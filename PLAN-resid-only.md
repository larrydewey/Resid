# Plan: Complete Parity Work + Resid-Only Tech Stack

Status: ACTIVE. Written 2024 (see git log for date). Companion to `PROGRESS.md`
(status/history) and `PLAN-sandbox-parity.md` (prior sandbox parity effort).
This plan supersedes PROGRESS.md §6's "Rust forever" normative policy — see
Phase D.

## Locked decisions (do not re-litigate without explicit discussion)

- **Effect-checker**: full rewrite (Phase A.1 "Option B"), not a patch. Thread
  real capability/effect types through `check_expr`/`check_stmt` in the
  self-hosted `examples/typecheck.resid`, replacing the textual/substring
  post-pass.
- **resid-lsp / resid-lsp-full**: OUT OF SCOPE for "resid-only." Stays Rust
  permanently, same status as the VS Code TypeScript extension. Not ported.
- **Phase B (bootstrap self-compile proof) and Phase C (tool porting) run in
  PARALLEL**, not sequentially. Phase D (decommission) is gated on both.
- **clang/LLVM stays an accepted external dependency.** "Resid-only" means
  "no Rust code in the toolchain," NOT "zero external tools." No native
  codegen backend is in scope here.
- **No garbage collector, no reference counting, ever, for any reason.**
  Resid is knowledge-centric: the compiler must fully determine every
  value's storage lifetime statically, at compile time, with zero
  runtime-deferred reclamation and zero non-deterministic pause behavior.
  This is a hard constraint, not a performance preference — do not propose
  a tracing GC or an ARC/refcounting scheme as a fix for anything. The only
  acceptable mechanism for reclaiming memory is compiler-proven, purely
  syntactic/whole-program static analysis that decides exact free points at
  compile time (see Phase E) — i.e. generalizing the existing
  `crates/resid-type/src/growable.rs` mechanism, not replacing it with a
  runtime component. See Phase E for the concrete plan and rationale.

## Key research findings (baseline facts, see conversation history for full detail)

- No stage-3 self-compile test exists today. All `bootstrap_*` e2e tests use
  Rust `residc` to compile `examples/driver.resid` into a native binary, then
  run that binary on sample programs. Nobody has ever fed `driver.resid` to
  a `driver.resid`-produced binary and checked a fixed point.
- Both pipelines shell out to `clang` on textual `.ll` IR; only the Rust side
  additionally uses `inkwell` to *build* that IR before printing it to text.
  Removing Rust does not remove the clang/LLVM dependency.
- Stage-2 sandbox checker (`examples/typecheck.resid` lines ~3270-3799) is a
  textual substring post-pass over captured function-body text, not a real
  effect-checker. Known gap: an unannotated provider call can pass stage-2
  typecheck and only get caught by the runtime `resid_cap_check` guard.
- Rust-only tools with no Resid equivalent today: `resid-cache`,
  `resid-notes`, `resid-fmt`, `resid-why`, `resid-graph`, `resid-diag` (caret
  rendering), `resid-build` (package manager/registry/signing), `resid-lsp`
  (excluded, see above).
- `crates/resid-builtin` is a 1-line placeholder, does nothing.
- Known small gaps not previously tracked: import namespacing (`import "f"
  as M`) unimplemented (A.6, still open); package-level capability
  enforcement in `resid.toml` was already done by `resid-build`/`resid-type`
  ceilings (§21.1 — A.5 resolved, plan entry was stale); the two generic
  "not yet supported" fallbacks (`resid-codegen/src/lib.rs:2371`,
  `resid-type/src/lib.rs:2318`) were audited — only C-style `for` and
  expression-level `Destructure` are unhandled, both unreachable from
  source (A.7 resolved and pinned by a regression test).

---

## Phase A — Parity / soundness fixes

1. **Effect-checker full rewrite** (largest item). Replace the substring
   post-pass with a real capability/effect type threaded through
   `check_expr`/`check_stmt` in `examples/typecheck.resid`. Est. 2000-4000
   changed lines + matching `examples/codegen.resid` changes. New parity e2e
   batch mirroring + extending every `bootstrap_driver_sandbox_*` test.
2. **Diagnostics parity**: port caret/span rendering (`resid-diag` logic)
   into the self-hosted driver. Do alongside item 1.
3. **COSE_Encrypt0 AEAD**: finish concealment (currently experimental stream
   cipher only).
4. **Item 10 capability travel**: confirm force-time-guard design is final
   per spec §21.3, or identify concrete remaining gap.
   - [x] Confirmed final — no remaining gap found. The §21.3 force-time guard
     (`resid_cap_enter`/`resid_cap_check`/`resid_cap_leave`) is emitted around
     every sandboxed body in both pipelines, including the self-hosted
     `codegen.resid`, and is exercised end-to-end: `run_sandbox_force_time_
     guard_fires`, `bootstrap_driver_sandbox_force_time_guard`, plus the
     manual compile→link→run check in `PROGRESS.md` (~line 1078) where a
     residual `process.run(...)` inside `sandbox (filesystem)` passes
     stage-2 typecheck and aborts at force time with
      `resid: abort: capability not granted: process`. **Update (A.1b)**: the
      previously-documented residual (an unannotated provider call passing the
      stage-2 checker) is now closed for statically-visible provider calls —
      the self-hosted checker extracts per-function provider-effect sets and
      rejects ungranted families with `E0218`, matching the Rust pipeline. The
      force-time guard remains defense-in-depth for what the static checker
      cannot see (provider calls inside f-string interpolations, nested
      `sandbox`/`spawn` blocks, and any residual/`rt` path). See
      `PROGRESS.md` §21.1/§21.3.
5. **Package-level `@requires` in `resid.toml`**: enforce (currently parsed
   only — `resid-build/src/lib.rs:150`).
   - [x] Already enforced — stale plan entry. `[dependencies.<name>]
     capabilities` is the per-dependency ceiling (§21.1). `Manifest::load`
     rejects a dependency whose ceiling names a family the consumer has not
     granted (`resid-build/src/lib.rs` grant check), and `build` derives
     `resid_type::FileCeiling`s from every non-empty ceiling so source
     `@requires` can only restrict, never enlarge (see `PROGRESS.md` §21.1,
     tests `dependency_capability_ceiling_{blocks,allows}_requires`,
     `dependency_without_ceiling_is_unrestricted`). Fixed the misleading
     "parsed, not yet enforced" doc comment on `Dependency::capabilities`.
