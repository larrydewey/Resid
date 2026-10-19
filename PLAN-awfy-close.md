# Plan: closing the AWFY gap, from measurement

Status 2026-10-19, HEAD f57dca3c (ownership on by default, in-place list
record writes). This plan replaces the forward-looking parts of
`PLAN-awfy-lead.md` and `PLAN-ownership-ir.md` §9 phase 5. Everything in
§1-§2 is measured on this machine; §3-§5 are the changes that the
measurements name, each with the number it must reach before it is built.

The rules in force: the target is the per-benchmark leader by wall ms per
iteration on an idle core, steering by `instructions:u`; a change is built
only when its ceiling clears 20% instructions on at least one benchmark;
ports stay as written; no user-visible ownership or annotations; bounds,
overflow and IEEE order stay; compile time may grow by about 5% of the
self-compile; every round is red-teamed before it is called done.

## 1. Where we stand

`harness <B> 5 <inner>` at the ReBench sizes, core 2, best of three,
portable profile. Leaders rerun the same way, same session.

| Benchmark  | Resid ms | Leader (ms)   | ms gap | instr gap | cycles gap | Resid IPC |
|------------|---------:|---------------|-------:|----------:|-----------:|----------:|
| Richards   |     98.3 | Zig 22.0      |  4.47x |     6.14x |      4.43x |      4.25 |
| DeltaBlue  |     28.3 | Rust 4.9      |  5.75x |     3.99x |      5.04x |      4.31 |
| Queens     |     19.6 | Zig 3.7       |  5.28x |     5.51x |      5.22x |      5.44 |
| Havlak     |    114.7 | Rust 32.3     |  3.55x |     2.16x |      3.53x |      2.80 |
| Bounce     |     15.6 | Rust 5.5      |  2.85x |     2.47x |      2.84x |      5.76 |
| CD         |     42.4 | Zig 15.1      |  2.81x |     3.09x |      2.76x |      4.30 |
| Sieve      |     27.0 | C++ 10.2      |  2.65x |     2.97x |      2.59x |      5.36 |
| Json       |     29.1 | Zig 11.5      |  2.53x |     4.24x |      3.04x |      5.14 |
| Permute    |     21.9 | C++ 9.4       |  2.33x |     3.62x |      2.29x |      6.30 |
| Towers     |     15.8 | Zig 7.2       |  2.18x |     3.01x |      2.14x |      6.29 |
| Storage    |     52.1 | Java 27.1     |  1.93x |        -- |         -- |      4.93 |
| NBody      |      9.4 | Rust 6.8      |  1.38x |     1.98x |      1.35x |      4.24 |
| List       |     13.2 | C++ 11.0      |  1.20x |     0.76x |      1.20x |      4.37 |
| Mandelbrot |     27.2 | Zig 26.9      |  1.01x |     0.90x |      1.01x |      0.96 |

Full table (every language, instructions and cycles) in the job's
`base0/table.txt`. Changes since the 2026-10-17 table: Richards 140 -> 98
ms, Towers 26.6 -> 15.8, NBody 38.8 -> 9.4, Permute 31.8 -> 21.9, Json
40.8 -> 29.1, DeltaBlue 29.6 -> 28.3. Storage is first among the native
languages (Zig 105 ms); List and Mandelbrot are within noise of the lead.
Resid is no longer last on any benchmark except Richards and Queens.

The gap is still instruction count: IPC is 4.2-6.3 everywhere but Havlak
(2.8, cache misses on list copies) and Mandelbrot (shared dependency
chain). So the plan is about instructions, and §2 says where they go.

## 2. Where the instructions go (exact, callgrind)

Method: `valgrind --tool=callgrind --dump-instr=yes` on the HEAD harness at
small sizes, exact `Ir` per machine instruction of the hot functions
(`cgaddr.py`/`cgfn.sh` in the job's tmp; the inclusive cost after a
`calls=` line is excluded). The counts below are per operation of the
benchmark, so they transfer to the ReBench sizes. The first finding
overturns the premise of the last four rounds: the named dynamic checks
(transient, flat, young/region, due, overflow) are 5-20% of the hot
functions, not the bulk. The bulk is the *shape* of every list access,
allocation and call, which no check-trimming reaches.

### 2.1 The cost of one operation today

