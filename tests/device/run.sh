#!/usr/bin/env bash
# Device descriptor checks (spec §49, PLAN-device-access.md): E0262-E0264
# on descriptors that only the standard library's lib/dev/ may declare.
#
# Usage: tests/device/run.sh [-c COMPILER] [FILTER...]
#
# The cases need descriptors that are wrong on purpose, and a descriptor is
# refused outside lib/dev/ (E0260). So the suite builds a private standard
# library: a copy of lib/ in a temporary RESID_HOME, with each case's
# fixture NAME.dev installed as lib/dev/fx_NAME.resid. The real lib/dev/
# never holds a broken descriptor.
#
# For each tests/device/cases/NAME.resid:
#   NAME.dev      the fixture module (imports device.resid)
#   NAME.fail     compilation must fail
#   NAME.compile  lines that must each appear in the compiler's output
#   NAME.out      expected stdout of the built binary
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CASES="$ROOT/tests/device/cases"
COMPILER="$ROOT/build/boot/stage2.bin"
while getopts "c:" opt; do
    case "$opt" in
        c) COMPILER="$(realpath "$OPTARG")" ;;
        *) exit 2 ;;
    esac
done
shift $((OPTIND - 1))
if [ -z "${RESID_SIGNING_KEY:-}" ] && [ ! -f "$ROOT/keys/resid-ed25519.key" ]; then
    KEYDIR="$(mktemp -d)"
    "$COMPILER" keygen "$KEYDIR" >/dev/null && export RESID_SIGNING_KEY="$KEYDIR/resid-ed25519.key"
fi
[ -x "$COMPILER" ] || { echo "compiler not found: $COMPILER (run ./boot.sh)"; exit 2; }
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
HOME_DIR="$WORK/home"
mkdir -p "$HOME_DIR"
cp -r "$ROOT/lib" "$HOME_DIR/lib"
ln -s "$ROOT/build/boot/rt.ll" "$HOME_DIR/rt.ll"
ln -s "$ROOT/build/boot/rt-aarch64.ll" "$HOME_DIR/rt-aarch64.ll"
for f in "$CASES"/*.dev; do
    cp "$f" "$HOME_DIR/lib/dev/fx_$(basename "$f" .dev).resid"
done
export RESID_HOME="$HOME_DIR"
pass=0; fail=0
for f in "$CASES"/*.resid; do
    n="$(basename "$f" .resid)"
    if [ "$#" -gt 0 ]; then
        hit=0; for pat in "$@"; do [[ "$n" == *"$pat"* ]] && hit=1; done
        [ "$hit" -eq 1 ] || continue
    fi
    d="$WORK/$n"; mkdir -p "$d"; cp "$f" "$d/$n.resid"
    why=""
    (cd "$d" && timeout 600 "$COMPILER" "$n.resid" -o bin) > "$d/c.log" 2>&1; rc=$?
    if [ -f "$CASES/$n.fail" ]; then
        [ "$rc" -ne 0 ] || why="compiled, but must fail"
    else
        [ "$rc" -eq 0 ] || why="compile failed: $(grep -m1 -i error "$d/c.log")"
    fi
    if [ -f "$CASES/$n.compile" ]; then
        while IFS= read -r line; do
            [ -z "$line" ] && continue
            grep -qF -- "$line" "$d/c.log" || why="${why:+$why; }compiler output lacks '$line'"
        done < "$CASES/$n.compile"
    fi
    if [ -z "$why" ] && [ -f "$CASES/$n.out" ]; then
        (cd "$d" && timeout 60 ./bin > out 2>/dev/null) || why="binary exited $?"
        cmp -s "$d/out" "$CASES/$n.out" || why="${why:+$why; }stdout differs from $n.out"
    fi
    if [ -z "$why" ]; then echo "PASS $n"; pass=$((pass + 1)); else echo "FAIL $n: $why"; fail=$((fail + 1)); fi
done
# E0260 decides "in lib/dev/" by path prefix, so the standard library's
# root must be absolute. Without RESID_HOME it is the relative `lib`, which
# a project's own ./lib/dev/ also matches: then nothing counts as lib/dev/
# and a descriptor there is refused, not trusted.
if [ "$#" -eq 0 ] || [[ " $* " == *" e0260_relative_stdroot "* ]]; then
    P="$WORK/relroot"; mkdir -p "$P/lib/dev" "$P/build/boot"
    cp "$ROOT/lib/dev/device.resid" "$ROOT/lib/dev/device_write.resid" "$P/lib/dev/"
    ln -s "$ROOT/build/boot/rt.ll" "$P/build/boot/rt.ll"
    printf '%s\n' 'import "device.resid";' 'import "device_write.resid";' \
        'pub IoctlOp own_op() { return IoctlOp {.name = "own.op", .path = "/dev/mem", .requests = dv_both(dv_iowr(77, 0, 16)), .size = 16, .fields = [Buffer(0, -1, 64, InOut, false), Scalar(8, 8, Out)], .write = true, .version = Unversioned, .stability = OutOfTree}; }' \
        '@requires(device)' \
        'pub Str own_call() { return match (device.ioctl(own_op(), [InBytes([(UInt(8))1])])) { Ok(o) => "ok", Err(e) => device_error_text(e), }; }' > "$P/lib/dev/own.resid"
    printf '%s\n' 'import "dev/own.resid";' '@requires(device)' 'Int main() { println(own_call()); return 0; }' > "$P/main.resid"
    (cd "$P" && env -u RESID_HOME timeout 600 "$COMPILER" main.resid -o bin) > "$P/c.log" 2>&1; rc=$?
    if [ "$rc" -ne 0 ] && grep -q "E0260.*not an absolute path" "$P/c.log"; then
        echo "PASS e0260_relative_stdroot"; pass=$((pass + 1))
    else
        echo "FAIL e0260_relative_stdroot: a project's own lib/dev/ counted as the standard library's (exit $rc)"; fail=$((fail + 1))
    fi
fi
echo "---"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
