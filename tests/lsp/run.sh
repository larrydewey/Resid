#!/usr/bin/env bash
# Language server tests: a client drives `residc lsp` over stdio on a small
# two-file project (diagnostics, hover, definition, symbols, completion,
# flat memory across edits, shutdown).
set -uo pipefail
cd "$(dirname "$0")"
ROOT="$(cd ../.. && pwd)"
COMPILER="${COMPILER:-$ROOT/build/boot/stage2.bin}"
# As in the other suites: the standard library of this checkout.
export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"
exec python3 client.py "$COMPILER" proj
