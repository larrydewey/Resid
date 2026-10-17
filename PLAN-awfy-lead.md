# Plan: taking the lead on Are We Fast Yet

Status 2026-10-16. Resid is the slowest compiled language on 12 of the 14
AWFY benchmarks in runtime mode, after four perf rounds that each won
20-50% and never changed that ranking. This document reviews those rounds,
says why they plateaued, and names the changes that will put Resid first on
every benchmark. Nothing here is implemented.

The target is the per-benchmark leader (not C++ the normalizer), in runtime
mode (`rt` inputs), with the language's semantics and safety intact: values
stay immutable and identity-free, overflow and bounds still abort, IEEE
order stays. Every change below is invisible to programs.

## 1. Where we stand

HEAD 3e44132f, this machine, core 0, `harness <B> 5 <inner>` at the ReBench
sizes, portable profile (`-O2`). Resid numbers are from this session; the
leaders were rerun the same way. Instructions are `perf stat -e
instructions:u` for the whole 5-iteration run.

| Benchmark  | Resid ms | Resid instr | Leader | Leader ms | Leader instr | Time gap | Instr gap |
|------------|---------:|------------:|--------|----------:|-------------:|---------:|----------:|
| Richards   |    215.8 |      20.2 G | Zig    |      20.6 |       1.63 G |   10.5x  |   12.4x   |
| Towers     |     48.1 |      5.39 G | Zig    |       7.0 |       0.78 G |    6.8x  |    6.9x   |
| Queens     |     21.9 |      3.60 G | Zig    |       3.6 |       0.46 G |    6.2x  |    7.8x   |
| DeltaBlue  |     26.2 |      2.57 G | Rust   |       4.8 |       0.59 G |    5.4x  |    4.4x   |
| Permute    |     40.9 |      6.91 G | Zig    |       9.1 |       0.90 G |    4.5x  |    7.7x   |
| Bounce     |     20.7 |      2.73 G | Rust   |       5.2 |       0.87 G |    4.0x  |    3.1x   |
| Sieve      |     37.0 |      5.48 G | C++    |       9.8 |       1.18 G |    3.8x  |    4.7x   |
| Havlak     |    115.0 |      8.01 G | Rust   |      31.3 |       3.54 G |    3.7x  |    2.3x   |
| Json       |     38.7 |      4.70 G | Zig    |      11.1 |       0.84 G |    3.5x  |    5.6x   |
| NBody      |     23.2 |      3.19 G | Rust   |       6.6 |       0.49 G |    3.5x  |    6.6x   |
| CD         |     43.4 |      4.53 G | Zig    |      14.7 |       1.40 G |    3.0x  |    3.2x   |
| Storage    |     51.8 |      6.85 G | Java   |      22.9 |         JIT  |    2.3x  |     --    |
| List       |     17.5 |      2.61 G | Zig    |      10.7 |       1.61 G |    1.6x  |    1.6x   |
| Mandelbrot |     26.8 |      0.65 G | Zig    |      26.5 |       0.72 G |    1.0x  |    0.9x   |

(Java's Storage number is from the 2026-10-13 run, same core class; Resid is
second there, ahead of every native language.) IPC is 4.5-7 everywhere but
Havlak (2.9, list copies missing cache) and Mandelbrot (1.0, a dependency
chain every language shares). The gap is instruction count: the runtime's
per-operation protocol.

## 2. What was tried, and what each round bought

In order, with the measured effect (instructions, `-rtr` baseline rule from
AGENTS.md). Commits 77600131, 6a7d0ba8, 3775977a, 9432acf5, 3e44132f and
the shelved 361678ba; details in the commit messages.

1. **Link flags** (SLP off, store merging off, inline thresholds 1000/5000,
   `-O3`, ordered reductions): nothing, or a loss; `-O3` mixed (Towers
   -12%, NBody +4%). Not a lever: the IR is the problem, not LLVM.
2. **Lazy loop regions, inline allocation on a failed reuse, barrier early
   return** (77600131): NBody 1.87 G to 0.65 G, CD 2.17 to 0.97 G, Permute
   3.87 to 1.93 G, Queens 1.65 to 0.93 G, DeltaBlue 1.35 to 0.77 G. The
   largest round, and it removed bookkeeping around the protocol, not the
   protocol.
