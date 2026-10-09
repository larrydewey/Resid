; A quoted global name: refused (E0237).
target triple = "aarch64-unknown-linux-gnu"
define i64 @bad_fn() {
  %r = call i64 @"resid_args_count"()
  ret i64 %r
}
