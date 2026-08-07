/// Integration test: parse → type-check → LLVM IR for a small program.
use inkwell::context::Context;
use crate::CodeGen;
use resid_parser::Parser;

#[test]
fn test_add_fn() {
    let src = r#"
Int add(Int a, Int b) {
    return a + b;
}

Int main() {
    Int x = 40;
    Int y = 2;
    return add(x, y);
}
"#;
    let (unit, errors) = Parser::parse("add.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "add");
    cg.generate(&unit).expect("codegen failed");

    // Module must verify
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_widening_to_128() {
    // Int64 + Int64 → Int128 per spec widening rules.
    let src = r#"
Int main() {
    Int a = 1;
    Int b = 2;
    return a + b;
}
"#;
    let (unit, errors) = Parser::parse("wid.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "wid");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    // Verify the add was promoted to i128
    assert!(ir.contains("sext i64"), "expected sext to 128-bit");
    assert!(ir.contains("add i128"), "expected i128 add");
}

#[test]
fn test_bool_return() {
    let src = r#"
Int main() {
    Bool b = true;
    return b;
}
"#;
    let (unit, errors) = Parser::parse("bool.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "bool");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_unary_minus() {
    let src = r#"
Int main() {
    Int x = -42;
    return x;
}
"#;
    let (unit, errors) = Parser::parse("neg.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "neg");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("neg"), "expected neg instruction");
}
