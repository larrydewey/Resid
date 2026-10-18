# Plan: ownership in the graph IR

Status 2026-10-17. Nothing here is implemented. This plan replaces W2
stages 2 and 3 of `PLAN-w2-ownership.md` and takes over the remaining
object-graph gaps of `PLAN-awfy-lead.md`.

The goal is the AWFY lead on the object-graph benchmarks (Richards,
DeltaBlue, Towers, Queens, Permute, Json, CD, Havlak, NBody, Bounce)
without touching the language. Values stay immutable and identity-free.
Overflow and bounds still abort at the exact element the spec names. IEEE
order stays. Capabilities, sandboxing, secret typing, constant-time code
and provenance all keep their guarantees.

## 0. What the programmer sees: nothing

Ownership is inferred and checked entirely by the compiler. The plan adds
no syntax, annotation, keyword, type, or error a program can trigger.
Every program that compiles today compiles unchanged and prints the same
output. The only observable difference is speed and memory.

- No `&`, `&mut`, `move`, lifetimes, or ownership annotations. A value can
  be used after it is passed anywhere, as today. The compiler decides per
  use whether that use is the last one.
- No new user diagnostics. When the checker in §4 rejects the inference's
  output, that is a compiler bug. It stops the compile with an internal
  error naming the function, like the existing `lw_args` cross-check
  ("internal: record ownership analysis disagrees"). It never asks the
  programmer to change anything.
- Code the analysis cannot prove keeps today's dynamic protocol. A program
  never gets a compile error or a slowdown from being hard to analyze.
- Developer tooling only: `--own-report` prints the inferred modes and the
  owned-edge fraction (§9, phase 1). `resid-why` gains a note kind that
  says which use made a value shared. Neither is part of the language.

## 1. Why the staged W2 path stops short

Stage 1 (`su_*`, a736cda3) bought Richards -14.9%, Bounce -11.2% and
Permute -3.3%. The structure limits what its successors can add:

- It is a side analysis inside lowering, keyed by variable *name*. A name
  bound twice, a pattern or closure parameter, a method-style call, or a
  variable bound outside a loop all end it.
- It only deletes a runtime test where it can prove the test would pass.
  Every literal still copies every field (`lw_fstores` over all of
  `fv.st`), and the state record is still rebuilt.
- Copies (`f__su`) are refused for recursive functions, so recursive
  chains such as Towers' `move_disks` and Queens' placement never get one.
- It knows nothing of regions. A fresh pointer stored into an owned record
  keeps the young test (`resid_rec_reuse_ny`) or the barrier
  (`bar_keep_f`). DeltaBlue's 899k barrier moves came from exactly that.

The measured ceiling of "delete every reuse test" (no proof, crashes on
three benchmarks) is Towers -44%, Json -34%, Richards -32%. Even unsound,
deleting tests isn't enough: what remains is whole-record rebuilds,
barrier moves, evacuation of the threaded state, and bodies too big to
inline. The fix has to change what is emitted, not which test is skipped.

## 2. The model

### 2.1 Tracked values

Ownership is tracked for values whose representation can be written in
place:

| Kind | Representation (today) | In-place write |
|------|------------------------|----------------|
| header record | pointer; header word has the UNIQUE bit (`rt_rec_new`) | field stores |
| inline record | slot run inside a list (W1 phase B, type word 17+) | field stores at `rec_at(i)` |
| plain record | `resid_gmalloc` block or frame slot (flag 16) | field stores |
| list | 32-byte header, `ltransient` = shift -2 | slot store, push |
| Map / Set | handle with `transient` and an edit token | `owned = 1` puts |
| sum box | tagged box, raw payloads (84d7cd85) | payload stores (§6.4) |

`Str`, `Dec`, scalars and builders are not tracked. `Str` is never written
in place, and builders are already linear by construction.

### 2.2 Modes on uses

The pass gives every use of a tracked value (an edge from a use node to
the binder it resolves to) exactly one mode:

- **read**: a field or element read of a scalar, or of a value immediately
  consumed by another read. No holder is created.
- **borrow**: the value is handed to something that only reads it while
  the current holder keeps it. Examples: an argument at a parameter the
  callee only reads, or `T t = xs[i]` while `xs` stays live and `t` is
  never written.
- **move**: the last use on every path. The value goes to its single next
  holder: an argument at an owned parameter, a `return`, the source of a
  rebuilding literal, `xs.with(i, v)` with `xs` owned, a binding, or a
  field of a fresh or owned record.
- **share**: anything else. A second holder may exist afterwards (both
  stay live, it is stored into a shared container, captured, spawned,
  persisted, or passed to a native module or device verb).

The analysis also gives every value a state at each program point:
**owned** (one holder, the current frame), **borrowed** (read-only, an
owner elsewhere keeps it alive), or **shared**.

### 2.3 Invariants the lowering relies on

- **I1 (the dynamic world is left exactly as it is).** Static ownership
  never reads a dynamic bit, and never creates a bit state today's
  lowering would not create for the same expression:
  - Owned code sets UNIQUE and `ltransient` exactly where today's
    lowering does (a record starts UNIQUE only for a type with tracked
    fields and lo flag 1; a list is transient where today's owned
    updates make it so). A record that today would be created shared is
    created shared in owned code too, even though static code writes it
    in place.
  - At every point where a value passes into code that may trust a bit
    (a shared instance, a store into a container, a capture, a spawn),
    owned code emits the same share or freeze operation today's lowering
    emits at that kind of site (`lo_freeze`, `resid.rec.freezef.T`,
    `rt_list_get_sh`, the `_f` list paths).
  - A thaw is today's first owned write, done once at the call:
    `with_fresh_f` for a list, a fresh shared copy for a record,
    `rt_map_transient` with a new edit token for a map. Static code treats
    every child of a thawed or shared object as shared (instance shape
    `top`, §3.5).

  So every invariant the dynamic protocol relies on (share-on-read for
  list elements, `freezef` at stores, UNIQUE only on tracked-field types)
  holds after this plan exactly as it holds before it, with no new bits to
  keep coherent. Static code needs no bits: its writes are justified by
  the analysis alone, and the checker re-proves them. Whether today's
  dynamic invariants are themselves complete (the fifth review asked
  about sum payloads holding header records, and `concat`/`slice`/`sort`
  copying UNIQUE elements without a share) is a question about the
  current compiler, not about this plan. Phase 1 audits it separately
  (§9) and fixes any hole it finds on its own.

  *Headerless* objects (records of types outside `LOP.hdr`, allocated
  with `resid_gmalloc` and no header word, and sum boxes) have no dynamic
  bit, and dynamic code never rewrites them in place. That holds because
  `LOP.hdr` (built by `lo_hdrs`, lower.resid:8582, from the types some
  literal may reuse, `lo_rl`) decides at `lw_struct` which types get a
  header, and only those reach the reuse branch, which itself has no
  header test (lower.resid:270-284). Checker rule 14 checks it against
  `lo_hdrs`. (In the compiler, `lo_plain` means "has a header":
  `lop.hdr.contains`. This plan never uses "plain".) Nothing on the
  runtime side ever *selects* spine objects by their bits: the spine is
  static (the push mover, §6.2).
- **I2 (no live pointer into a freed region).** When a region is popped,
  merged or compacted, no object that stays live outside it points into
  it. Owned code keeps this by two facts. First, every owned object it
  writes in place lives in the innermost region: it was created there, or
  it was moved there when its loop region was pushed (§6.2). Second, an
  owned object written inside a scalar scope while living in an older
  region is dead when that scope pops, which §6.2's escape rule
  guarantees. So a store into an owned object needs no young test, no
  barrier and no move, and runtime-internal allocations made for an owned
  object (buffer growth, map nodes) land in the innermost region, which is
  that object's own.
