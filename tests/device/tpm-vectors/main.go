// Vector generator for tests/conformance/cases/device_tpm_wire.resid:
// google/go-tpm (legacy/tpm2, the version go.mod pins) encodes each TPM
// command, and decodes a hand-built response, through a fake TPM that
// records what is written and answers the canned bytes. Both are printed
// as hex, with what go-tpm decoded. Run: `go run .` in this directory
// (needs network for the module once). Not part of any suite.
package main

import (
	"bytes"
	"encoding/binary"
	"encoding/hex"
	"fmt"

	"github.com/google/go-tpm/legacy/tpm2"
)

type fake struct {
	cmds  [][]byte
	resps [][]byte
	rbuf  *bytes.Buffer
}

func (f *fake) Write(p []byte) (int, error) {
	f.cmds = append(f.cmds, append([]byte{}, p...))
	f.rbuf = bytes.NewBuffer(f.resps[0])
	f.resps = f.resps[1:]
	return len(p), nil
}
func (f *fake) Read(p []byte) (int, error) { return f.rbuf.Read(p) }

func be16(v int) []byte        { b := make([]byte, 2); binary.BigEndian.PutUint16(b, uint16(v)); return b }
func be32(v uint32) []byte     { b := make([]byte, 4); binary.BigEndian.PutUint32(b, v); return b }
func tb(b []byte) []byte       { return append(be16(len(b)), b...) }
func rep(x byte, n int) []byte { return bytes.Repeat([]byte{x}, n) }
func cat(bs ...[]byte) []byte {
	var o []byte
	for _, b := range bs {
		o = append(o, b...)
	}
	return o
}
func resp(sessions bool, params []byte) []byte {
	tag := 0x8001
	body := params
	if sessions {
		tag = 0x8002
		body = cat(be32(uint32(len(params))), params, be16(0), []byte{1}, be16(0))
	}
	return cat(be16(tag), be32(uint32(10+len(body))), be32(0), body)
}
func h(b []byte) string { return hex.EncodeToString(b) }

func main() {
	sel := tpm2.PCRSelection{Hash: tpm2.AlgSHA256, PCRs: []int{0, 1, 7}}
	selBytes := cat(be32(1), be16(0x000b), []byte{3, 0x83, 0, 0})

	// GetRandom
	{
		r := resp(false, tb([]byte{1, 2, 3, 4, 5, 6, 7, 8}))
		f := &fake{resps: [][]byte{r}}
		out, err := tpm2.GetRandom(f, 8)
		fmt.Printf("getrandom cmd %s\nresp %s\n=> %x %v\n", h(f.cmds[0]), h(r), out, err)
	}
	// PCR_Read
	{
		r := resp(false, cat(be32(42), selBytes, be32(3), tb(rep(0x11, 32)), tb(rep(0x22, 32)), tb(rep(0x77, 32))))
		f := &fake{resps: [][]byte{r}}
		out, err := tpm2.ReadPCRs(f, sel)
		fmt.Printf("pcrread cmd %s\nresp %s\n=> 0:%x 1:%x 7:%x %v\n", h(f.cmds[0]), h(r), out[0][:2], out[1][:2], out[7][:2], err)
	}
	// ReadPublic of an ECC P-256 signing key
	{
		pub := cat(be16(0x0023), be16(0x000b), be32(0x00050072), tb(nil),
			be16(0x0010), be16(0x0018), be16(0x000b), be16(0x0003), be16(0x0010),
			tb(rep(0x5a, 32)), tb(rep(0xa5, 32)))
		name := cat(be16(0x000b), rep(0x33, 32))
		qn := cat(be16(0x000b), rep(0x44, 32))
		r := resp(false, cat(tb(pub), tb(name), tb(qn)))
		f := &fake{resps: [][]byte{r}}
		p, n, q, err := tpm2.ReadPublic(f, 0x81000003)
		fmt.Printf("readpublic cmd %s\nresp %s\n=> type %x namealg %x curve %x name %x.. qn %x.. %v\n", h(f.cmds[0]), h(r), p.Type, p.NameAlg, p.ECCParameters.CurveID, n[:3], q[:3], err)
	}
	// NV_ReadPublic + NV_Read (one block)
	{
		nvp := cat(be32(0x01400001), be16(0x000b), be32(0x000a0006), tb(nil), be16(8))
		nvname := cat(be16(0x000b), rep(0x66, 32))
		r1 := resp(false, cat(tb(nvp), tb(nvname)))
		r2 := resp(true, tb([]byte{0xde, 0xad, 0xbe, 0xef, 1, 2, 3, 4}))
		f := &fake{resps: [][]byte{r1, r2}}
		out, err := tpm2.NVReadEx(f, 0x01400001, tpm2.HandleOwner, "", 1024)
		fmt.Printf("nvreadpublic cmd %s\nresp %s\nnvread cmd %s\nresp %s\n=> %x %v\n", h(f.cmds[0]), h(r1), h(f.cmds[1]), h(r2), out, err)
	}
	// Quote with an ECDSA AK
	{
		nonce := rep(0xaa, 32)
		attest := cat(be32(0xff544347), be16(0x8018), tb(cat(be16(0x000b), rep(0x33, 32))), tb(nonce),
			be32(0), be32(0x00123456), be32(7), be32(3), []byte{1}, be32(0x20240101), be32(0x00000002),
			selBytes, tb(rep(0x99, 32)))
		sig := cat(be16(0x0018), be16(0x000b), tb(rep(0x01, 32)), tb(rep(0x02, 32)))
		r := resp(true, cat(tb(attest), sig))
		f := &fake{resps: [][]byte{r}}
		a, s, err := tpm2.Quote(f, 0x81000003, "", "", nonce, sel, tpm2.AlgNull)
		ad, err2 := tpm2.DecodeAttestationData(a)
		fmt.Printf("quote cmd %s\nresp %s\n=> attest %d bytes sig alg %x hash %x r %x.. %v | extra %x.. clock %d reset %d restart %d safe %v fw %x pcrs %v digest %x.. %v\n",
			h(f.cmds[0]), h(r), len(a), s.Alg, s.ECC.HashAlg, s.ECC.R.Bytes()[:2], err,
			[]byte(ad.ExtraData)[:2], ad.ClockInfo.Clock, ad.ClockInfo.ResetCount, ad.ClockInfo.RestartCount, ad.ClockInfo.Safe, ad.FirmwareVersion, ad.AttestedQuoteInfo.PCRSelection.PCRs, []byte(ad.AttestedQuoteInfo.PCRDigest)[:2], err2)
	}
	// GetCapability: handles
	{
		r := resp(false, cat([]byte{0}, be32(1), be32(2), be32(0x81000001), be32(0x81000003)))
		f := &fake{resps: [][]byte{r}}
		vals, more, err := tpm2.GetCapability(f, tpm2.CapabilityHandles, 10, 0x81000000)
		fmt.Printf("gethandles cmd %s\nresp %s\n=> %v %v %v\n", h(f.cmds[0]), h(r), vals, more, err)
	}
}
