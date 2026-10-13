Rochus Keller's C port of Are We Fast Yet
(https://github.com/rochus-keller/Are-we-fast-yet, commit in
`../upstream/C-rochus/COMMIT`), used unchanged. Licences: the AWFY
benchmark licences, `../upstream/C-rochus/LICENSE.md`.

It derives from upstream commit 770c6649 (2020-04), through the author's
C++ port; built as its README says (C99, gcc, `-fpermissive -w`).

Two deviations, in the harness only: `Run.c` prints the per-iteration line
(compiled out upstream), and `main` takes the reference harness's
arguments (`<Benchmark> <outer> <inner>`) instead of always running its own
fixed list (marked in `main.c`). A failed verification there `longjmp`s back
and prints `Benchmark failed with incorrect result`; the suite driver
treats a run whose iteration lines are missing as failed.
