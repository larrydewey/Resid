//! Comptime reduction of pure functions (§36).
//!
//! Given a subexpression whose evaluation is a compile-time constant, try to
//! reduce it to a value. Reduction covers integer/boolean/string constants,
//! arithmetic and comparisons, conditionals, local bindings, and calls to
//! other pure functions (including recursion). Any construct that cannot be
//! evaluated (effects, providers, match, list ops, unknown names, …) makes the
//! whole attempt fail — the caller then emits the runtime computation, so
//! reduction is always sound and purely an optimization / knowledge step.

use std::collections::HashMap;

use resid_lexer::token::{Literal, Op as OpKind};
use resid_parser::{Declaration, Expr, ExprKind, Id, Param, Stmt, StmtKind, TranslationUnit};

/// Budgets: beyond these, reduction gives up and runtime takes over.
const MAX_STEPS: u32 = 400_000;
const MAX_DEPTH: u32 = 256;

/// A compile-time-known value.
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum CValue {
    Int(i128),
    Bool(bool),
    Str(String),
}

impl CValue {
    pub fn display(&self) -> String {
        match self {
            CValue::Int(i) => i.to_string(),
            CValue::Bool(b) => b.to_string(),
            CValue::Str(s) => s.clone(),
        }
    }
}

struct Ctx<'a> {
    unit: &'a TranslationUnit,
    steps: u32,
    depth: u32,
    /// A `return` executed inside a nested block/expression; propagated out so
    /// `if (c) { return n; }` really aborts the enclosing (pure) function.
    pending: bool,
    pending_value: Option<CValue>,
}

impl<'a> Ctx<'a> {
    fn step(&mut self) -> bool {
        self.steps += 1;
        self.steps <= MAX_STEPS
    }

    fn eval(&mut self, expr: &Expr, env: &HashMap<String, CValue>) -> Option<CValue> {
        if !self.step() {
            return None;
        }
        if std::env::var("RDUMP").is_ok() {
            eprintln!("[step {}] {:?}", self.steps, expr.kind);
        }
        match &expr.kind {
            ExprKind::Literal(Literal::Int { value, .. }) => i128::try_from(*value).ok().map(CValue::Int),
            ExprKind::Literal(Literal::Bool(b)) => Some(CValue::Bool(*b)),
            ExprKind::Literal(Literal::Str(lit)) => Some(CValue::Str(lit.value.clone())),
            ExprKind::RawString(s) => Some(CValue::Str(s.clone())),
            ExprKind::Id(Id(n)) => env.get(n).cloned(),
            ExprKind::UnaryOp { op, operand } => match op {
                OpKind::Minus => Some(CValue::Int(self.eval(operand, env)?.as_int()?.wrapping_neg())),
                OpKind::Not => Some(CValue::Bool(!self.eval(operand, env)?.as_bool()?)),
                _ => None,
            },
            ExprKind::BinaryOp { op, lhs, rhs } => self.eval_binary(*op, lhs, rhs, env),
            ExprKind::If {
                cond,
                then_block,
                else_block,
            } => {
                if self.eval(cond, env)?.as_bool()? {
                    let v = self.eval_block(then_block, env, true);
                    if self.pending {
                        // Branch had an early return; leave pending set so the
                        // caller's statement loop can propagate it out of the
                        // enclosing block.
                        return v;
                    }
                    v
                } else {
                    match else_block {
                        Some(b) => {
                            let v = self.eval_block(b, env, true);
                            if self.pending {
                                return v;
                            }
                            v
                        }
                        None => Some(CValue::Bool(false)),
                    }
                }
            }
            ExprKind::Known(inner) | ExprKind::RtKnown(inner) => self.eval(inner, env),
            ExprKind::Call { func, args } => self.eval_call(func, args, env),
            _ => None,
        }
    }

