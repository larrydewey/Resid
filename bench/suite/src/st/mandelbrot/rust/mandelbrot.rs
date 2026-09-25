// mandelbrot: single-threaded, same algorithm as the Benchmarks Game description.
// Writes a binary PBM (P4) bitmap of the Mandelbrot set to stdout.
use std::io::Write;

fn main() {
    let n: usize = std::env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(200);
    let (w, h) = (n, n);
    let iter = 50;
    let limit2 = 4.0f64;
    let row_bytes = (w + 7) / 8;
    let mut out = Vec::with_capacity(row_bytes * h + 32);
    write!(out, "P4\n{} {}\n", w, h).unwrap();
    for y in 0..h {
        let ci = 2.0 * y as f64 / h as f64 - 1.0;
        let mut byte: u8 = 0;
        let mut bit_num = 0;
        for x in 0..w {
            let cr = 2.0 * x as f64 / w as f64 - 1.5;
            let (mut zr, mut zi, mut tr, mut ti) = (0.0f64, 0.0f64, 0.0f64, 0.0f64);
            let mut i = 0;
            while i < iter && tr + ti <= limit2 {
                zi = 2.0 * zr * zi + ci;
                zr = tr - ti + cr;
                tr = zr * zr;
                ti = zi * zi;
                i += 1;
            }
            byte <<= 1;
            if tr + ti <= limit2 {
                byte |= 1;
            }
            bit_num += 1;
            if bit_num == 8 {
                out.push(byte);
                byte = 0;
                bit_num = 0;
            } else if x == w - 1 {
                byte <<= 8 - w % 8;
                out.push(byte);
                byte = 0;
                bit_num = 0;
            }
        }
    }
    std::io::stdout().write_all(&out).unwrap();
}
