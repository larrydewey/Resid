---
title: Benchmarks
description: Resid against ten other languages on the Computer Language Benchmarks Game programs, with the strengths and the weaknesses.
---

Resid was measured against C, C++, Rust, Go, Java, C#, JavaScript, Python,
Fortran and Pascal on the ten programs of the
[Computer Language Benchmarks Game](https://benchmarksgame-team.pages.debian.net/benchmarksgame/),
at the official problem sizes. The full generated report, with every run,
confidence intervals, build commands and per-program notes, is
[`docs/BENCHMARKS.md`](https://github.com/larrydewey/Resid/blob/master/docs/BENCHMARKS.md);
the suite is in [`bench/suite`](https://github.com/larrydewey/Resid/tree/master/bench/suite).

**In one line:** written the same way as the C program, Resid is the
fastest of the eleven languages overall (0.86× C); against each language's
fastest hand-tuned program it is 0.77× C, third behind Rust and C++, whose
programs use SIMD intrinsics that Resid does not have.

## How it was measured

- **Two tracks.** `st`: every language implements the same algorithm,
  single-threaded, no SIMD or `-march=native`, pinned to one core. `best`:
  the fastest known program per language (Benchmarks Game, 3-clause BSD);
  threads, SIMD and `-O3 -march=native` allowed. Resid's `best` programs
  are its `st` programs made parallel with `spawn`, some laid out so that
  clang's vectorizer can use SIMD registers; Resid has no SIMD types.
- **Timing.** Wall-clock median of 5 cold process runs (fewer for runs
  over 60 s), CPU time and peak RSS from `wait4`. Every output is checked
  byte for byte against the C program's; every run passed.
- **Aggregation.** Each result is divided by C's for the same track, and
  languages are ranked by the geometric mean of those ratios (C = 1.00).
- **Machine.** AMD Ryzen AI 7 PRO 350 (8 cores, 16 threads, mixed core
  types), 54.6 GiB, Linux 7.2, performance governor. gcc 16.2,
  clang 22.1, rustc 1.98, Go 1.27, .NET 10.
- `regex-redux` is not applicable to Resid: it has no regular-expression
  library, and writing one for the benchmark would measure that engine.
  The means below are over the other nine programs.

## Overall

![Geometric mean of wall time ratio to C, st track](/Resid/benchmarks/geomean-st-official.svg)

| Language | `st` time (× C) | `best` time (× C) | `st` memory (× C) | `best` memory (× C) |
| --- | ---: | ---: | ---: | ---: |
| **Resid** | **0.86** | **0.77** | **1.40** | **9.44** |
| C | 1.00 | 1.00 | 1.00 | 1.00 |
| Fortran | 1.05 | 1.17 | 1.90 | 2.18 |
| C++ | 1.14 | 0.69 | 1.99 | 1.71 |
| Rust | 1.19 | 0.63 | 1.48 | 1.20 |
| Go | 1.45 | 1.55 | 2.01 | 2.43 |
| Java | 1.56 | 1.50 | 11.8 | 12.4 |
| C# | 1.68 | 1.31 | 8.17 | 5.70 |
| Pascal | 1.71 | 1.97 | 0.84 | 1.24 |
| JavaScript | 2.21 | 3.54 | 15.6 | 20.9 |
| Python | 22.1 | 22.8 | 4.27 | 4.57 |

![Geometric mean of wall time ratio to C, best track](/Resid/benchmarks/geomean-best-official.svg)

## Resid against C, program by program

Wall-time ratio to C (below 1.00, Resid is faster):

| Program | `st` | `best` | What decides it |
| --- | ---: | ---: | --- |
| `binary-trees` | **0.32** | **0.17** | allocation: see below |
| `fannkuch-redux` | **0.58** | **0.69** | a packed permutation: see below |
| `spectral-norm` | **0.67** | **0.56** | several rows per pass; vectorized in `best` |
| `nbody` | **0.77** | 1.18 | the `sqrt` builtin; C's `best` is SIMD |
| `fasta` | **0.94** | **0.27** | a lookup table and a jump-ahead generator in `best` |
| `mandelbrot` | 1.02 | **0.99** | 16 pixels in lockstep, vectorized in `best` |
| `pidigits` | 1.09 | 1.16 | exact decimals against GMP |
| `k-nucleotide` | 1.14 | 1.59 | Resid's hash map against hand-written tables |
| `reverse-complement` | 2.19 | 2.40 | a byte-at-a-time loop against C's bulk in-place reversal |

## Where Resid is strong

- **Straight-line compiled code.** With the same algorithm, Resid is at or
  ahead of C speed on most programs, and first of the eleven overall: it
  compiles through LLVM to a static binary with no runtime start-up,
  garbage collector or JIT.
- **Allocation-heavy code.** `binary-trees` allocates and discards
  hundreds of millions of tree nodes. Resid releases each short-lived tree
  in one step at the end of the binding that built it (the compiler proves
  nothing else can see it), where C calls `malloc` and `free` per node. It
  beats every language on the `st` track and the C, Go, C#, Java and
  JavaScript `best` programs.
- **Memory.** On the `st` track Resid uses 1.32× C's memory, less than
  every language except C and Pascal. Values are unboxed and updated in
  place when the compiler proves they are unshared.
- **`spawn` scales.** Regions run on a pool of reused threads (a spawn
  costs under a microsecond). The `best` programs are the `st` programs
  with `spawn`: fannkuch-redux 15.2 s → 1.42 s, binary-trees 2.1 s →
  0.47 s, spectral-norm 0.52 s → 0.056 s (the fastest of all languages),
  fasta 2.3 s → 0.14 s (the fastest by 3.5×).

## Where Resid is weak

- **No SIMD types.** Resid's `best` programs reach vector registers only
  through clang's vectorizer (independent lanes written as scalars). The
  fastest C++ and Rust programs for mandelbrot, nbody and fannkuch-redux
  use intrinsics and stay 1.2–1.5× ahead.
- **Byte-at-a-time text.** `reverse-complement` builds 250 MB of output
  one character at a time. The builder lives in registers and each read
  is a bounds test and a load, but C reverses the buffer in place with
  bulk operations; Resid is 2.2× C on `st` and 2.4× on `best`.
- **Memory on the `best` track.** Parallel Resid programs keep a heap per
  worker and build their outputs as lists and strings, so peak memory
  rises with parallelism (9.5× C, still below Java and JavaScript).
- **Hashing.** `k-nucleotide` uses Resid's general `Map`; the fastest
  programs use specialized tables.
- **Binaries.** Resid executables are static and 20–70 KB against C's
  16 KB dynamically linked ones; building one takes about 1.8 s (most of it
  clang).

## Read with care

- **`fannkuch-redux` `st`.** Resid has no mutable arrays, so its program
  packs the permutation 4 bits per element into one integer and flips a
  prefix with shifts and masks in constant time instead of swapping
  element by element. The algorithm (which permutations, in which order,
  how flips are counted) is the benchmark's, but the representation is
  unusual, and the 0.58× owes much to it.
- **Lanes.** The spectral-norm and mandelbrot programs compute several
  rows or pixels in one loop as independent scalars, each in the
  reference order, so results are identical; in `best` clang packs them
  into vector registers. The Benchmarks Game C programs do the same with
  intrinsics.
- **`binary-trees`.** Resid's win comes from its memory model (a
  short-lived tree is released as a whole), not from faster per-node code;
  a C program using an arena allocator would close the gap, and the
  Benchmarks Game's C++ and Rust `best` programs do.
- **`pidigits`** has no bignum type in Resid: it uses exact `Dec(N)`
  decimals, compared with GMP in C.
- One machine, cold process runs, frequency boost enabled, background load
  not stopped. The per-run spread is in the full report.
- Program quality differs: `best` programs come from different authors
  with different tuning effort; the Resid programs were written for this
  suite.

## Reproducing

```sh
cd bench/suite
./bench.py env && ./bench.py build && ./bench.py inputs
./bench.py run --size official     # about 2.5 hours on the machine above
./bench.py report                  # docs/BENCHMARKS.md and docs/benchmarks/
```

`./bench.py run --size small` takes a few minutes.
