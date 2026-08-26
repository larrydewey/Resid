//! Multi-file translation units: resolve `import "file.resid"` declarations
//! (spec §29) by loading, parsing, and merging imported sources into a single
//! flat `TranslationUnit`.
//!
//! Semantics (v1):
//! - Paths are relative to the importing file's directory.
//! - Each file is parsed and included at most once per unit (diamond imports
//!   and cycles are deduplicated by canonical path).
//! - From an imported file, only exported declarations are visible: `pub`
//!   functions, plus type and behavior definitions. The root file contributes
//!   everything.
//! - `import "f.resid" (a, b)` keeps only the named declarations.
//! - `import "f.resid" as M` namespacing is not yet supported.
//! - Name conflicts between merged files surface as duplicate-definition
//!   errors from the type checker.

use std::collections::HashMap;
use std::collections::HashSet;
use std::path::{Path, PathBuf};

use crate::{Declaration, Id, ImportDecl, TranslationUnit};

/// Dependency roots available to a unit: package name → resolved root file.
/// An import whose path does not exist relative to the importer falls back
/// to this map (spec §35: `import "http"` picks up the `[dependencies.http]`
/// package).
pub type DependencyMap = HashMap<String, PathBuf>;

/// Error raised while resolving a unit's import tree.
#[derive(Debug)]
pub struct ImportError {
    pub message: String,
}

impl std::fmt::Display for ImportError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(&self.message)
    }
}

/// Parse `path` and merge its public import tree into one flat unit.
/// Imported declarations come first (dependencies before dependents),
/// then the root file's declarations in source order.
pub fn resolve_unit(path: &Path) -> Result<TranslationUnit, ImportError> {
    resolve_unit_with(path, &DependencyMap::new())
}

/// Like `resolve_unit`, with a package-name → root-file map for dependency
/// imports (spec §35).
pub fn resolve_unit_with(
    path: &Path,
    deps: &DependencyMap,
) -> Result<TranslationUnit, ImportError> {
    let path = path.canonicalize().map_err(|e| {
        ImportError { message: format!("cannot resolve '{}': {e}", path.display()) }
    })?;
    let mut visited = HashSet::new();
    let mut decls: Vec<Declaration> = Vec::new();
    let mut aliases = crate::alias::AliasMap::new();
    let imports: Vec<ImportDecl> = Vec::new();
    merge_file(&path, &mut visited, &mut decls, None, None, &mut aliases, deps)?;
    // Rewrite qualified references in the root's own declarations. Root decls
    // sit at the tail of `decls`; rewrite them in place.
    if !aliases.is_empty() {
        let split_at = decls.len() - root_own_count(&path, &mut HashSet::new(), deps)?;
        // Simpler and safe: recompute the root's own decl names to rewrite
        // only root-owned declarations below.
        for d in decls.iter_mut().skip(split_at) {
            rewrite_decl(d, &aliases);
        }
    }
    Ok(TranslationUnit { imports, declarations: decls })
}

/// Number of declarations owned by the root file itself.
fn root_own_count(
    path: &Path,
    _visited: &mut HashSet<PathBuf>,
    deps: &DependencyMap,
) -> Result<usize, ImportError> {
    let text = std::fs::read_to_string(path)
        .map_err(|e| ImportError { message: format!("cannot read '{}': {e}", path.display()) })?;
    let (unit, errors) = crate::Parser::parse(&path.display().to_string(), &text);
    let _ = deps;
    if !errors.is_empty() {
        return Ok(0);
    }
    Ok(unit.declarations.len())
}

