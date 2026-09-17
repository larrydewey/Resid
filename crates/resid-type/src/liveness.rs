//! Perceus-style last-use (move) analysis (Phase E.1). This is the
//! concrete realization of `PLAN-resid-only.md`'s section "The real shape
//! of the fix: compile-time ownership / last-use analysis": a real
//! backward liveness pass over the structured AST/block-tree (the
//! representation decided in E.1 step 1 — no new IR), not a shape
//! enumeration.
//!
//! Resid is pure — values are immutable, every binding is defined exactly
//! once, and there is no reassignment or shadowing — so Perceus's
//! ownership model specializes to a simple, purely lexical rule: at a
//! binding's **last use** the caller keeps no reference, so the value can
//! be handed on as *owned* (moved). Any *other* use is a `dup` (a copy) —
//! which is exactly today's always-copy behavior — and a value that is
//! dupped elsewhere is still uniquely owned at its own last use.
//!
//! This module implements the last-use half: [`last_uses`] returns the
//! span of every `Id` occurrence that is the last use of its binding.
//! `ownership.rs` consumes it to replace the old literal-only call-site
//! freshness gate with move semantics (a last-use argument is owned by the
//! callee without an extra copy).
//!
//! Loops are deliberately conservative: every name referenced inside a
//! loop body or condition is treated as live across the whole loop, so no
//! last-use is reported inside a loop (it could be consumed on an earlier
//! iteration). This mirrors the loop conservatism already used by
//! `growable.rs`/`field_growable.rs`/`ownership.rs`.

use std::collections::HashSet;

use resid_parser::{Block, Expr, ExprKind, FuncDef, Pattern, PatternKind, Stmt, StmtKind};

/// A source occurrence, `(file, line, col_start, col_end)`. Same keying
/// rationale as `ownership.rs` (spans are stable across `flatten_unit`'s
/// clone; AST pointers are not).
pub type SiteKey = (String, usize, usize, usize);

fn site_key(e: &Expr) -> SiteKey {
    let s = &e.span;
    (s.file.clone(), s.line, s.col_start, s.col_end)
}

/// Span of every `Id` occurrence that is the last use of its function-
/// parameter or local binding, by backward liveness.
pub fn last_uses(f: &FuncDef) -> HashSet<SiteKey> {
    let declared = declared_names(f);
    let mut out = HashSet::new();
    let exit: HashSet<String> = HashSet::new();
    block_last_uses(&f.body, &exit, &declared, &mut out);
    out
}

// --- Backward liveness ---

fn block_last_uses(
    block: &Block,
    live_after: &HashSet<String>,
    declared: &HashSet<String>,
    out: &mut HashSet<SiteKey>,
) -> HashSet<String> {
    let mut live = live_after.clone();
    if let Some(ret) = &block.ret {
        live = expr_last_uses(ret, &live, declared, out);
    }
    for stmt in block.statements.iter().rev() {
        live = stmt_last_uses(stmt, &live, declared, out);
    }
    live
}

fn stmt_last_uses(
    stmt: &Stmt,
    live_after: &HashSet<String>,
    declared: &HashSet<String>,
    out: &mut HashSet<SiteKey>,
) -> HashSet<String> {
    match &stmt.kind {
        StmtKind::Bind { name, value, .. } => {
            let mut live = live_after.clone();
            live.remove(&name.0);
            expr_last_uses(value, &live, declared, out)
        }
        StmtKind::Discard(e) | StmtKind::Expr(e) => expr_last_uses(e, live_after, declared, out),
        // A returned value is consumed and nothing after a `return` is
        // reachable, so its own live-out is empty.
        StmtKind::Return(Some(e)) => {
            let exit: HashSet<String> = HashSet::new();
            expr_last_uses(e, &exit, declared, out)
        }
        StmtKind::Return(None) | StmtKind::Break | StmtKind::Continue => live_after.clone(),
        StmtKind::Destructure { pattern, source } => {
            let mut live = live_after.clone();
            for b in pattern_binders(pattern) {
                live.remove(&b);
            }
            expr_last_uses(source, &live, declared, out)
        }
    }
}

