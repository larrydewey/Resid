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

/// One-line human explanation for a note.
fn render_text(n: &ResidualNote) -> String {
    format!(
        "{} @ line {}:\n    {}\n    -> {}",
        n.symbol,
        n.line,
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
/// sidecar. Severity 4 = Hint: residual work, not an error.
fn render_lsp_json(notes: &[ResidualNote]) -> String {
    let items: Vec<String> = notes
        .iter()
        .map(|n| {
            let line = n.line.saturating_sub(1);
            format!(
                concat!(
                    "{{\"range\":{{\"start\":{{\"line\":{},\"character\":0}},",
                    "\"end\":{{\"line\":{},\"character\":0}}}},\"severity\":4,",
                    "\"code\":\"{}\",\"source\":\"resid-why\",\"message\":\"{}\"}}"
                ),
                line,
                line,
                json_escape(&n.kind),
                json_escape(&format!(
                    "{} @ line {}: {}",
                    n.symbol,
                    n.line,
                    explain(&n.kind)
                )),
            )
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

fn filter<'a>(notes: &'a [ResidualNote], kind: &Option<String>, symbol: &Option<String>) -> Vec<&'a ResidualNote> {
    notes
        .iter()
        .filter(|n| kind.as_ref().is_none_or(|f| *n.kind == *f))
        .filter(|n| symbol.as_ref().is_none_or(|f| n.symbol.contains(f.as_str())))
        .collect()
}

fn main() {
    let args: Vec<String> = std::env::args().skip(1).collect();
    if args.is_empty() {
        eprintln!(
            "usage: resid-why <artifact> [symbol-substring] [--kind K] [--json] [--summary]"
        );
        std::process::exit(2);
    }
    let artifact = PathBuf::from(&args[0]);
    let mut filter_symbol: Option<String> = None;
    let mut filter_kind: Option<String> = None;
    let mut as_json = false;
    let mut summary_only = false;
    let mut i = 1;
    while i < args.len() {
        match args[i].as_str() {
            "--kind" => {
                i += 1;
                filter_kind = args.get(i).cloned();
            }
            "--json" => as_json = true,
            "--summary" => summary_only = true,
            s => filter_symbol = Some(s.to_string()),
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

    let shown = filter(&notes, &filter_kind, &filter_symbol);
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
        ResidualNote { kind: kind.into(), symbol: symbol.into(), line }
    }

    #[test]
    fn text_render_includes_explanation() {
        let t = render_text(&note("rt-binding", "rt print_str", 12));
        assert!(t.contains("rt print_str"));
        assert!(t.contains("line 12"));
        assert!(t.contains("runtime binding"));
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
    fn filters_compose() {
        let notes = vec![
            note("rt-binding", "main.rt x", 1),
            note("rt-binding", "helper y", 2),
            note("provider-call", "main.fs read", 3),
        ];
        let got = filter(&notes, &Some("rt-binding".into()), &Some("main".into()));
        assert_eq!(got.len(), 1);
        assert_eq!(got[0].symbol, "main.rt x");
        assert_eq!(filter(&notes, &None, &None).len(), 3);
    }
}
