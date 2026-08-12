# Resid Compiler v3.0 — Implementation Plan

**Specification**: `resid_specification.txt` v3.0 (Production Ready)
**Target**: Rust stable + LLVM (inkwell)
**Workspace**: Monorepo, Cargo workspace
**Stdlib**: Rust first, later move to Resid
**Wide numeric types**: Software emulate via arrays + runtime lib
**Interpreter**: None — direct LLVM

---

## 1. OVERVIEW

Resid = eager compile-time lang. Compiler job: **max authorized reduction of first-class knowledge**. Program = knowledge graph (enriched DAG). Reduction happens eager, compile time. Only irreducible computation goes residual, enters runtime via `rt`.

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

**Job**: turn `.resid` source text into token stream.

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
- `"hello\n"` — regular string, escapes processed
- `f"hello {name}, version {ver}"` — f-string, interpolation points as sub-tokens
- `r"C:\path\file"` — raw string, no escape processing
- `b"bytes"` — byte string, yields Bytes type

**Build**: recursive descent, char-by-char scan, span tracking. No deps.

---

### 4.2 `resid-parser` — Parsing

**Job**: turn token stream into AST per EBNF in spec §31.

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

**Parser shape**: recursive descent, precedence climbing for ops.

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

**Param defaults + named args**:
- Params parsed as `type name [ = default_expr ]`
- Call args: `f(a, b = 2, c = 3)` → store as `Vec<(Option<Id>, Expr)>`
- Named args resolved against param list at semantic analysis

---

### 4.3 `resid-ir` — Knowledge Graph IR

**This is compiler's heart.** Knowledge graph = enriched expression DAG.

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

**KnowledgeGraph ops**:
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

**Arena alloc**: use `slotmap` or `generational_arena` for stable NodeIds.

**AST → IR conversion** (high level):
1. Walk AST, build nodes in dependency order
2. Resolve param defaults → insert Binding nodes
3. Resolve named args → reorder/align with param list
4. Insert Discard nodes for `_ = expr`
5. Insert Destructure nodes for irrefutable bindings
6. Insert EarlyReturn / ElseFallback sugar nodes
7. Insert FString construction nodes
8. Insert Range / Slice nodes
9. Track doc comments on declarations

---

### 4.4 `resid-type` — Types, Behaviors, Capabilities

**Job**: type system, behavior inference, capability checking.

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

**Job**: lower reduced knowledge graph to LLVM IR, emit native binary.

**LLVM wrapper**: `inkwell` crate for safe LLVM bindings.

**Codegen strategy**:

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

**Lowering rules** (by knowledge state):

| KnowledgeState | LLVM Codegen Strategy |
|---|---|
| **Known** | Constant fold / inline. Fully known fns eliminated. |
| **Effect** | Provider dispatch code + capability checks. |
| **Residual** | Gen standalone LLVM function (thunk). |
| **Invalid** | Emit trap/abort instruction. |

**Key lowering details**:

1. **Functions**: each fn → LLVM function. Param defaults → inserted at call sites or as wrapper fns. Named args → reordered at call site.

2. **Residual thunks** (spec §33): each `rt expr` or `@residual` → first-class LLVM fn carrying:
   - The residual computation
   - Provenance metadata
   - Capability requirements (runtime checks)

3. **Handles**: become runtime-resolved pointers. `with` blocks compile to RAII-style cleanup:
   ```llvm
   %h1 = call %HandleType @handle_create(...)
   %h2 = call %HandleType @handle_create(...)
   %result = call %ReturnType @body_func(%h1, %h2)
   call void @handle_release(%h2)  ; reverse-order release
   call void @handle_release(%h1)
   ```

4. **Pattern matching**: desugared to if-else chains or switch tables at IR phase.

5. **Destructuring**: desugared to field/index access + binding at IR phase.

6. **Result/Option sugar**: desugared to if-else w/ early return at IR phase.

