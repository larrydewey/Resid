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

```text
List(Secret(UInt(8))) key = secret_bytes(read_key());
List(Secret(UInt(8))) prk = hkdf256g_extract(salt_lifted, key);
List(Secret(UInt(8))) okm = hkdf256g_expand(prk, info_lifted, 32);
```

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

`PLAN-secret-type.md` lists the rest of the plan: moving the rest of the
cryptography library (AES-GCM, Ed25519, P-256/P-384, HPKE, the
TLS key schedule) onto `Word(T)`.
