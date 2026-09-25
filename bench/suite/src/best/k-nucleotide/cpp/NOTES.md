# k-nucleotide — C++ g++ (best track)

Source: Benchmarks Game C++ g++ #2 program `knucleotide-gpp-2`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/knucleotide-gpp-2.html
Contributors (per the source header): Sylvester Saguban
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: fastest C++ g++ program on the k-nucleotide page (std::thread, libstdc++ pb_ds hash table).

Build command (see `build`): `g++ -pipe -O3 -fomit-frame-pointer -march=native -std=c++17 -o out/k-nucleotide k-nucleotide.cpp -lpthread` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`).

Deviations: none.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
