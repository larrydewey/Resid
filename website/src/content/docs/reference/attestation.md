---
title: Attestation
description: One verifier for every platform's evidence, trust sets, bindings, claims, policies, and decisions that say whose word they rest on.
---

A program that acts on remote attestation evidence verifies it with one
call and appraises it with another, whatever the platform: an AMD SEV-SNP
report, an Intel TDX quote, an Arm CCA token, an AWS Nitro Enclaves
document, a TPM 2.0 quote or a device's SPDM measurements. It marks the
function that releases something with `@decides`, and the compiler checks
that the release cannot happen without fresh, verified, appraised evidence
from the roots the decision names. The design is `PLAN-attestation.md` in
the repository; this page describes what is implemented.

## In one page

The attester (`lib/attester.resid`) finds its platform and returns an
evidence envelope; it never names the platform:

```text
@requires(device, declassify)
Result(List(UInt(8)), DeviceError) answer(List(UInt(8)) challenge, List(Secret(UInt(8))) sk) {
    List(UInt(8)) bound = challenge_with_key(challenge, 32, sk)?;    // bind our HPKE key
    return attest(challenge = Verbatim(bound));
}
```

The verifier (`lib/verify/verifier.resid`) checks it, whatever it is, and
releases a key to the attested key alone:

```text
@policy
Policy release_policy() {
    return Policy {.measurements = ["5c1f…e0", "a7d3…19"],      // our image, built for SNP and for TDX
                   .require = ["committed_tcb.snp>=8"],
                   .allow = []};
}

@decides(accept = [vendor_roots], appraised = release_policy, identity = key_bound)
@requires(declassify, clock(readonly))
Result(HpkeMessage, VerifyError) release(List(UInt(8)) evidence, ChallengeRecord issued, List(Int) guest_pk,
                                         List(Secret(UInt(8))) key, List(Secret(UInt(8))) sender) {
    Verified(Claims) v = verify_evidence(evidence, issued, bind_key(32, guest_pk), vendor_roots(), kernel_time())?;
    Appraised(Claims) a = appraise_evidence(v, release_policy())?;
    return seal_to_evidence(a, 32, guest_pk, key, sender);
}
```

`issued` is the record the verifier made with `challenge_issue(64)` and
sent as `challenge_value(issued)`. Everything platform-specific -- the
vendor's certificate chain and revocation, the report's layout, which
field carries the challenge, the platform's own appraisal rules -- is the
verifier's business.

## Evidence

Evidence travels as an envelope (`lib/evidence.resid`): an IETF RATS CMW
(draft-ietf-rats-msg-wrap, CBOR form; `lib/cmw.resid`) collection with the
platform's evidence under `evidence` and, optionally, a list of collateral
under `collateral`. The platform is named by the evidence's media type
(`mt_snp_report()`, `mt_tdx_quote()`, `mt_cca_token()`,
`mt_nitro_document()`) or collection type (`ct_tpm_quote()`,
`ct_spdm_measurements()`, `ct_spdm_challenge()`).

Collateral is what builds the chain to a root: certificates
(`mt_cert()`), CRLs (`mt_crl()`), PEM chains (`mt_pem_chain()`), Intel's
signed TCB info and QE identity (`mt_json()`), OCSP responses
(`mt_ocsp()`). Nothing in it is trusted for being there: the verifier uses
an item only when it fits the chain it is checking, so anyone may add it.
The attester includes what the platform hands it (an SNP report brings the
host's certificate table); the verifier adds what it fetched or cached:

```text
List(UInt(8)) e2 = evidence_add_collateral(evidence, mt_crl(), amd_crl)?;
```

The library never touches the network for collateral; fetching it from
AMD's KDS or Intel's PCS is the caller's job. Decoding is strict and
bounded: one well-formed CBOR item of definite lengths, nested at most 12
deep, at most 4 MiB and 64 collateral items, text labels each once.

`attest(challenge)` tries the kernel's TSM report (SEV-SNP, TDX, CCA),
then the Nitro Secure Module, then the TPM (PCRs 0 to 7, signed by its
endorsement-hierarchy attestation key). The challenge is `Runtime` (a
fresh value nobody keeps), `Verbatim(v)` (the verifier's value, 32 to 64
bytes) or `Issued(c)` (this program's own record, spent before the request
and bound to the reply, so the program can verify its own evidence; the
NSM and the TPM take their challenge as request data, so `Issued` is
`Unsupported` there). It needs the full `device` grant.

## Trust sets

What a verification may rest on is a `Trust`, made by an `@trust`
function that names anchors and other trust sets:

```text
@trust(anchors = [amd_ark_genoa, amd_ark_genoa_vlek])
Trust genoa_only() { return trust_anchors(); }

@trust(include = [genoa_only, intel_roots])
Trust ours() { return trust_anchors(); }
```

The compiler rewrites the body so the set holds exactly the anchors named
(`E0281` for an `@trust` function of the wrong shape; `E0282` for a name
that is not an `@anchor` function in `anchors` or an `@trust` function in
`include`, or a set that includes itself). Nothing else builds a `Trust`
(it is opaque), so the compiler knows every anchor a verification may
rest on.

`vendor_roots()` is every root this release carries: AMD's SEV-SNP roots
(`amd_roots`: Milan, Genoa and Turin, VCEK and VLEK), Intel's SGX root
(`intel_roots`), the AWS Nitro root (`aws_roots`) and NVIDIA's device
identity CA (`nvidia_roots`). Arm CCA and TPM evidence is signed by keys
of the deployment's own: pin one as an anchor (`kind = EndorsedKeys` for a
CPAK, `TpmAk` for an AK), let a verified CoRIM endorse it
(`trust_with_keys(tr, refs)`), or, for a TPM, prove it by credential
activation (`trust_with_ak(tr, ak)`, below).

