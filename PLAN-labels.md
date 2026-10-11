# Labels, Layouts and Channels — Implementation Plan (revision 3)

**Status: revision 3 DRAFT (2026-10-10).** Revision 2 was accepted the
same day; revision 3 cuts it in two to lower programmer burden and to let
device access land without attestation. Everything about remote
attestation (RATS: hardware evidence, anchors, `Verified`, appraisal,
`@decides`, freshness, identity, rollback, the transcript) moves to
`PLAN-attestation.md`, which builds on this plan. `PLAN-device-access.md`
(revision 3) depends on this plan only. Depends on PLAN-secret-type.md
(done).

**Implementation status (2026-10-10).** Phase 0 holds: literal arithmetic
that leaves its type traps or is refused. Phase 1 is in
(`compiler/labels.resid`, `tests/labels/`, `SECURITY.md` "Integrity
labels"): the source table with E0271, propagation through data and
selection, flow summaries with a worklist fixed point, the `label` field
of the graph artifact and `resid-why --label`. Phase 1 gaps, carried to
the phase that first needs them: labels are computed only for `check` and
`debug` builds (no sink needs them in release yet); the residual re-check
(§4.5) and labels in the reducer's sharing key wait for the first sink
(phase 3); records are labelled as a whole; the language server hover is
not done; the diagnostics corpus starts with the first label error.
Phase 2 is in (`compiler/layout.resid`, reference page "Layout types"):
`@layout(c_abi|le|be)` record types with `@check`, `@len` and
`@reserved`, generated total `_parse`, `_parse_at`, `_bytes` and `_size`
(and `<type>__<field>_at` offsets under c_abi), E0272-E0274, c_abi checked
against clang for both targets, and an oracle against `tpm_wire`'s hand
parsers. Differences from §7.1, decided while implementing: fixed-width
byte fields are `@len(n) List(UInt(8))` (a `Bytes(N)` holds *at most* N
bytes and ends at a zero, spec "Fixed-capacity types"); `_bytes` returns
`Result(List(UInt(8)), DeviceError)`, since a request `@check` can fail.
Deferred to phase 3, with channels and RDV 2: Secret fields,
`Challenge(N)` fields, and replacing the hand-written parsers (device
plan R2.8 step 3); `_Bool`, enums, `char` and unions are not supported
yet.
Phase 3, in part: local randomness (§6.6: `resid_random_os`,
`resid_random_cpu` with RDSEED/RNDR, the hashed draw in lib/crypto.resid,
`random_secret`, `random_source`), challenge records (§6.5, runtime marks in
`runtime/rt/chal.resid`, `@opaque` E0276, record builtins E0277),
exportable records with `SpentStore` (§6.8), `challenge_with_key` and
`challenge_with_channel` with the TLS exporter (RFC 9266, checked against
RFC 8448's exporter master secret), `provisioned_key` and the `provision`
family (E0278 for the standard library), and E-key (`compiler/ekey.resid`,
E0270 as a warning). Differences decided while implementing: generic code
draws through a `Random(B)` behavior rather than a `w_random` verb on
`Word`; `@key_from` may name several parameters (HKDF-Extract keys on its
salt); `challenge_export` and `challenge_with_channel` also need
`declassify` (ciphertext and a hash of a secret are published values in
Resid's type system); keying annotations are on the function
(`@key(p, own)`), naming the parameter. E-key's analysis follows records
two levels deep and keeps up to four alternatives at a selection, meeting
them beyond that (it can only warn more); it still warns on the TLS
server's event loop. The nonce rule's constant half is in (E0279, a
warning: a constant nonce only under a key drawn in the same function,
outside loops and closures, for one sealing call; `random_bytes` is a
fresh source for this); a nonce from outside data is not checked yet. Not
yet in phase 3 (the challenge slot is in for `DevIn` requests: an
`InChallenge(request, at, n, challenge, evidence)` input the ioctl engine
fills, spending an issued record before the call and binding it to the
descriptor and evidence after, with `snp_report(challenge = ...)` as the
first wrapper; the evidence list is the wrapper's argument until typed
descriptors carry it): typed device
channels, `Challenge(N)` fields and the reply binding the device engines
make (`resid_chal_spend`/`resid_chal_bind` exist for them).
Phase 5, in part: inline `asm` in a native module stays allowed and is
recorded (`native_asm` in the provenance record, printed by `verify`);
the host is hardened instead (§9): its filter allows only the reply's
write and exit, it runs on a shadow stack where the CPU has one (CET,
GCS), and on AArch64 the module's code is built with PAC, BTI and GCS
compatibility and mapped `PROT_BTI`.
Exportable records live in `lib/challenge_export.resid`, apart from
`lib/challenge.resid`, so that a program which only issues and spends
records needs no `clock`. The standard library is compiled outside
dependency and attenuated-import sandboxes (`modules.md`, SECURITY.md), so
a device-only dependency is not charged for `declassify` code in
`crypto.resid` that it never calls.

**What changed from revision 2** (decisions of 2026-10-10, §15):

- **The runtime makes the challenge.** No program passes a nonce, a
  ticket or a receipt to a channel. A request field of type
  `Challenge(N)` is filled by the runtime on every call from a fresh
  nonce, and the reply carries an opaque challenge record. A verifier
  supplied value is an optional `challenge =` argument (§6.3).
- **Tickets, receipts and user-facing `Linear` are gone from the surface.**
  Single use of a nonce is a runtime invariant; single use of a freshness
  mark is checked by the compiler without the programmer writing `Linear`
  (attestation plan). General `Linear` and typestate are deferred to a
  later plan.
- **Integrity in this plan is two-valued**: `Internal` and `External`.
  `Verified`, `Appraised`, anchors, qualifiers, robust declassification
  and `assume` are attestation concepts and live there.
- **Labels are written only at sinks and declarations** (§2). Everything
  else is inferred.
- **No program-counter label** (§4.3). A `Secret` can never be a
  condition (spec §48, E0255), so confidentiality never reaches control
  flow. Integrity follows data *and selection*: a value chosen by an
  External condition is External. Whether code runs at all is checked
  only where it matters, for disclosure (attestation plan §5.4).
- **Keys must be unpredictable** (§5.2). A key or seed must be `Secret`
  and come from an unpredictable source through operations that keep it
  so; integrity alone cannot say whether the attacker knows a value.
- **No function contracts.** Revision 2's `requires`/`ensures` on
  functions are dropped: nothing in this plan, the device plan or the
  attestation plan rests on them. Layout fields keep their checks as one
  `@check` annotation (§7.1), and behavior conformance is label subtyping
  (§4.7). The file is renamed from `PLAN-labels-and-contracts.md`.
- **No new declaration kinds.** Revision 2's `format` and `channel`
  items are gone: a wire layout is an ordinary record `type` with
  `@layout`, and a channel is a `@descriptor` value as in revision 1.
  Fixed-width bytes are `Bytes(N)`.
- **Diagnostics are a requirement** (§4.6): source, path, sink; blame
  user code; a fix hint per code; a golden corpus of mistakes gates each
  phase; every new label error is a warning for one phase first.

**Goal**: one model for every place data enters or leaves a Resid program
(kernel devices, native modules, files, the network, the clock, randomness)
in which the compiler, not the author's discipline, enforces what may be
observed and that outside data is never mistaken for the program's own.
Bytes from outside are read only through generated, total parsers of
layout types, and every request that can carry a challenge carries a
fresh one without the programmer asking.

**What "guaranteed" means here.** As in `SECURITY.md`: every claim names
the code that enforces it and the test that fails if it breaks. Where the
design cannot guarantee something, it says so and why (§14).

---

## 0. Design in one paragraph

Nothing outside the program is trusted, the kernel included. Every value
carries, beside its knowledge state, two labels: **confidentiality**
(public or `Secret`) and **integrity** (`Internal` or `External`), and
key material carries a third property, **unpredictable**. Every
information-acquiring effect yields `External`. A `Secret` can never
decide control flow (spec §48), so confidentiality follows data only;
integrity follows data and the conditions that select a value. Bytes
cross the boundary only through **channels** (`@descriptor` values) and
are interpreted only by **layout types** (records with `@layout`, whose
parsers are generated, total and constant time over secrets). A request
field of type **`Challenge(N)`** is filled by the runtime with a fresh
nonce; a program that will check the answer holds a **challenge record**
no program can forge, which the attestation plan turns into freshness. Labels in behavior
signatures hold every implementation of a behavior to the same rules.
The integrity scale is open: the attestation plan adds levels
between `External` and `Internal` without changing this plan's rules.

## 1. Trust boundary

### 1.1 Internal and External

**Internal** is the program's own code and its `Known` values: they are in
the binary, which the build measures and signs (provenance).

**External** is everything else, with no exceptions: the kernel, devices,
firmware answers, native modules, files, the network, the clock, every
randomness source including the runtime's own (which is External but
unpredictable, §5.2), CPU feature reports (CPUID and ID
registers can be trapped and answered by the kernel or hypervisor), the
environment, arguments, standard input, the terminal, the display, other
processes.

What hardware evidence can vouch for, and the profiles that name whose
word a program relies on, are the attestation plan's subject (its §1).

### 1.2 Attacker

The attacker may: choose every External input, its timing and order; see
everything sent through a channel and the number, sizes and timing of
calls; replay, reorder, drop, delay or substitute any answer; roll back
stored state; set the clock; hide CPU features; refuse service or kill
the program.

### 1.3 Out of scope, stated

- Availability: an attack may stop the program; it must never make it
  accept outside data as its own.
- A running kernel's access to process memory. Wiping (§7.4) is hygiene
  against later observers, not a guarantee against the kernel.
- Side channels below the instruction level.
- Bugs in the compiler and runtime (the reviewed base, §11).

### 1.4 Prerequisites

Checked arithmetic must hold: the silent wrap of literal arithmetic
(`9223372036854775807 + 1` printing `MIN`) and of `rt` literals is fixed
first. Secret-mode processes do not dump core (done: `PR_SET_DUMPABLE` 0,
`RLIMIT_CORE` 0, abort by `exit_group`).

## 2. What the programmer writes

The design target is that ordinary code is unchanged and a device or
attestation wrapper reads like the code it replaces.

| Written by the programmer | Where |
|---|---|
| `Secret(T)` | where secrecy starts (as today, spec §48) |
| `declassify(x, "reason")` | the disclosure site, including a Secret channel argument (§5.1) |
| `@layout` types and `@descriptor` channels | the standard library (device ones are generated by `resid-devgen`) |
| `External(T)` | behavior signatures and declarations only |
| `@key_from(p)` | `lib/` only, on functions whose result is as unpredictable as parameter `p` (§5.2) |
| `@key`, `@key(own)`, `@key(own, provisioned)` | on the keying parameter of a primitive; wrappers are inferred (§5.2) |
| `@one_way(p)` | `lib/` only, on functions whose result may be published without disclosing parameter `p` (§5.2) |
| `provisioned_key(k, "reason")` | where a key supplied by an operator, a sealer or a parent process is used as a key (§5.2) |
| `challenge = Issued(c)` / `Verbatim(x)` | only when this program verifies the answer or a verifier fixes the value (§6.3) |

Never written: integrity labels in ordinary signatures (inferred, §4.4),
nonces, tickets, receipts, `Linear`. There is no program-counter label
to write or to read about in an error.

A device call before and after:

```resid
// revision 2
Linear(Ticket) t = ticket();
(SnpReportBytes r, Linear(Receipt) rc) = snp_report(t, rp_nonce, app_data)?;
// revision 3
SnpReportResp r = snp_report()?;                     // runtime challenge
SnpReportResp q = snp_report(challenge = Verbatim(kbs))?;
```

## 3. Dimensions

| Dimension | Question | Scale | Moves only through |
|---|---|---|---|
| Knowledge (spec §3.2) | When is it known? | `KNOWN` · `EFFECT` · `RESIDUAL` · `INVALID` | reduction |
| Confidentiality | Who may observe it? | public ⊑ `Secret` | `declassify` |
| Integrity | Who chose it? | `Internal` ⊒ `External` | nothing in this plan; the attestation plan's primitives |
| Unpredictability | Who could know it? | a count of unpredictable bytes, and their sources | only the sources and operations of §5.2 |

Integrity and unpredictability are separate questions. A constant key
compiled into the binary is `Internal` and predictable; a key from the
runtime's random source is `External` (the kernel supplied it) and
unpredictable; a key agreed with a peer mixes the peer's `External` input
and is unpredictable when this program's own part is. "Unpredictable"
means known at most to this program, the parties it chose to agree a key
with, and the sources it names (the kernel for `random_secret`, the
operator for a provisioned key). Whether an agreed peer is the right
peer is authentication, which the protocol checks (a certificate chain,
attestation), not this property.

**Integrity is open.** This plan defines only the two ends. The
attestation plan inserts `Verified(A)` and `Appraised(P)` between them,
with qualifiers; every rule here is stated so that it holds unchanged for
any level between the ends ("not `External`" where a rule needs trust,
joins as lattice joins). No program can raise integrity under this plan
alone.

**Relation to knowledge states.**

- An **information-acquiring** effect (a provider verb, a channel, a
  native module call, a source builtin, §4.1) yields `External`. Effects that
  are markers in the graph (`declassify`) keep their labels.
- A `KNOWN` value is `Internal` only if no External node's facts were
  used to reach it. Reduction records the nodes whose facts it discharged
  (spec §3.4); a derive edge carries their labels to the result
  (`if (v != 7) return; known(v)` is External).
- Labels are part of the hash-consing key and of the content hash, so two
  pure nodes with different labels are never shared.
- An `INVALID` node rejects the program; run-time failure is an error
  value (§8).

**Labels are not facts.** Facts may be dropped; labels never are.

**Canonical form.** Labels normalize to one set per type; `T` may not
itself be a label (E-label-nest).

## 4. Label checking

### 4.1 Sources: a total table

Every builtin and runtime entry has a label entry in one table; the build
fails if one is missing (E-label-unknown); there is no default entry.
The families, all `External`:

`args`, `environment`, `filesystem`, `network` (including raw TCP
builtins), `clock`, `terminal`, `display` (events), `process`, `git`,
standard input, randomness (the runtime's `random_bytes` and
`random_secret` included; their results are also fresh, and
`random_secret`'s unpredictable, §5.2), `device` (revision 1 verbs and channels), `native_<m>` (`@link`
calls),
CPU feature queries (`resid_cpu_has_*`, `resid_raw_cpuid_ab`), and the
`resid-debug` ptrace builtins.

**CPU feature dispatch** is declared *selection-equivalent*: a result
computed on the AES-NI or the software path chosen by a CPUID answer is
not made External by that choice (§4.3), because both paths compute the
same function and a lie only causes `SIGILL` (availability). Each such site is listed in the
reviewed base. `rt x` keeps `x`'s label.

### 4.2 Values

- An expression's label is the join of its operands' labels. A value
  chosen by a condition (§4.3) also takes the condition's integrity.
- **Containers** carry their elements' labels; retrieving never raises a
  label. A map with External keys is External, and a container whose
  length or order was chosen by External data is External (§4.3).
- **Closures.** Calling a closure value joins the closure value's own
  label into the result, so a closure chosen by an External condition
  (`f = if (ext) { () => 1 } else { () => 0 }; f()`) gives an External
  result.
- **Casts never raise integrity or drop `Secret`** (E-label-cast). Record
  literals and `using =` are checked by subsumption.
- **Spawn.** A `spawn` result is the join of everything the region read,
  and the tag of every spawn `Result` (`Ok` or `Err(RegionError)`) is
  External, because failure can be caused from outside (memory pressure,
  kills, host death).
- **Round trips stay External**: files and sockets are providers.

### 4.3 Selection, without a program-counter label

**Confidentiality needs no control tracking.** Jif-style program-counter
labels exist to stop a secret from leaking through *which way* a branch
went. Resid already forbids that at the source: a `Secret` may not be a
condition, `match` scrutinee, `&&`/`||` operand, loop bound, index, slice
bound, or the tag of an `Option` or `Result` (spec §48, E0253, E0255;
checked against today's compiler).

One public fact about a secret remains on purpose: a Secret sequence's
`.len()` is public (spec §48), and a program may branch on it. That is
sound only while a length can never be computed from secret values. Since
a Secret is never a loop bound, condition or slice bound, a program
cannot build such a length itself; the compiler must keep it so for
builtins too: any builtin whose result length depends on element values
(`filter`, `find`, de-duplication, splitting) refuses a Secret element
or predicate (E0255), with a conformance case per builtin.

**Integrity does.** An External value can steer a branch, and a branch
can turn outside data into a value built from constants:
`UInt(8) b = if (ext[i] == 1) { 1 } else { 0 };` copies an attacker's
bit. If `b` were Internal, any value could be laundered a bit at a time.
So a value **selected** by a condition takes the condition's integrity.
Bindings are immutable, so selection happens only where values from
different paths meet, and those places are few:

- the result of an `if` or `match` expression;
- a function's result, when its `return`s (including the error return
  of `?`) are chosen by a condition;
- a value carried around a loop, or a loop's count, when the condition
  that continues or stops it is External;
- the tag of an `Option` or `Result` built on such a path. The payload
  takes only the label of the value put in it, since only one path
  supplies it.

Code that merely runs after an exit (`if (c) return ...;` followed by
`Int x = 1;`) is not selected: `x` is the same whenever it exists.
*Whether* code runs is tracked only for disclosure, where it matters
(attestation plan §5.4); an attacker who can only stop a computation
affects availability.

The flow summary of §4.4 records which parameters select a function's
result as well as which reach it, so selection is checked across calls
without per-call analysis. A selection-equivalent CPU dispatch (§4.1)
does not select. A diagnostic names the condition: "chosen by outside
data at main.resid:12".

What this costs: an integrity error arises only at a sink that asks for
integrity (§5.2's nonce rule, and the attestation plan's sinks); ordinary
programs never see one. A disclosure stays visible through the
`declassify` capability, which every caller must grant (spec §48).

### 4.4 Label polymorphism

An unlabelled type in a signature is a fresh **label variable**. Each
function gets a flow summary: which parameters reach its result, which
select it (§4.3), and which keep its unpredictability (§5.2). An
explicit label (only at the places of
§2) is a bound checked by subsumption at every binding, field, argument,
return, cast, `using =` and instance signature. Generic copies are keyed
on the full labelled type, or checked through summaries, never once with
the first caller's labels. Existing programs compile unchanged: every
unlabelled signature becomes polymorphic, and only declared sinks can
fail.

### 4.5 After reduction

Reduction may specialize, trampoline and memoize. Labels are checked on
the source graph and **checked again on the residual graph** before
lowering, as E0261–E0264 already are (E-label-residual).

### 4.6 Diagnostics

Label errors decided whether Jif was usable; here they are a requirement
of every phase, not polish. Every label error, in this plan and the
attestation plan:

1. **Source, path, sink.** It shows the span where the value became
   External or Secret (with the provider or channel named), the shortest
   path of bindings and calls to the sink, and the sink's span. It never
   uses internal vocabulary: no "label variable", "summary", "copy" or
   "join".
2. **Blames user code.** The primary span is the first frame in the
   user's package, never inside `lib/` or a generic copy. Instantiation is
   shown as context ("in `total(Dec(4))`, called from `main.resid:8`").
3. **One fix hint per code.** Each error code carries a concrete `help`:
   verify with the named primitive, pass the Verified value, move the
   check into the decision, or (attestation) name an assumption.
4. **One error per root cause.** A source reaching many sinks is reported
   once, listing the sinks.
5. **Explainable after the fact.** `resid-why --label <expr>` prints the
   same source-path chain for any value, errors or not, and the language
   server shows a value's labels on hover.

```
error[E0270]: key could be known to someone else
  --> sealer.resid:22:30
   |
14 |   List(Secret(UInt(8))) raw = sev_guest.derive_key(sel)?;
   |                               -------------------------- the kernel supplied this (device: sev_guest.derive_key)
22 |   Sealed s = aead_seal(raw, nonce, data);
   |                        --- used as the key here
   = help: a key from the kernel is known to the kernel; generate one with
     `random_secret`, or accept this one with `platform_key` (attestation)
```

**The gate.** `tests/labels/mistakes/` holds realistic mistakes, each with
a golden diagnostic. A case passes only if the message names the source
and the sink, puts its primary span in user code, and fits a line budget
(15 lines unless the path is longer). A phase that adds an error code
cannot merge without its cases.

**Rollout.** Every new label error ships as a **warning** for one phase,
run over `lib/`, `tools/`, `examples/` and the sibling repositories
(`resid-datastar`, `resid-json`, `resid-serial`, `resid-book`). It is
promoted to an error once those are clean and the messages have been
reviewed against the corpus.

### 4.7 Behavior instances

A behavior's signature may carry labels (`External(T)`, `Secret(T)`). An
instance's signature must be a label subtype of the behavior's, checked
like any other binding (§4.4): results at least as External and as
Secret as declared (an instance may return a public value where the
behavior says `Secret`), parameters taken as declared or weaker. Its
capabilities stay within the behavior's (E0219, as today). The
attestation plan adds its integrity levels and `@decides` to the same
subtyping. Behaviors are declared by the libraries that use them.

## 5. Confidentiality: changes to `Secret`

`Secret(T)` (spec §48) is unchanged except:

1. **Into a channel is a declassification.** A Secret passed to a channel
   or a native module is disclosed to the other side. The binding declares
   the parameter Secret and the call site writes the argument as
   `declassify(k, "reason")` (graph effect `declassify.<reason>` with the
   site). Written directly in the argument position of a parameter
   declared Secret, it is a **disclosure argument**: the value stays
   Secret-typed inside the runtime (secret sections, wiping) and only the
   disclosure to the other side is recorded. Anywhere else `declassify`
   has today's meaning and yields a public value, which the runtime does
   not treat as secret. Any other Secret argument is refused (E0255, which
   already refuses a Secret provider argument).
2. **Keys and seeds must be unpredictable (E-key, E0270).** The key, seed
   or randomness parameter of a seal, encrypt, sign, MAC, KDF or
   key-generation primitive must be `Secret` and unpredictable, with at
   least min(key length, 32) unpredictable bytes. Integrity is the wrong
   test here: a constant compiled into the binary is Internal and known to
   everyone who has the binary, and a key agreed with a peer is External
   and still unknown to anyone but the peer.

   *Keying parameters.* A parameter is keying when it is annotated
   `@key` (the key, seed or randomness parameter of every library seal,
   encrypt, sign, MAC, KDF and key-generation function carries it, and so
   do `challenge_with_key` and `export_key`, §6.5, §6.8), or when it
   reaches a keying parameter of a callee. The flow summary (§4.4)
   records the second case, and the check is made at every caller, so a
   wrapper needs no annotation of its own. `@key(own)` and `@key(own,
   provisioned)` narrow which sources a parameter accepts (*own keys*,
   below).

   *Counting.* Unpredictability is a count of unpredictable bytes known at
   compile time, with the set of sources that supplied them. Bytes are
   counted by where they came from: each unpredictable source node in the
   graph (one `random_secret` call, one key agreement, one `platform_key`
   or `provisioned_key` call) supplies at most its own length, however
   many times its bytes appear, and a source node inside a loop counts
   once. A slice keeps the bytes it keeps (`k[0..1]` of a 32-byte random
   key has one); a concatenation has the distinct bytes of its parts, so
   `r ‖ r` counts `r` once; a `@key_from` result has the smaller of its
   source's count and its own length, so `sha256(r ‖ r)` of a 16-byte `r`
   has 16. A selection has the smallest count of its arms. One arm is
   ignored: an arm whose length is known to be zero (a failure value,
   such as the empty key `hpkeg_derive_keypair` returns when its search
   is exhausted), and only when the selected value reaches the keying
   parameter unchanged. Any operation between them that can turn an
   empty value into a non-empty one (a concatenation, padding, a
   `@key_from` function, which maps empty input to a fixed public
   output) gives the smallest arm's count, zero. Every keying primitive
   must refuse an empty key at run time. Counts are computed per
   specialization: a summary carries the count as a function of the
   call's `Known` arguments, so `hpkeg_generate_keypair(32)` draws
   `hpke_kem_nsk(32)` bytes, a known 32. A count the compiler
   cannot know (a slice with residual bounds, `random_secret(n)` with a
   residual `n`) is zero at a keying site. So `random_secret(1)` padded
   with zeros to 32 bytes is refused, and so is a 16-byte draw used
   twice.

   *Disclosure is per source byte.* A byte of a source node is
   **disclosed** once any copy of it reaches a public form by any path:
   `declassify`, a channel or native-module argument, a child process
   (an argument, the environment, a descriptor); directly, through
   slices and concatenations, or through a bijection (XOR, wrapping
   addition or subtraction with an operand that depends on no
   unpredictable value, as under *Kept by*; encryption, which XORs with a
   keystream drawn from a key, is therefore not a disclosure of its
   plaintext). A disclosed byte counts zero at every
   keying site in the program, before or after the disclosure, so
   sending `r` and then keying with `secret_bytes(r)` is refused, and so
   is keying with `sha256(r)` after `send(declassify(r))`. Flow summaries
   record, per parameter, whether a function discloses its bytes, so the
   check spans calls. A one-way image does not disclose its source: the
   result of a `@key_from` function, or of a `@one_way(p)` function
   (public-key derivation: `x25519g_public`, `ec_public_keyg`,
   `hpkeg_public_key`), may be published. But the image is itself a value
   that can be disclosed: a published `@key_from` result counts zero as
   a key, and equal calls (the same function on the same argument
   values) are one value, so publishing `sha256(r)` and keying with
   `sha256(r)` is refused, while keying with `hkdf(r, "a")` after
   publishing `hkdf(r, "b")` is not. `@one_way` is accepted only in
   `lib/`, and its claims are in the reviewed base (§11), like
   `@key_from`'s.

   *Own keys.* A value is **own** when every unpredictable byte in it
   comes from the runtime random source or `platform_key` and none is
   disclosed: no one but this program (and, for `platform_key`, the
   principal it names, which under the attestation plan's `in-guest`
   profile includes the measured kernel) can know it. A parameter marked `@key(own)` takes
   only own values, and `@key(own, provisioned)` also takes
   `provisioned_key` results. A key agreed with a peer is unpredictable
   but known to the peer, so it is never own: it may key a session with
   that peer, never vouch for this program to a third party.

   *Unpredictable sources* (the only ones):
   - the runtime's random source through `random_secret(n)` (§6.6),
     which returns `List(Secret(UInt(8)))`, so the bytes are never public
     (generic library code draws through the `Word` behavior's new
     `w_random(n)` verb, which is `random_secret` at a Secret byte type).
     `random_bytes(n)` stays public: its bytes are fresh, which nonces and
     challenges need, but never unpredictable for a key. Migration:
     `lib/tlsclient.resid`'s `secret_bytes(random_bytes(32))` and the
     `random_bytes` call in `hpkeg_generate_keypair` become
     `random_secret(32)` and `w_random(n)`;
   - a key agreement (`x25519g`, `ecdhg`, HPKE decapsulation) whose own
     private input is unpredictable, through a primitive that refuses
     low-order and off-curve peer points and an all-zero shared secret
     (otherwise the peer chooses the result);
   - the attestation plan's `platform_key`, which names whose word it
     rests on, and its `open_released`, whose result is unpredictable on
     the word of the sender its anchor pins (not own);
   - `provisioned_key(k, "reason")`, for a key an operator put in a file,
     a KMS or a configuration channel. Such a key is known to whoever
     provisioned it and to the kernel that read it, so this is a stated
     reliance, not a proof: it needs the `provision` capability family
     (granted like `declassify`, spec §48: spawn lists, sandbox ceilings,
     manifest bounds), records `provision.<reason>` with the site, and is
     listed by `residc verify`. It is refused in `lib/` except at the
     reviewed key-loading sites (`lib/tlskey.resid`, the driver's signing
     key, `tools/resid-pkg.resid`), each of which passes the reliance on
     to its caller's grant. Without it a TLS server could not use the key
     in its PEM file.

   *Kept by*: moving bytes (slices, concatenation, `secret(...)`
   wrapping, records and lists holding them); XOR, wrapping addition and
   wrapping subtraction with an operand that depends on no unpredictable
   value (a bijection keeps what the attacker cannot guess; `k ^ k` is
   excluded because its other operand depends on `k`), which is how the
   TLS and HPKE nonces (`iv ^ seq`) stay unpredictable; and the result of a
   library function annotated `@key_from(p)`, meaning "unpredictable when
   parameter `p` is" (hashes, HMAC, HKDF and the other KDFs).
   `@key_from` is accepted only in `lib/` and its claims are in the
   reviewed base (§11). AEAD decryption is not among them: a decrypted
   value is whatever the party that sealed it chose, whatever the
   decryption key, so a key opened from a blob or a released message is
   predictable. A program that relies on the sealer (a broker that
   released the key, its own earlier run) says so with `provisioned_key`.

   *Lost by* everything else: other arithmetic and bitwise operations
   (`k & 0` is predictable), disclosure (above), and a selection whose arms are not all unpredictable
   (`c ? random_key : constant_key`, counted as above). Every device, file, network and
   native-module result is predictable (the kernel or the other side saw
   it), and so is every `Known` value and every `rt` of one (E0250
   refuses a Known `Secret`, but `secret(rt [0, 0, ...])` is not Known).

   *Public copies.* The public `List(Int)` copies of keying entry points
   (`hpke_generate_keypair`, the public `aesgcm`/`hpke`/`ecdsa` signing
   and sealing functions) take keys that cannot be Secret. They are
   allowed only in tests (inline `test` blocks and `tests/`), where
   known-answer vectors need constant keys (E-key-public). Verification
   functions take public keys and are unaffected. Migration:
   `tools/resid-pkg.resid`'s key generation moves to a Secret seed, as
   the driver's already has.

   *Nonces.* A raw AEAD nonce parameter must be neither External, unless
   every byte of it comes from a runtime draw (`random_bytes` or
   `random_secret`; a nonce is public and needs to be fresh, not
   secret, so disclosure does not matter here), nor `Known` (a constant
   nonce reused on every run). Uniqueness under one key is not checked by the compiler:
   the library's stateful sealers (the TLS record layer, the HPKE
   context) build nonces from a counter, and the raw sealing function is
   for them (§14). One `Known` nonce is allowed: under a **single-use
   key**: one derived in the same function by a `@key_from` function
   whose key or salt parameter receives at least 32 runtime random bytes
   drawn there (the salt, say, under an unpredictable key), and which
   the compiler's
   linearity analysis shows reaches exactly one sealing call (not in a
   loop, a closure or a value copied into a spawn region). A key that
   seals once cannot repeat a nonce. The export token (§6.8) is sealed
   this way.

   The runtime's random source rests on the kernel: under a hostile
   kernel no program can do better on a machine without a CPU source, so
   refusing would only stop key generation there. The reliance is stated
   instead: the runtime reports at run time whether a CPU source
   contributed (`random_source()`), and `residc verify` lists every
   keying site and its unpredictable source.
3. **One-bit errors on secret data**, as `CtSame` already does.
4. **Layout fields that are Secret** take no `@check` or fixed value
   (E-layout-secret-check); comparisons over regions that
   contain Secret bytes use `ct_eq` and publish one bit, recorded.
5. **Wiping on every exit path** (§7.4).

Robust declassification (whether the attacker can choose *what* is
declassified) needs integrity levels above `External` to be useful and is
specified in the attestation plan.

## 6. Channels and the runtime challenge

This section uses revision 1's forms unchanged where they exist:
descriptors are values of `@descriptor` record types returned by
generated functions, a call is a provider verb (`device.ioctl(op, ...)`),
and every failure is a `DeviceError` naming the descriptor.

### 6.1 Channels

A **channel** is the only way bytes cross the boundary for a device or
another declared transport. It is a descriptor value (E0260 outside
`lib/dev/`), now typed by its request and reply layout types. `IoctlOp`
keeps revision 1's fields (the ioctl struct's size, its `fields` list,
the interface `version`), except that `write` becomes `effect` (device
plan R2.3). The generator writes it:

