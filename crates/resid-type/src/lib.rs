//! Type checking for Resid.
//!
//! Infers and checks types over the parsed AST for the numeric core of the
//! spec (§6 Primitive Numeric Types, §6.1–§6.4). Resolves the primitive
//! family (via `resid-ir`), applies the mixed-width widening rules, and
//! rejects signed/unsigned mixing.

use std::collections::HashMap;

pub use resid_ir::{
    BinOp, FloatWidth, IntWidth, NumericError, NumericType, ResultType, numeric_result_type,
};
use resid_lexer::token::{Literal, Op as OpKind, Span};
use resid_parser::{
    Block, Declaration, Expr, ExprKind, FuncDef, Id, Pattern, PatternKind, StmtKind,
    SumVariant, TranslationUnit, Type, TypeBody, TypeDef,
};

/// A semantic type for the supported core.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum SemType {
    Bool,
    Numeric(NumericType),
    Str,
    /// Raw byte string (`b"..."`), spec §14. A pointer to a byte array.
    Bytes,
    /// An immutable list of homogeneous elements.
    List(Box<SemType>),
    /// An immutable map (key → value). Spec §32 core types.
    Map(Box<SemType>, Box<SemType>),
    /// An immutable set of homogeneous elements. Spec §32 core types.
    Set(Box<SemType>),
    /// A user-declared product type.
    Struct {
        name: String,
        fields: Vec<(String, SemType)>,
    },
    /// A user-declared (or built-in `Option`) sum type.
    Sum {
        name: String,
        variants: Vec<(String, Option<SemType>)>,
    },
    /// Generic pointer type — matches any composite/boxed value for extern
    /// functions. LLVM emits this as `ptr`.
    Ptr,
    /// A numeric range `a..b` / `a..=b` (spec §15).
    Range(Box<SemType>),
    /// A slice view into a List's data (spec §15).
    Slice(Box<SemType>),
    /// A source location (`#location`), spec §25. Boxed struct with
    /// `file: Str`, `line: Int`, `col: Int` slots.
    SourceLoc,
    /// An identity-bearing resource handle (`File`), spec §16. Boxed as a
    /// pointer; acquired by `filesystem.open`, released by `resid_handle_release`
    /// at the end of a `with` block (or by `filesystem.close`).
    File,
}

impl core::fmt::Display for SemType {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        match self {
            SemType::Bool => write!(f, "Bool"),
            SemType::Numeric(n) => write!(f, "{n}"),
            SemType::Str => write!(f, "Str"),
            SemType::Bytes => write!(f, "Bytes"),
            SemType::List(e) => write!(f, "List({e})"),
            SemType::Map(k, v) => write!(f, "Map({k}, {v})"),
            SemType::Set(e) => write!(f, "Set({e})"),
            SemType::Struct { name, .. } => write!(f, "{name}"),
            SemType::Sum { name, .. } => write!(f, "{name}"),
            SemType::Ptr => write!(f, "ptr"),
            SemType::Range(e) => write!(f, "Range({e})"),
            SemType::Slice(e) => write!(f, "Slice({e})"),
            SemType::SourceLoc => write!(f, "SourceLoc"),
            SemType::File => write!(f, "File"),
        }
    }
}

impl SemType {
    /// Variant index of `name` inside a sum type.
    pub fn variant_index(&self, name: &str) -> Option<usize> {
        match self {
            SemType::Sum { variants, .. } => variants.iter().position(|(n, _)| n == name),
            _ => None,
        }
    }

    /// Index of `name` if it names a zero-payload (unit) variant — the kind a
    /// bare `None`-style pattern refers to.
    pub fn unit_variant_index(&self, name: &str) -> Option<usize> {
        match self {
            SemType::Sum { variants, .. } => {
                let idx = variants.iter().position(|(n, _)| n == name)?;
                if variants[idx].1.is_none() {
                    Some(idx)
                } else {
                    None
                }
            }
            _ => None,
        }
    }
}

/// For an Option/Residual sum (`Some(T) | None`), return the payload type `T`
/// that a `value?` / `value else` unwrap produces.
///
/// Two shapes qualify (spec §23):
/// - Option-style: any sum with a unit variant — payload is the other
///   variant's payload (`Some(T) | None`).
/// - Result-style: exactly two variants, both with payloads — the first is
///   success (`Ok(T)`), the second failure (`Err(E)`); `T` is returned.
pub fn residual_payload(ty: &SemType) -> Option<SemType> {
    match ty {
        SemType::Sum { variants, .. } => {
            let has_unit = variants.iter().any(|(_, p)| p.is_none());
            if has_unit {
                return variants.iter().find_map(|(_, p)| p.clone());
            }
            if variants.len() == 2 {
                if let Some((_, Some(pt))) = variants.first() {
                    return Some(pt.clone());
                }
            }
            None
        }
        _ => None,
    }
}

/// The set of user-declared named types (`type T = …`), used to resolve
/// `Type::Base` references and variant constructors.
pub type Types = HashMap<String, SemType>;

/// Behavior instances declared in a unit, keyed by instance text
/// (`"Ord(Point)"`) with the implementation function name as value.
pub type Behaviors = HashMap<String, String>;

/// Collect behavior definitions (`Ord(Point) = point_cmp;`). Returns
/// `(instances, errors)`: instances maps the instance key to the
/// implementation function; errors describe malformed definitions.
pub fn collect_behaviors(unit: &TranslationUnit) -> (Behaviors, Vec<TypeError>) {
    let mut out = Behaviors::new();
    let mut errs = Vec::new();
    for decl in &unit.declarations {
        let Declaration::Behavior(b) = decl else { continue };
        let key = if b.type_params.len() == 1 {
            format!("{}({})", b.name.0, b.type_params[0].0)
        } else {
            errs.push(err(
                &b.span,
                format!(
                    "behavior `{}`: exactly one type parameter is required",
                    b.name.0
                ),
            ));
            continue;
        };
        let func = match &b.body.kind {
            ExprKind::Id(id) => id.0.clone(),
            _ => {
                errs.push(err(
                    &b.span,
                    "behavior body must name an implementation function",
                ));
                continue;
            }
        };
        if out.insert(key.clone(), func).is_some() {
            errs.push(err(
                &b.span,
                format!("behavior instance `{key}` is already defined"),
            ));
        }
    }
    (out, errs)
}

/// Validate that each behavior instance's implementation function exists and
/// has comparator shape `(T, T) -> Int`.
pub fn check_behaviors(
    unit: &TranslationUnit,
    sigs: &Signatures,
    types: &Types,
    behaviors: &Behaviors,
) -> Vec<TypeError> {
    let mut errs = Vec::new();
    for decl in &unit.declarations {
        let Declaration::Behavior(b) = decl else { continue };
        if b.type_params.len() != 1 || !matches!(b.body.kind, ExprKind::Id(_)) {
            continue; // already reported by collect_behaviors
        }
        let key = format!("{}({})", b.name.0, b.type_params[0].0);
        let Some(func) = behaviors.get(&key) else { continue };
        let Some(sig) = sigs.get(func) else {
            errs.push(err(
                &b.span,
                format!("behavior `{key}`: undefined function `{func}`"),
            ));
            continue;
        };
        let param_ty = resolve_type_ctx(
            &Type::Base {
                name: b.type_params[0].clone(),
                params: None,
            },
            types,
        )
        .unwrap_or_else(|| SemType::Numeric(NumericType::Int(IntWidth::B64)));
        let want = vec![param_ty.clone(), param_ty];
        if sig.params != want {
            errs.push(err(
                &b.span,
                format!(
                    "behavior `{key}`: `{func}` must have signature ({T}, {T}) -> Int, found {}",
                    FormatSig(&sig),
                    T = b.type_params[0].0,
                ),
            ));
        } else if sig.ret != SemType::Numeric(NumericType::Int(IntWidth::B64)) {
            errs.push(err(
                &b.span,
                format!("behavior `{key}`: `{func}` must return Int"),
            ));
        }
    }
    errs
}

struct FormatSig<'a>(&'a FunctionSig);
impl std::fmt::Display for FormatSig<'_> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "(")?;
        for (i, p) in self.0.params.iter().enumerate() {
            if i > 0 {
                write!(f, ", ")?;
            }
            write!(f, "{p}")?;
        }
        write!(f, ") -> {}", self.0.ret)
    }
}

/// Collect the named product/sum types declared in a translation unit.
pub fn collect_types(unit: &TranslationUnit) -> Types {
    let mut types = Types::new();
    let mut order: Vec<TypeDef> = unit
        .declarations
        .iter()
        .filter_map(|d| match d {
            Declaration::Type(t) => Some(t.clone()),
            _ => None,
        })
        .collect();
    // Resolve in a fixed point so a field/variant may reference another
    // declared type regardless of declaration order.
    let mut progress = true;
    while progress && !order.is_empty() {
        progress = false;
        let mut remaining = Vec::new();
        for td in order.drain(..) {
            if let Some(st) = resolve_type_def(&td, &types) {
                types.insert(td.name.0.clone(), st);
                progress = true;
            } else {
                remaining.push(td);
            }
        }
        order = remaining;
    }
    // Materialize synthesized parametric types (Option(T), List(T), Map…)
    // wherever they're referenced so variant constructors (`Some`, `None`)
    // resolve even though no `type` declaration names them.
    collect_parametric_types(unit, &mut types);
    types
}

/// Walk every type annotation in the unit and insert the parametric types it
/// mentions (as synthesized `List`/`Sum` values) into the type map so
/// `find_constructor` can locate variant constructors for them.
fn collect_parametric_types(unit: &TranslationUnit, types: &mut Types) {
    fn insert_t(t: &Type, types: &mut Types) {
        let Some(st) = resolve_type_ctx(t, types) else {
            return;
        };
        let key = format!("{st}");
        let want = matches!(
            &st,
            SemType::List(_) | SemType::Sum { .. } | SemType::Struct { .. }
        );
        if want && !types.contains_key(&key) {
            types.insert(key, st);
        }
    }
    for decl in &unit.declarations {
        match decl {
            Declaration::Function(f) => {
                for p in &f.params {
                    insert_t(&p.type_, types);
                }
                insert_t(&f.ret, types);
                for stmt in &f.body.statements {
                    if let StmtKind::Bind { type_: Some(t), .. } = &stmt.kind {
                        insert_t(t, types);
                    }
                }
            }
            _ => {}
        }
    }
}

fn resolve_type_def(td: &TypeDef, types: &Types) -> Option<SemType> {
    match &td.body {
        TypeBody::Product(fields) => {
            let mut out = Vec::new();
            for (name, ft) in fields {
                out.push((name.0.clone(), resolve_type_ctx(ft, types)?));
            }
            Some(SemType::Struct {
                name: td.name.0.clone(),
                fields: out,
            })
        }
        TypeBody::Sum(variants) => {
            let mut out = Vec::new();
            for SumVariant { name, type_param } in variants {
                let payload = match type_param {
                    Some(t) => Some(resolve_type_ctx(t, types)?),
                    None => None,
                };
                out.push((name.0.clone(), payload));
            }
            Some(SemType::Sum {
                name: td.name.0.clone(),
                variants: out,
            })
        }
        _ => None,
    }
}

/// Find a sum type whose variants include `name` (for constructor resolution).
/// Prefers the built-in `Option` when the name matches.
pub fn find_constructor<'t>(types: &'t Types, name: &str) -> Option<&'t SemType> {
    let mut first: Option<&'t SemType> = None;
    for ty in types.values() {
        if let SemType::Sum { variants, .. } = ty {
            if variants.iter().any(|(n, _)| n == name) {
                if let SemType::Sum { name: sn, .. } = ty {
                    if sn == "Option" {
                        return Some(ty);
                    }
                }
                first.get_or_insert(ty);
            }
        }
    }
    first
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
    pub param_names: Vec<String>,
    pub param_defaults: Vec<Option<ExprKind>>,
    pub ret: SemType,
    /// Visibility (spec §22): `pub` items are importable; private items
    /// are module-local. Builtins are always public.
    pub is_pub: bool,
    /// Defining file (span origin); empty for builtins.
    pub file: String,
    /// Capability requirements declared with `@requires(…)` (spec §21).
    /// Each string is the capability name (e.g. "filesystem", "network").
    pub requires: Vec<String>,
    /// Capability ceiling from an enclosing `sandbox (…)` block (spec §21).
    /// Empty when the function is not inside a sandbox.
    pub sandbox_ceiling: Vec<String>,
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
    /// Insert a binding, rejecting shadowing (spec §7: "Shadowing is forbidden
    /// everywhere"). Returns the existing type if the name is already bound.
    pub fn try_insert(&mut self, name: &str, ty: SemType) -> Result<(), SemType> {
        if let Some(existing) = self.map.get(name) {
            return Err(existing.clone());
        }
        self.map.insert(name.to_string(), ty);
        Ok(())
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
        ExprKind::IfLet { .. } => "if-let",
        ExprKind::WhileLet { .. } => "while-let",
        ExprKind::Range { .. } => "range",
        ExprKind::EarlyReturn(_) => "value `?`",
        ExprKind::ElseFallback { .. } => "value else",
        ExprKind::StructLit { .. } => "struct literal",
        ExprKind::ListLit(_) => "list literal",
        ExprKind::MapLit(_) => "map literal",
        ExprKind::SetLit(_) => "set literal",
        ExprKind::Index { .. } => "index",
        ExprKind::FieldAccess { .. } => "field access",
        ExprKind::MethodCall { .. } => "method call",
        ExprKind::Slice { .. } => "slice",
        ExprKind::Spawn { .. } => "spawn",
        ExprKind::ProviderCall { .. } => "provider call",
        ExprKind::With { .. } => "with",
        ExprKind::ComptimePrint(_) => "comptime_print",
        _ => "expression",
    }
}

/// Map a type name to a semantic type.
pub fn type_from_name(name: &str) -> Option<SemType> {
    match name {
        "Bool" => Some(SemType::Bool),
        "Str" => Some(SemType::Str),
        "Bytes" => Some(SemType::Bytes),
        "SourceLoc" => Some(SemType::SourceLoc),
        // Identity-bearing resource handle (spec §16). Acquired via
        // `filesystem.open`, released by `with` (RAII) or `filesystem.close`.
        "File" => Some(SemType::File),
        // Core error type for structured concurrency (spec §19): child
        // failure surfaces as `Err(RegionError)` carrying a message.
        "RegionError" => Some(SemType::Struct {
            name: "RegionError".into(),
            fields: vec![("message".into(), SemType::Str)],
        }),
        _ => resid_ir::NumericType::from_name(name).map(SemType::Numeric),
    }
}

/// Trusted provider verbs (spec §32): `(provider, verb, param types, result)`.
///
/// This is the single source of truth for what each provider exposes. To add a
/// verb, add a row here, a matching `resid_<provider>_<verb>` helper in
/// `crates/residc/resid_rt.c`, and a dispatch arm in `resid-codegen`'s
/// `lower_provider_call`. Any new provider name must also be added to the
/// parser's `is_provider_name` and enabled as a callable root there.
pub fn provider_verbs() -> Vec<(&'static str, &'static str, Vec<SemType>, SemType)> {
    vec![
        // filesystem
        (
            "filesystem",
            "exists",
            vec![SemType::Str],
            SemType::Bool,
        ),
        (
            "filesystem",
            "list_dir",
            vec![SemType::Str],
            SemType::List(Box::new(SemType::Str)),
        ),
        (
            "filesystem",
            "read_all",
            vec![SemType::Str],
            SemType::Str,
        ),
        (
            "filesystem",
            "write_all",
            vec![SemType::Str, SemType::Str],
            SemType::Bool,
        ),
        // File handles (spec §16): `filesystem.open` acquires an
        // identity-bearing resource; `filesystem.close` releases it explicitly
        // (a `with` block releases automatically, in reverse order).
        (
            "filesystem",
            "open",
            vec![SemType::Str],
            SemType::File,
        ),
        (
            "filesystem",
            "read_handle",
            vec![SemType::File],
            SemType::Str,
        ),
        (
            "filesystem",
            "close",
            vec![SemType::File],
            SemType::Bool,
        ),
        // environment
        ("environment", "get", vec![SemType::Str], SemType::Str),
        (
            "environment",
            "has",
            vec![SemType::Str],
            SemType::Bool,
        ),
        // git
        ("git", "rev", vec![SemType::Str], SemType::Str),
        ("git", "branch", vec![], SemType::Str),
        // args: command-line arguments (spec §32)
        (
            "args",
            "count",
            vec![],
            SemType::Numeric(NumericType::Int(IntWidth::B64)),
        ),
        (
            "args",
            "get",
            vec![SemType::Numeric(NumericType::Int(IntWidth::B64))],
            SemType::Str,
        ),
        // process: run an external command, returns its exit code (spec §32)
        (
            "process",
            "run",
            vec![SemType::Str],
            SemType::Numeric(NumericType::Int(IntWidth::B64)),
        ),
    ]
}

/// The `SourceLoc` field layout (`file: Str`, `line: Int`, `col: Int`), used by
/// `#location` lowering and field access.
pub fn source_loc_fields() -> Vec<(String, SemType)> {
    vec![
        ("file".into(), SemType::Str),
        (
            "line".into(),
            SemType::Numeric(NumericType::Int(IntWidth::from_bits(64).unwrap())),
        ),
        (
            "col".into(),
            SemType::Numeric(NumericType::Int(IntWidth::from_bits(64).unwrap())),
        ),
    ]
}

/// Resolve a parsed type descriptor to a semantic type, using the primitives
/// and (syntactic) built-in `List`/`Option` spellings only.
pub fn resolve_type(td: &Type) -> Option<SemType> {
    resolve_type_ctx(td, &Types::new())
}

