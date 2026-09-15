# Sandbox Parity Plan — Stage-2 Driver

**Goal**: Full sandbox/capability support in the self-hosted driver so all 7
sandbox e2e tests pass through the stage-2 pipeline (driver.resid), achieving
parity with the Rust stage-1 pipeline (residc).

**User decisions**:
- Scope: Full parity (~2500 lines across typecheck.resid + codegen.resid)
- Error matching: Byte-exact stderr to match residc (E0xxx codes, spans, caret rendering)
- Residual calls: Included (force-time-guard-fires through driver)

---

## 1. Architecture Gap Analysis

### 1.1 Error Output Channel
| | Stage-1 (residc) | Stage-2 (driver) |
|---|---|---|
| Channel | **stderr** (`eprintln!`) | **stdout** (`println`) |
| Format | `error[E0xxx]: <msg>` + span + caret | `type error: <msg>` (plain) |
| Exit code | 1 (via `process::exit`) | 1 (via `return 1`) |
| Line/col | Yes (byte offset → line:col) | No (pos carried but never rendered) |

**Blocker**: The driver has no stderr-writing capability. `println` in Resid
goes to stdout. To match residc's stderr output, we need one of:
- (A) Add a `resid_eprint` / `resid_eprintln` C runtime function callable from
  Resid via `import "c"` / RT declaration, so the driver can write to stderr.
- (B) Capture the driver's stdout in the test and reinterpret it as stderr
  (dirty — masks legitimate stdout from the compiled program).
- (C) Accept a deviation: driver prints to stdout with error codes; tests
  match the formatted text but not the channel.

**Recommendation**: Option (A) — add a tiny C helper:
```c
#include <stdio.h>
#include <stdarg.h>
void resid_eprintln(const char* msg) { fprintf(stderr, "%s\n", msg); }
void resid_eprintln_i64(const char* prefix, long n) { fprintf(stderr, "%s%ld\n", prefix, n); }
```
Then the driver calls `resid_eprintln(...)` instead of `println(...)` for errors.

### 1.2 Error Code + Span Infrastructure
The driver needs to render:
```
error[E0212]: function `fetch_data` requires capability `network` which exceeds
  the effective capability ceiling [filesystem]
  ┌─ sample.resid:4:5
  │
4 │     @requires(network)
  │     ^^^^^^^^^^^^^^^^^ requires `network`
```

This requires:
- A line-number lookup table (byte offset → line:col) computed once from source
- Error code strings (E0xxx) per error site
- A span-to-caret renderer (read source line, find column, emit caret)

The Rust pipeline does this in `crates/resid-diag/src/lib.rs` (~500 lines).
The driver equivalent would be ~300-400 lines of Resid string manipulation.

**Alternative**: Instead of full caret rendering, produce the `error[E0xxx]: msg`
header (matching residc) and append a simplified span like `(sample.resid:4:5)`
without caret. This is still recognizable but not byte-identical caret output.

### 1.3 Current Error Format Strings (driver)
From `typecheck.resid` and `driver.resid`:
- `println("type error: " + d.err)` — typecheck (lines 3384, 3405, 7095, 7116)
- `println("type error: " + msg)` — behavior (line 3178)
- `println("codegen error: " + res.err)` — codegen (line 4424, 8000)
- `println("type error: unexpected declaration")` — fallback (3410, 7121)

None include error codes, spans, or caret rendering today.

---

## 2. What the Driver Must Handle (Feature Scope)

### 2.1 Parsing (parser.resid — ALREADY DONE)
`parse_sandbox`, `parse_sandbox_caps`, `parse_sandbox_body` at lines 991-1031.
`@requires(...)` parsing: NOT YET DONE (must parse annotation before function).

### 2.2 Type Checking (typecheck.resid)
Per-function sigs must carry:
- `requires`: list of capability families this function needs (from `@requires(...)`)
- `sandbox_ceiling`: list of caps enclosing this sandbox grants

New checks:
- **E0212**: `function F requires capability X which exceeds effective ceiling [caps]`
- **E0213**: `unknown capability mode 'readoly' on 'filesystem'; supported modes are 'readonly' and 'readwrite'`
- **E0211**: `call to F requires capability X which exceeds the caller's effective sandbox ceiling [caps] (attenuation is transitive across the call closure)`
- **Handle entry**: `File handle parameter on F requires capability filesystem; the enclosing sandbox ceiling [caps] does not grant it`
- **Value provenance**: `File handle value passed into a sandbox that does not grant filesystem`
- **Read-only write rejection**: `write operation 'filesystem.write_all' in read-only sandbox; the ceiling grants only read access`

