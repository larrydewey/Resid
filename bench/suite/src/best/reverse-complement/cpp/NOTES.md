# reverse-complement — C++ g++ (best track)

Source: Benchmarks Game C++ g++ #2 program `revcomp-gpp-2`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/revcomp-gpp-2.html
Contributors (per the source header): Adam Kewley
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: fastest C++ g++ program on the reverse-complement page (SIMD shuffle path).

Build command (see `build`): `g++ -pipe -O3 -fomit-frame-pointer -march=native -DSIMD -std=c++11 -o out/reverse-complement reverse-complement.cpp` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`).

Deviations: none.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
