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

use ed25519_dalek::{Signature, Signer, SigningKey, Verifier, VerifyingKey};
use sha2::{Digest, Sha256};

/// Trailer magic, scanned for at the end of the file.
pub const MAGIC: &[u8; 10] = b"RESIDPROV1";

/// Append a signed provenance trailer to `binary` in place.
pub fn seal(binary: &mut Vec<u8>, payload: &[u8], secret_hex: &str) -> Result<(), String> {
    let secret = decode_hex(secret_hex).ok_or("provenance: bad signing key hex")?;
    let key = SigningKey::from_bytes(
        &secret.try_into().map_err(|_| "provenance: key must be 32 bytes")?,
    );
    let sig = key.sign(payload);
    binary.extend_from_slice(payload);
    binary.extend_from_slice(&sig.to_bytes());
    binary.extend_from_slice(&(payload.len() as u64).to_be_bytes());
    binary.extend_from_slice(MAGIC);
    Ok(())
}

/// The unsealed code portion of `binary` (everything before the trailer).
pub fn code_region(binary: &[u8]) -> Option<&[u8]> {
    let (payload, _) = unseal(binary)?;
    // Trailer is payload + 64B signature + 8B length + MAGIC.
    let start = binary.len().checked_sub(payload.len() + 64 + 8 + MAGIC.len())?;
    Some(&binary[..start])
}

/// Full check: code hash matches the recorded one AND signature is valid.
pub fn verify_full(
    binary: &[u8],
    pub_hex: &str,
) -> Result<(bool, bool), String> {
    let Some((payload, sig)) = unseal(binary) else {
        return Err("no provenance trailer".into());
    };
    let sig_ok = verify(payload, sig, pub_hex)?;
    // Re-extract the recorded binary_sha256 from the CBOR map.
    let want = find_text_field(payload, "binary_sha256");
    let have = sha256_hex(code_region(binary).unwrap_or(&[]));
    let code_ok = match want {
        Some(w) => w == have,
        None => false,
    };
    Ok((sig_ok, code_ok))
}

/// Scan a flat CBOR map (text keys/values) for one field.
fn find_text_field<'a>(payload: &'a [u8], key: &str) -> Option<&'a str> {
    let mut pos = 0usize;
    // skip map header
    if payload.first()? & 0xE0 != 0xA0 {
        return None;
    }
    pos += 1;
    while pos < payload.len() {
        let k = read_cb_text(payload, &mut pos)?;
        let v_start = pos;
        let v = read_cb_text(payload, &mut pos)?;
        let _ = v_start;
        if k == key {
            return Some(v);
        }
    }
    None
}

fn read_cb_text<'a>(bytes: &'a [u8], pos: &mut usize) -> Option<&'a str> {
    let b = *bytes.get(*pos)?;
    *pos += 1;
    let len = match b & 0x1F {
        n @ 0..=23 => n as usize,
        24 => {
            let l = *bytes.get(*pos)? as usize;
            *pos += 1;
            l
        }
        _ => return None,
    };
    let v = bytes.get(*pos..*pos + len)?;
    *pos += len;
    std::str::from_utf8(v).ok()
}

/// Extract `(payload, signature)` from a sealed binary, if present.
pub fn unseal(binary: &[u8]) -> Option<(&[u8], &[u8])> {
    if binary.len() < MAGIC.len() + 8 + 64 {
        return None;
    }
    let end = binary.len();
    if &binary[end - MAGIC.len()..] != MAGIC {
        return None;
    }
    let len_pos = end - MAGIC.len() - 8;
    let len = u64::from_be_bytes(binary[len_pos..len_pos + 8].try_into().ok()?) as usize;
    let sig_end = len_pos;
    let sig_start = sig_end.checked_sub(64)?;
    let pay_end = sig_start;
    let pay_start = pay_end.checked_sub(len)?;
    Some((&binary[pay_start..pay_end], &binary[sig_start..sig_end]))
}

/// Verify the embedded signature over the payload.
pub fn verify(payload: &[u8], sig: &[u8], pub_hex: &str) -> Result<bool, String> {
    let pk = decode_hex(pub_hex).ok_or("provenance: bad public key hex")?;
    let vk = VerifyingKey::from_bytes(&pk.try_into().map_err(|_| {
        "provenance: public key must be 32 bytes"
    })?)
    .map_err(|e| format!("provenance: {e}"))?;
    let sig = Signature::from_bytes(sig.try_into().map_err(|_| "provenance: bad signature")?);
    Ok(vk.verify(payload, &sig).is_ok())
}

/// SHA-256 of arbitrary bytes, hex-encoded.
pub fn sha256_hex(bytes: &[u8]) -> String {
    let mut h = Sha256::new();
    h.update(bytes);
    format!("{:x}", h.finalize())
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

    #[test]
    fn seal_unseal_roundtrip() {
        let (sec, _pub) = crate::archive::keygen().unwrap();
        let mut bin = b"\x7fELF fake machine code".to_vec();
        let payload = b"{\"toolchain\":\"residc-v1\"}";
        seal(&mut bin, payload, &sec).unwrap();
        let (pay, sig) = unseal(&bin).expect("trailer found");
        assert_eq!(pay, payload);
        assert!(verify(pay, sig, &_pub).unwrap());
        // Code untouched.
        let trailer = payload.len() + 64 + 8 + MAGIC.len();
        assert_eq!(bin.len(), b"\x7fELF fake machine code".len() + trailer);
        assert_eq!(&bin[..b"\x7fELF fake machine code".len()], b"\x7fELF fake machine code");
    }

    #[test]
    fn tampered_payload_fails() {
        let (sec, _pub) = crate::archive::keygen().unwrap();
        let mut bin = vec![0u8; 16];
        seal(&mut bin, b"payload", &sec).unwrap();
        let (pay, sig) = unseal(&bin).unwrap();
        // Flip one payload byte.
        let mut bad = pay.to_vec();
        bad[0] ^= 1;
        assert!(!verify(&bad, sig, &_pub).unwrap());
    }

    #[test]
    fn unsigned_binary_has_no_trailer() {
        assert_eq!(unseal(b"just an elf"), None);
    }
}
