# Resid Language Support for VS Code

Syntax highlighting, snippets, language configuration, and a **language server** (`residc lsp`) for the
[Resid](https://github.com/larrydewey/Resid) language.

## Features

- **TextMate grammar** (`source.resid`) covering:
  - `//`, `/* */` comments and `///` / `/** */` doc comments
  - Keywords: `if/else/while/for/in/match/return/break/continue/with/spawn/sandbox/lambda`,
    declarations `type/behavior/test/pub/import/as/rt`, and the `using =` argument
  - First-class numeric types `Int(8..512)`, `UInt(...)`, `Float(16..128)`, `Dec(N)`, `ISize/USize`
  - Fixed-capacity stack types `Str(N)`, `Bytes(N)`, `List(T, N)` (spec §44)
  - Core types `Str Bytes Bool Option Result List Map Set StrBuf ListBuf Secret RegionError SourceLoc`,
    the variants `Some None Ok Err`, and user types
  - Conversion helpers `i8…i512`, `u8…u512`, `f16…f128`, `dN`, `isize`, `usize`
  - Built-ins: `assert`, `rt_assert`, `known`, `rt_known`, `comptime_print`, `todo`,
    `unimplemented`, `wrapping_*` / `saturating_*` / `checked_*`, `str_*`,
    `secret` / `classify` / `secret_split` / `secret_join`, `ct_hide` / `ct_public`
  - Annotations (`@requires(...)`, `@needs`, `@trust`, ...) and the capability
    families with their modes (`filesystem(readonly)`, `network`, `clock(readonly)`,
    `declassify`, `display`, `random`, `native_<m>`, ...)
  - Literals: hex/octal/binary ints, floats, decimal `m`-suffix literals, char,
    string, raw `r"…"`, byte `b"…"`, interpolated `f"…{expr}"` with its format
    spec (`{n:group}`, `{f:precision 2}`, `{s:fill '.', center}`) and the
    `{{` / `}}` brace escapes; the escapes `\n \t \r \0 \\ \" \' \xHH`,
    any other marked invalid
  - Ranges `..` / `..=`, `#location`, discard `_ = …`
- **Snippets**: functions, `main`, bindings, residual bindings, product, sum and
  constrained types, behaviors and their instances, match, if/else, loops,
  lambdas, `spawn` regions, sandboxes, inline tests, imports.
- **Language configuration**: bracket matching/auto-closing, comment toggling,
  folding markers.
- **Language server (`residc lsp`)**: diagnostics, hover, go to definition,
  document symbols and completion

Vim, Neovim and Emacs support live in their own repositories:
[resid-vim](https://github.com/larrydewey/resid-vim),
[resid-nvim](https://github.com/larrydewey/resid-nvim) and
[resid-mode](https://github.com/larrydewey/resid-mode).

## Language server

The server is the compiler itself: `residc lsp` runs the compiler's front
end (import resolution, parsing, resolution and checking) in process on the
editor's buffer, so unsaved edits are checked too. It provides:

- diagnostics on open, change and save (the compiler's own errors, with
  their codes)
- hover: the definition's signature, its `///` doc comment and the type, and
  an f-string hole's format spec
- go to definition, across imports
- document symbols (functions, types, behaviors, tests)
- completion of keywords and top-level names, and of the format flags when the
  cursor is inside an f-string hole's spec

The extension looks for `build/boot/stage2.bin` in the workspace (when the
workspace is the Resid repository), then `residc` on `PATH`.

### Settings

| Setting | Description | Default |
|---------|-------------|---------|
| `resid.lsp.enable` | Run the language server | `true` |
| `resid.compilerPath` | Path to the Resid compiler; empty auto-detects | `""` |

## Install locally

```sh
cd editors/vscode
npm install
npm run compile
npx @vscode/vsce package
code --install-extension resid-lang-0.4.0.vsix
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