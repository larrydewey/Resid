# Secret Values — Implementation Plan (revision 1)

**Status: ACCEPTED (2026-10-09).** Open questions 1, 3 and 4 settled (§8); question 2 is decided during implementation.

**Progress.** Step 1 of §7 is in (2026-10-09): the `Secret(T)` type,
`secret` and `declassify`, the `declassify` family with its graph record,
E0250, E0251 and E0253–E0257, per-copy checking of generic code, erasure
before lowering, `ct_select` (a compiler builtin) and `ct_eq` (in
`lib/crypto.resid`, which needs the `declassify` grant because it publishes
one bit), and the public `.len()` of a secret sequence; `tests/ct` checks
both helpers under valgrind (spec §48, `SECURITY.md`). Secrets as `Map` keys or `Set` elements, provider arguments and `spawn`
results are refused (E0253, E0255); `write_secret` takes a declassified
value. Runtime zeroing (§6) is in as option B, chosen 2026-10-09: a program
that handles secrets runs its whole allocator in secret mode (zero on free
and reuse, every heap mapping `MADV_DONTDUMP`); measured cost on the
compiler's own build is within noise. `mlock` is not used. Step 2 of §7 has begun (2026-10-09), as option B: one generic
implementation per primitive over `Word(T)` (`lib/word.resid`), checked by
the compiler at `Secret(Int)`. `lib/sha256g.resid` (SHA-256, HMAC, HKDF) and
`lib/sha512g.resid` (SHA-512/384 and their HMACs) are in, with
`secret_split`, `secret_join` and `classify`; next are
ChaCha20-Poly1305, AES-GCM, X25519, Ed25519, P-256/P-384, HPKE and the TLS
key schedule. Still to do: a
force-time `resid_cap_check("declassify")` (declassify lowers to nothing,
so the static check is the whole check today), and steps 2–3 of §7.

**Goal**: make "this value is a secret" knowledge the compiler holds and
enforces, so that code which branches on, indexes with, prints, compares
early on, or leaks a secret is a compile error rather than a finding from
`tests/ct/run.sh`. Today constant time is a property the cryptography library
keeps by discipline (`ct_hide`, masks, `ct_equal`) and checks after the fact
with valgrind on x86-64. This plan moves the rule into the type system, and
keeps the valgrind check as the backstop.

**What "guaranteed" means here.** As in `SECURITY.md`, every claim names the
code that enforces it and the test that fails if it breaks. The threat model
is `SECURITY.md`'s with one change: timing side channels that come from
**secret-dependent control flow and memory addresses** move into scope for
values typed `Secret(T)`. Variable-latency instructions are handled by a
refusal list (§3, §5), not a proof. Power, EM and microarchitectural leaks below
that level (speculation, port contention) stay out of scope.

---

## 0. Design in one paragraph

`Secret(T)` is a type, not a behavior: a value whose **knowledge** is
"present, but not observable by this program's control flow". Secrecy is
carried on the knowledge graph like effects and capabilities are (§3.1): every
node gains a `secret` bit, set on a `Secret(T)` value and propagated along
`deps` edges through the operations in the allowed list (§3). A node whose
secret bit is set may not decide control (an `if` or `match` condition, a loop
bound, a short-circuit operand), may not decide an address (an index, a slice
bound, a map key, a length), may not reach an output (`print`, `Show`, an
f-string, `Serialize`, a provider write, a native call, a spawn result), and
may not be compared with `==`. The only exits are the constant-time library
verbs (`ct_eq`, `ct_select`, the crypto primitives) and an explicit
`declassify`, which needs the `declassify` capability and is recorded in the
graph artifact, so `resid-why` can list every point where a secret becomes
public and who was granted the authority to do it.

## 1. Spec conformance matrix

