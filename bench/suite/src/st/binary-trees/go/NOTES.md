# binary-trees — Go, st track

Written for this suite (not copied from the Benchmarks Game); follows the
Benchmarks Game binary-trees description, single goroutine, no assembly.

Build: `go build` with default flags (go.mod declares `go 1.27`; default
GOAMD64, default GOCACHE).

Standard library only; every node is a separate heap allocation reclaimed by the garbage collector (default GOGC). The program itself runs on one goroutine; the Go runtime's concurrent GC still uses its own background threads (default GOMAXPROCS), as Java's default GC does in the Java st cell.

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, to the C st cell and the Rust/Go best cells.
