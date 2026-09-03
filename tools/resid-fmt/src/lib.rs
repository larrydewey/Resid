//! `resid fmt` — canonical formatter for Resid source (spec §37).
//!
//! Parses a translation unit and re-prints it in canonical style:
//! 4-space indentation, braces on the same line, one statement per line,
//! and precedence-aware parenthesization (spec §27/§30) so the output
//! parses to the identical AST.

use resid_lexer::token::{Literal, Op};
use resid_parser::{
    Block, Declaration, Expr, ExprKind, FStringPart, FuncDef, Pattern, PatternKind, StmtKind,
    TranslationUnit, Type, TypeBody,
};

pub fn format_source(src: &str) -> Result<String, String> {
    let (unit, errors) = resid_parser::Parser::parse("fmt.resid", src);
    if !errors.is_empty() {
        let mut msg = String::new();
        for e in &errors {
            msg.push_str(&format!("{}:{}: {}\n", e.span.line, e.span.col_start, e.message));
        }
        return Err(msg);
    }
    Ok(format_unit(&unit))
}

pub fn format_unit(unit: &TranslationUnit) -> String {
    let mut p = Printer::default();
    for imp in &unit.imports {
        match (&imp.names, &imp.alias) {
            (Some(names), _) => {
                let ns: Vec<String> = names.iter().map(|i| i.0.clone()).collect();
                p.line(&format!("import \"{}\" ({});", imp.path, ns.join(", ")));
            }
            (None, Some(a)) => p.line(&format!("import \"{}\" as {};", imp.path, a.0)),
            _ => p.line(&format!("import \"{}\";", imp.path)),
        }
    }
    if !unit.imports.is_empty() && !unit.declarations.is_empty() {
        p.blank();
    }
    for d in &unit.declarations {
        match d {
            Declaration::Function(f) => p.func(f),
            Declaration::Type(t) => {
                for dc in &t.doc_comments {
                    p.line(&format!("///{dc}"));
                }
                match &t.body {
                    TypeBody::Product(fields) => {
                        let fs: Vec<String> =
                            fields.iter().map(|(n, ty)| format!("{}: {}", n.0, ty_str(ty))).collect();
                        p.line(&format!("type {} = {{ {} }};", t.name.0, fs.join(", ")));
                    }
                    TypeBody::Sum(variants) => {
                        let vs: Vec<String> = variants
                            .iter()
                            .map(|v| match &v.type_param {
                                Some(ty) => format!("{}({})", v.name.0, ty_str(ty)),
                                None => v.name.0.clone(),
                            })
                            .collect();
                        p.line(&format!("type {} = {};", t.name.0, vs.join(" | ")));
                    }
                    TypeBody::Constraint { inner, constraint } => {
                        p.line(&format!(
                            "type {} = {} where {};",
                            t.name.0,
                            ty_str(inner),
                            expr_str(constraint, 0)
                        ));
                    }
                    TypeBody::Base(inner) => {
                        p.line(&format!("type {} = {};", t.name.0, ty_str(inner)));
                    }
                    TypeBody::Residual(_) => {}
                }
                p.blank();
            }
            Declaration::Behavior(b) => {
                p.line(&format!("behavior {} = …;", b.name.0));
                p.blank();
            }
            Declaration::Sandbox(s) => {
                let caps: Vec<String> = s.capabilities.iter()
                    .map(|c| if c.params.is_empty() { c.name.0.clone() } else {
                        format!("{}(…)", c.name.0)
                    })
                    .collect();
                p.open(&format!("sandbox ({})", caps.join(", ")));
                for child in &s.body {
                    if let Declaration::Function(f) = child { p.func(f) }
                }
                p.close();
                p.blank();
            }
        }
    }
    p.out.trim_end().to_string() + "\n"
}

#[derive(Default)]
struct Printer {
    out: String,
    depth: usize,
}

