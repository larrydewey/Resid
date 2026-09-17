//! General compile-time ownership / last-use analysis (Phase E.1 step 2 of
//! `PLAN-resid-only.md`). This is the "real dataflow computation, not shape
//! enumeration" the plan calls for: a single oracle,
//! `is_last_unique_use(&Expr) -> bool`, answering "is this specific syntactic
//! occurrence of a binding its last, uniquely-owned use" for **every heap
//! type uniformly** (List, Map, Set, Struct) and for **every root binding**
//! (function parameter OR local `let`) — not just parameters
//! ([`crate::growable`]) or struct-fields-of-parameters
//! ([`crate::field_growable`]).
//!
//! **Coexists with, does not yet replace,** `growable.rs`/`field_growable.rs`
//! (see `PLAN-resid-only.md`'s Locked decisions: one general mechanism, not
//! two — but only *after* this module is proven to strictly subsume both).
//! This module is standalone and unwired; nothing in codegen consumes it yet.
//!
//! ## What's covered
//!
//! - **Content growth**: a `List`/`Map`/`Set`-typed root (a bare binding, or
//!   a field of a struct-typed binding) grown via a chain of local
//!   `let`-bound calls to a type-appropriate growth method (`concat` for
//!   List; `insert`/`remove` for Map/Set), generalizing
//!   `field_growable.rs`'s access-path idea to **any** root, not just struct
//!   parameters.
//! - **Struct-box reuse** (`field_growable.rs`'s "mechanism A", previously
//!   unbuilt): a struct-typed root rebuilt via a same-type struct literal.
//! - **Roots**: function parameters *and* local `let` bindings (the
//!   concretely-identified gap in `field_growable.rs`'s checklist entry —
//!   `pg_func`'s `pp1`/`pp2` are locals, not parameters).
//! - **Terminal (reuse-relevant) consumption sites**: a return/tail
//!   pass-through, a self-recursive call at the same parameter slot, or a
//!   hand-off into a freshly-built container of a *different* type
//!   (`StructLit`/`ListLit`/`MapLit`/`SetLit`) — at **any** statement
//!   position, not just tail (a real generalization over both existing
//!   modules, which only recognized this shape at a block's tail
//!   expression).
//! - **Safe non-consuming reads**: field access to any *other* field,
//!   `.len()`/index/`.get()`/`.contains()`, and passing the tracked value
//!   whole to a function whose parameter at that position is
//!   whole-program-proven `ReadOnly` or `NeverEscapesBare` — generalizing
//!   both whole-program facts beyond `field_growable.rs`'s List/struct-only
//!   scope.
//!
//! ## What's deliberately NOT covered (documented, not silently wrong)
//!
//! - **Sum types.** Recognizing a sum-variant constructor call
//!   (`Some(x)`-shaped) requires resolved type information to distinguish it
//!   from an ordinary function call; this module stays at the same
//!   lightweight, type-annotation-only level as `growable.rs`/
//!   `field_growable.rs`. A sum-typed root is simply never discovered, so it
//!   always falls back to today's always-copy behavior — never unsound,
//!   just not optimized.
//! - **Cross-function delegation** (a chain handed to a *different*
//!   function's own independently-tracked growth root, continuing to grow
//!   the same buffer there — see `growable.rs`'s `ctr_xor`/`ctr_take`
//!   docstring example). Would need the same whole-program delegation
//!   fixpoint `growable.rs` already has for its narrower case; not
//!   duplicated here. Handing the tracked value to a *non-retaining*
//!   (`ReadOnly`/`NeverEscapesBare`) function is covered (see above) — only
//!   growth-continuing delegation is out of scope.
//! - **Loops and `match`.** Mirrors existing precedent exactly: a tracked
//!   root referenced inside a `while`/`for`/`forIn`/`match` body simply
//!   disqualifies that root (falls through to the generic reference check),
//!   the same conservative behavior `growable.rs`/`field_growable.rs` already
//!   have for these constructs.
//! - **Whole-program call-site ownership for PARAMETER roots (Perceus
//!   moves).** A parameter root is uniquely owned on entry if every call
//!   hands its slot a fresh literal, an **owned call result**, or a
//!   **last-use** argument ([`crate::liveness::last_uses`]) — Perceus's
//!   `dup`/move discipline: the caller keeps no reference to a moved value,
//!   so nothing is aliased. A non-last-use `Id` argument would need a
//!   caller-side `dup` and therefore disqualifies the root (until codegen
//!   emits those dups). Treating call results as owned is the Perceus rule
//!   (a callee returns an owned value and `dup`s anything it returns without
//!   consuming); it carries the symmetric return-`dup` obligation on the
//!   still-unwired codegen. A `base.field` argument is also a move when the
//!   base `Id` is at its last use — consuming the struct consumes its
//!   fields. **Local roots do not have this gap**: nothing
//!   outside a function can reference a local, so a local root's validity is
//!   fully self-contained.
//!
//! None of the above is a soundness gap in what this module *does* claim —
//! each is a case the analysis declines to recognize, which only means a
//! missed optimization, never a wrong answer (same bar as both existing
//! modules). The parameter-root ownership check is the precondition for
//! safely *wiring* parameter-root results into codegen; it is now the
//! Perceus `dup`/move rule above rather than the earlier literal-only gate.
//!
//! ## Design note: why occurrences are keyed by source span, not AST pointer
//!
//! Like `growable.rs`/`field_growable.rs`, this module analyzes
//! `crate::reduce::flatten_unit`'s *cloned* declaration list (needed to
//! inline `sandbox { ... }` bodies) — a temporary that is dropped when
//! [`analyze_ownership`] returns. A pointer-identity oracle would dangle the
//! moment the caller's own AST reference (from the original,
//! never-flattened `TranslationUnit`) differs from the address inside that
//! temporary clone. `Expr::span` (file/line/col) is stable across the clone
//! (spans come from the original source text, unaffected by cloning the
//! tree) and uniquely identifies a syntactic occurrence, so the oracle is
//! keyed on that instead.
//!
//! ## Soundness note: the "retired name" bookkeeping
//!
//! A chain-temp (or a root's own bare value) is only ever "consumed" at a
//! syntactically-recognized terminal site. Once consumed, this module
//! records that name (or root) as **retired** rather than dropping it from
//! tracking outright — any *later* reference to a retired name is treated as
//! a still-disqualifying use, not silently ignored. Without this, a second,
//! independent reference to an already-consumed name would look
//! "untracked" and pass every check, which is unsound the moment codegen
//! ever performs an actual in-place mutation at the recognized terminal
//! site. (This module is not yet wired into codegen, so this has no current
//! runtime effect — it's a correctness property of the analysis itself,
//! checked now so it's already right when wiring happens.)

use std::collections::{HashMap, HashSet};

use resid_parser::{
    Block, Declaration, Expr, ExprKind, FuncDef, Id, Stmt, StmtKind, TranslationUnit, Type,
    TypeBody,
};

/// A source occurrence, identified by span rather than AST pointer (see
/// module docs for why). `(file, line, col_start, col_end)`.
type SiteKey = (String, usize, usize, usize);

fn site_key(e: &Expr) -> SiteKey {
    let s = &e.span;
    (s.file.clone(), s.line, s.col_start, s.col_end)
}

/// The general ownership/last-use oracle. Query with
/// [`OwnershipInfo::is_last_unique_use`].
#[derive(Default)]
pub struct OwnershipInfo {
    last_unique_uses: HashSet<SiteKey>,
}

impl OwnershipInfo {
    pub fn new() -> Self {
        Self::default()
    }