7. **F-strings**: built via runtime lib call `fstring_format(parts...)`.

8. **Ranges & slices**: built via runtime lib calls or LLVM vectors for numeric ranges.

9. **For-in**: desugared to while loop w/ iterator protocol or indexed access.

10. **Spawn**: gens thread/task creation + structured join point:
    ```llvm
    %r = call %ResultType @spawn_task(<caps>, <child_func>)
    ; structured join: wait for child
    %tag = extractvalue %ResultType %r, 0
    %result = select i1 %tag, %ErrPayload, %OkPayload
    ```

11. **Checked arithmetic**: every arithmetic op wraps a runtime check:
    ```llvm
    %sum = add i64 %a, %b
    %overflow = icmp ugt i64 %sum, %a
    br i1 %overflow, label %overflow_handler, label %continue
    ```

12. **Wide numeric types**: software emulate via runtime lib:
    ```llvm
    ; Int(256) = 4 x i64
    %result = call <256-bit type> @wide_add_int256(%a, %b)
    ; Runtime lib provides: wide_add, wide_mul, wide_cmp, etc.
    ```

13. **#location**: gens SourceLoc struct w/ filename + line/col constants.

14. **assert/rt_assert**: emits condition check + abort on failure (compile-time vs runtime).

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

**Job**: implement stdlib primitives + provider backends in Rust.

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

**Provider linkage**: each provider fn exposed as LLVM extern decl in gen'd module. Capability system gates which providers get linked.

---

### 4.7 `resid-build` — Build System

**Job**: parse `resid.toml`, manage deps, profiles, orchestrate compile.

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
2. Resolve + verify deps (hash match, capability grant)
3. Load all `.resid` source files
4. Call compiler pipeline
5. Emit artifacts + optional CBOR sidecar

---

### 4.8 `residc` — CLI Binary

**Job**: user-facing CLI tool, orchestrates build system.

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

**`resid-fmt`** — canonical formatter:
- Indentation-based fmt (configurable width)
- Operator/keyword spacing
- Doc comment preserve
- Deterministic output

**`resid-notes`** — CBOR residual notes viewer:
- Parse `.resid-notes.cbor` files
- Show residual exprs, types, provenance
- Human-readable output

**`resid-cache`** — knowledge cache inspector:
- Parse `.resid-cache.cbor` files
- Show cached reductions, timestamps
- Clear/flush commands

**`resid-graph`** — dependency graph emitter:
- Parse knowledge graph from artifacts
- Output DOT format or ASCII art
- Show deps, effects, capabilities

**`resid-why`** — residual provenance query:
- Analyze why an expr is residual
- Trace through reduction rules
- Show: "Expression is residual because: provider call with volatile capability"
- Tooling query, not a lang construct

**`lsp-server`** — LSP server:
- Residual status hover
- Capability / knowledge state display
- Doc comment hover
- Exhaustiveness diagnostics for match exprs
- Go to definition, find references
- Diagnostics for shadowing, type errors, capability violations

---

## 5. REDUCTION ENGINE DESIGN (Phase 2)

Reduction engine implements pure reduction relation Κ ⊢ e → e′ (spec §36).

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

After reduction done:
- **Known** nodes: fully reduced constants or irreducible exprs
- **Residual** nodes: `rt`/`@residual`-marked computations
- **Effect** nodes: need runtime authorization
- **Invalid** nodes: compile errors

---

## 6. IMPLEMENTATION PHASES

### Phase 1: Lexer, Parser, AST

**Deliverables**: working lexer + parser, parses all spec §29 syntax.

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

**Est effort**: 3-4 weeks

**Status**: ✅ Done. 17 tests (7 lexer + 10 parser) pass.

All spec §29 syntax constructs lexed + parsed. `residc` driver binary
lexes + parses source files, reports diagnostics (exit 0 on success, 1 on errors).
Top-level grammar = imports + types + functions.

---

### Phase 2: Knowledge Graph IR + Reduction

