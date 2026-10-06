# Security

This file lists what Resid's compiler, runtime and tools guarantee, how
each guarantee is checked, and what is explicitly not guaranteed. Every
"Guaranteed" row names the tests that fail if the guarantee breaks; run
them with:

    ./boot.sh                      # self-compile fixed point
    tests/conformance/run.sh       # language cases, including err_* rejections
    tests/runtime/run.sh           # runtime properties (C harnesses over rt.ll)
    tests/pkg/run.sh               # package signing, trust and ceilings
    tests/provenance/run.sh        # signed provenance trailers and residc verify
    tests/tls/run.sh               # TLS server authentication over committed fixtures
    tests/http/run.sh              # lib/httpserv.resid request parsing and limits

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
- **A binary from elsewhere** that claims to be a Resid build: its
  signature must be checked against a key the verifier already trusts,
  and what the verifier re-derived must be told apart from what the
  signer merely wrote down.
- Out of scope: an attacker who can write the local build tree (`target/`,
  the key files, the compiler binary), timing and other side channels,
  and denial of service (a malformed input may abort the process).

## Capabilities (spec §19–21)

| Guarantee | Enforcement | Tests |
|---|---|---|
| No ambient authority: every capability family a function uses, directly or through anything it calls, wraps in a closure, or runs as a `sort` behavior, is granted by its own `@requires` or its enclosing sandbox. Authority enters a program only where `main` (or a `test` block) declares it. | E0219, `gk_authority` in `compiler/gcheck.resid` | `err_authority_*` (provider, builtin, call, closure, lambda, method sugar, behavior, test block), `authority_granted` |
| Effectful runtime builtins are capabilities too: TCP is `network`, the ptrace debugger is `process`, TTY queries and raw mode are `terminal`. | `gk_builtin_family` | `err_authority_ambient_builtin`, `term_requires_missing`, `readline_requires_terminal` |
| `terminal(readonly)` covers the TTY and window-size queries only; raw mode and restoring it are writes, at compile time and in the force-time guard (`terminal!`). | `gk_builtin_write`, `provider_family_of_line` | `term_readonly_write`, `term_readonly_query` |
| `network(readonly)` covers connecting out, listening on 127.0.0.1, accepting, sending, receiving and closing. Binding a listener to any other address (`resid_tcp_listen_at`, `http_listen_at`) exposes a port to other machines and is the one network write, at compile time and in the force-time guard (`network!`). A server's worker regions can therefore be spawned with `network(readonly)` while only the code that binds holds `network`. | `gk_builtin_write`, `gk_direct`, `provider_family_of_line` | `err_network_readonly_listen`, `network_readonly_loopback` |
| Reading the clock is `clock`, an effect like any other: under Laws 8 and 9 the answer to "what time is it" is knowledge the program does not have, so it arrives only through an authorized provider and never ambiently. `clock(readonly)` covers `now_ns`, `now_sec` and `monotonic_ns`; `sleep_ns` consumes time rather than observing it and so needs the full grant, at compile time and in the force-time guard (`clock!`). `lib/clock.resid` is the standard library's only clock surface, and the rest of the date and time library needs no grant at all — converting, formatting and zone-resolving a timestamp you already hold is arithmetic. | `is_prov_family`, `is_write_verb`, `provider_family_of_line` | `err_authority_clock`, `err_clock_readonly_write`, `authority_clock_readonly`, `dt_clock`, `tests/runtime/cap_guard.c` |
| A program never leaves the terminal in raw mode: the runtime restores the saved settings when `main` returns and on an uncaught abort. | `term_exit` in `runtime/rt/term.resid` | `tests/runtime` (readline on a pty) |
| Generics and behaviors add no authority. A behavior's function runs where the behavior is used, so its capabilities flow to the caller. A generic function's own body is checked against its own `@requires`; each copy made for concrete types is granted exactly what it and the instances it calls need, and the concrete caller must hold that (E0219 names the copy, e.g. `label(Task)`). A copy of a generic declared inside a `sandbox` is placed inside the same sandbox, so the ceiling still bounds it (E0211, E0218). | `gk_auth_all` (copies), `gm_wrap` in `compiler/mono.resid` | `err_generic_authority`, `err_generic_sandbox`, `generic_authority_granted` |
| The runtime's memory internals (arena and bulk push/pop, persist copies) and the `resid_raw_*` runtime primitives (raw memory, atomics, system calls, static storage, function addresses), which bypass every check above, are not part of the language. Two locks: the driver honors `--runtime-internals` only when the entry file is `compiler/driver.resid` or under `runtime/rt/`; and every use (a call, or an `@export`/`@import` annotation) must come from a file under `compiler/` or `runtime/rt/`, never `lib/`, found through the import source map (E0220). A lint test keeps `lib/` and `tools/` free of internal names. | `gk_internals_at`, `gk_internal_file`, driver `rentry` | `err_runtime_internal`, `err_runtime_internal_outside`, `tests/runtime` (primitives, lib/ import, lint) |
| Read-only grants cover reads only, including a write reached through a callee. | E0219 modes | `err_authority_readonly_write` |
| Sandboxes only narrow: nested sandboxes meet, and `sandbox ()` grants nothing. | `ceil_enter`, `meet_caps` in `compiler/typecheck.resid` | `err_sandbox_empty`, `err_sandbox_nested_meet` |
| `import "m" @requires(caps)` compiles `m` and its imports inside `sandbox (caps)`; re-importing an unattenuated module attenuated is an error. | `imp_resolve_lines_a` | `err_import_attenuated`, `import_attenuated_ok` |
| A manifest dependency compiles inside the `capabilities` its consumer's manifest lists for it. | depmap `name::root::caps` + `imp_resolve_lines_a` | `err_manifest_ceiling`, `manifest_ceiling_ok`, `tests/pkg` (ceiling) |
| A ceiling must be grantable under the manifest's `[capabilities] grant` with its mode: a read-only grant does not cover a full entry. | `cap_grantable` in `tools/resid-manifest.resid` | `tests/pkg` (read-only grant covered a full entry) |
| Authority only narrows down the dependency tree: a dependency's ceiling for its own dependency must be grantable under the ceiling it was given. | `collect_sub_deps_at` | `tests/pkg` (transitive ceiling) |
| A dependency declared by two packages gets the meet of every ceiling given to it, whichever declaration is reached first, and every pinned key any declaration names is verified. (Before this, the first declaration reached won, so a dependency could widen a sibling's ceiling or drop its pin.) | `merge_deps`, `meet_caps`, `verify_all_pinned_keys` over every declaration | `tests/pkg` (narrower ceiling ignored, second pin ignored) |
| A `spawn`'s child, and everything it calls, gets only the spawn's listed capabilities. | E0214 in `gk_auth_spawns`; the worker runs in its own runtime frame | `err_spawn_body_provider`, `err_spawn_*` |
| A running `spawn` region shares nothing mutable with its parent: captured maps are frozen and captured records marked shared at capture, a captured handle is moved (the parent may not use it again), and every region is joined before the scope that started it ends. | `lw_share_caps`, `gk_moved_use`, `lw_fut_waits` | `spawn_concurrent`, `err_spawn_handle_moved` |
| Force-time guard (defense in depth): every provider call is checked *before* it runs against the thread's sandbox frames; writes need a grant that is not read-only. | `resid_cap_check`, `capinject_at` | `tests/runtime/cap_guard.c`, `sandbox_force_time_guard_present` |

Effects that are **not** capabilities (ambient by design): writing to
stdout/stderr, reading stdin (`resid_read_line`, `resid_read_byte`), OS randomness, and the runtime's own
allocation and aborts. There is no `extern` and no in-process FFI: a
program reaches the OS only through providers and the builtins above.
Code in another language runs only as a native module (below), in a
process that cannot reach the OS at all.

## Native modules (spec §47)

A native module is code from another language (LLVM IR text) bound with
`@link("m")`. The guarantees below hold for any artifact, hostile ones
included. The test fixtures are in `tests/conformance/native/`.

| Guarantee | Enforcement | Tests |
|---|---|---|
| Calling a native function needs the family `native_<m>`, checked transitively like any capability, and bounded by spawn lists, sandboxes and manifest ceilings. `native_<m>(readonly)` and a bare `native` grant nothing. | `gk_link_decl`, `gk_all_facts` seed, `gk_requires_err`; force time: the stub's `resid_cap_check("native_<m>!")` | `err_native_ungranted`, `err_native_bare_native`, `err_native_readonly`, `err_native_spawn_ungranted`, `err_native_sandbox`, `tests/pkg` (native ceiling), `cap_guard.c` |
| Native code runs only in a separate process: the program re-executed from `/proc/self/exe` with an empty environment and only the call's socket open, so none of the program's memory, arguments, environment or descriptors are there. | `rt_native_call`, `native_child` in `runtime/rt/native.resid` | `native_escape` (stdout), `native_stateless` |
| That process has no authority: before native code runs it disables the TSC, unmaps the vDSO clock pages and installs a seccomp filter allowing only read/write on its socket, non-executable memory and exit. Any other system call, x32 or 32-bit entry kills it. | `native_lockdown`, `native_filter` | `native_escape` (open, getpid, stdout, socket, fork, execve, clock, rdtsc, PROT_EXEC mmap, x32, getrandom, vsyscall) |
| No state survives a call, and a call's CPU time is bounded (60 s). | process per call; `RLIMIT_CPU` in `native_child` | `native_stateless` |
| The reply is untrusted input: its length must be exact, a `Bool` 0 or 1, a narrow integer in range, a `Str(N)` valid UTF-8 within its capacity. A crash or a malformed reply fails the call (an `Err` inside `spawn`). | `resid_native_int_ok`, `resid_native_str_ok`, `rt_native_call` | `native_forged_reply`, `native_in_spawn_err`, `native_host_killed` |
| A native call is never evaluated at compile time. | `fbody = -1` in `gx_collect`; no leaf summary | `native_never_folded` |
| An artifact cannot run code in the program itself: it may reference only its own symbols, LLVM intrinsics and memcpy/memmove/memset; module asm, aliases, ifuncs, comdats, sections, constructors, external and thread-local globals and quoted names are refused; every symbol it defines is renamed `native.<m>.*`. | `nt_ingest` in `compiler/native.resid` (E0237) | `err_native_artifact_*` |
| A binding's C types are checked against the artifact's definition. | `nt_abi_err` (E0235, E0236) | `err_native_export_absent`, `err_native_abi_mismatch`, `err_native_artifact_internal`, `err_native_no_artifact` |
| The standard library, the tools and the runtime bind no native module. | `gk_link_place` (E0232), lint | `tests/runtime` (E0232) |
| A package's artifact must match the SHA-256 its manifest pins, and the archive hash (and a pinned-key signature) covers `.ll` files. | `native_flags_of`, `is_source_name`, `pk_walk` | `tests/pkg` (native artifact pinned, in the archive) |
| The signed provenance record names each linked artifact's SHA-256 (attestation), and the graph records each native call as an effect `native_<m>.<fn>`. | `prov_payload` `native`, `ga_effect` | `tests/provenance` (native) |

Not guaranteed:

- **Correctness of native code.** The process boundary contains it; it
  does not make it right. A reply is checked for its type, never its
  meaning.
- **Kernel enforcement.** The sandbox is only as strong as the kernel's
  seccomp. A kernel without seccomp, or one with a hole in an allowed
  system call, is outside this model, like other kernel bugs.
- **Denial of service.** Native code can spend its 60 s of CPU or exhaust
  memory (the host is first in line for the OOM killer). Both are out of
  scope here, as elsewhere.
- **Timing and other side channels**, as elsewhere. `rdrand` is not
  blocked: OS randomness is not a capability.
- **The build tree.** `-rt` still links an arbitrary extra C file without
  checks. It is a builder's flag, and an attacker who can write the build
  tree is out of scope.

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

A package archive (`RESIDPKG1`) holds every `.resid`, `.toml` and `.ll` (native module) file of
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
| An `https://` registry without `[registry] ca` is refused; with one, the server's certificate must chain to it and name the host, or the fetch is refused. Nothing is downgraded to plaintext. | remhttps, tlsdirect, tlsbadca |

`resid-pkg serve` is the publish side of the same layout, and is
deliberately small: loopback only, `GET` and `HEAD`, no listing, and no
request path may name a file outside the registry directory. Uploads are
opt-in (`--upload <keyring> --index-key <key>`) and take only an archive
signed by a keyring key; a client still trusts the index signature and
the archive hash, never the server. Its HTTP is
`lib/httpserv.resid`'s, so the HTTP server guarantees below apply to it,
and four worker regions share the listener. With `--cert` and `--key` it
serves over TLS 1.3 through `lib/tlswire.resid`, so the TLS server
guarantees apply too.

| Guarantee | Tests (`tests/pkg/run.sh`) |
|---|---|
| The server serves a registry, answers 404 for what it does not carry, rejects methods other than GET/HEAD, and refuses a path that could escape the registry directory. | serve GET, serve 404, serve rejects POST, serve refused a traversal path |
| It binds loopback and nothing else. | serve is not bound to loopback only |
| Over TLS it is the same registry: `resid-fetch` pulls the index and an archive byte-identical, and a key and certificate that are half given or do not belong together are refused at startup. | resid-fetch over https, serve --cert without --key, serve with a key the certificate does not carry |
| An artifact of any size up to what the client accepts is sent whole, not refused at the runtime's 1 MiB single-send cap. | serve a 3 MB artifact byte-identical |
| A client stalled mid-request costs the registry a socket until the request deadline, not a worker. | serve answers while other clients stall |
| An upload is written only when its signature verifies under the publisher keyring; a published version is never replaced; the index is re-signed by the registry key a client pins. | upload by a keyring key, upload by a key outside the keyring, a published version replaced, index after upload, upapp |
| Uploads are opt-in, and their two flags go together. | PUT to a read-only server, serve --upload without --index-key |
| Over TLS an upload checks the server against a trust store, and refuses without one. | upload over TLS, upload over TLS without a trust store |

Not guaranteed: `path` dependencies without a pinned key are trusted as
local source (spec §28.3); the package signature is not a COSE structure
and does not name the publisher key; `require_signatures` does not extend
to path dependencies, which the spec exempts as local source; and `resid
build` does not fetch `https://` itself, so a TLS registry is pulled with
`resid-fetch` into a directory that `[registry] path` names.

## HTTP server (`lib/httpserv.resid`)

The server parses requests from untrusted peers. It is plain Resid over
`List(Int)` byte buffers, so the memory-safety rows above cover it; the
rows here are about what it accepts.

| Guarantee | Tests (`tests/http/run.sh`) |
|---|---|
| A request's head and body are bounded (`HttpLimits`: 64 KiB of head, 8 MiB of body, 1000 requests per connection by default). A longer head is answered 431 once the buffer passes the bound, at most one 16 KiB read later; a declared `Content-Length` over the bound is answered 413 before any of the body is read, and a chunked body as soon as its chunks would pass it. | roundtrip (431, 413), client.py too-big, huge-head |
| Request smuggling shapes are refused rather than resolved one way: `Transfer-Encoding` with `Content-Length`, a coding other than a final `chunked`, a `Content-Length` that is not digits or whose repeated values differ, obsolete line folding, and whitespace before a header's colon. | roundtrip (400, 501), client.py te+cl, te-gzip, bad-cl, fold, space-colon |
| An HTTP/1.1 request without `Host` is refused (400), and an unsupported version is 505. | roundtrip, client.py no-host, version |
| A refused request closes the connection, so nothing after the point the parser stopped is read as another request. | roundtrip, client.py |
| A connection is closed by half-closing and draining before the close, so a refused client still receives its error reply instead of a reset. | roundtrip (431 reply received), client.py huge-head |
| Each request has a whole-request deadline (`HttpLimits.request_ms`, 30 s by default), from when the server starts waiting for it until its body is read, and the TLS handshake has the same bound; each reply likewise has `reply_ms` (60 s) to be taken, so a client that never reads it frees the worker when that passes; a client that trickles bytes or idles between keep-alive requests is disconnected when it passes. Enforced by the runtime (`resid_tcp_deadline`), so the server needs no `clock` grant. | roundtrip (slow client cut off, stalled reader dropped) |
| The accept loop closes each connection exactly once, so a worker never closes a descriptor number another worker has just been handed. | roundtrip (refusals, repeated runs) |
| `examples/http_server.resid` serves files only under its `--root`: a path with an empty, `.` or `..` segment is 404, and so is a directory. | client.py dotdot, dir |

| A client that connects and stalls -- silent, mid-head, or mid-handshake -- costs the server a descriptor, not a worker: `http_accept_loop` and `tls_accept_loop` are event loops over every connection they hold, so other clients are answered at once however many stall. | client.py (answered past 60 stalled clients), tls (served past 30 stalled handshakes) |
| Each loop holds at most `HttpLimits.open_max` connections (1024); past it, the one that has waited longest for its request is dropped for the newcomer, so stalled connections cannot keep new ones out. | roundtrip (crowd evicted) |
| A request is parsed once it is whole; how far it has been checked is remembered, so one sent a byte at a time costs linear work. A TLS handshake step is attempted only when a new record is complete, and a handshake past 64 KiB or 16 records is refused. | roundtrip (slow client cut off) |

Not guaranteed: a handler's own time is unbounded and runs on its loop,
so a slow handler delays that loop's other connections (spawn more loops
for more cores); and a flood of new connections can still crowd out
waiting ones through eviction (denial of service is out of scope above).

