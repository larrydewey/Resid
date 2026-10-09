# PLAN: closing the reducer's gaps

Status: in progress (written 2026-10-09, after the budgets rework in
PROGRESS §0zx). Steps 1 and 2 done (PROGRESS §0zy).
Goal: make compile-time reduction (`compiler/greduce.resid`, helpers in
`compiler/reduce.resid`) fold everything provable. Budgets are no longer the
main limit. The limit is now the constructs the evaluator cannot run: one
inside a call makes the whole call residual, whatever the budget.

## How the gaps were measured

An instrumented copy of the reducer logged, while β-reducing (depth > 0),
each expression whose value came out unknown. The logged kinds were call
(non-user), mcall, field, index, cast, ref, map/set/emptyb, lambda, match,
spawn, callv and rt, plus every `bad` result and every unusual statement kind.
It ran over the compiler, `tools/*.resid`, `examples/*.resid`,
`bench/suite/src/st/*`, and all conformance cases (442 programs), linked
against a stub `clang`.

To redo it: wrap `gx_expr` as `gx_expr0` plus a logger that does
`eprintln("RDX " + kind + ":" + name)` when `st.depth > 0 && !v.k`. Build it
with `build/boot/stage2.bin <copy>/compiler/driver.resid -o rdx.bin
--runtime-internals`. Compile the corpus with `PATH=<dir with a fake clang
that exits 0>:$PATH`, then aggregate with `sort | uniq -c`. Re-measure after
each step: the counts are the acceptance metric.

Results. Columns: occurrences, then programs affected. `ref:` (3,977) is
mostly propagation, not an origin.

| Gap | Occurrences | Programs | Today |
|---|---|---|---|
| Builders: `StrBuf()`, `ListBuf()`, `.push`, `.finish`, `str_sb_new` | ~940 | 12+ | never known; most compiler-style code builds text or lists this way |
| `Result` / user sum types: `Ok`, `Err`, `Parsed`, `ParsedZoned`, `match` on anything but `Option` | ~230 | 8+ | `match` only handles `Option` (`gx_match`, `gx_arm_for`) |
| Missing builtins: `wrapping_*`, `f128`, `i64`/width conversions, `min`, `sort`, some `str_*` | ~300 | 8+ | not in `rd_builtin` |
| Map / Set values: `{}` (emptyb), map literals, `.insert`, `.get`, `.contains`, `.len` | ~140 | 9+ | `gx_expr` returns unknown for map/set/emptyb |
| Slices `xs[a..]`, `xs[a..b]` while β-reducing | 88 (`bad:rangefrom`, `bad:index`) | 13 | a `bad` result: the call is marked not reducible ("!") |
| Records with collection fields | many `field:` misses | — | a struct is known only when every field is |
| `while` while β-reducing | (stmt:while) | — | left residual at depth > 0 (`gx_while`) |
| Lambdas / `callv` / closures | few | — | always unknown |

Effects (`println`, clock, `read_bytes`, `resid_crypto_random_byte`,
`spawn`) also show up in the log. They are correct to stay residual.

## Order of work (agreed with the user)

1. **Slices and missing builtins.** Done: slices, abs/min/max/clamp,
   conversions, sort, the missing `str_*`, list verbs, and integers past
   64 bits (carried as text, computed in Int(512)). Float(16/32/128) and
   Dec stay residual: the evaluator does not carry them.
   - Slices of known lists and strings in `gx_index`: `rangefrom` and
     `a..b`, clamped as the runtime does. Out of range stays residual (it
     traps at run time).
   - `rd_builtin` gains `wrapping_*`, `saturating_*`, `checked_*` (residual
     on overflow), `min`/`max`/`abs`/`clamp`, width conversions, `sort` on
     known lists, and the `str_*` family where missing.
   - Each one must match the runtime bit for bit. Fuzz against the runtime:
     compile the same expressions with `--no-reduce` and compare the outputs.
