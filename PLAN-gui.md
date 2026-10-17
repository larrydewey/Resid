# A Resid GUI Library — Implementation Plan

**Status: G0-G8 DONE** (updated
2026-10-16). `../resid-gui` runs on Wayland and X11 with every v1 widget,
TrueType text, images, damage tracking and HiDPI; its suite (45 files)
is green, and a full 1080p frame takes 1.9 to 2.1 ms against the 4 ms gate
(§4.1, numbers in §7.1). What is left is running G2 against Xephyr, Xnest or Xfbdev (it ran against the fake
server and Xwayland). Wayland, v2 below, shipped too. §2 records what G1
shipped. Read `AGENTS.md`, `PLAN-native-modules.md`, spec §45 (builders), §46
(vectors), §47 (native modules), and
`website/src/content/docs/reference/native-modules.md` first.

**v1 backend: X11** (was Wayland in the first revision of this plan; the
decision was reversed on 2026-10-06, see `../resid-gui/README.md` and the
`gui_run_x11` call in `../resid-gui/src/gui.resid`). Wayland is v2 behind the
same `Backend(W)` behavior. §3 is rewritten accordingly.

**Goal**: a GUI library for Resid that is *Resid-shaped*: values and pure
functions, no ambient authority, compile-time reduction of whatever is
static, and native code only where it is the right tool. It must not
weaken any guarantee in `resid_specification.txt` or `SECURITY.md`.

---

## 0. What native modules can and cannot do for a GUI

This is the constraint everything below follows from. It is measured,
not assumed (see `PLAN-native-modules.md`, `tests/conformance/native_*`):

| Fact | Consequence for a GUI |
|---|---|
| Native code runs in a process with **no OS access** (seccomp: its socket, non-executable memory, exit). | It can never open a display connection, a GPU device, a file or a font directory. **Windowing, input and presentation must be Resid code** under a capability. |
| Each call is a **fresh process**, so no state survives. | No GPU context, no cached FreeType face, no long-lived native object. Native work must be one self-contained call. |
| A call costs **about 2 ms** (fork + exec). | Never per frame or per glyph. Native calls are **asset preparation**: rasterize a glyph atlas, decode an image. Their results are cached as Resid values. |
| Arguments and results are scalars, `Str(N)` and `Bytes(N)` with N ≤ 16 MiB, fixed at compile time. | A font file or image goes in as `Bytes(16777216)` with a length; an atlas or pixel buffer comes out as a fixed-size `Bytes(M)`. Inputs over 16 MiB are refused with a clear error (decision: no chunking in v1). |
| Fixed-capacity values live inline in their frame (§44), so a `Bytes(16777216)` argument is 16 MiB of stack. | Measured in G0 (§7.1): a spawn worker's stack is 256 MB (`RESID_SPAWN_STACK_MB`), room for a decode's 112 MB, so resid-gui's loaders call the modules in a spawn region, where a crash is an `Err`. Never hold one in a deep recursion. |
| Native code is freestanding (no libc). | Use single-file libraries that build freestanding with a custom allocator: **stb_truetype** (fonts) and **stb_image** (PNG/JPEG/BMP). Not FreeType or HarfBuzz (they need libc/libc++). |

So the library is **pure Resid at its core**. Only two narrow, optional
native modules do the heavy pure computation:

```
 app (Resid)  ── view(Model) → Widget value ── layout ── paint (display list)
      │                                                     │
      │ update(Model, Event)                                ▼
      │                                       raster (pure Resid, Vec SIMD)
      │                                                     │
 events ◄── X11 client (Resid, `display` capability) ◄──┘ shm buffer
                     │
 assets: font bytes ─► native_font  (stb_truetype) ─► glyph atlas value
         image bytes ─► native_image (stb_image)    ─► pixels value
```

## 1. Decisions (locked)

