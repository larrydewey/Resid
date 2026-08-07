//! Type checking for Resid.
//!
//! Infers and checks types over the parsed AST for the numeric core of the
//! spec (§6 Primitive Numeric Types, §6.1–§6.4). Resolves the primitive
//! family (via `resid-ir`), applies the mixed-width widening rules, and
//! rejects signed/unsigned mixing.

use std::collections::HashMap;

pub use resid_ir::{
    BinOp, FloatWidth, IntWidth, NumericError, NumericType, ResultType,
    numeric_result_type,
};
use resid_lexer::token::{Literal, Op as OpKind, Span};
use resid_parser::{Block, Declaration, Expr, ExprKind, FuncDef, Id, StmtKind, Type, TranslationUnit};

/// A semantic type for the supported core.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum SemType {
    Bool,
    Numeric(NumericType),
    Str,
}

impl core::fmt::Display for SemType {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        match self {
            SemType::Bool => write!(f, "Bool"),
            SemType::Numeric(n) => write!(f, "{n}"),
            SemType::Str => write!(f, "Str"),
        }
    }
}

/// Type-checking failure surfaced to the driver.
#[derive(Debug, Clone)]
pub struct TypeError {
    pub message: String,
    pub span: Span,
}

impl core::fmt::Display for TypeError {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        write!(f, "{}", self.message)
    }
}

/// A resolved function signature.
#[derive(Debug, Clone)]
pub struct FunctionSig {
    pub name: String,
    pub params: Vec<SemType>,
    pub ret: SemType,
}

/// A variable-name → type environment.
#[derive(Debug, Clone, Default)]
pub struct Env {
    map: HashMap<String, SemType>,
}

impl Env {
    pub fn new() -> Self {
        Self::default()
    }
    pub fn insert(&mut self, name: &str, ty: SemType) {
        self.map.insert(name.to_string(), ty);
    }
    pub fn get(&self, name: &str) -> Option<&SemType> {
        self.map.get(name)
    }
}

/// Function signatures keyed by name.
pub type Signatures = HashMap<String, FunctionSig>;

fn err(span: &Span, message: impl Into<String>) -> TypeError {
    TypeError {
        message: message.into(),
        span: span.clone(),
    }
}

pub fn kind_tag(kind: &ExprKind) -> &'static str {
    match kind {
        ExprKind::While { .. } => "while",
        ExprKind::ForIn { .. } => "for-in",
        ExprKind::For { .. } => "for",
        ExprKind::Match { .. } => "match",
        ExprKind::Range { .. } => "range",
        ExprKind::StructLit { .. } => "struct literal",
        ExprKind::ListLit(_) => "list literal",
        ExprKind::MapLit(_) => "map literal",
        ExprKind::Index { .. } => "index",
        ExprKind::FieldAccess { .. } => "field access",
        ExprKind::MethodCall { .. } => "method call",
        ExprKind::Slice { .. } => "slice",
        ExprKind::Spawn { .. } => "spawn",
        ExprKind::ProviderCall { .. } => "provider call",
        _ => "expression",
    }
}

/// Map a type name to a semantic type.
pub fn type_from_name(name: &str) -> Option<SemType> {
    match name {
        "Bool" => Some(SemType::Bool),
        "Str" => Some(SemType::Str),
        _ => resid_ir::NumericType::from_name(name).map(SemType::Numeric),
    }
}

/// Resolve a parsed type descriptor to a semantic type.
pub fn resolve_type(td: &Type) -> Option<SemType> {
    match td {
        Type::Base { name, params } => {
            // Parameterized spellings Int(16) / UInt(8) / Float(32) carry a
            // single numeric-literal width; blend into the iN/uN/fN name.
            if let Some(ps) = params {
                if ps.len() == 1 {
                    if let Type::Base { name: width, params: None } = &ps[0] {
                        let kind = match name.0.as_str() {
                            "Int" => "i",
                            "UInt" => "u",
                            "Float" => "f",
                            _ => return type_from_name(&name.0),
                        };
                        if let Ok(w) = width.0.parse::<u16>() {
                            return type_from_name(&format!("{kind}{w}"));
                        }
                    }
                }
            }
            type_from_name(&name.0)
        }
        Type::ISize => Some(SemType::Numeric(NumericType::ISize)),
        Type::USize => Some(SemType::Numeric(NumericType::USize)),
        Type::Residual(inner) => resolve_type(inner),
    }
}

