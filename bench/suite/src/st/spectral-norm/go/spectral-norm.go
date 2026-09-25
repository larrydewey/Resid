// spectral-norm: single-threaded, same algorithm as the Benchmarks Game description.
package main

import (
	"fmt"
	"math"
	"os"
	"strconv"
)

func a(i, j int) float64 {
	return 1.0 / float64((i+j)*(i+j+1)/2+i+1)
}

func mulAv(v, out []float64) {
	for i := range out {
		var sum float64
		for j, vj := range v {
			sum += a(i, j) * vj
		}
		out[i] = sum
	}
}

func mulAtv(v, out []float64) {
	for i := range out {
		var sum float64
		for j, vj := range v {
			sum += a(j, i) * vj
		}
		out[i] = sum
	}
}

func mulAtAv(v, out, tmp []float64) {
	mulAv(v, tmp)
	mulAtv(tmp, out)
}

func main() {
	n := 100
	if len(os.Args) > 1 {
		n, _ = strconv.Atoi(os.Args[1])
	}
	u := make([]float64, n)
	v := make([]float64, n)
	tmp := make([]float64, n)
	for i := range u {
		u[i] = 1
	}
	for i := 0; i < 10; i++ {
		mulAtAv(u, v, tmp)
		mulAtAv(v, u, tmp)
	}
	var vBv, vv float64
	for i := 0; i < n; i++ {
		vBv += u[i] * v[i]
		vv += v[i] * v[i]
	}
	fmt.Printf("%0.9f\n", math.Sqrt(vBv/vv))
}
