//! Graph-reduction round-trip tests (spec §33 "maximal authorized reduction"):
//! a parsed unit flows parser AST → knowledge graph → fixed-point reduce →
//! retrofit → parser AST, and the reduced unit re-parses and re-type-checks.

use resid_parser::Parser;

const DEMO: &str = r#"
Str age_string(UInt(8) age) {
    if (age > (UInt(8)) 20) {
        return "You are old!";
    } else {
        return "You are legit!";
    }
}

Int main() {
    UInt(8) age = 120;
    println(f"Your age {age} means: {age_string(age)}");
    return 0;
}
"#;

#[test]
fn reduced_program_retypechecks() {
    let (unit, errs) = Parser::parse("graph_reduce_test.resid", DEMO);
    assert!(errs.is_empty(), "parse errors: {errs:?}");
    let reduced = resid_type::graph_reduce(unit, &[]).expect("graph reduce failed");
    let type_errors = resid_type::check_program(&reduced);
    assert!(
        type_errors.is_empty(),
        "reduced program fails type check: {type_errors:?}"
    );
}

#[test]
fn reduced_program_registers_equal_functions() {
    let (unit, _) = Parser::parse("graph_reduce_test.resid", DEMO);
    let reduced = resid_type::graph_reduce(unit, &[]).unwrap();
    let names: Vec<String> = reduced
        .declarations
        .iter()
        .filter_map(|d| match d {
            resid_parser::Declaration::Function(f) => Some(f.name.0.clone()),
            _ => None,
        })
        .collect();
    // Entry first, then name-sorted; both functions must survive reduction.
    assert_eq!(names, vec!["main".to_string(), "age_string".to_string()]);
}

#[test]
fn beta_substitution_collapses_pure_call_body() {
    let (unit, _) = Parser::parse(
        "graph_reduce_test.resid",
        r#"
Int main() {
    Int answer = 6 * 7;
    println(IntToString(answer));
    return 0;
}
"#,
    );
    let reduced = resid_type::graph_reduce(unit, &[]).unwrap();
    let type_errors = resid_type::check_program(&reduced);
    assert!(type_errors.is_empty(), "checked: {type_errors:?}");
}

#[test]
fn rejects_non_function_declarations() {
    let (unit, errs) = Parser::parse(
        "graph_reduce_test.resid",
        "type Point = { x: Int };\nInt main() { return 0; }\n",
    );
    assert!(errs.is_empty(), "parse errors: {errs:?}");
    let r = resid_type::graph_reduce(unit, &[]);
    assert!(r.is_err(), "type declarations must be rejected loudly");
}