- **I3 (read before write).** Lowering emits the in-place stores of a
  moved object only after every read of its old fields that the value
  semantics orders before them. The stores happen at the *commit point*
  (the rebuilding literal, or the `with` that writes an element back).
  Every field value they use is in an SSA register by then.

I1 and I2 are what a red-team must break. §7 lists the attacks.

## 3. Inference: `compiler/own.resid`

A new module, imported from the driver tail next to `verify_pins.resid`.
It runs inside `lw_program` (lower.resid:9421) after `lo_inline_prog` and
in place of `lo_program` (lower.resid:7541)/`su_clones`. Its input is the residual graph with
the inliner's helpers already folded in, which is what made DeltaBlue's
takes visible (`lo_inline_prog`: DeltaBlue -33%).

### 3.1 Inputs

- Def edges from `kg_resolve_only` on the residual graph, as `dv_post`
  already does (device.resid:53). Every use resolves to its binder *node*,
  never to a name, which ends stage 1's duplicate-name exclusions.
- Types from the reducer's residual nodes and the `Funcs` table from
  `lw_sigs`.
- The capability facts and sandbox grouping. Instances (§3.5) of a
  function inside a `sandbox` node are added inside the same node, so they
  inherit the ceiling and get their own `.sb` wrapper.

### 3.2 Per-function analysis

For each function instance:

1. **Control flow.** Build the CFG of the body at *expression*
   granularity, in evaluation order (arguments, fields, list items and
   operands left to right, as lowering emits them): blocks, `if`/`match`
   arms, `for`, early `return`, `?`, and the self-tail calls that TCO
   turns into loop back edges. A statement-level CFG would leave two uses
   inside one call unordered (red-team finding 5: `g(r, r)`). The loop
   structure must be the one `lr_region` and `ol_apply` see, so the
   analysis recognizes tail-call loops by the same rule TCO uses.

   The residual graph shares subtrees between a function and its
   specializations, and one node can sit in several bodies (`rs_dense`
   keeps one def edge per node for that reason). So every fact is keyed by
   (function instance, node), and binders are resolved by the analysis's
   own scoped walk of each body, not by the program-wide `kg_def` column.
