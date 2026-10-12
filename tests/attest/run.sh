#!/usr/bin/env bash
# Attestation (PLAN-attestation.md): lib/verify/ against real and test
# evidence, and the compiler's checks of anchors, primitives, policies and
# decisions. Runs in a private RESID_HOME whose lib/verify/ also holds the
# test anchors (fixtures/testing.resid); fixtures come from
# gen_fixtures.py (a test chain) and go-sev-guest (a real Milan report).
#
# Each cases/NAME.resid with NAME.fail must be refused with that text;
# without one it must build. Each run/NAME.resid is built and run, and its
# output must equal run/NAME.out.
#
# Usage: tests/attest/run.sh [-c COMPILER] [FILTER]
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
COMPILER="$ROOT/build/boot/stage2.bin"
while getopts "c:" opt; do
    case "$opt" in
        c) COMPILER="$(realpath "$OPTARG")" ;;
        *) exit 2 ;;
    esac
done
shift $((OPTIND - 1))
FILTER="${1:-}"
BOOT="${RESID_HOME:-$ROOT/build/boot}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
H="$WORK/home"; mkdir -p "$H"
cp -r "$ROOT/lib" "$H/lib"
cp "$ROOT/tests/attest/fixtures/testing.resid" "$H/lib/verify/"
cp "$BOOT/rt.ll" "$H/" 2>/dev/null || cp "$ROOT/build/boot/rt.ll" "$H/"
[ -f "$BOOT/rt-aarch64.ll" ] && cp "$BOOT/rt-aarch64.ll" "$H/"
export RESID_HOME="$H"
pass=0; fail=0

