//! KnowledgeGraph — slotmap-based enriched expression DAG.

use slotmap::new_key_type;
use slotmap::SlotMap;
new_key_type! { pub struct GraphKey; }
use std::collections::{HashMap, HashSet, VecDeque};
use std::fmt;

use crate::types::*;

/// Create a placeholder node for "no definition" cases.
pub fn invalid_key(graph: &mut KnowledgeGraph) -> GraphKey {
    let n = NodeKind::Literal(LiteralValue::Int { value: 0, width: IntWidth::B64, signed: true });
    graph.add_node(n, Type::Numeric(NumericType::Int(IntWidth::B64)),
        KnowledgeState::Known, vec![], HashSet::new(), HashSet::new(),
        Provenance::Inferred, Span::unknown())
}

/// Knowledge state of a node (spec §3).
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum KnowledgeState { Known, Effect, Residual, Invalid }

impl fmt::Display for KnowledgeState {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self { KnowledgeState::Known => write!(f,"known"),
                     KnowledgeState::Effect => write!(f,"effect"),
                     KnowledgeState::Residual => write!(f,"residual"),
                     KnowledgeState::Invalid => write!(f,"invalid"), }
    }
}

/// What a node computes.
#[derive(Clone)]
pub enum NodeKind {
    Literal(LiteralValue), Location,
    Binding { name: Identifier, def: GraphKey },
    Discard { source: GraphKey },
    Function { name: Identifier, params: Vec<(Identifier, Type, Option<GraphKey>)>,
               ret: Type, body: GraphKey, capabilities: HashSet<Capability> },
    Call { func: GraphKey, args: Vec<GraphKey> },
    Rt(GraphKey),
    AtResidual { type_: Type, inner: GraphKey },
    BinaryOp { op: BinOp, lhs: GraphKey, rhs: GraphKey },
    UnaryOp { op: UnaryOp, operand: GraphKey },
    Cast { type_: Type, operand: GraphKey },
    If { cond: GraphKey, then_branch: GraphKey, else_branch: Option<GraphKey> },
    While { cond: GraphKey, body: GraphKey },
    For { init: GraphKey, cond: GraphKey, step: GraphKey, body: GraphKey },
    ForIn { iter: GraphKey, name: Identifier, body: GraphKey },
    Match { scrutinee: GraphKey, arms: Vec<(Pattern, GraphKey)>, default_arm: Option<GraphKey> },
    Spawn { capabilities: HashSet<Capability>, body: GraphKey, ret: Type },
    Assert { cond: GraphKey, message: GraphKey },
    RtAssert { cond: GraphKey, message: GraphKey },
    Known(GraphKey), RtKnown(GraphKey), ComptimePrint(GraphKey),
    Todo, Unimplemented,
    Struct { name: Identifier, fields: Vec<(Identifier, GraphKey)> },
    List { elements: Vec<GraphKey> },
    Map { entries: Vec<(GraphKey, GraphKey)> },
    Range { start: GraphKey, end: GraphKey, closed: bool },
    FString { parts: Vec<FStringPartNode> },
    RawString(String), ByteString(Vec<u8>),
    FieldAccess { target: GraphKey, field: Identifier },
    Index { target: GraphKey, index: GraphKey },
    Slice { target: GraphKey, range: GraphKey },
    MethodCall { target: GraphKey, method: Identifier, args: Vec<GraphKey> },
    EarlyReturn { value: GraphKey },
    ElseFallback { value: GraphKey, fallback: GraphKey },
    Destructure { pattern: Pattern, source: GraphKey, bindings: Vec<(Identifier, GraphKey)> },
    With { bindings: Vec<WithBindingNode>, body: GraphKey },
    ProviderCall { provider: Provider, args: Vec<GraphKey> },
    BehaviorInstance { behavior: BehaviorRef, type_: Type },
    Using { value: GraphKey, behavior: BehaviorRef },
    RegionError(GraphKey),
}

