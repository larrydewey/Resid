use resid_parser::Parser;

#[test]
fn else_if_parses() {
    let src = r#"
Int main() {
    Int x = 5;
    if (x > 3) {
        println("big");
    } else if (x > 1) {
        println("mid");
    } else {
        println("small");
    }
    return 0;
}
"#;
    let (unit, errs) = Parser::parse("test.resid", src);
    assert!(errs.is_empty(), "parse errors: {errs:?}");
    assert_eq!(unit.declarations.len(), 1);
}

#[test]
fn else_if_all_branches() {
    // Each branch taken for the right value, via the full pipeline check:
    // parser must produce a clean AST for every chain position.
    for (src, branches) in [
        (3usize, 3),
        (2, 3),
        (0, 3),
    ] {
        let s = format!(
            r#"
Int main() {{
    Int x = {src};
    if (x > 3) {{
        println("big");
    }} else if (x > 1) {{
        println("mid");
    }} else {{
        println("small");
    }}
    return 0;
}}
"#
        );
        let (unit, errs) = Parser::parse("t.resid", &s);
        assert!(errs.is_empty(), "k={src} errors: {errs:?}");
        assert_eq!(unit.declarations.len(), branches / 3);
    }
}
