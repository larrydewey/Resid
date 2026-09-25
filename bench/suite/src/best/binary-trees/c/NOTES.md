# binary-trees — C gcc (best track)

Source: Benchmarks Game C gcc #5 program `binarytrees-gcc-5`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/binarytrees-gcc-5.html
Contributors (per the source header): Eckehard Berns, based on code by Kevin Carson
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: the two faster C gcc programs (#2, #3) need the Apache Portable Runtime (`apr-1` pools), which is not installed here (`pacman -Q apr` fails, no /usr/include/apr-1*). #5 is the fastest C gcc program that builds with what exists (pthreads, own arena).

Build command (see `build`): `gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -pthread -o out/binary-trees binary-trees.c` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`).

Deviations: none.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
