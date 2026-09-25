# regex-redux — C++ (g++) (st track)

Written for this suite (not copied from the Benchmarks Game). Implements the
algorithm from the Benchmarks Game description of regex-redux: single-threaded, no
SIMD intrinsics, no inline assembly, no `-march=native`.

Build: `g++ -O2 -std=c++17` (see `build`).

Regex library: `std::regex` (ECMAScript grammar, libstdc++). It finishes the contract small size (fasta 500000 output as input) in about 2 s and the official size (fasta 5000000 input) in about 26 s on this host, so PCRE2 was not needed. The first clean-up pattern is written `>[^\n]*\n|\n` (equivalent to the reference `>.*\n|\n`, since ECMAScript `.` never matches a newline).

Verified: output identical to the Benchmarks Game expected output at its test
size, and byte-identical to the C `st` cell at the contract small size.
