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

/// Dead-code elimination (§36): bindings whose values folded to constants and
/// whose names are no longer referenced by the residual computation are elided
/// from the reduced program. Here `live` is only referenced from a call site
/// that β-reduces away, so *all* bindings in `main` fold to nothing.
#[test]
fn dead_bindings_eliminated_from_reduced_unit() {
    let (unit, errs) = Parser::parse(
        "graph_reduce_test.resid",
        r#"
Int main() {
    Int dead_a = 1;
    Int live = 40 + 2;
    Int dead_b = live * 2;
    println(IntToString(live));
    return 0;
}
"#,
    );
    assert!(errs.is_empty(), "parse errors: {errs:?}");
    let reduced = resid_type::graph_reduce(unit, &[]).expect("graph reduce failed");
    let type_errors = resid_type::check_program(&reduced);
    assert!(
        type_errors.is_empty(),
        "reduced program fails type check: {type_errors:?}"
    );
    let main_binds = bindings_of(&reduced, "main");
    assert_eq!(
        main_binds,
        Vec::<&str>::new(),
        "every binding in a fully-folded body must be elided, got {main_binds:?}"
    );
}

/// A binding whose value stays residual because it references a parameter is
/// live computation and must survive DCE.
#[test]
fn referenced_residual_binding_is_preserved() {
    let (unit, errs) = Parser::parse(
        "graph_reduce_test.resid",
        r#"
Int inc(Int n) {
    Int m = n + 1;
    return m;
}
Int main() {
    Int dead_a = 1;
    println(IntToString(inc(5)));
    return 0;
}
"#,
    );
    assert!(errs.is_empty(), "parse errors: {errs:?}");
    let reduced = resid_type::graph_reduce(unit, &[]).expect("graph reduce failed");
    let type_errors = resid_type::check_program(&reduced);
    assert!(
        type_errors.is_empty(),
        "reduced program fails type check: {type_errors:?}"
    );
    assert_eq!(
        bindings_of(&reduced, "inc"),
        vec!["m"],
        "a parameter-referenced binding is live computation"
    );
    assert_eq!(
        bindings_of(&reduced, "main"),
        Vec::<&str>::new(),
        "the unreferenced constant binding folds away"
    );
}

fn bindings_of<'a>(unit: &'a resid_parser::TranslationUnit, fname: &str) -> Vec<&'a str> {
    unit.declarations
        .iter()
        .find_map(|d| match d {
            resid_parser::Declaration::Function(f) if f.name.0 == fname => Some(f),
            _ => None,
        })
        .map(|f| {
            f.body
                .statements
                .iter()
                .filter_map(|s| match &s.kind {
                    resid_parser::StmtKind::Bind { name, .. } => Some(name.0.as_str()),
                    _ => None,
                })
                .collect()
        })
        .unwrap_or_default()
}

/// DCE soundness: a binding whose value is *not* a folded constant is never
/// elided, even when its name is never referenced (its evaluation may have
/// observable effects).
#[test]
fn dead_binding_with_effect_is_preserved() {
    let (unit, errs) = Parser::parse(
        "graph_reduce_test.resid",
        r#"
Int main() {
    Bool unused = println("side-effect");
    return 0;
}
"#,
    );
    assert!(errs.is_empty(), "parse errors: {errs:?}");
    let reduced = resid_type::graph_reduce(unit, &[]).expect("graph reduce failed");
    let type_errors = resid_type::check_program(&reduced);
    assert!(
        type_errors.is_empty(),
        "reduced program fails type check: {type_errors:?}"
    );
    let main = reduced
        .declarations
        .iter()
        .find_map(|d| match d {
            resid_parser::Declaration::Function(f) if f.name.0 == "main" => Some(f),
            _ => None,
        })
        .expect("main survived");
    let binds: Vec<&str> = main
        .body
        .statements
        .iter()
        .filter_map(|s| match &s.kind {
            resid_parser::StmtKind::Bind { name, .. } => Some(name.0.as_str()),
            _ => None,
        })
        .collect();
    assert_eq!(
        binds,
        vec!["unused"],
        "an effectful binding must survive DCE, got {binds:?}"
    );
}