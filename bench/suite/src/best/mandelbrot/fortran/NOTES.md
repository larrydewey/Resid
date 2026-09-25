# mandelbrot / fortran / best

Source: mandelbrot Intel Fortran #6 (Pascal Parois), OpenMP, 32-wide vectors
https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/mandelbrot-ifx-6.html

Benchmarks Game programs are distributed under the revised BSD license (3-clause BSD), https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html.

Unmodified source. Build: `gfortran -O3 -march=native -fopenmp -ffp-contract=off`. `-ffp-contract=off` is required: with `-march=native` gfortran fuses `2*zr*zi+ci` into an FMA, which changes rounding and flips boundary pixels (output then differs from the expected output at N=200). The Benchmarks Game build targeted ivybridge, which has no FMA.

The Benchmarks Game only has Intel Fortran (ifx) entries; they are built here with gfortran 16.2.1.
