//! `residc` — the Resid compiler driver.
//!
//! Full pipeline: lex → parse → type check → LLVM codegen.
//!
//! Usage:
//!   residc <file.resid>          — lex + parse, report diagnostics
//!   residc <file.resid> emit-ir  — full pipeline → print LLVM IR
//!   residc <file.resid> build [-o <out>] — emit + clang → native binary
//!   residc <file.resid> run [args...] — build to a temp binary and run it,
//!       forwarding everything after `run` as the program's arguments

use std::env;
use std::fs;
use std::path::Path;
use std::process::ExitCode;

#[cfg(unix)]
use std::os::unix::process::ExitStatusExt;

use resid_parser::TranslationUnit;

enum Cmd {
    Check,
    EmitIr,
    Build,
    Run,
    Keygen,
    Verify,
}

fn main() -> ExitCode {
    let mut all: Vec<String> = env::args().skip(1).collect();
    // Tool-style subcommands that take a path in the file slot.
    let tool_cmd = all
        .iter()
        .find(|s| s.as_str() == "keygen" || s.as_str() == "verify")
        .cloned();
    let mut all_iter = all.into_iter();
    if let Some(c) = tool_cmd {
        all_iter.next();
        if c == "keygen" {
            return cmd_keygen();
        }
        let Some(target) = all_iter.next() else {
            eprintln!("usage: residc verify <binary>");
            return ExitCode::FAILURE;
        };
        return cmd_verify(&target);
    }
    let mut args = all_iter;
    let Some(file) = args.next() else {
        eprintln!("usage: residc <file.resid> [emit-ir|build|run]");
        return ExitCode::FAILURE;
    };
    let cmd = match args.next().as_deref() {
        Some("emit-ir") => Cmd::EmitIr,
        Some("build") => Cmd::Build,
        Some("run") => Cmd::Run,
        Some("keygen") => Cmd::Keygen,
        Some("verify") => Cmd::Verify,
        Some(other) => {
            eprintln!("error: unknown subcommand `{other}` (expected emit-ir | build | run)");
            return ExitCode::FAILURE;
        }
        None => Cmd::Check,
    };

    if matches!(cmd, Cmd::Keygen) {
        return cmd_keygen();
    }
    if matches!(cmd, Cmd::Verify) {
        let Some(bin) = args.next() else {
            eprintln!("usage: residc verify <binary>");
            return ExitCode::FAILURE;
        };
        return cmd_verify(&bin);
    }

    // `residc <file> run [args...]` — everything after `run` is forwarded to
    // the program as its command-line arguments (argv[1..]).
    let prog_args: Vec<String> = match cmd {
        Cmd::Run => args.by_ref().collect(),
        _ => Vec::new(),
    };

    // `residc <file> build [-o] <out>` — optional explicit output path.
    let out: Option<String> = match cmd {
        Cmd::Build => match args.next().as_deref() {
            Some("-o") => args.next(),
            other => other.map(|s| s.to_string()),
        },
        _ => None,
    };

    // Knowledge cache (spec §21.4, §35): skip the whole pipeline when the
    // source (and driver version) are unchanged and the artifact still
    // exists. The cache is an accelerator, never authoritative.
    let cache_key;
    let cache_out;
    match cmd {
        Cmd::Build | Cmd::Run => {
            // Provenance mode is part of the build identity: an encrypted
            // trailer is a different artifact than a plain one.
            let prov_encrypt = env::var("RESID_PROV_ENCRYPT").map(|v| v == "1").unwrap_or(false);
            let enc_key = env::var("RESID_PROV_KEY").ok();
            if prov_encrypt && enc_key.is_none() {
                eprintln!("error: RESID_PROV_ENCRYPT=1 requires RESID_PROV_KEY=<64 hex chars>");
                return ExitCode::FAILURE;
            }
            let src_bytes = fs::read(&file).unwrap_or_default();
            cache_key = resid_cache::hash_inputs(&[
                b"residc-v1",
                &src_bytes,
                if prov_encrypt { b"enc0" } else { b"plain" },
            ]);
            // Run artifacts must be UNIQUE per source: parallel invocations
            // that share a stem (every test's main.resid) would otherwise
            // overwrite each other's binaries mid-execution.
            let key_short: String = cache_key.chars().take(16).collect();
            let out_guess = match cmd {
                Cmd::Build => out.clone().unwrap_or_else(|| "a.out".to_string()),
                Cmd::Run => temp_dir().join(format!("{}_{}", stem(&file), key_short)).to_string_lossy().into_owned(),
                _ => String::new(),
            };
            cache_out = out_guess;
            let mut store = resid_cache::Store::open(Path::new(".resid-cache.cbor"));
            if let Some(cached) = store.get(&cache_key) {
                if Path::new(cached).exists() {
                    if matches!(cmd, Cmd::Build) {
                        eprintln!("cache: hit ({cached})");
                        return ExitCode::SUCCESS;
                    }
                    // Run: execute the cached binary directly.
                    if matches!(cmd, Cmd::Run) {
                        verify_if_configured(cached);
                    }
                    let status = std::process::Command::new(cached)
                        .args(&prog_args)
                        .status();
                    return match status {
                        Ok(s) => {
                            #[cfg(unix)]
                            if let Some(sig) = s.signal() {
                                eprintln!("terminated by signal {sig}");
                                return ExitCode::FAILURE;
                            }
                            ExitCode::from(s.code().unwrap_or(1) as u8)
                        }
                        Err(e) => {
                            eprintln!("error: cannot run '{cached}': {e}");
                            ExitCode::FAILURE
                        }
                    };
                }
            }
        }
        _ => {
            cache_key = String::new();
            cache_out = String::new();
        }
    }

    let unit = match pipeline(&file) {
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
            match build_native(&file, &unit, out.as_deref(), &cache_key) {
                Ok(()) => ExitCode::SUCCESS,
                Err(code) => code,
            }
        }
        Cmd::Run => run_native(&file, &unit, &prog_args, &cache_key),
        Cmd::Keygen | Cmd::Verify => unreachable!("handled earlier"),
    }
}

