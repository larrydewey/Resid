// genvec: Symbolon's oracle for the CGGMP21 zero-knowledge proofs.
//
// It makes proofs with the Taurus implementation (transcript hash patched to
// SHA-256, see sha256-transcript.patch) and prints them as JSON of hex
// strings, and it verifies proofs read from JSON, so that the Resid prover
// and verifier can be checked against it in both directions.
//
//	genvec keys N                 N fresh Paillier keys (p, q) as JSON
//	genvec prm   < key.json       a Pedersen-parameter proof for that key
//	genvec mod   < key.json       a Paillier-Blum modulus proof
//	genvec verify-prm < proof.json
//	genvec verify-mod < proof.json
package main

import (
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"math/big"
	"os"

	"github.com/cronokirby/saferith"
	"github.com/taurusgroup/multi-party-sig/pkg/hash"
	"github.com/taurusgroup/multi-party-sig/pkg/paillier"
	"github.com/taurusgroup/multi-party-sig/pkg/pool"
	zkmod "github.com/taurusgroup/multi-party-sig/pkg/zk/mod"
	zkprm "github.com/taurusgroup/multi-party-sig/pkg/zk/prm"
)

func hx(b *big.Int) string {
	if b.Sign() == 0 {
		return ""
	}
	s := b.Text(16)
	if len(s)%2 == 1 {
		s = "0" + s
	}
	return s
}

func un(s string) *big.Int {
	b, _ := hex.DecodeString(s)
	return new(big.Int).SetBytes(b)
}

func nat(b *big.Int) *saferith.Nat { return new(saferith.Nat).SetBig(b, b.BitLen()) }

type Key struct {
	P, Q string
}

type PrmJSON struct {
	N, S, T    string
	Lambda     string `json:",omitempty"`
	Phi        string `json:",omitempty"`
	P, Q       string `json:",omitempty"`
	As, Zs     []string
	Transcript string // hex of the prefix written before the proof (empty: none)
}

type ModResp struct {
	A, B bool
	X, Z string
}
type ModJSON struct {
	N, P, Q, Phi string
	W            string
	Responses    []ModResp
}

