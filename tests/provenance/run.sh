#!/usr/bin/env bash
# Signed provenance (spec §33.1): trailer signing, verification, tamper
# detection, key requirements, trust modes, evidence against attestation,
# concealment, reproducibility, and an independent reader of the record.
#
# Usage: tests/provenance/run.sh [-c compiler]
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
COMPILER="$ROOT/build/boot/stage2.bin"
while getopts "c:" opt; do
    case "$opt" in
        c) COMPILER="$(realpath "$OPTARG")" ;;
        *) exit 2 ;;
    esac
done
[ -x "$COMPILER" ] || { echo "compiler not found: $COMPILER (run ./boot.sh)"; exit 2; }
export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"

T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT
cd "$T"
unset RESID_SIGNING_KEY RESID_VERIFY_PUB RESID_PROV_ENCRYPT RESID_PROV_KEY
printf 'Int main() {\n    println("hi");\n    return 0;\n}\n' > p.resid
# A program with authority: its grant is main's @requires, and its graph
# (debug builds) records the capability the provider call uses.
printf '@requires(filesystem(readonly))\nInt main() {\n    Bool b = filesystem.exists("/etc/hosts");\n    println(if (b) { "y" } else { "n" });\n    return 0;\n}\n' > q.resid
# Two sources: the record then needs the two-byte CBOR length form.
printf 'pub Int helper(Int a) { return a + 1; }\n' > h.resid
printf 'import "./h.resid";\nInt main() {\n    println(f"{helper(1)}");\n    return 0;\n}\n' > m.resid

pass=0
fail=0
check() { # check <name> <expected-rc> <grep-pattern> <cmd...>
    local name="$1" want="$2" pat="$3"
    shift 3
    out="$("$@" 2>&1)"
    rc=$?
    if [ "$rc" -eq "$want" ] && echo "$out" | grep -q -- "$pat"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
        echo "FAIL $name (rc $rc, want $want): $(echo "$out" | tail -1)"
    fi
}
flip() { # flip <file> <offset from start, or negative from end>
    python3 -c "import sys; p=sys.argv[1]; o=int(sys.argv[2]); b=bytearray(open(p,'rb').read()); b[o]^=1; open(p,'wb').write(b)" "$1" "$2"
}

# An independent reader and signer of the trailer (cbor2 + cryptography):
# `check` verifies the genuine signature, the other modes re-sign a record
# that lies, so verify's cross-checks are tested against a valid signature.
cat > forge.py <<'PYEOF'
import sys, cbor2
from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey
bin_path, key_path, what = sys.argv[1:4]
b = open(bin_path, 'rb').read()
MAGIC = b"RESIDPROV2"
assert b[-10:] == MAGIC, "no trailer"
clen = int.from_bytes(b[-14:-10], 'big')
cose = b[-14 - clen:-14]
code = b[:-14 - clen]
tag = cbor2.loads(cose)
assert tag.tag == 18
prot, unprot, payload, sig = tag.value
rec = cbor2.loads(payload)
sk = Ed25519PrivateKey.from_private_bytes(bytes.fromhex(open(key_path).read().strip()))
sk.public_key().verify(sig, cbor2.dumps(["Signature1", prot, b"", payload]))
import hashlib
assert rec['code'] == hashlib.sha256(code).digest(), "code hash"
if what == 'check':
    print("genuine: signature verifies, code hash matches, payload head 0x%02x, grant %r" % (cose[cose.index(payload) - (3 if len(payload) > 255 else 2)], rec['grant']))
    sys.exit(0)
if what == 'grant':
    rec['grant'] = []
elif what == 'source':
    rec['sources'][0]['hash'] = bytes(32)
payload2 = cbor2.dumps(rec)
sig2 = sk.sign(cbor2.dumps(["Signature1", prot, b"", payload2]))
cose2 = cbor2.dumps(cbor2.CBORTag(18, [prot, unprot, payload2, sig2]))
open(bin_path, 'wb').write(code + cose2 + len(cose2).to_bytes(4, 'big') + MAGIC)
print("forged", what)
PYEOF
HAVE_PY=1
python3 -c "import cbor2, cryptography" 2>/dev/null || HAVE_PY=0

check "release without key" 1 "release builds require a signing key" "$COMPILER" p.resid -o nokey
check "debug without key" 0 "unsigned debug build" "$COMPILER" p.resid -o dbg --profile debug
check "unsigned has no trailer" 1 "no provenance trailer" "$COMPILER" verify dbg

check "keygen" 0 "wrote k/resid-ed25519.key" "$COMPILER" keygen k
check "keygen refuses overwrite" 1 "already exists" "$COMPILER" keygen k
export RESID_SIGNING_KEY="$T/k/resid-ed25519.key"
PUB="$(cat k/resid-ed25519.pub)"

check "signed build" 0 "provenance: signed" "$COMPILER" p.resid -o s
check "signed binary runs" 0 "hi" ./s
check "untrusted key" 1 "no trusted key" "$COMPILER" verify s
check "verify --pub" 0 "verify: ok" "$COMPILER" verify s --pub "$PUB"
export RESID_VERIFY_PUB="$PUB"
check "verify keyring env" 0 "verify: ok" "$COMPILER" verify s

