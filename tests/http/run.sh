#!/usr/bin/env bash
# HTTP server tests: lib/httpserv.resid against clients in the same process
# (roundtrip.resid) and, with python3, examples/http_server.resid driven
# over real sockets by several concurrent clients (client.py).
set -uo pipefail
cd "$(dirname "$0")"
ROOT="$(cd ../.. && pwd)"
COMPILER="${COMPILER:-$ROOT/build/boot/stage2.bin}"
W="$(mktemp -d)"; trap 'rm -rf "$W"; kill $(jobs -p) 2>/dev/null' EXIT
pass=0; fail=0
ok() { pass=$((pass + 1)); }
bad() { fail=$((fail + 1)); echo "FAIL $1"; }

# One process: a worker region serves, main is the client.
if (cd "$ROOT" && "$COMPILER" tests/http/roundtrip.resid -o "$W/rt") > "$W/rt.log" 2>&1 \
    && timeout 60 "$W/rt" > "$W/rt.out" 2>&1 && cmp -s "$W/rt.out" roundtrip.out; then ok
else bad "roundtrip: $(grep -m1 -i error "$W/rt.log") $(diff "$W/rt.out" roundtrip.out 2>/dev/null | head -4 | tr '\n' ' ')"; fi

# The example server over real sockets, from python3 clients.
if command -v python3 > /dev/null; then
    if (cd "$ROOT" && "$COMPILER" examples/http_server.resid -o "$W/srv") > "$W/srv.log" 2>&1; then
        mkdir -p "$W/root/sub"; printf 'file body\n' > "$W/root/a.txt"; printf '<p>hi</p>' > "$W/root/sub/i.html"
        "$W/srv" --port 0 --workers 3 --root "$W/root" --port-file "$W/port" > "$W/srv.out" 2>&1 &
        SRV=$!
        for _ in $(seq 1 100); do [ -s "$W/port" ] && break; sleep 0.05; done
        if [ -s "$W/port" ] && python3 client.py "$(cat "$W/port")" > "$W/client.out" 2>&1; then ok
        else bad "client.py: $(tail -3 "$W/client.out" | tr '\n' ' ')"; fi
        kill $SRV 2>/dev/null; wait $SRV 2>/dev/null
    else bad "http_server did not compile: $(grep -m1 -i error "$W/srv.log")"; fi
fi
echo "http: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
