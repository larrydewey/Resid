// pidigits: single-threaded, same algorithm as the Benchmarks Game description
// (unbounded spigot, digit extraction by comparing (3*numer+accum)/denom and
// (4*numer+accum)/denom). Bignums via rug (GMP).
use rug::{Assign, Integer};
use std::io::{self, Write};

struct Spigot {
    acc: Integer,
    den: Integer,
    num: Integer,
    tmp1: Integer,
    tmp2: Integer,
}

impl Spigot {
    fn extract_digit(&mut self, nth: u32) -> u32 {
        // (numer * nth + accum) / denom
        self.tmp1.assign(&self.num * nth);
        self.tmp2.assign(&self.tmp1 + &self.acc);
        self.tmp1.assign(&self.tmp2 / &self.den);
        self.tmp1.to_u32().unwrap()
    }

    fn next_term(&mut self, k: u32) {
        let k2 = k * 2 + 1;
        self.tmp1.assign(&self.num * 2u32);
        self.acc += &self.tmp1;
        self.acc *= k2;
        self.den *= k2;
        self.num *= k;
    }

    fn eliminate_digit(&mut self, d: u32) {
        self.tmp1.assign(&self.den * d);
        self.acc -= &self.tmp1;
        self.acc *= 10u32;
        self.num *= 10u32;
    }
}

fn main() -> io::Result<()> {
    let n: usize = std::env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(27);
    let stdout = io::stdout();
    let mut out = io::BufWriter::new(stdout.lock());
    let mut s = Spigot {
        acc: Integer::from(0),
        den: Integer::from(1),
        num: Integer::from(1),
        tmp1: Integer::new(),
        tmp2: Integer::new(),
    };
    let mut line = [0u8; 10];
    let mut i = 0usize;
    let mut k = 0u32;
    while i < n {
        k += 1;
        s.next_term(k);
        if s.num > s.acc {
            continue;
        }
        let d = s.extract_digit(3);
        if d != s.extract_digit(4) {
            continue;
        }
        line[i % 10] = b'0' + d as u8;
        i += 1;
        if i % 10 == 0 {
            out.write_all(&line)?;
            writeln!(out, "\t:{}", i)?;
        }
        s.eliminate_digit(d);
    }
    if i % 10 != 0 {
        for c in line.iter_mut().skip(i % 10) {
            *c = b' ';
        }
        out.write_all(&line)?;
        writeln!(out, "\t:{}", i)?;
    }
    out.flush()
}
