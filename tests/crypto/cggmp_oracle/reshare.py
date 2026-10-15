#!/usr/bin/env python3
"""End-to-end re-share oracle: a dealer makes a 3-of-6 CGGMP21 sharing,
Resid re-shares the shares of parties 1..3 to the disjoint set 4..6, and
Python checks that the joint public key is unchanged and that a signature by
the new set verifies under OpenSSL (the cryptography package).

    python3 reshare.py
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
    cmd = [RESIDC, os.path.join(HERE, src), '--root', REPO, '-o', out]
    p = subprocess.run(cmd, cwd=REPO, capture_output=True, text=True)
    if p.returncode:
        raise RuntimeError(p.stdout + p.stderr)
    return out


def cfg_with_new_shares(cfg, shares):
    out = []
    for line in cfg.splitlines():
        key = line.split(' ', 1)[0]
        if key in ('X4', 'X5', 'X6'):
            i = int(key[1:])
            out.append(f'X{i} {shares[str(i)]}')
        elif key in ('XP4', 'XP5', 'XP6'):
            i = int(key[2:])
            out.append(f'XP{i} {comp(int(shares[str(i)], 16))}')
        else:
            out.append(line)
    return '\n'.join(out) + '\n'


def main():
    os.makedirs(W, exist_ok=True)
    reshare = build('resid_reshare.resid', os.path.join(W, 'resid_reshare'))
    session = build('resid_session.resid', os.path.join(W, 'resid_session'))
    rng = random.Random(1234)
    cfg, pub, x = make_config(6, 2, rng)
    old_cfg = os.path.join(W, 'reshare_old.cfg')
    open(old_cfg, 'w').write(cfg)
    seed = os.urandom(32).hex()
    p = subprocess.run([reshare, old_cfg, seed], capture_output=True, text=True)
    if p.returncode:
        raise RuntimeError(p.stdout + p.stderr)
    res = json.loads(p.stdout)
    if res.get('pubkey') != pub:
        raise SystemExit(f'root key changed: {res} dealer={pub}')
    new_cfg = cfg_with_new_shares(cfg, res['shares'])
    new_path = os.path.join(W, 'reshare_new.cfg')
    open(new_path, 'w').write(new_cfg)
    digest = hashlib.sha256(b'reshare oracle message').digest()
    p = subprocess.run([session, new_path, '4,5,6', digest.hex(), os.urandom(32).hex()],
                       capture_output=True, text=True)
    if p.returncode:
        raise SystemExit(p.stdout + p.stderr)
    sigs = json.loads(p.stdout)
    pk = ec.EllipticCurvePublicKey.from_encoded_point(ec.SECP256R1(), bytes.fromhex(pub))
    for sg in sigs['signatures']:
        pk.verify(utils.encode_dss_signature(int(sg['r'], 16), int(sg['s'], 16)),
                  digest, ec.ECDSA(utils.Prehashed(hashes.SHA256())))
    print(f're-share preserved X={pub[:16]}...; {len(sigs["signatures"])} new-set signatures verify under OpenSSL')


if __name__ == '__main__':
    main()
