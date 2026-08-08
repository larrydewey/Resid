//! `residc` — the Resid compiler driver.
//!
//! Full pipeline: lex → parse → type check → LLVM codegen.
//!
//! Usage:
//!   residc <file.resid>          — lex + parse, report diagnostics
//!   residc <file.resid> emit-ir  — full pipeline → print LLVM IR
//!   residc <file.resid> build [-o <out>] — emit + clang → native binary
//!   residc <file.resid> run      — build to a temp binary and run it

use std::env;
use std::fs;
use std::process::ExitCode;

#[cfg(unix)]
use std::os::unix::process::ExitStatusExt;

use resid_parser::{Parser, TranslationUnit};

enum Cmd {
    Check,
    EmitIr,
    Build,
    Run,
}

fn main() -> ExitCode {
    let mut args = env::args().skip(1);
    let Some(file) = args.next() else {
        eprintln!("usage: residc <file.resid> [emit-ir|build|run]");
        return ExitCode::FAILURE;
    };
    let cmd = match args.next().as_deref() {
        Some("emit-ir") => Cmd::EmitIr,
        Some("build") => Cmd::Build,
        Some("run") => Cmd::Run,
        Some(other) => {
            eprintln!("error: unknown subcommand `{other}` (expected emit-ir | build | run)");
            return ExitCode::FAILURE;
        }
        None => Cmd::Check,
    };

    // `residc <file> build [-o] <out>` — optional explicit output path.
    let out: Option<String> = match cmd {
        Cmd::Build => match args.next().as_deref() {
            Some("-o") => args.next(),
            other => other.map(|s| s.to_string()),
        },
        _ => None,
    };

    let source = match fs::read_to_string(&file) {
        Ok(s) => s,
        Err(e) => {
            eprintln!("error: cannot read '{file}': {e}");
            return ExitCode::FAILURE;
        }
    };

    let unit = match pipeline(&file, &source) {
        Ok(u) => u,
        Err(code) => return code,
    };

    match cmd {
        Cmd::Check => {
            eprintln!(
                "ok: {} imports, {} declarations",
                unit.imports.len(),
                unit.declarations.len()
            );
            ExitCode::SUCCESS
        }
        Cmd::EmitIr => {
            let ir = match emit_ir_string(&unit) {
                Ok(s) => s,
                Err(code) => return code,
            };
            print!("{ir}");
            ExitCode::SUCCESS
        }
        Cmd::Build => {
            match build_native(&file, &unit, out.as_deref()) {
                Ok(()) => ExitCode::SUCCESS,
                Err(code) => code,
            }
        }
        Cmd::Run => run_native(&file, &unit),
    }
}

/// Lex + parse + type check. Prints diagnostics and returns `Err` on failure.
fn pipeline(file: &str, source: &str) -> Result<TranslationUnit, ExitCode> {
    let (unit, errors) = Parser::parse(file, source);
    for e in &errors {
        eprintln!(
            "{}:{}:{}: error: {}",
            e.span.file, e.span.line, e.span.col_start, e.message
        );
    }
    if !errors.is_empty() {
        eprintln!(
            "error: compilation failed with {} diagnostic(s)",
            errors.len()
        );
        return Err(ExitCode::FAILURE);
    }

    let type_errors = resid_type::check_program(&unit);
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
        return Err(ExitCode::FAILURE);
    }
    Ok(unit)
}

fn emit_ir_string(unit: &TranslationUnit) -> Result<String, ExitCode> {
    let cx = inkwell::context::Context::create();
    let mut cg = resid_codegen::CodeGen::new(&cx, "resid");
    match cg.generate(unit) {
        Ok(()) => match cg.module.verify() {
            Ok(()) => Ok(cg.module.print_to_string().to_string()),
            Err(v) => {
                eprintln!("error: module failed verification:\n{v}");
                Err(ExitCode::FAILURE)
            }
        },
        Err(e) => {
            eprintln!("error: codegen failed: {e}");
            Err(ExitCode::FAILURE)
        }
    }
}

/// The tiny bootstrap runtime linked into every native Resid binary.
const RUNTIME_C: &str = include_str!("../resid_rt.c");

/// Emit IR, link with the bootstrap runtime via clang, and write a native
/// binary to `out` (defaults to `a.out` in the current directory).
fn build_native(file: &str, unit: &TranslationUnit, out: Option<&str>) -> Result<(), ExitCode> {
    let ir = emit_ir_string(unit)?;
    let tmp = temp_dir();
    let ir_path = tmp.join(format!("{}.ir.ll", stem(file)));
    let rt_path = tmp.join(format!("{}_rt.c", stem(file)));
    if let Err(e) = fs::write(&ir_path, &ir) {
        eprintln!("error: cannot write IR '{}': {e}", ir_path.display());
        return Err(ExitCode::FAILURE);
    }
    if let Err(e) = fs::write(&rt_path, RUNTIME_C) {
        eprintln!("error: cannot write runtime '{}': {e}", rt_path.display());
        return Err(ExitCode::FAILURE);
    }
    let out = out.unwrap_or("a.out");
    let status = std::process::Command::new("clang")
        .arg(&ir_path)
        .arg(&rt_path)
        .arg("-Wno-override-module")
        .arg("-o")
        .arg(out)
        .status();
    match status {
        Ok(s) if s.success() => Ok(()),
        Ok(s) => {
            eprintln!("error: clang failed with {}", s.code().unwrap_or(-1));
            Err(ExitCode::FAILURE)
        }
        Err(e) => {
            eprintln!("error: cannot run clang (is LLVM installed?): {e}");
            Err(ExitCode::FAILURE)
        }
    }
}

/// Build + run; propagates the child's exit code. If the program is killed by
/// a signal, exit with 1 (128+signal for POSIX shells).
fn run_native(file: &str, unit: &TranslationUnit) -> ExitCode {
    let tmp = temp_dir();
    let bin = tmp.join(format!("{}_bin", stem(file)));
    if let Err(code) = build_native(file, unit, Some(&bin.to_string_lossy())) {
        return code;
    }
    let mut child = match std::process::Command::new(&bin).spawn() {
        Ok(c) => c,
        Err(e) => {
            let _ = fs::remove_file(&bin);
            eprintln!("error: cannot run '{}': {e}", bin.display());
            return ExitCode::FAILURE;
        }
    };
    let status = match child.wait() {
        Ok(s) => s,
        Err(e) => {
            let _ = fs::remove_file(&bin);
            eprintln!("error: waiting for program: {e}");
            return ExitCode::FAILURE;
        }
    };
    let _ = fs::remove_file(&bin);
    match status.code() {
        Some(code) => ExitCode::from(code as u8),
        None => {
            #[cfg(unix)]
            eprintln!(
                "program terminated by signal {}",
                status.signal().unwrap_or(0)
            );
            ExitCode::from(128)
        }
    }
}

fn temp_dir() -> std::path::PathBuf {
    let mut dir = env::temp_dir();
    dir.push(format!("residc-{}", std::process::id()));
    let _ = fs::create_dir_all(&dir);
    dir
}

fn stem(file: &str) -> String {
    std::path::Path::new(file)
        .file_stem()
        .map(|s| s.to_string_lossy().into_owned())
        .unwrap_or_else(|| "resid".to_string())
}
