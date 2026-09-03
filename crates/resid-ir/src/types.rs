//! Shared type definitions (used by parser + codegen too).

use std::fmt;

// ─── Integer / Float Widths ────────────────────────────────────────

#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
pub enum IntWidth {
    B8,
    B16,
    B32,
    B64,
    B128,
    B256,
    B512,
}

impl IntWidth {
    pub fn bits(self) -> u16 {
        match self {
            IntWidth::B8 => 8,
            IntWidth::B16 => 16,
            IntWidth::B32 => 32,
            IntWidth::B64 => 64,
            IntWidth::B128 => 128,
            IntWidth::B256 => 256,
            IntWidth::B512 => 512,
        }
    }
    pub fn from_bits(bits: u16) -> Option<Self> {
        match bits {
            8 => Some(IntWidth::B8),
            16 => Some(IntWidth::B16),
            32 => Some(IntWidth::B32),
            64 => Some(IntWidth::B64),
            128 => Some(IntWidth::B128),
            256 => Some(IntWidth::B256),
            512 => Some(IntWidth::B512),
            _ => None,
        }
    }
}

#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
pub enum FloatWidth {
    F16,
    F32,
    F64,
    F128,
}

impl FloatWidth {
    pub fn bits(self) -> u16 {
        match self {
            FloatWidth::F16 => 16,
            FloatWidth::F32 => 32,
            FloatWidth::F64 => 64,
            FloatWidth::F128 => 128,
        }
    }
    pub fn from_bits(bits: u16) -> Option<Self> {
        match bits {
            16 => Some(FloatWidth::F16),
            32 => Some(FloatWidth::F32),
            64 => Some(FloatWidth::F64),
            128 => Some(FloatWidth::F128),
            _ => None,
        }
    }
}

// ─── Numeric Type ──────────────────────────────────────────────────

#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
pub enum NumericType {
    Int(IntWidth),
    UInt(IntWidth),
    Float(FloatWidth),
    ISize,
    USize,
    /// Exact decimal: N significant digits + i32 exponent (spec §6.6a).
    /// Has no fixed binary width; arithmetic is `Dec(N) op Dec(M) -> Dec(max)`.
    Dec(u16),
}

impl NumericType {
    pub fn is_signed(&self) -> bool {
        matches!(self, NumericType::Int(_) | NumericType::ISize)
    }
    pub fn is_unsigned(&self) -> bool {
        matches!(self, NumericType::UInt(_) | NumericType::USize)
    }
    pub fn is_integer(&self) -> bool {
        self.is_signed() || self.is_unsigned()
    }
    pub fn is_float(&self) -> bool {
        matches!(self, NumericType::Float(_))
    }
    pub fn is_dec(&self) -> bool {
        matches!(self, NumericType::Dec(_))
    }
    pub fn target_width(&self) -> Option<u16> {
        match self {
            NumericType::Int(w) | NumericType::UInt(w) => Some(w.bits()),
            NumericType::Float(w) => Some(w.bits()),
            NumericType::ISize | NumericType::USize => Some(64),
            NumericType::Dec(_) => None,
        }
    }
    #[allow(clippy::manual_strip)]
    pub fn from_name(name: &str) -> Option<NumericType> {
        const D: u16 = 64;
        const DEC: u16 = 34;
        match name {
            "Int" => Some(NumericType::Int(IntWidth::from_bits(D).unwrap())),
            "UInt" => Some(NumericType::UInt(IntWidth::from_bits(D).unwrap())),
            "Float" => Some(NumericType::Float(FloatWidth::from_bits(D).unwrap())),
            "Dec" => Some(NumericType::Dec(DEC)),
            "ISize" => Some(NumericType::ISize),
            "USize" => Some(NumericType::USize),
            _ => {
                let (k, s) = if name.starts_with('u') {
                    ('u', &name[1..])
                } else if name.starts_with('i') {
                    ('i', &name[1..])
                } else if name.starts_with('f') {
                    ('f', &name[1..])
                } else if name.starts_with('d') {
                    ('d', &name[1..])
                } else {
                    return None;
                };
                match s.parse::<u16>() {
                    Ok(w) => match k {
                        'i' => IntWidth::from_bits(w).map(NumericType::Int),
                        'u' => IntWidth::from_bits(w).map(NumericType::UInt),
                        'f' => FloatWidth::from_bits(w).map(NumericType::Float),
                        'd' if w >= 1 => Some(NumericType::Dec(w)),
                        _ => None,
                    },
                    Err(_) => None,
                }
            }
        }
    }
}

