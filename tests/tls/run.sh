#!/usr/bin/env bash
# TLS 1.3 server authentication: the trust store, chain validation, and the
# PEM/base64 reading a PEM store needs (SECURITY.md; lib/chain.resid's trust
# store, spec §28.2's "accept only when you can name who signed it").
#
# Every case drives tests/tls/tsprobe.resid, which prints one `KEY=value`
# line per fact. The certificates in fixtures/ are committed, so this needs
# no openssl and no network.
#
# Usage: tests/tls/run.sh [-c COMPILER]
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

pass=0; fail=0
ok()  { pass=$((pass + 1)); }
bad() { fail=$((fail + 1)); echo "FAIL $1"; }

(cd "$ROOT" && "$COMPILER" tests/tls/tsprobe.resid -o "$W/tsprobe") > "$W/build.log" 2>&1 || {
    echo "FAIL build tsprobe"; grep -i error "$W/build.log" | head -3; exit 1; }
PROBE="$W/tsprobe"
(cd "$ROOT" && "$COMPILER" tests/tls/ocspprobe.resid -o "$W/ocspprobe") > "$W/build.log" 2>&1 || {
    echo "FAIL build ocspprobe"; grep -i error "$W/build.log" | head -3; exit 1; }
OPROBE="$W/ocspprobe"
F="$ROOT/tests/tls/fixtures"

# Stores derived from the fixtures, built here so the fixture directory
# stays exactly what is committed.
mkdir -p "$W/derstore" "$W/emptystore" "$W/pinstore" "$W/inters"
cp "$F/root.der" "$W/derstore/"
cp "$F/leaf.der" "$W/pinstore/"
cp "$F/inter.der" "$W/inters/"

LAST=""
field() { printf '%s\n' "$LAST" | sed -n "s/^$1=//p"; }

# probe <store> <leaf> <host> [intermediates-dir] -> LAST
probe() {
    if [ -n "${4:-}" ]; then
        LAST="$("$PROBE" "$1" "$2" "$3" "$4" 2>&1)"
    else
        LAST="$("$PROBE" "$1" "$2" "$3" 2>&1)"
    fi
}

# want <name> <expected TRUSTED> -- judged against the last probe.
want() {
    if [ "$(field TRUSTED)" = "$2" ]; then ok; else bad "$1: TRUSTED=$(field TRUSTED) want=$2 [$(printf '%s' "$LAST" | tr '\n' ' ')]"; fi
}

L="$F/leaf.der"

# A PEM bundle and a directory of DER hold the same anchor, and either one
# validates the chain the server sent.
probe "$F/root.pem" "$L" localhost "$W/inters"; want pemstore-full-chain true
[ "$(field roots)" = 1 ] && ok || bad "PEM store loaded $(field roots) roots, want 1"
[ "$(field inters)" = 1 ] && ok || bad "intermediates read: $(field inters), want 1"
[ "$(field valid_now)" = true ] && ok || bad "leaf should be in date"
[ "$(field san)" = true ] && ok || bad "leaf should match localhost"
[ "$(field pinned)" = false ] && ok || bad "leaf must be chained, not pinned"

probe "$W/derstore" "$L" localhost "$W/inters"; want derstore-full-chain true
probe "$F/root.pem" "$L" localhost; want pemstore-no-chain false
[ "$(field inters)" = 0 ] && ok || bad "intermediates read: $(field inters), want 0"

# Fail closed: no store, or an empty one, trusts nothing.
probe "" "$L" localhost "$W/inters"; want no-store false
probe "$W/emptystore" "$L" localhost "$W/inters"; want empty-store false

# A leaf is only as trusted as the anchor that issued it.
probe "$F/other.pem" "$L" localhost "$W/inters"; want wrong-anchor false
probe "$F/other.pem" "$F/oleaf.der" localhost; want other-root-own-leaf true
probe "$W/derstore" "$F/oleaf.der" localhost "$W/inters"; want derstore-rejects-other-leaf false

# Hostname is checked on top of the chain, never instead of it.
probe "$F/root.pem" "$L" evil.test "$W/inters"; want wrong-host false
[ "$(field san)" = false ] && ok || bad "evil.test should not match the SAN"

# A pinned leaf is accepted with no chain at all, but still has to be in
# date and still has to name the host.
probe "$W/pinstore" "$L" localhost; want pinned-leaf true
probe "$W/pinstore" "$L" evil.test; want pinned-leaf-wrong-host false
probe "$W/pinstore" "$F/expired.der" localhost; want pinned-expired-leaf false
[ "$(field valid_now)" = false ] && ok || bad "expired fixture should be out of date"