### 2.3 Code Generation (codegen.resid)
- **cap_enter** prologue: `alloca [1 x ptr]` + `store ptr @str` + `call void @resid_cap_enter(ptr %cap_set, i64 N)` at entry of sandboxed functions
- **cap_check** before provider calls: `call void @resid_cap_check(ptr @str.N)` with fresh string constant per call site
- **cap_leave** before each return: `call void @resid_cap_leave()`
- **hdr_core declarations**: `declare void @resid_cap_check(ptr)`, `declare void @resid_cap_enter(ptr, i64)`, `declare void @resid_cap_leave()`
- **Global string constants**: `@str = unnamed_addr constant [N x i8] c"filesystem\00"` (public, per Rust pipeline format)

### 2.4 Transitive Attenuation (the hard part)
Rust implementation: `enforce_transitive_attenuation` (lines 4131-4281)
- Build call graph (caller → callee edges)
- Seed effective ceilings from sandbox ceilings
- Fixpoint iteration: propagate ceilings along call edges (only shrink)
- Enforce: every call from restricted caller must fit caller ceiling
- Handle-entry: File params in restricted regions must be permitted
- Value provenance: walk File-typed values through body

In Resid (no reassignment): fixpoint via recursive state-threading struct.
Call graph collection requires walking function bodies textually to find
function calls — doable in the existing text-based parser pattern.

### 2.5 Residual/Dynamic Calls (force-time guard fires)
Stage-1 allows calls through variables/function pointers (residual calls):
the `resid_cap_check` guard fires at runtime if the capability isn't granted.
The driver must:
- Detect residual calls (call target not in known sigs) during typecheck
- Emit `resid_cap_check` for residual call sites during codegen
- Match residc's IR output for the `run_sandbox_force_time_guard_present` test

---

## 3. Test Plan

### 3.1 New bootstrap_* parity tests in e2e.rs

For each of the 7 existing `run_sandbox_*` tests, add a `bootstrap_sandbox_*`
counterpart that runs through the driver and matches stage-1 output.

| Stage-1 test | Stage-2 bootstrap test | What it asserts |
|---|---|---|
| `run_sandbox_enforcement` | `bootstrap_sandbox_enforcement_parity` | Legal sandbox compiles+runs stdout="42"; illegal → stderr contains "network", exit ≠ 0 |
| `run_sandbox_transitive_attenuation` | `bootstrap_sandbox_transitive_attenuation_parity` | Legal transitive call runs stdout="42"; illegal → stderr contains "network"+"fetch", exit ≠ 0 |
| `run_sandbox_handle_entry_file_param` | `bootstrap_sandbox_handle_entry_file_param_parity` | Legal File param sandbox runs stdout="5"; illegal → stderr contains "handle parameter"+"filesystem" |
| `run_sandbox_handle_entry_file_argument` | `bootstrap_sandbox_handle_entry_file_argument_parity` | Legal File arg sandbox runs stdout="1"; illegal → stderr contains "File handle value"+"filesystem" |
| `run_sandbox_capability_mode_readonly` | `bootstrap_sandbox_capability_mode_readonly_parity` | Legal RO sandbox runs stdout="5"; illegal write → stderr contains "write operation"+"read-only"; misspelled mode → stderr contains "unknown capability mode" |
| `run_sandbox_force_time_guard_present` | `bootstrap_sandbox_force_time_guard_present_parity` | Driver emit-ir output contains "resid_cap_check", "resid_cap_enter", "resid_cap_leave" |
| `run_sandbox_force_time_guard_fires` | *(not needed — test is pure C harness)* | Already tests runtime directly; no driver involved |

