#!/usr/bin/env python3
"""Writes tests/crypto/rsasign_test.resid: PKCS#1 v1.5 signatures by RSA keys
of 2048, 3072, 3000 and 4096 bits from Python's `cryptography` (the scheme
is deterministic, so they must agree byte for byte), and keys that must be
refused -- nothing from the code under test.

    python3 tools/gen_rsasign_ref.py
"""
import os
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import rsa, padding

L = lambda b: '[' + ', '.join(str(x) for x in b) + ']'
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
def be(v): return v.to_bytes((v.bit_length() + 7) // 8, 'big')
out = ['// RSA signing (lib/rsasign.resid) against Python\'s cryptography', '// (tools/gen_rsasign_ref.py). Generated; do not edit by hand.', '',
       'import "rsasign.resid";', 'import "hash.resid";', 'import "word.resid";', 'import "crypto.resid";', '']
for bits in (2048, 3072, 3000, 4096):
    k = rsa.generate_private_key(public_exponent=65537, key_size=bits)
    n = k.private_numbers()
    msg = os.urandom(50)
    out.append('@requires(declassify)')
    out.append(f'test "RSA-{bits}: rsa-sha2-256 and rsa-sha2-512 signatures equal cryptography\'s" {{')
    args = f'{L(be(n.public_numbers.n))}, {L(be(n.public_numbers.e))}, secret_bytes({L(be(n.d))}), secret_bytes({L(be(n.p))}), secret_bytes({L(be(n.q))}), secret_bytes({L(be(n.iqmp))})'
    for hn, h in (('Sha256', hashes.SHA256()), ('Sha512', hashes.SHA512())):
        out.append(f'    expect(hex_encode(rsa_pkcs1_sign({hn}, {args}, {L(msg)}))).toEqual("{k.sign(msg, padding.PKCS1v15(), h).hex()}");')
    if bits == 2048:
        # A wrong iqmp makes a faulty CRT signature: refused, not released.
        bad = f'{L(be(n.public_numbers.n))}, {L(be(n.public_numbers.e))}, secret_bytes({L(be(n.d))}), secret_bytes({L(be(n.p))}), secret_bytes({L(be(n.q))}), secret_bytes({L(be((n.iqmp + 1) % n.p))})'
        out.append(f'    expect(rsa_pkcs1_sign(Sha256, {bad}, {L(msg)}).len()).toEqual(0);')
        # p and q swapped is still a valid key (iqmp then wrong): refused too.
        out.append(f'    expect(rsa_pkcs1_sign(Sha256, {L(be(n.public_numbers.n))}, {L(be(n.public_numbers.e))}, secret_bytes({L(be(n.d))}), secret_bytes({L(be(n.q))}), secret_bytes({L(be(n.p))}), secret_bytes({L(be(n.iqmp))}), {L(msg)}).len()).toEqual(0);')
        out.append(f'    expect(rsa_pkcs1_sign(Sha1, {args}, {L(msg)}).len()).toEqual(0);')
    out.append('}\n')
open(os.path.join(ROOT, 'tests', 'crypto', 'rsasign_test.resid'), 'w').write('\n'.join(out) + '\n')
print('wrote tests/crypto/rsasign_test.resid')
