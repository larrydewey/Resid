---
title: Show and f-strings
description: How values become text, the built-in formats, and Show instances.
---

In Resid, `f"{x}"` is **the** way to turn a value into text. There are no
`to_string` methods and no per-type conversion functions. What a hole
prints depends on the value's type.

## Built-in formats

```resid
type Point = { Int x; Int y; };
type Shape = Circle(Int) | Rect(Point) | Empty;

Int main() {
    println(f"{42} {3.14} {true} {1.50m:.}");
    println(f"{[1, 2]} {["a", "b"]} {{"k": 1}}");
    println(f"{Point {.x = 1, .y = 2}}");
    println(f"{Circle(3)} {Rect(Point {.x = 0, .y = 0})} {Empty}");
    println(f"{Some("x")} {None}");
    return 0;
}
```

```text title="Output"
42 3.14 true 1.5
[1, 2] ["a", "b"] {"k": 1}
Point { x: 1, y: 2 }
Circle(3) Rect(Point { x: 0, y: 0 }) Empty
Some("x") None
```

- Integers print in full at any width; floats print the shortest text that
  reads back as the same value; a `Dec` prints all its digits (`:.` trims
  trailing zeros).
- A string prints as is at the top level and quoted inside a container.
- Records print their type and fields; variants print their name and
  payload; lists, maps and sets print their elements.

## Show instances

`Show(T) = f;` with `Str f(T v)` replaces the built-in text for `T`,
**everywhere**: in a hole, as a record field, inside a list or an option.

```resid
type Money = { Int cents; };

Str dollars(Money m) {
    Int c = m.cents % 100;
    Str pad = if (c < 10) { "0" } else { "" };
    return f"${m.cents / 100}.{pad}{c}";
}
Show(Money) = dollars;

type Line = { Str item; Money price; };

Int main() {
    Money m = Money {.cents = 1205};
    println(f"total: {m}");
    println(f"{Line {.item = "tea", .price = m}}");
    println(f"{[Money {.cents = 5}, Money {.cents = 199}]}");
    return 0;
}
```

```text title="Output"
total: $12.05
Line { item: "tea", price: $12.05 }
[$0.05, $1.99]
```

A `Show` instance is how you give a type a display format. For different
formats in different places, write ordinary functions (`Str csv(Row r)`,
`Str short(Money m)`) and call them in the hole: `f"{short(m)}"`.