    /// True iff `e` is the proven last, uniquely-owned use of some tracked
    /// root — the one syntactic point where codegen could safely reuse the
    /// value's allocation in place instead of copying. False for every
    /// other occurrence (including earlier uses of the *same* root — those
    /// are safe reads, just not terminal) and for any root this analysis
    /// declined to recognize at all.
    pub fn is_last_unique_use(&self, e: &Expr) -> bool {
        self.last_unique_uses.contains(&site_key(e))
    }
}

/// An access path this analysis tracks: `base` (a parameter or local name)
/// alone, or `base.field` (one `List`/`Map`/`Set`-typed field of a
/// struct-typed `base`).
#[derive(Clone, PartialEq, Eq, Hash, Debug)]
struct RootPath {
    base: String,
    field: Option<String>,
}

/// One candidate root inside one function.
#[derive(Clone)]
struct RootDef {
    path: RootPath,
    /// Declared type name of `base` itself, when `base` is struct-typed
    /// (needed to recognize a same-type rebuild). `None` when `base` is
    /// directly a `List`/`Map`/`Set` (field is always `None` in that case).
    base_ty: Option<String>,
    /// Declared type name of the tracked VALUE: `base`'s own type name when
    /// `field` is `None` and `base` is a container; the field's type name
    /// when `field` is `Some`; `None` for a whole-struct box-reuse root
    /// (nothing to content-grow, only the box itself may be reused).
    tracked_ty: Option<String>,
    /// `Some(i)` iff `base` is exactly parameter `i` of its function —
    /// needed for the self-recursive-same-slot terminal case, and to flag
    /// that this root still needs the (not-yet-implemented) whole-program
    /// call-site-freshness check before being safe to wire into codegen.
    param_idx: Option<usize>,
}

fn is_container_name(name: &str) -> bool {
    matches!(name, "List" | "Map" | "Set")
}

fn growth_methods_for(type_name: &str) -> &'static [&'static str] {
    match type_name {
        "List" => &["concat"],
        "Map" | "Set" => &["insert", "remove"],
        _ => &[],
    }
}

fn is_readonly_method(type_name: &str, method: &str, argc: usize) -> bool {
    matches!(
        (type_name, method, argc),
        ("List", "len", 0)
            | ("Map", "len", 0)
            | ("Map", "get", 1)
            | ("Map", "contains", 1)
            | ("Set", "len", 0)
            | ("Set", "contains", 1)
    )
}

type StructTable<'a> = HashMap<&'a str, &'a Vec<(Id, Type)>>;

/// Whole-program facts about call parameters, generalized from
/// `field_growable.rs`'s (List/struct-only) versions to every heap type this
/// module tracks.
struct Calls {
    readonly_params: HashSet<(String, usize)>,
    never_escapes_bare: HashSet<(String, usize)>,
}

/// One root that passed the per-function shape/ownership walk, together
/// with the terminal sites it produced. Retained until the whole-program
/// call-site-freshness pass has had a chance to disqualify parameter roots
/// (local roots are self-contained and always survive it).
struct AcceptedRoot {
    fname: String,
    /// `Some(i)` for a parameter root (needs call-site freshness), `None`
    /// for a local root.
    param_idx: Option<usize>,
    terminals: Vec<SiteKey>,
}

pub fn analyze_ownership(unit: &TranslationUnit) -> OwnershipInfo {
    let flat = crate::reduce::flatten_unit(unit);
    let funcs: HashMap<&str, &FuncDef> = flat
        .iter()
        .filter_map(|d| match d {
            Declaration::Function(f) => Some((f.name.0.as_str(), f)),
            _ => None,
        })
        .collect();
    let structs: StructTable = flat
        .iter()
        .filter_map(|d| match d {
            Declaration::Type(td) => match &td.body {
                TypeBody::Product(fields) => Some((td.name.0.as_str(), fields)),
                _ => None,
            },
            _ => None,
        })
        .collect();

    let calls = Calls {
        readonly_params: compute_readonly_params(&funcs),
        never_escapes_bare: compute_never_escapes_bare(&funcs, &structs),
    };

    let debug = std::env::var("OWNERSHIP_DEBUG").is_ok();

    // Pass 1: per-function shape/ownership walk. Parameter roots are
    // collected here but not yet trusted — a caller could hand one an
    // aliased/shared value (pass 2 settles that).
    let mut accepted: Vec<AcceptedRoot> = Vec::new();
    for f in funcs.values() {
        if debug {
            eprintln!("fn {} ({} stmts)", f.name.0, f.body.statements.len());
        }
        let roots = discover_roots(f, &structs);
        if debug {
            eprintln!("  {} roots", roots.len());
        }
        for (ri, root) in roots.iter().enumerate() {
            if debug {
                eprintln!("  root {ri}: {}{}", root.path.base, root.path.field.as_deref().map(|f| format!(".{f}")).unwrap_or_default());
            }
            if let Some(terminals) = check_root(f, root, &calls) {
                accepted.push(AcceptedRoot {
                    fname: f.name.0.clone(),
                    param_idx: root.param_idx,
                    terminals,
                });
            }
            if debug {
                eprintln!("  root {ri} done");
            }
        }
    }

    // Pass 2: whole-program call-site ownership for parameter roots
    // (Perceus move semantics). A parameter root is uniquely owned on entry
    // if every call to its function hands that slot either a freshly
    // allocated literal or a **last-use** argument (a move — the caller
    // keeps no reference, so nothing is aliased). A non-last-use `Id` still
    // needs a `dup` and disqualifies the root. Mirrors `growable.rs`'s
    // phase 3, narrowed to this module's documented scope (no cross-function
    // delegation), and the function's own verified recursive self-call
    // remains exempt because pass 1 already validated it.
    let param_roots: HashSet<(String, usize)> = accepted
        .iter()
        .filter_map(|r| r.param_idx.map(|i| (r.fname.clone(), i)))
        .collect();
    let mut stale: HashSet<(String, usize)> = HashSet::new();
    if !param_roots.is_empty() {
        for caller in funcs.values() {
            let moved = crate::liveness::last_uses(caller);
            scan_calls_for_stale_param_roots(&caller.body, caller, &param_roots, &moved, &mut stale);
        }
    }
    if debug {
        let mut v: Vec<_> = stale.iter().collect();
        v.sort();
        for k in v {
            eprintln!("  stale param root: {}.{}", k.0, k.1);
        }
    }

    // Pass 3: emit, dropping any parameter root whose freshness failed.
    // Locals (`param_idx == None`) are self-contained — nothing outside the
    // function can reference them — so they always survive.
    let mut last_unique_uses: HashSet<SiteKey> = HashSet::new();
    for r in accepted {
        if let Some(i) = r.param_idx
            && stale.contains(&(r.fname, i))
        {
            continue;
        }
        last_unique_uses.extend(r.terminals);
    }
    OwnershipInfo { last_unique_uses }
}

/// Whole-program scan: for every call whose callee has an accepted
/// parameter root at argument position `i`, mark that root stale unless the
/// argument is either a freshly-allocated literal or a last-use (moved)
/// `Id`. The calling function's own self-recursive calls are exempt — pass
/// 1's shape walk already verified that a recursive step passes only the
/// parameter itself or a chain temp derived from it.
fn scan_calls_for_stale_param_roots(
    block: &Block,
    caller: &FuncDef,
    param_roots: &HashSet<(String, usize)>,
    moved: &HashSet<SiteKey>,
    stale: &mut HashSet<(String, usize)>,
) {
    each_child_block(block, &mut |e| {
        if let ExprKind::Call { func, args } = &e.kind
            && let ExprKind::Id(fname) = &func.kind
            && fname.0 != caller.name.0
        {
            for (i, (_, arg)) in args.iter().enumerate() {
                let key = (fname.0.clone(), i);
                if param_roots.contains(&key)
                    && !is_fresh_allocation(arg)
                    && !is_owned_call_result(arg)
                    && !is_moved_arg(arg, moved)
                {
                    stale.insert(key);
                }
            }
        }
    });
}

