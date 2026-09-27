---
title: Errors and absence
description: Option and Result, the ? operator, else, and when a program aborts.
---

Resid has no null and no exceptions. Absence is `Option(T)`; failure that
a caller should handle is `Result(T, E)`.

## Option

```resid
Option(Int) find_index(List(Str) xs, Str want, Int i) {
    if (i >= xs.len()) { return None; }
    if (xs[i] == want) { return Some(i); }
    return find_index(xs, want, i + 1);
}

Int main() {
    List(Str) xs = ["a", "b", "c"];
    println(f"{find_index(xs, "c", 0)} {find_index(xs, "z", 0)}");
    Int at = find_index(xs, "b", 0) else { -1 };
    println(f"{at}");
    return 0;
}
```

```text title="Output"
Some(2) None
1
```

`value else { default }` unwraps an `Option` or `Result`, running the block
when there is no value.

## Result and ?

```resid
Result(Int, Str) parse_port(Str s) {
    if (!str_is_int(s)) { return Err(f"not a number: {s}"); }
    Int p = str_parse_int(s);
    if (p < 1 || p > 65535) { return Err(f"out of range: {p}"); }
    return Ok(p);
}

Result(Int, Str) next_port(Str s) {
    Int p = parse_port(s)?;        // an Err returns from next_port at once
    return Ok(p + 1);
}

Int main() {
    println(f"{next_port("8080")} {next_port("http")} {next_port("99999")}");
    return 0;
}
```

```text title="Output"
Ok(8081) Err("not a number: http") Err("out of range: 99999")
```

`e?` unwraps a value or returns the `None` / `Err` from the enclosing
function, so it needs a function that returns an `Option` or a `Result`.
In `main`, handle errors with `else` or `match`.

## Aborts are for bugs

Some failures are not values but program errors, and they abort the
process with a message: arithmetic overflow, division by zero, an index out
of range, a checked conversion that does not fit, a broken constraint,
`assert(false, "...")`, `todo()`. Inside a [`spawn`](/Resid/learn/concurrency/)
region an abort becomes an `Err(RegionError)` for the parent instead.
