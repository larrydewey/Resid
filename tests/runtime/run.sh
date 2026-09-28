#!/usr/bin/env bash
# Runtime unit tests: each C file links the Resid runtime (build/boot/rt.ll)
# and checks one property directly (immediate boxes, the capability guard, UTF-8 bounds);
# term/ checks buffered stdin and lib/readline.resid on a pty;
# rt/primitives.resid checks the runtime primitives; and lib/ and tools/
# must not use any compiler internal.
set -uo pipefail
cd "$(dirname "$0")"
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT
pass=0; fail=0
ROOT="$(cd ../.. && pwd)"
for t in *.c; do
    n="${t%.c}"
    # With the Resid runtime's IR: part of the runtime lives there.
    if clang -O2 -w "$t" "$ROOT/build/boot/rt.ll" -Wno-override-module -o "$W/$n" -lm -lpthread 2> "$W/$n.log" && "$W/$n" > "$W/$n.out" 2>&1; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL $n: $(tail -2 "$W/$n.log" "$W/$n.out" 2>/dev/null | tr '\n' ' ')"
    fi
done
# Runtime primitives compile only in runtime/rt/ (or the compiler's own
# sources) with --runtime-internals.
COMPILER="${COMPILER:-$ROOT/build/boot/stage2.bin}"
for t in rt/*.out; do
    n="$(basename "$t" .out)"
    if (cd "$ROOT" && "$COMPILER" "tests/runtime/rt/$n.resid" -o "$W/rt_$n" --runtime-internals) > "$W/rt_$n.log" 2>&1 && "$W/rt_$n" > "$W/rt_$n.out" 2>&1 && cmp -s "$W/rt_$n.out" "$t"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL rt/$n: $(grep -m1 -i error "$W/rt_$n.log")"
    fi
done
# A lib/ file imported by an allowed entry still may not use internals.
(cd "$ROOT" && "$COMPILER" tests/runtime/rt/uses_lib.resid -o "$W/ul" --runtime-internals) > "$W/ul.log" 2>&1
if grep -q "E0220.*resid_raw_load64" "$W/ul.log"; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL a lib/ file used an internal"
fi
# The standard library and the tools never name a compiler internal.
if grep -nE 'resid_raw_|resid_(arena|bulk)_(push|pop)|resid_list_str_persist_copy|resid_dec_persist|resid_internals|resid_rtmod|@export\(|@import\(' "$ROOT"/lib/*.resid "$ROOT"/tools/*.resid > "$W/lint.out"; then
    fail=$((fail + 1)); echo "FAIL internals outside the compiler: $(head -1 "$W/lint.out")"
else
    pass=$((pass + 1))
fi
# `residc test`: the generated test entry point is a complete process.
if (cd "$ROOT" && "$COMPILER" test examples/math_test.resid) > "$W/tm.log" 2>&1 && grep -q "Failures: 0 | Passed: 6" "$W/tm.log"; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL residc test: $(grep -v '^OK' "$W/tm.log" | tail -2 | tr '\n' ' ')"
fi
# Buffered stdin: bytes then lines, one longer than the 64 KB buffer.
if (cd "$ROOT" && "$COMPILER" tests/runtime/term/stdin.resid -o "$W/stdin" --profile debug) > "$W/stdin.log" 2>&1 \
    && { printf 'xyhello\n'; head -c 100000 /dev/zero | tr '\0' a; printf '\nlast'; } | "$W/stdin" > "$W/stdin.out" \
    && printf '120 121\n6\n100001\n4\n3 -1\n' | cmp -s - "$W/stdin.out"; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL buffered stdin: $(grep -m1 -i error "$W/stdin.log")"
fi
# lib/readline.resid on a pseudo-terminal (needs python3).
if command -v python3 > /dev/null; then
    if (cd "$ROOT" && "$COMPILER" tests/runtime/term/readline.resid -o "$W/rl" --profile debug) > "$W/rl.log" 2>&1 \
        && python3 term/drive.py "$W/rl" > "$W/rl.out" 2>&1 && cmp -s "$W/rl.out" term/drive.out; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL readline on a pty: $(grep -m1 -i error "$W/rl.log") $(diff "$W/rl.out" term/drive.out | head -3 | tr '\n' ' ')"
    fi
fi
echo "runtime: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
