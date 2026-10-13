# Resid port of Are We Fast Yet

Written for this suite from the Java and C++ references (upstream commit in
`../upstream/COMMIT`), benchmark by benchmark, with the same algorithms, the
same data and the same verification values.

## Modes

- `out/harness` (runtime mode, the headline): every constant the reference
  writes into a benchmark (Sieve's 5000, Queens' 8, the random seed 74755,
  Json's document, Havlak's loop counts, ...) is marked `rt`, so the
  compiler cannot compute a result while it builds the program. Without
  this, Resid's compile-time reduction evaluates Bounce, List, Permute,
  Queens and Storage entirely at build time.
- `out/harness-aw` (as-written mode): the same files with every `rt`
  removed (`build` does it), so reduction folds whatever it can.

## How the reference's mutable objects map to values

Resid values are immutable. Where a reference mutates objects, the port
keeps the same objects as records and the same steps, and threads the
state through calls:

- **Object graphs** (Richards' tasks and packets, DeltaBlue's variables and
  constraints, Havlak's blocks, union-find nodes and loops, CD's red-black
  tree nodes) live in indexed lists inside a state record; references are
  indices and null is -1. A field assignment is a record update stored back
  into its list (`xs.with(i, ...)`), which the compiler performs in place
  when it can prove the old list is no longer used.
- **Virtual dispatch** over constraint and task kinds (DeltaBlue's
  constraint subclasses, Richards' task functions) is a dispatch on a kind
  field instead of a stored closure.
- **Vectors used as queues** (`removeFirst`) are lists read from a head index.
- **Loops** are tail calls, as everywhere in Resid; `forEach` with a closure
  is a tail-recursive walk.
- **Math.sin/cos** (CD's simulator): Resid has no `sin`/`cos`, so the port
  carries fdlibm's (`fdlibm.resid`, StrictMath's algorithm), checked bit for
  bit against `java.lang.StrictMath` on 3,000 points.
- **Havlak** keeps the reference's quirks: `findSet` points the compressed
  nodes at the starting node's parent, and `stepE` walks a set that it may
  extend while walking it. The 50 discarded `findLoops` runs are summed and
  asserted so that no compiler can drop them.
- **DeltaBlue**: the reference's `Vector.sort` implements no swap and is only
  reached with lists already in order; the port asserts the same.

## Reviewer

Not yet reviewed by a second Resid programmer.
