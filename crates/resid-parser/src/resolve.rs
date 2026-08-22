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

use std::collections::HashSet;
use std::path::{Path, PathBuf};

use crate::{Declaration, Id, ImportDecl, TranslationUnit};

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
    let path = path.canonicalize().map_err(|e| {
        ImportError { message: format!("cannot resolve '{}': {e}", path.display()) }
    })?;
    let mut visited = HashSet::new();
    let mut decls: Vec<Declaration> = Vec::new();
    let mut imports: Vec<ImportDecl> = Vec::new();
    let root_imports = load_into(&path, &mut visited, &mut decls, None, true)?;
    imports.extend(root_imports);
    Ok(TranslationUnit { imports, declarations: decls })
}

/// Load `path` (if not seen), appending its visible declarations to `decls`.
/// Returns the unit's import list (for the root's metadata).
fn load_into(
    path: &Path,
    visited: &mut HashSet<PathBuf>,
    decls: &mut Vec<Declaration>,
    select: Option<&[Id]>,
    is_root: bool,
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
        if imp.alias.is_some() {
            return Err(ImportError {
                message: format!(
                    "{}:{}:{}: import-as namespacing is not supported yet",
                    imp.span.file, imp.span.line, imp.span.col_start
                ),
            });
        }
        let target = base.join(&imp.path);
        load_into(&target, visited, decls, imp.names.as_deref(), false)?;
    }

    // Append this unit's visible declarations.
    for d in unit.declarations {
        // Non-root files only contribute exports (`pub` functions; types and
        // behaviors are always visible).
        if !is_root {
            let exported = match &d {
                Declaration::Function(f) => f.pub_,
                Declaration::Type(_) | Declaration::Behavior(_) => true,
            };
            if !exported {
                continue;
            }
        }
        if let Some(names) = select {
            let n = decl_name(&d);
            if !names.iter().any(|id| id.0 == n) {
                continue;
            }
        }
        decls.push(d);
    }
    Ok(unit.imports)
}

fn decl_name(d: &Declaration) -> &str {
    match d {
        Declaration::Function(f) => &f.name.0,
        Declaration::Type(t) => &t.name.0,
        Declaration::Behavior(b) => &b.name.0,
    }
}
