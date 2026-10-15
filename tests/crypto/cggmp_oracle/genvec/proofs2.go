package main

import (
	"crypto/rand"
	"encoding/hex"

	"github.com/cronokirby/saferith"
	"github.com/taurusgroup/multi-party-sig/internal/elgamal"
	"github.com/taurusgroup/multi-party-sig/internal/mta"
	"github.com/taurusgroup/multi-party-sig/pkg/hash"
	"github.com/taurusgroup/multi-party-sig/pkg/math/curve"
	"github.com/taurusgroup/multi-party-sig/pkg/math/sample"
	"github.com/taurusgroup/multi-party-sig/pkg/paillier"
	zkaffg "github.com/taurusgroup/multi-party-sig/pkg/zk/affg"
	zkaffp "github.com/taurusgroup/multi-party-sig/pkg/zk/affp"
	zkelog "github.com/taurusgroup/multi-party-sig/pkg/zk/elog"
	zkencelg "github.com/taurusgroup/multi-party-sig/pkg/zk/encelg"
	zklog "github.com/taurusgroup/multi-party-sig/pkg/zk/log"
	zklogstar "github.com/taurusgroup/multi-party-sig/pkg/zk/logstar"
	zksch "github.com/taurusgroup/multi-party-sig/pkg/zk/sch"
)

var grp = curve.P256{}

func pt(p curve.Point) string {
	b, _ := p.MarshalBinary()
	return hex.EncodeToString(b)
}

func unPt(s string) curve.Point {
	b, _ := hex.DecodeString(s)
	p := grp.NewPoint()
	if err := p.UnmarshalBinary(b); err != nil {
		panic(err)
	}
	return p
}

func sc(s curve.Scalar) string {
	b, _ := s.MarshalBinary()
	return hex.EncodeToString(b)
}

func unSc(s string) curve.Scalar {
	b, _ := hex.DecodeString(s)
	x := grp.NewScalar()
	if err := x.UnmarshalBinary(b); err != nil {
		panic(err)
	}
	return x
}

func ctOf(c *paillier.Ciphertext) string { return hx(c.Nat().Big()) }

func unCt(s string) *paillier.Ciphertext {
	c := &paillier.Ciphertext{}
	_ = c.UnmarshalBinary(un(s).FillBytes(make([]byte, 512)))
	return c
}

func keysFrom(two Two) (*paillier.SecretKey, *paillier.SecretKey) {
	return paillier.NewSecretKeyFromPrimes(nat(un(two.Prover.P)), nat(un(two.Prover.Q))),
		paillier.NewSecretKeyFromPrimes(nat(un(two.Verifier.P)), nat(un(two.Verifier.Q)))
}

// ---- aff-g
type AffgJSON struct {
	NP, NV, Nhat, S, T                                  string
	Kv, Dv, Fp, Xp                                       string
	A, Bx, By, E, SS, F, TT, Z1, Z2, Z3, Z4, W, Wy string
}

func affgGen(two Two) AffgJSON {
	psk, vsk := keysFrom(two)
	aux, _ := vsk.GeneratePedersen()
	kv, _ := vsk.PublicKey.Enc(sample.IntervalL(rand.Reader))
	x := sample.IntervalL(rand.Reader)
	xs := grp.NewScalar().SetNat(x.Mod(grp.Order()))
	_ = xs
	xp := grp.NewScalar().SetNat(x.Mod(grp.Order())).ActOnBase()
	h := hash.New()
	_, d, f, proof := mta.ProveAffG(grp, h, x, xp, kv, psk, vsk.PublicKey, aux)
	_ = hash.New
	return AffgJSON{
		NP: hx(psk.PublicKey.N().Big()), NV: hx(vsk.PublicKey.N().Big()), Nhat: hx(aux.N().Big()), S: hx(aux.S().Big()), T: hx(aux.T().Big()),
		Kv: ctOf(kv), Dv: ctOf(d), Fp: ctOf(f), Xp: pt(xp),
		A: ctOf(proof.A), Bx: pt(proof.Bx), By: ctOf(proof.By), E: hx(proof.E.Big()), SS: hx(proof.S.Big()), F: hx(proof.F.Big()), TT: hx(proof.T.Big()),
		Z1: shx(proof.Z1), Z2: shx(proof.Z2), Z3: shx(proof.Z3), Z4: shx(proof.Z4), W: hx(proof.W.Big()), Wy: hx(proof.Wy.Big()),
	}
}

