#!/usr/bin/env python3
"""Generate tests/tls/fixtures/hostcheck/: leaves for the host check in
lib/chain.resid's tls_server_trusted -- address literals (v6), host forms
against name constraints (nc).

    gen_hostcheck.py [group ...]    (default: every group)

Each group has its own root, so regenerating one leaves the others'
committed bytes alone. Needs python3-cryptography; the output is committed."""
import datetime, ipaddress, os, sys
from cryptography import x509
from cryptography.x509.oid import NameOID
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ec

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "fixtures", "hostcheck")
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
BC_CA = (x509.BasicConstraints(ca=True, path_length=None), True)
BC_LEAF = (x509.BasicConstraints(ca=False, path_length=None), True)
KU_CA = (x509.KeyUsage(False, False, False, False, False, True, True, False, False), True)
def dns(n): return x509.DNSName(n)
def ip(a): return x509.IPAddress(ipaddress.ip_address(a))
def root(prefix, extra=()):
    k = key()
    r = build(f"Hostcheck {prefix} Root", name(f"Hostcheck {prefix} Root"), k.public_key(), k, [BC_CA, KU_CA] + list(extra))
    save(f"{prefix}_root.pem", r, pem=True)
    return r, k

def leaf(fn, r, rk, gns, extra=()):
    k = key()
    save(fn, build("leaf", r.subject, k.public_key(), rk,
                   [BC_LEAF, (x509.SubjectAlternativeName(gns), False)] + list(extra)))

def v6():
    # Compressed IPv6 hosts: each leaf names one address, and a host that
    # merely looks like it (the `::` on the other side) must not match.
    r, rk = root("v6")
    leaf("v6_loop.der", r, rk, [ip("::1")])
    leaf("v6_1colon.der", r, rk, [ip("1::")])
    leaf("v6_db8_1.der", r, rk, [ip("2001:db8::1")])
    leaf("v6_db8_1_left.der", r, rk, [ip("2001:db8:1::")])

def nc():
    # A root excluding the name evil.test and the range 10.0.0.0/8, and
    # leaves that spell those in other forms.
    excl = [dns("evil.test"), x509.IPAddress(ipaddress.ip_network("10.0.0.0/8"))]
    r, rk = root("nc", [(x509.NameConstraints(permitted_subtrees=None, excluded_subtrees=excl), True)])
    leaf("nc_dns.der", r, rk, [dns("evil.test")])
    leaf("nc_dns_dot.der", r, rk, [dns("evil.test.")])
    leaf("nc_sub_dot.der", r, rk, [dns("www.evil.test.")])
    leaf("nc_ip4.der", r, rk, [ip("10.0.0.1")])
    leaf("nc_ip4mapped.der", r, rk, [ip("::ffff:10.0.0.1")])
    leaf("nc_dns_mapped.der", r, rk, [dns("::ffff:10.0.0.1")])
    leaf("nc_ok.der", r, rk, [dns("good.test"), ip("192.0.2.1"), ip("2001:db8::1")])
    # A permitted IPv4 range: a mapped address inside it is inside it.
    pr, prk = root("ncp", [(x509.NameConstraints(permitted_subtrees=[x509.IPAddress(ipaddress.ip_network("192.0.2.0/24"))], excluded_subtrees=None), True)])
    leaf("ncp_ip4.der", pr, prk, [ip("192.0.2.7")])
    leaf("ncp_ip4mapped.der", pr, prk, [ip("::ffff:192.0.2.7")])

GROUPS = {"v6": v6, "nc": nc}
for g in (sys.argv[1:] or list(GROUPS)):
    GROUPS[g]()
print("wrote", OUT)
