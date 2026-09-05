//! AST → Knowledge Graph conversion.
//!
//! Two-phase construction: pass 1 registers every function with a placeholder
//! body; pass 2 fills in parameter cells, default expressions, and the real
//! body. Identifiers resolve through a lexical scope stack plus the function
//! table, producing `Reference` nodes that point at `Binding`/param-cells/
//! `Function` definition cells. Block statement layout is recorded in
//! [`KnowledgeGraph::block_info`] so reduction can reconstruct statements.

use crate::GraphKey;
use std::collections::HashMap;
use std::collections::HashSet;

use crate::graph::{
    BlockInfo, FStringPartNode, KnowledgeGraph, KnowledgeState, NodeKind, WithBindingNode,
    invalid_key,
};
use crate::types::*;

/// Errors during AST→IR conversion.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ConversionError {
    UndefinedIdentifier(String, Span),
}
impl std::fmt::Display for ConversionError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ConversionError::UndefinedIdentifier(n, _) => write!(f, "undefined '{}'", n),
        }
    }
}

/// Context for AST→IR conversion.
pub struct AstConverter {
    graph: KnowledgeGraph,
    scope_stack: Vec<HashMap<String, GraphKey>>,
    anon_counter: u64,
}

impl Default for AstConverter {
    fn default() -> Self {
        Self::new()
    }
}

impl AstConverter {
    pub fn new() -> Self {
        AstConverter {
            graph: KnowledgeGraph::new(),
            scope_stack: vec![HashMap::new()],
            anon_counter: 0,
        }
    }
    pub fn into_graph(self) -> KnowledgeGraph {
        self.graph
    }
    pub fn graph_mut(&mut self) -> &mut KnowledgeGraph {
        &mut self.graph
    }

    fn enter_scope(&mut self) {
        self.scope_stack.push(HashMap::new());
    }
    fn exit_scope(&mut self) {
        self.scope_stack.pop();
    }

    fn lookup(&self, name: &str) -> Option<GraphKey> {
        for scope in self.scope_stack.iter().rev() {
            if let Some(k) = scope.get(name) {
                return Some(*k);
            }
        }
        self.graph.lookup_function_key(name)
    }

    fn unique_id(&mut self, name: &str) -> Identifier {
        let id = self.graph.next_id;
        self.graph.next_id += 1;
        Identifier::new(name, id)
    }

    fn mk_node(
        &mut self,
        kind: NodeKind,
        type_: Type,
        knowledge: KnowledgeState,
        deps: Vec<GraphKey>,
        effects: HashSet<Effect>,
        capabilities: HashSet<Capability>,
        span: &Span,
    ) -> GraphKey {
        self.graph.add_node(
            kind,
            type_,
            knowledge,
            deps,
            effects,
            capabilities,
            Provenance::Source {
                file: span.file.clone(),
                line: span.line,
                col_start: span.col_start,
            },
            span.clone(),
        )
    }

    /// Convert a full translation unit.
    pub fn convert(&mut self, unit: AstTranslationUnit) -> Result<KnowledgeGraph, Vec<ConversionError>> {
        // Pass 1: register every function with a placeholder body so calls can
        // resolve to real Function keys and get their return types.
        for func_def in &unit.functions {
            let ret_type = match &func_def.ret {
                Some(s) => type_from_str(s),
                None => Type::Void,
            };
            let capabilities: HashSet<Capability> =
                func_def.capabilities.iter().cloned().collect();
            let fake_body = invalid_key(&mut self.graph);
            let fake_dep = invalid_key(&mut self.graph);
            let fkey = self.graph.add_node(
                NodeKind::Function {
                    name: Identifier::new(&func_def.name, self.graph.next_id),
                    public: func_def.public,
                    params: Vec::new(),
                    ret: ret_type.clone(),
                    body: fake_body,
                    capabilities: capabilities.clone(),
                },
                Type::Function { params: vec![], ret: Box::new(ret_type) },
                if capabilities.is_empty() { KnowledgeState::Known } else { KnowledgeState::Effect },
                vec![fake_dep],
                HashSet::new(),
                capabilities,
                Provenance::Inferred,
                func_def.span.clone(),
            );
            self.graph.register_function(func_def.name.clone(), fkey);
        }

        for func_def in &unit.functions {
            let fkey = self
                .graph
                .lookup_function_key(&func_def.name)
                .expect("function registered in pass 1");
            let (body, params, cells) = self.convert_function_body(func_def)?;
            self.graph.set_function_parts(fkey, body, params);
            self.graph.set_param_cells(fkey, cells);
        }

        // Entry point: main, else the first function.
        let entry = unit
            .functions
            .iter()
            .find(|f| f.name == "main")
            .or_else(|| unit.functions.first());
        if let Some(f) = entry {
            if let Some(k) = self.graph.lookup_function_key(&f.name) {
                self.graph.set_entry(k);
            }
        }

        Ok(self.graph.clone())
    }

    fn convert_function_body(
        &mut self,
        func_def: &AstFuncDef,
    ) -> Result<
        (GraphKey, Vec<(Identifier, Type, Option<GraphKey>)>, Vec<GraphKey>),
        Vec<ConversionError>,
    > {
        self.enter_scope();
        let mut params: Vec<(Identifier, Type, Option<GraphKey>)> = Vec::new();
        let mut cells: Vec<GraphKey> = Vec::new();
        for param in &func_def.params {
            let pid = self.unique_id(&param.name);
            let ptype = match &param.type_ {
                Some(s) => type_from_str(s),
                None => Type::Void,
            };
            // Param cell: a Binding whose def resolves to Null, state Residual,
            // so References to it never fold and β-substitution can override it.
            let fake_def = invalid_key(&mut self.graph);
            let placeholder = self.graph.add_node(
                NodeKind::Binding {
                    name: pid.clone(),
                    def: fake_def,
                },
                Type::Residual(Box::new(ptype.clone())),
                KnowledgeState::Residual,
                vec![],
                HashSet::new(),
                HashSet::new(),
                Provenance::Inferred,
                Span::unknown(),
            );
            self.scope_stack
                .last_mut()
                .unwrap()
                .insert(param.name.clone(), placeholder);
            cells.push(placeholder);
            params.push((pid.clone(), ptype.clone(), None));
        }
        let body_key = self.convert_block(&func_def.body)?;
        self.exit_scope();
        Ok((body_key, params, cells))
    }