func affgVerify(in AffgJSON) bool {
	pp := paillier.NewPublicKey(mod(in.NP))
	vp := paillier.NewPublicKey(mod(in.NV))
	pub := zkaffg.Public{Kv: unCt(in.Kv), Dv: unCt(in.Dv), Fp: unCt(in.Fp), Xp: unPt(in.Xp), Prover: pp, Verifier: vp, Aux: pedFrom(in.Nhat, in.S, in.T)}
	proof := zkaffg.Empty(grp)
	proof.Commitment = &zkaffg.Commitment{A: unCt(in.A), Bx: unPt(in.Bx), By: unCt(in.By), E: natW(in.E, 2048), S: natW(in.SS, 2048), F: natW(in.F, 2048), T: natW(in.TT, 2048)}
	proof.Z1, proof.Z2, proof.Z3, proof.Z4 = unI(in.Z1), unI(in.Z2), unI(in.Z3), unI(in.Z4)
	proof.W, proof.Wy = natW(in.W, 2048), natW(in.Wy, 2048)
	return proof.Verify(hash.New(), pub)
}

// ---- aff-p
type AffpJSON struct {
	NP, NV, Nhat, S, T                                       string
	Kv, Dv, Fp, Xp                                            string
	A, Bx, By, E, SS, F, TT, Z1, Z2, Z3, Z4, W, Wx, Wy string
}

func affpGen(two Two) AffpJSON {
	psk, vsk := keysFrom(two)
	aux, _ := vsk.GeneratePedersen()
	kv, _ := vsk.PublicKey.Enc(sample.IntervalL(rand.Reader))
	x := sample.IntervalL(rand.Reader)
	xp, rx := psk.PublicKey.Enc(x)
	_, d, f, proof := mta.ProveAffP(grp, hash.New(), x, xp, rx, kv, psk, vsk.PublicKey, aux)
	return AffpJSON{
		NP: hx(psk.PublicKey.N().Big()), NV: hx(vsk.PublicKey.N().Big()), Nhat: hx(aux.N().Big()), S: hx(aux.S().Big()), T: hx(aux.T().Big()),
		Kv: ctOf(kv), Dv: ctOf(d), Fp: ctOf(f), Xp: ctOf(xp),
		A: ctOf(proof.A), Bx: ctOf(proof.Bx), By: ctOf(proof.By), E: hx(proof.E.Big()), SS: hx(proof.S.Big()), F: hx(proof.F.Big()), TT: hx(proof.T.Big()),
		Z1: shx(proof.Z1), Z2: shx(proof.Z2), Z3: shx(proof.Z3), Z4: shx(proof.Z4), W: hx(proof.W.Big()), Wx: hx(proof.Wx.Big()), Wy: hx(proof.Wy.Big()),
	}
}

func affpVerify(in AffpJSON) bool {
	pp := paillier.NewPublicKey(mod(in.NP))
	vp := paillier.NewPublicKey(mod(in.NV))
	pub := zkaffp.Public{Kv: unCt(in.Kv), Dv: unCt(in.Dv), Fp: unCt(in.Fp), Xp: unCt(in.Xp), Prover: pp, Verifier: vp, Aux: pedFrom(in.Nhat, in.S, in.T)}
	proof := &zkaffp.Proof{
		Commitment: &zkaffp.Commitment{A: unCt(in.A), Bx: unCt(in.Bx), By: unCt(in.By), E: natW(in.E, 2048), S: natW(in.SS, 2048), F: natW(in.F, 2048), T: natW(in.TT, 2048)},
		Z1: unI(in.Z1), Z2: unI(in.Z2), Z3: unI(in.Z3), Z4: unI(in.Z4), W: natW(in.W, 2048), Wx: natW(in.Wx, 2048), Wy: natW(in.Wy, 2048),
	}
	return proof.Verify(grp, hash.New(), pub)
}

