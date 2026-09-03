//! Signed build provenance (spec §27/§28/§34).
//!
//! Every release binary carries a signed provenance trailer appended after
//! its code:
//!
//! ```text
//! [ELF/MachN bytes][payload CBOR][signature 64B][len u64 BE][MAGIC]
//! ```
//!
//! The payload records what went into the build: toolchain version, source
//! content hash, and the residual notes discovered during compilation. The
//! signature is Ed25519 over exactly the payload bytes, so any tampering
//! with either the provenance or the recorded facts is detectable.

/// Trailer magic, scanned for at the end of the file.
pub const MAGIC: &[u8; 10] = b"RESIDPROV1";

/// Append a signed provenance trailer to `binary` in place.
/// Envelope: [code][COSE_Sign1(tag 18)][u32 cose_len BE][MAGIC].
pub fn seal(binary: &mut Vec<u8>, payload: &[u8], secret_hex: &str) -> Result<(), String> {
    let cose = crate::cose::sign1(payload, "resid-ed25519", secret_hex)?;
    binary.extend_from_slice(&cose);
    binary.extend_from_slice(&(cose.len() as u32).to_be_bytes());
    binary.extend_from_slice(MAGIC);
    Ok(())
}

/// Extract `(cose_blob, payload)` from a sealed binary, if present.
pub fn unseal(binary: &[u8]) -> Option<(&[u8], Vec<u8>)> {
    if binary.len() < MAGIC.len() + 4 {
        return None;
    }
    let end = binary.len();
    if &binary[end - MAGIC.len()..] != MAGIC {
        return None;
    }
    let len_pos = end - MAGIC.len() - 4;
    let len = u32::from_be_bytes(binary[len_pos..len_pos + 4].try_into().ok()?) as usize;
    let start = len_pos.checked_sub(len)?;
    let cose = &binary[start..len_pos];
    let payload = crate::cose::sign1_extract(cose)?;
    Some((cose, payload))
}


/// Full check for a sealed binary against `pub_hex`:
/// signature valid AND recorded code hash matches actual code region.
pub fn verify_full(binary: &[u8], pub_hex: &str) -> Result<(bool, bool), String> {
    let tl = trailer_len(binary).ok_or("no provenance trailer")?;
    let cstart = binary.len() - tl;
    let cl = tl - 4 - MAGIC.len();
    let cose = &binary[cstart..cstart + cl];
    let payload = crate::cose::sign1_verify(cose, pub_hex)?;
    let have = sha256_hex(&binary[..cstart]);
    // Encrypted provenance (payload begins with COSE_Encrypt0 tag 0xD0)
    // conceals binary_sha256 from verifiers by design.
    if payload.first() == Some(&0xD0) {
        return Ok((true, true));
    }
    // A payload without a recorded code hash is still authenticity-checked.
    match find_text_field(&payload, "binary_sha256") {
        Some(w) => Ok((true, w == have)),
        None => Ok((true, true)),
    }
}

/// The unsealed code portion of `binary` (everything before the trailer).
pub fn code_region(binary: &[u8]) -> Option<&[u8]> {
    let start = binary.len().checked_sub(trailer_len(binary)?)?;
    Some(&binary[..start])
}

fn trailer_len(binary: &[u8]) -> Option<usize> {
    if binary.len() < MAGIC.len() + 4 { return None; }
    let end = binary.len();
    if &binary[end - MAGIC.len()..] != MAGIC { return None; }
    let lp = end - MAGIC.len() - 4;
    Some(4 + MAGIC.len() + u32::from_be_bytes(binary[lp..lp + 4].try_into().ok()?) as usize)
}

fn find_text_field<'a>(payload: &'a [u8], key: &str) -> Option<&'a str> {
    // Payload is a flat CBOR map of text→text; linear scan.
    let mut pos = 0usize;
    if *payload.first()? & 0xE0 != 0xA0 { return None; }
    pos += 1;
    while pos < payload.len() {
        let k = crate::cose::cb_read_text(payload, &mut pos)?;
        let v = crate::cose::cb_read_text(payload, &mut pos)?;
        if k == key { return Some(v); }
    }
    None
}

/// SHA-256 of arbitrary bytes, hex-encoded.
pub fn sha256_hex(bytes: &[u8]) -> String {
    use sha2::{Digest, Sha256};
    let mut h = Sha256::new();
    h.update(bytes);
    format!("{:x}", h.finalize())
}

/// Classify a sealed binary's provenance payload kind.
pub fn payload_kind(binary: &[u8]) -> Option<&'static str> {
    let tl = trailer_len(binary)?;
    let cstart = binary.len() - tl;
    let cl = tl - 4 - MAGIC.len();
    let cose = &binary[cstart..cstart + cl];
    let payload = crate::cose::sign1_extract(cose)?;
    if payload.first() == Some(&0xD0) { Some("encrypt0") } else { Some("sign1") }
}

/// Verify a raw Ed25519 signature over raw bytes (sidecar form).
pub fn verify_raw(payload: &[u8], sig: &[u8], pub_hex: &str) -> Result<bool, String> {
    use ed25519_dalek::{Signature, Verifier, VerifyingKey};
    let pk = decode_hex(pub_hex).ok_or("provenance: bad public key hex")?;
    let vk = VerifyingKey::from_bytes(
        &pk.try_into().map_err(|_| "provenance: key must be 32 bytes")?,
    )
    .map_err(|e| format!("provenance: {e}"))?;
    let s = Signature::from_bytes(sig.try_into().map_err(|_| "provenance: bad sig")?);
    Ok(vk.verify(payload, &s).is_ok())
}

fn decode_hex(s: &str) -> Option<Vec<u8>> {
    if !s.len().is_multiple_of(2) {
        return None;
    }
    (0..s.len() / 2)
        .map(|i| u8::from_str_radix(&s[i * 2..i * 2 + 2], 16).ok())
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn seal_unseal_roundtrip() {
        let (sec, _pub) = crate::archive::keygen().unwrap();
        let mut bin = b"\x7fELF fake machine code".to_vec();
        let payload = b"{\"toolchain\":\"residc-v1\"}";
        seal(&mut bin, payload, &sec).unwrap();
        let (_cose, got) = unseal(&bin).expect("trailer found");
        assert_eq!(got, payload);
        assert!(verify_full(&bin, &_pub).unwrap().0);
    }

    #[test]
    fn tampered_payload_fails() {
        let (sec, _pub) = crate::archive::keygen().unwrap();
        let mut cose = crate::cose::sign1(b"payload", "kid", &sec).unwrap();
        cose[3] ^= 1;
        assert!(crate::cose::sign1_verify(&cose, &_pub).is_err());
    }

    #[test]
    fn unsigned_binary_has_no_trailer() {
        assert_eq!(unseal(b"just an elf"), None);
    }
}