Measured from the hot paths; the leader column is what the Zig/C++ code
spends on the same operation.

| Operation | Instructions now | Made of | Leader |
|-----------|-----------------:|---------|-------:|
| `xs[i]` on a list of inline records (Richards `s.ts[s.cur]`, Bounce) | 11 | list ptr, word count, **divide by record words** (movabs, imulq, shr, sar, add = 5), bounds (2), root ptr, imul by record size | 2 |
| `xs[i]` on `List(Int)`/`List(Bool)` (Permute, Queens, Sieve) | 9-10 | list ptr, len, bounds (2), count word, shr, flat-or-trie compare (3), root ptr, lea, load | 3 |
| `xs[i]` on a list of boxed records (Richards `s.pk[p]`) | 13-14 | the above plus **share-on-read**: load header, test unique bit, and, store (4) | 2 |
| write-back of an inline element (`xs.with(i, r)` after a borrow) | 7-9 | transient test (2), field stores, second transient test (2), self-copy check `root+off == p` (3), store list back into its record (1) | field stores |
| `xs.with(i, v)` scalar, owned | 7 | bounds (2), transient test (2), root, store, list store-back | 1 |
| record allocation (Towers `Disk`, Queens `Placed`, Richards `Pkt`) | 20-22 | TLS base (1), loop meter `addq $N` (1), has-region flag (2), bump null test (2), 16-byte pad (3), limit (3), bump store (3), two header words (type pointer and header) (3) | 5-6 |
| recursive call frame (Permute, Towers, Queens, DeltaBlue, move_disks) | 11-17 | 5-6 callee-saved pushes and pops, stack adjust; the TLS base and the region/due pointers are kept live across calls, so they cost a saved register each | 4-8 |
| loop-region due test per iteration | 3 | reload `(%rsp)` slot, `cmpq $0`, branch | 0 |
| overflow check per `+`/`-` | 1 (`jo`) | | 0 |
| `str_slice(s, i, i+1)` (Json) | strlen + codepoint index | `c_strlen` 17% and `idx_slot_slow` 10% of Json | O(1) |
| `with` on a shared (frozen) list (Havlak) | 190 (`node_with`) | trie path copy; 1.23M calls, 16% of Havlak | 1 store |
| `xs.concat([x])` (DeltaBlue, CD, Havlak) | 60-100 | `append_core` + `flat_fill` + `concat_own` + memmove | 5 (push) |
| region young test on a record rebuild that changes a pointer field (Queens `set_rc`) | 12 | `rt_regions` page-table lookup | 0 |

### 2.2 Per benchmark

Exact per-operation budgets (self instructions, hot functions), with the
share of each cost source from §2.1. "Rest" is the algorithm's own loads,
stores, arithmetic and branches as LLVM emits them.

- **Permute**: 76 per `permute` call (Zig/C++ 20.7). Two swaps at 26 each
  (protocol 18 of the 26: two 9-instruction element reads, two 7-instruction
  writes, list store-back), frame 17 (22%, six callee-saved registers
  because the TLS base and two region pointers stay live across the
  recursion), count increment 3, loop and due 4.
