#!/bin/sh
# bench/crossing/run.sh — the cost of crossing between two processes over a
# shared ring, in Resid and in C, three runs each.
#
#   bench/crossing/run.sh            (RESIDC=<path> to choose the compiler)
#
# x86-64 Linux with at least three CPUs: the two sides are pinned to CPUs 0
# and 2. Close other programs first; plug a laptop in.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
RESIDC=${RESIDC:-$HOME/.resid/bin/residc}
[ -x "$RESIDC" ] || RESIDC="$HERE/../../build/boot/residc"
[ -x "$RESIDC" ] || { echo "residc not found; run ./setup.sh or set RESIDC" >&2; exit 1; }
[ "$(nproc)" -ge 3 ] || { echo "needs at least three CPUs" >&2; exit 1; }
OUT=$(mktemp -d)
trap 'rm -rf "$OUT"' EXIT
cd "$HERE"
"$RESIDC" runtime/rt/ringbench.resid --runtime-internals -o "$OUT/ringbench" > "$OUT/build.log" 2>&1 || { cat "$OUT/build.log"; exit 1; }
cc -O2 -o "$OUT/ring" ring.c
cc -O2 -DRMW -o "$OUT/ring_rmw" ring.c
uname -srm; grep -m1 'model name' /proc/cpuinfo || true
for i in 1 2 3; do
    echo "--- run $i"
    "$OUT/ringbench"
    "$OUT/ring"
    "$OUT/ring_rmw" | sed -n '1s/^c    /c rmw/p'
done
