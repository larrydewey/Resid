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

pub mod archive;
pub mod provenance;
pub mod cose;

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
    capabilities: Option<CapabilitiesToml>,
    #[serde(default)]
    dependencies: std::collections::HashMap<String, DepToml>,
    #[serde(default)]
    signing: Option<SigningToml>,
    #[serde(default)]
    registry: Option<RegistryToml>,
}

#[derive(Deserialize)]
struct SigningToml {
    #[serde(default)]
    require_signatures: bool,
    /// Directory of trusted publisher public keys (hex files).
    #[serde(default)]
    keyring: Option<String>,
}

#[derive(Deserialize)]
struct CapabilitiesToml {
    #[serde(default)]
    grant: Vec<String>,
}

#[derive(Deserialize)]
struct DepToml {
    /// Path mode: directory of the dependency package.
    #[serde(default)]
    path: Option<String>,
    /// Registry mode: package version pulled from [registry] path.
    #[serde(default)]
    version: Option<String>,
    #[serde(default)]
    capabilities: Option<Vec<String>>,
}

#[derive(Deserialize)]
struct RegistryToml {
    /// Directory containing <name>-<version>.resid-pkg archives.
    path: String,
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
    pub manifest_path: String,
    /// Resolved root source of the dependency.
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
    /// Granted capability families (text before any `(...)` arguments),
    /// from `[capabilities] grant`.
    pub granted_capabilities: Vec<String>,
    /// Parsed grant expressions (family + optional scope globs).
    pub grants: Vec<Grant>,
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
        // Transitive resolution: walk each dependency's manifest recursively.
        // Cycles are cut by package name; a name claimed by two different
        // paths is an error. Direct deps come first, then their deps, etc.
        let mut dependencies: Vec<Dependency> = Vec::new();
        let mut seen: std::collections::HashMap<String, PathBuf> = std::collections::HashMap::new();
        let registry_dir = raw
            .registry
            .as_ref()
            .map(|r| pkg_dir.join(&r.path));
        for (name, dep) in &raw.dependencies {
            let dep_dir = resolve_dep_dir(name, dep, registry_dir.as_deref(), &pkg_dir)?;
            collect_dep(
                name,
                &dep_dir,
                dep.capabilities.clone().unwrap_or_default(),
                &mut dependencies,
                &mut seen,
                0,
                registry_dir.as_deref(),
                &pkg_dir,
            )?;
        }
        let grants: Vec<Grant> = raw
            .capabilities
            .map(|c| c.grant)
            .unwrap_or_default()
            .iter()
            .map(|g| parse_grant(g))
            .collect();
        let granted_capabilities: Vec<String> =
            grants.iter().map(|g| g.family.clone()).collect();
        for dep in &dependencies {
            for cap in &dep.capabilities {
                let family = cap_family(cap);
                if !granted_capabilities.contains(&family) {
                    return Err(LoadError::Invalid(format!(
                        "dependency '{}` requires capability `{}`, which is not granted under [capabilities] grant (granted: {})",
                        dep.name,
                        cap,
                        if granted_capabilities.is_empty() {
                            "none".to_string()
                        } else {
                            granted_capabilities.join(", ")
                        }
                    )));
                }
            }
        }
        // Signature policy: when required, every path dependency must ship a
        // signed archive verifying against a keyring key (spec §28.2).
        if let Some(signing) = &raw.signing {
            if signing.require_signatures {
                let keyring_dir = signing
                    .keyring
                    .as_ref()
                    .map(|k| pkg_dir.join(k))
                    .unwrap_or_else(|| pkg_dir.join("keys"));
                for dep in &dependencies {
                    let dep_src = PathBuf::from(&dep.manifest_path);
                    let pkg_file = dep_src.join(format!("{}.resid-pkg", dep.name));
                    let sig_file = dep_src.join(format!("{}.resid-sig", dep.name));
                    verify_dep_signature(dep, &pkg_file, &sig_file, &keyring_dir)?;
                }
            }
        }
        Ok(Manifest {
            name: raw.package.name,
            version: raw.package.version,
            root,
            target_triple: raw.target.and_then(|t| t.triple),
            dependencies,
            granted_capabilities,
            grants,
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

/// The capability family of a capability expression: the text before any
/// `(...)` arguments — `filesystem(scope=["x"])` → `filesystem`.
fn cap_family(cap: &str) -> String {
    match cap.find('(') {
        Some(i) => cap[..i].trim().to_string(),
        None => cap.trim().to_string(),
    }
}

/// A parsed capability grant: family plus optional scope globs.
#[derive(Debug, Clone)]
pub struct Grant {
    pub family: String,
    /// Scope patterns from `scope=["a/**", "b"]` when present.
    pub scopes: Vec<String>,
}

/// Recursively validate a dependency and its transitive dependencies.
/// `rel` is the depending package's view of the dependency directory;
/// `dep_dir` is the absolute path. Appends one Dependency per unique
/// package name, dependencies-before-dependents not guaranteed across
/// branches (import order handles that at the resolver level).
/// Where does a dependency live? Path mode wins; otherwise pull
/// `<name>-<version>.resid-pkg` from the registry into the build cache.
fn resolve_dep_dir(
    name: &str,
    dep: &DepToml,
    registry_dir: Option<&Path>,
    root_pkg_dir: &Path,
) -> Result<PathBuf, LoadError> {
    if let Some(ver) = &dep.version {
        let reg = registry_dir.ok_or_else(|| {
            LoadError::Invalid(format!(
                "dependency '{name}': version '{ver}' requested but no [registry] path is configured"
            ))
        })?;
        let pkg_file = reg.join(format!("{name}-{ver}.resid-pkg"));
        let archive_bytes = std::fs::read(&pkg_file).map_err(|e| {
            LoadError::Invalid(format!(
                "dependency '{name}': cannot read registry archive '{}': {e}",
                pkg_file.display()
            ))
        })?;
        let sha_file = reg.join(format!("{name}-{ver}.resid-sha256"));
        if let Ok(expect_hex) = std::fs::read_to_string(&sha_file) {
            let got =
                archive::hex_encode(&archive::content_hash(&archive_bytes));
            if got != expect_hex.trim() {
                return Err(LoadError::Invalid(format!(
                    "dependency '{name}': archive hash mismatch (expected {}, got {got})",
                    expect_hex.trim()
                )));
            }
        }
        let cache_dir = root_pkg_dir
            .join("target")
            .join("resid")
            .join("deps")
            .join(format!("{name}-{ver}"));
        if !cache_dir.exists() {
            archive::extract(&archive_bytes, &cache_dir).map_err(|e| {
                LoadError::Invalid(format!("dependency '{name}': extraction failed: {e}"))
            })?;
        }
        Ok(cache_dir)
    } else if let Some(p) = &dep.path {
        Ok(root_pkg_dir.join(p))
    } else {
        Err(LoadError::Invalid(format!(
            "dependency '{name}': needs either `path` or `version`"
        )))
    }
}

#[allow(clippy::too_many_arguments)]
fn collect_dep(
    name: &str,
    dep_dir: &Path,
    caps: Vec<String>,
    out: &mut Vec<Dependency>,
    seen: &mut std::collections::HashMap<String, PathBuf>,
    depth: usize,
    registry_dir: Option<&Path>,
    root_pkg_dir: &Path,
) -> Result<(), LoadError> {
    if depth > 32 {
        return Err(LoadError::Invalid(format!(
            "dependency '{name}': dependency chain deeper than 32 (cycle?)"
        )));
    }
    if let Some(prev) = seen.get(name) {
        let same = prev.canonicalize().ok() == dep_dir.canonicalize().ok();
        if !same {
            return Err(LoadError::Invalid(format!(
                "dependency name '{name}' claimed by both '{}' and '{}'",
                prev.display(),
                dep_dir.display()
            )));
        }
        return Ok(());
    }
    let manifest_path = dep_dir.join("resid.toml");
    let text = std::fs::read_to_string(&manifest_path).map_err(|e| {
        LoadError::Invalid(format!(
            "dependency '{name}': cannot read '{}': {e}",
            manifest_path.display()
        ))
    })?;
    let raw: ManifestToml = toml::from_str(&text).map_err(|e| {
        LoadError::Invalid(format!("dependency '{name}': invalid resid.toml: {e}"))
    })?;
    let root_rel = raw
        .package
        .root
        .unwrap_or_else(|| "src/main.resid".to_string());
    let root = dep_dir.join(root_rel);
    if !root.is_file() {
        return Err(LoadError::Invalid(format!(
            "dependency '{name}': root source '{}' not found",
            root.display()
        )));
    }
    // The package's self-declared name is its identity; the manifest key is
    // only an import alias.
    let pkg_name = raw.package.name.clone();
    let canonical_dir = dep_dir.canonicalize().unwrap_or_else(|_| dep_dir.to_path_buf());
    if let Some(prev) = seen.get(&pkg_name) {
        return Err(LoadError::Invalid(format!(
            "package '{pkg_name}' provided by both '{}' and '{}' — conflicting dependency versions are not supported",
            prev.display(),
            canonical_dir.display()
        )));
    }
    seen.insert(pkg_name.clone(), canonical_dir.clone());

    // Recurse into the dependency's own dependencies first: their roots are
    // needed when this dependency's sources import them by name.
    for (sub_name, sub) in &raw.dependencies {
        let sub_dir = resolve_dep_dir(sub_name, sub, registry_dir, dep_dir)?;
        collect_dep(
            sub_name,
            &sub_dir,
            sub.capabilities.clone().unwrap_or_default(),
            out,
            seen,
            depth + 1,
            registry_dir,
            root_pkg_dir,
        )?;
    }

    out.push(Dependency {
        name: pkg_name,
        // Absolute directory of this dependency package (used by signature
        // verification to locate <name>.resid-pkg).
        manifest_path: dep_dir.display().to_string(),
        path: root.canonicalize().unwrap_or_else(|_| root.clone()),
        capabilities: caps,
    });
    Ok(())
}

fn verify_dep_signature(
    dep: &Dependency,
    pkg_file: &Path,
    sig_file: &Path,
    keyring_dir: &Path,
) -> Result<(), LoadError> {
    let archive = std::fs::read(pkg_file).map_err(|e| {
        LoadError::Invalid(format!(
            "dependency '{}': signed archive '{}' missing or unreadable: {e}",
            dep.name,
            pkg_file.display()
        ))
    })?;
    let hash = archive::content_hash(&archive);
    let sig_hex = std::fs::read_to_string(sig_file)
        .map_err(|e| {
            LoadError::Invalid(format!(
                "dependency '{}': signature file '{}' missing: {e}",
                dep.name,
                sig_file.display()
            ))
        })?
        .trim()
        .to_string();
    let entries = std::fs::read_dir(keyring_dir).map_err(|e| {
        LoadError::Invalid(format!(
            "dependency '{}': cannot read keyring '{}': {e}",
            dep.name,
            keyring_dir.display()
        ))
    })?;
    for entry in entries.flatten() {
        let p = entry.path();
        if p.extension().map(|e| e == "hex").unwrap_or(false) {
            if let Ok(pub_hex) = std::fs::read_to_string(&p) {
                if archive::verify_sig(&hash, &sig_hex, pub_hex.trim()).unwrap_or(false) {
                    return Ok(());
                }
            }
        }
    }
    Err(LoadError::Invalid(format!(
        "dependency '{}': signature does not verify against any key in '{}'",
        dep.name,
        keyring_dir.display()
    )))
}

/// Parse a grant expression like `filesystem(scope=["config/**"])` or a bare
/// `git(readonly)`. Bare (unscoped) grants return empty scopes, meaning
/// "all uses of this family".
fn parse_grant(cap: &str) -> Grant {
    let family = cap_family(cap);
    let open = cap.find('(');
    let close = cap.rfind(')');
    let scopes = match (open, close) {
        (Some(o), Some(c)) if c > o => {
            let inner = &cap[o + 1..c];
            // Extract every quoted string inside the parens; only `scope=…`
            // grants carry paths. A grant with non-scope args (readonly) is
            // treated as unscoped for that family.
            let strings: Vec<String> = split_quoted(inner);
            if inner.trim_start().starts_with("scope") && !strings.is_empty() {
                strings
            } else {
                Vec::new()
            }
        }
        _ => Vec::new(),
    };
    Grant { family, scopes }
}

/// Split out the double-quoted string literals of an argument list.
fn split_quoted(s: &str) -> Vec<String> {
    let mut out = Vec::new();
    let mut cur = String::new();
    let mut in_str = false;
    let mut esc = false;
    for c in s.chars() {
        if in_str {
            if esc {
                cur.push(c);
                esc = false;
            } else if c == '\\' {
                esc = true;
            } else if c == '"' {
                in_str = false;
                out.push(std::mem::take(&mut cur));
            } else {
                cur.push(c);
            }
        } else if c == '"' {
            in_str = true;
        }
    }
    out
}

/// Glob match supporting `**` (any path segment run), `*` (within one
/// segment) and `?` (single char). `/` never matches `*`.
fn glob_match(pattern: &str, path: &str) -> bool {
    glob_inner(pattern.as_bytes(), path.as_bytes())
}

fn glob_inner(p: &[u8], s: &[u8]) -> bool {
    if p.is_empty() {
        return s.is_empty();
    }
    match p[0] {
        b'*' if p.len() > 1 && p[1] == b'*' => {
            // `**` matches everything including `/`; also swallow a
            // following '/' so `a/**` matches `a/b` but not `ab`.
            let rest = if p.len() > 2 && p[2] == b'/' { &p[3..] } else { &p[2..] };
            for i in 0..=s.len() {
                if glob_inner(rest, &s[i..]) {
                    return true;
                }
            }
            false
        }
        b'*' => {
            for i in 0..=s.len() {
                // `*` must not cross a path separator.
                if s[..i].contains(&b'/') {
                    break;
                }
                if glob_inner(&p[1..], &s[i..]) {
                    return true;
                }
            }
            false
        }
        b'?' => !s.is_empty() && s[0] != b'/' && glob_inner(&p[1..], &s[1..]),
        c => !s.is_empty() && s[0] == c && glob_inner(&p[1..], &s[1..]),
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

    // Capability policy: every provider family a program touches must be
    // granted under [capabilities] grant (spec §28.2 step 4). `args` is
    // exempt — reading the program's own argv is not a resource capability.
    const EXEMPT_PROVIDERS: &[&str] = &["args"];
    let uses = resid_parser::collect_provider_calls(&unit);
    let mut violations: Vec<String> = Vec::new();
    for u in &uses {
        if EXEMPT_PROVIDERS.contains(&u.provider.as_str()) {
            continue;
        }
        // Grants for this family; a family absent entirely is a hard denial.
        let family_grants: Vec<&Grant> = manifest
            .grants
            .iter()
            .filter(|g| g.family == u.provider)
            .collect();
        if family_grants.is_empty() {
            violations.push(format!(
                "  {}:{}:{}: {}.{}() requires capability `{}`, which is not granted",
                u.span.file, u.span.line, u.span.col_start, u.provider, u.verb, u.provider
            ));
            continue;
        }
        // Scope narrowing applies to path-like first arguments (filesystem).
        let scoped: Vec<&&Grant> = family_grants.iter().filter(|g| !g.scopes.is_empty()).collect();
        if u.provider == "filesystem" && !scoped.is_empty() {
            // An unscoped grant for the same family overrides scope checks.
            let has_unscoped = family_grants.iter().any(|g| g.scopes.is_empty());
            if !has_unscoped {
                if let Some(path) = &u.first_str_arg {
                    let ok = scoped.iter().any(|g| {
                        g.scopes.iter().any(|pat| glob_match(pat, path))
                    });
                    if !ok {
                        let pats: Vec<String> = scoped
                            .iter()
                            .flat_map(|g| g.scopes.iter().cloned())
                            .collect();
                        violations.push(format!(
                            "  {}:{}:{}: {}.{}(\"{}\") is outside the granted scopes ({})",
                            u.span.file,
                            u.span.line,
                            u.span.col_start,
                            u.provider,
                            u.verb,
                            path,
                            pats.join(", ")
                        ));
                        continue;
                    }
                } else {
                    violations.push(format!(
                        "  {}:{}:{}: {}.{}() uses a dynamic path; a scoped filesystem grant only covers string-literal paths",
                        u.span.file, u.span.line, u.span.col_start, u.provider, u.verb
                    ));
                    continue;
                }
            }
        }
    }
    if !violations.is_empty() {
        return err(format!(
            "capability policy violations ({} call(s) not granted under [capabilities] grant):\n{}\n",
            violations.len(),
            violations.join("\n")
        ));
    }

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
