# regex-redux / fortran / best

Source: regex-redux Intel Fortran #1, PCRE2 JIT via iso_c_binding, OpenMP
https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/regexredux-ifx-1.html

Benchmarks Game programs are distributed under the revised BSD license (3-clause BSD), https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html.

One adaptation. The program re-opens preconnected unit 5 as a stream unit with no file name (works in ifx). For gfortran, unit 5 is now closed and re-opened with `file="/dev/stdin"`. The program sizes its read buffer with `INQUIRE(size=)`, so stdin must be a regular file, which is what the harness provides. Build: `gfortran -O3 -march=native -fopenmp ... -lpcre2-8`.

The Benchmarks Game only has Intel Fortran (ifx) entries; they are built here with gfortran 16.2.1.
