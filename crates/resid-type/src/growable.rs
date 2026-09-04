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
//! name, indexed, compared, or captured by `spawn`. The concat's *result*
//! (`acc2`) may appear ONLY as the corresponding argument of a recursive
//! self-call to `f` — nothing else. And EVERY call to `f` anywhere else in
//! the (fully-imported, whole-program) translation unit must pass a bare
//! list literal in that parameter position — never a named variable, a
//! field, or the result of any other call.
//!
//! That last requirement is what makes this sound without tracking aliases
//! at all: a literal evaluated inline at a call site creates a brand-new
//! object nothing else in the program could hold a reference to, and every
//! subsequent value in the chain is itself produced fresh by the
//! recognized `.concat` step and immediately consumed by nothing but the
//! next recursive call. Nothing in the program can ever observe the
//! intermediate buffer except through that one private chain.
//!
//! **Delegation.** `acc` may also appear as the accumulator argument of a
//! call to a *different* function `h` (not `f` itself), whose own
//! accumulator parameter is independently proven growable at that
//! position — e.g. `lib/aesgcm.resid`'s `ctr_xor` threading its `acc`
//! through `ctr_take`, which does the actual `.concat`. The call's result
//! must then flow into `f`'s own recursive self-call exactly like a
//! `.concat` result would. This makes a delegate target's own validity
//! depend on its delegator's, and vice versa (a call site passing the
//! delegator's own tracked parameter counts as "fresh" precisely because
//! the delegator proved nothing else can reference it either) — resolved
//! by a small least-fixpoint over the delegation graph below, not by
//! re-deriving freshness some other way.
//!
//! A pure delegate target (something only ever reached via delegation,
//! `ctr_take` here) must never convert its buffer back into a normal
//! boxed List at its own base case — that would run once per *inner*
//! call, defeating the whole point, and worse, hand the delegator a
//! normal boxed List where it expects to keep pushing onto a GrowBuf (the
//! two have different memory layouts; treating one as the other is
//! memory corruption, not a slowdown). Converting to a real List is
//! correct exactly once, at the root of a delegation chain (the function
//! nothing else delegates into) — `should_finish` tells codegen which is
//! which.
//!
//! This never rejects a program: a function that doesn't match the shape,
//! or has even one disqualifying call site, is simply not in the returned
//! set, and codegen falls back to today's always-copy behavior for it —
//! exactly as if this analysis didn't run at all.

use std::collections::{HashMap, HashSet};

use resid_parser::{Block, Declaration, Expr, ExprKind, FuncDef, Stmt, StmtKind, TranslationUnit, Type};

type Key = (String, usize);

/// Result of the analysis: which `(function, parameter index)` pairs are
/// safe to represent as a GrowBuf, and which of those must NOT convert
/// back to a normal List at their own base case (because some other
/// validated function delegates into them — see the module doc).
#[derive(Default)]
pub struct GrowableAccumulators {
    growable: HashSet<Key>,
    delegate_targets: HashSet<Key>,
}

impl GrowableAccumulators {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn is_growable(&self, name: &str, idx: usize) -> bool {
        self.growable.contains(&(name.to_string(), idx))
    }

