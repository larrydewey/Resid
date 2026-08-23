//! Residual notes (spec §27, §34): a record of the residual work that
//! remains after compilation, emitted as `<artifact>.resid-notes.cbor` so
//! later compilations — with more knowledge or capabilities — can see and
//! discharge what is left.

use resid_cache::cbor;

/// One residual fact discovered during compilation.
#[derive(Debug, Clone, PartialEq)]
pub struct ResidualNote {
    /// What kind of residual this is: "rt-binding", "provider-call", ...
    pub kind: String,
    /// The symbol or expression involved.
    pub symbol: String,
    /// Source line where it appears.
    pub line: u64,
}

/// Serialize notes as a CBOR array of 3-element text arrays.
pub fn to_cbor(notes: &[ResidualNote]) -> Vec<u8> {
    let mut out = Vec::new();
    cbor::write_header(&mut out, 4, notes.len());
    for n in notes {
        cbor::write_header(&mut out, 4, 3);
        cbor::write_text(&mut out, &n.kind);
        cbor::write_text(&mut out, &n.symbol);
        cbor::write_uint(&mut out, n.line);
    }
    out
}

/// Parse a notes array produced by [`to_cbor`]. Returns None on malformed
/// input.
pub fn from_cbor(bytes: &[u8]) -> Option<Vec<ResidualNote>> {
    let mut pos = 0usize;
    let n = read_array_header(bytes, &mut pos)?;
    let mut notes = Vec::with_capacity(n);
    for _ in 0..n {
        if read_array_header(bytes, &mut pos)? != 3 {
            return None;
        }
        let kind = read_text(bytes, &mut pos)?;
        let symbol = read_text(bytes, &mut pos)?;
        let line = read_uint(bytes, &mut pos)?;
        notes.push(ResidualNote { kind, symbol, line });
    }
    Some(notes)
}

/// Read and parse `<artifact>.resid-notes.cbor`, or None if absent/malformed.
pub fn read_notes_file(artifact: &std::path::Path) -> Option<Vec<ResidualNote>> {
    let mut p = artifact.as_os_str().to_owned();
    p.push(".resid-notes.cbor");
    from_cbor(&std::fs::read(p).ok()?)
}

fn read_array_header(b: &[u8], pos: &mut usize) -> Option<usize> {
    let byte = *b.get(*pos)?;
    *pos += 1;
    match byte {
        0x80..=0x97 => Some((byte & 0x1F) as usize),
        0x98 => {
            let v = *b.get(*pos)? as usize;
            *pos += 1;
            Some(v)
        }
        0x99 => {
            let v = b.get(*pos..*pos + 2)?;
            *pos += 2;
            Some(u16::from_be_bytes(v.try_into().ok()?) as usize)
        }
        _ => None,
    }
}

fn read_text(b: &[u8], pos: &mut usize) -> Option<String> {
    let byte = *b.get(*pos)?;
    *pos += 1;
    let len = if byte >= 0x60 && byte <= 0x77 {
        (byte & 0x1F) as usize
    } else if byte == 0x78 {
        let v = *b.get(*pos)? as usize;
        *pos += 1;
        v
    } else if byte == 0x79 {
        let v = b.get(*pos..*pos + 2)?;
        *pos += 2;
        u16::from_be_bytes(v.try_into().ok()?) as usize
    } else {
        return None;
    };
    let s = String::from_utf8(b.get(*pos..*pos + len)?.to_vec()).ok()?;
    *pos += len;
    Some(s)
}

fn read_uint(b: &[u8], pos: &mut usize) -> Option<u64> {
    let byte = *b.get(*pos)?;
    *pos += 1;
    match byte {
        0x00..=0x17 => Some(byte as u64),
        0x18 => {
            let v = *b.get(*pos)? as u64;
            *pos += 1;
            Some(v)
        }
        0x19 => {
            let v = b.get(*pos..*pos + 2)?;
            *pos += 2;
            Some(u16::from_be_bytes(v.try_into().ok()?) as u64)
        }
        0x1A => {
            let v = b.get(*pos..*pos + 4)?;
            *pos += 4;
            Some(u32::from_be_bytes(v.try_into().ok()?) as u64)
        }
        0x1B => {
            let v = b.get(*pos..*pos + 8)?;
            *pos += 8;
            Some(u64::from_be_bytes(v.try_into().ok()?))
        }
        _ => None,
    }
}
pub fn write_notes_file(artifact: &std::path::Path, notes: &[ResidualNote]) -> std::io::Result<()> {
    let mut p = artifact.as_os_str().to_owned();
    p.push(".resid-notes.cbor");
    std::fs::write(p, to_cbor(notes))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn cbor_roundtrip() {
        let notes = vec![
            ResidualNote { kind: "rt-binding".into(), symbol: "rt print_str".into(), line: 12 },
            ResidualNote { kind: "provider-call".into(), symbol: "filesystem.read_file(x)".into(), line: 3400 },
        ];
        let bytes = to_cbor(&notes);
        assert_eq!(from_cbor(&bytes).unwrap(), notes);
    }

    #[test]
    fn malformed_rejected() {
        assert!(from_cbor(&[0x00]).is_none());
        assert!(from_cbor(&[]).is_none());
    }
}