fn expr_last_uses(
    e: &Expr,
    live_after: &HashSet<String>,
    declared: &HashSet<String>,
    out: &mut HashSet<SiteKey>,
) -> HashSet<String> {
    match &e.kind {
        ExprKind::Id(id) => {
            if declared.contains(&id.0) && !live_after.contains(&id.0) {
                out.insert(site_key(e));
            }
            let mut live = live_after.clone();
            live.insert(id.0.clone());
            live
        }
        ExprKind::If { cond, then_block, else_block } => {
            let mut live = block_last_uses(then_block, live_after, declared, out);
            if let Some(eb) = else_block {
                live.extend(block_last_uses(eb, live_after, declared, out));
            }
            live.extend(expr_last_uses(cond, live_after, declared, out));
            live
        }
        ExprKind::While { cond, body } => {
            let live = loop_live(cond, body, live_after);
            let _ = block_last_uses(body, &live, declared, out);
            let _ = expr_last_uses(cond, &live, declared, out);
            live
        }
        ExprKind::ForIn { collection, body, name, .. } => {
            let mut live = loop_live(collection, body, live_after);
            live.insert(name.0.clone());
            let _ = block_last_uses(body, &live, declared, out);
            let _ = expr_last_uses(collection, &live, declared, out);
            live
        }
        ExprKind::For { init, cond, step, body } => {
            let mut live = loop_live(cond, body, live_after);
            if let Some(s) = init {
                live.extend(stmt_last_uses(s, &live, declared, out));
            }
            if let Some(s) = step {
                live.extend(stmt_last_uses(s, &live, declared, out));
            }
            let _ = block_last_uses(body, &live.clone(), declared, out);
            let _ = expr_last_uses(cond, &live.clone(), declared, out);
            live
        }
        ExprKind::Match { scrutinee, arms } => {
            let mut live = expr_last_uses(scrutinee, live_after, declared, out);
            for (_, arm) in arms {
                live.extend(expr_last_uses(arm, live_after, declared, out));
            }
            live
        }
        ExprKind::Spawn { body, .. } => {
            let mut live = live_after.clone();
            let mut used = HashSet::new();
            names_in_block(body, &mut used);
            live.extend(used);
            let _ = block_last_uses(body, &live, declared, out);
            live
        }
        ExprKind::ElseFallback { value, fallback } => {
            let mut live = block_last_uses(fallback, live_after, declared, out);
            live.extend(expr_last_uses(value, &live.clone(), declared, out));
            live
        }
        ExprKind::IfLet { source, then_block, else_block, .. } => {
            let mut live = block_last_uses(then_block, live_after, declared, out);
            if let Some(eb) = else_block {
                live.extend(block_last_uses(eb, live_after, declared, out));
            }
            live.extend(expr_last_uses(source, live_after, declared, out));
            live
        }
        ExprKind::WhileLet { source, body, .. } => {
            let mut live = live_after.clone();
            let mut used = HashSet::new();
            names_in_expr(source, &mut used);
            names_in_block(body, &mut used);
            live.extend(used);
            let _ = block_last_uses(body, &live, declared, out);
            let _ = expr_last_uses(source, &live, declared, out);
            live
        }
        ExprKind::With { bindings, body } => {
            let mut live = block_last_uses(body, live_after, declared, out);
            for b in bindings.iter().rev() {
                live.remove(&b.name.0);
                live = expr_last_uses(&b.init, &live, declared, out);
            }
            live
        }
        ExprKind::Destructure { pattern, source } => {
            let mut live = live_after.clone();
            for b in pattern_binders(pattern) {
                live.remove(&b);
            }
            expr_last_uses(source, &live, declared, out)
        }
        _ => {
            let mut live = live_after.clone();
            for child in child_exprs(e).into_iter().rev() {
                live = expr_last_uses(child, &live, declared, out);
            }
            live
        }
    }
}

/// Live set for a conservative loop: everything referenced anywhere in the
/// condition/body is live across the whole loop, plus whatever was live
/// after it.
fn loop_live(cond: &Expr, body: &Block, live_after: &HashSet<String>) -> HashSet<String> {
    let mut live = live_after.clone();
    names_in_expr(cond, &mut live);
    names_in_block(body, &mut live);
    live
}

// --- Binder name collection ---

