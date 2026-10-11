# Attestation — Implementation Plan (revision 1)

**Status: DRAFT (2026-10-10), implementation started 2026-10-11.** Split out of PLAN-labels.md
revision 2, which was accepted the same day: everything about remote
attestation (RATS) that device access does not need. Builds on
PLAN-labels.md revision 3 ("labels" below) and on device
access revision 3 for the platforms' channels.

**Implementation status (2026-10-11).** Phases A1-A4 in large part, for
SEV-SNP, TDX, AWS Nitro, Arm CCA, TPM 2.0 and SPDM devices, with CoRIM reference values (`lib/verify/`,
`compiler/attest.resid`, `tests/attest/`, `SECURITY.md` "Attestation",
reference page "Attestation"); A5 and A6 not started:

- `Verified(T)`, `Appraised(T)`, `Anchor`, `EvidenceTime` and
  `VerifyError` (`lib/verify/core.resid`), built only in `lib/verify/`
  (`@opaque("*")`, which also closed a hole: generic `@opaque` records'
  literals were not checked); `@primitive` and `@verify_internal` (E0280).
- Anchors (E0281, E0282): `@anchor` functions with kind, principal,
  formats, origin, fingerprint, algorithms and expiry; the compiler
  rewrites `anchor_der` into `anchor_make` with those facts (`at_expand`),
  and the bytes are checked against the fingerprint at the first use.
  `lib/verify/amd_anchors.resid` is generated from AMD's ARKs
  (`tools/attest/gen_amd_anchors.py`).
- SNP (`lib/verify/snp.resid`): the report as a `@layout(le) @signed` type
  with field origins; the chain, CRL, signature and signer-claim binding;
  the four verifier forms; `snp_appraise` with the mandatory checks
  (A2's appraisal, without reference-value endorsement or EAR).
- Policies (E0283) and `@decides` (E0284-E0288): gate, accept/require,
  appraised, freshness, identity, `time = not_kernel`; E0286 (the input
  rule) through the integrity labels, which now run in every build of a
  program with a decision.
- Freshness (A3): `vf_bind_challenge`, the accepted mark, reply binding
  of records spent on this program's own device (the SNP report inside
  the reply, `dv_ev_framed`), and the runtime's decided mark (op 4 of
  `resid_chal_mark`).
- `seal_to_evidence` and `open_released` (HPKE Auth mode,
  `lib/verify/seal.resid`).
