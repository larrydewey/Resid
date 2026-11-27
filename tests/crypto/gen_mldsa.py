#!/usr/bin/env python3
"""Vectors for lib/mldsa.resid: NIST ACVP ML-DSA (FIPS 204) keyGen, sigGen
and sigVer, converted from a checkout of usnistgov/ACVP-Server
(gen-val/json-files/ML-DSA-*-FIPS204), plus signatures made by OpenSSL
through pyca/cryptography (verified here, so this also checks
interoperability). Writes vectors_mldsa/mldsa.txt. Lines ("-" is empty):

  K set seed pk sk
  G set iface msg ctx rnd sk sig      iface: external | internal | mu
  V set iface pk msg ctx sig 1|0

Each group contributes its PER_GROUP shortest-message tests (every
valid/invalid sigVer reason is still represented). HashML-DSA (preHash)
groups are skipped: lib/mldsa.resid has no
pre-hash variant.

Usage: gen_mldsa.py <ACVP-Server checkout>
"""
import json, os, sys

root = os.path.join(sys.argv[1], "gen-val", "json-files")
out = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "vectors_mldsa", "mldsa.txt"), "w")
# The shortest messages of each group, to keep the committed file small.
PER_GROUP = 4
h = lambda s: (s or "").lower() or "-"

def load(name):
    p = json.load(open(os.path.join(root, name, "prompt.json")))
    e = json.load(open(os.path.join(root, name, "expectedResults.json")))
    exp = {(g["tgId"], t["tcId"]): t for g in e["testGroups"] for t in g["tests"]}
    return p, exp

def iface(g):
    if g.get("signatureInterface") == "external":
        return None if g.get("preHash") == "preHash" else "external"
    return "mu" if g.get("externalMu") else "internal"

p, exp = load("ML-DSA-keyGen-FIPS204")
for g in p["testGroups"]:
    for t in g["tests"][:PER_GROUP]:
        e = exp[(g["tgId"], t["tcId"])]
        out.write(f"K {g['parameterSet']} {h(t['seed'])} {h(e['pk'])} {h(e['sk'])}\n")

p, exp = load("ML-DSA-sigGen-FIPS204")
for g in p["testGroups"]:
    i = iface(g)
    if i is None: continue
    for t in sorted(g["tests"], key=lambda t: len(t.get("message") or ""))[:PER_GROUP]:
        e = exp[(g["tgId"], t["tcId"])]
        msg = t.get("mu") if i == "mu" else t.get("message")
        rnd = "00" * 32 if g["deterministic"] else t["rnd"]
        out.write(f"G {g['parameterSet']} {i} {h(msg)} {h(t.get('context'))} {h(rnd)} {h(t['sk'])} {h(e['signature'])}\n")

p, exp = load("ML-DSA-sigVer-FIPS204")
for g in p["testGroups"]:
    i = iface(g)
    if i is None: continue
    for t in sorted(g["tests"], key=lambda t: len(t.get("message") or ""))[:PER_GROUP]:
        e = exp[(g["tgId"], t["tcId"])]
        msg = t.get("mu") if i == "mu" else t.get("message")
        out.write(f"V {g['parameterSet']} {i} {h(t['pk'])} {h(msg)} {h(t.get('context'))} {h(t['signature'])} {1 if e['testPassed'] else 0}\n")

try:
    from cryptography.hazmat.primitives.asymmetric import mldsa
    from cryptography.hazmat.primitives import serialization
    import random
    rnd = random.Random(204)
    for name, cls in [("ML-DSA-44", mldsa.MLDSA44PrivateKey), ("ML-DSA-65", mldsa.MLDSA65PrivateKey), ("ML-DSA-87", mldsa.MLDSA87PrivateKey)]:
        for n in range(4):
            k = cls.from_seed_bytes(bytes(rnd.getrandbits(8) for _ in range(32)))
            pk = k.public_key().public_bytes(serialization.Encoding.Raw, serialization.PublicFormat.Raw)
            m = bytes(rnd.getrandbits(8) for _ in range(rnd.randrange(0, 200)))
            ctx = bytes(rnd.getrandbits(8) for _ in range(n * 17))
            sig = k.sign(m, ctx) if ctx else k.sign(m)
            out.write(f"V {name} external {pk.hex()} {h(m.hex())} {h(ctx.hex())} {sig.hex()} 1\n")
            bad = bytearray(sig); bad[len(sig) // 2] ^= 4
            out.write(f"V {name} external {pk.hex()} {h(m.hex())} {h(ctx.hex())} {bytes(bad).hex()} 0\n")
except ImportError:
    print("note: OpenSSL interop vectors skipped (no pyca/cryptography with ML-DSA)", file=sys.stderr)