/// True for an argument that can be handed to the callee as an owned value:
/// a fresh allocation, an owned call result, an `Id` occurrence that is its
/// binding's last use (a Perceus *move* — see
/// [`crate::liveness::last_uses`]), or a `base.field` access whose base `Id`
/// is its binding's last use (consuming the struct consumes its fields). Any
/// other `Id` use still requires a caller-side `dup`, so it disqualifies the
/// callee's parameter root until codegen emits those dups.
fn is_moved_arg(e: &Expr, moved: &HashSet<SiteKey>) -> bool {
    match &e.kind {
        ExprKind::Id(_) => moved.contains(&site_key(e)),
        ExprKind::FieldAccess { target, .. } => {
            matches!(target.kind, ExprKind::Id(_)) && moved.contains(&site_key(target))
        }
        _ => false,
    }
}

/// True for an expression whose value the caller uniquely owns under the
/// Perceus contract: a function/method/provider call returns a value the
/// callee produced (the callee `dup`s anything it returns without having
/// consumed). Retained as a distinct predicate from [`is_fresh_allocation`]
/// because it carries that contract as a precondition on the eventual
/// (still unwired) codegen — the callee must emit return-`dup`s exactly as
/// callers must emit argument-`dup`s.
fn is_owned_call_result(e: &Expr) -> bool {
    matches!(
        e.kind,
        ExprKind::Call { .. } | ExprKind::MethodCall { .. } | ExprKind::ProviderCall { .. }
    )
}

/// True for an expression shape that provably allocates a brand-new value
/// nothing else can reference.
fn is_fresh_allocation(e: &Expr) -> bool {
    matches!(
        e.kind,
        ExprKind::ListLit(_)
            | ExprKind::SetLit(_)
            | ExprKind::MapLit(_)
            | ExprKind::StructLit { .. }
    )
}

// --- Root discovery ---

fn discover_roots(f: &FuncDef, structs: &StructTable) -> Vec<RootDef> {
    let mut roots = Vec::new();
    for (i, p) in f.params.iter().enumerate() {
        push_root_for(&p.name.0, &p.type_, Some(i), structs, &mut roots);
    }
    collect_local_roots(&f.body, structs, &mut roots);
    roots
}

fn push_root_for(
    base: &str,
    ty: &Type,
    param_idx: Option<usize>,
    structs: &StructTable,
    roots: &mut Vec<RootDef>,
) {
    let Type::Base { name, .. } = ty else {
        return;
    };
    let tyname = name.0.as_str();
    if is_container_name(tyname) {
        roots.push(RootDef {
            path: RootPath { base: base.to_string(), field: None },
            base_ty: None,
            tracked_ty: Some(tyname.to_string()),
            param_idx,
        });
        return;
    }
    if let Some(fields) = structs.get(tyname) {
        roots.push(RootDef {
            path: RootPath { base: base.to_string(), field: None },
            base_ty: Some(tyname.to_string()),
            tracked_ty: None,
            param_idx,
        });
        for (fid, fty) in fields.iter() {
            if let Type::Base { name: fname, .. } = fty
                && is_container_name(&fname.0)
            {
                roots.push(RootDef {
                    path: RootPath { base: base.to_string(), field: Some(fid.0.clone()) },
                    base_ty: Some(tyname.to_string()),
                    tracked_ty: Some(fname.0.clone()),
                    param_idx,
                });
            }
        }
    }
}

fn collect_local_roots(block: &Block, structs: &StructTable, roots: &mut Vec<RootDef>) {
    for stmt in &block.statements {
        match &stmt.kind {
            StmtKind::Bind { type_: Some(t), name, .. } => push_root_for(&name.0, t, None, structs, roots),
            StmtKind::Discard(e) | StmtKind::Expr(e) => descend_if_for_roots(e, structs, roots),
            _ => {}
        }
    }
    if let Some(ret) = &block.ret {
        descend_if_for_roots(ret, structs, roots);
    }
}

fn descend_if_for_roots(e: &Expr, structs: &StructTable, roots: &mut Vec<RootDef>) {
    if let ExprKind::If { then_block, else_block, .. } = &e.kind {
        collect_local_roots(then_block, structs, roots);
        if let Some(eb) = else_block {
            collect_local_roots(eb, structs, roots);
        }
    }
}

// --- Whole-program call-parameter facts ---

/// Every `(function, param_idx)` whose struct- or container-typed parameter
/// never appears bare anywhere in that function's own body except as a pure
/// pass-through tail return. Type-agnostic (doesn't care whether the param
/// is a struct or a container) — generalizes `field_growable.rs`'s
/// struct-only version to every tracked type.
fn compute_never_escapes_bare(funcs: &HashMap<&str, &FuncDef>, structs: &StructTable) -> HashSet<(String, usize)> {
    let mut out = HashSet::new();
    for f in funcs.values() {
        for (i, p) in f.params.iter().enumerate() {
            let Type::Base { name, .. } = &p.type_ else { continue };
            if !is_container_name(&name.0) && !structs.contains_key(name.0.as_str()) {
                continue;
            }
            if base_never_escapes(&f.body, &p.name.0) {
                out.insert((f.name.0.clone(), i));
            }
        }
    }
    out
}

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

/// Every `(function, param_idx)` whose container-typed (`List`/`Map`/`Set`)
/// parameter is used only via its type's read-only ops in that function's
/// own body — never stored, returned bare, or passed to another call.
/// Deliberately one level deep, same rationale as `field_growable.rs`.
fn compute_readonly_params(funcs: &HashMap<&str, &FuncDef>) -> HashSet<(String, usize)> {
    let mut out = HashSet::new();
    for f in funcs.values() {
        for (i, p) in f.params.iter().enumerate() {
            let Type::Base { name, .. } = &p.type_ else { continue };
            if !is_container_name(&name.0) {
                continue;
            }
            if param_used_readonly(&f.body, &p.name.0, &name.0) {
                out.insert((f.name.0.clone(), i));
            }
        }
    }
    out
}

fn param_used_readonly(body: &Block, param: &str, tyname: &str) -> bool {
    let mut ok = true;
    scan_readonly_block(body, param, tyname, &mut ok);
    ok
}

fn scan_readonly_block(block: &Block, param: &str, tyname: &str, ok: &mut bool) {
    for stmt in &block.statements {
        each_child_stmt(stmt, &mut |e| scan_readonly_expr(e, param, tyname, ok));
    }
    if let Some(ret) = &block.ret {
        scan_readonly_expr(ret, param, tyname, ok);
    }
}

fn scan_readonly_expr(e: &Expr, param: &str, tyname: &str, ok: &mut bool) {
    if !*ok {
        return;
    }
    match &e.kind {
        ExprKind::MethodCall { target, method, args } => {
            let bare_param = matches!(&target.kind, ExprKind::Id(id) if id.0 == param);
            if bare_param {
                if !is_readonly_method(tyname, &method.0, args.len()) {
                    *ok = false;
                }
            } else {
                scan_readonly_expr(target, param, tyname, ok);
            }
            for a in args {
                scan_readonly_expr(a, param, tyname, ok);
            }
        }
        ExprKind::Index { target, index } => {
            if !matches!(&target.kind, ExprKind::Id(id) if id.0 == param) {
                scan_readonly_expr(target, param, tyname, ok);
            }
            scan_readonly_expr(index, param, tyname, ok);
        }
        ExprKind::Id(id) if id.0 == param => {
            *ok = false;
        }
        _ => each_child(e, &mut |c| scan_readonly_expr(c, param, tyname, ok)),
    }
}

// --- Per-root walk ---

#[derive(PartialEq)]
enum Use {
    Safe,
    Disqualified,
}