2. **`Result`, user sum types, general `match`.** Done, for declared
   sum types without generic parameters; variant values are left
   unrenderable.
   - A value encoding for variants (tag plus payload, like `S`/`N` for
     Option).
   - Constructors (`Ok(x)`, user variants) and `match` with any arms,
     including payload bindings and a catch-all.
   - `?` on `Result`.
   - `rd_render` must render variant literals, or leave them unrenderable
     (the value is still usable inside a fold).
3. **Builders at compile time.** The largest gap.
   - `StrBuf`/`ListBuf` are linear (E0401–E0404), so a known builder can be
     a plain known value: `push` appends, `finish` yields the Str or list.
   - Check the linearity rules still hold when reduction removes uses.
4. **Map / Set values.**
   - Encode with the runtime's canonical key order (FNV-1a, 5-bit chunks;
     see `runtime/rt/map.resid` and memory note project_map_ownership). The
     order is observable through `keys()`/`values()`/formatting.
   - Literals, `{}`, `insert`, `remove`, `get` (Option), `contains`, `len`,
     `keys`, `values`.
5. **Evaluator speed.** Today about 1.5 µs per step. Faster evaluation means
   more folds per budget.
   - About 25% of the time is `rt_scope_push`/`pop`: compiler-inferred
     scalar scopes in the reducer's own helpers (`gx_kind ==`, `gx_kid`, ...).
   - About 7% is `c_strcmp`: dispatch on node-kind strings.
   - The 16-field `GS` record is rebuilt on every tick and charge.
   - Lists are encoded strings, so most list operations are O(n).
   - Candidates: integer kind codes, a typed value representation for lists
     and records, and folding counters into fewer record rebuilds. Profile
     with the frame-pointer trick (memory note project_selfcompile_memory).
   - Target: 3–10×.
6. **Partial evaluation inside β-reduction.** Today a call with some unknown
   arguments inside a compile-time call fails the whole attempt. Online
   partial evaluation would leave a smaller residual. This is the biggest
   design change; do it last.

Smaller items:
- Memo entries made inside a tail-loop hop are dropped each iteration
  (`gx_hop` keeps `st` fixed). Keeping pure inner results would avoid
  recomputation.
- Non-tail nesting uses only about 1.3 KB of stack per level, so
  `rd_max_depth` (20,000) could go higher. E0902 stays the backstop.
- The meter constants (`rd_step_bytes`, `rd_call_bytes` = 4096) were
  calibrated on two shapes (tail loops, wide non-tail recursion).
  Re-calibrate after step 5.

## Constraints that must hold at every step

- **Determinism.** Nothing native (stack, RSS, time) may decide whether a
  call folds. resid-ddc (`../resid-ddc`, `scripts/ddc.sh ../resid` and
  `scripts/compare-cases.sh ../resid`) must reproduce the seed, `rt.ll`, and
  every conformance case. Any new builtin the compiler's own source uses
  needs a twin in `interp/builtins.go`.
- **Soundness.** A fold must equal what the program does at run time,
  failures included: overflow, an out-of-range index, or a failed conversion
  stays residual. Add a conformance case per construct, including a negative
  one. The readline miscompile (`reduce_tail_after_unknown`) shows how a
  fold can look right and be wrong.
- **`gx_hop`** must carry only scalars, Str and List(Str), so it keeps its
  loop region. Evaluator helpers that recurse into evaluation must not be
  self-tail loops (one 1 MB region page per nesting level).
- After each step: `./boot.sh --bootstrap-from-self`, then `./boot.sh`
  (byte-identical fixed point), every suite under `tests/*/run.sh`,
  `python3 tools/check_doc_examples.py`, and resid-ddc.
- Measure the compiler's memory by polling its own VmHWM: child rusage
  includes clang. Compare benchmark run times old vs new (`bench/suite`,
  argv sizes in `bench.py` `SIZE_ARG`).
