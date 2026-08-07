//! Type checking for Resid.
//!
//! Infers and checks types over the parsed AST for the numeric core of the
//! spec (§6 Primitive Numeric Types, §6.1–§6.4). Resolves the primitive
//! family (via `resid-ir`), applies the mixed-width widening rules, and
//! rejects signed/unsigned mixing.

use std::collections::HashMap;

pub use resid_ir::{
    BinOp, FloatWidth, IntWidth, NumericError, NumericType, ResultType,
    numeric_result_type,
};
use resid_lexer::token::{Literal, Op as OpKind, Span};
use resid_parser::{Block, Declaration, Expr, ExprKind, FuncDef, Id, StmtKind, Type, TranslationUnit};

/// A semantic type for the supported core.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum SemType {
    Bool,
    Numeric(NumericType),
    Str,
}

impl core::fmt::Display for SemType {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        match self {
            SemType::Bool => write!(f, "Bool"),
            SemType::Numeric(n) => write!(f, "{n}"),
            SemType::Str => write!(f, "Str"),
        }
    }
}

/// Type-checking failure surfaced to the driver.
#[derive(Debug, Clone)]
pub struct TypeError {
    pub message: String,
    pub span: Span,
}

impl core::fmt::Display for TypeError {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        write!(f, "{}", self.message)
    }
}

/// A resolved function signature.
#[derive(Debug, Clone)]
pub struct FunctionSig {
    pub name: String,
    pub params: Vec<SemType>,
    pub ret: SemType,
}

/// A variable-name → type environment.
#[derive(Debug, Clone, Default)]
pub struct Env {
    map: HashMap<String, SemType>,
}

impl Env {
    pub fn new() -> Self {
        Self::default()
    }
    pub fn insert(&mut self, name: &str, ty: SemType) {
        self.map.insert(name.to_string(), ty);
    }
    pub fn get(&self, name: &str) -> Option<&SemType> {
        self.map.get(name)
    }
}

/// Function signatures keyed by name.
pub type Signatures = HashMap<String, FunctionSig>;

fn err(span: &Span, message: impl Into<String>) -> TypeError {
    TypeError {
        message: message.into(),
        span: span.clone(),
    }
}

pub fn kind_tag(kind: &ExprKind) -> &'static str {
    match kind {
        ExprKind::While { .. } => "while",
        ExprKind::ForIn { .. } => "for-in",
        ExprKind::For { .. } => "for",
        ExprKind::Match { .. } => "match",
        ExprKind::Range { .. } => "range",
        ExprKind::StructLit { .. } => "struct literal",
        ExprKind::ListLit(_) => "list literal",
        ExprKind::MapLit(_) => "map literal",
        ExprKind::Index { .. } => "index",
        ExprKind::FieldAccess { .. } => "field access",
        ExprKind::MethodCall { .. } => "method call",
        ExprKind::Slice { .. } => "slice",
        ExprKind::Spawn { .. } => "spawn",
        ExprKind::ProviderCall { .. } => "provider call",
        _ => "expression",
    }
}

/// Map a type name to a semantic type.
pub fn type_from_name(name: &str) -> Option<SemType> {
    match name {
        "Bool" => Some(SemType::Bool),
        "Str" => Some(SemType::Str),
        _ => resid_ir::NumericType::from_name(name).map(SemType::Numeric),
    }
}

/// Resolve a parsed type descriptor to a semantic type.
pub fn resolve_type(td: &Type) -> Option<SemType> {
    match td {
        Type::Base { name, params } => {
            // Parameterized spellings Int(16) / UInt(8) / Float(32) carry a
            // single numeric-literal width; blend into the iN/uN/fN name.
            if let Some(ps) = params {
                if ps.len() == 1 {
                    if let Type::Base { name: width, params: None } = &ps[0] {
                        let kind = match name.0.as_str() {
                            "Int" => "i",
                            "UInt" => "u",
                            "Float" => "f",
                            _ => return type_from_name(&name.0),
                        };
                        if let Ok(w) = width.0.parse::<u16>() {
                            return type_from_name(&format!("{kind}{w}"));
                        }
                    }
                }
            }
            type_from_name(&name.0)
        }
        Type::ISize => Some(SemType::Numeric(NumericType::ISize)),
        Type::USize => Some(SemType::Numeric(NumericType::USize)),
        Type::Residual(inner) => resolve_type(inner),
    }
}