/// What a recognized consuming/renaming event actually consumed: a live
/// chain temp (a prior rename/growth result), or the root's own bare
/// zero-chain form (`base` or `base.field` directly, never yet renamed).
enum Consumed {
    Temp(String),
    Base,
}

#[derive(Default, Clone)]
struct Walk {
    /// Names currently holding the live chain head (a rename, or a
    /// growth-method result) awaiting further growth or terminal
    /// consumption.
    chain: HashSet<String>,
    /// Names that WERE in `chain` and have since been validly consumed —
    /// any later reference to one is a bug (double use), not a miss.
    chain_retired: HashSet<String>,
    /// True once the root's own bare zero-chain form has been captured by
    /// ANY recognized event (a rename-forward continuation OR a terminal
    /// consumption) — separate from `terminated` because a continuation
    /// (e.g. `acc2 = acc.insert(...)`) uses up the bare `acc` form without
    /// itself ending the root's story; a second, independent attempt to
    /// rename/consume the bare form again afterward would be a genuine
    /// aliasing bug (two chains claiming the same original value), so this
    /// flag — not `terminated` — is what `denotes_tracked_value` checks to
    /// refuse that second attempt.
    base_consumed: bool,
    /// True once a genuine terminal (reuse-relevant) site has fired for
    /// this root. Once set, nothing more may consume this root again.
    terminated: bool,
    terminals: HashSet<SiteKey>,
}

fn check_root(f: &FuncDef, root: &RootDef, calls: &Calls) -> Option<Vec<SiteKey>> {
    if !contains_bare_id(&f.body, &root.path.base) {
        return None;
    }
    let mut w = Walk::default();
    if check_block(&f.body, f, root, &mut w, calls) != Use::Safe {
        return None;
    }
    if !w.chain.is_empty() || w.terminals.is_empty() {
        return None;
    }
    Some(w.terminals.into_iter().collect())
}

fn contains_bare_id(block: &Block, name: &str) -> bool {
    let mut found = false;
    scan_presence_block(block, name, &mut found);
    found
}

fn scan_presence_block(block: &Block, name: &str, found: &mut bool) {
    for stmt in &block.statements {
        each_child_stmt(stmt, &mut |e| scan_presence_expr(e, name, found));
    }
    if let Some(ret) = &block.ret {
        scan_presence_expr(ret, name, found);
    }
}

fn scan_presence_expr(e: &Expr, name: &str, found: &mut bool) {
    if *found {
        return;
    }
    if matches!(&e.kind, ExprKind::Id(id) if id.0 == name) {
        *found = true;
        return;
    }
    each_child(e, &mut |c| scan_presence_expr(c, name, found));
}

/// True iff `e` is syntactically the tracked value: the bare root (or its
/// designated field), or a live chain-temp. `w.base_consumed` gates the
/// bare-root/field form (once its zero-chain identity has been captured
/// once — by a rename-forward continuation OR a terminal consumption — a
/// further "match" here is a bug, not a legitimate second sighting) — a
/// live chain temp is a different name each time, so it isn't gated the
/// same way.
fn denotes_tracked_value(e: &Expr, root: &RootDef, w: &Walk) -> bool {
    if let ExprKind::Id(id) = &e.kind
        && w.chain.contains(&id.0)
    {
        return true;
    }
    if w.base_consumed {
        return false;
    }
    match &root.path.field {
        None => matches!(&e.kind, ExprKind::Id(id) if id.0 == root.path.base),
        Some(f) => matches!(&e.kind, ExprKind::FieldAccess { target, field }
            if field.0 == *f && matches!(&target.kind, ExprKind::Id(id) if id.0 == root.path.base)),
    }
}

/// Classifies a `denotes_tracked_value`-matching expression as consuming a
/// live chain temp or the root's own bare form. `None` if `e` doesn't
/// denote the tracked value at all.
fn classify_consumption(e: &Expr, root: &RootDef, w: &Walk) -> Option<Consumed> {
    if !denotes_tracked_value(e, root, w) {
        return None;
    }
    if let ExprKind::Id(id) = &e.kind
        && w.chain.contains(&id.0)
    {
        return Some(Consumed::Temp(id.0.clone()));
    }
    Some(Consumed::Base)
}

/// Applies a **continuation** event (a rename-forward: the tracked value
/// lives on under a new name, e.g. a `let`-bound chain step or a same-type
/// struct rebuild). Returns `false` if this is a second, independent
/// attempt to consume the already-captured bare root — a real aliasing bug,
/// not a miss.
fn apply_consumption(w: &mut Walk, c: Consumed) -> bool {
    match c {
        Consumed::Temp(name) => {
            w.chain.remove(&name);
            w.chain_retired.insert(name);
            true
        }
        Consumed::Base => {
            if w.base_consumed {
                return false;
            }
            w.base_consumed = true;
            true
        }
    }
}

/// Applies a **terminal** (reuse-relevant) event: a return pass-through, a
/// self-recursive same-slot argument, or a hand-off into a fresh container.
/// Returns `Use::Disqualified` if a terminal site already fired for this
/// root (only one terminal use is legitimate per control-flow path — a
/// second one is a double-consumption bug).
fn finish_termination(w: &mut Walk, consumed: Consumed, site: SiteKey) -> Use {
    if w.terminated {
        return Use::Disqualified;
    }
    match consumed {
        Consumed::Temp(name) => {
            w.chain.remove(&name);
            w.chain_retired.insert(name);
        }
        Consumed::Base => {
            if w.base_consumed {
                return Use::Disqualified;
            }
            w.base_consumed = true;
        }
    }
    // This execution path ends here (a terminal fired) — if some OTHER
    // chain temp is still dangling unconsumed, this path never finished
    // growing it. Checking inline (per path), not just once at the very
    // end of the whole function, is what makes forking `Walk` per if/else
    // branch (see `check_block`'s and `check_return_expr`'s `If` handling)
    // sound: each independent path validates its own completeness right
    // where it terminates.
    if !w.chain.is_empty() {
        return Use::Disqualified;
    }
    w.terminated = true;
    w.terminals.insert(site);
    Use::Safe
}

/// True if `e` reads a field of the tracked root/chain anywhere inside it
/// (`base.SOMEFIELD` or `chaintemp.SOMEFIELD`) — used to require a
/// whole-value (field=`None`) struct-rebuild continuation to actually be
/// *derived from* the tracked root, not merely share its type name. Without
/// this, an unrelated struct literal that happens to have the same type
/// (e.g. a different code path's fresh, unrelated construction) would be
/// wrongly treated as reusing the tracked root's box.
fn field_reads_base(e: &Expr, root: &RootDef, w: &Walk) -> bool {
    if let ExprKind::FieldAccess { target, .. } = &e.kind
        && let ExprKind::Id(id) = &target.kind
        && (id.0 == root.path.base || w.chain.contains(&id.0))
    {
        return true;
    }
    let mut found = false;
    each_child(e, &mut |c| {
        if !found && field_reads_base(c, root, w) {
            found = true;
        }
    });
    found
}

