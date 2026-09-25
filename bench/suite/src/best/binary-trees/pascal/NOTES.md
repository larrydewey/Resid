# binary-trees / pascal / best

Source: binary-trees Free Pascal #5 (Vitaly Trifonof, Ales Katona, Nitorami, Akira1364), PasMP + PooledMM
https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/binarytrees-fpascal-5.html

Benchmarks Game programs are distributed under the revised BSD license (3-clause BSD), https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html.

Program source unmodified. It needs two units that are not part of FPC and not installed here. PasMP (Benjamin Rosseaux's third-party parallel library) is replaced by the local `pasmp.pas`, which implements only `TPasMP.CreateGlobalInstance`, `ParallelFor(data, from, to, method)` and `Invoke`: one thread per online CPU, granularity 1. PooledMM (`TNonFreePooledMemManager` from Lazarus LazUtils) is replaced by the local `pooledmm.pas`: a chunked bump allocator whose chunks double in size, with no per-item free, and whose `Clear` frees every chunk, as in LazUtils.

Build: Benchmarks Game flags, `fpc -XXs -O3 -Ci- -Cr- -g- -CpCOREAVX -CfAVX -Tlinux -Mdelphi` (Free Pascal 3.2.2, the same version the Benchmarks Game uses; it stands in for Delphi/Object Pascal).
