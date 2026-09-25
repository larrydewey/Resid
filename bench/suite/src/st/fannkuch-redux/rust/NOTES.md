# fannkuch-redux — Rust, st track

Written for this suite (not copied from the Benchmarks Game); follows the
Benchmarks Game fannkuch-redux description, single-threaded, no SIMD intrinsics
or `std::arch`, no `target-cpu` flag.

Build: `rustc --edition 2021 -C opt-level=3`.

Standard library only; one pass over all n! permutations in the reference generation order.

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, to the C st cell and the Rust/Go best cells.