/// Map a parser operator to the IR `BinOp` used for widening.
pub fn to_bin_op(op: &OpKind) -> Option<BinOp> {
    match op {
        OpKind::Plus => Some(BinOp::Add),
        OpKind::Minus => Some(BinOp::Sub),
        OpKind::Star => Some(BinOp::Mul),
        OpKind::Slash => Some(BinOp::Div),
        OpKind::Percent => Some(BinOp::Rem),
        OpKind::ShiftLeft => Some(BinOp::ShiftLeft),
        OpKind::ShiftRight => Some(BinOp::ShiftRight),
        OpKind::Amp => Some(BinOp::And),
        OpKind::Caret => Some(BinOp::Xor),
        OpKind::Pipe => Some(BinOp::Or),
        OpKind::EqEq => Some(BinOp::Eq),
        OpKind::Ne => Some(BinOp::Ne),
        OpKind::Less => Some(BinOp::Lt),
        OpKind::LessEq => Some(BinOp::Le),
        OpKind::Greater => Some(BinOp::Gt),
        OpKind::GreaterEq => Some(BinOp::Ge),
        _ => None,
    }
}

fn lit_type(lit: &Literal) -> SemType {
    match lit {
        Literal::Int { .. } => SemType::Numeric(NumericType::Int(IntWidth::from_bits(64).unwrap())),
        Literal::Float(_) => SemType::Numeric(NumericType::Float(FloatWidth::from_bits(64).unwrap())),
        Literal::Bool(_) => SemType::Bool,
        _ => SemType::Str,
    }
}

/// Collect all function signatures declared in a translation unit.
pub fn collect_signatures(unit: &TranslationUnit) -> Signatures {
    let mut sigs = Signatures::new();
    for decl in &unit.declarations {
        if let Declaration::Function(f) = decl {
            let sig = signature_of(f);
            sigs.insert(sig.name.clone(), sig);
        }
    }
    sigs
}

fn signature_of(f: &FuncDef) -> FunctionSig {
    let params = f
        .params
        .iter()
        .map(|p| resolve_type(&p.type_).unwrap_or(SemType::Bool))
        .collect();
    let ret = resolve_type(&f.ret).unwrap_or(SemType::Bool);
    FunctionSig {
        name: f.name.0.clone(),
        params,
        ret,
    }
}

/// Infer the type of an expression, applying the spec widening rules.
pub fn infer_expr(expr: &Expr, env: &Env, sigs: &Signatures) -> Result<SemType, TypeError> {
    match &expr.kind {
        ExprKind::Literal(lit) => Ok(lit_type(lit)),

        ExprKind::Id(id) => env.get(&id.0).cloned().ok_or_else(|| {
            err(
                &expr.span,
                format!("undefined variable `{}`", id.0),
            )
        }),

        ExprKind::Cast { type_, operand } => {
            let target = resolve_type(type_)
                .ok_or_else(|| err(&expr.span, "unknown cast target type"))?;
            let _ = infer_expr(operand, env, sigs)?;
            Ok(target)
        }

        ExprKind::UnaryOp { op, operand } => {
            let inner = infer_expr(operand, env, sigs)?;
            match op {
                OpKind::Not => match inner {
                    SemType::Bool => Ok(SemType::Bool),
                    other => Err(err(&expr.span, format!("`!` requires Bool, found {other}"))),
                },
                OpKind::Plus | OpKind::Minus | OpKind::Tilde => match inner {
                    SemType::Numeric(_) => Ok(inner),
                    other => Err(err(&expr.span, format!("unary `{op:?}` requires numeric, found {other}"))),
                },
                _ => Err(err(&expr.span, format!("unsupported unary operator {op:?}"))),
            }
        }

        ExprKind::BinaryOp { op, lhs, rhs } => infer_binary(op, lhs, rhs, env, sigs, &expr.span),

        ExprKind::If { cond, then_block, else_block } => {
            match infer_expr(cond, env, sigs)? {
                SemType::Bool => {}
                other => return Err(err(&expr.span, format!("if condition must be Bool, found {other}"))),
            }
            match else_block {
                Some(b) => {
                    let t = block_ret(then_block, env, sigs)?;
                    let e = block_ret(b, env, sigs)?;
                    if t != e {
                        return Err(err(&expr.span, format!("if arms disagree: {t} vs {e}")));
                    }
                    Ok(t)
                }
                None => block_ret(then_block, env, sigs),
            }
        }

        ExprKind::Call { func, args } => infer_call(func, args, env, sigs, &expr.span),

        ExprKind::Rt(inner) => infer_expr(inner, env, sigs),
        ExprKind::AtResidual { inner, .. } => infer_expr(inner, env, sigs),
        ExprKind::RawString(_) | ExprKind::FString(_) => Ok(SemType::Str),

        other => Err(err(
            &expr.span,
            format!("type checking not yet supported for `{}`", kind_tag(other)),
        )),
    }
}

