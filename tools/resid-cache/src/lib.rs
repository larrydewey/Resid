//! Knowledge cache (spec §21.4, §34, §35).
//!
//! Persists compile facts keyed by content hashes so later compilations can
//! skip work whose inputs are unchanged. Serialized as CBOR (RFC 8949) to
//! `<project>.resid-cache.cbor`.
//!
//! Two cache modes:
//!   - Binary artifact cache: whole-program binary paths (existing `Store`)
//!   - Knowledge cache: expression-level reduction results (new `KnowledgeStore`)

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

/// A compile-time-known value (matches `resid_type::reduce::CValue`).
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum KnowledgeValue {
    Int(i128),
    Bool(bool),
    Str(String),
}

/// Knowledge cache entry kind.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u8)]
pub enum KnowledgeKind {
    ReducedExpr = 0,
    ProviderResult = 1,
    TypeInfo = 2,
    ConstraintProof = 3,
    BehaviorResolution = 4,
}

impl KnowledgeKind {
    fn from_u8(n: u8) -> Option<Self> {
        match n {
            0 => Some(KnowledgeKind::ReducedExpr),
            1 => Some(KnowledgeKind::ProviderResult),
            2 => Some(KnowledgeKind::TypeInfo),
            3 => Some(KnowledgeKind::ConstraintProof),
            4 => Some(KnowledgeKind::BehaviorResolution),
            _ => None,
        }
    }
}

/// One knowledge cache entry.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct KnowledgeEntry {
    pub kind: KnowledgeKind,
    pub expr_hash: String,
    pub env_hash: String,
    pub value: KnowledgeValue,
    pub caps: Vec<String>,
}

/// Knowledge cache: content-addressed store for reduction results.
///
/// Key = hash(expr_hash + env_hash + kind). Value = KnowledgeEntry.
/// Separate from binary artifact cache to allow fine-grained invalidation.
pub struct KnowledgeStore {
    path: PathBuf,
    entries: HashMap<String, KnowledgeEntry>,
    hits: std::sync::atomic::AtomicU64,
    misses: std::sync::atomic::AtomicU64,
}

impl KnowledgeStore {
    /// Open (or create) the knowledge cache at `path`.
    pub fn open(path: &Path) -> KnowledgeStore {
        let entries = std::fs::read(path)
            .ok()
            .and_then(|bytes| decode_knowledge_map(&bytes))
            .unwrap_or_default();
        KnowledgeStore {
            path: path.to_path_buf(),
            entries,
            hits: std::sync::atomic::AtomicU64::new(0),
            misses: std::sync::atomic::AtomicU64::new(0),
        }
    }

    /// Look up a knowledge entry by expression hash, environment hash, and kind.
    pub fn get(&self, expr_hash: &str, env_hash: &str, kind: KnowledgeKind) -> Option<&KnowledgeValue> {
        let key = Self::make_key(expr_hash, env_hash, kind);
        let hit = self.entries.get(&key);
        if hit.is_some() {
            self.hits.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        } else {
            self.misses.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        }
        hit.map(|e| &e.value)
    }

    /// Insert a knowledge entry.
    pub fn put(&mut self, expr_hash: String, env_hash: String, kind: KnowledgeKind, value: KnowledgeValue, caps: Vec<String>) {
        let key = Self::make_key(&expr_hash, &env_hash, kind);
        self.entries.insert(key, KnowledgeEntry {
            kind,
            expr_hash,
            env_hash,
            value,
            caps,
        });
    }

    /// Remove an entry.
    pub fn remove(&mut self, expr_hash: &str, env_hash: &str, kind: KnowledgeKind) -> Option<KnowledgeValue> {
        let key = Self::make_key(expr_hash, env_hash, kind);
        self.entries.remove(&key).map(|e| e.value)
    }

