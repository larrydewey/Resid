---
title: Concurrency
description: Structured concurrency with spawn, capability lists, and failures delivered as values.
---

`spawn` runs a block on its own thread, **concurrently** with the code
that started it, and gives back a `Result`:

```resid
Int work(Int i, Int n, Int acc) {
    if (i >= n) { return acc; }
    return work(i + 1, n, (acc + i * i) % 1000003);
}

@requires(args)
Int main() {
    Int n = 1000000 + args.count();
    Result(Int, RegionError) a = spawn () { return work(0, n, 0); };
    Result(Int, RegionError) b = spawn () { return work(1, n, 0); };
    // Both regions are running now; each is waited for where it is used.
    Int total = (a else { 0 }) + (b else { 0 });
    println(f"{total > 0}");
    return 0;
}
```

```text title="Output"
true
```

- A region **starts immediately** and runs in parallel with the rest of the
  function (and with other regions).
- Using its result (in `match`, `else`, `?` or an f-string) **waits** for
  it. Later uses do not wait again.
- Completion is **structured**: every region is finished before the block
  that started it ends, and before a `return`, `break` or `continue` leaves
  that block, even if its result was never used. No thread outlives the
  code that owns it.
- The block sees the values it captures. Values are immutable, and what a
  region captures is shared from then on (never updated in place), so there
  are no data races.
- It receives **only the capabilities it lists**: `spawn (filesystem) { ... }`.
  The list may not exceed the parent's grants, and the block and everything
  it calls may use nothing else.
- A handle (an open `File`) captured by a region is **moved** into it: the
  parent may not use it afterwards.
- The Result's type is declared where it goes:
  `Result(T, RegionError) r = spawn (...) { ... };`, and the region's
  returns are checked against `T`.
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

Regions nest: a region can start regions of its own.
