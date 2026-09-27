---
title: Testing
description: test blocks, expect matchers, and residc test.
---

Tests live next to the code as `test` blocks:

```resid
Int add(Int a, Int b) { return a + b; }

test "add: identity" {
    expect(add(0, 5)).toEqual(5);
    expect(add(5, 0)).toEqual(5);
}

test "strings and lists" {
    expect("resid").toHaveLength(5);
    expect("resid").toMatch("^re[a-z]+d$");
    expect([1, 2, 3]).toContain(3);
}
```

Run them with `residc test`:

```text
$ residc test math_test.resid

math_test
  ✓ add: identity (0ms)
  ✓ strings and lists (0ms)

Failures: 0 | Passed: 2 | Duration: 0ms
```

`--filter REGEX` runs matching tests; `--format pretty|tap|json` chooses the
report. The exit status is 0 when every test passes.

## Matchers

| Matcher | Checks |
|---|---|
| `toEqual(v)` / `toBe(v)` | equal value |
| `toNotEqual(v)` | different value |
| `toBeTrue()` / `toBeFalse()` | a `Bool` |
| `toBeNull()` | an `Option` is `None` |
| `toContain(x)` | a list holds `x` |
| `toHaveLength(n)` | a list or string length |
| `toMatch(re)` | a string matches a regular expression |
| `toBeCloseTo(x, tol)` | floats within a `Float` tolerance, or equal to `n` decimal digits for an `Int` |
| `toThrow()` | a closure aborts |
| `toSatisfy(pred, why)` | a predicate holds |

A `test` block is an entry point, like `main`: if the code under test needs
a capability, the block declares it:

```text
@requires(filesystem(readonly))
test "reads the config" {
    expect(filesystem.exists("config.toml")).toBeTrue();
}
```
