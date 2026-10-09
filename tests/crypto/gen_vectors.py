#!/usr/bin/env python3
"""Convert Wycheproof JSON test vectors into the line format
tests/crypto/probe.resid reads, under tests/crypto/vectors/.

Usage: tests/crypto/gen_vectors.py <dir-of-wycheproof-json> [commit]

The same directory may hold hpke.json, the RFC 9180 vectors from
https://github.com/cfrg/draft-irtf-cfrg-hpke (test-vectors.json); they go
to vectors/hpke_rfc9180.txt (P-256 and X25519 suites; P-521 and X448 are
not implemented).

The JSON comes from https://github.com/C2SP/wycheproof (testvectors_v1,
Apache-2.0). The converted files are committed so the suite needs neither
the network nor python; rerun this only to pull newer vectors.

Format: one record per line, fields separated by single spaces, "-" for an
empty hex string.
  # ...                               comment
  G <kind> <group fields...>          sets the group for the T lines after it
  T <tcId> <valid|invalid|acceptable> <test fields...>
"""
import json
import os
import sys

HASH = {"SHA-1": "sha1", "SHA-256": "sha256", "SHA-384": "sha384", "SHA-512": "sha512"}
CURVE = {"secp256r1": "p256", "secp384r1": "p384"}

FILES = [
    # name, kind
    ("ecdsa_secp256r1_sha256_test", "ecdsa"),
    ("ecdsa_secp256r1_sha512_test", "ecdsa"),
    ("ecdsa_secp384r1_sha256_test", "ecdsa"),
    ("ecdsa_secp384r1_sha384_test", "ecdsa"),
    ("ecdsa_secp384r1_sha512_test", "ecdsa"),
    ("ecdsa_secp256r1_sha256_p1363_test", "ecdsa"),
    ("ecdsa_secp256r1_sha512_p1363_test", "ecdsa"),
    ("ecdsa_secp384r1_sha384_p1363_test", "ecdsa"),
    ("ecdsa_secp384r1_sha512_p1363_test", "ecdsa"),
    ("ecdh_secp256r1_ecpoint_test", "ecdh"),
    ("ecdh_secp384r1_ecpoint_test", "ecdh"),
    ("ecdh_secp256r1_test", "ecdh"),
    ("ecdh_secp384r1_test", "ecdh"),
    ("rsa_signature_2048_sha256_test", "rsa1"),
    ("rsa_signature_2048_sha384_test", "rsa1"),
    ("rsa_signature_2048_sha512_test", "rsa1"),
    ("rsa_signature_3072_sha256_test", "rsa1"),
    ("rsa_signature_3072_sha384_test", "rsa1"),
    ("rsa_signature_3072_sha512_test", "rsa1"),
    ("rsa_signature_4096_sha256_test", "rsa1"),
    ("rsa_signature_4096_sha384_test", "rsa1"),
    ("rsa_signature_4096_sha512_test", "rsa1"),
    ("rsa_pss_2048_sha256_mgf1_0_test", "pss"),
    ("rsa_pss_2048_sha256_mgf1_32_test", "pss"),
    ("rsa_pss_2048_sha384_mgf1_48_test", "pss"),
    ("rsa_pss_3072_sha256_mgf1_32_test", "pss"),
    ("rsa_pss_4096_sha256_mgf1_32_test", "pss"),
    ("rsa_pss_4096_sha384_mgf1_48_test", "pss"),
    ("rsa_pss_4096_sha512_mgf1_32_test", "pss"),
    ("rsa_pss_4096_sha512_mgf1_64_test", "pss"),
    ("rsa_pss_misc_test", "pss"),
    ("hmac_sha256_test", "hmac"),
    ("hmac_sha384_test", "hmac"),
    ("hmac_sha512_test", "hmac"),
    ("hkdf_sha256_test", "hkdf"),
    ("hkdf_sha384_test", "hkdf"),
    ("hkdf_sha512_test", "hkdf"),
    ("aes_gcm_test", "gcm"),
    ("aes_wrap_test", "kw"),
    ("chacha20_poly1305_test", "chacha"),
    ("x25519_test", "x25519"),
    ("ed25519_test", "ed25519"),
]


def h(s):
    return s if s else "-"


def hash_of_file(name):
    for part in name.split("_"):
        if part.startswith("sha"):
            return part
    raise SystemExit("no hash in " + name)