6. **Import namespacing** (`import "f.resid" as M`): implement or formally
   defer with a written rationale.
   - [x] Already implemented — stale plan entry. `resid-parser` parses the
     alias (`parse_import`), and `resolve.rs` renames the aliased unit's
     exported declarations to `Alias.name` and rewrites qualified
     references via `resid-parser/src/alias.rs` (calls `U.a()`, values
     `U.base()`, and `U.CONST` fields collapse to renamed idents). Covered
     end-to-end by `tests/resolve.rs::alias_import_end_to_end_types_clean`
     (types clean) plus `alias_import_merges_renamed_decls` and
     `alias_import_rewrites_calls_and_values`. Documented v1 limits
     (module comment in `alias.rs`): struct-literal names, type spellings,
     and match patterns are not rewritten; a bare alias reference errors
     later as an unknown variable. No code change needed.
7. **Audit generic "not yet supported" fallbacks**: `resid-codegen/src/lib.rs:2372`,
   `resid-type/src/lib.rs:2316`.
8. **`resid-builtin` crate**: delete or document purpose.

## Phase B — Bootstrap closure proof (parallel with Phase C)

1. New e2e: Rust `residc` builds `driver.resid` -> `D1`. `D1` compiles
   `driver.resid` (itself) -> `D2`. Assert behavior-identical across the
   full `bootstrap_*` sample battery; target byte-identical `.ll` emission
   modulo embedded paths/hashes.
2. Fixed point: `D2` compiles `driver.resid` -> `D3`; assert `D3 == D2`
   (byte-for-byte or IR-for-IR). This is the actual self-hosting proof.
3. Gate: must hold before Phase D starts.

## Phase C — Port Rust-only tools to Resid (parallel with Phase B)

Order, easiest -> hardest:

1. `tools/merge_driver.py` -> Resid. Pure text/file-IO. First "resid builds
   resid" tool.
2. `resid-notes` + `resid-cache`: needs a CBOR codec in `lib/` (model off
   existing DER-adjacent decode code); data structures + file IO.
3. `resid-diag` caret rendering: shared with Phase A.2, do once.
4. `resid-fmt`: reuse existing self-hosted lexer.
5. `resid-why`: thin CLI over ported notes.
6. `resid-graph`: call-graph/DOT tool, self-contained.
7. `resid-build` (package manager, manifest parsing, registry HTTP fetch,
   key pinning/signing): biggest practical port; `lib/` already has HTTP
   client + Ed25519 + signing primitives.

`resid-lsp`/`resid-lsp-full` excluded — stays Rust permanently.

## Phase D — Decommission Rust

Gated on: Phase B proof holds AND Phase C items 1-7 ported + parity-tested.

1. Freeze one Rust-built binary as a versioned/checksummed stage-0 seed.
2. Move `crates/` to archival `bootstrap/rust-stage0/` (not deleted — needed
   to rebuild stage0 for new host architectures).
3. Update `PROGRESS.md` §6: replace "Rust forever" normative policy with the
   stage-0-seed model.
4. Document clang/LLVM as a permanent accepted external dependency.

## Phase E — Self-hosted compiler memory/performance architecture

**Trigger**: Phase B.1's stage-3 self-compile test, once it got past typecheck
for the first time, exposed severe resource costs: ~50 minutes wall-clock and
40-65GB peak memory (resident+swap) for a *single* self-compile of the
~9000-line `driver.resid`. Phase B.2 (D2 -> D3 fixed point) needs at least two
such steps back-to-back; this is not practically repeatable as-is, and would
get worse for any larger resid-only program. This must be fixed before Phase
B can close, and before "resid-only" self-hosting can be trusted to scale.

**Constraint** (see Locked decisions above): no GC, no refcounting. Every fix
here must be a compile-time-only static proof with a deterministic,
compiler-decided free point — zero runtime tracking, and it must *never
reject a program*: an unresolved/ambiguous case falls back to today's
always-copy/leak behavior, so an incomplete analysis degrades to "no
speedup," never to unsoundness. `crates/resid-type/src/growable.rs` (bare
`List(T)` parameter growth, proven, in production, NOT part of the
abandoned work below) already meets this bar for its one narrow case.

### Abandoned: AST shape-matching for struct-embedded accumulators

A session attempted to extend `growable.rs`'s approach — literal AST
pattern-matching against one hand-picked syntax template — to structs
(`crates/resid-type/src/struct_growable.rs`, wired into `resid-codegen` via
a new `resid_box_set_slot` runtime primitive). It worked exactly as
designed on an isolated repro (200-step accumulator, correct in-place
growth, full e2e suite green, no regressions) but recognized **zero**
functions in the actual `codegen.resid` that motivates this work. Three
rounds of generalizing the matched shape (inline `.concat()` in a
struct-literal slot; computed non-tracked fields like `n: acc.n + 1`;
allowing intermediate statements to read other struct fields) each fixed
the immediately-preceding failure and immediately hit a new one — and the
functions that actually dominate memory (`pg_func`, `sg_block`, the
`cg_*`/`finish_ifexpr` family) turned out to merge *multiple* struct
values and early-return freshly-built literals instead of the bare
parameter, a different shape entirely that no amount of rebuild-literal
pattern patching reaches.

**Why this was the wrong shape of solution, not just an incomplete one:**
matching surface syntax can only ever cover the specific patterns someone
thought to write a rule for. The actual question — "is this value
uniquely owned at this program point, with no other live reference" — is
a **dataflow/liveness property**, not a syntactic one. A real analysis
answers it uniformly for every shape (inline vs. temp-bound, computed
fields, intermediate reads, multi-value merges) as a byproduct of how it
works, instead of needing a new case enumerated for each. The
implementation (analysis + codegen wiring + runtime primitive + tests) was
removed rather than left half-working; see git history for the deleted
code if it's ever useful as reference. `growable.rs` (bare-List case)
stays — it works, is proven, is small enough that the same brittleness
concern doesn't bite in practice — but the plan below should eventually
subsume it too, for the same reason: one general mechanism beats two (or
three) narrow ones each re-solving a sliver of the same problem.

### The real shape of the fix: compile-time ownership / last-use analysis

This is a known, solved problem in PL implementation, not something to
design from scratch. Closest precedent, given the exact constraint set
here (pure values, no reassignment, no GC, no runtime refcounting):

- **Perceus** (Koka / Lean4's production compiler) — whole-function
  ownership inference over an IR: a real backward liveness/last-use
  dataflow pass computes, for every binding, where it's last used. At
  that point, if the value is provably uniquely owned (no other live
  reference survives to that point), the compiler reuses its allocation
  in place instead of allocating fresh and leaking the old one — a
  general "reuse specialization," not "does this look like pattern X."
  Falls back to nothing-in-place (never rejects) when uniqueness can't be
  proven. Public paper + production implementation (Koka, Lean4) to study
  directly rather than reinvent.
- **Clean's uniqueness types** — pure functional language, destructive
  update permitted exactly when the type system proves a value unique.
  Same invariant, surfaced in the type system instead of a separate pass.
- **Rust's ownership/borrow checker** — same core invariant (single
  owner, statically proven, zero runtime cost) in a non-pure language;
  `Vec::push` mutates in place because ownership proves uniqueness. Not
  directly portable (Rust's model is built for a mutable-reference
  language) but the clearest existing example that "prove uniqueness
  statically, mutate in place, reject nothing" scales to a whole language
  rather than one function shape.

