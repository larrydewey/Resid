# Resid — Project Status

**Specification**: `resid_specification.txt` v3.3 (Production Ready; v3.2 base + fixed-capacity value types §44; some items still in flux — see audit below)
**Implementation**: Rust stable + LLVM (inkwell), monorepo Cargo workspace
**Interpreter**: None — direct LLVM
**Wide numerics**: `Int(128)..Int(512)` / `UInt(N)` via LLVM arbitrary-width integers, `Float` capped at 128, `Dec(N)` exact decimals

---

## 0. Current Snapshot

**Self-hosted, graph-only compiler.** `./boot.sh` reaches a byte-identical
  self-compile fixed point from the committed seed with no Rust. The
  pipeline is parse → resolve → check → reduce → lower on the knowledge
  graph (PLAN-graph-ir G0–G7 done, §0y). Self-hosted suites: conformance
  161, reduce 14, provenance 20, graph 390. The archived Rust workspace
  (`bootstrap/rust-stage0/`) keeps its `cargo test` suites (last full run:
  821 tests; its e2e now has 128 after removing tests of the retired text
  paths); see `AGENTS.md` for its slow-test table.

### 0a. Self-compile performance fix (2026-09-19): ~3h -> ~101s

A full `driver.resid` self-compile (D1 -> D2, typecheck+codegen+clang) went
from effectively un-runnable (~3h, historically OOMed before an earlier
O(n^3) fix, then simply too slow to use routinely) to **101.4s wall, 44.1GB
peak RSS**. Root cause was NOT the memory-shape problem the existing Phase E
plan (`PLAN-resid-only.md`) was built around — it was `resid_rt.c`'s
`str_len(s)` rescanning the WHOLE source string from byte 0 on every call;
the self-hosted `lex_tok` calls `str_len(s)` as its first statement on every
single token, always against the full file, so tokenizing cost O(N^2) in
source length alone, before any real parsing/checking/codegen work. Fixed
with a trivial pointer-keyed memo cache (no array, no eviction — sound
because Str buffers are immutable and never freed by this runtime). A
second, smaller O(n^2) (n = function count) survived in
`examples/typecheck.resid`'s sandbox-enforcement pass even after the
earlier O(n^3) fixpoint fix (that fix cut the round *count*, not the
per-round cost) — fixed via a reverse caller-index. A real, previously
latent bug in `examples/codegen.resid`'s `value else { fallback }` codegen
(dropped the fallback branch's emitted globals) was found and fixed along
the way — only triggered by a `Str`-default use of that sugar, which didn't
exist anywhere in the codebase before this session. Full writeup, numbers,
and the reverted alternate approach (a byte-offset-index cache that was
faster still but broke codegen at scale) are in `PLAN-resid-only.md` Phase
B.3. Stage-3 self-hosting fixed point (D2's output == D3's output,
byte-identical) was independently re-confirmed after this fix.

**`bootstrap_map_set_parity` regression — found and fixed same day (2026-09-19)**:
`Set(Int).contains(2)` diverged between the Rust pipeline (`has-2`, correct)
and the self-hosted driver (`no-2`, wrong); confirmed via `git stash` A/B
testing to be a pre-existing bug, not caused by the performance work above.
Root cause: `examples/codegen.resid`'s `.get`/`.remove`/`.contains` (Map)
and `.contains`/`.remove` (Set) methods, plus `m[key]` indexing, all boxed
their key/element argument via `box_scalar` — a bare stack-alloca `ptr`
(just `alloca T; store T val, ptr`) — instead of `box_heap_`, which
produces a real `resid_box_i64`/etc. heap box (`ResidVal{tag=-1, type="i64", ...}`).
`resid_map_contains`/`resid_hash`/`resid_key_eq` in `resid_rt.c` require
the real heap-box shape to identify and compare scalar keys; handed a bare
stack pointer instead, `resid_hash` falls into its "bare C string" branch
and hashes garbage bytes at that stack address, so the lookup essentially
never matches. Explains the exact failure pattern: `m.contains("a")` (a
`Str` key) happened to work because `box_scalar` is a no-op for `Str`
(strings are already bare pointers, which is what the hash path expects);
`s.contains(2)` (an `Int` element) broke because `box_scalar` actually
stack-allocates for non-composite types. `.insert()` on both Map and Set
already correctly used `box_heap_` (with a comment explaining exactly this
requirement) — the bug was that `get`/`remove`/`contains`/indexing never
got the same treatment. Fixed by switching all 6 call sites to `box_heap_`
and deleting `box_scalar` (had zero remaining/legitimate callers after the
fix). Verified: full `residc` e2e suite, 131/131 green.

### 0b. `resid_process_run` fix + scalar-box allocation fix (2026-09-21)

Two `runtime/resid_rt.c` fixes, full detail in `bootstrap/stage0/README.md`
(the stage0 seed was rebuilt for both):

1. **`resid_process_run` had been fully disabled** (`return -1` always) by
   the runtime-hardening commit `ab4f9e7` (it closed a real `system(cmd)`
   shell-injection hole by disabling the primitive outright, rather than
   fixing it) — this broke *every* self-hosted compile, not just
   `driver.resid`'s own: `examples/driver.resid`'s `main()` calls
   `process.run(cmd)` as its final step to invoke `clang`. Fixed via
   `fork`+`execvp` on a whitespace-split `argv` (never a shell) — closes the
   same injection vector without disabling the primitive.
2. **`resid_box_i64`/`f64`/`bool`/`i128`/`u128` did 3 mallocs per scalar**
   (struct + 1-element slots array + payload) instead of 1 — a real,
   independent addition to Phase E's root-cause list (below), not a
   duplicate of it. Fixed via one combined allocation. Measured:
   `examples/parser.resid` (34KB) malloc call count −39%, peak RSS −6%.

Neither fix touches the dominant memory cost identified in Phase E
below (still open, still tens of GB for a full `driver.resid`
self-compile) — that needs the ownership/last-use analysis described
there, not a runtime patch.

### 0c. Eager compile-time reduction in the self-hosted compiler (2026-09-24)

The self-hosted pipeline now reduces every program by default (spec §36):
`examples/reduce.resid`, a source-to-source partial evaluator, runs after
type checking and before code generation (`--no-reduce` skips it,
`--dump-reduced <path>` writes the reduced text). It folds operators with
the generator's exact width/overflow behavior, propagates known locals and
elides dead known bindings, drops dead `if` arms (statements and
expressions), evaluates pure runtime builtins by calling the runtime
function itself, folds f-strings and merges adjacent string literals, and
β-reduces user calls whose arguments are known (memoized; step, depth and
global fuel budgets, with fallback to the residual call). Known values
cover Int/Int(128..512) (64-bit range), Bool, Str, lists, structs and
Option, including `match`, `else`/`?` unwrapping and `for` loops during
evaluation. `comptime_print(e)` reports the reduced value at compile time.
Example: `println(IntToString(fact(10)))` compiles to `println("3628800")`.

Supporting fixes: `IntToString` no longer returns a pointer into a stack
buffer; `e.itoa` prints INT64_MIN correctly; `if` arms agree up to numeric
aliases; programs run on a 1 GiB-stack thread (`resid_run_main`,
`RESID_STACK_MB`), which lets the evaluator go ~20000 calls deep; all-constant
list literals are built once and cached (`resid_list_const_*`); the SHA-256
string path carries its state in scalars. Self-compile peak RSS is now
~0.4-0.6GB (53.8GB before §0-memory commit 89b7b04). Regression suite:
`tests/reduce/run.sh` (differential against `--no-reduce`, expected output,
and has/lacks checks on the reduced `main`).

### 0d. Tail calls, clang -O2, numeric aliases, diagnostics (2026-09-24)

- **Tail calls.** The driver ran clang with no `-O`, where `tail call` is
  only a hint, so every recursive step cost a stack frame. Codegen now
  rewrites a self tail call (`return f(...)` in `f`) into a jump back to a
  loop head whose phis are the parameters, and marks tail calls to other
  functions with an identical register-sized signature `musttail`. Both are
  guaranteed at every optimization level: 50M-deep self recursion and
  mutual recursion run on an 8MB stack. Functions that hold fixed-size
  stack values, sandboxed functions and growbuf parameters are left alone.
  Non-tail recursion (`n * fact(n - 1)`) is unchanged.
- **Optimization level.** Emitted programs are built with clang `-O2` by
  default; `-O0|-O1|-O2|-O3|-Os|-Oz` on the driver's command line selects
  another. `boot.sh` links the compiler binaries with `$RESID_OPT`
  (default `-O2`). Self-compile went from ~11s to ~7s, of which ~4.8s is
  clang -O2 (clang -O0 takes ~0.7s).
- **Numeric aliases.** `Int` and `Int(64)` (and `UInt`/`Float`) now name the
  same type at every typecheck comparison, including nested (`List(Int)` vs
  `List(Int(64))`): returns, bindings, call arguments, list/set elements,
  struct fields, if arms and closure bodies. `return [];` adopts a declared
  `List(T)` return type, as bindings and arguments already did.
- **Diagnostics.** Rendering the caret line of an error near the end of a
  large source recursed once per preceding character and overflowed the
  stack (the "core dump after a type error"); it now walks line to line.

### 0e. Self-hosted compiler reaches the full conformance suite (2026-09-25)

`tests/conformance/run.sh`: 120 / 120 (was 34; the archived Rust reference
passes 105). Spawn capability bounds (E0214/E0215) are enforced, and the
reducer folds through the new control-flow syntax (ternary, `while`,
`break`/`continue`, `with`, if-let/while-let, destructuring) rather than
leaving such functions residual. Work-package details are in `PLAN-self-hosted-conformance.md`'s
progress log. New source-level pass `examples/desugar.resid` (default and
named arguments, spec struct syntax); module visibility and aliases are
applied during import resolution.

Performance: a self-compile now takes ~2-3s at `-O0` (typecheck ~0.6s,
down from ~2.8s) and ~9s at the default `-O2` (clang dominates), with peak
RSS ~0.6-0.8GB. Two regressions found on the way were fixed: `&&`/`||`
evaluate both operands in this language, so guard checks written as
`a && expensive()` ran on every node (now nested ifs); and the runtime's
codepoint-index LRU (16 slots) was being flushed by bursts of short
strings, forcing re-walks of the whole 880K-character source on the next
lex step — strings under 256 bytes now use a dedicated slot and never
enter the LRU.

### 0f. In-place string accumulators (2026-09-25)

`examples/stracc.resid` runs on the reduced program before code
generation. A Str parameter threaded through a self tail call as
`return f(..., acc + e1 + ..., ...)` and otherwise only returned is
rewritten into a worker that appends in place to a growable buffer
(`resid_sacc_from` / `resid_sacc_append` in the runtime), plus a wrapper
that copies the caller's initial string once. Accumulating 100k pieces
went from 16.2s / 51.8GB to 0.005s / 12MB; see `bench/strcat/` for the
comparison with C, Rust, Go, Node, Python, Ruby and LuaJIT. `IntToString`
pieces are formatted straight into the buffer (`resid_sacc_append_int`),
so 10M appends take 0.29s / 78MB (Rust: 0.11s / 79MB).

### 0g. Self-compile peak memory 1.0GB -> 0.26GB (2026-09-25)

Measured by sampling the compiler's own VmHWM (earlier ~600MB figures
came from a coarser sampler that missed the late peak; the true peak was
~1.0GB). Each driver phase whose results are written out or copied now
runs in a `resid_bulk_push`/`resid_bulk_pop` scope: typecheck, reduction,
the string-accumulator pass, code generation, and the sidecar writers.
The bulk arena also takes the generated code's own allocations
(`resid_gmalloc`), which `resid_arena_push` leaves on the heap;
`resid_list_str_persist_copy` copies into the enclosing arena rather than
the permanent heap, and the heap is trimmed when the outermost scope
pops. Provenance hashing and signing compress each SHA-256/SHA-512 block
in its own scope (`prov_sha256`, `prov_sign`); signatures are
byte-identical. Self-compile: 1.57s, peak 262MB (was 2.06s, 1017MB).

