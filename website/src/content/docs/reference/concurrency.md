---
title: Concurrency
description: spawn regions, capability environments and failure as a value.
---

```text
Result(T, RegionError) r = spawn (cap1, cap2) {
    return value;
};
```

- The capabilities are listed explicitly, and the child's list must not
  exceed the parent's (`E0214`).
- The child receives a fresh capability environment: the spawn body and
  everything it calls may use only the listed capabilities (`E0214`,
  `E0215`), and the child thread runs in its own capability frame at run
  time.
- The body returns pure values. Immutable values may be shared; mutable
  handles must be moved.
- A failure in the child (an abort of any kind) is delivered to the parent
  as `Err(RegionError)`; it does not end the process.
- Spawns nest. Completion is structured: the parent receives the result
  only after the child finishes. The scheduler is implementation-defined;
  the current implementation runs each region on its own thread.