3. **Cheaper dynamic checks** (interned False/True/0.0 so `word_static`
   folds; `resid_list_with_i64/bool/f64` with one range test; the young
   region id precomputed in TLS word 13): Permute -26%, Sieve -19.5%,
   Queens -17%, others 2-4%.
4. **A "young window" of the top page run** instead of the page-table
   lookup: lost. Rebuilt-in-place records stay in old page runs forever.
5. **In-place records through owned lists** (`lo_borrows`, `get_own`,
   `with_fb`, `rec_reuse_sc`): Bounce -30%; Richards, DeltaBlue, CD within
   1%. Too few sites qualify: one take per list per block, no take across
   a call, the record's fields read after the write-back disqualify it.
6. **"Takes" in general** (361678ba, shelved): a record may stay unique
   inside a transient list; every other element read shares it. Bounce
   -33%, but the headers and read-shares cost NBody +6%, DeltaBlue +8%,
   Richards +3%. A dynamic share-on-read protocol taxes every read to make
   a few writes cheap.
7. **Storing only the changed fields on a reuse**: lost 3-12% everywhere.
   The reuse is a runtime branch, so the literal needs two code paths.
8. **Dropping the share on a read of a linear local**: unsound (the list
   still holds the record) and crashed as it should.
9. **`rec_reuse_eq` over more than 3 pointer fields**: Queens +6% (Queens'
   `set_rc` crossed LLVM's inline threshold). Young test first, or the
   allocation out of line: lost on Richards. Every inline fast path is
   fighting the inliner for the same budget.
10. **Any-age reuse when the pointers come back unchanged**: DeltaBlue +34%
    at the official size. The state record stays old, so every fresh young
    `Var` stored into it is barrier-moved (899k moves against 323k). Cured
    by the graph inliner `lo_inline_prog` (DeltaBlue -33%, Richards -15%)
    only because the inlined helpers let `lo_borrows` see the take.
11. **Bool unbox as an address compare**: +12% instructions on Queens, no
    cycle gain. Reverted.
12. **`resid_str_eq` inline** (pointer, first byte, then strcmp): Json -13%.
13. **Unboxed `List(primitive)` judged "would barely help"** on Sieve:
    its clear loop is 13 instructions per element and none is boxing (two
    overflow checks, the transient test, bounds, a root reload). True of
    the count, and it hid the real point: the store is a tagged pointer,
    so the loop can never be a byte store that LLVM vectorizes.

Cumulative since 2026-10-12: 2-3x on most benchmarks. Remaining gap: 3-12x
instructions. The memory note of 2026-10-13 already measured the ceiling of
this road: "within the current record/list semantics the ceiling is about
1.7x" of what a perfect lowering of the same protocol could drop. Every
round since has confirmed it. The rounds trimmed the dynamic value
protocol; none removed it, and it is the protocol that costs 3-12x.

## 3. What one operation costs today

From the emitted IR of `bench/v2/t1-awfy/resid/out/harness.ll` at HEAD,
and the flat profiles (every benchmark spends 85-99% in its own inlined
code; the runtime shows up by name only for copies and moves).

- **Richards `hold_self`** (one field assignment, `t.holding = true`, plus
  `s.next = t.link`, `s.hold += 1`): `resid_list_get_own` (bounds,
  flat-or-trie, transient test), the `tcb` call (`rec_reuse_sc` header
  compare, then 10 stores: every field of the Tcb is rewritten), 
  `resid_list_with_fb` (owned, transient, bounds, "already in its slot"
  test), `resid_rec_reuse_eq` on the Rs (two pointer compares, header
  compare, the young page-table lookup) and 8 stores of the Rs. About 120
  instructions. C++: two stores and an increment. Zig's whole Richards
  run is 1.63 G instructions; Resid's `schedule` alone rebuilds the Rs
  twice per step (`rec_new(64)` twice, `reuse_eq` once) and the loop
  region evacuates it (`resid.rec.evac.Rs`) at every compaction.
- **Permute `swap`**: two `resid_list_get` + `resid_unbox_i64`, two
  `resid_list_with_i64` (owned, transient, bounds, 54-bit range test, add
  the immediate offset), `rec_reuse_eq` on the 2-field St. 160 instructions
  per `permute` call against C++'s and Zig's 21.
- **Sieve `clear`**: `ssub` overflow check, `resid_list_with_bool` (three
  tests, then a store of `interned() + v*32`, a pointer), `sadd` overflow
  check. 13 instructions per element, and the store is 8 bytes of pointer,
  not a byte.
- **NBody `pairs`**: both bodies are read with `resid_list_get` (shared:
  two takes on one list is outside `lo_borrows`), so each pair allocates
  two 56-byte Body records (`resid_gmalloc`) and writes them back through
  `resid_list_with_f` with the evacuation barrier; the loop carries
  `resid_loop_due`/`resid_loop_move`/`resid_mv_list_f` on both back edges.
  2,550 instructions per step against Rust's ~390.
- **Towers `push_disk`**: a call to `pile_of`, the sum tag load,
  `resid_unbox_i64` of the disk size (a tagged word inside the sum),
  `resid_box_i64` + `resid_box_alloc(2)` for the new Disk, a call to
  `with_pile` (Piles rebuilt), then `move_top` rebuilds the Piles again for
  `moves + 1`. 219 instructions per move; Zig: 32.
- **Json `read`**: two `resid_str_eq` on the one-character `current`, a
  `str_slice` call for the next character (the input's codepoint index is
  11% of the run, `idx_slot_slow`), `rec_reuse_eq` with three pointer
  compares and 9 stores for the Ps record. Scope push/pop around calls add
  7%.
- **Storage `build`**: two `resid_listbuf_new`, `lb_grow` (21%) and
  `memmove` (12%) because every leaf of 1-10 elements grows from an empty
  buffer, `resid_gmalloc` for the Built record, `resid_box_alloc` for the
  Tree sum, `resid_list_freeze`.
- **Havlak**: `memset` 7%, `memmove` 5%, `node_with`/`set_leaf`/`with_shared`
  (trie path copies of lists past 64 elements), `with_fresh` (a whole copy
  on the first owned write to a frozen list), `resid_list_concat_own` 4%
  (`xs.concat([x])` allocates a one-element list, then appends), `t_rebuild`
  (the Map).
- **DeltaBlue**: `memmove`, `append_core`, `list_move`, `bar_move_f`,
  `resid_mv_rec`, `flat_copy`, `flat_fill`: about 25% of the run is copying
  and moving lists between regions.

Three cost sources, all in the value representation and its runtime
protocol:

A. **Boxed and tagged slots.** A list slot is a tagged word (an immediate
   for a 54-bit Int, a pointer to a box otherwise); a sum payload is a
   tagged word; a record inside a list is a pointer to a separately
   allocated record. Reads unbox and branch, writes box or range-test,
   `Float`s and records allocate, and no loop over a `List(Bool)` or
   `List(Float)` can vectorize.
B. **Dynamic uniqueness.** Whether a value may be rewritten in place is
   decided at run time: the record header's unique bit, `ltransient` on
   the list, the young region test, the barrier moves, share-on-read. Each
   rebuild copies every field because the fresh-allocation path needs them
   all. The state record threaded through every call (Rs, Db, Hf, Ps, St)
   is rebuilt at every step, and the loop region evacuates it.
C. **Unhoistable per-element checks.** Bounds, transient, overflow and
   the buffer root are retested per element because nothing proves them
   loop-invariant, and the loop region bookkeeping sits on every back edge.

## 4. What will take the lead

Four changes. Each removes a cost source rather than discounting it; the
first two are the large ones. They compose, and the per-benchmark section
says which benchmark needs which.

### W1. Typed flat storage

The list header's `type` word already names the element type. Use it: a
`List(Int)` holds raw `i64` slots, `List(Bool)` raw bytes, `List(Float)`
raw doubles, and a list whose element is a plain struct (scalar fields
only, `lo_plain`) holds the records inline, field after field, with no
header and no pointer. Sum payloads are laid out like record fields (raw
scalars, pointers for the rest), one layout per variant. `ListBuf(T)` and
the trie nodes use the same slot size, so a large list keeps the same
layout. Pointer-element lists (Str, header records, sums, nested lists)
keep today's word slots.

Then: `xs[i]` is a load, `xs.with(i, v)` on an owned list is a store,
`bs[i].x` is one load at a computed offset, `bs.with(i, Body {..})` is 7
stores (or, with W2, only the changed fields), no `Body` record is ever
allocated, `Disk(size, rest)` is a 24-byte object whose `size` is read
without a tag test, and a `List(Bool)` loop stores bytes.

Cost: every runtime path that walks slots generically (eq, hash, show,
to_array, slices, concat, trie append, persist copies, CBOR, `for ... in`,
the LSP/graph tools' value printing, the reducer's value model for
compile-time lists) dispatches on the element kind. The reducer and
resid-ddc must agree on the layout only where a literal is emitted
(`const_boxes`, list literals in IR). The compiler already distinguishes
`i64/bool/f64` elements (`lw_hdr_elem`, `lo_plain`, the `_i64/_bool/_f64`
writes), so the static side exists; the runtime side is the work. Days,
not weeks.

### W2. Static ownership across calls

Make uniqueness a compile-time fact for the values it matters for, so the
fast path has no header test, no transient test, no young test and no
copy of unchanged fields.

The analysis exists inside one function (`lo_*`: linear locals, owned
`with`, borrows, `lo_fix`'s fixed point over the program). What is
missing is the calling convention: a parameter the callee consumes
linearly is still a *maybe-shared* record, so every literal built from it
tests the header at run time. The change:

1. **Owned parameter modes.** For each tracked parameter and each call
   site, decide statically whether the argument is uniquely owned at the
   call (a linear local or parameter that is itself owned, or a fresh
   literal, with no other live mention). A whole-program fixed point over
   the call graph, as `lo_fix` already runs; recursion and the AWFY
   call chains (`schedule -> run_task -> run_fn -> handler_fn -> set_ab ->
   with_ts`) resolve to owned on every edge.
2. **Ownership specialization.** A function called with an owned argument
   at some sites and a shared one at others is emitted twice, as the
   reducer already emits `f__rsN` specializations. The owned copy's
   literals built from the parameter become stores of the changed fields
   into the parameter's memory: `Rs {.pk = s.pk, .ts = ts2, ..., .next =
   x}` is two stores. No `rec_reuse*` call, no header word read.
3. **Transitive ownership.** Inside an owned record, a list field that was
   never shared out is owned too, and so is a record read from it by a
   take; `s.ts[s.cur]` followed by `s.ts.with(s.cur, t2)` with `t2` built
   from the element is stores into the element and nothing else. This
   subsumes `lo_borrows` (one take per list per block, no take across a
   call) by carrying the fact through calls and across two takes on one
   list (NBody's `a`/`b`).
4. **The region question.** In-place update of an old record with a
   pointer to a younger value is what the young test and the barrier
   guard. Keep both only where a pointer field receives a fresh
   allocation; scalars and pointers already in the record need neither
   (today's `rec_reuse_sc`/`rec_reuse_eq` logic, decided statically).
   Where a fresh value does enter an owned old record, allocate it in the
   record's region (`region_use` exists for owned lists) rather than
   moving it afterwards. DeltaBlue's 899k barrier moves were exactly this
   case.
5. **Shared stays as today.** Every value the analysis cannot prove owned
   keeps the current dynamic protocol, so no program gets slower; the
   headers and share-on-read remain for the shared world. The shelved
   "takes" design (361678ba) is the dynamic half of this; it lost because
   it taxed reads to pay for writes. Static ownership taxes nothing.

What this buys: a field assignment in Richards, DeltaBlue, CD, Havlak,
Towers, Json and Permute becomes what it is in Zig, a store. The threaded
state record stops being rebuilt. The inliner then sees small bodies and
inlines `tcb`, `pile_of`, `with_pile`, `set_ab` (today they are out of
line because the reuse fast paths bloat them).

Soundness argument, for the red-team pass: a value is rewritten only when
the compiler proved it has one holder and that holder is the expression
being built. With no mutation and no identity in the language, the rewrite
is unobservable by construction, as `lo_borrows` already argues; the new
part is the interprocedural proof, which is a standard move analysis.
Closures (`gk_closure_facts`), spawn bodies, Maps and persist copies are
boundaries where ownership ends (argument is shared).

Estimated effort: the largest item, two to four weeks: the analysis, the
specialization plumbing in lowering, the region rule, tests for every
aliasing shape (two holders, a take across a call, a record kept in a sum,
a list shared then written, loop-carried ownership), resid-ddc.

### W3. Loop versioning and range facts for owned-list loops

For a self-tail loop (or `for`) over an owned flat list where the loop
body's index expressions are affine in the induction variables: emit one
guard at entry (list is transient and flat, `len` and the buffer root are
loop-invariant, index bounds and the induction arithmetic cannot overflow
given the entry values), then a body with plain loads and stores and no
checks; the fallback is today's checked loop, which aborts at the exact
element the spec names. Range facts already exist for `str_char_at`; extend
them to `xs[i]` on typed lists (W1 removes the map-index ambiguity) and to
`for (i in a..b)` bounds. After W1 the Sieve clear loop is `buf[k-1] = 0`
with stride `i`, Permute's swap is four scalar memory operations, Queens'
`get_rc` three byte loads; LLVM vectorizes the stride-1 cases.

Also: the loop region's `loop_due`/`loop_move` on every back edge becomes
one check per N iterations or moves to the exit path when the body is
proven not to allocate (W1 and W2 make most AWFY loop bodies allocation
free).

### W4. Allocation shape

Small, independent items that the profiles name directly:

- `xs.concat([x])` lowers to an owned push (`resid_list_push`-style, in
  place when transient with capacity) instead of a one-element literal
  plus concat. DeltaBlue, Havlak, Json objects.
- `ListBuf` with a known or likely final size allocates it once (a size
  hint from `list_fill`-shaped loops; Storage's leaves and 4-child nodes).
  A list literal of n copies of a scalar is one allocation and a memset.
- The first owned write to a frozen list copies the whole list
  (`with_fresh`) and a shared write past 64 elements builds a trie. With
  W2 these happen once per list instead of once per iteration, but a
  frozen list owned by an owned record (Havlak's `nbp`/`bp`) should thaw
  in place: the freeze/thaw bit, not a copy.
- `Str` gets a header (byte length, ASCII flag) so `str_len`, `==`,
  `str_slice` and `str_char_at` are O(1) without the codepoint index LRU.
  Json's `read` keeps `current` as a one-character Str because the
  reference (`JsonPureStringParser`) does; with a header, a one-character
  slice of an ASCII input is a pointer and a length, no index build.
  This is an ABI change for every runtime string path and for the `-rtr`
  baseline rule; do it after W1/W2 so the measurements stay comparable.
- Sum payloads: part of W1.

## 5. Per benchmark

Leader, what the gap is made of, what closes it, and where Resid lands.
Landing estimates assume the leader's instruction count as the floor and
Resid's IPC as it is; they are estimates, to be replaced by measurement.

- **Richards** (Zig, 10.5x). Every scheduler step rebuilds about eight
  records and the Rs twice. W2 alone turns that into stores; W1 removes
  the `List(Int)` data boxing in `worker_fn`. Expected: within 1.3x of Zig,
  the lead over C++, Rust and Go; the lead over Zig needs the inliner to
  flatten the task-function dispatch as Zig's `switch` does.
- **Towers** (Zig, 6.8x). Disk allocation plus two Piles rebuilds per move.
  W1 (raw payload in `Disk`, no box) and W2 (Piles unique through
  `move_disks`): one 24-byte bump allocation and three stores per move.
  Zig frees an arena per iteration; Resid's loop region is the same cost.
  Expected: parity to a small lead.
- **Queens** (Zig, 6.2x). Three `List(Bool)` writes and three reads per
  placement through the full protocol, Board rebuilt per `set_rc`. W1 + W3
  (byte stores, hoisted checks) + W2 (Board unique through recursion).
  Expected: parity.
- **DeltaBlue** (Rust, 5.4x). A quarter of the run copies lists between
  regions; the rest is Var/Con/Db rebuilds. W2 (the Db threaded uniquely,
  allocation into the Db's region), W4 (`cons.concat([ci])` as push).
  Expected: within 1.2x of Rust; ahead of Zig and C++.
- **Permute** (Zig, 4.5x). Two reads, two writes, one St rebuild per swap:
  W1 + W3 + W2. Expected: parity (the work is four memory operations).
- **Bounce** (Rust, 4.0x). Already a borrow site; remaining cost is the
  Ball record allocation and the loop region. W1 (Balls inline in the
  list) and W3. Expected: parity.
- **Sieve** (C++, 3.8x). W1 + W3: a byte store loop with hoisted checks.
  Expected: parity or better; the flags test loop vectorizes.
- **Havlak** (Rust, 3.7x). List copies and trie paths on frozen lists,
  `concat([x])`, the Map rebuild. W2 (Hf owned so its lists stay
  transient), W4 (push, thaw in place). Expected: within 1.3x of Rust;
  the Map(Int,Int) against Rust's HashMap decides the rest.
- **Json** (Zig, 3.5x). Ps rebuild per character (W2), string compares and
  slices (W4's Str header), scope push/pop around scalar-returning calls
  (fewer once bodies stop allocating). Expected: within 1.3x of Zig.
- **NBody** (Rust, 3.5x). Two Body allocations per pair, barrier stores,
  loop evacuation. W1 (Bodies inline, 7 doubles each) + W2 (two takes on
  one owned list) + W3. Expected: parity; the arithmetic is identical.
- **CD** (Zig, 3.0x). Red-black tree nodes as records in a list (W2 for
  the rebuilds, W1 for `V2`/`V3` keys and vectors inline), `concat([x])`
  pushes (W4), fdlibm sin/cos stays (the port's own, bit-exact). Expected:
  within 1.3x of Zig.
- **Storage** (Java, 2.3x; Resid already first among native languages).
  W4 (exact-size leaves, memset literal) and W1 (`Leaf(List(Int))` raw
  slots) take out `lb_grow` and `memmove` (33% of the run); W2 removes
  the Built rebuild. Java's bump allocation and no frees is the same cost
  model as Resid's regions. Expected: the lead.
- **List** (Zig/Rust, 1.6x). Cons cells are 32 bytes with a tagged
  payload against 16-byte nodes; W1's raw payload and a 16-byte sum box
  (tag folded into the header word) close it. Expected: parity.
- **Mandelbrot** (tie). Instruction count is already below every leader;
  the loop is a floating-point dependency chain all languages share.
  Nothing legitimate remains: fused multiply-add would change the
  verified checksum, and interleaving pixels is a program change the
  rules forbid. Report the tie.

Net: W1+W2+W3 are needed for every object-graph and scalar-list benchmark;
W4 finishes Havlak, DeltaBlue, Json, Storage and CD. Without W2, the
ceiling stays where the 2026-10-13 note measured it.

## 6. What will not work (so no round repeats it)

- Another pass over the dynamic checks (cheaper `young`, fewer compares,
  smarter barriers). Rounds 3, 4, 7, 9 and 11 are the evidence; each
  saved single-digit to 25% and the ranking never moved.
- Dynamic share-on-read to widen in-place updates (the shelved takes):
  it taxes every read.
- Flags and thresholds; `-O3`; forcing inlining. The bodies are too big
  because of the protocol, and they shrink only when the protocol goes.
- Rewriting the ports. They follow the reference's structure and the
  Rust port uses the same arena-of-indices mapping and leads; the Json
  `Str current` is the reference's own choice.
- Dropping checks the spec requires. Bounds and overflow stay; they are
  hoisted or versioned, never removed without a proof.

## 7. Order and verification

1. W1 first: it is mechanical, measurable alone, and it makes W3 possible
   and W2 cheaper (fewer pointer fields, fewer barrier cases). Reseed.
2. W3 on top of W1, with the Sieve/Permute/Queens loops as the test.
3. W2, in stages: owned parameter modes and specialization for records
   (Richards, Towers, Json, Permute), then transitive ownership through
   lists (NBody, Bounce, CD, DeltaBlue), then the region rule.
4. W4 items as each profile asks for them; the Str header last.

For every step: instructions:u on the whole AWFY set against a baseline
built from the committed `stage2.bin` + `-rtr` of a HEAD-lowered `rt.ll`
(never wall time alone); `boot.sh` fixed point; conformance, runtime,
reduce, ct and graph suites; resid-ddc reproduces `seed.ll` and `rt.ll`;
new conformance cases for every aliasing shape the change relies on
(following `owned_elem_borrow`, `owned_elem_borrow_lists`,
`reuse_in_sum`); an adversarial pass over the ownership proof before any
of it is called done. Compile time is a second gate: the specialization
in W2 must not reopen the quadratic cliffs closed on 2026-10-12.

## 8. Risks

- W2's analysis precision: if too few call edges resolve to owned, the
  shared specializations dominate and the gain is Bounce-sized again.
  Mitigation: measure the owned-edge fraction on the AWFY programs before
  building the lowering; the ports are written so that the state flows
  linearly, so the fraction should be near one.
- Code size from specialization: bounded by emitting the owned copy only
  for functions with a tracked parameter that is written.
- W1's blast radius in the runtime: every generic slot walker. Bounded by
  a single element-kind dispatch helper and the existing suites (the
  conformance suite covers lists of every element type; crypto and TLS
  exercise `List(UInt(8))` heavily).
- The region rule: allocating into an older region from an owned update
  must keep "no object points into a younger region"; `region_use` is the
  existing mechanism and the device/TLS code paths do not touch it.
