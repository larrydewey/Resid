//! resid-lsp: language server view of residual notes (spec §37).
//!
//! A minimal LSP (JSON-RPC over stdio) server that surfaces the
//! `.resid-notes.cbor` sidecars produced by `residc build` as editor
//! diagnostics and hover explanations:
//!
//! - Opening/saving a `.resid` document scans its directory (and, when
//!   present, a `target/` sibling) for `*.resid-notes.cbor` sidecars and
//!   publishes one Hint diagnostic per note whose line falls inside the
//!   document.
//! - Hovering a line carrying a residual shows what knowledge is
//!   missing and what would discharge it.
//!
//! Usage (VS Code / generic LSP client):
//!   resid-lsp            # serve on stdio

use std::collections::HashMap;
use std::io::{Read, Write};

use resid_notes::ResidualNote;

// ---------------------------------------------------------------------------
// Pure core (unit tested)
// ---------------------------------------------------------------------------

/// One diagnostic derived from a sidecar note (LSP wire shape).
pub struct Diagnostic {
    /// 0-based line.
    pub line: u64,
    pub code: String,
    pub message: String,
}

fn explain(kind: &str) -> &'static str {
    match kind {
        "rt-binding" => {
            "calls a runtime binding whose value is not known at compile time; \
             provide the value as compile-time knowledge or accept the runtime call"
        }
        "provider-call" => {
            "queries an external provider (filesystem/env/git/...); grant the \
             capability at build time with a concrete value to discharge it"
        }
        _ => "unknown residual kind",
    }
}

/// Convert notes into LSP diagnostics, dropping notes past the end of the
/// document (`line_count`, 1-based count as in an editor buffer).
pub fn notes_to_diagnostics(notes: &[ResidualNote], line_count: u64) -> Vec<Diagnostic> {
    let mut out = Vec::new();
    for n in notes {
        if n.line == 0 || n.line > line_count {
            continue;
        }
        // Notes are 1-based; LSP is 0-based.
        out.push(Diagnostic {
            line: n.line - 1,
            code: n.kind.clone(),
            message: format!("residual ({}): {}", n.symbol, explain(&n.kind)),
        });
    }
    out.sort_by_key(|d| d.line);
    out
}

/// Hover text shown when the cursor rests on a line that carries a note
/// (`hover_line` 0-based).
pub fn hover_for_line(notes: &[ResidualNote], hover_line: u64) -> Option<String> {
    let n = notes.iter().find(|n| n.line - 1 == hover_line && n.line >= 1)?;
    Some(format!(
        "**residual** `{}` @ line {}\n\n{}\n\n_kind: {}_",
        n.symbol,
        n.line,
        explain(&n.kind),
        n.kind
    ))
}

/// Discover sidecar files relevant to an open document: any
/// `*.resid-notes.cbor` in the document's directory.
pub fn sidecars_for(doc_path: &std::path::Path) -> Vec<std::path::PathBuf> {
    let mut out = Vec::new();
    if let Some(dir) = doc_path.parent() {
        let entries = match std::fs::read_dir(dir) {
            Ok(e) => e,
            Err(_) => return out,
        };
        for e in entries.flatten() {
            let name = e.file_name();
            let name = name.to_string_lossy();
            if name.ends_with(".resid-notes.cbor") {
                out.push(e.path());
            }
        }
    }
    out.sort();
    out
}

/// Serialize diagnostics + hover capability responses we send.
pub fn publish_diagnostics_message(uri: &str, diags: &[Diagnostic]) -> String {
    let items: Vec<serde_json::Value> = diags
        .iter()
        .map(|d| {
            serde_json::json!({
                "range": {
                    "start": {"line": d.line, "character": 0},
                    "end": {"line": d.line, "character": 0}
                },
                "severity": 4,
                "code": d.code,
                "source": "resid-lsp",
                "message": d.message,
            })
        })
        .collect();
    serde_json::json!({
        "jsonrpc": "2.0",
        "method": "textDocument/publishDiagnostics",
        "params": {"uri": uri, "diagnostics": items},
    })
    .to_string()
}

pub fn hover_result_message(id: &serde_json::Value, hover: &str) -> String {
    serde_json::json!({
        "jsonrpc": "2.0",
        "id": id,
        "result": {"contents": {"kind": "markdown", "value": hover}},
    })
    .to_string()
}

