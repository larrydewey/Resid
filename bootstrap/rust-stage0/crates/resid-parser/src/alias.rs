//! Alias-import rewriting: turn qualified references (`U.f`, `U.CONST`)
//! into plain idents bound to the aliased unit's renamed declarations.
//!
//! The resolver renames each aliased unit's exported declaration `x` to
//! `Alias.x` and rewrites the importing file's expressions:
//!   - `MethodCall { target: Id(A), method: m, .. }` → `Id("A.m")`
//!   - `FieldAccess { target: Id(A), field: x }`     → `Id("A.x")`
//!     when `A` is an alias and the member exists. Struct-literal names,
//!     type spellings, and match patterns are NOT rewritten in v1 (documented
//!     limitation); a bare alias reference errors later as an unknown variable.

use std::collections::HashMap;

use crate::{Expr, ExprKind, Pattern, PatternKind, StmtKind};

/// alias → { original exported name → rewritten name }.
#[derive(Debug, Default)]
pub struct AliasMap {
    map: HashMap<String, HashMap<String, String>>,
}

impl AliasMap {
    pub fn new() -> AliasMap {
        AliasMap { map: HashMap::new() }
    }

    pub fn add(&mut self, alias: &str, orig: &str) {
        self.map
            .entry(alias.to_string())
            .or_default()
            .insert(orig.to_string(), format!("{alias}.{orig}"));
    }

    fn lookup(&self, alias: &str, member: &str) -> Option<&str> {
        self.map.get(alias)?.get(member).map(|s| s.as_str())
    }

    pub fn is_empty(&self) -> bool {
        self.map.is_empty()
    }
}

