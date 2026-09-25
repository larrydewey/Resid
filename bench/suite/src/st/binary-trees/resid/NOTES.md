# binary-trees (Resid, st)

Port of the binary-trees description
(https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/binarytrees.html):
stretch tree of depth max+1, one long-lived tree of depth max, then
2^(max-d+4) trees of each depth d = 4, 6, ..., max, each allocated
bottom-up, walked for its node count, and discarded.

Deviations and workarounds:

- Resid has no garbage collector and never frees on its own. Each
  short-lived tree is built and checked in one scalar binding
  (`Int c = check(bottom_up(d, Leaf));`). The compiler evaluates such a
  binding in a scalar scope: every allocation made while computing a plain
  `Int` is released as soon as the `Int` is known, because an immutable
  value allocated there cannot be reachable from it. The long-lived tree is
  bound to a `Tree` and lives until exit. No runtime calls appear in the
  program.
- Sum-type variants carry a single payload (a two-field variant like
  `Node(Tree, Tree)` is not accepted), so a node is `Node(Pair)` with a
  `{ Tree l; Tree r; }` record. A variant whose payload is a record stores
  the record's fields inline, so each node is one 32-byte block (16-byte
  header plus the two child pointers), the same footprint as a malloc'd C
  node.
- The children of a bottom node are one shared `Leaf` value per tree (the
  counterpart of the C programs' NULL child pointers) instead of two fresh
  allocations; this cut run time by about 40%.
- The per-depth lines are accumulated into one string and printed with a
  single call (`print` flushes on every call); the bytes are identical.

Measured on this host (2026-09-25): size 21 (official) 2.2 s / 265 MB
peak RSS (C: 6.7 s / 264 MB); size 16 0.06 s / 18 MB. Output identical to
C.