### 3.2 Error matching target
Byte-exact stderr with E0xxx codes and spans (user's choice). This means the
driver must:
1. Write errors to stderr (not stdout)
2. Format as `error[E0xxx]: <msg>`
3. Include source location (at minimum `file:line:col`)
4. Optionally include caret rendering (would be byte-exact)

---

## 4. Implementation Plan

### Phase 0: Prerequisites (stderr + error formatting)
**Files**: `crates/residc/resid_rt.c`, `examples/codegen.resid` (hdr_core), tests

1. Add `resid_eprintln(const char*)` to `resid_rt.c`
2. Add `declare void @resid_eprintln(ptr)` to hdr_core in codegen.resid
3. Add `import "c"` declaration in typecheck.resid + codegen.resid for eprintln
4. Add line-number computation helper (byte offset → line:col from source string)
5. Add error formatting helpers:
   - `fmt_error(code, msg, file, line, col)` → `error[E0xxx]: msg\n  ┌─ file:line:col`
   - `fmt_error_with_caret(code, msg, file, line, col, source, span_start, span_end)` → full caret output
6. Wire driver main to emit errors via eprintln instead of println

### Phase 1: Funcs + Parsing (typecheck.resid + codegen.resid)
**Both files in parallel**:

1. Add `reqs: List(Str)`, `ceils: List(Str)` to `Funcs` type
2. Update `funcs_empty` to init empty lists
3. Update all Funcs construction sites (8 in typecheck, 5 in codegen)
4. Add `@requires(...)` parsing in `collect_sigs_at`:
   - Before each function decl, look for `@requires(cap1, cap2, ...)` pattern
   - Parse capability list: bare names (`network`) or `name(mode)` (`filesystem(readonly)`)
   - Store in `reqs[i]` as comma-joined string, empty = no requirements
5. Add `sandbox (caps) { ... }` handling in `collect_sigs_at`:
   - Parse sandbox caps: same format as @requires
   - Store ceiling in `ceils[i]` for each function found inside the sandbox body
   - Parse mode keywords: `readonly`, `readwrite`; reject unknown → E0213
6. Add `sandbox` handling in `check_program`/`pg_next`:
   - Flatten: walk sandbox body declarations, checking/codegen each with ceiling context

### Phase 2: Type Checking Enforcement (typecheck.resid)
**Hard phase**:

1. **E0212 enforcement**: After type-checking each function body, if ceiling
   exists, verify every `@requires` cap is in the ceiling:
   `caps_contain_family(ceiling, req)` → E0212 error if not
2. **Read-only write rejection**: For each provider call in a sandboxed
   function, check if the enclosing ceiling grants `:ro` and the verb is a
   write verb (`is_write_verb`) → reject with E0213-style message
3. **Transitive attenuation** (fixpoint):
   - Collect call graph: walk each function body, find `ident(args)` calls
   - Seed effective ceilings from `ceils` per function
   - Fixpoint iteration (recursive state struct, bounded by N functions):
     propagate `meet_caps` along call edges
   - Enforce: for each call from restricted caller to callee, verify
     callee's `@requires` ⊆ caller's effective ceiling → E0211
4. **Handle-entry**: For functions with `File` params in restricted regions,
   check ceiling grants `filesystem` → error if not
5. **Value provenance** (File values): Walk function bodies, track File-typed
   variables passed as call arguments into restricted-region callees

### Phase 3: Code Generation (codegen.resid)
**Relatively mechanical once Phase 1+2 done**:

1. **cap_enter prologue** in `pg_func`: When `ceils[i] != ""`, emit:
   - `@str = unnamed_addr constant [N x i8] c"<caps>\00"` global
   - `%cap_set = alloca [1 x ptr], align 8`
   - `store ptr @str, ptr %cap_slot, align 8`
   - `call void @resid_cap_enter(ptr %cap_set, i64 N)`
2. **cap_check** in `cg_provider`: Before each provider call inside a
   sandboxed function, emit `call void @resid_cap_check(ptr @str.N)` with
   a fresh string constant for the cap family
3. **cap_leave** before returns: In `pg_func`, before every `ret` in a
   sandboxed function, emit `call void @resid_cap_leave()`
4. **hdr_core**: Add 3 declarations (resid_cap_check, resid_cap_enter,
   resid_cap_leave) at the correct position (before resid_arith_overflow)

### Phase 4: merge_driver.py + Regeneration
1. Add new shared helpers (cap_family, meet_caps, caps_contain_family,
   is_write_verb, etc.) to `drop_decls` list in merge script
2. Ensure ck_ prefixes applied correctly to new Funcs fields
3. Regenerate `examples/driver.resid`
4. Verify driver compiles itself (`residc examples/driver.resid run examples/codegen.resid ...`)

### Phase 5: E2E Tests + Verification
1. Add all `bootstrap_sandbox_*` tests to `crates/residc/tests/e2e.rs`
2. Run individual tests first:
   `cargo test -p residc --test e2e -- bootstrap_sandbox`
3. Run all sandbox tests:
   `cargo test -p residc --test e2e -- run_sandbox`
4. Run all bootstrap tests:
   `cargo test -p residc --test e2e -- bootstrap_`
5. Full test suite: `cargo test` (817 tests, ~15 min)
6. Update PROGRESS.md

---

## 5. File Locations Reference

### Source files to modify
- `crates/residc/resid_rt.c` — add resid_eprintln C helper
- `examples/typecheck.resid` (4142 lines) — checker half
  - Funcs: line 3146 (DRes), need parallel sigs struct ~3100
  - collect_sigs_at: ~3252
  - check_params: 3148
  - check_func: 3184
  - graph-reduce sandbox rejection: 4072
- `examples/codegen.resid` (4436 lines) — codegen half (merge base)
  - Funcs: line 463
  - funcs_empty: 465
  - collect_sigs_at: 911
  - p_sym/p_rty/p_nargs: 2793-2844
  - cg_provider: 2846
  - pg_func: 4231
  - pg_next: 4272
  - hdr_core: 4418
- `tools/merge_driver.py` (179 lines) — merge recipe
- `crates/residc/tests/e2e.rs` — add bootstrap_sandbox_* tests

### Rust reference implementation
- `crates/resid-type/src/lib.rs`:
  - FunctionSig: 537-557 (requires line 553, sandbox_ceiling line 556)
  - Cap helpers: 608-669 (cap_family, cap_readonly, caps_contain_family,
    grant_readonly_only, is_write_verb, meet_caps)
  - FileCeiling: 567-587
  - effective_declared_ceiling: 591-606
  - provider_verbs: 488-498 (maps provider.verb → return type + cap family)
  - check_program_with E0212: 3857-3884
  - enforce_transitive_attenuation: 4131-4281
  - walk_spawn_cap_env (handle/value provenance): 4282-4400
- `crates/resid-codegen/src/lib.rs`:
  - lower_provider_call (cap_check emission): 3695-3786
  - lower_sandbox (cap_enter/leave): 3526-3693
  - emit_cap_enter helper: 590-636

### Target IR format (byte-identical for legal programs)
```llvm
@str = unnamed_addr constant [11 x i8] c"filesystem\00"
@str.1 = unnamed_addr constant [9 x i8] c"data.txt\00"
@str.2 = unnamed_addr constant [11 x i8] c"filesystem\00"

declare void @resid_cap_check(ptr)
declare void @resid_cap_enter(ptr, i64)
declare void @resid_cap_leave()

define i64 @read_demo() {
entry:
  %cap_set = alloca [1 x ptr], align 8
  %cap_slot = getelementptr inbounds [1 x ptr], ptr %cap_set, i32 0
  store ptr @str, ptr %cap_slot, align 8
  call void @resid_cap_enter(ptr %cap_set, i64 1)
  ...
  %resid_fs_read_all = call ptr @resid_fs_read_all(ptr @str.1)
  call void @resid_cap_check(ptr @str.2)
  ...
  call void @resid_cap_leave()
  ret i64 %call
}
```

Key details:
- cap_check comes AFTER provider call, BEFORE store result (Rust order)
- cap_check uses a SEPARATE fresh string constant per call site (not the cap_set one)
- cap_leave before EVERY return path
- cap_set is `[1 x ptr]` array alloca, getelementptr to slot 0
- String constants are `unnamed_addr constant` (NO `private` prefix for cap strings)

---

## 6. Risk Assessment

| Risk | Impact | Mitigation |
|---|---|---|
| stderr channel requires C runtime change | Blocks error parity | Add resid_eprintln in Phase 0 |
| Transitive attenuation fixpoint in Resid (no reassignment) | ~300-500 lines, hardest part | Recursive state struct pattern; bounded iterations |
| Byte-exact caret rendering in Resid | ~300-400 lines string manipulation | Start with file:line:col, add caret rendering iteratively |
| Funcs struct change ripples to all construction sites | 13 sites across both files | Mechanical; verify after each site update |
| merge_driver.py dedupe list grows | Must add cap helpers to drop_decls | Small, contained change |
| Residual call handling in driver typechecker | Driver may not support function-pointer calls | May need to add dynamic call detection during check_func body walk |
| Full test suite ~15 min per iteration | Slow iteration cycle | Run targeted subsets: `cargo test -p residc --test e2e -- bootstrap_sandbox` |

---

## 7. Estimated Size

| Phase | Lines (both files) | Complexity |
|---|---|---|
| Phase 0: stderr + error format | ~400 (resid_rt.c + codegen hdr + helpers) | Medium |
| Phase 1: Funcs + parsing | ~500 (typecheck + codegen) | Medium |
| Phase 2: Type checking enforcement | ~600 (typecheck.resid, mostly attenuation) | HIGH |
| Phase 3: Code generation | ~300 (codegen.resid) | Medium |
| Phase 4: merge + regeneration | ~30 (merge_driver.py + manual) | Low |
| Phase 5: E2E tests | ~200 (e2e.rs) | Low |
| **Total** | **~2000 lines** | |

Additional ~300-400 lines if full caret rendering is implemented.
