# Resid Compiler v3.0 — Implementation Plan

**Specification**: `resid_specification.txt` v3.0 (Production Ready)
**Target**: Stable Rust + LLVM (via inkwell)
**Workspace**: Monorepo, Cargo workspace
**Stdlib**: Rust first, then migrate to Resid
**Wide numeric types**: Software emulation via arrays + runtime library
**Interpreter**: None — direct LLVM

---

## 1. OVERVIEW

Resid is an eager compile-time language. The compiler's job is **maximal authorized reduction of first-class knowledge**. Programs are represented as a knowledge graph (enriched DAG). Reduction happens eagerly at compile time. Only irreducible computation becomes residual and enters the runtime via `rt`.

### Key design decisions

| Decision | Choice |
|----------|--------|
| Language | Rust, stable only |
| Backend | LLVM via `inkwell` crate |
| Interpreter | None — direct LLVM |
| Workspace | Monorepo (cargo workspace) |
| Wide types | Software emulation (arrays of i64 + runtime lib) |
| Target | LLVM all-arch (x86_64, aarch64, etc.) |

---

## 2. WORKSPACE STRUCTURE

```
resid/
├── Cargo.toml              # workspace root
├── resid.toml.example      # sample project config
│
├── crates/
│   ├── resid-lexer/        # 1. Tokenization
│   ├── resid-parser/       # 2. Parsing → AST
│   ├── resid-ir/           # 3. Knowledge graph IR + reduction
│   ├── resid-type/         # 4. Types, behaviors, capabilities
│   ├── resid-codegen/      # 5. LLVM code generation
│   ├── resid-builtin/      # 6. Built-in types/providers (Rust stdlib)
│   ├── resid-build/        # 7. Build system (resid.toml, profiles)
│   └── residc/             # 8. CLI binary
│
├── tools/
│   ├── resid-fmt/          # 9. Canonical formatter
│   ├── resid-notes/        # 10. CBOR residual notes viewer
│   ├── resid-cache/        # 11. Knowledge cache inspector
│   ├── resid-graph/        # 12. Dependency graph emitter
│   └── resid-why/          # 13. Residual provenance query
│
└── lsp-server/             # 14. LSP server
```

### Crate dependencies

```
residc
  ├── resid-build
  ├── resid-lexer
  ├── resid-parser
  ├── resid-ir
  ├── resid-type
  ├── resid-codegen
  ├── resid-builtin (for built-in provider implementations)
  └── lsp-server

tools/*                → resid-ir, resid-type (read-only, inspect artifacts)
lsp-server             → resid-ir, resid-parser, resid-type (full read access)
```

---

## 3. COMPILATION PIPELINE

```
Source (.resid)
    │
    ▼
┌─────────────────────────────────────────────────────────────────┐
│ PHASE 1: LEXER → TokenStream                                    │
│   All tokens per EBNF: keywords, id, literals (incl. f-strings, │
│   raw strings, byte strings, #location), ranges, punct, ops    │
│   Span tracking (file, line, col_start, col_end)               │
│   Errors: unexpected char, unterminated strings, etc.          │
└─────────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────────┐
│ PHASE 2: PARSER → AST                                           │
│   Recursive descent + precedence climbing (§27)                 │
│   All EBNF productions (§28)                                    │
│   - Parameter defaults, named args                              │
│   - Spawn expressions, for-in                                   │
│   - Ranges, slices, destructuring patterns                      │
│   - f-strings, raw strings, byte strings, #location             │
│   - if-let, while-let, value?, value else {}                    │
│   - @residual sugar, assertions                                 │
└─────────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────────┐
│ PHASE 3: AST → KNOWLEDGE GRAPH (IR)                             │
│   Enriched expression DAG with: type, knowledge state,          │
│   dependencies, effects, capabilities, provenance               │
│   Enforce: unique identifiers (no shadowing), discard _,       │
│   parameter defaults, named args resolution                     │
└─────────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────────┐
│ PHASE 4: REDUCTION ENGINE                                       │
│   Κ ⊢ e → e′ — fixed-point iteration to normal form           │
│   All reduction rules (§33)                                     │
└─────────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────────┐
│ PHASE 5: TYPE CHECK + BEHAVIOR INFERENCE + CAPABILITIES         │
│   Type checking, auto-behavior insertion, R1-R5 residual rules  │
│   Capability lattice checks (§20), provenance tracking          │
│   Result/Option sugar context checks                            │
└─────────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────────┐
│ PHASE 6: LLVM CODE GENERATION                                   │
│   Known → inline/constant elimination                           │
│   Residual → first-class LLVM thunks (§30)                      │
│   Handles → runtime-resolved resources                          │
│   Spawn → structured concurrency (scheduler-agnostic)           │
│   Emit: native binary + .resid-notes.cbor                       │
└─────────────────────────────────────────────────────────────────┘
```

---

## 4. DETAILED CRATE DESIGNS

### 4.1 `resid-lexer` — Tokenization

**Responsibility**: Convert `.resid` source text into a stream of tokens.

**Tokens** (enum):

```rust
Token {
    kind: TokenKind,
    span: Span,  // file, line, col_start, col_end
}

TokenKind:
    - Keyword(Keyword)
    - Ident(String)
    - Literal(Literal)
    - Op(Op)
    - Punct(Punct)
    - Eof
```

**Lexical rules** (from spec §14, §30, §31):
- Comments: `//` line comments, `///` doc comments, `/** */` block doc comments
- Keywords: `import`, `pub`, `type`, `with`, `rt`, `match`, `if`, `else`, `while`, `for`, `return`, `break`, `continue`, `spawn`, `known`, `rt_known`, `comptime_print`, `todo`, `unimplemented`, `@residual`
- Literals: integer (decimal, hex 0x, binary 0b, octal 0o), float, char, string, f-string, raw string, byte string, bool, null, `#location`
- Operators: `+`, `-`, `*`, `/`, `%`, `!`, `~`, `<<`, `>>`, `<`, `<=`, `>`, `>=`, `==`, `!=`, `&`, `^`, `|`, `&&`, `||`, `?`, `:`, `=`, `;`, `,`, `(`, `)`, `{`, `}`, `[`, `]`, `.`, `|`, `=>`, `..`, `..=`, `@`
- Punctuation: `@` (capability/residual annotation)

**String handling**:
- `"hello\n"` — regular string, escape sequences processed
- `f"hello {name}, version {ver}"` — f-string, interpolation points as sub-tokens
- `r"C:\path\file"` — raw string, no escape processing
- `b"bytes"` — byte string, yields Bytes type

**Implementation**: Recursive descent, char-by-char scanning, span tracking. No dependencies.

---

### 4.2 `resid-parser` — Parsing

**Responsibility**: Convert token stream into an AST per EBNF in spec §31.

**AST Node types** (enum-based tagged union):

