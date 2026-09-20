//! KnowledgeGraph — slotmap-based enriched expression DAG.

use slotmap::SlotMap;
use slotmap::new_key_type;
new_key_type! { pub struct GraphKey; }
use std::collections::{HashMap, HashSet, VecDeque};
use std::fmt;

use crate::types::*;

/// Create a placeholder node for "no definition" cases.
pub fn invalid_key(graph: &mut KnowledgeGraph) -> GraphKey {
    let n = NodeKind::Literal(LiteralValue::Int {
        value: 0,
        width: IntWidth::B64,
        signed: true,
    });
    graph.add_node(
        n,
        Type::Numeric(NumericType::Int(IntWidth::B64)),
        KnowledgeState::Known,
        vec![],
        HashSet::new(),
        HashSet::new(),
        Provenance::Inferred,
        Span::unknown(),
    )
}

/// Knowledge state of a node (spec §3).
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum KnowledgeState {
    Known,
    Effect,
    Residual,
    Invalid,
}

impl fmt::Display for KnowledgeState {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            KnowledgeState::Known => write!(f, "known"),
            KnowledgeState::Effect => write!(f, "effect"),
            KnowledgeState::Residual => write!(f, "residual"),
            KnowledgeState::Invalid => write!(f, "invalid"),
        }
    }
}

/// What a node computes.
#[derive(Clone)]
pub enum NodeKind {
    Literal(LiteralValue),
    Location,
    Binding {
        name: Identifier,
        def: GraphKey,
    },
    /// A compile-time reference to a binding cell (`Identifier` use site).
    /// `def` is the key of the definition it resolves to (a `Binding` cell, a
    /// param cell, or a `Function` node). Never folded away unless the def
    /// resolves to a literal.
    Reference {
        name: Identifier,
        def: GraphKey,
    },
    Discard {
        source: GraphKey,
    },
    /// `return;` / `return expr;` (value may be a void Null literal for a bare
    /// `return`).
    Break,
    Continue,
    Function {
        name: Identifier,
        public: bool,
        params: Vec<(Identifier, Type, Option<GraphKey>)>,
        ret: Type,
        body: GraphKey,
        capabilities: HashSet<Capability>,
    },
    Call {
        func: GraphKey,
        args: Vec<GraphKey>,
    },
    Rt(GraphKey),
    AtResidual {
        type_: Type,
        inner: GraphKey,
    },
    BinaryOp {
        op: BinOp,
        lhs: GraphKey,
        rhs: GraphKey,
    },
    UnaryOp {
        op: UnaryOp,
        operand: GraphKey,
    },
    Cast {
        type_: Type,
        operand: GraphKey,
    },
    If {
        cond: GraphKey,
        then_branch: GraphKey,
        else_branch: Option<GraphKey>,
    },
    While {
        cond: GraphKey,
        body: GraphKey,
    },
    For {
        init: GraphKey,
        cond: GraphKey,
        step: GraphKey,
        body: GraphKey,
    },
    ForIn {
        iter: GraphKey,
        name: Identifier,
        body: GraphKey,
    },
    Match {
        scrutinee: GraphKey,
        arms: Vec<(Pattern, GraphKey)>,
        default_arm: Option<GraphKey>,
    },
    Spawn {
        capabilities: HashSet<Capability>,
        body: GraphKey,
        ret: Type,
    },
    Assert {
        cond: GraphKey,
        message: GraphKey,
    },
    RtAssert {
        cond: GraphKey,
        message: GraphKey,
    },
    Known(GraphKey),
    RtKnown(GraphKey),
    ComptimePrint(GraphKey),
    Todo,
    Unimplemented,
    Struct {
        name: Identifier,
        fields: Vec<(Identifier, GraphKey)>,
    },
    List {
        elements: Vec<GraphKey>,
    },
    Map {
        entries: Vec<(GraphKey, GraphKey)>,
    },
    Set {
        elements: Vec<GraphKey>,
    },
    Range {
        start: GraphKey,
        end: GraphKey,
        closed: bool,
    },
    FString {
        parts: Vec<FStringPartNode>,
    },
    RawString(String),
    ByteString(Vec<u8>),
    FieldAccess {
        target: GraphKey,
        field: Identifier,
    },
    Index {
        target: GraphKey,
        index: GraphKey,
    },
    Slice {
        target: GraphKey,
        range: GraphKey,
    },
    MethodCall {
        target: GraphKey,
        method: Identifier,
        args: Vec<GraphKey>,
    },
    EarlyReturn {
        value: GraphKey,
    },
    ElseFallback {
        value: GraphKey,
        fallback: GraphKey,
    },
    Destructure {
        pattern: Pattern,
        source: GraphKey,
        bindings: Vec<(Identifier, GraphKey)>,
    },
    With {
        bindings: Vec<WithBindingNode>,
        body: GraphKey,
    },
    ProviderCall {
        provider: Provider,
        verb: Identifier,
        args: Vec<GraphKey>,
    },
    BehaviorInstance {
        behavior: BehaviorRef,
        type_: Type,
    },
    Using {
        value: GraphKey,
        behavior: BehaviorRef,
    },
    RegionError(GraphKey),
}

