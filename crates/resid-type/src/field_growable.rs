//! Field-growable analysis (Phase E.1 step 1 of `PLAN-resid-only.md`):
//! generalizes `growable.rs`'s bare-`List(T)`-parameter mechanism to a
//! `List(T)`-typed FIELD of a struct-typed parameter, by widening the
//! *tracked identity* `growable.rs` already checks everywhere from a bare
//! identifier to an access path (`param` or `param.field`). This is the
//! same invariant-based check as `growable.rs` (not a repeat of the
//! abandoned `struct_growable.rs` AST-shape-matcher — see
//! `PLAN-resid-only.md`'s "E.1 step 1" section for the full design
//! rationale and why that distinction matters): every reference to the
//! tracked path anywhere in the function is either a recognized safe use
//! or disqualifying, checked structurally, not by enumerating syntactic
//! shapes.
//!
//! **Deliberately decoupled from struct-box reuse.** This module only
//! answers "can this ONE `List(T)` field's buffer be grown in place,
//! independent of whether the struct wrapping it is reused." A grown
//! field's buffer can be handed off into a freshly-allocated struct of a
//! *different* type than the source parameter (see `pg_func` in the plan's
//! writeup) — that's still a real win (avoids the O(n) copy on every
//! `.concat`) even when no struct-box reuse applies at all.
//!
//! **Soundness bar, same as `growable.rs`**: never rejects a program — a
//! function/field pair that doesn't match is simply absent from the
//! returned set, and codegen falls back to always-copy, exactly as if this
//! analysis didn't run.
//!
//! Two shapes recognized, per `(function, param_idx, field)`:
//!
//! 1. **Straight-line growth** (`finish_ifexpr`-shaped): the field is grown
//!    via a chain of local `let`-bound `.concat` steps rooted at
//!    `param.field`, terminating in a return expression (of any type —
//!    the grown value may be handed into an unrelated struct's field).
//! 2. **Recursive growth** (`cap_enter_globals_at`-shaped): the same
//!    straight-line chain, but terminating by being rebuilt into a NEW
//!    struct literal of the SAME type as the tracked parameter (every
//!    other field of that literal a safe passthrough/recompute), which is
//!    then threaded to a recursive self-call at the same parameter
//!    position — mirrors `growable.rs`'s existing recursive-accumulator
//!    handling one level removed through the struct wrapper.

use std::collections::{HashMap, HashSet};

use resid_parser::{Block, Declaration, Expr, ExprKind, FuncDef, Stmt, StmtKind, TranslationUnit, Type, TypeBody};

type Key = (String, usize, String);

#[derive(Default)]
pub struct GrowableFields {
    growable: HashSet<Key>,
}

impl GrowableFields {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn is_growable(&self, func: &str, param_idx: usize, field: &str) -> bool {
        self.growable.contains(&(func.to_string(), param_idx, field.to_string()))
    }
}

pub fn find_growable_fields(unit: &TranslationUnit) -> GrowableFields {
    let flat = crate::reduce::flatten_unit(unit);
    let funcs: HashMap<&str, &FuncDef> = flat
        .iter()
        .filter_map(|d| match d {
            Declaration::Function(f) => Some((f.name.0.as_str(), f)),
            _ => None,
        })
        .collect();
    let structs: HashMap<&str, &Vec<(resid_parser::Id, Type)>> = flat
        .iter()
        .filter_map(|d| match d {
            Declaration::Type(td) => match &td.body {
                TypeBody::Product(fields) => Some((td.name.0.as_str(), fields)),
                _ => None,
            },
            _ => None,
        })
        .collect();

    let readonly_params = compute_readonly_params(&funcs);
    let never_escapes_bare = compute_never_escapes_bare(&funcs, &structs);

    let mut growable: HashSet<Key> = HashSet::new();
    for f in funcs.values() {
        for (i, p) in f.params.iter().enumerate() {
            let Type::Base { name: struct_name, params: None } = &p.type_ else {
                continue;
            };
            let Some(fields) = structs.get(struct_name.0.as_str()) else {
                continue;
            };
            for (field_id, field_ty) in fields.iter() {
                if !is_list_type(field_ty) {
                    continue;
                }
                if check_field_shape(
                    f,
                    &p.name.0,
                    i,
                    struct_name.0.as_str(),
                    &field_id.0,
                    &readonly_params,
                    &never_escapes_bare,
                ) {
                    growable.insert((f.name.0.clone(), i, field_id.0.clone()));
                }
            }
        }
    }
    GrowableFields { growable }
}