```rust
enum AstNode {
    // Translation unit
    TranslationUnit { imports: Vec<Import>, declarations: Vec<Declaration> },

    // Import
    Import { path: String, names: Option<Vec<Id>>, alias: Option<Id> },

    // Declarations
    FunctionDef {
        pub: bool,
        name: Id,
        params: Vec<Param>,       // type, name, default: Option<Expr>
        ret: Type,
        body: Block,
        doc_comments: Vec<String>,
    },
    TypeDef { name: Id, body: TypeBody, doc_comments: Vec<String> },
    BehaviorDef { name: Id, type_params: Vec<Type>, body: Expr },
    CapabilityAnnotation { annotations: Vec<CapabilityAnnotation>, inner: Box<AstNode> },

    // Parameters (spec §31)
    Param { type_: Type, name: Id, default: Option<Expr> },

    // Types
    Type { name: Id, params: Option<Vec<Type>> },
    ProductType { fields: Vec<(Id, Type)> },
    SumType { variants: Vec<SumVariant> },
    ConstraintType { inner: Box<TypeBody>, constraint: Expr },
    ResidualType(Box<Type>),

    // Expressions (full hierarchy per §30 precedence)
    Expr(Box<ExprKind>),

    // Statements
    Stmt(Box<StmtKind>),

    // Patterns (for matching and destructuring)
    Pattern(Box<PatternKind>),
}

enum ExprKind {
    // Literals and values
    Id(Id),
    Literal(Literal),
    Location,                  // #location

    // Operations
    BinaryOp(Expr, Op, Expr),
    UnaryOp(Op, Expr),
    Cast(Type, Expr),
    FunctionCall(Expr, Vec<(Option<Id>, Expr)>),  // named args
    Rt(Expr),                          // residual marker
    AtResidual(Type, Expr),            // @residual sugar

    // Control flow
    If { cond: Expr, then: Block, els: Option<Block> },
    While { cond: Expr, body: Block },
    For { init: Option<Stmt>, cond: Expr, step: Option<Stmt>, body: Block },
    ForIn { type_: Type, name: Id, collection: Expr, body: Block },
    Match(Expr, Vec<(Pattern, Expr)>),
    Spawn { capabilities: Vec<Capability>, body: Block },

    // Assertions and debugging
    Assert { cond: Expr, message: Expr },
    RtAssert { cond: Expr, message: Expr },
    Known(Expr),
    RtKnown(Expr),
    ComptimePrint(Expr),
    Todo(String),
    Unimplemented(String),

    // Structs, lists, maps, ranges
    StructLit(Id, Vec<(Id, Expr)>),
    ListLit(Vec<Expr>),
    MapLit(Vec<(Expr, Expr)>),
    Range { start: Expr, end: Expr, closed: bool },  // start..end, start..=end
    FString(Vec<FStringPart>),      // interpolated string
    RawString(String),
    ByteString(Vec<u8>),

    // Access and slicing
    FieldAccess(Expr, Id),
    Index(Expr, Expr),
    Slice { target: Expr, range: RangeExpr },  // xs[start..end]
    MethodCall(Expr, Id, Vec<Expr>),

    // Result/Option sugar (desugared at AST or IR phase)
    EarlyReturn(Expr),           // value?  — in Result/Option-returning fn
    ElseFallback { value: Expr, fallback: Block },  // value else { … }

    // Destructuring bindings (irrefutable)
    Destructure {
        pattern: Pattern,
        source: Expr,
    },

    // If-let / while-let
    IfLet {
        pattern: Pattern,
        source: Expr,
        then: Block,
        els: Option<Block>,
    },
    WhileLet {
        pattern: Pattern,
        source: Expr,
        body: Block,
    },

    // With handles (multiple bindings)
    With(Vec<WithBinding>, Block),

    // Using clause (explicit behavior selection)
    Using { value: Expr, behavior: BehaviorRef },

    // Provider call (external knowledge)
    ProviderCall(Provider, Vec<Expr>),

    // Discard binding
    Discard(Expr),  // _ = expression
}

struct FStringPart {
    text: String,
    expr: Option<Expr>,
}

struct RangeExpr {
    start: Option<Expr>,
    end: Option<Expr>,
    closed: bool,
}

struct WithBinding {
    type_: Type,
    name: Id,
    init: Expr,
}

struct CapabilityAnnotation {
    name: Id,
    params: Vec<Expr>,  // optional, e.g., filesystem(scope=["..."]), git(readonly)
}

// Patterns (for match arms and destructuring)
enum PatternKind {
    Wildcard,
    Bind(Id),
    Variant(Id, Option<Id>),           // Some(x)
    Literal(Literal),
    Struct(Id, Vec<(Id, Pattern)>),     // Point { x, y } — shorthand for Point { x: x, y: y }
    RangePattern { start: Lit, end: Lit, closed: bool },
}

// Type variants (spec §31)
enum TypeKind {
    Base { name: Id, params: Option<Vec<Type>> },  // Int, Option(T), Int(32)
    Residual(Box<Type>),                          // rt Type
    ISize,
    USize,
}
```

**Parser structure**: Recursive descent with precedence climbing for operators.

```
Parser {
    tokens: TokenStream,
    pos: usize,
    errors: Vec<ParseError>,
}
```

**Key parser methods**:
- `parse_translation_unit()`
- `parse_declaration()` — handles `pub`, doc comments, function, type, behavior
- `parse_expression()` — uses precedence climbing per §27
- `parse_pattern()` — for match arms and destructuring
- `parse_type()` — product, sum, constrained, parameterized primitives
- `parse_statement()` — handles all control flow including if-let, while-let, for-in
- `parse_fstring()` — parses interpolated string parts
- `parse_param()` — handles optional default values

**Precedence climbing** (per spec §30):
```
14: conditional  (?:)
13: using        (, using =)
12: logical OR   (||)
11: logical AND  (&&)
10: bitwise OR   (|)
 9: bitwise XOR  (^)
 8: bitwise AND  (&)
 7: equality     (==, !=)
 6: relational   (<, <=, >, >=)
 5: shift        (<<, >>)
 4: additive     (+, -)
 3: multiplicative (*, /, %)
 2: unary        (+, -, !, ~, cast)
 1: primary      (id, lit, rt, call, index, field, method, range, slice, #location)
```

**Parameter defaults and named args**:
- Parameters parsed as `type name [ = default_expr ]`
- Function call args: `f(a, b = 2, c = 3)` → store as `Vec<(Option<Id>, Expr)>`
- Named args resolved against parameter list during semantic analysis

---

### 4.3 `resid-ir` — Knowledge Graph IR

**This is the heart of the compiler.** The knowledge graph is an enriched expression DAG.

**Core data structures**:

```rust
/// Node ID in the DAG
type NodeId = u64;

/// The knowledge graph — a DAG where each node tracks full context
pub struct KnowledgeGraph {
    nodes: Arena<Node>,          // all nodes
    entry_point: NodeId,         // main function entry
    imports: Vec<ResolvedImport>, // resolved import graph
    doc_comments: HashMap<NodeId, Vec<String>>, // doc comment mapping
}

/// Single node in the knowledge graph
pub struct Node {
    /// The expression this node represents
    kind: NodeKind,

    /// Type of this node's value
    type_: TypeEnv,

    /// Current knowledge state
    knowledge: KnowledgeState,

    /// Dependencies (child NodeIds this node depends on)
    deps: Vec<NodeId>,

    /// Effects this node performs (inferred)
    effects: HashSet<Effect>,

    /// Capabilities this node requires
    capabilities: HashSet<Capability>,

    /// Where this value came from (provenance)
    provenance: Provenance,

    /// Doc comment, if any
    doc_comments: Option<Vec<String>>,
}

/// What this node computes
pub enum NodeKind {
    // Literals and values
    Literal(Literal),
    Location,                        // #location → SourceLoc value

    // Bindings (immutable, unique identifiers)
    Binding { name: Identifier, def: NodeId },
    Discard { source: NodeId },      // _ = expression

    // Functions
    Function {
        name: Identifier,
        params: Vec<(Identifier, TypeEnv, Option<NodeId>)>,  // + defaults
        ret: TypeEnv,
        body: NodeId,
        capabilities: HashSet<Capability>,
    },

    // Function application
    Call {
        func: NodeId,
        args: Vec<NodeId>,
    },

    // Residual marker
    Rt(NodeId),
    AtResidual { type_: TypeEnv, inner: NodeId },  // @residual sugar

    // Binary/unary operations
    BinaryOp { op: Op, lhs: NodeId, rhs: NodeId },
    UnaryOp { op: Op, operand: NodeId },

    // Type cast
    Cast { type_: TypeEnv, operand: NodeId },

    // Control flow
    If { cond: NodeId, then: NodeId, els: NodeId },
    While { cond: NodeId, body: NodeId },
    For { init: NodeId, cond: NodeId, step: NodeId, body: NodeId },
    ForIn { iter: NodeId, name: Identifier, body: NodeId },
    Match { scrutinee: NodeId, arms: Vec<(Pattern, NodeId)>, default: NodeId },

    // Spawn (structured concurrency)
    Spawn {
        capabilities: HashSet<Capability>,
        body: NodeId,
        ret: TypeEnv,
    },

    // Assertions and debugging
    Assert { cond: NodeId, message: NodeId },
    RtAssert { cond: NodeId, message: NodeId },
    Known(NodeId),
    RtKnown(NodeId),
    ComptimePrint(Expr),
    Todo,
    Unimplemented,

    // Structs, lists, maps, ranges
    Struct { name: Identifier, fields: Vec<(Identifier, NodeId)> },
    List { elements: Vec<NodeId> },
    Map { entries: Vec<(NodeId, NodeId)> },
    Range { start: NodeId, end: NodeId, closed: bool },
    FString { parts: Vec<FStringPartNode> },  // interpolated string
    RawString(String),
    ByteString(Vec<u8>),

    // Field/index access and slicing
    FieldAccess { target: NodeId, field: Identifier },
    Index { target: NodeId, index: NodeId },
    Slice { target: NodeId, range: RangeNode },  // xs[start..end]
    MethodCall { target: NodeId, method: Identifier, args: Vec<NodeId> },

    // Result/Option sugar (desugared, but tracked for diagnostics)
    EarlyReturn { value: NodeId },
    ElseFallback { value: NodeId, fallback: NodeId },

    // Destructuring (irrefutable binding)
    Destructure {
        pattern: Pattern,
        source: NodeId,
        bindings: Vec<(Identifier, NodeId)>,  // bound vars → nodes
    },

    // Handle management
    With { bindings: Vec<WithBindingNode>, body: NodeId },

    // Provider call (external knowledge)
    ProviderCall { provider: Provider, args: Vec<NodeId> },

    // Behavior instance
    BehaviorInstance { behavior: BehaviorRef, type_: TypeEnv },

    // Using clause (explicit behavior selection)
    Using { value: NodeId, behavior: BehaviorRef },

    // RegionError (for spawn failures)
    RegionError(NodeId),  // Err(RegionError) from spawn
}

struct FStringPartNode {
    text: String,
    expr: Option<NodeId>,
}

struct RangeNode {
    start: Option<NodeId>,
    end: Option<NodeId>,
    closed: bool,
}

struct WithBindingNode {
    type_: TypeEnv,
    name: Identifier,
    init: NodeId,
}

/// Pattern in knowledge graph (for destructuring)
pub enum Pattern {
    Wildcard,
    Bind(Identifier),
    Variant { name: Identifier, param: Option<Identifier> },
    Literal(Literal),
    Struct { name: Identifier, fields: Vec<(Identifier, Pattern)> },
}

/// Knowledge state of a node (spec §3)
pub enum KnowledgeState {
    /// Fully reduced to a known value
    Known,
    /// Reducible computation that requires capability authorization
    Effect,
    /// Runtime computation (marked by rt or @residual)
    Residual,
    /// Failed proof, type check, or capability requirement
    Invalid,
}

/// An effect (first-class semantic category)
pub enum Effect {
    Io,
    Provider(Provider),
    ResourceMutation,
    RuntimeForce,
    ConcurrencySpawn,
}

/// Capabilities form a lattice (spec §20)
pub struct Capability {
    kind: CapabilityKind,
    params: Vec<Expr>,  // optional params, e.g., scope=["config/**"]
}

pub enum CapabilityKind {
    Filesystem,
    Git,
    Environment,
    Compute,
    // Future extensibility
}

/// Provenance tracking (spec §11)
pub enum Provenance {
    Source { file: String, span: Span },
    Provider(Provider),
    Residual,
    Inferred,
}

/// Identifier with global uniqueness
pub struct Identifier {
    name: String,
    id: NodeId,  // globally unique
}
```

**KnowledgeGraph operations**:
```rust
impl KnowledgeGraph {
    fn new() -> Self;
    fn add_node(&mut self, kind: NodeKind, type_: TypeEnv, span: Span) -> NodeId;
    fn get_node(&self, id: NodeId) -> &Node;
    fn set_knowledge(&mut self, id: NodeId, state: KnowledgeState);
    fn set_doc_comments(&mut self, id: NodeId, comments: Vec<String>);
    fn merge(&mut self, other: &KnowledgeGraph);
    fn get_entry(&self) -> NodeId;
    fn collect_dependencies(&self, id: NodeId) -> HashSet<NodeId>;
}
```

**Arena allocation**: Use `slotmap` or `generational_arena` for stable NodeIds.

**AST → IR conversion** (high-level):
1. Traverse AST, build nodes in dependency order
2. Resolve parameter defaults → insert Binding nodes
3. Resolve named args → reorder/align with parameter list
4. Insert Discard nodes for `_ = expr`
5. Insert Destructure nodes for irrefutable bindings
6. Insert EarlyReturn / ElseFallback sugar nodes
7. Insert FString construction nodes
8. Insert Range / Slice nodes
9. Track doc comments on declarations

---

### 4.4 `resid-type` — Types, Behaviors, Capabilities

**Responsibility**: Type system, behavior inference, capability checking.

**Type system**:

```rust
/// First-class types (spec §12, §6)
pub enum Type {
    // Primitive types (full parameterized family)
    Bool,
    Int(u32),      // 8, 16, 32, 64, 128, 256, 512
    UInt(u32),     // 8, 16, 32, 64, 128, 256, 512
    Float(u32),    // 16, 32, 64, 128, 256, 512
    Str,
    Bytes,
    Null,
    Void,

    // Pointer-sized aliases
    ISize,
    USize,

    // Nullable
    RegionError,

    // Parametric types
    Option(Type),
    Result(Type, Type),
    List(Type),
    Map(Type, Type),
    Set(Type),

    // User-defined product types
    Struct(Identifier, Vec<(Identifier, Type)>),

    // User-defined sum types
    Enum(Identifier, Vec<SumVariant>),

    // Constrained types
    Constrained(Box<Type>, Constraint),

    // Residual types
    Residual(Box<Type>),

    // Behavior types
    Behavior(BehaviorRef),

    // Handle types
    Handle(Identifier, Lifetime),

    // Function types (for internal use)
    Function { params: Vec<Type>, ret: Type },

    // Source location
    SourceLoc,

    // Ranges (internal type)
    Range { start_type: Box<Type>, end_type: Box<Type>, closed: bool },

    // Slices (internal type)
    Slice { element_type: Box<Type>, range_type: Box<Type> },
}

/// Type constraints
pub struct Constraint {
    expression: Expr,
    provenance: Provenance,
}

/// Behavior reference
pub struct BehaviorRef {
    name: Identifier,
    type_params: Vec<Type>,
}

/// Behavior definition (spec §11)
pub struct BehaviorDef {
    name: Identifier,
    type_params: Vec<Type>,
    body: Expr,
    requirements: Vec<(Identifier, Type)>,
}

/// Conversion helpers (spec §6, §32)
pub enum ConversionHelper {
    I8, I16, I32, I64, I128, I256, I512,
    U8, U16, U32, U64, U128, U256, U512,
    F16, F32, F64, F128, F256, F512,
    ISize,
    USize,
}
```

**Type checking**:

```rust
pub struct TypeChecker {
    graph: &KnowledgeGraph,
    environment: TypeEnv,
    behaviors: HashMap<Identifier, BehaviorDef>,
    conversion_helpers: HashMap<Identifier, ConversionHelper>,
    result_or_option_fn: Option<ReturnType>,  // for value? sugar context
    errors: Vec<TypeError>,
}

impl TypeChecker {
    fn check(&mut self) -> Result<(), Vec<TypeError>>;
    fn check_expression(&mut self, id: NodeId) -> Type;
    fn check_binding(&mut self, name: &Identifier, type_: &Type) -> Result<(), TypeError>;
    fn resolve_behavior(&mut self, behavior: &BehaviorRef) -> Result<NodeId, TypeError>;
    fn check_capabilities(&self, node: &Node) -> Result<(), TypeError>;
    fn check_residual_rules(&self, node: &Node) -> Result<(), TypeError>;
    fn check_result_option_sugar(&self) -> Result<(), TypeError>;
    fn infer_for_in(&mut self, collection: &Type) -> (Type, Identifier, Block);
    fn infer_range(&mut self, start: &Type, end: &Type, closed: bool) -> Type;
    fn infer_slice(&mut self, target: &Type, range: &RangeExpr) -> Type;
    fn infer_fstring_parts(&mut self, parts: &[FStringPart]) -> Type;
}
```

