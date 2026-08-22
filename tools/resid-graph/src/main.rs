//! `resid-graph` — call graph for a Resid program (spec §37).
//!
//! Usage:
//!   resid-graph <file.resid>           — text tree to stdout
//!   resid-graph <file.resid> --dot     — Graphviz DOT to stdout

use std::process::ExitCode;

fn main() -> ExitCode {
    let mut path: Option<String> = None;
    let mut dot = false;
    for a in std::env::args().skip(1) {
        match a.as_str() {
            "--dot" => dot = true,
            other => path = Some(other.to_string()),
        }
    }
    let Some(path) = path else {
        eprintln!("usage: resid-graph <file.resid> [--dot]");
        return ExitCode::FAILURE;
    };
    let graph = match resid_graph::graph_of_file(std::path::Path::new(&path)) {
        Ok(g) => g,
        Err(e) => {
            eprintln!("error: {e}");
            return ExitCode::FAILURE;
        }
    };
    if dot {
        print!("{}", resid_graph::to_dot(&graph));
    } else {
        print!("{}", resid_graph::to_text(&graph));
    }
    ExitCode::SUCCESS
}
