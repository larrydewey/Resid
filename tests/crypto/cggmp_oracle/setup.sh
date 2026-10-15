#!/usr/bin/env bash
# Builds the oracle for the CGGMP21 proofs: Taurus multi-party-sig at a pinned
# commit, its transcript hash patched to SHA-256 (sha256-transcript.patch)
# and a P-256 curve added (p256_curve.go.src),
# plus genvec, which makes and verifies proofs as JSON. Needs go and git, and
# network access the first time. The result is cggmp_oracle/.work/genvec.
#
# The oracle is for testing only: nothing in lib/ depends on it, and its
# security is Taurus's, not ours.
set -euo pipefail
cd "$(dirname "$0")"
COMMIT=d489e309bba491d9cfb565dee14d76900948e497
[ -d .work/mps ] || { mkdir -p .work; git clone -q https://github.com/taurusgroup/multi-party-sig .work/mps; }
cd .work/mps
git checkout -q "$COMMIT" 2>/dev/null || git checkout -q d489e30
git checkout -q -- pkg/hash/hash.go
git apply ../../sha256-transcript.patch
cp ../../p256_curve.go.src pkg/math/curve/p256.go
mkdir -p cmd/genvec
cp ../../genvec/*.go cmd/genvec/
go build -o ../genvec ./cmd/genvec
echo "built $(pwd)/../genvec"
