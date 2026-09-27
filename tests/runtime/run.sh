#!/usr/bin/env bash
# Runtime unit tests: each C file includes runtime/resid_rt.c and checks one
# property directly (immediate boxes, the capability guard, UTF-8 bounds).
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
echo "runtime: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
