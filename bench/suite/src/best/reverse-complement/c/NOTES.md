# reverse-complement — C gcc (best track)

Source: Benchmarks Game C gcc #7 program `revcomp-gcc-7`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/revcomp-gcc-7.html
Contributors (per the source header): Jeremy Zerfas
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: fastest C gcc program on the reverse-complement page (pthreads, AVX).

Build command (see `build`): `gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -pthread -o out/reverse-complement reverse-complement.c` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`).

Deviations: none.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
