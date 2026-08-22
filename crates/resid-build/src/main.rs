//! `resid-build` — build a Resid package from its resid.toml manifest.
//!
//! Usage:
//!   resid-build [dir]            — build package in dir (default .), debug
//!   resid-build [dir] -p release — release build (-O2)
//!   resid-build [dir] -p check   — type check only
//!   resid-build [dir] -o outdir  — artifact directory (default target/resid)

use std::path::PathBuf;
use std::process::ExitCode;

fn main() -> ExitCode {
    let mut dir = PathBuf::from(".");
    let mut profile = resid_build::Profile::Debug;
    let mut out_dir: Option<PathBuf> = None;

    let mut args = std::env::args().skip(1);
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
