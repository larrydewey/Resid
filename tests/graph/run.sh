#!/usr/bin/env bash
# Knowledge graph (PLAN-graph-ir G1): every in-repo program parses into the
# graph and prints back to the same token stream, and none mixes operators
# whose grouping the pre-v3.5 precedence table got wrong.
#
# Usage: tests/graph/run.sh [-c compiler]
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
cd "$ROOT"

pass=0
fail=0
for f in examples/driver.resid lib/*.resid tools/*.resid examples/*.resid tests/conformance/cases/*.resid tests/reduce/cases/*.resid bench/suite/src/*/*/resid/*.resid; do
    [ -f "$f" ] || continue
    # Cases that must fail to compile may be unparseable; the precedence
    # case mixes operators on purpose.
    case "$f" in
        tests/conformance/cases/err_assignment.resid|tests/conformance/cases/err_list_missing_comma.resid) continue ;;
    esac
    want_lint="graph-lint: 0 mixed-precedence expression(s)"
    case "$f" in *operator_precedence_*|*logical_short_circuit*) want_lint="$("$COMPILER" "$f" --graph-lint 2>&1 | grep '^graph-lint' | tail -1)" ;; esac
    rt="$("$COMPILER" "$f" --graph-check 2>&1 | grep '^graph' | tail -1)"
    lint="$("$COMPILER" "$f" --graph-lint 2>&1 | grep '^graph-lint' | tail -1)"
    res="$("$COMPILER" "$f" --graph-resolve 2>&1 | grep '^graph-resolve' | tail -1)"
    # Every checked expression gets a type (programs that type-check).
    tys="$("$COMPILER" "$f" --graph-types 2>&1 | grep '^graph-types' | tail -1)"
    tys_ok=1
    case "$tys" in "graph-types: "*" untyped"*) [[ "$tys" == "graph-types: 0 untyped"* ]] || tys_ok=0 ;; esac
    if [ "$rt" = "graph: ok" ] && [ "$lint" = "$want_lint" ] && [ "${res##*, }" = "0 unresolved" ] && [ "$tys_ok" = 1 ]; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
        echo "FAIL $f: $rt / $lint / $res / $tys"
    fi
done
# Resolution must reject every out-of-scope use in the scopes case.
got="$("$COMPILER" tests/graph/cases/resolve_scopes.resid --graph-resolve 2>&1 | grep -E ':11: |^graph-resolve' | sed 's/.*:11: //' | tr '\n' ' ')"
if [ "$got" = "q v i z inner nope graph-resolve: 34 uses, 6 unresolved " ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1))
    echo "FAIL resolve_scopes: $got"
fi
# Golden type column: node types and def edges of a sample program.
TT="$(mktemp)"
"$COMPILER" tests/graph/cases/types_sample.resid --graph-types "$TT" >/dev/null 2>&1
if grep -v " SourceLoc\| RegionError\|message\| line \| col \| file " "$TT" | cmp -s - tests/graph/cases/types_sample.types; then
    pass=$((pass + 1))
else
    fail=$((fail + 1))
    echo "FAIL types_sample: type column differs"
fi
rm -f "$TT"

# Type-checker cases: each program's first diagnostic must contain the
# expected text.
CK="$(mktemp -d)"
trap 'rm -rf "$CK"' EXIT
awk -v d="$CK" '/^#/ && !name { next } /^=== / { name = $2; getline want; print want > (d "/" name ".want"); next } name { print > (d "/" name ".resid") }' tests/graph/check_cases.txt
for w in "$CK"/*.want; do
    c="${w%.want}.resid"
    want="$(cat "$w")"
    got="$("$COMPILER" "$c" --profile check 2>&1 | grep -E 'error|check: ok' | head -1)"
    if [[ "$got" == *"$want"* ]]; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
        echo "FAIL check case $(basename "$c" .resid): want '$want', got '$got'"
    fi
done
# Graph reduction (examples/greduce.resid) must token-match the text
# reducer on every program that type-checks.
for f in examples/driver.resid tests/reduce/cases/*.resid tests/conformance/cases/*.resid bench/suite/src/*/*/resid/*.resid; do
    got="$("$COMPILER" "$f" --graph-reduce-check 2>&1 | grep -E '^graph-reduce|^error' | head -1)"
    case "$got" in
        "graph-reduce: ok"*) pass=$((pass + 1)) ;;
        "error"*|"") ;;
        *) fail=$((fail + 1)); echo "FAIL graph-reduce $f: $got" ;;
    esac
done
# Signatures and leaf functions from the graph (lw_sigs) must equal those
# collected from the printed residual.
for f in examples/driver.resid tests/reduce/cases/*.resid tests/conformance/cases/*.resid bench/suite/src/*/*/resid/*.resid; do
    got="$("$COMPILER" "$f" -o /tmp/resid_gsig_$$ --graph-sigs-check 2>&1 | grep -E '^graph-sigs|^error' | head -1)"
    case "$got" in
        "graph-sigs: ok"*) pass=$((pass + 1)) ;;
        "error"*|"") ;;
        *) fail=$((fail + 1)); echo "FAIL graph-sigs $f: $got" ;;
    esac
done
rm -f /tmp/resid_gsig_$$*
# Debug builds describe functions, parameters and bindings in DWARF; with
# gdb present, a breakpoint shows them.
DB="$CK/dbg"
if "$COMPILER" tests/graph/cases/debug_locals.resid -o "$DB" --profile debug >/dev/null 2>&1 \
    && grep -q 'DILocalVariable(name: "msg"' "$DB.ll" && grep -q 'DILocalVariable(name: "acc", arg: 1' "$DB.ll"; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL debug_locals: no DILocalVariable for a binding or parameter"
fi
if command -v gdb >/dev/null 2>&1 && [ -x "$DB" ]; then
    got="$(gdb -batch -ex 'break debug_locals.resid:5' -ex run -ex 'info locals' -ex 'info args' "$DB" 2>&1)"
    if [[ "$got" == *"m = 16"* && "$got" == *'msg = '*'"hi!"'* && "$got" == *'tag = '*'"hi"'* ]]; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL debug_locals under gdb"
    fi
fi
# Residual notes are projected from the graph: the rt value and the
# provider call, not the comment or string mentioning them.
got="$("$COMPILER" tests/graph/cases/notes_sample.resid -o "$CK/notes" 2>&1 | grep 'residual note')"
if [[ "$got" == *"notes: 2 residual"* ]]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL notes_sample: $got"
fi
# resid-why answers from the graph artifact: a provider call's line.
if "$COMPILER" tools/resid-why.resid -o "$CK/why" >/dev/null 2>&1 \
    && "$COMPILER" tests/graph/cases/notes_sample.resid -o "$CK/ns" --profile debug >/dev/null 2>&1; then
    got="$("$CK/why" "$CK/ns" --at notes_sample.resid:4 2>&1)"
    if [[ "$got" == *"mcall: Int effect, effect(args.count)"* ]]; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL resid-why --at: $got"
    fi
else
    fail=$((fail + 1)); echo "FAIL resid-why build"
fi
# resid-graph draws a node's neighbourhood as DOT from the artifact.
if "$COMPILER" tools/resid-graph.resid -o "$CK/rg" >/dev/null 2>&1; then
    got="$("$CK/rg" "$CK/ns" --node 0 --depth 1 2>&1)"
    if [[ "$got" == "digraph kg {"* && "$got" == *"n0 [label="* ]]; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL resid-graph --node: $got"
    fi
else
    fail=$((fail + 1)); echo "FAIL resid-graph build"
fi
# The §3.4 invariants hold on debug builds' graphs.
for c in tests/graph/cases/debug_locals.resid tests/graph/cases/notes_sample.resid tests/conformance/cases/range_facts_discharge.resid tests/reduce/cases/*.resid; do
    b="$CK/inv_$(basename "$c" .resid)"
    "$COMPILER" "$c" -o "$b" --profile debug >/dev/null 2>&1 || continue
    [ -f "$b.resid-graph.cbor" ] || continue
    got="$("$CK/rg" "$b" --check 2>&1 | tail -1)"
    if [[ "$got" == *" 0 violation(s)"* ]]; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL graph check $c: $got"
    fi
done
echo "graph: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