impl fmt::Debug for NodeKind {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            NodeKind::Literal(_) => write!(f, "literal"),
            NodeKind::Location => write!(f, "#location"),
            NodeKind::Binding { name, .. } => write!(f, "binding({})", name),
            NodeKind::Reference { name, .. } => write!(f, "ref({})", name),
            NodeKind::Discard { .. } => write!(f, "discard"),
            NodeKind::Break => write!(f, "break"),
            NodeKind::Continue => write!(f, "continue"),
            NodeKind::Function { name, .. } => write!(f, "function({})", name),
            NodeKind::Call { .. } => write!(f, "call"),
            NodeKind::Rt(_) => write!(f, "rt"),
            NodeKind::AtResidual { .. } => write!(f, "@residual"),
            NodeKind::BinaryOp { op, .. } => write!(f, "binary({:?})", op),
            NodeKind::UnaryOp { op, .. } => write!(f, "unary({:?})", op),
            NodeKind::Cast { type_, .. } => write!(f, "cast({})", type_),
            NodeKind::If { .. } => write!(f, "if"),
            NodeKind::While { .. } => write!(f, "while"),
            NodeKind::For { .. } => write!(f, "for"),
            NodeKind::ForIn { name, .. } => write!(f, "for-in({})", name),
            NodeKind::Match { .. } => write!(f, "match"),
            NodeKind::Spawn { .. } => write!(f, "spawn"),
            NodeKind::Assert { .. } => write!(f, "assert"),
            NodeKind::RtAssert { .. } => write!(f, "rt_assert"),
            NodeKind::Known(_) => write!(f, "known"),
            NodeKind::RtKnown(_) => write!(f, "rt_known"),
            NodeKind::ComptimePrint(_) => write!(f, "comptime_print"),
            NodeKind::Todo => write!(f, "todo"),
            NodeKind::Unimplemented => write!(f, "unimp"),
            NodeKind::Struct { name, .. } => write!(f, "struct({})", name),
            NodeKind::List { .. } => write!(f, "list"),
            NodeKind::Map { .. } => write!(f, "map"),
            NodeKind::Set { .. } => write!(f, "set"),
            NodeKind::Range { .. } => write!(f, "range"),
            NodeKind::FString { .. } => write!(f, "fstring"),
            NodeKind::RawString(_) => write!(f, "raw_string"),
            NodeKind::ByteString(_) => write!(f, "byte_string"),
            NodeKind::FieldAccess { field, .. } => write!(f, "field({})", field),
            NodeKind::Index { .. } => write!(f, "index"),
            NodeKind::Slice { .. } => write!(f, "slice"),
            NodeKind::MethodCall { method, .. } => write!(f, "method({})", method),
            NodeKind::EarlyReturn { .. } => write!(f, "early_return"),
            NodeKind::ElseFallback { .. } => write!(f, "else_fallback"),
            NodeKind::Destructure { .. } => write!(f, "destructure"),
            NodeKind::With { .. } => write!(f, "with"),
            NodeKind::ProviderCall { provider, .. } => write!(f, "provider({:?})", provider),
            NodeKind::BehaviorInstance { behavior, .. } => write!(f, "behavior({})", behavior.name),
            NodeKind::Using { .. } => write!(f, "using"),
            NodeKind::RegionError(_) => write!(f, "region_error"),
        }
    }
}