## TLS server (`lib/tlsserver.resid`, `lib/tlswire.resid`)

| Guarantee | Tests (`tests/tls/run.sh`) |
|---|---|
| A server presents the chain it was configured with, leaf first, and refuses to start when the certificate does not carry the key it signs with -- checked at startup, not at every handshake. | key matches its certificate, a key and another key's certificate |
| Only TLS 1.3 is spoken. A client that offers TLS 1.2 is refused with `protocol_version` rather than answered under a version the server does not implement. | ossl hello is tls13, TLS 1.2 should be refused |
| The only cipher suite is `TLS_AES_128_GCM_SHA256`, because that is the only one this language can protect a record with. A client offering neither it nor a share this server can use gets `insufficient_security` or `illegal_parameter`, not a downgrade. | (offered-suite and share checks in `lib/tlsserver.resid`) |
| The key share is x25519, drawn fresh per handshake, so a session key is never reused across connections (forward secrecy). | (per-handshake `random_bytes`) |
| A handshake is refused with an alert, never a silent close: `protocol_version`, `illegal_parameter`, `handshake_failure`, `insufficient_security`, `decrypt_error` or `internal_error`. | (alert mapping in `ts_alert_for`) |
| A record that fails its tag ends the connection; it never becomes request bytes. | (record layer: `tls_open` returns nothing) |
| Records carry at most 2^14 bytes of plaintext each, so a reply larger than a record is split rather than truncated. | (large static files over TLS) |
| The client's Finished is verified before the connection serves anything; a wrong one is `decrypt_error`. | resid client against the resid server |
| ALPN picks the first protocol this server speaks that the client also offered, so a client offering only `h2` gets no ALPN extension rather than one it cannot use. | ossl alpn pick |
| The transcript hash is taken over the bytes that went on the wire, anchored on the ClientHello as received: a field this server does not read is still in the hash. | (openssl interoperability) |