def convert(name, kind, d):
    out = []
    for g in d["testGroups"]:
        if kind == "ecdsa":
            enc = "raw" if "p1363" in name else "der"
            out.append(f"G ecdsa {CURVE[g['publicKey']['curve']]} {HASH[g['sha']]} {enc} {g['publicKey']['uncompressed']}")
            for t in g["tests"]:
                out.append(f"T {t['tcId']} {t['result']} {h(t['msg'])} {h(t['sig'])}")
        elif kind == "ecdh":
            form = "point" if g["encoding"] == "ecpoint" else "spki"
            if g["curve"] not in CURVE:
                continue
            out.append(f"G ecdh {CURVE[g['curve']]} {form}")
            for t in g["tests"]:
                out.append(f"T {t['tcId']} {t['result']} {h(t['public'])} {h(t['private'])} {h(t['shared'])}")
        elif kind == "rsa1":
            pk = g["publicKey"]
            out.append(f"G rsa1 {HASH[g['sha']]} {pk['modulus']} {pk['publicExponent']}")
            for t in g["tests"]:
                out.append(f"T {t['tcId']} {t['result']} {h(t['msg'])} {h(t['sig'])}")
        elif kind == "pss":
            pk = g["publicKey"]
            if g["mgf"] != "MGF1" or g["sha"] not in HASH or g["mgfSha"] not in HASH:
                continue
            out.append(f"G pss {HASH[g['sha']]} {HASH[g['mgfSha']]} {g['sLen']} {pk['modulus']} {pk['publicExponent']}")
            for t in g["tests"]:
                out.append(f"T {t['tcId']} {t['result']} {h(t['msg'])} {h(t['sig'])}")
        elif kind == "hmac":
            out.append(f"G hmac {hash_of_file(name)} {g['tagSize'] // 8}")
            for t in g["tests"]:
                out.append(f"T {t['tcId']} {t['result']} {h(t['key'])} {h(t['msg'])} {h(t['tag'])}")
        elif kind == "hkdf":
            out.append(f"G hkdf {hash_of_file(name)}")
            for t in g["tests"]:
                out.append(f"T {t['tcId']} {t['result']} {h(t['ikm'])} {h(t['salt'])} {h(t['info'])} {t['size']} {h(t['okm'])}")
        elif kind in ("gcm", "chacha"):
            out.append(f"G {kind} {g['ivSize']} {g['tagSize']}")
            for t in g["tests"]:
                out.append(f"T {t['tcId']} {t['result']} {h(t['key'])} {h(t['iv'])} {h(t['aad'])} {h(t['msg'])} {h(t['ct'])} {h(t['tag'])}")
        elif kind == "kw":
            out.append("G kw")
            for t in g["tests"]:
                out.append(f"T {t['tcId']} {t['result']} {h(t['key'])} {h(t['msg'])} {h(t['ct'])}")
        elif kind == "x25519":
            out.append("G x25519")
            for t in g["tests"]:
                out.append(f"T {t['tcId']} {t['result']} {h(t['public'])} {h(t['private'])} {h(t['shared'])}")
        elif kind == "ed25519":
            out.append(f"G ed25519 {g['publicKey']['pk']}")
            for t in g["tests"]:
                out.append(f"T {t['tcId']} {t['result']} {h(t['msg'])} {h(t['sig'])}")
    return out


def convert_hpke(d):
    out = []
    tc = 1
    for v in d:
        if v["kem_id"] not in (16, 32):
            continue
        g = [v["mode"], v["kem_id"], v["kdf_id"], v["aead_id"], h(v["info"]), h(v["ikmE"]), h(v["ikmR"]),
             h(v.get("ikmS", "")), h(v.get("psk", "")), h(v.get("psk_id", "")), h(v["enc"]), h(v["key"]),
             h(v["base_nonce"]), h(v["exporter_secret"]), v["pkRm"]]
        out.append("G hpke " + " ".join(str(x) for x in g))
        encs = v["encryptions"]
        picks = sorted(set(i for i in (0, 1, 2, len(encs) - 1) if 0 <= i < len(encs)))
        for i in picks:
            e = encs[i]
            out.append(f"T {tc} valid e {i} {h(e['aad'])} {h(e['pt'])} {h(e['ct'])}")
            tc += 1
        for x in v["exports"]:
            out.append(f"T {tc} valid x {h(x['exporter_context'])} {x['L']} {x['exported_value']}")
            tc += 1
    return out


def main():
    src = sys.argv[1]
    commit = sys.argv[2] if len(sys.argv) > 2 else "unknown"
    dst = os.path.join(os.path.dirname(os.path.abspath(__file__)), "vectors")
    os.makedirs(dst, exist_ok=True)
    for name, kind in FILES:
        with open(os.path.join(src, name + ".json")) as f:
            d = json.load(f)
        lines = [f"# wycheproof {commit} testvectors_v1/{name}.json (Apache-2.0)"] + convert(name, kind, d)
        with open(os.path.join(dst, name + ".txt"), "w") as f:
            f.write("\n".join(lines) + "\n")
        print(f"{name}: {sum(1 for l in lines if l.startswith('T '))} tests")
    hp = os.path.join(src, "hpke.json")
    if os.path.exists(hp):
        with open(hp) as f:
            d = json.load(f)
        lines = ["# RFC 9180 test vectors, cfrg/draft-irtf-cfrg-hpke test-vectors.json"] + convert_hpke(d)
        with open(os.path.join(dst, "hpke_rfc9180.txt"), "w") as f:
            f.write("\n".join(lines) + "\n")
        print(f"hpke_rfc9180: {sum(1 for l in lines if l.startswith('T '))} tests")


if __name__ == "__main__":
    main()
