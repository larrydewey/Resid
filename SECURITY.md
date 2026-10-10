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
  terminal, clock, display, declassify)
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
| The display is a capability like any other: connecting to a window server, sending and receiving on it (descriptors included), waiting on it and mapping shared memory for a frame are the `resid_disp_*` builtins, needing `display`. The family has no modes (`display(readonly)` is refused, E0213): connecting to a window server, opening a window, drawing into it and reading from it all act on what the program itself put on screen. It reaches nothing outside this machine's own session — a `DISPLAY` naming another host is refused — and a shared mapping is a handle, so no address reaches the program. | `gk_builtin_family`, `gk_unknown_family`, `gk_display_moded`, `provider_family_of_line` | `err_display_ungranted`, `err_display_readonly`, `display_transport`, `tests/runtime` (`display.resid`, `display_shm.c`) |
| Publishing a secret is a capability: `declassify(s, "reason")` needs the mode-less family `declassify`, carried to every caller (E0219) and bounded like any family; `declassify(readonly)` is refused (E0213). The reason must be a non-empty string literal (E0251), and each call is an effect in the graph artifact (`declassify.<reason>`, capability `declassify`). The grant is also checked at force time, like a provider call: `sec_erase` marks each declassify left after reduction, and every function, lambda and spawn body holding one calls `resid_cap_check("declassify")` in its entry block (after a sandbox's `resid_cap_enter`, before a self-recursive loop's head; authority is fixed for one call), so a closure that declassifies, run inside a `spawn` list or sandbox ceiling without `declassify`, aborts (a spawn region fails) instead of publishing. A declassify folded to a literal leaves no code and no check. | `gk_builtin_family`, `gk_unknown_family`, `sec_declassify_moded`, `sec_call`, `ga_effect`, `sec_erase` (`sec_known_under`), `lw_declassify_check`, `rt_cap_check` | `err_declassify_ungranted`, `err_declassify_moded`, `err_declassify_reason`, `secret_ok`, `secret_declassify_granted`, `secret_declassify_spawn_dropped`, `secret_declassify_sandbox_dropped`, `secret_known_declassified` |
| A `Secret(T)` never decides control flow, an address or a public result: conditions, `match`, logic, comparisons, `/` and `%`, indexes, range bounds and shift amounts are refused (E0255); checked `+ - *` are refused because their overflow abort branches (E0254); bitwise operators, public shifts and `wrapping_*` keep the result secret. A secret cannot wrap a type whose shape is control or identity (E0253). | `sec_bin`, `gk_cond`, `gk_ifx`, `gk_match`, `gk_index`, `sec_lift`, `sec_wrap_err` | `err_secret_if`, `err_secret_ifx`, `err_secret_while`, `err_secret_match`, `err_secret_and`, `err_secret_compare`, `err_secret_div`, `err_secret_checked_add`, `err_secret_shift_amount`, `err_secret_index`, `err_secret_wrap_option`, `secret_index_public` |
| A secret never leaves the checked program unannounced: it cannot be a provider argument (E0255; `write_secret` takes a declassified value, so persisting key material needs the grant and is on the graph), a `spawn` region's result (E0255), or a `Map` key or `Set` element in any written type (E0253). | `gk_provider`, `gk_expr0` (spawn), `sec_key_err` in `gm_unknown_types` | `err_secret_provider_write`, `err_secret_spawn_result`, `err_secret_map_key`, `err_secret_set_element`, `err_secret_nested_map_key`, `secret_write_declassified` |
| A program that handles secrets runs its allocator in secret mode, switched on before `main` (the compiler emits the call when the reduced program contains a secret): every heap, region, thread-stack and thread-local mapping is `MADV_DONTDUMP`, freed small and big blocks are zeroed before they can be reused, and freed region pages bypass the page cache and are zero-filled by `MADV_DONTNEED`. Registers, static data and the initial process stack are not covered. | `rt_secret_mode_set`, `sys_mmap`, `c_free`, `big_free`, `pages_give`, `pages_take` (runtime); `main_entry_ir`, `td_main_ir`, `sec_graph_has` (compiler) | `tests/runtime/secret_zero.c` (with a control: without the mode the bytes survive) |
| The builtins of secret values cannot be redefined (E0259): a program's function named `secret`, `declassify`, `classify`, `secret_split`, `secret_join` or `ct_select` would replace the builtin in every module, so a dependency could otherwise turn `secret` or `declassify` into anything. | `sec_reserved` in `gm_unknown_types` | `err_secret_reserved_name` |
| A secret integer wider than 32 bits is never stored in a list, builder, vector, map or set (E0258), checked on written types and on every type the checker gives an expression (programs with secrets log them), so generic copies and inferred types are covered. List integers of 2^54 or more are boxed, a choice made on the value; secret bytes are UInt(8) and wide secrets live in records and parameters. | `sec_wide_err`, `sec_wide_scan` (in `gk_finish`), the type log enabled by `sec_graph_has` | `err_secret_wide_list`, `err_secret_wide_elements`, `err_secret_wide_generic` |
| ChaCha20, Poly1305 and the ChaCha20-Poly1305 AEAD have one implementation (`lib/chachag.resid`), generic over `Word(W, B)` (32-bit words, bytes) and `Wide512(P, B)` (Poly1305's accumulator, `Int(512)` or `Secret(Int(512))`, kept in parameters, never in a list); `lib/chacha.resid`'s API is the public copy. Nonce, counter, AAD, lengths and the received ciphertext are public; the reduction mod 2^130 - 5 subtracts p under a sign mask behind `ct_hide`; the open verdict is one bit published through `CtSame(B)` (`ct_equal` at public bytes, `ct_eq` at secret bytes, so the secret copy needs `@requires(declassify)`). Checked against RFC 8439 §2.5.2 and §2.8.2, the public copy against Wycheproof, and both copies under valgrind with the key and plaintext marked secret. | `lib/chachag.resid`, `lib/chacha.resid`, `lib/word.resid` (`Wide512`), `lib/crypto.resid` (`CtSame`), `sec_liftable` | `secret_chacha20poly1305`, `chacha20poly1305_in_resid`, `tests/ct/run.sh` (`chacha`, `chacha-secret`, `chacha-open-secret`, `poly1305-secret`), `tests/crypto` (Wycheproof ChaCha20-Poly1305) |
| AES-128/192/256, AES-GCM (any IV length) and AES key wrap have one implementation (`lib/aesgcmg.resid`), generic over `Word(W, B)` and `Block128(X, W, B)`: 128-bit blocks (`UInt(128)` or `Secret(UInt(128))`) and the AES-NI round keys live in records and parameters, the schedule is a list of 32-bit words; `lib/aesgcm.resid`'s API is the public copy. On AES-NI / AESE and PCLMULQDQ / PMULL the rounds and GHASH use `aesni_enc_round`, `aesni_enc_last_round` and `gf128_mul_hw`, which take secrets (constant-time instructions); otherwise the S-box is computed four bytes per word (an inverse in GF(2^8) as x^254, then the affine map) and GHASH multiplies with masks. IV, AAD, lengths, the received ciphertext and the wrapped key are public; GCM open and key unwrap publish one bit through `CtSame(B)` (the secret copies need `@requires(declassify)`). Checked against the GCM spec's test cases 4, 6, 10 and 16 and RFC 3394 at both types and on both paths, the public copy against Wycheproof, and the secret copy under valgrind on both paths with the key and plaintext marked secret. | `lib/aesgcmg.resid`, `lib/aesgcm.resid`, `lib/word.resid` (`Block128`), `sec_liftable` | `secret_aesgcm`, `aes128gcm_in_resid`, `tests/ct/run.sh` (`aes-gcm-secret-*`, `aes-gcm-open-secret-*`, `aes-kw-secret-*`, `aes-unwrap-secret`, `aes-sw`, `aes-dec`, `aes-gcm`, `aes-kw`, `ghash`, `ghash-sw`), `tests/crypto` (Wycheproof AES-GCM, key wrap) |
| X25519 (RFC 7748) has one implementation (`lib/x25519g.resid`), generic over `Wide512(P, B)`: field elements mod 2^255 - 19 are `Int(512)` or `Secret(Int(512))` values kept in parameters (never in a list), always reduced below p; reduction subtracts p under a sign mask behind `ct_hide`, and the Montgomery ladder's conditional swaps are xor masks built from the scalar bit. `lib/x25519.resid`'s API is the public copy. The private scalar is secret; the peer's public key, the field constants and the inversion exponent are public. Two facts are published, each through a behavior whose secret instance declassifies (so the secret copy needs `@requires(declassify)`): whether the shared secret is all zeros (`CtSame(B)`) and the public key derived from a private key (`X25519Pub(B)`). Checked against RFC 7748 §5.2 and §6.1 at both types, the public copy against Wycheproof, and both copies under valgrind with the scalar marked secret. | `lib/x25519g.resid`, `lib/x25519.resid`, `lib/word.resid` (`Wide512`), `lib/crypto.resid` (`CtSame`) | `secret_x25519`, `err_secret_x25519_public`, `x25519_in_resid`, `tests/ct/run.sh` (`x25519`, `x25519-secret`), `tests/crypto` (Wycheproof X25519) |
| P-256 and P-384 key derivation, ECDH and ECDSA signing have one implementation, generic over `P256Word(F, B)` / `P384Word(F, B)` (field elements `UInt(576)` / `UInt(832)` or `Secret(UInt(576))` / `Secret(UInt(832))`, kept in records and parameters, never in a list), generated into `lib/p256.resid` and `lib/p384.resid` by `tools/gen_nistp.py`: Montgomery arithmetic with masked conditional subtraction, the complete RCB16 formulas, a fixed-length ladder with masked selection, Fermat inversion of the nonce with the fixed public exponent n - 2, and the RFC 6979 nonce as an HMAC-DRBG over the generic HMACs (`lib/sha256g.resid`, `lib/sha512g.resid`) keyed by the secret key. `lib/ecdsa.resid`'s `ecdsag_*`, `ec_public_keyg` and `ecdhg` take the key as `List(B)`; its `List(Int)` API is the public copy, and verification (public inputs only) runs on it. A signature, a public key and the verdicts "key usable" and "point finite" are published through the behavior's open verb (`ct_public`, plus `declassify` at secret types, so those secret copies need `@requires(declassify)`); an ECDH shared secret stays secret. A secret cast that keeps every value stays secret; any other is refused (E0255). Checked against RFC 6979 A.2.5/A.2.6 and RFC 5903 §8.1 at both types, the public copy against Wycheproof ECDSA/ECDH and the RFC 6979 vectors, and both copies under valgrind with the key marked secret. | `tools/gen_nistp.py`, `lib/p256.resid`, `lib/p384.resid`, `lib/ecdsa.resid`, `sec_cast` | `secret_ecdsa`, `secret_widening_cast`, `err_secret_narrowing_cast`, `tests/ct/run.sh` (`p256-sign`, `p384-sign`, `p256-ecdh`, `p384-ecdh`, `p384-public`, `p256-secret-sign`, `p384-secret-ecdh`, `p384-secret-public`), `tests/crypto` (Wycheproof ECDSA/ECDH, RFC 6979) |
| Ed25519 key generation and signing have one implementation (`lib/ed25519g.resid`), generic over `Wide512(P, B)` (field elements below p and scalars as `Int(512)` or `Secret(Int(512))`, kept in records and parameters, never in a list) and `Word64(W, B)` (SHA-512 of the seed); `lib/ed25519.resid`'s API, its field and point arithmetic (shared with `lib/x25519.resid`) and verification are the public copy. Seed, expanded key, nonce r and the scalar arithmetic with a are secret at secret types; field reductions subtract under a sign mask behind `ct_hide`, and the scalar multiplication is a double-and-always-add ladder that picks the sum or the double with a mask from the scalar bit (no table, index or branch). The public key and the signature leave through `Publish(B)` (`lib/word.resid`: a copy at public bytes, `declassify` at secret bytes), so every caller of the secret copy needs `@requires(declassify)`; the compiler's provenance signing (`write_provenance`, `residc keygen`) holds its seed as `List(Secret(UInt(8)))` and carries the grant up to `main`. Checked against RFC 8032 §7.1 (both copies), the public copy against Wycheproof EdDSA, and both copies under valgrind with the seed marked secret. | `lib/ed25519g.resid`, `lib/ed25519.resid`, `lib/word.resid` (`Publish`, `Wide512.p_mul256`), `lib/cose.resid` (`cose_sign1`), `compiler/driver.resid` (`write_provenance`, `cmd_keygen`), `scope_arith_builtin` (`ct_hide`/`ct_select` are register-only, so masked field code gets no region scope) | `secret_ed25519`, `err_ed25519_secret_ungranted`, `ed25519_sign_in_resid`, `ed25519_verify_strict`, `tests/ct/run.sh` (`ed25519-sign`, `ed25519-secret-sign`, `ed25519-secret-pub`, `x25519`), `tests/crypto` (Wycheproof EdDSA), `tests/provenance` |
| HPKE (RFC 9180) has one implementation (`lib/hpkeg.resid`), generic over the byte type and the word behaviors of its primitives (`Word`, `Word64`, `Block128`, `Wide512`): the labeled HKDF over HKDF-SHA256/384/512 (`lib/sha256g.resid`, `lib/sha512g.resid`), the three KEMs -- DHKEM(X25519, HKDF-SHA256) over `lib/x25519g.resid`, and DHKEM(P-256, HKDF-SHA256) and DHKEM(P-384, HKDF-SHA384) over `lib/ecdsa.resid`'s `ecdhg` / `ec_public_keyg` (the generic curves) -- the key schedule in all four modes, the nonces, seal and open over AES-128/256-GCM and ChaCha20-Poly1305, and the exporter; `lib/hpke.resid`'s API is the public copy, and no suite has a public-only path. At secret types the private keys, the shared secret, the PSK, the key schedule's secret, key, base_nonce and exporter secret, each nonce and the plaintext are secret; public keys, `enc`, `info`, `psk_id`, the AAD, the received ciphertext and the sequence number are public. The AEADs take the nonce as secret bytes (`aes_gcmg_seal_ivb`, `chacha20poly1305g_seal_nb`, and their opens). Published by design, each through a behavior whose secret instance declassifies (so the secret copy needs `@requires(declassify)`): derived public keys (`X25519Pub(B)`, or the curve's open verb), the all-zero DH check and the tag verdict (`CtSame(B)`), and for the NIST curves whether a derived candidate or a peer key is usable. Checked against RFC 9180 A.1, A.2 and A.3 (DHKEM(P-256)) at both types, DHKEM(P-384) in auth mode at both types against each other, the public copy against all of the RFC's vectors, and the secret copy under valgrind with the recipient key, or the ephemeral key and plaintext, marked secret. | `lib/hpkeg.resid`, `lib/hpke.resid`, `lib/ecdsa.resid` (`ecdhg`, `ec_public_keyg`), `lib/aesgcmg.resid` (`*_ivb`), `lib/chachag.resid` (`*_nb`) | `secret_hpke`, `secret_hpke_nist`, `tests/ct/run.sh` (`hpke-open`, `hpke-open-secret`, `hpke-open-secret-chacha`, `hpke-seal-secret`, `hpke-seal-secret-chacha`, `hpke-p256-secret`), `tests/crypto` (`hpke_rfc9180.txt`, `hpke_p384_pyca.txt`) |
| The TLS 1.3 key schedule (RFC 8446 §7.1), Finished (§4.4.4) and AES-128-GCM record protection (§5.2) have one implementation (`lib/tls.resid`'s `tlsg_*`), generic over the byte type, on the generic HKDF-SHA256 and AES-GCM with the nonce in bytes `B` (`aes_gcmg_seal_ivb`, `aes_gcmg_decrypt_ivb`); its `List(Int)` API is the public copy. The server and client run the secret copy: the x25519 ephemeral key and shared secret (`lib/x25519g.resid`; an all-zero shared secret is refused), the early, handshake and master secrets, the traffic secrets, the finished keys, and the record keys and IVs (`TlsKeys`) are `List(Secret(UInt(8)))`, and each record's nonce (IV xor sequence number) is computed in secret bytes. The server's signing key (`ServerKey`) is secret from the moment its file is read (`tls_key_parse`, see the key-loading row) and CertificateVerify is signed with `ed25519g_sign` / `ecdsag_sign_digest`. Published by design: the key share, the signature, and through `TlsPublish(B)` (one `declassify` each, with its reason) record ciphertext, an authenticated record's plaintext handed to the application, and the Finished MAC; a record's tag and the peer's Finished publish one bit through `CtSame(B)`. So every function and program that runs a handshake or a record carries `@requires(declassify)` (E0219; spawn lists included, E0214). Checked against the RFC 8448 §3 trace at both types (shared secret, every secret, key and IV, both Finished, the client's protected Finished and first application record), live handshakes against this repository's client and `openssl s_client`, and the secret copy under valgrind with the shared secret, or the record key and IV, marked secret. | `lib/tls.resid` (`tlsg_*`, `TlsPublish`, `TlsKeys`), `lib/tlsserver.resid`, `lib/tlsclient.resid`, `lib/tlswire.resid`, `lib/tlskey.resid` | `secret_tls_key_schedule`, `err_secret_tls_record_ungranted`, `tests/ct/run.sh` (`tls-key-schedule-secret`, `tls-record-seal-secret`), `tests/tls/run.sh` |
| SHA-512, SHA-384 and HMAC-SHA-512/384 are generic over `Word64(W, B)` (`lib/sha512g.resid`), with the state in a record and the schedule in a 16-word parameter window so no 64-bit secret word is stored in a list (where values of 2^54 or more are boxed, a branch on the value). Checked against the existing implementations and RFC 4231. | `lib/sha512g.resid`, `lib/word.resid` | `secret_sha512`, `tests/ct/run.sh` (`sha512-secret`, `hmac512-secret`) |
| SHA-256, HMAC-SHA-256 and HKDF-SHA-256 have one implementation, generic over `Word(T)` (`lib/word.resid`): the copy at `Secret(Int)` is checked by the compiler like any code on secrets, and the copy at `Int` is `lib/crypto.resid`'s software block function. Both are checked against RFC 4231 / RFC 5869 and the existing implementation; the secret copy runs under valgrind with no secret-dependent branch or address. | `lib/sha256g.resid`, `lib/word.resid` | `secret_hmac_hkdf`, `tests/ct/run.sh` (`sha256-secret`, `hmac-secret`, `sha256-sw`), `tests/crypto` |
| A secret the compiler knows after reduction is refused (E0250): it would be in every copy of the binary. Only a `secret(...)` written directly inside `declassify(...)` is accepted, which states that the value is public. | `sec_known_check` (run on the reduced graph before lowering) | `err_secret_known`, `err_secret_known_folded`, `secret_known_declassified` |
| `ct_select(c, a, b)` on a `Secret(Bool)` selects with masks behind an empty-asm barrier, never a branch or `select`; `ct_eq` in `lib/crypto.resid` folds every byte into one secret word, reduces it to one bit and publishes only that bit, under the `declassify` grant. Both are checked under valgrind on the optimized binary. | `sec_select`, `lw_ct_select`, `ct_eq` | `secret_ct_select`, `secret_ct_eq`, `err_ct_eq_ungranted`, `err_ct_select_public_cond`, `tests/ct/run.sh` (`ct-select`, `ct-eq`) |
| A secret is never observed through a behavior: the structural `Show` refuses any type holding one and names the field path (E0256); `Show`, `Serialize`, `Hash`, `Eq` and `Ord` are never given for a secret, whether declared, asked by a verb or needed by a generic copy (E0257); a type's own `Show` is checked like any function. After checking, `Secret(T)` is erased and lowers exactly as `T`. | `sec_path`, `gm_find_inst`, `gm_builtin_inst`, `gm_inst_err`, `sec_obs`, `sec_erase` | `err_secret_show`, `err_secret_show_field`, `err_secret_show_verb_field`, `err_secret_show_instance`, `err_secret_wrapper_instance_leak`, `err_secret_serialize`, `err_secret_hash`, `err_secret_generic_show`, `secret_wrapper_instance_declassified` |
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
needs the full `network` grant, as before. Serving, and checking that the
certificate carries the key, also need `declassify`: the private key and
every TLS secret are typed secret (spec §48), and the handshake and record
layer publish what goes on the wire (a key share, a signature, ciphertext)
and hand up what an authenticated record decrypts to. The same holds for
the client (`tls_client_connect`, `tls_https_get`, `resid-fetch`,
`resid build`'s `https://` fetch).

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

- Only `ecdsa_secp256r1_sha256`, `ecdsa_secp384r1_sha384` and `ed25519`
  are produced. RSA signing, session resumption (PSK or tickets), client
  certificates, encrypted ClientHello, record compression and 0-RTT are
  not implemented. A client offering none of the server key's algorithm
  is refused rather than served with a signature the certificate does not
  cover.
- No session ticket is ever sent, so every connection pays a full
  handshake. That is the safe direction to be wrong in.
- This repository's own client verifies the CertificateVerify schemes
  ECDSA P-256/SHA-256, ECDSA P-384/SHA-384, Ed25519 and RSA-PSS with
  SHA-256/384/512 (rsaEncryption and RSASSA-PSS keys), each only with a
  certificate key of the matching kind (`tls_scheme_alg`).
- The key file's permissions are not checked (see above).
- Constant time is checked for the operations listed under
  "Cryptography library" below, on the shipped (optimized, LTO) code,
  including the TLS key schedule and one record sealed and opened under
  secret keys; a whole handshake on a socket is not run under valgrind.
  The secret types cover the rest: the checker refuses a branch, index or
  comparison on any TLS secret.

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
| Every primitive agrees with Wycheproof (C2SP, committed under `tests/crypto/vectors/`, including every "invalid" case): ECDSA P-256/P-384 with SHA-256/384/512 in DER and r‖s form; ECDH P-256/P-384 (raw points and SubjectPublicKeyInfo); RSA PKCS#1 v1.5 and RSA-PSS at 2048/3072/4096 bits with SHA-256/384/512; HMAC and HKDF with SHA-256/384/512; AES-128/192/256-GCM; AES key wrap; ChaCha20-Poly1305; X25519; Ed25519. | `tests/crypto/run.sh` (≈12,400 vectors) |
| Deterministic ECDSA nonces are RFC 6979's, byte for byte (the RFC's own vectors and pyca/cryptography's). | `ecdsa_rfc6979.txt` |
| HPKE (RFC 9180) matches the RFC's vectors for DHKEM(P-256) and DHKEM(X25519) in all four modes with every KDF and AEAD, and interoperates with pyca/cryptography for DHKEM(P-384). A forged tag never opens and does not advance the sequence number. | `hpke_rfc9180.txt`, `hpke_p384_pyca.txt`, roundtrip |
| COSE_Sign1 (ES256, ES384, PS256/384/512, RS256/384/512, EdDSA) reads the algorithm only from the protected header, requires the key type and curve it names, and refuses a wrong tag, trailing bytes, a swapped payload and an algorithm only in the unprotected header. | `cose_sign1.txt` |
| ECDSA verification rejects `r` or `s` outside `[1, n-1]`, keys off the curve, sums at infinity, and DER signatures that are not strict DER (BER lengths, padded or negative integers, trailing bytes). | Wycheproof ECDSA files |
| RSA verification refuses moduli below 2048 bits, even moduli and even or tiny exponents, compares PKCS#1 v1.5 by re-encoding (never by parsing the recovered block), and rejects a signature representative `>= n`. | Wycheproof RSA files, `rsa1024-ca` |
| **Constant time, checked on the binary.** `tests/ct/run.sh` runs ECDSA signing (P-256, P-384), ECDH, public-key derivation, X25519, Ed25519 signing, AES (AES-NI and software, encrypt and decrypt), AES-GCM, GHASH, AES key unwrap, ChaCha20-Poly1305, SHA-512, HMAC, HKDF, HPKE seal and open (X25519 and P-256), the TLS 1.3 key schedule and record protection, and `ct_equal` under valgrind memcheck with the secret marked undefined (`ct_secret`). No branch, conditional move or memory address depends on a secret in the optimized, LTO-linked code; a negative control (a secret-indexed table) must be reported. The software AES S-box is computed, not looked up; field reductions, point selection and conditional subtractions are masks, and masks pass through `ct_hide` so LLVM cannot turn them back into branches. The case list comes from the knowledge graph, and a coverage gate (`tools/resid-ctcover.resid`) fails the run when a library function that handles a secret -- a public signature with a `Secret` in it (directly or through a record or sum holding one), a public generic function that runs on secrets once instantiated at a `Secret` type, or any function that declassifies -- is reached by no case at a secret type, unless `tests/ct/uncovered.txt` lists it with a reason (today the socket loops and the `TlsCfg` constructor). Of the 232 functions in that surface, 227 are reached by the 61 cases, among them the TLS server handshake's pure steps, constant-time base64, and loading PEM and DER key files (PKCS#8, SEC1, Ed25519) with every byte of the file marked secret. | `tests/ct/run.sh` |
| A server's private key file is secret bytes from the moment it is read: `tls_key_load` reads it as bytes (`filesystem.read_bytes`, never text) and `tls_key_parse` makes every byte `Secret(UInt(8))` before looking at any. Only framing is published, each with its `declassify` reason: each byte's class (line feed, other whitespace, dash, '='; computed with masks), the PEM armor lines (which start with a dash, which a base64 line cannot), the DER identifier and length octets, version and algorithm OIDs, read one at a time at public offsets, and whether a file is DER (its first byte, a SEQUENCE's 0x30). The base64 body is decoded in constant time by `base64g_decode` (`lib/crypto.resid`, generic over `Word(W, B)`, `base64_decode` its public copy): each character's value and validity come from range masks, never a table or a branch, invalid characters set a bit in a secret flag, and that flag is the one bit published, through `CtSame(B)`. The private scalar or seed is sliced out of the secret DER at public bounds and goes into `ServerKey` without being published; an EC scalar's range [1, n-1] is checked by the constant-time public key derivation, whose "key usable" verdict and public key are published by design. So loading a key needs `@requires(declassify)`. Checked under valgrind with every byte of the key file marked secret (P-256, P-384 and Ed25519 PKCS#8 PEM, P-256 SEC1 PEM, PKCS#8 DER, and refused files), and the decoder against RFC 4648 §10 and malformed input at both types. | `lib/tlskey.resid` (`tls_key_parse`, `tk_classes`, `tk_pem_block`, `tk_at`), `lib/crypto.resid` (`base64g_decode`, `b64g_sextet`) | `tests/ct/run.sh` (`tls-key-secret`, `base64-secret`), `secret_base64`, `err_base64_secret_ungranted`, `tests/tls/run.sh` (key loading) |
| Every parser of untrusted bytes is total: certificates, CRLs, OCSP responses, keys (PKCS#8, SEC1, SPKI, RSAPublicKey, COSE_Key), ECDSA signatures, CBOR/COSE, TLS handshake messages, PEM, HTTP/2 frame headers and HPACK header blocks never abort and never loop on malformed input; mutated inputs are run through all of them (an abort is caught per input, a hang times out). | fuzz section of `tests/crypto/run.sh` |
| Randomness comes from `getrandom(2)`, falling back to `/dev/urandom`; failure aborts. | (runtime code) |

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

| Certificates are parsed strictly (`x509_parse`: DER only, inner and outer signature algorithms byte-equal, well-formed and duplicate-free extensions) and verified for ECDSA with SHA-256/384/512 on P-256 or P-384 keys, RSA PKCS#1 v1.5 with SHA-256/384/512, RSA-PSS with SHA-256/384/512 (any salt length; MGF1 must use the message hash; `hashAlgorithm` and `maskGenAlgorithm` must be present, since their defaults are SHA-1) and Ed25519. An id-RSASSA-PSS key only verifies PSS. AMD's published SEV ARK/ASK chains (Milan, Genoa) and the AWS Nitro root verify. | rsa_pkcs1, rsa_pss, pss parameter check, the x509 section of `tests/crypto/run.sh` |
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
- P-521, SHA-1 (in any signature), SHA-3, DSA, RSA below 2048 bits and
  ECDSA over curves other than P-256 and P-384 are not verified: such a
  certificate is refused, not accepted on another algorithm's terms.
- Constant time is checked with valgrind on x86-64 only, and covers
  secret-dependent control flow and addresses, not variable-latency
  instructions (the only divides in the checked binary are on public
  indices in the AES key schedule and in the allocator, found by reading
  its disassembly rather than by a test). The checks need valgrind installed;
  without it `tests/ct/run.sh` runs only its coverage gate and reports the
  valgrind runs skipped. Coverage is reachability in the call graph: a case
  covers a function its code can call, not one it is proven to execute on
  every path (an AES-NI case also reaches the software rounds), and a
  generic function counts only when the probe instantiates it at a
  `Secret` type.
- A key file's framing is published by design (the key-loading row): the
  positions of its line breaks, whitespace, dashes and '=' padding, its
  armor lines, and its DER tags, lengths and OIDs -- which say what kind
  of key it is, and how long, but nothing of the key. A PEM file is told
  from DER by its first byte, so a PEM file whose explanatory text before
  the armor starts with '0' is read as DER and refused. The file's bytes
  as read (`filesystem.read_bytes`) are an ordinary list until they are
  wrapped, freed like any other memory of a program in secret mode.

## Bootstrap

`build/boot/seed.ll` is committed LLVM IR of the compiler. `./boot.sh`
links it, rebuilds the compiler from source twice and requires all three
IR outputs to be byte-identical, so the seed is exactly what the source
compiles to under itself. This does not rule out a seed that reproduces
itself while miscompiling (the "trusting trust" problem): no independent
second compiler of the current source is maintained.
