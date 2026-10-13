# Zig port of Are We Fast Yet

Written for this suite from the Java reference (upstream commit in
`../upstream/COMMIT`); AWFY has no upstream Zig port. Same algorithms, data
and verification. Zig 0.16, standard library only, `-O ReleaseFast`
(`build`); `src/rap.json` is the Json document, `@embedFile`d.

Memory follows AWFY's explicit-memory rules (`../upstream/guidelines.md`)
and the C++ port's strategy per benchmark: every allocation is freed, and
a Debug build (`zig build-exe -O Debug src/main.zig`) runs under
`std.heap.DebugAllocator`, which panics on a leak. Release builds use
`std.heap.smp_allocator`, Zig's general-purpose allocator.

Choices an expert Zig programmer would make, recorded so a reviewer can
challenge them:

- **Arenas** where the C++ port frees a whole graph at once: Richards and
  DeltaBlue (C++ `object_tracker`) and Json (C++ frees the tree; std.json
  also parses into an arena). An arena is the idiomatic Zig form of that
  strategy, and it is cheaper than freeing objects one by one; a reviewer
  may prefer individual frees.
- **Explicit ownership** elsewhere, as in C++: CD's trees free their nodes
  and the voxel map its vectors; Havlak's graph, loop structure and finder
  own and free their parts; List, Storage, Towers, Permute and Queens free
  what each iteration allocates. Bounce, NBody and Sieve live on the stack.
- **Virtual dispatch**: Zig has no closures or inheritance, so Richards'
  task functions and data records are a tagged union and DeltaBlue's
  constraint subclasses one struct switched on its kind (as in the Go and
  Rust ports).
- **Json** keeps `current` as a one-character slice of the input (the
  reference's `substring`), compared with `std.mem.eql`.
- **Havlak** keeps the reference's quirks (`findSet` relinks to the starting
  node's parent; `stepE` walks a set it may extend) and sums the 50
  discarded `findLoops` results so the optimiser cannot drop them.
- **DeltaBlue** skips the reference's `Vector.sort`, whose `swap` is
  unimplemented: it only ever sees lists already in order.
- Integer arithmetic is `i32` as in Java; ReleaseFast drops Zig's overflow
  checks (Debug keeps them, and the Debug run passes).

## Reviewer

Not yet reviewed by a second Zig programmer.
