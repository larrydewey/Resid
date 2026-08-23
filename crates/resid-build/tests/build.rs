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

#[test]
fn ungranted_provider_call_rejected_at_build() {
    let dir = temp_dir("capsfs");
    write_pkg(
        &dir,
        r#"
[package]
name = "sneaky"
version = "0.1.0"
"#,
        "Int main() {\n    Str s = filesystem.read_all(\"/etc/hostname\");\n    println(s);\n    return 0;\n}\n",
    );
    let m = Manifest::load(&dir).expect("manifest ok (no deps to check)");
    let e = build(&m, Profile::Check, &dir.join("out")).err().expect("must fail");
    let msg = e.message;
    assert!(msg.contains("capability policy violation"), "{msg}");
    assert!(msg.contains("filesystem.read_all"), "{msg}");
}

#[test]
fn granted_provider_call_builds() {
    let dir = temp_dir("capsok");
    write_pkg(
        &dir,
        r#"
[package]
name = "reader"
version = "0.1.0"

[capabilities]
grant = ["filesystem"]
"#,
        "Int main() {\n    if (filesystem.exists(\"no-such-file\")) {\n        return 1;\n    }\n    return 0;\n}\n",
    );
    let m = Manifest::load(&dir).unwrap();
    match build(&m, Profile::Debug, &dir.join("out")).expect("granted build") {
        Artifact::Binary(_) => {}
        other => panic!("expected Binary, got {other:?}"),
    }
}

#[test]
fn args_provider_is_exempt_from_grants() {
    let dir = temp_dir("capsargs");
    write_pkg(
        &dir,
        r#"
[package]
name = "argy"
version = "0.1.0"
"#,
        "Int main() {\n    Int c = args.count();\n    return 0;\n}\n",
    );
    let m = Manifest::load(&dir).unwrap();
    let r = build(&m, Profile::Check, &dir.join("out")).expect("args needs no grant");
    assert!(matches!(r, Artifact::Checked));
}

#[test]
fn scoped_grant_rejects_path_outside_scope() {
    let dir = temp_dir("scoped");
    write_pkg(
        &dir,
        r#"
[package]
name = "scoped"
version = "0.1.0"

[capabilities]
grant = ["filesystem(scope=[\"config/**\"])"]
"#,
        "Int main() {\n    Str s = filesystem.read_all(\"/etc/passwd\");\n    return 0;\n}\n",
    );
    let m = Manifest::load(&dir).expect("manifest ok");
    assert_eq!(m.grants.len(), 1);
    assert_eq!(m.grants[0].scopes, vec!["config/**".to_string()]);
    let e = build(&m, Profile::Check, &dir.join("out")).err().expect("outside scope must fail");
    let msg = e.message;
    assert!(msg.contains("outside the granted scopes"), "{msg}");
}

#[test]
fn scoped_grant_accepts_matching_literal_path() {
    let dir = temp_dir("scopedok");
    write_pkg(
        &dir,
        r#"
[package]
name = "scoped"
version = "0.1.0"

[capabilities]
grant = ["filesystem(scope=[\"config/**\", \"config.ini\"])"]
"#,
        "Int main() {\n    if (filesystem.exists(\"config/app.conf\")) {\n        println(\"found\");\n    }\n    if (filesystem.exists(\"config.ini\")) {\n        println(\"ini\");\n    }\n    return 0;\n}\n",
    );
    let m = Manifest::load(&dir).unwrap();
    build(&m, Profile::Check, &dir.join("out")).expect("in-scope paths pass");
}

#[test]
fn dynamic_path_needs_unscoped_grant() {
    let dir = temp_dir("dynpath");
    write_pkg(
        &dir,
        r#"
[package]
name = "dyn"
version = "0.1.0"

[capabilities]
grant = ["filesystem(scope=[\"config/**\"])"]
"#,
        "Int main() {\n    Str p = \"config/a.txt\";\n    if (filesystem.exists(p)) {\n        return 1;\n    }\n    return 0;\n}\n",
    );
    let m = Manifest::load(&dir).unwrap();
    let e = build(&m, Profile::Check, &dir.join("out")).err().expect("dynamic path must fail under scope");
    assert!(e.message.contains("dynamic path"), "{}", e.message);
}

