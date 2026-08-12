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
}

impl core::fmt::Display for SemType {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        match self {
            SemType::Bool => write!(f, "Bool"),
            SemType::Numeric(n) => write!(f, "{n}"),
            SemType::Str => write!(f, "Str"),
            SemType::Bytes => write!(f, "Bytes"),
            SemType::List(e) => write!(f, "List({e})"),
            SemType::Struct { name, .. } => write!(f, "{name}"),
            SemType::Sum { name, .. } => write!(f, "{name}"),
            SemType::Ptr => write!(f, "ptr"),
            SemType::Range(e) => write!(f, "Range({e})"),
            SemType::Slice(e) => write!(f, "Slice({e})"),
            SemType::SourceLoc => write!(f, "SourceLoc"),
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
pub fn residual_payload(ty: &SemType) -> Option<SemType> {
    match ty {
        SemType::Sum { variants, .. } => {
            let has_unit = variants.iter().any(|(_, p)| p.is_none());
            if !has_unit {
                return None;
            }
            variants
                .iter()
                .find_map(|(_, p)| p.clone())
        }
        _ => None,
    }
}

/// The set of user-declared named types (`type T = …`), used to resolve
/// `Type::Base` references and variant constructors.
pub type Types = HashMap<String, SemType>;

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
        ExprKind::IfLet { .. } => "if-let",
        ExprKind::WhileLet { .. } => "while-let",
        ExprKind::Range { .. } => "range",
        ExprKind::EarlyReturn(_) => "value `?`",
        ExprKind::ElseFallback { .. } => "value else",
        ExprKind::StructLit { .. } => "struct literal",
        ExprKind::ListLit(_) => "list literal",
        ExprKind::MapLit(_) => "map literal",
        ExprKind::Index { .. } => "index",
        ExprKind::FieldAccess { .. } => "field access",
        ExprKind::MethodCall { .. } => "method call",
        ExprKind::Slice { .. } => "slice",
        ExprKind::Spawn { .. } => "spawn",
        ExprKind::ProviderCall { .. } => "provider call",
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
                        // Parsed as numeric literal: Int(8) → Type::Literal(Int { value: 8, .. })
                        Type::Literal(Literal::Int { value: w, .. }) => Ok(w.to_string()),
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
        Literal::Int { .. } => SemType::Numeric(NumericType::Int(IntWidth::from_bits(64).unwrap())),
        Literal::Float(_) => {
            SemType::Numeric(NumericType::Float(FloatWidth::from_bits(64).unwrap()))
        }
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
];

/// Return the set of built-in (extern) function signatures.
pub fn builtin_signatures() -> Signatures {
    BUILTIN_SIGS
        .iter()
        .map(|(name, params, ret)| {
            (
                name.to_string(),
                FunctionSig {
                    name: name.to_string(),
                    params: params.to_vec(),
                    ret: ret.clone(),
                },
            )
        })
        .collect()
}

/// Collect all function signatures declared in a translation unit, merged with
/// the built-in extern signatures (a unit definition of the same name wins).
pub fn collect_signatures(unit: &TranslationUnit) -> Signatures {
    let types = collect_types(unit);
    let mut sigs = builtin_signatures();
    for decl in &unit.declarations {
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
    let ret = resolve_type_ctx(&f.ret, types).unwrap_or(SemType::Bool);
    FunctionSig {
        name: f.name.0.clone(),
        params,
        ret,
    }
}

/// Infer the type of an expression without any user-declared named types in
/// scope (primitives, `List`, `Option` spellings only).
pub fn infer_expr(expr: &Expr, env: &Env, sigs: &Signatures) -> Result<SemType, TypeError> {
    infer_expr_ctx(expr, env, sigs, &Types::new())
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
                    SemType::Numeric(_) => Ok(inner),
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

        ExprKind::Match {
            scrutinee,
            arms,
        } => infer_match(scrutinee, arms, env, sigs, types, &expr.span),

        // Composite literals and their accessors.
        ExprKind::ListLit(elems) => infer_list(elems, env, sigs, types, &expr.span),
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
                other => Err(err(
                    &expr.span,
                    format!("cannot index value of type {other}"),
                )),
            }
        }
        ExprKind::MethodCall { target, method, args } => {
            // Built-in list methods surface here as sugar; only `len` and
            // `get` are recognized for now.
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
            for_env.insert(&name.0, elem_ty);
            type_check_block(body, &for_env, sigs, types, &mut errs);
            if let Some(e) = errs.into_iter().next() {
                return Err(e);
            }
            Ok(SemType::Bool)
        }