impl fmt::Debug for NodeKind {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            NodeKind::Literal(_) => write!(f,"literal"), NodeKind::Location => write!(f,"#location"),
            NodeKind::Binding{name,..} => write!(f,"binding({})",name), NodeKind::Discard{..}=>write!(f,"discard"),
            NodeKind::Function{name,..} => write!(f,"function({})",name), NodeKind::Call{..}=>write!(f,"call"),
            NodeKind::Rt(_) => write!(f,"rt"), NodeKind::AtResidual{..}=>write!(f,"@residual"),
            NodeKind::BinaryOp{op,..} => write!(f,"binary({:?})",op),
            NodeKind::UnaryOp{op,..} => write!(f,"unary({:?})",op),
            NodeKind::Cast{type_,..} => write!(f,"cast({})",type_),
            NodeKind::If{..} => write!(f,"if"),
            NodeKind::While{..} => write!(f,"while"),
            NodeKind::For{..} => write!(f,"for"),
            NodeKind::ForIn{name,..} => write!(f,"for-in({})",name),
            NodeKind::Match{..} => write!(f,"match"),
            NodeKind::Spawn{..} => write!(f,"spawn"),
            NodeKind::Assert{..} => write!(f,"assert"),
            NodeKind::RtAssert{..} => write!(f,"rt_assert"),
            NodeKind::Known(_) => write!(f,"known"),
            NodeKind::RtKnown(_) => write!(f,"rt_known"),
            NodeKind::ComptimePrint(_) => write!(f,"comptime_print"),
            NodeKind::Todo => write!(f,"todo"),
            NodeKind::Unimplemented => write!(f,"unimp"),
            NodeKind::Struct{name,..} => write!(f,"struct({})",name),
            NodeKind::List{..} => write!(f,"list"),
            NodeKind::Map{..} => write!(f,"map"),
            NodeKind::Range{..} => write!(f,"range"),
            NodeKind::FString{..} => write!(f,"fstring"),
            NodeKind::RawString(_) => write!(f,"raw_string"),
            NodeKind::ByteString(_) => write!(f,"byte_string"),
            NodeKind::FieldAccess{field,..} => write!(f,"field({})",field),
            NodeKind::Index{..} => write!(f,"index"),
            NodeKind::Slice{..} => write!(f,"slice"),
            NodeKind::MethodCall{method,..} => write!(f,"method({})",method),
            NodeKind::EarlyReturn{..} => write!(f,"early_return"),
            NodeKind::ElseFallback{..} => write!(f,"else_fallback"),
            NodeKind::Destructure{..} => write!(f,"destructure"),
            NodeKind::With{..} => write!(f,"with"),
            NodeKind::ProviderCall{provider,..} => write!(f,"provider({:?})",provider),
            NodeKind::BehaviorInstance{behavior,..} => write!(f,"behavior({})",behavior.name),
            NodeKind::Using{..} => write!(f,"using"),
            NodeKind::RegionError(_) => write!(f,"region_error"),
        }
    }
}

#[derive(Clone, Debug)]
pub struct FStringPartNode { pub text: String, pub expr: Option<GraphKey> }

#[derive(Clone, Debug)]
pub struct WithBindingNode { pub type_: Type, pub name: Identifier, pub init: GraphKey }

/// Single node in the knowledge graph.
#[derive(Clone)]
pub struct Node {
    pub kind: NodeKind, pub type_: Type, pub knowledge: KnowledgeState,
    pub deps: Vec<GraphKey>, pub effects: HashSet<Effect>,
    pub capabilities: HashSet<Capability>, pub provenance: Provenance,
    pub span: Span, pub doc_comments: Option<Vec<String>>,
}

impl fmt::Debug for Node {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("Node").field("kind", &self.kind).field("type_", &self.type_)
         .field("knowledge", &self.knowledge).field("deps", &self.deps).finish()
    }
}

/// The knowledge graph — enriched expression DAG.
#[derive(Clone)]
pub struct KnowledgeGraph {
    nodes: SlotMap<GraphKey, Node>,
    pub next_id: u64,
    identifiers: HashMap<String, Vec<u64>>,
    entry_point: Option<GraphKey>,
    functions: HashMap<String, GraphKey>,
}

impl KnowledgeGraph {
    pub fn new() -> Self {
        KnowledgeGraph { nodes: <SlotMap<GraphKey, Node>>::with_key(), next_id: 0,
            identifiers: HashMap::new(), entry_point: None, functions: HashMap::new() }
    }