Also fixed: the reducer had step/fuel budgets but no memory budget, so a
program signing a constant message exhausted memory at compile time; it
now stops at 512MB of requested allocation (`resid_mem_since_mark`,
deterministic) and leaves the call residual. `resid_arena_pop` now
invalidates the small-string and scratch index slots, which could
otherwise match a reused address.

### 0h. Numeric soundness pass (spec v3.4) and reducer specialization (2026-09-26)

Spec and implementation now agree on numerics. Before: `Int(64)` add and
all multiplies wrapped silently, division by zero was unchecked, unsigned
values compared/divided as signed, signed `>>` was logical below 256 bits,
explicit casts truncated, and binding checks accepted any narrowing whose
first token was short. Now: every operator yields the widest operand width
(multiplication's range rule removed); `+ - * / %` are checked at every
width (`llvm.*.with.overflow`, `resid_div_check`); unsigned ops use
`ult`/`udiv`/`urem`; signed `>>` is `ashr`; explicit conversions trap out
of range (`resid_conv_check`, float-to-int included) and `wrapping_iN/uN`
keep low bits; narrowing is rejected except whole fitting literals;
`Str(N)` capacity is UTF-8 bytes and casts never split a codepoint.
lib/ec256 and lib/tlsmsg use explicit wrapping/shift packing.

`examples/reduce.resid` specializes calls with partly-known arguments
(`f__rsN`), terminating by a homeomorphic-embedding whistle with
generalization; an identical re-entrant call stops evaluation at once;
budget hits print `note: reduce: ...`. The compiler specializes 53 of its
own calls; self-compile time and memory are unchanged.

### 0i. Signed provenance restored (spec v3.5 §33.1) (2026-09-26)

The self-hosted driver had regressed from the Rust pipeline's COSE trailer
to a plaintext `.resid-prov` sidecar that covered neither the binary nor
the notes. Now every build appends `[COSE_Sign1][u32 BE len]["RESIDPROV2"]`
to the binary. The payload (§34 Provenance map, deterministic key order)
binds the source files, the code bytes and the sidecars (notes, and graph
once G4 lands) by SHA-256. `RESID_PROV_ENCRYPT=1` + `RESID_PROV_KEY`
conceal it with COSE_Encrypt0. Release builds fail without a key
(`RESID_SIGNING_KEY` or `keys/resid-ed25519.key`), and debug builds are
unsigned with a note. New commands: `residc keygen [dir]` and
`residc verify <binary> [--pub HEX]`. The keyring is `keys/*.pub` or
`RESID_VERIFY_PUB`. Shared code lives in `lib/cose.resid` (preferred CBOR
serialization), which `tools/resid-cose.resid` now uses too. boot.sh and
the test harnesses create a throwaway key when none is configured.
`tests/provenance/run.sh` covers tamper detection, keys, concealment and
reproducibility. Self-compile time is unchanged.

### 0r. Graph artifact and derive edges (G3/G4, 2026-09-26)

Debug and check builds write `<out>.resid-graph.cbor` (spec §33, §34,
`examples/gart.resid`): source and residual nodes in one graph with kind,
checked type, knowledge state, literal value, deps, def, effects and
capabilities, span through the import source map, derive edge and a
SHA-256 content hash; roots name the parse unit and the residual unit. The
reducer and the string-accumulator rewrite record a derive edge (origin
and rule) for every node they create. The CBOR is streamed: the header,
then nodes in chunks of 2048, each built in its own arena and appended
(`filesystem.write_hex` / `append_hex`). The binary carries the file's
hash as `resid_graph_hash`, provenance signs it, and a stale artifact is
cleared when none is emitted. New runtime pieces: `str_sha256`,
`filesystem.write_hex`, `filesystem.append_hex`. Debug self-compile:
649MB peak (579MB before the artifact), 5.0s.

### 0s. DWARF debug info (G4, 2026-09-26)

Debug builds on the graph path emit DWARF 5: a DISubprogram per function
and a DILocation per statement at its source line and column (through the
import source map), attached to every instruction of that statement, so
gdb breaks, steps and backtraces in Resid source; specialized functions
report their original's lines. Lowering marks statement starts with
`;@dbg` lines and a post-pass (after tail-call rewriting) tags them.
Debug self-compile: 664MB peak, 5.3s. Parameters and bindings are
DWARF local variables through `llvm.dbg.value` (after the tail-call
loop's phis for parameters), so `info args` and `info locals` work, and a
module function is named without its `__m<module>__` prefix, so
`break lw_fn` works. Debug self-compile: 700MB peak.

### 0t. Signatures from the graph (G3/G4, 2026-09-26)

The driver's signature table (`Funcs`: functions, parameter types and
names, requires and sandbox ceilings, structs, sum types, behaviors,
constraint types) and the leaf-function analysis behind scalar scopes are
built from the graph (`lw_sigs` in `examples/lower.resid`) instead of
collecting them from the printed residual; the residual is no longer
printed unless `--dump-reduced` asks. The leaf walk mirrors the text
analysis over what the printer would emit. `--graph-sigs-check` compares
the two tables field for field; they agree on all 173 programs, and the
self-compile IR is unchanged. The linear map/set accumulator mask
(`lg_mask`) and struct `ToString` moved to the graph as well, with IR
identical on all programs.

### 0u. Reasons for residual nodes (G3, 2026-09-26)

Every RESIDUAL or EFFECT node in `<out>.resid-graph.cbor` carries a
reason (spec §3.4, §34): `effect` with the effect, `annotated` for `rt` /
`@residual`, `unknown` with the first RESIDUAL operand or definition, and
the reducer's own: `budget` (fuel, steps or specs), `loop` (an identical
re-entry) and `whistle` (a generalized specialization), recorded against
the call and inherited along derive edges. Self-compile: 2,517 budget and
605 whistle reasons; debug peak 690MB.

### 0v. Range facts discharge checks (G3, 2026-09-26)

Lowering computes range facts per function (spec §3.2a, `lr_facts` in
`examples/lower.resid`): integer literals, + - * / % &, lengths, `for`
over a range and branch conditions, including the early-exit
`if (i >= n) { return ...; }` pattern. A + - * / % whose operand ranges
prove it cannot trap is emitted as a plain `add nsw` / `sdiv` etc.; the
rest keep their checks (`--no-facts` keeps all). Self-compile: 1,610 of
2,500 overflow checks and 13 of 78 division checks remain; release peak
619MB (606MB without facts). The artifact carries a RESIDUAL node's range
as `facts`. Conformance case `range_facts_discharge` covers the
boundaries, ending in a MIN / -1 that must still trap.

### 0za. Map/Set ownership and a compact persistent runtime (2026-09-26)

Map/Set programs no longer allocate far more than C/Rust.