- AWS Nitro (`lib/verify/nsm.resid`, `aws_anchors.resid`: the real AWS
  root; a real document from blocky/nitrite's tests verifies) and TPM 2.0
  quotes under a pinned AK (`lib/verify/tpm.resid`, kind `TpmAk`), each
  with its plain, key-bound and replayable forms (NSM also channel-bound)
  and an appraisal (A4 in part).
- `seal_to_channel` and the bound TLS sends (`lib/verify/channel.resid`);
  a channel is named by the SHA-256 of its exporter.
- Field origins in the labels: relayed and host fields of `@signed` layout
  types are External when read.
- E-robust and E-control as warnings (E0291, E0292): control over
  disclosure through exits and per-function control summaries, in
  `compiler/labels.resid`; the standard library's sites and functions
  marked `@robust_exempt(reason = ...)` are the allowlist.
- TDX quotes v4 and v5 (`lib/verify/tdx.resid`, `intel_anchors.resid`:
  go-tdx-guest's real quotes verify under Intel's root) and Intel's
  collateral (TCB info, QE identity: strict JSON, `lib/verify/json.resid`,
  signed over exact bytes; Intel's real sample collateral verifies), with
  the TCB status a mandatory appraisal check, and the PCK CA's and root's
  CRLs (Intel's real ones verify).
- CCA tokens (`lib/verify/cca.resid`; the TF-M test token verifies under
  veraison's CPAK), with the CPAK pinned as an `EndorsedKeys` anchor.
- SPDM 1.1 device measurements (`lib/verify/spdm.resid`,
  `nvidia_anchors.resid`; NVIDIA's sample H100 report verifies under the
  real Device Identity CA), and SPDM 1.1 sessions
  (`lib/verify/spdm_session.resid`: the signed KEY_EXCHANGE, the
  measurements its summary covers; `lib/spdm_session.resid`: the
  requester's key schedule and secured messages, generic over secret
  bytes), with SNP and TDX evidence bound to a session
  (`lib/verify/device_bound.resid`). Not yet: later SPDM versions, mutual
  authentication, a transport for the requester, NSM and CCA bound to a
  session, OCSP.
- Endorsed reference values (A2): signed CoRIMs under an `Endorser` anchor
  (`lib/verify/corim.resid`; veraison's signed CoRIM verifies) and the
  endorsed appraisals of SNP, TDX, CCA and SPDM (`lib/verify/endorsed.resid`),
  whose result rests on the endorser too; attest-key triples endorse a CCA
  CPAK or TPM AK in place of a pinned key (`lib/verify/endorsed_keys.resid`,
  `cca_verify_endorsed`, `tpm_verify_quote_endorsed`). Not yet:
  endorsed-value triples, conditioned attest keys.
- Rollback (§8): `tpm_verify_counter` (TPM2_NV_Certify of a counter
  under a pinned AK), `bind_counter` (a local decision can be fresh) and
  `first_seal` (the explicit first-seal outcome);
  EAR output (`lib/verify/ear.resid`, A2).
- The transcript (§9): `runtime/rt/transcript.resid`, notes from the
  device engines, `lib/transcript.resid`, on only when read; no abort
  markers for failed regions yet (the hash is process-wide).
- `bind =` (E0293, a run-time check the compiler inserts), `assume`
  (`lib/verify/assume.resid`, the `assume` family, `@assumption`, E0289),
  instance pinning (E0294), AMD CRL number floors, and `Local`
  (`lib/verify/sealing.resid`: `snp_platform_key`, `local_seal`,
  `local_open`; without `bind_counter`, so local decisions are written
  `fresh = false`).
- The verify closure and runtime are pinned (E0290,
  `compiler/verify_pins.resid`, `tools/attest/verify_pins.py`, checked by
  `boot.sh`); the provenance record's `attest` array and `residc verify`
  list anchors, policies and decisions.

Differences decided while implementing: `Appraised(T)` has no policy
parameter (the compiler tracks the policy of each gate; the plan's
`Appraised(T, P)` binding types are inferred anyway); an anchor's kind,
algorithms and formats are also checked statically against the
primitive's annotation; qualifiers and inputs of each primitive are
declared in its `@primitive(...)` annotation (`gives`, `inputs`, `time`,
`release`, `gate`); a provisioned key is exempt from E0286 without a
`[labels] provisioned_release` list (it already needs the `provision`
grant); a record spent on a failed request is refused, not treated as the
relying party's; the new errors are errors from the start (no program used
these annotations before), while E-robust and E-control will be warnings
first; the robust-declassification allowlist is the standard library and
`@robust_exempt` functions rather than a manifest list, and "trusted for
control" is any primitive's result (no `control_anchors` yet). Found
while implementing: a record literal could leave a field unset (read as
garbage, a memory-safety hole); the checker now refuses it; and
lib/tls.resid used a function of lib/tlsmsg.resid it did not import. Not
yet: closures' own control summaries, `control_anchors`, the TPM AK's
binding to its EK; A5 and A6.

**Goal**: a platform verifier is written once against a contract and
cannot skip verification, appraisal or freshness, and a decision that
releases something says, in its signature, whose word it rests on. There
is no `unsafe` escape.

**Burden target** (labels §2 applies): a verifier author writes
`@decides` on the function that releases something, and calls the
platform's verify and appraise primitives. Nonces are the runtime's
(labels §6); freshness, its single use and the challenge check are done by the
primitives and the compiler. Labels are written only on `@decides` and
in `lib/verify/`.

Appendix B is a complete example in which every name is defined.


---

## 1. What hardware evidence can and cannot vouch for

A hardware report (SNP, TDX, CCA, NSM) or TPM quote vouches for the
**attesting principal**: the launched image as measured (firmware, kernel,
initrd and command line), at a privilege level, and for whatever that
principal placed in the report's caller-chosen fields. The guest kernel
requests reports and derives keys, and can read and write process memory.
Therefore:

- Claims about a user-space Resid program are exactly as good as the
  measured kernel that ran it. Platform anchors name their attesting
  principal (§3.1), so a `@decides` that accepts evidence from an in-guest
  principal says, in its signature, that it relies on the measured guest
  kernel.
- The Resid binary must itself be inside the launch measurement (a
  unified kernel image or measured initrd, or a measured dm-verity root
  named on the measured command line). A platform profile that cannot
  show this cannot produce `Appraised` claims about the program.
- **Profiles.** `in-guest` (default): the attesting principal is the
  measured guest image. `above-kernel` (phase A6): the attesting code runs
  at a higher privilege than the guest kernel (SNP SVSM at VMPL0, or a
  paravisor), so the guest kernel is outside what the evidence covers.

Because the `in-guest` profile already relies on the measured guest
kernel, randomness the guest kernel supplies is as trustworthy as the
evidence itself. This is what lets the runtime's nonce (labels §6.6)
give freshness without any nonce from the program (§6).

## 2. Integrity levels

This plan fills the open integrity scale of labels §3:

`Internal` ⊒ `Appraised(P)` ⊒ `Verified(A)` ⊒ `External`

`Verified` carries a set of anchors and a set of evidence identities
(§3.5); `Appraised` carries a policy identity. An integrity label also
carries **qualifiers**:

| Qualifier | Values | Produced by |
|---|---|---|
| `time_source` | `RelyingParty`, `SignedEvidence`, `Kernel` | time arguments (§3.4) |
| `principal` | `InGuest`, `AboveKernel` | anchors and `platform_key` (§1, §3.2) |
| freshness | `Fresh`, `Delivered`, none | challenge binding (§6) |
| bound data | `RpBound(bind)`, none | a record issued with `bind` (§6) |
| identity | `KeyBound(kem, pk)`, `ChannelBound`, `Local`, none | the `_key_bound` and `_channel_bound` verifier forms, `bind_counter` (§7) |

**Qualifiers are static.** Which qualifiers a primitive sets is fixed by
its signature, never by a run-time value: a condition that does not hold
at run time makes the primitive fail, it never weakens the result. So
`snp_verify`, `snp_verify_key_bound` and `snp_verify_channel_bound` are
separate functions (the second refuses an empty or malformed key), a `ReplayableRecord` (labels
§6.8) goes only to the replayable verifiers, whose result is `Delivered`,
and a profile condition such as the `above-kernel` CPU-source rule (§6.1)
is a refusal.

Qualifiers describe **evidence**: they are set by primitives on the
values they produce and are read only from the gate of a `@decides`
(§5.1). An `Internal` value carries no evidence and never satisfies an
evidence requirement, however high its integrity. For joins it is
neutral: `Verified(A)` joined with `Internal` is `Verified(A)` with the
same qualifiers. Otherwise joins take unions of sets and the weakest
qualifier (no freshness and no identity are the weakest). Casts never
raise integrity, drop anchors, or add `Fresh` or an identity (labels §4.2
extended). No layout field may have an anchor or an integrity-only type
(labels §7.2 rule 6 extended).

## 3. Verified

### 3.1 Anchors

An anchor is a `Known` value from a nullary `@anchor` function with its
origin, checked by resolved path and fingerprint (E-anchor-origin,
E-anchor-known):

```resid
@anchor(kind = AmdVcek(Genoa), principal = InGuest, formats = [SnpReport],
        source = "https://kdsintf.amd.com/vcek/v1/Genoa/cert_chain",
        fingerprint = "sha384:…", retrieved = "2026-10-01", reviewed_by = "…",
        algorithms = [RsaPss4096Sha384, EcdsaP384Sha384],   // root first
        expires = "2045-01-01")
Anchor amd_ark_genoa() { return anchor_der(…); }
```

- **An anchor's identity is its function**: the resolved path of the
  `@anchor` function together with its fingerprint. A `Verified` label
  carries identities, and `@decides(accept = …, require = …)` names
  anchor functions (`accept = [amd_ark_genoa]`), never kinds. Any package
  may declare anchors (a deployment pins its own CA or TPM), but a
  dependency's anchor is accepted only where the application names it,
  so declaring `kind = AmdVcek(Genoa)` over another root gains nothing.
- **The kind is checked by primitives**: `snp_verify` refuses a root whose
  kind is not `AmdVcek` or `AmdVlek`, and refuses a report whose
  `SIGNING_KEY` does not match the root's kind. The ARK roots both the
  VCEK and the VLEK chains, so the library declares two anchor functions
  over the same certificate (`amd_ark_genoa`, kind `AmdVcek(Genoa)`, and
  `amd_ark_genoa_vlek`, kind `AmdVlek(Genoa, csp_id)`).
- **`formats`** lists the `@signed` layout types this anchor's keys may
  verify (§3.3). An anchor may list only types declared in its own
  package (E-anchor-format), so an application cannot have AMD-signed
  bytes parsed under a type of its own.

- **Kinds** separate meanings that share a root: `AmdVcek(product)` (chip
  bound) versus `AmdVlek(product, csp_id)` (fleet wide); Intel PCK; NVIDIA
  device; Nitro; TPM EK manufacturer; endorsed key lists (CoRIM
  attest-key triples, as Arm CCA platform keys often are); and
  `ReleaseSender(kem)`, a releasing party's HPKE sender key, which
  `open_released` checks (§3.2). `principal` is given only for hardware
  kinds.
- **Algorithms per path level**: the AMD ARK and ASK sign with RSASSA-PSS
  SHA-384 (RSA-4096); only the VCEK is P-384.
- **Rotation and revocation.** Anchors are rebuild-only. A rebuild changes
  the launch measurement and so loses measurement-bound sealed data; the
  update path for sealed data is §8.

### 3.2 Primitives: the only constructors

`Verified` is produced only by functions annotated `@primitive` in
`lib/verify/` (E-primitive-outside, by resolved stdlib path). The
**verify closure** is every standard-library file that `lib/verify/` or
stdlib `@decides` code imports, directly or transitively (the parsers,
`x509`, `certverify`, `rsa`, `ecdsa`, the curve and hash code), plus the
files that define the instances pinned below. Provenance records the
hash of every file in it. The compiler carries the hashes of the verify
closure it was released with and refuses to compile against any other
set, so a substituted `RESID_HOME` can supply neither its own primitives
nor a `sig_verify` that returns true. The same holds for the runtime,
which holds `challenge_issue`, the spent, accepted and decided marks and
the random source: the compiler carries the hashes of `rt.ll` and
`rt-aarch64.ll`, refuses others, and refuses `-rtr` and `-rt` for a
program that reaches `lib/verify/` or a challenge builtin; provenance
records both hashes; `--verify-lib-dev` lifts this for work on the
library and is recorded in provenance, which `residc verify` reports. Generated canonical parsers are named in
the reviewed base as compiler-generated primitives. Instances of
behaviors reached from `lib/verify/` and stdlib `@decides` code are
pinned to the standard library's (E-verify-instance), so an application
cannot redefine `Eq(Measurement)`.

| Primitive | Takes | Gives |
|---|---|---|
| `anchor_key(a)` | a `Known` anchor | `Verified(Key, {a})` |
| `verify_chain(root, certs, crls, time)` | `Verified(Key)`, External certificates and CRLs, a time with its source | `Verified(LeafCert, A)`: parsed, verified extensions; validity, key usage, path length, revocation and CRL number checked |
| `verify_sig(key, span, sig)` | `Verified(Key)`, External raw byte span | `Verified(Span(F), A)` for a `@signed` layout type `F` listed in the `formats` of every anchor in `A` (§3.1) |
| `verify_mac(key, span, tag)` | key | `Verified(Span(F), Mac(binding))`, where `binding` is the key's compile-time binding identity, never a function of its value |
| `aead_open(key, nonce, ct, aad)` | key | `Verified(pt, Aead(anchor of key))` if the key is `Verified(A)` and unpredictable (labels §5.2), and under a `platform_key` key also `Local` when the plaintext carries this measurement (§7); `Aead(Self)` if the key is own (labels §5.2), drawn only from this process's `random_secret` and never disclosed, so only this process can have sealed the plaintext; **External** otherwise: under an agreed key the peer chose the plaintext (anyone can send an HPKE message to a public key), and a predictable key, such as a constant in the binary, proves nothing. `Aead(Self)` is not an anchor: it never satisfies `accept`, and only makes the value not External |
| `verify_digest(expected, span)` | `Known` or `Verified` digest | `Verified(Span(F), A)` |
| `bind_challenge(evidence, c, key)` | `Verified` evidence, the `ChallengeRecord` (labels §6.5) whose value its relayed field must carry, and, in the key-bound form, the attester's KEM and public key | the freshness, relying-party and `KeyBound(kem, pk)` qualifiers of §6 and §7; refuses a record past its lifetime, already accepted, spent on a descriptor of another platform, or reply-bound to other bytes (labels §6.5); called inside every platform verifier, never by hand |
| `platform_key(src, selector, report)` | a `SealingKey(P)` instance (§10; its `device` grant is the caller's), from which it derives the key itself, so key and selector cannot disagree; the typed selector, which must mix in the measurement and policy (§10); and a `Verified`, `Fresh` report, on which it applies the platform's mandatory checks of §4 that need no reference value (for SNP: `DEBUG` = 0, the migration-agent rule, the report's `VMPL`, signature algorithm and version), and whose record this program spent in an `Issued` request and which is reply-bound to that call (labels §6.5), so it is this program's own device's answer, not one relayed from another guest; the report's gate is consumed. No further appraisal is required: a policy compiled into the binary cannot name the binary's own launch measurement, and the key is bound to whatever measurement the report shows | `Verified(Secret(Key), PlatformDerived(selector, principal))`: the platform's derivation is accepted as the attesting principal's, so the anchor names the principal and a `@decides` must list it to rely on it |
| `bind_key(outer, key)` | evidence whose signed span carries `H(key)` | `Verified(Key, outer's anchors, outer's identity)` (Azure HCL, SVSM, CCA realm-to-platform) |
| `verify_signed_transcript(key, transcript, sig)` | SPDM-style signature over a request/response transcript | `Verified(Span)` with the requester nonce bound |
| `bind_channel(evidence, c, e)` | inside the `_channel_bound` verifier forms: verified evidence whose relayed field equals `challenge_with_channel(challenge_value(c), e)` (labels §6.5), where `e` is the `ChannelExporter` of the connection the decision answers on | `Fresh` and `ChannelBound`. The attester computes the value from its *own* connection, so a party in the middle, whose two connections have different exporters, cannot relay the challenge to a genuine attester |
| `bind_counter(opened, counter)` | a `Local` value from `aead_open` whose plaintext carries a version, and `Fresh` counter evidence (§8) for the pinned counter | a bound evidence set (§3.5) that is `Local` and `Fresh` when the versions agree; the way a local decision gets both |
| `replay_log(digest, log)` | a `Verified` PCR, RTMR or REM digest, an External event log | per-event `Verified` only where the event digest equals the hash of its data; other event data stays External |
| `cose_verify(key, msg)` | COSE_Sign1 | algorithm pinned from the protected header to the anchor's list |
| `tcb_ge(v, floor)` | a `Verified` TCB vector, a `Known` floor | a platform-ordered comparison (SNP per-component SPLs with the product's layout; TDX CPUSVN components, PCE SVN and module SVN) |
| `snp_verify`, `tdx_verify_quote`, `nsm_verify`, `cca_verify`, `spdm_verify`, each with its `_key_bound`, `_channel_bound` and `_replayable` forms | report bytes (the reply field the descriptor names as evidence, labels §6.5), the verifier's record, collateral, an `EvidenceTime`, and in the key-bound form the attester's KEM and public key, in the channel-bound form this side's `ChannelExporter` | `Verified` evidence with its challenge bound, tested for parity with go-sev-guest / virtee, Intel DCAP QVL, aws-nitro-enclaves-cose and Veraison |
| `seal_to_channel(e, x, value)` | `Appraised` evidence carrying `ChannelBound` for the `ChannelExporter` `x`, and a value | refuses unless `x` is the exporter the evidence was verified against; otherwise a `ChannelSealed(T)` (opaque) that only `tlsserver_send_bound(TlsConn c, ChannelSealed(T) v)` and `tlsclient_send_bound(TlsClient c, ChannelSealed(T) v)` write, each refusing unless `c`'s exporter is `x`. The only way a `channel_bound` decision releases (§5.1, §7); the sends are reviewed publication sites (§5.2) |
| `seal_to_evidence(e, kem, pk, value, sender)` | `Appraised` evidence carrying `KeyBound(kem', pk')`, a KEM and public key, a Secret value, and the releaser's HPKE sender private key (`@key(own, provisioned)`, labels §5.2) | refuses unless `kem = kem'` and `pk = pk'`; otherwise HPKE-seals `value` to `pk` in Auth mode under `sender` (RFC 9180 §5.1.3; suite and info fixed by `lib/verify/seal.resid`) and returns the public `HpkeMessage`, a reviewed publication site (§5.2). The only way a `key_bound` decision releases (§5.1, §7). Auth mode lets the attester tell who released the value: without it, anyone (the host included) could seal a key of its choosing to the attester's public key |
| `open_released(kem, sk, msg, a)` | the attester's own private key (`@key(own)`), an `HpkeMessage`, and a `Known` anchor of kind `ReleaseSender(kem)` | opens `msg` in Auth mode with the anchor's key as the sender's; `Verified(List(Secret(UInt(8))), {a})` on success. Its result is unpredictable on the sender's word (labels §5.2), so it can key a primitive without `provisioned_key` |

Every primitive is total over hostile input, constant time over secrets,
and refuses algorithms its anchor does not list. Primitives fail with
one sum, `type VerifyError = BadLayout(Str) | BadChain(Str) |
BadSignature(Str) | Stale(Str) | NotFresh(Str) | Refused(Str, Str);`.

The SNP verifier's signatures (`lib/verify/snp.resid`); the anchor set of
a result is inferred from the `Known` anchor passed in:

```resid
type SnpCollateral = { List(UInt(8)) vcek_der; List(UInt(8)) ask_der; List(UInt(8)) crl_der; };

type TimeSource = RelyingParty | SignedEvidence | Kernel;
type EvidenceTime;                       // builtin, opaque
@requires(clock(readonly)) EvidenceTime kernel_time();
Instant evidence_time_at(EvidenceTime t);
TimeSource evidence_time_source(EvidenceTime t);

@primitive pub Result(Verified(SnpReport), VerifyError)
    snp_verify(List(UInt(8)) report, ChallengeRecord c, Anchor root, SnpCollateral col,
               EvidenceTime t) { ... }
@primitive pub Result(Verified(SnpReport), VerifyError)
    snp_verify_key_bound(List(UInt(8)) report, ChallengeRecord c, Anchor root, SnpCollateral col,
                         EvidenceTime t, Int kem, List(Int) pk) { ... }
@primitive pub Result(Verified(SnpReport), VerifyError)
    snp_verify_channel_bound(List(UInt(8)) report, ChallengeRecord c, Anchor root,
                             SnpCollateral col, EvidenceTime t, ChannelExporter e) { ... }
@primitive pub Result(Verified(SnpReport), VerifyError)
    snp_verify_replayable(List(UInt(8)) report, ReplayableRecord c, Anchor root,
                          SnpCollateral col, EvidenceTime t) { ... }
@primitive pub Result(Appraised(SnpReport, P), VerifyError)
    snp_appraise(Verified(SnpReport) v, SnpPolicy policy) { ... }
@primitive pub Result(HpkeMessage, VerifyError)
    seal_to_evidence(Appraised(T, P) e, Int kem, List(Int) pk, List(Secret(UInt(8))) value,
                     List(Secret(UInt(8))) sender) { ... }
@primitive pub Result(Verified(List(Secret(UInt(8)))), VerifyError)
    open_released(Int kem, List(Secret(UInt(8))) sk, HpkeMessage msg, Anchor sender) { ... }
```

`snp_verify` gives `Fresh`; `snp_verify_key_bound` gives `Fresh` and
`KeyBound(kem, pk)`; `snp_verify_channel_bound` gives `Fresh` and
`ChannelBound`; `snp_verify_replayable` gives `Delivered`. Each other
platform has the same four forms. The time `t` checks certificate
and CRL validity and sets the result's `time_source` (§3.4);
`kernel_time()` reads the kernel clock and is marked `Kernel`, so a
decision with `time = not_kernel` needs the relying party's signed time
or a timestamp inside signed evidence. `EvidenceTime` is opaque: only
`kernel_time()` and the `lib/verify/` primitives that verify a signed
time (the relying party's, or one inside signed evidence such as NSM's
`timestamp`; specified with each platform in phase A1) build one, so a
program can neither claim a source it did not use nor pass a past time
to make an expired certificate valid.

**Signer-claim binding.** A claim whose meaning depends on the signer is
checked against the signer's certificate inside the platform primitive:
SNP `REPORTED_TCB` against the VCEK TCB extensions, `CHIP_ID` against the
hardware ID extension, `SIGNING_KEY` against the certificate kind; TDX PCK
SGX extensions against the TCB info's FMSPC and PCE ID.

### 3.3 Signed spans and field origin

- Signatures cover **raw byte spans**. Parsers are **unambiguous**: strict
  DER where DER applies; JSON and CBOR without duplicate keys, indefinite
  lengths or trailing data; canonical-only where the format defines a
  canonical form. XML signature formats are refused in the standard
  library (NVIDIA RIMs go through NRAS's signed token, a separate anchor).
- Layout types gain `@signed(sig = …, span = …)` and a per-field
  **origin** annotation: `@measured`, `@firmware` (the signer vouches) or
  `@relayed` / `@host` (copied from the requester or chosen by the host).
  A field without one is `@relayed`. SNP `REPORT_DATA`, `HOST_DATA`, ID block fields and
  `REPORTED_TCB` (host lowerable), TDX `REPORTDATA`, `MRCONFIGID`,
  `MROWNER`, `MROWNERCONFIG`, CCA RPV, NSM `user_data`, `public_key` and
  `nonce`, TPM `extraData` are relayed or host. A relayed or host field
  parses as External bound to the evidence identity, and is useful only
  through `bind_challenge`, `bind_key` or `bind_channel`.
- `Verified` bytes carry the identity of the layout type they were
  verified under; only that type's generated parser yields `Verified`
  fields, and a type can be verified only under an anchor whose
  `formats` lists it (§3.1). Origin annotations therefore speak only for
  the package that declares both the type and the anchor.
  Slicing or reparsing yields External with the evidence identity.

```resid
@layout(c_abi) @signed(sig = signature, span = 0x000..0x2A0)
type SnpReport = {
    @firmware @check(version in {2, 3, 5}) UInt(32) version;
    @measured UInt(32) guest_svn;
    @measured UInt(64) policy;
    @host Bytes(16) family_id;
    @host Bytes(16) image_id;
    @firmware UInt(32) vmpl;
    @firmware @check(signature_algo == 1) UInt(32) signature_algo;
    @firmware TcbVersion current_tcb;
    ...
    @relayed Bytes(64) report_data;       // carries SnpReportReq.user_data
    @measured Bytes(48) measurement;
    @host Bytes(32) host_data;
    ...
    @firmware Bytes(64) chip_id;
    ...
    SnpSignature signature;               // r, s little-endian, 72 bytes each, padding checked
};
```

### 3.4 Time and collateral

- Platform TSC protection (SNP Secure TSC, TDX) gives a trusted *monotonic*
  clock, not wall-clock time. No platform gives trusted absolute time.
- `time` arguments carry `time_source ∈ {RelyingParty, SignedEvidence,
  Kernel}`: the relying party's signed time, a timestamp inside signed
  evidence (the NSM `timestamp`), or the kernel clock.
- Collateral freshness: `Known` floors compiled in for Intel
  `tcbEvaluationDataNumber`, CRL numbers and AMD KDS CRLs; collateral below
  the floor is refused regardless of time.
- `verify_chain` results carry the time source and CRL freshness; a
  `@decides` may require `time = not_kernel`. Every platform verifier
  takes an `EvidenceTime` (§3.2).

### 3.5 Joins and identity

`Verified(A) ⊔ Verified(B)` is `Verified(A ∪ B)` with the union of
evidence identities. Composite evidence (quote and collateral, CCA
platform and realm, CPU and GPU) is one **bound evidence set** when its
members are linked by a verified binding (`bind_key`, an SPDM session
signed by the device, `bind_counter`); otherwise it is several sources.
A bound evidence set has the union of its members' anchors and the
identity and bound-data qualifiers any member carries, because the
binding shows they describe one principal; `principal` and
`time_source` are the weakest member's. Freshness is not shared: a key
binding shows who signed, not when, so a member signed by a long-lived
bound key may be old. The set is `Fresh` only when every member is,
each either binding a fresh challenge itself, or having the digest of
its bytes inside a `Fresh` member's signed span, or made fresh by
`bind_counter`'s version check. Values that are joined
without a verified binding are several sources, and a gate is never made
of several sources (§5.1). `single_source` in a behavior (§5.3) means the
instance's result must be one bound evidence set.

### 3.6 `assume`

`assume` is a capability family (spawn lists, sandbox ceilings, manifest
bounds, and a force-time check, as `declassify`). `assume(x, Why)` names a
declared assumption symbol, not a string, and every assumption **pins**
the value it vouches for: `assume` compares a digest of `x` with the pin
and returns an error value on a mismatch, so it can never bless whatever
the kernel or the network happened to supply.

```resid
@assumption(reason = "the deployment pins this host's TPM by EK name",
            pins = "sha256:…")
Assumption pinned_tpm();
...
Verified(Key, Assumed(pinned_tpm)) k = assume(ek_pub, pinned_tpm)?;
```

The anchor is `Assumed(package, symbol)`, so a dependency cannot mint an
assumption an application sink accepts. `assume` is refused in the
standard library (E-assume-lib) and listed by `residc verify`.

## 4. Appraisal: `Appraised(P)`

`Verified(A)` means "A signed these bytes". It does not mean the
evidence is acceptable: a debug-policy VM, an old TCB, a migration agent
or VMPL3 are all validly signed. **Appraisal** is the stage between.

`appraise(evidence, reference_values, policy)` primitives in `lib/verify/`
produce `Appraised(T, P)`. A **policy** is, like an anchor, a `Known`
value from a nullary function, annotated `@policy`; its identity `P` is
the function's resolved path, which `@decides(appraised = P)` names:

```resid
type TcbVersion = { Int bootloader; Int tee; Int snp; Int microcode; };
type SnpPolicy = { TcbVersion min_tcb; List(Str) measurements_hex; Int vmpl;
                   Bool allow_migration_agent; List(Str) id_key_digests_hex;
                   List(Str) host_data_hex; };
```

An empty `id_key_digests_hex` or `host_data_hex` means the field is not
constrained. The policy argument of every appraisal must be a direct call
of a `@policy` function (E-policy-known); its identity `P` is that
function's path. A policy value computed at run time, or read from
outside, is refused, so `Appraised(P)` always names a reviewed rule.

Claims about the program itself need the program inside the measurement
(§1). The compiler cannot see a launch measurement, so this is a duty of
the reference values: a deployment's expected measurement must be
computed over an image that contains the binary whose provenance record
it ships. `residc verify` prints the binary's hash for that purpose.

Each platform's appraisal has mandatory checks that no policy can turn
off:

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

## 5. Sinks

### 5.1 `@decides`

```resid
@decides(require = [amd_ark_genoa],
         accept = [amd_ark_genoa, nvidia_h100_root],
         appraised = snp_release_policy,
         identity = key_bound,
         time = not_kernel)
Result(HpkeMessage, VerifyError) release(...)
```

Every argument is `key = value` and every key is optional except that
identity and appraisal have no silent default (below).

**The gate.** A decision rests on one piece of evidence, its **gate**: a
value produced inside the body by a `@primitive` call. Every success
return of the body (any return other than an error value) must be
reached only through the `Ok` of that call: after `?` on it, or inside
its `match` arm for `Ok`. A body that calls a primitive and ignores the
result (`match (snp_verify(...)) { _ => () }`) has no gate and is
refused (E-decides-gate). The gate must satisfy every requirement:

- `accept` and `require` name anchor functions (§3.1). The gate's anchor
  set must be ⊆ `accept` and must contain every anchor in `require`
  (all-of). The gate is one bound evidence set (§3.5), so `require` is
  met only by evidence linked by a verified binding, never by joining
  unrelated reports.
- `appraised = P` requires the gate to be `Appraised(P)`, not just
  `Verified`, and is required: evidence that is only `Verified` could
  come from any image the anchor signs for, debug ones included. A
  decision that means that writes `appraised = none`, and `residc
  verify` lists it. `identity = local` does not need it: its key came from
  `platform_key`, which applied the platform's mandatory checks and
  binds the measurement.
- The gate must be `Fresh` (§6), and `Delivered` never satisfies it.
  Protocols are kept apart by the record's `bind` tag (labels §6.5),
  checked by `bind =` (below). The
  mark is consumed by this decision (§6.3). The one exception is
  written: `fresh = false` accepts a gate without freshness, `Delivered`
  included, for evidence meant to be reused (a signed license, a signed
  configuration). Such a gate needs no record and is not single-use,
  such a decision is listed by `residc verify`, and its result is never
  trusted for control (§5.2).
- **Identity is required by default**: the gate must carry
  `ChannelBound`, `KeyBound` or `Local` (§7), and `identity =
  channel_bound | key_bound | local` narrows it to one. A decision whose
  answer may go to anyone who asks writes `identity = none`, and
  `residc verify` lists it. With `key_bound`, every success return must
  be the result of `seal_to_evidence` on the gate (§3.2), so the released
  value can be opened only by the key the evidence attests. With
  `channel_bound`, every success return must be the result of
  `seal_to_channel` on the gate (§3.2), so the released value is written
  only to the connection the evidence is bound to. Which connection's
  exporter a request names may be chosen by anyone: the release reaches
  only that connection.
- `time = not_kernel` requires the gate's `time_source` to be other than
  `Kernel` (§3.4).
- `bind = b` (a `Known` byte string) requires the gate's `RpBound(b)`:
  the record was issued for this purpose. A program whose
  `challenge_issue` calls use more than one `bind`, or a `bind` the
  compiler cannot know, must name one on every decision
  (E-decides-bind), so a record issued for one protocol cannot satisfy
  another's decision.

`Internal` values never form a gate (§2): only a primitive's result can.

**Which value is decided.** Every other input that reaches or selects the
result (labels §4.3), and everything the body obtains (channel calls,
captured closures, callees), must not be `External`, except bytes passed
straight into a primitive that verifies them (the report, the
collateral, the record, the attester's key), and a Secret value whose
every byte is unpredictable (labels §5.2: its count equals its length)
from `random_secret` (labels §5.2), `platform_key`, or a `provisioned_key`
call at a site the application lists in `[labels] provisioned_release
= ["path::function"]` (a stated reliance that those bytes are the
operator's, not a request's: `provisioned_key` itself accepts any
bytes). The exemption removes only that source's own label: every other
operand that reaches the value must not be External (a KDF whose `info`
is a request's tenant name derives a key the request chose), and *which*
such value is released must not be selected by External data, so a
broker holding several keys picks one from the evidence or the
program. Across calls this is checked
at each caller through the flow summary: a caller passing External data
(or data selected by it) to a parameter that reaches the result is an
error at that call (E-decides-input). So a broker cannot release the key
an unverified request names; the choice must come from the evidence or
the program. The one External choice allowed is *which primitive forms
the gate* (an unverifiable `provider` field picking the SNP or the TDX
verifier, §10): whichever runs, its result must meet every requirement
above, so the choice can only make the decision fail. The compiler
allows it only where the arms differ in nothing but the primitive call
that forms the gate: the released value and everything else that reaches
the result must be the same expression on every arm. Any `Verified` or
`Appraised` value the body uses has anchors ⊆ `accept`.

**The result** is the join of the gate and those inputs; a decision never
raises integrity, so one `@decides` cannot launder another's anchors.

**Whether a decision runs is not checked.** An attacker who can trigger a
decision still needs fresh, accepted, appraised evidence for it; the gate
is single-use (§6.3); and with an identity requirement the result goes
only to the attested principal. What an attacker could gain by choosing
*whether* something happens is a disclosure, and disclosures are checked
where they happen (§5.2, §5.4).

### 5.2 Robust declassification

A `declassify` is robust only if the value's integrity, and that of
everything controlling whether it runs (§5.4), is `Internal` or
**trusted for control** (Myers, Sabelfeld, Zdancewic). Trusted for
control means `Verified` or `Appraised` evidence that is `Fresh` (never
the gate of a `fresh = false` decision), that carries an identity and
controls only disclosures to that identity (a `KeyBound` gate over
`seal_to_evidence` to its key, a `ChannelBound` gate over sends of
`seal_to_channel` on its connection, a `Local` gate over disclosures
into this program's own sealed state, sealed under its `platform_key`;
a `Local` gate never authorizes a disclosure to anyone else), and
whose anchors are all named in the application's manifest
(`[labels] control_anchors = ["path::anchor_fn"]`), none assumed. A
dependency's anchor, or an old signed approval replayed, therefore never
authorizes a disclosure. A non-robust `declassify` is refused (E-robust), except at
sites in a reviewed allowlist: in the standard library (the TLS record and
handshake publication sites, `seal_to_evidence`, the bound sends of
`seal_to_channel`, the `@one_way` publication sites such as public-key
derivation, and `challenge_with_key` and `challenge_with_channel`, whose
inputs are External by protocol design) and in an application's manifest
(`[labels] robust_exempt = ["path::function"]`, for sites such as a
password check, which must disclose one bit on an outside guess). Every
allowlisted site is listed by `residc verify`. Bytes from the runtime
random source are External but chosen by no one, so for E-robust they
count as `Internal`. Robustness is judged at the
outermost call site through control summaries (§5.4), not inside the
wrapper that holds the `declassify`. E-robust is enabled with this plan's
phase A1; before it, labels gives only the reason requirement.

### 5.3 Behavior conformance, extended

| In the behavior | The instance must |
|---|---|
| result `Verified(T, A)` / `Appraised(P)` | return it with anchors ⊆ A / the same policy |
| `Fresh`, anchor sets, `single_source` | be at least as strict |
| `@decides` | have `accept` ⊆ the behavior's and an identity at least as strict |
| control summary | control no disclosure the behavior's summary does not (§5.4) |

### 5.4 Control over disclosure

The labels plan tracks selection, not whether code runs (its §4.3). For
robust `declassify` the compiler also asks: *can outside data choose
whether this disclosure happens?* Every way of choosing counts: a
branch, an early `return`, `?`, `break`, a loop that stops early, and the
abort of a spawn region (the parent survives it and continues). Only two
things do not count:

- a condition that is trusted for control (§5.2), including the tag of
  a `@primitive` result whose evidence is (choosing by verified, fresh
  evidence from an anchor the application names is the point);
- an exit that ends the whole process (the attacker learns at most that
  it stopped, once: availability).

Selection-equivalent CPU dispatch (labels §4.1) never controls.

- **Within a function**: a disclosure on a path that an External
  condition decides is controlled.
- **Across calls**: each function's **control summary** lists, per
  parameter, the disclosures it controls (by reaching one or by deciding
  whether one runs), including through callees, closures it calls and
  behavior instances chosen per copy. A call passing External data to a
  controlling parameter is an error at that call (E-control), reported in
  the caller's code.
- **Closures**: a closure's type carries its control summary; calling a
  closure value that is itself External controls every disclosure it
  reaches.

The diagnostic is phrased as data flow, under labels §4.6 (source, path,
sink; blame user code; a fix hint; warning for one phase first):

```
error[E0271]: outside data decides whether a secret is disclosed
  --> main.resid:12:9
   |
12 |   Bool go = net_read_flag(sock)?;
   |             ------------------- External (network)
13 |   if (!go) { return Ok(()); }
   |       --- `go` decides whether the code below runs
14 |   send_key(sock, declassify(k, "session key to the peer"));
   |                  ------------------------------------- disclosed here
   = help: decide from verified evidence, or list this site in
     `[labels] robust_exempt` with a reason
```

## 6. Freshness from the runtime nonce

Labels §6 puts a runtime nonce (or an override) into every challenge
request, and a program that will check the answer holds a challenge
record. Platform verifiers bind it.

### 6.1 What each challenge proves

Every platform verifier takes the record the verifier holds (the four
forms of §3.2). It verifies the signature, then calls `bind_challenge`,
which compares the verified relayed field (`report_data`) with
`challenge_value(c)`, or, in the key-bound and channel-bound forms, with
the value `challenge_with_key` or `challenge_with_channel` (labels §6.5)
gives for that KEM and public key, or for this side's exporter
(constant time when Secret bytes are in the span). It refuses a record
past its lifetime, one already accepted, one spent on a descriptor of
another platform, and one reply-bound to other bytes. One function
serves both cases, because the record is the same thing in both:

| How the request was filled | Who holds `c` | Result |
|---|---|---|
| `Issued(c)` | this program (it asked its own device) | `Fresh`, only for the reply that call returned; `RpBound(bind)` when `c` was issued with `bind` |
| `Verbatim(challenge_with_key(challenge_value(c), kem, kp.sk))` on the attester | the relying party that issued `c` | `Fresh` and `KeyBound(kem, pk)` from the key-bound verifier |
| `Verbatim(challenge_with_channel(challenge_value(c), e))` on the attester, over its own connection | the relying party that issued `c`, over the other end of that connection | `Fresh` and `ChannelBound` from the channel-bound verifier |
| `Verbatim(challenge_value(c))` on the attester | the relying party that issued `c` | `Fresh` for the relying party |
| a record from `challenge_import(token, k, store)` (labels §6.8) | any process of the verifier that holds the export key | `Fresh`, with the `SpentStore` instance and the export key's source listed as reliances by `residc verify` |
| a `ReplayableRecord` from `challenge_import_unspent`, through a `_replayable` verifier | any process holding the key | `Delivered`: may be replayed within its lifetime, never satisfies a decision |
| `Runtime`, or `Verbatim(x)` with no record held | no one | not checkable: never `Fresh` |
| certified counter (§8) | — | `Fresh`, as the counter's signer |

A mismatch is an error value; there is no partial acceptance.

Why a record issued inside the guest gives `Fresh` under `in-guest`: the
evidence is already only as good as the measured guest kernel (§1), and
the record's nonce comes from that kernel mixed with the CPU source when
present (labels §6.6). A replay or substitution by the host fails the
challenge check; the residual reliance is the kernel the evidence
already names, and the anchor's `principal` says so. A relying party's
record comes from its own machine.

Under `above-kernel` (phase A6) the guest kernel is outside the evidence,
so a record issued inside the guest is accepted only when a CPU source
the profile vouches for contributed (recorded in the record); otherwise
the verifier refuses it (a refusal, never a weaker result, §2) and the
program needs a relying party's value or a counter. Decided in phase
A6.

### 6.2 Shipping evidence

A guest that proves itself to a relying party receives the party's
`challenge_value(c)`, sends its device request with
`Verbatim(challenge_with_key(value, kem, kp.sk))` for a key pair it
generated, and
returns the report bytes and the public key. The relying party calls
`snp_verify_key_bound(report, c, anchor, collateral, t, kem, pk)`.
Nothing but the report and the public key crosses back: the record never
leaves the program that issued it (unless exported, labels §6.8). The
guest computes the binding from its own key pair, so a party in the
middle that forwards the challenge to another genuine guest gets an
answer bound to that guest's key, which it cannot use.

**What `KeyBound` proves**: that a process in the measured image, holding
the private key, asked for the report. It binds the *image*, not one
process: any process in that image that can open the device could bind a
key it generated. Inside a Resid program `challenge_with_key` binds only
the public key of an own `sk`, one the program drew itself or the
platform derived for it, never one it agreed with a peer (labels §5.2,
§6.5), and reaching the
device needs the `device` capability; what other programs in the image
may do is the image's to restrict, and the reference values that admit
the image (§4) admit that choice.

### 6.3 Single use

- **At run time**: `bind_challenge` marks the record accepted in runtime
  state no program can name, atomically for the whole process (labels
  §6.5); a second bind of the same record fails. A decision's success
  return also marks its gate's record decided, and a second success
  return with the same gate fails, so the run-time check does not rest
  on the compiler's.
- **At compile time**: a `Fresh`-marked value reaches at most one
  `@decides` on every path (E-fresh-reuse), counting each loop iteration,
  each spawn region it is copied into, and each call of a closure that
  captured it. The compiler checks this with its internal linearity
  analysis; the programmer writes no `Linear`.
- `Delivered` never satisfies a `@decides`, except one written
  `fresh = false` (§5.1).

## 7. Identity and relay

A genuine machine can be asked our nonce and its answer relayed.
Freshness does not prove identity.

A decision requires one of these by default (§5.1).

- **Key bound** (`KeyBound(kem, pk)`, `identity = key_bound`): the
  attester bound its own key pair into the challenge (§6.2), and the
  decision releases only through `seal_to_evidence`, so only the holder
  of the attested key can open the answer.
- **Channel bound** (`ChannelBound`, `identity = channel_bound`): the
  attester puts `challenge_with_channel(value, e)` in the slot, with `e`
  taken from its own TLS connection, and the relying party verifies with
  the `_channel_bound` form and the `ChannelExporter` of its end of the
  connection the decision answers on (§3.2). The two ends of one TLS
  connection share an exporter and the two connections of a party in the
  middle do not, so the attested principal is the TLS endpoint. The
  decision releases only through `seal_to_channel`, whose result can be
  written only on that connection (§3.2). The attester's TLS must
  terminate inside the measured image.
- **Local** (`Local`, `@decides(identity = local)`): produced only by `aead_open`
  under a key from `platform_key` (`Verified`), over a blob whose
  plaintext carries the measurement this program sealed earlier. A key
  the platform derives is External on arrival (the kernel can substitute
  it); `platform_key` (§3.2) accepts it as `Verified(Key,
  PlatformDerived(selector, principal))`, so the reliance on the
  measured kernel (`InGuest`) is in the type, and `aead_open` under that
  key yields `Local`. A program with neither path cannot satisfy `local`.
  `Local` alone is not `Fresh` (an old sealed blob opens as well as a new
  one), so a local decision's gate is `bind_counter(opened, counter)`
  (§3.2): the blob's version must equal a fresh certified counter read
  (§8). A platform without a `Counter` instance (§10) cannot make local
  decisions; it can still use a relying party.
- Never by comparing a report with a self-measurement read through the
  kernel (circular).

## 8. Rollback

- Sealed data carries its version inside the authenticated plaintext,
  together with the **identity of the counter** that guards it (the TPM's
  EK or AK name, and the NV index name, which commits to its type and
  attributes), pinned at first seal and compared on every read.
- The latest version comes from a counter read with `NV_Certify` (its
  `qualifyingData` a challenge field filled with `Issued(c)`, since a
  `Runtime` value is never `Fresh`), signed
  by an AK that is restricted, signing, fixedTPM and fixedParent, and
  whose attestation structure has `magic == TPM_GENERATED`; or from the
  relying party.
- **First seal** (no prior state) is a distinct outcome that `@decides`
  must accept explicitly, through a remote party or a certified counter at
  its initial value; a missing blob is never silently "empty".
- Stated residual risks: a counter relayed from another TPM (bounded by
  the pinned EK name); cloud vTPMs whose state the host holds give no
  rollback protection, and their `Counter` instance does not exist.

## 9. The transcript

- A running hash of every channel crossing, written ahead (the request is
  recorded before the helper starts): site, challenge record, direction, and
  the canonical serialization of the format's **public** fields. Pointers
  and padding are excluded. Secret fields are left out (their position
  and length are recorded): a commitment to a low-entropy secret could be
  brute-forced. Publishing the transcript is a recorded declassification.
- An aborted child region's partial hash is folded into its parent with
  an abort marker.
- A bounded log (sites, counters, digests) is kept beside the hash so a
  relying party can check it.
- `transcript()` returns **External**: it is a commitment to what the
  program saw, not an endorsement, and it lives in memory the kernel can
  write.
- Off unless a program calls `transcript()` (the compiler sees the call),
  so device code that never ships evidence pays nothing.

## 10. Device behaviors and platform contracts

Attestation code is written against these behaviors; the device plan
provides the channels their instances call.

```resid
behavior ReportSource(P) {
    Result(SignedReport(P), DeviceError) report(Challenge(64) challenge = Runtime);
}
behavior SealingKey(P) {
    Result(External(Secret(Key)), DeviceError) derive(KeySelector(P) k);
}
behavior Counter(P) {
    Result(SignedCounter(P), DeviceError) read(Challenge(32) challenge = Runtime);
}
```

The defaulted `challenge` gives callers the optional `challenge =`
argument (labels §6.3): `src.report()` fills the slot with a value no one
keeps; `src.report(challenge = Issued(c))` lets the holder of `c` verify.

| Channel | Signed below the guest kernel | Proven by use | Never verifiable |
|---|---|---|---|
| sev-guest report / ext report | report (VCEK or VLEK), challenge in `report_data` | — | certificate table until chain-verified, `exitinfo2`, errno |
| sev-guest derived key | — | `platform_key` (`principal = InGuest`), then `aead_open` of data this measurement sealed | the key on arrival |
| tdx-guest report0 | MAC'd TDREPORT (checkable on the platform with TDX 1.5 `TDG.MR.VERIFYREPORT`) | — | — |
| configfs TSM report | outblob (SNP report, TDX quote, CCA token), challenge via `inblob` | — | provider, generation, auxblob until chain-verified |
| TPM | Quote and NV_Certify with challenge in `qualifyingData`, by a verified AK | — | GetCapability, PCR_Read, NV_Read, GetRandom |
| NSM | attestation document with challenge in `nonce`; `timestamp` as signed time | — | other responses |
| NVIDIA (SPDM) | measurements under a signed transcript with the requester nonce | — | handles, driver version |

- **`KeySelector(Snp)` is typed, not an integer.** It always includes the
  `policy` and `measurement` bits (or `policy`, `image_id`, `family_id`,
  `guest_svn` with a verified `ID_KEY_DIGEST` pinned to a `Known` author
  key, for images updated through the ID block); the root is the VCEK
  unless a `@decides` explicitly accepts the migration agent's root;
  `tcb_version` is the current committed TCB. Without the policy bit, a
  host could relaunch the image with debugging enabled and derive the
  same key.
- **Platforms without an instance** do not get one, and code that needs it
  does not compile for them: no `SealingKey` on TDX, CCA (RMM 1.0) or
  Nitro (which uses KMS with an attestation document); no `Counter` on SNP,
  TDX or CCA unless a hardware TPM is pinned by EK name, and none on
  host-held cloud vTPMs.
- **VMPL and SVSM.** Request fields such as `vmpl` are only what we asked;
  appraisal checks the report's own `VMPL` field and the SVSM service
  manifest (§4).
- **Live migration** with VCEK-rooted keys loses sealed data; the
  migration-agent root keeps it at the cost of trusting the agent. The
  `KeySelector` makes the choice explicit.
- **TPM sessions.** Sessions are salted and bound to the EK (or a pinned
  AK), so the TPM authenticates the attributes the dictionary-attack
  refusal relies on; attributes read without such a session are External
  and cannot justify sending an authorization.
- **NVIDIA.** GPU evidence is bound to the CPU instance through an SPDM
  session whose key exchange the device certificate signs, run by the
  attested principal; checks include confidential-computing mode, RIMs
  (through NRAS's signed token) and OCSP.
- **Unverifiable outputs only steer.** `provider` and driver version
  select among verifiers or formats that are each sound on any input; the
  accepted platform set is pinned per deployment in `@decides`.

## 11. Knowledge and reviewed base

Anchors, primitives, appraisal policies, `assume` sites, `@decides`
functions and freshness bindings are graph nodes. `residc verify` adds,
to labels §10: every anchor with its origin; every assumption; every
`declassify` with its robustness and every allowlisted site;
`@decides` functions with their requirements, `identity = none` ones
marked, and those written `appraised = none` or `fresh = false`;
replayable (`Delivered`) call sites; the `provisioned_release`,
`control_anchors` and `robust_exempt` entries; the binary's hash for
reference values (§4); and the hashes of the verify closure and the
runtime (§3.2).

The reviewed base adds `lib/verify/` primitives and appraisals (each with
parity tests against a reference verifier), the anchors and their
origins, and the robust-declassification allowlist.

## 12. Phases

A1. Integrity levels, anchors (identity, kinds, formats), primitives,
    signer-claim binding, time sources and collateral floors, pinned
    `assume`; `@decides` with its gate, input rule and identity default;
    control summaries; robust declassification. Each error a warning for one
    phase first, with its mistakes corpus (labels §4.6).
A2. Appraisal and reference values; EAR output.
A3. Freshness: `bind_challenge`, the call-form table, single use (runtime and
    E-fresh-reuse, decided marks), shipping evidence; identity
    (`KeyBound` with `challenge_with_key` and `seal_to_evidence`,
    `ChannelBound` with `challenge_with_channel`, `seal_to_channel` and
    the TLS exporter, `Local`); rollback; the transcript.
A4. Device behaviors and platform instances (private attestation
    library); TPM sessions; NVIDIA.
A5. User-facing `Linear` and typestate, if still wanted (§14).
A6. The `above-kernel` profile.

Needs labels phases 1–3. Each phase lands with conformance tests for
every error it introduces, a `SECURITY.md` row per guarantee, and a deep
security review before merge.

## 13. Holes considered

| Attack or failure | Closed by | Residual risk |
|---|---|---|
| Implementer skips verification | only primitives build `Verified` (§3.2) | none in the type system |
| Decision body ignores a failed verification | the gate: every success return passes through a primitive's `Ok` (§5.1) | none |
| Internal value standing in for evidence | only a primitive's result forms a gate; Internal is neutral in joins (§2, §5.1) | none |
| Attacker chooses which value is released | inputs that reach or select the result must not be External, checked at callers (§5.1) | none |
| Validly signed but unacceptable evidence (debug, old TCB, VMPL, MA) | `Appraised` with mandatory checks (§4) | reference values must be right |
| Trusting requester- or host-chosen signed fields | field origin (§3.3) | none |
| Old-TCB signing key forging current claims | signer-claim binding (§3.2) | none |
| Verifying bytes the signature does not cover; parser differentials | raw signed spans, format identity, unambiguous parsers (§3.3) | formats outside the supported layouts |
| Replay or substitution by the host | runtime challenge carried and bound (§6.1) | the measured guest kernel (`in-guest`), stated in the type |
| Replay within the process | atomic accepted and decided marks in the runtime, E-fresh-reuse over loops, regions and closures (§6.3) | none |
| Stale challenge answered late | record lifetime (labels §6.5, §6.1) | within the lifetime |
| Answer replayed to another process of a multi-process verifier | exported records accepted only through an atomic `SpentStore`; without one, `Delivered` (labels §6.8, §6.1) | the store's correctness and rollback, listed |
| Exported challenge minted by an outsider | sealed under the export key (labels §6.8); in a TEE, a key only the attested verifier holds | outside a TEE, whoever provisioned the key, listed |
| Replay toward a relying party | its own record, sent as `Verbatim` (§6.1–6.2) | none |
| Kernel picks local randomness or hides RDSEED | `in-guest` already relies on that kernel; `above-kernel` needs a CPU source or an RP nonce (§6.1) | `in-guest` reliance, stated |
| Relay to another genuine machine | identity required by default: `KeyBound` (attester binds its own key, release sealed to it), `ChannelBound` (attester binds its own connection's exporter), or `Local` (§5.1, §6.2, §7) | decisions marked `identity = none`, listed by `residc verify` |
| Rollback | versioned sealed data, pinned counter identity, explicit first seal (§8) | host-held vTPMs |
| Old collateral, rolled-back clock | `Known` floors, time sources (§3.4) | absolute time without an RP |
| Confused deputy across anchors or kinds (VCEK vs VLEK) | anchors named by function, kinds checked by primitives, `accept` ⊆, `require` all-of (§3.1, §5.1) | none |
| A dependency declares an anchor of a trusted kind over its own root | `accept` names anchor functions, not kinds (§3.1) | none |
| Signed bytes reparsed under a type with false field origins | anchor `formats`, own-package types only (§3.1, §3.3) | none |
| Appraisal under a policy built at run time | policy argument must be a `@policy` call (§4) | none |
| Weak algorithm | per-level algorithm lists (§3.1) | none |
| Attacker chooses what is declassified | robust declassification (§5.2) | reviewed allowlist |
| Wrapper, closure or early exit hides who triggers a disclosure | control summaries counting every exit except process end, E-control at the caller (§5.4) | none |
| "Proof by use" with a substituted or constant key | `aead_open` result follows key integrity and unpredictability (§3.2) | none |
| Laundering through `assume` | capability family, symbol anchors, a pin on every assumption, refused in lib (§3.6) | reviewed use |
| Laundering through `@decides` results | decisions never raise integrity (§5.1) | none |
| Application redefines an instance `lib/verify` uses | instance pinning (§3.2) | none |
| Transcript leaks or launders | External, public fields only, Secret fields left out (§9) | kernel memory writes |
| Kernel forges a derived key | predictable on arrival, so E-key (labels §5.2) refuses it; only `platform_key` accepts it, naming the principal | the measured guest kernel |
| Program claims hold for a binary outside the measurement | reference values computed over an image containing the binary; `residc verify` prints its hash (§4) | a deployment that ignores this |
| Host derives the same key after relaunching with debug | typed `KeySelector` with mandatory policy and measurement bits (§10) | none |
| TPM attributes forged to extract an authorization | EK-bound sessions (§10) | none |
| Another guest's report presented as this program's own device answer | `Issued` records are reply-bound (labels §6.5, §6.1) | a malicious measured kernel (`in-guest`) |
| Kernel's key accepted through a relayed report | `platform_key` needs a fresh, reply-bound, consumed `Issued` gate (§3.2) | the measured guest kernel |
| A process binds an attacker's public key into a report | `challenge_with_key` derives the public key from an `sk` that passes E-key (labels §6.5) | other programs in the image, admitted by reference values (§6.2) |
| Dependency anchor or replayed approval authorizes a disclosure | trusted for control needs `Fresh` and anchors named in `[labels] control_anchors` (§5.2) | none |
| Local decision on an old sealed blob | `bind_counter` with a fresh certified counter (§3.2, §7) | platforms without a counter cannot decide locally |
| Channel binding and challenge competing for one field | the exporter is hashed into the challenge value (`challenge_with_channel`, §3.2, §7) | none |
| Party in the middle relays a channel-bound challenge | the attester binds its own connection's exporter, which differs from the relying party's connection to the middle (§3.2, §7) | none |
| Peer of an agreed key steers a decision with `Aead(Self)` plaintext | `Aead(Self)` only under keys from this process's random source (§3.2) | none |
| Released key cannot be supplied at all | unpredictable Secrets from random, platform or provisioned sources are exempt from the input rule; their selection is not (§5.1) | the provisioner, listed |
| Key released to an unappraised image | `appraised` is required on every decision; `appraised = none` is written and listed (§5.1) | decisions marked `appraised = none` |
| Key agreed with an attacker bound into a report or used as export key | `@key(own)` on `challenge_with_key`, own or provisioned on `export_key` (labels §5.2) | none |
| Channel-bound release written to another connection | `seal_to_channel` and bound sends refusing a different exporter; control trust limited to disclosures to the gate's identity (§3.2, §5.1, §5.2) | none |
| Request-chosen key released through the exemption | only listed `provisioned_release` sites, and every other operand non-External (§5.1) | the listed provisioning sites |
| Key derived without the measurement passed off as platform-derived | `platform_key` derives the key itself from the typed selector and applies the mandatory checks (§3.2) | the measured guest kernel |
| Substituted runtime supplying a no-op mark or a constant nonce | runtime hashes pinned with the verify closure; `-rtr`/`-rt` refused for programs reaching it (§3.2) | `--verify-lib-dev` builds, recorded |
| Host seals a key of its choosing to the attester's public key | `seal_to_evidence` uses HPKE Auth mode; the attester accepts only through `open_released` with a pinned `ReleaseSender` anchor (§3.2) | the releaser's sender key |
| A runtime-built opaque value forged through a layout field | labels §7.2 rule 6 lists every opaque type of both plans | none |
| Stale member made fresh by its bound set | freshness is per member (§3.5) | none |
| A random key disclosed, then used to vouch for plaintext as `Aead(Self)` | `Aead(Self)` needs an own key, never disclosed (§3.2, labels §5.2) | none |
| A `Local` gate authorizing a disclosure to a network peer | `Local` controls only disclosures into this program's own sealed state (§5.2) | none |
| `platform_key` unusable for want of a self-appraisal | it needs a `Verified` report, the mandatory checks and a measurement-mixing selector, no reference value (§3.2) | none |
| Qualifier weakened by a run-time value | qualifiers fixed by signature; run-time conditions refuse (§2, §3.2) | none |
| Program forges an `EvidenceTime` (a past time, a false source) | opaque, built only by `kernel_time()` and signed-time primitives (§3.2) | none |
| Record issued for one protocol satisfies another's decision | `@decides(bind = …)`, required once a program uses several binds (§5.1) | none |
| Expired certificate accepted for lack of a time | every platform verifier takes an `EvidenceTime` (§3.2, §3.4) | the kernel clock unless `time = not_kernel` |
| `require` met by joining unrelated evidence | the gate is one bound evidence set (§3.5, §5.1) | none |
| Substituted `lib/verify/` or a library it imports under `RESID_HOME` | the compiler refuses a verify closure whose hashes differ from its release (§3.2) | `--verify-lib-dev` builds, recorded |
| Compiler, runtime or primitive bug | reviewed base (§11) | inherent |

## 14. Review findings of labels revision 2 and where they are now

Information flow: begin labels and closures replaced by control summaries
§5.4 (confidentiality cannot reach control flow, labels §4.3); relayed fields
§3.3; proof-by-use key integrity §3.2; keys as unpredictable values labels §5.2;
`@decides` anchors, results, body, concrete accept §5.1; relay `Local`
§7; robust declassification §5.2; exits (only process end exempt) §5.4,
selection labels §4.3, dispatch labels §4.1; total source table labels §4.1; label
polymorphism and casts labels §4.4, §4.2; receipts and tickets replaced by
the runtime nonce and challenge records labels §6, §6.3 here; transcript §9;
full-label pc replaced by control summaries §5.4; effects, facts, hash-consing labels §3; spawn
tags labels §4.2; `Linear` completeness: no user-facing `Linear` (labels
§6.7, here §6.3); Secret layout checks labels §5.4; format identity §3.3;
conformance variance labels §4.7, §5.3 here; anchor and assumption
identity §3.1, §3.6; time and CRL marking §3.4; MAC key identity §3.2;
stdlib root hashing and instance pinning §3.2.

Attestation: attesting principal and profiles §1; derived keys and proof
by use §3.2, §7; key selectors §10; channel binding §3.2, §7; appraisal
and field origin §4, §3.3; signer-claim binding §3.2; challenge values labels
§6.2, `bind_key`, signed transcripts §3.2; collateral floors and time
§3.4; TCB comparison §3.2; TDX quote, SNP, NSM parity §3.2; counter
identity and first seal §8; event-log replay §3.2; transcript labels §9;
anchor rotation §3.1; raw spans and unambiguous parsers §3.3; all-of
anchors and bound evidence sets §5.1, §3.5; GPU binding §10; reference
values §4; platforms without sealing keys §10; VMPL §4, §10; provider
steering §10; `Fresh` consumed by one decision §6.3; SNP layout details
§3.3.

Runtime: `Fresh` and local randomness §6.1, labels §6.6; effect classes
(device plan R2.3); core dumps labels §1.4; bleaching labels §7.4; wire
format and secret fields per field (device plan R2.2); layout cases and
capacity labels §7.2; transcript §9; foreign code as native modules labels §9;
helper wiping labels §7.4; fixed-length byte type labels §7.1; challenge
linkage and values labels §6.2; residual re-check labels §4.5; RDSEED
mechanics labels §6.6; parser memory labels §7.2; NVIDIA multi-fd and
versions (device plan R2.6); timeouts labels §6.2.

## 15. Decisions and open questions

Settled (2026-10-10, carried from labels revision 2 or decided for this
split):

1. `in-guest` profile now; `above-kernel` is phase A6.
2. `Delivered` never satisfies a `@decides`, except one written
   `fresh = false`.
3. Anchors are rebuild-only; a signed anchor-set update, paired with the
   SNP ID-block path for sealed data, is a later revision.
4. Freshness comes from a `ChallengeRecord` the verifier holds: `Issued(c)`
   on its own device (`Fresh` under `in-guest`), or `Verbatim` of its value
   on someone else's; `Runtime` is never `Fresh`. One `snp_verify` serves
   both; there is no `Reply` wrapper.
5. No user-facing tickets, receipts or `Linear`; single use of `Fresh` is
   a runtime accepted mark, a runtime decided mark, and E-fresh-reuse.
   Typestate is phase A5, if wanted.
6. Whether code runs is checked only for robust `declassify`, through
   per-parameter control summaries that count every exit except the end
   of the process, reported as data flow; there are no begin labels.
7. `@decides` takes only `key = value` arguments: `require`, `accept`
   (anchor functions), `appraised`, `identity = channel_bound |
   key_bound | local | none`, `time = not_kernel`, `fresh = false`,
   `bind`.
8. A decision has a gate: every success return passes through the `Ok`
   of one primitive call whose result meets the requirements. Other
   inputs that reach or select the result must not be External.
9. Identity is required by default; `identity = none` is written and
   listed.
10. Anchors are identified by function and fingerprint; kinds are checked
    by primitives; `formats` limits which `@signed` types an anchor
    verifies.
11. Every assumption pins the value it vouches for.
12. Unverifiable outputs may choose which primitive forms a gate, and
    nothing else in a decision.
13. A record imported with a `SpentStore` gives `Fresh` with the store and
    the export key listed as reliances; one imported without a store gives
    `Delivered`.
14. Qualifiers are static: each verifier has a plain, a key-bound, a
    channel-bound and a replayable form, and a run-time condition that
    fails is a refusal.
15. Every platform verifier takes an `EvidenceTime`.
16. Channel binding hashes the attester's own TLS exporter into the
    challenge value (`challenge_with_channel`); local decisions gate on
    `bind_counter`; a gate is one bound evidence set, and freshness is
    per member.
17. Control and robustness trust only fresh evidence from anchors the
    application names in `[labels] control_anchors`.
18. `platform_key` requires a `Verified`, fresh, reply-bound `Issued`
    report and a selector that mixes in the measurement; no appraisal.
19. The compiler refuses a verify closure (`lib/verify/` and everything
    it imports) whose hashes differ from its release set.
20. `Aead(Self)` only under keys from this process's random source.
21. Unpredictable Secrets from random, platform or provisioned sources
    are exempt from E-decides-input; their selection is not.
22. `fresh = false` is the one listed way to decide on reusable
    evidence; such a decision is never trusted for control.
23. `appraised` is required on every decision except `identity =
    local`; `appraised = none` is written and listed.
24. Robustness stays over every disclosure, not only of values whose own
    integrity is External: narrowing it would let outside data decide
    whether an Internal secret is disclosed (the §5.4 example). The
    burden is met by the standard library's allowlisted publication
    sites and `robust_exempt`, both listed.
25. A `channel_bound` decision releases only through `seal_to_channel`,
    and identity-bound evidence is trusted for control only over
    disclosures to its own identity.
26. `platform_key` derives the key itself and applies the platform's
    mandatory checks.
27. The runtime is pinned with the verify closure.
28. The input-rule exemption takes `provisioned_key` only at sites listed
    in `[labels] provisioned_release`.
29. Releases are sealed in HPKE Auth mode under the releaser's sender
    key, and attesters open them only with `open_released` against a
    pinned `ReleaseSender` anchor.
30. `EvidenceTime` is opaque; decisions may require a `bind`.

Open:

1. Does `above-kernel` trust RDSEED/RNDR on SNP (where the hypervisor can
   intercept them unless the guest policy forbids it) for `Fresh`?

## Appendix B. Worked example: a key broker and an SNP guest

Every name below is either in the repository today, defined in a plan
section (cited), or defined in this appendix. The guest proves itself to
a key broker, which releases a key only for fresh, appraised evidence,
and only to the key the evidence attests. The network between them is
left out: the guest receives the broker's challenge bytes and returns its
report bytes and public key; the broker returns a sealed message.

**B.1 The guest** (device access, the HPKE library and `lib/challenge`;
the device plan's R2 Appendix A gives `snp_report`):

```resid
import "dev/sev_guest.resid";
import "challenge.resid";
import "hpke.resid";
import "hpkeg.resid";
import "verify/seal.resid";

// The broker's HPKE sender key, pinned by this deployment (§3.1).
@anchor(kind = ReleaseSender(32), formats = [], source = "the broker's deployment",
        fingerprint = "sha256:…", retrieved = "2026-10-01", reviewed_by = "…",
        algorithms = [DhkemX25519], expires = "2027-10-01")
Anchor broker_sender() { return anchor_der(broker_sender_der()); }

// One key pair per attestation; the private key never leaves this process.
// Publishing the public key is a declassification inside the HPKE library.
@requires(declassify)
pub HpkeKeyPairG(Secret(UInt(8))) new_key() { return hpkeg_generate_keypair(32); }

// The broker's challenge, bound to this guest's own public key, so an
// answer relayed from another guest is bound to that guest's key instead.
@requires(device(readonly), declassify)
pub Result(List(UInt(8)), DeviceError) evidence(List(UInt(8)) broker_challenge,
                                                HpkeKeyPairG(Secret(UInt(8))) kp) {
    List(UInt(8)) bound = challenge_with_key(broker_challenge, 32, kp.sk)?;
    SnpReportResp r = snp_report(challenge = Verbatim(bound))?;
    return Ok(r.report);
}

// The released key, opened with the private key the report attests, and
// accepted only if the pinned broker sealed it.
@requires(declassify)
pub Result(List(Secret(UInt(8))), VerifyError) receive(HpkeKeyPairG(Secret(UInt(8))) kp,
                                                       HpkeMessage msg) {
    return open_released(32, kp.sk, msg, broker_sender());
}
```

**B.2 What `lib/verify/` provides** (signatures from §3.2 and §4;
bodies are the library's):

```resid
// lib/verify/amd_anchors.resid
@anchor(kind = AmdVcek(Genoa), principal = InGuest, formats = [SnpReport],
        source = "https://kdsintf.amd.com/vcek/v1/Genoa/cert_chain",
        fingerprint = "sha384:…", retrieved = "2026-10-01", reviewed_by = "…",
        algorithms = [RsaPss4096Sha384, EcdsaP384Sha384],   // root first
        expires = "2045-01-01")
pub Anchor amd_ark_genoa() { return anchor_der(amd_ark_genoa_der()); }

// lib/verify/snp.resid
@layout(c_abi) @signed(sig = signature, span = 0x000..0x2A0)
pub type SnpReport = { ... };                                  // §3.3

type SnpCollateral = { List(UInt(8)) vcek_der; List(UInt(8)) ask_der; List(UInt(8)) crl_der; };
type TcbVersion = { Int bootloader; Int tee; Int snp; Int microcode; };
type SnpPolicy = { TcbVersion min_tcb; List(Str) measurements_hex; Int vmpl;
                   Bool allow_migration_agent; List(Str) id_key_digests_hex;
                   List(Str) host_data_hex; };

type TimeSource = RelyingParty | SignedEvidence | Kernel;
type EvidenceTime;                       // builtin, opaque (§3.2)
@requires(clock(readonly)) pub EvidenceTime kernel_time() { ... }

@primitive pub Result(Verified(SnpReport), VerifyError)
    snp_verify_key_bound(List(UInt(8)) report, ChallengeRecord c, Anchor root, SnpCollateral col,
                         EvidenceTime t, Int kem, List(Int) pk) { ... }
@primitive pub Result(Appraised(SnpReport, P), VerifyError)
    snp_appraise(Verified(SnpReport) v, SnpPolicy policy) { ... }

// lib/verify/seal.resid: the KEM the guest chose, HKDF-SHA256, AES-128-GCM
pub HpkeSuite seal_to_evidence_suite(Int kem) { return hpke_suite(kem, 1, 1); }
pub List(Int) seal_to_evidence_info() { return bytes_of("resid.seal_to_evidence.v1"); }
@primitive @requires(declassify) pub Result(HpkeMessage, VerifyError)
    seal_to_evidence(Appraised(T, P) e, Int kem, List(Int) pk, List(Secret(UInt(8))) value,
                     List(Secret(UInt(8))) sender) { ... }
@primitive @requires(declassify) pub Result(Verified(List(Secret(UInt(8)))), VerifyError)
    open_released(Int kem, List(Secret(UInt(8))) sk, HpkeMessage msg, Anchor sender) { ... }
```

**B.3 The broker** (application code):

```resid
import "hpke.resid";
import "verify/amd_anchors.resid";
import "verify/snp.resid";
import "verify/seal.resid";

// The deployment's acceptance rule, a Known value (§4).
@policy
SnpPolicy release_policy() {
    return SnpPolicy {.min_tcb = TcbVersion {.bootloader = 3, .tee = 0, .snp = 8, .microcode = 115},
                      .measurements_hex = ["5c1f…e0"],
                      .vmpl = 0,
                      .allow_migration_agent = false,
                      .id_key_digests_hex = [],
                      .host_data_hex = []};
}

// Step 1: a fresh challenge from the runtime (labels §6.5); the broker
// sends challenge_value(issued) to the guest and keeps `issued`.
ChallengeRecord new_challenge() { return challenge_issue(64); }

// Step 2: the decision. The gate is snp_appraise's Ok; Fresh is required
// by default, and key_bound means the key leaves only sealed to the
// public key the report carries (§5.1, §7).
@decides(accept = [amd_ark_genoa], appraised = release_policy, identity = key_bound)
@requires(declassify, clock(readonly))
pub Result(HpkeMessage, VerifyError) release(List(UInt(8)) report, ChallengeRecord issued,
                                             SnpCollateral col, List(Int) guest_pk,
                                             List(Secret(UInt(8))) key,
                                             List(Secret(UInt(8))) sender) {
    Verified(SnpReport) v = snp_verify_key_bound(report, issued, amd_ark_genoa(), col,
                                                 kernel_time(), 32, guest_pk)?;
    Appraised(SnpReport, release_policy) a = snp_appraise(v, release_policy())?;
    return seal_to_evidence(a, 32, guest_pk, key, sender);
}
```

What the compiler checks in `release`: every success return passes
through `snp_appraise`'s `Ok` (the gate); the gate's anchors are
`{amd_ark_genoa}`, its policy is `release_policy`, it is `Fresh` and
`KeyBound(32, guest_pk)`; the certificate times were checked against
the broker's kernel clock (allowed: the decision does not say `time =
not_kernel`); the success return is `seal_to_evidence` on the
gate; `report`, `issued`, `col` and `guest_pk` are External but go only
into primitives; and at every caller, the argument for `key` must be
fully unpredictable from `random_secret`, `platform_key` or a
listed `provisioned_release` site, or not External (§5.1), and never
selected by or derived with External data; the argument for `sender`
must be own or provisioned (labels §5.2). On the guest, `receive`
accepts only a message the pinned broker sealed, and its result can key
a primitive on the broker's word.

**Where each name comes from:**

| Name | Source |
|---|---|
| `Result`, `Ok`, `Option`, `List`, `UInt`, `Str`, `Int`, `Bool`, `?`, `import`, `@requires`, `Secret`, `declassify`, `bytes_of` | the language and standard library today |
| `DeviceError`, `device(readonly)` | today (`lib/dev/device.resid`, capabilities) |
| `HpkeMessage`, `HpkeSuite`, `hpke_suite` | today (`lib/hpke.resid`, `lib/hpkeg.resid`) |
| `HpkeKeyPairG`, `hpkeg_generate_keypair` | today (`lib/hpkeg.resid`) |
| `snp_report`, `SnpReportResp`, `Challenge`, `Verbatim` | labels §6.1–6.3, device plan R2 Appendix A |
| `ChallengeRecord`, `challenge_issue`, `challenge_value`, `challenge_with_key` | labels §6.5 |
| `@anchor`, `Anchor`, `anchor_der`, `AmdVcek`, `ReleaseSender`, `InGuest`, `formats` | §3.1 |
| `DhkemX25519` | the anchor algorithm name for RFC 9180 KEM 32 (§3.1's per-anchor `algorithms`) |
| `@primitive`, `Verified`, `VerifyError` | §3.2 |
| `@layout`, `@signed`, `SnpReport` | labels §7.1, §3.3 |
| `@policy`, `Appraised`, `SnpPolicy`, `TcbVersion` | §4 |
| `snp_verify_key_bound`, `snp_appraise`, `SnpCollateral`, `seal_to_evidence`, `open_released`, `EvidenceTime`, `TimeSource`, `kernel_time` | §3.2, §6.1 |
| `seal_to_evidence_suite`, `seal_to_evidence_info` | B.2 |
| `@decides`, `accept`, `appraised`, `identity`, `key_bound` | §5.1 |
| `amd_ark_genoa_der` | the library's embedded certificate bytes (B.2) |
| `broker_sender_der` | the deployment's embedded copy of the broker's HPKE sender public key, DER (RFC 8410) |
| `new_key`, `evidence`, `broker_sender`, `receive`, `release_policy`, `new_challenge`, `release` | this appendix |

The `Verified(…)` and `Appraised(…)` types on the two bindings are
optional; they are inferred, and written here only to show what the
compiler knows at each step.