**Deliverables**: knowledge graph data structure, reduction engine w/ all rules.

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

**Est effort**: 4-5 weeks

---

### Phase 3: Types, Behaviors, Capabilities

**Deliverables**: type checker, behavior inferencer, capability checker.

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

**Est effort**: 4-5 weeks

---

### Phase 4: LLVM Code Generation ✅ Complete

**Status**: `residc <file> emit-ir` runs full pipeline: lex → parse → type-check →
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
C-style `for` loops, map literals.

**Coverage (next)**: float arithmetic, for-in loops, `comptime_print`,
`@residual`, the assertion family (`assert`/`known`/`rt_known`/`todo`/
`unimplemented`), range/slice notation (for-in over numeric ranges, `0..n`
half-open and `0..=n` inclusive), and if-let / while-let destructuring
(`if (Some(x) = opt)`, `while (PAT = source)`) are implemented.

**Est effort**: 3-4 weeks

**Deliverables**: working LLVM backend producing native binaries.

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

**Est effort**: 5-6 weeks

---

### Phase 5: Standard Library + Build System

**Deliverables**: working resid.toml build system, stdlib in Rust.

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
11. [x] Implement checked + wrapping + saturating arithmetic
12. [ ] Implement provider backends (filesystem, environment, git)
13. [ ] Implement handle types (Buffer, File)
14. [ ] Implement SourceLoc type
15. [ ] Implement Range, Slice, FString runtime support
16. [ ] Implement Spawn/RegionError runtime support
17. [ ] Implement wide numeric runtime library
18. [ ] Write integration tests with resid programs

**Est effort**: 4-5 weeks

---

### Phase 6: Tooling, Bootstrap

**Deliverables**: tooling suite, bootstrap done.

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

**Est effort**: 4-5 weeks

---

## 7. ERROR MODEL (spec §9, §24)

- **Compile-time errors**: shadowing, type mismatch, capability violation, invalid constraints, unrefutable pattern at binding site → hard error, compile fails
- **Runtime errors (top-level)**: residual force failure, unwrap failure → process abort
- **Runtime errors (concurrent)**: child failure → Err(RegionError) to parent (process NOT aborted)
- **Invalid nodes**: failed proofs → KnowledgeState::Invalid → LLVM trap instruction

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
| Knowledge graph complexity | Start minimal NodeKind set, expand as we go |
| LLVM integration difficulty | inkwell gives safe wrappers, test incrementally |
| Behavior inference non-determinism | Define strict priority order for behavior pick |
| Residual propagation complexity | Build residual rules R1-R5 incrementally w/ tests |
| Capability lattice soundness | Formalize lattice ops, test thoroughly |
| Performance of fixed-point reduction | Topo sort + incremental updates, cache results |
| Wide numeric type performance | Software emulate slower but correct; optimize later |
| Spawn concurrency complexity | One OS thread per spawn (spec §19); task pool deferred |
| Float(16) target compatibility | LLVM half primary, f32 software failover |
| Float(128) libcall availability | `__float128` libcall primary, software failover |
| Content-addressed caching deferred | Per-file hash cache; per-node in future |

---

## 10. CONFORMANCE CHECKLIST (spec §39)

