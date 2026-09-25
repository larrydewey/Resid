# fasta — Rust, best track

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/fasta-rust-7.html
(the fastest Rust program on the Benchmarks Game fasta page at time of
adaptation, 0.78s there). Benchmarks Game programs are distributed under
the revised BSD license (3-clause BSD):
https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html

Source copied verbatim; no code changes.

Program: multithreaded (min(num_cpus, 2) worker threads) with a spin mutex handing out RNG blocks; integer-threshold lookup.

Build: Cargo project, `cargo build --release --locked` with `[profile.release] opt-level=3, codegen-units=1` and `RUSTFLAGS="-C target-cpu=native"`; target dir `out/target`; Cargo.lock committed; crates fetched from crates.io on first build. Edition 2015 (the Benchmarks Game invokes rustc without `--edition`).
Benchmarks Game original command line: `rustc -C opt-level=3 -C target-cpu=ivybridge -C codegen-units=1 ...` (rustc 1.84.1). Deviation: the CPU
target is this host's (`-C target-cpu=native`) instead of the Benchmarks Game host's.

Dependencies: num_cpus 1.17.0, spin 0.9.9 (lockfile).

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, sha256-identical to the st cell.
