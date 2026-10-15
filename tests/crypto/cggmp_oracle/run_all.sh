#!/usr/bin/env bash
# Every Resid-side CGGMP21 oracle end to end: ordinary signing, re-share to a
# new party set, hidden additive tweak, initiator-only delivery, and the
# Taurus interop proofs. Run inside the Resid checkout.
set -euo pipefail
cd "$(dirname "$0")"

for s in session.py reshare.py tweak.py delivery.py; do
    echo "== $s"
    python3 "$s"
done
echo "all CGGMP21 oracles pass"
