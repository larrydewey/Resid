---
title: Integrity labels
description: Which values came from outside the program, and how the compiler knows.
---

Every value has an integrity label beside its type: **Internal** when the
program computed it from its own code and constants, **External** when
anything outside the program had a say in it. The labels are inferred;
nothing is written in ordinary code. The design is `PLAN-labels.md` in the
repository. This page describes what the compiler does today (phase 1 of
that plan): it computes the labels and explains them. No rule refuses a
program because of a label yet.

## What is External

Every effect that acquires information yields an External value:

- provider calls: `args`, `environment`, `filesystem`, `network`,
  `clock`, `terminal`, `display`, `process`, `device`, `git`, `random`;
- the runtime builtins behind them: sockets, the terminal, the clock,
  standard input, randomness, the device host, `ptrace`, and whether a
  `print` wrote;
- a native module call (`@link`);
- a `spawn` result: the region's value and whether it failed are chosen
  outside the program (memory pressure, kills);
- a CPU feature query (`resid_cpu_has_*`) in a program. The standard
  library's dispatch on one is *selection-equivalent*: the hardware and the
  software path compute the same function, so a lie only stops the program
  (an illegal instruction), and the result is not made External by it.

Every builtin has an entry in one table. A builtin without one is refused
(`E0271`) instead of guessed.

## How labels flow

- An operation's result joins its operands: one External operand makes it
  External. Containers carry their elements' labels, and a record field
  carries the record's.
- A value **chosen** by a condition takes the condition's label, even when
  every choice is a constant: `if (ext == 1) { 1 } else { 0 }` copies a bit
  of outside data. The places a choice is made are `if` and `match`
  expressions, a function's `return`s (and the early return of `?`) under a
  condition, and the iterations of a loop over outside data or one that a
  `break` under outside data stops.
- Code that merely runs after an exit is not chosen:
  `if (ext) { return 0; } Int x = 1;` leaves `x` Internal.
- A function's result carries the arguments of the parameters that reach
  or choose it, and nothing from the others; a function that acquires
  something itself returns External whatever it is given.
- A closure carries what it captures and what its body acquires; calling it
  joins its arguments.

A `Secret` value is never a condition (spec §48), so secrecy never flows
through a choice; integrity does.

## Asking why

Build with `--profile check` (or `debug`), then ask `resid-why` about a
name or a line:

```text
$ residc app.resid --profile check -o app
$ resid-why app --label count
bind count @ app.resid:9:5: External
  app.resid:5:13  mcall get  -- outside data enters here (args.get)
  app.resid:5:5  bind a
  app.resid:9:13  call str_len
  app.resid:9:5  bind count
$ resid-why app --label app.resid:12
```

The first line of the path is where outside data entered; each line after
it is a binding, call or choice it passed through. Each node's label is
also in the graph artifact as `label: {integrity, cause, effect}`.

## Keys must be unpredictable

A key, seed or other keying argument must hold enough bytes nobody else
can know: at least min(its length, 32). The compiler counts them after
reduction (`E0270`, a warning while the rule is rolled out):

- **Sources.** Draws (`random_secret(n)`, `lib/random.resid`; `n` must be
  known), keys given with `provisioned_key(k, "reason")` (a stated
  reliance: whoever provisioned the key knows it, so it needs the
  `provision` capability and is recorded as `provision.<reason>`), and the
  results of reviewed library functions: `@key_from(p, …)` (hashes, HMAC,
  HKDF: as unpredictable as the named parameters, and a value of its own)
  and `@agree(p)` (key agreement: unpredictable when the private input is,
  never *own*).
- **Kept by** moving bytes (slices with known bounds, concatenation, lists,
  records, `secret`, sum-type payloads) and by xor or wrapping addition with
  an operand holding nothing unpredictable. **Lost** by everything else:
  constants, bytes from a file, the network, a device or a native module,
  other arithmetic.
- **Counted once per source.** `r ‖ r` holds `r`'s bytes once, and so does
  `sha256(r ‖ r)`. A selection holds the smallest count of its arms;
  an arm known to be empty (a failure value) is dropped, since every keying
  primitive refuses an empty key at run time.
- **Disclosure.** A source any copy of which reaches `declassify` counts
  zero everywhere, before or after. A one-way image (`@one_way(p)`:
  public-key derivation) publishes without disclosing `p`; publishing
  `sha256(r)` makes keying with `sha256(r)` fail, but not keying with
  `hkdf(r, "b")` after publishing `hkdf(r, "a")`.
- **Own keys.** `@key(p, own)` takes only draws (`challenge_with_key`);
  `@key(p, own, provisioned)` also provisioned keys (`export_key`).
- **Public copies.** A keying function instantiated at public bytes
  (`List(Int)`) is for known-answer tests: outside tests it warns. Files
  under `tests/` and `test` blocks are not checked.

**Nonces.** An AEAD nonce (`@nonce(iv)` in the library) that is the same
on every run (a constant) is refused (`E0279`, a warning for now) unless the
key is single-use: it rests on a draw (`random_secret`, or the fresh public
bytes of `random_bytes`) made in the same function, outside any loop or
closure, which no other sealing call there uses. The library's stateful
sealers build nonces from a counter; a fresh random nonce is always fine.
A nonce taken from outside data is not checked yet.

Keying parameters are marked in the library with `@key(p)`; a parameter
that reaches one is keying too, so a wrapper needs no mark of its own.
Records are followed two levels deep and selections keep up to four
alternatives; past that the analysis keeps only what every alternative
holds, which can only warn more, never less.
