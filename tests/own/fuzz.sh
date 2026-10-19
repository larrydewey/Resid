#!/usr/bin/env bash
# Ownership differential fuzzing: tests/own/fuzz.sh [-c COMPILER] FROM TO
# Each seed's program (tests/own/gen.py) is built with --no-ownership and
# with the default (ownership on); the outputs must agree. Prints each
# disagreeing seed and a summary.
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
FROM="${1:-0}"
TO="${2:-99}"
export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"
if [ -z "${RESID_SIGNING_KEY:-}" ] && [ -f "$HOME/.resid/keys/resid-ed25519.key" ]; then
    export RESID_SIGNING_KEY="$HOME/.resid/keys/resid-ed25519.key"
fi
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
one() {
    local s="$1" d="$TMP/$1"
    mkdir -p "$d"
    python3 -I "$ROOT/tests/own/gen.py" "$s" > "$d/p.resid"
    if ! "$COMPILER" "$d/p.resid" -o "$d/off" --no-ownership > "$d/off.log" 2>&1; then echo "SKIP $s (does not compile)"; return; fi
    if ! "$COMPILER" "$d/p.resid" -o "$d/on" > "$d/on.log" 2>&1; then echo "FAIL $s (ownership build fails)"; return; fi
    "$d/off" > "$d/off.out" 2>&1
    "$d/on" > "$d/on.out" 2>&1
    if cmp -s "$d/off.out" "$d/on.out"; then echo "PASS $s"; else echo "FAIL $s"; cp "$d/p.resid" "/tmp/own-fuzz-fail-$s.resid" 2>/dev/null; fi
}
export -f one
export ROOT COMPILER TMP
seq "$FROM" "$TO" | xargs -P "$(nproc)" -I{} bash -c 'one {}' > "$TMP/res.txt"
grep -v '^PASS' "$TMP/res.txt" | sort -V
echo "fuzz: $(grep -c '^PASS' "$TMP/res.txt") passed, $(grep -c '^FAIL' "$TMP/res.txt") failed, $(grep -c '^SKIP' "$TMP/res.txt") skipped"
