//! Fixed-point reduction engine (spec §33).

use crate::GraphKey;
use std::collections::{HashMap, HashSet};

use crate::graph::{FStringPartNode, KnowledgeGraph, KnowledgeState, Node, NodeKind};
use crate::types::*;

/// Result of reducing a single node.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ReductionResult {
    Reduced(GraphKey),
    Irreducible,
    Invalid,
}

/// Reduction errors.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ReductionError {
    Overflow { op: BinOp, width: u16 },
    DivByZero,
    TypeMismatch { expected: String, got: String },
    UnknownNode(GraphKey),
}
impl std::fmt::Display for ReductionError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ReductionError::Overflow { op, width } => {
                write!(f, "overflow {:?} on {}-bit", op, width)
            }
            ReductionError::DivByZero => write!(f, "div by zero"),
            ReductionError::TypeMismatch { expected, got } => {
                write!(f, "type mismatch: {} vs {}", expected, got)
            }
            ReductionError::UnknownNode(k) => write!(f, "unknown node {:?}", k),
        }
    }
}

/// Reduction context for fixed-point iteration (spec §33).
pub struct ReductionContext<'a> {
    graph: &'a mut KnowledgeGraph,
    value_cache: HashMap<GraphKey, LiteralValue>,
    irreducible: HashSet<GraphKey>,
}

impl<'a> ReductionContext<'a> {
    pub fn new(graph: &'a mut KnowledgeGraph) -> Self {
        ReductionContext {
            graph,
            value_cache: HashMap::new(),
            irreducible: HashSet::new(),
        }
    }

    /// Reduce the entire graph to normal form from entry point.
    pub fn reduce_all(&mut self, entry: GraphKey) -> Result<(), Vec<ReductionError>> {
        let mut order = self.graph.topological_order(entry);
        order.reverse(); // children before parents
        loop {
            let reduced = self.reduce_once(&order)?;
            if !reduced {
                break;
            }
            order = self.graph.topological_order(entry);
            order.reverse();
        }
        Ok(())
    }

    fn reduce_once(&mut self, order: &[GraphKey]) -> Result<bool, Vec<ReductionError>> {
        let mut any_reduced = false;
        for &key in order {
            if self.irreducible.contains(&key) {
                continue;
            }
            match self.reduce_node(key)? {
                ReductionResult::Reduced(_) => {
                    any_reduced = true;
                    self.irreducible.clear();
                }
                ReductionResult::Irreducible => {
                    self.irreducible.insert(key);
                }
                ReductionResult::Invalid => {
                    self.graph.set_knowledge(key, KnowledgeState::Invalid);
                }
            }
        }
        Ok(any_reduced)
    }

