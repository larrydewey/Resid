# fasta / fortran / best

Source: fasta Intel Fortran #4
https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/fasta-ifx-4.html

Benchmarks Game programs are distributed under the revised BSD license (3-clause BSD), https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html.

Unmodified source; single-threaded, as in the Benchmarks Game. Build: `gfortran -O3 -march=native` (the ifx-only `-qopt-streaming-stores always` has no gfortran equivalent and was dropped).

The Benchmarks Game only has Intel Fortran (ifx) entries; they are built here with gfortran 16.2.1.
