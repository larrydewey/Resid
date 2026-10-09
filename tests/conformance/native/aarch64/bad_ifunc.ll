; An ifunc resolver runs during relocation: refused (E0237).
target triple = "aarch64-unknown-linux-gnu"
@bad_fn = ifunc i64 (), ptr @resolve
define ptr @resolve() {
  ret ptr null
}
