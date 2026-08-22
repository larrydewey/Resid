use resid_fmt::format_source;

fn fmt(src: &str) -> String {
    format_source(src).expect("format ok")
}

#[test]
fn canonical_layout_and_spacing() {
    let out = fmt("Int main(){\n  Int x=1+2*3;\n  return x;\n}\n");
    assert_eq!(
        out,
        "Int main() {\n    Int x = 1 + 2 * 3;\n    return x;\n}\n"
    );
}

#[test]
fn precedence_preserved_without_extra_parens() {
    let out = fmt("Int main() {\n    Int x = 1 + 2 * 3;\n    Int y = (1 + 2) * 3;\n    return x + y;\n}\n");
    assert!(out.contains("1 + 2 * 3;"));
    assert!(out.contains("(1 + 2) * 3;"));
}

#[test]
fn idempotent_on_control_flow() {
    let src = "Int main() {\n    if (x > 3) {\n        println(\"hi\");\n    } else {\n        println(\"lo\");\n    }\n    for (Int i in 0..3) {\n        println(IntToString(i));\n    }\n    while (false) {\n        break;\n    }\n    return 0;\n}\n";
    let once = fmt(src);
    assert_eq!(once, fmt(&once), "not idempotent");
}

#[test]
fn string_escapes_round_trip() {
    let src = "Int main() {\n    Str s = \"a\\\"b\\\\c\\nd\";\n    println(s);\n    return 0;\n}\n";
    let once = fmt(src);
    assert!(once.contains("\"a\\\"b\\\\c\\nd\""), "{once}");
    assert_eq!(once, fmt(&once));
}

#[test]
fn imports_types_and_match_format() {
    let src = "import \"u.resid\" as U;\nimport \"v.resid\" (a,b);\ntype P = { x: Int, y: Int };\ntype R = Some(Int) | None;\nInt main() {\n    Option(Int) m = Some(1);\n    Int v = match m { Some(k) => k, None => 0, };\n    return v;\n}\n";
    let once = fmt(src);
    assert!(once.contains("import \"u.resid\" as U;"));
    assert!(once.contains("import \"v.resid\" (a, b);"));
    assert!(once.contains("type P = { x: Int, y: Int };"));
    assert!(once.contains("type R = Some(Int) | None;"));
    assert!(once.contains("Some(k) => k,"));
    assert_eq!(once, fmt(&once));
}