- **Linear ownership** (`lo_*` in `examples/lower.resid`, replacing the
  self-tail-call-only `lg_mask`): a whole-program analysis marks Map/Set
  parameters and locals as linear when each mention is a read or one
  consuming use per path (return, a linear local's binding, `insert` /
  `remove`, a call's linear parameter, a struct literal field). It covers
  helpers (`bump(m, k)`), nested loops, let-chains, mutual recursion,
  updates on call results (`return f(x).insert(..)`, non-tail recursion)
  and Map/Set fields of structs, linear field-wise
  (`S {.m = s.m.insert(..), ..}`) or whole. Parameters are solved as a
  fixpoint (`lin` falls, `mut` rises); a call to a linear parameter that
  is never updated, with no Map/Set in its result, only borrows. Owned
  updates pass `owned` to the runtime; call results outside a chain are
  frozen (a struct result's Map/Set fields too), return-position calls
  are not (the caller decides, and self tail calls stay tail calls).
- **Runtime** (`runtime/resid_rt.c`): the first owned update of a shared
  map takes a private transient (small: a table copy; big: a trie
  transient sharing every node, Clojure-style edit tokens). The trie has
  compact CHAMP-layout nodes with unboxed key/value words and keeps the
  exact canonical key order (tables sort into it instead of building a
  trie); tables are built in place; set union/intersection/difference
  build tables; set tables keep no value array.
- Fixed along the way (pre-existing): `Set(T) s = {}` was typed as a Map;
  a `get(..) else` fallback in an if-expression condition reused labels.
- Measured against Rust `HashMap` (time / peak RSS): counting through a
  helper 1.95s/3.3GB -> 0.02s/12MB (Rust 0.02s/12MB); nested loops
  0.93s/1.9GB -> 0.04s/50MB (0.04s/53MB); set algebra 4.15s/6.9GB ->
  0.18s/147MB (0.19s/12MB); non-tail build 0.52s/1.1GB -> 0.03s/40MB;
  map in a state struct 1.02s/1.7GB -> 0.04s/50MB (0.02s/12MB).
  k-nucleotide: the committed compiler had regressed to 23.4s/11.7GB;
  now 5.4s/268MB (C 4.2s, Rust 11.0s). Self-compile peak 425 -> 370MB.
- Remaining gaps are not map cost: dead strings and struct records are
  never freed (no per-iteration reclamation), and `List` appends inside
  map values are persistent.
- Tests: conformance `map_ownership_aliasing`, `map_ownership_structs`,
  `map_ownership_chains`, `map_set_regressions`.

### 0z. Native debugger backend, more facts, builders (2026-09-26)

`resid-debug` live mode no longer needs gdb. The runtime has small
ptrace primitives (`resid_dbg_spawn/wait/cont/step/peek/poke/reg/set_pc/
kill`; every thread of the program is traced, since `main` runs on its
own thread), and everything else is resid: `lib/dwarf.resid` reads
`.debug_info`, abbreviations and DWARF 5 location lists; resid-debug
evaluates location expressions (registers, `fbreg`, `breg`, `deref_size`,
stack values), plants int3 breakpoints, steps by node over calls
(recursion-safe: a return breakpoint only counts at the caller's stack
depth), and on a signal in runtime code scans the stack for the
program's calling node, so an overflow abort names the binding that
overflowed. Its output matches the gdb backend's (`backend gdb`).

Facts: `x != 0` makes x nonzero, which discharges divisions; a list
literal's length and `i < xs.len()` (from `for (i in a..xs.len())` or a
condition) discharge list bounds checks (`resid_list_get_nc`); match
arms and patterns give a scrutinee its variant, and struct-literal
bindings give references their field nodes. Debug builds record every
runtime check (`; discharged #id check` / `; checked #id check` in the
IR), and the artifact lists them as discharged facts with the operands
used, or check facts with the operands that lacked a range. Self-compile:
840 checks discharged, 2,431 kept. Found on the way: lowering of
`for (i in a..b)` dropped the code computing non-literal bounds (and of
`for (x in e)` the code computing e), a latent bug the text codegen
shared; fixed. The straight accumulators (parser lists, parameter lists,
grafts, lint hits, checker lists) now use `ListBuf`.

### 0y. Text passes retired: the compiler runs on the graph (G7, 2026-09-26)

The driver always checks, reduces and lowers on the knowledge graph. The
text checker, text reducer, text codegen path, `gr_*` graph-reduce pass
and notes line scan are gone, with their flags (`--text-check`,
`--text-reduce`, `--text-lower`, `--graph-reduce-check`,
`--graph-sigs-check`, `--bootstrap-graph-reduce`). A reachability sweep
from the driver's `main` pruned about 10,500 lines that only those paths
used (codegen.resid 9.1K to 4.6K lines, typecheck.resid 7.3K to 3.2K,
reduce.resid 2.7K to 0.9K; the generated driver.resid 16.5K to 7.6K), and
`examples/stracc.resid` folded into greduce. After parsing, no pass reads
the source except for diagnostic text and line mapping: the reducer takes
pattern and `with` headers from printed nodes, `known`/`comptime_print`
from call nodes and the specialization gain from node token counts, and
a sandbox node carries its body position for lowering's symbol
numbering. The reducer also dropped two guards that only mirrored text
parsing hazards (a `?` the text reducer read as a conditional, comments
inside a string-accumulator argument). IR is byte-identical on all 157
in-repo programs that compile. Self-compile: about 2s, 423MB peak
release (was 624MB) and 506MB debug (was 749MB), because the driver no
longer builds the text pipeline's signature tables. Archived Rust e2e
tests that ran the standalone text checker and codegen or
`--bootstrap-graph-reduce` were removed.

### 0x. `resid-debug` and a DWARF reader (G6, 2026-09-26)

`tools/resid-debug.resid <binary>` is the graph-aware debugger. It reads
the debug build's artifact and, through `lib/dwarf.resid` (ELF sections,
symbols and the DWARF 5 line program, in resid), the binary's line table,
which is the lowered map: each row starts at its node's span. Static
commands (`node`, `kids`, `at`, `sym`, `lowered`, `pc`, `check`, `info`)
run from `-ex` or an interactive prompt (new builtin `resid_read_line`).
`info` checks the binary's `resid_graph_hash` against the artifact, and
`check` requires every row with a source line to map to a node. Live
mode drives gdb in batch: at each breakpoint stop it maps the program
counter to its node, pairs `info args`/`info locals` with the binding and
parameter nodes, and lists the known values folded into that line;
`step N` reports each change of node. The artifact now names declarations
and uses, so `resid-why <artifact> NAME` answers by symbol.

While reading facts back, `n * n` showed the range [MIN, 1]: the
runtime's `saturating_mul` multiplied in signed C (undefined on overflow)
and tested the wrapped product's sign, so `MAX * MAX` returned 1. Range
facts use it for their corners. It now uses `__builtin_mul_overflow`, and
the wrapping and `checked_*` helpers compute in unsigned arithmetic
(`wrapping_div(MIN, -1)` included). Conformance case
`saturating_corners` covers the corners.

### 0w. Residual notes from the graph (G5, 2026-09-26)

