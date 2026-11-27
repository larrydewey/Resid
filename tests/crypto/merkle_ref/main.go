// Vectors for lib/merkle.resid from an independent implementation:
// golang.org/x/mod/sumdb/tlog (RFC 6962/9162 tree hashing and proofs)
// and golang.org/x/mod/sumdb/note (signed notes, Ed25519), plus
// crypto/ed25519 for cosignature/v1 lines. Run by gen.sh; writes
// ../vectors_merkle/merkle.txt.
//
// Leaf i's entry is the two bytes (i & 255, i >> 8). Lines:
//   R n root
//   I n m root leafhash proof(hex, concatenated) want(1/0)
//   C m n rootm rootn proof want
//   N note-in-hex vkeyname pubhex want-origin-or-"-"
//   W note-in-hex logname logpub witname witpub threshold now want(1/0)
//   S seed name text note       (note_sign's output)
//   K seed name text time line  (cosig_line's output)
package main

import (
	"crypto/ed25519"
	"crypto/sha256"
	"encoding/base64"
	"encoding/binary"
	"encoding/hex"
	"fmt"
	"os"
	"strings"

	"golang.org/x/mod/sumdb/note"
	"golang.org/x/mod/sumdb/tlog"
)

type mem []tlog.Hash

func (m mem) ReadHashes(ix []int64) ([]tlog.Hash, error) {
	out := make([]tlog.Hash, len(ix))
	for i, x := range ix {
		out[i] = m[x]
	}
	return out, nil
}

func entry(i int) []byte { return []byte{byte(i & 255), byte(i >> 8)} }

func cat(p []tlog.Hash) string {
	var b strings.Builder
	for _, h := range p {
		b.WriteString(hex.EncodeToString(h[:]))
	}
	if b.Len() == 0 {
		return "-"
	}
	return b.String()
}

func flip(p []tlog.Hash, j int) []tlog.Hash {
	q := append([]tlog.Hash(nil), p...)
	q[j][j%32] ^= 1
	return q
}