/// Whether `e` bare-references the tracked root/field/chain in a way that
/// isn't one of the specifically-recognized safe contexts (matched inline,
/// before recursing, in the `MethodCall`/`Index`/`Call` arms below).
fn references_tracked(e: &Expr, root: &RootDef, w: &Walk, calls: &Calls) -> bool {
    match &e.kind {
        ExprKind::Id(id) => {
            id.0 == root.path.base || w.chain.contains(&id.0) || w.chain_retired.contains(&id.0)
        }
        ExprKind::FieldAccess { target, field } => {
            if let ExprKind::Id(id) = &target.kind {
                if w.chain_retired.contains(&id.0) {
                    return true;
                }
                if id.0 == root.path.base || w.chain.contains(&id.0) {
                    return root.path.field.as_deref() == Some(field.0.as_str());
                }
            }
            references_tracked(target, root, w, calls)
        }
        ExprKind::MethodCall { target, method, args } => {
            let readonly_on_tracked = root
                .tracked_ty
                .as_deref()
                .is_some_and(|ty| is_readonly_method(ty, &method.0, args.len()))
                && denotes_tracked_value(target, root, w);
            let target_hit = !readonly_on_tracked && references_tracked(target, root, w, calls);
            target_hit || args.iter().any(|a| references_tracked(a, root, w, calls))
        }
        ExprKind::Index { target, index } => {
            let readonly_on_tracked = root.tracked_ty.as_deref() == Some("List") && denotes_tracked_value(target, root, w);
            let target_hit = !readonly_on_tracked && references_tracked(target, root, w, calls);
            target_hit || references_tracked(index, root, w, calls)
        }
        ExprKind::Call { func, args } => {
            let callee = match &func.kind {
                ExprKind::Id(fname) => Some(fname.0.as_str()),
                _ => None,
            };
            let mut found = references_tracked(func, root, w, calls);
            for (i, (_, a)) in args.iter().enumerate() {
                let safe_handoff = denotes_tracked_value(a, root, w)
                    && callee.is_some_and(|c| {
                        calls.readonly_params.contains(&(c.to_string(), i))
                            || calls.never_escapes_bare.contains(&(c.to_string(), i))
                    });
                if !safe_handoff && references_tracked(a, root, w, calls) {
                    found = true;
                }
            }
            found
        }
        _ => {
            let mut found = false;
            each_child(e, &mut |c| {
                if !found && references_tracked(c, root, w, calls) {
                    found = true;
                }
            });
            found
        }
    }
}

/// Recognizes `value` as a (possibly zero-length, possibly multi-step)
/// growth chain: a run of type-appropriate growth-method calls rooted at
/// the tracked value or a live chain temp, with every argument along the
/// way safe. Returns what the chain's root consumed (see [`Consumed`]);
/// `None` = not this shape at all.
fn chain_growth(value: &Expr, root: &RootDef, w: &Walk, calls: &Calls) -> Option<Consumed> {
    let tyname = root.tracked_ty.as_deref()?;
    let methods = growth_methods_for(tyname);
    if methods.is_empty() {
        return None;
    }
    fn walk_chain<'a>(e: &'a Expr, root: &RootDef, w: &Walk, methods: &[&str], args_out: &mut Vec<&'a Expr>) -> Option<Consumed> {
        if let ExprKind::MethodCall { target, method, args } = &e.kind {
            if methods.contains(&method.0.as_str()) {
                let inner = walk_chain(target, root, w, methods, args_out)?;
                for a in args {
                    args_out.push(a);
                }
                return Some(inner);
            }
            return None;
        }
        classify_consumption(e, root, w)
    }
    let mut chain_args = Vec::new();
    let consumed = walk_chain(value, root, w, methods, &mut chain_args)?;
    if chain_args.iter().any(|a| references_tracked(a, root, w, calls)) {
        return None;
    }
    Some(consumed)
}

struct HandoffResult {
    consumed: Consumed,
    is_continuation: bool,
    site: SiteKey,
}

/// Recognizes `value` as either a same-type struct rebuild (a continuation —
/// the tracked path lives on under a new name) or a hand-off of the tracked
/// value into a freshly-built container of a different shape (`StructLit` of
/// another type, `ListLit`, `MapLit`, `SetLit` — a terminal use: the value's
/// story, from this root's point of view, ends here).
fn rebuild_or_handoff(value: &Expr, root: &RootDef, w: &Walk, calls: &Calls) -> Option<HandoffResult> {
    if let ExprKind::StructLit { name, fields } = &value.kind
        && root.base_ty.as_deref() == Some(name.0.as_str())
    {
        match &root.path.field {
            Some(designated) => {
                let mut consumed: Option<Consumed> = None;
                let mut consumed_site: Option<SiteKey> = None;
                for (fname, fval) in fields {
                    if fname.0 == *designated {
                        if let Some(c) = chain_growth(fval, root, w, calls) {
                            consumed = Some(c);
                            consumed_site = Some(site_key(fval));
                            continue;
                        }
                        if let Some(c) = classify_consumption(fval, root, w) {
                            consumed = Some(c);
                            consumed_site = Some(site_key(fval));
                            continue;
                        }
                        return None;
                    }
                    if references_tracked(fval, root, w, calls) {
                        return None;
                    }
                }
                return Some(HandoffResult { consumed: consumed?, is_continuation: true, site: consumed_site? });
            }
            None => {
                // Whole-value box-reuse: every field must be a safe read,
                // AND at least one field must actually derive from the
                // tracked root (otherwise this is just an unrelated literal
                // that happens to share its type name — see
                // `field_reads_base`'s docs).
                let mut saw_base = false;
                for (_, fval) in fields {
                    if references_tracked(fval, root, w, calls) {
                        return None;
                    }
                    if field_reads_base(fval, root, w) {
                        saw_base = true;
                    }
                }
                if !saw_base {
                    return None;
                }
                return Some(HandoffResult { consumed: Consumed::Base, is_continuation: true, site: site_key(value) });
            }
        }
    }
    match &value.kind {
        ExprKind::StructLit { fields, .. } => handoff_container(fields.iter().map(|(_, v)| v), root, w, calls),
        ExprKind::ListLit(elems) | ExprKind::SetLit(elems) => handoff_container(elems.iter(), root, w, calls),
        ExprKind::MapLit(entries) => handoff_container(entries.iter().map(|(_, v)| v), root, w, calls),
        _ => None,
    }
}

fn handoff_container<'a>(vals: impl Iterator<Item = &'a Expr>, root: &RootDef, w: &Walk, calls: &Calls) -> Option<HandoffResult> {
    let mut result: Option<(Consumed, SiteKey)> = None;
    for v in vals {
        let hit = chain_growth(v, root, w, calls).or_else(|| classify_consumption(v, root, w));
        if let Some(c) = hit {
            if result.is_some() {
                return None;
            }
            result = Some((c, site_key(v)));
            continue;
        }
        if references_tracked(v, root, w, calls) {
            return None;
        }
    }
    let (consumed, site) = result?;
    Some(HandoffResult { consumed, is_continuation: false, site })
}

/// Handing the tracked value whole to a proven non-retaining callee
/// (`ReadOnly` or `NeverEscapesBare`) is always a safe, non-terminal use —
/// the callee is proven not to keep another reference, so it doesn't matter
/// whether more uses of the root follow. Returns `true` if `args` matched
/// this shape (regardless of position — mid-block or tail).
fn is_safe_nonretaining_handoff(fname: &str, args: &[(Option<Id>, Expr)], root: &RootDef, w: &Walk, calls: &Calls) -> bool {
    let mut hit: Option<usize> = None;
    for (i, (_, arg)) in args.iter().enumerate() {
        if denotes_tracked_value(arg, root, w) {
            if hit.is_some() {
                return false;
            }
            hit = Some(i);
        }
    }
    let Some(i) = hit else { return false };
    if !(calls.readonly_params.contains(&(fname.to_string(), i)) || calls.never_escapes_bare.contains(&(fname.to_string(), i))) {
        return false;
    }
    args.iter().enumerate().filter(|(j, _)| *j != i).all(|(_, (_, a))| !references_tracked(a, root, w, calls))
}