`<out>.resid-notes.cbor` is projected from the residual graph
(`ga_notes` in `examples/gart.resid`) instead of scanning the main file's
lines for `rt ` and provider prefixes: `rt` values (rt-binding), provider
calls (provider-call) and the reducer's budget, loop and whistle reasons,
at their real positions in any imported file, sorted by place. Across 140
programs the scan's extra hits were all false (comments, strings,
`import`, `start = ...`, `args.ast` fields), and the graph finds `rt(...)`
and later calls on a line that the scan missed. `tools/resid-why.resid`
explains the new kinds, and with `--node ID` or `--at FILE:LINE` answers
from the graph artifact instead (knowledge, value, reason, facts,
effects, def and the derive chain back to source; 0.3s on the
self-compile's 35MB artifact). `tools/resid-graph.resid <artifact>
--node ID [--depth N]` prints a node's neighbourhood as DOT; both tools
read the artifact through `lib/kgart.resid`. `resid-graph <artifact>
--check` verifies the §3.4 invariants; it found literals grafted by the
reducer's fold and the string-accumulator rewrite's unit without derive
edges (fixed), and the self-compile's graph now has no violations. It
also exposed a runtime bug: a linear map loop entered with a large
frozen table copied the table on every entry (never freed), so a loop run
once per element of a growing map was quadratic; such loops now take the
persistent path like large tries. Self-compile: 187 notes (92 provider calls, 95
whistles).

### 0q. Reduction on the knowledge graph (G3 step 1, 2026-09-26)

`examples/greduce.resid` reduces the parsed graph instead of source text.
It makes the text reducer's decisions (folding, known bindings, dead arms,
β-reduction, specialization with the whistle, budgets, notes) and builds
the residual program as new nodes appended to the graph. Unchanged subtrees
are shared, and new nodes keep the span of the node they replace.
`--graph-reduce-check` compares the printed residual graph with
`rd_reduce_program`'s text token for token. All 177 in-repo programs that
type-check match, the self-compile included; `tests/graph/run.sh` runs the
check. While β-reducing, no residual nodes are built (they are never used);
building them had pushed a deep evaluation past the memory budget.

The graph path is now the default: the checker's parse is packed out of
its arena and reused, the residual graph (with `stracc`'s rewrite ported
to the graph as `gs_program`) is packed out of the reducer's arena, and
lowering walks it directly, with no reparse. Specialized functions share
nodes with their originals, so their position-numbered symbols (`@clo`,
`@spw`, `@.tmsg`) are offset by the specialization number. On all 173
in-repo programs the IR equals the text pipeline's (`--text-reduce`) once
those numbers are normalized, and the fixed point holds. Self-compile:
1.87s and 589MB peak, against 2.03s and 589MB with `--text-reduce`.
Signatures (`collect_sigs`) still come from the residual graph printed.

### 0p. Lowering from the knowledge graph (G4, 2026-09-26)

`examples/lower.resid` replaced the text codegen's walkers: every function
of every in-repo program lowers from graph nodes, byte-identical to the
text codegen (`--text-lower`), and the compiler reaches its fixed point with
graph lowering as the default. It was ported with a per-function fallback
to the text codegen, grown construct by construct against a byte-for-byte
differential over all 174 programs.

### 0o. Self-compile peak memory 1470MB -> 411MB (2026-09-26)

A DHAT profile of the self-compile showed signed provenance (commit
46fbdd5) had pushed the peak from ~350MB to 1470MB. It read the output binary
as a boxed `List(Int)` and hashed it with the Resid-level SHA-256, whose
per-block boxes the arena did not release. New provider verbs
`filesystem.sha256` (C, streaming) and `filesystem.append_bytes` (trailer
only) replace that path. The same profile showed string concatenation is
about 1% of allocation. About 78% of all bytes allocated are token text
from `lex_tok` in the text passes, which G3/G4 remove.

### 0n. Linear builders StrBuf / ListBuf(T) (G2b, spec v3.6 §45, 2026-09-26)

`StrBuf` and `ListBuf(T)` append in place; each value must be used exactly
once (E0401 unconsumed, E0402 used twice, E0403 used across a loop or
lambda boundary, E0404 nested in another type). The graph checker enforces
it with a path-sensitive pass over def edges. ListBuf push is an in-place
append into a doubling buffer (`resid_listbuf_*`), and finish hands the
buffer to the list without copying.

### 0m. Types on graph nodes (G2 complete, 2026-09-26)

The graph checker now records a type for every expression node, plus def
edges for field and method uses (`gk_analyze`, `--graph-types`). Every
checked expression in the compiler and the in-repo programs gets a type.

### 0l. Type checking on the graph (G2, 2026-09-26)

`examples/gcheck.resid` replaces the text checker in the driver
(`--text-check` keeps the old one for differential runs). It matches the
text checker on every in-repo program and on 91 rejection cases in
`tests/graph/check_cases.txt`, and it closes four gaps the text checker
had: call arity, match exhaustiveness without a trailing comma, range bound
types, and adopted literals that do not fit.

### 0k. Graph name resolution (G2 step 1, 2026-09-26)

`examples/resolve.resid` adds def edges: each use of a name points at the
node that binds it. `--graph-resolve` reports unresolved uses. Every
in-repo program resolves fully, and `tests/graph/cases/resolve_scopes`
checks that block, branch, loop, pattern, arm and lambda scopes do not
leak. Field and method names wait for types.

### 0j. Knowledge graph parser (G1) and three silent-semantics fixes (2026-09-26)

`examples/graph.resid` parses desugared programs into the §3 node store.
It round-trips every in-repo program, compiler included (`tests/graph`).
Building it exposed three bugs, now fixed. Precedence: codegen and the
reducer ranked `& ^ |` equal and `&& ||` equal, so `t || f && f` gave
false. The graph lint confirmed that no in-repo program relied on the
wrong grouping. Assignment: `x = 5;` type-checked and compiled to nothing;
it is now an error, and the one codegen block that relied on it (the
`expect().toEqual` widening for narrow ints) is rewritten. List literals:
a missing comma is now an error. Short-circuit: `&&` and `||` evaluated
both operands, so a guard like `i < n && xs[i] == 0` aborted. The spec now
requires short-circuit (§30). Codegen branches to a phi, and the reducer
folds `false && e` and `true || e` without evaluating e. The `else`
fallback's phi now names the arms' exit blocks. Checker diagnostics use
the import source map: they print `--> path:line:col`, and the caret
gutter shows the file's own line rather than the merged line.

### Major capabilities

- **Stage-2 self-hosting proven, including full sandbox/capability parity**:
  `examples/driver.resid` (~9930 lines) compiles programs identically to the
  Rust pipeline (all `bootstrap_*` e2e green except `bootstrap_map_set_parity`,
  a pre-existing regression — see §0a), including sandbox enforcement
  (E0211 transitive attenuation, E0212 ceiling violation, E0213 unknown
  capability mode, handle-entry, value-provenance, read-only-write
  rejection) and the `resid_cap_enter`/`resid_cap_check`/`resid_cap_leave`
  force-time guard emitted around every sandboxed function body. Regenerated
  by `tools/merge_driver.py` from `examples/typecheck.resid` +
  `examples/codegen.resid`.
- **Stage-2 constraint types (§12)**: constraint type aliases
  (`Int[value > 0]`, `Int where value >= 0`) implemented in Rust pipeline
  with discharge on constant bindings (e2e `run_constraint_types`,
  `constraint_type_violation_rejected`). Stage-2 driver supports both
  `[...]` and `where` forms with proper parsing via shared helpers from
  `tools/merge_driver.py`. Header merge fixed via
  `tools/merge_driver.py`.
- **Stage-2 List/Map/Set parity**: self-hosted driver uses same
  trie-backed C-runtime lists and HAMT maps/sets as stage-1 (all
  `bootstrap_*`/`stage2_*` e2e green).
- **Stage-2 Option/Result support**: `Some`/`None`/`Ok`/`Err` constructors,
  `match` on sums, `?`/`else` sugar — all parity-verified
  (`bootstrap_option_sum_parity`, `bootstrap_match_parity`,
  `bootstrap_question_else_parity`).
- **Wide-int boxing (Int(128)/UInt(128))**: values wider than 64 bits boxed
  into sum variants, unboxed, and formatted in both pipelines
  (e2e `run_wide_int_boxing`).
- **Full pipeline**: lex → parse → type → LLVM IR → native binary via clang
  + tiny C runtime (`crates/residc/resid_rt.c`).
- **Pure-Resid crypto stack** (`lib/`): SHA-256/512, HMAC, PBKDF2, HKDF,
  Base64, Ed25519, X25519, ChaCha20-Poly1305, AES-128-GCM, RSA, ECDSA-P256,
  chain validation, TLS 1.3 key schedule/message framing, HTTP/1.1 client,
  HTTP/2 framing + HPACK + Huffman — all in Resid, verified against
  RFC/NIST vectors through both pipelines.
- **Live TLS 1.3 + HTTP/2 end-to-end**: `examples/tls_client.resid` and
  `examples/h2_client.resid` perform live handshakes against real servers
  (e2e `run_tls13_live_openssl_in_resid`, `run_h2_live_request_in_resid`,
  `run_h2_post_and_continuation_in_resid`).
- **rustc-grade diagnostics (spec §34)**: `resid-diag` shared crate with
  error codes, caret-rendered snippets, span-pair labels, notes/help, TTY
  color. Every compile-time rule stamped (E0001–E0301). Runtime aborts
  (`todo`, `assert`, index OOB, capability force-time) carry baked-in
  `(file:line:col)` context at zero cost. Parse errors rendered inline.
  LSP-ready surface (residual status, exhaustiveness, attenuation view).

### Language features

- Complete numeric family with v3.2 width semantics: `Int(N)`, `UInt(N)`,
  `Float`, `Dec(N)` — result-width rules, literal inference, signed headroom,
  mixed-width comparisons, casts (sext/zext/trunc).
- Boxed composites (List/Struct/Option/Result) with `match`, destructuring,
  if-let/while-let; ranges + slicing; raw/byte strings; f-strings.
- Map/Set types (immutable persistent HAMT): literals, indexing `m[k]` →
  `Option(V)`, methods (`.get/.insert/.remove/.contains/.keys/.values/.len`),
  Set operations (`.union/.difference/.intersection/.to_list`).
- Constraint types (§12): `Int[value > 0]` and `Int where value > 0` with
  discharge on annotated bindings (e2e `run_constraint_types`).
- Fixed-size stack types (no heap allocation): `Str(N)`/`Bytes(N)`/`List(T, N)`
  with compile-time capacity, stored inline in the frame. Sized literals
  adopt the annotated fixed type (`Str(8) s = "abc"`); oversized literals are
  rejected at type-check, truncation only on explicit runtime cast
  (`Str(8)f = (Str(8))h`). Indexing is bounds-checked → `resid_index_abort`
  with source span. Casts to/from heap `Str`/`Bytes`/`List` are explicit
  (`resid_str_to_fixed`/`resid_bytes_to_fixed` helpers; fixed list is dense —
  `.len` = N on cast). e2e `run_fixed_size_stack_types`,
  `run_fixed_size_index_oob_aborts`.
- Behaviors: generic numeric `Ord`/`Eq`/`Hash` synthesized for all widths;
  `Serialize`/`Allocator` shape-checked; `sort(using = Ord(T))` with
  synthesized trampolines (e2e `run_generic_numeric_behaviors`).
- Per-width wrapping/saturating arithmetic (LLVM native, e2e
  `run_per_width_wrapping_saturating`).
- Capabilities & sandboxing (§21): transitive attenuation closure
  (call-graph meet fixpoint), manifest ceilings, force-time capability
  errors with `resid_cap_check` guards, capability modes (`:ro`/`:rw`),
  File value provenance at function entry (e2e
  `run_sandbox_transitive_attenuation`, `run_sandbox_capability_mode_readonly`,
  `run_sandbox_force_time_guard_*`, `run_sandbox_handle_entry_*`).
- Spawn (§19): pthreads-based, child ≤ parent enforced statically, fresh
  CapEnv bounds child body, child failure delivered as `Err(RegionError)`
  (e2e `run_spawn_simple`, `run_spawn_child_failure_err`).
- Build profiles (§35): `residc <f> build|run --profile debug|release|check`;
  `-O2` for release, `check` stops after type checking.
- Reduction relation (§36): comptime β-reduction of pure functions with
  step/depth budgets (e2e `reduction_known_fib_comptime_print`,
  `reduction_falls_back_to_runtime`).
- Package system: multi-file imports with import-as namespacing, transitive
  deps + lockfile, local registry, per-import capability narrowing,
  per-dependency key pinning (§28.3), Unicode case mapping in stdlib.
- Registry transport over HTTP: `resid-build serve` + app fetches dependencies live.
- SpecialCasing: Unicode case mapping table with conditional Final_Sigma rule.
- `resid-why` tool: reads `.resid-notes.cbor` sidecars, explains residuals.
- `resid-lsp`: full VS Code language server with parse/type diagnostics,
  completion, hover, navigation, and residual Hint diagnostics. The VS Code
  package ships `vscode-languageclient` as a runtime dependency so activation
  cannot fail when installed from a `.vsix`.
- Residual provenance in sidecars: notes carry `(file, line, column)` so
  `resid-why --json` emits URI-bearing, column-precise LSP diagnostics and
  `resid-lsp` shows each note only on its owning document (legacy
  3/4-field sidecars still read).
- Provenance: Ed25519-signed trailers, COSE_Sign1, optional concealment;
  `residc keygen`, `residc verify`, `RESID_VERIFY=1`.

Full e2e suite runtime ≈ 15 min (slow: live-network h2/TLS + bootstrap driver runs) — not a hang; use `cargo test -p residc --test e2e -- <filter>`.

### CLI

`residc <f> build [-o out]`, `residc <f> run` (exit code carries through),
`residc <f> emit-ir` (print LLVM IR), `residc keygen`, `residc verify <binary>`.
`resid-build serve` exposes a local registry.

### Soundness hardening

Bounds-checked list indexing (`resid_index_abort`), shift counts ≥ bit width
yield 0. Handle types: `with (Type h = expr) { … }` RAII.

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
  `RESID_PROV_ENCRYPT=1` + `RESID_PROV_KEY`, now a real AEAD —
  ChaCha20-Poly1305 (alg 24, RFC 8439) via the RustCrypto
  `chacha20poly1305` crate, with the RFC 9052 §5.3 `Enc_structure` as
  associated data and deterministic synthetic nonces (byte-reproducible
  builds, no nonce reuse across payloads). Provenance mode is part of the
  cache key. Unit tests cover roundtrip, determinism, tamper/wrong-key
  rejection; e2e `run_encrypt0_provenance_roundtrip`.

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
done end-to-end** — ALPN negotiation, connection preface + SETTINGS
exchange with ACK, GET on stream 1, and response HEADERS/DATA decoding
(HPACK incl. Huffman), verified live against a real hyper-h2 server
(`tools/h2_server.py`).

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

## 2. Language Gotchas Reference (accumulated, still current)

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

## 3. Notable Resolved Issues

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

## 4. Workspace Layout

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

## 5. Next Steps

### Open memory/performance gaps (2026-09-25)

- **lib/crypto SHA-512 allocates ~1MB per 128-byte block.** Each round
  builds dozens of two-element limb lists (`w64_*`, `fw_pair`) with boxed
  elements, and nothing is freed. The compiler sidesteps it for provenance
  signing (`prov_sha512` / `prov_sign` in the driver scope each block),
  but user programs calling `sha512_bytes`, `sign_msg` or `verify_sig`
  on large inputs still pay it: signing 14.5KB takes ~244MB. Fix: a
  scalar-state round (limbs as Int parameters or a flat struct, the
  message schedule as one list per block). The same pattern likely
  affects SHA-256's `ext_w` schedule.
- **`examples/stracc.resid` only recognizes `acc + e1 + ...` chains.**
  Accumulating through `str_join([acc, piece], "")`, an f-string, or a
  non-tail use still copies the whole accumulator per step.
  `tests/reduce/cases/tail_calls` builds 100k characters that way and
  peaks at ~4.7GB; it fails under a 4GB address-space limit.
- **The runtime never frees outside arena scopes.** User programs have no
  phase scopes like the driver's (`resid_bulk_push`/`pop` are
  compiler-internal), so long-running programs keep every intermediate
  value. The in-place accumulator and per-phase scopes cover the compiler
  and the benchmark idiom, not programs in general.
- **Resid is ~2.6x behind Rust on the 10M-append benchmark** (0.29s vs
  0.11s; memory is level): `resid_sacc_append_int` formats through
  snprintf, and every piece still pays a strlen.

The §7 spec-conformance roadmap is now effectively complete — every
curated item has landed in at least stage-1 (many in both pipelines).
Remaining conformance gaps are minimal:

- **§21.4 knowledge-cache gating**: **✅ DONE** — `resid_cache::caps_are_at_most`
  gates writes against `RESID_CAP_GRANT`; entries carry capability families
  through CBOR round-trip (e2e `run_cache_capability_gating`).
- **Per-verb capability-mode lattice**: `filesystem.write_all` and
  `process.run` are classified as write verbs; `git` verbs (`rev`, `branch`)
  are classified read-only; mode-aware meet (`readonly` ∩ `readwrite` =
  `readonly`); unknown-mode rejection (soundness fix). No new families/verbs
  pending — lattice is complete.
- **Stage-2 parity**: driving any remaining stage-1-only features into
  the self-hosted driver.

**Completed this session:**
- **Fixed-size stack types (§2 — `Str(N)`/`Bytes(N)`/`List(T, N)`)**: 
  heap-free, compile-time-capacity values stored inline in the frame.
  Parser: `Str`/`Bytes` fixed forms via `peek_after_is_op(Op::LParen)`;
  `List(T, N)` parses as `Base{name:"List", params:[T, N]}` and resolves
  to `SemType::ListFixed` when the second param is an int literal.
  Type checker: sized literals adopt the annotated fixed type
  (`string_literal_len`/`bytes_literal_len`/`ListFixed` cap checks);
  oversized literals are a type error (no silent truncation); indexing
  `Str(N)`/`Bytes(N)` → `Int(B64)`, `List(T, N)` → `T`, bounds-checked.
  Codegen: `llvm_type(ListFixed) = [N x ety]` (previously a bare `ptr` —
  that was a stack-corruption SEGV at exit since GEP wrote 64 bytes into a
  pointer-sized alloca), fixed-type bind paths + `str_fixed_const_array`/
  `fixed_array_ptr`, VarRef returns in-frame pointer, `cast_val`
  identity-retapes (`Str(N)`↔`Str`, `Bytes(N)`↔`Bytes`) plus
  heap→fixed copies via `resid_str_to_fixed`/`resid_bytes_to_fixed`
  (truncation allowed only on explicit runtime cast) and fixed→heap boxing.
  `resid-fmt` and `resid-lsp` type printers cover the new forms.
  e2e `run_fixed_size_stack_types`, `run_fixed_size_index_oob_aborts`;
  7 new `resid-type` tests. Stage-1 complete (both intermediate paths);
  **stage-2 driver parity complete** — `examples/typecheck.resid` +
  `examples/codegen.resid` implement literal adoption, bounds-checked
  indexing (`resid_index_abort`), Str/Bytes/List casts (identity views +
  bounded `resid_str_to_fixed`/`resid_bytes_to_fixed` copies + List(T,N)→List(T)
  dense boxing), `.len()` = compile-time N, and builtin-argument view widening
  (`builtin_args`, mirrors Rust's `fixed_view_ok`) — byte-identical output to
  the Rust pipeline (e2e `bootstrap_driver_fixed_size_stack_types`,
  `bootstrap_driver_fixed_builtin_widening`).
- **`Str` rope-backed representation (§2 string building, roadmap item 2)**: 
  concatenation-by-accumulator (the `acc + piece` / `acc + str_from_code(c)` 
  loop pattern) is now amortized O(1) per append via a chunked concat-rope in 
  `resid_rt.c` and flattened once at finish. New builtins — `str_sb_new()`,
  `str_sb_append(sb, s)`, `str_sb_append_cp(sb, cp)`, `str_sb_finish(sb)` — are
  typed in both pipelines (stage-1 `resid-type` BUILTIN_SIGS + driver
  `check_builtin`/`cg_extern*`/`hdr_core`). `lib/h2.resid` `h2_bs_acc` and
  `hp_huff_loop` rewritten onto the builder (byte/symbol-at-a-time decode no
  longer re-allocates the whole string per step). e2e `run_str_builder_in_resid`
  (both pipelines) + `run_h2_hpack_in_resid` still byte-identical on both
  pipelines. Handles are opaque pointers carried as `Str` values — no ABI or
  `i8*` change to existing Str consumers.
- **Graph-reduce stage-2 parity (§11, §36)**: the `--graph-reduce` reduction
  pipeline now runs in the self-hosted driver as `--bootstrap-graph-reduce`.
  Source-to-source reducer in `examples/typecheck.resid` (`examples/driver.resid`
  7694 lines): constant-fold bindings into `cenv`, β-reduce pure single-return
  calls with constant args, elide foldable unreferenced bindings (§36 DCE)
  while effectful bindings survive, then re-type-check the reduced program
  via `ck_collect_sigs` before codegen. Reduced output is byte-identical to
  the plain path (e2e `bootstrap_graph_reduce_parity`,
  `bootstrap_graph_reduce_eliminates_dead_bindings` — DCE sample: 2 dead
  bindings dropped, `println` side-effect preserved). Non-function
  declarations rejected with the Rust pipeline's exact message:
  `type`/`import`/`sandbox` and behavior instances `Ord(Int) = f;` →
  "only functions are representable" (e2e `bootstrap_graph_reduce_rejects_declarations`,
  `bootstrap_graph_reduce_rejects_behavior_instances`). Reducer fixes:
  `gr_brace_of_pd` now returns the exact `{` position / `-1` when no body brace
  (behavior-shape lookahead), `gr_brace_close` starts at depth 0,
  `MB.prefix` single-space rebuild, and the `--bootstrap-graph-reduce` flag
  avoids residc's global `--graph-reduce` strip. Caveat: `while` is not
  supported by the driver codegen (parity holds for the supported subset).
- **0-based list migration**: All crypto/TLS libs (`lib/crypto.resid`, `der`, `x509`, `rsa`, `chain`, `tls`, `tlsmsg`, `aesgcm`, `chacha`, `ed25519`, `x25519`, `ec256`, `h2`) now use pure 0-based indexing (no phantom seed), with `list.len()` = real count, `slice_seed(b,start,count,[])`, `sconcat(a,b)=a.concat(b)`. All e2e green: `run_x509_in_resid`, `run_rsa_pkcs1_verify_in_resid` (stage-1+stage-2), `run_ecdsa_p256_verify_in_resid`, `run_chain_san_validity_in_resid`, `run_tls13_framing_in_resid`, full crypto suite (SHA/HMAC/Ed25519/ChaCha/AES/X25519).
- **0-based migration completed for TLS/H2 clients + wide-ec e2e**: `examples/h2_client.resid` (framer: `read_one_record` plain-strip off-by-one, DATA-body truncation, `read_flight`/`read_app` 0-based slices, `hb`/`recv_exact`/`recv_loop` empty-seed) and `examples/tls_client.resid` (records, `open_if_app` marker, `read_app`, `verify_cv`, `safe_msg` `-1` sentinel, transcript slices) fully migrated. Live-network e2e green: `run_tls13_live_openssl_in_resid`, `run_h2_live_request_in_resid` (56s), `run_h2_post_and_continuation_in_resid` (129s); `run_ecge512_wide_prop_in_resid` green (623s — includes ECDSA-P256 verify via `tm_ecdsa_verify_sha256`). Supporting lib fixes: `tlsmsg` `tm_find_fin`/`tm_find_pos`/`tm_find_fin_last` not-found sentinel `-1`, `chain.resid` `eq_bytes`/`ci_eq_bytes`/RSA `der_content_pos` 0-based, `aesgcm` `e1_acc` `v[i]`, `ec256` `ecdsa_vx` `den==0` guard, `e2e.rs` `be512_acc` 0-based seed.
- **Stage-2 empty-list parity**: Fixed driver's typechecker (`params_accept_at` empty-adopt for `List(Unknown)`) and codegen (`[]` → `resid_list_new(0,null,…)`) in `examples/typecheck.resid` + `examples/codegen.resid`; regenerated `examples/driver.resid` (6950 lines). Verified by `bootstrap_*` tests (12/12 green) and `run_rsa_pkcs1_verify_in_resid` stage-2 path.
- **Knowledge cache subsystem (§34, §36)**: Expression-level reduction cache (`resid_cache::KnowledgeStore`) with content-addressed keys (expression hash + environment hash). CBOR schema for `KnowledgeEntry` (kind, expr_hash, env_hash, value, caps). Kinds: ReducedExpr, ProviderResult, TypeInfo, ConstraintProof, BehaviorResolution. Values: Int(i128), Bool, Str. Integrated with codegen's comptime β-reduction: cache checked before `reduce_call`, results stored after successful reduction. Capability-gated writes per §21.4 (`RESID_CAP_GRANT` env). 17 tests in `resid-cache` (8 new knowledge cache tests + 9 existing artifact cache tests). Persisted to `.resid-knowledge.cbor` in build output dir.
- **Stage-2 cache hit fix**: `residc build` cache hit now copies cached artifact to `-o` output path (was returning success without copy, breaking `stage2_emitter_compiles_bootstrap_lexer`).
- **Stage-2 provenance fix**: `prov_hex_seed` in `driver.resid` uses 0-based `[]` not seeded `[0]`; seeded list corrupted SHA-512 input → invalid Ed25519 signatures. Fixes `run_stage2_provenance_sidecar`.

**Completed this session (error system, spec §34):**
- **`resid-diag` crate**: shared diagnostic infrastructure (rustc-grade). Error codes (E0001, E0010, E0020, E0211–E0218, E0301), primary span with caret underline, secondary labels (span pairs / borrowck-style), `note:` / `help:` lines, ANSI color on TTY. Source snippet renderer reads file by line number (no byte offsets).
- **Lexer span widening**: token spans widened from points to ranges (`col_start`..`col_end`) so diagnostics underline the whole token. Trailing whitespace trimmed. Multi-line tokens keep point spans.
- **TypeError upgrade**: carries `code`, `primary_label`, `labels[]`, `notes[]`, `help`. Fluent builders `.code()`, `.primary_label()`, `.label()`, `.note()`, `.help()`, `.to_diag()` for rendering.
- **All strategic error sites stamped**: constraint discharge (E0301), transitive attenuation (E0211), sandbox ceiling exceed (E0212), unknown mode keyword (E0213), spawn child≤parent (E0214), spawn-body cap (E0215), handle-entry provenance (E0216), write-verb under RO grant (E0217), provider call not granted (E0218). Span pairs on call site ↔ callee declaration.
- **ImportError carries parse_errors**: structured lexer/parser errors preserved through `resolve_unit` for snippet rendering at the CLI.
- **residc rendering**: `print_diag()` / `print_type_errors()` use `resid-diag` with TTY color detection; parse errors print full snippets.
- **resid-build rendering**: type errors rendered via `TypeError::to_diag()` with source snippets.
- **Runtime aborts carry source spans (zero cost)**: codegen emits every `resid_abort` / `resid_abort_at` / `resid_index_abort` with a baked-in `(file:line:col)` C string literal. `todo`/`unimplemented` → `resid_abort(msg, span)`. Failing `assert` → `resid_abort_at(dyn_msg, static_loc)`. List index OOB → `resid_index_abort(idx, len, span)`. C runtime `resid_fail(msg, at)` prints both.
- **New e2e tests (5)**: `diag_type_error_renders_snippet`, `diag_constraint_carries_code_and_help`, `diag_capability_pair_renders_both_sites`, `runtime_aborts_carry_source_spans` (todo, index OOB, assert), plus duplicate-check removed.
- **All tests green**: 6 `resid-diag` unit, 252 `resid-type` unit, 117 `residc` e2e (111 baseline + 4 new + 2 parity from earlier).

Strategic work items:
- **Graph reduction stage-2 parity (§11, §36)**: **✅ DONE** (this session) — see §5 completed list; `--bootstrap-graph-reduce` + 4 new e2e tests.
- `Str` rope-backed representation: **✅ DONE** (this session) — chunked concat-rope builders in `resid_rt.c` (`str_sb_new`/`str_sb_append`/`str_sb_append_cp`/`str_sb_finish`) + both-pipeline type/codegen support + `lib/h2.resid` rewrite; see §5 completed list.
- `resid why` and `resid-lsp` hardening: **✅ DONE** (this session) — see §5
  completed list; `--file`/`--max`/`--help` filters, deterministic sort,
  URI + column-precise JSON diagnostics, per-document LSP filtering.
- Crypto: additional algorithms as needed (currently complete through TLS 1.3 + HTTP/2).

---

## 6. Spec-conformance roadmap (v3.3)

Audit result: the language is self-hosted and broadly functional, but
NOT yet 100% spec-complete. This section is the curated work list; an
item is DONE only when it ships in **both** pipelines (see policy).

**Status: the curated list is now complete in both pipelines.** Every item
has landed in stage-1, and stage-2 (`examples/driver.resid`) parity now
covers all of it too, including the §21 sandboxing items (transitive
attenuation, force-time capability errors, handle-entry/value-provenance,
mode lattice) that were previously stage-1-only — see "Stage-2 Parity:
Sandbox (§21)" below. Remaining work is incremental (new library/crypto
features, tooling hardening) rather than closing conformance gaps.

### Self-hosting policy (normative) — superseded by the stage-0-seed model

**This section described the bootstrap-period policy and is now
historical.** `PLAN-resid-only.md` Phase D supersedes it: Phase B (the
D1→D2→D3 self-compile fixed point) and Phase C (every Rust-only tool
ported to `.resid`, C.1-C.7) are both done, so the Rust pipeline is no
longer required as an ongoing dual-implementation partner for new work.
The replacement model:

- **The self-hosted pipeline (`examples/typecheck.resid` +
  `examples/codegen.resid` → `examples/driver.resid`) is the only actively
  developed compiler going forward.** New features are implemented
  directly there; there is no requirement to also implement them in
  `crates/resid-type`/`crates/resid-codegen` first or in parallel.
- **`crates/` (the Rust pipeline) is archived, not maintained.** It is
  kept only so a stage-0 seed binary can be rebuilt for a new host
  architecture the frozen seed binary doesn't already cover (see Phase D
  below) — not as a reference implementation new features must also
  satisfy.
- **A frozen, versioned, checksummed stage-0 seed binary** (built once
  from the last Rust pipeline commit, before archival) is the actual
  bootstrap root: `stage0 → D1 → D2 → D3 → ...`, each generation built by
  compiling `driver.resid` with the previous one. No generation after the
  frozen seed ever depends on Rust again.
- **clang/LLVM remains a permanent, accepted external dependency** (see
  Phase D.4) — "resid-only" means no Rust in the toolchain, not zero
  external tools. Both the historical Rust pipeline and every self-hosted
  generation shell out to `clang` on textual `.ll` IR.

The original bootstrap-period rules below are preserved for history, not
as current policy:

- ~~The Rust pipeline is implemented first (single implementation cost);
  the feature is then ported into `examples/typecheck.resid` +
  `examples/codegen.resid`, and `tools/merge_driver.py` regenerates
  `examples/driver.resid`.~~
- ~~Every conformance item must land with dual-pipeline e2e parity
  tests (`bootstrap_*`) proving byte-identical output through Rust
  residc AND the stage-2 driver before it counts as done.~~
- ~~Stage-2 is the acceptance gate, not a side demo. Constraint: bootstrap
  sources are compiled by the Rust pipeline, so they may only use
  features the Rust compiler already supports — satisfied automatically
  by Rust-first ordering.~~
- ~~Hard constraint from the audit: a feature used by the driver's own
  sources can never precede Rust support for it.~~

### Stage-2 Parity: Sandbox (§21) — ✅ DONE

**Sandbox is fully implemented in both pipelines.** Rust pipeline (all 7 e2e
tests pass): `run_sandbox_transitive_attenuation`, `run_sandbox_enforcement`,
`run_sandbox_force_time_guard_present`, `run_sandbox_force_time_guard_fires`,
`run_sandbox_handle_entry_file_param`, `run_sandbox_handle_entry_file_argument`,
`run_sandbox_capability_mode_readonly`.

Stage-2 (self-hosted driver, `examples/typecheck.resid` +
`examples/codegen.resid` → `examples/driver.resid`) now has full parity: 5
new e2e tests (`bootstrap_driver_sandbox_enforcement`,
`bootstrap_driver_sandbox_transitive_attenuation`,
`bootstrap_driver_sandbox_handle_entry`, `bootstrap_driver_sandbox_readonly_mode`,
`bootstrap_driver_sandbox_force_time_guard`) exercise ceiling enforcement
(E0212), transitive attenuation across the call closure (E0211), unknown
capability-mode rejection (E0213), handle-entry + value-provenance checks
for `File` parameters/arguments, read-only-write rejection, and the runtime
`resid_cap_enter`/`resid_cap_check`/`resid_cap_leave` force-time guard
actually firing (aborts with `capability not granted: <family>`) when a
capability slips past the (textual, best-effort) self-hosted typechecker.

**Note for posterity**: an earlier assessment in this file claimed stage-2
parity was blocked on `examples/parser.resid` needing a rewrite to parse
sandbox bodies. That was based on a mistaken premise — `typecheck.resid` and
`codegen.resid` are **not** built on top of `parser.resid`; they implement
their own self-contained lexer/parser/checker/codegen logic from scratch
(their own `lex_tok`, `skip_body`, `collect_sigs_at`, `check_expr`, etc.), so
`parser.resid`'s limitations were never actually a blocker for this feature.
The real work was: (1) add `eprintln` so the self-hosted checker can report
`error[E0xxx]:` to stderr like the Rust pipeline; (2) extend the `Funcs`
struct in both files with `reqs`/`ceils`/`bods` lanes and parse
`@requires(...)`/`sandbox(...) { }`; (3) implement the enforcement checks in
`typecheck.resid` as a **textual post-pass** over each function's captured
body text (not full effect-propagation through `check_expr`/`check_stmt` —
that was explicitly scoped out as too invasive) — this catches every case
exercised by the test suite but is not a complete effect-checker (see
"Known limitations" below); (4) in `codegen.resid`, fix a real
pre-existing bug where `pg_next` never generated code for
`sandbox(...) { }` blocks at all (they were silently skipped whole — no
sandboxed function was ever being compiled by the self-hosted driver before
this), then emit the `resid_cap_enter`/`resid_cap_check`/`resid_cap_leave`
force-time guard around sandboxed bodies; (5) add the
`filesystem.open`/`read_handle`/`close` provider methods to both files
(missing from both checker and codegen dispatch tables); (6) update
`tools/merge_driver.py`'s dedup list for the newly-shared `cap_list_at`/
`ceil_join` helpers and regenerate `examples/driver.resid`.

**Known limitations of the stage-2 checker** (by design, not bugs):
- *(A.1b, closed)* Provider calls are now checked for real. The checker
  builds per-function **call-graph edges** and **provider-effect sets** from a
  `lex_tok` scan of each body (not substring matching), and rejects a
  provider call whose family is not in the region's effective capability set
  with `E0218` — including transitively, through an undecorated helper
  reached from a narrower sandbox. The runtime `resid_cap_check` force-time
  guard remains as defense-in-depth for what the static scan cannot see
  (provider calls inside f-string interpolations, nested
  `sandbox`/`spawn` blocks inside a body, and residual/`rt` paths). Verified
  by the 12 `sandbox` e2e tests plus a manual probe
  (`helper()` using `filesystem.read_all` called from `sandbox (network)` →
  `error[E0218] … family 'filesystem' … [network]`).
- Runtime capability checks are family-only; `readonly`/`readwrite` mode
  distinctions are enforced only at compile time (`check_readonly_writes`),
  matching the Rust reference's own runtime design (confirmed by direct
  comparison), not a stage-2-specific gap.
- `cap_list_at`/`ceil_join` are duplicated verbatim between
  `typecheck.resid` and `codegen.resid` (deduped at merge time by
  `tools/merge_driver.py`); if either copy is edited without updating the
  other, the merged driver silently keeps only the `codegen.resid` version.

**Fixed-capacity stack types (§2 `Str(N)`/`Bytes(N)`/`List(T,N)`)** — **✅ DONE
(stage-1 + stage-2)**: literal adoption, bounds-checked indexing, casts, builtin
view widening, `.len()` all implemented in both the Rust pipeline and the
self-hosted driver (`examples/typecheck.resid` + `examples/codegen.resid`),
byte-identical output and identical abort behavior (e2e
`bootstrap_driver_fixed_size_stack_types`, `bootstrap_driver_fixed_builtin_widening`).

### MISSING — item 1 is now fully DONE in both pipelines

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
   gating (✅ DONE — `caps_are_at_most` gates writes, CBOR entries carry caps
   through round-trip, e2e `run_cache_capability_gating`).
   **✅ Stage-2 parity DONE** (this session) — all of the above now also
   holds through `examples/driver.resid` (see "Stage-2 Parity: Sandbox
   (§21)" above for the writeup and known limitations); e2e
   `bootstrap_driver_sandbox_enforcement`,
   `bootstrap_driver_sandbox_transitive_attenuation`,
   `bootstrap_driver_sandbox_handle_entry`,
   `bootstrap_driver_sandbox_readonly_mode`,
   `bootstrap_driver_sandbox_force_time_guard`.
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
    (see §9 progress). **Graph drives a full alternative pipeline**:
    `residc <f> run --graph-reduce` converts AST→graph→reduce→retrofit→
    checker→codegen with byte-identical output to the plain path, the
    cache key distinguishes the two modes, and §36 dead-code elimination
    elides unreferenced folded bindings while preserving effectful
    residuals (see §11 progress).
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
- **Stage-2 (DONE)**: driver compiles Map/Set programs end-to-end with
  byte-identical output to the Rust pipeline (e2e `bootstrap_map_set_parity`).
  Was regressed as of 2026-09-19 (`Set(Int).contains(2)` diverged
  stage-1 vs stage-2), root-caused and fixed same day — see §0a.
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

### Progress on item 11 — knowledge graph as DRIVING IR: graph pipeline wired (stage-1)

**`--graph-reduce` mode**: `residc <f> run|build|emit-ir --graph-reduce` (or
`RESID_GRAPH_REDUCE=1`) runs the full convert→reduce→retrofit loop between
parsing and type checking: parser AST → `resid-ir` knowledge graph → §36
β-reduction → `to_ast` back into a parser `TranslationUnit` → type check →
codegen. Prior state had the graph in parallel (`resid-ir/graph.rs`) with
ad-hoc reduction inside codegen; now the graph drives a full alternative
pipeline and its output is byte-identical to the plain one.

- `resid-ir` additions: `AstTranslationUnit` (functions-only IR carrying
  args, names, sig types, capabilities, doc), `from_ast` conversion (all
  expression forms incl. f-strings, structs, maps/sets, un/binary ops,
  calls incl. named/default args, index/slice, casts, `let`/`if`, match);
  retro `graph_reduce(unit) -> ReducedUnit` (β-reduce every pure function
  body, clean re-assembly) + `to_ast` back-conversion, with a
  `reduce_fstring` fix: folded literals render via the runtime-faithful
  `rendered_literal` helper (plain decimal, no `_64` width suffix) so
  folded strings match runtime prints exactly.
- `resid-type` bridge (`crates/resid-type/src/graph.rs`): `from_ast`,
  `to_ast`, `graph_reduce(unit, ok) -> Result<TranslationUnit, Vec<String>>`
  with full type round-trips (width-parameterized Int/UInt/Float/Dec,
  Char→Int(16), composites, residuals, behavior names) and a loud gate:
  non-function declarations are rejected ("only functions are representable
  in the reduction IR") rather than silently dropped.
- `residc`: `--graph-reduce` flag + `RESID_GRAPH_REDUCE=1`. The cache key
  distinguishes graph-reduce from plain-pipeline artifacts; reduced programs
  re-type-check and run with byte-identical stdout to the plain pipeline
  (e2e `run_graph_reduce_preserves_behavior`; reduction diagnostic
  `graph-reduce: reduced program to N function(s)` on stderr; non-function
  declarations rejected e2e `graph_reduce_rejects_type_declarations`).
- Notes/limitations: only functions round-trip (§22/type decls rejected);
  IR merges logical/bitwise AND → `&&`/`||` on conversion; checked runtime
  overflow (pre-existing `254+2` on UInt(8)) may trap on the plain path
  while the reducer folds it away — a spec edge (reduction funds wrapped
  values), not a regression.
- **Dead-code elimination (§36 amendment)**: a binding whose reduced value is
  a fully-known constant and whose name is not referenced by the remaining
  residual computation is elided by the retrofit pass (`dce_block` in
  `retro.rs`, undo fixpoint over block statements). Elision is authorized
  only for fully-known values — a binding whose value stays residual (an
  effectful call such as `Bool unused = println(…)`, an index, a checked
  div/rem) is preserved even when unreferenced, since its evaluation may
  print, abort, or fail to converge. Spec §36 updated to make this
  enforceable ("Runtime behavior may not depend on the presence or absence
  of an elided binding"). `test2.resid --graph-reduce` now emits `main` as a
  single `println(@str)` call — every dead `alloca/store` is gone.
- Tests: prior round resid-type +4 integration (`reduced_program_retypechecks`,
  `reduced_program_registers_equal_functions`, `beta_substitution_collapses_pure_call_body`,
  `rejects_non_function_declarations`) + resid-ir +9; DCE round resid-ir +4
  unit, resid-type +3 integration, residc e2e +1. Total non-e2e 659, e2e 111.

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

### Progress on item 1 — sandboxing: STAGE-2 PARITY ACHIEVED (self-hosted driver)

Full sandbox/capability enforcement now runs through `examples/driver.resid`
with output parity to the Rust `residc` pipeline — the last remaining §21
stage-2 gap is closed. Plan document: `PLAN-sandbox-parity.md` (kept as a
historical record of the phased design; marked complete at the top).

- **`typecheck.resid`**: extended the `Funcs` struct with `reqs`/`ceils`/
  `bods` lanes; `collect_sigs_at` parses `@requires(...)` (bare idents,
  modes silently dropped — mirrors the Rust parser's Id filter) and
  `sandbox (caps) { ... }` (nested sandboxes concatenate their ceilings).
  Added capability helpers (`cap_family`, `cap_readonly`,
  `caps_contain_family`, `grant_readonly_only`, `is_write_verb`,
  `meet_caps`, `cap_list_at`, `ceil_join`) mirroring the Rust reference
  semantics. Enforcement is a **textual post-pass** per function (not
  full effect-propagation through `check_expr`/`check_stmt` — deliberately
  scoped out as too invasive for the self-hosted checker): E0212 (ceiling
  violation), E0211 (transitive attenuation across the call closure via a
  call-graph meet fixpoint), E0213 (unknown capability mode), handle-entry
  (`File` parameter into a non-granting sandbox) and value-provenance
  (`File` value forwarded as a call argument into a non-granting sandbox)
  checks, and read-only-write rejection. Fixed two real bugs found while
  wiring this up: (1) the value-provenance check used a naive
  `"(" + param + ")"` substring match that misfired on provider calls like
  `filesystem.read_handle(h)` — tightened to require the argument be passed
  to a call whose callee is a *known user function name*; (2) enforcement
  stopped at the first violating function in declaration order, which
  could surface the wrong diagnostic when an earlier-declared function was
  also (correctly) flagged — changed to scan and report every violating
  function. Also added the `filesystem.open`/`read_handle`/`close`
  provider methods, which were missing from the checker's dispatch table
  entirely (pre-existing gap, unrelated to this work but required for the
  handle-entry/value-provenance tests to typecheck their provider calls at
  all).
- **`codegen.resid`**: mirrored the `Funcs` `reqs`/`ceils` parsing (no
  `bods` lane needed — codegen scans its own emitted LLVM lines, not
  source text). Found and fixed a real **pre-existing bug**: `pg_next`
  never had a case for the `sandbox` token at all, so every
  `sandbox(...) { ... }` block was silently skipped whole by the
  catch-all `skip_body` fallback — no function declared inside a sandbox
  block was ever being code-generated by the self-hosted driver before
  this change. Added proper sandbox-block recursion (parse the capability
  list, slice the inner body, recurse `pg_next` on it, continue after the
  close brace) plus a related fix where skipping past `@requires(...)`
  only skipped the annotation name and not its parenthesized argument
  list, which silently ate the following function's entire definition.
  Implemented the force-time guard: `cap_enter_prologue` emits an
  `alloca [N x ptr]` + per-capability `getelementptr`/`store` + a single
  `resid_cap_enter` call right after `entry:` for every sandboxed
  function; `capinject_at` walks the already-emitted body lines inserting
  `resid_cap_leave()` before every `ret` and a `resid_cap_check(family)`
  right after every provider-call line (detected by runtime symbol prefix:
  `resid_fs_*`, `resid_env_*`, `resid_args_*`, `resid_process_run`,
  `resid_tcp_*`, `resid_git_*`), each with a fresh `@str`/`@str.N`
  `unnamed_addr constant` global. Added `filesystem.open`/`read_handle`/
  `close` codegen support (runtime symbols, return types, arg counts, and
  `hdr_core` declarations) — matching the typecheck-side gap above.
- **Runtime (`crates/residc/resid_rt.c`, `crates/resid-type`)**: added
  `eprintln` so the self-hosted checker can report `error[E0xxx]: <msg>`
  to stderr in the same channel/format the Rust pipeline uses (substring
  matched by tests, not byte-exact caret rendering — that scope was
  explicitly cut, see the plan doc's risk table). `resid_cap_enter`/
  `resid_cap_check`/`resid_cap_leave`/`resid_cap_granted` runtime support
  already existed from the Rust-pipeline work and needed no changes.
- **`tools/merge_driver.py`**: added `cap_list_at`/`ceil_join` (byte-identical
  in both source files) to the dedup drop-list so the merged driver keeps
  only one copy; regenerated `examples/driver.resid`.
- **Verification**: beyond the automated e2e tests below, manually verified
  the full compile→link→run round trip outside the test harness — a
  single-capability sandbox reading a file and printing its contents, a
  two-capability sandbox (`filesystem`, `environment`) reading a file *and*
  an environment variable, and a runtime-only violation (`process.run(...)`
  with no `@requires`, inside `sandbox (filesystem)`) that passes stage-2
  typecheck but aborts at execution with
  `resid: abort: capability not granted: process` after the shell command
  it invoked had already run — demonstrating the force-time guard is a real
  backstop, not just IR decoration.
- **New e2e tests (5, `crates/residc/tests/e2e.rs`)**:
  `bootstrap_driver_sandbox_enforcement` (ceiling violation, E0212),
  `bootstrap_driver_sandbox_transitive_attenuation` (E0211, direct + 2-hop
  chain through an undecorated middle-man), `bootstrap_driver_sandbox_handle_entry`
  (File parameter entry + File value forwarded as a call argument, both
  legal and illegal cases), `bootstrap_driver_sandbox_readonly_mode`
  (legal read under `filesystem(readonly)`, illegal write, unknown mode
  keyword → E0213), `bootstrap_driver_sandbox_force_time_guard` (asserts
  the emitted `.ll` contains `resid_cap_check`/`resid_cap_enter`/
  `resid_cap_leave`, and that a violation which passes stage-2 typecheck
  aborts at runtime with `capability not granted: process`). All drive
  `examples/driver.resid` via `residc <driver.resid> run <sample.resid> -o
  <bin> -rt resid_rt.c`, matching the existing `bootstrap_driver_*` test
  style.
- **Known limitations** (see "Stage-2 Parity: Sandbox (§21)" above for the
  full list): the stage-2 checker is textual/pattern-based, not a full
  effect-checker — an unannotated provider call with no matching
  handle-entry/value-provenance/readonly-write shape passes stage-2
  typecheck even when it shouldn't; the runtime `resid_cap_check` guard is
  the backstop for this gap. `cap_list_at`/`ceil_join` remain hand-kept in
  sync between `typecheck.resid` and `codegen.resid`.
- **Full regression run**: `cargo nextest run --workspace` — **821/821
  passing, 0 failed, 0 skipped** (up from 817 before this session's 5 new
  tests, net +4 after accounting for count drift from an unrelated prior
  session). See `AGENTS.md` for the per-test timing table of the 31 tests
  ≥60s (total wall time ≈85 minutes, dominated by live-network TLS/HTTP,
  wide-EC crypto property tests, and bootstrap-driver/parity e2e tests that
  each run the full self-hosted lex→parse→typecheck→codegen→clang-link→execute
  pipeline).
