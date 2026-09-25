# fannkuch-redux — C++ g++ (best track)

Source: Benchmarks Game C++ g++ #6 program `fannkuchredux-gpp-6`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/fannkuchredux-gpp-6.html
Contributors (per the source header): Andrei Simion (with patch from Vincent Yu), based on C++ g++ #5 by Dave Compton
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: fastest C++ g++ program on the fannkuch-redux page (OpenMP, SSE).

Build command (see `build`): `g++ -pipe -O3 -fomit-frame-pointer -march=native -std=c++17 -fopenmp -o out/fannkuch-redux fannkuch-redux.cpp` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`).

Deviations: none.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
