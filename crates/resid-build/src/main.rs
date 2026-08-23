//! `resid-build` — build a Resid package from its resid.toml manifest.
//!
//! Usage:
//!   resid-build [dir] [-p profile] [-o outdir]  — build
//!   resid-build keygen <secret.hex> <pub.hex>   — Ed25519 signing keys
//!   resid-build pack <dir> --key secret.hex     — archive + sign a package
//!   resid-build verify <pkg> --sig sig --key pub.hex  — verify an archive
//!   resid-build publish <dir> --registry <dir> --key secret.hex — pack into registry

use std::path::PathBuf;
use std::process::ExitCode;

fn main() -> ExitCode {
    let args: Vec<String> = std::env::args().skip(1).collect();
    match args.first().map(|s| s.as_str()) {
        Some("keygen") => return cmd_keygen(&args[1..]),
        Some("pack") => return cmd_pack(&args[1..]),
        Some("verify") => return cmd_verify(&args[1..]),
        Some("publish") => return cmd_publish(&args[1..]),
        _ => {}
    }
    cmd_build(args)
}

fn cmd_keygen(args: &[String]) -> ExitCode {
    if args.len() != 2 {
        eprintln!("usage: resid-build keygen <secret.hex> <pub.hex>");
        return ExitCode::FAILURE;
    }
    let (secret, public) = match resid_build::archive::keygen() {
        Ok(k) => k,
        Err(e) => {
            eprintln!("error: {e}");
            return ExitCode::FAILURE;
        }
    };
    if let Err(e) = std::fs::write(&args[0], &secret) {
        eprintln!("error: cannot write '{}': {e}", args[0]);
        return ExitCode::FAILURE;
    }
    if let Err(e) = std::fs::write(&args[1], &public) {
        eprintln!("error: cannot write '{}': {e}", args[1]);
        return ExitCode::FAILURE;
    }
    println!("wrote {} (keep secret!)", args[0]);
    println!("wrote {}", args[1]);
    ExitCode::SUCCESS
}

fn cmd_pack(args: &[String]) -> ExitCode {
    let mut dir: Option<String> = None;
    let mut out: Option<String> = None;
    let mut key: Option<String> = None;
    let mut it = args.iter();
    while let Some(a) = it.next() {
        match a.as_str() {
            "-o" => out = it.next().cloned(),
            "--key" => key = it.next().cloned(),
            other => dir = Some(other.to_string()),
        }
    }
    let (Some(dir), Some(key)) = (dir, key) else {
        eprintln!("usage: resid-build pack <dir> --key <secret.hex> [-o pkg.resid-pkg]");
        return ExitCode::FAILURE;
    };
    // Load the manifest for the package name.
    let manifest = match resid_build::Manifest::load(std::path::Path::new(&dir)) {
        Ok(m) => m,
        Err(e) => {
            eprintln!("error: {e}");
            return ExitCode::FAILURE;
        }
    };
    let archive = match resid_build::archive::build_archive(std::path::Path::new(&dir)) {
        Ok(a) => a,
        Err(e) => {
            eprintln!("error: cannot pack '{dir}': {e}");
            return ExitCode::FAILURE;
        }
    };
    let hash = resid_build::archive::content_hash(&archive);
    let secret_hex = match std::fs::read_to_string(&key) {
        Ok(s) => s.trim().to_string(),
        Err(e) => {
            eprintln!("error: cannot read key '{key}': {e}");
            return ExitCode::FAILURE;
        }
    };
    let sig = match resid_build::archive::sign_hash(&hash, &secret_hex) {
        Ok(s) => s,
        Err(e) => {
            eprintln!("error: signing failed: {e}");
            return ExitCode::FAILURE;
        }
    };
    let pkg_path = out.unwrap_or_else(|| format!("{}.resid-pkg", manifest.name));
    let sig_path = format!("{}.resid-sig", pkg_path);
    if let Err(e) = std::fs::write(&pkg_path, &archive) {
        eprintln!("error: cannot write '{pkg_path}': {e}");
        return ExitCode::FAILURE;
    }
    if let Err(e) = std::fs::write(&sig_path, &sig) {
        eprintln!("error: cannot write '{sig_path}': {e}");
        return ExitCode::FAILURE;
    }
    println!(
        "packed {} ({} files, sha256 {}) → {}, {}",
        manifest.name,
        count_files(&archive),
        hex_prefix(&hash),
        pkg_path,
        sig_path
    );
    ExitCode::SUCCESS
}

fn cmd_verify(args: &[String]) -> ExitCode {
    let mut pkg: Option<String> = None;
    let mut sig: Option<String> = None;
    let mut key: Option<String> = None;
    let mut it = args.iter();
    while let Some(a) = it.next() {
        match a.as_str() {
            "--sig" => sig = it.next().cloned(),
            "--key" => key = it.next().cloned(),
            other => pkg = Some(other.to_string()),
        }
    }
    let (Some(pkg), Some(sig), Some(key)) = (pkg, sig, key) else {
        eprintln!("usage: resid-build verify <pkg> --sig <sig> --key <pub.hex>");
        return ExitCode::FAILURE;
    };
    let archive = match std::fs::read(&pkg) {
        Ok(a) => a,
        Err(e) => {
            eprintln!("error: cannot read '{pkg}': {e}");
            return ExitCode::FAILURE;
        }
    };
    let hash = resid_build::archive::content_hash(&archive);
    let sig_hex = match std::fs::read_to_string(&sig) {
        Ok(s) => s.trim().to_string(),
        Err(e) => {
            eprintln!("error: cannot read sig '{sig}': {e}");
            return ExitCode::FAILURE;
        }
    };
    let pub_hex = match std::fs::read_to_string(&key) {
        Ok(s) => s.trim().to_string(),
        Err(e) => {
            eprintln!("error: cannot read key '{key}': {e}");
            return ExitCode::FAILURE;
        }
    };
    match resid_build::archive::verify_sig(&hash, &sig_hex, &pub_hex) {
        Ok(true) => {
            println!("{pkg}: signature valid");
            ExitCode::SUCCESS
        }
        Ok(false) => {
            eprintln!("{pkg}: SIGNATURE INVALID");
            ExitCode::FAILURE
        }
        Err(e) => {
            eprintln!("error: {e}");
            ExitCode::FAILURE
        }
    }
}


