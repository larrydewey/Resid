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
    let src = "import \"u.resid\" as U;\nimport \"v.resid\" (a,b);\ntype P = { Int x; Int y; };\ntype R = Some(Int) | None;\nInt main() {\n    Option(Int) m = Some(1);\n    Int v = match m { Some(k) => k, None => 0, };\n    return v;\n}\n";
    let once = fmt(src);
    assert!(once.contains("import \"u.resid\" as U;"));
    assert!(once.contains("import \"v.resid\" (a, b);"));
    assert!(once.contains("type P = { Int x; Int y; };"));
    assert!(once.contains("type R = Some(Int) | None;"));
    assert!(once.contains("Some(k) => k,"));
    assert_eq!(once, fmt(&once));
}

#[test]
fn struct_literal_uses_dot_equals_and_reparses() {
    // Real grammar (resid-parser's parse_struct_lit) requires `.field =
    // value`; a prior version of this formatter emitted `field: value`,
    // which fails to reparse. Never caught — no test exercised this.
    let src = "type Point = { Int x; Int y; };\nPoint mk() {\n    return Point { .x = 1, .y = 2 };\n}\n";
    let once = fmt(src);
    assert!(
        once.contains(".x = 1, .y = 2"),
        "expected dot-equals struct literal fields, got: {once}"
    );
    // Round-trips: the formatter's own output must itself be valid Resid
    // (the real, load-bearing property a formatter must have).
    let (_, errors) = resid_parser::Parser::parse("out.resid", &once);
    assert!(errors.is_empty(), "formatted output failed to reparse: {errors:?}");
    assert_eq!(once, fmt(&once));
}

#[test]
fn behavior_declaration_formats_and_reparses() {
    // Previously printed a literal "…" placeholder instead of the real
    // declaration — never caught, no test exercised this either.
    let src = "Int by_y(Point a, Point b) {\n    return a.y - b.y;\n}\ntype Point = { Int x; Int y; };\nOrd(Point) = by_y;\n";
    let once = fmt(src);
    assert!(
        once.contains("Ord(Point) = by_y;"),
        "expected a real behavior declaration, got: {once}"
    );
    let (_, errors) = resid_parser::Parser::parse("out.resid", &once);
    assert!(errors.is_empty(), "formatted output failed to reparse: {errors:?}");
    assert_eq!(once, fmt(&once));
}
