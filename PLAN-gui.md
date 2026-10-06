# A Resid GUI Library — Implementation Plan

**Status: NOT STARTED.** This is for a fresh session. Read `AGENTS.md`,
`PLAN-native-modules.md`, spec §45 (builders), §46 (vectors), §47 (native
modules), and `website/src/content/docs/reference/native-modules.md`
first.

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
| Fixed-capacity values live inline in their frame (§44), so a `Bytes(16777216)` argument is 16 MiB of stack. | Call asset loaders from the main thread (whose stack is large), or measure spawn-thread stack sizes in G0 and size the buffers to fit. Never hold one in a deep recursion. |
| Native code is freestanding (no libc). | Use single-file libraries that build freestanding with a custom allocator: **stb_truetype** (fonts) and **stb_image** (PNG/JPEG/BMP). Not FreeType or HarfBuzz (they need libc/libc++). |

So the library is **pure Resid at its core**. Only two narrow, optional
native modules do the heavy pure computation:

```
 app (Resid)  ── view(Model) → Widget value ── layout ── paint (display list)
      │                                                     │
      │ update(Model, Event)                                ▼
      │                                       raster (pure Resid, Vec SIMD)
      │                                                     │
 events ◄── Wayland client (Resid, `display` capability) ◄──┘ shm buffer
                     │
 assets: font bytes ─► native_font  (stb_truetype) ─► glyph atlas value
         image bytes ─► native_image (stb_image)    ─► pixels value
```

## 1. Decisions (locked)

| Question | Decision | Why |
|---|---|---|
| Display protocol | **Wayland** client, speaking the wire protocol directly in Resid. X11 is later work (§8), not v1. | Wayland is small (32-bit words over a Unix socket) and uses fd-passed shared memory, so presenting needs no extension. It is the current Linux desktop. |
| Rendering | **CPU software rasterizer in pure Resid** into a shared-memory buffer, using `Vec(T, N)` lanes (§46) for spans. No GPU in v1. | A GPU needs a persistent device context and ioctls; native modules cannot hold either. CPU rendering of UI at 60 Hz is well within reach with SIMD spans and damage tracking. |
| Architecture | **Elm-style**: `init() -> M`, `update(M, Event) -> M`, `view(M) -> Widget`, expressed as a behavior `App(M)`. | Immutable values and pure functions are the language. Equal views give equal display lists, so damage tracking is value comparison. |
| Mutable pixels | A **linear builder** `Canvas` (like §45 `BytesBuf`): each draw op consumes the canvas and returns it; `finish()` yields the frame. | Spec §4 allows mutation only in handles, and §45 makes in-place writes legal and unobservable through linearity. No new mutable value type. |
| Capability | New family **`display`** (mode-less in v1), for connecting to the compositor, creating windows, receiving input and the clipboard. Assets add `filesystem(readonly)` for font and image files, and `native_font` / `native_image`. | Law 14: a GUI program says it touches the display. A library that only computes layouts needs nothing. |
| Where the code lives | Sibling repository **`../resid-gui`** (packages `resid-gui`, `resid-gui-font`, `resid-gui-image`), like `../resid-datastar`. The runtime and compiler additions (§2) live in this repo. | `@link` is refused in `lib/` (E0232). The native packages pin their `.ll` artifacts by SHA-256. |
| Text shaping | Kerning and UTF-8, left-to-right, no complex scripts in v1. | HarfBuzz needs libc++. Complex shaping is §8 future work. |
| Keyboard layout | v1: evdev keycodes through a built-in US layout. v2: parse the XKB keymap text the compositor sends (pure Resid). | libxkbcommon needs libc. The keymap parser is pure text processing, a good fit for Resid later. |

## 2. Core additions in this repository

Each new runtime builtin follows `AGENTS.md`: the `@export` in
`runtime/rt/`, the type in `typecheck.resid` and `codegen.resid`, the
`declare` in the driver tail's `hdr_core`, `ls_builtins` in
`compiler/lsp.resid`; then `python3 tools/merge_driver.py` and a reseed.
A new provider verb the compiler itself uses needs the two-step bootstrap,
but none of these are used by the compiler.

### 2.1 The `display` family

- Add `display` to `gk_unknown_family`, `gk_builtin_family` (prefix
  `resid_disp_`), `provider_family_of_line`, the spec §20 family table,
  `SECURITY.md`, and the website capability table.
- Mode-less in v1 (`display(readonly)` refused, as for `native_*`).
  Reconsider modes only if the clipboard needs a read-only grant.

### 2.2 Unix sockets with descriptor passing (`runtime/rt/unix.resid`)

| Builtin | Meaning |
|---|---|
| `resid_disp_connect() -> Int` | connect to `$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY` (default `wayland-0`), or to `WAYLAND_SOCKET` when set; `-1` on failure. Reads the environment itself, so the program needs `display`, not `environment`. |
| `resid_disp_send(fd, Bytes data, Int len, Int pass_fd) -> Bool` | `sendmsg`, with one `SCM_RIGHTS` fd when `pass_fd >= 0` |
| `resid_disp_recv(fd, Int max) -> Bytes` and `resid_disp_recv_fd() -> Int` | `recvmsg`, keeping received fds in a per-connection queue; Wayland sends fds for keymaps and the like |
| `resid_disp_close(fd)` | close |

Polling reuses `resid_tcp_poll` (it takes plain fds). Add a test that it
accepts a Unix socket fd.

### 2.3 Shared-memory buffers: a `Surface` handle

`memfd_create` + `ftruncate` + `mmap(MAP_SHARED)` are runtime internals.
Expose them only as a **handle** (spec §4, §16):