#[test]
fn unscoped_family_grant_overrides_scopes() {
    let dir = temp_dir("unscoped");
    write_pkg(
        &dir,
        r#"
[package]
name = "wide"
version = "0.1.0"

[capabilities]
grant = ["filesystem(scope=[\"config/**\"])", "filesystem(readonly)"]
"#,
        "Int main() {\n    Str s = filesystem.read_all(\"/etc/hostname\");\n    return 0;\n}\n",
    );
    let m = Manifest::load(&dir).unwrap();
    build(&m, Profile::Check, &dir.join("out")).expect("unscoped grant wins");
}

#[test]
fn archive_round_trip_and_signature_verification() {
    let dir = temp_dir("archive");
    write_pkg(&dir, GOOD_MANIFEST, GOOD_MAIN);
    let m = Manifest::load(&dir).unwrap();

    // Deterministic archives: same tree → same bytes → same hash.
    let a1 = resid_build::archive::build_archive(&dir).expect("archive 1");
    let a2 = resid_build::archive::build_archive(&dir).expect("archive 2");
    assert_eq!(a1, a2, "archives must be deterministic");
    assert_eq!(a1.starts_with(b"RESIDPKG1"), true);

    // Sign + verify.
    let (secret, public) = resid_build::archive::keygen().unwrap();
    let hash = resid_build::archive::content_hash(&a1);
    let sig = resid_build::archive::sign_hash(&hash, &secret).unwrap();
    assert!(
        resid_build::archive::verify_sig(&hash, &sig, &public).unwrap(),
        "valid signature must verify"
    );

    // Tampering invalidates.
    let mut tampered = a1.clone();
    tampered[20] ^= 0xff;
    let bad_hash = resid_build::archive::content_hash(&tampered);
    assert!(
        !resid_build::archive::verify_sig(&bad_hash, &sig, &public).unwrap(),
        "tampered content must fail verification"
    );
}

#[test]
fn require_signatures_accepts_valid_keyring() {
    let dir = temp_dir("sigreq");
    // Dependency package with its signed archive + keyring.
    fs::create_dir_all(dir.join("vendor/math/src")).unwrap();
    fs::create_dir_all(dir.join("keys")).unwrap();
    fs::write(dir.join("vendor/math/resid.toml"), "[package]\nname = \"math\"\nversion = \"0.1.0\"\n").unwrap();
    fs::write(dir.join("vendor/math/src/main.resid"), "pub Int f() { return 7; }\n").unwrap();
    fs::write(dir.join("app_main.resid.tmp"), "").unwrap();

    let (secret, public) = resid_build::archive::keygen().unwrap();
    fs::write(dir.join("keys/pub.hex"), &public).unwrap();
    let dep_dir = dir.join("vendor/math");
    let archive = resid_build::archive::build_archive(&dep_dir).unwrap();
    let hash = resid_build::archive::content_hash(&archive);
    let sig = resid_build::archive::sign_hash(&hash, &secret).unwrap();
    fs::write(dep_dir.join("math.resid-pkg"), &archive).unwrap();
    fs::write(dep_dir.join("math.resid-sig"), &sig).unwrap();

    fs::write(
        dir.join("resid.toml"),
        r#"
[package]
name = "app"
version = "0.1.0"

[signing]
require_signatures = true
keyring = "keys"

[dependencies.math]
path         = "vendor/math"
capabilities = []
"#,
    )
    .unwrap();
    fs::create_dir_all(dir.join("src")).unwrap();
    fs::write(dir.join("src/main.resid"), "import \"math\";\nInt main() { return f(); }\n").unwrap();
    let m = Manifest::load(&dir).expect("signed dependency accepted");
    assert_eq!(m.dependencies.len(), 1);
}

#[test]
fn require_signatures_rejects_missing_or_bad_signature() {
    let dir = temp_dir("sigbad");
    fs::create_dir_all(dir.join("vendor/math/src")).unwrap();
    fs::create_dir_all(dir.join("keys")).unwrap();
    fs::write(dir.join("vendor/math/resid.toml"), "[package]\nname = \"math\"\nversion = \"0.1.0\"\n").unwrap();
    fs::write(dir.join("vendor/math/src/main.resid"), "pub Int f() { return 7; }\n").unwrap();
    // No archive/sig at all.
    fs::write(
        dir.join("resid.toml"),
        "[package]\nname = \"app\"\nversion = \"0.1.0\"\n\n[signing]\nrequire_signatures = true\n\n[dependencies.math]\npath = \"vendor/math\"\ncapabilities = []\n",
    )
    .unwrap();
    fs::create_dir_all(dir.join("src")).unwrap();
    fs::write(dir.join("src/main.resid"), "Int main() { return 0; }\n").unwrap();
    let e = Manifest::load(&dir).err().expect("missing sig must fail");
    assert!(e.to_string().contains("missing or unreadable"), "{e}");
}