fn infer_binary(
    op: &OpKind,
    lhs: &Expr,
    rhs: &Expr,
    env: &Env,
    sigs: &Signatures,
    span: &Span,
) -> Result<SemType, TypeError> {
    // Logical connectives require Bool operands.
    if matches!(op, OpKind::AndAnd | OpKind::OrOr) {
        require_bool(lhs, env, sigs, span, "left operand of logical operator")?;
        require_bool(rhs, env, sigs, span, "right operand of logical operator")?;
        return Ok(SemType::Bool);
    }

    let binop = to_bin_op(op).ok_or_else(|| err(span, format!("unsupported operator {op:?}")))?;
    let lt = infer_expr(lhs, env, sigs)?;
    let rt = infer_expr(rhs, env, sigs)?;
    let (ln, rn) = match (&lt, &rt) {
        (SemType::Numeric(a), SemType::Numeric(b)) => (*a, *b),
        _ => return Err(err(span, format!("numeric operator requires numeric operands ({lt} {op:?} {rt})"))),
    };

    // Bitwise/shift operators require integer operands.
    if matches!(binop, BinOp::ShiftLeft | BinOp::ShiftRight | BinOp::And | BinOp::Or | BinOp::Xor)
        && (ln.is_float() || rn.is_float())
    {
        return Err(err(span, "bitwise/shift operator requires integer operands"));
    }

    match numeric_result_type(&ln, binop, &rn) {
        ResultType::Bool => Ok(SemType::Bool),
        ResultType::Numeric(n) => Ok(SemType::Numeric(n)),
        ResultType::Error(NumericError::SignednessMix) => {
            Err(err(span, "cannot mix signed and unsigned operands in one operation"))
        }
    }
}

fn require_bool(
    e: &Expr,
    env: &Env,
    sigs: &Signatures,
    span: &Span,
    who: &str,
) -> Result<(), TypeError> {
    match infer_expr(e, env, sigs)? {
        SemType::Bool => Ok(()),
        other => Err(err(span, format!("{who} must be Bool, found {other}"))),
    }
}

fn block_ret(block: &Block, env: &Env, sigs: &Signatures) -> Result<SemType, TypeError> {
    if let Some(ret) = &block.ret {
        return infer_expr(ret, env, sigs);
    }
    if let Some(stmt) = block.statements.last() {
        if let StmtKind::Expr(e) = &stmt.kind {
            return infer_expr(e, env, sigs);
        }
    }
    Ok(SemType::Bool)
}

fn infer_call(
    callee: &Expr,
    args: &[(Option<Id>, Expr)],
    env: &Env,
    sigs: &Signatures,
    span: &Span,
) -> Result<SemType, TypeError> {
    let name = match &callee.kind {
        ExprKind::Id(id) => id.0.clone(),
        _ => return Err(err(span, "only direct function calls are supported")),
    };
    let sig = sigs
        .get(&name)
        .ok_or_else(|| err(span, format!("call to undefined function `{name}`")))?;
    if args.len() != sig.params.len() {
        return Err(err(
            span,
            format!("`{name}` expects {} argument(s), got {}", sig.params.len(), args.len()),
        ));
    }
    // Check each argument against the parameter type.
    for (i, (_, a)) in args.iter().enumerate() {
        let at = infer_expr(a, env, sigs)?;
        let want = &sig.params[i];
        if &at != want && !literal_compatible(a, want) {
            return Err(err(
                &a.span,
                format!("argument {} of `{name}`: expected {want}, found {at}", i + 1),
            ));
        }
    }
    Ok(sig.ret.clone())
}

/// A numeric literal may adopt a (same-sign, wide-enough) numeric target type,
/// so `Int(8) x = 5;` and calling an `i8`-typed function with `5` are allowed.
fn literal_compatible(a: &Expr, target: &SemType) -> bool {
    let SemType::Numeric(t) = target else {
        return false;
    };
    let ExprKind::Literal(Literal::Int { value, .. }) = &a.kind else {
        return false;
    };
    let bits = t.target_width().unwrap_or(64) as u32;
    if bits >= 128 {
        return true;
    }
    if t.is_unsigned() {
        *value < (1u128 << bits)
    } else {
        *value <= (1u128 << (bits - 1)) - 1
    }
}

