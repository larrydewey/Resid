//! End-to-end: the resid-why binary reads a notes sidecar and renders
//! text, filtered, summary and LSP-JSON views.

use std::process::Command;

fn why_bin() -> &'static str {
    env!("CARGO_BIN_EXE_resid-why")
}

#[test]
fn why_reads_sidecar_and_renders_views() {
    let dir = std::env::temp_dir().join(format!("resid-why-e2e-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let artifact = dir.join("prog_bin");
    resid_notes::write_notes_file(
        &artifact,
        &[
            resid_notes::ResidualNote::at(
                "rt-binding",
                "rt print_str",
                12,
                0,
                "examples/main.resid",
            ),
            resid_notes::ResidualNote::at(
                "provider-call",
                "filesystem.read_file(cfg)",
                3400,
                6,
                "examples/main.resid",
            ),
            resid_notes::ResidualNote::at(
                "provider-call",
                "env.get(HOME)",
                41,
                2,
                "lib/env.resid",
            ),
        ],
    )
    .unwrap();

    let run = |extra: &[&str]| {
        let out = Command::new(why_bin())
            .arg(&artifact)
            .args(extra)
            .output()
            .expect("run resid-why");
        (
            out.status.code().unwrap(),
            String::from_utf8_lossy(&out.stdout).into_owned(),
            String::from_utf8_lossy(&out.stderr).into_owned(),
        )
    };

    // Full view.
    let (code, stdout, _) = run(&[]);
    assert_eq!(code, 0);
    assert!(stdout.contains("3/3 residual notes shown"));
    assert!(stdout.contains("rt print_str @ examples/main.resid:12:1"));
    assert!(stdout.contains("runtime binding"));

    // Symbol filter.
    let (code, stdout, _) = run(&["read_file"]);
    assert_eq!(code, 0);
    assert!(stdout.contains("filesystem.read_file(cfg) @ examples/main.resid:3400:7"));
    assert!(stdout.contains("1/3 residual notes shown"));

    // File filter.
    let (code, stdout, _) = run(&["--file", "examples/"]);
    assert_eq!(code, 0);
    assert_eq!(stdout.matches("@ examples/").count(), 2);
    let (code, stdout, _) = run(&["--file", "nope"]);
    assert_eq!(code, 0);
    assert!(stdout.contains("no residual notes match"));

    // Kind + no matches.
    let (code, stdout, _) = run(&["--kind", "provider-call"]);
    assert_eq!(code, 0);
    assert_eq!(stdout.matches("@ ").count(), 2);
    let (code, stdout, _) = run(&["--kind", "nope", "--"]);
    assert_eq!(code, 0);
    assert!(stdout.contains("no residual notes match"));

    // Summary view.
    let (code, stdout, _) = run(&["--summary"]);
    assert_eq!(code, 0);
    assert!(stdout.contains("provider-call: 2"));
    assert!(stdout.contains("rt-binding: 1"));

    // LSP JSON view (line numbers are 0-based, files become URIs).
    let (code, stdout, _) = run(&["--json"]);
    assert_eq!(code, 0);
    assert!(stdout.trim_start().starts_with('['));
    assert_eq!(stdout.matches("\"range\"").count(), 3);
    assert_eq!(stdout.matches("\"uri\"").count(), 3);
    assert!(stdout.contains("\"severity\":4"));
    assert!(stdout.contains("\"line\":11") && stdout.contains("\"line\":3399"));
    assert!(stdout.contains("\"uri\":\"file://examples/main.resid\""));
    assert!(stdout.contains("\"character\":6"));

    // --max clamps the view.
    let (code, stdout, _) = run(&["--max", "1"]);
    assert_eq!(code, 0);
    assert!(stdout.contains("1/3 residual notes shown"));

    // Missing sidecar is a hard error with a helpful message.
    let out = Command::new(why_bin())
        .arg(dir.join("nope_bin"))
        .output()
        .unwrap();
    assert_eq!(out.status.code(), Some(1));
    let err = String::from_utf8_lossy(&out.stderr);
    assert!(err.contains("no readable notes sidecar"), "{err}");

    // Usage error exits 2.
    let out = Command::new(why_bin()).output().unwrap();
    assert_eq!(out.status.code(), Some(2));

    let _ = std::fs::remove_dir_all(&dir);
}
