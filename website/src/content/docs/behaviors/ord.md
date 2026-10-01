---
title: Ord and sorting
description: Ordering values with Ord instances, comparator functions and Reverse.
---

`sort(xs)` returns a new, sorted list. The sort is stable: equal elements
keep their order.

## Built-in orderings

Numbers of every width and `Str` have a built-in ordering:

```resid
Int main() {
    println(f"{sort([5, 3, 9, 1])}");
    println(f"{sort(["pear", "apple", "fig"])}");
    println(f"{sort([2.5, -1.0, 0.25])}");
    println(f"{sort([3, 1, 2], using = Reverse(Ord(Int)))}");
    return 0;
}
```

```text title="Output"
[1, 3, 5, 9]
["apple", "fig", "pear"]
[-1, 0.25, 2.5]
[3, 2, 1]
```

## Ordering your own types

An `Ord(T)` instance is a complete record of three verbs: `compare`
orders two values, `least` returns the lesser of two, and `greatest`
returns the greater of two. The `sort` function uses `compare`.

`least` and `greatest` are reached by name, so a `T` of your own never
collides with the `min(a, b)` and `max(a, b)` builtins, which want
numbers, or with `Bounded(T)`'s `x.min()` and `x.max()`, which take no
argument at all (see [Generic verbs](/Resid/behaviors/generic-verbs/)).

```resid
type Version = { Int major; Int minor; };

Int newer_last(Version a, Version b) {
    return if (a.major != b.major) { a.major - b.major } else { a.minor - b.minor };
}
@needs(Ord(T))
T lo(T a, T b) { return if (compare(a, b) <= 0) { a } else { b }; }
@needs(Ord(T))
T hi(T a, T b) { return if (compare(a, b) >= 0) { a } else { b }; }
Ord(Version) = { .compare = newer_last, .least = lo, .greatest = hi };

Int main() {
    List(Version) vs = [
        Version {.major = 2, .minor = 1},
        Version {.major = 1, .minor = 9},
        Version {.major = 2, .minor = 0},
    ];
    println(f"{sort(vs)}");
    return 0;
}
```

```text title="Output"
[Version { major: 1, minor: 9 }, Version { major: 2, minor: 0 }, Version { major: 2, minor: 1 }]
```

With one `Ord(Version)` instance declared, `sort(vs)` inserts it
automatically. A type has at most one instance per behavior; a second
`Ord(Version) = ...` is an error.

## Other orderings: using =

The instance is the default. Any other comparator can be passed directly,
and `Reverse` flips an ordering:

```resid
type City = { Str name; Int population; };

Int by_population(City a, City b) { return a.population - b.population; }
Int by_name_length(City a, City b) { return str_len(a.name) - str_len(b.name); }
City lo(City a, City b) { return if (by_population(a, b) <= 0) { a } else { b }; }
City hi(City a, City b) { return if (by_population(a, b) >= 0) { a } else { b }; }
Ord(City) = { .compare = by_population, .least = lo, .greatest = hi };

Int main() {
    List(City) cs = [
        City {.name = "Lima", .population = 10},
        City {.name = "Oslo", .population = 1},
        City {.name = "Nairobi", .population = 5},
    ];
    List(City) biggest = sort(cs, using = Reverse(Ord(City)));
    List(City) short_names = sort(cs, using = by_name_length);
    println(f"{biggest[0].name} {short_names[2].name}");
    return 0;
}
```

```text title="Output"
Lima Nairobi
```

`using =` accepts `Ord(T)` (the instance, or the built-in ordering),
a comparator function, and `Reverse(...)` of either, nested as deeply as
you like.

## Rules

- The comparator's signature must be exactly `Int f(T, T)`, where `T` is
  the element type.
- The comparator's result is normalized to -1, 0 or 1 before `Reverse` is
  applied, so reversing never overflows.
- A comparator that needs a capability makes every caller of that `sort`
  need it (`E0219`).
- Instances may name any type, including parameterized ones:
  `Ord(Int(32)) = desc;`.
