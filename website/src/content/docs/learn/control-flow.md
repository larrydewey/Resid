---
title: Control flow
description: if and match expressions, for loops over ranges and lists, while-let, break and continue.
---

## if

`if` is a statement and an expression. As an expression it must have an
`else`, and both branches must have the same type:

```resid
Str size(Int n) {
    return if (n < 10) { "small" } else if (n < 100) { "medium" } else { "large" };
}

Int main() {
    println(f"{size(3)} {size(42)} {size(500)}");
    return 0;
}
```

```text title="Output"
small medium large
```

Conditions must be `Bool`; there is no truthiness. `&&` and `||`
short-circuit.

## match

`match` takes apart a sum type (`Option`, `Result`, or your own) and is an
expression:

```resid
type Shape = Circle(Int) | Rect(Int) | Empty;

Int area(Shape s) {
    return match s {
        Circle(r) => 3 * r * r,
        Rect(side) => side * side,
        Empty => 0,
    };
}

Int main() {
    println(f"{area(Circle(2))} {area(Rect(3))} {area(Empty)}");
    return 0;
}
```

```text title="Output"
12 9 0
```

Each arm binds the variant's payload. Arms can themselves branch,
match again, or use `else`.

## for

`for` walks a range or a list. The loop variable is a fresh binding on every
iteration:

```resid
Int main() {
    for (Int i in 0..3) {
        println(f"row {i}");
    }
    List(Str) fruit = ["fig", "pear"];
    for (Str f in fruit) {
        println(f);
    }
    return 0;
}
```

```text title="Output"
row 0
row 1
row 2
fig
pear
```

`a..b` is half-open and `a..=b` includes `b`. `break` and `continue` work
as in C.

A `for` loop cannot accumulate into an outer binding, because there is no
assignment. To compute a result, use recursion or a [linear
builder](/Resid/reference/builders/) passed through a recursive function:

```resid
Int sum_list(List(Int) xs, Int i, Int acc) {
    if (i >= xs.len()) { return acc; }
    return sum_list(xs, i + 1, acc + xs[i]);
}

Int main() {
    List(Int) xs = [4, 8, 15, 16, 23, 42];
    println(f"{sum_list(xs, 0, 0)} {xs.sum()}");
    return 0;
}
```

```text title="Output"
108 108
```

## if-let and while-let

A pattern in a condition binds on success:

```resid
Int main() {
    Option(Int) found = Some(7);
    if (Some(v) = found) {
        println(f"found {v}");
    } else {
        println("nothing");
    }
    return 0;
}
```

```text title="Output"
found 7
```

`while (Some(x) = next()) { ... }` loops while the pattern matches.
