# regex-redux / csharp (best)

Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/regexredux-csharpcore-2.html
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
- Program characteristics: multithreaded; PCRE2 JIT via DllImport("pcre2-8") (system libpcre2-8.so).