pub fn null_result_message(id: &serde_json::Value) -> String {
    serde_json::json!({"jsonrpc": "2.0", "id": id, "result": null}).to_string()
}

pub fn initialize_result_message(id: &serde_json::Value) -> String {
    serde_json::json!({
        "jsonrpc": "2.0",
        "id": id,
        "result": {
            "capabilities": {"textDocumentSync": 1, "hoverProvider": true},
            "serverInfo": {"name": "resid-lsp", "version": "0.1.0"},
        },
    })
    .to_string()
}

// ---------------------------------------------------------------------------
// Framing
// ---------------------------------------------------------------------------

/// Read one `Content-Length`-framed JSON-RPC message from `r`.
fn read_message(r: &mut impl Read) -> Option<String> {
    let mut buf = Vec::new();
    // Headers end at \r\n\r\n.
    loop {
        let mut b = [0u8; 1];
        match r.read(&mut b) {
            Ok(0) => return None,
            Ok(_) => buf.push(b[0]),
            Err(_) => return None,
        }
        if buf.ends_with(b"\r\n\r\n") {
            break;
        }
    }
    let headers = String::from_utf8_lossy(&buf);
    let len: usize = headers
        .lines()
        .find_map(|l| l.strip_prefix("Content-Length:"))
        .and_then(|v| v.trim().parse().ok())?;
    let mut body = vec![0u8; len];
    r.read_exact(&mut body).ok()?;
    Some(String::from_utf8_lossy(&body).into_owned())
}

/// Write one framed message.
fn write_message(w: &mut impl Write, msg: &str) -> std::io::Result<()> {
    write!(w, "Content-Length: {}\r\n\r\n{}", msg.len(), msg)?;
    w.flush()
}

// ---------------------------------------------------------------------------
// Server state
// ---------------------------------------------------------------------------

struct Server {
    /// Open documents: uri -> source text.
    docs: HashMap<String, String>,
    out: Box<dyn Write>,
}

impl Server {
    fn handle(&mut self, msg: &str) -> bool {
        let v: serde_json::Value = match serde_json::from_str(msg) {
            Ok(v) => v,
            Err(_) => return true,
        };
        let method = v.get("method").and_then(|m| m.as_str()).unwrap_or("");
        let id = v.get("id").cloned();
        match method {
            "initialize" => {
                let resp = initialize_result_message(id.as_ref().unwrap_or(&serde_json::Value::Null));
                let _ = write_message(&mut self.out, &resp);
            }
            "shutdown" => {
                let _ = write_message(&mut self.out, &null_result_message(id.as_ref().unwrap_or(&serde_json::Value::Null)));
            }
            "exit" => return false,
            "textDocument/didOpen" | "textDocument/didChange" | "textDocument/didSave" => {
                let td = v.pointer("/params/textDocument");
                let uri = td
                    .and_then(|t| t.get("uri"))
                    .and_then(|u| u.as_str())
                    .unwrap_or("")
                    .to_string();
                let text = if method == "textDocument/didChange" {
                    v.pointer("/params/contentChanges/0/text")
                        .and_then(|t| t.as_str())
                        .unwrap_or("")
                        .to_string()
                } else {
                    td.and_then(|t| t.get("text"))
                        .and_then(|t| t.as_str())
                        .unwrap_or("")
                        .to_string()
                };
                if !uri.is_empty() {
                    self.docs.insert(uri.clone(), text);
                    self.publish_for(&uri);
                }
            }
            "textDocument/hover" => {
                let uri = v
                    .pointer("/params/textDocument/uri")
                    .and_then(|u| u.as_str())
                    .unwrap_or("");
                let line = v
                    .pointer("/params/position/line")
                    .and_then(|l| l.as_u64())
                    .unwrap_or(u64::MAX);
                let path = uri_to_path(uri);
                let notes = load_notes_for(&path, &self.docs.get(uri).cloned().unwrap_or_default());
                let resp = match hover_for_line(&notes, line) {
                    Some(h) => hover_result_message(
                        id.as_ref().unwrap_or(&serde_json::Value::Null),
                        &h,
                    ),
                    None => null_result_message(id.as_ref().unwrap_or(&serde_json::Value::Null)),
                };
                let _ = write_message(&mut self.out, &resp);
            }
            _ => {}
        }
        true
    }

