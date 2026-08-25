//! Integration test: drive the resid-why binary against a synthetic
//! notes sidecar and check the explanations and filters.

use std::process::Command;

fn bin() -> &'static str {
    env!("CARGO_BIN_EXE_resid-why")
}

#[test]
fn explains_notes_and_filters() {
    let dir = std::env::temp_dir().join(format!("resid-why-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let artifact = dir.join("prog");
    let notes = vec![
        resid_notes::ResidualNote {
            kind: "rt-binding".into(),
            symbol: "rt print_str".into(),
            line: 12,
        },
        resid_notes::ResidualNote {
            kind: "provider-call".into(),
            symbol: "filesystem.read(x)".into(),
            line: 3400,
        },
    ];
    resid_notes::write_notes_file(&artifact, &notes).unwrap();

    // Full listing.
    let out = Command::new(bin()).arg(&artifact).output().unwrap();
    assert!(out.status.success());
    let text = String::from_utf8_lossy(&out.stdout).into_owned();
    assert!(text.contains("rt print_str"), "{text}");
    assert!(text.contains("line 3400"), "{text}");
    assert!(text.contains("provider"), "{text}");
    assert!(text.contains("2/2 residual notes shown"), "{text}");

    // Symbol filter.
    let out = Command::new(bin()).arg(&artifact).arg("filesystem").output().unwrap();
    let text = String::from_utf8_lossy(&out.stdout).into_owned();
    assert!(text.contains("filesystem.read"), "{text}");
    assert!(!text.contains("print_str"), "{text}");
    assert!(text.contains("1/2 residual notes shown"), "{text}");

    // Kind filter.
    let out = Command::new(bin()).arg(&artifact).args(["--kind", "rt-binding"]).output().unwrap();
    let text = String::from_utf8_lossy(&out.stdout).into_owned();
    assert!(text.contains("runtime binding"), "{text}");
    assert!(text.contains("1/2"), "{text}");

    // Missing sidecar is an error.
    let out = Command::new(bin()).arg(dir.join("absent")).output().unwrap();
    assert_eq!(out.status.code(), Some(1));

    std::fs::remove_dir_all(&dir).unwrap();
}

#[test]
fn fully_reduced_report() {
    let dir = std::env::temp_dir().join(format!("resid-why-empty-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let artifact = dir.join("clean");
    resid_notes::write_notes_file(&artifact, &[]).unwrap();
    let out = Command::new(bin()).arg(&artifact).output().unwrap();
    let text = String::from_utf8_lossy(&out.stdout).into_owned();
    assert!(text.contains("fully reduced"), "{text}");
    std::fs::remove_dir_all(&dir).unwrap();
}
