---
title: Attestation
description: Verified evidence, anchors, appraisal and decisions that say whose word they rest on.
---

A program that acts on remote attestation evidence (an AMD SEV-SNP report,
an Intel TDX quote, an AWS Nitro document, an Arm CCA token, a TPM quote
or a GPU's SPDM measurements) checks it with the standard library's verifiers in `lib/verify/`,
and marks the function that releases something with `@decides`. The
compiler then checks that the release cannot happen without fresh,
verified, appraised evidence from the anchors the decision names. The
design is `PLAN-attestation.md` in the repository; this page describes
what is implemented.

## Verified values

`Verified(T)` is a value of `T` together with how it was verified: the
anchors it rests on, its qualifiers (`Fresh`, `KeyBound`, ...), and the
challenge record whose mark it took. `Appraised(T)` is a `Verified(T)` that
also passed an appraisal. Only the files of `lib/verify/` build either
(`E0276`), and only functions marked `@primitive` there produce them
(`E0280`), so a value of these types came out of a verifier. Fields stay
readable: `v.value.measurement`.

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
when the anchor is first used. A primitive's anchor argument must be a call
of an `@anchor` function, of a kind the primitive takes (`E0282`), so the
compiler knows which anchor every verified value rests on. An anchor's
identity is its function: a dependency declaring `kind = AmdVcek(...)`
over its own root gains nothing, because a decision names the functions
it accepts.

`lib/verify/amd_anchors.resid` holds AMD's roots for Milan, Genoa and
Turin, each as a VCEK and a VLEK anchor (`amd_ark_genoa`,
`amd_ark_genoa_vlek`, ...).

## SEV-SNP

`lib/verify/snp.resid` declares the report as a layout type with each
field's origin (`@measured`, `@firmware`, `@relayed`, `@host`) and four
verifier forms:

| Function | Gives |
|---|---|
| `snp_verify(report, c, root, col, t)` | `Fresh`: the report carries `challenge_value(c)` |
| `snp_verify_key_bound(report, c, root, col, t, kem, pk)` | `Fresh`, `KeyBound(kem, pk)`: it carries `challenge_with_key(challenge_value(c), kem, sk)` for the `sk` behind `pk` |
| `snp_verify_channel_bound(report, c, root, col, t, e)` | `Fresh`, `ChannelBound`: it carries `challenge_with_channel(challenge_value(c), e')` for the attester's end of this connection |
| `snp_verify_replayable(report, r, root, col, t)` | `Delivered`, for a `ReplayableRecord`: never enough for a decision |

Each checks the chain from the anchor (ARK, ASK or ASVK, VCEK or VLEK,
RSASSA-PSS SHA-384, the ARK's current CRL), the report's ECDSA P-384
signature, and that the report's claims match its signer: `SIGNING_KEY`
the anchor's kind, `REPORTED_TCB` the VCEK's TCB, `CHIP_ID` the VCEK's
hardware ID. The challenge record is marked accepted once for the whole
process; a record this program spent on its own device answers only for
the report that request returned.

`t` is an `EvidenceTime`: `kernel_time()` reads the clock (source
`Kernel`); nothing else outside `lib/verify/` can build one, so a program
cannot pass a past time to make an expired certificate valid.

`snp_appraise(v, policy)` applies the checks no policy turns off (no
debugging, a migration agent only when the policy allows it, the report's
own VMPL, the committed and reported TCB at least the floor) and then the
policy's measurements, ID keys and host data. The policy argument must be a
direct call of a nullary `@policy` function (`E0283`):

```text
@policy
SnpPolicy release_policy() {
    return SnpPolicy {.min_tcb = TcbVersion {.fmc = 0, .bootloader = 3, .tee = 0, .snp = 8, .microcode = 115},
                      .measurements_hex = ["5c1f…e0"], .vmpl = 0, .allow_migration_agent = false,
                      .id_key_digests_hex = [], .host_data_hex = []};
}
```

## AWS Nitro Enclaves

`lib/verify/nsm.resid` verifies an NSM attestation document (an ES384
COSE_Sign1 over a CBOR map) whose certificate bundle starts at
`aws_nitro_root()` (`lib/verify/aws_anchors.resid`): `nsm_verify`,
`nsm_verify_key_bound`, `nsm_verify_channel_bound` and
`nsm_verify_replayable`, with the challenge in `nonce`. `nsm_appraise(v,
policy)` refuses a debug enclave (PCR0 all zeros) and checks the PCRs a
`@policy` function's `NsmPolicy {.pcrs_hex = ["0=...", ...]}` names.

## TPM 2.0

`lib/verify/tpm.resid` verifies a TPM2_Quote under an attestation key the
deployment pins as an anchor of kind `TpmAk` (its bytes are the AK's
SubjectPublicKeyInfo): `tpm_verify_quote(attest, sig, pcr_values, c, ak,
t)` and its key-bound and replayable forms. The challenge is the quote's
qualifying data (issue a 32-byte one), and the PCR values given must be
the ones the quote's digest covers. `tpm_appraise(v, policy)` checks the
PCRs a `TpmPolicy` names.

## Intel TDX

`lib/verify/tdx.resid` verifies quotes of versions 4 and 5 under Intel's
SGX root (`intel_sgx_root()`, `lib/verify/intel_anchors.resid`): the PCK
chain the quote carries, the quoting enclave's report and its binding of
the attestation key, and the quote's signature; the challenge is
REPORTDATA. `tdx_appraise(v, policy, collateral, root, t)` refuses a
debuggable TD and one without SEPT_VE_DISABLE, checks Intel's collateral
(the TCB info and QE identity PCS serves, signed under the same root, and
the PCK CA's and root's CRLs):
the platform's TCB status and the quoting enclave's must be `UpToDate`
or listed in the policy's `accepted_statuses`; then the MRTD, RTMRs and
TDX modules a `TdxPolicy` names.

## Arm CCA

`lib/verify/cca.resid` verifies a CCA token (the realm token, signed by
the RAK it carries, and the platform token, signed by a CPAK the
deployment pins as an anchor of kind `EndorsedKeys` and bound to that RAK)
with the challenge in the realm token: `cca_verify` and its key-bound,
channel-bound and replayable forms. `cca_appraise(v, policy)` requires a
secured platform lifecycle and checks the realm initial measurement, REMs
and platform implementation a `CcaPolicy` names.

## Devices over SPDM

`lib/verify/spdm.resid` verifies an SPDM 1.1 GET_MEASUREMENTS exchange
(what NVIDIA's Hopper GPUs answer) under NVIDIA's Device Identity CA
(`nvidia_device_root()`, `lib/verify/nvidia_anchors.resid`): the device
chain from the leaf to the root, the leaf's P-384 signature over the
request and response, and the challenge as the request's 32-byte nonce:
`spdm_verify(request, response, chain, c, root, t)` and its key-bound,
channel-bound and replayable forms. `spdm_appraise(v, policy)` checks the
measurement blocks an `SpdmPolicy` names.

## Endorsed reference values

A reference value need not be a hash compiled into a policy: a signed
CoRIM (`lib/verify/corim.resid`) carries an endorser's reference values,
and `corim_verify(corim, endorser, t)` checks it under an anchor of kind
`Endorser`. The endorsed appraisals in `lib/verify/endorsed.resid`
(`snp_appraise_endorsed`, `tdx_appraise_endorsed`,
`cca_appraise_endorsed`, `spdm_appraise_endorsed`) accept what it
endorses beside the policy's own values, and their result rests on the
endorser as well, so the decision names it:

```text
@decides(accept = [amd_ark_genoa, image_endorser], require = [image_endorser],
         appraised = release_policy, identity = key_bound)
...
    Verified(CorimRefs) refs = corim_verify(corim, image_endorser(), kernel_time())?;
    Appraised(SnpReport) a = snp_appraise_endorsed(v, release_policy(), refs)?;
```

## Sealing to this measurement

`lib/verify/sealing.resid`: `snp_platform_key(selector, report)` derives
the guest's SNP sealing key from its own fresh report (one this program's
own request returned), always mixing in the guest policy and measurement;
`local_seal(k, version, counter, value)` and `local_open(k, blob)` keep data only
this measurement can open, and `local_open`'s result carries `Local`. A
decision on it alone writes `identity = local, fresh = false` (an old blob opens
as well as a new one) unless a TPM counter binds the version: seal with
the counter's NV name (`local_seal(k, version, counter_name, value)`),
read the counter fresh with `tpm_verify_counter(attest, sig, c, ak, t)`
(a TPM2_NV_Certify under a pinned AK), and `bind_counter(opened,
counter)` gives a value that is `Local` and `Fresh` when the versions
agree, resting on both anchors: a decision then writes `identity = local`
and accepts both. Before anything was sealed, `first_seal(k, counter,
initial)` is the explicit outcome: a fresh reading at the counter's
provisioned initial value, never a missing blob read as empty.

## Attestation results

When a Resid program is the verifier, `ear_cwt(appraised, submod,
policy, build, developer, t, key)` (`lib/verify/ear.resid`) hands the
appraisal on as an EAR: a COSE_Sign1 (ES256) CWT carrying `ear.status`
affirming and an AR4SI trustworthiness vector, signed with the verifier's
own or provisioned P-256 key.

## Decisions

```text
@decides(accept = [amd_ark_genoa], appraised = release_policy, identity = key_bound)
@requires(declassify, clock(readonly))
pub Result(HpkeMessage, VerifyError) release(List(UInt(8)) report, ChallengeRecord issued,
                                             SnpCollateral col, List(Int) guest_pk,
                                             List(Secret(UInt(8))) key, List(Secret(UInt(8))) sender) {
    Verified(SnpReport) v = snp_verify_key_bound(report, issued, amd_ark_genoa(), col, kernel_time(), 32, guest_pk)?;
    Appraised(SnpReport) a = snp_appraise(v, release_policy())?;
    return seal_to_evidence(a, 32, guest_pk, key, sender);
}
```

The compiler checks:

- **The gate.** Every success return is reached only through the `Ok` of
  a primitive call made in the body: after `?`, in a `match` arm for `Ok`,
  or in `if (Ok(x) = ...)`. A body that calls a verifier and ignores its
  result has no gate (`E0284`).
- **Requirements** (`E0285`): the gate's anchors are all in `accept` and
  include every one in `require`; with `appraised = P` it passed `P`
  (`appraised` is required: write `appraised = none` to mean merely
  verified); it is fresh (`fresh = false` accepts reusable evidence); it
  carries an identity (`KeyBound`, `ChannelBound` or `Local`; `identity =
  none` when the answer may go to anyone); with `time = not_kernel` its
  certificates were not checked against the kernel clock.
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
- A field of signed evidence that the requester or the host chose
  (`@relayed`, `@host`, `report_data`, `host_data`, ...) is External when
  read, so a decision cannot turn on it.
- `bind = "purpose"` requires the decision's challenge record to have
  been issued for that purpose (`challenge_issue(n, bind)`); a program
  that issues for several purposes names one on every decision (`E0293`).

The attester opens a release with `open_released(kem, sk, msg, anchor)`,
which accepts only a message the pinned `ReleaseSender` anchor sealed.

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
`@robust_exempt(reason = "...")`, which `residc verify` lists:

```text
@robust_exempt(reason = "a password check discloses one bit on an outside guess")
@requires(declassify)
Bool check(Secret(Int) pw, Int guess) { ... }
```

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
every anchor with its origin, every policy and every decision with its
requirements, and `residc verify` prints them.
