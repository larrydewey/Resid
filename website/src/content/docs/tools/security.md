---
title: Security model
description: What Resid guarantees, how each guarantee is enforced, and what it does not guarantee.
---

Resid's security claims are kept in a ledger, `SECURITY.md` in the
repository, where every guarantee names the code that enforces it and the
tests that fail if it breaks. This page summarizes it.

## Threat model

- **Untrusted library code** must not gain capabilities the program did
  not grant it, or reach the runtime's memory internals.
- **Untrusted package sources** must deliver exactly what a trusted key
  signed, and the package that was asked for.
- **Untrusted input data** must not cause out-of-bounds memory access.
- Out of scope: an attacker who can write the build tree, side channels,
  and denial of service (malformed input may abort the process).

## Guarantees

**Authority.**
- *No ambient authority:* every capability a function uses, directly or
  through calls, closures and behaviors, is granted by its `@requires` or
  its sandbox (`E0219`).
- *Only narrowing:* sandboxes and attenuated imports only narrow authority,
  and manifest ceilings bound dependencies.
- *Regions:* a `spawn` region gets only its listed capabilities.
- *Checked twice:* every provider call is checked again before it runs,
  against the thread's sandbox frames, and a read-only grant never covers
  a write.

**Internals.** The runtime's memory primitives are not part of the
language. They are accepted only in the compiler's own sources and the
runtime, under a driver flag that is honored only for those entry files
(`E0220`). A test keeps `lib/` and `tools/` free of them.

**Memory safety.**
- Indexing is bounds-checked unless the compiler proves the index in range.
- Arithmetic and conversions are checked unless provably safe.
- String functions never read past the end of a string.
- There is no FFI and no `extern`: a program reaches the operating system
  only through providers and builtins.

**Packages.** Content-hashed archives, Ed25519 signatures, registry index
signatures, pinned keys and keyrings. The package must match the request,
and extraction cannot escape its directory. A registry reached over HTTP
(`[registry] url`, served by `resid-pkg serve`) is held to exactly the
same checks as one on disk: a successful download is never a reason to
trust anything.

**TLS.** The client authenticates the server against a trust store — a
PEM bundle or a directory of DER certificates — requiring that the leaf
names the connected host, is in date, and chains to a root in the store
through the intermediates the server sent. With no store it trusts
nothing; there is no way to turn the check off.

**Provenance.** Every release binary carries a signed record binding
source, code and sidecars; `residc verify` checks it.

**Bootstrap.** The committed seed must reproduce itself byte for byte
through two rebuilds from source.

## Not guaranteed

- TLS chain validation requires intermediates to be CAs, and covers
  ECDSA P-256, RSA PKCS#1 v1.5 and RSA-PSS certificate signatures.
- Revocation is CRL-based. There is no OCSP, and a store with no CRL for
  an issuer has no revocation information about that issuer's
  certificates — ask for `revocation_required` to have that treated as a
  refusal rather than an acceptance.
- Constant-time behavior of compiled code is not verified.
- DER, X.509 and HPACK parsers abort on malformed input instead of
  returning an error.
- The runtime and the compiler's in-place updates are tested, not proven.
- A seed that reproduces itself while miscompiling ("trusting trust") is
  not ruled out; no independent second compiler is maintained.