A verifier tries the set's roots and keys of the platform's kinds in
turn: a root whose chain the evidence does not use, or a key that did not
sign it, leaves the next to try; evidence that fails under a root it does
use is refused with that failure. A pure `@trust` set holding no anchor of
a kind the primitive takes is `E0282`.

## Bindings

How the evidence carries the challenge:

| Binding | The evidence carries | The result |
|---|---|---|
| `bind_fresh()` | `challenge_value(c)` | `Fresh` |
| `bind_key(kem, pk)` | `challenge_with_key(value, kem, sk)` for the `sk` behind `pk` | `Fresh`, `KeyBound`: `seal_to_evidence` can release to `pk` |
| `bind_channel(c, e)?` | `challenge_with_channel(value, e')` for the attester's end of this TLS connection | `Fresh`, `ChannelBound`: `seal_to_channel` can release on it |
| `bind_device(s)?` | `challenge_session_value(value, th)` for a verified SPDM session `s` | `Fresh`, resting on the device's root too |

A `Binding` is opaque and made only by these, and the compiler reads which
one a verification used (directly or through a local binding); a binding
it cannot see -- a parameter -- gives nothing, and a decision on it is
refused (`E0285`). The challenge record is accepted once for the whole
process; a record this program spent on its own device answers only for
the reply that request returned. `verify_evidence_replayable(evidence, r,
tr, t)` checks evidence against an imported `ReplayableRecord`: `Delivered`
only, never enough for a decision.

`t` is an `EvidenceTime`: `kernel_time()` reads the clock (source
`Kernel`); nothing else outside `lib/verify/` can build one, so a program
cannot pass a past time to make an expired certificate valid.

## Claims

`verify_evidence` returns `Verified(Claims)`: what the evidence says, in
one shape for every platform.

| Field | |
|---|---|
| `platform` | `AmdSnp`, `IntelTdxTd`, `ArmCcaRealm`, `AwsNitro`, `Tpm2`, `SpdmDevice` (`platform_name` gives "AMD SEV-SNP", ...) |
| `measurements` | slot-named digests: the launch measurement and the rest |
| `launch_slot` | which slot measures the launched image (`""` where none does) |
| `debug` | the platform says the TEE can be debugged |
| `values` | other claims the platform or the measured image vouches for, by name |
| `host_values` | claims the host or the requester chose (signed, but chosen outside) |
| `tcb_statuses` | the vendor collateral's TCB statuses (Intel's TCB and QE levels) |
| `hardware_id` | the chip or instance, when the evidence or its endorsement names one |
| `report_data` | what the attester bound (the challenge field) |
| `corim` | the same claims as CoRIM claims, for appraisal against reference values |

