# Labels, Formats and Contracts — Implementation Plan (revision 2)

**Status: DRAFT for review (2026-10-10).** Nothing here is implemented.
Revision 2 folds in three adversarial reviews of revision 1
(information flow, attestation protocol, runtime boundary); §17 maps each
finding to the section that closes it. Depends on PLAN-secret-type.md
(done). PLAN-device-access.md revision 2 builds on this plan.

**Goal**: one model for every place data enters or leaves a Resid program
(kernel devices, foreign code, files, the network, the clock, randomness)
in which the compiler, not the author's discipline, enforces what may be
observed, what has been checked, what was appraised, and what may be used
only once. A platform implementation is written once against a contract
and cannot skip secrecy, verification, appraisal or freshness, and there
is no `unsafe` escape.

**What "guaranteed" means here.** As in `SECURITY.md`: every claim names
the code that enforces it and the test that fails if it breaks. Where the
design cannot guarantee something, it says so and why (§16).

---

## 0. Design in one paragraph

Nothing outside the program is trusted, the kernel included; a program
can only verify outcomes. Every value carries, beside its knowledge state,
three labels: **confidentiality** (public or `Secret`), **integrity**
(`Internal`, `Verified(A)`, `Appraised(P)` or `External`) and **usage**
(unrestricted or `Linear`). The program counter carries a label too, and
every function has a **begin label** that callers must meet, so no
wrapper, closure or callee can hide where a decision or a disclosure
happens. Every information-acquiring effect yields `External`. Integrity
rises only through **primitives** in `lib/verify/` that start from
**anchors** compiled into the binary; signed fields that the requester or
host chose stay `External`; **appraisal** primitives turn verified
evidence into claims a policy accepts. Bytes cross the boundary only
through **channels**, are interpreted only by **formats** (generated,
total, constant-time over secrets), and each crossing consumes a
**ticket** and yields a **receipt** whose nonce a hardware or remote root
signs. `Fresh` needs a relying party's nonce or a certified counter.
Contracts on functions and behavior verbs hold every implementation of a
behavior to the same rules.

## 1. Trust boundary

### 1.1 Internal and External

**Internal** is the program's own code and its `Known` values: they are in
the binary, which the build measures and signs (provenance).

**External** is everything else, with no exceptions: the kernel, devices,
firmware answers, foreign code, files, the network, the clock, every
randomness source the kernel mediates, CPU feature reports (CPUID and ID
registers can be trapped and answered by the kernel or hypervisor), the
environment, arguments, standard input, the terminal, the display, other
processes.

### 1.2 What hardware evidence can and cannot vouch for

A hardware report (SNP, TDX, CCA, NSM) or TPM quote vouches for the
**attesting principal**: the launched image as measured (firmware, kernel,
initrd and command line), at a privilege level, and for whatever that
principal placed in the report's caller-chosen fields. The guest kernel
requests reports and derives keys, and can read and write process memory.
Therefore:

- Claims about a user-space Resid program are exactly as good as the
  measured kernel that ran it. This is stated in every type that rests on
  it: platform anchors name their attesting principal (§5.1), so a
  `@decides` that accepts evidence from an in-guest principal says, in its
  signature, that it relies on the measured guest kernel.
- The Resid binary must itself be inside the launch measurement (a
  unified kernel image or measured initrd, or a measured dm-verity root
  named on the measured command line). A platform profile that cannot
  show this cannot produce `Appraised` claims about the program.
- **Profiles.** `in-guest` (default): the attesting principal is the
  measured guest image. `above-kernel` (later phase): the attesting code
  runs at a higher privilege than the guest kernel (SNP SVSM at VMPL0, or
  a paravisor), so the guest kernel is outside what the evidence covers.

**Decision needed (open question 1):** this plan drafts option 3 from the
review: state the boundary precisely now (`in-guest`), add `above-kernel`
later.

### 1.3 Attacker

The attacker may: choose every External input, its timing and order; see
everything sent through a channel and the number, sizes and timing of
calls; replay, reorder, drop, delay, substitute or relay any answer; roll
back stored state; set the clock; hide CPU features; exhaust shared
hardware randomness; refuse service or kill the program.

### 1.4 Out of scope, stated

- Availability: an attack may stop the program; it must never produce an
  acceptance.
- A running kernel's access to process memory (§1.2). Wiping (§9.4) is
  hygiene against later observers, not a guarantee against the kernel.
- Side channels below the instruction level.
- Bugs in the compiler, runtime and `lib/verify/` (the reviewed base,
  §13).

### 1.5 Prerequisites

Checked arithmetic must hold: the silent wrap of literal arithmetic
(`9223372036854775807 + 1` printing `MIN`) and of `rt` literals is fixed
first. Secret-mode processes must not dump core (fixed separately, before
this plan: `PR_SET_DUMPABLE` 0, `RLIMIT_CORE` 0, abort by `exit_group`).

## 2. The four dimensions

| Dimension | Question | Scale | Moves only through |
|---|---|---|---|
| Knowledge (spec §3.2) | When is it known? | `KNOWN` · `EFFECT` · `RESIDUAL` · `INVALID` | reduction |
| Confidentiality | Who may observe it? | public ⊑ `Secret` | `declassify` |
| Integrity | Who vouched for it? | `Internal` ⊒ `Appraised(P)` ⊒ `Verified(A)` ⊒ `External` | primitives (§5), appraisal (§6) |
| Usage | How often may it be used? | unrestricted · `Linear` | consumption (§8) |

