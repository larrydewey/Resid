// mandelbrot: single-threaded, same algorithm as the Benchmarks Game description.
// Writes a binary PBM (P4) bitmap of the Mandelbrot set to stdout.
package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	n := 200
	if len(os.Args) > 1 {
		n, _ = strconv.Atoi(os.Args[1])
	}
	w, h := n, n
	const iter = 50
	const limit2 = 4.0
	out := bufio.NewWriterSize(os.Stdout, 1<<16)
	defer out.Flush()
	fmt.Fprintf(out, "P4\n%d %d\n", w, h)
	for y := 0; y < h; y++ {
		ci := 2.0*float64(y)/float64(h) - 1.0
		var b byte
		bitNum := 0
		for x := 0; x < w; x++ {
			cr := 2.0*float64(x)/float64(w) - 1.5
			var zr, zi, tr, ti float64
			for i := 0; i < iter && tr+ti <= limit2; i++ {
				zi = 2.0*zr*zi + ci
				zr = tr - ti + cr
				tr = zr * zr
				ti = zi * zi
			}
			b <<= 1
			if tr+ti <= limit2 {
				b |= 1
			}
			bitNum++
			if bitNum == 8 {
				out.WriteByte(b)
				b, bitNum = 0, 0
			} else if x == w-1 {
				b <<= uint(8 - w%8)
				out.WriteByte(b)
				b, bitNum = 0, 0
			}
		}
	}
}
