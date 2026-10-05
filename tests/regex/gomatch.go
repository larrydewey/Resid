package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strings"
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
			fmt.Fprintln(w, "E")
			continue
		}
		if re.MatchString(strings.ReplaceAll(f[1], "~", "\n")) {
			fmt.Fprintln(w, "1")
		} else {
			fmt.Fprintln(w, "0")
		}
	}
}
