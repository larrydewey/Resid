// k-nucleotide: single-threaded, same algorithm as the Benchmarks Game description.
// Reads a FASTA file on stdin, extracts sequence THREE, and counts k-mers with a
// built-in map keyed by the k-mer string.
package main

import (
	"bufio"
	"bytes"
	"fmt"
	"io"
	"os"
	"sort"
)

func frequencies(seq []byte, k int) map[string]int {
	m := make(map[string]int)
	for i := 0; i+k <= len(seq); i++ {
		m[string(seq[i:i+k])]++
	}
	return m
}

type kv struct {
	key   string
	count int
}

func writeFrequencies(out *bufio.Writer, seq []byte, k int) {
	m := frequencies(seq, k)
	total := 0
	v := make([]kv, 0, len(m))
	for key, c := range m {
		v = append(v, kv{key, c})
		total += c
	}
	sort.Slice(v, func(i, j int) bool {
		if v[i].count != v[j].count {
			return v[i].count > v[j].count
		}
		return v[i].key < v[j].key
	})
	for _, e := range v {
		fmt.Fprintf(out, "%s %.3f\n", e.key, 100*float64(e.count)/float64(total))
	}
	out.WriteByte('\n')
}

func writeCount(out *bufio.Writer, seq []byte, pattern string) {
	m := frequencies(seq, len(pattern))
	fmt.Fprintf(out, "%d\t%s\n", m[pattern], pattern)
}

func main() {
	in := bufio.NewReaderSize(os.Stdin, 1<<16)
	// Skip to the ">THREE" header.
	for {
		line, err := in.ReadSlice('\n')
		if bytes.HasPrefix(line, []byte(">THREE")) || err == io.EOF {
			break
		}
		if err != nil && err != bufio.ErrBufferFull {
			panic(err)
		}
	}
	var seq []byte
	for {
		line, err := in.ReadSlice('\n')
		if len(line) > 0 && line[0] == '>' {
			break
		}
		for _, c := range line {
			if c != '\n' && c != '\r' {
				if 'a' <= c && c <= 'z' {
					c -= 'a' - 'A'
				}
				seq = append(seq, c)
			}
		}
		if err == io.EOF {
			break
		}
		if err != nil && err != bufio.ErrBufferFull {
			panic(err)
		}
	}
	out := bufio.NewWriter(os.Stdout)
	defer out.Flush()
	writeFrequencies(out, seq, 1)
	writeFrequencies(out, seq, 2)
	for _, p := range []string{"GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT"} {
		writeCount(out, seq, p)
	}
}
