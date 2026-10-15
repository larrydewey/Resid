package main

import (
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"math/big"
	"os"
	"strings"

	"github.com/cronokirby/saferith"
	"github.com/taurusgroup/multi-party-sig/pkg/paillier"
	"github.com/taurusgroup/multi-party-sig/pkg/pedersen"
	"github.com/taurusgroup/multi-party-sig/pkg/math/arith"
)

// Signed integers are written as hex with a leading "-" when negative.
func shx(i *saferith.Int) string {
	b := i.Big()
	if b.Sign() < 0 {
		return "-" + hx(new(big.Int).Neg(b))
	}
	return hx(b)
}

func unI(s string) *saferith.Int {
	neg := strings.HasPrefix(s, "-")
	s = strings.TrimPrefix(s, "-")
	b := un(s)
	out := new(saferith.Int).SetBig(b, b.BitLen())
	if neg {
		out.Neg(1)
	}
	return out
}

// A Nat at a fixed announced width, as the protocol's decoded messages are.
func natW(s string, bits int) *saferith.Nat {
	return new(saferith.Nat).SetBig(un(s), bits)
}

func mod(s string) *saferith.Modulus { return saferith.ModulusFromNat(nat(un(s))) }

func pedFrom(n, s, t string) *pedersen.Parameters {
	return pedersen.New(arith.ModulusFromN(mod(n)), natW(s, 2048), natW(t, 2048))
}

type Pair struct{ P, Q string }

func readJSON(v interface{}) {
	if err := json.NewDecoder(os.Stdin).Decode(v); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func writeJSON(v interface{}) { must(json.NewEncoder(os.Stdout).Encode(v)) }

var _ = io.EOF
var _ = hex.EncodeToString
var _ = paillier.NewPublicKey
