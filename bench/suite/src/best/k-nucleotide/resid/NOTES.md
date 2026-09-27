# k-nucleotide (Resid, best)

The single-threaded program (`../../../st/k-nucleotide/resid/`, see its NOTES.md for
the algorithm and every workaround) made parallel: the seven tables (k = 1, 2 and the five fragments) are counted by seven concurrent `spawn` regions over the shared sequence text. Compiled with
`-O3` (the Resid driver adds no `-march` flag; Resid has no SIMD types or
intrinsics).

`spawn` regions run concurrently and are joined before the scope that
started them ends (spec §19). Measured on this host (2026-09-27): 5.9 s -> 2.0 s on the official input
(single-threaded -> this program). Output identical to C.