Before calling compiler done:

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
| 1. Lexer, Parser, AST | ✅ Complete | `resid-lexer` (13) + `resid-parser` (83) pass. Ranges parse as `ExprKind::Range`; `if (PAT = expr)` / `while (PAT = expr)` detect a depth-0 binding `=` and parse as `IfLet`/`WhileLet`. Slice syntax (`xs[1..4]`, `xs[..4]`, `xs[1..]`, `xs[..]`, `xs[0..=3]`) parses as `ExprKind::Slice` — the start bound is parsed at a precedence above the range operator so `1..4` isn't greedily consumed. Provider call syntax: `filesystem.verb(args)`, `environment.verb(args)`, `git.verb(args)` parse as `ExprKind::ProviderCall { provider, verb, args }` (trusted provider names: filesystem, environment, git). Method call syntax: `obj.method(args)` → `ExprKind::MethodCall { target, method, args }`. Field access: `obj.field` → `ExprKind::FieldAccess { target, field }`. C-style casts `(Int(32))x` parse via a `paren_is_cast` lookahead; named call args `add(a = 1, b = 2)`; raw/byte strings map to `RawString`/`ByteString`; `_ = expr;` → `StmtKind::Discard`; bare `{ … }` block statements (a `{` not followed by `ident :` is a block, not a struct/map literal); type defs require the spec `type Point = { … };` form.
| 2. Knowledge Graph IR | Partial | `resid-ir`: implements spec §6 primitive numeric types, mixed-width widening, list/rangetype member types (41 tests). |
| 3. Types, Behaviors | Partial | `resid-type`: 137 tests — literal inference, widening, signed/unsigned mixing, bitwise/float rejection, cast, if, `@residual`, while, RT, built-in extern signatures, `Str + Str`, `check_program`, `ListToString` (List(Int/UInt/Float) → Str), Step 1 (lists, structs, options, pattern matching including refutable-pattern hard errors), assertion/debug expressions (`assert`/`rt_assert` cond must be Bool, message Str; `known`/`rt_known` pass-through), ranges (`Range(Elem)` from numeric bounds; for-in over a Range requires the declared type match the element type), if-let/while-let (`bind_pattern` against the source type; vars scoped to the then/body block), byte strings (`b"..."` → `Bytes`), f-string interpolation (each interpolated expr is inferred/validated; the f-string is `Str`), and `#location` → `SourceLoc` with `file`/`line`/`col` field access (unknown fields rejected), provider type checking (unknown providers rejected, unknown verbs rejected, arg count mismatches rejected, arg type mismatches rejected, method calls on value types rejected, provider calls allowed inside RT expressions). Numeric overload resolution (`IntToString`/`UIntToString`/`FloatToString`/`BoolToString`/`ToString`) and numeric widening at call sites. The type checker — not the parser — rejects undefined variables (`check_program_undefined_var`).
| 4. LLVM Code Generation | ✅ Runnable binaries | `resid-codegen` (111 tests) + `residc` (13 e2e): functions, arithmetic, casts, calls, bool, `if`-expressions with phi joins, `while` loops with `break`/`continue` and loop-stack context, `for-in` over lists, boxed `List`/`Struct`/`Option` via `resid_box_*`, `match` tag-check + phi joins, struct field access, pattern destructuring, `_ = expr` discard, `comptime_print` (fires at compile time, dropped from runtime), `@residual Type y = expr`, assertions (`assert`/`rt_assert` → `resid_abort` on failure; `known`/`rt_known` static/runtime checks; `todo`/`unimplemented` trap), if-let/while-let (`pattern_match_test` compares the runtime tag via `resid_box_tag`; bindings scoped to the then/body block). Range `for-in` (`0..n` half-open, `0..=n` inclusive) lowers to a scalar i64 counter via `slt`/`sle`, with bounds widened/truncated to the declared width. Range/slice construction lower to `resid_range_new` / `resid_slice_new` (boxed, partial-open `..n`, `n..`, `..` resolve bounds via the list length). Runtime value formatting: `IntToString` (Int8–Int64), `UIntToString`, `FloatToString` (Float16/32/64), `BoolToString`, `ToString` (List/Struct/Option), with numeric widening at call sites, Bool↔i8 C ABI, and scalar box runtime support. Raw strings (`r"..."`) lower as `Str` globals; byte strings (`b"..."`) lower as constant global byte arrays (`Bytes`, no NUL terminator); `#location` boxes a `SourceLoc { file, line, col }` from the current span with field access via the boxed-slot runtime. F-string interpolation (spec §14) stringifies interpolated values (`Str` passthrough, `*ToString` helpers for numerics/bools, `ToString` for composites) and stitches them with `resid_str_concat`; pure-text f-strings fold to a constant. Runtime `Str + Str` with a non-constant operand concatenates via `resid_str_concat`. `residc <f> build [-o out]` produces a native binary via clang + `resid_rt.c`; `run` builds and executes with exit-code propagation. |
| 5. Stdlib, Build System | Partial | `resid-builtin`/`resid-build` stubs; compile clean. Runtime helpers landed: conversion helpers, checked/wrapping/saturating arithmetic, ranges/slicing, raw strings, byte strings, `#location`, f-string interpolation, runtime `Str + Str` concat. Still missing: providers, handles, spawn, wide numerics, `resid-build` crate. |
| 6. Tooling, Bootstrap | Stub | `tools/*` single-line stubs; they build. No formatter, no CBOR, no LSP. |

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
- **398 tests total**: lexer 13, parser 83, resid-ir 41, resid-type 137, resid-codegen 111,
  residc 13 (e2e). Destructuring, `_ = expr` discard,
  `if`-expressions with phi joins, `while` and range `for-in` loops with
  `break`/`continue`, `for-in` over boxed lists, `comptime_print` (compile-time
  evidence side effect), `@residual Type y = expr`, the assertion family
  (`assert`/`rt_assert`/`known`/`rt_known`/`todo`/`unimplemented`), and
  if-let/while-let all type-check
  and lower end-to-end: `residc <f> run` binds
  pattern variables from a boxed struct, discards values, prints at compile time,
  aborts on failed asserts, and runs control-flow statements. `value?` and
  `value else { … }` verify and run (payload read from box slot 0, not the
  variant index); nested `if` tails join correctly (phi predecessors follow the
  terminating block); struct/option/match slices, ranges, raw/byte strings,
  f-strings, and `#location` all verify.
  Wrapping/saturating/checked arithmetic extern functions (`wrapping_add`,
  `saturating_mul`, `checked_div`, etc.) declared and callable from Resid source.
