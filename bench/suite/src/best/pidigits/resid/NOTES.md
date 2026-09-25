# pidigits (Resid, best)

Same program as `../../../st/pidigits/resid/pidigits.resid` (see that
cell's NOTES.md for the algorithm), compiled with `-O3` (the Resid driver
passes `-O3` to clang; it adds no `-march` flag). N = 10000: 0.41 s, the
same as the `-O2` st cell.

No faster Resid variant exists: Resid has no usable parallelism.
`resid_spawn` (spec §19 structured spawn) creates a thread and joins it
immediately before returning (`runtime/resid_rt.c`, `pthread_create`
followed directly by `pthread_join`), so spawned work never runs
concurrently. There are no SIMD types or intrinsics either.
