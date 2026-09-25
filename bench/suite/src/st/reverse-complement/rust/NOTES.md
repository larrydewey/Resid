# reverse-complement — Rust, st track

Written for this suite (not copied from the Benchmarks Game); follows the
Benchmarks Game reverse-complement description, single-threaded, no SIMD intrinsics
or `std::arch`, no `target-cpu` flag.

Build: `rustc --edition 2021 -C opt-level=3`.

Standard library only; reads all of stdin, reverses and complements each sequence via a 256-byte lookup table, re-wraps at 60 columns.

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, to the C st cell and the Rust/Go best cells.