    fn reduce_node(&mut self, key: GraphKey) -> Result<ReductionResult, Vec<ReductionError>> {
        let node = self.graph.get_node(key).clone();
        if node.knowledge == KnowledgeState::Known {
            if let NodeKind::Literal(ref lit) = node.kind {
                self.value_cache.insert(key, lit.clone());
            }
            return Ok(ReductionResult::Irreducible);
        }
        if matches!(
            node.knowledge,
            KnowledgeState::Residual | KnowledgeState::Effect
        ) {
            return Ok(ReductionResult::Irreducible);
        }

        match &node.kind {
            NodeKind::BinaryOp { op, lhs, rhs } => self.reduce_binop(key, *op, *lhs, *rhs),
            NodeKind::UnaryOp { op, operand } => self.reduce_unaryop(key, op.clone(), *operand),
            NodeKind::Call { func, args } => self.reduce_call(key, *func, args.clone()),
            NodeKind::If {
                cond,
                then_branch,
                else_branch,
            } => self.reduce_if(key, *cond, *then_branch, *else_branch),
            NodeKind::Match {
                scrutinee, arms, ..
            } => self.reduce_match(key, *scrutinee, arms.clone()),
            NodeKind::Range { start, end, closed } => self.reduce_range(key, *start, *end, *closed),
            NodeKind::List { elements } => self.reduce_list(key, elements.clone()),
            NodeKind::Struct { name, fields } => {
                self.reduce_struct(key, name.clone(), fields.clone())
            }
            NodeKind::Binding { name, def } => self.reduce_binding(key, name.clone(), *def),
            NodeKind::Discard { source } => self.reduce_discard(key, *source),
            NodeKind::ComptimePrint(inner) => self.reduce_comptime_print(key, *inner),
            NodeKind::Cast { type_: ct, operand } => self.reduce_cast(key, ct.clone(), *operand),
            NodeKind::FieldAccess { target, field } => {
                self.reduce_field_access(key, *target, field.clone())
            }
            NodeKind::Index { target, index } => self.reduce_index(key, *target, *index),
            NodeKind::Known(inner) => self.reduce_node(*inner),
            NodeKind::Rt(_)
            | NodeKind::AtResidual { .. }
            | NodeKind::RtKnown(_)
            | NodeKind::RtAssert { .. } => Ok(ReductionResult::Irreducible),
            NodeKind::While { .. }
            | NodeKind::For { .. }
            | NodeKind::ForIn { .. }
            | NodeKind::Spawn { .. }
            | NodeKind::ProviderCall { .. } => Ok(ReductionResult::Irreducible),
            NodeKind::Literal(_)
            | NodeKind::Location
            | NodeKind::Todo
            | NodeKind::Unimplemented => Ok(ReductionResult::Irreducible),
            NodeKind::Function { .. } => Ok(ReductionResult::Irreducible),
            NodeKind::Assert { cond, message } => self.reduce_assert(key, *cond, *message, false),
            NodeKind::ElseFallback { .. } | NodeKind::EarlyReturn { .. } => {
                Ok(ReductionResult::Irreducible)
            }
            NodeKind::Destructure { source, .. } => self.reduce_node(*source),
            NodeKind::With { body, .. } => self.reduce_node(*body),
            NodeKind::FString { parts } => self.reduce_fstring(key, parts),
            NodeKind::Slice { target, range } => self.reduce_slice(key, *target, *range),
            NodeKind::Map { entries } => self.reduce_map(key, entries.clone()),
            NodeKind::Set { elements } => self.reduce_set(key, elements.clone()),
            NodeKind::MethodCall {
                target,
                method,
                args,
            } => self.reduce_method_call(key, *target, method, args),
            NodeKind::Using { value, .. } => self.reduce_node(*value),
            NodeKind::BehaviorInstance { .. } => Ok(ReductionResult::Irreducible),
            NodeKind::RegionError(inner) => self.reduce_node(*inner),
            NodeKind::RawString(_) | NodeKind::ByteString(_) => Ok(ReductionResult::Irreducible),
        }
    }

    // ─── β-reduction: call with known args ─────────────────────────

    fn reduce_call(
        &mut self,
        key: GraphKey,
        func: GraphKey,
        args: Vec<GraphKey>,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        // Check if all args are in cache
        let known_count = args
            .iter()
            .filter(|a| self.value_cache.contains_key(a))
            .count();
        if known_count != args.len() {
            return Ok(ReductionResult::Irreducible);
        }

        let fn_node = self.graph.get_node(func);
        if let NodeKind::Function { body, .. } = &fn_node.kind {
            let body_key = *body;
            let body_result = self.reduce_node(body_key)?;
            match body_result {
                ReductionResult::Reduced(rk) => {
                    let rn = self.graph.get_node(rk);
                    self.graph.replace_node(
                        key,
                        rn.kind.clone(),
                        rn.type_.clone(),
                        KnowledgeState::Known,
                    );
                    Ok(ReductionResult::Reduced(rk))
                }
                ReductionResult::Irreducible => {
                    if let Some(bn) = self.graph.get_node_checked(body_key)
                        && bn.knowledge == KnowledgeState::Known {
                            let kind = bn.kind.clone();
                            let type_ = bn.type_.clone();
                            let lit_value = if let NodeKind::Literal(lit) = &bn.kind {
                                Some(lit.clone())
                            } else {
                                None
                            };
                            self.graph
                                .replace_node(key, kind, type_, KnowledgeState::Known);
                            if let Some(lit) = lit_value {
                                self.value_cache.insert(key, lit);
                            }
                            return Ok(ReductionResult::Reduced(body_key));
                        }
                    Ok(ReductionResult::Irreducible)
                }
                ReductionResult::Invalid => Ok(ReductionResult::Invalid),
            }
        } else {
            Ok(ReductionResult::Irreducible)
        }
    }

    // ─── Constant folding: binary ops ──────────────────────────────

