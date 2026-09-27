---
title: Types
description: Core types, records, sums, generic sums, constraint types and aliases.
---

## Core types

`Bool`; the numeric family ([Numbers](/Resid/reference/numbers/)); `Str`
(immutable UTF-8, indexed by code point); `Bytes`; `List(T)`;
`Map(K, V)`; `Set(T)`; `Option(T)`; `Result(T, E)`; `RegionError`;
`SourceLoc`; the builders `StrBuf` and `ListBuf(T)`; closure types
`R closure(P1, P2)`; and the fixed-capacity `Str(N)`, `Bytes(N)` and
`List(T, N)` ([Fixed capacity](/Resid/reference/fixed-capacity/)).

All values are immutable and have no observable identity. Only *handles*
(for example an open `File`) carry identity; they are runtime resources
under capability control.

## Records

```text
type Point = { Int x; Int y; };          // field declarations
type Point = { x: Int, y: Int };         // the same type
```

Literals name every field: `Point {.x = 1, .y = 2}` or
`Point { x = 1, y = 2 }`. `p.x` reads a field. A record is destructured with
`Point { x, y } = p;`.

## Sums

```text
type Shape = Circle(Int) | Rect(Point) | Empty;
type Option(T) = Some(T) | None;         // generic
```

A variant carries at most one payload (use a record for several values).
Values are built by calling the variant (`Circle(2)`) or naming it
(`Empty`) and taken apart with `match`.

## Constraint types

```text
type Positive = Int[value > 0];
type Positive = Int where value > 0;
```

A constraint type is its base type plus a predicate over `value`. A value
bound to it is checked: at compile time when known (`E0301` on failure),
otherwise at the binding at run time (an abort naming the constraint). A
constrained value is usable wherever its base type is.

## Aliases

`type Meters = Int;` gives a type another name.

## Equality

`==` and `!=` compare numbers (with the numeric widening rules), `Bool` and
`Str`. Records, lists, maps, sets, options and sums are compared by their
parts; `==` on them is a compile-time error.