    fn convert_block(&mut self, block: &AstBlock) -> Result<GraphKey, Vec<ConversionError>> {
        self.enter_scope();
        let mut anchors: Vec<GraphKey> = Vec::new();
        let mut tail: Option<GraphKey> = None;
        for stmt in &block.statements {
            let k = self.convert_stmt(stmt)?;
            anchors.push(k);
        }
        if let Some(ret) = &block.ret {
            let k = self.convert_expr(ret)?;
            anchors.push(k);
            tail = Some(k);
        }
        let root_key = *anchors.last().unwrap_or(&invalid_key(&mut self.graph));
        self.graph
            .set_block_info(root_key, BlockInfo { anchors, tail });
        self.exit_scope();
        Ok(root_key)
    }

    fn convert_stmt(&mut self, stmt: &AstStmt) -> Result<GraphKey, Vec<ConversionError>> {
        match &stmt.kind {
            AstStmtKind::Bind {
                type_: ty,
                name,
                value,
            } => {
                let vk = self.convert_expr(value)?;
                let vtype = self.get_type(&vk);
                let btype = match ty {
                    Some(s) => type_from_str(s),
                    None => vtype.clone(),
                };
                let bname = self.unique_id(name);
                let key = self.graph.add_node(
                    NodeKind::Binding {
                        name: bname,
                        def: vk,
                    },
                    btype,
                    KnowledgeState::Known,
                    vec![vk],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: stmt.span.file.clone(),
                        line: stmt.span.line,
                        col_start: stmt.span.col_start,
                    },
                    stmt.span.clone(),
                );
                // Bind the name to the new cell in the current scope
                // (shadowing replaces the earlier binding).
                self.scope_stack
                    .last_mut()
                    .unwrap()
                    .insert(name.clone(), key);
                Ok(key)
            }
            AstStmtKind::Discard(inner) => {
                let ik = self.convert_expr(inner)?;
                Ok(self.graph.add_node(
                    NodeKind::Discard { source: ik },
                    self.get_type(&ik),
                    KnowledgeState::Known,
                    vec![ik],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: stmt.span.file.clone(),
                        line: stmt.span.line,
                        col_start: stmt.span.col_start,
                    },
                    stmt.span.clone(),
                ))
            }
            AstStmtKind::Destructure { pattern, source } => {
                let sk = self.convert_expr(source)?;
                let bindings = self.resolve_pattern(pattern)?;
                Ok(self.graph.add_node(
                    NodeKind::Destructure {
                        pattern: convert_ast_pattern(pattern.clone()),
                        source: sk,
                        bindings,
                    },
                    Type::Void,
                    KnowledgeState::Known,
                    vec![sk],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: stmt.span.file.clone(),
                        line: stmt.span.line,
                        col_start: stmt.span.col_start,
                    },
                    stmt.span.clone(),
                ))
            }
            AstStmtKind::Expr(e) => self.convert_expr(e),
            AstStmtKind::Return(v) => match v {
                Some(inner) => {
                    let ik = self.convert_expr(inner)?;
                    Ok(self.graph.add_node(
                        NodeKind::EarlyReturn { value: ik },
                        Type::Void,
                        KnowledgeState::Known,
                        vec![ik],
                        HashSet::new(),
                        HashSet::new(),
                        Provenance::Source {
                            file: stmt.span.file.clone(),
                            line: stmt.span.line,
                            col_start: stmt.span.col_start,
                        },
                        stmt.span.clone(),
                    ))
                }
                None => {
                    let null = self.lit(LiteralValue::Null, &Type::Null);
                    Ok(self.mk_node(
                        NodeKind::EarlyReturn { value: null },
                        Type::Void,
                        KnowledgeState::Known,
                        vec![null],
                        HashSet::new(),
                        HashSet::new(),
                        &stmt.span,
                    ))
                }
            },
            AstStmtKind::Break => Ok(self.mk_node(
                NodeKind::Break,
                Type::Void,
                KnowledgeState::Known,
                vec![],
                HashSet::new(),
                HashSet::new(),
                &stmt.span,
            )),
            AstStmtKind::Continue => Ok(self.mk_node(
                NodeKind::Continue,
                Type::Void,
                KnowledgeState::Known,
                vec![],
                HashSet::new(),
                HashSet::new(),
                &stmt.span,
            )),
        }
    }

    fn lit(&mut self, lit: LiteralValue, ty: &Type) -> GraphKey {
        self.graph.add_node(
            NodeKind::Literal(lit),
            ty.clone(),
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            Span::unknown(),
        )
    }

    /// Convert an AST expression to an IR node.
    fn convert_range(&mut self, range: &AstRange) -> Result<GraphKey, Vec<ConversionError>> {
        let start_k = match &range.start {
            Some(s) => Some(self.convert_expr(s)?),
            None => None,
        };
        let end_k = match &range.end {
            Some(e) => Some(self.convert_expr(e)?),
            None => None,
        };
        let deps: Vec<GraphKey> = start_k.iter().chain(end_k.iter()).cloned().collect();
        let mut default_key = || {
            let n = NodeKind::Literal(LiteralValue::Int {
                value: 0,
                width: IntWidth::B64,
                signed: true,
            });
            self.graph.add_node(
                n,
                Type::Numeric(NumericType::Int(IntWidth::B64)),
                KnowledgeState::Known,
                vec![],
                HashSet::new(),
                HashSet::new(),
                Provenance::Inferred,
                Span::unknown(),
            )
        };
        let s_key = start_k.unwrap_or_else(&mut default_key);
        let e_key = end_k.unwrap_or_else(default_key);
        let s_type = self.get_type(&s_key);
        let e_type = self.get_type(&e_key);
        let type_ = match (s_type, e_type) {
            (Type::Numeric(st), Type::Numeric(et)) => {
                match numeric_result_type(&st, BinOp::Add, &et) {
                    ResultType::Numeric(nt) => Type::Numeric(nt),
                    ResultType::Bool => Type::Bool,
                    ResultType::Error(_) => Type::Void,
                }
            }
            (t, _) => t,
        };
        Ok(self.graph.add_node(
            NodeKind::Range {
                start: s_key,
                end: e_key,
                closed: range.closed,
            },
            type_,
            KnowledgeState::Known,
            deps,
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            Span::unknown(),
        ))
    }

    fn convert_expr(&mut self, expr: &AstExpr) -> Result<GraphKey, Vec<ConversionError>> {
        match expr {
            AstExpr::Id(name) => self.convert_id(name, &expr.span()),
            AstExpr::Literal {
                value,
                kind: _,
                span,
            } => {
                let ty = Type::Numeric(NumericType::Int(IntWidth::B64));
                Ok(self.mk_node(
                    NodeKind::Literal(LiteralValue::Int {
                        value: *value,
                        width: IntWidth::B64,
                        signed: true,
                    }),
                    ty,
                    KnowledgeState::Known,
                    vec![],
                    HashSet::new(),
                    HashSet::new(),
                    span,
                ))
            }
            AstExpr::FloatLit { value, span } => {
                let ty = Type::Numeric(NumericType::Float(FloatWidth::F64));
                Ok(self.mk_node(
                    NodeKind::Literal(LiteralValue::Float {
                        value: value.clone(),
                        width: FloatWidth::F64,
                    }),
                    ty,
                    KnowledgeState::Known,
                    vec![],
                    HashSet::new(),
                    HashSet::new(),
                    span,
                ))
            }
            AstExpr::StrLit { value, span } => Ok(self.mk_node(
                NodeKind::Literal(LiteralValue::Str(value.clone())),
                Type::Str,
                KnowledgeState::Known,
                vec![],
                HashSet::new(),
                HashSet::new(),
                span,
            )),
            AstExpr::BoolLit(v, span) => Ok(self.mk_node(
                NodeKind::Literal(LiteralValue::Bool(*v)),
                Type::Bool,
                KnowledgeState::Known,
                vec![],
                HashSet::new(),
                HashSet::new(),
                span,
            )),
            AstExpr::NullLit(span) => Ok(self.mk_node(
                NodeKind::Literal(LiteralValue::Null),
                Type::Null,
                KnowledgeState::Known,
                vec![],
                HashSet::new(),
                HashSet::new(),
                span,
            )),
            AstExpr::CharLit(c, span) => Ok(self.mk_node(
                NodeKind::Literal(LiteralValue::Char(*c)),
                Type::Numeric(NumericType::Int(IntWidth::B16)),
                KnowledgeState::Known,
                vec![],
                HashSet::new(),
                HashSet::new(),
                span,
            )),
            AstExpr::Location(span) => Ok(self.mk_node(
                NodeKind::Location,
                Type::SourceLoc,
                KnowledgeState::Known,
                vec![],
                HashSet::new(),
                HashSet::new(),
                span,
            )),
            AstExpr::BinaryOp { op, lhs, rhs, span } => {
                let lk = self.convert_expr(lhs)?;
                let rk = self.convert_expr(rhs)?;
                let (rt, ks) = self.binop_type(&lk, op, &rk);
                Ok(self.graph.add_node(
                    NodeKind::BinaryOp {
                        op: *op,
                        lhs: lk,
                        rhs: rk,
                    },
                    rt,
                    ks,
                    vec![lk, rk],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::UnaryOp { op, operand, span } => {
                let ok = self.convert_expr(operand)?;
                let rt = unary_type(op, &self.get_type(&ok));
                Ok(self.graph.add_node(
                    NodeKind::UnaryOp {
                        op: op.clone(),
                        operand: ok,
                    },
                    rt,
                    KnowledgeState::Known,
                    vec![ok],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::Call { func, args, span } => {
                let fk = match func.as_ref() {
                    AstExpr::Id(name) => match self.lookup(name) {
                        Some(k) => k,
                        None => self.ad_hoc_function(name, span),
                    },
                    _ => self.convert_expr(func)?,
                };
                let mut aks = Vec::new();
                let mut errs = Vec::new();
                for (_, arg) in args {
                    match self.convert_expr(arg) {
                        Ok(k) => aks.push(k),
                        Err(e) => errs.extend(e),
                    }
                }
                if !errs.is_empty() {
                    return Err(errs);
                }
                let rt = self.call_ret_type(&fk);
                let deps: Vec<GraphKey> = std::iter::once(fk).chain(aks.iter().cloned()).collect();
                Ok(self.graph.add_node(
                    NodeKind::Call {
                        func: fk,
                        args: aks,
                    },
                    rt,
                    self.call_knowledge(&fk),
                    deps,
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::Rt(inner, span) => {
                let ik = self.convert_expr(inner)?;
                let it = self.get_type(&ik);
                Ok(self.graph.add_node(
                    NodeKind::Rt(ik),
                    Type::Residual(Box::new(it)),
                    KnowledgeState::Residual,
                    vec![ik],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Residual,
                    span.clone(),
                ))
            }
            AstExpr::AtResidual { type_, inner, span } => {
                let ik = self.convert_expr(inner)?;
                Ok(self.graph.add_node(
                    NodeKind::AtResidual {
                        type_: type_.clone(),
                        inner: ik,
                    },
                    type_.clone(),
                    KnowledgeState::Residual,
                    vec![ik],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::If {
                cond,
                then_block,
                else_block,
                span,
            } => {
                let ck = self.convert_expr(cond)?;
                let tk = self.convert_block(then_block)?;
                let ek = match else_block {
                    Some(b) => Some(self.convert_block(b)?),
                    None => None,
                };
                let tt = self.get_type(&tk);
                let et = match &ek {
                    Some(k) => self.get_type(k),
                    None => Type::Void,
                };
                let result_type = if tt == et {
                    tt
                } else {
                    Type::Option(Box::new(tt))
                };
                let mut deps = vec![ck, tk];
                if let Some(k) = ek {
                    deps.push(k);
                }
                Ok(self.graph.add_node(
                    NodeKind::If {
                        cond: ck,
                        then_branch: tk,
                        else_branch: ek,
                    },
                    result_type,
                    KnowledgeState::Known,
                    deps,
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::While { cond, body, span } => {
                let ck = self.convert_expr(cond)?;
                let bk = self.convert_block(body)?;
                Ok(self.graph.add_node(
                    NodeKind::While { cond: ck, body: bk },
                    Type::Void,
                    KnowledgeState::Known,
                    vec![ck, bk],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::ForIn {
                type_: _ty_str,
                name,
                collection,
                body,
                span,
            } => {
                let ik = self.convert_expr(collection)?;
                let bk = self.convert_block(body)?;
                self.enter_scope();
                let _lv = self.unique_id(name);
                self.exit_scope();
                Ok(self.graph.add_node(
                    NodeKind::ForIn {
                        iter: ik,
                        name: Identifier::new(name, self.graph.next_id),
                        body: bk,
                    },
                    Type::Void,
                    KnowledgeState::Known,
                    vec![ik, bk],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::Match {
                scrutinee,
                arms,
                span,
            } => {
                let sk = self.convert_expr(scrutinee)?;
                let mut ak = Vec::new();
                for (pat, ae) in arms {
                    let k = self.convert_expr(ae)?;
                    ak.push((convert_ast_pattern(pat.clone()), k));
                }
                let deps: Vec<GraphKey> = std::iter::once(sk)
                    .chain(ak.iter().map(|(_, k)| *k))
                    .collect();
                Ok(self.graph.add_node(
                    NodeKind::Match {
                        scrutinee: sk,
                        arms: ak,
                        default_arm: None,
                    },
                    Type::Void,
                    KnowledgeState::Known,
                    deps,
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::For {
                init,
                cond,
                step,
                body,
                span,
            } => {
                let init_k = match init {
                    Some(s) => self.convert_stmt(s)?,
                    None => self.graph.add_node(
                        NodeKind::Literal(LiteralValue::Null),
                        Type::Null,
                        KnowledgeState::Known,
                        vec![],
                        HashSet::new(),
                        HashSet::new(),
                        Provenance::Inferred,
                        Span::unknown(),
                    ),
                };
                let ck = self.convert_expr(cond)?;
                let step_k = match step {
                    Some(s) => self.convert_stmt(s)?,
                    None => self.graph.add_node(
                        NodeKind::Literal(LiteralValue::Null),
                        Type::Null,
                        KnowledgeState::Known,
                        vec![],
                        HashSet::new(),
                        HashSet::new(),
                        Provenance::Inferred,
                        Span::unknown(),
                    ),
                };
                let bk = self.convert_block(body)?;
                Ok(self.graph.add_node(
                    NodeKind::For {
                        init: init_k,
                        cond: ck,
                        step: step_k,
                        body: bk,
                    },
                    Type::Void,
                    KnowledgeState::Known,
                    vec![init_k, ck, step_k, bk],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::StructLit { name, fields, span } => {
                let sid = Identifier::new(name, self.graph.next_id);
                let mut fps = Vec::new();
                let mut errs = Vec::new();
                for (fn_, fe) in fields {
                    match self.convert_expr(fe) {
                        Ok(k) => {
                            fps.push((Identifier::new(fn_, self.graph.next_id), k));
                            self.graph.next_id += 1;
                        }
                        Err(e) => errs.extend(e),
                    }
                }
                if !errs.is_empty() {
                    return Err(errs);
                }
                let ft = Type::Struct(
                    sid.clone(),
                    fps.iter()
                        .map(|(n, k)| (n.clone(), self.get_type(k)))
                        .collect::<Vec<_>>(),
                );
                Ok(self.graph.add_node(
                    NodeKind::Struct {
                        name: sid,
                        fields: fps.clone(),
                    },
                    ft,
                    KnowledgeState::Known,
                    fps.iter().map(|(_, k)| *k).collect(),
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::ListLit(elts, span) => {
                let mut ek = Vec::new();
                let mut errs = Vec::new();
                for e in elts {
                    match self.convert_expr(e) {
                        Ok(k) => ek.push(k),
                        Err(e2) => errs.extend(e2),
                    }
                }
                if !errs.is_empty() {
                    return Err(errs);
                }
                let et = ek.first().map(|k| self.get_type(k)).unwrap_or(Type::Void);
                let deps: Vec<GraphKey> = ek.clone();
                Ok(self.graph.add_node(
                    NodeKind::List { elements: ek },
                    Type::List(Box::new(et)),
                    KnowledgeState::Known,
                    deps,
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::MapLit(entries, span) => {
                let mut eps = Vec::new();
                let mut errs = Vec::new();
                for (k, v) in entries {
                    match self.convert_expr(k) {
                        Ok(kk) => match self.convert_expr(v) {
                            Ok(vk) => eps.push((kk, vk)),
                            Err(e) => errs.extend(e),
                        },
                        Err(e) => errs.extend(e),
                    }
                }
                if !errs.is_empty() {
                    return Err(errs);
                }
                let deps: Vec<GraphKey> = eps.iter().flat_map(|(k, v)| vec![*k, *v]).collect();
                Ok(self.graph.add_node(
                    NodeKind::Map { entries: eps },
                    Type::Void,
                    KnowledgeState::Known,
                    deps,
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::SetLit(elts, span) => {
                let mut ek = Vec::new();
                let mut errs = Vec::new();
                for e in elts {
                    match self.convert_expr(e) {
                        Ok(k) => ek.push(k),
                        Err(e2) => errs.extend(e2),
                    }
                }
                if !errs.is_empty() {
                    return Err(errs);
                }
                let et = ek.first().map(|k| self.get_type(k)).unwrap_or(Type::Void);
                let deps: Vec<GraphKey> = ek.clone();
                Ok(self.graph.add_node(
                    NodeKind::Set { elements: ek },
                    Type::Set(Box::new(et)),
                    KnowledgeState::Known,
                    deps,
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::Range {
                start,
                end,
                closed,
                span,
            } => {
                let sk = self.convert_expr(start)?;
                let ek = self.convert_expr(end)?;
                Ok(self.graph.add_node(
                    NodeKind::Range {
                        start: sk,
                        end: ek,
                        closed: *closed,
                    },
                    Type::Range {
                        start_type: Box::new(self.get_type(&sk)),
                        end_type: Box::new(self.get_type(&ek)),
                        closed: *closed,
                    },
                    KnowledgeState::Known,
                    vec![sk, ek],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::FString(parts, span) => {
                let mut pns = Vec::new();
                let mut errs = Vec::new();
                for p in parts {
                    match p {
                        AstFStringPart::Text(t) => pns.push(FStringPartNode {
                            text: t.clone(),
                            expr: None,
                        }),
                        AstFStringPart::Expr(e) => match self.convert_expr(e) {
                            Ok(k) => pns.push(FStringPartNode {
                                text: String::new(),
                                expr: Some(k),
                            }),
                            Err(e2) => errs.extend(e2),
                        },
                    }
                }
                if !errs.is_empty() {
                    return Err(errs);
                }
                let deps: Vec<GraphKey> = pns.iter().filter_map(|p| p.expr).collect();
                Ok(self.graph.add_node(
                    NodeKind::FString { parts: pns },
                    Type::Str,
                    KnowledgeState::Known,
                    deps,
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::RawString(v, span) => Ok(self.graph.add_node(
                NodeKind::RawString(v.clone()),
                Type::Str,
                KnowledgeState::Known,
                vec![],
                HashSet::new(),
                HashSet::new(),
                Provenance::Source {
                    file: span.file.clone(),
                    line: span.line,
                    col_start: span.col_start,
                },
                span.clone(),
            )),
            AstExpr::ByteString(v, span) => Ok(self.graph.add_node(
                NodeKind::ByteString(v.clone()),
                Type::Bytes,
                KnowledgeState::Known,
                vec![],
                HashSet::new(),
                HashSet::new(),
                Provenance::Source {
                    file: span.file.clone(),
                    line: span.line,
                    col_start: span.col_start,
                },
                span.clone(),
            )),
            AstExpr::FieldAccess {
                target,
                field,
                span,
            } => {
                let tk = self.convert_expr(target)?;
                Ok(self.graph.add_node(
                    NodeKind::FieldAccess {
                        target: tk,
                        field: Identifier::new(field, self.graph.next_id),
                    },
                    Type::Void,
                    KnowledgeState::Known,
                    vec![tk],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::Index {
                target,
                index,
                span,
            } => {
                let tk = self.convert_expr(target)?;
                let ik = self.convert_expr(index)?;
                Ok(self.graph.add_node(
                    NodeKind::Index {
                        target: tk,
                        index: ik,
                    },
                    Type::Void,
                    KnowledgeState::Known,
                    vec![tk, ik],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::Slice {
                target,
                range,
                span,
            } => {
                let tk = self.convert_expr(target)?;
                let rk = self.convert_range(range)?;
                Ok(self.graph.add_node(
                    NodeKind::Slice {
                        target: tk,
                        range: rk,
                    },
                    Type::Void,
                    KnowledgeState::Known,
                    vec![tk, rk],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::MethodCall {
                target,
                method,
                args,
                span,
            } => {
                let tk = self.convert_expr(target)?;
                let mut aks = Vec::new();
                let mut errs = Vec::new();
                for a in args {
                    match self.convert_expr(a) {
                        Ok(k) => aks.push(k),
                        Err(e) => errs.extend(e),
                    }
                }
                if !errs.is_empty() {
                    return Err(errs);
                }
                let deps: Vec<GraphKey> = std::iter::once(tk).chain(aks.iter().cloned()).collect();
                Ok(self.graph.add_node(
                    NodeKind::MethodCall {
                        target: tk,
                        method: Identifier::new(method, self.graph.next_id),
                        args: aks,
                    },
                    Type::Void,
                    KnowledgeState::Known,
                    deps,
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::EarlyReturn(inner, span) => {
                let ik = self.convert_expr(inner)?;
                Ok(self.graph.add_node(
                    NodeKind::EarlyReturn { value: ik },
                    Type::Void,
                    KnowledgeState::Known,
                    vec![ik],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::ElseFallback {
                value,
                fallback,
                span,
            } => {
                let vk = self.convert_expr(value)?;
                let fk = self.convert_block(fallback)?;
                Ok(self.graph.add_node(
                    NodeKind::ElseFallback {
                        value: vk,
                        fallback: fk,
                    },
                    Type::Void,
                    KnowledgeState::Known,
                    vec![vk, fk],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::Destructure {
                pattern,
                source,
                span,
            } => {
                let sk = self.convert_expr(source)?;
                let bindings = self.resolve_pattern(pattern)?;
                Ok(self.graph.add_node(
                    NodeKind::Destructure {
                        pattern: convert_ast_pattern(pattern.clone()),
                        source: sk,
                        bindings,
                    },
                    Type::Void,
                    KnowledgeState::Known,
                    vec![sk],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::IfLet {
                pattern: _,
                source,
                then_block,
                else_block,
                span,
            } => {
                let sk = self.convert_expr(source)?;
                let tk = self.convert_block(then_block)?;
                let ek = match else_block {
                    Some(b) => Some(self.convert_block(b)?),
                    None => None,
                };
                Ok(self.graph.add_node(
                    NodeKind::If {
                        cond: sk,
                        then_branch: tk,
                        else_branch: ek,
                    },
                    Type::Void,
                    KnowledgeState::Known,
                    vec![sk, tk],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::WhileLet {
                pattern,
                source,
                body,
                span,
            } => {
                let _ = pattern;
                let sk = self.convert_expr(source)?;
                let bk = self.convert_block(body)?;
                Ok(self.graph.add_node(
                    NodeKind::While { cond: sk, body: bk },
                    Type::Void,
                    KnowledgeState::Known,
                    vec![sk, bk],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::With {
                bindings,
                body,
                span,
            } => {
                let bk = self.convert_block(body)?;
                let mut bns = Vec::new();
                let mut errs = Vec::new();
                for b in bindings {
                    let ik = match self.convert_expr(&b.init) {
                        Ok(k) => k,
                        Err(e) => {
                            errs.extend(e);
                            continue;
                        }
                    };
                    let t = match &b.type_ {
                        Some(s) => type_from_str(s),
                        None => Type::Void,
                    };
                    bns.push(WithBindingNode {
                        type_: t,
                        name: self.unique_id(&b.name),
                        init: ik,
                    });
                }
                if !errs.is_empty() {
                    return Err(errs);
                }
                let deps: Vec<GraphKey> = std::iter::once(bk)
                    .chain(bns.iter().map(|b| b.init))
                    .collect();
                Ok(self.graph.add_node(
                    NodeKind::With {
                        bindings: bns,
                        body: bk,
                    },
                    Type::Void,
                    KnowledgeState::Known,
                    deps,
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::Using {
                value,
                behavior,
                span,
            } => {
                let vk = self.convert_expr(value)?;
                Ok(self.graph.add_node(
                    NodeKind::Using {
                        value: vk,
                        behavior: BehaviorRef {
                            name: Identifier::new(behavior, self.graph.next_id),
                            type_params: vec![],
                        },
                    },
                    self.get_type(&vk),
                    KnowledgeState::Known,
                    vec![vk],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::Discard(inner, span) => {
                let ik = self.convert_expr(inner)?;
                Ok(self.graph.add_node(
                    NodeKind::Discard { source: ik },
                    self.get_type(&ik),
                    KnowledgeState::Known,
                    vec![ik],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::ProviderCall {
                provider,
                verb,
                args,
                span,
            } => {
                let prov = match provider.as_str() {
                    "filesystem" => Provider::Filesystem,
                    "environment" => Provider::Environment,
                    "git" => Provider::Git,
                    _ => Provider::Environment,
                };
                let mut aks = Vec::new();
                let mut errs = Vec::new();
                for a in args {
                    match self.convert_expr(a) {
                        Ok(k) => aks.push(k),
                        Err(e) => errs.extend(e),
                    }
                }
                if !errs.is_empty() {
                    return Err(errs);
                }
                let deps: Vec<GraphKey> = aks.clone();
                let effects: HashSet<Effect> = HashSet::from([Effect::Provider(prov.clone())]);
                let provenance = Provenance::Provider(prov.clone());
                Ok(self.graph.add_node(
                    NodeKind::ProviderCall {
                        provider: prov.clone(),
                        verb: Identifier::new(verb, self.graph.next_id),
                        args: aks.clone(),
                    },
                    Type::Str,
                    KnowledgeState::Effect,
                    deps,
                    effects,
                    HashSet::new(),
                    provenance,
                    span.clone(),
                ))
            }
            AstExpr::Known(inner, span) => {
                let ik = self.convert_expr(inner)?;
                Ok(self.graph.add_node(
                    NodeKind::Known(ik),
                    self.get_type(&ik),
                    KnowledgeState::Known,
                    vec![ik],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::RtKnown(inner, span) => {
                let ik = self.convert_expr(inner)?;
                Ok(self.graph.add_node(
                    NodeKind::RtKnown(ik),
                    self.get_type(&ik),
                    KnowledgeState::Residual,
                    vec![ik],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::ComptimePrint(inner, span) => {
                let ik = self.convert_expr(inner)?;
                Ok(self.graph.add_node(
                    NodeKind::ComptimePrint(ik),
                    Type::Void,
                    KnowledgeState::Known,
                    vec![ik],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::Todo(span) => Ok(self.graph.add_node(
                NodeKind::Todo,
                Type::Void,
                KnowledgeState::Invalid,
                vec![],
                HashSet::new(),
                HashSet::new(),
                Provenance::Source {
                    file: span.file.clone(),
                    line: span.line,
                    col_start: span.col_start,
                },
                span.clone(),
            )),
            AstExpr::Unimplemented(span) => Ok(self.graph.add_node(
                NodeKind::Unimplemented,
                Type::Void,
                KnowledgeState::Invalid,
                vec![],
                HashSet::new(),
                HashSet::new(),
                Provenance::Source {
                    file: span.file.clone(),
                    line: span.line,
                    col_start: span.col_start,
                },
                span.clone(),
            )),
            AstExpr::Assert {
                cond,
                message,
                span,
            } => {
                let ck = self.convert_expr(cond)?;
                let mk = self.convert_expr(message)?;
                Ok(self.graph.add_node(
                    NodeKind::Assert {
                        cond: ck,
                        message: mk,
                    },
                    Type::Void,
                    KnowledgeState::Known,
                    vec![ck, mk],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::RtAssert {
                cond,
                message,
                span,
            } => {
                let ck = self.convert_expr(cond)?;
                let mk = self.convert_expr(message)?;
                Ok(self.graph.add_node(
                    NodeKind::RtAssert {
                        cond: ck,
                        message: mk,
                    },
                    Type::Void,
                    KnowledgeState::Residual,
                    vec![ck, mk],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::Spawn {
                capabilities,
                body,
                span,
            } => {
                let bk = self.convert_block(body)?;
                Ok(self.graph.add_node(
                    NodeKind::Spawn {
                        capabilities: capabilities.iter().cloned().collect(),
                        body: bk,
                        ret: Type::Void,
                    },
                    Type::Void,
                    KnowledgeState::Effect,
                    vec![bk],
                    HashSet::from([Effect::ConcurrencySpawn]),
                    capabilities.iter().cloned().collect(),
                    Provenance::Source {
                        file: span.file.clone(),
                        line: span.line,
                        col_start: span.col_start,
                    },
                    span.clone(),
                ))
            }
            AstExpr::Span(span) => Ok(self.graph.add_node(
                NodeKind::Literal(LiteralValue::Null),
                Type::Void,
                KnowledgeState::Known,
                vec![],
                HashSet::new(),
                HashSet::new(),
                Provenance::Source {
                    file: span.file.clone(),
                    line: span.line,
                    col_start: span.col_start,
                },
                span.clone(),
            )),
        }
    }

    /// Create an external/builtin callee: a Function node with an invalid body
    /// that is *not* registered in the function table, so it never inlines and
    /// retro reconstructs the call from its name.
    fn ad_hoc_function(&mut self, name: &str, span: &Span) -> GraphKey {
        let body = invalid_key(&mut self.graph);
        let dep = invalid_key(&mut self.graph);
        self.graph.add_node(
            NodeKind::Function {
                name: Identifier::new(name, self.graph.next_id),
                public: false,
                params: Vec::new(),
                ret: Type::Void,
                body,
                capabilities: HashSet::new(),
            },
            Type::Function {
                params: vec![],
                ret: Box::new(Type::Void),
            },
            KnowledgeState::Known,
            vec![dep],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            span.clone(),
        )
    }

    fn convert_id(&mut self, name: &str, span: &Span) -> Result<GraphKey, Vec<ConversionError>> {
        match self.lookup(name) {
            Some(def) => {
                let def_type = self.get_type(&def);
                Ok(self.mk_node(
                    NodeKind::Reference {
                        name: Identifier::new(name, self.graph.next_id),
                        def,
                    },
                    def_type,
                    KnowledgeState::Residual,
                    vec![def],
                    HashSet::new(),
                    HashSet::new(),
                    span,
                ))
            }
            None => Err(vec![ConversionError::UndefinedIdentifier(
                name.to_string(),
                span.clone(),
            )]),
        }
    }

    fn resolve_pattern(
        &mut self,
        pattern: &AstPattern,
    ) -> Result<Vec<(Identifier, GraphKey)>, Vec<ConversionError>> {
        let mut bindings = Vec::new();
        match &pattern.kind {
            AstPatternKind::Bind(name) => {
                let id = self.unique_id(name);
                let def = invalid_key(&mut self.graph);
                bindings.push((id, def));
            }
            AstPatternKind::Variant { name: _, param } => {
                if let Some(p) = param {
                    let id = self.unique_id(p);
                    let def = self.convert_id(p, &pattern.span)?;
                    bindings.push((id, def));
                }
            }
            AstPatternKind::Struct { name: _, fields } => {
                for (_, fp) in fields {
                    bindings.extend(self.resolve_pattern(fp)?);
                }
            }
            AstPatternKind::Wildcard | AstPatternKind::Literal(_) => {}
        }
        Ok(bindings)
    }

    fn get_type(&self, key: &GraphKey) -> Type {
        if let Some(node) = self.graph.get_node_checked(*key) {
            node.type_.clone()
        } else {
            Type::Void
        }
    }

    fn binop_type(&self, lk: &GraphKey, op: &BinOp, rk: &GraphKey) -> (Type, KnowledgeState) {
        fn strip(t: &Type) -> &Type {
            match t {
                Type::Residual(inner) => &**inner,
                other => other,
            }
        }
        let lt = strip(&self.get_type(lk)).clone();
        let rt = strip(&self.get_type(rk)).clone();
        match (&lt, &rt) {
            (Type::Numeric(lt2), Type::Numeric(rt2)) => match numeric_result_type(lt2, *op, rt2) {
                ResultType::Numeric(ty) => (Type::Numeric(ty), KnowledgeState::Known),
                ResultType::Bool => (Type::Bool, KnowledgeState::Known),
                ResultType::Error(_) => (Type::Void, KnowledgeState::Invalid),
            },
            (Type::Bool, Type::Bool) => (Type::Bool, KnowledgeState::Known),
            _ => (Type::Void, KnowledgeState::Known),
        }
    }

    fn call_ret_type(&self, fk: &GraphKey) -> Type {
        if let Some(fn_node) = self.graph.get_node_checked(*fk)
            && let NodeKind::Function { ret, .. } = &fn_node.kind {
                return ret.clone();
            }
        Type::Void
    }

    fn call_knowledge(&self, fk: &GraphKey) -> KnowledgeState {
        if let Some(fn_node) = self.graph.get_node_checked(*fk) {
            if let NodeKind::Function { capabilities, .. } = &fn_node.kind {
                if capabilities.is_empty() {
                    KnowledgeState::Known
                } else {
                    KnowledgeState::Effect
                }
            } else {
                KnowledgeState::Known
            }
        } else {
            KnowledgeState::Known
        }
    }
}

// ─── Helpers ───────────────────────────────────────────────────────

fn type_from_str(s: &str) -> Type {
    if let Some(nt) = numeric_type_from_str(s) {
        return Type::Numeric(nt);
    }
    if let Some(inner) = strip_param_type(s, "List") {
        return Type::List(Box::new(type_from_str(&inner)));
    }
    if let Some(inner) = strip_param_type(s, "Map")
        && let Some((k, v)) = inner.split_once(',')
    {
        return Type::Map(
            Box::new(type_from_str(k.trim())),
            Box::new(type_from_str(v.trim())),
        );
    }
    if let Some(inner) = strip_param_type(s, "Set") {
        return Type::Set(Box::new(type_from_str(&inner)));
    }
    if let Some(inner) = strip_param_type(s, "Option") {
        return Type::Option(Box::new(type_from_str(&inner)));
    }
    if let Some(inner) = strip_param_type(s, "Result")
        && let Some((ok, er)) = inner.split_once(',')
    {
        return Type::Result(
            Box::new(type_from_str(ok.trim())),
            Box::new(type_from_str(er.trim())),
        );
    }
    if let Some(inner) = strip_param_type(s, "Slice") {
        return Type::Slice {
            element_type: Box::new(type_from_str(&inner)),
        };
    }
    if let Some(inner) = strip_param_type(s, "Range") {
        let elem = type_from_str(&inner);
        return Type::Range {
            start_type: Box::new(elem.clone()),
            end_type: Box::new(elem),
            closed: false,
        };
    }
    match s {
        "Bool" => Type::Bool,
        "Str" => Type::Str,
        "Bytes" => Type::Bytes,
        "Null" => Type::Null,
        "Void" => Type::Void,
        "" => Type::Void,
        _ => Type::UserDefined(s.into()),
    }
}

fn strip_param_type(s: &str, name: &str) -> Option<String> {
    let rest = s.trim().strip_prefix(name)?;
    let rest = rest.strip_prefix('(')?;
    let rest = rest.strip_suffix(')')?;
    Some(rest.to_string())
}

fn numeric_type_from_str(s: &str) -> Option<NumericType> {
    if let Some(nt) = NumericType::from_name(s) {
        return Some(nt);
    }
    if let Some(rest) = s.strip_prefix("Int(").and_then(|r| r.strip_suffix(')'))
        && let Ok(w) = rest.parse::<u16>()
    {
        return IntWidth::from_bits(w).map(NumericType::Int);
    }
    if let Some(rest) = s.strip_prefix("UInt(").and_then(|r| r.strip_suffix(')'))
        && let Ok(w) = rest.parse::<u16>()
    {
        return IntWidth::from_bits(w).map(NumericType::UInt);
    }
    if let Some(rest) = s.strip_prefix("Float(").and_then(|r| r.strip_suffix(')'))
        && let Ok(w) = rest.parse::<u16>()
    {
        return FloatWidth::from_bits(w).map(NumericType::Float);
    }
    if let Some(rest) = s.strip_prefix("Dec(").and_then(|r| r.strip_suffix(')'))
        && let Ok(w) = rest.parse::<u16>()
    {
        return Some(NumericType::Dec(w.max(1)));
    }
    None
}

fn unary_type(op: &UnaryOp, t: &Type) -> Type {
    match op {
        UnaryOp::Neg => t.clone(),
        UnaryOp::Not => Type::Bool,
        UnaryOp::BitNot => t.clone(),
        UnaryOp::Cast(ty) => (**ty).clone(),
    }
}

fn convert_ast_pattern(pattern: AstPattern) -> Pattern {
    Pattern {
        kind: convert_ast_pattern_kind(pattern.kind),
    }
}

fn convert_ast_pattern_kind(kind: AstPatternKind) -> PatternKind {
    match kind {
        AstPatternKind::Wildcard => PatternKind::Wildcard,
        AstPatternKind::Bind(n) => PatternKind::Bind(Identifier::new(n, 0)),
        AstPatternKind::Variant { name, param } => PatternKind::Variant {
            name: Identifier::new(name, 0),
            param: param.map(|p| Identifier::new(p, 0)),
        },
        AstPatternKind::Literal(v) => PatternKind::Literal(LiteralValue::Int {
            value: v,
            width: IntWidth::B64,
            signed: true,
        }),
        AstPatternKind::Struct { name, fields } => PatternKind::Struct {
            name: Identifier::new(name, 0),
            fields: fields
                .into_iter()
                .map(|(n, p)| (Identifier::new(n, 0), convert_ast_pattern(p)))
                .collect(),
        },
    }
}

impl AstExpr {
    fn span(&self) -> Span {
        Span::unknown()
    }
}