    /// Persist to disk.
    pub fn flush(&self) -> std::io::Result<()> {
        let mut out = Vec::new();
        cbor::write_map_header(&mut out, self.entries.len());
        let mut keys: Vec<_> = self.entries.keys().collect();
        keys.sort();
        for k in keys {
            let e = &self.entries[k];
            cbor::write_text(&mut out, k);
            // Inner map: {"k": kind, "e": expr_hash, "n": env_hash, "v": value, "c": [caps...]}
            let mut inner = Vec::new();
            cbor::write_map_header(&mut inner, 5);
            cbor::write_text(&mut inner, "k");
            cbor::write_uint(&mut inner, e.kind as u64);
            cbor::write_text(&mut inner, "e");
            cbor::write_text(&mut inner, &e.expr_hash);
            cbor::write_text(&mut inner, "n");
            cbor::write_text(&mut inner, &e.env_hash);
            cbor::write_text(&mut inner, "v");
            Self::encode_value(&mut inner, &e.value);
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
            std::fs::File::open(&tmp).and_then(|f| f.sync_all())
        });
        if let Err(e) = res {
            let _ = std::fs::remove_file(&tmp);
            return Err(e);
        }
        std::fs::rename(&tmp, &self.path)
    }

    fn make_key(expr_hash: &str, env_hash: &str, kind: KnowledgeKind) -> String {
        format!("{}:{}:{}", kind as u8, expr_hash, env_hash)
    }

    fn encode_value(out: &mut Vec<u8>, v: &KnowledgeValue) {
        match v {
            KnowledgeValue::Int(i) => {
                let val = *i;
                if val >= 0 && val <= u64::MAX as i128 {
                    // Fits in u64: standard major 0
                    cbor::write_uint(out, val as u64);
                } else if val < 0 && val >= i64::MIN as i128 {
                    // Fits in i64: standard major 1
                    let n = (-1 - val) as u64;
                    if n < 24 {
                        out.push(0x20 | n as u8);
                    } else if n <= u64::from(u8::MAX) {
                        out.extend_from_slice(&[0x38, n as u8]);
                    } else if n <= u64::from(u16::MAX) {
                        out.extend_from_slice(&[0x39]);
                        out.extend_from_slice(&(n as u16).to_be_bytes());
                    } else if n <= u64::from(u32::MAX) {
                        out.extend_from_slice(&[0x3A]);
                        out.extend_from_slice(&(n as u32).to_be_bytes());
                    } else {
                        out.extend_from_slice(&[0x3B]);
                        out.extend_from_slice(&n.to_be_bytes());
                    }
                } else if val > u64::MAX as i128 {
                    // Positive bignum: tag 2 + byte string
                    out.push(0xC2); // tag 2
                    let mut bytes = Vec::new();
                    let mut v = val as u128;
                    while v > 0 {
                        bytes.push((v & 0xFF) as u8);
                        v >>= 8;
                    }
                    bytes.reverse();
                    if bytes.len() < 24 {
                        out.push(0x40 | bytes.len() as u8);
                    } else if bytes.len() <= u8::MAX as usize {
                        out.extend_from_slice(&[0x58, bytes.len() as u8]);
                    } else {
                        out.extend_from_slice(&[0x59]);
                        out.extend_from_slice(&(bytes.len() as u16).to_be_bytes());
                    }
                    out.extend_from_slice(&bytes);
                } else {
                    // Negative bignum: tag 3 + byte string (absolute value)
                    out.push(0xC3); // tag 3
                    let mut bytes = Vec::new();
                    let mut v = (-1 - val) as u128;
                    while v > 0 {
                        bytes.push((v & 0xFF) as u8);
                        v >>= 8;
                    }
                    bytes.reverse();
                    if bytes.len() < 24 {
                        out.push(0x40 | bytes.len() as u8);
                    } else if bytes.len() <= u8::MAX as usize {
                        out.extend_from_slice(&[0x58, bytes.len() as u8]);
                    } else {
                        out.extend_from_slice(&[0x59]);
                        out.extend_from_slice(&(bytes.len() as u16).to_be_bytes());
                    }
                    out.extend_from_slice(&bytes);
                }
            }
            KnowledgeValue::Bool(b) => {
                out.push(if *b { 0xF5 } else { 0xF4 });
            }
            KnowledgeValue::Str(s) => {
                cbor::write_text(out, s);
            }
        }
    }

    pub fn len(&self) -> usize {
        self.entries.len()
    }

    pub fn is_empty(&self) -> bool {
        self.entries.is_empty()
    }

    pub fn stats(&self) -> Stats {
        Stats {
            hits: self.hits.load(std::sync::atomic::Ordering::Relaxed),
            misses: self.misses.load(std::sync::atomic::Ordering::Relaxed),
        }
    }
}