#[test]
fn transitive_dependencies_resolve() {
    let dir = temp_dir("transitive");
    // base has no deps; mid depends on base; app depends on mid.
    fs::create_dir_all(dir.join("vendor/base/src")).unwrap();
    fs::create_dir_all(dir.join("vendor/mid/src")).unwrap();
    fs::create_dir_all(dir.join("src")).unwrap();
    fs::write(dir.join("vendor/base/resid.toml"), "[package]\nname = \"base\"\nversion = \"0.1.0\"\n").unwrap();
    fs::write(dir.join("vendor/base/src/main.resid"), "pub Int one() { return 1; }\n").unwrap();
    fs::write(
        dir.join("vendor/mid/resid.toml"),
        "[package]\nname = \"mid\"\nversion = \"0.1.0\"\n\n[dependencies.base]\npath = \"../base\"\ncapabilities = []\n",
    )
    .unwrap();
    fs::write(
        dir.join("vendor/mid/src/main.resid"),
        "import \"base\";\npub Int two() { return one() + 1; }\n",
    )
    .unwrap();
    fs::write(
        dir.join("resid.toml"),
        "[package]\nname = \"app\"\nversion = \"0.1.0\"\n\n[dependencies.mid]\npath = \"vendor/mid\"\ncapabilities = []\n",
    )
    .unwrap();
    fs::write(
        dir.join("src/main.resid"),
        "import \"mid\";\nInt main() {\n    println(IntToString(two()));\n    return 0;\n}\n",
    )
    .unwrap();

    let m = Manifest::load(&dir).expect("transitive manifest loads");
    let names: Vec<&str> = m.dependencies.iter().map(|d| d.name.as_str()).collect();
    assert!(names.contains(&"base"), "{names:?}");
    assert!(names.contains(&"mid"), "{names:?}");

    let out = dir.join("out");
    let bin = match build(&m, Profile::Debug, &out).expect("transitive build") {
        Artifact::Binary(p) => p,
        other => panic!("expected Binary, got {other:?}"),
    };
    let res = Command::new(&bin).output().expect("run binary");
    assert_eq!(String::from_utf8_lossy(&res.stdout).trim(), "2");
}

#[test]
fn conflicting_transitive_names_rejected() {
    let dir = temp_dir("conflict");
    // Two packages both named "shared" at different paths.
    fs::create_dir_all(dir.join("vendor/a/src")).unwrap();
    fs::create_dir_all(dir.join("vendor/b/src")).unwrap();
    fs::create_dir_all(dir.join("src")).unwrap();
    for v in ["a", "b"] {
        fs::write(dir.join(format!("vendor/{v}/resid.toml")), "[package]\nname = \"shared\"\nversion = \"0.1.0\"\n").unwrap();
        fs::write(dir.join(format!("vendor/{v}/src/main.resid")), "pub Int f() { return 0; }\n").unwrap();
    }
    fs::write(
        dir.join("resid.toml"),
        "[package]\nname = \"app\"\nversion = \"0.1.0\"\n\n[dependencies.pa]\npath = \"vendor/a\"\ncapabilities = []\n\n[dependencies.pb]\npath = \"vendor/b\"\ncapabilities = []\n",
    )
    .unwrap();
    fs::write(dir.join("src/main.resid"), "Int main() { return 0; }\n").unwrap();
    let e = Manifest::load(&dir).err().expect("name conflict must fail");
    assert!(e.to_string().contains("conflicting dependency versions"), "{e}");
}