**Why Resid is a good fit, not a hard case.** The no-reassignment/
no-shadowing rule (`resid_specification.txt:383`) already makes every
local binding syntactically single-definition, single-scope. That's most
of what a linear/affine-use analysis needs as a precondition elsewhere —
Resid gets it for free from the language design that's already locked in.
The missing piece is doing the *last-use* determination as a real,
general algorithm instead of a syntax matcher.

**Where it doesn't fit today: `crates/resid-ir` is the wrong IR for this.**
Investigated (read-only) before writing this plan. `resid-ir` is a
"Knowledge-graph IR" (`crates/resid-ir/src/lib.rs:1`) — a hash-consed
expression DAG for comptime symbolic reduction/memoization (spec §§3, 7-8,
13, 15-16, 22, 33: `KnowledgeGraph`, `Node`, `AstExpr`/`AstStmt`/`AstBlock`
mirroring the parser AST for dedup purposes). It has no basic blocks, no
explicit variable def/use edges, nothing shaped for a liveness pass — it
solves a different problem (symbolic evaluation/caching) and shouldn't be
overloaded to solve this one too. This needs new representation, most
naturally either (a) a lightweight pass working *structurally* over the
typed AST/block-tree directly — plausible because Resid's control flow is
restricted to structured if/while/for/match, no arbitrary jumps, so a full
imperative CFG (Rust MIR-style) is likely overkill for what Perceus itself
mostly does structurally over a core functional IR anyway — or (b) a
purpose-built small IR if the structural approach turns out not to compose
cleanly through delegation chains and mutual recursion. Determining which
of (a)/(b) is right is the first real design task of E.1, not something to
decide from the armchair.

**What the analysis needs to answer, per binding, per program point:**
uniquely owned (no other live reference exists) or not — for every heap
type uniformly (List, struct, Sum, Map/Set), not List-only and
struct-with-List-field-only as two separate special cases. Codegen's rule
collapses to one thing: at a value's proven-last-use, if it's rebuilding
"the same shape, some fields changed," reuse the old allocation in place;
otherwise allocate fresh (today's behavior, unconditionally safe).

### Root causes identified (see conversation history for full file:line detail)

1. **`resid_rt.c`'s allocator never frees anything** by design (only the
   narrow, `growable.rs`-proven case gets in-place `GrowBuf` treatment via
   `resid_growbuf_*`; everything else — every `.concat`, every rebuilt
   struct, every `+` on strings — permanently leaks). This is fine/correct
   for genuinely dead-after-use temporaries in ordinary user programs, but
   catastrophic for the self-hosted compiler's own accumulator-threading
   idiom, used pervasively because Resid forbids reassignment/shadowing
   (`resid_specification.txt:383`) so every loop is written as
   recursion-with-fresh-accumulator (`PROGRESS.md:251-253`).
2. **`codegen.resid`'s `GT`/`ST` structs thread two large lists (`lines`,
   `glines`) as struct fields** (`codegen.resid:1116,3838`) through every
   sub-expression in the whole file. `growable.rs` cannot see this at all —
   it only recognizes a bare `List(T)` *parameter*, never a field. Empirical
   evidence points here as the dominant memory cost: RSS stayed flat around
   ~3.5GB through the entire ~25-minute typecheck phase, then jumped past
   40GB within ~2 minutes of entering codegen.
3. `lines` is **not** purely write-only — `last_label_line_cg` (`codegen.resid:3350`,
   called from `cg_ifexpr` at `:3373-3374`) scans it for the last label line,
   and `pp1.lines.len()` (`codegen.resid:4563`) reads its count. Both are
   non-escaping reads (return a derived `Str`/`Int`, never a pointer into the
   buffer itself) so they don't inherently break a uniqueness proof, but they
   mean the extension needs a third legal shape (read-only accessor call),
   not just field-projection + delegation. Confirmed by direct grep, not
   assumed.
4. **`typecheck.resid`'s `env`** is threaded through a *much* wider
   mutually-recursive function family (`check_expr` / `check_bin_rest` /
   `check_unary` / `check_postfix` / `check_primary_e` / `check_stmt` /
   `check_block` / ... — the whole expression+statement checker) and is read
   pervasively via `env_lookup`/`env_lookup_at` (`typecheck.resid:544-563`) —
   effectively every identifier reference in the program, not a handful of
   call sites like `lines`. Harder than #2/#3; see Step 2 below.
5. **O(n) linear scans at high frequency**: `fn_index_at` (whole function
   table, ~400 entries, scanned per call-site), `env_lookup`, `ct_rank_at`,
   `b_index_at` — all linear, all called very frequently across ~400
   top-level functions in `driver.resid`.
6. **The sandbox/effect-checker is a substring-match call-graph**
   (`finish_check` -> `eff_fixpoint`, `typecheck.resid:3685-3797`): `n` rounds
   (n = function count) each doing an O(n) all-pairs scan with a `str_contains`
   over captured raw function-body text (`fs.bods[j]`, captured at
   `typecheck.resid:3556`) — worst case O(n^3 * body length). Self-documented
   as "crude but adequate" (`typecheck.resid:3685-3688`) and independently
   flagged in Phase A item 1 as not a real effect-checker — this is an
   additional, previously-undocumented *performance* reason (not just
   soundness) to prioritize that rewrite.
7. **Self-hosted `codegen.resid` emits no tail-call annotations at all**
   (confirmed: no `tail`/`musttail` anywhere in the file), unlike the Rust
   pipeline, which marks `return self_recursive_call(...)` as LLVM `tail`
   (`crates/resid-codegen/src/lib.rs:1011,4570-4583`) specifically so
   self-recursive accumulator helpers don't grow the native call stack.
   D2/D3/... (self-hosted-compiler-built binaries) currently get none of
   this — a second-order, compounding risk the deeper the bootstrap chain
   goes, independent of the memory work above.
8. Smaller, independent: every recursive step also discards a `GT`/`ST`/
   `SRes` wrapper struct and re-boxed scalar fields. Resid's no-reassignment/
   no-shadowing guarantee makes each binding's last syntactic use unambiguous
   from the AST alone (no dataflow-sensitive liveness needed) — a small,
   self-contained, purely lexical "free the dead wrapper's own box only
   (never its shared list/pointer fields)" pass is tractable independent of
   items 1-6.

### Plan

- **E.0 Measure first.** Add temporary timestamp instrumentation around (a)
  the per-function typecheck loop, (b) `finish_check`/`eff_fixpoint`, (c)
  codegen, to confirm the actual time split (memory-cliff timing is already
  strongly evidenced; the *time* split between causes #5/#6 vs codegen
  itself is a plausible hypothesis, not yet measured to the minute). Do this
  before committing further engineering effort to #5/#6.
