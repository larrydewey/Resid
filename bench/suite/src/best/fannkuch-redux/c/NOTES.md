# fannkuch-redux — C gcc (best track)

Source: Benchmarks Game C gcc #6 program `fannkuchredux-gcc-6`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/fannkuchredux-gcc-6.html
Contributors (per the source header): Ilya Kurdyukov, based on C++ g++ #6 by Andrei Simion et al.
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: fastest C gcc program on the fannkuch-redux page (pthreads, SSE4.1).

Build command (see `build`): `gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -pthread -o out/fannkuch-redux fannkuch-redux.c` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`).

Deviations: none.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