/// Runs `then_block`/`else_block` on independent clones of `w` (never
/// shared — see below) and merges the result back into `w`.
///
/// A shared, monotonically-mutated `Walk` across mutually-exclusive
/// branches is unsound here: `if (cond) { return g; } return rebuild(g);`
/// is exactly the canonical base-case/recursive-step accumulator shape, and
/// EACH branch independently terminates the root — but at runtime only one
/// branch ever executes, so one branch's "already terminated" bookkeeping
/// must never block the other's. Forking avoids that false conflict; each
/// branch's own [`finish_termination`] calls still enforce that ITS path
/// leaves nothing dangling.
///
/// Forward state (what code textually AFTER the `if` sees) only comes from
/// a branch that genuinely falls through (`block.ret.is_none()` — a branch
/// that ends in its own return exits the function along that path, so its
/// bookkeeping is irrelevant afterward). A missing `else` falls through
/// with `w`'s pre-branch state unchanged (the implicit "nothing happened"
/// path). If both sides fall through, state is merged conservatively
/// (union of chains/retirees, OR of the flags) — never unioning in a way
/// that could wrongly validate a real double-use.
fn merge_branches(
    w: &mut Walk,
    f: &FuncDef,
    root: &RootDef,
    then_block: &Block,
    else_block: &Option<Box<Block>>,
    calls: &Calls,
) -> Use {
    if std::env::var("OWNERSHIP_DEBUG").is_ok() {
        static CALLS: std::sync::atomic::AtomicUsize = std::sync::atomic::AtomicUsize::new(0);
        let n = CALLS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        if n.is_multiple_of(10000) {
            eprintln!(
                "    merge_branches call #{n}, w.chain.len()={}, w.terminals.len()={}",
                w.chain.len(),
                w.terminals.len()
            );
        }
        assert!(n < 5_000_000, "merge_branches call count exploded — likely runaway recursion");
    }
    let pre_if = w.clone();
    let mut w_then = pre_if.clone();
    if check_block(then_block, f, root, &mut w_then, calls) == Use::Disqualified {
        return Use::Disqualified;
    }
    let then_fallthrough = then_block.ret.is_none();

    let (else_terminals, else_fallthrough_state): (HashSet<SiteKey>, Option<Walk>) = if let Some(eb) = else_block {
        let mut w_else = pre_if.clone();
        if check_block(eb, f, root, &mut w_else, calls) == Use::Disqualified {
            return Use::Disqualified;
        }
        let terminals = w_else.terminals.clone();
        (terminals, if eb.ret.is_none() { Some(w_else) } else { None })
    } else {
        (HashSet::new(), Some(pre_if.clone()))
    };

    w.terminals.extend(w_then.terminals.iter().cloned());
    w.terminals.extend(else_terminals);

    let then_fallthrough_state = then_fallthrough.then_some(w_then);
    match (then_fallthrough_state, else_fallthrough_state) {
        (None, None) => {} // every path through the `if` returns; `w` stays as it was
        (Some(a), None) | (None, Some(a)) => {
            w.chain = a.chain;
            w.chain_retired = a.chain_retired;
            w.base_consumed = a.base_consumed;
            w.terminated = a.terminated;
        }
        (Some(a), Some(b)) => {
            w.chain = a.chain.union(&b.chain).cloned().collect();
            w.chain_retired = a.chain_retired.union(&b.chain_retired).cloned().collect();
            w.base_consumed = a.base_consumed || b.base_consumed;
            w.terminated = a.terminated || b.terminated;
        }
    }
    Use::Safe
}

fn check_block(block: &Block, f: &FuncDef, root: &RootDef, w: &mut Walk, calls: &Calls) -> Use {
    for stmt in &block.statements {
        match &stmt.kind {
            StmtKind::Bind { name, value, .. } => {
                if let Some(consumed) = chain_growth(value, root, w, calls) {
                    if !apply_consumption(w, consumed) {
                        return Use::Disqualified;
                    }
                    w.chain.insert(name.0.clone());
                    continue;
                }
                if let Some(hr) = rebuild_or_handoff(value, root, w, calls) {
                    if hr.is_continuation {
                        if !apply_consumption(w, hr.consumed) {
                            return Use::Disqualified;
                        }
                        w.chain.insert(name.0.clone());
                    } else if finish_termination(w, hr.consumed, hr.site) == Use::Disqualified {
                        return Use::Disqualified;
                    }
                    continue;
                }
                if let ExprKind::Call { func, args } = &value.kind
                    && let ExprKind::Id(fname) = &func.kind
                    && is_safe_nonretaining_handoff(&fname.0, args, root, w, calls)
                {
                    // A safe, non-terminal read across a call boundary — `name`
                    // becomes an ordinary, untracked binding from here on.
                    continue;
                }
                if references_tracked(value, root, w, calls) {
                    return Use::Disqualified;
                }
            }
            StmtKind::Return(Some(e)) => {
                if check_return_expr(e, f, root, w, calls) == Use::Disqualified {
                    return Use::Disqualified;
                }
            }
            StmtKind::Return(None) => {}
            StmtKind::Discard(e) | StmtKind::Expr(e) => {
                if let ExprKind::If { cond, then_block, else_block } = &e.kind {
                    if references_tracked(cond, root, w, calls) {
                        return Use::Disqualified;
                    }
                    if merge_branches(w, f, root, then_block, else_block, calls) == Use::Disqualified {
                        return Use::Disqualified;
                    }
                    continue;
                }
                if references_tracked(e, root, w, calls) {
                    return Use::Disqualified;
                }
            }
            StmtKind::Destructure { source, .. } => {
                if references_tracked(source, root, w, calls) {
                    return Use::Disqualified;
                }
            }
            StmtKind::Break | StmtKind::Continue => {}
        }
    }
    if let Some(ret) = &block.ret {
        return check_return_expr(ret, f, root, w, calls);
    }
    Use::Safe
}

fn check_return_expr(e: &Expr, f: &FuncDef, root: &RootDef, w: &mut Walk, calls: &Calls) -> Use {
    if let Some(c) = classify_consumption(e, root, w) {
        return finish_termination(w, c, site_key(e));
    }
    if let ExprKind::If { cond, then_block, else_block } = &e.kind {
        if references_tracked(cond, root, w, calls) {
            return Use::Disqualified;
        }
        return merge_branches(w, f, root, then_block, else_block, calls);
    }
    if let ExprKind::Call { func, args } = &e.kind
        && let ExprKind::Id(fname) = &func.kind
    {
        if fname.0 == f.name.0
            && let Some(pidx) = root.param_idx
        {
            if args.len() != f.params.len() {
                return Use::Disqualified;
            }
            for (i, (_, arg)) in args.iter().enumerate() {
                if i == pidx {
                    let Some(c) = classify_consumption(arg, root, w) else {
                        return Use::Disqualified;
                    };
                    if finish_termination(w, c, site_key(arg)) == Use::Disqualified {
                        return Use::Disqualified;
                    }
                } else if references_tracked(arg, root, w, calls) {
                    return Use::Disqualified;
                }
            }
            return Use::Safe;
        }
        if is_safe_nonretaining_handoff(&fname.0, args, root, w, calls) {
            let (_, hit) = args
                .iter()
                .find(|(_, a)| denotes_tracked_value(a, root, w))
                .expect("is_safe_nonretaining_handoff found exactly one match");
            let c = classify_consumption(hit, root, w).expect("denotes_tracked_value already confirmed a match");
            return finish_termination(w, c, site_key(hit));
        }
    }
    if let Some(hr) = rebuild_or_handoff(e, root, w, calls) {
        return finish_termination(w, hr.consumed, hr.site);
    }
    if references_tracked(e, root, w, calls) {
        return Use::Disqualified;
    }
    Use::Safe
}

// --- Generic AST child-visitor (mirrors growable.rs's/field_growable.rs's;
// kept local since those modules' copies are private to them) ---

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

#[cfg(test)]
mod tests {
    use super::*;
    use resid_parser::Parser;

    fn parse(src: &str) -> TranslationUnit {
        let (unit, errs) = Parser::parse("test.resid", src);
        assert!(errs.is_empty(), "parse errors: {errs:?}");
        unit
    }