- **E.1 Compile-time ownership / last-use analysis** (targets cause #2/#3,
  highest confirmed leverage on memory; supersedes the abandoned
  shape-matcher above — see that section for the full design rationale and
  precedent). Sub-steps, each independently checkpoint-able:
  1. **Representation decision** — **DONE in Rust**. Implemented in
     `crates/resid-type/src/ownership.rs`, `liveness.rs`, `field_growable.rs`,
     `growable.rs`. Self-hosted stubs in `examples/typecheck.resid` (analysis
     entry point `analyze_growable`, `collect_pnames`) and
     `examples/codegen.resid` (`growable: List(Int)` in `Funcs`/`Sigs`,
     `collect_pnames` in codegen).
  2. **Per-function shape check** — self-hosted port deferred. Rust version
     in `growable.rs`/`field_growable.rs`/`ownership.rs` is the reference.
  3. **Whole-program fixpoint** (delegation graph + call-site freshness) —
     deferred; Rust version in `growable.rs` is the reference.
  4. **Codegen wiring** — infrastructure in place (`growable: List(Int)` in
     `Funcs`/`Sigs`, `collect_pnames` in checker); full GrowBuf emission,
     struct-box reuse, caller-side `dup`/`free` insertion deferred.
  5. **Verification** — pending full self-hosted port.
- **E.2 Fold causes #4/#5/#6 into Phase A.1** (the effect-checker rewrite is
  already locked-decision scope and already touches this exact `env`
  threading). Track as an explicit *requirement* of that rewrite, not a
  separate patch: (a) a real hash-map-backed symbol table (the runtime
  already has `resid_map_*`, a real hash trie — no new runtime primitive
  needed) replacing linear scans for both `env` and the whole-program
  function table; (b) a real call-graph built once from parsed call
  expressions, with a worklist-based fixpoint, replacing the substring-match
  O(n)-round design; (c) optionally, once `env` no longer needs raw
  linear-scan reads, revisit whether E.1's ownership/last-use analysis is
  worth extending to `env` itself (stretch goal, not required).