| Question | Decision | Why |
|---|---|---|
| Display protocol | **X11** client, speaking the wire protocol directly in Resid, frames up through MIT-SHM. Wayland is v2 (§8), behind the same `Backend(W)`. | X11 needs no generated binding layer and no XML: a client that renders everything itself uses a small fixed set of requests, object ids and a connection setup handshake. Xlibre ships the server, `Xfbdev` and `Xnest` for testing. |
| Rendering | **CPU software rasterizer in pure Resid** into a shared-memory buffer, using `Vec(T, N)` lanes (§46) for spans. No GPU in v1. | A GPU needs a persistent device context and ioctls; native modules cannot hold either. CPU rendering of UI at 60 Hz is well within reach with SIMD spans and damage tracking. |
| Architecture | **Elm-style**: `init() -> M`, `update(M, Event) -> M`, `view(M) -> Widget`, expressed as a behavior `App(M)`. | Immutable values and pure functions are the language. Equal views give equal display lists, so damage tracking is value comparison. |
| Mutable pixels | A **linear builder** `Canvas` (like §45 `BytesBuf`): each draw op consumes the canvas and returns it; `finish()` yields the frame. | Spec §4 allows mutation only in handles, and §45 makes in-place writes legal and unobservable through linearity. No new mutable value type. |
| Capability | `display` (mode-less), for connecting to the server, creating windows, receiving input and the clipboard. Assets add `filesystem(readonly)` for font and image files, and `native_font` / `native_image`. | Law 14: a GUI program says it touches the display. A library that only computes layouts needs nothing. |
| Where the code lives | Sibling repository **`../resid-gui`** (packages `resid-gui`, `resid-gui-font`, `resid-gui-image`), like `../resid-datastar`. The runtime and compiler additions (§2) live in this repo. | `@link` is refused in `lib/` (E0232). The native packages pin their `.ll` artifacts by SHA-256. |
| Text shaping | Kerning and UTF-8, left-to-right, no complex scripts in v1. | HarfBuzz needs libc++. Complex shaping is §8 future work. |
| Keyboard layout | v1: evdev keycodes through a built-in US layout. v2: parse the XKB keymap text the server sends (pure Resid). | libxkbcommon needs libc. The keymap parser is pure text processing, a good fit for Resid later. |

## 2. Core additions in this repository — DONE (G1)

**Everything in this section shipped.** `runtime/rt/unix.resid` holds the
whole display transport; the compiler, spec and tests are wired. The
signatures below are the ones that actually exist (`ls_builtins` in
`compiler/lsp.resid` is the authority), not the ones this plan first
proposed — bytes are `List(Int)`, and a socket pair helper was added that
the plan did not anticipate.

| Builtin | Meaning |
|---|---|
| `resid_disp_connect() -> Int` | connect to `$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY` (default `wayland-0`), or to `WAYLAND_SOCKET`; `-1` on failure. Reads the environment itself, so a program needs `display`, not `environment`. |
| `resid_disp_pair() -> List(Int)` | a connected Unix socket pair `[a, b]`, empty on failure. Added beyond the plan; what the transport test and the fake server run on. |
| `resid_disp_send(Int fd, List(Int) data, Int pass_fd) -> Bool` | `sendmsg`, with one `SCM_RIGHTS` descriptor when `pass_fd >= 0` |
| `resid_disp_recv(Int fd, Int max) -> List(Int)` | one `recvmsg`; bytes only |
| `resid_disp_recv_fd() -> Int` | a descriptor a receive queued, `-1` when none |
| `resid_disp_poll(List(Int) fds, List(Int) wants, Int ms) -> List(Int)` | `1` read `2` write `4` deadline passed `8` bad — plain fds, so `resid_tcp_poll` would do the same job |
| `resid_disp_close(Int fd) -> Bool` | close |
| `resid_disp_shm_new(Int bytes) -> Int` | a handle: memfd, size, mapping |
| `resid_disp_shm_fd(Int h) -> Int` | the descriptor to pass (MIT-SHM `ShmAttachFd` for X11) |
| `resid_disp_shm_put(Int h, Int off, List(Int) px, Int len) -> Bool` | copy a finished frame, or a damaged band, into the mapping |
| `resid_disp_shm_free(Int h) -> Bool` | unmap and close |

The program never sees a pointer. A frame is a Resid value; presenting
copies it into the handle. Still to measure: the copy at 1920×1080×4
(8 MiB). If it costs more than 2 ms, add `resid_disp_shm_put_rows` for
damaged bands only (§5.5).

Wiring, all present: `display` in `gk_unknown_family`'s sibling check
(`compiler/gcheck.resid`), the `resid_disp_` prefix in `gk_builtin_family`
and `provider_family_of_line`, the `@resid_disp_` classification in
`compiler/codegen.resid`, `compiler/labels.resid`, `ls_builtins` in
`compiler/lsp.resid`, the `declare`s and `check_builtin` cases in the
driver tail, and spec §20 (mode-less; `display(readonly)` is refused).
Tests: `tests/runtime/display.resid` (socketpair round trip with descriptor
passing, plus a refusal when no display is named) and the conformance
cases `display_transport`, `err_display_ungranted`,
`err_display_readonly`, `lambda_caps_sandbox_dropped_ui`.

