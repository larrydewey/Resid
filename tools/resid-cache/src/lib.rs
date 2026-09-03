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
/// produced from them, and `caps` is the set of capability families (spec
/// §21.4) associated with producing/consuming that entry. A full read is
/// always allowed; a *write* is permitted only when `caps` ≤ the sandbox's
/// granted set.
#[derive(Debug, Clone, PartialEq)]
pub struct Entry {
    pub key: String,
    pub value: String,
    pub caps: Vec<String>,
}

/// Is every capability family in `required` also present in `grant`? Spec
/// §21.4: a sandbox may write a cache entry only when the capabilities
/// associated with it are ≤ the sandbox's granted set.
pub fn caps_are_at_most(grant: &[String], required: &[String]) -> bool {
    required.iter().all(|r| grant.iter().any(|g| g == r))
}

static SELF_SEQ: std::sync::atomic::AtomicUsize = std::sync::atomic::AtomicUsize::new(0);

/// Hit/miss counters accumulated by [`Store::get`].
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Stats {
    pub hits: u64,
    pub misses: u64,
}

/// A content-addressed cache backed by a single CBOR file.
///
/// Serialization format (matches the subset the hand-rolled [`cbor`] encoder
/// covers): a top-level CBOR map `key → {"v": value, "c": [cap, …]}`. Each
/// entry's capabilities travel with it so §21.4 write gating survives
/// persistence.
pub struct Store {
    path: PathBuf,
    entries: HashMap<String, Entry>,
    hits: std::sync::atomic::AtomicU64,
    misses: std::sync::atomic::AtomicU64,
}

impl Store {
    /// Open (or create) the cache at `path`. A missing or corrupt file is an
    /// empty cache — the cache is an accelerator, never authoritative. A file
    /// in the older flat `key → value` format is also accepted (capabilities
    /// default to empty), so existing caches remain readable.
    pub fn open(path: &Path) -> Store {
        let entries = std::fs::read(path)
            .ok()
            .and_then(|bytes| decode_map(&bytes))
            .unwrap_or_default();
        Store {
            path: path.to_path_buf(),
            entries,
            hits: std::sync::atomic::AtomicU64::new(0),
            misses: std::sync::atomic::AtomicU64::new(0),
        }
    }

    /// The cached artifact path for `key`, if present.
    pub fn get(&self, key: &str) -> Option<&str> {
        let hit = self.entries.get(key);
        if hit.is_some() {
            self.hits.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        } else {
            self.misses.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        }
        hit.map(|e| e.value.as_str())
    }

    /// The full entry (value + associated capabilities) for `key`, if present.
    pub fn get_entry(&self, key: &str) -> Option<&Entry> {
        self.entries.get(key)
    }

    /// Drop a key; returns the previously cached artifact path if present.
    pub fn remove(&mut self, key: &str) -> Option<String> {
        self.entries.remove(key).map(|e| e.value)
    }

    /// Keep only the entries for which `pred` returns true (e.g. prune
    /// entries whose artifact no longer exists).
    pub fn retain<F: FnMut(&str, &Entry) -> bool>(&mut self, mut pred: F) {
        self.entries.retain(|k, e| pred(k, e));
    }

    /// Hit/miss counts observed since this Store was opened.
    pub fn stats(&self) -> Stats {
        Stats {
            hits: self.hits.load(std::sync::atomic::Ordering::Relaxed),
            misses: self.misses.load(std::sync::atomic::Ordering::Relaxed),
        }
    }

    /// Insert an entry with no associated capabilities.
    pub fn put(&mut self, key: impl Into<String>, value: impl Into<String>) {
        self.put_with_caps(key, value, Vec::new());
    }

