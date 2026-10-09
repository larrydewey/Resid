---
title: Secret values
description: Secret(T), declassify and what a secret may and may not do.
---

`Secret(T)` is a value the program holds but may not observe through
control flow, a memory address or an output. The rules are checked by the
compiler; the full design is `PLAN-secret-type.md` in the repository.

```resid
@requires(declassify)
Int main() {
    Secret(Int) k = secret(rt 41);
    Secret(Int) m = (k ^ 7) & 255;          // bitwise work stays secret
    Secret(Int) w = wrapping_add(m, k);     // so does wrapping arithmetic
    Int out = declassify(w, "test output"); // the one exit, authorized and recorded
    println(f"{out}");                      //> 87
    return 0;
}
```

## Making and publishing secrets

- `secret(x)` wraps a value. `T` may not be `Option`, `Result`, a sum type,
  `Map`, `Set`, a handle, a function or a secret (`E0253`).
- A secret whose value the compiler knows after reduction is refused
  (`E0250`): it would be in the binary for everyone who has it. Read
  secrets at run time. `declassify(secret(41), "why")` is accepted, since it
  states that the value is public.
- `declassify(s, "reason")` returns the `T`. It needs
  `@requires(declassify)`, carried to every caller like any capability
  (`E0219`); the family has no modes. The reason is a non-empty string
  literal (`E0251`) and is recorded with the call in the graph artifact
  (effect `declassify.<reason>`, capability `declassify`).

## What a secret may do

| Allowed, result secret | Refused |
|---|---|
| `&`, `\|`, `^` with integers; `<<` and `>>` by a public amount | `+ - *` (checked: overflow aborts, `E0254`) |
| `wrapping_add`, `wrapping_sub`, `wrapping_mul` | `/`, `%`, comparisons, `&&`, `\|\|` (`E0255`) |
| reading a secret list at a public index | a secret index, range bound or shift amount (`E0255`) |
| storing it in a record field or list | deciding an `if`, `while`, `match` or ternary (`E0255`) |
| `ct_select(c, a, b)` with a `Secret(Bool)` `c` | methods, except a secret list's, bytes' or text's `.len()` (`E0255`) |
| | being a `Map` key or `Set` element in any type (`E0253`) |
| | a provider argument, including `filesystem.write_secret` (`E0255`) |
| | a `spawn` region's result (`E0255`) |

To persist key material, declassify it under the grant and write it with
`filesystem.write_secret`, which keeps the file readable by its owner only:
`filesystem.write_secret(path, declassify(key, "persist the key"))`.

## Constant-time helpers

- `ct_select(c, a, b)` returns `a` when the secret `c` holds, else `b`,
  computed with masks rather than a branch. `a` and `b` are integers of at
  most 64 bits, or Bools, secret or public; the result is secret.
- `ct_eq(a, b)` in `lib/crypto.resid` compares two `Secret(List(Int))`
  byte lists in constant time and returns a public `Bool`. Only that one
  bit is published, which is a declassification, so `ct_eq` needs
  `@requires(declassify)`.
- A secret list's, bytes' or text's `.len()` is public.

`tests/ct/run.sh` checks both helpers under valgrind on the optimized
binary: no branch or memory address depends on the secret.

## Observation behaviors

- A secret, or a value that holds one, cannot be shown through the
  structural `Show` (`E0256`, naming the field path such as
  `KeyPair.priv`).
- `Show`, `Serialize`, `Hash`, `Eq` and `Ord` are never given for a secret
  (`E0257`), whether declared, asked for by a verb, or needed by a generic
  function's copy.
- A type that holds a secret may have its own `Show` instance. Its body is
  checked like any function, so it can only reach the secret through
  `declassify`.

## At run time

`Secret(T)` costs nothing per value: it lowers exactly as `T`. A program
that uses secrets anywhere runs its allocator in secret mode, switched on
before `main`:

- every heap, region, thread-stack and thread-local mapping is left out of
  core dumps (`MADV_DONTDUMP`);
- memory is zeroed when it is freed or handed back for reuse; memory given
  back to the kernel is zero-filled by the kernel.

Registers, the binary's static data and the process's initial stack are
not covered. `main` runs on its own thread stack, which is.

## Not yet enforced

`PLAN-secret-type.md` lists the rest of the plan: moving the
cryptography library onto `Secret(T)`.
