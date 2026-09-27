---
title: Standard library
description: The modules in lib/, all written in Resid.
---

Import a module by file name; the compiler finds it in the standard library
directory:

```resid
import "crypto.resid";

Int main() {
    println(sha256("abc"));
    println(base64_encode(bytes_of("hi")));
    return 0;
}
```

```text title="Output"
ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
aGk=
```

| Module | Provides |
|---|---|
| `crypto.resid` | SHA-256 (`sha256`, `sha256_bytes`), SHA-512, HMAC-SHA-256, HKDF, PBKDF2, `hex_encode`, `base64_encode`, `bytes_of`, `random_bytes` |
| `ed25519.resid` | Ed25519 keys, signatures and strict verification (`pub_key`, `sign_msg`, `verify_sig`) |
| `x25519.resid` | X25519 key agreement (RFC 7748) |
| `ec256.resid` | NIST P-256 ECDSA verification |
| `rsa.resid` | big-number arithmetic and RSA PKCS#1 v1.5 verification |
| `aesgcm.resid` | AES-128-GCM, with AES-NI when the CPU has it |
| `chacha.resid` | ChaCha20-Poly1305 (RFC 8439) |
| `der.resid` | an ASN.1 DER decoder |
| `x509.resid` | X.509 certificate structure |
| `chain.resid` | X.509 chain validation and SAN matching |
| `tlsmsg.resid`, `tls.resid` | TLS 1.3 message framing and the handshake key schedule (RFC 8446) |
| `http.resid` | an HTTP/1.1 client (`http_get`) |
| `h2.resid` | HTTP/2 framing and HPACK |
| `cose.resid` | CBOR (preferred serialization) and COSE Sign1 / Encrypt0 |
| `dwarf.resid` | reading an ELF64 binary's symbols and DWARF 5 line table |
| `kgart.resid` | reading the knowledge-graph artifact |
| `testing.resid` | explicit test registration and property tests |

Everything above is plain Resid: the cryptography uses the language's wide
integers (`Int(256)`, `Int(512)`) and is tested against the published test
vectors in `tests/conformance`.

Built into the language itself (no import): the string functions (see
[Strings](/Resid/learn/strings/)), the list, map and set methods, `sort`,
the numeric verbs, the conversion helpers, `StrBuf` / `ListBuf`, and the
providers.
