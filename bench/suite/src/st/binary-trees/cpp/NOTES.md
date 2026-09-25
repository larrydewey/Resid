# binary-trees — C++ (g++) (st track)

Written for this suite (not copied from the Benchmarks Game). Implements the
algorithm from the Benchmarks Game description of binary-trees: single-threaded, no
SIMD intrinsics, no inline assembly, no `-march=native`.

Build: `g++ -O2 -std=c++17` (see `build`).

Memory: every node is allocated with `new` and released with `delete` (no pools or arenas).

Verified: output identical to the Benchmarks Game expected output at its test
size, and byte-identical to the C `st` cell at the contract small size.
