#!/usr/bin/env bash
# The settlement ledger, the crown example (examples/ledger.resid and
# examples/ledger_core.resid): exact Dec(4) money, named behaviors, a
# generic total, compile-time-folded posting rules, an untrusted native fee
# schedule, signed provenance, and the knowledge graph explaining what
# stayed residual.
#
# Usage: tests/ledger/run.sh [-c compiler]
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
COMPILER="$ROOT/build/boot/stage2.bin"
while getopts "c:" opt; do
    case "$opt" in
        c) COMPILER="$(realpath "$OPTARG")" ;;
        *) exit 2 ;;
    esac
done
[ -x "$COMPILER" ] || { echo "compiler not found: $COMPILER (run ./boot.sh)"; exit 2; }
export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"

CORE="$ROOT/examples/ledger_core.resid"
LEDGER="$ROOT/examples/ledger.resid"
FEE_LL="$ROOT/examples/ledger/fees.ll"
NAT="fees=$FEE_LL"

# fees.ll is generated, not committed (like tests/conformance/native/tiny.ll).
if [ ! -f "$FEE_LL" ]; then
    if command -v clang >/dev/null; then
        "$ROOT/examples/ledger/build.sh"
    else
        echo "ledger: skipped (no fees.ll and no clang to build it)"
        exit 0
    fi
fi

T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT
cd "$T"
unset RESID_SIGNING_KEY RESID_VERIFY_PUB

pass=0
fail=0
check() { # check <name> <expected-rc> <grep-pattern> <cmd...>
    local name="$1" want="$2" pat="$3"
    shift 3
    out="$("$@" 2>&1)"
    rc=$?
    if [ "$rc" -eq "$want" ] && echo "$out" | grep -q -- "$pat"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
        echo "FAIL $name (rc $rc, want $want): $(echo "$out" | tail -2 | tr '\n' ' ')"
    fi
}

# ── The inline tests in the library half ────────────────────────────────
# A file with `main` cannot be run through `residc test`, so the tests
# live in ledger_core.resid and the program imports it.
check "library tests (5)" 0 "Passed: 5" "$COMPILER" test "$CORE" -native "$NAT"
check "library tests: exact money" 0 "money is exact" "$COMPILER" test "$CORE" -native "$NAT"
check "library tests: untrusted native" 0 "untrusted native input" "$COMPILER" test "$CORE" -native "$NAT"

# ── The program: reduction, then the residual work ──────────────────────
check "build folds the rule schedule" 0 "comptime_print\] 100" "$COMPILER" "$LEDGER" -o ledger --profile debug -native "$NAT"
check "build folds a second schedule use" 0 "comptime_print\] 75" "$COMPILER" "$LEDGER" -o ledger --profile debug -native "$NAT"
[ -x ./ledger ] || { echo "FAIL ledger did not build"; fail=$((fail + 1)); }

check "demo balances" 0 "balanced: true" ./ledger
check "demo total is exact" 0 "total posted: 57.64" ./ledger
check "net by account" 0 "cash  -52.34" ./ledger
check "report agrees with the demo" 0 "balanced: true" ./ledger report
check "balance command" 0 "total posted: 57.64" ./ledger balance
check "post a residual entry" 0 "wire: checking <- cash 250.0" ./ledger post wire cash checking 250.00
check "post runs the native fee schedule" 0 "escrow fee (class 2): 2.500" ./ledger post wire cash checking 250.00 2
check "post refuses an unknown account" 2 "unknown account: escrow" ./ledger post wire cash escrow 1.00
check "post needs its arguments" 2 "usage: ledger post" ./ledger post wire
check "help" 0 "usage: ledger" ./ledger help

# ── What stayed residual, and why (the knowledge graph) ────────────────
check "explain reads the notes sidecar" 0 "residual note(s) remain" ./ledger explain
"$COMPILER" "$ROOT/tools/resid-why.resid" -o why --profile debug >/dev/null 2>&1
if [ -x ./why ]; then
    check "resid-why summarizes the residual" 0 "residual summary:" ./why ./ledger --summary
    check "resid-why attributes a provider call" 0 "provider-call" ./why ./ledger --summary
else
    echo "skip: resid-why did not build"
fi

# ── Signed provenance ──────────────────────────────────────────────────
check "keygen" 0 "wrote k/resid-ed25519.key" "$COMPILER" keygen k
export RESID_SIGNING_KEY="$T/k/resid-ed25519.key"
export RESID_VERIFY_PUB="$(cat k/resid-ed25519.pub)"
check "release build is signed" 0 "provenance: signed" "$COMPILER" "$LEDGER" -o ledger.rel -native "$NAT"
check "release runs" 0 "balanced: true" ./ledger.rel
check "verify re-derives the build" 0 "verify: ok" "$COMPILER" verify ledger.rel
check "the grant names the native fee schedule" 0 "grant \[args, filesystem(readonly), native_fees\]" "$COMPILER" verify ledger.rel
check "the native artifact is attested" 0 "native module fees from an artifact" "$COMPILER" verify ledger.rel
check "signed debug build carries the graph" 0 "provenance: signed" "$COMPILER" "$LEDGER" -o ledger.dbg --profile debug -native "$NAT"
check "the graph's capabilities stay inside the grant" 0 "within the grant" "$COMPILER" verify ledger.dbg
cp ledger.rel ledger.tam; printf '\x01' | dd of=ledger.tam bs=1 seek=100 count=1 conv=notrunc 2>/dev/null
check "a tampered release fails to verify" 1 "code hash mismatch" "$COMPILER" verify ledger.tam

echo "ledger: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
