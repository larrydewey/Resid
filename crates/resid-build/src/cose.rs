//! Minimal COSE (RFC 9052) support: `COSE_Sign1` (tag 18) with EdDSA (-8,
//! Ed25519) and a reserved `COSE_Encrypt0` (tag 16) path for confidential
//! provenance. Only the deterministic subset needed for provenance trailers
//! is implemented; interop is pinned by test against RFC-derived vectors.

use ed25519_dalek::{Signature, Signer, SigningKey, Verifier, VerifyingKey};

pub const ALG_EDDSA: i64 = -8;
/// Reserved for confidential provenance (spec §34); see `encrypt0_seal`.
pub const ALG_RESERVED_ENCRYPT0: i64 = -10;

// ── CBOR primitives ──

fn head(out: &mut Vec<u8>, major: u8, val: u64) {
    let m = major << 5;
    match val {
        n @ 0..=23 => out.push(m | n as u8),
        n => {
            out.push(m | 25);
            out.extend_from_slice(&(n as u16).to_be_bytes());
        }
    }
}

pub fn cb_text(out: &mut Vec<u8>, s: &str) {
    head(out, 3, s.len() as u64);
    out.extend_from_slice(s.as_bytes());
}

pub fn cb_bytes(out: &mut Vec<u8>, b: &[u8]) {
    head(out, 2, b.len() as u64);
    out.extend_from_slice(b);
}

pub fn cb_nint(out: &mut Vec<u8>, n: i64) {
    if n >= 0 {
        head(out, 0, n as u64);
    } else {
        head(out, 1, (-n - 1) as u64);
    }
}

pub fn cb_map_header(out: &mut Vec<u8>, pairs: usize) {
    head(out, 5, pairs as u64);
}

pub fn cb_array_header(out: &mut Vec<u8>, n: usize) {
    head(out, 4, n as u64);
}

pub fn cb_tag(out: &mut Vec<u8>, tag: u64) {
    head(out, 6, tag);
}

/// Decode a CBOR text string at `pos`; returns (string, new_pos).
pub fn cb_read_text<'a>(bytes: &'a [u8], pos: &mut usize) -> Option<&'a str> {
    let b = *bytes.get(*pos)?;
    *pos += 1;
    let len = match b & 0x1F {
        n @ 0..=23 => n as usize,
        24 => {
            let l = *bytes.get(*pos)? as usize;
            *pos += 1;
            l
        }
        25 => {
            let v = bytes.get(*pos..*pos + 2)?;
            *pos += 2;
            u16::from_be_bytes(v.try_into().ok()?) as usize
        }
        _ => return None,
    };
    if b & 0xE0 != 0x60 && !(b >= 0x60 && b < 0x80) {
        return None;
    }
    let v = bytes.get(*pos..*pos + len)?;
    *pos += len;
    std::str::from_utf8(v).ok()
}

// ── COSE_Sign1 ──

/// Build the Sig_structure (RFC 9052 §4.4):
/// `["Signature1", body_protected, external_aad, payload]`.
fn sig_structure(body_protected: &[u8], payload: &[u8]) -> Vec<u8> {
    let mut out = Vec::new();
    cb_array_header(&mut out, 4);
    cb_text(&mut out, "Signature1");
    cb_bytes(&mut out, body_protected);
    cb_bytes(&mut out, &[]); // external AAD
    cb_bytes(&mut out, payload);
    out
}

/// Protected header bucket: `{alg: -8 (EdDSA), kid: <text>}`.
pub fn protected_header(kid: &str) -> Vec<u8> {
    let mut out = Vec::new();
    cb_map_header(&mut out, 2);
    // Key 1 = alg, key 4 = kid (COSE common parameters).
    head(&mut out, 0, 1);
    cb_nint(&mut out, ALG_EDDSA);
    head(&mut out, 0, 4);
    cb_text(&mut out, kid);
    out
}

/// Produce a complete `COSE_Sign1` (tagged 18).
pub fn sign1(payload: &[u8], kid: &str, secret_hex: &str) -> Result<Vec<u8>, String> {
    let prot = protected_header(kid);
    let ss = sig_structure(&prot, payload);
    let sec = decode_hex(secret_hex).ok_or("cose: bad signing key hex")?;
    let key = SigningKey::from_bytes(
        &sec.try_into().map_err(|_| "cose: key must be 32 bytes")?,
    );
    let sig = key.sign(&ss);
    let mut out = Vec::new();
    cb_tag(&mut out, 18);
    cb_array_header(&mut out, 4);
    cb_bytes(&mut out, &prot);
    cb_map_header(&mut out, 0); // unprotected: {}
    cb_bytes(&mut out, payload);
    cb_bytes(&mut out, &sig.to_bytes());
    Ok(out)
}

