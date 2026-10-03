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
(cd "$ROOT" && "$COMPILER" tests/tls/srvprobe.resid -o "$W/srvprobe") > "$W/build.log" 2>&1 || {
    echo "FAIL build srvprobe"; grep -i error "$W/build.log" | head -3; exit 1; }
SRVPROBE="$W/srvprobe"
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
# An issuer-signed response still carries a certificate in its `certs`
# field, and that certificate is not a delegate: the CA names no EKU for
# it, so there is no responder to have authorised.
owant "ocsp issuer signs, no delegate" DELEGATE false

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

# The store consults the response: a good answer admits the certificate
# with no CRL present, and a revoked one refuses it.
oprobe "$F/ocsp-good.der" "$F/ca.der" "$F/good.der"
owant "ocsp store admits good" ACCEPT true
oprobe "$F/ocsp-revoked.der" "$F/ca.der" "$F/revoked.der"
owant "ocsp store refuses revoked" ACCEPT false
# A response about another certificate leaves the store with no answer,
# and a store that requires revocation refuses what it cannot check.
oprobe "$F/ocsp-revoked.der" "$F/ca.der" "$F/good.der"
owant "ocsp store no answer" ACCEPT false

# A truncated response yields no answer rather than a crash.
head -c 40 "$F/ocsp-good.der" > "$W/ocsp-trunc.der"
oprobe "$W/ocsp-trunc.der" "$F/ca.der" "$F/good.der"
owant "ocsp truncated" STATUS -1

# A response signed by a responder the CA authorised is evidence when that
# responder is authorised for it: the certificate in the response has to
# chain to this issuer and carry the OCSPSigning EKU. The response is
# genuine and its answer is good, so nothing here turns on the issuer
# having signed it -- SIGNATURE=false is exactly the point.
oprobe "$F/ocsp-delegated.der" "$F/dca.der" "$F/dgood.der"
owant "ocsp delegated not issuer signed" SIGNATURE false
owant "ocsp delegated responder" DELEGATE true
owant "ocsp delegated status" DELEGATED_STATUS 0
owant "ocsp delegated before thisUpdate" DELEGATED_STALE -1
owant "ocsp delegated store admits good" ACCEPT true

# Naming another certificate says nothing about this one, whoever signed
# the response.
oprobe "$F/ocsp-delegated.der" "$F/dca.der" "$F/good.der"
owant "ocsp delegated other cert" DELEGATED_STATUS -1

# A responder the issuer does not vouch for authorises nothing: the
# certificate in the response chains to dca, not to other.
oprobe "$F/ocsp-delegated.der" "$F/other.der" "$F/dgood.der"
owant "ocsp delegated wrong signer" DELEGATE false
owant "ocsp delegated wrong signer status" DELEGATED_STATUS -1

# A responder with no EKU is authorised for nothing, which is what openssl
# says as well -- "ocsp_check_delegated: missing ocspsigning usage".
oprobe "$F/ocsp-delegated-noeku.der" "$F/dca.der" "$F/dgood.der"
owant "ocsp responder without eku" DELEGATE false
owant "ocsp responder without eku status" DELEGATED_STATUS -1
owant "ocsp responder without eku store" ACCEPT false

# ── the server side ──────────────────────────────────────────────────
# A server has to get three things right that a client never has to: read
# a private key, produce a signature, and read a ClientHello. These are
# the facts behind that, driven through tests/tls/srvprobe.resid.
sprobe() { LAST="$("$SRVPROBE" "$@" 2>&1)"; }
swant() {
    if [ "$(field "$2")" = "$3" ]; then ok; else bad "$1: $2=$(field "$2") want=$3"; fi
}
EC_PUB="0421c6245699b8808669f8f7754ca9259cb09a056fef1b81eecdaae0ae301cb85597916427da78cec04200cd722174ceaf506ec2780c5c01bd881f47e6456e9e54"
ED_PUB="a7662b063b00809c8856d465e67f92cad9a496a42899a411ab5e82f9e9b4013b"
for k in srv.key srv.key.der; do
    sprobe --keys "$F/$k"
    swant "$k" alg 1027
    swant "$k" pub "$EC_PUB"
done
for k in srved.key srved.key.der; do
    sprobe --keys "$F/$k"
    swant "$k" alg 2055
    swant "$k" pub "$ED_PUB"
