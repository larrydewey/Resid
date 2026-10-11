# Resid: notes for the next release (after v0.2.0)

A draft for the release body, from v0.2.0 to the merge of
`ioctl-device-access` into master. Each item's guarantees, with the tests
that check them, are in `SECURITY.md`.

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
  quotes and NV counters, and NVIDIA GPUs over SPDM 1.1. SPDM 1.1 also
  gets sessions, with the requester's key schedule and secured messages
  in `lib/spdm_session.resid`. SNP and TDX evidence can be bound to a GPU
  session, and signed CoRIMs supply reference values and endorsed
  attestation keys. `@anchor`, `@policy` and `@decides` let the compiler
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
- **Cryptography** — P-384, SHA-384, RSA verification, HPKE, COSE, strict
  X.509 parsing fuzzed by mutation, SHA-256/512 on the CPU's SHA
  instructions.

## Tooling

- The language server completes annotations after `@` and the secret
  builtins.
- `tools/resid-devgen` generates device descriptors and checks them
  across pinned kernels.
- `residc verify` lists a binary's anchors, policies and decisions from its
  provenance record.

## Tests

Self-hosted suites: conformance (573), graph (919), attestation (73),
constant time (71 cases), TLS (140), packages (109), provenance (76),
devices (57), runtime (24), reduce (29), labels (13), LSP (20), HTTP (3)
and ledger (27). `./boot.sh` reaches a byte-identical
self-compile fixed point from the committed seed.
