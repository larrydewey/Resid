//! Parser AST ↔ reduction-IR bridge (spec §33 "maximal authorized reduction").
//!
//! `from_ast` maps a parser [`TranslationUnit`] into the knowledge-graph IR's
//! AST form, `graph_reduce` runs the full convert → fixed-point reduce →
//! retrofit pipeline, and `to_ast` maps the reduced IR back into a fresh
//! parser [`TranslationUnit`] that re-parses and re-type-checks identically.
//!
//! Only function declarations are representable in the reduction IR
//! (`AstTranslationUnit` carries functions only); type/behavior/sandbox
//! declarations are rejected loudly rather than silently dropped.

use resid_lexer::token::{FloatLit, IntKind, Literal, Op as OpKind, Span as LexSpan, StrLit};
use resid_parser::{
    Block, CapabilityAnnotation, Declaration, Expr, ExprKind, FStringPart, FuncDef, Id, Param,
    Pattern, PatternKind, Stmt, StmtKind, TranslationUnit, Type as PType,
};
use resid_ir as ir;
use ir::{BinOp, Identifier, Lifetime, NumericType, UnaryOp};

// ─── Entry point ───────────────────────────────────────────────────

/// Full graph-reduction round trip on a parsed unit: convert → reduce to a
/// fixpoint → retrofit. The reduced unit must re-parse and re-type-check.
///
/// `ok` is the cosmetic capability-ceiling list passed through to the
/// retrofit (reserved; see `resid_ir::retro::graph_reduce`).
pub fn graph_reduce(
    unit: TranslationUnit,
    ok: &[(&str, String, String)],
) -> Result<TranslationUnit, Vec<String>> {
    for d in &unit.declarations {
        if !matches!(d, Declaration::Function(_)) {
            return Err(vec![format!(
                "graph-reduce: only functions are representable; declaration {} is not",
                decl_name(d)
            )]);
        }
    }
    let ast = from_ast(&unit);
    let reduced = ir::graph_reduce(ast, ok)
        .map_err(|e| e.iter().map(|x| format!("graph-reduce: {x}")).collect::<Vec<_>>())?;
    Ok(to_ast(reduced))
}

fn decl_name(d: &Declaration) -> String {
    match d {
        Declaration::Function(f) => f.name.to_string(),
        Declaration::Type(t) => t.name.to_string(),
        Declaration::Behavior(b) => b.name.to_string(),
        Declaration::Sandbox(_) => "sandbox block".into(),
    }
}

// ─── Forward direction (parser AST → IR) ───────────────────────────

pub fn from_ast(unit: &TranslationUnit) -> ir::AstTranslationUnit {
    let imports = unit
        .imports
        .iter()
        .map(|i| ir::AstImport {
            path: i.path.clone(),
        })
        .collect();
    let functions = unit
        .declarations
        .iter()
        .filter_map(|d| match d {
            Declaration::Function(f) => Some(func_to_ast(f)),
            _ => None,
        })
        .collect();
    ir::AstTranslationUnit { imports, functions }
}

fn func_to_ast(f: &FuncDef) -> ir::AstFuncDef {
    let params = f
        .params
        .iter()
        .map(|p| ir::AstParam {
            type_: Some(ir::type_to_str(&parser_type_to_ir(&p.type_))),
            name: p.name.0.clone(),
            default: p.default.as_ref().map(|d| expr_to_ast(d)),
        })
        .collect();
    let ret = ir::type_to_str(&parser_type_to_ir(&f.ret));
    ir::AstFuncDef {
        public: f.pub_,
        name: f.name.0.clone(),
        params,
        ret: if ret == "Void" { None } else { Some(ret) },
        body: block_to_ast(&f.body),
        doc_comments: f.doc_comments.clone(),
        capabilities: vec![],
        span: sp_to_ir(&f.span),
    }
}

fn block_to_ast(b: &Block) -> ir::AstBlock {
    ir::AstBlock {
        statements: b.statements.iter().map(stmt_to_ast).collect(),
        ret: b.ret.as_ref().map(|r| Box::new(expr_to_ast(r))),
    }
}

fn stmt_to_ast(s: &Stmt) -> ir::AstStmt {
    let kind = match &s.kind {
        StmtKind::Bind { type_, name, value } => ir::AstStmtKind::Bind {
            type_: type_
                .as_ref()
                .map(|t| ir::type_to_str(&parser_type_to_ir(t))),
            name: name.0.clone(),
            value: Box::new(expr_to_ast(value)),
        },
        StmtKind::Discard(e) => ir::AstStmtKind::Discard(Box::new(expr_to_ast(e))),
        StmtKind::Destructure { pattern, source } => ir::AstStmtKind::Destructure {
            pattern: pat_to_ast(pattern),
            source: Box::new(expr_to_ast(source)),
        },
        StmtKind::Expr(e) => ir::AstStmtKind::Expr(Box::new(expr_to_ast(e))),
        StmtKind::Return(e) => {
            ir::AstStmtKind::Return(e.as_ref().map(|x| Box::new(expr_to_ast(x))))
        }
        StmtKind::Break => ir::AstStmtKind::Break,
        StmtKind::Continue => ir::AstStmtKind::Continue,
    };
    ir::AstStmt { kind, span: sp_to_ir(&s.span) }
}

