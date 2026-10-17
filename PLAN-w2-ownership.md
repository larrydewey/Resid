# W2: static ownership of records (design)

W2 of `PLAN-awfy-lead.md`: make "this record has one holder" a compile-time
fact where the program's data flow proves it. The dynamic protocol (header
unique bit, young test, pointer-equality test) stays for everything else.

## Measured ceiling (2026-10-16, after W1 and W3)

A throwaway compiler that turned *every* reusing literal into stores into its
source record (no header test, no region test) gives, in AWFY instructions:
Towers -44%, Json -34%, Richards -32%, Bounce -11%, Queens -8%, Permute -5.5%.
DeltaBlue, CD and Havlak crash under it: they reuse records that other values
still hold. Those crashes are exactly what the proof below must exclude.

Dropping only the header test where no region test is needed (all-scalar
records, or every pointer field stored back unchanged) gives Richards -12% and
Bounce -11%: stage 1 alone. Towers and Json need stage 3 (a fresh pointer
entering an old record).

## What exists

- `lo_*` (compiler/lower.resid): per-function linearity of tracked values and
  the program-wide parameter masks `lop.lin` / `lop.mut` (`lo_fix`).
- Flag 1 on a node: the value is in a consuming chain. A struct literal with
  flag 1 is created unique (`resid_rec_new(size, 1)`), one without it shared
  (`, 0`). A struct call result outside a chain is frozen (`lo_freeze`:
  `resid_rec_share`).
- `lor`: a `return T {..}` (or `return f(.., T {..}, ..)` for a linear
  parameter of f) literal reuses a dead field-wise linear variable of type T.
  It lowers to `resid_rec_reuse{,_sc,_eq}(src)`. These rewrite src in place
  when its header says unique (and for `_eq`/plain, when it is young or every
  pointer field gets back what it holds), else allocate a fresh record. Either
  way the result is unique.
- Sharing that clears the bit after creation: `resid_rec_share` (freeze of a
  call result, a record stored into a list or another record, read from a
  list by `get_sh`), the `resid.rec.freeze.T` functions.

## Stage 1: statically unique header records

### The fact

SU(v) at a program point: the record v refers to has its header unique bit
set, and no value other than v refers to it. Then `resid_rec_reuse_sc(v)`
returns v, and `resid_rec_reuse_eq(v, s, same)` returns v whenever `same`.
Stage 1 lowers those two cases to the stores into v directly. A plain
`resid_rec_reuse` (young test) becomes `resid_rec_reuse_ny(v, size, same)`
(the region test alone).

### Expressions that produce SU

1. A struct literal of a header type that lowers to `resid_rec_new(_, 1)`,
   i.e. flag 1.
2. A reusing literal (`lor`): its result is unique by construction.
3. A call `f(..)` with flag 1 (not frozen) to a function f with `R(f)`
   (every return produces SU).
4. A variable that is SU at that point (below).
5. `if`/`match` expressions (and block values) whose every arm is SU.
6. A borrowed inline element (`T t = xs[i]` with flags 2 and 16, lowered to
   `resid_list_rec_borrow`): the element in place on a transient list,
   written back at its index before the list is used again, or a frame copy
   the runtime marks unique.

Nothing else: list reads, field reads of struct-typed fields, sum payloads,
closure captures, spawn results and persisted copies are never SU.

### Variables

A local bound to an SU expression, or a parameter with U(f, i), is SU from its
binding up to its consuming use. Valid only if:

- every other mention before that use is a field read `v.f` (the outer record
  is not shared by it; an inner record read this way is not SU itself); and
- the consuming use is one of: the source of a reusing literal, a `return v`,
  an argument at a parameter with U, a binding of another local (which
  inherits SU), or the receiver of a struct literal field (shares it, so SU
  ends there).

Any other mention (an argument at a non-U parameter, a list element, a
capture, a second consuming use on any path, use in a loop body when bound
outside the loop) makes the variable not SU anywhere. That is conservative,
and per variable per function.

### Parameter and return masks