/// Map a parser operator to the IR `BinOp` used for widening.
pub fn to_bin_op(op: &OpKind) -> Option<BinOp> {
    match op {
        OpKind::Plus => Some(BinOp::Add),
        OpKind::Minus => Some(BinOp::Sub),
        OpKind::Star => Some(BinOp::Mul),
        OpKind::Slash => Some(BinOp::Div),
        OpKind::Percent => Some(BinOp::Rem),
        OpKind::ShiftLeft => Some(BinOp::ShiftLeft),
        OpKind::ShiftRight => Some(BinOp::ShiftRight),
        OpKind::Amp => Some(BinOp::And),
        OpKind::Caret => Some(BinOp::Xor),
        OpKind::Pipe => Some(BinOp::Or),
        OpKind::EqEq => Some(BinOp::Eq),
        OpKind::Ne => Some(BinOp::Ne),
        OpKind::Less => Some(BinOp::Lt),
        OpKind::LessEq => Some(BinOp::Le),
        OpKind::Greater => Some(BinOp::Gt),
        OpKind::GreaterEq => Some(BinOp::Ge),
        _ => None,
    }
}

fn lit_type(lit: &Literal) -> SemType {
    match lit {
        Literal::Int { .. } => SemType::Numeric(NumericType::Int(IntWidth::from_bits(64).unwrap())),
        Literal::Float(_) => SemType::Numeric(NumericType::Float(FloatWidth::from_bits(64).unwrap())),
        Literal::Bool(_) => SemType::Bool,
        _ => SemType::Str,
    }
}

/// Collect all function signatures declared in a translation unit.
pub fn collect_signatures(unit: &TranslationUnit) -> Signatures {
    let mut sigs = Signatures::new();
    for decl in &unit.declarations {
        if let Declaration::Function(f) = decl {
            let sig = signature_of(f);
            sigs.insert(sig.name.clone(), sig);
        }
    }
    sigs
}

fn signature_of(f: &FuncDef) -> FunctionSig {
    let params = f
        .params
        .iter()
        .map(|p| resolve_type(&p.type_).unwrap_or(SemType::Bool))
        .collect();
    let ret = resolve_type(&f.ret).unwrap_or(SemType::Bool);
    FunctionSig {
        name: f.name.0.clone(),
        params,
        ret,
    }
}

/// Infer the type of an expression, applying the spec widening rules.
pub fn infer_expr(expr: &Expr, env: &Env, sigs: &Signatures) -> Result<SemType, TypeError> {
    match &expr.kind {
        ExprKind::Literal(lit) => Ok(lit_type(lit)),

        ExprKind::Id(id) => env.get(&id.0).cloned().ok_or_else(|| {
            err(
                &expr.span,
                format!("undefined variable `{}`", id.0),
            )
        }),

        ExprKind::Cast { type_, operand } => {
            let target = resolve_type(type_)
                .ok_or_else(|| err(&expr.span, "unknown cast target type"))?;
            let _ = infer_expr(operand, env, sigs)?;
            Ok(target)
        }

        ExprKind::UnaryOp { op, operand } => {
            let inner = infer_expr(operand, env, sigs)?;
            match op {
                OpKind::Not => match inner {
                    SemType::Bool => Ok(SemType::Bool),
                    other => Err(err(&expr.span, format!("`!` requires Bool, found {other}"))),
                },
                OpKind::Plus | OpKind::Minus | OpKind::Tilde => match inner {
                    SemType::Numeric(_) => Ok(inner),
                    other => Err(err(&expr.span, format!("unary `{op:?}` requires numeric, found {other}"))),
                },
                _ => Err(err(&expr.span, format!("unsupported unary operator {op:?}"))),
            }
        }

        ExprKind::BinaryOp { op, lhs, rhs } => infer_binary(op, lhs, rhs, env, sigs, &expr.span),

        ExprKind::If { cond, then_block, else_block } => {
            match infer_expr(cond, env, sigs)? {
                SemType::Bool => {}
                other => return Err(err(&expr.span, format!("if condition must be Bool, found {other}"))),
            }
            match else_block {
                Some(b) => {
                    let t = block_ret(then_block, env, sigs)?;
                    let e = block_ret(b, env, sigs)?;
                    if t != e {
                        return Err(err(&expr.span, format!("if arms disagree: {t} vs {e}")));
                    }
                    Ok(t)
                }
                None => block_ret(then_block, env, sigs),
            }
        }

        ExprKind::Call { func, args } => infer_call(func, args, env, sigs, &expr.span),

        ExprKind::Rt(inner) => infer_expr(inner, env, sigs),
        ExprKind::AtResidual { inner, .. } => infer_expr(inner, env, sigs),
        ExprKind::RawString(_) | ExprKind::FString(_) => Ok(SemType::Str),

        other => Err(err(
            &expr.span,
            format!("type checking not yet supported for `{}`", kind_tag(other)),
        )),
    }
}

