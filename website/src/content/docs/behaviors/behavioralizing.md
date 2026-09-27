---
title: Behavioralizing your code
description: Refactoring hand-written sorting, printing and type-specific helpers into behaviors and generic verbs.
---

*Behavioralizing* means moving the "how" of an operation out of ad-hoc
helper code and into a named behavior, so the generic operations
(`sort`, f-strings, the list verbs) do the work. It is the Resid answer to
"how do I write this once for many types?".

## 1. Replace hand-written sorts with Ord

A hand-written insertion sort for one record type:

```resid
type Job = { Str name; Int cost; };

List(Job) insert(List(Job) sorted, Job j, Int i) {
    if (i >= sorted.len()) { return sorted.concat([j]); }
    if (j.cost < sorted[i].cost) { return sorted[0..i].concat([j]).concat(sorted[i..sorted.len()]); }
    return insert(sorted, j, i + 1);
}

List(Job) sort_jobs(List(Job) js, Int i, List(Job) acc) {
    if (i >= js.len()) { return acc; }
    return sort_jobs(js, i + 1, insert(acc, js[i], 0));
}

Int main() {
    List(Job) js = [Job {.name = "b", .cost = 3}, Job {.name = "a", .cost = 1}];
    List(Job) none = [];
    println(f"{sort_jobs(js, 0, none)}");
    return 0;
}
```

becomes one comparator and one instance:

```resid
type Job = { Str name; Int cost; };

Int by_cost(Job a, Job b) { return a.cost - b.cost; }
Ord(Job) = by_cost;

Int main() {
    List(Job) js = [Job {.name = "b", .cost = 3}, Job {.name = "a", .cost = 1}];
    println(f"{sort(js)}");
    return 0;
}
```

```text title="Output"
[Job { name: "a", cost: 1 }, Job { name: "b", cost: 3 }]
```

The behavior version is shorter, runs in O(n log n) instead of O(n²), is
stable, and gets descending order for free with
`using = Reverse(Ord(Job))`.

**Rule of thumb:** if a type has *one* natural order, make it the `Ord`
instance. Put every other order in a named comparator and pass it with
`using =`, not in a second instance.

## 2. Replace to_string helpers with Show

Before:

```text
Str job_text(Job j) { return j.name + " (" + f"{j.cost}" + ")"; }
...
println("next: " + job_text(j));
```

After:

```resid
type Job = { Str name; Int cost; };

Str show_job(Job j) { return f"{j.name} ({j.cost})"; }
Show(Job) = show_job;

Int main() {
    Job j = Job {.name = "deploy", .cost = 5};
    println(f"next: {j}");
    println(f"queue: {[j, Job {.name = "test", .cost = 2}]}");
    return 0;
}
```

```text title="Output"
next: deploy (5)
queue: [deploy (5), test (2)]
```

Every f-string, every record containing a `Job`, every list of jobs now
uses it. There is nothing to remember to call.

## 3. Use the generic verbs, not per-type loops

Before (one helper per element type):

```text
Bool contains_int(List(Int) xs, Int v, Int i) { ... }
Bool contains_str(List(Str) xs, Str v, Int i) { ... }
Int total(List(Int) xs, Int i, Int acc) { ... }
```

After: `xs.contains(v)`, `xs.sum()`, `xs.reverse()`, `min`, `max`, `abs`,
`clamp`. They work for every width and float type.

## 4. Write it once: generic functions and your own behaviors

Code that repeats for several types becomes one generic function, and an
operation each type does its own way becomes a behavior:

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

@needs(Area(T))
Float total(List(T) xs, Int i, Float acc) {
    if (i >= xs.len()) { return acc; }
    return total(xs, i + 1, acc + area(xs[i]));
}

Int main() {
    List(Square) sqs = [Square {.side = 3.0}, Square {.side = 1.0}];
    List(Circle) cs = [Circle {.r = 1.0}];
    println(f"{total(sqs, 0, 0.0)} {total(cs, 0, 0.0)}");
    return 0;
}
```

```text title="Output"
10 3
```

See [your own behaviors](/Resid/behaviors/defining/) and
[generic functions](/Resid/behaviors/generics/).

## 5. Parameterize an algorithm with a closure

`sort`'s `using` names a comparator known at compile time. When an
algorithm needs a caller-chosen step at run time, take a closure (and make
the function generic when it works for any element type):

```resid
type Score = { Str who; Int points; };

List(T) keep_if(List(T) xs, Bool closure(T) ok, Int i, ListBuf(T) acc) {
    if (i >= xs.len()) { return acc.finish(); }
    return keep_if(xs, ok, i + 1, if (ok(xs[i])) { acc.push(xs[i]) } else { acc });
}

Int by_points(Score a, Score b) { return a.points - b.points; }

Int main() {
    List(Score) xs = [
        Score {.who = "ada", .points = 9},
        Score {.who = "bob", .points = 4},
        Score {.who = "cy", .points = 7},
    ];
    Int cut = 5;
    List(Score) good = keep_if(xs, lambda(s) { s.points > cut }, 0, ListBuf());
    println(f"{sort(good, using = Reverse(by_points))}");
    return 0;
}
```

```text title="Output"
[Score { who: "ada", points: 9 }, Score { who: "cy", points: 7 }]
```

The algorithm is written once. When a call's closure is known, the
compiler specializes the function for it, so the indirection usually
disappears.

## Checklist

- A type with a natural order → `Ord(T) = cmp;`
- A type people print → `Show(T) = show;`
- Any other order → a named comparator, `using = cmp` or
  `using = Reverse(cmp)`.
- A loop over a list that checks membership, sums, reverses or finds a
  min/max → the generic verb.
- The same function written for several types → one generic function,
  with `@needs` for what it sorts, shows or compares.
- An operation each type does its own way → `behavior Name(T) { ... }` and
  an instance per type.
- A comparator or `Show` function that reads files or the environment →
  reconsider; it makes every caller need that capability.