    fn reduce_binop(
        &mut self,
        key: GraphKey,
        op: BinOp,
        lhs: GraphKey,
        rhs: GraphKey,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        let ln = self.graph.get_node(lhs);
        let rn = self.graph.get_node(rhs);
        if let (NodeKind::Literal(ll), NodeKind::Literal(rl)) = (&ln.kind, &rn.kind) {
            // Numeric folding
            if let (Some(lv), Some(rv)) = (int_from_lit(ll), int_from_lit(rl)) {
                let result = fold_bin_int(op, lv, rv, ln.type_.clone());
                match result {
                    Some(val) => {
                        self.graph.replace_node(
                            key,
                            NodeKind::Literal(val),
                            ln.type_.clone(),
                            KnowledgeState::Known,
                        );
                        return Ok(ReductionResult::Reduced(lhs));
                    }
                    None => {
                        self.graph.set_knowledge(key, KnowledgeState::Invalid);
                        return Ok(ReductionResult::Invalid);
                    }
                }
            }
            // Bool folding
            if let (LiteralValue::Bool(b), LiteralValue::Bool(c)) = (ll, rl)
                && let Some(result) = fold_bin_bool(op, *b, *c) {
                    self.graph.replace_node(
                        key,
                        NodeKind::Literal(LiteralValue::Bool(result)),
                        Type::Bool,
                        KnowledgeState::Known,
                    );
                    return Ok(ReductionResult::Reduced(lhs));
                }
        }
        Ok(ReductionResult::Irreducible)
    }

    // ─── Constant folding: unary ops ───────────────────────────────

    fn reduce_unaryop(
        &mut self,
        key: GraphKey,
        op: UnaryOp,
        operand: GraphKey,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        let node = self.graph.get_node(operand);
        if let NodeKind::Literal(ref lit) = node.kind {
            match op {
                UnaryOp::Neg => {
                    if let Some(v) = neg_int(lit, &node.type_) {
                        self.graph.replace_node(
                            key,
                            NodeKind::Literal(v),
                            node.type_.clone(),
                            KnowledgeState::Known,
                        );
                        return Ok(ReductionResult::Reduced(operand));
                    }
                }
                UnaryOp::Not => {
                    if let LiteralValue::Bool(b) = lit {
                        self.graph.replace_node(
                            key,
                            NodeKind::Literal(LiteralValue::Bool(!b)),
                            Type::Bool,
                            KnowledgeState::Known,
                        );
                        return Ok(ReductionResult::Reduced(operand));
                    }
                }
                UnaryOp::BitNot => {
                    if let Some(v) = bitnot_int(lit) {
                        self.graph.replace_node(
                            key,
                            NodeKind::Literal(v),
                            node.type_.clone(),
                            KnowledgeState::Known,
                        );
                        return Ok(ReductionResult::Reduced(operand));
                    }
                }
                UnaryOp::Cast(ty) => {
                    if let Some(v) = cast_int(lit, &ty) {
                        self.graph.replace_node(
                            key,
                            NodeKind::Literal(v),
                            *ty,
                            KnowledgeState::Known,
                        );
                        return Ok(ReductionResult::Reduced(operand));
                    }
                }
            }
        }
        Ok(ReductionResult::Irreducible)
    }

    // ─── If reduction ──────────────────────────────────────────────

    fn reduce_if(
        &mut self,
        key: GraphKey,
        cond: GraphKey,
        then_b: GraphKey,
        els: Option<GraphKey>,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        let cn = self.graph.get_node(cond);
        if let NodeKind::Literal(LiteralValue::Bool(b)) = &cn.kind {
            let sel = if *b { Some(then_b) } else { els };
            if let Some(s) = sel {
                let sn = self.graph.get_node(s);
                self.graph
                    .replace_node(key, sn.kind.clone(), sn.type_.clone(), sn.knowledge);
                return Ok(ReductionResult::Reduced(s));
            }
            if !*b {
                let vk = self.graph.add_node(
                    NodeKind::Literal(LiteralValue::Null),
                    Type::Void,
                    KnowledgeState::Known,
                    vec![],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Inferred,
                    Span::unknown(),
                );
                self.graph.replace_node(
                    key,
                    NodeKind::Literal(LiteralValue::Null),
                    Type::Void,
                    KnowledgeState::Known,
                );
                return Ok(ReductionResult::Reduced(vk));
            }
        }
        Ok(ReductionResult::Irreducible)
    }

    // ─── Match reduction ───────────────────────────────────────────

