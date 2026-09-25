# nbody — C++ g++ (best track)

Source: Benchmarks Game C++ g++ #0 program `nbody-gpp-0`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/nbody-gpp-0.html
Contributors (per the source header): Miles (C), ported to C++ by François-David Collin
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: fastest C++ g++ program on the n-body page (AVX intrinsics).

Build command (see `build`): `g++ -pipe -O3 -fomit-frame-pointer -march=native -std=c++17 -o out/nbody nbody.cpp` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`).

Deviations: none.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
