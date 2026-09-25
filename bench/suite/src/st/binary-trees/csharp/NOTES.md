# binary-trees / csharp (st)

Written for this suite from the Benchmarks Game description of the algorithm:
single-threaded, no SIMD (no System.Runtime.Intrinsics, no Vector<T>), no unsafe code, no P/Invoke.


- Toolchain: .NET SDK 10, minimal console project (net10.0), `dotnet build -c Release -o out`.
  Default Release settings: workstation GC, TieredCompilation/TieredPGO defaults,
  no ReadyToRun, no NativeAOT. `InvariantGlobalization` is on so the process does not
  depend on ICU being installed (all formatting is culture-invariant anyway).
- `Directory.Build.props` redirects obj/ and bin/ under ./out/ so every build artifact
  stays in out/ as the suite contract requires.
- The harness runs the framework-dependent apphost `./out/<name>` directly (no `dotnet run`).
- Verified byte-identical against the Benchmarks Game expected output at its
  reference size, and against the `best` java/csharp cells at the contract small size.
