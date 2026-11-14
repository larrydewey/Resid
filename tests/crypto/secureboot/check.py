#!/usr/bin/env python3
"""A second check of what tests/crypto/sbprobe.resid made, with
pyca/cryptography: the RSA key file loads and matches the certificate, the
self-signed certificate verifies, and each signed PE image carries a PKCS#7
Authenticode signature whose RSA signature over the signed attributes
verifies with the certificate's key, and whose digest is the image's. The
digest is recomputed here by a second implementation of the same rules
(Microsoft's Authenticode PE specification), so it catches slips, not a
misreading of the rules; UEFI firmware verifying a signed loader (Hafen's
suite, under OVMF) is the check of the rules themselves. Prints one line per check and exits 1 on any failure."""
import hashlib, struct, sys, os
from cryptography import x509
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives.serialization import pkcs7

def der_read(b, i):
    tag = b[i]; l = b[i + 1]; i += 2
    if l & 0x80:
        n = l & 0x7F; l = int.from_bytes(b[i:i + n], "big"); i += n
    return tag, i, i + l   # tag, content start, end

def children(b, start, end):
    out = []
    while start < end:
        t, s, e = der_read(b, start); out.append((t, start, s, e)); start = e
    return out

def authenticode_digest(img):
    pe = struct.unpack_from("<I", img, 0x3C)[0]
    nsec, optsize = struct.unpack_from("<H", img, pe + 6)[0], struct.unpack_from("<H", img, pe + 20)[0]
    opt = pe + 24
    plus = struct.unpack_from("<H", img, opt)[0] == 0x20B
    ck = opt + 64
    certdir = opt + (112 if plus else 96) + 4 * 8
    headers = struct.unpack_from("<I", img, opt + 60)[0]
    cert_at, cert_size = struct.unpack_from("<II", img, certdir)
    h = hashlib.sha256()
    h.update(img[:ck]); h.update(img[ck + 4:certdir]); h.update(img[certdir + 8:headers])
    secs = []
    for i in range(nsec):
        e = opt + optsize + 40 * i
        size, ptr = struct.unpack_from("<II", img, e + 16)
        if size: secs.append((ptr, size))
    hashed = headers
    for ptr, size in sorted(secs):
        h.update(img[ptr:ptr + size]); hashed += size
    end = len(img) - cert_size
    if end > hashed: h.update(img[hashed:end])
    return h.digest(), cert_at, cert_size

def check_signed(path, cert, ok):
    img = open(path, "rb").read()
    digest, at, size = authenticode_digest(img)
    if at % 8 or at + size != len(img):
        return ok(False, f"{path}: certificate table not at the end")
    length, rev, typ = struct.unpack_from("<IHH", img, at)
    ok(rev == 0x200 and typ == 2, f"{path}: WIN_CERTIFICATE revision 2.0, PKCS_SIGNED_DATA")
    blob = img[at + 8:at + length]
    # cryptography parses the structure as PKCS#7 and returns its certificates.
    certs = pkcs7.load_der_pkcs7_certificates(blob)
    ok(len(certs) == 1 and certs[0] == cert, f"{path}: PKCS#7 carries the signer's certificate")
    # ContentInfo -> [0] -> SignedData
    _, s, e = der_read(blob, 0)
    ci = children(blob, s, e)
    sd_t, sd_s, sd_e = der_read(blob, ci[1][2])
    sd = children(blob, sd_s, sd_e)
    encap = children(blob, sd[2][2], sd[2][3])
    spc_t, spc_s, spc_e = der_read(blob, encap[1][2])
    spc = children(blob, spc_s, spc_e)
    dinfo = children(blob, spc[1][2], spc[1][3])
    signed_digest = blob[dinfo[1][2]:dinfo[1][3]]
    ok(signed_digest == digest, f"{path}: signed digest equals the image's Authenticode SHA-256")
    si = children(blob, *children(blob, sd[-1][2], sd[-1][3])[0][2:4])
    attrs = si[3]
    signed_attrs = b"\x31" + blob[attrs[1] + 1:attrs[3]]
    md = hashlib.sha256(blob[spc_s:spc_e]).digest()
    ok(md in blob[attrs[2]:attrs[3]], f"{path}: messageDigest covers the SpcIndirectDataContent")
    sig = blob[si[5][2]:si[5][3]]
    try:
        cert.public_key().verify(sig, signed_attrs, padding.PKCS1v15(), hashes.SHA256())
        ok(True, f"{path}: RSA signature over the signed attributes verifies")
    except Exception as ex:
        ok(False, f"{path}: RSA signature over the signed attributes verifies ({ex})")

def main(d):
    failures = []
    def ok(c, what):
        print(("pass  " if c else "FAIL  ") + what)
        if not c: failures.append(what)
    key = serialization.load_pem_private_key(open(os.path.join(d, "db.key"), "rb").read(), None)
    cert = x509.load_der_x509_certificate(open(os.path.join(d, "db.crt"), "rb").read())
    ok(key.key_size == 2048 and key.public_key().public_numbers() == cert.public_key().public_numbers(), "db.key loads (PKCS#8) and matches db.crt")
    pn = key.private_numbers()
    ok(pn.p * pn.q == pn.public_numbers.n and pn.d * pn.public_numbers.e % ((pn.p - 1) * (pn.q - 1) // __import__("math").gcd(pn.p - 1, pn.q - 1)) == 1, "the key's primes and exponents agree")
    try:
        cert.verify_directly_issued_by(cert)
        ok(True, "db.crt is a valid self-signed certificate")
    except Exception as ex:
        ok(False, f"db.crt is a valid self-signed certificate ({ex})")
    eku = cert.extensions.get_extension_for_class(x509.BasicConstraints).value
    ok(eku.ca, "db.crt is an authority")
    for name in ("tiny64.signed.efi", "tiny32.signed.efi"):
        check_signed(os.path.join(d, name), cert, ok)
    sys.exit(1 if failures else 0)

main(sys.argv[1])
