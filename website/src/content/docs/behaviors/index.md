---
title: Behaviors
description: How a type is ordered, shown and compared, as knowledge you name instead of interfaces a type implements.
---

Most languages attach operations to types: a class implements an
interface, a type implements a trait, a struct overloads `<`. Resid does
not. A **behavior** is a piece of compile-time knowledge that says *how* to
do something with a type, and you name it where it applies:

```resid
type Task = { Str title; Int priority; };

Int by_priority(Task a, Task b) { return a.priority - b.priority; }
@needs(Ord(T))
T lo(T a, T b) { return if (compare(a, b) <= 0) { a } else { b }; }
@needs(Ord(T))
T hi(T a, T b) { return if (compare(a, b) >= 0) { a } else { b }; }
Ord(Task) = { .compare = by_priority, .least = lo, .greatest = hi };

Str show_task(Task t) { return f"[{t.priority}] {t.title}"; }
Show(Task) = show_task;                   // how a Task is written

Int main() {
    List(Task) todo = [
        Task {.title = "write docs", .priority = 2},
        Task {.title = "fix bug", .priority = 1},
        Task {.title = "release", .priority = 3},
    ];
    println(f"{sort(todo)}");
    println(f"{sort(todo, using = Reverse(Ord(Task)))}");
    return 0;
}
```

```text title="Output"
[[1] fix bug, [2] write docs, [3] release]
[[3] release, [2] write docs, [1] fix bug]
```

An instance declaration `Behavior(Type) = function;` is a fact about
`Type`. The compiler checks the function's signature against the behavior,
and each place that needs the behavior either finds the unique instance
automatically or is told which one to use with `using =`.

## Why not interfaces?

- **Knowledge, not identity.** An ordering is not a property of a `Task`;
  it is a choice. Different parts of a program can sort the same list
  different ways without wrapper types.
- **Visible at the use site.** `sort(xs, using = by_deadline)` says exactly
  what happens; there is no method resolution to trace.
- **Reducible.** A behavior is resolved at compile time, like everything
  else in Resid. There is no dispatch at run time: sorting a list of
  records calls the comparator you named.
- **Authority stays visible.** A behavior's function is an ordinary
  function, so if it needs a capability, every function that sorts with it
  must be granted that capability too.

## The core behaviors

The prelude declares these as ordinary behaviors, so they follow the same
rules as [your own](/Resid/behaviors/defining/):

```text
behavior Eq(T)        { Bool eq(T a, T b); }
behavior Ord(T)       { Int compare(T a, T b); T least(T a, T b); T greatest(T a, T b); }
behavior Hash(T)      { Int hash(T x); }
behavior Show(T)      { Str show(T x); }
behavior Serialize(T) { Str serialize(T x); }
behavior Allocator(T) { T allocate(); }
```

| Behavior | Used by |
|---|---|
| `Ord(T)` | `sort`, `Reverse`, `<` `<=` `>` `>=`, the verb `compare` |
| `Show(T)` | f-string holes, including inside records, lists and options; the verb `show` |
| `Eq(T)` | `==` and `!=` on types without a built-in equality; the verb `eq` |
| `Hash(T)` | the verb `hash` |
| `Serialize(T)` | the verb `serialize` |
| `Allocator(T)` | the verb `allocate` |

Numbers and `Str` come with built-in instances, so `sort(xs)` on them
needs nothing, and the numeric family has `Eq`, `Ord` and `Hash` at every
width. A function of your own named like a verb (`show`, `hash`) wins
over the verb.

The chapters that follow cover [Ord](/Resid/behaviors/ord/),
[Show](/Resid/behaviors/show/), [your own behaviors](/Resid/behaviors/defining/),
[generic functions](/Resid/behaviors/generics/), the
[generic verbs](/Resid/behaviors/generic-verbs/), and how to
[behavioralize](/Resid/behaviors/behavioralizing/) existing code.
