# spectral-norm (Resid, best)

The single-threaded program (`../../../st/spectral-norm/resid/`, see its NOTES.md for
the algorithm and every workaround) made parallel: each matrix-vector product is cut into 16 row chunks computed by concurrent `spawn` regions; every row is summed in the reference order, so the result is identical to the single-threaded program. Compiled with
`-O3` (the Resid driver adds no `-march` flag; Resid has no SIMD types or
intrinsics).

`spawn` regions run concurrently and are joined before the scope that
started them ends (spec §19). Measured on this host (2026-09-27): 1.14 s -> 0.24 s at 5500
(single-threaded -> this program). Output identical to C.
