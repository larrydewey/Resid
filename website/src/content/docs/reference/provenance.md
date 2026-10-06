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
hash, the sidecar hashes, the hash of the compiler that built it, the
grant (`main`'s declared `@requires`, which is the whole program's
authority), the SHA-256 of each linked
[native module](/Resid/reference/native-modules/) artifact, and the output
name. A detached copy is written as
`<artifact>.resid-prov.cbor`.
The payload may be encrypted (COSE_Encrypt0, ChaCha20-Poly1305) with
deterministic nonces, so builds stay reproducible.

- Release builds require a signing key (`residc keygen`, or
  `RESID_SIGNING_KEY`) and fail without one.
- Debug builds without a key are unsigned; the compiler notes it.
- `residc verify <binary> [--pub HEX] [--anchored] [--sources DIR]` checks
  the signature, the code hash and the hash of each sidecar present, then
  reports the record in two parts.

## Evidence and attestation

A valid signature says that the signer wrote the record. It does not say
the record is true. `verify` therefore keeps apart what it re-derived
itself and what it is taking the signer's word for:

```text
trust: anchored (the install's keyring, $RESID_HOME/keys; kid e815aaa1920ec0ba)
evidence: code hash matches (c2b6…)
evidence: app.resid-notes.cbor matches its signed hash
evidence: app.resid-graph.cbor matches its signed hash
evidence: app.resid-prov.cbor equals the trailer
evidence: built by this residc (compiler a8cf…)
evidence: the graph's sources are the record's, and its capabilities are within the grant
attestation: 3 source file(s), hashes signed but not re-derived (--sources DIR checks a tree)
attestation: toolchain resid-stage2 3.5, profile debug, output app
attestation: grant [filesystem(readonly), network]
verify: ok (kid e815aaa1920ec0ba, code c2b6…, trust anchored)
```

- **Evidence** is recomputed here: the code hash, each sidecar's hash,
  the detached copy (byte-equal to the trailer), whether the `residc`
  running `verify` is the compiler recorded, and, when the graph artifact
  is signed (debug builds), that its sources are the record's and that
  every capability its nodes use lies within the grant. A record that
  lies about the grant fails even under a valid signature.
- **Attestation** is what only the signer says: toolchain, profile,
  output name, grant. The source hashes are attestation too, unless
  `--sources DIR` names a tree to hash them against; then a changed or
  missing file is a failure and the sources become evidence.

## Trust modes

The first line names where the key that verified the signature came from:

| Mode | Source | Meaning |
|---|---|---|
| `anchored` | `$RESID_HOME/keys/*.pub` | the install's keyring |
| `supplied` | `--pub HEX`, `RESID_VERIFY_PUB` | a key given for this run |
| `local` | `keys/*.pub` in the current directory | not an anchor: whoever wrote the directory could have put the key there |

`--anchored` refuses anything but the install's keyring, for scripts that
must not be talked into trusting a key shipped beside the binary. A key
present both in the install and in the current directory is reported as
anchored.

## Packages

Package archives hold every `.resid`, `.toml` and `.ll` file sorted by path. A
published package carries an Ed25519 signature over its content hash;
before a package is accepted into a build, its hash is recomputed, its
signature verified against the project keyring or a pinned key, its
manifest checked against the request, its dependency hashes matched, and
its capabilities checked against the manifest policy. See
[resid-pkg](/Resid/tools/fmt-pkg/) and [Security](/Resid/tools/security/).
