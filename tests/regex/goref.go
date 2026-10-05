package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strings"
	"unicode/utf8"
)

func main() {
	sc := bufio.NewScanner(os.Stdin)
	sc.Buffer(make([]byte, 1<<20), 1<<26)
	w := bufio.NewWriter(os.Stdout)
	defer w.Flush()
	for sc.Scan() {
		f := strings.SplitN(sc.Text(), "\t", 2)
		re, err := regexp.Compile(f[0])
		if err != nil {
			fmt.Fprintln(w, "ERR")
			continue
		}
		s := strings.ReplaceAll(f[1], "~", "\n")
		rc := func(x int) int { if x < 0 { return x }; return utf8.RuneCountInString(s[:x]) }
		var b strings.Builder
		for _, m := range re.FindAllStringSubmatchIndex(s, -1) {
			b.WriteString("[")
			for i, x := range m {
				if i > 0 {
					b.WriteString(", ")
				}
				fmt.Fprintf(&b, "%d", rc(x))
			}
			b.WriteString("]")
		}
		b.WriteString(" ")
		for _, m := range re.FindAllStringIndex(s, -1) {
			fmt.Fprintf(&b, "[%d, %d]", rc(m[0]), rc(m[1]))
		}
		b.WriteString(" ")
		b.WriteString(strings.ReplaceAll(re.ReplaceAllString(s, "<${1}>"), "\n", "~"))
		fmt.Fprintln(w, b.String())
	}
}
