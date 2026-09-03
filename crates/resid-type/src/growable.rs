//! Growable-accumulator analysis (perf work: turn the O(n^2)-copy,
//! never-freed pattern behind `List.concat` in self-recursive accumulator
//! functions into an O(1)-amortized, correctly-freed in-place grow).
//!
//! Identifies `(function name, parameter index)` pairs where the parameter
//! is provably the sole live reference to its backing list throughout the
//! function's entire self-recursive chain, so codegen can grow it in place
//! instead of copying on every step. There is deliberately NO alias or
//! escape analysis here — soundness comes entirely from a narrow,
//! syntactically-checked shape that already matches how this codebase's
//! accumulator helpers are written:
//!
//! ```text
//! pub List(T) f(..., List(T) acc, ...) {
//!     ...                                  // other params, freely
//!     if (cond) { return acc; }            // base case: acc read, unchanged
//!     ...
//!     List(T) acc2 = acc.concat(EXPR);     // EXPR must not reference acc
//!     ...
//!     return f(..., acc2, ...);            // acc2 threaded to the SAME slot
//! }
//! ```
//!
//! `acc` may appear ONLY as the target of exactly one `.concat` per
//! recursive step, or bare in a base-case return — never bound to another
//! name, passed to any other function, indexed, compared, or captured by
//! `spawn`. The concat's *result* (`acc2`) may appear ONLY as the
//! corresponding argument of a recursive self-call to `f` — nothing else.
//! And EVERY call to `f` anywhere else in the (fully-imported,
//! whole-program) translation unit must pass a bare list literal in that
//! parameter position — never a named variable, a field, or the result of
//! any other call.
//!
//! That last requirement is what makes this sound without tracking aliases
//! at all: a literal evaluated inline at a call site creates a brand-new
//! object nothing else in the program could hold a reference to, and every
//! subsequent value in the chain is itself produced fresh by the
//! recognized `.concat` step and immediately consumed by nothing but the
//! next recursive call. Nothing in the program can ever observe the
//! intermediate buffer except through that one private chain.
//!
//! This never rejects a program: a function that doesn't match the shape,
//! or has even one disqualifying call site, is simply not in the returned
//! set, and codegen falls back to today's always-copy behavior for it —
//! exactly as if this analysis didn't run at all.

use std::collections::{HashMap, HashSet};

use resid_parser::{Block, Declaration, Expr, ExprKind, FuncDef, Stmt, StmtKind, TranslationUnit, Type};

/// `(function name, 0-based parameter index)` pairs proven safe to grow
/// in place.
pub type GrowableAccumulators = HashSet<(String, usize)>;

/// Whether a candidate parameter's usage was entirely safe (accumulator
/// shape respected everywhere it's read), or found using it somewhere
/// disqualifying.
#[derive(PartialEq)]
enum Use {
    Safe,
    Disqualified,
}

pub fn find_growable_accumulators(unit: &TranslationUnit) -> GrowableAccumulators {
    let flat = crate::reduce::flatten_unit(unit);
    let funcs: HashMap<&str, &FuncDef> = flat
        .iter()
        .filter_map(|d| match d {
            Declaration::Function(f) => Some((f.name.0.as_str(), f)),
            _ => None,
        })
        .collect();

    let mut candidates: GrowableAccumulators = HashSet::new();
    for f in funcs.values() {
        for (i, p) in f.params.iter().enumerate() {
            if !is_list_type(&p.type_) {
                continue;
            }
            if check_function_shape(f, &p.name.0, i) {
                candidates.insert((f.name.0.clone(), i));
            }
        }
    }
    if candidates.is_empty() {
        return candidates;
    }

    // Whole-program call-site check: every call to a candidate function,
    // from anywhere except its own verified recursive self-call, must pass
    // a bare list literal in the accumulator's position.
    let mut disqualified: HashSet<(String, usize)> = HashSet::new();
    for f in funcs.values() {
        walk_calls_for_freshness(&f.body, f, &candidates, &mut disqualified);
    }
    for key in disqualified {
        candidates.remove(&key);
    }
    candidates
}

fn is_list_type(t: &Type) -> bool {
    matches!(t, Type::Base { name, .. } if name.0 == "List")
}

