; Module-level assembly could define any symbol: refused (E0237).
target triple = "aarch64-unknown-linux-gnu"
module asm ".globl resid_cap_check"
define i64 @bad_fn() {
  ret i64 1
}
