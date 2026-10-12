#!/usr/bin/env bash
# Build DMTF's spdm-emu (responder and sample keys) that tests/spdm/run.sh
# talks to, at a pinned commit, without root: needs git, cmake, make, a C
# compiler and perl (OpenSSL is built from libspdm's submodule).
#
# Usage: tests/spdm/emu/build.sh DIR
#   then RESID_SPDM_EMU=DIR/build/bin tests/spdm/run.sh
set -euo pipefail
REPO=https://github.com/DMTF/spdm-emu.git
COMMIT=9975786cd43c0b4baa9f6979c313f7520f9ce296   # 2026-10-06, libspdm a6994ee
DIR="${1:?usage: build.sh DIR}"
git init -q "$DIR"
git -C "$DIR" fetch -q --depth 1 "$REPO" "$COMMIT"
git -C "$DIR" checkout -q FETCH_HEAD
git -C "$DIR" submodule update -q --init --recursive --depth 1
mkdir -p "$DIR/build"
(cd "$DIR/build" && cmake -DARCH=x64 -DTOOLCHAIN=GCC -DTARGET=Release -DCRYPTO=openssl .. > ../build.log 2>&1 \
    && make copy_sample_key >> ../build.log 2>&1 && make -j"$(nproc 2>/dev/null || echo 4)" >> ../build.log 2>&1)
echo "$DIR/build/bin"
