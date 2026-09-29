---
title: Generic functions and records
description: Type parameters, width parameters, @needs, inference and how copies are made.
---

A single uppercase letter in a signature or a type declaration is a
**type parameter**. Functions and records that use one are generic.

```resid
type Pair(T) = { T a; T b; };
type Entry(K, V) = { K key; V value; Int hits; };

T first(List(T) xs) { return xs[0]; }
Pair(T) twin(T x) { return Pair {.a = x, .b = x}; }

Int main() {
    Pair(Int) p = Pair {.a = 1, .b = 2};
    Entry(Str, Int) e = Entry {.key = "a", .value = 7, .hits = 0};
    println(f"{p} {twin("hi")} {first([7, 8])} {e.value}");
    return 0;
}
```

```text title="Output"
Pair { a: 1, b: 2 } Pair { a: "hi", b: "hi" } 7 7
```

A record literal takes its type arguments from the binding's type or from
its field values. Records may mix type parameters and concrete fields.

## Width parameters

In a width position (`Int(N)`, `UInt(N)`, `Float(N)`) a parameter ranges
over widths, so one function serves every width:

```resid
Int(N) clamp_pos(Int(N) x) { return if (x < 0) { 0 } else { x }; }

Int main() {
    Int(8) small = -3;
    println(f"{clamp_pos(small)} {clamp_pos(9)}");
    return 0;
}
```

```text title="Output"
0 9
```

## What a generic function needs: @needs

Inside a generic body a `T` is opaque. Sorting, displaying, comparing
(`==`, `<`) or calling a behavior's verb on it requires naming the behavior
in `@needs`, next to `@requires`:

```resid
@needs(Ord(T))
T biggest(List(T) xs) { return sort(xs)[xs.len() - 1]; }

@needs(Eq(T))
Bool has(List(T) xs, T x, Int i) {
    if (i >= xs.len()) { return false; }
    if (xs[i] == x) { return true; }
    return has(xs, x, i + 1);
}

Int main() {
    println(f"{biggest([3, 9, 4])} {biggest(["b", "a"])} {has([1, 2], 2, 0)}");
    return 0;
}
```

```text title="Output"
9 b true
```

Leaving a need out is caught where the function is defined:

```resid
// expect-error: E0226
T smallest(List(T) xs) { return sort(xs)[0]; }

Int main() { return smallest([2, 1]); }
```

```text
error[E0226]: sort of T needs Ord(T): add @needs(Ord(T)) to the function
```

Every call checks its needs for its types: calling `biggest` on a record
with no `Ord` instance is an error naming the missing instance. A call may
also override a need:

```resid
@needs(Ord(T))
T top(List(T) xs) { return sort(xs)[0]; }

Int main() {
    println(f"{top([3, 1, 2])} {top([3, 1, 2], using = Reverse(Ord(Int)))}");
    return 0;
}
```

```text title="Output"
1 3
```

## Inference

Each type parameter comes from the arguments, else from the type the
result is bound to, else from the one instance that fits one of the
function's needs. That last step lets a parameter appear only in
`@needs`: with `@needs(Convert(A, Pair(B)))` and the instance
`Convert(Int, Pair(Int))`, a call on an `Int` has `B = Int`. When none
fixes it, the call is an error (`E0227`):

```resid
List(T) empty() {
    List(T) e = [];
    return e;
}

Int main() {
    List(Int) xs = empty();
    println(f"{xs.len()}");
    return 0;
}
```

```text title="Output"
0
```

## How copies are made

Generics are resolved during checking, before reduction. Each call whose
types are all known calls a copy of the function made for those types
(`first(List(Int))`), and each generic record used at a type gets its
layout. The reducer and code generator see only concrete functions and
types, so a generic call is as fast as a hand-written one and reduces the
same way. Every copy is recorded in the knowledge graph.

A generic function that calls itself at ever larger types (polymorphic
recursion, such as `f(T)` calling `f(Box(T))`) would need infinitely many
copies and is rejected (`E0228`). Lambdas are not generic.

Only single letters are type parameters. An unknown type name of more
than one letter is an error, so a misspelled type is never taken for a
parameter.
