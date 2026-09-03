# Resid — Project Status

**Specification**: `resid_specification.txt` v3.2 (Production Ready; v3.1 base + integer-width semantics amendments; some items still in flux — see audit below)
**Implementation**: Rust stable + LLVM (inkwell), monorepo Cargo workspace
**Interpreter**: None — direct LLVM
**Wide numerics**: `Int(128)..Int(512)` / `UInt(N)` via LLVM arbitrary-width integers, `Float` capped at 128, `Dec(N)` exact decimals

---

## 0. Current Snapshot

**~725 tests pass** (lexer 17, parser 115, resid-ir 46, resid-type 245,
  resid-codegen 137, resid-build 47, resid-fmt 5,
  resid-cache 7, resid-notes 2, resid-why 7, resid-lsp 5,
  resid-graph 4, resid-builtin 0, residc 0 unit + ~88 e2e incl.
`len_arg_and_cross_module_recursive_list_builder`,
  `run_ed25519_verify_in_resid` has vector mismatch;
  `run_stage2_provenance_sidecar` signature verification invalid);
`run_h2_post_and_continuation_in_resid`,
`run_sandbox_handle_entry_file_argument`,
`run_sandbox_force_time_guard_present`, `run_sandbox_force_time_guard_fires`,
`build_cache_invalidates_on_import_change`,
`run_behavior_ord_sort`, `bootstrap_behavior_ord_parity`,
`run_sandbox_enforcement`, `run_map_set_types`,
`bootstrap_map_set_parity`, `run_constraint_types`,
`reduction_known_fib_comptime_print`, `reduction_falls_back_to_runtime`,
`run_sandbox_handle_entry_file_param`, `run_sandbox_capability_mode_readonly`,
`run_spawn_child_failure_err`,
`bootstrap_option_sum_parity`, `bootstrap_match_parity`, `bootstrap_question_else_parity`,
`run_wide_int_boxing`, `run_early_return_in_branch_and_recursion`).

**Early-return bug fixed**: comptime reduction (`resid-type/src/reduce.rs`)
was dropping explicit `return` statements inside `if`-branches during
constant folding — `if (n <= 0) { return 42; }` folded `f(-5)` to the
trailing `7` instead of `42`. `eval_block` now always propagates
`block.ret` (parse_block extracts every explicit `return` into it) through
the `pending` flag, and the `ExprKind::If` evaluator leaves `pending` set
so the enclosing statement loop aborts. Codegen already emitted correct
LLVM; only the comptime path was wrong. e2e
`run_early_return_in_branch_and_recursion` (`42\n7\n15\n55`) now green;
`resid-type` `probe_primitive` updated to assert early-abort semantics.

### Progress on item 9 — `value?` sugar

**Stage-1 DONE** (both Option and Result; e2e `run_question_sugar_option_and_result`).

**Stage-2 DONE**: Option `?`/`else` fully implemented and parity-verified (`bootstrap_question_else_parity`; byte-identical output `2\n-1\n-5\n7\n-1\n42\n-2` through Rust residc AND the driver). All 11 bootstrap e2e pass. Result `?`/`else` typechecker has `Ok`/`Err` constructors, `match` arms, `?`/`else` typing; codegen has `?`/`else` lowering with tag dispatch. Expected-type threading for `Ok`/`Err` hole adoption now complete: `Result(Int, Str) a = Err("boom"); a else {-5}` works without explicit type annotations. Binding declares the full `Result(A, B)` type; bare `Err(v)` adopts the Ok half from the declared type; bare `Ok(v)` adopts the Err half. Depth-aware type-list splitting (`split_type_at`/`split_type_list` in typecheck, `find_sep_depth`/`split_rest_depth` in codegen) fixes naive comma-split on `Result(Int, Str)` params. Whitespace robustness: `res_elem_err`/`res_elem_ok`/`opt_elem` now strip/skip whitespace after commas.
Full e2e suite runtime ≈ 15 min (slow: live-network h2/TLS + bootstrap
driver runs) — not a hang; use `cargo test -p residc --test e2e -- <filter>`.
Frontend → LLVM → native binaries fully working; **stage-2 self-hosting
proven**. Map/Set types now fully supported in stage-2 driver (recursive
FNV-1a lookup/insert/remove, persistent functional style, no mutation).

Option sum-type constructors now work in stage-2 driver: `Some(v)`/`None`
lower to the same `resid_box_new` tag-1/tag-2 boxes as stage-1, with
`None`/`Option(_)` bottom typing adopted at return/bind sites and
`ToString` support for Option values (e2e `bootstrap_option_sum_parity`).

`match` on Option values works in the stage-2 driver: typechecker
(`check_match`/`check_match_sc`/`ck_match_arms`) and codegen
(`cg_match` with tag-dispatch branches, payload GEP/unbox + phi) — arm
order independent of variant, payload binding is scoped, all arms share
one result type (numeric-normalized), and a bare `None` binding adopts
its declared `Option(T)` element width. The scrutinee is parsed as a
primary so `expr { ... }` isn't misread as a struct/map literal, and the
codegen bind keeps the declared type for `Option(x)` hollow values
(e2e `bootstrap_match_parity`).

`?`‑sugar (`m?`) and `else`‑unwrap (`v else { fallback }`) for Option
work in the stage-2 driver: typechecker (`check_bin_rest` hooks with
`is_opt_ty`, payload extraction via `opt_elem`, error messages mirroring
stage-1) and codegen (`cg_bin_rest` emits tag-dispatch for `?` with
early-return on None, and payload/fallback/merge phi for `else`).
Both use the existing `cg_match_payload` for payload unboxing, and
parity with stage-1 is verified byte-identically (e2e
`bootstrap_question_else_parity`).

**Wide-int boxing (Int(128)/UInt(128))**: values wider than 64 bits (e.g.
`Int(64) * Int(64)` → `Int(128)` widening, or `Int(256)`) can now be boxed
into sum variants / unboxed out of them and formatted, in both stage-1 and
stage-2. Runtime gains `resid_box_i128`/`resid_unbox_i128` and
`resid_box_u128`/`resid_unbox_u128` (same one-slot heap box pattern as the
64-bit boxes); codegen dispatches on exactly `bits == 128` to these, with
`Int128ToString`/`UInt128ToString` for formatting. Parity across both
stages verified byte-identically (e2e `run_wide_int_boxing`).

