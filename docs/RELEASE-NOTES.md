# Resid v0.4.0

From v0.3.0. The standard library is documented in the source, and its API
reference is generated from that documentation.

## Highlights

- **Doc comments on the whole standard library.** Every declaration a
  program can import from `lib/`, `lib/dev/` and `lib/verify/` (2,737: each
  `pub` function, and every `type` and `behavior`, which are visible
  without `pub`) has a `///` comment directly above it and its
  annotations, and each module's header comment is its overview. The
  generators keep their output in the same shape (`tools/gen_nistp.py`,
  `tools/resid-devgen`, `tools/attest/gen_*_anchors.py`).
  `tools/check_doc_comments.py` fails when a declaration has none.
- **A generated API reference.** resid-book reads the source named by
  `api = "../lib"` in `website/book.toml` and serves a page per module
  under `/api/`: the overview, then each type, behavior and function with
  its annotations, its declaration as written, its documentation and a
  link to its line on GitHub, plus an index by module and by capability
  family. The pages are searched and exported like the hand-written ones.

## Fixes

Writing the documentation meant reading every function, which turned up
these:

- **HPACK's dynamic table kept only its newest entry** (`lib/h2.resid`):
  `lst_join_loop` and `h2_scat_acc` recursed on the list they started
  with, so `hp_insert`, `h2_join` and `bv_join` dropped what they
  appended, and a header block naming an older dynamic entry decoded to
  nothing. Static entries 1 and below were taken to carry values, and an
  entry without one decoded with its own name as its value. RFC 7541
  C.3.3 is now in `h2_hpack_in_resid`.
- **An OCSP response was only read for its first answer**
  (`lib/certverify.resid`): the search for a certificate's SingleResponse
  started at the `responses` list rather than inside it, so a certificate
  answered second came back as no answer. `tests/tls` has a two-answer
  response (`ocsp-two.der`).
- **CRLs in PEM were never loaded** (`lib/chain.resid`): the PEM reader
  knew only `CERTIFICATE` blocks, so `trust_store_crls_from_pem_file` and a
  PEM `crls` path added nothing. `X509 CRL` blocks are read now, and
  `tests/tls` revokes through `crl.pem`.
- **POSIX TZ rules were wrong south of the equator, and for `Jn`**
  (`lib/zone.resid`): daylight saving was taken to run from the earlier
  transition to the later, which inverts a rule whose start comes after its
  end (`AEST-10AEDT,M10.1.0,M4.1.0/3`), and `Jn` days were counted from 1
  March instead of 1 January. Five declarations read `pub pub`.
- **DER lengths of 128 and more were encoded one octet short**
  (`der_long_len`, which built `[128]`, the indefinite-length marker, for
  200), and **OIDs with a first arc of 2 and a second of 40 or more** read
  their second arc 40 too high (`der_oid_str`), and could not span octets.
- **HKDF-Expand with SHA-256 accepted lengths past 255 blocks**
  (`hkdf_expand`), whose block counter then no longer fit a byte; it now
  returns nothing, as `hkdf_with` already did.

# Resid v0.3.0

From v0.2.0 to the merge of `attest-complete` into master. Each item's
guarantees, with the tests that check them, are in `SECURITY.md`.

## Highlights

- **Secret values** (`Secret(T)`, spec §48, `PLAN-secret-type.md`): a
  type the checker keeps out of conditions, indices, comparisons and
  provider arguments; `declassify(x, "reason")` under the `declassify`
  capability is the only way out. SHA-2, HMAC/HKDF, AES-GCM,
  ChaCha20-Poly1305, X25519, P-256/P-384, Ed25519, HPKE and the TLS 1.3 key
  schedule and records are one generic implementation each, checked at
  secret types. A secret-mode allocator zeroes pages and leaves no core
  dump. `tests/ct` runs every case under valgrind, and a coverage gate
  fails when a library function on secrets has no case.
- **Device access** (spec §49, `PLAN-device-access.md`): the `device`
  provider reaches kernel devices only through descriptors in `lib/dev/`.
  The compiler checks each descriptor, and each call runs in a fresh,
  seccomp-confined host process. The ioctl descriptors are generated from
  the kernel's uapi headers. Modules: SEV-SNP guest reports, extended
  reports and derived keys, TDX reports, the Nitro Secure Module, the
  configfs TSM report (SNP, TDX, CCA), TPM 2.0 and the PCI TSM.
  Manifests bound a dependency's devices.
- **Integrity labels** (`PLAN-labels.md`, phases 1-3): every value is
  Internal or External; `resid-why --label` explains a label. Keys must
  hold unpredictable bytes (E0270), and an AEAD nonce may not be a
  constant under a reused key (E0279); both are warnings for now. Outside
  data may not reach what a decision decides (E0286).
