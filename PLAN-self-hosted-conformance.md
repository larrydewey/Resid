# Plan: Self-Hosted Compiler Spec Conformance

Status: DONE (opened 2026-09-24, closed 2026-09-25: 117 / 117). Companion to `PROGRESS.md` and
`PLAN-resid-only.md`.

## Why this plan exists

`PROGRESS.md` §6 marks the v3.3 conformance roadmap "complete in both
pipelines". Measured against the compiler that is actually maintained
(the self-hosted `examples/driver.resid`, built from
`examples/typecheck.resid` + `examples/codegen.resid`), that is not true.
Many items landed only in the Rust pipeline ("stage-1"), and that pipeline
has been archived under `bootstrap/rust-stage0/` since Phase D.

Audit method (2026-09-24):

1. Extracted every single-program `run_*`/`reduction_*` e2e test from
   `bootstrap/rust-stage0/crates/residc/tests/e2e.rs`, compiled each with
   both the archived Rust `residc` (reference) and the committed seed
   (self-hosted), then compared exit codes and stdout.
2. Wrote probes for spec sections the e2e suite does not cover.
3. Kept the results as a permanent, Rust-free regression suite:
   `tests/conformance/` (runner: `tests/conformance/run.sh`).

Baseline: **34 / 117 conformance cases pass** on the self-hosted compiler.
For comparison, the Rust reference passes 105 / 117. The 12 it fails are
also spec gaps in Rust, marked "(Rust gap too)" below.

## Gate

An item is DONE when its conformance cases pass under the self-hosted
compiler, no previously-passing case regresses, and `./boot.sh` still
reaches the byte-identical fixed point (reseed with
`./boot.sh --bootstrap-from-self` after compiler-source changes).

## Curated list of missing items

Cases named in brackets live in `tests/conformance/cases/`.

### WP1 — Numeric core (§6, §17, §32)

1. Alias normalization: `Int ≡ Int(64)`, `UInt ≡ UInt(64)`,
   `Float ≡ Float(64)` everywhere (bindings, returns, if/match branch
   unification). Today `if branches differ: Int(64) vs Int` breaks
   `lib/x25519.resid` and `lib/tlsmsg.resid` users.
   [x25519_in_resid, tls13_framing_in_resid, value_formatting,
   stdlib_float_misc, spec_float_alias, spec_int_alias_branches]
2. Conversion helpers `i8…i512`, `u8…u512`, `f16…f128`, `isize`, `usize`
   (§6.7), plus `(Type)expr` casts across widths.
   [conversion_helpers, float128, probe_cast, probe_floats, probe_isize,
   probe_typealias, probe_mulwiden]
3. Wide-integer and Bool display builtins: `Int128ToString`,
   `Int256ToString`, `Int512ToString`, `UInt128ToString`,
   `UInt256ToString`, `UInt512ToString`, `BoolToString`.
   [wide_int_128, wide_int_256_512, wide_literal_beyond_u128,
   fs_* cases, handle_explicit_close]
4. f-string interpolation of `Float`, `Bool`, and every integer width.
   [fstring_interpolation, stdlib_float_list]
5. Per-width `wrapping_*` / `saturating_*` for every signed and unsigned
   width (§6.5). [per_width_wrapping_saturating]
6. Unary `~`. Char literal `'a'` is an `Int` codepoint. Hex literals must
   lower to decimal LLVM constants: `0x0c` currently emits invalid IR.
   [probe_unary, probe_literals, spec_char_hex_literals, hkdf_in_resid]
7. Shift counts `>=` the bit width yield 0 at every width (§17).
   [shift_overflow_yields_zero]
8. Static numeric rules: literal range check (§6.1a); sign-mix error
   (§6.3); implicit narrowing error (§6.4, Rust gap too). Checked
   arithmetic must trap on overflow (§6.5).
   [err_literal_too_wide, err_sign_mix, err_implicit_narrowing,
   probe_overflow_trap, probe_overflow_static]

### WP2 — Decimals (§6.6a)

