---
title: Your first program
description: Hello, world; building, running and the files the compiler writes.
---

```resid
Int main() {
    println("Hello, Resid!");
    return 0;
}
```

```text title="Output"
Hello, Resid!
```

Save it as `hello.resid` and build:

```sh
residc hello.resid -o hello --profile debug
./hello
```

`main` returns the process exit status. `println` writes a line to standard
output; printing needs no capability.

## Profiles

| Profile | What you get |
|---|---|
| `release` (default) | `-O2`, signed; needs a [signing key](/Resid/learn/install/#signing-keys) |
| `debug` | `-O0`, DWARF debug info, the knowledge graph artifact, unsigned without a key |
| `check` | type checking only, plus the graph artifact; no binary |

Next to the binary the compiler writes **sidecars**: `hello.resid-graph.cbor`
(the knowledge graph: every node, what was reduced and why; see
[Knowledge graph](/Resid/reference/knowledge-graph/)) and
`hello.resid-notes.cbor` (residual notes: the runtime work you could still
remove). `hello.ll` is the LLVM IR.

## A program with input

```resid
@requires(args)
Int main() {
    Int n = args.count();
    println(f"called with {n - 1} argument(s)");
    return 0;
}
```

Reading the command line is an *effect* that needs authority, so `main`
declares `@requires(args)`. Leave the annotation out and the compiler
rejects the program with `E0219`. The [capabilities](/Resid/learn/capabilities/)
chapter explains why.

`f"...{expr}..."` is an f-string; any value can go inside the braces.
