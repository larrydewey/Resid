#!/usr/bin/env bash
# Cryptography conformance: every primitive in lib/ against Wycheproof
# (C2SP/wycheproof, converted by gen_vectors.py) and RFC 6979 signatures
# made by pyca/cryptography (gen_rfc6979.py). The vectors are committed,
# so this needs neither the network nor python.
#
# Each vectors/*.txt runs through probe.resid, which prints a FAIL line per
# disagreement and a SUMMARY line; a test whose expected result is
# "acceptable" passes either way, as Wycheproof intends.
#
# Usage: tests/crypto/run.sh [-c COMPILER]
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
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

(cd "$ROOT" && "$COMPILER" tests/crypto/probe.resid -o "$W/probe") > "$W/build.log" 2>&1 || {
    echo "FAIL build probe"; grep -i -A3 error "$W/build.log" | head -8; exit 1; }

pass=0; fail=0; files=0
for f in "$ROOT"/tests/crypto/vectors/*.txt; do
    name="$(basename "$f" .txt)"
    out="$("$W/probe" "$f" 2>&1)"
    rc=$?
    summary="$(printf '%s\n' "$out" | sed -n 's/^SUMMARY //p')"
    p="$(printf '%s' "$summary" | sed -n 's/.*pass=\([0-9]*\).*/\1/p')"
    x="$(printf '%s' "$summary" | sed -n 's/.*fail=\([0-9]*\).*/\1/p')"
    s="$(printf '%s' "$summary" | sed -n 's/.*skip=\([0-9]*\).*/\1/p')"
    files=$((files + 1))
    if [ -z "$summary" ] || [ "$rc" -gt 1 ]; then
        echo "FAIL $name: probe exited $rc"; printf '%s\n' "$out" | tail -3
        fail=$((fail + 1)); continue
    fi
    pass=$((pass + p)); fail=$((fail + x))
    [ "$x" = 0 ] || printf '%s\n' "$out" | grep '^FAIL' | head -5
    [ "${s:-0}" = 0 ] || echo "note: $name skipped $s"
done
# ── certificates ────────────────────────────────────────────────────
# One issuer link per case: the strict parse, the algorithm it names, and
# chain_verify (signature, names, CA bits, validity at 2030-01-01). The
# AMD and AWS certificates are the vendors' own; make.sh builds the rest.
(cd "$ROOT" && "$COMPILER" tests/crypto/x509probe.resid -o "$W/x509probe") > "$W/build.log" 2>&1 || {
    echo "FAIL build x509probe"; grep -i -A3 error "$W/build.log" | head -8; exit 1; }
X="$ROOT/tests/crypto/x509"
# link <child> <issuer> <want alg> <want chain> [flip]
link() {
    local out alg chain
    out="$("$W/x509probe" "$X/$1.der" "$X/$2.der" ${5:-} 2>&1)"
    alg="$(printf '%s\n' "$out" | sed -n 's/^alg=\([^ ]*\).*/\1/p')"
    chain="$(printf '%s\n' "$out" | sed -n 's/^chain=//p')"
    if [ "$alg" = "$3" ] && [ "$chain" = "$4" ]; then pass=$((pass + 1));
    else fail=$((fail + 1)); echo "FAIL x509 $1 <- $2 ${5:-}: alg=$alg chain=$chain want $3 $4"; fi
}
link amd-ark-milan amd-ark-milan pss/SHA-384 true
link amd-ask-milan amd-ark-milan pss/SHA-384 true
link amd-ark-genoa amd-ark-genoa pss/SHA-384 true
link amd-ask-genoa amd-ark-genoa pss/SHA-384 true
link amd-ask-genoa amd-ark-milan pss/SHA-384 false
link amd-ask-milan amd-ark-milan pss/SHA-384 false 1
link aws-nitro-root aws-nitro-root ecdsa/SHA-384 true
link aws-nitro-root aws-nitro-root ecdsa/SHA-384 false 3
link p384-ca p384-ca ecdsa/SHA-384 true
link p384-leaf p384-ca ecdsa/SHA-384 true
link p384-leaf-sha512 p384-ca ecdsa/SHA-512 true
link p256-under-p384 p384-ca ecdsa/SHA-384 true
link p256-ca p256-ca ecdsa/SHA-512 true
link p384-under-p256 p256-ca ecdsa/SHA-512 true
link p384-leaf p256-ca ecdsa/SHA-384 false
# A leaf is not an issuer, whatever its key verifies.
link p384-leaf p384-leaf ecdsa/SHA-384 false
link pss-ca pss-ca pss/SHA-384 true
link vcek-like pss-ca pss/SHA-384 true
link pss-sha512 pss-ca pss/SHA-512 true
link pss-salt20 pss-ca pss/SHA-384 true
link pss-mgf-mismatch pss-ca none false
link rsa4096-ca rsa4096-ca pkcs1/SHA-512 true
link rsa3072-leaf rsa4096-ca pkcs1/SHA-384 true
link rsa3072-leaf rsa4096-ca pkcs1/SHA-384 false 2
link rsa2048-pss-leaf rsa4096-ca pss/SHA-256 true
link rsa1024-ca rsa1024-ca pkcs1/SHA-256 false
link under-rsa1024 rsa1024-ca pkcs1/SHA-256 false
link ed-ca ed-ca ed25519/SHA-512 true
link ed-leaf ed-ca ed25519/SHA-512 true
link ed-leaf ed-ca ed25519/SHA-512 false 1
link sha1-leaf p384-ca none false