- **Attestation** (`PLAN-attestation.md`, A1-A4): `lib/verify/` turns
  evidence into `Verified(T)`. It covers SEV-SNP (VCEK and VLEK, AMD
  CRLs), TDX (with Intel's collateral), AWS Nitro, Arm CCA, TPM 2.0
  quotes and NV counters, and SPDM devices. SNP, TDX, Nitro, CCA and TPM
  evidence can be bound to a device's SPDM session.
- **SPDM 1.0-1.3, whole** (DSP0274, DSP0277): verifiers for measurements,
  CHALLENGE and KEY_EXCHANGE at every version, under NVIDIA's Device
  Identity CA or any vendor's device root, with every implemented
  algorithm (ECDSA P-256/P-384/P-521, RSASSA and RSAPSS 2048-4096,
  Ed25519; SHA-256/384/512) and OCSP for every certificate below the
  anchor (NVIDIA's real H100 chain and OCSP answers verify). A whole
  requester (`lib/spdm_requester.resid`): negotiation with the 1.2 opaque
  format and multi-key, certificates, CHALLENGE with basic mutual
  authentication, measurements, sessions with mutual authentication
  (encapsulated or not), PSK, heartbeat, key update, chunking both ways,
  over MCTP, PCI DOE and TCP (`lib/spdm_transport.resid`), interoperating
  with DMTF's spdm-emu in 22 configurations (`tests/spdm/run.sh`).
- **TPM attestation keys by credential activation**: an AK proven to live
  in a TPM a manufacturer certified, by TPM2_ActivateCredential against
  its EK, under the 46 EK roots of Microsoft's TrustedTpm.cab (generated
  anchors), with the EK chain's CRLs required. TPM2_MakeCredential in
  Resid (`lib/tpm_credential.resid`, RSA and ECC EKs) is checked against
  the IBM TPM simulator; the device side runs as one chain of commands on
  one open file (`device.transact_chain`).
- **CoRIM, whole** (draft-ietf-rats-corim): every triple (reference,
  endorsed, identity, attest-key, conditional endorsement and series),
  every measurement value and key type, and the appraisal of §9 over each
  platform's claims; endorsed appraisals for all six platforms, endorsed
  keys for CCA, TPM and SPDM devices. `@anchor`, `@policy` and `@decides` let the compiler
  check every release: whose word the evidence rests on, which policy
  appraised it, that it is fresh, and that the secret is sealed to the
  attested key or channel (E0280-E0294). Other parts: HPKE releases,
  sealing to the measurement with rollback protection, EAR results, a
  device transcript, and a pinned verify closure (E0290).
- **AArch64** — `--target aarch64` cross-compiles to AArch64 Linux and
  Android, with hardware AES, GHASH and SHA.
- **Compile-time reduction** — a separate evaluator for known calls (3-7x
  faster), work-counting budgets, closures, builders, sum types and
  integers to 2^1023 at compile time.
- **Native modules** (`@link`, spec §47) run confined per call, and the
  `display` capability adds a Unix window-server transport.
- **Cryptography** — P-384, SHA-384, RSA verification and RSAES-OAEP
  encryption, P-521 ECDSA verification (Wycheproof), HPKE, COSE (ES512
  too), strict X.509 parsing fuzzed by mutation, SHA-256/512 on the CPU's
  SHA instructions. OCSP responses past their nextUpdate are now refused.
- **PCI devices**: a PCI function's sysfs attributes (identity, DOE
  features, TSM connection) by a typed address, `device.read_pci_attr`.

## Fixes

- The CBOR readers (`lib/cose.resid`, `lib/cosesig.resid`) no longer
  overflow on a length or count near 2^63 (found by the new fuzz cases).
- `ocsp_sr_next_update` never found a SingleResponse's nextUpdate, so an
  OCSP answer past it was accepted (TLS and device chains); it reads the
  [0] after thisUpdate now.

## Tooling

- The language server completes annotations after `@` and the secret
  builtins.
- `tools/resid-devgen` generates device descriptors and checks them
  across pinned kernels.
- `residc verify` lists a binary's anchors, policies and decisions from its
  provenance record.

## Tests

Self-hosted suites: conformance (573), graph (924), attestation (78),
constant time (72 cases), TLS (140), cryptography (13,843 checks),
packages (109), provenance (76), devices (61, with the IBM TPM
simulator), SPDM interoperability (22, with DMTF's spdm-emu), runtime
(24), reduce (29), device generator (18), labels (13), LSP (20), HTTP (3)
and ledger (27). `./boot.sh` reaches a byte-identical self-compile fixed
point from the committed seed.
