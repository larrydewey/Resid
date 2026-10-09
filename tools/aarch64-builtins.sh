#!/usr/bin/env bash
# Puts compiler-rt's AArch64 builtins (128-bit division, Float(128)
# arithmetic: what libgcc gives an x86-64 build) where `residc --target
# aarch64` looks for them: build/boot/aarch64/libclang_rt.builtins.a.
#
# Usage: tools/aarch64-builtins.sh [ARCHIVE]
# Without ARCHIVE it searches clang's own resource directory, then an
# Android NDK (ANDROID_NDK_HOME, ANDROID_NDK_ROOT, ~/Android/Sdk/ndk/*).
# RESID_AARCH64_BUILTINS overrides the copy at compile time.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$ROOT/build/boot/aarch64/libclang_rt.builtins.a"

find_one() {
    local p
    p="$(clang --target=aarch64-linux-gnu -rtlib=compiler-rt -print-libgcc-file-name 2>/dev/null || true)"
    [ -f "$p" ] && { echo "$p"; return; }
    for ndk in "${ANDROID_NDK_HOME:-}" "${ANDROID_NDK_ROOT:-}" "$HOME"/Android/Sdk/ndk/* "$HOME"/Library/Android/sdk/ndk/*; do
        [ -n "$ndk" ] && [ -d "$ndk" ] || continue
        p="$(find "$ndk/toolchains/llvm/prebuilt" -name 'libclang_rt.builtins-aarch64-android.a' 2>/dev/null | sort | tail -1)"
        [ -n "$p" ] && { echo "$p"; return; }
    done
}

SRC="${1:-$(find_one)}"
[ -n "$SRC" ] && [ -f "$SRC" ] || { echo "error: no AArch64 compiler-rt builtins found (install compiler-rt for aarch64 or an Android NDK, or pass the archive)" >&2; exit 1; }
mkdir -p "$(dirname "$DEST")"
cp "$SRC" "$DEST"
echo "copied $SRC -> $DEST"
