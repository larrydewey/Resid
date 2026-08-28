//! AST → Knowledge Graph conversion.

use crate::GraphKey;
use std::collections::HashSet;

use crate::graph::{
    FStringPartNode, KnowledgeGraph, KnowledgeState, NodeKind, WithBindingNode, invalid_key,
};
use crate::types::*;

/// Errors during AST→IR conversion.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ConversionError {
    Shadowing(String, u64, u64),
    UndefinedIdentifier(String, Span),
}
impl std::fmt::Display for ConversionError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ConversionError::Shadowing(n, a, b) => write!(f, "shadowing '{}': {} vs {}", n, a, b),
            ConversionError::UndefinedIdentifier(n, _) => write!(f, "undefined '{}'", n),
        }
    }
}

/// Context for AST→IR conversion.
pub struct AstConverter {
    graph: KnowledgeGraph,
    scope_stack: Vec<HashSet<String>>,
    anon_counter: u64,
}

impl AstConverter {
    pub fn new() -> Self {
        AstConverter {
            graph: KnowledgeGraph::new(),
            scope_stack: vec![HashSet::new()],
            anon_counter: 0,
        }
    }
    pub fn into_graph(self) -> KnowledgeGraph {
        self.graph
    }
    pub fn graph_mut(&mut self) -> &mut KnowledgeGraph {
        &mut self.graph
    }

    /// Convert a full translation unit.
    pub fn convert(
        &mut self,
        unit: AstTranslationUnit,
    ) -> Result<KnowledgeGraph, Vec<ConversionError>> {
        for func_def in &unit.functions {
            self.convert_function(func_def)?;
        }
        Ok(self.graph.clone())
    }

    fn convert_function(&mut self, func_def: &AstFuncDef) -> Result<(), Vec<ConversionError>> {
        let ret_type = match &func_def.ret {
            Some(s) => type_from_str(s),
            None => Type::Void,
        };
        self.enter_scope();
        let mut params: Vec<(Identifier, Type, Option<GraphKey>)> = Vec::new();
        for param in &func_def.params {
            let pid = self.unique_id(&param.name);
            let ptype = match &param.type_ {
                Some(s) => type_from_str(s),
                None => Type::Void,
            };
            let default = match &param.default {
                Some(e) => Some(self.convert_expr(e)?),
                None => None,
            };
            params.push((pid, ptype, default));
        }
        let body_key = self.convert_block(&func_def.body)?;
        let fname = Identifier::new(&func_def.name, self.graph.next_id);
        let knowledge = if func_def.capabilities.is_empty() {
            KnowledgeState::Known
        } else {
            KnowledgeState::Effect
        };
        let func_type = Type::Function {
            params: params.iter().map(|(_, t, _)| t.clone()).collect(),
            ret: Box::new(ret_type.clone()),
        };
        let fkey = self.graph.add_node(
            NodeKind::Function {
                name: fname.clone(),
                params: params.clone(),
                ret: ret_type.clone(),
                body: body_key,
                capabilities: func_def.capabilities.iter().cloned().collect(),
            },
            func_type,
            knowledge,
            vec![body_key],
            HashSet::new(),
            HashSet::new(),
            Provenance::Source {
                file: func_def.span.file.clone(),
                line: func_def.span.line,
                col_start: func_def.span.col_start,
            },
            func_def.span.clone(),
        );
        self.graph.register_function(func_def.name.clone(), fkey);
        self.exit_scope();
        Ok(())
    }

    fn enter_scope(&mut self) {
        self.scope_stack.push(HashSet::new());
    }
    fn exit_scope(&mut self) {
        self.scope_stack.pop();
    }

    fn bind_id(&mut self, name: &str) -> Result<Identifier, ConversionError> {
        let id = self.graph.next_id;
        if let Some(s) = self.scope_stack.last() {
            if s.contains(name) {
                return Err(ConversionError::Shadowing(name.to_string(), id, id));
            }
        }
        if let Some(s) = self.scope_stack.last_mut() {
            s.insert(name.to_string());
        }
        Ok(Identifier::new(name, id))
    }