/// Whole-program: every `(function, param_idx)` whose struct-typed
/// parameter never appears bare anywhere in that function's own body
/// except as a pure pass-through tail return — see `gt_err` in the plan's
/// writeup. Scoped to struct-typed params only (the property is meaningful
/// for any struct, not just ones with a `List(T)` field).
fn compute_never_escapes_bare(
    funcs: &HashMap<&str, &FuncDef>,
    structs: &HashMap<&str, &Vec<(resid_parser::Id, Type)>>,
) -> HashSet<(String, usize)> {
    let mut out = HashSet::new();
    for f in funcs.values() {
        for (i, p) in f.params.iter().enumerate() {
            let Type::Base { name, params: None } = &p.type_ else {
                continue;
            };
            if !structs.contains_key(name.0.as_str()) {
                continue;
            }
            if base_never_escapes(&f.body, &p.name.0) {
                out.insert((f.name.0.clone(), i));
            }
        }
    }
    out
}

/// True if `param` never appears bare in `block` except as the exact tail
/// expression of a return (recursing through `if`/`else` arms) — any other
/// bare appearance (bound to another name, passed as a plain argument,
/// embedded in a literal, etc.) disqualifies. Field-access of `param` is
/// never "bare" and always allowed, anywhere.
fn base_never_escapes(block: &Block, param: &str) -> bool {
    for stmt in &block.statements {
        match &stmt.kind {
            StmtKind::Bind { value, .. } => {
                if bare_ref_anywhere(value, param) {
                    return false;
                }
            }
            StmtKind::Return(Some(e)) => {
                if !safe_tail_passthrough(e, param) {
                    return false;
                }
            }
            StmtKind::Return(None) | StmtKind::Break | StmtKind::Continue => {}
            StmtKind::Discard(e) | StmtKind::Expr(e) => {
                if let ExprKind::If { cond, then_block, else_block } = &e.kind {
                    if bare_ref_anywhere(cond, param) {
                        return false;
                    }
                    if !base_never_escapes(then_block, param) {
                        return false;
                    }
                    if let Some(eb) = else_block
                        && !base_never_escapes(eb, param)
                    {
                        return false;
                    }
                } else if bare_ref_anywhere(e, param) {
                    return false;
                }
            }
            StmtKind::Destructure { source, .. } => {
                if bare_ref_anywhere(source, param) {
                    return false;
                }
            }
        }
    }
    if let Some(ret) = &block.ret {
        return safe_tail_passthrough(ret, param);
    }
    true
}

fn safe_tail_passthrough(e: &Expr, param: &str) -> bool {
    if let ExprKind::Id(id) = &e.kind {
        return id.0 == param;
    }
    if let ExprKind::If { cond, then_block, else_block } = &e.kind {
        if bare_ref_anywhere(cond, param) {
            return false;
        }
        if !base_never_escapes(then_block, param) {
            return false;
        }
        if let Some(eb) = else_block {
            return base_never_escapes(eb, param);
        }
        return true;
    }
    !bare_ref_anywhere(e, param)
}

/// True if `param` appears anywhere in `e` other than as the target of a
/// `.field` access.
fn bare_ref_anywhere(e: &Expr, param: &str) -> bool {
    match &e.kind {
        ExprKind::FieldAccess { target, .. } => {
            if matches!(&target.kind, ExprKind::Id(id) if id.0 == param) {
                false
            } else {
                bare_ref_anywhere(target, param)
            }
        }
        ExprKind::Id(id) => id.0 == param,
        _ => {
            let mut found = false;
            each_child(e, &mut |c| {
                if !found && bare_ref_anywhere(c, param) {
                    found = true;
                }
            });
            found
        }
    }
}

/// Whole-program: every `(function, param_idx)` whose `List(T)` parameter
/// is used only via `.len()` or indexing in that function's own body —
/// never stored, returned bare, or passed to yet another call. Lets a
/// tracked field be handed whole into such a call without breaking its
/// uniqueness proof. Deliberately one level deep (doesn't recurse through
/// further calls the callee itself makes) — sufficient for the real cases
/// motivating this (`last_label_line_cg`), and erring on the side of not
/// recognizing a case is always safe here (falls back to disqualifying,
/// never to unsoundness).
fn compute_readonly_params(funcs: &HashMap<&str, &FuncDef>) -> HashSet<(String, usize)> {
    let mut out = HashSet::new();
    for f in funcs.values() {
        for (i, p) in f.params.iter().enumerate() {
            if is_list_type(&p.type_) && param_used_readonly(&f.body, &p.name.0) {
                out.insert((f.name.0.clone(), i));
            }
        }
    }
    out
}

fn param_used_readonly(body: &Block, param: &str) -> bool {
    let mut ok = true;
    scan_readonly_block(body, param, &mut ok);
    ok
}

fn scan_readonly_block(block: &Block, param: &str, ok: &mut bool) {
    for stmt in &block.statements {
        each_child_stmt(stmt, &mut |e| scan_readonly_expr(e, param, ok));
    }
    if let Some(ret) = &block.ret {
        scan_readonly_expr(ret, param, ok);
    }
}

