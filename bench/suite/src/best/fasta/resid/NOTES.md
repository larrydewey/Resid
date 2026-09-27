# fasta (Resid, best)

Same program as `../../../st/fasta/resid/fasta.resid` (see that cell's
NOTES.md for the algorithm and every workaround), compiled with `-O3`
(the Resid driver passes `-O3` to clang; it adds no `-march` flag).

No parallel variant: the output is defined by one sequential random-number stream, so there is nothing for concurrent `spawn`
regions to share. Resid has no SIMD types or intrinsics either.