# The cases are independent: check them in parallel, then read the logs.
JOBS="${RESID_TEST_JOBS:-4}"
for src in "$ROOT"/tests/attest/cases/*.resid; do
    name="$(basename "$src" .resid)"
    [ -n "$FILTER" ] && [[ "$name" != *"$FILTER"* ]] && continue
    d="$WORK/c-$name"; mkdir -p "$d"; cp "$src" "$d/"
    while [ "$(jobs -rp | wc -l)" -ge "$JOBS" ]; do sleep 0.2; done
    ( cd "$d" && "$COMPILER" "$name.resid" --profile check --verify-lib-dev -o "$name" > build.log 2>&1; echo $? > status ) &
done
wait
for src in "$ROOT"/tests/attest/cases/*.resid; do
    name="$(basename "$src" .resid)"
    [ -n "$FILTER" ] && [[ "$name" != *"$FILTER"* ]] && continue
    d="$WORK/c-$name"
    st=$(cat "$d/status" 2>/dev/null || echo 99)
    if [ -f "${src%.resid}.warn" ]; then
        want=$(grep -c . "${src%.resid}.warn"); got=$(grep -c 'warning\[E029[12]\]' "$d/build.log")
        hits=0; [ "$want" -gt 0 ] && hits=$(grep -F -f "${src%.resid}.warn" "$d/build.log" | wc -l)
        if [ $st -eq 0 ] && [ "$hits" -ge "$want" ] && [ "$got" -eq "$want" ]; then pass=$((pass + 1)); echo "ok   $name"; else fail=$((fail + 1)); echo "FAIL $name (want $want E0291/E0292 warnings, got $got)"; grep -v '^OK' "$d/build.log" | grep -A1 'warning\|error' | head -8; fi
        continue
    fi
    if [ -f "${src%.resid}.fail" ]; then
        if [ $st -ne 0 ] && grep -qF -f "${src%.resid}.fail" "$d/build.log"; then pass=$((pass + 1)); echo "ok   $name"; else fail=$((fail + 1)); echo "FAIL $name (expected $(cat "${src%.resid}.fail"))"; grep -v '^OK' "$d/build.log" | head -6; fi
    else
        if [ $st -eq 0 ]; then pass=$((pass + 1)); echo "ok   $name"; else fail=$((fail + 1)); echo "FAIL $name (expected to build)"; grep -v '^OK' "$d/build.log" | head -6; fi
    fi
done

for src in "$ROOT"/tests/attest/run/*.resid; do
    name="$(basename "$src" .resid)"
    [ -n "$FILTER" ] && [[ "$name" != *"$FILTER"* ]] && continue
    d="$WORK/r-$name"; mkdir -p "$d"; cp "$src" "$d/"; cp -r "$ROOT/tests/attest/fixtures" "$d/"; cp -r "$ROOT/tests/tls/fixtures" "$d/tlsfx"
    if ( cd "$d" && "$COMPILER" "$name.resid" --profile debug --verify-lib-dev -o "$name" > build.log 2>&1 ) && ( cd "$d" && ./"$name" > got 2>&1 ) && diff "${src%.resid}.out" "$d/got" > "$d/diff"; then
        pass=$((pass + 1)); echo "ok   $name"
    else
        fail=$((fail + 1)); echo "FAIL $name"; grep -v '^OK' "$d/build.log" | grep -i error | head -5; cat "$d/diff" 2>/dev/null | head -10
        # RESID_ATTEST_GOT=DIR keeps each failing run's whole output there.
        [ -n "${RESID_ATTEST_GOT:-}" ] && [ -f "$d/got" ] && cp "$d/got" "$RESID_ATTEST_GOT/$name.out"
    fi
done

# A decision in a release build (its own profile: the checks need the
# def column there too).
if [ -z "$FILTER" ] || [[ "release" == *"$FILTER"* ]]; then
    d="$WORK/release"; mkdir -p "$d"; cp "$ROOT/tests/attest/run/key_broker.resid" "$d/"; cp -r "$ROOT/tests/attest/fixtures" "$d/"
    KEYDIR="$WORK/keys"; mkdir -p "$KEYDIR"; "$COMPILER" keygen "$KEYDIR" > /dev/null 2>&1
    if ( cd "$d" && RESID_SIGNING_KEY="$KEYDIR/resid-ed25519.key" "$COMPILER" key_broker.resid --verify-lib-dev -o key_broker > build.log 2>&1 ) && ( cd "$d" && ./key_broker > got 2>&1 ) && diff "$ROOT/tests/attest/run/key_broker.out" "$d/got" > /dev/null; then
        pass=$((pass + 1)); echo "ok   release (key_broker)"
        # The provenance record lists the anchors, policy and decision.
        ( cd "$d" && "$COMPILER" verify key_broker --pub "$(cat "$KEYDIR/resid-ed25519.pub")" > verify.log 2>&1 )
        if grep -q "attestation: anchor std:test_ark kind AmdVcek(Milan)" "$d/verify.log" && grep -q "attestation: decides app:release accept \[test_snp_roots\]" "$d/verify.log" && grep -q "attestation: trust std:test_snp_roots anchors \[test_ark, test_ark_vlek\]" "$d/verify.log" && grep -q "attestation: policy app:release_policy" "$d/verify.log" && grep -q "attestation: verify-lib-dev" "$d/verify.log"; then
            pass=$((pass + 1)); echo "ok   residc verify lists the decisions"
        else
            fail=$((fail + 1)); echo "FAIL residc verify lists the decisions"; grep "attestation\|verify:" "$d/verify.log" | head -8
        fi
    else
        fail=$((fail + 1)); echo "FAIL release (key_broker)"; grep -v '^OK' "$d/build.log" | grep -i 'error' | head -5
    fi
fi

# The verify closure is pinned (E0290): the private home's lib/verify/
# holds a file the compiler was not released with.
if [ -z "$FILTER" ] || [[ "pins" == *"$FILTER"* ]]; then
    d="$WORK/pins"; mkdir -p "$d"; cp "$ROOT/tests/attest/run/snp_real.resid" "$d/"
    if ( cd "$d" && ! "$COMPILER" snp_real.resid --profile check -o x > build.log 2>&1 ) && grep -q 'error\[E0290\]' "$d/build.log"; then pass=$((pass + 1)); echo "ok   pins (unpinned file refused)"; else fail=$((fail + 1)); echo "FAIL pins (expected E0290)"; grep -v '^OK' "$d/build.log" | head -3; fi
    # The pins match this checkout (tools/attest/verify_pins.py --check).
    if command -v python3 >/dev/null 2>&1; then
        if python3 "$ROOT/tools/attest/verify_pins.py" > "$d/pins.log" 2>&1; then pass=$((pass + 1)); echo "ok   pins (current)"; else fail=$((fail + 1)); echo "FAIL pins: $(cat "$d/pins.log")"; fi
    fi
fi

echo "attest: $pass passed, $fail failed"
[ $fail -eq 0 ]
