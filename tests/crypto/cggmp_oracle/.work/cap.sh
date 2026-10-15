#!/bin/sh
# run a command under a hard memory and CPU cap
exec systemd-run --user --scope -q -p MemoryMax=3G -p MemorySwapMax=0 -p CPUQuota=100% nice -n 19 "$@"
