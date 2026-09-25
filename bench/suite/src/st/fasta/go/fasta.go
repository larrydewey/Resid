// fasta: single-threaded, same algorithm as the Benchmarks Game description.
// Linear congruential generator, cumulative probabilities with linear search.
package main

import (
	"bufio"
	"os"
	"strconv"
)

const (
	im   = 139968
	ia   = 3877
	ic   = 29573
	line = 60
)

const alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG" +
	"GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA" +
	"CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT" +
	"ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA" +
	"GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG" +
	"AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC" +
	"AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"

type acid struct {
	c byte
	p float64
}

var seed uint32 = 42

func random(max float64) float64 {
	seed = (seed*ia + ic) % im
	return max * float64(seed) / im
}

func repeatFasta(out *bufio.Writer, header string, src string, n int) {
	out.WriteString(header)
	l := len(src)
	buf := []byte(src + src[:line])
	pos := 0
	for left := n; left > 0; {
		m := line
		if left < line {
			m = left
		}
		out.Write(buf[pos : pos+m])
		out.WriteByte('\n')
		pos += m
		if pos >= l {
			pos -= l
		}
		left -= m
	}
}

func randomFasta(out *bufio.Writer, header string, table []acid, n int) {
	out.WriteString(header)
	chars := make([]byte, len(table))
	cumul := make([]float64, len(table))
	acc := 0.0
	for i, a := range table {
		acc += a.p
		chars[i] = a.c
		cumul[i] = acc
	}
	last := len(table) - 1
	var buf [line + 1]byte
	for left := n; left > 0; {
		m := line
		if left < line {
			m = left
		}
		for k := 0; k < m; k++ {
			r := random(1.0)
			i := 0
			for i < last && r >= cumul[i] {
				i++
			}
			buf[k] = chars[i]
		}
		buf[m] = '\n'
		out.Write(buf[:m+1])
		left -= m
	}
}

func main() {
	n := 1000
	if len(os.Args) > 1 {
		n, _ = strconv.Atoi(os.Args[1])
	}
	iub := []acid{
		{'a', 0.27}, {'c', 0.12}, {'g', 0.12}, {'t', 0.27},
		{'B', 0.02}, {'D', 0.02}, {'H', 0.02}, {'K', 0.02},
		{'M', 0.02}, {'N', 0.02}, {'R', 0.02}, {'S', 0.02},
		{'V', 0.02}, {'W', 0.02}, {'Y', 0.02},
	}
	homo := []acid{
		{'a', 0.3029549426680},
		{'c', 0.1979883004921},
		{'g', 0.1975473066391},
		{'t', 0.3015094502008},
	}
	out := bufio.NewWriterSize(os.Stdout, 1<<16)
	defer out.Flush()
	repeatFasta(out, ">ONE Homo sapiens alu\n", alu, 2*n)
	randomFasta(out, ">TWO IUB ambiguity codes\n", iub, 3*n)
	randomFasta(out, ">THREE Homo sapiens frequency\n", homo, 5*n)
}
