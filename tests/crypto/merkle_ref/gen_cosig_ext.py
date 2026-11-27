#!/usr/bin/env python3
"""Known answers for cosignature/v1 over a checkpoint WITH extension lines
(c2sp.org/tlog-cosignature, Ed25519: the signed message is the header
lines, then origin, size, root hash and every extension line), made with
pyca/cryptography's Ed25519, independently of lib/merkle.resid. Prints the
constants tests/crypto/merkle_redteam_test.resid holds.

The Go generator (main.go) builds on golang.org/x/mod, which has no
cosignature code; this needs python3 and cryptography only.
"""
import base64, hashlib
from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey
from cryptography.hazmat.primitives import serialization

def line(seed, name, body, t):
    key = Ed25519PrivateKey.from_private_bytes(seed)
    pub = key.public_key().public_bytes(serialization.Encoding.Raw, serialization.PublicFormat.Raw)
    kid = hashlib.sha256(name.encode() + b"\n\x04" + pub).digest()[:4]
    msg = b"cosignature/v1\ntime %d\n" % t + body
    return "— " + name + " " + base64.b64encode(kid + t.to_bytes(8, "big") + key.sign(msg)).decode() + "\n"

seed = hashlib.sha256(b"merkle redteam witness").digest()
root = base64.b64encode(hashlib.sha256(bytes([7])).digest())
three = b"log.example\n7\n" + root + b"\n"
print("with extension lines:", line(seed, "witness.example", three + b"extension one\nx=2\n", 1700000000), end="")
print("three lines only:    ", line(seed, "witness.example", three, 1700000000), end="")