fn declared_names(f: &FuncDef) -> HashSet<String> {
    let mut out = HashSet::new();
    for p in &f.params {
        out.insert(p.name.0.clone());
    }
    collect_binders_block(&f.body, &mut out);
    out
}

fn pattern_binders(p: &Pattern) -> Vec<String> {
    match &p.kind {
        PatternKind::Wildcard | PatternKind::Literal(_) => Vec::new(),
        PatternKind::Bind(id) => vec![id.0.clone()],
        PatternKind::Variant { param, .. } => param.iter().map(|i| i.0.clone()).collect(),
        PatternKind::Struct { fields, .. } => {
            fields.iter().flat_map(|(_, sub)| pattern_binders(sub)).collect()
        }
    }
}

fn collect_binders_block(block: &Block, out: &mut HashSet<String>) {
    for stmt in &block.statements {
        collect_binders_stmt(stmt, out);
    }
    if let Some(ret) = &block.ret {
        collect_binders_expr(ret, out);
    }
}

fn collect_binders_stmt(stmt: &Stmt, out: &mut HashSet<String>) {
    match &stmt.kind {
        StmtKind::Bind { name, value, .. } => {
            out.insert(name.0.clone());
            collect_binders_expr(value, out);
        }
        StmtKind::Discard(e) | StmtKind::Expr(e) | StmtKind::Return(Some(e)) => {
            collect_binders_expr(e, out)
        }
        StmtKind::Return(None) | StmtKind::Break | StmtKind::Continue => {}
        StmtKind::Destructure { pattern, source } => {
            for b in pattern_binders(pattern) {
                out.insert(b);
            }
            collect_binders_expr(source, out);
        }
    }
}

fn collect_binders_expr(e: &Expr, out: &mut HashSet<String>) {
    match &e.kind {
        ExprKind::If { cond, then_block, else_block } => {
            collect_binders_expr(cond, out);
            collect_binders_block(then_block, out);
            if let Some(eb) = else_block {
                collect_binders_block(eb, out);
            }
        }
        ExprKind::While { cond, body } => {
            collect_binders_expr(cond, out);
            collect_binders_block(body, out);
        }
        ExprKind::ForIn { collection, body, name, .. } => {
            out.insert(name.0.clone());
            collect_binders_expr(collection, out);
            collect_binders_block(body, out);
        }
        ExprKind::For { init, cond, step, body } => {
            if let Some(s) = init {
                collect_binders_stmt(s, out);
            }
            collect_binders_expr(cond, out);
            if let Some(s) = step {
                collect_binders_stmt(s, out);
            }
            collect_binders_block(body, out);
        }
        ExprKind::Match { scrutinee, arms } => {
            collect_binders_expr(scrutinee, out);
            for (pat, arm) in arms {
                for b in pattern_binders(pat) {
                    out.insert(b);
                }
                collect_binders_expr(arm, out);
            }
        }
        ExprKind::Spawn { body, .. } => collect_binders_block(body, out),
        ExprKind::ElseFallback { value, fallback } => {
            collect_binders_expr(value, out);
            collect_binders_block(fallback, out);
        }
        ExprKind::IfLet { pattern, source, then_block, else_block } => {
            for b in pattern_binders(pattern) {
                out.insert(b);
            }
            collect_binders_expr(source, out);
            collect_binders_block(then_block, out);
            if let Some(eb) = else_block {
                collect_binders_block(eb, out);
            }
        }
        ExprKind::WhileLet { pattern, source, body } => {
            for b in pattern_binders(pattern) {
                out.insert(b);
            }
            collect_binders_expr(source, out);
            collect_binders_block(body, out);
        }
        ExprKind::With { bindings, body } => {
            for b in bindings {
                out.insert(b.name.0.clone());
                collect_binders_expr(&b.init, out);
            }
            collect_binders_block(body, out);
        }
        ExprKind::Destructure { pattern, source } => {
            for b in pattern_binders(pattern) {
                out.insert(b);
            }
            collect_binders_expr(source, out);
        }
        _ => {
            for child in child_exprs(e) {
                collect_binders_expr(child, out);
            }
        }
    }
}

// --- Name-use scans (for loop conservatism) ---

