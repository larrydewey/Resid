# binary-trees (Resid, st)

Port of the binary-trees description
(https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/binarytrees.html):
stretch tree of depth max+1, one long-lived tree of depth max, then
2^(max-d+4) trees of each depth d = 4, 6, ..., max, each allocated
bottom-up, walked for its node count, and discarded.

Deviations and workarounds:

- Resid has no garbage collector and never frees on its own. Short-lived
  trees are built and checked inside runtime arena scopes
  (`resid_bulk_push()` / `resid_bulk_pop()`), about 2^15 nodes' worth of
  trees per scope; popping the scope frees the whole batch and only the
  `Int` check sum survives. The long-lived tree is allocated outside any
  scope. This is the arena/pool strategy some C and Rust reference programs
  also use.
- Sum-type variants carry a single payload (a two-field variant like
  `Node(Tree, Tree)` is not accepted), so a node is `Node(Pair)` with a
  `{ Tree l; Tree r; }` record.
- The children of a bottom node are one shared `Leaf` value per tree (the
  counterpart of the C programs' NULL child pointers) instead of two fresh
  allocations; this cut run time by about 40%.
- The per-depth lines are accumulated into one string and printed with a
  single call (`print` flushes on every call); the bytes are identical.

Measured on this host (2026-09-25): size 16 0.11 s / 24 MB peak RSS;
size 21 (official) 5.8 s / 514 MB.