#[derive(Clone, Debug)]
pub struct FStringPartNode {
    pub text: String,
    pub expr: Option<GraphKey>,
}

#[derive(Clone, Debug)]
pub struct WithBindingNode {
    pub type_: Type,
    pub name: Identifier,
    pub init: GraphKey,
}

/// Per-block statement layout recorded during AST conversion, keyed by the
/// block's last (root) node. `anchors` are the statement nodes in source
/// order; `tail` is the block's trailing return *expression* (convert_block's
/// `ret` expr), if any, and must be the last element of `anchors` when set.
/// Enables faithful statement reconstruction after reduction.
#[derive(Clone, Debug, Default)]
pub struct BlockInfo {
    pub anchors: Vec<GraphKey>,
    pub tail: Option<GraphKey>,
}

/// Single node in the knowledge graph.
#[derive(Clone)]
pub struct Node {
    pub kind: NodeKind,
    pub type_: Type,
    pub knowledge: KnowledgeState,
    pub deps: Vec<GraphKey>,
    pub effects: HashSet<Effect>,
    pub capabilities: HashSet<Capability>,
    pub provenance: Provenance,
    pub span: Span,
    pub doc_comments: Option<Vec<String>>,
}

impl fmt::Debug for Node {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("Node")
            .field("kind", &self.kind)
            .field("type_", &self.type_)
            .field("knowledge", &self.knowledge)
            .field("deps", &self.deps)
            .finish()
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
    block_info: HashMap<GraphKey, BlockInfo>,
    param_cells: HashMap<GraphKey, Vec<GraphKey>>,
}

impl Default for KnowledgeGraph {
    fn default() -> Self {
        Self::new()
    }
}

impl KnowledgeGraph {
    pub fn new() -> Self {
        KnowledgeGraph {
            nodes: <SlotMap<GraphKey, Node>>::with_key(),
            next_id: 0,
            identifiers: HashMap::new(),
            entry_point: None,
            functions: HashMap::new(),
            block_info: HashMap::new(),
            param_cells: HashMap::new(),
        }
    }

    #[allow(clippy::too_many_arguments)]
    pub fn add_node(
        &mut self,
        kind: NodeKind,
        type_: Type,
        knowledge: KnowledgeState,
        deps: Vec<GraphKey>,
        effects: HashSet<Effect>,
        capabilities: HashSet<Capability>,
        provenance: Provenance,
        span: Span,
    ) -> GraphKey {
        let id = self.next_id;
        self.next_id += 1;
        if let NodeKind::Binding { ref name, .. } = kind {
            self.identifiers
                .entry(name.name.clone())
                .or_default()
                .push(id);
        }
        let node = Node {
            kind,
            type_,
            knowledge,
            deps,
            effects,
            capabilities,
            provenance,
            span,
            doc_comments: None,
        };
        self.nodes.insert(node)
    }

    pub fn get_node(&self, key: GraphKey) -> &Node {
        &self.nodes[key]
    }
    pub fn get_node_mut(&mut self, key: GraphKey) -> &mut Node {
        &mut self.nodes[key]
    }
    pub fn get_node_checked(&self, key: GraphKey) -> Option<&Node> {
        self.nodes.get(key)
    }

    pub fn set_knowledge(&mut self, key: GraphKey, state: KnowledgeState) {
        self.nodes[key].knowledge = state;
    }

    pub fn set_doc_comments(&mut self, key: GraphKey, comments: Vec<String>) {
        self.nodes[key].doc_comments = Some(comments);
    }

    pub fn set_function_parts(
        &mut self,
        key: GraphKey,
        body: GraphKey,
        params: Vec<(Identifier, Type, Option<GraphKey>)>,
    ) {
        let mut deps: Vec<GraphKey> = vec![body];
        for (_, _, d) in &params {
            if let Some(dk) = d {
                deps.push(*dk);
            }
        }
        let node = self.nodes.get_mut(key).unwrap();
        if let NodeKind::Function {
            body: b,
            params: p,
            ..
        } = &mut node.kind
        {
            *b = body;
            *p = params;
        }
        node.deps = deps;
    }