    fn eval_binary(
        &mut self,
        op: OpKind,
        lhs: &Expr,
        rhs: &Expr,
        env: &HashMap<String, CValue>,
    ) -> Option<CValue> {
        match op {
            OpKind::AndAnd => {
                let a = self.eval(lhs, env)?.as_bool()?;
                Some(CValue::Bool(a && self.eval(rhs, env)?.as_bool()?))
            }
            OpKind::OrOr => {
                let a = self.eval(lhs, env)?.as_bool()?;
                Some(CValue::Bool(a || self.eval(rhs, env)?.as_bool()?))
            }
            OpKind::Plus => {
                let a = self.eval(lhs, env)?;
                let b = self.eval(rhs, env)?;
                match (a, b) {
                    (CValue::Int(x), CValue::Int(y)) => Some(CValue::Int(x.wrapping_add(y))),
                    (CValue::Str(s), CValue::Str(t)) => Some(CValue::Str(format!("{s}{t}"))),
                    _ => None,
                }
            }
            OpKind::Minus | OpKind::Star | OpKind::Slash | OpKind::Percent | OpKind::Less
            | OpKind::LessEq | OpKind::Greater | OpKind::GreaterEq | OpKind::EqEq | OpKind::Ne => {
                let a = self.eval(lhs, env)?.as_int()?;
                let b = self.eval(rhs, env)?.as_int()?;
                Some(match op {
                    OpKind::Minus => CValue::Int(a.wrapping_sub(b)),
                    OpKind::Star => CValue::Int(a.wrapping_mul(b)),
                    OpKind::Slash => CValue::Int(a.checked_div(b)?),
                    OpKind::Percent => CValue::Int(a.checked_rem(b)?),
                    OpKind::Less => CValue::Bool(a < b),
                    OpKind::LessEq => CValue::Bool(a <= b),
                    OpKind::Greater => CValue::Bool(a > b),
                    OpKind::GreaterEq => CValue::Bool(a >= b),
                    OpKind::EqEq => CValue::Bool(a == b),
                    OpKind::Ne => CValue::Bool(a != b),
                    _ => unreachable!(),
                })
            }
            _ => None,
        }
    }

    fn eval_stmt(&mut self, stmt: &Stmt, env: &mut HashMap<String, CValue>) -> Result<(), Option<CValue>> {
        match &stmt.kind {
            StmtKind::Bind { name, value, .. } => {
                let Some(v) = self.eval(value, env) else {
                    return Err(None);
                };
                env.insert(name.0.clone(), v);
                Ok(())
            }
            StmtKind::Expr(e) | StmtKind::Discard(e) => {
                if self.eval(e, env).is_none() {
                    return Err(None);
                }
                if self.pending {
                    let v = self.pending_value.take();
                    self.pending = false;
                    return Err(v);
                }
                Ok(())
            }
            StmtKind::Return(Some(e)) => {
                self.pending = true;
                self.pending_value = self.eval(e, env);
                Err(self.pending_value.clone())
            }
            StmtKind::Return(None) => {
                self.pending = true;
                self.pending_value = None;
                Err(None)
            }
            // Control-flow / destructure cannot be evaluated purely.
            StmtKind::Destructure { .. } | StmtKind::Break | StmtKind::Continue => Err(None),
        }
    }

    fn eval_block(
        &mut self,
        block: &resid_parser::Block,
        env: &HashMap<String, CValue>,
        capture_tail: bool,
    ) -> Option<CValue> {
        let mut local = env.clone();
        for stmt in &block.statements {
            match self.eval_stmt(stmt, &mut local) {
                Ok(()) => {}
                Err(v) => return v,
            }
            if self.pending {
                let v = self.pending_value.take();
                self.pending = false;
                return v;
            }
        }
        if let Some(ret) = &block.ret {
            // block.ret always represents an explicit `return` statement extracted
            // by parse_block (expression blocks have block.ret = None).  Propagate
            // it via pending so the caller can distinguish a real early return from
            // an expression-block tail value.
            let v = self.eval(ret, &local);
            self.pending = true;
            self.pending_value = v.clone();
            v
        } else if capture_tail {
            // Mimic codegen's tail capture: if the last statement is an expression
            // statement, treat it as the block's value.
            block
                .statements
                .last()
                .and_then(|s| match &s.kind {
                    StmtKind::Expr(e) => Some(self.eval(e, &local)),
                    _ => None,
                })
                .flatten()
        } else {
            None
        }
    }

