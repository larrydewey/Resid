#!/usr/bin/env python3
"""Vectors for lib/ristretto255g.resid from libsodium (>= 1.0.18, through
ctypes), an independent implementation of RFC 9496: writes
vectors_r255/r255.txt. Deterministic (seeded). Lines:

  B n enc                     [n]G for n = 0..31 and a few large n
  V enc 1|0                   decoding: canonical encodings and junk; a 0
                              must be refused outright (RFC 9496 A.2's
                              invalid encodings, and s + p, p - s and
                              bit 255 set for each valid point)
  U h64 enc                   the one-way map (from_uniform)
  A p q p+q p-q               addition and subtraction
  M k p kp                    scalar multiplication (k below l)
  S op a b out                scalar add/sub/mul/neg/inv (mod l)
  R x64 out                   64 bytes reduced mod l
  P v r C                     Pedersen vG + rH, H = from_hash(SHA-512(label))
  Q v0v1v2 r C                vector commitment, G_i = from_hash(SHA-512(label || le32(i)))
"""
import ctypes, ctypes.util, hashlib, os, random, sys

lib = ctypes.CDLL(ctypes.util.find_library("sodium") or "libsodium.so.23")
assert lib.sodium_init() >= 0
B = lambda n: ctypes.create_string_buffer(n)
L = 2**252 + 27742317777372353535851937790883648493

def base(n32):
    q = B(32)
    r = lib.crypto_scalarmult_ristretto255_base(q, n32)
    return q.raw if r == 0 else bytes(32)   # libsodium refuses an identity result

def mul(n32, p):
    q = B(32)
    r = lib.crypto_scalarmult_ristretto255(q, n32, p)
    return q.raw if r == 0 else bytes(32)

# libsodium 1.0.18 ignores bit 255 of an encoding; RFC 9496 §4.3.1 does
# not (s must be below p, and every value with bit 255 set is above it),
# so such an encoding is invalid here whatever libsodium answers.
def valid(p):
    if p[31] & 0x80: return False
    return lib.crypto_core_ristretto255_is_valid_point(p) == 1 or p == bytes(32)

def from_hash(h):
    q = B(32); assert lib.crypto_core_ristretto255_from_hash(q, h) == 0; return q.raw

def add(p, q):
    o = B(32); assert lib.crypto_core_ristretto255_add(o, p, q) == 0; return o.raw

def sub(p, q):
    o = B(32); assert lib.crypto_core_ristretto255_sub(o, p, q) == 0; return o.raw

def sc(n): return (n % L).to_bytes(32, "little")

# RFC 9496 Appendix A.2: encodings that MUST be rejected.
RFC_A2 = [
    # Non-canonical field encodings.
    "00ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
    "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7f",
    "f3ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7f",
    "edffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7f",
    # Negative field elements.
    "0100000000000000000000000000000000000000000000000000000000000000",
    "01ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7f",
    "ed57ffd8c914fb201471d1c3d245ce3c746fcbe63a3679d51b6a516ebebe0e20",
    "c34c4e1826e5d403b78e246e88aa051c36ccf0aafebffe137d148a2bf9104562",
    "c940e5a4404157cfb1628b108db051a8d439e1a421394ec4ebccb9ec92a8ac78",
    "47cfc5497c53dc8e61c91d17fd626ffb1c49e2bca94eed052281b510b1117a24",
    "f1c6165d33367351b0da8f6e4511010c68174a03b6581212c71c0e1d026c3c72",
    "87260f7a2f12495118360f02c26a470f450dadf34a413d21042b43b9d93e1309",
    # Non-square x^2.
    "26948d35ca62e643e26a83177332e6b6afeb9d08e4268b650f1f5bbd8d81d371",
    "4eac077a713c57b4f4397629a4145982c661f48044dd3f96427d40b147d9742f",
    "de6a7b00deadc788eb6b6c8d20c0ae96c2f2019078fa604fee5b87d6e989ad7b",
    "bcab477be20861e01e4a0e295284146a510150d9817763caf1a6f4b422d67042",
    "2a292df7e32cababbd9de088d1d1abec9fc0440f637ed2fba145094dc14bea08",
    "f4a9e534fc0d216c44b218fa0c42d99635a0127ee2e53c712f70609649fdff22",
    "8268436f8c4126196cf64b3c7ddbda90746a378625f9813dd9b8457077256731",
    "2810e5cbc2cc4d4eece54f61c6f69758e289aa7ab440b3cbeaa21995c2f4232b",
    # Negative x * y value.
    "3eb858e78f5a7254d8c9731174a94f76755fd3941c0ac93735c07ba14579630e",
    "a45fdc55c76448c049a1ab33f17023edfb2be3581e9c7aade8a6125215e04220",
    "d483fe813c6ba647ebbfd3ec41adca1c6130c2beeee9d9bf065c8d151c5f396e",
    "8a2e1d30050198c65a54483123960ccc38aef6848e1ec8f5f780e8523769ba32",
    "32888462f8b486c68ad7dd9610be5192bbeaf3b443951ac1a8118419d9fa097b",
    "227142501b9d4355ccba290404bde41575b037693cef1f438c47f8fbf35d1165",
    "5c37cc491da847cfeb9281d407efc41e15144c876e0170b499a96a22ed31e01e",
    "445425117cb8c90edcbc7c1cc0e74f747f2c1efa5630a967c64f287792a48a4b",
    # s = -1, which causes y = 0.
    "ecffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7f",
]

