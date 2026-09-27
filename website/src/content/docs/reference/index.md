---
title: Language reference
description: The Resid language, section by section.
---

This book states the rules of the language precisely. It is distilled from
the normative specification (`resid_specification.txt`, version 3.6) and
kept in step with the compiler: every complete example is compiled and run
when the documentation is built.

**Laws.** The specification opens with the laws the rest follows:

1. Everything begins as compile-time reducible.
2. The compiler must reduce all provable computation.
3. Unknown information must be explicitly introduced.
4. Residual computation enters through `rt`.
5. Compile-time computation cannot depend on unresolved residual
   information.
6. The compiler preserves knowledge whenever possible.
7. Residual dependencies should be minimized.
8. Authorized external knowledge enters through providers.
9. Knowledge acquisition is an effect.
10. Effects determine reducibility.
11. External information has provenance.
12. Runtime uncertainty is explicit.
13. Knowledge is first-class.
14. Authority is never ambient and may only be attenuated, never
    amplified, across trust boundaries.

**Non-goals**, on purpose: mutable values or bindings, shadowing,
assignment operators, null, ambient authority, hidden identity,
trait or interface systems, programmer-controlled allocation, exceptions
outside concurrent `Result`, implicit numeric conversions, operator
overloading beyond behaviors, unstructured concurrency, raw target
intrinsics, method chaining on plain values, and amplification of
authority across sandboxes.
