# regex-redux — Rust, st track

Written for this suite (not copied from the Benchmarks Game); follows the
Benchmarks Game regex-redux description, single-threaded, no SIMD intrinsics
or `std::arch`, no `target-cpu` flag.

Build: `cargo build --release (opt-level=3, default codegen-units)`.

Cargo project. Regex engine: `regex` crate 1.x (`regex::bytes::Regex`), the customary Rust regex library. Patterns compiled and applied sequentially on one thread. Cargo.lock is committed; build uses `--locked` and `--target-dir out/target`.

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, to the C st cell and the Rust/Go best cells.
