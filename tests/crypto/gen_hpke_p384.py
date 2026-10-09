#!/usr/bin/env python3
"""DHKEM(P-384) HPKE interop vectors (vectors/hpke_p384_pyca.txt).

RFC 9180 publishes no P-384 vectors, so these come from pyca/cryptography
(>= 46): each test is a base-mode single-shot message (enc || ct, empty
AAD) that Resid must open with the recipient's private key. Committed; the
suite does not need python.
"""
import os
import random
from cryptography.hazmat.primitives import hpke
from cryptography.hazmat.primitives.asymmetric import ec

KDFS = {1: hpke.KDF.HKDF_SHA256, 2: hpke.KDF.HKDF_SHA384, 3: hpke.KDF.HKDF_SHA512}
AEADS = {1: hpke.AEAD.AES_128_GCM, 2: hpke.AEAD.AES_256_GCM, 3: hpke.AEAD.CHACHA20_POLY1305}


def main():
    rnd = random.Random(384)
    out = ["# DHKEM(P-384) HPKE base mode, sealed by pyca/cryptography (enc || ct)"]
    tc = 1
    for kdf, k in KDFS.items():
        for aead, a in AEADS.items():
            sk = ec.generate_private_key(ec.SECP384R1())
            skb = sk.private_numbers().private_value.to_bytes(48, "big")
            out.append(f"G hpkeo 17 {kdf} {aead} {skb.hex()}")
            suite = hpke.Suite(hpke.KEM.P384, k, a)
            for _ in range(3):
                info = bytes(rnd.randrange(256) for _ in range(rnd.randrange(0, 40)))
                pt = bytes(rnd.randrange(256) for _ in range(rnd.randrange(0, 100)))
                blob = suite.encrypt(pt, sk.public_key(), info=info)
                out.append(f"T {tc} valid {info.hex() or '-'} {pt.hex() or '-'} {blob.hex()}")
                tc += 1
                bad = bytearray(blob)
                bad[-1] ^= 1
                out.append(f"T {tc} invalid {info.hex() or '-'} {pt.hex() or '-'} {bytes(bad).hex()}")
                tc += 1
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "vectors", "hpke_p384_pyca.txt")
    with open(path, "w") as f:
        f.write("\n".join(out) + "\n")
    print("wrote", path, tc - 1, "tests")


if __name__ == "__main__":
    main()
