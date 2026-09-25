# reverse-complement / fortran / best

Source: reverse-complement Intel Fortran #1
https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/revcomp-ifx-1.html

Benchmarks Game programs are distributed under the revised BSD license (3-clause BSD), https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html.

One adaptation. The program re-opens the preconnected units 5 and 6 as unformatted stream units, relying on ifx behaviour. gfortran would open a file named `fort.5` instead, so the two OPEN statements now name `file='/dev/stdin'` and `file='/dev/stdout'`. Nothing else changed. Build: `gfortran -O3 -march=native`.

The Benchmarks Game only has Intel Fortran (ifx) entries; they are built here with gfortran 16.2.1.
