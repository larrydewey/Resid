# spectral-norm (Resid, best)

The single-threaded program's algorithm (`../../../st/spectral-norm/resid/`,
see its NOTES.md), made parallel: each matrix-vector product is cut into 16
row chunks computed by concurrent `spawn` regions. Inside a chunk, 8 rows
are computed at once as 8 independent sums (each in the reference order
over j), which clang's SLP vectorizer packs into AVX-512 registers with
`-march=native`, like the other languages' best cells. Every row is summed in the reference order, so the result is
identical to the single-threaded program.

Measured on this host (2026-09-27): 0.055 s at 5500 (was 0.24 s with one
row at a time and Int indices). Output identical to C.