impl fmt::Display for NumericType {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            NumericType::Int(w) => write!(f, "Int({})", w.bits()),
            NumericType::UInt(w) => write!(f, "UInt({})", w.bits()),
            NumericType::Float(w) => write!(f, "Float({})", w.bits()),
            NumericType::ISize => write!(f, "ISize"),
            NumericType::USize => write!(f, "USize"),
            NumericType::Dec(n) => write!(f, "Dec({n})"),
        }
    }
}

// ─── Full Type System ──────────────────────────────────────────────

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum Type {
    Bool,
    Numeric(NumericType),
    Str,
    Bytes,
    Null,
    Void,
    Option(Box<Type>),
    Result(Box<Type>, Box<Type>),
    List(Box<Type>),
    Map(Box<Type>, Box<Type>),
    Set(Box<Type>),
    Struct(Identifier, Vec<(Identifier, Type)>),
    Enum(Identifier, Vec<SumVariant>),
    Constrained(Box<Type>, Box<ExprNode>),
    Residual(Box<Type>),
    Behavior(BehaviorRef),
    Handle(Identifier, Lifetime),
    Function {
        params: Vec<Type>,
        ret: Box<Type>,
    },
    SourceLoc,
    Range {
        start_type: Box<Type>,
        end_type: Box<Type>,
        closed: bool,
    },
    Slice {
        element_type: Box<Type>,
    },
    RegionError,
    UserDefined(String),
}