Capabilities: reading the key and the chain is `filesystem(readonly)` and
happens in the caller (`lib/tlskey.resid`); serving is `network(readonly)`
and binds nothing. A server that exposes a port other machines can reach
needs the full `network` grant, as before.

The private key is read, never written, never printed, and not kept past
the call. What this language cannot do is check the key *file's* mode: there
is no stat verb, so a mode check is not expressible here. Keeping a key
file owner-only is the operator's job, and a deployment that cannot do that
should not be running this.

## TLS client (`lib/tlsclient.resid`, `tools/resid-fetch.resid`)

| Guarantee | Tests (`tests/tls/run.sh`) |
|---|---|
| The server is authenticated before anything is sent: the leaf has to name the host, be inside its validity window, chain to a root in the trust store, and carry a CertificateVerify that verifies under its own key. | client against our own server |
| No trust store means nothing is trusted. There is no flag to skip verification and no fallback to plaintext: an https url with no store is a refusal. | (fail-closed in `tls_server_trusted`; `resid-fetch` refuses with no store) |
| A name that does not verify is refused by name -- `not trusted for 'otherhost'` -- rather than by a timeout or a silent close. | untrusted name refused |
| An address SAN is matched as bytes, exactly. `127.0.0.1` in a certificate is not a wildcard for the loopback. | iPAddress SAN, wrong iPAddress SAN refused |
| A response is only accepted with a Content-Length, and over a 64 MB cap. A body is never read to close, because a registry that keeps streaming is a registry that can stream forever. | (cap and `Content-Length` required in `tls_https_get`) |
| ALPN is negotiated, not assumed. The client's offers go on the wire in its ClientHello, the server's choice comes back in EncryptedExtensions, and a client offered a protocol the server did not name fails rather than picking for itself. | server choice wins over the client's order, declined ALPN is not an invented one |
| A server cannot hold a client: the whole exchange, handshake to last byte, has a deadline (five minutes; `tls_client_cfg_within`, `tls_https_get_within`, `resid-fetch --timeout`), and a connect gives up after 30 s. The same deadline bounds `lib/http.resid` and the `http://` registry fetch in `resid build`. | a trickling server is cut off by the fetch deadline (`tests/pkg/run.sh`) |
| What arrives is not trusted for it: `resid-fetch` prints the SHA-256 and `resid build` still verifies the index against `[registry] pubkey` and every archive against its hash. The indirection adds transport authentication, not trust. | (unchanged in `tests/pkg/run.sh`) |

