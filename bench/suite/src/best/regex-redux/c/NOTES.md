# regex-redux — C gcc (best track)

Source: Benchmarks Game C gcc #5 program `regexredux-gcc-5`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/regexredux-gcc-5.html
Contributors (per the source header): Jeremy Zerfas, modified by Zoltan Herczeg
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: fastest C gcc program on the regex-redux page (OpenMP, PCRE2 JIT).

Build command (see `build`): `gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp -o out/regex-redux regex-redux.c -lpcre2-8` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`).

Deviations: none.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