/// Check that `f`'s body respects the accumulator shape for parameter
/// `param_name` at position `param_idx`: read only as a base-case return
/// or as the target of a `.concat` whose result flows only into the
/// matching argument of a recursive self-call.
fn check_function_shape(f: &FuncDef, param_name: &str, param_idx: usize) -> bool {
    // A parameter never referenced at all would vacuously pass every check
    // below (nothing to disqualify it) and get seeded with a GrowBuf at
    // every call site that's then never finished or freed — require at
    // least one real occurrence of the shape before trusting it.
    let mut saw_param = false;
    walk_block(&f.body, &mut |e| {
        if matches!(&e.kind, ExprKind::Id(id) if id.0 == param_name) {
            saw_param = true;
        }
    });
    if !saw_param {
        return false;
    }
    let mut grow_temps: HashSet<String> = HashSet::new();
    if check_block(&f.body, f, param_name, param_idx, &mut grow_temps) != Use::Safe {
        return false;
    }
    // Every grow-temp introduced must actually be consumed by the matching
    // recursive-call argument somewhere; one left over means some control
    // path computed a grown value and never fed it onward — not the
    // recognized shape, don't guess, just decline the optimization.
    grow_temps.is_empty()
}

/// Walk a block once, verifying every appearance of `param_name` and of
/// any grow-temp derived from it. `grow_temps` accumulates temp names
/// bound to `param_name.concat(...)` still awaiting their one legal use
/// (the recursive-call argument); a name is removed once consumed.
fn check_block(
    block: &Block,
    f: &FuncDef,
    param_name: &str,
    param_idx: usize,
    grow_temps: &mut HashSet<String>,
) -> Use {
    for stmt in &block.statements {
        match &stmt.kind {
            StmtKind::Bind { name, value, .. } => {
                if is_concat_of(value, param_name) {
                    // value is `param_name.concat(EXPR)`: EXPR itself must
                    // not reference param_name or any live temp.
                    if expr_references_any(value_concat_arg(value), param_name, grow_temps) {
                        return Use::Disqualified;
                    }
                    grow_temps.insert(name.0.clone());
                    continue;
                }
                if expr_references_any(value, param_name, grow_temps) {
                    return Use::Disqualified;
                }
            }
            StmtKind::Return(Some(e)) => {
                if let Use::Disqualified =
                    check_return_expr(e, f, param_name, param_idx, grow_temps)
                {
                    return Use::Disqualified;
                }
            }
            StmtKind::Return(None) => {}
            StmtKind::Discard(e) | StmtKind::Expr(e) => {
                if let ExprKind::If { cond, then_block, else_block } = &e.kind {
                    if expr_references_any(cond, param_name, grow_temps) {
                        return Use::Disqualified;
                    }
                    if check_block(then_block, f, param_name, param_idx, grow_temps) == Use::Disqualified {
                        return Use::Disqualified;
                    }
                    if let Some(eb) = else_block {
                        if check_block(eb, f, param_name, param_idx, grow_temps) == Use::Disqualified {
                            return Use::Disqualified;
                        }
                    }
                    continue;
                }
                if expr_references_any(e, param_name, grow_temps) {
                    return Use::Disqualified;
                }
            }
            StmtKind::Destructure { source, .. } => {
                if expr_references_any(source, param_name, grow_temps) {
                    return Use::Disqualified;
                }
            }
            StmtKind::Break | StmtKind::Continue => {}
        }
    }
    if let Some(ret) = &block.ret {
        return check_return_expr(ret, f, param_name, param_idx, grow_temps);
    }
    Use::Safe
}

/// A tail/return expression may be: a bare `param_name` (base case), a
/// bare grow-temp is NOT legal here (a grown value must feed the
/// recursive call, never be returned directly — that would hand a
/// mid-chain buffer to the outside world), or a recursive call to `f`
/// with the grow-temp (or `param_name` itself, for a trivial pass-through
/// base case) in the matching argument position and nothing disqualifying
/// elsewhere in the call. Anything else must not reference param_name or
/// any live temp at all.
fn check_return_expr(
    e: &Expr,
    f: &FuncDef,
    param_name: &str,
    param_idx: usize,
    grow_temps: &mut HashSet<String>,
) -> Use {
    if let ExprKind::Id(id) = &e.kind {
        if id.0 == param_name {
            return Use::Safe; // base case: return acc;
        }
        if grow_temps.contains(&id.0) {
            // A grown value must be consumed by the recursive call, never
            // returned bare.
            return Use::Disqualified;
        }
        return Use::Safe;
    }
    if let ExprKind::If { cond, then_block, else_block } = &e.kind {
        if expr_references_any(cond, param_name, grow_temps) {
            return Use::Disqualified;
        }
        if check_block(then_block, f, param_name, param_idx, grow_temps) == Use::Disqualified {
            return Use::Disqualified;
        }
        if let Some(eb) = else_block {
            return check_block(eb, f, param_name, param_idx, grow_temps);
        }
        return Use::Safe;
    }
    if let ExprKind::Call { func, args } = &e.kind {
        if let ExprKind::Id(fname) = &func.kind {
            if fname.0 == f.name.0 {
                // Recursive self-call: the argument at param_idx must be
                // exactly param_name (trivial pass-through) or a
                // still-live grow-temp (consuming it); every OTHER
                // argument must not reference param_name or any temp.
                if args.len() != f.params.len() {
                    return Use::Disqualified;
                }
                for (i, (_, arg)) in args.iter().enumerate() {
                    if i == param_idx {
                        match &arg.kind {
                            ExprKind::Id(id) if id.0 == param_name => {}
                            ExprKind::Id(id) if grow_temps.remove(&id.0) => {}
                            _ => return Use::Disqualified,
                        }
                    } else if expr_references_any(arg, param_name, grow_temps) {
                        return Use::Disqualified;
                    }
                }
                return Use::Safe;
            }
        }
        // A call to any other function: fine as long as it doesn't
        // reference param_name or a live temp anywhere in it.
        return if expr_references_any(e, param_name, grow_temps) {
            Use::Disqualified
        } else {
            Use::Safe
        };
    }
    if expr_references_any(e, param_name, grow_temps) {
        return Use::Disqualified;
    }
    Use::Safe
}