fn expr_to_ast(e: &Expr) -> ir::AstExpr {
    let span = sp_to_ir(&e.span);
    match &e.kind {
        ExprKind::Id(id) => ir::AstExpr::Id(id.0.clone()),
        ExprKind::Literal(lit) => lit_to_ast(lit, &e.span),
        ExprKind::Location => ir::AstExpr::Location(span),
        ExprKind::BinaryOp { op, lhs, rhs } => ir::AstExpr::BinaryOp {
            op: binop_from_op(op),
            lhs: Box::new(expr_to_ast(lhs)),
            rhs: Box::new(expr_to_ast(rhs)),
            span,
        },
        ExprKind::UnaryOp { op, operand } => match op {
            OpKind::Minus => ir::AstExpr::UnaryOp {
                op: UnaryOp::Neg,
                operand: Box::new(expr_to_ast(operand)),
                span,
            },
            OpKind::Not => ir::AstExpr::UnaryOp {
                op: UnaryOp::Not,
                operand: Box::new(expr_to_ast(operand)),
                span,
            },
            OpKind::Tilde => ir::AstExpr::UnaryOp {
                op: UnaryOp::BitNot,
                operand: Box::new(expr_to_ast(operand)),
                span,
            },
            _ => expr_to_ast(operand),
        },
        ExprKind::Cast { type_, operand } => ir::AstExpr::UnaryOp {
            op: UnaryOp::Cast(Box::new(parser_type_to_ir(type_))),
            operand: Box::new(expr_to_ast(operand)),
            span,
        },
        ExprKind::Call { func, args } => ir::AstExpr::Call {
            func: Box::new(expr_to_ast(func)),
            args: args
                .iter()
                .map(|(n, a)| (n.as_ref().map(|i| i.0.clone()), expr_to_ast(a)))
                .collect(),
            span,
        },
        ExprKind::Rt(inner) => ir::AstExpr::Rt(Box::new(expr_to_ast(inner)), span),
        ExprKind::AtResidual { type_, inner } => ir::AstExpr::AtResidual {
            type_: parser_type_to_ir(type_),
            inner: Box::new(expr_to_ast(inner)),
            span,
        },
        ExprKind::If {
            cond,
            then_block,
            else_block,
        } => ir::AstExpr::If {
            cond: Box::new(expr_to_ast(cond)),
            then_block: Box::new(block_to_ast(then_block)),
            else_block: else_block.as_ref().map(|b| Box::new(block_to_ast(b))),
            span,
        },
        ExprKind::While { cond, body } => ir::AstExpr::While {
            cond: Box::new(expr_to_ast(cond)),
            body: Box::new(block_to_ast(body)),
            span,
        },
        ExprKind::ForIn {
            type_,
            name,
            collection,
            body,
        } => ir::AstExpr::ForIn {
            type_: ir::type_to_str(&parser_type_to_ir(type_)),
            name: name.0.clone(),
            collection: Box::new(expr_to_ast(collection)),
            body: Box::new(block_to_ast(body)),
            span,
        },
        ExprKind::Match { scrutinee, arms } => ir::AstExpr::Match {
            scrutinee: Box::new(expr_to_ast(scrutinee)),
            arms: arms
                .iter()
                .map(|(p, a)| (pat_to_ast(p), expr_to_ast(a)))
                .collect(),
            span,
        },
        ExprKind::For {
            init,
            cond,
            step,
            body,
        } => ir::AstExpr::For {
            init: init.as_ref().map(stmt_to_ast),
            cond: Box::new(expr_to_ast(cond)),
            step: step.as_ref().map(stmt_to_ast),
            body: Box::new(block_to_ast(body)),
            span,
        },
        ExprKind::Spawn { capabilities, body } => ir::AstExpr::Spawn {
            capabilities: caps_to_ir(capabilities),
            body: block_to_ast(body),
            span,
        },
        ExprKind::Assert { cond, message } => ir::AstExpr::Assert {
            cond: Box::new(expr_to_ast(cond)),
            message: Box::new(expr_to_ast(message)),
            span,
        },
        ExprKind::RtAssert { cond, message } => ir::AstExpr::RtAssert {
            cond: Box::new(expr_to_ast(cond)),
            message: Box::new(expr_to_ast(message)),
            span,
        },
        ExprKind::Known(inner) => ir::AstExpr::Known(Box::new(expr_to_ast(inner)), span),
        ExprKind::RtKnown(inner) => ir::AstExpr::RtKnown(Box::new(expr_to_ast(inner)), span),
        ExprKind::ComptimePrint(inner) => {
            ir::AstExpr::ComptimePrint(Box::new(expr_to_ast(inner)), span)
        }
        ExprKind::Todo(_) => ir::AstExpr::Todo(span),
        ExprKind::Unimplemented(_) => ir::AstExpr::Unimplemented(span),
        ExprKind::StructLit { name, fields } => ir::AstExpr::StructLit {
            name: name.0.clone(),
            fields: fields
                .iter()
                .map(|(n, v)| (n.0.clone(), expr_to_ast(v)))
                .collect(),
            span,
        },
        ExprKind::ListLit(v) => ir::AstExpr::ListLit(v.iter().map(expr_to_ast).collect(), span),
        ExprKind::MapLit(v) => ir::AstExpr::MapLit(
            v.iter().map(|(k, val)| (expr_to_ast(k), expr_to_ast(val))).collect(),
            span,
        ),
        ExprKind::SetLit(v) => ir::AstExpr::SetLit(v.iter().map(expr_to_ast).collect(), span),
        ExprKind::Range { start, end, closed } => ir::AstExpr::Range {
            start: Box::new(expr_to_ast(start)),
            end: Box::new(expr_to_ast(end)),
            closed: *closed,
            span,
        },
        ExprKind::FString(parts) => ir::AstExpr::FString(
            parts
                .iter()
                .map(|p| match p {
                    FStringPart::Text(t) => ir::AstFStringPart::Text(t.clone()),
                    FStringPart::Expr(x) => ir::AstFStringPart::Expr(Box::new(expr_to_ast(x))),
                })
                .collect(),
            span,
        ),
        ExprKind::RawString(s) => ir::AstExpr::RawString(s.clone(), span),
        ExprKind::ByteString(b) => ir::AstExpr::ByteString(b.clone(), span),
        ExprKind::FieldAccess { target, field } => ir::AstExpr::FieldAccess {
            target: Box::new(expr_to_ast(target)),
            field: field.0.clone(),
            span,
        },
        ExprKind::Index { target, index } => ir::AstExpr::Index {
            target: Box::new(expr_to_ast(target)),
            index: Box::new(expr_to_ast(index)),
            span,
        },
        ExprKind::Slice { target, range } => ir::AstExpr::Slice {
            target: Box::new(expr_to_ast(target)),
            range: Box::new(ir::AstRange {
                start: range.start.as_ref().map(expr_to_ast),
                end: range.end.as_ref().map(expr_to_ast),
                closed: range.closed,
            }),
            span,
        },
        ExprKind::MethodCall { target, method, args } => ir::AstExpr::MethodCall {
            target: Box::new(expr_to_ast(target)),
            method: method.0.clone(),
            args: args.iter().map(|a| expr_to_ast(a)).collect(),
            span,
        },
        ExprKind::EarlyReturn(v) => ir::AstExpr::EarlyReturn(Box::new(expr_to_ast(v)), span),
        ExprKind::ElseFallback { value, fallback } => ir::AstExpr::ElseFallback {
            value: Box::new(expr_to_ast(value)),
            fallback: block_to_ast(fallback),
            span,
        },
        ExprKind::Destructure { pattern, source } => ir::AstExpr::Destructure {
            pattern: pat_to_ast(pattern),
            source: Box::new(expr_to_ast(source)),
            span,
        },
        ExprKind::IfLet {
            pattern,
            source,
            then_block,
            else_block,
        } => ir::AstExpr::IfLet {
            pattern: pat_to_ast(pattern),
            source: Box::new(expr_to_ast(source)),
            then_block: Box::new(block_to_ast(then_block)),
            else_block: else_block.as_ref().map(|b| Box::new(block_to_ast(b))),
            span,
        },
        ExprKind::WhileLet {
            pattern,
            source,
            body,
        } => ir::AstExpr::WhileLet {
            pattern: pat_to_ast(pattern),
            source: Box::new(expr_to_ast(source)),
            body: Box::new(block_to_ast(body)),
            span,
        },
        ExprKind::With { bindings, body } => ir::AstExpr::With {
            bindings: bindings
                .iter()
                .map(|b| ir::AstWithBinding {
                    type_: Some(ir::type_to_str(&parser_type_to_ir(&b.type_))),
                    name: b.name.0.clone(),
                    init: Box::new(expr_to_ast(&b.init)),
                })
                .collect(),
            body: block_to_ast(body),
            span,
        },
        ExprKind::Using { value, behavior } => ir::AstExpr::Using {
            value: Box::new(expr_to_ast(value)),
            behavior: behavior.0.clone(),
            span,
        },
        ExprKind::ProviderCall { provider, verb, args } => ir::AstExpr::ProviderCall {
            provider: provider.0.clone(),
            verb: verb.0.clone(),
            args: args.iter().map(|a| expr_to_ast(a)).collect(),
            span,
        },
        ExprKind::Discard(e) => ir::AstExpr::Discard(Box::new(expr_to_ast(e)), span),
    }
}

