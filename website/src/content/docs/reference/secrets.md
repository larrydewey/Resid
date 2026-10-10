---
title: Secret values
description: Secret(T), declassify and what a secret may and may not do.
---

`Secret(T)` is a value the program holds but may not observe through
control flow, a memory address or an output. The rules are checked by the
compiler; the full design is `PLAN-secret-type.md` in the repository.

```resid
@requires(declassify)
Int main() {
    Secret(Int) k = secret(rt 41);
    Secret(Int) m = (k ^ 7) & 255;          // bitwise work stays secret
    Secret(Int) w = wrapping_add(m, k);     // so does wrapping arithmetic
    Int out = declassify(w, "test output"); // the one exit, authorized and recorded
    println(f"{out}");                      //> 87
    return 0;
}
```

## Making and publishing secrets

- `secret(x)` wraps a value. `T` may not be `Option`, `Result`, a sum type,
  `Map`, `Set`, a handle, a function or a secret (`E0253`).
- A secret whose value the compiler knows after reduction is refused
  (`E0250`): it would be in the binary for everyone who has it. Read
  secrets at run time. `declassify(secret(41), "why")` is accepted, since it
  states that the value is public.
- `declassify(s, "reason")` returns the `T`. It needs
  `@requires(declassify)`, carried to every caller like any capability
  (`E0219`); the family has no modes. The reason is a non-empty string
  literal (`E0251`) and is recorded with the call in the graph artifact
  (effect `declassify.<reason>`, capability `declassify`).

## What a secret may do

| Allowed, result secret | Refused |
|---|---|
| `&`, `\|`, `^` with integers; `<<` and `>>` by a public amount | `+ - *` (checked: overflow aborts, `E0254`) |
| `wrapping_add`, `wrapping_sub`, `wrapping_mul`, `wrapping_i8` .. `wrapping_u512` conversions | `/`, `%`, comparisons, `&&`, `\|\|` (`E0255`) |
| `ct_hide(x)` (an optimizer barrier for a mask) | |
| `aesni_enc_round`, `aesni_enc_last_round`, `gf128_mul_hw` (constant-time instructions) | |
| a cast to an integer type that holds every value (`(UInt(576)) b` for a `Secret(UInt(8))` `b`) | a cast that could lose a value, which is checked and aborts (`E0255`; use `wrapping_*`) |
| reading a secret list at a public index | a secret index, range bound or shift amount (`E0255`) |
| storing it in a record field or list | deciding an `if`, `while`, `match` or ternary (`E0255`) |
| `ct_select(c, a, b)` with a `Secret(Bool)` `c` | methods, except a secret list's, bytes' or text's `.len()` (`E0255`) |
| | being a `Map` key or `Set` element in any type (`E0253`) |
| | a provider argument, including `filesystem.write_secret` (`E0255`) |
| | a `spawn` region's result (`E0255`) |

To persist key material, declassify it under the grant and write it with
`filesystem.write_secret`, which keeps the file readable by its owner only:
`filesystem.write_secret(path, declassify(key, "persist the key"))`.

The builtins `secret`, `declassify`, `classify`, `secret_split`,
`secret_join` and `ct_select` are reserved: a program cannot define a
function by those names (`E0259`), since it would replace the builtin in
every module, libraries included.

## Secret byte strings and public values

- Secret byte strings are `UInt(8)` lists: `Secret(List(UInt(8)))` or
  `List(Secret(UInt(8)))`. A secret integer wider than 32 bits may not be
  stored in a list, builder, vector, map or set (`E0258`), written or
  inferred: the runtime boxes list integers of 2^54 or more, a choice made
  on the value. Keep 64-bit secrets in records and parameters.
  `secret_bytes(bs)` in `lib/word.resid` turns a byte string read at run
  time into `List(Secret(UInt(8)))`.