```resid
// lib/dev/uapi_sev_guest.resid (generated)
// effect: a report reveals nothing secret and changes no state
pub IoctlOp(SnpReportReq, SnpReportResp) snp_get_report_op() {
    return IoctlOp {.name = "sev_guest.snp_get_report", .path = "/dev/sev-guest",
                    .requests = [Request {.arch = X86_64, .number = 3223343872},
                                 Request {.arch = Aarch64, .number = 3223343872}],
                    .size = 32,
                    .fields = [Buffer(8, -1, 96, In, false), Buffer(16, -1, 4000, Out, false),
                               Status(24, 8)],
                    .effect = Observes, .version = Versioned(0, 1, 1), .stability = Uapi,
                    .evidence = ["report"]};
}
```

The ioctl struct around request and reply (`snp_guest_request_ioctl`:
version, two pointers, `exitinfo2`) is described by that descriptor data,
as in revision 1, never by a type the program sees: `Versioned(0, 1, 1)`
writes the message version, the two `Buffer`s carry the request and the
reply (their capacities, 96 and 4000, from the uapi `sizeof`), and the
one new `Field`, `Status(offset, width)`, turns a non-zero value into
`Kernel(name, value)` (the check revision 1 wrappers make by hand on
`exitinfo2`). `evidence` names the reply fields a verifier checks (§6.5);
it is new, and the generator takes it from the descriptor input list.