/// True when `value` is exactly `param_name.concat(inner)`.
fn is_concat_of(value: &Expr, param_name: &str) -> bool {
    if let ExprKind::MethodCall { target, method, args } = &value.kind {
        if method.0 == "concat" && args.len() == 1 {
            if let ExprKind::Id(id) = &target.kind {
                return id.0 == param_name;
            }
        }
    }
    false
}

fn value_concat_arg(value: &Expr) -> &Expr {
    match &value.kind {
        ExprKind::MethodCall { args, .. } => &args[0],
        _ => value,
    }
}

/// True if `e` references `param_name` anywhere, or references any name
/// still present in `live_temps` anywhere. Used for every context where
/// param_name (or a not-yet-consumed grow-temp) must simply not appear.
fn expr_references_any(e: &Expr, param_name: &str, live_temps: &HashSet<String>) -> bool {
    let mut found = false;
    walk_expr(e, &mut |sub| {
        if let ExprKind::Id(id) = &sub.kind {
            if id.0 == param_name || live_temps.contains(&id.0) {
                found = true;
            }
        }
        // Spawn bodies capture outer bindings by reference (see
        // resid-codegen's lower_spawn) — any reference to param_name or a
        // live temp inside one is a real escape, already covered by the
        // generic Id walk over the spawn body's statements below.
    });
    found
}

