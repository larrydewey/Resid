#!/usr/bin/env python3
"""Generate lib/verify/tpm_anchors.resid from Microsoft's TrustedTpm.cab.

Usage: tools/attest/gen_tpm_anchors.py DIR [TESTS] > lib/verify/tpm_anchors.resid

DIR is TrustedTpm.cab (https://go.microsoft.com/fwlink/?linkid=2097925)
extracted (`bsdtar -xf TrustedTpm.cab -C DIR`): one directory per TPM
manufacturer, each with RootCA/ and IntermediateCA/. Every certificate there
(roots, and a few cross-certified CAs Windows trusts as roots) whose key
Resid can use (RSA 2048-4096, ECC NIST P-256, P-384 or P-521) and that has not
expired becomes an anchor of kind TpmEk(<manufacturer>). Microsoft's own
directory holds its AIK CA, not an EK root, and is skipped.

The certificates are read with a small DER walker, not a full X.509
library: several manufacturers' roots carry multi-valued RDNs whose SET
members are not in DER order, which strict parsers refuse; lib/x509.resid
accepts them, and tests/attest/run/tpm_anchors.resid checks every
generated anchor with it.

With TESTS (tests/attest), it also writes, for each anchor, one current
intermediate CA from DIR that the anchor issued, to
TESTS/fixtures/tpm-roots/<anchor>.der, and TESTS/run/tpm_roots.resid,
which checks each one's signature against its anchor.
"""
import base64, datetime, hashlib, os, re, sys

def tlv(b, i):
    tag = b[i]; n = b[i + 1]; j = i + 2
    if n & 0x80:
        k = n & 0x7F
        n = int.from_bytes(b[j:j + k], "big"); j += k
    return tag, j, j + n

def kids(b, i):
    tag, s, e = tlv(b, i)
    out = []
    while s < e:
        out.append(s)
        s = tlv(b, s)[2]
    return out