func main() {
	out, _ := os.Create("../vectors_merkle/merkle.txt")
	defer out.Close()
	w := func(f string, a ...any) { fmt.Fprintf(out, f+"\n", a...) }
	const max = 70
	var store mem
	roots := map[int][]byte{}
	for n := 0; n < max; n++ {
		hs, _ := tlog.StoredHashes(int64(n), entry(n), store)
		store = append(store, hs...)
		r, _ := tlog.TreeHash(int64(n+1), store)
		rc := r; roots[n+1] = rc[:]
	}
	sizes := []int{}
	for n := 1; n <= max; n++ {
		sizes = append(sizes, n)
	}
	for _, n := range sizes {
		r := roots[n]
		_ = r
		w("R %d %s", n, hex.EncodeToString(r))
		for m := 0; m < n; m++ {
			if n > 20 && m%7 != 0 && m != n-1 {
				continue
			}
			p, err := tlog.ProveRecord(int64(n), int64(m), store)
			if err != nil {
				panic(err)
			}
			lh := tlog.RecordHash(entry(m))
			w("I %d %d %s %s %s 1", n, m, hex.EncodeToString(r), hex.EncodeToString(lh[:]), cat(p))
			if len(p) > 0 {
				w("I %d %d %s %s %s 0", n, m, hex.EncodeToString(r), hex.EncodeToString(lh[:]), cat(flip(p, len(p)-1)))
				w("I %d %d %s %s %s 0", n, m, hex.EncodeToString(r), hex.EncodeToString(lh[:]), cat(p[:len(p)-1]))
				w("I %d %d %s %s %s 0", n, (m+1)%n, hex.EncodeToString(r), hex.EncodeToString(lh[:]), cat(p))
			}
			w("I %d %d %s %s %s 0", n, m, hex.EncodeToString(r), hex.EncodeToString(lh[:]), cat(append(append([]tlog.Hash(nil), p...), tlog.Hash(r))))
		}
		for m := 1; m <= n; m++ {
			if n > 20 && m%5 != 0 && m != n-1 && m != 1 {
				continue
			}
			p, err := tlog.ProveTree(int64(n), int64(m), store)
			if err != nil {
				panic(err)
			}
			rm := roots[m]
			w("C %d %d %s %s %s 1", m, n, hex.EncodeToString(rm), hex.EncodeToString(r), cat(p))
			if len(p) > 0 {
				w("C %d %d %s %s %s 0", m, n, hex.EncodeToString(rm), hex.EncodeToString(r), cat(flip(p, 0)))
				w("C %d %d %s %s %s 0", m, n, hex.EncodeToString(rm), hex.EncodeToString(r), cat(p[1:]))
			}
			if m < n {
				w("C %d %d %s %s %s 0", m, n, hex.EncodeToString(r), hex.EncodeToString(rm), cat(p))
				w("C %d %d %s %s %s 0", m+1, n, hex.EncodeToString(rm), hex.EncodeToString(r), cat(p))
			}
		}
	}
	w("C 0 5 %s %s - 0", hex.EncodeToString(roots[5][:]), hex.EncodeToString(roots[5][:]))
	w("C 6 5 %s %s - 0", hex.EncodeToString(roots[5][:]), hex.EncodeToString(roots[5][:]))

	// Signed checkpoints: deterministic keys from fixed seeds.
	logSeed := sha256.Sum256([]byte("resid merkle log key"))
	logPriv := ed25519.NewKeyFromSeed(logSeed[:])
	logPub := logPriv.Public().(ed25519.PublicKey)
	logName := "example.com/log"
	skey := "PRIVATE+KEY+" + logName + "+" + fmt.Sprintf("%08x", keyID(logName, 1, logPub)) + "+" + base64.StdEncoding.EncodeToString(append([]byte{1}, logSeed[:]...))
	signer, err := note.NewSigner(skey)
	if err != nil {
		panic(err)
	}
	witSeed := sha256.Sum256([]byte("resid merkle witness key"))
	witPriv := ed25519.NewKeyFromSeed(witSeed[:])
	witPub := witPriv.Public().(ed25519.PublicKey)
	witName := "witness.example/w1"
	body := func(origin string, n int, ext string) string {
		r := roots[n]
		return origin + "\n" + fmt.Sprint(n) + "\n" + base64.StdEncoding.EncodeToString(r) + "\n" + ext
	}
	sign := func(text string) string {
		msg, err := note.Sign(&note.Note{Text: text}, signer)
		if err != nil {
			panic(err)
		}
		return string(msg)
	}
	nl := func(s, origin string) {
		w("N %s %s %s %s", hex.EncodeToString([]byte(s)), logName, hex.EncodeToString(logPub), origin)
	}
	good := sign(body(logName, 17, ""))
	nl(good, logName)
	nl(sign(body(logName, 17, "extension one\n")), logName)
	nl(sign(body("other.example/log", 17, "")), "-")
	nl(strings.Replace(good, "\n17\n", "\n18\n", 1), "-")
	nl(sign(logName+"\n017\n"+base64.StdEncoding.EncodeToString(roots[17][:])+"\n"), "-")
	nl(sign(logName+"\n17\n"+base64.StdEncoding.EncodeToString(roots[17][:16])+"\n"), "-")
	nl(sign(logName+"\n17\n"), "-")
	nl(good[:len(good)-1], "-")
	nl(strings.Replace(good, "— ", "- ", 1), "-")
	// A signature line from an unknown key is ignored.
	otherSeed := sha256.Sum256([]byte("someone else"))
	otherPriv := ed25519.NewKeyFromSeed(otherSeed[:])
	otherPub := otherPriv.Public().(ed25519.PublicKey)
	osk := "PRIVATE+KEY+other.example+" + fmt.Sprintf("%08x", keyID("other.example", 1, otherPub)) + "+" + base64.StdEncoding.EncodeToString(append([]byte{1}, otherSeed[:]...))
	os2, _ := note.NewSigner(osk)
	both, _ := note.Sign(&note.Note{Text: body(logName, 17, "")}, signer, os2)
	nl(string(both), logName)
	// The same key twice.
	nl(good+good[strings.LastIndex(good, "\n— "):][1:], "-")

	// Cosignatures (cosignature/v1, type 0x04).
	cos := func(text string, t uint64, priv ed25519.PrivateKey, pub ed25519.PublicKey, name string) string {
		lines := strings.SplitN(text, "\n", 4)
		msg := "cosignature/v1\ntime " + fmt.Sprint(t) + "\n" + lines[0] + "\n" + lines[1] + "\n" + lines[2] + "\n"
		sig := ed25519.Sign(priv, []byte(msg))
		var tb [8]byte
		binary.BigEndian.PutUint64(tb[:], t)
		var id [4]byte
		binary.BigEndian.PutUint32(id[:], keyID(name, 4, pub))
		blob := append(append(id[:], tb[:]...), sig...)
		return "— " + name + " " + base64.StdEncoding.EncodeToString(blob) + "\n"
	}
	wl := func(s string, thr int, now uint64, want int) {
		w("W %s %s %s %s %s %d %d %d", hex.EncodeToString([]byte(s)), logName, hex.EncodeToString(logPub), witName, hex.EncodeToString(witPub), thr, now, want)
	}
	text := body(logName, 17, "")
	cs := cos(text, 1700000000, witPriv, witPub, witName)
	wl(good+cs, 1, 1800000000, 1)
	wl(good+cs, 2, 1800000000, 0)
	wl(good, 1, 1800000000, 0)
	wl(good+cs, 0, 1800000000, 1)
	wl(good+cs, 1, 1600000000, 0)
	wl(good+cs+cs, 1, 1800000000, 0)
	bad := cos(body(logName, 16, ""), 1700000000, witPriv, witPub, witName)
	wl(good+bad, 1, 1800000000, 0)
	wrongKey := cos(text, 1700000000, otherPriv, witPub, witName)
	wl(good+wrongKey, 1, 1800000000, 0)
	// What the library makes: a signed checkpoint, and a cosignature line,
	// byte for byte (Ed25519 is deterministic).
	w("S %s %s %s %s", hex.EncodeToString(logSeed[:]), logName, hex.EncodeToString([]byte(text)), hex.EncodeToString([]byte(good)))
	w("K %s %s %s %d %s", hex.EncodeToString(witSeed[:]), witName, hex.EncodeToString([]byte(text)), 1700000000, hex.EncodeToString([]byte(cs)))
}

func keyID(name string, kind byte, pub []byte) uint32 {
	h := sha256.New()
	h.Write([]byte(name))
	h.Write([]byte{'\n', kind})
	h.Write(pub)
	return binary.BigEndian.Uint32(h.Sum(nil))
}
