# k-nucleotide / fortran / best

Not a Benchmarks Game program. The only Fortran k-nucleotide entry there
(https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/knucleotide-ifx-1.html) is an empty placeholder: its source is just a
comment saying there is no Fortran hash-table library, and it fails to link.

This is a tuned version of the st cell: the same algorithm and the same custom
open-addressing hash table, with these changes:
- Key and count sit in one 16-byte entry, so a probe touches one cache line.
- Each table is pre-sized from min(4**k, sequence length).
- The five counting frames (3, 4, 6, 12, 18) run concurrently with OpenMP
  (`schedule(dynamic,1)`, largest first). The 1- and 2-frame frequency tables
  are built serially first.

Build: `gfortran -O3 -march=native -fopenmp`. Ignores argv.