| Spec rule | How the design meets it | Enforced by (to build) | Test (to write) |
|---|---|---|---|
| Law 1, 2: everything is reducible; reduce all provable computation | A `Secret(T)` whose value is KNOWN at compile time (built from a literal or anything reduced from literals) is refused (E0250): a secret the compiler can prove is one everyone with the binary has. The only accepted form passes the value through `declassify` explicitly, which states in the source and the graph that it is public | checker, `greduce` | `err_secret_literal`, `secret_literal_declassified_ok` |
| Law 6: preserve knowledge | Secrecy is knowledge. Reduction keeps the secret bit on every node it produces, including folded constants | `gx_collect`, node merge | `secret_survives_reduction` |
| Law 9, 10: acquisition is an effect | Reading a secret from a provider (`filesystem.read_secret`, a device ioctl marked secret) is an effect returning `Secret(Bytes)`; never reduced | provider table | `secret_from_provider` |
| Law 11: provenance | Every `declassify` is a graph node with its source span and a required reason string; the provenance record lists them | `ga_declassify` (`gart.resid`) | `declassify_in_graph` |
| Law 12: runtime uncertainty is explicit | A `Secret(Result(..))` or `Secret(Option(..))` is refused: whether an operation failed is control flow. Fallible secret operations return `Result(Secret(T), E)`, where the error depends only on public data | checker | `err_secret_wraps_result` |
| Law 14: no ambient authority; only attenuated | Publishing a secret in any way is authority: `declassify` needs the capability family `declassify`, checked transitively (E0219), bounded by spawn lists, sandboxes and manifest ceilings, and recorded on the graph. Writing a secret out (`write_secret`, a secret-taking device descriptor) needs `declassify` too, in addition to its own family | `gk_all_facts`, `resid_cap_check("declassify")`, manifest | `err_declassify_ungranted`, `err_declassify_sandbox`, `pkg_declassify_ceiling`, `declassify_in_graph` |
| Law 13: knowledge is first-class (behaviors are compile-time knowledge about a type) | The instance table for prelude observation behaviors on secret-bearing types is fixed and empty; structural defaults refuse secrets; instance bodies are flow-checked (§4) | checker: instance declaration, structural default selection, per-copy taint | `err_secret_show_default`, `err_secret_serialize_default`, `err_secret_show_instance`, `err_secret_hash_instance`, `err_secret_wrapper_instance_leak`, `secret_wrapper_instance_declassified_ok` |
| Generic code is checked per concrete copy | Taint runs after monomorphization, on each copy | checker | `err_secret_generic_show`, `err_secret_generic_branch` |
| Compile-time outputs carry no secret value | Emitters for `comptime_print`, `--dump-reduced`, the graph artifact, provenance and LSP refuse or omit secret-marked nodes | `gart.resid`, `prov_payload`, LSP hover | `secret_absent_from_artifacts` |
| §4: values immutable, no observable identity | Unchanged. Storage that held a secret is zeroed before reuse or release (§6) | runtime allocator | `secret_zeroed_on_release` |

## 2. Surface

```resid
Secret(Bytes) k = secret(derive_key(seed));     // wrap: public -> secret is always allowed
Secret(Bytes) tag = hmac_sha256(k, msg);         // crypto verbs take and return secrets
Bool ok = ct_eq(tag, expected_tag);              // constant-time compare; result is public by design
Bytes out = declassify(ciphertext, "AEAD output is public");   // needs @requires(declassify); on the graph
```

- `secret(x)` wraps any value of an allowed `T` (§3). Wrapping is free.
- `declassify(s, reason)` takes a string literal reason (E0251 otherwise) and
  needs `@requires(declassify)`. The family has no modes. A library function
  that declassifies carries the requirement to every caller, so the standard
  library cannot declassify for a caller without the caller granting it.
