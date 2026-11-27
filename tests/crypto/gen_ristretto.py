#!/usr/bin/env python3
"""Vectors for lib/ristretto255g.resid from libsodium (>= 1.0.18, through
ctypes), an independent implementation of RFC 9496: writes
vectors_r255/r255.txt. Deterministic (seeded). Lines:

  B n enc                     [n]G for n = 0..31 and a few large n
  V enc 1|0                   decoding: canonical encodings and junk
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

main()