# ── round trips ──────────────────────────────────────────────────────
(cd "$ROOT" && "$COMPILER" tests/crypto/roundtrip.resid -o "$W/roundtrip") > "$W/build.log" 2>&1 || {
    echo "FAIL build roundtrip"; grep -i -A3 error "$W/build.log" | head -8; exit 1; }
rt="$("$W/roundtrip" 2>&1)"
pass=$((pass + $(printf '%s\n' "$rt" | grep -c '^ok ')))
nf=$(printf '%s\n' "$rt" | grep -c '^FAIL')
fail=$((fail + nf))
[ "$nf" = 0 ] || printf '%s\n' "$rt" | grep '^FAIL'
printf '%s\n' "$rt" | grep -q '^roundtrip: 0 failed' || { [ "$nf" != 0 ] || { echo "FAIL roundtrip did not finish"; fail=$((fail + 1)); }; }

# ── parsers under mutation ───────────────────────────────────────────
# Every parser that reads untrusted bytes, on mutated certificates, CRLs,
# OCSP responses, keys, signatures, COSE, TLS messages and PEM: an abort
# (caught per input by fuzz.resid) or a hang (the timeout) is a failure.
# The rng seeds are fixed, so a failure reproduces.
(cd "$ROOT" && "$COMPILER" tests/crypto/fuzz.resid -o "$W/fuzz") > "$W/build.log" 2>&1 || {
    echo "FAIL build fuzz"; grep -i -A3 error "$W/build.log" | head -8; exit 1; }
F="$ROOT/tests/tls/fixtures"
SD="$ROOT/tests/crypto/seeds"
N="${CRYPTO_FUZZ_N:-250}"
fz() {
    local out
    out="$(timeout 600 "$W/fuzz" "$@" 2>&1)"
    if printf '%s\n' "$out" | grep -q "^FUZZ .* crashes=0$"; then pass=$((pass + 1));
    else fail=$((fail + 1)); echo "FAIL fuzz $1 $(basename "$2") seed $4"; printf '%s\n' "$out" | grep -E '^(CRASH|FUZZ)' | head -3 | cut -c1-300; fi
}
fz cert "$F/leaf.der" "$N" 11 "$F/inter.der"
fz cert "$F/rsa_pss.der" "$N" 12 "$F/rsa_pss.der"
fz cert "$X/amd-ask-milan.der" "$N" 13 "$X/amd-ark-milan.der"
fz cert "$X/vcek-like.der" "$N" 14 "$X/pss-ca.der"
fz cert "$X/ed-leaf.der" "$N" 15 "$X/ed-ca.der"
fz cert "$X/p384-leaf.der" "$N" 16 "$X/p384-ca.der"
fz crl "$F/crl.der" "$N" 21 "$F/ca.der" "$F/bad.der"
fz ocsp "$F/ocsp-good.der" "$N" 22 "$F/root.der" "$F/leaf.der"
fz ocsp "$F/ocsp-delegated.der" "$N" 23 "$F/dca.der" "$F/dgood.der"
fz key "$F/srv.key.der" "$N" 24
fz key "$F/srved.key.der" "$N" 25
fz key "$SD/spki384.der" "$N" 26
fz key "$SD/rsapub.der" "$N" 27
fz key "$SD/ckey.bin" "$N" 28
fz sig "$SD/sig384.bin" $((N / 2)) 41
fz sig "$SD/pub384.bin" $((N / 2)) 42
fz cose "$SD/cose1.bin" "$N" 43
fz cose "$SD/cose2.bin" "$N" 44
fz tls "$F/certmsg.bin" "$N" 45 "$F/leaf.der"
fz tls "$F/ch-ossl.bin" "$N" 46 "$F/leaf.der"
fz pem "$F/root.pem" "$N" 47
fz pem "$F/srv.key" "$N" 48

echo "crypto: $pass passed, $fail failed ($files vector files)"
[ "$fail" -eq 0 ]