fn scan_readonly_expr(e: &Expr, param: &str, ok: &mut bool) {
    if !*ok {
        return;
    }
    match &e.kind {
        ExprKind::MethodCall { target, method, args } => {
            let bare_param = matches!(&target.kind, ExprKind::Id(id) if id.0 == param);
            if bare_param {
                if method.0 != "len" || !args.is_empty() {
                    *ok = false;
                }
            } else {
                scan_readonly_expr(target, param, ok);
            }
            for a in args {
                scan_readonly_expr(a, param, ok);
            }
        }
        ExprKind::Index { target, index } => {
            if !matches!(&target.kind, ExprKind::Id(id) if id.0 == param) {
                scan_readonly_expr(target, param, ok);
            }
            scan_readonly_expr(index, param, ok);
        }
        ExprKind::Id(id) if id.0 == param => {
            *ok = false;
        }
        _ => each_child(e, &mut |c| scan_readonly_expr(c, param, ok)),
    }
}

fn is_list_type(t: &Type) -> bool {
    matches!(t, Type::Base { name, .. } if name.0 == "List")
}

/// Whether `base` — the tracked struct parameter — and the returned/final
/// values of a straight-line-or-recursive walk over `f`'s body respect the
/// field-growth shape for `field`. `base_ty` is `base`'s declared struct
/// type (needed to recognize a valid same-type rebuild in the recursive
/// case).
fn check_field_shape(
    f: &FuncDef,
    base: &str,
    base_idx: usize,
    base_ty: &str,
    field: &str,
    readonly_params: &HashSet<(String, usize)>,
    never_escapes_bare: &HashSet<(String, usize)>,
) -> bool {
    let mut saw_field = false;
    walk_expr_in_block(&f.body, &mut |e| {
        if let ExprKind::FieldAccess { target, field: fld } = &e.kind
            && fld.0 == field
                && matches!(&target.kind, ExprKind::Id(id) if id.0 == base) {
                    saw_field = true;
                }
    });
    if !saw_field {
        return false;
    }
    let mut st = State {
        base,
        base_idx,
        base_ty,
        field,
        list_temps: HashSet::new(),
        obj_temps: HashSet::new(),
        readonly_params,
        never_escapes_bare,
    };
    if check_block(&f.body, f, &mut st) != Use::Safe {
        return false;
    }
    st.list_temps.is_empty() && st.obj_temps.is_empty()
}

struct State<'a> {
    base: &'a str,
    base_idx: usize,
    base_ty: &'a str,
    field: &'a str,
    /// Names bound to an in-progress `.concat` chain rooted at
    /// `base.field`, awaiting either further growth or final consumption.
    list_temps: HashSet<String>,
    /// Names bound to a same-type rebuild of `base` (a "next generation"
    /// of the tracked object), awaiting consumption by a recursive
    /// self-call or a return.
    obj_temps: HashSet<String>,
    /// Whole-program: `(function, param_idx)` pairs proven to use that
    /// `List(T)` parameter read-only (only `.len()`/indexing, never stored
    /// or passed onward) — lets a tracked field be passed whole into such
    /// a call without breaking its uniqueness proof (see
    /// `last_label_line_cg` in the plan's writeup).
    readonly_params: &'a HashSet<(String, usize)>,
    /// Whole-program: `(function, param_idx)` pairs whose struct-typed
    /// parameter never escapes bare within that function's own body (only
    /// field-accessed, or passed through unchanged at a tail return) — see
    /// `gt_err` in the plan's writeup. A function may hand `base`/an
    /// `obj_temp` whole to such a parameter (at any call position, not
    /// just tail) without breaking uniqueness: the callee is proven to
    /// never retain it beyond deriving its own return value.
    never_escapes_bare: &'a HashSet<(String, usize)>,
}

/// Whether `args` contains `base` (or a live `obj_temp`) at exactly one
/// position `k`, where `(callee, k)` is a proven never-escapes-bare
/// parameter, and every other argument doesn't bare-reference tracked
/// state. On success, returns the consumed name (to remove from
/// `obj_temps`) — `None` for `base` itself (nothing to remove).
fn try_delegate_consume(callee: &str, args: &[(Option<resid_parser::Id>, Expr)], st: &State) -> Option<Option<String>> {
    let mut found: Option<(usize, Option<String>)> = None;
    for (i, (_, a)) in args.iter().enumerate() {
        let candidate = match &a.kind {
            ExprKind::Id(id) if id.0 == st.base => Some(None),
            ExprKind::Id(id) if st.obj_temps.contains(&id.0) => Some(Some(id.0.clone())),
            _ => None,
        };
        if let Some(c) = candidate {
            if found.is_some() {
                return None; // base/obj_temp appears more than once: too unusual, decline
            }
            found = Some((i, c));
        }
    }
    let (idx, consumed) = found?;
    if !st.never_escapes_bare.contains(&(callee.to_string(), idx)) {
        return None;
    }
    for (i, (_, a)) in args.iter().enumerate() {
        if i != idx && expr_references_tracked(a, st) {
            return None;
        }
    }
    Some(consumed)
}

#[derive(PartialEq)]
enum Use {
    Safe,
    Disqualified,
}

