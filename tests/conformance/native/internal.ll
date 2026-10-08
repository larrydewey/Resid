; The bound function is internal, so it is not exported (E0236).
target triple = "x86_64-pc-linux-gnu"
define internal i64 @bad_fn() {
  ret i64 1
}
