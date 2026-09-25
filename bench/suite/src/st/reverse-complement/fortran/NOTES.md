# reverse-complement / fortran / st

Own implementation of the reference algorithm (IUB complement table, 60-column lines). Stdin is read whole with libc `read(2)`, output goes out with libc `write(2)`. Ignores argv.

Single-threaded, no SIMD intrinsics. Build: `gfortran -O2` (GCC 16.2.1).
