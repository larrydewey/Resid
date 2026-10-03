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
| `dca.pem`, `dca.der` | `CN=OCSP Delegated CA`, the issuer for the delegated-responder cases |
| `dgood.pem`, `dgood.der` | `CN=localhost` issued by that CA, serial `4000` |
| `del.pem`, `del.der` | `CN=OCSP Responder` issued by `dca`, carrying the OCSPSigning EKU and explicitly not a CA |
| `delnoeku.pem`, `delnoeku.der` | the same responder certificate with the EKU left off, so it is authorised for nothing |

The CRL's `thisUpdate` is when it was generated, so the revocation cases
pass an explicit `now` into the probe rather than reading the clock: a
freshly generated CRL has a window in the future, and both sides of it
have to be testable.

The two RSA roots exist because RSA certificate signatures were verified
by nothing at all. They now are, by all three of the cases above.

## The server fixtures

A *server* cannot be tested with keys that were thrown away: it has to
sign with one. So unlike the fixtures above, these private keys are
committed, and that is the whole point of them — they are test keys for a
handshake that has to sign something, and nothing else uses them.

| file | what it is |
|---|---|
| `srvca.pem`, `srvca.der`, `srvca.key` | `CN=TLS Server Test CA`, ECDSA P-256, self-signed |
| `srv.pem`, `srv.der`, `srv.key`, `srv.key.der` | `CN=localhost`, SAN `DNS:localhost,IP:127.0.0.1`, EKU serverAuth, signed by that CA, serial `0x5000`. The key is PKCS#8 PEM and, in `srv.key.der`, PKCS#8 DER |
| `srvedca.pem`, `srvedca.der`, `srvedca.key` | `CN=TLS Server Ed25519 CA` |
| `srved.pem`, `srved.der`, `srved.key`, `srved.key.der` | the same leaf under the Ed25519 CA, serial `0x5001` |

Both leaves are served with their CA in the chain, so the client walks
intermediates rather than being handed a single certificate.

Made with:

    openssl ecparam -name prime256v1 -genkey -noout -out srvca.key
    openssl req -new -x509 -key srvca.key -sha256 -days 7300 -subj "/CN=TLS Server Test CA" \
        -addext "basicConstraints=critical,CA:TRUE" -addext "keyUsage=critical,keyCertSign,cRLSign" \
        -out srvca.pem
    openssl req -new -newkey ec -pkeyopt ec_paramgen_curve:P-256 -nodes \
        -keyout srv.key -subj "/CN=localhost" -out srv.csr
    printf 'basicConstraints=CA:FALSE\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth\nsubjectAltName=DNS:localhost,IP:127.0.0.1\n' > srv.ext
    openssl x509 -req -in srv.csr -CA srvca.pem -CAkey srvca.key -set_serial 0x5000 \
        -days 3650 -sha256 -extfile srv.ext -out srv.pem
    openssl pkey -in srv.key -outform der -out srv.key.der

and the same three steps with `openssl genpkey -algorithm ed25519` for the
Ed25519 pair. `ch-ossl.bin` is a whole TLS 1.3 record: a real openssl 3.6
`ClientHello`, captured on a loopback socket, headers included.

Two things about that capture are worth keeping in mind. It leads with an
X25519MLKEM768 hybrid share (group `0x11ec`, 1216 bytes), so a server that
only speaks x25519 has to skip the entry it cannot use and take the one
after it — the server path is exercised on every run against this file.
And it advertises `compress_certificate`, an extension this server does
not implement and never echoes back, which is how a peer learns it was not
negotiated.

### The pinned signatures

`srvprobe --sign` prints two signatures over
`TLS 1.3, server CertificateVerify fixture`: one drawn (ECDSA nonce from
the system) and one with a fixed nonce, which makes the bytes a function
of the content and the key alone. Only the fixed one is asserted, and
openssl verifies both:

    printf 'TLS 1.3, server CertificateVerify fixture' > fixture.bin
    openssl x509 -in srv.pem -noout -pubkey > pub.pem
    openssl dgst -sha256 -verify pub.pem -signature pinned.der fixture.bin

    openssl x509 -in srved.pem -noout -pubkey > pubed.pem
    openssl pkeyutl -verify -pubin -inkey pubed.pem -rawin \
        -in fixture.bin -sigfile pinneded.der