// ---- log*
type LogstarJSON struct {
	N, Nhat, S, T string
	C, X, G       string
	CS, A, Y, D   string
	Z1, Z2, Z3    string
}

func logstarGen(two Two) LogstarJSON {
	psk, vsk := keysFrom(two)
	aux, _ := vsk.GeneratePedersen()
	x := sample.IntervalL(rand.Reader)
	c, rho := psk.PublicKey.Enc(x)
	g := sample.Scalar(rand.Reader, grp).ActOnBase() // a base other than G
	xp := grp.NewScalar().SetNat(x.Mod(grp.Order())).Act(g)
	pub := zklogstar.Public{C: c, X: xp, G: g, Prover: psk.PublicKey, Aux: aux}
	proof := zklogstar.NewProof(grp, hash.New(), pub, zklogstar.Private{X: x, Rho: rho})
	return LogstarJSON{
		N: hx(psk.PublicKey.N().Big()), Nhat: hx(aux.N().Big()), S: hx(aux.S().Big()), T: hx(aux.T().Big()),
		C: ctOf(c), X: pt(xp), G: pt(g),
		CS: hx(proof.S.Big()), A: ctOf(proof.A), Y: pt(proof.Y), D: hx(proof.D.Big()),
		Z1: shx(proof.Z1), Z2: hx(proof.Z2.Big()), Z3: shx(proof.Z3),
	}
}

func logstarVerify(in LogstarJSON) bool {
	pub := zklogstar.Public{C: unCt(in.C), X: unPt(in.X), G: unPt(in.G), Prover: paillier.NewPublicKey(mod(in.N)), Aux: pedFrom(in.Nhat, in.S, in.T)}
	proof := zklogstar.Empty(grp)
	proof.Commitment = &zklogstar.Commitment{S: natW(in.CS, 2048), A: unCt(in.A), Y: unPt(in.Y), D: natW(in.D, 2048)}
	proof.Z1, proof.Z2, proof.Z3 = unI(in.Z1), natW(in.Z2, 2048), unI(in.Z3)
	return proof.Verify(hash.New(), pub)
}

// ---- enc-elg
type EncelgJSON struct {
	N, Nhat, S, T string
	C, A, B, X    string
	CS, D, Y, Z, TT string
	Z1, W, Z2, Z3 string
}

func encelgGen(two Two) EncelgJSON {
	psk, vsk := keysFrom(two)
	aux, _ := vsk.GeneratePedersen()
	a := sample.Scalar(rand.Reader, grp)
	apub := a.ActOnBase()
	kScalar := sample.Scalar(rand.Reader, grp)
	kInt := curve.MakeInt(kScalar)
	c, rho := psk.PublicKey.Enc(kInt)
	el, nonce := elgamal.Encrypt(apub, kScalar)
	pub := zkencelg.Public{C: c, A: apub, B: el.L, X: el.M, Prover: psk.PublicKey, Aux: aux}
	proof := zkencelg.NewProof(grp, hash.New(), pub, zkencelg.Private{X: kInt, Rho: rho, A: a, B: nonce})
	return EncelgJSON{
		N: hx(psk.PublicKey.N().Big()), Nhat: hx(aux.N().Big()), S: hx(aux.S().Big()), T: hx(aux.T().Big()),
		C: ctOf(c), A: pt(apub), B: pt(el.L), X: pt(el.M),
		CS: hx(proof.S.Big()), D: ctOf(proof.D), Y: pt(proof.Y), Z: pt(proof.Z), TT: hx(proof.T.Big()),
		Z1: shx(proof.Z1), W: sc(proof.W), Z2: hx(proof.Z2.Big()), Z3: shx(proof.Z3),
	}
}