# ── Trust modes: the verdict names where the key came from ──────────────
check "supplied key is reported" 0 "trust: supplied" "$COMPILER" verify s
check "--anchored refuses a supplied key" 1 "is a supplied key" "$COMPILER" verify s --anchored
unset RESID_VERIFY_PUB
mkdir -p keys && cp k/resid-ed25519.pub keys/
check "cwd keys/ is local, not an anchor" 0 "trust: local" "$COMPILER" verify s
check "--anchored refuses a local key" 1 "is a local key" "$COMPILER" verify s --anchored
rm -rf keys
mkdir -p home/keys && cp k/resid-ed25519.pub home/keys/
check "RESID_HOME/keys is anchored" 0 "trust: anchored" env RESID_HOME="$T/home" "$COMPILER" verify s
check "--anchored accepts the install keyring" 0 "verify: ok.*trust anchored" env RESID_HOME="$T/home" "$COMPILER" verify s --anchored
mkdir -p keys && cp k/resid-ed25519.pub keys/
check "anchored wins over local for the same kid" 0 "trust: anchored" env RESID_HOME="$T/home" "$COMPILER" verify s
rm -rf keys
export RESID_VERIFY_PUB="$PUB"

# ── Evidence and attestation are reported apart ─────────────────────────
check "code hash is evidence" 0 "evidence: code hash matches" "$COMPILER" verify s
check "notes sidecar is evidence" 0 "evidence: s.resid-notes.cbor matches" "$COMPILER" verify s
check "detached copy is evidence" 0 "evidence: s.resid-prov.cbor equals the trailer" "$COMPILER" verify s
check "builder compiler is evidence" 0 "evidence: built by this residc" "$COMPILER" verify s
check "sources are attested without a tree" 0 "attestation: 1 source file(s), hashes signed but not re-derived" "$COMPILER" verify s
check "toolchain and profile are attested" 0 "attestation: toolchain resid-stage2 3.5, profile release, output s" "$COMPILER" verify s
check "empty grant for a main without @requires" 0 "attestation: grant \[\]" "$COMPILER" verify s
check "--sources re-derives the source hashes" 0 "evidence: 1 source file(s) under . match" "$COMPILER" verify s --sources .
mkdir -p other && cp p.resid other/ && printf '// changed\n' >> other/p.resid
check "--sources catches a changed source" 1 "does not match its signed hash" "$COMPILER" verify s --sources other
check "--sources catches a missing source" 1 "is missing under" "$COMPILER" verify s --sources home
cp "$COMPILER" notme.bin && printf 'x' >> notme.bin && chmod +x notme.bin
check "another compiler: builder is attested, not evidenced" 0 "attestation: compiler .* (not this residc)" ./notme.bin verify s

check "signed build with authority" 0 "provenance: signed" "$COMPILER" q.resid -o q
check "grant is main's @requires" 0 "attestation: grant \[filesystem(readonly)\]" "$COMPILER" verify q
check "signed debug build carries the graph" 0 "provenance: signed" "$COMPILER" q.resid -o qd --profile debug
check "graph sidecar is evidence" 0 "evidence: qd.resid-graph.cbor matches" "$COMPILER" verify qd
check "graph sources and capabilities are evidence" 0 "evidence: the graph's sources are the record's, and its capabilities are within the grant" "$COMPILER" verify qd

# ── Native modules (spec §47) ───────────────────────────────────────────
# The record names each linked artifact by its SHA-256 (attestation), and
# the graph records a native call as an effect of its family.
printf '@link("tiny") Int tiny_add(Int a, Int b) {}\n@requires(native_tiny)\nInt main() {\n    println(f"{tiny_add(rt 1, 2)}");\n    return 0;\n}\n' > n.resid
NAT="tiny=$ROOT/tests/conformance/native/tiny.ll"
NHASH="$(sha256sum "$ROOT/tests/conformance/native/tiny.ll" | cut -d' ' -f1)"
check "native build" 0 "provenance: signed" "$COMPILER" n.resid -o n -native "$NAT"
check "native artifact in the record" 0 "attestation: native module tiny from an artifact with SHA-256 $NHASH" "$COMPILER" verify n
check "native grant" 0 "attestation: grant \[native_tiny\]" "$COMPILER" verify n
check "native debug build" 0 "provenance: signed" "$COMPILER" n.resid -o nd --profile debug -native "$NAT"
check "native capability within the grant" 0 "its capabilities are within the grant" "$COMPILER" verify nd
if grep -qa "native_tiny.tiny_add" nd.resid-graph.cbor; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL the graph records the native call as an effect"; fi

