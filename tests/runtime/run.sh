#!/usr/bin/env bash
# Runtime unit tests: each C file includes runtime/resid_rt.c and checks one
# property directly (immediate boxes, the capability guard, UTF-8 bounds);
# rt/primitives.resid checks the runtime primitives; and lib/ and tools/
# must not use any compiler internal.
set -uo pipefail
cd "$(dirname "$0")"
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT
pass=0; fail=0
for t in *.c; do
    n="${t%.c}"
    if cc -O2 -w "$t" -o "$W/$n" -lm -lpthread 2> "$W/$n.log" && "$W/$n" > "$W/$n.out" 2>&1; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL $n: $(tail -2 "$W/$n.log" "$W/$n.out" 2>/dev/null | tr '\n' ' ')"
    fi
done
# Runtime primitives compile only in runtime/rt/ (or the compiler's own
# sources) with --runtime-internals.
ROOT="$(cd ../.. && pwd)"
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
echo "runtime: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
