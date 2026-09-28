# fannkuch-redux (Resid, best)

The single-threaded program (`../../../st/fannkuch-redux/resid/`, see its NOTES.md for
the algorithm and every workaround) made parallel: the n * (n-1) blocks of (n-2)! permutations, one per pair of top-level rotations, run on concurrent `spawn` regions (132 at n = 12, so 16 hardware threads stay busy to the end); block (k1, k2) starts from the identity with the first n elements rotated k1 times and then the first n-1 rotated k2 times, and since (n-2)! is even each block's local sign parity is the global one, so the checksums add and the flip counts take the maximum. Within a block the permutation is a `Vec(Int(8), 16)` (spec §46): a flip
of the first k + 1 elements is one byte shuffle (pshufb) with the index
vector `select(l <= k, k - l, l)`, and the next-permutation rotation is
another. Compiled with `-O3 -march=native`, like the other languages'
best cells.

`spawn` regions run concurrently and are joined before the scope that
started them ends (spec §19). Measured on this host (2026-09-27): 15.2 s -> 0.98 s at 12 (1.41 s with the nibble-packed permutation, 1.92 s with n blocks)
(single-threaded -> this program). Output identical to C.