/// Generic expression walker: calls `f` on every sub-expression
/// (including `e` itself), recursing into every nested `Expr` this AST
/// can hold — statements inside blocks, call/method arguments, binary/
/// unary operands, literals' interpolated parts, etc. Exhaustive (no
/// wildcard arm) so the compiler flags any new ExprKind variant that
/// needs wiring in here.
fn walk_expr<'a>(e: &'a Expr, f: &mut impl FnMut(&'a Expr)) {
    f(e);
    match &e.kind {
        ExprKind::Id(_)
        | ExprKind::Literal(_)
        | ExprKind::Location
        | ExprKind::RawString(_)
        | ExprKind::ByteString(_)
        | ExprKind::Todo(_)
        | ExprKind::Unimplemented(_) => {}
        ExprKind::BinaryOp { lhs, rhs, .. } => {
            walk_expr(lhs, f);
            walk_expr(rhs, f);
        }
        ExprKind::UnaryOp { operand, .. } => walk_expr(operand, f),
        ExprKind::Cast { operand, .. } => walk_expr(operand, f),
        ExprKind::Call { func, args } => {
            walk_expr(func, f);
            for (_, a) in args {
                walk_expr(a, f);
            }
        }
        ExprKind::Rt(inner) | ExprKind::AtResidual { inner, .. } => walk_expr(inner, f),
        ExprKind::If { cond, then_block, else_block } => {
            walk_expr(cond, f);
            walk_block(then_block, f);
            if let Some(eb) = else_block {
                walk_block(eb, f);
            }
        }
        ExprKind::While { cond, body } => {
            walk_expr(cond, f);
            walk_block(body, f);
        }
        ExprKind::ForIn { collection, body, .. } => {
            walk_expr(collection, f);
            walk_block(body, f);
        }
        ExprKind::Match { scrutinee, arms } => {
            walk_expr(scrutinee, f);
            for (_, e) in arms {
                walk_expr(e, f);
            }
        }
        ExprKind::For { init, cond, step, body } => {
            if let Some(s) = init {
                walk_stmt(s, f);
            }
            walk_expr(cond, f);
            if let Some(s) = step {
                walk_stmt(s, f);
            }
            walk_block(body, f);
        }
        ExprKind::Spawn { body, .. } => walk_block(body, f),
        ExprKind::Assert { cond, message } | ExprKind::RtAssert { cond, message } => {
            walk_expr(cond, f);
            walk_expr(message, f);
        }
        ExprKind::Known(inner) | ExprKind::RtKnown(inner) | ExprKind::ComptimePrint(inner) => {
            walk_expr(inner, f)
        }
        ExprKind::StructLit { fields, .. } => {
            for (_, v) in fields {
                walk_expr(v, f);
            }
        }
        ExprKind::ListLit(elems) | ExprKind::SetLit(elems) => {
            for e in elems {
                walk_expr(e, f);
            }
        }
        ExprKind::MapLit(entries) => {
            for (k, v) in entries {
                walk_expr(k, f);
                walk_expr(v, f);
            }
        }
        ExprKind::Range { start, end, .. } => {
            walk_expr(start, f);
            walk_expr(end, f);
        }
        ExprKind::FString(parts) => {
            for p in parts {
                if let resid_parser::FStringPart::Expr(e) = p {
                    walk_expr(e, f);
                }
            }
        }
        ExprKind::FieldAccess { target, .. } => walk_expr(target, f),
        ExprKind::Index { target, index } => {
            walk_expr(target, f);
            walk_expr(index, f);
        }
        ExprKind::Slice { target, range } => {
            walk_expr(target, f);
            if let Some(s) = &range.start {
                walk_expr(s, f);
            }
            if let Some(en) = &range.end {
                walk_expr(en, f);
            }
        }
        ExprKind::MethodCall { target, args, .. } => {
            walk_expr(target, f);
            for a in args {
                walk_expr(a, f);
            }
        }
        ExprKind::EarlyReturn(inner) => walk_expr(inner, f),
        ExprKind::ElseFallback { value, fallback } => {
            walk_expr(value, f);
            walk_block(fallback, f);
        }
        ExprKind::Destructure { source, .. } => walk_expr(source, f),
        ExprKind::IfLet { source, then_block, else_block, .. } => {
            walk_expr(source, f);
            walk_block(then_block, f);
            if let Some(eb) = else_block {
                walk_block(eb, f);
            }
        }
        ExprKind::WhileLet { source, body, .. } => {
            walk_expr(source, f);
            walk_block(body, f);
        }
        ExprKind::Using { value, .. } => walk_expr(value, f),
        ExprKind::With { bindings, body } => {
            for b in bindings {
                walk_expr(&b.init, f);
            }
            walk_block(body, f);
        }
        ExprKind::ProviderCall { args, .. } => {
            for a in args {
                walk_expr(a, f);
            }
        }
        ExprKind::Discard(inner) => walk_expr(inner, f),
    }
}

fn walk_block<'a>(block: &'a Block, f: &mut impl FnMut(&'a Expr)) {
    for stmt in &block.statements {
        walk_stmt(stmt, f);
    }
    if let Some(ret) = &block.ret {
        walk_expr(ret, f);
    }
}

fn walk_stmt<'a>(stmt: &'a Stmt, f: &mut impl FnMut(&'a Expr)) {
    match &stmt.kind {
        StmtKind::Bind { value, .. } => walk_expr(value, f),
        StmtKind::Discard(e) | StmtKind::Expr(e) => walk_expr(e, f),
        StmtKind::Return(Some(e)) => walk_expr(e, f),
        StmtKind::Return(None) | StmtKind::Break | StmtKind::Continue => {}
        StmtKind::Destructure { source, .. } => walk_expr(source, f),
    }
}

/// Whole-program call-site freshness check: every call anywhere to a
/// candidate `(fn, idx)`, except the already-verified recursive self-call
/// inside that same function's own body, must pass a bare list literal at
/// that position.
fn walk_calls_for_freshness(
    block: &Block,
    caller: &FuncDef,
    candidates: &GrowableAccumulators,
    disqualified: &mut HashSet<(String, usize)>,
) {
    walk_block(block, &mut |e| {
        if let ExprKind::Call { func, args } = &e.kind {
            if let ExprKind::Id(fname) = &func.kind {
                let is_self_recursive_call = fname.0 == caller.name.0;
                for (i, (_, arg)) in args.iter().enumerate() {
                    let key = (fname.0.clone(), i);
                    if !candidates.contains(&key) {
                        continue;
                    }
                    if is_self_recursive_call {
                        // Already fully verified by check_function_shape:
                        // it's either param_name or a consumed grow-temp.
                        continue;
                    }
                    if !matches!(arg.kind, ExprKind::ListLit(_)) {
                        disqualified.insert(key);
                    }
                }
            }
        }
    });
}
