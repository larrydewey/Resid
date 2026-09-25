// k-nucleotide: single-threaded, same algorithm as the Benchmarks Game description.
// Reads a FASTA file on stdin, extracts sequence THREE, and counts k-mers with a
// standard-library HashMap keyed by the k-mer bytes.
use std::collections::HashMap;
use std::io::{self, BufRead, Write};

fn frequencies(seq: &[u8], k: usize) -> HashMap<&[u8], u32> {
    let mut map: HashMap<&[u8], u32> = HashMap::new();
    for i in 0..=seq.len() - k {
        *map.entry(&seq[i..i + k]).or_insert(0) += 1;
    }
    map
}

fn write_frequencies<W: Write>(out: &mut W, seq: &[u8], k: usize) -> io::Result<()> {
    let map = frequencies(seq, k);
    let total: u32 = map.values().sum();
    let mut v: Vec<(&[u8], u32)> = map.into_iter().collect();
    v.sort_by(|a, b| b.1.cmp(&a.1).then(a.0.cmp(b.0)));
    for (key, count) in v {
        writeln!(
            out,
            "{} {:.3}",
            std::str::from_utf8(key).unwrap(),
            100.0 * count as f64 / total as f64
        )?;
    }
    writeln!(out)
}

fn write_count<W: Write>(out: &mut W, seq: &[u8], pattern: &str) -> io::Result<()> {
    let map = frequencies(seq, pattern.len());
    let count = map.get(pattern.as_bytes()).copied().unwrap_or(0);
    writeln!(out, "{}\t{}", count, pattern)
}

fn main() -> io::Result<()> {
    let stdin = io::stdin();
    let mut input = stdin.lock();
    let mut line = Vec::new();
    // Skip to the ">THREE" header.
    loop {
        line.clear();
        if input.read_until(b'\n', &mut line)? == 0 {
            break;
        }
        if line.starts_with(b">THREE") {
            break;
        }
    }
    let mut seq = Vec::new();
    loop {
        line.clear();
        if input.read_until(b'\n', &mut line)? == 0 || line[0] == b'>' {
            break;
        }
        for &c in &line {
            if c != b'\n' && c != b'\r' {
                seq.push(c.to_ascii_uppercase());
            }
        }
    }
    let stdout = io::stdout();
    let mut out = io::BufWriter::new(stdout.lock());
    write_frequencies(&mut out, &seq, 1)?;
    write_frequencies(&mut out, &seq, 2)?;
    for p in ["GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT"] {
        write_count(&mut out, &seq, p)?;
    }
    out.flush()
}
