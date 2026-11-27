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
