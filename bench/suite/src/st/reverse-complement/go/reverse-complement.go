// reverse-complement: single-threaded, same algorithm as the Benchmarks Game description.
// Reads FASTA from stdin, writes each sequence's reverse complement, 60 chars per line.
package main

import (
	"bufio"
	"bytes"
	"io"
	"os"
)

const lineLen = 60

var table [256]byte

func init() {
	for i := range table {
		table[i] = byte(i)
	}
	pairs := "AT" + "CG" + "GC" + "TA" + "UA" + "MK" + "RY" + "WW" +
		"SS" + "YR" + "KM" + "VB" + "HD" + "DH" + "BV" + "NN"
	for i := 0; i < len(pairs); i += 2 {
		from, to := pairs[i], pairs[i+1]
		table[from] = to
		table[from+('a'-'A')] = to
	}
}

func writeSeq(out *bufio.Writer, seq []byte) {
	for i, j := 0, len(seq)-1; i < j; i, j = i+1, j-1 {
		seq[i], seq[j] = table[seq[j]], table[seq[i]]
	}
	if len(seq)%2 == 1 {
		mid := len(seq) / 2
		seq[mid] = table[seq[mid]]
	}
	for len(seq) > 0 {
		m := lineLen
		if len(seq) < m {
			m = len(seq)
		}
		out.Write(seq[:m])
		out.WriteByte('\n')
		seq = seq[m:]
	}
}

func main() {
	input, err := io.ReadAll(os.Stdin)
	if err != nil {
		panic(err)
	}
	out := bufio.NewWriterSize(os.Stdout, 1<<16)
	defer out.Flush()
	var seq []byte
	for len(input) > 0 {
		var line []byte
		if i := bytes.IndexByte(input, '\n'); i >= 0 {
			line, input = input[:i], input[i+1:]
		} else {
			line, input = input, nil
		}
		if len(line) == 0 {
			continue
		}
		if line[0] == '>' {
			if len(seq) > 0 {
				writeSeq(out, seq)
				seq = seq[:0]
			}
			out.Write(line)
			out.WriteByte('\n')
		} else {
			seq = append(seq, line...)
		}
	}
	if len(seq) > 0 {
		writeSeq(out, seq)
	}
}