- `secret_split(s)` turns a `Secret(List(T))` into a `List(Secret(T))`
  (its length is public); `secret_join(xs)` turns it back. Both are free at
  run time. Generic code takes byte strings as `List(T)`, so the split form
  lets it take secret ones.
- `classify(x)` lifts a public value into secret computation, for example
  padding constants or public message bytes mixed with a key. It claims no
  secrecy, so `E0250` does not apply to it.

## One implementation for public and secret data

`lib/word.resid` declares `Word(W, B)`: the 32-bit word operations SHA-2
and friends need (xor, and, or, add modulo 2^32, rotations, shifts by a
public amount, public constants, byte conversions), with instances for
public data `(Int, Int)` and secret data `(Secret(UInt(32)),
Secret(UInt(8)))`.
Cryptographic code is written once, generic over `T`, and the compiler
checks the secret copy like any other code on secrets. The public copy is
the same code, compiled separately, at the cost of hand-written `Int` code.

`lib/sha256g.resid` is the first such module: SHA-256, HMAC-SHA-256 and
HKDF-SHA-256 for `List(T)` byte strings. `lib/crypto.resid`'s software
SHA-256 block function is its public copy. `lib/sha512g.resid` does the
same for SHA-512, SHA-384 and their HMACs over `Word64(W, B)` (64-bit
words `W`, bytes `B`).

A 64-bit secret word is never stored in a list (`E0258`): generic code
keeps such words in records and parameters, and `tests/ct` checks the
result under valgrind.

`lib/chachag.resid` is ChaCha20, Poly1305 and the ChaCha20-Poly1305 AEAD
(RFC 8439), generic over `Word(W, B)` for the ChaCha words and
`Wide512(P, B)` (also in `lib/word.resid`) for Poly1305: 512-bit
integers, `Int(512)` or `Secret(Int(512))`, with wrapping arithmetic,
public shifts, a sign mask and public constants. The accumulator and key
live in parameters, never in a list. `lib/chacha.resid`'s API is the
public copy. The nonce, the block counter, the associated data, every
length and the received ciphertext are public (lifted into `B` with
`w_lift_bytes`). Sealing at secret types returns a secret ciphertext and
tag; the caller declassifies them to send them. Opening publishes one
bit, whether the tag matched, through `CtSame(B)` in `lib/crypto.resid`:
`ct_equal` at public bytes and `ct_eq` at secret bytes, so the secret copy
needs `@requires(declassify)` and the public copy does not.

`lib/x25519g.resid` is X25519 (RFC 7748), generic over `Wide512(P, B)`:
field elements mod 2^255 - 19 are `P` values in parameters, always
reduced below p, and the Montgomery ladder swaps with xor masks built
from the scalar bit, never a branch. `lib/x25519.resid`'s API is the
public copy. The private scalar is secret; the peer's public key is public
and lifted. `x25519g(k, u)` and `x25519g_shared(priv, peer)` return the
shared secret as secret bytes. Two facts are published, each through a
behavior whose secret instance declassifies, so the secret copy needs
`@requires(declassify)`: whether the shared secret is all zeros (a
low-order peer, refused; `CtSame(B)`), and the public key derived by
`x25519g_public(priv)` (public by design; `X25519Pub(B)`).

```text
List(Secret(UInt(8))) sk = secret_bytes(read_key());
List(Int) pk = x25519g_public(sk);                  // published
List(Secret(UInt(8))) shared = x25519g_shared(sk, peer_pk);
```

```text
List(Secret(UInt(8))) key = secret_bytes(read_key());
List(Secret(UInt(8))) sealed = chacha20poly1305g_seal(key, nonce, secret_bytes(msg), aad);
List(UInt(8)) wire = declassify(secret_join(sealed), "AEAD output is public");
Option(List(Secret(UInt(8)))) opened = chacha20poly1305g_decrypt(key, nonce, received, aad);
```

