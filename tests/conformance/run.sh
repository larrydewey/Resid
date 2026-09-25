#!/usr/bin/env bash
# Spec-conformance suite for the self-hosted compiler.
#
# Usage: tests/conformance/run.sh [-c COMPILER] [-j JOBS] [FILTER...]
#
#   COMPILER defaults to build/boot/stage2.bin (built by ./boot.sh).
#   FILTER is a substring match on case names; no filter runs everything.
#
# Case layout (tests/conformance/cases/):
#   NAME.resid     the program (files starting with `_` are helper modules,
#                  not cases)
#   NAME.out       expected stdout of the built binary (exact match, after
#                  @TMP@ substitution)
#   NAME.exit      expected exit code of the binary (default 0)
#   NAME.fail      marker: compilation must FAIL
#   NAME.compile   lines that must each appear (substring) in the compiler's
#                  combined stdout/stderr
#   NAME.args      extra compiler arguments
#   NAME.nobin     marker: compilation must succeed without producing a binary
#
# Each case is compiled in a fresh temp dir holding lib/*.resid and the helper
# modules, so `import "crypto.resid"` and `import "_mod_a.resid"` resolve. The
# token @TMP@ in a case source is replaced with that temp dir, and
# @TMP@/in.txt is pre-created containing "hi".
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CASES="$ROOT/tests/conformance/cases"
COMPILER="$ROOT/build/boot/stage2.bin"
COMPILER_SUBCMD="${COMPILER_SUBCMD:-}"
JOBS="$(nproc 2>/dev/null || echo 4)"
while getopts "c:j:" opt; do
    case "$opt" in
        c) COMPILER="$(realpath "$OPTARG")" ;;
        j) JOBS="$OPTARG" ;;
        *) exit 2 ;;
    esac
done
shift $((OPTIND - 1))
[ -x "$COMPILER" ] || { echo "compiler not found: $COMPILER (run ./boot.sh)"; exit 2; }
export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

run_case() {
    local name="$1" dir="$WORK/$1" src
    mkdir -p "$dir"
    cp "$ROOT"/lib/*.resid "$dir"/ 2>/dev/null
    cp "$CASES"/_*.resid "$dir"/ 2>/dev/null
    echo hi > "$dir/in.txt"
    sed "s#@TMP@#$dir#g" "$CASES/$name.resid" > "$dir/$name.resid"
    local args=""
    [ -f "$CASES/$name.args" ] && args="$(cat "$CASES/$name.args")"
    # The compiler resolves runtime/resid_rt.c relative to the cwd.
    (cd "$ROOT" && timeout 600 "$COMPILER" "$dir/$name.resid" ${COMPILER_SUBCMD:-} -o "$dir/bin" $args) \
        > "$dir/compile.log" 2>&1
    local crc=$?
    local why=""
    if [ -f "$CASES/$name.compile" ]; then
        while IFS= read -r line; do
            [ -z "$line" ] && continue
            grep -qF -- "$line" "$dir/compile.log" || why="compiler output lacks '$line'"
        done < "$CASES/$name.compile"
    fi
    if [ -f "$CASES/$name.fail" ]; then
        [ "$crc" -ne 0 ] || why="expected compile failure, got success"
    elif [ "$crc" -ne 0 ]; then
        why="compile failed: $(grep -m1 -i error "$dir/compile.log" | cut -c1-160)"
    elif [ -f "$CASES/$name.nobin" ]; then
        [ -e "$dir/bin" ] && why="expected no binary"
    else
        (cd "$dir" && timeout 60 ./bin > "$dir/stdout" 2> "$dir/stderr")
        local rrc=$?
        local want_rc=0
        [ -f "$CASES/$name.exit" ] && want_rc="$(cat "$CASES/$name.exit")"
        if [ "$rrc" -ne "$want_rc" ]; then
            why="${why:+$why; }exit $rrc, want $want_rc"
        fi
        [ -f "$CASES/$name.out" ] && sed "s#@TMP@#$dir#g" "$CASES/$name.out" > "$dir/want"
        if [ -f "$CASES/$name.out" ] && ! cmp -s "$dir/stdout" "$dir/want"; then
            why="${why:+$why; }stdout differs: got '$(head -c 120 "$dir/stdout" | tr '\n' '|')'"
        fi
    fi
    if [ -z "$why" ]; then
        echo "PASS $name"
    else
        echo "FAIL $name: $why"
    fi
}
export -f run_case
export ROOT CASES COMPILER WORK COMPILER_SUBCMD

names=()
for f in "$CASES"/*.resid; do
    n="$(basename "$f" .resid)"
    case "$n" in _*) continue ;; esac
    if [ "$#" -gt 0 ]; then
        hit=0
        for pat in "$@"; do [[ "$n" == *"$pat"* ]] && hit=1; done
        [ "$hit" -eq 1 ] || continue
    fi
    names+=("$n")
done

results="$(printf '%s\n' "${names[@]}" | xargs -P "$JOBS" -I{} bash -c 'run_case {}' | sort)"
echo "$results"
pass=$(grep -c '^PASS' <<< "$results")
fail=$(grep -c '^FAIL' <<< "$results")
echo "---"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