/// `publish <dir> --registry <path> [--key secret.hex]`: pack the package
/// and drop `<name>-<version>.resid-pkg` + `.sha256` + `.sig` into the
/// local registry directory (transport to a remote server is future work).
fn cmd_publish(args: &[String]) -> ExitCode {
    let mut dir: Option<String> = None;
    let mut reg: Option<String> = None;
    let mut key: Option<String> = None;
    let mut it = args.iter();
    while let Some(a) = it.next() {
        match a.as_str() {
            "--registry" => reg = it.next().cloned(),
            "--key" => key = it.next().cloned(),
            other => dir = Some(other.to_string()),
        }
    }
    let (Some(dir), Some(reg)) = (dir, reg) else {
        eprintln!("usage: resid-build publish <dir> --registry <path> [--key secret.hex]");
        return ExitCode::FAILURE;
    };
    let manifest = match resid_build::Manifest::load(std::path::Path::new(&dir)) {
        Ok(m) => m,
        Err(e) => {
            eprintln!("error: {e}");
            return ExitCode::FAILURE;
        }
    };
    let archive = match resid_build::archive::build_archive(std::path::Path::new(&dir)) {
        Ok(a) => a,
        Err(e) => {
            eprintln!("error: cannot pack '{dir}': {e}");
            return ExitCode::FAILURE;
        }
    };
    let hash_hex = resid_build::archive::hex_encode(&resid_build::archive::content_hash(&archive));
    let sig = key.and_then(|k| std::fs::read_to_string(&k).ok().map(|s| s.trim().to_string()))
        .and_then(|secret| {
            resid_build::archive::sign_hash(&resid_build::archive::content_hash(&archive), &secret)
                .ok()
        });
    let base = format!("{}-{}.resid", manifest.name, manifest.version);
    let pkg_path = std::path::Path::new(&reg).join(format!("{base}-pkg"));
    let sha_path = std::path::Path::new(&reg).join(format!("{base}-sha256"));
    if let Err(e) = std::fs::write(&pkg_path, &archive) {
        eprintln!("error: cannot write '{}': {e}", pkg_path.display());
        return ExitCode::FAILURE;
    }
    if let Err(e) = std::fs::write(&sha_path, format!("{hash_hex}\n")) {
        eprintln!("error: cannot write '{}': {e}", sha_path.display());
        return ExitCode::FAILURE;
    }
    print!(
        "published {} {} (sha256 {}) → {}",
        manifest.name, manifest.version, hash_hex,
        pkg_path.display()
    );
    if let Some(sig) = sig {
        let sig_path = std::path::Path::new(&reg).join(format!("{base}-sig"));
        let _ = std::fs::write(&sig_path, sig);
        println!(" (+ signature)");
    } else {
        println!(" (unsigned)");
    }
    ExitCode::SUCCESS
}

fn count_files(archive: &[u8]) -> usize {
    if archive.len() < 13 {
        return 0;
    }
    u32::from_le_bytes([archive[9], archive[10], archive[11], archive[12]]) as usize
}

fn hex_prefix(hash: &[u8; 32]) -> String {
    resid_build::archive::hex_encode(&hash[..8])
}

fn cmd_build(args: Vec<String>) -> ExitCode {
    let mut dir = PathBuf::from(".");
    let mut profile = resid_build::Profile::Debug;
    let mut out_dir: Option<PathBuf> = None;

    let mut args = args.into_iter();
    while let Some(a) = args.next() {
        match a.as_str() {
            "-p" | "--profile" => match args.next().as_deref().map(resid_build::Profile::parse) {
                Some(Ok(p)) => profile = p,
                Some(Err(e)) => {
                    eprintln!("error: {e}");
                    return ExitCode::FAILURE;
                }
                None => {
                    eprintln!("error: -p requires a value");
                    return ExitCode::FAILURE;
                }
            },
            "-o" | "--out" => match args.next() {
                Some(o) => out_dir = Some(PathBuf::from(o)),
                None => {
                    eprintln!("error: -o requires a value");
                    return ExitCode::FAILURE;
                }
            },
            other if !other.starts_with('-') => dir = PathBuf::from(other),
            other => {
                eprintln!("error: unknown option `{other}`");
                return ExitCode::FAILURE;
            }
        }
    }

    let manifest = match resid_build::Manifest::load(&dir) {
        Ok(m) => m,
        Err(e) => {
            eprintln!("error: {e}");
            return ExitCode::FAILURE;
        }
    };
    println!(
        "building {} v{} ({})",
        manifest.name,
        manifest.version,
        profile
    );

    let out_dir = out_dir.unwrap_or_else(|| manifest.out_dir());
    match resid_build::build(&manifest, profile, &out_dir) {
        Ok(resid_build::Artifact::Binary(path)) => {
            println!("wrote {}", path.display());
            ExitCode::SUCCESS
        }
        Ok(resid_build::Artifact::Checked) => {
            println!("typecheck OK");
            ExitCode::SUCCESS
        }
        Err(e) => {
            eprint!("error: {e}");
            ExitCode::FAILURE
        }
    }
}
