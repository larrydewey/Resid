# pidigits — C gcc (best track)

Source: Benchmarks Game C gcc #2 program `pidigits-gcc-2`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/pidigits-gcc-2.html
Contributors (per the source header): Michael Ganss, Oleksii Prudkyi, Craig Russell; port of pidigits.lua-5 (Mike Pall, Wim Couwenberg); original C version by Mr Ledrug
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: fastest C gcc program on the pidigits page (GMP).

Build command (see `build`): `gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -o out/pidigits pidigits.c -lgmp` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`).

Deviations: none.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