The direction of the TLS 1.3 traffic secrets is the one mistake that a
test cannot be built around: a client that uses its own application secret
for both directions completes the handshake and then opens no application
record at all. The client reads with the server's application traffic
secret and writes with its own.

Not guaranteed:

- Only `ecdsa_secp256r1_sha256` and `ed25519` are produced. RSA signing,
  P-384, session resumption (PSK or tickets), client certificates,
  encrypted ClientHello, record compression and 0-RTT are not implemented.
  A client offering none of the two signature algorithms is refused rather
  than served with a signature the certificate does not cover.
- No session ticket is ever sent, so every connection pays a full
  handshake. That is the safe direction to be wrong in.
- This repository's own client (`examples/tls_client.resid`) verifies only
  ECDSA-P256 and RSA-PSS CertificateVerifies, so an Ed25519 server is
  checked end to end with an external client. The server side signs with
  either.
- The key file's permissions are not checked (see above).
- Constant-time behavior of compiled code is not verified: the compiler
  (and LLVM) may introduce branches, so the ECDSA and AES implementations
  are not claimed to be constant-time.

## Provenance (spec §33.1)

Release binaries carry a COSE_Sign1 (Ed25519) trailer over a record that
binds the source files, the binary and its sidecars by SHA-256. `residc
verify` checks the signature and the hashes, then reports the record as
**evidence** (what it re-derived) and **attestation** (what only the
signer says), and names where the key it trusted came from. The graph
tools (`resid-why`, `resid-graph`, `resid-debug`) do not verify
provenance themselves; run `residc verify` before trusting their inputs.

