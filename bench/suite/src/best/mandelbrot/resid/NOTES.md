# mandelbrot (Resid, best)

The single-threaded program (`../../../st/mandelbrot/resid/`, see its NOTES.md for
the algorithm and every workaround) made parallel: the image is cut into bands of 32 rows; waves of 16 bands (the host's hardware threads) are computed by concurrent `spawn` regions, started through a recursion that waits for each band on the way back so the bands are printed in order. Compiled with
`-O3` (the Resid driver adds no `-march` flag; Resid has no SIMD types or
intrinsics).

`spawn` regions run concurrently and are joined before the scope that
started them ends (spec §19). Measured on this host (2026-09-27): 11.1 s -> 1.36 s at 16000
(single-threaded -> this program). Output identical to C.
