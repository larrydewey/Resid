# fannkuch-redux / csharp (best)

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/fannkuchredux-csharpcore-5.html
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
- Program characteristics: multithreaded, SIMD intrinsics (Vector128/X86 shuffles).
- Deviation: upstream program gives a wrong checksum at the tiny reference size n=7
  (236 vs 228; max-flips correct). Correct at the contract small size 10 (73196 / 38) and
  official size 12 (3968050 / 65), which is where the harness runs it.