    /// Set the entry point (`main` when present, else the first function).
    pub fn set_entry(&mut self, key: GraphKey) {
        self.entry_point = Some(key);
    }
    pub fn get_entry(&self) -> Option<GraphKey> {
        self.entry_point
    }

    pub fn register_function(&mut self, name: String, key: GraphKey) {
        self.functions.insert(name, key);
    }
    pub fn lookup_function(&self, name: &str) -> Option<&Node> {
        self.functions.get(name).map(|k| &self.nodes[*k])
    }
    pub fn lookup_function_key(&self, name: &str) -> Option<GraphKey> {
        self.functions.get(name).copied()
    }
    pub fn function_keys(&self) -> Vec<GraphKey> {
        self.functions.values().copied().collect()
    }

    pub fn all_keys(&self) -> Vec<GraphKey> {
        self.nodes.keys().collect()
    }

    /// Record the statement layout of a converted block under its root key.
    pub fn set_block_info(&mut self, root: GraphKey, info: BlockInfo) {
        self.block_info.insert(root, info);
    }
    pub fn block_info(&self, key: GraphKey) -> Option<&BlockInfo> {
        self.block_info.get(&key)
    }

    /// Record which param-cell keys belong to a function (for β-substitution
    /// overrides during inlining).
    pub fn set_param_cells(&mut self, func: GraphKey, cells: Vec<GraphKey>) {
        self.param_cells.insert(func, cells);
    }
    pub fn param_cells(&self, func: GraphKey) -> Option<&Vec<GraphKey>> {
        self.param_cells.get(&func)
    }

    pub fn check_uniqueness(&self) -> Vec<(String, Vec<u64>)> {
        self.identifiers
            .iter()
            .filter(|(_, ids)| ids.len() > 1)
            .map(|(n, ids)| (n.clone(), ids.clone()))
            .collect()
    }

    pub fn reachable(&self, start: GraphKey) -> HashSet<GraphKey> {
        let mut visited = HashSet::new();
        let mut queue = VecDeque::new();
        queue.push_back(start);
        visited.insert(start);
        while let Some(key) = queue.pop_front() {
            if let Some(node) = self.nodes.get(key) {
                for &dep in &node.deps {
                    if visited.insert(dep) {
                        queue.push_back(dep);
                    }
                }
            }
        }
        visited
    }

    pub fn topological_order(&self, start: GraphKey) -> Vec<GraphKey> {
        let reachable = self.reachable(start);
        let mut in_degree: HashMap<GraphKey, usize> = HashMap::new();
        for &key in &reachable {
            in_degree.entry(key).or_insert(0);
            if let Some(node) = self.nodes.get(key) {
                for &dep in &node.deps {
                    if reachable.contains(&dep) {
                        *in_degree.entry(dep).or_insert(0) += 1;
                    }
                }
            }
        }
        let mut queue = VecDeque::new();
        for &key in &reachable {
            if in_degree.get(&key) == Some(&0) {
                queue.push_back(key);
            }
        }
        let mut result = Vec::new();
        while let Some(key) = queue.pop_front() {
            result.push(key);
            if let Some(node) = self.nodes.get(key) {
                for &dep in &node.deps {
                    if reachable.contains(&dep)
                        && let Some(deg) = in_degree.get_mut(&dep) {
                            *deg -= 1;
                            if *deg == 0 {
                                queue.push_back(dep);
                            }
                        }
                }
            }
        }
        result
    }

    pub fn replace_node(
        &mut self,
        key: GraphKey,
        kind: NodeKind,
        type_: Type,
        knowledge: KnowledgeState,
    ) -> GraphKey {
        let node = self.nodes.get(key).unwrap();
        self.nodes[key] = Node {
            kind,
            type_,
            knowledge,
            deps: node.deps.clone(),
            effects: node.effects.clone(),
            capabilities: node.capabilities.clone(),
            provenance: node.provenance.clone(),
            span: node.span.clone(),
            doc_comments: node.doc_comments.clone(),
        };
        key
    }

