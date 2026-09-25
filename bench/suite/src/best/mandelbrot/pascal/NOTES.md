# mandelbrot / pascal / best

Source: mandelbrot Free Pascal #5 (Akira1364, after Go #4), multi-threaded with MTProcs
https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/mandelbrot-fpascal-5.html

Benchmarks Game programs are distributed under the revised BSD license (3-clause BSD), https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html.

Program source unmodified. It uses the local `mtprocs.pas` stand-in for the Lazarus MTProcs unit (see that file, and the spectral-norm cell). Like the Benchmarks Game original, the program assumes the size is a multiple of 8 (true for 200, 4000 and 16000).

Build: Benchmarks Game flags, `fpc -XXs -O3 -Ci- -Cr- -g- -CpCOREAVX -CfAVX -Tlinux` (Free Pascal 3.2.2, the same version the Benchmarks Game uses; it stands in for Delphi/Object Pascal).