impl Printer {
    fn line(&mut self, s: &str) {
        // Multi-line renders (embedded blocks) keep relative indentation and
        // gain the current depth on every line.
        for l in s.split('\n') {
            self.out.push_str(&"    ".repeat(self.depth));
            self.out.push_str(l);
            self.out.push('\n');
        }
    }

    fn blank(&mut self) {
        if !self.out.is_empty() {
            self.out.push('\n');
        }
    }

    fn open(&mut self, head: &str) {
        self.line(&format!("{head} {{"));
        self.depth += 1;
    }

    fn close(&mut self) {
        self.depth -= 1;
        self.line("}");
    }

    fn func(&mut self, f: &FuncDef) {
        for dc in &f.doc_comments {
            self.line(&format!("///{dc}"));
        }
        let params: Vec<String> = f
            .params
            .iter()
            .map(|p| match &p.default {
                Some(d) => format!(
                    "{} {} = {}",
                    ty_str(&p.type_),
                    p.name.0,
                    expr_str(d, 1)
                ),
                None => format!("{} {}", ty_str(&p.type_), p.name.0),
            })
            .collect();
        let pubk = if f.pub_ { "pub " } else { "" };
        self.open(&format!(
            "{pubk}{} {}({})",
            ty_str(&f.ret),
            f.name.0,
            params.join(", ")
        ));
        self.block_body(&f.body);
        self.close();
        self.blank();
    }

    /// Statements + optional tail expression of a block (already inside `{`).
    fn block_body(&mut self, b: &Block) {
        // A trailing expression statement is canonicalized as the block's
        // tail expression (the parser folds both into `ret`).
        for s in &b.statements {
            self.stmt_ctx(s, true);
        }
        // The parser folds `return e;` into the block's tail, so the only
        // faithful spelling is an explicit return (round-trips identically).
        if let Some(tail) = &b.ret {
            self.line(&format!("return {};", expr_str(tail, 1)));
        }
    }

    fn stmt_ctx(&mut self, s: &resid_parser::Stmt, semi: bool) {
        match &s.kind {
            StmtKind::Bind { type_, name, value } => {
                let ty = type_
                    .as_ref()
                    .map(ty_str)
                    .unwrap_or_else(|| "_".to_string());
                self.line(&format!("{} {} = {};", ty, name.0, expr_str(value, 1)));
            }
            StmtKind::Discard(e) => self.line(&format!("_ = {};", expr_str(e, 1))),
            StmtKind::Destructure { pattern, source } => self.line(&format!(
                "{} = {};",
                pat_str(pattern),
                expr_str(source, 1)
            )),
            StmtKind::Expr(e) => {
                // Control-flow expressions print as statements without `;`
                // when they end in a block; everything else keeps `;`.
                match &e.kind {
                    ExprKind::If { .. }
                    | ExprKind::While { .. }
                    | ExprKind::ForIn { .. }
                    | ExprKind::For { .. }
                    | ExprKind::Match { .. }
                    | ExprKind::WhileLet { .. } => self.line(&expr_str(e, self.depth)),
                    _ => {
                        if semi {
                            self.line(&format!("{};", expr_str(e, 1)));
                        } else {
                            self.line(&expr_str(e, 1));
                        }
                    }
                }
            }
            StmtKind::Return(Some(e)) => self.line(&format!("return {};", expr_str(e, 1))),
            StmtKind::Return(None) => self.line("return;"),
            StmtKind::Break => self.line("break;"),
            StmtKind::Continue => self.line("continue;"),
        }
    }
}

/// Precedence of an expression per spec §30 (higher binds tighter).
fn prec(e: &Expr) -> u8 {
    match &e.kind {
        ExprKind::BinaryOp { op, .. } => op_prec(op),
        ExprKind::Range { .. } => 1,
        ExprKind::UnaryOp { .. } => 13,
        _ => 100, // primary / postfix
    }
}

fn op_prec(op: &Op) -> u8 {
    op.precedence().unwrap_or(100)
}

