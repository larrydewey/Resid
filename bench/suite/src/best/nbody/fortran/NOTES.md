# nbody / fortran / best

Source: nbody Intel Fortran program (contributed by Simon Geard, translated from Mark C. Williams' nbody.java)
https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/nbody-ifx-1.html

Benchmarks Game programs are distributed under the revised BSD license (3-clause BSD), https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html.

Unmodified source. The fastest Benchmarks Game entry under ifx is `nbody-ifx-5` (rsqrt plus one Newton step), but built with gfortran it measured about 1.5x slower than `ifx-1` on this host. Of the six ifx programs rebuilt with gfortran, `ifx-1` was the fastest (`ifx-6` was about the same). Build: `gfortran -O3 -march=native` (Benchmarks Game used `ifx -O3 -march=ivybridge -ipo -static`).

The Benchmarks Game only has Intel Fortran (ifx) entries; they are built here with gfortran 16.2.1.