    fn unique_id(&mut self, name: &str) -> Identifier {
        let id = self.graph.next_id;
        self.graph.next_id += 1;
        Identifier::new(name, id)
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
        let s_key = start_k.unwrap_or_else(|| default_key());
        let e_key = end_k.unwrap_or_else(|| default_key());
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
            } => lit_expr(
                span,
                LiteralValue::Int {
                    value: *value,
                    width: IntWidth::B64,
                    signed: true,
                },
            ),
            AstExpr::FloatLit { value, span } => lit_expr(
                span,
                LiteralValue::Float {
                    value: value.clone(),
                    width: FloatWidth::F64,
                },
            ),
            AstExpr::StrLit { value, span } => lit_expr(span, LiteralValue::Str(value.clone())),
            AstExpr::BoolLit(v, span) => lit_expr(span, LiteralValue::Bool(*v)),
            AstExpr::NullLit(span) => lit_expr(span, LiteralValue::Null),
            AstExpr::CharLit(c, span) => lit_expr(span, LiteralValue::Char(*c)),
            AstExpr::Location(span) => Ok(self.graph.add_node(
                NodeKind::Location,
                Type::SourceLoc,
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
                let fk = self.convert_expr(func)?;
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
                let rt = self.call_ret_type(&fk, func);
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
                    match self.convert_expr(&k) {
                        Ok(kk) => match self.convert_expr(&v) {
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
                let rk = self.convert_range(&range)?;
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
                let bindings = self.resolve_pattern(&pattern)?;
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
                match self.bind_id(name) {
                    Ok(_) => {}
                    Err(ConversionError::Shadowing(n, a, b)) => {
                        return Err(vec![ConversionError::Shadowing(n, a, b)]);
                    }
                    Err(e) => return Err(vec![e]),
                }
                let _id = self.unique_id(name);
                let bid = self.unique_id(name);
                Ok(self.graph.add_node(
                    NodeKind::Binding { name: bid, def: vk },
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
                ))
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
            AstStmtKind::Return(_) | AstStmtKind::Break | AstStmtKind::Continue => {
                Ok(self.graph.add_node(
                    NodeKind::Literal(LiteralValue::Null),
                    Type::Void,
                    KnowledgeState::Known,
                    vec![],
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
        }
    }

    fn convert_block(&mut self, block: &AstBlock) -> Result<GraphKey, Vec<ConversionError>> {
        self.enter_scope();
        let mut last = self.graph.add_node(
            NodeKind::Literal(LiteralValue::Null),
            Type::Void,
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            Span::unknown(),
        );
        for stmt in &block.statements {
            match self.convert_stmt(stmt) {
                Ok(k) => last = k,
                Err(e) => {
                    self.exit_scope();
                    return Err(e);
                }
            }
        }
        if let Some(ret) = &block.ret {
            match self.convert_expr(ret) {
                Ok(k) => last = k,
                Err(e) => {
                    self.exit_scope();
                    return Err(e);
                }
            }
        }
        self.exit_scope();
        Ok(last)
    }

    fn convert_id(&mut self, name: &str, span: &Span) -> Result<GraphKey, Vec<ConversionError>> {
        let bid = self.unique_id(name);
        let def = invalid_key(&mut self.graph);
        Ok(self.graph.add_node(
            NodeKind::Binding { name: bid, def },
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
        ))
    }

    fn resolve_pattern(
        &mut self,
        pattern: &AstPattern,
    ) -> Result<Vec<(Identifier, GraphKey)>, Vec<ConversionError>> {
        let mut bindings = Vec::new();
        match &pattern.kind {
            AstPatternKind::Bind(name) => {
                let id = self.unique_id(name);
                let dk = invalid_key(&mut self.graph);
                bindings.push((id, dk));
            }
            AstPatternKind::Variant { name: _, param } => {
                if let Some(p) = param {
                    let id = self.unique_id(p);
                    let dk = invalid_key(&mut self.graph);
                    bindings.push((id, dk));
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
        let lt = self.get_type(lk);
        let rt = self.get_type(rk);
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

    fn call_ret_type(&self, fk: &GraphKey, _func_ast: &AstExpr) -> Type {
        if let Some(fn_node) = self.graph.get_node_checked(*fk) {
            if let NodeKind::Function { ret, .. } = &fn_node.kind {
                return ret.clone();
            }
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

fn lit_expr(span: &Span, lit: LiteralValue) -> Result<GraphKey, Vec<ConversionError>> {
    // Create a temporary converter to add the literal node
    let mut tmp = AstConverter::new();
    let ty = match &lit {
        LiteralValue::Int { .. } => Type::Numeric(NumericType::Int(lit.int_width())),
        LiteralValue::UInt(_, w) => Type::Numeric(NumericType::UInt(*w)),
        LiteralValue::Float { width, .. } => Type::Numeric(NumericType::Float(*width)),
        LiteralValue::Str(_) => Type::Str,
        LiteralValue::Bool(_) => Type::Bool,
        LiteralValue::Null => Type::Null,
        LiteralValue::Bytes(_) => Type::Bytes,
        LiteralValue::Char(_) => Type::Numeric(NumericType::Int(IntWidth::B16)),
        _ => Type::Void,
    };
    let key = tmp.graph.add_node(
        NodeKind::Literal(lit),
        ty,
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
    );
    Ok(key)
}

// Helper to get int width from literal
trait IntLitExt {
    fn int_width(&self) -> IntWidth;
}
impl IntLitExt for LiteralValue {
    fn int_width(&self) -> IntWidth {
        match self {
            LiteralValue::Int { width, .. } => *width,
            LiteralValue::UInt(_, w) => *w,
            _ => IntWidth::B64,
        }
    }
}

fn type_from_str(s: &str) -> Type {
    if let Some(nt) = NumericType::from_name(s) {
        return Type::Numeric(nt);
    }
    match s {
        "Bool" => Type::Bool,
        "Str" => Type::Str,
        "Null" => Type::Null,
        "Void" => Type::Void,
        "" => Type::Void,
        _ => Type::UserDefined(s.into()),
    }
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
