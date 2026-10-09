; Code placed in another section (here an init array): refused (E0237).
target triple = "aarch64-unknown-linux-gnu"
@hook = global ptr @bad_fn, section ".init_array"
define i64 @bad_fn() {
  ret i64 1
}
