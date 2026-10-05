#!/usr/bin/env bash
# Package integrity and capability-ceiling checks for the self-hosted
# package tools (spec §21.1, §28): tools/resid-pkg.resid publishes and
# signs, tools/resid-manifest.resid resolves and verifies.
#
# Usage: tests/pkg/run.sh [-c COMPILER]
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
trap cleanup EXIT
if [ -z "${RESID_SIGNING_KEY:-}" ] && [ ! -f "$ROOT/keys/resid-ed25519.key" ]; then
    "$COMPILER" keygen "$W/buildkey" >/dev/null && export RESID_SIGNING_KEY="$W/buildkey/resid-ed25519.key"
fi
pass=0; fail=0
ok()  { pass=$((pass + 1)); }
bad() { fail=$((fail + 1)); echo "FAIL $1"; }
SRVS=""
cleanup() { for p in $SRVS; do kill "$p" 2>/dev/null; done; rm -rf "$W"; }
trap cleanup EXIT

# Start `resid-pkg serve` on <dir>; echoes the port it bound to. The server
# is the real one the registry system ships -- binding loopback only, and
# refusing any request path that could name a file outside <dir> -- so the
# remote cases exercise the same code a publisher would run.
serve() {  # dir
    local pf="$W/port.$RANDOM$RANDOM"
    "$PKG" serve "$1" --port 0 --port-file "$pf" > "$pf.log" 2>&1 &
    SRVS="$SRVS $!"
    local i=0
    while [ ! -s "$pf" ] && [ $i -lt 150 ]; do sleep 0.1; i=$((i + 1)); done
    cat "$pf" 2>/dev/null
}

for t in resid-pkg resid-manifest; do
    (cd "$ROOT" && "$COMPILER" "tools/$t.resid" -o "$W/$t") > "$W/$t.log" 2>&1 || { echo "FAIL build $t"; cat "$W/$t.log" | grep -i error | head -3; exit 1; }
done
# The https path into a registry: `resid-pkg serve --cert --key` publishes
# one; resid-manifest fetches from it directly and resid-fetch mirrors one
# artifact, built here because the cases below drive it for real.
(cd "$ROOT" && "$COMPILER" tools/resid-fetch.resid -o "$W/resid-fetch") > "$W/resid-fetch.log" 2>&1 || {
    echo "FAIL build resid-fetch"; grep -i error "$W/resid-fetch.log" | head -3; exit 1; }
PKG="$W/resid-pkg"; MAN="$W/resid-manifest"; FETCH="$W/resid-fetch"
# The driver finds the standard library and the runtime IR under RESID_HOME;
# without it they resolve relative to the current directory.
export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"

# A package: greet 1.0.0, and a second one to substitute for it.
mkpkg() {  # dir name version body
    mkdir -p "$1/src"
    printf '[package]\nname = "%s"\nversion = "%s"\n' "$2" "$3" > "$1/resid.toml"
    printf '%s\n' "$4" > "$1/src/main.resid"
}
mkpkg "$W/greet" greet 1.0.0 'pub Str greet() { return "hi"; }'
mkpkg "$W/evil" greet 6.6.6 'pub Str greet() { return "evil"; }'
"$PKG" keygen "$W/pub.sec" "$W/pub.pub" > /dev/null
"$PKG" keygen "$W/other.sec" "$W/other.pub" > /dev/null
PUB="$(cat "$W/pub.pub")"; OTHER="$(cat "$W/other.pub")"

# The secret key is readable by its owner only.
[ "$(stat -c %a "$W/pub.sec")" = 600 ] && ok || bad "keygen secret mode $(stat -c %a "$W/pub.sec")"

# An app depending on greet 1.0.0 from a local registry.
app() {  # name extra-toml
    mkdir -p "$W/$1/src"
    printf '[package]\nname = "%s"\nversion = "0.1.0"\n\n[registry]\npath = "../reg"\n%s\n[dependencies.greet]\nversion = "1.0.0"\n' "$1" "$2" > "$W/$1/resid.toml"
    printf 'import "greet";\nInt main() { println(greet()); return 0; }\n' > "$W/$1/src/main.resid"
}
deps() { (cd "$W" && "$MAN" deps "$W/$1/resid.toml") > "$W/$1.out" 2>&1; }
expect_ok()   { deps "$1"; if [ $? -eq 0 ]; then ok; else bad "$1: $(tail -1 "$W/$1.out")"; fi; }
expect_fail() { deps "$1"; if [ $? -ne 0 ] && grep -q "$2" "$W/$1.out"; then ok; else bad "$1: wanted '$2', got: $(tail -1 "$W/$1.out")"; fi; }

# Unsigned publish: rejected unless the manifest opts in.
"$PKG" publish "$W/greet" "$W/reg" > /dev/null
app unsigned ""
expect_fail unsigned "is unsigned"
app devprofile $'[signing]\nallow_unsigned = true'
expect_ok devprofile