The drawn ECDSA signature is 70 or 71 DER bytes depending on whether `r`
and `s` need a leading zero octet, so its length is not a fact to pin;
Ed25519 is always 64.

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

`ocsp-delegated.der` is signed by `del.der` rather than by the issuer, and
carries that certificate in its `certs` field. `ocsp-delegated-noeku.der`
is the same response signed by `delnoeku.der`, which is identical but for
the missing EKU: openssl refuses that one (`ocsp_check_delegated: missing
ocspsigning usage`), and so does `issuer_accepts`.

These have a CA of their own rather than reusing `ca.pem`, because the CA
keys were thrown away when the fixtures were first made (see above), so
nothing can now be signed *by* the committed `ca.der` -- a new responder
certificate under it would need a new `ca.der`, and with it a new
`good.der`, `bad.der`, `crl.der` and both existing responses, since the
CertID hashes the issuer's key. The delegated cases need none of that
churn. `dca.der` is generated here, keys and all:

    openssl ecparam -name prime256v1 -genkey -noout -out dca.key
    openssl req -new -x509 -key dca.key -sha256 -days 7300 \
        -subj "/CN=OCSP Delegated CA" -out dca.pem \
        -addext "basicConstraints=critical,CA:TRUE" \
        -addext "keyUsage=critical,keyCertSign,cRLSign"

    openssl req -new -newkey ec -pkeyopt ec_paramgen_curve:P-256 -nodes \
        -keyout dgood.key -subj "/CN=localhost" -out dgood.csr
    printf 'basicConstraints=CA:FALSE\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth\nsubjectAltName=DNS:localhost\n' > dgood.ext
    openssl x509 -req -in dgood.csr -CA dca.pem -CAkey dca.key \
        -set_serial 0x4000 -days 3650 -sha256 -extfile dgood.ext -out dgood.pem

    openssl req -new -newkey ec -pkeyopt ec_paramgen_curve:P-256 -nodes \
        -keyout del.key -subj "/CN=OCSP Responder" -out del.csr
    printf 'basicConstraints=CA:FALSE\nkeyUsage=digitalSignature\nextendedKeyUsage=OCSPSigning\n' > del.ext
    printf 'basicConstraints=CA:FALSE\nkeyUsage=digitalSignature\n' > delnoeku.ext
    openssl x509 -req -in del.csr -CA dca.pem -CAkey dca.key \
        -set_serial 0x4001 -days 3650 -sha256 -extfile del.ext -out del.pem
    openssl x509 -req -in del.csr -CA dca.pem -CAkey dca.key \
        -set_serial 0x4002 -days 3650 -sha256 -extfile delnoeku.ext -out delnoeku.pem

    printf 'V\t290104004758Z\t\t4000\tunknown\t/CN=localhost\n' > dindex.txt
    openssl ocsp -issuer dca.pem -cert dgood.pem -reqout req-dgood.der -no_nonce
    openssl ocsp -index dindex.txt -CA dca.pem -issuer dca.pem \
        -rsigner del.pem -rkey del.key -reqin req-dgood.der \
        -respout ocsp-delegated.der -no_nonce
    openssl ocsp -index dindex.txt -CA dca.pem -issuer dca.pem \
        -rsigner delnoeku.pem -rkey del.key -reqin req-dgood.der \
        -respout ocsp-delegated-noeku.der -no_nonce

The serial in the index is hex, like the certificate's. Only the `V` entry
is needed: a good answer is a status, not a date, and the revocation date
column is irrelevant to it.

`openssl ocsp -respin ocsp-delegated.der -CAfile dca.pem -VAfile dca.pem`
reports `Response verify OK`, and the responder certificate really is in
the response rather than assumed -- `-resp_text` lists serial `4001`
under the certificate section.
