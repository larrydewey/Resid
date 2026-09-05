//! End-to-end graph reduce tests: convert → reduce → retrofit.

use resid_ir::*;

fn span() -> Span {
    Span {
        file: "test".into(),
        line: 1,
        col_start: 0,
        col_end: 1,
    }
}

fn func(name: &str, body: AstBlock, ret: Option<String>) -> AstFuncDef {
    AstFuncDef {
        public: false,
        name: name.to_string(),
        params: vec![],
        ret,
        body,
        doc_comments: vec![],
        capabilities: vec![],
        span: span(),
    }
}

fn bind_stmt(name: &str, value: AstExpr) -> AstStmt {
    AstStmt {
        kind: AstStmtKind::Bind {
            type_: None,
            name: name.to_string(),
            value: Box::new(value),
        },
        span: span(),
    }
}

fn ilit(v: u128) -> AstExpr {
    AstExpr::Literal {
        value: v,
        kind: AstIntKind::Decimal,
        span: span(),
    }
}

fn bin(op: BinOp, l: AstExpr, r: AstExpr) -> AstExpr {
    AstExpr::BinaryOp {
        op,
        lhs: Box::new(l),
        rhs: Box::new(r),
        span: span(),
    }
}

fn unit_with(fs: Vec<AstFuncDef>) -> AstTranslationUnit {
    AstTranslationUnit {
        imports: vec![],
        functions: fs,
    }
}

/// `2 + 3` must fold to the literal 5 at compile time.
#[test]
fn folds_binary_literal() {
    let body = AstBlock {
        statements: vec![bind_stmt("x", bin(BinOp::Add, ilit(2), ilit(3)))],
        ret: Some(Box::new(AstExpr::Id("x".into()))),
    };
    let u = graph_reduce(unit_with(vec![func("main", body, None)]), &[]).expect("reduce");
    let main = u.functions.iter().find(|f| f.name == "main").unwrap();
    match main.body.ret.as_deref().map(|e| as_int(e)) {
        Some(Some(5)) => {}
        other => panic!("expected 5, got {:?}", other),
    }
}

/// `120 / 254` on UInt(8) folds to 0 (checked division, no overflow).
#[test]
fn folds_division_to_zero() {
    let expr = AstExpr::UnaryOp {
        op: UnaryOp::Cast(Box::new(Type::Numeric(NumericType::UInt(IntWidth::B8)))),
        operand: Box::new(ilit(120)),
        span: span(),
    };
    // Force UInt(8) operands: 120 as cast, then divide by the cast of 254.
    let lhs = AstExpr::UnaryOp {
        op: UnaryOp::Cast(Box::new(Type::Numeric(NumericType::UInt(IntWidth::B8)))),
        operand: Box::new(ilit(120)),
        span: span(),
    };
    let rhs = AstExpr::UnaryOp {
        op: UnaryOp::Cast(Box::new(Type::Numeric(NumericType::UInt(IntWidth::B8)))),
        operand: Box::new(ilit(254)),
        span: span(),
    };
    let _ = expr;
    let body = AstBlock {
        statements: vec![],
        ret: Some(Box::new(bin(BinOp::Div, lhs, rhs))),
    };
    let u = graph_reduce(unit_with(vec![func("main", body, Some("UInt(8)".into()))]), &[])
        .expect("reduce");
    let main = u.functions.iter().find(|f| f.name == "main").unwrap();
    match main.body.ret.as_deref().map(|e| as_cast_int(e)) {
        Some(Some(0)) => {}
        other => panic!("expected 0, got {:?}", other),
    }
}

fn as_int(e: &AstExpr) -> Option<u128> {
    if let AstExpr::Literal { value, .. } = e {
        Some(*value)
    } else {
        None
    }
}

fn as_cast_int(e: &AstExpr) -> Option<u128> {
    if let AstExpr::UnaryOp {
        op: UnaryOp::Cast(_),
        operand,
        ..
    } = e
    {
        as_int(operand)
    } else {
        as_int(e)
    }
}

/// A residual use (parameter-dependent) must survive reduction unchanged.
#[test]
fn keeps_residual_param() {
    let param = AstParam {
        type_: Some("Int".into()),
        name: "n".into(),
        default: None,
    };
    let body = AstBlock {
        statements: vec![],
        ret: Some(Box::new(AstExpr::Id("n".into()))),
    };
    let f = AstFuncDef {
        public: false,
        name: "identity".to_string(),
        params: vec![param],
        ret: Some("Int".into()),
        body,
        doc_comments: vec![],
        capabilities: vec![],
        span: span(),
    };
    let u = graph_reduce(unit_with(vec![f]), &[]).expect("reduce");
    let id = u.functions.iter().find(|f| f.name == "identity").unwrap();
    // The function must still take the parameter and return it unchanged.
    assert_eq!(id.params.len(), 1);
    assert!(matches!(
        id.body.ret.as_deref(),
        Some(AstExpr::Id(name)) if name == "n"
    ));
}

/// Compile-time if with a known constant condition collapses to its branch.
#[test]
fn collapses_constant_if() {
    let then_block = AstBlock {
        statements: vec![],
        ret: Some(Box::new(ilit(42))),
    };
    let else_block = AstBlock {
        statements: vec![],
        ret: Some(Box::new(ilit(7))),
    };
    let e = AstExpr::If {
        cond: Box::new(AstExpr::BoolLit(true, span())),
        then_block: Box::new(then_block),
        else_block: Some(Box::new(else_block)),
        span: span(),
    };
    let body = AstBlock {
        statements: vec![],
        ret: Some(Box::new(e)),
    };
    let u = graph_reduce(unit_with(vec![func("main", body, None)]), &[]).expect("reduce");
    let main = u.functions.iter().find(|f| f.name == "main").unwrap();
    assert_eq!(main.body.ret.as_deref().map(|e| as_int(e)), Some(Some(42)));
}

/// A pure call with constant argument inlines to its body's result.
#[test]
fn inlines_pure_call() {
    let callee = AstFuncDef {
        public: false,
        name: "doubler".to_string(),
        params: vec![AstParam {
            type_: Some("Int".into()),
            name: "x".into(),
            default: None,
        }],
        ret: Some("Int".into()),
        body: AstBlock {
            statements: vec![],
            ret: Some(Box::new(bin(BinOp::Add, AstExpr::Id("x".into()), AstExpr::Id("x".into())))),
        },
        doc_comments: vec![],
        capabilities: vec![],
        span: span(),
    };
    let call = AstExpr::Call {
        func: Box::new(AstExpr::Id("doubler".into())),
        args: vec![(None, ilit(21))],
        span: span(),
    };
    let body = AstBlock {
        statements: vec![],
        ret: Some(Box::new(call)),
    };
    let u = graph_reduce(unit_with(vec![callee, func("main", body, None)]), &[])
        .expect("reduce");
    let main = u.functions.iter().find(|f| f.name == "main").unwrap();
    assert_eq!(main.body.ret.as_deref().map(|e| as_int(e)), Some(Some(42)));
}