func must(err error) {
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func main() {
	pl := pool.NewPool(0)
	defer pl.TearDown()
	switch os.Args[1] {
	case "keys":
		var n int
		fmt.Sscan(os.Args[2], &n)
		var ks []Key
		for i := 0; i < n; i++ {
			sk := paillier.NewSecretKey(pl)
			ks = append(ks, Key{P: hx(sk.P().Big()), Q: hx(sk.Q().Big())})
		}
		must(json.NewEncoder(os.Stdout).Encode(ks))
	case "prm":
		var k Key
		must(json.NewDecoder(os.Stdin).Decode(&k))
		sk := paillier.NewSecretKeyFromPrimes(nat(un(k.P)), nat(un(k.Q)))
		ped, lambda := sk.GeneratePedersen()
		pub := zkprm.Public{Aux: ped}
		proof := zkprm.NewProof(zkprm.Private{Lambda: lambda, Phi: sk.Phi(), P: sk.P(), Q: sk.Q()}, hash.New(), pub, pl)
		out := PrmJSON{N: hx(ped.N().Big()), S: hx(ped.S().Big()), T: hx(ped.T().Big()),
			Lambda: hx(lambda.Big()), Phi: hx(sk.Phi().Big()), P: k.P, Q: k.Q}
		for i := range proof.As {
			out.As = append(out.As, hx(proof.As[i]))
			out.Zs = append(out.Zs, hx(proof.Zs[i]))
		}
		must(json.NewEncoder(os.Stdout).Encode(out))
	case "verify-prm":
		var in PrmJSON
		must(json.NewDecoder(os.Stdin).Decode(&in))
		n := saferith.ModulusFromNat(nat(un(in.N)))
		var proof zkprm.Proof
		for i := range proof.As {
			proof.As[i] = un(in.As[i])
			proof.Zs[i] = un(in.Zs[i])
		}
		// Rebuild the Pedersen parameters through a throwaway secret key is not
		// possible without the factors, so the verifier is driven through the
		// exported constructor with the arithmetic modulus built from N alone.
		pub := zkprm.Public{Aux: pedersenFrom(n, un(in.S), un(in.T))}
		fmt.Println(proof.Verify(pub, hash.New(), pl))
	case "mod":
		var k Key
		must(json.NewDecoder(os.Stdin).Decode(&k))
		sk := paillier.NewSecretKeyFromPrimes(nat(un(k.P)), nat(un(k.Q)))
		pub := zkmod.Public{N: saferith.ModulusFromNat(new(saferith.Nat).Mul(sk.P(), sk.Q(), -1))}
		proof := zkmod.NewProof(hash.New(), zkmod.Private{P: sk.P(), Q: sk.Q(), Phi: sk.Phi()}, pub, pl)
		out := ModJSON{N: hx(pub.N.Big()), P: k.P, Q: k.Q, Phi: hx(sk.Phi().Big()), W: hx(proof.W)}
		for _, r := range proof.Responses {
			out.Responses = append(out.Responses, ModResp{A: r.A, B: r.B, X: hx(r.X), Z: hx(r.Z)})
		}
		must(json.NewEncoder(os.Stdout).Encode(out))
	case "verify-mod":
		var in ModJSON
		must(json.NewDecoder(os.Stdin).Decode(&in))
		pub := zkmod.Public{N: saferith.ModulusFromNat(nat(un(in.N)))}
		proof := zkmod.Proof{W: un(in.W)}
		for i, r := range in.Responses {
			proof.Responses[i] = zkmod.Response{A: r.A, B: r.B, X: un(r.X), Z: un(r.Z)}
		}
		fmt.Println(proof.Verify(pub, hash.New(), pl))
	case "fac":
		var two Two
		readJSON(&two)
		writeJSON(facGen(two))
	case "verify-fac":
		var in FacJSON
		readJSON(&in)
		fmt.Println(facVerify(in))
	case "enc":
		var two Two
		readJSON(&two)
		writeJSON(encGen(two))
	case "verify-enc":
		var in EncJSON
		readJSON(&in)
		fmt.Println(encVerify(in))
	case "affg":
		var two Two
		readJSON(&two)
		writeJSON(affgGen(two))
	case "verify-affg":
		var in AffgJSON
		readJSON(&in)
		fmt.Println(affgVerify(in))
	case "affp":
		var two Two
		readJSON(&two)
		writeJSON(affpGen(two))
	case "verify-affp":
		var in AffpJSON
		readJSON(&in)
		fmt.Println(affpVerify(in))
	case "logstar":
		var two Two
		readJSON(&two)
		writeJSON(logstarGen(two))
	case "verify-logstar":
		var in LogstarJSON
		readJSON(&in)
		fmt.Println(logstarVerify(in))
	case "encelg":
		var two Two
		readJSON(&two)
		writeJSON(encelgGen(two))
	case "verify-encelg":
		var in EncelgJSON
		readJSON(&in)
		fmt.Println(encelgVerify(in))
	case "elog":
		writeJSON(elogGen())
	case "verify-elog":
		var in ElogJSON
		readJSON(&in)
		fmt.Println(elogVerify(in))
	case "log":
		writeJSON(logGen())
	case "verify-log":
		var in LogJSON
		readJSON(&in)
		fmt.Println(logVerify(in))
	case "nth":
		var p Pair
		readJSON(&p)
		writeJSON(nthGen(p))
	case "verify-nth":
		var in NthJSON
		readJSON(&in)
		fmt.Println(nthVerify(in))
	case "sch":
		writeJSON(schGen())
	case "verify-sch":
		var in SchJSON
		readJSON(&in)
		fmt.Println(schVerify(in))
	default:
		_, _ = io.WriteString(os.Stderr, "unknown command\n")
		os.Exit(2)
	}
}