- `Secret(T)` nests nowhere it would hide control: not in `Option`, `Result`,
  a sum type's tag, a map key or set element (E0253). It may be a record field
  and a list element (the list's length is public).

## 3. What a secret may do

Allowed, result secret: `+ - *` (wrapping and checked; overflow on a secret
is refused, E0254, since the abort is a branch), `& | ^ ~ << >>` by a
**public** shift amount, casts between integer widths, byte and list
construction, concatenation, `ct_select(secret_bool_mask, a, b)`, and the
crypto library's verbs.

Allowed, result public by design: `ct_eq`, the AEAD/signature verify verbs
(their Bool is the protocol's public outcome), `len` of a secret list or bytes.

Refused (E0255, naming the operation and the secret's source span): `/ %` by
or of a secret (variable latency on x86-64 and AArch64), `==`/`!=`/`<`
(use `ct_eq`), any condition, index, slice bound, loop bound, `match`
scrutinee, `&&`/`||` operand, map key, `Show`, `Serialize`, f-string hole,
`print*`, a provider write other than `write_secret`, a native-module argument,
a `spawn` return, and `todo`/`assert` on a secret. Behaviors and generic code follow §4.

## 4. Behaviors, instances and observation

Every path from a secret to anything observable must go through `declassify`.
Behaviors are the place where that is easiest to get wrong, because instances
are chosen at compile time from the program as a whole and the prelude gives
`Show` and `Serialize` a structural default for every type. The rules:

1. **Structural defaults refuse secrets (E0256).** The built-in structural
   `Show` and `Serialize` are a compile error for any type that contains
   `Secret` anywhere: a field, a list or vector element, a sum-type payload,
   or any of these nested at any depth. The error names the field path from
   the shown type to the secret (`KeyPair.priv`). There is no redacted
   rendering: a program that wants to show a record holding a secret writes
   its own instance, which falls under rule 3.
2. **No prelude observation instances (E0257).** Declaring an instance of
   `Show`, `Serialize`, `Hash`, `Eq` or `Ord` whose type arguments contain
   `Secret` at any depth is refused. This is a fixed rule of the compiler, not
   a general negative-instance feature: the compiler owns the instance table
   for these behaviors on secret-bearing types, and that table is empty.
3. **Every instance body is flow-checked.** An instance for a type that holds a
   secret (`Show(KeyPair)` reading `k.priv`), and any instance of a user
   behavior, is an ordinary function under §3. A public result computed from
   secret data needs `declassify`, so an override either fails to type-check or
   declassifies on the record. `Hash`, `Eq`, `Ord` and `Serialize` results
   computed from a secret are themselves secret and cannot be returned as their
   public types. A comparator passed with `using =` to `sort` over secrets is
   refused, since `sort` branches on its result.
4. **Checks run on every generic instantiation.** Taint is checked on each
   concrete copy of a generic function, the same way E0219 already names copies
   (`label(Task)`). `@needs(Show(T)) Str label(T x)` used with
   `T = Secret(Bytes)` fails rule 2; a generic body using a structural default
   fails rule 1; a generic body that branches on a `T` that is secret fails §3.
   A generic library cannot launder a secret.
5. **Compile-time and tooling exits.** `comptime_print`, `known`,
   `--dump-reduced`, the graph artifact, the provenance record and LSP hovers
   never contain a secret's value. A secret known at compile time is already
   refused (§1), so this is a backstop, enforced by the emitters and tested.
   At run time, `resid-debug` reading a secret's memory needs `process`
   authority over the target: a debugger with that authority can read secrets,
   and this plan does not claim otherwise. `MADV_DONTDUMP` (§6) keeps secrets
   out of core dumps.
6. **Public by design.** These are not leaks and are documented as such: the
   length of a secret list or bytes value; whether a structure holds a secret
   (its type is public); the Bool from `ct_eq` and from signature and AEAD
   verification. When a length is itself sensitive, padding to a fixed length
   is the caller's job.

**Why not a negative-instance feature.** A transitive negative instance, as
Zyl's `impl-not` provides, would also stop wrappers from acquiring `Show`.
Resid uses information flow instead because it covers more than behaviors: a
plain function, a closure, a provider write or a native call that turns secret
data into public data is caught by the same rule as an instance body. Rules 1
and 2 are the compiler's own fixed negative facts for the prelude behaviors;
no general `impl-not` is added to the language.

## 5. Code generation

- Secret masks pass through `ct_hide` automatically (today the library does it
  by hand), so LLVM cannot turn a select back into a branch.
- The lowering refuses to emit `udiv`/`sdiv`/`urem`/`srem` on a secret operand
  even if the checker missed it (a second line, `lw_secret_div`).
- `tests/ct/run.sh` gains a generated case per `Secret` use in `lib/`, so the
  valgrind backstop covers everything the type system claims.
- AArch64: the type rules are architecture-independent; the valgrind check
  stays x86-64 only (as `SECURITY.md` already says). An AArch64 backstop is
  out of scope for this plan.

## 6. Runtime

- Storage holding a secret is zeroed when its last reference dies, including
  when the compiler reuses it in place. The allocator gets a zeroing release
  path, selected per allocation by a flag the lowering sets.
- Secret allocations are `madvise(MADV_DONTDUMP)` and, where the limit
  allows, `mlock`ed; failure to lock is not an error (documented).
- A secret never crosses a process boundary except through `write_secret`, a
  device descriptor marked secret (PLAN-device-access.md), or a native module
  explicitly declared to take secrets (later; refused for now).

## 7. Migration

1. Land the type, checker rules and errors with no library changes.
2. Convert `lib/` key handling to `Secret(T)`: ecdsa, p256, p384, x25519,
   ed25519, rsa private ops, aesgcm, chacha, hpke, hkdf, hmac, tls key
   schedule. Each conversion removes a hand-written `ct_hide` where the
   compiler now inserts it.
3. Make `tests/ct/run.sh` generate its cases from the graph.

## 8. Open questions

1. Settled (2026-10-09): publishing a secret requires the `declassify`
   capability and is recorded on the graph.
2. Secret-dependent loop counts in bignum code (RSA): refuse, or allow loops
   whose bound is the public bit length only? The plan assumes the latter,
   with the bound checked to be public.
3. Settled (2026-10-09): secrets known at compile time are refused unless
   passed explicitly through `declassify`. Test keys are read from fixtures at
   run time, or declassified explicitly.
4. Settled (2026-10-09): no `impl-not` in Resid. Overriding `Show` (or any
   observation behavior) cannot leak a secret: structural defaults refuse
   secrets at compile time, prelude observation instances on secret-bearing
   types are refused, and every instance body is flow-checked (§4).
