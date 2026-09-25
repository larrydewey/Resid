# Cross-language benchmark suite

The ten Computer Language Benchmarks Game programs in Resid and ten other
languages (C, C++, Rust, Go, Java, C#, JavaScript, Python, Fortran, Pascal),
in two tracks:

- `st`: single-threaded, same algorithm, standard release flags, pinned to one CPU.
- `best`: fastest known program per language (threads, SIMD and `-march=native` allowed).

`bench.py` builds every program, runs it, checks its output against the C `st`
reference and writes a report to [`docs/BENCHMARKS.md`](../../docs/BENCHMARKS.md),
with SVG charts and CSV data under `docs/benchmarks/`. It needs only Python 3
(standard library) plus a C compiler, which it uses once to build a small
launcher (`results/tools/memrun-*`) for accurate peak-RSS measurement.

## Running

```sh
cd bench/suite
./bench.py all                      # env, build, inputs, run small, run official, report
```

Or step by step:

```sh
./bench.py env                      # CPU, RAM, kernel, governor, THP, SMT, toolchain versions,
                                    # Resid commit and stage2.bin sha256 -> results/env.json
./bench.py build [--track st] [--bench nbody,fasta] [--lang resid,c]
                                    # cold build (out/ removed first) -> results/builds.json
./bench.py inputs                   # fasta stdin inputs -> results/inputs/ (cached by sha256)
./bench.py run --size small         # timed runs -> results/runs.jsonl (resumable)
./bench.py run --size official
./bench.py report                   # docs/BENCHMARKS.md, docs/benchmarks/*.svg, *.csv
```

Useful `run` options:

| Option | Default | Meaning |
|---|---|---|
| `--track`, `--bench`, `--lang` | all | comma-separated filters |
| `--size official\|small` | small | problem size (see CONTRACT.md) |
| `--runs N` | 5 | runs per cell; 3 if the first run takes > 60 s, 1 if > 300 s |
| `--timeout S` | 1800 official, 300 small | wall-clock limit per run; kills the process group |
| `--mem-limit-gb G` | 16 | memory limit (0 disables) |
| `--mem-policy lang=mode,...` | java, csharp, javascript = `poll` | `rlimit` (RLIMIT_AS), `poll` (sample RSS from /proc, kill over limit) or `none` |
| `--force` | off | rerun cells that already have a complete batch |
| `--no-reference` | off | do not run the C `st` reference cell automatically |
| `--tmpdir DIR` | system temp | where program stdout is captured |

Global options (before the subcommand): `--core N` (CPU for the `st` track,
default 2), `--src`, `--results`, `--docs` (override paths, e.g. to test the
harness on a scratch cell tree).

`run` is resumable: a cell is skipped when its latest batch for that size is
complete and its sources (excluding `NOTES.md`) are unchanged. It builds cells
whose build is missing, failed or out of date, and always runs the C `st` cell
of each selected benchmark first, because that output is the correctness
reference. The report uses the latest batch of each cell and marks cells whose
sources changed after they ran as *stale*.

## Cells

See [CONTRACT.md](CONTRACT.md). In short, each program is
`src/<track>/<bench>/<lang>/` with a `build` script (writes to `out/`), a
one-line `cmd` (argv without the size argument), an optional `NOTES.md`
(provenance, licence, deviations), or an `NA` file giving the reason the cell
cannot exist. The harness appends the size argument, feeds stdin benchmarks
(k-nucleotide, reverse-complement, regex-redux) from generated fasta output,
and compares the sha256 of stdout with the C `st` cell.

## What is recorded

- `results/env.json`, `builds.json`, `inputs.json`, `runs.jsonl` are committed.
  `runs.jsonl` has one line per timed run: wall, user and sys time, peak RSS,
  exit status, stdout sha256, verdict, git commit, environment id.
- `results/inputs/`, `results/logs/` (build logs, stderr tails, first 4 KB of
  mismatching output) and `results/tools/` are gitignored.

## Time expectations

On the reference host (8-core Ryzen AI 7 PRO 350):

- `build` for all cells: about 5–15 minutes, dominated by Rust, C# and Resid.
- `run --size small`: roughly 30–60 minutes; Python and other interpreted
  programs dominate.
- `run --size official`: several hours (expect 6–10). Slow interpreted cells
  drop to 3 runs or 1 run automatically and may hit the 1800 s timeout, which
  the report shows as a timeout rather than a result.
- `report`: a few seconds.

Use filters (`--lang resid,c --bench nbody`) while iterating.
