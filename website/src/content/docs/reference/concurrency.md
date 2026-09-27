---
title: Concurrency
description: spawn regions, capability environments and failure as a value.
---

```text
Result(T, RegionError) r = spawn (cap1, cap2) {
    return value;
};
```

- The Result's type is declared where it goes (a binding or a return);
  the region's returns are checked against its `T`, and every path must
  return. A region returns values, not handles.
- The capabilities are listed explicitly, and the child's list must not
  exceed the parent's (`E0214`).
- The child receives a fresh capability environment: the spawn body and
  everything it calls may use only the listed capabilities (`E0214`,
  `E0215`), and the child thread runs in its own capability frame at run
  time.
- **Execution.** A region bound to a name starts when the binding runs and
  executes concurrently on its own thread; the first use of the name waits
  for its result. A spawn anywhere else (returned, matched inline) is
  started and waited for at once.
- **Structured completion.** Every region is finished before the block
  that bound it ends, and before any `return`, `break` or `continue` leaves
  that block, whether or not its result was used.
- **Sharing.** Captured values are shared from the point of capture:
  transient maps are frozen and unique records marked shared, so neither
  the parent nor the child updates them in place.
- **Handles move.** A handle a region captures may not be used by the
  parent after the spawn.
- A failure in the child (an abort of any kind) is delivered to the parent
  as `Err(RegionError)`; it does not end the process.
- Spawns nest. When no thread can be created, the region runs at once in
  the parent, with the same result.
