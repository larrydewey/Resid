#!/usr/bin/env python3
"""Initiator-only delivery oracle: a full CGGMP21 session routes signature
shares to the initiator, refuses them to every peer, and the initiator alone
emits the final signature.  The Resid program exits non-zero if a peer sees
any SgB message or if a non-initiator reaches the finishing API.

    python3 delivery.py
"""
import hashlib, json, os, random, subprocess, sys
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec, utils

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, '../../..'))
W = os.path.join(HERE, '.work')
sys.path.insert(0, HERE)
from session import make_config  # noqa: E402

RESIDC = os.environ.get('RESIDC', '/home/larry/.resid/bin/residc')


def build(src, out):
    if os.path.exists(out):
        return out
    p = subprocess.run([RESIDC, os.path.join(HERE, src), '--root', REPO, '-o', out], cwd=REPO, capture_output=True, text=True)
    if p.returncode:
        raise RuntimeError(p.stdout + p.stderr)
    return out


def main():
    os.makedirs(W, exist_ok=True)
    bin = build('resid_delivery_session.resid', os.path.join(W, 'resid_delivery_session'))
    cfg, pub, x = make_config(3, 1, random.Random(31))
    path = os.path.join(W, 'delivery.cfg')
    open(path, 'w').write(cfg)
    digest = hashlib.sha256(b'initiator-only delivery').digest()
    p = subprocess.run([bin, path, '1,2', digest.hex(), os.urandom(32).hex()], capture_output=True, text=True)
    if p.returncode:
        raise SystemExit(p.stdout + p.stderr)
    res = json.loads(p.stdout)
    if res['pubkey'] != pub or 'signature' not in res or 'signatures' in res:
        raise SystemExit(f'bad delivery result: {res}')
    sg = res['signature']
    pk = ec.EllipticCurvePublicKey.from_encoded_point(ec.SECP256R1(), bytes.fromhex(pub))
    pk.verify(utils.encode_dss_signature(int(sg['r'], 16), int(sg['s'], 16)), digest, ec.ECDSA(utils.Prehashed(hashes.SHA256())))
    print('initiator-only delivery: peers received no SgB; one signature emitted and verified under OpenSSL')


if __name__ == '__main__':
    main()