fn decode_knowledge_map(bytes: &[u8]) -> Option<HashMap<String, KnowledgeEntry>> {
    let mut pos = 0usize;
    let first = *bytes.first()?;
    if first & 0xE0 != 0xA0 {
        return None;
    }
    let n = read_uint(bytes, &mut pos)?;
    let mut map = HashMap::new();
    for _ in 0..n {
        let k = read_text(bytes, &mut pos)?;
        let entry = decode_knowledge_entry(bytes, &mut pos)?;
        map.insert(k, entry);
    }
    Some(map)
}

fn decode_knowledge_entry(bytes: &[u8], pos: &mut usize) -> Option<KnowledgeEntry> {
    let b = *bytes.get(*pos)?;
    if b & 0xE0 != 0xA0 {
        return None;
    }
    *pos += 1;
    let len = (b & 0x1F) as usize;
    let mut kind = None;
    let mut expr_hash = None;
    let mut env_hash = None;
    let mut value = None;
    let mut caps = Vec::new();
    for _ in 0..len {
        let key_t = read_text(bytes, pos)?;
        match key_t.as_str() {
            "k" => {
                let n = read_uint(bytes, pos)? as u8;
                kind = KnowledgeKind::from_u8(n);
            }
            "e" => expr_hash = Some(read_text(bytes, pos)?),
            "n" => env_hash = Some(read_text(bytes, pos)?),
            "v" => value = Some(decode_value(bytes, pos)?),
            "c" => {
                let n = read_len(bytes, pos)? as usize;
                for _ in 0..n {
                    caps.push(read_text(bytes, pos)?);
                }
            }
            _ => {
                let _ = read_text(bytes, pos)?;
            }
        }
    }
    Some(KnowledgeEntry {
        kind: kind?,
        expr_hash: expr_hash?,
        env_hash: env_hash?,
        value: value?,
        caps,
    })
}

fn decode_value(bytes: &[u8], pos: &mut usize) -> Option<KnowledgeValue> {
    let b = *bytes.get(*pos)?;
    *pos += 1;
    let major = b >> 5;
    let minor = b & 0x1F;
    match major {
        0 => {
            // Unsigned int (major 0)
            let n = decode_uint_from_minor(bytes, pos, minor)?;
            Some(KnowledgeValue::Int(n as i128))
        }
        1 => {
            // Negative int (major 1)
            let n = decode_uint_from_minor(bytes, pos, minor)?;
            Some(KnowledgeValue::Int(-1 - n as i128))
        }
        3 => {
            // Text string (major 3)
            let len = decode_len_from_minor(bytes, pos, minor)?;
            let v = String::from_utf8(bytes.get(*pos..*pos + len)?.to_vec()).ok()?;
            *pos += len;
            Some(KnowledgeValue::Str(v))
        }
        6 => {
            // Tag (major 6): check for tag 2 (positive bignum) or 3 (negative bignum)
            if minor == 2 {
                // Tag 2: positive bignum - next should be byte string (major 2)
                let tag_byte = *bytes.get(*pos)?;
                *pos += 1;
                if tag_byte >> 5 != 2 {
                    return None; // Not a byte string
                }
                let len = decode_len_from_minor(bytes, pos, tag_byte & 0x1F)?;
                let data = bytes.get(*pos..*pos + len)?;
                *pos += len;
                // Decode big-endian bytes to u128
                let mut val: u128 = 0;
                for &byte in data {
                    val = (val << 8) | byte as u128;
                }
                Some(KnowledgeValue::Int(val as i128))
            } else if minor == 3 {
                // Tag 3: negative bignum - next should be byte string (major 2)
                let tag_byte = *bytes.get(*pos)?;
                *pos += 1;
                if tag_byte >> 5 != 2 {
                    return None;
                }
                let len = decode_len_from_minor(bytes, pos, tag_byte & 0x1F)?;
                let data = bytes.get(*pos..*pos + len)?;
                *pos += len;
                let mut val: u128 = 0;
                for &byte in data {
                    val = (val << 8) | byte as u128;
                }
                Some(KnowledgeValue::Int(-1 - val as i128))
            } else {
                None // Unknown tag
            }
        }
        7 => {
            // Simple values: false=20 (0xF4), true=21 (0xF5)
            if minor == 20 {
                Some(KnowledgeValue::Bool(false))
            } else if minor == 21 {
                Some(KnowledgeValue::Bool(true))
            } else {
                None
            }
        }
        _ => None,
    }
}

