//! Dependency lockfiles (`resid.lock`, spec §28): pin every registry
//! dependency to the exact content hash of its archive so rebuilds are
//! reproducible and tampering is detected.

use std::path::Path;

/// One pinned dependency: `<name> <version> sha256:<hex>`.
#[derive(Debug, Clone, PartialEq)]
pub struct LockEntry {
    pub name: String,
    pub version: String,
    pub sha256: String,
}

#[derive(Debug, Clone, Default, PartialEq)]
pub struct LockFile {
    pub entries: Vec<LockEntry>,
}

impl LockFile {
    pub fn get(&self, name: &str) -> Option<&LockEntry> {
        self.entries.iter().find(|e| e.name == name)
    }

    pub fn set(&mut self, entry: LockEntry) {
        match self.entries.iter_mut().find(|e| e.name == entry.name) {
            Some(e) => *e = entry,
            None => self.entries.push(entry),
        }
        // Canonical order: by package name.
        self.entries.sort_by(|a, b| a.name.cmp(&b.name));
    }
}

/// Parse `resid.lock` text. Blank lines and `#` comments are skipped.
/// Malformed lines are an error (a lockfile is machine-written; hand edits
/// should fail loudly).
pub fn parse(text: &str) -> Result<LockFile, String> {
    let mut entries = Vec::new();
    for (idx, line) in text.lines().enumerate() {
        let line = line.trim();
        if line.is_empty() || line.starts_with('#') {
            continue;
        }
        let parts: Vec<&str> = line.split_whitespace().collect();
        if parts.len() != 3 || !parts[2].starts_with("sha256:") {
            return Err(format!("resid.lock line {}: expected '<name> <version> sha256:<hex>'", idx + 1));
        }
        entries.push(LockEntry {
            name: parts[0].to_string(),
            version: parts[1].to_string(),
            sha256: parts[2]["sha256:".len()..].to_string(),
        });
    }
    Ok(LockFile { entries })
}

pub fn to_text(lock: &LockFile) -> String {
    let mut out = String::from("# resid.lock — generated; dependency content hashes\n");
    for e in &lock.entries {
        out.push_str(&format!(
            "{} {} sha256:{}\n",
            e.name, e.version, e.sha256
        ));
    }
    out
}

pub fn read(path: &Path) -> Option<LockFile> {
    let text = std::fs::read_to_string(path).ok()?;
    parse(&text).ok()
}

pub fn write(path: &Path, lock: &LockFile) -> std::io::Result<()> {
    std::fs::write(path, to_text(lock))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn roundtrip() {
        let mut lf = LockFile::default();
        lf.set(LockEntry {
            name: "crypto".into(),
            version: "1.2.0".into(),
            sha256: "ab".repeat(32),
        });
        lf.set(LockEntry {
            name: "ed25519".into(),
            version: "0.9.0".into(),
            sha256: "cd".repeat(32),
        });
        let text = to_text(&lf);
        assert_eq!(parse(&text).unwrap(), lf);
    }

    #[test]
    fn canonical_ordering_and_get() {
        let mut lf = LockFile::default();
        lf.set(LockEntry { name: "b".into(), version: "1".into(), sha256: "x".into() });
        lf.set(LockEntry { name: "a".into(), version: "2".into(), sha256: "y".into() });
        assert_eq!(lf.entries[0].name, "a");
        assert_eq!(lf.get("b").unwrap().version, "1");
        assert!(lf.get("c").is_none());
    }

    #[test]
    fn malformed_line_rejected() {
        assert!(parse("pkg 1.0 nothex").is_err());
        assert!(parse("# comment\n\nok 1.0 sha256:ff\n").is_ok());
    }
}