fn lit_to_ast(lit: &Literal, span: &LexSpan) -> ir::AstExpr {
    let sp = sp_to_ir(span);
    match lit {
        Literal::Int { value, kind } => ir::AstExpr::Literal {
            value: *value,
            kind: match kind {
                IntKind::Decimal(_) => ir::AstIntKind::Decimal,
                IntKind::Hex(_) => ir::AstIntKind::Hex,
                IntKind::Binary(_) => ir::AstIntKind::Binary,
                IntKind::Octal(_) => ir::AstIntKind::Octal,
            },
            span: sp,
        },
        Literal::Float(f) => ir::AstExpr::FloatLit {
            value: f.value.clone(),
            span: sp,
        },
        Literal::Dec(d) => ir::AstExpr::FloatLit {
            value: d.to_string(),
            span: sp,
        },
        Literal::Char(c) => ir::AstExpr::CharLit(*c, sp),
        Literal::Str(s) => ir::AstExpr::StrLit {
            value: s.value.clone(),
            span: sp,
        },
        Literal::RawStr(s) => ir::AstExpr::RawString(s.value.clone(), sp),
        Literal::ByteStr(b) => ir::AstExpr::ByteString(b.value.clone(), sp),
        Literal::Bool(b) => ir::AstExpr::BoolLit(*b, sp),
        Literal::Null => ir::AstExpr::NullLit(sp),
    }
}

fn binop_from_op(op: &OpKind) -> BinOp {
    match op {
        OpKind::Plus => BinOp::Add,
        OpKind::Minus => BinOp::Sub,
        OpKind::Star => BinOp::Mul,
        OpKind::Slash => BinOp::Div,
        OpKind::Percent => BinOp::Rem,
        OpKind::ShiftLeft => BinOp::ShiftLeft,
        OpKind::ShiftRight => BinOp::ShiftRight,
        OpKind::Amp | OpKind::AndAnd => BinOp::And,
        OpKind::Caret => BinOp::Xor,
        OpKind::Pipe | OpKind::OrOr => BinOp::Or,
        OpKind::EqEq => BinOp::Eq,
        OpKind::Ne => BinOp::Ne,
        OpKind::Less => BinOp::Lt,
        OpKind::LessEq => BinOp::Le,
        OpKind::Greater => BinOp::Gt,
        OpKind::GreaterEq => BinOp::Ge,
        _ => BinOp::Eq,
    }
}