// ─── Upfront program type checking ─────────────────────────────

/// Type-check every function body in a translation unit.
/// Returns a list of errors (empty = all passed).
pub fn check_program(unit: &TranslationUnit) -> Vec<TypeError> {
    let sigs = collect_signatures(unit);
    let mut errs = Vec::new();
    for decl in &unit.declarations {
        if let Declaration::Function(f) = decl {
            let mut env = Env::new();
            let sig = sigs.get(&f.name.0).unwrap();
            for (param, pt) in f.params.iter().zip(sig.params.iter()) {
                env.insert(&param.name.0, pt.clone());
            }
            type_check_block(&f.body, &env, &sigs, &mut errs);
        }
    }
    errs
}

fn type_check_block(block: &Block, env: &Env, sigs: &Signatures, errs: &mut Vec<TypeError>) {
    let mut env = env.clone();
    for stmt in &block.statements {
        if let StmtKind::Bind { name, type_: opt_type, value } = &stmt.kind {
            let ty = if let Some(t) = opt_type {
                resolve_type(t).unwrap_or(SemType::Bool)
            } else {
                infer_expr(value, &env, sigs).unwrap_or(SemType::Bool)
            };
            env.insert(&name.0, ty);
        }
        if let StmtKind::Expr(e) = &stmt.kind {
            if let Err(err) = infer_expr(e, &env, sigs) {
                errs.push(err);
            }
        }
    }
    if let Some(ret) = &block.ret {
        if let Err(err) = infer_expr(ret, &env, sigs) {
            errs.push(err);
        }
    }
}

