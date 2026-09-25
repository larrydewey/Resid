# mandelbrot / fortran / st

Own implementation of the reference algorithm (50 iterations, escape |z|^2 > 4, rows padded to whole bytes). The binary PBM goes to stdout through libc `write(2)` bound with iso_c_binding, since Fortran formatted I/O cannot emit raw bytes portably.

Single-threaded, no SIMD intrinsics. Build: `gfortran -O2` (GCC 16.2.1).
