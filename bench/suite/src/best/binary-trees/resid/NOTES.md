# binary-trees (Resid, best)

The single-threaded program (`../../../st/binary-trees/resid/`, see its NOTES.md for
the algorithm and every workaround) made parallel: each depth level (all do about the same work) builds and checks its trees in its own concurrent `spawn` region, and the stretch tree is built and checked by another region while the long-lived tree and the levels run; the lines come back in order. Cutting levels further adds CPU time but no speed: the run is bound by memory traffic. Compiled with
`-O3 -march=native`, like the other languages' best cells (Resid has no
SIMD types or intrinsics).

`spawn` regions run concurrently and are joined before the scope that
started them ends (spec §19). Measured on this host (2026-09-27): 2.1 s -> 0.45 s at 21
(single-threaded -> this program). Output identical to C.