The verb takes the request value and returns the reply parsed under its
layout type (External, Secret per field):

```resid
Result(Resp, DeviceError) device.ioctl(IoctlOp(Req, Resp) op, Req request);   // provider verb
```

The other verbs (`transact`, `configfs_report`, `read_attr`,
`sequence`) take the same shape.

### 6.2 Challenge fields

A request field of type **`Challenge(N)`** is the slot the answering side
signs or MACs back (SNP `user_data`, TDX `REPORTDATA`, configfs `inblob`,
NSM `nonce`, TPM `qualifyingData`). At most one per request type.

To the program `Challenge(N)` is a builtin sum that says how to fill the
slot, never the bytes themselves:

```resid
type Challenge(N) = Runtime | Issued(ChallengeRecord) | Verbatim(List(UInt(8)));   // builtin
```

| Value | Field holds | Who can check the answer |
|---|---|---|
| `Runtime` | a fresh runtime value nobody keeps | no one; the slot is filled so it is never stale or attacker-chosen |
| `Issued(c)` | `challenge_value(c)`, from `challenge_issue` (§6.5); a record whose n is not N is `BadInput` before sending | the holder of `c`, for the reply to this call only |
| `Verbatim(x)` | `x` exactly (a length other than N is `BadInput` before sending) | whoever chose `x` |