fn pat_to_ast(p: &Pattern) -> ir::AstPattern {
    let kind = match &p.kind {
        PatternKind::Wildcard => ir::AstPatternKind::Wildcard,
        PatternKind::Bind(id) => ir::AstPatternKind::Bind(id.0.clone()),
        PatternKind::Variant { name, param } => ir::AstPatternKind::Variant {
            name: name.0.clone(),
            param: param.as_ref().map(|i| i.0.clone()),
        },
        PatternKind::Literal(l) => match l {
            Literal::Int { value, .. } => ir::AstPatternKind::Literal(*value),
            Literal::Bool(b) => ir::AstPatternKind::Literal(*b as u128),
            _ => ir::AstPatternKind::Wildcard,
        },
        PatternKind::Struct { name, fields } => ir::AstPatternKind::Struct {
            name: name.0.clone(),
            fields: fields
                .iter()
                .map(|(n, p)| (n.0.clone(), pat_to_ast(p)))
                .collect(),
        },
    };
    ir::AstPattern {
        kind,
        span: sp_to_ir(&p.span),
    }
}

// ─── Reverse direction (IR → parser AST) ───────────────────────────

pub fn to_ast(unit: ir::AstTranslationUnit) -> TranslationUnit {
    let declarations = unit
        .functions
        .into_iter()
        .map(|f| Declaration::Function(func_to_parser(f)))
        .collect();
    TranslationUnit {
        imports: vec![],
        declarations,
    }
}

fn func_to_parser(f: ir::AstFuncDef) -> FuncDef {
    FuncDef {
        pub_: f.public,
        name: Id(f.name.clone()),
        params: f
            .params
            .into_iter()
            .map(|p| Param {
                type_: type_surface_to_type(p.type_.as_deref().unwrap_or("Int(64)")),
                name: Id(p.name),
                default: p.default.map(|d| ast_expr_to_parser(&d)),
            })
            .collect(),
        ret: type_surface_to_type(f.ret.as_deref().unwrap_or("Void")),
        body: ast_block_to_parser(f.body),
        doc_comments: f.doc_comments.clone(),
        capabilities: vec![],
        sandbox_ceiling: vec![],
        span: sp_to_parser(&f.span),
    }
}

fn ast_block_to_parser(b: ir::AstBlock) -> Block {
    Block {
        statements: b.statements.into_iter().map(ast_stmt_to_parser).collect(),
        ret: b.ret.map(|r| Box::new(ast_expr_to_parser(&r))),
        span: unknown_pspan(),
    }
}

fn ast_stmt_to_parser(s: ir::AstStmt) -> Stmt {
    let kind = match s.kind {
        ir::AstStmtKind::Bind { type_, name, value } => StmtKind::Bind {
            type_: type_.as_deref().map(type_surface_to_type),
            name: Id(name),
            value: Box::new(ast_expr_to_parser(&value)),
        },
        ir::AstStmtKind::Discard(e) => StmtKind::Discard(Box::new(ast_expr_to_parser(&e))),
        ir::AstStmtKind::Destructure { pattern, source } => StmtKind::Destructure {
            pattern: ast_pat_to_parser(&pattern),
            source: Box::new(ast_expr_to_parser(&source)),
        },
        ir::AstStmtKind::Expr(e) => StmtKind::Expr(Box::new(ast_expr_to_parser(&e))),
        ir::AstStmtKind::Return(v) => {
            StmtKind::Return(v.map(|x| Box::new(ast_expr_to_parser(&x))))
        }
        ir::AstStmtKind::Break => StmtKind::Break,
        ir::AstStmtKind::Continue => StmtKind::Continue,
    };
    Stmt {
        kind,
        span: sp_to_parser(&s.span),
    }
}

