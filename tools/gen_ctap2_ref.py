#!/usr/bin/env python3
"""Writes tests/crypto/ctap2_test.resid: CTAP2 requests checked byte for byte
against python-fido2's canonical CBOR encoder, PIN protocol 2 against its
PinProtocolV2, and responses from an authenticator written here from the
CTAP 2.1 specification on `cryptography` (makeCredential and getAssertion
with hmac-secret) -- nothing from the code under test.

    python3 tools/gen_ctap2_ref.py
"""
import hashlib, hmac, os, struct
import fido2.cbor as cbor
from fido2.ctap2.pin import PinProtocolV2
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

L = lambda b: '[' + ', '.join(str(x) for x in b) + ']'
R = lambda s: '"' + s + '"'
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
V2 = PinProtocolV2()
def point(k): return k.public_key().public_bytes(serialization.Encoding.X962, serialization.PublicFormat.UncompressedPoint)
def scalar(k): return k.private_numbers().private_value.to_bytes(32, 'big')
def cose(pt, alg): return {1: 2, 3: alg, -1: 1, -2: pt[1:33], -3: pt[33:65]}

out = ['// CTAP2 (lib/ctap2.resid, lib/cborv.resid) against python-fido2 and an',
       '// authenticator written from the specification (tools/gen_ctap2_ref.py).',
       '// Generated; do not edit by hand.', '',
       'import "ctap2.resid";', 'import "cborv.resid";', 'import "crypto.resid";', '',
       'Str hx(List(Int) b) { return hex_encode(b); }',
       'Bool none_cv(Option(Cv) v) { return match v { None => true, Some(_) => false }; }', '']

# CBOR values against fido2.cbor.
vals = [0, 23, 24, 255, 256, 65536, -1, -25, -256, b'', b'\x01\x02', 'public-key', 'café', [1, [2, 3]], {1: 2, 3: -25}, True, False]
out.append('test "CBOR values decode and re-encode as python-fido2 encodes them" {')
for v in vals:
    e = cbor.encode(v)
    out.append(f'    expect(hx(cv_encode(cv_decode({L(e)}) else {{ CvNull }}))).toEqual("{e.hex()}");')
out.append('    expect(none_cv(cv_decode([161, 1]))).toBeTrue();')
out.append('    expect(none_cv(cv_decode([95, 255]))).toBeTrue();')
out.append('    expect(none_cv(cv_decode([1, 2]))).toBeTrue();')
out.append('    expect(none_cv(cv_decode([217, 1, 2]))).toBeTrue();')
deep = b'\x81' * 20 + b'\x00'
out.append(f'    expect(none_cv(cv_decode({L(deep)}))).toBeTrue();')
out.append('}\n')

# PIN protocol 2.
plat = ec.generate_private_key(ec.SECP256R1())
auth = ec.generate_private_key(ec.SECP256R1())
z = auth.exchange(ec.ECDH(), plat.public_key())
shared = V2.kdf(z)
hk, ak = shared[:32], shared[32:]
iv = os.urandom(16)
salt = os.urandom(32)
e = Cipher(algorithms.AES(ak), modes.CBC(iv)).encryptor()
salt_enc = iv + e.update(salt) + e.finalize()
assert V2.decrypt(shared, salt_enc) == salt
salt_auth = V2.authenticate(shared, salt_enc)
out.append('test "PIN protocol 2: shared secret, encrypt, decrypt and authenticate agree with PinProtocolV2" {')
out.append(f'    Pp2 k = pp2_shared({L(scalar(plat))}, {L(point(auth))});')
out.append(f'    expect(hx(k.hmac_key)).toEqual("{hk.hex()}");')
out.append(f'    expect(hx(k.aes_key)).toEqual("{ak.hex()}");')
out.append(f'    expect(hx(k.platform_pub)).toEqual("{point(plat).hex()}");')
out.append(f'    expect(hx(pp2_encrypt(k, {L(iv)}, {L(salt)}))).toEqual("{salt_enc.hex()}");')
out.append(f'    expect(hx(pp2_decrypt(k, {L(salt_enc)}))).toEqual("{salt.hex()}");')
out.append(f'    expect(hx(pp2_authenticate(k, {L(salt_enc)}))).toEqual("{salt_auth.hex()}");')
bad = bytearray(point(auth)); bad[64] ^= 1
out.append(f'    expect(pp2_shared({L(scalar(plat))}, {L(bytes(bad))}).aes_key.len()).toEqual(0);')
out.append('}\n')

# Requests.
cdh = os.urandom(32); rp = 'symbolon.unlock'; uid = os.urandom(16); user = 'device-7'
mc = b'\x01' + cbor.encode({1: cdh, 2: {'id': rp, 'name': rp}, 3: {'id': uid, 'name': user, 'displayName': user},
                             4: [{'alg': -7, 'type': 'public-key'}], 6: {'hmac-secret': True}, 7: {'rk': False}})
