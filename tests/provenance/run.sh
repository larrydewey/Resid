#!/usr/bin/env bash
# Signed provenance (spec §33.1): trailer signing, verification, tamper
# detection, key requirements, concealment and reproducibility.
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
RT="$ROOT/runtime/resid_rt.c"

T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT
cd "$T"
unset RESID_SIGNING_KEY RESID_VERIFY_PUB RESID_PROV_ENCRYPT RESID_PROV_KEY
printf 'Int main() {\n    println("hi");\n    return 0;\n}\n' > p.resid

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

check "release without key" 1 "release builds require a signing key" "$COMPILER" p.resid -o nokey -rt "$RT"
check "debug without key" 0 "unsigned debug build" "$COMPILER" p.resid -o dbg --profile debug -rt "$RT"
check "unsigned has no trailer" 1 "no provenance trailer" "$COMPILER" verify dbg

check "keygen" 0 "wrote k/resid-ed25519.key" "$COMPILER" keygen k
check "keygen refuses overwrite" 1 "already exists" "$COMPILER" keygen k
export RESID_SIGNING_KEY="$T/k/resid-ed25519.key"
PUB="$(cat k/resid-ed25519.pub)"

check "signed build" 0 "provenance: signed" "$COMPILER" p.resid -o s -rt "$RT"
check "signed binary runs" 0 "hi" ./s
check "untrusted key" 1 "no trusted key" "$COMPILER" verify s
check "verify --pub" 0 "verify: ok" "$COMPILER" verify s --pub "$PUB"
export RESID_VERIFY_PUB="$PUB"
check "verify keyring env" 0 "verify: ok" "$COMPILER" verify s

cp s s_code; flip s_code 100
check "tampered code" 1 "code hash mismatch" "$COMPILER" verify s_code
cp s s_sig; flip s_sig -20
check "tampered signature" 1 "bad signature" "$COMPILER" verify s_sig
cp s s_notes; cp s.resid-notes.cbor s_notes.resid-notes.cbor; flip s_notes.resid-notes.cbor -1
check "tampered notes" 1 "does not match its signed hash" "$COMPILER" verify s_notes
cp s s_ok; cp s.resid-notes.cbor s_ok.resid-notes.cbor
check "matching notes" 0 "verify: ok" "$COMPILER" verify s_ok

K=000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f
check "concealed needs key" 1 "needs RESID_PROV_KEY" env RESID_PROV_ENCRYPT=1 "$COMPILER" p.resid -o c -rt "$RT"
check "concealed build" 0 "provenance: signed" env RESID_PROV_ENCRYPT=1 RESID_PROV_KEY=$K "$COMPILER" p.resid -o c -rt "$RT"
check "concealed verify without key" 1 "payload is concealed" "$COMPILER" verify c
check "concealed verify with key" 0 "verify: ok" env RESID_PROV_KEY=$K "$COMPILER" verify c
check "concealed wrong key" 1 "authentication failed" env RESID_PROV_KEY=${K%??}00 "$COMPILER" verify c

cp s s.first
"$COMPILER" p.resid -o s -rt "$RT" >/dev/null 2>&1
if cmp -s s s.first; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL reproducible: rebuild differs"; fi

echo "provenance: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
