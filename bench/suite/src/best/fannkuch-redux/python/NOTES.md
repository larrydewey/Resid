# best / fannkuch-redux / python

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/fannkuchredux-python3-4.html
(Benchmarks Game program `fannkuchredux-python3-4`, author credits are in the file header.)

License: revised BSD license (3-clause BSD), per the Benchmarks Game.

Run: `python3 -OO` (as on the Benchmarks Game). Multi-process (multiprocessing).

Adaptations for CPython 3.14:
- Added `multiprocessing.set_start_method('fork')` under the `__main__` guard. CPython 3.14 defaults to `forkserver` on Linux; the Benchmarks Game ran on 3.13, where `fork` was the default. This program also works under `forkserver`, so the change only restores the start method (and startup cost) it was measured with.