**Integrity is a set, not a point.** `Verified` carries a set of anchors
and a set of evidence identities (§5.5); `Appraised` carries a policy
identity. An integrity label also carries **qualifiers**, which are part
of the integrity dimension, not dimensions of their own:

| Qualifier | Values | Produced by |
|---|---|---|
| `time_source` | `RelyingParty`, `SignedEvidence`, `Kernel` | time arguments (§5.4) |
| `principal` | `InGuest`, `AboveKernel` | anchors and the platform key primitive (§1.2, §5.2) |
| freshness | `Fresh(purpose)` (Linear), `Delivered`, none | `bind` (§8.3) |
| identity | `Local`, `ChannelBound`, none | `aead_open` under a platform key, `bind_channel` (§8.5) |

Joins take unions of sets and the weakest qualifier (no freshness and no
identity are the weakest).

**Relation to knowledge states.**

- An **information-acquiring** effect (a provider verb, a channel, a
  `foreign` call, a source builtin, §3.1) yields `External`. Effects that
  are markers in the graph (`declassify`, `assume`) keep the labels this
  plan gives them.
- A `KNOWN` value is `Internal` only if no External node's facts were
  used to reach it. Reduction records the nodes whose facts it discharged
  (spec §3.4); a derive edge carries their labels to the result
  (`if (v != 7) return; known(v)` is External).
- Labels are part of the hash-consing key and of the content hash, so two
  pure nodes with different labels are never shared.
- An `INVALID` node rejects the program; run-time failure is an error
  value (§10).

**Labels are not facts.** Facts may be dropped; labels never are.

**Canonical form.** Labels normalize to one set per type; `T` may not
itself be a label (E-label-nest).

## 3. Label checking

### 3.1 Sources: a total table

Every builtin and runtime entry has a label entry in one table; the build
fails if one is missing, whatever its arguments (E-label-unknown). An
entry not yet specified defaults to an `External` result. The families,
all `External`:

`args`, `environment`, `filesystem`, `network` (including raw TCP
builtins), `clock`, `terminal`, `display` (events), `process`, `git`,
standard input, randomness (`random_bytes`, kernel sources), `device`
(revision 1 verbs and revision 2 channels), `native_<m>` (`@link` calls),
`foreign`, CPU feature queries (`resid_cpu_has_*`, `resid_raw_cpuid_ab`),
and the `resid-debug` ptrace builtins.

**CPU feature dispatch** is declared *selection-equivalent*: choosing the
AES-NI or software path on a CPUID answer does not raise the program
counter label, because both paths compute the same function and a lie
only causes `SIGILL` (availability). Each such site is listed in the
reviewed base. `rt x` keeps `x`'s label.

### 3.2 Values

- An expression's label is the join of its operands' labels and the
  program counter label (§3.3) at a merge.
- **Containers** carry their elements' labels; retrieving never raises a
  label. A map with External keys is External, and iterating it runs
  under its label.
- **Casts never raise integrity or drop `Secret`, `Linear`, `Fresh` or
  anchors** (E-label-cast). Record literals and `using =` are checked by
  subsumption.
- **Spawn.** A `spawn` result is the join of everything the region read,
  and the tag of every spawn `Result` (`Ok` or `Err(RegionError)`) is
  External, because failure can be caused from outside (memory pressure,
  kills, host death).
- **Round trips stay External**: files and sockets are providers.

### 3.3 The program counter label

The program counter label (pc) is a full label: integrity with its anchor
and evidence sets, and `Fresh`.

- A branch (`if`, `match`, loop test, `&&`, `||`, ternary) raises the pc
  inside it by the condition's label.
- **Termination-insensitive exits.** After `?`, an early `return` or
  `break` whose condition is External, the continuation is *not* raised;
  instead the function's result label is the join, over every exit, of
  the returned value and the pc at that exit. Effects inside a branch see
  the branch's pc. This matches §1.3: an attacker who can stop the
  program learns nothing new from it stopping.
- **Calls.** Every function has a **begin label**: the meet of the pc
  requirements of every `@decides`, `declassify`, channel call with a
  Secret input, and other sink it reaches, transitively, including
  behavior instances chosen per copy. A call requires
  `pc_caller ⊔ label(callee) ⊑ begin_label(callee)` (E-pc). A closure's
  type carries its begin label; calling a value labelled L runs its body
  under `pc ⊔ L`; a `spawn` body runs under the parent's pc at the spawn.
- **Primitives join the caller's pc into their output.**

### 3.4 Label polymorphism

An unlabelled type in a signature is a fresh **label variable**. Each
function gets a flow summary: which parameters reach its result, by data
or by pc, and its begin label. An explicit label is a bound checked by
subsumption at every binding, field, argument, return, cast, `using =`
and instance signature. Generic copies are keyed on the full labelled
type, or checked through summaries, never once with the first caller's
labels. Existing programs compile unchanged: every unlabelled signature
becomes polymorphic, and only declared sinks (§7) can fail.

### 3.5 After reduction

Reduction may specialize, trampoline and memoize. Labels and linearity
are checked on the source graph and **checked again on the residual
graph** before lowering, as E0261–E0264 already are (E-label-residual).

### 3.6 `assume`

`assume` is a capability family (spawn lists, sandbox ceilings, manifest
bounds, and a force-time check, as `declassify`). `assume(x, Why)` names a
declared assumption symbol, not a string:

