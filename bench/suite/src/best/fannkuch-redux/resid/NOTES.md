# fannkuch-redux (Resid, best)

The single-threaded program (`../../../st/fannkuch-redux/resid/`, see its NOTES.md for
the algorithm and every workaround) made parallel: the n blocks of (n-1)! permutations, one per top-level rotation, run on concurrent `spawn` regions; block k starts from the identity rotated k times, and since (n-1)! is even each block's local sign parity is the global one, so the checksums add and the flip counts take the maximum. Compiled with
`-O3` (the Resid driver adds no `-march` flag; Resid has no SIMD types or
intrinsics).

`spawn` regions run concurrently and are joined before the scope that
started them ends (spec §19). Measured on this host (2026-09-27): 15.4 s -> 2.2 s at 12
(single-threaded -> this program). Output identical to C.
