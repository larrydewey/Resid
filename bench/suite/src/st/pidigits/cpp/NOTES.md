# pidigits — C++ (g++) (st track)

Written for this suite (not copied from the Benchmarks Game). Implements the
algorithm from the Benchmarks Game description of pidigits: single-threaded, no
SIMD intrinsics, no inline assembly, no `-march=native`.

Build: `g++ -O2 -std=c++17` (see `build`).

Bignum library: GMP through its C API (`mpz_*`, `-lgmp`), step-by-step spigot exactly as in the description (no gmpxx).

Verified: output identical to the Benchmarks Game expected output at its test
size, and byte-identical to the C `st` cell at the contract small size.
