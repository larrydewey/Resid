---
title: Diagnostics
description: What the compiler's error codes mean.
---

Diagnostics name the file, line and column (in imported modules, their
own), with the offending source line.

| Code | Meaning |
|---|---|
| `E0001` | a type or structure error: a mismatch, an unknown name, shadowing, a missing return, `?` outside an Option/Result function, an `if` expression without `else`, `==` on a composite value, a duplicate function or behavior instance, a malformed program |
| `E0211` | a call exceeds the caller's sandbox ceiling |
| `E0212` | a region violation: a handle entering a sandbox it exceeds, or a write under a read-only grant |
| `E0213` | a malformed capability list (unknown family or mode) |
| `E0214` | a `spawn` lists more capabilities than its parent holds |
| `E0215` | a call inside a `spawn` needs a capability the region lacks |
| `E0216` | an attenuated import of a module already imported without attenuation |
| `E0218` | a provider call in a restricted region uses a family outside it |
| `E0219` | a function uses a capability it is not granted (no ambient authority) |
| `E0220` | a compiler-internal primitive used outside the compiler's own sources |
| `E0221` | an imported module cannot be found |
| `E0222` | a name in the wrong case: types, behaviors and variants start uppercase, values and functions lowercase; single uppercase letters are reserved for type parameters |
| `E0223` | an unqualified use of a name that two imported modules both export |
| `E0301` | a known value violates its constraint type |
| `E0401` | a builder is not consumed on some path |
| `E0402` | a builder is used twice |
| `E0403` | a builder is used inside a loop or lambda it was not created in |
| `E0404` | a builder type nested inside another type |
| `E0901` | `known(x)` on a residual value |

Runtime failures (overflow, division by zero, index out of range, a failed
conversion, a broken constraint, an assertion, `todo`) abort with a message
naming what failed. Inside a `spawn` region they become
`Err(RegionError)`.

Notes (`note: ...`) are not errors: they report reduction budgets that ran
out, residual notes recorded, and whether the build was signed.