| Builtin | Meaning |
|---|---|
| `resid_disp_shm_new(Int bytes) -> Int` | a handle: memfd, size, mapping |
| `resid_disp_shm_fd(h) -> Int` | the fd to pass in `wl_shm.create_pool` |
| `resid_disp_shm_put(h, Int off, Bytes(N) px, Int len)` | copy a finished frame (or a damaged band of it) into the mapping |
| `resid_disp_shm_free(h)` | unmap and close |

The program never sees a pointer. A frame is a Resid value; presenting
copies it into the handle. Measure this copy at 1920×1080×4 (8 MiB). If
it costs more than 2 ms, add `resid_disp_shm_put_rows` for damaged bands
only (planned, see §5.5).

### 2.4 Tests (this repository)

`tests/runtime`: Unix socketpair round trip with fd passing; shm handle
write/read back through a second mapping; `display` E0219 cases in
conformance (`err_display_ungranted`, `display_readonly_refused`).

## 3. The Wayland client (`resid-gui/src/wl/`)

### 3.1 Wire format

Messages are `[object id u32][size<<16 | opcode u32][args…]`, little-endian,
with args 32-bit aligned: `int`, `uint`, `fixed` (24.8), `string` (u32
length incl. NUL, padded), `object`, `new_id`, `array`, and `fd` (out of
band). Implement `wl_wire.resid`: an encoder into `ListBuf(Int)` bytes and
a decoder over a received `Bytes`, both pure and unit-tested with recorded
byte sequences.

### 3.2 Protocol bindings: generated, not hand-written

`tools/wl_gen.resid` (in `resid-gui`) reads the protocol XML (`wayland.xml`,
`xdg-shell.xml`, vendored with their licenses) using a small pure-Resid XML
reader, and writes Resid source: one type per interface, request encoders
and event decoders as a sum type per interface. Commit the generated
files. The generator's output is checked by a test that regenerates and
compares.

Interfaces for v1: `wl_display`, `wl_registry`, `wl_callback`,
`wl_compositor`, `wl_surface`, `wl_shm`, `wl_shm_pool`, `wl_buffer`,
`wl_seat`, `wl_pointer`, `wl_keyboard`, `wl_output`, `xdg_wm_base`,
`xdg_surface`, `xdg_toplevel`. Later: `wp_fractional_scale_v1`,
`wp_viewporter`, `wl_data_device` (clipboard), `zwp_text_input_v3` (IME).

### 3.3 Connection state

The connection is a value: next object id, the id→interface table, the
globals, the pending fd queue. Each step consumes and returns it
(`WlConn`), like `lib/httpserv.resid`'s session state machines. The only
handle-held state is the socket fd and the shm `Surface`s.

### 3.4 Testing without a compositor

A fake compositor in Resid (`tests/fake_compositor.resid`) speaks enough
of the server side over a socketpair to accept a client: registry,
compositor, shm, xdg_wm_base, a seat with a pointer and keyboard. It can
inject input events and checksum committed buffers. When `weston` is
installed, also run against `weston --backend=headless`
(skip otherwise, like `tests/tls` with `openssl`).

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
| G0 | Spikes: shm copy cost at 1080p; pure-Resid span fill throughput with `Vec`; one stb_truetype build passing E0237; the stack cost of a 16 MiB fixed argument on the main thread and in a `spawn` region | numbers recorded in this file; rasterizer gate decided |
| G1 | §2: `display` family, Unix sockets with fd passing, shm `Surface` handle, tests, reseed, spec §20 and SECURITY.md rows | `tests/runtime` and conformance green |
| G2 | §3: wire codec, XML generator, generated bindings, fake compositor | the client shows a solid-color window in the fake compositor and in weston headless |
| G3 | §4: Canvas, display lists, golden-image tests (PNG via a tiny pure-Resid encoder, compared by SHA-256), performance gate | goldens stable; 1080p frame ≤ 4 ms |
| G4 | §5.1, §5.5: font package, atlas, text layout, bitmap fallback | text goldens; malicious-font fuzz yields `Err` |
| G5 | §6: App behavior, widgets, layout, input, focus, event loop | counter and todo examples run under weston headless with scripted input |
| G6 | §5.2: image package | image viewer example; fuzz |
| G7 | Damage tracking, double buffering, timers, HiDPI (`wp_fractional_scale`) | idle CPU ≈ 0; a blinking caret redraws only its box |
| G8 | Documentation: a Learn chapter ("Your first window"), a Reference page per module, `SECURITY.md` rows, examples in `../resid-gui/examples/` | doc examples compile under `tools/check_doc_examples.py` |

## 8. Out of scope for v1 (and why)

- **GPU rendering**: needs a device context that outlives a call. A future
  design would be a `gpu` capability with Resid-side DRM/Vulkan ioctls,
  not a native module.
- **X11, macOS, Windows**: the runtime is Linux-only and libc-free. X11
  would be a second backend behind the same `Surface` interface.
- **Complex text shaping, bidi, IME, accessibility (AT-SPI over D-Bus)**:
  each is a project of its own. They are listed so the widget model
  leaves room for them: text runs carry a script/direction field from v1.

## 9. Security checklist (repeat at every phase)

- No new ambient authority: every new builtin is in a family, and every
  library function that reaches one declares `@requires`.
- `lib/` and `tools/` stay free of `@link`; native code lives only in the
  `resid-gui-font` and `resid-gui-image` packages, and their artifacts
  are pinned by SHA-256.
- Data from the compositor is untrusted input: every decoder
  bounds-checks sizes, object ids and opcodes, and a malformed message
  ends the connection with an error, never an out-of-range access.
- Font and image bytes are untrusted input to native code. The process
  boundary contains a crash. The decoded result is checked for size and
  format by the Resid caller before use.
