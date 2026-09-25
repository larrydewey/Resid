# fannkuch-redux — Rust, best track

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/fannkuchredux-rust-6.html
(the fastest Rust program on the Benchmarks Game fannkuch-redux page at time of
adaptation, 3.81s there). Benchmarks Game programs are distributed under
the revised BSD license (3-clause BSD):
https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html

Source copied verbatim; no code changes.

Program: rayon parallel over permutation blocks, SSSE3 `_mm_shuffle_epi8` byte shuffles for flips.

Build: Cargo project, `cargo build --release --locked` with `[profile.release] opt-level=3, codegen-units=1` and `RUSTFLAGS="-C target-cpu=native"`; target dir `out/target`; Cargo.lock committed; crates fetched from crates.io on first build. Edition 2015 (the Benchmarks Game invokes rustc without `--edition`).
Benchmarks Game original command line: `rustc -C opt-level=3 -C target-cpu=ivybridge -C codegen-units=1 ...` (rustc 1.84.1). Deviation: the CPU
target is this host's (`-C target-cpu=native`) instead of the Benchmarks Game host's.

Dependencies: rayon 1.12.0 (lockfile).

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, sha256-identical to the st cell.
