#!/usr/bin/env bash
# Build the IBM TPM 2.0 simulator that tests/device/run.sh's tpm_simulator
# case runs against, at a pinned commit, without root: needs git, make, a
# C compiler and OpenSSL's libcrypto headers.
#
# Usage: tests/device/tpm-sim/build.sh DIR
#   then RESID_TPM_SIMULATOR=DIR/src/tpm_server tests/device/run.sh
set -euo pipefail
REPO=https://github.com/kgoldman/ibmswtpm2.git
COMMIT=e1df46e46fc2671e55372d65f27ecbb3c789d992   # 2026-08-25
DIR="${1:?usage: build.sh DIR}"
git init -q "$DIR"
git -C "$DIR" fetch -q --depth 1 "$REPO" "$COMMIT"
git -C "$DIR" checkout -q FETCH_HEAD
make -C "$DIR/src" -j"$(nproc 2>/dev/null || echo 4)" > "$DIR/build.log" 2>&1
echo "$DIR/src/tpm_server"
