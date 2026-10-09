#!/usr/bin/env bash
# Constant-time checks (ctgrind): every operation that handles a secret,
# run on the optimized binary under valgrind memcheck with the secret
# marked undefined (ct_secret). memcheck then reports any branch, select
# or memory address that depends on it -- including ones the compiler or
# LLVM introduced, which is the point of checking the binary rather than
# the source. Results are declassified with ct_public before printing.
#
# A case passes when memcheck reports nothing and its output matches the
# same binary run natively. Skipped (not failed) when valgrind is not
# installed.
#
# Usage: tests/ct/run.sh [-c COMPILER]
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
COMPILER="$ROOT/build/boot/stage2.bin"
while getopts "c:" opt; do
    case "$opt" in
        c) COMPILER="$(realpath "$OPTARG")" ;;
        *) exit 2 ;;
    esac
done
if ! command -v valgrind > /dev/null; then
    echo "ct: skipped (valgrind not installed)"
    exit 0
fi
W="$(mktemp -d)"
trap 'rm -rf "$W"' EXIT
export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"

(cd "$ROOT" && "$COMPILER" tests/ct/ctprobe.resid -o "$W/ctprobe") > "$W/build.log" 2>&1 || {
    echo "FAIL build ctprobe"; grep -i -A3 error "$W/build.log" | head -8; exit 1; }

CASES="ct-equal sha256-sw sha512 hmac hkdf ghash ghash-sw aes-sw aes-dec aes-gcm aes-kw chacha x25519 ed25519-sign
       p256-sign p384-sign p256-ecdh p384-ecdh p384-public hpke-open"
pass=0; fail=0
for c in $CASES; do
    want="$("$W/ctprobe" "$c" 2>&1)"
    got="$(valgrind -q --error-limit=no --expensive-definedness-checks=yes --log-file="$W/vg.$c" "$W/ctprobe" "$c" 2>&1)"
    n="$(grep -c -E 'depends on uninitialised|Use of uninitialised' "$W/vg.$c")"
    if [ "$n" = 0 ] && [ "$got" = "$want" ] && [ "${want#"$c "}" != "$want" ]; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
        echo "FAIL $c: $n secret-dependent branch(es) or address(es)"
        grep -A3 -E 'depends on uninitialised|Use of uninitialised' "$W/vg.$c" | head -8
        [ "$got" = "$want" ] || echo "  output differs under valgrind: $got"
    fi
done
# Secret(T) operations (spec §48), from their own probe.
(cd "$ROOT" && "$COMPILER" tests/ct/secretprobe.resid -o "$W/secretprobe") > "$W/build2.log" 2>&1 || {
    echo "FAIL build secretprobe"; grep -i -A3 error "$W/build2.log" | head -8; exit 1; }
for c in ct-select ct-eq sha256-secret hmac-secret sha512-secret hmac512-secret; do
    want="$("$W/secretprobe" "$c" 2>&1)"
    got="$(valgrind -q --error-limit=no --expensive-definedness-checks=yes --log-file="$W/vg.s.$c" "$W/secretprobe" "$c" 2>&1)"
    n="$(grep -c -E 'depends on uninitialised|Use of uninitialised' "$W/vg.s.$c")"
    if [ "$n" = 0 ] && [ "$got" = "$want" ] && [ "${want#"$c "}" != "$want" ]; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
        echo "FAIL $c: $n secret-dependent branch(es) or address(es)"
        grep -A3 -E 'depends on uninitialised|Use of uninitialised' "$W/vg.s.$c" | head -8
        [ "$got" = "$want" ] || echo "  output differs under valgrind: $got"
    fi
done
# The control must be caught, or the checks above prove nothing.
valgrind -q --error-limit=no --expensive-definedness-checks=yes --log-file="$W/vg.control" "$W/ctprobe" control > /dev/null 2>&1
if [ "$(grep -c -E 'depends on uninitialised|Use of uninitialised' "$W/vg.control")" -gt 0 ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL control: a secret-indexed load went unreported"
fi
echo "ct: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