    fn reduce_match(
        &mut self,
        key: GraphKey,
        scrut: GraphKey,
        arms: Vec<(Pattern, GraphKey)>,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        let sn = self.graph.get_node(scrut);
        for (pat, arm) in arms {
            if matches_pat(&pat, sn) {
                let an = self.graph.get_node(arm);
                self.graph
                    .replace_node(key, an.kind.clone(), an.type_.clone(), an.knowledge);
                return Ok(ReductionResult::Reduced(arm));
            }
        }
        Ok(ReductionResult::Invalid)
    }

    // ─── Range / List / Struct ─────────────────────────────────────

    fn reduce_range(
        &mut self,
        key: GraphKey,
        _start: GraphKey,
        _end: GraphKey,
        _closed: bool,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        self.graph.set_knowledge(key, KnowledgeState::Known);
        Ok(ReductionResult::Irreducible)
    }
    fn reduce_list(
        &mut self,
        key: GraphKey,
        _elements: Vec<GraphKey>,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        self.graph.set_knowledge(key, KnowledgeState::Known);
        Ok(ReductionResult::Irreducible)
    }
    fn reduce_struct(
        &mut self,
        key: GraphKey,
        _name: Identifier,
        _fields: Vec<(Identifier, GraphKey)>,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        self.graph.set_knowledge(key, KnowledgeState::Known);
        Ok(ReductionResult::Irreducible)
    }

    // ─── Binding / Discard ─────────────────────────────────────────

    fn reduce_binding(
        &mut self,
        key: GraphKey,
        _name: Identifier,
        def: GraphKey,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        let dn = self.graph.get_node(def);
        if dn.knowledge == KnowledgeState::Known {
            self.graph.replace_node(
                key,
                dn.kind.clone(),
                dn.type_.clone(),
                KnowledgeState::Known,
            );
            return Ok(ReductionResult::Reduced(def));
        }
        Ok(ReductionResult::Irreducible)
    }
    fn reduce_discard(
        &mut self,
        key: GraphKey,
        _source: GraphKey,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        self.graph.set_knowledge(key, KnowledgeState::Known);
        Ok(ReductionResult::Irreducible)
    }

    // ─── comptime_print ────────────────────────────────────────────

    fn reduce_comptime_print(
        &mut self,
        key: GraphKey,
        inner: GraphKey,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        let in2 = self.graph.get_node(inner);
        if let NodeKind::Literal(ref lit) = in2.kind {
            eprintln!("[comptime_print] {}", lit);
        } else {
            eprintln!("[comptime_print] {:?}", in2.kind);
        }
        let vk = self.graph.add_node(
            NodeKind::Literal(LiteralValue::Null),
            Type::Void,
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            Span::unknown(),
        );
        self.graph.replace_node(
            key,
            NodeKind::Literal(LiteralValue::Null),
            Type::Void,
            KnowledgeState::Known,
        );
        Ok(ReductionResult::Reduced(vk))
    }

    // ─── Cast ──────────────────────────────────────────────────────

    fn reduce_cast(
        &mut self,
        key: GraphKey,
        cast_type: Type,
        operand: GraphKey,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        let node = self.graph.get_node(operand);
        if let NodeKind::Literal(ref lit) = node.kind
            && let Some(cl) = cast_int(lit, &cast_type) {
                self.graph.replace_node(
                    key,
                    NodeKind::Literal(cl),
                    cast_type,
                    KnowledgeState::Known,
                );
                return Ok(ReductionResult::Reduced(operand));
            }
        Ok(ReductionResult::Irreducible)
    }

    // ─── Field access on struct ────────────────────────────────────

    fn reduce_field_access(
        &mut self,
        key: GraphKey,
        target: GraphKey,
        field: Identifier,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        let tn = self.graph.get_node(target);
        if let NodeKind::Struct { fields, .. } = &tn.kind {
            let matching: Option<(Identifier, GraphKey, NodeKind, Type, KnowledgeState)> =
                fields.iter().find_map(|(fid, fk)| {
                    if fid.name == field.name {
                        let fn2 = self.graph.get_node(*fk);
                        Some((
                            fid.clone(),
                            *fk,
                            fn2.kind.clone(),
                            fn2.type_.clone(),
                            fn2.knowledge,
                        ))
                    } else {
                        None
                    }
                });
            if let Some((_, fk, kind, type_, knowledge)) = matching {
                self.graph.replace_node(key, kind, type_, knowledge);
                return Ok(ReductionResult::Reduced(fk));
            }
        }
        Ok(ReductionResult::Irreducible)
    }

