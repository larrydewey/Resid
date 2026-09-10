//! resid why (spec §37): residual provenance query.
//!
//! Reads `<artifact>.resid-notes.cbor` and explains why each residual
//! remains: what kind of knowledge is missing, where it appears, and
//! what would discharge it.
//!
//! Usage:
//!   resid-why <artifact>              — explain every residual note
//!   resid-why <artifact> <symbol>     — only notes whose symbol contains <symbol>
//!   resid-why <artifact> --kind K     — only notes of one kind
//!   resid-why <artifact> --file F     — only notes whose source file contains F
//!   resid-why <artifact> --max N      — show at most N notes (after sorting)
//!   resid-why <artifact> --json       — LSP Diagnostic[] view (for editors)
//!   resid-why <artifact> --summary    — per-kind counts only

use std::path::PathBuf;

use resid_notes::{ResidualNote, read_notes_file};

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

/// Human location string: `path:line:col` when the sidecar carries file
/// provenance, `line N` otherwise.
fn location(n: &ResidualNote) -> String {
    if n.file.is_empty() {
        format!("line {}", n.line)
    } else {
        format!("{}:{}:{}", n.file, n.line, n.column + 1)
    }
}

/// One-line human explanation for a note.
fn render_text(n: &ResidualNote) -> String {
    format!(
        "{} @ {}:\n    {}\n    -> {}",
        n.symbol,
        location(n),
        n.kind,
        explain(&n.kind)
    )
}

fn json_escape(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for c in s.chars() {
        match c {
            '"' => out.push_str("\\\""),
            '\\' => out.push_str("\\\\"),
            '\n' => out.push_str("\\n"),
            '\r' => out.push_str("\\r"),
            '\t' => out.push_str("\\t"),
            c if (c as u32) < 0x20 => out.push_str(&format!("\\u{:04x}", c as u32)),
            c => out.push(c),
        }
    }
    out
}

/// Render notes as an LSP `Diagnostic[]` array (0-based lines), so an
/// editor language server can surface residuals straight from the
/// sidecar. Severity 4 = Hint: residual work, not an error. When the
/// note carries file provenance the diagnostic gets a `uri` and a
/// column-precise range.
fn render_lsp_json(notes: &[ResidualNote]) -> String {
    let items: Vec<String> = notes
        .iter()
        .map(|n| {
            let line = n.line.saturating_sub(1);
            let col = if n.file.is_empty() { 0 } else { n.column };
            let mut s = format!(
                concat!(
                    "{{\"range\":{{\"start\":{{\"line\":{},\"character\":{}}},",
                    "\"end\":{{\"line\":{},\"character\":{}}}}},\"severity\":4,",
                    "\"code\":\"{}\",\"source\":\"resid-why\",\"message\":\"{}\"}}"
                ),
                line,
                col,
                line,
                col,
                json_escape(&n.kind),
                json_escape(&format!(
                    "{} @ {}: {}",
                    n.symbol,
                    location(n),
                    explain(&n.kind)
                )),
            );
            if !n.file.is_empty() {
                s = format!("{{\"uri\":\"file://{}\",{}", json_escape(&n.file), &s[1..]);
            }
            s
        })
        .collect();
    format!("[\n  {}\n]\n", items.join(",\n  "))
}

/// Per-kind counts, sorted by kind name.
fn render_summary(notes: &[ResidualNote]) -> String {
    let mut counts: Vec<(&str, usize)> = Vec::new();
    for n in notes {
        match counts.iter_mut().find(|(k, _)| *k == n.kind) {
            Some((_, c)) => *c += 1,
            None => counts.push((&n.kind, 1)),
        }
    }
    counts.sort();
    let mut out = String::from("residual summary:\n");
    for (k, c) in &counts {
        out.push_str(&format!("  {k}: {c}\n"));
    }
    if counts.is_empty() {
        out.push_str("  fully reduced: no residual notes\n");
    }
    out
}

/// Query filters. `None` means "no constraint".
#[derive(Default)]
struct Query {
    symbol: Option<String>,
    kind: Option<String>,
    file: Option<String>,
    max: Option<usize>,
}

/// Apply filters, sort by source location (file, line, column) for a
/// deterministic editor view and clamp to `--max`.
fn query<'a>(notes: &'a [ResidualNote], q: &Query) -> Vec<&'a ResidualNote> {
    let mut out: Vec<&ResidualNote> = notes
        .iter()
        .filter(|n| q.kind.as_ref().is_none_or(|f| *n.kind == *f))
        .filter(|n| q.symbol.as_ref().is_none_or(|f| n.symbol.contains(f.as_str())))
        .filter(|n| q.file.as_ref().is_none_or(|f| n.file.contains(f.as_str())))
        .collect();
    out.sort_by_key(|n| (n.file.clone(), n.line, n.column));
    if let Some(m) = q.max {
        out.truncate(m);
    }
    out
}

fn usage() -> &'static str {
    concat!(
        "usage: resid-why <artifact> [symbol] [--kind K] [--file F] [--max N] ",
        "[--json] [--summary] [--help]\n",
    )
}

