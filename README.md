<div align="center">
    <img src="assets/logo.png" alt="Resid" width="150px"></img>
    <p><strong>What Remains is What Matters</strong></p>
    <p><a href="https://larrydewey.github.io/Resid/">Documentation</a> ·
    <a href="https://larrydewey.github.io/Resid/learn/">Learn</a> ·
    <a href="https://larrydewey.github.io/Resid/behaviors/">Behaviors</a> ·
    <a href="https://larrydewey.github.io/Resid/reference/">Reference</a></p>
</div>

**Resid** (*/ˈrɛz.ɪd/*) is an eager compile-time programming language. The
compiler must **reduce every computation it can prove**; only the residual
program, the part that truly depends on runtime information, is lowered to
native code through LLVM.

```resid
type Task = { Str title; Int priority; };

Int by_priority(Task a, Task b) { return a.priority - b.priority; }
@needs(Ord(T))
T lo(T a, T b) { return if (compare(a, b) <= 0) { a } else { b }; }
@needs(Ord(T))
T hi(T a, T b) { return if (compare(a, b) >= 0) { a } else { b }; }
Ord(Task) = { .compare = by_priority, .least = lo, .greatest = hi };

@requires(args)
Int main() {
    List(Task) todo = [
        Task {.title = "write docs", .priority = 2},
        Task {.title = "fix bug", .priority = 1},
    ];
    println(f"{sort(todo)}");
    println(f"{args.count()} argument(s)");
    return 0;
}
```

```text
[Task { title: "fix bug", priority: 1 }, Task { title: "write docs", priority: 2 }]
1 argument(s)
```

## What makes it different

- **Compilation is reduction.** Known calls are evaluated, partly known
  calls are specialized, provably unnecessary checks are dropped. Every
  reduction is recorded in a **knowledge graph** that the debugger and
  `resid-why` read, so you can always ask why something ran at runtime.
- **Values, not variables.** Immutable bindings, no null, no shadowing.
  Maps, lists and strings are values, updated in place only when the
  compiler proves no one else can see the old version.
- **No ambient authority.** A function that touches files, the environment,
  processes or the network says so with `@requires`, checked transitively;
  libraries can be sandboxed and imports attenuated.
- **Exact numbers.** `Int(8)` to `Int(512)`, `UInt`, `Float(16)` to
  `Float(128)`, exact `Dec(N)`. All arithmetic is checked; nothing wraps or
  truncates silently.
- **Behaviors instead of interfaces.** How a type is ordered or shown is
  knowledge you name (`Ord(Task) = { .compare = by_priority, .least = lo, .greatest = hi };`),
  not an interface it implements. Declare your own
  (`behavior Area(T) { Float area(T s); }`) and write generic functions and
  records (`T first(List(T) xs)`), instantiated at compile time before
  reduction. A verb reads as a method on its receiver (`c.area()`), and one
  that takes no argument takes its type from the receiver (`x.max()`).
- **Self-hosted, no C.** The compiler is written in Resid and compiles
  itself in about a second; the runtime is Resid too, and binaries are
  static executables with no C library.
- **Signed provenance.** Every release binary carries a COSE signature
  binding its source, code, sidecars, builder and grant; `residc verify`
  reports what it re-derived apart from what the signer asserts.

## Quick start

Requirements: Linux on x86-64, LLVM 22+ (`clang`, `lld`), `git`, `bash`.

```sh
git clone https://github.com/larrydewey/Resid.git
cd Resid
./boot.sh                                   # builds build/boot/stage2.bin (residc)
export RESID_HOME="$PWD/build/boot"
ln -s "$PWD/build/boot/stage2.bin" ~/.local/bin/residc

residc hello.resid -o hello --profile debug # or: residc keygen, then release builds
./hello
```

| Command | |
|---|---|
| `residc app.resid -o app [--profile release\|debug\|check]` | build (release builds are signed) |
| `residc test app.resid` | run the file's `test` blocks |
| `residc keygen` / `residc verify app` | signing keys / check a binary's provenance |
| `residc lsp` | the language server (the VS Code extension in `editors/vscode` uses it) |

## Documentation

The site at **https://larrydewey.github.io/Resid/** has four books:

- **Learn Resid**: a tour from the first program to capabilities,
  concurrency, testing and compile-time reduction.
- **Behaviors**: ordering, showing, the generic verbs, and how to
  behavioralize your code.
- **Reference**: the language, section by section.
- **Stdlib & Tools**: the compiler, providers, the standard library, the
  HTTP server, the editor, the graph tools and debugger, the security model
  and the benchmarks.

Every complete example in the documentation is compiled and run by
`tools/check_doc_examples.py`. The normative specification is
`resid_specification.txt`; `SECURITY.md` is the ledger of security
guarantees and the tests behind each; `PROGRESS.md` is the build log.

## Repository

```text
compiler/     the compiler, in Resid (driver.resid is the entry; lsp.resid the language server)
runtime/rt/   the runtime, in Resid (lowered to build/boot/rt.ll)
lib/          the standard library: crypto, Ed25519, X25519, P-256, RSA, AES-GCM,
              ChaCha20-Poly1305, DER/X.509, TLS 1.3, an HTTP/1.1 client and server,
              HTTP/2 framing, CBOR/COSE, DWARF,
              and date and time (calendar, spans, instants, IANA zones, strftime, clock)
tools/        resid-why, resid-graph, resid-debug, resid-fmt, resid-pkg, resid-manifest
tests/        conformance, reduction, provenance, runtime, graph, package, TLS, HTTP and LSP suites
examples/     complete programs: an HTTP server, TLS and HTTP/2 clients, a lexer and parser
bench/suite/  the cross-language benchmark suite
website/      the documentation site (Astro Starlight)
editors/      the VS Code extension
build/boot/   the committed seed (seed.ll) and runtime IR; boot.sh checks the fixed point
```

## License

MIT. See `LICENSE`.