A new runtime builtin still follows `AGENTS.md`: the `@export` in
`runtime/rt/`, the type in `typecheck.resid` and `codegen.resid`, the
`declare` in the driver tail, `ls_builtins` in `compiler/lsp.resid`; then
`python3 tools/merge_driver.py` and a reseed. A new provider verb the
compiler itself uses needs the two-step bootstrap, but none of these are
used by the compiler.

## 3. The X11 client (`resid-gui/src/x11/`)

### 3.1 Connection setup

X11 has no object ids and no registry: a fixed handshake, then requests.
1. `resid_disp_connect()`; fail closed with a clear error if there is no
   server (no DISPLAY, or `~/.Xauthority` unreadable).
2. Read the first reply: success byte, then the release number, the
   resource-id base/mask, the motion-buffer size, the vendor length and
   string, and the pixmap formats. Everything the client needs to allocate
   ids or match a visual comes from here, so decode it once into a value.
3. Authorization: read the `XAUTHORITY` cookie (an X11 family/name/address/
   number quadruple with 16 bytes of data), then the `Setup` request
   carrying the cookie's name and data. `filesystem(readonly)` covers the
   cookie file, or the cookie can arrive over the inherited descriptor.
4. Big-requests: ask for `BIG-REQUESTS` first, so a large blit or a long
   string is one request instead of a 256 KB chain. Confirm from
   `SetWindowAttributes`' `max-request-length` or the extension's reply.

### 3.2 Requests: opcode plus data, not generated bindings

`src/x11/wire.resid`: an encoder into `ListBuf(Int)` bytes and a decoder
over a received `List(Int)`, both pure, with the fixed opcode table as a
value. v1 needs a small, fixed set, each with one hand-written encoder and
decoder:

| Request | Use |
|---|---|
| `QueryExtension` | ask for MIT-SHM, and later XInput2 |
| `CreateWindow`, `ChangeWindowAttributes`, `MapWindow` | the one top-level window |
| `CreateGC`, `ChangeGC` | one graphics context per depth |
| `PutImage` / `ShmPutImage` | present a finished band |
| `CopyArea` | the damaged rectangles |
| `GetImage` | read back for golden-image comparison |
| `InternAtom`, `ChangeProperty` | WM_NAME, WM_PROTOCOLS |
| Events: `KeyPress`, `KeyRelease`, `ButtonPress/Release`, `MotionNotify`, `Expose`, `ConfigureNotify`, `ClientMessage` | input |

`PutImage` in 24-bit-per-pixel chunks rather than 32 keeps the byte layout
simple; the frame is composited in memory first either way.

### 3.3 Frames: MIT-SHM

`ShmAttachFd` carries `resid_disp_shm_fd(h)`; the reply gives the segment
id; then `ShmPutImage` names the segment and a rectangle in it, so no
bytes cross the socket at all. With no SHM extension the client falls back
to `PutImage` over the socket. Segments are created once at the size of one
frame and reused, so §2's per-call copy is the only cost.

### 3.4 Connection state

The connection is a value: next resource id inside the server's mask, the
setup reply's parsed fields, the event queue, the atom cache. Each step
consumes and returns it (`XConn`), like `lib/httpserv.resid`'s session
state machines. The only handle-held state is the socket fd and the shm
handles.

### 3.5 Testing without a server

A fake X server in Resid (`tests/fake_server.resid`) speaks the setup
handshake and enough of the request stream to accept a client: window
creation, MIT-SHM attach, one `ShmPutImage`, and the event stream. It can
inject scripted input and checksum the shared memory the client wrote.
When `Xephyr`, `Xnest` or `Xfbdev` is installed, also run against a real
server (skip otherwise, like `tests/tls` with `openssl`).

### 3.6 Wayland, later

The same `Backend(W)` gets a second implementation over §2's existing
verbs: the Wayland wire codec, `tools/wl_gen.resid` generating bindings
from vendored protocol XML, `WlConn` object ids and a fake compositor.

## 4. Rendering (`resid-gui/src/gfx/`)

### 4.1 Canvas