**Behavior inference** (spec §11):

```rust
pub struct BehaviorInferencer {
    graph: &KnowledgeGraph,
    known_behaviors: HashMap<Identifier, BehaviorDef>,
    pending: HashMap<(Identifier, Type), Vec<BehaviorRef>>,
}

impl BehaviorInferencer {
    fn infer(&mut self);
    fn insert_auto_behavior(&mut self, type_: &Type, required: &BehaviorRef);
    fn resolve_ambiguous(&mut self, candidates: Vec<BehaviorRef>) -> Option<BehaviorRef>;
    fn check_residual_behavior_safety(&self) -> Result<(), TypeError>;
}
```

**Capability lattice** (spec §20):

```rust
pub struct CapabilityChecker {
    grants: HashSet<Capability>,
    requirements: HashMap<NodeId, HashSet<Capability>>,
}

impl CapabilityChecker {
    fn is_granted(&self, cap: &Capability) -> bool;
    fn is_subsumed(&self, required: &Capability, grant: &Capability) -> bool;
    fn check_all(&self) -> Result<(), Vec<CapabilityError>>;
    fn revoke(&mut self, cap: &Capability);
}
```

**Conversions** (spec §6):
- `Int` = `Int(64)`, `UInt` = `UInt(64)`, `Float` = `Float(64)`
- `(Int(32))42` → explicit cast node
- `i32(42)` → conversion helper call (stdlib function)
- No implicit numeric conversions

---

### 4.5 `resid-codegen` — LLVM Code Generation

**Responsibility**: Lower the reduced knowledge graph to LLVM IR and emit native binary.

**LLVM wrapper**: Use `inkwell` crate for safe LLVM bindings.

**Code generation strategy**:

```rust
pub struct CodeGenerator {
    context: llvm::Context,
    module: llvm::Module,
    builder: llvm::Builder,
    value_map: HashMap<NodeId, llvm::Value>,
    residual_thunks: HashMap<NodeId, llvm::Function>,
    handle_state: HandleRuntimeState,
    capability_checks: Vec<CapabilityCheck>,
    spawn_runtime: SpawnRuntimeState,  // structured concurrency support
    wide_num_runtime: WideNumRuntimeState,  // software-emulated wide types
}

impl CodeGenerator {
    pub fn generate(graph: &KnowledgeGraph) -> Result<Artifact, CodegenError>;
    fn lower(&mut self) -> llvm::Module;
    fn lower_function(&mut self, func: &FunctionNode) -> llvm::Function;
    fn lower_expression(&mut self, id: NodeId) -> llvm::Value;
    fn lower_residual_thunk(&mut self, id: NodeId) -> llvm::Function;
    fn lower_spawn(&mut self, spawn: &SpawnNode) -> llvm::Value;
    fn emit(&self, output: &Path) -> Result<(), CodegenError>;
}
```

**Type mapping** (Resid → LLVM):

| Resid Type | LLVM Representation |
|---|---|
| Bool | i1 |
| Int(8) | i8, Int(16) | i16, Int(32) | i32, Int(64) | i64 |
| Int(128) | i128 (if available) or two i64s |
| Int(256), Int(512) | Array of i64s + runtime lib functions |
| UInt(8..64) | Same as Int variants, unsigned |
| UInt(128..512) | Same as Int variants |
| Float(16) | half (or i16 with conversion) |
| Float(32) | float |
| Float(64) | double |
| Float(128) | double (fallback) or __float128 via libcall |
| Float(256), Float(512) | Software emulation + runtime lib |
| ISize / USize | pointer-sized integer |
| Str | struct with ptr + len (or String wrapper) |
| Bytes | struct with ptr + len |
| Option(T) | tag + payload union |
| Result(T, E) | tag + payload union |
| List(T), Map(K,V), Set(T) | struct with ptr + len + capacity |
| SourceLoc | struct { file: Str, line: u32, col: u32 } |
| Range | struct { start, end, closed: bool } |
| RegionError | Error type (tagged) |

**Lowering rules** (per knowledge state):

| KnowledgeState | LLVM Code Generation Strategy |
|---|---|
| **Known** | Constant folding / inline instructions. Fully known functions eliminated. |
| **Effect** | Provider dispatch code with capability checks. |
| **Residual** | Generate standalone LLVM function (thunk). |
| **Invalid** | Emit trap/abort instruction. |

**Key lowering details**:

1. **Functions**: Each function becomes an LLVM function. Parameter defaults → default arguments inserted at call sites or as wrapper functions. Named args → reordered at call site.

2. **Residual thunks** (spec §33): Each `rt expr` or `@residual` becomes a first-class LLVM function carrying:
   - The residual computation
   - Provenance metadata
   - Capability requirements (runtime checks)

3. **Handles**: Becomes runtime-resolved pointers. `with` blocks compile to RAII-style cleanup:
   ```llvm
   %h1 = call %HandleType @handle_create(...)
   %h2 = call %HandleType @handle_create(...)
   %result = call %ReturnType @body_func(%h1, %h2)
   call void @handle_release(%h2)  ; reverse-order release
   call void @handle_release(%h1)
   ```

4. **Pattern matching**: Desugared to if-else chains or switch tables during IR phase.

5. **Destructuring**: Desugared to field/index access + binding during IR phase.

6. **Result/Option sugar**: Desugared to if-else with early return during IR phase.

7. **F-strings**: Constructed via runtime lib call `fstring_format(parts...)`.

8. **Ranges & slices**: Constructed via runtime lib calls or LLVM vectors for numeric ranges.

9. **For-in**: Desugared to while loop with iterator protocol or indexed access.

10. **Spawn**: Generates thread/task creation + structured join point:
    ```llvm
    %r = call %ResultType @spawn_task(<caps>, <child_func>)
    ; structured join: wait for child
    %tag = extractvalue %ResultType %r, 0
    %result = select i1 %tag, %ErrPayload, %OkPayload
    ```

11. **Checked arithmetic**: Every arithmetic op wraps a runtime check:
    ```llvm
    %sum = add i64 %a, %b
    %overflow = icmp ugt i64 %sum, %a
    br i1 %overflow, label %overflow_handler, label %continue
    ```

12. **Wide numeric types**: Software emulation via runtime library:
    ```llvm
    ; Int(256) = 4 x i64
    %result = call <256-bit type> @wide_add_int256(%a, %b)
    ; Runtime lib provides: wide_add, wide_mul, wide_cmp, etc.
    ```

13. **#location**: Generates SourceLoc struct with filename + line/col constants.

14. **assert/rt_assert**: Emits condition check + abort on failure (compile-time vs runtime).

15. **main() entry point**:
    ```llvm
    define i32 @main() {
        %result = call i32 @resid_main()
        ret i32 %result
    }
    ```

**Artifacts** (spec §33, §34):
- Native binary: `<name>` (ELF on Linux)
- Residual notes CBOR: `<name>.resid-notes.cbor`

---

### 4.6 `resid-builtin` — Built-in Types and Providers

**Responsibility**: Implement standard library primitives and provider backends in Rust.

**Components**:

```rust
/// Built-in primitive types (Rust implementations)
pub mod types {
    pub struct ResidBool;
    pub struct ResidInt<N>;       // generic over bit width
    pub struct ResidUInt<N>;
    pub struct ResidFloat<N>;
    pub struct ResidStr;          // String-backed
    pub struct ResidBytes;        // Vec<u8>-backed
    pub struct ResidOption<T>;
    pub struct ResidResult<T, E>;
    pub struct ResidList<T>;
    pub struct ResidMap<K, V>;
    pub struct ResidSet<T>;
    pub struct ResidSourceLoc { file: String, line: u32, col: u32 };
    pub struct ResidRange<T>;
    pub struct ResidSlice<T>;
    pub struct ResidRegionError { msg: String };
}

/// Handle implementations
pub mod handles {
    pub struct Buffer { /* Vec<u8> with cursor */ }
    pub struct File { /* std::fs::File wrapper */ }
    // Future: Socket, Arena, Mutex
}

/// Provider backends (spec §32)
pub mod providers {
    pub mod filesystem {
        pub fn open(path: &str, mode: &str) -> Result<File, IoError>;
        pub fn read_all(file: &File) -> Bytes;
        pub fn write_all(file: &File, data: &Bytes);
        pub fn list(path: &str) -> Vec<Str>;
        pub fn metadata(path: &str) -> Stat;
        pub fn close(file: &File);
    }

    pub mod environment {
        pub fn get(key: &str) -> Option<Str>;
        pub fn set(key: &str, value: &str);
    }

    pub mod git {
        pub fn commit() -> Str;
        pub fn status() -> Str;
        pub fn describe() -> Str;
    }
}

/// Core behavior implementations
pub mod behaviors {
    // Eq, Ord, Hash for all numeric types
    pub fn eq_int<N>(a: &ResidInt<N>, b: &ResidInt<N>) -> Bool;
    pub fn ord_int<N>(a: &ResidInt<N>, b: &ResidInt<N>) -> Ordering;
    pub fn hash_int<N>(v: &ResidInt<N>) -> u64;
    // ... for all core types
    pub fn reverse_ord<T: Ord>(a: T, b: T) -> Ordering;
}

/// Conversion helpers (spec §6, §32)
pub mod conversions {
    pub fn i8(v: impl Into<i64>) -> ResidInt<8>;
    pub fn i16(v: impl Into<i64>) -> ResidInt<16>;
    // ... i32, i64, i128, i256, i512
    pub fn u8(v: impl Into<u64>) -> ResidUInt<8>;
    // ... u16, u32, u64, u128, u256, u512
    pub fn f16(v: f64) -> ResidFloat<16>;
    // ... f32, f64, f128, f256, f512
    pub fn isize(v: i64) -> ISize;
    pub fn usize(v: u64) -> USize;
}

/// Checked arithmetic + wrapping + saturating (spec §6, §32)
pub mod arithmetic {
    // Checked (default) — returns Option/Err on overflow
    pub fn checked_add<T>(a: T, b: T) -> Result<T, OverflowError>;
    pub fn checked_sub<T>(a: T, b: T) -> Result<T, OverflowError>;
    pub fn checked_mul<T>(a: T, b: T) -> Result<T, OverflowError>;
    pub fn checked_div<T>(a: T, b: T) -> Result<T, DivByZeroError>;

    // Wrapping
    pub fn wrapping_add<T>(a: T, b: T) -> T;
    pub fn wrapping_mul<T>(a: T, b: T) -> T;
    // ... wrapping_sub, wrapping_div, etc.

    // Saturating
    pub fn saturating_add<T>(a: T, b: T) -> T;
    pub fn saturating_mul<T>(a: T, b: T) -> T;
    // ... saturating_sub, saturating_div, etc.
}

/// Wide numeric runtime library (spec §5, §33)
pub mod wide_num {
    // Int/UInt/Float emulation for >128-bit
    pub fn wide_add_256(a: [u64; 4], b: [u64; 4]) -> [u64; 4];
    pub fn wide_mul_256(a: [u64; 4], b: [u64; 4]) -> [u64; 8];
    pub fn wide_cmp_256(a: [u64; 4], b: [u64; 4]) -> Ordering;
    pub fn wide_add_512(a: [u64; 8], b: [u64; 8]) -> [u64; 8];
    // ... for Float as well
}

/// String interpolation
pub mod strings {
    pub fn fstring_format(parts: &[FStringPart]) -> Str;
}

/// Ranges and slices
pub mod collections {
    pub fn range_new<T: Ord>(start: T, end: T, closed: bool) -> Range<T>;
    pub fn slice_new<T>(slice: &List<T>, range: Range<UInt>) -> Slice<T>;
}

/// Spawn / concurrency runtime
pub mod concurrency {
    pub fn spawn(cap_env: CapEnv, body: fn() -> T) -> Result<T, RegionError>;
    // Scheduler implementation-defined (threads, tasks, pool)
}
```

**Provider linkage**: Each provider function is exposed as an LLVM extern declaration in the generated module. The capability system gates which providers are linked.

---

### 4.7 `resid-build` — Build System

**Responsibility**: Parse `resid.toml`, manage dependencies, profiles, and orchestrate compilation.

**Config types** (spec §35):

```rust
pub struct ResidConfig {
    package: Package,
    capabilities: Capabilities,
    reduction: ReductionConfig,
    target: TargetConfig,
    profile: Profile,
    dependencies: HashMap<String, Dependency>,
}

pub struct Package {
    name: String,
    version: String,
}

pub struct Capabilities {
    grants: Vec<Capability>,
}

pub struct ReductionConfig {
    residual_notes: bool,
    residual_notes_format: ResidNotesFormat,  // cbor
    knowledge_cache: bool,
}

pub struct TargetConfig {
    triple: String,  // e.g., "x86_64-unknown-linux-gnu"
}

pub struct Profile {
    name: ProfileName,  // debug, release, check
    optimization: OptimizationLevel,
}

pub struct Dependency {
    name: String,
    version: String,
    hash: String,       // content-addressed
}
```

**Build orchestration**:

```rust
pub struct BuildSystem {
    config: ResidConfig,
    source_root: PathBuf,
    output_dir: PathBuf,
}

impl BuildSystem {
    pub fn new(config_path: &Path) -> Result<Self, BuildError>;
    pub fn compile(&self) -> Result<Artifact, BuildError>;
    pub fn resolve_dependencies(&mut self) -> Result<(), BuildError>;
    pub fn generate_residual_notes(&self, graph: &KnowledgeGraph) -> Result<(), BuildError>;
}
```

**Build flow**:
1. Parse `resid.toml`
2. Resolve and verify dependencies (hash match, capability grant)
3. Load all `.resid` source files
4. Call compiler pipeline
5. Emit artifacts + optional CBOR sidecar

---

### 4.8 `residc` — CLI Binary

**Responsibility**: User-facing CLI tool, orchestrates the build system.

**Commands**:

```
residc <COMMAND> [OPTIONS]

Commands:
    build       Compile current project (default)
    run         Build and run
    check       Type-check without codegen
    clean       Remove build artifacts
    init        Create new resid project
    fmt         Format source files (canonical formatter)
    notes       Display residual notes (.cbor)
    cache       Manage knowledge cache
    graph       Display knowledge graph (debug)
    why         Query residual provenance ("Why is this residual?")
```

**CLI structure**:

```rust
use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "residc", version, about = "Resid compiler")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
    #[arg(short, long)]
    project: Option<PathBuf>,  // path to resid.toml
}

#[derive(Subcommand)]
enum Commands {
    Build { path: Option<PathBuf> },
    Run { path: Option<PathBuf> },
    Check { path: Option<PathBuf> },
    Clean { path: Option<PathBuf> },
    Init { path: PathBuf },
    Fmt { paths: Vec<PathBuf> },
    Notes { path: PathBuf },
    Cache { command: CacheCommand },
    Graph { path: PathBuf },
    Why { path: PathBuf, node: Option<NodeId> },
}
```

---

### 4.9 Tooling Crates

**`resid-fmt`** — Canonical formatter:
- Indentation-based formatting (configurable width)
- Operator spacing, keyword spacing
- Doc comment preservation
- Deterministic output

**`resid-notes`** — CBOR residual notes viewer:
- Parse `.resid-notes.cbor` files
- Display residual expressions, types, provenance
- Human-readable output

**`resid-cache`** — Knowledge cache inspector:
- Parse `.resid-cache.cbor` files
- Display cached reductions, timestamps
- Clear/flush commands

**`resid-graph`** — Dependency graph emitter:
- Parse knowledge graph from artifacts
- Output DOT format or ASCII art
- Show dependencies, effects, capabilities

**`resid-why`** — Residual provenance query:
- Analyze why an expression is residual
- Trace through reduction rules
- Show: "Expression is residual because: provider call with volatile capability"
- Tooling query, not a language construct

