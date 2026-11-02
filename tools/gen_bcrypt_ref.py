#!/usr/bin/env python3
"""Writes tests/crypto/bcrypt_pbkdf_test.resid: bcrypt_pbkdf outputs from
Python's `bcrypt.kdf` (OpenBSD's code), AES-CTR from `cryptography`, and a
whole passphrase-protected ed25519 key from ssh-keygen opened with them --
nothing from the code under test.

    python3 tools/gen_bcrypt_ref.py
"""
import os, subprocess, tempfile, base64, struct
import bcrypt
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
L = lambda b: '[' + ', '.join(str(x) for x in b) + ']'
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
cases = [(b'password', b'salt', 4, 32), (b'password', b'salt', 1, 48), (b'p', b'\x00' * 16, 2, 16), (os.urandom(20), os.urandom(16), 16, 48), (b'x' * 72, os.urandom(16), 3, 64)]
out = ['// bcrypt_pbkdf and AES-CTR (lib/bcrypt_pbkdf.resid) against Python\'s bcrypt',
       '// and cryptography (tools/gen_bcrypt_ref.py). Generated; do not edit.', '',
       'import "bcrypt_pbkdf.resid";', 'import "crypto.resid";', '',
       'test "bcrypt_pbkdf agrees with OpenBSD\'s (Python bcrypt.kdf)" {']
for p, s, r, n in cases:
    out.append(f'    expect(hex_encode(bcrypt_pbkdf({L(p)}, {L(s)}, {r}, {n}))).toEqual("{bcrypt.kdf(p, s, n, r, ignore_few_rounds=True).hex()}");')
out.append('    expect(bcrypt_pbkdf([], [1], 4, 32).len()).toEqual(0);')
out.append('    expect(bcrypt_pbkdf([1], [1], 0, 32).len()).toEqual(0);')
out.append('}\n')
out.append('test "AES-CTR agrees with cryptography, across a counter carry" {')
for kl in (16, 32):
    k = os.urandom(kl); iv = bytes(12) + b'\xff\xff\xff\xfe'; d = os.urandom(70)
    e = Cipher(algorithms.AES(k), modes.CTR(iv)).encryptor()
    out.append(f'    expect(hex_encode(aes_ctr({L(k)}, {L(iv)}, {L(d)}))).toEqual("{(e.update(d) + e.finalize()).hex()}");')
out.append('}\n')
W = tempfile.mkdtemp()
subprocess.run(['ssh-keygen', '-q', '-t', 'ed25519', '-N', 'correct horse', '-a', '16', '-C', 'enc@test', '-f', f'{W}/k'], check=True)
raw = base64.b64decode(''.join(l for l in open(f'{W}/k').read().splitlines() if not l.startswith('-----')))
i = 15
f = []
for _ in range(3):
    n = struct.unpack('>I', raw[i:i+4])[0]; f.append(raw[i+4:i+4+n]); i += 4 + n
assert f[0] == b'aes256-ctr' and f[1] == b'bcrypt', f[:2]
opts = f[2]; sl = struct.unpack('>I', opts[:4])[0]; salt = opts[4:4+sl]; rounds = struct.unpack('>I', opts[4+sl:8+sl])[0]
i += 4
n = struct.unpack('>I', raw[i:i+4])[0]; i += 4 + n
n = struct.unpack('>I', raw[i:i+4])[0]; sealed = raw[i+4:i+4+n]
kiv = bcrypt.kdf(b'correct horse', salt, 48, rounds)
d = Cipher(algorithms.AES(kiv[:32]), modes.CTR(kiv[32:])).decryptor()
plain = d.update(sealed) + d.finalize()
out.append('test "an ssh-keygen key protected by a passphrase opens: key and counter from bcrypt_pbkdf, then AES-256-CTR" {')
out.append(f'    List(Int) kiv = bcrypt_pbkdf({L(b"correct horse")}, {L(salt)}, {rounds}, 48);')
out.append(f'    expect(hex_encode(kiv)).toEqual("{kiv.hex()}");')
out.append(f'    expect(hex_encode(aes_ctr(kiv[0..32], kiv[32..48], {L(sealed)}))).toEqual("{plain.hex()}");')
out.append('}')
open(os.path.join(ROOT, 'tests', 'crypto', 'bcrypt_pbkdf_test.resid'), 'w').write('\n'.join(out) + '\n')
print('wrote tests/crypto/bcrypt_pbkdf_test.resid')
