// pidigits: single-threaded, same algorithm as the Benchmarks Game description
// (unbounded spigot, digit extraction by comparing (3*numer+accum)/denom and
// (4*numer+accum)/denom). Bignums via the standard library math/big.
package main

import (
	"bufio"
	"fmt"
	"math/big"
	"os"
	"strconv"
)

var (
	acc  = big.NewInt(0)
	den  = big.NewInt(1)
	num  = big.NewInt(1)
	tmp1 = new(big.Int)
	tmp2 = new(big.Int)
)

func extractDigit(nth int64) int64 {
	tmp1.Mul(num, big.NewInt(nth))
	tmp2.Add(tmp1, acc)
	tmp1.Quo(tmp2, den)
	return tmp1.Int64()
}

func nextTerm(k int64) {
	k2 := big.NewInt(k*2 + 1)
	tmp1.Lsh(num, 1)
	acc.Add(acc, tmp1)
	acc.Mul(acc, k2)
	den.Mul(den, k2)
	num.Mul(num, big.NewInt(k))
}

func eliminateDigit(d int64) {
	tmp1.Mul(den, big.NewInt(d))
	acc.Sub(acc, tmp1)
	acc.Mul(acc, big.NewInt(10))
	num.Mul(num, big.NewInt(10))
}

func main() {
	n := 27
	if len(os.Args) > 1 {
		n, _ = strconv.Atoi(os.Args[1])
	}
	out := bufio.NewWriter(os.Stdout)
	defer out.Flush()
	var line [10]byte
	i := 0
	for k := int64(1); i < n; k++ {
		nextTerm(k)
		if num.Cmp(acc) > 0 {
			continue
		}
		d := extractDigit(3)
		if d != extractDigit(4) {
			continue
		}
		line[i%10] = byte('0' + d)
		i++
		if i%10 == 0 {
			fmt.Fprintf(out, "%s\t:%d\n", line[:], i)
		}
		eliminateDigit(d)
	}
	if i%10 != 0 {
		for j := i % 10; j < 10; j++ {
			line[j] = ' '
		}
		fmt.Fprintf(out, "%s\t:%d\n", line[:], i)
	}
}
