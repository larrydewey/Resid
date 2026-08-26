//! End-to-end: drive the resid-lsp binary over stdio LSP framing and
//! check diagnostics + hover responses against a real notes sidecar.

use std::io::{Read, Write};
use std::process::{Command, Stdio};

fn lsp_bin() -> &'static str {
    env!("CARGO_BIN_EXE_resid-lsp")
}

fn framed(body: &str) -> Vec<u8> {
    format!("Content-Length: {}\r\n\r\n{}", body.len(), body).into_bytes()
}

#[test]
fn lsp_serves_diagnostics_and_hover_from_sidecar() {
    let dir = std::env::temp_dir().join(format!("resid-lsp-e2e-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let doc = dir.join("prog.resid");
    std::fs::write(&doc, "line one\nline two\n").unwrap();
    // Sidecar next to the doc, as `residc build` would leave it.
    resid_notes::write_notes_file(
        &dir.join("prog_bin"),
        &[
            resid_notes::ResidualNote {
                kind: "rt-binding".into(),
                symbol: "rt print_str".into(),
                line: 1,
            },
            resid_notes::ResidualNote {
                kind: "provider-call".into(),
                symbol: "env.get(HOME)".into(),
                line: 2,
            },
            resid_notes::ResidualNote {
                kind: "rt-binding".into(),
                symbol: "past-eof".into(),
                line: 99,
            },
        ],
    )
    .unwrap();

    let uri = format!("file://{}", doc.display());
    let mut child = Command::new(lsp_bin())
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()
        .expect("spawn resid-lsp");
    let mut stdin = child.stdin.take().unwrap();
    let mut stdout = child.stdout.take().unwrap();

    stdin.write_all(&framed(
        r#"{"jsonrpc":"2.0","id":1,"method":"initialize","params":{}}"#,
    )).unwrap();
    stdin.write_all(&framed(&format!(
        r#"{{"jsonrpc":"2.0","method":"textDocument/didOpen","params":{{"textDocument":{{"uri":"{uri}","languageId":"resid","version":1,"text":"line one\nline two\n"}}}}}}"#
    ))).unwrap();
    stdin.write_all(&framed(&format!(
        r#"{{"jsonrpc":"2.0","id":2,"method":"textDocument/hover","params":{{"textDocument":{{"uri":"{uri}"}},"position":{{"line":1,"character":3}}}}}}"#
    ))).unwrap();
    stdin.write_all(&framed(r#"{"jsonrpc":"2.0","id":3,"method":"shutdown"}"#)).unwrap();
    stdin.write_all(&framed(r#"{"jsonrpc":"2.0","method":"exit"}"#)).unwrap();
    drop(stdin);

    let mut out = String::new();
    stdout.read_to_string(&mut out).unwrap();
    child.wait().unwrap();

    let msgs: Vec<&str> = out
        .split("Content-Length:")
        .skip(1)
        .filter_map(|chunk| chunk.split_once("\r\n\r\n").map(|(_, b)| b))
        .collect();
    let parsed: Vec<serde_json::Value> = msgs
        .iter()
        .map(|m| serde_json::from_str(m).expect("valid JSON"))
        .collect();

    // initialize response.
    assert_eq!(parsed[0].pointer("/result/capabilities/hoverProvider"), Some(&serde_json::json!(true)));

    // Diagnostics: two in-range notes, zero-based, past-EOF dropped.
    let diags = &parsed[1]["params"]["diagnostics"];
    assert_eq!(diags.as_array().unwrap().len(), 2);
    assert_eq!(diags[0]["range"]["start"]["line"], serde_json::json!(0));
    assert_eq!(diags[0]["code"], serde_json::json!("rt-binding"));
    assert_eq!(diags[1]["range"]["start"]["line"], serde_json::json!(1));
    assert_eq!(diags[1]["code"], serde_json::json!("provider-call"));
    assert!(diags[1]["message"].as_str().unwrap().contains("env.get(HOME)"));

    // Hover on line 1 (0-based) explains the provider-call residual.
    let hover = &parsed[2]["result"]["contents"];
    assert_eq!(hover["kind"], serde_json::json!("markdown"));
    assert!(hover["value"].as_str().unwrap().contains("`env.get(HOME)`"));

    // shutdown answered.
    assert_eq!(parsed[3]["id"], serde_json::json!(3));

    let _ = std::fs::remove_dir_all(&dir);
}
