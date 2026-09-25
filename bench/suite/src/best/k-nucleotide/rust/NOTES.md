# k-nucleotide — Rust, best track

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/knucleotide-rust-7.html
(the fastest Rust program on the Benchmarks Game k-nucleotide page at time of
adaptation, 2.57s there). Benchmarks Game programs are distributed under
the revised BSD license (3-clause BSD):
https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html

Source copied verbatim; no code changes.

Program: tokio-threadpool with futures 0.1 tasks, one per k; packed 2-bit keys in `hashbrown` maps.

Build: Cargo project, `cargo build --release --locked` with `[profile.release] opt-level=3, codegen-units=1` and `RUSTFLAGS="-C target-cpu=native"`; target dir `out/target`; Cargo.lock committed; crates fetched from crates.io on first build. Edition 2015 (the Benchmarks Game invokes rustc without `--edition`).
Benchmarks Game original command line: `rustc -C opt-level=3 -C target-cpu=ivybridge -C codegen-units=1 ...` (rustc 1.84.1). Deviation: the CPU
target is this host's (`-C target-cpu=native`) instead of the Benchmarks Game host's.

Dependencies: futures 0.1.31, tokio-threadpool 0.1.18, itertools 0.14.0, num 0.4.3, hashbrown 0.15.5 (lockfile). The Benchmarks Game page does not state crate versions; latest semver-compatible versions of the APIs used were chosen and build without code changes.

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, sha256-identical to the st cell.