# Signed publish: the registry's signed index or a pinned key is trusted.
rm -rf "$W/reg"; "$PKG" publish "$W/greet" "$W/reg" "$W/pub.sec" > /dev/null
app noanchor ""
expect_fail noanchor "is unsigned"
app viaindex "pubkey = \"$PUB\""
expect_ok viaindex
app wrongindex "pubkey = \"$OTHER\""
expect_fail wrongindex "signature INVALID"
app pinned ""
printf 'pubkey = "%s"\n' "$PUB" >> "$W/pinned/resid.toml"
expect_ok pinned
app pinwrong ""
printf 'pubkey = "%s"\n' "$OTHER" >> "$W/pinwrong/resid.toml"
expect_fail pinwrong "INVALID or missing for its pinned key"
mkdir -p "$W/keyring"; cp "$W/pub.pub" "$W/keyring/publisher.pub"
app viakeyring $'[signing]\nkeyring = "../keyring"'
expect_ok viakeyring

# [signing] require_signatures: an index entry is not a signature. With it
# set, the signed index no longer admits a package by itself -- a detached
# signature under a pinned or keyring key has to.
# The registry here is signed and every artifact carries a detached
# signature, so what changes is only which key is consulted.
app reqsig_noanchor $'[signing]\nrequire_signatures = true'
expect_fail reqsig_noanchor "an index entry is not a signature"
app reqsig_keyring $'[signing]\nkeyring = "../keyring"\nrequire_signatures = true'
expect_ok reqsig_keyring
# A pinned key is still checked first, and a wrong one still fails.
app reqsig_wrongkey ""
printf 'pubkey = "%s"\n[signing]\nrequire_signatures = true\n' "$OTHER" >> "$W/reqsig_wrongkey/resid.toml"
expect_fail reqsig_wrongkey "INVALID or missing for its pinned key"
# With no [registry] pubkey there is no index to lean on at all, so this is
# the same demand arriving by a different road.
app reqsig_nopubkey $'[signing]\nrequire_signatures = true'
expect_fail reqsig_nopubkey "an index entry is not a signature"

# A modified archive fails the signed index and the pinned signature.
cp -r "$W/reg" "$W/reg.good"
printf 'x' >> "$W/reg/pkg/greet-1.0.0.resid-pkg"
rm -f "$W/reg/pkg/greet-1.0.0.resid-sha256"
app tamperidx "pubkey = \"$PUB\""
expect_fail tamperidx "does not match the signed registry index"
app tamperpin ""
printf 'pubkey = "%s"\n' "$PUB" >> "$W/tamperpin/resid.toml"
expect_fail tamperpin "INVALID or missing for its pinned key"
rm -rf "$W/reg"; mv "$W/reg.good" "$W/reg"

# Substitution: another package signed by the same key, served as greet.
"$PKG" pack "$W/evil" "$W/evilpkg" > /dev/null
cp "$W/evilpkg.resid-pkg" "$W/reg/pkg/greet-1.0.0.resid-pkg"
rm -f "$W/reg/pkg/greet-1.0.0.resid-sha256"
"$PKG" sign "$W/reg/pkg/greet-1.0.0" "$W/pub.sec" > /dev/null
app subst ""
printf 'pubkey = "%s"\n' "$PUB" >> "$W/subst/resid.toml"
expect_fail subst "archive holds package 'greet-6.6.6'"

# ── index: the publisher's side ──────────────────────────────────────
# publish maintains the index as a side effect; these are the operations
# that are not publishing, and each write re-signs the whole index.
IDX="$W/idxreg"
mkpkg "$W/idxpkg" greet 1.0.0 'pub Str greet() { return "hi"; }'
"$PKG" publish "$W/idxpkg" "$IDX" "$W/pub.sec" > /dev/null
HASH="$("$PKG" index list "$IDX" | sed -n 's/^greet 1\.0\.0 //p')"
[ -n "$HASH" ] && ok || bad "index list did not report the published hash"
"$PKG" index verify "$IDX" "$PUB" > /dev/null 2>&1 && ok || bad "index verify under the signing key"
"$PKG" index verify "$IDX" "$OTHER" > /dev/null 2>&1
[ $? -ne 0 ] && ok || bad "index verify accepted the wrong key"
# add re-signs, and verify still holds afterwards
"$PKG" index add "$IDX" other 2.0.0 aaaa1111 "$W/pub.sec" > /dev/null 2>&1 && ok || bad "index add"
"$PKG" index verify "$IDX" "$PUB" > /dev/null 2>&1 && ok || bad "index verify after add"
"$PKG" index list "$IDX" | grep -q '^other 2.0.0 aaaa1111$' && ok || bad "index list after add"
# a hash that contradicts the archive already published is refused
"$PKG" index add "$IDX" greet 1.0.0 deadbeefdeadbeef "$W/pub.sec" > /dev/null 2>&1
[ $? -ne 0 ] && ok || bad "index add accepted a hash contradicting the published archive"
# remove re-signs, and a name that is not there is an error not a no-op
"$PKG" index remove "$IDX" other 2.0.0 "$W/pub.sec" > /dev/null 2>&1 && ok || bad "index remove"
"$PKG" index verify "$IDX" "$PUB" > /dev/null 2>&1 && ok || bad "index verify after remove"
"$PKG" index list "$IDX" | grep -q '^other' && bad "index remove did not remove" || ok
"$PKG" index remove "$IDX" nope 1.0.0 "$W/pub.sec" > /dev/null 2>&1
[ $? -ne 0 ] && ok || bad "index remove of an absent entry must fail"
# both writers refuse to re-sign without the key
"$PKG" index add "$IDX" z 1.0.0 abc > /dev/null 2>&1
[ $? -ne 0 ] && ok || bad "index add without a key must fail"
"$PKG" index remove "$IDX" greet 1.0.0 > /dev/null 2>&1
[ $? -ne 0 ] && ok || bad "index remove without a key must fail"