    /// Clone the subgraph reachable from `root` into this graph, remapping
    /// every reachable key through `overrides` (param cells → argument nodes
    /// during β-substitution). Immutable leaf kinds (`Function`, `Literal`,
    /// `RawString`, `ByteString`, `Location`) are shared rather than cloned.
    ///
    /// Returns the new root and the list of newly created keys (deps first).
    /// Clones are marked `Provenance::Inferred` so the back-translator never
    /// mistakes them for source statements.
    pub fn clone_subgraph(
        &mut self,
        root: GraphKey,
        overrides: &HashMap<GraphKey, GraphKey>,
    ) -> Option<(GraphKey, Vec<GraphKey>)> {
        let mut remap: HashMap<GraphKey, GraphKey> = overrides.clone();
        // Walk deps-first (topological_order returns dependents first).
        let order = self.topological_order(root);
        let mut cloned: Vec<GraphKey> = Vec::new();
        for &key in order.iter().rev() {
            if remap.contains_key(&key) {
                continue;
            }
            let node = self.nodes.get(key)?.clone();
            let shared_leaf = matches!(
                node.kind,
                NodeKind::Function { .. }
                    | NodeKind::Literal(_)
                    | NodeKind::RawString(_)
                    | NodeKind::ByteString(_)
                    | NodeKind::Location
                    | NodeKind::Todo
                    | NodeKind::Unimplemented
            );
            if shared_leaf {
                remap.insert(key, key);
                continue;
            }
            let kind = remap_kind(node.kind, &remap);
            let deps: Vec<GraphKey> = node.deps.iter().map(|d| *remap.get(d).unwrap_or(d)).collect();
            let new_key = self.add_node(
                kind,
                node.type_,
                node.knowledge,
                deps,
                node.effects,
                node.capabilities,
                Provenance::Inferred,
                node.span,
            );
            remap.insert(key, new_key);
            cloned.push(new_key);
        }
        let new_root = *remap.get(&root)?;
        Some((new_root, cloned))
    }
}

