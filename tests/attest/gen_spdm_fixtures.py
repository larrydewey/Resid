#!/usr/bin/env python3
"""SPDM fixtures for tests/attest from DMTF's spdm-emu (run once; the
output is committed).

Usage: gen_spdm_fixtures.py <spdm-emu build/bin> <captures dir>

The captures are tests/spdm/requester.resid's records (REC=file) of this
repository's requester talking to spdm_responder_emu. For each sample key
directory used, the CA certificate (an anchor in testing.resid) and OCSP
responses for the intermediate (signed by the CA) and the responder's
certificate (signed by the intermediate), good from 2026-01-01 to
2028-01-01, plus a revoked one for the responder's. The sample keys are
DMTF's (spdm-emu, BSD-3-Clause), published for testing.
(Needs python3 with cryptography.)
"""
import datetime, os, shutil, sys
from cryptography import x509
from cryptography.x509 import ocsp
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ed25519, ed448

B, CAPS = sys.argv[1], sys.argv[2]
D = os.path.join(os.path.dirname(os.path.abspath(__file__)), "fixtures", "spdm-emu")
os.makedirs(D, exist_ok=True)
TU = datetime.datetime(2026, 1, 1)
NU = datetime.datetime(2028, 1, 1)

def cert(path):
    return x509.load_der_x509_certificate(open(path, "rb").read())

def key(path):
    return serialization.load_pem_private_key(open(path, "rb").read(), None)

def respond(c, issuer, ikey, status=ocsp.OCSPCertStatus.GOOD):
    b = ocsp.OCSPResponseBuilder().add_response(
        cert=c, issuer=issuer, algorithm=hashes.SHA1(), cert_status=status,
        this_update=TU, next_update=NU,
        revocation_time=TU if status == ocsp.OCSPCertStatus.REVOKED else None,
        revocation_reason=x509.ReasonFlags.key_compromise if status == ocsp.OCSPCertStatus.REVOKED else None,
    ).responder_id(ocsp.OCSPResponderEncoding.HASH, issuer)
    alg = None if isinstance(ikey, (ed25519.Ed25519PrivateKey, ed448.Ed448PrivateKey)) else hashes.SHA256()
    return b.sign(ikey, alg).public_bytes(serialization.Encoding.DER)

for d in ["ecp256", "ecp384", "rsa2048", "rsa3072", "ed25519"]:
    ca, inter, leaf = cert(f"{B}/{d}/ca.cert.der"), cert(f"{B}/{d}/inter.cert.der"), cert(f"{B}/{d}/end_responder.cert.der")
    cak, ik = key(f"{B}/{d}/ca.key"), key(f"{B}/{d}/inter.key")
    open(f"{D}/{d}-ca.der", "wb").write(ca.public_bytes(serialization.Encoding.DER))
    open(f"{D}/{d}-ocsp-inter.der", "wb").write(respond(inter, ca, cak))
    open(f"{D}/{d}-ocsp-leaf.der", "wb").write(respond(leaf, inter, ik))
    open(f"{D}/{d}-ocsp-leaf-revoked.der", "wb").write(respond(leaf, inter, ik, ocsp.OCSPCertStatus.REVOKED))

for f in sorted(os.listdir(CAPS)):
    if f.endswith(".rec"):
        shutil.copy(os.path.join(CAPS, f), os.path.join(D, f))
print("ok")