fn decode_uint_from_minor(bytes: &[u8], pos: &mut usize, minor: u8) -> Option<u64> {
    match minor {
        n @ 0..=23 => Some(n as u64),
        24 => {
            let v = *bytes.get(*pos)?;
            *pos += 1;
            Some(u64::from(v))
        }
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

fn decode_len_from_minor(bytes: &[u8], pos: &mut usize, minor: u8) -> Option<usize> {
    match minor {
        n @ 0..=23 => Some(n as usize),
        24 => Some(*bytes.get(*pos)? as usize),
        25 => {
            let v = bytes.get(*pos..*pos + 2)?;
            *pos += 2;
            Some(u16::from_be_bytes(v.try_into().ok()?) as usize)
        }
        26 => {
            let v = bytes.get(*pos..*pos + 4)?;
            *pos += 4;
            Some(u32::from_be_bytes(v.try_into().ok()?) as usize)
        }
        27 => {
            let v = bytes.get(*pos..*pos + 8)?;
            *pos += 8;
            Some(u64::from_be_bytes(v.try_into().ok()?) as usize)
        }
        _ => None,
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
        let entry = decode_entry(bytes, &mut pos)?;
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

#[cfg(test)]
mod knowledge_tests {
    use super::*;

    fn temp_path(suffix: &str) -> std::path::PathBuf {
        std::env::temp_dir().join(format!("resid-knowledge-{}-{}", std::process::id(), suffix))
    }

    #[test]
    fn knowledge_store_roundtrip() {
        let dir = temp_path("roundtrip");
        let _ = std::fs::create_dir_all(&dir);
        let path = dir.join(".resid-knowledge.cbor");
        let mut st = KnowledgeStore::open(&path);
        assert!(st.is_empty());

        let expr_hash = "abc123";
        let env_hash = "env456";
        st.put(expr_hash.into(), env_hash.into(), KnowledgeKind::ReducedExpr, KnowledgeValue::Int(42), vec!["filesystem".into()]);
        st.put(expr_hash.into(), env_hash.into(), KnowledgeKind::TypeInfo, KnowledgeValue::Str("Int(64)".into()), vec![]);
        st.flush().unwrap();

        let st2 = KnowledgeStore::open(&path);
        assert_eq!(st2.len(), 2);
        assert_eq!(st2.get(expr_hash, env_hash, KnowledgeKind::ReducedExpr), Some(&KnowledgeValue::Int(42)));
        assert_eq!(st2.get(expr_hash, env_hash, KnowledgeKind::TypeInfo), Some(&KnowledgeValue::Str("Int(64)".into())));
        assert_eq!(st2.get("none", "none", KnowledgeKind::ReducedExpr), None);
        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn knowledge_store_different_kinds_same_hash() {
        let dir = temp_path("kinds");
        let _ = std::fs::create_dir_all(&dir);
        let path = dir.join(".resid-knowledge.cbor");
        let mut st = KnowledgeStore::open(&path);

        let expr_hash = "same_hash";
        let env_hash = "same_env";
        st.put(expr_hash.into(), env_hash.into(), KnowledgeKind::ReducedExpr, KnowledgeValue::Int(1), vec![]);
        st.put(expr_hash.into(), env_hash.into(), KnowledgeKind::ProviderResult, KnowledgeValue::Str("result".into()), vec!["network".into()]);
        st.flush().unwrap();

        let st2 = KnowledgeStore::open(&path);
        assert_eq!(st2.len(), 2);
        assert_eq!(st2.get(expr_hash, env_hash, KnowledgeKind::ReducedExpr), Some(&KnowledgeValue::Int(1)));
        assert_eq!(st2.get(expr_hash, env_hash, KnowledgeKind::ProviderResult), Some(&KnowledgeValue::Str("result".into())));
        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn knowledge_store_bool_and_str_values() {
        let dir = temp_path("boolstr");
        let _ = std::fs::create_dir_all(&dir);
        let path = dir.join(".resid-knowledge.cbor");
        let mut st = KnowledgeStore::open(&path);

        st.put("e1".into(), "env1".into(), KnowledgeKind::ReducedExpr, KnowledgeValue::Bool(true), vec![]);
        st.put("e2".into(), "env2".into(), KnowledgeKind::ReducedExpr, KnowledgeValue::Bool(false), vec![]);
        st.put("e3".into(), "env3".into(), KnowledgeKind::ReducedExpr, KnowledgeValue::Str("hello world".into()), vec![]);
        st.flush().unwrap();

        let st2 = KnowledgeStore::open(&path);
        assert_eq!(st2.get("e1", "env1", KnowledgeKind::ReducedExpr), Some(&KnowledgeValue::Bool(true)));
        assert_eq!(st2.get("e2", "env2", KnowledgeKind::ReducedExpr), Some(&KnowledgeValue::Bool(false)));
        assert_eq!(st2.get("e3", "env3", KnowledgeKind::ReducedExpr), Some(&KnowledgeValue::Str("hello world".into())));
        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn knowledge_store_remove() {
        let dir = temp_path("remove");
        let _ = std::fs::create_dir_all(&dir);
        let path = dir.join(".resid-knowledge.cbor");
        let mut st = KnowledgeStore::open(&path);

        st.put("e1".into(), "env1".into(), KnowledgeKind::ReducedExpr, KnowledgeValue::Int(99), vec![]);
        st.flush().unwrap();

        let mut st2 = KnowledgeStore::open(&path);
        assert_eq!(st2.remove("e1", "env1", KnowledgeKind::ReducedExpr), Some(KnowledgeValue::Int(99)));
        assert_eq!(st2.remove("e1", "env1", KnowledgeKind::ReducedExpr), None);
        st2.flush().unwrap();

        assert!(KnowledgeStore::open(&path).get("e1", "env1", KnowledgeKind::ReducedExpr).is_none());
        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn knowledge_store_caps_roundtrip() {
        let dir = temp_path("caps");
        let _ = std::fs::create_dir_all(&dir);
        let path = dir.join(".resid-knowledge.cbor");
        let mut st = KnowledgeStore::open(&path);

        st.put("e1".into(), "env1".into(), KnowledgeKind::ReducedExpr, KnowledgeValue::Int(1), vec!["filesystem".to_string(), "network".to_string()]);
        st.flush().unwrap();

        let st2 = KnowledgeStore::open(&path);
        let entry = st2.entries.get("0:e1:env1").expect("entry present");
        assert_eq!(entry.caps, vec!["filesystem".to_string(), "network".to_string()]);
        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn knowledge_store_negative_int() {
        let dir = temp_path("neg");
        let _ = std::fs::create_dir_all(&dir);
        let path = dir.join(".resid-knowledge.cbor");
        let mut st = KnowledgeStore::open(&path);

        st.put("e1".into(), "env1".into(), KnowledgeKind::ReducedExpr, KnowledgeValue::Int(-42), vec![]);
        st.flush().unwrap();

        let st2 = KnowledgeStore::open(&path);
        assert_eq!(st2.get("e1", "env1", KnowledgeKind::ReducedExpr), Some(&KnowledgeValue::Int(-42)));
        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn knowledge_store_large_int() {
        let dir = temp_path("large");
        let _ = std::fs::create_dir_all(&dir);
        let path = dir.join(".resid-knowledge.cbor");
        let mut st = KnowledgeStore::open(&path);

        st.put("e1".into(), "env1".into(), KnowledgeKind::ReducedExpr, KnowledgeValue::Int(2_i128.pow(100)), vec![]);
        st.flush().unwrap();

        let st2 = KnowledgeStore::open(&path);
        assert_eq!(st2.get("e1", "env1", KnowledgeKind::ReducedExpr), Some(&KnowledgeValue::Int(2_i128.pow(100))));
        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn knowledge_store_corrupt_file_is_empty() {
        let dir = temp_path("corrupt");
        let _ = std::fs::create_dir_all(&dir);
        let path = dir.join(".resid-knowledge.cbor");
        std::fs::write(&path, b"\xff not cbor").unwrap();
        let st = KnowledgeStore::open(&path);
        assert!(st.is_empty());
        let _ = std::fs::remove_dir_all(&dir);
    }
}
