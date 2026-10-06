---
title: Collections
description: Lists, maps and sets as immutable values; slicing, sorting and the list verbs.
---

Collections are **values**. "Changing" one gives you a new value and leaves
the old one intact. When the compiler can prove the old version is never
read again, it updates in place, so you get value semantics at the cost of
a mutable data structure.

## Lists

```resid
Int main() {
    List(Int) xs = [3, 1, 2];
    List(Int) more = xs.concat([10, 20]);
    println(f"{xs} {more} {more.len()}");
    println(f"{more[1..3]} {sort(xs)} {xs.reverse()}");
    println(f"{xs.contains(2)} {xs.sum()}");
    return 0;
}
```

```text title="Output"
[3, 1, 2] [3, 1, 2, 10, 20] 5
[1, 2] [1, 2, 3] [2, 1, 3]
true 6
```

Indexing is bounds-checked; an out-of-range index aborts with the index and
the length. An empty list needs its type from the binding:
`List(Int) none = [];`.

`xs.with(i, x)` is the list with element `i` replaced; `xs` itself is
unchanged. Thread a list through a loop and each update happens in place:

```resid
List(Int) squares(List(Int) xs, Int i) {
    if (i >= xs.len()) { return xs; }
    return squares(xs.with(i, i * i), i + 1);
}

Int main() {
    List(Int) zs = [0, 0, 0, 0, 0];
    List(Int) sq = squares(zs, 0);
    println(f"{zs} {sq} {sq.with(0, 9)}");
    return 0;
}
```

```text title="Output"
[0, 0, 0, 0, 0] [0, 1, 4, 9, 16] [9, 1, 4, 9, 16]
```

The index is checked like `xs[i]`. When the old list is never read again
(here `zs` is, so the first update copies it), the compiler replaces the
element where it is, as it does for a map's `insert`.

## Maps

```resid
Int main() {
    Map(Str, Int) ages = {"ada": 36, "alan": 41};
    Map(Str, Int) more = ages.insert("grace", 85);
    println(f"{ages.len()} {more.len()} {more.contains("grace")}");
    Int a = ages.get("ada") else { 0 };
    Int z = ages.get("zed") else { -1 };
    println(f"{a} {z}");
    List(Str) names = sort(more.keys());
    println(f"{names}");
    return 0;
}
```

```text title="Output"
2 3 true
36 -1
["ada", "alan", "grace"]
```

`m.get(k)` (or `m[k]`) returns an `Option`; `else` supplies a default.
`insert` and `remove` return the new map. Map iteration order is by key
hash, so sort keys when order matters.

## Sets

```resid
Int main() {
    Set(Int) a = {1, 2, 3};
    Set(Int) b = {3, 4};
    println(f"{a.union(b).len()} {a.intersection(b).len()} {a.difference(b).len()}");
    println(f"{a.contains(2)} {a.insert(9).len()}");
    return 0;
}
```

```text title="Output"
4 1 2
true 4
```

## Building large collections

Each `concat` builds a new list. To produce a big list piece by piece, use a
**linear builder**: `ListBuf(T)` (and `StrBuf` for strings) appends in place
because the compiler guarantees each builder value is used exactly once:

```resid
ListBuf(Int) squares(Int i, Int n, ListBuf(Int) acc) {
    if (i >= n) { return acc; }
    return squares(i + 1, n, acc.push(i * i));
}

Int main() {
    List(Int) sq = squares(0, 6, ListBuf()).finish();
    println(f"{sq}");
    return 0;
}
```

```text title="Output"
[0, 1, 4, 9, 16, 25]
```

See [Linear builders](/Resid/reference/builders/) for the rules.
