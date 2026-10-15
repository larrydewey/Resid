#!/usr/bin/env python3
"""End-to-end hidden-tweak oracle: one designated party adds tau to its raw
share (scaled by its Lagrange coefficient), the public share commitment moves
by tau/lambda * G, and a full CGGMP21 presign+sign session verifies under
X + tau and not under X.

    python3 tweak.py
"""
import hashlib, json, os, random, subprocess, sys
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec, utils

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, '../../..'))
W = os.path.join(HERE, '.work')
sys.path.insert(0, HERE)
from session import Q, comp, make_config  # noqa: E402

RESIDC = os.environ.get('RESIDC', '/home/larry/.resid/bin/residc')


def build(src, out):
    if os.path.exists(out):
        return out
    p = subprocess.run([RESIDC, os.path.join(HERE, src), '--root', REPO, '-o', out], cwd=REPO, capture_output=True, text=True)
    if p.returncode:
        raise RuntimeError(p.stdout + p.stderr)
    return out


def set_field(cfg, key, value):
    out = []
    for line in cfg.splitlines():
        if line.split(' ', 1)[0] == key:
            out.append(f'{key} {value}')
        else:
            out.append(line)
    return '\n'.join(out) + '\n'


def verify(pk_hex, digest, sig):
    pk = ec.EllipticCurvePublicKey.from_encoded_point(ec.SECP256R1(), bytes.fromhex(pk_hex))
    pk.verify(utils.encode_dss_signature(int(sig['r'], 16), int(sig['s'], 16)), digest, ec.ECDSA(utils.Prehashed(hashes.SHA256())))


def main():
    os.makedirs(W, exist_ok=True)
    session = build('resid_session.resid', os.path.join(W, 'resid_session'))
    cfg, pub, x = make_config(3, 1, random.Random(77))
    tau = 5
    lam = 2  # the Lagrange coefficient of party 1 at zero over [1, 2]
    x1 = (int(dict(line.split(' ', 1) for line in cfg.splitlines())['X1'], 16) + tau * pow(lam, -1, Q)) % Q
    cfg = set_field(cfg, 'X1', format(x1, '064x'))
    cfg = set_field(cfg, 'XP1', comp(x1))
    tweaked_pub = comp((x + tau) % Q)
    path = os.path.join(W, 'tweak.cfg')
    open(path, 'w').write(cfg)
    digest = hashlib.sha256(b'hidden tweak oracle').digest()
    p = subprocess.run([session, path, '1,2', digest.hex(), os.urandom(32).hex()], capture_output=True, text=True)
    if p.returncode:
        raise SystemExit(p.stdout + p.stderr)
    sig = json.loads(p.stdout)['signatures'][0]
    verify(tweaked_pub, digest, sig)
    base_failed = False
    try:
        verify(pub, digest, sig)
    except Exception:
        base_failed = True
    if not base_failed:
        raise SystemExit('tweaked signature also verified under the untweaked key')
    print(f'hidden tweak: signature verifies under X+tau ({tweaked_pub[:16]}...), not under X ({pub[:16]}...)')


if __name__ == '__main__':
    main()