/// Load `path` (if not seen), appending its visible declarations — its
/// imports' first (post-order), then its own — to `decls`. Returns the
/// unit's import list (used only for the root's metadata).
///
/// `alias` namespaces this file's OWN exports under `Alias.` when present:
/// their declaration names become `Alias.orig`, and the alias map records
/// the mapping so the importing file's `A.orig` references collapse.
fn load_into(
    path: &Path,
    visited: &mut HashSet<PathBuf>,
    decls: &mut Vec<Declaration>,
    select: Option<&[Id]>,
    alias: Option<&str>,
    aliases: &mut crate::alias::AliasMap,
    deps: &DependencyMap,
) -> Result<Vec<ImportDecl>, ImportError> {
    if !visited.insert(path.to_path_buf()) {
        return Ok(Vec::new());
    }
    let source = std::fs::read_to_string(path).map_err(|e| {
        ImportError { message: format!("cannot read '{}': {e}", path.display()) }
    })?;
    let display = path.display().to_string();
    let (unit, errors) = crate::Parser::parse(&display, &source);
    if !errors.is_empty() {
        let mut msg = String::new();
        for e in &errors {
            msg.push_str(&format!(
                "{}:{}:{}: {}\n",
                e.span.file, e.span.line, e.span.col_start, e.message
            ));
        }
        return Err(ImportError { message: msg });
    }

    // Recurse into imports first (post-order): dependencies before dependents.
    let base = path.parent().unwrap_or(Path::new("."));
    for imp in &unit.imports {
        let target = resolve_import(base, &imp.path, deps)?;
        load_into(
            &target,
            visited,
            decls,
            imp.names.as_deref(),
            imp.alias.as_ref().map(|a| a.0.as_str()),
            aliases,
            deps,
        )?;
    }

    // Collect this unit's visible declarations.
    let mut own: Vec<Declaration> = Vec::new();
    for d in unit.declarations {
        // Import-name selection still applies; visibility (spec §22) is
        // enforced at call sites via FunctionSig::is_pub/file so imported
        // `pub` bodies keep access to their own private helpers.
        if let Some(names) = select {
            let n = decl_name(&d);
            if !names.iter().any(|id| id.0 == n) {
                continue;
            }
        }
        own.push(d);
    }

    // Alias namespacing: prefix this file's own exports and record mappings.
    if let Some(a) = alias {
        for d in &mut own {
            let orig = decl_name(d).to_string();
            let qualified = format!("{a}.{orig}");
            set_decl_name(d, &qualified);
            aliases.add(a, &orig);
        }
    }
    decls.extend(own);
    Ok(unit.imports)
}

/// Merge a whole file tree into `decls` (convenience wrapper used by the
/// resolver entry point so the root's own decls can be identified).
fn merge_file(
    path: &Path,
    visited: &mut HashSet<PathBuf>,
    decls: &mut Vec<Declaration>,
    select: Option<&[Id]>,
    alias: Option<&str>,
    aliases: &mut crate::alias::AliasMap,
    deps: &DependencyMap,
) -> Result<(), ImportError> {
    load_into(path, visited, decls, select, alias, aliases, deps)?;
    Ok(())
}

fn rewrite_decl(d: &mut Declaration, am: &crate::alias::AliasMap) {
    if let Declaration::Function(f) = d {
        crate::alias::qualify_block(&mut f.body, am);
    }
}

fn set_decl_name(d: &mut Declaration, name: &str) {
    match d {
        Declaration::Function(f) => f.name = Id(name.to_string()),
        Declaration::Type(t) => t.name = Id(name.to_string()),
        Declaration::Behavior(b) => b.name = Id(name.to_string()),
    }
}

/// Where does an import point? A path relative to the importing file wins;
/// otherwise the import text may name a dependency package (spec §35), in
/// which case that package's root file is used.
fn resolve_import(
    base: &Path,
    import_path: &str,
    deps: &DependencyMap,
) -> Result<PathBuf, ImportError> {
    let relative = base.join(import_path);
    if relative.is_file() {
        return relative
            .canonicalize()
            .map_err(|e| ImportError { message: format!("cannot resolve '{}': {e}", relative.display()) });
    }
    if let Some(root) = deps.get(import_path) {
        return Ok(root.clone());
    }
    Err(ImportError {
        message: format!(
            "import '{}': no such file ('{}') and no dependency with that name",
            import_path,
            relative.display()
        ),
    })
}

fn decl_name(d: &Declaration) -> &str {
    match d {
        Declaration::Function(f) => &f.name.0,
        Declaration::Type(t) => &t.name.0,
        Declaration::Behavior(b) => &b.name.0,
    }
}
