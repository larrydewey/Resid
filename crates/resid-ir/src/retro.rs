//! Reduced knowledge graph → AST retrofit.
//!
//! Consumes a reduced [`KnowledgeGraph`] and emits an [`AstTranslationUnit`]
//! that re-parses and re-type-checks, preserving the program's semantics.
//! Statement layout comes from the [`BlockInfo`] registry recorded during
//! conversion; everything else is reconstructed from the graph itself.

use std::collections::HashSet;

use crate::GraphKey;
use crate::graph::{BlockInfo, KnowledgeGraph, Node, NodeKind};
use crate::types::*;

/// Full compile-time reduction pipeline: convert → reduce to a fixpoint →
/// retrofit back to a parser-consumable translation unit.
///
/// `ok` is a list of (owner, kind, detail) capability ceilings to keep the
/// retrofit conservative (graph reduce never exercises effects, so it is only
/// cosmetic today).
pub fn graph_reduce(
    unit: AstTranslationUnit,
    _ok: &[(&str, String, String)],
) -> Result<AstTranslationUnit, Vec<String>> {
    let mut conv = crate::convert::AstConverter::new();
    let graph = conv
        .convert(unit)
        .map_err(|errs| errs.iter().map(|e| e.to_string()).collect::<Vec<_>>())?;
    let graph = {
        let mut g = graph;
        let mut r = crate::reduce::ReductionContext::new(&mut g);
        r.reduce_all_nodes().map_err(|e| {
            e.iter()
                .map(|x| format!("reduction: {x}"))
                .collect::<Vec<_>>()
        })?;
        g
    };
    Ok(Retro::new(graph).emit())
}

/// Statement reconstruction context. Keys are stable because reduction only
/// ever replaces a node's *kind in place* (keys never change meaning).
struct Retro {
    graph: KnowledgeGraph,
}

impl Retro {
    fn new(graph: KnowledgeGraph) -> Self {
        Retro { graph }
    }

    fn get(&self, key: GraphKey) -> &Node {
        self.graph.get_node(key)
    }

    fn node_kind(&self, key: GraphKey) -> &NodeKind {
        &self.get(key).kind
    }

    fn res(&self, key: GraphKey) -> Result<AstExpr, Vec<String>> {
        self.conv(key)
    }

    /// Emit the translation unit. Entry point first, remaining functions in
    /// name order so output is deterministic.
    fn emit(&self) -> AstTranslationUnit {
        let mut fs = self.graph.function_keys();
        if let Some(entry) = self.graph.get_entry() {
            if let Some(pos) = fs.iter().position(|k| *k == entry) {
                let e = fs.remove(pos);
                fs.insert(0, e);
            }
        }
        let ep = fs.first().copied();
        let mut rest: Vec<GraphKey> = if ep.is_some() { fs[1..].to_vec() } else { fs };
        rest.sort_by_key(|k| match self.node_kind(*k) {
            NodeKind::Function { name, .. } => name.name.clone(),
            _ => String::new(),
        });
        let ordered: Vec<GraphKey> = ep.into_iter().chain(rest).collect();
        let functions = ordered.into_iter().map(|k| self.func_def(k)).collect();
        AstTranslationUnit {
            imports: vec![],
            functions,
        }
    }

    fn func_def(&self, key: GraphKey) -> AstFuncDef {
        let NodeKind::Function {
            name,
            public,
            params,
            ret,
            body,
            capabilities: _,
        } = self.node_kind(key)
        else {
            return AstFuncDef {
                public: false,
                name: "<invalid>".into(),
                params: vec![],
                ret: None,
                body: AstBlock {
                    statements: vec![],
                    ret: None,
                },
                doc_comments: vec![],
                capabilities: vec![],
                span: self.get(key).span.clone(),
            };
        };
        let span = self.get(key).span.clone();
        let body = self.block(*body);
        let params = params
            .iter()
            .map(|(pid, pty, default)| AstParam {
                type_: Some(type_to_str(pty)),
                name: pid.name.clone(),
                default: default.and_then(|d| self.conv(d).ok()),
            })
            .collect();
        let ret = if *ret == Type::Void {
            None
        } else {
            Some(type_to_str(ret))
        };
        let doc_comments = self.get(key).doc_comments.clone().unwrap_or_default();
        AstFuncDef {
            public: *public,
            name: name.name.clone(),
            params,
            ret,
            body,
            doc_comments,
            capabilities: vec![],
            span,
        }
    }

