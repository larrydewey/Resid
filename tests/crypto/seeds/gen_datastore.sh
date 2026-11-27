#!/usr/bin/env bash
# The fuzz seeds of the datastore primitives (note, ristretto255, ML-DSA):
# made by fuzz.resid itself from its fixed keys (fuzz --mkseed <name>), so
# they stay in step with what its modes expect. Needs python3 (to turn
# the hex into bytes).
#
# Usage: tests/crypto/seeds/gen_datastore.sh [-c COMPILER]
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
COMPILER="$ROOT/build/boot/stage2.bin"
while getopts "c:" opt; do
    case "$opt" in
        c) COMPILER="$(realpath "$OPTARG")" ;;
        *) exit 2 ;;
    esac
done
W="$(mktemp -d)"
trap 'rm -rf "$W"' EXIT
export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"
(cd "$ROOT" && "$COMPILER" tests/crypto/fuzz.resid -o "$W/fuzz") > "$W/build.log" 2>&1 || {
    echo "FAIL build fuzz"; grep -i -A3 error "$W/build.log" | head -8; exit 1; }
for n in note r255-point r255-scalar r255-uniform \
         mldsa44-pk mldsa44-sig mldsa44-hint mldsa65-pk mldsa65-sig mldsa65-hint \
         mldsa87-pk mldsa87-sig mldsa87-hint; do
    "$W/fuzz" --mkseed "$n" | python3 -c 'import sys, binascii; sys.stdout.buffer.write(binascii.unhexlify(sys.stdin.read().strip()))' > "$ROOT/tests/crypto/seeds/$n.bin"
    echo "$n $(wc -c < "$ROOT/tests/crypto/seeds/$n.bin")"
done

# dc-merkle-1: the seed note, still under its signatures, with one
# character stored as an overlong UTF-8 form: the newline between the two
# extension lines (C0 8A), and the '2' of the size (C0 B2). Both must be
# refused (tests/crypto/merkle_strprobe.resid).
python3 - "$ROOT/tests/crypto/seeds" <<'PY'
import sys
d = sys.argv[1]
note = open(d + "/note.bin", "rb").read()
a = note.replace(b"extension one\nx=2", b"extension one\xc0\x8ax=2")
b = note.replace(b"\n1234567\n", b"\n1\xc0\xb234567\n")
assert a != note and b != note
open(d + "/note-overlong-newline.bin", "wb").write(a)
open(d + "/note-overlong-digit.bin", "wb").write(b)
PY
echo "note-overlong-newline note-overlong-digit"
