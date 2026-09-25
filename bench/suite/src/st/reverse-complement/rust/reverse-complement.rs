// reverse-complement: single-threaded, same algorithm as the Benchmarks Game description.
// Reads FASTA from stdin, writes each sequence's reverse complement, 60 chars per line.
use std::io::{self, Read, Write};

const LINE: usize = 60;

fn complement_table() -> [u8; 256] {
    let mut t = [0u8; 256];
    for (i, v) in t.iter_mut().enumerate() {
        *v = i as u8;
    }
    let pairs: &[(u8, u8)] = &[
        (b'A', b'T'), (b'C', b'G'), (b'G', b'C'), (b'T', b'A'),
        (b'U', b'A'), (b'M', b'K'), (b'R', b'Y'), (b'W', b'W'),
        (b'S', b'S'), (b'Y', b'R'), (b'K', b'M'), (b'V', b'B'),
        (b'H', b'D'), (b'D', b'H'), (b'B', b'V'), (b'N', b'N'),
    ];
    for &(from, to) in pairs {
        t[from as usize] = to;
        t[from.to_ascii_lowercase() as usize] = to;
    }
    t
}

fn write_seq<W: Write>(out: &mut W, seq: &mut Vec<u8>, table: &[u8; 256]) -> io::Result<()> {
    seq.reverse();
    for c in seq.iter_mut() {
        *c = table[*c as usize];
    }
    let mut buf = Vec::with_capacity(seq.len() + seq.len() / LINE + 1);
    for chunk in seq.chunks(LINE) {
        buf.extend_from_slice(chunk);
        buf.push(b'\n');
    }
    out.write_all(&buf)?;
    seq.clear();
    Ok(())
}

fn main() -> io::Result<()> {
    let table = complement_table();
    let mut input = Vec::new();
    io::stdin().lock().read_to_end(&mut input)?;
    let stdout = io::stdout();
    let mut out = io::BufWriter::with_capacity(1 << 16, stdout.lock());
    let mut seq: Vec<u8> = Vec::new();
    for line in input.split(|&c| c == b'\n') {
        if line.is_empty() {
            continue;
        }
        if line[0] == b'>' {
            if !seq.is_empty() {
                write_seq(&mut out, &mut seq, &table)?;
            }
            out.write_all(line)?;
            out.write_all(b"\n")?;
        } else {
            seq.extend_from_slice(line);
        }
    }
    if !seq.is_empty() {
        write_seq(&mut out, &mut seq, &table)?;
    }
    out.flush()
}