# ── serve: the transport the remote cases above use ──────────────────
# Loopback only, GET/HEAD only, and no request path may name a file outside
# the registry directory.
"$PKG" serve "$IDX" --port 0 --port-file "$W/sp.port" > "$W/sp.log" 2>&1 &
SRVS="$SRVS $!"
i=0; while [ ! -s "$W/sp.port" ] && [ $i -lt 150 ]; do sleep 0.1; i=$((i + 1)); done
SPORT="$(cat "$W/sp.port" 2>/dev/null)"
code() { timeout 5 curl -sS -o /dev/null -w '%{http_code}' "$@" 2>/dev/null; }
[ -n "$SPORT" ] && ok || bad "serve did not report a port"
# The remote cases below already drive this server over real HTTP through
# resid-manifest. These four need a client that will ask for things no
# package resolver would, so they need curl and are skipped without it.
if command -v curl > /dev/null 2>&1; then
    [ "$(code "http://127.0.0.1:$SPORT/pkg/index.resid-idx")" = 200 ] && ok || bad "serve GET"
    [ "$(code "http://127.0.0.1:$SPORT/pkg/no-such-thing")" = 404 ] && ok || bad "serve 404"
    [ "$(code -X POST "http://127.0.0.1:$SPORT/pkg/index.resid-idx")" = 405 ] && ok || bad "serve rejects POST"
    [ "$(code --path-as-is "http://127.0.0.1:$SPORT/../../../etc/passwd")" = 400 ] && ok || bad "serve refused a traversal path"
    # An artifact past the runtime's 1 MiB single-send cap comes back whole.
    head -c 3000000 /dev/urandom > "$IDX/big.bin"
    timeout 10 curl -sS -o "$W/big.got" "http://127.0.0.1:$SPORT/big.bin" 2>/dev/null
    cmp -s "$IDX/big.bin" "$W/big.got" && ok || bad "serve a 3 MB artifact byte-identical"
    rm -f "$IDX/big.bin"
else
    echo "note: curl absent, skipping the raw serve cases"
fi
# Clients that open a connection and stall mid-request hold a worker each
# until the request deadline, not the registry: another client is answered.
if command -v python3 > /dev/null 2>&1; then
    python3 - "$SPORT" <<'PY' && ok || bad "serve answers while other clients stall"
import socket, sys
port = int(sys.argv[1])
stalled = []
for _ in range(3):
    s = socket.create_connection(("127.0.0.1", port))
    s.sendall(b"GET /pkg/index.resid-idx HTTP/1.1\r\nHost: x\r\n")
    stalled.append(s)
c = socket.create_connection(("127.0.0.1", port), timeout=5)
c.sendall(b"GET /pkg/index.resid-idx HTTP/1.1\r\nHost: x\r\nConnection: close\r\n\r\n")
got = c.recv(64)
sys.exit(0 if got.startswith(b"HTTP/1.1 200") else 1)
PY
fi
# It is bound to loopback and nothing else.
if command -v ss > /dev/null 2>&1; then
    ss -ltn 2>/dev/null | grep -q "127.0.0.1:$SPORT" && ok || bad "serve is not bound to loopback only"
fi

# ── remote registry over HTTP ────────────────────────────────────────
# A registry reached by URL is untrusted input exactly like a local one,
# so the same checks must hold over it: the transport may not widen what
# is accepted, and a fetch that succeeds is never itself a reason to
# trust anything.
# Its own registry: the local cases above deliberately corrupted $W/reg
# (a substituted archive, a tampered one), and this block is about the
# transport, not about that damage.
"$PKG" publish "$W/greet" "$W/reghttp" "$W/pub.sec" > /dev/null
PORT="$(serve "$W/reghttp")"
rapp() {  # name extra-toml url
    mkdir -p "$W/$1/src"
    printf '[package]\nname = "%s"\nversion = "0.1.0"\n\n[registry]\nurl = "%s"\n%s\n[dependencies.greet]\nversion = "1.0.0"\n' "$1" "$3" "$2" > "$W/$1/resid.toml"
    printf 'import "greet";\nInt main() { println(greet()); return 0; }\n' > "$W/$1/src/main.resid"
}
URL="http://127.0.0.1:$PORT"
rapp remote_signed "pubkey = \"$PUB\"" "$URL"
expect_ok remote_signed
rapp remote_wrongkey "pubkey = \"$OTHER\"" "$URL"
expect_fail remote_wrongkey "signature INVALID"
rapp remote_unsigned "" "$URL"
expect_fail remote_unsigned "is unsigned"
# A trailing slash on the base URL must not double the path separator.
rapp remote_slash "pubkey = \"$PUB\"" "$URL/"
expect_ok remote_slash
# A version the registry does not publish.
mkdir -p "$W/rem404/src"
printf '[package]\nname = "rem404"\nversion = "0.1.0"\n\n[registry]\nurl = "%s"\n\n[dependencies.greet]\nversion = "9.9.9"\n' "$URL" > "$W/rem404/resid.toml"
printf 'Int main() { return 0; }\n' > "$W/rem404/src/main.resid"
expect_fail rem404 "cannot fetch 'greet-9.9.9'"
# Naming both transports is an error, not a silent precedence rule.
mkdir -p "$W/remboth/src"
printf '[package]\nname = "remboth"\nversion = "0.1.0"\n\n[registry]\npath = "../reg"\nurl = "%s"\n\n[dependencies.greet]\nversion = "1.0.0"\n' "$URL" > "$W/remboth/resid.toml"
printf 'Int main() { return 0; }\n' > "$W/remboth/src/main.resid"
expect_fail remboth "sets both path and url"
# An https:// registry needs a trust store: with none, nothing is trusted,
# so the manifest is refused before any connection -- never downgraded.
rapp remhttps "pubkey = \"$PUB\"" "https://127.0.0.1:$PORT"
expect_fail remhttps "names no ca"

# ── the same registry over https, fetched and then built ──────────────
# A registry published to disk, served over TLS by `resid-pkg serve --cert
# --key` itself, pulled one artifact at a time by tools/resid-fetch.resid, and
# then resolved by resid-manifest from the fetched directory. The signatures
# and hashes are checked exactly where they always were: what the fetch adds
# is transport authentication, nothing more.
"$PKG" serve "$W/reghttp" --cert "$ROOT/tests/tls/fixtures/srv.pem" --key "$ROOT/tests/tls/fixtures/srv.key" \
    --port 0 --port-file "$W/tlsport" > "$W/https.out" 2>&1 &
SRVS="$SRVS $!"
TLSI=0
while [ ! -s "$W/tlsport" ] && [ $TLSI -lt 150 ]; do sleep 0.1; TLSI=$((TLSI + 1)); done
TLSPORT="$(cat "$W/tlsport" 2>/dev/null)"
if [ -n "$TLSPORT" ]; then
    mkdir -p "$W/regtls/pkg"
    ok_tls=1
    for a in index.resid-idx index.resid-sig greet-1.0.0.resid-pkg greet-1.0.0.resid-sha256 greet-1.0.0.resid-sig; do
        timeout 120 "$FETCH" "https://localhost:$TLSPORT" "$ROOT/tests/tls/fixtures/srvca.pem" \
            "/pkg/$a" "$W/regtls/pkg/$a" > "$W/fetch-$a.out" 2>&1 || { ok_tls=0; break; }
    done
    if [ "$ok_tls" = 1 ] && cmp -s "$W/reghttp/pkg/index.resid-idx" "$W/regtls/pkg/index.resid-idx" \
        && cmp -s "$W/reghttp/pkg/greet-1.0.0.resid-pkg" "$W/regtls/pkg/greet-1.0.0.resid-pkg" \
        && cmp -s "$W/reghttp/pkg/greet-1.0.0.resid-sig" "$W/regtls/pkg/greet-1.0.0.resid-sig"; then ok
    else bad "resid-fetch over https: $(cat "$W"/fetch-*.out 2>/dev/null | tr '\n' ' ' | tail -c 200)"; fi

    # And the fetched directory is a working registry: the same app, the same
    # pubkey, resolved from bytes that arrived over TLS.
    mkdir -p "$W/tlsdep/src"
    printf '[package]\nname = "tlsdep"\nversion = "0.1.0"\n\n[registry]\npath = "../regtls"\npubkey = "%s"\n\n[dependencies.greet]\nversion = "1.0.0"\n' "$PUB" > "$W/tlsdep/resid.toml"
    printf 'import "greet";\nInt main() { println(greet()); return 0; }\n' > "$W/tlsdep/src/main.resid"
    deps tlsdep
    [ $? -eq 0 ] && ok || bad "resolve from a registry fetched over https: $(tail -1 "$W/tlsdep.out")"

    # A name the certificate does not carry: refused before any byte is
    # trusted, and the tool says which name failed.
    timeout 120 "$FETCH" "https://localhost:$TLSPORT" "$ROOT/tests/tls/fixtures/srvca.pem" \
        "/pkg/index.resid-idx" "$W/regtls/pkg/index.resid-idx" > "$W/fetch_ok.out" 2>&1
    timeout 120 "$FETCH" "https://localhost:$TLSPORT" "$ROOT/tests/tls/fixtures/other.pem" \
        "/pkg/index.resid-idx" "$W/regtls/pkg/index.resid-idx" > "$W/fetch_badca.out" 2>&1
    if grep -q "not trusted" "$W/fetch_badca.out"; then ok
    else bad "a trust store without the issuer: $(tail -1 "$W/fetch_badca.out")"; fi

    # No store at all is a refusal, never a downgrade to plaintext.
    timeout 120 "$FETCH" "https://localhost:$TLSPORT" "" "/pkg/index.resid-idx" \
        "$W/regtls/pkg/index.resid-idx" > "$W/fetch_nostore.out" 2>&1
    grep -q "trusts nothing" "$W/fetch_nostore.out" && ok \
        || bad "no trust store: $(tail -1 "$W/fetch_nostore.out")"

    # resid-manifest reaches the TLS registry itself: url, ca, the same pubkey.
    rapp tlsdirect $'pubkey = "'"$PUB"$'"\nca = "'"$ROOT/tests/tls/fixtures/srvca.pem"'"' "https://localhost:$TLSPORT"
    expect_ok tlsdirect
    # A trust store without the issuer: refused, and it says so.
    rapp tlsbadca $'pubkey = "'"$PUB"$'"\nca = "'"$ROOT/tests/tls/fixtures/other.pem"'"' "https://localhost:$TLSPORT"
    expect_fail tlsbadca "not trusted"
else bad "the https registry server did not report a port: $(tail -2 "$W/https.out")"; fi
# A server that trickles a byte every half second never trips the 30 s
# per-read timeout; the fetch's own deadline (--timeout) ends it.
if command -v python3 > /dev/null 2>&1; then
    rm -f "$W/trickle.port"
    python3 - "$W/trickle.port" <<'PY' &
import socket, sys, time, threading
l = socket.socket(); l.bind(("127.0.0.1", 0)); l.listen(4)
open(sys.argv[1], "w").write(str(l.getsockname()[1]))
def drip(c):
    try:
        for _ in range(60):
            c.sendall(b"\x16"); time.sleep(0.5)
    except OSError:
        pass
while True:
    c, _ = l.accept()
    threading.Thread(target=drip, args=(c,), daemon=True).start()
PY
    DRIP=$!
    for _ in $(seq 1 100); do [ -s "$W/trickle.port" ] && break; sleep 0.05; done
    T0=$(date +%s)
    timeout 60 "$FETCH" --timeout 2 "https://localhost:$(cat "$W/trickle.port")" "$ROOT/tests/tls/fixtures/srvca.pem" \
        "/x" "$W/trickle.out" > "$W/fetch_trickle.out" 2>&1
    RC=$?; T1=$(date +%s)
    [ "$RC" = 1 ] && [ $((T1 - T0)) -le 6 ] && ok \
        || bad "a trickling server is cut off by the fetch deadline: rc $RC after $((T1 - T0)) s: $(tail -1 "$W/fetch_trickle.out")"
    kill "$DRIP" 2>/dev/null; wait "$DRIP" 2>/dev/null
fi
# A TLS registry is refused at startup, not on every handshake, when its
# key and certificate are half given or do not belong together.
"$PKG" serve "$W/reghttp" --cert "$ROOT/tests/tls/fixtures/srv.pem" --port 0 > "$W/serve_half.out" 2>&1
[ $? = 2 ] && grep -q "go together" "$W/serve_half.out" && ok || bad "serve --cert without --key: $(tail -1 "$W/serve_half.out")"
"$PKG" serve "$W/reghttp" --cert "$ROOT/tests/tls/fixtures/srv.pem" --key "$ROOT/tests/tls/fixtures/srved.key" --port 0 > "$W/serve_mismatch.out" 2>&1
[ $? = 2 ] && grep -q "does not carry the key" "$W/serve_mismatch.out" && ok || bad "serve with a key the certificate does not carry: $(tail -1 "$W/serve_mismatch.out")"
grep -q "listening on https://127.0.0.1:" "$W/https.out" && ok || bad "serve --cert --key says https: $(head -1 "$W/https.out")"
# Nothing listening at all: a transport failure, not a fetch of nothing.
rapp remdead "pubkey = \"$PUB\"" "http://127.0.0.1:1"
expect_fail remdead "cannot connect to registry host"

# A package whose sources are not valid UTF-8. The archive is binary, so a
# Str round trip over the transport would corrupt it; the extracted sources
# must come back byte-identical to what was published.
mkdir -p "$W/binpkg/src"
printf '[package]\nname = "binpkg"\nversion = "1.0.0"\n' > "$W/binpkg/resid.toml"
printf '// raw byte \377\376\375\200 in a comment\npub Str b() { return "b"; }\n' > "$W/binpkg/src/main.resid"
"$PKG" publish "$W/binpkg" "$W/regbin" "$W/pub.sec" > /dev/null
BPORT="$(serve "$W/regbin")"
BURL="http://127.0.0.1:$BPORT"
mkdir -p "$W/rembin/src"
printf '[package]\nname = "rembin"\nversion = "0.1.0"\n\n[registry]\nurl = "%s"\npubkey = "%s"\n\n[dependencies.binpkg]\nversion = "1.0.0"\n' "$BURL" "$PUB" > "$W/rembin/resid.toml"
printf 'import "binpkg";\nInt main() { return 0; }\n' > "$W/rembin/src/main.resid"
deps rembin
if [ $? -eq 0 ] && cmp -s "$W/binpkg/src/main.resid" "$W/rembin/target/resid/deps/binpkg-1.0.0-"*/src/main.resid; then ok; else bad "remote archive is byte-identical after extraction"; fi

# A path dependency pinned to a key: its sources must be what was signed.
mkpkg "$W/local" local 1.0.0 'pub Str local_name() { return "local"; }'
"$PKG" sign-dir "$W/local" "$W/pub.sec" > /dev/null
mkdir -p "$W/pathapp/src"
printf '[package]\nname = "pathapp"\nversion = "0.1.0"\n\n[dependencies.local]\npath = "../local"\npubkey = "%s"\n' "$PUB" > "$W/pathapp/resid.toml"
expect_ok pathapp
printf '// changed\n' >> "$W/local/src/main.resid"
expect_fail pathapp "sources differ from what was signed"

# A package's root documents are packed and signed with its sources;
# other Markdown, and documents below the root, are not.
mkpkg "$W/docd" docd 1.0.0 'pub Str docd_name() { return "docd"; }'
printf '# docd\n' > "$W/docd/README.md"; printf 'MIT\n' > "$W/docd/LICENSE"
printf 'n\n' > "$W/docd/NOTES.md"; mkdir -p "$W/docd/src/more"; printf 'n\n' > "$W/docd/src/more/README.md"
"$PKG" pack "$W/docd" "$W/docd_arch" > /dev/null
mkdir -p "$W/docd_x"; "$PKG" extract "$W/docd_arch" "$W/docd_x" > /dev/null
if [ -f "$W/docd_x/README.md" ] && [ -f "$W/docd_x/LICENSE" ] && [ ! -e "$W/docd_x/NOTES.md" ] && [ ! -e "$W/docd_x/src/more/README.md" ]; then ok; else bad "root documents packed: $(cd "$W/docd_x" && find . -type f | sort | tr '\n' ' ')"; fi
"$PKG" sign-dir "$W/docd" "$W/pub.sec" > /dev/null
mkdir -p "$W/docapp/src"
printf '[package]\nname = "docapp"\nversion = "0.1.0"\n\n[dependencies.docd]\npath = "../docd"\npubkey = "%s"\n' "$PUB" > "$W/docapp/resid.toml"
printf 'import "docd";\nInt main() { return 0; }\n' > "$W/docapp/src/main.resid"
expect_ok docapp
printf 'changed\n' >> "$W/docd/README.md"
expect_fail docapp "sources differ from what was signed"

# Extraction never writes outside the target directory.
python3 - "$W/trav.resid-pkg" <<'PY'
import struct, sys
entries = [(b"../escaped.resid", b"x"), (b"/abs.resid", b"y"), (b"ok.resid", b"z")]
out = b"RESIDPKG1" + struct.pack("<I", len(entries))
for p, c in entries:
    out += struct.pack("<H", len(p)) + p + struct.pack("<Q", len(c)) + c
open(sys.argv[1], "wb").write(out)
PY
mkdir -p "$W/x/in"
"$PKG" extract "$W/trav" "$W/x/in" > /dev/null
if [ -f "$W/x/in/ok.resid" ] && [ ! -e "$W/x/escaped.resid" ] && [ ! -e /abs.resid ]; then ok; else bad "extract path traversal"; fi

# The manifest ceiling bounds a dependency's code (spec §21.1).
mkpkg "$W/reader" reader 1.0.0 $'@requires(filesystem(readonly))\npub Bool etc_exists() { return filesystem.exists("/etc"); }'
mkdir -p "$W/ceil/src"
printf '[package]\nname = "ceil"\nversion = "0.1.0"\n\n[capabilities]\ngrant = ["filesystem"]\n\n[dependencies.reader]\npath = "../reader"\ncapabilities = []\n' > "$W/ceil/resid.toml"
printf 'import "reader";\n@requires(filesystem(readonly))\nInt main() { if (etc_exists()) { println("yes"); } return 0; }\n' > "$W/ceil/src/main.resid"
(cd "$ROOT" && "$MAN" build "$W/ceil/resid.toml" "$COMPILER") > "$W/ceil.out" 2>&1
if [ $? -ne 0 ] && grep -q "E0212" "$W/ceil.out"; then ok; else bad "ceiling not enforced: $(grep -m1 -i error "$W/ceil.out")"; fi
sed -i 's/capabilities = \[\]/capabilities = ["filesystem(readonly)"]/' "$W/ceil/resid.toml"
(cd "$ROOT" && "$MAN" build "$W/ceil/resid.toml" "$COMPILER") > "$W/ceil2.out" 2>&1
if [ $? -eq 0 ] && [ "$("$W/ceil/target/resid/ceil")" = yes ]; then ok; else bad "ceiling grant: $(grep -m1 -i error "$W/ceil2.out")"; fi

# `resid-manifest test` resolves dependencies, writes the depmap, then hands
# discovery to the driver's own `test` mode (SPEC-testing.md §7.1).
mkpkg "$W/mathlib" mathlib 1.0.0 'pub Int triple(Int a) { return a * 3; }'
mkdir -p "$W/tsuite/src"
printf '[package]\nname = "tsuite"\nversion = "0.1.0"\n\n[dependencies.mathlib]\npath = "../mathlib"\ncapabilities = []\n' > "$W/tsuite/resid.toml"
printf 'import "mathlib";\nInt main() { return 0; }\n' > "$W/tsuite/src/main.resid"
printf 'test "arithmetic" {\n    expect(2 + 2).toEqual(4);\n}\n' > "$W/tsuite/src/math_test.resid"
printf 'test "strings" {\n    expect("resid").toHaveLength(5);\n}\n' > "$W/tsuite/src/str_test.resid"
printf 'import "mathlib";\ntest "a bare dependency import resolves in a test file" {\n    expect(triple(5)).toEqual(15);\n}\n' > "$W/tsuite/src/dep_test.resid"
(cd "$ROOT" && "$MAN" test "$W/tsuite/resid.toml" "$COMPILER") > "$W/tsuite.out" 2>&1
if [ $? -eq 0 ] && grep -q "3 file/s passed, 0 failed, 0 did not compile" "$W/tsuite.out"; then ok; else bad "manifest test: $(tail -3 "$W/tsuite.out" | tr '\n' '|')"; fi

# A failing test fails only its own file; the rest still run, exit is 1.
printf 'test "arithmetic" {\n    expect(2 + 2).toEqual(5);\n}\n' > "$W/tsuite/src/math_test.resid"
(cd "$ROOT" && "$MAN" test "$W/tsuite/resid.toml" "$COMPILER") > "$W/tsuite2.out" 2>&1
rc=$?
if [ $rc -eq 1 ] && grep -q "2 file/s passed, 1 failed, 0 did not compile" "$W/tsuite2.out" && grep -q "a bare dependency import resolves" "$W/tsuite2.out"; then ok; else bad "manifest test failure isolation (rc $rc)"; fi

# `residc test` with no file discovers and runs a whole tree (SPEC-testing.md
# §7.1 "Run all tests"). It needs the depmap, as any build does: one of these
# files imports a dependency by bare name.
printf 'test "arithmetic" {\n    expect(2 + 2).toEqual(4);\n}\n' > "$W/tsuite/src/math_test.resid"
(cd "$W/tsuite/src" && "$COMPILER" test -depmap "$W/tsuite/target/resid/depmap.txt") > "$W/drv1.out" 2>&1
rc=$?
if [ $rc -eq 0 ] && grep -q "3 file/s passed, 0 failed, 0 did not compile" "$W/drv1.out"; then ok; else bad "driver bare test: $(tail -3 "$W/drv1.out" | tr '\n' '|')"; fi
(cd "$W/tsuite/src" && "$COMPILER" test math_test.resid) >/dev/null 2>&1
[ $? -eq 0 ] && ok || bad "driver single test file, passing"
printf 'test "arithmetic" {\n    expect(2 + 2).toEqual(5);\n}\n' > "$W/tsuite/src/math_test.resid"
(cd "$W/tsuite/src" && "$COMPILER" test math_test.resid) >/dev/null 2>&1
[ $? -eq 1 ] && ok || bad "driver single test file, assertion failure must exit 1"
printf 'test "nope" {\n    expect(1).toEqual("str");\n}\n' > "$W/tsuite/src/broken_test.resid"
(cd "$W/tsuite/src" && "$COMPILER" test broken_test.resid) >/dev/null 2>&1
[ $? -eq 2 ] && ok || bad "driver single test file, compile error must exit 2 (not 1)"
# A plain (non-test) compile error keeps its own status.
"$COMPILER" "$W/tsuite/src/broken_test.resid" -o "$W/plain" >/dev/null 2>&1
[ $? -eq 1 ] && ok || bad "non-test compile error must stay 1"
rm -f "$W/tsuite/src/broken_test.resid"

# A test file that does not compile is counted apart from a failing one, and
# §7.2 makes the compile error dominate: exit 2, not 1. Its own package, so
# the check does not depend on the state the steps above left behind.
mkdir -p "$W/badpkg/src"
printf '[package]\nname = "badpkg"\nversion = "0.1.0"\n' > "$W/badpkg/resid.toml"
printf 'Int main() { return 0; }\n' > "$W/badpkg/src/main.resid"
printf 'test "fine" {\n    expect(1).toEqual(1);\n}\n' > "$W/badpkg/src/ok_test.resid"
printf 'test "does not compile" {\n    expect(1).toEqual("str");\n}\n' > "$W/badpkg/src/broken_test.resid"
(cd "$ROOT" && "$MAN" test "$W/badpkg/resid.toml" "$COMPILER") > "$W/tsuite3.out" 2>&1
rc=$?
if [ $rc -eq 2 ] && grep -q "1 file/s passed, 0 failed, 1 did not compile" "$W/tsuite3.out" && grep -q "E0001" "$W/tsuite3.out"; then ok; else bad "manifest test compile error (rc $rc): $(tail -3 "$W/tsuite3.out" | tr '\n' '|')"; fi

# A package with no test files succeeds and says so.
mkdir -p "$W/notest/src"
printf '[package]\nname = "notest"\nversion = "0.1.0"\n' > "$W/notest/resid.toml"
printf 'Int main() { return 0; }\n' > "$W/notest/src/main.resid"
(cd "$ROOT" && "$MAN" test "$W/notest/resid.toml" "$COMPILER") > "$W/notest.out" 2>&1
if [ $? -eq 0 ] && grep -q "no test files" "$W/notest.out"; then ok; else bad "manifest test with no tests: $(tail -2 "$W/notest.out" | tr '\n' '|')"; fi

# `target` is build output, not source: a test file there is not run.
mkdir -p "$W/tsuite/target/resid"
printf 'test "not a real test" {\n    expect(1).toEqual(2);\n}\n' > "$W/tsuite/target/resid/stale_test.resid"
(cd "$ROOT" && "$MAN" test "$W/tsuite/resid.toml" "$COMPILER") > "$W/tsuite4.out" 2>&1
if grep -q "stale_test" "$W/tsuite4.out"; then bad "manifest test walked target/"; else ok; fi
rm -rf "$W/tsuite/target"

# process.run splits its command on byte 32 and execs the words directly, so a
# path with a space is refused rather than silently split into two arguments.
mkdir -p "$W/sp ace/src"
printf '[package]\nname = "sp"\nversion = "0.1.0"\n' > "$W/sp ace/resid.toml"
printf 'Int main() { return 0; }\n' > "$W/sp ace/src/main.resid"
printf 'test "t" {\n    expect(1).toEqual(1);\n}\n' > "$W/sp ace/src/a_test.resid"
(cd "$ROOT" && "$MAN" test "$W/sp ace/resid.toml" "$COMPILER") > "$W/sp.out" 2>&1
rc=$?
if [ $rc -eq 2 ] && grep -q "contains a space" "$W/sp.out"; then ok; else bad "space in package path not refused (rc $rc)"; fi
(cd "$ROOT" && "$COMPILER" test --root "$W/sp ace/src") > "$W/sp2.out" 2>&1
rc=$?
if [ $rc -eq 2 ] && grep -q "contains a space" "$W/sp2.out"; then ok; else bad "space in --root not refused (rc $rc)"; fi
(cd "$ROOT" && "$COMPILER" "$W/sp ace/src/a_test.resid" -o "$W/sp ace/out") > "$W/sp3.out" 2>&1
rc=$?
if [ $rc -eq 2 ] && grep -q "contains a space" "$W/sp3.out"; then ok; else bad "space in -o not refused (rc $rc)"; fi

# ── registry v2: authenticated upload ─────────────────────────────────
# `serve --upload <keyring> --index-key <key>` takes a PUT of a signed
# archive. A publisher key in the keyring may publish; any other is
# refused; a version is never replaced; the index is re-signed by the
# registry's own key, which is what a client pins.
mkdir -p "$W/upkr" "$W/upreg"
"$PKG" keygen "$W/idx.sec" "$W/idx.pub" > /dev/null
cp "$W/pub.pub" "$W/upkr/alice.pub"
"$PKG" serve "$W/upreg" --port 0 --port-file "$W/upport" --upload "$W/upkr" --index-key "$W/idx.sec" > "$W/upserve.out" 2>&1 &
SRVS="$SRVS $!"
for _ in $(seq 1 150); do [ -s "$W/upport" ] && break; sleep 0.1; done
UPURL="http://127.0.0.1:$(cat "$W/upport" 2>/dev/null)"
"$PKG" upload "$W/greet" "$UPURL" "$W/pub.sec" > "$W/up1.out" 2>&1
[ $? = 0 ] && grep -q "published greet 1.0.0" "$W/up1.out" && ok || bad "upload by a keyring key: $(tail -1 "$W/up1.out")"
"$PKG" upload "$W/greet" "$UPURL" "$W/pub.sec" > "$W/up2.out" 2>&1
[ $? = 0 ] && grep -q "already published" "$W/up2.out" && ok || bad "the same archive again: $(tail -1 "$W/up2.out")"
"$PKG" upload "$W/greet" "$UPURL" "$W/other.sec" > "$W/up3.out" 2>&1
[ $? != 0 ] && grep -q "403" "$W/up3.out" && ok || bad "upload by a key outside the keyring: $(tail -1 "$W/up3.out")"
mkpkg "$W/greet2" greet 1.0.0 'pub Str greet() { return "changed"; }'
"$PKG" upload "$W/greet2" "$UPURL" "$W/pub.sec" > "$W/up4.out" 2>&1
[ $? != 0 ] && grep -q "409" "$W/up4.out" && ok || bad "a published version replaced: $(tail -1 "$W/up4.out")"
"$PKG" index verify "$W/upreg" "$(cat "$W/idx.pub")" > "$W/upidx.out" 2>&1
[ $? = 0 ] && grep -q "1 entries" "$W/upidx.out" && ok || bad "index after upload: $(tail -1 "$W/upidx.out")"
# A client pinning the registry's index key builds from what was uploaded.
rapp upapp "pubkey = \"$(cat "$W/idx.pub")\"" "$UPURL"
expect_ok upapp
# Uploads are opt-in: a plain server refuses PUT.
"$PKG" upload "$W/greet" "http://127.0.0.1:$PORT" "$W/pub.sec" > "$W/up5.out" 2>&1
[ $? != 0 ] && grep -q "405" "$W/up5.out" && ok || bad "PUT to a read-only server: $(tail -1 "$W/up5.out")"
# The flags go together.
"$PKG" serve "$W/upreg" --port 0 --upload "$W/upkr" > "$W/uphalf.out" 2>&1
[ $? = 2 ] && grep -q "go together" "$W/uphalf.out" && ok || bad "serve --upload without --index-key: $(tail -1 "$W/uphalf.out")"
# Over TLS too: the upload checks the server against --ca.
"$PKG" serve "$W/upreg" --port 0 --port-file "$W/uptlsport" --upload "$W/upkr" --index-key "$W/idx.sec" \
    --cert "$ROOT/tests/tls/fixtures/srv.pem" --key "$ROOT/tests/tls/fixtures/srv.key" > "$W/uptls.out" 2>&1 &
SRVS="$SRVS $!"
for _ in $(seq 1 150); do [ -s "$W/uptlsport" ] && break; sleep 0.1; done
mkpkg "$W/greet3" greet 1.1.0 'pub Str greet() { return "hi again"; }'
"$PKG" upload "$W/greet3" "https://localhost:$(cat "$W/uptlsport" 2>/dev/null)" "$W/pub.sec" --ca "$ROOT/tests/tls/fixtures/srvca.pem" > "$W/up6.out" 2>&1
[ $? = 0 ] && grep -q "published greet 1.1.0" "$W/up6.out" && ok || bad "upload over TLS: $(tail -1 "$W/up6.out")"
"$PKG" upload "$W/greet3" "https://localhost:$(cat "$W/uptlsport" 2>/dev/null)" "$W/pub.sec" > "$W/up7.out" 2>&1
[ $? != 0 ] && grep -q "needs --ca" "$W/up7.out" && ok || bad "upload over TLS without a trust store: $(tail -1 "$W/up7.out")"

echo "pkg: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
