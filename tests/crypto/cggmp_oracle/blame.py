#!/usr/bin/env python3
"""Identifiable abort: in each message round of presigning, one of three
signers sends the messages of another signer relabelled as its own (the
proofs in them are bound to the other signer's identity). The honest parties
must refuse and name exactly the forger.

    ./setup.sh && python3 blame.py
"""
import hashlib, json, os, random, subprocess, sys
import session

W = session.W


def run(round_no, victim, other):
    rng = random.Random(7)
    cfg, pub, x = session.make_config(3, 1, rng)
    path = os.path.join(W, 'blame.cfg')
    open(path, 'w').write(cfg)
    digest = hashlib.sha256(b'blame').digest()
    out = subprocess.run([os.path.join(W, 'resid_session'), path, '1,2,3', digest.hex(), os.urandom(32).hex(),
                          str(round_no), str(victim), str(other)], capture_output=True, text=True)
    try:
        res = json.loads(out.stdout)
    except Exception:
        return False, 'no result: ' + (out.stdout + out.stderr)[:300]
    return res.get('culprits') == [victim], f'{res.get("error")}; culprits {res.get("culprits")}'


if __name__ == '__main__':
    ok = True
    for r in range(1, 7):
        victim, other = (r % 3) + 1, ((r + 1) % 3) + 1
        good, msg = run(r, victim, other)
        print(f'round {r}, party {victim} forges with party {other}\'s messages: {"PASS" if good else "FAIL"} ({msg})', flush=True)
        ok = ok and good
    sys.exit(0 if ok else 1)
