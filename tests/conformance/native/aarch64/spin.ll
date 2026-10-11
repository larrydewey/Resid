; Spins for a while, so a test can look at the live host (tests/runtime).
target triple = "aarch64-unknown-linux-gnu"
define i64 @spin(i64 %n) {
entry:
  %v = alloca i64
  store volatile i64 0, ptr %v
  br label %loop
loop:
  %i = phi i64 [ 0, %entry ], [ %j, %loop ]
  %j = add i64 %i, 1
  store volatile i64 %j, ptr %v
  %c = icmp ult i64 %j, %n
  br i1 %c, label %loop, label %done
done:
  %r = load volatile i64, ptr %v
  ret i64 %r
}