/// Rewrite all qualified references inside `expr`.
pub fn qualify_expr(expr: &mut Expr, am: &AliasMap) {
    if am.is_empty() {
        return;
    }
    match &mut expr.kind {
        ExprKind::Id(_) | ExprKind::Literal(_) | ExprKind::Location => {}
        ExprKind::RawString(_) | ExprKind::ByteString(_) => {}
        ExprKind::Todo(_) | ExprKind::Unimplemented(_) | ExprKind::ComptimePrint(_) => {}
        ExprKind::Rt(inner) | ExprKind::Known(inner) | ExprKind::RtKnown(inner) => {
            qualify_expr(inner, am);
        }
        ExprKind::EarlyReturn(inner) | ExprKind::Discard(inner) => qualify_expr(inner, am),
        ExprKind::UnaryOp { operand, .. } => qualify_expr(operand, am),
        ExprKind::Cast { operand, .. } => qualify_expr(operand, am),
        ExprKind::AtResidual { inner, .. } => qualify_expr(inner, am),
        ExprKind::BinaryOp { lhs, rhs, .. } => {
            qualify_expr(lhs, am);
            qualify_expr(rhs, am);
        }
        ExprKind::Call { func, args } => {
            // A call whose callee is exactly `A.m` becomes the renamed ident.
            if let ExprKind::MethodCall { target, method, .. } = &mut func.kind
                && let Some(q) = method_target_rewrite(target, &method.0, am) {
                    func.kind = q;
                }
            qualify_expr(func, am);
            for (_, a) in args.iter_mut() {
                qualify_expr(a, am);
            }
        }
        ExprKind::If { cond, then_block, else_block } => {
            qualify_expr(cond, am);
            qualify_block(then_block, am);
            if let Some(eb) = else_block {
                for s in &mut eb.statements {
                    qualify_stmt(s, am);
                }
                if let Some(tail) = &mut eb.ret {
                    qualify_expr(tail, am);
                }
            }
        }
        ExprKind::While { cond, body } => {
            qualify_expr(cond, am);
            qualify_block(body, am);
        }
        ExprKind::ForIn { collection, body, .. } => {
            qualify_expr(collection, am);
            qualify_block(body, am);
        }
        ExprKind::For { init, cond, step, body } => {
            if let Some(s) = init {
                qualify_stmt(s, am);
            }
            qualify_expr(cond, am);
            if let Some(s) = step {
                qualify_stmt(s, am);
            }
            qualify_block(body, am);
        }
        ExprKind::Match { scrutinee, arms } => {
            qualify_expr(scrutinee, am);
            for (pat, e) in arms.iter_mut() {
                qualify_pattern(pat, am);
                qualify_expr(e, am);
            }
        }
        ExprKind::Spawn { body, .. } => qualify_block(body, am),
        ExprKind::Assert { cond, message } | ExprKind::RtAssert { cond, message } => {
            qualify_expr(cond, am);
            qualify_expr(message, am);
        }
        ExprKind::StructLit { fields, .. } => {
            for (_, v) in fields.iter_mut() {
                qualify_expr(v, am);
            }
        }
        ExprKind::ListLit(elems) => {
            for e in elems.iter_mut() {
                qualify_expr(e, am);
            }
        }
        ExprKind::MapLit(pairs) => {
            for (k, v) in pairs.iter_mut() {
                qualify_expr(k, am);
                qualify_expr(v, am);
            }
        }
        ExprKind::SetLit(elems) => {
            for e in elems.iter_mut() {
                qualify_expr(e, am);
            }
        }
        ExprKind::Range { start, end, .. } => {
            qualify_expr(start, am);
            qualify_expr(end, am);
        }
        ExprKind::FString(parts) => {
            for p in parts.iter_mut() {
                if let crate::FStringPart::Expr(e) = p {
                    qualify_expr(e, am);
                }
            }
        }
        ExprKind::Slice { target, range } => {
            qualify_expr(target, am);
            if let Some(s) = &mut range.start {
                qualify_expr(s, am);
            }
            if let Some(e) = &mut range.end {
                qualify_expr(e, am);
            }
        }
        ExprKind::MethodCall { target, args, .. } => {
            qualify_expr(target, am);
            for a in args.iter_mut() {
                qualify_expr(a, am);
            }
        }
        ExprKind::ElseFallback { value, fallback } => {
            qualify_expr(value, am);
            qualify_block(fallback, am);
        }
        ExprKind::With { bindings, body, .. } => {
            for b in bindings.iter_mut() {
                qualify_expr(&mut b.init, am);
            }
            qualify_block(body, am);
        }
        ExprKind::Using { .. } => {}
        ExprKind::ProviderCall { args, .. } => {
            for a in args.iter_mut() {
                qualify_expr(a, am);
            }
        }
        ExprKind::Index { target, index } => {
            qualify_expr(target, am);
            qualify_expr(index, am);
        }
        // FieldAccess is resolved in the collapse pass right after the match.
        ExprKind::Destructure { .. } => {}
        ExprKind::IfLet { pattern, source, then_block, else_block } => {
            qualify_pattern(pattern, am);
            qualify_expr(source, am);
            qualify_block(then_block, am);
            if let Some(eb) = else_block {
                qualify_block(eb, am);
            }
        }
        ExprKind::WhileLet { pattern, source, body } => {
            qualify_pattern(pattern, am);
            qualify_expr(source, am);
            qualify_block(body, am);
        }
        ExprKind::FieldAccess { target, .. } => {
            qualify_expr(target, am);
        }
    }
    // Qualified-reference collapse for bare `A.m` field/method shapes.
    // A qualified call stays a call: `A.m(x)` → `Call { func: A.m }`.
    if let ExprKind::MethodCall { target, method, args } = &expr.kind
        && let Some(q) = method_target_rewrite(target, &method.0, am) {
            expr.kind = ExprKind::Call {
                func: Box::new(Expr { kind: q, span: expr.span.clone() }),
                args: args
                    .iter()
                    .map(|a| (None, (**a).clone()))
                    .collect(),
            };
            return;
        }
    if let ExprKind::FieldAccess { target, field } = &expr.kind
        && let ExprKind::Id(alias) = &target.kind
            && let Some(q) = am.lookup(&alias.0, &field.0) {
                expr.kind = ExprKind::Id(crate::Id(q.to_string()));
            }
}

/// If `target` is a bare alias id whose member `member` exists, produce the
/// rewritten ident expression.
fn method_target_rewrite(target: &Expr, member: &str, am: &AliasMap) -> Option<ExprKind> {
    if let ExprKind::Id(alias) = &target.kind
        && let Some(q) = am.lookup(&alias.0, member) {
            return Some(ExprKind::Id(crate::Id(q.to_string())));
        }
    None
}

fn qualify_pattern(pat: &mut Pattern, _am: &AliasMap) {
    if let PatternKind::Struct { fields, .. } = &mut pat.kind {
        for (_, p) in fields.iter_mut() {
            qualify_pattern(p, _am);
        }
    }
}

fn qualify_stmt(stmt: &mut crate::Stmt, am: &AliasMap) {
    match &mut stmt.kind {
        StmtKind::Bind { value, .. } => qualify_expr(value, am),
        StmtKind::Discard(e) => qualify_expr(e, am),
        StmtKind::Destructure { source, .. } => qualify_expr(source, am),
        StmtKind::Expr(e) => qualify_expr(e, am),
        StmtKind::Return(Some(e)) => qualify_expr(e, am),
        _ => {}
    }
}

/// Rewrite every statement and tail expression of a block.
pub fn qualify_block(block: &mut crate::Block, am: &AliasMap) {
    for s in &mut block.statements {
        qualify_stmt(s, am);
    }
    if let Some(tail) = &mut block.ret {
        qualify_expr(tail, am);
    }
}
