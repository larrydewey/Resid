#!/usr/bin/env bash
# lib/regex.resid, and the runtime's matcher behind toMatch and --filter,
# against Go's regexp (RE2), the reference for their semantics.
# Skipped when go is not installed. Usage: tests/regex/run.sh [-c COMPILER] [CASES]
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
COMPILER="$ROOT/build/boot/stage2.bin"
[ "${1:-}" = "-c" ] && { COMPILER="$(realpath "$2")"; shift 2; }
CASES="${1:-2000}"
if ! command -v go >/dev/null; then echo "regex: go not installed, skipped"; exit 0; fi
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"
cp "$ROOT/tests/regex/fuzz.resid" "$ROOT/tests/regex/tomatch.resid" "$ROOT/lib/regex.resid" "$WORK/"
(cd "$WORK" && "$COMPILER" fuzz.resid -o fuzz --profile debug >build.log 2>&1) || { tail -5 "$WORK/build.log"; exit 1; }
(cd "$WORK" && "$COMPILER" tomatch.resid -o tomatch --profile debug >build2.log 2>&1) || { tail -5 "$WORK/build2.log"; exit 1; }
mkdir -p "$WORK/goref" && cp "$ROOT/tests/regex/goref.go" "$WORK/goref/main.go"
(cd "$WORK/goref" && go mod init goref >/dev/null 2>&1 && GOFLAGS=-mod=mod go build -o ../goref.bin . ) || exit 1
mkdir -p "$WORK/gomatch" && cp "$ROOT/tests/regex/gomatch.go" "$WORK/gomatch/main.go"
(cd "$WORK/gomatch" && go mod init gomatch >/dev/null 2>&1 && GOFLAGS=-mod=mod go build -o ../gomatch.bin . ) || exit 1
rc=0
for seed in 1 2 3; do python3 "$ROOT/tests/regex/fuzz.py" "$WORK/fuzz" "$WORK/goref.bin" "$seed" "$CASES" || rc=1; done
python3 "$ROOT/tests/regex/fuzz.py" "$WORK/tomatch" "$WORK/gomatch.bin" 4 "$CASES" match || rc=1
exit $rc
