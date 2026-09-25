# pidigits — C++ g++ (best track)

Source: Benchmarks Game C++ g++ #4 program `pidigits-gpp-4`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/pidigits-gpp-4.html
Contributors (per the source header): Alessandro Power
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: fastest C++ g++ program on the pidigits page (gmpxx).

Build command (see `build`): `g++ -pipe -O3 -fomit-frame-pointer -march=native -std=c++14 -g -o out/pidigits pidigits.cpp -lgmp -lgmpxx` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`).

Deviations: none.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