/// Resolve a parsed type descriptor to a semantic type, in the context of the
/// unit's declared named types.
pub fn resolve_type_ctx(td: &Type, types: &Types) -> Option<SemType> {
    match td {
        Type::Base { name, params } => {
            // Built-in `List(T)`.
            if name.0 == "List" {
                if let Some(ps) = params {
                    if ps.len() == 1 {
                        let Some(inner) = resolve_type_ctx(&ps[0], types) else {
                            return None;
                        };
                        return Some(SemType::List(Box::new(inner)));
                    }
                }
                return None; // a bare `List` needs an element type
            }
            // Built-in `Map(K, V)`.
            if name.0 == "Map" {
                let Some(ps) = params else {
                    return None;
                };
                if ps.len() != 2 {
                    return None;
                }
                let Some(key) = resolve_type_ctx(&ps[0], types) else {
                    return None;
                };
                let Some(val) = resolve_type_ctx(&ps[1], types) else {
                    return None;
                };
                return Some(SemType::Map(Box::new(key), Box::new(val)));
            }
            // Built-in `Set(T)`.
            if name.0 == "Set" {
                let Some(ps) = params else {
                    return None;
                };
                if ps.len() != 1 {
                    return None;
                }
                let Some(inner) = resolve_type_ctx(&ps[0], types) else {
                    return None;
                };
                return Some(SemType::Set(Box::new(inner)));
            }
            // Built-in `Option(T)` sum.
            if name.0 == "Option" {
                let Some(ps) = params else {
                    return None;
                };
                if ps.len() != 1 {
                    return None;
                }
                let Some(inner) = resolve_type_ctx(&ps[0], types) else {
                    return None;
                };
                return Some(SemType::Sum {
                    name: "Option".into(),
                    variants: vec![("None".into(), None), ("Some".into(), Some(inner))],
                });
            }
            // Built-in `Result(T, E)` sum — Ok(T) / Err(E) (spec §19 spawn).
            if name.0 == "Result" {
                let Some(ps) = params else {
                    return None;
                };
                if ps.len() != 2 {
                    return None;
                }
                let Some(ok) = resolve_type_ctx(&ps[0], types) else {
                    return None;
                };
                let Some(er) = resolve_type_ctx(&ps[1], types) else {
                    return None;
                };
                return Some(SemType::Sum {
                    name: "Result".into(),
                    variants: vec![("Ok".into(), Some(ok)), ("Err".into(), Some(er))],
                });
            }
            // Built-in `Slice(T)` — slice of a List's elements.
            if name.0 == "Slice" {
                let Some(ps) = params else {
                    return None;
                };
                if ps.len() != 1 {
                    return None;
                }
                let Some(inner) = resolve_type_ctx(&ps[0], types) else {
                    return None;
                };
                return Some(SemType::Slice(Box::new(inner)));
            }
            // Built-in `Range(T)` — range of numeric values.
            if name.0 == "Range" {
                let Some(ps) = params else {
                    return None;
                };
                if ps.len() != 1 {
                    return None;
                }
                let Some(inner) = resolve_type_ctx(&ps[0], types) else {
                    return None;
                };
                return Some(SemType::Range(Box::new(inner)));
            }
            // Parameterized spellings Int(16) / UInt(8) / Float(32) carry a
            // single numeric-literal width; blend into the iN/uN/fN name.
            if let Some(ps) = params {
                if ps.len() == 1 {
                    let width_str = match &ps[0] {
                        // Parsed as numeric literal: Int(8) → Type::Literal(Int { kind: Decimal("8"), .. })
                        Type::Literal(Literal::Int { kind, .. }) => Ok(kind.digits().to_string()),
                        // Fallback: type param that's a Base type (legacy)
                        Type::Base {
                            name: width,
                            params: None,
                        } => Ok(width.0.clone()),
                        _ => Err(()),
                    };
                    if let Ok(width) = width_str {
                        let kind = match name.0.as_str() {
                            "Int" => "i",
                            "UInt" => "u",
                            "Float" => "f",
                            "Dec" => "d",
                            _ => return type_from_name(&name.0),
                        };
                        if let Ok(w) = width.parse::<u16>() {
                            return type_from_name(&format!("{kind}{w}"));
                        }
                    }
                }
            }
            // Fallback: parse width from name string itself (e.g. "Float(32)" or "Int(8)")
            // when params is None but name contains parameterized spelling.
            if params.is_none() {
                if let Some(rest) = name.0.strip_prefix("Int(") {
                    if let Some(w) = rest.strip_suffix(')').and_then(|s| s.parse::<u16>().ok()) {
                        return type_from_name(&format!("i{w}"));
                    }
                }
                if let Some(rest) = name.0.strip_prefix("UInt(") {
                    if let Some(w) = rest.strip_suffix(')').and_then(|s| s.parse::<u16>().ok()) {
                        return type_from_name(&format!("u{w}"));
                    }
                }
                if let Some(rest) = name.0.strip_prefix("Float(") {
                    if let Some(w) = rest.strip_suffix(')').and_then(|s| s.parse::<u16>().ok()) {
                        return type_from_name(&format!("f{w}"));
                    }
                }
                if let Some(rest) = name.0.strip_prefix("Dec(") {
                    if let Some(w) = rest.strip_suffix(')').and_then(|s| s.parse::<u16>().ok()) {
                        return type_from_name(&format!("d{w}"));
                    }
                }
            }
            // A user-declared named type.
            if let Some(st) = types.get(&name.0) {
                return Some(st.clone());
            }
            type_from_name(&name.0)
        }
        Type::ISize => Some(SemType::Numeric(NumericType::ISize)),
        Type::USize => Some(SemType::Numeric(NumericType::USize)),
        Type::Residual(inner) => resolve_type_ctx(inner, types),
        // Literal used standalone (shouldn't happen; only valid as Base param).
        Type::Literal(_) => None,
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
        Literal::Int { kind, .. } => {
            // Match the codegen's magnitude-derived width: literals that need
            // more than 64 bits infer Int(128)/Int(256)/Int(512) so untyped
            // binds of wide literals don't truncate.
            let bits = kind.required_bits();
            // Signed literals need one extra headroom bit so the inferred
            // width actually holds the value (e.g. a 128-bit magnitude
            // above i128::MAX must infer Int(256), not wrap in Int(128)).
            let width = if bits <= 63 {
                64
            } else {
                [128u16, 256, 512]
                    .into_iter()
                    .find(|&w| w >= bits + 1)
                    .unwrap_or(512)
            };
            SemType::Numeric(NumericType::Int(IntWidth::from_bits(width).unwrap()))
        }
        Literal::Float(_) => {
            SemType::Numeric(NumericType::Float(FloatWidth::from_bits(64).unwrap()))
        }
        // Decimal literals (spec §6.6a) default to Dec(34).
        Literal::Dec(_) => SemType::Numeric(NumericType::Dec(34)),
        Literal::Bool(_) => SemType::Bool,
        // Char literals are Unicode codepoints (spec §14: literals default to
        // Int; §32 has no `Char` core type). `str_char_at` / `str_from_code`
        // bridge codepoints and 1-char strings for the bootstrap lexer.
        Literal::Char(_) => SemType::Numeric(NumericType::Int(IntWidth::from_bits(64).unwrap())),
        _ => SemType::Str,
    }
}