| Platform | Launch slot | Other slots | Claims (`values`) | Host-chosen (`host_values`) |
|---|---|---|---|---|
| SEV-SNP | `MEASUREMENT` | | `vmpl`, `guest_svn`, `policy`, `policy.migrate_ma`, `signing_key`, `committed_tcb.*`, `current_tcb.*`, `launch_tcb.*`, `report_id`, ... | `host_data`, `id_key_digest`, `author_key_digest`, `family_id`, `image_id`, `reported_tcb.*` |
| TDX | `MRTD` | `RTMR0`-`RTMR3`, `MRSEAM` | `td_attributes`, `xfam`, `tee_tcb_svn`, `mrsignerseam`, `fmspc`, `pcesvn`, `qe_isvsvn`, ... | `mrconfigid`, `mrowner`, `mrownerconfig` |
| CCA | `RIM` | `REM0`-`REM3`, `SW.<type>` per platform component | `implementation_id`, `instance_id`, `lifecycle`, `profile`, ... | `rpv` |
| Nitro | `PCR0` | `PCR1`... | `module_id`, `timestamp` | `user_data`, `public_key` |
| TPM | | `PCR0`-`PCR23` (SHA-256 bank) | `firmware`, `reset_count`, `restart_count`, `safe`, `instance` | |
| SPDM | | `MEAS<index>` | `version`, `slot`, `MEAS<index>.type`, `instance` | `context` |

Read them with `claims_measurement(c, slot)`, `claims_launch(c)`,
`claims_number(c, name, fallback)`, `claims_bytes(c, name)` and, for the
host's, `claims_host_bytes(c, name)`. Host-chosen claims, `report_data`
and the raw evidence are External to a decision (below): a release cannot
turn on them.

## Appraisal

`appraise_evidence(v, policy)` gives `Appraised(Claims)`. It first applies
what no policy turns off: the evidence must not say the TEE can be
debugged; the platform's own rules must hold (SEV-SNP: no migration agent
unless allowed, VMPL 0 unless the policy requires a VMPL; TDX:
SEPT_VE_DISABLE set; CCA: a secured lifecycle; Nitro: PCRs 0-2 present;
SPDM: measurements present); and every vendor TCB status must be
`UpToDate` or allowed. Then the policy, the same for every platform:

```text
type Policy = { List(Str) measurements; List(Str) require; List(Str) allow; };
```

- `measurements`: `"hex"` names an accepted launch measurement, `"SLOT=hex"`
  an accepted value of a slot. The launch measurement must be one of the
  bare entries when there are any; each slot named must hold one of the
  values listed for it. At least one entry is required. One policy can
  list the image's measurement on every platform it is built for.
- `require`: `"name=hex"` (a bytes claim equals one listed), `"name==n"`
  (a number equals one listed), `"name>=n"` (a number is at least n). A
  claim the evidence does not carry fails.
- `allow`: `"migration_agent"`, `"tcb_status=SWHardeningNeeded"` and the
  other statuses Intel's collateral may give (`tcb_status_names()`);
  anything else is refused.

The policy argument is a direct call of a nullary `@policy` function
(`E0283`), so the appraisal names a reviewed rule.

## Endorsed reference values