2. **Locations and aliases.** A *location* is an access path rooted at a
   binder: `x`, `x.f1.f2` (up to depth 3), `x.f[e]` (one element, `e` an
   index expression), and `x.f[*]` (any element; deeper paths fold into
   it). Two locations *overlap* when one is a prefix of the other, or when
   they name elements of one list with indices that range facts
   (`orf_*`) do not prove different.

   Every binder and every temporary carries an **alias set**: entries
   `P|L`, meaning the value's subpath `P` may point into location `L`. The
   rule is closed. **A value's set is the union of the sets of every
   tracked value it is computed from, placed under the step where that
   value ends up, plus its own location when it is a path.** Concretely,
   with no exceptions:
   - a path `b.q` (`xs[i]`, `r.f`, `b`): `|b.q`, plus `b`'s entries at or
     under `q`;
   - a record literal, list literal, sum constructor or map literal: its
     own object is new, and it holds each operand's set under `.f`, `[]`,
     the payload position or `{}`. "Fresh" means a new top object, never an
     empty set. `Rec {.n = a}` with `a = xs[i]` has `.n|xs[]` even when `a`
     is dead;
   - a call result: the union of the arguments' sets that the callee may
     keep (`keeps`, §3.3, which includes closures and containers in the
     result), under `|`; a thaw: the copied object is new and its children
     keep the source's set;
   - a lambda: the sets of every binder it captures (and the binders
     themselves);
   - `for (x in xs)`: `x` has `|xs[]`; a pattern payload of `r`:
     `|r.payload`; a field take: `|r.f`;
   - `if`/`match`/`tern`/block values, `?`, `orelse`: the union of every
     value the expression can produce;
   - a method result: the receiver's and arguments' sets (a writing method
     returns the receiver's object);
   - scalars, `Str` and `Dec`: no set (never written in place).

   A binder inside a loop gets the union over every iteration: alias sets
   and owned state are computed to a fixed point over `for`/`while` bodies
   and over the self-tail back edge, falling monotonically
   (owned to shared, sets growing).

   Temporaries count too: an argument expression such as `id(r)` in
   `g(id(r), r)` is a value with alias set `{r}` that is live until the
   call returns.

   **Index disjointness.** `xs[e1]` and `xs[e2]` are disjoint only when a
   new fact pass (`od_*`) proves `e1 != e2` from the expressions' def
   nodes (never their text, since a tail-call rebinding reuses names):
   `e2` is `e1 + c` with `c != 0` constant, or both are induction
   variables of one loop with a proved offset. `orf_*` answers bounds and
   overflow questions only, and has no such query. Phase 1 has no `od_*`:
   all element locations of one list overlap, and the report shows what
   that costs.

3. **Liveness of locations.** Backward liveness over the expression-level
   CFG. A location is *live* at a point when some live binder or live
   temporary reaches it: the binder itself, or any binder whose alias set
   overlaps it. A use inside a loop body of a binder bound outside the loop
   is never last, unless the binder is loop-carried (a tail-call argument)
   and this is its rebinding.

4. **The write rule.** One rule decides every in-place write: rebuilding
   `x`, an owned `with`/push on a path of `x`, or moving `x` into an owned
   parameter that writes. The write is static and in place only when
   - `x` is owned (§3.2 step 6), and
   - after the write point, no *other* live binder or temporary has an
     alias set overlapping the written location.

   Otherwise the use is a share, and the write goes through the dynamic
   path. This one rule covers the shapes the reviews found:
   - **Two takes.** `Node a = bs[i]; Node b = bs[j]; upd(a); use(b)`:
     `b`'s set `{bs[j]}` overlaps `a`'s location `bs[i]` unless `i != j`
     is proved, so `upd(a)` is not in place. This holds for header records
     and for inline records alike. A view `b` of an inline slot sees an
     in-place write exactly like a pointer would.
   - **Kept results.** `b = keep(a); ...; set(a)`: `b` is live with set
     `{a}`, so `set(a)` is not a move. `g(id(r), r)`: the temporary `id(r)`
     is live during the call with set `{r}`, so `r` cannot be moved into
     `g`. `g(r, r)`, `Pair {.a = x, .b = x}` and `[x, x]` are the same
     case.
   - **Read after a take.** Reading `xs[j]` while the take `t = xs[i]` is
     live is a read, not a write. It needs nothing unless `t` is written
     first. Then the write rule asks whether `xs` (the reader's location,
     live) overlaps `xs[i]`, which it does unless `j != i` is proved.

   **No deferred commits.** Every in-place write happens where the
   program writes: a rebuilding literal stores its changed fields at the
   literal, an owned `with` stores at the `with`. The write rule is
   checked at that point. NBody's `a2 = Body {..a..}` while `b = bs[j]`
   is live therefore fails the rule unless `od_*` proves `i != j`. `a2`
   is then a fresh inline record (frame or SSA values, flag 16, no heap
   allocation), and `bs.with(i, a2)` copies its seven doubles into the
   slot. That is the same stores a deferred commit would make, with no
   second mechanism to keep consistent.

5. **Field takes.** In `match top { Disk(s, rest) => ... }` with `top`
   owned and dead after the match, the payload binders own their payloads
   (alias sets `{top.payload}`, and `top` is dead, so nothing overlaps).
   The same goes for `r.f` of an owned `r` that is rebuilt without reading
   `f` again. Towers' piles and Json's state rest on this.

6. **Ownership and use modes.** A binder is **owned** when its value is a
   fresh object, a thaw, an owned parameter, or a take or field take from
   an owned root (step 5), and its alias set allows it (no other live alias
   at the points where it is written, step 4). Each use then gets read,
   borrow, move or share, by §2.2 and the write rule. A share has two
   effects:
   - **Lowering.** A share op on the value (§5) whenever it enters a
     container (record field, list, sum payload, map, closure, spawn) that
     is not an owned object it moves into as an owned child. This holds
     whether or not another alias is live, so no UNIQUE bit ever sits
     inside a shared structure. It also applies whenever the value reaches
     dynamic code that could write it (a shared instance's writing
     parameter) while another alias is live. A view `t = xs[i]` that is only read in static code needs no op
     and costs nothing. A view handed to a writing shared instance gets the
     op first, because that instance's `rt_rec_reuse` trusts the UNIQUE
     bit, and `rt_list_get_own` (list.resid:361) leaves the bit set on a
     transient list.
   - **State.** After a share of `x`, or of any value whose alias set
     overlaps `x`, `x` is no longer owned at later points. No later use of
     `x` can be a move into a writer.

   Contexts that force **share**: lambda bodies and captures
   (`gk_closure_facts`), spawn arguments and bodies (`lw_spawn`), persist
   copies, constant lists (`const_list`), map keys and values (until §6.4),
   native module arguments, device verb arguments, `@export`ed
   parameters, and `main`'s arguments.

### 3.3 Summaries

Per instance, by greatest fixed point over the call graph:

- `need[i]` for each tracked parameter: `none`, `read`, `may-write`, or
  `must-write`. `must-write` means every path consumes or rebuilds the
  parameter, or moves it into a callee whose parameter is `must-write`.
- `keeps[i]`: the result may reference the parameter or anything
  reachable from it, directly, inside a returned container, or captured by
  a returned closure. It is computed with the alias sets of §3.2 step 2 on
  the return values, so nothing a result can hold is missed.
- `shares[i]`: the callee may create a holder of the parameter that
  outlives neither through the result nor through the caller: a capture,
  a map value, a store into a container it shares. A caller treats such
  an argument as a share edge: the argument's alias set is shared after
  the call, and it is never borrowed into it while owned and later
  written.
- `fresh`: every return produces an owned value whose objects are all in
  the innermost region. This is stage 1's `R`, now with the home fact
  included.
- `escapes[i]`: something reachable from the parameter can outlive the
  call other than through the result. Values in Resid are immutable, so
  the only such exits are: a spawn argument or spawn body, a persist copy,
  a native or device call that may retain its argument, a closure that
  outlives the call, and a callee parameter whose own `escapes` is set. A
  value stored into a fresh local reaches the outside only through the
  result or one of these. It decides doomed (§6.2), and the checker
  verifies it (§4 rule 9).
- The result's state: **owned** only when `fresh`, or when it is built
  from moved (owned) parameters through `keeps`; **shared** otherwise,
  including every result that keeps part of a borrowed argument.
  The result's alias set is the union of the kept arguments' sets (§3.2
  step 2), so a later write to a kept argument is refused while the result
  lives.

`need` starts optimistic (from the body alone) and only falls, so the
fixed point exists. The rounds are bounded like `lo_fix` (64). Past the
bound, every remaining parameter falls to `read`/shared, which is always
sound.

### 3.4 Call sites

Each argument of a tracked type at a call gets a mode from the caller's
state and the callee's `need`:

| Caller has | Callee needs | Mode | Lowered as |
|------------|--------------|------|------------|
| owned, write rule passes (§3.2 step 4) | may/must-write | move | owned instance parameter |
| owned, write rule fails | may/must-write | share | share op, shared instance |
| shared, or a view | must-write | thaw + move | thaw, then the owned instance (below) |
| shared, or a view | may-write | share | share op if another alias is live, shared instance |
| any | read | borrow | plain pointer |

The write rule looks at every live alias, including temporaries of the
same call, so `g(id(r), r)` and `g(r, r)` never move `r`.

**Thaw** makes only the copied object owned (I1). For a list it is
`with_fresh_f`'s copy, which shares header-record elements, while inline
records come along as owned slot contents. For a record it copies the
record as today's lowering would a fresh literal of its type. For a
map or set it is `rt_map_transient`'s copy, with a new edit token
(`new_edit`) so the copy never inherits the source's. Takes from a thawed
list of header records are shared until an element is rebuilt (then it is
fresh and owned).

A list thaw keeps today's large-list rule. `list_with_f_slow`
(map.resid:2132) refuses to copy a frozen list past `fresh_max` (256) or
one marked frozen (`no_thaw`), and updates it persistently
(`with_shared`, O(log n)) instead. Copying it at every call would be O(n)
per call (parser node lists, Havlak's frozen lists). So a list thaw site
is a branch: `resid_own_thaw_ok(l)` (the same test) picks the owned
instance with a copy, else the shared instance with `l` as is. A
`must-write` parameter of list type therefore keeps a shared instance as
well.

When the callee writes a parameter on every path, today's
protocol copies it at the first write anyway: `rec_reuse` allocates when
the header says shared, and `with_fresh` copies a frozen list. Copying
once at the call (`resid_own_thaw_rec`, `resid_own_thaw_list`) is never
more work than that, and it sends the caller to the owned instance. For
`may-write`, the copy could be wasted on a path that doesn't write, so the
call keeps the shared instance.

**Same call, two roles.** One call must never pass a path as `move` and
an overlapping path in any other role. A borrow or temporary is held while
the callee runs (the bug of conformance case `record_alias_store`). This
is the write rule applied to the call's own temporaries, and the checker
re-checks it.

### 3.5 Instances

An instance is a function plus a key: one entry per writing parameter,
its **shape**. The shape is `shared`, `top` (the object is owned, its
children are not: what a thaw produces), or `deep` (the object and the
children the analysis proved owned, e.g. a list built from fresh
records). Inside an instance, a take from a `top` list is shared, never
owned, so a thawed list's elements (shared with the thaw's source) are
never written in place. `read` parameters are always borrowed and not
part of the key. Most functions get one instance, `deep`, plus `shared`
for list parameters reached by a thaw branch (below).

A `must-write` parameter is owned (`top` through a thaw at shared
callers) except in two cases, where it is `shared` like any other
parameter: the instance cap below is hit, or the parameter is a list
whose thaw branch (§3.4) finds it large or marked frozen at run time.
The second case is why a `must-write` list parameter keeps a `shared`
instance; its summaries (`need`, `keeps`, `shares`) are the function's
own and the checker (rule 8) checks that instance like any other.

- The keys a function needs are collected from its call sites by
  worklist, as `gm_round` does for type instances. A recursive or mutually
  recursive call inside an instance asks for the key its own arguments
  give, so a recursive owned chain stays on the owned instance (stage 1b
  refused recursion).
- **Bounds.** At most 4 keys per function, and at most 25% more function
  nodes than the program had. A call that would need more uses the
  all-shared key. Each instance copies a function node with fresh node ids,
  named `f__oK`, symbols offset into their own band (`(2000 + k) * 10^9`,
  apart from `__rsN` and the `__su` band).
- **Code size and compile-time gates:** §9.

### 3.6 Output

`own.resid` returns the graph with instance nodes added, plus an `OWN`
table: the mode of each use edge, the state of each tracked binder at its
uses, each take and its commit point, each thaw site, the home fact of
each owned binder (§6), and the instance chosen at each call. Lowering
reads only this table, never re-deriving ownership. The table replaces
`LOP.su`, `lor`, flags 1, 2 and 4 (`lo_borrows`) and the freeze decisions
of `lo_freeze`. Flags 8 and 16 (inline address, frame resident) remain
layout facts and come from the table too.

## 4. The checker: `compiler/ownck.resid`

Soundness must not depend on the fixed point being right. A separate,
smaller module re-verifies the annotated graph before lowering, and a
failure is an internal compiler error. It shares no code with inference
beyond the graph accessors and liveness. Its liveness is recomputed by its
own straightforward backward pass, and the inference's is not reused.

It checks, per instance and with no fixed point (call sites are checked
against the callees' *declared* keys and summaries in the table):

1. **The write rule.** At every in-place write (a rebuild, an owned
   `with`/push, a move into a writing owned parameter), the written binder
   is owned and no other live binder or temporary has an alias set
   overlapping the written location. Alias sets and liveness are
   recomputed here, not taken from the inference.
2. Every `borrow` ends before any write to an overlapping location, and
   no borrow or view crosses a loop back edge or a region push or pop.
3. A parameter declared owned receives only `move` or thaw arguments at
   every call site in the program. A parameter declared borrowed is never
   moved, committed or returned by the callee.
4. No owned path flows into a share context (§3.2 step 6) without a share
   edge, and every share edge lowers to a share or freeze operation.
5. Takes: a take's commit is a store at its write-back only. Between a
   take and its write-back, the list is not moved, returned or handed to a
   writer (rule 1 sees the take's alias). A `?` or early return in between
   does not hand the list on.
6. Home (I2): every owned binder's home is `cur` or `doomed`, and every
   store of a pointer into an owned object stores a value whose home is
   `cur` (or into a doomed object). §6.
7. Commit order (I3): every in-place write is at the literal or `with`
   that makes it (no deferred commits), and no read of the written
   object's old fields follows it.
8. Summaries hold: each instance's `fresh`, `keeps` and `need` are
   consistent with its body, given the callees' summaries.
9. `escapes` holds: no parameter with `escapes` clear reaches any exit of
   §3.3, and every owned argument of a scalar-scoped call has `escapes`
   clear in the callee.
10. Spine entry (I1): every value entering a container gets the share
    op today's lowering emits there, unless it is moved into an owned
    object as an owned child. A thawed callee's key says `top`, so no
    take from a thawed object is owned.
11. Share ops: a value reaching a writing parameter of a shared instance
    while another alias of it is live gets a share op first. After a
    share (including a callee's `shares`), no use of an overlapping binder
    is a move into a writer, around loop back edges too.
12. Loop regions (§6.2): every carried owned parameter the body writes in
    place, changed or not, is in the region loop's move list.
13. Inside a region loop's body (any nesting), every object written in
    place is either fresh in the current iteration or on the static spine
    of a carried owned parameter of that loop. This is what makes the small
    loop exit safe (§6.2).
14. Every `resid_rec_reuse*` call is on an `LOP.hdr` type.

The checker is linear in program size and runs on every compile, release
included. Measured cost goes in the phase 2 gate (§9).

## 5. Lowering owned code

Everything below applies only in owned instances, and only to edges the
table marks. Shared edges lower exactly as today.

- **Rebuilding literal from a moved source** (`lw_struct`,
  lower.resid:255): no `resid_rec_reuse*` call and no header word read.
  The literal's address is the source's. Only fields whose value differs
  from `src.f` are stored. This was tried before and lost 3-12% (round 7),
  but only because the reuse was a runtime branch and needed two code
  paths. Here there is no branch.
- **Owned `xs.with(i, v)`**: the bounds check (hoisted or versioned by
  `ol_apply`/`orf_*` where they apply), then a store into the slot at
  `lroot`. No call to `resid_list_with*`, no transient test, no
  `word_static` test, no barrier.
- **Take or view from an owned list**: the slot's address (`rec_at`
  arithmetic inline). `resid_list_rec_borrow`'s transient branch and frame
  copy go away. A `with` that stores back the object already in its slot
  (a take rebuilt in place) emits nothing.
  A view that reaches dynamic code that could write it while the list is
  live gets a share op there (§3.2 step 6). An inline record has no
  independent bit, so such a view is copied to the frame (today's
  `rec_borrow` copy) before it leaves static code.
- **Owned push** (`xs.concat([x])` on an owned list, W4's push): a store
  at `count` when within capacity, else `with_grow`. No one-element
  literal and no concat.
- **Owned Map/Set update**: `resid_map_put(..., owned = 1)` as today. The
  freeze calls `lo_freeze` inserts at call results come from share edges
  instead.
- **Share edges**: at exactly the edges the table names, not by
  `lo_freeze`'s heuristics. The operations are the ones today's lowering
  emits at that kind of site (I1): `resid_rec_share` plus
  `resid.rec.freezef.T` for a header record, `resid_list_freeze` for a
  list, the map freeze for a map.
- **Thaw sites**: `resid_own_thaw_rec(p, size)` (a copy whose bit is
  what today's lowering gives a fresh literal of that type),
  `resid_own_thaw_list(l)` (`with_fresh_f`'s copy, as today's first owned
  write) and `resid_own_thaw_map(m)` (`rt_map_transient` with a new edit
  token). These
  are new runtime functions, compiler-only (E0220), with their twins in
  resid-ddc only if the compiler's own source calls them (it does not:
  they are emitted, not called).
- **Debug profile**: same modes, same instances, plus DWARF as today. The
  inliner stays off under `dbg` as now, so debug builds get fewer takes;
  that changes speed only.
- **`--own-assert`** (developer flag, recorded in provenance): every
  static in-place write also emits the dynamic test it replaced (UNIQUE
  bit, transient, young/home) as an abort with the function name.
  Headerless objects have no bit to test, so an assert build gives every
  record type a header and every sum box an owner bit, at the cost of
  layout. It is a test build, so this costs nothing in release. Every
  suite and the self-compile run under it in phase 2 and later (§8).

After phase 4, `su_*`, `lo_borrows`/`lo_bscan`, `lo_ret_reuse`/`lor`,
`lo_arg_reuse` and the `resid_rec_reuse_ny/_eq/_sc` call sites are dead
on owned paths. The shared instance keeps `resid_rec_reuse`/`_eq`/`_sc`,
since its dynamic protocol still wins there. Deleting them from shared
code is a separate measurement, not part of this plan.

## 6. Memory: home regions

### 6.1 The rule today

`region.resid`: region ids grow with every push, and no object points into
a region younger than its own. A value written into an older object is
moved first (`bar_keep`, `bar_keep_f`/`bar_move_f`), and loop compaction
(`rt_loop_move`) moves the carried values into a new region. The young
test (`young_fast`, TLS word 13) is how `resid_rec_reuse` decides it may
write in place.

### 6.2 Keeping I2 statically

The analysis gives each owned binder a home: `cur` (innermost region) or
`doomed`. The places where the innermost region changes:

- **A call** pushes nothing. An owned argument is `cur` in the callee
  because it was `cur` in the caller.
- **A fresh allocation** goes to the innermost region, so it is `cur`.
- **A scalar scope** (`resid_scope_push`/`pop` around a scalar-returning
  call, lower.resid:3983/4001). An owned argument moved into the scoped
  call is *doomed*, and so is its whole owned spine (every owned object
  reachable from it, including ones allocated before the scope). The call
  returns a scalar, and `move` means the caller never uses the argument
  again. "Live" here means reachable from a root that survives the pop,
  so nothing live can see the young pointers the callee stores anywhere
  in that spine. The checker (§4 rule
  6) verifies that every owned argument of a scoped call is moved, not
  borrowed. A borrowed argument is only read inside, so it needs no rule.

  Doomed also requires that nothing inside the scope can keep the value
  past the pop: the callee's `escapes[i]` (§3.3) must be clear. An
  argument that may escape (a spawn argument or body, a persist copy, a
  map stored outside the result, a retaining native or device call) is not
  doomed. The caller then shares it before the scoped call, and the
  callee's writes go through the dynamic path. A spawned thread holding a
  doomed record that points into a popped scope would be a use-after-free;
  this rule, checked by §4 rule 9, is what stops it.

  Inside the scope, nothing distinguishes a doomed value from a `cur` one.
  The callee and its callees treat their owned parameters alike and store
  young pointers into them. That is sound because a doomed object is
  reachable only from frames that end before the pop. The caller moved it
  (and the write rule, §3.2 step 4, forbids a second live alias), the scope's result is a
  scalar, and `escapes` is clear on the whole call tree below. The only
  frames that see it are inside the scope.
- **A loop region push** (`lr_region`: at entry when `rt_loop_enter`
  pushes, or lazily at a back edge when `rt_loop_due` finds the outer
  region due). This is the one place where carried owned values would
  become older than the innermost region. **Change:** when L is pushed,
  the carried *owned* values move into L with the same movers compaction
  uses (`resid.rec.evac.T`, `resid_mv_list_f`, `list_move`), in one
  `mv_ctx` pass over the same source range. After that, carried owned
  values are `cur` in the body, as they are after every compaction
  already. Carried shared values do not move, as today.

  Three details the red-team found:
  - **Written but unchanged.** Today `lr_moves` moves only phis whose
    value changes, on the argument that an unchanged parameter is older
    and cannot point into the loop's region (lower.resid:5188;
    `lr_same_in`, lower.resid:6319). An owned parameter written in place keeps its pointer
    but changes its contents, so that argument fails. Every carried owned
    parameter the body writes in place counts as changed: it is moved at
    the push and at every compaction (checker rule 12). Otherwise
    `xs.with(0, Node {..})` on an unchanged `xs` in R would store an
    L-pointer that dangles at the next compaction.
  - **The source of the push move is the outer region R**, where the
    carried values live, not L. Today's step-1 context names L, which is
    empty at a lazy push and would move nothing. The push uses a *spine
    mover* generated per loop (a self-tail call of the *same instance*; a
    tail call into another instance is not a back edge) from the static spine of each carried owned
    parameter at the loop head: the owned locations (§3.2 step 2) the
    analysis proved, a loop-invariant fact since the loop head is a fixed
    point. The mover (`resid.own.spine.<fn>.<k>`) follows exactly those
    paths, copies the objects on them that lie in R, and leaves every
    other child where it is, since an L object may point into the older R.
    It never reads a UNIQUE bit to decide, so stale or cleared bits (and
    headerless plain records and sum boxes) cannot misdirect it. The push
    copies the owned state only, not everything reachable from it, and
    transient maps and lists keep a single holder.
  - **Small exit copies only the result** (`loop_exit_slow`'s `small`
    path, region.resid:368). That is safe under the first detail: inside
    a region loop, the only owned objects written in place are fresh ones
    and carried parameters, and all of them live in L. When the loop
    ends, the live ones are reachable from the result (which is moved)
    and the rest are dead. A loop is a self-tail function, so it has no
    other frame state to write.

  **Buffer growth and other runtime stores** (`with_grow`, an owned push
  past capacity, map node copies). The runtime allocates in the innermost
  region (`rt_gmalloc` to `scope_alloc`), and under I2 that is the owned
  object's own region. So the new buffer is no younger than its header.
  The checker sees only IR stores, and this argument covers the rest. It
  needs `lr_call_allocs` to count an owned push and `with_grow` as
  allocating when it decides whether a loop gets a region.
- **Compaction** (`rt_loop_move` step 1) already moves carried values into
  the new region, which keeps them `cur`.
- **Loop exit** merges L into the parent (`region_merge`) or copies a
  small result over, so the result is `cur` in the parent.
- **Sandbox frames and `region_use`** inside the runtime don't change the
  compiler's innermost region for user code. Map internals stay behind
  `map_enter`/`map_leave` as today.

Cost of the change: a carried owned value is copied once when L is
pushed. A lazy push happens only when the outer region has already grown
past twice its post-compaction size, and the first compaction after it
copies the same values again today. So this at most doubles one copy per
long loop instance. The phase 3 gate measures it against the barrier moves
it removes (DeltaBlue: 899k).

With I2 held, every store into an owned object stores a `cur` value (or
goes into a doomed object). `bar_keep`, `bar_keep_f`, the young test and
`resid_rec_reuse_ny` drop out of owned paths. Towers' `Disk` into
`Piles`, Json's state, and DeltaBlue's `Db.vs` are all this case.

### 6.3 What is not introduced: frees

This plan adds no per-object free. Memory is still reclaimed only by
region pop, compaction and merge, as today. A dead owned record (for
example the `Disk` cell a move pops) is garbage in its region exactly like
today's. So an ownership bug can produce a wrong value but cannot produce
a double free or a free list corruption.

A region bug can still produce a dangling pointer: an owned object left
pointing into a region that is popped while the object stays live. That
is why I2 is checked by the checker on every compile, asserted by
`--own-assert` at every store in the test runs, and attacked first by the
red-team (§7).

### 6.4 Sums and maps

- A sum box whose binder is owned and dead after a `match` can be
  rewritten in place by a constructor of the same variant and size in the
  same function. This is reuse within a function only, the shape Perceus
  calls reuse. It applies only when payload pointer slots get `cur`
  values. Cross-function reuse is not planned.
- Map and Set values (records stored as map values) stay share edges in
  this plan. The map runtime's edit tokens already make owned maps cheap.
  Owned map *values* are the follow-up if CD's or Havlak's profiles ask
  for it after phase 3.

## 7. Safety and security (red-team targets)

Each item: the attack, then what stops it.

1. **Aliasing miscompile.** A value rewritten in place while a second
   holder still reads it gives a wrong result. In crypto or the attestation
   verifier, that is a security bug.
   - Inference and checker are separate code (§4).
   - I1 means `--own-assert` turns every such case into an abort in tests.
   - The differential suite (§8) compiles every conformance case,
     `tests/crypto` (Wycheproof), `tests/tls`, `tests/attest`,
     `tests/provenance` and the self-compile with ownership off, on, and
     asserting, and requires identical output.
   - The aliasing shapes in §8.1 each get a conformance case.
2. **Region invariant (I2) broken.** An owned object left pointing into a
   younger region after a pop is a dangling pointer, a memory-safety bug.
   - The checker (rule 6) verifies every home fact on every compile.
   - `--own-assert` checks the region of every pointer stored on an owned
     path at run time.
   - The red-team pass must try: a carried owned value with a shared
     subobject from an older region; an owned value reachable from two
     loop phis; a doomed argument that escapes through a borrowed
     argument's result (`borrowed_by_result`); a scalar scope around a
     call whose callee pushes its own loop region; an owned value inside a
     sandbox call frame; abort and unwind through `region_unwind` with
     owned values half committed; a doomed argument handed to a spawn or
     persisted inside the scope (`escapes`, §6.2).
   - Found and closed by the first review (2026-10-17): written-but-
     unchanged loop parameters, the push move's source region, buffer
     growth by the runtime, the small loop exit (§6.2), stale UNIQUE bits
     under shared parents (I1), and two uses in one call (§3.2 step 4).
   - Found and closed by the second review: same-slot takes and views
     written through an owned callee, a view handed to a dynamic writer,
     kept results and nested temporaries, the binder state after a share
     (all now one rule: alias-aware liveness, §3.2 steps 2-4), the large
     frozen list thaw, map thaw, headerless objects and bit-selected
     spines (now static), and inner loops (checker rule 13).
   - Found and closed by the third review: deferred commits contradicting
     literal-time stores (dropped; every write is where the program
     writes, §3.2 step 4), thawed elements written through an owned
     instance (instance shapes `top`/`deep`, §3.5), thaw copy functions
     named inconsistently and nested stale bits (I1), alias
     sets dropping the contents of fresh literals, closures, `for`, `?`
     and sums (one closed rule, §3.2 step 2), callee-internal shares
     (`shares`, §3.3), loop back edges (fixed point), the missing
     disjointness query (`od_*`), headerless objects under
     `resid_rec_reuse*` (checker rule 14), share ops for every container
     entry (§3.2 step 6), and instance choice in loops (same-instance back
     edges only).
   - Found and closed by the fourth review: freezef reaching only
     Map/Set/List fields (now every header-record field, with an early
     exit), doomed children of a doomed argument, the large-list thaw as a
     third instance case, list share cost (O(1) freeze plus share-on-read),
     phase 4 keeping `lor`/`lo_hdrs` for shared instances, assert builds
     for headerless objects, home-fact checker rules starting in phase 3,
     and wrong citations.
   - Fifth review: the deep-share extension itself was unsound (element
     shares and sum payloads are shallow today, so an early-exit freezef
     could skip a UNIQUE grandchild). Replaced by I1 as it now stands:
     owned code creates and clears bits exactly as today's lowering does
     and never reads them, so the dynamic protocol's invariants are
     untouched. The review's questions about today's protocol (sum
     payloads, bulk copies, map values) go to a separate audit (§9,
     phase 1).
3. **Commit order (I3).** A read after a commit sees the new value.
   - Checker rule 7.
   - Conformance cases: read-after-rebuild (Richards' `hold_self` reads
     `t.link` after the write-back), two takes with `i == j` (take commits
     are stores at the write-back, §3.2 step 4), take then read of the
     same index.
4. **Threads.** Spawn arguments and spawn bodies are share contexts, and
   a value crossing a thread is never owned on both sides. Open question,
   which predates this plan: a bound spawn (a future) created inside a
   region loop captures values that may live in L (`lw_share_caps` only
   freezes them; spawn arguments are raw pointers, ctl.resid:158). What
   keeps them alive across L's compaction or pop must be confirmed against
   today's code before phase 3. Case `own_spawn_loop` tests it, and
   ownership must not make it worse: an owned value reaching a spawn
   always passes a share edge first, and the push mover never moves a
   shared value. No instance
   selection depends on which thread runs. `runtime/rt` threads and
   region ids are per-thread, as today.
5. **Capabilities.** `@requires` facts (E0219) are computed before this
   pass and are per function. An instance copies its function's
   annotations and stays inside its `sandbox` node, so it gets the same
   ceiling and wrapper (`resid_cap_enter`, `<name>.sb`). Closures
   (`lw_lambda`'s `resid_cap_check`) are share boundaries and are not
   rewritten. The checker verifies that an instance's ceiling string
   equals its original's.
6. **Secrets and constant time.** Instance choice is static, so no branch
   depends on a secret. The in-place path removes branches (header and
   young tests) and adds none. `sec_erase` runs before this pass, as now.
   Writing secret buffers in place leaves fewer stale copies in dead
   memory. `tests/ct/run.sh` runs the optimized binary under valgrind, so
   it exercises whichever instances the probes reach. The coverage gate
   (`tools/resid-ctcover.resid`) works on the source call graph and needs
   no change.
7. **Determinism.** The pass is pure graph work with canonical orders
   (node id order, sorted keys), no hashing of pointers and no time. The
   self-compile must reach the byte-identical fixed point, resid-ddc must
   reproduce `seed.ll` and `rt.ll`, and an AArch64 host must emit the same
   IR as an x86-64 host. The reduction budgets don't move: the pass runs
   after reduction and counts nothing.
8. **Untrusted packages.** No annotation means no claim a package can lie
   about. A package's code is analyzed like any other code, and the
   checker runs on it.
9. **No user switch.** Ownership is not optional. `--ownership on|off`
   exists only while phase 2 is built (default off, so the default
   output stays the committed compiler's until the checker and the
   differential suite are green). The default then turns on and the flag
   is removed; if a developer switch is kept for bisecting a miscompile,
   it is hidden and recorded in the provenance record.
10. **Pins.** The runtime changes (§5 thaw functions, §6.2 push-time
    moves) change `rt.ll`, so `tools/attest/verify_pins.py --write` and a
    rebuild are part of each runtime phase. Inference and checker are
    compiler code and touch no pinned file.
11. **Abort and unwind.** `under_catch` (runtime/rt/ctl.resid) restores
    capability depth, region uses and the scope, but it cannot undo an
    in-place store. Its callers (`spawn_run`, `expect_throws`) take
    closures or spawn arguments, which are share contexts, so no owned
    value is ever inside a catch. The checker keeps it so: an owned value
    never reaches a closure that a catching builtin runs. A `?` early return
    while a take is open may not hand the list on (checker rule 5), so a
    half-written element is never observed.

## 8. Tests

### 8.1 Conformance cases (each aliasing shape)

Kept: `unique_records_static`, `nested_record_share`,
`record_alias_store`, `owned_elem_borrow`, `owned_elem_borrow_lists`,
`reuse_in_sum`, `match_sum_try`.

New, one directory each under `tests/conformance/cases/`:

- `own_two_holders`: a value passed, then read.
- `own_same_call_roles`: one record moved and borrowed in one call.
- `own_take_read_same`: a take, then a read of the same index before the
  write-back.
- `own_two_takes_eq`: two takes on one list with `i == j` at run time.
- `own_read_after_commit`: Richards' `hold_self` shape.
- `own_recursive`: an owned value through direct and mutual recursion.
- `own_thaw`: a shared caller to a `must-write` callee; the caller reads
  its value afterwards.
- `own_may_write`: a `may-write` parameter called both owned and shared.
- `own_scalar_scope`: a doomed argument holding young pointers across the
  pop.
- `own_lazy_push`: an owned carried value through a loop long enough to
  push L and compact twice.
- `own_borrow_backedge`: a borrow alive at a back edge (must fall back).
- `own_closure`, `own_spawn`, `own_persist`: captures, spawn arguments,
  persisted copies.
- `own_sum_reuse`: a constructor reusing a dead matched box, with pointer
  payloads.
- `own_map_value`: a record stored in a map, then written through a copy.
- `own_sandbox`: an owned instance of a sandboxed function and its ceiling.
- `own_abort_unwind`: an abort with a half-committed owned value under a
  `?` path, and an abort inside a region loop after L was pushed.
- `own_written_unchanged`: a loop that writes a carried list in place
  without changing its pointer, long enough to push L and compact (red-team
  finding 2).
- `own_small_exit`: the same loop returning a scalar from a small L
  (finding 3).
- `own_grow_in_loop`: an owned list pushed past capacity inside a region
  loop (finding 4).
- `own_same_call`: `g(r, r)`, `Pair {.a = x, .b = x}`, `[x, x]` with a
  rebuild of one side (finding 5).
- `own_stale_unique`: a list of header records shared, then thawed, then
  an element rebuilt; the original is read afterwards (finding 1).
- `own_borrowed_result`: a result that keeps part of a borrowed argument,
  then rebuilt (finding 7).
- `own_alias_takes`: two takes `a = bs[i]`, `b = bs[j]` with `i == j`,
  `upd(a)` writing through `a`, then `b` read, for header and for inline
  records (second review).
- `own_view_to_writer`: `t = xs[i]` passed to a may-write shared callee
  while `xs` is live (second review).
- `own_nested_temp`: `g(id(r), r)` with `id` keeping its argument (second
  review).
- `own_share_then_move`: `b = keep(a); set(a); use(b)` (second review).
- `own_large_frozen_thaw`: a must-write callee called with a frozen list of
  10,000 elements, many times; must stay O(log n) per call (second review).
- `own_map_thaw`: a must-write callee given a shared map; the original is
  read afterwards.
- `own_stale_nested`: a record inside a record inside a list, shared,
  thawed, then rebuilt by a shared instance; the source is read after.
- `own_thaw_take`: a must-write callee given a thawed list takes and
  rebuilds `xs[0]`; the caller's original list is read after (third
  review).
- `own_literal_holds_take`: `Rec {.n = xs[i]}` kept while `xs[i]` is
  rebuilt (third review).
- `own_closure_keeps`: `f = mk(t)` capturing `t`, then `t` written
  (third review).
- `own_loop_share`: a loop that puts its carried record into a map, then
  rebuilds it on the next iteration (third review).
- `own_for_elem`: `for (x in xs)` rebuilding from `x` while `xs` is read
  (third review).
- `own_spawn_loop`: a future created in a region loop, joined after
  several compactions (§7 item 4).

### 8.2 Differential suite: `tests/own/run.sh`

- Every conformance case, built three ways (`--ownership=off`, default,
  `--own-assert`), must produce identical stdout and exit codes.
- The same for `tests/crypto`, `tests/tls`, `tests/attest`,
  `tests/provenance`, `tests/ledger`, `tests/regex` and the AWFY harness at
  the ReBench sizes.
- A generator (`tests/own/gen.py`, python3 -I, seeded) writes random
  programs over records, lists, sums and maps with random aliasing
  (holders, takes, loops, recursion, scopes). Each runs three ways and
  must agree. Run 2,000 programs per CI run and 100,000 before each phase
  is called done.
- **Self-compile under assert.** A compiler built with `--own-assert`
  compiles the compiler; its output must equal the fixed-point seed. That
  covers about 70,000 lines of real Resid.

## 9. Phases, deliverables and gates

Each phase: `boot.sh` fixed point, all suites, resid-ddc, and AWFY
`instructions:u` against a baseline from the committed `stage2.bin` plus
`-rtr` of a HEAD-lowered `rt.ll` (never wall time alone). Plus an
adversarial review of the phase's proof obligations before commit.

**Phase 1: inference, report only (about 1.5 weeks).**
- Deliverable: `own.resid` with CFG, liveness, paths, takes, summaries,
  instance keys and `--own-report`. Lowering still uses `lo_*`/`su_*`.
- Gate, per AWFY port: the fraction of hot-path tracked uses (by
  `perf`-weighted function) that are move or borrow is at least 95%. The
  report lists every share in the hot functions and its reason.
  Richards' `schedule -> run_task -> run_fn -> *_fn -> set_ab -> with_ts`
  chain is owned on every edge.
- Gate: self-compile pass time +0.5 s at most.
- Audit (separate from ownership): whether today's dynamic protocol
  keeps UNIQUE records out of shared structures through sum payloads,
  `concat`/`slice`/`sort`/`to_array` copies and map values. Any hole found
  gets its own fix, test and commit.
- Go/no-go: below 95% on a port, fix the inference first. Lowering does
  not start until the report shows the wins exist.

**Phase 1 status (2026-10-17, uncommitted).** `compiler/own.resid`
(report only), `residc --own-report <file> [--own-mode 1|2|3]`. The
driver now runs the one-return inliner once (`lw_inlined`), and lowering
and the report share its graph; emitted IR is byte-identical to the
committed compiler's on the AWFY harness and on the compiler itself.

Hot write weight (perf share per function, inlined callees attributed to
their hot caller), at the ReBench sizes:

| Benchmark | In place | Static copy | Dynamic |
|-----------|---------:|------------:|--------:|
| Bounce, Havlak, Json, NBody, Permute, Queens, Sieve, Towers | 100% | 0% | 0% |
| Richards | 97.5% | 2.5% | 0% |
| DeltaBlue | 97.7% | 2.3% | 0% |
| CD | 81.1% | 16.2% | 2.7% |

"Static copy" is a write whose source is genuinely still live (value
semantics needs a new object; no runtime test). Every benchmark has 0%
dynamic except CD, whose 2.7% is a list read out of a map value
(`put_into_map`, §6.4's follow-up). The remaining copies are real
aliases: Richards' `w.data` while `s` is pending into `set_ab`, and two
takes `d`/`w` of one list with unproved-different indices; DeltaBlue's
`recalculate`/`remove_propagate_from` passing two aliases of one value;
CD's `next` reused after `v2_minus(next, h)`. So the move-or-borrow gate
(95%) passes on every port when static copies count as moves (they need
no protocol). It fails on CD (81%) if only in-place writes count.

What the report has that the design needed, found while building it:
holes (`reads`, the fields a callee never reads, so a field taken out of
a pending argument is invisible to it), per-parameter `writes` (the
fields a callee may write, so an alias of another field is not
disturbed), instance split (a parameter keeps an owned instance while
some call site passes an owned value), keyed element locations with the
`with` receiver excluding its own slot, and scalar field reads hoisted
above writes. Callee-first sweeps with monotone joins settle in about
1.9 evaluations per function.

Compile time: the report adds about 7 s to the compiler's 53 s
self-compile (2.4 s preparation, 4.3 s sweeps, 0.4 s report), down from
56 s. That is far above the 0.5 s gate. The cost is the string-keyed
representation (locations, alias entries and live sets as text,
snapshots per tracked node), not the algorithm. Phase 2 must move to
integer locations (binder id and step ids) and per-binder live sets
before the pass runs on every compile. Until then `--own-report` is a
measurement tool, not part of the build.

Audit of today's protocol (§9): sum payloads holding header records,
`concat`, slices and list literals of shared elements, and map values,
each with a rebuild through the copy, all give the value-semantics answer
on the committed compiler. Not exhaustive: `sort`, `to_array` and
spawn captures are still to check.

**Phase 2 integration (design, 2026-10-17).** How the analysis reaches
lowering without a second source of truth:

- *Same graph.* Lowering's per-function graph is `lo_snap`'s copy of the
  inlined graph (`lw_fn_body`, `sg`). `lo_snap` rewrites nodes in place
  (`g.ns.with(id, ..)`) and appends hoisted binds, so every node id the
  analysis saw keeps its identity. Verdicts are therefore keyed by node
  id of the inlined graph and read directly in `lw_fn_body`.
- *Switch.* `--ownership on|off` (default off until the checker exists
  and the differential suite is green). With it off, lowering is
  byte-identical to today. A non-default value is recorded in provenance.
- *Strict verdicts for lowering.* The report's verdicts assume two things
  lowering does not yet do: per-ownership instances (a parameter owned
  because *some* caller passes it owned) and hoisting every scalar field
  read above a write. Lowering consumes a strict variant: a parameter is
  owned only when *every* call site passes an owned value the write rule
  allows, and a later scalar read of the written object or an alias is a
  conflict unless `lo_snap` already hoisted it.
- *Representation facts the analysis must mirror*, or it would call a
  shared object fresh:
  - a list literal whose elements are all constants of `Int`, `Str` or
    `Bool` is built once and cached by the runtime (`lst_emit_const`,
    `resid_list_const_*`): shared, never fresh;
  - sum boxes may be emitted as constants by the reducer (`const_boxes`):
    no sum is written in place before §6.4 is built;
  - an inline record read from a list is a frame copy (flag 16) or the
    slot itself (flag 8). The slot is an alias of the list element, which
    the analysis already models. The frame copy is a fresh object, which
    the analysis conservatively treats as an alias.
- *First consumer: record rebuilds.* For a struct literal whose strict
  verdict is in place with source binder `b`, lowering adds the literal
  to `lor` (source name) and `b` to `suv`, which takes `lw_struct`'s
  existing static path (`stat`): stores into the source record with no
  header test, and the region test (`resid_rec_reuse_ny`) when a pointer
  field changes, so I2 still holds dynamically. A binder whose name is
  bound more than once in the function (`su_dupmap`) is skipped, since
  `suv` and `lor` are keyed by name.
- *Order.* Rebuilds (measurable on Richards, Towers, Json, Queens), then
  `--own-assert` and the differential suite, then the checker, then
  owned list writes, instances, thaw, and the default turned on.

**Phase 2: checker, instances, owned lowering of records and lists (about
2 weeks).**
- Deliverable: `ownck.resid`, instance creation, §5 lowering except
  regions (owned stores whose home is not proven `cur` still call the
  young-tested path), thaw, `--own-assert`, `--ownership=off`,
  `tests/own/run.sh`.
- In phase 2 every pointer store on an owned path keeps today's region
  test or barrier, so I2 holds dynamically. Checker rules 6, 12 and 13
  (home facts) start in phase 3 with the home analysis; phase 2 runs rules
  1-5, 7-11 and 14.
- Gate: the differential suite and assert-mode self-compile pass; checker
  cost under 0.2 s on the self-compile; function count +25% at most;
  emitted IR +15% at most.
- Expected, from the stage 1 and ceiling measurements: Richards, Permute,
  Queens and Bounce lose their header tests, whole-record copies and
  rebuild calls. Target: the Towers/Json/Richards ceiling (-44/-34/-32%)
  is exceeded on Richards, since field-diff stores and inlining come on
  top of the deleted tests.

**Phase 2 compile time (2026-10-18).** With ownership on, the analysis
runs twice on the self-compile: once to find the functions worth an
owned instance, once on the graph with the clones. Measured by
instruction samples, it was 10.5% of the compiler's own work (about 7.6 s
of CPU) before these fixes:
- A summary's signature held the function's own call-site facts (`bad`,
  `good`). Callers are now dirtied only by the part they read (`ow_csig`).
- The sweeps run by strongly connected component, callees first. A
  recursive component iterates to its fixpoint before its callers run, so
  no caller is re-analysed against a cycle's unsettled summaries.
- The pieces are output-identical: short lists are deduplicated by scan;
  `ow_under` does not deduplicate, since every result goes through
  `ow_ov`; tracked path arguments are judged once, not twice; bad and good
  call sites share one judgment; no dummy-root strings are built.
- The runtime: in secret mode a freed arena chunk is wiped over its used
  part only, not all 4 MB.

The sweeps' order changes one route in the compiler (`lb_at` instead of
`lb_at__o`). The joins carry earlier rounds, so the fixpoint is
order-dependent, but it stays sound. AWFY is unchanged. The analysis
takes 35% fewer instructions (110 G to 71 G), and the compiler process 8%
fewer. It is still well above the 0.5 s gate:
`str_char_at`/slices and string-keyed maps are about two thirds of it.
The remaining plan:
- Integer paths and entries: interned steps, and keys built at
  preparation.
- One analysis run instead of two.

**Phase 3: home regions (about 1.5 weeks).**
- Deliverable: §6.2 home facts in the inference and checker; the spine
  movers `resid.own.spine.T`; push-time moves of carried owned values with
  R as the source (`resid_loop_push_owned(l, ctx)`, emitted by
  `lr_region` after `rt_loop_enter` or `lazy_push` takes L); `lr_moves`
  counting written-but-unchanged owned parameters as changed;
  `lr_call_allocs` counting owned pushes and growth; and owned paths free
  of `bar_keep*`, the young test and `resid_rec_reuse_ny`. `--own-assert`
  checks regions.
- Gate: DeltaBlue's barrier moves on owned paths go to zero (count
  `bar_move_f` calls); Towers and Json reach at least their measured
  ceilings; no benchmark's peak RSS grows more than 10%.
- Red-team: the region attacks of §7 item 2, then a second review of the
  fixes.

**Phase 4: retire the stage 1 machinery (about 0.5 week).**
- Delete `su_*` and `lo_borrows`/`lo_bscan`, and stop using flags 1, 2
  and 4 on owned paths. `lor`, `lo_ret_reuse`, `lo_arg_reuse` and
  `lo_hdrs` stay: shared instances still emit `resid_rec_reuse*` through
  `lw_struct`'s `lor` branch, and the headerless guarantee (I1) rests on
  `lo_hdrs`. Keep the shared-world runtime entry points.
- Gate: no AWFY regression against phase 3, and a smaller lowering
  (lower.resid loses about 1,500 lines of the roughly 3,400 in ownership
  code).

**Phase 5: what the profiles then name (separate decisions).**
W4's remaining items (presized `ListBuf`, thaw in place for Havlak's
frozen lists held by owned records, the `Str` header), owned map values
(§6.4), and the 16-byte sum box (still needs your call, as noted
2026-10-16).