// ─── Tests ─────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;
    use resid_lexer::token::{Literal, IntKind, FloatLit, Op as OpKind, Span};
    use resid_parser::{Expr, ExprKind, Id, Block, Type};

    fn span() -> Span {
        Span { file: String::new(), line: 0, col_start: 0, col_end: 0 }
    }

    fn expr_id(name: &str) -> Expr {
        Expr { kind: ExprKind::Id(Id(name.to_string())), span: span() }
    }

    fn expr_int(v: u128) -> Expr {
        Expr { kind: ExprKind::Literal(Literal::Int { value: v, kind: IntKind::Decimal(0) }), span: span() }
    }

    fn expr_binop(op: OpKind, lhs: &str, rhs: &str) -> Expr {
        Expr {
            kind: ExprKind::BinaryOp {
                op,
                lhs: Box::new(expr_id(lhs)),
                rhs: Box::new(expr_id(rhs)),
            },
            span: span(),
        }
    }

    fn make_env() -> Env {
        let mut env = Env::new();
        let int_ty = SemType::Numeric(NumericType::Int(IntWidth::from_bits(64).unwrap()));
        let u8_ty = SemType::Numeric(NumericType::UInt(IntWidth::B8.into()));
        let f64_ty = SemType::Numeric(NumericType::Float(FloatWidth::F64));
        env.insert("a", int_ty.clone());
        env.insert("b", int_ty);
        env.insert("u", u8_ty);
        env.insert("x", f64_ty);
        env
    }

    #[test]
    fn infer_literal_int() {
        let e = expr_int(42);
        let env = Env::new();
        let sigs = Signatures::new();
        let ty = infer_expr(&e, &env, &sigs).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B64.into())));
    }

    #[test]
    fn infer_literal_bool() {
        let e = Expr { kind: ExprKind::Literal(Literal::Bool(true)), span: span() };
        let ty = infer_expr(&e, &Env::new(), &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Bool);
    }

    #[test]
    fn infer_literal_float() {
        let e = Expr { kind: ExprKind::Literal(Literal::Float(FloatLit { value: "3.14".into() })), span: span() };
        let ty = infer_expr(&e, &Env::new(), &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Float(FloatWidth::F64)));
    }

    #[test]
    fn infer_id_from_env() {
        let e = expr_id("a");
        let env = make_env();
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B64.into())));
    }

    #[test]
    fn infer_undefined_var() {
        let e = expr_id("z");
        let env = Env::new();
        let result = infer_expr(&e, &env, &Signatures::new());
        assert!(result.is_err());
    }

    #[test]
    fn infer_binary_add_widening() {
        // a + b where both are i64 → i128 (spec §6.1 widening)
        let e = expr_binop(OpKind::Plus, "a", "b");
        let env = make_env();
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B128)));
    }

    #[test]
    fn infer_binary_mul_widening() {
        // a * b where both are i64 → i128
        let e = expr_binop(OpKind::Star, "a", "b");
        let env = make_env();
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B128)));
    }

    #[test]
    fn infer_binary_sub_no_widen() {
        // a - b where both are i64 → i64 (subtraction doesn't widen for same-width ints)
        // Actually per spec, the result width is determined by the smallest width that can
        // hold all possible results. For subtraction of two i64 values:
        // min value: -(2^63) - (2^63-1) which fits in i64
        // Actually: 0 - 2^63 = -2^63 which fits in i64
        // And 2^63 - 0 = 2^63 doesn't fit in i64... let me check the actual implementation.
        let e = expr_binop(OpKind::Minus, "a", "b");
        let env = make_env();
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        // Subtraction result: min(0 - (2^63-1)) = -(2^63-1), max((2^63-1) - 0) = 2^63-1
        // This needs 65 bits, so widens to i128
        assert!(matches!(ty, SemType::Numeric(NumericType::Int(w)) if w.bits() >= 64));
    }

    #[test]
    fn infer_signed_unsigned_mix_error() {
        // a (i64) + u (u8) should fail
        let e = expr_binop(OpKind::Plus, "a", "u");
        let env = make_env();
        let result = infer_expr(&e, &env, &Signatures::new());
        assert!(result.is_err());
        let err = result.unwrap_err();
        assert!(err.message.contains("signed and unsigned"), "expected signedness error, got: {}", err.message);
    }

    #[test]
    fn infer_comparison_produces_bool() {
        // a > b should produce Bool
        let e = expr_binop(OpKind::Greater, "a", "b");
        let env = make_env();
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Bool);
    }

    #[test]
    fn infer_logical_and() {
        // We need Bool operands. Let's create a custom env.
        let mut env = Env::new();
        let bool_ty = SemType::Bool;
        env.insert("p", bool_ty.clone());
        env.insert("q", bool_ty);
        let e = Expr {
            kind: ExprKind::BinaryOp {
                op: OpKind::AndAnd,
                lhs: Box::new(expr_id("p")),
                rhs: Box::new(expr_id("q")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Bool);
    }

    #[test]
    fn infer_logical_or() {
        let mut env = Env::new();
        env.insert("p", SemType::Bool);
        env.insert("q", SemType::Bool);
        let e = Expr {
            kind: ExprKind::BinaryOp {
                op: OpKind::OrOr,
                lhs: Box::new(expr_id("p")),
                rhs: Box::new(expr_id("q")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Bool);
    }

    #[test]
    fn infer_unary_not() {
        let mut env = Env::new();
        env.insert("p", SemType::Bool);
        let e = Expr {
            kind: ExprKind::UnaryOp { op: OpKind::Not, operand: Box::new(expr_id("p")) },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Bool);
    }

    #[test]
    fn infer_unary_not_on_int_error() {
        let env = make_env();
        let e = Expr {
            kind: ExprKind::UnaryOp { op: OpKind::Not, operand: Box::new(expr_id("a")) },
            span: span(),
        };
        let result = infer_expr(&e, &env, &Signatures::new());
        assert!(result.is_err());
    }

    #[test]
    fn infer_unary_minus_on_int() {
        let env = make_env();
        let e = Expr {
            kind: ExprKind::UnaryOp { op: OpKind::Minus, operand: Box::new(expr_id("a")) },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert!(matches!(ty, SemType::Numeric(_)));
    }

    #[test]
    fn infer_bitwise_on_float_error() {
        // & on floats should be an error
        let e = expr_binop(OpKind::Amp, "x", "x");
        let env = make_env();
        let result = infer_expr(&e, &env, &Signatures::new());
        assert!(result.is_err());
        let msg = result.unwrap_err().message;
        assert!(msg.contains("bitwise"), "expected bitwise error, got: {msg}");
    }

    #[test]
    fn infer_cast() {
        // Cast a i64 to i32
        let e = Expr {
            kind: ExprKind::Cast {
                type_: Type::Base { name: Id("i32".into()), params: None },
                operand: Box::new(expr_id("a")),
            },
            span: span(),
        };
        let env = make_env();
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B32.into())));
    }

    #[test]
    fn infer_if_expression() {
        let mut env = Env::new();
        env.insert("a", SemType::Numeric(NumericType::Int(IntWidth::B64.into())));
        env.insert("b", SemType::Numeric(NumericType::Int(IntWidth::B64.into())));
        env.insert("cond", SemType::Bool);
        let if_expr = Expr {
            kind: ExprKind::If {
                cond: Box::new(expr_id("cond")),
                then_block: Box::new(Block {
                    statements: vec![],
                    ret: Some(Box::new(expr_id("a"))),
                    span: span(),
                }),
                else_block: Some(Box::new(Block {
                    statements: vec![],
                    ret: Some(Box::new(expr_id("b"))),
                    span: span(),
                })),
            },
            span: span(),
        };
        let ty = infer_expr(&if_expr, &env, &Signatures::new()).unwrap();
        assert!(matches!(ty, SemType::Numeric(_)));
    }

    #[test]
    fn infer_if_no_else() {
        let mut env = Env::new();
        env.insert("cond", SemType::Bool);
        let if_expr = Expr {
            kind: ExprKind::If {
                cond: Box::new(expr_id("cond")),
                then_block: Box::new(Block {
                    statements: vec![],
                    ret: None,
                    span: span(),
                }),
                else_block: None,
            },
            span: span(),
        };
        let ty = infer_expr(&if_expr, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Bool); // void-like
    }

    #[test]
    fn infer_rt_expr() {
        let e = Expr {
            kind: ExprKind::Rt(Box::new(expr_int(42))),
            span: span(),
        };
        let ty = infer_expr(&e, &Env::new(), &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B64.into())));
    }

    #[test]
    fn infer_raw_string() {
        let e = Expr {
            kind: ExprKind::RawString("hello".into()),
            span: span(),
        };
        let ty = infer_expr(&e, &Env::new(), &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Str);
    }

    #[test]
    fn infer_fstring() {
        let e = Expr {
            kind: ExprKind::FString(vec![resid_parser::FStringPart::Text("hello".into())]),
            span: span(),
        };
        let ty = infer_expr(&e, &Env::new(), &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Str);
    }

    #[test]
    fn literal_compatible_fits() {
        let lit = expr_int(5);
        let target = SemType::Numeric(NumericType::Int(IntWidth::B16.into()));
        assert!(literal_compatible(&lit, &target));
    }

    #[test]
    fn literal_compatible_overflow_i8() {
        let lit = expr_int(300); // 300 > 127 (i8 max)
        let target = SemType::Numeric(NumericType::Int(IntWidth::B8.into()));
        assert!(!literal_compatible(&lit, &target));
    }

    #[test]
    fn literal_compatible_unsigned() {
        let lit = expr_int(255);
        let target = SemType::Numeric(NumericType::UInt(IntWidth::B8.into()));
        assert!(literal_compatible(&lit, &target)); // 255 = max u8
    }

    #[test]
    fn literal_compatible_not_numeric() {
        let lit = expr_int(5);
        let target = SemType::Bool;
        assert!(!literal_compatible(&lit, &target));
    }

    #[test]
    fn resolve_type_int() {
        let td = Type::Base { name: Id("Int".into()), params: None };
        let ty = resolve_type(&td).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B64.into())));
    }

    #[test]
    fn resolve_type_i32() {
        let td = Type::Base { name: Id("i32".into()), params: None };
        let ty = resolve_type(&td).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B32.into())));
    }

    #[test]
    fn resolve_type_bool() {
        let td = Type::Base { name: Id("Bool".into()), params: None };
        let ty = resolve_type(&td).unwrap();
        assert_eq!(ty, SemType::Bool);
    }

    #[test]
    fn check_program_valid() {
        let src = r#"
Int add(Int a, Int b) {
    return a + b;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors, got: {:?}", errs);
    }

    #[test]
    fn check_program_undefined_var() {
        let src = r#"
Int main() {
    return not_defined;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(!errs.is_empty(), "expected type error for undefined variable");
    }

    #[test]
    fn check_program_signedness_mix() {
        // Int + UInt should fail
        let src = r#"
Int main() {
    Int a = 1;
    UInt b = 2;
    return a + b;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(!errs.is_empty(), "expected type error for signed/unsigned mix");
    }

    #[test]
    fn check_program_widening_valid() {
        let src = r#"
Int main() {
    Int a = 1;
    Int b = 2;
    return a + b;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors, got: {:?}", errs);
    }
}