# ── Tampering ───────────────────────────────────────────────────────────
cp s s_code; flip s_code 100
check "tampered code" 1 "code hash mismatch" "$COMPILER" verify s_code
cp s s_sig; flip s_sig -20
check "tampered signature" 1 "bad signature" "$COMPILER" verify s_sig
cp s s_notes; cp s.resid-notes.cbor s_notes.resid-notes.cbor; flip s_notes.resid-notes.cbor -1
check "tampered notes" 1 "does not match its signed hash" "$COMPILER" verify s_notes
cp s s_ok; cp s.resid-notes.cbor s_ok.resid-notes.cbor
check "matching notes" 0 "verify: ok" "$COMPILER" verify s_ok
cp s s_gone   # the signed notes sidecar removed
check "missing signed sidecar" 1 "is missing (the signature covers it)" "$COMPILER" verify s_gone
cp s s_det; cp s.resid-notes.cbor s_det.resid-notes.cbor; cp s.resid-prov.cbor s_det.resid-prov.cbor; flip s_det.resid-prov.cbor -1
check "detached copy that differs from the trailer" 1 "s_det.resid-prov.cbor differs from the trailer" "$COMPILER" verify s_det
cp qd qd_graph; cp qd.resid-notes.cbor qd_graph.resid-notes.cbor; cp qd.resid-graph.cbor qd_graph.resid-graph.cbor; flip qd_graph.resid-graph.cbor -1
check "tampered graph" 1 "does not match its signed hash" "$COMPILER" verify qd_graph

# ── A record that lies, under a valid signature ─────────────────────────
if [ "$HAVE_PY" -eq 1 ]; then
    check "independent reader accepts the genuine trailer" 0 "genuine: signature verifies" python3 forge.py s "$RESID_SIGNING_KEY" check
    check "two sources use the two-byte length form" 0 "provenance: signed" "$COMPILER" m.resid -o m
    check "two-byte length form verifies" 0 "attestation: 2 source file(s)" "$COMPILER" verify m
    check "two-byte length form, independently" 0 "payload head 0x59" python3 forge.py m "$RESID_SIGNING_KEY" check
    cp qd lie_grant; cp qd.resid-notes.cbor lie_grant.resid-notes.cbor; cp qd.resid-graph.cbor lie_grant.resid-graph.cbor
    check "forge: empty grant" 0 "forged grant" python3 forge.py lie_grant "$RESID_SIGNING_KEY" grant
    check "graph capability outside the signed grant" 1 "uses capability \`filesystem\`, outside the recorded grant" "$COMPILER" verify lie_grant
    cp qd lie_src; cp qd.resid-notes.cbor lie_src.resid-notes.cbor; cp qd.resid-graph.cbor lie_src.resid-graph.cbor
    check "forge: wrong source hash" 0 "forged source" python3 forge.py lie_src "$RESID_SIGNING_KEY" source
    check "graph sources differ from the signed record" 1 "the graph's sources differ from the signed record's" "$COMPILER" verify lie_src
else
    echo "skip: python3 cbor2/cryptography not available (independent reader and forged records)"
fi

# ── CBOR length forms the record never reaches in a small build ─────────
cat > cb.resid <<EOF
import "$ROOT/lib/cose.resid";
Int main() {
    List(Int) body = bytes_of(str_repeat("a", 70000));
    List(Int) blob = cbe_bytes(body, []);
    CbeHead h = cbe_read_head(blob, 0);
    expect(h.major).toEqual(2);
    expect(h.val).toEqual(70000);
    expect(h.pos).toEqual(5);
    CbeStr s = cbe_read_str(blob, 0, 2);
    expect(s.ok).toEqual(true);
    expect(s.bytes.len()).toEqual(70000);
    expect(s.pos).toEqual(blob.len());
    List(Int) mid = cbe_text(str_repeat("b", 300), []);
    CbeHead h2 = cbe_read_head(mid, 0);
    expect(h2.val).toEqual(300);
    expect(h2.pos).toEqual(3);
    List(Int) one = cbe_text(str_repeat("c", 200), []);
    expect(cbe_read_head(one, 0).pos).toEqual(2);
    CbeStr bad = cbe_read_str(cbe_head(2, 500, []), 0, 2);
    expect(bad.ok).toEqual(false);
    println("cbor lengths ok");
    return 0;
}
EOF
check "cbor length forms compile" 0 "wrote cb" "$COMPILER" cb.resid -o cb --profile debug
check "cbor one-, two- and four-byte lengths read back" 0 "cbor lengths ok" ./cb

# ── Concealment ─────────────────────────────────────────────────────────
K=000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f
check "concealed needs key" 1 "needs RESID_PROV_KEY" env RESID_PROV_ENCRYPT=1 "$COMPILER" p.resid -o c
check "concealed build" 0 "provenance: signed" env RESID_PROV_ENCRYPT=1 RESID_PROV_KEY=$K "$COMPILER" p.resid -o c
check "concealed verify without key" 1 "payload is concealed" "$COMPILER" verify c
check "concealed verify with key" 0 "verify: ok" env RESID_PROV_KEY=$K "$COMPILER" verify c
check "concealed wrong key" 1 "authentication failed" env RESID_PROV_KEY=${K%??}00 "$COMPILER" verify c

cp s s.first
"$COMPILER" p.resid -o s >/dev/null 2>&1
if cmp -s s s.first; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL reproducible: rebuild differs"; fi

echo "provenance: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
