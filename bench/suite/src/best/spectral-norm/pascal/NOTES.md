# spectral-norm / pascal / best

Source: spectral-norm Free Pascal #2 (Ian Osgood, Vincent Snijders, Peter Blackman), multi-threaded with MTProcs
https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/spectralnorm-fpascal-2.html

Benchmarks Game programs are distributed under the revised BSD license (3-clause BSD), https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html.

Program source unmodified. It uses the Lazarus `MTProcs` unit (multithreadprocs package), which ships with Lazarus rather than FPC and is not installed here. The local `mtprocs.pas` is a stand-in written for this suite. It provides `ProcThreadPool.DoParallel(proc, start, end, data)` with the same signature and semantics: a persistent pool of one worker per online CPU (via `sysconf`, because FPC 3.2.2's `TThread.ProcessorCount` returns 1 on Linux), with indices handed out through an atomic counter.

Build: Benchmarks Game flags, `fpc -XXs -O3 -Ci- -Cr- -g- -CpCOREAVX -CfAVX -Tlinux` (Free Pascal 3.2.2, the same version the Benchmarks Game uses; it stands in for Delphi/Object Pascal).
