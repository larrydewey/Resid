# Resid Language

Resid = eager compile-time language: compiling mean maximal authorized reduction of first-class knowledge. This repo hold language spec plus in-progress Rust/Cargo build.

- **Source of truth**: `resid_specification.txt` — full language spec (now **v3.0 — Production Ready**). All design question must get answer from it, no exception.
- **Implementation**: Cargo workspace. Members under `crates/` (lexer, parser, ir, type, codegen, builtin, build, residc) and `tools/` (fmt, notes, cache, graph, why).
- **Status**: lexer 13, parser 88, resid-ir 41, resid-type 143, resid-codegen 114, residc 15 — **414 tests pass**. Operator precedence per spec §27 (multiplicative > additive > … > logical AND/OR; binary left-associative, ranges right-associative). `resid-ir` build spec-§6 primitive numeric types plus mixed-width widening. `resid-type` cover literal inference, widening, signed/unsigned mixing rejection, bitwise/float errors, cast, if, RT, built-in extern signatures, `Str + Str`, `check_program`, and (Step 1) lists, structs, options, pattern matching, numeric overload resolution (`IntToString`/`UIntToString`/`FloatToString`/`BoolToString`/`ToString`), and numeric widening at call sites. `resid-codegen` spit out verified LLVM IR: functions, arithmetic, casts, calls, bool, string literals/f-strings/raw strings (global constants), string-concat folding, extern built-ins (`print`/`println`), boxed composite values (`List`/`Struct`/`Option` via `resid_box_*` runtime calls, `match` with tag checks + phi joins), Bool↔i8 C ABI widening, runtime value formatting helpers, `value?`/`value else { … }` unwrap (payload from box slot 0), nested-`if` phi joins, and early `return` in if/else branches (emitted as a real `ret`, enabling recursion). `resid-parser` handles C-style casts `(Type)expr`, named call args, raw/byte strings, `_ = expr` discard, struct destructuring, and bare block statements; the type checker (not the parser) rejects undefined variables.
- **Runnable natives**: `residc <f> build [-o out]` build native binary (clang + tiny C runtime `crates/residc/resid_rt.c`), `residc <f> run` build and run it (exit code carry through), `residc <f> emit-ir` print LLVM IR. First bootstrap stage: Resid programs can print to stdout, return exit codes, and format all value types to strings.
- **Branch**: `master` (uncommitted).

## Workflow

When task done:

1. **Update `PROGRESS.md`** — bump test counts, update status notes, reflect new capability in status table (section 11).
2. **Commit** — make git commit summarizing changes. Check `PROGRESS.md` for current phase context.

When work here, check `resid_specification.txt` first; spec = contract implementation must satisfy. `residc <f> emit-ir` now run full pipeline (lex → parse → type → codegen → IR).