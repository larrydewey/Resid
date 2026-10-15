#!/usr/bin/env python3
"""Resid prover -> Go verifier for the proofs beyond prm and mod (see
interop.py). Each proof is made fresh from os.urandom streams for each key
pair in keys.json; a tampered copy must be refused.

    ./setup.sh && python3 interop_proofs.py
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


def bump(h, field_neg_ok=True):
    neg = h.startswith('-')
    v = int(h.lstrip('-'), 16) + 1
    s = format(v, 'x'); s = ('0' + s) if len(s) % 2 else s
    return ('-' if neg else '') + s


def kvfile(name, **kw):
    path = os.path.join(W, name)
    with open(path, 'w') as f:
        for k, v in kw.items(): f.write(f'{k} {v}\n')
    return path


def aux_for(vk, idx):
    """Pedersen parameters for the verifier's key, made by the Resid generator."""
    path = kvfile(f'aux{idx}.kv', P=vk['P'], Q=vk['Q'], RND=os.urandom(2048).hex())
    out = json.loads(run([os.path.join(W, 'resid_proofs'), 'aux', path]))
    return out['N'], out['S'], out['T']


ok = True
for i, prover in enumerate(keys):
    vk = keys[(i + 1) % len(keys)]
    n_hat, s, t = aux_for(vk, i)
    base = dict(P=prover['P'], Q=prover['Q'], NHAT=n_hat, S=s, T=t)
    base['VP'], base['VQ'] = vk['P'], vk['Q']
    CASES = (
        ('fac', {'RND': 4 * 4300}, 'Z1'),
        ('enc', {'RND': 4096, 'RND2': 4096}, 'Z1'),
        ('affg', {'RND': 4096, 'RND2': 4 * 4096}, 'Z1'),
        ('affp', {'RND': 4096, 'RND2': 4 * 4096}, 'Z1'),
        ('logstar', {'RND': 4096, 'RND2': 4096}, 'Z1'),
        ('encelg', {'RND': 4096, 'RND2': 4096}, 'Z1'),
        ('elog', {'RND': 4096, 'RND2': 4096}, 'Z'),
        ('log', {'RND': 4096, 'RND2': 4096}, 'Z1'),
        ('sch', {'RND': 4096, 'RND2': 4096}, 'Z'),
        ('nth', {'RND': 4096, 'RND2': 4096}, 'Z'),
    )
    for kind, fields, tfield in CASES:
        tamper = (tfield,)
        kw = dict(base)
        for name, size in fields.items():
            kw[name] = os.urandom(size).hex()
        path = kvfile(f'{kind}{i}.kv', **kw)
        out = json.loads(run([os.path.join(W, 'resid_proofs'), kind, path]))
        good = verify(kind, out)
        bad = dict(out)
        if kind in ('elog', 'log', 'sch'):
            # scalars are 32-byte hex: change one nibble
            v = bad[tamper[0]]; bad[tamper[0]] = v[:-1] + ('1' if v[-1] != '1' else '2')
        else:
            bad[tamper[0]] = bump(bad[tamper[0]])
        refused = not verify(kind, bad)
        print(f'key {i} {kind}: Go verifies Resid proof: {good}; tampered refused: {refused}')
        ok = ok and good and refused
sys.exit(0 if ok else 1)
