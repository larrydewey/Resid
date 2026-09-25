# regex-redux / pascal / st

Own implementation using the FPC-bundled `RegExpr` unit (`TRegExpr`), which is Free Pascal's customary regex library. It is a backtracking interpreter with no JIT. Matches are counted with `Exec`/`ExecNext`, and replacements use `TRegExpr.Replace`. Ignores argv.

Free Pascal 3.2.2 stands in for Delphi/Object Pascal. Single-threaded, no SIMD intrinsics. Build: `fpc -O2`.
