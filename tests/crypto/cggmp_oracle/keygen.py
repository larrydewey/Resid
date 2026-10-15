#!/usr/bin/env python3
"""End-to-end check of key generation, refresh and signing in lib/cggmp.resid:
no dealer. Each stage runs in its own process under a memory cap, passing the
configurations through lib/cggmp_store.resid's encoding:

  keygen  -> configurations (5 rounds among n parties)
  sign    -> a signature, verified here as ordinary ECDSA under the group
             public key by the cryptography package (OpenSSL)
  refresh -> new configurations (same key, new shares)
  sign    -> a signature again, under the same public key

    ./setup.sh && python3 keygen.py
"""
import hashlib, json, os, subprocess, sys
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec, utils

HERE = os.path.dirname(os.path.abspath(__file__))
W = os.path.join(HERE, '.work')
CAP = os.path.join(HERE, 'capped.sh')
keys = json.load(open(os.path.join(HERE, 'keys6.json')))


def stage(args, limit='5G'):
    r = subprocess.run([CAP, limit, os.path.join(W, 'resid_keygen')] + args, capture_output=True, text=True)
    if r.returncode != 0:
        raise SystemExit(f'stage {args[0]} failed (rc {r.returncode}): {(r.stdout or r.stderr)[:300]}')
    return r.stdout


def check_sig(out, digest):
    j = json.loads(out)
    pk = ec.EllipticCurvePublicKey.from_encoded_point(ec.SECP256R1(), bytes.fromhex(j['pubkey']))
    pk.verify(utils.encode_dss_signature(int(j['r'], 16), int(j['s'], 16)), digest, ec.ECDSA(utils.Prehashed(hashes.SHA256())))
    return j['pubkey']


def run(n, t, signers):
    primes = os.path.join(W, f'primes_{n}.kv')
    with open(primes, 'w') as f:
        for i in range(1, n + 1):
            f.write(f'P{i} {keys[i - 1]["P"]}\nQ{i} {keys[i - 1]["Q"]}\n')
    cfg1 = os.path.join(W, f'cfg_{n}_{t}_a.txt')
    cfg2 = os.path.join(W, f'cfg_{n}_{t}_b.txt')
    open(cfg1, 'w').write(stage(['keygen', primes, str(n), str(t), os.urandom(32).hex()]))
    digest = hashlib.sha256(os.urandom(20)).digest()
    pub1 = check_sig(stage(['sign', cfg1, ','.join(map(str, signers)), digest.hex(), os.urandom(32).hex()]), digest)
    open(cfg2, 'w').write(stage(['refresh', primes, cfg1, os.urandom(32).hex()]))
    digest2 = hashlib.sha256(os.urandom(20)).digest()
    pub2 = check_sig(stage(['sign', cfg2, ','.join(map(str, signers)), digest2.hex(), os.urandom(32).hex()]), digest2)
    changed = open(cfg1).read() != open(cfg2).read()
    return pub1 == pub2 and changed, f'both signatures verify under the group key (OpenSSL); key unchanged by refresh: {pub1 == pub2}; configurations changed: {changed}'


if __name__ == '__main__':
    cases = [(3, 1, [1, 2])]
    if len(sys.argv) > 3:
        cases = [(int(sys.argv[1]), int(sys.argv[2]), [int(v) for v in sys.argv[3:]])]
    ok = True
    for n, t, signers in cases:
        good, msg = run(n, t, signers)
        print(f'keygen degree {t} among {n}, signers {signers}: {msg}')
        ok = ok and good
    sys.exit(0 if ok else 1)
