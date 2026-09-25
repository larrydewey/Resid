# fasta — C (gcc) (st track)

Written for this suite (not copied from the Benchmarks Game). Implements the
algorithm from the Benchmarks Game description of fasta: single-threaded, no
SIMD intrinsics, no inline assembly, no `-march=native`.

Build: `gcc -O2` (see `build`).

Random selection uses a linear scan over the cumulative probabilities in `double`, as in the description. This output also serves as the stdin input for k-nucleotide, reverse-complement and regex-redux.

This cell is the harness reference: every other language's output is compared
against its stdout (sha256).

Verified: output identical to the Benchmarks Game expected output at its test
size, and byte-identical to the C `st` cell at the contract small size.
