// fasta: single-threaded, same algorithm as the Benchmarks Game description.
// Linear congruential generator, cumulative probabilities with linear search.
use std::io::{self, Write};

const IM: u32 = 139968;
const IA: u32 = 3877;
const IC: u32 = 29573;
const LINE: usize = 60;

const ALU: &[u8] = b"GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG\
GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA\
CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT\
ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA\
GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG\
AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC\
AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

struct Rng(u32);

impl Rng {
    fn next(&mut self, max: f64) -> f64 {
        self.0 = (self.0 * IA + IC) % IM;
        max * self.0 as f64 / IM as f64
    }
}

fn repeat_fasta<W: Write>(out: &mut W, header: &str, src: &[u8], n: usize) -> io::Result<()> {
    out.write_all(header.as_bytes())?;
    let len = src.len();
    // Doubled source lets every line be copied as one contiguous slice.
    let mut buf = Vec::with_capacity(len + LINE);
    buf.extend_from_slice(src);
    buf.extend_from_slice(&src[..LINE]);
    let mut pos = 0;
    let mut left = n;
    while left > 0 {
        let line = if left < LINE { left } else { LINE };
        out.write_all(&buf[pos..pos + line])?;
        out.write_all(b"\n")?;
        pos += line;
        if pos >= len {
            pos -= len;
        }
        left -= line;
    }
    Ok(())
}

fn random_fasta<W: Write>(
    out: &mut W,
    header: &str,
    table: &[(u8, f64)],
    n: usize,
    rng: &mut Rng,
) -> io::Result<()> {
    out.write_all(header.as_bytes())?;
    let mut chars = Vec::with_capacity(table.len());
    let mut cumul = Vec::with_capacity(table.len());
    let mut acc = 0.0;
    for &(c, p) in table {
        acc += p;
        chars.push(c);
        cumul.push(acc);
    }
    let last = table.len() - 1;
    let mut line = [0u8; LINE + 1];
    let mut left = n;
    while left > 0 {
        let m = if left < LINE { left } else { LINE };
        for slot in line.iter_mut().take(m) {
            let r = rng.next(1.0);
            let mut i = 0;
            while i < last && r >= cumul[i] {
                i += 1;
            }
            *slot = chars[i];
        }
        line[m] = b'\n';
        out.write_all(&line[..=m])?;
        left -= m;
    }
    Ok(())
}

fn main() -> io::Result<()> {
    let n: usize = std::env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(1000);
    let iub: [(u8, f64); 15] = [
        (b'a', 0.27), (b'c', 0.12), (b'g', 0.12), (b't', 0.27),
        (b'B', 0.02), (b'D', 0.02), (b'H', 0.02), (b'K', 0.02),
        (b'M', 0.02), (b'N', 0.02), (b'R', 0.02), (b'S', 0.02),
        (b'V', 0.02), (b'W', 0.02), (b'Y', 0.02),
    ];
    let homo: [(u8, f64); 4] = [
        (b'a', 0.3029549426680),
        (b'c', 0.1979883004921),
        (b'g', 0.1975473066391),
        (b't', 0.3015094502008),
    ];
    let stdout = io::stdout();
    let mut out = io::BufWriter::with_capacity(1 << 16, stdout.lock());
    let mut rng = Rng(42);
    repeat_fasta(&mut out, ">ONE Homo sapiens alu\n", ALU, n * 2)?;
    random_fasta(&mut out, ">TWO IUB ambiguity codes\n", &iub, n * 3, &mut rng)?;
    random_fasta(&mut out, ">THREE Homo sapiens frequency\n", &homo, n * 5, &mut rng)?;
    out.flush()
}