`Canvas(W, H)` is a linear builder over `W*H` premultiplied ARGB32 pixels
(little-endian BGRA in memory, matching `WL_SHM_FORMAT_ARGB8888`). Ops:

- `fill_rect(c, Rect, Color)`, `fill_rrect(c, Rect, radius, Color)`
- `blend_mask(c, x, y, Mask, Color)`: an alpha mask (glyph, AA path)
  composited with a color
- `blit(c, x, y, Image)`: premultiplied source-over
- `fill_path(c, Path, Color, FillRule)`: anti-aliased by scanline
  coverage (accumulation-buffer rasterizer, as in font-rs), handling lines
  and quadratic and cubic Béziers by flattening
- `clip_push` / `clip_pop`: rectangular clips, enough for scroll views

Inner loops work on spans with `Vec(UInt(32), 8)` and `Vec(Float(32), 8)`
(§46). **Performance gate** (decide in phase G3, not later): filling a
1920×1080 frame with mixed UI content must take ≤ 4 ms on the benchmark
machine. If pure Resid misses it after profiling, add two runtime builtins
(`resid_gfx_fill_span`, `resid_gfx_blend_span`) written in Resid in
`runtime/rt/`. That is still not C, and it is still not a native module.

### 4.2 Display lists

`paint(Widget, Layout) -> List(DrawOp)` is pure. Rendering a frame is
`fold(draw_ops, canvas, apply)`. Because display lists are values:

- **Damage**: diff the previous and the next frame's lists by value
  equality, per top-level widget box, and redraw only the boxes that
  changed. Commit with `wl_surface.damage_buffer` for those rectangles.
- **Reduction**: a `view` whose model parts are known at compile time (a
  static toolbar, a fixed layout) reduces to a literal display list at
  compile time. Make this a stated, tested property. Add a
  `tests/reduce` case asserting that a static subtree's paint is folded.

## 5. Text and images (native modules)

### 5.1 `resid-gui-font` (`native_font`)

Vendored `stb_truetype.h`, compiled freestanding with
`STBTT_malloc`/`STBTT_free` over a static bump arena in the C shim, and
`STBTT_ifloor` etc. mapped to builtins (no libm: provide `floor`, `ceil`,
`sqrt`, `pow`, `fmod`, `cos`, `acos` in the shim as freestanding C, or use
LLVM intrinsics via `__builtin_*`. Verify the artifact passes E0237).

One entry point per job, each one self-contained (no state survives):

```resid
@link("font")
Bytes(4194304) font_atlas(Bytes(16777216) font, Int font_len,
                          Str(4096) chars, Int px_size) {}
```

The result packs an alpha atlas (2048×2048 max) with a metrics table
(advance, bearing, atlas rect per glyph, kerning pairs for the requested
characters). Decode it in Resid into `GlyphAtlas`, a value cached per
(font hash, size, character set) for the life of the program. A missing
glyph triggers one more call with the extended set.

### 5.2 `resid-gui-image` (`native_image`)

Vendored `stb_image.h` with `STBI_NO_STDIO`, `STBI_NO_SIMD` (no intrinsics
assumptions), and `STBI_MALLOC` over a static arena. Entry point:

```resid
@link("image")
Bytes(16777216) image_decode(Bytes(16777216) data, Int len) {}
```

The result is `[u32 w][u32 h][premultiplied BGRA…]`. Images larger than
the result (about 2048×2048) are refused in v1 with a clear error.

### 5.3 Fallback without native modules

The core library must work with neither native package: a built-in
8×16 bitmap font (public domain, as a Resid literal) and no images. A
program then needs only `display`. Native packages are opt-in
dependencies.

### 5.4 Security review per native package

For each: confirm the artifact passes E0237 unmodified, run the escape
suite pattern from `tests/conformance/native_escape` against a deliberately
malicious variant, and fuzz the entry point with malformed font/image
bytes (the host may crash; the caller must see `Err`, never a hang
beyond the 60 s CPU limit).

### 5.5 Text layout (pure Resid)

UTF-8 iteration, kerning, line breaking at spaces and by width, ellipsis
truncation, caret positions and hit testing (needed by text input).

## 6. Widgets, layout and the event loop (`resid-gui/src/ui/`)

### 6.1 The App behavior

```resid
behavior App(M) {
    M init();
    M update(M m, Event e);
    Widget view(M m);
}
```

