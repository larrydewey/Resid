//! `resid-build` — package manifest parsing and build orchestration.
//!
//! A Resid package is a directory containing `resid.toml` (spec §28, §35):
//!
//! ```toml
//! [package]
//! name    = "example"
//! version = "0.1.0"
//! root    = "src/main.resid"   # optional, default src/main.resid
//!
//! [target]
//! triple = "x86_64-unknown-linux-gnu"  # optional, informational today
//! ```
//!
//! Profiles (spec §35): debug (default), release, check. `check` stops after
//! type checking; debug/release both emit a native binary (release passes
//! `-O2` to clang).

use std::fmt;
use std::path::{Path, PathBuf};

use serde::Deserialize;

/// Build profile (spec §35).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Profile {
    Debug,
    Release,
    Check,
}

impl Profile {
    pub fn parse(s: &str) -> Result<Profile, String> {
        match s {
            "debug" => Ok(Profile::Debug),
            "release" => Ok(Profile::Release),
            "check" => Ok(Profile::Check),
            other => Err(format!(
                "unknown profile `{other}` (expected debug | release | check)"
            )),
        }
    }

    pub fn as_str(&self) -> &'static str {
        match self {
            Profile::Debug => "debug",
            Profile::Release => "release",
            Profile::Check => "check",
        }
    }
}

impl fmt::Display for Profile {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(self.as_str())
    }
}

#[derive(Deserialize)]
struct ManifestToml {
    package: PackageToml,
    #[serde(default)]
    target: Option<TargetToml>,
    #[serde(default)]
    dependencies: std::collections::HashMap<String, DepToml>,
}

#[derive(Deserialize)]
struct DepToml {
    path: String,
    #[serde(default)]
    capabilities: Option<Vec<String>>,
}

#[derive(Deserialize)]
struct PackageToml {
    name: String,
    version: String,
    #[serde(default)]
    root: Option<String>,
}

#[derive(Deserialize)]
struct TargetToml {
    #[serde(default)]
    triple: Option<String>,
}

/// A path dependency declared in `[dependencies.<name>]` (spec §35).
#[derive(Debug, Clone)]
pub struct Dependency {
    pub name: String,
    /// Path relative to the depending package's directory.
    pub path: PathBuf,
    /// Declared capability requirements (parsed, not yet enforced).
    pub capabilities: Vec<String>,
}

/// A parsed `resid.toml`.
#[derive(Debug, Clone)]
pub struct Manifest {
    pub name: String,
    pub version: String,
    /// Crate root source file, resolved relative to the package directory.
    pub root: PathBuf,
    pub target_triple: Option<String>,
    /// Path dependencies in manifest order.
    pub dependencies: Vec<Dependency>,
    /// Directory containing resid.toml.
    pub dir: PathBuf,
}

#[derive(Debug)]
pub enum LoadError {
    Read(String, std::io::Error),
    Parse(String, toml::de::Error),
    /// Semantic problem with the manifest contents.
    Invalid(String),
}

impl fmt::Display for LoadError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            LoadError::Read(p, e) => write!(f, "cannot read '{p}': {e}"),
            LoadError::Parse(p, e) => write!(f, "invalid resid.toml at '{p}': {e}"),
            LoadError::Invalid(m) => write!(f, "invalid resid.toml: {m}"),
        }
    }
}

impl Manifest {
    /// Load and validate `resid.toml` from the given directory (or from the
    /// file itself if the path points at the manifest).
    pub fn load(dir: &Path) -> Result<Manifest, LoadError> {
        let manifest_path = if dir.is_file() {
            dir.to_path_buf()
        } else {
            dir.join("resid.toml")
        };
        let text = std::fs::read_to_string(&manifest_path).map_err(|e| {
            LoadError::Read(manifest_path.display().to_string(), e)
        })?;
        let raw: ManifestToml = toml::from_str(&text)
            .map_err(|e| LoadError::Parse(manifest_path.display().to_string(), e))?;
        if raw.package.name.trim().is_empty() {
            return Err(LoadError::Invalid(
                "[package] name must not be empty".into(),
            ));
        }
        if raw.package.version.trim().is_empty() {
            return Err(LoadError::Invalid(
                "[package] version must not be empty".into(),
            ));
        }
        let pkg_dir = manifest_path
            .parent()
            .map(|p| p.to_path_buf())
            .unwrap_or_else(|| PathBuf::from("."));
        let root_rel = raw
            .package
            .root
            .unwrap_or_else(|| "src/main.resid".to_string());
        let root = pkg_dir.join(&root_rel);
        if !root.is_file() {
            return Err(LoadError::Invalid(format!(
                "root source '{}' not found",
                root.display()
            )));
        }
        let mut dependencies = Vec::new();
        for (name, dep) in &raw.dependencies {
            let dep_dir = pkg_dir.join(&dep.path);
            // A dependency is a Resid package: its manifest tells us its root.
            let dep_manifest_path = dep_dir.join("resid.toml");
            let dep_text = std::fs::read_to_string(&dep_manifest_path).map_err(|e| {
                LoadError::Invalid(format!(
                    "dependency '{name}': cannot read '{}': {e}",
                    dep_manifest_path.display()
                ))
            })?;
            let dep_raw: ManifestToml = toml::from_str(&dep_text).map_err(|e| {
                LoadError::Invalid(format!(
                    "dependency '{name}': invalid resid.toml: {e}"
                ))
            })?;
            let dep_root_rel = dep_raw
                .package
                .root
                .unwrap_or_else(|| "src/main.resid".to_string());
            let dep_root = dep_dir.join(dep_root_rel);
            if !dep_root.is_file() {
                return Err(LoadError::Invalid(format!(
                    "dependency '{name}': root source '{}' not found",
                    dep_root.display()
                )));
            }
            dependencies.push(Dependency {
                name: name.clone(),
                path: dep_root.canonicalize().unwrap_or(dep_root),
                capabilities: dep.capabilities.clone().unwrap_or_default(),
            });
        }
        Ok(Manifest {
            name: raw.package.name,
            version: raw.package.version,
            root,
            target_triple: raw.target.and_then(|t| t.triple),
            dependencies,
            dir: pkg_dir,
        })
    }

