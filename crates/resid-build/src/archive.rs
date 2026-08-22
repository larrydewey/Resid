//! Package archives and signatures (spec §28).
//!
//! An archive is a deterministic byte serialization of a package's source
//! files (sorted relative paths), so the same tree always yields the same
//! bytes and thus the same content hash:
//!
//! ```text
//! "RESIDPKG1"                     (9-byte magic)
//! u32 file count
//! per file: u16 path length, path bytes, u64 content length, content bytes
//! ```
//!
//! The archive's SHA-256 digest is the package's content hash. A signature
//! is an Ed25519 signature over that digest; keys are hex-encoded. The
//! signature is stored alongside the archive in `<name>.resid-sig`.

use std::path::{Path, PathBuf};

use ed25519_dalek::{Signature, Signer, SigningKey, Verifier, VerifyingKey};
use sha2::{Digest, Sha256};

const MAGIC: &[u8; 9] = b"RESIDPKG1";

#[derive(Debug)]
pub enum PackError {
    /// Archive construction or I/O failure.
    Io(String),
    /// No source files found to pack.
    Empty,
}

impl std::fmt::Display for PackError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            PackError::Io(m) => f.write_str(m),
            PackError::Empty => f.write_str("package contains no source files"),
        }
    }
}

fn walk_sources(dir: &Path, base: &Path, out: &mut Vec<PathBuf>) -> std::io::Result<()> {
    for entry in std::fs::read_dir(dir)? {
        let entry = entry?;
        let path = entry.path();
        if path.is_dir() {
            // Skip build output.
            if path.file_name().map(|n| n == "target").unwrap_or(false) {
                continue;
            }
            walk_sources(&path, base, out)?;
        } else if path.extension().map(|e| e == "resid" || e == "toml").unwrap_or(false) {
            out.push(path.strip_prefix(base).unwrap_or(&path).to_path_buf());
        }
    }
    Ok(())
}

/// Serialize the package rooted at `dir` into deterministic archive bytes.
pub fn build_archive(dir: &Path) -> Result<Vec<u8>, PackError> {
    let mut files = Vec::new();
    walk_sources(dir, dir, &mut files).map_err(|e| PackError::Io(e.to_string()))?;
    if files.is_empty() {
        return Err(PackError::Empty);
    }
    files.sort();
    files.dedup();

    let mut out = Vec::new();
    out.extend_from_slice(MAGIC);
    out.extend_from_slice(&(files.len() as u32).to_le_bytes());
    for rel in &files {
        let abs = dir.join(rel);
        let content = std::fs::read(&abs)
            .map_err(|e| PackError::Io(format!("cannot read '{}': {e}", abs.display())))?;
        let rel_str = rel.to_string_lossy().into_owned();
        let rel_bytes = rel_str.as_bytes();
        out.extend_from_slice(&(rel_bytes.len() as u16).to_le_bytes());
        out.extend_from_slice(rel_bytes);
        out.extend_from_slice(&(content.len() as u64).to_le_bytes());
        out.extend_from_slice(&content);
    }
    Ok(out)
}

/// SHA-256 of the archive bytes — the package content hash.
pub fn content_hash(archive: &[u8]) -> [u8; 32] {
    Sha256::digest(archive).into()
}

/// Sign the content hash with a hex-encoded Ed25519 secret key.
/// Returns the hex signature.
pub fn sign_hash(hash: &[u8; 32], secret_hex: &str) -> Result<String, String> {
    let secret = decode_hex32(secret_hex)?;
    let key = SigningKey::from_bytes(&secret);
    let sig = key.sign(hash);
    Ok(hex_encode(&sig.to_bytes()))
}

/// Verify a hex signature over a hash against a hex public key.
pub fn verify_sig(hash: &[u8; 32], sig_hex: &str, pub_hex: &str) -> Result<bool, String> {
    let sig_bytes = decode_hex64(sig_hex)?;
    let sig = Signature::from_bytes(&sig_bytes);
    let pub_bytes = decode_hex32(pub_hex)?;
    let vk = VerifyingKey::from_bytes(&pub_bytes).map_err(|e| format!("bad public key: {e}"))?;
    match vk.verify(hash, &sig) {
        Ok(()) => Ok(true),
        Err(_) => Ok(false),
    }
}

/// Generate a new signing keypair; returns (secret_hex, public_hex).
pub fn keygen() -> Result<(String, String), String> {
    let mut seed = [0u8; 32];
    getrandom_fill(&mut seed)?;
    let key = SigningKey::from_bytes(&seed);
    let secret_hex = hex_encode(&key.to_bytes());
    let public_hex = hex_encode(&key.verifying_key().to_bytes());
    Ok((secret_hex, public_hex))
}

fn getrandom_fill(buf: &mut [u8]) -> Result<(), String> {
    getrandom::getrandom(buf).map_err(|e| format!("entropy failure: {e}"))
}

pub fn hex_encode(bytes: &[u8]) -> String {
    bytes.iter().map(|b| format!("{b:02x}")).collect()
}

fn decode_hex32(s: &str) -> Result<[u8; 32], String> {
    let v = decode_hex(s)?;
    v.try_into().map_err(|_| "expected 32-byte (64 hex char) key".to_string())
}

fn decode_hex64(s: &str) -> Result<[u8; 64], String> {
    let v = decode_hex(s)?;
    v.try_into().map_err(|_| "expected 64-byte (128 hex char) signature".to_string())
}

fn decode_hex(s: &str) -> Result<Vec<u8>, String> {
    if s.len() % 2 != 0 {
        return Err("odd-length hex string".to_string());
    }
    (0..s.len() / 2)
        .map(|i| {
            u8::from_str_radix(&s[2 * i..2 * i + 2], 16)
                .map_err(|e| format!("bad hex: {e}"))
        })
        .collect()
}