fn names_in_block(block: &Block, out: &mut HashSet<String>) {
    for stmt in &block.statements {
        names_in_stmt(stmt, out);
    }
    if let Some(ret) = &block.ret {
        names_in_expr(ret, out);
    }
}

fn names_in_stmt(stmt: &Stmt, out: &mut HashSet<String>) {
    match &stmt.kind {
        StmtKind::Bind { value, .. } => names_in_expr(value, out),
        StmtKind::Discard(e) | StmtKind::Expr(e) | StmtKind::Return(Some(e)) => {
            names_in_expr(e, out)
        }
        StmtKind::Return(None) | StmtKind::Break | StmtKind::Continue => {}
        StmtKind::Destructure { source, .. } => names_in_expr(source, out),
    }
}

fn names_in_expr(e: &Expr, out: &mut HashSet<String>) {
    if let ExprKind::Id(id) = &e.kind {
        out.insert(id.0.clone());
    }
    match &e.kind {
        ExprKind::If { cond, then_block, else_block } => {
            names_in_expr(cond, out);
            names_in_block(then_block, out);
            if let Some(eb) = else_block {
                names_in_block(eb, out);
            }
        }
        ExprKind::While { cond, body } => {
            names_in_expr(cond, out);
            names_in_block(body, out);
        }
        ExprKind::ForIn { collection, body, .. } => {
            names_in_expr(collection, out);
            names_in_block(body, out);
        }
        ExprKind::For { init, cond, step, body } => {
            if let Some(s) = init {
                names_in_stmt(s, out);
            }
            names_in_expr(cond, out);
            if let Some(s) = step {
                names_in_stmt(s, out);
            }
            names_in_block(body, out);
        }
        ExprKind::Match { scrutinee, arms } => {
            names_in_expr(scrutinee, out);
            for (_, arm) in arms {
                names_in_expr(arm, out);
            }
        }
        ExprKind::Spawn { body, .. } => names_in_block(body, out),
        ExprKind::ElseFallback { value, fallback } => {
            names_in_expr(value, out);
            names_in_block(fallback, out);
        }
        ExprKind::IfLet { source, then_block, else_block, .. } => {
            names_in_expr(source, out);
            names_in_block(then_block, out);
            if let Some(eb) = else_block {
                names_in_block(eb, out);
            }
        }
        ExprKind::WhileLet { source, body, .. } => {
            names_in_expr(source, out);
            names_in_block(body, out);
        }
        ExprKind::With { bindings, body } => {
            for b in bindings {
                names_in_expr(&b.init, out);
            }
            names_in_block(body, out);
        }
        ExprKind::Destructure { source, .. } => names_in_expr(source, out),
        _ => {
            for child in child_exprs(e) {
                names_in_expr(child, out);
            }
        }
    }
}

// --- Direct-child iterator (evaluation order) ---

