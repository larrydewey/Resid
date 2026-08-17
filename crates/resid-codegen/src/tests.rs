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
fn test_wide_128_literal_not_truncated() {
    // A 128-bit literal that exceeds i64 must not be truncated to 64 bits.
    let src = r#"
Int main() {
    Int(128) big = 18446744073709551617;
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("wid128.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "wid128");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(
        ir.contains("i128"),
        "expected i128 type for wide literal: {ir}"
    );
}

#[test]
fn test_wide_256_decimal_literal_preserved() {
    // A 2^256-1 decimal literal (well past u128) must survive lexing and be
    // emitted as a full i256 constant rather than silently truncating to 0.
    let src = r#"
Int main() {
    UInt(256) big = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
    println(UInt256ToString(big));
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("wid256.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "wid256");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(
        ir.contains("i256") && !ir.contains("add i256"),
        "expected a full i256 literal constant, not one assembled from ops: {ir}"
    );
}

#[test]
fn test_wide_hex_literal_preserved() {
    // Hex literals >u128 were already carried as strings; ensure the constant
    // is built from the hex digits (0xFFFF... ) at full width.
    let src = r#"
Int main() {
    UInt(256) big = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    println(UInt256ToString(big));
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("widhex.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "widhex");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(
        ir.contains("i256"),
        "expected i256 for wide hex literal: {ir}"
    );
}

#[test]
fn test_wide_128_arith_and_tostring() {
    let src = r#"
Int main() {
    Int(128) a = 5;
    Int(128) b = 7;
    Int(128) c = a + b;
    println(Int128ToString(c));
    UInt(128) u = 18446744073709551617;
    println(UInt128ToString(u));
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("wid128arith.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "wid128arith");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    // Int(128) + Int(128) widens to Int(256) per spec (carry bit).
    assert!(ir.contains("sext i128"), "expected sext i128: {ir}");
    assert!(ir.contains("add i256"), "expected i256 add: {ir}");
    assert!(
        ir.contains("@Int128ToString"),
        "expected Int128ToString call: {ir}"
    );
    assert!(
        ir.contains("@UInt128ToString"),
        "expected UInt128ToString call: {ir}"
    );
}

#[test]
fn test_wide_256_tostring_decomposes_limbs() {
    // Int(256)/UInt(256)/Int(512)/UInt(512) stringify by decomposing the
    // value into little-endian u64 limbs for the C ABI runtime helpers.
    let src = r#"
Int main() {
    Int(256) a = 340282366920938463463374607431768211455;
    println(Int256ToString(a));
    UInt(512) u = 7;
    println(UInt512ToString(u));
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("wid256.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "wid256");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    // 256-bit call takes 4 i64 limbs; 512-bit takes 8.
    assert!(
        ir.contains("@Int256ToString(i64, i64, i64, i64)"),
        "expected 4-limb Int256ToString decl: {ir}"
    );
    assert!(
        ir.contains("@UInt512ToString(i64, i64, i64, i64, i64, i64, i64, i64)"),
        "expected 8-limb UInt512ToString decl: {ir}"
    );
    assert!(ir.contains("lshr i256"), "expected i256 limb shift: {ir}");
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
fn test_string_introspection_calls() {
    let src = r#"
Int main() {
    Str s = "hello";
    Int n = str_len(s);
    Int c = str_char_at(s, 0);
    Str one = str_from_code(c);
    Str sub = str_slice(s, 1, 3);
    return n;
}
"#;
    let (unit, errors) = Parser::parse("strintr.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "strintr");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("call i64 @str_len"), "expected str_len: {ir}");
    assert!(ir.contains("call i64 @str_char_at"), "expected str_char_at: {ir}");
    assert!(ir.contains("call ptr @str_from_code"), "expected str_from_code: {ir}");
    assert!(ir.contains("call ptr @str_slice"), "expected str_slice: {ir}");
}

#[test]
fn test_char_literal_is_i64() {
    let src = r#"
Int main() {
    Int a = 'a';
    return a;
}
"#;
    let (unit, errors) = Parser::parse("charlit.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "charlit");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    // 'a' = 97, stored to the alloca; look for the constant.
    assert!(ir.contains("97"), "expected char literal 97 in IR: {ir}");
    assert!(!ir.contains("c\"a\\00\""), "char literal should not be a string: {ir}");
}

#[test]
fn test_str_eq_call() {
    let src = r#"
Int main() {
    Str a = "if";
    Bool same = a == "if";
    Bool diff = a != "while";
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("streq.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "streq");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    assert!(
        ir.contains("call i8 @resid_str_eq"),
        "expected resid_str_eq call: {ir}"
    );
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

#[test]
fn test_fstring_interpolation_lowering() {
    let src = r#"
Int main() {
    Str name = "world";
    Int n = 42;
    println(f"hello {name} n={n}");
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("fstr.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fstr");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    // Interpolated parts stitch together via resid_str_concat.
    assert!(
        ir.contains("call ptr @resid_str_concat"),
        "expected runtime string concat: {ir}"
    );
    assert!(
        ir.contains("call ptr @IntToString"),
        "expected IntToString for interpolated Int: {ir}"
    );
}

#[test]
fn test_str_plus_str_runtime_concat() {
    let src = r#"
Str make(Str x) {
    return x + "!";
}

Int main() {
    Str a = "foo";
    Str b = "bar";
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("sconcat.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "sconcat");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");

    let ir = cg.module.print_to_string().to_string();
    // Non-constant Str + Str lowers to a runtime concat call.
    assert!(
        ir.contains("call ptr @resid_str_concat"),
        "expected runtime string concat: {ir}"
    );
}

#[test]
fn test_provider_call_env_get() {
    let src = r#"
Int main() {
    Str x = environment.get("HOME");
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("prov.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "prov");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("call ptr @resid_env_get"), "expected resid_env_get: {ir}");
}

#[test]
fn test_provider_call_env_has() {
    let src = r#"
Int main() {
    Bool x = environment.has("PATH");
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("prov.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "prov");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("call i8 @resid_env_has"), "expected resid_env_has: {ir}");
}

#[test]
fn test_provider_call_git_branch() {
    let src = r#"
Int main() {
    Str x = git.branch();
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("prov.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "prov");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("call ptr @resid_git_branch"), "expected resid_git_branch: {ir}");
}

#[test]
fn test_provider_call_fs_exists() {
    let src = r#"
Int main() {
    Bool x = filesystem.exists("test.txt");
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("prov.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "prov");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("call i8 @resid_fs_exists"), "expected resid_fs_exists: {ir}");
}

#[test]
fn test_provider_call_fs_list_dir() {
    let src = r#"
Int main() {
    List(Str) dir = filesystem.list_dir(".");
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("prov.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "prov");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("call ptr @resid_fs_list_dir"), "expected resid_fs_list_dir: {ir}");
}

// ─── Float arithmetic codegen tests ─────────────────────────────

#[test]
fn test_float_literal() {
    let src = r#"
Float main() {
    Float a = 3.14;
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("f.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "f");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_float_add() {
    let src = r#"
Float main() {
    Float a = 1.5;
    Float b = 2.5;
    return a + b;
}
"#;
    let (unit, errors) = Parser::parse("fa.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fa");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("fadd"), "expected fadd: {ir}");
}

#[test]
fn test_float_sub() {
    let src = r#"
Float main() {
    Float a = 5.0;
    Float b = 3.0;
    return a - b;
}
"#;
    let (unit, errors) = Parser::parse("fs.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fs");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("fsub"), "expected fsub: {ir}");
}

#[test]
fn test_float_mul() {
    let src = r#"
Float main() {
    Float a = 3.0;
    Float b = 4.0;
    return a * b;
}
"#;
    let (unit, errors) = Parser::parse("fm.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fm");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("fmul"), "expected fmul: {ir}");
}

#[test]
fn test_float_div() {
    let src = r#"
Float main() {
    Float a = 10.0;
    Float b = 3.0;
    return a / b;
}
"#;
    let (unit, errors) = Parser::parse("fd.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fd");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("fdiv"), "expected fdiv: {ir}");
}

#[test]
fn test_float_rem() {
    let src = r#"
Float main() {
    Float a = 10.0;
    Float b = 3.0;
    return a % b;
}
"#;
    let (unit, errors) = Parser::parse("fr.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fr");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("frem"), "expected frem: {ir}");
}

#[test]
fn test_float_unary_neg() {
    let src = r#"
Float main() {
    Float a = 3.14;
    Float b = -a;
    return b;
}
"#;
    let (unit, errors) = Parser::parse("fn.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fn");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_float_comparison_lt() {
    let src = r#"
Int main() {
    Float a = 1.0;
    Float b = 2.0;
    if (a < b) {
        return 1;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("fl.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fl");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("fcmp olt"), "expected fcmp olt: {ir}");
}

#[test]
fn test_float_comparison_gt() {
    let src = r#"
Int main() {
    Float a = 3.0;
    Float b = 1.0;
    if (a > b) {
        return 1;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("fg.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fg");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("fcmp ogt"), "expected fcmp ogt: {ir}");
}

#[test]
fn test_float_comparison_eq() {
    let src = r#"
Int main() {
    Float a = 1.0;
    Float b = 1.0;
    if (a == b) {
        return 1;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("fe.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fe");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("fcmp oeq"), "expected fcmp oeq: {ir}");
}

#[test]
fn test_float_ne() {
    let src = r#"
Int main() {
    Float a = 1.0;
    Float b = 2.0;
    if (a != b) {
        return 1;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("fne.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fne");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("fcmp one"), "expected fcmp one: {ir}");
}

#[test]
fn test_float_le() {
    let src = r#"
Int main() {
    Float a = 1.0;
    Float b = 2.0;
    if (a <= b) {
        return 1;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("fle.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fle");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("fcmp ole"), "expected fcmp ole: {ir}");
}

#[test]
fn test_float_ge() {
    let src = r#"
Int main() {
    Float a = 2.0;
    Float b = 1.0;
    if (a >= b) {
        return 1;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("fge.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fge");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("fcmp oge"), "expected fcmp oge: {ir}");
}

#[test]
fn test_float_float_if() {
    let src = r#"
Float main() {
    Float a = 1.5;
    Float b = 2.5;
    return if (a < b) { a } else { b };
}
"#;
    let (unit, errors) = Parser::parse("ffi.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ffi");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_float_while() {
    let src = r#"
Float main() {
    Float x = 1.0;
    while (x < 10.0) {
        break;
    }
    return x;
}
"#;
    let (unit, errors) = Parser::parse("fw.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fw");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

// ─── More integer edge case tests ───────────────────────────────

#[test]
fn test_int_add() {
    let src = r#"
Int main() {
    Int a = 40;
    Int b = 2;
    return a + b;
}
"#;
    let (unit, errors) = Parser::parse("ia.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ia");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_int_sub() {
    let src = r#"
Int main() {
    Int a = 10;
    Int b = 3;
    return a - b;
}
"#;
    let (unit, errors) = Parser::parse("is.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "is");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_int_mul() {
    let src = r#"
Int main() {
    Int a = 6;
    Int b = 7;
    return a * b;
}
"#;
    let (unit, errors) = Parser::parse("im.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "im");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_int_div() {
    let src = r#"
Int main() {
    Int a = 20;
    Int b = 4;
    return a / b;
}
"#;
    let (unit, errors) = Parser::parse("id.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "id");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_int_rem() {
    let src = r#"
Int main() {
    Int a = 10;
    Int b = 3;
    return a % b;
}
"#;
    let (unit, errors) = Parser::parse("ir.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ir");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_int_shift_left() {
    let src = r#"
Int main() {
    Int a = 1;
    return a << 3;
}
"#;
    let (unit, errors) = Parser::parse("isl.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "isl");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_int_shift_right() {
    let src = r#"
Int main() {
    Int a = 8;
    return a >> 2;
}
"#;
    let (unit, errors) = Parser::parse("isr.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "isr");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_int_bitwise_and() {
    let src = r#"
Int main() {
    Int a = 15;
    Int b = 7;
    return a & b;
}
"#;
    let (unit, errors) = Parser::parse("iba.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "iba");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_int_bitwise_or() {
    let src = r#"
Int main() {
    Int a = 15;
    Int b = 8;
    return a | b;
}
"#;
    let (unit, errors) = Parser::parse("ibo.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ibo");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_int_bitwise_xor() {
    let src = r#"
Int main() {
    Int a = 15;
    Int b = 8;
    return a ^ b;
}
"#;
    let (unit, errors) = Parser::parse("ibx.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ibx");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_int_bitwise_not() {
    let src = r#"
Int main() {
    Int a = 15;
    return ~a;
}
"#;
    let (unit, errors) = Parser::parse("ibn.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ibn");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

// ─── Comparison codegen tests ───────────────────────────────────

#[test]
fn test_int_eq() {
    let src = r#"
Int main() {
    Int a = 5;
    Int b = 5;
    if (a == b) {
        return 1;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("ieq.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ieq");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_int_ne() {
    let src = r#"
Int main() {
    Int a = 5;
    Int b = 3;
    if (a != b) {
        return 1;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("ine.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ine");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_int_lt() {
    let src = r#"
Int main() {
    Int a = 3;
    Int b = 5;
    if (a < b) {
        return 1;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("ilt.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ilt");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_int_le() {
    let src = r#"
Int main() {
    Int a = 5;
    Int b = 5;
    if (a <= b) {
        return 1;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("ile.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ile");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_int_gt() {
    let src = r#"
Int main() {
    Int a = 7;
    Int b = 5;
    if (a > b) {
        return 1;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("igt.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "igt");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_int_ge() {
    let src = r#"
Int main() {
    Int a = 5;
    Int b = 3;
    if (a >= b) {
        return 1;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("ige.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ige");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

// ─── More string tests ─────────────────────────────────────────

#[test]
fn test_string_concat_runtime() {
    let src = r#"
Int main() {
    Str a = "hello";
    Str b = " world";
    Str c = a + b;
    println(c);
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("sc.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "sc");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_string_concat_fold() {
    let src = r#"
Int main() {
    Str c = "hello" + " world";
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("sfc.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "sfc");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    // Constant folding means no resid_str_concat *call* (the runtime
    // declaration itself is always present).
    let ir = cg.module.print_to_string().to_string();
    assert!(
        !ir.contains("call ptr @resid_str_concat"),
        "expected constant-folded string: {ir}"
    );
}

// ─── More control flow tests ────────────────────────────────────

#[test]
fn test_nested_if() {
    let src = r#"
Int main() {
    Int a = 1;
    Int b = 2;
    Int c = 3;
    if (a < b) {
        if (b < c) {
            return 1;
        }
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("ni.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ni");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_while_break_continue() {
    let src = r#"
Int main() {
    Int i = 0;
    while (i < 10) {
        if (i == 5) {
            continue;
        }
        if (i == 8) {
            break;
        }
        Int d = i;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("wbc.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "wbc");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

// ─── Assertion family codegen tests ─────────────────────────────

#[test]
fn test_assert_pass() {
    let src = r#"
Int main() {
    assert(1 == 1, "should be true");
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("ap.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ap");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_known() {
    let src = r#"
Int main() {
    known(42 > 0);
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("tk.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "tk");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

// ─── More composite tests ───────────────────────────────────────

#[test]
fn test_option_some() {
    let src = r#"
Int main() {
    Option(Int) x = Some(42);
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("os.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "os");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_option_none() {
    let src = r#"
Int main() {
    Option(Int) x = None;
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("on.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "on");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_list_lit() {
    let src = r#"
Int main() {
    List(Int) xs = [1, 2, 3];
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("ll.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ll");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_match_option() {
    let src = r#"
Int main() {
    Option(Int) x = Some(42);
    return match x {
        Some(n) => n,
        None => 0,
    };
}
"#;
    let (unit, errors) = Parser::parse("mo.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "mo");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_struct_field_access() {
    let src = r#"
type Pair = { x: Int, y: Int };
Int main() {
    Int x = 1;
    Int y = 2;
    Pair s = Pair { x: x, y: y };
    Int fx = s.x;
    return fx + 1;
}
"#;
    let (unit, errors) = Parser::parse("sf.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "sf");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_list_index() {
    let src = r#"
Int main() {
    List(Int) xs = [10, 20, 30];
    Int first = xs[0];
    return first;
}
"#;
    let (unit, errors) = Parser::parse("li.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "li");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_list_for_in() {
    let src = r#"
Int main() {
    for (Int x in [1, 2, 3]) {
        if (x == 2) {
            return x;
        }
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("lf.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "lf");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_match_list_tags() {
    let src = r#"
Int main() {
    List(Int) xs = [1, 2, 3];
    return match xs {
        EmptyList => 0,
        NonEmptyList => 1,
    };
}
"#;
    let (unit, errors) = Parser::parse("ml.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ml");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_cast_i64_to_i32() {
    let src = r#"
Int main() {
    Int x = 42;
    Int(32) y = (Int(32))x;
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("ci.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ci");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_fstring_interpolation() {
    let src = r#"
Int main() {
    Str name = "world";
    println(f"hello {name}");
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("fs.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fs");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_fstring_pure_text() {
    let src = r#"
Int main() {
    Str s = f"hello";
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("ftp.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ftp");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_raw_string() {
    let src = r#"
Int main() {
    Str s = r"C:\path\file";
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("rs.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "rs");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_byte_string() {
    let src = r#"
Bytes main() {
    Bytes b = b"hello";
    return b;
}
"#;
    let (unit, errors) = Parser::parse("bs.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "bs");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_discard() {
    let src = r#"
Int main() {
    _ = 42;
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("dc.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "dc");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_destructure() {
    let src = r#"
type Pair = { a: Int, b: Int };
Int main() {
    Int x = 1;
    Int y = 2;
    Pair p = Pair { a: x, b: y };
    Pair { a, b } = p;
    return a + b;
}
"#;
    let (unit, errors) = Parser::parse("ds.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ds");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_if_let_some() {
    let src = r#"
Int main() {
    Option(Int) x = Some(42);
    if (Some(n) = x) {
        return n;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("il.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "il");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_while_let() {
    let src = r#"
Int main() {
    Int x = 10;
    Option(Int) o = None;
    while (Some(v) = o) {
        return v;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("wl.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "wl");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_at_residual() {
    let src = r#"
Int main() {
    @residual Int x = 42;
    return x;
}
"#;
    let (unit, errors) = Parser::parse("ar.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ar");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_comptime_print() {
    let src = r#"
Int main() {
    comptime_print(42);
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("cp.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "cp");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_unary_bitwise_not() {
    let src = r#"
Int main() {
    Int a = 15;
    return ~a;
}
"#;
    let (unit, errors) = Parser::parse("ubn.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ubn");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_bool_ops() {
    let src = r#"
Int main() {
    Bool a = true;
    Bool b = false;
    Bool c = a && b;
    Bool d = a || b;
    Bool e = !c;
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("bo.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "bo");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_conversion_helper_i32() {
    let src = r#"
Int main() {
    Int(32) x = i32(42);
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("ci32.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ci32");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_conversion_helper_f64() {
    let src = r#"
Int main() {
    Float(64) x = f64(3.14);
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("cf64.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "cf64");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_wrapping_add() {
    let src = r#"
Int main() {
    Int x = 1;
    Int y = 2;
    Int z = wrapping_add(x, y);
    return z;
}
"#;
    let (unit, errors) = Parser::parse("wa.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "wa");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_saturating_mul() {
    let src = r#"
Int main() {
    Int x = 10;
    Int y = 20;
    Int z = saturating_mul(x, y);
    return z;
}
"#;
    let (unit, errors) = Parser::parse("sm.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "sm");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_checked_div() {
    let src = r#"
Int main() {
    Int x = 20;
    Int y = 4;
    Int z = checked_div(x, y);
    return z;
}
"#;
    let (unit, errors) = Parser::parse("cd.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "cd");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_location() {
    let src = r#"
Int main() {
    SourceLoc loc = #location;
    return loc.line;
}
"#;
    let (unit, errors) = Parser::parse("loc.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "loc");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_range_slice() {
    let src = r#"
Int main() {
    List(Int) xs = [1, 2, 3, 4, 5];
    Slice(Int) s = xs[1..4];
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("rs.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "rs");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_method_call() {
    let src = r#"
Int main() {
    Int x = 42;
    return x;
}
"#;
    let (unit, errors) = Parser::parse("mc.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "mc");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_early_return() {
    let src = r#"
Option(Int) main() {
    Option(Int) x = Some(42);
    Int v = x?;
    return Some(v);
}
"#;
    let (unit, errors) = Parser::parse("er.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "er");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_else_fallback() {
    let src = r#"
Int main() {
    Option(Int) x = None;
    Int y = x else { 0 };
    return y;
}
"#;
    let (unit, errors) = Parser::parse("ef.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ef");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_for_in_inclusive_range() {
    let src = r#"
Int main() {
    Int total = 0;
    for (Int i in 0..=5) {
        if (i == 3) {
            break;
        }
        Int part = i;
    }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("firc.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "firc");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_fn_with_params() {
    let src = r#"
Int add(Int a, Int b) {
    return a + b;
}

Int main() {
    return add(10, 20);
}
"#;
    let (unit, errors) = Parser::parse("fwp.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fwp");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_fn_with_float_params() {
    let src = r#"
Float add(Float a, Float b) {
    return a + b;
}

Int main() {
    Float x = add(1.5, 2.5);
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("ffp.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ffp");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_multiple_statements() {
    let src = r#"
Int main() {
    Int a = 1;
    Int b = 2;
    Int c = a + b;
    Int d = c * 2;
    return d;
}
"#;
    let (unit, errors) = Parser::parse("ms.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ms");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}

#[test]
fn test_forward_reference_and_mutual_recursion() {
    // A function may call another defined later in source order; mutual
    // recursion must resolve because all functions are declared up front.
    let src = r#"
Bool is_even(Int n) {
    if (n == 0) { return true; }
    Int m = n - 1;
    return is_odd(m);
}
Bool is_odd(Int n) {
    if (n == 0) { return false; }
    Int m = n - 1;
    return is_even(m);
}
Int main() {
    if (is_even(10)) { return 1; }
    return 0;
}
"#;
    let (unit, errors) = Parser::parse("fwd.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "fwd");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
    let ir = cg.module.print_to_string().to_string();
    assert!(ir.contains("define"), "expected function defs");
    assert!(ir.contains("call i1 @is_odd"), "expected is_odd call");
}

#[test]
fn test_complex_expression() {
    let src = r#"
Int main() {
    Int a = 1;
    Int b = 2;
    Int c = 3;
    Int d = (a + b) * c;
    return d;
}
"#;
    let (unit, errors) = Parser::parse("ce.resid", src);
    assert!(errors.is_empty(), "parse errors: {errors:?}");
    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "ce");
    cg.generate(&unit).expect("codegen failed");
    cg.module.verify().expect("module failed verification");
}
