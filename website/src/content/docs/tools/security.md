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
- **A binary from elsewhere** that claims to be a Resid build: its
  signature must be checked against a key the verifier already trusts.
- Out of scope: an attacker who can write the build tree, side channels
  beyond the constant-time checks below, and denial of service.

## Guarantees

**Authority.**
- *No ambient authority:* every capability a function uses, directly or
  through calls, closures and behaviors, is granted by its `@requires` or
  its sandbox (`E0219`).
- *Only narrowing:* sandboxes and attenuated imports only narrow authority,
  and manifest ceilings bound dependencies: modes included, down the
  whole dependency tree, and with the narrowest ceiling winning when two
  packages declare the same dependency.
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
- There is no `extern` and no in-process FFI: a program reaches the
  operating system only through providers and builtins.

**Native modules.** Code from another language runs only as a
[native module](/Resid/reference/native-modules/), each call in a fresh
process the kernel confines to computation (a seccomp filter: a write
on its own socket, exit; a shadow stack where the CPU has one). It gets no descriptors, no
environment, no clock and none of the program's memory. Its reply is
checked as untrusted input. The artifact is checked before linking so it
cannot run code in the program itself. Calling it needs the family
`native_<module>`, checked like any other.

**Packages.** Content-hashed archives, Ed25519 signatures, registry index
signatures, pinned keys and keyrings. The package must match the request,
and extraction cannot escape its directory. With
`require_signatures`, the signed index alone no longer admits a package.
A registry reached over HTTP or HTTPS (`[registry] url`, served by
`resid-pkg serve`; HTTPS needs a `ca` trust store, with no default) is
held to exactly the same checks as one on disk: a successful download is
never a reason to trust anything. An upload must be signed by a keyring
key and never replaces a published version.

**Secrets.** A `Secret(T)` value cannot steer a branch, index memory,
be compared or be printed; it leaves only through `declassify`, which is
a capability (spec §48, [Secret values](/Resid/reference/secrets/)).
Library code that handles secrets is checked for constant time on the
optimized, LTO-linked binary: `tests/ct/run.sh` runs each case under
valgrind memcheck with the secret marked undefined, so a branch, select
or memory address that depends on it -- including one LLVM introduced --
fails the run. A negative control must be caught, and a coverage gate
fails when a library function that handles a secret is reached by no
case and not listed, with a reason, in `tests/ct/uncovered.txt`.

**Devices.** A kernel device is reached only through the `device`
provider and a descriptor from `lib/dev/`, which the compiler checks and
records in the provenance record. Each call runs in a fresh device host
confined by seccomp (and Landlock for a configfs report) to the one
operation ([Device access](/Resid/reference/devices/)).

**Attestation.** `Verified(T)` and `Appraised(T)` are built only inside
`lib/verify/`; a `@decides` function succeeds only through a verified,
appraised, fresh gate resting on reviewed anchors (E0280-E0289), and a
program using `lib/verify/` is pinned to the exact library closure and
runtime it was reviewed with (E0290)
([Attestation](/Resid/reference/attestation/)).

**Parsers.** Every parser of untrusted bytes in the standard library --
certificates, CRLs, OCSP, keys, signatures, CBOR/COSE, TLS and SPDM
messages, PEM, HTTP/2 and HPACK, TPM responses, CoRIM and the attestation
verifiers' formats -- is total: malformed input gives an error, never an
abort or a hang. A mutation fuzz runs all of them.

**TLS.** The client authenticates the server against a trust store — a
PEM bundle or a directory of DER certificates — requiring that the leaf
names the connected host, is in date, and chains to a root in the store
through the intermediates the server sent; issuers must be CAs allowed to
sign certificates, and a store's CRLs and OCSP responses are enforced.
With no store it trusts nothing; there is no way to turn the check off.
The server speaks only TLS 1.3 (`TLS_AES_128_GCM_SHA256`, x25519), refuses
to start when its key does not match its certificate, and answers every
refusal with an alert.

**HTTP.** `lib/httpserv.resid` bounds a request's head, body and count
per connection, and refuses request-smuggling shapes
(`Transfer-Encoding` with `Content-Length`, conflicting lengths, obsolete
line folding) rather than resolving them one way.

**Provenance.** Every release binary carries a signed record binding
source, code, sidecars, the builder and `main`'s grant; `residc verify`
checks it, reports what it re-derived apart from what the signer
asserts, and names the keyring the key came from.

**Bootstrap.** The committed seed must reproduce itself byte for byte
through two rebuilds from source.

## Not guaranteed

- Side channels other than secret-dependent control flow and memory
  addresses are out of scope. Constant time is checked with valgrind on
  x86-64 only; AArch64 builds are not checked. Variable-latency
  instructions are not tested (the only divides in the checked binary are
  on public values, found by reading its disassembly). Without valgrind,
  `tests/ct/run.sh` runs only its coverage gate. Coverage is reachability
  in the call graph, not proof that every path ran.
- Certificate signatures verified: ECDSA P-256, P-384 and P-521 (P-521
  verification only), RSA PKCS#1 v1.5 and RSA-PSS (2048 bits and up), and
  Ed25519. SHA-1, DSA and other curves are refused, not accepted on
  another algorithm's terms.
- Revocation evidence comes from the store's CRLs and OCSP responses; no
  stapled OCSP response is read. A store with neither for an issuer has
  no revocation information about that issuer's certificates — ask for
  `revocation_required` to have that treated as a refusal rather than an
  acceptance. A pinned certificate and a trust anchor are not checked for
  revocation.
- The TLS server does not offer session resumption, 0-RTT, client
  certificates or RSA signing; it does not check its key file's
  permissions.
- In a provenance record, toolchain, profile and grant are attestation:
  `verify` cross-checks the grant against the graph artifact only when
  one is signed (debug builds), and the sources only with `--sources`.
- A native module's answers are checked for their type, never their
  meaning; the sandbox is as strong as the kernel's seccomp; and its
  60 s of CPU and its memory are not denial-of-service guarantees.
- Integrity labels are reported, not yet enforced: no rule refuses a
  program because of a label, and the key-unpredictability (E0270) and
  constant-nonce (E0279) rules are warnings during their rollout.
- Denial of service is out of scope: a program can still abort, for
  example when it exhausts its memory budget.
- The runtime and the compiler's in-place updates are tested, not proven.
- A seed that reproduces itself while miscompiling ("trusting trust") is
  not ruled out by the bootstrap alone. An independent interpreter,
  [resid-ddc](https://github.com/larrydewey/resid-ddc), has reproduced
  the seed and runtime IR byte for byte (diverse double-compiling), but
  it lives outside this repository and no suite here reruns it.
