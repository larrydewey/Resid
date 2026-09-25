# fasta — Go, st track

Written for this suite (not copied from the Benchmarks Game); follows the
Benchmarks Game fasta description, single goroutine, no assembly.

Build: `go build` with default flags (go.mod declares `go 1.27`; default
GOAMD64, default GOCACHE).

Standard library only; float64 LCG output, cumulative-probability linear search, bufio stdout.

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, to the C st cell and the Rust/Go best cells.