    /// Insert an entry carrying the capability families associated with it
    /// (spec §21.4). Callers gate the write with
    /// [`caps_are_at_most`] against their sandbox grant.
    pub fn put_with_caps(
        &mut self,
        key: impl Into<String>,
        value: impl Into<String>,
        caps: Vec<String>,
    ) {
        self.entries.insert(
            key.into(),
            Entry {
                key: String::new(),
                value: value.into(),
                caps,
            },
        );
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
            let e = &self.entries[k];
            cbor::write_text(&mut out, k);
            // Inner map: {"v": value, "c": [caps...]}
            let mut inner = Vec::new();
            cbor::write_map_header(&mut inner, 2);
            cbor::write_text(&mut inner, "v");
            cbor::write_text(&mut inner, &e.value);
            cbor::write_text(&mut inner, "c");
            cbor::write_header(&mut inner, 4, e.caps.len());
            for cap in &e.caps {
                cbor::write_text(&mut inner, cap);
            }
            out.extend_from_slice(&inner);
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

fn decode_map(bytes: &[u8]) -> Option<HashMap<String, Entry>> {
    let mut pos = 0usize;
    let first = *bytes.first()?;
    if first & 0xE0 != 0xA0 {
        return None;
    }
    let n = read_uint(bytes, &mut pos)?;
    let mut map = HashMap::new();
    for _ in 0..n {
        let k = read_text(bytes, &mut pos)?;
        let entry = decode_entry(&bytes, &mut pos)?;
        map.insert(k, entry);
    }
    Some(map)
}

/// Decode one entry value. Supports both the new map form `{"v", "c"}` and
/// the legacy flat-text form (value only, empty capabilities).
fn decode_entry(bytes: &[u8], pos: &mut usize) -> Option<Entry> {
    let b = *bytes.get(*pos)?;
    if b & 0xE0 == 0xA0 {
        // Inner map: a single header byte (small maps only, len < 24).
        *pos += 1;
        let len = (b & 0x1F) as usize;
        let mut value = None;
        let mut caps = Vec::new();
        for _ in 0..len {
            let key_t = read_text(bytes, pos)?;
            match key_t.as_str() {
                "v" => value = Some(read_text(bytes, pos)?),
                "c" => {
                    let n = read_len(bytes, pos)? as usize;
                    for _ in 0..n {
                        caps.push(read_text(bytes, pos)?);
                    }
                }
                _ => {
                    // Skip an unknown value of text type.
                    let _ = read_text(bytes, pos)?;
                }
            }
        }
        Some(Entry {
            key: String::new(),
            value: value?,
            caps,
        })
    } else {
        // Legacy flat text value (empty capabilities).
        Some(Entry {
            key: String::new(),
            value: read_text(bytes, pos)?,
            caps: Vec::new(),
        })
    }
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

    #[test]
    fn remove_drops_key() {
        let dir = std::env::temp_dir().join(format!("resid-cache-rm-{}", std::process::id()));
        let _ = std::fs::create_dir_all(&dir);
        let path = dir.join(".resid-cache.cbor");
        let mut st = Store::open(&path);
        st.put("gone", "v");
        assert_eq!(st.remove("gone").as_deref(), Some("v"));
        assert_eq!(st.remove("gone"), None);
        st.flush().unwrap();
        assert!(Store::open(&path).get("gone").is_none());
        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn retain_prunes_stale_artifacts() {
        let dir = std::env::temp_dir().join(format!("resid-cache-gc-{}", std::process::id()));
        let _ = std::fs::create_dir_all(&dir);
        let live = dir.join("live_bin");
        std::fs::write(&live, b"elf").unwrap();
        let path = dir.join(".resid-cache.cbor");
        let mut st = Store::open(&path);
        st.put("k-live", live.to_str().unwrap());
        st.put("k-stale", dir.join("missing_bin").to_str().unwrap());
        st.retain(|_, e| Path::new(&e.value).exists());
        assert_eq!(st.len(), 1);
        assert!(st.get("k-live").is_some());
        let _ = std::fs::remove_dir_all(&dir);
    }
    #[test]
    fn stats_count_hits_and_misses() {
        let dir = std::env::temp_dir().join(format!("resid-cache-st-{}", std::process::id()));
        let _ = std::fs::create_dir_all(&dir);
        let path = dir.join(".resid-cache.cbor");
        let mut st = Store::open(&path);
        st.put("k", "v");
        let _ = st.get("k");
        let _ = st.get("k");
        let _ = st.get("nope");
        let s = st.stats();
        assert_eq!((s.hits, s.misses), (2, 1));
        // Stats reset on reopen (they describe this process's session).
        assert_eq!((Store::open(&path).stats().hits, Store::open(&path).stats().misses), (0, 0));
        let _ = std::fs::remove_dir_all(&dir);
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
        assert_eq!(m.get(&k).map(|e| e.value.as_str()), Some(v));
    }

    #[test]
    fn caps_roundtrip_through_persistence() {
        let dir = std::env::temp_dir().join(format!("resid-cache-caps-{}", std::process::id()));
        let _ = std::fs::create_dir_all(&dir);
        let path = dir.join(".resid-cache.cbor");
        let mut st = Store::open(&path);
        st.put_with_caps("k1", "/tmp/x", vec!["filesystem".to_string(), "network".to_string()]);
        st.put("k2", "/tmp/y");
        st.flush().unwrap();

        let st2 = Store::open(&path);
        let e1 = st2.get_entry("k1").expect("k1 present");
        assert_eq!(e1.value, "/tmp/x");
        assert_eq!(e1.caps, vec!["filesystem".to_string(), "network".to_string()]);
        assert_eq!(st2.get_entry("k2").unwrap().caps.len(), 0);
        assert_eq!(st2.get("k1"), Some("/tmp/x"));
        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn caps_at_most_gates_the_write() {
        // §21.4: a sandbox may write only when entry caps ≤ granted set.
        assert!(caps_are_at_most(&["filesystem".into(), "network".into()], &["filesystem".into()]));
        assert!(caps_are_at_most(&["filesystem".into()], &[]));
        assert!(caps_are_at_most(&[], &[]));
        assert!(!caps_are_at_most(&["network".into()], &["filesystem".into()]));
        assert!(!caps_are_at_most(&["filesystem".into()], &["filesystem".into(), "network".into()]));
    }
}
