# k-nucleotide — C++ (g++) (st track)

Written for this suite (not copied from the Benchmarks Game). Implements the
algorithm from the Benchmarks Game description of k-nucleotide: single-threaded, no
SIMD intrinsics, no inline assembly, no `-march=native`.

Build: `g++ -O2 -std=c++17` (see `build`).

Hash table: `std::unordered_map<uint64_t, uint32_t>`, keys packed two bits per nucleotide. A fresh table is built for each k.

Verified: output identical to the Benchmarks Game expected output at its test
size, and byte-identical to the C `st` cell at the contract small size.
