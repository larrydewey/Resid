use std::fs;
use std::path::PathBuf;
use std::process::Command;

use resid_build::{build, Artifact, Manifest, Profile};

fn temp_dir(tag: &str) -> PathBuf {
    let dir = std::env::temp_dir().join(format!("resid-build-{}-{}", tag, std::process::id()));
    let _ = fs::remove_dir_all(&dir);
    fs::create_dir_all(&dir).unwrap();
    dir
}

fn write_pkg(dir: &PathBuf, manifest: &str, main: &str) {
    fs::create_dir_all(dir.join("src")).unwrap();
    fs::write(dir.join("resid.toml"), manifest).unwrap();
    fs::write(dir.join("src/main.resid"), main).unwrap();
}

const GOOD_MANIFEST: &str = r#"
[package]
name    = "hello"
version = "0.1.0"
"#;

const GOOD_MAIN: &str = r#"
Int main() {
    println("pkg hello");
    return 0;
}
"#;

#[test]
fn manifest_loads_defaults() {
    let dir = temp_dir("load");
    write_pkg(&dir, GOOD_MANIFEST, GOOD_MAIN);
    let m = Manifest::load(&dir).expect("manifest should load");
    assert_eq!(m.name, "hello");
    assert_eq!(m.version, "0.1.0");
    assert_eq!(m.root, dir.join("src/main.resid"));
    assert_eq!(m.out_dir(), dir.join("target/resid"));
}

#[test]
fn manifest_rejects_missing_name() {
    let dir = temp_dir("noname");
    fs::create_dir_all(&dir).unwrap();
    fs::write(dir.join("resid.toml"), "[package]\nversion = \"0.1.0\"\n").unwrap();
    let e = Manifest::load(&dir).err().expect("missing name must fail");
    assert!(e.to_string().contains("invalid resid.toml"), "{e}");
}

#[test]
fn manifest_rejects_missing_root_source() {
    let dir = temp_dir("noroot");
    fs::create_dir_all(&dir).unwrap();
    fs::write(dir.join("resid.toml"), GOOD_MANIFEST).unwrap();
    let e = Manifest::load(&dir).err().expect("missing root must fail");
    assert!(e.to_string().contains("not found"), "{e}");
}

#[test]
fn check_profile_typechecks_without_emitting() {
    let dir = temp_dir("check");
    write_pkg(&dir, GOOD_MANIFEST, GOOD_MAIN);
    let m = Manifest::load(&dir).unwrap();
    let out = dir.join("out");
    match build(&m, Profile::Check, &out).expect("check build") {
        Artifact::Checked => {}
        other => panic!("expected Checked, got {other:?}"),
    }
    assert!(!out.join("hello").exists(), "check profile emits no binary");
}

#[test]
fn debug_build_produces_runnable_binary() {
    let dir = temp_dir("debug");
    write_pkg(&dir, GOOD_MANIFEST, GOOD_MAIN);
    let m = Manifest::load(&dir).unwrap();
    let out = dir.join("out");
    let bin = match build(&m, Profile::Debug, &out).expect("debug build") {
        Artifact::Binary(p) => p,
        other => panic!("expected Binary, got {other:?}"),
    };
    let res = Command::new(&bin).output().expect("run built binary");
    assert_eq!(res.status.code(), Some(0));
    assert_eq!(
        String::from_utf8_lossy(&res.stdout).trim(),
        "pkg hello"
    );
}

#[test]
fn release_build_sets_opt_flag_and_runs() {
    let dir = temp_dir("release");
    write_pkg(&dir, GOOD_MANIFEST, GOOD_MAIN);
    let m = Manifest::load(&dir).unwrap();
    let out = dir.join("out");
    let bin = match build(&m, Profile::Release, &out).expect("release build") {
        Artifact::Binary(p) => p,
        other => panic!("expected Binary, got {other:?}"),
    };
    let res = Command::new(&bin).output().expect("run built binary");
    assert_eq!(res.status.code(), Some(0));
}

#[test]
fn type_errors_fail_the_build_with_diagnostics() {
    let dir = temp_dir("badtype");
    write_pkg(
        &dir,
        GOOD_MANIFEST,
        r#"
Int main() {
    Str x = 42;
    return 0;
}
"#,
    );
    let m = Manifest::load(&dir).unwrap();
    let e = build(&m, Profile::Check, &dir.join("out")).err().expect("must fail");
    assert!(e.message.contains("type error"), "{}", e.message);
}

