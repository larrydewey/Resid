---
title: Records, sums and constraints
description: Defining your own types; product and sum types, generics in sums, constraint types.
---

## Records

A record (product type) has named, typed fields. Two spellings declare the
same type:

```resid
type Point = { Int x; Int y; };
type Size = { w: Int, h: Int };

Int main() {
    Point p = Point {.x = 3, .y = 4};
    Size s = Size { w = 10, h = 20 };
    println(f"{p} {s.w * s.h}");
    Point { x, y } = p;          // destructuring
    println(f"{x + y}");
    return 0;
}
```

```text title="Output"
Point { x: 3, y: 4 } 200
7
```

Records are values: to "change" a field, build a new record. Compare
records by their fields; `==` is defined on numbers, `Bool` and `Str`.

## Sums

A sum type is one of several variants, each with an optional payload:

```resid
type Json = Num(Int) | Text(Str) | Flag(Bool) | Null;

Str kind(Json j) {
    return match j {
        Num(n) => f"number {n}",
        Text(s) => f"text {s}",
        Flag(b) => f"flag {b}",
        Null => "null",
    };
}

Int main() {
    println(kind(Num(3)));
    println(kind(Text("hi")));
    println(f"{Flag(true)} {Null}");
    return 0;
}
```

```text title="Output"
number 3
text hi
Flag(true) Null
```

Sum types may take type parameters; `Option` and `Result` are built this
way:

```resid
type Box(T) = Full(T) | Nothing;

Int unbox(Box(Int) b) {
    return match b {
        Full(x) => x,
        Nothing => 0,
    };
}

Int main() {
    println(f"{unbox(Full(3))} {unbox(Nothing)}");
    return 0;
}
```

```text title="Output"
3 0
```

## Constraint types

A constraint type is a base type plus a predicate over `value`:

```resid
type Percent = Int[value >= 0 && value <= 100];
type Even = Int where value % 2 == 0;

@requires(args)
Int main() {
    Percent p = 42;              // checked while compiling
    Even e = args.count() * 2;   // checked when bound, at run time
    println(f"{p} {e}");
    return 0;
}
```

```text title="Output"
42 2
```

A known value that breaks the constraint is a compile-time error (`E0301`);
a runtime value that breaks it aborts at the binding with a message naming
the constraint.

## Type aliases

`type Meters = Int;` names a type without adding a constraint.

## Generic types

A record or sum can take type parameters, single uppercase letters:

```resid
type Pair(T) = { T a; T b; };

Int main() {
    Pair(Int) p = Pair {.a = 1, .b = 2};
    Pair(Str) q = Pair {.a = "x", .b = "y"};
    println(f"{p.a + p.b} {q}");
    return 0;
}
```

```text title="Output"
3 Pair { a: "x", b: "y" }
```

Functions can be generic too; see
[Generic functions and records](/Resid/behaviors/generics/).