/// Rewrite every `GraphKey` inside a node kind through `remap` (unmapped keys
/// are preserved, i.e. shared leaves).
fn remap_kind(kind: NodeKind, remap: &HashMap<GraphKey, GraphKey>) -> NodeKind {
    let r = |k: GraphKey| *remap.get(&k).unwrap_or(&k);
    match kind {
        NodeKind::Literal(_) => kind,
        NodeKind::Location => kind,
        NodeKind::Binding { name, def } => NodeKind::Binding {
            name,
            def: r(def),
        },
        NodeKind::Reference { name, def } => NodeKind::Reference {
            name,
            def: r(def),
        },
        NodeKind::Discard { source } => NodeKind::Discard { source: r(source) },
        NodeKind::Break => NodeKind::Break,
        NodeKind::Continue => NodeKind::Continue,
        NodeKind::Function {
            name,
            public,
            params,
            ret,
            body,
            capabilities,
        } => NodeKind::Function {
            name,
            public,
            params: params
                .into_iter()
                .map(|(i, t, d)| (i, t, d.map(r)))
                .collect(),
            ret,
            body: r(body),
            capabilities,
        },
        NodeKind::Call { func, args } => NodeKind::Call {
            func: r(func),
            args: args.into_iter().map(r).collect(),
        },
        NodeKind::Rt(k) => NodeKind::Rt(r(k)),
        NodeKind::AtResidual { type_, inner } => NodeKind::AtResidual {
            type_,
            inner: r(inner),
        },
        NodeKind::BinaryOp { op, lhs, rhs } => NodeKind::BinaryOp {
            op,
            lhs: r(lhs),
            rhs: r(rhs),
        },
        NodeKind::UnaryOp { op, operand } => NodeKind::UnaryOp {
            op,
            operand: r(operand),
        },
        NodeKind::Cast { type_, operand } => NodeKind::Cast {
            type_,
            operand: r(operand),
        },
        NodeKind::If {
            cond,
            then_branch,
            else_branch,
        } => NodeKind::If {
            cond: r(cond),
            then_branch: r(then_branch),
            else_branch: else_branch.map(r),
        },
        NodeKind::While { cond, body } => NodeKind::While {
            cond: r(cond),
            body: r(body),
        },
        NodeKind::For {
            init,
            cond,
            step,
            body,
        } => NodeKind::For {
            init: r(init),
            cond: r(cond),
            step: r(step),
            body: r(body),
        },
        NodeKind::ForIn { iter, name, body } => NodeKind::ForIn {
            iter: r(iter),
            name,
            body: r(body),
        },
        NodeKind::Match {
            scrutinee,
            arms,
            default_arm,
        } => NodeKind::Match {
            scrutinee: r(scrutinee),
            arms: arms
                .into_iter()
                .map(|(p, k)| (p, r(k)))
                .collect(),
            default_arm: default_arm.map(r),
        },
        NodeKind::Spawn {
            capabilities,
            body,
            ret,
        } => NodeKind::Spawn {
            capabilities,
            body: r(body),
            ret,
        },
        NodeKind::Assert { cond, message } => NodeKind::Assert {
            cond: r(cond),
            message: r(message),
        },
        NodeKind::RtAssert { cond, message } => NodeKind::RtAssert {
            cond: r(cond),
            message: r(message),
        },
        NodeKind::Known(k) => NodeKind::Known(r(k)),
        NodeKind::RtKnown(k) => NodeKind::RtKnown(r(k)),
        NodeKind::ComptimePrint(k) => NodeKind::ComptimePrint(r(k)),
        NodeKind::Todo => NodeKind::Todo,
        NodeKind::Unimplemented => NodeKind::Unimplemented,
        NodeKind::Struct { name, fields } => NodeKind::Struct {
            name,
            fields: fields.into_iter().map(|(n, k)| (n, r(k))).collect(),
        },
        NodeKind::List { elements } => NodeKind::List {
            elements: elements.into_iter().map(r).collect(),
        },
        NodeKind::Map { entries } => NodeKind::Map {
            entries: entries.into_iter().map(|(k, v)| (r(k), r(v))).collect(),
        },
        NodeKind::Set { elements } => NodeKind::Set {
            elements: elements.into_iter().map(r).collect(),
        },
        NodeKind::Range { start, end, closed } => NodeKind::Range {
            start: r(start),
            end: r(end),
            closed,
        },
        NodeKind::FString { parts } => NodeKind::FString {
            parts: parts
                .into_iter()
                .map(|p| FStringPartNode {
                    text: p.text,
                    expr: p.expr.map(r),
                })
                .collect(),
        },
        NodeKind::RawString(_) => kind,
        NodeKind::ByteString(_) => kind,
        NodeKind::FieldAccess { target, field } => NodeKind::FieldAccess {
            target: r(target),
            field,
        },
        NodeKind::Index { target, index } => NodeKind::Index {
            target: r(target),
            index: r(index),
        },
        NodeKind::Slice { target, range } => NodeKind::Slice {
            target: r(target),
            range: r(range),
        },
        NodeKind::MethodCall {
            target,
            method,
            args,
        } => NodeKind::MethodCall {
            target: r(target),
            method,
            args: args.into_iter().map(r).collect(),
        },
        NodeKind::EarlyReturn { value } => NodeKind::EarlyReturn { value: r(value) },
        NodeKind::ElseFallback { value, fallback } => NodeKind::ElseFallback {
            value: r(value),
            fallback: r(fallback),
        },
        NodeKind::Destructure {
            pattern,
            source,
            bindings,
        } => NodeKind::Destructure {
            pattern,
            source: r(source),
            bindings: bindings.into_iter().map(|(n, k)| (n, r(k))).collect(),
        },
        NodeKind::With { bindings, body } => NodeKind::With {
            bindings: bindings
                .into_iter()
                .map(|b| WithBindingNode {
                    type_: b.type_,
                    name: b.name,
                    init: r(b.init),
                })
                .collect(),
            body: r(body),
        },
        NodeKind::ProviderCall {
            provider,
            verb,
            args,
        } => NodeKind::ProviderCall {
            provider,
            verb,
            args: args.into_iter().map(r).collect(),
        },
        NodeKind::BehaviorInstance { behavior, type_ } => NodeKind::BehaviorInstance {
            behavior,
            type_,
        },
        NodeKind::Using { value, behavior } => NodeKind::Using {
            value: r(value),
            behavior,
        },
        NodeKind::RegionError(k) => NodeKind::RegionError(r(k)),
    }
}

