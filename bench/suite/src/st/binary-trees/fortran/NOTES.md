# binary-trees / fortran / st

Own implementation of the reference algorithm. Each node is allocated with `allocate` and freed with `deallocate`; there is no pool or arena.

Single-threaded, no SIMD intrinsics. Build: `gfortran -O2` (GCC 16.2.1).