`lib/aesgcmg.resid` is AES-128/192/256, AES-GCM with any IV length and
AES key wrap (RFC 3394), generic over `Word(W, B)` and `Block128(X, W,
B)` (also in `lib/word.resid`): 128-bit blocks, `UInt(128)` or
`Secret(UInt(128))`, kept in records and parameters. The round keys are
the schedule as a list of 32-bit words, and the 128-bit round keys the
AES-NI path uses live in a record (`AesKeyG`). On a CPU with AES-NI /
AESE and PCLMULQDQ / PMULL the rounds and GHASH run on
`aesni_enc_round`, `aesni_enc_last_round` and `gf128_mul_hw`, which take
secrets since they run in constant time; otherwise the software cipher
computes the S-box four bytes at a time in a 32-bit word and GHASH
multiplies with masks. `lib/aesgcm.resid`'s API is the public copy. The
IV, the associated data, the lengths, the received ciphertext and the
wrapped key are public; sealing and wrapping at secret types return
secret bytes the caller declassifies; open and unwrap publish one bit
through `CtSame(B)`, so the secret copies need `@requires(declassify)`.

```text
List(Secret(UInt(8))) key = secret_bytes(read_key());
List(Secret(UInt(8))) sealed = aes_gcmg_seal(key, iv, secret_bytes(msg), aad);
Option(List(Secret(UInt(8)))) dek = aes_key_unwrapg(key, wrapped);
```

`lib/p256.resid` and `lib/p384.resid` (generated from one template by
`tools/gen_nistp.py`) are P-256 and P-384, generic over `P256Word(F, B)`
and `P384Word(F, B)`: field elements `F` are `UInt(576)` / `UInt(832)`,
or `Secret(UInt(576))` / `Secret(UInt(832))` when they derive from a
private key or a nonce, always in records and parameters. The field and
scalar arithmetic, the masked ladder, Fermat inversion of the nonce
(a fixed public exponent), public key derivation, ECDH, signing and the
RFC 6979 nonce (an HMAC-DRBG over the generic HMACs, keyed by the secret
key) are written once. `lib/ecdsa.resid` takes the private key as
`List(B)`: `ecdsag_sign_digest`, `ecdsag_sign`, `ecdsag_sign_raw`,
`ecdsag_sign_digest_k`, `ec_public_keyg` and `ecdhg`, and its functions
on `List(Int)` are the public copies. A signature and a public key are
public by design, and so are the verdicts "this key is usable" and "this
point is not infinity": they are published through the behavior's
`p256w_open` / `p384w_open`, `ct_public` at public types and `declassify`
at secret types, so the secret copies of signing, key derivation and
ECDH need `@requires(declassify)`. The ECDH shared secret stays secret.
Verification takes only public data and runs on the public copy.

```text
List(Secret(UInt(8))) d = secret_bytes(read_key());
List(Int) sig = ecdsag_sign(P256, Sha256, d, msg);           // published: needs declassify
List(Secret(UInt(8))) z = ecdhg(P384, d384, peer_public_key); // stays secret
```

`lib/ed25519g.resid` is Ed25519 key generation and signing (RFC 8032),
generic over `Wide512(P, B)` (field elements and scalars) and
`Word64(W, B)` (SHA-512 of the seed); `lib/ed25519.resid`'s API,
including verification, is the public copy. The seed, the expanded key,
the nonce `r` and the scalar arithmetic with `a` are secret at secret
types; the scalar multiplication is a double-and-always-add ladder that
picks the sum or the double with a mask, with no table, index or branch
on a scalar bit. The public key and the signature are public by design:
they leave through `Publish(B)` in `lib/word.resid`, a copy at public
bytes and a declassification at secret bytes, so signing with a secret
seed needs `@requires(declassify)`. The compiler signs its provenance
record this way, with its seed held as a secret.

```text
List(Secret(UInt(8))) seed = secret_bytes(read_seed());
List(Int) pk = ed25519g_pub(seed);            // needs @requires(declassify)
List(Int) sig = ed25519g_sign(seed, msg);     // msg is public
```

