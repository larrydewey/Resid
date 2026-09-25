// regex-redux: single-threaded, same algorithm as the Benchmarks Game description,
// using the standard library regexp package.
package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"regexp"
)

func main() {
	input, err := io.ReadAll(os.Stdin)
	if err != nil {
		panic(err)
	}
	ilen := len(input)
	seq := regexp.MustCompile(">.*\n|\n").ReplaceAll(input, nil)
	clen := len(seq)

	variants := []string{
		"agggtaaa|tttaccct",
		"[cgt]gggtaaa|tttaccc[acg]",
		"a[act]ggtaaa|tttacc[agt]t",
		"ag[act]gtaaa|tttac[agt]ct",
		"agg[act]taaa|ttta[agt]cct",
		"aggg[acg]aaa|ttt[cgt]ccct",
		"agggt[cgt]aa|tt[acg]accct",
		"agggta[cgt]a|t[acg]taccct",
		"agggtaa[cgt]|[acg]ttaccct",
	}
	out := bufio.NewWriter(os.Stdout)
	defer out.Flush()
	for _, v := range variants {
		count := len(regexp.MustCompile(v).FindAllIndex(seq, -1))
		fmt.Fprintf(out, "%s %d\n", v, count)
	}

	substs := []struct{ pat, rep string }{
		{"tHa[Nt]", "<4>"},
		{"aND|caN|Ha[DS]|WaS", "<3>"},
		{"a[NSt]|BY", "<2>"},
		{"<[^>]*>", "|"},
		{"\\|[^|][^|]*\\|", "-"},
	}
	s := seq
	for _, sub := range substs {
		s = regexp.MustCompile(sub.pat).ReplaceAllLiteral(s, []byte(sub.rep))
	}
	fmt.Fprintf(out, "\n%d\n%d\n%d\n", ilen, clen, len(s))
}
