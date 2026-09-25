#!/usr/bin/env bash
# Compile-time reduction suite (spec §36, examples/reduce.resid).
#
# Usage: tests/reduce/run.sh [-c COMPILER] [FILTER...]
#
# For each tests/reduce/cases/NAME.resid:
#   - compiled normally and with --no-reduce; both binaries must produce the
#     same stdout and exit code (reduction never changes behavior), and that
#     stdout must equal NAME.out;
#   - NAME.expect (optional) holds lines checked against the reduced `main`
#     (from `Int main()` to the end of the --dump-reduced source):
#     `has: TEXT` must occur, `lacks: TEXT` must not;
#   - NAME.compile (optional) holds lines that must appear in the compiler's
#     output (e.g. comptime_print reports).
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CASES="$ROOT/tests/reduce/cases"
COMPILER="$ROOT/build/boot/stage2.bin"
while getopts "c:" opt; do
    case "$opt" in
        c) COMPILER="$(realpath "$OPTARG")" ;;
        *) exit 2 ;;
    esac
done
shift $((OPTIND - 1))
[ -x "$COMPILER" ] || { echo "compiler not found: $COMPILER (run ./boot.sh)"; exit 2; }
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
pass=0; fail=0
for f in "$CASES"/*.resid; do
    n="$(basename "$f" .resid)"
    if [ "$#" -gt 0 ]; then
        hit=0; for pat in "$@"; do [[ "$n" == *"$pat"* ]] && hit=1; done
        [ "$hit" -eq 1 ] || continue
    fi
    d="$WORK/$n"; mkdir -p "$d"; cp "$f" "$d/$n.resid"
    why=""
    (cd "$ROOT" && timeout 600 "$COMPILER" "$d/$n.resid" -o "$d/red" --dump-reduced "$d/reduced.resid") > "$d/c1.log" 2>&1 || why="compile failed: $(grep -m1 -i error "$d/c1.log")"
    (cd "$ROOT" && timeout 600 "$COMPILER" "$d/$n.resid" -o "$d/plain" --no-reduce) > "$d/c2.log" 2>&1 || why="${why:-compile (--no-reduce) failed: $(grep -m1 -i error "$d/c2.log")}"
    if [ -z "$why" ]; then
        (cd "$d" && timeout 60 ./red > out.red 2>/dev/null); xr=$?
        (cd "$d" && timeout 60 ./plain > out.plain 2>/dev/null); xp=$?
        [ "$xr" -eq "$xp" ] || why="exit differs: reduced $xr, unreduced $xp"
        cmp -s "$d/out.red" "$d/out.plain" || why="${why:+$why; }stdout differs from --no-reduce"
        if [ -f "$CASES/$n.out" ] && ! cmp -s "$d/out.red" "$CASES/$n.out"; then
            why="${why:+$why; }stdout differs from $n.out"
        fi
        sed -n '/^Int main()/,$p' "$d/reduced.resid" > "$d/main.resid"
        if [ -f "$CASES/$n.expect" ]; then
            while IFS= read -r line; do
                case "$line" in
                    "has: "*) grep -qF -- "${line#has: }" "$d/main.resid" || why="${why:+$why; }reduced main lacks '${line#has: }'" ;;
                    "lacks: "*) grep -qF -- "${line#lacks: }" "$d/main.resid" && why="${why:+$why; }reduced main still has '${line#lacks: }'" ;;
                esac
            done < "$CASES/$n.expect"
        fi
        if [ -f "$CASES/$n.compile" ]; then
            while IFS= read -r line; do
                [ -z "$line" ] && continue
                grep -qF -- "$line" "$d/c1.log" || why="${why:+$why; }compiler output lacks '$line'"
            done < "$CASES/$n.compile"
        fi
    fi
    if [ -z "$why" ]; then echo "PASS $n"; pass=$((pass + 1)); else echo "FAIL $n: $why"; fail=$((fail + 1)); fi
done
echo "---"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