        ExprKind::ProviderCall { provider, verb, args } => {
            infer_provider_call(provider, verb, args, env, sigs, types, &expr.span)
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
        .ok_or_else(|| err(span, format!("unknown type `{}`", name.0)))?;
    let SemType::Struct { fields: defs, .. } = ty else {
        return Err(err(span, format!("`{}` is not a struct type", name.0)));
    };
    for (fname, fval) in fields {
        let want = defs
            .iter()
            .find(|(n, _)| n == &fname.0)
            .ok_or_else(|| err(span, format!("`{}` has no field `{}`", name.0, fname.0)))?;
        let has = infer_expr_ctx(fval, env, sigs, types)?;
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
            env.insert(&name.0, ty.clone());
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
                    env.insert(&b.0, pt.clone());
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
    ) && (ln.is_float() || rn.is_float())
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
    if let Some(ret) = &block.ret {
        return infer_expr_ctx(ret, env, sigs, types);
    }
    if let Some(stmt) = block.statements.last() {
        if let StmtKind::Expr(e) = &stmt.kind {
            return infer_expr_ctx(e, env, sigs, types);
        }
    }
    Ok(SemType::Bool)
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
    let sig = best_overload(
        &args
            .iter()
            .map(|(_, a)| infer_expr_ctx(a, env, sigs, types).unwrap_or(SemType::Bool))
            .collect::<Vec<_>>(),
        sigs,
        &name,
    )
    .ok_or_else(|| err(span, format!("call to undefined function `{name}`")))?;
    if args.len() != sig.params.len() {
        return Err(err(
            span,
            format!(
                "`{name}` expects {} argument(s), got {}",
                sig.params.len(),
                args.len()
            ),
        ));
    }
    // Check each argument against the parameter type.
    for (i, (_, a)) in args.iter().enumerate() {
        let at = infer_expr_ctx(a, env, sigs, types)?;
        let want = &sig.params[i];
        if !param_matches(&at, want)
            && !literal_compatible(a, want)
            && !numeric_can_widen(&at, want)
        {
            return Err(err(
                &a.span,
                format!(
                    "argument {} of `{name}`: expected {want}, found {at}",
                    i + 1
                ),
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
            'i' => matches!(a, NumericType::Int(_)) && matches!(p, NumericType::Int(_))
                    && p.target_width().unwrap_or(64) >= a.target_width().unwrap_or(64),
            'u' => matches!(a, NumericType::UInt(_)) && matches!(p, NumericType::UInt(_))
                    && p.target_width().unwrap_or(64) >= a.target_width().unwrap_or(64),
            'f' => a.is_float() && p.is_float()
                    && p.target_width().unwrap_or(64) >= a.target_width().unwrap_or(64),
            _ => false,
        }
    } else {
        false
    }
}

/// Select the best overload from a list of signatures whose first parameter
/// matches the argument type. For ToString-style functions with numeric
/// overloads this picks the most specific (narrowest) type that the argument
/// can safely be widened to. For conversion helpers (i8/i16/.../u8/.../f16/...)
/// this picks the narrowest parameter type that the argument can be widened to.
pub fn best_overload(args_ty: &[SemType], sigs: &Signatures, func: &str) -> Option<FunctionSig> {
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

    // For conversion helpers (i8..i512, u8..u512, f16..f512, isize, usize),
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

/// Type-check every function body in a translation unit.
/// Returns a list of errors (empty = all passed).
pub fn check_program(unit: &TranslationUnit) -> Vec<TypeError> {
    let types = collect_types(unit);
    let sigs = collect_signatures(unit);
    let mut errs = Vec::new();
    for decl in &unit.declarations {
        if let Declaration::Function(f) = decl {
            let mut env = Env::new();
            let sig = sigs.get(&f.name.0).unwrap();
            for (param, pt) in f.params.iter().zip(sig.params.iter()) {
                env.insert(&param.name.0, pt.clone());
            }
            type_check_block(&f.body, &env, &sigs, &types, &mut errs);
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
                if let Err(e) = infer_expr_ctx(value, &env, sigs, types) {
                    errs.push(e);
                }
                resolve_type_ctx(t, types).unwrap_or(SemType::Bool)
            } else {
                infer_expr_ctx(value, &env, sigs, types).unwrap_or(SemType::Bool)
            };
            env.insert(&name.0, ty);
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
    use resid_lexer::token::{FloatLit, IntKind, Literal, Op as OpKind, Span};
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
                kind: IntKind::Decimal(0),
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
    fn check_program_string_introspection() {        let src = r#"
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
}