    /// Reconstruct a block from its recorded statement anchors. Anchors whose
    /// nodes folded entirely away (single known literals) are dropped unless
    /// they are the block's tail expression.
    fn block(&self, root: GraphKey) -> AstBlock {
        let default = BlockInfo::default();
        let info = self.graph.block_info(root).unwrap_or(&default);
        let mut statements = Vec::new();
        let mut ret = None;
        for (i, anchor) in info.anchors.iter().enumerate() {
            let is_tail = info.tail == Some(*anchor);
            let stmt = self.stmt(*anchor);
            match stmt {
                Some(s) => {
                    if is_tail {
                        if self.is_tail_expr_ok(*anchor) {
                            ret = self.conv(*anchor).ok().map(Box::new);
                        }
                    } else {
                        statements.push(s);
                    }
                }
                None => {
                    if is_tail {
                        ret = self.conv(*anchor).ok().map(Box::new);
                    }
                }
            }
            let _ = i;
        }
        // Blocks with no recorded info: the whole block collapsed. The root
        // still holds whatever value it reduced to.
        if info.anchors.is_empty() && info.tail.is_none() {
            ret = self.conv(root).ok().map(Box::new);
        }
        AstBlock { statements, ret }
    }

    /// A tail is emitted as a bare return expression only when it cannot also
    /// be a statement (i.e. it is a pure value).
    fn is_tail_expr_ok(&self, key: GraphKey) -> bool {
        matches!(
            self.node_kind(key),
            NodeKind::Literal(_)
                | NodeKind::Reference { .. }
                | NodeKind::FString { .. }
                | NodeKind::Struct { .. }
                | NodeKind::List { .. }
                | NodeKind::Map { .. }
                | NodeKind::Set { .. }
                | NodeKind::Cast { .. }
                | NodeKind::Range { .. }
        ) || matches!(
            self.node_kind(key),
            NodeKind::Call { .. }
                | NodeKind::BinaryOp { .. }
                | NodeKind::UnaryOp { .. }
                | NodeKind::FieldAccess { .. }
                | NodeKind::Index { .. }
                | NodeKind::If { .. }
        ) || true
    }

    /// Convert one statement anchor. Returns `None` when it represents a pure
    /// folded-away expression (a bare known literal that is not the tail).
    fn stmt(&self, key: GraphKey) -> Option<AstStmt> {
        let span = self.get(key).span.clone();
        let kind = match self.node_kind(key).clone() {
            NodeKind::Binding { name, def } => AstStmtKind::Bind {
                type_: type_ann(&self.get(key).type_),
                name: name.name,
                value: Box::new(self.conv(def).ok()?),
            },
            NodeKind::Discard { source } => {
                AstStmtKind::Discard(Box::new(self.conv(source).ok()?))
            }
            NodeKind::Destructure { pattern, source, .. } => AstStmtKind::Destructure {
                pattern: conv_pattern(&pattern),
                source: Box::new(self.conv(source).ok()?),
            },
            NodeKind::EarlyReturn { value } => {
                if self.known_null(value) {
                    AstStmtKind::Return(None)
                } else {
                    AstStmtKind::Return(Some(Box::new(self.conv(value).ok()?)))
                }
            }
            NodeKind::Break => AstStmtKind::Break,
            NodeKind::Continue => AstStmtKind::Continue,
            NodeKind::ComptimePrint(inner) => AstStmtKind::Expr(Box::new(AstExpr::ComptimePrint(
                Box::new(self.conv(inner).ok()?),
                self.get(inner).span.clone(),
            ))),
            NodeKind::Literal(_) => return None,
            other => AstStmtKind::Expr(Box::new(self.conv_key_with_kind(key, &other))),
        };
        Some(AstStmt { kind, span })
    }

    fn known_null(&self, key: GraphKey) -> bool {
        matches!(self.node_kind(key), NodeKind::Literal(LiteralValue::Null))
    }

