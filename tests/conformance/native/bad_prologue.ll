; Raw prologue bytes run outside the recorded inline asm: refused (E0237).
target triple = "x86_64-pc-linux-gnu"
define i64 @bad_fn() prologue i8 15 {
  ret i64 1
}
