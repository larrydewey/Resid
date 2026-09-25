# String accumulation benchmark

Builds `"0,1,2,...,N-1,"` by repeated `acc + piece`, the idiomatic
accumulator in each language (Resid has no mutation, so it threads the
accumulator through a self tail call). `c (immutable)` is C with the same
immutable-string semantics: every concatenation allocates and copies.

    bench/strcat/build.sh     # compile the Resid, C, Rust and Go versions
    bench/strcat/run.py [N ...]

`run.py` reports wall time and peak RSS per run and cuts a run off after
`TIMEOUT` seconds (default 30).

Results on 2026-09-25 (`>30s` = cut off; the resid row is after the
`IntToString` pieces were formatted straight into the buffer):

| impl          | 10k          | 100k          | 1M            | 10M           |
|---------------|--------------|---------------|---------------|---------------|
| resid         | 0.005s 12MB  | 0.005s 12MB   | 0.030s 12MB   | 0.294s 78MB   |
| c (immutable) | 0.010s 12MB  | 2.749s 12MB   | >30s          | >30s          |
| rust          | 0.006s 12MB  | 0.005s 12MB   | 0.015s 12MB   | 0.112s 77MB   |
| go            | 0.016s 12MB  | 2.128s 18MB   | >30s          | >30s          |
| node          | 0.026s 58MB  | 0.031s 70MB   | 0.117s 185MB  | 1.208s 971MB  |
| python        | 0.016s 12MB  | 2.415s 12MB   | >30s          | >30s          |
| ruby          | 0.072s 79MB  | 3.131s 79MB   | >30s          | >30s          |
| luajit        | 0.011s 12MB  | 2.556s 12MB   | >30s          | >30s          |

Before `examples/stracc.resid` (in-place accumulators), Resid took 2.25s
and 13.4GB at 50k and 16.2s and 51.8GB at 100k: every step copied the whole
accumulator and nothing was ever freed.