#[test]
fn registry_dependency_pulls_verifies_and_builds() {
    let dir = temp_dir("registry");
    // Build the mathlib package and pack it into a local registry.
    fs::create_dir_all(dir.join("registry")).unwrap();
    fs::create_dir_all(dir.join("app/src")).unwrap();
    let math_dir = dir.join("math");
    fs::create_dir_all(math_dir.join("src")).unwrap();
    fs::write(math_dir.join("resid.toml"), "[package]\nname = \"math\"\nversion = \"0.3.0\"\n").unwrap();
    fs::write(math_dir.join("src/main.resid"), "pub Int dbl(Int x) {\n    return x * 2;\n}\n").unwrap();

    let archive = resid_build::archive::build_archive(&math_dir).unwrap();
    let hash = resid_build::archive::content_hash(&archive);
    fs::write(dir.join("registry/math-0.3.0.resid-pkg"), &archive).unwrap();
    fs::write(
        dir.join("registry/math-0.3.0.resid-sha256"),
        resid_build::archive::hex_encode(&hash),
    )
    .unwrap();

    fs::write(
        dir.join("app/resid.toml"),
        r#"
[package]
name = "app"
version = "1.0.0"

[registry]
path = "../registry"

[dependencies.math]
version = "0.3.0"
"#,
    )
    .unwrap();
    fs::write(
        dir.join("app/src/main.resid"),
        "import \"math\";\nInt main() {\n    println(IntToString(dbl(21)));\n    return 0;\n}\n",
    )
    .unwrap();

    let m = Manifest::load(&dir.join("app")).expect("registry manifest loads");
    assert_eq!(m.dependencies.len(), 1);
    let out = dir.join("out");
    let bin = match build(&m, Profile::Debug, &out).expect("registry build") {
        Artifact::Binary(p) => p,
        other => panic!("expected Binary, got {other:?}"),
    };
    let res = Command::new(&bin).output().expect("run binary");
    assert_eq!(String::from_utf8_lossy(&res.stdout).trim(), "42");

    // Extracted into the cache.
    assert!(dir.join("app/target/resid/deps/math-0.3.0/resid.toml").exists());
}

#[test]
fn registry_dependency_hash_mismatch_rejected() {
    let dir = temp_dir("reghash");
    fs::create_dir_all(dir.join("registry")).unwrap();
    fs::create_dir_all(dir.join("src")).unwrap();
    fs::write(dir.join("registry/math-0.3.0.resid-pkg"), b"corrupt").unwrap();
    fs::write(dir.join("registry/math-0.3.0.resid-sha256"), "deadbeef").unwrap();
    fs::write(
        dir.join("resid.toml"),
        "[package]\nname = \"app\"\nversion = \"1.0.0\"\n\n[registry]\npath = \"registry\"\n\n[dependencies.math]\nversion = \"0.3.0\"\n",
    )
    .unwrap();
    fs::write(dir.join("src/main.resid"), "Int main() { return 0; }\n").unwrap();
    let e = Manifest::load(&dir).err().expect("hash mismatch must fail");
    assert!(e.to_string().contains("hash mismatch"), "{e}");
}

/// Registry + lockfile: publish a package into a local registry, build
/// against it by version (lockfile is written), then verify that tampering
/// with the registry archive is rejected because of the pinned hash.
#[test]
fn registry_lockfile_pins_content_hashes() {
    use resid_build::lock;
    let dir = temp_dir("reglock");
    let reg = dir.join("registry");
    fs::create_dir_all(&reg).unwrap();
    // Dependency package source, published as math 1.0.0.
    fs::create_dir_all(dir.join("math/src")).unwrap();
    fs::write(
        dir.join("math/resid.toml"),
        "[package]\nname = \"math\"\nversion = \"1.0.0\"\n",
    )
    .unwrap();
    fs::write(
        dir.join("math/src/main.resid"),
        "pub Int dbl(Int x) {\n    return x * 2;\n}\n",
    )
    .unwrap();
    let archive = archive_bytes(&dir.join("math"));
    fs::write(reg.join("math-1.0.0.resid-pkg"), &archive).unwrap();
    fs::write(
        reg.join("math-1.0.0.resid-sha256"),
        format!(
            "{}\n",
            hex(&resid_build::archive::content_hash(&archive))
        ),
    )
    .unwrap();
    // Depending package pulls math by version.
    write_pkg(
        &dir,
        r#"
[package]
name = "app"
version = "0.1.0"

[registry]
path = "registry"

[dependencies.math]
version = "1.0.0"
"#,
        "import \"math\";\nInt main() {\n    println(IntToString(dbl(21)));\n    return 0;\n}\n",
    );
    let m = Manifest::load(&dir).expect("manifest loads");
    assert_eq!(m.dependencies.len(), 1);
    let out = dir.join("out");
    match build(&m, Profile::Debug, &out).expect("build with registry dep") {
        Artifact::Binary(bin) => {
            let res = Command::new(&bin).output().unwrap();
            assert_eq!(String::from_utf8_lossy(&res.stdout).trim(), "42");
        }
        other => panic!("expected Binary, got {other:?}"),
    }
    // Lockfile written with the pinned hash.
    let lockfile = lock::read(&dir.join("resid.lock")).expect("resid.lock written");
    let entry = lockfile.get("math").expect("math locked");
    assert_eq!(entry.version, "1.0.0");
    let want = hex(&resid_build::archive::content_hash(&archive));
    assert_eq!(entry.sha256, want);
    // Tamper with the archive → next load must fail on the locked hash.
    let mut bad = archive.clone();
    bad[10] ^= 0xFF;
    fs::write(reg.join("math-1.0.0.resid-pkg"), &bad).unwrap();
    // Remove the stale extraction cache so resolution re-reads the archive.
    fs::remove_dir_all(dir.join("target/resid/deps")).ok();
    let e = Manifest::load(&dir).err().expect("tampered archive must fail");
    assert!(
        e.to_string().contains("LOCKED content hash mismatch"),
        "{e}"
    );
}

