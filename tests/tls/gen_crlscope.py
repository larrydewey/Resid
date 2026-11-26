#!/usr/bin/env python3
"""Generate tests/tls/fixtures/crlscope/: one CA, a good and a revoked leaf
under it, and CRLs whose extensions limit what they may say (RFC 5280
§5.2, §5.3): delta CRLs, issuingDistributionPoint scopes, critical
extensions the walk does not process. Needs python3-cryptography; the
output is committed."""
import datetime, os
from cryptography import x509
from cryptography.x509.oid import NameOID, ObjectIdentifier
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.serialization import Encoding
from cryptography.hazmat.primitives.asymmetric import ec

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "fixtures", "crlscope")
os.makedirs(OUT, exist_ok=True)
NB = datetime.datetime(2025, 1, 1, tzinfo=datetime.timezone.utc)
NA = datetime.datetime(2124, 1, 1, tzinfo=datetime.timezone.utc)
GOOD, BAD = 0x6000, 0x6001

def name(cn): return x509.Name([x509.NameAttribute(NameOID.COMMON_NAME, cn)])
def save(fn, obj): open(os.path.join(OUT, fn), "wb").write(obj.public_bytes(Encoding.DER))

ck = ec.generate_private_key(ec.SECP256R1())
ca = (x509.CertificateBuilder().subject_name(name("CRL Scope CA")).issuer_name(name("CRL Scope CA"))
      .public_key(ck.public_key()).serial_number(1).not_valid_before(NB).not_valid_after(NA)
      .add_extension(x509.BasicConstraints(ca=True, path_length=None), True)
      .add_extension(x509.KeyUsage(False, False, False, False, False, True, True, False, False), True)
      .sign(ck, hashes.SHA256()))
save("ca.der", ca)
for fn, serial in (("good.der", GOOD), ("bad.der", BAD)):
    lk = ec.generate_private_key(ec.SECP256R1())
    save(fn, x509.CertificateBuilder().subject_name(name("localhost")).issuer_name(ca.subject)
         .public_key(lk.public_key()).serial_number(serial).not_valid_before(NB).not_valid_after(NA)
         .add_extension(x509.BasicConstraints(ca=False, path_length=None), True)
         .add_extension(x509.SubjectAlternativeName([x509.DNSName("localhost")]), False)
         .sign(ck, hashes.SHA256()))

def entry(serial, exts=()):
    b = x509.RevokedCertificateBuilder().serial_number(serial).revocation_date(NB)
    for e, crit in exts: b = b.add_extension(e, crit)
    return b.build()

def crl(fn, entries, exts=()):
    b = (x509.CertificateRevocationListBuilder().issuer_name(ca.subject)
         .last_update(NB).next_update(NA)
         .add_extension(x509.CRLNumber(1), False)
         .add_extension(x509.AuthorityKeyIdentifier.from_issuer_public_key(ck.public_key()), False))
    for e in entries: b = b.add_revoked_certificate(e)
    for e, crit in exts: b = b.add_extension(e, crit)
    save(fn, b.sign(ck, hashes.SHA256()))

UNKNOWN = x509.UnrecognizedExtension(ObjectIdentifier("1.2.3.4.5.6"), b"\x05\x00")
def idp(**kw):
    a = dict(full_name=None, relative_name=None, only_contains_user_certs=False,
             only_contains_ca_certs=False, only_some_reasons=None, indirect_crl=False,
             only_contains_attribute_certs=False)
    a.update(kw)
    return (x509.IssuingDistributionPoint(**a), True)

# A complete CRL: listing the revoked leaf, and covering the good one.
crl("full.der", [entry(BAD)])
# An unknown extension changes nothing while it is not critical.
crl("noncrit_unknown.der", [entry(BAD)], [(UNKNOWN, False)])
# Not to be used at all: a critical extension the walk does not process,
# on the CRL or on an entry, and an indirect CRL (entries may be another
# issuer's, through certificateIssuer).
crl("crit_unknown.der", [], [(UNKNOWN, True)])
crl("crit_unknown_bad.der", [entry(BAD)], [(UNKNOWN, True)])
crl("entry_crit.der", [entry(0x7777, [(UNKNOWN, True)])])
crl("indirect.der", [], [idp(indirect_crl=True)])
# A delta CRL lists only what changed since its base: it revokes what it
# lists, but not listing a serial says nothing.
crl("delta.der", [], [(x509.DeltaCRLIndicator(1), True)])
crl("delta_bad.der", [entry(BAD)], [(x509.DeltaCRLIndicator(1), True)])
# removeFromCRL un-revokes, which only a base-and-delta reading can apply.
crl("delta_remove.der", [entry(BAD, [(x509.CRLReason(x509.ReasonFlags.remove_from_crl), False)])],
    [(x509.DeltaCRLIndicator(1), True)])
# A partitioned or scoped CRL is authoritative only for its scope.
crl("idp_part.der", [], [idp(full_name=[x509.UniformResourceIdentifier("http://crl.test/1.crl")])])
crl("idp_part_bad.der", [entry(BAD)], [idp(full_name=[x509.UniformResourceIdentifier("http://crl.test/1.crl")])])
crl("idp_reasons.der", [], [idp(only_some_reasons=frozenset([x509.ReasonFlags.key_compromise]))])
crl("idp_users.der", [], [idp(only_contains_user_certs=True)])
print("wrote", OUT)
