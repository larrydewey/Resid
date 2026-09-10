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
    /// Source line where it appears (1-based).
    pub line: u64,
    /// Source column where it appears (0-based); 0 when unknown.
    pub column: u64,
    /// Source file that carries the residual; empty when unknown or when
    /// the sidecar predates provenance fields.
    pub file: String,
}

impl ResidualNote {
    /// Convenience constructor without column/file provenance.
    pub fn new(kind: impl Into<String>, symbol: impl Into<String>, line: u64) -> Self {
        Self { kind: kind.into(), symbol: symbol.into(), line, column: 0, file: String::new() }
    }

    /// Constructor carrying full source provenance.
    pub fn at(
        kind: impl Into<String>,
        symbol: impl Into<String>,
        line: u64,
        column: u64,
        file: impl Into<String>,
    ) -> Self {
        Self { kind: kind.into(), symbol: symbol.into(), line, column, file: file.into() }
    }
}

/// Serialize notes as a CBOR array of 5-element text arrays:
/// (kind, symbol, line, column, file).
pub fn to_cbor(notes: &[ResidualNote]) -> Vec<u8> {
    let mut out = Vec::new();
    cbor::write_header(&mut out, 4, notes.len());
    for n in notes {
        cbor::write_header(&mut out, 4, 5);
        cbor::write_text(&mut out, &n.kind);
        cbor::write_text(&mut out, &n.symbol);
        cbor::write_uint(&mut out, n.line);
        cbor::write_uint(&mut out, n.column);
        cbor::write_text(&mut out, &n.file);
    }
    out
}

/// Parse a notes array produced by [`to_cbor`]. Returns None on malformed
/// input.
///
/// Backward compatible: accepts 3-element arrays (kind, symbol, line —
/// column 0, file empty), 4-element arrays (…, column — file empty) and
/// 5-element arrays (…, column, file).
pub fn from_cbor(bytes: &[u8]) -> Option<Vec<ResidualNote>> {
    let mut pos = 0usize;
    let n = read_array_header(bytes, &mut pos)?;
    let mut notes = Vec::with_capacity(n);
    for _ in 0..n {
        let fields = read_array_header(bytes, &mut pos)?;
        let kind = read_text(bytes, &mut pos)?;
        let symbol = read_text(bytes, &mut pos)?;
        let line = read_uint(bytes, &mut pos)?;
        let (column, file) = match fields {
            3 => (0, String::new()),
            4 => (read_uint(bytes, &mut pos)?, String::new()),
            5 => {
                let col = read_uint(bytes, &mut pos)?;
                let file = read_text(bytes, &mut pos)?;
                (col, file)
            }
            _ => return None,
        };
        notes.push(ResidualNote { kind, symbol, line, column, file });
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
    let len = if (0x60..=0x77).contains(&byte) {
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
            ResidualNote {
                kind: "rt-binding".into(),
                symbol: "rt print_str".into(),
                line: 12,
                column: 4,
                file: "examples/hello.resid".into(),
            },
            ResidualNote::new("provider-call", "filesystem.read_file(x)", 3400),
        ];
        let bytes = to_cbor(&notes);
        assert_eq!(from_cbor(&bytes).unwrap(), notes);
    }

    #[test]
    fn old_three_and_four_field_sidecars_read_back() {
        // 4-element array (kind, symbol, line, column) — pre-file sidecars.
        let four = legacy_cbor(4, "rt-binding", "rt x", 5, Some(2), "");
        let notes = from_cbor(&four).unwrap();
        assert_eq!(notes.len(), 1);
        assert_eq!(notes[0].line, 5);
        assert_eq!(notes[0].column, 2);
        assert_eq!(notes[0].file, "");
        // 3-element array (kind, symbol, line) — original sidecars.
        let three = legacy_cbor(3, "rt-binding", "rt print", 7, None, "");
        let notes = from_cbor(&three).unwrap();
        assert_eq!(notes[0].line, 7);
        assert_eq!(notes[0].file, "");
        // 5-element current format survives a roundtrip.
        let m = ResidualNote::at("provider-call", "env.get(HOME)", 4, 9, "lib/cfg.resid");
        let bytes = to_cbor(&[m.clone()]);
        assert_eq!(from_cbor(&bytes).unwrap(), vec![m]);
    }

    #[test]
    fn malformed_rejected() {
        assert!(from_cbor(&[0x00]).is_none());
        assert!(from_cbor(&[]).is_none());
    }

    /// Build a legacy-field-count sidecar with the crate's own cbor
    /// helpers (so hand-rolled bytes cannot drift).
    fn legacy_cbor(
        fields: usize,
        kind: &str,
        symbol: &str,
        line: u64,
        column: Option<u64>,
        file: &str,
    ) -> Vec<u8> {
        let mut out = Vec::new();
        cbor::write_header(&mut out, 4, 1);
        cbor::write_header(&mut out, 4, fields);
        cbor::write_text(&mut out, kind);
        cbor::write_text(&mut out, symbol);
        cbor::write_uint(&mut out, line);
        if fields >= 4 {
            cbor::write_uint(&mut out, column.unwrap_or(0));
        }
        if fields >= 5 {
            cbor::write_text(&mut out, file);
        }
        out
    }
}
