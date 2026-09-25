# mandelbrot — C++ g++ (best track)

Source: Benchmarks Game C++ g++ #1 program `mandelbrot-gpp-1`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/mandelbrot-gpp-1.html
Contributors (per the source header): Kevin Miller (C), ported to C++ by Dave Compton, x86 optimisation by Kenta Yoshimura
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: C++ g++ #4 is marginally faster on the Benchmarks Game (0.89 s vs 0.90 s) but was rejected: it rounds the image height up to a multiple of `std::thread::hardware_concurrency()`, so its output depends on the host core count (size 200 on this 16-thread host emits a 200x208 image), and its AVX-512 path (selected by `-march=native` here) produces different pixels from the reference. #1 is the next fastest and is correct at every size tested.

Build command (see `build`): `g++ -pipe -O3 -fomit-frame-pointer -march=native -fopenmp -ffp-contract=off -o out/mandelbrot mandelbrot.cpp` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`; see deviations).

Deviations: added `-ffp-contract=off` as recommended in the program's own header comment ("FMA is fast, but different precision to original version"). Without it the AVX-512 build selected by `-march=native` differs from the expected output by one byte at sizes 200 and 4000.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