```resid
@assumption(reason = "the deployment pins this host's TPM by EK name")
Assumption pinned_tpm();
...
Verified(Key, Assumed(pinned_tpm)) k = assume(ek_pub, pinned_tpm);
```

The anchor is `Assumed(package, symbol)`, so a dependency cannot mint an
assumption an application sink accepts. `assume` is refused in the
standard library (E-assume-lib) and listed by `residc verify`.

## 4. Confidentiality: changes to `Secret`

`Secret(T)` (spec §48) is unchanged except:

1. **Into a channel is a declassification.** A Secret passed to a channel
   or foreign binding is disclosed to the other side. The binding declares
   the parameter Secret and the call site names a reason (graph effect
   `declassify.<reason>` with the site). Otherwise refused (E0255, which
   already refuses a Secret provider argument).
2. **Robust declassification.** A `declassify` is robust only if
   `pc ⊔ integrity(value)` is `Internal`, `Appraised`, or `Verified` with
   a non-assumed anchor (Myers, Sabelfeld, Zdancewic). A non-robust
   `declassify` is refused (E-robust), except at sites in a reviewed
   allowlist in the standard library (the TLS record and handshake
   publication sites, whose inputs are the External transcript by
   protocol design), each listed by `residc verify`. Robustness is judged
   at the outermost call site through begin labels (§3.3), not inside the
   wrapper that holds the `declassify`.
3. **Keys, seeds and nonces need integrity (E-ext-key).** The key, seed,
   nonce or randomness parameter of a seal, encrypt, sign, MAC, KDF-expand
   or key-generation primitive must be `Internal`, `Verified` or
   `Appraised`. A value the attacker supplied is not secret from the
   attacker, whatever its confidentiality label: a derived key from the
   kernel, `GetRandom` from a TPM through the kernel, kernel randomness.
   External entropy enters only through `mix_entropy(ext, cpu_seed)`,
   which is `Internal` only when a CPU-sourced seed read without the
   kernel (`RDSEED`, `RNDR`; §8.4) is mixed in; otherwise the result stays
   External and cannot key anything.
4. **One-bit errors on secret data**, as `CtSame` already does.
5. **Format fields that are Secret** take no `ensures`, `requires` or
   fixed value (E-format-secret-check); comparisons over signed regions
   that contain Secret bytes use `ct_eq` and publish one bit, recorded.
6. **Wiping on every exit path** (§9.4).

## 5. Integrity: `Verified`

### 5.1 Anchors

An anchor is a `Known` value from a nullary `@anchor` function with its
origin, checked by resolved path and fingerprint (E-anchor-origin,
E-anchor-known):

```resid
@anchor(kind = AmdVcek(Genoa), principal = InGuest,
        source = "https://kdsintf.amd.com/vcek/v1/Genoa/cert_chain",
        fingerprint = "sha384:…", retrieved = "2026-10-01", reviewed_by = "…",
        algorithms = { root: RsaPss4096Sha384, leaf: EcdsaP384Sha384 },
        expires = "2045-01-01")
Anchor amd_ark_genoa() { return anchor_der(…); }
```

- **Kinds** separate meanings that share a root: `AmdVcek(product)` (chip
  bound) versus `AmdVlek(product, csp_id)` (fleet wide); Intel PCK; NVIDIA
  device; Nitro; TPM EK manufacturer; endorsed key lists (CoRIM
  attest-key triples, as Arm CCA platform keys often are).
- **Algorithms per path level**: the AMD ARK and ASK sign with RSASSA-PSS
  SHA-384 (RSA-4096); only the VCEK is P-384.
- **Rotation and revocation.** Anchors are rebuild-only in revision 2. A
  rebuild changes the launch measurement and so loses measurement-bound
  sealed data; the update path for sealed data is §8.6.

### 5.2 Primitives: the only constructors

`Verified` is produced only by functions annotated `@primitive` in
`lib/verify/` (E-primitive-outside, by resolved stdlib path; provenance
records the hash of every `lib/verify/` file and `residc verify` flags a
mismatch with the release set). Generated canonical parsers (§9) are
named in the reviewed base as compiler-generated primitives. Instances
of behaviors reached from `lib/verify/` and stdlib `@decides` code are
pinned to the standard library's (E-verify-instance), so an application
cannot redefine `Eq(Measurement)`.