### Targets

Instruction gaps to the per-benchmark leader at 1c5fc404, and what this
plan must reach by the end of phase 3:

| Benchmark | Leader | Gap now (ms per iteration) | Target |
|-----------|--------|---------------------------:|--------|
| Richards  | Zig  | 140 vs 20.6 | within 1.5x of Zig, ahead of C++/Rust/Go |
| Towers    | Zig  | 26.6 vs 7.0 | within 1.3x |
| Queens    | Zig  | 17.5 vs 3.6 | within 1.5x |
| DeltaBlue | Rust | 29.6 vs 4.8 | within 1.5x, ahead of Zig and C++ |
| Permute   | Zig  | 31.8 vs 9.1 | within 1.3x |
| Bounce    | Rust | 16.9 vs 5.2 | within 1.3x |
| Json      | Zig  | 40.8 vs 11.1 | within 2x (the Str header, phase 5, closes the rest) |
| CD        | Zig  | 45.1 vs 14.7 | within 1.5x |
| Havlak    | Rust | 119 vs 31.3 | within 2x (owned map values and thaw in place, phase 5) |
| NBody     | Rust | 38.8 vs 6.6 | parity in instructions; the IPC collapse in the W3-versioned loop (23 to 39 ms) is a separate bug to fix first |

The targets are estimates and must be replaced by measurement at each
gate. Mandelbrot is already a tie and Sieve is a W3/W1 benchmark; neither
depends on this plan. The lead itself (first, not within a factor) needs
phase 5 on Json, Havlak and CD. On Richards it also needs the inliner to
flatten the task dispatch the way Zig's `switch` does once bodies are
small.

