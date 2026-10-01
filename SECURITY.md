# Security

This file lists what Resid's compiler, runtime and tools guarantee, how
each guarantee is checked, and what is explicitly not guaranteed. Every
"Guaranteed" row names the tests that fail if the guarantee breaks; run
them with:

    ./boot.sh                      # self-compile fixed point
    tests/conformance/run.sh       # language cases, including err_* rejections
    tests/runtime/run.sh           # runtime properties (C harnesses over rt.ll)
    tests/pkg/run.sh               # package signing, trust and ceilings
    tests/provenance/run.sh        # signed provenance trailers

## Threat model

- **Untrusted library code** compiled into a program: it must not gain
  capabilities (file system, processes, environment, arguments, network,
  terminal, clock)
  that the program did not grant it, or reach the runtime's memory
  internals at all.
- **Untrusted package sources** (a registry, a mirror, a copied archive):
  a dependency must be exactly what a trusted key signed, and must be the
  package that was asked for.
- **Untrusted input data** handled by a compiled program: it must not
  cause out-of-bounds memory access.
- Out of scope: an attacker who can write the local build tree (`target/`,
  the key files, the compiler binary), timing and other side channels,
  and denial of service (a malformed input may abort the process).

## Capabilities (spec §19–21)

| Guarantee | Enforcement | Tests |
|---|---|---|
| No ambient authority: every capability family a function uses, directly or through anything it calls, wraps in a closure, or runs as a `sort` behavior, is granted by its own `@requires` or its enclosing sandbox. Authority enters a program only where `main` (or a `test` block) declares it. | E0219, `gk_authority` in `compiler/gcheck.resid` | `err_authority_*` (provider, builtin, call, closure, lambda, method sugar, behavior, test block), `authority_granted` |
| Effectful runtime builtins are capabilities too: TCP is `network`, the ptrace debugger is `process`, TTY queries and raw mode are `terminal`. | `gk_builtin_family` | `err_authority_ambient_builtin`, `term_requires_missing`, `readline_requires_terminal` |
| `terminal(readonly)` covers the TTY and window-size queries only; raw mode and restoring it are writes, at compile time and in the force-time guard (`terminal!`). | `gk_builtin_write`, `provider_family_of_line` | `term_readonly_write`, `term_readonly_query` |
| Reading the clock is `clock`, an effect like any other: under Laws 8 and 9 the answer to "what time is it" is knowledge the program does not have, so it arrives only through an authorized provider and never ambiently. `clock(readonly)` covers `now_ns`, `now_sec` and `monotonic_ns`; `sleep_ns` consumes time rather than observing it and so needs the full grant, at compile time and in the force-time guard (`clock!`). `lib/clock.resid` is the standard library's only clock surface, and the rest of the date and time library needs no grant at all — converting, formatting and zone-resolving a timestamp you already hold is arithmetic. | `is_prov_family`, `is_write_verb`, `provider_family_of_line` | `err_authority_clock`, `err_clock_readonly_write`, `authority_clock_readonly`, `dt_clock`, `tests/runtime/cap_guard.c` |
| A program never leaves the terminal in raw mode: the runtime restores the saved settings when `main` returns and on an uncaught abort. | `term_exit` in `runtime/rt/term.resid` | `tests/runtime` (readline on a pty) |
| Generics and behaviors add no authority. A behavior's function runs where the behavior is used, so its capabilities flow to the caller. A generic function's own body is checked against its own `@requires`; each copy made for concrete types is granted exactly what it and the instances it calls need, and the concrete caller must hold that (E0219 names the copy, e.g. `label(Task)`). A copy of a generic declared inside a `sandbox` is placed inside the same sandbox, so the ceiling still bounds it (E0211, E0218). | `gk_auth_all` (copies), `gm_wrap` in `compiler/mono.resid` | `err_generic_authority`, `err_generic_sandbox`, `generic_authority_granted` |
| The runtime's memory internals (arena and bulk push/pop, persist copies) and the `resid_raw_*` runtime primitives (raw memory, atomics, system calls, static storage, function addresses), which bypass every check above, are not part of the language. Two locks: the driver honors `--runtime-internals` only when the entry file is `compiler/driver.resid` or under `runtime/rt/`; and every use (a call, or an `@export`/`@import` annotation) must come from a file under `compiler/` or `runtime/rt/`, never `lib/`, found through the import source map (E0220). A lint test keeps `lib/` and `tools/` free of internal names. | `gk_internals_at`, `gk_internal_file`, driver `rentry` | `err_runtime_internal`, `err_runtime_internal_outside`, `tests/runtime` (primitives, lib/ import, lint) |
| Read-only grants cover reads only, including a write reached through a callee. | E0219 modes | `err_authority_readonly_write` |
| Sandboxes only narrow: nested sandboxes meet, and `sandbox ()` grants nothing. | `ceil_enter`, `meet_caps` in `compiler/typecheck.resid` | `err_sandbox_empty`, `err_sandbox_nested_meet` |
| `import "m" @requires(caps)` compiles `m` and its imports inside `sandbox (caps)`; re-importing an unattenuated module attenuated is an error. | `imp_resolve_lines_a` | `err_import_attenuated`, `import_attenuated_ok` |
| A manifest dependency compiles inside the `capabilities` its consumer's manifest lists for it. | depmap `name::root::caps` + `imp_resolve_lines_a` | `err_manifest_ceiling`, `manifest_ceiling_ok`, `tests/pkg` (ceiling) |
| A `spawn`'s child, and everything it calls, gets only the spawn's listed capabilities. | E0214 in `gk_auth_spawns`; the worker runs in its own runtime frame | `err_spawn_body_provider`, `err_spawn_*` |
| A running `spawn` region shares nothing mutable with its parent: captured maps are frozen and captured records marked shared at capture, a captured handle is moved (the parent may not use it again), and every region is joined before the scope that started it ends. | `lw_share_caps`, `gk_moved_use`, `lw_fut_waits` | `spawn_concurrent`, `err_spawn_handle_moved` |
| Force-time guard (defense in depth): every provider call is checked *before* it runs against the thread's sandbox frames; writes need a grant that is not read-only. | `resid_cap_check`, `capinject_at` | `tests/runtime/cap_guard.c`, `sandbox_force_time_guard_present` |

