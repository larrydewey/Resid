---
title: Signed provenance
description: Every binary carries a signed record binding source, code and sidecars.
---

Every binary Resid produces carries **signed provenance**: a COSE_Sign1
(RFC 9052, EdDSA) over a record that binds, by SHA-256 hash, the source
files, the binary's code and every sidecar (knowledge graph, residual
notes). It is appended to the binary:

```text
[code][COSE_Sign1][cose length: u32 BE]["RESIDPROV2"]
```

The payload records the toolchain, the profile, the sources, the code
hash, the sidecar hashes, the capability set the build ran under and the
output name. A detached copy is written as `<artifact>.resid-prov.cbor`.
The payload may be encrypted (COSE_Encrypt0, ChaCha20-Poly1305) with
deterministic nonces, so builds stay reproducible.

- Release builds require a signing key (`residc keygen`, or
  `RESID_SIGNING_KEY`) and fail without one.
- Debug builds without a key are unsigned; the compiler notes it.
- `residc verify <binary> [--pub HEX]` checks the signature, the code hash
  and the hash of each sidecar present.

## Packages

Package archives hold every `.resid` and `.toml` file sorted by path. A
published package carries an Ed25519 signature over its content hash;
before a package is accepted into a build, its hash is recomputed, its
signature verified against the project keyring or a pinned key, its
manifest checked against the request, its dependency hashes matched, and
its capabilities checked against the manifest policy. See
[resid-pkg](/Resid/tools/fmt-pkg/) and [Security](/Resid/tools/security/).