impl fmt::Display for Type {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Type::Bool => write!(f, "bool"),
            Type::Numeric(nt) => write!(f, "{}", nt),
            Type::Str => write!(f, "str"),
            Type::Bytes => write!(f, "bytes"),
            Type::Null => write!(f, "null"),
            Type::Void => write!(f, "void"),
            Type::Option(t) => write!(f, "Option<{}>", t),
            Type::Result(ok, err) => write!(f, "Result<{}, {}>", ok, err),
            Type::List(t) => write!(f, "[{}]", t),
            Type::Map(k, v) => write!(f, "Map<{}, {}>", k, v),
            Type::Set(t) => write!(f, "Set<{}>", t),
            Type::Struct(name, _) => write!(f, "{}", name),
            Type::Enum(name, _) => write!(f, "{}", name),
            Type::Constrained(t, _) => write!(f, "{}", t),
            Type::Residual(t) => write!(f, "residual<{}>", t),
            Type::Behavior(b) => write!(f, "{}", b.name),
            Type::Handle(name, _) => write!(f, "Handle<{}>", name),
            Type::Function { params, ret } => {
                let params_str: Vec<String> = params.iter().map(|p| p.to_string()).collect();
                write!(f, "fn({}) -> {}", params_str.join(", "), ret)
            }
            Type::SourceLoc => write!(f, "sourceloc"),
            Type::Range {
                start_type,
                end_type,
                closed,
            } => {
                let range_str = if *closed { "..=" } else { ".." };
                write!(f, "{}{}{}", start_type, range_str, end_type)
            }
            Type::Slice { element_type } => write!(f, "[{}]", element_type),
            Type::RegionError => write!(f, "region_error"),
            Type::UserDefined(s) => write!(f, "{}", s),
        }
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct SumVariant {
    pub name: Identifier,
    pub type_param: Option<Type>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct BehaviorRef {
    pub name: Identifier,
    pub type_params: Vec<Type>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Lifetime {
    pub name: String,
}

// ─── Operators ─────────────────────────────────────────────────────

#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
pub enum BinOp {
    Add,
    Sub,
    Mul,
    Div,
    Rem,
    ShiftLeft,
    ShiftRight,
    And,
    Or,
    Xor,
    Eq,
    Ne,
    Lt,
    Le,
    Gt,
    Ge,
}
impl BinOp {
    pub fn is_comparison(self) -> bool {
        matches!(
            self,
            BinOp::Eq | BinOp::Ne | BinOp::Lt | BinOp::Le | BinOp::Gt | BinOp::Ge
        )
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum UnaryOp {
    Neg,
    Not,
    BitNot,
    Cast(Box<Type>),
}

// ─── Effects, Capabilities, Provider ───────────────────────────────

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub enum Effect {
    Io,
    Provider(Provider),
    ResourceMutation,
    RuntimeForce,
    ConcurrencySpawn,
}

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub enum Provider {
    Filesystem,
    Environment,
    Git,
}

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub struct Capability {
    pub kind: CapabilityKind,
    pub params: Vec<ExprNode>,
}

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub enum CapabilityKind {
    Filesystem,
    Git,
    Environment,
    Compute,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum Provenance {
    Source {
        file: String,
        line: usize,
        col_start: usize,
    },
    Provider(Provider),
    Residual,
    Inferred,
}

// ─── Pattern ───────────────────────────────────────────────────────

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum PatternKind {
    Wildcard,
    Bind(Identifier),
    Variant {
        name: Identifier,
        param: Option<Identifier>,
    },
    Literal(LiteralValue),
    Struct {
        name: Identifier,
        fields: Vec<(Identifier, Pattern)>,
    },
    RangePattern {
        start: LiteralValue,
        end: LiteralValue,
        closed: bool,
    },
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Pattern {
    pub kind: PatternKind,
}

// ─── Literal Value (known) ─────────────────────────────────────────

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum LiteralValue {
    Int {
        value: u128,
        width: IntWidth,
        signed: bool,
    },
    UInt(u128, IntWidth),
    Float {
        value: String,
        width: FloatWidth,
    },
    Str(String),
    Bool(bool),
    Null,
    Bytes(Vec<u8>),
    Char(char),
    Struct {
        name: Identifier,
        fields: Vec<(Identifier, LiteralValue)>,
    },
    List(Vec<LiteralValue>),
}
impl fmt::Display for LiteralValue {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            LiteralValue::Int { value, width, .. } => write!(f, "{}_{}", value, width.bits()),
            LiteralValue::UInt(v, w) => write!(f, "{}_{}", v, w.bits()),
            LiteralValue::Float { value, .. } => write!(f, "{}", value),
            LiteralValue::Str(s) => write!(f, "\"{}\"", s),
            LiteralValue::Bool(b) => write!(f, "{}", b),
            LiteralValue::Null => write!(f, "null"),
            LiteralValue::Bytes(b) => write!(f, "b\"{}\"", String::from_utf8_lossy(b)),
            LiteralValue::Char(c) => write!(f, "'{}'", c),
            LiteralValue::Struct { name, fields } => {
                write!(f, "{} {{", name)?;
                for (i, (k, v)) in fields.iter().enumerate() {
                    if i > 0 {
                        write!(f, ", ")?;
                    }
                    write!(f, "{}: {}", k, v)?;
                }
                write!(f, "}}")
            }
            LiteralValue::List(elts) => {
                write!(f, "[")?;
                for (i, v) in elts.iter().enumerate() {
                    if i > 0 {
                        write!(f, ", ")?;
                    }
                    write!(f, "{}", v)?;
                }
                write!(f, "]")
            }
        }
    }
}

// ─── Span ───────────────────────────────────────────────────────────

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub struct Span {
    pub file: String,
    pub line: usize,
    pub col_start: usize,
    pub col_end: usize,
}
impl Span {
    pub fn unknown() -> Self {
        Span {
            file: "<unknown>".into(),
            line: 0,
            col_start: 0,
            col_end: 0,
        }
    }
}
impl fmt::Display for Span {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}:{}:{}", self.file, self.line, self.col_start)
    }
}

// ─── Identifier ─────────────────────────────────────────────────────

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Identifier {
    pub name: String,
    pub id: u64,
}
impl Identifier {
    pub fn new(name: impl Into<String>, id: u64) -> Self {
        Identifier {
            name: name.into(),
            id,
        }
    }
}
impl fmt::Display for Identifier {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.name)
    }
}

// ─── AST Expression Nodes ──────────────────────────────────────────

// Forward declare ExprNode for recursive type references
#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub struct ExprNode(pub GraphKey);
use crate::GraphKey;

