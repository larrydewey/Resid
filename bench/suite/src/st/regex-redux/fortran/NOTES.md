# regex-redux / fortran / st

Own implementation. Fortran has no regex library of its own, so this binds the PCRE2 8-bit C API (`pcre2_compile_8`, `pcre2_jit_compile_8`, `pcre2_match_8`, `pcre2_substitute_8`) through iso_c_binding. That is the same library the C programs use. Patterns are JIT-compiled, as in the C PCRE2 programs. Matches are counted with a `pcre2_match` loop, and replacements use `pcre2_substitute` with `PCRE2_SUBSTITUTE_GLOBAL`. Links `-lpcre2-8`. Ignores argv.

Single-threaded, no SIMD intrinsics. Build: `gfortran -O2` (GCC 16.2.1).