| Guarantee | Tests (`tests/provenance/run.sh`) |
|---|---|
| A release build without a signing key fails; a debug build without one is unsigned and says so. | release without key, debug without key |
| The code hash covers every byte before the trailer: a modified binary, a modified signature and a modified sidecar are each refused, and a sidecar the signature covers may not be removed. | tampered code, tampered signature, tampered notes, tampered graph, missing signed sidecar |
| The detached `.resid-prov.cbor`, when present, must be the trailer byte for byte. | detached copy that differs from the trailer |
| The record's `grant` is `main`'s declared `@requires`, not an empty list; a program without authority records `[]`. | grant is main's @requires, empty grant for a main without @requires |
| When the graph artifact is signed, its sources must be the record's and every capability its nodes use must lie within the grant. A record that lies about either, under a valid signature, is refused. | graph capability outside the signed grant, graph sources differ from the signed record |
| The verdict says which keyring the key came from: `anchored` (`$RESID_HOME/keys`), `supplied` (`--pub`, `RESID_VERIFY_PUB`) or `local` (`keys/*.pub` in the current directory). A key found in both the install and the current directory is reported as anchored. `--anchored` refuses anything but the install's keyring. | supplied key is reported, cwd keys/ is local, RESID_HOME/keys is anchored, --anchored refuses a supplied key, --anchored refuses a local key |
| Evidence and attestation are printed apart. The code hash, the sidecars, the detached copy, the builder (when the verifying `residc` is the one recorded) and the graph cross-checks are evidence; toolchain, profile, output and grant are attestation; sources are attestation unless `--sources DIR` re-hashes them, and then a changed or missing file is a failure. | code hash is evidence, builder compiler is evidence, another compiler: builder is attested, sources are attested without a tree, --sources re-derives, --sources catches a changed source |
| The trailer is readable by an independent implementation (Python `cbor2` + `cryptography`), which also verifies the signature and the code hash. | independent reader accepts the genuine trailer |
| CBOR one-, two- and four-byte length forms read back; a head whose length runs past the buffer is refused. | two sources use the two-byte length form, cbor one-, two- and four-byte lengths read back |
| A concealed payload needs `RESID_PROV_KEY`, and a wrong key fails authentication. | concealed verify without key, concealed wrong key |
| Rebuilding the same source with the same key gives the same bytes. | reproducible |

