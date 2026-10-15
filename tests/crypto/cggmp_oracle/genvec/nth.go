package main

import (
	"crypto/rand"

	"github.com/taurusgroup/multi-party-sig/pkg/hash"
	"github.com/taurusgroup/multi-party-sig/pkg/math/sample"
	"github.com/taurusgroup/multi-party-sig/pkg/paillier"
	zknth "github.com/taurusgroup/multi-party-sig/pkg/zk/nth"
)

// NthJSON: a ciphertext C of the plaintext M (signed), its hidden nonce
// R = rho^N mod N^2 as recovered by DecWithRandomness, and the nth proof.
type NthJSON struct {
	N, C, M, R, A, Z string
}

func nthGen(p Pair) NthJSON {
	sk := paillier.NewSecretKeyFromPrimes(nat(un(p.P)), nat(un(p.Q)))
	pk := sk.PublicKey
	m := sample.IntervalLPrimeEps(rand.Reader)
	ct, _ := pk.Enc(m)
	plain, nonce, err := sk.DecWithRandomness(ct)
	must(err)
	if plain.Eq(m) != 1 {
		panic("decryption does not match")
	}
	r := pk.ModulusSquared().Exp(nonce, pk.N().Nat())
	proof := zknth.NewProof(hash.New(), zknth.Public{N: pk, R: r}, zknth.Private{Rho: nonce})
	return NthJSON{
		N: hx(pk.N().Big()), C: hx(ct.Nat().Big()), M: shx(plain), R: hx(r.Big()),
		A: hx(proof.A.Big()), Z: hx(proof.Z.Big()),
	}
}

func nthVerify(in NthJSON) bool {
	pk := paillier.NewPublicKey(mod(in.N))
	proof := &zknth.Proof{Commitment: zknth.Commitment{A: natW(in.A, 4096)}, Z: natW(in.Z, 2048)}
	return proof.Verify(hash.New(), zknth.Public{N: pk, R: natW(in.R, 4096)})
}