9. `Dec(N)` end to end:
   - `m`-suffix literals and exact `+ - * /` (divide with N+2 guard digits)
   - round half away from zero
   - fixed-notation display with all N digits
   - `:.` f-string trim (Rust gap too)
   - `dN` helpers
   - hard error when Dec is mixed with Int, UInt, or Float

   [dec_exact_arithmetic, probe_dec_ops, probe_dN, spec_dec_display,
   err_dec_int_mix]

### WP3 — Syntax, control flow, debugging surface (§7–9, §14, §18, §24–25, §30)

10. Trailing comma after the last match arm.
    [spec_match_trailing_comma, composite_values, map_set_types]
11. Block-valued `if` whose branches contain statements
    (`if (c) { 10; } else { 20; }`). [if_while_control_flow]
12. `break` / `continue`. [spec_break_continue, probe_breakcont]
13. Conditional operator `c ? a : b` (§30 level 13, Rust gap too).
    [spec_ternary]
14. Default parameters and named arguments (§8).
    [default_params, probe_named_args]
15. Raw strings `r"…"` in codegen; `#location` / `SourceLoc` (§25).
    [probe_rawstr, raw_bytes_and_location, spec_location]
16. Debug and residual builtins: `known`, `rt_known`, `rt_assert`, `todo`,
    `unimplemented`, `rt expr`, `@residual` bindings (§9, §24). Also a
    compile-time error for `known(x)` on a residual `x` (Rust gap too).
    [probe_known, probe_todo, at_residual_binding, err_known_residual]
17. Shadowing is forbidden (§7). [err_shadowing]

### WP4 — Patterns and types (§12, §13, §15, §23)

18. `if (Some(x) = opt)` and `while (Some(x) = e)`.
    [if_let_and_while_let, probe_whilelet]
19. `match` on `Result` (including `Result(T, RegionError)`). Unify
    `Ok(x)` / `Err(e)` / `None` across branches and arguments, so that
    `Result(Int, _)` + `Result(_, Str)` becomes `Result(Int, Str)`
    (Rust gap too). [result_type_ok_err, question_sugar_option_and_result,
    spec_result_if_branches]
20. Spec product-type syntax `type P = { x: Int, y: Int }` and literal
    `P { x = 1 }`, alongside the existing `{ Int x; }` / `.x =` forms
    (Rust gap too). [spec_struct_colon_syntax]
21. Destructuring: `Point { x, y } = p;` and irrefutable `Some(v) = o;`
    (Rust gap too). [spec_destructure]
22. Generic sum types `type Box(T) = Full(T) | Nothing` (Rust gap too).
    [spec_generic_sum]
23. `Range(Int)` values, and slices `xs[a..b]` that yield a `List`
    (Rust gap too for the List result).
    [range_and_slice_construction, spec_slice_is_list]
24. `m[k]` on a Map returns the right `Option`. It currently yields
    `None`/0 for a present key. [probe_maplit]
25. Constraint types `Int[P]` / `Int where P`: bindings and E0301
    discharge. [constraint_types, err_constraint_violation,
    err_constraint_bracket_violation]

### WP5 — Handles (§16)

26. `File` handle type, `with (File h = …) { }`, multi-binding `with`,
    and `h.close()` (Rust gap too for multi-binding).
    [with_handle_raii, handle_explicit_close, spec_with_multi]

### WP6 — Concurrency (§19)

27. `spawn (caps) { … }`:
    - pthread worker; captures; nested spawn
    - child ≤ parent capability check (E0214/E0215)
    - child failure delivered as `Err(RegionError)`

    [spawn_simple, spawn_with_captures, spawn_nested, spec_spawn_caps,
    spec_spawn_child_failure]

### WP7 — Behaviors (§6.6, §11, §32)

28. Generic numeric `Eq`/`Ord`/`Hash` for every width and for `Float`, with
    no user declaration needed. `Reverse(...)`. Shape checks for
    `Serialize` / `Allocator`. [spec_behavior_generic_numeric]

