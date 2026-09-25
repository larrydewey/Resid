# best / fasta / python

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/fasta-python3-5.html
(Benchmarks Game program `fasta-python3-5`, author credits are in the file header.)

License: revised BSD license (3-clause BSD), per the Benchmarks Game.

Run: `python3 -OO` (as on the Benchmarks Game). Multi-process (multiprocessing).

Adaptations for CPython 3.14:
- Added `multiprocessing.set_start_method('fork')` under the `__main__` guard. CPython 3.14 defaults to `forkserver` on Linux, and under it this program fails because its workers rely on globals inherited through fork. The Benchmarks Game ran it on 3.13, where `fork` was the default.
