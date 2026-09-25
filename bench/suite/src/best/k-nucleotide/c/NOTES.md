# k-nucleotide — C gcc (best track)

Source: Benchmarks Game C gcc #1 program `knucleotide-gcc-1`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/knucleotide-gcc-1.html
Contributors (per the source header): Jeremy Zerfas
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: the only C gcc program on the k-nucleotide page (OpenMP + klib khash).

Build command (see `build`): `gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp -I/usr/include/ucs/datastruct -o out/k-nucleotide k-nucleotide.c` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`; see deviations).

Deviations: the program includes `<khash.h>` (klib), which the Benchmarks Game supplies from its own `Include` directory (`-IInclude`). klib is not installed as a package here, but UCX ships an API-compatible copy of klib's khash.h at /usr/include/ucs/datastruct/khash.h, so the build points `-I` there instead. Source unchanged.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