What each value proves, locally and to a relying party, is the
attestation plan's subject. `x` may be External (a relying party's value
arrives over the network); it is not a key and E-key does not apply.

### 6.3 Wrappers

A wrapper takes the challenge as an ordinary defaulted parameter (spec
defaults and named arguments) and puts it in the request literal:

```resid
// lib/dev/sev_guest.resid
@requires(device(readonly))
pub Result(SnpReportResp, DeviceError) snp_report(Challenge(64) challenge = Runtime,
                                                  Int vmpl = 0, Int key_sel = 0) {
    return device.ioctl(snp_get_report_op(),
                        SnpReportReq {.user_data = challenge, .vmpl = vmpl, .key_sel = key_sel});
}
```

```resid
SnpReportResp r = snp_report()?;                               // device use: nothing to keep
SnpReportResp q = snp_report(challenge = Verbatim(kbs))?;      // a verifier chose the value
ChallengeRecord c = challenge_issue(64, tls_key_hash);         // this program will verify
SnpReportResp v = snp_report(challenge = Issued(c))?;
```

### 6.4 Failures

Every failure is a `DeviceError` (revision 1's sum, unchanged), so `?`
works as today:

- a request `@check` that fails: `BadInput(name, "<field>: <condition>")`,
  before anything is sent (what revision 1 wrappers return by hand);
- a reply `@check` that fails: `BadReply(name, "<field>: <condition>")`,
  or the constructor the check names, with the descriptor name supplied
  first: `@check(status == 0, Kernel(status))` gives
  `Err(Kernel("sev_guest.snp_get_report", status))`;
- a reply that does not parse: `BadReply`, or `TooLong` past capacity;
- an `Issued` record already used in a request, or past its lifetime:
  `BadInput`;
- the transport's own failures: `Absent`, `Denied`, `Kernel`, `Timeout`
  and the rest, as today.

### 6.5 Challenge records

```resid
ChallengeRecord challenge_issue(Int n, List(UInt(8)) bind = [], Int lifetime = 300);
List(UInt(8)) challenge_value(ChallengeRecord c);
```

`challenge_issue` asks the runtime for a fresh n-byte value, with
32 ≤ n ≤ 64 (anything else is refused: a short challenge can be guessed
ahead). The value is SHA-512 truncated to n bytes over
`"resid.challenge.v1" ‖ len(nonce) ‖ nonce ‖ len(bind) ‖ bind`, with a
fresh 32-byte runtime nonce (§6.6), where `bind` ties data into it (a
relying party's nonce, a protocol tag). The record holds the nonce,
`bind`, the value, its issue time on the monotonic clock, and, once
spent in a request, the descriptor that spent it and the SHA-512 of the
evidence that call returned (below). It is:

- built only by the runtime; no layout field, literal, cast or
  constructor can make one (E-layout-field: parsing External bytes must
  never forge one);
- used in at most one request (the runtime refuses a second, §6.4), and
  accepted at most once by a verifier (attestation plan);
- short-lived: a record not accepted within its lifetime (`lifetime`
  seconds, default 300) is refused by every
  verifier. The runtime keeps at most 65,536 outstanding records; past
  that the oldest is dropped and later refused, so an attacker who asks
  for challenges without answering costs bounded memory. Such an
  attacker can still push out records others are waiting on
  (availability only): the runtime does not know who asked, so a
  program that issues challenges for outside callers bounds each
  caller's issuance itself;
- held in runtime state shared by the whole process: spending and
  accepting are atomic across spawn regions and threads, and a record
  copied into a region is the same record;
- opaque except for `challenge_value`; nothing in it is secret;
- External in integrity. It means only "this runtime made this value".
  Checking that a signed or MAC'd answer carries it is a verifier's job.

A record leaves the process that issued it only as a sealed token
(§6.8), for a verifier that runs as several processes.

The same record serves a program checking its own device's answer
(`Issued(c)`) and a relying party checking someone else's (it sends
`challenge_value(c)`, the other side uses `Verbatim`). A record spent in
an `Issued` request is **reply-bound**: a verifier accepts it only with
the evidence that call returned. The evidence is the reply fields the
channel's descriptor names in its `evidence` list (descriptor data, like
the other transport facts; a descriptor whose request type has a
`Challenge` field names at least one, E-evidence-field): for SNP the
`report` buffer of `SnpReportResp`; for a TPM `Quote` or `NV_Certify`
the attestation structure and the signature; for a configfs report the
outblob and the auxblob. They are hashed as returned, each prefixed by
its length, in the list's order, and verifiers take the same fields in
the same order. Its value is public, so without this a
program could be handed another machine's report carrying the same value
(obtained from any guest that answers `Verbatim(x)` for an outside `x`)
and take it for its own device's.