### WP8 — Modules and visibility (§22)

29. `import "f" as M` with `M.name(...)` (plan item A.6); selective
    imports hide unlisted names; default-private, `pub` export enforced
    across modules. [spec_import_as, spec_import_selective,
    err_import_selective_excluded, err_pub_private]

### WP9 — Reduction, build profiles, codegen robustness (§27, §35, §36)

30. Comptime β-reduction of pure functions with step/depth budgets, and
    `comptime_print` output at compile time.
    [reduction_known_fib_comptime_print]
31. Build profiles `--profile debug|release|check`: `check` stops after
    type checking, `release` builds with `-O2`. [spec_check_profile]
32. Codegen bug: "Terminator found in the middle of a basic block" in
    `lib/ec256.resid`. [ec_ge_zero_max_in_resid]

## Deliberately out of scope (recorded, not dropped)

- C-style `for (init; cond; step)`. It needs reassignment, which §7
  forbids. The EBNF only defines for-in.
- A user-facing `hash(x, using = Hash(T))` function. The spec names the
  behavior but no call surface, so WP7 covers only the synthesized
  instances.
- Exhaustiveness diagnostics. §37 lists these as an LSP surface, not a
  language rule.
- `resid-lsp` stays in Rust per the locked decision in
  `PLAN-resid-only.md`.
- Proving overflow at compile time for known operands (§6.5 "compile-time
  when provable"). WP1 requires the runtime trap. Static discharge is a
  follow-up on top of WP9's reduction engine.

## Working order

WP1 → WP3 → WP4 → WP2 → WP5 → WP8 → WP7 → WP6 → WP9. Numeric alias
normalization and the conversion helpers unblock the most cases. Syntax
fixes come before the pattern/type work that depends on them.

## Progress log

(Append one entry per work package: what changed, cases turned green,
suite totals.)

- 2026-09-25 — all work packages, 34 -> 117 / 117 (the Rust reference
  passes 105). The stashed WP1 numeric work was merged onto the reduction
  commit (69 / 117), then:
  - WP1: `if`/`match`/`else` label numbering across nested arms (the
    ec256/tls13 "Terminator found in the middle of a basic block"), phi
    predecessors taken from the arm's last block, struct / list `ToString`,
    canonical list type names.
  - WP2: `Dec(N)` literals (`1.5m`), arithmetic, comparisons, casts, `dN`
    / `iN` / `fN`, f-string display and `:.`, the Dec/non-Dec mixing error
    (runtime: `resid_decp_*` over the existing resid_dec core).
  - WP3: `break` / `continue`, `while`, block values ending in `;`, `if`
    without `else`, `c ? a : b`, default parameters and named arguments
    (new pass `examples/desugar.resid`), raw strings and `b"..."`,
    `#location` / `SourceLoc`, `known` / `rt` / `rt_known` / `rt_assert` /
    `assert` / `todo` / `unimplemented` / `@residual`, shadowing error.
  - WP4: if-let / while-let, `match` on `Result`, `_`-hole unification
    (`Ok(x)` / `Err(e)` / `None` / `[]` across arms, arguments, returns),
    spec struct syntax `{ x: Int }` / `P { x = 1 }`, destructuring
    `Point { x, y } = p;` / `Some(v) = o;`, generic sums `Box(T)`,
    `Range(Int)` values and list slices, map indexing returning Option,
    constraint types with E0301 discharge (in the reduction pass).
  - WP5: `with (File h = ..., ...)` releasing handles on every exit.
  - WP6: `spawn (caps) { ... }` with captures, nesting and child failure as
    `Err(RegionError)`.
  - WP7: built-in numeric `Ord` / `Reverse(Ord)` for `sort`.
  - WP8: `import "f" as M`, selective imports, default-private visibility.
  - WP9: `--profile check|debug|release`.
  Remaining non-goals are listed under "Deliberately out of scope". Child
  capability narrowing (E0214/E0215) is parsed but not yet enforced.
