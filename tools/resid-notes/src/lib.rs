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

/// Write notes to `<artifact>.resid-notes.cbor`.
pub fn write_notes_file(artifact: &std::path::Path, notes: &[ResidualNote]) -> std::io::Result<()> {
    let mut p = artifact.as_os_str().to_owned();
    p.push(".resid-notes.cbor");
    std::fs::write(p, to_cbor(notes))
}