Effects that are **not** capabilities (ambient by design): writing to
stdout/stderr, reading stdin (`resid_read_line`, `resid_read_byte`), OS randomness, and the runtime's own
allocation and aborts. There is no FFI or
`extern`: a program can reach the OS only through providers and the
builtins above.

## Memory safety

| Guarantee | Tests |
|---|---|
| List, string and fixed-capacity indexing is bounds-checked; an index the compiler proves in range skips the check (range facts). | `range_facts_discharge`, conformance index cases |
| String functions never read past the terminating NUL on truncated or invalid UTF-8. | `tests/runtime/utf8_bounds.c` |
| Materializing a range whose length overflows aborts instead of overflowing an allocation; `lo..=Int.max` aborts instead of wrapping to empty. | runtime `resid_range_list` |
| Immediate Int/Float words are never confused with pointers: they lie at or above 2^48, and the runtime checks at startup that the stack, the heap, mmap'd memory and its own data lie below it (aborting otherwise). | `tests/runtime/immediates.c`, `immediate_scalars` |
| Arithmetic is checked (spec §6.5) unless the compiler proves it cannot overflow. | `saturating_corners`, `range_facts_discharge` |

The runtime is Resid (`runtime/rt/`), built on the compiler-only raw
memory primitives, with no C library underneath; and the compiler performs
in-place updates of values it proves unshared (ownership analysis, loop
regions). Both are covered by the conformance suite and the self-compile,
not by a proof.

## Packages (spec §28)

A package archive (`RESIDPKG1`) holds every `.resid` and `.toml` file of
the package, sorted, so its SHA-256 covers the sources, the manifest's
name, version, dependencies and capabilities, and `resid.lock`.

| Guarantee | Tests (`tests/pkg/run.sh`) |
|---|---|
| A registry dependency is accepted only when the registry's signed index lists its exact hash, or its detached Ed25519 signature verifies under the dependency's pinned key or a `[signing] keyring` key. Unsigned packages need `[signing] allow_unsigned = true`. | unsigned, devprofile, noanchor, viaindex, wrongindex, pinned, pinwrong, viakeyring |
| `[signing] require_signatures = true` refuses the index on its own: a detached signature under a pinned or keyring key is then required, because a hash somebody wrote down is not a signature over it. | reqsig_noanchor, reqsig_keyring, reqsig_wrongkey, reqsig_nopubkey |
| A modified archive is rejected. | tamperidx, tamperpin |
| The archive must hold the package that was requested (name and version), not another package signed by the same key. | subst |
| A path dependency with a pinned key must match what `resid-pkg sign-dir` signed. | pathapp |
| Extraction never writes outside the target directory. | extract path traversal |
| Secret keys are written readable by their owner only (`filesystem.write_secret`). | keygen secret mode |

### Remote registries

A registry named by `[registry] url` is untrusted input exactly like a
local directory, and the transport widens nothing: the archive's SHA-256
is checked against `resid.lock` and any `-sha256` sidecar, trust still
comes from a pinned key, a keyring key or a signed index, and the archive
must be the package that was asked for. A fetch that succeeds is never
itself a reason to trust anything.

| Guarantee | Tests (`tests/pkg/run.sh`) |
|---|---|
| A dependency fetched over HTTP is verified exactly as one fetched from disk. | remote_signed, remote_wrongkey, remote_unsigned, remote_slash |
| A version the registry does not publish is an error, not an empty build. | rem404 |
| A package archive that is not valid UTF-8 survives the round trip byte for byte. | remote archive is byte-identical after extraction |
| A manifest naming both `[registry] path` and `url` is refused, rather than one silently winning. | remboth |
| `https://` is refused, never downgraded to plaintext. | remhttps |

`resid-pkg serve` is the publish side of the same layout, and is
deliberately small: loopback only, `GET` and `HEAD` only, no listing, no
upload, and no request path may name a file outside the registry
directory. Nothing it does can change what a client accepts.

