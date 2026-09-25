# binary-trees — C++ g++ (best track)

Source: Benchmarks Game C++ g++ #5 program `binarytrees-gpp-5`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/binarytrees-gpp-5.html
Contributors (per the source header): Danial Klimkin (C++), adapted from the Rust program by the Rust Project Developers, TeXitoi, Cristi Cobzarenco, Matt Brubeck et al.
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: C++ g++ #7 (the fastest) needs Boost headers (`boost/iterator/counting_iterator.hpp`); only boost-libs is installed, with no /usr/include/boost. #5 is the next fastest and builds with the standard library alone (std::pmr pools + std::thread).

Build command (see `build`): `g++ -pipe -O3 -fomit-frame-pointer -march=native -std=gnu++17 -o out/binary-trees binary-trees.cpp -lpthread` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`).

Deviations: none.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
