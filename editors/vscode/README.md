# Resid Language Support for VS Code

Syntax highlighting, snippets, language configuration, and **LSP support** (diagnostics + hover for residual notes) for the
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
- **LSP (`resid-lsp`)**: Parse/type diagnostics, completions, hover, symbols,
  go-to-definition, and references

## LSP Setup

The extension includes an LSP client that connects to the full `resid-lsp`
server (the binary source is in `tools/resid-lsp-full/`).

### Prerequisites

1. Build the LSP server:
   ```sh
   cargo build -p resid-lsp --release
   ```
   This produces `target/release/resid-lsp`.

2. Ensure `resid-lsp` is in your `PATH`, or configure the path in settings.

### Settings

| Setting | Description | Default |
|---------|-------------|---------|
| `resid.lsp.enable` | Enable the Resid LSP server | `true` |
| `resid.lsp.serverPath` | Path or command to the `resid-lsp` binary. Empty auto-detects `target/release` or `target/debug` in the workspace, then PATH. | `""` |

### How it works

1. Run `residc build` on your Resid project — this produces `.resid-notes.cbor` sidecars.
2. Open a `.resid` file in VS Code.
3. The LSP client finds sidecars in the same directory (and `target/` sibling) and publishes diagnostics.
4. Hover a line with a residual (lightbulb/squiggly) to see what knowledge is missing.

## Install locally

```sh
cd editors/vscode
npm install
npm run compile
npx @vscode/vsce package
code --install-extension resid-lang-0.2.0.vsix
```

Or run the extension in development:
1. Open this repo in VS Code
2. Press `F5` → "Launch Extension"
3. A new VS Code window opens with the extension loaded

## Development

- `npm run compile` — compile TypeScript to `out/`
- `npm run watch` — watch mode
- `npm run lint` — ESLint
- `npm run package` — create `.vsix`