    /// A node used in statement position (for-loop init/step) becomes a bind or
    /// an expression statement.
    fn node_to_stmt(&self, key: GraphKey) -> Option<AstStmt> {
        let span = self.get(key).span.clone();
        let kind = match self.node_kind(key).clone() {
            NodeKind::Binding { name, def } => AstStmtKind::Bind {
                type_: type_ann(&self.get(key).type_),
                name: name.name,
                value: Box::new(self.conv(def).unwrap_or(AstExpr::Todo(span.clone()))),
            },
            NodeKind::Literal(_) => return None,
            other => AstStmtKind::Expr(Box::new(self.conv_key_with_kind(key, &other))),
        };
        Some(AstStmt { kind, span })
    }

    /// Full expression conversion.
    fn conv(&self, key: GraphKey) -> Result<AstExpr, Vec<String>> {
        let node = self.get(key);
        let kind = node.kind.clone();
        let ty = node.type_.clone();
        Ok(self.conv_typed(kind, ty, &node.span))
    }

    fn conv_key_with_kind(&self, key: GraphKey, kind: &NodeKind) -> AstExpr {
        let node = self.get(key);
        self.conv_typed(kind.clone(), node.type_.clone(), &node.span)
    }

    fn conv_typed(&self, kind: NodeKind, ty: Type, span: &Span) -> AstExpr {
        let sp = span.clone();
        match kind {
            NodeKind::Literal(lit) => literal_expr(lit, &ty, span),
            NodeKind::Reference { name, .. } => AstExpr::Id(name.name),
            NodeKind::Function { name, .. } => AstExpr::Id(name.name),
            NodeKind::Call { func, args } => AstExpr::Call {
                func: Box::new(self.conv(func).map_err(|_| AstExpr::Todo(sp.clone())).unwrap_or(
                    AstExpr::Todo(sp.clone()),
                )),
                args: args
                    .into_iter()
                    .map(|a| (None, self.conv(a).unwrap_or(AstExpr::Todo(sp.clone()))))
                    .collect(),
                span: sp,
            },
            NodeKind::Rt(inner) => AstExpr::Rt(Box::new(self.conv(inner).unwrap_or_else(|_| {
                AstExpr::Todo(sp.clone())
            })), sp),
            NodeKind::AtResidual { type_, inner } => AstExpr::AtResidual {
                type_,
                inner: Box::new(
                    self.conv(inner)
                        .unwrap_or(AstExpr::Todo(sp.clone())),
                ),
                span: sp,
            },
            NodeKind::BinaryOp { op, lhs, rhs } => AstExpr::BinaryOp {
                op,
                lhs: Box::new(self.conv(lhs).unwrap_or(AstExpr::Todo(sp.clone()))),
                rhs: Box::new(self.conv(rhs).unwrap_or(AstExpr::Todo(sp.clone()))),
                span: sp,
            },
            NodeKind::UnaryOp { op, operand } => unary_expr(op, self.conv(operand), sp),
            NodeKind::Cast { type_, operand } => AstExpr::UnaryOp {
                op: UnaryOp::Cast(Box::new(type_)),
                operand: Box::new(self.conv(operand).unwrap_or(AstExpr::Todo(sp.clone()))),
                span: sp,
            },
            NodeKind::If {
                cond,
                then_branch,
                else_branch,
            } => AstExpr::If {
                cond: Box::new(self.conv(cond).unwrap_or(AstExpr::Todo(sp.clone()))),
                then_block: Box::new(self.block(then_branch)),
                else_block: else_branch.map(|e| Box::new(self.block(e))),
                span: sp,
            },
            NodeKind::While { cond, body } => AstExpr::While {
                cond: Box::new(self.conv(cond).unwrap_or(AstExpr::Todo(sp.clone()))),
                body: Box::new(self.block(body)),
                span: sp,
            },
            NodeKind::For {
                init,
                cond,
                step,
                body,
            } => AstExpr::For {
                init: self.node_to_stmt(init),
                cond: Box::new(self.conv(cond).unwrap_or(AstExpr::Todo(sp.clone()))),
                step: self.node_to_stmt(step),
                body: Box::new(self.block(body)),
                span: sp,
            },
            NodeKind::ForIn { iter, name, body } => {
            let elem = type_to_str_el(&self.get(iter).type_);
            AstExpr::ForIn {
                type_: elem,
                name: name.name,
                collection: Box::new(self.conv(iter).unwrap_or(AstExpr::Todo(sp.clone()))),
                body: Box::new(self.block(body)),
                span: sp,
            }
        }
            NodeKind::Match {
                scrutinee,
                arms,
                default_arm,
            } => {
                let mut out_arms: Vec<(AstPattern, AstExpr)> = arms
                    .into_iter()
                    .map(|(p, k)| (conv_pattern(&p), self.conv(k).unwrap_or(AstExpr::Todo(sp.clone()))))
                    .collect();
                if let Some(d) = default_arm {
                    out_arms.push((
                        AstPattern {
                            kind: AstPatternKind::Wildcard,
                            span: sp.clone(),
                        },
                        self.conv(d).unwrap_or(AstExpr::Todo(sp.clone())),
                    ));
                }
                AstExpr::Match {
                    scrutinee: Box::new(self.conv(scrutinee).unwrap_or(AstExpr::Todo(sp.clone()))),
                    arms: out_arms,
                    span: sp,
                }
            }
            NodeKind::Spawn { capabilities, body, .. } => AstExpr::Spawn {
                capabilities: caps_to_ast(&capabilities),
                body: self.block(body),
                span: sp,
            },
            NodeKind::Assert { cond, message } => AstExpr::Assert {
                cond: Box::new(self.conv(cond).unwrap_or(AstExpr::Todo(sp.clone()))),
                message: Box::new(self.conv(message).unwrap_or(AstExpr::Todo(sp.clone()))),
                span: sp,
            },
            NodeKind::RtAssert { cond, message } => AstExpr::RtAssert {
                cond: Box::new(self.conv(cond).unwrap_or(AstExpr::Todo(sp.clone()))),
                message: Box::new(self.conv(message).unwrap_or(AstExpr::Todo(sp.clone()))),
                span: sp,
            },
            NodeKind::Known(inner) => AstExpr::Known(
                Box::new(self.conv(inner).unwrap_or(AstExpr::Todo(sp.clone()))),
                sp,
            ),
            NodeKind::RtKnown(inner) => AstExpr::RtKnown(
                Box::new(self.conv(inner).unwrap_or(AstExpr::Todo(sp.clone()))),
                sp,
            ),
            NodeKind::ComptimePrint(inner) => AstExpr::ComptimePrint(
                Box::new(self.conv(inner).unwrap_or(AstExpr::Todo(sp.clone()))),
                sp,
            ),
            NodeKind::Todo => AstExpr::Todo(sp),
            NodeKind::Unimplemented => AstExpr::Unimplemented(sp),
            NodeKind::Location => AstExpr::Location(sp),
            NodeKind::Struct { name, fields } => AstExpr::StructLit {
                name: name.name,
                fields: fields
                    .into_iter()
                    .map(|(fid, k)| {
                        (
                            fid.name,
                            self.conv(k).unwrap_or(AstExpr::Todo(sp.clone())),
                        )
                    })
                    .collect(),
                span: sp,
            },
            NodeKind::List { elements } => AstExpr::ListLit(
                elements
                    .into_iter()
                    .map(|e| self.conv(e).unwrap_or(AstExpr::Todo(sp.clone())))
                    .collect(),
                sp,
            ),
            NodeKind::Map { entries } => AstExpr::MapLit(
                entries
                    .into_iter()
                    .map(|(k, v)| {
                        (
                            self.conv(k).unwrap_or(AstExpr::Todo(sp.clone())),
                            self.conv(v).unwrap_or(AstExpr::Todo(sp.clone())),
                        )
                    })
                    .collect(),
                sp,
            ),
            NodeKind::Set { elements } => AstExpr::SetLit(
                elements
                    .into_iter()
                    .map(|e| self.conv(e).unwrap_or(AstExpr::Todo(sp.clone())))
                    .collect(),
                sp,
            ),
            NodeKind::Range { start, end, closed } => AstExpr::Range {
                start: Box::new(self.conv(start).unwrap_or(AstExpr::Todo(sp.clone()))),
                end: Box::new(self.conv(end).unwrap_or(AstExpr::Todo(sp.clone()))),
                closed,
                span: sp,
            },
            NodeKind::FString { parts } => AstExpr::FString(
                parts
                    .into_iter()
                    .map(|p| {
                        if let Some(ek) = p.expr {
                            AstFStringPart::Expr(Box::new(
                                self.conv(ek).unwrap_or(AstExpr::Todo(sp.clone())),
                            ))
                        } else {
                            AstFStringPart::Text(p.text)
                        }
                    })
                    .collect(),
                sp,
            ),
            NodeKind::RawString(s) => AstExpr::RawString(s, sp),
            NodeKind::ByteString(b) => AstExpr::ByteString(b, sp),
            NodeKind::FieldAccess { target, field } => AstExpr::FieldAccess {
                target: Box::new(self.conv(target).unwrap_or(AstExpr::Todo(sp.clone()))),
                field: field.name,
                span: sp,
            },
            NodeKind::Index { target, index } => AstExpr::Index {
                target: Box::new(self.conv(target).unwrap_or(AstExpr::Todo(sp.clone()))),
                index: Box::new(self.conv(index).unwrap_or(AstExpr::Todo(sp.clone()))),
                span: sp,
            },
            NodeKind::Slice { target, range } => AstExpr::Slice {
                target: Box::new(self.conv(target).unwrap_or(AstExpr::Todo(sp.clone()))),
                range: Box::new(self.conv_range_key(range)),
                span: sp,
            },
            NodeKind::MethodCall { target, method, args } => AstExpr::MethodCall {
                target: Box::new(self.conv(target).unwrap_or(AstExpr::Todo(sp.clone()))),
                method: method.name,
                args: args
                    .into_iter()
                    .map(|a| self.conv(a).unwrap_or(AstExpr::Todo(sp.clone())))
                    .collect(),
                span: sp,
            },
            NodeKind::EarlyReturn { value } => AstExpr::EarlyReturn(
                Box::new(self.conv(value).unwrap_or(AstExpr::Todo(sp.clone()))),
                sp,
            ),
            NodeKind::ElseFallback { value, fallback } => AstExpr::ElseFallback {
                value: Box::new(self.conv(value).unwrap_or(AstExpr::Todo(sp.clone()))),
                fallback: self.block(fallback),
                span: sp,
            },
            NodeKind::Destructure { pattern, source, .. } => AstExpr::Destructure {
                pattern: conv_pattern(&pattern),
                source: Box::new(self.conv(source).unwrap_or(AstExpr::Todo(sp.clone()))),
                span: sp,
            },
            NodeKind::With { bindings, body } => AstExpr::With {
                bindings: bindings
                    .into_iter()
                    .map(|b| AstWithBinding {
                        type_: type_ann(&b.type_),
                        name: b.name.name,
                        init: Box::new(
                            self.conv(b.init).unwrap_or(AstExpr::Todo(sp.clone())),
                        ),
                    })
                    .collect(),
                body: self.block(body),
                span: sp,
            },
            NodeKind::ProviderCall {
                provider,
                verb,
                args,
            } => AstExpr::ProviderCall {
                provider: provider_name(&provider),
                verb: verb.name,
                args: args
                    .into_iter()
                    .map(|a| self.conv(a).unwrap_or(AstExpr::Todo(sp.clone())))
                    .collect(),
                span: sp,
            },
            NodeKind::BehaviorInstance { behavior, .. } => AstExpr::Id(behavior.name.name),
            NodeKind::Using { value, behavior } => AstExpr::Using {
                value: Box::new(self.conv(value).unwrap_or(AstExpr::Todo(sp.clone()))),
                behavior: behavior.name.name,
                span: sp,
            },
            NodeKind::RegionError(inner) => self.conv(inner).unwrap_or(AstExpr::Todo(sp)),
            NodeKind::Binding { def, .. } => self
                .conv(def)
                .unwrap_or(AstExpr::Todo(sp.clone())),
            NodeKind::Discard { source } => AstExpr::Discard(
                Box::new(self.conv(source).unwrap_or(AstExpr::Todo(sp.clone()))),
                sp,
            ),
            NodeKind::Break => AstExpr::Todo(sp),
            NodeKind::Continue => AstExpr::Todo(sp),
        }
    }