fn check_block(block: &Block, f: &FuncDef, st: &mut State) -> Use {
    for stmt in &block.statements {
        match &stmt.kind {
            StmtKind::Bind { name, value, .. } => {
                if let Some(consumed) = concat_chain_growth(value, st) {
                    if let Some(t) = consumed {
                        st.list_temps.remove(&t);
                    }
                    st.list_temps.insert(name.0.clone());
                    continue;
                }
                if let Some(consumed) = try_object_rebuild(value, st) {
                    if let Some(t) = consumed {
                        st.list_temps.remove(&t);
                    }
                    st.obj_temps.insert(name.0.clone());
                    continue;
                }
                if let ExprKind::Call { func, args } = &value.kind
                    && let ExprKind::Id(fname) = &func.kind
                    && fname.0 != f.name.0
                    && let Some(consumed) = try_delegate_consume(&fname.0, args, st)
                {
                    if let Some(t) = consumed {
                        st.obj_temps.remove(&t);
                    }
                    // The delegate's return value isn't itself tracked
                    // further (it may not even share `base_ty`) — `name`
                    // is just an ordinary binding from here on.
                    continue;
                }
                if expr_references_tracked(value, st) {
                    return Use::Disqualified;
                }
            }
            StmtKind::Return(Some(e)) => {
                if check_return_expr(e, f, st) == Use::Disqualified {
                    return Use::Disqualified;
                }
            }
            StmtKind::Return(None) => {}
            StmtKind::Discard(e) | StmtKind::Expr(e) => {
                if let ExprKind::If { cond, then_block, else_block } = &e.kind {
                    if expr_references_tracked(cond, st) {
                        return Use::Disqualified;
                    }
                    if check_block(then_block, f, st) == Use::Disqualified {
                        return Use::Disqualified;
                    }
                    if let Some(eb) = else_block
                        && check_block(eb, f, st) == Use::Disqualified {
                            return Use::Disqualified;
                        }
                    continue;
                }
                if expr_references_tracked(e, st) {
                    return Use::Disqualified;
                }
            }
            StmtKind::Destructure { source, .. } => {
                if expr_references_tracked(source, st) {
                    return Use::Disqualified;
                }
            }
            StmtKind::Break | StmtKind::Continue => {}
        }
    }
    if let Some(ret) = &block.ret {
        return check_return_expr(ret, f, st);
    }
    Use::Safe
}

fn check_return_expr(e: &Expr, f: &FuncDef, st: &mut State) -> Use {
    if let ExprKind::Id(id) = &e.kind {
        if id.0 == st.base {
            return Use::Safe; // pass-through: whole object returned unchanged
        }
        if st.obj_temps.remove(&id.0) {
            return Use::Safe; // a rebuilt generation returned directly
        }
        if st.list_temps.contains(&id.0) {
            // A grown field value must be wrapped back into an object
            // before crossing a function boundary, never returned bare.
            return Use::Disqualified;
        }
        return Use::Safe;
    }
    if let ExprKind::If { cond, then_block, else_block } = &e.kind {
        if expr_references_tracked(cond, st) {
            return Use::Disqualified;
        }
        if check_block(then_block, f, st) == Use::Disqualified {
            return Use::Disqualified;
        }
        if let Some(eb) = else_block {
            return check_block(eb, f, st);
        }
        return Use::Safe;
    }
    if let ExprKind::StructLit { fields, .. } = &e.kind {
        if let Some(consumed) = try_object_rebuild(e, st) {
            if let Some(t) = consumed {
                st.list_temps.remove(&t);
            }
            return Use::Safe;
        }
        // A struct literal of some OTHER type: still fine to hand off a
        // grown buffer into one of its fields (the whole point of
        // decoupling growth from struct-box identity — see `pg_func` in
        // the plan). At most one field may consume a live list_temp;
        // every other field must not bare-reference tracked state.
        let mut consumed: Option<String> = None;
        let mut ok = true;
        for (_, fval) in fields {
            if let ExprKind::Id(id) = &fval.kind
                && st.list_temps.contains(&id.0)
            {
                if consumed.is_some() {
                    ok = false;
                    break;
                }
                consumed = Some(id.0.clone());
                continue;
            }
            if let Some(inner) = concat_chain_growth(fval, st) {
                if let Some(t) = inner {
                    if consumed.is_some() {
                        ok = false;
                        break;
                    }
                    consumed = Some(t);
                }
                continue;
            }
            if expr_references_tracked(fval, st) {
                ok = false;
                break;
            }
        }
        if ok {
            if let Some(t) = consumed {
                st.list_temps.remove(&t);
            }
            return Use::Safe;
        }
        return Use::Disqualified;
    }
    if let ExprKind::Call { func, args } = &e.kind
        && let ExprKind::Id(fname) = &func.kind
        && fname.0 == f.name.0
    {
        // Recursive self-call: the argument at base_idx must be base
        // itself (trivial pass-through) or a still-live obj_temp
        // (consuming a rebuilt generation); every other argument must not
        // reference base, an obj_temp, or a live list_temp.
        if args.len() != f.params.len() {
            return Use::Disqualified;
        }
        for (i, (_, arg)) in args.iter().enumerate() {
            if i == st.base_idx {
                match &arg.kind {
                    ExprKind::Id(id) if id.0 == st.base => {}
                    ExprKind::Id(id) if st.obj_temps.remove(&id.0) => {}
                    _ => return Use::Disqualified,
                }
            } else if expr_references_tracked(arg, st) {
                return Use::Disqualified;
            }
        }
        return Use::Safe;
    }
    if let ExprKind::Call { func, args } = &e.kind
        && let ExprKind::Id(fname) = &func.kind
        && fname.0 != f.name.0
        && let Some(consumed) = try_delegate_consume(&fname.0, args, st)
    {
        // Handing the whole tracked object to a proven never-escapes-bare
        // parameter of another function, directly at the tail (see
        // `gt_err` in the plan's writeup): finish_ifexpr's own return
        // value simply becomes whatever the delegate produces, so no
        // further tracking of `base`/the consumed `obj_temp` is needed.
        if let Some(t) = consumed {
            st.obj_temps.remove(&t);
        }
        return Use::Safe;
    }
    // Any other tail expression (including a rebuild-typed literal fed to
    // some other function, or a plain value): safe as long as it doesn't
    // bare-reference the tracked base/temps. A struct-literal rebuild used
    // directly here (not bound to a name first) is intentionally not
    // recognized — every real example threads it through a local bind
    // first; support can be added if a real case needs it.
    if expr_references_tracked(e, st) {
        return Use::Disqualified;
    }
    Use::Safe
}

