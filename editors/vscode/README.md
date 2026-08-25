# Resid Language Support for VS Code

Syntax highlighting, snippets, and language configuration for the
[Resid](../../../resid_specification.txt) language (v3.x).

## Features

- **TextMate grammar** (`source.resid`) covering:
  - `//`, `/* */` comments and `///` / `/** */` doc comments
  - Keywords: `if/else/while/for/in/match/return/break/continue/with/spawn/sandbox/import/pub/type/as/rt`
  - First-class numeric types `Int(8..512)`, `UInt(...)`, `Float(16..128)`, `Dec(N)`, `ISize/USize`
  - Core types `Str Bytes Bool Option Result List Map Set RegionError SourceLoc`
  - Conversion helpers `i8…i512`, `u8…u512`, `f16…f128`, `dN`, `isize`, `usize`
  - Built-ins: `assert`, `rt_assert`, `known`, `rt_known`, `comptime_print`, `todo`,
    `unimplemented`, `wrapping_*` / `saturating_*`, `str_*`
  - Annotations `@requires(...)`, `@residual`, capability names
    (`filesystem(readonly)`, `network`, …)
  - Literals: hex/octal/binary ints, floats, decimal `m`-suffix literals, char,
    string, raw `r"…"`, byte `b"…"`, interpolated `f"…{expr:.}"`
  - Ranges `..` / `..=`, `#location`, discard `_ = …`
- **Snippets**: functions, bindings, residual bindings, type definitions,
  match, if-let, for-in, `with` handles, `spawn` regions, sandboxes, imports.
- **Language configuration**: bracket matching/auto-closing, comment toggling,
  folding markers.

## Install locally

```sh
cd editors/vscode
npx @vscode/vsce package
code --install-extension resid-lang-0.1.0.vsix
```

Or symlink/copy this folder into `~/.vscode/extensions/`.
