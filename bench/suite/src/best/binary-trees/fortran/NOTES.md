# binary-trees / fortran / best

Source: binary-trees Intel Fortran #2 (Vladimir Fuka, after Francesco Abbate's C program), OpenMP, APR memory pools
https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/binarytrees-ifx-2.html

Benchmarks Game programs are distributed under the revised BSD license (3-clause BSD), https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html.

Fortran source unmodified. It calls five Apache Portable Runtime pool functions, and libapr is not installed on this host (no packages may be installed), so `apr_shim.c` provides those five symbols with the same semantics. It is a block-based region allocator: `apr_pool_clear` rewinds without freeing, and `apr_pool_destroy` frees everything. It is compiled with `gcc -O3 -march=native` and linked in place of `-lapr-1`. Build: `gfortran -O3 -march=native -fopenmp`.

The Benchmarks Game only has Intel Fortran (ifx) entries; they are built here with gfortran 16.2.1.
