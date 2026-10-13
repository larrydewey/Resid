# Benchmark suite v2 contract

The rules every program cell in `bench/v2/` follows. The plan and the
reasons behind it are in `PLAN-benchmarks.md` at the repository root.

## Layout

    bench/v2/<tier>/<lang>/          one cell per language for a tier whose
                                     programs share one harness (Tier 1)
    bench/v2/<tier>/<bench>/<lang>/  one cell per program otherwise

Each cell has:

- `build`: an executable bash script (`set -euo pipefail`), run with the
  cell as working directory. It writes everything under `./out/`, is
  idempotent, and may read `$RESID_ROOT` (the repository root).
- `cmd`: one line, the argv to run relative to the cell, without the
  benchmark's own arguments (the harness appends them). No shell syntax.
- `NOTES.md`: where the program came from (URL, commit, licence), every
  deviation from the reference, and who reviewed it.
- `NA` instead of `build`/`cmd` when the cell cannot exist, with the reason.

## Tier 1: Are We Fast Yet

The 14 programs of Marr et al., "Cross-Language Compiler Benchmarking: Are
We Fast Yet?" (DLS 2016), at upstream commit
`74306fec151070fd07157cefeacf19e7e0bcdc89` (`t1-awfy/upstream/COMMIT`).

- Upstream ports (C++, Java, JavaScript, Python) are used unchanged, from
  `t1-awfy/upstream/`.
- Every port follows the AWFY guidelines (`t1-awfy/upstream/guidelines.md`):
  the same structure as the reference, the core language only, no library
  shortcuts. A language without mutable objects keeps the same algorithm and
  the same work per step over values; its NOTES.md names each such mapping.
- The harness interface is the reference's: `harness <Benchmark> <outer>
  <inner>`, printing one `<Benchmark>: iterations=1 runtime: <N>us` line per
  outer iteration, and failing (nonzero exit) on a wrong result.
- Inner iterations are the ReBench values of the reference configuration
  (`rebench.conf`): DeltaBlue 12000, Richards 100, Json 100, CD 250, Havlak
  1500, Bounce 1500, List 1500, Mandelbrot 500, NBody 250000, Permute 1000,
  Queens 1000, Sieve 3000, Storage 1000, Towers 600.

### Two modes

1. **runtime** (the headline): no program's result may be computed while it
   is built. Every input the reference writes as a constant is opaque to the
   compiler (in Resid, marked `rt`). A guard run with other inner iteration
   counts checks that the time scales with the work.
2. **as-written**: the same source with nothing hidden; every compiler may
   evaluate at build time whatever it can. Opponents may submit
   `constexpr`/`comptime` variants, written by their reviewers. Build time is
   reported next to run time, because evaluating at build time moves work
   rather than removing it. Results of this mode are never reported as
   run-time speed.

### What is reported

Per benchmark and language: the first iteration (cold), the median of the
last half of the iterations (steady state), whole-process wall time, peak
resident memory, build time and binary size. Languages are aggregated by
the geometric mean of their steady-state ratio to C++. Every loss is named
in the report's summary, not only the wins.

## Honesty and reproducibility (all tiers)

1. No foldable inputs, except where a tier declares build-time inputs.
2. Outputs are verified (the program's own check, or a checksum against the
   reference language's output).
3. Two flag profiles per compiled language: portable release
   (`-O2`/`--release`, no `-march=native`) and native. No PGO unless every
   language gets it.
4. Toolchain versions, CPU, governor, SMT, THP and core pinning are recorded
   with every run (`env.json`).
5. Statistics: repeated cold process runs, medians with bootstrap 95%
   confidence intervals, geometric means; per-benchmark tables always shown.
6. A port outside the upstream sets names a reviewer fluent in its language
   in NOTES.md; a faster port is accepted at any time.
7. One command per tier (`bench2.py run --tier N`); raw results, the
   environment record and the Resid commit and compiler hash are published
   with the report.