    fn conv_range_key(&self, range: GraphKey) -> AstRange {
        let mut out = AstRange {
            start: None,
            end: None,
            closed: false,
        };
        match self.node_kind(range) {
            NodeKind::Range { start, end, closed } => {
                out.start = self.conv(*start).ok();
                out.end = self.conv(*end).ok();
                out.closed = *closed;
            }
            _ => {}
        }
        out
    }
}

// ─── Helpers ───────────────────────────────────────────────────────

/// Literal → AST expression, wrapping in a parser `Cast` when the literal's
/// node type is narrower/explicitly typed than what the parser infers.
fn literal_expr(lit: LiteralValue, ty: &Type, span: &Span) -> AstExpr {
    let sp = span.clone();
    let raw = match lit {
        LiteralValue::Int { value, width, signed } => {
            let nt = NumericType::Int(width);
            let default_lit = AstExpr::Literal {
                value,
                kind: AstIntKind::Decimal,
                span: sp.clone(),
            };
            if signed {
                if *ty == Type::Numeric(NumericType::Int(IntWidth::B64)) {
                    return default_lit;
                }
                return AstExpr::UnaryOp {
                    op: UnaryOp::Cast(Box::new(Type::Numeric(nt))),
                    operand: Box::new(default_lit),
                    span: sp,
                };
            }
            let _ = nt;
            return AstExpr::UnaryOp {
                op: UnaryOp::Cast(Box::new(Type::Numeric(NumericType::UInt(width)))),
                operand: Box::new(default_lit),
                span: sp,
            };
        }
        LiteralValue::UInt(value, width) => {
            let default_lit = AstExpr::Literal {
                value,
                kind: AstIntKind::Decimal,
                span: sp.clone(),
            };
            if *ty == Type::Numeric(NumericType::UInt(IntWidth::B64)) {
                return default_lit;
            }
            return AstExpr::UnaryOp {
                op: UnaryOp::Cast(Box::new(Type::Numeric(NumericType::UInt(width)))),
                operand: Box::new(default_lit),
                span: sp,
            };
        }
        LiteralValue::Float { value, width } => {
            return match ty {
                Type::Numeric(NumericType::Float(FloatWidth::F64)) => {
                    AstExpr::FloatLit { value, span: sp }
                }
                _ => AstExpr::UnaryOp {
                    op: UnaryOp::Cast(Box::new(Type::Numeric(NumericType::Float(width)))),
                    operand: Box::new(AstExpr::FloatLit { value, span: sp.clone() }),
                    span: sp,
                },
            };
        }
        LiteralValue::Str(s) => AstExpr::StrLit { value: s, span: sp },
        LiteralValue::Bool(b) => AstExpr::BoolLit(b, sp),
        LiteralValue::Null => AstExpr::NullLit(sp),
        LiteralValue::Bytes(b) => AstExpr::ByteString(b, sp),
        LiteralValue::Char(c) => AstExpr::CharLit(c, sp),
        LiteralValue::Struct { name, fields } => AstExpr::StructLit {
            name: name.name,
            fields: fields
                .into_iter()
                .map(|(k, v)| {
                    let t = type_of_lit(&v);
                    (k.name, literal_expr(v, &t, span))
                })
                .collect(),
            span: sp,
        },
        LiteralValue::List(elts) => AstExpr::ListLit(
            elts.iter()
                .map(|v| {
                    let t = type_of_lit(v);
                    literal_expr(v.clone(), &t, span)
                })
                .collect(),
            sp,
        ),
    };
    raw
}