impl fmt::Debug for KnowledgeGraph {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("KnowledgeGraph")
            .field("node_count", &self.nodes.len())
            .finish()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn make_span() -> Span {
        Span {
            file: "test".into(),
            line: 1,
            col_start: 0,
            col_end: 2,
        }
    }

    #[test]
    fn test_graph_new() {
        let g = KnowledgeGraph::new();
        assert_eq!(g.nodes.len(), 0);
        assert_eq!(g.next_id, 0);
    }

    #[test]
    fn test_graph_add_node() {
        let mut g = KnowledgeGraph::new();
        let lit = LiteralValue::Int {
            value: 42,
            width: IntWidth::B64,
            signed: true,
        };
        let key = g.add_node(
            NodeKind::Literal(lit.clone()),
            Type::Numeric(NumericType::Int(IntWidth::B64)),
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        assert_eq!(g.nodes.len(), 1);
        let node = g.get_node(key);
        match &node.kind {
            NodeKind::Literal(l) => assert_eq!(l, &lit),
            _ => panic!("expected literal"),
        }
    }

    #[test]
    fn test_graph_set_knowledge() {
        let mut g = KnowledgeGraph::new();
        let key = g.add_node(
            NodeKind::Literal(LiteralValue::Int {
                value: 1,
                width: IntWidth::B8,
                signed: true,
            }),
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        assert_eq!(g.get_node(key).knowledge, KnowledgeState::Known);
        g.set_knowledge(key, KnowledgeState::Residual);
        assert_eq!(g.get_node(key).knowledge, KnowledgeState::Residual);
    }

    #[test]
    fn test_graph_topological_order() {
        let mut g = KnowledgeGraph::new();
        let a = g.add_node(
            NodeKind::Literal(LiteralValue::Int {
                value: 1,
                width: IntWidth::B8,
                signed: true,
            }),
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let b = g.add_node(
            NodeKind::Literal(LiteralValue::Int {
                value: 2,
                width: IntWidth::B8,
                signed: true,
            }),
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let c = g.add_node(
            NodeKind::BinaryOp {
                op: BinOp::Add,
                lhs: a,
                rhs: b,
            },
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Known,
            vec![a, b],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let order = g.topological_order(c);
        // The topological order puts dependents before their dependencies
        assert_eq!(order.len(), 3);
        let c_pos = order.iter().position(|&k| k == c).unwrap();
        let a_pos = order.iter().position(|&k| k == a).unwrap();
        let b_pos = order.iter().position(|&k| k == b).unwrap();
        // c depends on a and b, so c comes first in reverse topo order
        assert!(c_pos < a_pos, "c must come before a in reverse topo order");
        assert!(c_pos < b_pos, "c must come before b in reverse topo order");
    }

    #[test]
    fn test_graph_reachable() {
        let mut g = KnowledgeGraph::new();
        let a = g.add_node(
            NodeKind::Literal(LiteralValue::Int {
                value: 1,
                width: IntWidth::B8,
                signed: true,
            }),
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let b = g.add_node(
            NodeKind::Literal(LiteralValue::Int {
                value: 2,
                width: IntWidth::B8,
                signed: true,
            }),
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let c = g.add_node(
            NodeKind::BinaryOp {
                op: BinOp::Add,
                lhs: a,
                rhs: b,
            },
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Known,
            vec![a, b],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let reachable = g.reachable(c);
        assert!(reachable.contains(&c));
        assert!(reachable.contains(&a));
        assert!(reachable.contains(&b));
    }

    #[test]
    fn test_graph_identifiers() {
        let mut g = KnowledgeGraph::new();
        let lit = g.add_node(
            NodeKind::Literal(LiteralValue::Int {
                value: 1,
                width: IntWidth::B8,
                signed: true,
            }),
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let name = Identifier::new("x", 1);
        let binding = g.add_node(
            NodeKind::Binding { name, def: lit },
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Known,
            vec![lit],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let dup_name = Identifier::new("x", 2);
        let binding2 = g.add_node(
            NodeKind::Binding {
                name: dup_name,
                def: lit,
            },
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Known,
            vec![lit],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let dupes = g.check_uniqueness();
        assert_eq!(dupes.len(), 1);
        assert_eq!(dupes[0].0, "x");
        assert_eq!(dupes[0].1.len(), 2);
        let _ = binding;
        let _ = binding2;
    }

    #[test]
    fn test_graph_function_registration() {
        let mut g = KnowledgeGraph::new();
        let body = g.add_node(
            NodeKind::Literal(LiteralValue::Int {
                value: 0,
                width: IntWidth::B8,
                signed: true,
            }),
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let key = g.add_node(
            NodeKind::Function {
                name: Identifier::new("main", 0),
                public: true,
                params: vec![],
                ret: Type::Numeric(NumericType::Int(IntWidth::B64)),
                body,
                capabilities: HashSet::new(),
            },
            Type::Numeric(NumericType::Int(IntWidth::B64)),
            KnowledgeState::Known,
            vec![body],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        g.register_function("main".into(), key);
        assert!(g.lookup_function("main").is_some());
        assert!(g.lookup_function("nonexistent").is_none());
    }

    #[test]
    fn test_invalid_key() {
        let mut g = KnowledgeGraph::new();
        let key = invalid_key(&mut g);
        let node = g.get_node(key);
        assert_eq!(node.type_, Type::Numeric(NumericType::Int(IntWidth::B64)));
    }

    #[test]
    fn test_replace_node() {
        let mut g = KnowledgeGraph::new();
        let key = g.add_node(
            NodeKind::Literal(LiteralValue::Int {
                value: 1,
                width: IntWidth::B8,
                signed: true,
            }),
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        g.replace_node(
            key,
            NodeKind::Literal(LiteralValue::Int {
                value: 2,
                width: IntWidth::B8,
                signed: true,
            }),
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Known,
        );
        let node = g.get_node(key);
        match &node.kind {
            NodeKind::Literal(LiteralValue::Int { value, .. }) => assert_eq!(*value, 2),
            _ => panic!("expected literal"),
        }
    }

    #[test]
    fn test_entry_point() {
        let mut g = KnowledgeGraph::new();
        assert!(g.get_entry().is_none());
        let key = g.add_node(
            NodeKind::Literal(LiteralValue::Int {
                value: 0,
                width: IntWidth::B8,
                signed: true,
            }),
            Type::Void,
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        g.set_entry(key);
        assert_eq!(g.get_entry(), Some(key));
    }

    #[test]
    fn test_doc_comments() {
        let mut g = KnowledgeGraph::new();
        let key = g.add_node(
            NodeKind::Literal(LiteralValue::Int {
                value: 0,
                width: IntWidth::B8,
                signed: true,
            }),
            Type::Void,
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        assert!(g.get_node(key).doc_comments.is_none());
        g.set_doc_comments(key, vec!["Hello".into(), "World".into()]);
        assert_eq!(
            g.get_node(key).doc_comments,
            Some(vec!["Hello".into(), "World".into()])
        );
    }

    #[test]
    fn test_all_keys() {
        let mut g = KnowledgeGraph::new();
        let a = g.add_node(
            NodeKind::Literal(LiteralValue::Int {
                value: 1,
                width: IntWidth::B8,
                signed: true,
            }),
            Type::Void,
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let b = g.add_node(
            NodeKind::Literal(LiteralValue::Int {
                value: 2,
                width: IntWidth::B8,
                signed: true,
            }),
            Type::Void,
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let keys = g.all_keys();
        assert_eq!(keys.len(), 2);
        assert!(keys.contains(&a));
        assert!(keys.contains(&b));
    }
}
