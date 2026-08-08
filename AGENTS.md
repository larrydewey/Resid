# Resid Language

Resid is an eager compile-time language: compilation is maximal authorized
reduction of first-class knowledge. This repo holds the language spec plus an
in-progress Rust/Cargo implementation.

- **Source of truth**: `resid_specification.txt` — the complete language spec (currently **v3.0 — Production Ready**). All design questions must be answered by consulting it.
- **Implementation**: Cargo workspace. Members under `crates/` (lexer, parser, ir, type, codegen, builtin, build, residc) and `tools/` (fmt, notes, cache, graph, why).
- **Status**: lexer 7, parser 10, resid-ir 41, resid-type 35, resid-codegen 9, residc 4 — **106 tests pass**. `resid-ir` implements the spec-§6 primitive numeric types and mixed-width widening. `resid-type` covers literal inference, widening, signed/unsigned mixing rejection, bitwise/float errors, cast, if, RT, built-in extern signatures, `Str + Str`, `check_program`, and (Step 1) lists, structs, options, pattern matching, numeric overload resolution (`IntToString`/`UIntToString`/`FloatToString`/`BoolToString`/`ToString`), and numeric widening at call sites. `resid-codegen` emits verified LLVM IR: functions, arithmetic, casts, calls, bool, string literals/f-strings/raw strings (global constants), string-concat folding, extern built-ins (`print`/`println`), boxed composite values (`List`/`Struct`/`Option` via `resid_box_*` runtime calls, `match` with tag checks + phi joins), Bool↔i8 C ABI widening, and runtime value formatting helpers.
- **Runnable natives**: `residc <f> build [-o out]` compiles to a native binary (clang + tiny C runtime `crates/residc/resid_rt.c`), `residc <f> run` builds and runs it (exit code propagated), `residc <f> emit-ir` prints the LLVM IR. First bootstrap stage: Resid programs can print to stdout, return exit codes, and format all value types to strings.
- **Branch**: `master` (uncommitted).

## Workflow

When completing a task:

1. **Update `PROGRESS.md`** — increment test counts, update status notes, and reflect any new capabilities in the status table (section 11).
2. **Commit** — create a git commit summarizing the changes. Consult `PROGRESS.md` for current phase context.

When working here, consult `resid_specification.txt` first; the spec is the contract the implementation must satisfy. `residc <f> emit-ir` now runs the full pipeline (lex → parse → type → codegen → IR).
