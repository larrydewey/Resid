package main

import (
	"math/big"

	"github.com/cronokirby/saferith"
	"github.com/taurusgroup/multi-party-sig/pkg/math/arith"
	"github.com/taurusgroup/multi-party-sig/pkg/pedersen"
)

// pedersenFrom builds Pedersen parameters from public N, S, T. The
// arithmetic modulus normally comes from the factors; a verifier only has N,
// and Verify needs just the exponentiation by public values, so a modulus
// built from N is enough.
func pedersenFrom(n *saferith.Modulus, s, t *big.Int) *pedersen.Parameters {
	return pedersen.New(arith.ModulusFromN(n), nat(s), nat(t))
}