## 10. What will not work (so no phase repeats it)

- More dynamic trimming: cheaper young tests, fewer compares, smarter
  barriers. Rounds 3, 4, 7, 9 and 11 of `PLAN-awfy-lead.md` are the
  evidence.
- Share-on-read takes (the shelved 361678ba): they tax every read.
- Trusting inference without the checker, or skipping the checker in
  release builds. The checker is the safety argument.
- Per-object frees. They would turn ownership bugs into use-after-free,
  and nothing measured asks for them.
- Any user-visible ownership: syntax, annotations, or diagnostics. §0 is
  a requirement, not a preference.

## 11. Risks

- **Inference precision.** If too few hot edges resolve to move, the gain
  is stage-1 sized again. Phase 1's report gate exists to find this before
  any lowering work.
- **Instance blow-up.** Bounded by the key rules (§3.5): `must-write`
  thaws instead of splitting, and caps per function and per program.
- **Push-time moves.** One extra copy per long loop instance. Measured in
  phase 3. If a benchmark loses, the push can move only the carried owned
  values the body writes (the checker knows which).
- **Compile time.** The pass sits in the 12 s of compiler passes. The
  phase 1 and phase 2 gates bound it, and the self-tail-loop rule of
  AGENTS.md applies: no growing list threaded through a self-tail loop,
  helpers recurse through a second function.
- **Bootstrap.** Phases 2 and 3 change emitted IR and phase 3 the runtime.
  Lower `rt.ll` with the committed compiler first, then reseed with
  `--bootstrap-from-self`, then commit `rt.ll` and `rt-aarch64.ll` with the
  seed. The compiler is itself the largest owned-code test, so a
  miscompile shows up as a fixed-point failure or an assert abort, never
  silently.
