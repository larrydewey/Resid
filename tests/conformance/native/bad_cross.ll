; Another module's renamed symbol is not this module's own: refused (E0237).
target triple = "x86_64-pc-linux-gnu"
define i64 @bad_fn() {
  %r = call i64 @native.tiny.tiny_add(i64 1, i64 0)
  ret i64 %r
}