**`lsp-server`** — LSP server:
- Residual status hover
- Capability / knowledge state display
- Doc comment hover
- Exhaustiveness diagnostics for match expressions
- Go to definition, find references
- Diagnostics for shadowing, type errors, capability violations

---

## 5. REDUCTION ENGINE DESIGN (Phase 2)

The reduction engine implements the pure reduction relation Κ ⊢ e → e′ (spec §36).

### 5.1 Reduction State

```rust
pub struct ReductionContext {
    knowledge: KnowledgeStore,
    graph: KnowledgeGraph,
    behaviors: HashMap<Identifier, BehaviorDef>,
    provider_cache: HashMap<ProviderCall, KnownValue>,
    capabilities: HashSet<Capability>,
}
```

### 5.2 Reduction Rules (per spec §36)

| Rule | Description | Example |
|------|-------------|---------|
| **β-reduction** | Function application with known args | `f(2 + 3)` → `f(5)` |
| **Constant folding** | Operators on known literals | `2 + 3` → `5` |
| **Constraint discharge** | Prove constraint holds | `x: Int where x > 0`, x=5 → discharge |
| **Provider substitution** | Replace known non-volatile provider | `environment::get("PATH")` → `"..."` |
| **Behavior insertion** | Auto-insert required behavior | `sort(xs)` → `sort(xs, using = Ord(Int))` |
| **Method desugaring** | `h.m(args)` → `m(h, args)` | `buf.append(data)` → `buffer_append(buf, data)` |
| **Pattern matching** | Reduce on known constructors | `match Some(42) { Some(x) => x }` → `42` |
| **Destructuring** | Irrefutable binding reduction | `Point { x, y } = p` → `x = p.x; y = p.y` |
| **Checked arithmetic** | Overflow → known error or residual | `2147483648_i32 + 1` → overflow |
| **String interpolation** | Known parts → constant string | `f"hello {name}"` if name known → `"hello world"` |
| **Range/slice construction** | Known bounds → constant | `0..10` → Range(0, 10, false) |
| **Result/Option sugar** | `value?` → early return on Err/None | (in Result fn) |
| **Structural identity** | Identity nodes pass through | `x` → `x` |
| **Cast** | `(Type)expr` when type known | `(Int(32))5` → `5` |
| **If/while** | Reduce when condition is known | `if (true) { A } else { B }` → `A` |
| **For-in** | Fully reducible when collection known | `for (Int x in [1,2,3]) { ... }` → inline |

### 5.3 Reduction Algorithm

```rust
impl ReductionContext {
    /// Reduce the entire graph to normal form
    pub fn reduce_all(&mut self) -> Result<(), ReductionError> {
        loop {
            let reduced = self.reduce_once()?;
            if !reduced {
                break;  // Normal form reached
            }
        }
        Ok(())
    }

    /// Try one round of reductions (returns true if any reduction happened)
    pub fn reduce_once(&mut self) -> Result<bool, ReductionError> {
        let mut any_reduced = false;

        for node_id in self.topological_order() {
            match self.reduce_node(node_id)? {
                ReductionResult::Reduced(new_id) => {
                    self.replace_node(node_id, new_id);
                    any_reduced = true;
                }
                ReductionResult::Irreducible => {}
                ReductionResult::Invalid => {
                    self.set_knowledge(node_id, KnowledgeState::Invalid);
                }
            }
        }

        Ok(any_reduced)
    }

    fn reduce_node(&mut self, id: NodeId) -> Result<ReductionResult, ReductionError> {
        match self.get_node(id).kind {
            NodeKind::Literal(_) => Ok(ReductionResult::Irreducible),
            NodeKind::BinaryOp { op, lhs, rhs } => {
                if self.is_known(lhs) && self.is_known(rhs) {
                    let result = self.fold_binary(op, lhs, rhs);
                    Ok(ReductionResult::Reduced(result))
                } else {
                    Ok(ReductionResult::Irreducible)
                }
            }
            NodeKind::Call { func, args } => {
                self.beta_reduce(func, args)
            }
            NodeKind::Rt(inner) => {
                Ok(ReductionResult::Irreducible)
            }
            NodeKind::Range { start, end, closed } => {
                if self.is_known(start) && self.is_known(end) {
                    Ok(ReductionResult::Reduced(self.make_range(start, end, closed)))
                } else {
                    Ok(ReductionResult::Irreducible)
                }
            }
            // ... other rules
        }
    }
}

pub enum ReductionResult {
    Reduced(NodeId),
    Irreducible,
    Invalid,
}
```

### 5.4 Normal Form

After reduction completes:
- **Known** nodes: fully reduced constants or irreducible expressions
- **Residual** nodes: `rt`/`@residual`-marked computations
- **Effect** nodes: require runtime authorization
- **Invalid** nodes: compilation errors

---

## 6. IMPLEMENTATION PHASES

### Phase 1: Lexer, Parser, AST

**Deliverables**: Working lexer and parser that can parse all spec §29 syntax.

**Tasks**:
1. [ ] Setup workspace with all crates
2. [ ] Implement `resid-lexer` (TokenStream, token types, span tracking)
3. [ ] Implement `resid-parser` (AST node types)
4. [ ] Implement expression parsing with precedence climbing (§27)
5. [ ] Implement parameter defaults, named args parsing
6. [ ] Implement type/function/behavior/import parsing
7. [ ] Implement spawn expression, for-in parsing
8. [ ] Implement pattern matching & destructuring parsing
9. [ ] Implement f-string, raw string, byte string parsing
10. [ ] Implement ranges, slices, #location parsing
11. [ ] Implement if-let, while-let parsing
12. [ ] Implement `@residual`, assertions, value? sugar parsing
13. [ ] Implement doc comment collection
14. [ ] Write tests for all syntax constructs
15. [ ] Implement error recovery (skip to next statement)

**Estimated effort**: 3-4 weeks

**Status**: ✅ Complete. 17 tests (7 lexer + 10 parser) pass.

All spec §29 syntax constructs are lexed and parsed. The `residc` driver binary
lexes + parses source files and reports diagnostics (exit 0 on success, 1 on errors).
Top-level grammar is imports + types + functions.

---

### Phase 2: Knowledge Graph IR + Reduction

**Deliverables**: Knowledge graph data structure, reduction engine with all rules.