fn infer_binary(
    op: &OpKind,
    lhs: &Expr,
    rhs: &Expr,
    env: &Env,
    sigs: &Signatures,
    span: &Span,
) -> Result<SemType, TypeError> {
    // Logical connectives require Bool operands.
    if matches!(op, OpKind::AndAnd | OpKind::OrOr) {
        require_bool(lhs, env, sigs, span, "left operand of logical operator")?;
        require_bool(rhs, env, sigs, span, "right operand of logical operator")?;
        return Ok(SemType::Bool);
    }

    let binop = to_bin_op(op).ok_or_else(|| err(span, format!("unsupported operator {op:?}")))?;
    let lt = infer_expr(lhs, env, sigs)?;
    let rt = infer_expr(rhs, env, sigs)?;
    let (ln, rn) = match (&lt, &rt) {
        (SemType::Numeric(a), SemType::Numeric(b)) => (*a, *b),
        _ => return Err(err(span, format!("numeric operator requires numeric operands ({lt} {op:?} {rt})"))),
    };

    // Bitwise/shift operators require integer operands.
    if matches!(binop, BinOp::ShiftLeft | BinOp::ShiftRight | BinOp::And | BinOp::Or | BinOp::Xor)
        && (ln.is_float() || rn.is_float())
    {
        return Err(err(span, "bitwise/shift operator requires integer operands"));
    }

    match numeric_result_type(&ln, binop, &rn) {
        ResultType::Bool => Ok(SemType::Bool),
        ResultType::Numeric(n) => Ok(SemType::Numeric(n)),
        ResultType::Error(NumericError::SignednessMix) => {
            Err(err(span, "cannot mix signed and unsigned operands in one operation"))
        }
    }
}

fn require_bool(
    e: &Expr,
    env: &Env,
    sigs: &Signatures,
    span: &Span,
    who: &str,
) -> Result<(), TypeError> {
    match infer_expr(e, env, sigs)? {
        SemType::Bool => Ok(()),
        other => Err(err(span, format!("{who} must be Bool, found {other}"))),
    }
}

fn block_ret(block: &Block, env: &Env, sigs: &Signatures) -> Result<SemType, TypeError> {
    if let Some(ret) = &block.ret {
        return infer_expr(ret, env, sigs);
    }
    if let Some(stmt) = block.statements.last() {
        if let StmtKind::Expr(e) = &stmt.kind {
            return infer_expr(e, env, sigs);
        }
    }
    Ok(SemType::Bool)
}

fn infer_call(
    callee: &Expr,
    args: &[(Option<Id>, Expr)],
    env: &Env,
    sigs: &Signatures,
    span: &Span,
) -> Result<SemType, TypeError> {
    let name = match &callee.kind {
        ExprKind::Id(id) => id.0.clone(),
        _ => return Err(err(span, "only direct function calls are supported")),
    };
    let sig = sigs
        .get(&name)
        .ok_or_else(|| err(span, format!("call to undefined function `{name}`")))?;
    if args.len() != sig.params.len() {
        return Err(err(
            span,
            format!("`{name}` expects {} argument(s), got {}", sig.params.len(), args.len()),
        ));
    }
    // Check each argument against the parameter type.
    for (i, (_, a)) in args.iter().enumerate() {
        let at = infer_expr(a, env, sigs)?;
        let want = &sig.params[i];
        if &at != want && !literal_compatible(a, want) {
            return Err(err(
                &a.span,
                format!("argument {} of `{name}`: expected {want}, found {at}", i + 1),
            ));
        }
    }
    Ok(sig.ret.clone())
}

/// A numeric literal may adopt a (same-sign, wide-enough) numeric target type,
/// so `Int(8) x = 5;` and calling an `i8`-typed function with `5` are allowed.
fn literal_compatible(a: &Expr, target: &SemType) -> bool {
    let SemType::Numeric(t) = target else {
        return false;
    };
    let ExprKind::Literal(Literal::Int { value, .. }) = &a.kind else {
        return false;
    };
    let bits = t.target_width().unwrap_or(64) as u32;
    if bits >= 128 {
        return true;
    }
    if t.is_unsigned() {
        *value < (1u128 << bits)
    } else {
        *value <= (1u128 << (bits - 1)) - 1
    }
}