# best / mandelbrot / python

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/mandelbrot-python3-7.html
(Benchmarks Game program `mandelbrot-python3-7`, author credits are in the file header.)

License: revised BSD license (3-clause BSD), per the Benchmarks Game.

Run: `python3 -OO` (as on the Benchmarks Game). Multi-process (multiprocessing).

Adaptations for CPython 3.14:
- Added `multiprocessing.set_start_method('fork')` under the `__main__` guard. CPython 3.14 defaults to `forkserver` on Linux; the Benchmarks Game ran on 3.13, where `fork` was the default. This program also works under `forkserver`, so the change only restores the start method (and startup cost) it was measured with.
- `pixels()`: computes each point directly as `2x/n-1.5`, `2y/n-1` and escapes on `|z| > 2`. The original accumulated `c += 2/n`, whose drift plus the `>= 2` test flipped boundary pixels.
- `compute_row()`: the last-byte mask is skipped when `n % 8 == 0`. The original masked with `0xff << 8`, which zeroed the last byte of every row.
- Both fixes were needed for byte-identical output (the original got 5 of 5011 bytes wrong at n=200).
