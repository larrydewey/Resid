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
fastest of the eleven languages overall (0.97× C) and uses the least memory
(0.81× C); against each language's fastest hand-tuned program it is 0.83× C,
third behind Rust (0.66×) and C++ (0.73×).

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
  types), 54.6 GiB, Linux 7.2, performance governor. gcc 16.2,
  clang 22.1, rustc 1.98, Go 1.27, .NET 10.
- All ten programs ran for all eleven languages on both tracks, so every
  mean below is over the same ten.

## Overall

![Geometric mean of wall time ratio to C, st track](/Resid/benchmarks/geomean-st-official.svg)

| Language | `st` time (× C) | `best` time (× C) | `st` memory (× C) | `best` memory (× C) |
| --- | ---: | ---: | ---: | ---: |
| **Resid** | **0.97** | **0.83** | **0.81** | **3.71** |
| C | 1.00 | 1.00 | 1.00 | 1.00 |
| Fortran | 1.04 | 1.21 | 1.71 | 2.02 |
| Rust | 1.05 | 0.66 | 1.42 | 1.18 |
| C++ | 1.44 | 0.73 | 1.91 | 1.70 |
| C# | 1.62 | 1.30 | 7.81 | 5.19 |
| Java | 1.70 | 1.53 | 11.1 | 10.4 |
| Go | 1.76 | 1.59 | 1.91 | 2.45 |
| JavaScript | 2.04 | 3.59 | 13.7 | 18.9 |
| Pascal | 2.05 | 2.24 | 0.89 | 1.16 |
| Python | 18.5 | 17.3 | 4.05 | 3.93 |

![Geometric mean of wall time ratio to C, best track](/Resid/benchmarks/geomean-best-official.svg)

## Resid against C, program by program

Wall-time ratio to C (below 1.00, Resid is faster):

| Program | `st` | `best` | What decides it |
| --- | ---: | ---: | --- |
| `binary-trees` | **0.32** | **0.17** | allocation: see below |
| `fannkuch-redux` | **0.58** | **0.46** | a packed permutation; byte shuffles in `best` |
| `nbody` | **0.77** | 1.07 | the `sqrt` builtin; vector pair distances in `best` |
| `fasta` | **0.96** | **0.28** | a lookup table and a jump-ahead generator in `best` |
| `mandelbrot` | 1.02 | **0.80** | 32 pixels in four `Vec(Float, 8)` in `best` |
| `pidigits` | 1.09 | 1.25 | exact decimals against GMP |
| `k-nucleotide` | 1.14 | 1.29 | Resid's hash map against hand-written tables |
| `regex-redux` | 1.48 | 3.41 | `lib/regex.resid`'s DFA against PCRE2's JIT |
| `spectral-norm` | 1.50 | **0.63** | one row at a time in `st`; 8 rows per pass, vectorized, in `best` |
| `reverse-complement` | 1.96 | 2.43 | a byte-at-a-time loop against C's bulk in-place reversal |

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
- **Memory.** On the `st` track Resid uses 0.81× C's memory, the least of
  all eleven. Values are unboxed and updated in place when the compiler
  proves they are unshared.
- **`spawn` scales.** Regions run on a pool of reused threads (a spawn
  costs under a microsecond). The `best` programs are the `st` programs
  with `spawn`: fannkuch-redux 15.1 s → 0.96 s, binary-trees 2.2 s →
  0.46 s, spectral-norm 1.17 s → 0.055 s (the fastest of all languages),
  fasta 2.3 s → 0.15 s (the fastest by 3.4×).

## Where Resid is weak

- **SIMD on par, not ahead.** With vector types, mandelbrot, fannkuch-redux
  and nbody `best` are within 1–12% of the fastest C++ and Rust programs,
  not ahead of them.
- **Byte-at-a-time text.** `reverse-complement` builds 250 MB of output
  one character at a time. The builder lives in registers and each read
  is a bounds test and a load, but C reverses the buffer in place with
  bulk operations; Resid is 2.0× C on `st` and 2.4× on `best`.
- **Regular expressions.** `lib/regex.resid` builds a DFA ahead of time and
  runs it with no per-character allocation, but it has no JIT: regex-redux
  is 1.5× C on `st` (Rust's `regex` crate is 0.36×) and 3.4× on `best`,
  where the five substitutions run one after another and set the time.
- **Memory on the `best` track.** Parallel Resid programs keep a heap per
  worker and build their outputs as lists and strings, so peak memory
  rises with parallelism (3.7× C, below Python, C#, Java and JavaScript).
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