def main():
    rnd = random.Random(9496)
    rb = lambda n: bytes(rnd.getrandbits(8) for _ in range(n))
    out = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "vectors_r255", "r255.txt"), "w")
    w = lambda *a: out.write(" ".join(a) + "\n")
    ns = list(range(32)) + [L - 1, L - 2, 2**200 + 5, rnd.randrange(L), rnd.randrange(L)]
    for n in ns:
        w("B", str(n), (bytes(32) if n % L == 0 else base(sc(n))).hex())
    pts = [base(sc(rnd.randrange(1, L))) for _ in range(24)]
    for p in pts:
        w("V", p.hex(), "1")
        for _ in range(3):   # one bit flipped: usually not canonical
            j = rnd.randrange(256); m = bytearray(p); m[j // 8] ^= 1 << (j % 8); m = bytes(m)
            w("V", m.hex(), "1" if valid(m) else "0")
    for _ in range(64):
        m = rb(32); w("V", m.hex(), "1" if valid(m) else "0")
    P = 2**255 - 19
    for x in [P, P + 1, 2**255 - 1, 1, P - 1]:
        m = x.to_bytes(32, "little"); w("V", m.hex(), "1" if valid(m) else "0")
    w("V", bytes(32).hex(), "1")
    for _ in range(32):
        h = rb(64); w("U", h.hex(), from_hash(h).hex())
    for i in range(16):
        p, q = pts[i], pts[(i * 5 + 3) % 24]
        w("A", p.hex(), q.hex(), add(p, q).hex(), sub(p, q).hex())
    for i in range(16):
        k = sc(rnd.randrange(L)); p = pts[i]
        w("M", k.hex(), p.hex(), mul(k, p).hex())
    for _ in range(12):
        a, b = rnd.randrange(L), rnd.randrange(L)
        w("S", "add", sc(a).hex(), sc(b).hex(), sc(a + b).hex())
        w("S", "sub", sc(a).hex(), sc(b).hex(), sc(a - b).hex())
        w("S", "mul", sc(a).hex(), sc(b).hex(), sc(a * b).hex())
        w("S", "neg", sc(a).hex(), sc(0).hex(), sc(-a).hex())
        w("S", "inv", sc(a).hex(), sc(0).hex(), sc(pow(a, L - 2, L)).hex())
    for x in [bytes(64), b"\xff" * 64] + [rb(64) for _ in range(10)]:
        w("R", x.hex(), sc(int.from_bytes(x, "little")).hex())
    H = from_hash(hashlib.sha512(b"resid/pedersen/H/v1").digest())
    for _ in range(12):
        v, r = rnd.randrange(L), rnd.randrange(L)
        c = add(base(sc(v)) if v else bytes(32), mul(sc(r), H) if r else bytes(32))
        w("P", sc(v).hex(), sc(r).hex(), c.hex())
    G = [from_hash(hashlib.sha512(b"resid/pedersen/G/v1" + i.to_bytes(4, "little")).digest()) for i in range(3)]
    for _ in range(4):
        vs = [rnd.randrange(1, L) for _ in range(3)]; r = rnd.randrange(1, L)
        c = mul(sc(r), H)
        for i in range(3): c = add(c, mul(sc(vs[i]), G[i]))
        w("Q", "".join(sc(v).hex() for v in vs), sc(r).hex(), c.hex())
    for v in [0, 1, 2**64 - 1]:
        r = rnd.randrange(1, L)
        c = add(base(sc(v)) if v else bytes(32), mul(sc(r), H))
        w("P", sc(v).hex(), sc(r).hex(), c.hex())
    # Encodings that must be refused (appended, so the lines above keep
    # their order): the RFC's, then three non-canonical forms of each valid
    # point's s -- the same field element written as s + p, its negation
    # p - s (odd, so "negative"), and s with bit 255 set.
    assert len(RFC_A2) == 29
    for h in RFC_A2:
        assert not valid(bytes.fromhex(h)), h
        w("V", h, "0")
    for p in pts:
        s = int.from_bytes(p, "little")
        assert 0 < s < P and s % 2 == 0
        for x in (s + P, P - s, s | (1 << 255)):
            w("V", x.to_bytes(32, "little").hex(), "0")

main()
