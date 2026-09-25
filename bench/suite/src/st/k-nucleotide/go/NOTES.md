# k-nucleotide — Go, st track

Written for this suite (not copied from the Benchmarks Game); follows the
Benchmarks Game k-nucleotide description, single goroutine, no assembly.

Build: `go build` with default flags (go.mod declares `go 1.27`; default
GOAMD64, default GOCACHE).

Standard library only; built-in `map[string]int` rebuilt for each k.

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, to the C st cell and the Rust/Go best cells.
