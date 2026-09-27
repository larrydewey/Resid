# binary-trees (Resid, best)

The single-threaded program (`../../../st/binary-trees/resid/`, see its NOTES.md for
the algorithm and every workaround) made parallel: each depth level (all do about the same work) builds and checks its trees in its own concurrent `spawn` region; the lines come back in order. Compiled with
`-O3` (the Resid driver adds no `-march` flag; Resid has no SIMD types or
intrinsics).

`spawn` regions run concurrently and are joined before the scope that
started them ends (spec §19). Measured on this host (2026-09-27): 2.1 s -> 0.53 s at 21
(single-threaded -> this program). Output identical to C.
