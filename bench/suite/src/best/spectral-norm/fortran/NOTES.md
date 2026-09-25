# spectral-norm / fortran / best

Source: spectral-norm Intel Fortran #3 (Brian Taylor, from the OpenMP C version), OpenMP
https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/spectralnorm-ifx-3.html

Benchmarks Game programs are distributed under the revised BSD license (3-clause BSD), https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html.

Unmodified source. Build: `gfortran -O3 -march=native -fopenmp`. At the small size (1000), OpenMP start-up and barrier cost is a large share of the total run time.

The Benchmarks Game only has Intel Fortran (ifx) entries; they are built here with gfortran 16.2.1.