    fn bind_args(
        &mut self,
        params: &[Param],
        args: &[(Option<Id>, Expr)],
        env: &mut HashMap<String, CValue>,
    ) -> Option<bool> {
        // Every argument/default expression must be evaluated against the
        // caller's scope as it stood *before* this call's own parameters
        // started binding — not against `env` as it's progressively
        // overwritten below. Otherwise an argument expression referencing
        // an identifier that happens to share a name with an earlier
        // parameter of the callee reads that just-bound parameter value
        // instead of the caller's variable (or correctly failing to
        // reduce), silently folding a runtime call to the wrong constant.
        let caller_env = env.clone();
        let mut bound: HashMap<String, bool> = HashMap::new();
        for (name_opt, arg) in args {
            let v = self.eval(arg, &caller_env)?;
            let name = match name_opt {
                Some(id) => id.0.clone(),
                None => {

                    params
                        .iter()
                        .position(|p| !bound.contains_key(&p.name.0))
                        .map(|i| params[i].name.0.clone())?
                }
            };
            if !params.iter().any(|p| p.name.0 == name) {
                return None;
            }
            env.insert(name.clone(), v);
            bound.insert(name, true);
        }
        for p in params {
            if !bound.contains_key(&p.name.0) {
                let dv = p.default.as_ref().and_then(|d| self.eval(d, &caller_env))?;
                env.insert(p.name.0.clone(), dv);
            }
        }
        Some(true)
    }

    fn eval_call(
        &mut self,
        func: &Expr,
        args: &[(Option<Id>, Expr)],
        env: &HashMap<String, CValue>,
    ) -> Option<CValue> {
        let ExprKind::Id(Id(name)) = &func.kind else {
            return None;
        };
        if self.depth > MAX_DEPTH {
            return None;
        }
        // Use flatten_unit to handle sandbox-wrapped functions consistently.
        let flat = flatten_unit(self.unit);
        let f = flat
            .iter()
            .find_map(|d| match d {
                Declaration::Function(f) if f.name.0 == *name => Some(f),
                _ => None,
            })?;
        let mut local = env.clone();
        if self.bind_args(&f.params, args, &mut local).is_none() {
            eprintln!("[reduce] bind_args failed for {name}");
            return None;
        }
        self.depth += 1;
        let v = self.eval_block(&f.body, &local, true);
        eprintln!("[reduce] {name} -> {:?}", v);
        self.depth -= 1;
        // A callee's internal `return` must not abort the caller's reduction.
        self.pending = false;
        self.pending_value = None;
        v
    }
}

impl CValue {
    fn as_int(&self) -> Option<i128> {
        match self {
            CValue::Int(i) => Some(*i),
            _ => None,
        }
    }
    fn as_bool(&self) -> Option<bool> {
        match self {
            CValue::Bool(b) => Some(*b),
            _ => None,
        }
    }
}

/// Try to reduce `expr` to a compile-time value.
pub fn reduce_expr(unit: &TranslationUnit, expr: &Expr) -> Option<CValue> {
    let mut ctx = Ctx {
        unit,
        steps: 0,
        depth: 0,
        pending: false,
        pending_value: None,
    };
    ctx.eval(expr, &HashMap::new())
}

/// Try to reduce a call `func(args…)` to a compile-time value.
pub fn reduce_call(unit: &TranslationUnit, func: &Expr, args: &[(Option<Id>, Expr)]) -> Option<CValue> {
    let ExprKind::Id(Id(name)) = &func.kind else {
        return None;
    };
    // Only user-defined pure functions are reducible; builtins/effects aren't.
    // Use flatten_unit to handle sandbox-wrapped functions.
    let flat = flatten_unit(unit);
    if !flat
        .iter()
        .any(|d| matches!(d, Declaration::Function(f) if f.name.0 == *name))
    {
        return None;
    }
    let mut ctx = Ctx {
        unit,
        steps: 0,
        depth: 0,
        pending: false,
        pending_value: None,
    };
    let mut env = HashMap::new();
    ctx.bind_args(
        flat.iter()
            .find_map(|d| match d {
                Declaration::Function(f) if f.name.0 == *name => Some(f),
                _ => None,
            })?
            .params
            .as_slice(),
        args,
        &mut env,
    )?;
    let f = flat
        .iter()
        .find_map(|d| match d {
            Declaration::Function(f) if f.name.0 == *name => Some(f),
            _ => None,
        })?;
    ctx.eval_block(&f.body, &env, true)
}