`lib/hpkeg.resid` is HPKE (RFC 9180) written once over all of the above:
the labeled HKDF over HKDF-SHA256/384/512, the three KEMs
(DHKEM(X25519, HKDF-SHA256), and DHKEM(P-256, HKDF-SHA256) and
DHKEM(P-384, HKDF-SHA384) over `ecdhg` and `ec_public_keyg`), the key
schedule in all four modes, the per-message nonces, seal and open over
AES-128/256-GCM and ChaCha20-Poly1305, and the exporter.
`lib/hpke.resid`'s API is the public copy; no suite has a public-only
path. At secret types the private keys
(recipient, sender, ephemeral), the shared secret, the PSK, the key
schedule's secret, key, base_nonce and exporter secret, each nonce and the
plaintext are secret bytes; public keys, `enc`, `info`, `psk_id`, the
associated data, the received ciphertext and the sequence number are
public. The nonce (base_nonce xor the sequence number, a public shift into
secret bytes) reaches the AEADs' `aes_gcmg_seal_ivb` and
`chacha20poly1305g_seal_nb`, which take the IV as bytes `B` so it stays
secret. Sealing returns a secret ciphertext the caller declassifies to
send; opening publishes the tag verdict through `CtSame(B)`, and the KEM
publishes the derived public keys (`X25519Pub(B)`, or the curve's open
verb), the all-zero check and, for the NIST curves, whether a candidate
or peer key is usable, so the secret copies need `@requires(declassify)`.

```text
HpkeKeyPairG(Secret(UInt(8))) r = hpkeg_derive_keypair(32, secret_bytes(read_ikm()));
Option(List(Secret(UInt(8)))) dek = hpkeg_open_with(hpke_suite(32, 1, 1), enc, r.sk, info, aad, ct);
```

```text
List(Secret(UInt(8))) key = secret_bytes(read_key());
List(Secret(UInt(8))) prk = hkdf256g_extract(salt_lifted, key);
List(Secret(UInt(8))) okm = hkdf256g_expand(prk, info_lifted, 32);
```

`lib/tls.resid` is the TLS 1.3 key schedule (RFC 8446 §7.1), Finished
(§4.4.4) and AES-128-GCM record protection (§5.2), written once over the
byte type (`tlsg_*`, on `lib/sha256g.resid`'s HKDF and
`lib/aesgcmg.resid`'s `aes_gcmg_seal_ivb` / `aes_gcmg_decrypt_ivb`); its
`List(Int)` functions (`tls_handshake_secret`, `tls_traffic_key`,
`tls_protect`, ...) are the public copy. The server (`lib/tlsserver.resid`)
and client (`lib/tlsclient.resid`) run the secret copy: the x25519
ephemeral key and shared secret (`lib/x25519g.resid`), the early,
handshake and master secrets, the four traffic secrets, the finished
keys, and the record keys and IVs (`TlsKeys`) are `List(Secret(UInt(8)))`,
and each record's nonce (the IV xor the sequence number) is computed in
secret bytes. The server's signing key (`lib/tlskey.resid`'s `ServerKey`,
Ed25519 or ECDSA P-256/P-384) is secret from the moment its file is read
and signs CertificateVerify with `ed25519g_sign` / `ecdsag_sign_digest`. Transcript hashes, labels, lengths and sequence
numbers are public. What leaves is public by design: the key share, the
signature, and through `TlsPublish(B)` (in `lib/tls.resid`, one
declassification each, with its reason) the record ciphertext, the
plaintext of an authenticated record handed to the application, and the
Finished MAC; a record's tag and the peer's Finished publish one bit
through `CtSame(B)`. So every program that runs a handshake or a record
-- a TLS server (`tls_accept_loop`, `tls_stream_loop`), a client
(`tls_client_connect`, `tls_https_get`), and their spawn lists -- needs
`@requires(declassify)`.

