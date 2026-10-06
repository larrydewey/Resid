#!/usr/bin/env bash
# Runtime unit tests: each C file links the Resid runtime (build/boot/rt.ll)
# and checks one property directly (immediate boxes, the capability guard, UTF-8 bounds);
# term/ checks buffered stdin and lib/readline.resid on a pty;
# rt/primitives.resid checks the runtime primitives; and lib/ and tools/
# must not use any compiler internal.
set -uo pipefail
cd "$(dirname "$0")"
W="$(mktemp -d)"; trap 'echo "Preserving $W" >trap 'rm -rf "$W"' EXIT2; ls -la $W' EXIT
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
# A native module (spec §47) is bound by a program or package, never by
# the standard library, the tools or the runtime (E0232); and lib/ and
# tools/ name no native family.
mkdir -p "$W/nat/lib" "$W/nat/tools" "$W/nat/runtime/rt"
printf '@link("tiny")\npub Int tiny_add(Int a, Int b) {}\n' > "$W/nat/lib/bind.resid"
printf 'import "lib/bind.resid";\n@requires(native_tiny)\nInt main() { return tiny_add(1, 2); }\n' > "$W/nat/main.resid"
printf '@link("tiny")\nInt tiny_add(Int a, Int b) {}\nInt main() { return 0; }\n' > "$W/nat/tools/t.resid"
nat_ok=1
(cd "$ROOT" && "$COMPILER" "$W/nat/main.resid" -o "$W/nat/m") > "$W/nat1.log" 2>&1; grep -q "E0232" "$W/nat1.log" || nat_ok=0
(cd "$ROOT" && "$COMPILER" "$W/nat/tools/t.resid" -o "$W/nat/t") > "$W/nat2.log" 2>&1; grep -q "E0232" "$W/nat2.log" || nat_ok=0
cp "$W/nat/tools/t.resid" "$W/nat/runtime/rt/x.resid"
(cd "$ROOT" && "$COMPILER" "$W/nat/runtime/rt/x.resid" --runtime-module -o "$W/nat/r") > "$W/nat3.log" 2>&1; grep -q "E0232" "$W/nat3.log" || nat_ok=0
grep -nE '@link\(|@requires\([^)]*native_' "$ROOT"/lib/*.resid "$ROOT"/tools/*.resid > "$W/natlint.out" && nat_ok=0
if [ "$nat_ok" = 1 ]; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL @link outside a program was not refused (E0232): $(grep -h -m1 -i error "$W"/nat*.log | head -1) $(head -1 "$W/natlint.out")"; fi

# The display transport (runtime/rt/unix.resid): a Unix socket pair, bytes
# and descriptors over it, a shared mapping through its handle, and the
# same descriptors pollable under `display` alone.
echo "DEBUG: starting display transport test, cwd=$(pwd)" >&2
if (cd "$ROOT" && "$COMPILER" tests/runtime/display.resid -o "$W/display") > "$W/display.log" 2>&1; then
    echo "DEBUG: compile ok, W=$W" >&2
    "$W/display" > "$W/display.out" 2>&1
    run_rc=$?
    echo "DEBUG: run rc=$run_rc, display.out size=$(wc -c < $W/display.out)" >&2
    echo "DEBUG: locale stdout=" >&2
    locale 2>&1; echo "locale rc=$?" >&2
    echo "DEBUG: ls stdout=" >&2
    ls -la "$W/display.out" 2>&1; echo "ls rc=$?" >&2
    echo "DEBUG: file stdout=" >&2
    file "$W/display.out" 2>&1; echo "file rc=$?" >&2
    echo "DEBUG: xxd stdout=" >&2
    xxd "$W/display.out" | head -3 2>&1; echo "xxd rc=$?" >&2
    echo "DEBUG: expected output (hex):" >&2
    xxd tests/runtime/display.out | head -3 >&2; echo "xxd expected rc=$?" >&2
    if [ $run_rc -eq 0 ] && cmp -s "$W/display.out" display.out; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1)); echo "FAIL display transport: $(grep -m1 -i error "$W/display.log") $(diff "$W/display.out" tests/runtime/display.out 2>/dev/null | head -3 | tr '
' ' ')"
    fi
else
    fail=$((fail + 1)); echo "FAIL display transport: $(grep -m1 -i error "$W/display.log") $(diff "$W/display.out" tests/runtime/display.out 2>/dev/null | head -3 | tr '
' ' ')"
fi
# With no display named in the environment, connecting is refused rather
# than guessed at.
printf '@requires(display)
Int main() { return if (resid_disp_connect() < 0) { 0 } else { 1 }; }
' > "$W/nodisplay.resid"
if (cd "$ROOT" && "$COMPILER" "$W/nodisplay.resid" -o "$W/nodisplay") > "$W/nodisplay.log" 2>&1     && env -u DISPLAY -u WAYLAND_DISPLAY -u WAYLAND_SOCKET -u XDG_RUNTIME_DIR "$W/nodisplay"; then
    pass=$((pass + 1))
else
    fail=$((fail + 1)); echo "FAIL display connect with no display: $(grep -m1 -i error "$W/nodisplay.log")"
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
