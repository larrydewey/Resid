# spectral-norm — C gcc (best track)

Source: Benchmarks Game C gcc #6 program `spectralnorm-gcc-6`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/spectralnorm-gcc-6.html
Contributors (per the source header): Miles
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: fastest C gcc program on the spectral-norm page (OpenMP, AVX).

Build command (see `build`): `gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp -o out/spectral-norm spectral-norm.c` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`).

Deviations: none.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
