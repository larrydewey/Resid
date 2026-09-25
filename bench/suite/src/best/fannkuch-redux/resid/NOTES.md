# fannkuch-redux (Resid, best)

Same program as `../../../st/fannkuch-redux/resid/fannkuchredux.resid` (see that cell's
NOTES.md for the algorithm and every workaround), compiled with `-O3`
(the Resid driver passes `-O3` to clang; it adds no `-march` flag).

No faster Resid variant exists: Resid has no usable parallelism.
`resid_spawn` (spec §19 structured spawn) creates a thread and joins it
immediately before returning (`runtime/resid_rt.c:1357`, `pthread_create`
followed directly by `pthread_join`), so spawned work never runs
concurrently. There are no SIMD types or intrinsics either.
