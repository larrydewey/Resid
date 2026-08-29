//! AST node types for the Resid language.
//!
//! Implements all EBNF productions from spec §28.

use resid_lexer::token::*;

/// A simple identifier.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct Id(pub String);

impl std::fmt::Display for Id {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}

// ─── Translation Unit ───────────────────────────────────────────

/// Top-level program.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TranslationUnit {
    pub imports: Vec<ImportDecl>,
    pub declarations: Vec<Declaration>,
}

// ─── Import Declarations ────────────────────────────────────────

/// import "path"; / import "path" (a, b); / import "path" as M;
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ImportDecl {
    pub path: String,
    pub names: Option<Vec<Id>>,
    pub alias: Option<Id>,
    pub span: Span,
}

// ─── Declarations ───────────────────────────────────────────────

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Declaration {
    Function(FuncDef),
    Type(TypeDef),
    Behavior(BehaviorDef),
    Sandbox(SandboxDecl),
}

/// sandbox (filesystem(readonly)) { … }
/// Restricts the capabilities available to all code inside.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct SandboxDecl {
    pub capabilities: Vec<CapabilityAnnotation>,
    pub body: Vec<Declaration>,
    pub span: Span,
}

/// Function definition.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FuncDef {
    pub pub_: bool,
    pub name: Id,
    pub params: Vec<Param>,
    pub ret: Type,
    pub body: Block,
    pub doc_comments: Vec<String>,
    pub capabilities: Vec<CapabilityAnnotation>,
    /// Capability ceiling imposed by an enclosing `sandbox (…)` block (spec §21).
    /// Empty when the function is not inside a sandbox.
    pub sandbox_ceiling: Vec<CapabilityAnnotation>,
    pub span: Span,
}

/// Function parameter.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Param {
    pub type_: Type,
    pub name: Id,
    pub default: Option<Expr>,
}

/// Block of statements.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Block {
    pub statements: Vec<Stmt>,
    pub ret: Option<Box<Expr>>,
    pub span: Span,
}

/// Type definition: type T = ...;
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TypeDef {
    pub name: Id,
    pub body: TypeBody,
    pub doc_comments: Vec<String>,
    pub span: Span,
}

/// Behavior definition: Ord(Int) = ...;
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct BehaviorDef {
    pub name: Id,
    pub type_params: Vec<Id>,
    pub body: Expr,
    pub span: Span,
}

/// Capability annotation: @requires(filesystem, git(readonly))
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CapabilityAnnotation {
    pub name: Id,
    pub params: Vec<Expr>,
}

// ─── Type ───────────────────────────────────────────────────────

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum TypeBody {
    Product(Vec<(Id, Type)>),
    Sum(Vec<SumVariant>),
    Constraint {
        inner: Box<Type>,
        constraint: Box<Expr>,
    },
    /// A plain type on the RHS of a `type` declaration (alias or base).
    Base(Box<Type>),
    Residual(Box<Type>),
}

/// Sum type variant: Some(T) | None
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct SumVariant {
    pub name: Id,
    pub type_param: Option<Type>,
}

/// Full type representation.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Type {
    Base { name: Id, params: Option<Vec<Type>> },
    /// Refinement type: `Int[value > 0]` (spec §12).
    Refined {
        base: Box<Type>,
        constraint: Box<Expr>,
    },
    Residual(Box<Type>),
    ISize,
    USize,
    Literal(Literal),
}

