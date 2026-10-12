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
PCRs a `TpmPolicy` names. `tpm_verify_counter` verifies TPM2_NV_Certify of
an 8-byte counter (sealing's rollback protection).

### Attestation keys by credential activation

An AK need not be pinned: it can be proven to live in the TPM a
manufacturer certified, by TPM2_ActivateCredential against the TPM's
endorsement key (TCG TPM 2.0 Part 1 §24, the EK Credential Profile's
low-range EKs: RSA 2048 at NV 0x01C00002, ECC NIST P-256 at 0x01C0000A).
The anchor is the manufacturer's EK root, of kind `TpmEk`;
`lib/verify/tpm_anchors.resid` holds the 46 roots of Microsoft's
TrustedTpm.cab (AMD, Atmel, Infineon, Intel, NationZ, Nuvoton, Qualcomm,
STMicro; generated by `tools/attest/gen_tpm_anchors.py`).

1. The attester reads its EK certificate and makes its EK and AK
   (`tpm_ek_cert(ecc)`, `tpm_ek_chain_certs()`, `tpm_ek_ak(ecc)` in
   `lib/dev/tpm.resid`): the AK is an ECC P-256 restricted signing key
   fixed to the TPM, derived in the endorsement hierarchy, so the same
   TPM makes the same AK every time and nothing persists.
2. The verifier makes a credential for that EK certificate and the AK's
   public area: `tpm_ak_challenge(ek_cert, ak_public, c)`. The credential
   is derived from the challenge record's nonce, which is never sent, so
   only a TPM that decrypts it can answer.
3. The attester's TPM releases it (`tpm_activate_credential(ecc, blob,
   secret)`) only if it holds the EK's private key and an object with
   that name; it runs in one TPM session chain (`device.transact_chain`),
   with the endorsement hierarchy's authorization (never a lockout count)
   and a noDA AK.
4. `tpm_verify_ak(ek_chain, crls, ak_public, activated, c, root, t)`
   checks the answer, the EK certificate's chain to the root with a
   current CRL for every certificate below it (revoked is refused,
   unanswered is stale), tcg-kp-EKCertificate, and that the AK is a
   restricted signing key fixed to its TPM: `Verified(TpmAk)`, with the
   TPM's manufacturer, model and version from the certificate.
5. Quotes and counters signed by that AK verify from it:
   `tpm_verify_quote_activated(attest, sig, pcr_values, c, ak, t)`, its
   key-bound form, `tpm_verify_counter_activated`. They rest on the EK
   root, so a decision accepts the manufacturer's anchor:

```text
@decides(accept = [tpm_ek_infineon_optiga_tm_ecc_root_ca], appraised = boot_policy, identity = key_bound)
...
    Verified(TpmAk) ak = tpm_verify_ak(chain, crls, ak_public, activated, c1, tpm_ek_infineon_optiga_tm_ecc_root_ca(), t)?;
    Verified(TpmQuoteEvidence) q = tpm_verify_quote_activated_key_bound(attest, sig, pcrs, c2, ak, t, 32, pk)?;
