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

echo "tls: $pass passed, $fail failed"
[ "$fail" -eq 0 ]