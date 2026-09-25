// spectral-norm: single-threaded, same algorithm as the Benchmarks Game description.

#[inline]
fn a(i: usize, j: usize) -> f64 {
    1.0 / (((i + j) * (i + j + 1) / 2 + i + 1) as f64)
}

fn mul_av(v: &[f64], out: &mut [f64]) {
    for (i, o) in out.iter_mut().enumerate() {
        let mut sum = 0.0;
        for (j, vj) in v.iter().enumerate() {
            sum += a(i, j) * vj;
        }
        *o = sum;
    }
}

fn mul_atv(v: &[f64], out: &mut [f64]) {
    for (i, o) in out.iter_mut().enumerate() {
        let mut sum = 0.0;
        for (j, vj) in v.iter().enumerate() {
            sum += a(j, i) * vj;
        }
        *o = sum;
    }
}

fn mul_atav(v: &[f64], out: &mut [f64], tmp: &mut [f64]) {
    mul_av(v, tmp);
    mul_atv(tmp, out);
}

fn main() {
    let n: usize = std::env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(100);
    let mut u = vec![1.0f64; n];
    let mut v = vec![0.0f64; n];
    let mut tmp = vec![0.0f64; n];
    for _ in 0..10 {
        mul_atav(&u, &mut v, &mut tmp);
        mul_atav(&v, &mut u, &mut tmp);
    }
    let mut vbv = 0.0;
    let mut vv = 0.0;
    for i in 0..n {
        vbv += u[i] * v[i];
        vv += v[i] * v[i];
    }
    println!("{:.9}", (vbv / vv).sqrt());
}
