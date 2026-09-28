# nbody (Resid, best)

Same program as `../../../st/nbody/resid/nbody.resid` (see that cell's
NOTES.md for the algorithm and every workaround), compiled with `-O3`
`-O3 -march=native`, like the other languages' best cells.

No parallel variant: the algorithm is a sequential time integration (each step depends on the last), so there is nothing for concurrent `spawn`
regions to share. The program uses no vector types: the pair updates are serial, and a
Vec(Float, 4) per body measured slower (1.53 s against 1.18 s).
