# k-nucleotide / fortran / st

Own implementation. Fortran has no standard or customary hash table library, so the program carries a small open-addressing hash table (linear probing, keys packed 2 bits per base into int64). One table is built per frame length (1, 2, 3, 4, 6, 12, 18), one after the other. Stdin is read whole with libc `read(2)`. Ignores argv.

Single-threaded, no SIMD intrinsics. Build: `gfortran -O2` (GCC 16.2.1).