    // ─── Index on list ─────────────────────────────────────────────

    fn reduce_index(
        &mut self,
        key: GraphKey,
        target: GraphKey,
        index: GraphKey,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        let tn = self.graph.get_node(target);
        let in2 = self.graph.get_node(index);
        if let (NodeKind::List { elements }, NodeKind::Literal(LiteralValue::Int { value, .. })) =
            (&tn.kind, &in2.kind)
            && let Some(idx) = value_to_usize(value)
                && idx < elements.len() {
                    let element_key = elements[idx];
                    let en = self.graph.get_node(element_key);
                    let kind = en.kind.clone();
                    let type_ = en.type_.clone();
                    let knowledge = en.knowledge;
                    self.graph.replace_node(key, kind, type_, knowledge);
                    return Ok(ReductionResult::Reduced(element_key));
                }
        Ok(ReductionResult::Irreducible)
    }

    // ─── Assert ────────────────────────────────────────────────────

    fn reduce_assert(
        &mut self,
        key: GraphKey,
        cond: GraphKey,
        _message: GraphKey,
        _is_rt: bool,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        let cn = self.graph.get_node(cond);
        if let NodeKind::Literal(LiteralValue::Bool(b)) = &cn.kind {
            if *b {
                let vk = self.graph.add_node(
                    NodeKind::Literal(LiteralValue::Null),
                    Type::Void,
                    KnowledgeState::Known,
                    vec![],
                    HashSet::new(),
                    HashSet::new(),
                    Provenance::Inferred,
                    Span::unknown(),
                );
                self.graph.replace_node(
                    key,
                    NodeKind::Literal(LiteralValue::Null),
                    Type::Void,
                    KnowledgeState::Known,
                );
                return Ok(ReductionResult::Reduced(vk));
            } else {
                self.graph.set_knowledge(key, KnowledgeState::Invalid);
                return Ok(ReductionResult::Invalid);
            }
        }
        Ok(ReductionResult::Irreducible)
    }

    // ─── F-string ──────────────────────────────────────────────────

    fn reduce_fstring(
        &mut self,
        key: GraphKey,
        parts: &[FStringPartNode],
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        let mut result = String::new();
        let mut all_known = true;
        for p in parts {
            if let Some(ek) = p.expr {
                let en = self.graph.get_node(ek);
                match &en.kind {
                    NodeKind::Literal(LiteralValue::Str(s)) => result.push_str(s),
                    NodeKind::Literal(lit) => result.push_str(&format!("{}", lit)),
                    _ => {
                        all_known = false;
                        break;
                    }
                }
            } else {
                result.push_str(&p.text);
            }
        }
        if all_known {
            let sk = self.graph.add_node(
                NodeKind::Literal(LiteralValue::Str(result.clone())),
                Type::Str,
                KnowledgeState::Known,
                vec![],
                HashSet::new(),
                HashSet::new(),
                Provenance::Inferred,
                Span::unknown(),
            );
            self.graph.replace_node(
                key,
                NodeKind::Literal(LiteralValue::Str(result)),
                Type::Str,
                KnowledgeState::Known,
            );
            return Ok(ReductionResult::Reduced(sk));
        }
        Ok(ReductionResult::Irreducible)
    }

    // ─── Slice / Map / MethodCall ──────────────────────────────────

    fn reduce_slice(
        &mut self,
        _key: GraphKey,
        _target: GraphKey,
        _range: GraphKey,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        Ok(ReductionResult::Irreducible)
    }
    fn reduce_map(
        &mut self,
        key: GraphKey,
        _entries: Vec<(GraphKey, GraphKey)>,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        self.graph.set_knowledge(key, KnowledgeState::Known);
        Ok(ReductionResult::Irreducible)
    }
    fn reduce_set(
        &mut self,
        key: GraphKey,
        _elements: Vec<GraphKey>,
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        self.graph.set_knowledge(key, KnowledgeState::Known);
        Ok(ReductionResult::Irreducible)
    }
    fn reduce_method_call(
        &mut self,
        _key: GraphKey,
        _target: GraphKey,
        _method: &Identifier,
        _args: &[GraphKey],
    ) -> Result<ReductionResult, Vec<ReductionError>> {
        Ok(ReductionResult::Irreducible)
    }
}

