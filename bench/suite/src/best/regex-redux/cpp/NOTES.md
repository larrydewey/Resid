# regex-redux — C++ g++ (best track)

Source: Benchmarks Game C++ g++ #6 program `regexredux-gpp-6`, https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/regexredux-gpp-6.html
Contributors (per the source header): Markus Lenger
License: revised BSD license (3-clause BSD), as for all Computer Language
Benchmarks Game programs. Source file is copied unmodified from the program
page unless noted below.

Selection: fastest C++ g++ program on the regex-redux page (std::async threads, PCRE2 JIT). The next ranked C++ programs are no better options: #3 needs Boost.Regex headers (not installed), and #1, #2, #4, #5 fail to build on the Benchmarks Game itself and have no measured time.

Build command (see `build`): `g++ -pipe -O3 -fomit-frame-pointer -march=native -std=c++17 -I. -o out/regex-redux regex-redux.cpp -lpcre2-8 -lpthread` (the Benchmarks Game flags, with `-march=ivybridge`
replaced by `-march=native`; see deviations).

Deviations: the program includes `<boost/noncopyable.hpp>` only to derive one class from `boost::noncopyable`. Boost headers are not installed here, so the cell carries a six-line stand-in at `boost/noncopyable.hpp` (same semantics: deleted copy constructor and copy assignment) and builds with `-I.`. Program source unchanged.

Verified: output identical to the Benchmarks Game expected output at its
test size, and byte-identical (sha256) to the C `st` cell at the contract
small size.