/// Recognizes `value` as a (possibly multi-step, chained in one
/// expression via nested `.concat` calls with no intermediate `let`) growth
/// of the tracked field: `base.field.concat(a).concat(b)...`, or the same
/// rooted at a live `list_temp` instead of `base.field`. Every argument
/// along the chain must not reference tracked state.
///
/// - `None` if `value` isn't shaped as a concat chain at all (caller
///   should fall through to the generic reference check).
/// - `Some(None)` if it's a valid chain rooted at `base.field` directly
///   (nothing consumed).
/// - `Some(Some(temp))` if it's a valid chain rooted at a live `list_temp`
///   (caller must remove `temp` from `list_temps`).
///
/// A chain with a disqualifying argument is reported as rooted-but-invalid
/// by returning `Some(None)` with the caller separately finding the bad
/// argument via the generic check — instead, to keep this unambiguous, an
/// invalid argument anywhere in the chain makes this return `None` (not a
/// recognized growth) so the generic `expr_references_tracked` check on
/// the whole expression below correctly disqualifies it.
fn concat_chain_growth(value: &Expr, st: &State) -> Option<Option<String>> {
    fn root<'a>(e: &'a Expr, st: &State, args: &mut Vec<&'a Expr>) -> Option<Option<String>> {
        if let ExprKind::MethodCall { target, method, args: call_args } = &e.kind {
            if method.0 == "concat" && call_args.len() == 1 {
                let inner = root(target, st, args)?;
                args.push(&call_args[0]);
                return Some(inner);
            }
            return None;
        }
        match &e.kind {
            ExprKind::FieldAccess { target, field } if field.0 == st.field => {
                if matches!(&target.kind, ExprKind::Id(id) if id.0 == st.base) {
                    Some(None)
                } else {
                    None
                }
            }
            ExprKind::Id(id) if st.list_temps.contains(&id.0) => Some(Some(id.0.clone())),
            _ => None,
        }
    }
    let mut chain_args = Vec::new();
    let consumed = root(value, st, &mut chain_args)?;
    // Zero-length chain (`Type d0 = base.field;`, no `.concat` yet in this
    // statement) is a valid rename/alias step — subsequent statements may
    // grow it further. `root` already confirmed it resolves back to
    // `base.field` or a live temp, which is exactly what makes it safe.
    if chain_args.iter().any(|a| expr_references_tracked(a, st)) {
        return None;
    }
    Some(consumed)
}

/// Whether `value` is a well-formed same-type rebuild of `base`: a
/// `StructLit` naming `base_ty`, where the tracked field's value is a
/// (possibly inline) growth chain rooted at `base.field`/a live list_temp,
/// or a plain passthrough `base.field`, and every other field doesn't
/// bare-reference `base` or any live temp (reading base's OTHER fields is
/// fine). Returns `Some(consumed_temp)` on success — caller removes the
/// temp from `list_temps` if present.
fn try_object_rebuild(value: &Expr, st: &State) -> Option<Option<String>> {
    let ExprKind::StructLit { name, fields } = &value.kind else {
        return None;
    };
    if name.0 != st.base_ty {
        return None;
    }
    let mut consumed_temp: Option<String> = None;
    for (fname, fval) in fields {
        if fname.0 == st.field {
            if let Some(consumed) = concat_chain_growth(fval, st) {
                consumed_temp = consumed;
                continue;
            }
            match &fval.kind {
                ExprKind::FieldAccess { target, field } if field.0 == st.field => {
                    if matches!(&target.kind, ExprKind::Id(id) if id.0 == st.base) {
                        continue; // passthrough, no growth this generation
                    }
                    return None;
                }
                _ => return None,
            }
        }
        if expr_references_tracked(fval, st) {
            return None;
        }
    }
    Some(consumed_temp)
}