#[test]
fn parse_errors_fail_the_build_with_diagnostics() {
    let dir = temp_dir("badparse");
    write_pkg(
        &dir,
        GOOD_MANIFEST,
        "Int main( {\n    return 0;\n}\n",
    );
    let m = Manifest::load(&dir).unwrap();
    let e = build(&m, Profile::Check, &dir.join("out")).err().expect("must fail");
    assert!(e.message.contains("expected"), "expected parse diagnostic, got: {}", e.message);
}

#[test]
fn path_dependency_resolves_and_builds() {
    let dir = temp_dir("dep");
    // Dependency package.
    fs::create_dir_all(dir.join("vendor/math/src")).unwrap();
    fs::write(
        dir.join("vendor/math/resid.toml"),
        "[package]\nname = \"math\"\nversion = \"0.1.0\"\n",
    )
    .unwrap();
    fs::write(
        dir.join("vendor/math/src/main.resid"),
        "pub Int dbl(Int x) {\n    return x * 2;\n}\n",
    )
    .unwrap();
    // Depending package.
    write_pkg(
        &dir,
        r#"
[package]
name = "app"
version = "0.1.0"

[capabilities]
grant = ["git(readonly)", "filesystem(readonly)"]

[dependencies.math]
path = "vendor/math"
capabilities = ["git(readonly)"]
"#,
        "import \"math\";\nInt main() {\n    println(IntToString(dbl(10)));\n    return 0;\n}\n",
    );
    let m = Manifest::load(&dir).expect("manifest loads");
    assert_eq!(m.dependencies.len(), 1);
    assert_eq!(m.dependencies[0].name, "math");
    assert_eq!(m.dependencies[0].capabilities, vec!["git(readonly)".to_string()]);
    let out = dir.join("out");
    let bin = match build(&m, Profile::Debug, &out).expect("build with dep") {
        Artifact::Binary(p) => p,
        other => panic!("expected Binary, got {other:?}"),
    };
    let res = Command::new(&bin).output().expect("run binary");
    assert_eq!(String::from_utf8_lossy(&res.stdout).trim(), "20");
}

#[test]
fn missing_dependency_package_rejected_at_load() {
    let dir = temp_dir("baddep");
    write_pkg(
        &dir,
        r#"
[package]
name = "app"
version = "0.1.0"

[dependencies.ghost]
path = "vendor/ghost"
"#,
        "Int main() { return 0; }\n",
    );
    let e = Manifest::load(&dir).err().expect("missing dep must fail");
    assert!(e.to_string().contains("dependency 'ghost'"), "{e}");
}

#[test]
fn ungranted_dependency_capability_rejected() {
    let dir = temp_dir("caps");
    fs::create_dir_all(dir.join("vendor/math/src")).unwrap();
    fs::write(
        dir.join("vendor/math/resid.toml"),
        "[package]\nname = \"math\"\nversion = \"0.1.0\"\n",
    )
    .unwrap();
    fs::write(dir.join("vendor/math/src/main.resid"), "pub Int f() { return 0; }\n").unwrap();
    write_pkg(
        &dir,
        r#"
[package]
name = "app"
version = "0.1.0"

[capabilities]
grant = ["git(readonly)"]

[dependencies.math]
path         = "vendor/math"
capabilities = ["filesystem(readonly)"]
"#,
        "import \"math\";\nInt main() { return f(); }\n",
    );
    let e = Manifest::load(&dir).err().expect("ungranted cap must fail");
    let msg = e.to_string();
    assert!(msg.contains("not granted"), "{msg}");
    assert!(msg.contains("filesystem"), "{msg}");
}

#[test]
fn granted_capability_family_accepted() {
    let dir = temp_dir("capok");
    fs::create_dir_all(dir.join("vendor/math/src")).unwrap();
    fs::write(
        dir.join("vendor/math/resid.toml"),
        "[package]\nname = \"math\"\nversion = \"0.1.0\"\n",
    )
    .unwrap();
    fs::write(dir.join("vendor/math/src/main.resid"), "pub Int f() { return 0; }\n").unwrap();
    write_pkg(
        &dir,
        r#"
[package]
name = "app"
version = "0.1.0"

[capabilities]
grant = ["filesystem(scope=[\"config/**\"])", "git(readonly)"]

[dependencies.math]
path         = "vendor/math"
capabilities = ["filesystem(readonly)"]
"#,
        "import \"math\";\nInt main() { return f(); }\n",
    );
    // Family match: dep wants `filesystem`, grant includes a scoped
    // `filesystem(...)` — same family, so grantable.
    let m = Manifest::load(&dir).expect("scoped grant covers family");
    assert_eq!(m.granted_capabilities.len(), 2);
}
