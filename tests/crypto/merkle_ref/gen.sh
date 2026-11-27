#!/usr/bin/env bash
# Regenerate ../vectors_merkle/merkle.txt with golang.org/x/mod's tlog and
# note packages. Usage: gen.sh <path to a golang.org/x/mod checkout>
# (git clone https://github.com/golang/mod). Needs go; no network.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p ../vectors_merkle
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT
cp main.go "$W/"
cd "$W"
go mod init merkleref >/dev/null 2>&1
go mod edit -require=golang.org/x/mod@v0.0.0 -replace=golang.org/x/mod="$(realpath "$1")"
OUT="$(cd "$OLDPWD" && pwd)"
sed -i "s#\"../vectors_merkle/merkle.txt\"#\"$OUT/../vectors_merkle/merkle.txt\"#" main.go
GOFLAGS=-mod=mod GOPROXY=off go run .