An attester whose answer should be bound to its own key or its own
connection puts one of these in the slot instead of the bare value
(library functions in `lib/challenge.resid`):

```resid
Result(List(UInt(8)), DeviceError) challenge_with_key(List(UInt(8)) value, Int kem,
                                                      @key(own) List(Secret(UInt(8))) sk);
List(UInt(8)) challenge_with_channel(List(UInt(8)) value, ChannelExporter e);
```

`challenge_with_key` derives the public key from `sk` itself
(`hpkeg_public_key(kem, sk)`), refuses a KEM `hpke_kem_ok` rejects or a
key that yields no public key with `BadInput("challenge_with_key", why)`
(its result fills a device request, so a refusal is a request that is
never sent), and otherwise returns SHA-512 truncated to the
value's length over `"resid.challenge.key.v1" ‖ len(value) ‖ value ‖ kem
‖ len(pk) ‖ pk`, with `kem` as two bytes, so a key is bound only for the
KEM it was made for. It never takes a public key, and `sk` must be own
(§5.2): a program can bind only a key it generated or the platform
derived for it, never a constant, a key handed to it or provisioned, or
a key agreed with someone (who would know it), and so never a key
anyone else holds. The attester sends its public key alongside; a wrong one
fails verification.

`challenge_with_channel` returns SHA-512 truncated to the value's length
over `"resid.challenge.channel.v1" ‖ len(value) ‖ value ‖ len(x) ‖ x`,
where `x` is the TLS exporter value (RFC 9266, 32 bytes) of the
connection `e` was taken from. `ChannelExporter` is opaque, built only by
`tlsserver_exporter(TlsConn c)` (`lib/tlswire.resid`) and
`tlsclient_exporter(TlsClient c)` (`lib/tlsclient.resid`) for a
connection whose handshake this process completed, so the attester
always binds its *own* connection. Today `TlsConn` and `TlsClient` are
plain records that any code could build, and the TLS library does not
derive the exporter master secret; this plan makes both types opaque
outside `lib/tls*.resid` and adds the exporter secret to `TlsKeys` as a
Secret field.

The attestation plan's verifiers recompute both from the public key or
from their own side's `ChannelExporter` (its §7).

A nonce is drawn fresh for every record and every `Runtime` call (§6.6);
a call that timed out or whose helper died still spent its own.

### 6.6 Local randomness

- Every draw is `SHA-512(len(k) ‖ k ‖ len(c) ‖ c)` truncated, where `k`
  is 32 bytes from `getrandom` with flags 0 (it blocks until the kernel's
  pool is ready; never `GRND_INSECURE`) and `c` is 32 bytes from a CPU
  source when one is available, so either source alone suffices and
  neither can cancel the other. There is no `/dev/urandom` fallback for
  challenges or keys (today's `resid_crypto_random_byte` has one; it
  becomes an error value): a process denied `getrandom` gets no
  randomness rather than possibly unseeded randomness.
- The CPU source is `RDSEED` on x86-64 and `RNDR` on AArch64, used only
  when CPUID / `AT_HWCAP2` says it is present (a hidden source is
  recorded as absent, the same outcome as a fault), 64-bit form only
  (16- and 32-bit `RDSEED` return zero with success on some AMD Zen 5
  parts), with bounded retry; exhaustion, zero or a repeat means "no CPU
  source". The outcome goes into the challenge record and is reported by
  `random_source()` at run time.
- **No state in user space.** Nothing is seeded once and stretched: each
  draw asks the kernel, so a forked child cannot repeat its parent's
  nonces or keys, and a restored VM snapshot repeats only what the
  kernel's own generator repeats.
- CPU randomness helps against the host, never against the guest kernel.
  The same source backs `random_bytes` and `random_secret` (§5.2).

### 6.7 Single use without `Linear`

A nonce is 32 bytes drawn fresh for its call (§6.6), so two calls share
one only by chance, in one process or across restarts and forks. A record's single use is the runtime's spent mark (§6.5), set
before the helper starts, so a crash, timeout or kill cannot let a record
serve twice. The user-visible `Linear`, `Ticket` and `Receipt` of
revision 2 are not part of the language in this plan.

### 6.8 Exportable records

A verifier that runs as several processes or machines (a load-balanced
broker, a login service, a webhook receiver, a TPM or NSM verifier) can
issue a challenge in one process and check the answer in another. A
record leaves its process only as a sealed token:

```resid
type ExportKey;                                                   // builtin, opaque
ExportKey export_key(@key(own, provisioned) List(Secret(UInt(8))) k);
@requires(clock(readonly))
Result(List(UInt(8)), ChallengeError) challenge_export(ChallengeRecord c, ExportKey k);
@requires(clock(readonly)) @needs(SpentStore(S))
Result(Imported(S), ChallengeError) challenge_import(List(UInt(8)) token, ExportKey k, S store);
@requires(clock(readonly))
Result(ReplayableRecord, ChallengeError) challenge_import_unspent(List(UInt(8)) token, ExportKey k);

