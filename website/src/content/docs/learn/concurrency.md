---
title: Concurrency
description: Structured concurrency with spawn, capability lists, and failures delivered as values.
---

`spawn` runs a block on its own thread and gives back a `Result`:

```resid
Int work(Int n) { return n * n; }

Int main() {
    Int base = 7;
    Result(Int, RegionError) r = spawn () {
        return work(base) + 1;
    };
    Int v = r else { -1 };
    println(f"{v}");
    return 0;
}
```

```text title="Output"
50
```

- The block sees the values it captures; values are immutable, so sharing
  them is safe.
- It receives **only the capabilities it lists**: `spawn (filesystem) { ... }`.
  The list may not exceed the parent's grants, and the block and everything
  it calls may use nothing else.
- A failure inside the region (an overflow, an index out of range, an
  explicit abort) does not bring the process down. The parent gets
  `Err(RegionError)`:

```resid
Int boom(Int i) {
    List(Int) xs = [1];
    return xs[i];
}

Int main() {
    Result(Int, RegionError) r = spawn () {
        return boom(5);
    };
    Str s = match r { Ok(n) => f"ok {n}", Err(e) => "the region failed" };
    println(s);
    return 0;
}
```

```text title="Output"
the region failed
```

Regions nest, and completion is structured: a region's result exists only
after its thread has finished.
