# pidigits — Go, best track

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/pidigits-go-4.html
(the fastest Go program on the Benchmarks Game pidigits page at time of
adaptation, 0.82s there). Benchmarks Game programs are distributed under
the revised BSD license (3-clause BSD):
https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html

Source copied verbatim; no code changes.

Program: cgo bindings to GMP (`#cgo LDFLAGS: -lgmp`), single-threaded spigot (program sets GOMAXPROCS(1)).

Build: `GOAMD64=v3 go build` (go.mod declares `go 1.27`).
Benchmarks Game original command line: `go build` with GOAMD64=v2 (go 1.23.1). Deviation: the CPU
target is this host's (`GOAMD64=v3`) instead of the Benchmarks Game host's.

Dependencies: host libgmp via cgo (needs CGO_ENABLED=1, the default).

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, sha256-identical to the st cell.
