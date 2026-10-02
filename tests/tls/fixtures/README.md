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

| file | what it is |
|---|---|
| `certmsg.bin` | a real TLS 1.3 `Certificate` message body captured from a live handshake: one certificate, with a `certificate_list` two bytes longer than the entry in it |
| `certmsg2.bin` | the same shape holding `leaf.der` and `inter.der` |
| `certmsg3.bin` | `leaf.der`, `inter.der` and `root.der` |
| `certmsg-ctx.bin` | `certmsg2` with a two-byte request context |
| `certmsg-long.bin` | one certificate under an over-long `certificate_list` |
| `certmsg-trunc.bin` | `certmsg2` cut short in the middle of the second entry |

The `.bin` files are Certificate message *bodies*, byte-for-byte as they
appear on the wire, which is what `tm_cert_list` reads.

| `ca.pem`, `ca.der` | `CN=CRL Test CA`, a second CA used only for revocation |
| `good.pem`, `good.der` | `CN=localhost` issued by that CA, serial `2000` |
| `bad.pem`, `bad.der` | `CN=localhost` issued by that CA, serial `2001`, revoked with `keyCompromise` |
| `crl.pem`, `crl.der` | that CA's CRL, listing serial `2001` |
| `rsa_pkcs1.pem`, `rsa_pkcs1.der` | self-signed `CN=Test RSA Root`, signed with sha256WithRSAEncryption |
| `rsa_pss.pem`, `rsa_pss.der` | self-signed `CN=Test RSA-PSS Root`, signed with rsassaPss (SHA-256, MGF1-SHA-256, salt 32) |

The CRL's `thisUpdate` is when it was generated, so the revocation cases
pass an explicit `now` into the probe rather than reading the clock: a
freshly generated CRL has a window in the future, and both sides of it
have to be testable.

The two RSA roots exist because RSA certificate signatures were verified
by nothing at all. They now are, by all three of the cases above.

## The OCSP fixtures

`ocsp-good.der` and `ocsp-revoked.der` are `BasicOCSPResponse` bodies in a
full `OCSPResponse` envelope, signed by the CA itself. `revoked.der` is the
serial-2001 certificate that `ocsp-revoked.der` reports revoked.

Regenerate them with:

    openssl ocsp -index ocsp-index.txt -CA ca.pem -issuer ca.pem \
        -rsigner ca.pem -rkey ca.key -cert good.pem \
        -reqout req-good.der -no_nonce
    openssl ocsp -index ocsp-index.txt -CA ca.pem -issuer ca.pem \
        -rsigner ca.pem -rkey ca.key -reqin req-revoked.der \
        -respout ocsp-revoked.der -no_nonce

Two things cost time and are worth writing down.

The index used for OCSP is separate from the one the CRL fixture uses,
because the OCSP index needs a *past* revocation date. With a date in the
future `openssl ocsp` produces no response and says nothing at all -- it
writes no file, no error, exit 0. `ocsp-index.txt` is that index:

    V	290104004758Z		2000	unknown	/CN=localhost
    R	290104004758Z	250101000000Z,keyCompromise	2001	unknown	/CN=localhost

Pass `-cert` a PEM, not a DER. A DER `-cert` makes openssl report "No
issuer certificate specified" instead of reading it.

`revoked_at` is asserted as the fixed literal 1735689600 rather than
computed, so the test pins the instant rather than restating the fixture.

### The delegated responder

`del.pem` is not committed and nothing uses it yet: it is the responder
certificate the delegated-responder path is to be tested against. It is
generated with an OCSP-signing EKU and is deliberately not a CA:

    openssl req -new -newkey ec -pkeyopt ec_paramgen_curve:P-256 -nodes \
        -keyout del.key -subj "/CN=OCSP Responder" -out del.csr
    printf 'basicConstraints=CA:FALSE\nkeyUsage=digitalSignature\nextendedKeyUsage=OCSPSigning\n' > del.ext
    openssl x509 -req -in del.csr -CA ca.pem -CAkey ca.key -set_serial 0x3001 \
        -days 3650 -extfile del.ext -out del.pem
    openssl ocsp -index ocsp-index.txt -CA ca.pem -issuer ca.pem \
        -rsigner del.pem -rkey del.key -reqin req-good.der \
        -respout ocsp-delegated.der -no_nonce

openssl accepts the result -- `openssl ocsp -respin ocsp-delegated.der
-CAfile ca.pem -VAfile ca.pem` reports `Response verify OK` -- so it is a
valid fixture for the path that is still to be written. Committing it
before there is a test for it would be a fixture with nothing checking it.
