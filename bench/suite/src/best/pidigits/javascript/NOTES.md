# best / pidigits / javascript

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/pidigits-node-2.html
(Benchmarks Game program `pidigits-node-2`, author credits are in the file header.)

License: revised BSD license (3-clause BSD), per the Benchmarks Game.

Run: `node`. Single-threaded.

Adaptations for node 26:
- The fastest Node program (pidigits-node-4) uses the `mpzjs` npm GMP binding. That package is not installed and we do not install packages, so this cell uses the next-fastest program, which is pure BigInt.
