# spectral-norm / fortran / st

Own implementation of the reference algorithm (10 iterations of AtA*u, A(i,j) = 1/((i+j)(i+j+1)/2+i+1)).

Single-threaded, no SIMD intrinsics. Build: `gfortran -O2` (GCC 16.2.1).