# Expiry.
probe "$F/root.pem" "$F/expired.der" localhost "$W/inters"; want expired-leaf false

# ── Certificate message framing (tm_cert_list) ──────────────────────
# A server's chain arrives as one message; the intermediates in it are
# what the trust store walks. Getting the walk wrong here is not cosmetic:
# a phantom trailing certificate is exactly what must never reach
# signature verification.
certs() { "$PROBE" x --certs "$@" 2>&1 | sed -n 's/^body=[0-9]* certs=\([0-9]*\) lens=\(.*\)$/\1 \2/p'; }

[ "$(certs "$F/certmsg.bin")" = "1 414" ] && ok \
  || bad "single-certificate message: $(certs "$F/certmsg.bin")"
[ "$(certs "$F/certmsg2.bin")" = "2 459,415" ] && ok \
  || bad "two-certificate message: $(certs "$F/certmsg2.bin")"
[ "$(certs "$F/certmsg3.bin")" = "3 459,415,408" ] && ok \
  || bad "three-certificate message: $(certs "$F/certmsg3.bin")"
# A non-empty request context is length-prefixed and has to be stepped over.
[ "$(certs "$F/certmsg-ctx.bin")" = "2 459,415" ] && ok \
  || bad "message with a request context: $(certs "$F/certmsg-ctx.bin")"
# A certificate_list longer than the entries it holds must not produce a
# phantom certificate -- the bug that made an empty list reach chain
# validation.
[ "$(certs "$F/certmsg-long.bin")" = "1 459" ] && ok \
  || bad "over-long certificate_list: $(certs "$F/certmsg-long.bin")"
# Truncated mid-entry: the whole certificate that is there still comes
# out, and the half one is dropped rather than turned into bytes.
[ "$(certs "$F/certmsg-trunc.bin")" = "1 459" ] && ok \
  || bad "truncated message: $(certs "$F/certmsg-trunc.bin")"

# ── signature algorithms ─────────────────────────────────────────────
# RSA certificate signatures were not exercised anywhere before, which is
# how a read one byte past the end of the signature buffer survived: the
# only "test" was the note "(library code)".
sig() { "$PROBE" x --sig "$F/$1.der" 2>&1 | sed -n "s/^$2 *=[[:space:]]*//p"; }
for c in root rsa_pkcs1 rsa_pss; do
    [ "$(sig "$c" sig_ok)" = "true" ] && ok || bad "$c: signature does not verify"
    [ "$(sig "$c" chain_verify)" = "true" ] && ok || bad "$c: chain_verify against itself"
    [ "$(sig "$c" is_ca)" = "true" ] && ok || bad "$c: should be a CA"
    [ "$(sig "$c" keycertsign)" = "true" ] && ok || bad "$c: should allow keyCertSign"
done
[ "$(sig rsa_pkcs1 sigalg)" = "1.2.840.113549.1.1.11" ] && ok || bad "pkcs1 OID"
[ "$(sig rsa_pss sigalg)" = "1.2.840.113549.1.1.10" ] && ok || bad "pss OID"
# A leaf may not act as an issuer, and that is checked, not assumed.
[ "$(sig leaf is_ca)" = "false" ] && ok || bad "leaf must not be a CA"

# ── revocation (CRL) ─────────────────────────────────────────────────
# A store carrying CRLs enforces them; `revocation_required` additionally
# refuses a certificate no current CRL covers, so "no revocation
# information" never silently reads as "not revoked".
IN_WINDOW="$(date -u -d '2026-10-15' +%s)"
STALE="$(date -u -d '2026-12-01' +%s)"
mkdir -p "$W/crlstore" && cp "$F/ca.der" "$W/crlstore/"
rev() { "$PROBE" "$W/crlstore" --revoke "$F/crl.der" "$F/$1.der" localhost "" "$F/ca.der" "$2" 2>&1; }
revfield() { printf "%s\n" "$REV" | sed -n "s/^$1 *=[[:space:]]*//p"; }

REV="$(rev good "$IN_WINDOW")"
[ "$(revfield crl_usable)" = true ] && ok || bad "CRL should be usable inside its window"
[ "$(revfield crl_revokes)" = false ] && ok || bad "good.der must not be listed"
[ "$(revfield covered)" = true ] && ok || bad "good.der should be covered by a CRL"
[ "$(revfield TRUSTED)" = true ] && ok || bad "good.der should be trusted"
[ "$(revfield TRUSTED-strict)" = true ] && ok || bad "good.der should be trusted under revocation_required"