fn type_of_lit(lit: &LiteralValue) -> Type {
    match lit {
        LiteralValue::Int { width, signed, .. } if *signed => {
            Type::Numeric(NumericType::Int(*width))
        }
        LiteralValue::Int { width, .. } => Type::Numeric(NumericType::UInt(*width)),
        LiteralValue::UInt(_, w) => Type::Numeric(NumericType::UInt(*w)),
        LiteralValue::Float { width, .. } => Type::Numeric(NumericType::Float(*width)),
        LiteralValue::Str(_) => Type::Str,
        LiteralValue::Bool(_) => Type::Bool,
        LiteralValue::Null => Type::Null,
        LiteralValue::Bytes(_) => Type::Bytes,
        LiteralValue::Char(_) => Type::Numeric(NumericType::Int(IntWidth::B16)),
        LiteralValue::Struct { name, .. } => Type::UserDefined(name.name.clone()),
        LiteralValue::List(_) => Type::Void,
    }
}

fn unary_expr(op: UnaryOp, operand: Result<AstExpr, Vec<String>>, sp: Span) -> AstExpr {
    let operand = operand.unwrap_or(AstExpr::Todo(sp.clone()));
    match op {
        UnaryOp::Neg => AstExpr::UnaryOp {
            op: UnaryOp::Neg,
            operand: Box::new(operand),
            span: sp,
        },
        UnaryOp::Not => AstExpr::UnaryOp {
            op: UnaryOp::Not,
            operand: Box::new(operand),
            span: sp,
        },
        UnaryOp::BitNot => AstExpr::UnaryOp {
            op: UnaryOp::BitNot,
            operand: Box::new(operand),
            span: sp,
        },
        UnaryOp::Cast(ty) => AstExpr::UnaryOp {
            op: UnaryOp::Cast(ty),
            operand: Box::new(operand),
            span: sp,
        },
    }
}

