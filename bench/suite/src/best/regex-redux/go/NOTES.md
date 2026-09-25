# regex-redux — Go, best track

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/regexredux-go-5.html
(the fastest Go program on the Benchmarks Game regex-redux page at time of
adaptation, 3.23s there). Benchmarks Game programs are distributed under
the revised BSD license (3-clause BSD):
https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html

Source copied verbatim; no code changes.

Program: cgo PCRE (libpcre 8.x) with JIT via github.com/GRbit/go-pcre, goroutine per variant/substitution.

Build: `GOAMD64=v3 go build` (go.mod declares `go 1.27`).
Benchmarks Game original command line: `go build` with GOAMD64=v2 (go 1.23.1). Deviation: the CPU
target is this host's (`GOAMD64=v3`) instead of the Benchmarks Game host's.

Dependencies: github.com/GRbit/go-pcre **v1.0.0** (go.mod/go.sum committed, fetched via GOPROXY on first build; links host libpcre). v1.0.1/v1.0.2 removed the `Regexp.Matcher` value-receiver method the program uses, so the module is pinned to v1.0.0 instead of editing the source.

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, sha256-identical to the st cell.