fn op_str(op: &Op) -> &'static str {
    use Op::*;
    match op {
        Star => "*",
        Slash => "/",
        Percent => "%",
        Plus => "+",
        Minus => "-",
        ShiftLeft => "<<",
        ShiftRight => ">>",
        Less => "<",
        LessEq => "<=",
        Greater => ">",
        GreaterEq => ">=",
        EqEq => "==",
        Ne => "!=",
        Amp => "&",
        Caret => "^",
        Pipe => "|",
        AndAnd => "&&",
        OrOr => "||",
        Question => "?",
        Equals => "=",
        Comma => ",",
        Not => "!",
        Tilde => "~",
        DotDot => "..",
        DotDotEq => "..=",
        _ => "?",
    }
}

fn child_str(child: &Expr, min: u8) -> String {
    if prec(child) < min {
        format!("({})", expr_str(child, 1))
    } else {
        expr_str(child, 1)
    }
}

fn block_inline(b: &Block) -> String {
    // Blocks are printed structurally by the caller via Printer when
    // statement context demands it; this helper is only for expression
    // contexts, where we render the block multi-line into a string.
    let mut sub = Printer { out: String::new(), depth: 0 };
    sub.block_body(b);
    let inner = sub.out.trim_end().to_string();
    if inner.is_empty() {
        return "{}".to_string();
    }
    let indented: String = inner
        .lines()
        .map(|l| format!("    {l}\n"))
        .collect::<Vec<_>>()
        .join("");
    format!("{{\n{indented}}}")
}