    /// Dependency roots keyed by package name, for import resolution.
    pub fn dependency_map(&self) -> resid_parser::DependencyMap {
        self.dependencies
            .iter()
            .map(|d| (d.name.clone(), d.path.clone()))
            .collect()
    }

    /// Default output directory for build artifacts: `<dir>/target/resid`.
    pub fn out_dir(&self) -> PathBuf {
        self.dir.join("target").join("resid")
    }
}

#[derive(Debug)]
pub struct BuildError {
    pub message: String,
}

impl fmt::Display for BuildError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(&self.message)
    }
}

fn err<T>(msg: impl Into<String>) -> Result<T, BuildError> {
    Err(BuildError { message: msg.into() })
}

/// Outcome of a successful build.
#[derive(Debug)]
pub enum Artifact {
    /// Native binary path (debug / release profiles).
    Binary(PathBuf),
    /// Type checking passed; nothing emitted (check profile).
    Checked,
}

/// Build the package described by `manifest` under `profile`, writing
/// artifacts into `out_dir` (created if missing).
///
/// Pipeline per file: lex → parse → type check → LLVM IR → clang.
pub fn build(manifest: &Manifest, profile: Profile, out_dir: &Path) -> Result<Artifact, BuildError> {
    // Resolve imports + lex + parse.
    let unit = match resid_parser::resolve_unit_with(&manifest.root, &manifest.dependency_map()) {
        Ok(u) => u,
        Err(e) => return err(format!("{}", e)),
    };

    // Type check.
    let type_errors = resid_type::check_program(&unit);
    if !type_errors.is_empty() {
        let mut msg = format!("{} type error(s):\n", type_errors.len());
        for e in &type_errors {
            msg.push_str(&format!(
                "  {}:{}:{}: {}\n",
                e.span.file, e.span.line, e.span.col_start, e.message
            ));
        }
        return err(msg);
    }

    if profile == Profile::Check {
        return Ok(Artifact::Checked);
    }

    // Codegen.
    let cx = inkwell::context::Context::create();
    let mut cg = resid_codegen::CodeGen::new(&cx, &manifest.name);
    if let Err(e) = cg.generate(&unit) {
        return err(format!("codegen failed: {e}"));
    }
    if let Err(v) = cg.module.verify() {
        return err(format!("module failed verification:\n{v}"));
    }
    let ir = cg.module.print_to_string().to_string();

    // Write IR + runtime, then link.
    std::fs::create_dir_all(out_dir)
        .map_err(|e| BuildError { message: format!("cannot create '{}': {e}", out_dir.display()) })?;
    let stem = &manifest.name;
    let ir_path = out_dir.join(format!("{stem}.ll"));
    let rt_path = out_dir.join(format!("{stem}_rt.c"));
    std::fs::write(&ir_path, &ir)
        .map_err(|e| BuildError { message: format!("cannot write '{}': {e}", ir_path.display()) })?;
    std::fs::write(&rt_path, RUNTIME_C)
        .map_err(|e| BuildError { message: format!("cannot write '{}': {e}", rt_path.display()) })?;

    let bin = out_dir.join(stem);
    let mut cmd = std::process::Command::new("clang");
    cmd.arg(&ir_path).arg(&rt_path).arg("-Wno-override-module").arg("-pthread");
    if profile == Profile::Release {
        cmd.arg("-O2");
    }
    cmd.arg("-o").arg(&bin);
    let status = cmd
        .status()
        .map_err(|e| BuildError { message: format!("cannot run clang (is LLVM installed?): {e}") })?;
    if !status.success() {
        return err(format!("clang failed with {}", status.code().unwrap_or(-1)));
    }
    Ok(Artifact::Binary(bin))
}

/// The tiny bootstrap runtime linked into every native Resid binary.
const RUNTIME_C: &str = include_str!(concat!(env!("CARGO_MANIFEST_DIR"), "/../residc/resid_rt.c"));
