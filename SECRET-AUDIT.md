# Secret-type audit

This is the audit gate for private and sensitive values. `Secret(T)` is not a
documentation marker: it is the compiler's taint, zeroization and register
safety mechanism. A value that can be a private key, share, nonce, seed,
plaintext or session secret must not be carried in a plain type across a
cryptographic operation.

## Current result

The standard library's generic cryptographic modules already carry secret
instantiations (`ecdsa`, `ed25519`, `x25519`, AES, SHA, Argon2, HPKE's generic
engine, TLS keys, TPM/SPDM secrets). The coverage gate reports 368 secret
library functions; 305 are reached by the constant-time cases and 76 cases
pass under memcheck.

The CGGMP21 reference implementation is **not** secret-typed. Its private
material is plain `List(UInt(64))` in `CgConfig`, `CgCtx`, `PaillierSec`,
`PaillierPub` internals and the keygen/reshare state. That code is a
public-value, variable-time protocol oracle for differential testing only. It
must not be linked into a program that accepts real key material. This is a
release blocker, not a passing claim.

`lib/cggmp_secret_types.resid` defines `CgSecretMaterial` with every private
field as `List(Secret(UInt(8)))` and no plain conversion. It is the required
storage shape for production CGGMP material. `lib/cggmp_secret_config.resid`
adds secret byte-to-scalar/Paillier conversions and `cggmp_secret_protocol.resid`
adds a secret `CgSecretCtx` private-state shape. and a secret ECDSA-share tweak;
every operation stays `Secret` and the module has no declassification.
`lib/cggmp_secret_scalar.resid`
provides the real `Secret(UInt(576))` P-256 scalar path (add, multiply,
inverse, lift) with no declassification. The existing `CgConfig` remains a
test/oracle shape until the protocol is refactored to consume this type.
`lib/cggmp_secret_paillier.resid` provides a real masked Paillier path over N
up to 2048 bits with Secret(UInt(2048)) plaintexts and Secret(UInt(4096))
ciphertexts (Montgomery multiply/exponent, secret division, encrypt and lambda
decryption) with no declassification.
Secret Paillier now covers N up to 2048 bits with masked Secret(UInt(4096))
ciphertext arithmetic; its reference and CT cases pass.  It is still not wired
into the CGGMP protocol, whose remaining secret-material work is the protocol
state and proof statements.

`declassify` is allowed only at an explicitly named publication boundary. No
`declassify` occurs in `lib/cggmp*.resid`. No wrapper is permitted to turn a
private key into a plain value and then feed it to a variable-time backend.

## Required before production

1. Store ECDSA shares, ElGamal secrets, Paillier `p/q`, Pedersen `lambda`,
   RID/chain keys, session seeds and nonces as `List(Secret(UInt(8)))` (or a
   secret fixed-width scalar where the width is bounded).
2. Implement secret big-integer add, subtract, multiply, comparison-masked
   reduction, inversion, exponentiation, gcd and Paillier decryption without
   branching on a secret limb. Keep the ciphertext public; keep plaintexts and
   keys secret.
3. Make the CGGMP proof statements operate on secret-typed witnesses and keep
   only public commitments, ciphertexts and verdicts in transcript bytes.
4. Add a memcheck case for every secret function; the coverage gate must reach
   every one with no waiver.
5. Keep the current public CGGMP implementation behind a test-only name or
   package boundary so production code cannot select it accidentally.

Until those steps pass, Layer 8 is **open** and the CGGMP21 implementation is
**not production-safe**.
