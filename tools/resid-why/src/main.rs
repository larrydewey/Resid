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

use std::path::PathBuf;

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

fn main() {
    let args: Vec<String> = std::env::args().skip(1).collect();
    if args.is_empty() {
        eprintln!("usage: resid-why <artifact> [symbol-substring] [--kind K]");
        std::process::exit(2);
    }
    let artifact = PathBuf::from(&args[0]);
    let mut filter_symbol: Option<String> = None;
    let mut filter_kind: Option<String> = None;
    let mut i = 1;
    while i < args.len() {
        match args[i].as_str() {
            "--kind" => {
                i += 1;
                filter_kind = args.get(i).cloned();
            }
            s => filter_symbol = Some(s.to_string()),
        }
        i += 1;
    }

    let notes = match resid_notes::read_notes_file(&artifact) {
        Some(n) => n,
        None => {
            eprintln!(
                "resid-why: no readable notes sidecar for '{}' (expected '{}')",
                artifact.display(),
                format!("{}.resid-notes.cbor", artifact.display())
            );
            std::process::exit(1);
        }
    };

    let total = notes.len();
    let mut shown = 0usize;
    for n in &notes {
        if let Some(f) = &filter_kind {
            if *n.kind != *f {
                continue;
            }
        }
        if let Some(f) = &filter_symbol {
            if !n.symbol.contains(f.as_str()) {
                continue;
            }
        }
        shown += 1;
        println!(
            "{} @ line {}:\n    {}\n    -> {}",
            n.symbol,
            n.line,
            n.kind,
            explain(&n.kind)
        );
    }
    println!();
    if shown == 0 && total > 0 {
        println!("no residual notes match the query ({total} total scanned)");
    } else if shown == 0 {
        println!("fully reduced: no residual notes");
    } else {
        println!("{shown}/{total} residual notes shown");
    }
}
