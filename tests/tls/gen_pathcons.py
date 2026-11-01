#!/usr/bin/env python3
"""Generate tests/tls/fixtures/pathcons/: chains for the TLS walk's path
constraints (name constraints, pathLenConstraint, EKU, critical extensions,
wildcard form). Needs python3-cryptography; the output is committed."""
import datetime, os, sys
from cryptography import x509
from cryptography.x509.oid import NameOID, ExtendedKeyUsageOID, ObjectIdentifier
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ec

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "fixtures", "pathcons")
os.makedirs(OUT, exist_ok=True)
NB = datetime.datetime(2025, 1, 1, tzinfo=datetime.timezone.utc)
NA = datetime.datetime(2124, 1, 1, tzinfo=datetime.timezone.utc)

def key(): return ec.generate_private_key(ec.SECP256R1())
def name(cn): return x509.Name([x509.NameAttribute(NameOID.COMMON_NAME, cn)])
def build(subj, issuer, pub, signer, exts):
    b = (x509.CertificateBuilder().subject_name(name(subj)).issuer_name(issuer)
         .public_key(pub).serial_number(x509.random_serial_number())
         .not_valid_before(NB).not_valid_after(NA))
    for e, crit in exts: b = b.add_extension(e, critical=crit)
    return b.sign(signer, hashes.SHA256())
def save(fn, c, pem=False):
    enc = serialization.Encoding.PEM if pem else serialization.Encoding.DER
    open(os.path.join(OUT, fn), "wb").write(c.public_bytes(enc))
def bc(ca, plen=None): return (x509.BasicConstraints(ca=ca, path_length=plen), True)
KU_CA = (x509.KeyUsage(False, False, False, False, False, True, True, False, False), True)
def san(*n): return (x509.SubjectAlternativeName([x509.DNSName(x) for x in n]), False)
def nc(permit=None, exclude=None): return (x509.NameConstraints(permitted_subtrees=permit, excluded_subtrees=exclude), True)
def leaf(fn, cn, issuer, ikey, extra, names=None):
    k = key()
    save(fn, build(cn, issuer.subject, k.public_key(), ikey, [bc(False), san(*(names or [cn]))] + extra))

rk = key()
root = build("PC Root", name("PC Root"), rk.public_key(), rk, [bc(True), KU_CA])
save("root.pem", root, pem=True)
ncr = build("PC Root", name("PC Root"), rk.public_key(), rk,
            [bc(True), KU_CA, nc(permit=[x509.DNSName("example.test")], exclude=[x509.DNSName("bad.example.test")])])
save("root_nc.pem", ncr, pem=True)

leaf("nc_evil.der", "evil.test", ncr, rk, [])
leaf("nc_ok.der", "api.example.test", ncr, rk, [])
leaf("nc_excluded.der", "x.bad.example.test", ncr, rk, [])
leaf("nc_wild.der", "*.example.test", ncr, rk, [])
leaf("nc_extra_san.der", "api.example.test", ncr, rk, [], names=["api.example.test", "evil.test"])
leaf("eku_client.der", "api.example.test", root, rk, [(x509.ExtendedKeyUsage([ExtendedKeyUsageOID.CLIENT_AUTH]), False)])
leaf("eku_server.der", "api.example.test", root, rk, [(x509.ExtendedKeyUsage([ExtendedKeyUsageOID.SERVER_AUTH]), False)])
leaf("crit_unknown.der", "api.example.test", root, rk, [(x509.UnrecognizedExtension(ObjectIdentifier("1.2.3.4.5.6"), b"\x04\x01\x00"), True)])
leaf("noncrit_unknown.der", "api.example.test", root, rk, [(x509.UnrecognizedExtension(ObjectIdentifier("1.2.3.4.5.6"), b"\x04\x01\x00"), False)])
leaf("wild_partial.der", "*foo.example.test", root, rk, [])

# pathLen: root -> inter(pathlen) -> sub -> leaf. pathlen 0 is broken, 1 is fine.
for plen in (0, 1):
    d = os.path.join(OUT, f"inters_pl{plen}")
    os.makedirs(d, exist_ok=True)
    ik, sk = key(), key()
    inter = build(f"PC Inter {plen}", root.subject, ik.public_key(), rk, [bc(True, plen), KU_CA])
    sub = build(f"PC Sub {plen}", inter.subject, sk.public_key(), ik, [bc(True), KU_CA])
    open(os.path.join(d, "inter.der"), "wb").write(inter.public_bytes(serialization.Encoding.DER))
    open(os.path.join(d, "sub.der"), "wb").write(sub.public_bytes(serialization.Encoding.DER))
    leaf(f"pl{plen}_leaf.der", "api.example.test", sub, sk, [])
print("wrote", OUT)
