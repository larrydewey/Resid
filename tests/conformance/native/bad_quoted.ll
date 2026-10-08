; A quoted global name: refused (E0237).
target triple = "x86_64-pc-linux-gnu"
define i64 @bad_fn() {
  %r = call i64 @"resid_args_count"()
  ret i64 %r
}
