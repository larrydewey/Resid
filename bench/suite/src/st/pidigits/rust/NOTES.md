# pidigits — Rust, st track

Written for this suite (not copied from the Benchmarks Game); follows the
Benchmarks Game pidigits description, single-threaded, no SIMD intrinsics
or `std::arch`, no `target-cpu` flag.

Build: `cargo build --release (opt-level=3, default codegen-units)`.

Cargo project. Bignum crate: `rug` 1.30 (GMP bindings, same library as the Benchmarks Game C programs), with `gmp-mpfr-sys` feature `use-system-libs` so it links the host's libgmp instead of building a bundled copy. Only the integer feature is enabled. Cargo.lock is committed; build uses `--locked` and `--target-dir out/target`.

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, to the C st cell and the Rust/Go best cells.
