package main

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	n, _ := strconv.Atoi(os.Args[1])
	s := ""
	for i := 0; i < n; i++ {
		s = s + strconv.Itoa(i) + ","
	}
	fmt.Println(len(s))
}
