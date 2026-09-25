# best / fasta / javascript

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/fasta-node-5.html
(Benchmarks Game program `fasta-node-5`, author credits are in the file header.)

License: revised BSD license (3-clause BSD), per the Benchmarks Game.

Run: `node`. Multi-threaded (worker_threads).

Adaptations for node 26:
- `Out.flush()` now allocates a fresh output buffer after each `process.stdout.write`. On a pipe, Node's stdout writes are asynchronous and do not copy the buffer, so reusing it corrupted piped output (it was correct only when stdout was a regular file).
