# mandelbrot — C gcc (best track)

Source: Benchmarks Game C gcc #6 program `mandelbrot-gcc-6`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/mandelbrot-gcc-6.html
Contributors (per the source header): Kevin Miller
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: fastest C gcc program on the mandelbrot page (OpenMP, SSE2 vectors).

Build command (see `build`): `gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -ffp-contract=off -mno-fma -fno-finite-math-only -fopenmp -o out/mandelbrot mandelbrot.c` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`; see deviations).

Deviations: added `-ffp-contract=off`. With `-march=native` on this host (Zen 5, AVX-512) gcc 16 contracts the multiply-adds into FMA instructions despite `-mno-fma`, which flips a few boundary pixels (1 byte differs at size 200 and at size 4000). Disabling contraction restores the exact expected output; `-march=ivybridge` (the Benchmarks Game setting) also matches without it.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
