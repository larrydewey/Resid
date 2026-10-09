; The bound function is internal, so it is not exported (E0236).
target triple = "aarch64-unknown-linux-gnu"
define internal i64 @bad_fn() {
  ret i64 1
}
