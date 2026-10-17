#!/usr/bin/env bash
# Differential suite for --ownership (PLAN-ownership-ir.md, phase 2).
#
# Usage: tests/own/run.sh [-c COMPILER] [-q]
#
#   1. conformance: every case compiled with --ownership on must match its
#      expected output, as it does with the default;
#   2. AWFY: the harness built with --ownership on must verify every
#      benchmark (it aborts on a wrong result);
#   3. self-compile: a compiler built with --ownership on must compile the
#      compiler to the same IR as the plain compiler does.
#
# -q skips step 3 (two self-compiles, about two minutes).
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
COMPILER="$ROOT/build/boot/stage2.bin"
QUICK=0
while getopts "c:q" opt; do
    case "$opt" in
        c) COMPILER="$(realpath "$OPTARG")" ;;
        q) QUICK=1 ;;
        *) exit 2 ;;
    esac
done
export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"
if [ -z "${RESID_SIGNING_KEY:-}" ] && [ -f "$HOME/.resid/keys/resid-ed25519.key" ]; then
    export RESID_SIGNING_KEY="$HOME/.resid/keys/resid-ed25519.key"
fi
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
pass=0
fail=0
ok()  { echo "PASS $1"; pass=$((pass + 1)); }
bad() { echo "FAIL $1"; fail=$((fail + 1)); }

# 1. Conformance through a wrapper that adds the flag.
printf '#!/usr/bin/env bash\nexec "%s" "$@" --ownership on\n' "$COMPILER" > "$TMP/on.sh"
chmod +x "$TMP/on.sh"
if "$ROOT/tests/conformance/run.sh" -c "$TMP/on.sh" > "$TMP/conf.log" 2>&1; then
    ok "conformance with --ownership on ($(tail -1 "$TMP/conf.log"))"
else
    bad "conformance with --ownership on"
    grep '^FAIL' "$TMP/conf.log" | head -20
fi

# 2. AWFY, every benchmark at its ReBench size (several verify only there).
AW="$ROOT/bench/v2/t1-awfy/resid"
if (cd "$ROOT" && "$COMPILER" "$AW/harness.resid" -o "$TMP/harness" -O2 --ownership on > "$TMP/aw.log" 2>&1); then
    for bn in Bounce:1500 CD:250 DeltaBlue:12000 Havlak:1500 Json:100 List:1500 Mandelbrot:500 NBody:250000 Permute:1000 Queens:1000 Richards:100 Sieve:3000 Storage:1000 Towers:600; do
        b="${bn%%:*}"
        if "$TMP/harness" "$b" 1 "${bn##*:}" > "$TMP/run.log" 2>&1 && grep -q 'Total Runtime' "$TMP/run.log"; then
            ok "awfy $b"
        else
            bad "awfy $b"
        fi
    done
else
    bad "awfy harness build"
fi

# 3. The compiler itself.
if [ "$QUICK" = 0 ]; then
    if (cd "$ROOT" && "$COMPILER" "$ROOT/compiler/driver.resid" -o "$TMP/c_on" --runtime-internals --ownership on > "$TMP/c1.log" 2>&1) \
        && (cd "$ROOT" && "$TMP/c_on" "$ROOT/compiler/driver.resid" -o "$TMP/c_on2" --runtime-internals > "$TMP/c2.log" 2>&1) \
        && (cd "$ROOT" && "$COMPILER" "$ROOT/compiler/driver.resid" -o "$TMP/c_off" --runtime-internals > "$TMP/c3.log" 2>&1) \
        && cmp -s "$TMP/c_on2.ll" "$TMP/c_off.ll"; then
        ok "self-compile by a compiler built with --ownership on"
    else
        bad "self-compile by a compiler built with --ownership on"
    fi
fi

echo "---"
echo "own: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