Not guaranteed: `toolchain` and `profile` are attestation only, and
`compiler` is evidence only when the `residc` running `verify` is the
builder (otherwise it is a hash the reader may compare by hand); a
`local` key verifies the signature exactly as an anchored one does, and
is only *named* as local -- `--anchored` is the switch that refuses it;
the graph cross-check applies only to builds that carry a signed graph
artifact (debug and check profiles); `--sources` compares against the
paths the record names, so a build from another directory needs its
relative layout reproduced.

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

| Certificate signatures are verified for ECDSA P-256 (`1.2.840.10045.4.3.2`), RSA PKCS#1 v1.5 (`1.2.840.113549.1.1.11`) and RSA-PSS (`1.2.840.113549.1.1.10`). A PSS signature is only accepted when its parameters *say* SHA-256, MGF1-SHA-256 and salt 32 -- RFC 4055's defaults are SHA-1, which is not verified, so absent parameters are refused rather than assumed. | rsa_pkcs1, rsa_pss, pss parameter check |
| A certificate may only sign for another if it says `CA:TRUE` and allows `keyCertSign`. A leaf handed over as an intermediate cannot issue. | leaf must not be a CA, issuer CA checks |
| A store carrying CRLs enforces them: a certificate the issuer's current CRL lists is refused. | good.der, bad.der |
| A CRL is used only if it is signed by the issuing CA and inside its `thisUpdate`..`nextUpdate` window, so a stale CRL cannot certify anything. | a stale CRL must not be usable |
| `revocation_required` refuses a certificate that no current CRL covers, so "no revocation information" never reads as "not revoked". | good.der under revocation_required, revocation_required must refuse a stale CRL |
| CRLs and roots are loaded separately, so a bundle of CRLs is never mistaken for a set of trust anchors. | (loading) |