fn main() {
    let args: Vec<String> = std::env::args().skip(1).collect();
    if args.is_empty() {
        eprint!("{}", usage());
        std::process::exit(2);
    }
    let artifact = PathBuf::from(&args[0]);
    let mut q = Query::default();
    let mut as_json = false;
    let mut summary_only = false;
    let mut i = 1;
    while i < args.len() {
        match args[i].as_str() {
            "--help" => {
                print!("{}", usage());
                std::process::exit(0);
            }
            "--kind" => {
                i += 1;
                q.kind = args.get(i).cloned();
            }
            "--file" => {
                i += 1;
                q.file = args.get(i).cloned();
            }
            "--max" => {
                i += 1;
                q.max = args.get(i).and_then(|v| v.parse().ok());
            }
            "--json" => as_json = true,
            "--summary" => summary_only = true,
            s => q.symbol = Some(s.to_string()),
        }
        i += 1;
    }

    let notes = match read_notes_file(&artifact) {
        Some(n) => n,
        None => {
            eprintln!(
                "resid-why: no readable notes sidecar for '{}' (expected '{}.resid-notes.cbor')",
                artifact.display(),
                artifact.display(),
            );
            std::process::exit(1);
        }
    };

    let shown = query(&notes, &q);
    let shown: Vec<ResidualNote> = shown.into_iter().cloned().collect();

    if as_json {
        print!("{}", render_lsp_json(&shown));
        return;
    }
    if summary_only {
        print!("{}", render_summary(&shown));
        return;
    }

    let total = notes.len();
    for n in &shown {
        println!("{}\n", render_text(n));
    }
    if shown.is_empty() && total > 0 {
        println!("no residual notes match the query ({total} total scanned)");
    } else if shown.is_empty() {
        println!("fully reduced: no residual notes");
    } else {
        println!("{}/{total} residual notes shown", shown.len());
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn note(kind: &str, symbol: &str, line: u64) -> ResidualNote {
        ResidualNote::new(kind, symbol, line)
    }

    #[test]
    fn text_render_includes_explanation() {
        let t = render_text(&note("rt-binding", "rt print_str", 12));
        assert!(t.contains("rt print_str"));
        assert!(t.contains("line 12"));
        assert!(t.contains("runtime binding"));
    }

    #[test]
    fn text_and_json_render_file_provenance() {
        let n = ResidualNote::at("rt-binding", "rt x", 12, 4, "examples/app.resid");
        let t = render_text(&n);
        assert!(t.contains("examples/app.resid:12:5"), "{t}");
        let j = render_lsp_json(&[n]);
        assert!(j.contains("\"uri\":\"file://examples/app.resid\""), "{j}");
        assert!(j.contains("\"character\":4"), "{j}");
        // Notes without provenance keep the legacy 0-based, character-0
        // diagnostic shape.
        let legacy = render_lsp_json(&[note("rt-binding", "rt y", 3)]);
        assert!(!legacy.contains("\"uri\""), "{legacy}");
        assert!(legacy.contains("\"line\":2"), "{legacy}");
    }

    #[test]
    fn lsp_json_shape_and_escaping() {
        let notes = vec![
            note("rt-binding", "rt \"quoted\"", 1),
            note("provider-call", "filesystem.read_file(x)", 3400),
        ];
        let j = render_lsp_json(&notes);
        assert!(j.starts_with('['));
        // Lines are 0-based in LSP.
        assert!(j.contains("\"line\":0"));
        assert!(j.contains("\"line\":3399"));
        assert!(j.contains("\"severity\":4"));
        assert!(j.contains("\"source\":\"resid-why\""));
        assert!(j.contains("\\\"quoted\\\""), "quotes must be escaped: {j}");
        // Parses back via serde-free sanity: balanced brackets per item.
        assert_eq!(j.matches("{\"range\"").count(), 2);
    }

    #[test]
    fn summary_counts_per_kind() {
        let notes = vec![
            note("provider-call", "a", 1),
            note("rt-binding", "b", 2),
            note("provider-call", "c", 3),
        ];
        let s = render_summary(&notes);
        assert!(s.contains("provider-call: 2"));
        assert!(s.contains("rt-binding: 1"));
    }

    #[test]
    fn query_filters_compose_file_max_sort() {
        let notes = vec![
            note("rt-binding", "main.rt x", 40),
            note("rt-binding", "helper y", 2),
            note("provider-call", "main.fs read", 3),
            ResidualNote::at("rt-binding", "app rt z", 1, 0, "lib/app.resid"),
        ];
        let q = Query {
            kind: Some("rt-binding".into()),
            symbol: None,
            file: None,
            max: None,
        };
        let got = query(&notes, &q);
        assert_eq!(got.len(), 3);
        assert_eq!(query(&notes, &Query::default()).len(), 4);
        // File filter.
        let qf = Query { file: Some("lib/".into()), ..Query::default() };
        let got = query(&notes, &qf);
        assert_eq!(got.len(), 1);
        assert_eq!(got[0].symbol, "app rt z");
        // Max clamps after sorting by (file, line, column).
        let qm = Query { max: Some(2), ..Query::default() };
        let got = query(&notes, &qm);
        assert_eq!(got.len(), 2);
        // Sort order: empty-file notes first (their file binds lower), by
        // line within equal files.
        assert_eq!(got[0].line, 2);
        assert_eq!(got[1].line, 3);
    }
}
