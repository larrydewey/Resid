#!/usr/bin/env python3
"""End-to-end blind-tweak oracle (lib/cggmp_blind.resid).

For several t-of-n configurations and every choice of designated party:
- the signature verifies (OpenSSL, via cryptography) under X + tau G and not
  under X;
- the designated party's key is X + tau G; every other party's is X;
- no curve point any other party receives equals X + tau G or tau G, and
  no S point, signature share or abort-2 opening reaches it.
Faults:
- a corrupted tweak aff-p proof is refused and names the designated party;
- a party whose Chi share is off makes the S points miss X + tau G; the
  designated party's blind abort 2 names exactly that party, and the abort
  openings reach no one else.

The point check is a necessary condition for blindness, not a proof of it.

    python3 blind.py
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
    p = subprocess.run([RESIDC, os.path.join(HERE, src), '--root', REPO, '-o', out], cwd=REPO, capture_output=True, text=True)
    if p.returncode:
        raise RuntimeError(p.stdout + p.stderr)
    return out


def verifies(pk_hex, digest, r, s):
    pk = ec.EllipticCurvePublicKey.from_encoded_point(ec.SECP256R1(), bytes.fromhex(pk_hex))
    try:
        pk.verify(utils.encode_dss_signature(int(r, 16), int(s, 16)), digest, ec.ECDSA(utils.Prehashed(hashes.SHA256())))
        return True
    except Exception:
        return False


def run(prog, cfg_path, signers, d, tau, digest, fault='none'):
    p = subprocess.run([prog, cfg_path, ','.join(map(str, signers)), str(d), format(tau, '064x'), digest.hex(), os.urandom(32).hex(), fault],
                       capture_output=True, text=True)
    try:
        return p.returncode, json.loads(p.stdout)
    except Exception:
        raise SystemExit(f'bad output ({p.returncode}): {p.stdout[:400]} {p.stderr[:400]}')


def check_seen(res, forbidden, label):
    for pid, items in res['seen'].items():
        for it in items:
            if it.startswith('kind:'):
                raise SystemExit(f'{label}: party {pid} received a {it[5:]} message')
            if it in forbidden:
                raise SystemExit(f'{label}: party {pid} received a forbidden point {it[:20]}...')


def main():
    os.makedirs(W, exist_ok=True)
    prog = build('resid_blind_session.resid', os.path.join(W, 'resid_blind_session'))
    cases = [(2, 1, [1, 2]), (3, 1, [1, 3]), (3, 2, [1, 2, 3]), (4, 2, [2, 3, 4])]
    for n, t, signers in cases:
        rng = random.Random(1000 + 10 * n + t)
        cfg, pub, x = make_config(n, t, rng)
        path = os.path.join(W, f'blind_{n}_{t}.cfg')
        open(path, 'w').write(cfg)
        for d in signers:
            tau = rng.randrange(1, Q)
            tweaked = comp((x + tau) % Q)
            forbidden = {tweaked, comp(tau), comp(Q - tau), comp((Q - x - tau) % Q)}
            digest = hashlib.sha256(f'blind {n} {t} {d}'.encode()).digest()
            code, res = run(prog, path, signers, d, tau, digest)
            if code:
                raise SystemExit(f'{n}/{t} d={d}: {res}')
            if res['pubkey'] != tweaked:
                raise SystemExit(f'{n}/{t} d={d}: designated key is not X + tau G')
            if any(k != pub for k in res['peer_keys']):
                raise SystemExit(f'{n}/{t} d={d}: a peer holds a key other than X')
            if not verifies(tweaked, digest, res['r'], res['s']):
                raise SystemExit(f'{n}/{t} d={d}: signature does not verify under X + tau G')
            if verifies(pub, digest, res['r'], res['s']):
                raise SystemExit(f'{n}/{t} d={d}: signature also verifies under X')
            check_seen(res, forbidden, f'{n}/{t} d={d}')
            print(f'{t + 1}-of-{n} signers {signers} designated {d}: verifies under X+tau (OpenSSL), not X; peers saw no S, sigma, P or tau G')

    rng = random.Random(4242)
    cfg, pub, x = make_config(3, 2, rng)
    path = os.path.join(W, 'blind_fault.cfg')
    open(path, 'w').write(cfg)
    tau = rng.randrange(1, Q)
    digest = hashlib.sha256(b'blind faults').digest()
    code, res = run(prog, path, [1, 2, 3], 2, tau, digest, 'proof')
    if code == 0 or res.get('culprits') != [2] or 'aff-p' not in res.get('error', ''):
        raise SystemExit(f'corrupted tweak proof not refused against the designated party: {res}')
    print(f'corrupted tweak aff-p proof: refused, culprit [2] ({res["error"]})')
    for cheat in (1, 3):
        code, res = run(prog, path, [1, 2, 3], 2, tau, digest, f'chi:{cheat}')
        if code == 0 or res.get('culprits') != [cheat]:
            raise SystemExit(f'blind abort 2 did not name party {cheat}: {res}')
        forbidden = {comp((x + tau) % Q), comp(tau), comp(Q - tau)}
        check_seen(res, forbidden, f'abort cheat={cheat}')
        print(f'party {cheat} with a wrong Chi share: blind abort 2 names [{cheat}]; no peer received openings, S or P')
    print('blind tweak oracle: all pass')


if __name__ == '__main__':
    main()
