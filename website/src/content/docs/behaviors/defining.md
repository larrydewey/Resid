---
title: Your own behaviors
description: Declaring behaviors, giving instances, bundles, behaviors over several types, overrides and coherence.
---

`Ord` and `Show` are not special: they are behaviors the prelude declares,
and you declare your own the same way.

## Declaring a behavior

A behavior lists one or more functions as *prototypes*: a signature with
no body. Each prototype is a **verb** you call like any function.

```resid
type Circle = { Float r; };
type Square = { Float side; };

behavior Area(T) {
    Float area(T shape);
}

Float circle_area(Circle c) { return 3.0 * c.r * c.r; }
Float square_area(Square s) { return s.side * s.side; }
Area(Circle) = circle_area;
Area(Square) = square_area;

Int main() {
    println(f"{area(Circle {.r = 2.0})} {area(Square {.side = 3.0})}");
    return 0;
}
```

```text title="Output"
12 9
```

`area(c)` picks the instance for the argument's type at compile time and
calls its function: after checking, the call *is* `circle_area(c)`, so
reduction folds it like any other call.

## Several functions: a bundle

When functions must agree with each other, keep them in one behavior. An
instance then gives a record of functions, one per verb:

```resid
type Square = { Float side; };

behavior Shape(T) {
    Float surface(T s);
    Float perimeter(T s);
}

Float sq_surface(Square s) { return s.side * s.side; }
Float sq_perimeter(Square s) { return 4.0 * s.side; }
Shape(Square) = { .surface = sq_surface, .perimeter = sq_perimeter };

Int main() {
    Square s = Square {.side = 3.0};
    println(f"{surface(s)} {perimeter(s)}");
    return 0;
}
```

```text title="Output"
9 12
```

Every verb needs an entry, and every entry must name a verb.

## Behaviors over several types

A behavior may relate several types. A type that appears only in a
result comes from where the result goes:

```resid
type Celsius = { Float deg; };
type Kelvin = { Float deg; };

behavior Convert(A, B) {
    B convert(A x);
}

Kelvin c_to_k(Celsius c) { return Kelvin {.deg = c.deg + 273.15}; }
Convert(Celsius, Kelvin) = c_to_k;

Int main() {
    Kelvin k = convert(Celsius {.deg = 0.0});
    println(f"{k.deg}");
    return 0;
}
```

```text title="Output"
273.15
```

If a behavior's type can be fixed neither by the arguments nor by the
expected type, the call is an error (`E0227`).

## Instances for every type argument

An instance may cover a whole family, `Pair(T)` for every `T`. Its
function is generic and states what it needs of `T`
(see [generic functions](/Resid/behaviors/generics/)):

```resid
type Pair(T) = { T a; T b; };

@needs(Show(T))
Str show_pair(Pair(T) p) { return f"<{p.a}|{p.b}>"; }
Show(Pair(T)) = show_pair;

Int main() {
    Pair(Int) p = Pair {.a = 1, .b = 2};
    Pair(Str) q = Pair {.a = "x", .b = "y"};
    println(f"{p} {q}");
    return 0;
}
```

```text title="Output"
<1|2> <x|y>
```

## Deriving an instance

There are no default bodies. To build one behavior from another, name a
generic function that needs it; the derivation is visible in the source
and recorded in the knowledge graph.

```resid
type Task = { Str name; Int p; };

Int by_p(Task a, Task b) { return a.p - b.p; }
Ord(Task) = by_p;

@needs(Ord(T))
Bool eq_from_ord(T a, T b) { return compare(a, b) == 0; }
Eq(Task) = eq_from_ord;

Int main() {
    Task a = Task {.name = "a", .p = 1};
    Task b = Task {.name = "b", .p = 1};
    println(f"{a == b} {a < b}");
    return 0;
}
```

```text title="Output"
true false
```

`==` and `!=` on a type with an `Eq` instance call it; `<`, `<=`, `>` and
`>=` on a type with an `Ord` instance call it.

## Overriding at a call

`using =` picks another function or instance for one call:

```resid
type Square = { Float side; };

behavior Area(T) {
    Float area(T shape);
}

Float square_area(Square s) { return s.side * s.side; }
Float half_area(Square s) { return s.side * s.side / 2.0; }
Area(Square) = square_area;

Int main() {
    Square s = Square {.side = 2.0};
    println(f"{area(s)} {area(s, using = half_area)}");
    return 0;
}
```

```text title="Output"
4 2
```

`using = Reverse(B)` swaps a two-argument verb's arguments, which reverses
an ordering.

## One instance per type

A program has at most one instance of a behavior for a type.

- Two instances whose types overlap at the same level, such as
  `Show(Pair(T))` and `Show(Pair(Int))`, are an error (`E0225`): there is no
  "most specific wins".
- **Levels.** The application outranks a library, which outranks the
  prelude. An instance at a higher level *replaces* a lower one for its
  type, everywhere in the program, including inside the library, so a
  `Map` keyed by that type hashes the same way throughout. The
  replacement is recorded in the knowledge graph.
- **Orphans.** A library may declare an instance only of its own behaviors
  or its own types (`E0224`). The application may declare any instance, so
  it can always settle a conflict between two libraries.

## Authority

An instance's function runs where the behavior is used, so the functions
using it need what it needs (`E0219`). For a generic function, its
authority is its own `@requires` plus what the instances it is given
need, and the concrete caller holds it:

```resid
// expect-error: E0219
type Task = { Str path; };

@requires(filesystem)
Str show_task(Task t) { return filesystem.read_all(t.path); }
Show(Task) = show_task;

@needs(Show(T))
Str label(T x) { return "[" + show(x) + "]"; }

Int main() {
    println(label(Task {.path = "/etc/hostname"}));
    return 0;
}
```

```text
error[E0219]: function `main` uses (through `label(Task)`) capability `filesystem` but is not granted it: declare @requires(filesystem) on it (no ambient authority, spec §20)
```

A generic function declared inside a `sandbox` keeps that ceiling for
every type it is instantiated at.

## Not traits

A behavior is knowledge stated from outside a type. Resid keeps it that
way:

- a type never declares what it implements;
- verbs are functions, not methods on the type;
- nothing dispatches on a value of unknown type at run time; every
  instance is chosen at compile time;
- behaviors do not inherit from one another; a function lists each need;
- a behavior contains no types of its own.
