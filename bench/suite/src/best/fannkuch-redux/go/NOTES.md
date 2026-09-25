# fannkuch-redux — Go, best track

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/fannkuchredux-go-3.html
(the fastest Go program on the Benchmarks Game fannkuch-redux page at time of
adaptation, 8.36s there). Benchmarks Game programs are distributed under
the revised BSD license (3-clause BSD):
https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html

Source copied verbatim; no code changes.

Program: parallel over permutation blocks with GOMAXPROCS fixed at 4 by the program, atomic work distribution, stack-allocated permutation arrays.

Build: `GOAMD64=v3 go build` (go.mod declares `go 1.27`).
Benchmarks Game original command line: `go build` with GOAMD64=v2 (go 1.23.1). Deviation: the CPU
target is this host's (`GOAMD64=v3`) instead of the Benchmarks Game host's.

Dependencies: none (std only).

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, sha256-identical to the st cell.
