#!/usr/bin/env bash
# Constant-time checks (ctgrind): every operation that handles a secret,
# run on the optimized binary under valgrind memcheck with the secret
# marked undefined (ct_secret). memcheck then reports any branch, select
# or memory address that depends on it -- including ones the compiler or
# LLVM introduced, which is the point of checking the binary rather than
# the source. Results are declassified with ct_public before printing.
#
# The cases come from the knowledge graph (PLAN-secret-type.md §7 step 3),
# not from a list here: every function named ct_case_<name> in
# ctprobe.resid and secretprobe.resid is case <name> (underscores to
# dashes). Before anything runs, a coverage gate (tools/resid-ctcover.resid)
# lists the library's secret surface -- every function under lib/ whose
# signature carries a Secret, every generic one that runs on secrets, and
# every one that declassifies -- from the graph of a program importing all
# of lib/, and fails when one of them is reached by no case (at a Secret
# instantiation, for a generic one) and is not listed with a reason in
# uncovered.txt. A listed function that a case now reaches, or that no
# longer handles a secret, fails too, as does a case that reaches no
# library function and handles no secret of its own. The gate runs with
# or without valgrind.
#
# A case passes when memcheck reports nothing and its output matches the
# same binary run natively. The valgrind runs are skipped (not failed)
# when valgrind is not installed.
#
# Usage: tests/ct/run.sh [-c COMPILER]
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
trap 'rm -rf "$W"' EXIT
export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"
cd "$ROOT"

build() { # build <log> <compiler args...>
    local log="$1"; shift
    "$COMPILER" "$@" > "$log" 2>&1 || { echo "FAIL build $*"; grep -i -A3 error "$log" | head -8; exit 1; }
}

# ── The coverage gate ──────────────────────────────────────────────────
build "$W/b.ctcover" tools/resid-ctcover.resid -o "$W/ctcover"
{ for f in lib/*.resid; do echo "import \"$ROOT/$f\";"; done; echo 'Int main() { return 0; }'; } > "$W/surface.resid"
build "$W/b.surface" "$W/surface.resid" --profile check -o "$W/surface"
"$W/ctcover" "$W/surface" surface > "$W/surface.txt" || { echo "FAIL ct surface: no secret functions found"; exit 1; }
PROBES="ctprobe secretprobe"
for p in $PROBES; do
    build "$W/b.$p.g" "tests/ct/$p.resid" --profile check -o "$W/$p.g"
    "$W/ctcover" "$W/$p.g" cases ct_case_ > "$W/$p.cases" || { echo "FAIL ct cases: $p has no ct_case_ functions"; exit 1; }
done
fail=0
# Library functions some case reaches (generic ones at a Secret type).
cat "$W"/*.cases | awk '$1 == "reach" && $5 != "public" { print $3 " " $4 }' | sort -u > "$W/covered"
awk '{ print $1 " " $2 }' "$W/surface.txt" | sort -u > "$W/secret"
grep -v '^#' tests/ct/uncovered.txt | awk 'NF >= 3 { print $1 " " $2 }' | sort -u > "$W/waived"
while read -r f n; do
    why="$(awk -v f="$f" -v n="$n" '$1 == f && $2 == n { print $3 }' "$W/surface.txt")"
    echo "FAIL ct coverage: $f $n handles a secret ($why) and no case reaches it: add a ct_case_ to tests/ct/secretprobe.resid (or a reason to tests/ct/uncovered.txt)"
    fail=$((fail + 1))
done < <(comm -23 "$W/secret" "$W/covered" | comm -23 - "$W/waived")
while read -r f n; do
    echo "FAIL ct coverage: stale tests/ct/uncovered.txt entry $f $n: a case reaches it now"
    fail=$((fail + 1))
done < <(comm -12 "$W/waived" "$W/covered")
while read -r f n; do
    echo "FAIL ct coverage: stale tests/ct/uncovered.txt entry $f $n: not a secret function"
    fail=$((fail + 1))
done < <(comm -23 "$W/waived" "$W/secret")
for p in $PROBES; do
    while read -r c; do
        echo "FAIL ct coverage: stale case $p ${c//_/-}: reaches no library function and handles no secret"
        fail=$((fail + 1))
    done < <(awk '$1 == "case" { s[$2] = $3; r[$2] += 0 } $1 == "reach" { r[$2]++ } END { for (c in s) if (s[c] == 0 && r[c] == 0) print c }' "$W/$p.cases" | sort)
done
nsec="$(wc -l < "$W/secret")"
ncov="$(comm -12 "$W/secret" "$W/covered" | wc -l)"
nwaived="$(wc -l < "$W/waived")"
ncases="$(cat "$W"/*.cases | grep -c '^case ')"
echo "ct coverage: $nsec secret library functions, $ncov reached by $ncases cases, $nwaived listed uncovered"
[ "$fail" -eq 0 ] || { echo "ct: coverage gate failed ($fail)"; exit 1; }

# ── The valgrind runs ──────────────────────────────────────────────────
if ! command -v valgrind > /dev/null; then
    echo "ct: valgrind runs skipped (valgrind not installed)"
    exit 0
fi
pass=0
for p in $PROBES; do
    build "$W/b.$p" "tests/ct/$p.resid" -o "$W/$p"
    for c in $(awk '$1 == "case" { gsub("_", "-", $2); print $2 }' "$W/$p.cases"); do
        want="$("$W/$p" "$c" 2>&1)"; st=$?
        got="$(valgrind -q --error-limit=no --expensive-definedness-checks=yes --log-file="$W/vg.$p.$c" "$W/$p" "$c" 2>&1)"
        n="$(grep -c -E 'depends on uninitialised|Use of uninitialised' "$W/vg.$p.$c")"
        if [ "$n" = 0 ] && [ "$st" = 0 ] && [ "$got" = "$want" ] && [ "${want#"$c "}" != "$want" ]; then
            pass=$((pass + 1))
        else
            fail=$((fail + 1))
            echo "FAIL $c: $n secret-dependent branch(es) or address(es)"
            grep -A3 -E 'depends on uninitialised|Use of uninitialised' "$W/vg.$p.$c" | head -8
            [ "$st" = 0 ] && [ "${want#"$c "}" != "$want" ] || echo "  native run: exit $st: $want"
            [ "$got" = "$want" ] || echo "  output differs under valgrind: $got"
        fi
    done
done
# The control must be caught, or the checks above prove nothing.
valgrind -q --error-limit=no --expensive-definedness-checks=yes --log-file="$W/vg.control" "$W/ctprobe" control > /dev/null 2>&1
if [ "$(grep -c -E 'depends on uninitialised|Use of uninitialised' "$W/vg.control")" -gt 0 ]; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL control: a secret-indexed load went unreported"
fi
echo "ct: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