```

The verifier's side of TPM2_MakeCredential is `lib/tpm_credential.resid`
(KDFa, KDFe, AES-128-CFB, HMAC, RSAES-OAEP), checked against the IBM TPM
simulator's ActivateCredential in `tests/device`'s `tpm_simulator` case.

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

`lib/verify/spdm.resid` verifies SPDM 1.0 to 1.3 evidence (DMTF DSP0274)
under a device root: NVIDIA's Device Identity CA
(`nvidia_device_root()`, `lib/verify/nvidia_anchors.resid`, kind
`NvidiaDevice`) or any vendor's, declared as an anchor of kind
`DeviceIdentity`. Every signature algorithm SPDM defines that the library
implements is accepted when the anchor lists it (`EcdsaP256Sha384`,
`RsaPss3072Sha256`, `Ed25519`, ...: ECDSA P-256, P-384 and P-521, RSASSA
and RSAPSS at 2048, 3072 and 4096 bits, Ed25519, each with SHA-256, -384
or -512). An `SpdmRecord` holds the negotiation (the six messages,
GET_VERSION to ALGORITHMS, which 1.2 and later sign over), the device's
certificates leaf first, OCSP responses, any unsigned GET_MEASUREMENTS
exchanges before the signed one, and the signed request and response:

- `spdm_verify(rec, c, root, t)` and its key-bound, channel-bound and
  replayable forms: the chain to the root, a current good OCSP answer for
  every certificate below it (NVIDIA's leaf, its firmware's alias key, is
  exempt, as NVIDIA's verifier does it), the device's signature over the
  transcript (from 1.2 with the signing context prefix), and the
  challenge as the request's nonce. `spdm_appraise(v, policy)` checks the
  measurement blocks an `SpdmPolicy` names.
- `spdm_verify_challenge(rec, c, root, t)`: CHALLENGE / CHALLENGE_AUTH,
  `Verified(SpdmIdentity)`.
- `spdm_verify_endorsed(rec, c, keys, instance_hex, t)`: the device key
  endorsed by a CoRIM identity triple instead of a chain (below).

### Sessions

`lib/verify/spdm_session.resid` verifies a KEY_EXCHANGE (1.1 to 1.3):
`spdm_session_verify(rec, c, root, t)` over an `SpdmSessionRecord` (the
negotiation, the chain as GET_CERTIFICATE returned it, its OCSP answers,
the DIGESTS response for multi-key connections, KEY_EXCHANGE, whose
random is the challenge, and KEY_EXCHANGE_RSP). The result,
`Verified(SpdmSession)`, holds the suite, session ID, exchange values,
the measurement summary, the ResponderVerifyData and `th`, the transcript
hash through the device's signature. `spdm_session_covers(s, e)` says
whether a verified MEASUREMENTS response holds exactly the measurements
the session's all-measurements summary covers.

The guest that holds the session binds its own evidence to it: its
report carries `challenge_session_value(challenge_value(c), th)`
(`lib/challenge_bind.resid`), checked by `snp_verify_device_bound`,
`tdx_verify_quote_device_bound`, `nsm_verify_device_bound`,
`cca_verify_device_bound`, `tpm_verify_quote_device_bound` and
`tpm_verify_quote_activated_device_bound`
(`lib/verify/device_bound.resid`) against a fresh session. The result
rests on both anchors:

```text
@decides(accept = [amd_ark_genoa, nvidia_device_root], appraised = guest_policy, identity = none)
...
    Verified(SpdmSession) s = spdm_session_verify(rec, gpu, nvidia_device_root(), t)?;
    Verified(SnpReport) r = snp_verify_device_bound(report, cpu, amd_ark_genoa(), col, t, s)?;