// ─── Expression Kinds ───────────────────────────────────────────

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ExprKind {
    // Literals and values
    Id(Id),
    Literal(Literal),
    Location, // #location

    // Operations
    BinaryOp {
        op: Op,
        lhs: Box<Expr>,
        rhs: Box<Expr>,
    },
    UnaryOp {
        op: Op,
        operand: Box<Expr>,
    },
    Cast {
        type_: Type,
        operand: Box<Expr>,
    },

    // Function call with named args
    Call {
        func: Box<Expr>,
        args: Vec<(Option<Id>, Expr)>,
    },

    // Residual marker
    Rt(Box<Expr>),
    AtResidual {
        type_: Type,
        inner: Box<Expr>,
    },

    // Control flow
    If {
        cond: Box<Expr>,
        then_block: Box<Block>,
        else_block: Option<Box<Block>>,
    },
    While {
        cond: Box<Expr>,
        body: Box<Block>,
    },
    ForIn {
        type_: Type,
        name: Id,
        collection: Box<Expr>,
        body: Box<Block>,
    },
    Match {
        scrutinee: Box<Expr>,
        arms: Vec<(Pattern, Expr)>,
    },
    For {
        init: Option<Stmt>,
        cond: Box<Expr>,
        step: Option<Stmt>,
        body: Box<Block>,
    },

    // Spawn (structured concurrency)
    Spawn {
        capabilities: Vec<CapabilityAnnotation>,
        body: Block,
    },

    // Assertions and debugging
    Assert {
        cond: Box<Expr>,
        message: Box<Expr>,
    },
    RtAssert {
        cond: Box<Expr>,
        message: Box<Expr>,
    },
    Known(Box<Expr>),
    RtKnown(Box<Expr>),
    ComptimePrint(Box<Expr>),
    Todo(String),
    Unimplemented(String),

    // Composite literals
    StructLit {
        name: Id,
        fields: Vec<(Id, Expr)>,
    },
    ListLit(Vec<Expr>),
    MapLit(Vec<(Expr, Expr)>),
    SetLit(Vec<Expr>),
    Range {
        start: Box<Expr>,
        end: Box<Expr>,
        closed: bool,
    },

    // Strings
    FString(Vec<FStringPart>),
    RawString(String),
    ByteString(Vec<u8>),

    // Access
    FieldAccess {
        target: Box<Expr>,
        field: Id,
    },
    Index {
        target: Box<Expr>,
        index: Box<Expr>,
    },
    Slice {
        target: Box<Expr>,
        range: Box<RangeExpr>,
    },
    MethodCall {
        target: Box<Expr>,
        method: Id,
        args: Vec<Box<Expr>>,
    },

    // Result/Option sugar
    EarlyReturn(Box<Expr>), // value?
    ElseFallback {
        value: Box<Expr>,
        fallback: Block,
    }, // value else { … }

    // Destructuring bindings
    Destructure {
        pattern: Pattern,
        source: Box<Expr>,
    },

    // if-let / while-let
    IfLet {
        pattern: Pattern,
        source: Box<Expr>,
        then_block: Box<Block>,
        else_block: Option<Box<Block>>,
    },
    WhileLet {
        pattern: Pattern,
        source: Box<Expr>,
        body: Box<Block>,
    },

    // Handle management
    With {
        bindings: Vec<WithBinding>,
        body: Block,
    },

    // Using clause (explicit behavior selection)
    Using {
        value: Box<Expr>,
        behavior: Id,
    },

    // Provider call: `provider.verb(args)` — authorized external knowledge.
    ProviderCall {
        provider: Id,
        verb: Id,
        args: Vec<Box<Expr>>,
    },

    // Discard
    Discard(Box<Expr>), // _ = expression
}

/// F-string part.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum FStringPart {
    Text(String),
    Expr(Box<Expr>),
}

/// Range expression (for slicing).
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RangeExpr {
    pub start: Option<Expr>,
    pub end: Option<Expr>,
    pub closed: bool,
}

/// With binding.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct WithBinding {
    pub type_: Type,
    pub name: Id,
    pub init: Box<Expr>,
}

/// Expression (boxed for recursion).
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Expr {
    pub kind: ExprKind,
    pub span: Span,
}

impl Expr {
    pub fn span(&self) -> &Span {
        &self.span
    }
}

// ─── Pattern ────────────────────────────────────────────────────

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PatternKind {
    Wildcard,
    Bind(Id),
    Variant {
        name: Id,
        param: Option<Id>,
    }, // Some(x)
    Literal(Literal),
    Struct {
        name: Id,
        fields: Vec<(Id, Pattern)>,
    },
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Pattern {
    pub kind: PatternKind,
    pub span: Span,
}

// ─── Statement Kinds ────────────────────────────────────────────

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum StmtKind {
    Bind {
        type_: Option<Type>,
        name: Id,
        value: Box<Expr>,
    },
    Discard(Box<Expr>),
    Destructure {
        pattern: Pattern,
        source: Box<Expr>,
    },
    Expr(Box<Expr>), // expression statement
    Return(Option<Box<Expr>>),
    Break,
    Continue,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Stmt {
    pub kind: StmtKind,
    pub span: Span,
}
