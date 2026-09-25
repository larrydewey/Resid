# fasta / fortran / st

Own implementation of the reference algorithm (LCG seed 42, IM 139968, IA 3877, IC 29573; double-precision cumulative probabilities; 60-column lines). Output is buffered in 64 KiB and flushed with libc `write(2)`.

Single-threaded, no SIMD intrinsics. Build: `gfortran -O2` (GCC 16.2.1).
