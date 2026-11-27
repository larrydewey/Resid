# Plan: cryptography for the security-first datastore

**Status: D1-D4 IMPLEMENTED (2026-11-27)**, on branch
`claude/datastore-crypto` (PR #8, coordination in issue #7). Where the code
differs from the plan below:

- **D1:** following signed-note, a signature line from an unknown key is
  ignored, not refused. The API is `note_sign`, `note_parse`,
  `note_verified`, `ckpt_open`, `ckpt_cosigned` and `cosig_line`.
- **D3:** scalar functions are named `r255_sc_*` (`sc_*` collided with
  `lib/p256ops.resid`). `pc_commit_vec` takes its values as concatenated
  32-byte encodings, because a wide secret may not sit in a list (E0258).
  The vectors come from libsodium (`gen_ristretto.py`) rather than
  RFC 9496's appendix, which could not be fetched here. libsodium 1.0.18
  accepts encodings with bit 255 set, which RFC 9496 refuses and
  `r255_decode` refuses too.
- **D4:** one implementation generic over `MdCoef(C, B)` covers both the
  public verifier and the secret signer. The rejection-verdict reveals
  and SampleInBall's masked writes are as SECURITY.md describes. The ACVP
  subset is the 4 shortest-message tests of each group (1.9 MB), plus
  OpenSSL interop. HashML-DSA is not implemented.
- **Red-team round 1 (issue #9)** found no forged proof, note or
  signature; one medium and five low findings are fixed, each with a
  regression (`tests/crypto/*_redteam_test.resid`, `merkle_strprobe.resid`):
  - `pc_open` refuses an opening outside [0, l) (scalar multiplication
    reads bits 0..255 only); `pc_open_bytes` takes canonical encodings.
  - A note must be exact UTF-8: `note_parse` and `ckpt_parse` refuse a
    `Str` whose stored bytes are not the encoding of its code points
    (overlong forms), and `note_parse_bytes`, `ckpt_open_bytes` and
    `ckpt_cosigned_bytes` take the bytes as received.
  - A key name holds no Unicode white space or control character.
  - `r255probe` requires an invalid encoding to be refused, and the
    vectors now include RFC 9496 Appendix A.2's invalid encodings.
  - Signing reveals one bit of a rejected try's hint count, not the count.
  - ML-DSA refuses a message, context, mu or hint that is not bytes.
  - `tests/crypto/fuzz.resid` has mutation kinds for notes, ristretto255
    encodings and ML-DSA keys, signatures and hints.
- The ct coverage gate reports 17 `lib/dev/device*.resid` functions on
  master as well as on this branch. They predate this work; every
  function added here is covered.

## Why

The successor to BurrowDB is designed as an owner-first fact store. Its
source of truth is an append-only log of signed facts, and tables are views
over that log. Columns are `SEALED` (unreadable by the engine) unless the
schema opts into leaking `EQUALITY`, `ORDER` or `CLEAR`. Writers prove
constraints in zero knowledge, query results carry proofs against the log
root, and aggregates over sealed data run across independent operators
(MPC). The design deliberately does not depend on TEEs.

Most of what that needs is already in `lib/`: SHA-2/SHA-3, HMAC/HKDF,
Ed25519, ECDSA, the AEADs, HPKE, ML-KEM-768, Shamir and the CGGMP stack.
This plan adds the pieces that are missing, in the order the datastore
needs them. Each piece is a new module and replaces nothing. No compiler,
runtime or seed changes are planned.

## D1 — Merkle transparency log (`lib/merkle.resid`)

RFC 9162 §2.1, the Certificate Transparency v2 tree, with SHA-256 by
default and the hash a `HashAlg` parameter:

- `mt_leaf_hash(data)` = H(0x00 ‖ data); `mt_node_hash(l, r)` = H(0x01 ‖ l ‖ r).
- `mt_root(leaves)`: MTH over a list of leaf hashes. The split is the
  largest power of two below n, never a padded tree.
- `mt_inclusion_proof(leaves, m)` and `mt_verify_inclusion(alg, index,
  size, leaf_hash, proof, root)`. Verification uses RFC 9162 §2.1.3.2's
  iterative algorithm, so it runs in O(log n) and never rebuilds the tree.
- `mt_consistency_proof(leaves, m)` and `mt_verify_consistency(alg, m, n,
  proof, root_m, root_n)` (§2.1.4.2).
- **Checkpoints:** the C2SP signed-note checkpoint body (`origin\nsize\n
  base64(root)\n`) with Ed25519 note signatures (key ID =
  SHA-256(name ‖ 0x0A ‖ 0x01 ‖ pubkey)[0..4]). `note_sign`, and
  `ckpt_open`, which checks a note against the log's key. As signed-note
  requires, lines from unknown keys are ignored, while a known key that
  fails or signs twice rejects the note. `ckpt_cosigned(note, log,
  witnesses, k, now)`
  requires k distinct witness signatures. Witness cosignatures follow
  C2SP tlog-cosignature (cosignature/v1, timestamped).
- Everything is public data: no `Secret` types and no ct cases. The parsers
  (note text, base64, proof lists) are total, and every length in a proof
  is checked against `size` before indexing.

**Tests:** RFC 9162 has no vectors, so they come from an independent
implementation: `tests/crypto/merkle_ref/` (Go, golang.org/x/mod's
`sumdb/tlog` and `sumdb/note`) writes `vectors_merkle/merkle.txt`, covering
every tree size up to 70 and indices and sizes across each tree. Negative cases: a flipped bit in each proof element, wrong
index, wrong size, a proof one element short or long, m = 0, m > n, and
checkpoints with a bad signature, an unknown key, a duplicate signer,
trailing text or a non-canonical size.

## D2 — SHA-512 allocation (`lib/crypto.resid`)

PROGRESS.md says `sha512_blocks` allocated ~1 MB per block and was
"unverified since 2026-09-25". Measured again on 2026-11-27 (x86-64,
software rounds, this checkout): SHA-512 of 14.5 KB, then Ed25519
sign and verify over it, peaks at 13 MB RSS. SHA-512 of 1 MB peaks at
16 MB, which is mostly the input as a `List(Int)`, and runs in 14 ms.
Every digest matches hashlib. **The leak is gone.** The fix is to record
the measurement, close the PROGRESS item, and add a bounded-memory
regression test (`tests/runtime/mem/sha512_bound.resid`: 1 MB input
under `RESID_MEM_LIMIT=64`). No library change is needed.

## D3 — ristretto255 and Pedersen commitments (`lib/ristretto255g.resid`)

RFC 9496 over the existing Edwards25519 arithmetic in
`lib/ed25519g.resid`, generic over `Wide512(P, B)` so the secret copy is
checked like Ed25519's:

- `r255_decode` (canonical, non-negative s, refuses non-square and
  negative t·x or y = 0), `r255_encode`, `r255_eq` (the RFC's x1·y2 ==
  y1·x2 ∨ y1·y2 == x1·x2), `r255_from_uniform` (64-byte one-way map,
  Elligator 2 twice), and `r255_add`, `r255_sub`, `r255_neg`, `r255_mul`
  (the existing masked ladder) and `r255_base_mul`.
- Scalars mod ℓ: `sc_reduce64` (wide reduction via `eg_digest_mod_l`),
  `sc_add/sub/mul/neg/inv`, and canonical 32-byte decoding that refuses
  any value ≥ ℓ.
- **Pedersen:** generators G (the base point) and H =
  `r255_from_uniform(SHA-512("resid/pedersen/H/v1"))`, a hash-to-group so
  nobody knows log_G H. `pc_commit(v, r)` = vG + rH, `pc_add`, `pc_open`,
  plus vector commitments `pc_commit_vec(vs, r)` with generators
  G_i = from_uniform(SHA-512("resid/pedersen/G/v1" ‖ le32(i))).
  Bulletproofs (range proofs) and membership proofs build on this in a
  later plan; they are out of scope here.
- **Secret handling:** v and r are secret at secret types. Commitments and
  encodings leave through `Publish(B)` (`@requires(declassify)`). No table
  lookups are indexed by secrets: the scalar multiplication is the
  existing double-and-always-add ladder. ct cases go in
  `tests/ct/secretprobe.resid`: `r255-secret-mul`, `pc-secret-commit`.

**Tests:** RFC 9496 §A.1 (multiples of the generator), §A.2 (the bad
encodings, which must all be refused) and §A.3 (from_uniform), at both
types. Group laws on random points, checked against Python `ristretto`
arithmetic written from the RFC in `tests/crypto/gen_ristretto.py` (no
third-party package). Pedersen homomorphism and binding sanity checks.

## D4 — ML-DSA (`lib/mldsa.resid`)

FIPS 204 ML-DSA-44, -65 and -87 (one implementation parameterised by
(k, l, η, τ, β, γ1, γ2, ω, λ)), over `lib/keccakg.resid`'s SHAKE128/256,
written like `lib/mlkem.resid`:

- `mldsa_keygen(ξ)`, `mldsa_sign(sk, M, ctx, rnd)` (the hedged variant,
  with `rnd` from the caller; the deterministic variant when rnd is all
  zeros), `mldsa_verify(pk, M, ctx, σ)` (pure ML-DSA, ctx ≤ 255 bytes),
  and the internal `_internal` forms for ACVP.
- Arithmetic follows the reference implementation: Montgomery reduction
  mod q = 8380417, NTT/inverse NTT, Power2Round, Decompose, MakeHint and
  UseHint, and the packing functions of FIPS 204 §7.
- **Secrets:** s1, s2, t0, K and the per-signature y are
  `Secret(Int(32))`. The rejection loop's verdict is a declassified bit
  each round: FIPS 204 allows it, and the number of rounds is public by
  design. The signature and public key leave through `ct_public`.
  `SampleInBall` and `RejBoundedPoly` run on public or seed-derived
  public data as specified. ct case `mldsa-secret-sign` keeps the signer
  under valgrind.
- Decoding is total: a public key or signature of the wrong length, a
  hint with more than ω ones or out-of-order indices, and z outside its
  bound are all refused.

**Tests:** NIST ACVP ML-DSA vectors (keyGen, sigGen deterministic and
hedged, sigVer, including the negative sigVer cases), converted by
`tests/crypto/gen_mldsa.py` and committed. Interoperability with OpenSSL
3.5 via pyca/cryptography where available. Wycheproof ML-DSA where it
covers the parameter set.

## Order and gates

D2 (records only), then D1, D3, D4. Each piece lands with its doc
comments (`tools/check_doc_comments.py`), `SECURITY.md` rows
("Cryptography library"), `website/book.toml` API entries, its
`tests/crypto/run.sh` section, and `tests/ct` cases for anything on
secrets (the coverage gate). `compiler/verify_pins.resid` only changes if
a module joins `lib/verify/`'s closure, which none of these do yet.

## Not in this plan

Bulletproofs and set-membership proofs, deterministic AEAD (AES-GCM-SIV)
for EQUALITY columns, SPDZ-style MPC arithmetic, and order-revealing
encryption. Those are datastore plans that build on D1 and D3.