fn flatten_unit(unit: &TranslationUnit) -> Vec<Declaration> {
    unit.declarations
        .iter()
        .flat_map(|d| match d {
            Declaration::Sandbox(s) => {
                let ceiling = &s.capabilities;
                s.body.iter().map(|child| {
                    let mut c = child.clone();
                    if let Declaration::Function(f) = &mut c
                        && f.sandbox_ceiling.is_empty() && !ceiling.is_empty() {
                            f.sandbox_ceiling = ceiling.clone();
                        }
                    c
                }).collect::<Vec<_>>()
            }
            other => vec![other.clone()],
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;
    use resid_parser::{Parser};

    fn unit(src: &str) -> TranslationUnit {
        let (unit, errs) = Parser::parse("reduce.resid", src);
        assert!(errs.is_empty(), "parse errors: {errs:?}");
        unit
    }

    fn call(u: &TranslationUnit, expr: &str) -> Option<CValue> {
        let src = format!("Int main() {{ return {expr}; }}");
        let (u2, errs) = Parser::parse("reduce.resid", &src);
        assert!(errs.is_empty(), "{errs:?}");
        let top: &Expr = match &u2.declarations[0] {
            Declaration::Function(f) => f.body.ret.as_ref().expect("ret"),
            _ => panic!(),
        };
        reduce_expr(u, top)
    }

    #[test]
    fn probe_primitive() {
        let u = unit(
            r#"
Int main() {
    if (true) {
        return 5;
    }
    return 9;
}
Int one() {
    return 1;
}
"#,
        );
        // An early `return` inside an if-branch terminates the enclosing
        // function: `main()` returns 5, not the trailing 9.
        assert_eq!(call(&u, "main()"), Some(CValue::Int(5)));
        assert_eq!(call(&u, "one()"), Some(CValue::Int(1)));
    }

    #[test]
    fn reduces_recursive_fib() {
        let u = unit(
            r#"
Int main() {
    Int r = fib(10);
    println(IntToString(r));
    return r;
}
Int fib(Int n) {
    return if (n < 2) { n } else { fib(n - 1) + fib(n - 2) };
}
"#,
        );
        assert_eq!(call(&u, "fib(0)"), Some(CValue::Int(0)));
        assert_eq!(call(&u, "fib(1)"), Some(CValue::Int(1)));
        assert_eq!(call(&u, "fib(2)"), Some(CValue::Int(1)));
        assert_eq!(call(&u, "fib(10)"), Some(CValue::Int(55)));
    }

    #[test]
    fn reduces_factorial_and_compound() {
        let u = unit(
            r#"
Int fac(Int n) {
    return if (n <= 1) { 1 } else { n * fac(n - 1) };
}
Int main() {
    return fac(5) + 2;
}
"#,
        );
        assert_eq!(call(&u, "fac(5) + 2"), Some(CValue::Int(122)));
    }

    #[test]
    fn reduces_bool_and_str_pure_fns() {
        let u = unit(
            r#"
Bool ispos(Int v) {
    return v > 0;
}
Str greet(Str who) {
    return "hi " + who;
}
Int main() {
    return 0;
}
"#,
        );
        assert_eq!(call(&u, "ispos(7)"), Some(CValue::Bool(true)));
        assert_eq!(call(&u, "ispos(-2)"), Some(CValue::Bool(false)));
        assert_eq!(
            call(&u, "greet(\"bob\")"),
            Some(CValue::Str("hi bob".to_string()))
        );
    }

    #[test]
    fn no_reduction_for_effects_or_unknown() {
        let u = unit(
            r#"
Int side() {
    println("bang");
    return 1;
}
Int main() {
    return side();
}
"#,
        );
        assert_eq!(call(&u, "side()"), None);
        assert_eq!(call(&u, "no_such_fn(1)"), None);
    }

    #[test]
    fn deep_recursion_skips_reduction_within_budget_soundness() {
        // Over the step budget → None (runtime path), never a wrong answer.
        let u = unit(
            r#"
Int count(Int n) {
    return if (n == 0) { 0 } else { count(n - 1) };
}
Int main() {
    return count(1000000);
}
"#,
        );
        assert_eq!(call(&u, "count(1000000)"), None);
    }

    #[test]
    fn negative_constant_reduces() {
        let u = unit(
            r#"
Int neg(Int x) {
    return -x;
}
Int main() {
    return neg(5);
}
"#,
        );
        assert_eq!(call(&u, "neg(5)"), Some(CValue::Int(-5)));
    }
}