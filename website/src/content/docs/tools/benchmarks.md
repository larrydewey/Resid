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
fastest of the eleven languages overall (0.85× C) and uses the least memory
(0.85× C); against each language's fastest hand-tuned program it is 0.75× C,
third behind Rust (0.65×) and C++ (0.73×).

## How it was measured

- **Two tracks.** `st`: every language implements the same algorithm,
  single-threaded, no SIMD or `-march=native`, pinned to one core. `best`:
  the fastest known program per language (Benchmarks Game, 3-clause BSD);
  threads, SIMD and `-O3 -march=native` allowed. Resid's `best` programs
  are its `st` programs made parallel with `spawn`, several using vector
  types (`Vec(T, N)`) for SIMD.
- **Timing.** Wall-clock median of 5 cold process runs (fewer for runs
  over 60 s), CPU time and peak RSS from `wait4`. Every output is checked
  byte for byte against the C program's; every run passed.
- **Aggregation.** Each result is divided by C's for the same track, and
  languages are ranked by the geometric mean of those ratios (C = 1.00).
- **Machine.** AMD Ryzen AI 7 PRO 350 (8 cores, 16 threads, mixed core
  types), 54.6 GiB, Linux 7.2, performance governor, every other
  application closed. gcc 16.2, clang 22.1, rustc 1.98, Go 1.27, .NET 10.
- All ten programs ran for all eleven languages on both tracks, so every
  mean below is over the same ten.

## Overall

![Geometric mean of wall time ratio to C, st track](/Resid/benchmarks/geomean-st-official.svg)

| Language | `st` time (× C) | `best` time (× C) | `st` memory (× C) | `best` memory (× C) |
| --- | ---: | ---: | ---: | ---: |
| **Resid** | **0.85** | **0.75** | **0.85** | **4.02** |
| C | 1.00 | 1.00 | 1.00 | 1.00 |
| Fortran | 1.04 | 1.21 | 1.72 | 2.04 |
| Rust | 1.05 | 0.65 | 1.42 | 1.14 |
| C++ | 1.45 | 0.73 | 1.91 | 1.72 |
| C# | 1.63 | 1.32 | 7.85 | 5.29 |
| Java | 1.69 | 1.54 | 11.1 | 10.6 |
| Go | 1.76 | 1.61 | 1.83 | 2.31 |
| JavaScript | 2.06 | 3.62 | 13.7 | 19.0 |
| Pascal | 2.06 | 2.25 | 0.90 | 1.17 |
| Python | 18.6 | 17.4 | 4.07 | 3.96 |

![Geometric mean of wall time ratio to C, best track](/Resid/benchmarks/geomean-best-official.svg)

## Resid against C, program by program

Wall-time ratio to C (below 1.00, Resid is faster):

| Program | `st` | `best` | What decides it |
| --- | ---: | ---: | --- |
| `binary-trees` | **0.30** | **0.16** | allocation: see below |
| `fannkuch-redux` | **0.58** | **0.46** | a packed permutation; byte shuffles in `best` |
| `regex-redux` | **0.60** | 1.70 | `lib/regex.resid`: bit-parallel and DFA scans against PCRE2's JIT |
| `nbody` | **0.77** | 1.07 | the `sqrt` builtin; vector pair distances in `best` |
| `fasta` | **0.95** | **0.26** | a lookup table and a jump-ahead generator in `best` |
| `mandelbrot` | 1.02 | **0.70** | 32 pixels in four `Vec(Float, 8)` in `best` |
| `spectral-norm` | 1.05 | **0.62** | guarded vector loops in `st`; 8 rows per pass, vectorized, in `best` |
| `k-nucleotide` | 1.14 | 1.22 | Resid's hash map against hand-written tables |
| `pidigits` | 1.15 | 1.25 | exact decimals against GMP |
| `reverse-complement` | 1.82 | 2.36 | a byte-at-a-time loop against C's bulk in-place reversal |