U(f, i): greatest fixpoint, starting at 1 for header-typed parameters of
functions only ever called directly by name. A function is excluded when its
name appears as a `ref` (a value) or as a method-style call (`s.f()`, whose
sites are not checked as calls), or it is `main` or exported. A sandboxed
function stays eligible: its wrapper has its name, so every call site is
still a checked call.

B is computed to its own fixed point first: it depends on nothing else, and
an optimistic B would otherwise make U fall at sites whose arguments only
look like reads.

The SU variable set is by name, so a name bound more than once in a
function (a shadow, the same name in two blocks, a pattern or closure
parameter) is never SU.
Each round, U(f, i) falls to 0 if some call site passes an argument that is
not SU there. A call inside a lambda or spawn body passes nothing SU.

R(f): every return of f produces SU, again a greatest fixpoint.

U and R only fall, so the fixed point exists; the rounds are bounded like
`lo_fix`.

### Why it is sound

A record is rewritten in place only through a variable v with SU(v) at the
literal. SU(v) holds when v's record was created unique (rules 1 to 3, or a U
parameter, whose every caller passed such a record) and nothing since gave a
second value a reference to it: field reads do not, and every other mention
ends the variable's SU. The callee side of an argument at a U parameter is
the same variable rule applied to the parameter. A record's bit is cleared by
`resid_rec_share` only on a path that makes a second holder, and each of
those paths is a mention this analysis already treats as ending SU. So the
runtime test it replaces would have passed.

### Specialization (stage 1b, built)

When U(f, i) fails only because some callers pass shared records, the
commonest pattern of SU arguments at f's call sites picks a copy `f__su`
with those parameters U, emitted only when the body reuses one of them and
f is not recursive (the copy's self calls would leave it). A call uses the
copy when lowering's own check finds each assumed argument SU there. The
copy's calls pass at least as many SU records as the original's, so the
program's U and R stand. Copies lower on the graph with their fn nodes
added, with symbol offsets apart from every other function.

Lowering reuses the analysis's per-function snapshot graph, flags, call
list and duplicate names, so the analysis adds no compile time.

Measured (instructions vs 11a3c605): Richards -14.9%, Bounce -11.2%,
Permute -3.3%, CD -0.4%, DeltaBlue -0.5%, the rest unchanged.

## Found on the way (fixed separately)

Sharing an outer header record (a list read, a list copy) did not share the
unique records nested in its tracked fields when the element type has no
region mover: the store skipped `resid.rec.freezef.T`. A later reusing
literal then rewrote a nested record under another holder (committed bug,
conformance case `nested_record_share`). The store now freezes tracked
fields whatever the mover.

The code review of stage 1 found three more shipped aliasing bugs, also
fixed (conformance case `record_alias_store`): one record passed to a
parameter the callee only borrows and to one it consumes, in the same call
(the borrow is held while the callee runs; `lo_ce_call` and `su_call` now
refuse it); and a struct stored by `with` keeping a unique record in a
tracked field when it had no header or was stored through a variable (the
store now always freezes the tracked fields).

## Stage 2: owned list fields and borrowed elements

Inside an SU record, a list field that was never shared out is transient, and
an element read by `lo_borrows` from it is SU. That makes `set_rec_wb` a no-op
and the element literal a field store: Richards' `ts[cur]`, NBody's two takes.
Needs transient as a static fact: the list was created transient (literal,
builder, owned update) and every update since was owned.

## Stage 3: the region rule

A fresh pointer stored into an SU record that may be older than the current
region (Towers' `Disk` into `Piles`, Json's state) keeps the young test today.
Allocate such values in the record's region (`region_use`), or prove the
record is young: created in the same loop iteration, or no loop region
between.

## Verification

For each stage:

- `instructions:u` on all of AWFY against the previous commit;
- the fixed point, all suites, resid-ddc;
- compile time;
- conformance cases for each aliasing shape: two holders, a record passed and
  then read, a record kept in a sum, in a list, captured, spawned, returned
  from a non-R function, a U-function also called through a value, a loop
  rebinding, and a sandboxed function;
- an adversarial review before anything is committed.
