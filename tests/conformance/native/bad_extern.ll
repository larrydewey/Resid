; Reaches for a runtime provider: refused (E0237).
target triple = "x86_64-pc-linux-gnu"
declare i64 @resid_process_run(ptr)
define i64 @bad_fn() {
  %r = call i64 @resid_process_run(ptr null)
  ret i64 %r
}
