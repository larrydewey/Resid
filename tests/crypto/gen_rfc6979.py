#!/usr/bin/env python3
"""Deterministic ECDSA (RFC 6979) vectors for tests/crypto/probe.resid.

Writes tests/crypto/vectors/ecdsa_rfc6979.txt: the RFC 6979 A.2.5/A.2.6
"sample" and "test" cases plus seeded random keys and messages, each
signature made by pyca/cryptography with deterministic_signing=True and
stored as r || s. Needs python3 with cryptography >= 42; the output is
committed, so the suite itself needs neither.
"""
import os
import random
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives.asymmetric.utils import decode_dss_signature

CURVES = {"p256": (ec.SECP256R1(), 32), "p384": (ec.SECP384R1(), 48)}
HASHES = {"sha256": hashes.SHA256(), "sha384": hashes.SHA384(), "sha512": hashes.SHA512()}
RFC = {
    "p256": 0xC9AFA9D845BA75166B5C215767B1D6934E50C3DB36E89B127B8A622B120F6721,
    "p384": 0x6B9D3DAD2E1B8C1C05B19875B6659F4DE23C3B667BF297BA9AA47740787137D896D5724E4C70A825F872C9EA60D2EDF5,
}


def sign(curve, hname, d, msg):
    c, n = CURVES[curve]
    key = ec.derive_private_key(d, c)
    der = key.sign(msg, ec.ECDSA(HASHES[hname], deterministic_signing=True))
    r, s = decode_dss_signature(der)
    return r.to_bytes(n, "big") + s.to_bytes(n, "big")


def main():
    rnd = random.Random(6979)
    out = ["# RFC 6979 deterministic ECDSA, signatures from pyca/cryptography (r || s)"]
    tc = 1
    for curve, (c, n) in CURVES.items():
        for hname in HASHES:
            out.append(f"G sign {curve} {hname}")
            cases = [(RFC[curve], b"sample"), (RFC[curve], b"test")]
            for _ in range(12):
                d = rnd.randrange(1, 2 ** (8 * n))
                cases.append((d, bytes(rnd.randrange(256) for _ in range(rnd.randrange(0, 200)))))
            for d, msg in cases:
                try:
                    sig = sign(curve, hname, d, msg)
                except ValueError:
                    continue  # d >= n
                out.append(f"T {tc} valid {d.to_bytes(n, 'big').hex()} {msg.hex() or '-'} {sig.hex()}")
                tc += 1
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "vectors", "ecdsa_rfc6979.txt")
    with open(path, "w") as f:
        f.write("\n".join(out) + "\n")
    print("wrote", path, tc - 1, "tests")


if __name__ == "__main__":
    main()
