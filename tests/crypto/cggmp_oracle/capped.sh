#!/bin/sh
# Runs a command under a hard memory limit, no swap, at low priority, so a
# runaway test cannot take the machine down. Usage: ./capped.sh [MemoryMax] cmd...
LIMIT=6G
case "$1" in *G|*M) LIMIT="$1"; shift ;; esac
exec systemd-run --user --scope -q -p MemoryMax="$LIMIT" -p MemorySwapMax=0 nice -n 19 "$@"
