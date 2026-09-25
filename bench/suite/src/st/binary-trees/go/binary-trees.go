// binary-trees: single-threaded, same algorithm as the Benchmarks Game description.
// Each node is individually heap-allocated and reclaimed by the garbage collector.
package main

import (
	"fmt"
	"os"
	"strconv"
)

type node struct {
	left, right *node
}

func bottomUp(depth int) *node {
	if depth <= 0 {
		return &node{}
	}
	return &node{bottomUp(depth - 1), bottomUp(depth - 1)}
}

func (n *node) check() int {
	if n.left == nil {
		return 1
	}
	return 1 + n.left.check() + n.right.check()
}

func main() {
	n := 10
	if len(os.Args) > 1 {
		n, _ = strconv.Atoi(os.Args[1])
	}
	minDepth := 4
	maxDepth := n
	if minDepth+2 > n {
		maxDepth = minDepth + 2
	}

	stretchDepth := maxDepth + 1
	fmt.Printf("stretch tree of depth %d\t check: %d\n", stretchDepth, bottomUp(stretchDepth).check())

	longLived := bottomUp(maxDepth)

	for depth := minDepth; depth <= maxDepth; depth += 2 {
		iterations := 1 << uint(maxDepth-depth+minDepth)
		chk := 0
		for i := 0; i < iterations; i++ {
			chk += bottomUp(depth).check()
		}
		fmt.Printf("%d\t trees of depth %d\t check: %d\n", iterations, depth, chk)
	}
	fmt.Printf("long lived tree of depth %d\t check: %d\n", maxDepth, longLived.check())
}