fn ast_expr_to_parser(e: &ir::AstExpr) -> Expr {
    let sp = unknown_pspan();
    let kind = match e.clone() {
        ir::AstExpr::Id(name) => ExprKind::Id(Id(name)),
        ir::AstExpr::Literal { value, kind: ik, .. } => ExprKind::Literal(Literal::Int {
            value,
            kind: match ik {
                ir::AstIntKind::Decimal => IntKind::Decimal(value.to_string()),
                ir::AstIntKind::Hex => IntKind::Hex(format!("{value:x}")),
                ir::AstIntKind::Binary => IntKind::Binary(format!("{value:b}")),
                ir::AstIntKind::Octal => IntKind::Octal(format!("{value:o}")),
            },
        }),
        ir::AstExpr::FloatLit { value, .. } => {
            ExprKind::Literal(Literal::Float(FloatLit { value }))
        }
        ir::AstExpr::StrLit { value, .. } => {
            ExprKind::Literal(Literal::Str(StrLit { value }))
        }
        ir::AstExpr::BoolLit(b, _) => ExprKind::Literal(Literal::Bool(b)),
        ir::AstExpr::NullLit(_) => ExprKind::Literal(Literal::Null),
        ir::AstExpr::CharLit(c, _) => ExprKind::Literal(Literal::Char(c)),
        ir::AstExpr::Location(_) => ExprKind::Location,
        ir::AstExpr::BinaryOp { op, lhs, rhs, .. } => ExprKind::BinaryOp {
            op: op_to_parser(op),
            lhs: Box::new(ast_expr_to_parser(&lhs)),
            rhs: Box::new(ast_expr_to_parser(&rhs)),
        },
        ir::AstExpr::UnaryOp { op, operand, .. } => match op {
            UnaryOp::Neg => ExprKind::UnaryOp {
                op: OpKind::Minus,
                operand: Box::new(ast_expr_to_parser(&operand)),
            },
            UnaryOp::Not => ExprKind::UnaryOp {
                op: OpKind::Not,
                operand: Box::new(ast_expr_to_parser(&operand)),
            },
            UnaryOp::BitNot => ExprKind::UnaryOp {
                op: OpKind::Tilde,
                operand: Box::new(ast_expr_to_parser(&operand)),
            },
            UnaryOp::Cast(ty) => ExprKind::Cast {
                type_: ir_ty_to_parser(&ty),
                operand: Box::new(ast_expr_to_parser(&operand)),
            },
        },
        ir::AstExpr::Call { func, args, .. } => ExprKind::Call {
            func: Box::new(ast_expr_to_parser(&func)),
            args: args
                .into_iter()
                .map(|(n, a)| (n.map(Id), ast_expr_to_parser(&a)))
                .collect(),
        },
        ir::AstExpr::Rt(inner, _) => ExprKind::Rt(Box::new(ast_expr_to_parser(&inner))),
        ir::AstExpr::AtResidual { type_, inner, .. } => ExprKind::AtResidual {
            type_: ir_ty_to_parser(&type_),
            inner: Box::new(ast_expr_to_parser(&inner)),
        },
        ir::AstExpr::If {
            cond,
            then_block,
            else_block,
            ..
        } => ExprKind::If {
            cond: Box::new(ast_expr_to_parser(&cond)),
            then_block: Box::new(ast_block_to_parser(*then_block)),
            else_block: else_block.map(|b| Box::new(ast_block_to_parser(*b))),
        },
        ir::AstExpr::While { cond, body, .. } => ExprKind::While {
            cond: Box::new(ast_expr_to_parser(&cond)),
            body: Box::new(ast_block_to_parser(*body)),
        },
        ir::AstExpr::ForIn {
            type_, name, collection, body, ..
        } => ExprKind::ForIn {
            type_: type_surface_to_type(&type_),
            name: Id(name),
            collection: Box::new(ast_expr_to_parser(&collection)),
            body: Box::new(ast_block_to_parser(*body)),
        },
        ir::AstExpr::Match { scrutinee, arms, .. } => ExprKind::Match {
            scrutinee: Box::new(ast_expr_to_parser(&scrutinee)),
            arms: arms
                .into_iter()
                .map(|(p, a)| (ast_pat_to_parser(&p), ast_expr_to_parser(&a)))
                .collect(),
        },
        ir::AstExpr::For {
            init,
            cond,
            step,
            body,
            ..
        } => ExprKind::For {
            init: init.map(|i| ast_stmt_to_parser(i)),
            cond: Box::new(ast_expr_to_parser(&cond)),
            step: step.map(|s| ast_stmt_to_parser(s)),
            body: Box::new(ast_block_to_parser(*body)),
        },
        ir::AstExpr::Spawn { capabilities, body, .. } => ExprKind::Spawn {
            capabilities: caps_to_parser(&capabilities),
            body: ast_block_to_parser(body),
        },
        ir::AstExpr::Assert { cond, message, .. } => ExprKind::Assert {
            cond: Box::new(ast_expr_to_parser(&cond)),
            message: Box::new(ast_expr_to_parser(&message)),
        },
        ir::AstExpr::RtAssert { cond, message, .. } => ExprKind::RtAssert {
            cond: Box::new(ast_expr_to_parser(&cond)),
            message: Box::new(ast_expr_to_parser(&message)),
        },
        ir::AstExpr::Known(inner, _) => ExprKind::Known(Box::new(ast_expr_to_parser(&inner))),
        ir::AstExpr::RtKnown(inner, _) => ExprKind::RtKnown(Box::new(ast_expr_to_parser(&inner))),
        ir::AstExpr::ComptimePrint(inner, _) => {
            ExprKind::ComptimePrint(Box::new(ast_expr_to_parser(&inner)))
        }
        ir::AstExpr::Todo(_) => ExprKind::Todo(String::new()),
        ir::AstExpr::Unimplemented(_) => ExprKind::Unimplemented(String::new()),
        ir::AstExpr::StructLit { name, fields, .. } => ExprKind::StructLit {
            name: Id(name),
            fields: fields
                .into_iter()
                .map(|(n, v)| (Id(n), ast_expr_to_parser(&v)))
                .collect(),
        },
        ir::AstExpr::ListLit(v, _) => {
            ExprKind::ListLit(v.into_iter().map(|x| ast_expr_to_parser(&x)).collect())
        }
        ir::AstExpr::MapLit(v, _) => ExprKind::MapLit(
            v.into_iter()
                .map(|(k, val)| (ast_expr_to_parser(&k), ast_expr_to_parser(&val)))
                .collect(),
        ),
        ir::AstExpr::SetLit(v, _) => {
            ExprKind::SetLit(v.into_iter().map(|x| ast_expr_to_parser(&x)).collect())
        }
        ir::AstExpr::Range { start, end, closed, .. } => ExprKind::Range {
            start: Box::new(ast_expr_to_parser(&start)),
            end: Box::new(ast_expr_to_parser(&end)),
            closed,
        },
        ir::AstExpr::FString(parts, _) => ExprKind::FString(
            parts
                .into_iter()
                .map(|p| match p {
                    ir::AstFStringPart::Text(t) => FStringPart::Text(t),
                    ir::AstFStringPart::Expr(x) => {
                        FStringPart::Expr(Box::new(ast_expr_to_parser(&x)))
                    }
                })
                .collect(),
        ),
        ir::AstExpr::RawString(s, _) => ExprKind::RawString(s),
        ir::AstExpr::ByteString(b, _) => ExprKind::ByteString(b),
        ir::AstExpr::FieldAccess { target, field, .. } => ExprKind::FieldAccess {
            target: Box::new(ast_expr_to_parser(&target)),
            field: Id(field),
        },
        ir::AstExpr::Index { target, index, .. } => ExprKind::Index {
            target: Box::new(ast_expr_to_parser(&target)),
            index: Box::new(ast_expr_to_parser(&index)),
        },
        ir::AstExpr::Slice { target, range, .. } => ExprKind::Slice {
            target: Box::new(ast_expr_to_parser(&target)),
            range: Box::new(resid_parser::RangeExpr {
                start: range.start.as_ref().map(ast_expr_to_parser),
                end: range.end.as_ref().map(ast_expr_to_parser),
                closed: range.closed,
            }),
        },
        ir::AstExpr::MethodCall { target, method, args, .. } => ExprKind::MethodCall {
            target: Box::new(ast_expr_to_parser(&target)),
            method: Id(method),
            args: args.into_iter().map(|a| Box::new(ast_expr_to_parser(&a))).collect(),
        },
        ir::AstExpr::EarlyReturn(v, _) => ExprKind::EarlyReturn(Box::new(ast_expr_to_parser(&v))),
        ir::AstExpr::ElseFallback { value, fallback, .. } => ExprKind::ElseFallback {
            value: Box::new(ast_expr_to_parser(&value)),
            fallback: ast_block_to_parser(fallback),
        },
        ir::AstExpr::Destructure { pattern, source, .. } => ExprKind::Destructure {
            pattern: ast_pat_to_parser(&pattern),
            source: Box::new(ast_expr_to_parser(&source)),
        },
        ir::AstExpr::IfLet {
            pattern,
            source,
            then_block,
            else_block,
            ..
        } => ExprKind::IfLet {
            pattern: ast_pat_to_parser(&pattern),
            source: Box::new(ast_expr_to_parser(&source)),
            then_block: Box::new(ast_block_to_parser(*then_block)),
            else_block: else_block.map(|b| Box::new(ast_block_to_parser(*b))),
        },
        ir::AstExpr::WhileLet {
            pattern,
            source,
            body,
            ..
        } => ExprKind::WhileLet {
            pattern: ast_pat_to_parser(&pattern),
            source: Box::new(ast_expr_to_parser(&source)),
            body: Box::new(ast_block_to_parser(*body)),
        },
        ir::AstExpr::With { bindings, body, .. } => ExprKind::With {
            bindings: bindings
                .into_iter()
                .map(|b| resid_parser::WithBinding {
                    type_: type_surface_to_type(b.type_.as_deref().unwrap_or("Int(64)")),
                    name: Id(b.name),
                    init: Box::new(ast_expr_to_parser(&b.init)),
                })
                .collect(),
            body: ast_block_to_parser(body),
        },
        ir::AstExpr::Using { value, behavior, .. } => ExprKind::Using {
            value: Box::new(ast_expr_to_parser(&value)),
            behavior: Id(behavior),
        },
        ir::AstExpr::Discard(e, _) => ExprKind::Discard(Box::new(ast_expr_to_parser(&e))),
        ir::AstExpr::ProviderCall {
            provider, verb, args, ..
        } => ExprKind::ProviderCall {
            provider: Id(provider),
            verb: Id(verb),
            args: args.into_iter().map(|a| Box::new(ast_expr_to_parser(&a))).collect(),
        },
        ir::AstExpr::Span(_) => ExprKind::Location,
    };
    Expr { kind, span: sp }
}