// ─── Helpers ───────────────────────────────────────────────────────

fn int_from_lit(lit: &LiteralValue) -> Option<i128> {
    match lit {
        LiteralValue::Int {
            value,
            signed: true,
            ..
        } => Some(*value as i128),
        LiteralValue::Int {
            value,
            signed: false,
            ..
        } => Some(*value as i128),
        LiteralValue::UInt(v, _) => Some(*v as i128),
        _ => None,
    }
}

fn value_to_usize(v: &u128) -> Option<usize> {
    Some(*v as usize)
}

fn fold_bin_int(op: BinOp, lhs: i128, rhs: i128, _type_: Type) -> Option<LiteralValue> {
    let result = match op {
        BinOp::Add => lhs.checked_add(rhs),
        BinOp::Sub => lhs.checked_sub(rhs),
        BinOp::Mul => lhs.checked_mul(rhs),
        BinOp::Div => {
            if rhs == 0 {
                return None;
            }
            lhs.checked_div(rhs)
        }
        BinOp::Rem => {
            if rhs == 0 {
                return None;
            }
            lhs.checked_rem(rhs)
        }
        BinOp::ShiftLeft => lhs.checked_shl(rhs as u32),
        BinOp::ShiftRight => lhs.checked_shr(rhs as u32),
        BinOp::And => Some(lhs & rhs),
        BinOp::Or => Some(lhs | rhs),
        BinOp::Xor => Some(lhs ^ rhs),
        BinOp::Eq => return Some(LiteralValue::Bool(lhs == rhs)),
        BinOp::Ne => return Some(LiteralValue::Bool(lhs != rhs)),
        BinOp::Lt => return Some(LiteralValue::Bool(lhs < rhs)),
        BinOp::Le => return Some(LiteralValue::Bool(lhs <= rhs)),
        BinOp::Gt => return Some(LiteralValue::Bool(lhs > rhs)),
        BinOp::Ge => return Some(LiteralValue::Bool(lhs >= rhs)),
    };
    result.map(|v| {
        let w = if v.unsigned_abs() > u64::MAX as u128 {
            IntWidth::B128
        } else if v.unsigned_abs() as u64 > u32::MAX as u64 {
            IntWidth::B64
        } else if v.unsigned_abs() as u32 > u16::MAX as u32 {
            IntWidth::B32
        } else if v.unsigned_abs() as u16 > u8::MAX as u16 {
            IntWidth::B16
        } else {
            IntWidth::B8
        };
        LiteralValue::Int {
            value: v as u128,
            width: w,
            signed: true,
        }
    })
}

fn fold_bin_bool(op: BinOp, lhs: bool, rhs: bool) -> Option<bool> {
    match op {
        BinOp::Eq => Some(lhs == rhs),
        BinOp::Ne => Some(lhs != rhs),
        BinOp::And => Some(lhs && rhs),
        BinOp::Or => Some(lhs || rhs),
        _ => None,
    }
}

fn neg_int(lit: &LiteralValue, _type_: &Type) -> Option<LiteralValue> {
    if let LiteralValue::Int {
        value,
        width,
        signed: true,
    } = lit
    {
        let neg = (*value as i128).checked_neg()?;
        Some(LiteralValue::Int {
            value: neg as u128,
            width: *width,
            signed: true,
        })
    } else {
        None
    }
}

fn bitnot_int(lit: &LiteralValue) -> Option<LiteralValue> {
    if let LiteralValue::Int {
        value,
        width,
        signed,
    } = lit
    {
        Some(LiteralValue::Int {
            value: value.wrapping_neg(),
            width: *width,
            signed: *signed,
        })
    } else {
        None
    }
}

fn cast_int(lit: &LiteralValue, target: &Type) -> Option<LiteralValue> {
    match (lit, target) {
        (
            LiteralValue::Int {
                value,
                width: _,
                signed: _,
            },
            Type::Numeric(NumericType::Int(dw)),
        ) => {
            let mask = (1u128 << dw.bits()) - 1;
            Some(LiteralValue::Int {
                value: value & mask,
                width: *dw,
                signed: true,
            })
        }
        (
            LiteralValue::Int {
                value,
                width: _,
                signed: _,
            },
            Type::Numeric(NumericType::UInt(dw)),
        ) => {
            let mask = (1u128 << dw.bits()) - 1;
            Some(LiteralValue::UInt(value & mask, *dw))
        }
        (LiteralValue::UInt(value, _), Type::Numeric(NumericType::Int(dw))) => {
            let mask = (1u128 << dw.bits()) - 1;
            Some(LiteralValue::Int {
                value: value & mask,
                width: *dw,
                signed: true,
            })
        }
        (LiteralValue::UInt(value, _), Type::Numeric(NumericType::UInt(dw))) => {
            let mask = (1u128 << dw.bits()) - 1;
            Some(LiteralValue::UInt(value & mask, *dw))
        }
        _ => None,
    }
}

