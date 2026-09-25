# pidigits / fortran / st

Own implementation of the reference spigot algorithm, using GMP's mpz C API bound through iso_c_binding (`__gmpz_*` symbols, `mpz_t` declared as a bind(C) struct). Links `-lgmp`.

Single-threaded, no SIMD intrinsics. Build: `gfortran -O2` (GCC 16.2.1).