type Imported(S) = { ChallengeRecord record; S store; };
type ChallengeError = Malformed | Forged | Expired | Spent | NotExportable;

behavior SpentStore(S) {
    Result(S, Str) spend(S s, List(UInt(8)) id, Int expires_unix);   // Err once spent
}
```

**The key.** `export_key` takes 32 bytes that are own or provisioned
(§5.2); a key agreed with a peer is refused, since the peer could mint
tokens. All the verifier's processes must hold the same key,
so where it comes from decides what the token proves:

- in a TEE on one machine, `platform_key` (attestation plan): only the
  measured verifier can mint or open tokens. The derivation is per chip
  (VCEK-rooted on SNP), so processes on different machines derive
  different keys and need a released key instead. A key a broker released to the
  attested verifier arrives by decryption, so it enters through
  `provisioned_key` like any opened key (§5.2), naming the broker;
- outside a TEE, `provisioned_key(k, "reason")` (§5.2): whoever
  provisioned the key, and the hosts that hold it, can mint tokens, and
  `residc verify` says so;
- processes that share a parent: the parent draws the key with
  `random_secret` and hands it to its children through an argument, the
  environment or a descriptor, which discloses it (§5.2), so the parent
  too uses it only through `provisioned_key`. Those bytes are External and predictable
  on arrival (§5.2), so each child passes them through
  `provisioned_key(k, "export key from the parent")`: a stated reliance
  on the parent and on the kernel that carried them.

**The token.** `challenge_export` writes the record's nonce, `bind`, its
expiry as wall-clock time (issue time plus the lifetime, read from the
clock, hence `clock(readonly)`), and a format version, sealed with
AES-256-GCM under a per-token key `HKDF-SHA256(k, salt = t, info =
"resid.challenge.export.v1")`, where `t` is 32 fresh runtime bytes sent
in the clear with the token, and a zero nonce (each per-token key seals
once: the single-use-key rule of §5.2). The value is recomputed on
import, never trusted from the token. `challenge_import` refuses a token
that does not open (`Forged`), does not parse (`Malformed`), or is past
its expiry (`Expired`). An imported record is a record like any other,
except that it serves only a verifier: it cannot fill an `Issued` request
(the issuing process already chose how the challenge goes out).

`challenge_export` refuses a record already spent in a request or
accepted (`NotExportable`), and marks the record exported, atomically
with the spend and accept marks (§6.5): from then on
the issuing process can neither spend it in a request nor accept it,
except through an import of its own token, which goes through the store
like any other. So every acceptance of an exported record, in any
process, passes the store, and an exported record never carries a reply
binding it could lose.

**Single use needs shared state.** A token alone cannot stop a replay:
within its lifetime the same token can be presented to two processes.
So `challenge_import` spends the record as it imports it: after the token
opens and its expiry checks, it calls `spend` once, with
`SHA-256(nonce)` and the expiry, and returns `Spent` on `Err`. On `Ok` it
returns the record together with the store `spend` returned, so a store
that is a value (the in-memory instance) carries its spends forward. The
call is the caller's: the instance's `@requires` become the caller's, as
for any behavior instance reached from it, so a database instance needs
`network` at the call, never inside a `lib/verify/` primitive. The
imported record is then held in this process like any other. The
runtime also keys imported records by nonce and refuses a second import
of the same token in one process (`Spent`), whatever the store does (a
store that is a value can be copied, and a copy forgets), so the
runtime's accept mark (§6.5) stops a second acceptance here while the
store stops one in another process. A token imported with bad evidence
is used up; whoever can see the token can do that, but could equally
drop the message. Spending must be atomic in the store: two processes
spending the same id must see exactly one `Ok`. That is the instance's
contract, and its correctness is a stated reliance, listed by `residc
verify` with the instance's type. `lib/` ships the behavior and an in-memory instance for tests; a
directory instance waits for an exclusive-create file verb, which the
`filesystem` provider does not have today; a database or a TPM counter
is an application's instance. The contract also bounds time: the store
keeps its own high-water mark, the latest reading of the store's own
clock, which never decreases and never takes an importer's time, refuses a
`spend` whose `expires_unix` is not after it, and drops an entry only
once its expiry is behind that mark. So an importer whose clock was
rolled back cannot get an id accepted after the store has forgotten
it.

A record from `challenge_import_unspent` has no store: its single use is
unchecked across processes. It has its own type, `ReplayableRecord`
(builtin, opaque like `ChallengeRecord`), so the difference is static:
the attestation plan's verifiers take it only in their replayable form,
whose result is `Delivered` and never satisfies a decision. Uses that can
tolerate a replay within the lifetime (a login nonce whose use is also
bound to a session) may still check it.

**What the attacker can do** is stated: a holder of the key can mint
tokens; a store that is rolled back (a restored database) reopens replay
within the lifetime; and the wall clock that bounds the lifetime is the
kernel's. The clock only shortens or stretches the window, within what
the store's high-water mark allows: a token is still bound to its own
nonce and `bind`.

## 7. Layout types

### 7.1 Declaration

A **layout type** is an ordinary record `type` with `@layout(c_abi)`,
`@layout(be)` or `@layout(le)`, written with the ABI's field names. The
compiler generates its serializer and its total parser; nothing else
reads its bytes. Literals name every field, as for any record.

```resid
// lib/dev/uapi_sev_guest.resid (generated)
@layout(c_abi)
type SnpReportReq = {
    Challenge(64) user_data;
    @check(vmpl <= 3) UInt(32) vmpl;
    @check(key_sel <= 2) UInt(32) key_sel;   // firmware ABI; uapi calls these bytes rsvd
    @reserved(24);
};

