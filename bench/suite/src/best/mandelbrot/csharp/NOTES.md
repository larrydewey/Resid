# mandelbrot / csharp (best)

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/mandelbrot-csharpcore-7.html
(Benchmarks Game, revised BSD license — https://benchmarksgame-team.pages.debian.net/benchmarksgame/license.html).
Chosen as the fastest C# (.NET, "csharpcore") program by elapsed time on the
Benchmarks Game "fastest" page. Program text copied verbatim into Program.cs.

- Project: mirrors the Benchmarks Game Include/csharpcore/program.csproj settings shown on
  the program page (OutputType Exe, ImplicitUsings, Nullable, AllowUnsafeBlocks,
  ServerGarbageCollection=true, ConcurrentGarbageCollection=true, PublishAot=false) with
  TargetFramework net10.0 instead of net9.0. Added InvariantGlobalization (no ICU dependency)
  and NoWarn for nullable warnings only.
- Build: `dotnet build -r linux-x64 -c Release -o out` (as upstream, plus -o out);
  `Directory.Build.props` keeps obj/ and bin/ under out/. Runs the apphost `./out/<name>`.
- Program characteristics: multithreaded, Vector512 (System.Runtime.Intrinsics) SIMD.


Guard run (N = 1232): output differs from the reference from byte 129 on.
The official and small sizes match; the difference at other sizes comes from
this program's vectorised arithmetic and is reported as a guard failure.