    fn publish_for(&mut self, uri: &str) {
        let text = self.docs.get(uri).cloned().unwrap_or_default();
        let line_count = text.lines().count() as u64;
        let notes = load_notes_for(&uri_to_path(uri), &text);
        let diags = notes_to_diagnostics(&notes, line_count.max(1));
        let _ = write_message(&mut self.out, &publish_diagnostics_message(uri, &diags));
    }

    fn serve(&mut self, input: &mut impl Read) {
        while let Some(msg) = read_message(input) {
            if !self.handle(&msg) {
                break;
            }
        }
    }
}

fn uri_to_path(uri: &str) -> std::path::PathBuf {
    std::path::PathBuf::from(uri.strip_prefix("file://").unwrap_or(uri))
}

fn load_notes_for(doc_path: &std::path::Path, _text: &str) -> Vec<ResidualNote> {
    let mut notes = Vec::new();
    for sc in sidecars_for(doc_path) {
        if let Ok(bytes) = std::fs::read(&sc)
            && let Some(mut ns) = resid_notes::from_cbor(&bytes) {
                notes.append(&mut ns);
            }
    }
    notes
}

fn main() {
    let mut server = Server { docs: HashMap::new(), out: Box::new(std::io::stdout()) };
    server.serve(&mut std::io::stdin());
}

#[cfg(test)]
mod tests {
    use super::*;

    fn note(kind: &str, symbol: &str, line: u64) -> ResidualNote {
        ResidualNote { kind: kind.into(), symbol: symbol.into(), line }
    }

    #[test]
    fn diagnostics_are_zero_based_sorted_and_clamped() {
        let notes = vec![
            note("provider-call", "env.get(HOME)", 41),
            note("rt-binding", "rt print", 1),
            note("rt-binding", "past-eof", 99),
            note("zero-line-dropped", "x", 0),
        ];
        let d = notes_to_diagnostics(&notes, 60);
        assert_eq!(d.len(), 2);
        assert_eq!(d[0].line, 0);
        assert_eq!(d[1].line, 40);
        assert!(d[1].message.contains("external provider"));
        assert!(d[0].message.contains("runtime binding"));
    }

    #[test]
    fn hover_matches_only_that_line() {
        let notes = vec![note("rt-binding", "rt x", 5)];
        assert!(hover_for_line(&notes, 4).is_some());
        assert!(hover_for_line(&notes, 3).is_none());
        assert!(hover_for_line(&notes, 5).is_none());
        let h = hover_for_line(&notes, 4).unwrap();
        assert!(h.contains("`rt x`"));
        assert!(h.contains("rt-binding"));
    }

    #[test]
    fn sidecar_discovery_scans_doc_directory() {
        let dir = std::env::temp_dir().join(format!("resid-lsp-scan-{}", std::process::id()));
        std::fs::create_dir_all(&dir).unwrap();
        let doc = dir.join("prog.resid");
        std::fs::write(&doc, "Int main() { return 0; }\n").unwrap();
        std::fs::write(dir.join("prog_bin.resid-notes.cbor"), b"\x80").unwrap();
        std::fs::write(dir.join("other_bin.resid-notes.cbor"), b"\x80").unwrap();
        std::fs::write(dir.join("unrelated.cbor"), b"\x80").unwrap();
        let sc = sidecars_for(&doc);
        assert_eq!(sc.len(), 2);
        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn messages_are_valid_json_with_expected_fields() {
        let d = notes_to_diagnostics(&[note("rt-binding", "rt \"q\"", 2)], 10);
        let m = publish_diagnostics_message("file:///p.resid", &d);
        let v: serde_json::Value = serde_json::from_str(&m).unwrap();
        assert_eq!(
            v.pointer("/params/diagnostics/0/range/start/line"),
            Some(&serde_json::json!(1))
        );
        assert_eq!(v.pointer("/params/diagnostics/0/severity"), Some(&serde_json::json!(4)));
        let h = hover_result_message(&serde_json::json!(7), "**x**");
        let hv: serde_json::Value = serde_json::from_str(&h).unwrap();
        assert_eq!(hv.pointer("/id"), Some(&serde_json::json!(7)));
        assert_eq!(
            hv.pointer("/result/contents/kind"),
            Some(&serde_json::json!("markdown"))
        );
        let i = initialize_result_message(&serde_json::json!(1));
        let iv: serde_json::Value = serde_json::from_str(&i).unwrap();
        assert_eq!(
            iv.pointer("/result/capabilities/hoverProvider"),
            Some(&serde_json::json!(true))
        );
    }
}
