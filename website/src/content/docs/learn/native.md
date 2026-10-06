---
title: Native modules
description: "Call code written in C (or any language that emits LLVM IR) from Resid, safely: one @link line, one capability, and a sandbox the kernel enforces."
---

Sometimes the code you need already exists in another language: a
compression routine, a codec, a numerical kernel. A **native module** lets
a Resid program call it without giving up anything the language promises.
The native code runs in a sandboxed process that **cannot touch the
outside world at all**. It gets its arguments and returns its answer,
nothing more.

## A first module

Write the native side in C. It must be *freestanding*, with no C library,
because the native code gets no operating system to talk to:

```c
// native/tiny.c
#include <stdint.h>

int64_t tiny_add(int64_t a, int64_t b) { return a + b + 1; }

void tiny_upper(const char *s, int64_t cap, char *out, int64_t ocap) {
    for (int64_t i = 0; i < cap && i < ocap && s[i]; i++)
        out[i] = (s[i] >= 'a' && s[i] <= 'z') ? s[i] - 32 : s[i];
}
```

Compile it to **LLVM IR text**. That is the only artifact form Resid
links, because the compiler checks it before linking:

```text
clang -S -emit-llvm -O2 -ffreestanding -fno-builtin -fno-stack-protector \
      -o native/tiny.ll native/tiny.c
```

Bind it from Resid with `@link`. The function's body is empty, because
the module supplies it:

```resid
// check-only
@link("tiny")
Int tiny_add(Int a, Int b) {}

@link("tiny")
Str(16) tiny_upper(Str(16) s) {}

@requires(native_tiny)
Int main() {
    println(f"{tiny_add(2, 3)}");
    Str(16) name = "resid";
    println(f"{tiny_upper(name)}");
    return 0;
}
```

Build with `-native`, naming the module and its artifact:

```text
residc main.resid -o main -native tiny=native/tiny.ll
./main
6
RESID
```

Three things to notice:

- `tiny_add(2, 3)` printed **6**. The compiler did not fold the call away,
  even with literal arguments. A native call is an *effect*: its answer
  comes from outside the program, so it always runs.
- `main` declares `@requires(native_tiny)`. Each module is a capability
  family of its own, `native_<module>`, checked like `filesystem` or
  `network`: every function that calls the module, directly or through
  others, must be granted it.
- The C function for `Str(16) tiny_upper(Str(16) s)` takes the text and its
  capacity, then an output buffer and its capacity. Each Resid type has
  one fixed C form ([the type table](/Resid/reference/native-modules/#types)).

## What the native code can and cannot do

Every call starts a fresh copy of your program in a special *host* mode.
Before any native instruction runs, the host locks itself down:

- It keeps no file descriptor but the socket the call arrives on.
- It has an empty environment, and none of the calling program's memory.
- It disables the CPU's time-stamp counter and unmaps the kernel's clock
  pages.
- It installs a kernel (seccomp) filter that allows reading and writing
  that one socket, allocating non-executable memory, and exiting.
  **Anything else kills the process**: opening a file, opening a
  socket, reading the clock, starting a process, even asking for its own
  process id.

So a native module is pure computation, enforced by the kernel rather
than by trust. If the C code tries to escape, the call fails:

```text
resid: abort: native module `tiny`: `tiny_add` failed: killed by signal 31
```

Each call gets a fresh process, so nothing survives from one call to the
next. A counter in C returns 1 every time. That is deliberate: a Resid
value has no hidden identity, and a native call cannot smuggle one in.

## When a call fails

A native call can fail: the code crashes, runs over its 60 seconds of CPU,
or sends back an answer that is not a valid value of its type. Resid
treats the answer as untrusted input: a `Bool` must be 0 or 1, an `Int(8)`
must fit, a `Str(N)` must be valid UTF-8. Outside a `spawn` region a
failed call aborts the program. Inside one it becomes the region's
`Err`, so you can recover:

```resid
// check-only
@link("tiny")
Int tiny_add(Int a, Int b) {}

@requires(native_tiny)
Int main() {
    Result(Int, RegionError) r = spawn (native_tiny) { return tiny_add(rt 1, 2); };
    Int v = r else { -1 };
    println(f"{v}");
    return 0;
}
```

## Packaging a module

In a package, list the artifact in `resid.toml` with its SHA-256. The
build refuses an artifact that has changed:

```text
[native.tiny]
path   = "native/tiny.ll"
sha256 = "6b89b5bc21a33682834e177fdc3dde21162c4850c44915df1d7df58d3f10eea8"
```

`resid-manifest build` then passes `-native` for you. A consumer of your
package grants the family through the dependency's ceiling, exactly as
for any other capability:

```text
[capabilities]
grant = ["native_tiny"]

[dependencies.tiny-bindings]
path = "../tiny-bindings"
capabilities = ["native_tiny"]
```

The package archive includes `.ll` files, so its hash and any signature
over it cover the native code too. The signed provenance record of the
binary names each artifact's SHA-256.

## Other languages

Anything that emits LLVM IR text for x86-64 Linux, without a C library,
works: Zig, Rust with `#![no_std]`, and others. The artifact may use
LLVM intrinsics and `memcpy`/`memmove`/`memset`, and nothing else from
outside itself. Emit it with an LLVM no newer than the one that builds
your Resid programs.

## When not to use one

A native call costs a process start, about 2 ms on a small program, more for a large one. Use a native
module for substantial work: compress a buffer, decode an image, run a
solver. Do not use one per character of a string. And native code cannot
reach the OS, so a native module can never be a display driver, a
database client or a file parser that opens its own files. Do that work
in Resid through [providers](/Resid/tools/providers/), and hand the native
module only the bytes.

The full rules are in the [reference](/Resid/reference/native-modules/).
