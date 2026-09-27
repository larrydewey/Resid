# Security

This file lists what Resid's compiler, runtime and tools guarantee, how
each guarantee is checked, and what is explicitly not guaranteed. Every
"Guaranteed" row names the tests that fail if the guarantee breaks; run
them with:

    ./boot.sh                      # self-compile fixed point
    tests/conformance/run.sh       # language cases, including err_* rejections
    tests/runtime/run.sh           # C-level runtime properties
    tests/pkg/run.sh               # package signing, trust and ceilings
    tests/provenance/run.sh        # signed provenance trailers

## Threat model

- **Untrusted library code** compiled into a program: it must not gain
  capabilities (file system, processes, environment, arguments, network)
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
| No ambient authority: every capability family a function uses, directly or through anything it calls, wraps in a closure, or runs as a `sort` behavior, is granted by its own `@requires` or its enclosing sandbox. Authority enters a program only where `main` (or a `test` block) declares it. | E0219, `gk_authority` in `examples/gcheck.resid` | `err_authority_*` (provider, builtin, call, closure, lambda, method sugar, behavior, test block), `authority_granted` |
| Effectful runtime builtins are capabilities too: TCP is `network`, the ptrace debugger is `process`. | `gk_builtin_family` | `err_authority_ambient_builtin` |
| The runtime's memory internals (arena and bulk push/pop, persist copies) and the `resid_raw_*` runtime primitives (raw memory, atomics, system calls, static storage, function addresses), which bypass every check above, are not part of the language: calling one is E0220 unless the compiler itself is being built (`--runtime-internals`, passed only by `boot.sh`). | `gk_internals_at` | `err_runtime_internal`, `runtime_primitives` |
| Read-only grants cover reads only, including a write reached through a callee. | E0219 modes | `err_authority_readonly_write` |
| Sandboxes only narrow: nested sandboxes meet, and `sandbox ()` grants nothing. | `ceil_enter`, `meet_caps` in `examples/typecheck.resid` | `err_sandbox_empty`, `err_sandbox_nested_meet` |
| `import "m" @requires(caps)` compiles `m` and its imports inside `sandbox (caps)`; re-importing an unattenuated module attenuated is an error. | `imp_resolve_lines_a` | `err_import_attenuated`, `import_attenuated_ok` |
| A manifest dependency compiles inside the `capabilities` its consumer's manifest lists for it. | depmap `name::root::caps` + `imp_resolve_lines_a` | `err_manifest_ceiling`, `manifest_ceiling_ok`, `tests/pkg` (ceiling) |
| A `spawn`'s child, and everything it calls, gets only the spawn's listed capabilities. | E0214 in `gk_auth_spawns`; the worker runs in its own runtime frame | `err_spawn_body_provider`, `err_spawn_*` |
| Force-time guard (defense in depth): every provider call is checked *before* it runs against the thread's sandbox frames; writes need a grant that is not read-only. | `resid_cap_check`, `capinject_at` | `tests/runtime/cap_guard.c`, `sandbox_force_time_guard_present` |

Effects that are **not** capabilities (ambient by design): writing to
stdout/stderr, reading stdin (`resid_read_line`), OS randomness, and the runtime's own
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

The runtime is C and the compiler performs in-place updates of values
it proves unshared (ownership analysis, loop regions). These are covered
by the conformance suite and the self-compile, not by a proof.

## Packages (spec §28)

A package archive (`RESIDPKG1`) holds every `.resid` and `.toml` file of
the package, sorted, so its SHA-256 covers the sources, the manifest's
name, version, dependencies and capabilities, and `resid.lock`.

| Guarantee | Tests (`tests/pkg/run.sh`) |
|---|---|
| A registry dependency is accepted only when the registry's signed index lists its exact hash, or its detached Ed25519 signature verifies under the dependency's pinned key or a `[signing] keyring` key. Unsigned packages need `[signing] allow_unsigned = true`. | unsigned, devprofile, noanchor, viaindex, wrongindex, pinned, pinwrong, viakeyring |
| A modified archive is rejected. | tamperidx, tamperpin |
| The archive must hold the package that was requested (name and version), not another package signed by the same key. | subst |
| A path dependency with a pinned key must match what `resid-pkg sign-dir` signed. | pathapp |
| Extraction never writes outside the target directory. | extract path traversal |
| Secret keys are written readable by their owner only (`filesystem.write_secret`). | keygen secret mode |

Not guaranteed: path dependencies without a pinned key are trusted as
local source; the package signature is not a COSE structure and does not
name the publisher key; there is no remote registry client.

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

Not guaranteed:

- **The TLS 1.3 client does not authenticate servers.** It has no trust
  store: `tls_server_cert_ok` checks only the validity window and the
  host name, so any certificate for the host is accepted. Do not use
  `lib/tls*.resid` or `lib/h2.resid` where an active attacker matters.
- Constant-time behavior of compiled code is not verified: the compiler
  (and LLVM) may introduce branches.
- DER, X.509 and HPACK parsers abort on malformed input rather than
  returning an error.

## Bootstrap

`build/boot/seed.ll` is committed LLVM IR of the compiler. `./boot.sh`
links it, rebuilds the compiler from source twice and requires all three
IR outputs to be byte-identical, so the seed is exactly what the source
compiles to under itself. This does not rule out a seed that reproduces
itself while miscompiling (the "trusting trust" problem): no independent
second compiler of the current source is maintained.
