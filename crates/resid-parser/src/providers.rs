//! Provider-call collection: find every `provider.verb(...)` expression in a
//! translation unit so a build can enforce capability policy (spec §28.2,
//! §35) before code generation runs.

use crate::{Declaration, ExprKind, TranslationUnit};

/// One provider use site.
#[derive(Debug, Clone)]
pub struct ProviderUse {
    pub provider: String,
    pub verb: String,
    pub span: resid_lexer::token::Span,
}

/// Collect every provider call in the unit, in source order (imports merged
/// first, so dependency uses are reported before the root's own).
pub fn collect_provider_calls(unit: &TranslationUnit) -> Vec<ProviderUse> {
    let mut out = Vec::new();
    for d in &unit.declarations {
        if let Declaration::Function(f) = d {
            collect_block(&f.body, &mut out);
        }
    }
    out
}

fn collect_block(block: &crate::Block, out: &mut Vec<ProviderUse>) {
    for s in &block.statements {
        collect_stmt(s, out);
    }
    if let Some(tail) = &block.ret {
        walk(tail, out);
    }
}

fn collect_stmt(s: &crate::Stmt, out: &mut Vec<ProviderUse>) {
    match &s.kind {
        crate::StmtKind::Bind { value, .. } => walk(value, out),
        crate::StmtKind::Discard(e) => walk(e, out),
        crate::StmtKind::Destructure { source, .. } => walk(source, out),
        crate::StmtKind::Expr(e) => walk(e, out),
        crate::StmtKind::Return(Some(e)) => walk(e, out),
        _ => {}
    }
}

fn walk(expr: &crate::Expr, out: &mut Vec<ProviderUse>) {
    if let ExprKind::ProviderCall { provider, verb, .. } = &expr.kind {
        out.push(ProviderUse {
            provider: provider.0.clone(),
            verb: verb.0.clone(),
            span: expr.span.clone(),
        });
    }
    walk_children(expr, out);
}

fn walk_children(expr: &crate::Expr, out: &mut Vec<ProviderUse>) {
    use ExprKind::*;
    match &expr.kind {
        Id(_) | Literal(_) | Location | RawString(_) | ByteString(_) | Todo(_)
        | Unimplemented(_) => {}
        ComptimePrint(inner) => walk(inner, out),
        Rt(inner) | Known(inner) | RtKnown(inner) | EarlyReturn(inner) | Discard(inner) => {
            walk(inner, out)
        }
        UnaryOp { operand, .. } | Cast { operand, .. } => walk(operand, out),
        AtResidual { inner, .. } => walk(inner, out),
        BinaryOp { lhs, rhs, .. } => {
            walk(lhs, out);
            walk(rhs, out);
        }
        Call { func, args } => {
            walk(func, out);
            for (_, a) in args {
                walk(a, out);
            }
        }
        If { cond, then_block, else_block } => {
            walk(cond, out);
            collect_block(then_block, out);
            if let Some(eb) = else_block {
                collect_block(eb, out);
            }
        }
        While { cond, body } => {
            walk(cond, out);
            collect_block(body, out);
        }
        ForIn { collection, body, .. } => {
            walk(collection, out);
            collect_block(body, out);
        }
        For { init, cond, step, body } => {
            if let Some(s) = init {
                collect_stmt(s, out);
            }
            walk(cond, out);
            if let Some(s) = step {
                collect_stmt(s, out);
            }
            collect_block(body, out);
        }
        Match { scrutinee, arms } => {
            walk(scrutinee, out);
            for (_, e) in arms {
                walk(e, out);
            }
        }
        Spawn { body, .. } => collect_block(body, out),
        Assert { cond, message } | RtAssert { cond, message } => {
            walk(cond, out);
            walk(message, out);
        }
        StructLit { fields, .. } => {
            for (_, v) in fields {
                walk(v, out);
            }
        }
        ListLit(elems) => {
            for e in elems {
                walk(e, out);
            }
        }
        MapLit(pairs) => {
            for (k, v) in pairs {
                walk(k, out);
                walk(v, out);
            }
        }
        Range { start, end, .. } => {
            walk(start, out);
            walk(end, out);
        }
        FString(parts) => {
            for p in parts {
                if let crate::FStringPart::Expr(x) = p {
                    walk(x, out);
                }
            }
        }
        FieldAccess { target, .. } | Index { target, .. } => walk(target, out),
        Slice { target, range } => {
            walk(target, out);
            if let Some(s) = &range.start {
                walk(s, out);
            }
            if let Some(e2) = &range.end {
                walk(e2, out);
            }
        }
        MethodCall { target, args, .. } => {
            walk(target, out);
            for a in args {
                walk(a, out);
            }
        }
        ElseFallback { value, fallback } => {
            walk(value, out);
            collect_block(fallback, out);
        }
        With { bindings, body, .. } => {
            for b in bindings {
                walk(&b.init, out);
            }
            collect_block(body, out);
        }
        Using { value, .. } => walk(value, out),
        ProviderCall { args, .. } => {
            for a in args {
                walk(a, out);
            }
        }
        Destructure { .. } => {}
        IfLet { source, then_block, else_block, .. } => {
            walk(source, out);
            collect_block(then_block, out);
            if let Some(eb) = else_block {
                collect_block(eb, out);
            }
        }
        WhileLet { source, body, .. } => {
            walk(source, out);
            collect_block(body, out);
        }
    }
}
