# best / k-nucleotide / javascript

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/knucleotide-node-3.html
(Benchmarks Game program `knucleotide-node-3`, author credits are in the file header.)

License: revised BSD license (3-clause BSD), per the Benchmarks Game.

Run: `node`. Multi-threaded (worker_threads).

Adaptations for node 26:
- Fixed an off-by-one in `frequency()`: the original loop skipped the final k-mer window, so counts were one short. That is invisible at the official 25M input after rounding, but it broke the output at the Benchmarks Game sample input. Removed the now-unused `n` local.