cred_id = os.urandom(48)
ga = b'\x02' + cbor.encode({1: rp, 2: cdh, 3: [{'id': cred_id, 'type': 'public-key'}],
                             4: {'hmac-secret': {1: cose(point(plat), -25), 2: salt_enc, 3: salt_auth, 4: 2}}, 5: {'up': True}})
out.append('test "requests are python-fido2\'s canonical encodings" {')
out.append(f'    expect(hx(req_get_info())).toEqual("04");')
kareq = bytes([6]) + cbor.encode({1: 2, 2: 2})
out.append(f'    expect(hx(req_key_agreement())).toEqual("{kareq.hex()}");')
out.append(f'    expect(hx(req_make_credential({L(cdh)}, {R(rp)}, {L(uid)}, {R(user)}))).toEqual("{mc.hex()}");')
out.append(f'    Pp2 k = pp2_shared({L(scalar(plat))}, {L(point(auth))});')
out.append(f'    expect(hx(req_hmac_assertion({L(cdh)}, {R(rp)}, {L(cred_id)}, k, {L(salt)}, {L(iv)}))).toEqual("{ga.hex()}");')
out.append('}\n')

# An authenticator: getInfo, key agreement, makeCredential, getAssertion.
aaguid = os.urandom(16)
info = b'\x00' + cbor.encode({1: ['FIDO_2_0', 'FIDO_2_1'], 2: ['credProtect', 'hmac-secret'], 3: aaguid, 4: {'rk': True, 'clientPin': False, 'up': True}, 6: [2, 1]})
ka = b'\x00' + cbor.encode({1: cose(point(auth), -25)})
credk = ec.generate_private_key(ec.SECP256R1())
cred_random = os.urandom(32)
rph = hashlib.sha256(rp.encode()).digest()
def authdata(flags, count, att=b'', ext=None):
    return rph + bytes([flags]) + struct.pack('>I', count) + att + (cbor.encode(ext) if ext is not None else b'')
att = aaguid + struct.pack('>H', len(cred_id)) + cred_id + cbor.encode(cose(point(credk), -7))
mc_ad = authdata(0x41 | 0x80, 1, att, {'hmac-secret': True})
mc_resp = b'\x00' + cbor.encode({1: 'none', 2: mc_ad, 3: {}})
mc_no_hmac = b'\x00' + cbor.encode({1: 'none', 2: authdata(0x41, 1, att), 3: {}})
mc_no_up = b'\x00' + cbor.encode({1: 'none', 2: authdata(0x40 | 0x80, 1, att, {'hmac-secret': True}), 3: {}})
# getAssertion: the authenticator decrypts and checks the salt, then answers.
assert hmac.compare_digest(V2.authenticate(shared, salt_enc), salt_auth)
outp = hmac.new(cred_random, V2.decrypt(shared, salt_enc), hashlib.sha256).digest()
enc_out = V2.encrypt(shared, outp)
ga_ad = authdata(0x81, 2, ext={'hmac-secret': enc_out})
der = credk.sign(ga_ad + cdh, ec.ECDSA(hashes.SHA256()))
ga_resp = b'\x00' + cbor.encode({1: {'id': cred_id, 'type': 'public-key'}, 2: ga_ad, 3: der})
other = ec.generate_private_key(ec.SECP256R1())
ga_badsig = b'\x00' + cbor.encode({1: {'id': cred_id, 'type': 'public-key'}, 2: ga_ad, 3: other.sign(ga_ad + cdh, ec.ECDSA(hashes.SHA256()))})
ga_noup_ad = authdata(0x80, 2, ext={'hmac-secret': enc_out})
ga_noup = b'\x00' + cbor.encode({1: {'id': cred_id, 'type': 'public-key'}, 2: ga_noup_ad, 3: credk.sign(ga_noup_ad + cdh, ec.ECDSA(hashes.SHA256()))})