func encelgVerify(in EncelgJSON) bool {
	pub := zkencelg.Public{C: unCt(in.C), A: unPt(in.A), B: unPt(in.B), X: unPt(in.X), Prover: paillier.NewPublicKey(mod(in.N)), Aux: pedFrom(in.Nhat, in.S, in.T)}
	proof := zkencelg.Empty(grp)
	proof.Commitment = &zkencelg.Commitment{S: natW(in.CS, 2048), D: unCt(in.D), Y: unPt(in.Y), Z: unPt(in.Z), T: natW(in.TT, 2048)}
	proof.Z1, proof.W, proof.Z2, proof.Z3 = unI(in.Z1), unSc(in.W), natW(in.Z2, 2048), unI(in.Z3)
	return proof.Verify(hash.New(), pub)
}

// ---- elog, log, sch
type ElogJSON struct{ EL, EM, X, Base, Y, A, N, B, Z, U string }

func elogGen() ElogJSON {
	x := sample.Scalar(rand.Reader, grp)
	xp := x.ActOnBase()
	base := sample.Scalar(rand.Reader, grp).ActOnBase()
	y := sample.Scalar(rand.Reader, grp)
	lam := sample.Scalar(rand.Reader, grp)
	el := &elgamal.Ciphertext{L: lam.ActOnBase(), M: y.ActOnBase().Add(lam.Act(xp))}
	yp := y.Act(base)
	pub := zkelog.Public{E: el, ElGamalPublic: xp, Base: base, Y: yp}
	proof := zkelog.NewProof(grp, hash.New(), pub, zkelog.Private{Y: y, Lambda: lam})
	return ElogJSON{EL: pt(el.L), EM: pt(el.M), X: pt(xp), Base: pt(base), Y: pt(yp), A: pt(proof.A), N: pt(proof.N), B: pt(proof.B), Z: sc(proof.Z), U: sc(proof.U)}
}

func elogVerify(in ElogJSON) bool {
	pub := zkelog.Public{E: &elgamal.Ciphertext{L: unPt(in.EL), M: unPt(in.EM)}, ElGamalPublic: unPt(in.X), Base: unPt(in.Base), Y: unPt(in.Y)}
	proof := zkelog.Empty(grp)
	proof.Commitment = &zkelog.Commitment{A: unPt(in.A), N: unPt(in.N), B: unPt(in.B)}
	proof.Z, proof.U = unSc(in.Z), unSc(in.U)
	return proof.Verify(hash.New(), pub)
}

type LogJSON struct{ H, X, Y, A, B, C, Z1, Z2 string }

func logGen() LogJSON {
	a := sample.Scalar(rand.Reader, grp)
	b := sample.Scalar(rand.Reader, grp)
	h := b.ActOnBase()
	x := a.ActOnBase()
	y := a.Act(h)
	proof := zklog.NewProof(grp, hash.New(), zklog.Public{H: h, X: x, Y: y}, zklog.Private{A: a, B: b})
	return LogJSON{H: pt(h), X: pt(x), Y: pt(y), A: pt(proof.A), B: pt(proof.B), C: pt(proof.C), Z1: sc(proof.Z1), Z2: sc(proof.Z2)}
}

func logVerify(in LogJSON) bool {
	proof := zklog.Empty(grp)
	proof.Commitment = &zklog.Commitment{A: unPt(in.A), B: unPt(in.B), C: unPt(in.C)}
	proof.Z1, proof.Z2 = unSc(in.Z1), unSc(in.Z2)
	return proof.Verify(hash.New(), zklog.Public{H: unPt(in.H), X: unPt(in.X), Y: unPt(in.Y)})
}

type SchJSON struct{ X, G, C, Z string }

func schGen() SchJSON {
	x := sample.Scalar(rand.Reader, grp)
	g := sample.Scalar(rand.Reader, grp).ActOnBase()
	xp := x.Act(g)
	proof := zksch.NewProof(hash.New(), xp, x, g)
	return SchJSON{X: pt(xp), G: pt(g), C: pt(proof.C.C), Z: sc(proof.Z.Z)}
}

func schVerify(in SchJSON) bool {
	resp := zksch.EmptyResponse(grp)
	resp.Z = unSc(in.Z)
	proof := &zksch.Proof{C: zksch.Commitment{C: unPt(in.C)}, Z: *resp}
	return proof.Verify(hash.New(), unPt(in.X), unPt(in.G))
}

var _ = saferith.Nat{}
