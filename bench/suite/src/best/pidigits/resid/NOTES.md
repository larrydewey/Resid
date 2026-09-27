# pidigits (Resid, best)

Same program as `../../../st/pidigits/resid/pidigits.resid` (see that
cell's NOTES.md for the algorithm), compiled with `-O3` (the Resid driver
passes `-O3 -march=native` to clang). N = 10000: 0.41 s, the
same as the `-O2` st cell.

No parallel variant: each digit depends on the previous state of the spigot, so there is nothing for concurrent `spawn`
regions to share. Resid has no SIMD types or intrinsics either.
