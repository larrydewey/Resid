// fannkuch-redux: single-threaded, same algorithm as the Benchmarks Game description
// (permutations generated in the reference order, checksum alternates sign).

fn fannkuch(n: usize) -> (i64, i32) {
    let mut perm1: Vec<usize> = (0..n).collect();
    let mut perm = vec![0usize; n];
    let mut count = vec![0usize; n];
    let mut max_flips = 0i32;
    let mut checksum = 0i64;
    let mut perm_count = 0i64;
    let mut r = n;
    loop {
        while r != 1 {
            count[r - 1] = r;
            r -= 1;
        }
        perm.copy_from_slice(&perm1);
        let mut flips = 0i32;
        let mut k = perm[0];
        while k != 0 {
            perm[..=k].reverse();
            flips += 1;
            k = perm[0];
        }
        if flips > max_flips {
            max_flips = flips;
        }
        checksum += if perm_count % 2 == 0 { flips as i64 } else { -(flips as i64) };
        // Next permutation.
        loop {
            if r == n {
                return (checksum, max_flips);
            }
            let perm0 = perm1[0];
            for i in 0..r {
                perm1[i] = perm1[i + 1];
            }
            perm1[r] = perm0;
            count[r] -= 1;
            if count[r] > 0 {
                break;
            }
            r += 1;
        }
        perm_count += 1;
    }
}

fn main() {
    let n: usize = std::env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(7);
    let (checksum, max_flips) = fannkuch(n);
    println!("{}\nPfannkuchen({}) = {}", checksum, n, max_flips);
}
