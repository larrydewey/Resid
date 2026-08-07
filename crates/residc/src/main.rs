//! `residc` — the Resid compiler driver.
//!
//! Full pipeline: lex → parse → type check → (emit-ir) LLVM codegen.
//!
//! Usage:
//!   residc <file.resid>          — lex + parse, report diagnostics
//!   residc <file.resid> emit-ir  — full pipeline → print LLVM IR

use std::env;
use std::fs;
use std::process::ExitCode;

fn main() -> ExitCode {
    let args: Vec<String> = env::args().skip(1).collect();

    let file = match args.first() {
        Some(f) => f.as_str(),
        None => {
            eprintln!("usage: residc <file.resid> [emit-ir]");
            return ExitCode::FAILURE;
        }
    };

    let source = match fs::read_to_string(file) {
        Ok(s) => s,
        Err(e) => {
            eprintln!("error: cannot read '{file}': {e}");
            return ExitCode::FAILURE;
        }
    };

    let (unit, errors) = resid_parser::Parser::parse(file, &source);

    for e in &errors {
        eprintln!(
            "{}:{}:{}: error: {}",
            e.span.file, e.span.line, e.span.col_start, e.message
        );
    }

    if !errors.is_empty() {
        eprintln!("error: compilation failed with {} diagnostic(s)", errors.len());
        return ExitCode::FAILURE;
    }

    if args.get(1).map(|s| s.as_str()) == Some("emit-ir") {
        return emit_ir(&unit);
    }

    eprintln!(
        "ok: {} imports, {} declarations",
        unit.imports.len(),
        unit.declarations.len()
    );
    ExitCode::SUCCESS
}

fn emit_ir(unit: &resid_parser::TranslationUnit) -> ExitCode {
    // Run upfront type checking.
    let type_errors = resid_type::check_program(unit);
    for e in &type_errors {
        eprintln!(
            "{}:{}:{}: type error: {}",
            e.span.file, e.span.line, e.span.col_start, e.message
        );
    }
    if !type_errors.is_empty() {
        eprintln!(
            "error: type checking failed with {} diagnostic(s)",
            type_errors.len()
        );
        return ExitCode::FAILURE;
    }

    let cx = inkwell::context::Context::create();
    let mut cg = resid_codegen::CodeGen::new(&cx, "resid");
    match cg.generate(unit) {
        Ok(()) => {
            if let Err(v) = cg.module.verify() {
                eprintln!("error: module failed verification:\n{v}");
                return ExitCode::FAILURE;
            }
            print!("{}", cg.module.print_to_string().to_string());
            ExitCode::SUCCESS
        }
        Err(e) => {
            eprintln!("error: codegen failed: {e}");
            ExitCode::FAILURE
        }
    }
}