    /// False only for a pure delegate target: its base-case `return acc;`
    /// must pass the raw GrowBuf pointer straight through instead of
    /// calling resid_growbuf_finish.
    pub fn should_finish(&self, name: &str, idx: usize) -> bool {
        !self.delegate_targets.contains(&(name.to_string(), idx))
    }
}

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

    // Phase 1: per-function shape check, ignoring (for now) whether any
    // delegate target this function relies on is itself valid — that's
    // resolved by the fixpoint below. `shapes[key]` = the delegate edges
    // `key` requires to hold (empty for a plain `.concat`-only leaf).
    let mut shapes: HashMap<Key, Vec<Key>> = HashMap::new();
    for f in funcs.values() {
        for (i, p) in f.params.iter().enumerate() {
            if !is_list_type(&p.type_) {
                continue;
            }
            if let Some(edges) = check_function_shape(f, &p.name.0, i) {
                shapes.insert((f.name.0.clone(), i), edges);
            }
        }
    }
    if shapes.is_empty() {
        return GrowableAccumulators::new();
    }

    // Phase 2: least fixpoint over the delegation graph — a candidate
    // survives only if every delegate edge it requires also survives.
    // Monotonically shrinking (only ever removes), so this terminates.
    let mut valid: HashSet<Key> = shapes.keys().cloned().collect();
    loop {
        let to_remove: Vec<Key> = shapes
            .iter()
            .filter(|(key, _)| valid.contains(*key))
            .filter(|(_, edges)| edges.iter().any(|t| !valid.contains(t)))
            .map(|(key, _)| key.clone())
            .collect();
        if to_remove.is_empty() {
            break;
        }
        for k in to_remove {
            valid.remove(&k);
        }
    }
    if valid.is_empty() {
        return GrowableAccumulators::new();
    }

    // Phase 3: whole-program call-site freshness. Every call to a
    // surviving candidate, other than its own verified recursive
    // self-call, must pass either a bare list literal, or the calling
    // function's own tracked accumulator parameter at a position that
    // phase 1 recorded as a delegate edge to exactly this candidate
    // (i.e. a sanctioned delegation — the delegator already proved
    // nothing else can reference that value either).
    let mut disqualified: HashSet<Key> = HashSet::new();
    for caller in funcs.values() {
        let caller_growable_param: Option<(usize, &str)> = caller
            .params
            .iter()
            .enumerate()
            .find(|(i, _)| valid.contains(&(caller.name.0.clone(), *i)))
            .map(|(i, p)| (i, p.name.0.as_str()));
        walk_calls_for_freshness(&caller.body, caller, &shapes, &valid, caller_growable_param, &mut disqualified);
    }
    for key in &disqualified {
        valid.remove(key);
    }
    // Removing call-site-disqualified entries can break edges that other
    // still-"valid" candidates depended on — re-run the fixpoint once
    // more against the shrunk set (phase 3 never adds candidates back,
    // and each pass only removes, so this still terminates).
    loop {
        let to_remove: Vec<Key> = shapes
            .iter()
            .filter(|(key, _)| valid.contains(*key))
            .filter(|(_, edges)| edges.iter().any(|t| !valid.contains(t)))
            .map(|(key, _)| key.clone())
            .collect();
        if to_remove.is_empty() {
            break;
        }
        for k in to_remove {
            valid.remove(&k);
        }
    }

    let delegate_targets: HashSet<Key> = valid
        .iter()
        .filter_map(|k| shapes.get(k))
        .flat_map(|edges| edges.iter().cloned())
        .filter(|t| valid.contains(t))
        .collect();

    GrowableAccumulators {
        growable: valid,
        delegate_targets,
    }
}

fn is_list_type(t: &Type) -> bool {
    matches!(t, Type::Base { name, .. } if name.0 == "List")
}

/// Check that `f`'s body respects the accumulator shape for parameter
/// `param_name` at position `param_idx`. Returns the delegate edges this
/// function's validity depends on (empty for a plain `.concat`-only
/// leaf), or `None` if the shape isn't respected at all.
fn check_function_shape(f: &FuncDef, param_name: &str, param_idx: usize) -> Option<Vec<Key>> {
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
        return None;
    }
    let mut grow_temps: HashSet<String> = HashSet::new();
    let mut edges: Vec<Key> = Vec::new();
    if check_block(&f.body, f, param_name, param_idx, &mut grow_temps, &mut edges) != Use::Safe {
        return None;
    }
    // Every grow-temp introduced must actually be consumed by the matching
    // recursive-call argument somewhere; one left over means some control
    // path computed a grown value and never fed it onward — not the
    // recognized shape, don't guess, just decline the optimization.
    if !grow_temps.is_empty() {
        return None;
    }
    Some(edges)
}

