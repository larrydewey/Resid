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

#[test]
fn test_if_let_tag_check() {
    let src = r#"
Int main() {
    Option(Int) mx = Some(7);
    if (Some(n) = mx) {
        println(IntToString(n));
    } else {
        println("none");
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("iflet.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "iflettest");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("iflet_then"), "expected then block: {ir}");
    assert!(ir.contains("iflet_else"), "expected else block: {ir}");
    assert!(ir.contains("iflet_merge"), "expected merge block: {ir}");
    assert!(ir.contains("iflet_tag"), "expected tag comparison: {ir}");
    assert!(
        ir.contains("@resid_box_tag"),
        "expected tag runtime call: {ir}"
    );
}

// ─── Checked/wrapping/saturating arithmetic ─────────────────────

/// Wrapping operations are callable extern functions.
#[test]
fn test_wrapping_add_call() {
    let src = r#"
Int main() {
    Int a = 10;
    Int b = 20;
    Int c = wrapping_add(a, b);
    return c;
}
"#;
    let (unit, errors) = Parser::parse("wrap.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "wrap");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("call i64 @wrapping_add"), "expected wrapping_add call: {ir}");
}

#[test]
fn test_wrapping_mul_call() {
    let src = r#"
Int main() {
    Int a = 7;
    Int b = 8;
    Int c = wrapping_mul(a, b);
    return c;
}
"#;
    let (unit, errors) = Parser::parse("wrapmul.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "wrapmul");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("call i64 @wrapping_mul"), "expected wrapping_mul call: {ir}");
}

#[test]
fn test_saturating_add_call() {
    let src = r#"
Int main() {
    Int a = 42;
    Int b = 58;
    Int c = saturating_add(a, b);
    return c;
}
"#;
    let (unit, errors) = Parser::parse("sat.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "sat");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("call i64 @saturating_add"), "expected saturating_add call: {ir}");
}

#[test]
fn test_saturating_sub_call() {
    let src = r#"
Int main() {
    Int a = 10;
    Int b = 20;
    Int c = saturating_sub(a, b);
    return c;
}
"#;
    let (unit, errors) = Parser::parse("satsub.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "satsub");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(
        ir.contains("call i64 @saturating_sub"),
        "expected saturating_sub call: {ir}"
    );
}

#[test]
fn test_checked_add_call() {
    let src = r#"
Int main() {
    Int a = 10;
    Int b = 20;
    Int c = checked_add(a, b);
    return c;
}
"#;
    let (unit, errors) = Parser::parse("chk.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "chk");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("call i64 @checked_add"), "expected checked_add call: {ir}");
}

#[test]
fn test_checked_mul_call() {
    let src = r#"
Int main() {
    Int a = 6;
    Int b = 7;
    Int c = checked_mul(a, b);
    return c;
}
"#;
    let (unit, errors) = Parser::parse("chkmul.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "chkmul");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("call i64 @checked_mul"), "expected checked_mul call: {ir}");
}

#[test]
fn test_wrapping_div_call() {
    let src = r#"
Int main() {
    Int a = 100;
    Int b = 3;
    Int c = wrapping_div(a, b);
    return c;
}
"#;
    let (unit, errors) = Parser::parse("wrapdiv.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "wrapdiv");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(
        ir.contains("call i64 @wrapping_div"),
        "expected wrapping_div call: {ir}"
    );
}

#[test]
fn test_checked_div_call() {
    let src = r#"
Int main() {
    Int a = 100;
    Int b = 3;
    Int c = checked_div(a, b);
    return c;
}
"#;
    let (unit, errors) = Parser::parse("chkdiv.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "chkdiv");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(
        ir.contains("call i64 @checked_div"),
        "expected checked_div call: {ir}"
    );
}

#[test]
fn test_saturating_mul_call() {
    let src = r#"
Int main() {
    Int a = 999999999;
    Int b = 999999999;
    Int c = saturating_mul(a, b);
    return c;
}
"#;
    let (unit, errors) = Parser::parse("satmul.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "satmul");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(
        ir.contains("call i64 @saturating_mul"),
        "expected saturating_mul call: {ir}"
    );
}

/// All arithmetic runtime decls are present after codegen.
#[test]
fn test_arithmetic_runtime_decls() {
    let src = r#"
Int main() {
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("decls.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "decls");
    cg.generate(&unit).expect("codegen failed");

    let ir = cg.module.print_to_string().to_string();

    // All checked arithmetic decls.
    for name in ["checked_add", "checked_sub", "checked_mul", "checked_div"] {
        assert!(
            ir.contains(&format!("declare i64 @{name}")),
            "expected declare for {name}: {ir}"
        );
    }
    for name in ["checked_uadd", "checked_usub", "checked_umul", "checked_udiv"] {
        assert!(
            ir.contains(&format!("declare i64 @{name}")),
            "expected declare for {name}: {ir}"
        );
    }
    // All wrapping arithmetic decls.
    for name in [
        "wrapping_add", "wrapping_sub", "wrapping_mul", "wrapping_div",
        "wrapping_uadd", "wrapping_usub", "wrapping_umul", "wrapping_udiv",
    ] {
        assert!(
            ir.contains(&format!("declare i64 @{name}")),
            "expected declare for {name}: {ir}"
        );
    }
    // All saturating arithmetic decls.
    for name in [
        "saturating_add", "saturating_sub", "saturating_mul",
        "saturating_uadd", "saturating_usub", "saturating_umul",
    ] {
        assert!(
            ir.contains(&format!("declare i64 @{name}")),
            "expected declare for {name}: {ir}"
        );
    }
}

/// Mixed wrapping + saturating calls in the same function.
#[test]
fn test_wrapping_saturating_mixed() {
    let src = r#"
Int main() {
    Int a = 10;
    Int b = 20;
    Int w = wrapping_mul(a, b);
    Int s = saturating_add(w, a);
    return s;
}
"#;
    let (unit, errors) = Parser::parse("mixed.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "mixed");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("call i64 @wrapping_mul"), "expected wrapping_mul: {ir}");
    assert!(ir.contains("call i64 @saturating_add"), "expected saturating_add: {ir}");
}

#[test]
fn test_range_construction() {
    // Range `0..5` in a for-in loop generates a resid_range_new call.
    let src = r#"
Range(Int) main() {
    Range(Int) r = 0..5;
    return r;
}
"#;
    let (unit, errors) = Parser::parse("range_constr.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "range_constr");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("call ptr @resid_range_new"), "expected range_new call: {ir}");
}

#[test]
fn test_range_construction_closed() {
    // Closed range `0..=4` generates resid_range_new with closed=true.
    let src = r#"
Range(Int) main() {
    Range(Int) r = 0..=4;
    return r;
}
"#;
    let (unit, errors) = Parser::parse("range_constr_closed.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "range_constr_closed");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("call ptr @resid_range_new"), "expected range_new call: {ir}");
}

#[test]
fn test_slice_syntax() {
    let src = r#"
Int main() {
    List(Int) xs = [1, 2, 3, 4, 5];
    Int a = xs[0];
    Int b = xs[4];
    return a + b;
}
"#;
    let (unit, errors) = Parser::parse("slice.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "slice");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("call ptr @resid_box_slot"), "expected box_slot for indexing: {ir}");
}

#[test]
fn test_slice_lowering() {
    // A real slice `xs[1..4]` must lower to a resid_slice_new call.
    let src = r#"
Int main() {
    List(Int) xs = [1, 2, 3, 4, 5];
    Slice(Int) s = xs[1..4];
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("slice_lowering.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "slice_lowering");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(
        ir.contains("call ptr @resid_slice_new"),
        "expected slice_new call: {ir}"
    );
}

#[test]
fn test_slice_lowering_partial_open() {
    // Partial-open slices `xs[..4]`, `xs[1..]`, `xs[..]` all lower to
    // resid_slice_new with resolved bounds.
    for (src, needle) in [
        (
            r#"
Int main() {
    List(Int) xs = [1, 2, 3, 4, 5];
    Slice(Int) s = xs[..4];
    return 0;
}
"#,
            &["call ptr @resid_slice_new", "i64 0, i64 4"][..],
        ),
        (
            r#"
Int main() {
    List(Int) xs = [1, 2, 3, 4, 5];
    Slice(Int) s = xs[1..];
    return 0;
}
"#,
            &["call ptr @resid_slice_new", "i64 1, i64"][..],
        ),
        (
            r#"
Int main() {
    List(Int) xs = [1, 2, 3, 4, 5];
    Slice(Int) s = xs[..];
    return 0;
}
"#,
            &["call ptr @resid_slice_new", "i64 0, i64"][..],
        ),
    ] {
        let (unit, errors) = Parser::parse("slice_po.resid", src);
        assert!(errors.is_empty(), "parse errors: {errors:?} for {needle:?}");

        let cx = Context::create();
        let mut cg = CodeGen::new(&cx, "slice_po");
        cg.generate(&unit).expect("codegen failed");
        cg.module.verify().expect("module failed verification");

        let ir = cg.module.print_to_string().to_string();
        for n in needle {
            assert!(ir.contains(n), "expected `{n}`: {ir}");
        }
    }
}

#[test]
fn test_slice_partial_open() {
    let src = r#"
Int main() {
    List(Int) xs = [1, 2, 3, 4, 5];
    Int a = xs[0];
    return a;
}
"#;
    let (unit, errors) = Parser::parse("slice_partial.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "slice_partial");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_byte_string_lowering() {
    let src = r#"
Int main() {
    Bytes b = b"bestil\0bytes";
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("bytes.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "bytes");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    // A byte string lowers to a packed constant global holding the raw bytes.
    assert!(
        ir.contains("@bytes = unnamed_addr constant [12 x i8] c\"bestil\\00bytes\""),
        "expected packed byte constant global: {ir}"
    );
}

#[test]
fn test_location_lowering() {
    let src = r#"
Int main() {
    SourceLoc loc = #location;
    Str f = loc.file;
    Int l = loc.line;
    Int c = loc.col;
    return l;
}
"#;
    let (unit, errors) = Parser::parse("loc.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "loc");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    // #location boxes a SourceLoc struct via resid_box_* calls.
    assert!(
        ir.contains("call ptr @resid_box_"),
        "expected SourceLoc to be boxed: {ir}"
    );
}
