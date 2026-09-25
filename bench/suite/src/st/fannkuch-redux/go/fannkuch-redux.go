// fannkuch-redux: single-threaded, same algorithm as the Benchmarks Game description
// (permutations generated in the reference order, checksum alternates sign).
package main

import (
	"fmt"
	"os"
	"strconv"
)

func fannkuch(n int) (int, int) {
	perm1 := make([]int, n)
	for i := range perm1 {
		perm1[i] = i
	}
	perm := make([]int, n)
	count := make([]int, n)
	maxFlips, checksum, permCount := 0, 0, 0
	r := n
	for {
		for ; r != 1; r-- {
			count[r-1] = r
		}
		copy(perm, perm1)
		flips := 0
		for k := perm[0]; k != 0; k = perm[0] {
			for i, j := 0, k; i < j; i, j = i+1, j-1 {
				perm[i], perm[j] = perm[j], perm[i]
			}
			flips++
		}
		if flips > maxFlips {
			maxFlips = flips
		}
		if permCount%2 == 0 {
			checksum += flips
		} else {
			checksum -= flips
		}
		// Next permutation.
		for {
			if r == n {
				return checksum, maxFlips
			}
			perm0 := perm1[0]
			for i := 0; i < r; i++ {
				perm1[i] = perm1[i+1]
			}
			perm1[r] = perm0
			count[r]--
			if count[r] > 0 {
				break
			}
			r++
		}
		permCount++
	}
}

func main() {
	n := 7
	if len(os.Args) > 1 {
		n, _ = strconv.Atoi(os.Args[1])
	}
	checksum, maxFlips := fannkuch(n)
	fmt.Printf("%d\nPfannkuchen(%d) = %d\n", checksum, n, maxFlips)
}