- **Self-host roadmap**: detailed in §12. Conversion helpers (§12.1, task 5.1),
  ranges/slicing (§12.1, task 5.3), raw/byte strings (§12.1, task 5.4),
  `#location` (§12.1, task 5.5), and f-string interpolation (§12.1, task 5.12)
  are done → M2 bootstrap milestone (string building for the Resid lexer).
  Next: provider backends (§12.1, task 5.6).

---

## 12. REMAINING TASKS — Self-Hosting Roadmap

Self-hosting (spec §39 Phase 3) requires a Resid program that can write the
compiler. The first milestone: **write a Resid lexer** — needs conversion
helpers (`i8(n)`, `u16(n)`, `f64(n)`) to turn ASCII codepoints into character
strings.

### 12.1 Phase 5 — Stdlib + Build System (blockers first)

| # | Task | Priority | Blocked on | Notes |
|---|------|----------|------------|-------|
| **5.1** | Conversion helpers (`i8..i512`, `u8..u512`, `f16..f512`, `isize`, `usize`) | ✅ Done | — | Extern functions. Narrow/widen numeric types at call sites. Bootstrap runtime: C casts. Typed in `BUILTIN_SIGS`, declared in codegen, implemented in `resid_rt.c`. Needed to write Resid lexer (codepoint→char). |
| **5.2** | Checked + wrapping + saturating arithmetic (`checked_add`, `wrapping_mul`, `saturating_sub`) | ✅ Done | 5.1 | Spec §6.5. Extern functions in `resid_rt.c`: `wrapping_add/sub/mul/div`, `saturating_add/sub/mul`, `checked_add/sub/mul/div` (signed + unsigned). Declared in codegen, typed in `BUILTIN_SIGS`. 11 new codegen tests. |
| **5.3** | Ranges and slicing (`xs[start..end]`, `0..=n` construction) | ✅ Done | — | Type: `Range(Elem)`/`Slice(Elem)`. `for-in` over a range lowers to a scalar counter. Construction lowers to `resid_range_new`/`resid_slice_new` (boxed). Parser fix: slice start/end bounds parsed above range precedence so `1..4` inside `[ ]` isn't consumed as a Range expr; `xs[..n]`, `xs[n..]`, `xs[..]` supported (defaults 0 / list length). |
| **5.4** | Raw strings + byte strings (`r"...\0"`, `b"bytes"`) | ✅ Done | — | `Bytes` core type (type + codegen). Raw strings (`r"..."`) lower as `Str` globals; byte strings (`b"..."`) lower as constant global byte arrays (`[N x i8]`, no NUL terminator), backed by the lexer's escape handling (`\"`, `\n`, `\t`, `\r`, `\\`, `\0`). |
| **5.5** | `#location` → `SourceLoc` type | ✅ Done | — | Type: `SourceLoc` with `file: Str`, `line: Int`, `col: Int` (`source_loc_fields()`); unknown fields rejected. Codegen: boxes a `SourceLoc { file, line, col }` from the current span (`e.span.file/line/col_start`) via the boxed-slot runtime; field access lowers through `load_slot`. |
| **5.6** | Provider backends (filesystem, environment, git) | P3 | 5.1 | `resid_rt.c` stubs only. Real I/O behind capability authorization. |
| **5.7** | Handle types (`with (File h = open(...))`) | P3 | 5.6 | RAII lifetime, reverse-order release, mutable ownership. |
| **5.8** | Spawn / `RegionError` / structured concurrency | P3 | 5.6 | `spawn (caps) { body }` → OS thread + structured join. |
| **5.9** | Wide numeric runtime (Int256, Int512, Float256, Float512) | P3 | — | Software emulation: `[u64; N]` arrays + runtime lib (add, mul, cmp). |
| **5.10** | `resid-build` crate (resid.toml, profiles, deps) | P3 | — | Config parsing, dependency resolution, build orchestration. |
| **5.11** | `resid-builtin` crate (full stdlib types) | P3 | — | `Option`, `Result`, `List`, `Map`, `Set`, `SourceLoc`, `Range`, behaviors. |
| **5.12** | F-string interpolation (`f"hello {name}"`) | ✅ Done | — | Type checker validates interpolated exprs (undefined vars/type errors surface at check time; f-string is `Str`). Codegen: pure-text f-strings fold to a constant; interpolated parts stringify each value (`Str` passthrough; `IntToString`/`UIntToString`/`FloatToString` widened to 64-bit; `BoolToString`; `ToString` for boxed composites, `SourceLoc`, `Ptr`) and stitch with runtime `resid_str_concat`. Runtime `Str + Str` with a non-constant operand also concatenates via `resid_str_concat` (constant operands still fold). |