/// Direct sub-expressions of a block-less `ExprKind`, in evaluation order.
/// Block-bearing kinds (`If`/`While`/`ForIn`/`Match`/`For`/`Spawn`/
/// `ElseFallback`/`IfLet`/`WhileLet`/`With`/`Destructure`) are handled by
/// the liveness walk itself and yield nothing here.
fn child_exprs(e: &Expr) -> Vec<&Expr> {
    use resid_parser::FStringPart;
    match &e.kind {
        ExprKind::BinaryOp { lhs, rhs, .. } => vec![lhs, rhs],
        ExprKind::UnaryOp { operand, .. } | ExprKind::Cast { operand, .. } => vec![operand],
        ExprKind::Call { func, args } => {
            let mut v = vec![func.as_ref()];
            v.extend(args.iter().map(|(_, a)| a));
            v
        }
        ExprKind::Rt(inner) | ExprKind::AtResidual { inner, .. } => vec![inner],
        ExprKind::Assert { cond, message } | ExprKind::RtAssert { cond, message } => {
            vec![cond, message]
        }
        ExprKind::Known(inner) | ExprKind::RtKnown(inner) | ExprKind::ComptimePrint(inner) => {
            vec![inner]
        }
        ExprKind::StructLit { fields, .. } => fields.iter().map(|(_, v)| v).collect(),
        ExprKind::ListLit(elems) | ExprKind::SetLit(elems) => elems.iter().collect(),
        ExprKind::MapLit(entries) => entries.iter().flat_map(|(k, v)| [k, v]).collect(),
        ExprKind::Range { start, end, .. } => vec![start, end],
        ExprKind::FString(parts) => parts
            .iter()
            .filter_map(|p| match p {
                FStringPart::Expr(e) => Some(e.as_ref()),
                FStringPart::Text(_) => None,
            })
            .collect(),
        ExprKind::FieldAccess { target, .. } => vec![target],
        ExprKind::Index { target, index } => vec![target, index],
        ExprKind::Slice { target, range } => {
            let mut v = vec![target.as_ref()];
            if let Some(s) = &range.start {
                v.push(s);
            }
            if let Some(en) = &range.end {
                v.push(en);
            }
            v
        }
        ExprKind::MethodCall { target, args, .. } => {
            let mut v = vec![target.as_ref()];
            v.extend(args.iter().map(|a| a.as_ref()));
            v
        }
        ExprKind::EarlyReturn(inner) => vec![inner],
        ExprKind::Using { value, .. } => vec![value],
        ExprKind::ProviderCall { args, .. } => args.iter().map(|a| a.as_ref()).collect(),
        ExprKind::Discard(inner) => vec![inner],
        ExprKind::Id(_)
        | ExprKind::Literal(_)
        | ExprKind::Location
        | ExprKind::RawString(_)
        | ExprKind::ByteString(_)
        | ExprKind::Todo(_)
        | ExprKind::Unimplemented(_) => Vec::new(),
        ExprKind::If { .. }
        | ExprKind::While { .. }
        | ExprKind::ForIn { .. }
        | ExprKind::Match { .. }
        | ExprKind::For { .. }
        | ExprKind::Spawn { .. }
        | ExprKind::ElseFallback { .. }
        | ExprKind::IfLet { .. }
        | ExprKind::WhileLet { .. }
        | ExprKind::With { .. }
        | ExprKind::Destructure { .. } => Vec::new(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use resid_parser::Parser;

    fn parse(src: &str) -> resid_parser::TranslationUnit {
        let (unit, errs) = Parser::parse("test.resid", src);
        assert!(errs.is_empty(), "parse errors: {errs:?}");
        unit
    }

    fn func<'a>(unit: &'a resid_parser::TranslationUnit, name: &str) -> &'a FuncDef {
        unit.declarations
            .iter()
            .find_map(|d| match d {
                resid_parser::Declaration::Function(f) if f.name.0 == name => Some(f),
                _ => None,
            })
            .unwrap_or_else(|| panic!("no function named {name}"))
    }

    /// All `Id` occurrences of a function body in source order, paired with
    /// their site key, for locating "the nth occurrence of `name`".
    fn occurrences(f: &FuncDef) -> Vec<(String, SiteKey)> {
        let mut v = Vec::new();
        fn eb(b: &Block, v: &mut Vec<(String, SiteKey)>) {
            for s in &b.statements {
                es(s, v);
            }
            if let Some(r) = &b.ret {
                ee(r, v);
            }
        }
        fn es(s: &Stmt, v: &mut Vec<(String, SiteKey)>) {
            match &s.kind {
                StmtKind::Bind { value, .. } => ee(value, v),
                StmtKind::Discard(e) | StmtKind::Expr(e) | StmtKind::Return(Some(e)) => ee(e, v),
                StmtKind::Destructure { source, .. } => ee(source, v),
                _ => {}
            }
        }
        fn ee(e: &Expr, v: &mut Vec<(String, SiteKey)>) {
            if let ExprKind::Id(id) = &e.kind {
                v.push((id.0.clone(), site_key(e)));
            }
            for c in child_exprs(e) {
                ee(c, v);
            }
            match &e.kind {
                ExprKind::If { cond, then_block, else_block } => {
                    ee(cond, v);
                    eb(then_block, v);
                    if let Some(ebk) = else_block {
                        eb(ebk, v);
                    }
                }
                ExprKind::While { cond, body } => {
                    ee(cond, v);
                    eb(body, v);
                }
                ExprKind::ForIn { collection, body, .. } => {
                    ee(collection, v);
                    eb(body, v);
                }
                ExprKind::For { init, cond, step, body } => {
                    if let Some(s) = init {
                        es(s, v);
                    }
                    ee(cond, v);
                    if let Some(s) = step {
                        es(s, v);
                    }
                    eb(body, v);
                }
                ExprKind::Match { scrutinee, arms } => {
                    ee(scrutinee, v);
                    for (_, arm) in arms {
                        ee(arm, v);
                    }
                }
                ExprKind::Spawn { body, .. } => eb(body, v),
                ExprKind::ElseFallback { value, fallback } => {
                    ee(value, v);
                    eb(fallback, v);
                }
                ExprKind::IfLet { source, then_block, else_block, .. } => {
                    ee(source, v);
                    eb(then_block, v);
                    if let Some(ebk) = else_block {
                        eb(ebk, v);
                    }
                }
                ExprKind::WhileLet { source, body, .. } => {
                    ee(source, v);
                    eb(body, v);
                }
                ExprKind::With { bindings, body } => {
                    for b in bindings {
                        ee(&b.init, v);
                    }
                    eb(body, v);
                }
                ExprKind::Destructure { source, .. } => ee(source, v),
                _ => {}
            }
        }
        eb(&f.body, &mut v);
        v
    }

    fn is_last(f: &FuncDef, name: &str, nth: usize) -> bool {
        let occ = occurrences(f);
        let key = occ
            .iter()
            .filter(|(n, _)| n == name)
            .nth(nth)
            .unwrap_or_else(|| panic!("no occurrence {nth} of `{name}`"))
            .1
            .clone();
        last_uses(f).contains(&key)
    }

    #[test]
    fn straight_line_last_use_is_final_occurrence() {
        let src = r#"
            type GT = { lines: List(Str), tag: Str };

            GT grow(GT ev, Str s) {
                List(Str) d = ev.lines.concat([s]);
                return GT { lines: d, tag: ev.tag };
            }
        "#;
        let unit = parse(src);
        let f = func(&unit, "grow");
        assert!(is_last(f, "ev", 1), "second `ev` occurrence (the rebuild) is last");
        assert!(!is_last(f, "ev", 0), "first `ev` occurrence (read) is not last");
        assert!(is_last(f, "d", 0), "`d`'s only use is last");
    }

    #[test]
    fn used_in_both_branches_then_after_is_not_last() {
        let src = r#"
            Int f(Int c, Int x) {
                if (c > 0) { Int a = x + 1; } else { Int b = x + 2; }
                return x;
            }
        "#;
        let unit = parse(src);
        let f = func(&unit, "f");
        // x is used in both branches and after the if: the branch uses are not
        // last (x stays live), but the final `return x` is.
        assert!(!is_last(f, "x", 0), "then-branch x should not be last");
        assert!(!is_last(f, "x", 1), "else-branch x should not be last");
        assert!(is_last(f, "x", 2), "the tail `return x` is the last use");
    }

    #[test]
    fn used_in_one_branch_not_after_is_last() {
        let src = r#"
            Int f(Int c, Int x) {
                if (c > 0) { return x; }
                return 0;
            }
        "#;
        let unit = parse(src);
        let f = func(&unit, "f");
        assert!(is_last(f, "x", 0), "x used only in the then-branch return is last on that path");
    }

    #[test]
    fn loop_use_reports_no_last_use() {
        let src = r#"
            Int f(Int n, Bool b) {
                while (b) {
                    Int u = n;
                }
                return n;
            }
        "#;
        let unit = parse(src);
        let f = func(&unit, "f");
        // `n` is referenced in the loop body, so it is live across the loop:
        // the body occurrence is not a last use, but the tail one is.
        assert!(!is_last(f, "n", 0), "loop-body occurrence must not be a last use");
        assert!(is_last(f, "n", 1), "the tail occurrence is a last use");
    }

    #[test]
    fn parameter_passed_through_only_once_is_last() {
        let src = r#"
            Int g(Int x) {
                return x;
            }

            Int f(Int x) {
                return g(x);
            }
        "#;
        let unit = parse(src);
        let f = func(&unit, "f");
        assert!(is_last(f, "x", 0), "a parameter used only as a forwarded argument is last");
    }
}