`Event` is a sum type covering pointer (move, button, scroll), key
(press/release with keysym and text), focus, resize, close, frame tick,
and app messages. Widgets carry messages as values (`Button("OK",
Clicked)`) so `update` matches on them; no closures are stored in the
tree (closures cannot be compared, and value equality powers damage
tracking).

### 6.2 Widgets (v1)

`Text`, `Button`, `TextInput` (single line, caret, selection, clipboard
later), `Checkbox`, `Slider`, `Image`, `Row`, `Column`, `Stack`,
`Padding`, `Align`, `Scroll` (vertical), `List` (virtualized rows).

### 6.3 Layout

A constraint-based pass (min/max width and height down the tree, sizes
back up), as in Flutter and Druid: `layout(Widget, Constraints) ->
LayoutTree`, pure. Hit testing walks the layout tree. Focus order is the
tree order, with Tab and Shift-Tab moving focus.

### 6.4 The loop

`gui_run(App(M) instance, WindowOptions)`, `@requires(display)` (plus
whatever the app's `update` needs). It connects, creates the
`xdg_toplevel`, then loops over `resid_tcp_poll` on the display fd:
decode events, fold them through `update`, and on a `wl_callback.done`
frame tick re-run `view`, layout, paint, diff, rasterize the damaged
boxes, `put` them into the shm buffer, and commit. Use two buffers,
swapping on `wl_buffer.release`. Timers (animations, caret blink) use
`clock(readonly)` and the poll timeout.

## 7. Phases

Each phase ends with its tests green, documentation, and a commit.

| Phase | Work | Exit criterion |
|---|---|---|
| Phase | Work | Exit criterion | Status |
|---|---|---|---|
| G0 | Spikes: shm copy cost at 1080p; pure-Resid span fill throughput with `Vec`; one stb_truetype build passing E0237; the stack cost of a 16 MiB fixed argument on the main thread and in a `spawn` region | numbers recorded in this file; rasterizer gate decided | **DONE**: §7.1. The bulk span write §4.1 foresaw is the list methods `xs.fill(from, n, x)` and `xs.grow(n, x)` (spec §17) |
| G1 | see §2, which records what shipped | `tests/runtime` and conformance green | **DONE** (2026-10-13) |
| G2 | §3: X11 setup handshake and auth, wire codec, MIT-SHM, connection state, fake server | a solid-color window in the fake server and against Xephyr/Xnest/Xfbdev | **DONE** against the fake server and Xwayland (MIT-SHM, `MIT-MAGIC-COOKIE-1`); Xephyr, Xnest and Xfbdev not tried |
| G3 | §4: Canvas, display lists, golden-image tests (PNG via a tiny pure-Resid encoder, compared by SHA-256), performance gate | goldens stable; 1080p frame ≤ 4 ms | **DONE**: goldens stable; a full 1080p frame is 1.9 to 2.1 ms (§7.1) against the 4 ms gate; an ordinary frame redraws its damage in microseconds |
| G4 | §5.1, §5.5: font package, atlas, text layout, bitmap fallback | text goldens; malicious-font fuzz yields `Err` | **DONE**: `../resid-gui/tests/evil.sh` (10 attacks, each an `Err`; 7 lying answers refused), `native/fuzz/run.sh` |
| G5 | §6: App behavior, widgets, layout, input, focus, event loop | counter and todo examples run against a real X server with scripted input | **DONE** (Xwayland, XTEST input; Hyprland with a virtual pointer and `wtype`) |
| G6 | §5.2: image package | image viewer example; fuzz | **DONE** (`examples/image_viewer.resid`; fuzzed) |
| G7 | Damage tracking, double buffering, timers, HiDPI | idle CPU ≈ 0; a blinking caret redraws only its box | **DONE**: 0 to 1 CPU ticks in 10 s idle; a blink redraws a 1x16 box (`gui.resid` test) |
| G8 | Documentation: a Learn chapter ("Your first window"), a Reference page per module, `SECURITY.md` rows, examples in `../resid-gui/examples/` | doc examples compile under `tools/check_doc_examples.py` | **DONE**; the doc examples are checked by `../resid-gui/tools/check_docs.py` (programs type-checked, not run, since they open windows; every listed signature must exist) |

### 7.1 Measurements (G0, G3, G7)

AMD Ryzen AI 7 PRO 350, Linux 7.2, 2026-10-16; `../resid-gui/bench/`.

| What | Number |
|---|---|
| Copying a 1920x1080 frame into shared memory | 15.7 ms with `resid_disp_shm_put` (a list element per byte); 2.2 ms with `resid_disp_shm_put32` (an element per pixel) |
| Pure-Resid span fill, one `with` per pixel into a canvas the compiler proved owned | about 4.3 ns a pixel: 8.7 to 9.7 ms for a whole 1080p frame |
| Building a 1080p canvas (`ListBuf` push per pixel) | 8.3 to 8.9 ms |
| Building a 1080p canvas with `xs.grow(n, x)` (spec §17) | 0.3 to 0.8 ms (16 MB of slots written by 8 KiB copies) |
| A full-frame fill, one `xs.fill(from, n, x)` per row into an owned canvas | about 0.3 ms; the 736 ops' fills (118% of a frame's area) 0.6 ms on top of the canvas |
| stb_truetype and stb_image, built freestanding | both pass E0237 unmodified (`native/build.sh`) |
| A 16 MiB fixed argument | fine on the main thread (1 GiB stack); faulted in a `spawn` region on the old 8 MiB worker stack; a region that decodes an image needs about 112 MB, so workers now reserve 256 MB (`RESID_SPAWN_STACK_MB`) |
| A whole 1920x1080 frame of 736 draw ops (45 rows of controls) | 65.3 ms with a byte per list element; 20.1 ms with a word per pixel (paint 0.1, rasterize 17.7, upload 2.2); 5.1 ms with `grow` and `fill` (paint 0.0, rasterize 4.5, upload 0.5); 1.9 to 2.1 ms with the font table built once per string (paint 0.0, rasterize 1.3 to 1.5, upload 0.5) |
| A caret blink | 1 to 2 µs, one 1x16 rectangle |
| Idle | 0 CPU ticks in 10 s (counter), 1 (todo) |