A reference value need not be a hash compiled into a policy: a signed
CoRIM (draft-ietf-rats-corim; `lib/verify/corim.resid`) carries an
endorser's word. `corim_verify(corim, tr, t)` checks it under an anchor
of kind `Endorser` in `tr` (ECDSA P-256, P-384 or P-521, Ed25519,
RSASSA-PSS or PKCS#1, as the anchor lists). Every triple is read:
reference values, endorsed values, identity keys, attestation keys,
conditional endorsements and series; every measurement value and key type
the draft defines.

`appraise_evidence_endorsed(v, policy, refs)` applies the CoRIM to the
evidence's claims (draft §9) and then the policy: a corroborated launch
measurement (SEV-SNP, TDX, CCA) counts as one the policy names; where a
platform's measurements are registers or blocks (Nitro, TPM, SPDM) the
CoRIM must corroborate them all, and the policy may then name none; a CCA
platform's software components must all be corroborated. The result rests
on the endorser as well, so the decision names it:

```text
@decides(accept = [vendor_roots, image_endorsers], require = [image_endorser],
         appraised = release_policy, identity = key_bound)
...
    Verified(CorimRefs) refs = corim_verify(corim, image_endorsers(), kernel_time())?;
    Verified(Claims) v = verify_evidence(evidence, issued, bind_key(32, pk), vendor_roots(), kernel_time())?;
    Appraised(Claims) a = appraise_evidence_endorsed(v, release_policy(), refs)?;
```

`evidence_corim(v, refs)` returns the accepted claims set, which a policy
queries with `corim_corroborated`, `corim_holds` and `corim_endorsements`.

### Endorsed keys

Attest-key triples endorse attestation keys and identity triples device
keys, so a CCA platform's CPAK, a TPM's AK or an SPDM device's key need
not be pinned: `trust_with_keys(tr, refs)` adds them to a trust set. A CCA
token names its own instance, which must be the key's; a TPM quote or an
SPDM transcript names none, so the instance is the endorsement's word
(the `instance` claim and `hardware_id`), and when two endorsements of one
key name different instances the verifier claims neither. A triple with
conditions is used only when it names no measured element and, if it
names who must have authorized the key, the endorser is among them.

## Devices over SPDM

SPDM 1.0 to 1.3 evidence (DMTF DSP0274) verifies under a device root:
NVIDIA's Device Identity CA (`nvidia_roots`, kind `NvidiaDevice`) or any
vendor's, declared as an anchor of kind `DeviceIdentity` whose product is
`"Vendor:Model"` (the device class CoRIM reference values are matched
against). Every signature algorithm SPDM defines that the library
implements is accepted when the anchor lists it. Measurement evidence
(`evidence_spdm_measurements(vca, certs, ocsp, before, request,
response)`) is checked through the chain, a current good OCSP answer for
every certificate below the root (NVIDIA's firmware alias leaf is exempt,
as NVIDIA's verifier does it), the device's signature over the transcript
and the challenge as the request's nonce; CHALLENGE evidence
(`evidence_spdm_challenge`) proves the device's identity and carries no
measurements to appraise.

### Sessions

`verify_session(evidence, c, tr, t)` verifies a KEY_EXCHANGE
(`evidence_spdm_session(vca, chain, ocsp, digests, key_exchange,
key_exchange_rsp)`, 1.1 to 1.3): `Verified(SpdmSession)`, with the suite,
session ID, exchange values, the measurement summary, the
ResponderVerifyData and `th`, the transcript hash through the device's
signature. `session_covers(s, m)` says whether verified measurement
evidence holds exactly what the session's summary covers. The guest that
holds the session binds its own evidence to it with `bind_device(s)`; the
result rests on both roots:

```text
@decides(accept = [vendor_roots], appraised = guest_policy, identity = none)
...
    Verified(SpdmSession) s = verify_session(session, gpu, vendor_roots(), t)?;
    Binding b = bind_device(s)?;
    Verified(Claims) r = verify_evidence(evidence, cpu, b, vendor_roots(), t)?;
```

### The requester

`lib/spdm_requester.resid` is a whole SPDM 1.0-1.3 requester over a
transport closure (`SpdmIo`): `spdm_connect`, `spdm_get_digests`,
`spdm_get_certificate`, `spdm_challenge`, `spdm_get_measurements`,
`spdm_start_session` (mutual authentication with and without encapsulated
requests, the handshake encrypted or in the clear),
`spdm_start_psk_session`, `spdm_heartbeat`, `spdm_key_update`,
`spdm_session_measurements` and `spdm_end_session`; it answers BUSY,
RESPONSE_NOT_READY and large responses (CHUNK_GET), and chunks large
requests (CHUNK_SEND). Each step returns the bytes an evidence record
needs. `lib/spdm_transport.resid` frames messages for MCTP, PCI DOE and
DSP0287 TCP, secured (DSP0277) or not, and speaks the DMTF spdm-emu socket
protocol; `tests/spdm/run.sh` runs the requester against spdm-emu.

## What each platform checks

- **SEV-SNP**: the chain from the ARK (ASK or ASVK, VCEK or VLEK,
  RSASSA-PSS SHA-384) with the ARK's newest current CRL in the collateral
  at or above the product's floor, the report's ECDSA P-384 signature, and
  its claims against its signer: `SIGNING_KEY` the root's kind,
  `REPORTED_TCB` the VCEK's TCB, `CHIP_ID` the VCEK's hardware ID, a VLEK's
  CSP ID, the product and CPU family. At most four certificate pairs are
  tried, however much collateral there is.
- **TDX** (quotes 4 and 5): the PCK chain the quote carries to Intel's
  root, the quoting enclave's report and its binding of the attestation
  key, the quote's signature; Intel's collateral from the envelope (the
  CRLs of the PCK's CA and the root, the TCB info for the platform's FMSPC
  and the TD QE identity, each signed under the same root and not below
  the evaluation floor) gives the platform's and the QE's TCB statuses.
- **Arm CCA**: the realm token signed by the RAK it carries, the platform
  token signed by the CPAK and bound to that RAK; the challenge in the
  realm token (64 bytes).
- **Nitro**: an ES384 COSE_Sign1 whose bundle starts at the root and
  chains to the signing certificate; the challenge in `nonce`.
- **TPM**: a TPM2_Quote by an AK in the trust set (pinned, endorsed or
  activated), one SHA-256 bank whose digest covers the PCR values given;
  the challenge in the qualifying data.
- **SPDM**: above.

## Platform-only features

These have no other platform's equivalent and stay with their platform.

### SEV-SNP sealing

`lib/verify/sealing.resid`: `snp_platform_key(selector, v)` derives the
guest's SNP sealing key from its own fresh SEV-SNP evidence (verified from
`attest(Issued(c))`, so it is this program's own device's answer),
always mixing in the guest policy and measurement; `local_seal(k,
version, counter, value)` and `local_open(k, blob)` keep data only this
measurement can open, and `local_open`'s result carries `Local`. A
decision on it alone writes `identity = local, fresh = false` (an old blob
opens as well as a new one) unless a TPM counter binds the version:
`tpm_verify_counter(attest, sig, c, tr, t)` reads a TPM2_NV_Certify fresh,
and `bind_counter(opened, counter)` gives a value that is `Local` and
`Fresh` when the versions agree, resting on both. Before anything was
sealed, `first_seal(k, counter, initial)` is the explicit outcome.

### TPM attestation keys by credential activation

An AK can be proven to live in the TPM a manufacturer certified, by
TPM2_ActivateCredential against the TPM's endorsement key (TCG TPM 2.0
Part 1 §24; the EK Credential Profile's low-range EKs). `tpm_ek_roots()`
holds the 46 roots of Microsoft's TrustedTpm.cab (kind `TpmEk`).

1. The attester reads its EK certificate and makes its EK and AK
   (`tpm_ek_cert`, `tpm_ek_chain_certs`, `tpm_ek_ak` in `lib/dev/tpm.resid`).
2. The verifier makes a credential for that EK certificate and the AK's
   public area: `tpm_ak_challenge(ek_cert, ak_public, c)`, derived from the
   challenge record's nonce, which is never sent.
3. The attester's TPM releases it (`tpm_activate_credential`) only if it
   holds the EK's private key and an object with that name.
4. `tpm_verify_ak(ek_chain, crls, ak_public, activated, c, tpm_ek_roots(),
   t)` checks the answer, the EK chain to a root in the set with a current
   CRL for every certificate below it, tcg-kp-EKCertificate, and that the
   AK is a restricted signing key fixed to its TPM.
5. `trust_with_ak(tr, ak)` adds the AK to a trust set; quotes and counters
   it signs verify under that set and rest on the EK root.

## Verified values

`Verified(T)` is a value of `T` together with how it was verified: the
anchors it rests on, its qualifiers (`Fresh`, `KeyBound`, ...), and the
challenge record whose mark it took. `Appraised(T)` is a `Verified(T)` that
also passed an appraisal. Only the files of `lib/verify/` build either
(`E0276`), and only functions marked `@primitive` there produce them
(`E0280`). The per-platform modules in `lib/verify/` are internal: their
functions are `@verify_internal`, which a program cannot call (`E0280`).

Every primitive fails with one sum:

```text
type VerifyError = BadLayout(Str) | BadChain(Str) | BadSignature(Str) | Stale(Str) | NotFresh(Str) | Refused(Str, Str);
```

## Anchors

An anchor is a nullary function marked `@anchor`, returning
`anchor_der(bytes)`:

```text
@anchor(kind = AmdVcek(Genoa), principal = InGuest, formats = [SnpReport],
        source = "https://kdsintf.amd.com/vcek/v1/Genoa/cert_chain",
        fingerprint = "sha384:d1b7…", retrieved = "2026-10-11", reviewed_by = "…",
        algorithms = [RsaPss4096Sha384, EcdsaP384Sha384], expires = "2047-01-26")
pub Anchor amd_ark_genoa() { return anchor_der(amd_ark_genoa_der()); }
```

The compiler rewrites the `anchor_der` call so the `Anchor` carries the
annotation's facts, and the bytes are checked against the fingerprint
when the anchor is first used. An anchor's identity is its function: a
dependency declaring `kind = AmdVcek(...)` over its own root gains
nothing, because a decision names the functions it accepts.

## Decisions

The compiler checks every `@decides` function:

- **The gate.** Every success return is reached only through the `Ok` of
  a primitive call made in the body: after `?`, in a `match` arm for `Ok`,
  or in `if (Ok(x) = ...)`. A body that calls a verifier and ignores its
  result has no gate (`E0284`).
- **Requirements** (`E0285`): every anchor the gate may rest on is in
  `accept` (which names `@anchor`, `@assumption` and `@trust` functions; a
  trust set stands for its anchors), and it surely rests on every one in
  `require` (a gate verified under a set of several rests on whichever
  fits, so `require` needs a set of that one); with `appraised = P` it
  passed `P` (`appraised = none` means merely verified); it is fresh
  (`fresh = false` accepts reusable evidence); it carries an identity
  (`KeyBound`, `ChannelBound` or `Local`; `identity = none` when the answer
  may go to anyone); with `time = not_kernel` its certificates were not
  checked against the kernel clock. A trust set or binding the compiler
  cannot see makes the gate's anchors unknown, which is refused.
- **Releases** (`E0287`): `seal_to_evidence` runs only inside a decision,
  and a `key_bound` decision's success return is that call on its gate. At
  run time it refuses evidence bound to another key, seals in HPKE Auth
  mode under the releaser's key, and marks the gate decided, so one gate
  releases once.
- **Inputs** (`E0286`): what reaches or selects the result is not
  External, at every caller and in the body, except the bytes a primitive
  verifies and values that only random draws or provisioned keys stand
  behind. A broker cannot release the key a request names.
- A gate formed inside a loop is refused (`E0288`).
- With `identity = channel_bound`, the release is `seal_to_channel(gate,
  exporter, value)`, which refuses evidence bound to another connection;
  only `tlsserver_send_bound` / `tlsclient_send_bound` write the result,
  each on that connection alone.
- What the requester or the host chose in signed evidence (`host_values`,
  `report_data`, the CoRIM view and the raw evidence) is External when
  read, so a decision cannot turn on it. Field origins only ever get
  stricter: a second `@layout_origins` declaration cannot launder a field.
- `bind = "purpose"` requires the decision's challenge record to have
  been issued for that purpose (`challenge_issue(n, bind)`); a program
  that issues for several purposes names one on every decision (`E0293`).

The attester opens a release with `open_released(kem, sk, msg, anchor)`,
which accepts only a message the pinned `ReleaseSender` anchor sealed.

## Attestation results

When a Resid program is the verifier, `ear_cwt(appraised, submod,
policy, build, developer, t, key)` (`lib/verify/ear.resid`) hands the
appraisal on as an EAR: a COSE_Sign1 (ES256) CWT carrying `ear.status`
affirming and an AR4SI trustworthiness vector, signed with the verifier's
own or provisioned P-256 key.

## Assumptions

Where no evidence exists, an application states an assumption and pins
the value it vouches for:

```text
@assumption(reason = "the deployment enrolled this key by hand", pins = "sha256:…")
Assumption enrolled() { return assumption_pinned(); }
```

`assume(x, enrolled())` (in `lib/verify/assume.resid`, needing the
`assume` family) gives `Verified(x)` only when x hashes to the pin, and a
decision accepts it only by naming `enrolled` in `accept`. The standard
library states no assumption (`E0289`), and `residc verify` lists them.

## Disclosure

Whether a `declassify` happens, and what it discloses, must not be
decided by outside data: a condition, an earlier `return`, `?`, `break` or
`continue` under outside data, or an argument to a function that discloses
(`E0291`, `E0292`; warnings during the rollout, in check and debug
builds and in any build of a program with a decision). Decisions on
verified evidence do not count as outside data. The standard library's
own publication sites are exempt, and so is a function marked
`@robust_exempt(reason = "...")`, which `residc verify` lists.

## The transcript

`transcript()` (`lib/transcript.resid`) returns what the program saw: a
running SHA-256 over every device crossing (each request noted before it
is sent, then its reply, secret outputs by length only) and the last 256
crossings. It is on only in a program that calls it, from the start of
`main`, and its result is External: a commitment, not an endorsement.

## The verify closure and instances

In a program that reaches `lib/verify/`, no instance the program or a
dependency declares may replace one of the standard library's (`E0294`):
the verifiers' randomness and word instances are the library's.

A program that reaches `lib/verify/` compiles only against the files of
`lib/verify/` and everything they import, and the runtime, that the
compiler was released with (`compiler/verify_pins.resid`), and never with
`-rt` or `-rtr` (`E0290`). `--verify-lib-dev` lifts this for work on the
library; the provenance record says so. The record's `attest` array lists
every anchor with its origin, every trust set with its anchors, every
policy and every decision with its requirements, and `residc verify`
prints them.
