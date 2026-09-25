# spectral-norm — Rust, st track

Written for this suite (not copied from the Benchmarks Game); follows the
Benchmarks Game spectral-norm description, single-threaded, no SIMD intrinsics
or `std::arch`, no `target-cpu` flag.

Build: `rustc --edition 2021 -C opt-level=3`.

Standard library only; scalar loops, A(i,j) recomputed on the fly.

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, to the C st cell and the Rust/Go best cells.
