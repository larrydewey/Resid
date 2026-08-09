use crate::CodeGen;
/// Integration test: parse → type-check → LLVM IR for a small program.
use inkwell::context::Context;
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

#[test]
fn test_string_literal_and_builtin_call() {
    let src = r#"
Int main() {
    println("hi");
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("str.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "str");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    // String global constant `[3 x i8] c"hi\00"` and the extern `println`.
    assert!(
        ir.contains("[3 x i8]"),
        "expected string constant in IR: {ir}"
    );
    assert!(
        ir.contains("declare i1 @println"),
        "expected extern println in IR:\n{ir}"
    );
    assert!(
        ir.contains("call i1 @println"),
        "expected call to println in IR:\n{ir}"
    );
}

#[test]
fn test_string_concat_folding() {
    let src = r#"
Int main() {
    println("a" + "b");
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("concat.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "concat");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(
        ir.contains("[3 x i8]"),
        "expected folded 'ab\\0' string in IR: {ir}"
    );
    assert!(
        ir.contains("c\"ab\\00\""),
        "expected 'ab\\0' content in IR: {ir}"
    );
}

/// Composite values (list/struct/option) lower to boxed runtime objects.
#[test]
fn test_boxed_composites() {
let src = r#"
type Point = { x: Int, y: Int };
Int main() {
    List(Int) xs = [10, 20, 30];
    Point p = Point { x: 3, y: 4 };
    Option(Int) mx = Some(7);
    Int out = match mx {
        Some(n) => n,
        None => 0,
    };
    return out;
}
"#;
    let (unit, errors) = Parser::parse("composites.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "composites");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(
        ir.contains("declare ptr @resid_box_new"),
        "expected boxed runtime decl: {ir}"
    );
    assert!(
        ir.contains("call ptr @resid_box_new"),
        "expected runtime box construction: {ir}"
    );
    assert!(
        ir.contains("@resid_box_slot"),
        "expected slot reads: {ir}"
    );
    assert!(
        ir.contains("@resid_box_tag"),
        "expected tag reads for match: {ir}"
    );
}

#[test]
fn test_if_expression() {
    let src = r#"
Int main() {
    Int x = if (1 < 2) { 10; } else { 20; };
    return x;
}
"#;
    let (unit, errors) = Parser::parse("if.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "iftest");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("if_then"), "expected then block: {ir}");
    assert!(ir.contains("if_else"), "expected else block: {ir}");
    assert!(ir.contains("if_merge"), "expected merge block: {ir}");
    assert!(ir.contains("iff = phi"), "expected phi join: {ir}");
}

#[test]
fn test_while_loop() {
    let src = r#"
Int main() {
    while (true) {
        break;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("whilest.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "whiletest");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("while_cond"), "expected cond block: {ir}");
    assert!(ir.contains("while_body"), "expected body block: {ir}");
    assert!(ir.contains("while_exit"), "expected exit block: {ir}");
}

#[test]
fn test_range_for_in() {
    let src = r#"
Int main() {
    for (Int i in 0..3) {
        println(IntToString(i));
    }
    for (Int j in 0..=2) {
        println(IntToString(j));
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("range.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "rangetest");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(
        ir.contains("forin_r_cond"),
        "expected range cond block: {ir}"
    );
    assert!(
        ir.contains("forin_r_body"),
        "expected range body block: {ir}"
    );
    assert!(ir.contains("slt"), "expected signed < compare: {ir}");
    assert!(ir.contains("sle"), "expected signed <= compare: {ir}");
    assert!(
        ir.contains("add i64 %forin_r_i, 1"),
        "expected i64 loop increment: {ir}"
    );
}
