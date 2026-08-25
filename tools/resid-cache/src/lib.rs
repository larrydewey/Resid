//! Knowledge cache (spec §21.4, §34, §35).
//!
//! Persists compile facts keyed by content hashes so later compilations can
//! skip work whose inputs are unchanged. Serialized as CBOR (RFC 8949) to
//! `<project>.resid-cache.cbor`.

use std::collections::HashMap;
use std::path::{Path, PathBuf};

use sha2::{Digest, Sha256};

/// Minimal CBOR encoder covering the subset the cache needs: unsigned
/// integers (major 0), byte strings (major 2), text strings (major 3),
/// arrays (major 4), and maps (major 5).
pub mod cbor {
    pub fn write_uint(out: &mut Vec<u8>, n: u64) {
        if n < 24 {
            out.push(n as u8);
        } else if n <= u64::from(u8::MAX) {
            out.extend_from_slice(&[24, n as u8]);
        } else if n <= u64::from(u16::MAX) {
            out.extend_from_slice(&[25]);
            out.extend_from_slice(&(n as u16).to_be_bytes());
        } else if n <= u64::from(u32::MAX) {
            out.extend_from_slice(&[26]);
            out.extend_from_slice(&(n as u32).to_be_bytes());
        } else {
            out.extend_from_slice(&[27]);
            out.extend_from_slice(&n.to_be_bytes());
        }
    }

    pub fn write_header(out: &mut Vec<u8>, major: u8, len: usize) {
        let m = major << 5;
        if len < 24 {
            out.push(m | len as u8);
        } else if len <= usize::from(u8::MAX) {
            out.extend_from_slice(&[m | 24, len as u8]);
        } else {
            out.extend_from_slice(&[m | 25]);
            out.extend_from_slice(&(len as u16).to_be_bytes());
        }
    }

    pub fn write_text(out: &mut Vec<u8>, s: &str) {
        write_header(out, 3, s.len());
        out.extend_from_slice(s.as_bytes());
    }

    pub fn write_bytes(out: &mut Vec<u8>, b: &[u8]) {
        write_header(out, 2, b.len());
        out.extend_from_slice(b);
    }

    pub fn write_map_header(out: &mut Vec<u8>, pairs: usize) {
        write_header(out, 5, pairs);
    }
}

/// One cached fact: `key` identifies the inputs, `value` names the artifact
/// produced from them.
#[derive(Debug, Clone, PartialEq)]
pub struct Entry {
    pub key: String,
    pub value: String,
}

static SELF_SEQ: std::sync::atomic::AtomicUsize = std::sync::atomic::AtomicUsize::new(0);

/// A content-addressed cache backed by a single CBOR file.
pub struct Store {
    path: PathBuf,
    entries: HashMap<String, String>,
}

impl Store {
    /// Open (or create) the cache at `path`. A missing or corrupt file is an
    /// empty cache — the cache is an accelerator, never authoritative.
    pub fn open(path: &Path) -> Store {
        let entries = std::fs::read(path)
            .ok()
            .and_then(|bytes| decode_map(&bytes))
            .unwrap_or_default();
        Store { path: path.to_path_buf(), entries }
    }

    pub fn get(&self, key: &str) -> Option<&str> {
        self.entries.get(key).map(String::as_str)
    }

    pub fn put(&mut self, key: impl Into<String>, value: impl Into<String>) {
        self.entries.insert(key.into(), value.into());
    }

    /// Persist to disk (atomically: unique temp file per writer, then
    /// rename). The temp name must be process-unique — a shared `.tmp`
    /// let two concurrent writers rename each other's half-written file,
    /// publishing torn caches that other processes then executed.
    pub fn flush(&self) -> std::io::Result<()> {
        let mut out = Vec::new();
        cbor::write_map_header(&mut out, self.entries.len());
        let mut keys: Vec<_> = self.entries.keys().collect();
        keys.sort();
        for k in keys {
            cbor::write_text(&mut out, k);
            cbor::write_text(&mut out, &self.entries[k]);
        }
        let tmp = self.path.with_extension(format!(
            "tmp.{}.{}",
            std::process::id(),
            SELF_SEQ.fetch_add(1, std::sync::atomic::Ordering::Relaxed)
        ));
        let res = std::fs::write(&tmp, &out).and_then(|_| {
            // fsync the temp so the rename never publishes unwritten pages
            std::fs::File::open(&tmp).and_then(|f| f.sync_all())
        });
        if let Err(e) = res {
            let _ = std::fs::remove_file(&tmp);
            return Err(e);
        }
        std::fs::rename(&tmp, &self.path)
    }

