#!/usr/bin/env python3
"""COSE_Sign1 vectors for tests/crypto/probe.resid (vectors/cose_sign1.txt).

Each group is a public key (SPKI DER, or a COSE_Key with "ckey"); each test
a COSE_Sign1 and the payload it must yield, or "invalid". Signatures are
made with pyca/cryptography, the CBOR with cbor2; the output is committed.
"""
import os
import random
import cbor2
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ec, ed25519, padding, rsa
from cryptography.hazmat.primitives.asymmetric.utils import decode_dss_signature

rnd = random.Random(9052)


def spki(pub):
    return pub.public_bytes(serialization.Encoding.DER, serialization.PublicFormat.SubjectPublicKeyInfo)


def sig_structure(prot, payload, aad=b""):
    return cbor2.dumps(["Signature1", prot, aad, payload])


def sign(key, alg, data):
    if alg in (-7, -35):
        h = hashes.SHA256() if alg == -7 else hashes.SHA384()
        n = 32 if alg == -7 else 48
        r, s = decode_dss_signature(key.sign(data, ec.ECDSA(h)))
        return r.to_bytes(n, "big") + s.to_bytes(n, "big")
    if alg == -8:
        return key.sign(data)
    h = {-37: hashes.SHA256(), -38: hashes.SHA384(), -39: hashes.SHA512(),
         -257: hashes.SHA256(), -258: hashes.SHA384(), -259: hashes.SHA512()}[alg]
    if alg in (-37, -38, -39):
        return key.sign(data, padding.PSS(mgf=padding.MGF1(h), salt_length=h.digest_size), h)
    return key.sign(data, padding.PKCS1v15(), h)


def msg(key, alg, payload, tagged=True, prot_extra=None, unprot=None, sig_alg=None, trailing=b""):
    p = {1: alg}
    if prot_extra:
        p.update(prot_extra)
    prot = cbor2.dumps(p)
    sig = sign(key, sig_alg or alg, sig_structure(prot, payload))
    body = [prot, unprot or {}, payload, sig]
    out = cbor2.dumps(cbor2.CBORTag(18, body) if tagged else body)
    return out + trailing


def main():
    out = ["# COSE_Sign1 vectors (gen_cose.py): pyca/cryptography signatures, cbor2 encoding"]
    tc = 1
    p256 = ec.generate_private_key(ec.SECP256R1())
    p384 = ec.generate_private_key(ec.SECP384R1())
    edk = ed25519.Ed25519PrivateKey.generate()
    rsak = rsa.generate_private_key(public_exponent=65537, key_size=3072)
    cases = [(p256, -7), (p384, -35), (edk, -8), (rsak, -37), (rsak, -38), (rsak, -39), (rsak, -257), (rsak, -258)]

    def t(valid, blob, payload):
        nonlocal tc
        out.append(f"T {tc} {'valid' if valid else 'invalid'} {blob.hex()} {payload.hex() or '-'}")
        tc += 1

    for key, alg in cases:
        out.append(f"G cose spki {spki(key.public_key()).hex()}")
        for _ in range(3):
            pl = bytes(rnd.randrange(256) for _ in range(rnd.randrange(0, 300)))
            t(True, msg(key, alg, pl), pl)
        pl = b"attestation document"
        t(True, msg(key, alg, pl, tagged=False), pl)              # Nitro: untagged
        t(True, msg(key, alg, pl, unprot={4: b"kid"}), pl)       # unprotected kid
        good = msg(key, alg, pl)
        t(False, good[:-1] + bytes([good[-1] ^ 1]), pl)          # signature bit flip
        t(False, msg(key, alg, pl, trailing=b"\x00"), pl)        # trailing byte
        t(False, cbor2.dumps(cbor2.CBORTag(17, cbor2.loads(good).value)), pl)  # wrong tag
        # alg only in the unprotected header: not covered, so refused
        prot = cbor2.dumps({})
        s = sign(key, alg, sig_structure(prot, pl))
        t(False, cbor2.dumps(cbor2.CBORTag(18, [prot, {1: alg}, pl, s])), pl)
        # payload swapped after signing
        body = cbor2.loads(good).value
        t(False, cbor2.dumps(cbor2.CBORTag(18, [body[0], body[1], pl + b"!", body[3]])), pl)
    # ES384 header over a P-256 key: the curve does not match the algorithm.
    out.append(f"G cose spki {spki(p256.public_key()).hex()}")
    t(False, msg(p256, -35, b"x", sig_alg=-7), b"x")
    # PS256 header but a PKCS#1 signature.
    out.append(f"G cose spki {spki(rsak.public_key()).hex()}")
    t(False, msg(rsak, -37, b"x", sig_alg=-257), b"x")
    # COSE_Key forms of the same keys.
    for key, crv, n in ((p256, 1, 32), (p384, 2, 48)):
        nums = key.public_key().public_numbers()
        ck = cbor2.dumps({1: 2, -1: crv, -2: nums.x.to_bytes(n, "big"), -3: nums.y.to_bytes(n, "big")})
        out.append(f"G cose ckey {ck.hex()}")
        t(True, msg(key, -7 if n == 32 else -35, b"cose key"), b"cose key")
    edraw = edk.public_key().public_bytes(serialization.Encoding.Raw, serialization.PublicFormat.Raw)
    out.append(f"G cose ckey {cbor2.dumps({1: 1, -1: 6, -2: edraw}).hex()}")
    t(True, msg(edk, -8, b"cose key"), b"cose key")
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "vectors", "cose_sign1.txt")
    with open(path, "w") as f:
        f.write("\n".join(out) + "\n")
    print("wrote", path, tc - 1, "tests")


if __name__ == "__main__":
    main()
