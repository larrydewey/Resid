package main

import (
	"crypto/rand"

	"github.com/cronokirby/saferith"
	"github.com/taurusgroup/multi-party-sig/pkg/hash"
	"github.com/taurusgroup/multi-party-sig/pkg/math/curve"
	"github.com/taurusgroup/multi-party-sig/pkg/math/sample"
	"github.com/taurusgroup/multi-party-sig/pkg/paillier"
	zkenc "github.com/taurusgroup/multi-party-sig/pkg/zk/enc"
	zkfac "github.com/taurusgroup/multi-party-sig/pkg/zk/fac"
)

// Input to fac and enc: the prover's primes and the verifier's primes (whose
// Pedersen parameters are the auxiliary parameters).
type Two struct{ Prover, Verifier Pair }

type FacJSON struct {
	N, Nhat, S, T          string
	P, Q, A, B, Tc         string
	Sigma, Z1, Z2, W1, W2, V string
}

func facGen(two Two) FacJSON {
	sk := paillier.NewSecretKeyFromPrimes(nat(un(two.Prover.P)), nat(un(two.Prover.Q)))
	vsk := paillier.NewSecretKeyFromPrimes(nat(un(two.Verifier.P)), nat(un(two.Verifier.Q)))
	aux, _ := vsk.GeneratePedersen()
	pub := zkfac.Public{N: sk.PublicKey.N(), Aux: aux}
	proof := zkfac.NewProof(zkfac.Private{P: sk.P(), Q: sk.Q()}, hash.New(), pub)
	return FacJSON{
		N: hx(sk.PublicKey.N().Big()), Nhat: hx(aux.N().Big()), S: hx(aux.S().Big()), T: hx(aux.T().Big()),
		P: hx(proof.Comm.P.Big()), Q: hx(proof.Comm.Q.Big()), A: hx(proof.Comm.A.Big()), B: hx(proof.Comm.B.Big()), Tc: hx(proof.Comm.T.Big()),
		Sigma: shx(proof.Sigma), Z1: shx(proof.Z1), Z2: shx(proof.Z2), W1: shx(proof.W1), W2: shx(proof.W2), V: shx(proof.V),
	}
}

func facVerify(in FacJSON) bool {
	pub := zkfac.Public{N: mod(in.N), Aux: pedFrom(in.Nhat, in.S, in.T)}
	proof := &zkfac.Proof{
		Comm: zkfac.Commitment{P: natW(in.P, 2048), Q: natW(in.Q, 2048), A: natW(in.A, 2048), B: natW(in.B, 2048), T: natW(in.Tc, 2048)},
		Sigma: unI(in.Sigma), Z1: unI(in.Z1), Z2: unI(in.Z2), W1: unI(in.W1), W2: unI(in.W2), V: unI(in.V),
	}
	return proof.Verify(pub, hash.New())
}

type EncJSON struct {
	N, Nhat, S, T string
	K             string // ciphertext
	CS, CA, CC    string // commitment S, A, C
	Z1, Z2, Z3    string
}

func encGen(two Two) EncJSON {
	sk := paillier.NewSecretKeyFromPrimes(nat(un(two.Prover.P)), nat(un(two.Prover.Q)))
	vsk := paillier.NewSecretKeyFromPrimes(nat(un(two.Verifier.P)), nat(un(two.Verifier.Q)))
	aux, _ := vsk.GeneratePedersen()
	k := sample.IntervalL(rand.Reader)
	ct, rho := sk.PublicKey.Enc(k)
	pub := zkenc.Public{K: ct, Prover: sk.PublicKey, Aux: aux}
	proof := zkenc.NewProof(curve.P256{}, hash.New(), pub, zkenc.Private{K: k, Rho: rho})
	return EncJSON{
		N: hx(sk.PublicKey.N().Big()), Nhat: hx(aux.N().Big()), S: hx(aux.S().Big()), T: hx(aux.T().Big()),
		K: hx(ct.Nat().Big()), CS: hx(proof.S.Big()), CA: hx(proof.A.Nat().Big()), CC: hx(proof.C.Big()),
		Z1: shx(proof.Z1), Z2: hx(proof.Z2.Big()), Z3: shx(proof.Z3),
	}
}

func encVerify(in EncJSON) bool {
	pk := paillier.NewPublicKey(mod(in.N))
	ct := &paillier.Ciphertext{}
	_ = ct.UnmarshalBinary(un(in.K).FillBytes(make([]byte, 512)))
	a := &paillier.Ciphertext{}
	_ = a.UnmarshalBinary(un(in.CA).FillBytes(make([]byte, 512)))
	pub := zkenc.Public{K: ct, Prover: pk, Aux: pedFrom(in.Nhat, in.S, in.T)}
	proof := &zkenc.Proof{
		Commitment: &zkenc.Commitment{S: natW(in.CS, 2048), A: a, C: natW(in.CC, 2048)},
		Z1: unI(in.Z1), Z2: natW(in.Z2, 2048), Z3: unI(in.Z3),
	}
	return proof.Verify(curve.P256{}, hash.New(), pub)
}

var _ = saferith.Nat{}
