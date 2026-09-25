# mandelbrot — Go, st track

Written for this suite (not copied from the Benchmarks Game); follows the
Benchmarks Game mandelbrot description, single goroutine, no assembly.

Build: `go build` with default flags (go.mod declares `go 1.27`; default
GOAMD64, default GOCACHE).

Standard library only; one pixel at a time, 50 iterations, escape test |z|^2 > 4 checked before each iteration (as in the reference C program). Default GOAMD64 (v1), so no FMA contraction.

Verified: output byte-identical to the Benchmarks Game expected output file
and, at the contract small size, to the C st cell and the Rust/Go best cells.
