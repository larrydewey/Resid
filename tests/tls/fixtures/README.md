# TLS trust-store fixtures

Certificates for `tests/tls/run.sh`. Generated once with openssl and
committed so the suite needs no openssl at test time.

All are ECDSA P-256, which is what `lib/chain.resid`'s `chain_verify`
verifies (`ecdsa_vx`, the same routine the CertificateVerify check uses).

| file | what it is |
|---|---|
| `root.pem`, `root.der` | self-signed CA, `CN=Test Root CA`, the trust anchor |
| `inter.pem`, `inter.der` | `CN=Test Intermediate CA`, signed by the root |
| `leaf.pem`, `leaf.der` | `CN=localhost`, SAN `DNS:localhost,IP:127.0.0.1`, signed by the intermediate |
| `other.pem`, `other.der` | an unrelated self-signed CA — a store holding only this must reject `leaf.der` |
| `oleaf.pem`, `oleaf.der` | `CN=localhost` issued by `other.pem`, not by the root |
| `expired.pem`, `expired.der` | self-signed `CN=localhost`, valid 2020-01-01 to 2020-01-02 |

Nothing here is a secret and nothing here is used outside tests: the
private keys were thrown away.
