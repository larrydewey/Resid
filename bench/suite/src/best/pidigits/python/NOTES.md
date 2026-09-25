# best / pidigits / python

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/pidigits-python3-3.html
(Benchmarks Game program `pidigits-python3-3`, translated from Mr Ledrug's C program by Jeremy Zerfas.)

License: revised BSD license (3-clause BSD), per the Benchmarks Game.

Run: `python3 -OO` (as on the Benchmarks Game). Single-threaded.

This is the fastest Python pidigits program on the Benchmarks Game. It calls the
system libgmp through `ctypes` rather than using Python's built-in `int`, the
same library the C, C++, Rust, Go, Java, C#, Fortran and Pascal best cells use.
Source is unchanged. Like the upstream program it only prints a complete final
line when N is a multiple of 10 (2000 and 10000 both are).
