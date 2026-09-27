# nbody (Resid, best)

Same program as `../../../st/nbody/resid/nbody.resid` (see that cell's
NOTES.md for the algorithm and every workaround), compiled with `-O3`
(the Resid driver passes `-O3` to clang; it adds no `-march` flag).

No parallel variant: the algorithm is a sequential time integration (each step depends on the last), so there is nothing for concurrent `spawn`
regions to share. Resid has no SIMD types or intrinsics either.