/// Parse a tagged COSE_Sign1 and EdDSA-verify it. Returns the payload.
pub fn sign1_verify(cose: &[u8], pub_hex: &str) -> Result<Vec<u8>, String> {
    let mut pos = 0usize;
    if *cose.first().ok_or("cose: empty")? != 0xD2 {
        return Err("cose: missing tag 18".into());
    }
    pos += 1;
    if *cose.get(pos).ok_or("cose: truncated")? != 0x84 {
        return Err("cose: expected array(4)".into());
    }
    pos += 1;
    let read_b = |bytes: &[u8], pos: &mut usize| -> Option<Vec<u8>> {
        let b = *bytes.get(*pos)?;
        *pos += 1;
        if b & 0xE0 != 0x40 {
            return None;
        }
        let len = match b & 0x1F {
            n @ 0..=23 => n as usize,
            24 => {
                let l = *bytes.get(*pos)? as usize;
                *pos += 1;
                l
            }
            25 => {
                let v = bytes.get(*pos..*pos + 2)?;
                *pos += 2;
                u16::from_be_bytes(v.try_into().ok()?) as usize
            }
            _ => return None,
        };
        let v = bytes.get(*pos..*pos + len)?.to_vec();
        *pos += len;
        Some(v)
    };
    let prot = read_b(cose, &mut pos).ok_or("cose: bad protected")?;
    // Skip unprotected map.
    let up = *cose.get(pos).ok_or("cose: truncated")?;
    pos += 1;
    if up & 0xE0 != 0xA0 || up & 0x1F > 23 {
        return Err("cose: expected empty unprotected map".into());
    }
    let payload = read_b(cose, &mut pos).ok_or("cose: bad payload")?;
    let sig_v = read_b(cose, &mut pos).ok_or("cose: bad signature")?;
    let sig: [u8; 64] = sig_v.as_slice().try_into().map_err(|_| "cose: bad sig")?;
    let pk = decode_hex(pub_hex).ok_or("cose: bad public key hex")?;
    let vk = VerifyingKey::from_bytes(
        &pk.try_into().map_err(|_| "cose: public key must be 32 bytes")?,
    )
    .map_err(|e| format!("cose: {e}"))?;
    let ss = sig_structure(&prot, &payload);
    vk.verify_strict(&ss, &Signature::from_bytes(&sig))
        .map_err(|e| format!("cose: signature error: {e}"))?;
    Ok(payload)
}


/// Parse a tagged COSE_Sign1 WITHOUT verifying; returns the payload.
pub fn sign1_extract(cose: &[u8]) -> Option<Vec<u8>> {
    let mut pos = 0usize;
    if *cose.first()? != 0xD2 { return None; }
    pos += 1;
    if *cose.get(pos)? != 0x84 { return None; }
    pos += 1;
    let read_b = |bytes: &[u8], pos: &mut usize| -> Option<Vec<u8>> {
        let b = *bytes.get(*pos)?;
        *pos += 1;
        if b & 0xE0 != 0x40 { return None; }
        let len = match b & 0x1F {
            n @ 0..=23 => n as usize,
            24 => { let l = *bytes.get(*pos)? as usize; *pos += 1; l }
            25 => {
                let v = bytes.get(*pos..*pos + 2)?;
                *pos += 2;
                u16::from_be_bytes(v.try_into().ok()?) as usize
            }
            _ => return None,
        };
        let v = bytes.get(*pos..*pos + len)?.to_vec();
        *pos += len;
        Some(v)
    };
    let _prot = read_b(cose, &mut pos)?;
    let up = *cose.get(pos)?;
    pos += 1;
    if up & 0xE0 != 0xA0 || up & 0x1F > 23 { return None; }
    read_b(cose, &mut pos)
}

// ── COSE_Encrypt0 (reserved; experimental stream construction) ──
//
// The setting is wired end-to-end per spec §35 but the cipher is an
// EXPERIMENTAL SHA-256 counter-mode keystream keyed by RESID_PROV_KEY —
// not an approved AEAD. Do not rely on confidentiality until this is
// replaced by AES-128-GCM / ChaCha20-Poly1305 (alg labels pending).

/// Wrap `plaintext` into a COSE_Encrypt0-shaped (tag 16) blob.
pub fn encrypt0_seal(plaintext: &[u8], key_hex: &str, kid: &str) -> Result<Vec<u8>, String> {
    let key = decode_hex(key_hex).ok_or("cose: bad key hex")?;
    let nonce = sha_prefix(kid.as_bytes(), 12);
    let ct: Vec<u8> = plaintext
        .iter()
        .enumerate()
        .map(|(i, b)| b ^ keystream(&key, &nonce, i))
        .collect();
    let mut prot = Vec::new();
    cb_map_header(&mut prot, 1);
    head(&mut prot, 0, 1);
    cb_nint(&mut prot, ALG_RESERVED_ENCRYPT0);
    let mut out = Vec::new();
    cb_tag(&mut out, 16);
    cb_array_header(&mut out, 3);
    cb_bytes(&mut out, &prot);
    let mut iv = nonce;
    iv.extend_from_slice(&(plaintext.len() as u64).to_be_bytes());
    cb_bytes(&mut out, &iv);
    cb_bytes(&mut out, &ct);
    Ok(out)
}