/// True if `e` bare-references `base` (i.e. as something other than the
/// target of a `.field` access), or references any live `list_temps`/
/// `obj_temps` name (obj_temps are also only safe when field-accessed;
/// list_temps are never safe to reference except through the recognized
/// concat/rebuild sites already handled above).
///
/// Unlike the generic `walk_expr`-based scans, this does NOT descend into
/// the target of a `FieldAccess` once it's recognized as a safe read of
/// the tracked object — descending further would re-flag the very `Id`
/// that access safely projects out of.
fn expr_references_tracked(e: &Expr, st: &State) -> bool {
    let mut found = false;
    scan(e, st, &mut found);
    found
}

/// True when `e` is exactly a field access of the tracked object's
/// tracked field (`base.field` / `obj_temp.field`) — the one access
/// pattern that needs a *specific* recognized safe context (builtin
/// read-only op, or a proven-read-only callee parameter), unlike any
/// OTHER field of the tracked object, which is always safe to read.
fn is_tracked_field_access(e: &Expr, st: &State) -> bool {
    matches!(&e.kind, ExprKind::FieldAccess { target, field }
        if field.0 == st.field
            && matches!(&target.kind, ExprKind::Id(id) if id.0 == st.base || st.obj_temps.contains(&id.0)))
}

fn scan(e: &Expr, st: &State, found: &mut bool) {
    if *found {
        return;
    }
    match &e.kind {
        ExprKind::FieldAccess { target, field } => {
            let is_tracked_obj = matches!(&target.kind, ExprKind::Id(id) if id.0 == st.base || st.obj_temps.contains(&id.0));
            if is_tracked_obj && field.0 != st.field {
                return; // safe: reading an unrelated field of the tracked object
            }
            if is_tracked_obj {
                // Bare appearance of the tracked field itself outside a
                // recognized context (concat receiver / rebuild consumer
                // are matched before `scan` ever runs; `.len()`/index/
                // read-only-callee are matched below in the MethodCall/
                // Index/Call arms before recursing into their target or
                // args) — reaching here means an unrecognized use.
                *found = true;
                return;
            }
            each_child(e, &mut |c| scan(c, st, found));
        }
        ExprKind::MethodCall { target, method, args } => {
            let builtin_readonly_on_tracked_field =
                is_tracked_field_access(target, st) && method.0 == "len" && args.is_empty();
            if !builtin_readonly_on_tracked_field {
                scan(target, st, found);
            }
            for a in args {
                scan(a, st, found);
            }
        }
        ExprKind::Index { target, index } => {
            if !is_tracked_field_access(target, st) {
                scan(target, st, found);
            }
            scan(index, st, found);
        }
        ExprKind::Call { func, args } => {
            let callee = match &func.kind {
                ExprKind::Id(fname) => Some(fname.0.as_str()),
                _ => None,
            };
            for (i, (_, a)) in args.iter().enumerate() {
                if is_tracked_field_access(a, st)
                    && callee.is_some_and(|c| st.readonly_params.contains(&(c.to_string(), i)))
                {
                    continue; // proven read-only at the callee: safe hand-off
                }
                scan(a, st, found);
            }
            scan(func, st, found);
        }
        ExprKind::Id(id) => {
            if id.0 == st.base || st.list_temps.contains(&id.0) || st.obj_temps.contains(&id.0) {
                *found = true;
            }
        }
        _ => each_child(e, &mut |c| scan(c, st, found)),
    }
}

