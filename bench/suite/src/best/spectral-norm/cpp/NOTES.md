# spectral-norm — C++ g++ (best track)

Source: Benchmarks Game C++ g++ #6 program `spectralnorm-gpp-6`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/spectralnorm-gpp-6.html
Contributors (per the source header): Sebastien Loisel (C), Jon Harrop (C++), The Anh Tran (OpenMP, SSE), Krzysztof Jakubowski (SSE)
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: fastest C++ g++ program on the spectral-norm page (OpenMP, SSE2).

Build command (see `build`): `g++ -pipe -O3 -fomit-frame-pointer -march=native -fopenmp -o out/spectral-norm spectral-norm.cpp` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`).

Deviations: none.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