Not guaranteed:

- Revocation evidence comes from the store's CRLs and OCSP responses;
  no stapled OCSP response in the handshake is read. A store with
  neither for an issuer has no revocation information about that
  issuer's certificates, and `revocation_required` is the switch that
  makes that a refusal rather than an acceptance.
- A pinned certificate (`trust_store_has`) is accepted without any chain,
  so it is not covered by a CRL: pinning is an explicit decision to trust
  those exact bytes, revocability included.
- A trust anchor is not itself checked for revocation.
- `require_signatures` does not extend to path dependencies, which spec
  §28.3 exempts as local source.
- Constant-time behavior of compiled code is not verified: the compiler
  (and LLVM) may introduce branches.
- DER, X.509 and HPACK parsers abort on malformed input rather than
  returning an error.
- Certificate signature algorithms other than ECDSA P-256, RSA PKCS#1
  v1.5 and RSA-PSS with SHA-256 are not verified.

## Bootstrap

`build/boot/seed.ll` is committed LLVM IR of the compiler. `./boot.sh`
links it, rebuilds the compiler from source twice and requires all three
IR outputs to be byte-identical, so the seed is exactly what the source
compiles to under itself. This does not rule out a seed that reproduces
itself while miscompiling (the "trusting trust" problem): no independent
second compiler of the current source is maintained.
