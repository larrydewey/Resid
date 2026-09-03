use resid_graph::{call_graph, to_dot};
use resid_parser::Parser;

#[test]
fn extracts_calls_and_recursion() {
    let src = r#"
Int sq(Int x) {
    return x * x;
}
Int sum_to(Int n) {
    if (n <= 0) {
        return 0;
    }
    return n + sum_to(n - 1);
}
Int main() {
    return sq(sum_to(3));
}
"#;
    let (unit, errs) = Parser::parse("g.resid", src);
    assert!(errs.is_empty(), "{errs:?}");
    let g = call_graph(&unit);
    assert!(g["main"].contains("sq"));
    assert!(g["main"].contains("sum_to"));
    assert!(g["sum_to"].contains("sum_to"), "recursion edge");
    assert!(g["sq"].is_empty());
}

#[test]
fn extern_builtins_are_not_nodes() {
    let src = "Int main() {\n    println(IntToString(str_len(\"abc\")));\n    return 0;\n}\n";
    let (unit, errs) = Parser::parse("b.resid", src);
    assert!(errs.is_empty(), "{errs:?}");
    let g = call_graph(&unit);
    assert!(g["main"].is_empty(), "{:?}", g["main"]);
}

#[test]
fn dot_output_is_wellformed() {
    let src = "Int f(Int x) {\n    return x;\n}\nInt main() {\n    return f(1);\n}\n";
    let (unit, errs) = Parser::parse("d.resid", src);
    assert!(errs.is_empty(), "{errs:?}");
    let dot = to_dot(&call_graph(&unit));
    assert!(dot.starts_with("digraph calls {"));
    assert!(dot.contains("\"f\";"));
    assert!(dot.contains("\"main\" -> \"f\";"));
    assert!(dot.trim_end().ends_with('}'));
}

#[test]
fn aliased_imports_appear_as_nodes() {
    use std::fs;
    let dir = std::env::temp_dir().join(format!("resid-graph-{}", std::process::id()));
    let _ = fs::remove_dir_all(&dir);
    fs::create_dir_all(&dir).unwrap();
    fs::write(dir.join("lib.resid"), "pub Int helper(Int x) {\n    return x + 1;\n}\n").unwrap();
    fs::write(
        dir.join("main.resid"),
        "import \"lib.resid\" as L;\nInt main() {\n    return L.helper(1);\n}\n",
    )
    .unwrap();
    let unit = resid_parser::resolve_unit(&dir.join("main.resid")).unwrap();
    let g = call_graph(&unit);
    assert!(g.contains_key("L.helper"), "{:?}", g.keys());
    assert!(g["main"].contains("L.helper"));
}
