#!/usr/bin/env python3
"""Interoperability of lib/cggmp_zk.resid with the Taurus oracle, both ways.

  Go prover -> Resid verifier is covered by the committed vectors in
  ../cggmp_zk_test.resid (made by ../gen_cggmp_zk.py).
  Resid prover -> Go verifier is run here, fresh each time: for each key in
  keys.json the Resid prover makes the proofs from os.urandom streams and the
  Go verifier must accept them; a tampered copy must be refused.

    ./setup.sh && python3 interop.py
"""
import json, os, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
W = os.path.join(HERE, '.work')
keys = json.load(open(os.path.join(HERE, 'keys.json')))


def run(cmd, inp=None):
    r = subprocess.run(cmd, input=inp, capture_output=True, text=True)
    if r.returncode != 0: raise SystemExit(f'{cmd[0]} failed: {r.stdout[:300]} {r.stderr[:300]}')
    return r.stdout.strip()


def verify(kind, obj):
    return run([os.path.join(W, 'genvec'), f'verify-{kind}'], json.dumps(obj)) == 'true'


ok = True
for i, k in enumerate(keys):
    paths = []
    for j, n in enumerate((4096, 80 * 256 * 4, 256 * 64)):
        path = os.path.join(W, f'stream{j}.hex')
        open(path, 'w').write(os.urandom(n).hex())
        paths.append(path)
    out = json.loads(run([os.path.join(W, 'resid_prove'), k['P'], k['Q']] + paths))
    for kind in ('prm', 'mod'):
        good = verify(kind, out[kind])
        bad = json.loads(json.dumps(out[kind]))
        if kind == 'prm':
            z = int(bad['Zs'][5], 16) + 1
        else:
            z = int(bad['Responses'][5]['Z'], 16) + 1
        h = format(z, 'x'); h = ('0' + h) if len(h) % 2 else h
        if kind == 'prm': bad['Zs'][5] = h
        else: bad['Responses'][5]['Z'] = h
        refused = not verify(kind, bad)
        print(f'key {i} {kind}: Go verifies Resid proof: {good}; tampered refused: {refused}')
        ok = ok and good and refused
sys.exit(0 if ok else 1)