/// Visits `e`'s immediate child expressions (one level, not transitively —
/// `scan` recurses by calling this at each level itself), mirroring every
/// `Expr`-holding position `walk_expr` handles.
fn each_child<'a>(e: &'a Expr, f: &mut impl FnMut(&'a Expr)) {
    match &e.kind {
        ExprKind::Id(_)
        | ExprKind::Literal(_)
        | ExprKind::Location
        | ExprKind::RawString(_)
        | ExprKind::ByteString(_)
        | ExprKind::Todo(_)
        | ExprKind::Unimplemented(_) => {}
        ExprKind::BinaryOp { lhs, rhs, .. } => {
            f(lhs);
            f(rhs);
        }
        ExprKind::UnaryOp { operand, .. } => f(operand),
        ExprKind::Cast { operand, .. } => f(operand),
        ExprKind::Call { func, args } => {
            f(func);
            for (_, a) in args {
                f(a);
            }
        }
        ExprKind::Rt(inner) | ExprKind::AtResidual { inner, .. } => f(inner),
        ExprKind::If { cond, then_block, else_block } => {
            f(cond);
            each_child_block(then_block, f);
            if let Some(eb) = else_block {
                each_child_block(eb, f);
            }
        }
        ExprKind::While { cond, body } => {
            f(cond);
            each_child_block(body, f);
        }
        ExprKind::ForIn { collection, body, .. } => {
            f(collection);
            each_child_block(body, f);
        }
        ExprKind::Match { scrutinee, arms } => {
            f(scrutinee);
            for (_, e) in arms {
                f(e);
            }
        }
        ExprKind::For { init, cond, step, body } => {
            if let Some(s) = init {
                each_child_stmt(s, f);
            }
            f(cond);
            if let Some(s) = step {
                each_child_stmt(s, f);
            }
            each_child_block(body, f);
        }
        ExprKind::Spawn { body, .. } => each_child_block(body, f),
        ExprKind::Assert { cond, message } | ExprKind::RtAssert { cond, message } => {
            f(cond);
            f(message);
        }
        ExprKind::Known(inner) | ExprKind::RtKnown(inner) | ExprKind::ComptimePrint(inner) => f(inner),
        ExprKind::StructLit { fields, .. } => {
            for (_, v) in fields {
                f(v);
            }
        }
        ExprKind::ListLit(elems) | ExprKind::SetLit(elems) => {
            for e in elems {
                f(e);
            }
        }
        ExprKind::MapLit(entries) => {
            for (k, v) in entries {
                f(k);
                f(v);
            }
        }
        ExprKind::Range { start, end, .. } => {
            f(start);
            f(end);
        }
        ExprKind::FString(parts) => {
            for p in parts {
                if let resid_parser::FStringPart::Expr(e) = p {
                    f(e);
                }
            }
        }
        ExprKind::FieldAccess { target, .. } => f(target),
        ExprKind::Index { target, index } => {
            f(target);
            f(index);
        }
        ExprKind::Slice { target, range } => {
            f(target);
            if let Some(s) = &range.start {
                f(s);
            }
            if let Some(en) = &range.end {
                f(en);
            }
        }
        ExprKind::MethodCall { target, args, .. } => {
            f(target);
            for a in args {
                f(a);
            }
        }
        ExprKind::EarlyReturn(inner) => f(inner),
        ExprKind::ElseFallback { value, fallback } => {
            f(value);
            each_child_block(fallback, f);
        }
        ExprKind::Destructure { source, .. } => f(source),
        ExprKind::IfLet { source, then_block, else_block, .. } => {
            f(source);
            each_child_block(then_block, f);
            if let Some(eb) = else_block {
                each_child_block(eb, f);
            }
        }
        ExprKind::WhileLet { source, body, .. } => {
            f(source);
            each_child_block(body, f);
        }
        ExprKind::Using { value, .. } => f(value),
        ExprKind::With { bindings, body } => {
            for b in bindings {
                f(&b.init);
            }
            each_child_block(body, f);
        }
        ExprKind::ProviderCall { args, .. } => {
            for a in args {
                f(a);
            }
        }
        ExprKind::Discard(inner) => f(inner),
    }
}

fn each_child_block<'a>(block: &'a Block, f: &mut impl FnMut(&'a Expr)) {
    for stmt in &block.statements {
        each_child_stmt(stmt, f);
    }
    if let Some(ret) = &block.ret {
        f(ret);
    }
}

fn each_child_stmt<'a>(stmt: &'a Stmt, f: &mut impl FnMut(&'a Expr)) {
    match &stmt.kind {
        StmtKind::Bind { value, .. } => f(value),
        StmtKind::Discard(e) | StmtKind::Expr(e) => f(e),
        StmtKind::Return(Some(e)) => f(e),
        StmtKind::Return(None) | StmtKind::Break | StmtKind::Continue => {}
        StmtKind::Destructure { source, .. } => f(source),
    }
}

/// Like `walk_expr` but skips descending into a `FieldAccess`'s target
/// when reporting to the caller doesn't matter here — used only for the
/// initial "does this field get accessed at all" presence scan, so a
/// plain full walk (calling `f` on every sub-expression) is fine.
fn walk_expr_in_block<'a>(block: &'a Block, f: &mut impl FnMut(&'a Expr)) {
    walk_block(block, f);
}

// --- Generic AST walkers (mirrors growable.rs's; kept local since
// growable.rs's own copies are private to that module) ---

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

#[cfg(test)]
mod tests {
    use super::*;
    use resid_parser::Parser;

    fn analyze(src: &str) -> GrowableFields {
        let (unit, errs) = Parser::parse("test.resid", src);
        assert!(errs.is_empty(), "parse errors: {errs:?}");
        find_growable_fields(&unit)
    }

