#!/usr/bin/env python3
"""Fixtures for tests/attest (run once; the output is committed).

A test chain shaped like AMD's: an RSA-4096 ARK (RSASSA-PSS SHA-384,
self-signed), an ASK it signs, a P-384 VCEK with AMD's extensions (product
name, SPLs, hardware ID), an empty CRL from the ARK, an unsigned report
template whose TCB and CHIP_ID match the VCEK, the VCEK's private scalar
(the tests sign reports with it), and an X25519 release sender key pair.
Writes fixtures/*.bin|der and fixtures/testing.resid (copied into the
private RESID_HOME's lib/verify/ by run.sh).
"""
import datetime, hashlib, os, struct, sys
from cryptography import x509
from cryptography.x509.oid import NameOID, ObjectIdentifier
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import rsa, ec, padding, x25519

D = os.path.join(os.path.dirname(os.path.abspath(__file__)), "fixtures")
PSS = padding.PSS(mgf=padding.MGF1(hashes.SHA384()), salt_length=48)
NB = datetime.datetime(2024, 1, 1)
NA = datetime.datetime(2040, 1, 1)
BL, TEE, SNP, UCODE = 3, 0, 8, 115
HWID = bytes(range(1, 65))

def name(cn):
    return x509.Name([x509.NameAttribute(NameOID.ORGANIZATIONAL_UNIT_NAME, "Engineering"),
                      x509.NameAttribute(NameOID.COUNTRY_NAME, "US"),
                      x509.NameAttribute(NameOID.ORGANIZATION_NAME, "Resid Test Devices"),
                      x509.NameAttribute(NameOID.COMMON_NAME, cn)])

def ca(subject, issuer, key, signer, serial):
    b = (x509.CertificateBuilder().subject_name(subject).issuer_name(issuer)
         .public_key(key.public_key()).serial_number(serial).not_valid_before(NB).not_valid_after(NA)
         .add_extension(x509.BasicConstraints(ca=True, path_length=None), critical=True)
         .add_extension(x509.KeyUsage(digital_signature=False, content_commitment=False, key_encipherment=False,
                                      data_encipherment=False, key_agreement=False, key_cert_sign=True,
                                      crl_sign=True, encipher_only=False, decipher_only=False), critical=True))
    return b.sign(signer, hashes.SHA384(), rsa_padding=PSS)

