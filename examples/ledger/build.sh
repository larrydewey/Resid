#!/usr/bin/env bash
# Regenerates the ledger's native-module fixtures (spec §47) from their C
# sources: freestanding LLVM IR text, as a native module's artifact must be.
set -euo pipefail
cd "$(dirname "$0")"
for c in fees; do
    clang -S -emit-llvm -O1 -ffreestanding -fno-builtin -fno-stack-protector -o "$c.ll" "$c.c"
done