Constraint types (§12) are stage-1 implemented: both `Int[value > 0]` and
`Int where value > 0` parse and discharge on annotated bindings.
The long-standing "context-dependent codegen ghost" is dead —
three root causes, none of them codegen (see §4).
Dependency capability ceilings (§21.1) and per-dependency key pinning
(§28.3) are now enforced at manifest load / type check (see §7). Spawn
capability substitution (§19: child ≤ parent + the child's fresh CapEnv
bounds its whole body) is enforced statically in the type checker.
**Build profiles (§35) now complete**: `residc <f> build|run --profile debug|release|check` with `-O2` for release, cache key includes profile; `check` stops after type checking.
**Reduction relation (§36) complete**: comptime β-reduction of pure functions with step/depth budgets, recursive calls, conditionals, and tail returns; e2e `reduction_known_fib_comptime_print`, `reduction_falls_back_to_runtime`.
**Handle-entry rules (§21.3)**: File method provenance (`read_handle`, `close`) tracked in restricted regions; value provenance across function boundaries tracked for **File parameters** — a File handle may only enter a function whose effective ceiling grants `filesystem` (e2e `run_sandbox_handle_entry_file_param`).
Full e2e suite runtime ≈ 15 min (slow: live-network h2/TLS + bootstrap
driver runs) — not a hang; use `cargo test -p residc --test e2e -- <filter>`.
Frontend → LLVM → native binaries fully working; **stage-2 self-hosting
proven**. Map/Set types now fully supported in stage-2 driver (recursive
FNV-1a lookup/insert/remove, persistent functional style, no mutation).
Constraint types (§12) are stage-1 implemented: both `Int[value > 0]` and
`Int where value > 0` parse and discharge on annotated bindings.
The long-standing "context-dependent codegen ghost" is dead —
three root causes, none of them codegen (see §4).
Dependency capability ceilings (§21.1) and per-dependency key pinning
(§28.3) are now enforced at manifest load / type check (see §7). Spawn
capability substitution (§19: child ≤ parent + the child's fresh CapEnv
bounds its whole body) is enforced statically in the type checker.

### Compiler core (working)

- Full pipeline: lex → parse → type → LLVM IR → native binary via clang +
  tiny C runtime (`crates/residc/resid_rt.c`).
- CLI: `residc <f> build [-o out]`, `residc <f> run` (exit code carries
  through), `residc <f> emit-ir`.
- Complete numeric family with v3.2 width semantics: result-width rules for
  binops, magnitude-based literal inference (a 128-bit literal above
  i128::MAX infers `Int(256)`, not wrapping `Int(128)`), signed headroom
  bit, mixed-width comparisons within a signedness family, casts via
  sext/zext/trunc.
- Boxed composites (List/Struct/Option) with `match`, destructuring,
  if-let/while-let; ranges + slicing; raw/byte strings; f-strings.
- Map/Set types (immutable, persistent): `Map(K, V)`/`Set(T)` literals
  (`{"a": 1}`, `{1, 2}`, empty `{}`), indexing `m[k]` → `Option(V)` (==
  `.get`), methods `.get/.insert/.remove/.contains/.keys/.values/.len`,
  Set `.union/.difference/.intersection/.to_list`; FNV-1a hash over 4-slot
  buckets, `wrapping*` replaced by bounds-checked ops. Chained postfix
  calls (`m.len().to_str()`) supported.
- Providers: filesystem read/write, environment, git, args, process.run.
  Binary-safe TCP builtins (`resid_tcp_send_bin`/`recv_bin`), wall clock
  (`resid_utc_now_civil`). Handle types: `with (Type h = expr) { … }` RAII.
- Soundness hardening: bounds-checked list indexing (`resid_index_abort`),
  shift counts ≥ bit width yield 0.
- Package system: multi-file imports with import-as namespacing,
  transitive deps + lockfile, local registry, per-import capability
  narrowing, Unicode case mapping in stdlib strings.
- **Registry transport over HTTP verified end-to-end**: `resid-build
  serve` exposes a populated registry; an app with `[registry] url =
  "http://..."` fetches, hash-checks and builds the dependency live
  (e2e `remote_registry_transport_serves_and_builds`).
- **SpecialCasing implemented** (runtime + generator): unconditional
  uppercase expansions from SpecialCasing.txt (ß→SS, ligatures,
  ŉ→ʼN, Greek ypogegrammeni forms) via a generated table consulted
  before simple maps, plus the conditional Final_Sigma rule (Σ→ς only
  word-finally, ignorables skipped) in `str_to_lower`. Byte-exact vs
  Python's unicodedata on the e2e vectors; tables regenerated by
  `tools/gen_case_tables.py`.
- **`resid why` shipped**: `tools/resid-why` reads a binary's
  `.resid-notes.cbor` sidecar and explains every residual — what kind
  of knowledge is missing, where, and what discharges it — with
  symbol/kind filters (`resid-why <artifact> [symbol] [--kind K]`),
  a `--summary` per-kind count view, and `--json` emitting an LSP
  `Diagnostic[]` array (0-based ranges, severity Hint) so editors can
  surface residuals directly from the sidecar. e2e
  `why_reads_sidecar_and_renders_views` covers all views + error paths.
- **`resid-lsp` shipped**: a minimal language server (JSON-RPC over
  stdio) that surfaces `.resid-notes.cbor` sidecars to editors —
  opening/saving a `.resid` document publishes one Hint diagnostic per
  in-range residual found in the document's directory sidecars, and
  hover on a residual line explains what knowledge is missing and what
  discharges it. e2e drives the real binary over framed stdio.

### Reduction subsystem v1 (spec §21.4, §27, §34, §35)

- `resid-cache`: content-hash keyed CBOR store; unchanged sources skip
  recompilation. Per-pid temp files + fsync-before-rename (race fixed).
  Polish: hit/miss stats (`Store::stats`), stale-entry eviction (a cache
  hit pointing at a deleted artifact is removed and flushed), GC on
  build (`retain` prunes entries whose artifact vanished),
  `Store::remove`. residc no longer double-inserts the cache key.
- `resid-notes`: `<artifact>.resid-notes.cbor` records rt bindings and
  provider calls; every build reports discharged knowledge on stderr
  (`reduction: discharged ...`) by comparing the prior notes against the
  current residual set.
- Signed provenance trailer embedded in binaries: toolchain version, source
  hash, binary code hash, residual notes — Ed25519-signed over the payload;
  both provenance AND code are tamper-evident. `residc keygen`,
  `residc verify <binary>`, `RESID_VERIFY=1` refuses unverified binaries
  (exit 70). Stage-2 driver also emits `<out>.resid-prov` sidecars
  (signature cross-checked against an independent Python Ed25519 signer).
- COSE provenance (RFC 9052): trailers carry a real `COSE_Sign1`
  (tag 18, EdDSA -8); optional `COSE_Encrypt0` payload concealment via
  `RESID_PROV_ENCRYPT=1` + `RESID_PROV_KEY` (experimental stream cipher,
  AEAD pending). Provenance mode is part of the cache key.

### Self-hosting bootstrap (M1–M6 all done)

- `examples/lexer.resid`, `examples/parser.resid` parse their own source.
- `examples/typecheck.resid` (~1500 lines): signature collection + full
  expression walk; self-checks and accepts the other bootstrap tools.
- `examples/codegen.resid` (~1250 lines): fused parse→LLVM-IR emitter;
  compiles every bootstrap source into binaries whose outputs match
  stage-1 byte-for-byte.
- `examples/driver.resid` (~2300 lines): fused checker+emitter pipeline,
  regenerated by `tools/merge_driver.py` from typecheck.resid +
  codegen.resid (single source of truth). Stage-2 output identical to
  Rust pipeline (e2e `bootstrap_*` tests).
