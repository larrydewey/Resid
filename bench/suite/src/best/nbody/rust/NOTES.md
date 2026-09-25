# nbody — Rust, best track

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/nbody-rust-9.html
(the fastest Rust program on the Benchmarks Game nbody page at time of
adaptation, 2.19s there). Benchmarks Game programs are distributed under
the revised BSD license (3-clause BSD):
https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html

Source copied verbatim; no code changes. rustc 1.98 warns that `mem::uninitialized` is used on SIMD/array types that "do not permit being left uninitialized" (UB lint); left as is, since output is verified correct.

Program: single-threaded, hand-written AVX `std::arch::x86_64` intrinsics (`__m256d`), converted from C #9.

Build: `rustc -C opt-level=3 -C target-cpu=native -C codegen-units=1` (std only, no Cargo).
Benchmarks Game original command line: `rustc -C opt-level=3 -C target-cpu=ivybridge -C codegen-units=1 ...` (rustc 1.84.1). Deviation: the CPU
target is this host's (`-C target-cpu=native`) instead of the Benchmarks Game host's.

Dependencies: none (std only).

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, sha256-identical to the st cell.
