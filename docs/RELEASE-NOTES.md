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