    /// `cap_enter_globals_at`-shaped: recursive accumulator, struct field
    /// grown via one concat step, rebuilt into the same struct type, fed
    /// to the recursive self-call.
    #[test]
    fn recursive_struct_field_growth_recognized() {
        let src = r#"
            type CapPP = { List(Str) lines; List(Str) glines; Int n; };

            CapPP cap_enter_globals_at(List(Str) caps, Int i, CapPP acc) {
                if (i >= caps.len()) { return acc; }
                Str gl = caps[i];
                CapPP acc2 = CapPP { .lines = acc.lines, .glines = acc.glines.concat([gl]), .n = acc.n + 1 };
                Int k = i + 1;
                return cap_enter_globals_at(caps, k, acc2);
            }
        "#;
        let g = analyze(src);
        assert!(g.is_growable("cap_enter_globals_at", 2, "glines"));
        // `lines` is threaded unchanged (pure passthrough) every
        // generation — no `.concat` ever touches it, but it's still sound
        // to mark it "growable": a single buffer, never reallocated, is a
        // degenerate case of the same in-place-identity proof.
        assert!(g.is_growable("cap_enter_globals_at", 2, "lines"));
    }

    /// `finish_ifexpr`-shaped: straight-line (non-recursive) function,
    /// field grown via a chain of local concat steps, consumed directly by
    /// the final return (not wrapped back into a same-type rebuild).
    #[test]
    fn straight_line_field_growth_recognized() {
        let src = r#"
            type GT = { Str val; Str ty; List(Str) glines; List(Str) lines; Int tmp; };

            GT finish_ifexpr(GT tv, GT ev) {
                if (ev.ty != tv.ty) { return ev; }
                List(Str) d0 = ev.lines;
                List(Str) d1 = d0.concat(["br"]);
                List(Str) d2 = d1.concat(["label:"]);
                return GT { .val = tv.val, .ty = tv.ty, .glines = ev.glines, .lines = d2, .tmp = ev.tmp };
            }
        "#;
        let g = analyze(src);
        assert!(g.is_growable("finish_ifexpr", 1, "lines"));
        // tv is read only via field access but never grown; not claimed.
        assert!(!g.is_growable("finish_ifexpr", 0, "lines"));
    }

    /// `pg_func`-shaped: the grown field is handed off into a
    /// freshly-allocated struct of a DIFFERENT type than the source
    /// parameter. Must still be recognized — this is the whole point of
    /// decoupling field growth from struct-box identity.
    #[test]
    fn growth_handed_off_to_different_struct_type_recognized() {
        let src = r#"
            type CapPP = { List(Str) lines; List(Str) glines; Int n; };
            type PG = { List(Str) lines; List(Str) glines; Int tmp; };

            PG merge_into_pg(CapPP pp1, CapPP pp2, Int t) {
                List(Str) lns = pp1.lines.concat(pp2.lines).concat(["}"]);
                return PG { .lines = lns, .glines = pp2.glines, .tmp = t };
            }
        "#;
        let g = analyze(src);
        assert!(g.is_growable("merge_into_pg", 0, "lines"));
    }

    /// Disqualifying case: the base struct escapes bare (passed whole to
    /// another function) — must never be claimed growable.
    #[test]
    fn escaping_base_disqualified() {
        let src = r#"
            type CapPP = { List(Str) lines; Int n; };

            CapPP leaks(CapPP acc) {
                CapPP other = stash(acc);
                List(Str) d = acc.lines.concat(["x"]);
                return CapPP { .lines = d, .n = acc.n };
            }
        "#;
        let g = analyze(src);
        assert!(!g.is_growable("leaks", 0, "lines"));
    }

    /// Real bug caught validating against `examples/codegen.resid`: the
    /// tracked field passed *whole* to a read-only accessor
    /// (`last_label_line_cg`-shaped: only `.len()`/indexing, returns a
    /// derived scalar) must not disqualify growth, but passing it to an
    /// UNPROVEN function must.
    #[test]
    fn readonly_accessor_call_does_not_disqualify() {
        let src = r#"
            type GT = { List(Str) lines; Str val; };

            Str last_label_line_cg(List(Str) lines, Str fallback) {
                Int n = lines.len();
                if (n < 1) { return fallback; }
                return lines[n - 1];
            }

            GT finish_ifexpr(GT ev, Str ld) {
                Str pt = last_label_line_cg(ev.lines, ld);
                List(Str) d = ev.lines.concat([pt]);
                return GT { .lines = d, .val = pt };
            }
        "#;
        let g = analyze(src);
        assert!(g.is_growable("finish_ifexpr", 0, "lines"));
    }

    /// Same shape, but the callee stores the parameter into a return value
    /// / another structure instead of just reading it — must disqualify.
    #[test]
    fn non_readonly_accessor_call_disqualifies() {
        let src = r#"
            type GT = { List(Str) lines; Str val; };
            type Box = { List(Str) l; };

            Box wrap(List(Str) lines) {
                return Box { .l = lines };
            }

            GT finish_ifexpr(GT ev, Str ld) {
                Box b = wrap(ev.lines);
                List(Str) d = ev.lines.concat([ld]);
                return GT { .lines = d, .val = ld };
            }
        "#;
        let g = analyze(src);
        assert!(!g.is_growable("finish_ifexpr", 0, "lines"));
    }
}