fn ast_pat_to_parser(p: &ir::AstPattern) -> Pattern {
    let kind = match &p.kind {
        ir::AstPatternKind::Wildcard => PatternKind::Wildcard,
        ir::AstPatternKind::Bind(n) => PatternKind::Bind(Id(n.clone())),
        ir::AstPatternKind::Variant { name, param } => PatternKind::Variant {
            name: Id(name.clone()),
            param: param.as_ref().map(|x| Id(x.clone())),
        },
        ir::AstPatternKind::Literal(v) => PatternKind::Literal(Literal::Int {
            value: *v,
            kind: IntKind::Decimal(v.to_string()),
        }),
        ir::AstPatternKind::Struct { name, fields } => PatternKind::Struct {
            name: Id(name.clone()),
            fields: fields
                .iter()
                .map(|(n, fp)| (Id(n.clone()), ast_pat_to_parser(fp)))
                .collect(),
        },
    };
    Pattern {
        kind,
        span: sp_to_parser(&p.span),
    }
}

fn op_to_parser(b: BinOp) -> OpKind {
    match b {
        BinOp::Add => OpKind::Plus,
        BinOp::Sub => OpKind::Minus,
        BinOp::Mul => OpKind::Star,
        BinOp::Div => OpKind::Slash,
        BinOp::Rem => OpKind::Percent,
        BinOp::ShiftLeft => OpKind::ShiftLeft,
        BinOp::ShiftRight => OpKind::ShiftRight,
        // IR merges logical/bitwise AND; the logical spelling round-trips
        // through the parser. Reduced graphs fold bitwise ops on constants and
        // only rarely retain residual bitwise ops on params.
        BinOp::And => OpKind::AndAnd,
        BinOp::Or => OpKind::OrOr,
        BinOp::Xor => OpKind::Caret,
        BinOp::Eq => OpKind::EqEq,
        BinOp::Ne => OpKind::Ne,
        BinOp::Lt => OpKind::Less,
        BinOp::Le => OpKind::LessEq,
        BinOp::Gt => OpKind::Greater,
        BinOp::Ge => OpKind::GreaterEq,
    }
}

// ─── Capability conversion ──────────────────────────────────────────

fn caps_to_ir(caps: &[CapabilityAnnotation]) -> Vec<ir::Capability> {
    caps.iter()
        .map(|c| ir::Capability {
            kind: cap_kind(&c.name.0),
            params: vec![],
        })
        .collect()
}

