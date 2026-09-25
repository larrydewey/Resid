# nbody / fortran / st

Own implementation of the Benchmarks Game n-body algorithm (symplectic Euler, 5 bodies, dt 0.01). Energies printed with `f40.9` then left-trimmed, so the leading `0` of `-0.169...` is kept (gfortran `f0.9` would drop it).

Single-threaded, no SIMD intrinsics. Build: `gfortran -O2` (GCC 16.2.1).