fn matches_pat(pattern: &Pattern, node: &Node) -> bool {
    match (&pattern.kind, &node.kind) {
        (PatternKind::Wildcard, _) => true,
        (PatternKind::Literal(l), NodeKind::Literal(n)) => l == n,
        (PatternKind::Bind(_), _) => true,
        (PatternKind::Variant { .. }, NodeKind::Struct { .. }) => true,
        (PatternKind::Struct { .. }, NodeKind::Struct { .. }) => true,
        _ => false,
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::graph::KnowledgeGraph;

    fn make_span() -> Span {
        Span {
            file: "test".into(),
            line: 1,
            col_start: 0,
            col_end: 2,
        }
    }

    fn make_int_lit(
        g: &mut KnowledgeGraph,
        value: u128,
        width: IntWidth,
        signed: bool,
    ) -> GraphKey {
        g.add_node(
            NodeKind::Literal(LiteralValue::Int {
                value,
                width,
                signed,
            }),
            Type::Numeric(NumericType::Int(width)),
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        )
    }

    fn make_bool_lit(g: &mut KnowledgeGraph, value: bool) -> GraphKey {
        g.add_node(
            NodeKind::Literal(LiteralValue::Bool(value)),
            Type::Bool,
            KnowledgeState::Known,
            vec![],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        )
    }

    #[test]
    fn test_reduce_binop_add() {
        let mut g = KnowledgeGraph::new();
        let a = make_int_lit(&mut g, 2, IntWidth::B8, true);
        let b = make_int_lit(&mut g, 3, IntWidth::B8, true);
        let add = g.add_node(
            NodeKind::BinaryOp {
                op: BinOp::Add,
                lhs: a,
                rhs: b,
            },
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Invalid,
            vec![a, b],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let mut rc = ReductionContext::new(&mut g);
        rc.reduce_all(add).unwrap();
        let node = g.get_node(add);
        match &node.kind {
            NodeKind::Literal(LiteralValue::Int { value, .. }) => assert_eq!(*value, 5),
            _ => panic!("expected literal 5, got {:?}", node.kind),
        }
    }

    #[test]
    fn test_reduce_binop_mul() {
        let mut g = KnowledgeGraph::new();
        let a = make_int_lit(&mut g, 4, IntWidth::B16, true);
        let b = make_int_lit(&mut g, 5, IntWidth::B16, true);
        let mul = g.add_node(
            NodeKind::BinaryOp {
                op: BinOp::Mul,
                lhs: a,
                rhs: b,
            },
            Type::Numeric(NumericType::Int(IntWidth::B16)),
            KnowledgeState::Invalid,
            vec![a, b],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let mut rc = ReductionContext::new(&mut g);
        rc.reduce_all(mul).unwrap();
        let node = g.get_node(mul);
        match &node.kind {
            NodeKind::Literal(LiteralValue::Int { value, .. }) => assert_eq!(*value, 20),
            _ => panic!("expected literal 20"),
        }
    }

    #[test]
    fn test_reduce_binop_bool_and() {
        let mut g = KnowledgeGraph::new();
        let a = make_bool_lit(&mut g, true);
        let b = make_bool_lit(&mut g, false);
        let and = g.add_node(
            NodeKind::BinaryOp {
                op: BinOp::And,
                lhs: a,
                rhs: b,
            },
            Type::Bool,
            KnowledgeState::Invalid,
            vec![a, b],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let mut rc = ReductionContext::new(&mut g);
        rc.reduce_all(and).unwrap();
        let node = g.get_node(and);
        match &node.kind {
            NodeKind::Literal(LiteralValue::Bool(v)) => assert!(!v),
            _ => panic!("expected literal false"),
        }
    }

    #[test]
    fn test_reduce_binop_bool_or() {
        let mut g = KnowledgeGraph::new();
        let a = make_bool_lit(&mut g, true);
        let b = make_bool_lit(&mut g, false);
        let or = g.add_node(
            NodeKind::BinaryOp {
                op: BinOp::Or,
                lhs: a,
                rhs: b,
            },
            Type::Bool,
            KnowledgeState::Invalid,
            vec![a, b],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let mut rc = ReductionContext::new(&mut g);
        rc.reduce_all(or).unwrap();
        let node = g.get_node(or);
        match &node.kind {
            NodeKind::Literal(LiteralValue::Bool(v)) => assert!(v),
            _ => panic!("expected literal true"),
        }
    }

    #[test]
    fn test_reduce_unary_neg() {
        let mut g = KnowledgeGraph::new();
        let a = make_int_lit(&mut g, 42, IntWidth::B16, true);
        let neg = g.add_node(
            NodeKind::UnaryOp {
                op: UnaryOp::Neg,
                operand: a,
            },
            Type::Numeric(NumericType::Int(IntWidth::B16)),
            KnowledgeState::Invalid,
            vec![a],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let mut rc = ReductionContext::new(&mut g);
        rc.reduce_all(neg).unwrap();
        let node = g.get_node(neg);
        match &node.kind {
            NodeKind::Literal(LiteralValue::Int { value, signed, .. }) => {
                assert!(*signed);
                // neg_int casts to i128 before negating, so -42_i128 = 2^128 - 42
                assert_eq!(*value, 340282366920938463463374607431768211414u128);
            }
            _ => panic!("expected literal"),
        }
    }

    #[test]
    fn test_reduce_unary_not() {
        let mut g = KnowledgeGraph::new();
        let a = make_bool_lit(&mut g, true);
        let not = g.add_node(
            NodeKind::UnaryOp {
                op: UnaryOp::Not,
                operand: a,
            },
            Type::Bool,
            KnowledgeState::Invalid,
            vec![a],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let mut rc = ReductionContext::new(&mut g);
        rc.reduce_all(not).unwrap();
        let node = g.get_node(not);
        match &node.kind {
            NodeKind::Literal(LiteralValue::Bool(v)) => assert!(!v),
            _ => panic!("expected literal false"),
        }
    }

    #[test]
    fn test_reduce_irreducible() {
        let mut g = KnowledgeGraph::new();
        let a = make_int_lit(&mut g, 1, IntWidth::B8, true);
        let b = make_int_lit(&mut g, 2, IntWidth::B8, true);
        let add = g.add_node(
            NodeKind::BinaryOp {
                op: BinOp::Add,
                lhs: a,
                rhs: b,
            },
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Invalid,
            vec![a, b],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let mut rc = ReductionContext::new(&mut g);
        let result = rc.reduce_node(add).unwrap();
        assert!(matches!(result, ReductionResult::Reduced(_)));
    }

    #[test]
    fn test_reduce_cast_int() {
        let mut g = KnowledgeGraph::new();
        let a = make_int_lit(&mut g, 300, IntWidth::B16, true);
        let cast = g.add_node(
            NodeKind::Cast {
                type_: Type::Numeric(NumericType::Int(IntWidth::B8)),
                operand: a,
            },
            Type::Numeric(NumericType::Int(IntWidth::B8)),
            KnowledgeState::Invalid,
            vec![a],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let mut rc = ReductionContext::new(&mut g);
        rc.reduce_all(cast).unwrap();
        let node = g.get_node(cast);
        match &node.kind {
            NodeKind::Literal(LiteralValue::Int { value, .. }) => assert_eq!(*value, 44),
            _ => panic!("expected literal, got {:?}", node.kind),
        }
    }

    #[test]
    fn test_reduce_binding() {
        let mut g = KnowledgeGraph::new();
        let lit = make_int_lit(&mut g, 100, IntWidth::B16, true);
        let name = Identifier::new("x", 1);
        let binding = g.add_node(
            NodeKind::Binding { name, def: lit },
            Type::Numeric(NumericType::Int(IntWidth::B16)),
            KnowledgeState::Invalid,
            vec![lit],
            HashSet::new(),
            HashSet::new(),
            Provenance::Inferred,
            make_span(),
        );
        let mut rc = ReductionContext::new(&mut g);
        rc.reduce_all(binding).unwrap();
        let node = g.get_node(binding);
        // Binding is reduced to its definition
        assert!(matches!(node.kind, NodeKind::Literal(_)));
    }
}