Loading that key (`tls_key_load`, or `tls_key_parse` on a file's bytes)
turns every byte of the file into `Secret(UInt(8))` before reading any of
it, and publishes only the file's framing: which bytes are line breaks,
whitespace, dashes or '=' padding (classified with masks), the PEM armor
lines, and the DER tags, lengths and algorithm OIDs. The base64 body is
decoded in constant time by `base64g_decode` in `lib/crypto.resid`,
generic over `Word(W, B)` like the primitives (`base64_decode` is its
public copy): each character's value comes from range masks, never a
table or a branch, and the one fact published is whether every character
was base64. The scalar or seed stays secret bytes into `ServerKey`, so
loading a key needs `@requires(declassify)`.

```text
List(Secret(UInt(8))) shared = x25519g_shared(priv, client_share);
List(Secret(UInt(8))) hs = tlsg_handshake_secret(shared);
List(Secret(UInt(8))) s_hs = tlsg_s_hs_traffic(hs, transcript_hash);
List(Int) record = tlsg_protect(seq, tlsg_traffic_key(s_hs), tlsg_traffic_iv(s_hs), content, 22);  // ciphertext published
```

With TLS, every key handled by the cryptography library is a secret at
run time: step 2 of the plan's migration is complete.

## Constant-time helpers

- `ct_select(c, a, b)` returns `a` when the secret `c` holds, else `b`,
  computed with masks rather than a branch. `a` and `b` are integers of at
  most 64 bits, or Bools, secret or public; the result is secret.
- `ct_eq(a, b)` in `lib/crypto.resid` compares two `Secret(List(UInt(8)))`
  byte lists in constant time and returns a public `Bool`. Only that one
  bit is published, which is a declassification, so `ct_eq` needs
  `@requires(declassify)`.
- A secret list's, bytes' or text's `.len()` is public.

`tests/ct/run.sh` checks both helpers under valgrind on the optimized
binary: no branch or memory address depends on the secret.

## The valgrind backstop

The type rules are checked again on the compiled binary. `tests/ct/run.sh`
takes its cases from the knowledge graph -- every `ct_case_<name>` function
in `tests/ct/ctprobe.resid` and `tests/ct/secretprobe.resid` -- and runs
each under valgrind with the secret inputs marked undefined. Before that,
`tools/resid-ctcover.resid` reads the graph of a program importing all of
`lib/` and lists every library function that handles a secret: a public
one whose signature names `Secret` (or a type holding one), a public
generic one that runs on secrets once instantiated at a `Secret` type,
and any one that declassifies. The run fails when one of them is reached
by no case at a secret type, so a new library function on secrets cannot
skip the check. The few a case cannot reach, such as the socket loops,
are listed with a reason in `tests/ct/uncovered.txt`.

## Observation behaviors

- A secret, or a value that holds one, cannot be shown through the
  structural `Show` (`E0256`, naming the field path such as
  `KeyPair.priv`).
- `Show`, `Serialize`, `Hash`, `Eq` and `Ord` are never given for a secret
  (`E0257`), whether declared, asked for by a verb, or needed by a generic
  function's copy.
- A type that holds a secret may have its own `Show` instance. Its body is
  checked like any function, so it can only reach the secret through
  `declassify`.

## At run time

`Secret(T)` costs nothing per value: it lowers exactly as `T`. A program
that uses secrets anywhere runs its allocator in secret mode, switched on
before `main`:

- every heap, region, thread-stack and thread-local mapping is left out of
  core dumps (`MADV_DONTDUMP`);
- memory is zeroed when it is freed or handed back for reuse; memory given
  back to the kernel is zero-filled by the kernel.

Registers, the binary's static data and the process's initial stack are
not covered. `main` runs on its own thread stack, which is.

## Not yet enforced

The cryptography library's migration onto the word behaviors is complete
(TLS was the last). `PLAN-secret-type.md` lists the rest of the plan: a
run-time check of the `declassify` grant (`declassify` lowers to nothing,
so the static check is the whole check today).
