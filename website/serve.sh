#!/usr/bin/env bash
# Serve the Resid documentation with resid-book: no Astro, no Node, no
# build step. The content is exactly what Astro was building from
# (src/content/docs); book.toml is the configuration.
#
#   ./website/serve.sh [--port N] [--cdn]
#
# Requires a Resid checkout beside this one (../resid) and resid-book
# beside that (../resid-book). RESIDC overrides the compiler.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
BOOK="${RESID_BOOK:-$ROOT/../resid-book}"
COMPILER="${RESIDC:-$ROOT/build/boot/stage2.bin}"
TARGET="$ROOT/target/resid-book"

[ -x "$COMPILER" ] || { echo "compiler not found: $COMPILER (build it with ./boot.sh)" >&2; exit 2; }
[ -d "$BOOK/src" ] || { echo "resid-book not found: $BOOK (clone larrydewey/resid-book beside the repository)" >&2; exit 2; }

# The compiler finds the standard library through RESID_HOME (the
# repository's own build/boot, where rt.ll and the compiler live).
export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"

mkdir -p "$ROOT/target"

# resid-manifest resolves resid-book's dependencies (the Datastar SDK, and
# through it resid-json and resid-serial) into a path map.
if [ ! -x "$ROOT/target/resid-manifest" ] || [ "$ROOT/tools/resid-manifest.resid" -nt "$ROOT/target/resid-manifest" ]; then
    echo "==> building resid-manifest"
    "$COMPILER" tools/resid-manifest.resid -o "$ROOT/target/resid-manifest" --profile debug >/dev/null
fi
echo "==> dependency map"
(cd "$BOOK" && "$ROOT/target/resid-manifest" depmap resid.toml deps.txt >/dev/null)

echo "==> resid-book"
(cd "$BOOK" && "$COMPILER" src/site.resid -o "$TARGET" --profile debug -depmap deps.txt >/dev/null)

echo "==> serving"
cd "$HERE"
exec "$TARGET" book.toml "$@"