done
# A CA key is still a key and still loads: refusing it would be refusing a
# key because of what it is *for*, which is not the loader's business.
sprobe --keys "$F/srvca.key"; swant "a CA key still loads" alg 1027
# A certificate is not one -- its public key is in the certificate, not in
# a file the signer reads -- and neither is a file that is not there.
sprobe --keys "$F/srv.der"; swant "a certificate is not a key" alg -1
sprobe --keys "$F/leaf.pem"; swant "a PEM certificate is not a key" alg -1
sprobe --keys "$F/no-such.key"; swant "a missing file is not a key" alg -1

# The certificate has to carry the key the server signs with, or every
# handshake fails on the client's side instead of at startup.
sprobe --match "$F/srv.key" "$F/srv.pem"; swant "key matches its certificate" match 1
sprobe --match "$F/srved.key" "$F/srved.pem"; swant "ed25519 key matches" match 1
sprobe --match "$F/srv.key" "$F/srved.pem"; swant "a key and another key's certificate" match 0

# Signatures, pinned: the ECDSA nonce is a parameter here, so the bytes are
# a function of the content and the key alone. openssl verifies both of
# these values (fixtures/README.md has the commands).
sprobe --sign "$F/srv.key"
swant "ecdsa pinned signature" pinned "30440220515c3d6eb9e396b904d3feca7f54fdcd0cc1e997bf375dca515ad0a6c3b4035f022047d96836b7476378955489c90629cd5b778a32c0b9cd67f98e5f0f3164e95daf"
sprobe --sign "$F/srved.key"
swant "ed25519 pinned signature" pinned "5b2861c334037b6c9df91c71ba0a45287a6bee1655bcd85624c163a090aaf4b71d76f8f13ea116acb97b22549d6d0adfac4160d1ebe9b8a9ed0c7116f202e000"
swant "ed25519 signature length" len 64

# A real openssl 3.6 ClientHello: TLS 1.3, a 32-byte session id, an x25519
# share behind a post-quantum hybrid one, both signature algorithms, and an
# ALPN list this server would pick http/1.1 out of.
sprobe --hello "$F/ch-ossl.bin"
swant "ossl hello parses" err 0
swant "ossl hello is tls13" tls13 true
swant "ossl session id length" session_id 32
swant "ossl x25519 share found" share 32
swant "ossl offers ecdsa" ecdsa true
swant "ossl offers ed25519" ed25519 true
swant "ossl alpn pick" alpn_pick http/1.1
# Truncated: refused, not read past the end.
sprobe --trunc "$F/ch-ossl.bin"
swant "whole hello" full 0
swant "half a hello" half 1
swant "eight bytes of a hello" tiny 1

# ── live handshakes ──────────────────────────────────────────────────
# The server is examples/https_server.resid. The clients are this
# repository's own (examples/tls_client.resid) and, when it is installed,
# openssl. Both check the certificate against a trust store, so a case
# that passes has proved the chain and the signature, not just the keys.
(cd "$ROOT" && "$COMPILER" examples/https_server.resid -o "$W/https") > "$W/build.log" 2>&1 || {
    echo "FAIL build https_server"; grep -i error "$W/build.log" | head -3; exit 1; }
(cd "$ROOT" && "$COMPILER" examples/tls_client.resid -o "$W/tlsclient") > "$W/build.log" 2>&1 || {
    echo "FAIL build tls_client"; grep -i error "$W/build.log" | head -3; exit 1; }

hex_of() { python3 -c 'import sys; sys.stdout.write(open(sys.argv[1],"rb").read().hex())' "$1"; }
EC_CERT="$(hex_of "$F/srv.der")"

# A certificate that does not carry the key is refused at startup, saying
# which of the two files is wrong, rather than failing every handshake.
"$W/https" --cert "$F/srv.pem" --key "$F/srved.key" --port 0 > "$W/mismatch.out" 2>&1
if [ "$?" = 2 ] && grep -q "does not carry the key" "$W/mismatch.out"; then ok
else bad "mismatched key and certificate: exit $? $(cat "$W/mismatch.out")"; fi
"$W/https" --cert "$F/srv.pem" --key "$F/no-such.key" --port 0 > "$W/nokey.out" 2>&1
if [ "$?" = 2 ] && grep -q "cannot read a usable key" "$W/nokey.out"; then ok
else bad "unreadable key: exit $? $(cat "$W/nokey.out")"; fi