def der_int(v):
    b = v.to_bytes(max(1, (v.bit_length() + 8) // 8), "big")
    return bytes([2, len(b)]) + b

def amd(tail):
    return ObjectIdentifier("1.3.6.1.4.1.3704.1." + tail)

ark_k = rsa.generate_private_key(65537, 4096)
ask_k = rsa.generate_private_key(65537, 4096)
vcek_k = ec.generate_private_key(ec.SECP384R1())
ark = ca(name("ARK-Milan"), name("ARK-Milan"), ark_k, ark_k, 1)
ask = ca(name("SEV-Milan"), name("ARK-Milan"), ask_k, ark_k, 2)
pn = b"Milan-B0"
exts = [("1", der_int(0)), ("2", bytes([22, len(pn)]) + pn), ("3.1", der_int(BL)), ("3.2", der_int(TEE)),
        ("3.3", der_int(SNP)), ("3.8", der_int(UCODE)), ("4", HWID)]
vb = (x509.CertificateBuilder().subject_name(name("SEV-VCEK")).issuer_name(name("SEV-Milan"))
      .public_key(vcek_k.public_key()).serial_number(3).not_valid_before(NB).not_valid_after(NA))
for t, v in exts:
    vb = vb.add_extension(x509.UnrecognizedExtension(amd(t), v), critical=False)
vcek = vb.sign(ask_k, hashes.SHA384(), rsa_padding=PSS)
crl = (x509.CertificateRevocationListBuilder().issuer_name(name("ARK-Milan"))
       .last_update(NB).next_update(NA).add_extension(x509.CRLNumber(12), critical=False)
       .sign(ark_k, hashes.SHA384(), rsa_padding=PSS))
# An older CRL (below the Milan floor).
crl_old = (x509.CertificateRevocationListBuilder().issuer_name(name("ARK-Milan"))
           .last_update(NB).next_update(NA).add_extension(x509.CRLNumber(11), critical=False)
           .sign(ark_k, hashes.SHA384(), rsa_padding=PSS))
# A CRL that revokes the ASK.
crl_rev = (x509.CertificateRevocationListBuilder().issuer_name(name("ARK-Milan"))
           .last_update(NB).next_update(NA).add_extension(x509.CRLNumber(13), critical=False)
           .add_revoked_certificate(x509.RevokedCertificateBuilder().serial_number(2).revocation_date(NB).build())
           .sign(ark_k, hashes.SHA384(), rsa_padding=PSS))

def tcb(bl, tee, snp, uc):
    return bl | (tee << 8) | (snp << 48) | (uc << 56)

r = bytearray(1184)
struct.pack_into("<I", r, 0x00, 2)            # version
struct.pack_into("<Q", r, 0x08, 0x30000)       # policy: SMT, reserved bit 17
struct.pack_into("<I", r, 0x30, 0)             # vmpl
struct.pack_into("<I", r, 0x34, 1)             # signature_algo
struct.pack_into("<Q", r, 0x38, tcb(BL, TEE, SNP, UCODE))
r[0x90:0xC0] = hashlib.sha384(b"resid test image").digest()
struct.pack_into("<Q", r, 0x180, tcb(BL, TEE, SNP, UCODE))   # reported
r[0x1A0:0x1E0] = HWID
struct.pack_into("<Q", r, 0x1E0, tcb(BL, TEE, SNP, UCODE))   # committed
struct.pack_into("<Q", r, 0x1F0, tcb(BL, TEE, SNP, UCODE))   # launch

# A test Nitro chain: P-384 root, intermediate and leaf, ECDSA SHA-384.
def ec_ca(subject, issuer, key, signer, serial, is_ca=True):
    b = (x509.CertificateBuilder().subject_name(subject).issuer_name(issuer)
         .public_key(key.public_key()).serial_number(serial).not_valid_before(NB).not_valid_after(NA)
         .add_extension(x509.BasicConstraints(ca=is_ca, path_length=None), critical=True))
    if is_ca:
        b = b.add_extension(x509.KeyUsage(digital_signature=True, content_commitment=False, key_encipherment=False,
                                          data_encipherment=False, key_agreement=False, key_cert_sign=True,
                                          crl_sign=True, encipher_only=False, decipher_only=False), critical=True)
    return b.sign(signer, hashes.SHA384())

nroot_k = ec.generate_private_key(ec.SECP384R1())
nint_k = ec.generate_private_key(ec.SECP384R1())
nleaf_k = ec.generate_private_key(ec.SECP384R1())
nroot = ec_ca(name("test.nitro-enclaves"), name("test.nitro-enclaves"), nroot_k, nroot_k, 11)
nint = ec_ca(name("test-zonal"), name("test.nitro-enclaves"), nint_k, nroot_k, 12)
nleaf = ec_ca(name("test-enclave"), name("test-zonal"), nleaf_k, nint_k, 13, is_ca=False)

# A TPM attestation key (P-256), pinned by a test anchor as its SPKI.
ak_k = ec.generate_private_key(ec.SECP256R1())
ak_spki = ak_k.public_key().public_bytes(serialization.Encoding.DER, serialization.PublicFormat.SubjectPublicKeyInfo)

# A test Intel-like PCK chain (P-256) and a quoting enclave's report,
# signed by the PCK key, binding a test attestation key: the tests then
# build TDX quotes around any REPORTDATA and sign them with that key.
def ec256_ca(subject, issuer, key, signer, serial, is_ca=True):
    b = (x509.CertificateBuilder().subject_name(subject).issuer_name(issuer)
         .public_key(key.public_key()).serial_number(serial).not_valid_before(NB).not_valid_after(NA)
         .add_extension(x509.BasicConstraints(ca=is_ca, path_length=None), critical=True))
    if is_ca:
        b = b.add_extension(x509.KeyUsage(digital_signature=False, content_commitment=False, key_encipherment=False,
                                          data_encipherment=False, key_agreement=False, key_cert_sign=True,
                                          crl_sign=True, encipher_only=False, decipher_only=False), critical=True)
    return b.sign(signer, hashes.SHA256())

iroot_k = ec.generate_private_key(ec.SECP256R1())
ica_k = ec.generate_private_key(ec.SECP256R1())
ipck_k = ec.generate_private_key(ec.SECP256R1())
iroot = ec256_ca(name("Test SGX Root CA"), name("Test SGX Root CA"), iroot_k, iroot_k, 21)
ica = ec256_ca(name("Test SGX PCK Platform CA"), name("Test SGX Root CA"), ica_k, iroot_k, 22)

# The PCK certificate's SGX extensions (1.2.840.113741.1.13.1): PPID, the
# TCB (sixteen SVNs, PCESVN, CPUSVN), PCE ID, FMSPC.
def der(tag, body):
    n = len(body)
    ln = bytes([n]) if n < 128 else (bytes([0x81, n]) if n < 256 else bytes([0x82, n >> 8, n & 255]))
    return bytes([tag]) + ln + body
def oid(dotted):
    parts = [int(x) for x in dotted.split(".")]
    out = bytes([40 * parts[0] + parts[1]])
    for v in parts[2:]:
        enc = [v & 127]
        v >>= 7
        while v:
            enc.insert(0, (v & 127) | 128); v >>= 7
        out += bytes(enc)
    return der(6, out)
def dint(v):
    b = v.to_bytes(max(1, (v.bit_length() + 8) // 8), "big")
    return der(2, b)
SGX = "1.2.840.113741.1.13.1"
SVN, PCESVN = 2, 11
FMSPC, PCEID = bytes.fromhex("00906ed50000"), bytes.fromhex("0000")
tcb_items = b"".join(der(0x30, oid(f"{SGX}.2.{i}") + dint(SVN)) for i in range(1, 17))
tcb_items += der(0x30, oid(f"{SGX}.2.17") + dint(PCESVN)) + der(0x30, oid(f"{SGX}.2.18") + der(4, bytes([SVN] * 16)))
sgx_ext = der(0x30, der(0x30, oid(f"{SGX}.1") + der(4, bytes(16))) + der(0x30, oid(f"{SGX}.2") + der(0x30, tcb_items))
              + der(0x30, oid(f"{SGX}.3") + der(4, PCEID)) + der(0x30, oid(f"{SGX}.4") + der(4, FMSPC)))
ipck = (x509.CertificateBuilder().subject_name(name("Test SGX PCK Certificate")).issuer_name(name("Test SGX PCK Platform CA"))
        .public_key(ipck_k.public_key()).serial_number(23).not_valid_before(NB).not_valid_after(NA)
        .add_extension(x509.BasicConstraints(ca=False, path_length=None), critical=True)
        .add_extension(x509.UnrecognizedExtension(ObjectIdentifier(SGX), sgx_ext), critical=False)
        .sign(ica_k, hashes.SHA256()))

# Collateral: a TCB signing certificate under the test root, and the TCB
# info and QE identity it signs over their exact bytes.
itcb_k = ec.generate_private_key(ec.SECP256R1())
itcb = ec256_ca(name("Test SGX TCB Signing"), name("Test SGX Root CA"), itcb_k, iroot_k, 24, is_ca=False)
def signed_json(member, body):
    from cryptography.hazmat.primitives.asymmetric.utils import decode_dss_signature as dds
    r_, s_ = dds(itcb_k.sign(body.encode(), ec.ECDSA(hashes.SHA256())))
    return ('{"' + member + '":' + body + ',"signature":"' + (r_.to_bytes(32, "big") + s_.to_bytes(32, "big")).hex() + '"}').encode()
def comps(v):
    return "[" + ",".join('{"svn":%d}' % v for _ in range(16)) + "]"
def tcb_info(levels):
    lv = ",".join('{"tcb":{"sgxtcbcomponents":%s,"pcesvn":%d,"tdxtcbcomponents":%s},"tcbDate":"2024-01-01T00:00:00Z","tcbStatus":"%s"}' % (comps(a), p, comps(t), st) for (a, p, t, st) in levels)
    return ('{"id":"TDX","version":3,"issueDate":"2024-01-01T00:00:00Z","nextUpdate":"2039-01-01T00:00:00Z","fmspc":"%s","pceId":"%s","tcbType":0,"tcbEvaluationDataNumber":17,'
            '"tdxModule":{"mrsigner":"%s","attributes":"0000000000000000","attributesMask":"FFFFFFFFFFFFFFFF"},"tcbLevels":[%s]}') % (FMSPC.hex(), PCEID.hex(), "0" * 96, lv)
tcb_ok = signed_json("tcbInfo", tcb_info([(SVN, PCESVN, 0, "UpToDate")]))
tcb_old = signed_json("tcbInfo", tcb_info([(SVN + 1, PCESVN, 0, "UpToDate"), (SVN, PCESVN, 0, "SWHardeningNeeded")]))
qe_id = signed_json("enclaveIdentity", '{"id":"TD_QE","version":2,"issueDate":"2024-01-01T00:00:00Z","nextUpdate":"2039-01-01T00:00:00Z","tcbEvaluationDataNumber":17,"miscselect":"00000000","miscselectMask":"FFFFFFFF","attributes":"11000000000000000000000000000000","attributesMask":"FBFFFFFFFFFFFFFF0000000000000000","mrsigner":"DC9E2A7C6F948F17474E34A7FC43ED030F7C1563F1BABDDF6340C82E0E54A8C5","isvprodid":2,"tcbLevels":[{"tcb":{"isvsvn":4},"tcbDate":"2024-01-01T00:00:00Z","tcbStatus":"UpToDate"}]}')
tcb_chain = b"".join(c.public_bytes(serialization.Encoding.PEM) for c in (itcb, iroot))
def ec_crl(issuer, key, revoked=None):
    b = (x509.CertificateRevocationListBuilder().issuer_name(issuer).last_update(NB).next_update(NA)
         .add_extension(x509.CRLNumber(1), critical=False))
    if revoked is not None:
        b = b.add_revoked_certificate(x509.RevokedCertificateBuilder().serial_number(revoked).revocation_date(NB).build())
    return b.sign(key, hashes.SHA256()).public_bytes(serialization.Encoding.DER)
pck_crl = ec_crl(name("Test SGX PCK Platform CA"), ica_k)
pck_crl_rev = ec_crl(name("Test SGX PCK Platform CA"), ica_k, 23)
root_crl = ec_crl(name("Test SGX Root CA"), iroot_k)
ak2 = ec.generate_private_key(ec.SECP256R1())
nums = ak2.public_key().public_numbers()
akraw = nums.x.to_bytes(32, "big") + nums.y.to_bytes(32, "big")
qe_auth = bytes(range(32))
qer = bytearray(384)
qer[128:160] = bytes.fromhex("dc9e2a7c6f948f17474e34a7fc43ed030f7c1563f1babddf6340c82e0e54a8c5")
struct.pack_into("<H", qer, 256, 2)
struct.pack_into("<H", qer, 258, 4)    # ISVSVN
qer[48] = 0x11                         # attributes
qer[320:352] = hashlib.sha256(akraw + qe_auth).digest()
from cryptography.hazmat.primitives.asymmetric.utils import decode_dss_signature
r_, s_ = decode_dss_signature(ipck_k.sign(bytes(qer), ec.ECDSA(hashes.SHA256())))
qe_sig = r_.to_bytes(32, "big") + s_.to_bytes(32, "big")
pem = b"".join(c.public_bytes(serialization.Encoding.PEM) for c in (ipck, ica, iroot))
# The rest of a v4 quote after header and body: everything but the quote
# signature (64 bytes, first), which the test makes.
cert = bytes(qer) + qe_sig + struct.pack("<H", len(qe_auth)) + qe_auth + struct.pack("<HI", 5, len(pem)) + pem
tail = akraw + struct.pack("<HI", 6, len(cert)) + cert
sigdata_len = 64 + len(tail)
body = bytearray(584)
struct.pack_into("<Q", body, 120, 1 << 28)               # td_attributes: SEPT_VE_DISABLE
body[136:184] = hashlib.sha384(b"resid test td").digest() # mrtd
header = struct.pack("<HHIHH", 4, 2, 129, 0, 0) + bytes(16) + bytes(20)

# CCA: the TF-M test token's CPAK (veraison/ccatoken's testRMMCPAK), and a
# test CPAK and RAK (P-384) to sign tokens around any challenge.
import base64
def b64u(x):
    return base64.urlsafe_b64decode(x + "=" * (-len(x) % 4))
rmm_pub = ec.EllipticCurvePublicNumbers(int.from_bytes(b64u("IShnxS4rlQiwpCCpBWDzlNLfqiG911FP8akBr-fh94uxHU5m-Kijivp2r2oxxN6M"), "big"),
                                        int.from_bytes(b64u("hM4tr8mWQli1P61xh3T0ViDREbF26DGOEYfbAjWjGNN7pZf-6A4OTHYqEryz6m7U"), "big"),
                                        ec.SECP384R1()).public_key()
rmm_spki = rmm_pub.public_bytes(serialization.Encoding.DER, serialization.PublicFormat.SubjectPublicKeyInfo)
cpak_k = ec.generate_private_key(ec.SECP384R1())
cpak_spki = cpak_k.public_key().public_bytes(serialization.Encoding.DER, serialization.PublicFormat.SubjectPublicKeyInfo)
rak_k = ec.generate_private_key(ec.SECP384R1())
rak_pub = rak_k.public_key().public_bytes(serialization.Encoding.X962, serialization.PublicFormat.UncompressedPoint)

snd = x25519.X25519PrivateKey.generate()
snd_pub = snd.public_key().public_bytes(serialization.Encoding.Raw, serialization.PublicFormat.Raw)
snd_sk = snd.private_bytes(serialization.Encoding.Raw, serialization.PrivateFormat.Raw, serialization.NoEncryption())

def w(n, b):
    open(os.path.join(D, n), "wb").write(b)

w("test-ark.der", ark.public_bytes(serialization.Encoding.DER))
w("test-ask.der", ask.public_bytes(serialization.Encoding.DER))
w("test-vcek.der", vcek.public_bytes(serialization.Encoding.DER))
w("test-crl.der", crl.public_bytes(serialization.Encoding.DER))
w("test-crl-revoked.der", crl_rev.public_bytes(serialization.Encoding.DER))
w("test-crl-old.der", crl_old.public_bytes(serialization.Encoding.DER))
w("report-template.bin", bytes(r))
w("vcek-d.bin", vcek_k.private_numbers().private_value.to_bytes(48, "big"))
w("sender-sk.bin", snd_sk)
w("nitro-root.der", nroot.public_bytes(serialization.Encoding.DER))
w("nitro-int.der", nint.public_bytes(serialization.Encoding.DER))
w("nitro-leaf.der", nleaf.public_bytes(serialization.Encoding.DER))
w("nitro-leaf-d.bin", nleaf_k.private_numbers().private_value.to_bytes(48, "big"))
w("tpm-ak-d.bin", ak_k.private_numbers().private_value.to_bytes(32, "big"))
w("tdx-header.bin", header)
w("tdx-body.bin", bytes(body))
w("tdx-sigdata-tail.bin", struct.pack("<I", sigdata_len) + tail)
w("tdx-ak-d.bin", ak2.private_numbers().private_value.to_bytes(32, "big"))
w("tdx-tcb-info.json", tcb_ok)
w("tdx-tcb-info-old.json", tcb_old)
w("tdx-qe-identity.json", qe_id)
w("tdx-tcb-chain.pem", tcb_chain)
w("tdx-pck-crl.der", pck_crl)
w("tdx-pck-crl-revoked.der", pck_crl_rev)
w("tdx-root-crl.der", root_crl)
w("cca-cpak-d.bin", cpak_k.private_numbers().private_value.to_bytes(48, "big"))
w("cca-rak-d.bin", rak_k.private_numbers().private_value.to_bytes(48, "big"))
w("cca-rak-pub.bin", rak_pub)

def ints(b):
    return "[" + ", ".join(str(x) for x in b) + "]"

ark_der = ark.public_bytes(serialization.Encoding.DER)
nroot_der = nroot.public_bytes(serialization.Encoding.DER)
t = f'''// GENERATED by tests/attest/gen_fixtures.py: test anchors and a fixed
// evidence time, for a private RESID_HOME only (never the real lib/verify/,
// whose closure the compiler pins).

import "core.resid";
import "snp.resid";
import "nsm.resid";
import "tpm.resid";
import "tdx.resid";
import "intel_anchors.resid";
import "sealing.resid";
import "cca.resid";
import "../word.resid";
import "../instant.resid";

@anchor(kind = AmdVcek(Milan), principal = InGuest, formats = [SnpReport], source = "tests/attest/gen_fixtures.py", fingerprint = "sha384:{hashlib.sha384(ark_der).hexdigest()}", retrieved = "2026-10-11", reviewed_by = "tests", algorithms = [RsaPss4096Sha384, EcdsaP384Sha384], expires = "2039-12-31")
pub Anchor test_ark() {{ return anchor_der(test_ark_der()); }}

@anchor(kind = AmdVlek(Milan), principal = InGuest, formats = [SnpReport], source = "tests/attest/gen_fixtures.py", fingerprint = "sha384:{hashlib.sha384(ark_der).hexdigest()}", retrieved = "2026-10-11", reviewed_by = "tests", algorithms = [RsaPss4096Sha384, EcdsaP384Sha384], expires = "2039-12-31")
pub Anchor test_ark_vlek() {{ return anchor_der(test_ark_der()); }}

@anchor(kind = ReleaseSender(32), formats = [], source = "tests/attest/gen_fixtures.py", fingerprint = "sha256:{hashlib.sha256(snd_pub).hexdigest()}", retrieved = "2026-10-11", reviewed_by = "tests", algorithms = [DhkemX25519], expires = "2039-12-31")
pub Anchor test_sender() {{ return anchor_der({ints(snd_pub)}); }}

pub List(Int) test_ark_der() {{ return {ints(ark_der)}; }}

@anchor(kind = Nitro(Test), principal = InGuest, formats = [NsmDocument], source = "tests/attest/gen_fixtures.py", fingerprint = "sha384:{hashlib.sha384(nroot_der).hexdigest()}", retrieved = "2026-10-11", reviewed_by = "tests", algorithms = [EcdsaP384Sha384], expires = "2039-12-31")
pub Anchor test_nitro_root() {{ return anchor_der({ints(nroot_der)}); }}

@anchor(kind = TpmAk(Test), principal = InGuest, formats = [TpmQuoteEvidence, TpmCounter], source = "tests/attest/gen_fixtures.py", fingerprint = "sha256:{hashlib.sha256(ak_spki).hexdigest()}", retrieved = "2026-10-11", reviewed_by = "tests", algorithms = [EcdsaP256Sha256], expires = "2039-12-31")
pub Anchor test_tpm_ak() {{ return anchor_der({ints(ak_spki)}); }}

@anchor(kind = IntelPck(Test), principal = InGuest, formats = [TdxQuote], source = "tests/attest/gen_fixtures.py", fingerprint = "sha384:{hashlib.sha384(iroot.public_bytes(serialization.Encoding.DER)).hexdigest()}", retrieved = "2026-10-11", reviewed_by = "tests", algorithms = [EcdsaP256Sha256], expires = "2039-12-31")
pub Anchor test_sgx_root() {{ return anchor_der({ints(iroot.public_bytes(serialization.Encoding.DER))}); }}

// A TDX quote's chain and signatures alone, for real quotes.
pub Result(TdxQuote, VerifyError) test_tdx_check(List(UInt(8)) quote, Anchor root, EvidenceTime t) {{ return tdx_check(quote, root, t); }}

// A platform key from given bytes and measurement (no device here).
pub Verified(PlatformKey) test_platform_key(List(Int) key, List(Int) measurement) {{
    List(Int) none = [];
    return Verified {{.value = PlatformKey {{.key = secret_bytes(key), .measurement = measurement, .fields = 9}}, .anchors = [test_ark().id], .quals = 0, .record = 0 - 1, .kem = 0, .pk = none, .chan = none, .time = Kernel, .principal = "InGuest", .format = "PlatformKey"}};
}}

@anchor(kind = EndorsedKeys(TfmTest), formats = [CcaToken], source = "veraison/ccatoken testRMMCPAK", fingerprint = "sha256:{hashlib.sha256(rmm_spki).hexdigest()}", retrieved = "2026-10-11", reviewed_by = "tests", algorithms = [EcdsaP384Sha384], expires = "2039-12-31")
pub Anchor test_rmm_cpak() {{ return anchor_der({ints(rmm_spki)}); }}

@anchor(kind = EndorsedKeys(Test), formats = [CcaToken], source = "tests/attest/gen_fixtures.py", fingerprint = "sha256:{hashlib.sha256(cpak_spki).hexdigest()}", retrieved = "2026-10-11", reviewed_by = "tests", algorithms = [EcdsaP384Sha384], expires = "2039-12-31")
pub Anchor test_cpak() {{ return anchor_der({ints(cpak_spki)}); }}

// A CCA token's signatures and binding alone.
pub Result(CcaToken, VerifyError) test_cca_check(List(UInt(8)) token, Anchor cpak, EvidenceTime t) {{ return cca_check(token, cpak, t); }}

// Intel's collateral against a checked quote: the two statuses, or why not.
pub Str tdx_collateral_status(TdxQuote q, TdxCollateral c, Anchor root, EvidenceTime t) {{
    return match (tdx_collateral_check(q, c, root, t)) {{ Ok(st) => "TCB " + st[0] + ", QE " + st[1], Err(e) => verify_error_text(e) }};
}}

// The NSM document's chain and signature alone, for real documents whose
// nonce carries no challenge of ours.
pub Result(NsmDocument, VerifyError) test_nsm_check(List(UInt(8)) doc, Anchor root, EvidenceTime t) {{ return nsm_check(doc, root, t); }}

// A fixed time from the kernel's clock, as tests need one.
pub EvidenceTime test_time(Int unix) {{ return EvidenceTime {{.at = instant_of_seconds(unix), .source = Kernel}}; }}

// A time a relying party signed (tests only: no signature here).
@primitive(time_source = RelyingParty)
pub EvidenceTime test_rp_time(Int unix) {{ return EvidenceTime {{.at = instant_of_seconds(unix), .source = RelyingParty}}; }}

// The chain and claim checks alone, for real reports whose report_data
// carries no challenge of ours.
pub Result(SnpReport, VerifyError) test_snp_check(List(UInt(8)) report, Anchor root, SnpCollateral col, EvidenceTime t) {{ return snp_check(report, root, col, t); }}
'''
w("testing.resid", t.encode())
print("ok")
