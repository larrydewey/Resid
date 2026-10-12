---
title: Diagnostics
description: What the compiler's error codes mean.
---

Diagnostics name the file, line and column (in imported modules, their
own), with the offending source line. Capabilities and capability lists
are spelled as in source: `filesystem(readonly)`, `[clock(readonly),
network]`.

| Code | Meaning |
|---|---|
| `E0001` | a type or structure error: a mismatch, an unknown name, shadowing, a missing return, `?` outside an Option/Result function, an `if` expression without `else`, `==` on a composite value without `Eq`, a duplicate function or behavior instance, an instance whose functions do not match its behavior, a malformed program |
| `E0211` | a call exceeds the caller's sandbox ceiling |
| `E0212` | a region violation: a handle entering a sandbox it exceeds, or a write under a read-only grant |
| `E0213` | a malformed capability list (unknown family or mode) |
| `E0214` | a `spawn` lists more capabilities than its parent holds |
| `E0215` | a call inside a `spawn` needs a capability the region lacks |
| `E0216` | an attenuated import of a module already imported without attenuation |
| `E0218` | a provider call in a restricted region uses a family outside it |
| `E0219` | a function uses a capability it is not granted (no ambient authority) |
| `E0220` | a compiler-internal primitive used outside the compiler's own sources |
| `E0221` | an imported module cannot be found |
| `E0222` | a name in the wrong case: types, behaviors and variants start uppercase, values and functions lowercase; single uppercase letters are reserved for type parameters |
| `E0223` | an unqualified use of a name that two imported modules both export |
| `E0224` | a library declares an instance of a behavior and a type it owns neither of |
| `E0225` | two instances of one behavior overlap at the same level (no specialization) |
| `E0226` | a generic function uses a behavior it does not list in `@needs`, or a call's needs have no instance |
| `E0227` | a type parameter cannot be inferred from the arguments, the expected type or one fitting instance |
| `E0228` | a generic function calls itself at ever larger types (instantiation does not terminate) |
| `E0231` | a function has the name of a behavior's verb |
| `E0232` | `@link` in the standard library, the tools or the runtime ([native modules](/Resid/reference/native-modules/)) |
| `E0233` | a native function's parameter or result type cannot cross to a native module |
| `E0234` | a malformed `@link`: module name, non-empty body, generic, another annotation, or not on a function |
| `E0235` | no artifact for a native module, or it does not define the bound function |
| `E0236` | a native artifact defines the function with other C types, or not visibly |
| `E0237` | a native artifact is refused (it reaches outside itself, runs at load time, …), or a malformed `-native` |
| `E0250` | `secret(...)` of a value the compiler knows after reduction (it would be in the binary); pass it straight to `declassify` to state that it is public |
| `E0251` | `declassify` without a non-empty string-literal reason ([secret values](/Resid/reference/secrets/)) |
| `E0253` | `Secret(T)` wrapping a type whose shape is control or identity: `Option`, `Result`, a sum type, `Map`, `Set`, a handle, a function, or another secret; a secret `Bytes` or `Bytes(N)` (its length and conversions scan the bytes; use `List(Secret(UInt(8)))`); or a secret as a `Map` key or `Set` element in any written type |
| `E0254` | checked `+`, `-` or `*` on a secret (its overflow abort is a branch on the value); use `wrapping_add` / `wrapping_sub` / `wrapping_mul` |
| `E0255` | a secret decides control, an address or a public result: a condition, a `match`, `&&`/`\|\|`, a comparison, `/` or `%`, an index, a range bound, a shift amount, a method other than a sequence's `.len()`, a provider argument, or a `spawn` region's result |
| `E0256` | showing a secret, or a value holding one through the structural `Show` (the error names the field path) |
| `E0257` | `Show`, `Serialize`, `Hash`, `Eq` or `Ord` given for, or asked of, a secret |
| `E0258` | a secret integer wider than 32 bits in a list, builder, vector, map or set (`List(Secret(Int))`, `Secret(List(Int))`), written or inferred: list integers of 2^54 or more are boxed, a choice made on the value; use 32-bit or narrower elements (`UInt(8)` for bytes) and keep wider secrets in records and parameters |
| `E0259` | a function named after a builtin of secret values (`secret`, `declassify`, `classify`, `secret_split`, `secret_join`, `ct_select`): it would replace the builtin in every module, libraries included |
| `E0260` | a device descriptor (`@descriptor`, or a literal of a descriptor type) outside the standard library's `lib/dev/`; a call of the device engine or of `resid_device_call` other than by the compiler; a `device` verb without a descriptor from `lib/dev/` (a record of another type with the same fields included) ([device access](/Resid/reference/devices/)) |
| `E0261` | a dependency's code reaches a device descriptor outside its manifest bound `devices = [...]` |
| `E0262` | a device verb's descriptor is not known after reduction |
| `E0263` | a device descriptor's layout is inconsistent: request size or direction bits, fields outside the struct or overlapping, an unaligned pointer, a buffer without a maximum, a length field that is not a Scalar, too narrow for its buffer's maximum, or shared by two buffers, a path outside `/dev/` and `/sys/` or with `..`, no request number for the target, an ioctl that only sends data marked `write = false`, a Transact marked `write = false` (it writes its command) |
| `E0264` | a Sequence descriptor's links: backwards, not from a Scalar output to a Scalar input of one width, outputs before the last step, steps on another path |
| `E0265` | a function named `resid_...`: the prefix is the runtime's (its entry points share the program's link, and the compiler recognizes the device entry by name) |
| `E0271` | a builtin with no entry in the integrity source table (compiler/labels.resid): every builtin's result is classified as acquired from outside or computed from its arguments, and one without an entry is refused rather than guessed ([integrity labels](/Resid/reference/labels/)) |
| `E0272` | a layout type is malformed: `@layout` not on a record type or with a kind other than `c_abi`, `le`, `be`; an unknown field annotation; a field type a layout cannot hold; `@len` on a non-byte field, naming a later or non-integer field, or missing on a `List(UInt(8))`; a variable-length field other than the last under `c_abi`; a nested type of another layout, of variable size under `c_abi`, or containing itself ([layout types](/Resid/reference/layouts/)) |
| `E0273` | a `Secret` layout field with a `@check`: a failed check would publish a bit of it |
| `E0274` | a layout field of a type only the runtime builds (`ChallengeRecord` and the like): parsing outside bytes must never forge one |
| `E0270` | (warning while the rule is rolled out) a key, seed or keying argument that could be known to someone else: fewer than min(length, 32) unpredictable bytes (a constant, bytes from a file, the network, a device or a native module, a short draw padded or repeated, bytes disclosed anywhere), a key that must be own but was agreed or provisioned, or a public keying copy outside tests ([integrity labels](/Resid/reference/labels/)) |
| `E0276` | a literal of an `@opaque` record type outside the file that declares it (and the files it names) |
| `E0277` | a challenge-record builtin (`resid_chal_*`) outside the one standard-library file that owns it |
| `E0278` | `provisioned_key` in the standard library outside lib/tlskey.resid |
| `E0279` | (warning while the rule is rolled out) an AEAD nonce that is a constant, outside a single-use key: one drawn in the same function, outside any loop or closure, for that one sealing call |
| `E0280` | `@primitive` or `@verify_internal` outside `lib/verify/`, or a call of a `@verify_internal` function from outside it |
| `E0281` | a malformed `@anchor` (kind, principal, fingerprint, dates, algorithms, a format that is not a `@signed` type of the standard library or its package), an `@anchor` function that is not `Anchor name() { return anchor_der(bytes); }`, or `anchor_make`/`anchor_der` anywhere else |
| `E0282` | a primitive's anchor argument that is not a call of an `@anchor` function, or one of a kind, algorithms or formats the primitive does not take |
| `E0283` | an appraisal's policy that is not a direct call of a nullary `@policy` function |
| `E0284` | a `@decides` function with a success return no primitive's `Ok` gates, or a malformed `@decides` |
| `E0285` | a decision's gate that does not meet its requirements: anchors not accepted or not required, another policy or none, not fresh, no identity, a kernel time under `time = not_kernel` |
| `E0286` | outside data reaches or selects what a `@decides` function decides |
| `E0287` | `seal_to_evidence` or `seal_to_channel` outside a `@decides` function, or a `key_bound` / `channel_bound` decision whose success return is not that release on its gate |
| `E0288` | a decision's gate formed inside a loop |
| `E0291` | (warning while the rule is rolled out) outside data decides whether, or what, a `declassify` discloses |
| `E0292` | (warning while the rule is rolled out) outside data decides whether, or what, a called function discloses |
| `E0289` | an `@assumption` without a pin or reason, `assumed` or an assumption in the standard library, or `assumption_make`/`assumption_pinned` outside an `@assumption` function |
| `E0293` | a program that issues challenges for several purposes with a decision that names none (`bind = "..."`), or a `bind` decision without exactly one ChallengeRecord |
| `E0294` | an instance replacing one of the standard library's in a program that reaches `lib/verify/` |
| `E0290` | a program that reaches `lib/verify/` built against a closure or runtime this compiler was not released with (or with `-rt`/`-rtr`); `--verify-lib-dev` lifts it |
| `E0301` | a known value violates its constraint type |
| `E0401` | a builder is not consumed on some path |
| `E0402` | a builder is used twice |
| `E0403` | a builder is used inside a loop or lambda it was not created in |
| `E0404` | a builder type nested inside another type |
| `E0410` | a vector's lane type or lane count is not allowed |
| `E0411` | a vector type nested inside another type, or a vector captured by a lambda or `spawn` |
| `E0412` | a vector literal, `splat` or `lanes` without a vector slot to take its type from |
| `E0413` | an f-string hole's format spec that does not fit the value's type (`hex` on a Float, `precision` on an Int, `trim` on anything but a Dec), or two specs that do not go together ([strings](/Resid/learn/strings/#f-strings)) |
| `E0901` | `known(x)` on a residual value |
| `E0902` | compile-time evaluation nests deeper than the compiler's stack (raise `RESID_STACK_MB`, or bound the reduction with `--reduce-budget`) |
| `E0903` | a call of an `@fold` function has an argument that is not known, does not reduce, or runs out of memory or depth |
| `E0904` | a malformed `@reduce(...)`, or `@reduce` with `@fold` or `@link` |

Runtime failures (overflow, division by zero, index out of range, a failed
conversion, a broken constraint, an assertion, `todo`) abort with a message
naming what failed. Inside a `spawn` region they become
`Err(RegionError)`.

Notes (`note: ...`) are not errors: they report reduction budgets that ran
out (`note: reduce: reduction budget (steps) exhausted evaluating f(...)`),
residual notes recorded, and whether the build was signed. A compile-time
evaluation long enough to double past 2^26 steps also says so as it goes.
