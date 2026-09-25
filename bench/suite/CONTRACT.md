# Benchmark suite layout contract

Everything under `bench/suite/`. Every program cell is one directory:

    bench/suite/src/<track>/<bench>/<lang>/

- `<track>`: `st` (single-thread, same algorithm) or `best` (fastest known
  program per language, as on the Computer Language Benchmarks Game).
- `<bench>`: `nbody fannkuch-redux spectral-norm mandelbrot binary-trees
  fasta k-nucleotide reverse-complement pidigits regex-redux`
- `<lang>`: `resid c cpp rust go java csharp javascript python fortran pascal`

Each cell contains:

- source file(s)
- `build` — executable bash script (`#!/usr/bin/env bash`, `set -euo pipefail`),
  run with cwd = cell dir. Writes all artifacts under `./out/` (create it).
  Must be idempotent. Interpreted languages may just `mkdir -p out`.
  Absolute repo root is available as `$RESID_ROOT` (harness exports it;
  scripts may fall back to `$(git rev-parse --show-toplevel)`).
- `cmd` — ONE line: the argv to run, relative to cell dir, WITHOUT the
  benchmark size argument (harness appends it). Example: `./out/nbody` or
  `java -cp out nbody` or `python3 nbody.py`. No shell syntax (no pipes,
  redirects, env assignments). Harness execs it directly with cwd = cell dir.
  Input files arrive on stdin (harness redirects from a regular file).
- `NOTES.md` (optional) — deviations, provenance URL + license of adapted
  Benchmarks Game program, why N/A.
- `NA` (instead of build/cmd) — file whose text is a one-paragraph reason the
  cell cannot exist (e.g. "Resid has no regex engine"). Harness reports N/A.

## Tracks

`st`: every language implements the SAME algorithm as the reference
Benchmarks Game description, single-threaded, no SIMD intrinsics, no inline
assembly, no `-march=native`, standard release optimisation:
C/C++ `gcc/g++ -O2`, Rust `rustc -C opt-level=3` (or cargo `--release`),
Go default, Java default HotSpot, C# `dotnet` Release, Fortran
`gfortran -O2`, Pascal `fpc -O2`, Resid default (`-O2`), JS `node`, Python
`python3` (CPython). Bignum (pidigits): language's standard/customary library
(Python int, Java BigInteger, C# System.Numerics.BigInteger, Go math/big,
JS BigInt, C/C++/Fortran/Pascal GMP via its C API, Rust `num-bigint` or
`rug`). Regex (regex-redux): language's standard/customary library
(C/C++ PCRE2 or std::regex noted, Rust `regex` crate, etc.).

`best`: fastest program known for that language, multithreading/SIMD
allowed, flags as the Benchmarks Game uses (`-O3 -march=native`, `-fopenmp`,
etc.). Adapt from benchmarksgame-team.pages.debian.net sources (3-clause BSD);
record the source URL in NOTES.md.

## Sizes (argument appended by harness)

| bench | official | small | stdin input |
|---|---|---|---|
| nbody | 50000000 | 5000000 | – |
| fannkuch-redux | 12 | 10 | – |
| spectral-norm | 5500 | 1000 | – |
| mandelbrot | 16000 | 4000 | – (binary PBM on stdout) |
| binary-trees | 21 | 16 | – |
| fasta | 25000000 | 2500000 | – |
| k-nucleotide | 0 | 0 | fasta output (official 25000000, small 2500000) |
| reverse-complement | 0 | 0 | fasta output (official 25000000, small 2500000) |
| pidigits | 10000 | 2000 | – |
| regex-redux | 0 | 0 | fasta output (official 5000000, small 500000) |

Programs for stdin benchmarks must ignore argv (harness still passes `0`).
Output must be byte-identical to the Benchmarks Game expected output
(harness compares stdout sha256 against the C `st` cell).

## Toolchains on this host

gcc/g++ 16.2.1, clang 22.1.8, gfortran 16.2.1, fpc 3.2.2, rustc/cargo 1.98.0,
go 1.27.0, openjdk 26.0.2, dotnet SDK 10.0.111, node 26.5.0, CPython 3.14.7,
GMP + PCRE2 headers installed, OpenMP available. Resid compiler:
`$RESID_ROOT/build/boot/stage2.bin file.resid -o out/prog` (run from
`$RESID_ROOT`; accepts `-O0..-O3`).