def oid(b, i):
    tag, s, e = tlv(b, i)
    v = b[s:e]
    arcs = [v[0] // 40, v[0] % 40]
    x = 0
    for c in v[1:]:
        x = (x << 7) | (c & 0x7F)
        if not c & 0x80:
            arcs.append(x); x = 0
    return ".".join(map(str, arcs))

def time_at(b, i):
    tag, s, e = tlv(b, i)
    t = b[s:e].decode()
    if tag == 23:
        y = int(t[:2]); t = ("19" if y >= 50 else "20") + t
    return datetime.datetime.strptime(t[:14], "%Y%m%d%H%M%S")

def cn(b, i):
    for rdn in kids(b, i):
        for atv in kids(b, rdn):
            o, v = kids(b, atv)
            if oid(b, o) == "2.5.4.3":
                tag, s, e = tlv(b, v)
                return b[s:e].decode("utf-8", "replace")
    return ""

def info(der):
    tbs = kids(der, 0)[0]
    f = kids(der, tbs)
    if der[f[0]] == 0xA0:
        f = f[1:]
    issuer, validity, subject, spki = f[2], f[3], f[4], f[5]
    nb, na = (time_at(der, x) for x in kids(der, validity))
    alg = kids(der, kids(der, spki)[0])
    key = oid(der, alg[0])
    if key == "1.2.840.10045.2.1":
        curve = {"1.2.840.10045.3.1.7": "P256", "1.3.132.0.34": "P384", "1.3.132.0.35": "P521"}.get(oid(der, alg[1]))
        kind = curve and ("Ec" + curve)
    elif key == "1.2.840.113549.1.1.1":
        tag, s, e = tlv(der, kids(der, spki)[1])
        n = kids(der[s + 1:e], 0)[0]
        tag, ns, ne = tlv(der[s + 1:e], n)
        bits = (ne - ns - (1 if der[s + 1 + ns] == 0 else 0)) * 8
        kind = f"Rsa{bits}" if bits in (2048, 3072, 4096) else None
    else:
        kind = None
    self_issued = der[issuer:tlv(der, issuer)[2]] == der[subject:tlv(der, subject)[2]]
    return {"kind": kind, "not_before": nb, "not_after": na, "self_issued": self_issued, "cn": cn(der, subject),
            "issuer": der[issuer:tlv(der, issuer)[2]], "subject": der[subject:tlv(der, subject)[2]]}

def load(path):
    der = open(path, "rb").read()
    if der.startswith(b"-----BEGIN CERTIFICATE-----"):
        der = base64.b64decode(b"".join(der.split(b"-----")[2].split()))
    return der

ALGS = {"EcP256": "EcdsaP256Sha256, EcdsaP256Sha384", "EcP384": "EcdsaP384Sha384, EcdsaP384Sha256", "EcP521": "EcdsaP521Sha512",
        "Rsa2048": "RsaPkcs1Sha256", "Rsa3072": "RsaPkcs1Sha256", "Rsa4096": "RsaPkcs1Sha256"}

def slug(s):
    return re.sub(r"_+", "_", re.sub(r"[^a-z0-9]+", "_", s.lower())).strip("_")

def main(d):
    today = datetime.datetime(2026, 10, 11)
    out, skipped, names, issued = [], [], set(), []
    for vendor in sorted(os.listdir(d)):
        rd = os.path.join(d, vendor, "RootCA")
        if vendor == "Microsoft" or not os.path.isdir(rd):
            continue
        for f in sorted(os.listdir(rd)):
            der = load(os.path.join(rd, f))
            if der[:1] != b"\x30":
                skipped.append(f"{vendor}/{f}: neither DER nor PEM"); continue
            x = info(der)
            if x["kind"] is None:
                skipped.append(f"{vendor}/{f}: a key Resid does not verify with"); continue
            if x["not_after"] < today:
                skipped.append(f"{vendor}/{f}: expired {x['not_after']:%Y-%m-%d}"); continue
            base = slug(os.path.splitext(f)[0])
            for w in (slug(vendor) + "_", "tpm_ek_", "tpm_"):
                base = base[len(w):] if base.startswith(w) else base
            fn = "tpm_ek_" + slug(vendor) + "_" + base
            assert fn not in names, fn
            names.add(fn)
            issued.append((fn, x, vendor))
            v = re.sub(r"[^A-Za-z0-9]", "", vendor)
            xs = [str(c) for c in der]
            rows = ",\n        ".join(", ".join(xs[i:i + 24]) for i in range(0, len(xs), 24))
            out.append(f'''// {vendor}: {x["cn"] or f} ({x["kind"]}, until {x["not_after"]:%Y-%m-%d}{"" if x["self_issued"] else "; cross-certified, Windows trusts it as a root"}).
@anchor(kind = TpmEk({v}), principal = InGuest, formats = [TpmAk, TpmQuoteEvidence, TpmCounter], source = "Microsoft TrustedTpm.cab ({vendor}/RootCA/{f})", fingerprint = "sha256:{hashlib.sha256(der).hexdigest()}", retrieved = "2026-10-11", reviewed_by = "Larry Dewey", algorithms = [{ALGS[x["kind"]]}], expires = "{min(x["not_after"], datetime.datetime(9999, 12, 31)):%Y-%m-%d}")
pub Anchor {fn}() {{ return anchor_der({fn}_der()); }}

pub List(Int) {fn}_der() {{
    return [
        {rows}
    ];
}}
''')
    sys.stdout.write('''// GENERATED by tools/attest/gen_tpm_anchors.py from Microsoft's TrustedTpm.cab
// (the TPM manufacturers' EK root CAs Windows trusts, 10-Aug-2026); do not
// edit. verify/tpm_anchors.resid — the roots a TPM's EK certificate chain
// ends at, one anchor each, for tpm_verify_ak (verify/tpm.resid). Pick the
// manufacturer's root by the chain's top issuer; a decision accepts the
// ones it trusts. Rebuild-only.
//
// Skipped:
''' + "".join(f"//   {s}\n" for s in skipped) + '''
import "core.resid";
import "tpm.resid";

''' + "\n".join(out))

    if len(sys.argv) > 2:
        write_tests(d, sys.argv[2], issued, today)

def write_tests(d, tests, issued, today):
    fx = os.path.join(tests, "fixtures", "tpm-roots")
    os.makedirs(fx, exist_ok=True)
    checks = []
    for fn, root, vendor in issued:
        idir = os.path.join(d, vendor, "IntermediateCA")
        pick = None
        for f in sorted(os.listdir(idir)):
            der = load(os.path.join(idir, f))
            try:
                x = info(der)
            except Exception:
                continue
            if x["issuer"] == root["subject"] and x["not_before"] <= today <= x["not_after"] and x["kind"]:
                pick = (f, der); break
        if pick is None:
            checks.append(f'    println("{fn}: no current intermediate in the cab");')
            continue
        open(os.path.join(fx, fn + ".der"), "wb").write(pick[1])
        checks.append(f'    println(link("{fn}", {fn}_der(), "{pick[0]}"));')
    open(os.path.join(tests, "run", "tpm_roots.resid"), "w").write('''// GENERATED by tools/attest/gen_tpm_anchors.py: each TPM manufacturer EK
// root in verify/tpm_anchors.resid against one current intermediate CA it
// issued (fixtures/tpm-roots/, from Microsoft's TrustedTpm.cab): the
// strict parse of both and the intermediate's signature, names, CA bits
// and validity (chain_verify_parsed) at 2026-10-11.

import "verify/tpm_anchors.resid";
import "x509.resid";
import "chain.resid";
import "instant.resid";

@requires(filesystem(readonly))
Str link(Str name, List(Int) root, Str from) {
    List(Int) der = filesystem.read_bytes("fixtures/tpm-roots/" + name + ".der");
    Instant at = instant_of_seconds(1791763200);
    return name + ": " + match (x509_parse(root)) {
        Err(e) => "the root does not parse: " + e,
        Ok(r) => match (x509_parse(der)) {
            Err(e) => "the intermediate does not parse: " + e,
            Ok(c) => if (chain_verify_parsed(c, r, at)) { "certifies " + from } else { "does NOT certify " + from },
        },
    };
}

@requires(filesystem(readonly))
Int main() {
''' + "\n".join(checks) + '''
    return 0;
}
''')

main(sys.argv[1])