/// Annotation for a binding/param: concrete types only. Residual/function/handle
/// types are left to inference.
fn type_ann(t: &Type) -> Option<String> {
    match t {
        Type::Residual(_) | Type::Function { .. } | Type::Behavior(_) | Type::Handle(_, _) => None,
        Type::Void | Type::Null => None,
        Type::Constrained(_, _) | Type::RegionError => None,
        _ => Some(type_to_str(t)),
    }
}

fn conv_pattern(p: &Pattern) -> AstPattern {
    let sp = Span::unknown();
    let kind = match &p.kind {
        PatternKind::Wildcard => AstPatternKind::Wildcard,
        PatternKind::Bind(id) => AstPatternKind::Bind(id.name.clone()),
        PatternKind::Variant { name, param } => AstPatternKind::Variant {
            name: name.name.clone(),
            param: param.as_ref().map(|i| i.name.clone()),
        },
        PatternKind::Literal(l) => match l {
            LiteralValue::Int { value, .. } | LiteralValue::UInt(value, _) => {
                AstPatternKind::Literal(*value)
            }
            LiteralValue::Bool(b) => AstPatternKind::Literal(*b as u128),
            _ => AstPatternKind::Wildcard,
        },
        PatternKind::Struct { name, fields } => AstPatternKind::Struct {
            name: name.name.clone(),
            fields: fields
                .iter()
                .map(|(fid, fp)| (fid.name.clone(), conv_pattern(fp)))
                .collect(),
        },
        PatternKind::RangePattern { .. } => AstPatternKind::Wildcard,
    };
    AstPattern { kind, span: sp }
}