**Tasks**:
1. [ ] Design and implement `resid-ir` crate (KnowledgeGraph, Node, NodeKind)
2. [ ] Implement AST → Knowledge Graph conversion
3. [ ] Implement identifier uniqueness checking (no shadowing)
4. [ ] Implement discard `_ = expr` binding
5. [ ] Implement parameter default resolution
6. [ ] Implement named args resolution
7. [ ] Implement destructuring IR nodes
8. [ ] Implement range, slice, f-string IR nodes
9. [ ] Implement Result/Option sugar IR nodes
10. [ ] Implement location (#location) IR node
11. [ ] Implement reduction context and fixed-point loop
12. [ ] Implement β-reduction
13. [ ] Implement constant folding
14. [ ] Implement constraint discharge
15. [ ] Implement method desugaring
16. [ ] Implement pattern matching reduction
17. [ ] Implement destructuring reduction
18. [ ] Implement checked arithmetic reduction (overflow detection)
19. [ ] Implement string interpolation reduction
20. [ ] Implement range/slice construction reduction
21. [ ] Implement provider substitution (non-volatile)
22. [ ] Implement behavior insertion
23. [ ] Write tests for each reduction rule

**Estimated effort**: 4-5 weeks

---

### Phase 3: Types, Behaviors, Capabilities

**Deliverables**: Type checker, behavior inferencer, capability checker.

**Tasks**:
1. [ ] Implement `resid-type` crate (Type enum, TypeChecker)
2. [ ] Implement parameterized numeric types (Int(8)..Int(512), Float(16)..Float(512))
3. [ ] Implement ISize/USize handling (target-dependent width)
4. [ ] Implement type checking for all expression forms
5. [ ] Implement conversion helper resolution (i32(42), usize(len), etc.)
6. [ ] Implement type constraint checking (where clauses)
7. [ ] Implement behavior inference (auto-insert)
8. [ ] Implement behavior ambiguity resolution (`using =`)
9. [ ] Implement residual-type rules R1-R5
10. [ ] Implement capability lattice and checks
11. [ ] Implement capability revocation tracking
12. [ ] Implement Result/Option sugar context checking
13. [ ] Implement for-in type inference
14. [ ] Implement range/slice type inference
15. [ ] Implement SourceLoc type
16. [ ] Write tests for type errors, behavior inference, capability violations

**Estimated effort**: 4-5 weeks

---

### Phase 4: LLVM Code Generation ✅ Complete

**Status**: `residc <file> emit-ir` runs the full pipeline: lex → parse → type-check →
LLVM IR emission (module verified before output). `residc <file> build|run` links a
native binary via clang + `crates/residc/resid_rt.c`, propagating exit codes.

**Coverage**:
- Functions with typed parameters and return values
- Immutable bindings (`Int x = expr;`) with declared-type coercion
- Integer arithmetic (`+` `-` `*` `/` `%` `<<` `>>` `&` `|` `^`) with spec §6.1
  mixed-width widening (e.g. Int64 + Int64 → Int128)
- Signed/unsigned widening and truncation back to declared types on `return`
- Comparison operators (`==` `!=` `<` `<=` `>` `>=`) producing Bool (i1)
- Logical connectives (`&&` `||`) on Bool operands; unary operators (`-` `!` `~`)
- Type casts `(T) expr`; `if`-expressions with phi joins (then/else blocks, merge)
- Function calls (direct, with named args resolved); extern built-ins
  (`print`/`println` from `resid-type::builtin_signatures`)
- String literals, f-strings, raw strings (global constants) and string-concat folding
- Boxed composite values: `List`/`Struct`/`Option` via `resid_box_*` runtime calls,
  `match` with tag checks + phi joins, struct construction + field access
- **Pattern-based destructuring** (`Point { x, y } = p`) via `bind_pattern_vars`
- **Discard** (`_ = expr`) — type-checked and lowered, value dropped
- **`while` loops** with `break`/`continue` — condition block, body block, exit block,
  loop-stack context for break/continue targets

**Coverage (deferred)**: structured spawn, `value?` sugar, provider linkage,
checked/wrapping/saturating arithmetic, C-style `for` loops, map literals.

**Coverage (next)**: float arithmetic, for-in loops, `comptime_print`,
`@residual`, the assertion family (`assert`/`known`/`rt_known`/`todo`/
`unimplemented`), range/slice notation (for-in over numeric ranges, `0..n`
half-open and `0..=n` inclusive), and if-let / while-let destructuring
(`if (Some(x) = opt)`, `while (PAT = source)`) are implemented.

**Estimated effort**: 3-4 weeks

**Deliverables**: Working LLVM backend that produces native binaries.

**Tasks**:
1. [ ] Implement `resid-codegen` crate with inkwell
2. [ ] Implement LLVM context/module/builder setup
3. [ ] Implement type mapping (Resid types → LLVM types, incl. wide types)
4. [ ] Implement function lowering (defaults, named args)
5. [ ] Implement expression lowering (known → inline, residual → thunk)
6. [ ] Implement residual thunk generation
7. [ ] Implement control flow lowering (if/while/for/for-in/match)
8. [ ] Implement destructuring lowering
9. [ ] Implement handle lowering (with, reverse-order release)
10. [ ] Implement provider extern linkage
11. [ ] Implement main() entry point generation
12. [ ] Implement checked arithmetic lowering (overflow checks)
13. [ ] Implement wide numeric type lowering (software emulation)
14. [ ] Implement Range/Slice lowering
15. [ ] Implement f-string lowering
16. [ ] Implement #location lowering
17. [ ] Implement spawn lowering (structured concurrency)
18. [ ] Implement assertion lowering (assert, rt_assert, known, rt_known)
19. [ ] Implement Result/Option sugar lowering
20. [ ] Implement binary emission
21. [ ] Implement CBOR residual notes generation (spec §34)
22. [ ] Write tests for code generation output

**Estimated effort**: 5-6 weeks

---

### Phase 5: Standard Library + Build System

**Deliverables**: Working resid.toml build system, stdlib in Rust.

**Tasks**:
1. [ ] Implement `resid-build` crate (resid.toml parsing, build orchestration)
2. [ ] Implement dependency resolution and hash verification
3. [ ] Implement profile support (debug, release, check)
4. [ ] Implement `residc` CLI (clap-based)
5. [ ] Implement `resid-builtin` crate
6. [ ] Implement primitive type implementations
7. [ ] Implement full numeric family (Int(8)..Int(512), UInt, Float, ISize, USize)
8. [ ] Implement core collections (Option, Result, List, Map, Set)
9. [ ] Implement core behaviors (Eq, Ord, Hash, Reverse)
10. [ ] Implement conversion helpers (i8..i512, u8..u512, f16..f512, isize, usize)
11. [ ] Implement checked + wrapping + saturating arithmetic
12. [ ] Implement provider backends (filesystem, environment, git)
13. [ ] Implement handle types (Buffer, File)
14. [ ] Implement SourceLoc type
15. [ ] Implement Range, Slice, FString runtime support
16. [ ] Implement Spawn/RegionError runtime support
17. [ ] Implement wide numeric runtime library
18. [ ] Write integration tests with resid programs

**Estimated effort**: 4-5 weeks

---

### Phase 6: Tooling, Bootstrap

**Deliverables**: Tooling suite, bootstrap complete.

**Tasks**:
1. [ ] Implement `resid-fmt` (canonical formatter)
2. [ ] Implement `resid-notes` (CBOR residual notes viewer)
3. [ ] Implement `resid-cache` (knowledge cache inspector)
4. [ ] Implement `resid-graph` (dependency graph emitter)
5. [ ] Implement `resid-why` (residual provenance query)
6. [ ] Implement LSP server (residual status, doc hover, diagnostics, exhaustiveness)
7. [ ] Implement knowledge cache serialization (CBOR)
8. [ ] Implement incremental compilation support
9. [ ] Write example programs in Resid
10. [ ] Document compiler architecture
11. [ ] Bootstrap: rewrite critical stdlib parts in Resid
12. [ ] Conformance test suite

**Estimated effort**: 4-5 weeks

---

## 7. ERROR MODEL (spec §9, §24)

- **Compile-time errors**: Shadowing, type mismatch, capability violation, invalid constraints, unrefutable pattern at binding site → hard error, compilation fails
- **Runtime errors (top-level)**: Residual force failure, unwrap failure → process abort
- **Runtime errors (concurrent)**: Child failure → Err(RegionError) to parent (process NOT aborted)
- **Invalid nodes**: Failed proofs → KnowledgeState::Invalid → LLVM trap instruction

Error reporting:
```
error[E0001]: identifier `x` already bound
  ┌─ src/main.resid:12:5
  │
12 │     Int x = 5;
  │         ^ previously bound here

error[E0002]: residual expression in pure context
  ┌─ src/main.resid:15:10
  │
15 │     Int x = rt read_file("config.toml");
  │          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ cannot be reduced

error[E0003]: unrefutable pattern at binding site
  ┌─ src/main.resid:20:3
  │
20 │     Some(x) = opt;
  │     ^^^^^^^^ pattern is refutable; use if-let instead
```

---

## 8. CBOR ARTIFACTS (spec §34)

**Residual Notes** (`<artifact>.resid-notes.cbor`):
```cbor
// Top-level: ResidualNotes
[
    [
        node_id: u64,
        expression: "resid_expr_string",
        type: "Int",
        provenance: { file: "...", line: 42, col: 10 },
        capabilities: ["filesystem"],
        effects: ["provider(filesystem)"],
    ],
]
```

**Knowledge Cache** (`<project>.resid-cache.cbor`):
```cbor
[
    {
        source_hash: "sha256:...",
        node_id: u64,
        reduced_value: "...",
        timestamp: u64,
    }
]
```

---

## 9. RISK MITIGATION

| Risk | Mitigation |
|------|------------|
| Knowledge graph complexity | Start with minimal NodeKind set, expand iteratively |
| LLVM integration difficulty | inkwell provides safe wrappers, test incrementally |
| Behavior inference non-determinism | Define strict priority order for behavior selection |
| Residual propagation complexity | Implement residual rules R1-R5 incrementally with tests |
| Capability lattice soundness | Formalize lattice operations, test thoroughly |
| Performance of fixed-point reduction | Topological sort + incremental updates, cache results |
| Wide numeric type performance | Software emulation is slower but correct; optimize later |
| Spawn concurrency complexity | One OS thread per spawn (spec §19); task pool deferred |
| Float(16) target compatibility | LLVM half primary, f32 software failover |
| Float(128) libcall availability | `__float128` libcall primary, software failover |
| Content-addressed caching deferred | Per-file hash cache; per-node in future |

---

## 10. CONFORMANCE CHECKLIST (spec §39)

Before considering the compiler complete:

- [ ] Pure reduction relation implemented (spec §36)
- [ ] Residual-machine semantics correct (spec §9)
- [ ] Residual-type rules R1-R5 enforced (spec §12)
- [ ] CBOR schemas implemented (spec §34)
- [ ] Capability checks working (spec §20)
- [ ] Absolute identifier uniqueness enforced (spec §7)
- [ ] Behavior inference rules correct (spec §11)
- [ ] Method desugaring implemented (spec §16)
- [ ] Pattern matching works (spec §13)
- [ ] Destructuring works (spec §13)
- [x] if-let/while-let works (spec §13)
- [ ] Visibility rules enforced (spec §21)
- [ ] Structured spawn semantics correct (spec §19)
- [ ] Full primitive numeric set implemented (spec §6, §32)
- [ ] Checked arithmetic defaults working (spec §6)
- [x] For-in iteration works (spec §18, §29)
- [ ] Ranges and slicing work (spec §15)
- [ ] known/rt_known work (spec §9, §24)
- [ ] comptime_print works (spec §24)
- [ ] Raw/byte strings work (spec §14)
- [ ] #location works (spec §25)
- [ ] Discard binding works (spec §7)
- [ ] Default parameters work (spec §8)
- [ ] Named arguments work (spec §8)
- [ ] @residual sugar works (spec §9)
- [ ] value? / value else {} sugar works (spec §23)
- [ ] Failure model correct: abort at top-level, Err(RegionError) in concurrent regions (spec §9)

---

## 11. CURRENT STATUS

| Phase | Status | Notes |
|-------|--------|-------|
| 1. Lexer, Parser, AST | ✅ Complete | `resid-lexer` (7) + `resid-parser` (14) pass. Ranges parse as `ExprKind::Range`; `if (PAT = expr)` / `while (PAT = expr)` detect a depth-0 binding `=` and parse as `IfLet`/`WhileLet`. |
| 2. Knowledge Graph IR | Partial | `resid-ir`: implements spec §6 primitive numeric types, mixed-width widening, list/rangetype member types (41 tests). |
| 3. Types, Behaviors | Partial | `resid-type`: 44 tests — literal inference, widening, signed/unsigned mixing, bitwise/float rejection, cast, if, `@residual`, while, RT, built-in extern signatures, `Str + Str`, `check_program`, Step 1 (lists, structs, options, pattern matching including refutable-pattern hard errors), assertion/debug expressions (`assert`/`rt_assert` cond must be Bool, message Str; `known`/`rt_known` pass-through), ranges (`Range(Elem)` from numeric bounds; for-in over a Range requires the declared type match the element type), and if-let/while-let (`bind_pattern` against the source type; vars scoped to the then/body block). |
| 4. LLVM Code Generation | ✅ Runnable binaries | `resid-codegen` (11 tests) + `residc` (9 e2e): functions, arithmetic, casts, calls, bool, `if`-expressions with phi joins, `while` loops with `break`/`continue` and loop-stack context, `for-in` over lists, boxed `List`/`Struct`/`Option` via `resid_box_*`, `match` tag-check + phi joins, struct field access, pattern destructuring, `_ = expr` discard, `comptime_print` (fires at compile time, dropped from runtime), `@residual Type y = expr`, assertions (`assert`/`rt_assert` → `resid_abort` on failure; `known`/`rt_known` static/runtime checks; `todo`/`unimplemented` trap), if-let/while-let (`pattern_match_test` compares the runtime tag via `resid_box_tag`; bindings scoped to the then/body block). Range `for-in` (`0..n` half-open, `0..=n` inclusive) lowers to a scalar i64 counter via `slt`/`sle`, with bounds widened/truncated to the declared width. Runtime value formatting: `IntToString` (Int8–Int64), `UIntToString`, `FloatToString` (Float16/32/64), `BoolToString`, `ToString` (List/Struct/Option), with numeric widening at call sites, Bool↔i8 C ABI, and scalar box runtime support. `residc <f> build [-o out]` produces a native binary via clang + `resid_rt.c`; `run` builds and executes with exit-code propagation. |
| 5. Stdlib, Build System | Partial | `resid-builtin`/`resid-build` stubs; compile clean. |
| 6. Tooling, Bootstrap | Stub | `tools/*` single-line stubs; they build. |

Build/test notes:
- Full `cargo build` and `cargo test --workspace` succeed against system LLVM 22
  (inkwell `0.9` with `llvm22-1`; no env var needed).
- `residc <file.resid>` runs the lexer + parser and prints diagnostics; exit 0 on
  success, 1 on parse errors.
- `residc <file.resid> emit-ir` runs the full pipeline (lex → parse → type check → LLVM IR)
  and prints the IR, verifying the module before output.
  Type errors (undefined vars, signed/unsigned mixing) are reported with file:line:col.
- `residc <file.resid> build [-o <out>]` compiles to a native binary via clang + the
  bootstrap runtime (`crates/residc/resid_rt.c`); `run` builds to a temp dir and executes
  it, propagating the exit code (including POSIX signal exits as 128+signal).
- **126 tests total**: lexer 7, parser 14, resid-ir 41, resid-type 44, resid-codegen 11,
  residc 9 (e2e). Destructuring, `_ = expr` discard,
  `if`-expressions with phi joins, `while` and range `for-in` loops with
  `break`/`continue`, `for-in` over boxed lists, `comptime_print` (compile-time
  evidence side effect), `@residual Type y = expr`, the assertion family
  (`assert`/`rt_assert`/`known`/`rt_known`/`todo`/`unimplemented`), and
  if-let/while-let all type-check
  and lower end-to-end: `residc <f> run` binds
  pattern variables from a boxed struct, discards values, prints at compile time,
  aborts on failed asserts, and runs control-flow statements.
- **Self-host roadmap** (spec §39 Phase 3): next frontiers are data structures
  (List/Option/struct + pattern matching) and runtime value formatting (numeric→Str) so a
  Resid lexer/parser can be written in Resid; then the compiler pipeline itself.

---

## 12. OPEN QUESTIONS

All resolved in Resid 3.0. See `resid_specification.txt`.

### Resolved

1. ~~**Float(16)**~~ → **RESOLVED**: LLVM half (i16, IEEE 754 binary16). Failover to software-emulated via f32 conversion on targets lacking native half support.

2. ~~**Float(128/256/512)**~~ → **RESOLVED**: Float(128) → `__float128` libcall with software failover. Float(256/512) → software emulation via `[u64; N]` + runtime lib.

3. ~~**Provider volatility**~~ → **RESOLVED**: All three providers (`filesystem`, `environment`, `git`) are volatile. Cannot be constant-folded at compile time.

4. ~~**Spawn scheduler**~~ → **RESOLVED**: One OS thread per spawn. Structured join via thread join. Task pools deferred.

5. ~~**Doc comment storage**~~ → **RESOLVED**: `Vec<String>` per declaration. Flows into residual notes CBOR and LSP hover.

6. ~~**Incremental recompilation**~~ → **RESOLVED**: Cache per source file hash. Content-addressed per-node caching tracked as future planning.

---

*Last updated: 2026-08-08*