/// Resolve imports + lex + parse + type check. Prints diagnostics and
/// returns `Err` on failure.
fn pipeline(file: &str) -> Result<TranslationUnit, ExitCode> {
    let unit = match resid_parser::resolve_unit(std::path::Path::new(file)) {
        Ok(u) => u,
        Err(e) => {
            eprintln!("error: {e}");
            return Err(ExitCode::FAILURE);
        }
    };

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
fn build_native(
    file: &str,
    unit: &TranslationUnit,
    out: Option<&str>,
    cache_key: &str,
) -> Result<(), ExitCode> {
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
        .arg("-pthread")
        .arg("-o")
        .arg(out)
        .status();
    note_residual(file, Path::new(out));
    let prov_encrypt = env::var("RESID_PROV_ENCRYPT").map(|v| v == "1").unwrap_or(false);
    let enc_key = env::var("RESID_PROV_KEY").ok();
    if prov_encrypt && enc_key.is_none() {
        eprintln!("error: RESID_PROV_ENCRYPT=1 requires RESID_PROV_KEY=<64 hex chars>");
        return Err(ExitCode::FAILURE);
    }
    match status {
        Ok(s) if s.success() => {
            let mut store = resid_cache::Store::open(Path::new(".resid-cache.cbor"));
            store.put(cache_key.clone(), out.clone());
            store.put(cache_key.to_string(), out.clone());
            if let Err(e) = store.flush() {
                eprintln!("cache flush error: {e}");
            }
            // Signed provenance trailer (spec §27/§34). Confidential
            // reservation (§35): RESID_PROV_ENCRYPT=1 + RESID_PROV_KEY wraps
            // the payload in COSE_Encrypt0 (experimental cipher, cose.rs).
            if let Some(sec) = ensure_signing_key_interactive() {
                let mut bytes = match fs::read(out) {
                    Ok(b) => b,
                    Err(e) => {
                        eprintln!("error: cannot read built binary '{out}': {e}");
                        return Err(ExitCode::FAILURE);
                    }
                };
                let src_sha =
                    resid_build::provenance::sha256_hex(&fs::read(file).unwrap_or_default());
                let bin_sha = resid_build::provenance::sha256_hex(&bytes);
                let notes = collect_residual_notes(file);
                let mut payload = Vec::new();
                resid_cache::cbor::write_map_header(&mut payload, 5);
                resid_cache::cbor::write_text(&mut payload, "toolchain");
                resid_cache::cbor::write_text(&mut payload, "residc-v1");
                resid_cache::cbor::write_text(&mut payload, "source_sha256");
                resid_cache::cbor::write_text(&mut payload, &src_sha);
                resid_cache::cbor::write_text(&mut payload, "binary_sha256");
                resid_cache::cbor::write_text(&mut payload, &bin_sha);
                resid_cache::cbor::write_text(&mut payload, "output");
                resid_cache::cbor::write_text(&mut payload, out);
                resid_cache::cbor::write_text(&mut payload, "notes");
                resid_cache::cbor::write_bytes(&mut payload, &resid_notes::to_cbor(&notes));
                let signed_payload = if prov_encrypt {
                    match resid_build::cose::encrypt0_seal(
                        &payload,
                        enc_key.as_deref().unwrap(),
                        "resid-prov",
                    ) {
                        Ok(b) => b,
                        Err(e) => {
                            eprintln!("error: {e}");
                            return Err(ExitCode::FAILURE);
                        }
                    }
                } else {
                    payload
                };
                let tag = if prov_encrypt { "encrypt0+sign1" } else { "sign1" };
                if let Err(e) = resid_build::provenance::seal(&mut bytes, &signed_payload, &sec) {
                    eprintln!("error: {e}");
                    return Err(ExitCode::FAILURE);
                }
                if let Err(e) = fs::write(out, &bytes) {
                    eprintln!("error: cannot write sealed binary '{out}': {e}");
                    return Err(ExitCode::FAILURE);
                }
                eprintln!(
                    "provenance: signed [{}] ({} notes)",
                    tag, notes.len()
                );
            }
            Ok(())
        }
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
/// Optional verify-before-execute (spec §35 `verify_on_run`): set
/// RESID_VERIFY=1 to check the embedded provenance each run.
fn verify_if_configured(bin: &str) {
    if env::var("RESID_VERIFY").map(|v| v == "1").unwrap_or(false) {
        let bytes = fs::read(bin).unwrap_or_default();
        let pub_hex = fs::read_to_string(format!("{KEY_DIR}/resid-ed25519.pub"))
            .map(|s| s.trim().to_string())
            .unwrap_or_default();
        match resid_build::provenance::verify_full(&bytes, &pub_hex) {
            Ok((true, true)) => {}
            _ => {
                eprintln!("error: provenance verification failed; refusing to run");
                std::process::exit(70);
            }
        }
    }
}

fn run_native(
    file: &str,
    unit: &TranslationUnit,
    prog_args: &[String],
    cache_key: &str,
) -> ExitCode {
    let tmp = temp_dir();
    let bin = tmp.join(format!("{}_bin", stem(file)));
    if let Err(code) = build_native(file, unit, Some(&bin.to_string_lossy()), &cache_key) {
        return code;
    }
    verify_if_configured(&bin.to_string_lossy());
    let mut child = match std::process::Command::new(&bin)
        .args(prog_args)
        .spawn()
    {
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

/// Record residual facts (spec §27/§34) for `file` next to its artifact:
/// every `rt` binding and trusted-provider call becomes a note so later
/// compilations can see what remains residual.
fn note_residual(file: &str, artifact: &Path) {
    let notes = collect_residual_notes(file);
    // Reduction pass (spec §34): notes from a previous build of this
    // artifact that no longer appear are discharged knowledge.
    if let Some(prior) = resid_notes::read_notes_file(artifact) {
        for p in &prior {
            if !notes.contains(p) {
                eprintln!(
                    "reduction: discharged {} at line {} ({})",
                    p.kind, p.line, p.symbol
                );
            }
        }
    }
    let _ = resid_notes::write_notes_file(artifact, &notes);
}

fn collect_residual_notes(file: &str) -> Vec<resid_notes::ResidualNote> {
    let text = fs::read_to_string(file).unwrap_or_default();
    let mut notes = Vec::new();
    for (idx, line) in text.lines().enumerate() {
        for (kind, pat) in [
            ("rt-binding", "rt "),
            ("provider-call", "filesystem."),
            ("provider-call", "env."),
            ("provider-call", "args."),
            ("provider-call", "process."),
            ("provider-call", "git."),
        ] {
            if let Some(col) = line.find(pat) {
                let symbol: String = line[col..].trim_start().chars().take(40).collect();
                notes.push(resid_notes::ResidualNote {
                    kind: kind.to_string(),
                    symbol,
                    line: (idx + 1) as u64,
                });
                break;
            }
        }
    }
        notes
}

// ── signing + provenance (spec §27/§28/§34/§35) ──

const KEY_DIR: &str = "keys";
const KEY_FILE: &str = "keys/resid-ed25519.key";

/// Load the hex-encoded signing seed, or None if no key exists.
fn load_signing_key() -> Option<String> {
    fs::read_to_string(KEY_FILE)
        .ok()
        .map(|s| s.trim().to_string())
        .filter(|s| !s.is_empty())
}

/// First-time signing wizard: generate a keypair under keys/, with a
/// confirmation prompt when attached to a terminal.
fn ensure_signing_key_interactive() -> Option<String> {
    if let Some(k) = load_signing_key() {
        return Some(k);
    }
    use std::io::IsTerminal;
    let interactive = std::io::stdin().is_terminal();
    if interactive {
        println!("No signing key found. Builds can carry a signed provenance");
        println!("trailer (Ed25519 over build facts) verifiable with `residc verify`.");
        print!("Generate a keypair at {KEY_FILE}? [Y/n] ");
        use std::io::Write;
        let _ = std::io::stdout().flush();
        let mut ans = String::new();
        let _ = std::io::stdin().read_line(&mut ans);
        let ans = ans.trim().to_ascii_lowercase();
        if !(ans.is_empty() || ans == "y" || ans == "yes") {
            eprintln!("note: binary will be unsigned");
            return None;
        }
    } else {
        eprintln!("note: unsigned build (no key; run `residc keygen`, or set RESID_SIGN_KEY)");
        return None;
    }
    match cmd_keygen() {
        ExitCode::SUCCESS => load_signing_key(),
        _ => None,
    }
}

fn cmd_keygen() -> ExitCode {
    match resid_build::archive::keygen() {
        Ok((sec, pubk)) => {
            let _ = fs::create_dir_all(KEY_DIR);
            if fs::write(KEY_FILE, format!("{sec}\n")).is_err() {
                eprintln!("error: cannot write {KEY_FILE}");
                return ExitCode::FAILURE;
            }
            let pubfile = format!("{KEY_DIR}/resid-ed25519.pub");
            let _ = fs::write(pubfile, format!("{pubk}\n"));
            println!("keypair written: {KEY_FILE} (+ .pub)");
            println!("keep the secret file safe; the .pub is what `residc verify` checks against.");
            ExitCode::SUCCESS
        }
        Err(e) => {
            eprintln!("error: {e}");
            ExitCode::FAILURE
        }
    }
}

/// `residc verify <binary>` — check the embedded signed provenance.
fn cmd_verify(bin_path: &str) -> ExitCode {
    let bytes = match fs::read(bin_path) {
        Ok(b) => b,
        Err(e) => {
            eprintln!("error: cannot read '{bin_path}': {e}");
            return ExitCode::FAILURE;
        }
    };
    // Stage-2 sidecar form: <bin>.resid-prov = payload line + sig-hex line.
    if bytes.starts_with(b"toolchain=") {
        return cmd_verify_sidecar(bin_path, &bytes);
    }
    let sidecar = format!("{bin_path}.resid-prov");
    if let Ok(sc) = fs::read_to_string(&sidecar) {
        return cmd_verify_sidecar(&sidecar, sc.as_bytes());
    }
    let Some((payload, sig)) = resid_build::provenance::unseal(&bytes) else {
        println!("no provenance trailer found in {bin_path}");
        return ExitCode::FAILURE;
    };
    // The verifying key is whatever public key sits next to the binary's
    // build key; fall back to keys/resid-ed25519.pub.
    let pub_hex = fs::read_to_string(format!("{KEY_DIR}/resid-ed25519.pub"))
        .map(|s| s.trim().to_string())
        .ok();
    let Some(pub_hex) = pub_hex else {
        eprintln!("error: no public key at {KEY_DIR}/resid-ed25519.pub");
        return ExitCode::FAILURE;
    };
    let concealed = matches!(resid_build::provenance::payload_kind(&bytes), Some("encrypt0"));
    match resid_build::provenance::verify_full(&bytes, &pub_hex) {
        Ok((true, true)) => {
            if concealed {
                println!("provenance: SIGNATURE OK (encrypted payload; code hash sealed inside)");
            } else {
                println!("provenance: SIGNATURE OK — code and build facts are authentic");
            }
            println!(
                "payload: {} bytes, sha256 {}",
                payload.len(),
                resid_build::provenance::sha256_hex(payload)
            );
            ExitCode::SUCCESS
        }
        Ok((true, false)) => {
            println!("provenance: SIGNATURE VALID but CODE HASH MISMATCH — binary was modified after signing");
            ExitCode::FAILURE
        }
        Ok((false, _)) => {
            println!("provenance: SIGNATURE INVALID — provenance is not authentic");
            ExitCode::FAILURE
        }
        Err(e) => {
            eprintln!("error: {e}");
            ExitCode::FAILURE
        }
    }
}

/// Verify a `.resid-prov` sidecar: line 1 = cleartext payload,
/// line 2 = Ed25519 signature hex. Checked against
/// keys/resid-ed25519.pub.
fn cmd_verify_sidecar(name: &str, bytes: &[u8]) -> ExitCode {
    let text = String::from_utf8_lossy(bytes);
    let mut lines = text.lines();
    let Some(payload) = lines.next() else {
        eprintln!("error: empty sidecar");
        return ExitCode::FAILURE;
    };
    let Some(sig_hex) = lines.next() else {
        eprintln!("error: sidecar missing signature line");
        return ExitCode::FAILURE;
    };
    let Ok(pub_hex) = fs::read_to_string(format!("{KEY_DIR}/resid-ed25519.pub"))
        .map(|s| s.trim().to_string())
    else {
        eprintln!("error: no public key at {KEY_DIR}/resid-ed25519.pub");
        return ExitCode::FAILURE;
    };
    let mut sig_bytes = Vec::new();
    let nib = sig_hex.as_bytes();
    if nib.len() != 128 {
        eprintln!("error: bad signature length");
        return ExitCode::FAILURE;
    }
    let hv = |c: u8| -> Option<u8> {
        match c {
            b'0'..=b'9' => Some(c - b'0'),
            b'a'..=b'f' => Some(c - b'a' + 10),
            _ => None,
        }
    };
    for i in (0..nib.len()).step_by(2) {
        match (hv(nib[i]), hv(nib[i + 1])) {
            (Some(h), Some(l)) => sig_bytes.push(h * 16 + l),
            _ => {
                eprintln!("error: bad signature hex");
                return ExitCode::FAILURE;
            }
        }
    }
    match resid_build::provenance::verify_raw(payload.as_bytes(), &sig_bytes, &pub_hex) {
        Ok(true) => {
            println!("provenance: SIGNATURE OK (sidecar)");
            println!("payload: {payload}");
            ExitCode::SUCCESS
        }
        Ok(false) => {
            println!("provenance: SIGNATURE INVALID");
            ExitCode::FAILURE
        }
        Err(e) => {
            eprintln!("error: {e}");
            ExitCode::FAILURE
        }
    }
}