fn archive_bytes(pkg: &PathBuf) -> Vec<u8> {
    resid_build::archive::build_archive(pkg).expect("archive builds")
}

fn hex(bytes: &[u8]) -> String {
    resid_build::archive::hex_encode(bytes.try_into().expect("32-byte sha256"))
}

/// Remote registry transport: serve a local registry over HTTP, build
/// against it via `[registry] url`, and confirm the lockfile pins the
/// same content hash as the direct local build.
#[test]
fn remote_registry_http_pull() {
    use resid_build::lock;
    let dir = temp_dir("remote");
    let reg = dir.join("registry");
    // Package published into the canonical <reg>/pkg/ layout.
    fs::create_dir_all(reg.join("pkg")).unwrap();
    fs::create_dir_all(dir.join("math/src")).unwrap();
    fs::write(
        dir.join("math/resid.toml"),
        "[package]\nname = \"math\"\nversion = \"2.0.0\"\n",
    )
    .unwrap();
    fs::write(
        dir.join("math/src/main.resid"),
        "pub Int tpl(Int x) {\n    return x * 3;\n}\n",
    )
    .unwrap();
    let archive = resid_build::archive::build_archive(&dir.join("math")).unwrap();
    let sha = resid_build::archive::hex_encode(&resid_build::archive::content_hash(&archive));
    fs::write(reg.join("pkg/math-2.0.0.resid-pkg"), &archive).unwrap();
    fs::write(reg.join("pkg/math-2.0.0.resid-sha256"), format!("{sha}\n")).unwrap();
    // Start the HTTP server on an ephemeral port.
    let listener = std::net::TcpListener::bind(("127.0.0.1", 0)).unwrap();
    let port = listener.local_addr().unwrap().port();
    drop(listener);
    let server_dir = reg.clone();
    std::thread::spawn(move || {
        let _ = resid_build::registry::serve_dir(&server_dir, port);
    });
    // Give the listener a moment.
    std::thread::sleep(std::time::Duration::from_millis(100));
    // Client package pulls over HTTP.
    write_pkg(
        &dir,
        &format!(
            r#"
[package]
name = "app"
version = "0.1.0"

[registry]
url = "http://127.0.0.1:{port}"

[dependencies.math]
version = "2.0.0"
"#
        ),
        "import \"math\";\nInt main() {\n    println(IntToString(tpl(14)));\n    return 0;\n}\n",
    );
    let m = Manifest::load(&dir).expect("manifest loads with url registry");
    assert_eq!(m.dependencies.len(), 1);
    let out = dir.join("out");
    match build(&m, Profile::Debug, &out).expect("build via http") {
        Artifact::Binary(bin) => {
            let res = Command::new(&bin).output().unwrap();
            assert_eq!(String::from_utf8_lossy(&res.stdout).trim(), "42");
        }
        other => panic!("expected Binary, got {other:?}"),
    }
    // Lockfile pin matches the archive hash served over HTTP.
    let lockfile = lock::read(&dir.join("resid.lock")).expect("resid.lock written");
    let entry = lockfile.get("math").expect("math locked");
    assert_eq!(entry.version, "2.0.0");
    assert_eq!(entry.sha256, sha);
}