### 12.2 Phase 4 — Codegen Gaps

| # | Task | Status | Notes |
|---|------|--------|-------|
| **4.1** | Float arithmetic (`+`, `-`, `*`, `/` on Float types) | ❌ Not yet | Int arithmetic done. Need float_type + fadd/fsub/fmul/fdiv. |
| **4.2** | Conversion helpers lowering | ❌ Not yet | Must declare extern, widen args to target width, return result. |
| **4.3** | `@residual Type y = expr` codegen | ✅ Done | Lowers as typed binding with residual marker. |
| **4.4** | `known`/`rt_known` codegen | ✅ Done | `known` → compile-time check abort; `rt_known` → runtime check abort. |
| **4.5** | `todo`/`unimplemented` codegen | ✅ Done | Lower to `resid_abort("message")`. |
| **4.6** | `comptime_print` codegen | ✅ Done | Fires at compile time (stderr), drops value from runtime. |
| **4.7** | `for-in` over numeric ranges | ✅ Done | Lowers to scalar i64 counter with `slt`/`sle` bounds check. |
| **4.8** | `if-let`/`while-let` destructuring | ✅ Done | Pattern matching on boxed values via `resid_box_tag`. |
| **4.9** | Struct field access codegen | ✅ Done | `p.x` on boxed struct → `resid_box_slot(idx)`. |
| **4.10** | List indexing codegen | ✅ Done | `xs[i]` → `resid_box_slot(i)`. |

