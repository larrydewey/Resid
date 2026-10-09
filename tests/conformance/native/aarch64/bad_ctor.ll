; A constructor would run at load time in the program itself: refused (E0237).
target triple = "aarch64-unknown-linux-gnu"
@llvm.global_ctors = appending global [1 x { i32, ptr, ptr }] [{ i32, ptr, ptr } { i32 65535, ptr @bad_fn, ptr null }]
define i64 @bad_fn() {
  ret i64 1
}
