// Are We Fast Yet, Go port: `harness <Benchmark> [outer [inner]]`, the
// reference harness's interface and output (Run.java).
package main

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

func run(name string, inner int) bool {
	switch name {
	case "Bounce":
		return bounceInner(inner)
	case "List":
		return listInner(inner)
	case "Mandelbrot":
		return mandelbrotInner(inner)
	case "NBody":
		return nbodyInner(inner)
	case "Permute":
		return permuteInner(inner)
	case "Queens":
		return queensInner(inner)
	case "Sieve":
		return sieveInner(inner)
	case "Storage":
		return storageInner(inner)
	case "Towers":
		return towersInner(inner)
	case "Richards":
		return richardsInner(inner)
	case "DeltaBlue":
		return deltaBlueInner(inner)
	case "Json":
		return jsonInner(inner)
	case "CD":
		return cdInner(inner)
	case "Havlak":
		return havlakInner(inner)
	}
	panic("No benchmark found with the name: " + name)
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("harness benchmark [num-iterations [inner-iter]]")
		os.Exit(1)
	}
	name := os.Args[1]
	outer, inner := 1, 1
	if len(os.Args) > 2 {
		outer, _ = strconv.Atoi(os.Args[2])
	}
	if len(os.Args) > 3 {
		inner, _ = strconv.Atoi(os.Args[3])
	}
	fmt.Printf("Starting %s benchmark ...\n", name)
	var total int64
	for i := 0; i < outer; i++ {
		t0 := time.Now()
		if !run(name, inner) {
			fmt.Println("Benchmark failed with incorrect result")
			os.Exit(1)
		}
		us := time.Since(t0).Microseconds()
		fmt.Printf("%s: iterations=1 runtime: %dus\n", name, us)
		total += us
	}
	fmt.Printf("%s: iterations=%d average: %dus total: %dus\n\n", name, outer, total/int64(outer), total)
	fmt.Printf("Total Runtime: %dus\n", total)
}

// som.Random
type Random struct{ seed int }

func newRandom() *Random { return &Random{seed: 74755} }
func (r *Random) next() int {
	r.seed = ((r.seed * 1309) + 13849) & 65535
	return r.seed
}