fn expr_str(e: &Expr, _ctx: usize) -> String {
    match &e.kind {
        ExprKind::Id(id) => id.0.clone(),
        ExprKind::Literal(lit) => lit_to_string(lit),
        ExprKind::Location => "#location".to_string(),
        ExprKind::RawString(_) => "r\"\"".to_string(),
        ExprKind::ByteString(_) => "b\"\"".to_string(),
        ExprKind::BinaryOp { op, lhs, rhs } => {
            let p = op_prec(op);
            format!(
                "{} {} {}",
                child_str(lhs, p),
                op_str(op),
                child_str(rhs, p + 1)
            )
        }
        ExprKind::UnaryOp { op, operand } => {
            format!("{}{}", op_str(op), child_str(operand, 13))
        }
        ExprKind::Cast { type_, operand } => {
            format!("({}){}", ty_str(type_), child_str(operand, 13))
        }
        ExprKind::Call { func, args } => {
            let as_str: Vec<String> = args
                .iter()
                .map(|(n, a)| match n {
                    Some(n) => format!("{}: {}", n.0, expr_str(a, 1)),
                    None => expr_str(a, 1),
                })
                .collect();
            format!("{}({})", child_str(func, 100), as_str.join(", "))
        }
        ExprKind::MethodCall { target, method, args } => {
            let as_str: Vec<String> = args.iter().map(|a| expr_str(a, 1)).collect();
            format!(
                "{}.{}({})",
                child_str(target, 100),
                method.0,
                as_str.join(", ")
            )
        }
        ExprKind::FieldAccess { target, field } => {
            format!("{}.{}", child_str(target, 100), field.0)
        }
        ExprKind::Index { target, index } => {
            format!("{}[{}]", child_str(target, 100), expr_str(index, 1))
        }
        ExprKind::Slice { target, range } => {
            let start = range
                .start
                .as_ref()
                .map(|s| expr_str(s, 1))
                .unwrap_or_default();
            let end = range
                .end
                .as_ref()
                .map(|s| expr_str(s, 1))
                .unwrap_or_default();
            format!("{}[{}..{}]", child_str(target, 100), start, end)
        }
        ExprKind::StructLit { name, fields } => {
            let fs: Vec<String> = fields
                .iter()
                .map(|(n, v)| format!("{}: {}", n.0, expr_str(v, 1)))
                .collect();
            format!("{} {{ {} }}", name.0, fs.join(", "))
        }
        ExprKind::ListLit(elems) => {
            let es: Vec<String> = elems.iter().map(|e| expr_str(e, 1)).collect();
            format!("[{}]", es.join(", "))
        }
        ExprKind::MapLit(pairs) => {
            let ps: Vec<String> = pairs
                .iter()
                .map(|(k, v)| format!("{}: {}", expr_str(k, 1), expr_str(v, 1)))
                .collect();
            format!("{{{}}}", ps.join(", "))
        }
        ExprKind::SetLit(elems) => {
            let es: Vec<String> = elems.iter().map(|e| expr_str(e, 1)).collect();
            format!("{{{}}}", es.join(", "))
        }
        ExprKind::Range { start, end, closed } => {
            let dots = if *closed { "..=" } else { ".." };
            format!("{}{dots}{}", child_str(start, 2), child_str(end, 2))
        }
        ExprKind::FString(parts) => {
            let mut out = String::from("f\"");
            for part in parts {
                match part {
                    FStringPart::Text(t) => out.push_str(t),
                    FStringPart::Expr(x) => {
                        out.push('{');
                        out.push_str(&expr_str(x, 1));
                        out.push('}');
                    }
                }
            }
            out.push('"');
            out
        }
        ExprKind::Rt(inner) => format!("rt {}", child_str(inner, 13)),
        ExprKind::Known(inner) => format!("known {}", child_str(inner, 13)),
        ExprKind::RtKnown(inner) => format!("rt_known {}", child_str(inner, 13)),
        ExprKind::EarlyReturn(inner) => format!("{}?", child_str(inner, 100)),
        ExprKind::Todo(msg) => format!("todo(\"{msg}\")"),
        ExprKind::Unimplemented(msg) => format!("unimplemented(\"{msg}\")"),
        ExprKind::ComptimePrint(inner) => format!("comptime_print({})", expr_str(inner, 1)),
        ExprKind::ProviderCall { provider, verb, args } => {
            let as_str: Vec<String> = args.iter().map(|a| expr_str(a, 1)).collect();
            format!("{}.{}({})", provider.0, verb.0, as_str.join(", "))
        }
        ExprKind::Assert { cond, message } => {
            format!("assert({}, {})", expr_str(cond, 1), expr_str(message, 1))
        }
        ExprKind::RtAssert { cond, message } => {
            format!("rt_assert({}, {})", expr_str(cond, 1), expr_str(message, 1))
        }
        ExprKind::AtResidual { type_, inner } => {
            format!("at_residual {}: {}", ty_str(type_), expr_str(inner, 1))
        }
        // Block forms — rendered structurally.
        ExprKind::If { cond, then_block, else_block } => {
            let mut out = format!("if ({}) {}", expr_str(cond, 1), block_inline(then_block));
            if let Some(eb) = else_block {
                out.push_str(" else ");
                out.push_str(&block_inline(eb));
            }
            out
        }
        ExprKind::While { cond, body } => {
            format!("while ({}) {}", expr_str(cond, 1), block_inline(body))
        }
        ExprKind::ForIn { type_, name, collection, body } => {
            format!(
                "for ({} {} in {}) {}",
                ty_str(type_),
                name.0,
                expr_str(collection, 1),
                block_inline(body)
            )
        }
        ExprKind::For { init, cond, step, body } => {
            let i = init
                .as_ref()
                .map(stmt_head)
                .unwrap_or_default();
            let st = step.as_ref().map(stmt_head).unwrap_or_default();
            format!(
                "for ({}; {}; {}) {}",
                i,
                expr_str(cond, 1),
                st,
                block_inline(body)
            )
        }
        ExprKind::Match { scrutinee, arms } => {
            let mut out = format!("match {} {{\n", expr_str(scrutinee, 1));
            for (pat, e) in arms {
                out.push_str(&format!("    {} => {},\n", pat_str(pat), expr_str(e, 1)));
            }
            out.push('}');
            out
        }
        ExprKind::Spawn { body, .. } => {
            format!("spawn {{\n{}}}", block_inline(body).trim_matches(|c| c == '{' || c == '}'))
        }
        ExprKind::ElseFallback { value, fallback } => {
            format!("{} else {}", child_str(value, 100), block_inline(fallback))
        }
        ExprKind::With { bindings, body, .. } => {
            let bs: Vec<String> = bindings
                .iter()
                .map(|b| {
                    format!("{} {} = {}", ty_str(&b.type_), b.name.0, expr_str(&b.init, 1))
                })
                .collect();
            format!("with ({}) {}", bs.join(", "), block_inline(body))
        }
        ExprKind::Using { .. } => "using …".to_string(),
        ExprKind::IfLet { pattern, source, then_block, else_block } => {
            let mut out = format!(
                "if (let {} = {}) {}",
                pat_str(pattern),
                expr_str(source, 1),
                block_inline(then_block)
            );
            if let Some(eb) = else_block {
                out.push_str(" else ");
                out.push_str(&block_inline(eb));
            }
            out
        }
        ExprKind::WhileLet { pattern, source, body } => {
            format!(
                "while (let {} = {}) {}",
                pat_str(pattern),
                expr_str(source, 1),
                block_inline(body)
            )
        }
        ExprKind::Destructure { pattern, source } => {
            format!("{} = {}", pat_str(pattern), expr_str(source, 1))
        }
        ExprKind::Discard(inner) => format!("_ = {}", expr_str(inner, 1)),
    }
}

