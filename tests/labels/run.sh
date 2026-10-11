#!/usr/bin/env bash
# Integrity labels and layout types (PLAN-labels.md phases 1-2): each case is built with
# `--profile check`, then `resid-why --label` answers the queries in
# NAME.query (one per line); the combined output must equal NAME.out.
# The source table is also checked against the checker's builtin list.
#
# Usage: tests/labels/run.sh [-c COMPILER] [FILTER]
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
export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"
if [ -z "${RESID_SIGNING_KEY:-}" ] && [ ! -f "$ROOT/keys/resid-ed25519.key" ]; then
    KEYDIR="$(mktemp -d)"
    "$COMPILER" keygen "$KEYDIR" >/dev/null && export RESID_SIGNING_KEY="$KEYDIR/resid-ed25519.key"
fi
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
pass=0; fail=0

# Every builtin the checker knows has a label entry: compile one call of
# each through the table's own predicate is not possible from outside, so
# the names are compared textually against compiler/labels.resid.
names=$(awk '/^ERes check_builtin/,/^}/' "$ROOT/compiler/typecheck.resid" | grep -o 'name == "[a-z_0-9A-Z]*"' | sed 's/name == "\(.*\)"/\1/' | sort -u)
missing=""
for n in $names; do
    if ! grep -q "\"$n\"" "$ROOT/compiler/labels.resid"; then
        case "$n" in
            str_*|resid_fmt_*|resid_chal_*|resid_tcp_*|resid_term_*|resid_dbg_*|resid_disp_*|resid_clock_*|resid_device_*|resid_cpu_has_*|ct_*|aesni_*|checked_*|wrapping_*|saturating_*) ;;
            *) missing="$missing $n" ;;
        esac
    fi
done
if [ -z "$missing" ]; then pass=$((pass + 1)); echo "ok   source-table"; else fail=$((fail + 1)); echo "FAIL source-table: no entry for$missing"; fi

# c_abi layouts against clang, for both targets (skipped without clang).
if command -v clang >/dev/null 2>&1; then
    c="$WORK/cabi"; mkdir -p "$c"; cp "$ROOT/tests/labels/cabi/layouts.resid" "$c/"
    if ( cd "$c" && "$COMPILER" layouts.resid --profile debug -o layouts > build.log 2>&1 && ./layouts > resid.txt ); then
        for tgt in x86_64-linux-gnu aarch64-linux-gnu; do
            clang -target "$tgt" -S -emit-llvm -O0 "$ROOT/tests/labels/cabi/layouts.c" -o "$c/$tgt.ll" 2>/dev/null
            sed -n 's/^@\([A-Za-z0-9]*\) = .*\[\(.*\)\], align.*/\1 \2/p' "$c/$tgt.ll" | sed 's/i64 //g; s/,//g' > "$c/$tgt.txt"
            if diff "$c/$tgt.txt" "$c/resid.txt" > "$c/$tgt.diff"; then pass=$((pass + 1)); echo "ok   c_abi $tgt"; else fail=$((fail + 1)); echo "FAIL c_abi $tgt"; cat "$c/$tgt.diff"; fi
        done
    else
        fail=$((fail + 1)); echo "FAIL c_abi (build)"; head -5 "$c/build.log"
    fi
fi

# Generated layout parsers against the hand parsers they replace (§7.3).
TW="$ROOT/lib/dev/tpm_wire.resid"; [ -d "$RESID_HOME/lib/dev" ] && TW="$RESID_HOME/lib/dev/tpm_wire.resid"
if ( cd "$WORK" && "$COMPILER" test "$TW" -o "$WORK/tw.testbin" > oracle.log 2>&1 ); then pass=$((pass + 1)); echo "ok   layout oracle (tpm_wire)"; else fail=$((fail + 1)); echo "FAIL layout oracle (tpm_wire)"; tail -5 "$WORK/oracle.log"; fi

"$COMPILER" "$ROOT/tools/resid-why.resid" --profile debug -o "$WORK/why" >/dev/null 2>&1 || { echo "FAIL building resid-why"; exit 1; }
for src in "$ROOT"/tests/labels/cases/*.resid; do
    name="$(basename "$src" .resid)"
    [ -n "$FILTER" ] && [[ "$name" != *"$FILTER"* ]] && continue
    d="$WORK/$name"; mkdir -p "$d"; cp "$src" "$d/"
    ( cd "$d" && "$COMPILER" "$name.resid" --profile check -o "$name" > build.log 2>&1 )
    # NAME.warn: built (debug, so it is reduced); every line of the file
    # must appear in the output and nothing else may warn E0270.
    if [ -f "${src%.resid}.warn" ]; then
        ( cd "$d" && "$COMPILER" "$name.resid" --profile debug -o "$name" > build.log 2>&1 )
        want=$(grep -c . "${src%.resid}.warn"); got=$(grep -c 'warning\[E027[09]\]' "$d/build.log")
        hits=0; [ "$want" -gt 0 ] && hits=$(grep -F -f "${src%.resid}.warn" "$d/build.log" | wc -l)
        if [ -x "$d/$name" ] && [ "$hits" -ge "$want" ] && [ "$got" -eq "$want" ]; then pass=$((pass + 1)); echo "ok   $name"; else fail=$((fail + 1)); echo "FAIL $name (want $want E0270 warnings, got $got)"; grep -A1 'warning\[E0270\]\|rror\[' "$d/build.log" | head -20; fi
        continue
    fi
    if [ -f "${src%.resid}.fail" ]; then
        if grep -qF -f "${src%.resid}.fail" "$d/build.log"; then pass=$((pass + 1)); echo "ok   $name"; else fail=$((fail + 1)); echo "FAIL $name (expected refusal)"; cat "$d/build.log" | head -5; fi
        continue
    fi
    : > "$d/got"
    while IFS= read -r q; do
        [ -z "$q" ] && continue
        ( cd "$d" && "$WORK/why" "$name" --label "$q" >> got 2>&1 )
    done < "${src%.resid}.query"
    if diff -u "${src%.resid}.out" "$d/got" > "$d/diff"; then pass=$((pass + 1)); echo "ok   $name"; else fail=$((fail + 1)); echo "FAIL $name"; head -30 "$d/diff"; fi
done
echo "labels: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