fn caps_to_ast(caps: &HashSet<Capability>) -> Vec<Capability> {
    caps.iter().cloned().collect()
}

fn provider_name(p: &Provider) -> String {
    match p {
        Provider::Filesystem => "filesystem".to_string(),
        Provider::Environment => "environment".to_string(),
        Provider::Git => "git".to_string(),
    }
}

/// Element type of a collection for a `for x: T in …` annotation.
fn type_to_str_el(t: &Type) -> String {
    match t {
        Type::List(inner) => type_to_str(inner),
        Type::Str => "Char".to_string(),
        Type::Bytes => "UInt(8)".to_string(),
        other => type_to_str(other),
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::convert::AstConverter;

    fn graph_of(src_unit: &str) -> KnowledgeGraph {
        let _ = src_unit;
        AstConverter::new().into_graph()
    }

    #[test]
    fn type_ann_skips_residual() {
        assert_eq!(type_ann(&Type::Residual(Box::new(Type::Bool))), None);
        assert_eq!(type_ann(&Type::Bool), Some("Bool".to_string()));
    }

    #[test]
    fn provider_name_maps() {
        assert_eq!(provider_name(&Provider::Filesystem), "filesystem");
        assert_eq!(provider_name(&Provider::Git), "git");
    }
    #[test]
    fn empty() {
        let _ = graph_of("");
    }
}