# serve <conns> <logfile> <cert> <key>: a server that exits after `conns`.
serve() {
    rm -f "$W/port"
    "$W/https" --cert "$3" --key "$4" --port 0 --workers 2 --conns "$1" \
        --root "$W/root" --port-file "$W/port" --alpn http/1.1 > "$2" 2>&1 &
    SRVPID=$!
    for _ in $(seq 1 400); do [ -s "$W/port" ] && break; sleep 0.05; done
    SRVPORT="$(cat "$W/port" 2>/dev/null)"
}
unserve() { kill "$SRVPID" 2>/dev/null; wait "$SRVPID" 2>/dev/null; }
mkdir -p "$W/root"
printf 'served over tls\n' > "$W/root/note.txt"

# This repository's client, trusting the fixture CA. It prints the first
# line of the decrypted reply, so a 200 is the whole handshake answered:
# the chain verified, the CertificateVerify verified, and both Finisheds
# verified, or nothing would have been decrypted.
serve 1 "$W/srv.log" "$F/srv.pem" "$F/srv.key"
if [ -n "$SRVPORT" ]; then
    LAST="$("$W/tlsclient" localhost "$SRVPORT" "$EC_CERT" "" "$F/srvca.pem" 2>&1)"
    printf '%s\n' "$LAST" | grep -q "^REPLY: HTTP/1.1 200 OK" && ok \
        || bad "resid client against the resid server: $(printf '%s' "$LAST" | tr '\n' ' ')"
else bad "https server did not report a port"; fi
unserve

# A client that does not trust the server's CA gets nothing: refused, not
# downgraded and not served.
serve 1 "$W/srv.log" "$F/srv.pem" "$F/srv.key"
if [ -n "$SRVPORT" ]; then
    LAST="$("$W/tlsclient" localhost "$SRVPORT" "$EC_CERT" "" "$F/other.pem" 2>&1)"
    printf '%s\n' "$LAST" | grep -q "^CERT-FAIL" && ok \
        || bad "an untrusted chain must fail: $(printf '%s' "$LAST" | tr '\n' ' ')"
    printf '%s\n' "$LAST" | grep -q "^REPLY" && bad "an untrusted chain got a reply: $(printf '%s' "$LAST" | tr '\n' ' ')"
else bad "https server did not report a port (2)"; fi
unserve

# openssl, when it is installed: the reference client against the ECDSA
# server, then the Ed25519 one (this repository's own client verifies only
# ECDSA-P256 and RSA-PSS CertificateVerifies, so openssl is what covers
# the other algorithm end to end), and a version this server does not
# speak.
if command -v openssl > /dev/null; then
    serve 2 "$W/ossl_srv.log" "$F/srv.pem" "$F/srv.key"
    if [ -n "$SRVPORT" ]; then
        printf 'GET /files/note.txt HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n' \
            | timeout 180 openssl s_client -connect 127.0.0.1:"$SRVPORT" -CAfile "$F/srvca.pem" \
                -servername localhost -quiet > "$W/ossl.out" 2>"$W/ossl.err"
        grep -q "served over tls" "$W/ossl.out" && ok \
            || bad "openssl s_client: $(tail -2 "$W/ossl.out" | tr '\n' ' ') $(tail -1 "$W/ossl.err")"
        # TLS 1.2 only: refused with protocol_version, so the client never
        # gets a reply at all.
        timeout 60 openssl s_client -connect 127.0.0.1:"$SRVPORT" -CAfile "$F/srvca.pem" \
            -servername localhost -tls1_2 </dev/null > "$W/ossl12.out" 2>&1
        grep -qiE "alert|protocol version|error|no protocols" "$W/ossl12.out" && ok \
            || bad "TLS 1.2 should be refused: $(tail -2 "$W/ossl12.out" | tr '\n' ' ')"
    else bad "https server did not report a port (3)"; fi
    unserve

    serve 1 "$W/ossl_ed.log" "$F/srved.pem" "$F/srved.key"
    if [ -n "$SRVPORT" ]; then
        printf 'GET /files/note.txt HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n' \
            | timeout 180 openssl s_client -connect 127.0.0.1:"$SRVPORT" -CAfile "$F/srvedca.pem" \
                -servername localhost -quiet > "$W/ossled.out" 2>"$W/ossled.err"
        grep -q "served over tls" "$W/ossled.out" && ok \
            || bad "openssl against the ed25519 server: $(tail -2 "$W/ossled.out" | tr '\n' ' ') $(tail -1 "$W/ossled.err")"
    else bad "https server did not report a port (4)"; fi
    unserve
else
    echo "note: openssl not installed, skipping the s_client cases"
fi

echo "tls: $pass passed, $fail failed"
[ "$fail" -eq 0 ]