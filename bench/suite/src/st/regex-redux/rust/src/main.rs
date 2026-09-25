// regex-redux: single-threaded, same algorithm as the Benchmarks Game description,
// using the customary Rust `regex` crate.
use regex::bytes::Regex;
use std::io::{self, Read, Write};

fn main() -> io::Result<()> {
    let mut input = Vec::new();
    io::stdin().lock().read_to_end(&mut input)?;
    let ilen = input.len();

    let seq = Regex::new(r">.*\n|\n").unwrap().replace_all(&input, &b""[..]).into_owned();
    let clen = seq.len();

    let variants = [
        "agggtaaa|tttaccct",
        "[cgt]gggtaaa|tttaccc[acg]",
        "a[act]ggtaaa|tttacc[agt]t",
        "ag[act]gtaaa|tttac[agt]ct",
        "agg[act]taaa|ttta[agt]cct",
        "aggg[acg]aaa|ttt[cgt]ccct",
        "agggt[cgt]aa|tt[acg]accct",
        "agggta[cgt]a|t[acg]taccct",
        "agggtaa[cgt]|[acg]ttaccct",
    ];
    let stdout = io::stdout();
    let mut out = io::BufWriter::new(stdout.lock());
    for v in variants {
        let count = Regex::new(v).unwrap().find_iter(&seq).count();
        writeln!(out, "{} {}", v, count)?;
    }

    let substs = [
        ("tHa[Nt]", "<4>"),
        ("aND|caN|Ha[DS]|WaS", "<3>"),
        ("a[NSt]|BY", "<2>"),
        ("<[^>]*>", "|"),
        (r"\|[^|][^|]*\|", "-"),
    ];
    let mut s = seq;
    for (pat, rep) in substs {
        s = Regex::new(pat).unwrap().replace_all(&s, rep.as_bytes()).into_owned();
    }
    writeln!(out, "\n{}\n{}\n{}", ilen, clen, s.len())?;
    out.flush()
}
