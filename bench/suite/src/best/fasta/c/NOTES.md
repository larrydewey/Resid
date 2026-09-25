# fasta — C gcc (best track)

Source: Benchmarks Game C gcc #3 program `fasta-gcc-3`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/fasta-gcc-3.html
Contributors (per the source header): Drake Diedrich
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: fastest C gcc program on the fasta page (single-threaded, integer-scaled lookup).

Build command (see `build`): `gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -o out/fasta fasta.c` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`).

Deviations: none.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
