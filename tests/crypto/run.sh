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
# RESID_TARGET=aarch64 cross-compiles the probes (run through qemu-user).
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

(cd "$ROOT" && "$COMPILER" tests/crypto/probe.resid ${RESID_TARGET:+--target $RESID_TARGET} -o "$W/probe") > "$W/build.log" 2>&1 || {
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
(cd "$ROOT" && "$COMPILER" tests/crypto/x509probe.resid ${RESID_TARGET:+--target $RESID_TARGET} -o "$W/x509probe") > "$W/build.log" 2>&1 || {
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
(cd "$ROOT" && "$COMPILER" tests/crypto/roundtrip.resid ${RESID_TARGET:+--target $RESID_TARGET} -o "$W/roundtrip") > "$W/build.log" 2>&1 || {
    echo "FAIL build roundtrip"; grep -i -A3 error "$W/build.log" | head -8; exit 1; }
rt="$("$W/roundtrip" 2>&1)"
pass=$((pass + $(printf '%s\n' "$rt" | grep -c '^ok ')))
nf=$(printf '%s\n' "$rt" | grep -c '^FAIL')
fail=$((fail + nf))
[ "$nf" = 0 ] || printf '%s\n' "$rt" | grep '^FAIL'
printf '%s\n' "$rt" | grep -q '^roundtrip: 0 failed' || { [ "$nf" != 0 ] || { echo "FAIL roundtrip did not finish"; fail=$((fail + 1)); }; }

# ── parsers under mutation ───────────────────────────────────────────
# Every parser that reads untrusted bytes, on mutated certificates, CRLs,
# OCSP responses, keys, signatures, COSE, TLS messages, PEM, HTTP/2
# frames with HPACK blocks, SPDM messages, TPM responses, CoRIMs, signed
# notes, ristretto255 encodings and ML-DSA keys and signatures: an abort
# (caught per input by fuzz.resid) or a hang (the timeout) is a failure.
# The rng seeds are fixed, so a failure reproduces.
(cd "$ROOT" && "$COMPILER" tests/crypto/fuzz.resid ${RESID_TARGET:+--target $RESID_TARGET} -o "$W/fuzz") > "$W/build.log" 2>&1 || {
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
fz hpack "$SD/hpack-huff.bin" "$N" 61
fz hpack "$SD/hpack-raw.bin" "$N" 62
fz spdm "$SD/spdm-meas.bin" "$N" 71
fz spdm "$SD/spdm-algs.bin" "$N" 72
fz spdm "$SD/spdm-kex.bin" "$N" 73
fz spdm "$SD/spdm-chal.bin" "$N" 74
fz tpm "$SD/tpm-create.bin" "$N" 75
fz tpm "$SD/tpm-public.bin" "$N" 76
fz corim "$SD/corim-payload.bin" "$N" 77
fz corim "$SD/corim-keys-payload.bin" "$N" 78
# Datastore primitives (seeds from seeds/gen_datastore.sh). These kinds
# also assert that what is accepted is canonical, and that only the signed
# original verifies; they are cheap, so the note and ristretto255 parsers
# get four times the iterations.
fz note "$SD/note.bin" $((N * 4)) 81
fz r255 "$SD/r255-point.bin" $((N * 4)) 82
fz r255 "$SD/r255-scalar.bin" $((N * 4)) 83
fz r255 "$SD/r255-uniform.bin" $((N * 4)) 84
seedn=85
for lv in 44 65 87; do
    fz mldsasig "$SD/mldsa$lv-sig.bin" "$N" "$seedn" "$SD/mldsa$lv-pk.bin" "$SD/mldsa$lv-sig.bin"
    fz mldsapk "$SD/mldsa$lv-pk.bin" "$N" $((seedn + 1)) "$SD/mldsa$lv-sig.bin" "$SD/mldsa$lv-pk.bin"
    fz mldsahint "$SD/mldsa$lv-hint.bin" $((N * 4)) $((seedn + 2)) "$SD/mldsa$lv-pk.bin" "$SD/mldsa$lv-sig.bin"
    seedn=$((seedn + 3))
done

# bcrypt_pbkdf and AES-CTR (lib/bcrypt_pbkdf.resid) against Python's bcrypt
# and cryptography, and a passphrase-protected ssh-keygen key
# (tools/gen_bcrypt_ref.py).
if (cd "$ROOT" && "$COMPILER" test tests/crypto/bcrypt_pbkdf_test.resid) > "$W/bcrypt.log" 2>&1 && grep -q "Failures: 0 " "$W/bcrypt.log"; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL bcrypt_pbkdf: $(grep -m3 -E 'error|expected|actual' "$W/bcrypt.log" | tr '\n' ' ')"
fi

# Red-team regressions for the datastore primitives (issue #9): one file
# a module, each test failing before its fix.
for t in r255_redteam; do
    [ -f "$ROOT/tests/crypto/${t}_test.resid" ] || continue
    if (cd "$ROOT" && "$COMPILER" test "tests/crypto/${t}_test.resid") > "$W/$t.log" 2>&1 && grep -q "Failures: 0 " "$W/$t.log"; then
        pass=$((pass + $(sed -n 's/.*Passed: \([0-9]*\).*/\1/p' "$W/$t.log" | tail -1)))
    else
        fail=$((fail + 1)); echo "FAIL $t: $(grep -m3 -E 'error|✗|expected|actual' "$W/$t.log" | tr '\n' ' ')"
    fi
done

# RSA signing on secret keys (lib/rsasign.resid) against cryptography,
# faulty CRT halves refused (tools/gen_rsasign_ref.py).
if (cd "$ROOT" && RESID_MEM_LIMIT=12000 "$COMPILER" test tests/crypto/rsasign_test.resid) > "$W/rsasign.log" 2>&1 && grep -q "Failures: 0 " "$W/rsasign.log"; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL rsasign: $(grep -m3 -E 'error|expected|actual' "$W/rsasign.log" | tr '\n' ' ')"
fi

# SHA-3 / SHAKE (lib/keccakg.resid) against hashlib, and ML-KEM-768
# (lib/mlkem.resid) against OpenSSL through cryptography (gen_sha3_mlkem.py).
# AES-GCM and ChaCha20-Poly1305 against cryptography and RFC 8439 appendix
# A at both types, both paths and the packed entry points
# (tools/gen_aead_ref.py), and against their v0.13.0 implementations on
# random inputs (aead_cmp_test.resid, tests/crypto/aead_ref/).
for t in sha3 mlkem aead aead_cmp; do
    if (cd "$ROOT" && "$COMPILER" test tests/crypto/${t}_test.resid) > "$W/$t.log" 2>&1 && grep -q "Failures: 0 " "$W/$t.log"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL $t: $(grep -m3 -E 'error|expected|actual' "$W/$t.log" | tr '\n' ' ')"
    fi
done

# CTAP2 and CBOR values (lib/ctap2.resid, lib/cborv.resid) against
# python-fido2 and an authenticator written from the specification
# (tools/gen_ctap2_ref.py).
if (cd "$ROOT" && "$COMPILER" test tests/crypto/ctap2_test.resid) > "$W/ctap2.log" 2>&1 && grep -q "Failures: 0 " "$W/ctap2.log"; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL ctap2: $(grep -m3 -E 'error|expected|actual' "$W/ctap2.log" | tr '\n' ' ')"
fi

# UEFI Secure Boot formats (lib/rsakey, lib/x509gen's RSA certificates,
# lib/pkcs7, lib/authenticode): sbprobe makes a key from a seed, signs the
# PE32+ and PE32 images in tests/crypto/secureboot (gen_pe.py) and checks
# its own refusals; check.py then verifies the key file, the certificate
# and each Authenticode signature independently with pyca/cryptography
# (skipped without it). UEFI firmware itself checks the same signatures in
# Hafen's test suite (OVMF with Secure Boot on).
(cd "$ROOT" && "$COMPILER" tests/crypto/sbprobe.resid ${RESID_TARGET:+--target $RESID_TARGET} -o "$W/sbprobe") > "$W/build.log" 2>&1 || {
    echo "FAIL build sbprobe"; grep -i -A3 error "$W/build.log" | head -8; exit 1; }
mkdir -p "$W/sb"
if out="$("$W/sbprobe" "$W/sb" "$ROOT/tests/crypto/secureboot" "resid secure boot" 2>&1)"; then
    pass=$((pass + $(printf '%s\n' "$out" | grep -c '^pass ')))
else
    fail=$((fail + 1)); printf '%s\n' "$out" | grep -E '^FAIL|abort' | head -5
fi
if python3 -c 'import cryptography' 2>/dev/null; then
    if out="$(python3 "$ROOT/tests/crypto/secureboot/check.py" "$W/sb" 2>&1)"; then
        pass=$((pass + $(printf '%s\n' "$out" | grep -c '^pass ')))
    else
        fail=$((fail + 1)); printf '%s\n' "$out" | grep -E '^FAIL|Error' | head -5
    fi
else
    echo "note: secure boot cross-check skipped (python3 cryptography not installed)"
fi

# Merkle transparency logs (lib/merkle.resid): RFC 9162 roots, inclusion
# and consistency proofs (valid and tampered) for every tree size up to 70,
# signed checkpoints and witness cosignatures, made and checked byte for
# byte against golang.org/x/mod's tlog and note (merkle_ref/gen.sh).
(cd "$ROOT" && "$COMPILER" tests/crypto/merkleprobe.resid ${RESID_TARGET:+--target $RESID_TARGET} -o "$W/merkleprobe") > "$W/build.log" 2>&1 || {
    echo "FAIL build merkleprobe"; grep -i -A3 error "$W/build.log" | head -8; exit 1; }
out="$("$W/merkleprobe" "$ROOT/tests/crypto/vectors_merkle/merkle.txt" 2>&1)"
summary="$(printf '%s\n' "$out" | sed -n 's/^SUMMARY //p')"
p="$(printf '%s' "$summary" | sed -n 's/.*pass=\([0-9]*\).*/\1/p')"
x="$(printf '%s' "$summary" | sed -n 's/.*fail=\([0-9]*\).*/\1/p')"
if [ -z "$summary" ]; then fail=$((fail + 1)); echo "FAIL merkleprobe did not finish"; printf '%s\n' "$out" | tail -3;
else pass=$((pass + p)); fail=$((fail + x)); [ "$x" = 0 ] || printf '%s\n' "$out" | grep '^FAIL' | head -5 | cut -c1-200; fi

# ristretto255 and Pedersen commitments (lib/ristretto255g.resid's public
# copy) against libsodium (gen_ristretto.py): multiples of the generator,
# canonical and junk encodings, the one-way map, addition, scalar
# multiplication, scalar arithmetic mod l and Pedersen commitments.
(cd "$ROOT" && "$COMPILER" tests/crypto/r255probe.resid ${RESID_TARGET:+--target $RESID_TARGET} -o "$W/r255probe") > "$W/build.log" 2>&1 || {
    echo "FAIL build r255probe"; grep -i -A3 error "$W/build.log" | head -8; exit 1; }
out="$("$W/r255probe" "$ROOT/tests/crypto/vectors_r255/r255.txt" 2>&1)"
summary="$(printf '%s\n' "$out" | sed -n 's/^SUMMARY //p')"
p="$(printf '%s' "$summary" | sed -n 's/.*pass=\([0-9]*\).*/\1/p')"
x="$(printf '%s' "$summary" | sed -n 's/.*fail=\([0-9]*\).*/\1/p')"
if [ -z "$summary" ]; then fail=$((fail + 1)); echo "FAIL r255probe did not finish"; printf '%s\n' "$out" | tail -3;
else pass=$((pass + p)); fail=$((fail + x)); [ "$x" = 0 ] || printf '%s\n' "$out" | grep '^FAIL' | head -5 | cut -c1-200; fi

# ML-DSA (lib/mldsa.resid) at all three parameter sets: NIST ACVP keyGen,
# sigGen (deterministic and hedged; external, internal and external-mu)
# byte for byte, sigVer (valid and invalid), and OpenSSL's signatures
# (gen_mldsa.py over an ACVP-Server checkout and pyca/cryptography).
(cd "$ROOT" && "$COMPILER" tests/crypto/mldsaprobe.resid ${RESID_TARGET:+--target $RESID_TARGET} -o "$W/mldsaprobe") > "$W/build.log" 2>&1 || {
    echo "FAIL build mldsaprobe"; grep -i -A3 error "$W/build.log" | head -8; exit 1; }
out="$("$W/mldsaprobe" "$ROOT/tests/crypto/vectors_mldsa/mldsa.txt" 2>&1)"
summary="$(printf '%s\n' "$out" | sed -n 's/^SUMMARY //p')"
p="$(printf '%s' "$summary" | sed -n 's/.*pass=\([0-9]*\).*/\1/p')"
x="$(printf '%s' "$summary" | sed -n 's/.*fail=\([0-9]*\).*/\1/p')"
if [ -z "$summary" ]; then fail=$((fail + 1)); echo "FAIL mldsaprobe did not finish"; printf '%s\n' "$out" | tail -3;
else pass=$((pass + p)); fail=$((fail + x)); [ "$x" = 0 ] || printf '%s\n' "$out" | grep '^FAIL' | head -5 | cut -c1-200; fi

echo "crypto: $pass passed, $fail failed ($files vector files)"
[ "$fail" -eq 0 ]