    /// Direct, structural access to a named function's body — deliberately
    /// NOT a text/span search: this analysis's whole point is span-keyed
    /// identity, so tests navigate the same tree `analyze_ownership` saw and
    /// pull out the exact `&Expr` in hand, the way a real caller (codegen)
    /// would.
    fn func<'a>(unit: &'a TranslationUnit, name: &str) -> &'a FuncDef {
        unit.declarations
            .iter()
            .find_map(|d| match d {
                Declaration::Function(f) if f.name.0 == name => Some(f),
                _ => None,
            })
            .unwrap_or_else(|| panic!("no function named {name}"))
    }

    fn stmt_value(f: &FuncDef, i: usize) -> &Expr {
        let StmtKind::Bind { value, .. } = &f.body.statements[i].kind else {
            panic!("statement {i} of {} isn't a Bind", f.name.0)
        };
        value
    }

    /// Local root (`pg_func`-shaped): `pp1`/`pp2` are LOCALS, not
    /// parameters — the concrete gap `field_growable.rs`'s checklist named
    /// as its "natural next increment." Field-growth of `pp1.lines` handed
    /// off into a freshly-built `PG` must be recognized as the last unique
    /// use of `pp1.lines`'s growth chain.
    #[test]
    fn local_root_field_growth_recognized() {
        let src = r#"
            type CapPP = { lines: List(Str), glines: List(Str) };
            type PG = { lines: List(Str), glines: List(Str), tmp: Int };

            PG pg_func(CapPP g, Int t) {
                CapPP pp1 = mk1();
                CapPP pp2 = mk2();
                List(Str) lns = pp1.lines.concat(pp2.lines).concat(["}"]);
                return PG { lines: lns, glines: pp2.glines, tmp: t };
            }
        "#;
        let unit = parse(src);
        let info = analyze_ownership(&unit);
        let f = func(&unit, "pg_func");
        // The LAST use of the chain is what's recognized as terminal, not
        // its root reference: `pp1.lines` immediately renames into `lns`
        // (stmt[2]), and `lns` is consumed exactly once, inside the
        // returned `PG` literal — that occurrence is the recognized site.
        // `return X;` is always folded into the enclosing `Block::ret` by
        // the parser (see `parse_block`), never left as a `StmtKind::Return`
        // inside `statements` — regardless of the explicit `return` keyword.
        let ret_expr = f.body.ret.as_ref().expect("expected a tail return");
        let ExprKind::StructLit { fields, .. } = &ret_expr.kind else { panic!("expected StructLit") };
        let (_, lines_val) = fields.iter().find(|(id, _)| id.0 == "lines").unwrap();
        assert!(info.is_last_unique_use(lines_val), "the `lns` reference inside the returned PG should be the recognized terminal site");
    }

    /// Whole-struct box-reuse root: `g` is rebuilt into a same-type struct
    /// literal with every field a plain passthrough, and that literal is
    /// returned directly. `g` itself should be recognized as terminally,
    /// uniquely consumed there.
    #[test]
    fn struct_box_reuse_recognized() {
        let src = r#"
            type PG = { lines: List(Str), tmp: Int };

            PG rebuild(PG g) {
                if (g.tmp < 0) { return g; }
                return PG { lines: g.lines, tmp: g.tmp + 1 };
            }
        "#;
        let unit = parse(src);
        let info = analyze_ownership(&unit);
        let f = func(&unit, "rebuild");
        // The whole-value box-reuse root has no single "designated field",
        // so the terminal site recorded is the whole rebuild literal.
        let ret_expr = f.body.ret.as_ref().expect("expected a tail return");
        assert!(matches!(&ret_expr.kind, ExprKind::StructLit { .. }));
        assert!(info.is_last_unique_use(ret_expr), "g should be recognized as box-reuse-eligible at its rebuild site");
    }

    /// Map/Set content growth: a bare `Map`-typed parameter grown via
    /// `.insert`, mirroring `growable.rs`'s List case one level over to a
    /// different container kind.
    #[test]
    fn map_growth_recognized() {
        let src = r#"
            Map(Str, Int) build(List(Str) keys, Int i, Map(Str, Int) acc) {
                if (i >= keys.len()) { return acc; }
                Map(Str, Int) acc2 = acc.insert(keys[i], i);
                Int k = i + 1;
                return build(keys, k, acc2);
            }
        "#;
        let unit = parse(src);
        let info = analyze_ownership(&unit);
        let f = func(&unit, "build");
        // `acc` renames into `acc2` (stmt[1]); `acc2` is consumed exactly
        // once, as the matching argument of the recursive self-call — that
        // occurrence, not `acc`'s own original mention, is the terminal site.
        let call_expr = f.body.ret.as_ref().expect("expected a tail return");
        let ExprKind::Call { args, .. } = &call_expr.kind else { panic!("expected Call") };
        assert!(info.is_last_unique_use(&args[2].1), "acc2 fed into the recursive call should be the recognized last unique use");
    }

    /// Mid-block hand-off (a genuine generalization over both
    /// `growable.rs`/`field_growable.rs`, which only recognized this shape
    /// at a block's TAIL position): the tracked field is consumed by a
    /// container literal in a non-tail `Bind`, with real code following
    /// afterward that doesn't touch it.
    #[test]
    fn mid_block_handoff_recognized() {
        let src = r#"
            type GT = { lines: List(Str), tag: Str };
            type Box = { l: List(Str) };

            Box wrap_mid(GT ev, Str s) {
                List(Str) d = ev.lines.concat([s]);
                Box b = Box { l: d };
                Int x = 1 + 1;
                return b;
            }
        "#;
        let unit = parse(src);
        let info = analyze_ownership(&unit);
        let f = func(&unit, "wrap_mid");
        // `d` (renamed from `ev.lines`) is consumed inside `Box { l: d }`
        // at stmt[1] — a genuinely MID-block hand-off, not at the return.
        let value = stmt_value(f, 1);
        let ExprKind::StructLit { fields, .. } = &value.kind else { panic!("expected StructLit") };
        let (_, l_val) = fields.iter().find(|(id, _)| id.0 == "l").unwrap();
        assert!(info.is_last_unique_use(l_val), "ev.lines should be recognized even though its handoff isn't at block tail");
    }

    /// Soundness: a chain-temp consumed by a mid-block handoff must not be
    /// referenced again afterward — this is exactly the "retired name"
    /// bookkeeping the module docs describe. If this ever wrongly validates
    /// AND still (incorrectly) marks a terminal, that's the double-use bug
    /// this test exists to catch.
    #[test]
    fn double_use_after_mid_block_handoff_disqualifies() {
        let src = r#"
            type GT = { lines: List(Str), tag: Str };
            type Box = { l: List(Str) };

            Box wrap_and_reuse(GT ev, Str s) {
                List(Str) d = ev.lines.concat([s]);
                Box b = Box { l: d };
                Int n = d.len();
                return b;
            }
        "#;
        let unit = parse(src);
        let info = analyze_ownership(&unit);
        let f = func(&unit, "wrap_and_reuse");
        let value = stmt_value(f, 1);
        let ExprKind::StructLit { fields, .. } = &value.kind else { panic!("expected StructLit") };
        let (_, l_val) = fields.iter().find(|(id, _)| id.0 == "l").unwrap();
        assert!(!info.is_last_unique_use(l_val), "referencing `d` again after its hand-off must disqualify, not silently pass");
    }

    /// Escaping base disqualifies (regression parity with both existing
    /// modules' equivalent test).
    #[test]
    fn escaping_local_disqualified() {
        let src = r#"
            type CapPP = { lines: List(Str) };

            CapPP leaks() {
                CapPP acc = mk();
                CapPP other = stash(acc);
                List(Str) d = acc.lines.concat(["x"]);
                return CapPP { lines: d };
            }
        "#;
        let unit = parse(src);
        let info = analyze_ownership(&unit);
        let f = func(&unit, "leaks");
        let value = stmt_value(f, 2);
        let ExprKind::MethodCall { target, .. } = &value.kind else { panic!("expected MethodCall") };
        assert!(!info.is_last_unique_use(target), "acc escapes bare via stash(acc); must not be recognized");
    }

    /// Never-escapes-bare hand-off at return tail (`gt_err`-shaped, the real
    /// case from `finish_ifexpr` in `codegen.resid` per the plan's
    /// writeup) — regression parity with `field_growable.rs`'s equivalent
    /// coverage, now via the unified mechanism.
    #[test]
    fn tail_handoff_to_never_escapes_bare_recognized() {        let src = r#"
            type GT = { lines: List(Str), val: Str };

            GT gt_err(Str msg, GT base) {
                return GT { lines: base.lines, val: msg };
            }

            GT finish_ifexpr(GT ev, Str ld) {
                if (ld != "") { return gt_err(ld, ev); }
                List(Str) d = ev.lines.concat([ld]);
                return GT { lines: d, val: ld };
            }
        "#;
        let unit = parse(src);
        let info = analyze_ownership(&unit);
        let f = func(&unit, "finish_ifexpr");
        let (StmtKind::Expr(if_expr) | StmtKind::Discard(if_expr)) = &f.body.statements[0].kind else {
            panic!("expected if statement")
        };
        let ExprKind::If { then_block, .. } = &if_expr.kind else { panic!("expected If") };
        let call_expr = then_block.ret.as_ref().expect("expected a tail return");
        let ExprKind::Call { args, .. } = &call_expr.kind else { panic!("expected Call") };
        // whole-struct box-reuse root for `ev` (field=None) should recognize
        // this hand-off as its terminal use.
        assert!(info.is_last_unique_use(&args[1].1), "ev handed whole to a never-escapes-bare callee at tail should be recognized");
    }

    /// Parameter-root freshness, positive: `grow`'s parameter root is
    /// uniquely owned on entry because its only caller hands it a freshly
    /// allocated struct literal. The in-place reuse site inside `grow` must
    /// therefore be recognized.
    #[test]
    fn fresh_literal_call_arg_keeps_param_root() {
        let src = r#"
            type GT = { lines: List(Str), tag: Str };

            GT grow(GT ev) {
                List(Str) d = ev.lines.concat(["x"]);
                return GT { lines: d, tag: ev.tag };
            }

            GT call_fresh() {
                return grow(GT { lines: [], tag: "t" });
            }
        "#;
        let unit = parse(src);
        let info = analyze_ownership(&unit);
        let f = func(&unit, "grow");
        let ret_expr = f.body.ret.as_ref().expect("expected a tail return");
        assert!(
            info.is_last_unique_use(ret_expr),
            "a parameter root fed only a fresh literal at its call site is uniquely owned; its in-place reuse site must be recognized"
        );
    }

    /// Parameter-root ownership, negative (the soundness gate): the same
    /// `grow` is called with a live local (`src`) that is still used
    /// afterwards. That argument is *not* a last use, so it would need a
    /// caller-side `dup`; mutating `ev` in place inside `grow` would still
    /// corrupt `src`'s buffer, so the parameter root must be dropped.
    #[test]
    fn aliased_call_arg_disqualifies_param_root() {
        let src = r#"
            type GT = { lines: List(Str), tag: Str };

            GT grow(GT ev) {
                List(Str) d = ev.lines.concat(["x"]);
                return GT { lines: d, tag: ev.tag };
            }

            GT call_alias(GT src) {
                GT r = grow(src);
                Int n = src.tag.len();
                return r;
            }
        "#;
        let unit = parse(src);
        let info = analyze_ownership(&unit);
        let f = func(&unit, "grow");
        let ret_expr = f.body.ret.as_ref().expect("expected a tail return");
        assert!(
            !info.is_last_unique_use(ret_expr),
            "a parameter root handed a non-last-use (dupped) alias at ANY call site must not be trusted for in-place reuse"
        );
    }

    /// Parameter-root ownership, positive under Perceus move semantics: the
    /// argument `src` is its binding's last use at the call, so it is moved
    /// (not aliased) and the callee's parameter root stays uniquely owned.
    #[test]
    fn moved_call_arg_keeps_param_root() {
        let src = r#"
            type GT = { lines: List(Str), tag: Str };

            GT grow(GT ev) {
                List(Str) d = ev.lines.concat(["x"]);
                return GT { lines: d, tag: ev.tag };
            }

            GT call_move(GT src) {
                return grow(src);
            }
        "#;
        let unit = parse(src);
        let info = analyze_ownership(&unit);
        let f = func(&unit, "grow");
        let ret_expr = f.body.ret.as_ref().expect("expected a tail return");
        assert!(
            info.is_last_unique_use(ret_expr),
            "a last-use (moved) call argument aliases nothing; the parameter root must survive"
        );
    }

    /// Parameter-root ownership, Perceus rule for call results: a call
    /// expression yields a value the caller owns (the callee `dup`s anything
    /// it returns), so a call-result argument is a move, not an alias.
    #[test]
    fn call_result_arg_keeps_param_root() {
        let src = r#"
            type GT = { lines: List(Str), tag: Str };

            GT grow(GT ev) {
                List(Str) d = ev.lines.concat(["x"]);
                return GT { lines: d, tag: ev.tag };
            }

            GT fresh() {
                return GT { lines: [], tag: "t" };
            }

            GT call_result() {
                return grow(fresh());
            }
        "#;
        let unit = parse(src);
        let info = analyze_ownership(&unit);
        let f = func(&unit, "grow");
        let ret_expr = f.body.ret.as_ref().expect("expected a tail return");
        assert!(
            info.is_last_unique_use(ret_expr),
            "a call-result argument is owned under the Perceus contract; the parameter root must survive"
        );
    }

    /// Parameter-root ownership via a field-access move: `fs.ctn` is owned
    /// because `fs` is at its last use (consuming the struct consumes the
    /// field), so the callee's parameter root survives.
    #[test]
    fn field_access_move_keeps_param_root() {
        let src = r#"
            List(Str) chain(List(Str) names, Int i) {
                if (i >= names.len()) { return names; }
                Int k = i + 1;
                return chain(names, k);
            }

            type FS = { ctn: List(Str) };

            Bool call_field(FS fs) {
                return chain(fs.ctn, 0).len() > 0;
            }
        "#;
        let unit = parse(src);
        let info = analyze_ownership(&unit);
        let f = func(&unit, "chain");
        let call = f.body.ret.as_ref().expect("expected a tail return");
        let ExprKind::Call { args, .. } = &call.kind else { panic!("expected Call") };
        assert!(
            info.is_last_unique_use(&args[0].1),
            "a `base.field` argument whose base is at its last use is a move; the parameter root must survive"
        );
    }

    /// Parameter-root freshness, recursion exemption: a function whose only
    /// caller is its own verified recursive self-call keeps its parameter
    /// root (pass 1 already validated the recursive step's shape).
    #[test]
    fn self_recursive_only_param_root_kept() {
        let src = r#"
            Map(Str, Int) build(List(Str) keys, Int i, Map(Str, Int) acc) {
                if (i >= keys.len()) { return acc; }
                Map(Str, Int) acc2 = acc.insert(keys[i], i);
                Int k = i + 1;
                return build(keys, k, acc2);
            }
        "#;
        let unit = parse(src);
        let info = analyze_ownership(&unit);
        let f = func(&unit, "build");
        let call_expr = f.body.ret.as_ref().expect("expected a tail return");
        let ExprKind::Call { args, .. } = &call_expr.kind else { panic!("expected Call") };
        assert!(
            info.is_last_unique_use(&args[2].1),
            "self-recursive calls are exempt from whole-program freshness; the accumulator root must survive"
        );
    }
}