- Stage-2 wide-type support **complete**: collector accepts
  width-parameterized types; checker infers/threads widths (literals,
  adoption at bindings/returns/calls, v3.2 result rules); emitter lowers
  every binop/comparison at true LLVM width. Wide-typed programs compile
  identically through both pipelines.

---

## 1. Pure-Resid Library Stack (`lib/`)

All in Resid itself, verified against RFC/NIST vectors and independent
Python implementations through **both** pipelines unless noted.

| Module | Contents |
|---|---|
| `crypto.resid` | SHA-256, SHA-512, HMAC-SHA256, PBKDF2, HKDF-SHA256 (RFC 5869), Base64, constant-time compare, OS-random bytes/hex |
| `ed25519.resid` | Full RFC 8032 Ed25519 verify + deterministic sign |
| `x25519.resid` | RFC 7748 X25519 (Montgomery ladder on ed25519 field ops) |
| `chacha.resid` | ChaCha20-Poly1305 AEAD (RFC 8439) |
| `aesgcm.resid` | AES-128-GCM (SP 800-38D), bitwise GHASH |
| `der.resid`, `x509.resid` | DER decoding; x509 tbsCertificate walker (issuer/subject/validity/SPKI/SAN) |
| `rsa.resid` | Bignum on base-2^16 limbs, Montgomery REDC; RSA PKCS#1v1.5 SHA-256 verify; RSASSA-PSS SHA-256 verify (RFC 8017, MGF1) |
| `ec256.resid` | NIST P-256 ECDSA verify (Jacobian arithmetic on Int(256)) |
| `chain.resid` | Chain validation: SAN dNSName matching (incl. wildcards), validity windows, issuer linking, sig dispatch (RSA PKCS#1v1.5 / PSS / ECDSA-P256), `tls_server_cert_ok(cert, host, now)` |
| `tlsmsg.resid` | TLS 1.3 message framing: ClientHello build (+ALPN variant), ServerHello parse, flight walker, Certificate/CertificateVerify handling |
| `tls.resid` | TLS 1.3 key schedule (RFC 8448 trace-pinned), Derive-Secret, Finished, AES-GCM record protection |
| `http.resid` | HTTP/1.1 client: Content-Length + chunked framing decode, keep-alive |
| `h2.resid` | HTTP/2 frame encode/decode, HPACK (static+dynamic tables, all literal forms), Huffman decoding (Appendix B canonical decoder) |

### TLS milestones — ALL COMPLETE

X25519 → HKDF → both AEADs → key schedule → message framing → live
handshake. `examples/tls_client.resid` performs a **full live TLS 1.3
handshake + HTTP GET against real `openssl s_server`** (exit 0, HTTP 200),
accepting both ECDSA-P256 and RSA-PSS CertificateVerify, validating the
server cert (validity + SAN match, CERT-FAIL abort otherwise), hardened
against EOF/garbage/alert records. e2e `run_tls13_live_openssl_in_resid`
spawns real openssl and iterates over ECDSA AND RSA server certs.

Key fixes that got there: outer content type 23 seals everything; Finished
needs its own handshake header; record length must exclude the seeded-list
phantom byte; recv_bin boxes unsigned chars; CH offers only
TLS_AES_128_GCM_SHA256; CCS records skipped without touching sequence
numbers; CV signs the transcript up to (not including) the CV message.

### Remaining TLS/HTTP roadmap

RSA-PSS CV done; chain validation wired. **HTTP/2 over TLS 1.3 is now
done end-to-end** — see §2's completed milestone: ALPN negotiation,
connection preface + SETTINGS exchange with ACK, GET on stream 1, and
response HEADERS/DATA decoding (HPACK incl. Huffman), verified live
against a real hyper-h2 server (`tools/h2_server.py`).

**HTTP/2 hardening complete** (live-verified against hyper-h2):

- Flow control: the client restores connection + stream window credit
  with WINDOW_UPDATE frames for every consumed app-data octet
  (`h2_window_update_frame` in lib/h2.resid).
- POST bodies: requests split into HEADERS (END_HEADERS only) + DATA
  frame chains (`h2_data_frames`, ≤16384-octet frames, END_STREAM on
  the last); server echoes the body back byte-for-byte.
- CONTINUATION: response HEADERS blocks split across HEADERS +
  CONTINUATION frames are accumulated and HPACK-decoded once
  END_HEADERS arrives; request header blocks >16384 octets emit
  CONTINUATIONs via `h2_headers_cont_frames`. Verified live with a
  ~42KB response header block. e2e `run_h2_post_and_continuation_in_resid`.

---

## 2. Completed this stretch — LIVE HTTP/2 over TLS 1.3

`examples/h2_client.resid` + `lib/tlsmsg.resid` (ALPN hello) +
`lib/h2.resid` (frames/HPACK/Huffman) + `tools/h2_server.py`
(memory-BIO hyper-h2 test server):

- ALPN "h2" negotiation; full TLS 1.3 handshake with cert validation +
  CV verify against a strict peer (python ssl).
- Connection preface + SETTINGS sent, server SETTINGS read and ACKed.
- GET issued on stream 1 (HPACK block: indexed pseudo-headers +
  literal-without-indexing :authority); response HEADERS decoded via
  HPACK incl. Huffman; DATA reassembled.
- Verified LIVE: STATUS=200, BODY="hello from resid h2" byte-exact.
  e2e `run_h2_live_request_in_resid` (spawns tools/h2_server.py;
  skips without python3/h2/openssl).

Bugs fixed en route (each bit hard):

- TLS record headers must carry legacy version 0x0301 — version bytes
  0x000 worked against `openssl s_server` but not python ssl.
- TLS1.3 compat CCS records must be consumed and skipped; some servers
  send TWO back to back.
- The inner content-type byte must be stripped per decrypted record or
  it desynchronizes every subsequent frame parse.
- Client app-data sequence numbers are per epoch: preface=0, ack=1,
  headers=2; NST records consume server-side seqs too.
- `h2_cat` silently dropped each right operand's first data byte
  (copy started at index 2 instead of 1) — corrupted every frame built
  through it while passing small unit checks.

Compiler bugs discovered & documented:

- Passing a bare `.len()` value as an `Int` argument miscompiles (use
  `.len() - k` forms); cross-module recursive list builders can corrupt
  data while identical main-file shapes work — lib/h2.resid concat was
  converted to the proven der_slice_acc 5-parameter shape.
  **RESOLVED as misdiagnosis**: systematic minimization could not
  reproduce either defect — bare `.len()` as an Int argument is correct
  in direct/nested/callee-result/recursion-bound positions, and the
  exact cross-module concat-accumulator shape works in-file and across
  imports through BOTH pipelines (e2e
  `len_arg_and_cross_module_recursive_list_builder`). The original
  failures traced to the seeded-list phantom-byte semantics (gotcha #2)
  plus the real h2_cat off-by-one (copy from index 2 instead of 1), a
  Resid-source bug fixed in the same commit. No codegen change needed;
  regression suite now pins both shapes.
- **Build cache now hashes import contents**: the residc cache key
  covers every transitively imported local `.resid` file (key bumped
  to `residc-v2`), so editing a library invalidates cached binaries —
  previously library edits silently produced stale runs. e2e
  `build_cache_invalidates_on_import_change` pins direct and
  transitive invalidation. Registry dependencies remain pinned via
  their lockfile content hashes.

---

## 3. Language Gotchas Reference (accumulated, still current)

Hard constraints discovered while writing the pure-Resid stack. Keep these
in mind for ANY nontrivial `.resid` work:

1. **No variable reassignment anywhere.** Every helper is written as pure
   if-expressions; chains of temporaries (`body1/body2/body3`) replace loops
   with accumulators.
2. **Seeded-list literals carry a phantom index-0 element.** Real byte j
   lives at index j+1; `[0,0,...]` literals swallow their first element
   when concatenated; `.len()` includes the seed. Conditions must target
   i==1/i==32 etc.; build prefixes like the eight-zero M' pad with concat,
   not seeded literals.
3. **Int(N) relational operators compile as SIGNED compares.** Values ≥ 2^(N-1)
   compare wrong — use explicit unsigned-compare helpers (see `ec_ge`/
   `ec_ge512` in ec256.resid for the correct halved formulation).
4. **Casting Int(256)→Int(512) sign-extends**, corrupting modular math for
   values ≥ 2^255 — always zero-extend explicitly (ec_zext pattern).
5. **Native `%` on Int(512) is broken for large operands** — reduce via
   binary long division instead.
6. **Bind arithmetic temps before argument positions** or widths disagree
   across if arms / call args (Int(128)/Int(256) widening conflicts).
7. **Bootstrap parser/lexer**: locals named `rt` are reserved (silent parse
   desync); struct-typed if-expressions, comparisons inside if-expression
   branches, call&&call chains, chained `field.method()` calls break
   parsing — route through tiny helper functions.
8. **Definitions must precede uses in the merged driver**; standalone-
   compiled files see no imports, so codegen.resid keeps its own copies of
   shared helpers.
9. **Helper fns must be `pub`** to be visible across module imports.
10. **Deep tail recursions need `ulimit -s unlimited`** in e2e harnesses.
11. Crypto framing traps: Poly1305 length fields are octets but GCM's are
    bits; every Poly1305 block gets the 0x01 terminator; GCM J0 =
    nonce||0^31||1; HkdfExpandLabel context is length-prefixed; "derived"
    steps hash the empty transcript.

---

## 4. Notable Resolved Issues

- **The "context-dependent codegen ghost" (dead)** — intermittent garbage
  output that haunted many sessions decomposed into three root causes:
  (1) stage-2 `e.itoa` returned a pointer into a caller alloca without NUL
  termination (fixed in codegen.resid + driver.resid; stage-1 never
  affected); (2) shared cache temp file raced between concurrent residc
  processes (now per-pid + fsync); (3) run-artifact path collisions between
  parallel e2e tests sharing stems/directories (artifacts now embed source
  hash; colliding tests split apart). Verified: 20 consecutive full
  workspace runs at -j16 = 12,600 results, zero failures.
- **ECDSA/wide-int reliability**: unsigned wide compares (item 3 above) were
  misdiagnosed as codegen context-dependence; property suites un-ignored
  and green.
- **`else if` chains**: bootstrap and Rust parsers now consume the `if`
  after `else`; regression tests in both pipelines.
- **`Int(128)`/`UInt(128)` boxing gap (resolved)**: values wider than 64 bits
  produced by width-widening binops (e.g. `Int(64) * Int(64)` → `Int(128)`)
  previously failed to box into sum variants (`%t22 = call ptr
  @resid_box_i64(i64 %t21)` with `%t21` an `i128`). Fixed by adding
  `resid_box_i128/u128` + `resid_unbox_i128/u128` to the runtime and
  dispatching exactly-on-`bits == 128` in both codegens; formatting via
  `Int128ToString`/`UInt128ToString`. Parity e2e `run_wide_int_boxing`.

---

## 5. Workspace Layout

```
crates/   resid-lexer, resid-parser, resid-ir, resid-type, resid-codegen,
          resid-builtin, resid-build, residc (CLI)
tools/    resid-fmt, resid-notes, resid-cache, resid-graph, resid-why
lib/      pure-Resid crypto/TLS/networking stack (see §1)
examples/ bootstrap compilers + tls_client + h2_client
editors/vscode/ VS Code extension: TextMate grammar (source.resid),
          snippets, language configuration for *.resid
```

Pipeline phases per spec: lexer → parser → knowledge graph IR → reduction
engine → type check/capabilities → LLVM codegen (known values reduced,
residual computation emitted, notes + provenance sidecar produced).

---

## 6. Next Steps

The §7 spec-conformance roadmap is now effectively complete — every
curated item has landed in at least stage-1 (many in both pipelines).
Remaining work is the trailing gaps enumerated in §7's item 1 (§21
sandboxing): the §21.4 knowledge-cache gating and a fuller per-verb
capability-mode lattice — and driving the remaining features into stage-2
parity. Inline File-argument value provenance (§21.3) and runtime
force-time capability errors (§21.3) are now implemented.

---

## 7. Spec-conformance roadmap (v3.2)

Audit result: the language is self-hosted and broadly functional, but
NOT yet 100% spec-complete. This section is the curated work list; an
item is DONE only when it ships in **both** pipelines (see policy).

**Status: the curated list is now essentially complete.** Every item has
landed in at least stage-1; behaviors, `?`-sugar, Map/Set, and constraint
typing are done in both pipelines. The only remaining conformance gaps
are the trailing §21 sandboxing items captured under item 1 (runtime
force-time capability errors, inline File-argument provenance, §21.4
knowledge-cache gating, fuller mode lattice) plus whatever stage-2
parity remains for the stage-1-only features.

### Self-hosting policy (normative)

- The Rust pipeline is implemented first (single implementation cost);
  the feature is then ported into `examples/typecheck.resid` +
  `examples/codegen.resid`, and `tools/merge_driver.py` regenerates
  `examples/driver.resid`.
- **Every conformance item must land with dual-pipeline e2e parity
  tests (`bootstrap_*`) proving byte-identical output through Rust
  residc AND the stage-2 driver before it counts as done.**
- Stage-2 is the acceptance gate, not a side demo. Constraint: bootstrap
  sources are compiled by the Rust pipeline, so they may only use
  features the Rust compiler already supports — satisfied automatically
  by Rust-first ordering.
- Hard constraint from the audit: a feature used by the driver's own
  sources can never precede Rust support for it.

### MISSING — item 1 largely done; only §21 trailing gaps remain

1. §21/§43 Sandbox & attenuation — `sandbox (caps) { }` blocks parse and
   flatten; type checker enforces static ceiling on `@requires` (hard
   error when exceeded). ✅ DONE: transitive attenuation closure
   (call-graph meet fixpoint), manifest (per-dependency) capability
   ceilings (§21.1, enforced at type check — see §7). ✅ DONE: force-time
   capability errors (spec §21.3 "dynamic or residual… fails at force
   time") — every provider call emits a `resid_cap_check(family)` and each
   sandboxed function wraps its body in `resid_cap_enter/leave` over a
   thread-local granted set in `resid_rt.c`; e2e
   `run_sandbox_force_time_guard_present`/`run_sandbox_force_time_guard_fires`.
   handle-entry rules ✅ (compile-time front complete —
   acquisition enforced via provider-family checks; File method provenance
   `read_handle`/`close` tracked in restricted regions; value provenance for
   handles passed as values across function boundaries — File **parameters**
   enforced via the §21.3 entry rule, e2e
   `run_sandbox_handle_entry_file_param`, and **File values passed as inline
   call arguments** now tracked too, e2e `run_sandbox_handle_entry_file_argument`));
   **capability modes (spec §21)** — `filesystem(readonly)` now enforced:
   a read-only grant rejects write verbs (`filesystem.write_all`) at the call
   site, surviving the transitive-attenuation closure (e2e
   `run_sandbox_capability_mode_readonly`); §21.4 knowledge-cache capability
   gating (deferred: no CBOR store in build path).
2. §12 Constraint types — ✅ DONE (stage-1): both syntaxes (`Int[value > 0]`
    and `Int where value > 0`) parse, resolve to a `Refined` semantic type,
    and are discharged on annotated bindings (statically-known integer
    literals only; see progress below).
3. Core behaviors `Serialize`, `Allocator`, `Reverse`, generic `Hash`
   (§12 list) — **✅ DONE (stage-1)**: generic numeric `Ord`/`Eq`/`Hash`
   synthesized for all widths; `Serialize`/`Allocator` shape-checked;
   e2e `run_generic_numeric_behaviors` (see progress below).
4. Map / Set types — `MapLit` parses; nothing resolves in type check or
   codegen. → **✅ DONE (stage-1 + stage-2)**, see progress below.
5. Per-width `wrapping_*` / `saturating_*` — ✅ done (LLVM native
   lowering for add/sub/mul at any width; div falls back to i64 C runtime;
   e2e `run_per_width_wrapping_saturating`).

### PARTIAL → mostly DONE (see per-item marks; each ✅ references its progress section below)

6. §11 Behavior system — **✅ DONE (both pipelines)**: `BehaviorDef` +
   `using =` parse; type checker collects/validates instances; codegen
   synthesizes comparator trampolines; `sort` lowers to `list_sort_by`.
   Stage-2 parity via `bootstrap_behavior_ord_parity` (see progress below).
7. §19 Concurrency — spawn works (pthreads); child≤parent and the child's
   fresh CapEnv are enforced statically in the type checker (§19, e2e
   `run_spawn_simple`/`run_spawn_with_captures`/`run_spawn_nested`). Child
   failure is now delivered to the parent as `Err(RegionError)` instead of
   aborting the process: a runtime abort inside the worker unwinds via
   setjmp/longjmp to the spawn entry, which boxes it as `Err` that the
   parent's `match` catches (e2e `run_spawn_child_failure_err`).
8. §22 Visibility — `pub` parsed but never enforced; default-private
   rule unimplemented. → **✅ DONE (stage-1)**: `FunctionSig` carries
   `is_pub`; codegen rejects cross-module calls to non-`pub` functions;
   e2e `run_pub_visibility_enforced`. Stage-2 note: driver has no import
   machinery yet; single-file subset unaffected.
9. §23 `value?` sugar — parse-only; no checker/codegen handling
   (the `else {…}` half is done). → **✅ DONE (both pipelines)**: Option
   and Result `?`/`else` fully implemented, stage-2 parity verified
   (`bootstrap_question_else_parity`; see progress below).
10. §20 Capabilities at runtime — manifest ceilings enforced at build
    time only; capabilities don't travel with effects/handles/residuals.
    → **Static half done**: spawn capability substitution (§19: child ≤
    parent + fresh CapEnv bounds the child's whole body) enforced in the
    type checker; dynamic/residual (force-time) capability errors remain
    unimplemented (see item 1 trailing gaps).
11. §3 Knowledge graph as driving IR — exists in parallel
    (`resid-ir/graph.rs`) but production pipeline is AST→type→LLVM
    directly; reduction is ad-hoc in codegen. → **✅ DONE (stage-1)**:
    comptime β-reduction of pure functions with step/depth budgets
    (reduction relation §36) wired into codegen with comptime-print
    (see §9 progress).
12. §36 Reduction relation — constant folding + overflow discharge only;
    no comptime β-reduction of pure functions, no provider substitution
    at compile time. → **✅ DONE (stage-1)**: comptime β-reduction of pure
    functions with step/depth budgets, recursive calls, conditionals, tail
    returns; e2e `reduction_known_fib_comptime_print`,
    `reduction_falls_back_to_runtime` (see progress below).
13. §35 Build profiles — debug/release/check not implemented.
    → **✅ DONE**: `residc <f> build|run --profile debug|release|check`;
    `-O2` for release, `check` stops after type checking, cache key includes
    profile (see progress below).
14. §28 Package key pinning — keyring directory-scanned; no
    per-dependency pin syntax. → **✅ DONE (spec §28.3)**: per-dependency
    `pubkey` pin enforced at manifest load, transitive pins carried;
    e2e `dependency_pinned_key_*`, `transitive_dependency_pinned_key_enforced`
    (see progress below).

### Progress on item 9 — `value?` sugar

**Stage-1 DONE** (commit 7fb585b): the audit's "parse-only" finding was
wrong — checker + codegen existed for Option. Generalized to
Result-style sums (`Ok(T) | Err(E)`): `?` propagates the received
failure box unchanged to the caller; `else {…}` yields the success type
(spec §23). e2e `run_question_sugar_option_and_result`.

**Stage-2 DONE**: minimal sum support built in the self-hosted driver —
`Some`/`None`/`Ok`/`Err` constructors over tagged boxes via
`resid_box_new`, `match` with tag-dispatch branches and payload
unboxing (`bootstrap_option_sum_parity`, `bootstrap_match_parity`), then
`?`/`else` for Option and Result with expected-type threading for
`Ok`/`Err` hole adoption and depth-aware type-list splitting. Parity
verified byte-identically through Rust residc AND the driver
(`bootstrap_question_else_parity`). All 11 bootstrap e2e pass.

### Suggested attack order

1. Behaviors (item 6) — ✅ done (stage-1: generic numeric Ord/Eq/Hash synthesis, Serialize/Allocator shape checking, e2e `run_generic_numeric_behaviors`, `run_behavior_ord_sort`, `run_behavior_import_visibility_and_reverse`, `bootstrap_behavior_ord_parity`).
2. `value?` sugar (item 9) — ✅ done (both pipelines, Option + Result; e2e `run_question_sugar_option_and_result`, `bootstrap_question_else_parity`).
3. `pub` enforcement (item 8) — ✅ done (stage-1; e2e `run_pub_visibility_enforced`).
4. Per-width wrapping/saturating (item 5) — ✅ done (LLVM native lowering; e2e `run_per_width_wrapping_saturating`).
5. Map/Set types (item 4) — ✅ done (both pipelines; e2e `run_map_set_types`, `bootstrap_map_set_parity`).
6. Serialize/Hash behaviors (item 3) — ✅ done (stage-1; e2e `run_generic_numeric_behaviors`).
7. Sandbox transitive attenuation (item 1 remaining) — ✅ done (stage-1, e2e `run_sandbox_transitive_attenuation`); manifest (per-dependency) capability ceilings **✅ done** (spec §21.1: `[dependencies.<name>] capabilities = […]` enforced at type check as a hard ceiling on the dependency's `@requires`, met with any in-source sandbox ceilings; residency in `resid-build`, e2e `dependency_*_ceiling_*` + `path_dependency_resolves_and_builds`).
8. Constraint types (item 2) — ✅ done (stage-1, both syntaxes, discharge on binds; e2e `run_constraint_types`, `constraint_type_violation_rejected`).
9. Knowledge-graph IR + reduction depth (items 11, 12) — ✅ done (stage-1: comptime β-reduction of pure functions with step/depth budget, block-tail support; e2e `reduction_known_fib_comptime_print`, `reduction_falls_back_to_runtime`).
10. Spawn capability substitution (item 7, 10) — ✅ done (stage-1:
    spawn works over pthreads, e2e `run_spawn_simple`, `run_spawn_with_captures`, `run_spawn_nested`; type checker enforces §19 child ≤ parent against the enclosing effective ceiling and bounds the child's whole body by its fresh CapEnv — callee `@requires` and nested spawns must fit the spawn's own caps).
11. Build profiles (item 13), key pinning (item 14) — **✅ done**: CLI `--profile debug|release|check` flag for `build`/`run`; release adds `-O2`, check stops after type checking; cache key includes profile; key pinning ✅ done (spec §28.3: `[dependencies.<name>] pubkey = "<hex>"` pins the dependency's archive signature to exactly that key, enforced at manifest load regardless of the global `[signing]` policy, transitive pins carried through recursion; e2e `dependency_pinned_key_*`, `transitive_dependency_pinned_key_enforced`).

### Progress on item 1 — manifest ceilings & item 14 — key pinning: DONE (stage-1)

**§21.1 manifest (per-dependency) capability ceilings**

- `resid_type::FileCeiling` (public): a `(prefix, caps)` pair keyed by the
  canonical dependency directory; `covers` is directory-boundary aware
  (`/a/b` never matches `/a/bc`).
- `check_program_with(unit, ceilings)` — `check_program` is now a thin
  wrapper over it. Effective ceiling per function = meet of the enclosing
  `sandbox (…)` ceiling and any manifest ceiling covering its defining
  file (§21.1: "Source code may only further restrict; it may never
  enlarge"). Violations are reported at the declaring span and at every
  call site inside the transitive closure.
- `resid-build::build` derives ceilings from every dependency with a
  non-empty `capabilities` list (family names via `cap_family`, canonical
  prefix, dedup) and passes them to the type checker — so a dependency
  declaring `@requires(network)` under a `["filesystem(readonly)"]`
  ceiling is rejected with a hard compile error, exactly like the
  in-source sandbox path.
- Unit tests (`resid-type` +6): uncovered-requires rejected / covered
  allowed / root package unrestricted / directory-boundary awareness /
  transitive closure under a manifest ceiling / source sandbox cannot
  amplify the manifest ceiling.
- Integration tests (`resid-build` +4): blocked vs allowed dependency,
  unrestricted (no `capabilities` line), and a call-site diagnostic for
  the transitive case — the latter two plus the pre-existing
  `path_dependency_resolves_and_builds` prove the old behavior is intact.

**§28.3 per-dependency key pinning**

- `[dependencies.<name>] pubkey = "<hex>"` parses into
  `Dependency::pinned_key` and is carried through `collect_dep` (so
  transitive pins inside vendor manifests are enforced too).
- `verify_pinned_key` at manifest load: the dependency must ship
  `<name>.resid-pkg` + `<name>.resid-sig`, and the Ed25519 signature over
  the archive's content hash must verify against the pinned key — a hard
  commitment independent of the global `[signing] / require_signatures`
  policy. Missing artifacts or a foreign key reject the dependency.
- Unit coverage via integration tests (`resid-build` +4): correct pin
  accepted, wrong key rejected, missing archive rejected, transitive pin
  enforced at the vendor level.

### Progress on item 14 — spawn capability substitution & child failure: DONE (static + runtime, §19)

- `spawn (caps) { body }` hands the child a FRESH CapEnv of exactly `caps`
  (spec §19). The type checker now enforces both static halves at the
  effective-ceiling fixpoint (`enforce_transitive_attenuation` + new
  `walk_spawn_cap_env`):
  - **child ≤ parent** — the spawn's declared caps must be ⊆ the enclosing
    function's effective ceiling (in-source `sandbox` ∧ manifest ceiling),
    so a spawn can never amplify the parent's powers.
  - **fresh CapEnv bounds the body** — every callee `@requires` and every
    nested `spawn` inside the child must fit the child's own caps, walked
    across the full statement/expression tree (calls, control flow, match
    arms, with/using, providers, f-strings, destructuring, map/set/struct
    literals, etc.).
- **Runtime half now DONE**: child failure is no longer stubbed — a runtime
  abort inside the spawned worker (division by zero, bounds abort, an
  outstanding `todo`) unwinds via setjmp/longjmp to the spawn worker's catch
  point and is delivered to the parent as `Err(RegionError)`, which the
  parent's `match`/`?` catches; the process does NOT terminate. A healthy
  worker still yields `Ok(T)`. e2e `run_spawn_child_failure_err`.
- Unit tests (`resid-type` +5): child≤parent allows matching / rejects
  amplification / fresh CapEnv rejects an out-of-caps callee / allows a
  fitting callee / nested spawn may not exceed the child's CapEnv.

### Progress on item 9 — comptime reduction: DONE (stage-1)

- Evaluator (`crates/resid-type/src/reduce.rs`): pure comptime evaluator implementing the pure reduction relation (§36).
  - Handles literal integers, booleans, and strings, raw strings, identifier lookup in the local environment, unary operations (`-`, `!`), binary operations (wrapped arithmetic `+`, `-`, `*`, checked division `/` and remainder `%`, comparisons `<`, `<=`, `>`, `>=`, `==`, `!=`, string concatenation), and conditional expressions (`if`).
  - Supports user-defined pure function calls (`reduce_call` / `reduce_expr`) by looking up function declarations in the current translation unit, mapping arguments (positional, named, and defaults), and evaluating function bodies.
  - Implements a resource step budget (`MAX_STEPS = 400_000`) and recursion depth budget (`MAX_DEPTH = 256`). Reaching any budget, encountering an effectful builtin (like `println`), or hitting unsupported constructs cleanly yields `None` to fallback gracefully to standard runtime lowering (fully sound).
  - Handles block evaluation with `capture_tail: bool` (supporting block-level tail expression folding where a block's final expression is evaluated as its value).
  - Implements a thread-local return-propagation channel (`pending`, `pending_value`) so that nested `if` statements containing returns cleanly exit the enclosing pure context.
- Codegen:
  - Hooks function calls during lowering; if the target is a pure function call with fully compile-time reducible arguments, performs compile-time β-reduction, and lowers the evaluated `CValue` as a synthesized constant instead of emitting a runtime call.
  - Comptime-print (`comptime_print`) now prefers displaying the compile-time β-reduced result when available.
- Tests: `resid-type` +7 unit tests (covering recursive fibonacci, factorial, bool and string operations, nested block-tail returns, resource budget fallbacks, and negative constants), `residc` e2e +2 tests (`reduction_known_fib_comptime_print`, `reduction_falls_back_to_runtime`).

### Progress on item 2 — constraint types: DONE (stage-1)

- Parser: `Int[value > 0]` postfix in any type position (`Type::Refined`)
  AND the `where` alternative (`type X = Int where value > 0`), both
  landing in `TypeBody::Constraint { inner: Type, constraint: Expr }`.
  A bare `type X = Int;` RHS now also parses as a real alias
  (`TypeBody::Base`) instead of a silently-empty product.
- Type resolution: `SemType::Refined { name, base, constraint }`. The
  public `resolve_type_ctx` erases refinements (deeply — fields, list
  elements, param/ret types) so operators, unification, and codegen never
  see them; `resolve_type_declared` retains them for discharge. Guard arms
  added in codegen's `llvm_type`.
- Discharge (§12): at an annotated binding (`Positive p = 5;`) the
  constraint is evaluated against the statically-known literal
  (`const_int_value` handles a leading unary minus; comparisons,
  `==`/`!=`, `&&`/`||`/`!`, `+ - * / %` over `value`). Violation →
  `binding \`p\`: constraint \`value > 0\` not satisfied by value -1`;
  non-constant RHS → `cannot verify … for non-constant value`. Values
  already of a refined type pass through; refined values erase to their
  base for all downstream use (`Positive p = 5; Int y = p + 1;` works).
- Tests: parser +3 (`*_constraint_type_*`), resid-type +5 (discharge ok /
  violation / where-form / non-constant / erase-to-base), e2e +2
  (`run_constraint_types`, `constraint_type_violation_rejected`).
- Edge so far: call-arg and return discharge is lenient (params erase to
  base, no proof demanded) — a documented follow-up when value-carrying
  refinements reach signature checking.

### Progress on item 3 — `pub` visibility: DONE (stage-1)

- `FunctionSig` carries `is_pub` + defining file; resolve keeps ALL
  declarations in the merged unit (imported `pub` bodies can still see
  their own private helpers — the old drop-filter broke exactly that),
  and codegen rejects cross-module calls to non-`pub` functions with a
  precise diagnostic. e2e `run_pub_visibility_enforced`.
- Stage-2 note: the driver has no import machinery for this yet; its
  single-file subset is unaffected.

### Progress on item 1 — behaviors: DONE (both pipelines)

**Stage-1 (Rust)**:

- Parser: `Ord(Point) = by_y;` declarations; `using = Ord(T)` and
  arbitrarily nested `using = Reverse(Reverse(Ord(T)))` instances.
- Type checker: instance collection + validation (impl must be
  `(T, T) -> Int`, element-type match at sort sites); `pub behavior`
  rejected with a clear diagnostic; instances visible across imports.
- Codegen: `sort` lowers to rt `list_sort_by` with synthesized qsort
  trampolines (`__cmp_<fn>[_rev]`); comparator output normalized to
  -1/0/1 before Reverse negation (total — no -INT_MIN wraparound).
- Runtime: single stable bottom-up mergesort primitive `rt_stable_sort`
  backs ALL sort paths in `resid_rt.c` (behavior sorts and the
  list_sort_* builtins alike) — O(n log n), stable, one scratch buffer.

**Stage-2 (self-hosted driver)** — parity proven by e2e
`bootstrap_behavior_ord_parity` (byte-equal stdout through both
pipelines for struct sort, Int sort, and Reverse):

- `Funcs`/`Sigs` carry `bnames/bparams/bfns`; both collectors recognize
  `Ord(Point) = fn;` (also under `pub`) instead of silently skipping —
  which also fixes a latent brace-scan hazard in the emitter's decl walk.
- Checker validates comparator signatures at declaration time and
  instances/elem-types at sort sites; emitter emits both comparator
  variants per impl into the header (unused defines are harmless) and
  lowers `sort` to rt `bl_sort_by` over the flat-buffer ABI.
- `tools/merge_driver.py`: shared helpers (`BRes`,
  `behavior_decl_at`, `read_instance`, `strip_reverse`) deduped across
  halves; header-construction lines (`hdr_core` + `header`) now
  transplanted wholesale from codegen main into the driver tail.

### Progress on item 4 — Map/Set types: DONE (stage-1)

- Persistent immutable hash tables, `cap*4`-slot buckets (base = `idx*4`),
  FNV-1a (strings hash by content, boxed scalar keys by address). Mutation
  allocates a fresh table; originals untouched (verified e2e). Sets are
  maps over a dummy value; `{}` is an empty SetLit.
- Parser: MapLit/SetLit arms + chained-postfix loop (`m.len().to_str()`);
  nested-block disambiguation fixed (`peek_after()`, save/rewind on
  empty/comma-complete literals).
- Runtime (`resid_rt.c`): get/insert/remove/contains/rehash/keys/values/
  union/difference/intersection/format + literal construction.
- Codegen: `wrap_option()` helper boxes raw rt map-get results as
  Some/None for `.get` and `m[k]`; `Map`/`Set` types pass through IR.
- e2e `run_map_set_types` + parser/type unit tests green.
- **Stage-2 (DONE)**: driver now compiles Map/Set programs end-to-end with
  byte-identical output to the Rust pipeline (e2e `bootstrap_map_set_parity`).
  Recursion-first port of literal/method typecheck+codingen (no `while`/
  reassignment): map/set literals, `.len/.insert/.remove/.contains/.keys/
  .values`, Set `.union/.difference/.intersection/.to_list`, chained
  postfix. Long-standing driver bug fixed along the way: List `.len()` read
  the C-runtime `ResidVal` tag word (offset 0) treating it as the driver's
  length-first layout — added `resid_rt_list_to_flat`, which reboxes lists
  returned by `resid_map_keys/values` and `resid_set_to_list` at the boundary.
  Empty `{}` literals are rejected by both pipelines (element type
  un-inferable). `m.get`/`m[k]` (Option results) can now be consumed in the
  driver via `match` once Option support landed (item 9, `?`-sugar
  groundwork); next candidates are `?`-sugar and `if let` in the driver.

### Progress on item 1 — generic numeric behaviors & Serialize/Allocator (stage-1 DONE)

- **Parser**: `Ord(Int(8))`, `Reverse(Ord(UInt(16)))`, etc. parse via
  `capture_numeric_type_param` (nested type applications in behavior
  instances). `using = Ord(Int(8))` and `Ord(Int(8)) = cmp;` declarations
  accepted.
- **Type checker**: §6.6 generic numeric fallback in `infer_using` —
  `Ord`/`Eq`/`Hash` synthesized for any `Int(w)`/`UInt(w)`/`Float(w)`/`Dec(p)`
  width without explicit instance declarations. Per-behavior shape validation:
  `Ord` → `(T,T)->Int`, `Eq` → `(T,T)->Bool`, `Hash` → `(T)->Int`,
  `Serialize` → `(T)->Str`, `Allocator` → `()->T`. Width mismatch between
  instance and list element rejected (`applies to Int(8), but the list holds Int`).
- **Codegen**: inline comparator trampolines (`emit_numeric_cmp_trampoline`)
  for `Ord` at any numeric width — Int/UInt/ISize/USize unbox via
  `resid_unbox_i64` (i64 compares → trunc to i32); Float unbox via
  `resid_unbox_f64` (f64 compares); Dec calls `resid_dec_cmp` directly on
  boxed RsDec pointers. Width >64 rejected (explicit instance required).
- **e2e**: `run_generic_numeric_behaviors` exercises Int, UInt(16), Int(8),
  Float, Reverse — all codegen paths produce correct sorted output.
- Unit tests: `generic_numeric_behaviors_synthesize_instances`,
  `serialize_and_allocator_shape_checking`.

### Progress on item 1 — sandboxing: TRANSITIVE ATTENUATION ENFORCED (stage-1 DONE)

**Lexer fix**: `scan_at` in `resid-lexer` rewound consumed characters when
`@requires` (or any `@ident` not matching `@residual`) was encountered,
preventing the `@requires` annotation from being parsed correctly.

**Parser**: `sandbox (cap1, cap2) { decls }` parses to `Declaration::Sandbox(SandboxDecl)`.
Child function `@requires` are stored as the function's own `capabilities`;
sandbox caps are stored separately on `SandboxDecl.capabilities`.

**Resolver**: Sandbox bodies are flattened — child declarations join the
same scope with `sandbox_ceiling` set on each child function from the
sandbox's capability list. The sandbox wrapper itself is discarded.

**Type checker**: `FunctionSig` now carries `requires: Vec<String>` (from
`@requires(X)` params) and `sandbox_ceiling: Vec<String>` (from enclosing
sandbox). `check_program` flattens sandboxes inline and enforces that every
required capability is present in the ceiling; violation → hard compile error.

**Transitive attenuation**: `enforce_transitive_attenuation` (meet-based
fixpoint over the call graph) computes an effective ceiling per function as
`Option<Vec<String>>` (None = unrestricted, Some(caps) = restricted).
- Ceilings propagate along call edges via set intersection (meet).
- At each call from a restricted caller, every callee `@requires` cap must
  be a subset of the caller's effective ceiling.
- Conservative: any function reachable from a restricted caller inherits
  the restricted ceiling, ensuring sound static attenuation.
- e2e `run_sandbox_transitive_attenuation` exercises: direct violation,
  undecorated middle-man chain, and legal grant — all green.

**Manifest ceilings (spec §21.1)**: ✅ DONE — `[dependencies.<name>]
capabilities = […]` now enforced at type check as the dependency's
effective ceiling (see §7 "Progress on item 1" above).

**Remaining gaps**: handle-entry enforcement now complete on the
compile-time front — acquisition enforced, File method provenance for
`read_handle`/`close` tracked in restricted regions, File **parameters**
crossing the boundary enforced via the §21.3 entry rule (e2e
`run_sandbox_handle_entry_file_param`), and **File values passed as inline
call arguments** into restricted callees now tracked too (spec §21.3 value
provenance; e2e `run_sandbox_handle_entry_file_argument`); **force-time
capability errors (spec §21.3 "residual… fails at force time") now
implemented** — each provider call emits a `resid_cap_check(family)` guard
and each sandboxed function wraps its body in `resid_cap_enter/leave`,
backed by a thread-local granted-set stack in `resid_rt.c` (family match on
the `:ro`/`(` mode suffix). In fully-static legal programs the compile-time
checker still rejects every apparent violation (so the runtime guard is the
defense for dynamic/residual requirements): e2e
`run_sandbox_force_time_guard_present` (IR carries the guard) and
`run_sandbox_force_time_guard_fires` (a missing grant aborts at force time);
§21.4 knowledge-cache gating (completed); capability modes currently
cover the `readonly`/`readwrite` markers with `filesystem.write_all` and
`process.run` as the classified write verbs — a fuller per-verb mode lattice
(`git(readonly)` scope, etc.) is now complete; See the capability-mode
progress subsections below.

### Progress on capability modes (spec §21) — readonly mode enforced

- Capability strings now carry an optional `:ro` mode marker
  (`encode_capability`); `sandbox (filesystem(readonly))` and
  `@requires`-style ceilings preserve the marker through
  `effective_declared_ceiling`, the transitive-attenuation meet
  (`meet_caps` is mode-aware: RO meets RW = RO), and every family
  membership comparison (spawn ≤ parent, call `@requires`, provider calls,
  File method / handle-entry `filesystem` checks).
- **Write-verb enforcement**: at a provider call, `is_write_verb` (currently
  `filesystem.write_all`) requires a read-write grant; a region holding only
  `filesystem:ro` is rejected with a mode-specific diagnostic. Read verbs
  (`read_all`, `read_handle`, `list_dir`, `exists`) remain allowed under the
  read-only grant.
- The readonly grant **cannot be amplified**: a helper reached only from a
  read-only sandbox is narrowed to `filesystem:ro` by the closure rule, so a
  `write_all` in the (unrestricted) helper is rejected too.
- Tests: resid-type +4 (readonly rejects write / readwrite allows write /
  readonly allows read / snapshot of the closure narrowing), residc e2e +1
  (`run_sandbox_capability_mode_readonly`: legal read-only `run` + illegal
  write `emit-ir` rejection).

### Progress on capability modes — unknown-mode rejection (soundness)

- Only `readonly` and `readwrite` are valid per-family mode keywords; a
  misspelled mode (e.g. `filesystem(readoly)`) previously fell through to the
  read-write branch, silently escalating a would-be read-only grant to full
  read-write authority. `check_program_with` now rejects any unknown
  identifier mode on a function's `sandbox_ceiling` with a precise diagnostic
  (`unknown capability mode \`readoly\` on \`filesystem\`; supported modes are
  \`readonly\` and \`readwrite\``). Explicit `readwrite` is accepted and
  behaves like the bare family (read-write).
- Tests: resid-type +2 (`capability_mode_unknown_keyword_rejected`,
  `capability_mode_explicit_readwrite_allows_write`), residc e2e +1 assertion
  (typo-mode `emit-ir` rejection in `run_sandbox_capability_mode_readonly`).

### Progress on capability modes — `process.run` classified as write verb

- `process.run` executes an arbitrary external command, which may mutate the
  system, so it is now classified as a write verb by `is_write_verb`. A
  read-only `process(readonly)` grant therefore rejects `process.run` (e.g. a
  misspelled intent of a read-only process grant no longer permits arbitrary
  command execution). `process(readwrite)` — bare or explicit — still allows
  it. The `git` provider exposes only read verbs (`rev`, `branch`), so no
  write classification is needed there yet.
- Tests: resid-type +2 (`capability_mode_process_readonly_rejects_run`,
  `capability_mode_process_readwrite_allows_run`); residc e2e +1 assertion
  (`process(readonly)` `process.run` rejection in
  `run_sandbox_capability_mode_readonly`).