@layout(c_abi)
type SnpReportResp = {
    @check(status == 0, Kernel(status)) UInt(32) status;
    @check(report_size <= 4000 - 32) UInt(32) report_size;
    @reserved(24);
    @len(report_size) List(UInt(8)) report;  // the signed report, parsed by a verifier
};
```

Annotations (new parser surface, accepted only inside `@layout` types):

| Annotation | Meaning |
|---|---|
| `@check(e)` / `@check(e, Ctor(args))` | request field: holds before sending, else `BadInput`; reply field: holds while parsing, else `BadReply` or the named `DeviceError` constructor (§6.4) |
| `@len(f)` | length from an earlier field `f`; the one dependent length |
| `@reserved(n)` | n bytes that no ABI on the path defines; not a field, so literals never name it; sent as zero, ignored in a reply |

Facts about the transport (buffer capacities, the ioctl struct, versions,
status words) are descriptor data the generator writes, not annotations.

**Bits inside a word are plain shifts and masks.** There are no bit
fields: a word an ABI packs is one integer field, its rules are `@check`s
written with `& | << >>`, and the wrapper composes or splits it. A failed
check's message quotes the condition, so the error names the rule even
though it names the word. (Device plan R2.2a declares SNP's MSG_KEY_REQ
this way.)

Field types: integers, `Bytes(N)` (N bytes inline; never converted to a
heap `Bytes`, so zeros inside are kept, spec §44), `List(UInt(8))` with
`@len`, other layout types, and `Challenge(N)` in requests.

Every layout type gets two generated functions named after it, as
revision 1's generated layout functions are (`snp_report_req_size()`):
`Result(SnpReport, DeviceError) snp_report_parse(List(UInt(8)) bytes)`
(total) and `List(UInt(8)) snp_report_bytes(SnpReport r)`. A type with a
Secret field takes and returns `List(Secret(UInt(8)))` instead. A request
type with a `Challenge(N)` field gets no `_bytes`: only the verb
serializes it, since filling the slot draws or spends a nonce. Device replies
are parsed by the verb; a verifier parses signed bytes it received (the
SNP report above is plain bytes here, parsed later under the attestation
library's `SnpReport`), so device access does not depend on the
attestation plan.

### 7.2 Rules (each a compile error)

1. Structure is public: lengths, counts, tags, selectors and offsets
   cannot be Secret.
2. Lengths look backward and are bounded; nesting depth is bounded;
   parsing is linear time with no backtracking. Generated parsers are
   loops or tail calls with fixed memory; exceeding the memory budget
   while parsing is an error value, never an abort (tested at the maximum
   size of every layout type).
3. Reply `@check`s run while parsing; status and firmware error words are
   declared with them.
4. At most one `Challenge(N)` field per request type; none in a reply.
5. Secret fields: no checks (§5.4); their serializer feeds only a channel
   parameter declared Secret.
6. No field may have a challenge record or any other runtime-built type
   (E-layout-field): `ChallengeRecord`, `ReplayableRecord`, `ExportKey`
   and `ChannelExporter` here, and the attestation plan's
   `EvidenceTime`, `ChannelSealed`, `Anchor` and integrity-only types.
   No literal, cast or constructor outside the runtime and the defining
   library builds one either.
7. Layouts:
   - `c_abi`, per target, computed by the compiler and cross-checked
     against clang by `resid-devgen` for both targets, with a test for
     each of: flexible array members (`offsetof` below `sizeof`), tail
     padding, enum size by range, `_Bool` (only 0 or 1 accepted), `char`
     signedness (signed on x86-64, unsigned on AArch64), untagged unions
     as overlapping views, and padding bytes (sent as zero, ignored in a
     reply; bytes an ABI defines as reserved are `@reserved`, §7.1). No bit fields (a packed word is one integer
     field checked with shifts and masks, §7.1) and no packed structs.
   - Buffer capacity comes from the uapi `sizeof`, never from the parse
     view; `@check`s on lengths are relative to capacity.
   - `be` / `le`: packed, in that byte order.

### 7.3 What layout types replace

Hand-written parsers of untrusted input: device descriptors and wrappers,
`tpm_wire`, the SNP certificate table parser. DER, CBOR and TLS record
parsing follow once a layout form for their encodings is designed; none
is specified here. Each is replaced only after the generated code matches it
byte for byte on its existing tests.

### 7.4 Wiping

- Secret mode: no core dumps (§1.4).
- **Stack bleaching at boundaries** instead of per-frame scrubbing (which
  would break tail calls and is skipped by aborts that unwind): at every
  `declassify`, channel call, region exit and abort landing, zero the
  stack from its floor to the current stack pointer minus the red zone,
  then clear vector registers. Each spawn region's stack is bleached at
  that region's exit, so other threads' stacks are covered. Lowering
  carries a "touches secret" bit per function so only programs and paths
  that need it pay.
- Region and arena pages that held a Secret are zeroed before they are
  reused or returned to the kernel.
- Helper processes wipe the request mapping, struct and command regions
  as well as secret regions; helpers killed by timeout, guard page or
  seccomp cannot wipe, so the guarantee there is "no core, no ptrace"
  (dumpable 0, `RLIMIT_CORE` 0).
- All of this is hygiene against later observers; a running kernel can
  read memory (§1.3).

## 8. Failure

A refusing, timed-out or killed channel, a rejected parse and a failed
reply `@check` all produce error values, and none produces a partial
value: a rejected parse has no value. Errors from External sources are
External.

## 9. Native modules

Foreign code is reached only through native modules (`@link`, spec §47,
`PLAN-native-modules.md`): IR linked into the measured binary (own
symbols, intrinsics and `mem*` only; no constructors, thread locals or
module asm), each call in a fresh seccomp-confined copy of the program.
There is no dynamic loading: a library loaded at run time is code the
kernel can substitute. This plan adds only labels to them:

- every `@link` result is External;
- a Secret argument is a declassification, written `declassify(k,
  "reason")` (§5.1), where today it is refused outright (E0255);
- inline `asm` in a module's functions is allowed and recorded, not
  refused (decided 2026-10-11): it runs only in the confined host, and a
  refusal would not be a boundary, since native code can reach the
  program's own system-call instructions without asm. The host is
  hardened instead: a filter allowing only the reply's write and exit,
  a shadow stack (CET, or GCS on AArch64), and on AArch64 return signing
  and BTI landing pads on the module's code, mapped `PROT_BTI`.

What is not enforced, and stated: what the module's code does inside,
and a module that returns key material as plain bytes. Such bytes are
predictable (§5.2), so E-key stops them from keying a primitive.

## 10. Knowledge

Layout types, fields and their checks, labels, channels, challenge
fields, call sites, `declassify` sites and `secret(x)` of External
data are graph nodes.
`residc verify` prints, for a binary: every `declassify` with its reason;
every channel and native module symbol; every challenge call site with its
`Challenge` form; every keying site with its unpredictable source;
every `provisioned_key` site; every `challenge_import` site with its
`SpentStore` instance, and every `challenge_import_unspent` site;
selection-equivalent CPU dispatch sites; and, for a build made while a
label error was still a warning (§4.6), which checks were warnings. The
provenance record carries that label mode, so such a build is never
presented as checked. The attestation plan adds its own entries.

## 11. Reviewed base

The compiler and runtime (checked by the self-hosting fixed point,
provenance and the suites), the runtime nonce source, generated parsers,
the selection-equivalent dispatch sites, the `@key_from` and
`@one_way` claims in `lib/`, the key-agreement primitives' point checks
(§5.2), and the opacity of `TlsConn`, `TlsClient` and `ChannelExporter`
(§6.5).

## 12. Spec changes

- New law 15: *Nothing external is trusted; only outcomes are verified.*
- §3.2: labels beside knowledge states; information-acquiring effects are
  External; labels in hash-consing and content hashes.
- New sections: integrity labels (two-valued, open, data flow and
  selection), unpredictability (`@key`, `@key(own)`, `@key_from`,
  `@one_way`, per-byte disclosure, `random_secret`), label polymorphism, label
  diagnostics, `provisioned_key` and the `provision` family, exportable
  challenge records and `SpentStore`, layout types (`@layout`,
  `@check`, `@len`, field annotations), channels with `Challenge(N)`,
  the descriptor's `evidence` list and the runtime nonce,
  `challenge_with_key` and `challenge_with_channel` with `ChannelExporter`,
  labels on native modules. §48 gains
  §5's rules.
- Error codes from E0270 upward (E0260–E0265 are taken).

## 13. Phases

0. Prerequisites: checked literal arithmetic; literal ranges. (Secret
   mode without core dumps is done.)
1. Integrity labels: the source table, propagation, label polymorphism,
   residual re-check, `resid-why --label`, the diagnostics corpus. No
   sinks yet; tests assert labels through `resid-why`.
2. Layout types: layouts, rules, generated parsers; existing parsers as
   oracles.
3. Channels: typed descriptors, `Challenge(N)`, `challenge_issue`, the runtime
   nonce and its source, challenge records, `@check` errors as
   `DeviceError`. E-key (§5.2: counting, disclosure, own keys,
   `random_secret`, `provisioned_key`), which exportable records (§6.8),
   with the in-memory `SpentStore`, and `challenge_with_key` need;
   `challenge_with_channel` with the TLS exporter and opaque connection
   types.
4. Behavior instance subtyping (§4.7); the other Secret rule changes
   (§5) and wiping (§7.4).
5. Labels on native modules (§9).

The device plan's revision 3 needs phases 1–3. The attestation plan
starts after phase 3.

Each phase lands with conformance tests for every error it introduces, a
`SECURITY.md` row per guarantee, and a deep security review before merge.

## 14. Holes considered

| Attack or failure | Closed by | Residual risk |
|---|---|---|
| Outside data mistaken for the program's own | every acquiring effect External; total source table (§3, §4.1) | new builtins must be specified |
| Laundering through casts, spawn failure, facts, hash-consing | cast rule, spawn tags, fact labels, label in hash key (§3, §4.2) | none |
| Laundering outside data through a branch on it, a bit at a time | selection takes the condition's integrity, across calls by flow summaries (§4.3) | none |
| Secret leaks through which way a branch went | a Secret is never a condition (spec §48, §4.3) | none |
| Secret leaks through a sequence length | lengths are public by construction; value-dependent-length builtins refuse Secret (§4.3) | a builtin added without its case |
| Short key padded to full length | compile-time count of unpredictable bytes (§5.2) | none |
| Short draw repeated to look long (`r ‖ r`, `sha256(r ‖ r)`) | bytes counted once per source node (§5.2) | none |
| Random bytes published, then used as a key from another copy | disclosure is tracked per source byte across copies, slices, bijections and calls (§5.2) | none |
| An empty arm padded or hashed into a constant key | the zero-length arm is ignored only when it reaches the keying parameter unchanged (§5.2) | none |
| Key agreed with an attacker used to vouch for this program | `@key(own)` on `challenge_with_key`, own or provisioned on `export_key` (§5.2, §6.5, §6.8) | none |
| Token replayed after the store forgot it, under a rolled-back clock | the store's high-water mark refuses expired ids (§6.8) | the store's correctness |
| One token imported twice in one process | the runtime refuses a second import by nonce (§6.8) | none |
| A published hash of a random value reused as a key | images are values: equal calls are one value, and a published image counts zero (§5.2) | none |
| Random bytes used publicly first, then as a key | keys draw only through `random_secret`, whose bytes are never public (§5.2) | none |
| Random nonce refused as disclosed | nonces need only fresh bytes from a runtime draw (§5.2) | none |
| Evidence spread over several reply fields (TPM, configfs) | `evidence` lists every field, hashed in order (§6.1, §6.5) | none |
| Store high-water mark moved by an importer's clock | the mark is the store's own clock (§6.8) | the store's clock |
| Multi-machine verifier relying on a per-chip platform key | stated: `platform_key` serves one machine; others use a released key (§6.8) | none |
| E-key needed before it exists | E-key lands in phase 3 with the records that use it (§13) | none |
| Key chosen by whoever sealed it, passed off as unpredictable | AEAD decryption is not `@key_from`; opened keys enter through `provisioned_key` (§5.2) | whoever sealed it, listed |
| Program binds a public key it does not hold | `challenge_with_key` derives the public key from a keying `sk` (§6.5) | none |
| Party in the middle relays a channel-bound challenge to a genuine attester | the attester binds its own connection's exporter (`challenge_with_channel`, §6.5) | none |
| Closure chosen by outside data | calling a closure joins its label (§4.2) | none |
| Wrapper or closure hides a disclosure | the `declassify` capability reaches every caller (spec §48) | who controls *whether* it runs: attestation §5.4 |
| Label errors too hard to act on | diagnostic rules, corpus gate, warning-first rollout (§4.6) | message quality on paths outside the corpus |
| Device- or file-supplied key used as a secret | E-key: keys must be unpredictable (§5.2) | keys from `random_secret` rest on the kernel when no CPU source exists; reported by `random_source()`, sites listed by `residc verify` |
| Constant key or nonce compiled into the binary | Known values are predictable; public keying copies only in tests; Known nonces refused (§5.2) | none |
| Peer chooses an agreed key (low-order point) | key-agreement primitives refuse low-order, off-curve and all-zero results (§5.2) | reviewed base |
| AEAD nonce reused under one key | stateful library sealers build nonces from counters (§5.2) | a program calling the raw sealing function with its own counter |
| Error oracle on secrets | one-bit errors, no checks on Secret fields (§5.3–5.4) | none |
| Secret leaked to the kernel via a channel | declassification at the call site (§5.1) | intended disclosures |
| Programmer forgets, reuses or predicts a nonce | the runtime draws every nonce from the kernel per call; single use of a record is a runtime mark (§6.5, §6.7) | none |
| Nonce or key repeated after fork or snapshot | no randomness state in user space (§6.6) | what the kernel's generator repeats after a snapshot |
| Guessable challenge | 32 ≤ n ≤ 64 (§6.5) | none |
| Challenges requested and never answered | lifetime and a cap on outstanding records (§6.5) | pending records pushed out by a flood (availability); callers bounded by the program |
| Two regions accept one record | process-wide atomic spent mark (§6.5) | none |
| Forged or altered exported token | AEAD under the export key, value recomputed on import (§6.8) | holders of the key; with a provisioned key, whoever provisioned it |
| Exported record accepted both in its issuing process and through its token | export refuses a spent or accepted record and marks it exported, so every acceptance passes the store (§6.8) | the store instance's correctness |
| Exported token replayed to another process | atomic `spend` in a shared `SpentStore`, at import (§6.8) | the store instance's correctness; a rolled-back store reopens replay within the lifetime |
| Token accepted long after issue | wall-clock expiry sealed in the token (§6.8) | the kernel's clock moves the window |
| Key from a file or KMS used as unpredictable | only through `provisioned_key`, a capability and a listed reliance (§5.2) | whoever provisioned the key |
| Kernel picks local randomness or hides RDSEED | hash combine of both sources; outcome in the record and `random_source()` (§6.6); what that means for freshness is the attestation plan's | depends on profile |
| Unseeded randomness early in boot | blocking `getrandom`, no `/dev/urandom` fallback (§6.6) | none |
| Forged challenge or record from parsed bytes | runtime-built only, no layout field (§6.2, §6.5, §7.2 rule 6) | none |
| One answer accepted for another channel | the record stores the descriptor that spent it, and a verifier refuses a record spent on another (§6.5; attestation §6.1) | `Verbatim` calls, where the relying party's `bind` keeps protocols apart |
| Core dumps of secrets | done (§1.4) | none |
| Secrets left on the stack or in freed memory | bleaching at boundaries and region exits, zeroing secret pages before reuse (§7.4) | a running kernel |
| Secret bound first, then passed to a channel | only a disclosure argument keeps runtime secrecy; a bound `declassify` is public (§5.1) | none |
| Parser hang, crash or memory exhaustion | §7.2 rules 1–2 | none in generated parsers |
| Foreign code substituted at run time | native modules only, linked IR (§9) | the module's internals |
| Integer wrap in a check or length | prerequisite (§1.4) | none once fixed |
| Compiler or runtime bug | reviewed base (§12) | inherent |

Revision 2's review findings (its §17) are mapped in the attestation
plan's §14, with the sections of this plan that now hold the core ones.

## 15. Decisions and open questions

Settled for revision 3 (2026-10-10):

1. The runtime fills every `Challenge(N)` field from a fresh nonce; no
   program passes a nonce, ticket or receipt.
2. `Challenge(N)` is the sum `Runtime | Issued(c) | Verbatim(x)`; a
   wrapper takes it as `Challenge(N) challenge = Runtime`. A program that
   verifies holds the record from `challenge_issue`; replies carry
   nothing extra (no `Reply` wrapper).
3. Tickets and receipts are hidden; single use is a runtime invariant;
   user-facing `Linear` and typestate are deferred to a later plan.
4. No separate purpose: `challenge_issue(n, tag)` separates protocols
   (`app_data` is its `bind` argument), and the record stores the
   descriptor that spent it.
5. Labels are written only at sinks, declarations and `lib/verify/`;
   everything else is inferred.
6. Integrity here is `Internal` / `External`; `Verified`, `Appraised`,
   qualifiers, robust declassification, `assume`, freshness, identity,
   rollback and the transcript move to `PLAN-attestation.md`.
7. Local randomness mechanics stay here (every challenge call uses them).
8. No program-counter or begin labels. Confidentiality follows data only,
   since a Secret is never a condition; integrity follows data and
   selection (§4.3). Whether code runs is checked only for disclosure
   (attestation plan §5.4).
9. Diagnostics: source, path, sink; blame user code; a fix hint per code;
   a golden corpus gates each phase; warning for one phase, then error.
10. No function contracts; layout fields use `@check(e[, Ctor(x)])`;
    behavior conformance is label subtyping.
11. No `format` or `channel` keywords: layout types are record `type`s
    with `@layout`, channels are `@descriptor` values. Fixed-width bytes
    are `Bytes(N)` (never converted to heap `Bytes` inside a layout).
12. Revision 1's forms carry over: descriptors from generated functions,
    typed now (`IoctlOp(Req, Resp)`), with an `effect` field; the verb
    returns `Result(Resp, DeviceError)`; `@check` failures are
    `DeviceError` constructors with the name supplied first.
13. A Secret channel argument is written `declassify(k, "reason")`
    directly in the argument position (a disclosure argument).
14. No bit fields: a packed word is one integer field; its bit rules are
    `@check`s with shifts and masks, and the wrapper composes it.
15. Layout annotations are only `@check`, `@len` and `@reserved`;
    transport facts (capacities, the ioctl struct, versions, status
    words) are descriptor data.
16. No `foreign` keyword: native modules (`@link`) are the one FFI, with
    External results and Secret arguments by `declassify`.
17. Keys and seeds must be Secret and unpredictable (E-key); integrity is
    not the test. `random_secret` is External and unpredictable
    (`random_bytes` only fresh); when no
    CPU source contributed, the reliance on the kernel is reported, not
    refused.
18. Randomness keeps no state in user space: every draw hashes fresh
    `getrandom` output with a CPU source's, with no `/dev/urandom`
    fallback.
19. Challenge records: 32 to 64 bytes, a lifetime, a cap on outstanding
    records, a process-wide atomic spent mark; request types with a
    challenge field have no generated `_bytes`.
20. `challenge_with_key(value, kem, sk)` binds an attester's own key
    (the public key derived from a keying `sk`, the KEM included) and
    `challenge_with_channel(value, e)` its own connection's TLS exporter
    into a challenge value; a record spent in an `Issued` request is
    bound to the reply field its descriptor names as evidence.
21. Records leave their process only as sealed tokens (`challenge_export`
    / `challenge_import`) under an `ExportKey`; single use across
    processes goes through an atomic `SpentStore`, spent at import in the
    caller's code, and a record imported without one has unchecked single
    use. Exporting refuses a spent record and marks the record exported.
22. Keys provisioned by an operator, opened from a sealed blob, or handed
    over by a parent process are usable only through
    `provisioned_key(k, "reason")`, under the `provision` capability
    family, and listed.
23. Keying parameters are marked `@key` or inferred through flow
    summaries; unpredictable bytes are counted once per source node and
    per specialization, and a byte disclosed anywhere counts zero
    everywhere. `@key(own)` takes only random or platform-derived keys.
24. A `Known` nonce is allowed only under a single-use key.
25. Keys draw randomness only through `random_secret` (`w_random` in
    generic code); `random_bytes` is fresh but never a key.
26. A request type's descriptor lists every reply field that is
    evidence.

Carried from revision 2, settled: anchors are rebuild-only (attestation
plan); `Delivered` never satisfies a `@decides` unless it is written
`fresh = false` (attestation plan).

Open:

1. Label-generic code: label variables (§4.4) only, or also the
   `Word(W, B)` pattern for code that must differ by label? Decided during
   implementation.
2. Which `SpentStore` instances ship in `lib/` once the filesystem
   provider has an exclusive-create verb (a directory store), and whether
   a TPM NV counter instance belongs in `lib/dev/`.

A worked example of device access with these forms, every name defined,
is the device plan's R2 Appendix A.
