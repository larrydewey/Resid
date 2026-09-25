# best / regex-redux / python

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/regexredux-python3-2.html
(Benchmarks Game program `regexredux-python3-2`, author credits are in the file header.)

License: revised BSD license (3-clause BSD), per the Benchmarks Game.

Run: `python3 -OO` (as on the Benchmarks Game). Multi-process (multiprocessing).

Adaptations for CPython 3.14:
- Added `multiprocessing.set_start_method('fork')` under the `__main__` guard. CPython 3.14 defaults to `forkserver` on Linux; the Benchmarks Game ran on 3.13, where `fork` was the default. This program also works under `forkserver`, so the change only restores the start method (and startup cost) it was measured with.
- This program calls the system libpcre2-8 through `ctypes` (stdlib), with multiprocessing. It needs `libpcre2-8.so` (installed on this host). Nothing was pip-installed.