### 12.3 Phase 3 — Type System Gaps

| # | Task | Status | Notes |
|---|------|--------|-------|
| **3.1** | Conversion helper type resolution | ❌ Not yet | `i32(42)` must resolve to `Int(32)` type. |
| **3.2** | Float type inference | ❌ Not yet | Float literals → `Float(64)` default. |
| **3.3** | `Range(Elem)` type construction | ✅ Done | From numeric bounds; for-in requires element type match. |
| **3.4** | `ListToString` | ✅ Done | List(Int/UInt/Float) → Str. |
| **3.5** | `Str + Str` concat type | ✅ Done | String concatenation produces Str. |
| **3.6** | `check_program` | ✅ Done | Full program type-checking entry point. |
| **3.7** | Behavior inference (auto-insert) | Partial | Numeric Eq/Ord/Hash generic over family. User-defined behaviors not yet. |
| **3.8** | Capability lattice checks | Partial | Built-in extern signatures resolved, capability enforcement not yet. |
| **3.9** | `@residual` type inference | ✅ Done | Residual marker preserves inner type. |
| **3.10** | If/while type inference | ✅ Done | `if` returns common type; `while` returns Void. |

### 12.4 Phase 2 — Knowledge Graph IR

| # | Task | Status | Notes |
|---|------|--------|-------|
| **2.1** | AST → IR conversion | ❌ Not yet | Phase 2 never implemented. IR crate has types but no AST bridge. |
| **2.2** | Reduction engine | ❌ Not yet | β-reduction, constant folding, constraint discharge, provider substitution. |
| **2.3** | Identifier uniqueness (no shadowing) | ❌ Not yet | Spec §7. |
| **2.4** | Parameter defaults resolution | ❌ Not yet | Inserted at call sites. |
| **2.5** | Named args resolution | ❌ Not yet | Reordered against param list. |
| **2.6** | Destructuring IR nodes | ❌ Not yet | `Point { x, y } = p` → field accesses. |
| **2.7** | Provenance tracking | ❌ Not yet | Source → provider → residual. |

### 12.5 Phase 6 — Tooling & Bootstrap

| # | Task | Status | Notes |
|---|------|--------|-------|
| **6.1** | `resid-fmt` (canonical formatter) | ❌ Stub | Single-line stub, not implemented. |
| **6.2** | CBOR residual notes (`resid-notes`) | ❌ Stub | `.resid-notes.cbor` schema per spec §34. |
| **6.3** | Knowledge cache (CBOR) | ❌ Stub | `.resid-cache.cbor` for incremental compilation. |
| **6.4** | `resid-graph` (dependency graph) | ❌ Stub | DOT / ASCII emitter. |
| **6.5** | `resid-why` (provenance query) | ❌ Stub | "Why is this residual?" tool. |
| **6.6** | LSP server | ❌ Not started | Residual status, doc hover, diagnostics, exhaustiveness. |
| **6.7** | Incremental compilation | ❌ Not started | Cache per source file hash. |
| **6.8** | Conformance test suite | ❌ Not started | All spec §39 conformance items. |
| **6.9** | Bootstrap (compiler in Resid) | ❌ Not started | Rewrite lexer/parser in Resid, then full pipeline. |

### 12.6 Conformance Checklist (spec §39)

Updated from §10. **Checked = done, unchecked = missing.**