- **Towers**: 75 per `move_top` plus 21 per move in `move_disks` (Zig 9.5
  per move in total). Allocation 22, frame 11 + move_disks' own frame
  (`move_top` is not inlined), the three-way pile dispatch 15 (the port
  selects `.a/.b/.c` by index; the reference's array would be one load),
  asserts and tag tests 6, stores and the move count 10.
- **Queens**: 56 per row test (Zig 10) and about 150 per placement. The
  row test is three 14-instruction reads (`b.rows[r]`, `b.maxs[c+r]`,
  `b.mins[c-r+7]`: each is record field, list header, flat test, bounds,
  byte test) plus due. A placement is three `with` writes at 7-9, three
  region young tests at 12 (the `Board` rebuild changes pointer fields,
  so the in-place write takes `resid_rec_reuse_ny`'s page-table lookup),
  the `Placed` allocation 20, frame 15, and the field copies through the
  frame (`movups`).
- **Richards**: 188 per scheduler step (Zig 30.5). About 14 list accesses
  per step (`s.ts[s.cur]` in schedule, run_task, set_ab, add_input,
  hold_self; `s.pk[..]` in run_task, handler_fn, queue_packet) at 11-14
  each plus 4-6 write-backs at 7-9: about 110 of the 188. Frames 8%,
  `with_shared` 4.3% (a `with` on a list the analysis could not keep
  transient), `list_move`/`bar_move_f`/`evac.Pkt` 4% (region moves of
  `Pkt` records with their `data` lists), transient tests 3%, the
  word-count division alone 6%.
- **DeltaBlue**: `execute` 34%, `satisfy` 11%; `append_core` + `flat_fill`
  + `concat_own` + memmove 20% (`cons.concat([ci])` and the plan lists);
  frame 10%; the list protocol as in Richards.
- **CD**: `put_into_map` 18%, `is_in_voxel` 13%, red-black `rb_put`/`put_fix`
  (tree nodes as records in a list) 20%; `append_core`/`flat_fill`/
  `cat_fill_f`/memmove 17% (pushes); frame 4.6% spills.
- **Havlak**: `node_with` + its memmove 20% (every `h.nbp.with(i, ..)` and
  friends on a frozen list copies a trie path), memset 12% (the seven
  `fill(size, ..)` tables per `find_loops`; C does the same zeroing, so
  verify once that Resid does not zero twice), `with_fresh`/`with_shared`
  5%, `append_core`/`concat_own`/`cat_like` 10%, `list_contains_int` 2%,
  `region_grow` 2%. Havlak is a list-ownership benchmark: its tables are
  owned by `Hf` and never shared, yet every write copies.
- **Json**: `c_strlen` 17%, `idx_slot_slow` 10% (both from one-character
  `str_slice` of the input and `str_len` of names), `resid_str_concat`'s
  memmove 17% (`p.cap + piece` accumulation), `append_core`/`flat_fill` 4%.
  The `Str` representation is 45% of Json.
- **Sieve**: builder 36% (`trues` pushes at 11 per element plus `lb_grow`
  doublings), first `clear` copies the 5000-element list once per run
  (`list_set_slow`, 12%: the builder's `finish()` result is not transient),
  outer loop 20 per prime candidate (overflow on `i-1`/`i+1`, bounds, flat
  test, due; C++ 6), inner clear loop 4 per element (already minimal, W3).
- **Bounce**: 60 per ball step (Rust 17). Word-count division 7%, overflow
  4.4%, transient tests 3.5%, due 1.8%, element bounds and root loads; the
  arithmetic with cmov about 25.
- **NBody**: 62 per body pair (Rust about 30): due 3%, the bounds `jae`,
  and stores of the four unchanged fields (`x`, `y`, `z`, `mass`) on every
  pair and move. Already 1.38x in ms.
- **Storage**: `lb_grow` 19%, memmove 15% (builder growth copies),
  the `build` recursion. Zig/Rust are 2x slower; Java's bump allocation
  leads.
- **List**: `is_shorter_than` is 6 instructions per step (two tag tests,
  two next loads); fewer instructions than every leader, 1.2x in ms from
  32-byte cons cells against 16-byte nodes (dependent loads, cache).
- **Mandelbrot**: tie; nothing legitimate remains.

The per-benchmark totals of the cost sources (hot functions, callgrind):

| Source | Richards | Permute | Queens | Towers | Bounce | DeltaBlue | Havlak | Json | Sieve |
|--------|---------:|--------:|-------:|-------:|-------:|----------:|-------:|-----:|------:|
| list access protocol (§2.1 rows 1-5) | ~55% | ~45% | ~45% | -- | ~35% | ~25% | ~10% | ~5% | ~15% |
| shared-list copies and pushes (trie path, with_shared, concat/append) | 6% | -- | -- | -- | -- | 20% | 35% | 4% | 12% |
| allocation | 1% | -- | 5% | 30% | -- | 3% | 5% | 5% | -- |
| call frames | 8% | 22% | 3% | 30% | -- | 10% | ? | ? | -- |
| region young/due/transient/flat/overflow checks | 7% | 10% | 15% | 3% | 17% | 6% | ? | ? | 10% |
| Str (strlen, codepoint index, concat copies) | -- | -- | -- | -- | -- | -- | -- | 45% | -- |
| builder growth (`lb_grow`, memmove) | -- | -- | -- | -- | 2% | -- | -- | -- | 36% |

("?" = not yet attributed; phase 0 completes the table for Havlak, Json,
CD, DeltaBlue, Storage.)

### 2.3 What this says

1. The list access protocol is the largest single cost on seven
   benchmarks and it is paid per access, not per check: 9-14
   instructions where the leader spends 2-3. Its parts are the
   two-object layout (header {count, shift/transient, root, type} and a
   separate data block), a count kept in words for inline records (a
   64-bit division per index), the flat-or-trie test, and share-on-read.
2. Writes to lists the program owns still copy: Havlak's trie path copies,
   Sieve's one thaw per run, Richards' `with_shared`, and every
   `concat([x])`. The ownership analysis stops at records; lists held by
   owned records are not yet owned.
3. Allocation is 20+ instructions for a bump; recursion frames carry
   runtime pointers that could be re-read from `%fs`.
4. `Str` as a bare NUL-terminated pointer is 45% of Json.
5. The remaining dynamic checks are 5-17%: worth taking only where a
   layout or ownership change removes them for free.

## 3. The changes

Ordered by the total instruction win the §2 budgets predict. Each names
the exact mechanism, the files, the measured basis, the predicted effect
per benchmark, and the risk. Predictions come from replacing the measured
per-operation cost with the target cost in the §2.2 budgets; they are not
guesses about unmeasured code.

### L1. List access: count in elements, one flag test, one object

Three layout steps, each measurable alone, in order of blast radius.

**L1a. Element count and kind flags in the header.** Today the header's
count is in words for inline-record lists (`lcount(l) / w` per index) and
the kind is a 64-bit type word tested by range (`raw_kind`), while
transient-vs-trie is a 32-bit shift field compared to -2. Change: the
header keeps the element count (`len()` is one load; `rt_list_rec_at`
multiplies by the static record size instead of dividing), and a flags
word carries transient, raw kind and "trie" as bits, so the hot test is
one `test`+branch. Files: `runtime/rt/list.resid` (`lcount`, `lshift`,
`ltransient`, `lraw`, `rec_words`, every walker that reads words),
`runtime/rt/map.resid` (`rt_list_with*`, `set_rec*`, `concat*`, `slice`),
`compiler/lower.resid` (`lw_index`, `lw_with`, the `lendiv` emission for
inline records, `ol_*` range facts which assume `len = words / w`),
`compiler/codegen.resid` declares. Effect from §2.1: inline-record read
11 -> 6, scalar read 9 -> 6. Richards about -25%, Bounce -12%, Queens
-15%, Permute -12%, DeltaBlue/CD -8%.

**L1b. One object.** Header and data in one block: `{len, flags, type,
elements...}`; a trie list keeps its root in the first element slot
behind the trie flag. A list value is the pointer; `with` on a transient
list writes in place at the same pointer; growth (`concat`, `push_rec`,
builders) returns a new pointer as it already returns a new header.
Effect: one load and the 32-byte root offset per access gone: inline read
6 -> 4, scalar read 6 -> 4; with L1a, Richards about -35% total, Permute
-20%, Queens -25%, Bounce -18%. Risk: every runtime function that takes
a list; `ListBuf`'s buffer becomes the list on `finish()` (it already is
the root today); region movers (`list_move`, `evac.*`) copy one block
instead of two. The conformance suite covers every element kind; crypto
and TLS cover `List(UInt(8))` at scale.

**L1c. Share-on-read gone for boxed records.** `s.pk[p]` clears the unique
bit of the element on every read (4 instructions) so that a later rebuild
cannot rewrite a record the list still holds. Under ownership (§L2) the
analysis knows whether the read is a borrow; the shared path keeps the
clear. Richards -3%.

Ceiling: L1a's win is computed from exact counts (the division and the
compare sequence are 8 of 11 instructions per access); no hack is
cheaper than building it. L1b is gated on L1a's measured result.

### L2. Owned lists: writes in place, pushes in place, no thaw

The ownership analysis (`compiler/own.resid`) tracks records; this
extends its verdicts to list fields and list-typed locals so that
lowering emits, on an owned list: `with` as a bounds check and a store
(no transient test, no write-back self-copy test, no list store-back
when the pointer cannot change); `concat([x])` as a push into spare
capacity (`rt_list_push_rec`/`pvec_append_into` without the copy when the
list is owned and has room; capacity in the L1 header); `finish()` of a
builder as a transient list (today the first `with` after `finish()`
thaws, Sieve 12%); and the trie path copy replaced by a flat in-place
write when the owned list is flat. Files: `compiler/own.resid` (tracked
value kinds, write summaries already carry `[` element writes),
`compiler/lower.resid` (`lw_with`, `lw_concat`, the `__o` instances),
`runtime/rt/map.resid` (push with capacity), `runtime/rt/list.resid`
(builder finish). Effect: Havlak -30% (node_with, with_fresh,
with_shared, half the appends), DeltaBlue -15%, CD -12%, Sieve -14%,
Richards -8%, Permute -8%, Queens -8%. Compile cost: the analysis
already computes element writes; the new verdicts add instances for
functions that write list fields, bounded by the existing caps.

Ceiling (one day, unsound): lowering flag that drops the transient tests
and write-back checks on every `with`, forces `finish()` transient, and
makes `concat([x])` a push when capacity allows. Must show at least
Havlak -25% and Sieve/DeltaBlue -12% before the analysis work starts.

### L3. Allocation fast path: 20 instructions to 6

`scope_alloc` (`runtime/rt/alloc.resid`) and the lowering around it
(`lr_call_allocs` meter, has-region flag) become: `p = %fs:bump; q = p +
size; if q > %fs:lim goto slow; %fs:bump = q; store header; store type`.
Mechanism: the runtime's TLS words addressed as local-exec thread-locals
(`mov %fs:off`) instead of through a base register; the loop meter
derived from `bump - start` at the loop's due test instead of an add per
allocation; heap mode (no region) sharing the same bump/limit pair with
`lim = 0` so it falls to the slow path without a flag test; the 16-byte
pad gone by sizing every block to 16 (the runtime's own allocations are
already multiples of 16 except odd-word records, which get one pad word).
Effect: Towers -18%, List -8%, Queens -5%, Richards -3%, DeltaBlue, CD,
Json, Storage -3-5%. Ceiling (half a day, unsound): patch `scope_alloc`
to the bare bump without meter, flag or pad, rebuild `rt.ll`, measure
Towers and List.

### L4. Calls: no runtime pointers live across calls, small callees inlined

Two parts. (a) The TLS base and the region/due pointers are computed at
function entry and kept in callee-saved registers across every call;
with L3's `%fs`-relative addressing nothing needs the base, and the due
test reads `%fs:rg_due` directly. Permute's frame drops from six saved
registers to the two the algorithm needs. (b) `lo_inline_prog` inlines
one-return helpers only at `return f(..)`/`T x = f(..)` sites; extend it
to a single-caller non-recursive callee of any shape when the body is
under a size (Towers' `move_top` into `move_disks`, Richards' `set_ab`,
`with_ts`, `tcb`, `pkt` chains) -- LLVM does not, because the bodies are
above its threshold until L1-L3 shrink them. Effect: Permute -18%, Towers
-20% (with L3: Towers about -40% total), DeltaBlue -8%, Richards -6%,
Queens -4%. Ceiling for (a): after L3's TLS change, measured directly;
for (b): a lowering flag that forces inlining of every single-caller
callee, measured on Towers and Richards.

### L5. `Str` with a length and an ASCII flag

A `Str` becomes a pointer to `{len, flags(ascii), bytes..., NUL}` (the
NUL stays, so the C-string ABI for native modules and the runtime's
syscalls keeps a `str_cstr` of zero cost). `str_len` is a load; an ASCII
string's `str_slice`/`str_char_at` is pointer arithmetic, no codepoint
index; `concat` copies known lengths. Files: `runtime/rt/text.resid`
(every `c_strlen` site, `idx_*`), `compiler/lower.resid` (string literal
emission with the header, `lw_str_*`), the `resid_str_*` builtins, the
provenance/driver code that hashes strings. Effect: Json -40% (strlen,
idx_slot and half of concat's cost), small gains anywhere strings are
compared or hashed (CD's map keys are records, not strings; Havlak none).
This is the one change whose win is confined to one benchmark; it is
built because Json's gap is 2.5x and the measured share is 45%.

### L6. Taken along, not built alone

- Range facts for the Sieve/Bounce overflow checks (`i-1`, `i+1` with a
  known lower bound): inside L1's rewrite of `ol_*`, where `len` is a
  header load. Sieve -5%, Bounce -4%.
- The loop due test as `%fs:rg_due` (L4a): 1-3% everywhere.
- Store only changed fields of a borrowed inline element in versioned
  loops (NBody's `x`, `y`, `z`, `mass` stores): NBody -8%.
- The 16-byte sum box (tag folded into the header word): List to parity
  in ms, Towers' `Disk` -4%. After L3, since both change the box header.
- Havlak's `fill`: check that a filled table is zeroed once.

### What is not done, with the measured reason

- Another pass over the young/transient/due checks on their own: 5-17%,
  below the gate everywhere; L1-L4 remove most of them as a side effect.
- Towers' three-way pile dispatch (15 of 75 per move): the port's record
  shape; ports are frozen.
- Queens' `Placed` return as a register pair: measured 3%.
- Inlining thresholds: Towers -15% but Queens +11%, Permute +27%.
- Per-object frees, `-O3`, link flags: measured earlier, nothing.

## 4. Where this lands

Instruction budgets after L1-L5, from the §2.2 numbers with each
operation at its target cost, and the ms it implies at today's IPC. The
"lead" column is honest: three benchmarks do not reach first place from
this plan alone.

| Benchmark | Now (per op) | After (per op) | Instr change | ms now -> est. | Leader | Lead? |
|-----------|-------------:|---------------:|-------------:|---------------:|-------:|-------|
| Richards  | 188 / step   | ~65            | -65%         | 98 -> ~35      | 22.0 (Zig); C++ 43.6, Rust 31.3 | ahead of C++/Go/Java; Rust close; Zig no (needs the dispatch flattened: 30/step is the algorithm) |
| Permute   | 76 / call    | ~32            | -58%         | 21.9 -> ~9.5   | 9.4  | parity |
| Towers    | 96 / move    | ~50            | -48%         | 15.8 -> ~8.5   | 7.2  | within 1.2x; parity needs the dispatch |
| Queens    | 56 / row, 150 / placement | ~24, ~55 | -55%     | 19.6 -> ~9     | 3.7  | no: 2.4x remains (recursion with a result record per call) |
| Bounce    | 60 / step    | ~34            | -43%         | 15.6 -> ~9     | 5.5  | within 1.6x |
| Sieve     | 338k / run   | ~170k          | -50%         | 27.0 -> ~13.5  | 10.2 | within 1.3x |
| Havlak    | --           | --             | -40%         | 115 -> ~70     | 32.3 | within 2.2x; IPC rises when copies go |
| Json      | --           | --             | -45%         | 29.1 -> ~16    | 11.5 | within 1.4x |
| DeltaBlue | --           | --             | -40%         | 28.3 -> ~17    | 4.9  | no: 3.5x remains; phase 0 must break execute/satisfy down first |
| CD        | --           | --             | -30%         | 42.4 -> ~30    | 15.1 | within 2x; map protocol next |
| NBody     | 62 / pair    | ~50            | -20%         | 9.4 -> ~7.5    | 6.8  | within 1.1x |
| Towers/List/Storage/Mandelbrot | -- | -- | List -8%, Storage -10% | -- | -- | List parity (sum box), Storage lead kept |

So: parity or the lead on Permute, NBody, List, Storage, Mandelbrot;
within 1.2-1.6x on Towers, Sieve, Json, Bounce; Richards ahead of all
but Zig; Queens, DeltaBlue, CD and Havlak remain 2-3.5x and need the
next plan (DeltaBlue's `execute`/`satisfy` and CD's map protocol are
not yet attributed; Queens is the recursion shape).

## 5. Phases and gates

**Phase 0: finish the attribution (1-2 days).** Exact budgets for
DeltaBlue (`execute`, `satisfy`, `recalculate`), CD (`put_into_map`,
`is_in_voxel`, `rb_put`), Havlak (`find_main`, `identify_edges`,
`dfs_outs`), Json (`read`, `string_loop`), Storage (`build`), Bounce's
full step, so the §2.2 table has no "?". Deliverable: the table and the
scripts under `bench/v2/tools/` (`cgaddr.py`, `cgfn.sh`, `classify.py`)
so every later round reports the same numbers. Also: Havlak's double
zeroing check. Note: Havlak, CD and NBody verify only at their listed
sizes, so a callgrind run at a small size does its work and then aborts
on the final check (`Benchmark failed with incorrect result`, a core
dump in the working directory to delete); the profile is still exact for
that size. Use Havlak 150, CD 10 or 100, and NBody at 5000 with the
abort expected.

**Phase 1: ceilings (3-4 days).** Built unsound, measured, not committed:
- L2 ceiling (lowering flag): Havlak, Sieve, DeltaBlue, CD, Richards.
- L3 ceiling (bare bump in `rt.ll`): Towers, List, Queens, Richards.
- L4b ceiling (force single-caller inlining): Towers, Richards, Permute.
- L5 has no cheap ceiling; its share is measured (45% of Json).
- L1a/L1b have no cheap ceiling; their share is measured per access.
Gate: a change is built only if its ceiling clears 20% on at least one
benchmark. Expected to pass: all four. A ceiling that fails sends its
item to "not done" with the number.

**Phase 2: L1a, then L3 and L4a (runtime and lowering, about 1.5 weeks).**
L1a first because every later measurement moves with it. L3 and L4a
together because both are the `%fs` addressing change. Reseed after each
(`rt.ll` and the seed together; lower `rt.ll` from the relative path).
Gate: Richards -25%, Towers -30%, Permute -20% instructions vs HEAD;
boot fixed point; all suites; resid-ddc.

**Phase 3: L1b and L4b (about 1.5 weeks).** The one-object list, then
the inliner extension once bodies are small. Gate: Richards -45%,
Permute -40%, Queens -35% cumulative.

**Phase 4: L2 (about 2 weeks).** Ownership of lists. The differential
fuzzer (`tests/own/fuzz.sh`, `gen.py`) gets list fields and
`concat([x])` shapes before the lowering lands; conformance cases for
each aliasing shape (a list field read while its record is rebuilt, a
list pushed while a slice of it is live, a builder finished twice).
Gate: Havlak -30%, Sieve -12%, DeltaBlue -12%; compile time within the
+5% budget on the self-compile; fuzzer 3000/3000.

**Phase 5: L5 (about 1.5 weeks).** `Str` header. Gate: Json -35%; the
TLS, crypto, provenance and pkg suites (strings cross every boundary);
native-module ABI unchanged (`str_cstr` returns the same bytes).

**Phase 6: L6 items as the profiles then show them**, and the next
attribution round for Queens, DeltaBlue, CD, Havlak.

Per step, as before: `instructions:u` on the whole set against a
baseline from the committed `stage2.bin` plus `-rtr` of a HEAD-lowered
`rt.ll`; cycles only on the idle core, best of three; `boot.sh` fixed
point; conformance, runtime, reduce, ct, graph, own suites; resid-ddc
reproduces `seed.ll` and `rt.ll`; an adversarial review of every
soundness argument (L1b's pointer identity for transient writes, L2's
aliasing shapes, L3's heap-mode fallback, L5's NUL and ABI) before the
commit.

## 6. Risks

- **L1b's blast radius.** Every runtime list function and every region
  mover. Mitigation: L1a first (header fields only), the conformance
  suite's per-kind coverage, and crypto/TLS as the large-list tests.
- **L2 precision.** If list fields of owned records do not resolve to
  owned at the hot sites (Havlak's `Hf`, DeltaBlue's `Db.vs`), the gain is
  Sieve-sized. The phase 1 ceiling is the check, and `--own-report`
  already lists why a site is shared.
- **L3's heap mode.** Programs without regions (the compiler's own
  passes, runtime code) must keep allocating; the `lim = 0` fallback is
  the invariant, tested by the runtime suite and the self-compile.
- **L5 and the ABI.** Strings reach native modules, syscalls and the
  provenance hash; the NUL stays and `str_cstr` is the header offset. The
  pkg, provenance and native tests are the gate.
- **Compile time.** L2 is the only analysis change; the others are
  lowering and runtime. Budget +5% of the self-compile, measured at each
  phase gate.

## 7. Results (2026-10-19, measured)

Instructions (`instructions:u`, whole run at the ReBench sizes) of the
final batch against HEAD f57dca3c. Every item went through the ceiling
gate first; the table at the end lists what failed it.

| Benchmark  | HEAD G | Final G | Change |
|------------|-------:|--------:|-------:|
| Json       |  0.710 |   0.487 | -31.3% |
| Towers     |  0.471 |   0.349 | -25.8% |
| Richards   |  1.999 |   1.592 | -20.4% |
| Queens     |  0.511 |   0.461 |  -9.9% |
| Bounce     |  0.432 |   0.394 |  -8.8% |
| CD         |  0.864 |   0.804 |  -7.0% |
| Havlak     |  1.531 |   1.426 |  -6.9% |
| Storage    |  1.224 |   1.153 |  -5.8% |
| DeltaBlue  |  0.469 |   0.443 |  -5.6% |
| Permute    |  0.659 |   0.625 |  -5.2% |
| NBody      |  0.192 |   0.184 |  -3.9% |
| Sieve      |  0.698 |   0.673 |  -3.6% |
| List       |  0.279 |   0.278 |  -0.1% |
| Mandelbrot |  0.130 |   0.130 |  -0.1% |

What is in the batch:
- **Element count for inline-record lists** (L1a): bits 0..30 of header
  word 12 (bit 31 stays the frozen mark), kept by `sync_elems` at every
  count or type write; `len()` is `resid_list_elems`, so an index check
  multiplies instead of dividing. Every loop-versioning text matcher in
  lower.resid had to learn the new call (NBody went +40% while one did
  not). The multiply-form bounds test (`i * w < n`) was tried first and
  lost: it stops LLVM removing the check in length-bounded loops.
- **Local-exec TLS** for the runtime's thread-locals (`%fs:off` instead of
  a base register): -2..-6% everywhere on its own.
- **`inline_small`** (driver tail): a program function with 1-3 call
  sites, at most 400 IR lines, not recursive alone or with one other
  function and never a musttail callee is marked `alwaysinline`.
- **Allocation fast path**: every region block is a multiple of 16
  bytes, so the per-allocation pad arithmetic is gone (`alloc_in` rounds
  the same way, keeping every bump 16-aligned); a size that wraps when
  rounded is refused on the slow path.
- **String length cache**: `str_len` of an all-ASCII string under 64
  bytes counts it directly instead of indexing it, and the index lookup
  finds an indexed string before scanning it. Json took the length of
  each short name and so evicted its long input from the two fast
  entries; every following one-character slice then rescanned 256 bytes.
- **Lazy assert messages**: an assert whose message is literals, names,
  fields and `+` builds it on the failing branch only (Json's `expect`).
- **Pointer compares before the region test** in in-place rebuilds raised
  from 3 to 8 fields (Queens' `Board`); the old cap existed for LLVM's
  inline threshold, which `inline_small` now overrides.

Red-team findings fixed before the final pass: `str_len` disagreed with
indexing on invalid UTF-8 (the short path is now ASCII only); the dropped
pad broke the 16-byte alignment of blocks after an `alloc_in`; the byte
meter behind `resid_mem_since_mark` stopped counting `resid_gmalloc`
(restored); `inline_small` had no size cap and no mutual-recursion guard.

Measured and not built (below the 20% gate, or a loss):

| Item | Result |
|------|--------|
| L2 ceiling: no freeze on store, transient builder results | 0..-2% |
| L2 as built: single-holder lists thawed in place on proved writes | net loss vs the batch (Sieve +7 pts, Havlak/DeltaBlue -2.5 pts) |
| L3 ceiling: runtime-only bare bump, no meter, no pad | Towers -5%, Havlak -6% (the pad part is in the batch) |
| L1b one-object list | about 1 load in 12 on the hottest reads; not built |
| Owned-instance clone cap 200 -> 600 | no change (DeltaBlue's `execute` gets no owned instance for another reason, open) |

Open, by measured share: DeltaBlue's `execute` (33%) runs header tests
because no `execute__o` instance is made although every report line says
in place; Richards' worker step copies `w.data` and barrier-moves the new
`Pkt` (~12%); Havlak's nested-list writes and table zeroing; Queens' row
reads (about 12 instructions each, the `List(Bool)` protocol).
