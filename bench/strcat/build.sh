#!/usr/bin/env bash
# Build the compiled implementations into bench/strcat/out/.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; ROOT="$HERE/../.."
mkdir -p "$HERE/out"
(cd "$ROOT" && build/boot/stage2.bin "$HERE/strcat.resid" -o "$HERE/out/strcat_resid" >/dev/null)
cc -O2 "$HERE/strcat_naive.c" -o "$HERE/out/strcat_c"
rustc -O "$HERE/strcat.rs" -o "$HERE/out/strcat_rs" 2>/dev/null
(cd "$HERE" && go build -o out/strcat_go strcat.go)