    pub fn len(&self) -> usize {
        self.entries.len()
    }

    pub fn is_empty(&self) -> bool {
        self.entries.is_empty()
    }
}

fn decode_map(bytes: &[u8]) -> Option<HashMap<String, String>> {
    let mut pos = 0usize;
    let first = *bytes.first()?;
    if first & 0xE0 != 0xA0 {
        return None;
    }
    let n = read_uint(bytes, &mut pos)?;
    let mut map = HashMap::new();
    for _ in 0..n {
        let k = read_text(bytes, &mut pos)?;
        let v = read_text(bytes, &mut pos)?;
        map.insert(k, v);
    }
    Some(map)
}

fn read_uint(bytes: &[u8], pos: &mut usize) -> Option<u64> {
    let b = *bytes.get(*pos)?;
    *pos += 1;
    match b & 0x1F {
        n @ 0..=23 => Some(n as u64),
        24 => Some(u64::from(*bytes.get(*pos)?)),
        25 => {
            let v = bytes.get(*pos..*pos + 2)?;
            *pos += 2;
            Some(u64::from(u16::from_be_bytes(v.try_into().ok()?)))
        }
        26 => {
            let v = bytes.get(*pos..*pos + 4)?;
            *pos += 4;
            Some(u64::from(u32::from_be_bytes(v.try_into().ok()?)))
        }
        27 => {
            let v = bytes.get(*pos..*pos + 8)?;
            *pos += 8;
            Some(u64::from_be_bytes(v.try_into().ok()?))
        }
        _ => None,
    }
}

fn read_text(bytes: &[u8], pos: &mut usize) -> Option<String> {
    let len = read_len(bytes, pos)? as usize;
    let v = bytes.get(*pos..*pos + len)?;
    *pos += len;
    String::from_utf8(v.to_vec()).ok()
}

fn read_len(bytes: &[u8], pos: &mut usize) -> Option<u64> {
    let b = *bytes.get(*pos)?;
    *pos += 1;
    match b & 0x1F {
        n @ 0..=23 => Some(n as u64),
        24 => {
            let l = u64::from(*bytes.get(*pos)?);
            *pos += 1;
            Some(l)
        }
        25 => {
            let v = bytes.get(*pos..*pos + 2)?;
            *pos += 2;
            Some(u64::from(u16::from_be_bytes(v.try_into().ok()?)))
        }
        _ => None,
    }
}

/// Content hash for cache keys: SHA-256 over the concatenated inputs.
pub fn hash_inputs(parts: &[&[u8]]) -> String {
    let mut hasher = Sha256::new();
    for p in parts {
        hasher.update((p.len() as u64).to_be_bytes());
        hasher.update(p);
    }
    format!("{:x}", hasher.finalize())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn roundtrip_store() {
        let dir = std::env::temp_dir().join(format!("resid-cache-{}", std::process::id()));
        let _ = std::fs::create_dir_all(&dir);
        let path = dir.join(".resid-cache.cbor");
        let mut st = Store::open(&path);
        assert!(st.is_empty());
        st.put("k1", "v1");
        st.put("k2", "v2");
        st.flush().unwrap();

        let st2 = Store::open(&path);
        assert_eq!(st2.len(), 2);
        assert_eq!(st2.get("k1"), Some("v1"));
        assert_eq!(st2.get("k2"), Some("v2"));
        assert_eq!(st2.get("nope"), None);
        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn corrupt_file_is_empty_cache() {
        let dir = std::env::temp_dir().join(format!("resid-cache-bad-{}", std::process::id()));
        let _ = std::fs::create_dir_all(&dir);
        let path = dir.join(".resid-cache.cbor");
        std::fs::write(&path, b"\xff not cbor").unwrap();
        let st = Store::open(&path);
        assert!(st.is_empty());
        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn hash_is_stable_and_sensitive() {
        let a = hash_inputs(&[b"hello"]);
        let b = hash_inputs(&[b"hello"]);
        let c = hash_inputs(&[b"hell", b"o"]);
        assert_eq!(a, b);
        assert_ne!(a, c);
    }
}

#[cfg(test)]
mod tests2 {
    use super::*;
    #[test]
    fn long_keys_roundtrip() {
        let k = "a".repeat(64);
        let v = "/tmp/residc-123/prog_bin";
        let mut out = Vec::new();
        cbor::write_map_header(&mut out, 1);
        cbor::write_text(&mut out, &k);
        cbor::write_text(&mut out, v);
        let m = decode_map(&out).expect("decode ok");
        assert_eq!(m.get(&k).map(|s| s.as_str()), Some(v));
    }
}