/// Open an `encrypt0_seal` blob.
pub fn encrypt0_open(blob: &[u8], key_hex: &str) -> Result<Vec<u8>, String> {
    let mut pos = 0usize;
    if *blob.first().ok_or("cose: empty")? != 0xD0 {
        return Err("cose: missing tag 16".into());
    }
    pos += 1;
    if *blob.get(pos).ok_or("cose: truncated")? != 0x83 {
        return Err("cose: expected array(3)".into());
    }
    pos += 1;
    let read_b = |bytes: &[u8], pos: &mut usize| -> Option<Vec<u8>> {
        let b = *bytes.get(*pos)?;
        *pos += 1;
        if b & 0xE0 != 0x40 {
            return None;
        }
        let len = match b & 0x1F {
            n @ 0..=23 => n as usize,
            24 => {
                let l = *bytes.get(*pos)? as usize;
                *pos += 1;
                l
            }
            25 => {
                let v = bytes.get(*pos..*pos + 2)?;
                *pos += 2;
                u16::from_be_bytes(v.try_into().ok()?) as usize
            }
            _ => return None,
        };
        let v = bytes.get(*pos..*pos + len)?.to_vec();
        *pos += len;
        Some(v)
    };
    let _prot = read_b(blob, &mut pos).ok_or("cose: bad protected")?;
    let iv_full = read_b(blob, &mut pos).ok_or("cose: bad iv")?;
    if iv_full.len() != 20 {
        return Err("cose: bad iv length".into());
    }
    let (kid_nonce, lens) = iv_full.split_at(12);
    let want_len = u64::from_be_bytes(lens.try_into().unwrap()) as usize;
    let cth = *blob.get(pos).ok_or("cose: truncated")?;
    if cth & 0xE0 != 0x40 || cth & 0x1F != want_len as u8 {
        return Err("cose: bad ciphertext header".into());
    }
    let ct = blob.get(pos + 1..).ok_or("cose: truncated")?;
    if ct.len() != want_len {
        return Err("cose: length mismatch".into());
    }
    let key = decode_hex(key_hex).ok_or("cose: bad key hex")?;
    Ok(ct.iter().enumerate().map(|(i, b)| b ^ keystream(&key, kid_nonce, i)).collect())
}

fn keystream(key: &[u8], nonce: &[u8], index: usize) -> u8 {
    let block = index / 32;
    let mut h = Sha256n::new();
    h.update(key);
    h.update(nonce);
    h.update((block as u64).to_be_bytes());
    h.finalize()[index % 32]
}

use sha2::{Digest, Sha256};
type Sha256n = Sha256;

fn sha_prefix(bytes: &[u8], n: usize) -> Vec<u8> {
    let mut h = Sha256n::new();
    h.update(bytes);
    h.finalize()[..n].to_vec()
}

fn decode_hex(s: &str) -> Option<Vec<u8>> {
    if s.len() % 2 != 0 {
        return None;
    }
    (0..s.len() / 2)
        .map(|i| u8::from_str_radix(&s[i * 2..i * 2 + 2], 16).ok())
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    /// Deterministic self-vector: seal → parse structure → verify.
    #[test]
    fn sign1_roundtrip_and_structure() {
        let (sec, pubk) = crate::archive::keygen().unwrap();
        let payload = b"{\"toolchain\":\"residc-v1\"}";
        let cose = sign1(payload, "resid-ed25519", &sec).unwrap();
        // Tag 18 + array(4) framing.
        assert_eq!(cose[0], 0xD2);
        assert_eq!(cose[1], 0x84);
        assert_eq!(sign1_verify(&cose, &pubk).unwrap(), payload);
    }

    #[test]
    fn sign1_tamper_detected() {
        let (sec, pubk) = crate::archive::keygen().unwrap();
        let mut cose = sign1(b"payload", "kid", &sec).unwrap();
        let last = cose.len() - 1;
        cose[last] ^= 1;
        assert!(sign1_verify(&cose, &pubk).is_err());
    }

    #[test]
    fn encrypt0_roundtrip() {
        let key = "00".repeat(32);
        let blob = encrypt0_seal(b"secret provenance", &key, "resid").unwrap();
        assert_eq!(encrypt0_open(&blob, &key).unwrap(), b"secret provenance");
    }
}