#[allow(clippy::large_enum_variant)]
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum AstExpr {
    Id(String),
    Literal {
        value: u128,
        kind: AstIntKind,
        span: Span,
    },
    FloatLit {
        value: String,
        span: Span,
    },
    StrLit {
        value: String,
        span: Span,
    },
    BoolLit(bool, Span),
    NullLit(Span),
    CharLit(char, Span),
    Location(Span),
    BinaryOp {
        op: BinOp,
        lhs: Box<AstExpr>,
        rhs: Box<AstExpr>,
        span: Span,
    },
    UnaryOp {
        op: UnaryOp,
        operand: Box<AstExpr>,
        span: Span,
    },
    Call {
        func: Box<AstExpr>,
        args: Vec<(Option<String>, AstExpr)>,
        span: Span,
    },
    Rt(Box<AstExpr>, Span),
    AtResidual {
        type_: Type,
        inner: Box<AstExpr>,
        span: Span,
    },
    If {
        cond: Box<AstExpr>,
        then_block: Box<AstBlock>,
        else_block: Option<Box<AstBlock>>,
        span: Span,
    },
    While {
        cond: Box<AstExpr>,
        body: Box<AstBlock>,
        span: Span,
    },
    ForIn {
        type_: String,
        name: String,
        collection: Box<AstExpr>,
        body: Box<AstBlock>,
        span: Span,
    },
    Match {
        scrutinee: Box<AstExpr>,
        arms: Vec<(AstPattern, AstExpr)>,
        span: Span,
    },
    For {
        init: Option<AstStmt>,
        cond: Box<AstExpr>,
        step: Option<AstStmt>,
        body: Box<AstBlock>,
        span: Span,
    },
    Spawn {
        capabilities: Vec<Capability>,
        body: AstBlock,
        span: Span,
    },
    Assert {
        cond: Box<AstExpr>,
        message: Box<AstExpr>,
        span: Span,
    },
    RtAssert {
        cond: Box<AstExpr>,
        message: Box<AstExpr>,
        span: Span,
    },
    Known(Box<AstExpr>, Span),
    RtKnown(Box<AstExpr>, Span),
    ComptimePrint(Box<AstExpr>, Span),
    Todo(Span),
    Unimplemented(Span),
    StructLit {
        name: String,
        fields: Vec<(String, AstExpr)>,
        span: Span,
    },
    ListLit(Vec<AstExpr>, Span),
    MapLit(Vec<(AstExpr, AstExpr)>, Span),
    SetLit(Vec<AstExpr>, Span),
    Range {
        start: Box<AstExpr>,
        end: Box<AstExpr>,
        closed: bool,
        span: Span,
    },
    FString(Vec<AstFStringPart>, Span),
    RawString(String, Span),
    ByteString(Vec<u8>, Span),
    FieldAccess {
        target: Box<AstExpr>,
        field: String,
        span: Span,
    },
    Index {
        target: Box<AstExpr>,
        index: Box<AstExpr>,
        span: Span,
    },
    Slice {
        target: Box<AstExpr>,
        range: Box<AstRange>,
        span: Span,
    },
    MethodCall {
        target: Box<AstExpr>,
        method: String,
        args: Vec<AstExpr>,
        span: Span,
    },
    EarlyReturn(Box<AstExpr>, Span),
    ElseFallback {
        value: Box<AstExpr>,
        fallback: AstBlock,
        span: Span,
    },
    Destructure {
        pattern: AstPattern,
        source: Box<AstExpr>,
        span: Span,
    },
    IfLet {
        pattern: AstPattern,
        source: Box<AstExpr>,
        then_block: Box<AstBlock>,
        else_block: Option<Box<AstBlock>>,
        span: Span,
    },
    WhileLet {
        pattern: AstPattern,
        source: Box<AstExpr>,
        body: Box<AstBlock>,
        span: Span,
    },
    With {
        bindings: Vec<AstWithBinding>,
        body: AstBlock,
        span: Span,
    },
    Using {
        value: Box<AstExpr>,
        behavior: String,
        span: Span,
    },
    Discard(Box<AstExpr>, Span),
    ProviderCall {
        provider: String,
        args: Vec<AstExpr>,
        span: Span,
    },
    Span(Span),
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum AstIntKind {
    Decimal,
    Hex,
    Binary,
    Octal,
}
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum AstFStringPart {
    Text(String),
    Expr(Box<AstExpr>),
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct AstRange {
    pub start: Option<AstExpr>,
    pub end: Option<AstExpr>,
    pub closed: bool,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum AstPatternKind {
    Wildcard,
    Bind(String),
    Variant {
        name: String,
        param: Option<String>,
    },
    Literal(u128),
    Struct {
        name: String,
        fields: Vec<(String, AstPattern)>,
    },
}
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct AstPattern {
    pub kind: AstPatternKind,
    pub span: Span,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct AstBlock {
    pub statements: Vec<AstStmt>,
    pub ret: Option<Box<AstExpr>>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum AstStmtKind {
    Bind {
        type_: Option<String>,
        name: String,
        value: Box<AstExpr>,
    },
    Discard(Box<AstExpr>),
    Destructure {
        pattern: AstPattern,
        source: Box<AstExpr>,
    },
    Expr(Box<AstExpr>),
    Return(Option<Box<AstExpr>>),
    Break,
    Continue,
}
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct AstStmt {
    pub kind: AstStmtKind,
    pub span: Span,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct AstWithBinding {
    pub type_: Option<String>,
    pub name: String,
    pub init: Box<AstExpr>,
}

// ─── AST Function / Translation Unit ───────────────────────────────

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct AstFuncDef {
    pub public: bool,
    pub name: String,
    pub params: Vec<AstParam>,
    pub ret: Option<String>,
    pub body: AstBlock,
    pub doc_comments: Vec<String>,
    pub capabilities: Vec<Capability>,
    pub span: Span,
}
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct AstParam {
    pub type_: Option<String>,
    pub name: String,
    pub default: Option<AstExpr>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct AstTranslationUnit {
    pub imports: Vec<AstImport>,
    pub functions: Vec<AstFuncDef>,
}
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct AstImport {
    pub path: String,
}

// ─── Numeric Result Type ───────────────────────────────────────────

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ResultType {
    Numeric(NumericType),
    Bool,
    Error(NumericError),
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum NumericError {
    SignednessMix,
    /// Dec mixed with Int/UInt/Float in one operation (spec §6.6a: hard error).
    DecMix,
    /// An operator not defined on Dec (bitwise/shift).
    DecOp,
}

pub fn numeric_result_type(lhs: &NumericType, op: BinOp, rhs: &NumericType) -> ResultType {
    if lhs.is_dec() || rhs.is_dec() {
        if op.is_comparison() {
            return ResultType::Bool;
        }
        if matches!(
            op,
            BinOp::ShiftLeft | BinOp::ShiftRight | BinOp::And | BinOp::Or | BinOp::Xor
        ) {
            return ResultType::Error(NumericError::DecOp);
        }
        match (lhs, rhs) {
            (NumericType::Dec(a), NumericType::Dec(b)) => {
                return ResultType::Numeric(NumericType::Dec(*a.max(b)));
            }
            _ => return ResultType::Error(NumericError::DecMix),
        }
    }
    if lhs.is_float() || rhs.is_float() {
        return float_result(lhs, op, rhs, 64);
    }
    if op.is_comparison() {
        if lhs.is_signed() && rhs.is_unsigned() || lhs.is_unsigned() && rhs.is_signed() {
            return ResultType::Error(NumericError::SignednessMix);
        }
        return ResultType::Bool;
    }
    if lhs.is_signed() && rhs.is_unsigned() || lhs.is_unsigned() && rhs.is_signed() {
        return ResultType::Error(NumericError::SignednessMix);
    }
    let a = concrete_width(lhs);
    let b = concrete_width(rhs);
    let needed = needed_bits(op, a, b);
    let width = IntWidth::from_bits(needed)
        .or_else(|| {
            let supported = [8u16, 16, 32, 64, 128, 256, 512];
            supported
                .iter()
                .find(|&&w| w > needed)
                .map(|&w| IntWidth::from_bits(w).unwrap())
        })
        .unwrap_or(IntWidth::B512);
    let ty = if lhs.is_signed() {
        NumericType::Int(width)
    } else {
        NumericType::UInt(width)
    };
    ResultType::Numeric(ty)
}

fn concrete_width(ty: &NumericType) -> u16 {
    match ty {
        NumericType::Int(w) | NumericType::UInt(w) => w.bits(),
        NumericType::Float(w) => w.bits(),
        NumericType::ISize | NumericType::USize => 64,
        // Dec never reaches width widening (short-circuited in numeric_result_type).
        NumericType::Dec(_) => 0,
    }
}
fn needed_bits(op: BinOp, a: u16, b: u16) -> u16 {
    match op {
        // Spec v3.2 §6.1: add/sub yield the widest operand width.
        // Overflow is handled by checked semantics (trap), never by
        // static promotion — promote-then-narrow loses the carry.
        BinOp::Add | BinOp::Sub => a.max(b),
        // Multiplication keeps the range rule: headroom is real and
        // crypto code relies on products fitting the promoted width.
        BinOp::Mul => a + b,
        BinOp::Div
        | BinOp::Rem
        | BinOp::ShiftLeft
        | BinOp::ShiftRight
        | BinOp::And
        | BinOp::Or
        | BinOp::Xor
        | BinOp::Eq
        | BinOp::Ne
        | BinOp::Lt
        | BinOp::Le
        | BinOp::Gt
        | BinOp::Ge => a.max(b),
    }
}
fn float_result(lhs: &NumericType, op: BinOp, rhs: &NumericType, _tw: u16) -> ResultType {
    if op.is_comparison() {
        return ResultType::Bool;
    }
    match (lhs, rhs) {
        (NumericType::Float(a), NumericType::Float(b)) => {
            let w = if a.bits() >= b.bits() { *a } else { *b };
            ResultType::Numeric(NumericType::Float(w))
        }
        (l, NumericType::Float(b)) if l.is_integer() => ResultType::Numeric(NumericType::Float(*b)),
        (NumericType::Float(w), r) if r.is_integer() => ResultType::Numeric(NumericType::Float(*w)),
        _ => ResultType::Error(NumericError::SignednessMix),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_int_width_bits() {
        assert_eq!(IntWidth::B8.bits(), 8);
        assert_eq!(IntWidth::B64.bits(), 64);
        assert_eq!(IntWidth::B512.bits(), 512);
    }

    #[test]
    fn test_int_width_from_bits() {
        assert_eq!(IntWidth::from_bits(8), Some(IntWidth::B8));
        assert_eq!(IntWidth::from_bits(64), Some(IntWidth::B64));
        assert_eq!(IntWidth::from_bits(100), None);
    }

    #[test]
    fn test_float_width_bits() {
        assert_eq!(FloatWidth::F16.bits(), 16);
        assert_eq!(FloatWidth::F64.bits(), 64);
        assert_eq!(FloatWidth::F128.bits(), 128);
        assert_eq!(FloatWidth::from_bits(256), None);
        assert_eq!(FloatWidth::from_bits(512), None);
    }

    #[test]
    fn test_numeric_type_from_name() {
        assert_eq!(
            NumericType::from_name("Int"),
            Some(NumericType::Int(IntWidth::B64))
        );
        assert_eq!(
            NumericType::from_name("UInt"),
            Some(NumericType::UInt(IntWidth::B64))
        );
        assert_eq!(
            NumericType::from_name("Float"),
            Some(NumericType::Float(FloatWidth::F64))
        );
        assert_eq!(NumericType::from_name("ISize"), Some(NumericType::ISize));
        assert_eq!(NumericType::from_name("USize"), Some(NumericType::USize));
        assert_eq!(
            NumericType::from_name("i32"),
            Some(NumericType::Int(IntWidth::B32))
        );
        assert_eq!(
            NumericType::from_name("u16"),
            Some(NumericType::UInt(IntWidth::B16))
        );
        assert_eq!(
            NumericType::from_name("f32"),
            Some(NumericType::Float(FloatWidth::F32))
        );
        assert_eq!(
            NumericType::from_name("f128"),
            Some(NumericType::Float(FloatWidth::F128))
        );
        assert_eq!(NumericType::from_name("invalid"), None);
    }

    #[test]
    fn test_numeric_type_is_signed() {
        assert!(NumericType::Int(IntWidth::B64).is_signed());
        assert!(NumericType::ISize.is_signed());
        assert!(!NumericType::UInt(IntWidth::B64).is_signed());
        assert!(!NumericType::Float(FloatWidth::F64).is_signed());
    }

    #[test]
    fn test_numeric_type_is_unsigned() {
        assert!(NumericType::UInt(IntWidth::B64).is_unsigned());
        assert!(NumericType::USize.is_unsigned());
        assert!(!NumericType::Int(IntWidth::B64).is_unsigned());
    }

    #[test]
    fn test_numeric_type_is_integer() {
        assert!(NumericType::Int(IntWidth::B64).is_integer());
        assert!(NumericType::UInt(IntWidth::B64).is_integer());
        assert!(!NumericType::Float(FloatWidth::F64).is_integer());
    }

    #[test]
    fn test_numeric_type_is_float() {
        assert!(NumericType::Float(FloatWidth::F64).is_float());
        assert!(!NumericType::Int(IntWidth::B64).is_float());
    }

    #[test]
    fn test_numeric_type_target_width() {
        assert_eq!(NumericType::Int(IntWidth::B32).target_width(), Some(32));
        assert_eq!(NumericType::UInt(IntWidth::B64).target_width(), Some(64));
        assert_eq!(
            NumericType::Float(FloatWidth::F128).target_width(),
            Some(128)
        );
        assert_eq!(NumericType::ISize.target_width(), Some(64));
    }

    #[test]
    fn test_binop_is_comparison() {
        assert!(BinOp::Eq.is_comparison());
        assert!(BinOp::Lt.is_comparison());
        assert!(!BinOp::Add.is_comparison());
        assert!(!BinOp::Mul.is_comparison());
    }

    #[test]
    fn test_numeric_result_type_add_widening() {
        // Spec v3.2 §6.1: add/sub yield the widest operand width;
        // overflow is handled by checked semantics, not promotion.
        let i8_t = NumericType::Int(IntWidth::B8);
        let i8_t2 = NumericType::Int(IntWidth::B8);
        let result = numeric_result_type(&i8_t, BinOp::Add, &i8_t2);
        match result {
            ResultType::Numeric(NumericType::Int(w)) => assert_eq!(w, IntWidth::B8),
            _ => panic!("expected Int(8)"),
        }
        // Multiplication keeps the range rule.
        let mul = numeric_result_type(&i8_t, BinOp::Mul, &i8_t2);
        match mul {
            ResultType::Numeric(NumericType::Int(w)) => assert_eq!(w, IntWidth::B16),
            _ => panic!("expected Int(16) for mul"),
        }
    }

    #[test]
    fn test_numeric_result_type_signedness_mix_error() {
        let signed = NumericType::Int(IntWidth::B64);
        let unsigned = NumericType::UInt(IntWidth::B64);
        assert!(matches!(
            numeric_result_type(&signed, BinOp::Add, &unsigned),
            ResultType::Error(_)
        ));
        assert!(matches!(
            numeric_result_type(&unsigned, BinOp::Add, &signed),
            ResultType::Error(_)
        ));
    }

    #[test]
    fn test_numeric_result_type_comparison_produces_bool() {
        let i64 = NumericType::Int(IntWidth::B64);
        assert!(matches!(
            numeric_result_type(&i64, BinOp::Lt, &i64),
            ResultType::Bool
        ));
        assert!(matches!(
            numeric_result_type(&i64, BinOp::Eq, &i64),
            ResultType::Bool
        ));
    }

    #[test]
    fn test_numeric_result_type_float_widening() {
        let f32 = NumericType::Float(FloatWidth::F32);
        let f64 = NumericType::Float(FloatWidth::F64);
        let result = numeric_result_type(&f32, BinOp::Add, &f64);
        assert!(matches!(
            result,
            ResultType::Numeric(NumericType::Float(FloatWidth::F64))
        ));
    }

    #[test]
    fn test_dec_arithmetic_max_digits() {
        let d2 = NumericType::Dec(2);
        let d5 = NumericType::Dec(5);
        assert!(matches!(
            numeric_result_type(&d2, BinOp::Add, &d5),
            ResultType::Numeric(NumericType::Dec(5))
        ));
        assert!(matches!(
            numeric_result_type(&d2, BinOp::Mul, &d2),
            ResultType::Numeric(NumericType::Dec(2))
        ));
    }

    #[test]
    fn test_dec_mix_is_hard_error() {
        let d = NumericType::Dec(4);
        let i = NumericType::Int(IntWidth::B64);
        let f = NumericType::Float(FloatWidth::F64);
        let u = NumericType::UInt(IntWidth::B64);
        assert!(matches!(
            numeric_result_type(&d, BinOp::Add, &i),
            ResultType::Error(NumericError::DecMix)
        ));
        assert!(matches!(
            numeric_result_type(&i, BinOp::Add, &d),
            ResultType::Error(NumericError::DecMix)
        ));
        assert!(matches!(
            numeric_result_type(&d, BinOp::Add, &f),
            ResultType::Error(NumericError::DecMix)
        ));
        assert!(matches!(
            numeric_result_type(&u, BinOp::Add, &d),
            ResultType::Error(NumericError::DecMix)
        ));
    }

    #[test]
    fn test_dec_comparison_and_bitwise() {
        let d = NumericType::Dec(4);
        assert!(matches!(
            numeric_result_type(&d, BinOp::Lt, &d),
            ResultType::Bool
        ));
        assert!(matches!(
            numeric_result_type(&d, BinOp::Eq, &d),
            ResultType::Bool
        ));
        assert!(matches!(
            numeric_result_type(&d, BinOp::And, &d),
            ResultType::Error(NumericError::DecOp)
        ));
        assert!(matches!(
            numeric_result_type(&d, BinOp::ShiftLeft, &d),
            ResultType::Error(NumericError::DecOp)
        ));
    }

    #[test]
    fn test_dec_from_name() {
        assert_eq!(
            NumericType::from_name("Dec"),
            Some(NumericType::Dec(34))
        );
        assert_eq!(NumericType::from_name("d12"), Some(NumericType::Dec(12)));
        assert_eq!(NumericType::from_name("d1"), Some(NumericType::Dec(1)));
        assert_eq!(NumericType::from_name("d0"), None);
        assert_eq!(NumericType::from_name("dabc"), None);
        assert_eq!(NumericType::from_name("Dec(8)"), None);
    }

    #[test]
    fn test_dec_target_width_none() {
        assert_eq!(NumericType::Dec(4).target_width(), None);
        assert!(!NumericType::Dec(4).is_signed());
        assert!(!NumericType::Dec(4).is_unsigned());
        assert!(!NumericType::Dec(4).is_integer());
        assert!(!NumericType::Dec(4).is_float());
        assert!(NumericType::Dec(4).is_dec());
    }

    #[test]
    fn test_numeric_result_type_int_float_mixed() {
        let i32 = NumericType::Int(IntWidth::B32);
        let f64 = NumericType::Float(FloatWidth::F64);
        let result = numeric_result_type(&i32, BinOp::Add, &f64);
        assert!(matches!(
            result,
            ResultType::Numeric(NumericType::Float(FloatWidth::F64))
        ));
    }

    #[test]
    fn test_literal_value_display() {
        let int_lit = LiteralValue::Int {
            value: 42,
            width: IntWidth::B64,
            signed: true,
        };
        assert_eq!(format!("{}", int_lit), "42_64");

        let bool_lit = LiteralValue::Bool(true);
        assert_eq!(format!("{}", bool_lit), "true");

        let str_lit = LiteralValue::Str("hello".into());
        assert_eq!(format!("{}", str_lit), "\"hello\"");
    }

    #[test]
    fn test_type_display() {
        assert_eq!(format!("{}", Type::Bool), "bool");
        assert_eq!(
            format!("{}", Type::Numeric(NumericType::Int(IntWidth::B64))),
            "Int(64)"
        );
        assert_eq!(format!("{}", Type::Str), "str");
        assert_eq!(format!("{}", Type::Void), "void");
    }

    #[test]
    fn test_span_unknown() {
        let s = Span::unknown();
        assert_eq!(s.file, "<unknown>");
        assert_eq!(s.line, 0);
    }

    #[test]
    fn test_identifier_new() {
        let id = Identifier::new("foo", 42);
        assert_eq!(id.name, "foo");
        assert_eq!(id.id, 42);
        assert_eq!(format!("{}", id), "foo");
    }

    #[test]
    fn test_provenance_display() {
        let p = Provenance::Inferred;
        let _ = format!("{:?}", p);
    }
}