out.append('test "getInfo and key agreement are read" {')
out.append(f'    Info i = info_of(resp_of({L(info)}).body);')
out.append(f'    expect(i.hmac_secret).toBeTrue();')
out.append(f'    expect(i.protocol2).toBeTrue();')
out.append(f'    expect(i.client_pin).toBeFalse();')
out.append(f'    expect(hx(i.aaguid)).toEqual("{aaguid.hex()}");')
out.append(f'    expect(str_join(i.versions, ",")).toEqual("FIDO_2_0,FIDO_2_1");')
out.append(f'    expect(hx(key_agreement_of(resp_of({L(ka)}).body))).toEqual("{point(auth).hex()}");')
out.append(f'    expect(resp_of([46]).status).toEqual(46);')
out.append('}\n')
out.append('test "a new credential is taken only with user presence, its relying party and hmac-secret" {')
out.append(f'    Made m = made_of(resp_of({L(mc_resp)}), {R(rp)});')
out.append(f'    expect(m.ok).toBeTrue();')
out.append(f'    expect(hx(m.cred_id)).toEqual("{cred_id.hex()}");')
out.append(f'    expect(hx(m.cred_point)).toEqual("{point(credk).hex()}");')
out.append(f'    expect(made_of(resp_of({L(mc_resp)}), "other.rp").why).toEqual("the key answered for another relying party");')
out.append(f'    expect(made_of(resp_of({L(mc_no_hmac)}), {R(rp)}).why).toEqual("the key did not grant hmac-secret");')
out.append(f'    expect(made_of(resp_of({L(mc_no_up)}), {R(rp)}).why).toEqual("the key was not touched");')
out.append(f'    expect(made_of(resp_of([39]), {R(rp)}).why).toEqual("the key was not touched in time, or refused (operation denied)");')
out.append('}\n')
out.append('test "the hmac-secret output comes back only with a valid assertion signature and a touch" {')
out.append(f'    Pp2 k = pp2_shared({L(scalar(plat))}, {L(point(auth))});')
out.append(f'    Got g = hmac_output_of(resp_of({L(ga_resp)}), {R(rp)}, {L(cred_id)}, {L(point(credk))}, {L(cdh)}, k);')
out.append(f'    expect(g.ok).toBeTrue();')
out.append(f'    expect(hx(g.output)).toEqual("{outp.hex()}");')
out.append(f'    expect(hmac_output_of(resp_of({L(ga_badsig)}), {R(rp)}, {L(cred_id)}, {L(point(credk))}, {L(cdh)}, k).why).toEqual("the key\'s signature does not verify");')
out.append(f'    expect(hmac_output_of(resp_of({L(ga_noup)}), {R(rp)}, {L(cred_id)}, {L(point(credk))}, {L(cdh)}, k).why).toEqual("the key was not touched");')
out.append(f'    expect(hmac_output_of(resp_of({L(ga_resp)}), {R(rp)}, {L(os.urandom(48))}, {L(point(credk))}, {L(cdh)}, k).why).toEqual("the key answered with another credential");')
out.append(f'    expect(hmac_output_of(resp_of({L(ga_resp)}), {R(rp)}, {L(cred_id)}, {L(point(credk))}, {L(os.urandom(32))}, k).why).toEqual("the key\'s signature does not verify");')
out.append('}\n')

# CTAPHID framing.
cid = 0x01020304
payload = os.urandom(200)
def frames(cid, cmd, p):
    fs = [struct.pack('>IBH', cid, cmd, len(p)) + p[:57]]
    rest, seq = p[57:], 0
    while rest:
        fs.append(struct.pack('>IB', cid, seq) + rest[:59]); rest = rest[59:]; seq += 1
    return [f.ljust(64, b'\x00') for f in fs]
fr = frames(cid, 0x90, payload)
keep = struct.pack('>IBHB', cid, 0xbb, 1, 2).ljust(64, b'\x00')
noise = struct.pack('>IBH', 0x09090909, 0x90, 3).ljust(64, b'\x00')
nonce = os.urandom(8)
init_reply = frames(0xffffffff, 0x86, nonce + struct.pack('>I', 0x0a0b0c0d) + bytes([2, 5, 4, 0, 5]))
out.append('test "CTAPHID frames and reassembly, across keep-alives and other channels" {')
out.append(f'    List(List(Int)) f = hid_frames({cid}, 144, {L(payload)});')
out.append(f'    expect(f.len()).toEqual({len(fr)});')
for i, x in enumerate(fr):
    out.append(f'    expect(hx(f[{i}])).toEqual("{x.hex()}");')
mixed = [keep, fr[0], noise, keep, fr[1], fr[2], fr[3]]
out.append(f'    HidMsg m = hid_collect([{", ".join(L(x) for x in mixed)}], {cid});')
out.append(f'    expect(m.cmd).toEqual(144);')
out.append(f'    expect(hx(m.payload)).toEqual("{payload.hex()}");')
out.append(f'    expect(hid_collect([{L(fr[0])}, {L(fr[1])}], {cid}).cmd).toEqual(-1);')
out.append(f'    expect(hid_collect([{L(fr[0])}, {L(fr[2])}], {cid}).cmd).toEqual(-2);')
out.append(f'    expect(hid_init_cid(hid_collect([{L(init_reply[0])}], 4294967295), {L(nonce)})).toEqual({0x0a0b0c0d});')
out.append(f'    expect(hid_init_cid(hid_collect([{L(init_reply[0])}], 4294967295), {L(os.urandom(8))})).toEqual(-1);')
out.append(f'    expect(hid_frames(1, 144, {L(bytes(7610))}).len()).toEqual(0);')
out.append('}')
open(os.path.join(ROOT, 'tests', 'crypto', 'ctap2_test.resid'), 'w').write('\n'.join(out) + '\n')
print('wrote tests/crypto/ctap2_test.resid')