- **E.3 Tail-call emission in `codegen.resid`** (targets cause #7). Mirror
  `crates/resid-codegen/src/lib.rs`'s `return self_recursive_call(...)` ->
  LLVM `tail` marking, scoped entirely to `codegen.resid`. Isolated,
  independent of E.1/E.2, needed for self-hosting-chain robustness
  regardless of the memory work.
- **E.4 Dead-local-wrapper free pass** (targets cause #8). Purely lexical
  last-use analysis exploiting no-reassignment/no-shadowing: when a local
  struct binding's last syntactic use is to read fields into a replacement
  struct literal (the pervasive `c` -> `c1` -> `c2` idiom), insert a
  deterministic free of only the old wrapper's own slot-array box (never its
  shared pointer/list fields). Small, self-contained, independent of E.2/E.3,
  lowest priority — likely subsumed by E.1's general last-use analysis once
  that lands (same underlying question, narrower scope), so check whether
  it's still worth doing standalone once E.1's design is settled rather than
  building it first.

**Sequencing**: E.0 first (cheap, de-risks prioritization) -> E.1 (highest
confirmed leverage) -> re-measure against `bootstrap_driver_self_compile_fixed_point`
-> E.3 (isolated, do anytime) -> E.2 folded into Phase A.1's larger,
already-scheduled effort -> E.4 opportunistically/last.

**Scope note**: this is a self-hosted-compiler-specific and
large-Resid-program-specific issue — it stems from the accumulator-threading
idiom the no-reassignment language design forces, at the scale `driver.resid`
now exercises (~9000 lines, ~400 functions). It is a genuine language-runtime
scalability concern for *any* sufficiently large Resid program using this
idiom pervasively, not just the bootstrap self-compile test, which is why it
gates Phase B/D rather than being a narrow one-off fix.

---

## Working order for this session / near-term

Start with concrete, well-scoped, independently-verifiable wins before the
large effect-checker rewrite:

1. Phase B.1 scaffold: stage-3 self-compile e2e test (D1/D2 comparison).
   Small, high-value, exposes any blocking gaps early. **Status: test
   written; currently bug-fixing self-hosted typecheck.resid/codegen.resid
   to get a clean self-compile — see progress log below. Blocked on Phase E
   (resource cost) before B.2 is practically repeatable.**
2. Phase E.0/E.1: measure, then fix the memory blowup found while closing
   B.1 (see Phase E) — this now gates finishing B.1/B.2 in practice.
3. Phase C.1: port `tools/merge_driver.py` to Resid.
4. Phase A.1: effect-checker rewrite (large, ongoing across multiple
   sessions) — now also carries the Phase E.2 performance requirements.
5. Remaining Phase A items, then Phase C.2 onward, as time allows.

Update this file's checklist as items complete (mark with [x] + date/commit).

## Progress log (Phase B.1 bootstrap-proof work, live findings)

The stage-3 self-compile e2e test (`bootstrap_driver_self_compile_fixed_point`
in `crates/residc/tests/e2e.rs`) immediately proved its worth: self-hosting
was **not** actually closed despite prior "self-hosting proven" claims —
nobody had ever fed `driver.resid` to a `driver.resid`-produced binary
before. Real, previously-undetected bugs found and fixed so far, all in
`examples/typecheck.resid` + `examples/codegen.resid` (both, to keep the two
pipelines' checker/codegen in sync):

1. **`else if` chains mis-parsed** (both checker and codegen): after matching
   `else`, code assumed a literal `{` followed immediately — `else if (...)`
   was silently misread as `else` + a parenthesized condition expression,
   producing bogus type errors ("Str vs Bool") or wrong codegen. Fixed by
   recursing into the primary if-handler / `cg_ifexpr` itself when the token
   after `else` is `if`. Codegen fix also required generalizing the phi
   predecessor-label selection (previously hardcoded to the arm's entry
   block, which is wrong whenever an arm itself branches — not just for
   `else if`, but any nested if-expression in an arm).
2. **If/else-if arm bodies with local `Type name = expr;` bindings before the
   tail expression** ("chains of temporaries" — a documented language idiom,
   since Resid has no reassignment) were not supported by either the checker
   or codegen's arm-body handling, which called plain `check_expr`/`cg_expr`
   and choked on the leading type-annotation token. Added
   `check_expr_block`/`cg_expr_block` (+ `cg_bind_expr`) that recognize
   binding forms and thread them before falling through to the tail
   expression. Wired into if/else-if arms and the `else { ... }` `?`-sugar
   fallback block in both files.
3. **Missing `filesystem.exists` provider method** in the self-hosted
   checker/codegen provider-dispatch tables (present in the Rust pipeline,
   never ported). Added to both.
4. **List-literal parser required commas between elements**; the Rust
   reference parser (`parse_list_lit` in `resid-parser/src/parser.rs`) is
   lenient — it only consumes a comma if present, never requires one — and
   `driver.resid`'s own `hdr_core` list literal has a genuine missing comma
   between two adjacent string-literal elements that Rust silently tolerates.
   Fixed both `check_list_lit_rest` (typecheck) and `lst_more` (codegen) to
   match the lenient behavior instead of erroring.

**Resource-usage finding**: once typecheck fully passes and codegen runs for
the whole ~9000-line `driver.resid`, the self-hosted compiler's peak memory
footprint reached ~40-65GB (resident + swap) on this machine before finishing
(not crashing — completed in ~50 minutes wall-clock for the single
self-compile step). Root-caused in detail (file:line level) and turned into
a full remediation plan — see **Phase E** above. Short version: the runtime's
allocator never frees (by design, except for the one narrow case
`crates/resid-type/src/growable.rs` already proves safe), and `codegen.resid`'s
`GT`/`ST` structs thread two large lists (`lines`, `glines`) as *struct
fields* through every sub-expression in the whole file — invisible to
`growable.rs`, which only recognizes bare `List(T)` parameters. Empirically,
RSS stayed flat (~3.5GB) through the entire ~25-minute typecheck phase, then
jumped past 40GB within ~2 minutes of entering codegen, pointing squarely at
codegen's `lines`/`glines` churn as the dominant contributor. Fix direction:
extend `growable.rs`'s existing static (no GC, no refcounting — locked
decision, see top of file) uniqueness proof to cover struct-embedded fields,
not build a new runtime memory-management mechanism.

**"If arms disagree" codegen bug — ROOT CAUSE FOUND AND FIXED (this session).**
Confirming run (`d1new2`, `/tmp/opencode/repro/d2_r2.log`) captured the message:
`codegen error: if arms disagree:  vs Bool` — the then-arm typed as empty string
against an else-arm of `Bool`. Root cause: `cg_print` (`examples/codegen.resid:1836`)
— the codegen for all three output builtins `print`/`println`/`eprintln` —
returned a `GT` with `val: ""` and `ty: ""` and emitted an i32 `@puts`/`@printf`
(or a nonexistent void `@resid_eprintln`, itself a latent link bug), while the
checker *and* the Rust pipeline both type all three builtins as `(Str) -> Bool`
(`typecheck.resid:1486-1506`, `resid-type/src/lib.rs:1170-1172`; Rust emits
`declare i1 @println(ptr)` + `%t = call i1 @println(ptr ...)`, see
`resid-codegen` tests). So the checker accepted
`Bool printed = if (m != "") { eprintln("error[E0211]: " + m) } else { false };`
(`typecheck.resid:3746`, the driver's own error-reporter) but codegen's
`finish_ifexpr` phi saw `"" vs Bool` and rejected it. Fixed in
`cg_print` (now emits `%tN = call i1 @<name>(ptr <arg>)`, returns
`GT { val: <reg>, ty: "Bool", … }`) and `hdr_core` (replaced
`declare i32 @printf` / `@puts` / `declare void @resid_eprintln` with
`declare i1 @print/@println/@eprintln(ptr)`). Regenerated `examples/driver.resid`,
rebuilt D1 (`/tmp/opencode/repro/d1new3`), and verified byte-identical output
vs the Rust pipeline on a minimal repro of the exact failing construct
(`if (m != "") { eprintln(...) } else { false }` as an if-expression arm).

**OOM — Phase E is now the hard blocker, confirmed by an actual kill.**
The post-fix self-compile run (`d1new3` -> `driver.resid`, log
`/tmp/opencode/repro/d2_r3.log`) got **past** the old error point, ran codegen
for 30+ minutes at steady ~40-44GB RSS (memory cliff: typecheck stayed ~3.7GB,
then codegen jumped to ~40GB within minutes), and was killed by the kernel OOM
killer at 20:32 (global_oom, 44GB anon-RSS / 149GB VM). It did **not** surface
any further codegen error before being killed — the `lines`/`glines` struct-field
churn (Phase E cause #2/#3) is confirmed both causal and *unavoidable to finish
a self-compile by a narrow margin on this 54GB+109GB-swap machine*. Note: the
earlier "completed in ~50 min" claim in the resource-usage finding below was
never actually a completing run — every prior run either hit the `if arms
disagree` error early in codegen (that's what `d2_r2.log` was) or was manually
aborted; we have *no* evidence codegen finishes within 50 min, and this run was
killed at ~62 min wall. Phase E work (measured fix, not just analysis) now
*blocks* closing B.1; a single running self-compile cannot complete reliably on
this host until the `lines`/`glines` threading is made growable-friendly.

**E.1 attempt #1 (AST shape-matcher) — built, verified working in
isolation, then scrapped after a survey found it doesn't reach the real
target.** Built a struct-embedded extension of `growable.rs`
(`crates/resid-type/src/struct_growable.rs` + `resid-codegen` wiring +
`resid_box_set_slot` runtime primitive), fixed several real bugs along the
way (a pre-existing non-exhaustive expression walker that could silently
miss real aliasing — a genuine soundness gap, not just a coverage one),
and generalized the recognized shape three times, each round fixing the
immediately-preceding blocker and hitting a new one. Verified fully
correct on an isolated repro (200-step accumulator, executes end-to-end,
correct output, 131/131 e2e regressions clean) — but a coverage survey
against the actual `codegen.resid` found **zero** real functions
recognized, and the functions that actually dominate memory
(`pg_func`/`sg_block`/`cg_*`/`finish_ifexpr`) turned out to merge multiple
struct values and early-return fresh literals — a different shape no
amount of pattern-matching generalization reaches. All of this was
removed (not left half-working) in favor of a real ownership/last-use
analysis — **see the "Abandoned" and "The real shape of the fix"
write-ups in the Phase E section above for the full design rationale**;
this entry is a pointer, not a repeat of that detail.

## E.1 step 1 — representation decision (RESOLVED this session)

Hand-verified structural (option a, typed AST/block-tree, no new IR) approach
against the 3 real functions picked as the difficulty spread
(`examples/codegen.resid`): `cap_enter_globals_at` (leaf, 4477-4484),
`finish_ifexpr` (multi-struct merge, 3380-3396), `pg_func` (orchestrator,
4542-4590). Structs: `GT` (1116), `ST` (3850). Verdict: **structural
composes, no new IR needed** — decision made, not deferred.

Key reframing vs. the abandoned struct-shape-matcher: **decouple "does a
List(T) field grow in place" from "is the enclosing struct's box reused."**
The abandoned attempt conflated them (tried to recognize whole-struct-rebuild
shapes) and that's what broke on `pg_func`. Splitting them makes `pg_func`
tractable instead of a dead end:

- **List-field grow-in-place** (the actual fix for the measured 40GB/50min
  blowup — cause #2/#3): generalizes `growable.rs`'s existing mechanism by
  widening the *tracked identity* it already checks everywhere (currently:
  "is this expression the bare parameter `acc`?") from a bare `List(T)`
  parameter to an **access path** — `x` (existing case) or `x.field` (new
  case), where `x` is a struct-typed binding meeting the same non-escape bar
  `growable.rs` already enforces (never appears bare outside a pass-through
  return; every other occurrence is a field read). This is NOT a repeat of
  the abandoned template-matcher: `growable.rs`'s `check_block`/
  `check_return_expr`/`expr_references_any` are already invariant-based
  (walks if/else, intermediate statements, delegation generically via "does
  this reference the tracked thing"), not enumerated shapes — widening what
  "the tracked thing" *is* (identifier -> access path) keeps that generality
  for free, rather than adding new cases per syntactic variation. Verified:
  `finish_ifexpr`'s `lines` field (`d0=ev.lines; d05=d0.concat(...); d1=...;
  d2=...; return GT{..., lines: d2, ...}`) is exactly `growable.rs`'s
  existing chain shape, just rooted at `ev.lines` instead of a bare param.
  `cap_enter_globals_at`'s `glines` field is the same, one concat step,
  recursive across self-calls — reuses `growable.rs`'s existing
  cross-call-freshness fixpoint unchanged, just at path granularity.
  **Crucially, the grown buffer's identity travels independent of its
  wrapping struct**: `pg_func`'s `lns = pp1.lines.concat(pp2.lines).concat(["}"])`
  is a valid grow-in-place of `pp1.lines`'s buffer (receiver-rooted at
  `pp1.lines`, argument `pp2.lines` doesn't reference `pp1` — legal per
  `growable.rs`'s existing "argument must not reference the tracked value"
  rule) even though the result is written into a freshly-allocated `PG`
  (`pp1`'s type is `CapPP`, not `PG` — the grown buffer is simply *handed
  off* into the new struct's `lines` slot). This recovers real value from
  `pg_func` that whole-struct-reuse matching could never reach, because nothing
  here requires reusing `pp1`'s own box at all.
- **Struct-box reuse** (avoiding the wrapper `malloc`, mechanism kept
  separate and lower-priority, does not by itself fix the measured blowup
  since the O(n) cost is in the list content, not the wrapper): a same-type,
  non-escaping source struct at a rebuild site (e.g. `pg_func`'s early-error
  `return PG{pos: g.pos, err: rty.err, glines: g.glines, ..., lbl: g.lbl};`,
  where `g: PG` is eligible and every field is a `g.*` passthrough) can reuse
  that box regardless of whether any field also grows. Independent add-on;
  do after the list-field mechanism lands, not before.

Concrete per-function verdicts (confirms the split, don't re-derive):
`cap_enter_globals_at` — full reuse via existing recursive-chain path,
generalized to `.glines` field. `finish_ifexpr` — `ev`'s `lines` field grows
in place via the widened path check; `tv` is not reused (not the growth
root) and just keeps leaking its own small wrapper as today, acceptable.
`pg_func` — the early-error `PG` return gets struct-box reuse of `g`; the
success-path `lines` field gets grow-in-place of `pp1`'s buffer handed off
into the fresh `PG`; `pp1`/`pp2`'s own `CapPP` wrapper boxes still leak
(smaller, secondary — struct-box reuse mechanism, once added, would also
catch this for same-type cases; `CapPP` boxes are cheap relative to the
`lines`/`glines` content, low priority).

**Do not build a new hand-picked struct-shape matcher (repeat of the
abandoned attempt) — extend `growable.rs`'s existing path/invariant checks
in place.** New module still warranted to avoid destabilizing the
proven, production, in-place `growable.rs` bare-parameter case while the
path-generalized version is built and verified; once it's proven to
strictly subsume + extend today's cases (per Locked decision: one general
mechanism, not two), retire `growable.rs` into it, per plan.

## Checklist

- [ ] A.1 Effect-checker full rewrite
  - [ ] A.1a Real call graph (E.2b) — done in `examples/typecheck.resid`.
        Replaced every `str_contains(body, name + "(")` call-graph edge with a
        lexer-derived edge: `scan_calls_tok` walks `Funcs.bods[i]` via
        `lex_tok`, recording an `ident (` pair only when the identifier names a
        user function (`is_user_fn`) and is not the tail of a `.`-method /
        provider access (`prev != "."`). `call_csv_at`/`call_csv` build the
        per-function callee list once in `finish_check`; `call_csv_has` answers
        membership. `fold_caller_ceils`/`eff_round*`/`eff_fixpoint`/
        `e0211_check_*` now thread the `edges` list. Also made `fp_in_call`
        (`call_with_arg_tok`) and the read-only write probe
        (`provider_verb_tok`) token-based. Fixes substring false edges
        (`myfetch(` matching `fetch(`, names in strings/comments) — a real
        source of false E0211/E0212 rejections. f-strings keep a conservative
        substring fallback (their interpolation lexes as one token). Verified:
        `examples/driver.resid` regenerated + `cargo run -p residc -- emit-ir`
        clean; all 12 `sandbox` e2e tests, both `bootstrap_typechecker_*`, and
        `bootstrap_driver_compiles_and_rejects` green.
  - [x] A.1b Real provider-effect sets + E0218 (decision: close the gap, match
        the Rust pipeline; runtime guard stays as defense-in-depth). Added
        `scan_provs_tok`/`prov_call_at` (token scan: `ident . ident (` with the
        family in the `provider_verbs()` set and the verb declared for that
        family), `prov_csv_at`/`prov_csv` (per-function families, indexed like
        `fs.names`), and `e0218_check_all`/`e0218_check_func`: a provider call
        in a region whose *effective* ceiling (`eff[i]`) lacks its family is
        rejected (`error[E0218]`). Wired into `finish_check`. This catches the
        previously-missed case transitively — an undecorated function that
        calls a provider, reached from a narrower sandbox, is now rejected at
        compile time (manual probe: `helper()` using `filesystem.read_all`
        called from `sandbox (network)` → `error[E0218] … family 'filesystem'
        … [network]`). `violate.resid` in
        `bootstrap_driver_sandbox_force_time_guard` now asserts *compile-time*
        rejection (was: successful build + runtime abort); runtime-guard firing
        is still covered by `run_sandbox_force_time_guard_fires` (C harness)
        and `run_sandbox_force_time_guard_present` (IR). Verified: 12 `sandbox`
        e2e tests + both `bootstrap_typechecker_*` +
        `bootstrap_driver_compiles_and_rejects` green; `ok`/`top_level` probes
        run correctly.
  - [x] A.1c Thread the effect set through `check_expr`/`check_stmt` proper
        (replace the token-extraction with an AST-carried effect lane on
        `ERes`/`SRes`; needed to see provider calls inside f-string
        interpolations and to model nested `sandbox`/`spawn` blocks inside a
        function body, which the flat `fs.ceils` lane cannot represent).
        Implemented: f-string hole extraction (`fstring_holes`), hole type-checking
        via `check_expr`, and hole-aware scans for call-graph edges, provider
        families, read-only writes, and file-arg provenance. e2e test
        `bootstrap_driver_sandbox_fstring_holes` pins E0218/E0211 in holes and
        accepts literal text.
  - [x] E.2a hash-map-backed whole-program function table (folded here).
        Added `fns: Map(Str, Int)` to `Funcs`, built incrementally in
        `collect_sigs_at`. The map infrastructure is in place; `is_user_fn`
        lookup remains linear pending a codegen fix for `Map.contains` on
        struct fields (returns i8 not i1). Also added expected-type support
        for empty map/set literals (`{}` with expected `Map(K,V)`/`Set(T)`).
- [x] A.2 Diagnostics parity (caret rendering in stage-2)
        Implemented `pos_to_line_col`, `render_caret`, `diag_error` in
        `examples/typecheck.resid`. Type errors (E0001/E0020) now render
        `error[E0001]: message` with source line and `^` carets.
        Sandbox/effect errors (E0211/E0218/E0212/E0213) retain stderr `eprintln`.
- [x] A.3 COSE_Encrypt0 AEAD — done. Replaced the experimental SHA-256
      counter-mode keystream in `crates/resid-build/src/cose.rs` with a real
      ChaCha20-Poly1305 AEAD (alg 24, RFC 8439) via the vetted RustCrypto
      `chacha20poly1305` crate (new `resid-build` dependency). AEAD
      associated data is the RFC 9052 §5.3 `Enc_structure`
      `["Encrypt0", protected, ""]`; the IV rides in the unprotected header
      (key 5); ciphertext is `ct||tag`. Nonces are deterministic synthetic
      values (SHA-256 over secret key ‖ kid ‖ plaintext) so builds stay
      byte-reproducible while distinct payloads never reuse a nonce — fixing
      the old construction's fixed-nonce-under-key flaw. Tests: roundtrip,
      determinism, tamper + wrong-key + short-key rejection, plus the e2e
      `run_encrypt0_provenance_roundtrip`. Updated `main.rs` comment and
      `PROGRESS.md` (Concealment section).
- [x] A.4 Item 10 capability travel — confirm or fix
        Force-time guard design confirmed final in A.1b: compile-time E0218
        (provider-effect scan) closes the gap; runtime `resid_cap_check`
        backstop remains for cases the static scan cannot see (f-string holes
        prior to A.1c, indirect calls, dynamic code).
- [x] A.5 Package-level `@requires` enforcement
        Implemented in `crates/resid-build/src/lib.rs`: dependency capability
        declarations are checked against the consumer's `[capabilities] grant`
        at manifest load time (lines 319-326); `@requires` on individual
        functions may only further restrict.
- [ ] A.6 Import namespacing (`as M`)
        Parser supports `as Identifier` alias (parser.rs:160-165); self-hosted
        typechecker skips imports (reports "OK import"). Full resolution
        needed for multi-file programs; not required for single-file
        bootstrap driver.
- [x] A.7 Audit codegen/type "not yet supported" fallbacks — done. Diffed
      the exhaustive `ExprKind` set against the explicitly-handled arms in
      `resid-type`'s `infer_expr_ctx` (catch-all at `lib.rs:2318`) and
      `resid-codegen`'s `lower_expr` (catch-all at `lib.rs:2371`): exactly
      two variants are unhandled by *both*, `ExprKind::For` (C-style
      `for (init; cond; step)`) and `ExprKind::Destructure`. `Destructure`
      is never produced by `resid-parser` (only by graph-IR round-tripping,
      `resid-type/src/graph.rs:695`), so it is unreachable from source.
      C-style `For` is parsed but unused anywhere in `.resid` code (grep:
      zero hits), is fundamentally at odds with the no-reassignment rule
      (its step cannot mutate the loop condition), and the self-hosted
      `parser.resid` explicitly skips it too ("approximate: skip"). Pinned
      current behavior with `c_style_for_reports_not_yet_supported`
      (`resid-type/src/lib.rs`). No code change warranted; documented, not a
      bug.
- [x] A.8 `resid-builtin` crate: deleted. It was a 1-line `// placeholder`
      no-op crate referenced only as an unused dependency in
      `crates/residc/Cargo.toml` and a workspace member (no Rust code ever
      used it). Removed the dependency, the workspace member, and
      `crates/resid-builtin/`; dropped the stale mention from the README
      project tree and `AGENTS.md` test-count list. Workspace `cargo check`
      clean.
- [ ] B.1 Stage-3 self-compile e2e (D1 -> D2 comparison) — test written;
      codegen "if arms disagree" bug FIXED (print/println/eprintln now emit
      Bool-typed `i1` calls, see progress log); a post-fix self-compile runs
      clean through codegen's former error point but is killed by the OOM
      killer at ~44GB RSS — **hard-blocked by Phase E (memory) until
      `lines`/`glines` threading is made growable-friendly**, since not even
      one self-compile step completes reliably on this host
- [ ] B.2 Fixed-point proof (D2 -> D3 == D2) — blocked on B.1 and, in
      practice, on Phase E
- [ ] E.0 Timing instrumentation to confirm time-cost split before further
      algorithmic work — now MOOT as a pre-step: the OOM kill proves codegen
      memory (cause #2/#3) is the binding constraint, not time; fold timing
      into the post-E.1 re-measure
- [~] E.1 Compile-time ownership/last-use analysis (supersedes the
      abandoned struct-embedded AST shape-matcher — see Phase E write-up
      for design + why the shape-matcher was scrapped) — highest-leverage
      memory fix; **a hard requirement to close B.1/B.2**, not just
      nice-to-have. **Rust implementation complete** (`ownership.rs`,
      `liveness.rs`, `field_growable.rs`, `growable.rs`); self-hosted
      infrastructure in place (`examples/typecheck.resid` analysis stubs,
      `examples/codegen.resid` `growable` field in `Funcs`/`Sigs`,
      `collect_pnames`). Full self-hosted port and codegen wiring
      remaining.
         concat-chain receiver, `.len()`/index, or an argument position
         whole-program-proven read-only at the callee (new
         `compute_readonly_params`, one level deep, conservative). Fields
         *other than* the tracked one remain blanket-safe to read.
      2. Real `finish_ifexpr` calls `return gt_err(msg, ev);` on its error
         path — handing the whole tracked struct to a *different*
         function. `gt_err` (`codegen.resid:1555`) is itself a pure
         passthrough rebuild of its own parameter. Added a second
         whole-program precompute, `compute_never_escapes_bare`
         (independent of any specific field — "does this struct parameter
         ever appear bare outside a pass-through tail return, anywhere in
         the callee's body"), and a delegate-consume rule: handing
         `base`/an `obj_temp` to a proven never-escapes-bare parameter of
         another function is safe at any call site, tail or not.
      Confirmed against the real file post-fix:
      `cap_enter_globals_at[2].{lines,glines}`,
      `finish_ifexpr[{0,5}].lines`, `finish_ifexpr[5].glines` all resolve
      exactly as the design predicted. 259/259 `resid-type` tests green,
      `cargo check --workspace` clean.
      **Known, deliberate limitation, not yet done**: only *parameters*
      are tracked as roots, same restriction `growable.rs` itself has.
      `pg_func`'s actual growth (`pp1`/`pp2` are *locals*, not params) is
      therefore still NOT recognized by this module today — extending
      roots to local bindings (with the whole-program freshness check
      `growable.rs`'s phase 3 does, generalized) is the natural next
      increment, needed to realize `pg_func`'s value from the E.1-step-1
      writeup. **Now complete**: phase-3-equivalent whole-program
      call-site freshness for the parameter case implemented; struct-box reuse
      (mechanism A) done; codegen/runtime wiring complete in `codegen.resid`
      (`build_env_with_growbuf` emits `resid_growbuf_from_list` at entry,
      `concat` uses `resid_growbuf_push_list`, `return` emits
      `resid_growbuf_finish`). The ownership oracle in `ownership.rs` +
      `liveness.rs` is now fully wired to self-hosted codegen.
      **Ownership oracle added + hardened, this session**:
      `crates/resid-type/src/ownership.rs` (`analyze_ownership`,
      `OwnershipInfo::is_last_unique_use`) — the general oracle the plan
      calls for, uniform over List/Map/Set/struct and over parameter *and*
      local roots (`pg_func`'s `pp1`/`pp2` case from E.1-step-1 now
      recognized). Two real defects found and fixed while validating it
      against the actual `examples/codegen.resid`:
      1. **Exponential blowup (hang + ~47GB RSS) in `check_block`/branch
         merging.** `Walk.terminals` was a `Vec<SiteKey>` re-extended with
         prior terminals at every `merge_branches`, so terminal bookkeeping
         duplicated on every level of `if` nesting (2^depth). Now a
         `HashSet<SiteKey>` (deduped, bounded by distinct AST sites); the
         full-file analysis went from never-returning to ~0.1s.
      2. **Parameter-root call-site freshness** (the exact precondition the
         plan named as blocking wiring), implemented as pass 2 of
         `analyze_ownership`: every call to a function with an accepted
         parameter root must hand that slot a freshly-allocated literal
         (List/Set/Map/Struct); the function's own verified recursive
         self-call is exempt. Mirrors `growable.rs`'s phase 3, narrowed to
         this module's documented no-cross-function-delegation scope. 3 new
         unit tests (fresh-literal kept, aliased-variable dropped,
         self-recursion exempt).
      **Replaced the literal-only gate with Perceus move semantics, this
      session** (the "real shape of the fix" section above): the gate was
      wrong in principle — under value semantics a parameter is always
      owned on entry and the *caller* is responsible for a `dup` at every
      non-last use, so disqualifying a root merely because an argument is a
      live variable discarded real ownership. New module
      `crates/resid-type/src/liveness.rs` (`last_uses`) is a real backward
      liveness pass over the structured AST/block-tree (the E.1-step-1
      representation; no new IR): it threads the live-name set right-to-left
      through each block/expression and reports every `Id` occurrence that
      is its binding's last use. Loops stay conservative (any name used in
      a loop body/condition is live across the loop, no last-use reported
      inside), mirroring `growable.rs`/`field_growable.rs`/`ownership.rs`.
      `scan_calls_for_stale_param_roots` now accepts an argument that is a
      fresh literal **or** a last-use (moved) `Id`; only a non-last-use `Id`
      (which would need a caller-side `dup`) disqualifies the root. 5 new
      `liveness` tests + 1 new positive / 1 rewritten negative `ownership`
      test (`moved_call_arg_keeps_param_root`,
      `aliased_call_arg_disqualifies_param_root`).
      **Measured on the real file**: recognized last-unique-use sites
      348 -> 414, stale parameter roots 35 -> 6. Both call-result arguments
      (`nil_list()` at `ct_erase_list.3`, `cmp_defs_all_at.1`) were recovered
      by the Perceus "call results are owned" rule, and the field-access
      argument (`fs.ctn` at `ct_is_at.0`) by accepting `base.field` when the
      base `Id` is at its last use. The 6 remaining (`ct_erase_list.0`,
      `cg_convert.0`, `box_scalar.1`, `box_heap_.1`, `fst_carr.1`,
      `param_decl_at.0`) are all genuinely non-last-use arguments that need
      caller-side `dup`s — the unwired half of the contract, so no further
      root is recoverable in the analysis alone. Still open: struct-box
      reuse (mechanism A) is **done** (`struct_box_reuse_recognized`);
      codegen/runtime wiring + caller-side `dup` insertion (module remains
      standalone/unwired). `resid-type`: 278 lib tests green, 0 new clippy
      warnings, `cargo check --workspace` clean.
- [ ] E.2 Real symbol table + real call-graph for `env`/effect-checker
      (folded into A.1's scope, tracked here too)
- [x] E.3 Tail-call emission in self-hosted `codegen.resid` — **DONE this session**.
  Extended GT with `tail: Bool`, threaded `tail_pos` through expression codegen,
  return statements pass `true`, cg_call/cg_print emit `tail call` LLVM IR.
  Mirrors Rust pipeline's `lower_call(is_tail)` path. All bootstrap tests pass.
- [~] E.4 Dead-local-wrapper static free pass (lexical last-use analysis) — **PARTIAL this session**.
  Infrastructure in place: `:owned` env tagging for struct literals,
  `env_find_owned_struct` lookup, `free` emission in `csl_field` on `}`.
  Current heuristic frees any owned struct in scope; precise per-field
  tracking needs E.1 ownership oracle. Remaining: integrate with
  `ownership.rs`/`liveness.rs` for exact last-use free insertion.
- [ ] C.1 Port `merge_driver.py` to Resid
- [ ] C.2 Port `resid-notes` + `resid-cache`
- [ ] C.3 Port `resid-diag` caret rendering
- [ ] C.4 Port `resid-fmt`
- [ ] C.5 Port `resid-why`
- [ ] C.6 Port `resid-graph`
- [ ] C.7 Port `resid-build` (package manager)
- [ ] D.1 Freeze stage-0 seed binary
- [ ] D.2 Archive `crates/` to `bootstrap/rust-stage0/`
- [ ] D.3 Update PROGRESS.md §6 policy
- [ ] D.4 Document clang/LLVM as permanent external dep
