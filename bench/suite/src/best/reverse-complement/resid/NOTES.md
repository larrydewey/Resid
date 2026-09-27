# reverse-complement (Resid, best)

The single-threaded program (`../../../st/reverse-complement/resid/`, see its NOTES.md for
the algorithm and every workaround) made parallel: each sequence (header plus reverse complement) is built by its own concurrent `spawn` region; the input has three sequences, so the gain is small and the run stays dominated by reading and writing. Compiled with
`-O3` (the Resid driver adds no `-march` flag; Resid has no SIMD types or
intrinsics).

`spawn` regions run concurrently and are joined before the scope that
started them ends (spec §19). Measured on this host (2026-09-27): 0.46 s -> 0.41 s on the official input
(single-threaded -> this program). Output identical to C.