fn cap_kind(name: &str) -> ir::CapabilityKind {
    match name {
        "filesystem" => ir::CapabilityKind::Filesystem,
        "git" => ir::CapabilityKind::Git,
        "environment" => ir::CapabilityKind::Environment,
        _ => ir::CapabilityKind::Compute,
    }
}

fn caps_to_parser(caps: &[ir::Capability]) -> Vec<CapabilityAnnotation> {
    caps.iter()
        .map(|c| CapabilityAnnotation {
            name: Id(c.kind.name().to_string()),
            params: vec![],
        })
        .collect()
}

// ─── Type conversion ────────────────────────────────────────────────

fn parser_type_to_ir(t: &PType) -> ir::Type {
    match t {
        PType::Base { name, params } => parser_base_to_ir(&name.0, params.as_deref()),
        PType::ISize => ir::Type::Numeric(NumericType::ISize),
        PType::USize => ir::Type::Numeric(NumericType::USize),
        PType::Refined { base, .. } => parser_type_to_ir(base),
        PType::Residual(inner) => ir::Type::Residual(Box::new(parser_type_to_ir(inner))),
        PType::Literal(l) => match l {
            Literal::Bool(_) => ir::Type::Bool,
            Literal::Char(_) => ir::Type::Numeric(NumericType::Int(ir::IntWidth::B16)),
            Literal::Null => ir::Type::Null,
            _ => ir::Type::Void,
        },
    }
}

fn parser_base_to_ir(name: &str, params: Option<&[PType]>) -> ir::Type {
    match name {
        "Bool" => ir::Type::Bool,
        "Str" => ir::Type::Str,
        "Bytes" => ir::Type::Bytes,
        "Null" => ir::Type::Null,
        "Void" => ir::Type::Void,
        "SourceLoc" => ir::Type::SourceLoc,
        "RegionError" => ir::Type::RegionError,
        "ISize" => ir::Type::Numeric(NumericType::ISize),
        "USize" => ir::Type::Numeric(NumericType::USize),
        "File" => ir::Type::Handle(Identifier::new("File", 0), Lifetime { name: "static".into() }),
        "Int" | "UInt" | "Float" | "Dec" => {
            let w = params.and_then(|ps| ps.first()).and_then(width_of_type);
            match name {
                "Int" => ir::Type::Numeric(NumericType::Int(
                    w.and_then(ir::IntWidth::from_bits).unwrap_or(ir::IntWidth::B64),
                )),
                "UInt" => ir::Type::Numeric(NumericType::UInt(
                    w.and_then(ir::IntWidth::from_bits).unwrap_or(ir::IntWidth::B64),
                )),
                "Float" => ir::Type::Numeric(NumericType::Float(
                    w.and_then(ir::FloatWidth::from_bits).unwrap_or(ir::FloatWidth::F64),
                )),
                _ => ir::Type::Numeric(NumericType::Dec(w.unwrap_or(34))),
            }
        }
        "List" => param1(params).map_or(ir::Type::List(Box::new(ir::Type::Void)), |t| {
            ir::Type::List(Box::new(parser_type_to_ir(t)))
        }),
        "Map" => match params {
            Some([k, v]) => ir::Type::Map(Box::new(parser_type_to_ir(k)), Box::new(parser_type_to_ir(v))),
            _ => ir::Type::Map(Box::new(ir::Type::Void), Box::new(ir::Type::Void)),
        },
        "Set" => param1(params).map_or(ir::Type::Set(Box::new(ir::Type::Void)), |t| {
            ir::Type::Set(Box::new(parser_type_to_ir(t)))
        }),
        "Option" => param1(params).map_or(ir::Type::Option(Box::new(ir::Type::Void)), |t| {
            ir::Type::Option(Box::new(parser_type_to_ir(t)))
        }),
        "Result" => match params {
            Some([ok, er]) => ir::Type::Result(Box::new(parser_type_to_ir(ok)), Box::new(parser_type_to_ir(er))),
            _ => ir::Type::Result(Box::new(ir::Type::Void), Box::new(ir::Type::Void)),
        },
        "Slice" => param1(params).map_or(ir::Type::Slice { element_type: Box::new(ir::Type::Void) }, |t| {
            ir::Type::Slice { element_type: Box::new(parser_type_to_ir(t)) }
        }),
        "Range" => match params {
            Some([t]) => ir::Type::Range {
                start_type: Box::new(parser_type_to_ir(t)),
                end_type: Box::new(parser_type_to_ir(t)),
                closed: false,
            },
            _ => ir::Type::Range {
                start_type: Box::new(ir::Type::Void),
                end_type: Box::new(ir::Type::Void),
                closed: false,
            },
        },
        _ => ir::Type::UserDefined(name.to_string()),
    }
}

fn param1<'a>(params: Option<&'a [PType]>) -> Option<&'a PType> {
    params.and_then(|ps| ps.first())
}

fn width_of_type(t: &PType) -> Option<u16> {
    match t {
        PType::Literal(Literal::Int { kind, .. }) => kind.digits().parse::<u16>().ok(),
        PType::Base { name, params: None } => name.0.parse::<u16>().ok(),
        _ => None,
    }
}