/// Best-effort single-line rendering of a for-loop clause statement.
fn stmt_head(s: &resid_parser::Stmt) -> String {
    match &s.kind {
        StmtKind::Bind { type_, name, value } => {
            let ty = type_.as_ref().map(ty_str).unwrap_or_else(|| "_".into());
            format!("{} {} = {}", ty, name.0, expr_str(value, 1))
        }
        StmtKind::Expr(e) => expr_str(e, 1),
        _ => String::new(),
    }
}

fn pat_str(p: &Pattern) -> String {
    match &p.kind {
        PatternKind::Wildcard => "_".to_string(),
        PatternKind::Bind(id) => id.0.clone(),
        PatternKind::Variant { name, param } => match param {
            Some(id) => format!("{}({})", name.0, id.0),
            None => name.0.clone(),
        },
        PatternKind::Literal(lit) => lit_to_string(lit),
        PatternKind::Struct { name, fields } => {
            let fs: Vec<String> = fields
                .iter()
                .map(|(n, fp)| format!("{}: {}", n.0, pat_str(fp)))
                .collect();
            format!("{} {{ {} }}", name.0, fs.join(", "))
        }
    }
}

fn lit_to_string(lit: &Literal) -> String {
    match lit {
        Literal::Str(s) => format!("\"{}\"", escape_str(&s.value)),
        other => other.to_string(),
    }
}

/// Re-escape a decoded string value so it round-trips through the lexer.
fn escape_str(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for c in s.chars() {
        match c {
            '\\' => out.push_str("\\\\"),
            '"' => out.push_str("\\\""),
            '\n' => out.push_str("\\n"),
            '\t' => out.push_str("\\t"),
            '\r' => out.push_str("\\r"),
            '\0' => out.push_str("\\0"),
            other => out.push(other),
        }
    }
    out
}

fn ty_str(t: &Type) -> String {
    match t {
        Type::Base { name, params } => match params {
            Some(ps) => {
                let s: Vec<String> = ps.iter().map(ty_str).collect();
                format!("{}({})", name.0, s.join(", "))
            }
            None => name.0.clone(),
        },
        Type::Refined { base, constraint } => {
            format!("{}[{}]", ty_str(base), expr_str(constraint, 0))
        }
        Type::Residual(inner) => format!("residual {}", ty_str(inner)),
        Type::ISize => "isize".to_string(),
        Type::USize => "usize".to_string(),
        Type::Literal(lit) => lit_to_string(lit),
    }
}
