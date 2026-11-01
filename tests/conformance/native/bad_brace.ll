; Text after a function's closing brace escaped the top-level checks: refused (E0237).
target triple = "x86_64-pc-linux-gnu"
define i64 @bad_fn() {
  ret i64 1
} module asm ".globl zz_probe_sym"