fn ir_ty_to_parser(t: &ir::Type) -> PType {
    match t {
        ir::Type::Bool => base_ty("Bool"),
        ir::Type::Numeric(nt) => match nt {
            NumericType::Int(w) => width_ty("Int", w.bits()),
            NumericType::UInt(w) => width_ty("UInt", w.bits()),
            NumericType::Float(w) => width_ty("Float", w.bits()),
            NumericType::Dec(n) => width_ty("Dec", *n),
            NumericType::ISize => PType::ISize,
            NumericType::USize => PType::USize,
        },
        ir::Type::Str => base_ty("Str"),
        ir::Type::Bytes => base_ty("Bytes"),
        ir::Type::Null => base_ty("Null"),
        ir::Type::Void => base_ty("Void"),
        ir::Type::Option(inner) => param_ty("Option", vec![ir_ty_to_parser(inner)]),
        ir::Type::Result(ok, er) => param_ty(
            "Result",
            vec![ir_ty_to_parser(ok), ir_ty_to_parser(er)],
        ),
        ir::Type::List(inner) => param_ty("List", vec![ir_ty_to_parser(inner)]),
        ir::Type::Map(k, v) => param_ty("Map", vec![ir_ty_to_parser(k), ir_ty_to_parser(v)]),
        ir::Type::Set(inner) => param_ty("Set", vec![ir_ty_to_parser(inner)]),
        ir::Type::Slice { element_type } => param_ty("Slice", vec![ir_ty_to_parser(element_type)]),
        ir::Type::Range { start_type, .. } => {
            param_ty("Range", vec![ir_ty_to_parser(start_type)])
        }
        ir::Type::Struct(name, _) => base_ty(&name.name),
        ir::Type::Enum(name, _) => base_ty(&name.name),
        ir::Type::Constrained(inner, _) => ir_ty_to_parser(inner),
        ir::Type::Residual(inner) => PType::Residual(Box::new(ir_ty_to_parser(inner))),
        ir::Type::Behavior(b) => base_ty(&b.name.name),
        ir::Type::Handle(name, _) => base_ty(&name.name),
        ir::Type::Function { .. } => base_ty("Void"),
        ir::Type::SourceLoc => base_ty("SourceLoc"),
        ir::Type::RegionError => base_ty("RegionError"),
        ir::Type::UserDefined(s) => base_ty(s),
    }
}

fn base_ty(name: &str) -> PType {
    PType::Base {
        name: Id(name.to_string()),
        params: None,
    }
}

fn width_ty(name: &str, w: u16) -> PType {
    PType::Base {
        name: Id(name.to_string()),
        params: Some(vec![PType::Literal(Literal::Int {
            value: w as u128,
            kind: IntKind::Decimal(w.to_string()),
        })]),
    }
}

fn param_ty(name: &str, ts: Vec<PType>) -> PType {
    PType::Base {
        name: Id(name.to_string()),
        params: Some(ts),
    }
}

/// Re-parse a source-level annotation string (as produced by `type_to_str`)
/// into a parser `Type`. Handles `Int(8)`, `Str`, `List(Int(8))`, etc.
fn type_surface_to_type(s: &str) -> PType {
    let s = s.trim().to_string();
    if let Some(inner) = strip_parens_param(&s, "Int") {
        return width_ty("Int", inner.parse().unwrap_or(64));
    }
    if let Some(inner) = strip_parens_param(&s, "UInt") {
        return width_ty("UInt", inner.parse().unwrap_or(64));
    }
    if let Some(inner) = strip_parens_param(&s, "Float") {
        return width_ty("Float", inner.parse().unwrap_or(64));
    }
    if let Some(inner) = strip_parens_param(&s, "Dec") {
        return width_ty("Dec", inner.parse().unwrap_or(34));
    }
    match s.as_str() {
        "ISize" => return PType::ISize,
        "USize" => return PType::USize,
        "Char" => return width_ty("Int", 16),
        _ => {}
    }
    if let Some(rest) = s.strip_prefix("residual(").and_then(|r| r.strip_suffix(')')) {
        return PType::Residual(Box::new(type_surface_to_type(rest)));
    }
    if let Some((name, rest)) = s.split_once('(')
        && let Some(inner) = rest.strip_suffix(')')
    {
        let params = split_top_level(inner, ',')
            .into_iter()
            .map(|p| type_surface_to_type(&p))
            .collect();
        return PType::Base {
            name: Id(name.trim().to_string()),
            params: Some(params),
        };
    }
    PType::Base {
        name: Id(s),
        params: None,
    }
}

fn strip_parens_param<'a>(s: &'a str, name: &str) -> Option<&'a str> {
    let rest = s.trim_start().strip_prefix(name)?;
    let rest = rest.trim_start().strip_prefix('(')?;
    let rest = rest.strip_suffix(')')?;
    Some(rest.trim())
}

/// Split on a separator at nesting depth zero (type parameter lists).
fn split_top_level(s: &str, sep: char) -> Vec<String> {
    let mut out = Vec::new();
    let mut depth = 0i32;
    let mut cur = String::new();
    for c in s.chars() {
        match c {
            '(' | '[' => {
                depth += 1;
                cur.push(c);
            }
            ')' | ']' => {
                depth -= 1;
                cur.push(c);
            }
            _ if c == sep && depth == 0 => {
                if !cur.trim().is_empty() {
                    out.push(cur.trim().to_string());
                }
                cur.clear();
            }
            _ => cur.push(c),
        }
    }
    if !cur.trim().is_empty() {
        out.push(cur.trim().to_string());
    }
    out
}

// ─── Span conversion ────────────────────────────────────────────────

fn sp_to_ir(s: &LexSpan) -> ir::Span {
    ir::Span {
        file: s.file.clone(),
        line: s.line,
        col_start: s.col_start,
        col_end: s.col_end,
    }
}

fn sp_to_parser(s: &ir::Span) -> LexSpan {
    LexSpan {
        file: s.file.clone(),
        line: s.line,
        col_start: s.col_start,
        col_end: s.col_end,
    }
}

fn unknown_pspan() -> LexSpan {
    LexSpan {
        file: "<reduced>".into(),
        line: 0,
        col_start: 0,
        col_end: 0,
    }
}