REV="$(rev bad "$IN_WINDOW")"
[ "$(revfield crl_revokes)" = true ] && ok || bad "bad.der must be listed as revoked"
[ "$(revfield revoked)" = true ] && ok || bad "bad.der revoked flag"
[ "$(revfield TRUSTED)" = false ] && ok || bad "a revoked certificate must not be trusted"
[ "$(revfield TRUSTED-strict)" = false ] && ok || bad "a revoked certificate must not be trusted under revocation_required"

# A CRL past its nextUpdate says what was true when it was issued and is
# not used: relying on it is how a revoked certificate keeps working.
REV="$(rev bad "$STALE")"
[ "$(revfield crl_usable)" = false ] && ok || bad "a stale CRL must not be usable"
[ "$(revfield covered)" = false ] && ok || bad "a stale CRL covers nothing"
[ "$(revfield TRUSTED-strict)" = false ] && ok || bad "revocation_required must refuse a stale CRL"
# The serial the CRL lists, so the parse itself is pinned and not just the
# verdict.
REV="$(rev bad "$IN_WINDOW")"
[ "$(revfield revoked_list)" = "2001" ] && ok || bad "CRL should list serial 2001, got $(revfield revoked_list)"

# PEM reading, checked through what it produces.
probe "$F/root.pem" "$F/root.der" localhost
[ "$(field roots)" = 1 ] && ok || bad "PEM bundle did not parse to one root"
[ "$(field pinned)" = true ] && ok || bad "PEM-parsed root should equal root.der"

printf 'not a certificate at all\n' > "$W/junk.pem"
probe "$W/junk.pem" "$L" localhost
[ "$(field roots)" = 0 ] && ok || bad "junk PEM produced $(field roots) roots"

printf -- '-----BEGIN CERTIFICATE-----\nZm9vYmFy\n' > "$W/trunc.pem"
probe "$W/trunc.pem" "$L" localhost
[ "$(field roots)" = 0 ] && ok || bad "unterminated PEM block produced a root"

# An intermediates argument that is a file rather than a directory yields
# no intermediates, so a chain that needs one fails rather than silently
# skipping it.
probe "$F/root.pem" "$L" localhost "$F/inter.der"; want inter-not-a-dir false
[ "$(field inters)" = 0 ] && ok || bad "a file as intermediates dir gave $(field inters)"

# A store path that does not exist is an empty store, not a crash.
probe "$W/no-such-path" "$L" localhost
[ "$(field roots)" = 0 ] && ok || bad "missing store path produced $(field roots) roots"
[ "$(field TRUSTED)" = false ] && ok || bad "missing store path must not trust"

oprobe() { LAST="$("$OPROBE" "$1" "$2" "$3" 2>&1)"; }
owant() {
    if [ "$(field "$2")" = "$3" ]; then ok; else bad "$1: $2=$(field "$2") want=$3 [$(printf '%s' "$LAST" | tr '\n' ' ')]"; fi
}

# An OCSP response is evidence only when the issuer signed it, it names
# this certificate, and it is inside its own validity window.
oprobe "$F/ocsp-good.der" "$F/ca.der" "$F/good.der"
owant "ocsp good signature" SIGNATURE true
owant "ocsp good status" STATUS 0
owant "ocsp good before thisUpdate" STALE -1
owant "ocsp good no revocation" REVOKED_AT -1

# A revoked certificate is reported revoked, with the time it happened.
oprobe "$F/ocsp-revoked.der" "$F/ca.der" "$F/revoked.der"
owant "ocsp revoked signature" SIGNATURE true
owant "ocsp revoked status" STATUS 1
owant "ocsp revoked time" REVOKED_AT 1735689600

# A response naming another certificate says nothing about this one, even
# though it is genuine and signed by the same issuer.
oprobe "$F/ocsp-good.der" "$F/ca.der" "$F/leaf.der"
owant "ocsp other cert" STATUS -1

# A signature that is not the issuer's is not evidence, so the good answer
# inside it does not survive.
oprobe "$F/ocsp-good.der" "$F/other.der" "$F/good.der"
owant "ocsp wrong signer" SIGNATURE false
owant "ocsp wrong signer status" STATUS -1

# A truncated response yields no answer rather than a crash.
head -c 40 "$F/ocsp-good.der" > "$W/ocsp-trunc.der"
oprobe "$W/ocsp-trunc.der" "$F/ca.der" "$F/good.der"
owant "ocsp truncated" STATUS -1

echo "tls: $pass passed, $fail failed"
[ "$fail" -eq 0 ]