| Item | Status |
|------|--------|
| Pure reduction relation (§36) | ❌ |
| Residual-machine semantics (§9) | Partial — `rt`, `@residual` work |
| Residual-type rules R1-R5 (§12) | ❌ |
| CBOR schemas (§34) | ❌ |
| Capability checks (§20) | ❌ |
| Absolute identifier uniqueness (§7) | ❌ |
| Behavior inference (§11) | Partial — numeric only |
| **Method call syntax (§16)** | ✅ | `obj.method(args)` parses as `MethodCall { target, method, args }`; method calls on value types rejected at type-check. Desugaring not yet. |
| Pattern matching (§13) | ✅ |
| Destructuring (§13) | ✅ |
| **if-let/while-let (§13)** | ✅ |
| Visibility rules (§22) | ❌ |
| Structured spawn (§19) | ❌ |
| Full numeric family (§6, §32) | Partial — Int8..Int64, UInt8..UInt64, Float16/32/64 |
| Checked arithmetic (§6.5) | ❌ |
| **For-in (§18, §29)** | ✅ |
| Ranges and slicing (§15) | ✅ |
| known/rt_known (§9, §24) | ✅ |
| comptime_print (§24) | ✅ |
| Raw/byte strings (§14) | ❌ |
| #location (§25) | ❌ |
| Discard binding (§7) | ✅ |
| Default parameters (§8) | ❌ |
| Named arguments (§8) | ❌ |
| **@residual (§9)** | ✅ |
| value? / value else {} (§23) | ❌ |
| Failure model (§9) | Partial — abort works, RegionError not |
| Conversion helpers (§6.7) | ✅ |
| Wrapping/saturating arithmetic (§6.5) | ✅ |
| **Provider call syntax (§32)** | ✅ | `filesystem.verb(args)`, `environment.verb(args)`, `git.verb(args)` parse as ProviderCall; type-check rejects unknown providers, unknown verbs, wrong arg counts/types; codegen dispatches to extern functions. |
| Float arithmetic (§6.2) | ❌ |

### 12.7 Bootstrap Milestones

1. **M1 — Conversion helpers**: `i8..i512`, `u8..u512`, `f16..f512`, `isize`, `usize`.
   Enables Resid codepoint→char conversion for lexer.

2. **M2 — String + char support**: byte strings, `#location`, ranges, `Str + Str`.
   Enables Resid string building for lexer output.

3. **M3 — List + Option + struct + pattern matching**: already mostly working in
   codegen, needs type system + IR glue. Enables Resid data structures for parser.

4. **M4 — Resid lexer**: Write a Resid program that lexes `.resid` source.
   Proof: `cargo run` on a `.resid` file produces tokens.

5. **M5 — Resid parser**: Write a Resid program that parses tokens into AST.
   Proof: `cargo run` on `.resid` source produces AST output.

6. **M6 — Full compiler in Resid**: Type checking, codegen, LLVM backend.
   Self-hosting achieved.

---

## 13. OPEN QUESTIONS

All resolved in Resid 3.0. See `resid_specification.txt`.

### Resolved

1. ~~**Float(16)**~~ → **RESOLVED**: LLVM half (i16, IEEE 754 binary16). Failover to software-emulated via f32 conversion on targets lacking native half support.

2. ~~**Float(128/256/512)**~~ → **RESOLVED**: Float(128) → `__float128` libcall with software failover. Float(256/512) → software emulation via `[u64; N]` + runtime lib.

3. ~~**Provider volatility**~~ → **RESOLVED**: All three providers (`filesystem`, `environment`, `git`) are volatile. Cannot be constant-folded at compile time.

4. ~~**Spawn scheduler**~~ → **RESOLVED**: One OS thread per spawn. Structured join via thread join. Task pools deferred.

5. ~~**Doc comment storage**~~ → **RESOLVED**: `Vec<String>` per declaration. Flows into residual notes CBOR and LSP hover.

6. ~~**Incremental recompilation**~~ → **RESOLVED**: Cache per source file hash. Content-addressed per-node caching tracked as future planning.

---

*Last updated: 2026-08-10 — Self-hosting roadmap added in §12.*