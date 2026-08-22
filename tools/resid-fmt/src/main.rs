//! `resid fmt` — canonical formatter CLI (spec §37).
//!
//! Usage:
//!   resid fmt <file>          — print formatted source to stdout
//!   resid fmt <file> -w       — rewrite the file in place
//!   resid fmt <file> --check  — exit 1 if the file is not formatted

use std::process::ExitCode;

fn main() -> ExitCode {
    let mut path: Option<String> = None;
    let mut write_in_place = false;
    let mut check = false;
    for a in std::env::args().skip(1) {
        match a.as_str() {
            "-w" => write_in_place = true,
            "--check" => check = true,
            other => path = Some(other.to_string()),
        }
    }
    let Some(path) = path else {
        eprintln!("usage: resid fmt <file> [-w | --check]");
        return ExitCode::FAILURE;
    };
    let src = match std::fs::read_to_string(&path) {
        Ok(s) => s,
        Err(e) => {
            eprintln!("error: cannot read '{path}': {e}");
            return ExitCode::FAILURE;
        }
    };
    let formatted = match resid_fmt::format_source(&src) {
        Ok(f) => f,
        Err(e) => {
            eprintln!("error: cannot format '{path}':\n{e}");
            return ExitCode::FAILURE;
        }
    };
    if write_in_place {
        if let Err(e) = std::fs::write(&path, &formatted) {
            eprintln!("error: cannot write '{path}': {e}");
            return ExitCode::FAILURE;
        }
        return ExitCode::SUCCESS;
    }
    if check {
        if src == formatted {
            println!("{path}: formatted");
            ExitCode::SUCCESS
        } else {
            eprintln!("{path}: not formatted (run `resid fmt {path} -w`)");
            ExitCode::FAILURE
        }
    } else {
        print!("{formatted}");
        ExitCode::SUCCESS
    }
}