```

### The requester

`lib/spdm_requester.resid` is a whole SPDM 1.0-1.3 requester over a
transport closure (`SpdmIo`): `spdm_connect` (GET_VERSION,
GET_CAPABILITIES, NEGOTIATE_ALGORITHMS, the 1.2 opaque-data format,
multi-key), `spdm_get_digests`, `spdm_get_certificate`, `spdm_challenge`
(with basic mutual authentication), `spdm_get_measurements`,
`spdm_start_session` (KEY_EXCHANGE and FINISH, mutual authentication with
and without encapsulated requests, the handshake encrypted or in the
clear), `spdm_start_psk_session` (with and without context),
`spdm_heartbeat`, `spdm_key_update`, `spdm_session_measurements` and
`spdm_end_session`; it answers BUSY, RESPONSE_NOT_READY and large
responses (CHUNK_GET), and chunks large requests (CHUNK_SEND). Each step
returns the bytes a verifier's record needs. `lib/spdm_transport.resid`
frames messages for MCTP, PCI DOE and DSP0287 TCP, secured (DSP0277) or
not, and speaks the DMTF spdm-emu socket protocol (`spdm_emu_connect`,
`@requires(network(readonly))`); `lib/spdm_session.resid` holds the key
schedule and secured messages, generic over the byte type so session
secrets stay `Secret`. `tests/spdm/run.sh` runs the requester against
spdm-emu (22 configurations). The kernel's view of a PCI device
(identity, DOE features, TSM connection) is `lib/dev/pci_tsm.resid`.

## Endorsed reference values

A reference value need not be a hash compiled into a policy: a signed
CoRIM (draft-ietf-rats-corim; `lib/verify/corim.resid`) carries an
endorser's word, and `corim_verify(corim, endorser, t)` checks it under an
anchor of kind `Endorser` (ECDSA P-256, P-384 or P-521, Ed25519,
RSASSA-PSS or PKCS#1, as the anchor lists). Every triple is read:
reference values, endorsed values, identity keys, attestation keys,
conditional endorsements and conditional endorsement series; every
measurement value (version, SVN or minimum SVN, digests, flags, raw value
with a mask, MAC and IP address, serial number, UEID, UUID, name, keys,
integrity registers, integer ranges) and every key type (PEM keys and
certificates, DER certificates, COSE_Keys, thumbprints, bytes).

`corim_appraise(claims, refs)` applies a CoRIM to evidence given as
claims (environment and measurements), as draft-ietf-rats-corim §9 does:
a reference triple whose environment matches and all of whose
measurements match corroborates the claims it matched; endorsed triples
add their measurements; conditional endorsements add theirs when every
condition holds; a series adds the addition of its first record whose
selection matches. Each platform's claims come from
`lib/verify/endorsed.resid` (`snp_claims`, `tdx_claims`, `cca_claims`,
`spdm_claims(v, env)`, `tpm_claims`, `nsm_claims`; their measurement keys
are listed in its header), and `snp_corim(v, refs)` and the like return
the accepted claims set, which a policy queries with
`corim_corroborated`, `corim_holds` and `corim_endorsements`.

The endorsed appraisals (`snp_appraise_endorsed`,
`tdx_appraise_endorsed`, `cca_appraise_endorsed`,
`spdm_appraise_endorsed(v, policy, refs, env)`, `tpm_appraise_endorsed`,
`nsm_appraise_endorsed`) accept what a reference value corroborates beside
the policy's own values, and their result rests on the endorser as well,
so the decision names it:

```text
@decides(accept = [amd_ark_genoa, image_endorser], require = [image_endorser],
         appraised = release_policy, identity = key_bound)
...
    Verified(CorimRefs) refs = corim_verify(corim, image_endorser(), kernel_time())?;
    Appraised(SnpReport) a = snp_appraise_endorsed(v, release_policy(), refs)?;
```

### Endorsed keys

Attest-key triples endorse attestation keys, so a CCA platform's CPAK or a
TPM's AK need not be pinned: `cca_verify_endorsed(token, c, keys, t)`
accepts a platform token signed by a key endorsed for the token's own
instance ID, `tpm_verify_quote_endorsed(attest, sig, pcr_values, c, keys,
instance_hex, t)` a quote signed by a key endorsed for the instance the
verifier names. Identity triples endorse device keys:
`spdm_verify_endorsed(rec, c, keys, instance_hex, t)` accepts a device
whose certificate's key one names (by the key, its certificate or a
thumbprint). A triple with conditions is used only when it names no
measured element and, if it names who must have authorized the key, the
endorser is among them. The CoRIM's not-after and the endorser anchor's
expiry bound the evidence time, and the result rests on the endorser:

```text
@decides(accept = [tpm_endorser], appraised = boot_policy, identity = key_bound)
...
    Verified(CorimRefs) keys = corim_verify(corim, tpm_endorser(), kernel_time())?;
    Verified(TpmQuoteEvidence) v = tpm_verify_quote_endorsed_key_bound(a, s, pcrs, c, keys, instance, kernel_time(), 32, pk)?;
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
