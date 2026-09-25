# fasta — C++ g++ (best track)

Source: Benchmarks Game C++ g++ #7 program `fasta-gpp-7`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/fasta-gpp-7.html
Contributors (per the source header): Sylvester Saguban, inspired by C++ g++ #7 from Rafal Rusin and contributors
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: C++ g++ #9 (the fastest) needs Boost.Range headers, which are not installed (no /usr/include/boost). #7 is the next fastest C++ g++ program (multithreaded, standard library only).

Build command (see `build`): `g++ -pipe -O3 -fomit-frame-pointer -march=native -std=c++20 -o out/fasta fasta.cpp -lpthread` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`).

Deviations: none.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