The rasterizer's cost was per list element, not per byte of work: `Vec`
lanes cannot be stored into a list (§46: a vector cannot appear inside a
List), so a span was one `with` per pixel. The bulk write §4.1 foresaw is
now two list methods (spec §17): `xs.fill(from, n, x)` replaces a run in
place under the same ownership proof as `with`, and `xs.grow(n, x)`
appends `n` copies, so `canvas_new`, `canvas_filled` and `fill_rows` in
`../resid-gui/src/gfx/canvas.resid` cost a store per pixel. That took the
full frame from 20.1 ms to 5.1 ms. Of the 4.5 ms rasterization left, fills
were 0.6 ms and the canvas 0.3 ms; text was 4.0 ms for 1150 characters of
the built-in font, because `glyph_row` (`src/gfx/font.resid`) rebuilt the
1520-entry `font_data()` list (eight `concat`s) for every glyph row it read,
about 18,400 times a frame. `render_text_scaled` now builds the table once
per string and passes it down to `glyph_row_in`, which took the frame to
1.9 to 2.1 ms (rasterize 1.3 to 1.5) and met the gate with goldens
unchanged. Writing each run of a glyph row's set bits with one `fill`
instead of a `with` per pixel measured the same, so the per-pixel writes
stay. The upload
measured 0.5 ms in this run, against 2.2 ms before; nothing in it changed,
so take the range as 0.5 to 2.2 ms.

## 8. Out of scope for v1 (and why)

- **GPU rendering**: needs a device context that outlives a call. A future
  design would be a `gpu` capability with Resid-side DRM/Vulkan ioctls,
  not a native module.
- **Wayland, macOS, Windows**: the runtime is Linux-only and libc-free.
  Wayland is v2 (§3.6); macOS and Windows would each be a backend behind
  the same `Surface` interface.
- **Complex text shaping, bidi, IME, accessibility (AT-SPI over D-Bus)**:
  each is a project of its own. They are listed so the widget model
  leaves room for them: text runs carry a script/direction field from v1.

## 9. Security checklist (repeat at every phase)

- No new ambient authority: every new builtin is in a family, and every
  library function that reaches one declares `@requires`.
- `lib/` and `tools/` stay free of `@link`; native code lives only in the
  `resid-gui-font` and `resid-gui-image` packages, and their artifacts
  are pinned by SHA-256.
- Data from the server is untrusted input: every decoder
  bounds-checks sizes, object ids and opcodes, and a malformed message
  ends the connection with an error, never an out-of-range access.
- Font and image bytes are untrusted input to native code. The process
  boundary contains a crash. The decoded result is checked for size and
  format by the Resid caller before use.