/// Runtime-exposed built-in functions (the tiny bootstrap runtime linked by
/// `residc build|run` provides their native bodies).
const BUILTIN_SIGS: &[(&str, &[SemType], SemType)] = &[
    ("println", &[SemType::Str], SemType::Bool),
    ("print", &[SemType::Str], SemType::Bool),
    // ─── Integer stringification (bootstrap runtime) ───
    (
        "IntToString",
        &[SemType::Numeric(NumericType::Int(IntWidth::B8))],
        SemType::Str,
    ),
    (
        "IntToString",
        &[SemType::Numeric(NumericType::Int(IntWidth::B16))],
        SemType::Str,
    ),
    (
        "IntToString",
        &[SemType::Numeric(NumericType::Int(IntWidth::B32))],
        SemType::Str,
    ),
    (
        "IntToString",
        &[SemType::Numeric(NumericType::Int(IntWidth::B64))],
        SemType::Str,
    ),
    (
        "UIntToString",
        &[SemType::Numeric(NumericType::UInt(IntWidth::B8))],
        SemType::Str,
    ),
    (
        "UIntToString",
        &[SemType::Numeric(NumericType::UInt(IntWidth::B16))],
        SemType::Str,
    ),
    (
        "UIntToString",
        &[SemType::Numeric(NumericType::UInt(IntWidth::B32))],
        SemType::Str,
    ),
    (
        "UIntToString",
        &[SemType::Numeric(NumericType::UInt(IntWidth::B64))],
        SemType::Str,
    ),
    // ─── Wide (128-bit) integer stringification ───
    // LLVM lowers Int(128)/UInt(128) to native i128; the runtime exposes a
    // dedicated symbol (C `__int128` ABI) since the i64 helpers can't hold it.
    (
        "Int128ToString",
        &[SemType::Numeric(NumericType::Int(IntWidth::B128))],
        SemType::Str,
    ),
    (
        "UInt128ToString",
        &[SemType::Numeric(NumericType::UInt(IntWidth::B128))],
        SemType::Str,
    ),
    // ─── Wide (256/512-bit) integer stringification ───
    // Codegen decomposes the value into little-endian u64 limbs before the
    // call (the C ABI has no native 256-bit type).
    (
        "Int256ToString",
        &[SemType::Numeric(NumericType::Int(IntWidth::B256))],
        SemType::Str,
    ),
    (
        "UInt256ToString",
        &[SemType::Numeric(NumericType::UInt(IntWidth::B256))],
        SemType::Str,
    ),
    (
        "Int512ToString",
        &[SemType::Numeric(NumericType::Int(IntWidth::B512))],
        SemType::Str,
    ),
    (
        "UInt512ToString",
        &[SemType::Numeric(NumericType::UInt(IntWidth::B512))],
        SemType::Str,
    ),
    // ─── Float stringification (bootstrap runtime) ───
    (
        "FloatToString",
        &[SemType::Numeric(NumericType::Float(FloatWidth::F16))],
        SemType::Str,
    ),
    (
        "FloatToString",
        &[SemType::Numeric(NumericType::Float(FloatWidth::F32))],
        SemType::Str,
    ),
    (
        "FloatToString",
        &[SemType::Numeric(NumericType::Float(FloatWidth::F64))],
        SemType::Str,
    ),
    (
        "Float128ToString",
        &[SemType::Numeric(NumericType::Float(FloatWidth::F128))],
        SemType::Str,
    ),
    // ─── Bool stringification (bootstrap runtime) ───
    ("BoolToString", &[SemType::Bool], SemType::Str),
    // ─── Composite stringification (bootstrap runtime) ───
    // Generic ToString for any boxed value (List/Struct/Sum).
    // Takes a ptr — the runtime inspects the tag to determine format.
    ("ToString", &[SemType::Ptr], SemType::Str),
    // ─── Conversion helpers (spec §6.7) ───
    // Integer helpers accept Int(64) — the default for integer literals.
    ("i8", &[SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B8))),
    ("i16", &[SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B16))),
    ("i32", &[SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B32))),
    ("i64", &[SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("i128", &[SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B128))),
    ("i256", &[SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B256))),
    ("i512", &[SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B512))),
    // Unsigned integer helpers accept UInt(64).
    ("u8", &[SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B8))),
    ("u16", &[SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B16))),
    ("u32", &[SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B32))),
    ("u64", &[SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B64))),
    ("u128", &[SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B128))),
    ("u256", &[SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B256))),
    ("u512", &[SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B512))),
    // Float helpers accept Float(64) — the default for float literals.
    ("f16", &[SemType::Numeric(NumericType::Float(FloatWidth::F64))], SemType::Numeric(NumericType::Float(FloatWidth::F16))),
    ("f32", &[SemType::Numeric(NumericType::Float(FloatWidth::F64))], SemType::Numeric(NumericType::Float(FloatWidth::F32))),
    ("f64", &[SemType::Numeric(NumericType::Float(FloatWidth::F64))], SemType::Numeric(NumericType::Float(FloatWidth::F64))),
    ("f128", &[SemType::Numeric(NumericType::Float(FloatWidth::F64))], SemType::Numeric(NumericType::Float(FloatWidth::F128))),
    // isize / usize: pointer-sized.
    ("isize", &[SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::ISize)),
    ("usize", &[SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::USize)),
    // ─── Checked/wrapping/saturating arithmetic (spec §6.5) ───
    // Checked (default overflow check emitted by codegen).
    ("checked_add", &[SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("checked_sub", &[SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("checked_mul", &[SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("checked_div", &[SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("checked_uadd", &[SemType::Numeric(NumericType::UInt(IntWidth::B64)), SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B64))),
    ("checked_usub", &[SemType::Numeric(NumericType::UInt(IntWidth::B64)), SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B64))),
    ("checked_umul", &[SemType::Numeric(NumericType::UInt(IntWidth::B64)), SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B64))),
    ("checked_udiv", &[SemType::Numeric(NumericType::UInt(IntWidth::B64)), SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B64))),
    // Wrapping arithmetic.
    ("wrapping_add", &[SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("wrapping_sub", &[SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("wrapping_mul", &[SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("wrapping_div", &[SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("wrapping_uadd", &[SemType::Numeric(NumericType::UInt(IntWidth::B64)), SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B64))),
    ("wrapping_usub", &[SemType::Numeric(NumericType::UInt(IntWidth::B64)), SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B64))),
    ("wrapping_umul", &[SemType::Numeric(NumericType::UInt(IntWidth::B64)), SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B64))),
    ("wrapping_udiv", &[SemType::Numeric(NumericType::UInt(IntWidth::B64)), SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B64))),
    // Saturating arithmetic.
    ("saturating_add", &[SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("saturating_sub", &[SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("saturating_mul", &[SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("saturating_uadd", &[SemType::Numeric(NumericType::UInt(IntWidth::B64)), SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B64))),
    ("saturating_usub", &[SemType::Numeric(NumericType::UInt(IntWidth::B64)), SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B64))),
    ("saturating_umul", &[SemType::Numeric(NumericType::UInt(IntWidth::B64)), SemType::Numeric(NumericType::UInt(IntWidth::B64))], SemType::Numeric(NumericType::UInt(IntWidth::B64))),
    // ─── String introspection (bootstrap lexer) ───
    // Codepoint count of `s`.
    ("str_len", &[SemType::Str], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    // Codepoint at index `i` (0-based), or -1 when out of bounds.
    ("str_char_at", &[SemType::Str, SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    // Build a 1-codepoint `Str` from a codepoint (spec §14 char literal).
    ("str_from_code", &[SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Str),
    // Half-open substring `s[start..end]` by codepoint index.
    ("str_slice", &[SemType::Str, SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Str),
    // ─── Stdlib v1: string verbs ───
    // Trim leading/trailing ASCII whitespace.
    ("str_trim", &[SemType::Str], SemType::Str),
    ("str_contains", &[SemType::Str, SemType::Str], SemType::Bool),
    ("str_starts_with", &[SemType::Str, SemType::Str], SemType::Bool),
    ("str_ends_with", &[SemType::Str, SemType::Str], SemType::Bool),
    // ASCII-only case mapping (full Unicode casing is a later milestone).
    ("str_to_lower", &[SemType::Str], SemType::Str),
    ("str_to_upper", &[SemType::Str], SemType::Str),
    ("str_repeat", &[SemType::Str, SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Str),
    ("str_replace", &[SemType::Str, SemType::Str, SemType::Str], SemType::Str),
    // ─── Stdlib v1.1: parsing + integer math ───
    // Decimal integer recognition / parsing; parse yields 0 on malformed
    // input (pair with str_is_int).
    ("str_is_int", &[SemType::Str], SemType::Bool),
    ("str_parse_int", &[SemType::Str], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("abs_i64", &[SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("min_i64", &[SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("max_i64", &[SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("clamp_i64", &[SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    // ─── Stdlib v1.2: float parsing + misc string helpers ───
    ("str_is_float", &[SemType::Str], SemType::Bool),
    ("str_parse_float", &[SemType::Str], SemType::Numeric(NumericType::Float(FloatWidth::F64))),
    ("str_count", &[SemType::Str, SemType::Str], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("str_reverse", &[SemType::Str], SemType::Str),
    // ─── Stdlib v1.6: OS entropy hook (one byte per call) ───
    ("resid_crypto_random_byte", &[], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    // ─── Stdlib v2: TCP transport (protocol logic lives in lib/http.resid) ───
    // fd < 0 on failure. recv reads until the peer closes or 4 MB.
    ("resid_tcp_connect", &[SemType::Str, SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Numeric(NumericType::Int(IntWidth::B64))),
    ("resid_tcp_send", &[SemType::Numeric(NumericType::Int(IntWidth::B64)), SemType::Str], SemType::Bool),
    ("resid_tcp_recv_all", &[SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Str),
    ("resid_tcp_close", &[SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Bool),
    // UTC civil timestamp YYYYMMDDHHMMSS for x509 validity checks.
    ("resid_utc_now_civil", &[], SemType::Numeric(NumericType::Int(IntWidth::B64))),
];

/// Return the set of built-in (extern) function signatures.
pub fn builtin_signatures() -> Signatures {
    let mut sigs: Signatures = BUILTIN_SIGS
        .iter()
        .map(|(name, params, ret)| {
            (
                name.to_string(),
                FunctionSig {
                    name: name.to_string(),
                    params: params.to_vec(),
                    param_names: Vec::new(),
                    param_defaults: Vec::new(),
                    ret: ret.clone(),
                    is_pub: true,
                    file: String::new(),
                    requires: Vec::new(),
                    sandbox_ceiling: Vec::new(),
                },
            )
        })
        .collect();
    // List-typed entries (Box is not const-constructible): stdlib split/join
    // and the v1.3 list verbs over boxed lists.
    fn float_list() -> SemType {
        SemType::List(Box::new(SemType::Numeric(NumericType::Float(
            resid_ir::FloatWidth::F64,
        ))))
    }
    let int_list = || SemType::List(Box::new(SemType::Numeric(NumericType::Int(IntWidth::B64))));
    let str_list = || SemType::List(Box::new(SemType::Str));
    for (name, params, ret) in [
        (
            "str_split",
            vec![SemType::Str, SemType::Str],
            SemType::List(Box::new(SemType::Str)),
        ),
        (
            "str_join",
            vec![SemType::List(Box::new(SemType::Str)), SemType::Str],
            SemType::Str,
        ),
        ("list_reverse_ints", vec![int_list()], int_list()),
        ("list_reverse_strs", vec![str_list()], str_list()),
        ("list_contains_int", vec![int_list(), SemType::Numeric(NumericType::Int(IntWidth::B64))], SemType::Bool),
        ("list_contains_str", vec![str_list(), SemType::Str], SemType::Bool),
        ("list_sort_ints", vec![int_list()], int_list()),
        ("list_sort_strs", vec![str_list()], str_list()),
        ("list_sum", vec![int_list()], SemType::Numeric(NumericType::Int(IntWidth::B64))),
        (
            "list_reverse_floats",
            vec![float_list()],
            float_list(),
        ),
        (
            "list_contains_float",
            vec![float_list(), SemType::Numeric(NumericType::Float(resid_ir::FloatWidth::F64))],
            SemType::Bool,
        ),
        (
            "resid_tcp_send_bin",
            vec![SemType::Numeric(NumericType::Int(IntWidth::B64)), int_list()],
            SemType::Bool,
        ),
        (
            "resid_tcp_recv_bin",
            vec![
                SemType::Numeric(NumericType::Int(IntWidth::B64)),
                SemType::Numeric(NumericType::Int(IntWidth::B64)),
            ],
            int_list(),
        ),
        ("list_sort_floats", vec![float_list()], float_list()),
        (
            "list_sumf",
            vec![float_list()],
            SemType::Numeric(NumericType::Float(resid_ir::FloatWidth::F64)),
        ),
    ] {
        sigs.insert(
            name.to_string(),
            FunctionSig {
                name: name.to_string(),
                params,
                param_names: Vec::new(),
                param_defaults: Vec::new(),
                ret,
                is_pub: true,
                file: String::new(),
                requires: Vec::new(),
                sandbox_ceiling: Vec::new(),
            },
        );
    }
    sigs
}

/// Collect all function signatures declared in a translation unit, merged with
/// the built-in extern signatures (a unit definition of the same name wins).
pub fn collect_signatures(unit: &TranslationUnit) -> Signatures {
    let types = collect_types(unit);
    let mut sigs = builtin_signatures();
    let flat = flatten_unit(unit);
    for decl in &flat {
        if let Declaration::Function(f) = decl {
            let sig = signature_of(f, &types);
            sigs.insert(sig.name.clone(), sig);
        }
    }
    sigs
}

fn signature_of(f: &FuncDef, types: &Types) -> FunctionSig {
    let params = f
        .params
        .iter()
        .map(|p| resolve_type_ctx(&p.type_, types).unwrap_or(SemType::Bool))
        .collect();
    let param_names = f.params.iter().map(|p| p.name.0.clone()).collect();
    let param_defaults = f
        .params
        .iter()
        .map(|p| p.default.as_ref().map(|d| d.kind.clone()))
        .collect();
    let ret = resolve_type_ctx(&f.ret, types).unwrap_or(SemType::Bool);
    FunctionSig {
        name: f.name.0.clone(),
        params,
        param_names,
        param_defaults,
        ret,
        is_pub: f.pub_,
        file: f.span.file.clone(),
        requires: f.capabilities.iter()
            .filter(|c| c.name.0 == "requires")
            .flat_map(|c| c.params.iter().filter_map(|p| match &p.kind {
                ExprKind::Id(id) => Some(id.0.clone()),
                _ => None,
            }))
            .collect(),
        sandbox_ceiling: f.sandbox_ceiling.iter().map(|c| c.name.0.clone()).collect(),
    }
}

/// Infer the type of an expression without any user-declared named types in
/// scope (primitives, `List`, `Option` spellings only).
pub fn infer_expr(expr: &Expr, env: &Env, sigs: &Signatures) -> Result<SemType, TypeError> {
    infer_expr_ctx(expr, env, sigs, &Types::new())
}

/// Infer the type of an expression with an expected type hint. The hint only
/// matters for constructs whose type the expression cannot carry by itself —
/// an empty list literal `[]`, whose element type comes from the declared
/// type at the bind/field/return/argument site.
pub fn infer_expr_expected(
    expr: &Expr,
    env: &Env,
    sigs: &Signatures,
    types: &Types,
    expected: Option<&SemType>,
) -> Result<SemType, TypeError> {
    if let ExprKind::ListLit(elems) = &expr.kind {
        if elems.is_empty() {
            return match expected {
                Some(SemType::List(elem)) => Ok(SemType::List(elem.clone())),
                _ => Err(err(
                    &expr.span,
                    "cannot infer element type of an empty list literal (add an explicit type)",
                )),
            };
        }
    }
    // Spec §6: overflow of the result type is a compile-time error. A literal
    // written against an expected numeric type must fit its range (e.g.
    // `Int(8) x = 300` or `Int(64) y = <2^256-1 literal>`). Wide targets
    // (>= 128 bits) accept any literal by design.
    if let Some(SemType::Numeric(_)) = expected {
        if matches!(&expr.kind, ExprKind::Literal(Literal::Int { .. }))
            && !literal_compatible(expr, expected.unwrap())
        {
            let ExprKind::Literal(Literal::Int { kind, .. }) = &expr.kind else {
                unreachable!()
            };
            return Err(err(
                &expr.span,
format!(
                    "integer literal `{}` does not fit the expected type {} (needs {} bits)",
                    kind.source_str(),
                    expected.unwrap(),
                    kind.required_bits()
                ),
            ));
        }
    }
    infer_expr_ctx(expr, env, sigs, types)
}

/// Infer the type of an expression, in the context of the unit's named types.
pub fn infer_expr_ctx(
    expr: &Expr,
    env: &Env,
    sigs: &Signatures,
    types: &Types,
) -> Result<SemType, TypeError> {
    match &expr.kind {
        ExprKind::Literal(lit) => Ok(lit_type(lit)),

        ExprKind::Id(id) => {
            if let Some(ty) = env.get(&id.0) {
                return Ok(ty.clone());
            }
            // A bare unit-variant constructor (e.g. `None`).
            if let Some(sum) = find_constructor(types, &id.0) {
                let SemType::Sum { variants, .. } = sum else {
                    unreachable!()
                };
                let idx = sum.variant_index(&id.0).unwrap();
                if variants[idx].1.is_none() {
                    return Ok(sum.clone());
                }
                return Err(err(
                    &expr.span,
                    format!("`{}` requires its payload argument", id.0),
                ));
            }
            Err(err(&expr.span, format!("undefined variable `{}`", id.0)))
        }

        ExprKind::Cast { type_, operand } => {
            let target = resolve_type_ctx(type_, types)
                .ok_or_else(|| err(&expr.span, "unknown cast target type"))?;
            let _ = infer_expr_ctx(operand, env, sigs, types)?;
            Ok(target)
        }

        ExprKind::UnaryOp { op, operand } => {
            let inner = infer_expr_ctx(operand, env, sigs, types)?;
            match op {
                OpKind::Not => match inner {
                    SemType::Bool => Ok(SemType::Bool),
                    other => Err(err(&expr.span, format!("`!` requires Bool, found {other}"))),
                },
                OpKind::Plus | OpKind::Minus | OpKind::Tilde => match inner {
                    SemType::Numeric(n) => {
                        if op == &OpKind::Tilde && n.is_dec() {
                            return Err(err(
                                &expr.span,
                                "`~` requires an integer operand",
                            ));
                        }
                        Ok(inner)
                    }
                    other => Err(err(
                        &expr.span,
                        format!("unary `{op:?}` requires numeric, found {other}"),
                    )),
                },
                _ => Err(err(
                    &expr.span,
                    format!("unsupported unary operator {op:?}"),
                )),
            }
        }

        ExprKind::BinaryOp { op, lhs, rhs } => {
            infer_binary(op, lhs, rhs, env, sigs, types, &expr.span)
        }

        ExprKind::If {
            cond,
            then_block,
            else_block,
        } => {
            match infer_expr_ctx(cond, env, sigs, types)? {
                SemType::Bool => {}
                other => {
                    return Err(err(
                        &expr.span,
                        format!("if condition must be Bool, found {other}"),
                    ));
                }
            }
            match else_block {
                Some(b) => {
                    let t = block_ret(then_block, env, sigs, types)?;
                    let e = block_ret(b, env, sigs, types)?;
                    if t != e {
                        return Err(err(&expr.span, format!("if arms disagree: {t} vs {e}")));
                    }
                    Ok(t)
                }
                None => block_ret(then_block, env, sigs, types),
            }
        }

        ExprKind::Call { func, args } => infer_call(func, args, env, sigs, types, &expr.span),

        ExprKind::Using { value, behavior } => {
            infer_using(value, behavior, env, sigs, types, &expr.span)
        }

        ExprKind::Match {
            scrutinee,
            arms,
        } => infer_match(scrutinee, arms, env, sigs, types, &expr.span),

        // Composite literals and their accessors.
        ExprKind::ListLit(elems) => infer_list(elems, env, sigs, types, &expr.span),
        ExprKind::MapLit(entries) => infer_map(entries, env, sigs, types, &expr.span),
        ExprKind::SetLit(elems) => infer_set(elems, env, sigs, types, &expr.span),
        ExprKind::Range { start, end, .. } => {
            let st = infer_expr_ctx(start, env, sigs, types)?;
            let et = infer_expr_ctx(end, env, sigs, types)?;
            match (&st, &et) {
                (SemType::Numeric(_), SemType::Numeric(_)) => Ok(SemType::Range(Box::new(st))),
                _ => Err(err(
                    &expr.span,
                    format!("range bounds must be numeric, found {st} and {et}"),
                )),
            }
        }
        ExprKind::Slice { target, range: _ } => {
            let tt = infer_expr_ctx(target, env, sigs, types)?;
            match &tt {
                SemType::List(elem) => Ok(SemType::Slice(elem.clone())),
                other => Err(err(
                    &expr.span,
                    format!("cannot slice value of type {other}"),
                )),
            }
        }
        ExprKind::StructLit { name, fields } => {
            infer_struct_lit(name, fields, env, sigs, types, &expr.span)
        }
        ExprKind::FieldAccess { target, field } => {
            let tt = infer_expr_ctx(target, env, sigs, types)?;
            match &tt {
                SemType::Struct { fields, .. } => match fields.iter().find(|(n, _)| n == &field.0) {
                    Some((_, ft)) => Ok(ft.clone()),
                    None => Err(err(
                        &expr.span,
                        format!("type `{tt}` has no field `{}`", field.0),
                    )),
                },
                SemType::SourceLoc => {
                    match source_loc_fields().iter().find(|(n, _)| n == &field.0) {
                        Some((_, ft)) => Ok(ft.clone()),
                        None => Err(err(
                            &expr.span,
                            format!("type `{tt}` has no field `{}`", field.0),
                        )),
                    }
                }
                other => Err(err(
                    &expr.span,
                    format!("cannot access field `{}` on {other}", field.0),
                )),
            }
        }
        ExprKind::Index { target, index } => {
            let tt = infer_expr_ctx(target, env, sigs, types)?;
            match &tt {
                SemType::List(elem) => {
                    let it = infer_expr_ctx(index, env, sigs, types)?;
                    match it {
                        SemType::Numeric(_) => {}
                        other => {
                            return Err(err(
                                &index.span,
                                format!("list index must be numeric, found {other}"),
                            ));
                        }
                    }
                    Ok((**elem).clone())
                }
                SemType::Map(k, v) => {
                    let it = infer_expr_ctx(index, env, sigs, types)?;
                    if &it != k.as_ref() {
                        return Err(err(
                            &index.span,
                            format!("map index key mismatch: map has key {k}, found {it}"),
                        ));
                    }
                    Ok(SemType::Sum {
                        name: "Option".into(),
                        variants: vec![
                            ("None".into(), None),
                            ("Some".into(), Some(v.as_ref().clone())),
                        ],
                    })
                }
                other => Err(err(
                    &expr.span,
                    format!("cannot index value of type {other}"),
                )),
            }
        }
        ExprKind::MethodCall { target, method, args } => {
            // Built-in list methods surface here as sugar; only `len`,
            // `get` and `concat` are recognized for now.
            let tt = infer_expr_ctx(target, env, sigs, types)?;
            let method_name = &method.0;
            if args.is_empty() {
                match (method_name.as_str(), &tt) {
                    ("len", SemType::List(_)) => {
                        return Ok(SemType::Numeric(NumericType::ISize));
                    }
                    _ => {}
                }
            }
            // `a.concat(b)` joins two lists of the same element type.
            if method_name == "concat" {
                let SemType::List(elem) = &tt else {
                    return Err(err(
                        &expr.span,
                        format!("cannot call `.concat` on {tt}; only lists support it"),
                    ));
                };
                if args.len() != 1 {
                    return Err(err(
                        &expr.span,
                        "`.concat` takes exactly one list argument",
                    ));
                }
                let at = infer_expr_ctx(&args[0], env, sigs, types)?;
                match at {
                    SemType::List(ae) if &ae == elem => {
                        return Ok(SemType::List(elem.clone()));
                    }
                    _ => {
                        return Err(err(
                            &expr.span,
                            format!(
                                "`.concat` expects `List({elem})`, found {at}"
                            ),
                        ));
                    }
                }
            }
            // ─── Map methods ────────────────────────────────────
            if let SemType::Map(k, v) = &tt {
                match method_name.as_str() {
                    "len" if args.is_empty() => {
                        return Ok(SemType::Numeric(NumericType::ISize));
                    }
                    "get" if args.len() == 1 => {
                        let at = infer_expr_ctx(&args[0], env, sigs, types)?;
                        if &at != k.as_ref() {
                            return Err(err(
                                &expr.span,
                                format!("`.get` key type mismatch: map has key {k}, found {at}"),
                            ));
                        }
                        return Ok(SemType::Sum {
                            name: "Option".into(),
                            variants: vec![
                                ("None".into(), None),
                                ("Some".into(), Some(v.as_ref().clone())),
                            ],
                        });
                    }
                    "insert" if args.len() == 2 => {
                        let kt = infer_expr_ctx(&args[0], env, sigs, types)?;
                        let vt = infer_expr_ctx(&args[1], env, sigs, types)?;
                        if &kt != k.as_ref() {
                            return Err(err(
                                &expr.span,
                                format!("`.insert` key type mismatch: map has key {k}, found {kt}"),
                            ));
                        }
                        if &vt != v.as_ref() {
                            return Err(err(
                                &expr.span,
                                format!("`.insert` value type mismatch: map has value {v}, found {vt}"),
                            ));
                        }
                        return Ok(tt.clone());
                    }
                    "contains" if args.len() == 1 => {
                        let at = infer_expr_ctx(&args[0], env, sigs, types)?;
                        if &at != k.as_ref() {
                            return Err(err(
                                &expr.span,
                                format!("`.contains` key type mismatch: map has key {k}, found {at}"),
                            ));
                        }
                        return Ok(SemType::Bool);
                    }
                    "remove" if args.len() == 1 => {
                        let at = infer_expr_ctx(&args[0], env, sigs, types)?;
                        if &at != k.as_ref() {
                            return Err(err(
                                &expr.span,
                                format!("`.remove` key type mismatch: map has key {k}, found {at}"),
                            ));
                        }
                        return Ok(tt.clone());
                    }
                    "keys" if args.is_empty() => {
                        return Ok(SemType::List(k.clone()));
                    }
                    "values" if args.is_empty() => {
                        return Ok(SemType::List(v.clone()));
                    }
                    _ => {}
                }
            }
            // ─── Set methods ────────────────────────────────────
            if let SemType::Set(elem) = &tt {
                match method_name.as_str() {
                    "len" if args.is_empty() => {
                        return Ok(SemType::Numeric(NumericType::ISize));
                    }
                    "contains" if args.len() == 1 => {
                        let at = infer_expr_ctx(&args[0], env, sigs, types)?;
                        if &at != elem.as_ref() {
                            return Err(err(
                                &expr.span,
                                format!("`.contains` type mismatch: set has element {elem}, found {at}"),
                            ));
                        }
                        return Ok(SemType::Bool);
                    }
                    "insert" if args.len() == 1 => {
                        let at = infer_expr_ctx(&args[0], env, sigs, types)?;
                        if &at != elem.as_ref() {
                            return Err(err(
                                &expr.span,
                                format!("`.insert` type mismatch: set has element {elem}, found {at}"),
                            ));
                        }
                        return Ok(tt.clone());
                    }
                    "remove" if args.len() == 1 => {
                        let at = infer_expr_ctx(&args[0], env, sigs, types)?;
                        if &at != elem.as_ref() {
                            return Err(err(
                                &expr.span,
                                format!("`.remove` type mismatch: set has element {elem}, found {at}"),
                            ));
                        }
                        return Ok(tt.clone());
                    }
                    "union" if args.len() == 1 => {
                        let at = infer_expr_ctx(&args[0], env, sigs, types)?;
                        if at != tt {
                            return Err(err(
                                &expr.span,
                                format!("`.union` type mismatch: expected {tt}, found {at}"),
                            ));
                        }
                        return Ok(tt.clone());
                    }
                    "difference" if args.len() == 1 => {
                        let at = infer_expr_ctx(&args[0], env, sigs, types)?;
                        if at != tt {
                            return Err(err(
                                &expr.span,
                                format!("`.difference` type mismatch: expected {tt}, found {at}"),
                            ));
                        }
                        return Ok(tt.clone());
                    }
                    "intersection" if args.len() == 1 => {
                        let at = infer_expr_ctx(&args[0], env, sigs, types)?;
                        if at != tt {
                            return Err(err(
                                &expr.span,
                                format!("`.intersection` type mismatch: expected {tt}, found {at}"),
                            ));
                        }
                        return Ok(tt.clone());
                    }
                    "to_list" if args.is_empty() => {
                        return Ok(SemType::List(elem.clone()));
                    }
                    _ => {}
                }
            }
            Err(err(
                &expr.span,
                format!("unsupported method `{method_name}` on {tt}"),
            ))
        }

        ExprKind::Rt(inner) => infer_expr_ctx(inner, env, sigs, types),
        ExprKind::AtResidual { inner, .. } => infer_expr_ctx(inner, env, sigs, types),
        ExprKind::RawString(_) => Ok(SemType::Str),
        ExprKind::FString(parts) => {
            // Validate each interpolated expression; f-strings are Str.
            for p in parts {
                if let resid_parser::FStringPart::Expr(e) = p {
                    infer_expr_ctx(e, env, sigs, types)?;
                }
            }
            Ok(SemType::Str)
        }
        ExprKind::ByteString(_) => Ok(SemType::Bytes),
        ExprKind::Location => Ok(SemType::SourceLoc),
        ExprKind::Discard(inner) => infer_expr_ctx(inner, env, sigs, types),
        ExprKind::ComptimePrint(inner) => {
            // Compile-time debug print of a statically-known value.
            infer_expr_ctx(inner, env, sigs, types)
        }
        ExprKind::Assert { cond, message } => {
            match infer_expr_ctx(cond, env, sigs, types)? {
                SemType::Bool => {}
                other => {
                    return Err(err(
                        &cond.span,
                        format!("assert condition must be Bool, found {other}"),
                    ));
                }
            }
            let mt = infer_expr_ctx(message, env, sigs, types)?;
            if mt != SemType::Str {
                return Err(err(
                    &message.span,
                    format!("assert message must be Str, found {mt}"),
                ));
            }
            Ok(SemType::Bool)
        }
        ExprKind::RtAssert { cond, message } => {
            match infer_expr_ctx(cond, env, sigs, types)? {
                SemType::Bool => {}
                other => {
                    return Err(err(
                        &cond.span,
                        format!("rt_assert condition must be Bool, found {other}"),
                    ));
                }
            }
            let mt = infer_expr_ctx(message, env, sigs, types)?;
            if mt != SemType::Str {
                return Err(err(
                    &message.span,
                    format!("rt_assert message must be Str, found {mt}"),
                ));
            }
            Ok(SemType::Bool)
        }
        ExprKind::Known(inner) | ExprKind::RtKnown(inner) => {
            infer_expr_ctx(inner, env, sigs, types)
        }
        ExprKind::Todo(_) | ExprKind::Unimplemented(_) => Ok(SemType::Bool),

ExprKind::While { cond, body } => {
            match infer_expr_ctx(cond, env, sigs, types)? {
                SemType::Bool => {}
                other => {
                    return Err(err(
                        &expr.span,
                        format!("while condition must be Bool, found {other}"),
                    ));
                }
            }
            let mut errs = Vec::new();
            type_check_block(body, env, sigs, types, &mut errs);
            if let Some(e) = errs.into_iter().next() {
                return Err(e);
            }
            Ok(SemType::Bool)
        }

        ExprKind::IfLet {
            pattern,
            source,
            then_block,
            else_block,
        } => {
            let st = infer_expr_ctx(source, env, sigs, types)?;
            // The pattern must be applicable to the source type; bindings live
            // inside the then-branch only.
            let mut then_env = env.clone();
            bind_pattern(pattern, &st, &mut then_env, types, sigs)?;
            let mut errs = Vec::new();
            type_check_block(then_block, &then_env, sigs, types, &mut errs);
            if let Some(e) = errs.into_iter().next() {
                return Err(e);
            }
            match else_block {
                Some(b) => {
                    let mut errs = Vec::new();
                    type_check_block(b, env, sigs, types, &mut errs);
                    if let Some(e) = errs.into_iter().next() {
                        return Err(e);
                    }
                    Ok(SemType::Bool)
                }
                None => Ok(SemType::Bool),
            }
        }

        ExprKind::WhileLet {
            pattern,
            source,
            body,
        } => {
            let st = infer_expr_ctx(source, env, sigs, types)?;
            let mut body_env = env.clone();
            bind_pattern(pattern, &st, &mut body_env, types, sigs)?;
            let mut errs = Vec::new();
            type_check_block(body, &body_env, sigs, types, &mut errs);
            if let Some(e) = errs.into_iter().next() {
                return Err(e);
            }
            Ok(SemType::Bool)
        }

        ExprKind::EarlyReturn(inner) => {
            // `value?` — unwrap a residual/Option: the enclosing function
            // returns the unit variant early; here the payload type is the
            // expression's type.
            let st = infer_expr_ctx(inner, env, sigs, types)?;
            match residual_payload(&st) {
                Some(pt) => Ok(pt),
                None => Err(err(
                    &expr.span,
                    format!("`?` requires an Option, found {st}"),
                )),
            }
        }

        ExprKind::ElseFallback { value, fallback } => {
            // `value else { … }` — unwrap; on the unit variant run the block.
            let st = infer_expr_ctx(value, env, sigs, types)?;
            let pt = match residual_payload(&st) {
                Some(pt) => pt,
                None => {
                    return Err(err(
                        &expr.span,
                        format!("`value else` requires an Option, found {st}"),
                    ));
                }
            };
            let mut errs = Vec::new();
            type_check_block(fallback, env, sigs, types, &mut errs);
            if let Some(e) = errs.into_iter().next() {
                return Err(e);
            }
            let ft = block_ret(fallback, env, sigs, types)?;
            if ft != pt {
                return Err(err(
                    &expr.span,
                    format!("`else` block yields {ft}, need payload {pt}"),
                ));
            }
            Ok(pt)
        }

        ExprKind::ForIn { type_, name, collection, body } => {
            let col_ty = infer_expr_ctx(collection, env, sigs, types)?;
            let declared = resolve_type_ctx(type_, types).unwrap_or(SemType::Bool);
            let elem_ty = match &col_ty {
                SemType::List(inner) => {
                    if declared != **inner {
                        return Err(err(
                            &expr.span,
                            format!(
                                "for-in element type mismatch: declared {declared}, collection has {inner}"
                            ),
                        ));
                    }
                    inner.as_ref().clone()
                }
                SemType::Range(inner) => {
                    if declared != **inner {
                        return Err(err(
                            &expr.span,
                            format!(
                                "for-in element type mismatch: declared {declared}, range has {inner}"
                            ),
                        ));
                    }
                    inner.as_ref().clone()
                }
                other => {
                    return Err(err(
                        &expr.span,
                        format!("for-in collection must be List or Range, found {other}"),
                    ));
                }
            };
            let mut errs = Vec::new();
            let mut for_env = env.clone();
            if let Err(_) = for_env.try_insert(&name.0, elem_ty) {
                return Err(err(
                    &expr.span,
                    format!("loop variable `{}` is already bound; shadowing is forbidden", name.0),
                ));
            }
            type_check_block(body, &for_env, sigs, types, &mut errs);
            if let Some(e) = errs.into_iter().next() {
                return Err(e);
            }
            Ok(SemType::Bool)
        }

        ExprKind::ProviderCall { provider, verb, args } => {
            infer_provider_call(provider, verb, args, env, sigs, types, &expr.span)
        }

        ExprKind::With { bindings, body } => {
            // spec §16: `with (Type h = expr) { body }` acquires `h` for the
            // duration of `body`, then releases it (RAII, reverse order).
            let mut with_env = env.clone();
            for b in bindings {
                let declared = resolve_type_ctx(&b.type_, types).ok_or_else(|| {
                    err(&expr.span, format!("unknown with-binding type"))
                })?;
                let has = infer_expr_expected(&b.init, &with_env, sigs, types, Some(&declared))?;
                if &has != &declared {
                    return Err(err(
                        &b.init.span,
                        format!(
                            "with binding `{}`: expected {}, found {}",
                            b.name.0, declared, has
                        ),
                    ));
                }
                with_env.try_insert(&b.name.0, declared).map_err(|_| {
                    err(
                        &expr.span,
                        format!(
                            "identifier `{}` is already bound; shadowing is forbidden",
                            b.name.0
                        ),
                    )
                })?;
            }
            let mut errs = Vec::new();
            type_check_block(body, &with_env, sigs, types, &mut errs);
            if let Some(e) = errs.into_iter().next() {
                return Err(e);
            }
            block_ret(body, &with_env, sigs, types)
        }

        ExprKind::Spawn { body, .. } => {
            // spec §19: `spawn (caps) { body } : Result(T, RegionError)` where
            // T is the block's tail value type.
            let mut errs = Vec::new();
            type_check_block(body, env, sigs, types, &mut errs);
            if let Some(e) = errs.into_iter().next() {
                return Err(e);
            }
            let bt = block_ret(body, env, sigs, types)?;
            let region_error = SemType::Struct {
                name: "RegionError".into(),
                fields: vec![("message".into(), SemType::Str)],
            };
            Ok(SemType::Sum {
                name: "Result".into(),
                variants: vec![("Ok".into(), Some(bt)), ("Err".into(), Some(region_error))],
            })
        }

        other => Err(err(
            &expr.span,
            format!("type checking not yet supported for `{}`", kind_tag(other)),
        )),
    }
}

/// Infer a provider call `provider.verb(args)` (spec §32). The provider must
/// be trusted and the verb known; each verb declares its parameter arity and
/// return type. Interpolated/provided external knowledge is volatile.
///
/// To add a verb: extend `PROVIDER_VERBS` (and the matching runtime helper in
/// `resid_rt.c`, plus the codegen dispatch in `resid-codegen`'s
/// `lower_provider_call`).
fn infer_provider_call(
    provider: &Id,
    verb: &Id,
    args: &[Box<Expr>],
    env: &Env,
    sigs: &Signatures,
    types: &Types,
    span: &Span,
) -> Result<SemType, TypeError> {
    if !resid_parser::is_provider_name(&provider.0) {
        return Err(err(span, format!("unknown provider `{}`", provider.0)));
    }
    let verbs = provider_verbs();
    let entry = verbs
        .iter()
        .find(|(p, v, _, _)| p == &provider.0 && v == &verb.0)
        .ok_or_else(|| {
            err(
                span,
                format!("provider `{}` has no verb `{}`", provider.0, verb.0),
            )
        })?;
    let (_, _, param_tys, ret) = entry;
    if args.len() != param_tys.len() {
        return Err(err(
            span,
            format!(
                "`{}.{}` expects {} argument(s), found {}",
                provider.0,
                verb.0,
                param_tys.len(),
                args.len()
            ),
        ));
    }
    for (a, pt) in args.iter().zip(param_tys.iter()) {
        let at = infer_expr_ctx(a, env, sigs, types)?;
        if &at != pt {
            return Err(err(
                span,
                format!(
                    "`{}.{}` argument must be {pt}, found {at}",
                    provider.0, verb.0
                ),
            ));
        }
    }
    Ok(ret.clone())
}

/// Infer a list literal: homogeneous element type, or an explicit element type.
fn infer_list(
    elems: &[Expr],
    env: &Env,
    sigs: &Signatures,
    types: &Types,
    span: &Span,
) -> Result<SemType, TypeError> {
    let mut elem_ty: Option<SemType> = None;
    for e in elems {
        let t = infer_expr_ctx(e, env, sigs, types)?;
        match &elem_ty {
            None => elem_ty = Some(t),
            Some(known) => {
                if &t != known {
                    return Err(err(
                        span,
                        format!("list elements differ: {known} vs {t}"),
                    ));
                }
            }
        }
    }
    match elem_ty {
        Some(e) => Ok(SemType::List(Box::new(e))),
        None => Err(err(
            span,
            "cannot infer element type of an empty list literal (add an explicit type)",
        )),
    }
}

fn infer_map(
    entries: &[(Expr, Expr)],
    env: &Env,
    sigs: &Signatures,
    types: &Types,
    span: &Span,
) -> Result<SemType, TypeError> {
    let mut key_ty: Option<SemType> = None;
    let mut val_ty: Option<SemType> = None;
    for (k, v) in entries {
        let kt = infer_expr_ctx(k, env, sigs, types)?;
        let vt = infer_expr_ctx(v, env, sigs, types)?;
        match &key_ty {
            None => {
                key_ty = Some(kt);
                val_ty = Some(vt);
            }
            Some(known_k) => {
                if &kt != known_k {
                    return Err(err(
                        span,
                        format!("map keys differ: {known_k} vs {kt}"),
                    ));
                }
                if &vt != val_ty.as_ref().unwrap() {
                    return Err(err(
                        span,
                        format!(
                            "map values differ: {} vs {vt}",
                            val_ty.as_ref().unwrap()
                        ),
                    ));
                }
            }
        }
    }
    match (key_ty, val_ty) {
        (Some(k), Some(v)) => Ok(SemType::Map(Box::new(k), Box::new(v))),
        _ => Err(err(
            span,
            "cannot infer types of an empty map literal (add an explicit type)",
        )),
    }
}

fn infer_set(
    elems: &[Expr],
    env: &Env,
    sigs: &Signatures,
    types: &Types,
    span: &Span,
) -> Result<SemType, TypeError> {
    let mut elem_ty: Option<SemType> = None;
    for e in elems {
        let t = infer_expr_ctx(e, env, sigs, types)?;
        match &elem_ty {
            None => elem_ty = Some(t),
            Some(known) => {
                if &t != known {
                    return Err(err(
                        span,
                        format!("set elements differ: {known} vs {t}"),
                    ));
                }
            }
        }
    }
    match elem_ty {
        Some(e) => Ok(SemType::Set(Box::new(e))),
        None => Err(err(
            span,
            "cannot infer element type of an empty set literal (add an explicit type)",
        )),
    }
}

fn infer_struct_lit(
    name: &Id,
    fields: &[(Id, Expr)],
    env: &Env,
    sigs: &Signatures,
    types: &Types,
    span: &Span,
) -> Result<SemType, TypeError> {
    let ty = types
        .get(&name.0)
        .map(Clone::clone)
        .or_else(|| type_from_name(&name.0))
        .ok_or_else(|| err(span, format!("unknown type `{}`", name.0)))?;
    let SemType::Struct { fields: defs, .. } = &ty else {
        return Err(err(span, format!("`{}` is not a struct type", name.0)));
    };
    for (fname, fval) in fields {
        let want = defs
            .iter()
            .find(|(n, _)| n == &fname.0)
            .ok_or_else(|| err(span, format!("`{}` has no field `{}`", name.0, fname.0)))?;
        let has = infer_expr_expected(fval, env, sigs, types, Some(&want.1))?;
        if &has != &want.1 {
            return Err(err(
                span,
                format!(
                    "field `{}` of `{}`: expected {}, found {}",
                    fname.0, name.0, want.1, has
                ),
            ));
        }
    }
    Ok(ty.clone())
}

/// Type a match: bind pattern variables per arm and check the arms agree.
fn infer_match(
    scrutinee: &Expr,
    arms: &[(Pattern, Expr)],
    env: &Env,
    sigs: &Signatures,
    types: &Types,
    span: &Span,
) -> Result<SemType, TypeError> {
    let st = infer_expr_ctx(scrutinee, env, sigs, types)?;
    let SemType::Sum { .. } = &st else {
        return Err(err(
            &scrutinee.span,
            format!("match scrutinee must be a sum type, not {st}"),
        ));
    };
    let mut result: Option<SemType> = None;
    for (pat, body) in arms {
        let mut arm_env = env.clone();
        bind_pattern(pat, &st, &mut arm_env, types, sigs)?;
        let bt = infer_expr_ctx(body, &arm_env, sigs, types)?;
        match &result {
            None => result = Some(bt),
            Some(expect) => {
                if expect != &bt {
                    return Err(err(
                        span,
                        format!("match arms disagree: {expect} vs {bt}"),
                    ));
                }
            }
        }
    }
    match result {
        Some(t) => Ok(t),
        None => Err(err(span, "match with no arms")),
    }
}

/// Bind the variables a pattern introduces, checking it against a value type.
fn bind_pattern(
    pat: &Pattern,
    ty: &SemType,
    env: &mut Env,
    types: &Types,
    sigs: &Signatures,
) -> Result<(), TypeError> {
    match &pat.kind {
        PatternKind::Wildcard | PatternKind::Literal(_) => Ok(()),
        PatternKind::Bind(name) => {
            // A bare identifier that names a unit variant of the value type is
            // the variant itself (`None`), not a capture binding.
            if ty.unit_variant_index(&name.0).is_some() {
                return Ok(());
            }
            env.try_insert(&name.0, ty.clone())
                .map_err(|_| err(&pat.span, format!("identifier `{}` is already bound; shadowing is forbidden", name.0)))?;
            Ok(())
        }
        PatternKind::Variant { name, param } => {
            let SemType::Sum { variants, .. } = ty else {
                return Err(err(&pat.span, format!("cannot match variants of {ty}")));
            };
            let idx = ty
                .variant_index(&name.0)
                .ok_or_else(|| err(&pat.span, format!("`{ty}` has no variant `{}`", name.0)))?;
            let (_, payload) = &variants[idx];
            match (param, payload) {
                (Some(b), Some(pt)) => {
                    env.try_insert(&b.0, pt.clone())
                        .map_err(|_| err(&pat.span, format!("identifier `{}` is already bound; shadowing is forbidden", b.0)))?;
                    Ok(())
                }
                (None, None) => Ok(()),
                (Some(b), None) => Err(err(
                    &pat.span,
                    format!("variant `{}` carries no value to bind to `{}`", name.0, b.0),
                )),
                (None, Some(_)) => Err(err(
                    &pat.span,
                    format!("variant `{}` carries a payload that must be bound", name.0),
                )),
            }
        }
        PatternKind::Struct { name: _, fields } => {
            let SemType::Struct { fields: defs, .. } = ty else {
                return Err(err(&pat.span, format!("cannot destructure {ty}")));
            };
            let _ = defs;
            for (fname, sub) in fields {
                let fty = defs
                    .iter()
                    .find(|(n, _)| n == &fname.0)
                    .map(|(_, t)| t.clone())
                    .ok_or_else(|| err(&pat.span, format!("no field `{}`", fname.0)))?;
                bind_pattern(sub, &fty, env, types, sigs)?;
            }
            Ok(())
        }
    }
}

fn infer_binary(
    op: &OpKind,
    lhs: &Expr,
    rhs: &Expr,
    env: &Env,
    sigs: &Signatures,
    types: &Types,
    span: &Span,
) -> Result<SemType, TypeError> {
    // Logical connectives require Bool operands.
    if matches!(op, OpKind::AndAnd | OpKind::OrOr) {
        require_bool(lhs, env, sigs, types, span, "left operand of logical operator")?;
        require_bool(rhs, env, sigs, types, span, "right operand of logical operator")?;
        return Ok(SemType::Bool);
    }

    // Bool equality/inequality: Bool == Bool → Bool, Bool != Bool → Bool
    if matches!(op, OpKind::EqEq | OpKind::Ne) {
        let lt = infer_expr_ctx(lhs, env, sigs, types)?;
        let rt = infer_expr_ctx(rhs, env, sigs, types)?;
        if lt == SemType::Bool && rt == SemType::Bool {
            return Ok(SemType::Bool);
        }
        // Str equality/inequality: Str == Str → Bool, Str != Str → Bool.
        // Needed by the bootstrap lexer to match keywords/identifiers.
        if lt == SemType::Str && rt == SemType::Str {
            return Ok(SemType::Bool);
        }
    }

    let binop = to_bin_op(op).ok_or_else(|| err(span, format!("unsupported operator {op:?}")))?;

    // String concatenation: Str + Str → Str (folds to a constant in codegen
    // when both sides are literal; runtime concat arrives with the stdlib).
    if matches!(binop, BinOp::Add) {
        let lt = infer_expr_ctx(lhs, env, sigs, types)?;
        let rt = infer_expr_ctx(rhs, env, sigs, types)?;
        if lt == SemType::Str && rt == SemType::Str {
            return Ok(SemType::Str);
        }
    }

    let lt = infer_expr_ctx(lhs, env, sigs, types)?;
    let rt = infer_expr_ctx(rhs, env, sigs, types)?;
    let (ln, rn) = match (&lt, &rt) {
        (SemType::Numeric(a), SemType::Numeric(b)) => (*a, *b),
        _ => {
            return Err(err(
                span,
                format!("numeric operator requires numeric operands ({lt} {op:?} {rt})"),
            ));
        }
    };

    // Bitwise/shift operators require integer operands.
    if matches!(
        binop,
        BinOp::ShiftLeft | BinOp::ShiftRight | BinOp::And | BinOp::Or | BinOp::Xor
    ) && (ln.is_float() || rn.is_float() || ln.is_dec() || rn.is_dec())
    {
        return Err(err(
            span,
            "bitwise/shift operator requires integer operands",
        ));
    }

    match numeric_result_type(&ln, binop, &rn) {
        ResultType::Bool => Ok(SemType::Bool),
        ResultType::Numeric(n) => Ok(SemType::Numeric(n)),
        ResultType::Error(NumericError::SignednessMix) => Err(err(
            span,
            "cannot mix signed and unsigned operands in one operation",
        )),
        ResultType::Error(NumericError::DecMix) => Err(err(
            span,
            "cannot mix Dec with Int/UInt/Float in one operation (convert explicitly via dN/iN/fN)",
        )),
        ResultType::Error(NumericError::DecOp) => Err(err(
            span,
            "bitwise/shift operator requires integer operands",
        )),
    }
}

fn require_bool(
    e: &Expr,
    env: &Env,
    sigs: &Signatures,
    types: &Types,
    span: &Span,
    who: &str,
) -> Result<(), TypeError> {
    match infer_expr_ctx(e, env, sigs, types)? {
        SemType::Bool => Ok(()),
        other => Err(err(span, format!("{who} must be Bool, found {other}"))),
    }
}

fn block_ret(
    block: &Block,
    env: &Env,
    sigs: &Signatures,
    types: &Types,
) -> Result<SemType, TypeError> {
    // Register bindings declared by the block's statements (and recurse into
    // nested control flow) so the tail expression can reference them — e.g.
    // `if (c) { Int k = 1; return k; }`.
    let mut env = env.clone();
    for stmt in &block.statements {
        match &stmt.kind {
            StmtKind::Bind {
                name,
                type_: opt_type,
                value,
            } => {
                let ty = if let Some(t) = opt_type {
                    let declared = resolve_type_ctx(t, types).unwrap_or(SemType::Bool);
                    let inferred = infer_expr_expected(value, &env, sigs, types, Some(&declared))?;
                    if !bind_assignable(value, &inferred, &declared) {
                        return Err(err(
                            &stmt.span,
                            format!(
                                "binding `{}`: expected {declared}, found {inferred}",
                                name.0
                            ),
                        ));
                    }
                    declared
                } else {
                    infer_expr_ctx(value, &env, sigs, types)?
                };
                env.try_insert(&name.0, ty)
                    .map_err(|_| err(&stmt.span, format!("identifier `{}` is already bound; shadowing is forbidden", name.0)))?;
            }
            StmtKind::Destructure { pattern, source } => {
                let st = infer_expr_ctx(source, &env, sigs, types)?;
                if !is_refutable_pattern(pattern) {
                    bind_pattern(pattern, &st, &mut env, types, sigs)?;
                }
            }
            StmtKind::Expr(e) => {
                match &e.kind {
                    ExprKind::If {
                        then_block,
                        else_block,
                        ..
                    } => {
                        block_ret(then_block, &env, sigs, types)?;
                        if let Some(eb) = else_block {
                            block_ret(eb, &env, sigs, types)?;
                        }
                    }
                    ExprKind::While { body, .. } => {
                        block_ret(body, &env, sigs, types)?;
                    }
                    ExprKind::IfLet {
                        pattern,
                        source,
                        then_block,
                        else_block,
                    } => {
                        let st = infer_expr_ctx(source, &env, sigs, types)?;
                        let mut then_env = env.clone();
                        bind_pattern(pattern, &st, &mut then_env, types, sigs)?;
                        block_ret(then_block, &then_env, sigs, types)?;
                        if let Some(eb) = else_block {
                            block_ret(eb, &env, sigs, types)?;
                        }
                    }
                    ExprKind::WhileLet {
                        pattern,
                        source,
                        body,
                    } => {
                        let st = infer_expr_ctx(source, &env, sigs, types)?;
                        let mut body_env = env.clone();
                        bind_pattern(pattern, &st, &mut body_env, types, sigs)?;
                        block_ret(body, &body_env, sigs, types)?;
                    }
                    _ => {
                        let _ = infer_expr_ctx(e, &env, sigs, types)?;
                    }
                }
            }
            _ => {}
        }
    }
    if let Some(ret) = &block.ret {
        return infer_expr_ctx(ret, &env, sigs, types);
    }
    if let Some(stmt) = block.statements.last() {
        if let StmtKind::Expr(e) = &stmt.kind {
            return infer_expr_ctx(e, &env, sigs, types);
        }
    }
    Ok(SemType::Bool)
}

/// A `using = Ord(T)` clause parses as `Using { value, behavior }` wrapping
/// the qualified argument. Validate the behavior instance against the
/// element type and return the wrapped value's own type.
fn infer_using(
    value: &Expr,
    behavior: &Id,
    env: &Env,
    sigs: &Signatures,
    types: &Types,
    span: &Span,
) -> Result<SemType, TypeError> {
    let ty = infer_expr_ctx(value, env, sigs, types)?;
    let elem = match &ty {
        SemType::List(e) => *e.clone(),
        other => {
            return Err(err(
                span,
                format!("`using` qualifies a List argument, found {other}"),
            ))
        }
    };
    // Resolve through any number of Reverse(...) wrappers (spec §11).
    let mut layers = 0usize;
    let mut inner = behavior.0.as_str();
    while let Some(rest) = inner
        .strip_prefix("Reverse(")
        .and_then(|r| r.strip_suffix(')'))
    {
        layers += 1;
        inner = rest;
    }
    if !inner.contains('(') {
        return Err(err(
            span,
            format!("behavior instance `{inner}` must name a type, e.g. Ord(Int)"),
        ));
    }
    let key = format!("behavior::{inner}");
    let Some(sig) = sigs.get(&key) else {
        return Err(err(
            span,
            format!("no behavior instance `{inner}` is defined"),
        ));
    };
    if sig.params.first() != Some(&elem) {
        return Err(err(
            span,
            format!(
                "behavior `{inner}` orders {}, but the list holds {}",
                sig.params.first().map(|t| t.to_string()).unwrap_or_default(),
                elem
            ),
        ));
    }
    Ok(ty)
}

fn infer_call(
    callee: &Expr,
    args: &[(Option<Id>, Expr)],
    env: &Env,
    sigs: &Signatures,
    types: &Types,
    span: &Span,
) -> Result<SemType, TypeError> {
    let name = match &callee.kind {
        ExprKind::Id(id) => id.0.clone(),
        _ => return Err(err(span, "only direct function calls are supported")),
    };
    // A variant constructor (Some(x), None, …) — resolve to the owning sum.
    if !sigs.contains_key(&name) {
        if let Some(sum) = find_constructor(types, &name) {
            let SemType::Sum { variants, .. } = sum else {
                unreachable!()
            };
            let idx = sum
                .variant_index(&name)
                .ok_or_else(|| err(span, format!("unknown variant `{name}`")))?;
            let (_, payload) = &variants[idx];
            match payload {
                None => {
                    if args.is_empty() {
                        return Ok(sum.clone());
                    }
                    return Err(err(span, format!("`{name}` takes no arguments")));
                }
                Some(pt) => {
                    if args.len() != 1 {
                        return Err(err(
                            span,
                            format!("`{name}` expects exactly one payload argument"),
                        ));
                    }
                    let at = infer_expr_ctx(&args[0].1, env, sigs, types)?;
                    if &at != pt && !literal_compatible(&args[0].1, pt) {
                        return Err(err(
                            &args[0].1.span,
                            format!("`{name}` payload: expected {pt}, found {at}"),
                        ));
                    }
                    return Ok(sum.clone());
                }
            }
        }
    }
    // `sort(xs, using = Ord(T))` — no fixed signature; the element type and
    // behavior instance are validated by the Using arm on the argument.
    if name == "sort" {
        if args.len() != 1 {
            return Err(err(span, "sort expects exactly one list argument"));
        }
        if !matches!(args[0].1.kind, ExprKind::Using { .. }) {
            return Err(err(
                span,
                "sort requires a behavior: sort(xs, using = Ord(T))",
            ));
        }
        return infer_expr_ctx(&args[0].1, env, sigs, types);
    }
    let sig = best_overload(
        &args
            .iter()
            .map(|(_, a)| infer_expr_ctx(a, env, sigs, types).unwrap_or(SemType::Bool))
            .collect::<Vec<_>>(),
        sigs,
        &name,
    )
    .ok_or_else(|| err(span, format!("call to undefined function `{name}`")))?;
    // Check: no more args than total params.
    if args.len() > sig.params.len() {
        return Err(err(
            span,
            format!(
                "`{name}` expects {} argument(s), got {}",
                sig.params.len(),
                args.len()
            ),
        ));
    }

    // Check: each provided arg maps to a real param or a param with a default.
    let mut used_positional = 0usize;
    for (name_opt, a) in args {
        let wanted_param = if let Some(n) = name_opt {
            // Named arg: find the param index by name.
            sig.param_names.iter().position(|p| p == &n.0).ok_or_else(|| {
                err(&a.span, format!("unknown parameter `{}` for `{}`", n.0, name))
            })?
        } else {
            // Positional arg: next available param.
            used_positional
        };

        if wanted_param >= sig.params.len() {
            return Err(err(
                span,
                format!("`{name}` expects {} argument(s), got {}", sig.params.len(), args.len()),
            ));
        }
        used_positional += 1;

        let want = &sig.params[wanted_param];
        let at = infer_expr_expected(a, env, sigs, types, Some(want))?;
        let conversion_ok = match name.chars().next() {
            Some(fc) if matches!(fc, 'i' | 'u' | 'f' | 'd') => {
                conversion_helper_match(&at, want, fc)
            }
            _ => false,
        };
        // Spec v3.2 §6.4: same-sign integer arguments adopt the
        // parameter width in either direction — narrowing is a CHECKED
        // conversion (compile error for provable constants, runtime
        // trap otherwise), never a silent truncation.
        let int_checked_narrow = matches!((&at, want), (SemType::Numeric(a), SemType::Numeric(t)) if
            !a.is_float() && !t.is_float() && !a.is_dec() && !t.is_dec()
            && a.is_signed() == t.is_signed());
        if !param_matches(&at, want)
            && !literal_compatible(a, want)
            && !numeric_can_widen(&at, want)
            && !int_checked_narrow
            && !conversion_ok
        {
            return Err(err(
                &a.span,
                format!(
                    "argument {} of `{name}`: expected {want}, found {at}",
                    wanted_param + 1
                ),
            ));
        }
    }

    // Check that any gap between provided positional args and total params
    // is covered by defaults.
    let max_positional = args
        .iter()
        .filter(|(n, _)| n.is_none())
        .count();
    let last_pos_param = max_positional.saturating_sub(1);
    for i in (last_pos_param + 1)..sig.params.len() {
        if sig.param_defaults.get(i).is_none() {
            return Err(err(
                span,
                format!(
                    "`{}` parameter `{}` has no default and is not provided",
                    name,
                    sig.param_names.get(i).map(|s| s.as_str()).unwrap_or("?")
                ),
            ));
        }
    }

    Ok(sig.ret.clone())
}

/// May an inferred value type be bound to a declared type? Covers the
/// established coercions: numeric literal adoption, lossless widening,
/// same-family arithmetic-margin narrowing (`Int(64) x = a + b` infers
/// `Int(128)` by the overflow margin but binds at the declared width), and
/// range construction against a numeric target.
fn bind_assignable(value: &Expr, inferred: &SemType, declared: &SemType) -> bool {
    if inferred == declared {
        return true;
    }
    if numeric_can_widen(inferred, declared) {
        return true;
    }
    // A numeric literal adopts its (wide-enough, same-sign) target type.
    if literal_compatible(value, declared) {
        return true;
    }
    // Decimal values round once to the declared precision (spec §6.6a), so
    // any Dec → Dec binding is accepted regardless of operand precision.
    if matches!(declared, SemType::Numeric(n) if n.is_dec())
        && matches!(inferred, SemType::Numeric(n) if n.is_dec())
    {
        return true;
    }
    if let (SemType::Numeric(a), SemType::Numeric(b)) = (inferred, declared) {
        // Integer-only margin narrowing at equal signedness; floats and Dec
        // must match exactly (or widen) — their ops carry no margin.
        if !a.is_float() && !b.is_float() && !a.is_dec() && !b.is_dec() {
            return a.is_signed() == b.is_signed();
        }
        return false;
    }
    // Sums are nominal: same name binds, even if payloads resolve
    // differently at the two inference sites.
    if let (SemType::Sum { name: a, .. }, SemType::Sum { name: b, .. }) = (inferred, declared) {
        return a == b;
    }
    // `0..10` / `0..=5` may bind to the endpoint's numeric type.
    if let SemType::Range(_) = inferred {
        return matches!(declared, SemType::Numeric(_));
    }
    false
}

/// A numeric literal may adopt a (same-sign, wide-enough) numeric target type,
/// so `Int(8) x = 5;` and calling an `i8`-typed function with `5` are allowed.
fn literal_compatible(a: &Expr, target: &SemType) -> bool {    let SemType::Numeric(t) = target else {
        return false;
    };
    // A decimal literal fits any Dec(N) target: narrowing rounds once to N
    // significant digits (spec §6.6a). Widening keeps the value exactly.
    if matches!(&a.kind, ExprKind::Literal(Literal::Dec(_))) && t.is_dec() {
        return true;
    }
    let ExprKind::Literal(Literal::Int { kind, .. }) = &a.kind else {
        return false;
    };
    let bits = t.target_width().unwrap_or(64) as u32;
    if bits >= 128 {
        return true;
    }
    let required = kind.required_bits() as u32;
    if t.is_unsigned() {
        required <= bits
    } else {
        required <= bits - 1
    }
}

/// Check if a parameter type matches an argument type. `Ptr` matches any
/// composite (List/Struct/Sum).
fn param_matches(arg: &SemType, param: &SemType) -> bool {
    if arg == param {
        return true;
    }
    // Ptr parameter matches any composite type.
    if matches!(param, SemType::Ptr) {
        matches!(arg, SemType::List(_) | SemType::Struct { .. } | SemType::Sum { .. })
    } else {
        false
    }
}

/// Check if a numeric argument type can be widened to the parameter type
/// (same sign, target width >= source width). Used for function call arguments
/// where `IntToString(i8_val)` should match `IntToString(Int(64))`.
fn numeric_can_widen(arg: &SemType, target: &SemType) -> bool {
    let SemType::Numeric(a) = arg else {
        return false;
    };
    let SemType::Numeric(t) = target else {
        return false;
    };
    // Dec never implicitly converts to/from Int/UInt/Float (spec §6.6a:
    // mixing is a hard error; conversion is explicit via dN/iN/fN). Dec→Dec
    // widens to at least as many significant digits.
    if a.is_dec() || t.is_dec() {
        return match (a, t) {
            (NumericType::Dec(ad), NumericType::Dec(td)) => td >= ad,
            _ => false,
        };
    }
    // Same signedness.
    if a.is_signed() != t.is_signed() {
        return false;
    }
    // For floats, allow widening to wider float types.
    if a.is_float() && t.is_float() {
        return a.target_width().unwrap_or(64) <= t.target_width().unwrap_or(64);
    }
    // For ints/uints, target must be at least as wide.
    if a.is_float() || t.is_float() {
        return false; // int↔float requires explicit cast
    }
    let target_bits = t.target_width().unwrap_or(64) as u32;
    let arg_bits = a.target_width().unwrap_or(64) as u32;
    target_bits >= arg_bits
}

/// Check if the argument type can be converted to the parameter type for
/// conversion helpers. `i32(some_i8)` should match `i32(Int(64))` by widening
/// the arg from Int(8) to Int(64).
fn conversion_helper_match(arg: &SemType, param: &SemType, first_char: char) -> bool {
    if let (SemType::Numeric(a), SemType::Numeric(p)) = (arg, param) {
        match first_char {
            'i' => (matches!(a, NumericType::Int(_)) || a.is_dec())
                && matches!(p, NumericType::Int(_))
                && (a.is_dec()
                    || p.target_width().unwrap_or(64) >= a.target_width().unwrap_or(64)),
            'u' => (matches!(a, NumericType::UInt(_)) || a.is_dec())
                && matches!(p, NumericType::UInt(_))
                && (a.is_dec()
                    || p.target_width().unwrap_or(64) >= a.target_width().unwrap_or(64)),
            'f' => (a.is_float() || a.is_dec())
                && p.is_float()
                && (a.is_dec()
                    || p.target_width().unwrap_or(64) >= a.target_width().unwrap_or(64)),
            // dN accepts Dec (widening or narrowing — dN is "exact conversion"
            // which rounds once when narrowing), Int (exact), or Str (exact
            // decimal parse) per spec §6.7.
            'd' => p.is_dec() && (a.is_dec() || a.is_integer() || matches!(arg, SemType::Str)),
            _ => false,
        }
    } else {
        first_char == 'd'
            && matches!(param, SemType::Numeric(NumericType::Dec(_)))
            && matches!(arg, SemType::Str)
    }
}

/// Select the best overload from a list of signatures whose first parameter
/// matches the argument type. For ToString-style functions with numeric
/// overloads this picks the most specific (narrowest) type that the argument
/// can safely be widened to. For conversion helpers (i8/i16/.../u8/.../f16/...)
/// this picks the narrowest parameter type that the argument can be widened to.
/// Synthesize a signature for the open-ended wrapping_/saturating_
/// arithmetic family: `(wrapping|saturating)_u?(add|sub|mul)` over any
/// numeric width; both operands must share one width.
fn arith_family_sig(args_ty: &[SemType], func: &str) -> Option<FunctionSig> {
    let (kind, rest) = if let Some(r) = func.strip_prefix("wrapping_") {
        ("wrapping", r)
    } else if let Some(r) = func.strip_prefix("saturating_") {
        ("saturating", r)
    } else {
        return None;
    };
    let _ = kind;
    let (unsigned, op) = match rest.strip_prefix('u') {
        Some(r) => (true, r),
        None => (false, rest),
    };
    if !matches!(op, "add" | "sub" | "mul") {
        return None;
    }
    let w0 = match args_ty.first() {
        Some(SemType::Numeric(n)) => *n,
        _ => return None,
    };
    let w1 = match args_ty.get(1) {
        Some(SemType::Numeric(n)) => *n,
        _ => return None,
    };
    // Widths must agree; unsigned family requires UInt operands.
    let matches_family = |n: &NumericType| {
        if unsigned {
            matches!(n, NumericType::UInt(_))
        } else {
            matches!(n, NumericType::Int(_))
        }
    };
    if w0 != w1 || !matches_family(&w0) {
        return None;
    }
    Some(FunctionSig {
        name: func.to_string(),
        params: vec![SemType::Numeric(w0), SemType::Numeric(w1)],
        param_names: vec!["a".into(), "b".into()],
        param_defaults: vec![None, None],
        ret: SemType::Numeric(w0),
        is_pub: true,
        file: String::new(),
        requires: Vec::new(),
        sandbox_ceiling: Vec::new(),
    })
}

pub fn best_overload(args_ty: &[SemType], sigs: &Signatures, func: &str) -> Option<FunctionSig> {
    // wrapping_*/saturating_ arithmetic is open-ended over the whole numeric
    // family (spec §6/§32): (wrapping|saturating)_u?(add|sub|mul) at any
    // width, requiring both operands at the same width. add/sub/mul only —
    // div keeps its enumerated i64 form.
    if let Some(sig) = arith_family_sig(args_ty, func) {
        return Some(sig);
    }
    // dN conversion helpers (spec §6.7) are open-ended (any N >= 1) and so are
    // not enumerated in BUILTIN_SIGS — synthesize the signature here. Accepted
    // from: Dec (exact, narrowing rounds once), Int (exact), Str (exact parse).
    if let Some(rest) = func.strip_prefix('d') {
        if let Ok(n) = rest.parse::<u16>() {
            if n >= 1 {
                let tgt = SemType::Numeric(NumericType::Dec(n));
                if let Some(arg) = args_ty.first() {
                    if conversion_helper_match(arg, &tgt, 'd') {
                        return Some(FunctionSig {
                            name: func.to_string(),
                            params: vec![tgt.clone()],
                            param_names: vec!["value".to_string()],
                            param_defaults: vec![None],
                            ret: tgt,
                            is_pub: true,
                            file: String::new(),
                            requires: Vec::new(),
                            sandbox_ceiling: Vec::new(),
                        });
                    }
                    return None;
                }
                return Some(FunctionSig {
                    name: func.to_string(),
                    params: vec![tgt.clone()],
                    param_names: vec!["value".to_string()],
                    param_defaults: vec![None],
                    ret: tgt,
                    is_pub: true,
                    file: String::new(),
                    requires: Vec::new(),
                    sandbox_ceiling: Vec::new(),
                });
            }
        }
    }
    let candidate = sigs.get(func)?;
    if candidate.params.len() != 1 {
        return Some(candidate.clone());
    }
    let want = &args_ty[0];

    // For ToString functions, find the best numeric match.
    if matches!(func, "IntToString" | "UIntToString" | "FloatToString") {
        let SemType::Numeric(arg) = want else {
            return Some(candidate.clone());
        };
        // Look for all overloads whose numeric type matches or is wider.
        let matching: Vec<(&SemType, FunctionSig)> = sigs
            .iter()
            .filter(|(n, _)| *n == func)
            .filter_map(|(_, sig)| {
                if sig.params.len() == 1 {
                    if let SemType::Numeric(_p) = &sig.params[0] {
                        return Some((&sig.params[0], sig.clone()));
                    }
                }
                None
            })
            .collect();

        // For IntToString/UIntToString, find the narrowest width that can
        // hold the argument value. Pick the one closest to (but >=) arg width.
        if func == "IntToString" || func == "UIntToString" {
            let arg_bits = arg.target_width().unwrap_or(64);
            let same_sign = |nt: &NumericType| {
                (func == "IntToString" && nt.is_signed()) || (func == "UIntToString" && nt.is_unsigned())
            };
            let best = matching
                .iter()
                .filter(|(p, _)| {
                    if let SemType::Numeric(np) = p {
                        same_sign(np) && np.target_width().unwrap_or(64) >= arg_bits
                    } else {
                        false
                    }
                })
                .min_by_key(|(p, _)| {
                    if let SemType::Numeric(np) = p {
                        np.target_width().unwrap_or(u16::MAX)
                    } else {
                        u16::MAX
                    }
                });
            if let Some((_, sig)) = best {
                return Some(sig.clone());
            }
            // Fall back to widest available
            if let Some((_, sig)) = matching.iter().max_by_key(|(p, _)| {
                if let SemType::Numeric(np) = p { np.target_width().unwrap_or(0) } else { 0 }
            }) {
                return Some(sig.clone());
            }
        }
        // FloatToString: find the narrowest float that can hold the arg
        if func == "FloatToString" {
            let arg_bits = arg.target_width().unwrap_or(64);
            let best = matching
                .iter()
                .filter(|(p, _)| {
                    if let SemType::Numeric(np) = p {
                        np.is_float() && np.target_width().unwrap_or(64) >= arg_bits
                    } else {
                        false
                    }
                })
                .min_by_key(|(p, _)| {
                    if let SemType::Numeric(np) = p { np.target_width().unwrap_or(u16::MAX) } else { u16::MAX }
                });
            if let Some((_, sig)) = best {
                return Some(sig.clone());
            }
            if let Some((_, sig)) = matching.iter().max_by_key(|(p, _)| {
                if let SemType::Numeric(np) = p { np.target_width().unwrap_or(0) } else { 0 }
            }) {
                return Some(sig.clone());
            }
        }
        return Some(candidate.clone());
    }

    // For BoolToString, exact match on Bool.
    if func == "BoolToString" {
        if matches!(want, SemType::Bool) {
            return Some(candidate.clone());
        }
        return Some(candidate.clone());
    }

    // For ToString on composites, exact match or fallback to first match.
    if func == "ToString" {
        return Some(candidate.clone());
    }

    // For conversion helpers (i8..i512, u8..u512, f16..f128, isize, usize),
    // find the narrowest parameter type that the argument can be widened to.
    let first_char = func.chars().next();
    if let Some(fc) = first_char {
        if matches!(fc, 'i' | 'u' | 'f') {
            let matching: Vec<(&SemType, FunctionSig)> = sigs
                .iter()
                .filter(|(n, _)| *n == func)
                .filter_map(|(_, sig)| {
                    if sig.params.len() == 1 {
                        if let SemType::Numeric(_) = &sig.params[0] {
                            return Some((&sig.params[0], sig.clone()));
                        }
                    }
                    None
                })
                .collect();
            let _arg_bits = match want {
                SemType::Numeric(n) => n.target_width().unwrap_or(64),
                _ => 64,
            };
            let best = matching
                .iter()
                .filter(|(p, _)| conversion_helper_match(want, p, fc))
                .min_by_key(|(p, _)| {
                    if let SemType::Numeric(n) = p { n.target_width().unwrap_or(u16::MAX) } else { u16::MAX }
                });
            if let Some((_, sig)) = best {
                return Some(sig.clone());
            }
            return Some(candidate.clone());
        }
    }

    Some(candidate.clone())
}

// ─── Upfront program type checking ─────────────────────────────

/// Flatten sandbox declarations: extract child declarations and set their
/// `sandbox_ceiling` from the enclosing sandbox's capability list (spec §21).
fn flatten_unit(unit: &TranslationUnit) -> Vec<Declaration> {
    unit.declarations
        .iter()
        .flat_map(|d| match d {
            Declaration::Sandbox(s) => {
                let ceiling = &s.capabilities;
                s.body.iter().map(|child| {
                    let mut c = child.clone();
                    if let Declaration::Function(f) = &mut c {
                        if f.sandbox_ceiling.is_empty() && !ceiling.is_empty() {
                            f.sandbox_ceiling = ceiling.clone();
                        }
                    }
                    c
                }).collect::<Vec<_>>()
            }
            other => vec![other.clone()],
        })
        .collect()
}

/// Type-check every function body in a translation unit.
/// Returns a list of errors (empty = all passed).
pub fn check_program(unit: &TranslationUnit) -> Vec<TypeError> {
    let types = collect_types(unit);
    let mut sigs = collect_signatures(unit);
    // Behavior instances become pseudo-signatures keyed `behavior::<Inst>`
    // so expression inference can resolve `using = Ord(Point)` without
    // threading a behaviors map through every infer_* function.
    let (behaviors, mut behavior_errs) = collect_behaviors(unit);
    for (key, func) in &behaviors {
        let param_name = key
            .split_once('(')
            .and_then(|(_, rest)| rest.strip_suffix(')'))
            .unwrap_or("");
        let param_ty = types
            .get(param_name)
            .cloned()
            .unwrap_or(SemType::Numeric(NumericType::Int(IntWidth::B64)));
        sigs.insert(
            format!("behavior::{key}"),
            FunctionSig {
                name: func.clone(),
                params: vec![param_ty.clone(), param_ty],
                param_names: vec!["a".into(), "b".into()],
                param_defaults: vec![None, None],
                ret: SemType::Numeric(NumericType::Int(IntWidth::B64)),
                is_pub: true,
                file: String::new(),
                requires: Vec::new(),
                sandbox_ceiling: Vec::new(),
            },
        );
    }
    let mut errs = Vec::new();
    errs.append(&mut behavior_errs);
    errs.extend(check_behaviors(unit, &sigs, &types, &behaviors));
    let mut seen: std::collections::HashSet<String> = std::collections::HashSet::new();
    let flat = flatten_unit(unit);
    for decl in &flat {
        if let Declaration::Function(f) = decl {
            if !seen.insert(f.name.0.clone()) {
                errs.push(err(
                    &f.span,
                    format!("function `{}` is already defined; duplicate definitions are forbidden", f.name.0),
                ));
                continue;
            }
            let mut env = Env::new();
            let sig = sigs.get(&f.name.0).unwrap();
            for (param, pt) in f.params.iter().zip(sig.params.iter()) {
                if let Err(_) = env.try_insert(&param.name.0, pt.clone()) {
                    errs.push(err(
                        &f.span,
                        format!("parameter `{}` is already bound; shadowing is forbidden", param.name.0),
                    ));
                }
            }
            type_check_block(&f.body, &env, &sigs, &types, &mut errs);
            // ── §21.3 sandbox enforcement ──────────────────────────
            // If the function is inside a sandbox, every @requires cap
            // must be present in the sandbox ceiling.
            if !sig.sandbox_ceiling.is_empty() {
                for req in &sig.requires {
                    if !sig.sandbox_ceiling.iter().any(|c| c == req) {
                        errs.push(err(
                            &f.span,
                            format!(
                                "function `{}` requires capability `{}` which exceeds the enclosing sandbox ceiling [{}]",
                                f.name.0,
                                req,
                                sig.sandbox_ceiling.join(", "),
                            ),
                        ));
                    }
                }
            }
        }
    }
    errs
}

fn type_check_block(
    block: &Block,
    env: &Env,
    sigs: &Signatures,
    types: &Types,
    errs: &mut Vec<TypeError>,
) {
    let mut env = env.clone();
    for stmt in &block.statements {
        if let StmtKind::Bind {
            name,
            type_: opt_type,
            value,
        } = &stmt.kind
        {
            let ty = if let Some(t) = opt_type {
                // Even with an explicit declared type the value expression is
                // validated, so e.g. `filesystem.exists()` still errors despite
                // `Bool ex = ...` giving a concrete binding type.
                let declared = resolve_type_ctx(t, types).unwrap_or(SemType::Bool);
                match infer_expr_expected(value, &env, sigs, types, Some(&declared)) {
                    Ok(inferred) => {
                        if !bind_assignable(value, &inferred, &declared) {
                            errs.push(err(
                                &stmt.span,
                                format!(
                                    "binding `{}`: expected {declared}, found {inferred}",
                                    name.0
                                ),
                            ));
                        }
                    }
                    Err(e) => errs.push(e),
                }
                declared
            } else {
                infer_expr_ctx(value, &env, sigs, types).unwrap_or(SemType::Bool)
            };
            if let Err(_) = env.try_insert(&name.0, ty) {
                errs.push(err(
                    &stmt.span,
                    format!("identifier `{}` is already bound; shadowing is forbidden", name.0),
                ));
            }
        }
        if let StmtKind::Destructure { pattern, source } = &stmt.kind {
            match infer_expr_ctx(source, &env, sigs, types) {
                Ok(st) => {
                    if is_refutable_pattern(pattern) {
                        errs.push(err(
                            &pattern.span,
                            "refutable pattern is not allowed in an irrefutable declaration",
                        ));
                    } else if let Err(b) = bind_pattern(pattern, &st, &mut env, types, sigs) {
                        errs.push(b);
                    }
                }
                Err(e) => errs.push(e),
            }
        }
        if let StmtKind::Expr(e) = &stmt.kind {
            if let Err(err) = infer_expr_ctx(e, &env, sigs, types) {
                errs.push(err);
            }
        }
        if let StmtKind::Discard(e) = &stmt.kind {
            if let Err(err) = infer_expr_ctx(e, &env, sigs, types) {
                errs.push(err);
            }
        }
    }
    if let Some(ret) = &block.ret {
        if let Err(err) = infer_expr_ctx(ret, &env, sigs, types) {
            errs.push(err);
        }
    }
}

/// `_`-style irrefutable patterns are required for declarations; any tagged
/// (variant) pattern is refutable.
fn is_refutable_pattern(pat: &Pattern) -> bool {
    match &pat.kind {
        PatternKind::Variant { .. } => true,
        _ => false,
    }
}

// ─── Tests ─────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;
    use resid_lexer::token::{FloatLit, IntKind, Literal, Op as OpKind, Span, StrLit};
    use resid_parser::{
        Block, Expr, ExprKind, Id, Pattern, PatternKind, RangeExpr, Stmt, StmtKind, Type,
    };

    fn span() -> Span {
        Span {
            file: String::new(),
            line: 0,
            col_start: 0,
            col_end: 0,
        }
    }

    fn expr_id(name: &str) -> Expr {
        Expr {
            kind: ExprKind::Id(Id(name.to_string())),
            span: span(),
        }
    }

    fn expr_int(v: u128) -> Expr {
        Expr {
            kind: ExprKind::Literal(Literal::Int {
                value: v,
                kind: IntKind::Decimal(v.to_string()),
            }),
            span: span(),
        }
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
        let e = Expr {
            kind: ExprKind::Literal(Literal::Bool(true)),
            span: span(),
        };
        let ty = infer_expr(&e, &Env::new(), &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Bool);
    }

    #[test]
    fn infer_literal_float() {
        let e = Expr {
            kind: ExprKind::Literal(Literal::Float(FloatLit {
                value: "3.14".into(),
            })),
            span: span(),
        };
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
        // a + b where both are i64 → i64 (spec v3.2 §6.1: widest operand;
        // overflow handled by checked semantics)
        let e = expr_binop(OpKind::Plus, "a", "b");
        let env = make_env();
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B64)));
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
        assert!(
            err.message.contains("signed and unsigned"),
            "expected signedness error, got: {}",
            err.message
        );
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
            kind: ExprKind::UnaryOp {
                op: OpKind::Not,
                operand: Box::new(expr_id("p")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Bool);
    }

    #[test]
    fn infer_unary_not_on_int_error() {
        let env = make_env();
        let e = Expr {
            kind: ExprKind::UnaryOp {
                op: OpKind::Not,
                operand: Box::new(expr_id("a")),
            },
            span: span(),
        };
        let result = infer_expr(&e, &env, &Signatures::new());
        assert!(result.is_err());
    }

    #[test]
    fn infer_unary_minus_on_int() {
        let env = make_env();
        let e = Expr {
            kind: ExprKind::UnaryOp {
                op: OpKind::Minus,
                operand: Box::new(expr_id("a")),
            },
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
        assert!(
            msg.contains("bitwise"),
            "expected bitwise error, got: {msg}"
        );
    }

    #[test]
    fn infer_cast() {
        // Cast a i64 to i32
        let e = Expr {
            kind: ExprKind::Cast {
                type_: Type::Base {
                    name: Id("i32".into()),
                    params: None,
                },
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
        env.insert(
            "a",
            SemType::Numeric(NumericType::Int(IntWidth::B64.into())),
        );
        env.insert(
            "b",
            SemType::Numeric(NumericType::Int(IntWidth::B64.into())),
        );
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
    fn infer_comptime_print() {
        let e = Expr {
            kind: ExprKind::ComptimePrint(Box::new(expr_int(42))),
            span: span(),
        };
        let ty = infer_expr(&e, &Env::new(), &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B64.into())));
    }

    #[test]
    fn infer_assert_ok() {
        let e = Expr {
            kind: ExprKind::Assert {
                cond: Box::new(Expr {
                    kind: ExprKind::Literal(Literal::Bool(true)),
                    span: span(),
                }),
                message: Box::new(Expr {
                    kind: ExprKind::RawString("boom".into()),
                    span: span(),
                }),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &Env::new(), &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Bool);
    }

    #[test]
    fn infer_assert_rejects_non_bool_cond() {
        let e = Expr {
            kind: ExprKind::Assert {
                cond: Box::new(expr_int(42)),
                message: Box::new(Expr {
                    kind: ExprKind::RawString("boom".into()),
                    span: span(),
                }),
            },
            span: span(),
        };
        let r = infer_expr(&e, &Env::new(), &Signatures::new());
        assert!(r.is_err());
    }

    #[test]
    fn infer_todo_ok() {
        let e = Expr {
            kind: ExprKind::Todo("finish".into()),
            span: span(),
        };
        let ty = infer_expr(&e, &Env::new(), &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Bool);
    }

    #[test]
    fn infer_range_is_range_of_start() {
        let e = Expr {
            kind: ExprKind::Range {
                start: Box::new(expr_int(0)),
                end: Box::new(expr_int(3)),
                closed: false,
            },
            span: span(),
        };
        let ty = infer_expr(&e, &Env::new(), &Signatures::new()).unwrap();
        assert_eq!(
            ty,
            SemType::Range(Box::new(SemType::Numeric(NumericType::Int(
                IntWidth::B64.into()
            ))))
        );
    }

    #[test]
    fn infer_range_for_in_ok() {
        let e = Expr {
            kind: ExprKind::ForIn {
                type_: Type::Base {
                    name: Id("Int".into()),
                    params: None,
                },
                name: Id("i".into()),
                collection: Box::new(Expr {
                    kind: ExprKind::Range {
                        start: Box::new(expr_int(0)),
                        end: Box::new(expr_int(3)),
                        closed: true,
                    },
                    span: span(),
                }),
                body: Box::new(Block {
                    statements: vec![],
                    ret: None,
                    span: span(),
                }),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &Env::new(), &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Bool);
    }

    #[test]
    fn infer_range_for_in_mismatch_rejected() {
        // Declared Float, range of Int → rejected.
        let e = Expr {
            kind: ExprKind::ForIn {
                type_: Type::Base {
                    name: Id("Float".into()),
                    params: None,
                },
                name: Id("i".into()),
                collection: Box::new(Expr {
                    kind: ExprKind::Range {
                        start: Box::new(expr_int(0)),
                        end: Box::new(expr_int(3)),
                        closed: false,
                    },
                    span: span(),
                }),
                body: Box::new(Block {
                    statements: vec![],
                    ret: None,
                    span: span(),
                }),
            },
            span: span(),
        };
        let r = infer_expr(&e, &Env::new(), &Signatures::new());
        assert!(r.is_err());
    }

#[test]
    fn infer_if_let_binds_pattern_vars() {
        // `if (Some(n) = mx) { n; }` — n must be in the body.
        let then_block = Block {
            statements: vec![Stmt {
                kind: StmtKind::Expr(Box::new(expr_id("n"))),
                span: span(),
            }],
            ret: None,
            span: span(),
        };
        let e = Expr {
            kind: ExprKind::IfLet {
                pattern: Pattern {
                    kind: PatternKind::Variant {
                        name: Id("Some".into()),
                        param: Some(Id("n".into())),
                    },
                    span: span(),
                },
                source: Box::new(expr_id("mx")),
                then_block: Box::new(then_block),
                else_block: None,
            },
            span: span(),
        };
        // mx : Option(Int)
        let mut env = Env::new();
        env.insert(
            "mx",
            SemType::Sum {
                name: "Option".into(),
                variants: vec![
                    ("None".into(), None),
                    (
                        "Some".into(),
                        Some(SemType::Numeric(NumericType::Int(IntWidth::B64))),
                    ),
                ],
            },
        );
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Bool);
    }

    #[test]
    fn infer_if_let_rejects_unknown_variant() {
        // `if (Some(n) = mx)` where mx is Int → bind_pattern must fail.
        let o_block = Block {
            statements: vec![],
            ret: None,
            span: span(),
        };
        let e = Expr {
            kind: ExprKind::IfLet {
                pattern: Pattern {
                    kind: PatternKind::Variant {
                        name: Id("Some".into()),
                        param: Some(Id("n".into())),
                    },
                    span: span(),
                },
                source: Box::new(expr_id("mx")),
                then_block: Box::new(o_block),
                else_block: None,
            },
            span: span(),
        };
        let mut env = Env::new();
        env.insert(
            "mx",
            SemType::Numeric(NumericType::Int(IntWidth::B64)),
        );
        let r = infer_expr(&e, &env, &Signatures::new());
        assert!(r.is_err());
    }

    #[test]
    fn infer_early_return_payload() {
        // `v?` where v : Option(Int) → Int
        let e = Expr {
            kind: ExprKind::EarlyReturn(Box::new(expr_id("v"))),
            span: span(),
        };
        let mut env = Env::new();
        env.insert(
            "v",
            SemType::Sum {
                name: "Option".into(),
                variants: vec![
                    ("None".into(), None),
                    (
                        "Some".into(),
                        Some(SemType::Numeric(NumericType::Int(IntWidth::B64))),
                    ),
                ],
            },
        );
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B64)));
    }

    #[test]
    fn infer_early_return_rejects_non_option() {
        let e = Expr {
            kind: ExprKind::EarlyReturn(Box::new(expr_id("v"))),
            span: span(),
        };
        let mut env = Env::new();
        env.insert("v", SemType::Bool);
        let r = infer_expr(&e, &env, &Signatures::new());
        assert!(r.is_err());
    }

    #[test]
    fn infer_else_fallback_payload() {
        // `v else { 0 }` where v : Option(Int) → Int
        let e = Expr {
            kind: ExprKind::ElseFallback {
                value: Box::new(expr_id("v")),
                fallback: Block {
                    statements: vec![],
                    ret: Some(Box::new(expr_int(0))),
                    span: span(),
                },
            },
            span: span(),
        };
        let mut env = Env::new();
        env.insert(
            "v",
            SemType::Sum {
                name: "Option".into(),
                variants: vec![
                    ("None".into(), None),
                    (
                        "Some".into(),
                        Some(SemType::Numeric(NumericType::Int(IntWidth::B64))),
                    ),
                ],
            },
        );
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B64)));
    }

    #[test]
    fn infer_else_fallback_type_mismatch() {
        // `v else { true }` where v : Option(Int) → error (Bool ≠ Int)
        let e = Expr {
            kind: ExprKind::ElseFallback {
                value: Box::new(expr_id("v")),
                fallback: Block {
                    statements: vec![],
                    ret: Some(Box::new(Expr {
                        kind: ExprKind::Literal(Literal::Bool(true)),
                        span: span(),
                    })),
                    span: span(),
                },
            },
            span: span(),
        };
        let mut env = Env::new();
        env.insert(
            "v",
            SemType::Sum {
                name: "Option".into(),
                variants: vec![
                    ("None".into(), None),
                    (
                        "Some".into(),
                        Some(SemType::Numeric(NumericType::Int(IntWidth::B64))),
                    ),
                ],
            },
        );
        let r = infer_expr(&e, &env, &Signatures::new());
        assert!(r.is_err());
    }

    #[test]
    fn infer_else_fallback_rejects_non_option() {
        let e = Expr {
            kind: ExprKind::ElseFallback {
                value: Box::new(expr_id("v")),
                fallback: Block {
                    statements: vec![],
                    ret: Some(Box::new(expr_int(0))),
                    span: span(),
                },
            },
            span: span(),
        };
        let mut env = Env::new();
        env.insert("v", SemType::Bool);
        let r = infer_expr(&e, &env, &Signatures::new());
        assert!(r.is_err());
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
        let td = Type::Base {
            name: Id("Int".into()),
            params: None,
        };
        let ty = resolve_type(&td).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B64.into())));
    }

    #[test]
    fn resolve_type_i32() {
        let td = Type::Base {
            name: Id("i32".into()),
            params: None,
        };
        let ty = resolve_type(&td).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B32.into())));
    }

    #[test]
    fn resolve_type_bool() {
        let td = Type::Base {
            name: Id("Bool".into()),
            params: None,
        };
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

    fn parse_unit(src: &str) -> resid_parser::TranslationUnit {
        let (unit, errs) = resid_parser::Parser::parse("beh.resid", src);
        assert!(errs.is_empty(), "parse errors: {errs:?}");
        unit
    }

    #[test]
    fn behavior_ord_sort_accepts_and_rejects() {
        let ok = parse_unit(
            r#"
Int cmp(Int a, Int b) { return a - b; }
Ord(Int) = cmp;
Int main() {
    List(Int) xs = [2, 1];
    List(Int) s = sort(xs, using = Ord(Int));
    return 0;
}
"#,
        );
        assert!(check_program(&ok).is_empty());

        // Wrong comparator signature.
        let bad_sig = parse_unit(
            r#"
Int f(Int a) { return a; }
Ord(Int) = f;
Int main() { return 0; }
"#,
        );
        let errs = check_program(&bad_sig);
        assert!(
            errs.iter().any(|e| e.message.contains("must have signature")),
            "{errs:?}"
        );

        // Undefined implementation function.
        let missing = parse_unit(
            r#"
Ord(Int) = nope;
Int main() { return 0; }
"#,
        );
        let errs = check_program(&missing);
        assert!(
            errs.iter().any(|e| e.message.contains("undefined function")),
            "{errs:?}"
        );

        // Element type mismatch between instance and list.
        let mismatch = parse_unit(
            r#"
Int cmp(Int a, Int b) { return a - b; }
Ord(Int) = cmp;
Int main() {
    List(Str) xs = ["b"];
    List(Str) s = sort(xs, using = Ord(Int));
    return 0;
}
"#,
        );
        let errs = check_program(&mismatch);
        assert!(
            errs.iter().any(|e| e.message.contains("orders") && e.message.contains("holds")),
            "{errs:?}"
        );
    }

    #[test]
    fn sort_without_using_is_rejected() {
        let src = parse_unit(
            r#"
Int main() {
    List(Int) xs = [2, 1];
    List(Int) s = sort(xs);
    return 0;
}
"#,
        );
        let errs = check_program(&src);
        assert!(
            errs.iter().any(|e| e.message.contains("requires a behavior")),
            "{errs:?}"
        );
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
        assert!(
            !errs.is_empty(),
            "expected type error for undefined variable"
        );
    }

    #[test]
    fn check_program_shadowing_same_block() {
        let src = r#"
Int main() {
    Int x = 1;
    Int x = 2;
    return x;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected shadowing error for duplicate binding in same block"
        );
        assert!(
            errs.iter().any(|e| e.message.contains("shadowing is forbidden")),
            "expected shadowing message, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_shadowing_nested_block() {
        // Rebinding an outer name inside a nested block is still shadowing.
        let src = r#"
Int main() {
    Int x = 1;
    Bool c = true;
    if (c) {
        Int x = 2;
    }
    return x;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected shadowing error for nested block rebind"
        );
        assert!(
            errs.iter().any(|e| e.message.contains("shadowing is forbidden")),
            "expected shadowing message, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_shadowing_for_loop_var() {
        let src = r#"
Int main() {
    Int x = 0;
    for (Int x in [1, 2, 3]) {
        return x;
    }
    return x;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected shadowing error for for-in loop variable"
        );
        assert!(
            errs.iter().any(|e| e.message.contains("shadowing is forbidden")),
            "expected shadowing message, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_duplicate_param_names() {
        let src = r#"
Int add(Int a, Int a) {
    return a;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected shadowing error for duplicate parameter names"
        );
        assert!(
            errs.iter().any(|e| e.message.contains("shadowing is forbidden")),
            "expected shadowing message, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_shadowing_param_in_body() {
        // Rebinding a parameter inside the function body is shadowing.
        let src = r#"
Int add(Int a, Int b) {
    Int a = 10;
    return a + b;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected shadowing error for rebinding a parameter"
        );
        assert!(
            errs.iter().any(|e| e.message.contains("shadowing is forbidden")),
            "expected shadowing message, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_no_shadowing_sibling_blocks() {
        // Bindings in sibling if branches do not shadow each other.
        let src = r#"
Int main() {
    Bool c = true;
    Int r = 0;
    if (c) {
        Int x = 1;
        return x;
    }
    return r;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            errs.is_empty(),
            "sibling block bindings should not shadow, got: {:?}",
            errs
        );
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
        assert!(
            !errs.is_empty(),
            "expected type error for signed/unsigned mix"
        );
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

    #[test]
    fn check_while_cond_must_be_bool() {
        let src = r#"
Int main() {
    while (5) { break; }
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected while condition to require Bool"
        );
    }

    #[test]
    fn check_bytes_and_location() {
        let src = r#"
Int main() {
    Bytes b = b"bytes";
    SourceLoc loc = #location;
    Str f = loc.file;
    Int l = loc.line;
    Int c = loc.col;
    return l;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors, got: {:?}", errs);
    }

    #[test]
    fn check_location_unknown_field_rejected() {
        let src = r#"
Int main() {
    SourceLoc loc = #location;
    return loc.nope;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(!errs.is_empty(), "expected missing field to error");
    }

    #[test]
    fn check_while_valid() {
        let src = r#"
Int main() {
    while (true) { break; }
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors, got: {:?}", errs);
    }

    #[test]
    fn check_conversion_helper_i32() {
        let src = r#"
Int main() {
    Int(32) a = i32(42);
    return a;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors for i32(42), got: {:?}", errs);
    }

    #[test]
    fn check_dec_literal_bind() {
        let src = r#"
Int main() {
    Dec(4) a = 1.5m;
    Dec(34) b = 5m;
    Dec c = 123.456m;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors, got: {:?}", errs);
    }

    #[test]
    fn check_dec_arithmetic_max_digits() {
        let src = r#"
Int main() {
    Dec(4) a = 1.5m;
    Dec(2) b = 0.5m;
    Dec(4) s = a + b;
    Dec(4) p = a * a;
    Bool lt = a < b;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors, got: {:?}", errs);
    }

    #[test]
    fn check_dec_mix_with_int_is_error() {
        let src = r#"
Int main() {
    Dec x = 1.5m + 2;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(!errs.is_empty(), "expected Dec/Int mix to error");
    }

    #[test]
    fn check_dec_mix_with_float_is_error() {
        let src = r#"
Int main() {
    Dec x = 1.5m + 2.5;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(!errs.is_empty(), "expected Dec/Float mix to error");
    }

    #[test]
    fn check_dec_bitwise_is_error() {
        let src = r#"
Int main() {
    Dec x = 1.5m & 1.5m;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(!errs.is_empty(), "expected Dec bitwise to error");
    }

    #[test]
    fn check_dec_tilde_is_error() {
        let src = r#"
Int main() {
    Dec x = ~1.5m;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(!errs.is_empty(), "expected `~` on Dec to error");
    }

    #[test]
    fn check_dec_conversion_helpers() {
        let src = r#"
Int main() {
    Dec(4) a = d4(1.5m);
    Dec(8) b = d8(42);
    Dec x = d12("3.14159");
    Int(32) n = i32(1.5m);
    Dec(12) y = d12(a);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors, got: {:?}", errs);
    }

    #[test]
    fn check_dec_conversion_from_float_rejected() {
        let src = r#"
Int main() {
    Dec x = d4(3.14);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(!errs.is_empty(), "expected dN(Float) to error (dN takes Int/Str/Dec only)");
    }

    #[test]
    fn check_conversion_helper_u16() {
        let src = r#"
Int main() {
    UInt(16) b = u16(256);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors for u16(256), got: {:?}", errs);
    }

    #[test]
    fn check_conversion_helper_f32() {
        let src = r#"
Int main() {
    Float(32) c = f32(3.14);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors for f32(3.14), got: {:?}", errs);
    }

    #[test]
    fn check_conversion_helper_f64() {
        let src = r#"
Int main() {
    Float(64) d = f64(2.71);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors for f64(2.71), got: {:?}", errs);
    }

    #[test]
    fn check_conversion_helper_f128() {
        let src = r#"
Int main() {
    Float(128) x = f128(3.14);
    Float(128) y = x + f128(1.0);
    println(Float128ToString(y));
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors for f128/Float(128), got: {:?}", errs);
    }

    #[test]
    fn check_float128_widens_f64() {
        let src = r#"
Int main() {
    Float(128) x = f128(1.0);
    Float(64) y = f64(1.0);
    Float(128) z = x + y;
    println(Float128ToString(z));
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected Float(128) + Float(64) to widen to Float(128) per spec §6.2, got: {:?}", errs);
    }

    #[test]
    fn check_conversion_helper_isize() {
        let src = r#"
Int main() {
    Int(64) e = 99;
    Int x = isize(e);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors for isize(99), got: {:?}", errs);
    }

    #[test]
    fn check_conversion_helper_usize() {
        let src = r#"
Int main() {
    UInt(64) f = 123;
    UInt x = usize(f);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors for usize(123), got: {:?}", errs);
    }

    #[test]
    fn check_provider_scalar_verbs_valid() {
        let src = r#"
Int main() {
    Bool ex = filesystem.exists("a.txt");
    Bool has = environment.has("PATH");
    Str home = environment.get("HOME");
    Str branch = git.branch();
    return 0;
}
"#;
        let (unit, errors) = resid_parser::Parser::parse("check.resid", src);
        assert!(errors.is_empty(), "parse errors: {errors:?}");
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors, got: {:?}", errs);
    }

    #[test]
    fn check_provider_list_dir_returns_list_of_str() {
        let src = r#"
Int main() {
    List(Str) dir = filesystem.list_dir(".");
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors, got: {:?}", errs);
    }

    #[test]
    fn check_provider_unknown_provider_rejected() {
        let src = r#"
Int main() {
    Str x = nebulon.get("PATH");
    return 0;
}
"#;
        let (unit, errors) = resid_parser::Parser::parse("check.resid", src);
        assert!(errors.is_empty(), "parse errors: {errors:?}");
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected unknown provider `nebulon` to be rejected"
        );
    }

    #[test]
    fn check_provider_unknown_verb_rejected() {
        let src = r#"
Int main() {
    Str x = filesystem.teleport();
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected unknown verb `filesystem.teleport` to be rejected"
        );
    }

    #[test]
    fn check_provider_arg_count_rejected() {
        let src = r#"
Int main() {
    Bool ex = filesystem.exists();
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected `filesystem.exists()` (no args) to be rejected"
        );
    }

    #[test]
    fn check_provider_arg_type_rejected() {
        let src = r#"
Int main() {
    Bool ex = filesystem.exists(42);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected `filesystem.exists(42)` (Int arg) to be rejected"
        );
    }

    #[test]
    fn check_method_call_on_value_rejected() {
        // §38 bans pure-value method chaining; only handles carry methods.
        let src = r#"
Int main() {
    Int x = 5;
    Int y = x.add(1);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected method call on plain value `x.add(1)` to be rejected"
        );
    }

    #[test]
    fn check_list_concat_same_elem_type_ok() {
        let src = r#"
Int main() {
    List(Str) a = ["x", "y"];
    List(Str) b = ["z"];
    List(Str) c = a.concat(b);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected concat to typecheck, got: {errs:?}");
    }

    #[test]
    fn check_list_concat_mismatched_elem_rejected() {
        let src = r#"
Int main() {
    List(Str) a = ["x"];
    List(Int) b = [1];
    List(Str) c = a.concat(b);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected mismatched `.concat` element type to be rejected"
        );
    }

    #[test]
    fn check_empty_list_with_declared_type_ok() {
        let src = r#"
Int main() {
    List(Str) a = [];
    List(Int) b = [];
    Int n = a.len();
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            errs.is_empty(),
            "expected typed empty list to typecheck, got: {errs:?}"
        );
    }

    #[test]
    fn check_empty_list_struct_field_ok() {
        let src = r#"
type T = { names: List(Str) };
Int main() {
    T t = T { names: [] };
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            errs.is_empty(),
            "expected typed empty struct-field list to typecheck, got: {errs:?}"
        );
    }

    #[test]
    fn check_provider_tail_call_in_rt_allowed() {
        // rt wins over provider substitution: an rt provider call stays residual.
        let src = r#"
Int main() {
    Str home = rt environment.get("HOME");
    return 0;
}
"#;
        let (unit, errors) = resid_parser::Parser::parse("check.resid", src);
        assert!(errors.is_empty(), "parse errors: {errors:?}");
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected rt provider call to typecheck, got: {:?}", errs);
    }

    #[test]
    fn infer_slice_is_slice_of_list_elem() {
        let e = Expr {
            kind: ExprKind::Slice {
                target: Box::new(Expr {
                    kind: ExprKind::ListLit(vec![expr_int(1), expr_int(2)]),
                    span: span(),
                }),
                range: Box::new(RangeExpr {
                    start: Some(expr_int(0)),
                    end: Some(expr_int(3)),
                    closed: false,
                }),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &Env::new(), &Signatures::new()).unwrap();
        assert_eq!(
            ty,
            SemType::Slice(Box::new(SemType::Numeric(
                NumericType::Int(IntWidth::B64.into())
            )))
        );
    }

    #[test]
    fn infer_slice_rejects_non_list() {
        let e = Expr {
            kind: ExprKind::Slice {
                target: Box::new(expr_int(42)),
                range: Box::new(RangeExpr {
                    start: Some(expr_int(0)),
                    end: Some(expr_int(3)),
                    closed: false,
                }),
            },
            span: span(),
        };
        let result = infer_expr(&e, &Env::new(), &Signatures::new());
        assert!(result.is_err(), "expected error slicing non-list");
    }

    #[test]
    fn check_fstring_interpolation_valid() {
        let src = r#"
Int main() {
    Str name = "resid";
    Int n = 7;
    println(f"hello {name} n={n}");
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            errs.is_empty(),
            "expected no type errors for f-string interpolation, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_fstring_undefined_var_rejected() {
        let src = r#"
Int main() {
    println(f"hello {nope}");
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(!errs.is_empty(), "expected undefined var in f-string to error");
    }

    // ─── Float arithmetic inference ───────────────────────────────

    #[test]
    fn infer_float_literal() {
        let e = Expr {
            kind: ExprKind::Literal(Literal::Float(FloatLit {
                value: "3.14".into(),
            })),
            span: span(),
        };
        let ty = infer_expr(&e, &Env::new(), &Signatures::new()).unwrap();
        assert_eq!(
            ty,
            SemType::Numeric(NumericType::Float(FloatWidth::from_bits(64).unwrap()))
        );
    }

    #[test]
    fn infer_float_add() {
        let mut env = Env::new();
        env.insert("a", SemType::Numeric(NumericType::Float(FloatWidth::F64)));
        env.insert("b", SemType::Numeric(NumericType::Float(FloatWidth::F64)));
        let e = Expr {
            kind: ExprKind::BinaryOp {
                op: OpKind::Plus,
                lhs: Box::new(expr_id("a")),
                rhs: Box::new(expr_id("b")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Float(FloatWidth::F64)));
    }

    #[test]
    fn infer_float_sub() {
        let mut env = Env::new();
        env.insert("a", SemType::Numeric(NumericType::Float(FloatWidth::F64)));
        env.insert("b", SemType::Numeric(NumericType::Float(FloatWidth::F64)));
        let e = Expr {
            kind: ExprKind::BinaryOp {
                op: OpKind::Minus,
                lhs: Box::new(expr_id("a")),
                rhs: Box::new(expr_id("b")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Float(FloatWidth::F64)));
    }

    #[test]
    fn infer_float_mul() {
        let mut env = Env::new();
        env.insert("a", SemType::Numeric(NumericType::Float(FloatWidth::F64)));
        env.insert("b", SemType::Numeric(NumericType::Float(FloatWidth::F64)));
        let e = Expr {
            kind: ExprKind::BinaryOp {
                op: OpKind::Star,
                lhs: Box::new(expr_id("a")),
                rhs: Box::new(expr_id("b")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Float(FloatWidth::F64)));
    }

    #[test]
    fn infer_float_div() {
        let mut env = Env::new();
        env.insert("a", SemType::Numeric(NumericType::Float(FloatWidth::F64)));
        env.insert("b", SemType::Numeric(NumericType::Float(FloatWidth::F64)));
        let e = Expr {
            kind: ExprKind::BinaryOp {
                op: OpKind::Slash,
                lhs: Box::new(expr_id("a")),
                rhs: Box::new(expr_id("b")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Float(FloatWidth::F64)));
    }

    #[test]
    fn infer_float_rem() {
        let mut env = Env::new();
        env.insert("a", SemType::Numeric(NumericType::Float(FloatWidth::F64)));
        env.insert("b", SemType::Numeric(NumericType::Float(FloatWidth::F64)));
        let e = Expr {
            kind: ExprKind::BinaryOp {
                op: OpKind::Percent,
                lhs: Box::new(expr_id("a")),
                rhs: Box::new(expr_id("b")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Float(FloatWidth::F64)));
    }

    #[test]
    fn infer_float_comparison_produces_bool() {
        let mut env = Env::new();
        env.insert("a", SemType::Numeric(NumericType::Float(FloatWidth::F64)));
        env.insert("b", SemType::Numeric(NumericType::Float(FloatWidth::F64)));
        let e = Expr {
            kind: ExprKind::BinaryOp {
                op: OpKind::Greater,
                lhs: Box::new(expr_id("a")),
                rhs: Box::new(expr_id("b")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Bool);
    }

    #[test]
    fn infer_float_unary_neg() {
        let mut env = Env::new();
        env.insert("a", SemType::Numeric(NumericType::Float(FloatWidth::F64)));
        let e = Expr {
            kind: ExprKind::UnaryOp {
                op: OpKind::Minus,
                operand: Box::new(expr_id("a")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Float(FloatWidth::F64)));
    }

    #[test]
    fn infer_float_f64_cast() {
        let mut env = Env::new();
        env.insert("a", SemType::Numeric(NumericType::Float(FloatWidth::F64)));
        let e = Expr {
            kind: ExprKind::Cast {
                type_: Type::Base {
                    name: Id("Float(32)".into()),
                    params: None,
                },
                operand: Box::new(expr_id("a")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Float(FloatWidth::F32)));
    }

    #[test]
    fn check_program_float_arithmetic() {
        let src = r#"
Float main() {
    Float a = 1.5;
    Float b = 2.5;
    return a + b;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors for float arithmetic, got: {:?}", errs);
    }

    #[test]
    fn check_program_float_comparison() {
        let src = r#"
Bool main() {
    Float a = 1.5;
    Float b = 2.5;
    return a < b;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors for float comparison, got: {:?}", errs);
    }

    #[test]
    fn check_program_mixed_float_int_ops() {
        // Float + Int converts Int to Float (spec §6.2)
        let src = r#"
Float main() {
    Float a = 1.5;
    Int b = 2;
    return a + b;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for float + int mix, got: {:?}", errs);
    }

    // ─── Integer overflow / edge cases ────────────────────────────

    #[test]
    fn infer_int_widening_add() {
        // Int64 + Int64 → Int128
        let mut env = Env::new();
        let int64 = SemType::Numeric(NumericType::Int(IntWidth::B64.into()));
        env.insert("a", int64.clone());
        env.insert("b", int64);
        let e = Expr {
            kind: ExprKind::BinaryOp {
                op: OpKind::Plus,
                lhs: Box::new(expr_id("a")),
                rhs: Box::new(expr_id("b")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert!(matches!(ty, SemType::Numeric(NumericType::Int(w)) if w.bits() >= 64));
    }

    #[test]
    fn infer_int_widening_mul() {
        // Int64 * Int64 → Int128
        let mut env = Env::new();
        let int64 = SemType::Numeric(NumericType::Int(IntWidth::B64.into()));
        env.insert("a", int64.clone());
        env.insert("b", int64);
        let e = Expr {
            kind: ExprKind::BinaryOp {
                op: OpKind::Star,
                lhs: Box::new(expr_id("a")),
                rhs: Box::new(expr_id("b")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert!(matches!(ty, SemType::Numeric(NumericType::Int(w)) if w.bits() >= 64));
    }

    #[test]
    fn infer_int_sub_no_widening() {
        // Int64 - Int64 does not widen (result fits in same width)
        let mut env = Env::new();
        let int64 = SemType::Numeric(NumericType::Int(IntWidth::B64.into()));
        env.insert("a", int64.clone());
        env.insert("b", int64);
        let e = Expr {
            kind: ExprKind::BinaryOp {
                op: OpKind::Minus,
                lhs: Box::new(expr_id("a")),
                rhs: Box::new(expr_id("b")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert!(matches!(ty, SemType::Numeric(NumericType::Int(w)) if w.bits() >= 64));
    }

    #[test]
    fn infer_uint_add_same_sign_ok() {
        // UInt64 + UInt64 → UInt128 (same sign, widening)
        let mut env = Env::new();
        let uint64 = SemType::Numeric(NumericType::UInt(IntWidth::B64.into()));
        env.insert("a", uint64.clone());
        env.insert("b", uint64);
        let e = Expr {
            kind: ExprKind::BinaryOp {
                op: OpKind::Plus,
                lhs: Box::new(expr_id("a")),
                rhs: Box::new(expr_id("b")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert!(matches!(ty, SemType::Numeric(NumericType::UInt(_))));
    }

    #[test]
    fn infer_int_mix_with_uint_error() {
        // Int64 + UInt64 → error
        let mut env = Env::new();
        let int64 = SemType::Numeric(NumericType::Int(IntWidth::B64.into()));
        let uint64 = SemType::Numeric(NumericType::UInt(IntWidth::B64.into()));
        env.insert("a", int64);
        env.insert("b", uint64);
        let e = Expr {
            kind: ExprKind::BinaryOp {
                op: OpKind::Plus,
                lhs: Box::new(expr_id("a")),
                rhs: Box::new(expr_id("b")),
            },
            span: span(),
        };
        let result = infer_expr(&e, &env, &Signatures::new());
        assert!(result.is_err());
    }

    // ─── String operations ───────────────────────────────────────

    #[test]
    fn check_program_string_concat() {
        let src = r#"
Str main() {
    Str a = "hello";
    Str b = " world";
    return a + b;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no type errors for string concat, got: {:?}", errs);
    }

    #[test]
    fn check_program_string_int_concat_rejected() {
        let src = r#"
Int main() {
    Str s = "hello";
    Int n = 42;
    return s + n;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected error for Str + Int, got: {:?}",
            errs
        );
    }

    // ─── Unary operators ─────────────────────────────────────────

    #[test]
    fn check_program_str_eq_valid() {
        let src = r#"
Int main() {
    Str a = "if";
    Bool same = a == "if";
    Bool diff = a != "while";
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            errs.is_empty(),
            "expected Str == Str to type-check, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_str_eq_int_rejected() {
        let src = r#"
Int main() {
    Bool b = "hello" == 42;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected Str == Int to be rejected, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_str_lt_rejected() {
        let src = r#"
Int main() {
    Bool b = "hello" < "world";
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected Str < Str to be rejected, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_string_introspection() {
        let src = r#"
Int main() {
    Str s = "hello";
    Int n = str_len(s);
    Int c = str_char_at(s, 0);
    Str one = str_from_code(c);
    Str sub = str_slice(s, 1, 3);
    return n;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            errs.is_empty(),
            "expected no type errors for string introspection, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_wide_128_tostring() {
        let src = r#"
Int main() {
    Int(128) a = 5;
    Str sa = Int128ToString(a);
    UInt(128) u = 18446744073709551617;
    Str su = UInt128ToString(u);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            errs.is_empty(),
            "expected wide Int128ToString/UInt128ToString to type-check, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_wide_128_tostring_wrong_type_rejected() {
        // Int128ToString takes a numeric Int; passing Str is a type error.
        // (Int(64) widens losslessly to Int(128), so that is accepted.)
        let src = r#"
Int main() {
    Str s = "hi";
    Str sa = Int128ToString(s);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected Int128ToString(Str) to be rejected, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_wide_256_512_tostring() {
        let src = r#"
Int main() {
    Int(256) a = 5;
    Str sa = Int256ToString(a);
    UInt(256) u = 18446744073709551617;
    Str su = UInt256ToString(u);
    Int(512) b = 7;
    Str sb = Int512ToString(b);
    UInt(512) v = 9;
    Str sv = UInt512ToString(v);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            errs.is_empty(),
            "expected wide 256/512-bit ToString built-ins to type-check, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_wide_256_tostring_wrong_type_rejected() {
        let src = r#"
Int main() {
    Str s = "hi";
    Str sa = Int256ToString(s);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected Int256ToString(Str) to be rejected, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_wide_256_literal_fits() {
        let src = r#"
Int main() {
    UInt(256) big = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            errs.is_empty(),
            "expected 2^256-1 literal to fit UInt(256), got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_literal_overflow_rejected() {
        // Spec §6: overflow of the result type is a compile-time error.
        let src = r#"
Int main() {
    Int(8) x = 300;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected Int(8) x = 300 to be rejected, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_wide_256_literal_into_64_rejected() {
        let src = r#"
Int main() {
    Int(64) x = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected 2^256-1 literal into Int(64) to be rejected, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_char_literal_is_int() {
        let src = r#"
Int main() {
    Int a = 'a';
    return a;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            errs.is_empty(),
            "expected char literal to type as Int, got: {:?}",
            errs
        );
    }

    #[test]
    fn bindings_in_if_block_visible_to_return() {
        let src = r#"
Int f(Int i) {
    if (i > 0) {
        Int k = i + 1;
        return k;
    }
    return i;
}
Int main() {
    Int x = f(5);
    return x;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("bind.resid", src);
        let errs = check_program(&unit);
        assert!(
            errs.is_empty(),
            "expected clean check, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_str_wrong_args_rejected() {
        let src = r#"
Int main() {
    Int n = str_len(42);
    return n;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected error for str_len(42), got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_stdlib_string_verbs() {
        let src = r#"
Int main() {
    Str s = str_trim("  hi  ");
    Bool c = str_contains("hello", "ell");
    Bool p = str_starts_with("hello", "he");
    Bool q = str_ends_with("hello", "lo");
    Str l = str_to_lower("ABC");
    Str u = str_to_upper("abc");
    Str r = str_repeat("ab", 3);
    Str w = str_replace("aaa", "a", "ba");
    List(Str) parts = str_split("a,b,c", ",");
    Str j = str_join(parts, "-");
    if (c && p && q) {
        println(s);
        println(l);
        println(u);
        println(r);
        println(w);
        println(j);
    }
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            errs.is_empty(),
            "stdlib string verbs should type-check, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_stdlib_parse_and_math() {
        let src = r#"
Int main() {
    if (str_is_int("-17")) {
        Int n = str_parse_int("-17");
        println(IntToString(n));
    }
    Int a = abs_i64(-8);
    Int lo = min_i64(a, 3);
    Int hi = max_i64(a, 3);
    Int c = clamp_i64(15, 0, 10);
    Int t = lo + hi;
    Int u = t + c;
    println(IntToString(u));
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "stdlib parse/math should type-check, got: {:?}", errs);
    }

    #[test]
    fn check_program_stdlib_float_parse_and_misc() {
        let src = r#"
Int main() {
    if (str_is_float("3.5")) {
        Float f = str_parse_float("-1.25");
        println(f"f={f}");
    }
    Int c = str_count("banana", "an");
    Str r = str_reverse("héllo");
    println(IntToString(c));
    println(r);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "stdlib float/misc should type-check, got: {:?}", errs);
    }

    #[test]
    fn check_program_stdlib_list_verbs() {
        let src = r#"
Int main() {
    List(Int) xs = [3, 1, 2];
    List(Int) sorted = list_sort_ints(xs);
    List(Int) rev = list_reverse_ints(sorted);
    Int s = list_sum(sorted);
    Bool has2 = list_contains_int(xs, 2);
    List(Str) ss = list_sort_strs(["pear", "apple"]);
    List(Str) rs = list_reverse_strs(ss);
    Bool hasFig = list_contains_str(rs, "fig");
    if (has2 && hasFig) {
        println(IntToString(s));
        println(IntToString(list_sum(rev)));
    }
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "list verbs should type-check, got: {:?}", errs);
    }

    #[test]
    fn check_program_stdlib_float_list_verbs() {
        let src = r#"
Int main() {
    List(Float) fs = [3.5, -1.0, 2.25];
    List(Float) sorted = list_sort_floats(fs);
    Float s = list_sumf(sorted);
    Bool has = list_contains_float(fs, 2.25);
    List(Float) rev = list_reverse_floats(sorted);
    if (has) {
        println(f"sum={s}");
    }
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "float list verbs should type-check, got: {:?}", errs);
    }

    #[test]
    fn check_program_list_verb_wrong_elem_rejected() {
        let src = r#"
Int main() {
    List(Str) ss = ["a"];
    List(Str) r = list_reverse_ints(ss);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(!errs.is_empty(), "expected elem-type error, got: {:?}", errs);
    }

    #[test]
    fn check_program_str_join_wrong_elem_type_rejected() {
        let src = r#"
Int main() {
    List(Int) xs = [1, 2];
    Str j = str_join(xs, "-");
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected error for joining a List(Int), got: {:?}",
            errs
        );
    }

    #[test]
    fn infer_unary_not_bool() {
        let mut env = Env::new();
        env.insert("p", SemType::Bool);
        let e = Expr {
            kind: ExprKind::UnaryOp {
                op: OpKind::Not,
                operand: Box::new(expr_id("p")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Bool);
    }

    #[test]
    fn infer_unary_not_int_rejected() {
        let env = Env::new();
        let e = Expr {
            kind: ExprKind::UnaryOp {
                op: OpKind::Not,
                operand: Box::new(expr_id("x")),
            },
            span: span(),
        };
        let result = infer_expr(&e, &env, &Signatures::new());
        assert!(result.is_err());
    }

    #[test]
    fn infer_unary_neg_int() {
        let mut env = Env::new();
        env.insert("a", SemType::Numeric(NumericType::Int(IntWidth::B64.into())));
        let e = Expr {
            kind: ExprKind::UnaryOp {
                op: OpKind::Minus,
                operand: Box::new(expr_id("a")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert!(matches!(ty, SemType::Numeric(NumericType::Int(_))));
    }

    #[test]
    fn infer_unary_neg_float() {
        let mut env = Env::new();
        env.insert("a", SemType::Numeric(NumericType::Float(FloatWidth::F64)));
        let e = Expr {
            kind: ExprKind::UnaryOp {
                op: OpKind::Minus,
                operand: Box::new(expr_id("a")),
            },
            span: span(),
        };
        let ty = infer_expr(&e, &env, &Signatures::new()).unwrap();
        assert!(matches!(ty, SemType::Numeric(NumericType::Float(_))));
    }

    // ─── Block return type inference ─────────────────────────────

    #[test]
    fn block_ret_empty_returns_bool() {
        let block = Block {
            statements: vec![],
            ret: None,
            span: span(),
        };
        let env = Env::new();
        let sigs = Signatures::new();
        let ty = block_ret(&block, &env, &sigs, &Types::new()).unwrap();
        assert_eq!(ty, SemType::Bool);
    }

    #[test]
    fn block_ret_expr_returns_expr_type() {
        let e = expr_int(42);
        let block = Block {
            statements: vec![Stmt {
                kind: StmtKind::Expr(Box::new(e)),
                span: span(),
            }],
            ret: None,
            span: span(),
        };
        let env = Env::new();
        let sigs = Signatures::new();
        let ty = block_ret(&block, &env, &sigs, &Types::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B64.into())));
    }

    #[test]
    fn block_ret_explicit_returns_declared_type() {
        let e = expr_int(42);
        let block = Block {
            statements: vec![],
            ret: Some(Box::new(e)),
            span: span(),
        };
        let env = Env::new();
        let sigs = Signatures::new();
        let ty = block_ret(&block, &env, &sigs, &Types::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::Int(IntWidth::B64.into())));
    }

    // ─── Numeric literal bounds ──────────────────────────────────

    #[test]
    fn literal_compatible_i8_positive() {
        let lit = expr_int(127);
        let target = SemType::Numeric(NumericType::Int(IntWidth::B8.into()));
        assert!(literal_compatible(&lit, &target));
    }

    #[test]
    fn literal_compatible_i8_negative_max() {
        // -128 can hold 127 as positive, but 128 overflows
        let lit = expr_int(128);
        let target = SemType::Numeric(NumericType::Int(IntWidth::B8.into()));
        assert!(!literal_compatible(&lit, &target));
    }

    #[test]
    fn literal_compatible_u8_max() {
        let lit = expr_int(255);
        let target = SemType::Numeric(NumericType::UInt(IntWidth::B8.into()));
        assert!(literal_compatible(&lit, &target));
    }

    #[test]
    fn literal_compatible_u8_overflow() {
        let lit = expr_int(256);
        let target = SemType::Numeric(NumericType::UInt(IntWidth::B8.into()));
        assert!(!literal_compatible(&lit, &target));
    }

    #[test]
    fn literal_compatible_i16() {
        let lit = expr_int(32767);
        let target = SemType::Numeric(NumericType::Int(IntWidth::B16.into()));
        assert!(literal_compatible(&lit, &target));
    }

    #[test]
    fn literal_compatible_i32() {
        let lit = expr_int(2147483647);
        let target = SemType::Numeric(NumericType::Int(IntWidth::B32.into()));
        assert!(literal_compatible(&lit, &target));
    }

    #[test]
    fn literal_compatible_128_bit() {
        // 128-bit ints should accept any literal
        let lit = expr_int(u128::MAX);
        let target = SemType::Numeric(NumericType::Int(IntWidth::B128));
        assert!(literal_compatible(&lit, &target));
    }

    // ─── Conversion helpers type checking ────────────────────────

    #[test]
    fn check_i8_conversion_helper() {
        let src = r#"
Int main() {
    Int(8) x = i8(42);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for i8(42), got: {:?}", errs);
    }

    #[test]
    fn check_i64_conversion_helper() {
        let src = r#"
Int main() {
    Int(64) x = i64(99);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for i64(99), got: {:?}", errs);
    }

    #[test]
    fn check_u32_conversion_helper() {
        let src = r#"
Int main() {
    UInt(32) x = u32(65535);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for u32(65535), got: {:?}", errs);
    }

    #[test]
    fn check_isize_conversion_helper() {
        let src = r#"
Int main() {
    Int(64) x = isize(100);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for isize(100), got: {:?}", errs);
    }

    #[test]
    fn check_usize_conversion_helper() {
        let src = r#"
Int main() {
    UInt(64) x = usize(200);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for usize(200), got: {:?}", errs);
    }

    #[test]
    fn check_program_result_type_ok() {
        let src = r#"
Int main() {
    Result(Int, RegionError) r = Ok(7);
    Int out = match r {
        Ok(n) => n,
        Err(e) => 0,
    };
    return out;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for Result typing, got: {:?}", errs);
    }

    #[test]
    fn check_program_result_type_err() {
        let src = r#"
Int main() {
    Result(Int, RegionError) r = Err(RegionError { message: "boom" });
    Int out = match r {
        Ok(n) => n,
        Err(e) => 0,
    };
    return out;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for Result Err, got: {:?}", errs);
    }

    #[test]
    fn check_program_result_wrong_variant_rejected() {
        let src = r#"
Int main() {
    Result(Int, RegionError) r = Ok("not an int");
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected Result(Int,..) = Ok(Str) to be rejected"
        );
    }

    #[test]
    fn check_program_region_error_message_field() {
        let src = r#"
Int main() {
    RegionError e = RegionError { message: "boom" };
    Str m = e.message;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected RegionError field access to type-check, got: {:?}", errs);
    }

    #[test]
    fn check_program_spawn_types() {
        let src = r#"
Int main() {
    Result(Int, RegionError) r = spawn (filesystem) {
        7;
    };
    Int out = match r {
        Ok(n) => n,
        Err(e) => 0,
    };
    return out;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for spawn typing, got: {:?}", errs);
    }

    #[test]
    fn check_program_spawn_body_error_surfaces() {
        let src = r#"
Int main() {
    Result(Int, RegionError) r = spawn (filesystem) {
        UndefinedThing;
    };
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected undefined var inside spawn body to be rejected"
        );
    }

    // ─── Handle types + `with` blocks (spec §16) ─────────────────

    #[test]
    fn check_program_with_handle_types() {
        let src = r#"
Int main() {
    with (File h = filesystem.open("data.txt")) {
        Int n = 7;
        return n;
    }
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected `with` + File handle to type-check, got: {:?}", errs);
    }

    #[test]
    fn check_program_with_multiple_bindings() {
        let src = r#"
Int main() {
    with (File a = filesystem.open("a.txt"), File b = filesystem.open("b.txt")) {
        Str unused = "x";
        return 0;
    }
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected multi-binding `with` to type-check, got: {:?}", errs);
    }

    #[test]
    fn check_program_with_explicit_close() {
        let src = r#"
Int main() {
    File h = filesystem.open("data.txt");
    Bool ok = filesystem.close(h);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected filesystem.close to type-check, got: {:?}", errs);
    }

    #[test]
    fn check_program_with_type_mismatch_rejected() {
        let src = r#"
Int main() {
    with (File h = 42) {
        return 0;
    }
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            errs.iter().any(|e| e.message.contains("expected File, found Int")),
            "expected with-binding type mismatch, got: {:?}", errs
        );
    }

    #[test]
    fn check_program_with_shadowing_rejected() {
        let src = r#"
Int main() {
    Int h = 1;
    with (File h = filesystem.open("data.txt")) {
        return 0;
    }
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            errs.iter().any(|e| e.message.contains("shadowing is forbidden")),
            "expected with-binding shadowing rejection, got: {:?}", errs
        );
    }

    #[test]
    fn check_program_with_undefined_var_in_body_surfaces() {
        let src = r#"
Int main() {
    with (File h = filesystem.open("data.txt")) {
        return Missing;
    }
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected undefined var inside `with` body to be rejected"
        );
    }

    // ─── Provider type checking ──────────────────────────────────

    #[test]
    fn check_program_filesystem_exists() {
        let src = r#"
Int main() {
    Bool ex = filesystem.exists("test.txt");
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for filesystem.exists, got: {:?}", errs);
    }

    #[test]
    fn check_program_filesystem_list_dir() {
        let src = r#"
Int main() {
    List(Str) files = filesystem.list_dir(".");
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for filesystem.list_dir, got: {:?}", errs);
    }

    #[test]
    fn check_program_filesystem_write_all() {
        let src = r#"
Int main() {
    Bool ok = filesystem.write_all("out.txt", "data");
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for filesystem.write_all, got: {:?}", errs);
    }

    #[test]
    fn check_program_filesystem_write_all_bad_args() {
        let src = r#"
Int main() {
    Bool ok = filesystem.write_all(42, "data");
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected filesystem.write_all(Int, Str) to be rejected"
        );
    }

    #[test]
    fn check_program_environment_get() {
        let src = r#"
Int main() {
    Str home = environment.get("HOME");
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for environment.get, got: {:?}", errs);
    }

    #[test]
    fn check_program_environment_has() {
        let src = r#"
Int main() {
    Bool has = environment.has("PATH");
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for environment.has, got: {:?}", errs);
    }

    #[test]
    fn check_program_git_branch() {
        let src = r#"
Int main() {
    Str branch = git.branch();
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for git.branch, got: {:?}", errs);
    }

    #[test]
    fn check_program_git_rev() {
        let src = r#"
Int main() {
    Str rev = git.rev("HEAD");
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for git.rev, got: {:?}", errs);
    }

    // ─── If/while type inference ─────────────────────────────────

    #[test]
    fn check_program_if_expression_types() {
        let src = r#"
Int main() {
    Int a = 1;
    Int b = 2;
    Bool c = true;
    return if (c) { a } else { b };
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for if expr, got: {:?}", errs);
    }

    #[test]
    fn check_program_while_loop() {
        let src = r#"
Int main() {
    Int i = 0;
    while (i < 10) {
        Int x = i + 1;
    }
    return i;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for while, got: {:?}", errs);
    }

    // ─── Range type inference ────────────────────────────────────

    #[test]
    fn check_program_range_construction() {
        let src = r#"
Int main() {
    Int(64) r = 0..10;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for range, got: {:?}", errs);
    }

    #[test]
    fn check_program_range_inclusive_construction() {
        let src = r#"
Int main() {
    Int(64) r = 0..=5;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for inclusive range, got: {:?}", errs);
    }

    // ─── For-in over ranges ──────────────────────────────────────

    #[test]
    fn check_program_for_in_range() {
        let src = r#"
Int main() {
    for (Int(64) i in 0..10) {
        Int(64) x = i + 1;
    }
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for for-in range, got: {:?}", errs);
    }

    #[test]
    fn check_program_for_in_range_inclusive() {
        let src = r#"
Int main() {
    for (Int(64) i in 0..=5) {
        Int(64) x = i + 1;
    }
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for for-in inclusive range, got: {:?}", errs);
    }

    // ─── Cast type inference ─────────────────────────────────────

    #[test]
    fn check_program_int_to_int_cast() {
        let src = r#"
Int main() {
    Int x = 42;
    Int y = x;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for int cast, got: {:?}", errs);
    }

    // ─── Assertion expressions ───────────────────────────────────

    #[test]
    fn check_program_assert() {
        let src = r#"
Int main() {
    assert(1 == 1, "should be true");
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for assert, got: {:?}", errs);
    }

    #[test]
    fn check_program_assert_non_bool_cond() {
        let src = r#"
Int main() {
    assert(42, "should fail");
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(
            !errs.is_empty(),
            "expected error for assert with non-bool cond, got: {:?}",
            errs
        );
    }

    #[test]
    fn check_program_known() {
        let src = r#"
Int main() {
    known(1 == 1);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for known, got: {:?}", errs);
    }

    // ─── RT expressions ──────────────────────────────────────────

    #[test]
    fn check_program_rt_expression() {
        let src = r#"
Int main() {
    Int x = rt 42;
    return x;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for rt, got: {:?}", errs);
    }

    // ─── @residual type inference ────────────────────────────────

    #[test]
    fn check_program_at_residual() {
        let src = r#"
Int main() {
    @residual Int x = 42;
    return x;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for @residual, got: {:?}", errs);
    }

    #[test]
    fn check_program_at_residual_float() {
        let src = r#"
Int main() {
    @residual Float x = 3.14;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for @residual float, got: {:?}", errs);
    }

    // ─── Destructure / discard ───────────────────────────────────

    #[test]
    fn check_program_discard() {
        let src = r#"
Int main() {
    _ = 42;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for discard, got: {:?}", errs);
    }

    #[test]
    fn check_program_destructure() {
        let src = r#"
type Pair { a: Int, b: Int }

Int main() {
    Pair p = Pair { a: 1, b: 2 };
    Pair { a, b } = p;
    return a + b;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for destructure, got: {:?}", errs);
    }

    // ─── Bool operations ─────────────────────────────────────────

    #[test]
    fn check_program_bool_and() {
        let src = r#"
Bool main() {
    Bool a = true;
    Bool b = false;
    return a && b;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for &&, got: {:?}", errs);
    }

    #[test]
    fn check_program_bool_or() {
        let src = r#"
Bool main() {
    Bool a = true;
    Bool b = false;
    return a || b;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for ||, got: {:?}", errs);
    }

    #[test]
    fn check_program_bool_not() {
        let src = r#"
Bool main() {
    Bool a = true;
    return !a;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for !, got: {:?}", errs);
    }

    #[test]
    fn check_program_bool_comparison() {
        let src = r#"
Bool main() {
    Bool a = true;
    Bool b = false;
    return a == b;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for bool ==, got: {:?}", errs);
    }

    // ─── Struct type checking ────────────────────────────────────

    #[test]
    fn check_program_struct_def_and_use() {
        let src = r#"
type Point { x: Int, y: Int }

Int main() {
    Point p = Point { x: 1, y: 2 };
    return p.x + p.y;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for struct, got: {:?}", errs);
    }

    // ─── Option type checking ────────────────────────────────────

    #[test]
    fn check_program_option_some() {
        let src = r#"
Int main() {
    Option(Int) x = Some(42);
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for Option, got: {:?}", errs);
    }

    #[test]
    fn check_program_option_none() {
        let src = r#"
Int main() {
    Option(Int) x = None;
    return 0;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for None, got: {:?}", errs);
    }

    #[test]
    fn check_program_early_return() {
        let src = r#"
Option(Int) main() {
    Option(Int) x = Some(42);
    return x?;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for early return, got: {:?}", errs);
    }

    #[test]
    fn check_program_else_fallback() {
        let src = r#"
Int main() {
    Option(Int) x = None;
    Int y = x else { 0 };
    return y;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for else fallback, got: {:?}", errs);
    }

    #[test]
    fn check_program_match_on_non_sum_rejected() {
        let src = r#"
Int main() {
    Int y = match 1 { 0 => 10, 1 => 20, _ => 0 };
    return y;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(!errs.is_empty(), "expected error for match on non-sum type");
        assert!(
            errs[0].message.contains("must be a sum type"),
            "expected sum-type error, got: {}",
            errs[0].message
        );
    }

    #[test]
    fn check_program_rejects_duplicate_function_definitions() {
        let src = r#"
Int f(Int x) {
    return x;
}
Int f(Int x) {
    return x + 1;
}
Int main() {
    return f(1);
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("dup.resid", src);
        let errs = check_program(&unit);
        assert!(!errs.is_empty(), "expected error for duplicate function");
        assert!(
            errs[0].message.contains("already defined"),
            "expected duplicate-definition error, got: {}",
            errs[0].message
        );
    }

    #[test]
    fn check_program_match_on_option_ok() {
        let src = r#"
Int main() {
    Option(Int) x = Some(42);
    Int y = match x {
        Some(v) => v,
        None => 0,
    };
    return y;
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("check.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "expected no errors for match on Option, got: {:?}", errs);
    }

    #[test]
    fn sandbox_allows_matching_requires() {
        let src = r#"
sandbox (filesystem) {
    Int read() { return 42; }
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("test.resid", src);
        let errs = check_program(&unit);
        assert!(errs.is_empty(), "sandbox with matching require should pass, got: {:?}", errs);
    }

    #[test]
    fn sandbox_rejects_exceeding_requires() {
        let src = r#"
sandbox (filesystem) {
    @requires(network)
    Int fetch() { return 1; }
}
"#;
        let (unit, _errors) = resid_parser::Parser::parse("test.resid", src);
        let errs = check_program(&unit);
        assert!(!errs.is_empty(), "sandbox should reject requires exceeding ceiling");
        assert!(errs.iter().any(|e| e.message.contains("network")),
            "error should mention the exceeding capability, got: {:?}", errs);
    }


    // ─── Map / Set literal + method inference ──────────────────

    fn expr_str(s: &str) -> Expr {
        Expr {
            kind: ExprKind::Literal(Literal::Str(StrLit {
                value: s.to_string(),
            })),
            span: span(),
        }
    }

    #[test]
    fn infer_map_literal() {
        let m = Expr {
            kind: ExprKind::MapLit(vec![
                (expr_str("a"), expr_int(1)),
                (expr_str("b"), expr_int(2)),
            ]),
            span: span(),
        };
        let ty = infer_expr(&m, &Env::new(), &Signatures::new()).unwrap();
        assert_eq!(
            ty,
            SemType::Map(
                Box::new(SemType::Str),
                Box::new(SemType::Numeric(NumericType::Int(IntWidth::B64.into())))
            )
        );
    }

    #[test]
    fn infer_set_literal() {
        let s = Expr {
            kind: ExprKind::SetLit(vec![expr_int(1), expr_int(2), expr_int(3)]),
            span: span(),
        };
        let ty = infer_expr(&s, &Env::new(), &Signatures::new()).unwrap();
        assert_eq!(
            ty,
            SemType::Set(Box::new(SemType::Numeric(NumericType::Int(
                IntWidth::B64.into()
            ))))
        );
    }

    #[test]
    fn infer_map_index_and_methods() {
        let int_ty = SemType::Numeric(NumericType::Int(IntWidth::B64.into()));
        let map_ty = SemType::Map(Box::new(SemType::Str), Box::new(int_ty.clone()));
        let mut env = Env::new();
        env.insert("m", map_ty.clone());

        // m["k"] → Option(Int)
        let ix = Expr {
            kind: ExprKind::Index {
                target: Box::new(expr_id("m")),
                index: Box::new(expr_str("k")),
            },
            span: span(),
        };
        let ty = infer_expr(&ix, &env, &Signatures::new()).unwrap();
        assert_eq!(
            ty,
            SemType::Sum {
                name: "Option".into(),
                variants: vec![
                    ("None".into(), None),
                    ("Some".into(), Some(int_ty.clone())),
                ],
            }
        );

        // m.get("k") → Option(Int)
        let get = Expr {
            kind: ExprKind::MethodCall {
                target: Box::new(expr_id("m")),
                method: Id("get".into()),
                args: vec![Box::new(expr_str("k"))],
            },
            span: span(),
        };
        let ty = infer_expr(&get, &env, &Signatures::new()).unwrap();
        assert_eq!(
            ty,
            SemType::Sum {
                name: "Option".into(),
                variants: vec![
                    ("None".into(), None),
                    ("Some".into(), Some(int_ty)),
                ],
            }
        );

        // m.len() → ISize
        let len = Expr {
            kind: ExprKind::MethodCall {
                target: Box::new(expr_id("m")),
                method: Id("len".into()),
                args: vec![],
            },
            span: span(),
        };
        let ty = infer_expr(&len, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::ISize));

        // m.get(3) → key type mismatch error
        let bad = Expr {
            kind: ExprKind::MethodCall {
                target: Box::new(expr_id("m")),
                method: Id("get".into()),
                args: vec![Box::new(expr_int(3))],
            },
            span: span(),
        };
        assert!(infer_expr(&bad, &env, &Signatures::new()).is_err());
    }

    #[test]
    fn infer_set_methods() {
        let int_ty = SemType::Numeric(NumericType::Int(IntWidth::B64.into()));
        let set_ty = SemType::Set(Box::new(int_ty.clone()));
        let mut env = Env::new();
        env.insert("s", set_ty);

        let contains = Expr {
            kind: ExprKind::MethodCall {
                target: Box::new(expr_id("s")),
                method: Id("contains".into()),
                args: vec![Box::new(expr_int(1))],
            },
            span: span(),
        };
        let ty = infer_expr(&contains, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Bool);

        let len = Expr {
            kind: ExprKind::MethodCall {
                target: Box::new(expr_id("s")),
                method: Id("len".into()),
                args: vec![],
            },
            span: span(),
        };
        let ty = infer_expr(&len, &env, &Signatures::new()).unwrap();
        assert_eq!(ty, SemType::Numeric(NumericType::ISize));
    }
}