| Primitive | Takes | Gives |
|---|---|---|
| `anchor_key(a)` | a `Known` anchor | `Verified(Key, {a})` |
| `verify_chain(root, certs, crls, time)` | `Verified(Key)`, External certificates and CRLs, a time with its source | `Verified(LeafCert, A)`: parsed, verified extensions; validity, key usage, path length, revocation and CRL number checked |
| `verify_sig(key, span, sig)` | `Verified(Key)`, External raw byte span | `Verified(Span(F), A)` for a declared format `F` |
| `verify_mac(key, span, tag)` | key | `Verified(Span(F), Mac(binding))`, where `binding` is the key's compile-time binding identity, never a function of its value |
| `aead_open(key, nonce, ct, aad)` | key | `Verified(pt, Aead(anchor of key))` if the key is `Verified(A)`; `Aead(Self)` if `Internal`; **External** if the key is External |
| `verify_digest(expected, span)` | `Known` or `Verified` digest | `Verified(Span(F), A)` |
| `bind(evidence, receipt, rp)` | `Verified` evidence, a `Linear` receipt, the relying party's nonce | `Fresh(purpose)` on the evidence (§8.3) |
| `platform_key(k, selector, report)` | a device-derived key (`External(Secret(Key))`), its typed selector, and this program's `Appraised` report from the same platform | `Verified(Secret(Key), PlatformDerived(P, selector, principal))`: the platform's derivation is accepted as the attesting principal's, so the anchor names the principal (`InGuest` in the default profile) and a `@decides` must list it to rely on it. The key is otherwise External, and E-ext-key and `aead_open` treat it as such |
| `bind_key(outer, key)` | evidence whose signed span carries `H(key)` | `Verified(Key, outer's anchors, outer's identity)` (Azure HCL, SVSM, CCA realm-to-platform) |
| `verify_signed_transcript(key, transcript, sig)` | SPDM-style signature over a request/response transcript | `Verified(Span)` with the requester nonce bound |
| `bind_channel(evidence, exporter)` | evidence whose signed span carries `H(rp_nonce ‖ tls_exporter)` (RFC 9266) or an attested key | `ChannelBound` on the evidence |
| `replay_log(digest, log)` | a `Verified` PCR, RTMR or REM digest, an External event log | per-event `Verified` only where the event digest equals the hash of its data; other event data stays External |
| `cose_verify(key, msg)` | COSE_Sign1 | algorithm pinned from the protected header to the anchor's list |
| `tcb_ge(v, floor)` | a `Verified` TCB vector, a `Known` floor | a platform-ordered comparison (SNP per-component SPLs with the product's layout; TDX CPUSVN components, PCE SVN and module SVN) |
| `snp_verify`, `tdx_verify_quote`, `nsm_verify`, `cca_verify`, `spdm_verify` | evidence and collateral | `Verified` evidence, tested for parity with go-sev-guest / virtee, Intel DCAP QVL, aws-nitro-enclaves-cose and Veraison |

Every primitive is total over hostile input, constant time over secrets,
refuses algorithms its anchor does not list, and joins the caller's pc.

**Signer-claim binding.** A claim whose meaning depends on the signer is
checked against the signer's certificate inside the platform primitive:
SNP `REPORTED_TCB` against the VCEK TCB extensions, `CHIP_ID` against the
hardware ID extension, `SIGNING_KEY` against the certificate kind; TDX PCK
SGX extensions against the TCB info's FMSPC and PCE ID.

### 5.3 Signed spans, field origin and format identity

- Signatures cover **raw byte spans**. Parsers are **unambiguous**: strict
  DER where DER applies; JSON and CBOR without duplicate keys, indefinite
  lengths or trailing data; canonical-only where the format defines a
  canonical form. XML signature formats are refused in the standard
  library (NVIDIA RIMs go through NRAS's signed token, a separate anchor).
- Every field in a signed region declares its **origin**: `measured`,
  `firmware` (the signer vouches) or `relayed` / `host` (copied from the
  requester or chosen by the host). The default is `relayed`. SNP
  `REPORT_DATA`, `HOST_DATA`, ID block fields and `REPORTED_TCB` (host
  lowerable), TDX `REPORTDATA`, `MRCONFIGID`, `MROWNER`, `MROWNERCONFIG`,
  CCA RPV, NSM `user_data`, `public_key` and `nonce`, TPM `extraData` are
  relayed or host. A relayed or host field parses as External bound to
  the evidence identity, and is useful only through `bind`, `bind_key` or
  `bind_channel`.
- `Verified` bytes carry the identity of the format they were verified
  under; only that format's generated parser yields `Verified` fields.
  Slicing or reparsing yields External with the evidence identity.

### 5.4 Time and collateral

- Platform TSC protection (SNP Secure TSC, TDX) gives a trusted *monotonic*
  clock, not wall-clock time. No platform gives trusted absolute time.
- `time` arguments carry `time_source ∈ {RelyingParty, SignedEvidence,
  Kernel}`: the relying party's signed time, a timestamp inside signed
  evidence (the NSM `timestamp`), or the kernel clock.
- Collateral freshness: `Known` floors compiled in for Intel
  `tcbEvaluationDataNumber`, CRL numbers and AMD KDS CRLs; collateral below
  the floor is refused regardless of time.
- `verify_chain` results carry the time source and CRL freshness; a
  `@decides` may require `time_source != Kernel`.

### 5.5 Joins and identity

`Verified(A) ⊔ Verified(B)` is `Verified(A ∪ B)` with the union of
evidence identities. Composite evidence (quote and collateral, CCA
platform and realm, CPU and GPU) is one **bound evidence set** when its
members are linked by a verified binding (`bind_key`, an SPDM session
signed by the device); otherwise it is several sources.

## 6. Appraisal: `Appraised(P)`

`Verified(A)` means "A signed these bytes". It does not mean the
evidence is acceptable: a debug-policy VM, an old TCB, a migration agent
or VMPL3 are all validly signed. **Appraisal** is the stage between.

`appraise(evidence, reference_values, policy)` primitives in `lib/verify/`
produce `Appraised(T, policy_id)`. Each platform's appraisal has mandatory
checks that no policy can turn off:

- SNP: policy `DEBUG` = 0, `MIGRATE_MA` per policy, the report's `VMPL`
  field, `SIGNATURE_ALGO`, report version in a known set (2, 3, 5 today)
  with CPUID family and model matching the anchor's product, `CHIP_ID`
  not masked when chip binding is required, TCB compared with `tcb_ge` on
  a named field (committed, launch or current; never only the host
  lowerable reported TCB).
- TDX: `TD_ATTRIBUTES.DEBUG` = 0, `SEPT_VE_DISABLE`, TCB status from TCB
  info (`UpToDate` or an explicitly accepted status with advisory IDs),
  QE identity, MRSEAM.
- CCA: platform lifecycle "secured", realm-to-platform binding.
- NSM: PCRs not all zero (debug mode).

Reference values are `Verified(RefValue, Endorser)`: endorsed CoRIM or a
computed set (SNP launch measurements depend on host-chosen vCPU count
and type and on firmware and kernel hashes, so a single digest is not
enough). An appraisal emits an EAR (AR4SI trust vector) when Resid is the
verifier.

## 7. Sinks and contracts

### 7.1 `@decides`

```resid
@decides(require = [AmdVcek(Genoa)], accept = [AmdVcek(Genoa), Nvidia(H100)],
         appraised = snp_release_policy, fresh = "key-release",
         channel_bound, local, time_source != Kernel)
Secret(Key) release(...)
```

- `accept` and `require` are concrete anchor kinds, never type
  parameters. The value's anchor set must be ⊆ `accept`, and must
  contain every anchor in `require` (all-of).
- `appraised = P` requires `Appraised(P)`, not just `Verified`.
- `fresh = "purpose"` requires `Fresh` for that purpose, consumed by this
  decision (a `Fresh` mark is `Linear`, §8.3).
- `channel_bound` requires `bind_channel` (remote release).
- `local` requires `Local` (§8.5).
- Checked over every input, everything the body obtains (channel calls,
  captured closures, callees), every sink pc inside the body, and the
  result. The result label is the join of all of these; a decision never
  raises integrity, so one `@decides` cannot launder another's anchors.

### 7.2 `requires` and `ensures`

A decidable fragment: comparisons, linear integer arithmetic, length
relations, membership in a `Known` set, equality across parameters and
results, and label requirements. Proved statically when possible (they
become facts); otherwise a function's own contract failing at run time is
a bug and aborts, and a format's `ensures` failing is an error value.

### 7.3 Behavior conformance

| In the behavior | The instance must |
|---|---|
| result `External(T)` | return External or higher |
| result `Verified(T, A)` / `Appraised(P)` | return it with anchors ⊆ A / the same policy |
| result `Secret(T)` | return Secret or public |
| result `Linear(T)` | return `Linear`; and an unrestricted result may not be `Linear` |
| parameter `External(T)` | not require more of it |
| parameter `Secret(T)` | take it as Secret |
| parameter `Linear(T)` | take it as Linear and consume it on every path |
| `requires` | be implied *by* the behavior's (contravariant) |
| `ensures` | imply the behavior's (covariant) |
| `Fresh`, anchor sets, `single_source` | be at least as strict |
| `@decides` | have `accept` ⊆ the behavior's and begin label ⊒ |

Behaviors themselves are declared by the libraries that use them: the device
behaviors (`ReportSource`, `SealingKey`, `Counter`) in PLAN-device-access.md
R2.5, the attestation roles in the private attestation library. This plan
defines only the conformance rules they are held to.

## 8. Usage, freshness and identity

### 8.1 `Linear`

Adopts the builder rules of spec §45.1 wholesale, generalized:

- Any type with a `Linear` component is `Linear` (`Option(Ticket)`,
  records, sums, closures).
- Used exactly once on every path, including loops (E0403/E0404
  analogues), `&&`, `||` and ternaries; dropped only through the type's
  declared `Drop`, whose capabilities and begin label are checked where
  the compiler inserts it (at `?`, early returns).
- No `Eq`, `Ord`, `Hash`, `Show` or `Serialize` instance (E0257 analogue).
- Not storable in `List`, `Map`, `Set`; a closure that captures one is
  `Linear` (callable once); a higher-order parameter that receives one is
  declared Linear-callable, checked per copy.
- May move into a `spawn` region. A `Linear` value holding a `Secret`
  cannot be a spawn result (E0255 stands).
- No format field may have a `Linear`, `Ticket`, `Receipt`, `Anchor` or
  integrity-only type (E-format-field): parsing External bytes must never
  forge one.

### 8.2 Tickets and receipts

- A channel call consumes a `Linear(Ticket)` and returns the External
  answer together with a `Linear(Receipt(site, purpose))`.
- Tickets and receipts are **opaque**: no fields, no instances, built only
  by the runtime. Their epoch and counter are External (§8.4).
- The nonce is computed by the runtime, never by the program. Its form is
  a per-format **echo profile**: `derived`
  (`H(domain ‖ rp ‖ receipt ‖ site ‖ purpose ‖ app_data)` truncated or
  padded to the field width, SHA-512 for 64-byte fields) or `verbatim`
  (the relying party's own construction, for verifiers such as MAA, ITA
  or KBS that fix the layout), with an `app_data` slot (for example an
  RA-TLS key hash).
- A call that timed out or whose helper died still consumes its ticket,
  and its transcript entry counts as sent; no retry reuses a nonce.

### 8.3 `Fresh`

`bind(evidence, receipt, rp)` consumes the receipt, recomputes the nonce,
checks the echo field named by the format, and yields `Fresh(purpose)` —
**only if** an `rp` nonce from a relying party is given, or the call was
checked against a certified counter (§8.6). Without either, the result is
`Delivered`: replay is not excluded, because the kernel controls local
randomness and can hide the CPU source. `Fresh` is itself `Linear` and is
consumed by one decision.

### 8.4 Local randomness

- `RDSEED` / `RNDR` are executed unconditionally (no CPUID gate), 64-bit
  form only (16- and 32-bit `RDSEED` return zero with success on some AMD
  Zen 5 parts), with bounded retry; a fault, exhaustion, zero or a repeat
  means "no CPU source". The outcome is recorded in the transcript and in
  provenance.
- Drawn lazily at the first ticket, not at process start (helper hosts
  re-execute start; early-boot agents may run before the kernel's random
  pool is ready).
- CPU randomness helps against the host, never against the guest kernel
  (§1.2). It feeds `mix_entropy` (§4.3).

### 8.5 Identity and relay

A genuine machine can be asked our nonce and its answer relayed. Freshness
does not prove identity.

- **Remote**: a relying party that knows the expected measurement, plus
  `bind_channel`, so the attested principal is the TLS endpoint.
- **Local** (`Local` marker, `@decides(local)`): produced only by
  `aead_open` under a key that is `Verified` or `Internal`, over a blob
  whose plaintext carries the measurement this program sealed earlier. A
  key the platform derives is External on arrival (the kernel can
  substitute it); `platform_key` (§5.2) accepts it as
  `Verified(Key, PlatformDerived(P, selector, principal))`, so the
  reliance on the measured kernel (`InGuest`) is in the type, and
  `aead_open` under that key yields `Local`. A program with neither path cannot
  satisfy `local`.
- Never by comparing a report with a self-measurement read through the
  kernel (circular).

### 8.6 Rollback

- Sealed data carries its version inside the authenticated plaintext,
  together with the **identity of the counter** that guards it (the TPM's
  EK or AK name, and the NV index name, which commits to its type and
  attributes), pinned at first seal and compared on every read.
- The latest version comes from a counter read with `NV_Certify` and a
  ticket nonce, signed by an AK that is restricted, signing, fixedTPM and
  fixedParent, and whose attestation structure has `magic ==
  TPM_GENERATED`; or from the relying party.
- **First seal** (no prior state) is a distinct outcome that `@decides`
  must accept explicitly, through a remote party or a certified counter at
  its initial value; a missing blob is never silently "empty".
- Stated residual risks: a counter relayed from another TPM (bounded by
  the pinned EK name); cloud vTPMs whose state the host holds give no
  rollback protection, and their `Counter` instance does not exist.

### 8.7 The transcript

- A running hash of every crossing, written ahead (the request is
  recorded before the helper starts): site, receipt, direction, and the
  canonical serialization of the format's **public** fields. Pointers and
  padding are excluded. Secret fields enter as a keyed commitment, or not
  at all; publishing the transcript is a recorded declassification.
- An aborted child region's partial hash is folded into its parent with
  an abort marker.
- A bounded log (sites, counters, digests) is kept beside the hash so a
  relying party can check it.
- `transcript()` returns **External**: it is a commitment to what the
  program saw, not an endorsement, and it lives in memory the kernel can
  write.

## 9. Formats

### 9.1 Declaration

```resid
format SnpReport @layout(c_abi) @signed(sig = signature, span = 0x000..0x2A0) {
    UInt(32) version         firmware  ensures (version in {2, 3, 5});
    UInt(32) guest_svn       measured;
    UInt(64) policy          measured;
    Bytes(16) family_id      host;
    Bytes(16) image_id       host;
    UInt(32) vmpl            firmware;
    UInt(32) signature_algo  firmware  ensures (signature_algo == 1);
    TcbVersion current_tcb   firmware;
    ...
    Bytes(64) report_data    relayed   echo;
    Bytes(48) measurement    measured;
    Bytes(32) host_data      host;
    ...
    Bytes(64) chip_id        firmware;
    ...
    SnpSignature signature;               // r, s little-endian, 72 bytes each, padding checked
}
```

`Bytes(N)` here is a **fixed-length byte array** type for formats
(`List(UInt(8))` with a length fact), not the NUL-terminated `Bytes` of
spec §44.

### 9.2 Rules (each a compile error)

1. Structure is public: lengths, counts, tags, selectors and offsets
   cannot be Secret.
2. Lengths look backward and are bounded; nesting depth is bounded;
   parsing is linear time with no backtracking. Generated parsers are
   loops or tail calls with fixed memory; exceeding the memory budget
   while parsing is an error value, never an abort (tested at the maximum
   size of every format).
3. `ensures` is checked while parsing; status and firmware error words
   are declared with it.
4. Signed spans, field origins and echo fields are declared (§5.3, §8.2).
5. Secret fields: no checks (§4.5); their serializer feeds only a channel
   parameter declared Secret.
6. No `Linear`, ticket, receipt, anchor or integrity-only field types.
7. Layouts:
   - `c_abi`, per target, computed by the compiler and cross-checked
     against clang by `resid-devgen` for both targets, with a test for
     each of: flexible array members (`offsetof` below `sizeof`), tail
     padding, enum size by range, `_Bool` (only 0 or 1 accepted), `char`
     signedness (signed on x86-64, unsigned on AArch64), untagged unions
     as overlapping views, and padding bytes (ignored or required zero,
     declared per format). No bitfields or packed structs in revision 2.
   - Buffer capacity comes from the uapi `sizeof`, never from the parse
     view; `ensures` on lengths are relative to capacity.
   - `be` / `le` packed; `tlv` combinators for DER and CBOR with explicit
     limits.

### 9.3 What formats replace

Hand-written parsers of untrusted input: device descriptors and wrappers,
`tpm_wire`, the SNP certificate table parser, then DER, CBOR and TLS
record parsing. Each is replaced only after the generated code matches it
byte for byte on its existing tests.

### 9.4 Wiping

- Secret mode: no core dumps (prerequisite, §1.5).
- **Stack bleaching at boundaries** instead of per-frame scrubbing (which
  would break tail calls and is skipped by aborts that unwind): at every
  `declassify`, channel call, region exit and abort landing, zero the
  stack from its floor to the current stack pointer minus the red zone,
  then clear vector registers. Lowering carries a "touches secret" bit
  per function so only programs and paths that need it pay.
- Helper processes wipe the request mapping, struct and command regions
  as well as secret regions; helpers killed by timeout, guard page or
  seccomp cannot wipe, so the guarantee there is "no core, no ptrace"
  (dumpable 0, `RLIMIT_CORE` 0).
- All of this is hygiene against later observers; a running kernel can
  read memory (§1.2).

## 10. Failure

A refusing, timed-out or killed channel, a rejected parse, a failed format
contract and a rejecting primitive all produce error values, and none can
produce a partial acceptance: a rejected parse has no value and a failed
primitive no `Verified`. Errors from External sources are External.

## 11. Foreign code

A `foreign` binding is a channel to **IR linked into the measured
binary** (as native modules are, spec §47: own symbols, intrinsics and
`mem*` only; no constructors, thread locals or module asm), run in the
isolated helper. There is no dynamic loading: a library loaded at run
time is code the kernel can substitute.

- Every result is External; arguments and results are formats; a Secret
  argument is a declassification (§4.1).
- The helper's filter allows I/O only on its socket; any I/O the foreign
  code needs goes back to the parent as declared channels with labels.
- Inline `asm` in foreign IR is refused (today only `module asm` is).
- Replies are fixed size; the timer register readable from user space on
  AArch64 is a documented timing channel.
- State that outlives one call (a `Linear` handle held in a helper)
  requires a persistent helper, designed separately; until then foreign
  calls are stateless.

What is not enforced, and stated: what the foreign code does inside, and
a binding that returns key material as plain bytes. `classify` of
External data is recorded in the graph, so such flows are visible to
review, and E-ext-key (§4.3) stops such a key from keying a primitive.

## 12. Knowledge

Formats, fields and their origins, labels, contracts, channels, call
sites, anchors, primitives, appraisal policies, `declassify`, `assume` and
`classify` sites are graph nodes. `residc verify` prints, for a binary:
every anchor with its origin; every assumption; every `declassify` with
its reason and robustness; every channel and foreign symbol; replayable
call sites; selection-equivalent CPU dispatch sites; `@decides` functions
with their requirements; and the hash of every `lib/verify/` file. That
list is the program's reviewed base.

## 13. Reviewed base

The compiler and runtime (checked by the self-hosting fixed point,
provenance and the suites); `lib/verify/` primitives and appraisals, each
with parity tests against a reference verifier; generated parsers; the
anchors and their origins; the robust-declassification allowlist; the
selection-equivalent dispatch sites.

## 14. Spec changes

- New law 15: *Nothing external is trusted; only outcomes are verified.*
- §3.2: labels beside knowledge states; information-acquiring effects are
  External; labels in hash-consing and content hashes.
- New sections: integrity labels and appraisal, the program counter and
  begin labels, label polymorphism, `Linear`, tickets and receipts,
  contracts, formats, channels, `foreign`. §48 gains §4's rules; §45's
  builder rules generalize to `Linear`.
- Error codes from E0270 upward (E0260–E0265 are taken).

## 15. Phases

0. Prerequisites: checked literal arithmetic; literal ranges; secret mode
   without core dumps.
1. Integrity labels: the source table, propagation, pc and begin labels,
   label polymorphism, residual re-check, `assume`. No sinks yet; tests
   assert labels through `resid-why`.
2. Anchors, primitives, signer-claim binding, time sources and collateral
   floors; `@decides`.
3. Appraisal and reference values; EAR output.
4. `Linear`, tickets, receipts, the echo profiles, `bind`, `Fresh`,
   `Local`, the transcript, CPU randomness.
5. Formats: layouts, rules, generated parsers; existing parsers as
   oracles.
6. Behavior contracts and conformance.
7. Secret rule changes (§4) and wiping (§9.4).
8. `foreign`.
9. The `above-kernel` profile.

Each phase lands with conformance tests for every error it introduces, a
`SECURITY.md` row per guarantee, and a deep security review before merge.

## 16. Holes considered

| Attack or failure | Closed by | Residual risk |
|---|---|---|
| Implementer skips verification | only primitives build `Verified` (§5.2) | none in the type system |
| Validly signed but unacceptable evidence (debug, old TCB, VMPL, MA) | `Appraised` with mandatory checks (§6) | reference values must be right |
| Trusting requester- or host-chosen signed fields | field origin (§5.3) | none |
| Old-TCB signing key forging current claims | signer-claim binding (§5.2) | none |
| Verifying bytes the signature does not cover; parser differentials | raw signed spans, format identity, unambiguous parsers (§5.3) | formats outside revision 2 layouts |
| Replay | receipts, echo, `Fresh` needs an RP nonce or certified counter (§8.3) | `Delivered` results without either |
| Kernel picks local randomness or hides RDSEED | ticket External; `Fresh` never rests on local randomness (§8.3–8.4) | none for freshness |
| Relay to another genuine machine | `bind_channel` remotely, `Local` locally (§8.5) | programs with neither cannot decide locally |
| Rollback | versioned sealed data, pinned counter identity, explicit first seal (§8.6) | host-held vTPMs |
| Old collateral, rolled-back clock | `Known` floors, time sources (§5.4) | absolute time without an RP |
| Confused deputy across anchors or kinds (VCEK vs VLEK) | anchor kinds, `accept` ⊆, `require` all-of (§5.1, §7.1) | none |
| Weak algorithm | per-level algorithm lists (§5.1) | none |
| Wrapper or closure hides a decision or declassification | begin labels (§3.3) | none |
| Attacker chooses what is declassified | robust declassification on pc and value integrity (§4.2) | reviewed allowlist |
| Kernel-supplied key or randomness used as a secret | E-ext-key, `mix_entropy` (§4.3) | none |
| "Proof by use" with a substituted key | `aead_open` anchor follows key integrity (§5.2) | none |
| Laundering through builtins, casts, spawn failure, facts, hash-consing | total source table, cast rule, spawn tags, fact labels, label in hash key (§2, §3) | new builtins must be specified |
| Laundering through `assume` | capability family, symbol anchors, refused in lib (§3.6) | reviewed use |
| Laundering through `@decides` results | decisions never raise integrity (§7.1) | none |
| Application redefines an instance `lib/verify` uses | instance pinning (§5.2) | none |
| Error oracle on secrets | one-bit errors, no checks on Secret fields (§4.4–4.5) | none |
| Secret leaked to the kernel via a channel | declassification at the call site (§4.1) | intended disclosures |
| Transcript leaks or launders | External, public fields, keyed commitments (§8.7) | kernel memory writes |
| Core dumps of secrets | prerequisite fix (§1.5) | none |
| Secrets left on the stack | bleaching at boundaries (§9.4) | a running kernel |
| Nonce or handle reuse | `Linear` (§8.1) | across restarts without a counter |
| Parser hang, crash or memory exhaustion | §9.2 rules 1–2 | none in generated parsers |
| Foreign code substituted at run time | linked IR only (§11) | foreign code's internals |
| Integer wrap in a contract or length | prerequisite (§1.5) | none once fixed |
| Compiler, runtime or primitive bug | reviewed base (§13) | inherent |

## 17. Review findings and where they are closed

Information flow: begin labels and closures §3.3; relayed fields §5.3;
proof-by-use key integrity §5.2; External keys E-ext-key §4.3; `@decides`
anchors, results, body, concrete accept §7.1; relay `Local` §8.5; robust
declassification with value integrity §4.2; termination-insensitive exits
and dispatch §3.3, §3.1; total source table §3.1; label polymorphism and
casts §3.4, §3.2; receipts §8.2; transcript and opaque tickets §8.2,
§8.7; full-label pc §3.3; effects, facts, hash-consing §2; spawn tags
§3.2; `Linear` completeness §8.1; Secret format checks §4.5; format
identity §5.3; conformance variance §7.3; anchor and assumption identity
§5.1, §3.6; time and CRL marking §5.4; MAC key identity §5.2; stdlib root
hashing and instance pinning §5.2.

Attestation: attesting principal and profiles §1.2; derived keys and
proof by use §5.2, §8.5; key selectors (device plan R2.5); channel binding
§5.2, §8.5; appraisal and field origin §6, §5.3; signer-claim binding
§5.2; echo profiles, `bind_key`, signed transcripts §8.2, §5.2;
collateral floors and time §5.4; TCB comparison §5.2; TDX quote, SNP,
NSM parity §5.2; counter identity and first seal §8.6; event-log replay
§5.2; transcript labels §8.7; anchor rotation §5.1; raw spans and
unambiguous parsers §5.3; all-of anchors and bound evidence sets §7.1,
§5.5; GPU binding (device plan R2.6); reference values §6; platforms
without sealing keys (device plan R2.5); VMPL §6; provider steering
(device plan R2.4); `Fresh` consumed by one decision §8.3; SNP format
details §9.1.

Runtime: `Fresh` and local randomness §8.3–8.4; effect classes (device
plan R2.3); core dumps §1.5; bleaching §9.4; wire format and secret
fields per field (device plan R2.2); layout cases and capacity §9.2;
transcript §8.7; foreign feasibility §11; helper wiping §9.4;
fixed-length byte type §9.1; echo linkage and profiles §8.2; residual
re-check §3.5; RDSEED mechanics §8.4; parser memory §9.2; NVIDIA
multi-fd and versions (device plan R2.6); TPM sessions (device plan
R2.6); timeouts §8.2.

## 18. Open questions

1. **Attesting principal** (§1.2): state the boundary precisely now with
   the `in-guest` profile, and add `above-kernel` later? (Drafted as yes.)
2. Should `Delivered` (fresh only from our side) be usable in any
   `@decides`, or refused everywhere?
3. Label-generic code: label variables (§3.4) only, or also the
   `Word(W, B)` pattern for code that must differ by label?
4. Typestate for protocols: with `Linear` (phase 4) or after formats
   (phase 5)?
5. Anchor updates without a rebuild (a signed anchor-set update) — in
   scope for a later revision, or rebuild-only permanently?