/// Walk a block once, verifying every appearance of `param_name` and of
/// any grow-temp derived from it. `grow_temps` accumulates temp names
/// bound to a growth op (`.concat` or a delegate call) still awaiting
/// their one legal use (the recursive-call argument); a name is removed
/// once consumed. `edges` collects every delegate target discovered.
fn check_block(
    block: &Block,
    f: &FuncDef,
    param_name: &str,
    param_idx: usize,
    grow_temps: &mut HashSet<String>,
    edges: &mut Vec<Key>,
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
                if let Some((idx, callee)) = is_delegate_call_of(value, param_name, &f.name.0) {
                    let ExprKind::Call { args, .. } = &value.kind else {
                        unreachable!("is_delegate_call_of only matches ExprKind::Call")
                    };
                    let other_args_ok = args
                        .iter()
                        .enumerate()
                        .filter(|(j, _)| *j != idx)
                        .all(|(_, (_, arg))| !expr_references_any(arg, param_name, grow_temps));
                    if !other_args_ok {
                        return Use::Disqualified;
                    }
                    edges.push((callee, idx));
                    grow_temps.insert(name.0.clone());
                    continue;
                }
                if expr_references_any(value, param_name, grow_temps) {
                    return Use::Disqualified;
                }
            }
            StmtKind::Return(Some(e)) => {
                if let Use::Disqualified =
                    check_return_expr(e, f, param_name, param_idx, grow_temps, edges)
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
                    if check_block(then_block, f, param_name, param_idx, grow_temps, edges) == Use::Disqualified {
                        return Use::Disqualified;
                    }
                    if let Some(eb) = else_block
                        && check_block(eb, f, param_name, param_idx, grow_temps, edges) == Use::Disqualified {
                            return Use::Disqualified;
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
        return check_return_expr(ret, f, param_name, param_idx, grow_temps, edges);
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
    edges: &mut Vec<Key>,
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
        if check_block(then_block, f, param_name, param_idx, grow_temps, edges) == Use::Disqualified {
            return Use::Disqualified;
        }
        if let Some(eb) = else_block {
            return check_block(eb, f, param_name, param_idx, grow_temps, edges);
        }
        return Use::Safe;
    }
    if let ExprKind::Call { func, args } = &e.kind {
        if let ExprKind::Id(fname) = &func.kind
            && fname.0 == f.name.0 {
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
    if let ExprKind::MethodCall { target, method, args } = &value.kind
        && method.0 == "concat" && args.len() == 1
            && let ExprKind::Id(id) = &target.kind {
                return id.0 == param_name;
            }
    false
}

fn value_concat_arg(value: &Expr) -> &Expr {
    match &value.kind {
        ExprKind::MethodCall { args, .. } => &args[0],
        _ => value,
    }
}

/// `Some((idx, callee))` when `value` is a call to a function OTHER than
/// `self_name` with `param_name` appearing exactly once among its
/// arguments, at position `idx`. `None` for the self-recursive call
/// (handled separately in check_return_expr), for calls not referencing
/// param_name at all, or for param_name appearing more than once (too
/// unusual a shape to trust).
fn is_delegate_call_of(value: &Expr, param_name: &str, self_name: &str) -> Option<(usize, String)> {
    let ExprKind::Call { func, args } = &value.kind else {
        return None;
    };
    let ExprKind::Id(fname) = &func.kind else {
        return None;
    };
    if fname.0 == self_name {
        return None;
    }
    let mut found: Option<usize> = None;
    for (i, (_, arg)) in args.iter().enumerate() {
        if matches!(&arg.kind, ExprKind::Id(id) if id.0 == param_name) {
            if found.is_some() {
                return None;
            }
            found = Some(i);
        }
    }
    found.map(|i| (i, fname.0.clone()))
}

/// True if `e` references `param_name` anywhere, or references any name
/// still present in `live_temps` anywhere. Used for every context where
/// param_name (or a not-yet-consumed grow-temp) must simply not appear.
fn expr_references_any(e: &Expr, param_name: &str, live_temps: &HashSet<String>) -> bool {
    let mut found = false;
    walk_expr(e, &mut |sub| {
        if let ExprKind::Id(id) = &sub.kind
            && (id.0 == param_name || live_temps.contains(&id.0)) {
                found = true;
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
/// still-`valid` candidate, except a function's own verified recursive
/// self-call, must pass either a bare list literal, or (a sanctioned
/// delegation) the calling function's own tracked accumulator parameter
/// at exactly the position phase 1 recorded as delegating to this
/// candidate.
fn walk_calls_for_freshness(
    block: &Block,
    caller: &FuncDef,
    shapes: &HashMap<Key, Vec<Key>>,
    valid: &HashSet<Key>,
    caller_growable_param: Option<(usize, &str)>,
    disqualified: &mut HashSet<Key>,
) {
    walk_block(block, &mut |e| {
        if let ExprKind::Call { func, args } = &e.kind
            && let ExprKind::Id(fname) = &func.kind {
                let is_self_recursive_call = fname.0 == caller.name.0;
                for (i, (_, arg)) in args.iter().enumerate() {
                    let key = (fname.0.clone(), i);
                    if !valid.contains(&key) {
                        continue;
                    }
                    if is_self_recursive_call {
                        // Already fully verified by check_function_shape:
                        // it's either param_name or a consumed grow-temp.
                        continue;
                    }
                    if matches!(arg.kind, ExprKind::ListLit(_)) {
                        continue;
                    }
                    let is_sanctioned_delegation = match (&arg.kind, caller_growable_param) {
                        (ExprKind::Id(id), Some((cidx, cname))) if id.0 == cname => shapes
                            .get(&(caller.name.0.clone(), cidx))
                            .is_some_and(|edges| edges.contains(&key)),
                        _ => false,
                    };
                    if !is_sanctioned_delegation {
                        disqualified.insert(key);
                    }
                }
            }
    });
}