## Where Resid is strong

- **Straight-line compiled code.** With the same algorithm, Resid is at or
  ahead of C speed on most programs, and first of the eleven overall: it
  compiles through LLVM to a static binary with no runtime start-up,
  garbage collector or JIT.
- **Allocation-heavy code.** `binary-trees` allocates and discards
  hundreds of millions of tree nodes. Resid releases each short-lived tree
  in one step at the end of the binding that built it (the compiler proves
  nothing else can see it), where C calls `malloc` and `free` per node. On
  the `st` track only Java's generational collector is faster; it beats the
  C, Go, C#, Java and JavaScript `best` programs.
- **Memory.** On the `st` track Resid uses 0.85× C's memory, the least of
  all eleven. Values are unboxed and updated in place when the compiler
  proves they are unshared.
- **`spawn` scales.** Regions run on a pool of reused threads (a spawn
  costs under a microsecond). The `best` programs are the `st` programs
  with `spawn`: fannkuch-redux 15.2 s → 0.96 s, binary-trees 2.0 s →
  0.42 s, spectral-norm 0.82 s → 0.053 s, fasta 2.3 s → 0.14 s and
  mandelbrot 11.1 s → 0.17 s, each of the last three the fastest of all
  languages.
- **Loops over lists vectorize.** A counted loop over a list (spectral-norm's
  rows) runs a second copy under a guard at entry: integer parameters
  small enough for 32-bit arithmetic, the list's elements unboxed. That
  copy has no overflow or bounds checks and vectorizes, keeping float sums
  in source order; when the guard fails the checked loop runs. `st`
  spectral-norm went from 1.50× C to 1.05×.

## Where Resid is weak

- **SIMD on par, mostly not ahead.** With vector types, mandelbrot `best`
  is the fastest of all languages, but fannkuch-redux and nbody `best` are
  within 1–12% of the fastest C++ and Rust programs, not ahead of them.
- **Byte-at-a-time text.** `reverse-complement` builds 250 MB of output
  one character at a time. The builder lives in registers and each read
  is a bounds test and a load, but C reverses the buffer in place with
  bulk operations; Resid is 1.8× C on `st` and 2.4× on `best`.
- **Regular expressions.** `lib/regex.resid` runs a bit-parallel matcher
  for alternatives of fixed-length literals, a literal-prefix prefilter and
  a whole DFA otherwise, with no per-character allocation, but no SIMD
  literal search and no JIT: regex-redux is 0.60× C on `st` but behind
  Rust's `regex` crate (0.36×), and 1.7× C on `best`, where the five
  substitutions run one after another and set the time.
- **Memory on the `best` track.** Parallel Resid programs keep a heap per
  worker and build their outputs as lists and strings, so peak memory
  rises with parallelism (4.0× C, below C#, Java and JavaScript).
- **Hashing.** `k-nucleotide` uses Resid's general `Map`; the fastest
  programs use specialized tables.
- **Binaries.** Resid executables are static and 20–90 KB (about 250 KB
  with the regex engine) against C's 16 KB dynamically linked ones;
  building one takes 2–4 s, most of it clang.

## Read with care

- **`fannkuch-redux` `st`.** Resid has no mutable arrays, so its program
  packs the permutation 4 bits per element into one integer and flips a
  prefix with shifts and masks in constant time instead of swapping
  element by element. The algorithm (which permutations, in which order,
  how flips are counted) is the benchmark's, but the representation is
  unusual, and the 0.58× owes much to it.
- **Vector programs.** The `best` spectral-norm, mandelbrot, nbody and
  fannkuch-redux programs keep every floating-point operation in the
  reference's order, so their output is byte-identical; the `st` programs
  use no vector types and no loop restructuring beyond the reference.
- **Target.** Resid binaries on both tracks target x86-64 with SSSE3,
  SSE4.1 and AES-NI (its runtime needs them); the other languages' `st`
  builds use the plain x86-64 baseline.
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
