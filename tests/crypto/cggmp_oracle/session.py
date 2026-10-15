#!/usr/bin/env python3
"""End-to-end check of lib/cggmp.resid: a dealer makes a t-of-n key sharing
(Shamir over the P-256 scalar field), per-party Paillier keys (primes from
keys6.json, made by the Taurus oracle), Pedersen parameters and ElGamal keys.
The Resid parties then run the whole presign-and-sign protocol in one process
(resid_session), and the signature is verified here as an ordinary ECDSA
signature under the dealer's public key by the cryptography package (OpenSSL).

    ./setup.sh && python3 session.py [n t signers...]
"""
import hashlib, json, math, os, random, subprocess, sys
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec, utils

HERE = os.path.dirname(os.path.abspath(__file__))
W = os.path.join(HERE, '.work')
Q = 0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551
keys = json.load(open(os.path.join(HERE, 'keys6.json')))


def comp(k):
    n = ec.derive_private_key(k, ec.SECP256R1()).public_key().public_numbers()
    return (bytes([2 + (n.y & 1)]) + n.x.to_bytes(32, 'big')).hex()


def h32(v): return v.to_bytes(32, 'big').hex()
def hx(v):
    s = format(v, 'x'); return s if len(s) % 2 == 0 else '0' + s


def make_config(n, t, rng):
    x = rng.randrange(1, Q)
    coeffs = [x] + [rng.randrange(Q) for _ in range(t)]
    f = lambda i: sum(c * pow(i, j, Q) for j, c in enumerate(coeffs)) % Q
    lines = [f'N {n}', f'T {t}']
    for i in range(1, n + 1):
        k = keys[i - 1]
        p, q = int(k['P'], 16), int(k['Q'], 16)
        N = p * q; phi = (p - 1) * (q - 1)
        while True:
            tau = rng.randrange(2, N)
            if math.gcd(tau, N) == 1: break
        tt = tau * tau % N
        lam = rng.randrange(phi)
        s = pow(tt, lam, N)
        e = rng.randrange(1, Q)
        lines += [f'X{i} {h32(f(i))}', f'E{i} {h32(e)}', f'P{i} {k["P"]}', f'Q{i} {k["Q"]}', f'XP{i} {comp(f(i))}', f'EP{i} {comp(e)}',
                  f'NH{i} {hx(N)}', f'S{i} {hx(s)}', f'T{i} {hx(tt)}']
    return '\n'.join(lines) + '\n', comp(x), x


def run(n, t, signers, seed):
    rng = random.Random(seed)
    cfg, pub, x = make_config(n, t, rng)
    path = os.path.join(W, f'session_{n}_{t}.cfg')
    open(path, 'w').write(cfg)
    msg = os.urandom(24)
    digest = hashlib.sha256(msg).digest()
    out = subprocess.run([os.path.join(W, 'resid_session'), path, ','.join(map(str, signers)), digest.hex(), os.urandom(32).hex()],
                         capture_output=True, text=True)
    if out.returncode != 0:
        return False, out.stdout.strip() or out.stderr.strip()[:300]
    res = json.loads(out.stdout)
    if res['pubkey'] != pub:
        return False, f'public key {res["pubkey"]} is not the dealer\'s {pub}'
    pk = ec.EllipticCurvePublicKey.from_encoded_point(ec.SECP256R1(), bytes.fromhex(pub))
    for sg in res['signatures']:
        pk.verify(utils.encode_dss_signature(int(sg['r'], 16), int(sg['s'], 16)), digest, ec.ECDSA(utils.Prehashed(hashes.SHA256())))
    first = res['signatures'][0]
    same = all(s == first for s in res['signatures'])
    return same, f'{len(res["signatures"])} signers, signature verifies under the dealer key (OpenSSL), all parties agree: {same}'


if __name__ == '__main__':
    cases = [(3, 1, [1, 2]), (3, 1, [1, 3]), (3, 1, [1, 2, 3]), (3, 2, [1, 2, 3])]
    if len(sys.argv) > 3:
        cases = [(int(sys.argv[1]), int(sys.argv[2]), [int(v) for v in sys.argv[3:]])]
    ok = True
    for n, t, signers in cases:
        good, msg = run(n, t, signers, seed=n * 100 + t)
        print(f'{t}-degree sharing of {n}, signers {signers}: {msg}')
        ok = ok and good
    sys.exit(0 if ok else 1)