| Guarantee | Tests (`tests/pkg/run.sh`) |
|---|---|
| The server serves a registry, answers 404 for what it does not carry, rejects methods other than GET/HEAD, and refuses a path that could escape the registry directory. | serve GET, serve 404, serve rejects POST, serve refused a traversal path |
| It binds loopback and nothing else. | serve is not bound to loopback only |

Not guaranteed: `path` dependencies without a pinned key are trusted as
local source (spec §28.3); the package signature is not a COSE structure
and does not name the publisher key; `require_signatures` does not extend
to path dependencies, which the spec exempts as local source; there is no
TLS registry transport, so an `https://` registry must be fronted by a
proxy that terminates TLS.

## Provenance (spec §33.1)

Release binaries carry a COSE_Sign1 (Ed25519) trailer binding the source,
the binary and its sidecars. `residc verify` checks the signature against
the keyring, the code hash and each sidecar (`tests/provenance/run.sh`).
The graph tools (`resid-why`, `resid-graph`, `resid-debug`) do not verify
provenance themselves; run `residc verify` before trusting their inputs.

## Cryptography library

| Guarantee | Tests |
|---|---|
| Ed25519 verification is strict (RFC 8032 §5.1.7): 64-byte signatures, `S < L` as a full integer, canonical `y < p`, keys and `R` must decode to curve points; malformed input returns false, never aborts. | `ed25519_verify_strict`, `ed25519_verify_in_resid` |
| ECDSA P-256 verification rejects `r` or `s` outside `[1, n-1]` (including the `r = Qx, s = 0` forgery), keys off the curve and sums at infinity, and accepts DER integers with leading zeros stripped. | `ecdsa_verify_strict` |
| RSA PKCS#1 v1.5 certificate verification (`rsa_cert_verify`) compares the full expected encoding and rejects a signature representative `>= n`. | (library code) |
| Randomness comes from `getrandom(2)`, falling back to `/dev/urandom`; failure aborts. | (runtime code) |
| `ct_equal` and the AEAD tag checks accumulate every byte with no data-dependent exit in the source. | (library code) |

## TLS server authentication

| Guarantee | Tests (`tests/tls/run.sh`) |
|---|---|
| A server is trusted only when its leaf names the connected host, is inside its validity window, and chains to a root in the trust store. | pemstore-full-chain, wrong-host, expired-leaf |
| The store may be a PEM bundle or a directory of DER certificates; both hold the same anchor. | derstore-full-chain |
| Intermediates come from the chain the server sent, and a chain that needs one is rejected when it is not sent. | pemstore-no-chain |
| A leaf is only as trusted as the anchor that issued it. | wrong-anchor, other-root-own-leaf, derstore-rejects-other-leaf |
| **No store trusts nothing.** There is no "skip verification" flag: an empty or absent store refuses the handshake rather than falling back to "any certificate with the right host name". | no-store, empty-store |
| A pinned leaf is accepted without a chain, but is still checked for host name and validity. | pinned-leaf, pinned-leaf-wrong-host, pinned-expired-leaf |
| A store path that does not exist is an empty store, not a crash. | missing store path |
| PEM reading is strict: text that is not a certificate, and an unterminated block, yield no root rather than a partial one. | junk PEM, unterminated PEM block |
| The chain the server sends is read whole, and a `certificate_list` that claims more than it holds, or that is cut short mid-entry, yields only the certificates that are actually there. | single-certificate message, two-certificate message, three-certificate message, message with a request context, over-long certificate_list, truncated message |

Certificates are compared as moments on the timeline, not as packed
integers: `x509_valid_now` takes an `Instant` and converts the
certificate's UTCTime/GeneralizedTime through `lib/calendar.resid`, so a
certificate's `notBefore` cannot drift from what the rest of the language
calls the same day. A time this cannot read rejects rather than comparing
against a moment it did not read.

Not guaranteed:

- `require_signatures` does not extend to path dependencies, which spec
  §28.3 exempts as local source.
- Constant-time behavior of compiled code is not verified: the compiler
  (and LLVM) may introduce branches.
- DER, X.509 and HPACK parsers abort on malformed input rather than
  returning an error.
- Only ECDSA P-256 (`1.2.840.10045.4.3.2`) and RSA PKCS#1 v1.5
  (`1.2.840.113549.1.1.11`) certificate signatures are verified.
  `rsa_pss_verify_sha256` exists in `lib/chain.resid` but `chain_verify`
  does not dispatch to it, so an RSA-PSS-issued certificate does not
  validate. Intermediates are not checked for `CA:TRUE`, and revocation
  (CRL/OCSP) is not implemented.

## Bootstrap

`build/boot/seed.ll` is committed LLVM IR of the compiler. `./boot.sh`
links it, rebuilds the compiler from source twice and requires all three
IR outputs to be byte-identical, so the seed is exactly what the source
compiles to under itself. This does not rule out a seed that reproduces
itself while miscompiling (the "trusting trust" problem): no independent
second compiler of the current source is maintained.
