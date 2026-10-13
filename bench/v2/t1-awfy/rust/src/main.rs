// Are We Fast Yet, Rust port: `harness <Benchmark> [outer [inner]]`, the
// reference harness's interface and output (Run.java).
mod som;
mod small;
mod richards;
mod deltablue;
mod json;
mod cd;
mod havlak;

use std::time::Instant;

fn run(name: &str, inner: i32) -> bool {
    match name {
        "Bounce" => small::bounce_inner(inner),
        "List" => small::list_inner(inner),
        "Mandelbrot" => small::mandelbrot_inner(inner),
        "NBody" => small::nbody_inner(inner),
        "Permute" => small::permute_inner(inner),
        "Queens" => small::queens_inner(inner),
        "Sieve" => small::sieve_inner(inner),
        "Storage" => small::storage_inner(inner),
        "Towers" => small::towers_inner(inner),
        "Richards" => richards::inner(inner),
        "DeltaBlue" => deltablue::inner(inner),
        "Json" => json::inner(inner),
        "CD" => cd::inner(inner),
        "Havlak" => havlak::inner(inner),
        _ => panic!("No benchmark found with the name: {}", name),
    }
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 2 {
        println!("harness benchmark [num-iterations [inner-iter]]");
        std::process::exit(1);
    }
    let name = &args[1];
    let outer: i32 = args.get(2).map(|s| s.parse().unwrap()).unwrap_or(1);
    let inner: i32 = args.get(3).map(|s| s.parse().unwrap()).unwrap_or(1);
    println!("Starting {} benchmark ...", name);
    let mut total: i64 = 0;
    for _ in 0..outer {
        let t0 = Instant::now();
        if !run(name, inner) {
            println!("Benchmark failed with incorrect result");
            std::process::exit(1);
        }
        let us = t0.elapsed().as_micros() as i64;
        println!("{}: iterations=1 runtime: {}us", name, us);
        total += us;
    }
    println!("{}: iterations={} average: {}us total: {}us\n", name, outer, total / outer as i64, total);
    println!("Total Runtime: {}us", total);
}
