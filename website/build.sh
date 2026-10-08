#!/usr/bin/env bash
# Export the Resid documentation to static files with resid-book, the way
# .github/workflows/docs.yml does: the same pages a browser would be served,
# written to website/dist. Then GitHub Pages (or any static host) can serve
# it directly, with no Node.
#
#   ./website/build.sh          # writes website/dist
#
# Requires a Resid checkout beside this one (../resid) and resid-book
# beside that (../resid-book). RESIDC overrides the compiler.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
BOOK="${RESID_BOOK:-$ROOT/../resid-book}"
COMPILER="${RESIDC:-$ROOT/build/boot/stage2.bin}"
OUT="${1:-$HERE/dist}"

[ -x "$COMPILER" ] || { echo "compiler not found: $COMPILER (build it with ./boot.sh)" >&2; exit 2; }
[ -d "$BOOK/src" ] || { echo "resid-book not found: $BOOK (clone larrydewey/resid-book beside the repository)" >&2; exit 2; }

export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"
mkdir -p "$ROOT/target"

if [ ! -x "$ROOT/target/resid-manifest" ] || [ "$ROOT/tools/resid-manifest.resid" -nt "$ROOT/target/resid-manifest" ]; then
    echo "==> resid-manifest"
    "$COMPILER" tools/resid-manifest.resid -o "$ROOT/target/resid-manifest" --profile debug >/dev/null
fi
echo "==> dependency map"
(cd "$BOOK" && "$ROOT/target/resid-manifest" depmap resid.toml deps.txt >/dev/null)

echo "==> resid-book"
(cd "$BOOK" && "$COMPILER" src/site.resid -o "$ROOT/target/resid-book" --profile debug -depmap deps.txt >/dev/null)

echo "==> export"
rm -rf "$OUT"
(cd "$BOOK" && "$ROOT/target/resid-book" export "$HERE/book.toml" "$OUT")
echo "==> $OUT"