    pub fn add_node(&mut self, kind: NodeKind, type_: Type, knowledge: KnowledgeState,
                    deps: Vec<GraphKey>, effects: HashSet<Effect>,
                    capabilities: HashSet<Capability>, provenance: Provenance, span: Span,
                   ) -> GraphKey {
        let id = self.next_id; self.next_id += 1;
        if let NodeKind::Binding{ref name,..} = kind {
            self.identifiers.entry(name.name.clone()).or_default().push(id);
        }
        let node = Node { kind, type_, knowledge, deps, effects, capabilities,
                          provenance, span, doc_comments: None };
        self.nodes.insert(node)
    }

    pub fn get_node(&self, key: GraphKey) -> &Node { &self.nodes[key] }
    pub fn get_node_mut(&mut self, key: GraphKey) -> &mut Node { &mut self.nodes[key] }
    pub fn get_node_checked(&self, key: GraphKey) -> Option<&Node> { self.nodes.get(key) }

    pub fn set_knowledge(&mut self, key: GraphKey, state: KnowledgeState) {
        self.nodes[key].knowledge = state;
    }

    pub fn set_doc_comments(&mut self, key: GraphKey, comments: Vec<String>) {
        self.nodes[key].doc_comments = Some(comments);
    }

    pub fn set_entry(&mut self, key: GraphKey) { self.entry_point = Some(key); }
    pub fn get_entry(&self) -> Option<GraphKey> { self.entry_point }

    pub fn register_function(&mut self, name: String, key: GraphKey) {
        self.functions.insert(name, key);
    }
    pub fn lookup_function(&self, name: &str) -> Option<&Node> {
        self.functions.get(name).map(|k| &self.nodes[*k])
    }

    pub fn check_uniqueness(&self) -> Vec<(String, Vec<u64>)> {
        self.identifiers.iter().filter(|(_,ids)| ids.len()>1)
            .map(|(n,ids)| (n.clone(), ids.clone())).collect()
    }

    pub fn all_keys(&self) -> Vec<GraphKey> {
        self.nodes.iter().map(|(k,_)| k).collect()
    }

    pub fn reachable(&self, start: GraphKey) -> HashSet<GraphKey> {
        let mut visited = HashSet::new();
        let mut queue = VecDeque::new();
        queue.push_back(start); visited.insert(start);
        while let Some(key) = queue.pop_front() {
            if let Some(node) = self.nodes.get(key) {
                for &dep in &node.deps { if visited.insert(dep) { queue.push_back(dep); } }
            }
        }
        visited
    }

    pub fn topological_order(&self, start: GraphKey) -> Vec<GraphKey> {
        let reachable = self.reachable(start);
        let mut in_degree: HashMap<GraphKey, usize> = HashMap::new();
        for &key in &reachable { in_degree.entry(key).or_insert(0);
            if let Some(node) = self.nodes.get(key) {
                for &dep in &node.deps { if reachable.contains(&dep) {
                    *in_degree.entry(dep).or_insert(0) += 1; } }
            }
        }
        let mut queue = VecDeque::new();
        for &key in &reachable { if in_degree.get(&key) == Some(&0) { queue.push_back(key); } }
        let mut result = Vec::new();
        while let Some(key) = queue.pop_front() {
            result.push(key);
            if let Some(node) = self.nodes.get(key) {
                for &dep in &node.deps {
                    if reachable.contains(&dep) {
                        if let Some(deg) = in_degree.get_mut(&dep) { *deg -= 1;
                            if *deg == 0 { queue.push_back(dep); }
                        }
                    }
                }
            }
        }
        result
    }

    pub fn replace_node(&mut self, key: GraphKey, kind: NodeKind, type_: Type, knowledge: KnowledgeState) -> GraphKey {
        let node = self.nodes.get(key).unwrap();
        self.nodes[key] = Node { kind, type_, knowledge,
            deps: node.deps.clone(), effects: node.effects.clone(),
            capabilities: node.capabilities.clone(), provenance: node.provenance.clone(),
            span: node.span.clone(), doc_comments: node.doc_comments.clone() };
        key
    }
}

impl fmt::Debug for KnowledgeGraph {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("KnowledgeGraph").field("node_count", &self.nodes.len()).finish()
    }
}
