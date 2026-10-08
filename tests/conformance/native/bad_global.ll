; An external variable is a reference outside the artifact: refused (E0237).
target triple = "x86_64-pc-linux-gnu"
@environ = external global ptr
define i64 @bad_fn() {
  %p = load ptr, ptr @environ
  %i = ptrtoint ptr %p to i64
  ret i64 %i
}
