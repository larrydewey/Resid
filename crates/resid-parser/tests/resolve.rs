use std::fs;
use std::path::PathBuf;

use resid_parser::resolve_unit;

fn temp_dir(tag: &str) -> PathBuf {
    let dir = std::env::temp_dir().join(format!("resid-resolve-{}-{}", tag, std::process::id()));
    let _ = fs::remove_dir_all(&dir);
    fs::create_dir_all(&dir).unwrap();
    dir
}

fn write(dir: &PathBuf, rel: &str, content: &str) -> PathBuf {
    let p = dir.join(rel);
    fs::create_dir_all(p.parent().unwrap()).unwrap();
    fs::write(&p, content).unwrap();
    p
}

#[test]
fn resolves_simple_import() {
    let dir = temp_dir("simple");
    write(
        &dir,
        "lib/util.resid",
        r#"
pub Int add(Int a, Int b) {
    return a + b;
}
Int hidden() {
    return 0;
}
"#,
    );
    let root = write(
        &dir,
        "src/main.resid",
        r#"
import "../lib/util.resid";
Int main() {
    return add(1, 2);
}
"#,
    );
    let unit = resolve_unit(&root).expect("resolve ok");
    let names: Vec<&str> = unit
        .declarations
        .iter()
        .map(|d| match d {
            resid_parser::Declaration::Function(f) => f.name.0.as_str(),
            _ => "?",
        })
        .collect();
    // Imported first (post-order), root last; only pub functions cross files.
    assert_eq!(names, vec!["add", "main"], "{names:?}");
}

#[test]
fn import_selection_keeps_only_named() {
    let dir = temp_dir("select");
    write(
        &dir,
        "util.resid",
        "pub Int a() { return 1; }\npub Int b() { return 2; }\n",
    );
    let root = write(
        &dir,
        "main.resid",
        "import \"util.resid\" (a);\nInt main() { return a(); }\n",
    );
    let unit = resolve_unit(&root).expect("resolve ok");
    assert_eq!(unit.declarations.len(), 2, "only `a` plus main");
}

#[test]
fn diamond_import_deduplicates() {
    let dir = temp_dir("diamond");
    write(&dir, "base.resid", "pub Int base() { return 1; }\n");
    write(
        &dir,
        "left.resid",
        "import \"base.resid\";\npub Int left() { return base(); }\n",
    );
    write(
        &dir,
        "right.resid",
        "import \"base.resid\";\npub Int right() { return base(); }\n",
    );
    let root = write(
        &dir,
        "main.resid",
        "import \"left.resid\";\nimport \"right.resid\";\nInt main() { return left() + right(); }\n",
    );
    let unit = resolve_unit(&root).expect("resolve ok");
    let count = unit
        .declarations
        .iter()
        .filter(|d| matches!(d, resid_parser::Declaration::Function(f) if f.name.0 == "base"))
        .count();
    assert_eq!(count, 1, "base included once, got {count}");
}

#[test]
fn import_cycle_terminates() {
    let dir = temp_dir("cycle");
    write(
        &dir,
        "a.resid",
        "import \"b.resid\";\npub Int fa() { return fb(); }\n",
    );
    write(
        &dir,
        "b.resid",
        "import \"a.resid\";\npub Int fb() { return fa(); }\n",
    );
    let root = write(&dir, "main.resid", "import \"a.resid\";\nInt main() { return fa(); }\n");
    let unit = resolve_unit(&root).expect("cycle resolves");
    assert_eq!(unit.declarations.len(), 3);
}

#[test]
fn import_as_is_rejected() {
    let dir = temp_dir("alias");
    write(&dir, "u.resid", "pub Int a() { return 1; }\n");
    let root = write(
        &dir,
        "main.resid",
        "import \"u.resid\" as U;\nInt main() { return 0; }\n",
    );
    let e = resolve_unit(&root).err().expect("alias must error");
    assert!(e.message.contains("not supported"), "{}", e.message);
}

#[test]
fn missing_import_file_errors() {
    let dir = temp_dir("missing");
    let root = write(
        &dir,
        "main.resid",
        "import \"nope.resid\";\nInt main() { return 0; }\n",
    );
    let e = resolve_unit(&root).err().expect("missing import must error");
    assert!(
        e.message.contains("cannot read") || e.message.contains("no such file"),
        "{}",
        e.message
    );
}

#[test]
fn non_pub_function_not_visible() {
    let dir = temp_dir("priv");
    write(
        &dir,
        "u.resid",
        "Int secret() { return 9; }\npub Int open() { return 1; }\n",
    );
    let root = write(
        &dir,
        "main.resid",
        "import \"u.resid\";\nInt main() { return open(); }\n",
    );
    let unit = resolve_unit(&root).expect("resolve ok");
    let has_secret = unit
        .declarations
        .iter()
        .any(|d| matches!(d, resid_parser::Declaration::Function(f) if f.name.0 == "secret"));
    assert!(!has_secret, "private function leaked into merged unit");
}

#[test]
fn types_are_always_exported() {
    let dir = temp_dir("types");
    write(&dir, "geom.resid", "type Point = { x: Int, y: Int };\npub Int px(Point p) { return p.x; }\n");
    let root = write(
        &dir,
        "main.resid",
        "import \"geom.resid\";\nInt main() {\n    Point p = Point { x: 1, y: 2 };\n    return px(p);\n}\n",
    );
    let unit = resolve_unit(&root).expect("resolve ok");
    assert!(
        unit.declarations
            .iter()
            .any(|d| matches!(d, resid_parser::Declaration::Type(_))),
        "type def carried across"
    );
}

#[test]
fn dependency_import_by_package_name() {
    let dir = temp_dir("dep");
    // Dependency package: lib/math.resid with its own manifest.
    write(
        &dir,
        "vendor/math/src/main.resid",
        "pub Int dbl(Int x) {\n    return x * 2;\n}\n",
    );
    fs::write(dir.join("vendor/math/resid.toml"), "[package]\nname = \"math\"\nversion = \"0.1.0\"\n").unwrap();
    let root = write(
        &dir,
        "main.resid",
        "import \"math\";\nInt main() { return dbl(21); }\n",
    );
    let deps = resid_parser::DependencyMap::from([(
        "math".to_string(),
        dir.join("vendor/math/src/main.resid"),
    )]);
    let unit = resid_parser::resolve_unit_with(&root, &deps).expect("resolve ok");
    assert_eq!(unit.declarations.len(), 2);
}

#[test]
fn unknown_dependency_import_errors() {
    let dir = temp_dir("nodep");
    let root = write(
        &dir,
        "main.resid",
        "import \"ghost\";\nInt main() { return 0; }\n",
    );
    let e = resolve_unit(&root).err().expect("must fail");
    assert!(e.message.contains("no dependency"), "{}", e.message);
}
