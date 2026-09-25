# mandelbrot — C (gcc) (st track)

Written for this suite (not copied from the Benchmarks Game). Implements the
algorithm from the Benchmarks Game description of mandelbrot: single-threaded, no
SIMD intrinsics, no inline assembly, no `-march=native`.

Build: `gcc -O2` (see `build`).

Output is a binary PBM (P4). Built without `-march=native`, so no FMA contraction; pixel values match the reference exactly.

This cell is the harness reference: every other language's output is compared
against its stdout (sha256).

Verified: output identical to the Benchmarks Game expected output at its test
size, and byte-identical to the C `st` cell at the contract small size.
