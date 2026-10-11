#!/usr/bin/env bash
# The kernel-matrix job for generated device descriptors (PLAN-device-access.md
# §6.2, `devgen_matches_uapi_*`): before a release, and on a schedule in CI
# (.github/workflows/devgen-matrix.yml), check that
#   1. lib/dev/uapi_*.resid are exactly what the committed header snapshot
#      generates (`resid-devgen --check`, the same check tests/devgen runs
#      offline), and
#   2. every kernel pinned in tools/devgen/kernels.toml -- the oldest kernel
#      of each interface, every LTS line, the current stable release and the
#      latest mainline tag -- gives the same struct sizes, member offsets and
#      widths, buffer maxima and request numbers, for x86-64 and AArch64
#      (`resid-devgen --matrix`).
# Each pinned tree is a sparse, shallow, blob-filtered checkout of
# include/uapi and the two arch uapi trees, cached in tools/devgen/cache/
# (gitignored) and refused unless it is the pinned commit.
#
# Exit 0: no drift. Exit 1: drift (the report names the kernel, the target
# and the fact). Exit 2: the tool could not run (no clang, no network).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
"$ROOT/tools/resid-devgen" --check
"$ROOT/tools/resid-devgen" --matrix "$@"
