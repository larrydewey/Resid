declare ptr @malloc(i64)
declare void @free(ptr)
declare <2 x i64> @llvm.x86.aesni.aesenc(<2 x i64>, <2 x i64>)
declare <2 x i64> @llvm.x86.aesni.aesenclast(<2 x i64>, <2 x i64>)
declare {i8, i1} @llvm.sadd.with.overflow.i8(i8, i8)
declare {i16, i1} @llvm.sadd.with.overflow.i16(i16, i16)
declare {i32, i1} @llvm.sadd.with.overflow.i32(i32, i32)
declare {i64, i1} @llvm.sadd.with.overflow.i64(i64, i64)
declare {i128, i1} @llvm.sadd.with.overflow.i128(i128, i128)
declare {i256, i1} @llvm.sadd.with.overflow.i256(i256, i256)
declare {i512, i1} @llvm.sadd.with.overflow.i512(i512, i512)
declare {i8, i1} @llvm.ssub.with.overflow.i8(i8, i8)
declare {i16, i1} @llvm.ssub.with.overflow.i16(i16, i16)
declare {i32, i1} @llvm.ssub.with.overflow.i32(i32, i32)
declare {i64, i1} @llvm.ssub.with.overflow.i64(i64, i64)
declare {i128, i1} @llvm.ssub.with.overflow.i128(i128, i128)
declare {i256, i1} @llvm.ssub.with.overflow.i256(i256, i256)
declare {i512, i1} @llvm.ssub.with.overflow.i512(i512, i512)
declare {i8, i1} @llvm.smul.with.overflow.i8(i8, i8)
declare {i16, i1} @llvm.smul.with.overflow.i16(i16, i16)
declare {i32, i1} @llvm.smul.with.overflow.i32(i32, i32)
declare {i64, i1} @llvm.smul.with.overflow.i64(i64, i64)
declare {i128, i1} @llvm.smul.with.overflow.i128(i128, i128)
declare {i256, i1} @llvm.smul.with.overflow.i256(i256, i256)
declare {i512, i1} @llvm.smul.with.overflow.i512(i512, i512)
declare {i8, i1} @llvm.uadd.with.overflow.i8(i8, i8)
declare {i16, i1} @llvm.uadd.with.overflow.i16(i16, i16)
declare {i32, i1} @llvm.uadd.with.overflow.i32(i32, i32)
declare {i64, i1} @llvm.uadd.with.overflow.i64(i64, i64)
declare {i128, i1} @llvm.uadd.with.overflow.i128(i128, i128)
declare {i256, i1} @llvm.uadd.with.overflow.i256(i256, i256)
declare {i512, i1} @llvm.uadd.with.overflow.i512(i512, i512)
declare {i8, i1} @llvm.usub.with.overflow.i8(i8, i8)
declare {i16, i1} @llvm.usub.with.overflow.i16(i16, i16)
declare {i32, i1} @llvm.usub.with.overflow.i32(i32, i32)
declare {i64, i1} @llvm.usub.with.overflow.i64(i64, i64)
declare {i128, i1} @llvm.usub.with.overflow.i128(i128, i128)
declare {i256, i1} @llvm.usub.with.overflow.i256(i256, i256)
declare {i512, i1} @llvm.usub.with.overflow.i512(i512, i512)
declare {i8, i1} @llvm.umul.with.overflow.i8(i8, i8)
declare {i16, i1} @llvm.umul.with.overflow.i16(i16, i16)
declare {i32, i1} @llvm.umul.with.overflow.i32(i32, i32)
declare {i64, i1} @llvm.umul.with.overflow.i64(i64, i64)
declare {i128, i1} @llvm.umul.with.overflow.i128(i128, i128)
declare {i256, i1} @llvm.umul.with.overflow.i256(i256, i256)
declare {i512, i1} @llvm.umul.with.overflow.i512(i512, i512)
declare void @llvm.memmove.p0.p0.i64(ptr, ptr, i64, i1)
declare void @llvm.memset.p0.i64(ptr, i8, i64, i1)
declare ptr @llvm.threadlocal.address.p0(ptr)
@.fixedidx = private unnamed_addr constant [12 x i8] c"fixed index\00"
define linkonce_odr ptr @e.itoa(ptr %buf, i64 %v) {
entry:
  %zn = icmp eq i64 %v, 0
  br i1 %zn, label %zero, label %prep
zero:
  %zp = getelementptr i8, ptr %buf, i64 22
  store i8 48, ptr %zp
  %zt = getelementptr i8, ptr %buf, i64 23
  store i8 0, ptr %zt
  ret ptr %zp
prep:
  %neg = icmp slt i64 %v, 0
  %an = sub i64 0, %v
  %mag = select i1 %neg, i64 %an, i64 %v
  br label %loop
loop:
  %cur = phi i64 [ %mag, %prep ], [ %q, %body ]
  %idx = phi i64 [ 22, %prep ], [ %im, %body ]
  %d = urem i64 %cur, 10
  %q = udiv i64 %cur, 10
  %ai = add i64 %d, 48
  %ab = trunc i64 %ai to i8
  %sp = getelementptr i8, ptr %buf, i64 %idx
  store i8 %ab, ptr %sp
  %im = sub i64 %idx, 1
  %more = icmp ne i64 %q, 0
  br i1 %more, label %body, label %sig
body:
  br label %loop
sig:
  br i1 %neg, label %wneg, label %wpos
wpos:
  %pp = getelementptr i8, ptr %buf, i64 %idx
  %pt = getelementptr i8, ptr %buf, i64 23
  store i8 0, ptr %pt
  ret ptr %pp
wneg:
  %mi = sub i64 %idx, 1
  %mp = getelementptr i8, ptr %buf, i64 %mi
  store i8 45, ptr %mp
  %mt = getelementptr i8, ptr %buf, i64 23
  store i8 0, ptr %mt
  ret ptr %mp
}
declare i64 @llvm.ctpop.i64(i64)
declare i32 @_setjmp(ptr) returns_twice
define linkonce_odr i64 @e.catch(i64 %slot, i64 %fn, i64 %arg) noinline {
entry:
  %jb = alloca [256 x i8], align 16
  %sp = inttoptr i64 %slot to ptr
  %prev = load volatile i64, ptr %sp
  %jbi = ptrtoint ptr %jb to i64
  store volatile i64 %jbi, ptr %sp
  %r = call i32 @_setjmp(ptr %jb) returns_twice
  %z = icmp eq i32 %r, 0
  br i1 %z, label %run, label %caught
run:
  %f = inttoptr i64 %fn to ptr
  %x = call i64 %f(i64 %arg)
  store volatile i64 %prev, ptr %sp
  ret i64 0
caught:
  store volatile i64 %prev, ptr %sp
  ret i64 1
}
define internal i64 @c_abort(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
call void @resid_abort(ptr %x0)
unreachable
}
define internal i64 @rt_abort(ptr %p0) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1 = ptrtoint ptr %p0 to i64
%t2 = call i64 @c_abort(i64 %t1)
ret i64 %t2
}
define internal i64 @rt_abort_at(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3 = tail call i64 @c_abort(i64 %p0)
ret i64 %t3
}
define internal i64 @c_malloc(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call ptr @malloc(i64 %a0)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_calloc(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call ptr @calloc(i64 %a0, i64 %a1)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_realloc(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call ptr @realloc(ptr %x0, i64 %a1)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_free(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
call void @free(ptr %x0)
ret i64 0
}
define internal i64 @c_strlen(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call i64 @strlen(ptr %x0)
ret i64 %r
}
define internal i64 @c_memcmp(i64 %a0, i64 %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = inttoptr i64 %a1 to ptr
%r = call i32 @memcmp(ptr %x0, ptr %x1, i64 %a2)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_memchr(i64 %a0, i64 %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = trunc i64 %a1 to i32
%r = call ptr @memchr(ptr %x0, i32 %x1, i64 %a2)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_memmem(i64 %a0, i64 %a1, i64 %a2, i64 %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x2 = inttoptr i64 %a2 to ptr
%r = call ptr @memmem(ptr %x0, i64 %a1, ptr %x2, i64 %a3)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_strcmp(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = inttoptr i64 %a1 to ptr
%r = call i32 @strcmp(ptr %x0, ptr %x1)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_strstr(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = inttoptr i64 %a1 to ptr
%r = call ptr @strstr(ptr %x0, ptr %x1)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_getenv(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call ptr @getenv(ptr %x0)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @rt_alloc(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call ptr @resid_rt_alloc(i64 %a0)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @rt_arena_contains(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call i8 @resid_rt_arena_contains(ptr %x0)
%rv = zext i8 %r to i64
ret i64 %rv
}
define internal double @c_strtod(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = inttoptr i64 %a1 to ptr
%r = call double @strtod(ptr %x0, ptr %x1)
ret double %r
}
define internal i64 @c_strncmp(i64 %a0, i64 %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = inttoptr i64 %a1 to ptr
%r = call i32 @strncmp(ptr %x0, ptr %x1, i64 %a2)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_list_new(i64 %a0, i64 %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x1 = inttoptr i64 %a1 to ptr
%x2 = inttoptr i64 %a2 to ptr
%r = call ptr @resid_list_new(i64 %a0, ptr %x1, ptr %x2)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_list_len(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call i64 @resid_list_len(ptr %x0)
ret i64 %r
}
define internal i64 @c_list_to_array(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call ptr @resid_list_to_array(ptr %x0)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_list_get(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call ptr @resid_list_get(ptr %x0, i64 %a1)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_box_i64(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call ptr @resid_box_i64(i64 %a0)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_unbox_i64(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call i64 @resid_unbox_i64(ptr %x0)
ret i64 %r
}
define internal i64 @c_float_to_string(double %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call ptr @FloatToString(double %a0)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_fork() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i32 @fork()
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_execvp(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = inttoptr i64 %a1 to ptr
%r = call i32 @execvp(ptr %x0, ptr %x1)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_execv(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = inttoptr i64 %a1 to ptr
%r = call i32 @execv(ptr %x0, ptr %x1)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_popen(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = inttoptr i64 %a1 to ptr
%r = call ptr @popen(ptr %x0, ptr %x1)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_pclose(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call i32 @pclose(ptr %x0)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_fgets(i64 %a0, i64 %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = trunc i64 %a1 to i32
%x2 = inttoptr i64 %a2 to ptr
%r = call ptr @fgets(ptr %x0, i32 %x1, ptr %x2)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_pthread_create(i64 %a0, i64 %a1, i64 %a2, i64 %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = inttoptr i64 %a1 to ptr
%x2 = inttoptr i64 %a2 to ptr
%x3 = inttoptr i64 %a3 to ptr
%r = call i32 @pthread_create(ptr %x0, ptr %x1, ptr %x2, ptr %x3)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_pthread_join(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x1 = inttoptr i64 %a1 to ptr
%r = call i32 @pthread_join(i64 %a0, ptr %x1)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_pthread_attr_init(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call i32 @pthread_attr_init(ptr %x0)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_pthread_attr_setstacksize(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call i32 @pthread_attr_setstacksize(ptr %x0, i64 %a1)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_pthread_attr_destroy(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call i32 @pthread_attr_destroy(ptr %x0)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_strfromd(i64 %a0, i64 %a1, i64 %a2, double %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x2 = inttoptr i64 %a2 to ptr
%r = call i32 @strfromd(ptr %x0, i64 %a1, ptr %x2, double %a3)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_list_type(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call ptr @resid_list_type(ptr %x0)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_getaddrinfo(i64 %a0, i64 %a1, i64 %a2, i64 %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = inttoptr i64 %a1 to ptr
%x2 = inttoptr i64 %a2 to ptr
%x3 = inttoptr i64 %a3 to ptr
%r = call i32 @getaddrinfo(ptr %x0, ptr %x1, ptr %x2, ptr %x3)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_freeaddrinfo(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
call void @freeaddrinfo(ptr %x0)
ret i64 0
}
define internal i64 @c_libc_abort() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
call void @abort()
unreachable
}
define internal i64 @c_longjmp(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = trunc i64 %a1 to i32
call void @longjmp(ptr %x0, i32 %x1)
unreachable
}
define internal i64 @c_box_new(i64 %a0, i64 %a1, i64 %a2, i64 %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x2 = inttoptr i64 %a2 to ptr
%x3 = inttoptr i64 %a3 to ptr
%r = call ptr @resid_box_new(i64 %a0, i64 %a1, ptr %x2, ptr %x3)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_strchr(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = trunc i64 %a1 to i32
%r = call ptr @strchr(ptr %x0, i32 %x1)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_gmalloc(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call ptr @resid_gmalloc(i64 %a0)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_box_interned(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call i8 @resid_rt_box_interned(ptr %x0)
%rv = zext i8 %r to i64
ret i64 %rv
}
define internal i64 @c_box_f64(double %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call ptr @resid_box_f64(double %a0)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_box_bool(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = trunc i64 %a0 to i8
%r = call ptr @resid_box_bool(i8 %x0)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_sc_depth() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @resid_rt_sc_depth()
ret i64 %r
}
define internal i64 @c_sc_depth_set(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
call void @resid_rt_sc_depth_set(i64 %a0)
ret i64 0
}
define internal i64 @c_in_scope(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call i8 @resid_rt_in_scope(ptr %x0)
%rv = zext i8 %r to i64
ret i64 %rv
}
define internal i64 @c_scope_alloc(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call ptr @resid_rt_scope_alloc(i64 %a0)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_outer_alloc(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call ptr @resid_rt_outer_alloc(i64 %a0)
%rvi = ptrtoint ptr %r to i64
ret i64 %rvi
}
define internal i64 @c_suspend(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
call void @resid_rt_suspend(ptr %x0)
ret i64 0
}
define internal i64 @c_resume(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
call void @resid_rt_resume(ptr %x0)
ret i64 0
}
define internal i64 @c_in_arenas(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%r = call i8 @resid_rt_in_arenas(ptr %x0)
%rv = zext i8 %r to i64
ret i64 %rv
}
define internal i64 @c_malloc_trim(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i32 @malloc_trim(i64 %a0)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_pthread_key_create(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = inttoptr i64 %a1 to ptr
%r = call i32 @pthread_key_create(ptr %x0, ptr %x1)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_pthread_once(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
%x1 = inttoptr i64 %a1 to ptr
%r = call i32 @pthread_once(ptr %x0, ptr %x1)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @c_pthread_setspecific(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = trunc i64 %a0 to i32
%x1 = inttoptr i64 %a1 to ptr
%r = call i32 @pthread_setspecific(i32 %x0, ptr %x1)
%rv = sext i32 %r to i64
ret i64 %rv
}
define internal i64 @ld8(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4p = inttoptr i64 %p0 to ptr
%t4w = load i8, ptr %t4p, align 1
%t4 = zext i8 %t4w to i64
ret i64 %t4
}
define internal i64 @ld32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5p = inttoptr i64 %p0 to ptr
%t5w = load i32, ptr %t5p, align 1
%t5 = zext i32 %t5w to i64
ret i64 %t5
}
define internal i64 @ld64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6p = inttoptr i64 %p0 to ptr
%t6w = load i64, ptr %t6p, align 1
%t6 = add i64 %t6w, 0
ret i64 %t6
}
define internal i64 @st8(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7p = inttoptr i64 %p0 to ptr
%t7w = trunc i64 %p1 to i8
store i8 %t7w, ptr %t7p, align 1
%t7 = add i64 0, 0
ret i64 %t7
}
define internal i64 @st32(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8p = inttoptr i64 %p0 to ptr
%t8w = trunc i64 %p1 to i32
store i32 %t8w, ptr %t8p, align 1
%t8 = add i64 0, 0
ret i64 %t8
}
define internal i64 @st64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9p = inttoptr i64 %p0 to ptr
%t9w = add i64 %p1, 0
store i64 %t9w, ptr %t9p, align 1
%t9 = add i64 0, 0
ret i64 %t9
}
define internal i64 @mcopy(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10p = inttoptr i64 %p0 to ptr
%t10q = inttoptr i64 %p1 to ptr
call void @llvm.memmove.p0.p0.i64(ptr %t10p, ptr %t10q, i64 %p2, i1 false)
%t10 = add i64 0, 0
ret i64 %t10
}
define internal i64 @xmalloc(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11 = icmp sgt i64 %p0, 0
br i1 %t11, label %L1, label %L2
L1:
br label %L3
L2:
br label %L3
L3:
%t12 = phi i64 [ %p0, %L1 ], [ 1, %L2 ]
%t13 = call i64 @c_malloc(i64 %t12)
%t14 = icmp eq i64 %t13, 0
br i1 %t14, label %L4, label %L6
L4:
%t16 = call i64 @rt_abort(ptr @.s15)
ret i64 %t16
L6:
ret i64 %t13
}
define internal i64 @xrealloc(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t17 = icmp sgt i64 %p1, 0
br i1 %t17, label %L7, label %L8
L7:
br label %L9
L8:
br label %L9
L9:
%t18 = phi i64 [ %p1, %L7 ], [ 1, %L8 ]
%t19 = call i64 @c_realloc(i64 %p0, i64 %t18)
%t20 = icmp eq i64 %t19, 0
br i1 %t20, label %L10, label %L12
L10:
%t22 = call i64 @rt_abort(ptr @.s21)
ret i64 %t22
L12:
ret i64 %t19
}
define internal i64 @ralloc(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t23 = tail call i64 @rt_alloc(i64 %p0)
ret i64 %t23
}
define internal i64 @cstr_dup(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t24 = call i64 @c_strlen(i64 %p0)
%t25 = add i64 %t24, 1
%t26 = call i64 @xmalloc(i64 %t25)
%t27 = add i64 %t24, 1
%t28 = call i64 @mcopy(i64 %t26, i64 %p0, i64 %t27)
ret i64 %t26
}
define internal i64 @cstr_from(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t29 = icmp eq i64 %p2, 0
br i1 %t29, label %L13, label %L14
L13:
%t30 = add i64 %p1, 1
%t31 = call i64 @xmalloc(i64 %t30)
br label %L15
L14:
%t32 = add i64 %p1, 1
%t33 = call i64 @ralloc(i64 %t32)
br label %L15
L15:
%t34 = phi i64 [ %t31, %L13 ], [ %t33, %L14 ]
%t35 = call i64 @mcopy(i64 %t34, i64 %p0, i64 %p1)
%t36 = add i64 %t34, %p1
%t37 = call i64 @st8(i64 %t36, i64 0)
ret i64 %t34
}
define internal i64 @udiv(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t38 = icmp slt i64 %p1, 0
br i1 %t38, label %L16, label %L18
L16:
%t39 = call i1 @ult(i64 %p0, i64 %p1)
br i1 %t39, label %L19, label %L20
L19:
br label %L21
L20:
br label %L21
L21:
%t40 = phi i64 [ 0, %L19 ], [ 1, %L20 ]
ret i64 %t40
L18:
%t41 = icmp sge i64 %p0, 0
br i1 %t41, label %L22, label %L24
L22:
%t42 = icmp eq i64 %p1, 0
%t43 = zext i1 %t42 to i8
call void @resid_div_check(i8 %t43)
%t44 = icmp eq i64 %p1, -1
%t45 = icmp eq i64 %p0, -9223372036854775808
%t46 = and i1 %t44, %t45
%t49 = zext i1 %t46 to i8
call void @resid_overflow_check(i8 %t49)
%t47 = add i64 %p1, 0
%t48 = sdiv i64 %p0, %t47
ret i64 %t48
L24:
%t50 = ashr i64 %p0, 1
%t51 = and i64 %t50, 9223372036854775807
%t52 = icmp eq i64 %p1, 0
%t53 = zext i1 %t52 to i8
call void @resid_div_check(i8 %t53)
%t54 = icmp eq i64 %p1, -1
%t55 = icmp eq i64 %t51, -9223372036854775808
%t56 = and i1 %t54, %t55
%t59 = zext i1 %t56 to i8
call void @resid_overflow_check(i8 %t59)
%t57 = add i64 %p1, 0
%t58 = sdiv i64 %t51, %t57
%t60 = shl i64 %t58, 1
%t61 = mul i64 %t60, %p1
%t62 = sub i64 %p0, %t61
%t63 = call i1 @ult(i64 %t62, i64 %p1)
br i1 %t63, label %L25, label %L26
L25:
br label %L27
L26:
%t64 = add i64 %t60, 1
br label %L27
L27:
%t65 = phi i64 [ %t60, %L25 ], [ %t64, %L26 ]
ret i64 %t65
}
define internal i64 @urem(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t66 = call i64 @udiv(i64 %p0, i64 %p1)
%t67 = mul i64 %t66, %p1
%t68 = sub i64 %p0, %t67
ret i64 %t68
}
define internal i64 @lshr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t69 = icmp eq i64 %p1, 0
br i1 %t69, label %L28, label %L30
L28:
ret i64 %p0
L30:
%t70 = icmp uge i64 %p1, 64
%t71 = add i64 %p1, 0
%t72 = select i1 %t70, i64 63, i64 %t71
%t73 = ashr i64 %p0, %t72
%t74 = sub i64 %p1, 1
%t75 = zext i64 %t74 to i128
%t76 = icmp uge i128 %t75, 128
%t77 = add i128 %t75, 0
%t78 = select i1 %t76, i128 127, i128 %t77
%t79 = ashr i128 9223372036854775807, %t78
%t80 = sext i64 %t73 to i128
%t81 = and i128 %t80, %t79
%t82 = trunc i128 %t81 to i64
ret i64 %t82
}
define internal i1 @ult(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t83 = sext i64 0 to i128
%t84 = sub i128 %t83, 9223372036854775807
%t85 = sext i64 1 to i128
%t86 = sub i128 %t84, %t85
%t87 = trunc i128 %t86 to i64
%t88 = xor i64 %p0, %t87
%t89 = xor i64 %p1, %t87
%t90 = icmp slt i64 %t88, %t89
ret i1 %t90
}
define internal i1 @write_all(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %t97, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %t98, %tco.s1 ]
%t91 = icmp sle i64 %p2, 0
br i1 %t91, label %L31, label %L33
L31:
ret i1 true
L33:
%t92 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 1, i64 %p0, i64 %p1, i64 %p2, i64 0, i64 0, i64 0)
%t93 = sub nsw i64 0, 4
%t94 = icmp eq i64 %t92, %t93
br i1 %t94, label %L34, label %L36
L34:
br label %tco.s0
tco.s0:
br label %tco.head
L36:
%t96 = icmp sle i64 %t92, 0
br i1 %t96, label %L37, label %L39
L37:
ret i1 false
L39:
%t97 = add i64 %p1, %t92
%t98 = sub nsw i64 %p2, %t92
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i1 @write_cstr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t100 = call i64 @c_strlen(i64 %p1)
%t101 = call i1 @write_all(i64 %p0, i64 %p1, i64 %t100)
ret i1 %t101
}
define internal i1 @write_nl(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t103 = ptrtoint ptr @.s102 to i64
%t104 = call i1 @write_all(i64 %p0, i64 %t103, i64 1)
ret i1 %t104
}
define internal i1 @rt_print(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t105 = call i1 @write_cstr(i64 1, i64 %p0)
ret i1 %t105
}
define i1 @print(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i1 @rt_print(i64 %x0i)
ret i1 %r
}
define internal i1 @write_line(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t106p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.iov)
%t106 = ptrtoint ptr %t106p to i64
%t107 = call i64 @st64(i64 %t106, i64 %p1)
%t108 = add i64 %t106, 8
%t109 = call i64 @st64(i64 %t108, i64 %p2)
%t110 = add i64 %t106, 16
%t112 = ptrtoint ptr @.s111 to i64
%t113 = call i64 @st64(i64 %t110, i64 %t112)
%t114 = add i64 %t106, 24
%t115 = call i64 @st64(i64 %t114, i64 1)
%t116 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 20, i64 %p0, i64 %t106, i64 2, i64 0, i64 0, i64 0)
%t117 = add i64 %p2, 1
%t118 = icmp eq i64 %t116, %t117
br i1 %t118, label %L40, label %L42
L40:
ret i1 true
L42:
%t119 = icmp slt i64 %t116, 0
br label %LSL120
LSL120:
br i1 %t119, label %LSR120, label %LSJ120
LSR120:
%t121 = sub nsw i64 0, 4
%t122 = icmp ne i64 %t116, %t121
br label %LSJ120
LSJ120:
%t123 = phi i1 [ false, %LSL120 ], [ %t122, %LSR120 ]
br i1 %t123, label %L43, label %L45
L43:
ret i1 false
L45:
%t124 = icmp slt i64 %t116, 0
br i1 %t124, label %L46, label %L47
L46:
br label %L48
L47:
br label %L48
L48:
%t125 = phi i64 [ 0, %L46 ], [ %t116, %L47 ]
%t126 = icmp sge i64 %t125, %p2
br i1 %t126, label %L49, label %L51
L49:
%t127 = call i1 @write_nl(i64 %p0)
ret i1 %t127
L51:
%t128 = add i64 %p1, %t125
%t129 = sub i64 %p2, %t125
%t130 = call i1 @write_all(i64 %p0, i64 %t128, i64 %t129)
br label %LSL131
LSL131:
br i1 %t130, label %LSR131, label %LSJ131
LSR131:
%t132 = call i1 @write_nl(i64 %p0)
br label %LSJ131
LSJ131:
%t133 = phi i1 [ false, %LSL131 ], [ %t132, %LSR131 ]
ret i1 %t133
}
define internal i1 @rt_println(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t134 = call i64 @c_strlen(i64 %p0)
%t135 = call i1 @write_line(i64 1, i64 %p0, i64 %t134)
ret i1 %t135
}
define i1 @println(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i1 @rt_println(i64 %x0i)
ret i1 %r
}
define internal i1 @rt_eprintln(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t136 = call i64 @c_strlen(i64 %p0)
%t137 = call i1 @write_line(i64 2, i64 %p0, i64 %t136)
ret i1 %t137
}
define i1 @eprintln(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i1 @rt_eprintln(i64 %x0i)
ret i1 %r
}
define internal i64 @__mruntime_rt_io_resid__flags() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t138p = getelementptr i8, ptr @rtg.rt_flags, i64 0
%t138 = ptrtoint ptr %t138p to i64
ret i64 %t138
}
define internal i64 @rt_quiet_set(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t139 = call i64 @__mruntime_rt_io_resid__flags()
%t140 = call i64 @st64(i64 %t139, i64 %p0)
%t141 = add i64 %t140, 1
ret i64 %t141
}
define i8 @resid_quiet_set(i1 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = zext i1 %a0 to i64
%r = call i64 @rt_quiet_set(i64 %x0)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_quiet() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t142 = call i64 @__mruntime_rt_io_resid__flags()
%t143 = call i64 @ld64(i64 %t142)
ret i64 %t143
}
define i8 @resid_quiet() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_quiet()
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_internals_set(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t144 = call i64 @__mruntime_rt_io_resid__flags()
%t145 = add i64 %t144, 8
%t146 = call i64 @st64(i64 %t145, i64 %p0)
%t147 = add i64 %t146, 1
ret i64 %t147
}
define i8 @resid_internals_set(i1 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = zext i1 %a0 to i64
%r = call i64 @rt_internals_set(i64 %x0)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_internals() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t148 = call i64 @__mruntime_rt_io_resid__flags()
%t149 = add i64 %t148, 8
%t150 = call i64 @ld64(i64 %t149)
ret i64 %t150
}
define i8 @resid_internals() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_internals()
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_rtmod_set(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t151 = call i64 @__mruntime_rt_io_resid__flags()
%t152 = add i64 %t151, 16
%t153 = call i64 @st64(i64 %t152, i64 %p0)
%t154 = add i64 %t153, 1
ret i64 %t154
}
define i8 @resid_rtmod_set(i1 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = zext i1 %a0 to i64
%r = call i64 @rt_rtmod_set(i64 %x0)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_rtmod() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t155 = call i64 @__mruntime_rt_io_resid__flags()
%t156 = add i64 %t155, 16
%t157 = call i64 @ld64(i64 %t156)
ret i64 %t157
}
define i8 @resid_rtmod() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_rtmod()
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_overflow_check(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t158 = icmp ne i64 %p0, 0
br i1 %t158, label %L52, label %L54
L52:
%t160 = call i64 @rt_abort(ptr @.s159)
ret i64 %t160
L54:
ret i64 0
}
define void @resid_overflow_check(i8 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = zext i8 %a0 to i64
%r = call i64 @rt_overflow_check(i64 %x0)
ret void
}
define internal i64 @rt_div_check(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t161 = icmp ne i64 %p0, 0
br i1 %t161, label %L55, label %L57
L55:
%t163 = call i64 @rt_abort(ptr @.s162)
ret i64 %t163
L57:
ret i64 0
}
define void @resid_div_check(i8 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = zext i8 %a0 to i64
%r = call i64 @rt_div_check(i64 %x0)
ret void
}
define internal i64 @rt_conv_check(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t164 = icmp ne i64 %p0, 0
br i1 %t164, label %L58, label %L60
L58:
%t166 = call i64 @rt_abort(ptr @.s165)
ret i64 %t166
L60:
ret i64 0
}
define void @resid_conv_check(i8 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = zext i8 %a0 to i64
%r = call i64 @rt_conv_check(i64 %x0)
ret void
}
define internal i64 @__mruntime_rt_arith_resid__imax() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t167 = trunc i128 9223372036854775807 to i64
ret i64 %t167
}
define internal i64 @__mruntime_rt_arith_resid__imin() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t168 = sext i64 0 to i128
%t169 = sub i128 %t168, 9223372036854775807
%t170 = sext i64 1 to i128
%t171 = sub i128 %t169, %t170
%t172 = trunc i128 %t171 to i64
ret i64 %t172
}
define internal i64 @rt_wrapping_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t173 = add i64 %p0, %p1
ret i64 %t173
}
define i64 @wrapping_add(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_add(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_wrapping_sub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t174 = sub i64 %p0, %p1
ret i64 %t174
}
define i64 @wrapping_sub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_sub(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_wrapping_mul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t175 = mul i64 %p0, %p1
ret i64 %t175
}
define i64 @wrapping_mul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_mul(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_wrapping_div(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t176 = icmp eq i64 %p1, 0
br i1 %t176, label %L61, label %L63
L61:
%t178 = call i64 @rt_abort(ptr @.s177)
ret i64 %t178
L63:
%t179 = sub nsw i64 0, 1
%t180 = icmp eq i64 %p1, %t179
br i1 %t180, label %L64, label %L66
L64:
%t181 = sub i64 0, %p0
ret i64 %t181
L66:
%t182 = icmp eq i64 %p1, 0
%t183 = zext i1 %t182 to i8
call void @resid_div_check(i8 %t183)
%t184 = icmp eq i64 %p1, -1
%t185 = icmp eq i64 %p0, -9223372036854775808
%t186 = and i1 %t184, %t185
%t189 = zext i1 %t186 to i8
call void @resid_overflow_check(i8 %t189)
%t187 = add i64 %p1, 0
%t188 = sdiv i64 %p0, %t187
ret i64 %t188
}
define i64 @wrapping_div(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_div(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_wrapping_uadd(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t190 = add i64 %p0, %p1
ret i64 %t190
}
define i64 @wrapping_uadd(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_uadd(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_wrapping_usub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t191 = sub i64 %p0, %p1
ret i64 %t191
}
define i64 @wrapping_usub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_usub(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_wrapping_umul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t192 = mul i64 %p0, %p1
ret i64 %t192
}
define i64 @wrapping_umul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_umul(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_wrapping_udiv(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t193 = icmp eq i64 %p1, 0
br i1 %t193, label %L67, label %L69
L67:
%t195 = call i64 @rt_abort(ptr @.s194)
ret i64 %t195
L69:
%t196 = tail call i64 @__mruntime_rt_arith_resid__rt_udiv(i64 %p0, i64 %p1)
ret i64 %t196
}
define i64 @wrapping_udiv(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_udiv(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @__mruntime_rt_arith_resid__rt_udiv(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t197 = tail call i64 @udiv(i64 %p0, i64 %p1)
ret i64 %t197
}
define internal i1 @__mruntime_rt_arith_resid__rt_ult(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t198 = tail call i1 @ult(i64 %p0, i64 %p1)
ret i1 %t198
}
define internal i64 @rt_saturating_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t199 = icmp sgt i64 %p1, 0
br label %LSL200
LSL200:
br i1 %t199, label %LSR200, label %LSJ200
LSR200:
%t201 = call i64 @__mruntime_rt_arith_resid__imax()
%t202 = sub i64 %t201, %p1
%t203 = icmp sgt i64 %p0, %t202
br label %LSJ200
LSJ200:
%t204 = phi i1 [ false, %LSL200 ], [ %t203, %LSR200 ]
br i1 %t204, label %L70, label %L72
L70:
%t205 = call i64 @__mruntime_rt_arith_resid__imax()
ret i64 %t205
L72:
%t206 = icmp slt i64 %p1, 0
br label %LSL207
LSL207:
br i1 %t206, label %LSR207, label %LSJ207
LSR207:
%t208 = call i64 @__mruntime_rt_arith_resid__imin()
%t209 = sub i64 %t208, %p1
%t210 = icmp slt i64 %p0, %t209
br label %LSJ207
LSJ207:
%t211 = phi i1 [ false, %LSL207 ], [ %t210, %LSR207 ]
br i1 %t211, label %L73, label %L75
L73:
%t212 = call i64 @__mruntime_rt_arith_resid__imin()
ret i64 %t212
L75:
%t213 = add i64 %p0, %p1
ret i64 %t213
}
define i64 @saturating_add(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_add(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_saturating_sub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t214 = icmp slt i64 %p1, 0
br label %LSL215
LSL215:
br i1 %t214, label %LSR215, label %LSJ215
LSR215:
%t216 = call i64 @__mruntime_rt_arith_resid__imax()
%t217 = add i64 %t216, %p1
%t218 = icmp sgt i64 %p0, %t217
br label %LSJ215
LSJ215:
%t219 = phi i1 [ false, %LSL215 ], [ %t218, %LSR215 ]
br i1 %t219, label %L76, label %L78
L76:
%t220 = call i64 @__mruntime_rt_arith_resid__imax()
ret i64 %t220
L78:
%t221 = icmp sgt i64 %p1, 0
br label %LSL222
LSL222:
br i1 %t221, label %LSR222, label %LSJ222
LSR222:
%t223 = call i64 @__mruntime_rt_arith_resid__imin()
%t224 = add i64 %t223, %p1
%t225 = icmp slt i64 %p0, %t224
br label %LSJ222
LSJ222:
%t226 = phi i1 [ false, %LSL222 ], [ %t225, %LSR222 ]
br i1 %t226, label %L79, label %L81
L79:
%t227 = call i64 @__mruntime_rt_arith_resid__imin()
ret i64 %t227
L81:
%t228 = sub i64 %p0, %p1
ret i64 %t228
}
define i64 @saturating_sub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_sub(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_saturating_mul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t229 = mul i64 %p0, %p1
%t230 = icmp ne i64 %p0, 0
br label %LSL231
LSL231:
br i1 %t230, label %LSR231, label %LSJ231
LSR231:
%t232 = icmp eq i64 %p0, 0
%t233 = zext i1 %t232 to i8
call void @resid_div_check(i8 %t233)
%t234 = icmp eq i64 %p0, -1
%t235 = icmp eq i64 %t229, -9223372036854775808
%t236 = and i1 %t234, %t235
%t239 = zext i1 %t236 to i8
call void @resid_overflow_check(i8 %t239)
%t237 = add i64 %p0, 0
%t238 = sdiv i64 %t229, %t237
%t240 = icmp ne i64 %t238, %p1
br label %LSL241
LSL241:
br i1 %t240, label %LSJ241, label %LSR241
LSR241:
%t242 = sub nsw i64 0, 1
%t243 = icmp eq i64 %p0, %t242
br label %LSL244
LSL244:
br i1 %t243, label %LSR244, label %LSJ244
LSR244:
%t245 = call i64 @__mruntime_rt_arith_resid__imin()
%t246 = icmp eq i64 %p1, %t245
br label %LSJ244
LSJ244:
%t247 = phi i1 [ false, %LSL244 ], [ %t246, %LSR244 ]
br label %LSJ241
LSJ241:
%t248 = phi i1 [ true, %LSL241 ], [ %t247, %LSJ244 ]
br label %LSJ231
LSJ231:
%t249 = phi i1 [ false, %LSL231 ], [ %t248, %LSJ241 ]
br label %LSL250
LSL250:
br i1 %t249, label %LSJ250, label %LSR250
LSR250:
%t251 = sub nsw i64 0, 1
%t252 = icmp eq i64 %p1, %t251
br label %LSL253
LSL253:
br i1 %t252, label %LSR253, label %LSJ253
LSR253:
%t254 = call i64 @__mruntime_rt_arith_resid__imin()
%t255 = icmp eq i64 %p0, %t254
br label %LSJ253
LSJ253:
%t256 = phi i1 [ false, %LSL253 ], [ %t255, %LSR253 ]
br label %LSJ250
LSJ250:
%t257 = phi i1 [ true, %LSL250 ], [ %t256, %LSJ253 ]
%t258 = xor i1 %t257, true
br i1 %t258, label %L82, label %L84
L82:
ret i64 %t229
L84:
%t259 = icmp sgt i64 %p0, 0
%t260 = icmp sgt i64 %p1, 0
%t261 = icmp eq i1 %t259, %t260
br i1 %t261, label %L85, label %L86
L85:
%t262 = call i64 @__mruntime_rt_arith_resid__imax()
br label %L87
L86:
%t263 = call i64 @__mruntime_rt_arith_resid__imin()
br label %L87
L87:
%t264 = phi i64 [ %t262, %L85 ], [ %t263, %L86 ]
ret i64 %t264
}
define i64 @saturating_mul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_mul(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_saturating_uadd(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t265 = add i64 %p0, %p1
%t266 = call i1 @__mruntime_rt_arith_resid__rt_ult(i64 %t265, i64 %p0)
br i1 %t266, label %L88, label %L89
L88:
%t267 = sub nsw i64 0, 1
br label %L90
L89:
br label %L90
L90:
%t268 = phi i64 [ %t267, %L88 ], [ %t265, %L89 ]
ret i64 %t268
}
define i64 @saturating_uadd(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_uadd(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_saturating_usub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t269 = call i1 @__mruntime_rt_arith_resid__rt_ult(i64 %p0, i64 %p1)
br i1 %t269, label %L91, label %L92
L91:
br label %L93
L92:
%t270 = sub i64 %p0, %p1
br label %L93
L93:
%t271 = phi i64 [ 0, %L91 ], [ %t270, %L92 ]
ret i64 %t271
}
define i64 @saturating_usub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_usub(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_saturating_umul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t272 = icmp eq i64 %p0, 0
br label %LSL273
LSL273:
br i1 %t272, label %LSJ273, label %LSR273
LSR273:
%t274 = icmp eq i64 %p1, 0
br label %LSJ273
LSJ273:
%t275 = phi i1 [ true, %LSL273 ], [ %t274, %LSR273 ]
br i1 %t275, label %L94, label %L96
L94:
ret i64 0
L96:
%t276 = mul i64 %p0, %p1
%t277 = call i64 @__mruntime_rt_arith_resid__rt_udiv(i64 %t276, i64 %p0)
%t278 = icmp ne i64 %t277, %p1
br i1 %t278, label %L97, label %L98
L97:
%t279 = sub nsw i64 0, 1
br label %L99
L98:
br label %L99
L99:
%t280 = phi i64 [ %t279, %L97 ], [ %t276, %L98 ]
ret i64 %t280
}
define i64 @saturating_umul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_umul(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t281 = add i64 %p0, %p1
ret i64 %t281
}
define i64 @checked_add(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_add(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_sub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t282 = sub i64 %p0, %p1
ret i64 %t282
}
define i64 @checked_sub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_sub(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_mul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t283 = mul i64 %p0, %p1
ret i64 %t283
}
define i64 @checked_mul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_mul(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_div(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t284 = icmp eq i64 %p1, 0
br i1 %t284, label %L100, label %L102
L100:
%t286 = call i64 @rt_abort(ptr @.s285)
ret i64 %t286
L102:
%t287 = icmp eq i64 %p1, 0
%t288 = zext i1 %t287 to i8
call void @resid_div_check(i8 %t288)
%t289 = icmp eq i64 %p1, -1
%t290 = icmp eq i64 %p0, -9223372036854775808
%t291 = and i1 %t289, %t290
%t294 = zext i1 %t291 to i8
call void @resid_overflow_check(i8 %t294)
%t292 = add i64 %p1, 0
%t293 = sdiv i64 %p0, %t292
ret i64 %t293
}
define i64 @checked_div(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_div(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_uadd(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t295 = add i64 %p0, %p1
ret i64 %t295
}
define i64 @checked_uadd(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_uadd(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_usub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t296 = sub i64 %p0, %p1
ret i64 %t296
}
define i64 @checked_usub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_usub(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_umul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t297 = mul i64 %p0, %p1
ret i64 %t297
}
define i64 @checked_umul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_umul(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_udiv(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t298 = icmp eq i64 %p1, 0
br i1 %t298, label %L103, label %L105
L103:
%t300 = call i64 @rt_abort(ptr @.s299)
ret i64 %t300
L105:
%t301 = tail call i64 @__mruntime_rt_arith_resid__rt_udiv(i64 %p0, i64 %p1)
ret i64 %t301
}
define i64 @checked_udiv(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_udiv(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_abs_i64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t302 = icmp slt i64 %p0, 0
br i1 %t302, label %L106, label %L107
L106:
%t303 = sub i64 0, %p0
br label %L108
L107:
br label %L108
L108:
%t304 = phi i64 [ %t303, %L106 ], [ %p0, %L107 ]
ret i64 %t304
}
define i64 @abs_i64(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_abs_i64(i64 %a0)
ret i64 %r
}
define internal i64 @rt_min_i64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t305 = icmp slt i64 %p0, %p1
br i1 %t305, label %L109, label %L110
L109:
br label %L111
L110:
br label %L111
L111:
%t306 = phi i64 [ %p0, %L109 ], [ %p1, %L110 ]
ret i64 %t306
}
define i64 @min_i64(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_min_i64(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_max_i64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t307 = icmp sgt i64 %p0, %p1
br i1 %t307, label %L112, label %L113
L112:
br label %L114
L113:
br label %L114
L114:
%t308 = phi i64 [ %p0, %L112 ], [ %p1, %L113 ]
ret i64 %t308
}
define i64 @max_i64(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_max_i64(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_clamp_i64(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t309 = icmp slt i64 %p0, %p1
br i1 %t309, label %L115, label %L117
L115:
ret i64 %p1
L117:
%t310 = icmp sgt i64 %p0, %p2
br i1 %t310, label %L118, label %L120
L118:
ret i64 %p2
L120:
ret i64 %p0
}
define i64 @clamp_i64(i64 %a0, i64 %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_clamp_i64(i64 %a0, i64 %a1, i64 %a2)
ret i64 %r
}
define internal i1 @__mruntime_rt_regex_resid__rx_class(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t311 = add i64 %p0, 1
%t312 = call i64 @ld8(i64 %t311)
%t313 = icmp eq i64 %t312, 94
br i1 %t313, label %L121, label %L122
L121:
%t314 = add i64 %p0, 2
br label %L123
L122:
%t315 = add i64 %p0, 1
br label %L123
L123:
%t316 = phi i64 [ %t314, %L121 ], [ %t315, %L122 ]
%t317 = call i1 @__mruntime_rt_regex_resid__rx_class_at(i64 %t316, i64 %p1, i1 false)
%t318 = icmp ne i1 %t317, %t313
ret i1 %t318
}
define internal i1 @__mruntime_rt_regex_resid__rx_class_at(i64 %p0.in, i64 %p1.in, i1 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t337, %tco.s0 ], [ %t345, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i1 [ %p2.in, %entry ], [ %t343, %tco.s0 ], [ %t348, %tco.s1 ]
%t319 = call i64 @ld8(i64 %p0)
%t320 = icmp eq i64 %t319, 0
br label %LSL321
LSL321:
br i1 %t320, label %LSJ321, label %LSR321
LSR321:
%t322 = icmp eq i64 %t319, 93
br label %LSJ321
LSJ321:
%t323 = phi i1 [ true, %LSL321 ], [ %t322, %LSR321 ]
br i1 %t323, label %L124, label %L126
L124:
ret i1 %p2
L126:
%t324 = add i64 %p0, 1
%t325 = call i64 @ld8(i64 %t324)
%t326 = icmp eq i64 %t325, 0
br i1 %t326, label %L127, label %L128
L127:
br label %L129
L128:
%t327 = add i64 %p0, 2
%t328 = call i64 @ld8(i64 %t327)
br label %L129
L129:
%t329 = phi i64 [ 0, %L127 ], [ %t328, %L128 ]
%t330 = icmp eq i64 %t325, 45
br label %LSL331
LSL331:
br i1 %t330, label %LSR331, label %LSJ331
LSR331:
%t332 = icmp ne i64 %t329, 0
br label %LSJ331
LSJ331:
%t333 = phi i1 [ false, %LSL331 ], [ %t332, %LSR331 ]
br label %LSL334
LSL334:
br i1 %t333, label %LSR334, label %LSJ334
LSR334:
%t335 = icmp ne i64 %t329, 93
br label %LSJ334
LSJ334:
%t336 = phi i1 [ false, %LSL334 ], [ %t335, %LSR334 ]
br i1 %t336, label %L130, label %L132
L130:
%t337 = add i64 %p0, 3
br label %LSL338
LSL338:
br i1 %p2, label %LSJ338, label %LSR338
LSR338:
%t339 = icmp sge i64 %p1, %t319
br label %LSL340
LSL340:
br i1 %t339, label %LSR340, label %LSJ340
LSR340:
%t341 = icmp sle i64 %p1, %t329
br label %LSJ340
LSJ340:
%t342 = phi i1 [ false, %LSL340 ], [ %t341, %LSR340 ]
br label %LSJ338
LSJ338:
%t343 = phi i1 [ true, %LSL338 ], [ %t342, %LSJ340 ]
br label %tco.s0
tco.s0:
br label %tco.head
L132:
%t345 = add i64 %p0, 1
br label %LSL346
LSL346:
br i1 %p2, label %LSJ346, label %LSR346
LSR346:
%t347 = icmp eq i64 %t319, %p1
br label %LSJ346
LSJ346:
%t348 = phi i1 [ true, %LSL346 ], [ %t347, %LSR346 ]
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @__mruntime_rt_regex_resid__rx_atom_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t350 = call i64 @ld8(i64 %p0)
%t351 = icmp eq i64 %t350, 91
br i1 %t351, label %L133, label %L135
L133:
%t352 = add i64 %p0, 1
%t353 = call i64 @ld8(i64 %t352)
%t354 = icmp eq i64 %t353, 94
br i1 %t354, label %L136, label %L137
L136:
%t355 = add i64 %t352, 1
br label %L138
L137:
br label %L138
L138:
%t356 = phi i64 [ %t355, %L136 ], [ %t352, %L137 ]
%t357 = call i64 @ld8(i64 %t356)
%t358 = icmp eq i64 %t357, 93
br i1 %t358, label %L139, label %L140
L139:
%t359 = add i64 %t356, 1
br label %L141
L140:
br label %L141
L141:
%t360 = phi i64 [ %t359, %L139 ], [ %t356, %L140 ]
%t361 = call i64 @__mruntime_rt_regex_resid__rx_to_close(i64 %t360)
%t362 = call i64 @ld8(i64 %t361)
%t363 = icmp eq i64 %t362, 93
br i1 %t363, label %L142, label %L143
L142:
%t364 = add i64 %t361, 1
%t365 = sub i64 %t364, %p0
br label %L144
L143:
%t366 = sub i64 %t361, %p0
br label %L144
L144:
%t367 = phi i64 [ %t365, %L142 ], [ %t366, %L143 ]
ret i64 %t367
L135:
%t368 = icmp eq i64 %t350, 92
br label %LSL369
LSL369:
br i1 %t368, label %LSR369, label %LSJ369
LSR369:
%t370 = add i64 %p0, 1
%t371 = call i64 @ld8(i64 %t370)
%t372 = icmp ne i64 %t371, 0
br label %LSJ369
LSJ369:
%t373 = phi i1 [ false, %LSL369 ], [ %t372, %LSR369 ]
br i1 %t373, label %L145, label %L147
L145:
ret i64 2
L147:
ret i64 1
}
define internal i64 @__mruntime_rt_regex_resid__rx_to_close(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t379, %tco.s0 ]
%t374 = call i64 @ld8(i64 %p0)
%t375 = icmp eq i64 %t374, 0
br label %LSL376
LSL376:
br i1 %t375, label %LSJ376, label %LSR376
LSR376:
%t377 = icmp eq i64 %t374, 93
br label %LSJ376
LSJ376:
%t378 = phi i1 [ true, %LSL376 ], [ %t377, %LSR376 ]
br i1 %t378, label %L148, label %L150
L148:
ret i64 %p0
L150:
%t379 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_regex_resid__rx_one(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t381 = call i64 @ld8(i64 %p0)
%t382 = icmp eq i64 %t381, 91
br i1 %t382, label %L151, label %L153
L151:
%t383 = tail call i1 @__mruntime_rt_regex_resid__rx_class(i64 %p0, i64 %p1)
ret i1 %t383
L153:
%t384 = icmp eq i64 %t381, 92
br label %LSL385
LSL385:
br i1 %t384, label %LSR385, label %LSJ385
LSR385:
%t386 = add i64 %p0, 1
%t387 = call i64 @ld8(i64 %t386)
%t388 = icmp ne i64 %t387, 0
br label %LSJ385
LSJ385:
%t389 = phi i1 [ false, %LSL385 ], [ %t388, %LSR385 ]
br i1 %t389, label %L154, label %L156
L154:
%t390 = add i64 %p0, 1
%t391 = call i64 @ld8(i64 %t390)
%t392 = icmp eq i64 %t391, %p1
ret i1 %t392
L156:
%t393 = icmp eq i64 %t381, 46
br i1 %t393, label %L157, label %L159
L157:
%t394 = icmp ne i64 %p1, 0
ret i1 %t394
L159:
%t395 = icmp eq i64 %t381, %p1
ret i1 %t395
}
define internal i1 @__mruntime_rt_regex_resid__rx_star(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t403, %tco.s0 ]
%t396 = call i1 @__mruntime_rt_regex_resid__rx_here(i64 %p1, i64 %p2)
br i1 %t396, label %L160, label %L162
L160:
ret i1 true
L162:
%t397 = call i64 @ld8(i64 %p2)
%t398 = icmp eq i64 %t397, 0
br label %LSL399
LSL399:
br i1 %t398, label %LSJ399, label %LSR399
LSR399:
%t400 = call i1 @__mruntime_rt_regex_resid__rx_one(i64 %p0, i64 %t397)
%t401 = xor i1 %t400, true
br label %LSJ399
LSJ399:
%t402 = phi i1 [ true, %LSL399 ], [ %t401, %LSR399 ]
br i1 %t402, label %L163, label %L165
L163:
ret i1 false
L165:
%t403 = add i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_regex_resid__rx_rep(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t405 = call i64 @ld8(i64 %p3)
%t406 = icmp eq i64 %p1, 63
br i1 %t406, label %L166, label %L168
L166:
%t407 = call i1 @__mruntime_rt_regex_resid__rx_here(i64 %p2, i64 %p3)
br i1 %t407, label %L169, label %L171
L169:
ret i1 true
L171:
%t408 = icmp ne i64 %t405, 0
br label %LSL409
LSL409:
br i1 %t408, label %LSR409, label %LSJ409
LSR409:
%t410 = call i1 @__mruntime_rt_regex_resid__rx_one(i64 %p0, i64 %t405)
br label %LSJ409
LSJ409:
%t411 = phi i1 [ false, %LSL409 ], [ %t410, %LSR409 ]
br label %LSL412
LSL412:
br i1 %t411, label %LSR412, label %LSJ412
LSR412:
%t413 = add i64 %p3, 1
%t414 = call i1 @__mruntime_rt_regex_resid__rx_here(i64 %p2, i64 %t413)
br label %LSJ412
LSJ412:
%t415 = phi i1 [ false, %LSL412 ], [ %t414, %LSR412 ]
ret i1 %t415
L168:
%t416 = icmp eq i64 %p1, 43
br i1 %t416, label %L172, label %L174
L172:
%t417 = icmp eq i64 %t405, 0
br label %LSL418
LSL418:
br i1 %t417, label %LSJ418, label %LSR418
LSR418:
%t419 = call i1 @__mruntime_rt_regex_resid__rx_one(i64 %p0, i64 %t405)
%t420 = xor i1 %t419, true
br label %LSJ418
LSJ418:
%t421 = phi i1 [ true, %LSL418 ], [ %t420, %LSR418 ]
br i1 %t421, label %L175, label %L177
L175:
ret i1 false
L177:
%t422 = add i64 %p3, 1
%t423 = call i1 @__mruntime_rt_regex_resid__rx_star(i64 %p0, i64 %p2, i64 %t422)
ret i1 %t423
L174:
%t424 = call i1 @__mruntime_rt_regex_resid__rx_star(i64 %p0, i64 %p2, i64 %p3)
ret i1 %t424
}
define internal i1 @__mruntime_rt_regex_resid__rx_here(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t425 = call i64 @ld8(i64 %p0)
%t426 = icmp eq i64 %t425, 0
br i1 %t426, label %L178, label %L180
L178:
ret i1 true
L180:
%t427 = icmp eq i64 %t425, 36
br label %LSL428
LSL428:
br i1 %t427, label %LSR428, label %LSJ428
LSR428:
%t429 = add i64 %p0, 1
%t430 = call i64 @ld8(i64 %t429)
%t431 = icmp eq i64 %t430, 0
br label %LSJ428
LSJ428:
%t432 = phi i1 [ false, %LSL428 ], [ %t431, %LSR428 ]
br i1 %t432, label %L181, label %L183
L181:
%t433 = call i64 @ld8(i64 %p1)
%t434 = icmp eq i64 %t433, 0
ret i1 %t434
L183:
%t435 = call i64 @__mruntime_rt_regex_resid__rx_atom_len(i64 %p0)
%t436 = add i64 %p0, %t435
%t437 = call i64 @ld8(i64 %t436)
%t438 = icmp eq i64 %t437, 42
br label %LSL439
LSL439:
br i1 %t438, label %LSJ439, label %LSR439
LSR439:
%t440 = icmp eq i64 %t437, 43
br label %LSJ439
LSJ439:
%t441 = phi i1 [ true, %LSL439 ], [ %t440, %LSR439 ]
br label %LSL442
LSL442:
br i1 %t441, label %LSJ442, label %LSR442
LSR442:
%t443 = icmp eq i64 %t437, 63
br label %LSJ442
LSJ442:
%t444 = phi i1 [ true, %LSL442 ], [ %t443, %LSR442 ]
br i1 %t444, label %L184, label %L186
L184:
%t445 = add i64 %p0, %t435
%t446 = add i64 %t445, 1
%t447 = call i1 @__mruntime_rt_regex_resid__rx_rep(i64 %p0, i64 %t437, i64 %t446, i64 %p1)
ret i1 %t447
L186:
%t448 = call i64 @ld8(i64 %p1)
%t449 = icmp ne i64 %t448, 0
br label %LSL450
LSL450:
br i1 %t449, label %LSR450, label %LSJ450
LSR450:
%t451 = call i1 @__mruntime_rt_regex_resid__rx_one(i64 %p0, i64 %t448)
br label %LSJ450
LSJ450:
%t452 = phi i1 [ false, %LSL450 ], [ %t451, %LSR450 ]
br label %LSL453
LSL453:
br i1 %t452, label %LSR453, label %LSJ453
LSR453:
%t454 = add i64 %p0, %t435
%t455 = add i64 %p1, 1
%t456 = call i1 @__mruntime_rt_regex_resid__rx_here(i64 %t454, i64 %t455)
br label %LSJ453
LSJ453:
%t457 = phi i1 [ false, %LSL453 ], [ %t456, %LSR453 ]
ret i1 %t457
}
define internal i1 @__mruntime_rt_regex_resid__rx_search(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t461, %tco.s0 ]
%t458 = call i1 @__mruntime_rt_regex_resid__rx_here(i64 %p0, i64 %p1)
br i1 %t458, label %L187, label %L189
L187:
ret i1 true
L189:
%t459 = call i64 @ld8(i64 %p1)
%t460 = icmp eq i64 %t459, 0
br i1 %t460, label %L190, label %L192
L190:
ret i1 false
L192:
%t461 = add i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_regex_match(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t463 = icmp eq i64 %p0, 0
br label %LSL464
LSL464:
br i1 %t463, label %LSJ464, label %LSR464
LSR464:
%t465 = icmp eq i64 %p1, 0
br label %LSJ464
LSJ464:
%t466 = phi i1 [ true, %LSL464 ], [ %t465, %LSR464 ]
br i1 %t466, label %L193, label %L195
L193:
ret i64 0
L195:
%t467 = call i64 @ld8(i64 %p0)
%t468 = icmp eq i64 %t467, 94
br i1 %t468, label %L196, label %L197
L196:
%t469 = add i64 %p0, 1
%t470 = call i1 @__mruntime_rt_regex_resid__rx_here(i64 %t469, i64 %p1)
br label %L198
L197:
%t471 = call i1 @__mruntime_rt_regex_resid__rx_search(i64 %p0, i64 %p1)
br label %L198
L198:
%t472 = phi i1 [ %t470, %L196 ], [ %t471, %L197 ]
br i1 %t472, label %L199, label %L200
L199:
br label %L201
L200:
br label %L201
L201:
%t473 = phi i64 [ 1, %L199 ], [ 0, %L200 ]
ret i64 %t473
}
define i8 @resid_regex_match(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_regex_match(i64 %x0i, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @__mruntime_rt_caps_resid__cap_max_depth() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 32
}
define internal i64 @__mruntime_rt_caps_resid__cap_max_set() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 64
}
define internal i64 @__mruntime_rt_caps_resid__cap_stack() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t474p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.cap_stack)
%t474 = ptrtoint ptr %t474p to i64
ret i64 %t474
}
define internal i64 @__mruntime_rt_caps_resid__cap_ns() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t475p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.cap_ns)
%t475 = ptrtoint ptr %t475p to i64
ret i64 %t475
}
define internal i64 @__mruntime_rt_caps_resid__cap_depth_at() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t476p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.cap_depth)
%t476 = ptrtoint ptr %t476p to i64
ret i64 %t476
}
define internal i64 @rt_cap_enter(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t477 = call i64 @__mruntime_rt_caps_resid__cap_depth_at()
%t478 = call i64 @ld64(i64 %t477)
%t479 = call i64 @__mruntime_rt_caps_resid__cap_max_depth()
%t480 = icmp sge i64 %t478, %t479
br i1 %t480, label %L202, label %L204
L202:
%t482 = call i64 @rt_abort(ptr @.s481)
ret i64 %t482
L204:
%t483 = icmp ne i64 %p0, 0
br label %LSL484
LSL484:
br i1 %t483, label %LSR484, label %LSJ484
LSR484:
%t485 = icmp sgt i64 %p1, 0
br label %LSJ484
LSJ484:
%t486 = phi i1 [ false, %LSL484 ], [ %t485, %LSR484 ]
br i1 %t486, label %L205, label %L206
L205:
br label %L207
L206:
br label %L207
L207:
%t487 = phi i64 [ %p1, %L205 ], [ 0, %L206 ]
%t488 = call i64 @__mruntime_rt_caps_resid__cap_max_set()
%t489 = icmp sgt i64 %t487, %t488
br i1 %t489, label %L208, label %L209
L208:
%t490 = call i64 @__mruntime_rt_caps_resid__cap_max_set()
br label %L210
L209:
br label %L210
L210:
%t491 = phi i64 [ %t490, %L208 ], [ %t487, %L209 ]
%t492 = call i64 @__mruntime_rt_caps_resid__cap_stack()
%t493 = mul i64 %t478, 512
%t494 = add i64 %t492, %t493
%t495 = mul i64 %t491, 8
%t496 = call i64 @mcopy(i64 %t494, i64 %p0, i64 %t495)
%t497 = call i64 @__mruntime_rt_caps_resid__cap_ns()
%t498 = mul i64 %t478, 8
%t499 = add i64 %t497, %t498
%t500 = call i64 @st64(i64 %t499, i64 %t491)
%t501 = call i64 @__mruntime_rt_caps_resid__cap_depth_at()
%t502 = add nsw i64 %t478, 1
%t503 = tail call i64 @st64(i64 %t501, i64 %t502)
ret i64 %t503
}
define void @resid_cap_enter(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_cap_enter(i64 %x0i, i64 %a1)
ret void
}
define internal i64 @rt_cap_leave() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t504 = call i64 @__mruntime_rt_caps_resid__cap_depth_at()
%t505 = call i64 @ld64(i64 %t504)
%t506 = icmp sgt i64 %t505, 0
br i1 %t506, label %L211, label %L212
L211:
%t507 = call i64 @__mruntime_rt_caps_resid__cap_depth_at()
%t508 = sub nsw i64 %t505, 1
%t509 = call i64 @st64(i64 %t507, i64 %t508)
br label %L213
L212:
br label %L213
L213:
%t510 = phi i64 [ %t509, %L211 ], [ 0, %L212 ]
ret i64 %t510
}
define void @resid_cap_leave() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_cap_leave()
ret void
}
define internal i1 @__mruntime_rt_caps_resid__cap_term(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t511 = icmp eq i64 %p0, 0
br label %LSL512
LSL512:
br i1 %t511, label %LSJ512, label %LSR512
LSR512:
%t513 = icmp eq i64 %p0, 40
br label %LSJ512
LSJ512:
%t514 = phi i1 [ true, %LSL512 ], [ %t513, %LSR512 ]
br label %LSL515
LSL515:
br i1 %t514, label %LSJ515, label %LSR515
LSR515:
%t516 = icmp eq i64 %p0, 58
br label %LSJ515
LSJ515:
%t517 = phi i1 [ true, %LSL515 ], [ %t516, %LSR515 ]
br label %LSL518
LSL518:
br i1 %t517, label %LSJ518, label %LSR518
LSR518:
%t519 = icmp eq i64 %p0, 33
br label %LSJ518
LSJ518:
%t520 = phi i1 [ true, %LSL518 ], [ %t519, %LSR518 ]
ret i1 %t520
}
define internal i1 @__mruntime_rt_caps_resid__cap_ro(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t521 = call i64 @__mruntime_rt_caps_resid__cap_find(i64 %p0, i64 58)
%t522 = icmp ne i64 %t521, 0
br label %LSL523
LSL523:
br i1 %t522, label %LSR523, label %LSJ523
LSR523:
%t524 = add i64 %t521, 1
%t525 = call i64 @ld8(i64 %t524)
%t526 = icmp eq i64 %t525, 114
br label %LSJ523
LSJ523:
%t527 = phi i1 [ false, %LSL523 ], [ %t526, %LSR523 ]
br label %LSL528
LSL528:
br i1 %t527, label %LSR528, label %LSJ528
LSR528:
%t529 = add i64 %t521, 2
%t530 = call i64 @ld8(i64 %t529)
%t531 = icmp eq i64 %t530, 111
br label %LSJ528
LSJ528:
%t532 = phi i1 [ false, %LSL528 ], [ %t531, %LSR528 ]
br label %LSL533
LSL533:
br i1 %t532, label %LSR533, label %LSJ533
LSR533:
%t534 = add i64 %t521, 3
%t535 = call i64 @ld8(i64 %t534)
%t536 = icmp eq i64 %t535, 0
br label %LSJ533
LSJ533:
%t537 = phi i1 [ false, %LSL533 ], [ %t536, %LSR533 ]
ret i1 %t537
}
define internal i64 @__mruntime_rt_caps_resid__cap_find(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t541, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%t538 = call i64 @ld8(i64 %p0)
%t539 = icmp eq i64 %t538, %p1
br i1 %t539, label %L214, label %L216
L214:
ret i64 %p0
L216:
%t540 = icmp eq i64 %t538, 0
br i1 %t540, label %L217, label %L219
L217:
ret i64 0
L219:
%t541 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_caps_resid__cap_same_family(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t564, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t565, %tco.s0 ]
%t543 = icmp eq i64 %p0, 0
br label %LSL544
LSL544:
br i1 %t543, label %LSJ544, label %LSR544
LSR544:
%t545 = icmp eq i64 %p1, 0
br label %LSJ544
LSJ544:
%t546 = phi i1 [ true, %LSL544 ], [ %t545, %LSR544 ]
br i1 %t546, label %L220, label %L222
L220:
ret i1 false
L222:
%t547 = call i64 @ld8(i64 %p0)
%t548 = call i64 @ld8(i64 %p1)
%t549 = icmp ne i64 %t547, 0
br label %LSL550
LSL550:
br i1 %t549, label %LSR550, label %LSJ550
LSR550:
%t551 = icmp ne i64 %t548, 0
br label %LSJ550
LSJ550:
%t552 = phi i1 [ false, %LSL550 ], [ %t551, %LSR550 ]
br label %LSL553
LSL553:
br i1 %t552, label %LSR553, label %LSJ553
LSR553:
%t554 = call i1 @__mruntime_rt_caps_resid__cap_term(i64 %t547)
%t555 = xor i1 %t554, true
br label %LSJ553
LSJ553:
%t556 = phi i1 [ false, %LSL553 ], [ %t555, %LSR553 ]
br label %LSL557
LSL557:
br i1 %t556, label %LSR557, label %LSJ557
LSR557:
%t558 = call i1 @__mruntime_rt_caps_resid__cap_term(i64 %t548)
%t559 = xor i1 %t558, true
br label %LSJ557
LSJ557:
%t560 = phi i1 [ false, %LSL557 ], [ %t559, %LSR557 ]
br label %LSL561
LSL561:
br i1 %t560, label %LSR561, label %LSJ561
LSR561:
%t562 = icmp eq i64 %t547, %t548
br label %LSJ561
LSJ561:
%t563 = phi i1 [ false, %LSL561 ], [ %t562, %LSR561 ]
br i1 %t563, label %L223, label %L225
L223:
%t564 = add i64 %p0, 1
%t565 = add i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L225:
%t567 = call i1 @__mruntime_rt_caps_resid__cap_term(i64 %t547)
br label %LSL568
LSL568:
br i1 %t567, label %LSR568, label %LSJ568
LSR568:
%t569 = call i1 @__mruntime_rt_caps_resid__cap_term(i64 %t548)
br label %LSJ568
LSJ568:
%t570 = phi i1 [ false, %LSL568 ], [ %t569, %LSR568 ]
ret i1 %t570
}
define internal i1 @__mruntime_rt_caps_resid__cap_in_frame(i64 %p0.in, i64 %p1.in, i64 %p2.in, i1 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t589, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i1 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t571 = call i64 @__mruntime_rt_caps_resid__cap_ns()
%t572 = mul i64 %p0, 8
%t573 = add i64 %t571, %t572
%t574 = call i64 @ld64(i64 %t573)
%t575 = icmp sge i64 %p1, %t574
br i1 %t575, label %L226, label %L228
L226:
ret i1 false
L228:
%t576 = call i64 @__mruntime_rt_caps_resid__cap_stack()
%t577 = mul i64 %p0, 512
%t578 = add i64 %t576, %t577
%t579 = mul i64 %p1, 8
%t580 = add i64 %t578, %t579
%t581 = call i64 @ld64(i64 %t580)
%t582 = call i1 @__mruntime_rt_caps_resid__cap_same_family(i64 %t581, i64 %p2)
br label %LSL583
LSL583:
br i1 %t582, label %LSR583, label %LSJ583
LSR583:
br label %LSL584
LSL584:
br i1 %p3, label %LSR584, label %LSJ584
LSR584:
%t585 = call i1 @__mruntime_rt_caps_resid__cap_ro(i64 %t581)
br label %LSJ584
LSJ584:
%t586 = phi i1 [ false, %LSL584 ], [ %t585, %LSR584 ]
%t587 = xor i1 %t586, true
br label %LSJ583
LSJ583:
%t588 = phi i1 [ false, %LSL583 ], [ %t587, %LSJ584 ]
br i1 %t588, label %L229, label %L231
L229:
ret i1 true
L231:
%t589 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_caps_resid__cap_all_frames(i64 %p0.in, i64 %p1.in, i64 %p2.in, i1 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t594, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i1 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t591 = icmp sge i64 %p0, %p1
br i1 %t591, label %L232, label %L234
L232:
ret i1 true
L234:
%t592 = call i1 @__mruntime_rt_caps_resid__cap_in_frame(i64 %p0, i64 0, i64 %p2, i1 %p3)
%t593 = xor i1 %t592, true
br i1 %t593, label %L235, label %L237
L235:
ret i1 false
L237:
%t594 = add nsw i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_caps_resid__cap_granted(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t596 = call i64 @__mruntime_rt_caps_resid__cap_depth_at()
%t597 = call i64 @ld64(i64 %t596)
%t598 = icmp eq i64 %t597, 0
br i1 %t598, label %L238, label %L240
L238:
ret i1 true
L240:
%t599 = call i64 @c_strlen(i64 %p0)
%t600 = icmp sgt i64 %t599, 0
br label %LSL601
LSL601:
br i1 %t600, label %LSR601, label %LSJ601
LSR601:
%t602 = add i64 %p0, %t599
%t603 = sub nsw i64 %t602, 1
%t604 = call i64 @ld8(i64 %t603)
%t605 = icmp eq i64 %t604, 33
br label %LSJ601
LSJ601:
%t606 = phi i1 [ false, %LSL601 ], [ %t605, %LSR601 ]
%t607 = call i1 @__mruntime_rt_caps_resid__cap_all_frames(i64 0, i64 %t597, i64 %p0, i1 %t606)
ret i1 %t607
}
define internal i64 @rt_cap_granted(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t608 = call i1 @__mruntime_rt_caps_resid__cap_granted(i64 %p0)
br i1 %t608, label %L241, label %L242
L241:
br label %L243
L242:
br label %L243
L243:
%t609 = phi i64 [ 1, %L241 ], [ 0, %L242 ]
ret i64 %t609
}
define i8 @resid_cap_granted(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_cap_granted(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_cap_check(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t610 = call i1 @__mruntime_rt_caps_resid__cap_granted(i64 %p0)
br i1 %t610, label %L244, label %L246
L244:
ret i64 0
L246:
%t611 = call i64 @c_strlen(i64 %p0)
%t612 = icmp sgt i64 %t611, 0
br label %LSL613
LSL613:
br i1 %t612, label %LSR613, label %LSJ613
LSR613:
%t614 = add i64 %p0, %t611
%t615 = sub nsw i64 %t614, 1
%t616 = call i64 @ld8(i64 %t615)
%t617 = icmp eq i64 %t616, 33
br label %LSJ613
LSJ613:
%t618 = phi i1 [ false, %LSL613 ], [ %t617, %LSR613 ]
br i1 %t618, label %L247, label %L248
L247:
%t619 = sub i64 %t611, 1
br label %L249
L248:
br label %L249
L249:
%t620 = phi i64 [ %t619, %L247 ], [ %t611, %L248 ]
%t622 = ptrtoint ptr @.s621 to i64
br i1 %t618, label %L250, label %L251
L250:
%t624 = ptrtoint ptr @.s623 to i64
br label %L252
L251:
%t626 = ptrtoint ptr @.s625 to i64
br label %L252
L252:
%t627 = phi i64 [ %t624, %L250 ], [ %t626, %L251 ]
%t628 = call i64 @c_strlen(i64 %t622)
%t629 = call i64 @c_strlen(i64 %t627)
%t630 = add i64 %t628, %t620
%t631 = add i64 %t630, %t629
%t632 = add i64 %t631, 1
%t633 = call i64 @xmalloc(i64 %t632)
%t634 = call i64 @mcopy(i64 %t633, i64 %t622, i64 %t628)
%t635 = add i64 %t633, %t628
%t636 = call i64 @mcopy(i64 %t635, i64 %p0, i64 %t620)
%t637 = add i64 %t633, %t628
%t638 = add i64 %t637, %t620
%t639 = add i64 %t629, 1
%t640 = call i64 @mcopy(i64 %t638, i64 %t627, i64 %t639)
%t641 = tail call i64 @rt_abort_at(i64 %t633)
ret i64 %t641
}
define void @resid_cap_check(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_cap_check(i64 %x0i)
ret void
}
define internal i64 @rt_str_concat(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t642 = call i64 @c_strlen(i64 %p0)
%t643 = call i64 @c_strlen(i64 %p1)
%t644 = add i64 %t642, %t643
%t645 = add i64 %t644, 1
%t646 = call i64 @ralloc(i64 %t645)
%t647 = call i64 @mcopy(i64 %t646, i64 %p0, i64 %t642)
%t648 = add i64 %t646, %t642
%t649 = add i64 %t643, 1
%t650 = call i64 @mcopy(i64 %t648, i64 %p1, i64 %t649)
ret i64 %t646
}
define ptr @resid_str_concat(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_str_concat(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_str_eq(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t651 = call i64 @c_strcmp(i64 %p0, i64 %p1)
%t652 = icmp eq i64 %t651, 0
br i1 %t652, label %L253, label %L254
L253:
br label %L255
L254:
br label %L255
L255:
%t653 = phi i64 [ 1, %L253 ], [ 0, %L254 ]
ret i64 %t653
}
define i8 @resid_str_eq(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_str_eq(i64 %x0i, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @__mruntime_rt_text_resid__sacc_alloc(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t654 = add i64 16, %p0
%t655 = add i64 %t654, 1
%t656 = call i64 @xmalloc(i64 %t655)
%t657 = call i64 @st64(i64 %t656, i64 0)
%t658 = add i64 %t656, 8
%t659 = call i64 @st64(i64 %t658, i64 %p0)
%t660 = add i64 %t656, 16
ret i64 %t660
}
define internal i64 @rt_sacc_from(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t661 = call i64 @c_strlen(i64 %p0)
%t662 = icmp slt i64 %t661, 32
br i1 %t662, label %L256, label %L257
L256:
br label %L258
L257:
%t663 = mul i64 %t661, 2
br label %L258
L258:
%t664 = phi i64 [ 64, %L256 ], [ %t663, %L257 ]
%t665 = call i64 @__mruntime_rt_text_resid__sacc_alloc(i64 %t664)
%t666 = add i64 %t661, 1
%t667 = call i64 @mcopy(i64 %t665, i64 %p0, i64 %t666)
%t668 = sub i64 %t665, 16
%t669 = call i64 @st64(i64 %t668, i64 %t661)
ret i64 %t665
}
define ptr @resid_sacc_from(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_sacc_from(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_text_resid__sacc_reserve(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t670 = sub i64 %p0, 16
%t671 = call i64 @ld64(i64 %t670)
%t672 = sub i64 %p0, 8
%t673 = call i64 @ld64(i64 %t672)
%t674 = add i64 %t671, %p1
%t675 = icmp sle i64 %t674, %t673
br i1 %t675, label %L259, label %L261
L259:
ret i64 %p0
L261:
%t676 = mul i64 %t673, 2
%t677 = add i64 %t671, %p1
%t678 = icmp slt i64 %t676, %t677
br i1 %t678, label %L262, label %L263
L262:
%t679 = add i64 %t671, %p1
br label %L264
L263:
%t680 = mul i64 %t673, 2
br label %L264
L264:
%t681 = phi i64 [ %t679, %L262 ], [ %t680, %L263 ]
%t682 = call i64 @str_index_forget(i64 %p0)
%t683 = sub i64 %p0, 16
%t684 = add i64 16, %t681
%t685 = add i64 %t684, 1
%t686 = call i64 @xrealloc(i64 %t683, i64 %t685)
%t687 = add i64 %t686, 8
%t688 = call i64 @st64(i64 %t687, i64 %t681)
%t689 = add i64 %t686, 16
ret i64 %t689
}
define internal i64 @rt_sacc_append(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t690 = call i64 @c_strlen(i64 %p1)
%t691 = call i64 @__mruntime_rt_text_resid__sacc_reserve(i64 %p0, i64 %t690)
%t692 = sub i64 %t691, 16
%t693 = call i64 @ld64(i64 %t692)
%t694 = add i64 %t691, %t693
%t695 = add i64 %t690, 1
%t696 = call i64 @mcopy(i64 %t694, i64 %p1, i64 %t695)
%t697 = sub i64 %t691, 16
%t698 = add i64 %t693, %t690
%t699 = call i64 @st64(i64 %t697, i64 %t698)
%t700 = add i64 %t699, %t691
ret i64 %t700
}
define ptr @resid_sacc_append(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_sacc_append(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_sacc_append_int(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t701p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.sacc_itoa)
%t701 = ptrtoint ptr %t701p to i64
%t702 = call i64 @itoa_into(i64 %t701, i64 %p1)
%t703 = call i64 @__mruntime_rt_text_resid__sacc_reserve(i64 %p0, i64 %t702)
%t704 = sub i64 %t703, 16
%t705 = call i64 @ld64(i64 %t704)
%t706 = add i64 %t703, %t705
%t707 = call i64 @mcopy(i64 %t706, i64 %t701, i64 %t702)
%t708 = add i64 %t703, %t705
%t709 = add i64 %t708, %t702
%t710 = call i64 @st8(i64 %t709, i64 0)
%t711 = sub i64 %t703, 16
%t712 = add i64 %t705, %t702
%t713 = call i64 @st64(i64 %t711, i64 %t712)
%t714 = add i64 %t713, %t703
ret i64 %t714
}
define ptr @resid_sacc_append_int(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_sacc_append_int(i64 %x0i, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @itoa_into(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t715 = icmp slt i64 %p1, 0
br i1 %t715, label %L265, label %L266
L265:
%t716 = sub i64 0, %p1
br label %L267
L266:
br label %L267
L267:
%t717 = phi i64 [ %t716, %L265 ], [ %p1, %L266 ]
%t718 = call i64 @udigits(i64 %t717, i64 1)
br i1 %t715, label %L268, label %L269
L268:
%t719 = call i64 @st8(i64 %p0, i64 45)
%t720 = add i64 %t719, 1
br label %L270
L269:
br label %L270
L270:
%t721 = phi i64 [ %t720, %L268 ], [ 0, %L269 ]
%t722 = add i64 %p0, %t721
%t723 = add i64 %t722, %t718
%t724 = sub i64 %t723, 1
%t725 = call i64 @uput(i64 %t724, i64 %t717)
%t726 = add i64 %t721, %t718
ret i64 %t726
}
define internal i64 @udigits(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t727, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t729, %tco.s0 ]
%t727 = call i64 @__mruntime_rt_text_resid__udiv10(i64 %p0)
%t728 = icmp eq i64 %t727, 0
br i1 %t728, label %L271, label %L273
L271:
ret i64 %p1
L273:
%t729 = add i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__udiv10(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t731 = call i64 @udiv(i64 %p0, i64 10)
ret i64 %t731
}
define internal i64 @uput(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t738, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t732, %tco.s0 ]
%t732 = call i64 @__mruntime_rt_text_resid__udiv10(i64 %p1)
%t733 = mul i64 %t732, 10
%t734 = sub i64 %p1, %t733
%t735 = add i64 48, %t734
%t736 = call i64 @st8(i64 %p0, i64 %t735)
%t737 = icmp eq i64 %t732, 0
br i1 %t737, label %L274, label %L276
L274:
ret i64 0
L276:
%t738 = sub i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_to_fixed(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t740 = icmp eq i64 %p2, 0
br i1 %t740, label %L277, label %L279
L277:
ret i64 0
L279:
%t741 = sub i64 %p2, 1
%t742 = call i64 @__mruntime_rt_text_resid__fixed_copy(i64 %p0, i64 %p1, i64 0, i64 %t741)
%t743 = add i64 %p1, %t742
%t744 = call i64 @ld8(i64 %t743)
%t745 = icmp ne i64 %t744, 0
br label %LSL746
LSL746:
br i1 %t745, label %LSR746, label %LSJ746
LSR746:
%t747 = add i64 %p1, %t742
%t748 = call i64 @ld8(i64 %t747)
%t749 = and i64 %t748, 192
%t750 = icmp eq i64 %t749, 128
br label %LSJ746
LSJ746:
%t751 = phi i1 [ false, %LSL746 ], [ %t750, %LSR746 ]
br i1 %t751, label %L280, label %L281
L280:
%t752 = call i64 @__mruntime_rt_text_resid__fixed_back(i64 %p1, i64 %t742)
br label %L282
L281:
br label %L282
L282:
%t753 = phi i64 [ %t752, %L280 ], [ %t742, %L281 ]
%t754 = add i64 %p0, %t753
%t755 = call i64 @st8(i64 %t754, i64 0)
ret i64 %t753
}
define i64 @resid_str_to_fixed(ptr %a0, ptr %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_str_to_fixed(i64 %x0i, i64 %x1i, i64 %a2)
ret i64 %r
}
define internal i64 @__mruntime_rt_text_resid__fixed_copy(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t762, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t756 = icmp sge i64 %p2, %p3
br i1 %t756, label %L283, label %L285
L283:
ret i64 %p2
L285:
%t757 = add i64 %p1, %p2
%t758 = call i64 @ld8(i64 %t757)
%t759 = icmp eq i64 %t758, 0
br i1 %t759, label %L286, label %L288
L286:
ret i64 %p2
L288:
%t760 = add i64 %p0, %p2
%t761 = call i64 @st8(i64 %t760, i64 %t758)
%t762 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__fixed_back(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t771, %tco.s0 ]
%t764 = icmp sgt i64 %p1, 0
br label %LSL765
LSL765:
br i1 %t764, label %LSR765, label %LSJ765
LSR765:
%t766 = add i64 %p0, %p1
%t767 = call i64 @ld8(i64 %t766)
%t768 = and i64 %t767, 192
%t769 = icmp eq i64 %t768, 128
br label %LSJ765
LSJ765:
%t770 = phi i1 [ false, %LSL765 ], [ %t769, %LSR765 ]
br i1 %t770, label %L289, label %L291
L289:
%t771 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L291:
ret i64 %p1
}
define internal i64 @rt_bytes_to_fixed(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t773 = icmp eq i64 %p2, 0
br i1 %t773, label %L292, label %L294
L292:
ret i64 0
L294:
%t774 = call i64 @__mruntime_rt_text_resid__fixed_copy(i64 %p0, i64 %p1, i64 0, i64 %p2)
ret i64 %t774
}
define i64 @resid_bytes_to_fixed(ptr %a0, ptr %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_bytes_to_fixed(i64 %x0i, i64 %x1i, i64 %a2)
ret i64 %r
}
define internal i64 @utf8_seq_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t775 = icmp slt i64 %p0, 128
br i1 %t775, label %L295, label %L297
L295:
ret i64 1
L297:
%t776 = and i64 %p0, 224
%t777 = icmp eq i64 %t776, 192
br i1 %t777, label %L298, label %L300
L298:
ret i64 2
L300:
%t778 = and i64 %p0, 240
%t779 = icmp eq i64 %t778, 224
br i1 %t779, label %L301, label %L303
L301:
ret i64 3
L303:
%t780 = and i64 %p0, 248
%t781 = icmp eq i64 %t780, 240
br i1 %t781, label %L304, label %L306
L304:
ret i64 4
L306:
ret i64 1
}
define internal i64 @utf8_len_at(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t782 = call i64 @ld8(i64 %p0)
%t783 = call i64 @utf8_seq_len(i64 %t782)
%t784 = call i64 @__mruntime_rt_text_resid__utf8_cont(i64 %p0, i64 1, i64 %t783)
ret i64 %t784
}
define internal i64 @__mruntime_rt_text_resid__utf8_cont(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t790, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t785 = icmp sge i64 %p1, %p2
br i1 %t785, label %L307, label %L309
L307:
ret i64 %p2
L309:
%t786 = add i64 %p0, %p1
%t787 = call i64 @ld8(i64 %t786)
%t788 = and i64 %t787, 192
%t789 = icmp ne i64 %t788, 128
br i1 %t789, label %L310, label %L312
L310:
ret i64 %p1
L312:
%t790 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @utf8_decode(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t792 = call i64 @ld8(i64 %p0)
%t793 = icmp eq i64 %p1, 1
br i1 %t793, label %L313, label %L315
L313:
ret i64 %t792
L315:
%t794 = icmp eq i64 %p1, 2
br i1 %t794, label %L316, label %L318
L316:
%t795 = and i64 %t792, 31
%t796 = shl i64 %t795, 6
%t797 = add i64 %p0, 1
%t798 = call i64 @ld8(i64 %t797)
%t799 = and i64 %t798, 63
%t800 = or i64 %t796, %t799
ret i64 %t800
L318:
%t801 = icmp eq i64 %p1, 3
br i1 %t801, label %L319, label %L321
L319:
%t802 = and i64 %t792, 15
%t803 = shl i64 %t802, 12
%t804 = add i64 %p0, 1
%t805 = call i64 @ld8(i64 %t804)
%t806 = and i64 %t805, 63
%t807 = shl i64 %t806, 6
%t808 = or i64 %t803, %t807
%t809 = add i64 %p0, 2
%t810 = call i64 @ld8(i64 %t809)
%t811 = and i64 %t810, 63
%t812 = or i64 %t808, %t811
ret i64 %t812
L321:
%t813 = and i64 %t792, 7
%t814 = shl i64 %t813, 18
%t815 = add i64 %p0, 1
%t816 = call i64 @ld8(i64 %t815)
%t817 = and i64 %t816, 63
%t818 = shl i64 %t817, 12
%t819 = or i64 %t814, %t818
%t820 = add i64 %p0, 2
%t821 = call i64 @ld8(i64 %t820)
%t822 = and i64 %t821, 63
%t823 = shl i64 %t822, 6
%t824 = or i64 %t819, %t823
%t825 = add i64 %p0, 3
%t826 = call i64 @ld8(i64 %t825)
%t827 = and i64 %t826, 63
%t828 = or i64 %t824, %t827
ret i64 %t828
}
define internal i64 @utf8_encode(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t829 = icmp slt i64 %p0, 128
br i1 %t829, label %L322, label %L324
L322:
%t830 = call i64 @st8(i64 %p1, i64 %p0)
%t831 = add i64 %t830, 1
ret i64 %t831
L324:
%t832 = icmp slt i64 %p0, 2048
br i1 %t832, label %L325, label %L327
L325:
%t833 = ashr i64 %p0, 6
%t834 = or i64 192, %t833
%t835 = call i64 @st8(i64 %p1, i64 %t834)
%t836 = add i64 %p1, 1
%t837 = and i64 %p0, 63
%t838 = or i64 128, %t837
%t839 = call i64 @st8(i64 %t836, i64 %t838)
%t840 = add i64 %t839, 2
ret i64 %t840
L327:
%t841 = icmp slt i64 %p0, 65536
br i1 %t841, label %L328, label %L330
L328:
%t842 = ashr i64 %p0, 12
%t843 = or i64 224, %t842
%t844 = call i64 @st8(i64 %p1, i64 %t843)
%t845 = add i64 %p1, 1
%t846 = ashr i64 %p0, 6
%t847 = and i64 %t846, 63
%t848 = or i64 128, %t847
%t849 = call i64 @st8(i64 %t845, i64 %t848)
%t850 = add i64 %p1, 2
%t851 = and i64 %p0, 63
%t852 = or i64 128, %t851
%t853 = call i64 @st8(i64 %t850, i64 %t852)
%t854 = add i64 %t853, 3
ret i64 %t854
L330:
%t855 = ashr i64 %p0, 18
%t856 = or i64 240, %t855
%t857 = call i64 @st8(i64 %p1, i64 %t856)
%t858 = add i64 %p1, 1
%t859 = ashr i64 %p0, 12
%t860 = and i64 %t859, 63
%t861 = or i64 128, %t860
%t862 = call i64 @st8(i64 %t858, i64 %t861)
%t863 = add i64 %p1, 2
%t864 = ashr i64 %p0, 6
%t865 = and i64 %t864, 63
%t866 = or i64 128, %t865
%t867 = call i64 @st8(i64 %t863, i64 %t866)
%t868 = add i64 %p1, 3
%t869 = and i64 %p0, 63
%t870 = or i64 128, %t869
%t871 = call i64 @st8(i64 %t868, i64 %t870)
%t872 = add i64 %t871, 4
ret i64 %t872
}
define internal i64 @rt_str_from_code(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t873p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.from_code)
%t873 = ptrtoint ptr %t873p to i64
%t874 = call i64 @utf8_encode(i64 %p0, i64 %t873)
%t875 = call i64 @cstr_from(i64 %t873, i64 %t874, i64 0)
ret i64 %t875
}
define ptr @str_from_code(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_str_from_code(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_text_resid__idx_slots() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t876p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.str_slots)
%t876 = ptrtoint ptr %t876p to i64
ret i64 %t876
}
define internal i64 @__mruntime_rt_text_resid__idx_small() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t877 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t878 = add i64 %t877, 640
ret i64 %t878
}
define internal i64 @__mruntime_rt_text_resid__idx_scratch() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t879 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t880 = add i64 %t879, 680
ret i64 %t880
}
define internal i64 @__mruntime_rt_text_resid__idx_state() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t881p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.str_state)
%t881 = ptrtoint ptr %t881p to i64
ret i64 %t881
}
define internal i64 @__mruntime_rt_text_resid__sl_s(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t882 = tail call i64 @ld64(i64 %p0)
ret i64 %t882
}
define internal i64 @__mruntime_rt_text_resid__sl_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t883 = add i64 %p0, 8
%t884 = tail call i64 @ld64(i64 %t883)
ret i64 %t884
}
define internal i64 @__mruntime_rt_text_resid__sl_off(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t885 = add i64 %p0, 16
%t886 = tail call i64 @ld64(i64 %t885)
ret i64 %t886
}
define internal i64 @__mruntime_rt_text_resid__sl_blen(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t887 = add i64 %p0, 32
%t888 = tail call i64 @ld64(i64 %t887)
ret i64 %t888
}
define internal i64 @slot_off(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t889 = call i64 @__mruntime_rt_text_resid__sl_off(i64 %p0)
%t890 = icmp eq i64 %t889, 0
br i1 %t890, label %L331, label %L333
L331:
ret i64 %p1
L333:
%t891 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %p0)
%t892 = ashr i64 %p1, 4
%t893 = mul i64 %t892, 8
%t894 = add i64 %t889, %t893
%t895 = call i64 @ld64(i64 %t894)
%t896 = add i64 %t891, %t895
%t897 = and i64 %p1, 15
%t898 = call i64 @__mruntime_rt_text_resid__slot_walk(i64 %t896, i64 %t897)
%t899 = sub i64 %t898, %t891
ret i64 %t899
}
define internal i64 @__mruntime_rt_text_resid__slot_walk(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t902, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t903, %tco.s0 ]
%t900 = icmp sle i64 %p1, 0
br i1 %t900, label %L334, label %L336
L334:
ret i64 %p0
L336:
%t901 = call i64 @utf8_len_at(i64 %p0)
%t902 = add i64 %p0, %t901
%t903 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_text_resid__any_high(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t907, %tco.s0 ], [ %t925, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t922, %tco.s0 ], [ %t928, %tco.s1 ]
%t905 = add i64 %p1, 32
%t906 = icmp sle i64 %t905, %p2
br i1 %t906, label %L337, label %L339
L337:
%t907 = add i64 %p1, 32
%t908 = add i64 %p0, %p1
%t909 = call i64 @ld64(i64 %t908)
%t910 = or i64 %p3, %t909
%t911 = add i64 %p0, %p1
%t912 = add i64 %t911, 8
%t913 = call i64 @ld64(i64 %t912)
%t914 = or i64 %t910, %t913
%t915 = add i64 %p0, %p1
%t916 = add i64 %t915, 16
%t917 = call i64 @ld64(i64 %t916)
%t918 = or i64 %t914, %t917
%t919 = add i64 %p0, %p1
%t920 = add i64 %t919, 24
%t921 = call i64 @ld64(i64 %t920)
%t922 = or i64 %t918, %t921
br label %tco.s0
tco.s0:
br label %tco.head
L339:
%t924 = icmp slt i64 %p1, %p2
br i1 %t924, label %L340, label %L342
L340:
%t925 = add nsw i64 %p1, 1
%t926 = add i64 %p0, %p1
%t927 = call i64 @ld8(i64 %t926)
%t928 = or i64 %p3, %t927
br label %tco.s1
tco.s1:
br label %tco.head
L342:
%t930 = sext i64 0 to i128
%t931 = sub i128 %t930, 9187201950435737472
%t932 = sext i64 %p3 to i128
%t933 = and i128 %t932, %t931
%t934 = icmp ne i128 %t933, 0
ret i1 %t934
}
define internal i64 @__mruntime_rt_text_resid__cp_count(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t938, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t939, %tco.s0 ]
%t935 = call i64 @ld8(i64 %p0)
%t936 = icmp eq i64 %t935, 0
br i1 %t936, label %L343, label %L345
L343:
ret i64 %p1
L345:
%t937 = call i64 @utf8_len_at(i64 %p0)
%t938 = add i64 %p0, %t937
%t939 = add i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__fill_off(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t958, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t959, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t941 = icmp sge i64 %p3, %p4
br i1 %t941, label %L346, label %L348
L346:
%t942 = and i64 %p4, 15
%t943 = icmp eq i64 %t942, 0
br i1 %t943, label %L349, label %L351
L349:
%t944 = ashr i64 %p4, 4
%t945 = mul i64 %t944, 8
%t946 = add i64 %p1, %t945
%t947 = sub i64 %p2, %p0
%t948 = call i64 @st64(i64 %t946, i64 %t947)
ret i64 %t948
L351:
ret i64 0
L348:
%t949 = and i64 %p3, 15
%t950 = icmp eq i64 %t949, 0
br i1 %t950, label %L352, label %L353
L352:
%t951 = ashr i64 %p3, 4
%t952 = mul i64 %t951, 8
%t953 = add i64 %p1, %t952
%t954 = sub i64 %p2, %p0
%t955 = call i64 @st64(i64 %t953, i64 %t954)
br label %L354
L353:
br label %L354
L354:
%t956 = phi i64 [ %t955, %L352 ], [ 0, %L353 ]
%t957 = call i64 @utf8_len_at(i64 %p2)
%t958 = add i64 %p2, %t957
%t959 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__idx_build(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t961 = call i64 @__mruntime_rt_text_resid__sl_off(i64 %p1)
%t962 = icmp ne i64 %t961, 0
br i1 %t962, label %L355, label %L356
L355:
%t963 = call i64 @c_free(i64 %t961)
%t964 = add i64 %p1, 16
%t965 = call i64 @st64(i64 %t964, i64 0)
%t966 = add i64 %t963, %t965
br label %L357
L356:
br label %L357
L357:
%t967 = phi i64 [ %t966, %L355 ], [ 0, %L356 ]
%t968 = call i64 @c_strlen(i64 %p0)
%t969 = add i64 %p1, 32
%t970 = call i64 @st64(i64 %t969, i64 %t968)
%t971 = call i64 @st64(i64 %p1, i64 %p0)
%t972 = call i1 @__mruntime_rt_text_resid__any_high(i64 %p0, i64 0, i64 %t968, i64 0)
%t973 = xor i1 %t972, true
br i1 %t973, label %L358, label %L360
L358:
%t974 = add i64 %p1, 8
%t975 = tail call i64 @st64(i64 %t974, i64 %t968)
ret i64 %t975
L360:
%t976 = call i64 @__mruntime_rt_text_resid__cp_count(i64 %p0, i64 0)
%t977 = add i64 %p1, 8
%t978 = call i64 @st64(i64 %t977, i64 %t976)
%t979 = ashr i64 %t976, 4
%t980 = add i64 %t979, 1
%t981 = mul i64 %t980, 8
%t982 = call i64 @xmalloc(i64 %t981)
%t983 = call i64 @__mruntime_rt_text_resid__fill_off(i64 %p0, i64 %t982, i64 %p0, i64 0, i64 %t976)
%t984 = add i64 %p1, 16
%t985 = tail call i64 @st64(i64 %t984, i64 %t982)
ret i64 %t985
}
define internal i64 @__mruntime_rt_text_resid__idx_ready() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t986 = call i64 @__mruntime_rt_text_resid__idx_state()
%t987 = add i64 %t986, 8
%t988 = call i64 @ld64(i64 %t987)
%t989 = icmp ne i64 %t988, 0
br i1 %t989, label %L361, label %L363
L361:
ret i64 0
L363:
%t990 = call i64 @__mruntime_rt_text_resid__idx_clear_all(i64 0)
%t991 = call i64 @__mruntime_rt_text_resid__idx_state()
%t992 = add i64 %t991, 8
%t993 = call i64 @st64(i64 %t992, i64 1)
ret i64 %t993
}
define internal i64 @__mruntime_rt_text_resid__idx_clear_all(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1006, %tco.s0 ]
%t994 = icmp sge i64 %p0, 16
br i1 %t994, label %L364, label %L366
L364:
ret i64 0
L366:
%t995 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t996 = mul i64 %p0, 40
%t997 = add i64 %t995, %t996
%t998 = call i64 @st64(i64 %t997, i64 0)
%t999 = add i64 %t997, 8
%t1000 = sub nsw i64 0, 1
%t1001 = call i64 @st64(i64 %t999, i64 %t1000)
%t1002 = add i64 %t997, 16
%t1003 = call i64 @st64(i64 %t1002, i64 0)
%t1004 = add i64 %t997, 24
%t1005 = call i64 @st64(i64 %t1004, i64 0)
%t1006 = add nsw i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_text_resid__str_short(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1012, %tco.s0 ]
%t1008 = icmp sge i64 %p1, 256
br i1 %t1008, label %L367, label %L369
L367:
ret i1 false
L369:
%t1009 = add i64 %p0, %p1
%t1010 = call i64 @ld8(i64 %t1009)
%t1011 = icmp eq i64 %t1010, 0
br i1 %t1011, label %L370, label %L372
L370:
ret i1 true
L372:
%t1012 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__idx_find(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1020, %tco.s0 ]
%t1014 = icmp sge i64 %p1, 16
br i1 %t1014, label %L373, label %L375
L373:
ret i64 0
L375:
%t1015 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t1016 = mul i64 %p1, 40
%t1017 = add i64 %t1015, %t1016
%t1018 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1017)
%t1019 = icmp eq i64 %t1018, %p0
br i1 %t1019, label %L376, label %L378
L376:
ret i64 %t1017
L378:
%t1020 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__idx_victim(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1031, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1032, %tco.s0 ]
%t1022 = icmp sge i64 %p0, 16
br i1 %t1022, label %L379, label %L381
L379:
ret i64 %p1
L381:
%t1023 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t1024 = mul i64 %p0, 40
%t1025 = add i64 %t1023, %t1024
%t1026 = add i64 %t1025, 24
%t1027 = call i64 @ld64(i64 %t1026)
%t1028 = add i64 %p1, 24
%t1029 = call i64 @ld64(i64 %t1028)
%t1030 = icmp slt i64 %t1027, %t1029
%t1031 = add nsw i64 %p0, 1
br i1 %t1030, label %L382, label %L383
L382:
br label %L384
L383:
br label %L384
L384:
%t1032 = phi i64 [ %t1025, %L382 ], [ %p1, %L383 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__idx_slot_slow(i64 %p0) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1034 = call i64 @__mruntime_rt_text_resid__idx_ready()
%t1035 = call i64 @__mruntime_rt_text_resid__idx_small()
%t1036 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1035)
%t1037 = icmp eq i64 %t1036, %p0
br i1 %t1037, label %L385, label %L387
L385:
%t1038 = call i64 @__mruntime_rt_text_resid__idx_small()
ret i64 %t1038
L387:
%t1039 = call i1 @__mruntime_rt_text_resid__str_short(i64 %p0, i64 0)
br i1 %t1039, label %L388, label %L390
L388:
%t1040 = call i64 @__mruntime_rt_text_resid__idx_small()
%t1041 = call i64 @__mruntime_rt_text_resid__idx_build(i64 %p0, i64 %t1040)
%t1042 = mul nsw i64 %t1041, 0
%t1043 = call i64 @__mruntime_rt_text_resid__idx_small()
%t1044 = add nsw i64 %t1042, %t1043
ret i64 %t1044
L390:
%t1045 = call i64 @__mruntime_rt_text_resid__idx_state()
%t1046 = call i64 @ld64(i64 %t1045)
%t1047 = add i64 %t1046, 1
%t1048 = call i64 @st64(i64 %t1045, i64 %t1047)
%t1049 = add i64 %t1045, 16
%t1050 = call i64 @ld64(i64 %t1049)
%t1051 = icmp ne i64 %t1050, 0
br i1 %t1051, label %L391, label %L392
L391:
%t1052 = add i64 %t1050, 24
%t1053 = call i64 @st64(i64 %t1052, i64 %t1047)
br label %L393
L392:
br label %L393
L393:
%t1054 = phi i64 [ %t1053, %L391 ], [ 0, %L392 ]
%t1055 = call i64 @__mruntime_rt_text_resid__idx_find(i64 %p0, i64 0)
%t1056 = icmp ne i64 %t1055, 0
br i1 %t1056, label %L394, label %L396
L394:
%t1057 = add i64 %t1055, 24
%t1058 = call i64 @st64(i64 %t1057, i64 %t1047)
%t1059 = mul nsw i64 %t1058, 0
%t1060 = add nsw i64 %t1059, %t1055
ret i64 %t1060
L396:
%t1061 = call i64 @__mruntime_rt_text_resid__idx_scratch()
%t1062 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1061)
%t1063 = icmp eq i64 %t1062, %p0
br i1 %t1063, label %L397, label %L399
L397:
%t1064 = call i64 @__mruntime_rt_text_resid__idx_scratch()
ret i64 %t1064
L399:
%t1065 = call i64 @rt_arena_contains(i64 %p0)
%t1066 = icmp ne i64 %t1065, 0
br i1 %t1066, label %L400, label %L402
L400:
%t1067 = call i64 @__mruntime_rt_text_resid__idx_scratch()
%t1068 = call i64 @__mruntime_rt_text_resid__idx_build(i64 %p0, i64 %t1067)
%t1069 = call i64 @__mruntime_rt_text_resid__idx_scratch()
%t1070 = add i64 %t1069, 24
%t1071 = call i64 @st64(i64 %t1070, i64 %t1047)
%t1072 = mul nsw i64 %t1071, 0
%t1073 = call i64 @__mruntime_rt_text_resid__idx_scratch()
%t1074 = add nsw i64 %t1072, %t1073
ret i64 %t1074
L402:
%t1075 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t1076 = call i64 @__mruntime_rt_text_resid__idx_victim(i64 1, i64 %t1075)
%t1077 = call i64 @__mruntime_rt_text_resid__idx_build(i64 %p0, i64 %t1076)
%t1078 = add i64 %t1076, 24
%t1079 = call i64 @st64(i64 %t1078, i64 %t1047)
%t1080 = mul nsw i64 %t1079, 0
%t1081 = add nsw i64 %t1080, %t1076
ret i64 %t1081
}
define internal i64 @idx_slot(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1082 = call i64 @__mruntime_rt_text_resid__idx_state()
%t1083 = add i64 %t1082, 16
%t1084 = call i64 @ld64(i64 %t1083)
%t1085 = icmp ne i64 %t1084, 0
br label %LSL1086
LSL1086:
br i1 %t1085, label %LSR1086, label %LSJ1086
LSR1086:
%t1087 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1084)
%t1088 = icmp eq i64 %t1087, %p0
br label %LSJ1086
LSJ1086:
%t1089 = phi i1 [ false, %LSL1086 ], [ %t1088, %LSR1086 ]
br i1 %t1089, label %L403, label %L405
L403:
ret i64 %t1084
L405:
%t1090 = call i64 @__mruntime_rt_text_resid__idx_slot_miss(i64 %p0, i64 %t1082)
ret i64 %t1090
}
define internal i64 @__mruntime_rt_text_resid__idx_slot_miss(i64 %p0, i64 %p1) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1091 = call i64 @__mruntime_rt_text_resid__idx_slot_slow(i64 %p0)
%t1092 = add i64 %p1, 16
%t1093 = call i64 @st64(i64 %t1092, i64 %t1091)
%t1094 = call i64 @__mruntime_rt_text_resid__sl_off(i64 %t1091)
%t1095 = icmp eq i64 %t1094, 0
br i1 %t1095, label %L406, label %L407
L406:
%t1096 = add i64 %p1, 24
%t1097 = call i64 @st64(i64 %t1096, i64 %p0)
%t1098 = add i64 %p1, 32
%t1099 = call i64 @__mruntime_rt_text_resid__sl_len(i64 %t1091)
%t1100 = call i64 @st64(i64 %t1098, i64 %t1099)
%t1101 = add i64 %t1097, %t1100
br label %L408
L407:
br label %L408
L408:
%t1102 = phi i64 [ %t1101, %L406 ], [ 0, %L407 ]
ret i64 %t1091
}
define internal i64 @rt_str_index_popped() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1103 = call i64 @__mruntime_rt_text_resid__idx_state()
%t1104 = add i64 %t1103, 24
%t1105 = call i64 @st64(i64 %t1104, i64 0)
%t1106 = call i64 @__mruntime_rt_text_resid__idx_small()
%t1107 = call i64 @st64(i64 %t1106, i64 0)
%t1108 = call i64 @__mruntime_rt_text_resid__idx_scratch()
%t1109 = call i64 @st64(i64 %t1108, i64 0)
ret i64 %t1109
}
define void @resid_str_index_popped() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_str_index_popped()
ret void
}
define internal i64 @str_index_forget(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1110 = call i64 @__mruntime_rt_text_resid__idx_state()
%t1111 = add i64 %t1110, 24
%t1112 = call i64 @ld64(i64 %t1111)
%t1113 = icmp eq i64 %t1112, %p0
br i1 %t1113, label %L409, label %L410
L409:
%t1114 = add i64 %t1110, 24
%t1115 = call i64 @st64(i64 %t1114, i64 0)
br label %L411
L410:
br label %L411
L411:
%t1116 = phi i64 [ %t1115, %L409 ], [ 0, %L410 ]
%t1117 = call i64 @__mruntime_rt_text_resid__idx_small()
%t1118 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1117)
%t1119 = icmp eq i64 %t1118, %p0
br i1 %t1119, label %L412, label %L413
L412:
%t1120 = call i64 @__mruntime_rt_text_resid__idx_small()
%t1121 = call i64 @st64(i64 %t1120, i64 0)
br label %L414
L413:
br label %L414
L414:
%t1122 = phi i64 [ %t1121, %L412 ], [ 0, %L413 ]
%t1123 = call i64 @__mruntime_rt_text_resid__idx_scratch()
%t1124 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1123)
%t1125 = icmp eq i64 %t1124, %p0
br i1 %t1125, label %L415, label %L416
L415:
%t1126 = call i64 @__mruntime_rt_text_resid__idx_scratch()
%t1127 = call i64 @st64(i64 %t1126, i64 0)
br label %L417
L416:
br label %L417
L417:
%t1128 = phi i64 [ %t1127, %L415 ], [ 0, %L416 ]
%t1129 = add i64 %t1110, 8
%t1130 = call i64 @ld64(i64 %t1129)
%t1131 = icmp eq i64 %t1130, 0
br i1 %t1131, label %L418, label %L420
L418:
ret i64 0
L420:
%t1132 = call i64 @__mruntime_rt_text_resid__idx_forget_at(i64 %p0, i64 0)
ret i64 %t1132
}
define internal i64 @__mruntime_rt_text_resid__idx_forget_at(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1144, %tco.s0 ]
%t1133 = icmp sge i64 %p1, 16
br i1 %t1133, label %L421, label %L423
L421:
ret i64 0
L423:
%t1134 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t1135 = mul i64 %p1, 40
%t1136 = add i64 %t1134, %t1135
%t1137 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1136)
%t1138 = icmp eq i64 %t1137, %p0
br i1 %t1138, label %L424, label %L425
L424:
%t1139 = call i64 @st64(i64 %t1136, i64 0)
%t1140 = add i64 %t1136, 24
%t1141 = call i64 @st64(i64 %t1140, i64 0)
%t1142 = add i64 %t1139, %t1141
br label %L426
L425:
br label %L426
L426:
%t1143 = phi i64 [ %t1142, %L424 ], [ 0, %L425 ]
%t1144 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1146 = call i64 @__mruntime_rt_text_resid__idx_state()
%t1147 = add i64 %t1146, 24
%t1148 = call i64 @ld64(i64 %t1147)
%t1149 = icmp eq i64 %p0, %t1148
br i1 %t1149, label %L427, label %L429
L427:
%t1150 = add i64 %t1146, 32
%t1151 = tail call i64 @ld64(i64 %t1150)
ret i64 %t1151
L429:
%t1152 = call i64 @idx_slot(i64 %p0)
%t1153 = tail call i64 @__mruntime_rt_text_resid__sl_len(i64 %t1152)
ret i64 %t1153
}
define i64 @str_len(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_len(i64 %x0i)
ret i64 %r
}
define internal i64 @__mruntime_rt_text_resid__char_at_slow(i64 %p0, i64 %p1) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1154 = call i64 @idx_slot(i64 %p0)
%t1155 = call i64 @__mruntime_rt_text_resid__sl_len(i64 %t1154)
%t1156 = call i1 @ult(i64 %p1, i64 %t1155)
%t1157 = xor i1 %t1156, true
br i1 %t1157, label %L430, label %L432
L430:
%t1158 = sub nsw i64 0, 1
ret i64 %t1158
L432:
%t1159 = call i64 @__mruntime_rt_text_resid__sl_off(i64 %t1154)
%t1160 = icmp eq i64 %t1159, 0
br i1 %t1160, label %L433, label %L435
L433:
%t1161 = add i64 %p0, %p1
%t1162 = call i64 @ld8(i64 %t1161)
ret i64 %t1162
L435:
%t1163 = call i64 @slot_off(i64 %t1154, i64 %p1)
%t1164 = add i64 %p0, %t1163
%t1165 = call i64 @utf8_len_at(i64 %t1164)
%t1166 = tail call i64 @utf8_decode(i64 %t1164, i64 %t1165)
ret i64 %t1166
}
define internal i64 @rt_str_char_at(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1167 = call i64 @__mruntime_rt_text_resid__idx_state()
%t1168 = add i64 %t1167, 24
%t1169 = call i64 @ld64(i64 %t1168)
%t1170 = icmp eq i64 %p0, %t1169
br i1 %t1170, label %L436, label %L438
L436:
%t1171 = add i64 %t1167, 32
%t1172 = call i64 @ld64(i64 %t1171)
%t1173 = call i1 @ult(i64 %p1, i64 %t1172)
br i1 %t1173, label %L439, label %L440
L439:
%t1174 = add i64 %p0, %p1
%t1175 = call i64 @ld8(i64 %t1174)
br label %L441
L440:
%t1176 = sub nsw i64 0, 1
br label %L441
L441:
%t1177 = phi i64 [ %t1175, %L439 ], [ %t1176, %L440 ]
ret i64 %t1177
L438:
%t1178 = tail call i64 @__mruntime_rt_text_resid__char_at_slow(i64 %p0, i64 %p1)
ret i64 %t1178
}
define i64 @str_char_at(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_char_at(i64 %x0i, i64 %a1)
ret i64 %r
}
define internal i64 @rt_str_slice(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1179 = call i64 @idx_slot(i64 %p0)
%t1180 = call i64 @__mruntime_rt_text_resid__sl_len(i64 %t1179)
%t1181 = icmp slt i64 %p1, 0
br i1 %t1181, label %L442, label %L443
L442:
br label %L444
L443:
br label %L444
L444:
%t1182 = phi i64 [ 0, %L442 ], [ %p1, %L443 ]
%t1183 = icmp slt i64 %p2, %t1182
br i1 %t1183, label %L445, label %L446
L445:
br label %L447
L446:
br label %L447
L447:
%t1184 = phi i64 [ %t1182, %L445 ], [ %p2, %L446 ]
%t1185 = icmp sgt i64 %t1182, %t1180
br i1 %t1185, label %L448, label %L449
L448:
br label %L450
L449:
br label %L450
L450:
%t1186 = phi i64 [ %t1180, %L448 ], [ %t1182, %L449 ]
%t1187 = icmp sgt i64 %t1184, %t1180
br i1 %t1187, label %L451, label %L452
L451:
br label %L453
L452:
br label %L453
L453:
%t1188 = phi i64 [ %t1180, %L451 ], [ %t1184, %L452 ]
%t1189 = call i64 @slot_off(i64 %t1179, i64 %t1186)
%t1190 = call i64 @slot_off(i64 %t1179, i64 %t1188)
%t1191 = add i64 %p0, %t1189
%t1192 = sub i64 %t1190, %t1189
%t1193 = tail call i64 @cstr_from(i64 %t1191, i64 %t1192, i64 1)
ret i64 %t1193
}
define ptr @str_slice(ptr %a0, i64 %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_slice(i64 %x0i, i64 %a1, i64 %a2)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_text_resid__byte_common(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1194 = icmp sge i64 %p0, 97
br label %LSL1195
LSL1195:
br i1 %t1194, label %LSR1195, label %LSJ1195
LSR1195:
%t1196 = icmp sle i64 %p0, 122
br label %LSJ1195
LSJ1195:
%t1197 = phi i1 [ false, %LSL1195 ], [ %t1196, %LSR1195 ]
br label %LSL1198
LSL1198:
br i1 %t1197, label %LSJ1198, label %LSR1198
LSR1198:
%t1199 = icmp eq i64 %p0, 32
br label %LSJ1198
LSJ1198:
%t1200 = phi i1 [ true, %LSL1198 ], [ %t1199, %LSR1198 ]
br label %LSL1201
LSL1201:
br i1 %t1200, label %LSJ1201, label %LSR1201
LSR1201:
%t1202 = icmp eq i64 %p0, 10
br label %LSJ1201
LSJ1201:
%t1203 = phi i1 [ true, %LSL1201 ], [ %t1202, %LSR1201 ]
br i1 %t1203, label %L454, label %L456
L454:
ret i64 3
L456:
%t1204 = icmp sge i64 %p0, 65
br label %LSL1205
LSL1205:
br i1 %t1204, label %LSR1205, label %LSJ1205
LSR1205:
%t1206 = icmp sle i64 %p0, 90
br label %LSJ1205
LSJ1205:
%t1207 = phi i1 [ false, %LSL1205 ], [ %t1206, %LSR1205 ]
br label %LSL1208
LSL1208:
br i1 %t1207, label %LSJ1208, label %LSR1208
LSR1208:
%t1209 = icmp sge i64 %p0, 48
br label %LSL1210
LSL1210:
br i1 %t1209, label %LSR1210, label %LSJ1210
LSR1210:
%t1211 = icmp sle i64 %p0, 57
br label %LSJ1210
LSJ1210:
%t1212 = phi i1 [ false, %LSL1210 ], [ %t1211, %LSR1210 ]
br label %LSJ1208
LSJ1208:
%t1213 = phi i1 [ true, %LSL1208 ], [ %t1212, %LSJ1210 ]
br i1 %t1213, label %L457, label %L459
L457:
ret i64 2
L459:
ret i64 1
}
define internal i64 @__mruntime_rt_text_resid__rarest(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1222, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1223, %tco.s0 ]
%t1214 = icmp sge i64 %p1, %p2
br i1 %t1214, label %L460, label %L462
L460:
ret i64 %p3
L462:
%t1215 = add i64 %p0, %p1
%t1216 = call i64 @ld8(i64 %t1215)
%t1217 = call i64 @__mruntime_rt_text_resid__byte_common(i64 %t1216)
%t1218 = add i64 %p0, %p3
%t1219 = call i64 @ld8(i64 %t1218)
%t1220 = call i64 @__mruntime_rt_text_resid__byte_common(i64 %t1219)
%t1221 = icmp slt i64 %t1217, %t1220
%t1222 = add nsw i64 %p1, 1
br i1 %t1221, label %L463, label %L464
L463:
br label %L465
L464:
br label %L465
L465:
%t1223 = phi i64 [ %p1, %L463 ], [ %p3, %L464 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @find_bytes(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1225 = icmp eq i64 %p3, 0
br i1 %t1225, label %L466, label %L468
L466:
ret i64 %p0
L468:
%t1226 = icmp sgt i64 %p3, %p1
br i1 %t1226, label %L469, label %L471
L469:
ret i64 0
L471:
%t1227 = call i64 @__mruntime_rt_text_resid__rarest(i64 %p2, i64 1, i64 %p3, i64 0)
%t1228 = add i64 %p0, %p1
%t1229 = add i64 %p0, %t1227
%t1230 = call i64 @__mruntime_rt_text_resid__find_from(i64 %p0, i64 %t1228, i64 %p2, i64 %p3, i64 %t1227, i64 %t1229, i64 0)
ret i64 %t1230
}
define internal i64 @__mruntime_rt_text_resid__find_from(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t1243, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %t1244, %tco.s0 ]
%t1231 = sub i64 %p3, 1
%t1232 = sub i64 %t1231, %p4
%t1233 = sub i64 %p1, %t1232
%t1234 = icmp sge i64 %p5, %t1233
br i1 %t1234, label %L472, label %L474
L472:
ret i64 0
L474:
%t1235 = add i64 %p2, %p4
%t1236 = call i64 @ld8(i64 %t1235)
%t1237 = sub i64 %t1233, %p5
%t1238 = call i64 @c_memchr(i64 %p5, i64 %t1236, i64 %t1237)
%t1239 = icmp eq i64 %t1238, 0
br i1 %t1239, label %L475, label %L477
L475:
ret i64 0
L477:
%t1240 = sub i64 %t1238, %p4
%t1241 = call i64 @c_memcmp(i64 %t1240, i64 %p2, i64 %p3)
%t1242 = icmp eq i64 %t1241, 0
br i1 %t1242, label %L478, label %L480
L478:
ret i64 %t1240
L480:
%t1243 = add i64 %t1238, 1
%t1244 = add i64 %p6, 1
%t1245 = icmp sgt i64 %t1244, 64
br label %LSL1246
LSL1246:
br i1 %t1245, label %LSR1246, label %LSJ1246
LSR1246:
%t1247 = sub i64 %t1243, %p0
%t1248 = mul i64 %t1244, 16
%t1249 = icmp slt i64 %t1247, %t1248
br label %LSJ1246
LSJ1246:
%t1250 = phi i1 [ false, %LSL1246 ], [ %t1249, %LSR1246 ]
br i1 %t1250, label %L481, label %L483
L481:
%t1251 = add i64 %t1240, 1
%t1252 = sub i64 %p1, %t1240
%t1253 = sub i64 %t1252, 1
%t1254 = call i64 @c_memmem(i64 %t1251, i64 %t1253, i64 %p2, i64 %p3)
ret i64 %t1254
L483:
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_index_of(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1256 = call i64 @idx_slot(i64 %p0)
%t1257 = call i64 @__mruntime_rt_text_resid__sl_len(i64 %t1256)
%t1258 = icmp slt i64 %p2, 0
br i1 %t1258, label %L484, label %L485
L484:
br label %L486
L485:
br label %L486
L486:
%t1259 = phi i64 [ 0, %L484 ], [ %p2, %L485 ]
%t1260 = icmp sgt i64 %t1259, %t1257
br i1 %t1260, label %L487, label %L489
L487:
%t1261 = sub nsw i64 0, 1
ret i64 %t1261
L489:
%t1262 = call i64 @slot_off(i64 %t1256, i64 %t1259)
%t1263 = add i64 %p0, %t1262
%t1264 = call i64 @__mruntime_rt_text_resid__sl_blen(i64 %t1256)
%t1265 = sub i64 %t1264, %t1262
%t1266 = call i64 @c_strlen(i64 %p1)
%t1267 = call i64 @find_bytes(i64 %t1263, i64 %t1265, i64 %p1, i64 %t1266)
%t1268 = icmp eq i64 %t1267, 0
br i1 %t1268, label %L490, label %L492
L490:
%t1269 = sub nsw i64 0, 1
ret i64 %t1269
L492:
%t1270 = sub i64 %t1267, %p0
%t1271 = call i64 @__mruntime_rt_text_resid__sl_off(i64 %t1256)
%t1272 = icmp eq i64 %t1271, 0
br i1 %t1272, label %L493, label %L495
L493:
ret i64 %t1270
L495:
%t1273 = ashr i64 %t1257, 4
%t1274 = call i64 @__mruntime_rt_text_resid__ck_search(i64 %t1271, i64 %t1270, i64 0, i64 %t1273)
%t1275 = mul i64 %t1274, 8
%t1276 = add i64 %t1271, %t1275
%t1277 = call i64 @ld64(i64 %t1276)
%t1278 = add i64 %p0, %t1277
%t1279 = add i64 %p0, %t1270
%t1280 = shl i64 %t1274, 4
%t1281 = tail call i64 @__mruntime_rt_text_resid__cp_walk(i64 %t1278, i64 %t1279, i64 %t1280)
ret i64 %t1281
}
define i64 @str_index_of(ptr %a0, ptr %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_str_index_of(i64 %x0i, i64 %x1i, i64 %a2)
ret i64 %r
}
define internal i64 @__mruntime_rt_text_resid__ck_search(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1285, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ], [ %t1291, %tco.s1 ]
%t1282 = icmp sge i64 %p2, %p3
br i1 %t1282, label %L496, label %L498
L496:
ret i64 %p2
L498:
%t1283 = add i64 %p2, %p3
%t1284 = add i64 %t1283, 1
%t1285 = sdiv i64 %t1284, 2
%t1286 = mul i64 %t1285, 8
%t1287 = add i64 %p0, %t1286
%t1288 = call i64 @ld64(i64 %t1287)
%t1289 = icmp sle i64 %t1288, %p1
br i1 %t1289, label %L499, label %L501
L499:
br label %tco.s0
tco.s0:
br label %tco.head
L501:
%t1291 = sub nsw i64 %t1285, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__cp_walk(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1295, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1296, %tco.s0 ]
%t1293 = icmp sge i64 %p0, %p1
br i1 %t1293, label %L502, label %L504
L502:
ret i64 %p2
L504:
%t1294 = call i64 @utf8_len_at(i64 %p0)
%t1295 = add i64 %p0, %t1294
%t1296 = add i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__sb_grow(i64 %p0, i64 %p1) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1298 = add i64 %p0, 8
%t1299 = call i64 @ld64(i64 %t1298)
%t1300 = add i64 %p0, 16
%t1301 = call i64 @ld64(i64 %t1300)
%t1302 = icmp eq i64 %t1301, 0
br i1 %t1302, label %L505, label %L506
L505:
br label %L507
L506:
%t1303 = mul i64 %t1301, 2
br label %L507
L507:
%t1304 = phi i64 [ 64, %L505 ], [ %t1303, %L506 ]
%t1305 = add i64 %t1299, %p1
%t1306 = icmp slt i64 %t1304, %t1305
br i1 %t1306, label %L508, label %L509
L508:
%t1307 = add i64 %t1299, %p1
br label %L510
L509:
br label %L510
L510:
%t1308 = phi i64 [ %t1307, %L508 ], [ %t1304, %L509 ]
%t1309 = call i64 @ld64(i64 %p0)
%t1310 = add i64 %t1308, 1
%t1311 = call i64 @xrealloc(i64 %t1309, i64 %t1310)
%t1312 = call i64 @st64(i64 %p0, i64 %t1311)
%t1313 = add i64 %p0, 16
%t1314 = tail call i64 @st64(i64 %t1313, i64 %t1308)
ret i64 %t1314
}
define internal i64 @sb_bytes(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1315 = add i64 %p0, 16
%t1316 = call i64 @ld64(i64 %t1315)
%t1317 = add i64 %p0, 8
%t1318 = call i64 @ld64(i64 %t1317)
%t1319 = sub i64 %t1316, %t1318
%t1320 = icmp slt i64 %t1319, %p2
br i1 %t1320, label %L511, label %L512
L511:
%t1321 = call i64 @__mruntime_rt_text_resid__sb_grow(i64 %p0, i64 %p2)
br label %L513
L512:
br label %L513
L513:
%t1322 = phi i64 [ %t1321, %L511 ], [ 0, %L512 ]
%t1323 = add i64 %p0, 8
%t1324 = call i64 @ld64(i64 %t1323)
%t1325 = call i64 @ld64(i64 %p0)
%t1326 = add i64 %t1325, %t1324
%t1327 = call i64 @mcopy(i64 %t1326, i64 %p1, i64 %p2)
%t1328 = add i64 %p0, 8
%t1329 = add i64 %t1324, %p2
%t1330 = call i64 @st64(i64 %t1328, i64 %t1329)
ret i64 %t1330
}
define internal i64 @rt_sb_new() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1331 = call i64 @xmalloc(i64 24)
%t1332 = call i64 @st64(i64 %t1331, i64 0)
%t1333 = add i64 %t1331, 8
%t1334 = call i64 @st64(i64 %t1333, i64 0)
%t1335 = add i64 %t1331, 16
%t1336 = call i64 @st64(i64 %t1335, i64 0)
ret i64 %t1331
}
define ptr @str_sb_new() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_sb_new()
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_sb_append(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1337 = call i64 @c_strlen(i64 %p1)
%t1338 = call i64 @sb_bytes(i64 %p0, i64 %p1, i64 %t1337)
%t1339 = mul nsw i64 %t1338, 0
%t1340 = add nsw i64 %t1339, %p0
ret i64 %t1340
}
define ptr @str_sb_append(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_sb_append(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_sb_append_cp(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1341 = add i64 %p0, 8
%t1342 = call i64 @ld64(i64 %t1341)
%t1343 = call i1 @ult(i64 %p1, i64 128)
br label %LSL1344
LSL1344:
br i1 %t1343, label %LSR1344, label %LSJ1344
LSR1344:
%t1345 = add i64 %p0, 16
%t1346 = call i64 @ld64(i64 %t1345)
%t1347 = icmp slt i64 %t1342, %t1346
br label %LSJ1344
LSJ1344:
%t1348 = phi i1 [ false, %LSL1344 ], [ %t1347, %LSR1344 ]
br i1 %t1348, label %L514, label %L516
L514:
%t1349 = call i64 @ld64(i64 %p0)
%t1350 = add i64 %t1349, %t1342
%t1351 = call i64 @st8(i64 %t1350, i64 %p1)
%t1352 = add i64 %p0, 8
%t1353 = add nsw i64 %t1342, 1
%t1354 = call i64 @st64(i64 %t1352, i64 %t1353)
%t1355 = mul nsw i64 %t1354, 0
%t1356 = add nsw i64 %t1355, %p0
ret i64 %t1356
L516:
%t1357 = tail call i64 @__mruntime_rt_text_resid__sb_cp_slow(i64 %p0, i64 %p1)
ret i64 %t1357
}
define ptr @str_sb_append_cp(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_sb_append_cp(i64 %x0i, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_text_resid__sb_cp_slow(i64 %p0, i64 %p1) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1358p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.sb_cp)
%t1358 = ptrtoint ptr %t1358p to i64
%t1359 = call i64 @utf8_encode(i64 %p1, i64 %t1358)
%t1360 = call i64 @sb_bytes(i64 %p0, i64 %t1358, i64 %t1359)
%t1361 = mul nsw i64 %t1360, 0
%t1362 = add nsw i64 %t1361, %p0
ret i64 %t1362
}
define internal i64 @rt_sb_finish(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1363 = call i64 @ld64(i64 %p0)
%t1364 = add i64 %p0, 8
%t1365 = call i64 @ld64(i64 %t1364)
%t1366 = add i64 %p0, 16
%t1367 = call i64 @ld64(i64 %t1366)
%t1368 = icmp eq i64 %t1363, 0
br i1 %t1368, label %L517, label %L518
L517:
%t1369 = call i64 @xmalloc(i64 1)
br label %L519
L518:
br label %L519
L519:
%t1370 = phi i64 [ %t1369, %L517 ], [ %t1363, %L518 ]
%t1371 = icmp ne i64 %t1363, 0
br label %LSL1372
LSL1372:
br i1 %t1371, label %LSR1372, label %LSJ1372
LSR1372:
%t1373 = sdiv i64 %t1365, 8
%t1374 = add i64 %t1365, %t1373
%t1375 = add i64 %t1374, 64
%t1376 = icmp sgt i64 %t1367, %t1375
br label %LSJ1372
LSJ1372:
%t1377 = phi i1 [ false, %LSL1372 ], [ %t1376, %LSR1372 ]
br i1 %t1377, label %L520, label %L521
L520:
%t1378 = call i64 @__mruntime_rt_text_resid__sb_shrink(i64 %t1370, i64 %t1365)
br label %L522
L521:
br label %L522
L522:
%t1379 = phi i64 [ %t1378, %L520 ], [ %t1370, %L521 ]
%t1380 = add i64 %t1379, %t1365
%t1381 = call i64 @st8(i64 %t1380, i64 0)
%t1382 = call i64 @c_free(i64 %p0)
ret i64 %t1379
}
define ptr @str_sb_finish(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_sb_finish(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_text_resid__sb_shrink(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1383 = add i64 %p1, 1
%t1384 = call i64 @c_realloc(i64 %p0, i64 %t1383)
%t1385 = icmp eq i64 %t1384, 0
br i1 %t1385, label %L523, label %L524
L523:
br label %L525
L524:
br label %L525
L525:
%t1386 = phi i64 [ %p0, %L523 ], [ %t1384, %L524 ]
ret i64 %t1386
}
define internal i1 @rt_sb_print(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1387 = call i64 @ld64(i64 %p0)
%t1388 = add i64 %p0, 8
%t1389 = call i64 @ld64(i64 %t1388)
%t1390 = icmp ne i64 %p1, 0
br i1 %t1390, label %L526, label %L527
L526:
%t1391 = icmp eq i64 %t1387, 0
br i1 %t1391, label %L529, label %L530
L529:
%t1393 = ptrtoint ptr @.s1392 to i64
br label %L531
L530:
br label %L531
L531:
%t1394 = phi i64 [ %t1393, %L529 ], [ %t1387, %L530 ]
%t1395 = call i1 @write_line(i64 1, i64 %t1394, i64 %t1389)
br label %L528
L527:
%t1396 = icmp eq i64 %t1387, 0
br label %LSL1397
LSL1397:
br i1 %t1396, label %LSJ1397, label %LSR1397
LSR1397:
%t1398 = call i1 @write_all(i64 1, i64 %t1387, i64 %t1389)
br label %LSJ1397
LSJ1397:
%t1399 = phi i1 [ true, %LSL1397 ], [ %t1398, %LSR1397 ]
br label %L528
L528:
%t1400 = phi i1 [ %t1395, %L531 ], [ %t1399, %LSJ1397 ]
%t1401 = call i64 @c_free(i64 %t1387)
%t1402 = call i64 @c_free(i64 %p0)
ret i1 %t1400
}
define i1 @resid_sb_print(ptr %a0, i8 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1 = zext i8 %a1 to i64
%r = call i1 @rt_sb_print(i64 %x0i, i64 %x1)
ret i1 %r
}
define internal i64 @rt_str_from_codepoints(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1403 = call i64 @lcount(i64 %p0)
%t1404 = icmp sle i64 %t1403, 0
br i1 %t1404, label %L532, label %L534
L532:
%t1406 = ptrtoint ptr @.s1405 to i64
%t1407 = tail call i64 @cstr_dup(i64 %t1406)
ret i64 %t1407
L534:
%t1408 = mul i64 4, %t1403
%t1409 = add i64 %t1408, 1
%t1410 = call i64 @xmalloc(i64 %t1409)
%t1411 = call i64 @__mruntime_rt_text_resid__cps_out(i64 %p0, i64 %t1410, i64 0, i64 0, i64 %t1403)
%t1412 = add i64 %t1410, %t1411
%t1413 = call i64 @st8(i64 %t1412, i64 0)
%t1414 = mul nsw i64 %t1413, 0
%t1415 = add nsw i64 %t1414, %t1410
ret i64 %t1415
}
define ptr @resid_str_from_codepoints(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_from_codepoints(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_text_resid__cps_out(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1421, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1422, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t1416 = icmp sge i64 %p3, %p4
br i1 %t1416, label %L535, label %L537
L535:
ret i64 %p2
L537:
%t1417 = call i64 @rt_list_get(i64 %p0, i64 %p3)
%t1418 = call i64 @unbox_word(i64 %t1417)
%t1419 = add i64 %p1, %p2
%t1420 = call i64 @utf8_encode(i64 %t1418, i64 %t1419)
%t1421 = add i64 %p2, %t1420
%t1422 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @case_lower_tab() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1424 = ptrtoint ptr @rtt.8615 to i64
ret i64 %t1424
}
define internal i64 @case_lower_n() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 1459
}
define internal i64 @case_upper_tab() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1425 = ptrtoint ptr @rtt.11526 to i64
ret i64 %t1425
}
define internal i64 @case_upper_n() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 1450
}
define internal i64 @case_special_tab() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1426 = ptrtoint ptr @rtt.12450 to i64
ret i64 %t1426
}
define internal i64 @case_special_n() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 83
}
define internal i64 @__mruntime_rt_case_resid__case_lookup(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1427 = sub i64 %p1, 1
%t1428 = call i64 @__mruntime_rt_case_resid__case_bs(i64 %p0, i64 %p2, i64 0, i64 %t1427)
ret i64 %t1428
}
define internal i64 @__mruntime_rt_case_resid__case_bs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %t1444, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1442, %tco.s0 ], [ %p3, %tco.s1 ]
%t1429 = icmp sgt i64 %p2, %p3
br i1 %t1429, label %L538, label %L540
L538:
ret i64 0
L540:
%t1430 = sub i64 %p3, %p2
%t1431 = sdiv i64 %t1430, 2
%t1432 = add i64 %p2, %t1431
%t1433 = mul i64 %t1432, 16
%t1434 = add i64 %p0, %t1433
%t1435 = call i64 @ld64(i64 %t1434)
%t1436 = icmp eq i64 %p1, %t1435
br i1 %t1436, label %L541, label %L543
L541:
%t1437 = mul i64 %t1432, 16
%t1438 = add i64 %p0, %t1437
%t1439 = add i64 %t1438, 8
%t1440 = call i64 @ld64(i64 %t1439)
ret i64 %t1440
L543:
%t1441 = icmp slt i64 %p1, %t1435
br i1 %t1441, label %L544, label %L546
L544:
%t1442 = sub i64 %t1432, 1
br label %tco.s0
tco.s0:
br label %tco.head
L546:
%t1444 = add i64 %t1432, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @case_simple(i64 %p0, i1 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br i1 %p1, label %L547, label %L548
L547:
%t1446 = call i64 @case_lower_tab()
%t1447 = call i64 @case_lower_n()
%t1448 = call i64 @__mruntime_rt_case_resid__case_lookup(i64 %t1446, i64 %t1447, i64 %p0)
br label %L549
L548:
%t1449 = call i64 @case_upper_tab()
%t1450 = call i64 @case_upper_n()
%t1451 = call i64 @__mruntime_rt_case_resid__case_lookup(i64 %t1449, i64 %t1450, i64 %p0)
br label %L549
L549:
%t1452 = phi i64 [ %t1448, %L547 ], [ %t1451, %L548 ]
%t1453 = icmp ne i64 %t1452, 0
br i1 %t1453, label %L550, label %L551
L550:
br label %L552
L551:
br label %L552
L552:
%t1454 = phi i64 [ %t1452, %L550 ], [ %p0, %L551 ]
ret i64 %t1454
}
define internal i64 @__mruntime_rt_case_resid__special_upper(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1455 = call i64 @case_special_tab()
%t1456 = call i64 @case_special_n()
%t1457 = sub i64 %t1456, 1
%t1458 = call i64 @__mruntime_rt_case_resid__special_bs(i64 %t1455, i64 %p0, i64 0, i64 %t1457)
ret i64 %t1458
}
define internal i64 @__mruntime_rt_case_resid__special_bs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %t1470, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1468, %tco.s0 ], [ %p3, %tco.s1 ]
%t1459 = icmp sgt i64 %p2, %p3
br i1 %t1459, label %L553, label %L555
L553:
ret i64 0
L555:
%t1460 = sub i64 %p3, %p2
%t1461 = sdiv i64 %t1460, 2
%t1462 = add i64 %p2, %t1461
%t1463 = mul i64 %t1462, 88
%t1464 = add i64 %p0, %t1463
%t1465 = call i64 @ld64(i64 %t1464)
%t1466 = icmp eq i64 %p1, %t1465
br i1 %t1466, label %L556, label %L558
L556:
ret i64 %t1464
L558:
%t1467 = icmp slt i64 %p1, %t1465
br i1 %t1467, label %L559, label %L561
L559:
%t1468 = sub i64 %t1462, 1
br label %tco.s0
tco.s0:
br label %tco.head
L561:
%t1470 = add i64 %t1462, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i1 @__mruntime_rt_case_resid__is_cased(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1472 = call i64 @case_lower_tab()
%t1473 = call i64 @case_lower_n()
%t1474 = call i64 @__mruntime_rt_case_resid__case_lookup(i64 %t1472, i64 %t1473, i64 %p0)
%t1475 = icmp ne i64 %t1474, 0
br label %LSL1476
LSL1476:
br i1 %t1475, label %LSJ1476, label %LSR1476
LSR1476:
%t1477 = call i64 @case_upper_tab()
%t1478 = call i64 @case_upper_n()
%t1479 = call i64 @__mruntime_rt_case_resid__case_lookup(i64 %t1477, i64 %t1478, i64 %p0)
%t1480 = icmp ne i64 %t1479, 0
br label %LSJ1476
LSJ1476:
%t1481 = phi i1 [ true, %LSL1476 ], [ %t1480, %LSR1476 ]
ret i1 %t1481
}
define internal i1 @__mruntime_rt_case_resid__is_ignorable(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1482 = call i1 @__mruntime_rt_case_resid__is_cased(i64 %p0)
br i1 %t1482, label %L562, label %L564
L562:
ret i1 false
L564:
%t1483 = icmp sge i64 %p0, 768
br label %LSL1484
LSL1484:
br i1 %t1483, label %LSR1484, label %LSJ1484
LSR1484:
%t1485 = icmp sle i64 %p0, 879
br label %LSJ1484
LSJ1484:
%t1486 = phi i1 [ false, %LSL1484 ], [ %t1485, %LSR1484 ]
br label %LSL1487
LSL1487:
br i1 %t1486, label %LSJ1487, label %LSR1487
LSR1487:
%t1488 = icmp sge i64 %p0, 1155
br label %LSL1489
LSL1489:
br i1 %t1488, label %LSR1489, label %LSJ1489
LSR1489:
%t1490 = icmp sle i64 %p0, 1161
br label %LSJ1489
LSJ1489:
%t1491 = phi i1 [ false, %LSL1489 ], [ %t1490, %LSR1489 ]
br label %LSJ1487
LSJ1487:
%t1492 = phi i1 [ true, %LSL1487 ], [ %t1491, %LSJ1489 ]
br label %LSL1493
LSL1493:
br i1 %t1492, label %LSJ1493, label %LSR1493
LSR1493:
%t1494 = icmp sge i64 %p0, 1425
br label %LSL1495
LSL1495:
br i1 %t1494, label %LSR1495, label %LSJ1495
LSR1495:
%t1496 = icmp sle i64 %p0, 1469
br label %LSJ1495
LSJ1495:
%t1497 = phi i1 [ false, %LSL1495 ], [ %t1496, %LSR1495 ]
br label %LSJ1493
LSJ1493:
%t1498 = phi i1 [ true, %LSL1493 ], [ %t1497, %LSJ1495 ]
br label %LSL1499
LSL1499:
br i1 %t1498, label %LSJ1499, label %LSR1499
LSR1499:
%t1500 = icmp sge i64 %p0, 1552
br label %LSL1501
LSL1501:
br i1 %t1500, label %LSR1501, label %LSJ1501
LSR1501:
%t1502 = icmp sle i64 %p0, 1562
br label %LSJ1501
LSJ1501:
%t1503 = phi i1 [ false, %LSL1501 ], [ %t1502, %LSR1501 ]
br label %LSJ1499
LSJ1499:
%t1504 = phi i1 [ true, %LSL1499 ], [ %t1503, %LSJ1501 ]
br label %LSL1505
LSL1505:
br i1 %t1504, label %LSJ1505, label %LSR1505
LSR1505:
%t1506 = icmp sge i64 %p0, 1611
br label %LSL1507
LSL1507:
br i1 %t1506, label %LSR1507, label %LSJ1507
LSR1507:
%t1508 = icmp sle i64 %p0, 1631
br label %LSJ1507
LSJ1507:
%t1509 = phi i1 [ false, %LSL1507 ], [ %t1508, %LSR1507 ]
br label %LSJ1505
LSJ1505:
%t1510 = phi i1 [ true, %LSL1505 ], [ %t1509, %LSJ1507 ]
br label %LSL1511
LSL1511:
br i1 %t1510, label %LSJ1511, label %LSR1511
LSR1511:
%t1512 = icmp sge i64 %p0, 3633
br label %LSL1513
LSL1513:
br i1 %t1512, label %LSR1513, label %LSJ1513
LSR1513:
%t1514 = icmp sle i64 %p0, 3642
br label %LSJ1513
LSJ1513:
%t1515 = phi i1 [ false, %LSL1513 ], [ %t1514, %LSR1513 ]
br label %LSJ1511
LSJ1511:
%t1516 = phi i1 [ true, %LSL1511 ], [ %t1515, %LSJ1513 ]
br label %LSL1517
LSL1517:
br i1 %t1516, label %LSJ1517, label %LSR1517
LSR1517:
%t1518 = icmp sge i64 %p0, 8204
br label %LSL1519
LSL1519:
br i1 %t1518, label %LSR1519, label %LSJ1519
LSR1519:
%t1520 = icmp sle i64 %p0, 8207
br label %LSJ1519
LSJ1519:
%t1521 = phi i1 [ false, %LSL1519 ], [ %t1520, %LSR1519 ]
br label %LSJ1517
LSJ1517:
%t1522 = phi i1 [ true, %LSL1517 ], [ %t1521, %LSJ1519 ]
br label %LSL1523
LSL1523:
br i1 %t1522, label %LSJ1523, label %LSR1523
LSR1523:
%t1524 = icmp sge i64 %p0, 65024
br label %LSL1525
LSL1525:
br i1 %t1524, label %LSR1525, label %LSJ1525
LSR1525:
%t1526 = icmp sle i64 %p0, 65039
br label %LSJ1525
LSJ1525:
%t1527 = phi i1 [ false, %LSL1525 ], [ %t1526, %LSR1525 ]
br label %LSJ1523
LSJ1523:
%t1528 = phi i1 [ true, %LSL1523 ], [ %t1527, %LSJ1525 ]
ret i1 %t1528
}
define internal i1 @__mruntime_rt_case_resid__prev_cased(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1531, %tco.s0 ]
%t1529 = icmp sle i64 %p1, %p0
br i1 %t1529, label %L565, label %L567
L565:
ret i1 false
L567:
%t1530 = sub nsw i64 %p1, 1
%t1531 = call i64 @__mruntime_rt_case_resid__back_lead(i64 %p0, i64 %t1530)
%t1532 = sub i64 %p1, %t1531
%t1533 = call i64 @utf8_decode(i64 %t1531, i64 %t1532)
%t1534 = call i1 @__mruntime_rt_case_resid__is_ignorable(i64 %t1533)
%t1535 = xor i1 %t1534, true
br i1 %t1535, label %L568, label %L570
L568:
%t1536 = call i1 @__mruntime_rt_case_resid__is_cased(i64 %t1533)
ret i1 %t1536
L570:
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_case_resid__back_lead(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1548, %tco.s0 ]
%t1538 = call i64 @ld8(i64 %p1)
%t1539 = and i64 %t1538, 128
%t1540 = icmp eq i64 %t1539, 0
br i1 %t1540, label %L571, label %L573
L571:
ret i64 %p1
L573:
%t1541 = icmp sgt i64 %p1, %p0
br label %LSL1542
LSL1542:
br i1 %t1541, label %LSR1542, label %LSJ1542
LSR1542:
%t1543 = sub nsw i64 %p1, 1
%t1544 = call i64 @ld8(i64 %t1543)
%t1545 = and i64 %t1544, 192
%t1546 = icmp eq i64 %t1545, 128
br label %LSJ1542
LSJ1542:
%t1547 = phi i1 [ false, %LSL1542 ], [ %t1546, %LSR1542 ]
br i1 %t1547, label %L574, label %L576
L574:
%t1548 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L576:
%t1550 = icmp sgt i64 %p1, %p0
br label %LSL1551
LSL1551:
br i1 %t1550, label %LSR1551, label %LSJ1551
LSR1551:
%t1552 = call i64 @ld8(i64 %p1)
%t1553 = and i64 %t1552, 192
%t1554 = icmp eq i64 %t1553, 128
br label %LSJ1551
LSJ1551:
%t1555 = phi i1 [ false, %LSL1551 ], [ %t1554, %LSR1551 ]
br i1 %t1555, label %L577, label %L578
L577:
%t1556 = sub nsw i64 %p1, 1
br label %L579
L578:
br label %L579
L579:
%t1557 = phi i64 [ %t1556, %L577 ], [ %p1, %L578 ]
ret i64 %t1557
}
define internal i1 @__mruntime_rt_case_resid__next_cased(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1565, %tco.s0 ]
%t1558 = call i64 @ld8(i64 %p0)
%t1559 = icmp eq i64 %t1558, 0
br i1 %t1559, label %L580, label %L582
L580:
ret i1 false
L582:
%t1560 = call i64 @utf8_len_at(i64 %p0)
%t1561 = call i64 @utf8_decode(i64 %p0, i64 %t1560)
%t1562 = call i1 @__mruntime_rt_case_resid__is_ignorable(i64 %t1561)
%t1563 = xor i1 %t1562, true
br i1 %t1563, label %L583, label %L585
L583:
%t1564 = tail call i1 @__mruntime_rt_case_resid__is_cased(i64 %t1561)
ret i1 %t1564
L585:
%t1565 = add i64 %p0, %t1560
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_case_resid__lower_at(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1581, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1583, %tco.s0 ]
%t1567 = call i64 @ld8(i64 %p1)
%t1568 = icmp eq i64 %t1567, 0
br i1 %t1568, label %L586, label %L588
L586:
ret i64 %p2
L588:
%t1569 = call i64 @utf8_len_at(i64 %p1)
%t1570 = call i64 @utf8_decode(i64 %p1, i64 %t1569)
%t1571 = icmp eq i64 %t1570, 931
br i1 %t1571, label %L589, label %L590
L589:
%t1572 = call i1 @__mruntime_rt_case_resid__prev_cased(i64 %p0, i64 %p1)
br label %LSL1573
LSL1573:
br i1 %t1572, label %LSR1573, label %LSJ1573
LSR1573:
%t1574 = add i64 %p1, %t1569
%t1575 = call i1 @__mruntime_rt_case_resid__next_cased(i64 %t1574)
%t1576 = xor i1 %t1575, true
br label %LSJ1573
LSJ1573:
%t1577 = phi i1 [ false, %LSL1573 ], [ %t1576, %LSR1573 ]
br i1 %t1577, label %L592, label %L593
L592:
br label %L594
L593:
br label %L594
L594:
%t1578 = phi i64 [ 962, %L592 ], [ 963, %L593 ]
br label %L591
L590:
%t1579 = call i64 @case_simple(i64 %t1570, i1 true)
br label %L591
L591:
%t1580 = phi i64 [ %t1578, %L594 ], [ %t1579, %L590 ]
%t1581 = add i64 %p1, %t1569
%t1582 = call i64 @utf8_encode(i64 %t1580, i64 %p2)
%t1583 = add i64 %p2, %t1582
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_to_lower(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1585 = call i64 @rt_str_len(i64 %p0)
%t1586 = mul i64 %t1585, 4
%t1587 = add i64 %t1586, 8
%t1588 = call i64 @xmalloc(i64 %t1587)
%t1589 = call i64 @__mruntime_rt_case_resid__lower_at(i64 %p0, i64 %p0, i64 %t1588)
%t1590 = call i64 @st8(i64 %t1589, i64 0)
ret i64 %t1588
}
define ptr @str_to_lower(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_to_lower(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_case_resid__upper_at(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1604, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1605, %tco.s0 ]
%t1591 = call i64 @ld8(i64 %p0)
%t1592 = icmp eq i64 %t1591, 0
br i1 %t1592, label %L595, label %L597
L595:
ret i64 %p1
L597:
%t1593 = call i64 @utf8_len_at(i64 %p0)
%t1594 = call i64 @utf8_decode(i64 %p0, i64 %t1593)
%t1595 = call i64 @__mruntime_rt_case_resid__special_upper(i64 %t1594)
%t1596 = icmp ne i64 %t1595, 0
br i1 %t1596, label %L598, label %L599
L598:
%t1597 = add i64 %t1595, 16
%t1598 = add i64 %t1595, 8
%t1599 = call i64 @ld64(i64 %t1598)
%t1600 = call i64 @__mruntime_rt_case_resid__copy_words(i64 %p1, i64 %t1597, i64 %t1599)
br label %L600
L599:
%t1601 = call i64 @case_simple(i64 %t1594, i1 false)
%t1602 = call i64 @utf8_encode(i64 %t1601, i64 %p1)
br label %L600
L600:
%t1603 = phi i64 [ %t1600, %L598 ], [ %t1602, %L599 ]
%t1604 = add i64 %p0, %t1593
%t1605 = add i64 %p1, %t1603
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_case_resid__copy_words(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1607 = call i64 @__mruntime_rt_case_resid__copy_words_at(i64 %p0, i64 %p1, i64 0, i64 %p2)
ret i64 %p2
}
define internal i64 @__mruntime_rt_case_resid__copy_words_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1614, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t1608 = icmp sge i64 %p2, %p3
br i1 %t1608, label %L601, label %L603
L601:
ret i64 0
L603:
%t1609 = add i64 %p0, %p2
%t1610 = mul i64 %p2, 8
%t1611 = add i64 %p1, %t1610
%t1612 = call i64 @ld64(i64 %t1611)
%t1613 = call i64 @st8(i64 %t1609, i64 %t1612)
%t1614 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_to_upper(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1616 = call i64 @rt_str_len(i64 %p0)
%t1617 = mul i64 %t1616, 9
%t1618 = add i64 %t1617, 8
%t1619 = call i64 @xmalloc(i64 %t1618)
%t1620 = call i64 @__mruntime_rt_case_resid__upper_at(i64 %p0, i64 %t1619)
%t1621 = call i64 @st8(i64 %t1620, i64 0)
ret i64 %t1619
}
define ptr @str_to_upper(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_to_upper(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_case_simple(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1622 = icmp ne i64 %p1, 0
%t1623 = call i64 @case_simple(i64 %p0, i1 %t1622)
ret i64 %t1623
}
define i32 @resid_case_simple(i32 %a0, i32 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = sext i32 %a0 to i64
%x1 = sext i32 %a1 to i64
%r = call i64 @rt_case_simple(i64 %x0, i64 %x1)
%rv = trunc i64 %r to i32
ret i32 %rv
}
define internal i1 @__mruntime_rt_strutil_resid__is_space(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1624 = icmp eq i64 %p0, 32
br label %LSL1625
LSL1625:
br i1 %t1624, label %LSJ1625, label %LSR1625
LSR1625:
%t1626 = icmp eq i64 %p0, 9
br label %LSJ1625
LSJ1625:
%t1627 = phi i1 [ true, %LSL1625 ], [ %t1626, %LSR1625 ]
br label %LSL1628
LSL1628:
br i1 %t1627, label %LSJ1628, label %LSR1628
LSR1628:
%t1629 = icmp eq i64 %p0, 10
br label %LSJ1628
LSJ1628:
%t1630 = phi i1 [ true, %LSL1628 ], [ %t1629, %LSR1628 ]
br label %LSL1631
LSL1631:
br i1 %t1630, label %LSJ1631, label %LSR1631
LSR1631:
%t1632 = icmp eq i64 %p0, 13
br label %LSJ1631
LSJ1631:
%t1633 = phi i1 [ true, %LSL1631 ], [ %t1632, %LSR1631 ]
br label %LSL1634
LSL1634:
br i1 %t1633, label %LSJ1634, label %LSR1634
LSR1634:
%t1635 = icmp eq i64 %p0, 11
br label %LSJ1634
LSJ1634:
%t1636 = phi i1 [ true, %LSL1634 ], [ %t1635, %LSR1634 ]
br label %LSL1637
LSL1637:
br i1 %t1636, label %LSJ1637, label %LSR1637
LSR1637:
%t1638 = icmp eq i64 %p0, 12
br label %LSJ1637
LSJ1637:
%t1639 = phi i1 [ true, %LSL1637 ], [ %t1638, %LSR1637 ]
ret i1 %t1639
}
define internal i64 @__mruntime_rt_strutil_resid__skip_space(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1645, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%t1640 = icmp slt i64 %p0, %p1
br label %LSL1641
LSL1641:
br i1 %t1640, label %LSR1641, label %LSJ1641
LSR1641:
%t1642 = call i64 @ld8(i64 %p0)
%t1643 = call i1 @__mruntime_rt_strutil_resid__is_space(i64 %t1642)
br label %LSJ1641
LSJ1641:
%t1644 = phi i1 [ false, %LSL1641 ], [ %t1643, %LSR1641 ]
br i1 %t1644, label %L604, label %L606
L604:
%t1645 = add nsw i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
L606:
ret i64 %p0
}
define internal i64 @__mruntime_rt_strutil_resid__back_space(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1653, %tco.s0 ]
%t1647 = icmp sgt i64 %p1, %p0
br label %LSL1648
LSL1648:
br i1 %t1647, label %LSR1648, label %LSJ1648
LSR1648:
%t1649 = sub nsw i64 %p1, 1
%t1650 = call i64 @ld8(i64 %t1649)
%t1651 = call i1 @__mruntime_rt_strutil_resid__is_space(i64 %t1650)
br label %LSJ1648
LSJ1648:
%t1652 = phi i1 [ false, %LSL1648 ], [ %t1651, %LSR1648 ]
br i1 %t1652, label %L607, label %L609
L607:
%t1653 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L609:
ret i64 %p1
}
define internal i64 @rt_str_trim(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1655 = call i64 @c_strlen(i64 %p0)
%t1656 = add i64 %p0, %t1655
%t1657 = call i64 @__mruntime_rt_strutil_resid__skip_space(i64 %p0, i64 %t1656)
%t1658 = call i64 @c_strlen(i64 %p0)
%t1659 = add i64 %p0, %t1658
%t1660 = call i64 @__mruntime_rt_strutil_resid__back_space(i64 %t1657, i64 %t1659)
%t1661 = sub i64 %t1660, %t1657
%t1662 = call i64 @cstr_from(i64 %t1657, i64 %t1661, i64 0)
ret i64 %t1662
}
define ptr @str_trim(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_trim(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_str_contains(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1663 = call i64 @c_strstr(i64 %p0, i64 %p1)
%t1664 = icmp ne i64 %t1663, 0
br i1 %t1664, label %L610, label %L611
L610:
br label %L612
L611:
br label %L612
L612:
%t1665 = phi i64 [ 1, %L610 ], [ 0, %L611 ]
ret i64 %t1665
}
define i8 @str_contains(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_str_contains(i64 %x0i, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_str_starts_with(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1666 = call i64 @c_strlen(i64 %p1)
%t1667 = call i64 @c_strncmp(i64 %p0, i64 %p1, i64 %t1666)
%t1668 = icmp eq i64 %t1667, 0
br i1 %t1668, label %L613, label %L614
L613:
br label %L615
L614:
br label %L615
L615:
%t1669 = phi i64 [ 1, %L613 ], [ 0, %L614 ]
ret i64 %t1669
}
define i8 @str_starts_with(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_str_starts_with(i64 %x0i, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_str_ends_with(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1670 = call i64 @c_strlen(i64 %p0)
%t1671 = call i64 @c_strlen(i64 %p1)
%t1672 = icmp sgt i64 %t1671, %t1670
br i1 %t1672, label %L616, label %L618
L616:
ret i64 0
L618:
%t1673 = add i64 %p0, %t1670
%t1674 = sub i64 %t1673, %t1671
%t1675 = call i64 @c_strcmp(i64 %t1674, i64 %p1)
%t1676 = icmp eq i64 %t1675, 0
br i1 %t1676, label %L619, label %L620
L619:
br label %L621
L620:
br label %L621
L621:
%t1677 = phi i64 [ 1, %L619 ], [ 0, %L620 ]
ret i64 %t1677
}
define i8 @str_ends_with(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_str_ends_with(i64 %x0i, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_str_repeat(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1678 = icmp slt i64 %p1, 0
br i1 %t1678, label %L622, label %L623
L622:
br label %L624
L623:
br label %L624
L624:
%t1679 = phi i64 [ 0, %L622 ], [ %p1, %L623 ]
%t1680 = call i64 @c_strlen(i64 %p0)
%t1681 = icmp sgt i64 %t1680, 0
br label %LSL1682
LSL1682:
br i1 %t1681, label %LSR1682, label %LSJ1682
LSR1682:
%t1683 = sdiv i64 9223372036854775807, %t1680
%t1684 = icmp sgt i64 %t1679, %t1683
br label %LSJ1682
LSJ1682:
%t1685 = phi i1 [ false, %LSL1682 ], [ %t1684, %LSR1682 ]
br i1 %t1685, label %L625, label %L627
L625:
%t1686 = call i64 @cstr_from(i64 %p0, i64 0, i64 0)
ret i64 %t1686
L627:
%t1687 = mul i64 %t1680, %t1679
%t1688 = add i64 %t1687, 1
%t1689 = call i64 @c_malloc(i64 %t1688)
%t1690 = icmp eq i64 %t1689, 0
br i1 %t1690, label %L628, label %L630
L628:
%t1691 = call i64 @cstr_from(i64 %p0, i64 0, i64 0)
ret i64 %t1691
L630:
%t1692 = call i64 @__mruntime_rt_strutil_resid__repeat_at(i64 %t1689, i64 %p0, i64 %t1680, i64 %t1679)
%t1693 = call i64 @st8(i64 %t1692, i64 0)
ret i64 %t1689
}
define ptr @str_repeat(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_repeat(i64 %x0i, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_strutil_resid__repeat_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1696, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1697, %tco.s0 ]
%t1694 = icmp sle i64 %p3, 0
br i1 %t1694, label %L631, label %L633
L631:
ret i64 %p0
L633:
%t1695 = call i64 @mcopy(i64 %p0, i64 %p1, i64 %p2)
%t1696 = add i64 %p0, %p2
%t1697 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_strutil_resid__count_hits(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1701, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1702, %tco.s0 ]
%t1699 = call i64 @c_strstr(i64 %p0, i64 %p1)
%t1700 = icmp eq i64 %t1699, 0
br i1 %t1700, label %L634, label %L636
L634:
ret i64 %p3
L636:
%t1701 = add i64 %t1699, %p2
%t1702 = add i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_replace(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1704 = call i64 @c_strlen(i64 %p1)
%t1705 = call i64 @c_strlen(i64 %p2)
%t1706 = icmp eq i64 %t1704, 0
br i1 %t1706, label %L637, label %L639
L637:
%t1707 = call i64 @cstr_dup(i64 %p0)
ret i64 %t1707
L639:
%t1708 = call i64 @__mruntime_rt_strutil_resid__count_hits(i64 %p0, i64 %p1, i64 %t1704, i64 0)
%t1709 = call i64 @c_strlen(i64 %p0)
%t1710 = icmp sgt i64 %t1705, %t1704
br i1 %t1710, label %L640, label %L641
L640:
%t1711 = sub i64 %t1705, %t1704
%t1712 = mul i64 %t1708, %t1711
br label %L642
L641:
br label %L642
L642:
%t1713 = phi i64 [ %t1712, %L640 ], [ 0, %L641 ]
%t1714 = add i64 %t1709, %t1713
%t1715 = add i64 %t1714, 1
%t1716 = call i64 @xmalloc(i64 %t1715)
%t1717 = call i64 @__mruntime_rt_strutil_resid__replace_at(i64 %t1716, i64 %p0, i64 %p1, i64 %t1704, i64 %p2, i64 %t1705)
ret i64 %t1716
}
define ptr @str_replace(ptr %a0, ptr %a1, ptr %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%x2i = ptrtoint ptr %a2 to i64
%r = call i64 @rt_str_replace(i64 %x0i, i64 %x1i, i64 %x2i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_strutil_resid__replace_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1732, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1733, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t1718 = call i64 @c_strstr(i64 %p1, i64 %p2)
%t1719 = icmp eq i64 %t1718, 0
br i1 %t1719, label %L643, label %L645
L643:
%t1720 = call i64 @c_strlen(i64 %p1)
%t1721 = add i64 %t1720, 1
%t1722 = call i64 @mcopy(i64 %p0, i64 %p1, i64 %t1721)
%t1723 = add i64 %t1722, %p0
%t1724 = add i64 %t1723, %t1720
ret i64 %t1724
L645:
%t1725 = sub i64 %t1718, %p1
%t1726 = call i64 @mcopy(i64 %p0, i64 %p1, i64 %t1725)
%t1727 = sub i64 %t1718, %p1
%t1728 = add i64 %p0, %t1727
%t1729 = call i64 @mcopy(i64 %t1728, i64 %p4, i64 %p5)
%t1730 = sub i64 %t1718, %p1
%t1731 = add i64 %p0, %t1730
%t1732 = add i64 %t1731, %p5
%t1733 = add i64 %t1718, %p3
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_split(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1736 = ptrtoint ptr @.s1735 to i64
%t1737 = call i64 @c_strlen(i64 %p1)
%t1738 = icmp eq i64 %t1737, 0
br i1 %t1738, label %L646, label %L648
L646:
%t1739p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.split_one)
%t1739 = ptrtoint ptr %t1739p to i64
%t1740 = call i64 @st64(i64 %t1739, i64 %p0)
%t1741 = call i64 @c_list_new(i64 1, i64 %t1739, i64 %t1736)
ret i64 %t1741
L648:
%t1742 = call i64 @__mruntime_rt_strutil_resid__count_hits(i64 %p0, i64 %p1, i64 %t1737, i64 0)
%t1743 = add i64 %t1742, 1
%t1744 = mul i64 %t1743, 8
%t1745 = call i64 @xmalloc(i64 %t1744)
%t1746 = call i64 @__mruntime_rt_strutil_resid__split_at(i64 %t1745, i64 0, i64 %p0, i64 %p1, i64 %t1737)
%t1747 = call i64 @c_list_new(i64 %t1743, i64 %t1745, i64 %t1736)
%t1748 = call i64 @c_free(i64 %t1745)
ret i64 %t1747
}
define ptr @str_split(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_str_split(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_strutil_resid__split_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1760, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1761, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t1749 = call i64 @c_strstr(i64 %p2, i64 %p3)
%t1750 = icmp eq i64 %t1749, 0
br i1 %t1750, label %L649, label %L651
L649:
%t1751 = mul i64 %p1, 8
%t1752 = add i64 %p0, %t1751
%t1753 = call i64 @cstr_dup(i64 %p2)
%t1754 = call i64 @st64(i64 %t1752, i64 %t1753)
ret i64 %t1754
L651:
%t1755 = mul i64 %p1, 8
%t1756 = add i64 %p0, %t1755
%t1757 = sub i64 %t1749, %p2
%t1758 = call i64 @cstr_from(i64 %p2, i64 %t1757, i64 0)
%t1759 = call i64 @st64(i64 %t1756, i64 %t1758)
%t1760 = add i64 %p1, 1
%t1761 = add i64 %t1749, %p4
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_join(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1763 = call i64 @c_list_len(i64 %p0)
%t1764 = call i64 @c_list_to_array(i64 %p0)
%t1765 = call i64 @c_strlen(i64 %p1)
%t1766 = call i64 @__mruntime_rt_strutil_resid__join_len(i64 %t1764, i64 0, i64 %t1763, i64 0)
%t1767 = icmp sgt i64 %t1763, 0
br i1 %t1767, label %L652, label %L653
L652:
%t1768 = sub nsw i64 %t1763, 1
%t1769 = mul i64 %t1765, %t1768
br label %L654
L653:
br label %L654
L654:
%t1770 = phi i64 [ %t1769, %L652 ], [ 0, %L653 ]
%t1771 = add i64 %t1766, %t1770
%t1772 = add i64 %t1771, 1
%t1773 = call i64 @xmalloc(i64 %t1772)
%t1774 = call i64 @__mruntime_rt_strutil_resid__join_at(i64 %t1773, i64 %t1764, i64 0, i64 %t1763, i64 %p1, i64 %t1765)
%t1775 = call i64 @st8(i64 %t1774, i64 0)
%t1776 = call i64 @c_free(i64 %t1764)
ret i64 %t1773
}
define ptr @str_join(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_str_join(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_strutil_resid__join_len(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1778, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1783, %tco.s0 ]
%t1777 = icmp sge i64 %p1, %p2
br i1 %t1777, label %L655, label %L657
L655:
ret i64 %p3
L657:
%t1778 = add nsw i64 %p1, 1
%t1779 = mul i64 %p1, 8
%t1780 = add i64 %p0, %t1779
%t1781 = call i64 @ld64(i64 %t1780)
%t1782 = call i64 @c_strlen(i64 %t1781)
%t1783 = add i64 %p3, %t1782
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_strutil_resid__join_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1796, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1797, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t1785 = icmp sge i64 %p2, %p3
br i1 %t1785, label %L658, label %L660
L658:
ret i64 %p0
L660:
%t1786 = icmp sgt i64 %p2, 0
br i1 %t1786, label %L661, label %L662
L661:
%t1787 = call i64 @mcopy(i64 %p0, i64 %p4, i64 %p5)
%t1788 = add i64 %t1787, %p0
%t1789 = add i64 %t1788, %p5
br label %L663
L662:
br label %L663
L663:
%t1790 = phi i64 [ %t1789, %L661 ], [ %p0, %L662 ]
%t1791 = mul i64 %p2, 8
%t1792 = add i64 %p1, %t1791
%t1793 = call i64 @ld64(i64 %t1792)
%t1794 = call i64 @c_strlen(i64 %t1793)
%t1795 = call i64 @mcopy(i64 %t1790, i64 %t1793, i64 %t1794)
%t1796 = add i64 %t1790, %t1794
%t1797 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_strutil_resid__all_digits(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1805, %tco.s0 ]
%t1799 = call i64 @ld8(i64 %p0)
%t1800 = icmp eq i64 %t1799, 0
br i1 %t1800, label %L664, label %L666
L664:
ret i1 true
L666:
%t1801 = icmp slt i64 %t1799, 48
br label %LSL1802
LSL1802:
br i1 %t1801, label %LSJ1802, label %LSR1802
LSR1802:
%t1803 = icmp sgt i64 %t1799, 57
br label %LSJ1802
LSJ1802:
%t1804 = phi i1 [ true, %LSL1802 ], [ %t1803, %LSR1802 ]
br i1 %t1804, label %L667, label %L669
L667:
ret i1 false
L669:
%t1805 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @is_int(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1807 = call i64 @ld8(i64 %p0)
%t1808 = icmp eq i64 %t1807, 0
br i1 %t1808, label %L670, label %L672
L670:
ret i1 false
L672:
%t1809 = icmp eq i64 %t1807, 45
br label %LSL1810
LSL1810:
br i1 %t1809, label %LSJ1810, label %LSR1810
LSR1810:
%t1811 = icmp eq i64 %t1807, 43
br label %LSJ1810
LSJ1810:
%t1812 = phi i1 [ true, %LSL1810 ], [ %t1811, %LSR1810 ]
br i1 %t1812, label %L673, label %L674
L673:
%t1813 = add i64 %p0, 1
br label %L675
L674:
br label %L675
L675:
%t1814 = phi i64 [ %t1813, %L673 ], [ %p0, %L674 ]
%t1815 = call i64 @ld8(i64 %t1814)
%t1816 = icmp ne i64 %t1815, 0
br label %LSL1817
LSL1817:
br i1 %t1816, label %LSR1817, label %LSJ1817
LSR1817:
%t1818 = call i1 @__mruntime_rt_strutil_resid__all_digits(i64 %t1814)
br label %LSJ1817
LSJ1817:
%t1819 = phi i1 [ false, %LSL1817 ], [ %t1818, %LSR1817 ]
ret i1 %t1819
}
define internal i64 @rt_str_is_int(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1820 = call i1 @is_int(i64 %p0)
br i1 %t1820, label %L676, label %L677
L676:
br label %L678
L677:
br label %L678
L678:
%t1821 = phi i64 [ 1, %L676 ], [ 0, %L677 ]
ret i64 %t1821
}
define i8 @str_is_int(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_is_int(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_str_parse_int(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1822 = call i1 @is_int(i64 %p0)
%t1823 = xor i1 %t1822, true
br i1 %t1823, label %L679, label %L681
L679:
ret i64 0
L681:
%t1824 = call i64 @ld8(i64 %p0)
%t1825 = icmp eq i64 %t1824, 45
%t1826 = call i64 @ld8(i64 %p0)
%t1827 = icmp eq i64 %t1826, 45
br label %LSL1828
LSL1828:
br i1 %t1827, label %LSJ1828, label %LSR1828
LSR1828:
%t1829 = call i64 @ld8(i64 %p0)
%t1830 = icmp eq i64 %t1829, 43
br label %LSJ1828
LSJ1828:
%t1831 = phi i1 [ true, %LSL1828 ], [ %t1830, %LSR1828 ]
br i1 %t1831, label %L682, label %L683
L682:
%t1832 = add i64 %p0, 1
br label %L684
L683:
br label %L684
L684:
%t1833 = phi i64 [ %t1832, %L682 ], [ %p0, %L683 ]
%t1834 = call i64 @__mruntime_rt_strutil_resid__neg_digits(i64 %t1833, i64 0)
%t1835 = icmp eq i64 %t1834, 1
br i1 %t1835, label %L685, label %L687
L685:
br i1 %t1825, label %L688, label %L689
L688:
%t1836 = sext i64 0 to i128
%t1837 = sub i128 %t1836, 9223372036854775807
%t1838 = sext i64 1 to i128
%t1839 = sub i128 %t1837, %t1838
br label %L690
L689:
br label %L690
L690:
%t1840 = phi i128 [ %t1839, %L688 ], [ 9223372036854775807, %L689 ]
%t1841 = trunc i128 %t1840 to i64
ret i64 %t1841
L687:
br i1 %t1825, label %L691, label %L693
L691:
ret i64 %t1834
L693:
%t1842 = sext i64 0 to i128
%t1843 = sub i128 %t1842, 9223372036854775807
%t1844 = sext i64 1 to i128
%t1845 = sub i128 %t1843, %t1844
%t1846 = sext i64 %t1834 to i128
%t1847 = icmp eq i128 %t1846, %t1845
br i1 %t1847, label %L694, label %L696
L694:
%t1848 = trunc i128 9223372036854775807 to i64
ret i64 %t1848
L696:
%t1849 = sub i64 0, %t1834
ret i64 %t1849
}
define i64 @str_parse_int(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_parse_int(i64 %x0i)
ret i64 %r
}
define internal i64 @__mruntime_rt_strutil_resid__neg_digits(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1861, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1863, %tco.s0 ]
%t1850 = call i64 @ld8(i64 %p0)
%t1851 = icmp eq i64 %t1850, 0
br i1 %t1851, label %L697, label %L699
L697:
ret i64 %p1
L699:
%t1852 = sub i64 %t1850, 48
%t1853 = sub nsw i64 0, 922337203685477580
%t1854 = icmp slt i64 %p1, %t1853
br label %LSL1855
LSL1855:
br i1 %t1854, label %LSJ1855, label %LSR1855
LSR1855:
%t1856 = icmp eq i64 %p1, %t1853
br label %LSL1857
LSL1857:
br i1 %t1856, label %LSR1857, label %LSJ1857
LSR1857:
%t1858 = icmp sgt i64 %t1852, 8
br label %LSJ1857
LSJ1857:
%t1859 = phi i1 [ false, %LSL1857 ], [ %t1858, %LSR1857 ]
br label %LSJ1855
LSJ1855:
%t1860 = phi i1 [ true, %LSL1855 ], [ %t1859, %LSJ1857 ]
br i1 %t1860, label %L700, label %L702
L700:
ret i64 1
L702:
%t1861 = add i64 %p0, 1
%t1862 = mul i64 %p1, 10
%t1863 = sub i64 %t1862, %t1852
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_strutil_resid__is_float(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1865 = call i64 @ld8(i64 %p0)
%t1866 = icmp eq i64 %t1865, 0
br i1 %t1866, label %L703, label %L705
L703:
ret i1 false
L705:
%t1867p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.strtod_end)
%t1867 = ptrtoint ptr %t1867p to i64
%t1868 = call double @c_strtod(i64 %p0, i64 %t1867)
%t1869 = call i64 @ld64(i64 %t1867)
%t1870 = call i64 @__mruntime_rt_strutil_resid__skip_tabs(i64 %t1869)
%t1871 = call i64 @ld8(i64 %t1870)
%t1872 = icmp eq i64 %t1871, 0
br label %LSL1873
LSL1873:
br i1 %t1872, label %LSR1873, label %LSJ1873
LSR1873:
%t1874 = icmp ne i64 %t1869, %p0
br label %LSJ1873
LSJ1873:
%t1875 = phi i1 [ false, %LSL1873 ], [ %t1874, %LSR1873 ]
ret i1 %t1875
}
define internal i64 @__mruntime_rt_strutil_resid__skip_tabs(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1881, %tco.s0 ]
%t1876 = call i64 @ld8(i64 %p0)
%t1877 = icmp eq i64 %t1876, 32
br label %LSL1878
LSL1878:
br i1 %t1877, label %LSJ1878, label %LSR1878
LSR1878:
%t1879 = icmp eq i64 %t1876, 9
br label %LSJ1878
LSJ1878:
%t1880 = phi i1 [ true, %LSL1878 ], [ %t1879, %LSR1878 ]
br i1 %t1880, label %L706, label %L708
L706:
%t1881 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
L708:
ret i64 %p0
}
define internal i64 @rt_str_is_float(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1883 = call i1 @__mruntime_rt_strutil_resid__is_float(i64 %p0)
br i1 %t1883, label %L709, label %L710
L709:
br label %L711
L710:
br label %L711
L711:
%t1884 = phi i64 [ 1, %L709 ], [ 0, %L710 ]
ret i64 %t1884
}
define i8 @str_is_float(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_is_float(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal double @rt_str_parse_float(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1885 = call i1 @__mruntime_rt_strutil_resid__is_float(i64 %p0)
%t1886 = xor i1 %t1885, true
br i1 %t1886, label %L712, label %L714
L712:
ret double 0.0
L714:
%t1887 = call double @c_strtod(i64 %p0, i64 0)
ret double %t1887
}
define double @str_parse_float(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call double @rt_str_parse_float(i64 %x0i)
ret double %r
}
define internal i64 @rt_str_count(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1888 = call i64 @c_strlen(i64 %p1)
%t1889 = icmp eq i64 %t1888, 0
br i1 %t1889, label %L715, label %L717
L715:
ret i64 0
L717:
%t1890 = call i64 @__mruntime_rt_strutil_resid__count_hits(i64 %p0, i64 %p1, i64 %t1888, i64 0)
ret i64 %t1890
}
define i64 @str_count(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_str_count(i64 %x0i, i64 %x1i)
ret i64 %r
}
define internal i64 @rt_str_reverse(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1891 = call i64 @c_strlen(i64 %p0)
%t1892 = add i64 %t1891, 1
%t1893 = call i64 @xmalloc(i64 %t1892)
%t1894 = add i64 %t1893, %t1891
%t1895 = call i64 @__mruntime_rt_strutil_resid__rev_at(i64 %p0, i64 %t1894)
%t1896 = add i64 %t1893, %t1891
%t1897 = call i64 @st8(i64 %t1896, i64 0)
ret i64 %t1893
}
define ptr @str_reverse(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_reverse(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_strutil_resid__rev_at(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1903, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1904, %tco.s0 ]
%t1898 = call i64 @ld8(i64 %p0)
%t1899 = icmp eq i64 %t1898, 0
br i1 %t1899, label %L718, label %L720
L718:
ret i64 0
L720:
%t1900 = call i64 @utf8_len_at(i64 %p0)
%t1901 = sub i64 %p1, %t1900
%t1902 = call i64 @mcopy(i64 %t1901, i64 %p0, i64 %t1900)
%t1903 = add i64 %p0, %t1900
%t1904 = sub i64 %p1, %t1900
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @sc(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t1906 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 0, i64 0)
%t1907 = sub nsw i64 0, 4
%t1908 = icmp eq i64 %t1906, %t1907
br i1 %t1908, label %L721, label %L723
L721:
br label %tco.s0
tco.s0:
br label %tco.head
L723:
ret i64 %t1906
}
define internal i64 @__mruntime_rt_sys_resid__sc4(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t1910 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 0, i64 0)
%t1911 = sub nsw i64 0, 4
%t1912 = icmp eq i64 %t1910, %t1911
br i1 %t1912, label %L724, label %L726
L724:
br label %tco.s0
tco.s0:
br label %tco.head
L726:
ret i64 %t1910
}
define internal i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1914 = icmp ne i64 %p0, 0
br label %LSL1915
LSL1915:
br i1 %t1914, label %LSR1915, label %LSJ1915
LSR1915:
%t1916 = call i64 @ld8(i64 %p0)
%t1917 = icmp ne i64 %t1916, 0
br label %LSJ1915
LSJ1915:
%t1918 = phi i1 [ false, %LSL1915 ], [ %t1917, %LSR1915 ]
ret i1 %t1918
}
define internal i64 @o_rdonly() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 524288
}
define internal i64 @__mruntime_rt_sys_resid__o_write() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1919 = or i64 524288, 1
%t1920 = or i64 %t1919, 64
%t1921 = or i64 %t1920, 512
ret i64 %t1921
}
define internal i64 @__mruntime_rt_sys_resid__o_append() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1922 = or i64 524288, 1
%t1923 = or i64 %t1922, 64
%t1924 = or i64 %t1923, 1024
ret i64 %t1924
}
define internal i64 @sys_open(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1925 = call i64 @sc(i64 2, i64 %p0, i64 %p1, i64 %p2)
ret i64 %t1925
}
define internal i64 @sys_close(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1926 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 3, i64 %p0, i64 0, i64 0, i64 0, i64 0, i64 0)
ret i64 %t1926
}
define internal i64 @__mruntime_rt_sys_resid__stat_buf() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1927p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.stat_buf)
%t1927 = ptrtoint ptr %t1927p to i64
ret i64 %t1927
}
define internal i1 @__mruntime_rt_sys_resid__mode_dir(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1928 = and i64 %p0, 61440
%t1929 = icmp eq i64 %t1928, 16384
ret i1 %t1929
}
define internal i1 @__mruntime_rt_sys_resid__mode_reg(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1930 = and i64 %p0, 61440
%t1931 = icmp eq i64 %t1930, 32768
ret i1 %t1931
}
define internal i64 @rt_fs_is_dir(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1932 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t1933 = xor i1 %t1932, true
br i1 %t1933, label %L727, label %L729
L727:
ret i64 0
L729:
%t1934 = call i64 @__mruntime_rt_sys_resid__stat_buf()
%t1935 = call i64 @sc(i64 4, i64 %p0, i64 %t1934, i64 0)
%t1936 = icmp ne i64 %t1935, 0
br i1 %t1936, label %L730, label %L732
L730:
ret i64 0
L732:
%t1937 = add i64 %t1934, 24
%t1938 = call i64 @ld32(i64 %t1937)
%t1939 = call i1 @__mruntime_rt_sys_resid__mode_dir(i64 %t1938)
br i1 %t1939, label %L733, label %L734
L733:
br label %L735
L734:
br label %L735
L735:
%t1940 = phi i64 [ 1, %L733 ], [ 0, %L734 ]
ret i64 %t1940
}
define i8 @resid_fs_is_dir(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_fs_is_dir(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_fs_create_dir_all(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1941 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t1942 = xor i1 %t1941, true
br i1 %t1942, label %L736, label %L738
L736:
ret i64 0
L738:
%t1943 = call i64 @c_strlen(i64 %p0)
%t1944 = icmp sge i64 %t1943, 4096
br i1 %t1944, label %L739, label %L741
L739:
ret i64 0
L741:
%t1945 = call i64 @cstr_dup(i64 %p0)
%t1946 = call i1 @__mruntime_rt_sys_resid__mkdir_parents(i64 %t1945, i64 1, i64 %t1943)
br label %LSL1947
LSL1947:
br i1 %t1946, label %LSR1947, label %LSJ1947
LSR1947:
%t1948 = call i1 @__mruntime_rt_sys_resid__mkdir_ok(i64 %t1945)
br label %LSJ1947
LSJ1947:
%t1949 = phi i1 [ false, %LSL1947 ], [ %t1948, %LSR1947 ]
%t1950 = call i64 @__mruntime_rt_sys_resid__stat_buf()
br label %LSL1951
LSL1951:
br i1 %t1949, label %LSR1951, label %LSJ1951
LSR1951:
%t1952 = call i64 @sc(i64 4, i64 %t1945, i64 %t1950, i64 0)
%t1953 = icmp eq i64 %t1952, 0
br label %LSJ1951
LSJ1951:
%t1954 = phi i1 [ false, %LSL1951 ], [ %t1953, %LSR1951 ]
br label %LSL1955
LSL1955:
br i1 %t1954, label %LSR1955, label %LSJ1955
LSR1955:
%t1956 = add i64 %t1950, 24
%t1957 = call i64 @ld32(i64 %t1956)
%t1958 = call i1 @__mruntime_rt_sys_resid__mode_dir(i64 %t1957)
br label %LSJ1955
LSJ1955:
%t1959 = phi i1 [ false, %LSL1955 ], [ %t1958, %LSR1955 ]
%t1960 = call i64 @c_free(i64 %t1945)
br i1 %t1959, label %L742, label %L743
L742:
br label %L744
L743:
br label %L744
L744:
%t1961 = phi i64 [ 1, %L742 ], [ 0, %L743 ]
ret i64 %t1961
}
define i8 @resid_fs_create_dir_all(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_fs_create_dir_all(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i1 @__mruntime_rt_sys_resid__mkdir_ok(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1962 = call i64 @sc(i64 83, i64 %p0, i64 511, i64 0)
%t1963 = icmp eq i64 %t1962, 0
br label %LSL1964
LSL1964:
br i1 %t1963, label %LSJ1964, label %LSR1964
LSR1964:
%t1965 = sub nsw i64 0, 17
%t1966 = icmp eq i64 %t1962, %t1965
br label %LSJ1964
LSJ1964:
%t1967 = phi i1 [ true, %LSL1964 ], [ %t1966, %LSR1964 ]
ret i1 %t1967
}
define internal i1 @__mruntime_rt_sys_resid__mkdir_parents(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1972, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t1968 = icmp sge i64 %p1, %p2
br i1 %t1968, label %L745, label %L747
L745:
ret i1 true
L747:
%t1969 = add i64 %p0, %p1
%t1970 = call i64 @ld8(i64 %t1969)
%t1971 = icmp ne i64 %t1970, 47
br i1 %t1971, label %L748, label %L750
L748:
%t1972 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L750:
%t1974 = add i64 %p0, %p1
%t1975 = call i64 @st8(i64 %t1974, i64 0)
%t1976 = call i64 @ld8(i64 %p0)
%t1977 = icmp eq i64 %t1976, 0
br label %LSL1978
LSL1978:
br i1 %t1977, label %LSJ1978, label %LSR1978
LSR1978:
%t1979 = call i1 @__mruntime_rt_sys_resid__mkdir_ok(i64 %p0)
br label %LSJ1978
LSJ1978:
%t1980 = phi i1 [ true, %LSL1978 ], [ %t1979, %LSR1978 ]
%t1981 = add i64 %p0, %p1
%t1982 = call i64 @st8(i64 %t1981, i64 47)
br label %LSL1983
LSL1983:
br i1 %t1980, label %LSR1983, label %LSJ1983
LSR1983:
%t1984 = add nsw i64 %p1, 1
%t1985 = call i1 @__mruntime_rt_sys_resid__mkdir_parents(i64 %p0, i64 %t1984, i64 %p2)
br label %LSJ1983
LSJ1983:
%t1986 = phi i1 [ false, %LSL1983 ], [ %t1985, %LSR1983 ]
ret i1 %t1986
}
define internal i64 @rt_fs_exists(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1987 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t1988 = xor i1 %t1987, true
br i1 %t1988, label %L751, label %L753
L751:
ret i64 0
L753:
%t1989 = call i64 @o_rdonly()
%t1990 = call i64 @sys_open(i64 %p0, i64 %t1989, i64 0)
%t1991 = icmp slt i64 %t1990, 0
br i1 %t1991, label %L754, label %L756
L754:
ret i64 0
L756:
%t1992 = call i64 @sys_close(i64 %t1990)
%t1993 = mul nsw i64 %t1992, 0
%t1994 = add nsw i64 %t1993, 1
ret i64 %t1994
}
define i8 @resid_fs_exists(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_fs_exists(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_read_line() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1995 = call i64 @xmalloc(i64 256)
%t1996 = call i64 @__mruntime_rt_sys_resid__read_line_at(i64 %t1995, i64 0, i64 256)
ret i64 %t1996
}
define ptr @resid_read_line() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_read_line()
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_sys_resid__read_line_at(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t2001, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2019, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2005, %tco.s0 ]
%t1997 = add i64 %p1, 2
%t1998 = icmp sgt i64 %t1997, %p2
br i1 %t1998, label %L757, label %L758
L757:
%t1999 = mul i64 %p2, 2
%t2000 = call i64 @xrealloc(i64 %p0, i64 %t1999)
br label %L759
L758:
br label %L759
L759:
%t2001 = phi i64 [ %t2000, %L757 ], [ %p0, %L758 ]
%t2002 = add i64 %p1, 2
%t2003 = icmp sgt i64 %t2002, %p2
br i1 %t2003, label %L760, label %L761
L760:
%t2004 = mul i64 %p2, 2
br label %L762
L761:
br label %L762
L762:
%t2005 = phi i64 [ %t2004, %L760 ], [ %p2, %L761 ]
%t2006 = add i64 %t2001, %p1
%t2007 = call i64 @sc(i64 0, i64 0, i64 %t2006, i64 1)
%t2008 = icmp sle i64 %t2007, 0
br i1 %t2008, label %L763, label %L765
L763:
%t2009 = add i64 %t2001, %p1
%t2010 = call i64 @st8(i64 %t2009, i64 0)
%t2011 = add i64 %t2010, %t2001
ret i64 %t2011
L765:
%t2012 = add i64 %t2001, %p1
%t2013 = call i64 @ld8(i64 %t2012)
%t2014 = icmp eq i64 %t2013, 10
br i1 %t2014, label %L766, label %L768
L766:
%t2015 = add i64 %t2001, %p1
%t2016 = add i64 %t2015, 1
%t2017 = call i64 @st8(i64 %t2016, i64 0)
%t2018 = add i64 %t2017, %t2001
ret i64 %t2018
L768:
%t2019 = add i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__read_fd_all(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2021 = call i64 @__mruntime_rt_sys_resid__stat_buf()
%t2022 = call i64 @sc(i64 5, i64 %p0, i64 %t2021, i64 0)
%t2023 = icmp eq i64 %t2022, 0
br label %LSL2024
LSL2024:
br i1 %t2023, label %LSR2024, label %LSJ2024
LSR2024:
%t2025 = add i64 %t2021, 24
%t2026 = call i64 @ld32(i64 %t2025)
%t2027 = call i1 @__mruntime_rt_sys_resid__mode_reg(i64 %t2026)
br label %LSJ2024
LSJ2024:
%t2028 = phi i1 [ false, %LSL2024 ], [ %t2027, %LSR2024 ]
br i1 %t2028, label %L769, label %L770
L769:
%t2029 = add i64 %t2021, 48
%t2030 = call i64 @ld64(i64 %t2029)
br label %L771
L770:
br label %L771
L771:
%t2031 = phi i64 [ %t2030, %L769 ], [ 0, %L770 ]
%t2032 = call i64 @sc(i64 8, i64 %p0, i64 0, i64 1)
%t2033 = icmp sgt i64 %t2031, 0
br label %LSL2034
LSL2034:
br i1 %t2033, label %LSR2034, label %LSJ2034
LSR2034:
%t2035 = icmp sgt i64 %t2032, 0
br label %LSJ2034
LSJ2034:
%t2036 = phi i1 [ false, %LSL2034 ], [ %t2035, %LSR2034 ]
br label %LSL2037
LSL2037:
br i1 %t2036, label %LSR2037, label %LSJ2037
LSR2037:
%t2038 = icmp slt i64 %t2032, %t2031
br label %LSJ2037
LSJ2037:
%t2039 = phi i1 [ false, %LSL2037 ], [ %t2038, %LSR2037 ]
br i1 %t2039, label %L772, label %L773
L772:
%t2040 = sub nsw i64 %t2031, %t2032
br label %L774
L773:
br label %L774
L774:
%t2041 = phi i64 [ %t2040, %L772 ], [ %t2031, %L773 ]
%t2042 = icmp sgt i64 %t2041, 0
br i1 %t2042, label %L775, label %L776
L775:
br label %L777
L776:
br label %L777
L777:
%t2043 = phi i64 [ %t2041, %L775 ], [ 65536, %L776 ]
%t2044 = add i64 %t2043, 1
%t2045 = call i64 @xmalloc(i64 %t2044)
%t2046 = call i64 @__mruntime_rt_sys_resid__read_fd_at(i64 %p0, i64 %t2045, i64 0, i64 %t2043)
ret i64 %t2046
}
define internal i64 @__mruntime_rt_sys_resid__read_fd_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2051, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2062, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t2054, %tco.s0 ]
%t2047 = icmp sge i64 %p2, %p3
br i1 %t2047, label %L778, label %L779
L778:
%t2048 = mul i64 %p3, 2
%t2049 = add i64 %t2048, 1
%t2050 = call i64 @xrealloc(i64 %p1, i64 %t2049)
br label %L780
L779:
br label %L780
L780:
%t2051 = phi i64 [ %t2050, %L778 ], [ %p1, %L779 ]
%t2052 = icmp sge i64 %p2, %p3
br i1 %t2052, label %L781, label %L782
L781:
%t2053 = mul i64 %p3, 2
br label %L783
L782:
br label %L783
L783:
%t2054 = phi i64 [ %t2053, %L781 ], [ %p3, %L782 ]
%t2055 = add i64 %t2051, %p2
%t2056 = sub i64 %t2054, %p2
%t2057 = call i64 @sc(i64 0, i64 %p0, i64 %t2055, i64 %t2056)
%t2058 = icmp sle i64 %t2057, 0
br i1 %t2058, label %L784, label %L786
L784:
%t2059 = add i64 %t2051, %p2
%t2060 = call i64 @st8(i64 %t2059, i64 0)
%t2061 = add i64 %t2060, %t2051
ret i64 %t2061
L786:
%t2062 = add i64 %p2, %t2057
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_fs_read_all(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2064 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t2065 = xor i1 %t2064, true
br i1 %t2065, label %L787, label %L789
L787:
%t2066 = call i64 @xempty()
ret i64 %t2066
L789:
%t2067 = call i64 @o_rdonly()
%t2068 = call i64 @sys_open(i64 %p0, i64 %t2067, i64 0)
%t2069 = icmp slt i64 %t2068, 0
br i1 %t2069, label %L790, label %L792
L790:
%t2070 = call i64 @xempty()
ret i64 %t2070
L792:
%t2071 = call i64 @__mruntime_rt_sys_resid__read_fd_all(i64 %t2068)
%t2072 = call i64 @sys_close(i64 %t2068)
%t2073 = mul nsw i64 %t2072, 0
%t2074 = add nsw i64 %t2073, %t2071
ret i64 %t2074
}
define ptr @resid_fs_read_all(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_fs_read_all(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @xempty() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2075 = call i64 @xmalloc(i64 1)
%t2076 = call i64 @st8(i64 %t2075, i64 0)
%t2077 = add i64 %t2076, %t2075
ret i64 %t2077
}
define internal i1 @__mruntime_rt_sys_resid__put_file(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2078 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t2079 = xor i1 %t2078, true
br i1 %t2079, label %L793, label %L795
L793:
ret i1 false
L795:
%t2080 = call i64 @sys_open(i64 %p0, i64 %p1, i64 %p2)
%t2081 = icmp slt i64 %t2080, 0
br i1 %t2081, label %L796, label %L798
L796:
ret i1 false
L798:
%t2082 = call i1 @write_all(i64 %t2080, i64 %p3, i64 %p4)
%t2083 = call i64 @sys_close(i64 %t2080)
%t2084 = icmp eq i64 %t2083, 0
br label %LSL2085
LSL2085:
br i1 %t2084, label %LSR2085, label %LSJ2085
LSR2085:
br label %LSJ2085
LSJ2085:
%t2086 = phi i1 [ false, %LSL2085 ], [ %t2082, %LSR2085 ]
ret i1 %t2086
}
define internal i64 @__mruntime_rt_sys_resid__b8(i1 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br i1 %p0, label %L799, label %L800
L799:
br label %L801
L800:
br label %L801
L801:
%t2087 = phi i64 [ 1, %L799 ], [ 0, %L800 ]
ret i64 %t2087
}
define internal i64 @rt_fs_write_all(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2088 = call i64 @__mruntime_rt_sys_resid__o_write()
%t2089 = call i64 @c_strlen(i64 %p1)
%t2090 = call i1 @__mruntime_rt_sys_resid__put_file(i64 %p0, i64 %t2088, i64 438, i64 %p1, i64 %t2089)
%t2091 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t2090)
ret i64 %t2091
}
define i8 @resid_fs_write_all(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_fs_write_all(i64 %x0i, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @__mruntime_rt_sys_resid__list_bytes(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2092 = call i64 @c_list_len(i64 %p0)
%t2093 = call i64 @xmalloc(i64 %t2092)
%t2094 = call i64 @__mruntime_rt_sys_resid__list_bytes_at(i64 %p0, i64 %t2093, i64 0, i64 %t2092)
ret i64 %t2093
}
define internal i64 @__mruntime_rt_sys_resid__list_bytes_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2100, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t2095 = icmp sge i64 %p2, %p3
br i1 %t2095, label %L802, label %L804
L802:
ret i64 0
L804:
%t2096 = add i64 %p1, %p2
%t2097 = call i64 @c_list_get(i64 %p0, i64 %p2)
%t2098 = call i64 @c_unbox_i64(i64 %t2097)
%t2099 = call i64 @st8(i64 %t2096, i64 %t2098)
%t2100 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_sys_resid__put_list(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2102 = call i64 @__mruntime_rt_sys_resid__list_bytes(i64 %p3)
%t2103 = call i64 @c_list_len(i64 %p3)
%t2104 = call i1 @__mruntime_rt_sys_resid__put_file(i64 %p0, i64 %p1, i64 %p2, i64 %t2102, i64 %t2103)
%t2105 = call i64 @c_free(i64 %t2102)
ret i1 %t2104
}
define internal i64 @rt_fs_write_bytes(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2106 = call i64 @__mruntime_rt_sys_resid__o_write()
%t2107 = call i1 @__mruntime_rt_sys_resid__put_list(i64 %p0, i64 %t2106, i64 438, i64 %p1)
%t2108 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t2107)
ret i64 %t2108
}
define i8 @resid_fs_write_bytes(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_fs_write_bytes(i64 %x0i, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_fs_append_bytes(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2109 = call i64 @__mruntime_rt_sys_resid__o_append()
%t2110 = call i1 @__mruntime_rt_sys_resid__put_list(i64 %p0, i64 %t2109, i64 438, i64 %p1)
%t2111 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t2110)
ret i64 %t2111
}
define i8 @resid_fs_append_bytes(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_fs_append_bytes(i64 %x0i, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_fs_write_secret(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2112 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t2113 = xor i1 %t2112, true
br i1 %t2113, label %L805, label %L807
L805:
ret i64 0
L807:
%t2114 = call i64 @__mruntime_rt_sys_resid__o_write()
%t2115 = or i64 %t2114, 131072
%t2116 = call i64 @sys_open(i64 %p0, i64 %t2115, i64 384)
%t2117 = icmp slt i64 %t2116, 0
br i1 %t2117, label %L808, label %L810
L808:
ret i64 0
L810:
%t2118 = call i64 @sc(i64 91, i64 %t2116, i64 384, i64 0)
%t2119 = icmp eq i64 %t2118, 0
%t2120 = call i64 @__mruntime_rt_sys_resid__list_bytes(i64 %p1)
br label %LSL2121
LSL2121:
br i1 %t2119, label %LSR2121, label %LSJ2121
LSR2121:
%t2122 = call i64 @c_list_len(i64 %p1)
%t2123 = call i1 @write_all(i64 %t2116, i64 %t2120, i64 %t2122)
br label %LSJ2121
LSJ2121:
%t2124 = phi i1 [ false, %LSL2121 ], [ %t2123, %LSR2121 ]
%t2125 = call i64 @c_free(i64 %t2120)
%t2126 = call i64 @sys_close(i64 %t2116)
%t2127 = icmp eq i64 %t2126, 0
br label %LSL2128
LSL2128:
br i1 %t2127, label %LSR2128, label %LSJ2128
LSR2128:
br label %LSJ2128
LSJ2128:
%t2129 = phi i1 [ false, %LSL2128 ], [ %t2124, %LSR2128 ]
%t2130 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t2129)
ret i64 %t2130
}
define i8 @resid_fs_write_secret(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_fs_write_secret(i64 %x0i, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @__mruntime_rt_sys_resid__hex_val(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2131 = icmp sge i64 %p0, 48
br label %LSL2132
LSL2132:
br i1 %t2131, label %LSR2132, label %LSJ2132
LSR2132:
%t2133 = icmp sle i64 %p0, 57
br label %LSJ2132
LSJ2132:
%t2134 = phi i1 [ false, %LSL2132 ], [ %t2133, %LSR2132 ]
br i1 %t2134, label %L811, label %L813
L811:
%t2135 = sub nsw i64 %p0, 48
ret i64 %t2135
L813:
%t2136 = icmp sge i64 %p0, 97
br label %LSL2137
LSL2137:
br i1 %t2136, label %LSR2137, label %LSJ2137
LSR2137:
%t2138 = icmp sle i64 %p0, 102
br label %LSJ2137
LSJ2137:
%t2139 = phi i1 [ false, %LSL2137 ], [ %t2138, %LSR2137 ]
br i1 %t2139, label %L814, label %L816
L814:
%t2140 = sub nsw i64 %p0, 87
ret i64 %t2140
L816:
%t2141 = icmp sge i64 %p0, 65
br label %LSL2142
LSL2142:
br i1 %t2141, label %LSR2142, label %LSJ2142
LSR2142:
%t2143 = icmp sle i64 %p0, 70
br label %LSJ2142
LSJ2142:
%t2144 = phi i1 [ false, %LSL2142 ], [ %t2143, %LSR2142 ]
br i1 %t2144, label %L817, label %L819
L817:
%t2145 = sub nsw i64 %p0, 55
ret i64 %t2145
L819:
%t2146 = sub nsw i64 0, 1
ret i64 %t2146
}
define internal i1 @__mruntime_rt_sys_resid__unhex(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2165, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t2147 = icmp sge i64 %p2, %p3
br i1 %t2147, label %L820, label %L822
L820:
ret i1 true
L822:
%t2148 = mul i64 2, %p2
%t2149 = add i64 %p0, %t2148
%t2150 = call i64 @ld8(i64 %t2149)
%t2151 = call i64 @__mruntime_rt_sys_resid__hex_val(i64 %t2150)
%t2152 = mul i64 2, %p2
%t2153 = add i64 %p0, %t2152
%t2154 = add i64 %t2153, 1
%t2155 = call i64 @ld8(i64 %t2154)
%t2156 = call i64 @__mruntime_rt_sys_resid__hex_val(i64 %t2155)
%t2157 = icmp slt i64 %t2151, 0
br label %LSL2158
LSL2158:
br i1 %t2157, label %LSJ2158, label %LSR2158
LSR2158:
%t2159 = icmp slt i64 %t2156, 0
br label %LSJ2158
LSJ2158:
%t2160 = phi i1 [ true, %LSL2158 ], [ %t2159, %LSR2158 ]
br i1 %t2160, label %L823, label %L825
L823:
ret i1 false
L825:
%t2161 = add i64 %p1, %p2
%t2162 = mul i64 %t2151, 16
%t2163 = add i64 %t2162, %t2156
%t2164 = call i64 @st8(i64 %t2161, i64 %t2163)
%t2165 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__put_hex(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2167 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t2168 = xor i1 %t2167, true
br i1 %t2168, label %L826, label %L828
L826:
ret i64 0
L828:
%t2169 = call i64 @c_strlen(i64 %p1)
%t2170 = srem i64 %t2169, 2
%t2171 = icmp ne i64 %t2170, 0
br i1 %t2171, label %L829, label %L831
L829:
ret i64 0
L831:
%t2172 = sdiv i64 %t2169, 2
%t2173 = add nsw i64 %t2172, 1
%t2174 = call i64 @xmalloc(i64 %t2173)
%t2175 = sdiv i64 %t2169, 2
%t2176 = call i1 @__mruntime_rt_sys_resid__unhex(i64 %p1, i64 %t2174, i64 0, i64 %t2175)
br label %LSL2177
LSL2177:
br i1 %t2176, label %LSR2177, label %LSJ2177
LSR2177:
%t2178 = sdiv i64 %t2169, 2
%t2179 = call i1 @__mruntime_rt_sys_resid__put_file(i64 %p0, i64 %p2, i64 438, i64 %t2174, i64 %t2178)
br label %LSJ2177
LSJ2177:
%t2180 = phi i1 [ false, %LSL2177 ], [ %t2179, %LSR2177 ]
%t2181 = call i64 @c_free(i64 %t2174)
%t2182 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t2180)
ret i64 %t2182
}
define internal i64 @rt_fs_write_hex(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2183 = call i64 @__mruntime_rt_sys_resid__o_write()
%t2184 = call i64 @__mruntime_rt_sys_resid__put_hex(i64 %p0, i64 %p1, i64 %t2183)
ret i64 %t2184
}
define i8 @resid_fs_write_hex(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_fs_write_hex(i64 %x0i, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_fs_append_hex(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2185 = call i64 @__mruntime_rt_sys_resid__o_append()
%t2186 = call i64 @__mruntime_rt_sys_resid__put_hex(i64 %p0, i64 %p1, i64 %t2185)
ret i64 %t2186
}
define i8 @resid_fs_append_hex(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_fs_append_hex(i64 %x0i, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @__mruntime_rt_sys_resid__bytes_list(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2187 = mul i64 %p1, 8
%t2188 = call i64 @xmalloc(i64 %t2187)
%t2189 = call i64 @__mruntime_rt_sys_resid__box_bytes(i64 %p0, i64 %t2188, i64 0, i64 %p1)
%t2191 = ptrtoint ptr @.s2190 to i64
%t2192 = call i64 @c_list_new(i64 %p1, i64 %t2188, i64 %t2191)
%t2193 = call i64 @c_free(i64 %t2188)
%t2194 = mul nsw i64 %t2193, 0
%t2195 = add nsw i64 %t2194, %t2192
ret i64 %t2195
}
define internal i64 @__mruntime_rt_sys_resid__box_bytes(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2203, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t2196 = icmp sge i64 %p2, %p3
br i1 %t2196, label %L832, label %L834
L832:
ret i64 0
L834:
%t2197 = mul i64 %p2, 8
%t2198 = add i64 %p1, %t2197
%t2199 = add i64 %p0, %p2
%t2200 = call i64 @ld8(i64 %t2199)
%t2201 = call i64 @c_box_i64(i64 %t2200)
%t2202 = call i64 @st64(i64 %t2198, i64 %t2201)
%t2203 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__empty_bytes() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2206 = ptrtoint ptr @.s2205 to i64
%t2207 = call i64 @c_list_new(i64 0, i64 0, i64 %t2206)
ret i64 %t2207
}
define internal i64 @rt_fs_read_bytes(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2208 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t2209 = xor i1 %t2208, true
br i1 %t2209, label %L835, label %L837
L835:
%t2210 = call i64 @__mruntime_rt_sys_resid__empty_bytes()
ret i64 %t2210
L837:
%t2211 = call i64 @o_rdonly()
%t2212 = call i64 @sys_open(i64 %p0, i64 %t2211, i64 0)
%t2213 = icmp slt i64 %t2212, 0
br i1 %t2213, label %L838, label %L840
L838:
%t2214 = call i64 @__mruntime_rt_sys_resid__empty_bytes()
ret i64 %t2214
L840:
%t2215 = call i64 @__mruntime_rt_sys_resid__stat_buf()
%t2216 = call i64 @sc(i64 5, i64 %t2212, i64 %t2215, i64 0)
%t2217 = icmp eq i64 %t2216, 0
br i1 %t2217, label %L841, label %L842
L841:
%t2218 = add i64 %t2215, 48
%t2219 = call i64 @ld64(i64 %t2218)
br label %L843
L842:
br label %L843
L843:
%t2220 = phi i64 [ %t2219, %L841 ], [ 0, %L842 ]
%t2221 = icmp sgt i64 %t2220, 0
br i1 %t2221, label %L844, label %L845
L844:
br label %L846
L845:
br label %L846
L846:
%t2222 = phi i64 [ %t2220, %L844 ], [ 1, %L845 ]
%t2223 = call i64 @xmalloc(i64 %t2222)
%t2224 = call i64 @__mruntime_rt_sys_resid__read_n(i64 %t2212, i64 %t2223, i64 0, i64 %t2220)
%t2225 = call i64 @sys_close(i64 %t2212)
%t2226 = call i64 @__mruntime_rt_sys_resid__bytes_list(i64 %t2223, i64 %t2224)
%t2227 = call i64 @c_free(i64 %t2223)
%t2228 = mul nsw i64 %t2227, 0
%t2229 = add nsw i64 %t2228, %t2226
ret i64 %t2229
}
define ptr @resid_fs_read_bytes(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_fs_read_bytes(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_sys_resid__read_n(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2235, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t2230 = icmp sge i64 %p2, %p3
br i1 %t2230, label %L847, label %L849
L847:
ret i64 %p2
L849:
%t2231 = add i64 %p1, %p2
%t2232 = sub i64 %p3, %p2
%t2233 = call i64 @sc(i64 0, i64 %p0, i64 %t2231, i64 %t2232)
%t2234 = icmp sle i64 %t2233, 0
br i1 %t2234, label %L850, label %L852
L850:
ret i64 %p2
L852:
%t2235 = add i64 %p2, %t2233
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_print_bytes(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2237 = call i64 @__mruntime_rt_sys_resid__list_bytes(i64 %p0)
%t2238 = call i64 @c_list_len(i64 %p0)
%t2239 = call i1 @write_all(i64 1, i64 %t2237, i64 %t2238)
%t2240 = call i64 @c_free(i64 %t2237)
%t2241 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t2239)
ret i64 %t2241
}
define i8 @resid_print_bytes(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_print_bytes(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_fs_list_dir(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2243 = ptrtoint ptr @.s2242 to i64
%t2244 = call i64 @o_rdonly()
%t2245 = or i64 %t2244, 65536
%t2246 = call i64 @sys_open(i64 %p0, i64 %t2245, i64 0)
%t2247 = icmp slt i64 %t2246, 0
br i1 %t2247, label %L853, label %L855
L853:
%t2248 = call i64 @c_list_new(i64 0, i64 0, i64 %t2243)
ret i64 %t2248
L855:
%t2249 = call i64 @xmalloc(i64 32768)
%t2250 = mul nsw i64 64, 8
%t2251 = call i64 @xmalloc(i64 %t2250)
%t2252 = call i64 @__mruntime_rt_sys_resid__dir_entries(i64 %t2246, i64 %t2249, i64 %t2251, i64 0, i64 64)
%t2253 = call i64 @ld64(i64 %t2249)
%t2254 = call i64 @c_list_new(i64 %t2253, i64 %t2252, i64 %t2243)
%t2255 = call i64 @sys_close(i64 %t2246)
%t2256 = call i64 @c_free(i64 %t2252)
%t2257 = call i64 @c_free(i64 %t2249)
%t2258 = mul nsw i64 %t2257, 0
%t2259 = add nsw i64 %t2258, %t2254
ret i64 %t2259
}
define ptr @resid_fs_list_dir(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_fs_list_dir(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_sys_resid__dir_entries(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2260 = call i64 @sc(i64 217, i64 %p0, i64 %p1, i64 32768)
%t2261 = icmp sle i64 %t2260, 0
br i1 %t2261, label %L856, label %L858
L856:
%t2262 = call i64 @st64(i64 %p1, i64 %p3)
%t2263 = mul nsw i64 %t2262, 0
%t2264 = add nsw i64 %t2263, %p2
ret i64 %t2264
L858:
%t2265 = add i64 %p1, %t2260
%t2266 = call i64 @__mruntime_rt_sys_resid__dir_chunk(i64 %p0, i64 %p1, i64 %p1, i64 %t2265, i64 %p2, i64 %p3, i64 %p4)
ret i64 %t2266
}
define internal i64 @__mruntime_rt_sys_resid__dir_chunk(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2293, %tco.s0 ], [ %t2306, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ], [ %p3, %tco.s1 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ], [ %t2298, %tco.s1 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ], [ %t2307, %tco.s1 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ], [ %t2301, %tco.s1 ]
%t2267 = icmp sge i64 %p2, %p3
br i1 %t2267, label %L859, label %L861
L859:
%t2268 = call i64 @__mruntime_rt_sys_resid__dir_entries(i64 %p0, i64 %p1, i64 %p4, i64 %p5, i64 %p6)
ret i64 %t2268
L861:
%t2269 = add i64 %p2, 16
%t2270 = call i64 @ld8(i64 %t2269)
%t2271 = add i64 %p2, 17
%t2272 = call i64 @ld8(i64 %t2271)
%t2273 = shl i64 %t2272, 8
%t2274 = or i64 %t2270, %t2273
%t2275 = add i64 %p2, 19
%t2276 = call i64 @ld8(i64 %t2275)
%t2277 = icmp eq i64 %t2276, 46
br label %LSL2278
LSL2278:
br i1 %t2277, label %LSR2278, label %LSJ2278
LSR2278:
%t2279 = add i64 %t2275, 1
%t2280 = call i64 @ld8(i64 %t2279)
%t2281 = icmp eq i64 %t2280, 0
br label %LSL2282
LSL2282:
br i1 %t2281, label %LSJ2282, label %LSR2282
LSR2282:
%t2283 = add i64 %t2275, 1
%t2284 = call i64 @ld8(i64 %t2283)
%t2285 = icmp eq i64 %t2284, 46
br label %LSL2286
LSL2286:
br i1 %t2285, label %LSR2286, label %LSJ2286
LSR2286:
%t2287 = add i64 %t2275, 2
%t2288 = call i64 @ld8(i64 %t2287)
%t2289 = icmp eq i64 %t2288, 0
br label %LSJ2286
LSJ2286:
%t2290 = phi i1 [ false, %LSL2286 ], [ %t2289, %LSR2286 ]
br label %LSJ2282
LSJ2282:
%t2291 = phi i1 [ true, %LSL2282 ], [ %t2290, %LSJ2286 ]
br label %LSJ2278
LSJ2278:
%t2292 = phi i1 [ false, %LSL2278 ], [ %t2291, %LSJ2282 ]
br i1 %t2292, label %L862, label %L864
L862:
%t2293 = add i64 %p2, %t2274
br label %tco.s0
tco.s0:
br label %tco.head
L864:
%t2295 = icmp sge i64 %p5, %p6
br i1 %t2295, label %L865, label %L866
L865:
%t2296 = mul i64 %p6, 16
%t2297 = call i64 @xrealloc(i64 %p4, i64 %t2296)
br label %L867
L866:
br label %L867
L867:
%t2298 = phi i64 [ %t2297, %L865 ], [ %p4, %L866 ]
%t2299 = icmp sge i64 %p5, %p6
br i1 %t2299, label %L868, label %L869
L868:
%t2300 = mul i64 %p6, 2
br label %L870
L869:
br label %L870
L870:
%t2301 = phi i64 [ %t2300, %L868 ], [ %p6, %L869 ]
%t2302 = mul i64 %p5, 8
%t2303 = add i64 %t2298, %t2302
%t2304 = call i64 @cstr_dup(i64 %t2275)
%t2305 = call i64 @st64(i64 %t2303, i64 %t2304)
%t2306 = add i64 %p2, %t2274
%t2307 = add i64 %p5, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__file_tag() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 12
}
define internal i64 @rt_fs_open(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2309 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
br i1 %t2309, label %L871, label %L872
L871:
%t2310 = call i64 @o_rdonly()
%t2311 = call i64 @sys_open(i64 %p0, i64 %t2310, i64 0)
br label %L873
L872:
%t2312 = sub nsw i64 0, 1
br label %L873
L873:
%t2313 = phi i64 [ %t2311, %L871 ], [ %t2312, %L872 ]
%t2314 = call i64 @xmalloc(i64 24)
%t2315 = call i64 @__mruntime_rt_sys_resid__file_tag()
%t2316 = call i64 @st32(i64 %t2314, i64 %t2315)
%t2317 = add i64 %t2314, 4
%t2318 = call i64 @st32(i64 %t2317, i64 1)
%t2319 = add i64 %t2314, 8
%t2321 = ptrtoint ptr @.s2320 to i64
%t2322 = call i64 @st64(i64 %t2319, i64 %t2321)
%t2323 = add i64 %t2314, 16
%t2324 = icmp slt i64 %t2313, 0
br i1 %t2324, label %L874, label %L875
L874:
%t2325 = sub nsw i64 0, 1
br label %L876
L875:
br label %L876
L876:
%t2326 = phi i64 [ %t2325, %L874 ], [ %t2313, %L875 ]
%t2327 = call i64 @st64(i64 %t2323, i64 %t2326)
%t2328 = mul nsw i64 %t2327, 0
%t2329 = add nsw i64 %t2328, %t2314
ret i64 %t2329
}
define ptr @resid_fs_open(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_fs_open(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_sys_resid__handle_fd(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2330 = icmp eq i64 %p0, 0
br label %LSL2331
LSL2331:
br i1 %t2330, label %LSJ2331, label %LSR2331
LSR2331:
%t2332 = call i64 @ld32(i64 %p0)
%t2333 = call i64 @__mruntime_rt_sys_resid__file_tag()
%t2334 = icmp ne i64 %t2332, %t2333
br label %LSJ2331
LSJ2331:
%t2335 = phi i1 [ true, %LSL2331 ], [ %t2334, %LSR2331 ]
br label %LSL2336
LSL2336:
br i1 %t2335, label %LSJ2336, label %LSR2336
LSR2336:
%t2337 = add i64 %p0, 4
%t2338 = call i64 @ld32(i64 %t2337)
%t2339 = icmp slt i64 %t2338, 1
br label %LSJ2336
LSJ2336:
%t2340 = phi i1 [ true, %LSL2336 ], [ %t2339, %LSR2336 ]
br i1 %t2340, label %L877, label %L879
L877:
%t2341 = sub nsw i64 0, 1
ret i64 %t2341
L879:
%t2342 = add i64 %p0, 16
%t2343 = tail call i64 @ld64(i64 %t2342)
ret i64 %t2343
}
define internal i64 @rt_fs_read_handle(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2344 = call i64 @__mruntime_rt_sys_resid__handle_fd(i64 %p0)
%t2345 = icmp slt i64 %t2344, 0
br i1 %t2345, label %L880, label %L882
L880:
%t2346 = call i64 @xempty()
ret i64 %t2346
L882:
%t2347 = call i64 @sc(i64 8, i64 %t2344, i64 0, i64 2)
%t2348 = icmp slt i64 %t2347, 0
br label %LSL2349
LSL2349:
br i1 %t2348, label %LSJ2349, label %LSR2349
LSR2349:
%t2350 = call i64 @sc(i64 8, i64 %t2344, i64 0, i64 0)
%t2351 = icmp slt i64 %t2350, 0
br label %LSJ2349
LSJ2349:
%t2352 = phi i1 [ true, %LSL2349 ], [ %t2351, %LSR2349 ]
br i1 %t2352, label %L883, label %L885
L883:
%t2353 = call i64 @xempty()
ret i64 %t2353
L885:
%t2354 = add i64 %t2347, 1
%t2355 = call i64 @xmalloc(i64 %t2354)
%t2356 = call i64 @__mruntime_rt_sys_resid__read_n(i64 %t2344, i64 %t2355, i64 0, i64 %t2347)
%t2357 = add i64 %t2355, %t2356
%t2358 = call i64 @st8(i64 %t2357, i64 0)
%t2359 = add i64 %t2358, %t2355
ret i64 %t2359
}
define ptr @resid_fs_read_handle(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_fs_read_handle(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_fs_close(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2360 = icmp eq i64 %p0, 0
br i1 %t2360, label %L886, label %L888
L886:
ret i64 0
L888:
%t2361 = call i64 @__mruntime_rt_sys_resid__handle_fd(i64 %p0)
%t2362 = icmp sge i64 %t2361, 0
br i1 %t2362, label %L889, label %L890
L889:
%t2363 = call i64 @sys_close(i64 %t2361)
br label %L891
L890:
br label %L891
L891:
%t2364 = phi i64 [ %t2363, %L889 ], [ 0, %L890 ]
%t2365 = call i64 @c_free(i64 %p0)
%t2366 = add i64 %t2365, 1
ret i64 %t2366
}
define i8 @resid_fs_close(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_fs_close(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_handle_release(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2367 = icmp eq i64 %p0, 0
br i1 %t2367, label %L892, label %L893
L892:
br label %L894
L893:
%t2368 = call i64 @rt_fs_close(i64 %p0)
br label %L894
L894:
%t2369 = phi i64 [ 0, %L892 ], [ %t2368, %L893 ]
ret i64 %t2369
}
define void @resid_handle_release(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_handle_release(i64 %x0i)
ret void
}
define internal i64 @rt_env_get(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2370 = call i64 @c_getenv(i64 %p0)
%t2371 = icmp eq i64 %t2370, 0
br i1 %t2371, label %L895, label %L896
L895:
%t2372 = call i64 @xempty()
br label %L897
L896:
%t2373 = call i64 @cstr_dup(i64 %t2370)
br label %L897
L897:
%t2374 = phi i64 [ %t2372, %L895 ], [ %t2373, %L896 ]
ret i64 %t2374
}
define ptr @resid_env_get(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_env_get(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_env_has(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2375 = call i64 @c_getenv(i64 %p0)
%t2376 = icmp ne i64 %t2375, 0
%t2377 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t2376)
ret i64 %t2377
}
define i8 @resid_env_has(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_env_has(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @__mruntime_rt_sys_resid__args_state() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2378p = getelementptr i8, ptr @rtg.rt_args, i64 0
%t2378 = ptrtoint ptr %t2378p to i64
ret i64 %t2378
}
define internal i64 @__mruntime_rt_sys_resid__args_load() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2379 = call i64 @__mruntime_rt_sys_resid__args_state()
%t2380 = add i64 %t2379, 8
%t2381 = call i64 @ld64(i64 %t2380)
%t2382 = icmp ne i64 %t2381, 0
br i1 %t2382, label %L898, label %L900
L898:
ret i64 0
L900:
%t2384 = ptrtoint ptr @.s2383 to i64
%t2385 = call i64 @rt_fs_read_all(i64 %t2384)
%t2387 = ptrtoint ptr @.s2386 to i64
%t2388 = call i64 @__mruntime_rt_sys_resid__cmdline_len(i64 %t2387)
%t2389 = call i64 @__mruntime_rt_sys_resid__count_nuls(i64 %t2385, i64 0, i64 %t2388, i64 0)
%t2390 = add i64 %t2389, 1
%t2391 = mul i64 %t2390, 8
%t2392 = call i64 @xmalloc(i64 %t2391)
%t2393 = call i64 @__mruntime_rt_sys_resid__index_nuls(i64 %t2385, i64 %t2392, i64 0, i64 %t2388, i64 0, i64 0)
%t2394 = call i64 @st64(i64 %t2379, i64 %t2389)
%t2395 = add i64 %t2379, 16
%t2396 = call i64 @st64(i64 %t2395, i64 %t2392)
%t2397 = add i64 %t2379, 8
%t2398 = call i64 @st64(i64 %t2397, i64 %t2385)
ret i64 %t2398
}
define internal i64 @__mruntime_rt_sys_resid__cmdline_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2399 = call i64 @o_rdonly()
%t2400 = call i64 @sys_open(i64 %p0, i64 %t2399, i64 0)
%t2401 = icmp slt i64 %t2400, 0
br i1 %t2401, label %L901, label %L903
L901:
ret i64 0
L903:
%t2402 = call i64 @xmalloc(i64 65536)
%t2403 = call i64 @__mruntime_rt_sys_resid__count_read(i64 %t2400, i64 %t2402, i64 0)
%t2404 = call i64 @sys_close(i64 %t2400)
%t2405 = call i64 @c_free(i64 %t2402)
%t2406 = mul nsw i64 %t2405, 0
%t2407 = add nsw i64 %t2406, %t2403
ret i64 %t2407
}
define internal i64 @__mruntime_rt_sys_resid__count_read(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2410, %tco.s0 ]
%t2408 = call i64 @sc(i64 0, i64 %p0, i64 %p1, i64 65536)
%t2409 = icmp sle i64 %t2408, 0
br i1 %t2409, label %L904, label %L906
L904:
ret i64 %p2
L906:
%t2410 = add i64 %p2, %t2408
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__count_nuls(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2413, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t2418, %tco.s0 ]
%t2412 = icmp sge i64 %p1, %p2
br i1 %t2412, label %L907, label %L909
L907:
ret i64 %p3
L909:
%t2413 = add nsw i64 %p1, 1
%t2414 = add i64 %p0, %p1
%t2415 = call i64 @ld8(i64 %t2414)
%t2416 = icmp eq i64 %t2415, 0
br i1 %t2416, label %L910, label %L911
L910:
%t2417 = add i64 %p3, 1
br label %L912
L911:
br label %L912
L912:
%t2418 = phi i64 [ %t2417, %L910 ], [ %p3, %L911 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__index_nuls(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2424, %tco.s0 ], [ %t2430, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ], [ %p3, %tco.s1 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ], [ %t2431, %tco.s1 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ], [ %t2432, %tco.s1 ]
%t2420 = icmp sge i64 %p2, %p3
br i1 %t2420, label %L913, label %L915
L913:
ret i64 0
L915:
%t2421 = add i64 %p0, %p2
%t2422 = call i64 @ld8(i64 %t2421)
%t2423 = icmp ne i64 %t2422, 0
br i1 %t2423, label %L916, label %L918
L916:
%t2424 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
L918:
%t2426 = mul i64 %p5, 8
%t2427 = add i64 %p1, %t2426
%t2428 = add i64 %p0, %p4
%t2429 = call i64 @st64(i64 %t2427, i64 %t2428)
%t2430 = add nsw i64 %p2, 1
%t2431 = add nsw i64 %p2, 1
%t2432 = add i64 %p5, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @rt_args_count() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2434 = call i64 @__mruntime_rt_sys_resid__args_load()
%t2435 = mul nsw i64 %t2434, 0
%t2436 = call i64 @__mruntime_rt_sys_resid__args_state()
%t2437 = call i64 @ld64(i64 %t2436)
%t2438 = add nsw i64 %t2435, %t2437
ret i64 %t2438
}
define i64 @resid_args_count() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_args_count()
ret i64 %r
}
define internal i64 @rt_args_get(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2439 = call i64 @__mruntime_rt_sys_resid__args_load()
%t2440 = call i64 @__mruntime_rt_sys_resid__args_state()
%t2441 = icmp slt i64 %p0, 0
br label %LSL2442
LSL2442:
br i1 %t2441, label %LSJ2442, label %LSR2442
LSR2442:
%t2443 = call i64 @ld64(i64 %t2440)
%t2444 = icmp sge i64 %p0, %t2443
br label %LSJ2442
LSJ2442:
%t2445 = phi i1 [ true, %LSL2442 ], [ %t2444, %LSR2442 ]
br i1 %t2445, label %L919, label %L921
L919:
%t2446 = call i64 @xempty()
ret i64 %t2446
L921:
%t2447 = add i64 %t2440, 16
%t2448 = call i64 @ld64(i64 %t2447)
%t2449 = mul i64 %p0, 8
%t2450 = add i64 %t2448, %t2449
%t2451 = call i64 @ld64(i64 %t2450)
%t2452 = tail call i64 @cstr_dup(i64 %t2451)
ret i64 %t2452
}
define ptr @resid_args_get(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_args_get(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_sys_resid__split_argv(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2453 = call i64 @cstr_dup(i64 %p0)
%t2454 = mul nsw i64 65, 8
%t2455 = call i64 @xmalloc(i64 %t2454)
%t2456 = call i64 @__mruntime_rt_sys_resid__argv_at(i64 %t2453, i64 %t2455, i64 0)
%t2457 = mul i64 %t2456, 8
%t2458 = add i64 %t2455, %t2457
%t2459 = call i64 @st64(i64 %t2458, i64 0)
%t2460 = icmp eq i64 %t2456, 0
br i1 %t2460, label %L922, label %L924
L922:
%t2461 = call i64 @c_free(i64 %t2453)
%t2462 = call i64 @c_free(i64 %t2455)
%t2463 = add i64 %t2461, %t2462
ret i64 %t2463
L924:
ret i64 %t2455
}
define internal i64 @__mruntime_rt_sys_resid__skip_sp(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t2466, %tco.s0 ]
%t2464 = call i64 @ld8(i64 %p0)
%t2465 = icmp eq i64 %t2464, 32
br i1 %t2465, label %L925, label %L927
L925:
%t2466 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
L927:
ret i64 %p0
}
define internal i64 @__mruntime_rt_sys_resid__word_end(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t2473, %tco.s0 ]
%t2468 = call i64 @ld8(i64 %p0)
%t2469 = icmp eq i64 %t2468, 0
br label %LSL2470
LSL2470:
br i1 %t2469, label %LSJ2470, label %LSR2470
LSR2470:
%t2471 = icmp eq i64 %t2468, 32
br label %LSJ2470
LSJ2470:
%t2472 = phi i1 [ true, %LSL2470 ], [ %t2471, %LSR2470 ]
br i1 %t2472, label %L928, label %L930
L928:
ret i64 %p0
L930:
%t2473 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__argv_at(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t2487, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2488, %tco.s0 ]
%t2475 = icmp sge i64 %p2, 64
br i1 %t2475, label %L931, label %L933
L931:
ret i64 %p2
L933:
%t2476 = call i64 @__mruntime_rt_sys_resid__skip_sp(i64 %p0)
%t2477 = call i64 @ld8(i64 %t2476)
%t2478 = icmp eq i64 %t2477, 0
br i1 %t2478, label %L934, label %L936
L934:
ret i64 %p2
L936:
%t2479 = mul i64 %p2, 8
%t2480 = add i64 %p1, %t2479
%t2481 = call i64 @st64(i64 %t2480, i64 %t2476)
%t2482 = call i64 @__mruntime_rt_sys_resid__word_end(i64 %t2476)
%t2483 = call i64 @ld8(i64 %t2482)
%t2484 = icmp eq i64 %t2483, 0
br i1 %t2484, label %L937, label %L939
L937:
%t2485 = add nsw i64 %p2, 1
ret i64 %t2485
L939:
%t2486 = call i64 @st8(i64 %t2482, i64 0)
%t2487 = add i64 %t2482, 1
%t2488 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__free_argv(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2490 = call i64 @ld64(i64 %p0)
%t2491 = call i64 @c_free(i64 %t2490)
%t2492 = call i64 @c_free(i64 %p0)
%t2493 = add i64 %t2491, %t2492
ret i64 %t2493
}
define internal i64 @__mruntime_rt_sys_resid__wait_pid(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2494p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.wait_status)
%t2494 = ptrtoint ptr %t2494p to i64
%t2495 = call i64 @st64(i64 %t2494, i64 0)
%t2496 = call i64 @__mruntime_rt_sys_resid__sc4(i64 61, i64 %p0, i64 %t2494, i64 %p1, i64 0)
%t2497 = icmp slt i64 %t2496, 0
br i1 %t2497, label %L940, label %L942
L940:
%t2498 = sub nsw i64 0, 1
ret i64 %t2498
L942:
%t2499 = call i64 @ld32(i64 %t2494)
ret i64 %t2499
}
define internal i64 @__mruntime_rt_sys_resid__exit_code(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2500 = and i64 %p0, 127
%t2501 = icmp eq i64 %t2500, 0
br i1 %t2501, label %L943, label %L944
L943:
%t2502 = ashr i64 %p0, 8
%t2503 = and i64 %t2502, 255
br label %L945
L944:
%t2504 = sub nsw i64 0, 1
br label %L945
L945:
%t2505 = phi i64 [ %t2503, %L943 ], [ %t2504, %L944 ]
ret i64 %t2505
}
define internal i64 @rt_process_run(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2506 = icmp eq i64 %p0, 0
br i1 %t2506, label %L946, label %L948
L946:
%t2507 = sub nsw i64 0, 1
ret i64 %t2507
L948:
%t2508 = call i64 @__mruntime_rt_sys_resid__split_argv(i64 %p0)
%t2509 = icmp eq i64 %t2508, 0
br i1 %t2509, label %L949, label %L951
L949:
%t2510 = sub nsw i64 0, 1
ret i64 %t2510
L951:
%t2511 = call i64 @c_fork()
%t2512 = icmp slt i64 %t2511, 0
br i1 %t2512, label %L952, label %L954
L952:
%t2513 = call i64 @__mruntime_rt_sys_resid__free_argv(i64 %t2508)
%t2514 = sub i64 %t2513, 1
ret i64 %t2514
L954:
%t2515 = icmp eq i64 %t2511, 0
br i1 %t2515, label %L955, label %L957
L955:
%t2516 = call i64 @ld64(i64 %t2508)
%t2517 = call i64 @c_execvp(i64 %t2516, i64 %t2508)
%t2518 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 231, i64 127, i64 0, i64 0, i64 0, i64 0, i64 0)
ret i64 %t2518
L957:
%t2519 = call i64 @__mruntime_rt_sys_resid__wait_pid(i64 %t2511, i64 0)
%t2520 = call i64 @__mruntime_rt_sys_resid__free_argv(i64 %t2508)
%t2521 = icmp slt i64 %t2519, 0
br i1 %t2521, label %L958, label %L960
L958:
%t2522 = sub nsw i64 0, 1
ret i64 %t2522
L960:
%t2523 = tail call i64 @__mruntime_rt_sys_resid__exit_code(i64 %t2519)
ret i64 %t2523
}
define i64 @resid_process_run(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_process_run(i64 %x0i)
ret i64 %r
}
define internal i1 @__mruntime_rt_sys_resid__ref_ok(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2524 = call i64 @ld8(i64 %p0)
%t2525 = icmp eq i64 %t2524, 0
br i1 %t2525, label %L961, label %L963
L961:
ret i1 true
L963:
%t2526 = icmp sge i64 %t2524, 97
br label %LSL2527
LSL2527:
br i1 %t2526, label %LSR2527, label %LSJ2527
LSR2527:
%t2528 = icmp sle i64 %t2524, 122
br label %LSJ2527
LSJ2527:
%t2529 = phi i1 [ false, %LSL2527 ], [ %t2528, %LSR2527 ]
br label %LSL2530
LSL2530:
br i1 %t2529, label %LSJ2530, label %LSR2530
LSR2530:
%t2531 = icmp sge i64 %t2524, 65
br label %LSL2532
LSL2532:
br i1 %t2531, label %LSR2532, label %LSJ2532
LSR2532:
%t2533 = icmp sle i64 %t2524, 90
br label %LSJ2532
LSJ2532:
%t2534 = phi i1 [ false, %LSL2532 ], [ %t2533, %LSR2532 ]
br label %LSJ2530
LSJ2530:
%t2535 = phi i1 [ true, %LSL2530 ], [ %t2534, %LSJ2532 ]
br label %LSL2536
LSL2536:
br i1 %t2535, label %LSJ2536, label %LSR2536
LSR2536:
%t2537 = icmp sge i64 %t2524, 48
br label %LSL2538
LSL2538:
br i1 %t2537, label %LSR2538, label %LSJ2538
LSR2538:
%t2539 = icmp sle i64 %t2524, 57
br label %LSJ2538
LSJ2538:
%t2540 = phi i1 [ false, %LSL2538 ], [ %t2539, %LSR2538 ]
br label %LSJ2536
LSJ2536:
%t2541 = phi i1 [ true, %LSL2536 ], [ %t2540, %LSJ2538 ]
br label %LSL2542
LSL2542:
br i1 %t2541, label %LSJ2542, label %LSR2542
LSR2542:
%t2543 = icmp eq i64 %t2524, 45
br label %LSJ2542
LSJ2542:
%t2544 = phi i1 [ true, %LSL2542 ], [ %t2543, %LSR2542 ]
br label %LSL2545
LSL2545:
br i1 %t2544, label %LSJ2545, label %LSR2545
LSR2545:
%t2546 = icmp eq i64 %t2524, 95
br label %LSJ2545
LSJ2545:
%t2547 = phi i1 [ true, %LSL2545 ], [ %t2546, %LSR2545 ]
br label %LSL2548
LSL2548:
br i1 %t2547, label %LSJ2548, label %LSR2548
LSR2548:
%t2549 = icmp eq i64 %t2524, 47
br label %LSJ2548
LSJ2548:
%t2550 = phi i1 [ true, %LSL2548 ], [ %t2549, %LSR2548 ]
br label %LSL2551
LSL2551:
br i1 %t2550, label %LSJ2551, label %LSR2551
LSR2551:
%t2552 = icmp eq i64 %t2524, 46
br label %LSJ2551
LSJ2551:
%t2553 = phi i1 [ true, %LSL2551 ], [ %t2552, %LSR2551 ]
br label %LSL2554
LSL2554:
br i1 %t2553, label %LSR2554, label %LSJ2554
LSR2554:
%t2555 = add i64 %p0, 1
%t2556 = call i1 @__mruntime_rt_sys_resid__ref_ok(i64 %t2555)
br label %LSJ2554
LSJ2554:
%t2557 = phi i1 [ false, %LSL2554 ], [ %t2556, %LSR2554 ]
ret i1 %t2557
}
define internal i64 @__mruntime_rt_sys_resid__popen_line(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2559 = ptrtoint ptr @.s2558 to i64
%t2560 = call i64 @c_popen(i64 %p0, i64 %t2559)
%t2561 = icmp eq i64 %t2560, 0
br i1 %t2561, label %L964, label %L966
L964:
%t2562 = call i64 @xempty()
ret i64 %t2562
L966:
%t2563 = call i64 @xmalloc(i64 256)
%t2564 = call i64 @c_fgets(i64 %t2563, i64 256, i64 %t2560)
%t2565 = call i64 @c_pclose(i64 %t2560)
%t2566 = icmp eq i64 %t2564, 0
br i1 %t2566, label %L967, label %L969
L967:
%t2567 = call i64 @st8(i64 %t2563, i64 0)
%t2568 = add i64 %t2567, %t2563
ret i64 %t2568
L969:
%t2569 = call i64 @c_strlen(i64 %t2563)
%t2570 = icmp sgt i64 %t2569, 0
br label %LSL2571
LSL2571:
br i1 %t2570, label %LSR2571, label %LSJ2571
LSR2571:
%t2572 = add i64 %t2563, %t2569
%t2573 = sub nsw i64 %t2572, 1
%t2574 = call i64 @ld8(i64 %t2573)
%t2575 = icmp eq i64 %t2574, 10
br label %LSJ2571
LSJ2571:
%t2576 = phi i1 [ false, %LSL2571 ], [ %t2575, %LSR2571 ]
br i1 %t2576, label %L970, label %L971
L970:
%t2577 = add i64 %t2563, %t2569
%t2578 = sub nsw i64 %t2577, 1
%t2579 = call i64 @st8(i64 %t2578, i64 0)
br label %L972
L971:
br label %L972
L972:
%t2580 = phi i64 [ %t2579, %L970 ], [ 0, %L971 ]
ret i64 %t2563
}
define internal i64 @rt_git_rev(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2581 = icmp eq i64 %p0, 0
br label %LSL2582
LSL2582:
br i1 %t2581, label %LSJ2582, label %LSR2582
LSR2582:
%t2583 = call i64 @ld8(i64 %p0)
%t2584 = icmp eq i64 %t2583, 0
br label %LSJ2582
LSJ2582:
%t2585 = phi i1 [ true, %LSL2582 ], [ %t2584, %LSR2582 ]
br label %LSL2586
LSL2586:
br i1 %t2585, label %LSJ2586, label %LSR2586
LSR2586:
%t2587 = call i1 @__mruntime_rt_sys_resid__ref_ok(i64 %p0)
%t2588 = xor i1 %t2587, true
br label %LSJ2586
LSJ2586:
%t2589 = phi i1 [ true, %LSL2586 ], [ %t2588, %LSR2586 ]
br label %LSL2590
LSL2590:
br i1 %t2589, label %LSJ2590, label %LSR2590
LSR2590:
%t2591 = call i64 @c_strlen(i64 %p0)
%t2592 = icmp sgt i64 %t2591, 4000
br label %LSJ2590
LSJ2590:
%t2593 = phi i1 [ true, %LSL2590 ], [ %t2592, %LSR2590 ]
br i1 %t2593, label %L973, label %L975
L973:
%t2594 = call i64 @xempty()
ret i64 %t2594
L975:
%t2596 = ptrtoint ptr @.s2595 to i64
%t2597 = call i64 @rt_str_concat(i64 %t2596, i64 %p0)
%t2599 = ptrtoint ptr @.s2598 to i64
%t2600 = call i64 @rt_str_concat(i64 %t2597, i64 %t2599)
%t2601 = tail call i64 @__mruntime_rt_sys_resid__popen_line(i64 %t2600)
ret i64 %t2601
}
define ptr @resid_git_rev(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_git_rev(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_git_branch() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2603 = ptrtoint ptr @.s2602 to i64
%t2604 = call i64 @__mruntime_rt_sys_resid__popen_line(i64 %t2603)
%t2605 = call i64 @__mruntime_rt_sys_resid__sanitize_ref(i64 %t2604)
ret i64 %t2604
}
define ptr @resid_git_branch() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_git_branch()
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_sys_resid__sanitize_ref(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t2638, %tco.s0 ]
%t2606 = call i64 @ld8(i64 %p0)
%t2607 = icmp eq i64 %t2606, 0
br i1 %t2607, label %L976, label %L978
L976:
ret i64 0
L978:
%t2608 = icmp sge i64 %t2606, 97
br label %LSL2609
LSL2609:
br i1 %t2608, label %LSR2609, label %LSJ2609
LSR2609:
%t2610 = icmp sle i64 %t2606, 122
br label %LSJ2609
LSJ2609:
%t2611 = phi i1 [ false, %LSL2609 ], [ %t2610, %LSR2609 ]
br label %LSL2612
LSL2612:
br i1 %t2611, label %LSJ2612, label %LSR2612
LSR2612:
%t2613 = icmp sge i64 %t2606, 65
br label %LSL2614
LSL2614:
br i1 %t2613, label %LSR2614, label %LSJ2614
LSR2614:
%t2615 = icmp sle i64 %t2606, 90
br label %LSJ2614
LSJ2614:
%t2616 = phi i1 [ false, %LSL2614 ], [ %t2615, %LSR2614 ]
br label %LSJ2612
LSJ2612:
%t2617 = phi i1 [ true, %LSL2612 ], [ %t2616, %LSJ2614 ]
br label %LSL2618
LSL2618:
br i1 %t2617, label %LSJ2618, label %LSR2618
LSR2618:
%t2619 = icmp sge i64 %t2606, 48
br label %LSL2620
LSL2620:
br i1 %t2619, label %LSR2620, label %LSJ2620
LSR2620:
%t2621 = icmp sle i64 %t2606, 57
br label %LSJ2620
LSJ2620:
%t2622 = phi i1 [ false, %LSL2620 ], [ %t2621, %LSR2620 ]
br label %LSJ2618
LSJ2618:
%t2623 = phi i1 [ true, %LSL2618 ], [ %t2622, %LSJ2620 ]
br label %LSL2624
LSL2624:
br i1 %t2623, label %LSJ2624, label %LSR2624
LSR2624:
%t2625 = icmp eq i64 %t2606, 45
br label %LSJ2624
LSJ2624:
%t2626 = phi i1 [ true, %LSL2624 ], [ %t2625, %LSR2624 ]
br label %LSL2627
LSL2627:
br i1 %t2626, label %LSJ2627, label %LSR2627
LSR2627:
%t2628 = icmp eq i64 %t2606, 95
br label %LSJ2627
LSJ2627:
%t2629 = phi i1 [ true, %LSL2627 ], [ %t2628, %LSR2627 ]
br label %LSL2630
LSL2630:
br i1 %t2629, label %LSJ2630, label %LSR2630
LSR2630:
%t2631 = icmp eq i64 %t2606, 47
br label %LSJ2630
LSJ2630:
%t2632 = phi i1 [ true, %LSL2630 ], [ %t2631, %LSR2630 ]
br label %LSL2633
LSL2633:
br i1 %t2632, label %LSJ2633, label %LSR2633
LSR2633:
%t2634 = icmp eq i64 %t2606, 46
br label %LSJ2633
LSJ2633:
%t2635 = phi i1 [ true, %LSL2633 ], [ %t2634, %LSR2633 ]
br i1 %t2635, label %L979, label %L980
L979:
br label %L981
L980:
%t2636 = call i64 @st8(i64 %p0, i64 95)
br label %L981
L981:
%t2637 = phi i64 [ 0, %L979 ], [ %t2636, %L980 ]
%t2638 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__sha_k() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2640 = ptrtoint ptr @rtt.17089 to i64
ret i64 %t2640
}
define internal i64 @__mruntime_rt_sys_resid__m32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2641 = and i64 %p0, 4294967295
ret i64 %t2641
}
define internal i64 @__mruntime_rt_sys_resid__ror32(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2642 = icmp uge i64 %p1, 64
%t2643 = add i64 %p1, 0
%t2644 = select i1 %t2642, i64 63, i64 %t2643
%t2645 = ashr i64 %p0, %t2644
%t2646 = sub i64 32, %p1
%t2647 = icmp uge i64 %t2646, 64
%t2648 = add i64 %t2646, 0
%t2649 = shl i64 %p0, %t2648
%t2650 = select i1 %t2647, i64 0, i64 %t2649
%t2651 = or i64 %t2645, %t2650
%t2652 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2651)
ret i64 %t2652
}
define internal i64 @__mruntime_rt_sys_resid__sha_block(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2653 = call i64 @__mruntime_rt_sys_resid__sha_load(i64 %p2, i64 %p1, i64 0)
%t2654 = call i64 @__mruntime_rt_sys_resid__sha_expand(i64 %p2, i64 16)
%t2655 = call i64 @ld64(i64 %p0)
%t2656 = add i64 %p0, 8
%t2657 = call i64 @ld64(i64 %t2656)
%t2658 = add i64 %p0, 16
%t2659 = call i64 @ld64(i64 %t2658)
%t2660 = add i64 %p0, 24
%t2661 = call i64 @ld64(i64 %t2660)
%t2662 = add i64 %p0, 32
%t2663 = call i64 @ld64(i64 %t2662)
%t2664 = add i64 %p0, 40
%t2665 = call i64 @ld64(i64 %t2664)
%t2666 = add i64 %p0, 48
%t2667 = call i64 @ld64(i64 %t2666)
%t2668 = add i64 %p0, 56
%t2669 = call i64 @ld64(i64 %t2668)
%t2670 = call i64 @__mruntime_rt_sys_resid__sha_rounds(i64 %p0, i64 %p2, i64 0, i64 %t2655, i64 %t2657, i64 %t2659, i64 %t2661, i64 %t2663, i64 %t2665, i64 %t2667, i64 %t2669)
ret i64 0
}
define internal i64 @__mruntime_rt_sys_resid__sha_load(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2696, %tco.s0 ]
%t2671 = icmp sge i64 %p2, 16
br i1 %t2671, label %L982, label %L984
L982:
ret i64 0
L984:
%t2672 = mul i64 4, %p2
%t2673 = add i64 %p1, %t2672
%t2674 = call i64 @ld8(i64 %t2673)
%t2675 = shl i64 %t2674, 24
%t2676 = mul i64 4, %p2
%t2677 = add i64 %p1, %t2676
%t2678 = add i64 %t2677, 1
%t2679 = call i64 @ld8(i64 %t2678)
%t2680 = shl i64 %t2679, 16
%t2681 = or i64 %t2675, %t2680
%t2682 = mul i64 4, %p2
%t2683 = add i64 %p1, %t2682
%t2684 = add i64 %t2683, 2
%t2685 = call i64 @ld8(i64 %t2684)
%t2686 = shl i64 %t2685, 8
%t2687 = or i64 %t2681, %t2686
%t2688 = mul i64 4, %p2
%t2689 = add i64 %p1, %t2688
%t2690 = add i64 %t2689, 3
%t2691 = call i64 @ld8(i64 %t2690)
%t2692 = or i64 %t2687, %t2691
%t2693 = mul i64 %p2, 8
%t2694 = add i64 %p0, %t2693
%t2695 = call i64 @st64(i64 %t2694, i64 %t2692)
%t2696 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__sha_expand(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2732, %tco.s0 ]
%t2698 = icmp sge i64 %p1, 64
br i1 %t2698, label %L985, label %L987
L985:
ret i64 0
L987:
%t2699 = sub i64 %p1, 15
%t2700 = mul i64 %t2699, 8
%t2701 = add i64 %p0, %t2700
%t2702 = call i64 @ld64(i64 %t2701)
%t2703 = sub i64 %p1, 2
%t2704 = mul i64 %t2703, 8
%t2705 = add i64 %p0, %t2704
%t2706 = call i64 @ld64(i64 %t2705)
%t2707 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %t2702, i64 7)
%t2708 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %t2702, i64 18)
%t2709 = xor i64 %t2707, %t2708
%t2710 = ashr i64 %t2702, 3
%t2711 = xor i64 %t2709, %t2710
%t2712 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %t2706, i64 17)
%t2713 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %t2706, i64 19)
%t2714 = xor i64 %t2712, %t2713
%t2715 = ashr i64 %t2706, 10
%t2716 = xor i64 %t2714, %t2715
%t2717 = mul i64 %p1, 8
%t2718 = add i64 %p0, %t2717
%t2719 = sub i64 %p1, 16
%t2720 = mul i64 %t2719, 8
%t2721 = add i64 %p0, %t2720
%t2722 = call i64 @ld64(i64 %t2721)
%t2723 = add i64 %t2722, %t2711
%t2724 = sub i64 %p1, 7
%t2725 = mul i64 %t2724, 8
%t2726 = add i64 %p0, %t2725
%t2727 = call i64 @ld64(i64 %t2726)
%t2728 = add i64 %t2723, %t2727
%t2729 = add i64 %t2728, %t2716
%t2730 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2729)
%t2731 = call i64 @st64(i64 %t2718, i64 %t2730)
%t2732 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__sha_rounds(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2815, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t2817, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p3, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0 ]
%p7 = phi i64 [ %p7.in, %entry ], [ %t2819, %tco.s0 ]
%p8 = phi i64 [ %p8.in, %entry ], [ %p7, %tco.s0 ]
%p9 = phi i64 [ %p9.in, %entry ], [ %p8, %tco.s0 ]
%p10 = phi i64 [ %p10.in, %entry ], [ %p9, %tco.s0 ]
%t2734 = icmp sge i64 %p2, 64
br i1 %t2734, label %L988, label %L990
L988:
%t2735 = call i64 @ld64(i64 %p0)
%t2736 = add i64 %t2735, %p3
%t2737 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2736)
%t2738 = call i64 @st64(i64 %p0, i64 %t2737)
%t2739 = add i64 %p0, 8
%t2740 = add i64 %p0, 8
%t2741 = call i64 @ld64(i64 %t2740)
%t2742 = add i64 %t2741, %p4
%t2743 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2742)
%t2744 = call i64 @st64(i64 %t2739, i64 %t2743)
%t2745 = add i64 %p0, 16
%t2746 = add i64 %p0, 16
%t2747 = call i64 @ld64(i64 %t2746)
%t2748 = add i64 %t2747, %p5
%t2749 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2748)
%t2750 = call i64 @st64(i64 %t2745, i64 %t2749)
%t2751 = add i64 %p0, 24
%t2752 = add i64 %p0, 24
%t2753 = call i64 @ld64(i64 %t2752)
%t2754 = add i64 %t2753, %p6
%t2755 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2754)
%t2756 = call i64 @st64(i64 %t2751, i64 %t2755)
%t2757 = add i64 %p0, 32
%t2758 = add i64 %p0, 32
%t2759 = call i64 @ld64(i64 %t2758)
%t2760 = add i64 %t2759, %p7
%t2761 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2760)
%t2762 = call i64 @st64(i64 %t2757, i64 %t2761)
%t2763 = add i64 %p0, 40
%t2764 = add i64 %p0, 40
%t2765 = call i64 @ld64(i64 %t2764)
%t2766 = add i64 %t2765, %p8
%t2767 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2766)
%t2768 = call i64 @st64(i64 %t2763, i64 %t2767)
%t2769 = add i64 %p0, 48
%t2770 = add i64 %p0, 48
%t2771 = call i64 @ld64(i64 %t2770)
%t2772 = add i64 %t2771, %p9
%t2773 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2772)
%t2774 = call i64 @st64(i64 %t2769, i64 %t2773)
%t2775 = add i64 %p0, 56
%t2776 = add i64 %p0, 56
%t2777 = call i64 @ld64(i64 %t2776)
%t2778 = add i64 %t2777, %p10
%t2779 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2778)
%t2780 = call i64 @st64(i64 %t2775, i64 %t2779)
ret i64 %t2780
L990:
%t2781 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %p7, i64 6)
%t2782 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %p7, i64 11)
%t2783 = xor i64 %t2781, %t2782
%t2784 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %p7, i64 25)
%t2785 = xor i64 %t2783, %t2784
%t2786 = add i64 %p10, %t2785
%t2787 = and i64 %p7, %p8
%t2788 = xor i64 %p7, -1
%t2789 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2788)
%t2790 = and i64 %t2789, %p9
%t2791 = xor i64 %t2787, %t2790
%t2792 = add i64 %t2786, %t2791
%t2793 = call i64 @__mruntime_rt_sys_resid__sha_k()
%t2794 = mul i64 %p2, 8
%t2795 = add i64 %t2793, %t2794
%t2796 = call i64 @ld64(i64 %t2795)
%t2797 = add i64 %t2792, %t2796
%t2798 = mul i64 %p2, 8
%t2799 = add i64 %p1, %t2798
%t2800 = call i64 @ld64(i64 %t2799)
%t2801 = add i64 %t2797, %t2800
%t2802 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2801)
%t2803 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %p3, i64 2)
%t2804 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %p3, i64 13)
%t2805 = xor i64 %t2803, %t2804
%t2806 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %p3, i64 22)
%t2807 = xor i64 %t2805, %t2806
%t2808 = and i64 %p3, %p4
%t2809 = and i64 %p3, %p5
%t2810 = xor i64 %t2808, %t2809
%t2811 = and i64 %p4, %p5
%t2812 = xor i64 %t2810, %t2811
%t2813 = add i64 %t2807, %t2812
%t2814 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2813)
%t2815 = add nsw i64 %p2, 1
%t2816 = add i64 %t2802, %t2814
%t2817 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2816)
%t2818 = add i64 %p6, %t2802
%t2819 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2818)
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__sha_new() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2821 = add nsw i64 64, 512
%t2822 = add nsw i64 %t2821, 128
%t2823 = call i64 @xmalloc(i64 %t2822)
%t2824 = ptrtoint ptr @rtt.17603 to i64
%t2825 = call i64 @mcopy(i64 %t2823, i64 %t2824, i64 64)
%t2826 = add i64 %t2825, %t2823
ret i64 %t2826
}
define internal i64 @__mruntime_rt_sys_resid__sha_bytes(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2827 = sub nsw i64 0, 64
%t2828 = and i64 %p2, %t2827
%t2829 = call i64 @__mruntime_rt_sys_resid__sha_blocks(i64 %p0, i64 %p1, i64 0, i64 %t2828)
ret i64 %t2828
}
define internal i64 @__mruntime_rt_sys_resid__sha_blocks(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2834, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t2830 = icmp sge i64 %p2, %p3
br i1 %t2830, label %L991, label %L993
L991:
ret i64 0
L993:
%t2831 = add i64 %p1, %p2
%t2832 = add i64 %p0, 64
%t2833 = call i64 @__mruntime_rt_sys_resid__sha_block(i64 %p0, i64 %t2831, i64 %t2832)
%t2834 = add i64 %p2, 64
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__sha_finish(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2836 = add i64 %p0, 576
%t2837 = call i64 @mcopy(i64 %t2836, i64 %p1, i64 %p2)
%t2838 = add i64 %t2836, %p2
%t2839 = call i64 @st8(i64 %t2838, i64 128)
%t2840 = add i64 %p2, 1
%t2841 = icmp sle i64 %t2840, 56
br i1 %t2841, label %L994, label %L995
L994:
br label %L996
L995:
br label %L996
L996:
%t2842 = phi i64 [ 64, %L994 ], [ 128, %L995 ]
%t2843 = add i64 %t2836, %p2
%t2844 = add i64 %t2843, 1
%t2845 = sub i64 %t2842, %p2
%t2846 = sub i64 %t2845, 1
%t2847p = inttoptr i64 %t2844 to ptr
%t2847q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t2847p, i8 %t2847q, i64 %t2846, i1 false)
%t2847 = add i64 0, 0
%t2848 = mul i64 %p3, 8
%t2849 = add i64 %t2836, %t2842
%t2850 = sub i64 %t2849, 8
%t2851 = call i64 @__mruntime_rt_sys_resid__sha_len(i64 %t2850, i64 %t2848, i64 0)
%t2852 = tail call i64 @__mruntime_rt_sys_resid__sha_blocks(i64 %p0, i64 %t2836, i64 0, i64 %t2842)
ret i64 %t2852
}
define internal i64 @__mruntime_rt_sys_resid__sha_len(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2859, %tco.s0 ]
%t2853 = icmp sge i64 %p2, 8
br i1 %t2853, label %L997, label %L999
L997:
ret i64 0
L999:
%t2854 = add i64 %p0, 7
%t2855 = sub i64 %t2854, %p2
%t2856 = mul i64 8, %p2
%t2857 = call i64 @lshr(i64 %p1, i64 %t2856)
%t2858 = call i64 @st8(i64 %t2855, i64 %t2857)
%t2859 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__sha_byte(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2861 = sdiv i64 %p1, 4
%t2862 = mul i64 %t2861, 8
%t2863 = add i64 %p0, %t2862
%t2864 = call i64 @ld64(i64 %t2863)
%t2865 = srem i64 %p1, 4
%t2866 = mul nsw i64 8, %t2865
%t2867 = sub nsw i64 24, %t2866
%t2868 = icmp uge i64 %t2867, 64
%t2869 = add i64 %t2867, 0
%t2870 = select i1 %t2868, i64 63, i64 %t2869
%t2871 = ashr i64 %t2864, %t2870
%t2872 = and i64 %t2871, 255
ret i64 %t2872
}
define internal i64 @rt_fs_sha256(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2873 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t2874 = xor i1 %t2873, true
br i1 %t2874, label %L1000, label %L1002
L1000:
%t2875 = call i64 @__mruntime_rt_sys_resid__empty_bytes()
ret i64 %t2875
L1002:
%t2876 = call i64 @o_rdonly()
%t2877 = call i64 @sys_open(i64 %p0, i64 %t2876, i64 0)
%t2878 = icmp slt i64 %t2877, 0
br i1 %t2878, label %L1003, label %L1005
L1003:
%t2879 = call i64 @__mruntime_rt_sys_resid__empty_bytes()
ret i64 %t2879
L1005:
%t2880 = call i64 @__mruntime_rt_sys_resid__sha_new()
%t2881 = call i64 @xmalloc(i64 65536)
%t2882 = call i64 @__mruntime_rt_sys_resid__sha_file(i64 %t2877, i64 %t2880, i64 %t2881, i64 0, i64 0)
%t2883 = call i64 @sys_close(i64 %t2877)
%t2884 = srem i64 %t2882, 64
%t2885 = call i64 @__mruntime_rt_sys_resid__sha_finish(i64 %t2880, i64 %t2881, i64 %t2884, i64 %t2882)
%t2886 = call i64 @xmalloc(i64 32)
%t2887 = call i64 @__mruntime_rt_sys_resid__sha_out(i64 %t2880, i64 %t2886, i64 0)
%t2888 = call i64 @__mruntime_rt_sys_resid__bytes_list(i64 %t2886, i64 32)
%t2889 = call i64 @c_free(i64 %t2886)
%t2890 = call i64 @c_free(i64 %t2881)
%t2891 = add i64 %t2889, %t2890
%t2892 = call i64 @c_free(i64 %t2880)
%t2893 = add i64 %t2891, %t2892
%t2894 = add i64 %t2893, %t2888
ret i64 %t2894
}
define ptr @resid_fs_sha256(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_fs_sha256(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_sys_resid__sha_file(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t2901, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t2904, %tco.s0 ]
%t2895 = add i64 %p2, %p3
%t2896 = sub i64 65536, %p3
%t2897 = call i64 @sc(i64 0, i64 %p0, i64 %t2895, i64 %t2896)
%t2898 = icmp sle i64 %t2897, 0
br i1 %t2898, label %L1006, label %L1008
L1006:
ret i64 %p4
L1008:
%t2899 = add i64 %p3, %t2897
%t2900 = call i64 @__mruntime_rt_sys_resid__sha_bytes(i64 %p1, i64 %p2, i64 %t2899)
%t2901 = sub i64 %t2899, %t2900
%t2902 = add i64 %p2, %t2900
%t2903 = call i64 @mcopy(i64 %p2, i64 %t2902, i64 %t2901)
%t2904 = add i64 %p4, %t2897
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__sha_out(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2910, %tco.s0 ]
%t2906 = icmp sge i64 %p2, 32
br i1 %t2906, label %L1009, label %L1011
L1009:
ret i64 0
L1011:
%t2907 = add i64 %p1, %p2
%t2908 = call i64 @__mruntime_rt_sys_resid__sha_byte(i64 %p0, i64 %p2)
%t2909 = call i64 @st8(i64 %t2907, i64 %t2908)
%t2910 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_sha256(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2912 = call i64 @c_strlen(i64 %p0)
%t2913 = call i64 @__mruntime_rt_sys_resid__sha_new()
%t2914 = call i64 @__mruntime_rt_sys_resid__sha_bytes(i64 %t2913, i64 %p0, i64 %t2912)
%t2915 = add i64 %p0, %t2914
%t2916 = sub i64 %t2912, %t2914
%t2917 = call i64 @__mruntime_rt_sys_resid__sha_finish(i64 %t2913, i64 %t2915, i64 %t2916, i64 %t2912)
%t2918 = call i64 @xmalloc(i64 65)
%t2919 = call i64 @__mruntime_rt_sys_resid__sha_hex(i64 %t2913, i64 %t2918, i64 0)
%t2920 = add i64 %t2918, 64
%t2921 = call i64 @st8(i64 %t2920, i64 0)
%t2922 = call i64 @c_free(i64 %t2913)
%t2923 = add i64 %t2922, %t2918
ret i64 %t2923
}
define ptr @str_sha256(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_sha256(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_sys_resid__sha_hex(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2941, %tco.s0 ]
%t2924 = icmp sge i64 %p2, 32
br i1 %t2924, label %L1012, label %L1014
L1012:
ret i64 0
L1014:
%t2925 = call i64 @__mruntime_rt_sys_resid__sha_byte(i64 %p0, i64 %p2)
%t2927 = ptrtoint ptr @.s2926 to i64
%t2928 = mul i64 2, %p2
%t2929 = add i64 %p1, %t2928
%t2930 = ashr i64 %t2925, 4
%t2931 = add i64 %t2927, %t2930
%t2932 = call i64 @ld8(i64 %t2931)
%t2933 = call i64 @st8(i64 %t2929, i64 %t2932)
%t2934 = mul i64 2, %p2
%t2935 = add i64 %p1, %t2934
%t2936 = add i64 %t2935, 1
%t2937 = and i64 %t2925, 15
%t2938 = add i64 %t2927, %t2937
%t2939 = call i64 @ld8(i64 %t2938)
%t2940 = call i64 @st8(i64 %t2936, i64 %t2939)
%t2941 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__dbg() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2943p = getelementptr i8, ptr @rtg.rt_dbg, i64 0
%t2943 = ptrtoint ptr %t2943p to i64
ret i64 %t2943
}
define internal i64 @__mruntime_rt_sys_resid__ptrace(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2944 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 101, i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 0)
ret i64 %t2944
}
define internal i1 @__mruntime_rt_sys_resid__dbg_known(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2955, %tco.s0 ]
%t2945 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2946 = add i64 %t2945, 8
%t2947 = call i64 @ld64(i64 %t2946)
%t2948 = icmp sge i64 %p1, %t2947
br i1 %t2948, label %L1015, label %L1017
L1015:
ret i1 false
L1017:
%t2949 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2950 = add i64 %t2949, 32
%t2951 = mul i64 %p1, 8
%t2952 = add i64 %t2950, %t2951
%t2953 = call i64 @ld64(i64 %t2952)
%t2954 = icmp eq i64 %t2953, %p0
br i1 %t2954, label %L1018, label %L1020
L1018:
ret i1 true
L1020:
%t2955 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__dbg_add(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2957 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2958 = add i64 %t2957, 8
%t2959 = call i64 @ld64(i64 %t2958)
%t2960 = call i1 @__mruntime_rt_sys_resid__dbg_known(i64 %p0, i64 0)
br label %LSL2961
LSL2961:
br i1 %t2960, label %LSJ2961, label %LSR2961
LSR2961:
%t2962 = icmp sge i64 %t2959, 1024
br label %LSJ2961
LSJ2961:
%t2963 = phi i1 [ true, %LSL2961 ], [ %t2962, %LSR2961 ]
br i1 %t2963, label %L1021, label %L1023
L1021:
ret i64 0
L1023:
%t2964 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2965 = add i64 %t2964, 32
%t2966 = mul i64 %t2959, 8
%t2967 = add i64 %t2965, %t2966
%t2968 = call i64 @st64(i64 %t2967, i64 %p0)
%t2969 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2970 = add i64 %t2969, 8
%t2971 = add nsw i64 %t2959, 1
%t2972 = call i64 @st64(i64 %t2970, i64 %t2971)
ret i64 %t2972
}
define internal i64 @__mruntime_rt_sys_resid__dbg_remove(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2973 = call i64 @__mruntime_rt_sys_resid__dbg_remove_at(i64 %p0, i64 0)
ret i64 %t2973
}
define internal i64 @__mruntime_rt_sys_resid__dbg_remove_at(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2984, %tco.s0 ]
%t2974 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2975 = add i64 %t2974, 8
%t2976 = call i64 @ld64(i64 %t2975)
%t2977 = icmp sge i64 %p1, %t2976
br i1 %t2977, label %L1024, label %L1026
L1024:
ret i64 0
L1026:
%t2978 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2979 = add i64 %t2978, 32
%t2980 = mul i64 %p1, 8
%t2981 = add i64 %t2979, %t2980
%t2982 = call i64 @ld64(i64 %t2981)
%t2983 = icmp ne i64 %t2982, %p0
br i1 %t2983, label %L1027, label %L1029
L1027:
%t2984 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L1029:
%t2986 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2987 = add i64 %t2986, 32
%t2988 = mul i64 %p1, 8
%t2989 = add i64 %t2987, %t2988
%t2990 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2991 = add i64 %t2990, 32
%t2992 = sub nsw i64 %t2976, 1
%t2993 = mul i64 %t2992, 8
%t2994 = add i64 %t2991, %t2993
%t2995 = call i64 @ld64(i64 %t2994)
%t2996 = call i64 @st64(i64 %t2989, i64 %t2995)
%t2997 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2998 = add i64 %t2997, 8
%t2999 = sub nsw i64 %t2976, 1
%t3000 = tail call i64 @st64(i64 %t2998, i64 %t2999)
ret i64 %t3000
}
define internal i64 @rt_dbg_spawn(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3001 = icmp eq i64 %p0, 0
br i1 %t3001, label %L1030, label %L1032
L1030:
%t3002 = sub nsw i64 0, 1
ret i64 %t3002
L1032:
%t3003 = call i64 @__mruntime_rt_sys_resid__split_argv(i64 %p0)
%t3004 = icmp eq i64 %t3003, 0
br i1 %t3004, label %L1033, label %L1035
L1033:
%t3005 = sub nsw i64 0, 1
ret i64 %t3005
L1035:
%t3006 = call i64 @c_fork()
%t3007 = icmp slt i64 %t3006, 0
br i1 %t3007, label %L1036, label %L1038
L1036:
%t3008 = call i64 @__mruntime_rt_sys_resid__free_argv(i64 %t3003)
%t3009 = sub i64 %t3008, 1
ret i64 %t3009
L1038:
%t3010 = icmp eq i64 %t3006, 0
br i1 %t3010, label %L1039, label %L1041
L1039:
%t3011 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 0, i64 0, i64 0, i64 0)
%t3012 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 135, i64 262144, i64 0, i64 0, i64 0, i64 0, i64 0)
%t3013 = call i64 @ld64(i64 %t3003)
%t3014 = call i64 @c_execv(i64 %t3013, i64 %t3003)
%t3015 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 231, i64 127, i64 0, i64 0, i64 0, i64 0, i64 0)
ret i64 %t3015
L1041:
%t3016 = call i64 @__mruntime_rt_sys_resid__free_argv(i64 %t3003)
%t3017 = call i64 @__mruntime_rt_sys_resid__wait_pid(i64 %t3006, i64 0)
%t3018 = icmp slt i64 %t3017, 0
br label %LSL3019
LSL3019:
br i1 %t3018, label %LSJ3019, label %LSR3019
LSR3019:
%t3020 = and i64 %t3017, 255
%t3021 = icmp ne i64 %t3020, 127
br label %LSJ3019
LSJ3019:
%t3022 = phi i1 [ true, %LSL3019 ], [ %t3021, %LSR3019 ]
br i1 %t3022, label %L1042, label %L1044
L1042:
%t3023 = sub nsw i64 0, 1
ret i64 %t3023
L1044:
%t3024 = or i64 8, 1048576
%t3025 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 16896, i64 %t3006, i64 0, i64 %t3024)
%t3026 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3027 = call i64 @st64(i64 %t3026, i64 %t3006)
%t3028 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3029 = add i64 %t3028, 8
%t3030 = call i64 @st64(i64 %t3029, i64 0)
%t3031 = call i64 @__mruntime_rt_sys_resid__dbg_add(i64 %t3006)
%t3032 = mul nsw i64 %t3031, 0
%t3033 = add nsw i64 %t3032, %t3006
ret i64 %t3033
}
define i64 @resid_dbg_spawn(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_dbg_spawn(i64 %x0i)
ret i64 %r
}
define internal i64 @rt_dbg_cont(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3034 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 7, i64 %p0, i64 0, i64 %p1)
%t3035 = icmp eq i64 %t3034, 0
%t3036 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t3035)
ret i64 %t3036
}
define i8 @resid_dbg_cont(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_cont(i64 %a0, i64 %a1)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i1 @__mruntime_rt_sys_resid__st_exited(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3037 = and i64 %p0, 127
%t3038 = icmp eq i64 %t3037, 0
ret i1 %t3038
}
define internal i1 @__mruntime_rt_sys_resid__st_signaled(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3039 = and i64 %p0, 127
%t3040 = icmp ne i64 %t3039, 0
br label %LSL3041
LSL3041:
br i1 %t3040, label %LSR3041, label %LSJ3041
LSR3041:
%t3042 = and i64 %p0, 127
%t3043 = icmp ne i64 %t3042, 127
br label %LSJ3041
LSJ3041:
%t3044 = phi i1 [ false, %LSL3041 ], [ %t3043, %LSR3041 ]
ret i1 %t3044
}
define internal i1 @__mruntime_rt_sys_resid__st_stopped(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3045 = and i64 %p0, 255
%t3046 = icmp eq i64 %t3045, 127
ret i1 %t3046
}
define internal i64 @__mruntime_rt_sys_resid__dbg_status(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3047 = call i1 @__mruntime_rt_sys_resid__st_exited(i64 %p0)
br i1 %t3047, label %L1045, label %L1046
L1045:
%t3048 = ashr i64 %p0, 8
%t3049 = and i64 %t3048, 255
br label %L1047
L1046:
%t3050 = and i64 %p0, 127
%t3051 = add nsw i64 128, %t3050
br label %L1047
L1047:
%t3052 = phi i64 [ %t3049, %L1045 ], [ %t3051, %L1046 ]
ret i64 %t3052
}
define internal i64 @rt_dbg_wait() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%t3053p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dbg_status)
%t3053 = ptrtoint ptr %t3053p to i64
%t3054 = call i64 @st64(i64 %t3053, i64 0)
%t3055 = sub nsw i64 0, 1
%t3056 = call i64 @__mruntime_rt_sys_resid__sc4(i64 61, i64 %t3055, i64 %t3053, i64 1073741824, i64 0)
%t3057 = icmp slt i64 %t3056, 0
br i1 %t3057, label %L1048, label %L1050
L1048:
%t3058 = sub nsw i64 0, 1
ret i64 %t3058
L1050:
%t3059 = call i64 @ld32(i64 %t3053)
%t3060 = call i1 @__mruntime_rt_sys_resid__st_exited(i64 %t3059)
br label %LSL3061
LSL3061:
br i1 %t3060, label %LSJ3061, label %LSR3061
LSR3061:
%t3062 = call i1 @__mruntime_rt_sys_resid__st_signaled(i64 %t3059)
br label %LSJ3061
LSJ3061:
%t3063 = phi i1 [ true, %LSL3061 ], [ %t3062, %LSR3061 ]
br i1 %t3063, label %L1051, label %L1053
L1051:
%t3064 = call i64 @__mruntime_rt_sys_resid__dbg_remove(i64 %t3056)
%t3065 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3066 = call i64 @ld64(i64 %t3065)
%t3067 = icmp eq i64 %t3056, %t3066
br i1 %t3067, label %L1054, label %L1056
L1054:
%t3068 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3069 = add i64 %t3068, 24
%t3070 = call i64 @__mruntime_rt_sys_resid__dbg_status(i64 %t3059)
%t3071 = call i64 @st64(i64 %t3069, i64 %t3070)
%t3072 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3073 = sub nsw i64 0, 1
%t3074 = call i64 @st64(i64 %t3072, i64 %t3073)
%t3075 = sub i64 %t3074, 1
ret i64 %t3075
L1056:
br label %tco.s0
tco.s0:
br label %tco.head
L1053:
%t3077 = call i1 @__mruntime_rt_sys_resid__st_stopped(i64 %t3059)
%t3078 = xor i1 %t3077, true
br i1 %t3078, label %L1057, label %L1059
L1057:
br label %tco.s1
tco.s1:
br label %tco.head
L1059:
%t3080 = ashr i64 %t3059, 8
%t3081 = and i64 %t3080, 255
%t3082 = ashr i64 %t3059, 16
%t3083 = icmp eq i64 %t3081, 5
br label %LSL3084
LSL3084:
br i1 %t3083, label %LSR3084, label %LSJ3084
LSR3084:
%t3085 = icmp eq i64 %t3082, 3
br label %LSJ3084
LSJ3084:
%t3086 = phi i1 [ false, %LSL3084 ], [ %t3085, %LSR3084 ]
br i1 %t3086, label %L1060, label %L1062
L1060:
%t3087p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dbg_msg)
%t3087 = ptrtoint ptr %t3087p to i64
%t3088 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 16897, i64 %t3056, i64 0, i64 %t3087)
%t3089 = call i64 @ld64(i64 %t3087)
%t3090 = call i64 @__mruntime_rt_sys_resid__dbg_add(i64 %t3089)
%t3091 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 7, i64 %t3056, i64 0, i64 0)
br label %tco.s2
tco.s2:
br label %tco.head
L1062:
%t3093 = icmp eq i64 %t3081, 19
br label %LSL3094
LSL3094:
br i1 %t3093, label %LSR3094, label %LSJ3094
LSR3094:
%t3095 = call i1 @__mruntime_rt_sys_resid__dbg_known(i64 %t3056, i64 0)
%t3096 = xor i1 %t3095, true
br label %LSJ3094
LSJ3094:
%t3097 = phi i1 [ false, %LSL3094 ], [ %t3096, %LSR3094 ]
br i1 %t3097, label %L1063, label %L1065
L1063:
%t3098 = call i64 @__mruntime_rt_sys_resid__dbg_add(i64 %t3056)
%t3099 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 7, i64 %t3056, i64 0, i64 0)
br label %tco.s3
tco.s3:
br label %tco.head
L1065:
%t3101 = icmp eq i64 %t3081, 19
br label %LSL3102
LSL3102:
br i1 %t3101, label %LSR3102, label %LSJ3102
LSR3102:
%t3103 = icmp eq i64 %t3082, 0
br label %LSJ3102
LSJ3102:
%t3104 = phi i1 [ false, %LSL3102 ], [ %t3103, %LSR3102 ]
br label %LSL3105
LSL3105:
br i1 %t3104, label %LSR3105, label %LSJ3105
LSR3105:
%t3106 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3107 = call i64 @ld64(i64 %t3106)
%t3108 = icmp ne i64 %t3056, %t3107
br label %LSJ3105
LSJ3105:
%t3109 = phi i1 [ false, %LSL3105 ], [ %t3108, %LSR3105 ]
br i1 %t3109, label %L1066, label %L1068
L1066:
%t3110 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 7, i64 %t3056, i64 0, i64 0)
br label %tco.s4
tco.s4:
br label %tco.head
L1068:
%t3112 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3113 = add i64 %t3112, 16
%t3114 = icmp eq i64 %t3081, 5
br i1 %t3114, label %L1069, label %L1070
L1069:
br label %L1071
L1070:
br label %L1071
L1071:
%t3115 = phi i64 [ 0, %L1069 ], [ %t3081, %L1070 ]
%t3116 = call i64 @st64(i64 %t3113, i64 %t3115)
ret i64 %t3056
}
define i64 @resid_dbg_wait() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_wait()
ret i64 %r
}
define internal i64 @rt_dbg_signal() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3117 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3118 = add i64 %t3117, 16
%t3119 = call i64 @ld64(i64 %t3118)
ret i64 %t3119
}
define i64 @resid_dbg_signal() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_signal()
ret i64 %r
}
define internal i64 @rt_dbg_exit_code() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3120 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3121 = add i64 %t3120, 24
%t3122 = call i64 @ld64(i64 %t3121)
ret i64 %t3122
}
define i64 @resid_dbg_exit_code() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_exit_code()
ret i64 %r
}
define internal i64 @rt_dbg_step(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3123 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 9, i64 %p0, i64 0, i64 0)
%t3124 = icmp ne i64 %t3123, 0
br i1 %t3124, label %L1072, label %L1074
L1072:
ret i64 0
L1074:
%t3125 = call i64 @__mruntime_rt_sys_resid__wait_pid(i64 %p0, i64 1073741824)
%t3126 = icmp slt i64 %t3125, 0
br i1 %t3126, label %L1075, label %L1077
L1075:
ret i64 0
L1077:
%t3127 = call i1 @__mruntime_rt_sys_resid__st_exited(i64 %t3125)
br label %LSL3128
LSL3128:
br i1 %t3127, label %LSJ3128, label %LSR3128
LSR3128:
%t3129 = call i1 @__mruntime_rt_sys_resid__st_signaled(i64 %t3125)
br label %LSJ3128
LSJ3128:
%t3130 = phi i1 [ true, %LSL3128 ], [ %t3129, %LSR3128 ]
br i1 %t3130, label %L1078, label %L1080
L1078:
%t3131 = call i64 @__mruntime_rt_sys_resid__dbg_remove(i64 %p0)
%t3132 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3133 = call i64 @ld64(i64 %t3132)
%t3134 = icmp eq i64 %p0, %t3133
br i1 %t3134, label %L1081, label %L1082
L1081:
%t3135 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3136 = add i64 %t3135, 24
%t3137 = call i64 @__mruntime_rt_sys_resid__dbg_status(i64 %t3125)
%t3138 = call i64 @st64(i64 %t3136, i64 %t3137)
%t3139 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3140 = sub nsw i64 0, 1
%t3141 = call i64 @st64(i64 %t3139, i64 %t3140)
%t3142 = add i64 %t3138, %t3141
br label %L1083
L1082:
br label %L1083
L1083:
%t3143 = phi i64 [ %t3142, %L1081 ], [ 0, %L1082 ]
ret i64 0
L1080:
ret i64 1
}
define i8 @resid_dbg_step(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_step(i64 %a0)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_dbg_peek(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3144p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dbg_peek)
%t3144 = ptrtoint ptr %t3144p to i64
%t3145 = call i64 @st64(i64 %t3144, i64 0)
%t3146 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 2, i64 %p0, i64 %p1, i64 %t3144)
%t3147 = call i64 @ld64(i64 %t3144)
ret i64 %t3147
}
define i64 @resid_dbg_peek(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_peek(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_dbg_poke(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3148 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 5, i64 %p0, i64 %p1, i64 %p2)
%t3149 = icmp eq i64 %t3148, 0
%t3150 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t3149)
ret i64 %t3150
}
define i8 @resid_dbg_poke(i64 %a0, i64 %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_poke(i64 %a0, i64 %a1, i64 %a2)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @__mruntime_rt_sys_resid__reg_off(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3151 = ptrtoint ptr @rtt.18840 to i64
%t3152 = icmp sge i64 %p0, 0
br label %LSL3153
LSL3153:
br i1 %t3152, label %LSR3153, label %LSJ3153
LSR3153:
%t3154 = icmp sle i64 %p0, 16
br label %LSJ3153
LSJ3153:
%t3155 = phi i1 [ false, %LSL3153 ], [ %t3154, %LSR3153 ]
br i1 %t3155, label %L1084, label %L1085
L1084:
%t3156 = mul nsw i64 %p0, 8
%t3157 = add i64 %t3151, %t3156
%t3158 = call i64 @ld64(i64 %t3157)
br label %L1086
L1085:
%t3159 = sub nsw i64 0, 1
br label %L1086
L1086:
%t3160 = phi i64 [ %t3158, %L1084 ], [ %t3159, %L1085 ]
ret i64 %t3160
}
define internal i64 @rt_dbg_reg(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3161p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dbg_regs)
%t3161 = ptrtoint ptr %t3161p to i64
%t3162 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 12, i64 %p0, i64 0, i64 %t3161)
%t3163 = icmp ne i64 %t3162, 0
br i1 %t3163, label %L1087, label %L1089
L1087:
ret i64 0
L1089:
%t3164 = call i64 @__mruntime_rt_sys_resid__reg_off(i64 %p1)
%t3165 = icmp slt i64 %t3164, 0
br i1 %t3165, label %L1090, label %L1091
L1090:
br label %L1092
L1091:
%t3166 = add i64 %t3161, %t3164
%t3167 = call i64 @ld64(i64 %t3166)
br label %L1092
L1092:
%t3168 = phi i64 [ 0, %L1090 ], [ %t3167, %L1091 ]
ret i64 %t3168
}
define i64 @resid_dbg_reg(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_reg(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_dbg_set_pc(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3169p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dbg_regs)
%t3169 = ptrtoint ptr %t3169p to i64
%t3170 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 12, i64 %p0, i64 0, i64 %t3169)
%t3171 = icmp ne i64 %t3170, 0
br i1 %t3171, label %L1093, label %L1095
L1093:
ret i64 0
L1095:
%t3172 = add i64 %t3169, 128
%t3173 = call i64 @st64(i64 %t3172, i64 %p1)
%t3174 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 13, i64 %p0, i64 0, i64 %t3169)
%t3175 = icmp eq i64 %t3174, 0
%t3176 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t3175)
ret i64 %t3176
}
define i8 @resid_dbg_set_pc(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_set_pc(i64 %a0, i64 %a1)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_dbg_kill() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3177 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3178 = call i64 @ld64(i64 %t3177)
%t3179 = icmp sle i64 %t3178, 0
br i1 %t3179, label %L1096, label %L1098
L1096:
ret i64 0
L1098:
%t3180 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 62, i64 %t3178, i64 9, i64 0, i64 0, i64 0, i64 0)
%t3181 = call i64 @__mruntime_rt_sys_resid__reap_all()
%t3182 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3183 = sub nsw i64 0, 1
%t3184 = call i64 @st64(i64 %t3182, i64 %t3183)
%t3185 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3186 = add i64 %t3185, 8
%t3187 = call i64 @st64(i64 %t3186, i64 0)
%t3188 = add i64 %t3187, 1
ret i64 %t3188
}
define i8 @resid_dbg_kill() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_kill()
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @__mruntime_rt_sys_resid__reap_all() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%t3189p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dbg_status)
%t3189 = ptrtoint ptr %t3189p to i64
%t3190 = sub nsw i64 0, 1
%t3191 = call i64 @__mruntime_rt_sys_resid__sc4(i64 61, i64 %t3190, i64 %t3189, i64 1073741824, i64 0)
%t3192 = icmp sgt i64 %t3191, 0
br i1 %t3192, label %L1099, label %L1101
L1099:
br label %tco.s0
tco.s0:
br label %tco.head
L1101:
ret i64 0
}
define internal i64 @rt_dbg_f64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3194 = bitcast i64 %p0 to double
%t3195 = call i64 @c_float_to_string(double %t3194)
ret i64 %t3195
}
define ptr @resid_dbg_f64(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_f64(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @main_thread(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3196 = call i64 @ld64(i64 %p0)
%t3197p = inttoptr i64 %t3196 to ptr
%t3197 = call i64 %t3197p(i64 0, i64 0)
%t3198 = and i64 %t3197, 4294967295
ret i64 %t3198
}
define internal i64 @__mruntime_rt_sys_resid__stack_mb() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3200 = ptrtoint ptr @.s3199 to i64
%t3201 = call i64 @c_getenv(i64 %t3200)
%t3202 = icmp eq i64 %t3201, 0
br label %LSL3203
LSL3203:
br i1 %t3202, label %LSJ3203, label %LSR3203
LSR3203:
%t3204 = call i64 @ld8(i64 %t3201)
%t3205 = icmp eq i64 %t3204, 0
br label %LSJ3203
LSJ3203:
%t3206 = phi i1 [ true, %LSL3203 ], [ %t3205, %LSR3203 ]
br label %LSL3207
LSL3207:
br i1 %t3206, label %LSJ3207, label %LSR3207
LSR3207:
%t3208 = call i1 @is_int(i64 %t3201)
%t3209 = xor i1 %t3208, true
br label %LSJ3207
LSJ3207:
%t3210 = phi i1 [ true, %LSL3207 ], [ %t3209, %LSR3207 ]
br i1 %t3210, label %L1102, label %L1104
L1102:
ret i64 1024
L1104:
%t3211 = call i64 @rt_str_parse_int(i64 %t3201)
%t3212 = icmp sge i64 %t3211, 8
br label %LSL3213
LSL3213:
br i1 %t3212, label %LSR3213, label %LSJ3213
LSR3213:
%t3214 = icmp sle i64 %t3211, 1048576
br label %LSJ3213
LSJ3213:
%t3215 = phi i1 [ false, %LSL3213 ], [ %t3214, %LSR3213 ]
br i1 %t3215, label %L1105, label %L1106
L1105:
br label %L1107
L1106:
br label %L1107
L1107:
%t3216 = phi i64 [ %t3211, %L1105 ], [ 1024, %L1106 ]
ret i64 %t3216
}
define internal i64 @rt_run_main(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3217 = call i64 @check_address_space()
%t3218 = call i64 @xmalloc(i64 64)
%t3219 = call i64 @xmalloc(i64 16)
%t3220 = call i64 @st64(i64 %t3219, i64 %p0)
%t3221 = call i64 @c_pthread_attr_init(i64 %t3218)
%t3222 = icmp ne i64 %t3221, 0
br i1 %t3222, label %L1108, label %L1110
L1108:
%t3223p = inttoptr i64 %p0 to ptr
%t3223 = call i64 %t3223p(i64 0, i64 0)
ret i64 %t3223
L1110:
%t3224 = call i64 @__mruntime_rt_sys_resid__stack_mb()
%t3225 = mul i64 %t3224, 1048576
%t3226 = call i64 @c_pthread_attr_setstacksize(i64 %t3218, i64 %t3225)
%t3227 = call i64 @xmalloc(i64 8)
%t3228 = icmp eq i64 %t3226, 0
br i1 %t3228, label %L1111, label %L1112
L1111:
%t3229 = ptrtoint ptr @main_thread to i64
%t3230 = call i64 @c_pthread_create(i64 %t3227, i64 %t3218, i64 %t3229, i64 %t3219)
br label %L1113
L1112:
br label %L1113
L1113:
%t3231 = phi i64 [ %t3230, %L1111 ], [ 1, %L1112 ]
%t3232 = call i64 @c_pthread_attr_destroy(i64 %t3218)
%t3233 = icmp ne i64 %t3231, 0
br i1 %t3233, label %L1114, label %L1116
L1114:
%t3234p = inttoptr i64 %p0 to ptr
%t3234 = call i64 %t3234p(i64 0, i64 0)
ret i64 %t3234
L1116:
%t3235 = call i64 @xmalloc(i64 8)
%t3236 = call i64 @ld64(i64 %t3227)
%t3237 = call i64 @c_pthread_join(i64 %t3236, i64 %t3235)
%t3238 = tail call i64 @ld64(i64 %t3235)
ret i64 %t3238
}
define i32 @resid_run_main(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_run_main(i64 %x0i)
%rv = trunc i64 %r to i32
ret i32 %rv
}
define internal i64 @rt_int_to_string(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3239p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.numfmt_buf)
%t3239 = ptrtoint ptr %t3239p to i64
%t3240 = call i64 @itoa_into(i64 %t3239, i64 %p0)
%t3241 = call i64 @cstr_from(i64 %t3239, i64 %t3240, i64 0)
ret i64 %t3241
}
define ptr @IntToString(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_int_to_string(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @utoa_into(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3242 = call i64 @udigits(i64 %p1, i64 1)
%t3243 = add i64 %p0, %t3242
%t3244 = sub i64 %t3243, 1
%t3245 = call i64 @uput(i64 %t3244, i64 %p1)
ret i64 %t3242
}
define internal i64 @rt_uint_to_string(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3246p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.numfmt_buf)
%t3246 = ptrtoint ptr %t3246p to i64
%t3247 = call i64 @utoa_into(i64 %t3246, i64 %p0)
%t3248 = call i64 @cstr_from(i64 %t3246, i64 %t3247, i64 0)
ret i64 %t3248
}
define ptr @UIntToString(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_uint_to_string(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_int128_to_string(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3249 = call i64 @__mruntime_rt_numfmt_resid__limbs_i128(i128 %p0)
%t3250 = sext i64 0 to i128
%t3251 = icmp slt i128 %p0, %t3250
%t3252 = call i64 @limbs_to_str(i64 %t3249, i64 2, i1 %t3251)
ret i64 %t3252
}
define ptr @Int128ToString(i128 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_int128_to_string(i128 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_uint128_to_string(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3253 = call i64 @__mruntime_rt_numfmt_resid__limbs_i128(i128 %p0)
%t3254 = call i64 @limbs_to_str(i64 %t3253, i64 2, i1 false)
ret i64 %t3254
}
define ptr @UInt128ToString(i128 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_uint128_to_string(i128 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_numfmt_resid__limbs_negate(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3270, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t3269, %tco.s0 ]
%t3255 = icmp sge i64 %p1, %p2
br i1 %t3255, label %L1117, label %L1119
L1117:
ret i64 0
L1119:
%t3256 = mul i64 %p1, 8
%t3257 = add i64 %p0, %t3256
%t3258 = call i64 @ld64(i64 %t3257)
%t3259 = xor i64 %t3258, -1
%t3260 = mul i64 %p1, 8
%t3261 = add i64 %p0, %t3260
%t3262 = add i64 %t3259, %p3
%t3263 = call i64 @st64(i64 %t3261, i64 %t3262)
%t3264 = icmp eq i64 %p3, 1
br label %LSL3265
LSL3265:
br i1 %t3264, label %LSR3265, label %LSJ3265
LSR3265:
%t3266 = sub nsw i64 0, 1
%t3267 = icmp eq i64 %t3259, %t3266
br label %LSJ3265
LSJ3265:
%t3268 = phi i1 [ false, %LSL3265 ], [ %t3267, %LSR3265 ]
br i1 %t3268, label %L1120, label %L1121
L1120:
br label %L1122
L1121:
br label %L1122
L1122:
%t3269 = phi i64 [ 1, %L1120 ], [ 0, %L1121 ]
%t3270 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_numfmt_resid__limbs_zero(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3277, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t3272 = icmp sge i64 %p1, %p2
br i1 %t3272, label %L1123, label %L1125
L1123:
ret i1 true
L1125:
%t3273 = mul i64 %p1, 8
%t3274 = add i64 %p0, %t3273
%t3275 = call i64 @ld64(i64 %t3274)
%t3276 = icmp ne i64 %t3275, 0
br i1 %t3276, label %L1126, label %L1128
L1126:
ret i1 false
L1128:
%t3277 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__limbs_div10(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3341, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3352, %tco.s0 ]
%t3279 = icmp slt i64 %p1, 0
br i1 %t3279, label %L1129, label %L1131
L1129:
ret i64 %p2
L1131:
%t3280 = sext i64 %p2 to i128
%t3281 = add i128 %t3280, 0
%t3287 = sext i64 64 to i128
%t3288 = add i128 %t3287, 0
%t3294 = icmp uge i128 %t3288, 128
%t3295 = add i128 %t3288, 0
%t3296 = shl i128 %t3281, %t3295
%t3297 = select i1 %t3294, i128 0, i128 %t3296
%t3298 = mul i64 %p1, 8
%t3299 = add i64 %p0, %t3298
%t3300 = call i64 @ld64(i64 %t3299)
%t3301 = sext i64 %t3300 to i128
%t3302 = add i128 %t3301, 0
%t3308 = add i128 18446744073709551615, 0
%t3309 = add i128 %t3308, 0
%t3315 = and i128 %t3302, %t3309
%t3316 = or i128 %t3297, %t3315
%t3317 = sext i64 10 to i128
%t3318 = add i128 %t3317, 0
%t3324 = icmp eq i128 %t3318, 0
%t3325 = zext i1 %t3324 to i8
call void @resid_div_check(i8 %t3325)
%t3330 = udiv i128 %t3316, %t3318
%t3331 = mul i64 %p1, 8
%t3332 = add i64 %p0, %t3331
%t3333 = add i128 %t3330, 0
%t3334 = trunc i128 %t3333 to i64
%t3340 = call i64 @st64(i64 %t3332, i64 %t3334)
%t3341 = sub nsw i64 %p1, 1
%t3342 = sext i64 10 to i128
%t3343 = add i128 %t3342, 0
%t3349 = mul i128 %t3330, %t3343
%t3350 = sub i128 %t3316, %t3349
%t3351 = add i128 %t3350, 0
%t3352 = trunc i128 %t3351 to i64
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__limbs_digits(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3366, %tco.s0 ]
%t3359 = sub i64 %p1, 1
%t3360 = call i64 @__mruntime_rt_numfmt_resid__limbs_div10(i64 %p0, i64 %t3359, i64 0)
%t3361 = sub i64 %p2, 1
%t3362 = add i64 48, %t3360
%t3363 = call i64 @st8(i64 %t3361, i64 %t3362)
%t3364 = call i1 @__mruntime_rt_numfmt_resid__limbs_zero(i64 %p0, i64 0, i64 %p1)
br i1 %t3364, label %L1132, label %L1134
L1132:
%t3365 = sub i64 %p2, 1
ret i64 %t3365
L1134:
%t3366 = sub i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @limbs_to_str(i64 %p0, i64 %p1, i1 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br i1 %p2, label %L1135, label %L1136
L1135:
%t3368 = call i64 @__mruntime_rt_numfmt_resid__limbs_negate(i64 %p0, i64 0, i64 %p1, i64 1)
br label %L1137
L1136:
br label %L1137
L1137:
%t3369 = phi i64 [ %t3368, %L1135 ], [ 0, %L1136 ]
%t3370p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.limb_buf)
%t3370 = ptrtoint ptr %t3370p to i64
%t3371 = add i64 %t3370, 204
%t3372 = call i64 @__mruntime_rt_numfmt_resid__limbs_digits(i64 %p0, i64 %p1, i64 %t3371)
br i1 %p2, label %L1138, label %L1139
L1138:
%t3373 = sub i64 %t3372, 1
%t3374 = call i64 @st8(i64 %t3373, i64 45)
%t3375 = add i64 %t3374, %t3372
%t3376 = sub i64 %t3375, 1
br label %L1140
L1139:
br label %L1140
L1140:
%t3377 = phi i64 [ %t3376, %L1138 ], [ %t3372, %L1139 ]
%t3378 = add i64 %t3370, 204
%t3379 = sub i64 %t3378, %t3377
%t3380 = call i64 @cstr_from(i64 %t3377, i64 %t3379, i64 0)
ret i64 %t3380
}
define internal i64 @__mruntime_rt_numfmt_resid__limbs_i128(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3381p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.limbs)
%t3381 = ptrtoint ptr %t3381p to i64
%t3382 = add i128 %p0, 0
%t3383 = trunc i128 %t3382 to i64
%t3389 = call i64 @st64(i64 %t3381, i64 %t3383)
%t3390 = add i64 %t3381, 8
%t3391 = sext i64 64 to i128
%t3392 = icmp uge i128 %t3391, 128
%t3393 = add i128 %t3391, 0
%t3394 = select i1 %t3392, i128 127, i128 %t3393
%t3395 = ashr i128 %p0, %t3394
%t3396 = add i128 %t3395, 0
%t3397 = trunc i128 %t3396 to i64
%t3403 = call i64 @st64(i64 %t3390, i64 %t3397)
%t3404 = mul nsw i64 %t3403, 0
%t3405 = add nsw i64 %t3404, %t3381
ret i64 %t3405
}
define internal i64 @limbs2(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3406p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.limbs)
%t3406 = ptrtoint ptr %t3406p to i64
%t3407 = add i64 %p0, 24
%t3408 = call i64 @ld64(i64 %t3407)
%t3409 = call i64 @st64(i64 %t3406, i64 %t3408)
%t3410 = add i64 %t3406, 8
%t3411 = add i64 %p0, 32
%t3412 = call i64 @ld64(i64 %t3411)
%t3413 = call i64 @st64(i64 %t3410, i64 %t3412)
%t3414 = mul nsw i64 %t3413, 0
%t3415 = add nsw i64 %t3414, %t3406
ret i64 %t3415
}
define internal i64 @__mruntime_rt_numfmt_resid__limbs4(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3416p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.limbs)
%t3416 = ptrtoint ptr %t3416p to i64
%t3417 = call i64 @st64(i64 %t3416, i64 %p0)
%t3418 = add i64 %t3416, 8
%t3419 = call i64 @st64(i64 %t3418, i64 %p1)
%t3420 = add i64 %t3416, 16
%t3421 = call i64 @st64(i64 %t3420, i64 %p2)
%t3422 = add i64 %t3416, 24
%t3423 = call i64 @st64(i64 %t3422, i64 %p3)
%t3424 = mul nsw i64 %t3423, 0
%t3425 = add nsw i64 %t3424, %t3416
ret i64 %t3425
}
define internal i64 @__mruntime_rt_numfmt_resid__limbs8(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3426 = call i64 @__mruntime_rt_numfmt_resid__limbs4(i64 %p0, i64 %p1, i64 %p2, i64 %p3)
%t3427 = add i64 %t3426, 32
%t3428 = call i64 @st64(i64 %t3427, i64 %p4)
%t3429 = add i64 %t3426, 40
%t3430 = call i64 @st64(i64 %t3429, i64 %p5)
%t3431 = add i64 %t3426, 48
%t3432 = call i64 @st64(i64 %t3431, i64 %p6)
%t3433 = add i64 %t3426, 56
%t3434 = call i64 @st64(i64 %t3433, i64 %p7)
%t3435 = mul nsw i64 %t3434, 0
%t3436 = add nsw i64 %t3435, %t3426
ret i64 %t3436
}
define internal i64 @rt_int256_to_string(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3437 = call i64 @__mruntime_rt_numfmt_resid__limbs4(i64 %p0, i64 %p1, i64 %p2, i64 %p3)
%t3438 = icmp slt i64 %p3, 0
%t3439 = call i64 @limbs_to_str(i64 %t3437, i64 4, i1 %t3438)
ret i64 %t3439
}
define ptr @Int256ToString(i64 %a0, i64 %a1, i64 %a2, i64 %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_int256_to_string(i64 %a0, i64 %a1, i64 %a2, i64 %a3)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_uint256_to_string(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3440 = call i64 @__mruntime_rt_numfmt_resid__limbs4(i64 %p0, i64 %p1, i64 %p2, i64 %p3)
%t3441 = call i64 @limbs_to_str(i64 %t3440, i64 4, i1 false)
ret i64 %t3441
}
define ptr @UInt256ToString(i64 %a0, i64 %a1, i64 %a2, i64 %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_uint256_to_string(i64 %a0, i64 %a1, i64 %a2, i64 %a3)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_int512_to_string(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3442 = call i64 @__mruntime_rt_numfmt_resid__limbs8(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7)
%t3443 = icmp slt i64 %p7, 0
%t3444 = call i64 @limbs_to_str(i64 %t3442, i64 8, i1 %t3443)
ret i64 %t3444
}
define ptr @Int512ToString(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_int512_to_string(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_uint512_to_string(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3445 = call i64 @__mruntime_rt_numfmt_resid__limbs8(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7)
%t3446 = call i64 @limbs_to_str(i64 %t3445, i64 8, i1 false)
ret i64 %t3446
}
define ptr @UInt512ToString(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_uint512_to_string(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_float_to_string(double %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3447p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.ftoa_buf)
%t3447 = ptrtoint ptr %t3447p to i64
%t3449 = ptrtoint ptr @.s3448 to i64
%t3450 = call i64 @c_strfromd(i64 %t3447, i64 64, i64 %t3449, double %p0)
%t3451 = call i64 @cstr_from(i64 %t3447, i64 %t3450, i64 0)
ret i64 %t3451
}
define ptr @FloatToString(double %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_float_to_string(double %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_bool_to_string(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3452 = icmp ne i64 %p0, 0
br i1 %t3452, label %L1141, label %L1142
L1141:
%t3454 = ptrtoint ptr @.s3453 to i64
br label %L1143
L1142:
%t3456 = ptrtoint ptr @.s3455 to i64
br label %L1143
L1143:
%t3457 = phi i64 [ %t3454, %L1141 ], [ %t3456, %L1142 ]
%t3458 = tail call i64 @cstr_dup(i64 %t3457)
ret i64 %t3458
}
define ptr @BoolToString(i8 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = zext i8 %a0 to i64
%r = call i64 @rt_bool_to_string(i64 %x0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_zero(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3459p = inttoptr i64 %p0 to ptr
%t3459q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t3459p, i8 %t3459q, i64 2080, i1 false)
%t3459 = add i64 0, 0
ret i64 %t3459
}
define internal i1 @__mruntime_rt_numfmt_resid__f128_is_zero(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3460 = call i1 @__mruntime_rt_numfmt_resid__limbs_zero(i64 %p0, i64 0, i64 260)
ret i1 %t3460
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_load(i64 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3461 = call i64 @__mruntime_rt_numfmt_resid__f128_zero(i64 %p0)
%t3462 = add i128 %p1, 0
%t3463 = trunc i128 %t3462 to i64
%t3469 = call i64 @st64(i64 %p0, i64 %t3463)
%t3470 = add i64 %p0, 8
%t3471 = sext i64 64 to i128
%t3472 = add i128 %t3471, 0
%t3478 = icmp uge i128 %t3472, 128
%t3479 = add i128 %t3472, 0
%t3480 = lshr i128 %p1, %t3479
%t3481 = select i1 %t3478, i128 0, i128 %t3480
%t3482 = add i128 %t3481, 0
%t3483 = trunc i128 %t3482 to i64
%t3489 = call i64 @st64(i64 %t3470, i64 %t3483)
ret i64 %t3489
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_shl(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3490 = sdiv i64 %p1, 64
%t3491 = srem i64 %p1, 64
%t3492 = call i64 @__mruntime_rt_numfmt_resid__shl_words(i64 %p0, i64 259, i64 %t3490, i64 %t3491)
%t3493 = mul nsw i64 %t3490, 8
%t3494p = inttoptr i64 %p0 to ptr
%t3494q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t3494p, i8 %t3494q, i64 %t3493, i1 false)
%t3494 = add i64 0, 0
ret i64 %t3494
}
define internal i64 @__mruntime_rt_numfmt_resid__shl_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3524, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t3495 = icmp slt i64 %p1, %p2
br i1 %t3495, label %L1144, label %L1146
L1144:
ret i64 0
L1146:
%t3496 = sub i64 %p1, %p2
%t3497 = mul i64 %t3496, 8
%t3498 = add i64 %p0, %t3497
%t3499 = call i64 @ld64(i64 %t3498)
%t3500 = icmp ne i64 %p3, 0
br label %LSL3501
LSL3501:
br i1 %t3500, label %LSR3501, label %LSJ3501
LSR3501:
%t3502 = sub i64 %p1, %p2
%t3503 = sub i64 %t3502, 1
%t3504 = icmp sge i64 %t3503, 0
br label %LSJ3501
LSJ3501:
%t3505 = phi i1 [ false, %LSL3501 ], [ %t3504, %LSR3501 ]
br i1 %t3505, label %L1147, label %L1148
L1147:
%t3506 = sub i64 %p1, %p2
%t3507 = sub i64 %t3506, 1
%t3508 = mul i64 %t3507, 8
%t3509 = add i64 %p0, %t3508
%t3510 = call i64 @ld64(i64 %t3509)
%t3511 = sub i64 64, %p3
%t3512 = call i64 @lshr(i64 %t3510, i64 %t3511)
br label %L1149
L1148:
br label %L1149
L1149:
%t3513 = phi i64 [ %t3512, %L1147 ], [ 0, %L1148 ]
%t3514 = mul i64 %p1, 8
%t3515 = add i64 %p0, %t3514
%t3516 = icmp eq i64 %p3, 0
br i1 %t3516, label %L1150, label %L1151
L1150:
br label %L1152
L1151:
%t3517 = icmp uge i64 %p3, 64
%t3518 = add i64 %p3, 0
%t3519 = shl i64 %t3499, %t3518
%t3520 = select i1 %t3517, i64 0, i64 %t3519
%t3521 = or i64 %t3520, %t3513
br label %L1152
L1152:
%t3522 = phi i64 [ %t3499, %L1150 ], [ %t3521, %L1151 ]
%t3523 = call i64 @st64(i64 %t3515, i64 %t3522)
%t3524 = sub i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_shr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3526 = sdiv i64 %p1, 64
%t3527 = srem i64 %p1, 64
%t3528 = call i64 @__mruntime_rt_numfmt_resid__shr_words(i64 %p0, i64 0, i64 %t3526, i64 %t3527)
%t3529 = sub nsw i64 260, %t3526
%t3530 = icmp slt i64 %t3529, 0
br i1 %t3530, label %L1153, label %L1154
L1153:
br label %L1155
L1154:
%t3531 = sub nsw i64 260, %t3526
br label %L1155
L1155:
%t3532 = phi i64 [ 0, %L1153 ], [ %t3531, %L1154 ]
%t3533 = mul i64 %t3532, 8
%t3534 = add i64 %p0, %t3533
%t3535 = sub i64 260, %t3532
%t3536 = mul i64 %t3535, 8
%t3537p = inttoptr i64 %t3534 to ptr
%t3537q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t3537p, i8 %t3537q, i64 %t3536, i1 false)
%t3537 = add i64 0, 0
ret i64 %t3537
}
define internal i64 @__mruntime_rt_numfmt_resid__shr_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3568, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t3538 = add i64 %p1, %p2
%t3539 = icmp sge i64 %t3538, 260
br i1 %t3539, label %L1156, label %L1158
L1156:
ret i64 0
L1158:
%t3540 = add i64 %p1, %p2
%t3541 = mul i64 %t3540, 8
%t3542 = add i64 %p0, %t3541
%t3543 = call i64 @ld64(i64 %t3542)
%t3544 = icmp ne i64 %p3, 0
br label %LSL3545
LSL3545:
br i1 %t3544, label %LSR3545, label %LSJ3545
LSR3545:
%t3546 = add i64 %p1, %p2
%t3547 = add i64 %t3546, 1
%t3548 = icmp slt i64 %t3547, 260
br label %LSJ3545
LSJ3545:
%t3549 = phi i1 [ false, %LSL3545 ], [ %t3548, %LSR3545 ]
br i1 %t3549, label %L1159, label %L1160
L1159:
%t3550 = add i64 %p1, %p2
%t3551 = add i64 %t3550, 1
%t3552 = mul i64 %t3551, 8
%t3553 = add i64 %p0, %t3552
%t3554 = call i64 @ld64(i64 %t3553)
%t3555 = sub i64 64, %p3
%t3556 = icmp uge i64 %t3555, 64
%t3557 = add i64 %t3555, 0
%t3558 = shl i64 %t3554, %t3557
%t3559 = select i1 %t3556, i64 0, i64 %t3558
br label %L1161
L1160:
br label %L1161
L1161:
%t3560 = phi i64 [ %t3559, %L1159 ], [ 0, %L1160 ]
%t3561 = mul i64 %p1, 8
%t3562 = add i64 %p0, %t3561
%t3563 = icmp eq i64 %p3, 0
br i1 %t3563, label %L1162, label %L1163
L1162:
br label %L1164
L1163:
%t3564 = call i64 @lshr(i64 %t3543, i64 %p3)
%t3565 = or i64 %t3564, %t3560
br label %L1164
L1164:
%t3566 = phi i64 [ %t3543, %L1162 ], [ %t3565, %L1163 ]
%t3567 = call i64 @st64(i64 %t3562, i64 %t3566)
%t3568 = add i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_mul10(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3615, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3628, %tco.s0 ]
%t3570 = icmp sge i64 %p1, 260
br i1 %t3570, label %L1165, label %L1167
L1165:
ret i64 0
L1167:
%t3571 = mul i64 %p1, 8
%t3572 = add i64 %p0, %t3571
%t3573 = call i64 @ld64(i64 %t3572)
%t3574 = sext i64 %t3573 to i128
%t3575 = add i128 %t3574, 0
%t3581 = add i128 18446744073709551615, 0
%t3582 = add i128 %t3581, 0
%t3588 = and i128 %t3575, %t3582
%t3589 = sext i64 10 to i128
%t3590 = add i128 %t3589, 0
%t3596 = mul i128 %t3588, %t3590
%t3597 = sext i64 %p2 to i128
%t3598 = add i128 %t3597, 0
%t3604 = add i128 %t3596, %t3598
%t3605 = mul i64 %p1, 8
%t3606 = add i64 %p0, %t3605
%t3607 = add i128 %t3604, 0
%t3608 = trunc i128 %t3607 to i64
%t3614 = call i64 @st64(i64 %t3606, i64 %t3608)
%t3615 = add nsw i64 %p1, 1
%t3616 = sext i64 64 to i128
%t3617 = add i128 %t3616, 0
%t3623 = icmp uge i128 %t3617, 128
%t3624 = add i128 %t3617, 0
%t3625 = lshr i128 %t3604, %t3624
%t3626 = select i1 %t3623, i128 0, i128 %t3625
%t3627 = add i128 %t3626, 0
%t3628 = trunc i128 %t3627 to i64
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_div10(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3635 = call i64 @__mruntime_rt_numfmt_resid__limbs_div10(i64 %p0, i64 259, i64 0)
ret i64 %t3635
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_mask(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3636 = sdiv i64 %p1, 64
%t3637 = srem i64 %p1, 64
%t3638 = add nsw i64 %t3636, 1
%t3639 = icmp slt i64 %t3638, 260
br i1 %t3639, label %L1168, label %L1169
L1168:
%t3640 = add nsw i64 %t3636, 1
%t3641 = mul nsw i64 %t3640, 8
%t3642 = add i64 %p0, %t3641
%t3643 = sub nsw i64 259, %t3636
%t3644 = mul nsw i64 %t3643, 8
%t3645p = inttoptr i64 %t3642 to ptr
%t3645q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t3645p, i8 %t3645q, i64 %t3644, i1 false)
%t3645 = add i64 0, 0
br label %L1170
L1169:
br label %L1170
L1170:
%t3646 = phi i64 [ %t3645, %L1168 ], [ 0, %L1169 ]
%t3647 = icmp ne i64 %t3637, 0
br label %LSL3648
LSL3648:
br i1 %t3647, label %LSR3648, label %LSJ3648
LSR3648:
%t3649 = icmp slt i64 %t3636, 260
br label %LSJ3648
LSJ3648:
%t3650 = phi i1 [ false, %LSL3648 ], [ %t3649, %LSR3648 ]
br i1 %t3650, label %L1171, label %L1172
L1171:
%t3651 = mul nsw i64 %t3636, 8
%t3652 = add i64 %p0, %t3651
%t3653 = mul nsw i64 %t3636, 8
%t3654 = add i64 %p0, %t3653
%t3655 = call i64 @ld64(i64 %t3654)
%t3656 = icmp uge i64 %t3637, 64
%t3657 = add i64 %t3637, 0
%t3658 = shl i64 1, %t3657
%t3659 = select i1 %t3656, i64 0, i64 %t3658
%t3660 = sub i64 %t3659, 1
%t3661 = and i64 %t3655, %t3660
%t3662 = call i64 @st64(i64 %t3652, i64 %t3661)
br label %L1173
L1172:
br label %L1173
L1173:
%t3663 = phi i64 [ %t3662, %L1171 ], [ 0, %L1172 ]
ret i64 %t3663
}
define internal i64 @__mruntime_rt_numfmt_resid__int_digits(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3672, %tco.s0 ]
%t3664 = call i1 @__mruntime_rt_numfmt_resid__f128_is_zero(i64 %p0)
br label %LSL3665
LSL3665:
br i1 %t3664, label %LSJ3665, label %LSR3665
LSR3665:
%t3666 = icmp sge i64 %p2, 5000
br label %LSJ3665
LSJ3665:
%t3667 = phi i1 [ true, %LSL3665 ], [ %t3666, %LSR3665 ]
br i1 %t3667, label %L1174, label %L1176
L1174:
ret i64 %p2
L1176:
%t3668 = add i64 %p1, %p2
%t3669 = call i64 @__mruntime_rt_numfmt_resid__f128_div10(i64 %p0)
%t3670 = add i64 48, %t3669
%t3671 = call i64 @st8(i64 %t3668, i64 %t3670)
%t3672 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__frac_digits(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i1 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ 0, %tco.s0 ], [ %t3715, %tco.s1 ]
%p4 = phi i1 [ %p4.in, %entry ], [ %p4, %tco.s0 ], [ %p4, %tco.s1 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ], [ %p5, %tco.s1 ]
%t3674 = icmp sge i64 %p3, 44
br label %LSL3675
LSL3675:
br i1 %t3674, label %LSJ3675, label %LSR3675
LSR3675:
%t3676 = call i1 @__mruntime_rt_numfmt_resid__f128_is_zero(i64 %p0)
br label %LSJ3675
LSJ3675:
%t3677 = phi i1 [ true, %LSL3675 ], [ %t3676, %LSR3675 ]
br i1 %t3677, label %L1177, label %L1179
L1177:
ret i64 %p3
L1179:
%t3678 = call i64 @__mruntime_rt_numfmt_resid__f128_mul10(i64 %p0, i64 0, i64 0)
%t3679 = sdiv i64 %p1, 64
%t3680 = srem i64 %p1, 64
%t3681 = icmp eq i64 %t3680, 0
br i1 %t3681, label %L1180, label %L1181
L1180:
%t3682 = mul nsw i64 %t3679, 8
%t3683 = add i64 %p0, %t3682
%t3684 = call i64 @ld64(i64 %t3683)
br label %L1182
L1181:
%t3685 = mul nsw i64 %t3679, 8
%t3686 = add i64 %p0, %t3685
%t3687 = call i64 @ld64(i64 %t3686)
%t3688 = call i64 @lshr(i64 %t3687, i64 %t3680)
%t3689 = add nsw i64 %t3679, 1
%t3690 = mul nsw i64 %t3689, 8
%t3691 = add i64 %p0, %t3690
%t3692 = call i64 @ld64(i64 %t3691)
%t3693 = sub nsw i64 64, %t3680
%t3694 = icmp uge i64 %t3693, 64
%t3695 = add i64 %t3693, 0
%t3696 = shl i64 %t3692, %t3695
%t3697 = select i1 %t3694, i64 0, i64 %t3696
%t3698 = or i64 %t3688, %t3697
br label %L1182
L1182:
%t3699 = phi i64 [ %t3684, %L1180 ], [ %t3698, %L1181 ]
%t3700 = and i64 %t3699, 15
%t3701 = call i64 @__mruntime_rt_numfmt_resid__f128_mask(i64 %p0, i64 %p1)
br label %LSL3702
LSL3702:
br i1 %p4, label %LSR3702, label %LSJ3702
LSR3702:
%t3703 = icmp eq i64 %p3, 0
br label %LSJ3702
LSJ3702:
%t3704 = phi i1 [ false, %LSL3702 ], [ %t3703, %LSR3702 ]
br label %LSL3705
LSL3705:
br i1 %t3704, label %LSR3705, label %LSJ3705
LSR3705:
%t3706 = icmp eq i64 %t3700, 0
br label %LSJ3705
LSJ3705:
%t3707 = phi i1 [ false, %LSL3705 ], [ %t3706, %LSR3705 ]
br i1 %t3707, label %L1183, label %L1185
L1183:
%t3708 = call i64 @ld64(i64 %p5)
%t3709 = add i64 %t3708, 1
%t3710 = call i64 @st64(i64 %p5, i64 %t3709)
br label %tco.s0
tco.s0:
br label %tco.head
L1185:
%t3712 = add i64 %p2, %p3
%t3713 = add nsw i64 48, %t3700
%t3714 = call i64 @st8(i64 %t3712, i64 %t3713)
%t3715 = add nsw i64 %p3, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @rt_float128_to_string(fp128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3717 = bitcast fp128 %p0 to i128
%t3718 = add i128 %t3717, 0
%t3719 = add i128 %t3718, 0
%t3725 = sext i64 127 to i128
%t3726 = add i128 %t3725, 0
%t3732 = icmp uge i128 %t3726, 128
%t3733 = add i128 %t3726, 0
%t3734 = lshr i128 %t3719, %t3733
%t3735 = select i1 %t3732, i128 0, i128 %t3734
%t3736 = sext i64 0 to i128
%t3737 = add i128 %t3736, 0
%t3743 = icmp ne i128 %t3735, %t3737
%t3744 = sext i64 112 to i128
%t3745 = add i128 %t3744, 0
%t3751 = icmp uge i128 %t3745, 128
%t3752 = add i128 %t3745, 0
%t3753 = lshr i128 %t3719, %t3752
%t3754 = select i1 %t3751, i128 0, i128 %t3753
%t3755 = sext i64 32767 to i128
%t3756 = add i128 %t3755, 0
%t3762 = and i128 %t3754, %t3756
%t3763 = add i128 %t3762, 0
%t3764 = trunc i128 %t3763 to i64
%t3770 = sext i64 1 to i128
%t3771 = add i128 %t3770, 0
%t3777 = sext i64 112 to i128
%t3778 = add i128 %t3777, 0
%t3784 = icmp uge i128 %t3778, 128
%t3785 = add i128 %t3778, 0
%t3786 = shl i128 %t3771, %t3785
%t3787 = select i1 %t3784, i128 0, i128 %t3786
%t3788 = sext i64 1 to i128
%t3789 = add i128 %t3788, 0
%t3795 = sub i128 %t3787, %t3789
%t3796 = and i128 %t3719, %t3795
%t3797 = icmp eq i64 %t3764, 32767
br i1 %t3797, label %L1186, label %L1188
L1186:
%t3798 = sext i64 0 to i128
%t3799 = add i128 %t3798, 0
%t3805 = icmp ne i128 %t3796, %t3799
br i1 %t3805, label %L1189, label %L1190
L1189:
%t3807 = ptrtoint ptr @.s3806 to i64
br label %L1191
L1190:
br i1 %t3743, label %L1192, label %L1193
L1192:
%t3809 = ptrtoint ptr @.s3808 to i64
br label %L1194
L1193:
%t3811 = ptrtoint ptr @.s3810 to i64
br label %L1194
L1194:
%t3812 = phi i64 [ %t3809, %L1192 ], [ %t3811, %L1193 ]
br label %L1191
L1191:
%t3813 = phi i64 [ %t3807, %L1189 ], [ %t3812, %L1194 ]
%t3814 = call i64 @cstr_dup(i64 %t3813)
ret i64 %t3814
L1188:
%t3815 = icmp eq i64 %t3764, 0
br i1 %t3815, label %L1195, label %L1196
L1195:
br label %L1197
L1196:
%t3816 = sext i64 1 to i128
%t3817 = add i128 %t3816, 0
%t3823 = sext i64 112 to i128
%t3824 = add i128 %t3823, 0
%t3830 = icmp uge i128 %t3824, 128
%t3831 = add i128 %t3824, 0
%t3832 = shl i128 %t3817, %t3831
%t3833 = select i1 %t3830, i128 0, i128 %t3832
%t3834 = or i128 %t3833, %t3796
br label %L1197
L1197:
%t3835 = phi i128 [ %t3796, %L1195 ], [ %t3834, %L1196 ]
%t3836 = icmp eq i64 %t3764, 0
br i1 %t3836, label %L1198, label %L1199
L1198:
%t3837 = sub nsw i64 0, 16382
%t3838 = sub nsw i64 %t3837, 112
br label %L1200
L1199:
%t3839 = sub i64 %t3764, 16383
%t3840 = sub i64 %t3839, 112
br label %L1200
L1200:
%t3841 = phi i64 [ %t3838, %L1198 ], [ %t3840, %L1199 ]
%t3842p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_m)
%t3842 = ptrtoint ptr %t3842p to i64
%t3843p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_ip)
%t3843 = ptrtoint ptr %t3843p to i64
%t3844p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_ib)
%t3844 = ptrtoint ptr %t3844p to i64
%t3845p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_fd)
%t3845 = ptrtoint ptr %t3845p to i64
%t3846 = call i64 @__mruntime_rt_numfmt_resid__f128_load(i64 %t3842, i128 %t3835)
%t3847 = call i64 @__mruntime_rt_numfmt_resid__f128_text(i64 %t3842, i64 %t3843, i64 %t3844, i64 %t3845, i128 %t3835, i64 %t3841, i1 %t3743)
ret i64 %t3847
}
define ptr @Float128ToString(fp128 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_float128_to_string(fp128 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_text(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i128 %p4, i64 %p5, i1 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3848 = icmp sge i64 %p5, 0
br i1 %t3848, label %L1201, label %L1203
L1201:
%t3849 = call i64 @__mruntime_rt_numfmt_resid__f128_shl(i64 %p0, i64 %p5)
%t3850 = call i1 @__mruntime_rt_numfmt_resid__f128_is_zero(i64 %p0)
br i1 %t3850, label %L1204, label %L1206
L1204:
%t3852 = ptrtoint ptr @.s3851 to i64
%t3853 = call i64 @cstr_dup(i64 %t3852)
ret i64 %t3853
L1206:
%t3854 = call i64 @__mruntime_rt_numfmt_resid__int_digits(i64 %p0, i64 %p2, i64 0)
%t3855 = sub i64 %t3854, 1
%t3856 = call i64 @__mruntime_rt_numfmt_resid__f128_assemble(i64 %p2, i64 %t3854, i64 %p3, i64 0, i64 %t3855, i1 %p6)
ret i64 %t3856
L1203:
%t3857 = sub i64 0, %p5
%t3858 = call i64 @__mruntime_rt_numfmt_resid__f128_load(i64 %p1, i128 %p4)
%t3859 = call i64 @__mruntime_rt_numfmt_resid__f128_shr(i64 %p1, i64 %t3857)
%t3860 = call i64 @__mruntime_rt_numfmt_resid__int_digits(i64 %p1, i64 %p2, i64 0)
%t3861 = call i64 @__mruntime_rt_numfmt_resid__f128_load(i64 %p0, i128 %p4)
%t3862 = call i64 @__mruntime_rt_numfmt_resid__f128_mask(i64 %p0, i64 %t3857)
%t3863p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_lead)
%t3863 = ptrtoint ptr %t3863p to i64
%t3864 = call i64 @st64(i64 %t3863, i64 0)
%t3865 = icmp eq i64 %t3860, 0
%t3866 = call i64 @__mruntime_rt_numfmt_resid__frac_digits(i64 %p0, i64 %t3857, i64 %p3, i64 0, i1 %t3865, i64 %t3863)
%t3867 = icmp sgt i64 %t3860, 0
br i1 %t3867, label %L1207, label %L1209
L1207:
%t3868 = sub nsw i64 %t3860, 1
%t3869 = call i64 @__mruntime_rt_numfmt_resid__f128_assemble(i64 %p2, i64 %t3860, i64 %p3, i64 %t3866, i64 %t3868, i1 %p6)
ret i64 %t3869
L1209:
%t3870 = icmp eq i64 %t3866, 0
br i1 %t3870, label %L1210, label %L1212
L1210:
br i1 %p6, label %L1213, label %L1214
L1213:
%t3872 = ptrtoint ptr @.s3871 to i64
br label %L1215
L1214:
%t3874 = ptrtoint ptr @.s3873 to i64
br label %L1215
L1215:
%t3875 = phi i64 [ %t3872, %L1213 ], [ %t3874, %L1214 ]
%t3876 = call i64 @cstr_dup(i64 %t3875)
ret i64 %t3876
L1212:
%t3877 = call i64 @ld64(i64 %t3863)
%t3878 = sub i64 0, %t3877
%t3879 = sub nsw i64 %t3878, 1
%t3880 = call i64 @__mruntime_rt_numfmt_resid__f128_assemble(i64 %p2, i64 0, i64 %p3, i64 %t3866, i64 %t3879, i1 %p6)
ret i64 %t3880
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_assemble(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i1 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3881p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_digits)
%t3881 = ptrtoint ptr %t3881p to i64
%t3882 = call i64 @__mruntime_rt_numfmt_resid__copy_rev(i64 %p0, i64 %p1, i64 %t3881, i64 0, i64 37)
%t3883 = call i64 @__mruntime_rt_numfmt_resid__copy_fwd(i64 %p2, i64 %p3, i64 %t3881, i64 %t3882, i64 37, i64 0)
%t3884 = icmp sgt i64 %t3883, 36
br label %LSL3885
LSL3885:
br i1 %t3884, label %LSR3885, label %LSJ3885
LSR3885:
%t3886 = add i64 %t3881, 36
%t3887 = call i64 @ld8(i64 %t3886)
%t3888 = icmp sge i64 %t3887, 53
br label %LSJ3885
LSJ3885:
%t3889 = phi i1 [ false, %LSL3885 ], [ %t3888, %LSR3885 ]
br label %LSL3890
LSL3890:
br i1 %t3889, label %LSR3890, label %LSJ3890
LSR3890:
%t3891 = call i1 @__mruntime_rt_numfmt_resid__round_up(i64 %t3881, i64 35)
br label %LSJ3890
LSJ3890:
%t3892 = phi i1 [ false, %LSL3890 ], [ %t3891, %LSR3890 ]
br i1 %t3892, label %L1216, label %L1217
L1216:
%t3893 = call i64 @st8(i64 %t3881, i64 49)
%t3894 = add i64 %t3881, 1
%t3895p = inttoptr i64 %t3894 to ptr
%t3895q = trunc i64 48 to i8
call void @llvm.memset.p0.i64(ptr %t3895p, i8 %t3895q, i64 35, i1 false)
%t3895 = add i64 0, 0
%t3896 = add i64 %t3893, %t3895
br label %L1218
L1217:
br label %L1218
L1218:
%t3897 = phi i64 [ %t3896, %L1216 ], [ 0, %L1217 ]
br i1 %t3892, label %L1219, label %L1220
L1219:
%t3898 = add i64 %p4, 1
br label %L1221
L1220:
br label %L1221
L1221:
%t3899 = phi i64 [ %t3898, %L1219 ], [ %p4, %L1220 ]
%t3900 = icmp sgt i64 %t3883, 36
br i1 %t3900, label %L1222, label %L1223
L1222:
br label %L1224
L1223:
br label %L1224
L1224:
%t3901 = phi i64 [ 36, %L1222 ], [ %t3883, %L1223 ]
%t3902 = call i64 @__mruntime_rt_numfmt_resid__strip_zeros(i64 %t3881, i64 %t3901)
%t3903p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_out)
%t3903 = ptrtoint ptr %t3903p to i64
br i1 %p5, label %L1225, label %L1226
L1225:
%t3904 = call i64 @st8(i64 %t3903, i64 45)
%t3905 = add i64 %t3904, 1
br label %L1227
L1226:
br label %L1227
L1227:
%t3906 = phi i64 [ %t3905, %L1225 ], [ 0, %L1226 ]
%t3907 = sub nsw i64 0, 6
%t3908 = icmp sge i64 %t3899, %t3907
br label %LSL3909
LSL3909:
br i1 %t3908, label %LSR3909, label %LSJ3909
LSR3909:
%t3910 = icmp sle i64 %t3899, 36
br label %LSJ3909
LSJ3909:
%t3911 = phi i1 [ false, %LSL3909 ], [ %t3910, %LSR3909 ]
br i1 %t3911, label %L1228, label %L1229
L1228:
%t3912 = call i64 @__mruntime_rt_numfmt_resid__fixed_text(i64 %t3903, i64 %t3906, i64 %t3881, i64 %t3902, i64 %t3899)
br label %L1230
L1229:
%t3913 = call i64 @__mruntime_rt_numfmt_resid__sci_text(i64 %t3903, i64 %t3906, i64 %t3881, i64 %t3902, i64 %t3899)
br label %L1230
L1230:
%t3914 = phi i64 [ %t3912, %L1228 ], [ %t3913, %L1229 ]
%t3915 = call i64 @cstr_from(i64 %t3903, i64 %t3914, i64 0)
ret i64 %t3915
}
define internal i64 @__mruntime_rt_numfmt_resid__copy_rev(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t3926, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t3916 = icmp sge i64 %p3, %p1
br label %LSL3917
LSL3917:
br i1 %t3916, label %LSJ3917, label %LSR3917
LSR3917:
%t3918 = icmp sge i64 %p3, %p4
br label %LSJ3917
LSJ3917:
%t3919 = phi i1 [ true, %LSL3917 ], [ %t3918, %LSR3917 ]
br i1 %t3919, label %L1231, label %L1233
L1231:
ret i64 %p3
L1233:
%t3920 = add i64 %p2, %p3
%t3921 = add i64 %p0, %p1
%t3922 = sub i64 %t3921, 1
%t3923 = sub i64 %t3922, %p3
%t3924 = call i64 @ld8(i64 %t3923)
%t3925 = call i64 @st8(i64 %t3920, i64 %t3924)
%t3926 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__copy_fwd(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t3936, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t3937, %tco.s0 ]
%t3928 = icmp sge i64 %p5, %p1
br label %LSL3929
LSL3929:
br i1 %t3928, label %LSJ3929, label %LSR3929
LSR3929:
%t3930 = icmp sge i64 %p3, %p4
br label %LSJ3929
LSJ3929:
%t3931 = phi i1 [ true, %LSL3929 ], [ %t3930, %LSR3929 ]
br i1 %t3931, label %L1234, label %L1236
L1234:
ret i64 %p3
L1236:
%t3932 = add i64 %p2, %p3
%t3933 = add i64 %p0, %p5
%t3934 = call i64 @ld8(i64 %t3933)
%t3935 = call i64 @st8(i64 %t3932, i64 %t3934)
%t3936 = add nsw i64 %p3, 1
%t3937 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_numfmt_resid__round_up(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3945, %tco.s0 ]
%t3939 = icmp slt i64 %p1, 0
br i1 %t3939, label %L1237, label %L1239
L1237:
ret i1 true
L1239:
%t3940 = add i64 %p0, %p1
%t3941 = call i64 @ld8(i64 %t3940)
%t3942 = icmp eq i64 %t3941, 57
br i1 %t3942, label %L1240, label %L1242
L1240:
%t3943 = add i64 %p0, %p1
%t3944 = call i64 @st8(i64 %t3943, i64 48)
%t3945 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L1242:
%t3947 = add i64 %p0, %p1
%t3948 = add i64 %p0, %p1
%t3949 = call i64 @ld8(i64 %t3948)
%t3950 = add i64 %t3949, 1
%t3951 = call i64 @st8(i64 %t3947, i64 %t3950)
ret i1 false
}
define internal i64 @__mruntime_rt_numfmt_resid__strip_zeros(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3959, %tco.s0 ]
%t3952 = icmp sgt i64 %p1, 1
br label %LSL3953
LSL3953:
br i1 %t3952, label %LSR3953, label %LSJ3953
LSR3953:
%t3954 = add i64 %p0, %p1
%t3955 = sub nsw i64 %t3954, 1
%t3956 = call i64 @ld8(i64 %t3955)
%t3957 = icmp eq i64 %t3956, 48
br label %LSJ3953
LSJ3953:
%t3958 = phi i1 [ false, %LSL3953 ], [ %t3957, %LSR3953 ]
br i1 %t3958, label %L1243, label %L1245
L1243:
%t3959 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L1245:
ret i64 %p1
}
define internal i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3961 = add i64 %p0, %p1
%t3962 = call i64 @st8(i64 %t3961, i64 %p2)
%t3963 = add i64 %t3962, %p1
%t3964 = add i64 %t3963, 1
ret i64 %t3964
}
define internal i64 @__mruntime_rt_numfmt_resid__fixed_text(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3965 = icmp slt i64 %p4, 0
br i1 %t3965, label %L1246, label %L1248
L1246:
%t3966 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 48)
%t3967 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t3966, i64 46)
%t3968 = sub i64 0, %p4
%t3969 = sub nsw i64 %t3968, 1
%t3970 = call i64 @__mruntime_rt_numfmt_resid__zeros(i64 %p0, i64 %t3967, i64 %t3969)
%t3971 = tail call i64 @__mruntime_rt_numfmt_resid__digits_out(i64 %p0, i64 %t3970, i64 %p2, i64 0, i64 %p3)
ret i64 %t3971
L1248:
%t3972 = call i64 @__mruntime_rt_numfmt_resid__int_part(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 %p4)
%t3973 = add i64 %p4, 1
%t3974 = icmp slt i64 %t3973, %p3
br i1 %t3974, label %L1249, label %L1251
L1249:
%t3975 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t3972, i64 46)
%t3976 = add i64 %p4, 1
%t3977 = tail call i64 @__mruntime_rt_numfmt_resid__digits_out(i64 %p0, i64 %t3975, i64 %p2, i64 %t3976, i64 %p3)
ret i64 %t3977
L1251:
ret i64 %t3972
}
define internal i64 @__mruntime_rt_numfmt_resid__zeros(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3979, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3980, %tco.s0 ]
%t3978 = icmp sle i64 %p2, 0
br i1 %t3978, label %L1252, label %L1254
L1252:
ret i64 %p1
L1254:
%t3979 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 48)
%t3980 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__digits_out(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3985, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t3986, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t3982 = icmp sge i64 %p3, %p4
br i1 %t3982, label %L1255, label %L1257
L1255:
ret i64 %p1
L1257:
%t3983 = add i64 %p2, %p3
%t3984 = call i64 @ld8(i64 %t3983)
%t3985 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 %t3984)
%t3986 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__int_part(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3993, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t3994, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t3988 = icmp sgt i64 %p4, %p5
br i1 %t3988, label %L1258, label %L1260
L1258:
ret i64 %p1
L1260:
%t3989 = icmp slt i64 %p4, %p3
br i1 %t3989, label %L1261, label %L1262
L1261:
%t3990 = add i64 %p2, %p4
%t3991 = call i64 @ld8(i64 %t3990)
br label %L1263
L1262:
br label %L1263
L1263:
%t3992 = phi i64 [ %t3991, %L1261 ], [ 48, %L1262 ]
%t3993 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 %t3992)
%t3994 = add i64 %p4, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__sci_text(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3996 = call i64 @ld8(i64 %p2)
%t3997 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 %t3996)
%t3998 = icmp sgt i64 %p3, 1
br i1 %t3998, label %L1264, label %L1265
L1264:
%t3999 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t3997, i64 46)
%t4000 = call i64 @__mruntime_rt_numfmt_resid__digits_out(i64 %p0, i64 %t3999, i64 %p2, i64 1, i64 %p3)
br label %L1266
L1265:
br label %L1266
L1266:
%t4001 = phi i64 [ %t4000, %L1264 ], [ %t3997, %L1265 ]
%t4002 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t4001, i64 69)
%t4003 = icmp sge i64 %p4, 0
br i1 %t4003, label %L1267, label %L1268
L1267:
br label %L1269
L1268:
br label %L1269
L1269:
%t4004 = phi i64 [ 43, %L1267 ], [ 45, %L1268 ]
%t4005 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t4002, i64 %t4004)
%t4006 = icmp sge i64 %p4, 0
br i1 %t4006, label %L1270, label %L1271
L1270:
br label %L1272
L1271:
%t4007 = sub i64 0, %p4
br label %L1272
L1272:
%t4008 = phi i64 [ %p4, %L1270 ], [ %t4007, %L1271 ]
%t4009 = icmp slt i64 %t4008, 10
br i1 %t4009, label %L1273, label %L1274
L1273:
%t4010 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t4005, i64 48)
br label %L1275
L1274:
br label %L1275
L1275:
%t4011 = phi i64 [ %t4010, %L1273 ], [ %t4005, %L1274 ]
%t4012 = add i64 %p0, %t4011
%t4013 = call i64 @itoa_into(i64 %t4012, i64 %t4008)
%t4014 = add i64 %t4011, %t4013
ret i64 %t4014
}
define internal i1 @box_imm(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4015 = sub i64 %p0, 281474976710656
%t4016 = call i1 @ult(i64 %t4015, i64 36028797018963968)
ret i1 %t4016
}
define internal i1 @box_fimm(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4017 = call i1 @ult(i64 %p0, i64 72057594037927936)
%t4018 = xor i1 %t4017, true
ret i1 %t4018
}
define internal i64 @imm_val(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4019 = sub i64 %p0, 18295873486192640
ret i64 %t4019
}
define internal i64 @sx32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4020 = shl i64 %p0, 32
%t4021 = ashr i64 %t4020, 32
ret i64 %t4021
}
define internal i64 @box_tag(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4022 = call i64 @ld32(i64 %p0)
%t4023 = tail call i64 @sx32(i64 %t4022)
ret i64 %t4023
}
define internal i64 @box_count(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4024 = add i64 %p0, 4
%t4025 = call i64 @ld32(i64 %t4024)
%t4026 = tail call i64 @sx32(i64 %t4025)
ret i64 %t4026
}
define internal i64 @box_type(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4027 = add i64 %p0, 8
%t4028 = tail call i64 @ld64(i64 %t4027)
ret i64 %t4028
}
define internal i64 @box_slot(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4029 = add i64 %p0, 16
%t4030 = mul i64 %p1, 8
%t4031 = add i64 %t4029, %t4030
%t4032 = call i64 @ld64(i64 %t4031)
ret i64 %t4032
}
define internal i64 @unbox_word(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4033 = call i1 @box_imm(i64 %p0)
br i1 %t4033, label %L1276, label %L1277
L1276:
%t4034 = call i64 @imm_val(i64 %p0)
br label %L1278
L1277:
%t4035 = add i64 %p0, 24
%t4036 = call i64 @ld64(i64 %t4035)
br label %L1278
L1278:
%t4037 = phi i64 [ %t4034, %L1276 ], [ %t4036, %L1277 ]
ret i64 %t4037
}
define internal double @unbox_float(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4038 = call i1 @box_fimm(i64 %p0)
br i1 %t4038, label %L1279, label %L1280
L1279:
br label %L1281
L1280:
%t4039 = add i64 %p0, 24
%t4040 = call i64 @ld64(i64 %t4039)
br label %L1281
L1281:
%t4041 = phi i64 [ %p0, %L1279 ], [ %t4040, %L1280 ]
%t4042 = bitcast i64 %t4041 to double
ret double %t4042
}
define internal i64 @__mruntime_rt_show_resid__scalar_kind(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4043 = call i1 @box_imm(i64 %p0)
br i1 %t4043, label %L1282, label %L1284
L1282:
ret i64 105
L1284:
%t4044 = call i1 @box_fimm(i64 %p0)
br i1 %t4044, label %L1285, label %L1287
L1285:
ret i64 102
L1287:
%t4045 = call i64 @box_tag(i64 %p0)
%t4046 = sub nsw i64 0, 1
%t4047 = icmp ne i64 %t4045, %t4046
br label %LSL4048
LSL4048:
br i1 %t4047, label %LSJ4048, label %LSR4048
LSR4048:
%t4049 = call i64 @box_type(i64 %p0)
%t4050 = icmp eq i64 %t4049, 0
br label %LSJ4048
LSJ4048:
%t4051 = phi i1 [ true, %LSL4048 ], [ %t4050, %LSR4048 ]
br i1 %t4051, label %L1288, label %L1290
L1288:
ret i64 0
L1290:
%t4052 = call i64 @box_type(i64 %p0)
%t4053 = tail call i64 @ld8(i64 %t4052)
ret i64 %t4053
}
define internal i64 @sb_lit(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4054 = call i64 @c_strlen(i64 %p1)
%t4055 = call i64 @sb_bytes(i64 %p0, i64 %p1, i64 %t4054)
ret i64 %t4055
}
define internal i64 @sb_word(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4056p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.show_buf)
%t4056 = ptrtoint ptr %t4056p to i64
%t4057 = call i64 @itoa_into(i64 %t4056, i64 %p1)
%t4058 = call i64 @sb_bytes(i64 %p0, i64 %t4056, i64 %t4057)
ret i64 %t4058
}
define internal i64 @sb_float(i64 %p0, double %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4059p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.show_buf)
%t4059 = ptrtoint ptr %t4059p to i64
%t4061 = ptrtoint ptr @.s4060 to i64
%t4062 = call i64 @c_strfromd(i64 %t4059, i64 64, i64 %t4061, double %p1)
%t4063 = call i64 @sb_bytes(i64 %p0, i64 %t4059, i64 %t4062)
ret i64 %t4063
}
define internal i64 @__mruntime_rt_show_resid__sb_scalar(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4064 = icmp eq i64 %p2, 102
br i1 %t4064, label %L1291, label %L1293
L1291:
%t4065 = call double @unbox_float(i64 %p1)
%t4066 = call i64 @sb_float(i64 %p0, double %t4065)
ret i64 %t4066
L1293:
%t4067 = icmp eq i64 %p2, 98
br i1 %t4067, label %L1294, label %L1296
L1294:
%t4068 = add i64 %p1, 24
%t4069 = call i64 @ld8(i64 %t4068)
%t4070 = icmp ne i64 %t4069, 0
br i1 %t4070, label %L1297, label %L1298
L1297:
%t4072 = ptrtoint ptr @.s4071 to i64
br label %L1299
L1298:
%t4074 = ptrtoint ptr @.s4073 to i64
br label %L1299
L1299:
%t4075 = phi i64 [ %t4072, %L1297 ], [ %t4074, %L1298 ]
%t4076 = call i64 @sb_lit(i64 %p0, i64 %t4075)
ret i64 %t4076
L1296:
%t4077 = call i64 @unbox_word(i64 %p1)
%t4078 = call i64 @sb_word(i64 %p0, i64 %t4077)
ret i64 %t4078
}
define internal i64 @__mruntime_rt_show_resid__sb_elem(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4079 = icmp eq i64 %p1, 0
br i1 %t4079, label %L1300, label %L1302
L1300:
%t4081 = ptrtoint ptr @.s4080 to i64
%t4082 = tail call i64 @sb_lit(i64 %p0, i64 %t4081)
ret i64 %t4082
L1302:
%t4083 = call i64 @__mruntime_rt_show_resid__scalar_kind(i64 %p1)
%t4084 = icmp eq i64 %t4083, 0
br i1 %t4084, label %L1303, label %L1305
L1303:
%t4086 = ptrtoint ptr @.s4085 to i64
%t4087 = tail call i64 @sb_lit(i64 %p0, i64 %t4086)
ret i64 %t4087
L1305:
%t4088 = call i64 @__mruntime_rt_show_resid__sb_scalar(i64 %p0, i64 %p1, i64 %t4083)
ret i64 %t4088
}
define internal i64 @__mruntime_rt_show_resid__sb_slots(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4097, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t4089 = icmp sge i64 %p2, %p3
br i1 %t4089, label %L1306, label %L1308
L1306:
ret i64 0
L1308:
%t4090 = icmp sgt i64 %p2, 0
br i1 %t4090, label %L1309, label %L1310
L1309:
%t4092 = ptrtoint ptr @.s4091 to i64
%t4093 = call i64 @sb_lit(i64 %p0, i64 %t4092)
br label %L1311
L1310:
br label %L1311
L1311:
%t4094 = phi i64 [ %t4093, %L1309 ], [ 0, %L1310 ]
%t4095 = call i64 @box_slot(i64 %p1, i64 %p2)
%t4096 = call i64 @__mruntime_rt_show_resid__sb_elem(i64 %p0, i64 %t4095)
%t4097 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_show_resid__sb_items(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4107, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t4099 = icmp sge i64 %p2, %p3
br i1 %t4099, label %L1312, label %L1314
L1312:
ret i64 0
L1314:
%t4100 = icmp sgt i64 %p2, 0
br i1 %t4100, label %L1315, label %L1316
L1315:
%t4102 = ptrtoint ptr @.s4101 to i64
%t4103 = call i64 @sb_lit(i64 %p0, i64 %t4102)
br label %L1317
L1316:
br label %L1317
L1317:
%t4104 = phi i64 [ %t4103, %L1315 ], [ 0, %L1316 ]
%t4105 = call i64 @c_list_get(i64 %p1, i64 %p2)
%t4106 = call i64 @__mruntime_rt_show_resid__sb_elem(i64 %p0, i64 %t4105)
%t4107 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_to_string(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4109 = call i1 @box_imm(i64 %p0)
br i1 %t4109, label %L1318, label %L1320
L1318:
%t4110 = call i64 @imm_val(i64 %p0)
%t4111 = tail call i64 @rt_int_to_string(i64 %t4110)
ret i64 %t4111
L1320:
%t4112 = call i1 @box_fimm(i64 %p0)
br i1 %t4112, label %L1321, label %L1323
L1321:
%t4113 = call double @unbox_float(i64 %p0)
%t4114 = call i64 @rt_float_to_string(double %t4113)
ret i64 %t4114
L1323:
%t4115 = icmp eq i64 %p0, 0
br label %LSL4116
LSL4116:
br i1 %t4115, label %LSJ4116, label %LSR4116
LSR4116:
%t4117 = call i64 @box_count(i64 %p0)
%t4118 = icmp sle i64 %t4117, 0
br label %LSJ4116
LSJ4116:
%t4119 = phi i1 [ true, %LSL4116 ], [ %t4118, %LSR4116 ]
br i1 %t4119, label %L1324, label %L1326
L1324:
%t4121 = ptrtoint ptr @.s4120 to i64
%t4122 = tail call i64 @cstr_dup(i64 %t4121)
ret i64 %t4122
L1326:
%t4123 = call i64 @box_tag(i64 %p0)
%t4124 = call i64 @box_type(i64 %p0)
%t4125 = sub nsw i64 0, 1
%t4126 = icmp eq i64 %t4123, %t4125
br i1 %t4126, label %L1327, label %L1329
L1327:
%t4127 = icmp ne i64 %t4124, 0
br label %LSL4128
LSL4128:
br i1 %t4127, label %LSR4128, label %LSJ4128
LSR4128:
%t4130 = ptrtoint ptr @.s4129 to i64
%t4131 = call i64 @c_strcmp(i64 %t4124, i64 %t4130)
%t4132 = icmp eq i64 %t4131, 0
br label %LSJ4128
LSJ4128:
%t4133 = phi i1 [ false, %LSL4128 ], [ %t4132, %LSR4128 ]
br i1 %t4133, label %L1330, label %L1332
L1330:
%t4134 = call i64 @limbs2(i64 %p0)
%t4135 = add i64 %p0, 32
%t4136 = call i64 @ld64(i64 %t4135)
%t4137 = icmp slt i64 %t4136, 0
%t4138 = call i64 @limbs_to_str(i64 %t4134, i64 2, i1 %t4137)
ret i64 %t4138
L1332:
%t4139 = icmp ne i64 %t4124, 0
br label %LSL4140
LSL4140:
br i1 %t4139, label %LSR4140, label %LSJ4140
LSR4140:
%t4142 = ptrtoint ptr @.s4141 to i64
%t4143 = call i64 @c_strcmp(i64 %t4124, i64 %t4142)
%t4144 = icmp eq i64 %t4143, 0
br label %LSJ4140
LSJ4140:
%t4145 = phi i1 [ false, %LSL4140 ], [ %t4144, %LSR4140 ]
br i1 %t4145, label %L1333, label %L1335
L1333:
%t4146 = call i64 @limbs2(i64 %p0)
%t4147 = call i64 @limbs_to_str(i64 %t4146, i64 2, i1 false)
ret i64 %t4147
L1335:
%t4148 = icmp eq i64 %t4124, 0
br i1 %t4148, label %L1336, label %L1337
L1336:
br label %L1338
L1337:
%t4149 = call i64 @ld8(i64 %t4124)
br label %L1338
L1338:
%t4150 = phi i64 [ 0, %L1336 ], [ %t4149, %L1337 ]
%t4151 = call i64 @rt_sb_new()
%t4152 = icmp eq i64 %t4150, 102
br label %LSL4153
LSL4153:
br i1 %t4152, label %LSJ4153, label %LSR4153
LSR4153:
%t4154 = icmp eq i64 %t4150, 98
br label %LSJ4153
LSJ4153:
%t4155 = phi i1 [ true, %LSL4153 ], [ %t4154, %LSR4153 ]
br i1 %t4155, label %L1339, label %L1340
L1339:
br label %L1341
L1340:
br label %L1341
L1341:
%t4156 = phi i64 [ %t4150, %L1339 ], [ 105, %L1340 ]
%t4157 = call i64 @__mruntime_rt_show_resid__sb_scalar(i64 %t4151, i64 %p0, i64 %t4156)
%t4158 = tail call i64 @rt_sb_finish(i64 %t4151)
ret i64 %t4158
L1329:
%t4159 = icmp eq i64 %t4123, 1
br label %LSL4160
LSL4160:
br i1 %t4159, label %LSR4160, label %LSJ4160
LSR4160:
%t4161 = call i64 @box_count(i64 %p0)
%t4162 = icmp eq i64 %t4161, 1
br label %LSJ4160
LSJ4160:
%t4163 = phi i1 [ false, %LSL4160 ], [ %t4162, %LSR4160 ]
br label %LSL4164
LSL4164:
br i1 %t4163, label %LSR4164, label %LSJ4164
LSR4164:
%t4165 = call i64 @box_slot(i64 %p0, i64 0)
%t4166 = icmp ne i64 %t4165, 0
br label %LSJ4164
LSJ4164:
%t4167 = phi i1 [ false, %LSL4164 ], [ %t4166, %LSR4164 ]
br i1 %t4167, label %L1342, label %L1344
L1342:
%t4168 = call i64 @box_slot(i64 %p0, i64 0)
%t4169 = call i64 @__mruntime_rt_show_resid__scalar_kind(i64 %t4168)
%t4170 = call i64 @rt_sb_new()
%t4171 = icmp ne i64 %t4169, 0
br i1 %t4171, label %L1345, label %L1346
L1345:
%t4173 = ptrtoint ptr @.s4172 to i64
br label %L1347
L1346:
%t4175 = ptrtoint ptr @.s4174 to i64
br label %L1347
L1347:
%t4176 = phi i64 [ %t4173, %L1345 ], [ %t4175, %L1346 ]
%t4177 = call i64 @sb_lit(i64 %t4170, i64 %t4176)
%t4178 = icmp ne i64 %t4169, 0
br i1 %t4178, label %L1348, label %L1349
L1348:
%t4179 = call i64 @__mruntime_rt_show_resid__sb_scalar(i64 %t4170, i64 %t4168, i64 %t4169)
br label %L1350
L1349:
%t4180 = call i64 @sb_lit(i64 %t4170, i64 %t4124)
br label %L1350
L1350:
%t4181 = phi i64 [ %t4179, %L1348 ], [ %t4180, %L1349 ]
%t4182 = icmp ne i64 %t4169, 0
br i1 %t4182, label %L1351, label %L1352
L1351:
%t4184 = ptrtoint ptr @.s4183 to i64
br label %L1353
L1352:
%t4186 = ptrtoint ptr @.s4185 to i64
br label %L1353
L1353:
%t4187 = phi i64 [ %t4184, %L1351 ], [ %t4186, %L1352 ]
%t4188 = call i64 @sb_lit(i64 %t4170, i64 %t4187)
%t4189 = tail call i64 @rt_sb_finish(i64 %t4170)
ret i64 %t4189
L1344:
%t4190 = icmp eq i64 %t4123, 2
br i1 %t4190, label %L1354, label %L1356
L1354:
%t4192 = ptrtoint ptr @.s4191 to i64
%t4193 = tail call i64 @cstr_dup(i64 %t4192)
ret i64 %t4193
L1356:
%t4194 = call i64 @rt_sb_new()
%t4195 = call i64 @sb_lit(i64 %t4194, i64 %t4124)
%t4197 = ptrtoint ptr @.s4196 to i64
%t4198 = call i64 @sb_lit(i64 %t4194, i64 %t4197)
%t4199 = call i64 @box_count(i64 %p0)
%t4200 = call i64 @__mruntime_rt_show_resid__sb_slots(i64 %t4194, i64 %p0, i64 0, i64 %t4199)
%t4202 = ptrtoint ptr @.s4201 to i64
%t4203 = call i64 @sb_lit(i64 %t4194, i64 %t4202)
%t4204 = tail call i64 @rt_sb_finish(i64 %t4194)
ret i64 %t4204
}
define ptr @ToString(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_to_string(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_list_show(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4205 = icmp eq i64 %p0, 0
br i1 %t4205, label %L1357, label %L1359
L1357:
%t4207 = ptrtoint ptr @.s4206 to i64
%t4208 = call i64 @cstr_dup(i64 %t4207)
ret i64 %t4208
L1359:
%t4209 = call i64 @rt_sb_new()
%t4210 = add i64 %p0, 24
%t4211 = call i64 @ld64(i64 %t4210)
%t4212 = call i64 @sb_lit(i64 %t4209, i64 %t4211)
%t4214 = ptrtoint ptr @.s4213 to i64
%t4215 = call i64 @sb_lit(i64 %t4209, i64 %t4214)
%t4216 = icmp ne i64 %p1, 0
br i1 %t4216, label %L1360, label %L1361
L1360:
%t4217 = call i64 @ld64(i64 %p0)
%t4218 = call i64 @__mruntime_rt_show_resid__sb_strs(i64 %t4209, i64 %p0, i64 0, i64 %t4217)
br label %L1362
L1361:
%t4219 = call i64 @ld64(i64 %p0)
%t4220 = call i64 @__mruntime_rt_show_resid__sb_items(i64 %t4209, i64 %p0, i64 0, i64 %t4219)
br label %L1362
L1362:
%t4221 = phi i64 [ %t4218, %L1360 ], [ %t4220, %L1361 ]
%t4223 = ptrtoint ptr @.s4222 to i64
%t4224 = call i64 @sb_lit(i64 %t4209, i64 %t4223)
%t4225 = call i64 @rt_sb_finish(i64 %t4209)
ret i64 %t4225
}
define ptr @resid_list_show(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_show(i64 %x0i, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_show_resid__sb_strs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4234, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t4226 = icmp sge i64 %p2, %p3
br i1 %t4226, label %L1363, label %L1365
L1363:
ret i64 0
L1365:
%t4227 = icmp sgt i64 %p2, 0
br i1 %t4227, label %L1366, label %L1367
L1366:
%t4229 = ptrtoint ptr @.s4228 to i64
%t4230 = call i64 @sb_lit(i64 %p0, i64 %t4229)
br label %L1368
L1367:
br label %L1368
L1368:
%t4231 = phi i64 [ %t4230, %L1366 ], [ 0, %L1367 ]
%t4232 = call i64 @c_list_get(i64 %p1, i64 %p2)
%t4233 = call i64 @sb_lit(i64 %p0, i64 %t4232)
%t4234 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_to_string(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4236 = call i64 @rt_list_show(i64 %p0, i64 0)
ret i64 %t4236
}
define ptr @resid_list_to_string(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_to_string(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i1 @__mruntime_rt_lists_resid__elem_eq(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4237 = icmp eq i64 %p0, 2
br i1 %t4237, label %L1369, label %L1371
L1369:
%t4238 = call i64 @c_strcmp(i64 %p1, i64 %p2)
%t4239 = icmp eq i64 %t4238, 0
ret i1 %t4239
L1371:
%t4240 = icmp eq i64 %p0, 1
br i1 %t4240, label %L1372, label %L1374
L1372:
%t4241 = call double @unbox_float(i64 %p1)
%t4242 = bitcast i64 %p2 to double
%t4243 = fcmp oeq double %t4241, %t4242
ret i1 %t4243
L1374:
%t4244 = call i64 @unbox_word(i64 %p1)
%t4245 = icmp eq i64 %t4244, %p2
ret i1 %t4245
}
define internal i1 @__mruntime_rt_lists_resid__list_has(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t4249, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t4246 = icmp sge i64 %p3, %p4
br i1 %t4246, label %L1375, label %L1377
L1375:
ret i1 false
L1377:
%t4247 = call i64 @c_list_get(i64 %p0, i64 %p3)
%t4248 = call i1 @__mruntime_rt_lists_resid__elem_eq(i64 %p1, i64 %t4247, i64 %p2)
br i1 %t4248, label %L1378, label %L1380
L1378:
ret i1 true
L1380:
%t4249 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_contains_int(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4251 = call i64 @c_list_len(i64 %p0)
%t4252 = call i1 @__mruntime_rt_lists_resid__list_has(i64 %p0, i64 0, i64 %p1, i64 0, i64 %t4251)
br i1 %t4252, label %L1381, label %L1382
L1381:
br label %L1383
L1382:
br label %L1383
L1383:
%t4253 = phi i64 [ 1, %L1381 ], [ 0, %L1382 ]
ret i64 %t4253
}
define i8 @list_contains_int(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_contains_int(i64 %x0i, i64 %a1)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_list_contains_float(i64 %p0, double %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4254 = bitcast double %p1 to i64
%t4255 = call i64 @c_list_len(i64 %p0)
%t4256 = call i1 @__mruntime_rt_lists_resid__list_has(i64 %p0, i64 1, i64 %t4254, i64 0, i64 %t4255)
br i1 %t4256, label %L1384, label %L1385
L1384:
br label %L1386
L1385:
br label %L1386
L1386:
%t4257 = phi i64 [ 1, %L1384 ], [ 0, %L1385 ]
ret i64 %t4257
}
define i8 @list_contains_float(ptr %a0, double %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_contains_float(i64 %x0i, double %a1)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_list_contains_str(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4258 = call i64 @c_list_len(i64 %p0)
%t4259 = call i1 @__mruntime_rt_lists_resid__list_has(i64 %p0, i64 2, i64 %p1, i64 0, i64 %t4258)
br i1 %t4259, label %L1387, label %L1388
L1387:
br label %L1389
L1388:
br label %L1389
L1389:
%t4260 = phi i64 [ 1, %L1387 ], [ 0, %L1388 ]
ret i64 %t4260
}
define i8 @list_contains_str(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_list_contains_str(i64 %x0i, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_list_reverse(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4261 = call i64 @c_list_len(i64 %p0)
%t4262 = call i64 @c_list_to_array(i64 %p0)
%t4263 = sub i64 %t4261, 1
%t4264 = call i64 @__mruntime_rt_lists_resid__rev_at(i64 %t4262, i64 0, i64 %t4263)
%t4265 = call i64 @c_list_type(i64 %p0)
%t4266 = call i64 @c_list_new(i64 %t4261, i64 %t4262, i64 %t4265)
%t4267 = call i64 @c_free(i64 %t4262)
%t4268 = mul nsw i64 %t4267, 0
%t4269 = add nsw i64 %t4268, %t4266
ret i64 %t4269
}
define ptr @list_reverse_ints(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_reverse(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_lists_resid__rev_at(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4283, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4284, %tco.s0 ]
%t4270 = icmp sge i64 %p1, %p2
br i1 %t4270, label %L1390, label %L1392
L1390:
ret i64 0
L1392:
%t4271 = mul i64 %p1, 8
%t4272 = add i64 %p0, %t4271
%t4273 = call i64 @ld64(i64 %t4272)
%t4274 = mul i64 %p1, 8
%t4275 = add i64 %p0, %t4274
%t4276 = mul i64 %p2, 8
%t4277 = add i64 %p0, %t4276
%t4278 = call i64 @ld64(i64 %t4277)
%t4279 = call i64 @st64(i64 %t4275, i64 %t4278)
%t4280 = mul i64 %p2, 8
%t4281 = add i64 %p0, %t4280
%t4282 = call i64 @st64(i64 %t4281, i64 %t4273)
%t4283 = add nsw i64 %p1, 1
%t4284 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_sum(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4286 = call i64 @c_list_len(i64 %p0)
%t4287 = call i64 @__mruntime_rt_lists_resid__sum_words(i64 %p0, i64 0, i64 %t4286, i64 0)
ret i64 %t4287
}
define i64 @list_sum(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_sum(i64 %x0i)
ret i64 %r
}
define internal i64 @__mruntime_rt_lists_resid__sum_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4289, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t4292, %tco.s0 ]
%t4288 = icmp sge i64 %p1, %p2
br i1 %t4288, label %L1393, label %L1395
L1393:
ret i64 %p3
L1395:
%t4289 = add nsw i64 %p1, 1
%t4290 = call i64 @c_list_get(i64 %p0, i64 %p1)
%t4291 = call i64 @unbox_word(i64 %t4290)
%t4292 = add i64 %p3, %t4291
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal double @rt_list_sumf(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4294 = call i64 @c_list_len(i64 %p0)
%t4295 = call double @__mruntime_rt_lists_resid__sum_floats(i64 %p0, i64 0, i64 %t4294, double 0.0)
ret double %t4295
}
define double @list_sumf(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call double @rt_list_sumf(i64 %x0i)
ret double %r
}
define internal double @__mruntime_rt_lists_resid__sum_floats(i64 %p0.in, i64 %p1.in, i64 %p2.in, double %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4297, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi double [ %p3.in, %entry ], [ %t4300, %tco.s0 ]
%t4296 = icmp sge i64 %p1, %p2
br i1 %t4296, label %L1396, label %L1398
L1396:
ret double %p3
L1398:
%t4297 = add nsw i64 %p1, 1
%t4298 = call i64 @c_list_get(i64 %p0, i64 %p1)
%t4299 = call double @unbox_float(i64 %t4298)
%t4300 = fadd double %p3, %t4299
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_lists_resid__slot_cmp(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4302 = icmp eq i64 %p0, 3
br i1 %t4302, label %L1399, label %L1401
L1399:
%t4303p = inttoptr i64 %p1 to ptr
%t4303 = call i64 %t4303p(i64 %p2, i64 %p3)
%t4304 = call i64 @sx32(i64 %t4303)
ret i64 %t4304
L1401:
%t4305 = call i64 @ld64(i64 %p2)
%t4306 = call i64 @ld64(i64 %p3)
%t4307 = icmp eq i64 %p0, 2
br i1 %t4307, label %L1402, label %L1404
L1402:
%t4308 = call i64 @c_strcmp(i64 %t4305, i64 %t4306)
ret i64 %t4308
L1404:
%t4309 = icmp eq i64 %p0, 1
br i1 %t4309, label %L1405, label %L1407
L1405:
%t4310 = call double @unbox_float(i64 %t4305)
%t4311 = call double @unbox_float(i64 %t4306)
%t4312 = fcmp olt double %t4310, %t4311
br i1 %t4312, label %L1408, label %L1409
L1408:
%t4313 = sub nsw i64 0, 1
br label %L1410
L1409:
%t4314 = fcmp ogt double %t4310, %t4311
br i1 %t4314, label %L1411, label %L1412
L1411:
br label %L1413
L1412:
br label %L1413
L1413:
%t4315 = phi i64 [ 1, %L1411 ], [ 0, %L1412 ]
br label %L1410
L1410:
%t4316 = phi i64 [ %t4313, %L1408 ], [ %t4315, %L1413 ]
ret i64 %t4316
L1407:
%t4317 = call i64 @unbox_word(i64 %t4305)
%t4318 = call i64 @unbox_word(i64 %t4306)
%t4319 = icmp slt i64 %t4317, %t4318
br i1 %t4319, label %L1414, label %L1415
L1414:
%t4320 = sub nsw i64 0, 1
br label %L1416
L1415:
%t4321 = icmp sgt i64 %t4317, %t4318
br i1 %t4321, label %L1417, label %L1418
L1417:
br label %L1419
L1418:
br label %L1419
L1419:
%t4322 = phi i64 [ 1, %L1417 ], [ 0, %L1418 ]
br label %L1416
L1416:
%t4323 = phi i64 [ %t4320, %L1414 ], [ %t4322, %L1419 ]
ret i64 %t4323
}
define internal i64 @__mruntime_rt_lists_resid__merge_run(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ], [ %p3, %tco.s1 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t4340, %tco.s0 ], [ %p4, %tco.s1 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ], [ %p5, %tco.s1 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ], [ %t4349, %tco.s1 ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p7, %tco.s0 ], [ %p7, %tco.s1 ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t4341, %tco.s0 ], [ %t4350, %tco.s1 ]
%t4324 = icmp slt i64 %p4, %p5
br label %LSL4325
LSL4325:
br i1 %t4324, label %LSR4325, label %LSJ4325
LSR4325:
%t4326 = icmp slt i64 %p6, %p7
br label %LSJ4325
LSJ4325:
%t4327 = phi i1 [ false, %LSL4325 ], [ %t4326, %LSR4325 ]
br i1 %t4327, label %L1420, label %L1422
L1420:
%t4328 = mul i64 %p4, 8
%t4329 = add i64 %p2, %t4328
%t4330 = mul i64 %p6, 8
%t4331 = add i64 %p2, %t4330
%t4332 = call i64 @__mruntime_rt_lists_resid__slot_cmp(i64 %p0, i64 %p1, i64 %t4329, i64 %t4331)
%t4333 = icmp sle i64 %t4332, 0
br i1 %t4333, label %L1423, label %L1425
L1423:
%t4334 = mul i64 %p8, 8
%t4335 = add i64 %p3, %t4334
%t4336 = mul i64 %p4, 8
%t4337 = add i64 %p2, %t4336
%t4338 = call i64 @ld64(i64 %t4337)
%t4339 = call i64 @st64(i64 %t4335, i64 %t4338)
%t4340 = add nsw i64 %p4, 1
%t4341 = add i64 %p8, 1
br label %tco.s0
tco.s0:
br label %tco.head
L1425:
%t4343 = mul i64 %p8, 8
%t4344 = add i64 %p3, %t4343
%t4345 = mul i64 %p6, 8
%t4346 = add i64 %p2, %t4345
%t4347 = call i64 @ld64(i64 %t4346)
%t4348 = call i64 @st64(i64 %t4344, i64 %t4347)
%t4349 = add nsw i64 %p6, 1
%t4350 = add i64 %p8, 1
br label %tco.s1
tco.s1:
br label %tco.head
L1422:
%t4352 = icmp slt i64 %p4, %p5
br i1 %t4352, label %L1426, label %L1427
L1426:
%t4353 = mul i64 %p8, 8
%t4354 = add i64 %p3, %t4353
%t4355 = mul i64 %p4, 8
%t4356 = add i64 %p2, %t4355
%t4357 = sub i64 %p5, %p4
%t4358 = mul i64 %t4357, 8
%t4359 = call i64 @mcopy(i64 %t4354, i64 %t4356, i64 %t4358)
br label %L1428
L1427:
br label %L1428
L1428:
%t4360 = phi i64 [ %t4359, %L1426 ], [ 0, %L1427 ]
%t4361 = icmp slt i64 %p6, %p7
br i1 %t4361, label %L1429, label %L1430
L1429:
%t4362 = add i64 %p8, %p5
%t4363 = sub i64 %t4362, %p4
%t4364 = mul i64 %t4363, 8
%t4365 = add i64 %p3, %t4364
%t4366 = mul i64 %p6, 8
%t4367 = add i64 %p2, %t4366
%t4368 = sub i64 %p7, %p6
%t4369 = mul i64 %t4368, 8
%t4370 = call i64 @mcopy(i64 %t4365, i64 %t4367, i64 %t4369)
br label %L1431
L1430:
br label %L1431
L1431:
%t4371 = phi i64 [ %t4370, %L1429 ], [ 0, %L1430 ]
ret i64 %t4371
}
define internal i64 @__mruntime_rt_lists_resid__merge_pass(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %t4382, %tco.s0 ]
%t4372 = icmp sge i64 %p6, %p4
br i1 %t4372, label %L1432, label %L1434
L1432:
ret i64 0
L1434:
%t4373 = add i64 %p6, %p5
%t4374 = icmp slt i64 %t4373, %p4
br i1 %t4374, label %L1435, label %L1436
L1435:
br label %L1437
L1436:
br label %L1437
L1437:
%t4375 = phi i64 [ %t4373, %L1435 ], [ %p4, %L1436 ]
%t4376 = mul i64 2, %p5
%t4377 = add i64 %p6, %t4376
%t4378 = icmp slt i64 %t4377, %p4
br i1 %t4378, label %L1438, label %L1439
L1438:
br label %L1440
L1439:
br label %L1440
L1440:
%t4379 = phi i64 [ %t4377, %L1438 ], [ %p4, %L1439 ]
%t4380 = call i64 @__mruntime_rt_lists_resid__merge_run(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p6, i64 %t4375, i64 %t4375, i64 %t4379, i64 %p6)
%t4381 = mul i64 2, %p5
%t4382 = add i64 %p6, %t4381
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_lists_resid__merge_sort(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p3, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p2, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t4386, %tco.s0 ]
%t4384 = icmp sge i64 %p5, %p4
br i1 %t4384, label %L1441, label %L1443
L1441:
ret i64 %p2
L1443:
%t4385 = call i64 @__mruntime_rt_lists_resid__merge_pass(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 0)
%t4386 = mul i64 %p5, 2
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_lists_resid__sorted_copy(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4388 = call i64 @c_list_len(i64 %p0)
%t4389 = call i64 @c_list_to_array(i64 %p0)
%t4390 = mul i64 %t4388, 8
%t4391 = call i64 @xmalloc(i64 %t4390)
%t4392 = call i64 @__mruntime_rt_lists_resid__merge_sort(i64 %p1, i64 %p2, i64 %t4389, i64 %t4391, i64 %t4388, i64 1)
%t4393 = call i64 @c_list_type(i64 %p0)
%t4394 = call i64 @c_list_new(i64 %t4388, i64 %t4392, i64 %t4393)
%t4395 = call i64 @c_free(i64 %t4389)
%t4396 = call i64 @c_free(i64 %t4391)
%t4397 = add i64 %t4395, %t4396
ret i64 %t4394
}
define internal i64 @rt_list_sort_ints(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4398 = call i64 @__mruntime_rt_lists_resid__sorted_copy(i64 %p0, i64 0, i64 0)
ret i64 %t4398
}
define ptr @list_sort_ints(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_sort_ints(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_list_sort_floats(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4399 = call i64 @__mruntime_rt_lists_resid__sorted_copy(i64 %p0, i64 1, i64 0)
ret i64 %t4399
}
define ptr @list_sort_floats(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_sort_floats(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_list_sort_strs(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4400 = call i64 @__mruntime_rt_lists_resid__sorted_copy(i64 %p0, i64 2, i64 0)
ret i64 %t4400
}
define ptr @list_sort_strs(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_sort_strs(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_list_sort_by(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4401 = call i64 @__mruntime_rt_lists_resid__sorted_copy(i64 %p0, i64 3, i64 %p1)
ret i64 %t4401
}
define ptr @list_sort_by(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_list_sort_by(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_crypto_random_byte() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4402p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.rand_byte)
%t4402 = ptrtoint ptr %t4402p to i64
%t4403 = call i64 @st64(i64 %t4402, i64 0)
%t4404 = call i64 @sc(i64 318, i64 %t4402, i64 1, i64 0)
%t4405 = icmp eq i64 %t4404, 1
br i1 %t4405, label %L1444, label %L1446
L1444:
%t4406 = call i64 @ld8(i64 %t4402)
ret i64 %t4406
L1446:
%t4408 = ptrtoint ptr @.s4407 to i64
%t4409 = call i64 @o_rdonly()
%t4410 = call i64 @sys_open(i64 %t4408, i64 %t4409, i64 0)
%t4411 = icmp slt i64 %t4410, 0
br i1 %t4411, label %L1447, label %L1449
L1447:
%t4413 = call i64 @rt_abort(ptr @.s4412)
ret i64 %t4413
L1449:
%t4414 = call i64 @sc(i64 0, i64 %t4410, i64 %t4402, i64 1)
%t4415 = call i64 @sys_close(i64 %t4410)
%t4416 = icmp ne i64 %t4414, 1
br i1 %t4416, label %L1450, label %L1452
L1450:
%t4418 = call i64 @rt_abort(ptr @.s4417)
ret i64 %t4418
L1452:
%t4419 = call i64 @ld8(i64 %t4402)
ret i64 %t4419
}
define i64 @resid_crypto_random_byte() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_crypto_random_byte()
ret i64 %r
}
define internal i64 @rt_cpu_has_aesni() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4420a = trunc i64 1 to i32
%t4420b = trunc i64 0 to i32
%t4420s = call { i32, i32, i32, i32 } asm "cpuid", "={ax},={bx},={cx},={dx},{ax},{cx}"(i32 %t4420a, i32 %t4420b)
%t4420c = extractvalue { i32, i32, i32, i32 } %t4420s, 2
%t4420d = extractvalue { i32, i32, i32, i32 } %t4420s, 3
%t4420h = zext i32 %t4420c to i64
%t4420l = zext i32 %t4420d to i64
%t4420k = shl i64 %t4420h, 32
%t4420 = or i64 %t4420k, %t4420l
%t4421 = ashr i64 %t4420, 57
%t4422 = and i64 %t4421, 1
ret i64 %t4422
}
define i8 @resid_cpu_has_aesni() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_cpu_has_aesni()
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_index_abort(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4423 = call i64 @rt_sb_new()
%t4425 = ptrtoint ptr @.s4424 to i64
%t4426 = call i64 @sb_lit(i64 %t4423, i64 %t4425)
%t4427 = call i64 @sb_word(i64 %t4423, i64 %p0)
%t4429 = ptrtoint ptr @.s4428 to i64
%t4430 = call i64 @sb_lit(i64 %t4423, i64 %t4429)
%t4431 = call i64 @sb_word(i64 %t4423, i64 %p1)
%t4432 = icmp ne i64 %p2, 0
br label %LSL4433
LSL4433:
br i1 %t4432, label %LSR4433, label %LSJ4433
LSR4433:
%t4434 = call i64 @ld8(i64 %p2)
%t4435 = icmp ne i64 %t4434, 0
br label %LSJ4433
LSJ4433:
%t4436 = phi i1 [ false, %LSL4433 ], [ %t4435, %LSR4433 ]
br i1 %t4436, label %L1453, label %L1454
L1453:
%t4438 = ptrtoint ptr @.s4437 to i64
%t4439 = call i64 @sb_lit(i64 %t4423, i64 %t4438)
%t4440 = call i64 @sb_lit(i64 %t4423, i64 %p2)
%t4441 = add i64 %t4439, %t4440
%t4443 = ptrtoint ptr @.s4442 to i64
%t4444 = call i64 @sb_lit(i64 %t4423, i64 %t4443)
%t4445 = add i64 %t4441, %t4444
br label %L1455
L1454:
br label %L1455
L1455:
%t4446 = phi i64 [ %t4445, %L1453 ], [ 0, %L1454 ]
%t4447 = call i64 @rt_sb_finish(i64 %t4423)
%t4448 = call i64 @rt_abort_at(i64 %t4447)
ret i64 %t4448
}
define void @resid_index_abort(i64 %a0, i64 %a1, ptr %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x2i = ptrtoint ptr %a2 to i64
%r = call i64 @rt_index_abort(i64 %a0, i64 %a1, i64 %x2i)
ret void
}
define internal i1 @__mruntime_rt_net_resid__host_ok(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4449 = call i64 @ld8(i64 %p0)
%t4450 = icmp eq i64 %t4449, 0
br i1 %t4450, label %L1456, label %L1458
L1456:
ret i1 true
L1458:
%t4451 = icmp sge i64 %t4449, 97
br label %LSL4452
LSL4452:
br i1 %t4451, label %LSR4452, label %LSJ4452
LSR4452:
%t4453 = icmp sle i64 %t4449, 122
br label %LSJ4452
LSJ4452:
%t4454 = phi i1 [ false, %LSL4452 ], [ %t4453, %LSR4452 ]
br label %LSL4455
LSL4455:
br i1 %t4454, label %LSJ4455, label %LSR4455
LSR4455:
%t4456 = icmp sge i64 %t4449, 65
br label %LSL4457
LSL4457:
br i1 %t4456, label %LSR4457, label %LSJ4457
LSR4457:
%t4458 = icmp sle i64 %t4449, 90
br label %LSJ4457
LSJ4457:
%t4459 = phi i1 [ false, %LSL4457 ], [ %t4458, %LSR4457 ]
br label %LSJ4455
LSJ4455:
%t4460 = phi i1 [ true, %LSL4455 ], [ %t4459, %LSJ4457 ]
br label %LSL4461
LSL4461:
br i1 %t4460, label %LSJ4461, label %LSR4461
LSR4461:
%t4462 = icmp sge i64 %t4449, 48
br label %LSL4463
LSL4463:
br i1 %t4462, label %LSR4463, label %LSJ4463
LSR4463:
%t4464 = icmp sle i64 %t4449, 57
br label %LSJ4463
LSJ4463:
%t4465 = phi i1 [ false, %LSL4463 ], [ %t4464, %LSR4463 ]
br label %LSJ4461
LSJ4461:
%t4466 = phi i1 [ true, %LSL4461 ], [ %t4465, %LSJ4463 ]
br label %LSL4467
LSL4467:
br i1 %t4466, label %LSJ4467, label %LSR4467
LSR4467:
%t4468 = icmp eq i64 %t4449, 45
br label %LSJ4467
LSJ4467:
%t4469 = phi i1 [ true, %LSL4467 ], [ %t4468, %LSR4467 ]
br label %LSL4470
LSL4470:
br i1 %t4469, label %LSJ4470, label %LSR4470
LSR4470:
%t4471 = icmp eq i64 %t4449, 46
br label %LSJ4470
LSJ4470:
%t4472 = phi i1 [ true, %LSL4470 ], [ %t4471, %LSR4470 ]
br label %LSL4473
LSL4473:
br i1 %t4472, label %LSJ4473, label %LSR4473
LSR4473:
%t4474 = icmp eq i64 %t4449, 58
br label %LSJ4473
LSJ4473:
%t4475 = phi i1 [ true, %LSL4473 ], [ %t4474, %LSR4473 ]
br label %LSL4476
LSL4476:
br i1 %t4475, label %LSR4476, label %LSJ4476
LSR4476:
%t4477 = add i64 %p0, 1
%t4478 = call i1 @__mruntime_rt_net_resid__host_ok(i64 %t4477)
br label %LSJ4476
LSJ4476:
%t4479 = phi i1 [ false, %LSL4476 ], [ %t4478, %LSR4476 ]
ret i1 %t4479
}
define internal i64 @rt_tcp_connect(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4480 = icmp eq i64 %p0, 0
br label %LSL4481
LSL4481:
br i1 %t4480, label %LSJ4481, label %LSR4481
LSR4481:
%t4482 = call i64 @ld8(i64 %p0)
%t4483 = icmp eq i64 %t4482, 0
br label %LSJ4481
LSJ4481:
%t4484 = phi i1 [ true, %LSL4481 ], [ %t4483, %LSR4481 ]
br label %LSL4485
LSL4485:
br i1 %t4484, label %LSJ4485, label %LSR4485
LSR4485:
%t4486 = call i1 @__mruntime_rt_net_resid__host_ok(i64 %p0)
%t4487 = xor i1 %t4486, true
br label %LSJ4485
LSJ4485:
%t4488 = phi i1 [ true, %LSL4485 ], [ %t4487, %LSR4485 ]
br i1 %t4488, label %L1459, label %L1461
L1459:
%t4489 = sub nsw i64 0, 1
ret i64 %t4489
L1461:
%t4490 = icmp sle i64 %p1, 0
br label %LSL4491
LSL4491:
br i1 %t4490, label %LSJ4491, label %LSR4491
LSR4491:
%t4492 = icmp sgt i64 %p1, 65535
br label %LSJ4491
LSJ4491:
%t4493 = phi i1 [ true, %LSL4491 ], [ %t4492, %LSR4491 ]
br i1 %t4493, label %L1462, label %L1464
L1462:
%t4494 = sub nsw i64 0, 1
ret i64 %t4494
L1464:
%t4495p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.ai_hints)
%t4495 = ptrtoint ptr %t4495p to i64
%t4496p = inttoptr i64 %t4495 to ptr
%t4496q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t4496p, i8 %t4496q, i64 48, i1 false)
%t4496 = add i64 0, 0
%t4497 = add i64 %t4495, 8
%t4498 = call i64 @st32(i64 %t4497, i64 1)
%t4499p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.ai_port)
%t4499 = ptrtoint ptr %t4499p to i64
%t4500 = call i64 @itoa_into(i64 %t4499, i64 %p1)
%t4501 = add i64 %t4499, %t4500
%t4502 = call i64 @st8(i64 %t4501, i64 0)
%t4503p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.ai_res)
%t4503 = ptrtoint ptr %t4503p to i64
%t4504 = call i64 @st64(i64 %t4503, i64 0)
%t4505 = call i64 @c_getaddrinfo(i64 %p0, i64 %t4499, i64 %t4495, i64 %t4503)
%t4506 = icmp ne i64 %t4505, 0
br label %LSL4507
LSL4507:
br i1 %t4506, label %LSJ4507, label %LSR4507
LSR4507:
%t4508 = call i64 @ld64(i64 %t4503)
%t4509 = icmp eq i64 %t4508, 0
br label %LSJ4507
LSJ4507:
%t4510 = phi i1 [ true, %LSL4507 ], [ %t4509, %LSR4507 ]
br i1 %t4510, label %L1465, label %L1467
L1465:
%t4511 = sub nsw i64 0, 1
ret i64 %t4511
L1467:
%t4512 = call i64 @ld64(i64 %t4503)
%t4513 = add i64 %t4512, 4
%t4514 = call i64 @ld32(i64 %t4513)
%t4515 = add i64 %t4512, 8
%t4516 = call i64 @ld32(i64 %t4515)
%t4517 = add i64 %t4512, 12
%t4518 = call i64 @ld32(i64 %t4517)
%t4519 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 41, i64 %t4514, i64 %t4516, i64 %t4518, i64 0, i64 0, i64 0)
%t4520 = icmp slt i64 %t4519, 0
br i1 %t4520, label %L1468, label %L1470
L1468:
%t4521 = call i64 @c_freeaddrinfo(i64 %t4512)
%t4522 = mul nsw i64 %t4521, 0
%t4523 = sub nsw i64 %t4522, 1
ret i64 %t4523
L1470:
%t4524 = add i64 %t4512, 24
%t4525 = call i64 @ld64(i64 %t4524)
%t4526 = add i64 %t4512, 16
%t4527 = call i64 @ld32(i64 %t4526)
%t4528 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 42, i64 %t4519, i64 %t4525, i64 %t4527, i64 0, i64 0, i64 0)
%t4529 = call i64 @c_freeaddrinfo(i64 %t4512)
%t4530 = icmp ne i64 %t4528, 0
br i1 %t4530, label %L1471, label %L1473
L1471:
%t4531 = call i64 @sys_close(i64 %t4519)
%t4532 = mul nsw i64 %t4531, 0
%t4533 = sub nsw i64 %t4532, 1
ret i64 %t4533
L1473:
%t4534p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.ai_tv)
%t4534 = ptrtoint ptr %t4534p to i64
%t4535 = call i64 @st64(i64 %t4534, i64 30)
%t4536 = add i64 %t4534, 8
%t4537 = call i64 @st64(i64 %t4536, i64 0)
%t4538 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 54, i64 %t4519, i64 1, i64 20, i64 %t4534, i64 16, i64 0)
ret i64 %t4519
}
define i64 @resid_tcp_connect(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_tcp_connect(i64 %x0i, i64 %a1)
ret i64 %r
}
define internal i1 @__mruntime_rt_net_resid__send_all(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4542, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4543, %tco.s0 ]
%t4539 = icmp sle i64 %p2, 0
br i1 %t4539, label %L1474, label %L1476
L1474:
ret i1 true
L1476:
%t4540 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 44, i64 %p0, i64 %p1, i64 %p2, i64 16384, i64 0, i64 0)
%t4541 = icmp sle i64 %t4540, 0
br i1 %t4541, label %L1477, label %L1479
L1477:
ret i1 false
L1479:
%t4542 = add i64 %p1, %t4540
%t4543 = sub nsw i64 %p2, %t4540
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_tcp_send(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4545 = call i64 @c_strlen(i64 %p1)
%t4546 = call i1 @__mruntime_rt_net_resid__send_all(i64 %p0, i64 %p1, i64 %t4545)
br i1 %t4546, label %L1480, label %L1481
L1480:
br label %L1482
L1481:
br label %L1482
L1482:
%t4547 = phi i64 [ 1, %L1480 ], [ 0, %L1481 ]
ret i64 %t4547
}
define i8 @resid_tcp_send(i64 %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_tcp_send(i64 %a0, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_tcp_recv_all(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4548 = call i64 @xmalloc(i64 65536)
%t4549 = call i64 @__mruntime_rt_net_resid__recv_loop(i64 %p0, i64 %t4548, i64 65536, i64 0)
ret i64 %t4549
}
define ptr @resid_tcp_recv_all(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_tcp_recv_all(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_net_resid__recv_loop(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4558, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4559, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ], [ %t4570, %tco.s1 ]
%t4550 = add i64 %p3, 4096
%t4551 = icmp sgt i64 %t4550, %p2
br i1 %t4551, label %L1483, label %L1485
L1483:
%t4552 = icmp sge i64 %p2, 4194304
br i1 %t4552, label %L1486, label %L1488
L1486:
%t4553 = add i64 %p1, %p3
%t4554 = call i64 @st8(i64 %t4553, i64 0)
%t4555 = mul nsw i64 %t4554, 0
%t4556 = add nsw i64 %t4555, %p1
ret i64 %t4556
L1488:
%t4557 = mul i64 %p2, 2
%t4558 = call i64 @xrealloc(i64 %p1, i64 %t4557)
%t4559 = mul i64 %p2, 2
br label %tco.s0
tco.s0:
br label %tco.head
L1485:
%t4561 = add i64 %p1, %p3
%t4562 = sub i64 %p2, %p3
%t4563 = sub i64 %t4562, 1
%t4564 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 45, i64 %p0, i64 %t4561, i64 %t4563, i64 0, i64 0, i64 0)
%t4565 = icmp sle i64 %t4564, 0
br i1 %t4565, label %L1489, label %L1491
L1489:
%t4566 = add i64 %p1, %p3
%t4567 = call i64 @st8(i64 %t4566, i64 0)
%t4568 = mul nsw i64 %t4567, 0
%t4569 = add nsw i64 %t4568, %p1
ret i64 %t4569
L1491:
%t4570 = add i64 %p3, %t4564
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @rt_tcp_close(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4572 = call i64 @sys_close(i64 %p0)
%t4573 = icmp eq i64 %t4572, 0
br i1 %t4573, label %L1492, label %L1493
L1492:
br label %L1494
L1493:
br label %L1494
L1494:
%t4574 = phi i64 [ 1, %L1492 ], [ 0, %L1493 ]
ret i64 %t4574
}
define i8 @resid_tcp_close(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_tcp_close(i64 %a0)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_tcp_send_bin(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4575 = call i64 @c_list_len(i64 %p1)
%t4576 = icmp sle i64 %t4575, 0
br i1 %t4576, label %L1495, label %L1497
L1495:
ret i64 1
L1497:
%t4577 = icmp sgt i64 %t4575, 1048576
br i1 %t4577, label %L1498, label %L1500
L1498:
ret i64 0
L1500:
%t4578 = call i64 @xmalloc(i64 %t4575)
%t4579 = call i64 @__mruntime_rt_net_resid__bytes_of(i64 %p1, i64 %t4578, i64 0, i64 %t4575)
%t4580 = call i1 @__mruntime_rt_net_resid__send_all(i64 %p0, i64 %t4578, i64 %t4575)
%t4581 = call i64 @c_free(i64 %t4578)
br i1 %t4580, label %L1501, label %L1502
L1501:
br label %L1503
L1502:
br label %L1503
L1503:
%t4582 = phi i64 [ 1, %L1501 ], [ 0, %L1502 ]
ret i64 %t4582
}
define i8 @resid_tcp_send_bin(i64 %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_tcp_send_bin(i64 %a0, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @__mruntime_rt_net_resid__bytes_of(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4589, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t4583 = icmp sge i64 %p2, %p3
br i1 %t4583, label %L1504, label %L1506
L1504:
ret i64 0
L1506:
%t4584 = add i64 %p1, %p2
%t4585 = call i64 @c_list_get(i64 %p0, i64 %p2)
%t4586 = call i64 @unbox_word(i64 %t4585)
%t4587 = and i64 %t4586, 255
%t4588 = call i64 @st8(i64 %t4584, i64 %t4587)
%t4589 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_tcp_recv_bin(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4591 = icmp slt i64 %p1, 0
br i1 %t4591, label %L1507, label %L1508
L1507:
br label %L1509
L1508:
%t4592 = icmp sgt i64 %p1, 1048576
br i1 %t4592, label %L1510, label %L1511
L1510:
br label %L1512
L1511:
br label %L1512
L1512:
%t4593 = phi i64 [ 1048576, %L1510 ], [ %p1, %L1511 ]
br label %L1509
L1509:
%t4594 = phi i64 [ 0, %L1507 ], [ %t4593, %L1512 ]
%t4595 = call i64 @xmalloc(i64 %t4594)
%t4596p = inttoptr i64 %t4595 to ptr
%t4596q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t4596p, i8 %t4596q, i64 %t4594, i1 false)
%t4596 = add i64 0, 0
%t4597 = call i64 @__mruntime_rt_net_resid__recv_exact(i64 %p0, i64 %t4595, i64 0, i64 %t4594)
%t4598 = mul i64 %t4594, 8
%t4599 = call i64 @xmalloc(i64 %t4598)
%t4600 = call i64 @__mruntime_rt_net_resid__byte_boxes(i64 %t4595, i64 %t4599, i64 0, i64 %t4594)
%t4602 = ptrtoint ptr @.s4601 to i64
%t4603 = call i64 @c_list_new(i64 %t4594, i64 %t4599, i64 %t4602)
%t4604 = call i64 @c_free(i64 %t4595)
%t4605 = call i64 @c_free(i64 %t4599)
%t4606 = add i64 %t4604, %t4605
ret i64 %t4603
}
define ptr @resid_tcp_recv_bin(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_tcp_recv_bin(i64 %a0, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_net_resid__recv_exact(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4612, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t4607 = icmp sge i64 %p2, %p3
br i1 %t4607, label %L1513, label %L1515
L1513:
ret i64 %p2
L1515:
%t4608 = add i64 %p1, %p2
%t4609 = sub i64 %p3, %p2
%t4610 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 45, i64 %p0, i64 %t4608, i64 %t4609, i64 0, i64 0, i64 0)
%t4611 = icmp sle i64 %t4610, 0
br i1 %t4611, label %L1516, label %L1518
L1516:
ret i64 %p2
L1518:
%t4612 = add i64 %p2, %t4610
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_net_resid__byte_boxes(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4621, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t4614 = icmp sge i64 %p2, %p3
br i1 %t4614, label %L1519, label %L1521
L1519:
ret i64 0
L1521:
%t4615 = mul i64 %p2, 8
%t4616 = add i64 %p1, %t4615
%t4617 = add i64 %p0, %p2
%t4618 = call i64 @ld8(i64 %t4617)
%t4619 = add i64 %t4618, 18295873486192640
%t4620 = call i64 @st64(i64 %t4616, i64 %t4619)
%t4621 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_ctl_resid__catch_slot() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4623p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.rt_catch)
%t4623 = ptrtoint ptr %t4623p to i64
ret i64 %t4623
}
define internal i64 @__mruntime_rt_ctl_resid__catch_msg() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4624p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.rt_catch_msg)
%t4624 = ptrtoint ptr %t4624p to i64
ret i64 %t4624
}
define internal i1 @under_catch(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4625 = call i64 @__mruntime_rt_ctl_resid__catch_slot()
%t4626 = call i64 @e.catch(i64 %t4625, i64 %p0, i64 %p1)
%t4627 = icmp ne i64 %t4626, 0
ret i1 %t4627
}
define internal i64 @__mruntime_rt_ctl_resid__rt_fail(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4628 = call i64 @__mruntime_rt_ctl_resid__catch_slot()
%t4629 = call i64 @ld64(i64 %t4628)
%t4630 = icmp ne i64 %t4629, 0
br i1 %t4630, label %L1522, label %L1524
L1522:
%t4631 = call i64 @__mruntime_rt_ctl_resid__catch_msg()
%t4632 = icmp ne i64 %p0, 0
br i1 %t4632, label %L1525, label %L1526
L1525:
br label %L1527
L1526:
%t4634 = ptrtoint ptr @.s4633 to i64
br label %L1527
L1527:
%t4635 = phi i64 [ %p0, %L1525 ], [ %t4634, %L1526 ]
%t4636 = call i64 @st64(i64 %t4631, i64 %t4635)
%t4637 = tail call i64 @c_longjmp(i64 %t4629, i64 1)
ret i64 %t4637
L1524:
%t4638 = call i64 @rt_sb_new()
%t4639 = icmp ne i64 %p0, 0
br label %LSL4640
LSL4640:
br i1 %t4639, label %LSR4640, label %LSJ4640
LSR4640:
%t4641 = call i64 @ld8(i64 %p0)
%t4642 = icmp ne i64 %t4641, 0
br label %LSJ4640
LSJ4640:
%t4643 = phi i1 [ false, %LSL4640 ], [ %t4642, %LSR4640 ]
%t4644 = icmp ne i64 %p1, 0
br label %LSL4645
LSL4645:
br i1 %t4644, label %LSR4645, label %LSJ4645
LSR4645:
%t4646 = call i64 @ld8(i64 %p1)
%t4647 = icmp ne i64 %t4646, 0
br label %LSJ4645
LSJ4645:
%t4648 = phi i1 [ false, %LSL4645 ], [ %t4647, %LSR4645 ]
%t4650 = ptrtoint ptr @.s4649 to i64
%t4651 = call i64 @sb_lit(i64 %t4638, i64 %t4650)
br i1 %t4648, label %L1528, label %L1529
L1528:
%t4653 = ptrtoint ptr @.s4652 to i64
%t4654 = call i64 @sb_lit(i64 %t4638, i64 %t4653)
br i1 %t4643, label %L1531, label %L1532
L1531:
br label %L1533
L1532:
%t4656 = ptrtoint ptr @.s4655 to i64
br label %L1533
L1533:
%t4657 = phi i64 [ %p0, %L1531 ], [ %t4656, %L1532 ]
%t4658 = call i64 @sb_lit(i64 %t4638, i64 %t4657)
%t4659 = add i64 %t4654, %t4658
%t4661 = ptrtoint ptr @.s4660 to i64
%t4662 = call i64 @sb_lit(i64 %t4638, i64 %t4661)
%t4663 = add i64 %t4659, %t4662
%t4664 = call i64 @sb_lit(i64 %t4638, i64 %p1)
%t4665 = add i64 %t4663, %t4664
%t4667 = ptrtoint ptr @.s4666 to i64
%t4668 = call i64 @sb_lit(i64 %t4638, i64 %t4667)
%t4669 = add i64 %t4665, %t4668
br label %L1530
L1529:
br label %L1530
L1530:
%t4670 = phi i64 [ %t4669, %L1533 ], [ 0, %L1529 ]
%t4671 = xor i1 %t4648, true
br label %LSL4672
LSL4672:
br i1 %t4671, label %LSR4672, label %LSJ4672
LSR4672:
br label %LSJ4672
LSJ4672:
%t4673 = phi i1 [ false, %LSL4672 ], [ %t4643, %LSR4672 ]
br i1 %t4673, label %L1534, label %L1535
L1534:
%t4675 = ptrtoint ptr @.s4674 to i64
%t4676 = call i64 @sb_lit(i64 %t4638, i64 %t4675)
%t4677 = call i64 @sb_lit(i64 %t4638, i64 %p0)
%t4678 = add i64 %t4676, %t4677
br label %L1536
L1535:
br label %L1536
L1536:
%t4679 = phi i64 [ %t4678, %L1534 ], [ 0, %L1535 ]
%t4681 = ptrtoint ptr @.s4680 to i64
%t4682 = call i64 @sb_lit(i64 %t4638, i64 %t4681)
%t4683 = call i64 @rt_sb_finish(i64 %t4638)
%t4684 = call i64 @c_strlen(i64 %t4683)
%t4685 = call i1 @write_all(i64 2, i64 %t4683, i64 %t4684)
%t4686 = call i64 @c_libc_abort()
ret i64 %t4686
}
define internal i64 @rt_abort_msg(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4687 = call i64 @__mruntime_rt_ctl_resid__rt_fail(i64 %p0, i64 0)
ret i64 %t4687
}
define void @resid_abort(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_abort_msg(i64 %x0i)
ret void
}
define internal i64 @rt_abort_msg_at(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4688 = tail call i64 @__mruntime_rt_ctl_resid__rt_fail(i64 %p0, i64 %p1)
ret i64 %t4688
}
define void @resid_abort_at(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_abort_msg_at(i64 %x0i, i64 %x1i)
ret void
}
define internal i64 @spawn_run(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4689 = add i64 %p0, 16
%t4690 = call i64 @ld64(i64 %p0)
%t4691 = add i64 %p0, 8
%t4692 = call i64 @ld64(i64 %t4691)
%t4693p = inttoptr i64 %t4690 to ptr
%t4693 = call i64 %t4693p(i64 %t4692, i64 0)
%t4694 = call i64 @st64(i64 %t4689, i64 %t4693)
ret i64 %t4694
}
define internal i64 @spawn_entry(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4695 = ptrtoint ptr @spawn_run to i64
%t4696 = call i1 @under_catch(i64 %t4695, i64 %p0)
%t4697 = xor i1 %t4696, true
br i1 %t4697, label %L1537, label %L1539
L1537:
%t4698 = add i64 %p0, 16
%t4699 = tail call i64 @ld64(i64 %t4698)
ret i64 %t4699
L1539:
%t4700 = call i64 @__mruntime_rt_ctl_resid__catch_msg()
%t4701 = call i64 @ld64(i64 %t4700)
%t4702 = call i64 @xmalloc(i64 8)
%t4703 = icmp ne i64 %t4701, 0
br i1 %t4703, label %L1540, label %L1541
L1540:
br label %L1542
L1541:
%t4705 = ptrtoint ptr @.s4704 to i64
br label %L1542
L1542:
%t4706 = phi i64 [ %t4701, %L1540 ], [ %t4705, %L1541 ]
%t4707 = call i64 @cstr_dup(i64 %t4706)
%t4708 = call i64 @st64(i64 %t4702, i64 %t4707)
%t4709p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.spawn_slot)
%t4709 = ptrtoint ptr %t4709p to i64
%t4710 = call i64 @st64(i64 %t4709, i64 %t4702)
%t4712 = ptrtoint ptr @.s4711 to i64
%t4713 = call i64 @c_box_new(i64 2, i64 1, i64 %t4709, i64 %t4712)
ret i64 %t4713
}
define internal i64 @rt_spawn(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4714 = call i64 @xmalloc(i64 24)
%t4715 = call i64 @st64(i64 %t4714, i64 %p0)
%t4716 = add i64 %t4714, 8
%t4717 = call i64 @st64(i64 %t4716, i64 %p1)
%t4718 = add i64 %t4714, 16
%t4719 = call i64 @st64(i64 %t4718, i64 0)
%t4720 = call i64 @xmalloc(i64 16)
%t4721 = ptrtoint ptr @spawn_entry to i64
%t4722 = call i64 @c_pthread_create(i64 %t4720, i64 0, i64 %t4721, i64 %t4714)
%t4723 = icmp ne i64 %t4722, 0
br i1 %t4723, label %L1543, label %L1545
L1543:
%t4724 = call i64 @c_free(i64 %t4714)
%t4725 = mul nsw i64 %t4724, 0
ret i64 %t4725
L1545:
%t4726p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.spawn_ret)
%t4726 = ptrtoint ptr %t4726p to i64
%t4727 = call i64 @ld64(i64 %t4720)
%t4728 = call i64 @c_pthread_join(i64 %t4727, i64 %t4726)
%t4729 = call i64 @c_free(i64 %t4714)
%t4730 = call i64 @c_free(i64 %t4720)
%t4731 = add i64 %t4729, %t4730
%t4732 = call i64 @ld64(i64 %t4726)
ret i64 %t4732
}
define ptr @resid_spawn(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_spawn(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_ok_box(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4733p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.spawn_slot)
%t4733 = ptrtoint ptr %t4733p to i64
%t4734 = call i64 @st64(i64 %t4733, i64 %p0)
%t4736 = ptrtoint ptr @.s4735 to i64
%t4737 = call i64 @c_box_new(i64 1, i64 1, i64 %t4733, i64 %t4736)
ret i64 %t4737
}
define ptr @resid_ok_box(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_ok_box(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_ctl_resid__ts() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4738p = getelementptr i8, ptr @rtg.rt_test, i64 0
%t4738 = ptrtoint ptr %t4738p to i64
ret i64 %t4738
}
define internal i64 @__mruntime_rt_ctl_resid__tget(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4739 = call i64 @__mruntime_rt_ctl_resid__ts()
%t4740 = mul i64 %p0, 8
%t4741 = add i64 %t4739, %t4740
%t4742 = tail call i64 @ld64(i64 %t4741)
ret i64 %t4742
}
define internal i64 @__mruntime_rt_ctl_resid__tset(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4743 = call i64 @__mruntime_rt_ctl_resid__ts()
%t4744 = mul i64 %p0, 8
%t4745 = add i64 %t4743, %t4744
%t4746 = tail call i64 @st64(i64 %t4745, i64 %p1)
ret i64 %t4746
}
define internal i64 @__mruntime_rt_ctl_resid__fail_buf() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4747p = getelementptr i8, ptr @rtg.rt_test_fail, i64 0
%t4747 = ptrtoint ptr %t4747p to i64
ret i64 %t4747
}
define internal i64 @__mruntime_rt_ctl_resid__cstr_copy_cap(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4748 = call i64 @c_strlen(i64 %p1)
%t4749 = sub i64 %p2, 1
%t4750 = icmp slt i64 %t4748, %t4749
br i1 %t4750, label %L1546, label %L1547
L1546:
br label %L1548
L1547:
br label %L1548
L1548:
%t4751 = phi i64 [ %t4748, %L1546 ], [ %t4749, %L1547 ]
%t4752 = call i64 @mcopy(i64 %p0, i64 %p1, i64 %t4751)
%t4753 = add i64 %p0, %t4751
%t4754 = call i64 @st8(i64 %t4753, i64 0)
ret i64 %t4754
}
define internal i1 @__mruntime_rt_ctl_resid__fmt_read() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4755p = getelementptr i8, ptr @rtg.rt_test_fmt_read, i64 0
%t4755 = ptrtoint ptr %t4755p to i64
%t4756 = call i64 @ld8(i64 %t4755)
%t4757 = icmp ne i64 %t4756, 0
ret i1 %t4757
}
define internal i64 @__mruntime_rt_ctl_resid__fmt_init() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4758 = call i1 @__mruntime_rt_ctl_resid__fmt_read()
br i1 %t4758, label %L1549, label %L1551
L1549:
%t4759 = call i64 @__mruntime_rt_ctl_resid__tget(i64 6)
ret i64 %t4759
L1551:
%t4761 = ptrtoint ptr @.s4760 to i64
%t4762 = call i64 @c_getenv(i64 %t4761)
%t4763 = icmp ne i64 %t4762, 0
br label %LSL4764
LSL4764:
br i1 %t4763, label %LSR4764, label %LSJ4764
LSR4764:
%t4766 = ptrtoint ptr @.s4765 to i64
%t4767 = call i64 @c_strcmp(i64 %t4762, i64 %t4766)
%t4768 = icmp eq i64 %t4767, 0
br label %LSJ4764
LSJ4764:
%t4769 = phi i1 [ false, %LSL4764 ], [ %t4768, %LSR4764 ]
br i1 %t4769, label %L1552, label %L1553
L1552:
br label %L1554
L1553:
%t4770 = icmp ne i64 %t4762, 0
br label %LSL4771
LSL4771:
br i1 %t4770, label %LSR4771, label %LSJ4771
LSR4771:
%t4773 = ptrtoint ptr @.s4772 to i64
%t4774 = call i64 @c_strcmp(i64 %t4762, i64 %t4773)
%t4775 = icmp eq i64 %t4774, 0
br label %LSJ4771
LSJ4771:
%t4776 = phi i1 [ false, %LSL4771 ], [ %t4775, %LSR4771 ]
br i1 %t4776, label %L1555, label %L1556
L1555:
br label %L1557
L1556:
br label %L1557
L1557:
%t4777 = phi i64 [ 2, %L1555 ], [ 0, %L1556 ]
br label %L1554
L1554:
%t4778 = phi i64 [ 1, %L1552 ], [ %t4777, %L1557 ]
%t4779p = getelementptr i8, ptr @rtg.rt_test_fmt_read, i64 0
%t4779 = ptrtoint ptr %t4779p to i64
%t4780 = call i64 @st8(i64 %t4779, i64 1)
%t4781 = call i64 @__mruntime_rt_ctl_resid__tset(i64 7, i64 1)
%t4782 = call i64 @__mruntime_rt_ctl_resid__tset(i64 6, i64 %t4778)
%t4783 = mul nsw i64 %t4782, 0
%t4784 = add nsw i64 %t4783, %t4778
ret i64 %t4784
}
define internal i64 @__mruntime_rt_ctl_resid__out_sb(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4785 = call i64 @rt_sb_finish(i64 %p0)
%t4786 = call i64 @c_strlen(i64 %t4785)
%t4787 = call i1 @write_all(i64 1, i64 %t4785, i64 %t4786)
%t4788 = tail call i64 @c_free(i64 %t4785)
ret i64 %t4788
}
define internal i64 @__mruntime_rt_ctl_resid__sb_ms(i64 %p0, double %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4789p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.test_ms)
%t4789 = ptrtoint ptr %t4789p to i64
%t4790 = call i64 @c_strfromd(i64 %t4789, i64 64, i64 %p2, double %p1)
%t4791 = call i64 @sb_bytes(i64 %p0, i64 %t4789, i64 %t4790)
ret i64 %t4791
}
define internal i64 @__mruntime_rt_ctl_resid__module_name() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4792 = call i64 @__mruntime_rt_ctl_resid__tget(i64 8)
%t4793 = icmp eq i64 %t4792, 0
br i1 %t4793, label %L1558, label %L1559
L1558:
%t4795 = ptrtoint ptr @.s4794 to i64
br label %L1560
L1559:
%t4796 = call i64 @__mruntime_rt_ctl_resid__tget(i64 8)
br label %L1560
L1560:
%t4797 = phi i64 [ %t4795, %L1558 ], [ %t4796, %L1559 ]
ret i64 %t4797
}
define internal i64 @rt_expect_fail(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4798 = call i64 @rt_sb_new()
%t4800 = ptrtoint ptr @.s4799 to i64
%t4801 = call i64 @sb_lit(i64 %t4798, i64 %t4800)
%t4802 = icmp ne i64 %p0, 0
br i1 %t4802, label %L1561, label %L1562
L1561:
br label %L1563
L1562:
%t4804 = ptrtoint ptr @.s4803 to i64
br label %L1563
L1563:
%t4805 = phi i64 [ %p0, %L1561 ], [ %t4804, %L1562 ]
%t4806 = call i64 @sb_lit(i64 %t4798, i64 %t4805)
%t4807 = icmp ne i64 %p1, 0
br i1 %t4807, label %L1564, label %L1565
L1564:
%t4809 = ptrtoint ptr @.s4808 to i64
%t4810 = call i64 @sb_lit(i64 %t4798, i64 %t4809)
%t4811 = call i64 @sb_lit(i64 %t4798, i64 %p1)
%t4812 = add i64 %t4810, %t4811
br label %L1566
L1565:
br label %L1566
L1566:
%t4813 = phi i64 [ %t4812, %L1564 ], [ 0, %L1565 ]
%t4814 = icmp ne i64 %p1, 0
br label %LSL4815
LSL4815:
br i1 %t4814, label %LSR4815, label %LSJ4815
LSR4815:
%t4816 = icmp ne i64 %p2, 0
br label %LSJ4815
LSJ4815:
%t4817 = phi i1 [ false, %LSL4815 ], [ %t4816, %LSR4815 ]
br i1 %t4817, label %L1567, label %L1568
L1567:
%t4819 = ptrtoint ptr @.s4818 to i64
%t4820 = call i64 @sb_lit(i64 %t4798, i64 %t4819)
%t4821 = call i64 @sb_lit(i64 %t4798, i64 %p2)
%t4822 = add i64 %t4820, %t4821
br label %L1569
L1568:
br label %L1569
L1569:
%t4823 = phi i64 [ %t4822, %L1567 ], [ 0, %L1568 ]
%t4824 = call i64 @rt_sb_finish(i64 %t4798)
%t4825p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.expect_buf)
%t4825 = ptrtoint ptr %t4825p to i64
%t4826 = call i64 @__mruntime_rt_ctl_resid__cstr_copy_cap(i64 %t4825, i64 %t4824, i64 1024)
%t4827 = call i64 @__mruntime_rt_ctl_resid__tget(i64 0)
%t4828 = icmp ne i64 %t4827, 0
br i1 %t4828, label %L1570, label %L1571
L1570:
%t4829 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t4830 = call i64 @__mruntime_rt_ctl_resid__cstr_copy_cap(i64 %t4829, i64 %t4825, i64 1024)
br label %L1572
L1571:
br label %L1572
L1572:
%t4831 = phi i64 [ %t4830, %L1570 ], [ 0, %L1571 ]
%t4832 = call i64 @__mruntime_rt_ctl_resid__rt_fail(i64 %t4825, i64 0)
ret i64 %t4832
}
define void @resid_expect_fail(ptr %a0, ptr %a1, ptr %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%x2i = ptrtoint ptr %a2 to i64
%r = call i64 @rt_expect_fail(i64 %x0i, i64 %x1i, i64 %x2i)
ret void
}
define internal i64 @rt_expect_throws(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4833 = icmp eq i64 %p0, 0
br label %LSL4834
LSL4834:
br i1 %t4833, label %LSJ4834, label %LSR4834
LSR4834:
%t4835 = call i64 @ld64(i64 %p0)
%t4836 = icmp eq i64 %t4835, 0
br label %LSJ4834
LSJ4834:
%t4837 = phi i1 [ true, %LSL4834 ], [ %t4836, %LSR4834 ]
br i1 %t4837, label %L1573, label %L1575
L1573:
ret i64 0
L1575:
%t4838 = call i64 @xmalloc(i64 1024)
%t4839 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t4840 = call i64 @mcopy(i64 %t4838, i64 %t4839, i64 1024)
%t4841 = call i64 @__mruntime_rt_ctl_resid__tget(i64 0)
%t4842 = call i64 @__mruntime_rt_ctl_resid__catch_msg()
%t4843 = call i64 @ld64(i64 %t4842)
%t4844 = call i64 @__mruntime_rt_ctl_resid__tset(i64 0, i64 1)
%t4845 = call i64 @ld64(i64 %p0)
%t4846 = call i1 @under_catch(i64 %t4845, i64 %p0)
%t4847 = call i64 @__mruntime_rt_ctl_resid__catch_msg()
%t4848 = call i64 @st64(i64 %t4847, i64 %t4843)
%t4849 = call i64 @__mruntime_rt_ctl_resid__tset(i64 0, i64 %t4841)
%t4850 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t4851 = call i64 @mcopy(i64 %t4850, i64 %t4838, i64 1024)
%t4852 = call i64 @c_free(i64 %t4838)
br i1 %t4846, label %L1576, label %L1577
L1576:
br label %L1578
L1577:
br label %L1578
L1578:
%t4853 = phi i64 [ 1, %L1576 ], [ 0, %L1577 ]
ret i64 %t4853
}
define i8 @resid_expect_throws(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_expect_throws(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_test_selected(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4855 = ptrtoint ptr @.s4854 to i64
%t4856 = call i64 @c_getenv(i64 %t4855)
%t4857 = icmp eq i64 %t4856, 0
br label %LSL4858
LSL4858:
br i1 %t4857, label %LSJ4858, label %LSR4858
LSR4858:
%t4859 = call i64 @ld8(i64 %t4856)
%t4860 = icmp eq i64 %t4859, 0
br label %LSJ4858
LSJ4858:
%t4861 = phi i1 [ true, %LSL4858 ], [ %t4860, %LSR4858 ]
br i1 %t4861, label %L1579, label %L1581
L1579:
ret i64 1
L1581:
%t4862 = icmp ne i64 %p0, 0
br i1 %t4862, label %L1582, label %L1583
L1582:
br label %L1584
L1583:
%t4864 = ptrtoint ptr @.s4863 to i64
br label %L1584
L1584:
%t4865 = phi i64 [ %p0, %L1582 ], [ %t4864, %L1583 ]
%t4866 = call i64 @rt_regex_match(i64 %t4856, i64 %t4865)
ret i64 %t4866
}
define i8 @resid_test_selected(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_test_selected(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_test_plan(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4867 = icmp ne i64 %p1, 0
br i1 %t4867, label %L1585, label %L1586
L1585:
br label %L1587
L1586:
%t4869 = ptrtoint ptr @.s4868 to i64
br label %L1587
L1587:
%t4870 = phi i64 [ %p1, %L1585 ], [ %t4869, %L1586 ]
%t4871 = call i64 @__mruntime_rt_ctl_resid__tset(i64 8, i64 %t4870)
%t4872 = call i64 @__mruntime_rt_ctl_resid__fmt_init()
%t4873 = call i64 @rt_sb_new()
%t4874 = icmp eq i64 %t4872, 1
br i1 %t4874, label %L1588, label %L1589
L1588:
%t4876 = ptrtoint ptr @.s4875 to i64
%t4877 = call i64 @sb_lit(i64 %t4873, i64 %t4876)
%t4878 = call i64 @sb_word(i64 %t4873, i64 %p0)
%t4879 = add i64 %t4877, %t4878
%t4881 = ptrtoint ptr @.s4880 to i64
%t4882 = call i64 @sb_lit(i64 %t4873, i64 %t4881)
%t4883 = add i64 %t4879, %t4882
br label %L1590
L1589:
br label %L1590
L1590:
%t4884 = phi i64 [ %t4883, %L1588 ], [ 0, %L1589 ]
%t4885 = icmp eq i64 %t4872, 2
br i1 %t4885, label %L1591, label %L1592
L1591:
%t4887 = ptrtoint ptr @.s4886 to i64
%t4888 = call i64 @sb_lit(i64 %t4873, i64 %t4887)
%t4889 = call i64 @__mruntime_rt_ctl_resid__module_name()
%t4890 = call i64 @sb_lit(i64 %t4873, i64 %t4889)
%t4891 = add i64 %t4888, %t4890
%t4893 = ptrtoint ptr @.s4892 to i64
%t4894 = call i64 @sb_lit(i64 %t4873, i64 %t4893)
%t4895 = add i64 %t4891, %t4894
br label %L1593
L1592:
br label %L1593
L1593:
%t4896 = phi i64 [ %t4895, %L1591 ], [ 0, %L1592 ]
%t4897 = icmp eq i64 %t4872, 0
br i1 %t4897, label %L1594, label %L1595
L1594:
%t4899 = ptrtoint ptr @.s4898 to i64
%t4900 = call i64 @sb_lit(i64 %t4873, i64 %t4899)
%t4901 = call i64 @__mruntime_rt_ctl_resid__module_name()
%t4902 = call i64 @sb_lit(i64 %t4873, i64 %t4901)
%t4903 = add i64 %t4900, %t4902
%t4905 = ptrtoint ptr @.s4904 to i64
%t4906 = call i64 @sb_lit(i64 %t4873, i64 %t4905)
%t4907 = add i64 %t4903, %t4906
br label %L1596
L1595:
br label %L1596
L1596:
%t4908 = phi i64 [ %t4907, %L1594 ], [ 0, %L1595 ]
%t4909 = call i64 @__mruntime_rt_ctl_resid__out_sb(i64 %t4873)
ret i64 1
}
define i8 @resid_test_plan(i64 %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_test_plan(i64 %a0, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @__mruntime_rt_ctl_resid__sb_lines(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4923, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t4910 = call i64 @ld8(i64 %p1)
%t4911 = icmp eq i64 %t4910, 0
br i1 %t4911, label %L1597, label %L1599
L1597:
ret i64 0
L1599:
%t4912 = call i64 @c_strchr(i64 %p1, i64 10)
%t4913 = icmp eq i64 %t4912, 0
br i1 %t4913, label %L1600, label %L1601
L1600:
%t4914 = call i64 @c_strlen(i64 %p1)
br label %L1602
L1601:
%t4915 = sub i64 %t4912, %p1
br label %L1602
L1602:
%t4916 = phi i64 [ %t4914, %L1600 ], [ %t4915, %L1601 ]
%t4917 = call i64 @sb_lit(i64 %p0, i64 %p2)
%t4918 = call i64 @sb_bytes(i64 %p0, i64 %p1, i64 %t4916)
%t4920 = ptrtoint ptr @.s4919 to i64
%t4921 = call i64 @sb_lit(i64 %p0, i64 %t4920)
%t4922 = icmp eq i64 %t4912, 0
br i1 %t4922, label %L1603, label %L1605
L1603:
ret i64 0
L1605:
%t4923 = add i64 %t4912, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_ctl_resid__test_report(i64 %p0, i1 %p1, i1 %p2, double %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4925 = call i64 @__mruntime_rt_ctl_resid__fmt_init()
%t4926 = call i64 @rt_sb_new()
%t4927 = icmp eq i64 %t4925, 1
br i1 %t4927, label %L1606, label %L1607
L1606:
%t4928 = call i64 @__mruntime_rt_ctl_resid__report_tap(i64 %t4926, i64 %p0, i1 %p1, i1 %p2)
br label %L1608
L1607:
%t4929 = icmp eq i64 %t4925, 2
br i1 %t4929, label %L1609, label %L1610
L1609:
%t4930 = call i64 @__mruntime_rt_ctl_resid__report_json(i64 %t4926, i64 %p0, i1 %p1, i1 %p2, double %p3)
br label %L1611
L1610:
%t4931 = call i64 @__mruntime_rt_ctl_resid__report_pretty(i64 %t4926, i64 %p0, i1 %p1, i1 %p2, double %p3)
br label %L1611
L1611:
%t4932 = phi i64 [ %t4930, %L1609 ], [ %t4931, %L1610 ]
br label %L1608
L1608:
%t4933 = phi i64 [ %t4928, %L1606 ], [ %t4932, %L1611 ]
%t4934 = call i64 @__mruntime_rt_ctl_resid__out_sb(i64 %t4926)
ret i64 %t4934
}
define internal i64 @__mruntime_rt_ctl_resid__report_tap(i64 %p0, i64 %p1, i1 %p2, i1 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %LSL4935
LSL4935:
br i1 %p2, label %LSR4935, label %LSJ4935
LSR4935:
%t4936 = xor i1 %p3, true
br label %LSJ4935
LSJ4935:
%t4937 = phi i1 [ false, %LSL4935 ], [ %t4936, %LSR4935 ]
br i1 %t4937, label %L1612, label %L1613
L1612:
%t4939 = ptrtoint ptr @.s4938 to i64
br label %L1614
L1613:
%t4941 = ptrtoint ptr @.s4940 to i64
br label %L1614
L1614:
%t4942 = phi i64 [ %t4939, %L1612 ], [ %t4941, %L1613 ]
%t4943 = call i64 @sb_lit(i64 %p0, i64 %t4942)
%t4944 = call i64 @__mruntime_rt_ctl_resid__tget(i64 4)
%t4945 = call i64 @sb_word(i64 %p0, i64 %t4944)
%t4947 = ptrtoint ptr @.s4946 to i64
%t4948 = call i64 @sb_lit(i64 %p0, i64 %t4947)
%t4949 = add i64 %t4945, %t4948
%t4950 = call i64 @__mruntime_rt_ctl_resid__module_name()
%t4951 = call i64 @sb_lit(i64 %p0, i64 %t4950)
%t4952 = add i64 %t4949, %t4951
%t4954 = ptrtoint ptr @.s4953 to i64
%t4955 = call i64 @sb_lit(i64 %p0, i64 %t4954)
%t4956 = add i64 %t4952, %t4955
%t4957 = call i64 @sb_lit(i64 %p0, i64 %p1)
%t4958 = add i64 %t4956, %t4957
br i1 %p3, label %L1615, label %L1617
L1615:
%t4960 = ptrtoint ptr @.s4959 to i64
%t4961 = call i64 @sb_lit(i64 %p0, i64 %t4960)
ret i64 %t4961
L1617:
%t4963 = ptrtoint ptr @.s4962 to i64
%t4964 = call i64 @sb_lit(i64 %p0, i64 %t4963)
%t4965 = xor i1 %p2, true
br i1 %t4965, label %L1618, label %L1620
L1618:
ret i64 0
L1620:
%t4967 = ptrtoint ptr @.s4966 to i64
%t4968 = call i64 @sb_lit(i64 %p0, i64 %t4967)
%t4969 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t4971 = ptrtoint ptr @.s4970 to i64
%t4972 = call i64 @__mruntime_rt_ctl_resid__sb_lines(i64 %p0, i64 %t4969, i64 %t4971)
%t4974 = ptrtoint ptr @.s4973 to i64
%t4975 = call i64 @sb_lit(i64 %p0, i64 %t4974)
ret i64 %t4975
}
define internal i64 @__mruntime_rt_ctl_resid__report_json(i64 %p0, i64 %p1, i1 %p2, i1 %p3, double %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4976 = call i64 @__mruntime_rt_ctl_resid__tget(i64 7)
%t4977 = icmp ne i64 %t4976, 0
br i1 %t4977, label %L1621, label %L1622
L1621:
br label %L1623
L1622:
%t4979 = ptrtoint ptr @.s4978 to i64
%t4980 = call i64 @sb_lit(i64 %p0, i64 %t4979)
br label %L1623
L1623:
%t4981 = phi i64 [ 0, %L1621 ], [ %t4980, %L1622 ]
%t4983 = ptrtoint ptr @.s4982 to i64
%t4984 = call i64 @sb_lit(i64 %p0, i64 %t4983)
%t4985 = call i64 @sb_lit(i64 %p0, i64 %p1)
%t4986 = add i64 %t4984, %t4985
%t4988 = ptrtoint ptr @.s4987 to i64
%t4989 = call i64 @sb_lit(i64 %p0, i64 %t4988)
%t4990 = add i64 %t4986, %t4989
br i1 %p3, label %L1624, label %L1625
L1624:
%t4992 = ptrtoint ptr @.s4991 to i64
br label %L1626
L1625:
br i1 %p2, label %L1627, label %L1628
L1627:
%t4994 = ptrtoint ptr @.s4993 to i64
br label %L1629
L1628:
%t4996 = ptrtoint ptr @.s4995 to i64
br label %L1629
L1629:
%t4997 = phi i64 [ %t4994, %L1627 ], [ %t4996, %L1628 ]
br label %L1626
L1626:
%t4998 = phi i64 [ %t4992, %L1624 ], [ %t4997, %L1629 ]
%t4999 = call i64 @sb_lit(i64 %p0, i64 %t4998)
%t5001 = ptrtoint ptr @.s5000 to i64
%t5002 = call i64 @sb_lit(i64 %p0, i64 %t5001)
%t5004 = ptrtoint ptr @.s5003 to i64
%t5005 = call i64 @__mruntime_rt_ctl_resid__sb_ms(i64 %p0, double %p4, i64 %t5004)
%t5006 = add i64 %t5002, %t5005
%t5008 = ptrtoint ptr @.s5007 to i64
%t5009 = call i64 @sb_lit(i64 %p0, i64 %t5008)
%t5010 = add i64 %t5006, %t5009
%t5011 = call i64 @__mruntime_rt_ctl_resid__tset(i64 7, i64 0)
ret i64 %t5011
}
define internal i64 @__mruntime_rt_ctl_resid__report_pretty(i64 %p0, i64 %p1, i1 %p2, i1 %p3, double %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br i1 %p3, label %L1630, label %L1632
L1630:
%t5013 = ptrtoint ptr @.s5012 to i64
%t5014 = call i64 @sb_lit(i64 %p0, i64 %t5013)
%t5015 = call i64 @sb_lit(i64 %p0, i64 %p1)
%t5016 = add i64 %t5014, %t5015
%t5018 = ptrtoint ptr @.s5017 to i64
%t5019 = call i64 @sb_lit(i64 %p0, i64 %t5018)
%t5020 = add i64 %t5016, %t5019
ret i64 %t5020
L1632:
br i1 %p2, label %L1633, label %L1634
L1633:
%t5022 = ptrtoint ptr @.s5021 to i64
br label %L1635
L1634:
%t5024 = ptrtoint ptr @.s5023 to i64
br label %L1635
L1635:
%t5025 = phi i64 [ %t5022, %L1633 ], [ %t5024, %L1634 ]
%t5026 = call i64 @sb_lit(i64 %p0, i64 %t5025)
%t5027 = call i64 @sb_lit(i64 %p0, i64 %p1)
%t5029 = ptrtoint ptr @.s5028 to i64
%t5030 = call i64 @sb_lit(i64 %p0, i64 %t5029)
%t5031 = add i64 %t5027, %t5030
%t5033 = ptrtoint ptr @.s5032 to i64
%t5034 = call i64 @__mruntime_rt_ctl_resid__sb_ms(i64 %p0, double %p4, i64 %t5033)
%t5035 = add i64 %t5031, %t5034
%t5037 = ptrtoint ptr @.s5036 to i64
%t5038 = call i64 @sb_lit(i64 %p0, i64 %t5037)
%t5039 = add i64 %t5035, %t5038
br i1 %p2, label %L1636, label %L1637
L1636:
%t5040 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t5042 = ptrtoint ptr @.s5041 to i64
%t5043 = call i64 @__mruntime_rt_ctl_resid__sb_lines(i64 %p0, i64 %t5040, i64 %t5042)
br label %L1638
L1637:
br label %L1638
L1638:
%t5044 = phi i64 [ %t5043, %L1636 ], [ 0, %L1637 ]
ret i64 %t5044
}
define internal double @__mruntime_rt_ctl_resid__now_ms() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5045p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.test_clock)
%t5045 = ptrtoint ptr %t5045p to i64
%t5046 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 228, i64 1, i64 %t5045, i64 0, i64 0, i64 0, i64 0)
%t5047 = call i64 @ld64(i64 %t5045)
%t5048 = sitofp i64 %t5047 to double
%t5049 = fmul double %t5048, 1000.0
%t5050 = add i64 %t5045, 8
%t5051 = call i64 @ld64(i64 %t5050)
%t5052 = sitofp i64 %t5051 to double
%t5053 = fdiv double %t5052, 1000000.0
%t5054 = fadd double %t5049, %t5053
ret double %t5054
}
define internal i64 @rt_test_run(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5055 = icmp ne i64 %p1, 0
br i1 %t5055, label %L1639, label %L1640
L1639:
br label %L1641
L1640:
%t5057 = ptrtoint ptr @.s5056 to i64
br label %L1641
L1641:
%t5058 = phi i64 [ %p1, %L1639 ], [ %t5057, %L1640 ]
%t5059 = call i64 @__mruntime_rt_ctl_resid__tget(i64 4)
%t5060 = add i64 %t5059, 1
%t5061 = call i64 @__mruntime_rt_ctl_resid__tset(i64 4, i64 %t5060)
%t5062 = call i64 @__mruntime_rt_ctl_resid__tget(i64 10)
%t5063 = call i64 @__mruntime_rt_ctl_resid__tget(i64 9)
%t5064 = call i64 @__mruntime_rt_ctl_resid__tset(i64 10, i64 0)
%t5065 = call i64 @__mruntime_rt_ctl_resid__tset(i64 9, i64 0)
%t5066 = call i64 @rt_test_selected(i64 %t5058)
%t5067 = icmp eq i64 %t5066, 0
br i1 %t5067, label %L1642, label %L1644
L1642:
%t5068 = call i64 @__mruntime_rt_ctl_resid__tget(i64 3)
%t5069 = add i64 %t5068, 1
%t5070 = call i64 @__mruntime_rt_ctl_resid__tset(i64 3, i64 %t5069)
%t5071 = call i64 @__mruntime_rt_ctl_resid__test_report(i64 %t5058, i1 false, i1 true, double 0.0)
%t5072 = mul nsw i64 %t5071, 0
ret i64 %t5072
L1644:
%t5073 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t5074 = call i64 @st8(i64 %t5073, i64 0)
%t5075 = call i64 @__mruntime_rt_ctl_resid__tset(i64 0, i64 1)
%t5076 = call i64 @__mruntime_rt_ctl_resid__catch_msg()
%t5077 = call i64 @ld64(i64 %t5076)
%t5078 = call double @__mruntime_rt_ctl_resid__now_ms()
%t5079 = icmp ne i64 %p0, 0
br i1 %t5079, label %L1645, label %L1646
L1645:
br label %L1647
L1646:
br label %L1647
L1647:
%t5080 = phi i64 [ %p0, %L1645 ], [ %t5062, %L1646 ]
%t5081 = icmp ne i64 %t5080, 0
br label %LSL5082
LSL5082:
br i1 %t5081, label %LSR5082, label %LSJ5082
LSR5082:
%t5083 = icmp ne i64 %p0, 0
br i1 %t5083, label %L1648, label %L1649
L1648:
br label %L1650
L1649:
br label %L1650
L1650:
%t5084 = phi i64 [ 0, %L1648 ], [ %t5063, %L1649 ]
%t5085 = call i1 @under_catch(i64 %t5080, i64 %t5084)
br label %LSJ5082
LSJ5082:
%t5086 = phi i1 [ false, %LSL5082 ], [ %t5085, %L1650 ]
%t5087 = call i64 @__mruntime_rt_ctl_resid__catch_msg()
%t5088 = call i64 @ld64(i64 %t5087)
br label %LSL5089
LSL5089:
br i1 %t5086, label %LSR5089, label %LSJ5089
LSR5089:
%t5090 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t5091 = call i64 @ld8(i64 %t5090)
%t5092 = icmp eq i64 %t5091, 0
br label %LSJ5089
LSJ5089:
%t5093 = phi i1 [ false, %LSL5089 ], [ %t5092, %LSR5089 ]
br i1 %t5093, label %L1651, label %L1652
L1651:
%t5094 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t5095 = icmp ne i64 %t5088, 0
br i1 %t5095, label %L1654, label %L1655
L1654:
br label %L1656
L1655:
%t5097 = ptrtoint ptr @.s5096 to i64
br label %L1656
L1656:
%t5098 = phi i64 [ %t5088, %L1654 ], [ %t5097, %L1655 ]
%t5099 = call i64 @__mruntime_rt_ctl_resid__cstr_copy_cap(i64 %t5094, i64 %t5098, i64 1024)
br label %L1653
L1652:
br label %L1653
L1653:
%t5100 = phi i64 [ %t5099, %L1656 ], [ 0, %L1652 ]
%t5101 = call i64 @__mruntime_rt_ctl_resid__catch_msg()
%t5102 = call i64 @st64(i64 %t5101, i64 %t5077)
%t5103 = call i64 @__mruntime_rt_ctl_resid__tset(i64 0, i64 0)
%t5104 = call double @__mruntime_rt_ctl_resid__now_ms()
%t5105 = fsub double %t5104, %t5078
%t5106 = call i64 @__mruntime_rt_ctl_resid__tget(i64 5)
%t5107 = bitcast i64 %t5106 to double
%t5108 = fadd double %t5107, %t5105
%t5109 = bitcast double %t5108 to i64
%t5110 = call i64 @__mruntime_rt_ctl_resid__tset(i64 5, i64 %t5109)
br i1 %t5086, label %L1657, label %L1658
L1657:
%t5111 = call i64 @__mruntime_rt_ctl_resid__tget(i64 2)
%t5112 = add i64 %t5111, 1
%t5113 = call i64 @__mruntime_rt_ctl_resid__tset(i64 2, i64 %t5112)
br label %L1659
L1658:
%t5114 = call i64 @__mruntime_rt_ctl_resid__tget(i64 1)
%t5115 = add i64 %t5114, 1
%t5116 = call i64 @__mruntime_rt_ctl_resid__tset(i64 1, i64 %t5115)
br label %L1659
L1659:
%t5117 = phi i64 [ %t5113, %L1657 ], [ %t5116, %L1658 ]
%t5118 = call i64 @__mruntime_rt_ctl_resid__test_report(i64 %t5058, i1 %t5086, i1 false, double %t5105)
br i1 %t5086, label %L1660, label %L1661
L1660:
br label %L1662
L1661:
br label %L1662
L1662:
%t5119 = phi i64 [ 1, %L1660 ], [ 0, %L1661 ]
ret i64 %t5119
}
define i64 @resid_test_run(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_test_run(i64 %x0i, i64 %x1i)
ret i64 %r
}
define internal i64 @rt_test_run_closure(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5120 = icmp eq i64 %p0, 0
br label %LSL5121
LSL5121:
br i1 %t5120, label %LSJ5121, label %LSR5121
LSR5121:
%t5122 = call i64 @ld64(i64 %p0)
%t5123 = icmp eq i64 %t5122, 0
br label %LSJ5121
LSJ5121:
%t5124 = phi i1 [ true, %LSL5121 ], [ %t5123, %LSR5121 ]
br i1 %t5124, label %L1663, label %L1665
L1663:
ret i64 1
L1665:
%t5125 = call i64 @__mruntime_rt_ctl_resid__tset(i64 9, i64 %p0)
%t5126 = call i64 @ld64(i64 %p0)
%t5127 = call i64 @__mruntime_rt_ctl_resid__tset(i64 10, i64 %t5126)
%t5128 = tail call i64 @rt_test_run(i64 0, i64 %p1)
ret i64 %t5128
}
define i64 @resid_test_run_closure(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_test_run_closure(i64 %x0i, i64 %x1i)
ret i64 %r
}
define internal i64 @rt_test_summary() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5129 = call i64 @__mruntime_rt_ctl_resid__fmt_init()
%t5130 = call i64 @__mruntime_rt_ctl_resid__tget(i64 5)
%t5131 = bitcast i64 %t5130 to double
%t5132 = call i64 @rt_sb_new()
%t5133 = icmp eq i64 %t5129, 2
br i1 %t5133, label %L1666, label %L1667
L1666:
%t5135 = ptrtoint ptr @.s5134 to i64
%t5136 = call i64 @sb_lit(i64 %t5132, i64 %t5135)
%t5137 = call i64 @__mruntime_rt_ctl_resid__tget(i64 1)
%t5138 = call i64 @sb_word(i64 %t5132, i64 %t5137)
%t5139 = add i64 %t5136, %t5138
%t5141 = ptrtoint ptr @.s5140 to i64
%t5142 = call i64 @sb_lit(i64 %t5132, i64 %t5141)
%t5143 = add i64 %t5139, %t5142
%t5144 = call i64 @__mruntime_rt_ctl_resid__tget(i64 2)
%t5145 = call i64 @sb_word(i64 %t5132, i64 %t5144)
%t5146 = add i64 %t5143, %t5145
%t5148 = ptrtoint ptr @.s5147 to i64
%t5149 = call i64 @sb_lit(i64 %t5132, i64 %t5148)
%t5150 = add i64 %t5146, %t5149
%t5151 = call i64 @__mruntime_rt_ctl_resid__tget(i64 3)
%t5152 = call i64 @sb_word(i64 %t5132, i64 %t5151)
%t5153 = add i64 %t5150, %t5152
%t5155 = ptrtoint ptr @.s5154 to i64
%t5156 = call i64 @sb_lit(i64 %t5132, i64 %t5155)
%t5157 = add i64 %t5153, %t5156
%t5159 = ptrtoint ptr @.s5158 to i64
%t5160 = call i64 @__mruntime_rt_ctl_resid__sb_ms(i64 %t5132, double %t5131, i64 %t5159)
%t5161 = add i64 %t5157, %t5160
%t5163 = ptrtoint ptr @.s5162 to i64
%t5164 = call i64 @sb_lit(i64 %t5132, i64 %t5163)
%t5165 = add i64 %t5161, %t5164
br label %L1668
L1667:
br label %L1668
L1668:
%t5166 = phi i64 [ %t5165, %L1666 ], [ 0, %L1667 ]
%t5167 = icmp eq i64 %t5129, 0
br i1 %t5167, label %L1669, label %L1670
L1669:
%t5168 = call i64 @__mruntime_rt_ctl_resid__summary_pretty(i64 %t5132, double %t5131)
br label %L1671
L1670:
br label %L1671
L1671:
%t5169 = phi i64 [ %t5168, %L1669 ], [ 0, %L1670 ]
%t5170 = call i64 @__mruntime_rt_ctl_resid__out_sb(i64 %t5132)
%t5171 = call i64 @__mruntime_rt_ctl_resid__tget(i64 2)
%t5172 = icmp ne i64 %t5171, 0
br i1 %t5172, label %L1672, label %L1673
L1672:
br label %L1674
L1673:
br label %L1674
L1674:
%t5173 = phi i64 [ 1, %L1672 ], [ 0, %L1673 ]
ret i64 %t5173
}
define i64 @resid_test_summary() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_test_summary()
ret i64 %r
}
define internal i64 @__mruntime_rt_ctl_resid__summary_pretty(i64 %p0, double %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5175 = ptrtoint ptr @.s5174 to i64
%t5176 = call i64 @sb_lit(i64 %p0, i64 %t5175)
%t5177 = call i64 @__mruntime_rt_ctl_resid__tget(i64 2)
%t5178 = call i64 @sb_word(i64 %p0, i64 %t5177)
%t5179 = add i64 %t5176, %t5178
%t5181 = ptrtoint ptr @.s5180 to i64
%t5182 = call i64 @sb_lit(i64 %p0, i64 %t5181)
%t5183 = add i64 %t5179, %t5182
%t5184 = call i64 @__mruntime_rt_ctl_resid__tget(i64 1)
%t5185 = call i64 @sb_word(i64 %p0, i64 %t5184)
%t5186 = add i64 %t5183, %t5185
%t5187 = call i64 @__mruntime_rt_ctl_resid__tget(i64 3)
%t5188 = icmp ne i64 %t5187, 0
br i1 %t5188, label %L1675, label %L1676
L1675:
%t5190 = ptrtoint ptr @.s5189 to i64
%t5191 = call i64 @sb_lit(i64 %p0, i64 %t5190)
%t5192 = call i64 @__mruntime_rt_ctl_resid__tget(i64 3)
%t5193 = call i64 @sb_word(i64 %p0, i64 %t5192)
%t5194 = add i64 %t5191, %t5193
br label %L1677
L1676:
br label %L1677
L1677:
%t5195 = phi i64 [ %t5194, %L1675 ], [ 0, %L1676 ]
%t5197 = ptrtoint ptr @.s5196 to i64
%t5198 = call i64 @sb_lit(i64 %p0, i64 %t5197)
%t5200 = ptrtoint ptr @.s5199 to i64
%t5201 = call i64 @__mruntime_rt_ctl_resid__sb_ms(i64 %p0, double %p1, i64 %t5200)
%t5202 = add i64 %t5198, %t5201
%t5204 = ptrtoint ptr @.s5203 to i64
%t5205 = call i64 @sb_lit(i64 %p0, i64 %t5204)
%t5206 = add i64 %t5202, %t5205
ret i64 %t5206
}
define internal i64 @__mruntime_rt_dec_resid__bb() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5207 = trunc i128 10000000000000000000 to i64
ret i64 %t5207
}
define internal i64 @__mruntime_rt_dec_resid__binv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5208 = trunc i128 15581492618384294730 to i64
ret i64 %t5208
}
define internal i64 @__mruntime_rt_dec_resid__ld_() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 19
}
define internal i64 @__mruntime_rt_dec_resid__max_exp() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 1000000
}
define internal i64 @__mruntime_rt_dec_resid__p10(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5209 = icmp eq i64 %p0, 19
br i1 %t5209, label %L1678, label %L1680
L1678:
%t5210 = call i64 @__mruntime_rt_dec_resid__bb()
ret i64 %t5210
L1680:
%t5211 = ptrtoint ptr @rtt.25383 to i64
%t5212 = mul i64 %p0, 8
%t5213 = add i64 %t5211, %t5212
%t5214 = call i64 @ld64(i64 %t5213)
%t5215 = add i64 %t5214, 0
%t5216 = add i64 %t5215, 0
ret i64 %t5216
}
define internal i64 @__mruntime_rt_dec_resid__lu(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5222 = call i64 @ld64(i64 %p0)
%t5223 = add i64 %t5222, 0
%t5224 = add i64 %t5223, 0
ret i64 %t5224
}
define internal i64 @__mruntime_rt_dec_resid__su(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5230 = add i64 %p1, 0
%t5231 = add i64 %t5230, 0
%t5237 = tail call i64 @st64(i64 %p0, i64 %t5231)
ret i64 %t5237
}
define internal i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5238 = mul i64 %p1, 8
%t5239 = add i64 %p0, %t5238
ret i64 %t5239
}
define internal i64 @sx8(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5240 = shl i64 %p0, 56
%t5241 = ashr i64 %t5240, 56
ret i64 %t5241
}
define internal i64 @__mruntime_rt_dec_resid__dsign(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5242 = call i64 @ld8(i64 %p0)
%t5243 = tail call i64 @sx8(i64 %t5242)
ret i64 %t5243
}
define internal i64 @__mruntime_rt_dec_resid__dprec(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5244 = add i64 %p0, 4
%t5245 = tail call i64 @ld32(i64 %t5244)
ret i64 %t5245
}
define internal i64 @__mruntime_rt_dec_resid__dexp(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5246 = add i64 %p0, 8
%t5247 = call i64 @ld32(i64 %t5246)
%t5248 = tail call i64 @sx32(i64 %t5247)
ret i64 %t5248
}
define internal i64 @dn(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5249 = add i64 %p0, 12
%t5250 = tail call i64 @ld32(i64 %t5249)
ret i64 %t5250
}
define internal i64 @__mruntime_rt_dec_resid__dnd(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5251 = add i64 %p0, 16
%t5252 = tail call i64 @ld32(i64 %t5251)
ret i64 %t5252
}
define internal i64 @__mruntime_rt_dec_resid__dl(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5253 = add i64 %p0, 24
ret i64 %t5253
}
define internal i64 @__mruntime_rt_dec_resid__r2() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5254p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dec_r2)
%t5254 = ptrtoint ptr %t5254p to i64
ret i64 %t5254
}
define internal i64 @__mruntime_rt_dec_resid__div_b(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5255 = sext i64 64 to i128
%t5256 = add i128 %t5255, 0
%t5262 = icmp uge i128 %t5256, 128
%t5263 = add i128 %t5256, 0
%t5264 = lshr i128 %p0, %t5263
%t5265 = select i1 %t5262, i128 0, i128 %t5264
%t5266 = add i128 %t5265, 0
%t5267 = trunc i128 %t5266 to i64
%t5273 = add i128 %p0, 0
%t5274 = trunc i128 %t5273 to i64
%t5280 = call i64 @__mruntime_rt_dec_resid__binv()
%t5281 = zext i64 %t5280 to i128
%t5282 = zext i64 %t5267 to i128
%t5283 = mul i128 %t5281, %t5282
%t5284 = add i128 %t5283, %p0
%t5285 = sext i64 64 to i128
%t5286 = add i128 %t5285, 0
%t5292 = icmp uge i128 %t5286, 128
%t5293 = add i128 %t5286, 0
%t5294 = lshr i128 %t5284, %t5293
%t5295 = select i1 %t5292, i128 0, i128 %t5294
%t5296 = add i128 %t5295, 0
%t5297 = trunc i128 %t5296 to i64
%t5303 = add i64 1, 0
%t5304 = add i64 %t5303, 0
%t5310 = add i64 %t5297, %t5304
%t5311 = add i128 %t5284, 0
%t5312 = trunc i128 %t5311 to i64
%t5318 = call i64 @__mruntime_rt_dec_resid__bb()
%t5319 = mul i64 %t5310, %t5318
%t5320 = sub i64 %t5274, %t5319
%t5321 = icmp ugt i64 %t5320, %t5312
br i1 %t5321, label %L1681, label %L1682
L1681:
%t5322 = add i64 1, 0
%t5323 = add i64 %t5322, 0
%t5329 = sub i64 %t5310, %t5323
br label %L1683
L1682:
br label %L1683
L1683:
%t5330 = phi i64 [ %t5329, %L1681 ], [ %t5310, %L1682 ]
br i1 %t5321, label %L1684, label %L1685
L1684:
%t5331 = call i64 @__mruntime_rt_dec_resid__bb()
%t5332 = add i64 %t5320, %t5331
br label %L1686
L1685:
br label %L1686
L1686:
%t5333 = phi i64 [ %t5332, %L1684 ], [ %t5320, %L1685 ]
%t5334 = call i64 @__mruntime_rt_dec_resid__bb()
%t5335 = icmp uge i64 %t5333, %t5334
br i1 %t5335, label %L1687, label %L1688
L1687:
%t5336 = add i64 1, 0
%t5337 = add i64 %t5336, 0
%t5343 = add i64 %t5330, %t5337
br label %L1689
L1688:
br label %L1689
L1689:
%t5344 = phi i64 [ %t5343, %L1687 ], [ %t5330, %L1688 ]
ret i64 %t5344
}
define internal i64 @__mruntime_rt_dec_resid__ndig64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5345 = call i64 @__mruntime_rt_dec_resid__ndig64_at(i64 %p0, i64 1)
ret i64 %t5345
}
define internal i64 @__mruntime_rt_dec_resid__ndig64_at(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5351, %tco.s0 ]
%t5346 = icmp slt i64 %p1, 20
br label %LSL5347
LSL5347:
br i1 %t5346, label %LSR5347, label %LSJ5347
LSR5347:
%t5348 = call i64 @__mruntime_rt_dec_resid__p10(i64 %p1)
%t5349 = icmp uge i64 %p0, %t5348
br label %LSJ5347
LSJ5347:
%t5350 = phi i1 [ false, %LSL5347 ], [ %t5349, %LSR5347 ]
br i1 %t5350, label %L1690, label %L1692
L1690:
%t5351 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L1692:
ret i64 %p1
}
define internal i64 @__mruntime_rt_dec_resid__ndig(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5353 = icmp eq i64 %p1, 0
br i1 %t5353, label %L1693, label %L1695
L1693:
ret i64 0
L1695:
%t5354 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5355 = sub i64 %p1, 1
%t5356 = mul i64 %t5354, %t5355
%t5357 = sub i64 %p1, 1
%t5358 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t5357)
%t5359 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5358)
%t5360 = call i64 @__mruntime_rt_dec_resid__ndig64(i64 %t5359)
%t5361 = add i64 %t5356, %t5360
ret i64 %t5361
}
define internal i64 @__mruntime_rt_dec_resid__tmp_limbs(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5362 = icmp sgt i64 %p0, 0
br i1 %t5362, label %L1696, label %L1697
L1696:
%t5363 = mul i64 %p0, 8
br label %L1698
L1697:
br label %L1698
L1698:
%t5364 = phi i64 [ %t5363, %L1696 ], [ 8, %L1697 ]
%t5365 = tail call i64 @xmalloc(i64 %t5364)
ret i64 %t5365
}
define internal i64 @__mruntime_rt_dec_resid__dalloc(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5366 = icmp slt i64 %p0, 0
br label %LSL5367
LSL5367:
br i1 %t5366, label %LSJ5367, label %LSR5367
LSR5367:
%t5368 = icmp sgt i64 %p0, 1099511627776
br label %LSJ5367
LSJ5367:
%t5369 = phi i1 [ true, %LSL5367 ], [ %t5368, %LSR5367 ]
br i1 %t5369, label %L1699, label %L1701
L1699:
%t5371 = call i64 @rt_abort(ptr @.s5370)
ret i64 %t5371
L1701:
%t5372 = mul nsw i64 %p0, 8
%t5373 = add nsw i64 24, %t5372
%t5374 = tail call i64 @c_gmalloc(i64 %t5373)
ret i64 %t5374
}
define internal i64 @__mruntime_rt_dec_resid__dzero(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5375 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 0)
%t5376 = call i64 @st8(i64 %t5375, i64 0)
%t5377 = add i64 %t5375, 4
%t5378 = call i64 @st32(i64 %t5377, i64 %p0)
%t5379 = add i64 %t5375, 8
%t5380 = call i64 @st32(i64 %t5379, i64 0)
%t5381 = add i64 %t5375, 12
%t5382 = call i64 @st32(i64 %t5381, i64 0)
%t5383 = add i64 %t5375, 16
%t5384 = call i64 @st32(i64 %t5383, i64 0)
%t5385 = mul nsw i64 %t5384, 0
%t5386 = add nsw i64 %t5385, %t5375
ret i64 %t5386
}
define internal i64 @__mruntime_rt_dec_resid__top(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5401, %tco.s0 ]
%t5387 = icmp sgt i64 %p1, 0
br label %LSL5388
LSL5388:
br i1 %t5387, label %LSR5388, label %LSJ5388
LSR5388:
%t5389 = sub nsw i64 %p1, 1
%t5390 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t5389)
%t5391 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5390)
%t5392 = add i64 0, 0
%t5393 = add i64 %t5392, 0
%t5399 = icmp eq i64 %t5391, %t5393
br label %LSJ5388
LSJ5388:
%t5400 = phi i1 [ false, %LSL5388 ], [ %t5399, %LSR5388 ]
br i1 %t5400, label %L1702, label %L1704
L1702:
%t5401 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L1704:
ret i64 %p1
}
define internal i64 @__mruntime_rt_dec_resid__set_hdr(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5403 = call i64 @st8(i64 %p0, i64 %p1)
%t5404 = add i64 %p0, 4
%t5405 = call i64 @st32(i64 %t5404, i64 %p2)
%t5406 = add i64 %p0, 8
%t5407 = call i64 @st32(i64 %t5406, i64 %p3)
%t5408 = add i64 %p0, 12
%t5409 = call i64 @st32(i64 %t5408, i64 %p4)
%t5410 = add i64 %p0, 16
%t5411 = call i64 @st32(i64 %t5410, i64 %p5)
%t5412 = mul nsw i64 %t5411, 0
%t5413 = add nsw i64 %t5412, %p0
ret i64 %t5413
}
define internal i64 @__mruntime_rt_dec_resid__finish(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5414 = icmp slt i64 %p4, 1
br label %LSL5415
LSL5415:
br i1 %t5414, label %LSJ5415, label %LSR5415
LSR5415:
%t5416 = icmp sgt i64 %p4, 1073741823
br label %LSJ5415
LSJ5415:
%t5417 = phi i1 [ true, %LSL5415 ], [ %t5416, %LSR5415 ]
br i1 %t5417, label %L1705, label %L1707
L1705:
%t5419 = call i64 @rt_abort(ptr @.s5418)
ret i64 %t5419
L1707:
%t5420 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t5421 = call i64 @__mruntime_rt_dec_resid__top(i64 %t5420, i64 %p2)
%t5422 = icmp eq i64 %t5421, 0
br label %LSL5423
LSL5423:
br i1 %t5422, label %LSJ5423, label %LSR5423
LSR5423:
%t5424 = icmp eq i64 %p1, 0
br label %LSJ5423
LSJ5423:
%t5425 = phi i1 [ true, %LSL5423 ], [ %t5424, %LSR5423 ]
br i1 %t5425, label %L1708, label %L1710
L1708:
%t5426 = call i64 @__mruntime_rt_dec_resid__set_hdr(i64 %p0, i64 0, i64 %p4, i64 0, i64 0, i64 0)
ret i64 %t5426
L1710:
%t5427 = call i64 @__mruntime_rt_dec_resid__ndig(i64 %t5420, i64 %t5421)
%t5428 = icmp sle i64 %t5427, %p4
br i1 %t5428, label %L1711, label %L1713
L1711:
%t5429 = call i64 @__mruntime_rt_dec_resid__finish_hdr(i64 %p0, i64 %p1, i64 %t5421, i64 %p3, i64 %t5427, i64 %p4)
ret i64 %t5429
L1713:
%t5430 = sub nsw i64 %t5427, %p4
%t5431 = sub nsw i64 %t5430, 1
%t5432 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5433 = icmp eq i64 %t5432, 0
%t5434 = zext i1 %t5433 to i8
call void @resid_div_check(i8 %t5434)
%t5435 = icmp eq i64 %t5432, -1
%t5436 = icmp eq i64 %t5431, -9223372036854775808
%t5437 = and i1 %t5435, %t5436
%t5440 = zext i1 %t5437 to i8
call void @resid_overflow_check(i8 %t5440)
%t5438 = add i64 %t5432, 0
%t5439 = sdiv i64 %t5431, %t5438
%t5441 = call i64 @__mruntime_rt_dec_resid__li(i64 %t5420, i64 %t5439)
%t5442 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5441)
%t5443 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5444 = icmp eq i64 %t5443, 0
%t5445 = zext i1 %t5444 to i8
call void @resid_div_check(i8 %t5445)
%t5446 = icmp eq i64 %t5443, -1
%t5447 = icmp eq i64 %t5431, -9223372036854775808
%t5448 = and i1 %t5446, %t5447
%t5449 = select i1 %t5446, i64 1, i64 %t5443
%t5450 = srem i64 %t5431, %t5449
%t5452 = call i64 @__mruntime_rt_dec_resid__p10(i64 %t5450)
%t5453 = icmp eq i64 %t5452, 0
%t5454 = zext i1 %t5453 to i8
call void @resid_div_check(i8 %t5454)
%t5459 = udiv i64 %t5442, %t5452
%t5460 = add i64 10, 0
%t5461 = add i64 %t5460, 0
%t5467 = icmp eq i64 %t5461, 0
%t5468 = zext i1 %t5467 to i8
call void @resid_div_check(i8 %t5468)
%t5473 = urem i64 %t5459, %t5461
%t5474 = add i64 5, 0
%t5475 = add i64 %t5474, 0
%t5481 = icmp uge i64 %t5473, %t5475
%t5482 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5483 = icmp eq i64 %t5482, 0
%t5484 = zext i1 %t5483 to i8
call void @resid_div_check(i8 %t5484)
%t5485 = icmp eq i64 %t5482, -1
%t5486 = icmp eq i64 %t5430, -9223372036854775808
%t5487 = and i1 %t5485, %t5486
%t5490 = zext i1 %t5487 to i8
call void @resid_overflow_check(i8 %t5490)
%t5488 = add i64 %t5482, 0
%t5489 = sdiv i64 %t5430, %t5488
%t5491 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5492 = icmp eq i64 %t5491, 0
%t5493 = zext i1 %t5492 to i8
call void @resid_div_check(i8 %t5493)
%t5494 = icmp eq i64 %t5491, -1
%t5495 = icmp eq i64 %t5430, -9223372036854775808
%t5496 = and i1 %t5494, %t5495
%t5497 = select i1 %t5494, i64 1, i64 %t5491
%t5498 = srem i64 %t5430, %t5497
%t5500 = sub i64 %t5421, %t5489
%t5501 = icmp eq i64 %t5498, 0
br i1 %t5501, label %L1714, label %L1715
L1714:
%t5502 = call i64 @__mruntime_rt_dec_resid__li(i64 %t5420, i64 %t5489)
%t5503 = mul i64 %t5500, 8
%t5504 = call i64 @mcopy(i64 %t5420, i64 %t5502, i64 %t5503)
br label %L1716
L1715:
%t5505 = call i64 @__mruntime_rt_dec_resid__p10(i64 %t5498)
%t5506 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5507 = sub i64 %t5506, %t5498
%t5508 = call i64 @__mruntime_rt_dec_resid__p10(i64 %t5507)
%t5509 = call i64 @__mruntime_rt_dec_resid__shift_down(i64 %t5420, i64 %t5421, i64 %t5489, i64 %t5505, i64 %t5508, i64 0, i64 %t5500)
br label %L1716
L1716:
%t5510 = phi i64 [ %t5504, %L1714 ], [ %t5509, %L1715 ]
%t5511 = call i64 @__mruntime_rt_dec_resid__top(i64 %t5420, i64 %t5500)
%t5512 = add i64 %p3, %t5430
br i1 %t5481, label %L1717, label %L1718
L1717:
%t5513 = call i64 @__mruntime_rt_dec_resid__round_up(i64 %t5420, i64 0, i64 %t5511)
br label %L1719
L1718:
br label %L1719
L1719:
%t5514 = phi i64 [ %t5513, %L1717 ], [ %t5511, %L1718 ]
%t5515 = call i64 @__mruntime_rt_dec_resid__ndig(i64 %t5420, i64 %t5514)
%t5516 = icmp sgt i64 %t5515, %p4
br i1 %t5516, label %L1720, label %L1722
L1720:
%t5517 = add i64 1, 0
%t5518 = add i64 %t5517, 0
%t5524 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5420, i64 %t5518)
%t5525 = add i64 %t5512, %p4
%t5526 = call i64 @__mruntime_rt_dec_resid__finish_hdr(i64 %p0, i64 %p1, i64 1, i64 %t5525, i64 1, i64 %p4)
ret i64 %t5526
L1722:
%t5527 = call i64 @__mruntime_rt_dec_resid__finish_hdr(i64 %p0, i64 %p1, i64 %t5514, i64 %t5512, i64 %t5515, i64 %p4)
ret i64 %t5527
}
define internal i64 @__mruntime_rt_dec_resid__finish_hdr(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5528 = sub i64 %p5, %p4
%t5529 = sub i64 %p3, %t5528
%t5530 = call i64 @__mruntime_rt_dec_resid__max_exp()
%t5531 = icmp sgt i64 %t5529, %t5530
br label %LSL5532
LSL5532:
br i1 %t5531, label %LSJ5532, label %LSR5532
LSR5532:
%t5533 = call i64 @__mruntime_rt_dec_resid__max_exp()
%t5534 = sub i64 0, %t5533
%t5535 = icmp slt i64 %t5529, %t5534
br label %LSJ5532
LSJ5532:
%t5536 = phi i1 [ true, %LSL5532 ], [ %t5535, %LSR5532 ]
br i1 %t5536, label %L1723, label %L1725
L1723:
%t5538 = call i64 @rt_abort(ptr @.s5537)
ret i64 %t5538
L1725:
%t5539 = icmp slt i64 %p1, 0
br i1 %t5539, label %L1726, label %L1727
L1726:
%t5540 = sub nsw i64 0, 1
br label %L1728
L1727:
br label %L1728
L1728:
%t5541 = phi i64 [ %t5540, %L1726 ], [ 1, %L1727 ]
%t5542 = tail call i64 @__mruntime_rt_dec_resid__set_hdr(i64 %p0, i64 %t5541, i64 %p5, i64 %p3, i64 %p2, i64 %p4)
ret i64 %t5542
}
define internal i64 @__mruntime_rt_dec_resid__shift_down(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t5580, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ]
%t5543 = icmp sge i64 %p5, %p6
br i1 %t5543, label %L1729, label %L1731
L1729:
ret i64 0
L1731:
%t5544 = add i64 %p5, %p2
%t5545 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t5544)
%t5546 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5545)
%t5547 = icmp eq i64 %p3, 0
%t5548 = zext i1 %t5547 to i8
call void @resid_div_check(i8 %t5548)
%t5553 = udiv i64 %t5546, %p3
%t5554 = add i64 %p5, %p2
%t5555 = add i64 %t5554, 1
%t5556 = icmp slt i64 %t5555, %p1
br i1 %t5556, label %L1732, label %L1733
L1732:
%t5557 = add i64 %p5, %p2
%t5558 = add i64 %t5557, 1
%t5559 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t5558)
%t5560 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5559)
%t5561 = icmp eq i64 %p3, 0
%t5562 = zext i1 %t5561 to i8
call void @resid_div_check(i8 %t5562)
%t5567 = urem i64 %t5560, %p3
%t5568 = mul i64 %t5567, %p4
br label %L1734
L1733:
%t5569 = add i64 0, 0
%t5570 = add i64 %t5569, 0
br label %L1734
L1734:
%t5576 = phi i64 [ %t5568, %L1732 ], [ %t5570, %L1733 ]
%t5577 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p5)
%t5578 = add i64 %t5553, %t5576
%t5579 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5577, i64 %t5578)
%t5580 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__round_up(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5628, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t5582 = icmp sge i64 %p1, %p2
br i1 %t5582, label %L1735, label %L1737
L1735:
%t5583 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t5584 = add i64 1, 0
%t5585 = add i64 %t5584, 0
%t5591 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5583, i64 %t5585)
%t5592 = mul nsw i64 %t5591, 0
%t5593 = add nsw i64 %t5592, %p2
%t5594 = add i64 %t5593, 1
ret i64 %t5594
L1737:
%t5595 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p1)
%t5596 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5595)
%t5597 = add i64 1, 0
%t5598 = add i64 %t5597, 0
%t5604 = add i64 %t5596, %t5598
%t5605 = call i64 @__mruntime_rt_dec_resid__bb()
%t5606 = icmp ult i64 %t5604, %t5605
br i1 %t5606, label %L1738, label %L1740
L1738:
%t5607 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p1)
%t5608 = add i64 1, 0
%t5609 = add i64 %t5608, 0
%t5615 = add i64 %t5596, %t5609
%t5616 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5607, i64 %t5615)
%t5617 = mul nsw i64 %t5616, 0
%t5618 = add nsw i64 %t5617, %p2
ret i64 %t5618
L1740:
%t5619 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p1)
%t5620 = add i64 0, 0
%t5621 = add i64 %t5620, 0
%t5627 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5619, i64 %t5621)
%t5628 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__from_limbs(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5630 = call i64 @__mruntime_rt_dec_resid__top(i64 %p1, i64 %p2)
%t5631 = icmp eq i64 %t5630, 0
br label %LSL5632
LSL5632:
br i1 %t5631, label %LSJ5632, label %LSR5632
LSR5632:
%t5633 = icmp eq i64 %p0, 0
br label %LSJ5632
LSJ5632:
%t5634 = phi i1 [ true, %LSL5632 ], [ %t5633, %LSR5632 ]
br i1 %t5634, label %L1741, label %L1743
L1741:
%t5635 = call i64 @__mruntime_rt_dec_resid__dzero(i64 %p4)
ret i64 %t5635
L1743:
%t5636 = add i64 %t5630, 1
%t5637 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 %t5636)
%t5638 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t5637)
%t5639 = mul i64 %t5630, 8
%t5640 = call i64 @mcopy(i64 %t5638, i64 %p1, i64 %t5639)
%t5641 = tail call i64 @__mruntime_rt_dec_resid__finish(i64 %t5637, i64 %p0, i64 %t5630, i64 %p3, i64 %p4)
ret i64 %t5641
}
define internal i64 @__mruntime_rt_dec_resid__mul1(i64 %p0, i64 %p1, i64 %p2, i64 %p3) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5642 = add i64 4294967296, 0
%t5643 = add i64 %t5642, 0
%t5649 = icmp ult i64 %p3, %t5643
br i1 %t5649, label %L1744, label %L1746
L1744:
%t5650 = add i64 %p3, 0
%t5651 = add i64 %t5650, 0
%t5657 = sitofp i64 %t5651 to double
%t5658 = fmul double %t5657, 2.0
%t5659 = fdiv double %t5658, 10000000000000000000.0
%t5660 = mul i64 %p2, 8
%t5661 = add i64 %p1, %t5660
%t5662 = add i64 0, 0
%t5663 = add i64 %t5662, 0
%t5669 = call i64 @__mruntime_rt_dec_resid__mul1_small(i64 %p0, i64 %p1, i64 %t5661, i64 %p3, double %t5659, i64 %t5663)
%t5670 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t5671 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5670, i64 %t5669)
%t5672 = mul nsw i64 %t5671, 0
%t5673 = add nsw i64 %t5672, %p2
%t5674 = add i64 %t5673, 1
ret i64 %t5674
L1746:
%t5675 = add i64 0, 0
%t5676 = add i64 %t5675, 0
%t5682 = call i64 @__mruntime_rt_dec_resid__mul1_big(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 %t5676)
%t5683 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t5684 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5683, i64 %t5682)
%t5685 = mul nsw i64 %t5684, 0
%t5686 = add nsw i64 %t5685, %p2
%t5687 = add i64 %t5686, 1
ret i64 %t5687
}
define internal i64 @__mruntime_rt_dec_resid__mul1_small(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, double %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t5733, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5734, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi double [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t5718, %tco.s0 ]
%t5688 = icmp sge i64 %p1, %p2
br i1 %t5688, label %L1747, label %L1749
L1747:
ret i64 %p5
L1749:
%t5689 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p1)
%t5690 = add i64 1, 0
%t5691 = add i64 %t5690, 0
%t5697 = icmp uge i64 %t5691, 64
%t5698 = add i64 %t5691, 0
%t5699 = lshr i64 %t5689, %t5698
%t5700 = select i1 %t5697, i64 0, i64 %t5699
%t5701 = add i64 %t5700, 0
%t5702 = add i64 %t5701, 0
%t5708 = sitofp i64 %t5702 to double
%t5709 = fmul double %t5708, %p4
%t5710 = fsub double %t5709, 0.000030517578125
%t5716 = fptosi double %t5710 to i64
%t5717 = add i64 %t5716, 0
%t5718 = add i64 %t5717, 0
%t5724 = mul i64 %t5689, %p3
%t5725 = call i64 @__mruntime_rt_dec_resid__bb()
%t5726 = mul i64 %t5718, %t5725
%t5727 = sub i64 %t5724, %t5726
%t5728 = add i64 %t5727, %p5
%t5729 = call i64 @__mruntime_rt_dec_resid__bb()
%t5730 = icmp uge i64 %t5728, %t5729
br i1 %t5730, label %L1750, label %L1752
L1750:
%t5731 = call i64 @__mruntime_rt_dec_resid__mul1_fix(i64 %p0, i64 %p1, i64 %p2, i64 %p3, double %p4, i64 %t5728, i64 %t5718)
ret i64 %t5731
L1752:
%t5732 = call i64 @__mruntime_rt_dec_resid__su(i64 %p0, i64 %t5728)
%t5733 = add i64 %p0, 8
%t5734 = add i64 %p1, 8
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__mul1_fix(i64 %p0, i64 %p1, i64 %p2, i64 %p3, double %p4, i64 %p5, i64 %p6) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5736 = call i64 @__mruntime_rt_dec_resid__bb()
%t5737 = sub i64 %p5, %t5736
%t5738 = call i64 @__mruntime_rt_dec_resid__su(i64 %p0, i64 %t5737)
%t5739 = add i64 %p0, 8
%t5740 = add i64 %p1, 8
%t5741 = add i64 1, 0
%t5742 = add i64 %t5741, 0
%t5748 = add i64 %p6, %t5742
%t5749 = call i64 @__mruntime_rt_dec_resid__mul1_small(i64 %t5739, i64 %t5740, i64 %p2, i64 %p3, double %p4, i64 %t5748)
ret i64 %t5749
}
define internal i64 @__mruntime_rt_dec_resid__mul1_big(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t5775, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t5784, %tco.s0 ]
%t5750 = icmp sge i64 %p4, %p2
br i1 %t5750, label %L1753, label %L1755
L1753:
ret i64 %p5
L1755:
%t5751 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p4)
%t5752 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5751)
%t5753 = zext i64 %t5752 to i128
%t5754 = zext i64 %p3 to i128
%t5755 = mul i128 %t5753, %t5754
%t5756 = call i64 @__mruntime_rt_dec_resid__div_b(i128 %t5755)
%t5757 = add i128 %t5755, 0
%t5758 = trunc i128 %t5757 to i64
%t5764 = call i64 @__mruntime_rt_dec_resid__bb()
%t5765 = mul i64 %t5756, %t5764
%t5766 = sub i64 %t5758, %t5765
%t5767 = call i64 @__mruntime_rt_dec_resid__bb()
%t5768 = sub i64 %t5767, %p5
%t5769 = icmp uge i64 %t5766, %t5768
%t5770 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p4)
br i1 %t5769, label %L1756, label %L1757
L1756:
%t5771 = sub i64 %t5766, %t5768
br label %L1758
L1757:
%t5772 = add i64 %t5766, %p5
br label %L1758
L1758:
%t5773 = phi i64 [ %t5771, %L1756 ], [ %t5772, %L1757 ]
%t5774 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5770, i64 %t5773)
%t5775 = add nsw i64 %p4, 1
br i1 %t5769, label %L1759, label %L1760
L1759:
%t5776 = add i64 1, 0
%t5777 = add i64 %t5776, 0
%t5783 = add i64 %t5756, %t5777
br label %L1761
L1760:
br label %L1761
L1761:
%t5784 = phi i64 [ %t5783, %L1759 ], [ %t5756, %L1760 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__scale(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5786 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5787 = icmp eq i64 %t5786, 0
%t5788 = zext i1 %t5787 to i8
call void @resid_div_check(i8 %t5788)
%t5789 = icmp eq i64 %t5786, -1
%t5790 = icmp eq i64 %p2, -9223372036854775808
%t5791 = and i1 %t5789, %t5790
%t5794 = zext i1 %t5791 to i8
call void @resid_overflow_check(i8 %t5794)
%t5792 = add i64 %t5786, 0
%t5793 = sdiv i64 %p2, %t5792
%t5795 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5796 = icmp eq i64 %t5795, 0
%t5797 = zext i1 %t5796 to i8
call void @resid_div_check(i8 %t5797)
%t5798 = icmp eq i64 %t5795, -1
%t5799 = icmp eq i64 %p2, -9223372036854775808
%t5800 = and i1 %t5798, %t5799
%t5801 = select i1 %t5798, i64 1, i64 %t5795
%t5802 = srem i64 %p2, %t5801
%t5804 = add i64 %p1, %t5793
%t5805 = add i64 %t5804, 1
%t5806 = call i64 @__mruntime_rt_dec_resid__tmp_limbs(i64 %t5805)
%t5807 = mul i64 %t5793, 8
%t5808p = inttoptr i64 %t5806 to ptr
%t5808q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t5808p, i8 %t5808q, i64 %t5807, i1 false)
%t5808 = add i64 0, 0
%t5809 = icmp eq i64 %t5802, 0
br i1 %t5809, label %L1762, label %L1763
L1762:
%t5810 = call i64 @__mruntime_rt_dec_resid__li(i64 %t5806, i64 %t5793)
%t5811 = mul i64 %p1, 8
%t5812 = call i64 @mcopy(i64 %t5810, i64 %p0, i64 %t5811)
%t5813 = add i64 %t5793, %p1
%t5814 = call i64 @__mruntime_rt_dec_resid__li(i64 %t5806, i64 %t5813)
%t5815 = add i64 0, 0
%t5816 = add i64 %t5815, 0
%t5822 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5814, i64 %t5816)
%t5823 = add i64 %t5812, %t5822
br label %L1764
L1763:
%t5824 = call i64 @__mruntime_rt_dec_resid__li(i64 %t5806, i64 %t5793)
%t5825 = call i64 @__mruntime_rt_dec_resid__p10(i64 %t5802)
%t5826 = call i64 @__mruntime_rt_dec_resid__mul1(i64 %t5824, i64 %p0, i64 %p1, i64 %t5825)
br label %L1764
L1764:
%t5827 = phi i64 [ %t5823, %L1762 ], [ %t5826, %L1763 ]
%t5828 = call i64 @__mruntime_rt_dec_resid__r2()
%t5829 = add i64 %p1, %t5793
%t5830 = add i64 %t5829, 1
%t5831 = call i64 @__mruntime_rt_dec_resid__top(i64 %t5806, i64 %t5830)
%t5832 = call i64 @st64(i64 %t5828, i64 %t5831)
ret i64 %t5806
}
define internal i64 @__mruntime_rt_dec_resid__cmp_n(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5833 = call i64 @__mruntime_rt_dec_resid__top(i64 %p0, i64 %p1)
%t5834 = call i64 @__mruntime_rt_dec_resid__top(i64 %p2, i64 %p3)
%t5835 = icmp ne i64 %t5833, %t5834
br i1 %t5835, label %L1765, label %L1767
L1765:
%t5836 = icmp sgt i64 %t5833, %t5834
br i1 %t5836, label %L1768, label %L1769
L1768:
br label %L1770
L1769:
%t5837 = sub nsw i64 0, 1
br label %L1770
L1770:
%t5838 = phi i64 [ 1, %L1768 ], [ %t5837, %L1769 ]
ret i64 %t5838
L1767:
%t5839 = sub i64 %t5833, 1
%t5840 = call i64 @__mruntime_rt_dec_resid__cmp_from(i64 %p0, i64 %p2, i64 %t5839)
ret i64 %t5840
}
define internal i64 @__mruntime_rt_dec_resid__cmp_from(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5850, %tco.s0 ]
%t5841 = icmp slt i64 %p2, 0
br i1 %t5841, label %L1771, label %L1773
L1771:
ret i64 0
L1773:
%t5842 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t5843 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5842)
%t5844 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p2)
%t5845 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5844)
%t5846 = icmp ne i64 %t5843, %t5845
br i1 %t5846, label %L1774, label %L1776
L1774:
%t5847 = icmp ugt i64 %t5843, %t5845
br i1 %t5847, label %L1777, label %L1778
L1777:
br label %L1779
L1778:
%t5848 = sub nsw i64 0, 1
br label %L1779
L1779:
%t5849 = phi i64 [ 1, %L1777 ], [ %t5848, %L1778 ]
ret i64 %t5849
L1776:
%t5850 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__cmp_mag(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5852 = add i64 %p3, %p2
%t5853 = add i64 %p7, %p6
%t5854 = icmp ne i64 %t5852, %t5853
br i1 %t5854, label %L1780, label %L1782
L1780:
%t5855 = icmp sgt i64 %t5852, %t5853
br i1 %t5855, label %L1783, label %L1784
L1783:
br label %L1785
L1784:
%t5856 = sub nsw i64 0, 1
br label %L1785
L1785:
%t5857 = phi i64 [ 1, %L1783 ], [ %t5856, %L1784 ]
ret i64 %t5857
L1782:
%t5858 = icmp eq i64 %p3, %p7
br i1 %t5858, label %L1786, label %L1788
L1786:
%t5859 = call i64 @__mruntime_rt_dec_resid__cmp_n(i64 %p0, i64 %p1, i64 %p4, i64 %p5)
ret i64 %t5859
L1788:
%t5860 = icmp sgt i64 %p3, %p7
br i1 %t5860, label %L1789, label %L1791
L1789:
%t5861 = sub i64 %p3, %p7
%t5862 = call i64 @__mruntime_rt_dec_resid__scale(i64 %p0, i64 %p1, i64 %t5861)
%t5863 = call i64 @__mruntime_rt_dec_resid__r2()
%t5864 = call i64 @ld64(i64 %t5863)
%t5865 = call i64 @__mruntime_rt_dec_resid__cmp_n(i64 %t5862, i64 %t5864, i64 %p4, i64 %p5)
%t5866 = call i64 @c_free(i64 %t5862)
%t5867 = mul nsw i64 %t5866, 0
%t5868 = add nsw i64 %t5867, %t5865
ret i64 %t5868
L1791:
%t5869 = sub i64 %p7, %p3
%t5870 = call i64 @__mruntime_rt_dec_resid__scale(i64 %p4, i64 %p5, i64 %t5869)
%t5871 = call i64 @__mruntime_rt_dec_resid__r2()
%t5872 = call i64 @ld64(i64 %t5871)
%t5873 = call i64 @__mruntime_rt_dec_resid__cmp_n(i64 %p0, i64 %p1, i64 %t5870, i64 %t5872)
%t5874 = call i64 @c_free(i64 %t5870)
%t5875 = mul nsw i64 %t5874, 0
%t5876 = add nsw i64 %t5875, %t5873
ret i64 %t5876
}
define internal i64 @__mruntime_rt_dec_resid__add_n(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5877 = mul i64 %p4, 8
%t5878 = add i64 %p3, %t5877
%t5879 = add i64 0, 0
%t5880 = add i64 %t5879, 0
%t5886 = call i64 @__mruntime_rt_dec_resid__add_lo(i64 %p0, i64 %p1, i64 %p3, i64 %t5878, i64 %t5880)
%t5887 = call i64 @__mruntime_rt_dec_resid__add_carry(i64 %p0, i64 %p1, i64 %p4, i64 %p2, i64 %t5886)
%t5888 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t5889 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5888, i64 %t5887)
%t5890 = mul nsw i64 %t5889, 0
%t5891 = add nsw i64 %t5890, %p2
%t5892 = add i64 %t5891, 1
ret i64 %t5892
}
define internal i64 @__mruntime_rt_dec_resid__add_lo(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t5933, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5934, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5935, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t5950, %tco.s0 ]
%t5893 = add i64 %p2, 8
%t5894 = icmp slt i64 %t5893, %p3
br i1 %t5894, label %L1792, label %L1794
L1792:
%t5895 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p2)
%t5896 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p1)
%t5897 = add i64 %t5896, %p4
%t5898 = call i64 @__mruntime_rt_dec_resid__bb()
%t5899 = sub i64 %t5898, %t5895
%t5900 = icmp uge i64 %t5897, %t5899
br i1 %t5900, label %L1795, label %L1796
L1795:
%t5901 = sub i64 %t5897, %t5899
br label %L1797
L1796:
%t5902 = add i64 %t5897, %t5895
br label %L1797
L1797:
%t5903 = phi i64 [ %t5901, %L1795 ], [ %t5902, %L1796 ]
%t5904 = call i64 @__mruntime_rt_dec_resid__su(i64 %p0, i64 %t5903)
%t5905 = add i64 %p2, 8
%t5906 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5905)
%t5907 = add i64 %p1, 8
%t5908 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5907)
br i1 %t5900, label %L1798, label %L1799
L1798:
%t5909 = add i64 1, 0
%t5910 = add i64 %t5909, 0
br label %L1800
L1799:
%t5916 = add i64 0, 0
%t5917 = add i64 %t5916, 0
br label %L1800
L1800:
%t5923 = phi i64 [ %t5910, %L1798 ], [ %t5917, %L1799 ]
%t5924 = add i64 %t5908, %t5923
%t5925 = call i64 @__mruntime_rt_dec_resid__bb()
%t5926 = sub i64 %t5925, %t5906
%t5927 = icmp uge i64 %t5924, %t5926
%t5928 = add i64 %p0, 8
br i1 %t5927, label %L1801, label %L1802
L1801:
%t5929 = sub i64 %t5924, %t5926
br label %L1803
L1802:
%t5930 = add i64 %t5924, %t5906
br label %L1803
L1803:
%t5931 = phi i64 [ %t5929, %L1801 ], [ %t5930, %L1802 ]
%t5932 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5928, i64 %t5931)
%t5933 = add i64 %p0, 16
%t5934 = add i64 %p1, 16
%t5935 = add i64 %p2, 16
br i1 %t5927, label %L1804, label %L1805
L1804:
%t5936 = add i64 1, 0
%t5937 = add i64 %t5936, 0
br label %L1806
L1805:
%t5943 = add i64 0, 0
%t5944 = add i64 %t5943, 0
br label %L1806
L1806:
%t5950 = phi i64 [ %t5937, %L1804 ], [ %t5944, %L1805 ]
br label %tco.s0
tco.s0:
br label %tco.head
L1794:
%t5952 = icmp sge i64 %p2, %p3
br i1 %t5952, label %L1807, label %L1809
L1807:
ret i64 %p4
L1809:
%t5953 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p2)
%t5954 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p1)
%t5955 = add i64 %t5954, %p4
%t5956 = call i64 @__mruntime_rt_dec_resid__bb()
%t5957 = sub i64 %t5956, %t5953
%t5958 = icmp uge i64 %t5955, %t5957
br i1 %t5958, label %L1810, label %L1811
L1810:
%t5959 = sub i64 %t5955, %t5957
br label %L1812
L1811:
%t5960 = add i64 %t5955, %t5953
br label %L1812
L1812:
%t5961 = phi i64 [ %t5959, %L1810 ], [ %t5960, %L1811 ]
%t5962 = call i64 @__mruntime_rt_dec_resid__su(i64 %p0, i64 %t5961)
br i1 %t5958, label %L1813, label %L1814
L1813:
%t5963 = add i64 1, 0
%t5964 = add i64 %t5963, 0
br label %L1815
L1814:
%t5970 = add i64 0, 0
%t5971 = add i64 %t5970, 0
br label %L1815
L1815:
%t5977 = phi i64 [ %t5964, %L1813 ], [ %t5971, %L1814 ]
ret i64 %t5977
}
define internal i64 @__mruntime_rt_dec_resid__add_carry(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6016, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t6031, %tco.s0 ]
%t5978 = icmp sge i64 %p2, %p3
br i1 %t5978, label %L1816, label %L1818
L1816:
ret i64 %p4
L1818:
%t5979 = add i64 0, 0
%t5980 = add i64 %t5979, 0
%t5986 = icmp eq i64 %p4, %t5980
br i1 %t5986, label %L1819, label %L1821
L1819:
%t5987 = icmp ne i64 %p0, %p1
br i1 %t5987, label %L1822, label %L1823
L1822:
%t5988 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t5989 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p2)
%t5990 = sub i64 %p3, %p2
%t5991 = mul i64 %t5990, 8
%t5992 = call i64 @mcopy(i64 %t5988, i64 %t5989, i64 %t5991)
br label %L1824
L1823:
br label %L1824
L1824:
%t5993 = phi i64 [ %t5992, %L1822 ], [ 0, %L1823 ]
ret i64 %p4
L1821:
%t5994 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p2)
%t5995 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5994)
%t5996 = add i64 1, 0
%t5997 = add i64 %t5996, 0
%t6003 = add i64 %t5995, %t5997
%t6004 = call i64 @__mruntime_rt_dec_resid__bb()
%t6005 = icmp eq i64 %t6003, %t6004
%t6006 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
br i1 %t6005, label %L1825, label %L1826
L1825:
%t6007 = add i64 0, 0
%t6008 = add i64 %t6007, 0
br label %L1827
L1826:
br label %L1827
L1827:
%t6014 = phi i64 [ %t6008, %L1825 ], [ %t6003, %L1826 ]
%t6015 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6006, i64 %t6014)
%t6016 = add nsw i64 %p2, 1
br i1 %t6005, label %L1828, label %L1829
L1828:
%t6017 = add i64 1, 0
%t6018 = add i64 %t6017, 0
br label %L1830
L1829:
%t6024 = add i64 0, 0
%t6025 = add i64 %t6024, 0
br label %L1830
L1830:
%t6031 = phi i64 [ %t6018, %L1828 ], [ %t6025, %L1829 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__sub_n(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6033 = mul i64 %p4, 8
%t6034 = add i64 %p3, %t6033
%t6035 = add i64 0, 0
%t6036 = add i64 %t6035, 0
%t6042 = call i64 @__mruntime_rt_dec_resid__sub_lo(i64 %p0, i64 %p1, i64 %p3, i64 %t6034, i64 %t6036)
%t6043 = call i64 @__mruntime_rt_dec_resid__sub_borrow(i64 %p0, i64 %p1, i64 %p4, i64 %p2, i64 %t6042)
ret i64 %p2
}
define internal i64 @__mruntime_rt_dec_resid__sub_lo(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t6084, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6085, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6086, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t6101, %tco.s0 ]
%t6044 = add i64 %p2, 8
%t6045 = icmp slt i64 %t6044, %p3
br i1 %t6045, label %L1831, label %L1833
L1831:
%t6046 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p1)
%t6047 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p2)
%t6048 = add i64 %t6047, %p4
%t6049 = icmp ult i64 %t6046, %t6048
br i1 %t6049, label %L1834, label %L1835
L1834:
%t6050 = call i64 @__mruntime_rt_dec_resid__bb()
%t6051 = sub i64 %t6050, %t6048
%t6052 = add i64 %t6046, %t6051
br label %L1836
L1835:
%t6053 = sub i64 %t6046, %t6048
br label %L1836
L1836:
%t6054 = phi i64 [ %t6052, %L1834 ], [ %t6053, %L1835 ]
%t6055 = call i64 @__mruntime_rt_dec_resid__su(i64 %p0, i64 %t6054)
%t6056 = add i64 %p1, 8
%t6057 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6056)
%t6058 = add i64 %p2, 8
%t6059 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6058)
br i1 %t6049, label %L1837, label %L1838
L1837:
%t6060 = add i64 1, 0
%t6061 = add i64 %t6060, 0
br label %L1839
L1838:
%t6067 = add i64 0, 0
%t6068 = add i64 %t6067, 0
br label %L1839
L1839:
%t6074 = phi i64 [ %t6061, %L1837 ], [ %t6068, %L1838 ]
%t6075 = add i64 %t6059, %t6074
%t6076 = icmp ult i64 %t6057, %t6075
%t6077 = add i64 %p0, 8
br i1 %t6076, label %L1840, label %L1841
L1840:
%t6078 = call i64 @__mruntime_rt_dec_resid__bb()
%t6079 = sub i64 %t6078, %t6075
%t6080 = add i64 %t6057, %t6079
br label %L1842
L1841:
%t6081 = sub i64 %t6057, %t6075
br label %L1842
L1842:
%t6082 = phi i64 [ %t6080, %L1840 ], [ %t6081, %L1841 ]
%t6083 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6077, i64 %t6082)
%t6084 = add i64 %p0, 16
%t6085 = add i64 %p1, 16
%t6086 = add i64 %p2, 16
br i1 %t6076, label %L1843, label %L1844
L1843:
%t6087 = add i64 1, 0
%t6088 = add i64 %t6087, 0
br label %L1845
L1844:
%t6094 = add i64 0, 0
%t6095 = add i64 %t6094, 0
br label %L1845
L1845:
%t6101 = phi i64 [ %t6088, %L1843 ], [ %t6095, %L1844 ]
br label %tco.s0
tco.s0:
br label %tco.head
L1833:
%t6103 = icmp sge i64 %p2, %p3
br i1 %t6103, label %L1846, label %L1848
L1846:
ret i64 %p4
L1848:
%t6104 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p1)
%t6105 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p2)
%t6106 = add i64 %t6105, %p4
%t6107 = icmp ult i64 %t6104, %t6106
br i1 %t6107, label %L1849, label %L1850
L1849:
%t6108 = call i64 @__mruntime_rt_dec_resid__bb()
%t6109 = sub i64 %t6108, %t6106
%t6110 = add i64 %t6104, %t6109
br label %L1851
L1850:
%t6111 = sub i64 %t6104, %t6106
br label %L1851
L1851:
%t6112 = phi i64 [ %t6110, %L1849 ], [ %t6111, %L1850 ]
%t6113 = call i64 @__mruntime_rt_dec_resid__su(i64 %p0, i64 %t6112)
br i1 %t6107, label %L1852, label %L1853
L1852:
%t6114 = add i64 1, 0
%t6115 = add i64 %t6114, 0
br label %L1854
L1853:
%t6121 = add i64 0, 0
%t6122 = add i64 %t6121, 0
br label %L1854
L1854:
%t6128 = phi i64 [ %t6115, %L1852 ], [ %t6122, %L1853 ]
ret i64 %t6128
}
define internal i64 @__mruntime_rt_dec_resid__sub_borrow(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6175, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t6190, %tco.s0 ]
%t6129 = icmp sge i64 %p2, %p3
br i1 %t6129, label %L1855, label %L1857
L1855:
ret i64 0
L1857:
%t6130 = add i64 0, 0
%t6131 = add i64 %t6130, 0
%t6137 = icmp eq i64 %p4, %t6131
br i1 %t6137, label %L1858, label %L1860
L1858:
%t6138 = icmp ne i64 %p0, %p1
br i1 %t6138, label %L1861, label %L1862
L1861:
%t6139 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t6140 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p2)
%t6141 = sub i64 %p3, %p2
%t6142 = mul i64 %t6141, 8
%t6143 = call i64 @mcopy(i64 %t6139, i64 %t6140, i64 %t6142)
br label %L1863
L1862:
br label %L1863
L1863:
%t6144 = phi i64 [ %t6143, %L1861 ], [ 0, %L1862 ]
ret i64 %t6144
L1860:
%t6145 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p2)
%t6146 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6145)
%t6147 = add i64 0, 0
%t6148 = add i64 %t6147, 0
%t6154 = icmp eq i64 %t6146, %t6148
%t6155 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
br i1 %t6154, label %L1864, label %L1865
L1864:
%t6156 = call i64 @__mruntime_rt_dec_resid__bb()
%t6157 = add i64 1, 0
%t6158 = add i64 %t6157, 0
%t6164 = sub i64 %t6156, %t6158
br label %L1866
L1865:
%t6165 = add i64 1, 0
%t6166 = add i64 %t6165, 0
%t6172 = sub i64 %t6146, %t6166
br label %L1866
L1866:
%t6173 = phi i64 [ %t6164, %L1864 ], [ %t6172, %L1865 ]
%t6174 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6155, i64 %t6173)
%t6175 = add nsw i64 %p2, 1
br i1 %t6154, label %L1867, label %L1868
L1867:
%t6176 = add i64 1, 0
%t6177 = add i64 %t6176, 0
br label %L1869
L1868:
%t6183 = add i64 0, 0
%t6184 = add i64 %t6183, 0
br label %L1869
L1869:
%t6190 = phi i64 [ %t6177, %L1867 ], [ %t6184, %L1868 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__round_v(i64 %p0, i64 %p1, i1 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br i1 %p2, label %L1870, label %L1871
L1870:
%t6192 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6193 = sub i64 0, %t6192
br label %L1872
L1871:
%t6194 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
br label %L1872
L1872:
%t6195 = phi i64 [ %t6193, %L1870 ], [ %t6194, %L1871 ]
%t6196 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6197 = icmp eq i64 %t6196, 0
br i1 %t6197, label %L1873, label %L1875
L1873:
%t6198 = call i64 @__mruntime_rt_dec_resid__dzero(i64 %p1)
ret i64 %t6198
L1875:
%t6199 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t6200 = icmp sle i64 %t6199, %p1
br i1 %t6200, label %L1876, label %L1878
L1876:
%t6201 = call i64 @dn(i64 %p0)
%t6202 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 %t6201)
%t6203 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6202)
%t6204 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6205 = call i64 @dn(i64 %p0)
%t6206 = mul i64 %t6205, 8
%t6207 = call i64 @mcopy(i64 %t6203, i64 %t6204, i64 %t6206)
%t6208 = call i64 @dn(i64 %p0)
%t6209 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t6210 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6202, i64 %t6195, i64 %t6208, i64 %t6209, i64 %p1)
ret i64 %t6210
L1878:
%t6211 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t6212 = sub i64 %t6211, %p1
%t6213 = sub i64 %t6212, 1
%t6214 = call i64 @__mruntime_rt_dec_resid__ld_()
%t6215 = icmp eq i64 %t6214, 0
%t6216 = zext i1 %t6215 to i8
call void @resid_div_check(i8 %t6216)
%t6217 = icmp eq i64 %t6214, -1
%t6218 = icmp eq i64 %t6213, -9223372036854775808
%t6219 = and i1 %t6217, %t6218
%t6222 = zext i1 %t6219 to i8
call void @resid_overflow_check(i8 %t6222)
%t6220 = add i64 %t6214, 0
%t6221 = sdiv i64 %t6213, %t6220
%t6223 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6224 = call i64 @__mruntime_rt_dec_resid__li(i64 %t6223, i64 %t6221)
%t6225 = call i64 @dn(i64 %p0)
%t6226 = sub i64 %t6225, %t6221
%t6227 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t6228 = call i64 @__mruntime_rt_dec_resid__ld_()
%t6229 = mul i64 %t6228, %t6221
%t6230 = add i64 %t6227, %t6229
%t6231 = call i64 @__mruntime_rt_dec_resid__from_limbs(i64 %t6195, i64 %t6224, i64 %t6226, i64 %t6230, i64 %p1)
ret i64 %t6231
}
define internal i64 @__mruntime_rt_dec_resid__addsub(i64 %p0, i64 %p1, i1 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br i1 %p2, label %L1879, label %L1880
L1879:
%t6232 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t6233 = sub i64 0, %t6232
br label %L1881
L1880:
%t6234 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
br label %L1881
L1881:
%t6235 = phi i64 [ %t6233, %L1879 ], [ %t6234, %L1880 ]
%t6236 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6237 = icmp eq i64 %t6236, 0
br i1 %t6237, label %L1882, label %L1884
L1882:
%t6238 = call i64 @__mruntime_rt_dec_resid__round_v(i64 %p1, i64 %p3, i1 %p2)
ret i64 %t6238
L1884:
%t6239 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t6240 = icmp eq i64 %t6239, 0
br i1 %t6240, label %L1885, label %L1887
L1885:
%t6241 = call i64 @__mruntime_rt_dec_resid__round_v(i64 %p0, i64 %p3, i1 false)
ret i64 %t6241
L1887:
%t6242 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t6243 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p1)
%t6244 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t6245 = add i64 %t6242, %t6244
%t6246 = sub i64 %t6245, 1
%t6247 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p1)
%t6248 = add i64 %t6243, %t6247
%t6249 = sub i64 %t6248, 1
%t6250 = sub i64 %t6246, %p3
%t6251 = sub i64 %t6250, 2
%t6252 = icmp sle i64 %t6249, %t6251
br i1 %t6252, label %L1888, label %L1890
L1888:
%t6253 = call i64 @__mruntime_rt_dec_resid__round_v(i64 %p0, i64 %p3, i1 false)
ret i64 %t6253
L1890:
%t6254 = sub i64 %t6249, %p3
%t6255 = sub i64 %t6254, 2
%t6256 = icmp sle i64 %t6246, %t6255
br i1 %t6256, label %L1891, label %L1893
L1891:
%t6257 = call i64 @__mruntime_rt_dec_resid__round_v(i64 %p1, i64 %p3, i1 %p2)
ret i64 %t6257
L1893:
%t6258 = icmp slt i64 %t6242, %t6243
br i1 %t6258, label %L1894, label %L1895
L1894:
br label %L1896
L1895:
br label %L1896
L1896:
%t6259 = phi i64 [ %t6242, %L1894 ], [ %t6243, %L1895 ]
%t6260 = icmp sgt i64 %t6242, %t6259
br i1 %t6260, label %L1897, label %L1898
L1897:
%t6261 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6262 = call i64 @dn(i64 %p0)
%t6263 = sub i64 %t6242, %t6259
%t6264 = call i64 @__mruntime_rt_dec_resid__scale(i64 %t6261, i64 %t6262, i64 %t6263)
br label %L1899
L1898:
br label %L1899
L1899:
%t6265 = phi i64 [ %t6264, %L1897 ], [ 0, %L1898 ]
%t6266 = icmp sgt i64 %t6242, %t6259
br i1 %t6266, label %L1900, label %L1901
L1900:
%t6267 = call i64 @__mruntime_rt_dec_resid__r2()
%t6268 = call i64 @ld64(i64 %t6267)
br label %L1902
L1901:
%t6269 = call i64 @dn(i64 %p0)
br label %L1902
L1902:
%t6270 = phi i64 [ %t6268, %L1900 ], [ %t6269, %L1901 ]
%t6271 = icmp sgt i64 %t6243, %t6259
br i1 %t6271, label %L1903, label %L1904
L1903:
%t6272 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t6273 = call i64 @dn(i64 %p1)
%t6274 = sub i64 %t6243, %t6259
%t6275 = call i64 @__mruntime_rt_dec_resid__scale(i64 %t6272, i64 %t6273, i64 %t6274)
br label %L1905
L1904:
br label %L1905
L1905:
%t6276 = phi i64 [ %t6275, %L1903 ], [ 0, %L1904 ]
%t6277 = icmp sgt i64 %t6243, %t6259
br i1 %t6277, label %L1906, label %L1907
L1906:
%t6278 = call i64 @__mruntime_rt_dec_resid__r2()
%t6279 = call i64 @ld64(i64 %t6278)
br label %L1908
L1907:
%t6280 = call i64 @dn(i64 %p1)
br label %L1908
L1908:
%t6281 = phi i64 [ %t6279, %L1906 ], [ %t6280, %L1907 ]
%t6282 = icmp ne i64 %t6265, 0
br i1 %t6282, label %L1909, label %L1910
L1909:
br label %L1911
L1910:
%t6283 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
br label %L1911
L1911:
%t6284 = phi i64 [ %t6265, %L1909 ], [ %t6283, %L1910 ]
%t6285 = icmp ne i64 %t6276, 0
br i1 %t6285, label %L1912, label %L1913
L1912:
br label %L1914
L1913:
%t6286 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
br label %L1914
L1914:
%t6287 = phi i64 [ %t6276, %L1912 ], [ %t6286, %L1913 ]
%t6288 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6289 = call i64 @__mruntime_rt_dec_resid__addsub_n(i64 %t6288, i64 %t6235, i64 %t6284, i64 %t6270, i64 %t6287, i64 %t6281, i64 %t6259, i64 %p3)
%t6290 = call i64 @c_free(i64 %t6265)
%t6291 = call i64 @c_free(i64 %t6276)
%t6292 = add i64 %t6290, %t6291
ret i64 %t6289
}
define internal i64 @__mruntime_rt_dec_resid__addsub_n(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6293 = icmp sgt i64 %p3, %p5
br i1 %t6293, label %L1915, label %L1916
L1915:
br label %L1917
L1916:
br label %L1917
L1917:
%t6294 = phi i64 [ %p3, %L1915 ], [ %p5, %L1916 ]
%t6295 = add i64 %t6294, 1
%t6296 = icmp eq i64 %p0, %p1
br i1 %t6296, label %L1918, label %L1920
L1918:
%t6297 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 %t6295)
%t6298 = icmp sge i64 %p3, %p5
br i1 %t6298, label %L1921, label %L1922
L1921:
%t6299 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6297)
%t6300 = call i64 @__mruntime_rt_dec_resid__add_n(i64 %t6299, i64 %p2, i64 %p3, i64 %p4, i64 %p5)
br label %L1923
L1922:
%t6301 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6297)
%t6302 = call i64 @__mruntime_rt_dec_resid__add_n(i64 %t6301, i64 %p4, i64 %p5, i64 %p2, i64 %p3)
br label %L1923
L1923:
%t6303 = phi i64 [ %t6300, %L1921 ], [ %t6302, %L1922 ]
%t6304 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6297, i64 %p0, i64 %t6303, i64 %p6, i64 %p7)
ret i64 %t6304
L1920:
%t6305 = call i64 @__mruntime_rt_dec_resid__cmp_n(i64 %p2, i64 %p3, i64 %p4, i64 %p5)
%t6306 = icmp eq i64 %t6305, 0
br i1 %t6306, label %L1924, label %L1926
L1924:
%t6307 = call i64 @__mruntime_rt_dec_resid__dzero(i64 %p7)
ret i64 %t6307
L1926:
%t6308 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 %t6295)
%t6309 = icmp sgt i64 %t6305, 0
br i1 %t6309, label %L1927, label %L1929
L1927:
%t6310 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6308)
%t6311 = call i64 @__mruntime_rt_dec_resid__sub_n(i64 %t6310, i64 %p2, i64 %p3, i64 %p4, i64 %p5)
%t6312 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6308, i64 %p0, i64 %t6311, i64 %p6, i64 %p7)
ret i64 %t6312
L1929:
%t6313 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6308)
%t6314 = call i64 @__mruntime_rt_dec_resid__sub_n(i64 %t6313, i64 %p4, i64 %p5, i64 %p2, i64 %p3)
%t6315 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6308, i64 %p1, i64 %t6314, i64 %p6, i64 %p7)
ret i64 %t6315
}
define internal i64 @__mruntime_rt_dec_resid__mul_v(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6316 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6317 = icmp eq i64 %t6316, 0
br label %LSL6318
LSL6318:
br i1 %t6317, label %LSJ6318, label %LSR6318
LSR6318:
%t6319 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t6320 = icmp eq i64 %t6319, 0
br label %LSJ6318
LSJ6318:
%t6321 = phi i1 [ true, %LSL6318 ], [ %t6320, %LSR6318 ]
br i1 %t6321, label %L1930, label %L1932
L1930:
%t6322 = call i64 @__mruntime_rt_dec_resid__dzero(i64 %p2)
ret i64 %t6322
L1932:
%t6323 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6324 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t6325 = icmp eq i64 %t6323, %t6324
br i1 %t6325, label %L1933, label %L1934
L1933:
br label %L1935
L1934:
%t6326 = sub nsw i64 0, 1
br label %L1935
L1935:
%t6327 = phi i64 [ 1, %L1933 ], [ %t6326, %L1934 ]
%t6328 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t6329 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p1)
%t6330 = add i64 %t6328, %t6329
%t6331 = call i64 @dn(i64 %p0)
%t6332 = call i64 @dn(i64 %p1)
%t6333 = add i64 %t6331, %t6332
%t6334 = add i64 %t6333, 1
%t6335 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 %t6334)
%t6336 = icmp eq i64 %t6332, 1
br i1 %t6336, label %L1936, label %L1938
L1936:
%t6337 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6335)
%t6338 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6339 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t6340 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6339)
%t6341 = call i64 @__mruntime_rt_dec_resid__mul1(i64 %t6337, i64 %t6338, i64 %t6331, i64 %t6340)
%t6342 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6335, i64 %t6327, i64 %t6341, i64 %t6330, i64 %p2)
ret i64 %t6342
L1938:
%t6343 = icmp eq i64 %t6331, 1
br i1 %t6343, label %L1939, label %L1941
L1939:
%t6344 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6335)
%t6345 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t6346 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6347 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6346)
%t6348 = call i64 @__mruntime_rt_dec_resid__mul1(i64 %t6344, i64 %t6345, i64 %t6332, i64 %t6347)
%t6349 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6335, i64 %t6327, i64 %t6348, i64 %t6330, i64 %p2)
ret i64 %t6349
L1941:
%t6350 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6335)
%t6351 = add i64 %t6331, %t6332
%t6352 = mul i64 %t6351, 8
%t6353p = inttoptr i64 %t6350 to ptr
%t6353q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t6353p, i8 %t6353q, i64 %t6352, i1 false)
%t6353 = add i64 0, 0
%t6354 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6335)
%t6355 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6356 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t6357 = call i64 @__mruntime_rt_dec_resid__mul_rows(i64 %t6354, i64 %t6355, i64 %t6331, i64 %t6356, i64 %t6332, i64 0)
%t6358 = add i64 %t6331, %t6332
%t6359 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6335, i64 %t6327, i64 %t6358, i64 %t6330, i64 %p2)
ret i64 %t6359
}
define internal i64 @__mruntime_rt_dec_resid__mul_rows(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t6374, %tco.s0 ]
%t6360 = icmp sge i64 %p5, %p2
br i1 %t6360, label %L1942, label %L1944
L1942:
ret i64 0
L1944:
%t6361 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p5)
%t6362 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6361)
%t6363 = add i64 0, 0
%t6364 = add i64 %t6363, 0
%t6370 = icmp ne i64 %t6362, %t6364
br i1 %t6370, label %L1945, label %L1946
L1945:
%t6371 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p5)
%t6372 = call i64 @__mruntime_rt_dec_resid__mul_row(i64 %t6371, i64 %t6362, i64 %p3, i64 %p4)
br label %L1947
L1946:
br label %L1947
L1947:
%t6373 = phi i64 [ %t6372, %L1945 ], [ 0, %L1946 ]
%t6374 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__mul_row(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6376 = add i64 0, 0
%t6377 = add i64 %t6376, 0
%t6383 = add i64 0, 0
%t6384 = add i64 %t6383, 0
%t6390 = call i64 @__mruntime_rt_dec_resid__mul_row_at(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 %t6377, i64 %t6384)
ret i64 %t6390
}
define internal i64 @__mruntime_rt_dec_resid__mul_row_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t6424, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t6404, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %t6439, %tco.s0 ]
%t6391 = icmp sge i64 %p4, %p3
br i1 %t6391, label %L1948, label %L1950
L1948:
%t6392 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p3)
%t6393 = add i64 %p5, %p6
%t6394 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6392, i64 %t6393)
ret i64 %t6394
L1950:
%t6395 = zext i64 %p1 to i128
%t6396 = call i64 @__mruntime_rt_dec_resid__li(i64 %p2, i64 %p4)
%t6397 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6396)
%t6398 = zext i64 %t6397 to i128
%t6399 = mul i128 %t6395, %t6398
%t6400 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p4)
%t6401 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6400)
%t6402 = zext i64 %t6401 to i128
%t6403 = add i128 %t6399, %t6402
%t6404 = call i64 @__mruntime_rt_dec_resid__div_b(i128 %t6403)
%t6405 = add i128 %t6403, 0
%t6406 = trunc i128 %t6405 to i64
%t6412 = call i64 @__mruntime_rt_dec_resid__bb()
%t6413 = mul i64 %t6404, %t6412
%t6414 = sub i64 %t6406, %t6413
%t6415 = add i64 %t6414, %p6
%t6416 = call i64 @__mruntime_rt_dec_resid__bb()
%t6417 = sub i64 %t6416, %p5
%t6418 = icmp uge i64 %t6415, %t6417
%t6419 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p4)
br i1 %t6418, label %L1951, label %L1952
L1951:
%t6420 = sub i64 %t6415, %t6417
br label %L1953
L1952:
%t6421 = add i64 %t6415, %p5
br label %L1953
L1953:
%t6422 = phi i64 [ %t6420, %L1951 ], [ %t6421, %L1952 ]
%t6423 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6419, i64 %t6422)
%t6424 = add nsw i64 %p4, 1
br i1 %t6418, label %L1954, label %L1955
L1954:
%t6425 = add i64 1, 0
%t6426 = add i64 %t6425, 0
br label %L1956
L1955:
%t6432 = add i64 0, 0
%t6433 = add i64 %t6432, 0
br label %L1956
L1956:
%t6439 = phi i64 [ %t6426, %L1954 ], [ %t6433, %L1955 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__divmod_n(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6441 = call i64 @__mruntime_rt_dec_resid__bb()
%t6442 = sub i64 %p3, 1
%t6443 = call i64 @__mruntime_rt_dec_resid__li(i64 %p2, i64 %t6442)
%t6444 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6443)
%t6445 = add i64 1, 0
%t6446 = add i64 %t6445, 0
%t6452 = add i64 %t6444, %t6446
%t6453 = icmp eq i64 %t6452, 0
%t6454 = zext i1 %t6453 to i8
call void @resid_div_check(i8 %t6454)
%t6459 = udiv i64 %t6441, %t6452
%t6460 = add i64 1, 0
%t6461 = add i64 %t6460, 0
%t6467 = icmp ugt i64 %t6459, %t6461
br i1 %t6467, label %L1957, label %L1958
L1957:
%t6468 = call i64 @__mruntime_rt_dec_resid__mul1(i64 %p0, i64 %p0, i64 %p1, i64 %t6459)
%t6469 = call i64 @__mruntime_rt_dec_resid__norm_v(i64 %p2, i64 %p3, i64 %t6459)
%t6470 = add i64 %t6468, %t6469
br label %L1959
L1958:
%t6471 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p1)
%t6472 = add i64 0, 0
%t6473 = add i64 %t6472, 0
%t6479 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6471, i64 %t6473)
br label %L1959
L1959:
%t6480 = phi i64 [ %t6470, %L1957 ], [ %t6479, %L1958 ]
%t6481 = sub i64 %p1, %p3
%t6482 = sub i64 %p3, 1
%t6483 = call i64 @__mruntime_rt_dec_resid__li(i64 %p2, i64 %t6482)
%t6484 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6483)
%t6485 = sub i64 %p3, 2
%t6486 = call i64 @__mruntime_rt_dec_resid__li(i64 %p2, i64 %t6485)
%t6487 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6486)
%t6488 = call i64 @__mruntime_rt_dec_resid__div_steps(i64 %p0, i64 %p2, i64 %p3, i64 %p4, i64 %t6481, i64 %t6484, i64 %t6487)
ret i64 %t6488
}
define internal i64 @__mruntime_rt_dec_resid__norm_v(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6489 = add i64 %p1, 1
%t6490 = call i64 @__mruntime_rt_dec_resid__tmp_limbs(i64 %t6489)
%t6491 = call i64 @__mruntime_rt_dec_resid__mul1(i64 %t6490, i64 %p0, i64 %p1, i64 %p2)
%t6492 = mul i64 %p1, 8
%t6493 = call i64 @mcopy(i64 %p0, i64 %t6490, i64 %t6492)
%t6494 = call i64 @c_free(i64 %t6490)
ret i64 %t6494
}
define internal i64 @__mruntime_rt_dec_resid__div_steps(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t6582, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ]
%t6495 = icmp slt i64 %p4, 0
br i1 %t6495, label %L1960, label %L1962
L1960:
ret i64 0
L1962:
%t6496 = add i64 %p4, %p2
%t6497 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6496)
%t6498 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6497)
%t6499 = zext i64 %t6498 to i128
%t6500 = call i64 @__mruntime_rt_dec_resid__bb()
%t6501 = zext i64 %t6500 to i128
%t6502 = mul i128 %t6499, %t6501
%t6503 = add i64 %p4, %p2
%t6504 = sub i64 %t6503, 1
%t6505 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6504)
%t6506 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6505)
%t6507 = zext i64 %t6506 to i128
%t6508 = add i128 %t6502, %t6507
%t6509 = zext i64 %p5 to i128
%t6510 = icmp eq i128 %t6509, 0
%t6511 = zext i1 %t6510 to i8
call void @resid_div_check(i8 %t6511)
%t6516 = udiv i128 %t6508, %t6509
%t6517 = zext i64 %p5 to i128
%t6518 = mul i128 %t6516, %t6517
%t6519 = sub i128 %t6508, %t6518
%t6520 = add i64 %p4, %p2
%t6521 = sub i64 %t6520, 2
%t6522 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6521)
%t6523 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6522)
%t6524 = call i128 @__mruntime_rt_dec_resid__qhat_fix(i128 %t6516, i128 %t6519, i64 %p5, i64 %p6, i64 %t6523)
%t6525 = add i128 %t6524, 0
%t6526 = trunc i128 %t6525 to i64
%t6532 = add i64 0, 0
%t6533 = add i64 %t6532, 0
%t6539 = add i64 0, 0
%t6540 = add i64 %t6539, 0
%t6546 = call i64 @__mruntime_rt_dec_resid__sub_mul(i64 %p0, i64 %p1, i64 %p2, i64 %p4, i64 %t6526, i64 0, i64 %t6533, i64 %t6540)
%t6547 = call i64 @__mruntime_rt_dec_resid__r2()
%t6548 = call i64 @ld64(i64 %t6547)
%t6549 = add i64 %t6548, 0
%t6550 = add i64 %t6549, 0
%t6556 = add i64 %p4, %p2
%t6557 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6556)
%t6558 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6557)
%t6559 = add i64 %t6546, %t6550
%t6560 = icmp ult i64 %t6558, %t6559
%t6561 = add i64 %p4, %p2
%t6562 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6561)
br i1 %t6560, label %L1963, label %L1964
L1963:
%t6563 = call i64 @__mruntime_rt_dec_resid__bb()
%t6564 = sub i64 %t6563, %t6559
%t6565 = add i64 %t6558, %t6564
br label %L1965
L1964:
%t6566 = sub i64 %t6558, %t6559
br label %L1965
L1965:
%t6567 = phi i64 [ %t6565, %L1963 ], [ %t6566, %L1964 ]
%t6568 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6562, i64 %t6567)
br i1 %t6560, label %L1966, label %L1967
L1966:
%t6569 = call i64 @__mruntime_rt_dec_resid__add_back(i64 %p0, i64 %p1, i64 %p2, i64 %p4)
br label %L1968
L1967:
br label %L1968
L1968:
%t6570 = phi i64 [ %t6569, %L1966 ], [ 0, %L1967 ]
br i1 %t6560, label %L1969, label %L1970
L1969:
%t6571 = add i64 1, 0
%t6572 = add i64 %t6571, 0
%t6578 = sub i64 %t6526, %t6572
br label %L1971
L1970:
br label %L1971
L1971:
%t6579 = phi i64 [ %t6578, %L1969 ], [ %t6526, %L1970 ]
%t6580 = call i64 @__mruntime_rt_dec_resid__li(i64 %p3, i64 %p4)
%t6581 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6580, i64 %t6579)
%t6582 = sub nsw i64 %p4, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i128 @__mruntime_rt_dec_resid__qhat_fix(i128 %p0.in, i128 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i128 [ %p0.in, %entry ], [ %t6618, %tco.s0 ]
%p1 = phi i128 [ %p1.in, %entry ], [ %t6599, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t6584 = call i64 @__mruntime_rt_dec_resid__bb()
%t6585 = zext i64 %t6584 to i128
%t6586 = icmp uge i128 %p0, %t6585
br label %LSL6587
LSL6587:
br i1 %t6586, label %LSJ6587, label %LSR6587
LSR6587:
%t6588 = zext i64 %p3 to i128
%t6589 = mul i128 %p0, %t6588
%t6590 = call i64 @__mruntime_rt_dec_resid__bb()
%t6591 = zext i64 %t6590 to i128
%t6592 = mul i128 %p1, %t6591
%t6593 = zext i64 %p4 to i128
%t6594 = add i128 %t6592, %t6593
%t6595 = icmp ugt i128 %t6589, %t6594
br label %LSJ6587
LSJ6587:
%t6596 = phi i1 [ true, %LSL6587 ], [ %t6595, %LSR6587 ]
%t6597 = xor i1 %t6596, true
br i1 %t6597, label %L1972, label %L1974
L1972:
ret i128 %p0
L1974:
%t6598 = zext i64 %p2 to i128
%t6599 = add i128 %p1, %t6598
%t6600 = call i64 @__mruntime_rt_dec_resid__bb()
%t6601 = zext i64 %t6600 to i128
%t6602 = icmp uge i128 %t6599, %t6601
br i1 %t6602, label %L1975, label %L1977
L1975:
%t6603 = sext i64 1 to i128
%t6604 = add i128 %t6603, 0
%t6610 = sub i128 %p0, %t6604
ret i128 %t6610
L1977:
%t6611 = sext i64 1 to i128
%t6612 = add i128 %t6611, 0
%t6618 = sub i128 %p0, %t6612
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__sub_mul(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t6661, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %t6637, %tco.s0 ]
%p7 = phi i64 [ %p7.in, %entry ], [ %t6676, %tco.s0 ]
%t6620 = icmp sge i64 %p5, %p2
br i1 %t6620, label %L1978, label %L1980
L1978:
%t6621 = call i64 @__mruntime_rt_dec_resid__r2()
%t6622 = add i64 %p7, 0
%t6623 = add i64 %t6622, 0
%t6629 = call i64 @st64(i64 %t6621, i64 %t6623)
ret i64 %p6
L1980:
%t6630 = zext i64 %p4 to i128
%t6631 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p5)
%t6632 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6631)
%t6633 = zext i64 %t6632 to i128
%t6634 = mul i128 %t6630, %t6633
%t6635 = zext i64 %p6 to i128
%t6636 = add i128 %t6634, %t6635
%t6637 = call i64 @__mruntime_rt_dec_resid__div_b(i128 %t6636)
%t6638 = add i128 %t6636, 0
%t6639 = trunc i128 %t6638 to i64
%t6645 = call i64 @__mruntime_rt_dec_resid__bb()
%t6646 = mul i64 %t6637, %t6645
%t6647 = sub i64 %t6639, %t6646
%t6648 = add i64 %p5, %p3
%t6649 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6648)
%t6650 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6649)
%t6651 = add i64 %t6647, %p7
%t6652 = icmp uge i64 %t6650, %t6651
%t6653 = add i64 %p5, %p3
%t6654 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6653)
br i1 %t6652, label %L1981, label %L1982
L1981:
%t6655 = sub i64 %t6650, %t6651
br label %L1983
L1982:
%t6656 = call i64 @__mruntime_rt_dec_resid__bb()
%t6657 = sub i64 %t6656, %t6651
%t6658 = add i64 %t6650, %t6657
br label %L1983
L1983:
%t6659 = phi i64 [ %t6655, %L1981 ], [ %t6658, %L1982 ]
%t6660 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6654, i64 %t6659)
%t6661 = add nsw i64 %p5, 1
br i1 %t6652, label %L1984, label %L1985
L1984:
%t6662 = add i64 0, 0
%t6663 = add i64 %t6662, 0
br label %L1986
L1985:
%t6669 = add i64 1, 0
%t6670 = add i64 %t6669, 0
br label %L1986
L1986:
%t6676 = phi i64 [ %t6663, %L1984 ], [ %t6670, %L1985 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__add_back(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6678 = add i64 0, 0
%t6679 = add i64 %t6678, 0
%t6685 = call i64 @__mruntime_rt_dec_resid__add_back_at(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 %t6679)
%t6686 = add i64 %p3, %p2
%t6687 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6686)
%t6688 = add i64 %p3, %p2
%t6689 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6688)
%t6690 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6689)
%t6691 = add i64 %t6690, %t6685
%t6692 = call i64 @__mruntime_rt_dec_resid__bb()
%t6693 = icmp eq i64 %t6692, 0
%t6694 = zext i1 %t6693 to i8
call void @resid_div_check(i8 %t6694)
%t6699 = urem i64 %t6691, %t6692
%t6700 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6687, i64 %t6699)
ret i64 %t6700
}
define internal i64 @__mruntime_rt_dec_resid__add_back_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t6717, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t6732, %tco.s0 ]
%t6701 = icmp sge i64 %p4, %p2
br i1 %t6701, label %L1987, label %L1989
L1987:
ret i64 %p5
L1989:
%t6702 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p4)
%t6703 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6702)
%t6704 = add i64 %p4, %p3
%t6705 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6704)
%t6706 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6705)
%t6707 = add i64 %t6706, %p5
%t6708 = call i64 @__mruntime_rt_dec_resid__bb()
%t6709 = sub i64 %t6708, %t6703
%t6710 = icmp uge i64 %t6707, %t6709
%t6711 = add i64 %p4, %p3
%t6712 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6711)
br i1 %t6710, label %L1990, label %L1991
L1990:
%t6713 = sub i64 %t6707, %t6709
br label %L1992
L1991:
%t6714 = add i64 %t6707, %t6703
br label %L1992
L1992:
%t6715 = phi i64 [ %t6713, %L1990 ], [ %t6714, %L1991 ]
%t6716 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6712, i64 %t6715)
%t6717 = add nsw i64 %p4, 1
br i1 %t6710, label %L1993, label %L1994
L1993:
%t6718 = add i64 1, 0
%t6719 = add i64 %t6718, 0
br label %L1995
L1994:
%t6725 = add i64 0, 0
%t6726 = add i64 %t6725, 0
br label %L1995
L1995:
%t6732 = phi i64 [ %t6719, %L1993 ], [ %t6726, %L1994 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__div_v(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6734 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t6735 = icmp eq i64 %t6734, 0
br i1 %t6735, label %L1996, label %L1998
L1996:
%t6737 = call i64 @rt_abort(ptr @.s6736)
ret i64 %t6737
L1998:
%t6738 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6739 = icmp eq i64 %t6738, 0
br i1 %t6739, label %L1999, label %L2001
L1999:
%t6740 = call i64 @__mruntime_rt_dec_resid__dzero(i64 %p2)
ret i64 %t6740
L2001:
%t6741 = add i64 %p2, 2
%t6742 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t6743 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p1)
%t6744 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6745 = call i64 @dn(i64 %p0)
%t6746 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t6747 = call i64 @dn(i64 %p1)
%t6748 = sub i64 %t6742, %t6743
%t6749 = call i64 @__mruntime_rt_dec_resid__cmp_mag(i64 %t6744, i64 %t6745, i64 %t6742, i64 0, i64 %t6746, i64 %t6747, i64 %t6743, i64 %t6748)
%t6750 = sub i64 %t6742, %t6743
%t6751 = icmp slt i64 %t6749, 0
br i1 %t6751, label %L2002, label %L2003
L2002:
br label %L2004
L2003:
br label %L2004
L2004:
%t6752 = phi i64 [ 1, %L2002 ], [ 0, %L2003 ]
%t6753 = sub i64 %t6750, %t6752
%t6754 = sub nsw i64 %t6741, 1
%t6755 = sub i64 %t6754, %t6753
%t6756 = icmp sge i64 %t6755, 0
br i1 %t6756, label %L2005, label %L2006
L2005:
%t6757 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6758 = call i64 @dn(i64 %p0)
%t6759 = call i64 @__mruntime_rt_dec_resid__scale(i64 %t6757, i64 %t6758, i64 %t6755)
br label %L2007
L2006:
%t6760 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6761 = call i64 @dn(i64 %p0)
%t6762 = call i64 @dn(i64 %p0)
%t6763 = add i64 %t6762, 1
%t6764 = call i64 @__mruntime_rt_dec_resid__copy_limbs(i64 %t6760, i64 %t6761, i64 %t6763)
br label %L2007
L2007:
%t6765 = phi i64 [ %t6759, %L2005 ], [ %t6764, %L2006 ]
%t6766 = icmp sge i64 %t6755, 0
br i1 %t6766, label %L2008, label %L2009
L2008:
%t6767 = call i64 @__mruntime_rt_dec_resid__r2()
%t6768 = call i64 @ld64(i64 %t6767)
br label %L2010
L2009:
%t6769 = call i64 @dn(i64 %p0)
br label %L2010
L2010:
%t6770 = phi i64 [ %t6768, %L2008 ], [ %t6769, %L2009 ]
%t6771 = icmp sge i64 %t6755, 0
br i1 %t6771, label %L2011, label %L2012
L2011:
%t6772 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t6773 = call i64 @dn(i64 %p1)
%t6774 = call i64 @dn(i64 %p1)
%t6775 = call i64 @__mruntime_rt_dec_resid__copy_limbs(i64 %t6772, i64 %t6773, i64 %t6774)
br label %L2013
L2012:
%t6776 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t6777 = call i64 @dn(i64 %p1)
%t6778 = sub i64 0, %t6755
%t6779 = call i64 @__mruntime_rt_dec_resid__scale(i64 %t6776, i64 %t6777, i64 %t6778)
br label %L2013
L2013:
%t6780 = phi i64 [ %t6775, %L2011 ], [ %t6779, %L2012 ]
%t6781 = icmp sge i64 %t6755, 0
br i1 %t6781, label %L2014, label %L2015
L2014:
%t6782 = call i64 @dn(i64 %p1)
br label %L2016
L2015:
%t6783 = call i64 @__mruntime_rt_dec_resid__r2()
%t6784 = call i64 @ld64(i64 %t6783)
br label %L2016
L2016:
%t6785 = phi i64 [ %t6782, %L2014 ], [ %t6784, %L2015 ]
%t6786 = sub i64 %t6770, %t6785
%t6787 = add i64 %t6786, 1
%t6788 = icmp sgt i64 %t6787, 1
br i1 %t6788, label %L2017, label %L2018
L2017:
br label %L2019
L2018:
br label %L2019
L2019:
%t6789 = phi i64 [ %t6787, %L2017 ], [ 1, %L2018 ]
%t6790 = add i64 %t6789, 1
%t6791 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 %t6790)
%t6792 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6791)
%t6793 = add i64 %t6789, 1
%t6794 = mul i64 %t6793, 8
%t6795p = inttoptr i64 %t6792 to ptr
%t6795q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t6795p, i8 %t6795q, i64 %t6794, i1 false)
%t6795 = add i64 0, 0
%t6796 = icmp slt i64 %t6770, %t6785
br i1 %t6796, label %L2020, label %L2022
L2020:
%t6798 = call i64 @rt_abort(ptr @.s6797)
ret i64 %t6798
L2022:
%t6799 = icmp eq i64 %t6785, 1
br i1 %t6799, label %L2023, label %L2024
L2023:
%t6800 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6791)
%t6801 = sub i64 %t6770, 1
%t6802 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6780)
%t6803 = sext i64 0 to i128
%t6804 = add i128 %t6803, 0
%t6810 = call i64 @__mruntime_rt_dec_resid__div_small(i64 %t6800, i64 %t6765, i64 %t6801, i64 %t6802, i128 %t6804)
br label %L2025
L2024:
%t6811 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6791)
%t6812 = call i64 @__mruntime_rt_dec_resid__div_big(i64 %t6765, i64 %t6770, i64 %t6780, i64 %t6785, i64 %t6811)
br label %L2025
L2025:
%t6813 = phi i64 [ %t6810, %L2023 ], [ %t6812, %L2024 ]
%t6814 = call i64 @c_free(i64 %t6765)
%t6815 = call i64 @c_free(i64 %t6780)
%t6816 = add i64 %t6814, %t6815
%t6817 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6818 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t6819 = icmp eq i64 %t6817, %t6818
br i1 %t6819, label %L2026, label %L2027
L2026:
br label %L2028
L2027:
%t6820 = sub nsw i64 0, 1
br label %L2028
L2028:
%t6821 = phi i64 [ 1, %L2026 ], [ %t6820, %L2027 ]
%t6822 = add i64 %t6789, 1
%t6823 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t6824 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p1)
%t6825 = sub i64 %t6823, %t6824
%t6826 = sub i64 %t6825, %t6755
%t6827 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6791, i64 %t6821, i64 %t6822, i64 %t6826, i64 %p2)
ret i64 %t6827
}
define internal i64 @__mruntime_rt_dec_resid__copy_limbs(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6828 = call i64 @__mruntime_rt_dec_resid__tmp_limbs(i64 %p2)
%t6829 = mul i64 %p1, 8
%t6830 = call i64 @mcopy(i64 %t6828, i64 %p0, i64 %t6829)
%t6831 = mul nsw i64 %t6830, 0
%t6832 = add nsw i64 %t6831, %t6828
ret i64 %t6832
}
define internal i64 @__mruntime_rt_dec_resid__div_small(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i128 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6858, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i128 [ %p4.in, %entry ], [ %t6861, %tco.s0 ]
%t6833 = icmp slt i64 %p2, 0
br i1 %t6833, label %L2029, label %L2031
L2029:
ret i64 0
L2031:
%t6834 = call i64 @__mruntime_rt_dec_resid__bb()
%t6835 = zext i64 %t6834 to i128
%t6836 = mul i128 %p4, %t6835
%t6837 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p2)
%t6838 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6837)
%t6839 = zext i64 %t6838 to i128
%t6840 = add i128 %t6836, %t6839
%t6841 = zext i64 %p3 to i128
%t6842 = icmp eq i128 %t6841, 0
%t6843 = zext i1 %t6842 to i8
call void @resid_div_check(i8 %t6843)
%t6848 = udiv i128 %t6840, %t6841
%t6849 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t6850 = add i128 %t6848, 0
%t6851 = trunc i128 %t6850 to i64
%t6857 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6849, i64 %t6851)
%t6858 = sub nsw i64 %p2, 1
%t6859 = zext i64 %p3 to i128
%t6860 = mul i128 %t6848, %t6859
%t6861 = sub i128 %t6840, %t6860
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__div_big(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6863 = add i64 %p1, 1
%t6864 = call i64 @__mruntime_rt_dec_resid__tmp_limbs(i64 %t6863)
%t6865 = mul i64 %p1, 8
%t6866 = call i64 @mcopy(i64 %t6864, i64 %p0, i64 %t6865)
%t6867 = call i64 @__mruntime_rt_dec_resid__li(i64 %t6864, i64 %p1)
%t6868 = add i64 0, 0
%t6869 = add i64 %t6868, 0
%t6875 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6867, i64 %t6869)
%t6876 = call i64 @__mruntime_rt_dec_resid__divmod_n(i64 %t6864, i64 %p1, i64 %p2, i64 %p3, i64 %p4)
%t6877 = call i64 @c_free(i64 %t6864)
ret i64 %t6877
}
define internal i64 @__mruntime_rt_dec_resid__coef_digits(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6878 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t6879 = add i64 %t6878, 1
%t6880 = call i64 @xmalloc(i64 %t6879)
%t6881 = add i64 %t6880, %t6878
%t6882 = call i64 @st8(i64 %t6881, i64 0)
%t6883 = call i64 @__mruntime_rt_dec_resid__digits_limbs(i64 %p0, i64 %t6880, i64 0, i64 %t6878)
ret i64 %t6880
}
define internal i64 @__mruntime_rt_dec_resid__digits_limbs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6896, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t6895, %tco.s0 ]
%t6884 = call i64 @dn(i64 %p0)
%t6885 = icmp sge i64 %p2, %t6884
br i1 %t6885, label %L2032, label %L2034
L2032:
ret i64 0
L2034:
%t6886 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6887 = call i64 @__mruntime_rt_dec_resid__li(i64 %t6886, i64 %p2)
%t6888 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6887)
%t6889 = call i64 @dn(i64 %p0)
%t6890 = sub i64 %t6889, 1
%t6891 = icmp eq i64 %p2, %t6890
br i1 %t6891, label %L2035, label %L2036
L2035:
%t6892 = call i64 @__mruntime_rt_dec_resid__ndig64(i64 %t6888)
br label %L2037
L2036:
%t6893 = call i64 @__mruntime_rt_dec_resid__ld_()
br label %L2037
L2037:
%t6894 = phi i64 [ %t6892, %L2035 ], [ %t6893, %L2036 ]
%t6895 = call i64 @__mruntime_rt_dec_resid__digits_one(i64 %p1, i64 %t6888, i64 %t6894, i64 %p3)
%t6896 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__digits_one(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6937, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6938, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t6939, %tco.s0 ]
%t6898 = icmp eq i64 %p2, 0
br i1 %t6898, label %L2038, label %L2040
L2038:
ret i64 %p3
L2040:
%t6899 = add i64 %p0, %p3
%t6900 = sub i64 %t6899, 1
%t6901 = add i64 10, 0
%t6902 = add i64 %t6901, 0
%t6908 = icmp eq i64 %t6902, 0
%t6909 = zext i1 %t6908 to i8
call void @resid_div_check(i8 %t6909)
%t6914 = urem i64 %p1, %t6902
%t6915 = add i64 %t6914, 0
%t6916 = add i64 %t6915, 0
%t6922 = add i64 48, %t6916
%t6923 = call i64 @st8(i64 %t6900, i64 %t6922)
%t6924 = add i64 10, 0
%t6925 = add i64 %t6924, 0
%t6931 = icmp eq i64 %t6925, 0
%t6932 = zext i1 %t6931 to i8
call void @resid_div_check(i8 %t6932)
%t6937 = udiv i64 %p1, %t6925
%t6938 = sub i64 %p2, 1
%t6939 = sub i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__parse_digits(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6941 = call i64 @__mruntime_rt_dec_resid__ld_()
%t6942 = add i64 %p1, %t6941
%t6943 = sub i64 %t6942, 1
%t6944 = call i64 @__mruntime_rt_dec_resid__ld_()
%t6945 = icmp eq i64 %t6944, 0
%t6946 = zext i1 %t6945 to i8
call void @resid_div_check(i8 %t6946)
%t6947 = icmp eq i64 %t6944, -1
%t6948 = icmp eq i64 %t6943, -9223372036854775808
%t6949 = and i1 %t6947, %t6948
%t6952 = zext i1 %t6949 to i8
call void @resid_overflow_check(i8 %t6952)
%t6950 = add i64 %t6944, 0
%t6951 = sdiv i64 %t6943, %t6950
%t6953 = add i64 %t6951, 1
%t6954 = call i64 @__mruntime_rt_dec_resid__tmp_limbs(i64 %t6953)
%t6955 = call i64 @__mruntime_rt_dec_resid__parse_limbs(i64 %p0, i64 %t6954, i64 0, i64 %t6951, i64 %p1)
%t6956 = call i64 @__mruntime_rt_dec_resid__r2()
%t6957 = call i64 @__mruntime_rt_dec_resid__top(i64 %t6954, i64 %t6951)
%t6958 = call i64 @st64(i64 %t6956, i64 %t6957)
ret i64 %t6954
}
define internal i64 @__mruntime_rt_dec_resid__parse_limbs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6974, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t6963, %tco.s0 ]
%t6959 = icmp sge i64 %p2, %p3
br i1 %t6959, label %L2041, label %L2043
L2041:
ret i64 0
L2043:
%t6960 = call i64 @__mruntime_rt_dec_resid__ld_()
%t6961 = sub i64 %p4, %t6960
%t6962 = icmp sgt i64 %t6961, 0
br i1 %t6962, label %L2044, label %L2045
L2044:
br label %L2046
L2045:
br label %L2046
L2046:
%t6963 = phi i64 [ %t6961, %L2044 ], [ 0, %L2045 ]
%t6964 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p2)
%t6965 = add i64 0, 0
%t6966 = add i64 %t6965, 0
%t6972 = call i64 @__mruntime_rt_dec_resid__digits_value(i64 %p0, i64 %t6963, i64 %p4, i64 %t6966)
%t6973 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6964, i64 %t6972)
%t6974 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__digits_value(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6977, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t6996, %tco.s0 ]
%t6976 = icmp sge i64 %p1, %p2
br i1 %t6976, label %L2047, label %L2049
L2047:
ret i64 %p3
L2049:
%t6977 = add nsw i64 %p1, 1
%t6978 = add i64 10, 0
%t6979 = add i64 %t6978, 0
%t6985 = mul i64 %p3, %t6979
%t6986 = add i64 %p0, %p1
%t6987 = call i64 @ld8(i64 %t6986)
%t6988 = sub i64 %t6987, 48
%t6989 = add i64 %t6988, 0
%t6990 = add i64 %t6989, 0
%t6996 = add i64 %t6985, %t6990
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_dec_resid__is_dig(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6998 = icmp sge i64 %p0, 48
br label %LSL6999
LSL6999:
br i1 %t6998, label %LSR6999, label %LSJ6999
LSR6999:
%t7000 = icmp sle i64 %p0, 57
br label %LSJ6999
LSJ6999:
%t7001 = phi i1 [ false, %LSL6999 ], [ %t7000, %LSR6999 ]
ret i1 %t7001
}
define internal i64 @__mruntime_rt_dec_resid__take_digits(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t7012, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t7013, %tco.s0 ]
%t7002 = call i64 @ld8(i64 %p0)
%t7003 = call i1 @__mruntime_rt_dec_resid__is_dig(i64 %t7002)
%t7004 = xor i1 %t7003, true
br i1 %t7004, label %L2050, label %L2052
L2050:
%t7005 = call i64 @__mruntime_rt_dec_resid__r2()
%t7006 = call i64 @st64(i64 %t7005, i64 %p0)
%t7007 = mul nsw i64 %t7006, 0
%t7008 = add nsw i64 %t7007, %p2
ret i64 %t7008
L2052:
%t7009 = add i64 %p1, %p2
%t7010 = call i64 @ld8(i64 %p0)
%t7011 = call i64 @st8(i64 %t7009, i64 %t7010)
%t7012 = add i64 %p0, 1
%t7013 = add i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__exp_value(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t7027, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7031, %tco.s0 ]
%t7015 = call i64 @ld8(i64 %p0)
%t7016 = call i1 @__mruntime_rt_dec_resid__is_dig(i64 %t7015)
%t7017 = xor i1 %t7016, true
br i1 %t7017, label %L2053, label %L2055
L2053:
%t7018 = call i64 @__mruntime_rt_dec_resid__r2()
%t7019 = call i64 @st64(i64 %t7018, i64 %p0)
%t7020 = mul nsw i64 %t7019, 0
%t7021 = add nsw i64 %t7020, %p1
ret i64 %t7021
L2055:
%t7022 = call i64 @__mruntime_rt_dec_resid__max_exp()
%t7023 = sdiv i64 %t7022, 10
%t7024 = icmp sgt i64 %p1, %t7023
br i1 %t7024, label %L2056, label %L2058
L2056:
%t7026 = call i64 @rt_abort(ptr @.s7025)
ret i64 %t7026
L2058:
%t7027 = add i64 %p0, 1
%t7028 = mul i64 %p1, 10
%t7029 = call i64 @ld8(i64 %p0)
%t7030 = add i64 %t7028, %t7029
%t7031 = sub i64 %t7030, 48
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__from_str(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7033 = call i64 @ld8(i64 %p0)
%t7034 = icmp eq i64 %t7033, 45
br i1 %t7034, label %L2059, label %L2060
L2059:
%t7035 = sub nsw i64 0, 1
br label %L2061
L2060:
br label %L2061
L2061:
%t7036 = phi i64 [ %t7035, %L2059 ], [ 1, %L2060 ]
%t7037 = icmp eq i64 %t7033, 45
br label %LSL7038
LSL7038:
br i1 %t7037, label %LSJ7038, label %LSR7038
LSR7038:
%t7039 = icmp eq i64 %t7033, 43
br label %LSJ7038
LSJ7038:
%t7040 = phi i1 [ true, %LSL7038 ], [ %t7039, %LSR7038 ]
br i1 %t7040, label %L2062, label %L2063
L2062:
%t7041 = add i64 %p0, 1
br label %L2064
L2063:
br label %L2064
L2064:
%t7042 = phi i64 [ %t7041, %L2062 ], [ %p0, %L2063 ]
%t7043 = call i64 @c_strlen(i64 %t7042)
%t7044 = add i64 %t7043, 1
%t7045 = call i64 @xmalloc(i64 %t7044)
%t7046 = call i64 @__mruntime_rt_dec_resid__take_digits(i64 %t7042, i64 %t7045, i64 0)
%t7047 = call i64 @__mruntime_rt_dec_resid__r2()
%t7048 = call i64 @ld64(i64 %t7047)
%t7049 = call i64 @ld8(i64 %t7048)
%t7050 = icmp eq i64 %t7049, 46
br i1 %t7050, label %L2065, label %L2066
L2065:
%t7051 = add i64 %t7048, 1
%t7052 = call i64 @__mruntime_rt_dec_resid__take_digits(i64 %t7051, i64 %t7045, i64 %t7046)
br label %L2067
L2066:
br label %L2067
L2067:
%t7053 = phi i64 [ %t7052, %L2065 ], [ %t7046, %L2066 ]
br i1 %t7050, label %L2068, label %L2069
L2068:
%t7054 = call i64 @__mruntime_rt_dec_resid__r2()
%t7055 = call i64 @ld64(i64 %t7054)
br label %L2070
L2069:
br label %L2070
L2070:
%t7056 = phi i64 [ %t7055, %L2068 ], [ %t7048, %L2069 ]
%t7057 = sub i64 %t7053, %t7046
%t7058 = sub i64 0, %t7057
%t7059 = call i64 @ld8(i64 %t7056)
%t7060 = icmp eq i64 %t7059, 101
br label %LSL7061
LSL7061:
br i1 %t7060, label %LSJ7061, label %LSR7061
LSR7061:
%t7062 = icmp eq i64 %t7059, 69
br label %LSJ7061
LSJ7061:
%t7063 = phi i1 [ true, %LSL7061 ], [ %t7062, %LSR7061 ]
%t7064 = add i64 %t7056, 1
br label %LSL7065
LSL7065:
br i1 %t7063, label %LSR7065, label %LSJ7065
LSR7065:
%t7066 = call i64 @ld8(i64 %t7064)
%t7067 = icmp eq i64 %t7066, 45
br label %LSJ7065
LSJ7065:
%t7068 = phi i1 [ false, %LSL7065 ], [ %t7067, %LSR7065 ]
br i1 %t7068, label %L2071, label %L2072
L2071:
%t7069 = sub nsw i64 0, 1
br label %L2073
L2072:
br label %L2073
L2073:
%t7070 = phi i64 [ %t7069, %L2071 ], [ 1, %L2072 ]
br label %LSL7071
LSL7071:
br i1 %t7063, label %LSR7071, label %LSJ7071
LSR7071:
%t7072 = call i64 @ld8(i64 %t7064)
%t7073 = icmp eq i64 %t7072, 45
br label %LSL7074
LSL7074:
br i1 %t7073, label %LSJ7074, label %LSR7074
LSR7074:
%t7075 = call i64 @ld8(i64 %t7064)
%t7076 = icmp eq i64 %t7075, 43
br label %LSJ7074
LSJ7074:
%t7077 = phi i1 [ true, %LSL7074 ], [ %t7076, %LSR7074 ]
br label %LSJ7071
LSJ7071:
%t7078 = phi i1 [ false, %LSL7071 ], [ %t7077, %LSJ7074 ]
br i1 %t7078, label %L2074, label %L2075
L2074:
%t7079 = add i64 %t7064, 1
br label %L2076
L2075:
br label %L2076
L2076:
%t7080 = phi i64 [ %t7079, %L2074 ], [ %t7064, %L2075 ]
br i1 %t7063, label %L2077, label %L2078
L2077:
%t7081 = call i64 @__mruntime_rt_dec_resid__exp_value(i64 %t7080, i64 0)
br label %L2079
L2078:
br label %L2079
L2079:
%t7082 = phi i64 [ %t7081, %L2077 ], [ 0, %L2078 ]
br i1 %t7063, label %L2080, label %L2081
L2080:
%t7083 = call i64 @__mruntime_rt_dec_resid__r2()
%t7084 = call i64 @ld64(i64 %t7083)
br label %L2082
L2081:
br label %L2082
L2082:
%t7085 = phi i64 [ %t7084, %L2080 ], [ %t7056, %L2081 ]
%t7086 = icmp eq i64 %t7053, 0
br label %LSL7087
LSL7087:
br i1 %t7086, label %LSJ7087, label %LSR7087
LSR7087:
%t7088 = call i64 @ld8(i64 %t7085)
%t7089 = icmp ne i64 %t7088, 0
br label %LSJ7087
LSJ7087:
%t7090 = phi i1 [ true, %LSL7087 ], [ %t7089, %LSR7087 ]
br i1 %t7090, label %L2083, label %L2085
L2083:
%t7092 = call i64 @rt_abort(ptr @.s7091)
ret i64 %t7092
L2085:
%t7093 = call i64 @__mruntime_rt_dec_resid__parse_digits(i64 %t7045, i64 %t7053)
%t7094 = call i64 @__mruntime_rt_dec_resid__r2()
%t7095 = call i64 @ld64(i64 %t7094)
%t7096 = call i64 @c_free(i64 %t7045)
%t7097 = mul i64 %t7070, %t7082
%t7098 = add i64 %t7058, %t7097
%t7099 = call i64 @__mruntime_rt_dec_resid__from_limbs(i64 %t7036, i64 %t7093, i64 %t7095, i64 %t7098, i64 %p1)
%t7100 = call i64 @c_free(i64 %t7093)
%t7101 = mul nsw i64 %t7100, 0
%t7102 = add nsw i64 %t7101, %t7099
ret i64 %t7102
}
define internal i64 @__mruntime_rt_dec_resid__from_i64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7103 = icmp eq i64 %p0, 0
br i1 %t7103, label %L2086, label %L2088
L2086:
%t7104 = call i64 @__mruntime_rt_dec_resid__dzero(i64 %p1)
ret i64 %t7104
L2088:
%t7105p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dec_one)
%t7105 = ptrtoint ptr %t7105p to i64
%t7106 = icmp slt i64 %p0, 0
br i1 %t7106, label %L2089, label %L2090
L2089:
%t7107 = sub i64 0, %p0
br label %L2091
L2090:
br label %L2091
L2091:
%t7108 = phi i64 [ %t7107, %L2089 ], [ %p0, %L2090 ]
%t7109 = call i64 @st64(i64 %t7105, i64 %t7108)
%t7110 = icmp slt i64 %p0, 0
br i1 %t7110, label %L2092, label %L2093
L2092:
%t7111 = sub nsw i64 0, 1
br label %L2094
L2093:
br label %L2094
L2094:
%t7112 = phi i64 [ %t7111, %L2092 ], [ 1, %L2093 ]
%t7113 = call i64 @__mruntime_rt_dec_resid__from_limbs(i64 %t7112, i64 %t7105, i64 1, i64 0, i64 %p1)
ret i64 %t7113
}
define internal i64 @__mruntime_rt_dec_resid__cmp_v(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7114 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7115 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t7116 = icmp ne i64 %t7114, %t7115
br i1 %t7116, label %L2095, label %L2097
L2095:
%t7117 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7118 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t7119 = icmp sgt i64 %t7117, %t7118
br i1 %t7119, label %L2098, label %L2099
L2098:
br label %L2100
L2099:
%t7120 = sub nsw i64 0, 1
br label %L2100
L2100:
%t7121 = phi i64 [ 1, %L2098 ], [ %t7120, %L2099 ]
ret i64 %t7121
L2097:
%t7122 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7123 = icmp eq i64 %t7122, 0
br i1 %t7123, label %L2101, label %L2103
L2101:
ret i64 0
L2103:
%t7124 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t7125 = call i64 @dn(i64 %p0)
%t7126 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t7127 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t7128 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t7129 = call i64 @dn(i64 %p1)
%t7130 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p1)
%t7131 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p1)
%t7132 = call i64 @__mruntime_rt_dec_resid__cmp_mag(i64 %t7124, i64 %t7125, i64 %t7126, i64 %t7127, i64 %t7128, i64 %t7129, i64 %t7130, i64 %t7131)
%t7133 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7134 = icmp slt i64 %t7133, 0
br i1 %t7134, label %L2104, label %L2105
L2104:
%t7135 = sub i64 0, %t7132
br label %L2106
L2105:
br label %L2106
L2106:
%t7136 = phi i64 [ %t7135, %L2104 ], [ %t7132, %L2105 ]
ret i64 %t7136
}
define internal i64 @__mruntime_rt_dec_resid__format(i64 %p0, i1 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7137 = call i64 @__mruntime_rt_dec_resid__dprec(i64 %p0)
%t7138 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7139 = icmp eq i64 %t7138, 0
br i1 %t7139, label %L2107, label %L2109
L2107:
br i1 %p1, label %L2110, label %L2112
L2110:
%t7141 = ptrtoint ptr @.s7140 to i64
%t7142 = call i64 @cstr_dup(i64 %t7141)
ret i64 %t7142
L2112:
%t7143 = add i64 %t7137, 3
%t7144 = call i64 @xmalloc(i64 %t7143)
%t7145 = call i64 @st8(i64 %t7144, i64 48)
%t7146 = add i64 %t7144, 1
%t7147 = call i64 @st8(i64 %t7146, i64 46)
%t7148 = add i64 %t7145, %t7147
%t7149 = add i64 %t7144, 2
%t7150p = inttoptr i64 %t7149 to ptr
%t7150q = trunc i64 48 to i8
call void @llvm.memset.p0.i64(ptr %t7150p, i8 %t7150q, i64 %t7137, i1 false)
%t7150 = add i64 0, 0
%t7151 = add i64 %t7148, %t7150
%t7152 = add i64 %t7144, %t7137
%t7153 = add i64 %t7152, 2
%t7154 = call i64 @st8(i64 %t7153, i64 0)
%t7155 = mul nsw i64 %t7154, 0
%t7156 = add nsw i64 %t7155, %t7144
ret i64 %t7156
L2109:
%t7157 = call i64 @__mruntime_rt_dec_resid__coef_digits(i64 %p0)
%t7158 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t7159 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t7160 = add i64 %t7158, %t7159
%t7161 = call i64 @__mruntime_rt_dec_resid__trail_zeros(i64 %t7157, i64 %t7158)
br label %LSL7162
LSL7162:
br i1 %p1, label %LSR7162, label %LSJ7162
LSR7162:
%t7163 = icmp slt i64 %t7160, %t7137
br label %LSJ7162
LSJ7162:
%t7164 = phi i1 [ false, %LSL7162 ], [ %t7163, %LSR7162 ]
br i1 %t7164, label %L2113, label %L2114
L2113:
%t7165 = icmp sgt i64 %t7161, %t7160
br i1 %t7165, label %L2116, label %L2117
L2116:
br label %L2118
L2117:
%t7166 = icmp sgt i64 %t7160, 0
br i1 %t7166, label %L2119, label %L2120
L2119:
br label %L2121
L2120:
br label %L2121
L2121:
%t7167 = phi i64 [ %t7160, %L2119 ], [ %t7161, %L2120 ]
br label %L2118
L2118:
%t7168 = phi i64 [ %t7161, %L2116 ], [ %t7167, %L2121 ]
br label %L2115
L2114:
br label %L2115
L2115:
%t7169 = phi i64 [ %t7168, %L2118 ], [ %t7137, %L2114 ]
%t7170 = icmp sgt i64 %t7160, 1
br i1 %t7170, label %L2122, label %L2123
L2122:
br label %L2124
L2123:
br label %L2124
L2124:
%t7171 = phi i64 [ %t7160, %L2122 ], [ 1, %L2123 ]
%t7172 = add i64 1, %t7171
%t7173 = add i64 %t7172, 1
%t7174 = sub i64 0, %t7160
%t7175 = icmp sgt i64 %t7174, 0
br i1 %t7175, label %L2125, label %L2126
L2125:
br label %L2127
L2126:
br label %L2127
L2127:
%t7176 = phi i64 [ %t7174, %L2125 ], [ 0, %L2126 ]
%t7177 = add i64 %t7173, %t7176
%t7178 = icmp sgt i64 %t7169, 0
br i1 %t7178, label %L2128, label %L2129
L2128:
br label %L2130
L2129:
br label %L2130
L2130:
%t7179 = phi i64 [ %t7169, %L2128 ], [ 0, %L2129 ]
%t7180 = add i64 %t7177, %t7179
%t7181 = add i64 %t7180, 1
%t7182 = add i64 %t7181, 1
%t7183 = call i64 @xmalloc(i64 %t7182)
%t7184 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7185 = icmp slt i64 %t7184, 0
br i1 %t7185, label %L2131, label %L2132
L2131:
%t7186 = call i64 @st8(i64 %t7183, i64 45)
%t7187 = add i64 %t7186, 1
br label %L2133
L2132:
br label %L2133
L2133:
%t7188 = phi i64 [ %t7187, %L2131 ], [ 0, %L2132 ]
%t7189 = icmp sgt i64 %t7160, 0
br i1 %t7189, label %L2134, label %L2135
L2134:
%t7190 = call i64 @__mruntime_rt_dec_resid__fmt_int(i64 %t7183, i64 %t7188, i64 %t7157, i64 %t7158, i64 %t7160, i64 %t7169)
br label %L2136
L2135:
%t7191 = call i64 @__mruntime_rt_dec_resid__fmt_frac(i64 %t7183, i64 %t7188, i64 %t7157, i64 %t7158, i64 %t7160, i64 %t7169)
br label %L2136
L2136:
%t7192 = phi i64 [ %t7190, %L2134 ], [ %t7191, %L2135 ]
%t7193 = add i64 %t7183, %t7192
%t7194 = call i64 @st8(i64 %t7193, i64 0)
%t7195 = call i64 @c_free(i64 %t7157)
%t7196 = mul nsw i64 %t7195, 0
%t7197 = add nsw i64 %t7196, %t7183
ret i64 %t7197
}
define internal i64 @__mruntime_rt_dec_resid__trail_zeros(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7205, %tco.s0 ]
%t7198 = icmp sgt i64 %p1, 0
br label %LSL7199
LSL7199:
br i1 %t7198, label %LSR7199, label %LSJ7199
LSR7199:
%t7200 = add i64 %p0, %p1
%t7201 = sub nsw i64 %t7200, 1
%t7202 = call i64 @ld8(i64 %t7201)
%t7203 = icmp eq i64 %t7202, 48
br label %LSJ7199
LSJ7199:
%t7204 = phi i1 [ false, %LSL7199 ], [ %t7203, %LSR7199 ]
br i1 %t7204, label %L2137, label %L2139
L2137:
%t7205 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L2139:
ret i64 %p1
}
define internal i64 @__mruntime_rt_dec_resid__dig_at(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7207 = icmp slt i64 %p2, %p1
br i1 %t7207, label %L2140, label %L2141
L2140:
%t7208 = add i64 %p0, %p2
%t7209 = call i64 @ld8(i64 %t7208)
br label %L2142
L2141:
br label %L2142
L2142:
%t7210 = phi i64 [ %t7209, %L2140 ], [ 48, %L2141 ]
ret i64 %t7210
}
define internal i64 @__mruntime_rt_dec_resid__put_digits(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7215, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t7216, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t7211 = icmp sge i64 %p4, %p5
br i1 %t7211, label %L2143, label %L2145
L2143:
ret i64 %p1
L2145:
%t7212 = add i64 %p0, %p1
%t7213 = call i64 @__mruntime_rt_dec_resid__dig_at(i64 %p2, i64 %p3, i64 %p4)
%t7214 = call i64 @st8(i64 %t7212, i64 %t7213)
%t7215 = add i64 %p1, 1
%t7216 = add nsw i64 %p4, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__fmt_int(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7218 = call i64 @__mruntime_rt_dec_resid__put_digits(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 %p4)
%t7219 = icmp sge i64 %p4, %p5
br i1 %t7219, label %L2146, label %L2148
L2146:
ret i64 %t7218
L2148:
%t7220 = add i64 %p0, %t7218
%t7221 = call i64 @st8(i64 %t7220, i64 46)
%t7222 = add i64 %t7218, 1
%t7223 = tail call i64 @__mruntime_rt_dec_resid__put_digits(i64 %p0, i64 %t7222, i64 %p2, i64 %p3, i64 %p4, i64 %p5)
ret i64 %t7223
}
define internal i64 @__mruntime_rt_dec_resid__fmt_frac(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7224 = add i64 %p0, %p1
%t7225 = call i64 @st8(i64 %t7224, i64 48)
%t7226 = add i64 %p0, %p1
%t7227 = add i64 %t7226, 1
%t7228 = call i64 @st8(i64 %t7227, i64 46)
%t7229 = add i64 %t7225, %t7228
%t7230 = add i64 %p0, %p1
%t7231 = add i64 %t7230, 2
%t7232 = sub i64 0, %p4
%t7233p = inttoptr i64 %t7231 to ptr
%t7233q = trunc i64 48 to i8
call void @llvm.memset.p0.i64(ptr %t7233p, i8 %t7233q, i64 %t7232, i1 false)
%t7233 = add i64 0, 0
%t7234 = add i64 %t7229, %t7233
%t7235 = add i64 %p1, 2
%t7236 = sub i64 %t7235, %p4
%t7237 = tail call i64 @__mruntime_rt_dec_resid__put_digits(i64 %p0, i64 %t7236, i64 %p2, i64 %p3, i64 0, i64 %p5)
ret i64 %t7237
}
define internal i64 @__mruntime_rt_dec_resid__to_int(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7238 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7239 = icmp eq i64 %t7238, 0
br i1 %t7239, label %L2149, label %L2151
L2149:
ret i64 0
L2151:
%t7240 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t7241 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t7242 = icmp slt i64 %t7241, 0
br i1 %t7242, label %L2152, label %L2153
L2152:
%t7243 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t7244 = sub i64 0, %t7243
br label %L2154
L2153:
br label %L2154
L2154:
%t7245 = phi i64 [ %t7244, %L2152 ], [ 0, %L2153 ]
%t7246 = icmp eq i64 %t7245, 0
br label %LSL7247
LSL7247:
br i1 %t7246, label %LSJ7247, label %LSR7247
LSR7247:
%t7248 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t7249 = icmp slt i64 %t7245, %t7248
br label %LSL7250
LSL7250:
br i1 %t7249, label %LSR7250, label %LSJ7250
LSR7250:
%t7251 = call i64 @__mruntime_rt_dec_resid__ld_()
%t7252 = icmp eq i64 %t7251, 0
%t7253 = zext i1 %t7252 to i8
call void @resid_div_check(i8 %t7253)
%t7254 = icmp eq i64 %t7251, -1
%t7255 = icmp eq i64 %t7245, -9223372036854775808
%t7256 = and i1 %t7254, %t7255
%t7259 = zext i1 %t7256 to i8
call void @resid_overflow_check(i8 %t7259)
%t7257 = add i64 %t7251, 0
%t7258 = sdiv i64 %t7245, %t7257
%t7260 = call i1 @__mruntime_rt_dec_resid__limbs_zero_to(i64 %t7240, i64 0, i64 %t7258)
br label %LSJ7250
LSJ7250:
%t7261 = phi i1 [ false, %LSL7250 ], [ %t7260, %LSR7250 ]
br label %LSL7262
LSL7262:
br i1 %t7261, label %LSR7262, label %LSJ7262
LSR7262:
%t7263 = call i64 @__mruntime_rt_dec_resid__ld_()
%t7264 = icmp eq i64 %t7263, 0
%t7265 = zext i1 %t7264 to i8
call void @resid_div_check(i8 %t7265)
%t7266 = icmp eq i64 %t7263, -1
%t7267 = icmp eq i64 %t7245, -9223372036854775808
%t7268 = and i1 %t7266, %t7267
%t7271 = zext i1 %t7268 to i8
call void @resid_overflow_check(i8 %t7271)
%t7269 = add i64 %t7263, 0
%t7270 = sdiv i64 %t7245, %t7269
%t7272 = call i64 @__mruntime_rt_dec_resid__li(i64 %t7240, i64 %t7270)
%t7273 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t7272)
%t7274 = call i64 @__mruntime_rt_dec_resid__ld_()
%t7275 = icmp eq i64 %t7274, 0
%t7276 = zext i1 %t7275 to i8
call void @resid_div_check(i8 %t7276)
%t7277 = icmp eq i64 %t7274, -1
%t7278 = icmp eq i64 %t7245, -9223372036854775808
%t7279 = and i1 %t7277, %t7278
%t7280 = select i1 %t7277, i64 1, i64 %t7274
%t7281 = srem i64 %t7245, %t7280
%t7283 = call i64 @__mruntime_rt_dec_resid__p10(i64 %t7281)
%t7284 = icmp eq i64 %t7283, 0
%t7285 = zext i1 %t7284 to i8
call void @resid_div_check(i8 %t7285)
%t7290 = urem i64 %t7273, %t7283
%t7291 = add i64 0, 0
%t7292 = add i64 %t7291, 0
%t7298 = icmp eq i64 %t7290, %t7292
br label %LSJ7262
LSJ7262:
%t7299 = phi i1 [ false, %LSL7262 ], [ %t7298, %LSR7262 ]
br label %LSJ7247
LSJ7247:
%t7300 = phi i1 [ true, %LSL7247 ], [ %t7299, %LSJ7262 ]
%t7301 = xor i1 %t7300, true
br i1 %t7301, label %L2155, label %L2157
L2155:
%t7303 = call i64 @rt_abort(ptr @.s7302)
ret i64 %t7303
L2157:
%t7304 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t7305 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t7306 = add i64 %t7304, %t7305
%t7307 = icmp sgt i64 %t7306, 20
br i1 %t7307, label %L2158, label %L2160
L2158:
%t7309 = call i64 @rt_abort(ptr @.s7308)
ret i64 %t7309
L2160:
%t7310 = call i64 @__mruntime_rt_dec_resid__coef_digits(i64 %p0)
%t7311 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t7312 = sub i64 %t7311, %t7245
%t7313 = sext i64 0 to i128
%t7314 = add i128 %t7313, 0
%t7320 = call i128 @__mruntime_rt_dec_resid__digits128(i64 %t7310, i64 0, i64 %t7312, i128 %t7314)
%t7321 = call i64 @c_free(i64 %t7310)
%t7322 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t7323 = call i128 @__mruntime_rt_dec_resid__times10(i128 %t7320, i64 %t7322)
%t7324 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7325 = icmp slt i64 %t7324, 0
br i1 %t7325, label %L2161, label %L2162
L2161:
%t7326 = add i128 9223372036854775807, 0
%t7327 = add i128 %t7326, 0
%t7333 = sext i64 1 to i128
%t7334 = add i128 %t7333, 0
%t7340 = add i128 %t7327, %t7334
br label %L2163
L2162:
%t7341 = add i128 9223372036854775807, 0
%t7342 = add i128 %t7341, 0
br label %L2163
L2163:
%t7348 = phi i128 [ %t7340, %L2161 ], [ %t7342, %L2162 ]
%t7349 = icmp ugt i128 %t7323, %t7348
br i1 %t7349, label %L2164, label %L2166
L2164:
%t7351 = call i64 @rt_abort(ptr @.s7350)
ret i64 %t7351
L2166:
%t7352 = add i128 %t7323, 0
%t7353 = trunc i128 %t7352 to i64
%t7359 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7360 = icmp slt i64 %t7359, 0
br i1 %t7360, label %L2167, label %L2168
L2167:
%t7361 = sub i64 0, %t7353
br label %L2169
L2168:
br label %L2169
L2169:
%t7362 = phi i64 [ %t7361, %L2167 ], [ %t7353, %L2168 ]
ret i64 %t7362
}
define internal i1 @__mruntime_rt_dec_resid__limbs_zero_to(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7363 = icmp sge i64 %p1, %p2
br i1 %t7363, label %L2170, label %L2172
L2170:
ret i1 true
L2172:
%t7364 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p1)
%t7365 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t7364)
%t7366 = add i64 0, 0
%t7367 = add i64 %t7366, 0
%t7373 = icmp eq i64 %t7365, %t7367
br label %LSL7374
LSL7374:
br i1 %t7373, label %LSR7374, label %LSJ7374
LSR7374:
%t7375 = add nsw i64 %p1, 1
%t7376 = call i1 @__mruntime_rt_dec_resid__limbs_zero_to(i64 %p0, i64 %t7375, i64 %p2)
br label %LSJ7374
LSJ7374:
%t7377 = phi i1 [ false, %LSL7374 ], [ %t7376, %LSR7374 ]
ret i1 %t7377
}
define internal i128 @__mruntime_rt_dec_resid__digits128(i64 %p0.in, i64 %p1.in, i64 %p2.in, i128 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7379, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i128 [ %p3.in, %entry ], [ %t7398, %tco.s0 ]
%t7378 = icmp sge i64 %p1, %p2
br i1 %t7378, label %L2173, label %L2175
L2173:
ret i128 %p3
L2175:
%t7379 = add nsw i64 %p1, 1
%t7380 = sext i64 10 to i128
%t7381 = add i128 %t7380, 0
%t7387 = mul i128 %p3, %t7381
%t7388 = add i64 %p0, %p1
%t7389 = call i64 @ld8(i64 %t7388)
%t7390 = sub i64 %t7389, 48
%t7391 = sext i64 %t7390 to i128
%t7392 = add i128 %t7391, 0
%t7398 = add i128 %t7387, %t7392
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i128 @__mruntime_rt_dec_resid__times10(i128 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i128 [ %p0.in, %entry ], [ %t7408, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7409, %tco.s0 ]
%t7400 = icmp sle i64 %p1, 0
br i1 %t7400, label %L2176, label %L2178
L2176:
ret i128 %p0
L2178:
%t7401 = sext i64 10 to i128
%t7402 = add i128 %t7401, 0
%t7408 = mul i128 %p0, %t7402
%t7409 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal double @__mruntime_rt_dec_resid__to_f64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7411 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7412 = icmp eq i64 %t7411, 0
br i1 %t7412, label %L2179, label %L2181
L2179:
ret double 0.0
L2181:
%t7413 = call i64 @__mruntime_rt_dec_resid__coef_digits(i64 %p0)
%t7414 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t7415 = icmp slt i64 %t7414, 40
br i1 %t7415, label %L2182, label %L2183
L2182:
br label %L2184
L2183:
br label %L2184
L2184:
%t7416 = phi i64 [ %t7414, %L2182 ], [ 40, %L2183 ]
%t7417p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dec_f64)
%t7417 = ptrtoint ptr %t7417p to i64
%t7418 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7419 = icmp slt i64 %t7418, 0
br i1 %t7419, label %L2185, label %L2186
L2185:
%t7420 = call i64 @st8(i64 %t7417, i64 45)
%t7421 = add i64 %t7420, 1
br label %L2187
L2186:
br label %L2187
L2187:
%t7422 = phi i64 [ %t7421, %L2185 ], [ 0, %L2186 ]
%t7423 = add i64 %t7417, %t7422
%t7424 = call i64 @mcopy(i64 %t7423, i64 %t7413, i64 %t7416)
%t7425 = add i64 %t7422, %t7416
%t7426 = add i64 %t7417, %t7425
%t7427 = call i64 @st8(i64 %t7426, i64 101)
%t7428 = add i64 %t7425, 1
%t7429 = add i64 %t7417, %t7425
%t7430 = add i64 %t7429, 1
%t7431 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t7432 = sub i64 %t7414, %t7416
%t7433 = add i64 %t7431, %t7432
%t7434 = call i64 @itoa_into(i64 %t7430, i64 %t7433)
%t7435 = add i64 %t7428, %t7434
%t7436 = add i64 %t7417, %t7435
%t7437 = call i64 @st8(i64 %t7436, i64 0)
%t7438 = call i64 @c_free(i64 %t7413)
%t7439 = call double @c_strtod(i64 %t7417, i64 0)
ret double %t7439
}
define internal i64 @__mruntime_rt_dec_resid__opprec(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7440 = call i64 @__mruntime_rt_dec_resid__dprec(i64 %p0)
%t7441 = call i64 @__mruntime_rt_dec_resid__dprec(i64 %p1)
%t7442 = icmp sgt i64 %t7440, %t7441
br i1 %t7442, label %L2188, label %L2189
L2188:
br label %L2190
L2189:
br label %L2190
L2190:
%t7443 = phi i64 [ %t7440, %L2188 ], [ %t7441, %L2189 ]
ret i64 %t7443
}
define internal i64 @__mruntime_rt_dec_resid__fit(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7444 = call i64 @__mruntime_rt_dec_resid__dprec(i64 %p0)
%t7445 = icmp eq i64 %t7444, %p1
br i1 %t7445, label %L2191, label %L2192
L2191:
br label %L2193
L2192:
%t7446 = call i64 @__mruntime_rt_dec_resid__round_v(i64 %p0, i64 %p1, i1 false)
br label %L2193
L2193:
%t7447 = phi i64 [ %p0, %L2191 ], [ %t7446, %L2192 ]
ret i64 %t7447
}
define internal i64 @rt_decp_from_str(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7448 = tail call i64 @__mruntime_rt_dec_resid__from_str(i64 %p0, i64 %p1)
ret i64 %t7448
}
define ptr @resid_decp_from_str(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_decp_from_str(i64 %x0i, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_decp_from_i64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7449 = tail call i64 @__mruntime_rt_dec_resid__from_i64(i64 %p0, i64 %p1)
ret i64 %t7449
}
define ptr @resid_decp_from_i64(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_decp_from_i64(i64 %a0, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_decp_round(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7450 = call i64 @__mruntime_rt_dec_resid__round_v(i64 %p0, i64 %p1, i1 false)
ret i64 %t7450
}
define ptr @resid_decp_round(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_decp_round(i64 %x0i, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_decp_add(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7451 = call i64 @__mruntime_rt_dec_resid__opprec(i64 %p0, i64 %p1)
%t7452 = call i64 @__mruntime_rt_dec_resid__addsub(i64 %p0, i64 %p1, i1 false, i64 %t7451)
%t7453 = call i64 @__mruntime_rt_dec_resid__fit(i64 %t7452, i64 %p2)
ret i64 %t7453
}
define ptr @resid_decp_add(ptr %a0, ptr %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_decp_add(i64 %x0i, i64 %x1i, i64 %a2)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_decp_sub(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7454 = call i64 @__mruntime_rt_dec_resid__opprec(i64 %p0, i64 %p1)
%t7455 = call i64 @__mruntime_rt_dec_resid__addsub(i64 %p0, i64 %p1, i1 true, i64 %t7454)
%t7456 = call i64 @__mruntime_rt_dec_resid__fit(i64 %t7455, i64 %p2)
ret i64 %t7456
}
define ptr @resid_decp_sub(ptr %a0, ptr %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_decp_sub(i64 %x0i, i64 %x1i, i64 %a2)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_decp_mul(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7457 = call i64 @__mruntime_rt_dec_resid__opprec(i64 %p0, i64 %p1)
%t7458 = call i64 @__mruntime_rt_dec_resid__mul_v(i64 %p0, i64 %p1, i64 %t7457)
%t7459 = call i64 @__mruntime_rt_dec_resid__fit(i64 %t7458, i64 %p2)
ret i64 %t7459
}
define ptr @resid_decp_mul(ptr %a0, ptr %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_decp_mul(i64 %x0i, i64 %x1i, i64 %a2)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_decp_div(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7460 = call i64 @__mruntime_rt_dec_resid__opprec(i64 %p0, i64 %p1)
%t7461 = call i64 @__mruntime_rt_dec_resid__div_v(i64 %p0, i64 %p1, i64 %t7460)
%t7462 = call i64 @__mruntime_rt_dec_resid__fit(i64 %t7461, i64 %p2)
ret i64 %t7462
}
define ptr @resid_decp_div(ptr %a0, ptr %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_decp_div(i64 %x0i, i64 %x1i, i64 %a2)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_decp_neg(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7463 = call i64 @dn(i64 %p0)
%t7464 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 %t7463)
%t7465 = call i64 @dn(i64 %p0)
%t7466 = mul i64 %t7465, 8
%t7467 = add i64 24, %t7466
%t7468 = call i64 @mcopy(i64 %t7464, i64 %p0, i64 %t7467)
%t7469 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7470 = sub i64 0, %t7469
%t7471 = call i64 @st8(i64 %t7464, i64 %t7470)
%t7472 = mul nsw i64 %t7471, 0
%t7473 = add nsw i64 %t7472, %t7464
ret i64 %t7473
}
define ptr @resid_decp_neg(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_decp_neg(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_decp_cmp(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7474 = tail call i64 @__mruntime_rt_dec_resid__cmp_v(i64 %p0, i64 %p1)
ret i64 %t7474
}
define i64 @resid_decp_cmp(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_decp_cmp(i64 %x0i, i64 %x1i)
ret i64 %r
}
define internal i64 @rt_decp_to_str(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7475 = icmp ne i64 %p1, 0
%t7476 = call i64 @__mruntime_rt_dec_resid__format(i64 %p0, i1 %t7475)
ret i64 %t7476
}
define ptr @resid_decp_to_str(ptr %a0, i8 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1 = zext i8 %a1 to i64
%r = call i64 @rt_decp_to_str(i64 %x0i, i64 %x1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_decp_to_i64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7477 = tail call i64 @__mruntime_rt_dec_resid__to_int(i64 %p0)
ret i64 %t7477
}
define i64 @resid_decp_to_i64(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_decp_to_i64(i64 %x0i)
ret i64 %r
}
define internal double @rt_decp_to_f64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7478 = tail call double @__mruntime_rt_dec_resid__to_f64(i64 %p0)
ret double %t7478
}
define double @resid_decp_to_f64(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call double @rt_decp_to_f64(i64 %x0i)
ret double %r
}
define internal i64 @__mruntime_rt_list_resid__box_hdr(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7479 = icmp sgt i64 %p1, 0
br i1 %t7479, label %L2194, label %L2195
L2194:
br label %L2196
L2195:
br label %L2196
L2196:
%t7480 = phi i64 [ %p1, %L2194 ], [ 0, %L2195 ]
%t7481 = mul i64 %t7480, 8
%t7482 = add i64 16, %t7481
%t7483 = call i64 @ralloc(i64 %t7482)
%t7484 = call i64 @st32(i64 %t7483, i64 %p0)
%t7485 = add i64 %t7483, 4
%t7486 = call i64 @st32(i64 %t7485, i64 %p1)
%t7487 = add i64 %t7483, 8
%t7488 = call i64 @st64(i64 %t7487, i64 %p2)
%t7489 = mul nsw i64 %t7488, 0
%t7490 = add nsw i64 %t7489, %t7483
ret i64 %t7490
}
define internal i64 @rt_box_new(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7491 = call i64 @__mruntime_rt_list_resid__box_hdr(i64 %p0, i64 %p1, i64 %p3)
%t7492 = icmp sgt i64 %p1, 0
br i1 %t7492, label %L2197, label %L2198
L2197:
%t7493 = add i64 %t7491, 16
%t7494 = mul i64 %p1, 8
%t7495 = call i64 @mcopy(i64 %t7493, i64 %p2, i64 %t7494)
br label %L2199
L2198:
br label %L2199
L2199:
%t7496 = phi i64 [ %t7495, %L2197 ], [ 0, %L2198 ]
ret i64 %t7491
}
define ptr @resid_box_new(i64 %a0, i64 %a1, ptr %a2, ptr %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x2i = ptrtoint ptr %a2 to i64
%x3i = ptrtoint ptr %a3 to i64
%r = call i64 @rt_box_new(i64 %a0, i64 %a1, i64 %x2i, i64 %x3i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_box_alloc(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7497 = tail call i64 @__mruntime_rt_list_resid__box_hdr(i64 %p0, i64 %p1, i64 %p2)
ret i64 %t7497
}
define ptr @resid_box_alloc(i64 %a0, i64 %a1, ptr %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x2i = ptrtoint ptr %a2 to i64
%r = call i64 @rt_box_alloc(i64 %a0, i64 %a1, i64 %x2i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_box_tag(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7498 = call i1 @box_imm(i64 %p0)
br label %LSL7499
LSL7499:
br i1 %t7498, label %LSJ7499, label %LSR7499
LSR7499:
%t7500 = call i1 @box_fimm(i64 %p0)
br label %LSJ7499
LSJ7499:
%t7501 = phi i1 [ true, %LSL7499 ], [ %t7500, %LSR7499 ]
br i1 %t7501, label %L2200, label %L2201
L2200:
%t7502 = sub nsw i64 0, 1
br label %L2202
L2201:
%t7503 = call i64 @box_tag(i64 %p0)
br label %L2202
L2202:
%t7504 = phi i64 [ %t7502, %L2200 ], [ %t7503, %L2201 ]
ret i64 %t7504
}
define i64 @resid_box_tag(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_box_tag(i64 %x0i)
ret i64 %r
}
define internal i64 @rt_box_count(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7505 = call i1 @box_imm(i64 %p0)
br label %LSL7506
LSL7506:
br i1 %t7505, label %LSJ7506, label %LSR7506
LSR7506:
%t7507 = call i1 @box_fimm(i64 %p0)
br label %LSJ7506
LSJ7506:
%t7508 = phi i1 [ true, %LSL7506 ], [ %t7507, %LSR7506 ]
br i1 %t7508, label %L2203, label %L2204
L2203:
br label %L2205
L2204:
%t7509 = call i64 @box_count(i64 %p0)
br label %L2205
L2205:
%t7510 = phi i64 [ 1, %L2203 ], [ %t7509, %L2204 ]
ret i64 %t7510
}
define i64 @resid_box_count(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_box_count(i64 %x0i)
ret i64 %r
}
define internal i64 @rt_box_slots(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7511 = add i64 %p0, 16
ret i64 %t7511
}
define ptr @resid_box_slots(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_box_slots(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_box_slot(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7512 = add i64 %p0, 16
%t7513 = mul i64 %p1, 8
%t7514 = add i64 %t7512, %t7513
%t7515 = call i64 @ld64(i64 %t7514)
ret i64 %t7515
}
define ptr @resid_box_slot(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_box_slot(i64 %x0i, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_malloc(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7516 = tail call i64 @c_malloc(i64 %p0)
ret i64 %t7516
}
define ptr @resid_malloc(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_malloc(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @lcount(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7517 = tail call i64 @ld64(i64 %p0)
ret i64 %t7517
}
define internal i64 @lshift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7518 = add i64 %p0, 8
%t7519 = call i64 @ld32(i64 %t7518)
%t7520 = tail call i64 @sx32(i64 %t7519)
ret i64 %t7520
}
define internal i64 @lroot(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7521 = add i64 %p0, 16
%t7522 = tail call i64 @ld64(i64 %t7521)
ret i64 %t7522
}
define internal i64 @ltype(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7523 = add i64 %p0, 24
%t7524 = tail call i64 @ld64(i64 %t7523)
ret i64 %t7524
}
define internal i64 @__mruntime_rt_list_resid__set_list(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7525 = call i64 @st64(i64 %p0, i64 %p1)
%t7526 = add i64 %p0, 8
%t7527 = call i64 @st32(i64 %t7526, i64 %p2)
%t7528 = add i64 %p0, 16
%t7529 = call i64 @st64(i64 %t7528, i64 %p3)
%t7530 = add i64 %p0, 24
%t7531 = call i64 @st64(i64 %t7530, i64 %p4)
%t7532 = mul nsw i64 %t7531, 0
%t7533 = add nsw i64 %t7532, %p0
ret i64 %t7533
}
define internal i64 @list_hdr() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7534 = call i64 @ralloc(i64 32)
%t7535 = add i64 %t7534, 12
%t7536 = call i64 @st32(i64 %t7535, i64 0)
%t7537 = mul nsw i64 %t7536, 0
%t7538 = add nsw i64 %t7537, %t7534
ret i64 %t7538
}
define ptr @resid_rt_list_hdr() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @list_hdr()
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_list_resid__node_new(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7539 = mul i64 %p0, 8
%t7540 = add i64 8, %t7539
%t7541 = call i64 @ralloc(i64 %t7540)
%t7542 = call i64 @st64(i64 %t7541, i64 %p0)
%t7543 = add i64 %t7541, 8
%t7544 = mul i64 %p0, 8
%t7545p = inttoptr i64 %t7543 to ptr
%t7545q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t7545p, i8 %t7545q, i64 %t7544, i1 false)
%t7545 = add i64 0, 0
%t7546 = mul nsw i64 %t7545, 0
%t7547 = add nsw i64 %t7546, %t7541
ret i64 %t7547
}
define internal i64 @flat_new(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7548 = mul i64 %p0, 8
%t7549 = add i64 24, %t7548
%t7550 = call i64 @ralloc(i64 %t7549)
%t7551 = call i64 @st64(i64 %t7550, i64 0)
%t7552 = add i64 %t7550, 8
%t7553 = call i64 @st64(i64 %t7552, i64 %p0)
%t7554 = add i64 %t7550, 16
%t7555 = call i64 @st64(i64 %t7554, i64 0)
%t7556 = mul nsw i64 %t7555, 0
%t7557 = add nsw i64 %t7556, %t7550
ret i64 %t7557
}
define ptr @resid_rt_flatbuf_new(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @flat_new(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_list_resid__pvec_get(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t7572, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7573, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t7558 = icmp sle i64 %p1, 0
br i1 %t7558, label %L2206, label %L2208
L2206:
%t7559 = add i64 %p0, 8
%t7560 = and i64 %p2, 31
%t7561 = mul nsw i64 %t7560, 8
%t7562 = add i64 %t7559, %t7561
%t7563 = call i64 @ld64(i64 %t7562)
ret i64 %t7563
L2208:
%t7564 = add i64 %p0, 8
%t7565 = icmp uge i64 %p1, 64
%t7566 = add i64 %p1, 0
%t7567 = select i1 %t7565, i64 63, i64 %t7566
%t7568 = ashr i64 %p2, %t7567
%t7569 = and i64 %t7568, 31
%t7570 = mul nsw i64 %t7569, 8
%t7571 = add i64 %t7564, %t7570
%t7572 = call i64 @ld64(i64 %t7571)
%t7573 = sub nsw i64 %p1, 5
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @list_at(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7575 = call i64 @lshift(i64 %p0)
%t7576 = sub nsw i64 0, 1
%t7577 = icmp eq i64 %t7575, %t7576
br i1 %t7577, label %L2209, label %L2211
L2209:
%t7578 = call i64 @lroot(i64 %p0)
%t7579 = add i64 %t7578, 24
%t7580 = mul i64 %p1, 8
%t7581 = add i64 %t7579, %t7580
%t7582 = call i64 @ld64(i64 %t7581)
ret i64 %t7582
L2211:
%t7583 = call i64 @lroot(i64 %p0)
%t7584 = call i64 @lshift(i64 %p0)
%t7585 = call i64 @__mruntime_rt_list_resid__pvec_get(i64 %t7583, i64 %t7584, i64 %p1)
ret i64 %t7585
}
define internal i64 @__mruntime_rt_list_resid__node_with(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7586 = icmp ne i64 %p0, 0
br i1 %t7586, label %L2212, label %L2213
L2212:
%t7587 = call i64 @ld64(i64 %p0)
br label %L2214
L2213:
br label %L2214
L2214:
%t7588 = phi i64 [ %t7587, %L2212 ], [ 0, %L2213 ]
%t7589 = add i64 %p1, 1
%t7590 = icmp sgt i64 %t7589, %t7588
br i1 %t7590, label %L2215, label %L2216
L2215:
br label %L2217
L2216:
br label %L2217
L2217:
%t7591 = phi i64 [ %t7589, %L2215 ], [ %t7588, %L2216 ]
%t7592 = call i64 @__mruntime_rt_list_resid__node_new(i64 %t7591)
%t7593 = icmp sgt i64 %t7588, 0
br i1 %t7593, label %L2218, label %L2219
L2218:
%t7594 = add i64 %t7592, 8
%t7595 = add i64 %p0, 8
%t7596 = mul i64 %t7588, 8
%t7597 = call i64 @mcopy(i64 %t7594, i64 %t7595, i64 %t7596)
br label %L2220
L2219:
br label %L2220
L2220:
%t7598 = phi i64 [ %t7597, %L2218 ], [ 0, %L2219 ]
%t7599 = add i64 %t7592, 8
%t7600 = mul i64 %p1, 8
%t7601 = add i64 %t7599, %t7600
%t7602 = call i64 @st64(i64 %t7601, i64 %p2)
%t7603 = mul nsw i64 %t7602, 0
%t7604 = add nsw i64 %t7603, %t7592
ret i64 %t7604
}
define internal i64 @__mruntime_rt_list_resid__set_leaf(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7605 = icmp eq i64 %p1, 0
br i1 %t7605, label %L2221, label %L2223
L2221:
ret i64 %p3
L2223:
%t7606 = sub i64 %p1, 5
%t7607 = icmp uge i64 %t7606, 64
%t7608 = add i64 %t7606, 0
%t7609 = select i1 %t7607, i64 63, i64 %t7608
%t7610 = ashr i64 %p2, %t7609
%t7611 = and i64 %t7610, 31
%t7612 = icmp ne i64 %p0, 0
br label %LSL7613
LSL7613:
br i1 %t7612, label %LSR7613, label %LSJ7613
LSR7613:
%t7614 = call i64 @ld64(i64 %p0)
%t7615 = icmp slt i64 %t7611, %t7614
br label %LSJ7613
LSJ7613:
%t7616 = phi i1 [ false, %LSL7613 ], [ %t7615, %LSR7613 ]
br i1 %t7616, label %L2224, label %L2225
L2224:
%t7617 = add i64 %p0, 8
%t7618 = mul nsw i64 %t7611, 8
%t7619 = add i64 %t7617, %t7618
%t7620 = call i64 @ld64(i64 %t7619)
br label %L2226
L2225:
br label %L2226
L2226:
%t7621 = phi i64 [ %t7620, %L2224 ], [ 0, %L2225 ]
%t7622 = sub i64 %p1, 5
%t7623 = call i64 @__mruntime_rt_list_resid__set_leaf(i64 %t7621, i64 %t7622, i64 %p2, i64 %p3)
%t7624 = call i64 @__mruntime_rt_list_resid__node_with(i64 %p0, i64 %t7611, i64 %t7623)
ret i64 %t7624
}
define internal i64 @pvec_append_into(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7625 = call i64 @lshift(i64 %p1)
%t7626 = sub nsw i64 0, 1
%t7627 = icmp eq i64 %t7625, %t7626
br label %LSL7628
LSL7628:
br i1 %t7627, label %LSJ7628, label %LSR7628
LSR7628:
%t7629 = call i64 @lroot(i64 %p1)
%t7630 = icmp eq i64 %t7629, 0
br label %LSJ7628
LSJ7628:
%t7631 = phi i1 [ true, %LSL7628 ], [ %t7630, %LSR7628 ]
br i1 %t7631, label %L2227, label %L2229
L2227:
%t7632 = call i64 @lroot(i64 %p1)
%t7633 = call i64 @lcount(i64 %p1)
%t7634 = icmp ne i64 %t7632, 0
br label %LSL7635
LSL7635:
br i1 %t7634, label %LSR7635, label %LSJ7635
LSR7635:
%t7636 = add i64 %t7633, %p3
%t7637 = add i64 %t7632, 8
%t7638 = call i64 @ld64(i64 %t7637)
%t7639 = icmp sle i64 %t7636, %t7638
br label %LSJ7635
LSJ7635:
%t7640 = phi i1 [ false, %LSL7635 ], [ %t7639, %LSR7635 ]
br label %LSL7641
LSL7641:
br i1 %t7640, label %LSR7641, label %LSJ7641
LSR7641:
%t7642 = add i64 %t7633, %p3
%t7643p = inttoptr i64 %t7632 to ptr
%t7643x = cmpxchg ptr %t7643p, i64 %t7633, i64 %t7642 seq_cst seq_cst
%t7643 = extractvalue {i64, i1} %t7643x, 1
br label %LSJ7641
LSJ7641:
%t7644 = phi i1 [ false, %LSL7641 ], [ %t7643, %LSR7641 ]
br i1 %t7644, label %L2230, label %L2232
L2230:
%t7645 = call i64 @__mruntime_rt_list_resid__flat_fill(i64 %p0, i64 %p1, i64 %t7632, i64 %t7632, i64 %t7633, i64 %p2, i64 %p3)
ret i64 %t7645
L2232:
%t7646 = icmp eq i64 %t7632, 0
br label %LSL7647
LSL7647:
br i1 %t7646, label %LSJ7647, label %LSR7647
LSR7647:
%t7648 = call i64 @ld64(i64 %t7632)
%t7649 = icmp eq i64 %t7648, %t7633
br label %LSJ7647
LSJ7647:
%t7650 = phi i1 [ true, %LSL7647 ], [ %t7649, %LSR7647 ]
br label %LSL7651
LSL7651:
br i1 %t7650, label %LSJ7651, label %LSR7651
LSR7651:
%t7652 = icmp sle i64 %t7633, 64
br label %LSJ7651
LSJ7651:
%t7653 = phi i1 [ true, %LSL7651 ], [ %t7652, %LSR7651 ]
br i1 %t7653, label %L2233, label %L2235
L2233:
%t7654 = icmp ne i64 %t7632, 0
br i1 %t7654, label %L2236, label %L2237
L2236:
%t7655 = add i64 %t7633, %p3
%t7656 = mul i64 %t7655, 2
br label %L2238
L2237:
%t7657 = add i64 %t7633, %p3
br label %L2238
L2238:
%t7658 = phi i64 [ %t7656, %L2236 ], [ %t7657, %L2237 ]
%t7659 = call i64 @flat_new(i64 %t7658)
%t7660 = icmp sgt i64 %t7633, 0
br i1 %t7660, label %L2239, label %L2240
L2239:
%t7661 = add i64 %t7659, 24
%t7662 = add i64 %t7632, 24
%t7663 = mul i64 %t7633, 8
%t7664 = call i64 @mcopy(i64 %t7661, i64 %t7662, i64 %t7663)
br label %L2241
L2240:
br label %L2241
L2241:
%t7665 = phi i64 [ %t7664, %L2239 ], [ 0, %L2240 ]
%t7666 = call i64 @st64(i64 %t7659, i64 %t7633)
%t7667 = call i64 @__mruntime_rt_list_resid__flat_fill(i64 %p0, i64 %p1, i64 %t7632, i64 %t7659, i64 %t7633, i64 %p2, i64 %p3)
ret i64 %t7667
L2235:
%t7668 = add i64 %t7632, 24
%t7669 = call i64 @ltype(i64 %p1)
%t7670 = call i64 @__mruntime_rt_list_resid__trie_from_items(i64 %t7668, i64 %t7633, i64 %t7669)
%t7671 = tail call i64 @__mruntime_rt_list_resid__trie_append(i64 %p0, i64 %t7670, i64 %p2, i64 %p3)
ret i64 %t7671
L2229:
%t7672 = tail call i64 @__mruntime_rt_list_resid__trie_append(i64 %p0, i64 %p1, i64 %p2, i64 %p3)
ret i64 %t7672
}
define ptr @resid_rt_pvec_append_into(ptr %a0, ptr %a1, ptr %a2, i64 %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%x2i = ptrtoint ptr %a2 to i64
%r = call i64 @pvec_append_into(i64 %x0i, i64 %x1i, i64 %x2i, i64 %a3)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_list_resid__flat_fill(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7673 = add i64 %p3, 24
%t7674 = mul i64 %p4, 8
%t7675 = add i64 %t7673, %t7674
%t7676 = mul i64 %p6, 8
%t7677 = call i64 @mcopy(i64 %t7675, i64 %p5, i64 %t7676)
%t7678 = icmp ne i64 %p3, %p2
br i1 %t7678, label %L2242, label %L2243
L2242:
%t7679 = add i64 %p4, %p6
%t7680 = call i64 @st64(i64 %p3, i64 %t7679)
br label %L2244
L2243:
br label %L2244
L2244:
%t7681 = phi i64 [ %t7680, %L2242 ], [ 0, %L2243 ]
%t7682 = icmp ne i64 %p0, 0
br i1 %t7682, label %L2245, label %L2246
L2245:
br label %L2247
L2246:
%t7683 = call i64 @list_hdr()
br label %L2247
L2247:
%t7684 = phi i64 [ %p0, %L2245 ], [ %t7683, %L2246 ]
%t7685 = add i64 %p4, %p6
%t7686 = sub nsw i64 0, 1
%t7687 = call i64 @ltype(i64 %p1)
%t7688 = call i64 @__mruntime_rt_list_resid__set_list(i64 %t7684, i64 %t7685, i64 %t7686, i64 %p3, i64 %t7687)
ret i64 %t7688
}
define internal i64 @__mruntime_rt_list_resid__trie_append(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7689 = icmp ne i64 %p0, 0
br i1 %t7689, label %L2248, label %L2249
L2248:
br label %L2250
L2249:
%t7690 = call i64 @list_hdr()
br label %L2250
L2250:
%t7691 = phi i64 [ %p0, %L2248 ], [ %t7690, %L2249 ]
%t7692 = icmp ne i64 %t7691, %p1
br i1 %t7692, label %L2251, label %L2252
L2251:
%t7693 = call i64 @lcount(i64 %p1)
%t7694 = call i64 @lshift(i64 %p1)
%t7695 = call i64 @lroot(i64 %p1)
%t7696 = call i64 @ltype(i64 %p1)
%t7697 = call i64 @__mruntime_rt_list_resid__set_list(i64 %t7691, i64 %t7693, i64 %t7694, i64 %t7695, i64 %t7696)
br label %L2253
L2252:
br label %L2253
L2253:
%t7698 = phi i64 [ %t7697, %L2251 ], [ 0, %L2252 ]
%t7699 = tail call i64 @__mruntime_rt_list_resid__trie_fill(i64 %t7691, i64 %p2, i64 %p3, i64 0)
ret i64 %t7699
}
define internal i64 @__mruntime_rt_list_resid__trie_fill(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t7737, %tco.s0 ]
%t7700 = icmp sge i64 %p3, %p2
br i1 %t7700, label %L2254, label %L2256
L2254:
ret i64 %p0
L2256:
%t7701 = call i64 @lcount(i64 %p0)
%t7702 = ashr i64 %t7701, 5
%t7703 = and i64 %t7701, 31
%t7704 = sub nsw i64 32, %t7703
%t7705 = sub i64 %p2, %p3
%t7706 = icmp slt i64 %t7704, %t7705
br i1 %t7706, label %L2257, label %L2258
L2257:
br label %L2259
L2258:
br label %L2259
L2259:
%t7707 = phi i64 [ %t7704, %L2257 ], [ %t7705, %L2258 ]
%t7708 = add i64 %t7703, %t7707
%t7709 = call i64 @__mruntime_rt_list_resid__node_new(i64 %t7708)
%t7710 = icmp sgt i64 %t7703, 0
br i1 %t7710, label %L2260, label %L2261
L2260:
%t7711 = add i64 %t7709, 8
%t7712 = call i64 @lroot(i64 %p0)
%t7713 = call i64 @lshift(i64 %p0)
%t7714 = call i64 @__mruntime_rt_list_resid__leaf_of(i64 %t7712, i64 %t7713, i64 %t7701)
%t7715 = add i64 %t7714, 8
%t7716 = mul nsw i64 %t7703, 8
%t7717 = call i64 @mcopy(i64 %t7711, i64 %t7715, i64 %t7716)
br label %L2262
L2261:
br label %L2262
L2262:
%t7718 = phi i64 [ %t7717, %L2260 ], [ 0, %L2261 ]
%t7719 = add i64 %t7709, 8
%t7720 = mul nsw i64 %t7703, 8
%t7721 = add i64 %t7719, %t7720
%t7722 = mul i64 %p3, 8
%t7723 = add i64 %p1, %t7722
%t7724 = mul i64 %t7707, 8
%t7725 = call i64 @mcopy(i64 %t7721, i64 %t7723, i64 %t7724)
%t7726 = call i64 @lroot(i64 %p0)
%t7727 = icmp eq i64 %t7726, 0
br i1 %t7727, label %L2263, label %L2264
L2263:
%t7728 = add i64 %p0, 16
%t7729 = call i64 @st64(i64 %t7728, i64 %t7709)
%t7730 = add i64 %p0, 8
%t7731 = call i64 @st32(i64 %t7730, i64 0)
%t7732 = add i64 %t7729, %t7731
br label %L2265
L2264:
%t7733 = call i64 @__mruntime_rt_list_resid__place_leaf(i64 %p0, i64 %t7701, i64 %t7702, i64 %t7709)
br label %L2265
L2265:
%t7734 = phi i64 [ %t7732, %L2263 ], [ %t7733, %L2264 ]
%t7735 = add i64 %t7701, %t7707
%t7736 = call i64 @st64(i64 %p0, i64 %t7735)
%t7737 = add i64 %p3, %t7707
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_list_resid__leaf_of(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t7748, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7749, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t7739 = icmp sle i64 %p1, 0
br i1 %t7739, label %L2266, label %L2268
L2266:
ret i64 %p0
L2268:
%t7740 = add i64 %p0, 8
%t7741 = icmp uge i64 %p1, 64
%t7742 = add i64 %p1, 0
%t7743 = select i1 %t7741, i64 63, i64 %t7742
%t7744 = ashr i64 %p2, %t7743
%t7745 = and i64 %t7744, 31
%t7746 = mul nsw i64 %t7745, 8
%t7747 = add i64 %t7740, %t7746
%t7748 = call i64 @ld64(i64 %t7747)
%t7749 = sub nsw i64 %p1, 5
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_list_resid__place_leaf(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7751 = call i64 @lshift(i64 %p0)
%t7752 = add i64 %t7751, 5
%t7753 = icmp uge i64 %t7752, 64
%t7754 = add i64 %t7752, 0
%t7755 = shl i64 1, %t7754
%t7756 = select i1 %t7753, i64 0, i64 %t7755
%t7757 = icmp sge i64 %p1, %t7756
br i1 %t7757, label %L2269, label %L2270
L2269:
%t7758 = call i64 @__mruntime_rt_list_resid__grow_root(i64 %p0)
br label %L2271
L2270:
br label %L2271
L2271:
%t7759 = phi i64 [ %t7758, %L2269 ], [ 0, %L2270 ]
%t7760 = call i64 @lshift(i64 %p0)
%t7761 = add i64 %p0, 16
%t7762 = icmp eq i64 %t7760, 0
br i1 %t7762, label %L2272, label %L2273
L2272:
br label %L2274
L2273:
%t7763 = call i64 @lroot(i64 %p0)
%t7764 = call i64 @__mruntime_rt_list_resid__set_leaf(i64 %t7763, i64 %t7760, i64 %p2, i64 %p3)
br label %L2274
L2274:
%t7765 = phi i64 [ %p3, %L2272 ], [ %t7764, %L2273 ]
%t7766 = call i64 @st64(i64 %t7761, i64 %t7765)
ret i64 %t7766
}
define internal i64 @__mruntime_rt_list_resid__grow_root(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7767 = call i64 @__mruntime_rt_list_resid__node_new(i64 1)
%t7768 = add i64 %t7767, 8
%t7769 = call i64 @lroot(i64 %p0)
%t7770 = call i64 @st64(i64 %t7768, i64 %t7769)
%t7771 = add i64 %p0, 16
%t7772 = call i64 @st64(i64 %t7771, i64 %t7767)
%t7773 = add i64 %p0, 8
%t7774 = call i64 @lshift(i64 %p0)
%t7775 = add i64 %t7774, 5
%t7776 = call i64 @st32(i64 %t7773, i64 %t7775)
ret i64 %t7776
}
define internal i64 @pvec_push(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7777p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.pvec_one)
%t7777 = ptrtoint ptr %t7777p to i64
%t7778 = call i64 @st64(i64 %t7777, i64 %p1)
%t7779 = call i64 @pvec_append_into(i64 0, i64 %p0, i64 %t7777, i64 1)
ret i64 %t7779
}
define ptr @resid_rt_pvec_push(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @pvec_push(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_list_resid__trie_from_items(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7780 = icmp slt i64 %p1, 32
br i1 %t7780, label %L2275, label %L2276
L2275:
br label %L2277
L2276:
br label %L2277
L2277:
%t7781 = phi i64 [ %p1, %L2275 ], [ 32, %L2276 ]
%t7782 = call i64 @__mruntime_rt_list_resid__node_new(i64 %t7781)
%t7783 = add i64 %t7782, 8
%t7784 = mul i64 %t7781, 8
%t7785 = call i64 @mcopy(i64 %t7783, i64 %p0, i64 %t7784)
%t7786 = call i64 @list_hdr()
%t7787 = call i64 @__mruntime_rt_list_resid__set_list(i64 %t7786, i64 %t7781, i64 0, i64 %t7782, i64 %p2)
%t7788 = icmp sgt i64 %p1, %t7781
br i1 %t7788, label %L2278, label %L2280
L2278:
%t7789 = mul i64 %t7781, 8
%t7790 = add i64 %p0, %t7789
%t7791 = sub i64 %p1, %t7781
%t7792 = call i64 @__mruntime_rt_list_resid__trie_append(i64 0, i64 %t7787, i64 %t7790, i64 %t7791)
ret i64 %t7792
L2280:
ret i64 %t7787
}
define internal i64 @rt_list_new(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7793p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.list_seed)
%t7793 = ptrtoint ptr %t7793p to i64
%t7794 = call i64 @__mruntime_rt_list_resid__set_list(i64 %t7793, i64 0, i64 0, i64 0, i64 %p2)
%t7795 = icmp eq i64 %p0, 0
br i1 %t7795, label %L2281, label %L2283
L2281:
%t7796 = call i64 @list_hdr()
%t7797 = call i64 @__mruntime_rt_list_resid__set_list(i64 %t7796, i64 0, i64 0, i64 0, i64 %p2)
ret i64 %t7797
L2283:
%t7798 = call i64 @pvec_append_into(i64 0, i64 %t7794, i64 %p1, i64 %p0)
ret i64 %t7798
}
define ptr @resid_list_new(i64 %a0, ptr %a1, ptr %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x1i = ptrtoint ptr %a1 to i64
%x2i = ptrtoint ptr %a2 to i64
%r = call i64 @rt_list_new(i64 %a0, i64 %x1i, i64 %x2i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_list_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7799 = tail call i64 @lcount(i64 %p0)
ret i64 %t7799
}
define i64 @resid_list_len(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_len(i64 %x0i)
ret i64 %r
}
define internal i64 @rt_list_get(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7800 = call i64 @lcount(i64 %p0)
%t7801 = call i1 @ult(i64 %p1, i64 %t7800)
%t7802 = xor i1 %t7801, true
br i1 %t7802, label %L2284, label %L2286
L2284:
%t7803 = call i64 @lcount(i64 %p0)
%t7804 = call i64 @rt_index_abort(i64 %p1, i64 %t7803, i64 0)
ret i64 %t7804
L2286:
%t7805 = tail call i64 @list_at(i64 %p0, i64 %p1)
ret i64 %t7805
}
define ptr @resid_list_get(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_get(i64 %x0i, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_list_get_nc(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7806 = tail call i64 @list_at(i64 %p0, i64 %p1)
ret i64 %t7806
}
define ptr @resid_list_get_nc(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_get_nc(i64 %x0i, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_list_type(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7807 = tail call i64 @ltype(i64 %p0)
ret i64 %t7807
}
define ptr @resid_list_type(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_type(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_list_to_array(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7808 = call i64 @lcount(i64 %p0)
%t7809 = icmp eq i64 %t7808, 0
br i1 %t7809, label %L2287, label %L2289
L2287:
ret i64 0
L2289:
%t7810 = mul i64 %t7808, 8
%t7811 = call i64 @xmalloc(i64 %t7810)
%t7812 = call i64 @lshift(i64 %p0)
%t7813 = sub nsw i64 0, 1
%t7814 = icmp eq i64 %t7812, %t7813
br i1 %t7814, label %L2290, label %L2291
L2290:
%t7815 = call i64 @lroot(i64 %p0)
%t7816 = add i64 %t7815, 24
%t7817 = mul i64 %t7808, 8
%t7818 = call i64 @mcopy(i64 %t7811, i64 %t7816, i64 %t7817)
br label %L2292
L2291:
%t7819 = call i64 @__mruntime_rt_list_resid__array_from_trie(i64 %p0, i64 %t7811, i64 0, i64 %t7808)
br label %L2292
L2292:
%t7820 = phi i64 [ %t7818, %L2290 ], [ %t7819, %L2291 ]
ret i64 %t7811
}
define ptr @resid_list_to_array(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_to_array(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_list_resid__array_from_trie(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t7826, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t7821 = icmp sge i64 %p2, %p3
br i1 %t7821, label %L2293, label %L2295
L2293:
ret i64 0
L2295:
%t7822 = mul i64 %p2, 8
%t7823 = add i64 %p1, %t7822
%t7824 = call i64 @list_at(i64 %p0, i64 %p2)
%t7825 = call i64 @st64(i64 %t7823, i64 %t7824)
%t7826 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_concat(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7828 = call i64 @lcount(i64 %p1)
%t7829 = icmp eq i64 %t7828, 0
br i1 %t7829, label %L2296, label %L2298
L2296:
ret i64 %p0
L2298:
%t7830 = icmp eq i64 %t7828, 1
br i1 %t7830, label %L2299, label %L2301
L2299:
%t7831 = call i64 @list_at(i64 %p1, i64 0)
%t7832 = tail call i64 @pvec_push(i64 %p0, i64 %t7831)
ret i64 %t7832
L2301:
%t7833 = call i64 @lshift(i64 %p1)
%t7834 = sub nsw i64 0, 1
%t7835 = icmp eq i64 %t7833, %t7834
br i1 %t7835, label %L2302, label %L2304
L2302:
%t7836 = call i64 @lroot(i64 %p1)
%t7837 = add i64 %t7836, 24
%t7838 = call i64 @pvec_append_into(i64 0, i64 %p0, i64 %t7837, i64 %t7828)
ret i64 %t7838
L2304:
%t7839 = call i64 @rt_list_to_array(i64 %p1)
%t7840 = call i64 @pvec_append_into(i64 0, i64 %p0, i64 %t7839, i64 %t7828)
%t7841 = call i64 @c_free(i64 %t7839)
%t7842 = mul nsw i64 %t7841, 0
%t7843 = add nsw i64 %t7842, %t7840
ret i64 %t7843
}
define ptr @resid_list_concat(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_list_concat(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_list_push(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7844 = tail call i64 @pvec_push(i64 %p0, i64 %p1)
ret i64 %t7844
}
define ptr @resid_list_push(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_list_push(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_listbuf_new() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7845 = call i64 @list_hdr()
%t7846 = sub nsw i64 0, 1
%t7847 = call i64 @__mruntime_rt_list_resid__set_list(i64 %t7845, i64 0, i64 %t7846, i64 0, i64 0)
ret i64 %t7847
}
define ptr @resid_listbuf_new() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_listbuf_new()
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_listbuf_push(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7848 = call i64 @lcount(i64 %p0)
%t7849 = call i64 @lroot(i64 %p0)
%t7850 = icmp eq i64 %t7849, 0
br label %LSL7851
LSL7851:
br i1 %t7850, label %LSJ7851, label %LSR7851
LSR7851:
%t7852 = add i64 %t7849, 8
%t7853 = call i64 @ld64(i64 %t7852)
%t7854 = icmp sge i64 %t7848, %t7853
br label %LSJ7851
LSJ7851:
%t7855 = phi i1 [ true, %LSL7851 ], [ %t7854, %LSR7851 ]
br i1 %t7855, label %L2305, label %L2306
L2305:
%t7856 = call i64 @__mruntime_rt_list_resid__lb_grow(i64 %p0, i64 %t7849, i64 %t7848)
br label %L2307
L2306:
br label %L2307
L2307:
%t7857 = phi i64 [ %t7856, %L2305 ], [ %t7849, %L2306 ]
%t7858 = add i64 %t7857, 24
%t7859 = mul i64 %t7848, 8
%t7860 = add i64 %t7858, %t7859
%t7861 = call i64 @st64(i64 %t7860, i64 %p1)
%t7862 = add i64 %t7848, 1
%t7863 = call i64 @st64(i64 %p0, i64 %t7862)
%t7864 = add i64 %t7848, 1
%t7865 = call i64 @st64(i64 %t7857, i64 %t7864)
%t7866 = mul nsw i64 %t7865, 0
%t7867 = add nsw i64 %t7866, %p0
ret i64 %t7867
}
define ptr @resid_listbuf_push(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_listbuf_push(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_list_resid__lb_grow(i64 %p0, i64 %p1, i64 %p2) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7868 = icmp slt i64 %p2, 4
br i1 %t7868, label %L2308, label %L2309
L2308:
br label %L2310
L2309:
%t7869 = mul i64 %p2, 2
br label %L2310
L2310:
%t7870 = phi i64 [ 8, %L2308 ], [ %t7869, %L2309 ]
%t7871 = call i64 @flat_new(i64 %t7870)
%t7872 = icmp sgt i64 %p2, 0
br i1 %t7872, label %L2311, label %L2312
L2311:
%t7873 = add i64 %t7871, 24
%t7874 = add i64 %p1, 24
%t7875 = mul i64 %p2, 8
%t7876 = call i64 @mcopy(i64 %t7873, i64 %t7874, i64 %t7875)
br label %L2313
L2312:
br label %L2313
L2313:
%t7877 = phi i64 [ %t7876, %L2311 ], [ 0, %L2312 ]
%t7878 = add i64 %p0, 16
%t7879 = call i64 @st64(i64 %t7878, i64 %t7871)
%t7880 = mul nsw i64 %t7879, 0
%t7881 = add nsw i64 %t7880, %t7871
ret i64 %t7881
}
define internal i64 @rt_listbuf_finish(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7882 = add i64 %p0, 24
%t7883 = call i64 @st64(i64 %t7882, i64 %p1)
%t7884 = call i64 @lroot(i64 %p0)
%t7885 = icmp eq i64 %t7884, 0
br i1 %t7885, label %L2314, label %L2315
L2314:
%t7886 = add i64 %p0, 8
%t7887 = call i64 @st32(i64 %t7886, i64 0)
br label %L2316
L2315:
br label %L2316
L2316:
%t7888 = phi i64 [ %t7887, %L2314 ], [ 0, %L2315 ]
ret i64 %p0
}
define ptr @resid_listbuf_finish(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_listbuf_finish(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_list_slice(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7889 = icmp sgt i64 %p1, 0
br i1 %t7889, label %L2317, label %L2318
L2317:
br label %L2319
L2318:
br label %L2319
L2319:
%t7890 = phi i64 [ %p1, %L2317 ], [ 0, %L2318 ]
%t7891 = call i64 @lcount(i64 %p0)
%t7892 = icmp slt i64 %p2, %t7891
br i1 %t7892, label %L2320, label %L2321
L2320:
br label %L2322
L2321:
br label %L2322
L2322:
%t7893 = phi i64 [ %p2, %L2320 ], [ %t7891, %L2321 ]
%t7894 = sub i64 %t7893, %t7890
%t7895 = icmp sgt i64 %t7894, 0
br i1 %t7895, label %L2323, label %L2324
L2323:
br label %L2325
L2324:
br label %L2325
L2325:
%t7896 = phi i64 [ %t7894, %L2323 ], [ 0, %L2324 ]
%t7897 = icmp sgt i64 %t7896, 0
br label %LSL7898
LSL7898:
br i1 %t7897, label %LSR7898, label %LSJ7898
LSR7898:
%t7899 = call i64 @lshift(i64 %p0)
%t7900 = sub nsw i64 0, 1
%t7901 = icmp eq i64 %t7899, %t7900
br label %LSJ7898
LSJ7898:
%t7902 = phi i1 [ false, %LSL7898 ], [ %t7901, %LSR7898 ]
br i1 %t7902, label %L2326, label %L2328
L2326:
%t7903 = call i64 @lroot(i64 %p0)
%t7904 = add i64 %t7903, 24
%t7905 = mul i64 %t7890, 8
%t7906 = add i64 %t7904, %t7905
%t7907 = call i64 @ltype(i64 %p0)
%t7908 = tail call i64 @rt_list_new(i64 %t7896, i64 %t7906, i64 %t7907)
ret i64 %t7908
L2328:
%t7909 = icmp sgt i64 %t7896, 1
br i1 %t7909, label %L2329, label %L2330
L2329:
br label %L2331
L2330:
br label %L2331
L2331:
%t7910 = phi i64 [ %t7896, %L2329 ], [ 1, %L2330 ]
%t7911 = mul i64 %t7910, 8
%t7912 = call i64 @xmalloc(i64 %t7911)
%t7913 = call i64 @__mruntime_rt_list_resid__slice_fill(i64 %p0, i64 %t7912, i64 %t7890, i64 0, i64 %t7896)
%t7914 = call i64 @ltype(i64 %p0)
%t7915 = call i64 @rt_list_new(i64 %t7896, i64 %t7912, i64 %t7914)
%t7916 = call i64 @c_free(i64 %t7912)
%t7917 = mul nsw i64 %t7916, 0
%t7918 = add nsw i64 %t7917, %t7915
ret i64 %t7918
}
define ptr @resid_list_slice(ptr %a0, i64 %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_slice(i64 %x0i, i64 %a1, i64 %a2)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_list_resid__slice_fill(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t7925, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t7919 = icmp sge i64 %p3, %p4
br i1 %t7919, label %L2332, label %L2334
L2332:
ret i64 0
L2334:
%t7920 = mul i64 %p3, 8
%t7921 = add i64 %p1, %t7920
%t7922 = add i64 %p2, %p3
%t7923 = call i64 @list_at(i64 %p0, i64 %t7922)
%t7924 = call i64 @st64(i64 %t7921, i64 %t7923)
%t7925 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_range_list(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7927 = icmp sgt i64 %p1, %p0
br i1 %t7927, label %L2335, label %L2336
L2335:
%t7928 = sub i64 %p1, %p0
br label %L2337
L2336:
br label %L2337
L2337:
%t7929 = phi i64 [ %t7928, %L2335 ], [ 0, %L2336 ]
%t7930 = icmp slt i64 %t7929, 0
br label %LSL7931
LSL7931:
br i1 %t7930, label %LSJ7931, label %LSR7931
LSR7931:
%t7932 = icmp sgt i64 %t7929, 1152921504606846975
br label %LSJ7931
LSJ7931:
%t7933 = phi i1 [ true, %LSL7931 ], [ %t7932, %LSR7931 ]
br i1 %t7933, label %L2338, label %L2340
L2338:
%t7935 = call i64 @rt_abort(ptr @.s7934)
ret i64 %t7935
L2340:
%t7936 = icmp sgt i64 %t7929, 1
br i1 %t7936, label %L2341, label %L2342
L2341:
br label %L2343
L2342:
br label %L2343
L2343:
%t7937 = phi i64 [ %t7929, %L2341 ], [ 1, %L2342 ]
%t7938 = mul i64 %t7937, 8
%t7939 = call i64 @xmalloc(i64 %t7938)
%t7940 = call i64 @__mruntime_rt_list_resid__range_fill(i64 %t7939, i64 %p0, i64 0, i64 %t7929)
%t7942 = ptrtoint ptr @.s7941 to i64
%t7943 = call i64 @rt_list_new(i64 %t7929, i64 %t7939, i64 %t7942)
%t7944 = call i64 @c_free(i64 %t7939)
%t7945 = mul nsw i64 %t7944, 0
%t7946 = add nsw i64 %t7945, %t7943
ret i64 %t7946
}
define ptr @resid_range_list(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_range_list(i64 %a0, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_list_resid__range_fill(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t7953, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t7947 = icmp sge i64 %p2, %p3
br i1 %t7947, label %L2344, label %L2346
L2344:
ret i64 0
L2346:
%t7948 = mul i64 %p2, 8
%t7949 = add i64 %p0, %t7948
%t7950 = add i64 %p1, %p2
%t7951 = call i64 @c_box_i64(i64 %t7950)
%t7952 = call i64 @st64(i64 %t7949, i64 %t7951)
%t7953 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_range_list_incl(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7955 = icmp eq i64 %p1, 9223372036854775807
br i1 %t7955, label %L2347, label %L2349
L2347:
%t7957 = call i64 @rt_abort(ptr @.s7956)
ret i64 %t7957
L2349:
%t7958 = add i64 %p1, 1
%t7959 = tail call i64 @rt_range_list(i64 %p0, i64 %t7958)
ret i64 %t7959
}
define ptr @resid_range_list_incl(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_range_list_incl(i64 %a0, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_assert(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7960 = icmp ne i64 %p0, 0
br i1 %t7960, label %L2350, label %L2352
L2350:
ret i64 0
L2352:
%t7961 = call i64 @rt_sb_new()
%t7963 = ptrtoint ptr @.s7962 to i64
%t7964 = call i64 @sb_lit(i64 %t7961, i64 %t7963)
%t7965 = icmp ne i64 %p1, 0
br i1 %t7965, label %L2353, label %L2354
L2353:
%t7967 = ptrtoint ptr @.s7966 to i64
%t7968 = call i64 @sb_lit(i64 %t7961, i64 %t7967)
%t7969 = call i64 @sb_lit(i64 %t7961, i64 %p1)
%t7970 = add i64 %t7968, %t7969
br label %L2355
L2354:
br label %L2355
L2355:
%t7971 = phi i64 [ %t7970, %L2353 ], [ 0, %L2354 ]
%t7972 = call i64 @rt_sb_finish(i64 %t7961)
%t7973 = call i64 @rt_abort_msg(i64 %t7972)
ret i64 %t7973
}
define void @resid_assert(i8 %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = zext i8 %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_assert(i64 %x0, i64 %x1i)
ret void
}
define internal i64 @rt_todo(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7974 = call i64 @rt_sb_new()
%t7975 = icmp ne i64 %p0, 0
br i1 %t7975, label %L2356, label %L2357
L2356:
%t7977 = ptrtoint ptr @.s7976 to i64
br label %L2358
L2357:
%t7979 = ptrtoint ptr @.s7978 to i64
br label %L2358
L2358:
%t7980 = phi i64 [ %t7977, %L2356 ], [ %t7979, %L2357 ]
%t7981 = call i64 @sb_lit(i64 %t7974, i64 %t7980)
%t7982 = icmp ne i64 %p1, 0
br i1 %t7982, label %L2359, label %L2360
L2359:
%t7984 = ptrtoint ptr @.s7983 to i64
%t7985 = call i64 @sb_lit(i64 %t7974, i64 %t7984)
%t7986 = call i64 @sb_lit(i64 %t7974, i64 %p1)
%t7987 = add i64 %t7985, %t7986
br label %L2361
L2360:
br label %L2361
L2361:
%t7988 = phi i64 [ %t7987, %L2359 ], [ 0, %L2360 ]
%t7989 = call i64 @rt_sb_finish(i64 %t7974)
%t7990 = call i64 @rt_abort_msg(i64 %t7989)
ret i64 %t7990
}
define void @resid_todo(i8 %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = zext i8 %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_todo(i64 %x0, i64 %x1i)
ret void
}
define internal i64 @rt_growbuf_from_list(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7991 = call i64 @lcount(i64 %p0)
%t7992 = call i64 @xmalloc(i64 24)
%t7993 = icmp slt i64 %t7991, 4
br i1 %t7993, label %L2362, label %L2363
L2362:
br label %L2364
L2363:
%t7994 = mul i64 %t7991, 2
br label %L2364
L2364:
%t7995 = phi i64 [ 4, %L2362 ], [ %t7994, %L2363 ]
%t7996 = mul i64 %t7995, 8
%t7997 = call i64 @xmalloc(i64 %t7996)
%t7998 = call i64 @rt_list_to_array(i64 %p0)
%t7999 = icmp sgt i64 %t7991, 0
br i1 %t7999, label %L2365, label %L2366
L2365:
%t8000 = mul i64 %t7991, 8
%t8001 = call i64 @mcopy(i64 %t7997, i64 %t7998, i64 %t8000)
br label %L2367
L2366:
br label %L2367
L2367:
%t8002 = phi i64 [ %t8001, %L2365 ], [ 0, %L2366 ]
%t8003 = call i64 @c_free(i64 %t7998)
%t8004 = call i64 @st64(i64 %t7992, i64 %t7991)
%t8005 = add i64 %t7992, 8
%t8006 = call i64 @st64(i64 %t8005, i64 %t7995)
%t8007 = add i64 %t7992, 16
%t8008 = call i64 @st64(i64 %t8007, i64 %t7997)
%t8009 = mul nsw i64 %t8008, 0
%t8010 = add nsw i64 %t8009, %t7992
ret i64 %t8010
}
define ptr @resid_growbuf_from_list(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_growbuf_from_list(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_growbuf_push_list(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8011 = call i64 @lcount(i64 %p1)
%t8012 = call i64 @ld64(i64 %p0)
%t8013 = add i64 %t8012, %t8011
%t8014 = add i64 %p0, 8
%t8015 = call i64 @ld64(i64 %t8014)
%t8016 = icmp sgt i64 %t8013, %t8015
br i1 %t8016, label %L2368, label %L2369
L2368:
%t8017 = call i64 @__mruntime_rt_list_resid__gb_grow(i64 %p0, i64 %t8013)
br label %L2370
L2369:
br label %L2370
L2370:
%t8018 = phi i64 [ %t8017, %L2368 ], [ 0, %L2369 ]
%t8019 = call i64 @rt_list_to_array(i64 %p1)
%t8020 = icmp sgt i64 %t8011, 0
br i1 %t8020, label %L2371, label %L2372
L2371:
%t8021 = add i64 %p0, 16
%t8022 = call i64 @ld64(i64 %t8021)
%t8023 = call i64 @ld64(i64 %p0)
%t8024 = mul i64 %t8023, 8
%t8025 = add i64 %t8022, %t8024
%t8026 = mul i64 %t8011, 8
%t8027 = call i64 @mcopy(i64 %t8025, i64 %t8019, i64 %t8026)
br label %L2373
L2372:
br label %L2373
L2373:
%t8028 = phi i64 [ %t8027, %L2371 ], [ 0, %L2372 ]
%t8029 = call i64 @c_free(i64 %t8019)
%t8030 = call i64 @st64(i64 %p0, i64 %t8013)
%t8031 = mul nsw i64 %t8030, 0
%t8032 = add nsw i64 %t8031, %p0
ret i64 %t8032
}
define ptr @resid_growbuf_push_list(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_growbuf_push_list(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_list_resid__gb_grow(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8033 = add i64 %p0, 8
%t8034 = call i64 @ld64(i64 %t8033)
%t8035 = mul i64 %t8034, 2
%t8036 = icmp sgt i64 %t8035, %p1
br i1 %t8036, label %L2374, label %L2375
L2374:
br label %L2376
L2375:
br label %L2376
L2376:
%t8037 = phi i64 [ %t8035, %L2374 ], [ %p1, %L2375 ]
%t8038 = add i64 %p0, 16
%t8039 = add i64 %p0, 16
%t8040 = call i64 @ld64(i64 %t8039)
%t8041 = mul i64 %t8037, 8
%t8042 = call i64 @xrealloc(i64 %t8040, i64 %t8041)
%t8043 = call i64 @st64(i64 %t8038, i64 %t8042)
%t8044 = add i64 %p0, 8
%t8045 = tail call i64 @st64(i64 %t8044, i64 %t8037)
ret i64 %t8045
}
define internal i64 @rt_growbuf_finish(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8046 = call i64 @ld64(i64 %p0)
%t8047 = add i64 %p0, 16
%t8048 = call i64 @ld64(i64 %t8047)
%t8049 = call i64 @rt_list_new(i64 %t8046, i64 %t8048, i64 %p1)
%t8050 = add i64 %p0, 16
%t8051 = call i64 @ld64(i64 %t8050)
%t8052 = call i64 @c_free(i64 %t8051)
%t8053 = call i64 @c_free(i64 %p0)
%t8054 = add i64 %t8052, %t8053
ret i64 %t8049
}
define ptr @resid_growbuf_finish(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_growbuf_finish(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_list_resid__box_free_shallow(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8055 = call i64 @c_box_interned(i64 %p0)
%t8056 = icmp ne i64 %t8055, 0
br i1 %t8056, label %L2377, label %L2378
L2377:
br label %L2379
L2378:
%t8057 = call i64 @c_free(i64 %p0)
br label %L2379
L2379:
%t8058 = phi i64 [ 0, %L2377 ], [ %t8057, %L2378 ]
ret i64 %t8058
}
define internal i64 @__mruntime_rt_list_resid__free_node(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8059 = icmp eq i64 %p0, 0
br i1 %t8059, label %L2380, label %L2382
L2380:
ret i64 0
L2382:
%t8060 = call i64 @ld64(i64 %p0)
%t8061 = call i64 @__mruntime_rt_list_resid__free_kids(i64 %p0, i64 %p1, i64 0, i64 %t8060)
%t8062 = call i64 @c_free(i64 %p0)
ret i64 %t8062
}
define internal i64 @__mruntime_rt_list_resid__free_kids(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8075, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t8063 = icmp sge i64 %p2, %p3
br i1 %t8063, label %L2383, label %L2385
L2383:
ret i64 0
L2385:
%t8064 = add i64 %p0, 8
%t8065 = mul i64 %p2, 8
%t8066 = add i64 %t8064, %t8065
%t8067 = call i64 @ld64(i64 %t8066)
%t8068 = icmp eq i64 %p1, 0
br i1 %t8068, label %L2386, label %L2387
L2386:
%t8069 = icmp ne i64 %t8067, 0
br i1 %t8069, label %L2389, label %L2390
L2389:
%t8070 = call i64 @__mruntime_rt_list_resid__box_free_shallow(i64 %t8067)
br label %L2391
L2390:
br label %L2391
L2391:
%t8071 = phi i64 [ %t8070, %L2389 ], [ 0, %L2390 ]
br label %L2388
L2387:
%t8072 = sub i64 %p1, 5
%t8073 = call i64 @__mruntime_rt_list_resid__free_node(i64 %t8067, i64 %t8072)
br label %L2388
L2388:
%t8074 = phi i64 [ %t8071, %L2391 ], [ %t8073, %L2387 ]
%t8075 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_free(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8077 = icmp eq i64 %p0, 0
br i1 %t8077, label %L2392, label %L2394
L2392:
ret i64 0
L2394:
%t8078 = call i64 @lroot(i64 %p0)
%t8079 = icmp ne i64 %t8078, 0
br label %LSL8080
LSL8080:
br i1 %t8079, label %LSR8080, label %LSJ8080
LSR8080:
%t8081 = call i64 @lshift(i64 %p0)
%t8082 = sub nsw i64 0, 1
%t8083 = icmp ne i64 %t8081, %t8082
br label %LSJ8080
LSJ8080:
%t8084 = phi i1 [ false, %LSL8080 ], [ %t8083, %LSR8080 ]
br i1 %t8084, label %L2395, label %L2396
L2395:
%t8085 = call i64 @lroot(i64 %p0)
%t8086 = call i64 @lshift(i64 %p0)
%t8087 = call i64 @__mruntime_rt_list_resid__free_node(i64 %t8085, i64 %t8086)
br label %L2397
L2396:
br label %L2397
L2397:
%t8088 = phi i64 [ %t8087, %L2395 ], [ 0, %L2396 ]
%t8089 = tail call i64 @c_free(i64 %p0)
ret i64 %t8089
}
define void @resid_list_free(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_free(i64 %x0i)
ret void
}
define internal i64 @__mruntime_rt_list_resid__free_slots(i64 %p0.in, i64 %p1.in, i64 %p2.in, i1 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8102, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i1 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t8090 = icmp sge i64 %p1, %p2
br i1 %t8090, label %L2398, label %L2400
L2398:
ret i64 0
L2400:
%t8091 = add i64 %p0, 16
%t8092 = mul i64 %p1, 8
%t8093 = add i64 %t8091, %t8092
%t8094 = call i64 @ld64(i64 %t8093)
%t8095 = icmp ne i64 %t8094, 0
br label %LSL8096
LSL8096:
br i1 %t8095, label %LSR8096, label %LSJ8096
LSR8096:
%t8097 = call i64 @c_box_interned(i64 %t8094)
%t8098 = icmp eq i64 %t8097, 0
br label %LSJ8096
LSJ8096:
%t8099 = phi i1 [ false, %LSL8096 ], [ %t8098, %LSR8096 ]
br i1 %t8099, label %L2401, label %L2402
L2401:
%t8100 = call i64 @c_free(i64 %t8094)
br label %L2403
L2402:
br label %L2403
L2403:
%t8101 = phi i64 [ %t8100, %L2401 ], [ 0, %L2402 ]
%t8102 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_struct_free(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8104 = icmp eq i64 %p0, 0
br i1 %t8104, label %L2404, label %L2406
L2404:
ret i64 0
L2406:
%t8105 = call i64 @box_count(i64 %p0)
%t8106 = call i64 @__mruntime_rt_list_resid__free_slots(i64 %p0, i64 0, i64 %t8105, i1 false)
%t8107 = tail call i64 @c_free(i64 %p0)
ret i64 %t8107
}
define void @resid_struct_free(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_struct_free(i64 %x0i)
ret void
}
define internal i64 @rt_box_free(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8108 = icmp eq i64 %p0, 0
br label %LSL8109
LSL8109:
br i1 %t8108, label %LSJ8109, label %LSR8109
LSR8109:
%t8110 = call i64 @c_box_interned(i64 %p0)
%t8111 = icmp ne i64 %t8110, 0
br label %LSJ8109
LSJ8109:
%t8112 = phi i1 [ true, %LSL8109 ], [ %t8111, %LSR8109 ]
br i1 %t8112, label %L2407, label %L2409
L2407:
ret i64 0
L2409:
%t8113 = call i64 @box_tag(i64 %p0)
%t8114 = sub nsw i64 0, 1
%t8115 = icmp ne i64 %t8113, %t8114
br i1 %t8115, label %L2410, label %L2411
L2410:
%t8116 = call i64 @box_count(i64 %p0)
%t8117 = call i64 @__mruntime_rt_list_resid__free_slots(i64 %p0, i64 0, i64 %t8116, i1 true)
br label %L2412
L2411:
br label %L2412
L2412:
%t8118 = phi i64 [ %t8117, %L2410 ], [ 0, %L2411 ]
%t8119 = tail call i64 @c_free(i64 %p0)
ret i64 %t8119
}
define void @resid_box_free(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_box_free(i64 %x0i)
ret void
}
define internal i64 @__mruntime_rt_map_resid__ld_i8(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8120 = call i64 @ld8(i64 %p0)
%t8121 = tail call i64 @sx8(i64 %t8120)
ret i64 %t8121
}
define internal i64 @__mruntime_rt_map_resid__popc(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8122 = tail call i64 @llvm.ctpop.i64(i64 %p0)
ret i64 %t8122
}
define internal i64 @__mruntime_rt_map_resid__mret() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8123p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_ret)
%t8123 = ptrtoint ptr %t8123p to i64
ret i64 %t8123
}
define internal i64 @__mruntime_rt_map_resid__mflag() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8124p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_flag)
%t8124 = ptrtoint ptr %t8124p to i64
ret i64 %t8124
}
define internal i64 @__mruntime_rt_map_resid__ret_word(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8125 = call i64 @__mruntime_rt_map_resid__mret()
%t8126 = call i64 @st64(i64 %t8125, i64 %p0)
%t8127 = mul nsw i64 %t8126, 0
%t8128 = add nsw i64 %t8127, 1
ret i64 %t8128
}
define internal i64 @__mruntime_rt_map_resid__map_heap_w() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8129p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_heap)
%t8129 = ptrtoint ptr %t8129p to i64
ret i64 %t8129
}
define internal i1 @__mruntime_rt_map_resid__map_heap() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8130 = call i64 @__mruntime_rt_map_resid__map_heap_w()
%t8131 = call i64 @ld64(i64 %t8130)
%t8132 = icmp ne i64 %t8131, 0
ret i1 %t8132
}
define internal i64 @__mruntime_rt_map_resid__sc_depth() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8133 = tail call i64 @c_sc_depth()
ret i64 %t8133
}
define internal i1 @__mruntime_rt_map_resid__in_region(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8134 = call i64 @c_sc_depth()
%t8135 = icmp ne i64 %t8134, 0
br label %LSL8136
LSL8136:
br i1 %t8135, label %LSR8136, label %LSJ8136
LSR8136:
%t8137 = call i64 @c_in_scope(i64 %p0)
%t8138 = icmp ne i64 %t8137, 0
br label %LSJ8136
LSJ8136:
%t8139 = phi i1 [ false, %LSL8136 ], [ %t8138, %LSR8136 ]
ret i1 %t8139
}
define internal i64 @__mruntime_rt_map_resid__map_obj(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8140 = call i1 @__mruntime_rt_map_resid__map_heap()
%t8141 = xor i1 %t8140, true
br label %LSL8142
LSL8142:
br i1 %t8141, label %LSR8142, label %LSJ8142
LSR8142:
%t8143 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t8144 = icmp ne i64 %t8143, 0
br label %LSJ8142
LSJ8142:
%t8145 = phi i1 [ false, %LSL8142 ], [ %t8144, %LSR8142 ]
br i1 %t8145, label %L2413, label %L2415
L2413:
%t8146 = tail call i64 @c_scope_alloc(i64 %p0)
ret i64 %t8146
L2415:
%t8147 = tail call i64 @xmalloc(i64 %p0)
ret i64 %t8147
}
define internal i64 @__mruntime_rt_map_resid__map_obj_free(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8148 = icmp ne i64 %p0, 0
br label %LSL8149
LSL8149:
br i1 %t8148, label %LSR8149, label %LSJ8149
LSR8149:
%t8150 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t8151 = xor i1 %t8150, true
br label %LSJ8149
LSJ8149:
%t8152 = phi i1 [ false, %LSL8149 ], [ %t8151, %LSR8149 ]
br i1 %t8152, label %L2416, label %L2417
L2416:
%t8153 = call i64 @c_free(i64 %p0)
br label %L2418
L2417:
br label %L2418
L2418:
%t8154 = phi i64 [ %t8153, %L2416 ], [ 0, %L2417 ]
ret i64 %t8154
}
define internal i64 @__mruntime_rt_map_resid__raw_empty() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8155 = sext i64 0 to i128
%t8156 = sub i128 %t8155, 9223372036854775807
%t8157 = sext i64 1 to i128
%t8158 = sub i128 %t8156, %t8157
%t8159 = trunc i128 %t8158 to i64
ret i64 %t8159
}
define internal i64 @__mruntime_rt_map_resid__raw_tomb() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8160 = sext i64 0 to i128
%t8161 = sub i128 %t8160, 9223372036854775807
%t8162 = trunc i128 %t8161 to i64
ret i64 %t8162
}
define internal i64 @__mruntime_rt_map_resid__fnv_off() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8163 = sext i64 0 to i128
%t8164 = sub i128 %t8163, 3750763034362895579
%t8165 = trunc i128 %t8164 to i64
ret i64 %t8165
}
define internal i64 @__mruntime_rt_map_resid__fnv_p() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 1099511628211
}
define internal i64 @__mruntime_rt_map_resid__fnv_str(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8166 = call i64 @__mruntime_rt_map_resid__fnv_off()
%t8167 = call i64 @__mruntime_rt_map_resid__fnv_from(i64 %t8166, i64 %p0)
ret i64 %t8167
}
define internal i64 @__mruntime_rt_map_resid__fnv_from(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t8172, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8173, %tco.s0 ]
%t8168 = call i64 @ld8(i64 %p1)
%t8169 = icmp eq i64 %t8168, 0
br i1 %t8169, label %L2419, label %L2421
L2419:
ret i64 %p0
L2421:
%t8170 = xor i64 %p0, %t8168
%t8171 = call i64 @__mruntime_rt_map_resid__fnv_p()
%t8172 = mul i64 %t8170, %t8171
%t8173 = add i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__fnv_dec(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8175 = sdiv i64 %p1, 10
%t8176 = icmp sgt i64 %t8175, 0
br i1 %t8176, label %L2422, label %L2423
L2422:
%t8177 = call i64 @__mruntime_rt_map_resid__fnv_dec(i64 %p0, i64 %t8175)
br label %L2424
L2423:
br label %L2424
L2424:
%t8178 = phi i64 [ %t8177, %L2422 ], [ %p0, %L2423 ]
%t8179 = add i64 48, %p1
%t8180 = mul nsw i64 %t8175, 10
%t8181 = sub i64 %t8179, %t8180
%t8182 = xor i64 %t8178, %t8181
%t8183 = call i64 @__mruntime_rt_map_resid__fnv_p()
%t8184 = mul i64 %t8182, %t8183
ret i64 %t8184
}
define internal i64 @__mruntime_rt_map_resid__fnv_i64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8185 = icmp slt i64 %p0, 0
br i1 %t8185, label %L2425, label %L2426
L2425:
%t8186 = call i64 @__mruntime_rt_map_resid__fnv_off()
%t8187 = xor i64 %t8186, 45
%t8188 = call i64 @__mruntime_rt_map_resid__fnv_p()
%t8189 = mul i64 %t8187, %t8188
br label %L2427
L2426:
%t8190 = call i64 @__mruntime_rt_map_resid__fnv_off()
br label %L2427
L2427:
%t8191 = phi i64 [ %t8189, %L2425 ], [ %t8190, %L2426 ]
%t8192 = call i64 @__mruntime_rt_map_resid__raw_empty()
%t8193 = icmp eq i64 %p0, %t8192
br i1 %t8193, label %L2428, label %L2430
L2428:
%t8194 = call i64 @__mruntime_rt_map_resid__fnv_dec(i64 %t8191, i64 922337203685477580)
%t8195 = xor i64 %t8194, 56
%t8196 = call i64 @__mruntime_rt_map_resid__fnv_p()
%t8197 = mul i64 %t8195, %t8196
ret i64 %t8197
L2430:
%t8198 = icmp slt i64 %p0, 0
br i1 %t8198, label %L2431, label %L2432
L2431:
%t8199 = sub i64 0, %p0
br label %L2433
L2432:
br label %L2433
L2433:
%t8200 = phi i64 [ %t8199, %L2431 ], [ %p0, %L2432 ]
%t8201 = call i64 @__mruntime_rt_map_resid__fnv_dec(i64 %t8191, i64 %t8200)
ret i64 %t8201
}
define internal i64 @__mruntime_rt_map_resid__fnv_f64(double %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8202p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_fbuf)
%t8202 = ptrtoint ptr %t8202p to i64
%t8204 = ptrtoint ptr @.s8203 to i64
%t8205 = call i64 @c_strfromd(i64 %t8202, i64 64, i64 %t8204, double %p0)
%t8206 = call i64 @__mruntime_rt_map_resid__fnv_str(i64 %t8202)
ret i64 %t8206
}
define internal i1 @__mruntime_rt_map_resid__is_boxed(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8207 = call i1 @box_imm(i64 %p0)
br label %LSL8208
LSL8208:
br i1 %t8207, label %LSJ8208, label %LSR8208
LSR8208:
%t8209 = call i1 @box_fimm(i64 %p0)
br label %LSJ8208
LSJ8208:
%t8210 = phi i1 [ true, %LSL8208 ], [ %t8209, %LSR8208 ]
br label %LSL8211
LSL8211:
br i1 %t8210, label %LSJ8211, label %LSR8211
LSR8211:
%t8212 = call i64 @ld8(i64 %p0)
%t8213 = icmp eq i64 %t8212, 255
br label %LSJ8211
LSJ8211:
%t8214 = phi i1 [ true, %LSL8211 ], [ %t8213, %LSR8211 ]
ret i1 %t8214
}
define internal i1 @__mruntime_rt_map_resid__type_is(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8215 = icmp ne i64 %p0, 0
br label %LSL8216
LSL8216:
br i1 %t8215, label %LSR8216, label %LSJ8216
LSR8216:
%t8217 = call i64 @c_strcmp(i64 %p0, i64 %p1)
%t8218 = icmp eq i64 %t8217, 0
br label %LSJ8216
LSJ8216:
%t8219 = phi i1 [ false, %LSL8216 ], [ %t8218, %LSR8216 ]
ret i1 %t8219
}
define internal i64 @__mruntime_rt_map_resid__stype(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8220 = call i1 @box_imm(i64 %p0)
br i1 %t8220, label %L2434, label %L2436
L2434:
ret i64 1
L2436:
%t8221 = call i1 @box_fimm(i64 %p0)
br i1 %t8221, label %L2437, label %L2439
L2437:
ret i64 2
L2439:
%t8222 = call i64 @box_tag(i64 %p0)
%t8223 = sub nsw i64 0, 1
%t8224 = icmp ne i64 %t8222, %t8223
br i1 %t8224, label %L2440, label %L2442
L2440:
ret i64 0
L2442:
%t8225 = call i64 @box_type(i64 %p0)
%t8227 = ptrtoint ptr @.s8226 to i64
%t8228 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8225, i64 %t8227)
br i1 %t8228, label %L2443, label %L2445
L2443:
ret i64 1
L2445:
%t8230 = ptrtoint ptr @.s8229 to i64
%t8231 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8225, i64 %t8230)
br i1 %t8231, label %L2446, label %L2448
L2446:
ret i64 2
L2448:
%t8233 = ptrtoint ptr @.s8232 to i64
%t8234 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8225, i64 %t8233)
br i1 %t8234, label %L2449, label %L2451
L2449:
ret i64 3
L2451:
%t8236 = ptrtoint ptr @.s8235 to i64
%t8237 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8225, i64 %t8236)
br i1 %t8237, label %L2452, label %L2454
L2452:
ret i64 4
L2454:
%t8239 = ptrtoint ptr @.s8238 to i64
%t8240 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8225, i64 %t8239)
br i1 %t8240, label %L2455, label %L2457
L2455:
ret i64 5
L2457:
ret i64 6
}
define internal i64 @__mruntime_rt_map_resid__value_hash(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8241 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p0)
%t8242 = xor i1 %t8241, true
br i1 %t8242, label %L2458, label %L2460
L2458:
%t8243 = tail call i64 @__mruntime_rt_map_resid__fnv_str(i64 %p0)
ret i64 %t8243
L2460:
%t8244 = call i1 @box_imm(i64 %p0)
br i1 %t8244, label %L2461, label %L2463
L2461:
%t8245 = call i64 @imm_val(i64 %p0)
%t8246 = tail call i64 @__mruntime_rt_map_resid__fnv_i64(i64 %t8245)
ret i64 %t8246
L2463:
%t8247 = call i1 @box_fimm(i64 %p0)
br i1 %t8247, label %L2464, label %L2466
L2464:
%t8248 = call double @unbox_float(i64 %p0)
%t8249 = call i64 @__mruntime_rt_map_resid__fnv_f64(double %t8248)
ret i64 %t8249
L2466:
%t8250 = call i64 @box_type(i64 %p0)
%t8251 = add i64 %p0, 16
%t8252 = call i64 @ld64(i64 %t8251)
%t8253 = call i64 @box_tag(i64 %p0)
%t8254 = sub nsw i64 0, 1
%t8255 = icmp eq i64 %t8253, %t8254
br i1 %t8255, label %L2467, label %L2469
L2467:
%t8256 = call i64 @__mruntime_rt_map_resid__stype(i64 %p0)
%t8257 = icmp eq i64 %t8256, 1
br label %LSL8258
LSL8258:
br i1 %t8257, label %LSJ8258, label %LSR8258
LSR8258:
%t8259 = icmp eq i64 %t8256, 4
br label %LSJ8258
LSJ8258:
%t8260 = phi i1 [ true, %LSL8258 ], [ %t8259, %LSR8258 ]
br i1 %t8260, label %L2470, label %L2472
L2470:
%t8261 = call i64 @ld64(i64 %t8252)
%t8262 = tail call i64 @__mruntime_rt_map_resid__fnv_i64(i64 %t8261)
ret i64 %t8262
L2472:
%t8263 = icmp eq i64 %t8256, 2
br i1 %t8263, label %L2473, label %L2475
L2473:
%t8264 = call i64 @ld64(i64 %t8252)
%t8265 = bitcast i64 %t8264 to double
%t8266 = call i64 @__mruntime_rt_map_resid__fnv_f64(double %t8265)
ret i64 %t8266
L2475:
%t8267 = icmp eq i64 %t8256, 3
br i1 %t8267, label %L2476, label %L2478
L2476:
%t8268 = call i64 @ld8(i64 %t8252)
%t8269 = icmp ne i64 %t8268, 0
br i1 %t8269, label %L2479, label %L2480
L2479:
%t8271 = ptrtoint ptr @.s8270 to i64
br label %L2481
L2480:
%t8273 = ptrtoint ptr @.s8272 to i64
br label %L2481
L2481:
%t8274 = phi i64 [ %t8271, %L2479 ], [ %t8273, %L2480 ]
%t8275 = tail call i64 @__mruntime_rt_map_resid__fnv_str(i64 %t8274)
ret i64 %t8275
L2478:
%t8276 = icmp eq i64 %t8256, 5
br i1 %t8276, label %L2482, label %L2484
L2482:
%t8277p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_ubuf)
%t8277 = ptrtoint ptr %t8277p to i64
%t8278 = call i64 @ld64(i64 %t8252)
%t8279 = call i64 @utoa_into(i64 %t8277, i64 %t8278)
%t8280 = add i64 %t8277, %t8279
%t8281 = call i64 @st8(i64 %t8280, i64 0)
%t8282 = mul nsw i64 %t8281, 0
%t8283 = call i64 @__mruntime_rt_map_resid__fnv_str(i64 %t8277)
%t8284 = add nsw i64 %t8282, %t8283
ret i64 %t8284
L2484:
%t8285 = icmp ne i64 %t8250, 0
br i1 %t8285, label %L2485, label %L2486
L2485:
br label %L2487
L2486:
%t8287 = ptrtoint ptr @.s8286 to i64
br label %L2487
L2487:
%t8288 = phi i64 [ %t8250, %L2485 ], [ %t8287, %L2486 ]
%t8289 = tail call i64 @__mruntime_rt_map_resid__fnv_str(i64 %t8288)
ret i64 %t8289
L2469:
%t8291 = ptrtoint ptr @.s8290 to i64
%t8292 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8250, i64 %t8291)
br i1 %t8292, label %L2488, label %L2490
L2488:
%t8293 = icmp ne i64 %t8252, 0
br i1 %t8293, label %L2491, label %L2492
L2491:
br label %L2493
L2492:
%t8295 = ptrtoint ptr @.s8294 to i64
br label %L2493
L2493:
%t8296 = phi i64 [ %t8252, %L2491 ], [ %t8295, %L2492 ]
%t8297 = tail call i64 @__mruntime_rt_map_resid__fnv_str(i64 %t8296)
ret i64 %t8297
L2490:
%t8298 = icmp ne i64 %t8250, 0
br i1 %t8298, label %L2494, label %L2495
L2494:
br label %L2496
L2495:
%t8300 = ptrtoint ptr @.s8299 to i64
br label %L2496
L2496:
%t8301 = phi i64 [ %t8250, %L2494 ], [ %t8300, %L2495 ]
%t8302 = tail call i64 @__mruntime_rt_map_resid__fnv_str(i64 %t8301)
ret i64 %t8302
}
define internal i1 @__mruntime_rt_map_resid__value_eq(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8303 = call i1 @box_imm(i64 %p0)
br label %LSL8304
LSL8304:
br i1 %t8303, label %LSJ8304, label %LSR8304
LSR8304:
%t8305 = call i1 @box_imm(i64 %p1)
br label %LSJ8304
LSJ8304:
%t8306 = phi i1 [ true, %LSL8304 ], [ %t8305, %LSR8304 ]
br label %LSL8307
LSL8307:
br i1 %t8306, label %LSJ8307, label %LSR8307
LSR8307:
%t8308 = call i1 @box_fimm(i64 %p0)
br label %LSJ8307
LSJ8307:
%t8309 = phi i1 [ true, %LSL8307 ], [ %t8308, %LSR8307 ]
br label %LSL8310
LSL8310:
br i1 %t8309, label %LSJ8310, label %LSR8310
LSR8310:
%t8311 = call i1 @box_fimm(i64 %p1)
br label %LSJ8310
LSJ8310:
%t8312 = phi i1 [ true, %LSL8310 ], [ %t8311, %LSR8310 ]
br i1 %t8312, label %L2497, label %L2499
L2497:
%t8313 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p0)
br i1 %t8313, label %L2500, label %L2501
L2500:
%t8314 = call i64 @__mruntime_rt_map_resid__stype(i64 %p0)
br label %L2502
L2501:
br label %L2502
L2502:
%t8315 = phi i64 [ %t8314, %L2500 ], [ 0, %L2501 ]
%t8316 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p1)
br i1 %t8316, label %L2503, label %L2504
L2503:
%t8317 = call i64 @__mruntime_rt_map_resid__stype(i64 %p1)
br label %L2505
L2504:
br label %L2505
L2505:
%t8318 = phi i64 [ %t8317, %L2503 ], [ 0, %L2504 ]
%t8319 = icmp eq i64 %t8315, 0
br label %LSL8320
LSL8320:
br i1 %t8319, label %LSJ8320, label %LSR8320
LSR8320:
%t8321 = icmp ne i64 %t8315, %t8318
br label %LSJ8320
LSJ8320:
%t8322 = phi i1 [ true, %LSL8320 ], [ %t8321, %LSR8320 ]
br i1 %t8322, label %L2506, label %L2508
L2506:
ret i1 false
L2508:
%t8323 = icmp eq i64 %t8315, 1
br i1 %t8323, label %L2509, label %L2511
L2509:
%t8324 = call i64 @unbox_word(i64 %p0)
%t8325 = call i64 @unbox_word(i64 %p1)
%t8326 = icmp eq i64 %t8324, %t8325
ret i1 %t8326
L2511:
%t8327 = icmp eq i64 %t8315, 2
br label %LSL8328
LSL8328:
br i1 %t8327, label %LSR8328, label %LSJ8328
LSR8328:
%t8329 = call double @unbox_float(i64 %p0)
%t8330 = call double @unbox_float(i64 %p1)
%t8331 = fcmp oeq double %t8329, %t8330
br label %LSJ8328
LSJ8328:
%t8332 = phi i1 [ false, %LSL8328 ], [ %t8331, %LSR8328 ]
ret i1 %t8332
L2499:
%t8333 = icmp eq i64 %p0, %p1
br i1 %t8333, label %L2512, label %L2514
L2512:
ret i1 true
L2514:
%t8334 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p0)
%t8335 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p1)
br label %LSL8336
LSL8336:
br i1 %t8334, label %LSR8336, label %LSJ8336
LSR8336:
br label %LSJ8336
LSJ8336:
%t8337 = phi i1 [ false, %LSL8336 ], [ %t8335, %LSR8336 ]
br i1 %t8337, label %L2515, label %L2517
L2515:
%t8338 = tail call i1 @__mruntime_rt_map_resid__boxed_eq(i64 %p0, i64 %p1)
ret i1 %t8338
L2517:
%t8339 = xor i1 %t8334, true
br label %LSL8340
LSL8340:
br i1 %t8339, label %LSR8340, label %LSJ8340
LSR8340:
%t8341 = xor i1 %t8335, true
br label %LSJ8340
LSJ8340:
%t8342 = phi i1 [ false, %LSL8340 ], [ %t8341, %LSR8340 ]
br i1 %t8342, label %L2518, label %L2520
L2518:
%t8343 = call i64 @c_strcmp(i64 %p0, i64 %p1)
%t8344 = icmp eq i64 %t8343, 0
ret i1 %t8344
L2520:
ret i1 false
}
define internal i1 @__mruntime_rt_map_resid__boxed_eq(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8345 = call i64 @box_type(i64 %p0)
%t8346 = call i64 @box_type(i64 %p1)
%t8347 = call i64 @box_tag(i64 %p0)
%t8348 = sub nsw i64 0, 1
%t8349 = icmp eq i64 %t8347, %t8348
br label %LSL8350
LSL8350:
br i1 %t8349, label %LSR8350, label %LSJ8350
LSR8350:
%t8351 = call i64 @box_tag(i64 %p1)
%t8352 = sub nsw i64 0, 1
%t8353 = icmp eq i64 %t8351, %t8352
br label %LSJ8350
LSJ8350:
%t8354 = phi i1 [ false, %LSL8350 ], [ %t8353, %LSR8350 ]
br i1 %t8354, label %L2521, label %L2523
L2521:
%t8355 = icmp eq i64 %t8345, 0
br label %LSL8356
LSL8356:
br i1 %t8355, label %LSJ8356, label %LSR8356
LSR8356:
%t8357 = icmp eq i64 %t8346, 0
br label %LSJ8356
LSJ8356:
%t8358 = phi i1 [ true, %LSL8356 ], [ %t8357, %LSR8356 ]
br label %LSL8359
LSL8359:
br i1 %t8358, label %LSJ8359, label %LSR8359
LSR8359:
%t8360 = call i64 @c_strcmp(i64 %t8345, i64 %t8346)
%t8361 = icmp ne i64 %t8360, 0
br label %LSJ8359
LSJ8359:
%t8362 = phi i1 [ true, %LSL8359 ], [ %t8361, %LSR8359 ]
br i1 %t8362, label %L2524, label %L2526
L2524:
ret i1 false
L2526:
%t8363 = add i64 %p0, 16
%t8364 = call i64 @ld64(i64 %t8363)
%t8365 = add i64 %p1, 16
%t8366 = call i64 @ld64(i64 %t8365)
%t8367 = icmp eq i64 %t8364, %t8366
br i1 %t8367, label %L2527, label %L2529
L2527:
ret i1 true
L2529:
%t8368 = call i64 @__mruntime_rt_map_resid__stype(i64 %p0)
%t8369 = icmp eq i64 %t8368, 1
br i1 %t8369, label %L2530, label %L2532
L2530:
%t8370 = call i64 @ld64(i64 %t8364)
%t8371 = call i64 @ld64(i64 %t8366)
%t8372 = icmp eq i64 %t8370, %t8371
ret i1 %t8372
L2532:
%t8373 = icmp eq i64 %t8368, 2
br i1 %t8373, label %L2533, label %L2535
L2533:
%t8374 = call i64 @ld64(i64 %t8364)
%t8375 = bitcast i64 %t8374 to double
%t8376 = call i64 @ld64(i64 %t8366)
%t8377 = bitcast i64 %t8376 to double
%t8378 = fcmp oeq double %t8375, %t8377
ret i1 %t8378
L2535:
%t8379 = icmp eq i64 %t8368, 3
br i1 %t8379, label %L2536, label %L2538
L2536:
%t8380 = call i64 @ld8(i64 %t8364)
%t8381 = call i64 @ld8(i64 %t8366)
%t8382 = icmp eq i64 %t8380, %t8381
ret i1 %t8382
L2538:
%t8383 = icmp eq i64 %t8368, 4
br label %LSL8384
LSL8384:
br i1 %t8383, label %LSJ8384, label %LSR8384
LSR8384:
%t8385 = icmp eq i64 %t8368, 5
br label %LSJ8384
LSJ8384:
%t8386 = phi i1 [ true, %LSL8384 ], [ %t8385, %LSR8384 ]
br i1 %t8386, label %L2539, label %L2541
L2539:
%t8387 = call i64 @ld64(i64 %t8364)
%t8388 = call i64 @ld64(i64 %t8366)
%t8389 = icmp eq i64 %t8387, %t8388
br label %LSL8390
LSL8390:
br i1 %t8389, label %LSR8390, label %LSJ8390
LSR8390:
%t8391 = add i64 %t8364, 8
%t8392 = call i64 @ld64(i64 %t8391)
%t8393 = add i64 %t8366, 8
%t8394 = call i64 @ld64(i64 %t8393)
%t8395 = icmp eq i64 %t8392, %t8394
br label %LSJ8390
LSJ8390:
%t8396 = phi i1 [ false, %LSL8390 ], [ %t8395, %LSR8390 ]
ret i1 %t8396
L2541:
ret i1 false
L2523:
%t8398 = ptrtoint ptr @.s8397 to i64
%t8399 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8345, i64 %t8398)
br label %LSL8400
LSL8400:
br i1 %t8399, label %LSR8400, label %LSJ8400
LSR8400:
%t8402 = ptrtoint ptr @.s8401 to i64
%t8403 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8346, i64 %t8402)
br label %LSJ8400
LSJ8400:
%t8404 = phi i1 [ false, %LSL8400 ], [ %t8403, %LSR8400 ]
br i1 %t8404, label %L2542, label %L2544
L2542:
%t8405 = add i64 %p0, 16
%t8406 = call i64 @ld64(i64 %t8405)
%t8407 = add i64 %p1, 16
%t8408 = call i64 @ld64(i64 %t8407)
%t8409 = icmp eq i64 %t8406, 0
br label %LSL8410
LSL8410:
br i1 %t8409, label %LSJ8410, label %LSR8410
LSR8410:
%t8411 = icmp eq i64 %t8408, 0
br label %LSJ8410
LSJ8410:
%t8412 = phi i1 [ true, %LSL8410 ], [ %t8411, %LSR8410 ]
br i1 %t8412, label %L2545, label %L2547
L2545:
%t8413 = icmp eq i64 %t8406, %t8408
ret i1 %t8413
L2547:
%t8414 = call i64 @c_strcmp(i64 %t8406, i64 %t8408)
%t8415 = icmp eq i64 %t8414, 0
ret i1 %t8415
L2544:
%t8416 = icmp eq i64 %p0, %p1
ret i1 %t8416
}
define internal i64 @__mruntime_rt_map_resid__key_hash(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8417 = icmp eq i64 %p0, 1
br i1 %t8417, label %L2548, label %L2549
L2548:
%t8418 = call i64 @__mruntime_rt_map_resid__fnv_i64(i64 %p1)
br label %L2550
L2549:
%t8419 = call i64 @__mruntime_rt_map_resid__value_hash(i64 %p1)
br label %L2550
L2550:
%t8420 = phi i64 [ %t8418, %L2548 ], [ %t8419, %L2549 ]
ret i64 %t8420
}
define internal i1 @__mruntime_rt_map_resid__key_eq(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8421 = icmp eq i64 %p0, 1
br i1 %t8421, label %L2551, label %L2552
L2551:
%t8422 = icmp eq i64 %p1, %p2
br label %L2553
L2552:
%t8423 = call i1 @__mruntime_rt_map_resid__value_eq(i64 %p1, i64 %p2)
br label %L2553
L2553:
%t8424 = phi i1 [ %t8422, %L2551 ], [ %t8423, %L2552 ]
ret i1 %t8424
}
define internal i64 @__mruntime_rt_map_resid__canon_rank(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8425 = call i64 @__mruntime_rt_map_resid__rank_at(i64 %p0, i64 0, i64 0)
%t8426 = shl i64 %t8425, 4
%t8427 = call i64 @lshr(i64 %p0, i64 60)
%t8428 = or i64 %t8426, %t8427
ret i64 %t8428
}
define internal i64 @__mruntime_rt_map_resid__rank_at(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8430, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8438, %tco.s0 ]
%t8429 = icmp sge i64 %p1, 12
br i1 %t8429, label %L2554, label %L2556
L2554:
ret i64 %p2
L2556:
%t8430 = add nsw i64 %p1, 1
%t8431 = shl i64 %p2, 5
%t8432 = mul i64 %p1, 5
%t8433 = icmp uge i64 %t8432, 64
%t8434 = add i64 %t8432, 0
%t8435 = select i1 %t8433, i64 63, i64 %t8434
%t8436 = ashr i64 %p0, %t8435
%t8437 = and i64 %t8436, 31
%t8438 = or i64 %t8431, %t8437
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__edit_seq() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8440p = getelementptr i8, ptr @rtg.map_edit_seq, i64 0
%t8440 = ptrtoint ptr %t8440p to i64
ret i64 %t8440
}
define internal i64 @__mruntime_rt_map_resid__new_edit() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8441 = call i64 @__mruntime_rt_map_resid__edit_seq()
%t8442p = inttoptr i64 %t8441 to ptr
%t8442 = atomicrmw add ptr %t8442p, i64 1 seq_cst
%t8443 = add i64 %t8442, 1
ret i64 %t8443
}
define internal i64 @__mruntime_rt_map_resid__box_any(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8444 = icmp eq i64 %p0, 1
br i1 %t8444, label %L2557, label %L2559
L2557:
%t8445 = call i64 @c_box_i64(i64 %p1)
ret i64 %t8445
L2559:
%t8446 = icmp eq i64 %p0, 2
br i1 %t8446, label %L2560, label %L2562
L2560:
%t8447 = bitcast i64 %p1 to double
%t8448 = call i64 @c_box_f64(double %t8447)
ret i64 %t8448
L2562:
%t8449 = icmp eq i64 %p0, 3
br i1 %t8449, label %L2563, label %L2565
L2563:
%t8450 = icmp ne i64 %p1, 0
br i1 %t8450, label %L2566, label %L2567
L2566:
br label %L2568
L2567:
br label %L2568
L2568:
%t8451 = phi i64 [ 1, %L2566 ], [ 0, %L2567 ]
%t8452 = call i64 @c_box_bool(i64 %t8451)
ret i64 %t8452
L2565:
ret i64 %p1
}
define internal i64 @__mruntime_rt_map_resid__mbox(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8453 = icmp slt i64 %p0, 1
br label %LSL8454
LSL8454:
br i1 %t8453, label %LSJ8454, label %LSR8454
LSR8454:
%t8455 = icmp sgt i64 %p0, 3
br label %LSJ8454
LSJ8454:
%t8456 = phi i1 [ true, %LSL8454 ], [ %t8455, %LSR8454 ]
br label %LSL8457
LSL8457:
br i1 %t8456, label %LSJ8457, label %LSR8457
LSR8457:
%t8458 = call i1 @__mruntime_rt_map_resid__map_heap()
%t8459 = xor i1 %t8458, true
br label %LSJ8457
LSJ8457:
%t8460 = phi i1 [ true, %LSL8457 ], [ %t8459, %LSR8457 ]
br label %LSL8461
LSL8461:
br i1 %t8460, label %LSJ8461, label %LSR8461
LSR8461:
%t8462 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t8463 = icmp eq i64 %t8462, 0
br label %LSJ8461
LSJ8461:
%t8464 = phi i1 [ true, %LSL8461 ], [ %t8463, %LSR8461 ]
br i1 %t8464, label %L2569, label %L2571
L2569:
%t8465 = tail call i64 @__mruntime_rt_map_resid__box_any(i64 %p0, i64 %p1)
ret i64 %t8465
L2571:
%t8466 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t8467 = call i64 @c_sc_depth_set(i64 0)
%t8468 = call i64 @__mruntime_rt_map_resid__box_any(i64 %p0, i64 %p1)
%t8469 = call i64 @c_sc_depth_set(i64 %t8466)
%t8470 = mul nsw i64 %t8469, 0
%t8471 = add nsw i64 %t8470, %t8468
ret i64 %t8471
}
define internal i1 @__mruntime_rt_map_resid__unbox_k(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8472 = call i1 @ult(i64 %p1, i64 4096)
br label %LSL8473
LSL8473:
br i1 %t8472, label %LSJ8473, label %LSR8473
LSR8473:
%t8474 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p1)
%t8475 = xor i1 %t8474, true
br label %LSJ8473
LSJ8473:
%t8476 = phi i1 [ true, %LSL8473 ], [ %t8475, %LSR8473 ]
br i1 %t8476, label %L2572, label %L2574
L2572:
ret i1 false
L2574:
%t8477 = call i64 @__mruntime_rt_map_resid__stype(i64 %p1)
%t8478 = icmp eq i64 %p0, 1
br label %LSL8479
LSL8479:
br i1 %t8478, label %LSR8479, label %LSJ8479
LSR8479:
%t8480 = icmp eq i64 %t8477, 1
br label %LSJ8479
LSJ8479:
%t8481 = phi i1 [ false, %LSL8479 ], [ %t8480, %LSR8479 ]
br i1 %t8481, label %L2575, label %L2577
L2575:
%t8482 = call i64 @unbox_word(i64 %p1)
%t8483 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t8482)
%t8484 = icmp ne i64 %t8483, 0
ret i1 %t8484
L2577:
%t8485 = icmp eq i64 %p0, 2
br label %LSL8486
LSL8486:
br i1 %t8485, label %LSR8486, label %LSJ8486
LSR8486:
%t8487 = icmp eq i64 %t8477, 2
br label %LSJ8486
LSJ8486:
%t8488 = phi i1 [ false, %LSL8486 ], [ %t8487, %LSR8486 ]
br i1 %t8488, label %L2578, label %L2580
L2578:
%t8489 = call double @unbox_float(i64 %p1)
%t8490 = bitcast double %t8489 to i64
%t8491 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t8490)
%t8492 = icmp ne i64 %t8491, 0
ret i1 %t8492
L2580:
%t8493 = icmp eq i64 %p0, 3
br label %LSL8494
LSL8494:
br i1 %t8493, label %LSR8494, label %LSJ8494
LSR8494:
%t8495 = icmp eq i64 %t8477, 3
br label %LSJ8494
LSJ8494:
%t8496 = phi i1 [ false, %LSL8494 ], [ %t8495, %LSR8494 ]
br i1 %t8496, label %L2581, label %L2583
L2581:
%t8497 = add i64 %p1, 24
%t8498 = call i64 @ld8(i64 %t8497)
%t8499 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t8498)
%t8500 = icmp ne i64 %t8499, 0
ret i1 %t8500
L2583:
ret i1 false
}
define internal i64 @__mruntime_rt_map_resid__word_of_box(i64 %p0, i1 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8501 = call i1 @ult(i64 %p0, i64 4096)
%t8502 = xor i1 %t8501, true
br label %LSL8503
LSL8503:
br i1 %t8502, label %LSR8503, label %LSJ8503
LSR8503:
%t8504 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p0)
br label %LSJ8503
LSJ8503:
%t8505 = phi i1 [ false, %LSL8503 ], [ %t8504, %LSR8503 ]
br i1 %t8505, label %L2584, label %L2585
L2584:
%t8506 = call i64 @__mruntime_rt_map_resid__stype(i64 %p0)
br label %L2586
L2585:
br label %L2586
L2586:
%t8507 = phi i64 [ %t8506, %L2584 ], [ 0, %L2585 ]
%t8508 = icmp eq i64 %t8507, 1
br i1 %t8508, label %L2587, label %L2589
L2587:
%t8509 = call i64 @unbox_word(i64 %p0)
%t8510 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t8509)
ret i64 %t8510
L2589:
%t8511 = xor i1 %p1, true
br label %LSL8512
LSL8512:
br i1 %t8511, label %LSR8512, label %LSJ8512
LSR8512:
%t8513 = icmp eq i64 %t8507, 2
br label %LSJ8512
LSJ8512:
%t8514 = phi i1 [ false, %LSL8512 ], [ %t8513, %LSR8512 ]
br i1 %t8514, label %L2590, label %L2592
L2590:
%t8515 = call double @unbox_float(i64 %p0)
%t8516 = bitcast double %t8515 to i64
%t8517 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t8516)
%t8518 = mul i64 %t8517, 2
ret i64 %t8518
L2592:
%t8519 = xor i1 %p1, true
br label %LSL8520
LSL8520:
br i1 %t8519, label %LSR8520, label %LSJ8520
LSR8520:
%t8521 = icmp eq i64 %t8507, 3
br label %LSJ8520
LSJ8520:
%t8522 = phi i1 [ false, %LSL8520 ], [ %t8521, %LSR8520 ]
br i1 %t8522, label %L2593, label %L2595
L2593:
%t8523 = add i64 %p0, 24
%t8524 = call i64 @ld8(i64 %t8523)
%t8525 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t8524)
%t8526 = mul i64 %t8525, 3
ret i64 %t8526
L2595:
%t8527 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %p0)
%t8528 = mul nsw i64 %t8527, 0
ret i64 %t8528
}
define internal i64 @rt_str_keep(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8529 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t8530 = icmp eq i64 %t8529, 0
br label %LSL8531
LSL8531:
br i1 %t8530, label %LSJ8531, label %LSR8531
LSR8531:
%t8532 = call i64 @c_in_scope(i64 %p0)
%t8533 = icmp eq i64 %t8532, 0
br label %LSJ8531
LSJ8531:
%t8534 = phi i1 [ true, %LSL8531 ], [ %t8533, %LSR8531 ]
br i1 %t8534, label %L2596, label %L2598
L2596:
ret i64 %p0
L2598:
%t8535 = call i64 @c_strlen(i64 %p0)
%t8536 = add i64 %t8535, 1
%t8537 = call i64 @c_outer_alloc(i64 %t8536)
%t8538 = call i64 @mcopy(i64 %t8537, i64 %p0, i64 %t8536)
%t8539 = mul nsw i64 %t8538, 0
%t8540 = add nsw i64 %t8539, %t8537
ret i64 %t8540
}
define ptr @resid_str_keep(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_keep(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_map_resid__word_keep(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8541 = icmp eq i64 %p0, 4
br i1 %t8541, label %L2599, label %L2601
L2599:
%t8542 = call i64 @rt_str_keep(i64 %p1)
ret i64 %t8542
L2601:
%t8543 = icmp eq i64 %p0, 5
br i1 %t8543, label %L2602, label %L2604
L2602:
%t8544 = call i64 @rt_list_keep(i64 %p1)
ret i64 %t8544
L2604:
ret i64 %p1
}
define internal i64 @__mruntime_rt_map_resid__ndmap(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8545 = tail call i64 @ld32(i64 %p0)
ret i64 %t8545
}
define internal i64 @__mruntime_rt_map_resid__nnmap(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8546 = add i64 %p0, 4
%t8547 = tail call i64 @ld32(i64 %t8546)
ret i64 %t8547
}
define internal i64 @__mruntime_rt_map_resid__nncoll(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8548 = add i64 %p0, 8
%t8549 = tail call i64 @ld32(i64 %t8548)
ret i64 %t8549
}
define internal i64 @__mruntime_rt_map_resid__ncap(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8550 = add i64 %p0, 12
%t8551 = tail call i64 @ld32(i64 %t8550)
ret i64 %t8551
}
define internal i64 @__mruntime_rt_map_resid__nedit(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8552 = add i64 %p0, 16
%t8553 = tail call i64 @ld64(i64 %t8552)
ret i64 %t8553
}
define internal i64 @__mruntime_rt_map_resid__nw(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8554 = add i64 %p0, 24
ret i64 %t8554
}
define internal i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8555 = add i64 %p0, 24
%t8556 = mul i64 %p1, 8
%t8557 = add i64 %t8555, %t8556
%t8558 = call i64 @ld64(i64 %t8557)
ret i64 %t8558
}
define internal i64 @__mruntime_rt_map_resid__wset(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8559 = add i64 %p0, 24
%t8560 = mul i64 %p1, 8
%t8561 = add i64 %t8559, %t8560
%t8562 = call i64 @st64(i64 %t8561, i64 %p2)
ret i64 %t8562
}
define internal i64 @__mruntime_rt_map_resid__node_nd(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8563 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t8564 = icmp ne i64 %t8563, 0
br i1 %t8564, label %L2605, label %L2606
L2605:
%t8565 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
br label %L2607
L2606:
%t8566 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8567 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8566)
br label %L2607
L2607:
%t8568 = phi i64 [ %t8565, %L2605 ], [ %t8567, %L2606 ]
ret i64 %t8568
}
define internal i64 @__mruntime_rt_map_resid__node_nn(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8569 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t8570 = icmp ne i64 %t8569, 0
br i1 %t8570, label %L2608, label %L2609
L2608:
br label %L2610
L2609:
%t8571 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8572 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8571)
br label %L2610
L2610:
%t8573 = phi i64 [ 0, %L2608 ], [ %t8572, %L2609 ]
ret i64 %t8573
}
define internal i64 @__mruntime_rt_map_resid__node_words(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8574 = call i64 @__mruntime_rt_map_resid__node_nd(i64 %p0)
%t8575 = mul i64 2, %t8574
%t8576 = call i64 @__mruntime_rt_map_resid__node_nn(i64 %p0)
%t8577 = add i64 %t8575, %t8576
ret i64 %t8577
}
define internal i64 @__mruntime_rt_map_resid__slot_bit(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8578 = mul i64 %p1, 5
%t8579 = call i64 @lshr(i64 %p0, i64 %t8578)
%t8580 = and i64 %t8579, 31
%t8581 = icmp uge i64 %t8580, 64
%t8582 = add i64 %t8580, 0
%t8583 = shl i64 1, %t8582
%t8584 = select i1 %t8581, i64 0, i64 %t8583
ret i64 %t8584
}
define internal i64 @__mruntime_rt_map_resid__node_new(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8585 = mul i64 %p0, 8
%t8586 = add i64 24, %t8585
%t8587 = call i64 @__mruntime_rt_map_resid__map_obj(i64 %t8586)
%t8588 = call i64 @st32(i64 %t8587, i64 0)
%t8589 = add i64 %t8587, 4
%t8590 = call i64 @st32(i64 %t8589, i64 0)
%t8591 = add i64 %t8588, %t8590
%t8592 = add i64 %t8587, 8
%t8593 = call i64 @st32(i64 %t8592, i64 0)
%t8594 = add i64 %t8591, %t8593
%t8595 = add i64 %t8587, 12
%t8596 = call i64 @st32(i64 %t8595, i64 %p0)
%t8597 = add i64 %t8587, 16
%t8598 = call i64 @st64(i64 %t8597, i64 %p1)
%t8599 = mul nsw i64 %t8598, 0
%t8600 = add nsw i64 %t8599, %t8587
ret i64 %t8600
}
define internal i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8601 = call i64 @__mruntime_rt_map_resid__node_words(i64 %p0)
%t8602 = icmp ne i64 %p2, 0
br label %LSL8603
LSL8603:
br i1 %t8602, label %LSR8603, label %LSJ8603
LSR8603:
%t8604 = call i64 @__mruntime_rt_map_resid__nedit(i64 %p0)
%t8605 = icmp eq i64 %t8604, %p2
br label %LSJ8603
LSJ8603:
%t8606 = phi i1 [ false, %LSL8603 ], [ %t8605, %LSR8603 ]
br label %LSL8607
LSL8607:
br i1 %t8606, label %LSR8607, label %LSJ8607
LSR8607:
%t8608 = add i64 %t8601, %p1
%t8609 = call i64 @__mruntime_rt_map_resid__ncap(i64 %p0)
%t8610 = icmp sle i64 %t8608, %t8609
br label %LSJ8607
LSJ8607:
%t8611 = phi i1 [ false, %LSL8607 ], [ %t8610, %LSR8607 ]
br i1 %t8611, label %L2611, label %L2613
L2611:
ret i64 %p0
L2613:
%t8612 = icmp sgt i64 %p1, 0
br i1 %t8612, label %L2614, label %L2615
L2614:
br label %L2616
L2615:
br label %L2616
L2616:
%t8613 = phi i64 [ %p1, %L2614 ], [ 0, %L2615 ]
%t8614 = icmp ne i64 %p2, 0
br i1 %t8614, label %L2617, label %L2618
L2617:
br label %L2619
L2618:
br label %L2619
L2619:
%t8615 = phi i64 [ 4, %L2617 ], [ 0, %L2618 ]
%t8616 = add i64 %t8613, %t8615
%t8617 = add i64 %t8601, %t8616
%t8618 = call i64 @__mruntime_rt_map_resid__node_new(i64 %t8617, i64 %p2)
%t8619 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8620 = call i64 @st32(i64 %t8618, i64 %t8619)
%t8621 = add i64 %t8618, 4
%t8622 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8623 = call i64 @st32(i64 %t8621, i64 %t8622)
%t8624 = add i64 %t8620, %t8623
%t8625 = add i64 %t8618, 8
%t8626 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t8627 = call i64 @st32(i64 %t8625, i64 %t8626)
%t8628 = add i64 %t8624, %t8627
%t8629 = call i64 @__mruntime_rt_map_resid__nw(i64 %t8618)
%t8630 = call i64 @__mruntime_rt_map_resid__nw(i64 %p0)
%t8631 = mul i64 %t8601, 8
%t8632 = call i64 @mcopy(i64 %t8629, i64 %t8630, i64 %t8631)
%t8633 = mul nsw i64 %t8632, 0
%t8634 = add nsw i64 %t8633, %t8618
ret i64 %t8634
}
define internal i64 @__mruntime_rt_map_resid__node_leaf(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8635 = icmp ne i64 %p4, 0
br i1 %t8635, label %L2620, label %L2621
L2620:
br label %L2622
L2621:
br label %L2622
L2622:
%t8636 = phi i64 [ 6, %L2620 ], [ 2, %L2621 ]
%t8637 = call i64 @__mruntime_rt_map_resid__node_new(i64 %t8636, i64 %p4)
%t8638 = call i64 @__mruntime_rt_map_resid__slot_bit(i64 %p1, i64 %p0)
%t8639 = call i64 @st32(i64 %t8637, i64 %t8638)
%t8640 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8637, i64 0, i64 %p2)
%t8641 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8637, i64 1, i64 %p3)
%t8642 = mul nsw i64 %t8641, 0
%t8643 = add nsw i64 %t8642, %t8637
ret i64 %t8643
}
define internal i64 @__mruntime_rt_map_resid__node_coll2(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8644 = icmp ne i64 %p4, 0
br i1 %t8644, label %L2623, label %L2624
L2623:
br label %L2625
L2624:
br label %L2625
L2625:
%t8645 = phi i64 [ 8, %L2623 ], [ 4, %L2624 ]
%t8646 = call i64 @__mruntime_rt_map_resid__node_new(i64 %t8645, i64 %p4)
%t8647 = add i64 %t8646, 8
%t8648 = call i64 @st32(i64 %t8647, i64 2)
%t8649 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8646, i64 0, i64 %p0)
%t8650 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8646, i64 1, i64 %p1)
%t8651 = add i64 %t8649, %t8650
%t8652 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8646, i64 2, i64 %p2)
%t8653 = add i64 %t8651, %t8652
%t8654 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8646, i64 3, i64 %p3)
%t8655 = add i64 %t8653, %t8654
ret i64 %t8646
}
define internal i64 @__mruntime_rt_map_resid__node_pair(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8656 = icmp sgt i64 %p0, 12
br i1 %t8656, label %L2626, label %L2628
L2626:
%t8657 = call i64 @__mruntime_rt_map_resid__node_coll2(i64 %p2, i64 %p3, i64 %p5, i64 %p6, i64 %p7)
ret i64 %t8657
L2628:
%t8658 = call i64 @__mruntime_rt_map_resid__slot_bit(i64 %p1, i64 %p0)
%t8659 = call i64 @__mruntime_rt_map_resid__slot_bit(i64 %p4, i64 %p0)
%t8660 = icmp eq i64 %t8658, %t8659
br i1 %t8660, label %L2629, label %L2631
L2629:
%t8661 = add nsw i64 %p0, 1
%t8662 = call i64 @__mruntime_rt_map_resid__node_pair(i64 %t8661, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7)
%t8663 = icmp ne i64 %p7, 0
br i1 %t8663, label %L2632, label %L2633
L2632:
br label %L2634
L2633:
br label %L2634
L2634:
%t8664 = phi i64 [ 5, %L2632 ], [ 1, %L2633 ]
%t8665 = call i64 @__mruntime_rt_map_resid__node_new(i64 %t8664, i64 %p7)
%t8666 = add i64 %t8665, 4
%t8667 = call i64 @st32(i64 %t8666, i64 %t8658)
%t8668 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8665, i64 0, i64 %t8662)
%t8669 = mul nsw i64 %t8668, 0
%t8670 = add nsw i64 %t8669, %t8665
ret i64 %t8670
L2631:
%t8671 = icmp ne i64 %p7, 0
br i1 %t8671, label %L2635, label %L2636
L2635:
br label %L2637
L2636:
br label %L2637
L2637:
%t8672 = phi i64 [ 8, %L2635 ], [ 4, %L2636 ]
%t8673 = call i64 @__mruntime_rt_map_resid__node_new(i64 %t8672, i64 %p7)
%t8674 = or i64 %t8658, %t8659
%t8675 = call i64 @st32(i64 %t8673, i64 %t8674)
%t8676 = icmp slt i64 %t8658, %t8659
br i1 %t8676, label %L2638, label %L2639
L2638:
br label %L2640
L2639:
br label %L2640
L2640:
%t8677 = phi i64 [ %p2, %L2638 ], [ %p5, %L2639 ]
%t8678 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8673, i64 0, i64 %t8677)
br i1 %t8676, label %L2641, label %L2642
L2641:
br label %L2643
L2642:
br label %L2643
L2643:
%t8679 = phi i64 [ %p3, %L2641 ], [ %p6, %L2642 ]
%t8680 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8673, i64 1, i64 %t8679)
%t8681 = add i64 %t8678, %t8680
br i1 %t8676, label %L2644, label %L2645
L2644:
br label %L2646
L2645:
br label %L2646
L2646:
%t8682 = phi i64 [ %p5, %L2644 ], [ %p2, %L2645 ]
%t8683 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8673, i64 2, i64 %t8682)
%t8684 = add i64 %t8681, %t8683
br i1 %t8676, label %L2647, label %L2648
L2647:
br label %L2649
L2648:
br label %L2649
L2649:
%t8685 = phi i64 [ %p6, %L2647 ], [ %p3, %L2648 ]
%t8686 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8673, i64 3, i64 %t8685)
%t8687 = add i64 %t8684, %t8686
ret i64 %t8673
}
define internal i64 @__mruntime_rt_map_resid__node_ins_data(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8688 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8689 = sub i64 %p1, 1
%t8690 = and i64 %t8688, %t8689
%t8691 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8690)
%t8692 = call i64 @__mruntime_rt_map_resid__node_words(i64 %p0)
%t8693 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 2, i64 %p4)
%t8694 = call i64 @__mruntime_rt_map_resid__nw(i64 %t8693)
%t8695 = mul i64 2, %t8691
%t8696 = add i64 %t8695, 2
%t8697 = mul i64 %t8696, 8
%t8698 = add i64 %t8694, %t8697
%t8699 = call i64 @__mruntime_rt_map_resid__nw(i64 %t8693)
%t8700 = mul i64 2, %t8691
%t8701 = mul i64 %t8700, 8
%t8702 = add i64 %t8699, %t8701
%t8703 = mul i64 2, %t8691
%t8704 = sub i64 %t8692, %t8703
%t8705 = mul i64 %t8704, 8
%t8706 = call i64 @mcopy(i64 %t8698, i64 %t8702, i64 %t8705)
%t8707 = mul i64 2, %t8691
%t8708 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8693, i64 %t8707, i64 %p2)
%t8709 = mul i64 2, %t8691
%t8710 = add i64 %t8709, 1
%t8711 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8693, i64 %t8710, i64 %p3)
%t8712 = add i64 %t8708, %t8711
%t8713 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %t8693)
%t8714 = or i64 %t8713, %p1
%t8715 = call i64 @st32(i64 %t8693, i64 %t8714)
%t8716 = mul nsw i64 %t8715, 0
%t8717 = add nsw i64 %t8716, %t8693
ret i64 %t8717
}
define internal i64 @__mruntime_rt_map_resid__node_data_to_sub(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8718 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8719 = sub i64 %p1, 1
%t8720 = and i64 %t8718, %t8719
%t8721 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8720)
%t8722 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8723 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8722)
%t8724 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8725 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8724)
%t8726 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8727 = sub i64 %p1, 1
%t8728 = and i64 %t8726, %t8727
%t8729 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8728)
%t8730 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p3)
%t8731 = call i64 @__mruntime_rt_map_resid__nw(i64 %t8730)
%t8732 = mul i64 2, %t8721
%t8733 = mul i64 %t8732, 8
%t8734 = add i64 %t8731, %t8733
%t8735 = mul i64 2, %t8721
%t8736 = add i64 %t8735, 2
%t8737 = mul i64 %t8736, 8
%t8738 = add i64 %t8731, %t8737
%t8739 = sub i64 %t8723, %t8721
%t8740 = sub i64 %t8739, 1
%t8741 = mul i64 2, %t8740
%t8742 = mul i64 %t8741, 8
%t8743 = call i64 @mcopy(i64 %t8734, i64 %t8738, i64 %t8742)
%t8744 = sub i64 %t8723, 1
%t8745 = mul i64 2, %t8744
%t8746 = mul i64 %t8745, 8
%t8747 = add i64 %t8731, %t8746
%t8748 = mul i64 2, %t8723
%t8749 = mul i64 %t8748, 8
%t8750 = add i64 %t8731, %t8749
%t8751 = mul i64 %t8729, 8
%t8752 = call i64 @mcopy(i64 %t8747, i64 %t8750, i64 %t8751)
%t8753 = sub i64 %t8723, 1
%t8754 = mul i64 2, %t8753
%t8755 = add i64 %t8754, %t8729
%t8756 = add i64 %t8755, 1
%t8757 = mul i64 %t8756, 8
%t8758 = add i64 %t8731, %t8757
%t8759 = mul i64 2, %t8723
%t8760 = add i64 %t8759, %t8729
%t8761 = mul i64 %t8760, 8
%t8762 = add i64 %t8731, %t8761
%t8763 = sub i64 %t8725, %t8729
%t8764 = mul i64 %t8763, 8
%t8765 = call i64 @mcopy(i64 %t8758, i64 %t8762, i64 %t8764)
%t8766 = sub i64 %t8723, 1
%t8767 = mul i64 2, %t8766
%t8768 = add i64 %t8767, %t8729
%t8769 = mul i64 %t8768, 8
%t8770 = add i64 %t8731, %t8769
%t8771 = call i64 @st64(i64 %t8770, i64 %p2)
%t8772 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %t8730)
%t8773 = xor i64 %p1, -1
%t8774 = and i64 %t8772, %t8773
%t8775 = call i64 @st32(i64 %t8730, i64 %t8774)
%t8776 = add i64 %t8730, 4
%t8777 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %t8730)
%t8778 = or i64 %t8777, %p1
%t8779 = call i64 @st32(i64 %t8776, i64 %t8778)
%t8780 = mul nsw i64 %t8779, 0
%t8781 = add nsw i64 %t8780, %t8730
ret i64 %t8781
}
define internal i64 @__mruntime_rt_map_resid__node_sub_to_data(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8782 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8783 = sub i64 %p1, 1
%t8784 = and i64 %t8782, %t8783
%t8785 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8784)
%t8786 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8787 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8786)
%t8788 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8789 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8788)
%t8790 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8791 = sub i64 %p1, 1
%t8792 = and i64 %t8790, %t8791
%t8793 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8792)
%t8794 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 1, i64 %p4)
%t8795 = call i64 @__mruntime_rt_map_resid__nw(i64 %t8794)
%t8796 = mul i64 2, %t8787
%t8797 = add i64 %t8796, 2
%t8798 = add i64 %t8797, %t8793
%t8799 = mul i64 %t8798, 8
%t8800 = add i64 %t8795, %t8799
%t8801 = mul i64 2, %t8787
%t8802 = add i64 %t8801, %t8793
%t8803 = add i64 %t8802, 1
%t8804 = mul i64 %t8803, 8
%t8805 = add i64 %t8795, %t8804
%t8806 = sub i64 %t8789, %t8793
%t8807 = sub i64 %t8806, 1
%t8808 = mul i64 %t8807, 8
%t8809 = call i64 @mcopy(i64 %t8800, i64 %t8805, i64 %t8808)
%t8810 = mul i64 2, %t8787
%t8811 = add i64 %t8810, 2
%t8812 = mul i64 %t8811, 8
%t8813 = add i64 %t8795, %t8812
%t8814 = mul i64 2, %t8787
%t8815 = mul i64 %t8814, 8
%t8816 = add i64 %t8795, %t8815
%t8817 = mul i64 %t8793, 8
%t8818 = call i64 @mcopy(i64 %t8813, i64 %t8816, i64 %t8817)
%t8819 = mul i64 2, %t8785
%t8820 = add i64 %t8819, 2
%t8821 = mul i64 %t8820, 8
%t8822 = add i64 %t8795, %t8821
%t8823 = mul i64 2, %t8785
%t8824 = mul i64 %t8823, 8
%t8825 = add i64 %t8795, %t8824
%t8826 = sub i64 %t8787, %t8785
%t8827 = mul i64 2, %t8826
%t8828 = mul i64 %t8827, 8
%t8829 = call i64 @mcopy(i64 %t8822, i64 %t8825, i64 %t8828)
%t8830 = mul i64 2, %t8785
%t8831 = mul i64 %t8830, 8
%t8832 = add i64 %t8795, %t8831
%t8833 = call i64 @st64(i64 %t8832, i64 %p2)
%t8834 = mul i64 2, %t8785
%t8835 = add i64 %t8834, 1
%t8836 = mul i64 %t8835, 8
%t8837 = add i64 %t8795, %t8836
%t8838 = call i64 @st64(i64 %t8837, i64 %p3)
%t8839 = add i64 %t8833, %t8838
%t8840 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %t8794)
%t8841 = or i64 %t8840, %p1
%t8842 = call i64 @st32(i64 %t8794, i64 %t8841)
%t8843 = add i64 %t8794, 4
%t8844 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %t8794)
%t8845 = xor i64 %p1, -1
%t8846 = and i64 %t8844, %t8845
%t8847 = call i64 @st32(i64 %t8843, i64 %t8846)
%t8848 = mul nsw i64 %t8847, 0
%t8849 = add nsw i64 %t8848, %t8794
ret i64 %t8849
}
define internal i64 @__mruntime_rt_map_resid__hn_insert(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8850 = icmp eq i64 %p0, 0
br i1 %t8850, label %L2650, label %L2652
L2650:
%t8851 = call i64 @__mruntime_rt_map_resid__mflag()
%t8852 = call i64 @st64(i64 %t8851, i64 1)
%t8853 = mul nsw i64 %t8852, 0
%t8854 = call i64 @__mruntime_rt_map_resid__node_leaf(i64 %p1, i64 %p2, i64 %p4, i64 %p5, i64 %p6)
%t8855 = add nsw i64 %t8853, %t8854
ret i64 %t8855
L2652:
%t8856 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t8857 = icmp ne i64 %t8856, 0
br i1 %t8857, label %L2653, label %L2655
L2653:
%t8858 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t8859 = tail call i64 @__mruntime_rt_map_resid__coll_insert(i64 %p0, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 0, i64 %t8858)
ret i64 %t8859
L2655:
%t8860 = call i64 @__mruntime_rt_map_resid__slot_bit(i64 %p2, i64 %p1)
%t8861 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8862 = and i64 %t8861, %t8860
%t8863 = icmp ne i64 %t8862, 0
br i1 %t8863, label %L2656, label %L2658
L2656:
%t8864 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8865 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8864)
%t8866 = mul i64 2, %t8865
%t8867 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8868 = sub i64 %t8860, 1
%t8869 = and i64 %t8867, %t8868
%t8870 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8869)
%t8871 = add i64 %t8866, %t8870
%t8872 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8871)
%t8873 = add i64 %p1, 1
%t8874 = call i64 @__mruntime_rt_map_resid__hn_insert(i64 %t8872, i64 %t8873, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6)
%t8875 = icmp eq i64 %t8874, %t8872
br i1 %t8875, label %L2659, label %L2661
L2659:
ret i64 %p0
L2661:
%t8876 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p6)
%t8877 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8876, i64 %t8871, i64 %t8874)
%t8878 = mul nsw i64 %t8877, 0
%t8879 = add nsw i64 %t8878, %t8876
ret i64 %t8879
L2658:
%t8880 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8881 = and i64 %t8880, %t8860
%t8882 = icmp ne i64 %t8881, 0
br i1 %t8882, label %L2662, label %L2664
L2662:
%t8883 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8884 = sub i64 %t8860, 1
%t8885 = and i64 %t8883, %t8884
%t8886 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8885)
%t8887 = mul i64 2, %t8886
%t8888 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8887)
%t8889 = mul i64 2, %t8886
%t8890 = add i64 %t8889, 1
%t8891 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8890)
%t8892 = call i1 @__mruntime_rt_map_resid__key_eq(i64 %p3, i64 %t8888, i64 %p4)
br i1 %t8892, label %L2665, label %L2667
L2665:
%t8893 = call i64 @__mruntime_rt_map_resid__mflag()
%t8894 = call i64 @st64(i64 %t8893, i64 0)
%t8895 = icmp eq i64 %t8891, %p5
br label %LSL8896
LSL8896:
br i1 %t8895, label %LSR8896, label %LSJ8896
LSR8896:
%t8897 = icmp eq i64 %t8888, %p4
br label %LSJ8896
LSJ8896:
%t8898 = phi i1 [ false, %LSL8896 ], [ %t8897, %LSR8896 ]
br i1 %t8898, label %L2668, label %L2670
L2668:
ret i64 %p0
L2670:
%t8899 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p6)
%t8900 = mul i64 2, %t8886
%t8901 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8899, i64 %t8900, i64 %p4)
%t8902 = mul nsw i64 %t8901, 0
%t8903 = mul i64 2, %t8886
%t8904 = add i64 %t8903, 1
%t8905 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8899, i64 %t8904, i64 %p5)
%t8906 = mul nsw i64 %t8905, 0
%t8907 = add nsw i64 %t8902, %t8906
%t8908 = add nsw i64 %t8907, %t8899
ret i64 %t8908
L2667:
%t8909 = call i64 @__mruntime_rt_map_resid__mflag()
%t8910 = call i64 @st64(i64 %t8909, i64 1)
%t8911 = icmp sge i64 %p1, 12
br i1 %t8911, label %L2671, label %L2672
L2671:
%t8912 = call i64 @__mruntime_rt_map_resid__node_coll2(i64 %t8888, i64 %t8891, i64 %p4, i64 %p5, i64 %p6)
br label %L2673
L2672:
%t8913 = add nsw i64 %p1, 1
%t8914 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %p3, i64 %t8888)
%t8915 = call i64 @__mruntime_rt_map_resid__node_pair(i64 %t8913, i64 %t8914, i64 %t8888, i64 %t8891, i64 %p2, i64 %p4, i64 %p5, i64 %p6)
br label %L2673
L2673:
%t8916 = phi i64 [ %t8912, %L2671 ], [ %t8915, %L2672 ]
%t8917 = call i64 @__mruntime_rt_map_resid__node_data_to_sub(i64 %p0, i64 %t8860, i64 %t8916, i64 %p6)
ret i64 %t8917
L2664:
%t8918 = call i64 @__mruntime_rt_map_resid__mflag()
%t8919 = call i64 @st64(i64 %t8918, i64 1)
%t8920 = call i64 @__mruntime_rt_map_resid__node_ins_data(i64 %p0, i64 %t8860, i64 %p4, i64 %p5, i64 %p6)
ret i64 %t8920
}
define internal i64 @__mruntime_rt_map_resid__coll_insert(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t8960, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ]
%t8921 = icmp sge i64 %p5, %p6
br i1 %t8921, label %L2674, label %L2676
L2674:
%t8922 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 2, i64 %p4)
%t8923 = mul i64 2, %p6
%t8924 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8922, i64 %t8923, i64 %p2)
%t8925 = mul i64 2, %p6
%t8926 = add i64 %t8925, 1
%t8927 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8922, i64 %t8926, i64 %p3)
%t8928 = add i64 %t8924, %t8927
%t8929 = add i64 %t8922, 8
%t8930 = add i64 %p6, 1
%t8931 = call i64 @st32(i64 %t8929, i64 %t8930)
%t8932 = call i64 @__mruntime_rt_map_resid__mflag()
%t8933 = call i64 @st64(i64 %t8932, i64 1)
%t8934 = mul nsw i64 %t8933, 0
%t8935 = add nsw i64 %t8934, %t8922
ret i64 %t8935
L2676:
%t8936 = mul i64 2, %p5
%t8937 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8936)
%t8938 = call i1 @__mruntime_rt_map_resid__key_eq(i64 %p1, i64 %t8937, i64 %p2)
br i1 %t8938, label %L2677, label %L2679
L2677:
%t8939 = call i64 @__mruntime_rt_map_resid__mflag()
%t8940 = call i64 @st64(i64 %t8939, i64 0)
%t8941 = mul i64 2, %p5
%t8942 = add i64 %t8941, 1
%t8943 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8942)
%t8944 = icmp eq i64 %t8943, %p3
br label %LSL8945
LSL8945:
br i1 %t8944, label %LSR8945, label %LSJ8945
LSR8945:
%t8946 = mul i64 2, %p5
%t8947 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8946)
%t8948 = icmp eq i64 %t8947, %p2
br label %LSJ8945
LSJ8945:
%t8949 = phi i1 [ false, %LSL8945 ], [ %t8948, %LSR8945 ]
br i1 %t8949, label %L2680, label %L2682
L2680:
ret i64 %p0
L2682:
%t8950 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p4)
%t8951 = mul i64 2, %p5
%t8952 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8950, i64 %t8951, i64 %p2)
%t8953 = mul nsw i64 %t8952, 0
%t8954 = mul i64 2, %p5
%t8955 = add i64 %t8954, 1
%t8956 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8950, i64 %t8955, i64 %p3)
%t8957 = mul nsw i64 %t8956, 0
%t8958 = add nsw i64 %t8953, %t8957
%t8959 = add nsw i64 %t8958, %t8950
ret i64 %t8959
L2679:
%t8960 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__hn_find(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t8995, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t8996, %tco.s0 ]
%t8962 = icmp eq i64 %p0, 0
br i1 %t8962, label %L2683, label %L2685
L2683:
ret i64 0
L2685:
%t8963 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t8964 = icmp ne i64 %t8963, 0
br i1 %t8964, label %L2686, label %L2688
L2686:
%t8965 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t8966 = tail call i64 @__mruntime_rt_map_resid__coll_find(i64 %p0, i64 %p2, i64 %p3, i64 0, i64 %t8965)
ret i64 %t8966
L2688:
%t8967 = call i64 @__mruntime_rt_map_resid__slot_bit(i64 %p1, i64 %p4)
%t8968 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8969 = and i64 %t8968, %t8967
%t8970 = icmp ne i64 %t8969, 0
br i1 %t8970, label %L2689, label %L2691
L2689:
%t8971 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8972 = sub i64 %t8967, 1
%t8973 = and i64 %t8971, %t8972
%t8974 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8973)
%t8975 = mul i64 2, %t8974
%t8976 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8975)
%t8977 = call i1 @__mruntime_rt_map_resid__key_eq(i64 %p2, i64 %t8976, i64 %p3)
br i1 %t8977, label %L2692, label %L2693
L2692:
%t8978 = call i64 @__mruntime_rt_map_resid__nw(i64 %p0)
%t8979 = mul i64 2, %t8974
%t8980 = add i64 %t8979, 1
%t8981 = mul i64 %t8980, 8
%t8982 = add i64 %t8978, %t8981
br label %L2694
L2693:
br label %L2694
L2694:
%t8983 = phi i64 [ %t8982, %L2692 ], [ 0, %L2693 ]
ret i64 %t8983
L2691:
%t8984 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8985 = and i64 %t8984, %t8967
%t8986 = icmp eq i64 %t8985, 0
br i1 %t8986, label %L2695, label %L2697
L2695:
ret i64 0
L2697:
%t8987 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8988 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8987)
%t8989 = mul i64 2, %t8988
%t8990 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8991 = sub i64 %t8967, 1
%t8992 = and i64 %t8990, %t8991
%t8993 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8992)
%t8994 = add i64 %t8989, %t8993
%t8995 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8994)
%t8996 = add i64 %p4, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__coll_find(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9007, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t8998 = icmp sge i64 %p3, %p4
br i1 %t8998, label %L2698, label %L2700
L2698:
ret i64 0
L2700:
%t8999 = mul i64 2, %p3
%t9000 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8999)
%t9001 = call i1 @__mruntime_rt_map_resid__key_eq(i64 %p1, i64 %t9000, i64 %p2)
br i1 %t9001, label %L2701, label %L2703
L2701:
%t9002 = call i64 @__mruntime_rt_map_resid__nw(i64 %p0)
%t9003 = mul i64 2, %p3
%t9004 = add i64 %t9003, 1
%t9005 = mul i64 %t9004, 8
%t9006 = add i64 %t9002, %t9005
ret i64 %t9006
L2703:
%t9007 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_map_resid__node_single(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9009 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t9010 = icmp eq i64 %t9009, 1
br label %LSL9011
LSL9011:
br i1 %t9010, label %LSJ9011, label %LSR9011
LSR9011:
%t9012 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t9013 = icmp eq i64 %t9012, 0
br label %LSL9014
LSL9014:
br i1 %t9013, label %LSR9014, label %LSJ9014
LSR9014:
%t9015 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t9016 = icmp eq i64 %t9015, 0
br label %LSJ9014
LSJ9014:
%t9017 = phi i1 [ false, %LSL9014 ], [ %t9016, %LSR9014 ]
br label %LSL9018
LSL9018:
br i1 %t9017, label %LSR9018, label %LSJ9018
LSR9018:
%t9019 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9020 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9019)
%t9021 = icmp eq i64 %t9020, 1
br label %LSJ9018
LSJ9018:
%t9022 = phi i1 [ false, %LSL9018 ], [ %t9021, %LSR9018 ]
br label %LSJ9011
LSJ9011:
%t9023 = phi i1 [ true, %LSL9011 ], [ %t9022, %LSJ9018 ]
ret i1 %t9023
}
define internal i64 @__mruntime_rt_map_resid__hn_remove(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9024 = call i64 @__mruntime_rt_map_resid__mflag()
%t9025 = call i64 @st64(i64 %t9024, i64 0)
%t9026 = icmp eq i64 %p0, 0
br i1 %t9026, label %L2704, label %L2706
L2704:
ret i64 0
L2706:
%t9027 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t9028 = icmp ne i64 %t9027, 0
br i1 %t9028, label %L2707, label %L2709
L2707:
%t9029 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t9030 = tail call i64 @__mruntime_rt_map_resid__coll_remove(i64 %p0, i64 %p3, i64 %p4, i64 %p5, i64 0, i64 %t9029)
ret i64 %t9030
L2709:
%t9031 = call i64 @__mruntime_rt_map_resid__slot_bit(i64 %p2, i64 %p1)
%t9032 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t9033 = and i64 %t9032, %t9031
%t9034 = icmp ne i64 %t9033, 0
br i1 %t9034, label %L2710, label %L2712
L2710:
%t9035 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9036 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9035)
%t9037 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t9038 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9037)
%t9039 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t9040 = sub i64 %t9031, 1
%t9041 = and i64 %t9039, %t9040
%t9042 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9041)
%t9043 = mul i64 2, %t9036
%t9044 = add i64 %t9043, %t9042
%t9045 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9044)
%t9046 = add i64 %p1, 1
%t9047 = call i64 @__mruntime_rt_map_resid__hn_remove(i64 %t9045, i64 %t9046, i64 %p2, i64 %p3, i64 %p4, i64 %p5)
%t9048 = call i64 @__mruntime_rt_map_resid__mflag()
%t9049 = call i64 @ld64(i64 %t9048)
%t9050 = icmp eq i64 %t9049, 0
br i1 %t9050, label %L2713, label %L2715
L2713:
ret i64 %p0
L2715:
%t9051 = icmp eq i64 %t9047, 0
br i1 %t9051, label %L2716, label %L2718
L2716:
%t9052 = icmp eq i64 %t9036, 0
br label %LSL9053
LSL9053:
br i1 %t9052, label %LSR9053, label %LSJ9053
LSR9053:
%t9054 = icmp eq i64 %t9038, 1
br label %LSJ9053
LSJ9053:
%t9055 = phi i1 [ false, %LSL9053 ], [ %t9054, %LSR9053 ]
br i1 %t9055, label %L2719, label %L2721
L2719:
ret i64 0
L2721:
%t9056 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p5)
%t9057 = call i64 @__mruntime_rt_map_resid__nw(i64 %t9056)
%t9058 = mul i64 2, %t9036
%t9059 = add i64 %t9058, %t9042
%t9060 = mul i64 %t9059, 8
%t9061 = add i64 %t9057, %t9060
%t9062 = call i64 @__mruntime_rt_map_resid__nw(i64 %t9056)
%t9063 = mul i64 2, %t9036
%t9064 = add i64 %t9063, %t9042
%t9065 = add i64 %t9064, 1
%t9066 = mul i64 %t9065, 8
%t9067 = add i64 %t9062, %t9066
%t9068 = sub i64 %t9038, %t9042
%t9069 = sub i64 %t9068, 1
%t9070 = mul i64 %t9069, 8
%t9071 = call i64 @mcopy(i64 %t9061, i64 %t9067, i64 %t9070)
%t9072 = add i64 %t9056, 4
%t9073 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %t9056)
%t9074 = xor i64 %t9031, -1
%t9075 = and i64 %t9073, %t9074
%t9076 = call i64 @st32(i64 %t9072, i64 %t9075)
%t9077 = mul nsw i64 %t9076, 0
%t9078 = add nsw i64 %t9077, %t9056
ret i64 %t9078
L2718:
%t9079 = call i1 @__mruntime_rt_map_resid__node_single(i64 %t9047)
br i1 %t9079, label %L2722, label %L2724
L2722:
%t9080 = call i64 @__mruntime_rt_map_resid__wd(i64 %t9047, i64 0)
%t9081 = call i64 @__mruntime_rt_map_resid__wd(i64 %t9047, i64 1)
%t9082 = call i64 @__mruntime_rt_map_resid__node_sub_to_data(i64 %p0, i64 %t9031, i64 %t9080, i64 %t9081, i64 %p5)
ret i64 %t9082
L2724:
%t9083 = icmp eq i64 %t9047, %t9045
br i1 %t9083, label %L2725, label %L2727
L2725:
ret i64 %p0
L2727:
%t9084 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p5)
%t9085 = mul i64 2, %t9036
%t9086 = add i64 %t9085, %t9042
%t9087 = call i64 @__mruntime_rt_map_resid__wset(i64 %t9084, i64 %t9086, i64 %t9047)
%t9088 = mul nsw i64 %t9087, 0
%t9089 = add nsw i64 %t9088, %t9084
ret i64 %t9089
L2712:
%t9090 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9091 = and i64 %t9090, %t9031
%t9092 = icmp ne i64 %t9091, 0
br i1 %t9092, label %L2728, label %L2730
L2728:
%t9093 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9094 = sub i64 %t9031, 1
%t9095 = and i64 %t9093, %t9094
%t9096 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9095)
%t9097 = mul i64 2, %t9096
%t9098 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9097)
%t9099 = call i1 @__mruntime_rt_map_resid__key_eq(i64 %p3, i64 %t9098, i64 %p4)
%t9100 = xor i1 %t9099, true
br i1 %t9100, label %L2731, label %L2733
L2731:
ret i64 %p0
L2733:
%t9101 = call i64 @__mruntime_rt_map_resid__mflag()
%t9102 = call i64 @st64(i64 %t9101, i64 1)
%t9103 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9104 = icmp eq i64 %t9103, %t9031
br label %LSL9105
LSL9105:
br i1 %t9104, label %LSR9105, label %LSJ9105
LSR9105:
%t9106 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t9107 = icmp eq i64 %t9106, 0
br label %LSJ9105
LSJ9105:
%t9108 = phi i1 [ false, %LSL9105 ], [ %t9107, %LSR9105 ]
br i1 %t9108, label %L2734, label %L2736
L2734:
ret i64 0
L2736:
%t9109 = call i64 @__mruntime_rt_map_resid__node_words(i64 %p0)
%t9110 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p5)
%t9111 = call i64 @__mruntime_rt_map_resid__nw(i64 %t9110)
%t9112 = mul i64 2, %t9096
%t9113 = mul i64 %t9112, 8
%t9114 = add i64 %t9111, %t9113
%t9115 = call i64 @__mruntime_rt_map_resid__nw(i64 %t9110)
%t9116 = mul i64 2, %t9096
%t9117 = add i64 %t9116, 2
%t9118 = mul i64 %t9117, 8
%t9119 = add i64 %t9115, %t9118
%t9120 = mul i64 2, %t9096
%t9121 = sub i64 %t9109, %t9120
%t9122 = sub i64 %t9121, 2
%t9123 = mul i64 %t9122, 8
%t9124 = call i64 @mcopy(i64 %t9114, i64 %t9119, i64 %t9123)
%t9125 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %t9110)
%t9126 = xor i64 %t9031, -1
%t9127 = and i64 %t9125, %t9126
%t9128 = call i64 @st32(i64 %t9110, i64 %t9127)
%t9129 = mul nsw i64 %t9128, 0
%t9130 = add nsw i64 %t9129, %t9110
ret i64 %t9130
L2730:
ret i64 %p0
}
define internal i64 @__mruntime_rt_map_resid__coll_remove(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t9136, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t9131 = icmp sge i64 %p4, %p5
br i1 %t9131, label %L2737, label %L2739
L2737:
ret i64 %p0
L2739:
%t9132 = mul i64 2, %p4
%t9133 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9132)
%t9134 = call i1 @__mruntime_rt_map_resid__key_eq(i64 %p1, i64 %t9133, i64 %p2)
%t9135 = xor i1 %t9134, true
br i1 %t9135, label %L2740, label %L2742
L2740:
%t9136 = add nsw i64 %p4, 1
br label %tco.s0
tco.s0:
br label %tco.head
L2742:
%t9138 = call i64 @__mruntime_rt_map_resid__mflag()
%t9139 = call i64 @st64(i64 %t9138, i64 1)
%t9140 = icmp eq i64 %p5, 1
br i1 %t9140, label %L2743, label %L2745
L2743:
ret i64 0
L2745:
%t9141 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p3)
%t9142 = call i64 @__mruntime_rt_map_resid__nw(i64 %t9141)
%t9143 = mul i64 2, %p4
%t9144 = mul i64 %t9143, 8
%t9145 = add i64 %t9142, %t9144
%t9146 = call i64 @__mruntime_rt_map_resid__nw(i64 %t9141)
%t9147 = mul i64 2, %p4
%t9148 = add i64 %t9147, 2
%t9149 = mul i64 %t9148, 8
%t9150 = add i64 %t9146, %t9149
%t9151 = sub i64 %p5, %p4
%t9152 = sub i64 %t9151, 1
%t9153 = mul i64 2, %t9152
%t9154 = mul i64 %t9153, 8
%t9155 = call i64 @mcopy(i64 %t9145, i64 %t9150, i64 %t9154)
%t9156 = add i64 %t9141, 8
%t9157 = sub nsw i64 %p5, 1
%t9158 = call i64 @st32(i64 %t9156, i64 %t9157)
%t9159 = mul nsw i64 %t9158, 0
%t9160 = add nsw i64 %t9159, %t9141
ret i64 %t9160
}
define internal i64 @__mruntime_rt_map_resid__hn_collect(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9161 = icmp eq i64 %p0, 0
br i1 %t9161, label %L2746, label %L2748
L2746:
ret i64 %p3
L2748:
%t9162 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t9163 = icmp ne i64 %t9162, 0
br i1 %t9163, label %L2749, label %L2751
L2749:
%t9164 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t9165 = call i64 @__mruntime_rt_map_resid__coll_collect(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 %t9164)
ret i64 %t9165
L2751:
%t9166 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9167 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t9168 = or i64 %t9166, %t9167
%t9169 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9170 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9169)
%t9171 = call i64 @__mruntime_rt_map_resid__slots_collect(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %t9168, i64 %t9170)
ret i64 %t9171
}
define internal i64 @__mruntime_rt_map_resid__coll_collect(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9188, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t9189, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t9172 = icmp sge i64 %p4, %p5
br i1 %t9172, label %L2752, label %L2754
L2752:
ret i64 %p3
L2754:
%t9173 = icmp ne i64 %p1, 0
br i1 %t9173, label %L2755, label %L2756
L2755:
%t9174 = mul i64 %p3, 8
%t9175 = add i64 %p1, %t9174
%t9176 = mul i64 2, %p4
%t9177 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9176)
%t9178 = call i64 @st64(i64 %t9175, i64 %t9177)
br label %L2757
L2756:
br label %L2757
L2757:
%t9179 = phi i64 [ %t9178, %L2755 ], [ 0, %L2756 ]
%t9180 = icmp ne i64 %p2, 0
br i1 %t9180, label %L2758, label %L2759
L2758:
%t9181 = mul i64 %p3, 8
%t9182 = add i64 %p2, %t9181
%t9183 = mul i64 2, %p4
%t9184 = add i64 %t9183, 1
%t9185 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9184)
%t9186 = call i64 @st64(i64 %t9182, i64 %t9185)
br label %L2760
L2759:
br label %L2760
L2760:
%t9187 = phi i64 [ %t9186, %L2758 ], [ 0, %L2759 ]
%t9188 = add i64 %p3, 1
%t9189 = add nsw i64 %p4, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__slots_collect(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9216, %tco.s0 ], [ %t9227, %tco.s1 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t9218, %tco.s0 ], [ %t9229, %tco.s1 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ], [ %p5, %tco.s1 ]
%t9191 = icmp eq i64 %p4, 0
br i1 %t9191, label %L2761, label %L2763
L2761:
ret i64 %p3
L2763:
%t9192 = sub i64 0, %p4
%t9193 = and i64 %p4, %t9192
%t9194 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9195 = and i64 %t9194, %t9193
%t9196 = icmp ne i64 %t9195, 0
br i1 %t9196, label %L2764, label %L2766
L2764:
%t9197 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9198 = sub i64 %t9193, 1
%t9199 = and i64 %t9197, %t9198
%t9200 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9199)
%t9201 = icmp ne i64 %p1, 0
br i1 %t9201, label %L2767, label %L2768
L2767:
%t9202 = mul i64 %p3, 8
%t9203 = add i64 %p1, %t9202
%t9204 = mul i64 2, %t9200
%t9205 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9204)
%t9206 = call i64 @st64(i64 %t9203, i64 %t9205)
br label %L2769
L2768:
br label %L2769
L2769:
%t9207 = phi i64 [ %t9206, %L2767 ], [ 0, %L2768 ]
%t9208 = icmp ne i64 %p2, 0
br i1 %t9208, label %L2770, label %L2771
L2770:
%t9209 = mul i64 %p3, 8
%t9210 = add i64 %p2, %t9209
%t9211 = mul i64 2, %t9200
%t9212 = add i64 %t9211, 1
%t9213 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9212)
%t9214 = call i64 @st64(i64 %t9210, i64 %t9213)
br label %L2772
L2771:
br label %L2772
L2772:
%t9215 = phi i64 [ %t9214, %L2770 ], [ 0, %L2771 ]
%t9216 = add i64 %p3, 1
%t9217 = sub i64 %p4, 1
%t9218 = and i64 %p4, %t9217
br label %tco.s0
tco.s0:
br label %tco.head
L2766:
%t9220 = mul i64 2, %p5
%t9221 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t9222 = sub i64 %t9193, 1
%t9223 = and i64 %t9221, %t9222
%t9224 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9223)
%t9225 = add i64 %t9220, %t9224
%t9226 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9225)
%t9227 = call i64 @__mruntime_rt_map_resid__hn_collect(i64 %t9226, i64 %p1, i64 %p2, i64 %p3)
%t9228 = sub i64 %p4, 1
%t9229 = and i64 %p4, %t9228
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__mcount(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9231 = tail call i64 @ld64(i64 %p0)
ret i64 %t9231
}
define internal i64 @__mruntime_rt_map_resid__mroot(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9232 = add i64 %p0, 8
%t9233 = tail call i64 @ld64(i64 %t9232)
ret i64 %t9233
}
define internal i64 @__mruntime_rt_map_resid__mtab(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9234 = add i64 %p0, 16
%t9235 = tail call i64 @ld64(i64 %t9234)
ret i64 %t9235
}
define internal i1 @__mruntime_rt_map_resid__mtrans(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9236 = add i64 %p0, 24
%t9237 = call i64 @ld64(i64 %t9236)
%t9238 = icmp ne i64 %t9237, 0
ret i1 %t9238
}
define internal i64 @__mruntime_rt_map_resid__medit(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9239 = add i64 %p0, 32
%t9240 = tail call i64 @ld64(i64 %t9239)
ret i64 %t9240
}
define internal i64 @__mruntime_rt_map_resid__mown(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9241 = add i64 %p0, 40
%t9242 = tail call i64 @ld32(i64 %t9241)
ret i64 %t9242
}
define internal i64 @__mruntime_rt_map_resid__mkk(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9243 = add i64 %p0, 44
%t9244 = tail call i64 @__mruntime_rt_map_resid__ld_i8(i64 %t9243)
ret i64 %t9244
}
define internal i64 @__mruntime_rt_map_resid__mvk(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9245 = add i64 %p0, 45
%t9246 = tail call i64 @__mruntime_rt_map_resid__ld_i8(i64 %t9245)
ret i64 %t9246
}
define internal i64 @__mruntime_rt_map_resid__trie_new(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9247 = call i64 @__mruntime_rt_map_resid__map_obj(i64 48)
%t9248 = call i64 @st64(i64 %t9247, i64 %p0)
%t9249 = add i64 %t9247, 8
%t9250 = call i64 @st64(i64 %t9249, i64 %p1)
%t9251 = add i64 %t9248, %t9250
%t9252 = add i64 %t9247, 16
%t9253 = call i64 @st64(i64 %t9252, i64 0)
%t9254 = add i64 %t9251, %t9253
%t9255 = add i64 %t9247, 24
%t9256 = call i64 @st64(i64 %t9255, i64 0)
%t9257 = add i64 %t9254, %t9256
%t9258 = add i64 %t9247, 32
%t9259 = call i64 @st64(i64 %t9258, i64 0)
%t9260 = add i64 %t9257, %t9259
%t9261 = add i64 %t9247, 40
%t9262 = call i64 @st32(i64 %t9261, i64 0)
%t9263 = add i64 %t9247, 44
%t9264 = call i64 @st8(i64 %t9263, i64 %p2)
%t9265 = add i64 %t9262, %t9264
%t9266 = add i64 %t9247, 45
%t9267 = call i64 @st8(i64 %t9266, i64 %p3)
%t9268 = add i64 %t9265, %t9267
ret i64 %t9247
}
define internal i64 @__mruntime_rt_map_resid__tcap(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9269 = tail call i64 @ld64(i64 %p0)
ret i64 %t9269
}
define internal i64 @__mruntime_rt_map_resid__tlive(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9270 = add i64 %p0, 8
%t9271 = tail call i64 @ld64(i64 %t9270)
ret i64 %t9271
}
define internal i64 @__mruntime_rt_map_resid__ttombs(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9272 = add i64 %p0, 16
%t9273 = tail call i64 @ld64(i64 %t9272)
ret i64 %t9273
}
define internal i64 @__mruntime_rt_map_resid__tkk(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9274 = add i64 %p0, 24
%t9275 = tail call i64 @__mruntime_rt_map_resid__ld_i8(i64 %t9274)
ret i64 %t9275
}
define internal i64 @__mruntime_rt_map_resid__tvk(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9276 = add i64 %p0, 25
%t9277 = tail call i64 @__mruntime_rt_map_resid__ld_i8(i64 %t9276)
ret i64 %t9277
}
define internal i1 @__mruntime_rt_map_resid__tnov(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9278 = add i64 %p0, 26
%t9279 = call i64 @ld8(i64 %t9278)
%t9280 = icmp ne i64 %t9279, 0
ret i1 %t9280
}
define internal i64 @__mruntime_rt_map_resid__tkeys(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9281 = add i64 %p0, 32
%t9282 = tail call i64 @ld64(i64 %t9281)
ret i64 %t9282
}
define internal i64 @__mruntime_rt_map_resid__tvals(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9283 = add i64 %p0, 40
%t9284 = tail call i64 @ld64(i64 %t9283)
ret i64 %t9284
}
define internal i1 @__mruntime_rt_map_resid__toob_has(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9285 = add i64 %p0, 48
%t9286 = add i64 %t9285, %p1
%t9287 = call i64 @ld8(i64 %t9286)
%t9288 = icmp ne i64 %t9287, 0
ret i1 %t9288
}
define internal i64 @__mruntime_rt_map_resid__toob_val(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9289 = add i64 %p0, 56
%t9290 = mul i64 %p1, 8
%t9291 = add i64 %t9289, %t9290
%t9292 = call i64 @ld64(i64 %t9291)
ret i64 %t9292
}
define internal i64 @__mruntime_rt_map_resid__t_empty(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9293 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9294 = icmp eq i64 %t9293, 1
br i1 %t9294, label %L2773, label %L2774
L2773:
%t9295 = call i64 @__mruntime_rt_map_resid__raw_empty()
br label %L2775
L2774:
br label %L2775
L2775:
%t9296 = phi i64 [ %t9295, %L2773 ], [ 0, %L2774 ]
ret i64 %t9296
}
define internal i64 @__mruntime_rt_map_resid__t_tomb(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9297 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9298 = icmp eq i64 %t9297, 1
br i1 %t9298, label %L2776, label %L2777
L2776:
%t9299 = call i64 @__mruntime_rt_map_resid__raw_tomb()
br label %L2778
L2777:
br label %L2778
L2778:
%t9300 = phi i64 [ %t9299, %L2776 ], [ 1, %L2777 ]
ret i64 %t9300
}
define internal i64 @__mruntime_rt_map_resid__mix(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9301 = call i64 @lshr(i64 %p0, i64 33)
%t9302 = xor i64 %p0, %t9301
%t9303 = sub nsw i64 0, 49064778989728563
%t9304 = mul i64 %t9302, %t9303
%t9305 = call i64 @lshr(i64 %t9304, i64 33)
%t9306 = xor i64 %t9304, %t9305
ret i64 %t9306
}
define internal i64 @__mruntime_rt_map_resid__t_hash(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9307 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9308 = icmp eq i64 %t9307, 1
br i1 %t9308, label %L2779, label %L2780
L2779:
%t9309 = call i64 @__mruntime_rt_map_resid__mix(i64 %p1)
br label %L2781
L2780:
%t9310 = call i64 @__mruntime_rt_map_resid__value_hash(i64 %p1)
br label %L2781
L2781:
%t9311 = phi i64 [ %t9309, %L2779 ], [ %t9310, %L2780 ]
ret i64 %t9311
}
define internal i1 @__mruntime_rt_map_resid__t_keq(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9312 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9313 = icmp eq i64 %t9312, 1
br i1 %t9313, label %L2782, label %L2783
L2782:
%t9314 = icmp eq i64 %p1, %p2
br label %L2784
L2783:
%t9315 = call i1 @__mruntime_rt_map_resid__value_eq(i64 %p1, i64 %p2)
br label %L2784
L2784:
%t9316 = phi i1 [ %t9314, %L2782 ], [ %t9315, %L2783 ]
ret i1 %t9316
}
define internal i64 @__mruntime_rt_map_resid__t_oob(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9317 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9318 = icmp ne i64 %t9317, 1
br i1 %t9318, label %L2785, label %L2787
L2785:
%t9319 = sub nsw i64 0, 1
ret i64 %t9319
L2787:
%t9320 = call i64 @__mruntime_rt_map_resid__raw_empty()
%t9321 = icmp eq i64 %p1, %t9320
br i1 %t9321, label %L2788, label %L2790
L2788:
ret i64 0
L2790:
%t9322 = call i64 @__mruntime_rt_map_resid__raw_tomb()
%t9323 = icmp eq i64 %p1, %t9322
br i1 %t9323, label %L2791, label %L2793
L2791:
ret i64 1
L2793:
%t9324 = sub nsw i64 0, 1
ret i64 %t9324
}
define internal i64 @__mruntime_rt_map_resid__t_alloc(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9325 = call i64 @st64(i64 %p0, i64 %p1)
%t9326 = mul i64 %p1, 8
%t9327 = call i64 @__mruntime_rt_map_resid__map_obj(i64 %t9326)
%t9328 = add i64 %p0, 32
%t9329 = call i64 @st64(i64 %t9328, i64 %t9327)
%t9330 = add i64 %p0, 40
%t9331 = call i1 @__mruntime_rt_map_resid__tnov(i64 %p0)
br i1 %t9331, label %L2794, label %L2795
L2794:
br label %L2796
L2795:
%t9332 = mul i64 %p1, 8
%t9333 = call i64 @__mruntime_rt_map_resid__map_obj(i64 %t9332)
br label %L2796
L2796:
%t9334 = phi i64 [ 0, %L2794 ], [ %t9333, %L2795 ]
%t9335 = call i64 @st64(i64 %t9330, i64 %t9334)
%t9336 = call i64 @__mruntime_rt_map_resid__t_empty(i64 %p0)
%t9337 = call i64 @__mruntime_rt_map_resid__fill_words(i64 %t9327, i64 %t9336, i64 0, i64 %p1)
ret i64 %t9337
}
define internal i64 @__mruntime_rt_map_resid__fill_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9342, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t9338 = icmp sge i64 %p2, %p3
br i1 %t9338, label %L2797, label %L2799
L2797:
ret i64 0
L2799:
%t9339 = mul i64 %p2, 8
%t9340 = add i64 %p0, %t9339
%t9341 = call i64 @st64(i64 %t9340, i64 %p1)
%t9342 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__tab_new(i64 %p0, i64 %p1, i64 %p2, i1 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9344 = call i64 @__mruntime_rt_map_resid__map_obj(i64 96)
%t9345p = inttoptr i64 %t9344 to ptr
%t9345q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t9345p, i8 %t9345q, i64 96, i1 false)
%t9345 = add i64 0, 0
%t9346 = call i64 @st64(i64 %t9344, i64 %p0)
%t9347 = add i64 %t9344, 24
%t9348 = call i64 @st8(i64 %t9347, i64 %p1)
%t9349 = add i64 %t9344, 25
%t9350 = call i64 @st8(i64 %t9349, i64 %p2)
%t9351 = add i64 %t9348, %t9350
%t9352 = add i64 %t9344, 26
br i1 %p3, label %L2800, label %L2801
L2800:
br label %L2802
L2801:
br label %L2802
L2802:
%t9353 = phi i64 [ 1, %L2800 ], [ 0, %L2801 ]
%t9354 = call i64 @st8(i64 %t9352, i64 %t9353)
%t9355 = add i64 %t9351, %t9354
%t9356 = sub nsw i64 0, 1
%t9357 = icmp ne i64 %p1, %t9356
br i1 %t9357, label %L2803, label %L2804
L2803:
%t9358 = call i64 @__mruntime_rt_map_resid__t_alloc(i64 %t9344, i64 %p0)
br label %L2805
L2804:
br label %L2805
L2805:
%t9359 = phi i64 [ %t9358, %L2803 ], [ 0, %L2804 ]
ret i64 %t9344
}
define internal i1 @__mruntime_rt_map_resid__t_over(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9360 = mul i64 %p0, 2
%t9361 = icmp sgt i64 %t9360, %p1
ret i1 %t9361
}
define internal i64 @__mruntime_rt_map_resid__cap_for(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9362 = call i64 @__mruntime_rt_map_resid__cap_for_at(i64 %p0, i64 16)
ret i64 %t9362
}
define internal i64 @__mruntime_rt_map_resid__cap_for_at(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9363 = add i64 %p0, 1
%t9364 = call i1 @__mruntime_rt_map_resid__t_over(i64 %t9363, i64 %p1)
br i1 %t9364, label %L2806, label %L2807
L2806:
%t9365 = mul i64 %p1, 2
%t9366 = call i64 @__mruntime_rt_map_resid__cap_for_at(i64 %p0, i64 %t9365)
br label %L2808
L2807:
br label %L2808
L2808:
%t9367 = phi i64 [ %t9366, %L2806 ], [ %p1, %L2807 ]
ret i64 %t9367
}
define internal i64 @__mruntime_rt_map_resid__t_probe(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9368 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9369 = sub i64 %t9368, 1
%t9370 = call i64 @__mruntime_rt_map_resid__t_hash(i64 %p0, i64 %p1)
%t9371 = and i64 %t9370, %t9369
%t9372 = call i64 @__mruntime_rt_map_resid__t_empty(i64 %p0)
%t9373 = call i64 @__mruntime_rt_map_resid__t_tomb(i64 %p0)
%t9374 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9375 = call i64 @__mruntime_rt_map_resid__probe_at(i64 %p0, i64 %p1, i64 %t9371, i64 %t9369, i64 %t9372, i64 %t9373, i64 %t9374)
ret i64 %t9375
}
define internal i64 @__mruntime_rt_map_resid__probe_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9387, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ]
%t9376 = mul i64 %p2, 8
%t9377 = add i64 %p6, %t9376
%t9378 = call i64 @ld64(i64 %t9377)
%t9379 = icmp eq i64 %t9378, %p4
br i1 %t9379, label %L2809, label %L2811
L2809:
%t9380 = sub i64 0, %p2
%t9381 = sub nsw i64 %t9380, 1
ret i64 %t9381
L2811:
%t9382 = icmp ne i64 %t9378, %p5
br label %LSL9383
LSL9383:
br i1 %t9382, label %LSR9383, label %LSJ9383
LSR9383:
%t9384 = call i1 @__mruntime_rt_map_resid__t_keq(i64 %p0, i64 %t9378, i64 %p1)
br label %LSJ9383
LSJ9383:
%t9385 = phi i1 [ false, %LSL9383 ], [ %t9384, %LSR9383 ]
br i1 %t9385, label %L2812, label %L2814
L2812:
ret i64 %p2
L2814:
%t9386 = add i64 %p2, 1
%t9387 = and i64 %t9386, %p3
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__probe_raw_cached(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9389 = add i64 %p0, 72
%t9390 = call i64 @ld8(i64 %t9389)
%t9391 = icmp ne i64 %t9390, 0
br label %LSL9392
LSL9392:
br i1 %t9391, label %LSR9392, label %LSJ9392
LSR9392:
%t9393 = add i64 %p0, 80
%t9394 = call i64 @ld64(i64 %t9393)
%t9395 = icmp eq i64 %t9394, %p1
br label %LSJ9392
LSJ9392:
%t9396 = phi i1 [ false, %LSL9392 ], [ %t9395, %LSR9392 ]
br i1 %t9396, label %L2815, label %L2817
L2815:
%t9397 = add i64 %p0, 88
%t9398 = call i64 @ld64(i64 %t9397)
ret i64 %t9398
L2817:
%t9399 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9400 = sub i64 %t9399, 1
%t9401 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9402 = call i64 @__mruntime_rt_map_resid__mix(i64 %p1)
%t9403 = and i64 %t9402, %t9400
%t9404 = call i64 @__mruntime_rt_map_resid__probe_raw(i64 %t9401, i64 %p1, i64 %t9403, i64 %t9400)
%t9405 = add i64 %p0, 72
%t9406 = call i64 @st8(i64 %t9405, i64 1)
%t9407 = add i64 %p0, 80
%t9408 = call i64 @st64(i64 %t9407, i64 %p1)
%t9409 = add i64 %p0, 88
%t9410 = call i64 @st64(i64 %t9409, i64 %t9404)
%t9411 = mul nsw i64 %t9410, 0
%t9412 = add nsw i64 %t9411, %t9404
ret i64 %t9412
}
define internal i64 @__mruntime_rt_map_resid__probe_raw(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9422, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t9413 = mul i64 %p2, 8
%t9414 = add i64 %p0, %t9413
%t9415 = call i64 @ld64(i64 %t9414)
%t9416 = call i64 @__mruntime_rt_map_resid__raw_empty()
%t9417 = icmp eq i64 %t9415, %t9416
br i1 %t9417, label %L2818, label %L2820
L2818:
%t9418 = sub i64 0, %p2
%t9419 = sub nsw i64 %t9418, 1
ret i64 %t9419
L2820:
%t9420 = icmp eq i64 %t9415, %p1
br i1 %t9420, label %L2821, label %L2823
L2821:
ret i64 %p2
L2823:
%t9421 = add i64 %p2, 1
%t9422 = and i64 %t9421, %p3
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__t_next(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ], [ %p0, %tco.s2 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9424, %tco.s0 ], [ %t9439, %tco.s1 ], [ %t9458, %tco.s2 ]
%t9424 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9425 = icmp slt i64 %p1, %t9424
br i1 %t9425, label %L2824, label %L2826
L2824:
%t9426 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9427 = icmp eq i64 %t9426, 0
br i1 %t9427, label %L2827, label %L2829
L2827:
br label %tco.s0
tco.s0:
br label %tco.head
L2829:
%t9429 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9430 = mul i64 %p1, 8
%t9431 = add i64 %t9429, %t9430
%t9432 = call i64 @ld64(i64 %t9431)
%t9433 = call i64 @__mruntime_rt_map_resid__t_empty(i64 %p0)
%t9434 = icmp eq i64 %t9432, %t9433
br label %LSL9435
LSL9435:
br i1 %t9434, label %LSJ9435, label %LSR9435
LSR9435:
%t9436 = call i64 @__mruntime_rt_map_resid__t_tomb(i64 %p0)
%t9437 = icmp eq i64 %t9432, %t9436
br label %LSJ9435
LSJ9435:
%t9438 = phi i1 [ true, %LSL9435 ], [ %t9437, %LSR9435 ]
br i1 %t9438, label %L2830, label %L2832
L2830:
%t9439 = add nsw i64 %p1, 1
br label %tco.s1
tco.s1:
br label %tco.head
L2832:
%t9441 = call i64 @__mruntime_rt_map_resid__mret()
%t9442 = call i64 @st64(i64 %t9441, i64 %t9432)
%t9443 = call i64 @__mruntime_rt_map_resid__mflag()
%t9444 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9445 = icmp ne i64 %t9444, 0
br i1 %t9445, label %L2833, label %L2834
L2833:
%t9446 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9447 = mul i64 %p1, 8
%t9448 = add i64 %t9446, %t9447
%t9449 = call i64 @ld64(i64 %t9448)
br label %L2835
L2834:
br label %L2835
L2835:
%t9450 = phi i64 [ %t9449, %L2833 ], [ 1, %L2834 ]
%t9451 = call i64 @st64(i64 %t9443, i64 %t9450)
%t9452 = add nsw i64 %p1, 1
ret i64 %t9452
L2826:
%t9453 = add i64 %t9424, 2
%t9454 = icmp slt i64 %p1, %t9453
br i1 %t9454, label %L2836, label %L2838
L2836:
%t9455 = sub i64 %p1, %t9424
%t9456 = call i1 @__mruntime_rt_map_resid__toob_has(i64 %p0, i64 %t9455)
%t9457 = xor i1 %t9456, true
br i1 %t9457, label %L2839, label %L2841
L2839:
%t9458 = add nsw i64 %p1, 1
br label %tco.s2
tco.s2:
br label %tco.head
L2841:
%t9460 = call i64 @__mruntime_rt_map_resid__mret()
%t9461 = icmp eq i64 %t9455, 0
br i1 %t9461, label %L2842, label %L2843
L2842:
%t9462 = call i64 @__mruntime_rt_map_resid__raw_empty()
br label %L2844
L2843:
%t9463 = call i64 @__mruntime_rt_map_resid__raw_tomb()
br label %L2844
L2844:
%t9464 = phi i64 [ %t9462, %L2842 ], [ %t9463, %L2843 ]
%t9465 = call i64 @st64(i64 %t9460, i64 %t9464)
%t9466 = call i64 @__mruntime_rt_map_resid__mflag()
%t9467 = call i64 @__mruntime_rt_map_resid__toob_val(i64 %p0, i64 %t9455)
%t9468 = call i64 @st64(i64 %t9466, i64 %t9467)
%t9469 = add nsw i64 %p1, 1
ret i64 %t9469
L2838:
%t9470 = sub nsw i64 0, 1
ret i64 %t9470
}
define internal i64 @__mruntime_rt_map_resid__t_rebuild(i64 %p0, i64 %p1, i64 %p2, i1 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9471 = call i64 @xmalloc(i64 96)
%t9472 = call i64 @mcopy(i64 %t9471, i64 %p0, i64 96)
%t9473 = add i64 %p0, 24
%t9474 = call i64 @st8(i64 %t9473, i64 %p2)
%t9475 = add i64 %p0, 8
%t9476 = call i64 @st64(i64 %t9475, i64 0)
%t9477 = add i64 %p0, 16
%t9478 = call i64 @st64(i64 %t9477, i64 0)
%t9479 = add i64 %t9476, %t9478
%t9480 = add i64 %p0, 48
%t9481 = call i64 @st8(i64 %t9480, i64 0)
%t9482 = add i64 %t9479, %t9481
%t9483 = add i64 %p0, 49
%t9484 = call i64 @st8(i64 %t9483, i64 0)
%t9485 = add i64 %t9482, %t9484
%t9486 = add i64 %p0, 72
%t9487 = call i64 @st8(i64 %t9486, i64 0)
%t9488 = add i64 %t9485, %t9487
%t9489 = call i64 @__mruntime_rt_map_resid__t_alloc(i64 %p0, i64 %p1)
%t9490 = call i64 @__mruntime_rt_map_resid__rebuild_from(i64 %p0, i64 %t9471, i64 0, i1 %p3)
%t9491 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %t9471)
%t9492 = call i64 @__mruntime_rt_map_resid__map_obj_free(i64 %t9491)
%t9493 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t9471)
%t9494 = call i64 @__mruntime_rt_map_resid__map_obj_free(i64 %t9493)
%t9495 = add i64 %t9492, %t9494
%t9496 = call i64 @c_free(i64 %t9471)
ret i64 %t9496
}
define internal i64 @__mruntime_rt_map_resid__rebuild_from(i64 %p0.in, i64 %p1.in, i64 %p2.in, i1 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9497, %tco.s0 ]
%p3 = phi i1 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t9497 = call i64 @__mruntime_rt_map_resid__t_next(i64 %p1, i64 %p2)
%t9498 = icmp slt i64 %t9497, 0
br i1 %t9498, label %L2845, label %L2847
L2845:
ret i64 0
L2847:
%t9499 = call i64 @__mruntime_rt_map_resid__mret()
%t9500 = call i64 @ld64(i64 %t9499)
%t9501 = call i64 @__mruntime_rt_map_resid__mflag()
%t9502 = call i64 @ld64(i64 %t9501)
br i1 %p3, label %L2848, label %L2849
L2848:
%t9503 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p1)
%t9504 = call i64 @__mruntime_rt_map_resid__mbox(i64 %t9503, i64 %t9500)
br label %L2850
L2849:
br label %L2850
L2850:
%t9505 = phi i64 [ %t9504, %L2848 ], [ %t9500, %L2849 ]
%t9506 = call i64 @__mruntime_rt_map_resid__t_insert_new(i64 %p0, i64 %t9505, i64 %t9502)
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__t_insert_new(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9508 = call i64 @__mruntime_rt_map_resid__t_oob(i64 %p0, i64 %p1)
%t9509 = icmp sge i64 %t9508, 0
br i1 %t9509, label %L2851, label %L2853
L2851:
%t9510 = add i64 %p0, 48
%t9511 = add i64 %t9510, %t9508
%t9512 = call i64 @st8(i64 %t9511, i64 1)
%t9513 = add i64 %p0, 56
%t9514 = mul i64 %t9508, 8
%t9515 = add i64 %t9513, %t9514
%t9516 = call i64 @st64(i64 %t9515, i64 %p2)
%t9517 = add i64 %t9512, %t9516
%t9518 = add i64 %p0, 8
%t9519 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9520 = add i64 %t9519, 1
%t9521 = call i64 @st64(i64 %t9518, i64 %t9520)
%t9522 = add i64 %t9517, %t9521
ret i64 %t9522
L2853:
%t9523 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9524 = call i64 @__mruntime_rt_map_resid__ttombs(i64 %p0)
%t9525 = add i64 %t9523, %t9524
%t9526 = add i64 %t9525, 1
%t9527 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9528 = call i1 @__mruntime_rt_map_resid__t_over(i64 %t9526, i64 %t9527)
br i1 %t9528, label %L2854, label %L2855
L2854:
%t9529 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9530 = mul i64 %t9529, 4
%t9531 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9532 = icmp sgt i64 %t9530, %t9531
br i1 %t9532, label %L2857, label %L2858
L2857:
%t9533 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9534 = mul i64 %t9533, 2
br label %L2859
L2858:
%t9535 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
br label %L2859
L2859:
%t9536 = phi i64 [ %t9534, %L2857 ], [ %t9535, %L2858 ]
%t9537 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9538 = call i64 @__mruntime_rt_map_resid__t_rebuild(i64 %p0, i64 %t9536, i64 %t9537, i1 false)
br label %L2856
L2855:
br label %L2856
L2856:
%t9539 = phi i64 [ %t9538, %L2859 ], [ 0, %L2855 ]
%t9540 = call i64 @__mruntime_rt_map_resid__t_probe(i64 %p0, i64 %p1)
%t9541 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9542 = sub i64 0, %t9540
%t9543 = sub nsw i64 %t9542, 1
%t9544 = mul i64 %t9543, 8
%t9545 = add i64 %t9541, %t9544
%t9546 = call i64 @st64(i64 %t9545, i64 %p1)
%t9547 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9548 = icmp ne i64 %t9547, 0
br i1 %t9548, label %L2860, label %L2861
L2860:
%t9549 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9550 = sub i64 0, %t9540
%t9551 = sub nsw i64 %t9550, 1
%t9552 = mul i64 %t9551, 8
%t9553 = add i64 %t9549, %t9552
%t9554 = call i64 @st64(i64 %t9553, i64 %p2)
br label %L2862
L2861:
br label %L2862
L2862:
%t9555 = phi i64 [ %t9554, %L2860 ], [ 0, %L2861 ]
%t9556 = add i64 %p0, 8
%t9557 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9558 = add i64 %t9557, 1
%t9559 = call i64 @st64(i64 %t9556, i64 %t9558)
%t9560 = add i64 %p0, 72
%t9561 = call i64 @st8(i64 %t9560, i64 0)
ret i64 %t9561
}
define internal i64 @__mruntime_rt_map_resid__t_decide(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9562 = call i64 @__mruntime_rt_map_resid__tvk(i64 %p0)
%t9563 = sub nsw i64 0, 1
%t9564 = icmp eq i64 %t9562, %t9563
br i1 %t9564, label %L2863, label %L2864
L2863:
%t9565 = add i64 %p0, 25
%t9566 = call i64 @st8(i64 %t9565, i64 %p2)
br label %L2865
L2864:
br label %L2865
L2865:
%t9567 = phi i64 [ %t9566, %L2863 ], [ 0, %L2864 ]
%t9568 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9569 = sub nsw i64 0, 1
%t9570 = icmp ne i64 %t9568, %t9569
br i1 %t9570, label %L2866, label %L2868
L2866:
ret i64 0
L2868:
%t9571 = add i64 %p0, 24
%t9572 = call i64 @st8(i64 %t9571, i64 %p1)
%t9573 = add i64 %p0, 26
%t9574 = icmp eq i64 %p2, 0
br label %LSL9575
LSL9575:
br i1 %t9574, label %LSR9575, label %LSJ9575
LSR9575:
%t9576 = icmp eq i64 %p3, 1
br label %LSJ9575
LSJ9575:
%t9577 = phi i1 [ false, %LSL9575 ], [ %t9576, %LSR9575 ]
br i1 %t9577, label %L2869, label %L2870
L2869:
br label %L2871
L2870:
br label %L2871
L2871:
%t9578 = phi i64 [ 1, %L2869 ], [ 0, %L2870 ]
%t9579 = call i64 @st8(i64 %t9573, i64 %t9578)
%t9580 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9581 = call i64 @__mruntime_rt_map_resid__t_alloc(i64 %p0, i64 %t9580)
ret i64 %t9581
}
define internal i64 @__mruntime_rt_map_resid__t_vals_make(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9582 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9583 = mul i64 %t9582, 8
%t9584 = call i64 @__mruntime_rt_map_resid__map_obj(i64 %t9583)
%t9585 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9586 = call i64 @__mruntime_rt_map_resid__fill_words(i64 %t9584, i64 1, i64 0, i64 %t9585)
%t9587 = add i64 %p0, 40
%t9588 = call i64 @st64(i64 %t9587, i64 %t9584)
%t9589 = add i64 %p0, 26
%t9590 = call i64 @st8(i64 %t9589, i64 0)
ret i64 %t9590
}
define internal i64 @__mruntime_rt_map_resid__t_vals_boxed(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9591 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9592 = call i64 @__mruntime_rt_map_resid__vals_box_at(i64 %p0, i64 0, i64 %t9591)
%t9593 = call i1 @__mruntime_rt_map_resid__toob_has(i64 %p0, i64 0)
br i1 %t9593, label %L2872, label %L2873
L2872:
%t9594 = add i64 %p0, 56
%t9595 = call i64 @__mruntime_rt_map_resid__tvk(i64 %p0)
%t9596 = call i64 @__mruntime_rt_map_resid__toob_val(i64 %p0, i64 0)
%t9597 = call i64 @__mruntime_rt_map_resid__mbox(i64 %t9595, i64 %t9596)
%t9598 = call i64 @st64(i64 %t9594, i64 %t9597)
br label %L2874
L2873:
br label %L2874
L2874:
%t9599 = phi i64 [ %t9598, %L2872 ], [ 0, %L2873 ]
%t9600 = call i1 @__mruntime_rt_map_resid__toob_has(i64 %p0, i64 1)
br i1 %t9600, label %L2875, label %L2876
L2875:
%t9601 = add i64 %p0, 64
%t9602 = call i64 @__mruntime_rt_map_resid__tvk(i64 %p0)
%t9603 = call i64 @__mruntime_rt_map_resid__toob_val(i64 %p0, i64 1)
%t9604 = call i64 @__mruntime_rt_map_resid__mbox(i64 %t9602, i64 %t9603)
%t9605 = call i64 @st64(i64 %t9601, i64 %t9604)
br label %L2877
L2876:
br label %L2877
L2877:
%t9606 = phi i64 [ %t9605, %L2875 ], [ 0, %L2876 ]
%t9607 = add i64 %p0, 25
%t9608 = call i64 @st8(i64 %t9607, i64 0)
ret i64 %t9608
}
define internal i64 @__mruntime_rt_map_resid__vals_box_at(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9631, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t9609 = icmp sge i64 %p1, %p2
br i1 %t9609, label %L2878, label %L2880
L2878:
ret i64 0
L2880:
%t9610 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9611 = mul i64 %p1, 8
%t9612 = add i64 %t9610, %t9611
%t9613 = call i64 @ld64(i64 %t9612)
%t9614 = call i64 @__mruntime_rt_map_resid__t_empty(i64 %p0)
%t9615 = icmp ne i64 %t9613, %t9614
br label %LSL9616
LSL9616:
br i1 %t9615, label %LSR9616, label %LSJ9616
LSR9616:
%t9617 = call i64 @__mruntime_rt_map_resid__t_tomb(i64 %p0)
%t9618 = icmp ne i64 %t9613, %t9617
br label %LSJ9616
LSJ9616:
%t9619 = phi i1 [ false, %LSL9616 ], [ %t9618, %LSR9616 ]
br i1 %t9619, label %L2881, label %L2882
L2881:
%t9620 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9621 = mul i64 %p1, 8
%t9622 = add i64 %t9620, %t9621
%t9623 = call i64 @__mruntime_rt_map_resid__tvk(i64 %p0)
%t9624 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9625 = mul i64 %p1, 8
%t9626 = add i64 %t9624, %t9625
%t9627 = call i64 @ld64(i64 %t9626)
%t9628 = call i64 @__mruntime_rt_map_resid__mbox(i64 %t9623, i64 %t9627)
%t9629 = call i64 @st64(i64 %t9622, i64 %t9628)
br label %L2883
L2882:
br label %L2883
L2883:
%t9630 = phi i64 [ %t9629, %L2881 ], [ 0, %L2882 ]
%t9631 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__t_key_in(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9633 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9634 = icmp eq i64 %t9633, %p1
br i1 %t9634, label %L2884, label %L2886
L2884:
ret i64 %p2
L2886:
%t9635 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9636 = icmp eq i64 %t9635, 0
br i1 %t9636, label %L2887, label %L2889
L2887:
%t9637 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
ret i64 %t9637
L2889:
%t9638 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9639 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %t9638, i64 %p2)
br i1 %t9639, label %L2890, label %L2892
L2890:
%t9640 = call i64 @__mruntime_rt_map_resid__mret()
%t9641 = call i64 @ld64(i64 %t9640)
ret i64 %t9641
L2892:
%t9642 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9643 = call i64 @__mruntime_rt_map_resid__t_rebuild(i64 %p0, i64 %t9642, i64 0, i1 true)
ret i64 %p2
}
define internal i64 @__mruntime_rt_map_resid__t_val_in(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9644 = call i64 @__mruntime_rt_map_resid__tvk(i64 %p0)
%t9645 = icmp eq i64 %t9644, %p1
br i1 %t9645, label %L2893, label %L2895
L2893:
ret i64 %p2
L2895:
%t9646 = call i64 @__mruntime_rt_map_resid__tvk(i64 %p0)
%t9647 = icmp eq i64 %t9646, 0
br i1 %t9647, label %L2896, label %L2898
L2896:
%t9648 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
ret i64 %t9648
L2898:
%t9649 = icmp eq i64 %p1, 0
br label %LSL9650
LSL9650:
br i1 %t9649, label %LSR9650, label %LSJ9650
LSR9650:
%t9651 = call i64 @__mruntime_rt_map_resid__tvk(i64 %p0)
%t9652 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %t9651, i64 %p2)
br label %LSJ9650
LSJ9650:
%t9653 = phi i1 [ false, %LSL9650 ], [ %t9652, %LSR9650 ]
br i1 %t9653, label %L2899, label %L2901
L2899:
%t9654 = call i64 @__mruntime_rt_map_resid__mret()
%t9655 = call i64 @ld64(i64 %t9654)
ret i64 %t9655
L2901:
%t9656 = call i64 @__mruntime_rt_map_resid__t_vals_boxed(i64 %p0)
%t9657 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
ret i64 %t9657
}
define internal i64 @__mruntime_rt_map_resid__word_out(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9658 = icmp eq i64 %p0, %p1
br label %LSL9659
LSL9659:
br i1 %t9658, label %LSJ9659, label %LSR9659
LSR9659:
%t9660 = sub nsw i64 0, 1
%t9661 = icmp eq i64 %p0, %t9660
br label %LSJ9659
LSJ9659:
%t9662 = phi i1 [ true, %LSL9659 ], [ %t9661, %LSR9659 ]
br i1 %t9662, label %L2902, label %L2904
L2902:
ret i64 %p2
L2904:
%t9663 = icmp eq i64 %p1, 0
br i1 %t9663, label %L2905, label %L2907
L2905:
%t9664 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p0, i64 %p2)
ret i64 %t9664
L2907:
%t9665 = icmp eq i64 %p0, 0
br label %LSL9666
LSL9666:
br i1 %t9665, label %LSR9666, label %LSJ9666
LSR9666:
%t9667 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %p1, i64 %p2)
br label %LSJ9666
LSJ9666:
%t9668 = phi i1 [ false, %LSL9666 ], [ %t9667, %LSR9666 ]
br i1 %t9668, label %L2908, label %L2910
L2908:
%t9669 = call i64 @__mruntime_rt_map_resid__mret()
%t9670 = call i64 @ld64(i64 %t9669)
ret i64 %t9670
L2910:
ret i64 %p2
}
define internal i64 @__mruntime_rt_map_resid__map_one() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9671p = getelementptr i8, ptr @rtg.map_one, i64 0
%t9671 = ptrtoint ptr %t9671p to i64
ret i64 %t9671
}
define internal i64 @__mruntime_rt_map_resid__t_vref(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9672 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9673 = icmp eq i64 %t9672, 0
br label %LSL9674
LSL9674:
br i1 %t9673, label %LSJ9674, label %LSR9674
LSR9674:
%t9675 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9676 = icmp eq i64 %t9675, 0
br label %LSJ9674
LSJ9674:
%t9677 = phi i1 [ true, %LSL9674 ], [ %t9676, %LSR9674 ]
br i1 %t9677, label %L2911, label %L2913
L2911:
ret i64 0
L2913:
%t9678 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9679 = icmp eq i64 %t9678, %p1
br label %LSL9680
LSL9680:
br i1 %t9679, label %LSJ9680, label %LSR9680
LSR9680:
%t9681 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9682 = icmp eq i64 %t9681, 0
br label %LSL9683
LSL9683:
br i1 %t9682, label %LSR9683, label %LSJ9683
LSR9683:
%t9684 = icmp eq i64 %p1, 1
br label %LSJ9683
LSJ9683:
%t9685 = phi i1 [ false, %LSL9683 ], [ %t9684, %LSR9683 ]
br label %LSJ9680
LSJ9680:
%t9686 = phi i1 [ true, %LSL9680 ], [ %t9685, %LSJ9683 ]
br label %LSL9687
LSL9687:
br i1 %t9686, label %LSJ9687, label %LSR9687
LSR9687:
%t9688 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9689 = icmp ne i64 %t9688, 0
br label %LSL9690
LSL9690:
br i1 %t9689, label %LSR9690, label %LSJ9690
LSR9690:
%t9691 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9692 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %t9691, i64 %p2)
br label %LSJ9690
LSJ9690:
%t9693 = phi i1 [ false, %LSL9690 ], [ %t9692, %LSR9690 ]
br label %LSJ9687
LSJ9687:
%t9694 = phi i1 [ true, %LSL9687 ], [ %t9693, %LSJ9690 ]
%t9695 = xor i1 %t9694, true
br i1 %t9695, label %L2914, label %L2916
L2914:
ret i64 0
L2916:
br i1 %t9679, label %L2917, label %L2918
L2917:
br label %L2919
L2918:
%t9696 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9697 = icmp eq i64 %t9696, 0
br i1 %t9697, label %L2920, label %L2921
L2920:
%t9698 = call i64 @c_box_i64(i64 %p2)
br label %L2922
L2921:
%t9699 = call i64 @__mruntime_rt_map_resid__mret()
%t9700 = call i64 @ld64(i64 %t9699)
br label %L2922
L2922:
%t9701 = phi i64 [ %t9698, %L2920 ], [ %t9700, %L2921 ]
br label %L2919
L2919:
%t9702 = phi i64 [ %p2, %L2917 ], [ %t9701, %L2922 ]
%t9703 = call i64 @__mruntime_rt_map_resid__t_oob(i64 %p0, i64 %t9702)
%t9704 = icmp sge i64 %t9703, 0
br i1 %t9704, label %L2923, label %L2925
L2923:
%t9705 = call i1 @__mruntime_rt_map_resid__toob_has(i64 %p0, i64 %t9703)
br i1 %t9705, label %L2926, label %L2927
L2926:
%t9706 = add i64 %p0, 56
%t9707 = mul i64 %t9703, 8
%t9708 = add i64 %t9706, %t9707
br label %L2928
L2927:
br label %L2928
L2928:
%t9709 = phi i64 [ %t9708, %L2926 ], [ 0, %L2927 ]
ret i64 %t9709
L2925:
%t9710 = call i64 @__mruntime_rt_map_resid__t_probe(i64 %p0, i64 %t9702)
%t9711 = icmp slt i64 %t9710, 0
br i1 %t9711, label %L2929, label %L2931
L2929:
ret i64 0
L2931:
%t9712 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9713 = icmp ne i64 %t9712, 0
br i1 %t9713, label %L2932, label %L2934
L2932:
%t9714 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9715 = mul i64 %t9710, 8
%t9716 = add i64 %t9714, %t9715
ret i64 %t9716
L2934:
%t9717 = call i64 @__mruntime_rt_map_resid__map_one()
%t9718 = call i64 @st64(i64 %t9717, i64 1)
%t9719 = mul nsw i64 %t9718, 0
%t9720 = call i64 @__mruntime_rt_map_resid__map_one()
%t9721 = add nsw i64 %t9719, %t9720
ret i64 %t9721
}
define internal i64 @__mruntime_rt_map_resid__t_put_s(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9722 = call i64 @__mruntime_rt_map_resid__t_decide(i64 %p0, i64 %p1, i64 %p3, i64 %p4)
%t9723 = call i64 @__mruntime_rt_map_resid__t_key_in(i64 %p0, i64 %p1, i64 %p2)
%t9724 = call i64 @__mruntime_rt_map_resid__t_val_in(i64 %p0, i64 %p3, i64 %p4)
%t9725 = call i1 @__mruntime_rt_map_resid__tnov(i64 %p0)
br label %LSL9726
LSL9726:
br i1 %t9725, label %LSR9726, label %LSJ9726
LSR9726:
%t9727 = icmp ne i64 %t9724, 1
br label %LSJ9726
LSJ9726:
%t9728 = phi i1 [ false, %LSL9726 ], [ %t9727, %LSR9726 ]
br i1 %t9728, label %L2935, label %L2936
L2935:
%t9729 = call i64 @__mruntime_rt_map_resid__t_vals_make(i64 %p0)
br label %L2937
L2936:
br label %L2937
L2937:
%t9730 = phi i64 [ %t9729, %L2935 ], [ 0, %L2936 ]
%t9731 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9732 = call i64 @__mruntime_rt_map_resid__t_vref(i64 %p0, i64 %t9731, i64 %t9723)
%t9733 = icmp ne i64 %p6, 0
br i1 %t9733, label %L2938, label %L2939
L2938:
%t9734 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %p6, i64 %t9724)
br label %L2940
L2939:
br label %L2940
L2940:
%t9735 = phi i64 [ %t9734, %L2938 ], [ %t9724, %L2939 ]
%t9736 = icmp ne i64 %t9732, 0
br i1 %t9736, label %L2941, label %L2943
L2941:
%t9737 = call i1 @__mruntime_rt_map_resid__tnov(i64 %p0)
%t9738 = xor i1 %t9737, true
br i1 %t9738, label %L2944, label %L2945
L2944:
%t9739 = call i64 @st64(i64 %t9732, i64 %t9735)
br label %L2946
L2945:
br label %L2946
L2946:
%t9740 = phi i64 [ %t9739, %L2944 ], [ 0, %L2945 ]
ret i64 %t9740
L2943:
%t9741 = icmp ne i64 %p5, 0
br i1 %t9741, label %L2947, label %L2948
L2947:
%t9742 = call i64 @__mruntime_rt_map_resid__word_keep(i64 4, i64 %t9723)
br label %L2949
L2948:
br label %L2949
L2949:
%t9743 = phi i64 [ %t9742, %L2947 ], [ %t9723, %L2948 ]
%t9744 = call i64 @__mruntime_rt_map_resid__t_insert_new(i64 %p0, i64 %t9743, i64 %t9735)
ret i64 %t9744
}
define internal i64 @__mruntime_rt_map_resid__t_put(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9745 = call i64 @__mruntime_rt_map_resid__t_put_s(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 0, i64 0)
ret i64 %t9745
}
define internal i1 @__mruntime_rt_map_resid__t_del(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9746 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9747 = icmp eq i64 %t9746, 0
br label %LSL9748
LSL9748:
br i1 %t9747, label %LSJ9748, label %LSR9748
LSR9748:
%t9749 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9750 = icmp eq i64 %t9749, 0
br label %LSJ9748
LSJ9748:
%t9751 = phi i1 [ true, %LSL9748 ], [ %t9750, %LSR9748 ]
br i1 %t9751, label %L2950, label %L2952
L2950:
ret i1 false
L2952:
%t9752 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9753 = icmp eq i64 %t9752, %p1
br label %LSL9754
LSL9754:
br i1 %t9753, label %LSJ9754, label %LSR9754
LSR9754:
%t9755 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9756 = icmp eq i64 %t9755, 0
br label %LSJ9754
LSJ9754:
%t9757 = phi i1 [ true, %LSL9754 ], [ %t9756, %LSR9754 ]
br label %LSL9758
LSL9758:
br i1 %t9757, label %LSJ9758, label %LSR9758
LSR9758:
%t9759 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9760 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %t9759, i64 %p2)
br label %LSJ9758
LSJ9758:
%t9761 = phi i1 [ true, %LSL9758 ], [ %t9760, %LSR9758 ]
%t9762 = xor i1 %t9761, true
br i1 %t9762, label %L2953, label %L2955
L2953:
ret i1 false
L2955:
br i1 %t9753, label %L2956, label %L2957
L2956:
br label %L2958
L2957:
%t9763 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9764 = icmp eq i64 %t9763, 0
br i1 %t9764, label %L2959, label %L2960
L2959:
%t9765 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
br label %L2961
L2960:
%t9766 = call i64 @__mruntime_rt_map_resid__mret()
%t9767 = call i64 @ld64(i64 %t9766)
br label %L2961
L2961:
%t9768 = phi i64 [ %t9765, %L2959 ], [ %t9767, %L2960 ]
br label %L2958
L2958:
%t9769 = phi i64 [ %p2, %L2956 ], [ %t9768, %L2961 ]
%t9770 = add i64 %p0, 72
%t9771 = call i64 @st8(i64 %t9770, i64 0)
%t9772 = call i64 @__mruntime_rt_map_resid__t_oob(i64 %p0, i64 %t9769)
%t9773 = icmp sge i64 %t9772, 0
br i1 %t9773, label %L2962, label %L2964
L2962:
%t9774 = call i1 @__mruntime_rt_map_resid__toob_has(i64 %p0, i64 %t9772)
%t9775 = xor i1 %t9774, true
br i1 %t9775, label %L2965, label %L2967
L2965:
ret i1 false
L2967:
%t9776 = add i64 %p0, 48
%t9777 = add i64 %t9776, %t9772
%t9778 = call i64 @st8(i64 %t9777, i64 0)
%t9779 = add i64 %p0, 8
%t9780 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9781 = sub i64 %t9780, 1
%t9782 = call i64 @st64(i64 %t9779, i64 %t9781)
%t9783 = icmp eq i64 %t9782, 0
ret i1 %t9783
L2964:
%t9784 = call i64 @__mruntime_rt_map_resid__t_probe(i64 %p0, i64 %t9769)
%t9785 = icmp slt i64 %t9784, 0
br i1 %t9785, label %L2968, label %L2970
L2968:
ret i1 false
L2970:
%t9786 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9787 = mul i64 %t9784, 8
%t9788 = add i64 %t9786, %t9787
%t9789 = call i64 @__mruntime_rt_map_resid__t_tomb(i64 %p0)
%t9790 = call i64 @st64(i64 %t9788, i64 %t9789)
%t9791 = add i64 %p0, 8
%t9792 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9793 = sub i64 %t9792, 1
%t9794 = call i64 @st64(i64 %t9791, i64 %t9793)
%t9795 = add i64 %p0, 16
%t9796 = call i64 @__mruntime_rt_map_resid__ttombs(i64 %p0)
%t9797 = add i64 %t9796, 1
%t9798 = call i64 @st64(i64 %t9795, i64 %t9797)
%t9799 = icmp eq i64 %t9798, 0
ret i1 %t9799
}
define internal i64 @__mruntime_rt_map_resid__map_kk(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9800 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9801 = icmp ne i64 %t9800, 0
br i1 %t9801, label %L2971, label %L2972
L2971:
%t9802 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9803 = call i64 @__mruntime_rt_map_resid__tkk(i64 %t9802)
br label %L2973
L2972:
%t9804 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
br label %L2973
L2973:
%t9805 = phi i64 [ %t9803, %L2971 ], [ %t9804, %L2972 ]
ret i64 %t9805
}
define internal i64 @__mruntime_rt_map_resid__map_vk(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9806 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9807 = icmp ne i64 %t9806, 0
br i1 %t9807, label %L2974, label %L2975
L2974:
%t9808 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9809 = call i64 @__mruntime_rt_map_resid__tvk(i64 %t9808)
br label %L2976
L2975:
%t9810 = call i64 @__mruntime_rt_map_resid__mvk(i64 %p0)
br label %L2976
L2976:
%t9811 = phi i64 [ %t9809, %L2974 ], [ %t9810, %L2975 ]
ret i64 %t9811
}
define internal i64 @__mruntime_rt_map_resid__trie_build(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9812 = call i64 @__mruntime_rt_map_resid__new_edit()
%t9813 = call i64 @__mruntime_rt_map_resid__build_at(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %t9812, i64 0, i64 0)
ret i64 %t9813
}
define internal i64 @__mruntime_rt_map_resid__build_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t9825, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %t9824, %tco.s0 ]
%t9814 = icmp sge i64 %p5, %p2
br i1 %t9814, label %L2977, label %L2979
L2977:
ret i64 %p6
L2979:
%t9815 = mul i64 %p5, 8
%t9816 = add i64 %p0, %t9815
%t9817 = call i64 @ld64(i64 %t9816)
%t9818 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %p3, i64 %t9817)
%t9819 = icmp ne i64 %p1, 0
br i1 %t9819, label %L2980, label %L2981
L2980:
%t9820 = mul i64 %p5, 8
%t9821 = add i64 %p1, %t9820
%t9822 = call i64 @ld64(i64 %t9821)
br label %L2982
L2981:
br label %L2982
L2982:
%t9823 = phi i64 [ %t9822, %L2980 ], [ 1, %L2981 ]
%t9824 = call i64 @__mruntime_rt_map_resid__hn_insert(i64 %p6, i64 0, i64 %t9818, i64 %p3, i64 %t9817, i64 %t9823, i64 %p4)
%t9825 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__t_entries(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9827 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9828 = icmp eq i64 %t9827, 0
br i1 %t9828, label %L2983, label %L2985
L2983:
ret i64 0
L2985:
%t9829 = mul i64 %t9827, 24
%t9830 = call i64 @xmalloc(i64 %t9829)
%t9831 = call i64 @__mruntime_rt_map_resid__ents_fill(i64 %p0, i64 %t9830, i64 0, i64 0)
%t9832 = mul i64 %t9827, 24
%t9833 = call i64 @xmalloc(i64 %t9832)
%t9834 = call i64 @__mruntime_rt_map_resid__ent_sort(i64 %t9830, i64 %t9833, i64 %t9827, i64 1)
%t9835 = call i64 @__mruntime_rt_map_resid__ents_out(i64 %t9834, i64 %p1, i64 %p2, i64 0, i64 %t9827)
%t9836 = call i64 @c_free(i64 %t9830)
%t9837 = call i64 @c_free(i64 %t9833)
%t9838 = add i64 %t9836, %t9837
ret i64 %t9838
}
define internal i64 @__mruntime_rt_map_resid__ents_fill(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9839, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9857, %tco.s0 ]
%t9839 = call i64 @__mruntime_rt_map_resid__t_next(i64 %p0, i64 %p2)
%t9840 = icmp slt i64 %t9839, 0
br i1 %t9840, label %L2986, label %L2988
L2986:
ret i64 %p3
L2988:
%t9841 = call i64 @__mruntime_rt_map_resid__mret()
%t9842 = call i64 @ld64(i64 %t9841)
%t9843 = mul i64 %p3, 24
%t9844 = add i64 %p1, %t9843
%t9845 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9846 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %t9845, i64 %t9842)
%t9847 = call i64 @__mruntime_rt_map_resid__canon_rank(i64 %t9846)
%t9848 = call i64 @st64(i64 %t9844, i64 %t9847)
%t9849 = add i64 %t9844, 8
%t9850 = call i64 @st64(i64 %t9849, i64 %t9842)
%t9851 = add i64 %t9848, %t9850
%t9852 = add i64 %t9844, 16
%t9853 = call i64 @__mruntime_rt_map_resid__mflag()
%t9854 = call i64 @ld64(i64 %t9853)
%t9855 = call i64 @st64(i64 %t9852, i64 %t9854)
%t9856 = add i64 %t9851, %t9855
%t9857 = add i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__ent_merge(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9859 = icmp slt i64 %p2, %p3
br label %LSL9860
LSL9860:
br i1 %t9859, label %LSR9860, label %LSJ9860
LSR9860:
%t9861 = icmp slt i64 %p4, %p5
br label %LSJ9860
LSJ9860:
%t9862 = phi i1 [ false, %LSL9860 ], [ %t9861, %LSR9860 ]
br i1 %t9862, label %L2989, label %L2991
L2989:
%t9863 = mul i64 %p4, 24
%t9864 = add i64 %p0, %t9863
%t9865 = call i64 @ld64(i64 %t9864)
%t9866 = mul i64 %p2, 24
%t9867 = add i64 %p0, %t9866
%t9868 = call i64 @ld64(i64 %t9867)
%t9869 = call i1 @ult(i64 %t9865, i64 %t9868)
%t9870 = xor i1 %t9869, true
br i1 %t9870, label %L2992, label %L2993
L2992:
br label %L2994
L2993:
br label %L2994
L2994:
%t9871 = phi i64 [ %p2, %L2992 ], [ %p4, %L2993 ]
%t9872 = mul i64 %p6, 24
%t9873 = add i64 %p1, %t9872
%t9874 = mul i64 %t9871, 24
%t9875 = add i64 %p0, %t9874
%t9876 = call i64 @mcopy(i64 %t9873, i64 %t9875, i64 24)
br i1 %t9870, label %L2995, label %L2996
L2995:
%t9877 = add nsw i64 %p2, 1
%t9878 = add i64 %p6, 1
%t9879 = call i64 @__mruntime_rt_map_resid__ent_merge(i64 %p0, i64 %p1, i64 %t9877, i64 %p3, i64 %p4, i64 %p5, i64 %t9878)
br label %L2997
L2996:
%t9880 = add nsw i64 %p4, 1
%t9881 = add i64 %p6, 1
%t9882 = call i64 @__mruntime_rt_map_resid__ent_merge(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %t9880, i64 %p5, i64 %t9881)
br label %L2997
L2997:
%t9883 = phi i64 [ %t9879, %L2995 ], [ %t9882, %L2996 ]
ret i64 %t9883
L2991:
%t9884 = icmp slt i64 %p2, %p3
br i1 %t9884, label %L2998, label %L2999
L2998:
%t9885 = mul i64 %p6, 24
%t9886 = add i64 %p1, %t9885
%t9887 = mul i64 %p2, 24
%t9888 = add i64 %p0, %t9887
%t9889 = sub i64 %p3, %p2
%t9890 = mul i64 %t9889, 24
%t9891 = call i64 @mcopy(i64 %t9886, i64 %t9888, i64 %t9890)
br label %L3000
L2999:
br label %L3000
L3000:
%t9892 = phi i64 [ %t9891, %L2998 ], [ 0, %L2999 ]
%t9893 = icmp slt i64 %p4, %p5
br i1 %t9893, label %L3001, label %L3002
L3001:
%t9894 = add i64 %p6, %p3
%t9895 = sub i64 %t9894, %p2
%t9896 = mul i64 %t9895, 24
%t9897 = add i64 %p1, %t9896
%t9898 = mul i64 %p4, 24
%t9899 = add i64 %p0, %t9898
%t9900 = sub i64 %p5, %p4
%t9901 = mul i64 %t9900, 24
%t9902 = call i64 @mcopy(i64 %t9897, i64 %t9899, i64 %t9901)
br label %L3003
L3002:
br label %L3003
L3003:
%t9903 = phi i64 [ %t9902, %L3001 ], [ 0, %L3002 ]
ret i64 %t9903
}
define internal i64 @__mruntime_rt_map_resid__ent_pass(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t9917, %tco.s0 ]
%t9904 = icmp sge i64 %p4, %p2
br i1 %t9904, label %L3004, label %L3006
L3004:
ret i64 0
L3006:
%t9905 = add i64 %p4, %p3
%t9906 = icmp slt i64 %t9905, %p2
br i1 %t9906, label %L3007, label %L3008
L3007:
br label %L3009
L3008:
br label %L3009
L3009:
%t9907 = phi i64 [ %t9905, %L3007 ], [ %p2, %L3008 ]
%t9908 = add i64 %p4, %p3
%t9909 = icmp slt i64 %t9908, %p2
br i1 %t9909, label %L3010, label %L3011
L3010:
br label %L3012
L3011:
br label %L3012
L3012:
%t9910 = phi i64 [ %t9908, %L3010 ], [ %p2, %L3011 ]
%t9911 = mul i64 2, %p3
%t9912 = add i64 %p4, %t9911
%t9913 = icmp slt i64 %t9912, %p2
br i1 %t9913, label %L3013, label %L3014
L3013:
br label %L3015
L3014:
br label %L3015
L3015:
%t9914 = phi i64 [ %t9912, %L3013 ], [ %p2, %L3014 ]
%t9915 = call i64 @__mruntime_rt_map_resid__ent_merge(i64 %p0, i64 %p1, i64 %p4, i64 %t9907, i64 %t9910, i64 %t9914, i64 %p4)
%t9916 = mul i64 2, %p3
%t9917 = add i64 %p4, %t9916
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__ent_sort(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p1, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p0, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9921, %tco.s0 ]
%t9919 = icmp sge i64 %p3, %p2
br i1 %t9919, label %L3016, label %L3018
L3016:
ret i64 %p0
L3018:
%t9920 = call i64 @__mruntime_rt_map_resid__ent_pass(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0)
%t9921 = mul i64 %p3, 2
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__ents_out(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9942, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t9923 = icmp sge i64 %p3, %p4
br i1 %t9923, label %L3019, label %L3021
L3019:
ret i64 0
L3021:
%t9924 = icmp ne i64 %p1, 0
br i1 %t9924, label %L3022, label %L3023
L3022:
%t9925 = mul i64 %p3, 8
%t9926 = add i64 %p1, %t9925
%t9927 = mul i64 %p3, 24
%t9928 = add i64 %p0, %t9927
%t9929 = add i64 %t9928, 8
%t9930 = call i64 @ld64(i64 %t9929)
%t9931 = call i64 @st64(i64 %t9926, i64 %t9930)
br label %L3024
L3023:
br label %L3024
L3024:
%t9932 = phi i64 [ %t9931, %L3022 ], [ 0, %L3023 ]
%t9933 = icmp ne i64 %p2, 0
br i1 %t9933, label %L3025, label %L3026
L3025:
%t9934 = mul i64 %p3, 8
%t9935 = add i64 %p2, %t9934
%t9936 = mul i64 %p3, 24
%t9937 = add i64 %p0, %t9936
%t9938 = add i64 %t9937, 16
%t9939 = call i64 @ld64(i64 %t9938)
%t9940 = call i64 @st64(i64 %t9935, i64 %t9939)
br label %L3027
L3026:
br label %L3027
L3027:
%t9941 = phi i64 [ %t9940, %L3025 ], [ 0, %L3026 ]
%t9942 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__map_entries(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9944 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9945 = icmp ne i64 %t9944, 0
br i1 %t9945, label %L3028, label %L3030
L3028:
%t9946 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9947 = tail call i64 @__mruntime_rt_map_resid__t_entries(i64 %t9946, i64 %p1, i64 %p2)
ret i64 %t9947
L3030:
%t9948 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t9949 = call i64 @__mruntime_rt_map_resid__hn_collect(i64 %t9948, i64 %p1, i64 %p2, i64 0)
ret i64 %t9949
}
define internal i64 @__mruntime_rt_map_resid__words_of(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9950 = icmp sgt i64 %p0, 1
br i1 %t9950, label %L3031, label %L3032
L3031:
br label %L3033
L3032:
br label %L3033
L3033:
%t9951 = phi i64 [ %p0, %L3031 ], [ 1, %L3032 ]
%t9952 = mul i64 %t9951, 8
%t9953 = tail call i64 @xmalloc(i64 %t9952)
ret i64 %t9953
}
define internal i64 @__mruntime_rt_map_resid__map_root(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9954 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9955 = icmp eq i64 %t9954, 0
br i1 %t9955, label %L3034, label %L3036
L3034:
%t9956 = tail call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
ret i64 %t9956
L3036:
%t9957 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
%t9958 = xor i1 %t9957, true
br i1 %t9958, label %L3037, label %L3039
L3037:
%t9959 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t9960 = icmp ne i64 %t9959, 0
br label %LSL9961
LSL9961:
br i1 %t9960, label %LSJ9961, label %LSR9961
LSR9961:
%t9962 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t9963 = icmp eq i64 %t9962, 0
br label %LSJ9961
LSJ9961:
%t9964 = phi i1 [ true, %LSL9961 ], [ %t9963, %LSR9961 ]
br i1 %t9964, label %L3040, label %L3042
L3040:
ret i64 %t9959
L3042:
br label %L3039
L3039:
%t9965 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9966 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t9965)
%t9967 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
%t9968 = xor i1 %t9967, true
%t9969 = call i64 @xmalloc(i64 24)
br i1 %t9968, label %L3043, label %L3044
L3043:
%t9970 = call i64 @c_suspend(i64 %t9969)
br label %L3045
L3044:
br label %L3045
L3045:
%t9971 = phi i64 [ %t9970, %L3043 ], [ 0, %L3044 ]
%t9972 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t9966)
%t9973 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t9966)
%t9974 = call i64 @__mruntime_rt_map_resid__table_words(i64 %t9965, i64 %t9972, i64 %t9973, i64 0, i64 0)
%t9975 = call i64 @__mruntime_rt_map_resid__tkk(i64 %t9965)
%t9976 = call i64 @__mruntime_rt_map_resid__trie_build(i64 %t9972, i64 %t9973, i64 %t9966, i64 %t9975)
%t9977 = call i64 @c_free(i64 %t9972)
%t9978 = call i64 @c_free(i64 %t9973)
%t9979 = add i64 %t9977, %t9978
br i1 %t9968, label %L3046, label %L3047
L3046:
%t9980 = call i64 @c_resume(i64 %t9969)
br label %L3048
L3047:
br label %L3048
L3048:
%t9981 = phi i64 [ %t9980, %L3046 ], [ 0, %L3047 ]
%t9982 = call i64 @c_free(i64 %t9969)
%t9983 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
br i1 %t9983, label %L3049, label %L3051
L3049:
ret i64 %t9976
L3051:
%t9984 = add i64 %p0, 8
%t9985p = inttoptr i64 %t9984 to ptr
%t9985x = cmpxchg ptr %t9985p, i64 0, i64 %t9976 seq_cst seq_cst
%t9985 = extractvalue {i64, i1} %t9985x, 1
br i1 %t9985, label %L3052, label %L3054
L3052:
ret i64 %t9976
L3054:
%t9986 = tail call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
ret i64 %t9986
}
define internal i64 @__mruntime_rt_map_resid__table_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9987, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t9999, %tco.s0 ]
%t9987 = call i64 @__mruntime_rt_map_resid__t_next(i64 %p0, i64 %p3)
%t9988 = icmp slt i64 %t9987, 0
br i1 %t9988, label %L3055, label %L3057
L3055:
ret i64 %p4
L3057:
%t9989 = mul i64 %p4, 8
%t9990 = add i64 %p1, %t9989
%t9991 = call i64 @__mruntime_rt_map_resid__mret()
%t9992 = call i64 @ld64(i64 %t9991)
%t9993 = call i64 @st64(i64 %t9990, i64 %t9992)
%t9994 = mul i64 %p4, 8
%t9995 = add i64 %p2, %t9994
%t9996 = call i64 @__mruntime_rt_map_resid__mflag()
%t9997 = call i64 @ld64(i64 %t9996)
%t9998 = call i64 @st64(i64 %t9995, i64 %t9997)
%t9999 = add i64 %p4, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__map_exit(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10001 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
br label %LSL10002
LSL10002:
br i1 %t10001, label %LSR10002, label %LSJ10002
LSR10002:
%t10003 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10004 = icmp sle i64 %t10003, 0
br label %LSJ10002
LSJ10002:
%t10005 = phi i1 [ false, %LSL10002 ], [ %t10004, %LSR10002 ]
br i1 %t10005, label %L3058, label %L3060
L3058:
%t10006 = add i64 %p0, 40
%t10007 = call i64 @__mruntime_rt_map_resid__new_own()
%t10008 = call i64 @st32(i64 %t10006, i64 %t10007)
ret i64 %t10008
L3060:
ret i64 0
}
define internal i64 @__mruntime_rt_map_resid__base_w() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10009p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_base)
%t10009 = ptrtoint ptr %t10009p to i64
ret i64 %t10009
}
define internal i64 @__mruntime_rt_map_resid__base_set(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10010 = call i64 @__mruntime_rt_map_resid__base_w()
%t10011 = call i64 @st64(i64 %t10010, i64 %p0)
%t10012 = call i64 @__mruntime_rt_map_resid__base_w()
%t10013 = add i64 %t10012, 8
%t10014 = call i64 @st64(i64 %t10013, i64 %p1)
%t10015 = add i64 %t10011, %t10014
%t10016 = call i64 @__mruntime_rt_map_resid__base_w()
%t10017 = add i64 %t10016, 16
%t10018 = call i64 @st64(i64 %t10017, i64 %p2)
%t10019 = add i64 %t10015, %t10018
ret i64 %t10019
}
define internal i64 @__mruntime_rt_map_resid__b_root() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10020 = call i64 @__mruntime_rt_map_resid__base_w()
%t10021 = call i64 @ld64(i64 %t10020)
ret i64 %t10021
}
define internal i64 @__mruntime_rt_map_resid__b_kk() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10022 = call i64 @__mruntime_rt_map_resid__base_w()
%t10023 = add i64 %t10022, 8
%t10024 = call i64 @ld64(i64 %t10023)
ret i64 %t10024
}
define internal i64 @__mruntime_rt_map_resid__b_vk() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10025 = call i64 @__mruntime_rt_map_resid__base_w()
%t10026 = add i64 %t10025, 16
%t10027 = call i64 @ld64(i64 %t10026)
ret i64 %t10027
}
define internal i64 @__mruntime_rt_map_resid__map_base(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10028 = call i64 @__mruntime_rt_map_resid__map_exit(i64 %p0)
%t10029 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10030 = icmp ne i64 %t10029, 0
br label %LSL10031
LSL10031:
br i1 %t10030, label %LSJ10031, label %LSR10031
LSR10031:
%t10032 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
%t10033 = xor i1 %t10032, true
br label %LSJ10031
LSJ10031:
%t10034 = phi i1 [ true, %LSL10031 ], [ %t10033, %LSR10031 ]
br i1 %t10034, label %L3061, label %L3063
L3061:
%t10035 = call i64 @__mruntime_rt_map_resid__map_root(i64 %p0)
%t10036 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t10037 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10038 = call i64 @__mruntime_rt_map_resid__base_set(i64 %t10035, i64 %t10036, i64 %t10037)
ret i64 %t10038
L3063:
%t10039 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10040 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t10039)
%t10041 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t10039)
%t10042 = call i64 @__mruntime_rt_map_resid__map_entries(i64 %p0, i64 %t10040, i64 %t10041)
%t10043 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t10044 = call i64 @__mruntime_rt_map_resid__trie_build(i64 %t10040, i64 %t10041, i64 %t10039, i64 %t10043)
%t10045 = call i64 @c_free(i64 %t10040)
%t10046 = call i64 @c_free(i64 %t10041)
%t10047 = add i64 %t10045, %t10046
%t10048 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t10049 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10050 = call i64 @__mruntime_rt_map_resid__base_set(i64 %t10044, i64 %t10048, i64 %t10049)
ret i64 %t10050
}
define internal i64 @__mruntime_rt_map_resid__base_boxed(i64 %p0, i1 %p1, i1 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10051 = call i64 @__mruntime_rt_map_resid__words_of(i64 %p0)
%t10052 = call i64 @__mruntime_rt_map_resid__words_of(i64 %p0)
%t10053 = call i64 @__mruntime_rt_map_resid__b_root()
%t10054 = call i64 @__mruntime_rt_map_resid__hn_collect(i64 %t10053, i64 %t10051, i64 %t10052, i64 0)
br i1 %p1, label %L3064, label %L3065
L3064:
br label %L3066
L3065:
%t10055 = call i64 @__mruntime_rt_map_resid__b_kk()
br label %L3066
L3066:
%t10056 = phi i64 [ 0, %L3064 ], [ %t10055, %L3065 ]
br i1 %p2, label %L3067, label %L3068
L3067:
br label %L3069
L3068:
%t10057 = call i64 @__mruntime_rt_map_resid__b_vk()
br label %L3069
L3069:
%t10058 = phi i64 [ 0, %L3067 ], [ %t10057, %L3068 ]
%t10059 = call i64 @__mruntime_rt_map_resid__b_kk()
%t10060 = call i64 @__mruntime_rt_map_resid__b_vk()
%t10061 = call i64 @__mruntime_rt_map_resid__box_words(i64 %t10051, i64 %t10052, i64 0, i64 %p0, i1 %p1, i1 %p2, i64 %t10059, i64 %t10060)
%t10062 = call i64 @__mruntime_rt_map_resid__trie_build(i64 %t10051, i64 %t10052, i64 %p0, i64 %t10056)
%t10063 = call i64 @c_free(i64 %t10051)
%t10064 = call i64 @c_free(i64 %t10052)
%t10065 = add i64 %t10063, %t10064
%t10066 = call i64 @__mruntime_rt_map_resid__base_set(i64 %t10062, i64 %t10056, i64 %t10058)
ret i64 %t10066
}
define internal i64 @__mruntime_rt_map_resid__box_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i1 %p4.in, i1 %p5.in, i64 %p6.in, i64 %p7.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t10084, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i1 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i1 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p7, %tco.s0 ]
%t10067 = icmp sge i64 %p2, %p3
br i1 %t10067, label %L3070, label %L3072
L3070:
ret i64 0
L3072:
br i1 %p4, label %L3073, label %L3074
L3073:
%t10068 = mul i64 %p2, 8
%t10069 = add i64 %p0, %t10068
%t10070 = mul i64 %p2, 8
%t10071 = add i64 %p0, %t10070
%t10072 = call i64 @ld64(i64 %t10071)
%t10073 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p6, i64 %t10072)
%t10074 = call i64 @st64(i64 %t10069, i64 %t10073)
br label %L3075
L3074:
br label %L3075
L3075:
%t10075 = phi i64 [ %t10074, %L3073 ], [ 0, %L3074 ]
br i1 %p5, label %L3076, label %L3077
L3076:
%t10076 = mul i64 %p2, 8
%t10077 = add i64 %p1, %t10076
%t10078 = mul i64 %p2, 8
%t10079 = add i64 %p1, %t10078
%t10080 = call i64 @ld64(i64 %t10079)
%t10081 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p7, i64 %t10080)
%t10082 = call i64 @st64(i64 %t10077, i64 %t10081)
br label %L3078
L3077:
br label %L3078
L3078:
%t10083 = phi i64 [ %t10082, %L3076 ], [ 0, %L3077 ]
%t10084 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_map_resid__word_in(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10086 = icmp eq i64 %p0, %p1
br i1 %t10086, label %L3079, label %L3081
L3079:
%t10087 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %p2)
%t10088 = icmp ne i64 %t10087, 0
ret i1 %t10088
L3081:
%t10089 = icmp eq i64 %p0, 0
br i1 %t10089, label %L3082, label %L3084
L3082:
%t10090 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
%t10091 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t10090)
%t10092 = icmp ne i64 %t10091, 0
ret i1 %t10092
L3084:
%t10093 = icmp eq i64 %p1, 0
br i1 %t10093, label %L3085, label %L3087
L3085:
%t10094 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %p0, i64 %p2)
ret i1 %t10094
L3087:
ret i1 false
}
define internal i64 @__mruntime_rt_map_resid__map_insert_p(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10095 = call i64 @__mruntime_rt_map_resid__map_base(i64 %p0)
%t10096 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10097 = icmp eq i64 %t10096, 0
br i1 %t10097, label %L3088, label %L3089
L3088:
%t10098 = call i64 @__mruntime_rt_map_resid__base_set(i64 0, i64 %p1, i64 %p3)
br label %L3090
L3089:
br label %L3090
L3090:
%t10099 = phi i64 [ %t10098, %L3088 ], [ 0, %L3089 ]
%t10100 = call i64 @__mruntime_rt_map_resid__b_kk()
%t10101 = sub nsw i64 0, 1
%t10102 = icmp eq i64 %t10100, %t10101
br i1 %t10102, label %L3091, label %L3092
L3091:
%t10103 = call i64 @__mruntime_rt_map_resid__base_w()
%t10104 = add i64 %t10103, 8
%t10105 = call i64 @st64(i64 %t10104, i64 %p1)
br label %L3093
L3092:
br label %L3093
L3093:
%t10106 = phi i64 [ %t10105, %L3091 ], [ 0, %L3092 ]
%t10107 = call i64 @__mruntime_rt_map_resid__b_vk()
%t10108 = sub nsw i64 0, 1
%t10109 = icmp eq i64 %t10107, %t10108
br i1 %t10109, label %L3094, label %L3095
L3094:
%t10110 = call i64 @__mruntime_rt_map_resid__base_w()
%t10111 = add i64 %t10110, 16
%t10112 = call i64 @st64(i64 %t10111, i64 %p3)
br label %L3096
L3095:
br label %L3096
L3096:
%t10113 = phi i64 [ %t10112, %L3094 ], [ 0, %L3095 ]
%t10114 = call i64 @__mruntime_rt_map_resid__b_kk()
%t10115 = call i1 @__mruntime_rt_map_resid__word_in(i64 %t10114, i64 %p1, i64 %p2)
br i1 %t10115, label %L3097, label %L3098
L3097:
%t10116 = call i64 @__mruntime_rt_map_resid__mret()
%t10117 = call i64 @ld64(i64 %t10116)
br label %L3099
L3098:
%t10118 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10119 = call i64 @__mruntime_rt_map_resid__base_boxed(i64 %t10118, i1 true, i1 false)
%t10120 = mul nsw i64 %t10119, 0
%t10121 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
%t10122 = add nsw i64 %t10120, %t10121
br label %L3099
L3099:
%t10123 = phi i64 [ %t10117, %L3097 ], [ %t10122, %L3098 ]
%t10124 = call i64 @__mruntime_rt_map_resid__b_vk()
%t10125 = call i1 @__mruntime_rt_map_resid__word_in(i64 %t10124, i64 %p3, i64 %p4)
br i1 %t10125, label %L3100, label %L3101
L3100:
%t10126 = call i64 @__mruntime_rt_map_resid__mret()
%t10127 = call i64 @ld64(i64 %t10126)
br label %L3102
L3101:
%t10128 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10129 = call i64 @__mruntime_rt_map_resid__base_boxed(i64 %t10128, i1 false, i1 true)
%t10130 = mul nsw i64 %t10129, 0
%t10131 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p3, i64 %p4)
%t10132 = add nsw i64 %t10130, %t10131
br label %L3102
L3102:
%t10133 = phi i64 [ %t10127, %L3100 ], [ %t10132, %L3101 ]
%t10134 = call i64 @__mruntime_rt_map_resid__b_kk()
%t10135 = call i64 @__mruntime_rt_map_resid__b_vk()
%t10136 = call i64 @__mruntime_rt_map_resid__b_root()
%t10137 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %t10134, i64 %t10123)
%t10138 = call i64 @__mruntime_rt_map_resid__hn_insert(i64 %t10136, i64 0, i64 %t10137, i64 %t10134, i64 %t10123, i64 %t10133, i64 0)
%t10139 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10140 = call i64 @__mruntime_rt_map_resid__mflag()
%t10141 = call i64 @ld64(i64 %t10140)
%t10142 = add i64 %t10139, %t10141
%t10143 = call i64 @__mruntime_rt_map_resid__trie_new(i64 %t10142, i64 %t10138, i64 %t10134, i64 %t10135)
ret i64 %t10143
}
define internal i1 @__mruntime_rt_map_resid__key_lookup_word(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10144 = icmp eq i64 %p0, %p1
br i1 %t10144, label %L3103, label %L3105
L3103:
%t10145 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %p2)
%t10146 = icmp ne i64 %t10145, 0
ret i1 %t10146
L3105:
%t10147 = icmp eq i64 %p0, 0
br i1 %t10147, label %L3106, label %L3108
L3106:
%t10148 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
%t10149 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t10148)
%t10150 = icmp ne i64 %t10149, 0
ret i1 %t10150
L3108:
%t10151 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %p0, i64 %p2)
ret i1 %t10151
}
define internal i64 @__mruntime_rt_map_resid__map_remove_p(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10152 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10153 = icmp eq i64 %t10152, 0
br label %LSL10154
LSL10154:
br i1 %t10153, label %LSJ10154, label %LSR10154
LSR10154:
%t10155 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t10156 = call i1 @__mruntime_rt_map_resid__key_lookup_word(i64 %t10155, i64 %p1, i64 %p2)
%t10157 = xor i1 %t10156, true
br label %LSJ10154
LSJ10154:
%t10158 = phi i1 [ true, %LSL10154 ], [ %t10157, %LSR10154 ]
br i1 %t10158, label %L3109, label %L3111
L3109:
%t10159 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
%t10160 = xor i1 %t10159, true
br i1 %t10160, label %L3112, label %L3114
L3112:
ret i64 %p0
L3114:
%t10161 = call i64 @__mruntime_rt_map_resid__map_base(i64 %p0)
%t10162 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10163 = call i64 @__mruntime_rt_map_resid__b_root()
%t10164 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t10165 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10166 = call i64 @__mruntime_rt_map_resid__trie_new(i64 %t10162, i64 %t10163, i64 %t10164, i64 %t10165)
ret i64 %t10166
L3111:
%t10167 = call i64 @__mruntime_rt_map_resid__mret()
%t10168 = call i64 @ld64(i64 %t10167)
%t10169 = call i64 @__mruntime_rt_map_resid__map_base(i64 %p0)
%t10170 = call i64 @__mruntime_rt_map_resid__b_kk()
%t10171 = call i64 @__mruntime_rt_map_resid__b_vk()
%t10172 = call i64 @__mruntime_rt_map_resid__b_root()
%t10173 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %t10170, i64 %t10168)
%t10174 = call i64 @__mruntime_rt_map_resid__hn_remove(i64 %t10172, i64 0, i64 %t10173, i64 %t10170, i64 %t10168, i64 0)
%t10175 = call i64 @__mruntime_rt_map_resid__mflag()
%t10176 = call i64 @ld64(i64 %t10175)
%t10177 = icmp eq i64 %t10176, 0
br i1 %t10177, label %L3115, label %L3117
L3115:
%t10178 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
br i1 %t10178, label %L3118, label %L3119
L3118:
%t10179 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10180 = call i64 @__mruntime_rt_map_resid__trie_new(i64 %t10179, i64 %t10172, i64 %t10170, i64 %t10171)
br label %L3120
L3119:
br label %L3120
L3120:
%t10181 = phi i64 [ %t10180, %L3118 ], [ %p0, %L3119 ]
ret i64 %t10181
L3117:
%t10182 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10183 = sub i64 %t10182, 1
%t10184 = call i64 @__mruntime_rt_map_resid__trie_new(i64 %t10183, i64 %t10174, i64 %t10170, i64 %t10171)
ret i64 %t10184
}
define internal i64 @__mruntime_rt_map_resid__own_w() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10185p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_own)
%t10185 = ptrtoint ptr %t10185p to i64
ret i64 %t10185
}
define internal i64 @__mruntime_rt_map_resid__new_own() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10186 = call i64 @__mruntime_rt_map_resid__own_w()
%t10187 = call i64 @ld64(i64 %t10186)
%t10188 = add i64 %t10186, 8
%t10189 = call i64 @ld64(i64 %t10188)
%t10190 = icmp eq i64 %t10187, %t10189
br i1 %t10190, label %L3121, label %L3122
L3121:
%t10191 = call i64 @__mruntime_rt_map_resid__own_block(i64 %t10186)
br label %L3123
L3122:
br label %L3123
L3123:
%t10192 = phi i64 [ %t10191, %L3121 ], [ 0, %L3122 ]
%t10193 = call i64 @ld64(i64 %t10186)
%t10194 = icmp sgt i64 %t10193, 4294967295
br i1 %t10194, label %L3124, label %L3126
L3124:
ret i64 0
L3126:
%t10195 = add nsw i64 %t10193, 1
%t10196 = call i64 @st64(i64 %t10186, i64 %t10195)
%t10197 = mul nsw i64 %t10196, 0
%t10198 = add nsw i64 %t10197, %t10193
ret i64 %t10198
}
define internal i64 @__mruntime_rt_map_resid__own_block(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10199p = getelementptr i8, ptr @rtg.map_own_seq, i64 0
%t10199 = ptrtoint ptr %t10199p to i64
%t10200p = inttoptr i64 %t10199 to ptr
%t10200 = atomicrmw add ptr %t10200p, i64 65536 seq_cst
%t10201 = add i64 %t10200, 1
%t10202 = call i64 @st64(i64 %p0, i64 %t10201)
%t10203 = add i64 %p0, 8
%t10204 = add i64 %t10201, 65535
%t10205 = call i64 @st64(i64 %t10203, i64 %t10204)
ret i64 %t10205
}
define internal i64 @__mruntime_rt_map_resid__map_vref(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10206 = call i64 @__mruntime_rt_map_resid__map_exit(i64 %p0)
%t10207 = tail call i64 @__mruntime_rt_map_resid__map_vref_raw(i64 %p0, i64 %p1, i64 %p2)
ret i64 %t10207
}
define internal i64 @__mruntime_rt_map_resid__map_vref_raw(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10208 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10209 = icmp eq i64 %t10208, 0
br i1 %t10209, label %L3127, label %L3129
L3127:
ret i64 0
L3129:
%t10210 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10211 = icmp ne i64 %t10210, 0
br i1 %t10211, label %L3130, label %L3132
L3130:
%t10212 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10213 = tail call i64 @__mruntime_rt_map_resid__t_vref(i64 %t10212, i64 %p1, i64 %p2)
ret i64 %t10213
L3132:
%t10214 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10215 = call i1 @__mruntime_rt_map_resid__key_lookup_word(i64 %t10214, i64 %p1, i64 %p2)
%t10216 = xor i1 %t10215, true
br i1 %t10216, label %L3133, label %L3135
L3133:
ret i64 0
L3135:
%t10217 = call i64 @__mruntime_rt_map_resid__mret()
%t10218 = call i64 @ld64(i64 %t10217)
%t10219 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t10220 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10221 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %t10220, i64 %t10218)
%t10222 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10223 = call i64 @__mruntime_rt_map_resid__hn_find(i64 %t10219, i64 %t10221, i64 %t10222, i64 %t10218, i64 0)
ret i64 %t10223
}
define internal i64 @rt_map_transient(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10224 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10225 = icmp sgt i64 %t10224, 64
br label %LSL10226
LSL10226:
br i1 %t10225, label %LSR10226, label %LSJ10226
LSR10226:
%t10227 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
%t10228 = xor i1 %t10227, true
br label %LSJ10226
LSJ10226:
%t10229 = phi i1 [ false, %LSL10226 ], [ %t10228, %LSR10226 ]
br i1 %t10229, label %L3136, label %L3138
L3136:
%t10230 = call i64 @__mruntime_rt_map_resid__map_root(i64 %p0)
%t10231 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t10232 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10233 = call i64 @__mruntime_rt_map_resid__trie_new(i64 %t10224, i64 %t10230, i64 %t10231, i64 %t10232)
%t10234 = add i64 %t10233, 24
%t10235 = call i64 @st64(i64 %t10234, i64 1)
%t10236 = add i64 %t10233, 32
%t10237 = call i64 @__mruntime_rt_map_resid__new_edit()
%t10238 = call i64 @st64(i64 %t10236, i64 %t10237)
%t10239 = add i64 %t10235, %t10238
%t10240 = add i64 %t10233, 40
%t10241 = call i64 @__mruntime_rt_map_resid__new_own()
%t10242 = call i64 @st32(i64 %t10240, i64 %t10241)
%t10243 = mul nsw i64 %t10242, 0
%t10244 = add nsw i64 %t10243, %t10233
ret i64 %t10244
L3138:
%t10245 = call i64 @__mruntime_rt_map_resid__map_exit(i64 %p0)
%t10246 = sub nsw i64 0, 1
%t10247 = sub nsw i64 0, 1
%t10248 = call i64 @__mruntime_rt_map_resid__trie_new(i64 %t10224, i64 0, i64 %t10246, i64 %t10247)
%t10249 = add i64 %t10248, 24
%t10250 = call i64 @st64(i64 %t10249, i64 1)
%t10251 = add i64 %t10248, 40
%t10252 = call i64 @__mruntime_rt_map_resid__new_own()
%t10253 = call i64 @st32(i64 %t10251, i64 %t10252)
%t10254 = add i64 %t10250, %t10253
%t10255 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10256 = icmp ne i64 %t10255, 0
br i1 %t10256, label %L3139, label %L3141
L3139:
%t10257 = add i64 %t10248, 16
%t10258 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10259 = call i64 @__mruntime_rt_map_resid__copy_tab(i64 %t10258)
%t10260 = call i64 @st64(i64 %t10257, i64 %t10259)
%t10261 = mul nsw i64 %t10260, 0
%t10262 = add nsw i64 %t10261, %t10248
ret i64 %t10262
L3141:
%t10263 = call i64 @__mruntime_rt_map_resid__cap_for(i64 %t10224)
%t10264 = sub nsw i64 0, 1
%t10265 = sub nsw i64 0, 1
%t10266 = call i64 @__mruntime_rt_map_resid__tab_new(i64 %t10263, i64 %t10264, i64 %t10265, i1 false)
%t10267 = add i64 %t10248, 16
%t10268 = call i64 @st64(i64 %t10267, i64 %t10266)
%t10269 = icmp eq i64 %t10224, 0
br i1 %t10269, label %L3142, label %L3144
L3142:
ret i64 %t10248
L3144:
%t10270 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t10224)
%t10271 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t10224)
%t10272 = call i64 @__mruntime_rt_map_resid__map_entries(i64 %p0, i64 %t10270, i64 %t10271)
%t10273 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10274 = call i64 @__mruntime_rt_map_resid__mvk(i64 %p0)
%t10275 = call i64 @__mruntime_rt_map_resid__put_all(i64 %t10266, i64 %t10273, i64 %t10274, i64 %t10270, i64 %t10271, i64 0, i64 %t10224)
%t10276 = call i64 @c_free(i64 %t10270)
%t10277 = call i64 @c_free(i64 %t10271)
%t10278 = add i64 %t10276, %t10277
ret i64 %t10248
}
define ptr @resid_map_transient(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_map_transient(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_map_resid__copy_tab(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10279 = call i64 @__mruntime_rt_map_resid__map_obj(i64 96)
%t10280 = call i64 @mcopy(i64 %t10279, i64 %p0, i64 96)
%t10281 = add i64 %t10279, 72
%t10282 = call i64 @st8(i64 %t10281, i64 0)
%t10283 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t10284 = icmp eq i64 %t10283, 0
br i1 %t10284, label %L3145, label %L3147
L3145:
ret i64 %t10279
L3147:
%t10285 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t10286 = mul i64 %t10285, 8
%t10287 = call i64 @__mruntime_rt_map_resid__map_obj(i64 %t10286)
%t10288 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t10289 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t10290 = mul i64 %t10289, 8
%t10291 = call i64 @mcopy(i64 %t10287, i64 %t10288, i64 %t10290)
%t10292 = add i64 %t10279, 32
%t10293 = call i64 @st64(i64 %t10292, i64 %t10287)
%t10294 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t10295 = icmp eq i64 %t10294, 0
br i1 %t10295, label %L3148, label %L3150
L3148:
ret i64 %t10279
L3150:
%t10296 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t10297 = mul i64 %t10296, 8
%t10298 = call i64 @__mruntime_rt_map_resid__map_obj(i64 %t10297)
%t10299 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t10300 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t10301 = mul i64 %t10300, 8
%t10302 = call i64 @mcopy(i64 %t10298, i64 %t10299, i64 %t10301)
%t10303 = add i64 %t10279, 40
%t10304 = call i64 @st64(i64 %t10303, i64 %t10298)
%t10305 = mul nsw i64 %t10304, 0
%t10306 = add nsw i64 %t10305, %t10279
ret i64 %t10306
}
define internal i64 @__mruntime_rt_map_resid__put_all(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t10315, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ]
%t10307 = icmp sge i64 %p5, %p6
br i1 %t10307, label %L3151, label %L3153
L3151:
ret i64 0
L3153:
%t10308 = mul i64 %p5, 8
%t10309 = add i64 %p3, %t10308
%t10310 = call i64 @ld64(i64 %t10309)
%t10311 = mul i64 %p5, 8
%t10312 = add i64 %p4, %t10311
%t10313 = call i64 @ld64(i64 %t10312)
%t10314 = call i64 @__mruntime_rt_map_resid__t_put(i64 %p0, i64 %p1, i64 %t10310, i64 %p2, i64 %t10313)
%t10315 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_map_freeze(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10317 = add i64 %p0, 24
%t10318 = call i64 @st64(i64 %t10317, i64 0)
%t10319 = mul nsw i64 %t10318, 0
%t10320 = add nsw i64 %t10319, %p0
ret i64 %t10320
}
define ptr @resid_map_freeze(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_map_freeze(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_map_resid__trie_put_owned(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10321 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10322 = icmp eq i64 %t10321, 0
br i1 %t10322, label %L3154, label %L3155
L3154:
%t10323 = add i64 %p0, 44
%t10324 = call i64 @st8(i64 %t10323, i64 %p1)
%t10325 = add i64 %p0, 45
%t10326 = call i64 @st8(i64 %t10325, i64 %p3)
%t10327 = add i64 %t10324, %t10326
br label %L3156
L3155:
br label %L3156
L3156:
%t10328 = phi i64 [ %t10327, %L3154 ], [ 0, %L3155 ]
%t10329 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10330 = call i1 @__mruntime_rt_map_resid__word_in(i64 %t10329, i64 %p1, i64 %p2)
%t10331 = call i64 @__mruntime_rt_map_resid__mret()
%t10332 = call i64 @ld64(i64 %t10331)
br label %LSL10333
LSL10333:
br i1 %t10330, label %LSR10333, label %LSJ10333
LSR10333:
%t10334 = call i64 @__mruntime_rt_map_resid__mvk(i64 %p0)
%t10335 = call i1 @__mruntime_rt_map_resid__word_in(i64 %t10334, i64 %p3, i64 %p4)
br label %LSJ10333
LSJ10333:
%t10336 = phi i1 [ false, %LSL10333 ], [ %t10335, %LSR10333 ]
%t10337 = call i64 @__mruntime_rt_map_resid__mret()
%t10338 = call i64 @ld64(i64 %t10337)
%t10339 = xor i1 %t10330, true
br label %LSL10340
LSL10340:
br i1 %t10339, label %LSJ10340, label %LSR10340
LSR10340:
%t10341 = xor i1 %t10336, true
br label %LSJ10340
LSJ10340:
%t10342 = phi i1 [ true, %LSL10340 ], [ %t10341, %LSR10340 ]
br i1 %t10342, label %L3157, label %L3159
L3157:
%t10343 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t10344 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10345 = call i64 @__mruntime_rt_map_resid__mvk(i64 %p0)
%t10346 = call i64 @__mruntime_rt_map_resid__base_set(i64 %t10343, i64 %t10344, i64 %t10345)
%t10347 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10348 = call i64 @__mruntime_rt_map_resid__base_boxed(i64 %t10347, i1 true, i1 true)
%t10349 = add i64 %p0, 8
%t10350 = call i64 @__mruntime_rt_map_resid__b_root()
%t10351 = call i64 @st64(i64 %t10349, i64 %t10350)
%t10352 = add i64 %p0, 44
%t10353 = call i64 @st8(i64 %t10352, i64 0)
%t10354 = add i64 %t10351, %t10353
%t10355 = add i64 %p0, 45
%t10356 = call i64 @st8(i64 %t10355, i64 0)
%t10357 = add i64 %t10354, %t10356
%t10358 = add i64 %p0, 32
%t10359 = call i64 @__mruntime_rt_map_resid__new_edit()
%t10360 = call i64 @st64(i64 %t10358, i64 %t10359)
%t10361 = add i64 %t10357, %t10360
%t10362 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
%t10363 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p3, i64 %p4)
%t10364 = call i64 @__mruntime_rt_map_resid__trie_put_at(i64 %p0, i64 %t10362, i64 %t10363)
ret i64 %t10364
L3159:
%t10365 = call i64 @__mruntime_rt_map_resid__trie_put_at(i64 %p0, i64 %t10332, i64 %t10338)
ret i64 %t10365
}
define internal i64 @__mruntime_rt_map_resid__trie_put_at(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10366 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t10367 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10368 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %t10367, i64 %p1)
%t10369 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10370 = call i64 @__mruntime_rt_map_resid__medit(i64 %p0)
%t10371 = call i64 @__mruntime_rt_map_resid__hn_insert(i64 %t10366, i64 0, i64 %t10368, i64 %t10369, i64 %p1, i64 %p2, i64 %t10370)
%t10372 = add i64 %p0, 8
%t10373 = call i64 @st64(i64 %t10372, i64 %t10371)
%t10374 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10375 = call i64 @__mruntime_rt_map_resid__mflag()
%t10376 = call i64 @ld64(i64 %t10375)
%t10377 = add i64 %t10374, %t10376
%t10378 = call i64 @st64(i64 %p0, i64 %t10377)
%t10379 = mul nsw i64 %t10378, 0
%t10380 = add nsw i64 %t10379, %p0
ret i64 %t10380
}
define internal i64 @__mruntime_rt_map_resid__map_put_slow(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10381 = icmp eq i64 %p2, 4
br i1 %t10381, label %L3160, label %L3161
L3160:
br label %L3162
L3161:
br label %L3162
L3162:
%t10382 = phi i64 [ 1, %L3160 ], [ 0, %L3161 ]
%t10383 = icmp eq i64 %p2, 4
br i1 %t10383, label %L3163, label %L3164
L3163:
br label %L3165
L3164:
br label %L3165
L3165:
%t10384 = phi i64 [ 0, %L3163 ], [ %p2, %L3164 ]
%t10385 = icmp eq i64 %p4, 4
br label %LSL10386
LSL10386:
br i1 %t10385, label %LSJ10386, label %LSR10386
LSR10386:
%t10387 = icmp eq i64 %p4, 5
br label %LSJ10386
LSJ10386:
%t10388 = phi i1 [ true, %LSL10386 ], [ %t10387, %LSR10386 ]
br i1 %t10388, label %L3166, label %L3167
L3166:
br label %L3168
L3167:
br label %L3168
L3168:
%t10389 = phi i64 [ %p4, %L3166 ], [ 0, %L3167 ]
%t10390 = icmp eq i64 %p4, 4
br label %LSL10391
LSL10391:
br i1 %t10390, label %LSJ10391, label %LSR10391
LSR10391:
%t10392 = icmp eq i64 %p4, 5
br label %LSJ10391
LSJ10391:
%t10393 = phi i1 [ true, %LSL10391 ], [ %t10392, %LSR10391 ]
br i1 %t10393, label %L3169, label %L3170
L3169:
br label %L3171
L3170:
br label %L3171
L3171:
%t10394 = phi i64 [ 0, %L3169 ], [ %p4, %L3170 ]
%t10395 = icmp ne i64 %p1, 0
br label %LSL10396
LSL10396:
br i1 %t10395, label %LSR10396, label %LSJ10396
LSR10396:
%t10397 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
%t10398 = xor i1 %t10397, true
br label %LSJ10396
LSJ10396:
%t10399 = phi i1 [ false, %LSL10396 ], [ %t10398, %LSR10396 ]
br i1 %t10399, label %L3172, label %L3173
L3172:
%t10400 = call i64 @rt_map_transient(i64 %p0)
br label %L3174
L3173:
br label %L3174
L3174:
%t10401 = phi i64 [ %t10400, %L3172 ], [ %p0, %L3173 ]
%t10402 = icmp ne i64 %p1, 0
br label %LSL10403
LSL10403:
br i1 %t10402, label %LSR10403, label %LSJ10403
LSR10403:
%t10404 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %t10401)
br label %LSJ10403
LSJ10403:
%t10405 = phi i1 [ false, %LSL10403 ], [ %t10404, %LSR10403 ]
br i1 %t10405, label %L3175, label %L3177
L3175:
%t10406 = call i64 @__mruntime_rt_map_resid__map_heap_w()
%t10407 = call i64 @ld64(i64 %t10406)
%t10408 = call i64 @__mruntime_rt_map_resid__map_heap_w()
%t10409 = call i1 @__mruntime_rt_map_resid__in_region(i64 %t10401)
br i1 %t10409, label %L3178, label %L3179
L3178:
br label %L3180
L3179:
br label %L3180
L3180:
%t10410 = phi i64 [ 0, %L3178 ], [ 1, %L3179 ]
%t10411 = call i64 @st64(i64 %t10408, i64 %t10410)
%t10412 = call i64 @__mruntime_rt_map_resid__mtab(i64 %t10401)
%t10413 = icmp ne i64 %t10412, 0
br i1 %t10413, label %L3181, label %L3182
L3181:
%t10414 = call i64 @__mruntime_rt_map_resid__tab_put_owned(i64 %t10401, i64 %t10384, i64 %p3, i64 %t10394, i64 %p5, i64 %t10382, i64 %t10389)
br label %L3183
L3182:
%t10415 = icmp ne i64 %t10382, 0
br i1 %t10415, label %L3184, label %L3185
L3184:
br label %L3186
L3185:
br label %L3186
L3186:
%t10416 = phi i64 [ 4, %L3184 ], [ 0, %L3185 ]
%t10417 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %t10416, i64 %p3)
%t10418 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %t10389, i64 %p5)
%t10419 = call i64 @__mruntime_rt_map_resid__trie_put_owned(i64 %t10401, i64 %t10384, i64 %t10417, i64 %t10394, i64 %t10418)
br label %L3183
L3183:
%t10420 = phi i64 [ %t10414, %L3181 ], [ %t10419, %L3186 ]
%t10421 = call i64 @__mruntime_rt_map_resid__map_heap_w()
%t10422 = call i64 @st64(i64 %t10421, i64 %t10407)
%t10423 = mul nsw i64 %t10422, 0
%t10424 = add nsw i64 %t10423, %t10401
ret i64 %t10424
L3177:
%t10425 = icmp ne i64 %t10382, 0
br i1 %t10425, label %L3187, label %L3188
L3187:
br label %L3189
L3188:
br label %L3189
L3189:
%t10426 = phi i64 [ 4, %L3187 ], [ 0, %L3188 ]
%t10427 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %t10426, i64 %p3)
%t10428 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %t10389, i64 %p5)
%t10429 = call i64 @__mruntime_rt_map_resid__map_insert_p(i64 %t10401, i64 %t10384, i64 %t10427, i64 %t10394, i64 %t10428)
ret i64 %t10429
}
define internal i64 @__mruntime_rt_map_resid__tab_put_owned(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10430 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10431 = add i64 %t10430, 72
%t10432 = call i64 @st8(i64 %t10431, i64 0)
%t10433 = call i64 @__mruntime_rt_map_resid__t_put_s(i64 %t10430, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6)
%t10434 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t10430)
%t10435 = call i64 @st64(i64 %p0, i64 %t10434)
ret i64 %t10435
}
define internal i64 @rt_map_put(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10436 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10437 = icmp ne i64 %p1, 0
br label %LSL10438
LSL10438:
br i1 %t10437, label %LSR10438, label %LSJ10438
LSR10438:
%t10439 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
br label %LSJ10438
LSJ10438:
%t10440 = phi i1 [ false, %LSL10438 ], [ %t10439, %LSR10438 ]
br label %LSL10441
LSL10441:
br i1 %t10440, label %LSR10441, label %LSJ10441
LSR10441:
%t10442 = icmp ne i64 %t10436, 0
br label %LSJ10441
LSJ10441:
%t10443 = phi i1 [ false, %LSL10441 ], [ %t10442, %LSR10441 ]
br label %LSL10444
LSL10444:
br i1 %t10443, label %LSR10444, label %LSJ10444
LSR10444:
%t10445 = icmp eq i64 %p2, 1
br label %LSJ10444
LSJ10444:
%t10446 = phi i1 [ false, %LSL10444 ], [ %t10445, %LSR10444 ]
br label %LSL10447
LSL10447:
br i1 %t10446, label %LSR10447, label %LSJ10447
LSR10447:
%t10448 = call i64 @__mruntime_rt_map_resid__tkk(i64 %t10436)
%t10449 = icmp eq i64 %t10448, 1
br label %LSJ10447
LSJ10447:
%t10450 = phi i1 [ false, %LSL10447 ], [ %t10449, %LSR10447 ]
br label %LSL10451
LSL10451:
br i1 %t10450, label %LSR10451, label %LSJ10451
LSR10451:
%t10452 = call i64 @__mruntime_rt_map_resid__tvk(i64 %t10436)
%t10453 = icmp eq i64 %t10452, %p4
br label %LSJ10451
LSJ10451:
%t10454 = phi i1 [ false, %LSL10451 ], [ %t10453, %LSR10451 ]
br label %LSL10455
LSL10455:
br i1 %t10454, label %LSR10455, label %LSJ10455
LSR10455:
%t10456 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t10436)
%t10457 = icmp ne i64 %t10456, 0
br label %LSL10458
LSL10458:
br i1 %t10457, label %LSJ10458, label %LSR10458
LSR10458:
%t10459 = icmp eq i64 %p5, 1
br label %LSJ10458
LSJ10458:
%t10460 = phi i1 [ true, %LSL10458 ], [ %t10459, %LSR10458 ]
br label %LSJ10455
LSJ10455:
%t10461 = phi i1 [ false, %LSL10455 ], [ %t10460, %LSJ10458 ]
br label %LSL10462
LSL10462:
br i1 %t10461, label %LSR10462, label %LSJ10462
LSR10462:
%t10463 = call i64 @lshr(i64 %p3, i64 1)
%t10464 = call i64 @__mruntime_rt_map_resid__raw_empty()
%t10465 = call i64 @lshr(i64 %t10464, i64 1)
%t10466 = icmp ne i64 %t10463, %t10465
br label %LSJ10462
LSJ10462:
%t10467 = phi i1 [ false, %LSL10462 ], [ %t10466, %LSR10462 ]
br i1 %t10467, label %L3190, label %L3192
L3190:
%t10468 = call i64 @__mruntime_rt_map_resid__probe_raw_cached(i64 %t10436, i64 %p3)
%t10469 = icmp sge i64 %t10468, 0
br i1 %t10469, label %L3193, label %L3195
L3193:
%t10470 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t10436)
%t10471 = icmp ne i64 %t10470, 0
br i1 %t10471, label %L3196, label %L3197
L3196:
%t10472 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t10436)
%t10473 = mul i64 %t10468, 8
%t10474 = add i64 %t10472, %t10473
%t10475 = call i64 @st64(i64 %t10474, i64 %p5)
br label %L3198
L3197:
br label %L3198
L3198:
%t10476 = phi i64 [ %t10475, %L3196 ], [ 0, %L3197 ]
%t10477 = mul nsw i64 %t10476, 0
%t10478 = add nsw i64 %t10477, %p0
ret i64 %t10478
L3195:
%t10479 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t10436)
%t10480 = call i64 @__mruntime_rt_map_resid__ttombs(i64 %t10436)
%t10481 = add i64 %t10479, %t10480
%t10482 = add i64 %t10481, 1
%t10483 = call i64 @__mruntime_rt_map_resid__tcap(i64 %t10436)
%t10484 = call i1 @__mruntime_rt_map_resid__t_over(i64 %t10482, i64 %t10483)
%t10485 = xor i1 %t10484, true
br i1 %t10485, label %L3199, label %L3201
L3199:
%t10486 = sub i64 0, %t10468
%t10487 = sub nsw i64 %t10486, 1
%t10488 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %t10436)
%t10489 = mul i64 %t10487, 8
%t10490 = add i64 %t10488, %t10489
%t10491 = call i64 @st64(i64 %t10490, i64 %p3)
%t10492 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t10436)
%t10493 = icmp ne i64 %t10492, 0
br i1 %t10493, label %L3202, label %L3203
L3202:
%t10494 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t10436)
%t10495 = mul i64 %t10487, 8
%t10496 = add i64 %t10494, %t10495
%t10497 = call i64 @st64(i64 %t10496, i64 %p5)
br label %L3204
L3203:
br label %L3204
L3204:
%t10498 = phi i64 [ %t10497, %L3202 ], [ 0, %L3203 ]
%t10499 = add i64 %t10436, 8
%t10500 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t10436)
%t10501 = add i64 %t10500, 1
%t10502 = call i64 @st64(i64 %t10499, i64 %t10501)
%t10503 = add i64 %t10436, 88
%t10504 = call i64 @st64(i64 %t10503, i64 %t10487)
%t10505 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t10436)
%t10506 = call i64 @st64(i64 %p0, i64 %t10505)
%t10507 = mul nsw i64 %t10506, 0
%t10508 = add nsw i64 %t10507, %p0
ret i64 %t10508
L3201:
br label %L3192
L3192:
%t10509 = tail call i64 @__mruntime_rt_map_resid__map_put_slow(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5)
ret i64 %t10509
}
define ptr @resid_map_put(ptr %a0, i8 %a1, i8 %a2, i64 %a3, i8 %a4, i64 %a5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1 = zext i8 %a1 to i64
%x2 = zext i8 %a2 to i64
%x4 = zext i8 %a4 to i64
%r = call i64 @rt_map_put(i64 %x0i, i64 %x1, i64 %x2, i64 %a3, i64 %x4, i64 %a5)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_map_resid__elem_keep(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10510 = icmp eq i64 %p0, 0
br label %LSL10511
LSL10511:
br i1 %t10510, label %LSJ10511, label %LSR10511
LSR10511:
%t10512 = call i1 @ult(i64 %p0, i64 4096)
br label %LSJ10511
LSJ10511:
%t10513 = phi i1 [ true, %LSL10511 ], [ %t10512, %LSR10511 ]
br label %LSL10514
LSL10514:
br i1 %t10513, label %LSJ10514, label %LSR10514
LSR10514:
%t10515 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t10516 = xor i1 %t10515, true
br label %LSJ10514
LSJ10514:
%t10517 = phi i1 [ true, %LSL10514 ], [ %t10516, %LSR10514 ]
br i1 %t10517, label %L3205, label %L3207
L3205:
ret i64 %p0
L3207:
%t10518 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p0)
%t10519 = xor i1 %t10518, true
br i1 %t10519, label %L3208, label %L3210
L3208:
%t10520 = tail call i64 @rt_str_keep(i64 %p0)
ret i64 %t10520
L3210:
%t10521 = call i64 @__mruntime_rt_map_resid__word_of_box(i64 %p0, i1 false)
%t10522 = icmp eq i64 %t10521, 0
br i1 %t10522, label %L3211, label %L3213
L3211:
ret i64 %p0
L3213:
%t10523 = call i64 @__mruntime_rt_map_resid__mret()
%t10524 = call i64 @ld64(i64 %t10523)
%t10525 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t10526 = call i64 @c_sc_depth_set(i64 0)
%t10527 = call i64 @__mruntime_rt_map_resid__box_any(i64 %t10521, i64 %t10524)
%t10528 = call i64 @c_sc_depth_set(i64 %t10525)
%t10529 = mul nsw i64 %t10528, 0
%t10530 = add nsw i64 %t10529, %t10527
ret i64 %t10530
}
define internal i64 @rt_map_list_push(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10531 = icmp eq i64 %p2, 4
br i1 %t10531, label %L3214, label %L3215
L3214:
br label %L3216
L3215:
br label %L3216
L3216:
%t10532 = phi i64 [ 0, %L3214 ], [ %p2, %L3215 ]
%t10533 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t10534 = xor i1 %t10533, true
%t10535 = icmp ne i64 %p1, 0
br label %LSL10536
LSL10536:
br i1 %t10535, label %LSR10536, label %LSJ10536
LSR10536:
%t10537 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
br label %LSJ10536
LSJ10536:
%t10538 = phi i1 [ false, %LSL10536 ], [ %t10537, %LSR10536 ]
br label %LSL10539
LSL10539:
br i1 %t10538, label %LSR10539, label %LSJ10539
LSR10539:
%t10540 = call i64 @__mruntime_rt_map_resid__mown(i64 %p0)
%t10541 = icmp ne i64 %t10540, 0
br label %LSJ10539
LSJ10539:
%t10542 = phi i1 [ false, %LSL10539 ], [ %t10541, %LSR10539 ]
br i1 %t10542, label %L3217, label %L3219
L3217:
%t10543 = call i64 @__mruntime_rt_map_resid__map_vref_raw(i64 %p0, i64 %t10532, i64 %p3)
%t10544 = icmp ne i64 %t10543, 0
br i1 %t10544, label %L3220, label %L3221
L3220:
%t10545 = call i64 @ld64(i64 %t10543)
br label %L3222
L3221:
br label %L3222
L3222:
%t10546 = phi i64 [ %t10545, %L3220 ], [ 0, %L3221 ]
%t10547 = icmp ne i64 %t10546, 0
br label %LSL10548
LSL10548:
br i1 %t10547, label %LSR10548, label %LSJ10548
LSR10548:
%t10549 = add i64 %t10546, 12
%t10550 = call i64 @ld32(i64 %t10549)
%t10551 = call i64 @__mruntime_rt_map_resid__mown(i64 %p0)
%t10552 = icmp eq i64 %t10550, %t10551
br label %LSJ10548
LSJ10548:
%t10553 = phi i1 [ false, %LSL10548 ], [ %t10552, %LSR10548 ]
br i1 %t10553, label %L3223, label %L3225
L3223:
%t10554 = call i64 @__mruntime_rt_map_resid__sc_depth()
br i1 %t10534, label %L3226, label %L3227
L3226:
%t10555 = call i64 @__mruntime_rt_map_resid__elem_keep(i64 %p4)
br label %L3228
L3227:
br label %L3228
L3228:
%t10556 = phi i64 [ %t10555, %L3226 ], [ %p4, %L3227 ]
br i1 %t10534, label %L3229, label %L3230
L3229:
%t10557 = call i64 @c_sc_depth_set(i64 0)
br label %L3231
L3230:
br label %L3231
L3231:
%t10558 = phi i64 [ %t10557, %L3229 ], [ 0, %L3230 ]
%t10559p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_one_elem)
%t10559 = ptrtoint ptr %t10559p to i64
%t10560 = call i64 @st64(i64 %t10559, i64 %t10556)
%t10561 = call i64 @pvec_append_into(i64 %t10546, i64 %t10546, i64 %t10559, i64 1)
%t10562 = call i64 @c_sc_depth_set(i64 %t10554)
%t10563 = mul nsw i64 %t10562, 0
%t10564 = add nsw i64 %t10563, %p0
ret i64 %t10564
L3225:
br label %L3219
L3219:
%t10565 = call i64 @__mruntime_rt_map_resid__map_vref_raw(i64 %p0, i64 %t10532, i64 %p3)
%t10566 = icmp ne i64 %t10565, 0
br i1 %t10566, label %L3232, label %L3233
L3232:
%t10567 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10568 = call i64 @ld64(i64 %t10565)
%t10569 = call i64 @__mruntime_rt_map_resid__word_out(i64 %t10567, i64 0, i64 %t10568)
br label %L3234
L3233:
br label %L3234
L3234:
%t10570 = phi i64 [ %t10569, %L3232 ], [ %p5, %L3233 ]
%t10571 = call i64 @lcount(i64 %t10570)
%t10572 = icmp eq i64 %t10571, 0
br i1 %t10572, label %L3235, label %L3236
L3235:
%t10573 = icmp ne i64 %p1, 0
%t10574 = call i64 @__mruntime_rt_map_resid__fresh_list(i64 %t10570, i64 %p4, i1 %t10534, i1 %t10573)
br label %L3237
L3236:
%t10575 = call i64 @pvec_push(i64 %t10570, i64 %p4)
br label %L3237
L3237:
%t10576 = phi i64 [ %t10574, %L3235 ], [ %t10575, %L3236 ]
%t10577 = call i64 @rt_map_put(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 5, i64 %t10576)
%t10578 = icmp ne i64 %p1, 0
br label %LSL10579
LSL10579:
br i1 %t10578, label %LSR10579, label %LSJ10579
LSR10579:
%t10580 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %t10577)
br label %LSJ10579
LSJ10579:
%t10581 = phi i1 [ false, %LSL10579 ], [ %t10580, %LSR10579 ]
br label %LSL10582
LSL10582:
br i1 %t10581, label %LSR10582, label %LSJ10582
LSR10582:
%t10583 = call i64 @__mruntime_rt_map_resid__mown(i64 %t10577)
%t10584 = icmp ne i64 %t10583, 0
br label %LSJ10582
LSJ10582:
%t10585 = phi i1 [ false, %LSL10582 ], [ %t10584, %LSR10582 ]
br i1 %t10585, label %L3238, label %L3240
L3238:
%t10586 = call i64 @__mruntime_rt_map_resid__map_vref_raw(i64 %t10577, i64 %t10532, i64 %p3)
%t10587 = icmp ne i64 %t10586, 0
br i1 %t10587, label %L3241, label %L3242
L3241:
%t10588 = call i64 @ld64(i64 %t10586)
%t10589 = add i64 %t10588, 12
%t10590 = call i64 @__mruntime_rt_map_resid__mown(i64 %t10577)
%t10591 = call i64 @st32(i64 %t10589, i64 %t10590)
br label %L3243
L3242:
br label %L3243
L3243:
%t10592 = phi i64 [ %t10591, %L3241 ], [ 0, %L3242 ]
ret i64 %t10577
L3240:
ret i64 %t10577
}
define ptr @resid_map_list_push(ptr %a0, i8 %a1, i8 %a2, i64 %a3, ptr %a4, ptr %a5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1 = zext i8 %a1 to i64
%x2 = zext i8 %a2 to i64
%x4i = ptrtoint ptr %a4 to i64
%x5i = ptrtoint ptr %a5 to i64
%r = call i64 @rt_map_list_push(i64 %x0i, i64 %x1, i64 %x2, i64 %a3, i64 %x4i, i64 %x5i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_map_resid__fresh_list(i64 %p0, i64 %p1, i1 %p2, i1 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10593 = call i64 @__mruntime_rt_map_resid__sc_depth()
br label %LSL10594
LSL10594:
br i1 %p2, label %LSR10594, label %LSJ10594
LSR10594:
br label %LSJ10594
LSJ10594:
%t10595 = phi i1 [ false, %LSL10594 ], [ %p3, %LSR10594 ]
br i1 %t10595, label %L3244, label %L3245
L3244:
%t10596 = call i64 @c_sc_depth_set(i64 0)
br label %L3246
L3245:
br label %L3246
L3246:
%t10597 = phi i64 [ %t10596, %L3244 ], [ 0, %L3245 ]
%t10598 = call i64 @flat_new(i64 4)
%t10599 = add i64 %t10598, 24
br i1 %p2, label %L3247, label %L3248
L3247:
%t10600 = call i64 @__mruntime_rt_map_resid__elem_keep(i64 %p1)
br label %L3249
L3248:
br label %L3249
L3249:
%t10601 = phi i64 [ %t10600, %L3247 ], [ %p1, %L3248 ]
%t10602 = call i64 @st64(i64 %t10599, i64 %t10601)
%t10603 = call i64 @st64(i64 %t10598, i64 1)
%t10604 = call i64 @list_hdr()
%t10605 = call i64 @st64(i64 %t10604, i64 1)
%t10606 = add i64 %t10604, 8
%t10607 = sub nsw i64 0, 1
%t10608 = call i64 @st32(i64 %t10606, i64 %t10607)
%t10609 = add i64 %t10605, %t10608
%t10610 = add i64 %t10604, 16
%t10611 = call i64 @st64(i64 %t10610, i64 %t10598)
%t10612 = add i64 %t10609, %t10611
%t10613 = add i64 %t10604, 24
%t10614 = call i64 @ltype(i64 %p0)
%t10615 = call i64 @st64(i64 %t10613, i64 %t10614)
%t10616 = add i64 %t10612, %t10615
%t10617 = call i64 @c_sc_depth_set(i64 %t10593)
%t10618 = mul nsw i64 %t10617, 0
%t10619 = add nsw i64 %t10618, %t10604
ret i64 %t10619
}
define internal i64 @rt_map_del(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10620 = icmp eq i64 %p2, 4
br i1 %t10620, label %L3250, label %L3251
L3250:
br label %L3252
L3251:
br label %L3252
L3252:
%t10621 = phi i64 [ 0, %L3250 ], [ %p2, %L3251 ]
%t10622 = icmp ne i64 %p1, 0
br label %LSL10623
LSL10623:
br i1 %t10622, label %LSR10623, label %LSJ10623
LSR10623:
%t10624 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
%t10625 = xor i1 %t10624, true
br label %LSJ10623
LSJ10623:
%t10626 = phi i1 [ false, %LSL10623 ], [ %t10625, %LSR10623 ]
br label %LSL10627
LSL10627:
br i1 %t10626, label %LSR10627, label %LSJ10627
LSR10627:
%t10628 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10629 = icmp sgt i64 %t10628, 0
br label %LSJ10627
LSJ10627:
%t10630 = phi i1 [ false, %LSL10627 ], [ %t10629, %LSR10627 ]
br i1 %t10630, label %L3253, label %L3254
L3253:
%t10631 = call i64 @rt_map_transient(i64 %p0)
br label %L3255
L3254:
br label %L3255
L3255:
%t10632 = phi i64 [ %t10631, %L3253 ], [ %p0, %L3254 ]
%t10633 = icmp ne i64 %p1, 0
br label %LSL10634
LSL10634:
br i1 %t10633, label %LSR10634, label %LSJ10634
LSR10634:
%t10635 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %t10632)
br label %LSJ10634
LSJ10634:
%t10636 = phi i1 [ false, %LSL10634 ], [ %t10635, %LSR10634 ]
br label %LSL10637
LSL10637:
br i1 %t10636, label %LSR10637, label %LSJ10637
LSR10637:
%t10638 = call i64 @__mruntime_rt_map_resid__mtab(i64 %t10632)
%t10639 = icmp eq i64 %t10638, 0
br label %LSJ10637
LSJ10637:
%t10640 = phi i1 [ false, %LSL10637 ], [ %t10639, %LSR10637 ]
br i1 %t10640, label %L3256, label %L3258
L3256:
%t10641 = call i64 @__mruntime_rt_map_resid__map_heap_w()
%t10642 = call i64 @ld64(i64 %t10641)
%t10643 = call i64 @__mruntime_rt_map_resid__map_heap_w()
%t10644 = call i1 @__mruntime_rt_map_resid__in_region(i64 %t10632)
br i1 %t10644, label %L3259, label %L3260
L3259:
br label %L3261
L3260:
br label %L3261
L3261:
%t10645 = phi i64 [ 0, %L3259 ], [ 1, %L3260 ]
%t10646 = call i64 @st64(i64 %t10643, i64 %t10645)
%t10647 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t10632)
%t10648 = icmp sgt i64 %t10647, 0
br label %LSL10649
LSL10649:
br i1 %t10648, label %LSR10649, label %LSJ10649
LSR10649:
%t10650 = call i64 @__mruntime_rt_map_resid__mkk(i64 %t10632)
%t10651 = call i1 @__mruntime_rt_map_resid__key_lookup_word(i64 %t10650, i64 %t10621, i64 %p3)
br label %LSJ10649
LSJ10649:
%t10652 = phi i1 [ false, %LSL10649 ], [ %t10651, %LSR10649 ]
br i1 %t10652, label %L3262, label %L3263
L3262:
%t10653 = call i64 @__mruntime_rt_map_resid__mret()
%t10654 = call i64 @ld64(i64 %t10653)
%t10655 = call i64 @__mruntime_rt_map_resid__trie_del_at(i64 %t10632, i64 %t10654)
br label %L3264
L3263:
br label %L3264
L3264:
%t10656 = phi i64 [ %t10655, %L3262 ], [ 0, %L3263 ]
%t10657 = call i64 @__mruntime_rt_map_resid__map_heap_w()
%t10658 = call i64 @st64(i64 %t10657, i64 %t10642)
%t10659 = mul nsw i64 %t10658, 0
%t10660 = add nsw i64 %t10659, %t10632
ret i64 %t10660
L3258:
%t10661 = icmp ne i64 %p1, 0
br label %LSL10662
LSL10662:
br i1 %t10661, label %LSR10662, label %LSJ10662
LSR10662:
%t10663 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %t10632)
br label %LSJ10662
LSJ10662:
%t10664 = phi i1 [ false, %LSL10662 ], [ %t10663, %LSR10662 ]
br i1 %t10664, label %L3265, label %L3267
L3265:
%t10665 = call i64 @__mruntime_rt_map_resid__mtab(i64 %t10632)
%t10666 = call i1 @__mruntime_rt_map_resid__t_del(i64 %t10665, i64 %t10621, i64 %p3)
%t10667 = call i64 @__mruntime_rt_map_resid__mtab(i64 %t10632)
%t10668 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t10667)
%t10669 = call i64 @st64(i64 %t10632, i64 %t10668)
%t10670 = mul nsw i64 %t10669, 0
%t10671 = add nsw i64 %t10670, %t10632
ret i64 %t10671
L3267:
%t10672 = call i64 @__mruntime_rt_map_resid__map_remove_p(i64 %t10632, i64 %t10621, i64 %p3)
ret i64 %t10672
}
define ptr @resid_map_del(ptr %a0, i8 %a1, i8 %a2, i64 %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1 = zext i8 %a1 to i64
%x2 = zext i8 %a2 to i64
%r = call i64 @rt_map_del(i64 %x0i, i64 %x1, i64 %x2, i64 %a3)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_map_resid__trie_del_at(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10673 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t10674 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10675 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %t10674, i64 %p1)
%t10676 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10677 = call i64 @__mruntime_rt_map_resid__medit(i64 %p0)
%t10678 = call i64 @__mruntime_rt_map_resid__hn_remove(i64 %t10673, i64 0, i64 %t10675, i64 %t10676, i64 %p1, i64 %t10677)
%t10679 = add i64 %p0, 8
%t10680 = call i64 @st64(i64 %t10679, i64 %t10678)
%t10681 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10682 = call i64 @__mruntime_rt_map_resid__mflag()
%t10683 = call i64 @ld64(i64 %t10682)
%t10684 = sub i64 %t10681, %t10683
%t10685 = tail call i64 @st64(i64 %p0, i64 %t10684)
ret i64 %t10685
}
define internal i64 @rt_set_put(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10686 = call i64 @rt_map_put(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 1)
ret i64 %t10686
}
define ptr @resid_set_put(ptr %a0, i8 %a1, i8 %a2, i64 %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1 = zext i8 %a1 to i64
%x2 = zext i8 %a2 to i64
%r = call i64 @rt_set_put(i64 %x0i, i64 %x1, i64 %x2, i64 %a3)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i128 @__mruntime_rt_map_resid__map_find_slow(i64 %p0, i64 %p1, i64 %p2, i64 %p3) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10687 = call i64 @__mruntime_rt_map_resid__map_vref(i64 %p0, i64 %p1, i64 %p2)
%t10688 = icmp eq i64 %t10687, 0
br i1 %t10688, label %L3268, label %L3270
L3268:
%t10689 = sext i64 0 to i128
ret i128 %t10689
L3270:
%t10690 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10691 = call i64 @ld64(i64 %t10687)
%t10692 = call i64 @__mruntime_rt_map_resid__word_out(i64 %t10690, i64 %p3, i64 %t10691)
%t10693 = icmp ne i64 %p3, 0
br label %LSL10694
LSL10694:
br i1 %t10693, label %LSR10694, label %LSJ10694
LSR10694:
%t10695 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10696 = icmp eq i64 %t10695, 0
br label %LSJ10694
LSJ10694:
%t10697 = phi i1 [ false, %LSL10694 ], [ %t10696, %LSR10694 ]
br label %LSL10698
LSL10698:
br i1 %t10697, label %LSR10698, label %LSJ10698
LSR10698:
%t10699 = call i64 @ld64(i64 %t10687)
%t10700 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %p3, i64 %t10699)
%t10701 = xor i1 %t10700, true
br label %LSJ10698
LSJ10698:
%t10702 = phi i1 [ false, %LSL10698 ], [ %t10701, %LSR10698 ]
br i1 %t10702, label %L3271, label %L3273
L3271:
%t10703 = sext i64 0 to i128
ret i128 %t10703
L3273:
%t10704 = icmp ne i64 %p3, 0
br label %LSL10705
LSL10705:
br i1 %t10704, label %LSR10705, label %LSJ10705
LSR10705:
%t10706 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10707 = icmp eq i64 %t10706, 0
br label %LSJ10705
LSJ10705:
%t10708 = phi i1 [ false, %LSL10705 ], [ %t10707, %LSR10705 ]
br i1 %t10708, label %L3274, label %L3275
L3274:
%t10709 = call i64 @__mruntime_rt_map_resid__mret()
%t10710 = call i64 @ld64(i64 %t10709)
br label %L3276
L3275:
br label %L3276
L3276:
%t10711 = phi i64 [ %t10710, %L3274 ], [ %t10692, %L3275 ]
%t10712 = call i128 @__mruntime_rt_map_resid__found_word(i64 %t10711)
ret i128 %t10712
}
define internal i128 @__mruntime_rt_map_resid__found_word(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10713 = sext i64 1 to i128
%t10714 = sext i64 64 to i128
%t10715 = icmp uge i128 %t10714, 128
%t10716 = add i128 %t10714, 0
%t10717 = shl i128 %t10713, %t10716
%t10718 = select i1 %t10715, i128 0, i128 %t10717
%t10719 = sext i64 %p0 to i128
%t10720 = and i128 %t10719, 18446744073709551615
%t10721 = or i128 %t10718, %t10720
ret i128 %t10721
}
define internal i128 @rt_map_find(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10722 = icmp eq i64 %p1, 4
br i1 %t10722, label %L3277, label %L3278
L3277:
br label %L3279
L3278:
br label %L3279
L3279:
%t10723 = phi i64 [ 0, %L3277 ], [ %p1, %L3278 ]
%t10724 = icmp eq i64 %p3, 4
br i1 %t10724, label %L3280, label %L3281
L3280:
br label %L3282
L3281:
br label %L3282
L3282:
%t10725 = phi i64 [ 0, %L3280 ], [ %p3, %L3281 ]
%t10726 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10727 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
br label %LSL10728
LSL10728:
br i1 %t10727, label %LSR10728, label %LSJ10728
LSR10728:
%t10729 = icmp ne i64 %t10726, 0
br label %LSJ10728
LSJ10728:
%t10730 = phi i1 [ false, %LSL10728 ], [ %t10729, %LSR10728 ]
br label %LSL10731
LSL10731:
br i1 %t10730, label %LSR10731, label %LSJ10731
LSR10731:
%t10732 = icmp eq i64 %t10723, 1
br label %LSJ10731
LSJ10731:
%t10733 = phi i1 [ false, %LSL10731 ], [ %t10732, %LSR10731 ]
br label %LSL10734
LSL10734:
br i1 %t10733, label %LSR10734, label %LSJ10734
LSR10734:
%t10735 = call i64 @__mruntime_rt_map_resid__tkk(i64 %t10726)
%t10736 = icmp eq i64 %t10735, 1
br label %LSJ10734
LSJ10734:
%t10737 = phi i1 [ false, %LSL10734 ], [ %t10736, %LSR10734 ]
br label %LSL10738
LSL10738:
br i1 %t10737, label %LSR10738, label %LSJ10738
LSR10738:
%t10739 = call i64 @__mruntime_rt_map_resid__tvk(i64 %t10726)
%t10740 = icmp eq i64 %t10739, %t10725
br label %LSJ10738
LSJ10738:
%t10741 = phi i1 [ false, %LSL10738 ], [ %t10740, %LSR10738 ]
br label %LSL10742
LSL10742:
br i1 %t10741, label %LSR10742, label %LSJ10742
LSR10742:
%t10743 = call i64 @lshr(i64 %p2, i64 1)
%t10744 = call i64 @__mruntime_rt_map_resid__raw_empty()
%t10745 = call i64 @lshr(i64 %t10744, i64 1)
%t10746 = icmp ne i64 %t10743, %t10745
br label %LSJ10742
LSJ10742:
%t10747 = phi i1 [ false, %LSL10742 ], [ %t10746, %LSR10742 ]
br i1 %t10747, label %L3283, label %L3285
L3283:
%t10748 = call i64 @__mruntime_rt_map_resid__map_exit(i64 %p0)
%t10749 = call i64 @__mruntime_rt_map_resid__probe_raw_cached(i64 %t10726, i64 %p2)
%t10750 = icmp slt i64 %t10749, 0
br i1 %t10750, label %L3286, label %L3288
L3286:
%t10751 = sext i64 0 to i128
ret i128 %t10751
L3288:
%t10752 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t10726)
%t10753 = icmp ne i64 %t10752, 0
br i1 %t10753, label %L3289, label %L3290
L3289:
%t10754 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t10726)
%t10755 = mul i64 %t10749, 8
%t10756 = add i64 %t10754, %t10755
%t10757 = call i64 @ld64(i64 %t10756)
br label %L3291
L3290:
br label %L3291
L3291:
%t10758 = phi i64 [ %t10757, %L3289 ], [ 1, %L3290 ]
%t10759 = call i128 @__mruntime_rt_map_resid__found_word(i64 %t10758)
ret i128 %t10759
L3285:
%t10760 = call i128 @__mruntime_rt_map_resid__map_find_slow(i64 %p0, i64 %t10723, i64 %p2, i64 %t10725)
ret i128 %t10760
}
define i128 @resid_map_find(ptr %a0, i8 %a1, i64 %a2, i8 %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1 = zext i8 %a1 to i64
%x3 = zext i8 %a3 to i64
%r = call i128 @rt_map_find(i64 %x0i, i64 %x1, i64 %a2, i64 %x3)
ret i128 %r
}
define internal i64 @rt_map_has(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10761 = icmp eq i64 %p1, 4
br i1 %t10761, label %L3292, label %L3293
L3292:
br label %L3294
L3293:
br label %L3294
L3294:
%t10762 = phi i64 [ 0, %L3292 ], [ %p1, %L3293 ]
%t10763 = call i64 @__mruntime_rt_map_resid__map_vref(i64 %p0, i64 %t10762, i64 %p2)
%t10764 = icmp ne i64 %t10763, 0
br i1 %t10764, label %L3295, label %L3296
L3295:
br label %L3297
L3296:
br label %L3297
L3297:
%t10765 = phi i64 [ 1, %L3295 ], [ 0, %L3296 ]
ret i64 %t10765
}
define i8 @resid_map_has(ptr %a0, i8 %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1 = zext i8 %a1 to i64
%r = call i64 @rt_map_has(i64 %x0i, i64 %x1, i64 %a2)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_map_get(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10766 = call i64 @__mruntime_rt_map_resid__word_of_box(i64 %p1, i1 true)
%t10767 = call i64 @__mruntime_rt_map_resid__mret()
%t10768 = call i64 @ld64(i64 %t10767)
%t10769 = call i64 @__mruntime_rt_map_resid__map_vref(i64 %p0, i64 %t10766, i64 %t10768)
%t10770 = icmp ne i64 %t10769, 0
br i1 %t10770, label %L3298, label %L3299
L3298:
%t10771 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10772 = call i64 @ld64(i64 %t10769)
%t10773 = call i64 @__mruntime_rt_map_resid__word_out(i64 %t10771, i64 0, i64 %t10772)
br label %L3300
L3299:
br label %L3300
L3300:
%t10774 = phi i64 [ %t10773, %L3298 ], [ 0, %L3299 ]
ret i64 %t10774
}
define ptr @resid_map_get(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_map_get(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_map_insert(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10775 = call i64 @__mruntime_rt_map_resid__word_of_box(i64 %p1, i1 true)
%t10776 = call i64 @__mruntime_rt_map_resid__mret()
%t10777 = call i64 @ld64(i64 %t10776)
%t10778 = call i64 @__mruntime_rt_map_resid__word_of_box(i64 %p2, i1 false)
%t10779 = call i64 @__mruntime_rt_map_resid__mret()
%t10780 = call i64 @ld64(i64 %t10779)
%t10781 = call i64 @__mruntime_rt_map_resid__map_insert_p(i64 %p0, i64 %t10775, i64 %t10777, i64 %t10778, i64 %t10780)
ret i64 %t10781
}
define ptr @resid_map_insert(ptr %a0, ptr %a1, ptr %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%x2i = ptrtoint ptr %a2 to i64
%r = call i64 @rt_map_insert(i64 %x0i, i64 %x1i, i64 %x2i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_map_remove(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10782 = call i64 @__mruntime_rt_map_resid__word_of_box(i64 %p1, i1 true)
%t10783 = call i64 @__mruntime_rt_map_resid__mret()
%t10784 = call i64 @ld64(i64 %t10783)
%t10785 = call i64 @__mruntime_rt_map_resid__map_remove_p(i64 %p0, i64 %t10782, i64 %t10784)
ret i64 %t10785
}
define ptr @resid_map_remove(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_map_remove(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_map_contains(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10786 = call i64 @__mruntime_rt_map_resid__word_of_box(i64 %p1, i1 true)
%t10787 = call i64 @__mruntime_rt_map_resid__mret()
%t10788 = call i64 @ld64(i64 %t10787)
%t10789 = call i64 @__mruntime_rt_map_resid__map_vref(i64 %p0, i64 %t10786, i64 %t10788)
%t10790 = icmp ne i64 %t10789, 0
br i1 %t10790, label %L3301, label %L3302
L3301:
br label %L3303
L3302:
br label %L3303
L3303:
%t10791 = phi i64 [ 1, %L3301 ], [ 0, %L3302 ]
ret i64 %t10791
}
define i8 @resid_map_contains(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_map_contains(i64 %x0i, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_map_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10792 = tail call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
ret i64 %t10792
}
define i64 @resid_map_len(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_map_len(i64 %x0i)
ret i64 %r
}
define internal i64 @rt_map_free(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 0
}
define void @resid_map_free(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_map_free(i64 %x0i)
ret void
}
define internal i64 @rt_set_free(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 0
}
define void @resid_set_free(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_set_free(i64 %x0i)
ret void
}
define internal i64 @__mruntime_rt_map_resid__boxed_entries(i64 %p0, i1 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10793 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10794 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t10793)
%t10795 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t10793)
%t10796 = call i64 @__mruntime_rt_map_resid__map_exit(i64 %p0)
%t10797 = call i64 @__mruntime_rt_map_resid__map_entries(i64 %p0, i64 %t10794, i64 %t10795)
%t10798 = xor i1 %p1, true
%t10799 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t10800 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10801 = call i64 @__mruntime_rt_map_resid__box_words(i64 %t10794, i64 %t10795, i64 0, i64 %t10793, i1 %p1, i1 %t10798, i64 %t10799, i64 %t10800)
br i1 %p1, label %L3304, label %L3306
L3304:
%t10802 = call i64 @c_free(i64 %t10795)
%t10803 = mul nsw i64 %t10802, 0
%t10804 = add nsw i64 %t10803, %t10794
ret i64 %t10804
L3306:
%t10805 = call i64 @c_free(i64 %t10794)
%t10806 = mul nsw i64 %t10805, 0
%t10807 = add nsw i64 %t10806, %t10795
ret i64 %t10807
}
define internal i64 @rt_map_keys(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10808 = call i64 @__mruntime_rt_map_resid__boxed_entries(i64 %p0, i1 true)
%t10809 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10811 = ptrtoint ptr @.s10810 to i64
%t10812 = call i64 @rt_list_new(i64 %t10809, i64 %t10808, i64 %t10811)
%t10813 = call i64 @c_free(i64 %t10808)
%t10814 = mul nsw i64 %t10813, 0
%t10815 = add nsw i64 %t10814, %t10812
ret i64 %t10815
}
define ptr @resid_map_keys(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_map_keys(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_map_values(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10816 = call i64 @__mruntime_rt_map_resid__boxed_entries(i64 %p0, i1 false)
%t10817 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10819 = ptrtoint ptr @.s10818 to i64
%t10820 = call i64 @rt_list_new(i64 %t10817, i64 %t10816, i64 %t10819)
%t10821 = call i64 @c_free(i64 %t10816)
%t10822 = mul nsw i64 %t10821, 0
%t10823 = add nsw i64 %t10822, %t10820
ret i64 %t10823
}
define ptr @resid_map_values(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_map_values(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_map_resid__sb_entry(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10824 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p1)
br i1 %t10824, label %L3307, label %L3308
L3307:
%t10825 = call i64 @__mruntime_rt_map_resid__stype(i64 %p1)
br label %L3309
L3308:
br label %L3309
L3309:
%t10826 = phi i64 [ %t10825, %L3307 ], [ 0, %L3308 ]
%t10827 = icmp eq i64 %t10826, 0
br i1 %t10827, label %L3310, label %L3312
L3310:
%t10828 = tail call i64 @sb_lit(i64 %p0, i64 %p1)
ret i64 %t10828
L3312:
%t10829 = icmp eq i64 %t10826, 2
br i1 %t10829, label %L3313, label %L3315
L3313:
%t10830 = call double @unbox_float(i64 %p1)
%t10831 = call i64 @sb_float(i64 %p0, double %t10830)
ret i64 %t10831
L3315:
%t10832 = icmp eq i64 %t10826, 3
br i1 %t10832, label %L3316, label %L3318
L3316:
%t10833 = add i64 %p1, 24
%t10834 = call i64 @ld8(i64 %t10833)
%t10835 = icmp ne i64 %t10834, 0
br i1 %t10835, label %L3319, label %L3320
L3319:
%t10837 = ptrtoint ptr @.s10836 to i64
br label %L3321
L3320:
%t10839 = ptrtoint ptr @.s10838 to i64
br label %L3321
L3321:
%t10840 = phi i64 [ %t10837, %L3319 ], [ %t10839, %L3320 ]
%t10841 = tail call i64 @sb_lit(i64 %p0, i64 %t10840)
ret i64 %t10841
L3318:
%t10842 = call i64 @unbox_word(i64 %p1)
%t10843 = tail call i64 @sb_word(i64 %p0, i64 %t10842)
ret i64 %t10843
}
define internal i64 @__mruntime_rt_map_resid__sb_pairs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t10864, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t10844 = icmp sge i64 %p3, %p4
br i1 %t10844, label %L3322, label %L3324
L3322:
ret i64 0
L3324:
%t10845 = icmp sgt i64 %p3, 0
br i1 %t10845, label %L3325, label %L3326
L3325:
%t10847 = ptrtoint ptr @.s10846 to i64
%t10848 = call i64 @sb_lit(i64 %p0, i64 %t10847)
br label %L3327
L3326:
br label %L3327
L3327:
%t10849 = phi i64 [ %t10848, %L3325 ], [ 0, %L3326 ]
%t10850 = mul i64 %p3, 8
%t10851 = add i64 %p1, %t10850
%t10852 = call i64 @ld64(i64 %t10851)
%t10853 = call i64 @__mruntime_rt_map_resid__sb_entry(i64 %p0, i64 %t10852)
%t10854 = icmp ne i64 %p2, 0
br i1 %t10854, label %L3328, label %L3329
L3328:
%t10856 = ptrtoint ptr @.s10855 to i64
%t10857 = call i64 @sb_lit(i64 %p0, i64 %t10856)
%t10858 = mul i64 %p3, 8
%t10859 = add i64 %p2, %t10858
%t10860 = call i64 @ld64(i64 %t10859)
%t10861 = call i64 @__mruntime_rt_map_resid__sb_entry(i64 %p0, i64 %t10860)
%t10862 = add i64 %t10857, %t10861
br label %L3330
L3329:
br label %L3330
L3330:
%t10863 = phi i64 [ %t10862, %L3328 ], [ 0, %L3329 ]
%t10864 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_map_format(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10866 = call i64 @rt_sb_new()
%t10867 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10868 = icmp sgt i64 %t10867, 0
br i1 %t10868, label %L3331, label %L3332
L3331:
%t10869 = call i64 @__mruntime_rt_map_resid__boxed_entries(i64 %p0, i1 true)
br label %L3333
L3332:
br label %L3333
L3333:
%t10870 = phi i64 [ %t10869, %L3331 ], [ 0, %L3332 ]
%t10871 = icmp sgt i64 %t10867, 0
br i1 %t10871, label %L3334, label %L3335
L3334:
%t10872 = call i64 @__mruntime_rt_map_resid__boxed_entries(i64 %p0, i1 false)
br label %L3336
L3335:
br label %L3336
L3336:
%t10873 = phi i64 [ %t10872, %L3334 ], [ 0, %L3335 ]
%t10875 = ptrtoint ptr @.s10874 to i64
%t10876 = call i64 @sb_lit(i64 %t10866, i64 %t10875)
%t10877 = call i64 @__mruntime_rt_map_resid__sb_pairs(i64 %t10866, i64 %t10870, i64 %t10873, i64 0, i64 %t10867)
%t10879 = ptrtoint ptr @.s10878 to i64
%t10880 = call i64 @sb_lit(i64 %t10866, i64 %t10879)
%t10881 = call i64 @c_free(i64 %t10870)
%t10882 = call i64 @c_free(i64 %t10873)
%t10883 = add i64 %t10881, %t10882
%t10884 = tail call i64 @rt_sb_finish(i64 %t10866)
ret i64 %t10884
}
define ptr @resid_map_format(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_map_format(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_set_new() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10885 = sub nsw i64 0, 1
%t10886 = sub nsw i64 0, 1
%t10887 = call i64 @__mruntime_rt_map_resid__trie_new(i64 0, i64 0, i64 %t10885, i64 %t10886)
ret i64 %t10887
}
define ptr @resid_set_new() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_set_new()
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_set_insert(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10888 = call i64 @rt_map_insert(i64 %p0, i64 %p1, i64 1)
ret i64 %t10888
}
define ptr @resid_set_insert(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_set_insert(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_set_remove(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10889 = tail call i64 @rt_map_remove(i64 %p0, i64 %p1)
ret i64 %t10889
}
define ptr @resid_set_remove(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_set_remove(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_set_contains(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10890 = tail call i64 @rt_map_contains(i64 %p0, i64 %p1)
ret i64 %t10890
}
define i8 @resid_set_contains(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_set_contains(i64 %x0i, i64 %x1i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_set_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10891 = tail call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
ret i64 %t10891
}
define i64 @resid_set_len(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_set_len(i64 %x0i)
ret i64 %r
}
define internal i64 @__mruntime_rt_map_resid__set_words(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10892 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10893 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t10892)
%t10894 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10895 = icmp ne i64 %t10894, 0
br i1 %t10895, label %L3337, label %L3339
L3337:
%t10896 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10897 = call i64 @__mruntime_rt_map_resid__table_keys(i64 %t10896, i64 %t10893, i64 0, i64 0)
%t10898 = mul nsw i64 %t10897, 0
%t10899 = add nsw i64 %t10898, %t10893
ret i64 %t10899
L3339:
%t10900 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t10901 = call i64 @__mruntime_rt_map_resid__hn_collect(i64 %t10900, i64 %t10893, i64 0, i64 0)
%t10902 = mul nsw i64 %t10901, 0
%t10903 = add nsw i64 %t10902, %t10893
ret i64 %t10903
}
define internal i64 @__mruntime_rt_map_resid__table_keys(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t10904, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t10911, %tco.s0 ]
%t10904 = call i64 @__mruntime_rt_map_resid__t_next(i64 %p0, i64 %p2)
%t10905 = icmp slt i64 %t10904, 0
br i1 %t10905, label %L3340, label %L3342
L3340:
ret i64 %p3
L3342:
%t10906 = mul i64 %p3, 8
%t10907 = add i64 %p1, %t10906
%t10908 = call i64 @__mruntime_rt_map_resid__mret()
%t10909 = call i64 @ld64(i64 %t10908)
%t10910 = call i64 @st64(i64 %t10907, i64 %t10909)
%t10911 = add i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__set_of_words(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10913 = sub nsw i64 0, 1
%t10914 = sub nsw i64 0, 1
%t10915 = call i64 @__mruntime_rt_map_resid__trie_new(i64 0, i64 0, i64 %t10913, i64 %t10914)
%t10916 = icmp eq i64 %p1, 0
br i1 %t10916, label %L3343, label %L3345
L3343:
ret i64 %t10915
L3345:
%t10917 = call i64 @__mruntime_rt_map_resid__cap_for(i64 %p1)
%t10918 = call i64 @__mruntime_rt_map_resid__tab_new(i64 %t10917, i64 %p2, i64 0, i1 true)
%t10919 = add i64 %t10915, 16
%t10920 = call i64 @st64(i64 %t10919, i64 %t10918)
%t10921 = call i64 @__mruntime_rt_map_resid__insert_words(i64 %t10918, i64 %p0, i64 0, i64 %p1)
%t10922 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t10918)
%t10923 = call i64 @st64(i64 %t10915, i64 %t10922)
%t10924 = mul nsw i64 %t10923, 0
%t10925 = add nsw i64 %t10924, %t10915
ret i64 %t10925
}
define internal i64 @__mruntime_rt_map_resid__insert_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t10931, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t10926 = icmp sge i64 %p2, %p3
br i1 %t10926, label %L3346, label %L3348
L3346:
ret i64 0
L3348:
%t10927 = mul i64 %p2, 8
%t10928 = add i64 %p1, %t10927
%t10929 = call i64 @ld64(i64 %t10928)
%t10930 = call i64 @__mruntime_rt_map_resid__t_insert_new(i64 %p0, i64 %t10929, i64 1)
%t10931 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__put_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t10938, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t10933 = icmp sge i64 %p3, %p4
br i1 %t10933, label %L3349, label %L3351
L3349:
ret i64 0
L3351:
%t10934 = mul i64 %p3, 8
%t10935 = add i64 %p2, %t10934
%t10936 = call i64 @ld64(i64 %t10935)
%t10937 = call i64 @__mruntime_rt_map_resid__t_put(i64 %p0, i64 %p1, i64 %t10936, i64 0, i64 1)
%t10938 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__set_put_all(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10940 = call i64 @__mruntime_rt_map_resid__set_words(i64 %p1)
%t10941 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p1)
%t10942 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t10943 = call i64 @__mruntime_rt_map_resid__put_owned_words(i64 %p0, i64 %t10941, i64 %t10940, i64 0, i64 %t10942)
%t10944 = call i64 @c_free(i64 %t10940)
%t10945 = mul nsw i64 %t10944, 0
%t10946 = add nsw i64 %t10945, %t10943
ret i64 %t10946
}
define internal i64 @__mruntime_rt_map_resid__put_owned_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t10951, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t10952, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t10947 = icmp sge i64 %p3, %p4
br i1 %t10947, label %L3352, label %L3354
L3352:
ret i64 %p0
L3354:
%t10948 = mul i64 %p3, 8
%t10949 = add i64 %p2, %t10948
%t10950 = call i64 @ld64(i64 %t10949)
%t10951 = call i64 @__mruntime_rt_map_resid__map_put_slow(i64 %p0, i64 1, i64 %p1, i64 %t10950, i64 0, i64 1)
%t10952 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_set_union(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10954 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t10955 = icmp eq i64 %t10954, 0
br i1 %t10955, label %L3355, label %L3357
L3355:
ret i64 %p0
L3357:
%t10956 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10957 = icmp eq i64 %t10956, 0
br i1 %t10957, label %L3358, label %L3360
L3358:
ret i64 %p1
L3360:
%t10958 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10959 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t10960 = icmp sge i64 %t10958, %t10959
br i1 %t10960, label %L3361, label %L3362
L3361:
br label %L3363
L3362:
br label %L3363
L3363:
%t10961 = phi i64 [ %p0, %L3361 ], [ %p1, %L3362 ]
%t10962 = icmp eq i64 %t10961, %p0
br i1 %t10962, label %L3364, label %L3365
L3364:
br label %L3366
L3365:
br label %L3366
L3366:
%t10963 = phi i64 [ %p1, %L3364 ], [ %p0, %L3365 ]
%t10964 = call i64 @__mruntime_rt_map_resid__mtab(i64 %t10961)
%t10965 = icmp eq i64 %t10964, 0
br label %LSL10966
LSL10966:
br i1 %t10965, label %LSR10966, label %LSJ10966
LSR10966:
%t10967 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t10963)
%t10968 = mul i64 %t10967, 8
%t10969 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t10961)
%t10970 = icmp slt i64 %t10968, %t10969
br label %LSJ10966
LSJ10966:
%t10971 = phi i1 [ false, %LSL10966 ], [ %t10970, %LSR10966 ]
br i1 %t10971, label %L3367, label %L3369
L3367:
%t10972 = call i64 @rt_map_transient(i64 %t10961)
%t10973 = call i64 @__mruntime_rt_map_resid__set_put_all(i64 %t10972, i64 %t10963)
%t10974 = call i64 @rt_map_freeze(i64 %t10973)
ret i64 %t10974
L3369:
%t10975 = sub nsw i64 0, 1
%t10976 = sub nsw i64 0, 1
%t10977 = call i64 @__mruntime_rt_map_resid__trie_new(i64 0, i64 0, i64 %t10975, i64 %t10976)
%t10978 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t10961)
%t10979 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t10963)
%t10980 = add i64 %t10978, %t10979
%t10981 = call i64 @__mruntime_rt_map_resid__cap_for(i64 %t10980)
%t10982 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %t10961)
%t10983 = call i64 @__mruntime_rt_map_resid__tab_new(i64 %t10981, i64 %t10982, i64 0, i1 true)
%t10984 = add i64 %t10977, 16
%t10985 = call i64 @st64(i64 %t10984, i64 %t10983)
%t10986 = call i64 @__mruntime_rt_map_resid__set_words(i64 %t10961)
%t10987 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t10961)
%t10988 = call i64 @__mruntime_rt_map_resid__insert_words(i64 %t10983, i64 %t10986, i64 0, i64 %t10987)
%t10989 = call i64 @__mruntime_rt_map_resid__set_words(i64 %t10963)
%t10990 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %t10963)
%t10991 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t10963)
%t10992 = call i64 @__mruntime_rt_map_resid__put_words(i64 %t10983, i64 %t10990, i64 %t10989, i64 0, i64 %t10991)
%t10993 = call i64 @c_free(i64 %t10986)
%t10994 = call i64 @c_free(i64 %t10989)
%t10995 = add i64 %t10993, %t10994
%t10996 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t10983)
%t10997 = call i64 @st64(i64 %t10977, i64 %t10996)
%t10998 = mul nsw i64 %t10997, 0
%t10999 = add nsw i64 %t10998, %t10977
ret i64 %t10999
}
define ptr @resid_set_union(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_set_union(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_set_difference(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11000 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t11001 = icmp eq i64 %t11000, 0
br label %LSL11002
LSL11002:
br i1 %t11001, label %LSJ11002, label %LSR11002
LSR11002:
%t11003 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t11004 = icmp eq i64 %t11003, 0
br label %LSJ11002
LSJ11002:
%t11005 = phi i1 [ true, %LSL11002 ], [ %t11004, %LSR11002 ]
br i1 %t11005, label %L3370, label %L3372
L3370:
ret i64 %p0
L3372:
%t11006 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t11007 = mul i64 %t11006, 4
%t11008 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t11009 = icmp slt i64 %t11007, %t11008
br i1 %t11009, label %L3373, label %L3375
L3373:
%t11010 = call i64 @__mruntime_rt_map_resid__set_words(i64 %p1)
%t11011 = call i64 @rt_map_transient(i64 %p0)
%t11012 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p1)
%t11013 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t11014 = call i64 @__mruntime_rt_map_resid__del_words(i64 %t11011, i64 %t11012, i64 %t11010, i64 0, i64 %t11013)
%t11015 = call i64 @c_free(i64 %t11010)
%t11016 = mul nsw i64 %t11015, 0
%t11017 = call i64 @rt_map_freeze(i64 %t11014)
%t11018 = add nsw i64 %t11016, %t11017
ret i64 %t11018
L3375:
%t11019 = call i64 @__mruntime_rt_map_resid__set_words(i64 %p0)
%t11020 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t11021 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t11022 = call i64 @__mruntime_rt_map_resid__keep_words(i64 %t11019, i64 0, i64 0, i64 %t11020, i64 %p1, i64 %t11021, i1 false)
%t11023 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t11024 = icmp eq i64 %t11022, %t11023
br i1 %t11024, label %L3376, label %L3377
L3376:
br label %L3378
L3377:
%t11025 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t11026 = call i64 @__mruntime_rt_map_resid__set_of_words(i64 %t11019, i64 %t11022, i64 %t11025)
br label %L3378
L3378:
%t11027 = phi i64 [ %p0, %L3376 ], [ %t11026, %L3377 ]
%t11028 = call i64 @c_free(i64 %t11019)
%t11029 = mul nsw i64 %t11028, 0
%t11030 = add nsw i64 %t11029, %t11027
ret i64 %t11030
}
define ptr @resid_set_difference(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_set_difference(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_map_resid__del_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t11035, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t11036, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t11031 = icmp sge i64 %p3, %p4
br i1 %t11031, label %L3379, label %L3381
L3379:
ret i64 %p0
L3381:
%t11032 = mul i64 %p3, 8
%t11033 = add i64 %p2, %t11032
%t11034 = call i64 @ld64(i64 %t11033)
%t11035 = call i64 @rt_map_del(i64 %p0, i64 1, i64 %p1, i64 %t11034)
%t11036 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__keep_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i1 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t11045, %tco.s0 ], [ %t11053, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t11051, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ], [ %p3, %tco.s1 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ], [ %p4, %tco.s1 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ], [ %p5, %tco.s1 ]
%p6 = phi i1 [ %p6.in, %entry ], [ %p6, %tco.s0 ], [ %p6, %tco.s1 ]
%t11038 = icmp sge i64 %p1, %p3
br i1 %t11038, label %L3382, label %L3384
L3382:
ret i64 %p2
L3384:
%t11039 = mul i64 %p1, 8
%t11040 = add i64 %p0, %t11039
%t11041 = call i64 @ld64(i64 %t11040)
%t11042 = call i64 @__mruntime_rt_map_resid__map_vref(i64 %p4, i64 %p5, i64 %t11041)
%t11043 = icmp ne i64 %t11042, 0
%t11044 = icmp eq i1 %t11043, %p6
br i1 %t11044, label %L3385, label %L3387
L3385:
%t11045 = add nsw i64 %p1, 1
%t11046 = mul i64 %p2, 8
%t11047 = add i64 %p0, %t11046
%t11048 = call i64 @st64(i64 %t11047, i64 %t11041)
%t11049 = mul nsw i64 %t11048, 0
%t11050 = add nsw i64 %t11049, %p2
%t11051 = add i64 %t11050, 1
br label %tco.s0
tco.s0:
br label %tco.head
L3387:
%t11053 = add nsw i64 %p1, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @rt_set_intersection(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11055 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t11056 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t11057 = icmp sle i64 %t11055, %t11056
br i1 %t11057, label %L3388, label %L3389
L3388:
br label %L3390
L3389:
br label %L3390
L3390:
%t11058 = phi i64 [ %p0, %L3388 ], [ %p1, %L3389 ]
%t11059 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t11060 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t11061 = icmp sle i64 %t11059, %t11060
br i1 %t11061, label %L3391, label %L3392
L3391:
br label %L3393
L3392:
br label %L3393
L3393:
%t11062 = phi i64 [ %p1, %L3391 ], [ %p0, %L3392 ]
%t11063 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t11058)
%t11064 = icmp eq i64 %t11063, 0
br i1 %t11064, label %L3394, label %L3396
L3394:
ret i64 %t11058
L3396:
%t11065 = call i64 @__mruntime_rt_map_resid__set_words(i64 %t11058)
%t11066 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t11058)
%t11067 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %t11058)
%t11068 = call i64 @__mruntime_rt_map_resid__keep_words(i64 %t11065, i64 0, i64 0, i64 %t11066, i64 %t11062, i64 %t11067, i1 true)
%t11069 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t11058)
%t11070 = icmp eq i64 %t11068, %t11069
br i1 %t11070, label %L3397, label %L3398
L3397:
br label %L3399
L3398:
%t11071 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %t11058)
%t11072 = call i64 @__mruntime_rt_map_resid__set_of_words(i64 %t11065, i64 %t11068, i64 %t11071)
br label %L3399
L3399:
%t11073 = phi i64 [ %t11058, %L3397 ], [ %t11072, %L3398 ]
%t11074 = call i64 @c_free(i64 %t11065)
%t11075 = mul nsw i64 %t11074, 0
%t11076 = add nsw i64 %t11075, %t11073
ret i64 %t11076
}
define ptr @resid_set_intersection(ptr %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_set_intersection(i64 %x0i, i64 %x1i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_set_to_list(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11077 = tail call i64 @rt_map_keys(i64 %p0)
ret i64 %t11077
}
define ptr @resid_set_to_list(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_set_to_list(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_set_format(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11078 = call i64 @rt_sb_new()
%t11079 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t11080 = icmp sgt i64 %t11079, 0
br i1 %t11080, label %L3400, label %L3401
L3400:
%t11081 = call i64 @__mruntime_rt_map_resid__boxed_entries(i64 %p0, i1 true)
br label %L3402
L3401:
br label %L3402
L3402:
%t11082 = phi i64 [ %t11081, %L3400 ], [ 0, %L3401 ]
%t11084 = ptrtoint ptr @.s11083 to i64
%t11085 = call i64 @sb_lit(i64 %t11078, i64 %t11084)
%t11086 = call i64 @__mruntime_rt_map_resid__sb_pairs(i64 %t11078, i64 %t11082, i64 0, i64 0, i64 %t11079)
%t11088 = ptrtoint ptr @.s11087 to i64
%t11089 = call i64 @sb_lit(i64 %t11078, i64 %t11088)
%t11090 = call i64 @c_free(i64 %t11082)
%t11091 = tail call i64 @rt_sb_finish(i64 %t11078)
ret i64 %t11091
}
define ptr @resid_set_format(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_set_format(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_map_resid__pvec_keep(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11092 = icmp eq i64 %p0, 0
br label %LSL11093
LSL11093:
br i1 %t11092, label %LSJ11093, label %LSR11093
LSR11093:
%t11094 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t11095 = xor i1 %t11094, true
br label %LSJ11093
LSJ11093:
%t11096 = phi i1 [ true, %LSL11093 ], [ %t11095, %LSR11093 ]
br i1 %t11096, label %L3403, label %L3405
L3403:
ret i64 %p0
L3405:
%t11097 = call i64 @ld64(i64 %p0)
%t11098 = mul i64 %t11097, 8
%t11099 = add i64 8, %t11098
%t11100 = call i64 @c_outer_alloc(i64 %t11099)
%t11101 = call i64 @st64(i64 %t11100, i64 %t11097)
%t11102 = call i64 @__mruntime_rt_map_resid__keep_items(i64 %p0, i64 %t11100, i64 0, i64 %t11097, i64 %p1)
%t11103 = mul nsw i64 %t11102, 0
%t11104 = add nsw i64 %t11103, %t11100
ret i64 %t11104
}
define internal i64 @__mruntime_rt_map_resid__keep_items(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t11119, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t11105 = icmp sge i64 %p2, %p3
br i1 %t11105, label %L3406, label %L3408
L3406:
ret i64 0
L3408:
%t11106 = add i64 %p0, 8
%t11107 = mul i64 %p2, 8
%t11108 = add i64 %t11106, %t11107
%t11109 = call i64 @ld64(i64 %t11108)
%t11110 = add i64 %p1, 8
%t11111 = mul i64 %p2, 8
%t11112 = add i64 %t11110, %t11111
%t11113 = icmp sgt i64 %p4, 0
br i1 %t11113, label %L3409, label %L3410
L3409:
%t11114 = sub nsw i64 %p4, 5
%t11115 = call i64 @__mruntime_rt_map_resid__pvec_keep(i64 %t11109, i64 %t11114)
br label %L3411
L3410:
%t11116 = call i64 @__mruntime_rt_map_resid__elem_keep(i64 %t11109)
br label %L3411
L3411:
%t11117 = phi i64 [ %t11115, %L3409 ], [ %t11116, %L3410 ]
%t11118 = call i64 @st64(i64 %t11112, i64 %t11117)
%t11119 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_keep(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11121 = icmp eq i64 %p0, 0
br label %LSL11122
LSL11122:
br i1 %t11121, label %LSJ11122, label %LSR11122
LSR11122:
%t11123 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t11124 = icmp eq i64 %t11123, 0
br label %LSJ11122
LSJ11122:
%t11125 = phi i1 [ true, %LSL11122 ], [ %t11124, %LSR11122 ]
br i1 %t11125, label %L3412, label %L3414
L3412:
ret i64 %p0
L3414:
%t11126 = call i64 @lroot(i64 %p0)
%t11127 = call i64 @lcount(i64 %p0)
%t11128 = call i64 @lshift(i64 %p0)
%t11129 = sub nsw i64 0, 1
%t11130 = icmp eq i64 %t11128, %t11129
br label %LSL11131
LSL11131:
br i1 %t11130, label %LSR11131, label %LSJ11131
LSR11131:
%t11132 = icmp ne i64 %t11126, 0
br label %LSJ11131
LSJ11131:
%t11133 = phi i1 [ false, %LSL11131 ], [ %t11132, %LSR11131 ]
br i1 %t11133, label %L3415, label %L3416
L3415:
%t11134 = call i64 @__mruntime_rt_map_resid__flat_keep(i64 %t11126, i64 %t11127)
br label %L3417
L3416:
%t11135 = icmp ne i64 %t11126, 0
br i1 %t11135, label %L3418, label %L3419
L3418:
%t11136 = call i64 @lshift(i64 %p0)
%t11137 = call i64 @__mruntime_rt_map_resid__pvec_keep(i64 %t11126, i64 %t11136)
br label %L3420
L3419:
br label %L3420
L3420:
%t11138 = phi i64 [ %t11137, %L3418 ], [ %t11126, %L3419 ]
br label %L3417
L3417:
%t11139 = phi i64 [ %t11134, %L3415 ], [ %t11138, %L3420 ]
%t11140 = icmp eq i64 %t11139, %t11126
br label %LSL11141
LSL11141:
br i1 %t11140, label %LSR11141, label %LSJ11141
LSR11141:
%t11142 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t11143 = xor i1 %t11142, true
br label %LSJ11141
LSJ11141:
%t11144 = phi i1 [ false, %LSL11141 ], [ %t11143, %LSR11141 ]
br i1 %t11144, label %L3421, label %L3423
L3421:
ret i64 %p0
L3423:
%t11145 = call i64 @c_outer_alloc(i64 32)
%t11146 = call i64 @mcopy(i64 %t11145, i64 %p0, i64 32)
%t11147 = add i64 %t11145, 16
%t11148 = call i64 @st64(i64 %t11147, i64 %t11139)
%t11149 = mul nsw i64 %t11148, 0
%t11150 = add nsw i64 %t11149, %t11145
ret i64 %t11150
}
define ptr @resid_list_keep(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_keep(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_map_resid__flat_keep(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11151 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
br i1 %t11151, label %L3424, label %L3426
L3424:
%t11152 = add i64 %p0, 8
%t11153 = call i64 @ld64(i64 %t11152)
%t11154 = icmp sgt i64 %t11153, %p1
br i1 %t11154, label %L3427, label %L3428
L3427:
%t11155 = add i64 %p0, 8
%t11156 = call i64 @ld64(i64 %t11155)
br label %L3429
L3428:
%t11157 = icmp sgt i64 %p1, 1
br i1 %t11157, label %L3430, label %L3431
L3430:
br label %L3432
L3431:
br label %L3432
L3432:
%t11158 = phi i64 [ %p1, %L3430 ], [ 1, %L3431 ]
br label %L3429
L3429:
%t11159 = phi i64 [ %t11156, %L3427 ], [ %t11158, %L3432 ]
%t11160 = mul i64 %t11159, 8
%t11161 = add i64 24, %t11160
%t11162 = call i64 @c_outer_alloc(i64 %t11161)
%t11163 = call i64 @st64(i64 %t11162, i64 %p1)
%t11164 = add i64 %t11162, 8
%t11165 = call i64 @st64(i64 %t11164, i64 %t11159)
%t11166 = add i64 %t11163, %t11165
%t11167 = add i64 %t11162, 16
%t11168 = call i64 @st64(i64 %t11167, i64 %p1)
%t11169 = add i64 %t11166, %t11168
%t11170 = call i64 @__mruntime_rt_map_resid__keep_elems(i64 %p0, i64 %t11162, i64 0, i64 %p1)
%t11171 = mul nsw i64 %t11170, 0
%t11172 = add nsw i64 %t11171, %t11162
ret i64 %t11172
L3426:
%t11173 = add i64 %p0, 16
%t11174 = call i64 @ld64(i64 %t11173)
%t11175 = icmp slt i64 %t11174, %p1
br i1 %t11175, label %L3433, label %L3434
L3433:
%t11176 = call i64 @__mruntime_rt_map_resid__keep_elems(i64 %p0, i64 %p0, i64 %t11174, i64 %p1)
%t11177 = add i64 %p0, 16
%t11178 = call i64 @st64(i64 %t11177, i64 %p1)
%t11179 = add i64 %t11176, %t11178
br label %L3435
L3434:
br label %L3435
L3435:
%t11180 = phi i64 [ %t11179, %L3433 ], [ 0, %L3434 ]
ret i64 %p0
}
define internal i64 @__mruntime_rt_map_resid__keep_elems(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t11191, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t11181 = icmp sge i64 %p2, %p3
br i1 %t11181, label %L3436, label %L3438
L3436:
ret i64 0
L3438:
%t11182 = add i64 %p1, 24
%t11183 = mul i64 %p2, 8
%t11184 = add i64 %t11182, %t11183
%t11185 = add i64 %p0, 24
%t11186 = mul i64 %p2, 8
%t11187 = add i64 %t11185, %t11186
%t11188 = call i64 @ld64(i64 %t11187)
%t11189 = call i64 @__mruntime_rt_map_resid__elem_keep(i64 %t11188)
%t11190 = call i64 @st64(i64 %t11184, i64 %t11189)
%t11191 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_evac(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11193 = tail call i64 @rt_list_keep(i64 %p0)
ret i64 %t11193
}
define ptr @resid_list_evac(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_evac(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_carry_free(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11194 = icmp eq i64 %p0, 0
br label %LSL11195
LSL11195:
br i1 %t11194, label %LSJ11195, label %LSR11195
LSR11195:
%t11196 = icmp eq i64 %p1, 0
br label %LSJ11195
LSJ11195:
%t11197 = phi i1 [ true, %LSL11195 ], [ %t11196, %LSR11195 ]
br label %LSL11198
LSL11198:
br i1 %t11197, label %LSJ11198, label %LSR11198
LSR11198:
%t11199 = call i64 @c_in_arenas(i64 %p1)
%t11200 = icmp ne i64 %t11199, 0
br label %LSJ11198
LSJ11198:
%t11201 = phi i1 [ true, %LSL11198 ], [ %t11200, %LSR11198 ]
br i1 %t11201, label %L3439, label %L3441
L3439:
ret i64 0
L3441:
%t11202 = call i64 @c_free(i64 %p1)
ret i64 %t11202
}
define void @resid_carry_free(i8 %a0, ptr %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = zext i8 %a0 to i64
%x1i = ptrtoint ptr %a1 to i64
%r = call i64 @rt_carry_free(i64 %x0, i64 %x1i)
ret void
}
define internal i64 @rt_dec_evac(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11203 = icmp eq i64 %p0, 0
br label %LSL11204
LSL11204:
br i1 %t11203, label %LSJ11204, label %LSR11204
LSR11204:
%t11205 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t11206 = xor i1 %t11205, true
br label %LSJ11204
LSJ11204:
%t11207 = phi i1 [ true, %LSL11204 ], [ %t11206, %LSR11204 ]
br i1 %t11207, label %L3442, label %L3444
L3442:
ret i64 %p0
L3444:
%t11208 = call i64 @dn(i64 %p0)
%t11209 = mul i64 %t11208, 8
%t11210 = add i64 24, %t11209
%t11211 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t11212 = call i64 @c_sc_depth_set(i64 0)
%t11213 = call i64 @c_gmalloc(i64 %t11210)
%t11214 = call i64 @c_sc_depth_set(i64 %t11211)
%t11215 = call i64 @mcopy(i64 %t11213, i64 %p0, i64 %t11210)
%t11216 = mul nsw i64 %t11215, 0
%t11217 = add nsw i64 %t11216, %t11213
ret i64 %t11217
}
define ptr @resid_dec_evac(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_dec_evac(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_map_resid__hnode_evac(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11218 = icmp eq i64 %p0, 0
br label %LSL11219
LSL11219:
br i1 %t11218, label %LSJ11219, label %LSR11219
LSR11219:
%t11220 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t11221 = xor i1 %t11220, true
br label %LSJ11219
LSJ11219:
%t11222 = phi i1 [ true, %LSL11219 ], [ %t11221, %LSR11219 ]
br i1 %t11222, label %L3445, label %L3447
L3445:
ret i64 %p0
L3447:
%t11223 = call i64 @__mruntime_rt_map_resid__node_nd(i64 %p0)
%t11224 = call i64 @__mruntime_rt_map_resid__node_nn(i64 %p0)
%t11225 = call i64 @__mruntime_rt_map_resid__ncap(i64 %p0)
%t11226 = mul i64 %t11225, 8
%t11227 = add i64 24, %t11226
%t11228 = call i64 @xmalloc(i64 %t11227)
%t11229 = mul i64 2, %t11223
%t11230 = add i64 %t11229, %t11224
%t11231 = mul i64 %t11230, 8
%t11232 = add i64 24, %t11231
%t11233 = call i64 @mcopy(i64 %t11228, i64 %p0, i64 %t11232)
%t11234 = call i64 @__mruntime_rt_map_resid__evac_pairs(i64 %t11228, i64 0, i64 %t11223, i64 %p1, i64 %p2)
%t11235 = call i64 @__mruntime_rt_map_resid__evac_subs(i64 %t11228, i64 %t11223, i64 0, i64 %t11224, i64 %p1, i64 %p2)
%t11236 = mul nsw i64 %t11235, 0
%t11237 = add nsw i64 %t11236, %t11228
ret i64 %t11237
}
define internal i64 @__mruntime_rt_map_resid__evac_pairs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t11251, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t11238 = icmp sge i64 %p1, %p2
br i1 %t11238, label %L3448, label %L3450
L3448:
ret i64 0
L3450:
%t11239 = mul i64 2, %p1
%t11240 = mul i64 2, %p1
%t11241 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t11240)
%t11242 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %p3, i64 %t11241)
%t11243 = call i64 @__mruntime_rt_map_resid__wset(i64 %p0, i64 %t11239, i64 %t11242)
%t11244 = mul i64 2, %p1
%t11245 = add i64 %t11244, 1
%t11246 = mul i64 2, %p1
%t11247 = add i64 %t11246, 1
%t11248 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t11247)
%t11249 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %p4, i64 %t11248)
%t11250 = call i64 @__mruntime_rt_map_resid__wset(i64 %p0, i64 %t11245, i64 %t11249)
%t11251 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__evac_subs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t11261, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t11253 = icmp sge i64 %p2, %p3
br i1 %t11253, label %L3451, label %L3453
L3451:
ret i64 0
L3453:
%t11254 = mul i64 2, %p1
%t11255 = add i64 %t11254, %p2
%t11256 = mul i64 2, %p1
%t11257 = add i64 %t11256, %p2
%t11258 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t11257)
%t11259 = call i64 @__mruntime_rt_map_resid__hnode_evac(i64 %t11258, i64 %p4, i64 %p5)
%t11260 = call i64 @__mruntime_rt_map_resid__wset(i64 %p0, i64 %t11255, i64 %t11259)
%t11261 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_map_evac(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11263 = icmp eq i64 %p0, 0
br label %LSL11264
LSL11264:
br i1 %t11263, label %LSJ11264, label %LSR11264
LSR11264:
%t11265 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t11266 = icmp eq i64 %t11265, 0
br label %LSJ11264
LSJ11264:
%t11267 = phi i1 [ true, %LSL11264 ], [ %t11266, %LSR11264 ]
br i1 %t11267, label %L3454, label %L3456
L3454:
ret i64 %p0
L3456:
%t11268 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t11269 = icmp ne i64 %t11268, 0
br i1 %t11269, label %L3457, label %L3458
L3457:
%t11270 = call i64 @__mruntime_rt_map_resid__tab_evac(i64 %t11268, i64 %p1, i64 %p2)
br label %L3459
L3458:
br label %L3459
L3459:
%t11271 = phi i64 [ %t11270, %L3457 ], [ 0, %L3458 ]
%t11272 = icmp ne i64 %t11268, 0
br i1 %t11272, label %L3460, label %L3461
L3460:
%t11273 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
br label %L3462
L3461:
%t11274 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t11275 = call i64 @__mruntime_rt_map_resid__hnode_evac(i64 %t11274, i64 %p1, i64 %p2)
br label %L3462
L3462:
%t11276 = phi i64 [ %t11273, %L3460 ], [ %t11275, %L3461 ]
%t11277 = icmp eq i64 %t11271, %t11268
br label %LSL11278
LSL11278:
br i1 %t11277, label %LSR11278, label %LSJ11278
LSR11278:
%t11279 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t11280 = icmp eq i64 %t11276, %t11279
br label %LSJ11278
LSJ11278:
%t11281 = phi i1 [ false, %LSL11278 ], [ %t11280, %LSR11278 ]
br label %LSL11282
LSL11282:
br i1 %t11281, label %LSR11282, label %LSJ11282
LSR11282:
%t11283 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t11284 = xor i1 %t11283, true
br label %LSJ11282
LSJ11282:
%t11285 = phi i1 [ false, %LSL11282 ], [ %t11284, %LSR11282 ]
br i1 %t11285, label %L3463, label %L3465
L3463:
ret i64 %p0
L3465:
%t11286 = call i64 @xmalloc(i64 48)
%t11287 = call i64 @mcopy(i64 %t11286, i64 %p0, i64 48)
%t11288 = add i64 %t11286, 16
%t11289 = call i64 @st64(i64 %t11288, i64 %t11271)
%t11290 = add i64 %t11286, 8
%t11291 = call i64 @st64(i64 %t11290, i64 %t11276)
%t11292 = mul nsw i64 %t11291, 0
%t11293 = add nsw i64 %t11292, %t11286
ret i64 %t11293
}
define ptr @resid_map_evac(ptr %a0, i8 %a1, i8 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x1 = zext i8 %a1 to i64
%x2 = zext i8 %a2 to i64
%r = call i64 @rt_map_evac(i64 %x0i, i64 %x1, i64 %x2)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_map_resid__tab_evac(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11294 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t11295 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t11296 = icmp ne i64 %t11295, 0
br label %LSL11297
LSL11297:
br i1 %t11296, label %LSR11297, label %LSJ11297
LSR11297:
%t11298 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t11299 = call i1 @__mruntime_rt_map_resid__in_region(i64 %t11298)
br label %LSJ11297
LSJ11297:
%t11300 = phi i1 [ false, %LSL11297 ], [ %t11299, %LSR11297 ]
%t11301 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t11302 = icmp ne i64 %t11301, 0
br label %LSL11303
LSL11303:
br i1 %t11302, label %LSR11303, label %LSJ11303
LSR11303:
%t11304 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t11305 = call i1 @__mruntime_rt_map_resid__in_region(i64 %t11304)
br label %LSJ11303
LSJ11303:
%t11306 = phi i1 [ false, %LSL11303 ], [ %t11305, %LSR11303 ]
%t11307 = xor i1 %t11294, true
br label %LSL11308
LSL11308:
br i1 %t11307, label %LSR11308, label %LSJ11308
LSR11308:
%t11309 = xor i1 %t11300, true
br label %LSJ11308
LSJ11308:
%t11310 = phi i1 [ false, %LSL11308 ], [ %t11309, %LSR11308 ]
br label %LSL11311
LSL11311:
br i1 %t11310, label %LSR11311, label %LSJ11311
LSR11311:
%t11312 = xor i1 %t11306, true
br label %LSJ11311
LSJ11311:
%t11313 = phi i1 [ false, %LSL11311 ], [ %t11312, %LSR11311 ]
br i1 %t11313, label %L3466, label %L3468
L3466:
ret i64 %p0
L3468:
%t11314 = call i64 @xmalloc(i64 96)
%t11315 = call i64 @mcopy(i64 %t11314, i64 %p0, i64 96)
br i1 %t11300, label %L3469, label %L3470
L3469:
%t11316 = add i64 %t11314, 32
%t11317 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t11318 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t11319 = call i64 @__mruntime_rt_map_resid__dup_words(i64 %t11317, i64 %t11318)
%t11320 = call i64 @st64(i64 %t11316, i64 %t11319)
br label %L3471
L3470:
br label %L3471
L3471:
%t11321 = phi i64 [ %t11320, %L3469 ], [ 0, %L3470 ]
br i1 %t11306, label %L3472, label %L3473
L3472:
%t11322 = add i64 %t11314, 40
%t11323 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t11324 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t11325 = call i64 @__mruntime_rt_map_resid__dup_words(i64 %t11323, i64 %t11324)
%t11326 = call i64 @st64(i64 %t11322, i64 %t11325)
br label %L3474
L3473:
br label %L3474
L3474:
%t11327 = phi i64 [ %t11326, %L3472 ], [ 0, %L3473 ]
%t11328 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %t11314)
%t11329 = icmp ne i64 %t11328, 0
br label %LSL11330
LSL11330:
br i1 %t11329, label %LSR11330, label %LSJ11330
LSR11330:
%t11331 = icmp eq i64 %p1, 4
br label %LSL11332
LSL11332:
br i1 %t11331, label %LSJ11332, label %LSR11332
LSR11332:
%t11333 = icmp sge i64 %p2, 4
br label %LSL11334
LSL11334:
br i1 %t11333, label %LSR11334, label %LSJ11334
LSR11334:
%t11335 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t11314)
%t11336 = icmp ne i64 %t11335, 0
br label %LSJ11334
LSJ11334:
%t11337 = phi i1 [ false, %LSL11334 ], [ %t11336, %LSR11334 ]
br label %LSJ11332
LSJ11332:
%t11338 = phi i1 [ true, %LSL11332 ], [ %t11337, %LSJ11334 ]
br label %LSJ11330
LSJ11330:
%t11339 = phi i1 [ false, %LSL11330 ], [ %t11338, %LSJ11332 ]
br i1 %t11339, label %L3475, label %L3476
L3475:
%t11340 = call i64 @__mruntime_rt_map_resid__tcap(i64 %t11314)
br label %LSL11341
LSL11341:
br i1 %t11300, label %LSR11341, label %LSJ11341
LSR11341:
%t11342 = icmp eq i64 %p1, 4
br label %LSJ11341
LSJ11341:
%t11343 = phi i1 [ false, %LSL11341 ], [ %t11342, %LSR11341 ]
br label %LSL11344
LSL11344:
br i1 %t11306, label %LSR11344, label %LSJ11344
LSR11344:
%t11345 = icmp sge i64 %p2, 4
br label %LSJ11344
LSJ11344:
%t11346 = phi i1 [ false, %LSL11344 ], [ %t11345, %LSR11344 ]
%t11347 = call i64 @__mruntime_rt_map_resid__keep_slots(i64 %t11314, i64 0, i64 %t11340, i1 %t11343, i1 %t11346, i64 %p2)
br label %L3477
L3476:
br label %L3477
L3477:
%t11348 = phi i64 [ %t11347, %LSJ11344 ], [ 0, %L3476 ]
ret i64 %t11314
}
define internal i64 @__mruntime_rt_map_resid__dup_words(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11349 = mul i64 %p1, 8
%t11350 = call i64 @xmalloc(i64 %t11349)
%t11351 = mul i64 %p1, 8
%t11352 = call i64 @mcopy(i64 %t11350, i64 %p0, i64 %t11351)
%t11353 = mul nsw i64 %t11352, 0
%t11354 = add nsw i64 %t11353, %t11350
ret i64 %t11354
}
define internal i64 @__mruntime_rt_map_resid__keep_slots(i64 %p0.in, i64 %p1.in, i64 %p2.in, i1 %p3.in, i1 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t11386, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i1 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i1 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t11355 = icmp sge i64 %p1, %p2
br i1 %t11355, label %L3478, label %L3480
L3478:
ret i64 0
L3480:
%t11356 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t11357 = mul i64 %p1, 8
%t11358 = add i64 %t11356, %t11357
%t11359 = call i64 @ld64(i64 %t11358)
%t11360 = call i64 @__mruntime_rt_map_resid__t_empty(i64 %p0)
%t11361 = icmp ne i64 %t11359, %t11360
br label %LSL11362
LSL11362:
br i1 %t11361, label %LSR11362, label %LSJ11362
LSR11362:
%t11363 = call i64 @__mruntime_rt_map_resid__t_tomb(i64 %p0)
%t11364 = icmp ne i64 %t11359, %t11363
br label %LSJ11362
LSJ11362:
%t11365 = phi i1 [ false, %LSL11362 ], [ %t11364, %LSR11362 ]
br label %LSL11366
LSL11366:
br i1 %t11365, label %LSR11366, label %LSJ11366
LSR11366:
br label %LSJ11366
LSJ11366:
%t11367 = phi i1 [ false, %LSL11366 ], [ %p3, %LSR11366 ]
br i1 %t11367, label %L3481, label %L3482
L3481:
%t11368 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t11369 = mul i64 %p1, 8
%t11370 = add i64 %t11368, %t11369
%t11371 = call i64 @__mruntime_rt_map_resid__word_keep(i64 4, i64 %t11359)
%t11372 = call i64 @st64(i64 %t11370, i64 %t11371)
br label %L3483
L3482:
br label %L3483
L3483:
%t11373 = phi i64 [ %t11372, %L3481 ], [ 0, %L3482 ]
br label %LSL11374
LSL11374:
br i1 %t11365, label %LSR11374, label %LSJ11374
LSR11374:
br label %LSJ11374
LSJ11374:
%t11375 = phi i1 [ false, %LSL11374 ], [ %p4, %LSR11374 ]
br i1 %t11375, label %L3484, label %L3485
L3484:
%t11376 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t11377 = mul i64 %p1, 8
%t11378 = add i64 %t11376, %t11377
%t11379 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t11380 = mul i64 %p1, 8
%t11381 = add i64 %t11379, %t11380
%t11382 = call i64 @ld64(i64 %t11381)
%t11383 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %p5, i64 %t11382)
%t11384 = call i64 @st64(i64 %t11378, i64 %t11383)
br label %L3486
L3485:
br label %L3486
L3486:
%t11385 = phi i64 [ %t11384, %L3484 ], [ 0, %L3485 ]
%t11386 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_alloc_resid__ast() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11388p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.rt_alloc)
%t11388 = ptrtoint ptr %t11388p to i64
ret i64 %t11388
}
define internal i64 @__mruntime_rt_alloc_resid__ag(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11389 = call i64 @__mruntime_rt_alloc_resid__ast()
%t11390 = mul i64 %p0, 8
%t11391 = add i64 %t11389, %t11390
%t11392 = tail call i64 @ld64(i64 %t11391)
ret i64 %t11392
}
define internal i64 @__mruntime_rt_alloc_resid__as_(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11393 = call i64 @__mruntime_rt_alloc_resid__ast()
%t11394 = mul i64 %p0, 8
%t11395 = add i64 %t11393, %t11394
%t11396 = tail call i64 @st64(i64 %t11395, i64 %p1)
ret i64 %t11396
}
define internal i64 @__mruntime_rt_alloc_resid__arena_chunk_size() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 4194304
}
define internal i64 @__mruntime_rt_alloc_resid__scope_chunk_size() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 1048576
}
define internal i64 @__mruntime_rt_alloc_resid__arena_new(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11397 = call i64 @xmalloc(i64 24)
%t11398 = call i64 @st64(i64 %t11397, i64 0)
%t11399 = add i64 %t11397, 8
%t11400 = call i64 @st64(i64 %t11399, i64 0)
%t11401 = add i64 %t11398, %t11400
%t11402 = add i64 %t11397, 16
%t11403 = call i64 @st64(i64 %t11402, i64 %p0)
%t11404 = mul nsw i64 %t11403, 0
%t11405 = add nsw i64 %t11404, %t11397
ret i64 %t11405
}
define internal i64 @__mruntime_rt_alloc_resid__free_chunks(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t11408, %tco.s0 ]
%t11406 = icmp eq i64 %p0, 0
br i1 %t11406, label %L3487, label %L3489
L3487:
ret i64 0
L3489:
%t11407 = add i64 %p0, 16
%t11408 = call i64 @ld64(i64 %t11407)
%t11409 = call i64 @c_free(i64 %p0)
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_arena_push() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11411 = call i64 @__mruntime_rt_alloc_resid__ag(i64 0)
%t11412 = call i64 @__mruntime_rt_alloc_resid__arena_new(i64 %t11411)
%t11413 = call i64 @__mruntime_rt_alloc_resid__as_(i64 0, i64 %t11412)
%t11414 = mul nsw i64 %t11413, 0
ret i64 %t11414
}
define i64 @resid_arena_push() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_arena_push()
ret i64 %r
}
define internal i64 @rt_arena_pop() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11415 = call i64 @__mruntime_rt_alloc_resid__ag(i64 0)
%t11416 = icmp eq i64 %t11415, 0
br i1 %t11416, label %L3490, label %L3492
L3490:
%t11418 = call i64 @rt_abort(ptr @.s11417)
ret i64 %t11418
L3492:
%t11419 = call i64 @rt_str_index_popped()
%t11420 = call i64 @ld64(i64 %t11415)
%t11421 = call i64 @__mruntime_rt_alloc_resid__free_chunks(i64 %t11420)
%t11422 = add i64 %t11415, 16
%t11423 = call i64 @ld64(i64 %t11422)
%t11424 = call i64 @__mruntime_rt_alloc_resid__as_(i64 0, i64 %t11423)
%t11425 = call i64 @c_free(i64 %t11415)
%t11426 = mul nsw i64 %t11425, 0
ret i64 %t11426
}
define i64 @resid_arena_pop() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_arena_pop()
ret i64 %r
}
define internal i64 @__mruntime_rt_alloc_resid__arena_bump(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11427 = add i64 %p1, 15
%t11428 = sub nsw i64 0, 16
%t11429 = and i64 %t11427, %t11428
%t11430 = add i64 %p0, 8
%t11431 = call i64 @ld64(i64 %t11430)
%t11432 = icmp eq i64 %t11431, 0
br label %LSL11433
LSL11433:
br i1 %t11432, label %LSJ11433, label %LSR11433
LSR11433:
%t11434 = add i64 %t11431, 8
%t11435 = call i64 @ld64(i64 %t11434)
%t11436 = add i64 %t11435, %t11429
%t11437 = call i64 @ld64(i64 %t11431)
%t11438 = icmp sgt i64 %t11436, %t11437
br label %LSJ11433
LSJ11433:
%t11439 = phi i1 [ true, %LSL11433 ], [ %t11438, %LSR11433 ]
br i1 %t11439, label %L3493, label %L3495
L3493:
%t11440 = call i64 @__mruntime_rt_alloc_resid__arena_chunk_size()
%t11441 = icmp sgt i64 %t11440, %t11429
br i1 %t11441, label %L3496, label %L3497
L3496:
br label %L3498
L3497:
br label %L3498
L3498:
%t11442 = phi i64 [ %t11440, %L3496 ], [ %t11429, %L3497 ]
%t11443 = add i64 24, %t11442
%t11444 = call i64 @xmalloc(i64 %t11443)
%t11445 = call i64 @st64(i64 %t11444, i64 %t11442)
%t11446 = add i64 %t11444, 8
%t11447 = call i64 @st64(i64 %t11446, i64 0)
%t11448 = add i64 %t11445, %t11447
%t11449 = add i64 %t11444, 16
%t11450 = call i64 @ld64(i64 %p0)
%t11451 = call i64 @st64(i64 %t11449, i64 %t11450)
%t11452 = add i64 %t11448, %t11451
%t11453 = call i64 @st64(i64 %p0, i64 %t11444)
%t11454 = add i64 %p0, 8
%t11455 = call i64 @st64(i64 %t11454, i64 %t11444)
%t11456 = add i64 %t11453, %t11455
%t11457 = tail call i64 @__mruntime_rt_alloc_resid__bump_in(i64 %t11444, i64 %t11429)
ret i64 %t11457
L3495:
%t11458 = tail call i64 @__mruntime_rt_alloc_resid__bump_in(i64 %t11431, i64 %t11429)
ret i64 %t11458
}
define internal i64 @__mruntime_rt_alloc_resid__bump_in(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11459 = add i64 %p0, 8
%t11460 = call i64 @ld64(i64 %t11459)
%t11461 = add i64 %p0, 8
%t11462 = add i64 %t11460, %p1
%t11463 = call i64 @st64(i64 %t11461, i64 %t11462)
%t11464 = add i64 %p0, 24
%t11465 = add i64 %t11464, %t11460
ret i64 %t11465
}
define internal i1 @__mruntime_rt_alloc_resid__chain_contains(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11466 = icmp eq i64 %p0, 0
br i1 %t11466, label %L3499, label %L3501
L3499:
ret i1 false
L3501:
%t11467 = call i64 @ld64(i64 %p0)
%t11468 = call i1 @__mruntime_rt_alloc_resid__chunks_contain(i64 %t11467, i64 %p1)
br label %LSL11469
LSL11469:
br i1 %t11468, label %LSJ11469, label %LSR11469
LSR11469:
%t11470 = add i64 %p0, 16
%t11471 = call i64 @ld64(i64 %t11470)
%t11472 = call i1 @__mruntime_rt_alloc_resid__chain_contains(i64 %t11471, i64 %p1)
br label %LSJ11469
LSJ11469:
%t11473 = phi i1 [ true, %LSL11469 ], [ %t11472, %LSR11469 ]
ret i1 %t11473
}
define internal i1 @__mruntime_rt_alloc_resid__chunks_contain(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t11485, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%t11474 = icmp eq i64 %p0, 0
br i1 %t11474, label %L3502, label %L3504
L3502:
ret i1 false
L3504:
%t11475 = add i64 %p0, 24
%t11476 = call i1 @ult(i64 %p1, i64 %t11475)
%t11477 = xor i1 %t11476, true
br label %LSL11478
LSL11478:
br i1 %t11477, label %LSR11478, label %LSJ11478
LSR11478:
%t11479 = add i64 %p0, 24
%t11480 = call i64 @ld64(i64 %p0)
%t11481 = add i64 %t11479, %t11480
%t11482 = call i1 @ult(i64 %p1, i64 %t11481)
br label %LSJ11478
LSJ11478:
%t11483 = phi i1 [ false, %LSL11478 ], [ %t11482, %LSR11478 ]
br i1 %t11483, label %L3505, label %L3507
L3505:
ret i1 true
L3507:
%t11484 = add i64 %p0, 16
%t11485 = call i64 @ld64(i64 %t11484)
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_alloc_resid__scope_contains(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11487 = call i64 @__mruntime_rt_alloc_resid__ag(i64 5)
%t11488 = call i1 @__mruntime_rt_alloc_resid__scope_chunks_contain(i64 %t11487, i64 %p0)
ret i1 %t11488
}
define internal i1 @__mruntime_rt_alloc_resid__scope_chunks_contain(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t11500, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%t11489 = icmp eq i64 %p0, 0
br i1 %t11489, label %L3508, label %L3510
L3508:
ret i1 false
L3510:
%t11490 = add i64 %p0, 16
%t11491 = call i1 @ult(i64 %p1, i64 %t11490)
%t11492 = xor i1 %t11491, true
br label %LSL11493
LSL11493:
br i1 %t11492, label %LSR11493, label %LSJ11493
LSR11493:
%t11494 = add i64 %p0, 16
%t11495 = add i64 %p0, 8
%t11496 = call i64 @ld64(i64 %t11495)
%t11497 = add i64 %t11494, %t11496
%t11498 = call i1 @ult(i64 %p1, i64 %t11497)
br label %LSJ11493
LSJ11493:
%t11499 = phi i1 [ false, %LSL11493 ], [ %t11498, %LSR11493 ]
br i1 %t11499, label %L3511, label %L3513
L3511:
ret i1 true
L3513:
%t11500 = call i64 @ld64(i64 %p0)
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_arena_contains_x(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11502 = call i64 @__mruntime_rt_alloc_resid__ag(i64 0)
%t11503 = call i1 @__mruntime_rt_alloc_resid__chain_contains(i64 %t11502, i64 %p0)
br label %LSL11504
LSL11504:
br i1 %t11503, label %LSJ11504, label %LSR11504
LSR11504:
%t11505 = call i64 @__mruntime_rt_alloc_resid__ag(i64 1)
%t11506 = call i1 @__mruntime_rt_alloc_resid__chain_contains(i64 %t11505, i64 %p0)
br label %LSJ11504
LSJ11504:
%t11507 = phi i1 [ true, %LSL11504 ], [ %t11506, %LSR11504 ]
br label %LSL11508
LSL11508:
br i1 %t11507, label %LSJ11508, label %LSR11508
LSR11508:
%t11509 = call i1 @__mruntime_rt_alloc_resid__scope_contains(i64 %p0)
br label %LSJ11508
LSJ11508:
%t11510 = phi i1 [ true, %LSL11508 ], [ %t11509, %LSR11508 ]
br i1 %t11510, label %L3514, label %L3515
L3514:
br label %L3516
L3515:
br label %L3516
L3516:
%t11511 = phi i64 [ 1, %L3514 ], [ 0, %L3515 ]
ret i64 %t11511
}
define i8 @resid_rt_arena_contains(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_arena_contains_x(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_bulk_push() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11512 = call i64 @__mruntime_rt_alloc_resid__ag(i64 1)
%t11513 = call i64 @__mruntime_rt_alloc_resid__arena_new(i64 %t11512)
%t11514 = call i64 @__mruntime_rt_alloc_resid__as_(i64 1, i64 %t11513)
%t11515 = tail call i64 @rt_arena_push()
ret i64 %t11515
}
define i64 @resid_bulk_push() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_bulk_push()
ret i64 %r
}
define internal i64 @rt_bulk_pop() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11516 = call i64 @rt_arena_pop()
%t11517 = call i64 @__mruntime_rt_alloc_resid__ag(i64 1)
%t11518 = icmp eq i64 %t11517, 0
br i1 %t11518, label %L3517, label %L3519
L3517:
%t11520 = call i64 @rt_abort(ptr @.s11519)
ret i64 %t11520
L3519:
%t11521 = call i64 @rt_str_index_popped()
%t11522 = call i64 @ld64(i64 %t11517)
%t11523 = call i64 @__mruntime_rt_alloc_resid__free_chunks(i64 %t11522)
%t11524 = add i64 %t11517, 16
%t11525 = call i64 @ld64(i64 %t11524)
%t11526 = call i64 @__mruntime_rt_alloc_resid__as_(i64 1, i64 %t11525)
%t11527 = call i64 @c_free(i64 %t11517)
%t11528 = call i64 @__mruntime_rt_alloc_resid__ag(i64 1)
%t11529 = icmp eq i64 %t11528, 0
br i1 %t11529, label %L3520, label %L3521
L3520:
%t11530 = call i64 @c_malloc_trim(i64 0)
%t11531 = mul nsw i64 %t11530, 0
br label %L3522
L3521:
br label %L3522
L3522:
%t11532 = phi i64 [ %t11531, %L3520 ], [ 0, %L3521 ]
ret i64 %t11532
}
define i64 @resid_bulk_pop() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_bulk_pop()
ret i64 %r
}
define internal i64 @__mruntime_rt_alloc_resid__sc_once() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11533p = getelementptr i8, ptr @rtg.rt_sc_once, i64 0
%t11533 = ptrtoint ptr %t11533p to i64
ret i64 %t11533
}
define internal i64 @__mruntime_rt_alloc_resid__sc_key() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11534p = getelementptr i8, ptr @rtg.rt_sc_key, i64 0
%t11534 = ptrtoint ptr %t11534p to i64
ret i64 %t11534
}
define internal i64 @scope_thread_exit(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11535 = call i64 @__mruntime_rt_alloc_resid__ag(i64 10)
%t11536 = call i64 @__mruntime_rt_alloc_resid__free_pool(i64 %t11535)
%t11537 = call i64 @__mruntime_rt_alloc_resid__as_(i64 10, i64 0)
%t11538 = call i64 @__mruntime_rt_alloc_resid__as_(i64 11, i64 0)
%t11539 = add i64 %t11537, %t11538
%t11540 = call i64 @__mruntime_rt_alloc_resid__ag(i64 8)
%t11541 = call i64 @c_free(i64 %t11540)
%t11542 = call i64 @__mruntime_rt_alloc_resid__as_(i64 8, i64 0)
%t11543 = call i64 @__mruntime_rt_alloc_resid__as_(i64 9, i64 0)
%t11544 = add i64 %t11542, %t11543
ret i64 %t11544
}
define internal i64 @__mruntime_rt_alloc_resid__free_pool(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t11546, %tco.s0 ]
%t11545 = icmp eq i64 %p0, 0
br i1 %t11545, label %L3523, label %L3525
L3523:
ret i64 0
L3525:
%t11546 = call i64 @ld64(i64 %p0)
%t11547 = call i64 @c_free(i64 %p0)
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @scope_key_init() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11549 = call i64 @__mruntime_rt_alloc_resid__sc_key()
%t11550 = ptrtoint ptr @scope_thread_exit to i64
%t11551 = call i64 @c_pthread_key_create(i64 %t11549, i64 %t11550)
ret i64 %t11551
}
define internal i64 @__mruntime_rt_alloc_resid__marks_grow() noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11552 = call i64 @__mruntime_rt_alloc_resid__ag(i64 9)
%t11553 = icmp ne i64 %t11552, 0
br i1 %t11553, label %L3526, label %L3527
L3526:
%t11554 = call i64 @__mruntime_rt_alloc_resid__ag(i64 9)
%t11555 = mul i64 %t11554, 2
br label %L3528
L3527:
br label %L3528
L3528:
%t11556 = phi i64 [ %t11555, %L3526 ], [ 64, %L3527 ]
%t11557 = call i64 @__mruntime_rt_alloc_resid__ag(i64 8)
%t11558 = mul i64 %t11556, 16
%t11559 = call i64 @xrealloc(i64 %t11557, i64 %t11558)
%t11560 = call i64 @__mruntime_rt_alloc_resid__as_(i64 8, i64 %t11559)
%t11561 = call i64 @__mruntime_rt_alloc_resid__as_(i64 9, i64 %t11556)
%t11562 = call i64 @__mruntime_rt_alloc_resid__ag(i64 12)
%t11563 = icmp ne i64 %t11562, 0
br i1 %t11563, label %L3529, label %L3531
L3529:
ret i64 0
L3531:
%t11564 = call i64 @__mruntime_rt_alloc_resid__sc_once()
%t11565 = ptrtoint ptr @scope_key_init to i64
%t11566 = call i64 @c_pthread_once(i64 %t11564, i64 %t11565)
%t11567 = call i64 @__mruntime_rt_alloc_resid__sc_key()
%t11568 = call i64 @ld32(i64 %t11567)
%t11569 = call i64 @c_pthread_setspecific(i64 %t11568, i64 1)
%t11570 = call i64 @__mruntime_rt_alloc_resid__as_(i64 12, i64 1)
ret i64 %t11570
}
define internal i64 @rt_scope_push() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11571 = call i64 @__mruntime_rt_alloc_resid__ag(i64 4)
%t11572 = call i64 @__mruntime_rt_alloc_resid__ag(i64 9)
%t11573 = icmp eq i64 %t11571, %t11572
br i1 %t11573, label %L3532, label %L3533
L3532:
%t11574 = call i64 @__mruntime_rt_alloc_resid__marks_grow()
br label %L3534
L3533:
br label %L3534
L3534:
%t11575 = phi i64 [ %t11574, %L3532 ], [ 0, %L3533 ]
%t11576 = call i64 @__mruntime_rt_alloc_resid__ag(i64 8)
%t11577 = mul i64 %t11571, 16
%t11578 = add i64 %t11576, %t11577
%t11579 = call i64 @__mruntime_rt_alloc_resid__ag(i64 5)
%t11580 = call i64 @st64(i64 %t11578, i64 %t11579)
%t11581 = add i64 %t11578, 8
%t11582 = call i64 @__mruntime_rt_alloc_resid__ag(i64 6)
%t11583 = call i64 @st64(i64 %t11581, i64 %t11582)
%t11584 = add i64 %t11580, %t11583
%t11585 = add i64 %t11571, 1
%t11586 = call i64 @__mruntime_rt_alloc_resid__as_(i64 4, i64 %t11585)
%t11587 = mul nsw i64 %t11586, 0
%t11588 = add nsw i64 %t11587, %t11571
ret i64 %t11588
}
define i64 @resid_scope_push() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_scope_push()
ret i64 %r
}
define internal i64 @__mruntime_rt_alloc_resid__chunk_release(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11589 = add i64 %p0, 8
%t11590 = call i64 @ld64(i64 %t11589)
%t11591 = call i64 @__mruntime_rt_alloc_resid__scope_chunk_size()
%t11592 = icmp eq i64 %t11590, %t11591
br label %LSL11593
LSL11593:
br i1 %t11592, label %LSR11593, label %LSJ11593
LSR11593:
%t11594 = call i64 @__mruntime_rt_alloc_resid__ag(i64 11)
%t11595 = icmp slt i64 %t11594, 16
br label %LSJ11593
LSJ11593:
%t11596 = phi i1 [ false, %LSL11593 ], [ %t11595, %LSR11593 ]
br i1 %t11596, label %L3535, label %L3537
L3535:
%t11597 = call i64 @__mruntime_rt_alloc_resid__ag(i64 10)
%t11598 = call i64 @st64(i64 %p0, i64 %t11597)
%t11599 = call i64 @__mruntime_rt_alloc_resid__as_(i64 10, i64 %p0)
%t11600 = call i64 @__mruntime_rt_alloc_resid__ag(i64 11)
%t11601 = add i64 %t11600, 1
%t11602 = call i64 @__mruntime_rt_alloc_resid__as_(i64 11, i64 %t11601)
%t11603 = add i64 %t11599, %t11602
ret i64 %t11603
L3537:
%t11604 = tail call i64 @c_free(i64 %p0)
ret i64 %t11604
}
define internal i64 @__mruntime_rt_alloc_resid__release_to(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%t11605 = call i64 @__mruntime_rt_alloc_resid__ag(i64 5)
%t11606 = icmp eq i64 %t11605, %p0
br i1 %t11606, label %L3538, label %L3540
L3538:
ret i64 0
L3540:
%t11607 = call i64 @__mruntime_rt_alloc_resid__ag(i64 5)
%t11608 = call i64 @ld64(i64 %t11607)
%t11609 = call i64 @__mruntime_rt_alloc_resid__as_(i64 5, i64 %t11608)
%t11610 = call i64 @__mruntime_rt_alloc_resid__chunk_release(i64 %t11607)
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_scope_pop(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11612 = icmp slt i64 %p0, 0
br label %LSL11613
LSL11613:
br i1 %t11612, label %LSJ11613, label %LSR11613
LSR11613:
%t11614 = call i64 @__mruntime_rt_alloc_resid__ag(i64 4)
%t11615 = icmp sge i64 %p0, %t11614
br label %LSJ11613
LSJ11613:
%t11616 = phi i1 [ true, %LSL11613 ], [ %t11615, %LSR11613 ]
br i1 %t11616, label %L3541, label %L3543
L3541:
ret i64 0
L3543:
%t11617 = call i64 @__mruntime_rt_alloc_resid__ag(i64 8)
%t11618 = mul i64 %p0, 16
%t11619 = add i64 %t11617, %t11618
%t11620 = call i64 @ld64(i64 %t11619)
%t11621 = add i64 %t11619, 8
%t11622 = call i64 @ld64(i64 %t11621)
%t11623 = call i64 @__mruntime_rt_alloc_resid__as_(i64 4, i64 %p0)
%t11624 = call i64 @__mruntime_rt_alloc_resid__ag(i64 6)
%t11625 = icmp eq i64 %t11624, %t11622
br i1 %t11625, label %L3544, label %L3546
L3544:
ret i64 0
L3546:
%t11626 = call i64 @__mruntime_rt_alloc_resid__release_to(i64 %t11620)
%t11627 = call i64 @__mruntime_rt_alloc_resid__as_(i64 6, i64 %t11622)
%t11628 = icmp ne i64 %t11620, 0
br i1 %t11628, label %L3547, label %L3548
L3547:
%t11629 = add i64 %t11620, 16
%t11630 = add i64 %t11620, 8
%t11631 = call i64 @ld64(i64 %t11630)
%t11632 = add i64 %t11629, %t11631
br label %L3549
L3548:
br label %L3549
L3549:
%t11633 = phi i64 [ %t11632, %L3547 ], [ 0, %L3548 ]
%t11634 = call i64 @__mruntime_rt_alloc_resid__as_(i64 7, i64 %t11633)
%t11635 = call i64 @rt_str_index_popped()
ret i64 %t11635
}
define void @resid_scope_pop(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_scope_pop(i64 %a0)
ret void
}
define internal i64 @__mruntime_rt_alloc_resid__scope_alloc_slow(i64 %p0) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11636 = call i64 @__mruntime_rt_alloc_resid__scope_chunk_size()
%t11637 = sdiv i64 %t11636, 4
%t11638 = icmp sgt i64 %p0, %t11637
br i1 %t11638, label %L3550, label %L3551
L3550:
%t11639 = call i64 @__mruntime_rt_alloc_resid__own_chunk(i64 %p0)
br label %L3552
L3551:
%t11640 = call i64 @__mruntime_rt_alloc_resid__ag(i64 10)
%t11641 = icmp ne i64 %t11640, 0
br i1 %t11641, label %L3553, label %L3554
L3553:
%t11642 = call i64 @__mruntime_rt_alloc_resid__pool_chunk()
br label %L3555
L3554:
%t11643 = call i64 @__mruntime_rt_alloc_resid__scope_chunk_size()
%t11644 = call i64 @__mruntime_rt_alloc_resid__own_chunk(i64 %t11643)
br label %L3555
L3555:
%t11645 = phi i64 [ %t11642, %L3553 ], [ %t11644, %L3554 ]
br label %L3552
L3552:
%t11646 = phi i64 [ %t11639, %L3550 ], [ %t11645, %L3555 ]
%t11647 = call i64 @__mruntime_rt_alloc_resid__ag(i64 5)
%t11648 = call i64 @st64(i64 %t11646, i64 %t11647)
%t11649 = call i64 @__mruntime_rt_alloc_resid__as_(i64 5, i64 %t11646)
%t11650 = add i64 %t11646, 16
%t11651 = add i64 %t11650, %p0
%t11652 = call i64 @__mruntime_rt_alloc_resid__as_(i64 6, i64 %t11651)
%t11653 = add i64 %t11646, 16
%t11654 = add i64 %t11646, 8
%t11655 = call i64 @ld64(i64 %t11654)
%t11656 = add i64 %t11653, %t11655
%t11657 = call i64 @__mruntime_rt_alloc_resid__as_(i64 7, i64 %t11656)
%t11658 = add i64 %t11646, 16
ret i64 %t11658
}
define internal i64 @__mruntime_rt_alloc_resid__own_chunk(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11659 = add i64 16, %p0
%t11660 = call i64 @xmalloc(i64 %t11659)
%t11661 = add i64 %t11660, 8
%t11662 = call i64 @st64(i64 %t11661, i64 %p0)
%t11663 = mul nsw i64 %t11662, 0
%t11664 = add nsw i64 %t11663, %t11660
ret i64 %t11664
}
define internal i64 @__mruntime_rt_alloc_resid__pool_chunk() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11665 = call i64 @__mruntime_rt_alloc_resid__ag(i64 10)
%t11666 = call i64 @ld64(i64 %t11665)
%t11667 = call i64 @__mruntime_rt_alloc_resid__as_(i64 10, i64 %t11666)
%t11668 = call i64 @__mruntime_rt_alloc_resid__ag(i64 11)
%t11669 = sub i64 %t11668, 1
%t11670 = call i64 @__mruntime_rt_alloc_resid__as_(i64 11, i64 %t11669)
%t11671 = mul nsw i64 %t11670, 0
%t11672 = add nsw i64 %t11671, %t11665
ret i64 %t11672
}
define internal i64 @scope_alloc(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11673 = add i64 %p0, 7
%t11674 = sub nsw i64 0, 8
%t11675 = and i64 %t11673, %t11674
%t11676 = call i64 @__mruntime_rt_alloc_resid__ag(i64 6)
%t11677 = and i64 %t11675, 8
%t11678 = icmp ne i64 %t11677, 0
br i1 %t11678, label %L3556, label %L3557
L3556:
br label %L3558
L3557:
%t11679 = and i64 %t11676, 8
br label %L3558
L3558:
%t11680 = phi i64 [ 0, %L3556 ], [ %t11679, %L3557 ]
%t11681 = icmp ne i64 %t11676, 0
br label %LSL11682
LSL11682:
br i1 %t11681, label %LSR11682, label %LSJ11682
LSR11682:
%t11683 = call i64 @__mruntime_rt_alloc_resid__ag(i64 7)
%t11684 = sub i64 %t11683, %t11676
%t11685 = add i64 %t11675, %t11680
%t11686 = icmp sge i64 %t11684, %t11685
br label %LSJ11682
LSJ11682:
%t11687 = phi i1 [ false, %LSL11682 ], [ %t11686, %LSR11682 ]
br i1 %t11687, label %L3559, label %L3561
L3559:
%t11688 = add i64 %t11676, %t11680
%t11689 = add i64 %t11688, %t11675
%t11690 = call i64 @__mruntime_rt_alloc_resid__as_(i64 6, i64 %t11689)
%t11691 = add i64 %t11676, %t11680
ret i64 %t11691
L3561:
%t11692 = add i64 %t11675, 15
%t11693 = sub nsw i64 0, 16
%t11694 = and i64 %t11692, %t11693
%t11695 = tail call i64 @__mruntime_rt_alloc_resid__scope_alloc_slow(i64 %t11694)
ret i64 %t11695
}
define internal i64 @suspend(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11696 = call i64 @__mruntime_rt_alloc_resid__ag(i64 0)
%t11697 = call i64 @st64(i64 %p0, i64 %t11696)
%t11698 = add i64 %p0, 8
%t11699 = call i64 @__mruntime_rt_alloc_resid__ag(i64 1)
%t11700 = call i64 @st64(i64 %t11698, i64 %t11699)
%t11701 = add i64 %t11697, %t11700
%t11702 = add i64 %p0, 16
%t11703 = call i64 @__mruntime_rt_alloc_resid__ag(i64 4)
%t11704 = call i64 @st64(i64 %t11702, i64 %t11703)
%t11705 = add i64 %t11701, %t11704
%t11706 = call i64 @__mruntime_rt_alloc_resid__as_(i64 0, i64 0)
%t11707 = call i64 @__mruntime_rt_alloc_resid__as_(i64 1, i64 0)
%t11708 = add i64 %t11706, %t11707
%t11709 = call i64 @__mruntime_rt_alloc_resid__as_(i64 4, i64 0)
%t11710 = add i64 %t11708, %t11709
ret i64 %t11710
}
define internal i64 @resume(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11711 = call i64 @ld64(i64 %p0)
%t11712 = call i64 @__mruntime_rt_alloc_resid__as_(i64 0, i64 %t11711)
%t11713 = add i64 %p0, 8
%t11714 = call i64 @ld64(i64 %t11713)
%t11715 = call i64 @__mruntime_rt_alloc_resid__as_(i64 1, i64 %t11714)
%t11716 = add i64 %t11712, %t11715
%t11717 = add i64 %p0, 16
%t11718 = call i64 @ld64(i64 %t11717)
%t11719 = call i64 @__mruntime_rt_alloc_resid__as_(i64 4, i64 %t11718)
%t11720 = add i64 %t11716, %t11719
ret i64 %t11720
}
define internal i64 @rt_gmalloc(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11721 = call i64 @__mruntime_rt_alloc_resid__ag(i64 2)
%t11722 = add i64 %t11721, %p0
%t11723 = call i64 @__mruntime_rt_alloc_resid__as_(i64 2, i64 %t11722)
%t11724 = call i64 @__mruntime_rt_alloc_resid__ag(i64 4)
%t11725 = icmp ne i64 %t11724, 0
br i1 %t11725, label %L3562, label %L3564
L3562:
%t11726 = tail call i64 @scope_alloc(i64 %p0)
ret i64 %t11726
L3564:
%t11727 = tail call i64 @__mruntime_rt_alloc_resid__gmalloc_slow(i64 %p0)
ret i64 %t11727
}
define ptr @resid_gmalloc(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_gmalloc(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_alloc_resid__gmalloc_slow(i64 %p0) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11728 = call i64 @__mruntime_rt_alloc_resid__ag(i64 1)
%t11729 = icmp ne i64 %t11728, 0
br i1 %t11729, label %L3565, label %L3567
L3565:
%t11730 = call i64 @__mruntime_rt_alloc_resid__ag(i64 1)
%t11731 = call i64 @__mruntime_rt_alloc_resid__arena_bump(i64 %t11730, i64 %p0)
ret i64 %t11731
L3567:
%t11732 = tail call i64 @xmalloc(i64 %p0)
ret i64 %t11732
}
define internal i64 @rt_gfree(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11733 = call i64 @__mruntime_rt_alloc_resid__ag(i64 4)
%t11734 = icmp ne i64 %t11733, 0
br label %LSL11735
LSL11735:
br i1 %t11734, label %LSJ11735, label %LSR11735
LSR11735:
%t11736 = call i64 @__mruntime_rt_alloc_resid__ag(i64 1)
%t11737 = call i1 @__mruntime_rt_alloc_resid__chain_contains(i64 %t11736, i64 %p0)
br label %LSJ11735
LSJ11735:
%t11738 = phi i1 [ true, %LSL11735 ], [ %t11737, %LSR11735 ]
br i1 %t11738, label %L3568, label %L3570
L3568:
ret i64 0
L3570:
%t11739 = tail call i64 @c_free(i64 %p0)
ret i64 %t11739
}
define void @resid_gfree(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_gfree(i64 %x0i)
ret void
}
define internal i64 @rt_alloc_x(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11740 = call i64 @__mruntime_rt_alloc_resid__ag(i64 2)
%t11741 = add i64 %t11740, %p0
%t11742 = call i64 @__mruntime_rt_alloc_resid__as_(i64 2, i64 %t11741)
%t11743 = call i64 @__mruntime_rt_alloc_resid__ag(i64 4)
%t11744 = icmp ne i64 %t11743, 0
br i1 %t11744, label %L3571, label %L3573
L3571:
%t11745 = tail call i64 @scope_alloc(i64 %p0)
ret i64 %t11745
L3573:
%t11746 = tail call i64 @__mruntime_rt_alloc_resid__alloc_slow(i64 %p0)
ret i64 %t11746
}
define ptr @resid_rt_alloc(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_alloc_x(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_alloc_resid__alloc_slow(i64 %p0) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11747 = call i64 @__mruntime_rt_alloc_resid__ag(i64 0)
%t11748 = icmp ne i64 %t11747, 0
br i1 %t11748, label %L3574, label %L3576
L3574:
%t11749 = call i64 @__mruntime_rt_alloc_resid__ag(i64 0)
%t11750 = call i64 @__mruntime_rt_alloc_resid__arena_bump(i64 %t11749, i64 %p0)
ret i64 %t11750
L3576:
%t11751 = tail call i64 @xmalloc(i64 %p0)
ret i64 %t11751
}
define internal i64 @rt_outer_alloc(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11752 = call i64 @__mruntime_rt_alloc_resid__ag(i64 4)
%t11753 = call i64 @__mruntime_rt_alloc_resid__as_(i64 4, i64 0)
%t11754 = call i64 @rt_alloc_x(i64 %p0)
%t11755 = call i64 @__mruntime_rt_alloc_resid__as_(i64 4, i64 %t11752)
%t11756 = mul nsw i64 %t11755, 0
%t11757 = add nsw i64 %t11756, %t11754
ret i64 %t11757
}
define ptr @resid_rt_outer_alloc(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_outer_alloc(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_mem_mark() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11758 = call i64 @__mruntime_rt_alloc_resid__ag(i64 2)
%t11759 = call i64 @__mruntime_rt_alloc_resid__as_(i64 3, i64 %t11758)
%t11760 = mul nsw i64 %t11759, 0
ret i64 %t11760
}
define i64 @resid_mem_mark() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_mem_mark()
ret i64 %r
}
define internal i64 @rt_mem_since_mark() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11761 = call i64 @__mruntime_rt_alloc_resid__ag(i64 2)
%t11762 = call i64 @__mruntime_rt_alloc_resid__ag(i64 3)
%t11763 = sub i64 %t11761, %t11762
ret i64 %t11763
}
define i64 @resid_mem_since_mark() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_mem_since_mark()
ret i64 %r
}
define internal i64 @rt_sc_depth_x() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11764 = call i64 @__mruntime_rt_alloc_resid__ag(i64 4)
ret i64 %t11764
}
define i64 @resid_rt_sc_depth() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_sc_depth_x()
ret i64 %r
}
define internal i64 @rt_sc_depth_set_x(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11765 = call i64 @__mruntime_rt_alloc_resid__as_(i64 4, i64 %p0)
ret i64 %t11765
}
define void @resid_rt_sc_depth_set(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_sc_depth_set_x(i64 %a0)
ret void
}
define internal i64 @rt_in_scope_x(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11766 = call i1 @__mruntime_rt_alloc_resid__scope_contains(i64 %p0)
br i1 %t11766, label %L3577, label %L3578
L3577:
br label %L3579
L3578:
br label %L3579
L3579:
%t11767 = phi i64 [ 1, %L3577 ], [ 0, %L3578 ]
ret i64 %t11767
}
define i8 @resid_rt_in_scope(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_in_scope_x(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_scope_alloc_x(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11768 = tail call i64 @scope_alloc(i64 %p0)
ret i64 %t11768
}
define ptr @resid_rt_scope_alloc(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_scope_alloc_x(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_suspend_x(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11769 = tail call i64 @suspend(i64 %p0)
ret i64 %t11769
}
define void @resid_rt_suspend(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_suspend_x(i64 %x0i)
ret void
}
define internal i64 @rt_resume_x(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11770 = tail call i64 @resume(i64 %p0)
ret i64 %t11770
}
define void @resid_rt_resume(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_resume_x(i64 %x0i)
ret void
}
define internal i64 @rt_in_arenas_x(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11771 = tail call i64 @rt_arena_contains_x(i64 %p0)
ret i64 %t11771
}
define i8 @resid_rt_in_arenas(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_in_arenas_x(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @__mruntime_rt_alloc_resid__rec_tag() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11772 = shl i64 1380303070, 32
ret i64 %t11772
}
define internal i64 @rt_rec_new(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11773 = add i64 %p0, 8
%t11774 = call i64 @rt_gmalloc(i64 %t11773)
%t11775 = call i64 @__mruntime_rt_alloc_resid__rec_tag()
%t11776 = shl i64 %p0, 1
%t11777 = or i64 %t11775, %t11776
%t11778 = icmp ne i64 %p1, 0
br i1 %t11778, label %L3580, label %L3581
L3580:
br label %L3582
L3581:
br label %L3582
L3582:
%t11779 = phi i64 [ 1, %L3580 ], [ 0, %L3581 ]
%t11780 = or i64 %t11777, %t11779
%t11781 = call i64 @st64(i64 %t11774, i64 %t11780)
%t11782 = add i64 %t11774, 8
ret i64 %t11782
}
define ptr @resid_rec_new(i64 %a0, i8 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x1 = zext i8 %a1 to i64
%r = call i64 @rt_rec_new(i64 %a0, i64 %x1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_rec_reuse(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11783 = sub i64 %p0, 8
%t11784 = call i64 @ld64(i64 %t11783)
%t11785 = call i64 @__mruntime_rt_alloc_resid__rec_tag()
%t11786 = shl i64 %p1, 1
%t11787 = or i64 %t11785, %t11786
%t11788 = or i64 %t11787, 1
%t11789 = icmp eq i64 %t11784, %t11788
br i1 %t11789, label %L3583, label %L3585
L3583:
ret i64 %p0
L3585:
%t11790 = tail call i64 @rt_rec_new(i64 %p1, i64 1)
ret i64 %t11790
}
define ptr @resid_rec_reuse(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_rec_reuse(i64 %x0i, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_rec_share(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11791 = sub i64 %p0, 8
%t11792 = call i64 @ld64(i64 %t11791)
%t11793 = ashr i64 %t11792, 32
%t11794 = icmp eq i64 %t11793, 1380303070
br label %LSL11795
LSL11795:
br i1 %t11794, label %LSR11795, label %LSJ11795
LSR11795:
%t11796 = and i64 %t11792, 1
%t11797 = icmp ne i64 %t11796, 0
br label %LSJ11795
LSJ11795:
%t11798 = phi i1 [ false, %LSL11795 ], [ %t11797, %LSR11795 ]
br i1 %t11798, label %L3586, label %L3588
L3586:
%t11799 = sub i64 %p0, 8
%t11800 = sub nsw i64 0, 2
%t11801 = and i64 %t11792, %t11800
%t11802 = call i64 @st64(i64 %t11799, i64 %t11801)
ret i64 %t11802
L3588:
ret i64 0
}
define void @resid_rec_share(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_rec_share(i64 %x0i)
ret void
}
define internal i64 @rt_list_str_persist_copy(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11803 = call i64 @lcount(i64 %p0)
%t11804 = call i64 @rt_list_to_array(i64 %p0)
%t11805 = call i64 @__mruntime_rt_alloc_resid__ag(i64 0)
%t11806 = icmp ne i64 %t11805, 0
br i1 %t11806, label %L3589, label %L3590
L3589:
%t11807 = add i64 %t11805, 16
%t11808 = call i64 @ld64(i64 %t11807)
br label %L3591
L3590:
br label %L3591
L3591:
%t11809 = phi i64 [ %t11808, %L3589 ], [ 0, %L3590 ]
%t11810 = call i64 @__mruntime_rt_alloc_resid__as_(i64 0, i64 %t11809)
%t11811 = icmp sgt i64 %t11803, 1
br i1 %t11811, label %L3592, label %L3593
L3592:
br label %L3594
L3593:
br label %L3594
L3594:
%t11812 = phi i64 [ %t11803, %L3592 ], [ 1, %L3593 ]
%t11813 = mul i64 %t11812, 8
%t11814 = call i64 @xmalloc(i64 %t11813)
%t11815 = call i64 @__mruntime_rt_alloc_resid__copy_strs(i64 %t11804, i64 %t11814, i64 0, i64 %t11803)
%t11816 = call i64 @ltype(i64 %p0)
%t11817 = call i64 @rt_list_new(i64 %t11803, i64 %t11814, i64 %t11816)
%t11818 = call i64 @c_free(i64 %t11814)
%t11819 = call i64 @c_free(i64 %t11804)
%t11820 = add i64 %t11818, %t11819
%t11821 = call i64 @__mruntime_rt_alloc_resid__as_(i64 0, i64 %t11805)
%t11822 = mul nsw i64 %t11821, 0
%t11823 = add nsw i64 %t11822, %t11817
ret i64 %t11823
}
define ptr @resid_list_str_persist_copy(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_str_persist_copy(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_alloc_resid__copy_strs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t11836, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t11824 = icmp sge i64 %p2, %p3
br i1 %t11824, label %L3595, label %L3597
L3595:
ret i64 0
L3597:
%t11825 = mul i64 %p2, 8
%t11826 = add i64 %p0, %t11825
%t11827 = call i64 @ld64(i64 %t11826)
%t11828 = call i64 @c_strlen(i64 %t11827)
%t11829 = add i64 %t11828, 1
%t11830 = call i64 @rt_alloc_x(i64 %t11829)
%t11831 = add i64 %t11828, 1
%t11832 = call i64 @mcopy(i64 %t11830, i64 %t11827, i64 %t11831)
%t11833 = mul i64 %p2, 8
%t11834 = add i64 %p1, %t11833
%t11835 = call i64 @st64(i64 %t11834, i64 %t11830)
%t11836 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_decp_persist(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11838 = call i64 @__mruntime_rt_alloc_resid__ag(i64 1)
%t11839 = icmp eq i64 %t11838, 0
br i1 %t11839, label %L3598, label %L3600
L3598:
ret i64 %p0
L3600:
%t11840 = call i64 @dn(i64 %p0)
%t11841 = mul i64 %t11840, 8
%t11842 = add i64 24, %t11841
%t11843 = call i64 @__mruntime_rt_alloc_resid__ag(i64 2)
%t11844 = add i64 %t11843, %t11842
%t11845 = call i64 @__mruntime_rt_alloc_resid__as_(i64 2, i64 %t11844)
%t11846 = add i64 %t11838, 16
%t11847 = call i64 @ld64(i64 %t11846)
%t11848 = icmp ne i64 %t11847, 0
br i1 %t11848, label %L3601, label %L3602
L3601:
%t11849 = add i64 %t11838, 16
%t11850 = call i64 @ld64(i64 %t11849)
%t11851 = call i64 @__mruntime_rt_alloc_resid__arena_bump(i64 %t11850, i64 %t11842)
br label %L3603
L3602:
%t11852 = call i64 @xmalloc(i64 %t11842)
br label %L3603
L3603:
%t11853 = phi i64 [ %t11851, %L3601 ], [ %t11852, %L3602 ]
%t11854 = call i64 @mcopy(i64 %t11853, i64 %p0, i64 %t11842)
%t11855 = mul nsw i64 %t11854, 0
%t11856 = add nsw i64 %t11855, %t11853
ret i64 %t11856
}
define ptr @resid_decp_persist(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_decp_persist(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_alloc_resid__const_list(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11857 = call i64 @ld64(i64 %p0)
%t11858 = icmp ne i64 %t11857, 0
br i1 %t11858, label %L3604, label %L3606
L3604:
ret i64 %t11857
L3606:
%t11859 = call i64 @xmalloc(i64 24)
%t11860 = call i64 @suspend(i64 %t11859)
%t11861 = icmp eq i64 %p4, 2
br i1 %t11861, label %L3607, label %L3608
L3607:
br label %L3609
L3608:
%t11862 = icmp sgt i64 %p1, 1
br i1 %t11862, label %L3610, label %L3611
L3610:
br label %L3612
L3611:
br label %L3612
L3612:
%t11863 = phi i64 [ %p1, %L3610 ], [ 1, %L3611 ]
%t11864 = mul i64 %t11863, 8
%t11865 = call i64 @xmalloc(i64 %t11864)
br label %L3609
L3609:
%t11866 = phi i64 [ %p2, %L3607 ], [ %t11865, %L3612 ]
%t11867 = icmp eq i64 %p4, 2
br i1 %t11867, label %L3613, label %L3614
L3613:
br label %L3615
L3614:
%t11868 = call i64 @__mruntime_rt_alloc_resid__const_boxes(i64 %t11866, i64 %p2, i64 0, i64 %p1, i64 %p4)
br label %L3615
L3615:
%t11869 = phi i64 [ 0, %L3613 ], [ %t11868, %L3614 ]
%t11870 = call i64 @rt_list_new(i64 %p1, i64 %t11866, i64 %p3)
%t11871 = icmp eq i64 %p4, 2
br i1 %t11871, label %L3616, label %L3617
L3616:
br label %L3618
L3617:
%t11872 = call i64 @c_free(i64 %t11866)
br label %L3618
L3618:
%t11873 = phi i64 [ 0, %L3616 ], [ %t11872, %L3617 ]
%t11874 = call i64 @resume(i64 %t11859)
%t11875 = call i64 @c_free(i64 %t11859)
%t11876 = call i64 @st64(i64 %p0, i64 %t11870)
%t11877 = mul nsw i64 %t11876, 0
%t11878 = add nsw i64 %t11877, %t11870
ret i64 %t11878
}
define internal i64 @__mruntime_rt_alloc_resid__const_boxes(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t11894, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t11879 = icmp sge i64 %p2, %p3
br i1 %t11879, label %L3619, label %L3621
L3619:
ret i64 0
L3621:
%t11880 = icmp eq i64 %p4, 0
br i1 %t11880, label %L3622, label %L3623
L3622:
%t11881 = mul i64 %p2, 8
%t11882 = add i64 %p1, %t11881
%t11883 = call i64 @ld64(i64 %t11882)
%t11884 = call i64 @rt_box_i64(i64 %t11883)
br label %L3624
L3623:
%t11885 = add i64 %p1, %p2
%t11886 = call i64 @ld8(i64 %t11885)
%t11887 = icmp ne i64 %t11886, 0
br i1 %t11887, label %L3625, label %L3626
L3625:
br label %L3627
L3626:
br label %L3627
L3627:
%t11888 = phi i64 [ 1, %L3625 ], [ 0, %L3626 ]
%t11889 = call i64 @rt_box_bool(i64 %t11888)
br label %L3624
L3624:
%t11890 = phi i64 [ %t11884, %L3622 ], [ %t11889, %L3627 ]
%t11891 = mul i64 %p2, 8
%t11892 = add i64 %p0, %t11891
%t11893 = call i64 @st64(i64 %t11892, i64 %t11890)
%t11894 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_const_i64(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11896 = call i64 @__mruntime_rt_alloc_resid__const_list(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0)
ret i64 %t11896
}
define ptr @resid_list_const_i64(ptr %a0, i64 %a1, ptr %a2, ptr %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x2i = ptrtoint ptr %a2 to i64
%x3i = ptrtoint ptr %a3 to i64
%r = call i64 @rt_list_const_i64(i64 %x0i, i64 %a1, i64 %x2i, i64 %x3i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_list_const_bool(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11897 = call i64 @__mruntime_rt_alloc_resid__const_list(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 1)
ret i64 %t11897
}
define ptr @resid_list_const_bool(ptr %a0, i64 %a1, ptr %a2, ptr %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x2i = ptrtoint ptr %a2 to i64
%x3i = ptrtoint ptr %a3 to i64
%r = call i64 @rt_list_const_bool(i64 %x0i, i64 %a1, i64 %x2i, i64 %x3i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_list_const_ptr(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11898 = call i64 @__mruntime_rt_alloc_resid__const_list(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 2)
ret i64 %t11898
}
define ptr @resid_list_const_ptr(ptr %a0, i64 %a1, ptr %a2, ptr %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%x2i = ptrtoint ptr %a2 to i64
%x3i = ptrtoint ptr %a3 to i64
%r = call i64 @rt_list_const_ptr(i64 %x0i, i64 %a1, i64 %x2i, i64 %x3i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_alloc_resid__imm_off() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 18295873486192640
}
define internal i64 @__mruntime_rt_alloc_resid__imm_min() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11899 = sub nsw i64 0, 18014398509481984
ret i64 %t11899
}
define internal i64 @__mruntime_rt_alloc_resid__imm_max() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 18014398509481983
}
define internal i64 @__mruntime_rt_alloc_resid__interned() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11900p = getelementptr i8, ptr @rtg.box_interned, i64 0
%t11900 = ptrtoint ptr %t11900p to i64
ret i64 %t11900
}
define internal i64 @__mruntime_rt_alloc_resid__intern_init() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11901 = call i64 @__mruntime_rt_alloc_resid__interned()
%t11903 = ptrtoint ptr @.s11902 to i64
%t11904 = call i64 @__mruntime_rt_alloc_resid__intern_one(i64 %t11901, i64 %t11903, i64 0)
%t11905 = add i64 %t11901, 32
%t11907 = ptrtoint ptr @.s11906 to i64
%t11908 = call i64 @__mruntime_rt_alloc_resid__intern_one(i64 %t11905, i64 %t11907, i64 1)
%t11909 = add i64 %t11901, 64
%t11911 = ptrtoint ptr @.s11910 to i64
%t11912 = call i64 @__mruntime_rt_alloc_resid__intern_one(i64 %t11909, i64 %t11911, i64 0)
ret i64 %t11901
}
define internal i64 @__mruntime_rt_alloc_resid__intern_one(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11913 = sub nsw i64 0, 1
%t11914 = call i64 @st32(i64 %p0, i64 %t11913)
%t11915 = add i64 %p0, 4
%t11916 = call i64 @st32(i64 %t11915, i64 1)
%t11917 = add i64 %t11914, %t11916
%t11918 = add i64 %p0, 16
%t11919 = add i64 %p0, 24
%t11920 = call i64 @st64(i64 %t11918, i64 %t11919)
%t11921 = add i64 %t11917, %t11920
%t11922 = add i64 %p0, 24
%t11923 = call i64 @st64(i64 %t11922, i64 %p2)
%t11924 = add i64 %t11921, %t11923
%t11925 = add i64 %p0, 8
%t11926 = call i64 @st64(i64 %t11925, i64 %p1)
ret i64 %t11926
}
define internal i64 @__mruntime_rt_alloc_resid__interned_ready() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11927 = call i64 @__mruntime_rt_alloc_resid__interned()
%t11928 = add i64 %t11927, 72
%t11929 = call i64 @ld64(i64 %t11928)
%t11930 = icmp eq i64 %t11929, 0
br i1 %t11930, label %L3628, label %L3629
L3628:
%t11931 = call i64 @__mruntime_rt_alloc_resid__intern_init()
br label %L3630
L3629:
br label %L3630
L3630:
%t11932 = phi i64 [ %t11931, %L3628 ], [ %t11927, %L3629 ]
ret i64 %t11932
}
define internal i1 @box_interned(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11933 = call i64 @__mruntime_rt_alloc_resid__interned()
%t11934 = call i1 @box_imm(i64 %p0)
br label %LSL11935
LSL11935:
br i1 %t11934, label %LSJ11935, label %LSR11935
LSR11935:
%t11936 = call i1 @box_fimm(i64 %p0)
br label %LSJ11935
LSJ11935:
%t11937 = phi i1 [ true, %LSL11935 ], [ %t11936, %LSR11935 ]
br label %LSL11938
LSL11938:
br i1 %t11937, label %LSJ11938, label %LSR11938
LSR11938:
%t11939 = call i1 @ult(i64 %p0, i64 %t11933)
%t11940 = xor i1 %t11939, true
br label %LSL11941
LSL11941:
br i1 %t11940, label %LSR11941, label %LSJ11941
LSR11941:
%t11942 = add i64 %t11933, 64
%t11943 = call i1 @ult(i64 %p0, i64 %t11942)
br label %LSJ11941
LSJ11941:
%t11944 = phi i1 [ false, %LSL11941 ], [ %t11943, %LSR11941 ]
br label %LSJ11938
LSJ11938:
%t11945 = phi i1 [ true, %LSL11938 ], [ %t11944, %LSJ11941 ]
br label %LSL11946
LSL11946:
br i1 %t11945, label %LSJ11946, label %LSR11946
LSR11946:
%t11947 = add i64 %t11933, 64
%t11948 = icmp eq i64 %p0, %t11947
br label %LSJ11946
LSJ11946:
%t11949 = phi i1 [ true, %LSL11946 ], [ %t11948, %LSR11946 ]
ret i1 %t11949
}
define internal i64 @rt_box_interned_x(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11950 = call i1 @box_interned(i64 %p0)
br i1 %t11950, label %L3631, label %L3632
L3631:
br label %L3633
L3632:
br label %L3633
L3633:
%t11951 = phi i64 [ 1, %L3631 ], [ 0, %L3632 ]
ret i64 %t11951
}
define i8 @resid_rt_box_interned(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_box_interned_x(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @__mruntime_rt_alloc_resid__scalar_box(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11952 = add i64 %p1, 7
%t11953 = sub nsw i64 0, 8
%t11954 = and i64 %t11952, %t11953
%t11955 = add i64 24, %t11954
%t11956 = call i64 @rt_alloc_x(i64 %t11955)
%t11957 = sub nsw i64 0, 1
%t11958 = call i64 @st32(i64 %t11956, i64 %t11957)
%t11959 = add i64 %t11956, 4
%t11960 = call i64 @st32(i64 %t11959, i64 1)
%t11961 = add i64 %t11958, %t11960
%t11962 = add i64 %t11956, 8
%t11963 = call i64 @st64(i64 %t11962, i64 %p0)
%t11964 = add i64 %t11961, %t11963
%t11965 = add i64 %t11956, 16
%t11966 = add i64 %t11956, 24
%t11967 = call i64 @st64(i64 %t11965, i64 %t11966)
%t11968 = mul nsw i64 %t11967, 0
%t11969 = add nsw i64 %t11968, %t11956
ret i64 %t11969
}
define internal i64 @rt_box_i64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11970 = call i64 @__mruntime_rt_alloc_resid__imm_min()
%t11971 = icmp sge i64 %p0, %t11970
br label %LSL11972
LSL11972:
br i1 %t11971, label %LSR11972, label %LSJ11972
LSR11972:
%t11973 = call i64 @__mruntime_rt_alloc_resid__imm_max()
%t11974 = icmp sle i64 %p0, %t11973
br label %LSJ11972
LSJ11972:
%t11975 = phi i1 [ false, %LSL11972 ], [ %t11974, %LSR11972 ]
br i1 %t11975, label %L3634, label %L3636
L3634:
%t11976 = call i64 @__mruntime_rt_alloc_resid__imm_off()
%t11977 = add i64 %p0, %t11976
ret i64 %t11977
L3636:
%t11979 = ptrtoint ptr @.s11978 to i64
%t11980 = call i64 @__mruntime_rt_alloc_resid__scalar_box(i64 %t11979, i64 8)
%t11981 = add i64 %t11980, 24
%t11982 = call i64 @st64(i64 %t11981, i64 %p0)
%t11983 = mul nsw i64 %t11982, 0
%t11984 = add nsw i64 %t11983, %t11980
ret i64 %t11984
}
define ptr @resid_box_i64(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_box_i64(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_unbox_i64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11985 = tail call i64 @unbox_word(i64 %p0)
ret i64 %t11985
}
define i64 @resid_unbox_i64(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_unbox_i64(i64 %x0i)
ret i64 %r
}
define internal i64 @rt_box_f64(double %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11986 = bitcast double %p0 to i64
%t11987 = call i1 @ult(i64 %t11986, i64 72057594037927936)
%t11988 = xor i1 %t11987, true
br i1 %t11988, label %L3637, label %L3639
L3637:
ret i64 %t11986
L3639:
%t11989 = icmp eq i64 %t11986, 0
br i1 %t11989, label %L3640, label %L3642
L3640:
%t11990 = call i64 @__mruntime_rt_alloc_resid__interned_ready()
%t11991 = add i64 %t11990, 64
ret i64 %t11991
L3642:
%t11993 = ptrtoint ptr @.s11992 to i64
%t11994 = call i64 @__mruntime_rt_alloc_resid__scalar_box(i64 %t11993, i64 8)
%t11995 = add i64 %t11994, 24
%t11996 = call i64 @st64(i64 %t11995, i64 %t11986)
%t11997 = mul nsw i64 %t11996, 0
%t11998 = add nsw i64 %t11997, %t11994
ret i64 %t11998
}
define ptr @resid_box_f64(double %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_box_f64(double %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal double @rt_unbox_f64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11999 = tail call double @unbox_float(i64 %p0)
ret double %t11999
}
define double @resid_unbox_f64(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call double @rt_unbox_f64(i64 %x0i)
ret double %r
}
define internal i64 @rt_box_bool(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t12000 = call i64 @sx8(i64 %p0)
%t12001 = icmp eq i64 %t12000, 0
br label %LSL12002
LSL12002:
br i1 %t12001, label %LSJ12002, label %LSR12002
LSR12002:
%t12003 = icmp eq i64 %t12000, 1
br label %LSJ12002
LSJ12002:
%t12004 = phi i1 [ true, %LSL12002 ], [ %t12003, %LSR12002 ]
br i1 %t12004, label %L3643, label %L3645
L3643:
%t12005 = call i64 @__mruntime_rt_alloc_resid__interned_ready()
%t12006 = mul i64 %t12000, 32
%t12007 = add i64 %t12005, %t12006
ret i64 %t12007
L3645:
%t12009 = ptrtoint ptr @.s12008 to i64
%t12010 = call i64 @__mruntime_rt_alloc_resid__scalar_box(i64 %t12009, i64 1)
%t12011 = add i64 %t12010, 24
%t12012 = call i64 @st8(i64 %t12011, i64 %t12000)
%t12013 = mul nsw i64 %t12012, 0
%t12014 = add nsw i64 %t12013, %t12010
ret i64 %t12014
}
define ptr @resid_box_bool(i8 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = zext i8 %a0 to i64
%r = call i64 @rt_box_bool(i64 %x0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_unbox_bool(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t12015 = add i64 %p0, 24
%t12016 = tail call i64 @ld8(i64 %t12015)
ret i64 %t12016
}
define i8 @resid_unbox_bool(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_unbox_bool(i64 %x0i)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_box_i128(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t12018 = ptrtoint ptr @.s12017 to i64
%t12019 = call i64 @__mruntime_rt_alloc_resid__scalar_box(i64 %t12018, i64 16)
%t12020 = add i64 %t12019, 24
%t12021 = add i128 %p0, 0
%t12022 = trunc i128 %t12021 to i64
%t12028 = call i64 @st64(i64 %t12020, i64 %t12022)
%t12029 = add i64 %t12019, 32
%t12030 = sext i64 64 to i128
%t12031 = icmp uge i128 %t12030, 128
%t12032 = add i128 %t12030, 0
%t12033 = select i1 %t12031, i128 127, i128 %t12032
%t12034 = ashr i128 %p0, %t12033
%t12035 = add i128 %t12034, 0
%t12036 = trunc i128 %t12035 to i64
%t12042 = call i64 @st64(i64 %t12029, i64 %t12036)
%t12043 = mul nsw i64 %t12042, 0
%t12044 = add nsw i64 %t12043, %t12019
ret i64 %t12044
}
define ptr @resid_box_i128(i128 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_box_i128(i128 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i128 @rt_unbox_i128(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t12045 = call i1 @box_imm(i64 %p0)
br i1 %t12045, label %L3646, label %L3648
L3646:
%t12046 = call i64 @imm_val(i64 %p0)
%t12047 = sext i64 %t12046 to i128
ret i128 %t12047
L3648:
%t12048 = add i64 %p0, 32
%t12049 = call i64 @ld64(i64 %t12048)
%t12050 = sext i64 %t12049 to i128
%t12051 = sext i64 64 to i128
%t12052 = icmp uge i128 %t12051, 128
%t12053 = add i128 %t12051, 0
%t12054 = shl i128 %t12050, %t12053
%t12055 = select i1 %t12052, i128 0, i128 %t12054
%t12056 = add i64 %p0, 24
%t12057 = call i64 @ld64(i64 %t12056)
%t12058 = sext i64 %t12057 to i128
%t12059 = and i128 %t12058, 18446744073709551615
%t12060 = or i128 %t12055, %t12059
ret i128 %t12060
}
define i128 @resid_unbox_i128(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i128 @rt_unbox_i128(i64 %x0i)
ret i128 %r
}
define internal i64 @rt_box_u128(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t12062 = ptrtoint ptr @.s12061 to i64
%t12063 = call i64 @__mruntime_rt_alloc_resid__scalar_box(i64 %t12062, i64 16)
%t12064 = add i64 %t12063, 24
%t12065 = add i128 %p0, 0
%t12066 = trunc i128 %t12065 to i64
%t12072 = call i64 @st64(i64 %t12064, i64 %t12066)
%t12073 = add i64 %t12063, 32
%t12074 = sext i64 64 to i128
%t12075 = icmp uge i128 %t12074, 128
%t12076 = add i128 %t12074, 0
%t12077 = select i1 %t12075, i128 127, i128 %t12076
%t12078 = ashr i128 %p0, %t12077
%t12079 = add i128 %t12078, 0
%t12080 = trunc i128 %t12079 to i64
%t12086 = call i64 @st64(i64 %t12073, i64 %t12080)
%t12087 = mul nsw i64 %t12086, 0
%t12088 = add nsw i64 %t12087, %t12063
ret i64 %t12088
}
define ptr @resid_box_u128(i128 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_box_u128(i128 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i128 @rt_unbox_u128(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t12089 = call i128 @rt_unbox_i128(i64 %p0)
ret i128 %t12089
}
define i128 @resid_unbox_u128(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i128 @rt_unbox_u128(i64 %x0i)
ret i128 %r
}
define internal i64 @check_address_space() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t12090p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.addr_probe)
%t12090 = ptrtoint ptr %t12090p to i64
%t12091 = call i64 @xmalloc(i64 1)
%t12092 = call i64 @xmalloc(i64 1048576)
%t12093 = or i64 %t12090, %t12091
%t12094 = or i64 %t12093, %t12092
%t12095 = call i64 @__mruntime_rt_alloc_resid__interned()
%t12096 = or i64 %t12094, %t12095
%t12098 = ptrtoint ptr @.s12097 to i64
%t12099 = or i64 %t12096, %t12098
%t12100 = call i64 @c_free(i64 %t12091)
%t12101 = call i64 @c_free(i64 %t12092)
%t12102 = add i64 %t12100, %t12101
%t12103 = call i1 @ult(i64 %t12099, i64 281474976710656)
%t12104 = xor i1 %t12103, true
br i1 %t12104, label %L3649, label %L3651
L3649:
%t12106 = ptrtoint ptr @.s12105 to i64
%t12107 = call i1 @write_all(i64 2, i64 %t12106, i64 50)
%t12108 = tail call i64 @c_libc_abort()
ret i64 %t12108
L3651:
ret i64 0
}
declare ptr @calloc(i64, i64)
declare ptr @realloc(ptr, i64)
declare i64 @strlen(ptr)
declare i32 @memcmp(ptr, ptr, i64)
declare ptr @memchr(ptr, i32, i64)
declare ptr @memmem(ptr, i64, ptr, i64)
declare i32 @strcmp(ptr, ptr)
declare ptr @strstr(ptr, ptr)
declare ptr @getenv(ptr)
declare double @strtod(ptr, ptr)
declare i32 @strncmp(ptr, ptr, i64)
declare i32 @fork()
declare i32 @execvp(ptr, ptr)
declare i32 @execv(ptr, ptr)
declare ptr @popen(ptr, ptr)
declare i32 @pclose(ptr)
declare ptr @fgets(ptr, i32, ptr)
declare i32 @pthread_create(ptr, ptr, ptr, ptr)
declare i32 @pthread_join(i64, ptr)
declare i32 @pthread_attr_init(ptr)
declare i32 @pthread_attr_setstacksize(ptr, i64)
declare i32 @pthread_attr_destroy(ptr)
declare i32 @strfromd(ptr, i64, ptr, double)
declare i32 @getaddrinfo(ptr, ptr, ptr, ptr)
declare void @freeaddrinfo(ptr)
declare void @abort() noreturn
declare void @longjmp(ptr, i32) noreturn
declare ptr @strchr(ptr, i32)
declare i32 @malloc_trim(i64)
declare i32 @pthread_key_create(ptr, ptr)
declare i32 @pthread_once(ptr, ptr)
declare i32 @pthread_setspecific(i32, ptr)
@.s15 = private unnamed_addr constant [14 x i8] c"out of memory\00"
@.s21 = private unnamed_addr constant [14 x i8] c"out of memory\00"
@.s102 = private unnamed_addr constant [2 x i8] c"\0A\00"
@rtg.iov = internal thread_local global [32 x i8] zeroinitializer, align 16
@.s111 = private unnamed_addr constant [2 x i8] c"\0A\00"
@rtg.rt_flags = internal global [24 x i8] zeroinitializer, align 16
@.s159 = private unnamed_addr constant [39 x i8] c"integer overflow in checked arithmetic\00"
@.s162 = private unnamed_addr constant [25 x i8] c"integer division by zero\00"
@.s165 = private unnamed_addr constant [32 x i8] c"numeric conversion out of range\00"
@.s177 = private unnamed_addr constant [31 x i8] c"wrapping_div: division by zero\00"
@.s194 = private unnamed_addr constant [32 x i8] c"wrapping_udiv: division by zero\00"
@.s285 = private unnamed_addr constant [30 x i8] c"checked_div: division by zero\00"
@.s299 = private unnamed_addr constant [31 x i8] c"checked_udiv: division by zero\00"
@rtg.cap_stack = internal thread_local global [16384 x i8] zeroinitializer, align 16
@rtg.cap_ns = internal thread_local global [256 x i8] zeroinitializer, align 16
@rtg.cap_depth = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s481 = private unnamed_addr constant [56 x i8] c"capability: sandbox nesting exceeds RESID_CAP_MAX_DEPTH\00"
@.s621 = private unnamed_addr constant [25 x i8] c"capability not granted: \00"
@.s623 = private unnamed_addr constant [9 x i8] c" (write)\00"
@.s625 = private unnamed_addr constant [1 x i8] c"\00"
@rtg.sacc_itoa = internal thread_local global [32 x i8] zeroinitializer, align 16
@rtg.from_code = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.str_slots = internal thread_local global [720 x i8] zeroinitializer, align 16
@rtg.str_state = internal thread_local global [40 x i8] zeroinitializer, align 16
@rtg.sb_cp = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s1392 = private unnamed_addr constant [1 x i8] c"\00"
@.s1405 = private unnamed_addr constant [1 x i8] c"\00"
@rtt.8615 = private unnamed_addr constant [2918 x i64] [i64 65, i64 97, i64 66, i64 98, i64 67, i64 99, i64 68, i64 100, i64 69, i64 101, i64 70, i64 102, i64 71, i64 103, i64 72, i64 104, i64 73, i64 105, i64 74, i64 106, i64 75, i64 107, i64 76, i64 108, i64 77, i64 109, i64 78, i64 110, i64 79, i64 111, i64 80, i64 112, i64 81, i64 113, i64 82, i64 114, i64 83, i64 115, i64 84, i64 116, i64 85, i64 117, i64 86, i64 118, i64 87, i64 119, i64 88, i64 120, i64 89, i64 121, i64 90, i64 122, i64 192, i64 224, i64 193, i64 225, i64 194, i64 226, i64 195, i64 227, i64 196, i64 228, i64 197, i64 229, i64 198, i64 230, i64 199, i64 231, i64 200, i64 232, i64 201, i64 233, i64 202, i64 234, i64 203, i64 235, i64 204, i64 236, i64 205, i64 237, i64 206, i64 238, i64 207, i64 239, i64 208, i64 240, i64 209, i64 241, i64 210, i64 242, i64 211, i64 243, i64 212, i64 244, i64 213, i64 245, i64 214, i64 246, i64 216, i64 248, i64 217, i64 249, i64 218, i64 250, i64 219, i64 251, i64 220, i64 252, i64 221, i64 253, i64 222, i64 254, i64 256, i64 257, i64 258, i64 259, i64 260, i64 261, i64 262, i64 263, i64 264, i64 265, i64 266, i64 267, i64 268, i64 269, i64 270, i64 271, i64 272, i64 273, i64 274, i64 275, i64 276, i64 277, i64 278, i64 279, i64 280, i64 281, i64 282, i64 283, i64 284, i64 285, i64 286, i64 287, i64 288, i64 289, i64 290, i64 291, i64 292, i64 293, i64 294, i64 295, i64 296, i64 297, i64 298, i64 299, i64 300, i64 301, i64 302, i64 303, i64 306, i64 307, i64 308, i64 309, i64 310, i64 311, i64 313, i64 314, i64 315, i64 316, i64 317, i64 318, i64 319, i64 320, i64 321, i64 322, i64 323, i64 324, i64 325, i64 326, i64 327, i64 328, i64 330, i64 331, i64 332, i64 333, i64 334, i64 335, i64 336, i64 337, i64 338, i64 339, i64 340, i64 341, i64 342, i64 343, i64 344, i64 345, i64 346, i64 347, i64 348, i64 349, i64 350, i64 351, i64 352, i64 353, i64 354, i64 355, i64 356, i64 357, i64 358, i64 359, i64 360, i64 361, i64 362, i64 363, i64 364, i64 365, i64 366, i64 367, i64 368, i64 369, i64 370, i64 371, i64 372, i64 373, i64 374, i64 375, i64 376, i64 255, i64 377, i64 378, i64 379, i64 380, i64 381, i64 382, i64 385, i64 595, i64 386, i64 387, i64 388, i64 389, i64 390, i64 596, i64 391, i64 392, i64 393, i64 598, i64 394, i64 599, i64 395, i64 396, i64 398, i64 477, i64 399, i64 601, i64 400, i64 603, i64 401, i64 402, i64 403, i64 608, i64 404, i64 611, i64 406, i64 617, i64 407, i64 616, i64 408, i64 409, i64 412, i64 623, i64 413, i64 626, i64 415, i64 629, i64 416, i64 417, i64 418, i64 419, i64 420, i64 421, i64 422, i64 640, i64 423, i64 424, i64 425, i64 643, i64 428, i64 429, i64 430, i64 648, i64 431, i64 432, i64 433, i64 650, i64 434, i64 651, i64 435, i64 436, i64 437, i64 438, i64 439, i64 658, i64 440, i64 441, i64 444, i64 445, i64 452, i64 454, i64 453, i64 454, i64 455, i64 457, i64 456, i64 457, i64 458, i64 460, i64 459, i64 460, i64 461, i64 462, i64 463, i64 464, i64 465, i64 466, i64 467, i64 468, i64 469, i64 470, i64 471, i64 472, i64 473, i64 474, i64 475, i64 476, i64 478, i64 479, i64 480, i64 481, i64 482, i64 483, i64 484, i64 485, i64 486, i64 487, i64 488, i64 489, i64 490, i64 491, i64 492, i64 493, i64 494, i64 495, i64 497, i64 499, i64 498, i64 499, i64 500, i64 501, i64 502, i64 405, i64 503, i64 447, i64 504, i64 505, i64 506, i64 507, i64 508, i64 509, i64 510, i64 511, i64 512, i64 513, i64 514, i64 515, i64 516, i64 517, i64 518, i64 519, i64 520, i64 521, i64 522, i64 523, i64 524, i64 525, i64 526, i64 527, i64 528, i64 529, i64 530, i64 531, i64 532, i64 533, i64 534, i64 535, i64 536, i64 537, i64 538, i64 539, i64 540, i64 541, i64 542, i64 543, i64 544, i64 414, i64 546, i64 547, i64 548, i64 549, i64 550, i64 551, i64 552, i64 553, i64 554, i64 555, i64 556, i64 557, i64 558, i64 559, i64 560, i64 561, i64 562, i64 563, i64 570, i64 11365, i64 571, i64 572, i64 573, i64 410, i64 574, i64 11366, i64 577, i64 578, i64 579, i64 384, i64 580, i64 649, i64 581, i64 652, i64 582, i64 583, i64 584, i64 585, i64 586, i64 587, i64 588, i64 589, i64 590, i64 591, i64 880, i64 881, i64 882, i64 883, i64 886, i64 887, i64 895, i64 1011, i64 902, i64 940, i64 904, i64 941, i64 905, i64 942, i64 906, i64 943, i64 908, i64 972, i64 910, i64 973, i64 911, i64 974, i64 913, i64 945, i64 914, i64 946, i64 915, i64 947, i64 916, i64 948, i64 917, i64 949, i64 918, i64 950, i64 919, i64 951, i64 920, i64 952, i64 921, i64 953, i64 922, i64 954, i64 923, i64 955, i64 924, i64 956, i64 925, i64 957, i64 926, i64 958, i64 927, i64 959, i64 928, i64 960, i64 929, i64 961, i64 931, i64 963, i64 932, i64 964, i64 933, i64 965, i64 934, i64 966, i64 935, i64 967, i64 936, i64 968, i64 937, i64 969, i64 938, i64 970, i64 939, i64 971, i64 975, i64 983, i64 984, i64 985, i64 986, i64 987, i64 988, i64 989, i64 990, i64 991, i64 992, i64 993, i64 994, i64 995, i64 996, i64 997, i64 998, i64 999, i64 1000, i64 1001, i64 1002, i64 1003, i64 1004, i64 1005, i64 1006, i64 1007, i64 1012, i64 952, i64 1015, i64 1016, i64 1017, i64 1010, i64 1018, i64 1019, i64 1021, i64 891, i64 1022, i64 892, i64 1023, i64 893, i64 1024, i64 1104, i64 1025, i64 1105, i64 1026, i64 1106, i64 1027, i64 1107, i64 1028, i64 1108, i64 1029, i64 1109, i64 1030, i64 1110, i64 1031, i64 1111, i64 1032, i64 1112, i64 1033, i64 1113, i64 1034, i64 1114, i64 1035, i64 1115, i64 1036, i64 1116, i64 1037, i64 1117, i64 1038, i64 1118, i64 1039, i64 1119, i64 1040, i64 1072, i64 1041, i64 1073, i64 1042, i64 1074, i64 1043, i64 1075, i64 1044, i64 1076, i64 1045, i64 1077, i64 1046, i64 1078, i64 1047, i64 1079, i64 1048, i64 1080, i64 1049, i64 1081, i64 1050, i64 1082, i64 1051, i64 1083, i64 1052, i64 1084, i64 1053, i64 1085, i64 1054, i64 1086, i64 1055, i64 1087, i64 1056, i64 1088, i64 1057, i64 1089, i64 1058, i64 1090, i64 1059, i64 1091, i64 1060, i64 1092, i64 1061, i64 1093, i64 1062, i64 1094, i64 1063, i64 1095, i64 1064, i64 1096, i64 1065, i64 1097, i64 1066, i64 1098, i64 1067, i64 1099, i64 1068, i64 1100, i64 1069, i64 1101, i64 1070, i64 1102, i64 1071, i64 1103, i64 1120, i64 1121, i64 1122, i64 1123, i64 1124, i64 1125, i64 1126, i64 1127, i64 1128, i64 1129, i64 1130, i64 1131, i64 1132, i64 1133, i64 1134, i64 1135, i64 1136, i64 1137, i64 1138, i64 1139, i64 1140, i64 1141, i64 1142, i64 1143, i64 1144, i64 1145, i64 1146, i64 1147, i64 1148, i64 1149, i64 1150, i64 1151, i64 1152, i64 1153, i64 1162, i64 1163, i64 1164, i64 1165, i64 1166, i64 1167, i64 1168, i64 1169, i64 1170, i64 1171, i64 1172, i64 1173, i64 1174, i64 1175, i64 1176, i64 1177, i64 1178, i64 1179, i64 1180, i64 1181, i64 1182, i64 1183, i64 1184, i64 1185, i64 1186, i64 1187, i64 1188, i64 1189, i64 1190, i64 1191, i64 1192, i64 1193, i64 1194, i64 1195, i64 1196, i64 1197, i64 1198, i64 1199, i64 1200, i64 1201, i64 1202, i64 1203, i64 1204, i64 1205, i64 1206, i64 1207, i64 1208, i64 1209, i64 1210, i64 1211, i64 1212, i64 1213, i64 1214, i64 1215, i64 1216, i64 1231, i64 1217, i64 1218, i64 1219, i64 1220, i64 1221, i64 1222, i64 1223, i64 1224, i64 1225, i64 1226, i64 1227, i64 1228, i64 1229, i64 1230, i64 1232, i64 1233, i64 1234, i64 1235, i64 1236, i64 1237, i64 1238, i64 1239, i64 1240, i64 1241, i64 1242, i64 1243, i64 1244, i64 1245, i64 1246, i64 1247, i64 1248, i64 1249, i64 1250, i64 1251, i64 1252, i64 1253, i64 1254, i64 1255, i64 1256, i64 1257, i64 1258, i64 1259, i64 1260, i64 1261, i64 1262, i64 1263, i64 1264, i64 1265, i64 1266, i64 1267, i64 1268, i64 1269, i64 1270, i64 1271, i64 1272, i64 1273, i64 1274, i64 1275, i64 1276, i64 1277, i64 1278, i64 1279, i64 1280, i64 1281, i64 1282, i64 1283, i64 1284, i64 1285, i64 1286, i64 1287, i64 1288, i64 1289, i64 1290, i64 1291, i64 1292, i64 1293, i64 1294, i64 1295, i64 1296, i64 1297, i64 1298, i64 1299, i64 1300, i64 1301, i64 1302, i64 1303, i64 1304, i64 1305, i64 1306, i64 1307, i64 1308, i64 1309, i64 1310, i64 1311, i64 1312, i64 1313, i64 1314, i64 1315, i64 1316, i64 1317, i64 1318, i64 1319, i64 1320, i64 1321, i64 1322, i64 1323, i64 1324, i64 1325, i64 1326, i64 1327, i64 1329, i64 1377, i64 1330, i64 1378, i64 1331, i64 1379, i64 1332, i64 1380, i64 1333, i64 1381, i64 1334, i64 1382, i64 1335, i64 1383, i64 1336, i64 1384, i64 1337, i64 1385, i64 1338, i64 1386, i64 1339, i64 1387, i64 1340, i64 1388, i64 1341, i64 1389, i64 1342, i64 1390, i64 1343, i64 1391, i64 1344, i64 1392, i64 1345, i64 1393, i64 1346, i64 1394, i64 1347, i64 1395, i64 1348, i64 1396, i64 1349, i64 1397, i64 1350, i64 1398, i64 1351, i64 1399, i64 1352, i64 1400, i64 1353, i64 1401, i64 1354, i64 1402, i64 1355, i64 1403, i64 1356, i64 1404, i64 1357, i64 1405, i64 1358, i64 1406, i64 1359, i64 1407, i64 1360, i64 1408, i64 1361, i64 1409, i64 1362, i64 1410, i64 1363, i64 1411, i64 1364, i64 1412, i64 1365, i64 1413, i64 1366, i64 1414, i64 4256, i64 11520, i64 4257, i64 11521, i64 4258, i64 11522, i64 4259, i64 11523, i64 4260, i64 11524, i64 4261, i64 11525, i64 4262, i64 11526, i64 4263, i64 11527, i64 4264, i64 11528, i64 4265, i64 11529, i64 4266, i64 11530, i64 4267, i64 11531, i64 4268, i64 11532, i64 4269, i64 11533, i64 4270, i64 11534, i64 4271, i64 11535, i64 4272, i64 11536, i64 4273, i64 11537, i64 4274, i64 11538, i64 4275, i64 11539, i64 4276, i64 11540, i64 4277, i64 11541, i64 4278, i64 11542, i64 4279, i64 11543, i64 4280, i64 11544, i64 4281, i64 11545, i64 4282, i64 11546, i64 4283, i64 11547, i64 4284, i64 11548, i64 4285, i64 11549, i64 4286, i64 11550, i64 4287, i64 11551, i64 4288, i64 11552, i64 4289, i64 11553, i64 4290, i64 11554, i64 4291, i64 11555, i64 4292, i64 11556, i64 4293, i64 11557, i64 4295, i64 11559, i64 4301, i64 11565, i64 5024, i64 43888, i64 5025, i64 43889, i64 5026, i64 43890, i64 5027, i64 43891, i64 5028, i64 43892, i64 5029, i64 43893, i64 5030, i64 43894, i64 5031, i64 43895, i64 5032, i64 43896, i64 5033, i64 43897, i64 5034, i64 43898, i64 5035, i64 43899, i64 5036, i64 43900, i64 5037, i64 43901, i64 5038, i64 43902, i64 5039, i64 43903, i64 5040, i64 43904, i64 5041, i64 43905, i64 5042, i64 43906, i64 5043, i64 43907, i64 5044, i64 43908, i64 5045, i64 43909, i64 5046, i64 43910, i64 5047, i64 43911, i64 5048, i64 43912, i64 5049, i64 43913, i64 5050, i64 43914, i64 5051, i64 43915, i64 5052, i64 43916, i64 5053, i64 43917, i64 5054, i64 43918, i64 5055, i64 43919, i64 5056, i64 43920, i64 5057, i64 43921, i64 5058, i64 43922, i64 5059, i64 43923, i64 5060, i64 43924, i64 5061, i64 43925, i64 5062, i64 43926, i64 5063, i64 43927, i64 5064, i64 43928, i64 5065, i64 43929, i64 5066, i64 43930, i64 5067, i64 43931, i64 5068, i64 43932, i64 5069, i64 43933, i64 5070, i64 43934, i64 5071, i64 43935, i64 5072, i64 43936, i64 5073, i64 43937, i64 5074, i64 43938, i64 5075, i64 43939, i64 5076, i64 43940, i64 5077, i64 43941, i64 5078, i64 43942, i64 5079, i64 43943, i64 5080, i64 43944, i64 5081, i64 43945, i64 5082, i64 43946, i64 5083, i64 43947, i64 5084, i64 43948, i64 5085, i64 43949, i64 5086, i64 43950, i64 5087, i64 43951, i64 5088, i64 43952, i64 5089, i64 43953, i64 5090, i64 43954, i64 5091, i64 43955, i64 5092, i64 43956, i64 5093, i64 43957, i64 5094, i64 43958, i64 5095, i64 43959, i64 5096, i64 43960, i64 5097, i64 43961, i64 5098, i64 43962, i64 5099, i64 43963, i64 5100, i64 43964, i64 5101, i64 43965, i64 5102, i64 43966, i64 5103, i64 43967, i64 5104, i64 5112, i64 5105, i64 5113, i64 5106, i64 5114, i64 5107, i64 5115, i64 5108, i64 5116, i64 5109, i64 5117, i64 7305, i64 7306, i64 7312, i64 4304, i64 7313, i64 4305, i64 7314, i64 4306, i64 7315, i64 4307, i64 7316, i64 4308, i64 7317, i64 4309, i64 7318, i64 4310, i64 7319, i64 4311, i64 7320, i64 4312, i64 7321, i64 4313, i64 7322, i64 4314, i64 7323, i64 4315, i64 7324, i64 4316, i64 7325, i64 4317, i64 7326, i64 4318, i64 7327, i64 4319, i64 7328, i64 4320, i64 7329, i64 4321, i64 7330, i64 4322, i64 7331, i64 4323, i64 7332, i64 4324, i64 7333, i64 4325, i64 7334, i64 4326, i64 7335, i64 4327, i64 7336, i64 4328, i64 7337, i64 4329, i64 7338, i64 4330, i64 7339, i64 4331, i64 7340, i64 4332, i64 7341, i64 4333, i64 7342, i64 4334, i64 7343, i64 4335, i64 7344, i64 4336, i64 7345, i64 4337, i64 7346, i64 4338, i64 7347, i64 4339, i64 7348, i64 4340, i64 7349, i64 4341, i64 7350, i64 4342, i64 7351, i64 4343, i64 7352, i64 4344, i64 7353, i64 4345, i64 7354, i64 4346, i64 7357, i64 4349, i64 7358, i64 4350, i64 7359, i64 4351, i64 7680, i64 7681, i64 7682, i64 7683, i64 7684, i64 7685, i64 7686, i64 7687, i64 7688, i64 7689, i64 7690, i64 7691, i64 7692, i64 7693, i64 7694, i64 7695, i64 7696, i64 7697, i64 7698, i64 7699, i64 7700, i64 7701, i64 7702, i64 7703, i64 7704, i64 7705, i64 7706, i64 7707, i64 7708, i64 7709, i64 7710, i64 7711, i64 7712, i64 7713, i64 7714, i64 7715, i64 7716, i64 7717, i64 7718, i64 7719, i64 7720, i64 7721, i64 7722, i64 7723, i64 7724, i64 7725, i64 7726, i64 7727, i64 7728, i64 7729, i64 7730, i64 7731, i64 7732, i64 7733, i64 7734, i64 7735, i64 7736, i64 7737, i64 7738, i64 7739, i64 7740, i64 7741, i64 7742, i64 7743, i64 7744, i64 7745, i64 7746, i64 7747, i64 7748, i64 7749, i64 7750, i64 7751, i64 7752, i64 7753, i64 7754, i64 7755, i64 7756, i64 7757, i64 7758, i64 7759, i64 7760, i64 7761, i64 7762, i64 7763, i64 7764, i64 7765, i64 7766, i64 7767, i64 7768, i64 7769, i64 7770, i64 7771, i64 7772, i64 7773, i64 7774, i64 7775, i64 7776, i64 7777, i64 7778, i64 7779, i64 7780, i64 7781, i64 7782, i64 7783, i64 7784, i64 7785, i64 7786, i64 7787, i64 7788, i64 7789, i64 7790, i64 7791, i64 7792, i64 7793, i64 7794, i64 7795, i64 7796, i64 7797, i64 7798, i64 7799, i64 7800, i64 7801, i64 7802, i64 7803, i64 7804, i64 7805, i64 7806, i64 7807, i64 7808, i64 7809, i64 7810, i64 7811, i64 7812, i64 7813, i64 7814, i64 7815, i64 7816, i64 7817, i64 7818, i64 7819, i64 7820, i64 7821, i64 7822, i64 7823, i64 7824, i64 7825, i64 7826, i64 7827, i64 7828, i64 7829, i64 7838, i64 223, i64 7840, i64 7841, i64 7842, i64 7843, i64 7844, i64 7845, i64 7846, i64 7847, i64 7848, i64 7849, i64 7850, i64 7851, i64 7852, i64 7853, i64 7854, i64 7855, i64 7856, i64 7857, i64 7858, i64 7859, i64 7860, i64 7861, i64 7862, i64 7863, i64 7864, i64 7865, i64 7866, i64 7867, i64 7868, i64 7869, i64 7870, i64 7871, i64 7872, i64 7873, i64 7874, i64 7875, i64 7876, i64 7877, i64 7878, i64 7879, i64 7880, i64 7881, i64 7882, i64 7883, i64 7884, i64 7885, i64 7886, i64 7887, i64 7888, i64 7889, i64 7890, i64 7891, i64 7892, i64 7893, i64 7894, i64 7895, i64 7896, i64 7897, i64 7898, i64 7899, i64 7900, i64 7901, i64 7902, i64 7903, i64 7904, i64 7905, i64 7906, i64 7907, i64 7908, i64 7909, i64 7910, i64 7911, i64 7912, i64 7913, i64 7914, i64 7915, i64 7916, i64 7917, i64 7918, i64 7919, i64 7920, i64 7921, i64 7922, i64 7923, i64 7924, i64 7925, i64 7926, i64 7927, i64 7928, i64 7929, i64 7930, i64 7931, i64 7932, i64 7933, i64 7934, i64 7935, i64 7944, i64 7936, i64 7945, i64 7937, i64 7946, i64 7938, i64 7947, i64 7939, i64 7948, i64 7940, i64 7949, i64 7941, i64 7950, i64 7942, i64 7951, i64 7943, i64 7960, i64 7952, i64 7961, i64 7953, i64 7962, i64 7954, i64 7963, i64 7955, i64 7964, i64 7956, i64 7965, i64 7957, i64 7976, i64 7968, i64 7977, i64 7969, i64 7978, i64 7970, i64 7979, i64 7971, i64 7980, i64 7972, i64 7981, i64 7973, i64 7982, i64 7974, i64 7983, i64 7975, i64 7992, i64 7984, i64 7993, i64 7985, i64 7994, i64 7986, i64 7995, i64 7987, i64 7996, i64 7988, i64 7997, i64 7989, i64 7998, i64 7990, i64 7999, i64 7991, i64 8008, i64 8000, i64 8009, i64 8001, i64 8010, i64 8002, i64 8011, i64 8003, i64 8012, i64 8004, i64 8013, i64 8005, i64 8025, i64 8017, i64 8027, i64 8019, i64 8029, i64 8021, i64 8031, i64 8023, i64 8040, i64 8032, i64 8041, i64 8033, i64 8042, i64 8034, i64 8043, i64 8035, i64 8044, i64 8036, i64 8045, i64 8037, i64 8046, i64 8038, i64 8047, i64 8039, i64 8072, i64 8064, i64 8073, i64 8065, i64 8074, i64 8066, i64 8075, i64 8067, i64 8076, i64 8068, i64 8077, i64 8069, i64 8078, i64 8070, i64 8079, i64 8071, i64 8088, i64 8080, i64 8089, i64 8081, i64 8090, i64 8082, i64 8091, i64 8083, i64 8092, i64 8084, i64 8093, i64 8085, i64 8094, i64 8086, i64 8095, i64 8087, i64 8104, i64 8096, i64 8105, i64 8097, i64 8106, i64 8098, i64 8107, i64 8099, i64 8108, i64 8100, i64 8109, i64 8101, i64 8110, i64 8102, i64 8111, i64 8103, i64 8120, i64 8112, i64 8121, i64 8113, i64 8122, i64 8048, i64 8123, i64 8049, i64 8124, i64 8115, i64 8136, i64 8050, i64 8137, i64 8051, i64 8138, i64 8052, i64 8139, i64 8053, i64 8140, i64 8131, i64 8152, i64 8144, i64 8153, i64 8145, i64 8154, i64 8054, i64 8155, i64 8055, i64 8168, i64 8160, i64 8169, i64 8161, i64 8170, i64 8058, i64 8171, i64 8059, i64 8172, i64 8165, i64 8184, i64 8056, i64 8185, i64 8057, i64 8186, i64 8060, i64 8187, i64 8061, i64 8188, i64 8179, i64 8486, i64 969, i64 8490, i64 107, i64 8491, i64 229, i64 8498, i64 8526, i64 8544, i64 8560, i64 8545, i64 8561, i64 8546, i64 8562, i64 8547, i64 8563, i64 8548, i64 8564, i64 8549, i64 8565, i64 8550, i64 8566, i64 8551, i64 8567, i64 8552, i64 8568, i64 8553, i64 8569, i64 8554, i64 8570, i64 8555, i64 8571, i64 8556, i64 8572, i64 8557, i64 8573, i64 8558, i64 8574, i64 8559, i64 8575, i64 8579, i64 8580, i64 9398, i64 9424, i64 9399, i64 9425, i64 9400, i64 9426, i64 9401, i64 9427, i64 9402, i64 9428, i64 9403, i64 9429, i64 9404, i64 9430, i64 9405, i64 9431, i64 9406, i64 9432, i64 9407, i64 9433, i64 9408, i64 9434, i64 9409, i64 9435, i64 9410, i64 9436, i64 9411, i64 9437, i64 9412, i64 9438, i64 9413, i64 9439, i64 9414, i64 9440, i64 9415, i64 9441, i64 9416, i64 9442, i64 9417, i64 9443, i64 9418, i64 9444, i64 9419, i64 9445, i64 9420, i64 9446, i64 9421, i64 9447, i64 9422, i64 9448, i64 9423, i64 9449, i64 11264, i64 11312, i64 11265, i64 11313, i64 11266, i64 11314, i64 11267, i64 11315, i64 11268, i64 11316, i64 11269, i64 11317, i64 11270, i64 11318, i64 11271, i64 11319, i64 11272, i64 11320, i64 11273, i64 11321, i64 11274, i64 11322, i64 11275, i64 11323, i64 11276, i64 11324, i64 11277, i64 11325, i64 11278, i64 11326, i64 11279, i64 11327, i64 11280, i64 11328, i64 11281, i64 11329, i64 11282, i64 11330, i64 11283, i64 11331, i64 11284, i64 11332, i64 11285, i64 11333, i64 11286, i64 11334, i64 11287, i64 11335, i64 11288, i64 11336, i64 11289, i64 11337, i64 11290, i64 11338, i64 11291, i64 11339, i64 11292, i64 11340, i64 11293, i64 11341, i64 11294, i64 11342, i64 11295, i64 11343, i64 11296, i64 11344, i64 11297, i64 11345, i64 11298, i64 11346, i64 11299, i64 11347, i64 11300, i64 11348, i64 11301, i64 11349, i64 11302, i64 11350, i64 11303, i64 11351, i64 11304, i64 11352, i64 11305, i64 11353, i64 11306, i64 11354, i64 11307, i64 11355, i64 11308, i64 11356, i64 11309, i64 11357, i64 11310, i64 11358, i64 11311, i64 11359, i64 11360, i64 11361, i64 11362, i64 619, i64 11363, i64 7549, i64 11364, i64 637, i64 11367, i64 11368, i64 11369, i64 11370, i64 11371, i64 11372, i64 11373, i64 593, i64 11374, i64 625, i64 11375, i64 592, i64 11376, i64 594, i64 11378, i64 11379, i64 11381, i64 11382, i64 11390, i64 575, i64 11391, i64 576, i64 11392, i64 11393, i64 11394, i64 11395, i64 11396, i64 11397, i64 11398, i64 11399, i64 11400, i64 11401, i64 11402, i64 11403, i64 11404, i64 11405, i64 11406, i64 11407, i64 11408, i64 11409, i64 11410, i64 11411, i64 11412, i64 11413, i64 11414, i64 11415, i64 11416, i64 11417, i64 11418, i64 11419, i64 11420, i64 11421, i64 11422, i64 11423, i64 11424, i64 11425, i64 11426, i64 11427, i64 11428, i64 11429, i64 11430, i64 11431, i64 11432, i64 11433, i64 11434, i64 11435, i64 11436, i64 11437, i64 11438, i64 11439, i64 11440, i64 11441, i64 11442, i64 11443, i64 11444, i64 11445, i64 11446, i64 11447, i64 11448, i64 11449, i64 11450, i64 11451, i64 11452, i64 11453, i64 11454, i64 11455, i64 11456, i64 11457, i64 11458, i64 11459, i64 11460, i64 11461, i64 11462, i64 11463, i64 11464, i64 11465, i64 11466, i64 11467, i64 11468, i64 11469, i64 11470, i64 11471, i64 11472, i64 11473, i64 11474, i64 11475, i64 11476, i64 11477, i64 11478, i64 11479, i64 11480, i64 11481, i64 11482, i64 11483, i64 11484, i64 11485, i64 11486, i64 11487, i64 11488, i64 11489, i64 11490, i64 11491, i64 11499, i64 11500, i64 11501, i64 11502, i64 11506, i64 11507, i64 42560, i64 42561, i64 42562, i64 42563, i64 42564, i64 42565, i64 42566, i64 42567, i64 42568, i64 42569, i64 42570, i64 42571, i64 42572, i64 42573, i64 42574, i64 42575, i64 42576, i64 42577, i64 42578, i64 42579, i64 42580, i64 42581, i64 42582, i64 42583, i64 42584, i64 42585, i64 42586, i64 42587, i64 42588, i64 42589, i64 42590, i64 42591, i64 42592, i64 42593, i64 42594, i64 42595, i64 42596, i64 42597, i64 42598, i64 42599, i64 42600, i64 42601, i64 42602, i64 42603, i64 42604, i64 42605, i64 42624, i64 42625, i64 42626, i64 42627, i64 42628, i64 42629, i64 42630, i64 42631, i64 42632, i64 42633, i64 42634, i64 42635, i64 42636, i64 42637, i64 42638, i64 42639, i64 42640, i64 42641, i64 42642, i64 42643, i64 42644, i64 42645, i64 42646, i64 42647, i64 42648, i64 42649, i64 42650, i64 42651, i64 42786, i64 42787, i64 42788, i64 42789, i64 42790, i64 42791, i64 42792, i64 42793, i64 42794, i64 42795, i64 42796, i64 42797, i64 42798, i64 42799, i64 42802, i64 42803, i64 42804, i64 42805, i64 42806, i64 42807, i64 42808, i64 42809, i64 42810, i64 42811, i64 42812, i64 42813, i64 42814, i64 42815, i64 42816, i64 42817, i64 42818, i64 42819, i64 42820, i64 42821, i64 42822, i64 42823, i64 42824, i64 42825, i64 42826, i64 42827, i64 42828, i64 42829, i64 42830, i64 42831, i64 42832, i64 42833, i64 42834, i64 42835, i64 42836, i64 42837, i64 42838, i64 42839, i64 42840, i64 42841, i64 42842, i64 42843, i64 42844, i64 42845, i64 42846, i64 42847, i64 42848, i64 42849, i64 42850, i64 42851, i64 42852, i64 42853, i64 42854, i64 42855, i64 42856, i64 42857, i64 42858, i64 42859, i64 42860, i64 42861, i64 42862, i64 42863, i64 42873, i64 42874, i64 42875, i64 42876, i64 42877, i64 7545, i64 42878, i64 42879, i64 42880, i64 42881, i64 42882, i64 42883, i64 42884, i64 42885, i64 42886, i64 42887, i64 42891, i64 42892, i64 42893, i64 613, i64 42896, i64 42897, i64 42898, i64 42899, i64 42902, i64 42903, i64 42904, i64 42905, i64 42906, i64 42907, i64 42908, i64 42909, i64 42910, i64 42911, i64 42912, i64 42913, i64 42914, i64 42915, i64 42916, i64 42917, i64 42918, i64 42919, i64 42920, i64 42921, i64 42922, i64 614, i64 42923, i64 604, i64 42924, i64 609, i64 42925, i64 620, i64 42926, i64 618, i64 42928, i64 670, i64 42929, i64 647, i64 42930, i64 669, i64 42931, i64 43859, i64 42932, i64 42933, i64 42934, i64 42935, i64 42936, i64 42937, i64 42938, i64 42939, i64 42940, i64 42941, i64 42942, i64 42943, i64 42944, i64 42945, i64 42946, i64 42947, i64 42948, i64 42900, i64 42949, i64 642, i64 42950, i64 7566, i64 42951, i64 42952, i64 42953, i64 42954, i64 42955, i64 612, i64 42956, i64 42957, i64 42960, i64 42961, i64 42966, i64 42967, i64 42968, i64 42969, i64 42970, i64 42971, i64 42972, i64 411, i64 42997, i64 42998, i64 65313, i64 65345, i64 65314, i64 65346, i64 65315, i64 65347, i64 65316, i64 65348, i64 65317, i64 65349, i64 65318, i64 65350, i64 65319, i64 65351, i64 65320, i64 65352, i64 65321, i64 65353, i64 65322, i64 65354, i64 65323, i64 65355, i64 65324, i64 65356, i64 65325, i64 65357, i64 65326, i64 65358, i64 65327, i64 65359, i64 65328, i64 65360, i64 65329, i64 65361, i64 65330, i64 65362, i64 65331, i64 65363, i64 65332, i64 65364, i64 65333, i64 65365, i64 65334, i64 65366, i64 65335, i64 65367, i64 65336, i64 65368, i64 65337, i64 65369, i64 65338, i64 65370, i64 66560, i64 66600, i64 66561, i64 66601, i64 66562, i64 66602, i64 66563, i64 66603, i64 66564, i64 66604, i64 66565, i64 66605, i64 66566, i64 66606, i64 66567, i64 66607, i64 66568, i64 66608, i64 66569, i64 66609, i64 66570, i64 66610, i64 66571, i64 66611, i64 66572, i64 66612, i64 66573, i64 66613, i64 66574, i64 66614, i64 66575, i64 66615, i64 66576, i64 66616, i64 66577, i64 66617, i64 66578, i64 66618, i64 66579, i64 66619, i64 66580, i64 66620, i64 66581, i64 66621, i64 66582, i64 66622, i64 66583, i64 66623, i64 66584, i64 66624, i64 66585, i64 66625, i64 66586, i64 66626, i64 66587, i64 66627, i64 66588, i64 66628, i64 66589, i64 66629, i64 66590, i64 66630, i64 66591, i64 66631, i64 66592, i64 66632, i64 66593, i64 66633, i64 66594, i64 66634, i64 66595, i64 66635, i64 66596, i64 66636, i64 66597, i64 66637, i64 66598, i64 66638, i64 66599, i64 66639, i64 66736, i64 66776, i64 66737, i64 66777, i64 66738, i64 66778, i64 66739, i64 66779, i64 66740, i64 66780, i64 66741, i64 66781, i64 66742, i64 66782, i64 66743, i64 66783, i64 66744, i64 66784, i64 66745, i64 66785, i64 66746, i64 66786, i64 66747, i64 66787, i64 66748, i64 66788, i64 66749, i64 66789, i64 66750, i64 66790, i64 66751, i64 66791, i64 66752, i64 66792, i64 66753, i64 66793, i64 66754, i64 66794, i64 66755, i64 66795, i64 66756, i64 66796, i64 66757, i64 66797, i64 66758, i64 66798, i64 66759, i64 66799, i64 66760, i64 66800, i64 66761, i64 66801, i64 66762, i64 66802, i64 66763, i64 66803, i64 66764, i64 66804, i64 66765, i64 66805, i64 66766, i64 66806, i64 66767, i64 66807, i64 66768, i64 66808, i64 66769, i64 66809, i64 66770, i64 66810, i64 66771, i64 66811, i64 66928, i64 66967, i64 66929, i64 66968, i64 66930, i64 66969, i64 66931, i64 66970, i64 66932, i64 66971, i64 66933, i64 66972, i64 66934, i64 66973, i64 66935, i64 66974, i64 66936, i64 66975, i64 66937, i64 66976, i64 66938, i64 66977, i64 66940, i64 66979, i64 66941, i64 66980, i64 66942, i64 66981, i64 66943, i64 66982, i64 66944, i64 66983, i64 66945, i64 66984, i64 66946, i64 66985, i64 66947, i64 66986, i64 66948, i64 66987, i64 66949, i64 66988, i64 66950, i64 66989, i64 66951, i64 66990, i64 66952, i64 66991, i64 66953, i64 66992, i64 66954, i64 66993, i64 66956, i64 66995, i64 66957, i64 66996, i64 66958, i64 66997, i64 66959, i64 66998, i64 66960, i64 66999, i64 66961, i64 67000, i64 66962, i64 67001, i64 66964, i64 67003, i64 66965, i64 67004, i64 68736, i64 68800, i64 68737, i64 68801, i64 68738, i64 68802, i64 68739, i64 68803, i64 68740, i64 68804, i64 68741, i64 68805, i64 68742, i64 68806, i64 68743, i64 68807, i64 68744, i64 68808, i64 68745, i64 68809, i64 68746, i64 68810, i64 68747, i64 68811, i64 68748, i64 68812, i64 68749, i64 68813, i64 68750, i64 68814, i64 68751, i64 68815, i64 68752, i64 68816, i64 68753, i64 68817, i64 68754, i64 68818, i64 68755, i64 68819, i64 68756, i64 68820, i64 68757, i64 68821, i64 68758, i64 68822, i64 68759, i64 68823, i64 68760, i64 68824, i64 68761, i64 68825, i64 68762, i64 68826, i64 68763, i64 68827, i64 68764, i64 68828, i64 68765, i64 68829, i64 68766, i64 68830, i64 68767, i64 68831, i64 68768, i64 68832, i64 68769, i64 68833, i64 68770, i64 68834, i64 68771, i64 68835, i64 68772, i64 68836, i64 68773, i64 68837, i64 68774, i64 68838, i64 68775, i64 68839, i64 68776, i64 68840, i64 68777, i64 68841, i64 68778, i64 68842, i64 68779, i64 68843, i64 68780, i64 68844, i64 68781, i64 68845, i64 68782, i64 68846, i64 68783, i64 68847, i64 68784, i64 68848, i64 68785, i64 68849, i64 68786, i64 68850, i64 68944, i64 68976, i64 68945, i64 68977, i64 68946, i64 68978, i64 68947, i64 68979, i64 68948, i64 68980, i64 68949, i64 68981, i64 68950, i64 68982, i64 68951, i64 68983, i64 68952, i64 68984, i64 68953, i64 68985, i64 68954, i64 68986, i64 68955, i64 68987, i64 68956, i64 68988, i64 68957, i64 68989, i64 68958, i64 68990, i64 68959, i64 68991, i64 68960, i64 68992, i64 68961, i64 68993, i64 68962, i64 68994, i64 68963, i64 68995, i64 68964, i64 68996, i64 68965, i64 68997, i64 71840, i64 71872, i64 71841, i64 71873, i64 71842, i64 71874, i64 71843, i64 71875, i64 71844, i64 71876, i64 71845, i64 71877, i64 71846, i64 71878, i64 71847, i64 71879, i64 71848, i64 71880, i64 71849, i64 71881, i64 71850, i64 71882, i64 71851, i64 71883, i64 71852, i64 71884, i64 71853, i64 71885, i64 71854, i64 71886, i64 71855, i64 71887, i64 71856, i64 71888, i64 71857, i64 71889, i64 71858, i64 71890, i64 71859, i64 71891, i64 71860, i64 71892, i64 71861, i64 71893, i64 71862, i64 71894, i64 71863, i64 71895, i64 71864, i64 71896, i64 71865, i64 71897, i64 71866, i64 71898, i64 71867, i64 71899, i64 71868, i64 71900, i64 71869, i64 71901, i64 71870, i64 71902, i64 71871, i64 71903, i64 93760, i64 93792, i64 93761, i64 93793, i64 93762, i64 93794, i64 93763, i64 93795, i64 93764, i64 93796, i64 93765, i64 93797, i64 93766, i64 93798, i64 93767, i64 93799, i64 93768, i64 93800, i64 93769, i64 93801, i64 93770, i64 93802, i64 93771, i64 93803, i64 93772, i64 93804, i64 93773, i64 93805, i64 93774, i64 93806, i64 93775, i64 93807, i64 93776, i64 93808, i64 93777, i64 93809, i64 93778, i64 93810, i64 93779, i64 93811, i64 93780, i64 93812, i64 93781, i64 93813, i64 93782, i64 93814, i64 93783, i64 93815, i64 93784, i64 93816, i64 93785, i64 93817, i64 93786, i64 93818, i64 93787, i64 93819, i64 93788, i64 93820, i64 93789, i64 93821, i64 93790, i64 93822, i64 93791, i64 93823, i64 125184, i64 125218, i64 125185, i64 125219, i64 125186, i64 125220, i64 125187, i64 125221, i64 125188, i64 125222, i64 125189, i64 125223, i64 125190, i64 125224, i64 125191, i64 125225, i64 125192, i64 125226, i64 125193, i64 125227, i64 125194, i64 125228, i64 125195, i64 125229, i64 125196, i64 125230, i64 125197, i64 125231, i64 125198, i64 125232, i64 125199, i64 125233, i64 125200, i64 125234, i64 125201, i64 125235, i64 125202, i64 125236, i64 125203, i64 125237, i64 125204, i64 125238, i64 125205, i64 125239, i64 125206, i64 125240, i64 125207, i64 125241, i64 125208, i64 125242, i64 125209, i64 125243, i64 125210, i64 125244, i64 125211, i64 125245, i64 125212, i64 125246, i64 125213, i64 125247, i64 125214, i64 125248, i64 125215, i64 125249, i64 125216, i64 125250, i64 125217, i64 125251], align 16
@rtt.11526 = private unnamed_addr constant [2900 x i64] [i64 97, i64 65, i64 98, i64 66, i64 99, i64 67, i64 100, i64 68, i64 101, i64 69, i64 102, i64 70, i64 103, i64 71, i64 104, i64 72, i64 105, i64 73, i64 106, i64 74, i64 107, i64 75, i64 108, i64 76, i64 109, i64 77, i64 110, i64 78, i64 111, i64 79, i64 112, i64 80, i64 113, i64 81, i64 114, i64 82, i64 115, i64 83, i64 116, i64 84, i64 117, i64 85, i64 118, i64 86, i64 119, i64 87, i64 120, i64 88, i64 121, i64 89, i64 122, i64 90, i64 181, i64 924, i64 224, i64 192, i64 225, i64 193, i64 226, i64 194, i64 227, i64 195, i64 228, i64 196, i64 229, i64 197, i64 230, i64 198, i64 231, i64 199, i64 232, i64 200, i64 233, i64 201, i64 234, i64 202, i64 235, i64 203, i64 236, i64 204, i64 237, i64 205, i64 238, i64 206, i64 239, i64 207, i64 240, i64 208, i64 241, i64 209, i64 242, i64 210, i64 243, i64 211, i64 244, i64 212, i64 245, i64 213, i64 246, i64 214, i64 248, i64 216, i64 249, i64 217, i64 250, i64 218, i64 251, i64 219, i64 252, i64 220, i64 253, i64 221, i64 254, i64 222, i64 255, i64 376, i64 257, i64 256, i64 259, i64 258, i64 261, i64 260, i64 263, i64 262, i64 265, i64 264, i64 267, i64 266, i64 269, i64 268, i64 271, i64 270, i64 273, i64 272, i64 275, i64 274, i64 277, i64 276, i64 279, i64 278, i64 281, i64 280, i64 283, i64 282, i64 285, i64 284, i64 287, i64 286, i64 289, i64 288, i64 291, i64 290, i64 293, i64 292, i64 295, i64 294, i64 297, i64 296, i64 299, i64 298, i64 301, i64 300, i64 303, i64 302, i64 305, i64 73, i64 307, i64 306, i64 309, i64 308, i64 311, i64 310, i64 314, i64 313, i64 316, i64 315, i64 318, i64 317, i64 320, i64 319, i64 322, i64 321, i64 324, i64 323, i64 326, i64 325, i64 328, i64 327, i64 331, i64 330, i64 333, i64 332, i64 335, i64 334, i64 337, i64 336, i64 339, i64 338, i64 341, i64 340, i64 343, i64 342, i64 345, i64 344, i64 347, i64 346, i64 349, i64 348, i64 351, i64 350, i64 353, i64 352, i64 355, i64 354, i64 357, i64 356, i64 359, i64 358, i64 361, i64 360, i64 363, i64 362, i64 365, i64 364, i64 367, i64 366, i64 369, i64 368, i64 371, i64 370, i64 373, i64 372, i64 375, i64 374, i64 378, i64 377, i64 380, i64 379, i64 382, i64 381, i64 383, i64 83, i64 384, i64 579, i64 387, i64 386, i64 389, i64 388, i64 392, i64 391, i64 396, i64 395, i64 402, i64 401, i64 405, i64 502, i64 409, i64 408, i64 410, i64 573, i64 411, i64 42972, i64 414, i64 544, i64 417, i64 416, i64 419, i64 418, i64 421, i64 420, i64 424, i64 423, i64 429, i64 428, i64 432, i64 431, i64 436, i64 435, i64 438, i64 437, i64 441, i64 440, i64 445, i64 444, i64 447, i64 503, i64 453, i64 452, i64 454, i64 452, i64 456, i64 455, i64 457, i64 455, i64 459, i64 458, i64 460, i64 458, i64 462, i64 461, i64 464, i64 463, i64 466, i64 465, i64 468, i64 467, i64 470, i64 469, i64 472, i64 471, i64 474, i64 473, i64 476, i64 475, i64 477, i64 398, i64 479, i64 478, i64 481, i64 480, i64 483, i64 482, i64 485, i64 484, i64 487, i64 486, i64 489, i64 488, i64 491, i64 490, i64 493, i64 492, i64 495, i64 494, i64 498, i64 497, i64 499, i64 497, i64 501, i64 500, i64 505, i64 504, i64 507, i64 506, i64 509, i64 508, i64 511, i64 510, i64 513, i64 512, i64 515, i64 514, i64 517, i64 516, i64 519, i64 518, i64 521, i64 520, i64 523, i64 522, i64 525, i64 524, i64 527, i64 526, i64 529, i64 528, i64 531, i64 530, i64 533, i64 532, i64 535, i64 534, i64 537, i64 536, i64 539, i64 538, i64 541, i64 540, i64 543, i64 542, i64 547, i64 546, i64 549, i64 548, i64 551, i64 550, i64 553, i64 552, i64 555, i64 554, i64 557, i64 556, i64 559, i64 558, i64 561, i64 560, i64 563, i64 562, i64 572, i64 571, i64 575, i64 11390, i64 576, i64 11391, i64 578, i64 577, i64 583, i64 582, i64 585, i64 584, i64 587, i64 586, i64 589, i64 588, i64 591, i64 590, i64 592, i64 11375, i64 593, i64 11373, i64 594, i64 11376, i64 595, i64 385, i64 596, i64 390, i64 598, i64 393, i64 599, i64 394, i64 601, i64 399, i64 603, i64 400, i64 604, i64 42923, i64 608, i64 403, i64 609, i64 42924, i64 611, i64 404, i64 612, i64 42955, i64 613, i64 42893, i64 614, i64 42922, i64 616, i64 407, i64 617, i64 406, i64 618, i64 42926, i64 619, i64 11362, i64 620, i64 42925, i64 623, i64 412, i64 625, i64 11374, i64 626, i64 413, i64 629, i64 415, i64 637, i64 11364, i64 640, i64 422, i64 642, i64 42949, i64 643, i64 425, i64 647, i64 42929, i64 648, i64 430, i64 649, i64 580, i64 650, i64 433, i64 651, i64 434, i64 652, i64 581, i64 658, i64 439, i64 669, i64 42930, i64 670, i64 42928, i64 837, i64 921, i64 881, i64 880, i64 883, i64 882, i64 887, i64 886, i64 891, i64 1021, i64 892, i64 1022, i64 893, i64 1023, i64 940, i64 902, i64 941, i64 904, i64 942, i64 905, i64 943, i64 906, i64 945, i64 913, i64 946, i64 914, i64 947, i64 915, i64 948, i64 916, i64 949, i64 917, i64 950, i64 918, i64 951, i64 919, i64 952, i64 920, i64 953, i64 921, i64 954, i64 922, i64 955, i64 923, i64 956, i64 924, i64 957, i64 925, i64 958, i64 926, i64 959, i64 927, i64 960, i64 928, i64 961, i64 929, i64 962, i64 931, i64 963, i64 931, i64 964, i64 932, i64 965, i64 933, i64 966, i64 934, i64 967, i64 935, i64 968, i64 936, i64 969, i64 937, i64 970, i64 938, i64 971, i64 939, i64 972, i64 908, i64 973, i64 910, i64 974, i64 911, i64 976, i64 914, i64 977, i64 920, i64 981, i64 934, i64 982, i64 928, i64 983, i64 975, i64 985, i64 984, i64 987, i64 986, i64 989, i64 988, i64 991, i64 990, i64 993, i64 992, i64 995, i64 994, i64 997, i64 996, i64 999, i64 998, i64 1001, i64 1000, i64 1003, i64 1002, i64 1005, i64 1004, i64 1007, i64 1006, i64 1008, i64 922, i64 1009, i64 929, i64 1010, i64 1017, i64 1011, i64 895, i64 1013, i64 917, i64 1016, i64 1015, i64 1019, i64 1018, i64 1072, i64 1040, i64 1073, i64 1041, i64 1074, i64 1042, i64 1075, i64 1043, i64 1076, i64 1044, i64 1077, i64 1045, i64 1078, i64 1046, i64 1079, i64 1047, i64 1080, i64 1048, i64 1081, i64 1049, i64 1082, i64 1050, i64 1083, i64 1051, i64 1084, i64 1052, i64 1085, i64 1053, i64 1086, i64 1054, i64 1087, i64 1055, i64 1088, i64 1056, i64 1089, i64 1057, i64 1090, i64 1058, i64 1091, i64 1059, i64 1092, i64 1060, i64 1093, i64 1061, i64 1094, i64 1062, i64 1095, i64 1063, i64 1096, i64 1064, i64 1097, i64 1065, i64 1098, i64 1066, i64 1099, i64 1067, i64 1100, i64 1068, i64 1101, i64 1069, i64 1102, i64 1070, i64 1103, i64 1071, i64 1104, i64 1024, i64 1105, i64 1025, i64 1106, i64 1026, i64 1107, i64 1027, i64 1108, i64 1028, i64 1109, i64 1029, i64 1110, i64 1030, i64 1111, i64 1031, i64 1112, i64 1032, i64 1113, i64 1033, i64 1114, i64 1034, i64 1115, i64 1035, i64 1116, i64 1036, i64 1117, i64 1037, i64 1118, i64 1038, i64 1119, i64 1039, i64 1121, i64 1120, i64 1123, i64 1122, i64 1125, i64 1124, i64 1127, i64 1126, i64 1129, i64 1128, i64 1131, i64 1130, i64 1133, i64 1132, i64 1135, i64 1134, i64 1137, i64 1136, i64 1139, i64 1138, i64 1141, i64 1140, i64 1143, i64 1142, i64 1145, i64 1144, i64 1147, i64 1146, i64 1149, i64 1148, i64 1151, i64 1150, i64 1153, i64 1152, i64 1163, i64 1162, i64 1165, i64 1164, i64 1167, i64 1166, i64 1169, i64 1168, i64 1171, i64 1170, i64 1173, i64 1172, i64 1175, i64 1174, i64 1177, i64 1176, i64 1179, i64 1178, i64 1181, i64 1180, i64 1183, i64 1182, i64 1185, i64 1184, i64 1187, i64 1186, i64 1189, i64 1188, i64 1191, i64 1190, i64 1193, i64 1192, i64 1195, i64 1194, i64 1197, i64 1196, i64 1199, i64 1198, i64 1201, i64 1200, i64 1203, i64 1202, i64 1205, i64 1204, i64 1207, i64 1206, i64 1209, i64 1208, i64 1211, i64 1210, i64 1213, i64 1212, i64 1215, i64 1214, i64 1218, i64 1217, i64 1220, i64 1219, i64 1222, i64 1221, i64 1224, i64 1223, i64 1226, i64 1225, i64 1228, i64 1227, i64 1230, i64 1229, i64 1231, i64 1216, i64 1233, i64 1232, i64 1235, i64 1234, i64 1237, i64 1236, i64 1239, i64 1238, i64 1241, i64 1240, i64 1243, i64 1242, i64 1245, i64 1244, i64 1247, i64 1246, i64 1249, i64 1248, i64 1251, i64 1250, i64 1253, i64 1252, i64 1255, i64 1254, i64 1257, i64 1256, i64 1259, i64 1258, i64 1261, i64 1260, i64 1263, i64 1262, i64 1265, i64 1264, i64 1267, i64 1266, i64 1269, i64 1268, i64 1271, i64 1270, i64 1273, i64 1272, i64 1275, i64 1274, i64 1277, i64 1276, i64 1279, i64 1278, i64 1281, i64 1280, i64 1283, i64 1282, i64 1285, i64 1284, i64 1287, i64 1286, i64 1289, i64 1288, i64 1291, i64 1290, i64 1293, i64 1292, i64 1295, i64 1294, i64 1297, i64 1296, i64 1299, i64 1298, i64 1301, i64 1300, i64 1303, i64 1302, i64 1305, i64 1304, i64 1307, i64 1306, i64 1309, i64 1308, i64 1311, i64 1310, i64 1313, i64 1312, i64 1315, i64 1314, i64 1317, i64 1316, i64 1319, i64 1318, i64 1321, i64 1320, i64 1323, i64 1322, i64 1325, i64 1324, i64 1327, i64 1326, i64 1377, i64 1329, i64 1378, i64 1330, i64 1379, i64 1331, i64 1380, i64 1332, i64 1381, i64 1333, i64 1382, i64 1334, i64 1383, i64 1335, i64 1384, i64 1336, i64 1385, i64 1337, i64 1386, i64 1338, i64 1387, i64 1339, i64 1388, i64 1340, i64 1389, i64 1341, i64 1390, i64 1342, i64 1391, i64 1343, i64 1392, i64 1344, i64 1393, i64 1345, i64 1394, i64 1346, i64 1395, i64 1347, i64 1396, i64 1348, i64 1397, i64 1349, i64 1398, i64 1350, i64 1399, i64 1351, i64 1400, i64 1352, i64 1401, i64 1353, i64 1402, i64 1354, i64 1403, i64 1355, i64 1404, i64 1356, i64 1405, i64 1357, i64 1406, i64 1358, i64 1407, i64 1359, i64 1408, i64 1360, i64 1409, i64 1361, i64 1410, i64 1362, i64 1411, i64 1363, i64 1412, i64 1364, i64 1413, i64 1365, i64 1414, i64 1366, i64 4304, i64 7312, i64 4305, i64 7313, i64 4306, i64 7314, i64 4307, i64 7315, i64 4308, i64 7316, i64 4309, i64 7317, i64 4310, i64 7318, i64 4311, i64 7319, i64 4312, i64 7320, i64 4313, i64 7321, i64 4314, i64 7322, i64 4315, i64 7323, i64 4316, i64 7324, i64 4317, i64 7325, i64 4318, i64 7326, i64 4319, i64 7327, i64 4320, i64 7328, i64 4321, i64 7329, i64 4322, i64 7330, i64 4323, i64 7331, i64 4324, i64 7332, i64 4325, i64 7333, i64 4326, i64 7334, i64 4327, i64 7335, i64 4328, i64 7336, i64 4329, i64 7337, i64 4330, i64 7338, i64 4331, i64 7339, i64 4332, i64 7340, i64 4333, i64 7341, i64 4334, i64 7342, i64 4335, i64 7343, i64 4336, i64 7344, i64 4337, i64 7345, i64 4338, i64 7346, i64 4339, i64 7347, i64 4340, i64 7348, i64 4341, i64 7349, i64 4342, i64 7350, i64 4343, i64 7351, i64 4344, i64 7352, i64 4345, i64 7353, i64 4346, i64 7354, i64 4349, i64 7357, i64 4350, i64 7358, i64 4351, i64 7359, i64 5112, i64 5104, i64 5113, i64 5105, i64 5114, i64 5106, i64 5115, i64 5107, i64 5116, i64 5108, i64 5117, i64 5109, i64 7296, i64 1042, i64 7297, i64 1044, i64 7298, i64 1054, i64 7299, i64 1057, i64 7300, i64 1058, i64 7301, i64 1058, i64 7302, i64 1066, i64 7303, i64 1122, i64 7304, i64 42570, i64 7306, i64 7305, i64 7545, i64 42877, i64 7549, i64 11363, i64 7566, i64 42950, i64 7681, i64 7680, i64 7683, i64 7682, i64 7685, i64 7684, i64 7687, i64 7686, i64 7689, i64 7688, i64 7691, i64 7690, i64 7693, i64 7692, i64 7695, i64 7694, i64 7697, i64 7696, i64 7699, i64 7698, i64 7701, i64 7700, i64 7703, i64 7702, i64 7705, i64 7704, i64 7707, i64 7706, i64 7709, i64 7708, i64 7711, i64 7710, i64 7713, i64 7712, i64 7715, i64 7714, i64 7717, i64 7716, i64 7719, i64 7718, i64 7721, i64 7720, i64 7723, i64 7722, i64 7725, i64 7724, i64 7727, i64 7726, i64 7729, i64 7728, i64 7731, i64 7730, i64 7733, i64 7732, i64 7735, i64 7734, i64 7737, i64 7736, i64 7739, i64 7738, i64 7741, i64 7740, i64 7743, i64 7742, i64 7745, i64 7744, i64 7747, i64 7746, i64 7749, i64 7748, i64 7751, i64 7750, i64 7753, i64 7752, i64 7755, i64 7754, i64 7757, i64 7756, i64 7759, i64 7758, i64 7761, i64 7760, i64 7763, i64 7762, i64 7765, i64 7764, i64 7767, i64 7766, i64 7769, i64 7768, i64 7771, i64 7770, i64 7773, i64 7772, i64 7775, i64 7774, i64 7777, i64 7776, i64 7779, i64 7778, i64 7781, i64 7780, i64 7783, i64 7782, i64 7785, i64 7784, i64 7787, i64 7786, i64 7789, i64 7788, i64 7791, i64 7790, i64 7793, i64 7792, i64 7795, i64 7794, i64 7797, i64 7796, i64 7799, i64 7798, i64 7801, i64 7800, i64 7803, i64 7802, i64 7805, i64 7804, i64 7807, i64 7806, i64 7809, i64 7808, i64 7811, i64 7810, i64 7813, i64 7812, i64 7815, i64 7814, i64 7817, i64 7816, i64 7819, i64 7818, i64 7821, i64 7820, i64 7823, i64 7822, i64 7825, i64 7824, i64 7827, i64 7826, i64 7829, i64 7828, i64 7835, i64 7776, i64 7841, i64 7840, i64 7843, i64 7842, i64 7845, i64 7844, i64 7847, i64 7846, i64 7849, i64 7848, i64 7851, i64 7850, i64 7853, i64 7852, i64 7855, i64 7854, i64 7857, i64 7856, i64 7859, i64 7858, i64 7861, i64 7860, i64 7863, i64 7862, i64 7865, i64 7864, i64 7867, i64 7866, i64 7869, i64 7868, i64 7871, i64 7870, i64 7873, i64 7872, i64 7875, i64 7874, i64 7877, i64 7876, i64 7879, i64 7878, i64 7881, i64 7880, i64 7883, i64 7882, i64 7885, i64 7884, i64 7887, i64 7886, i64 7889, i64 7888, i64 7891, i64 7890, i64 7893, i64 7892, i64 7895, i64 7894, i64 7897, i64 7896, i64 7899, i64 7898, i64 7901, i64 7900, i64 7903, i64 7902, i64 7905, i64 7904, i64 7907, i64 7906, i64 7909, i64 7908, i64 7911, i64 7910, i64 7913, i64 7912, i64 7915, i64 7914, i64 7917, i64 7916, i64 7919, i64 7918, i64 7921, i64 7920, i64 7923, i64 7922, i64 7925, i64 7924, i64 7927, i64 7926, i64 7929, i64 7928, i64 7931, i64 7930, i64 7933, i64 7932, i64 7935, i64 7934, i64 7936, i64 7944, i64 7937, i64 7945, i64 7938, i64 7946, i64 7939, i64 7947, i64 7940, i64 7948, i64 7941, i64 7949, i64 7942, i64 7950, i64 7943, i64 7951, i64 7952, i64 7960, i64 7953, i64 7961, i64 7954, i64 7962, i64 7955, i64 7963, i64 7956, i64 7964, i64 7957, i64 7965, i64 7968, i64 7976, i64 7969, i64 7977, i64 7970, i64 7978, i64 7971, i64 7979, i64 7972, i64 7980, i64 7973, i64 7981, i64 7974, i64 7982, i64 7975, i64 7983, i64 7984, i64 7992, i64 7985, i64 7993, i64 7986, i64 7994, i64 7987, i64 7995, i64 7988, i64 7996, i64 7989, i64 7997, i64 7990, i64 7998, i64 7991, i64 7999, i64 8000, i64 8008, i64 8001, i64 8009, i64 8002, i64 8010, i64 8003, i64 8011, i64 8004, i64 8012, i64 8005, i64 8013, i64 8017, i64 8025, i64 8019, i64 8027, i64 8021, i64 8029, i64 8023, i64 8031, i64 8032, i64 8040, i64 8033, i64 8041, i64 8034, i64 8042, i64 8035, i64 8043, i64 8036, i64 8044, i64 8037, i64 8045, i64 8038, i64 8046, i64 8039, i64 8047, i64 8048, i64 8122, i64 8049, i64 8123, i64 8050, i64 8136, i64 8051, i64 8137, i64 8052, i64 8138, i64 8053, i64 8139, i64 8054, i64 8154, i64 8055, i64 8155, i64 8056, i64 8184, i64 8057, i64 8185, i64 8058, i64 8170, i64 8059, i64 8171, i64 8060, i64 8186, i64 8061, i64 8187, i64 8112, i64 8120, i64 8113, i64 8121, i64 8126, i64 921, i64 8144, i64 8152, i64 8145, i64 8153, i64 8160, i64 8168, i64 8161, i64 8169, i64 8165, i64 8172, i64 8526, i64 8498, i64 8560, i64 8544, i64 8561, i64 8545, i64 8562, i64 8546, i64 8563, i64 8547, i64 8564, i64 8548, i64 8565, i64 8549, i64 8566, i64 8550, i64 8567, i64 8551, i64 8568, i64 8552, i64 8569, i64 8553, i64 8570, i64 8554, i64 8571, i64 8555, i64 8572, i64 8556, i64 8573, i64 8557, i64 8574, i64 8558, i64 8575, i64 8559, i64 8580, i64 8579, i64 9424, i64 9398, i64 9425, i64 9399, i64 9426, i64 9400, i64 9427, i64 9401, i64 9428, i64 9402, i64 9429, i64 9403, i64 9430, i64 9404, i64 9431, i64 9405, i64 9432, i64 9406, i64 9433, i64 9407, i64 9434, i64 9408, i64 9435, i64 9409, i64 9436, i64 9410, i64 9437, i64 9411, i64 9438, i64 9412, i64 9439, i64 9413, i64 9440, i64 9414, i64 9441, i64 9415, i64 9442, i64 9416, i64 9443, i64 9417, i64 9444, i64 9418, i64 9445, i64 9419, i64 9446, i64 9420, i64 9447, i64 9421, i64 9448, i64 9422, i64 9449, i64 9423, i64 11312, i64 11264, i64 11313, i64 11265, i64 11314, i64 11266, i64 11315, i64 11267, i64 11316, i64 11268, i64 11317, i64 11269, i64 11318, i64 11270, i64 11319, i64 11271, i64 11320, i64 11272, i64 11321, i64 11273, i64 11322, i64 11274, i64 11323, i64 11275, i64 11324, i64 11276, i64 11325, i64 11277, i64 11326, i64 11278, i64 11327, i64 11279, i64 11328, i64 11280, i64 11329, i64 11281, i64 11330, i64 11282, i64 11331, i64 11283, i64 11332, i64 11284, i64 11333, i64 11285, i64 11334, i64 11286, i64 11335, i64 11287, i64 11336, i64 11288, i64 11337, i64 11289, i64 11338, i64 11290, i64 11339, i64 11291, i64 11340, i64 11292, i64 11341, i64 11293, i64 11342, i64 11294, i64 11343, i64 11295, i64 11344, i64 11296, i64 11345, i64 11297, i64 11346, i64 11298, i64 11347, i64 11299, i64 11348, i64 11300, i64 11349, i64 11301, i64 11350, i64 11302, i64 11351, i64 11303, i64 11352, i64 11304, i64 11353, i64 11305, i64 11354, i64 11306, i64 11355, i64 11307, i64 11356, i64 11308, i64 11357, i64 11309, i64 11358, i64 11310, i64 11359, i64 11311, i64 11361, i64 11360, i64 11365, i64 570, i64 11366, i64 574, i64 11368, i64 11367, i64 11370, i64 11369, i64 11372, i64 11371, i64 11379, i64 11378, i64 11382, i64 11381, i64 11393, i64 11392, i64 11395, i64 11394, i64 11397, i64 11396, i64 11399, i64 11398, i64 11401, i64 11400, i64 11403, i64 11402, i64 11405, i64 11404, i64 11407, i64 11406, i64 11409, i64 11408, i64 11411, i64 11410, i64 11413, i64 11412, i64 11415, i64 11414, i64 11417, i64 11416, i64 11419, i64 11418, i64 11421, i64 11420, i64 11423, i64 11422, i64 11425, i64 11424, i64 11427, i64 11426, i64 11429, i64 11428, i64 11431, i64 11430, i64 11433, i64 11432, i64 11435, i64 11434, i64 11437, i64 11436, i64 11439, i64 11438, i64 11441, i64 11440, i64 11443, i64 11442, i64 11445, i64 11444, i64 11447, i64 11446, i64 11449, i64 11448, i64 11451, i64 11450, i64 11453, i64 11452, i64 11455, i64 11454, i64 11457, i64 11456, i64 11459, i64 11458, i64 11461, i64 11460, i64 11463, i64 11462, i64 11465, i64 11464, i64 11467, i64 11466, i64 11469, i64 11468, i64 11471, i64 11470, i64 11473, i64 11472, i64 11475, i64 11474, i64 11477, i64 11476, i64 11479, i64 11478, i64 11481, i64 11480, i64 11483, i64 11482, i64 11485, i64 11484, i64 11487, i64 11486, i64 11489, i64 11488, i64 11491, i64 11490, i64 11500, i64 11499, i64 11502, i64 11501, i64 11507, i64 11506, i64 11520, i64 4256, i64 11521, i64 4257, i64 11522, i64 4258, i64 11523, i64 4259, i64 11524, i64 4260, i64 11525, i64 4261, i64 11526, i64 4262, i64 11527, i64 4263, i64 11528, i64 4264, i64 11529, i64 4265, i64 11530, i64 4266, i64 11531, i64 4267, i64 11532, i64 4268, i64 11533, i64 4269, i64 11534, i64 4270, i64 11535, i64 4271, i64 11536, i64 4272, i64 11537, i64 4273, i64 11538, i64 4274, i64 11539, i64 4275, i64 11540, i64 4276, i64 11541, i64 4277, i64 11542, i64 4278, i64 11543, i64 4279, i64 11544, i64 4280, i64 11545, i64 4281, i64 11546, i64 4282, i64 11547, i64 4283, i64 11548, i64 4284, i64 11549, i64 4285, i64 11550, i64 4286, i64 11551, i64 4287, i64 11552, i64 4288, i64 11553, i64 4289, i64 11554, i64 4290, i64 11555, i64 4291, i64 11556, i64 4292, i64 11557, i64 4293, i64 11559, i64 4295, i64 11565, i64 4301, i64 42561, i64 42560, i64 42563, i64 42562, i64 42565, i64 42564, i64 42567, i64 42566, i64 42569, i64 42568, i64 42571, i64 42570, i64 42573, i64 42572, i64 42575, i64 42574, i64 42577, i64 42576, i64 42579, i64 42578, i64 42581, i64 42580, i64 42583, i64 42582, i64 42585, i64 42584, i64 42587, i64 42586, i64 42589, i64 42588, i64 42591, i64 42590, i64 42593, i64 42592, i64 42595, i64 42594, i64 42597, i64 42596, i64 42599, i64 42598, i64 42601, i64 42600, i64 42603, i64 42602, i64 42605, i64 42604, i64 42625, i64 42624, i64 42627, i64 42626, i64 42629, i64 42628, i64 42631, i64 42630, i64 42633, i64 42632, i64 42635, i64 42634, i64 42637, i64 42636, i64 42639, i64 42638, i64 42641, i64 42640, i64 42643, i64 42642, i64 42645, i64 42644, i64 42647, i64 42646, i64 42649, i64 42648, i64 42651, i64 42650, i64 42787, i64 42786, i64 42789, i64 42788, i64 42791, i64 42790, i64 42793, i64 42792, i64 42795, i64 42794, i64 42797, i64 42796, i64 42799, i64 42798, i64 42803, i64 42802, i64 42805, i64 42804, i64 42807, i64 42806, i64 42809, i64 42808, i64 42811, i64 42810, i64 42813, i64 42812, i64 42815, i64 42814, i64 42817, i64 42816, i64 42819, i64 42818, i64 42821, i64 42820, i64 42823, i64 42822, i64 42825, i64 42824, i64 42827, i64 42826, i64 42829, i64 42828, i64 42831, i64 42830, i64 42833, i64 42832, i64 42835, i64 42834, i64 42837, i64 42836, i64 42839, i64 42838, i64 42841, i64 42840, i64 42843, i64 42842, i64 42845, i64 42844, i64 42847, i64 42846, i64 42849, i64 42848, i64 42851, i64 42850, i64 42853, i64 42852, i64 42855, i64 42854, i64 42857, i64 42856, i64 42859, i64 42858, i64 42861, i64 42860, i64 42863, i64 42862, i64 42874, i64 42873, i64 42876, i64 42875, i64 42879, i64 42878, i64 42881, i64 42880, i64 42883, i64 42882, i64 42885, i64 42884, i64 42887, i64 42886, i64 42892, i64 42891, i64 42897, i64 42896, i64 42899, i64 42898, i64 42900, i64 42948, i64 42903, i64 42902, i64 42905, i64 42904, i64 42907, i64 42906, i64 42909, i64 42908, i64 42911, i64 42910, i64 42913, i64 42912, i64 42915, i64 42914, i64 42917, i64 42916, i64 42919, i64 42918, i64 42921, i64 42920, i64 42933, i64 42932, i64 42935, i64 42934, i64 42937, i64 42936, i64 42939, i64 42938, i64 42941, i64 42940, i64 42943, i64 42942, i64 42945, i64 42944, i64 42947, i64 42946, i64 42952, i64 42951, i64 42954, i64 42953, i64 42957, i64 42956, i64 42961, i64 42960, i64 42967, i64 42966, i64 42969, i64 42968, i64 42971, i64 42970, i64 42998, i64 42997, i64 43859, i64 42931, i64 43888, i64 5024, i64 43889, i64 5025, i64 43890, i64 5026, i64 43891, i64 5027, i64 43892, i64 5028, i64 43893, i64 5029, i64 43894, i64 5030, i64 43895, i64 5031, i64 43896, i64 5032, i64 43897, i64 5033, i64 43898, i64 5034, i64 43899, i64 5035, i64 43900, i64 5036, i64 43901, i64 5037, i64 43902, i64 5038, i64 43903, i64 5039, i64 43904, i64 5040, i64 43905, i64 5041, i64 43906, i64 5042, i64 43907, i64 5043, i64 43908, i64 5044, i64 43909, i64 5045, i64 43910, i64 5046, i64 43911, i64 5047, i64 43912, i64 5048, i64 43913, i64 5049, i64 43914, i64 5050, i64 43915, i64 5051, i64 43916, i64 5052, i64 43917, i64 5053, i64 43918, i64 5054, i64 43919, i64 5055, i64 43920, i64 5056, i64 43921, i64 5057, i64 43922, i64 5058, i64 43923, i64 5059, i64 43924, i64 5060, i64 43925, i64 5061, i64 43926, i64 5062, i64 43927, i64 5063, i64 43928, i64 5064, i64 43929, i64 5065, i64 43930, i64 5066, i64 43931, i64 5067, i64 43932, i64 5068, i64 43933, i64 5069, i64 43934, i64 5070, i64 43935, i64 5071, i64 43936, i64 5072, i64 43937, i64 5073, i64 43938, i64 5074, i64 43939, i64 5075, i64 43940, i64 5076, i64 43941, i64 5077, i64 43942, i64 5078, i64 43943, i64 5079, i64 43944, i64 5080, i64 43945, i64 5081, i64 43946, i64 5082, i64 43947, i64 5083, i64 43948, i64 5084, i64 43949, i64 5085, i64 43950, i64 5086, i64 43951, i64 5087, i64 43952, i64 5088, i64 43953, i64 5089, i64 43954, i64 5090, i64 43955, i64 5091, i64 43956, i64 5092, i64 43957, i64 5093, i64 43958, i64 5094, i64 43959, i64 5095, i64 43960, i64 5096, i64 43961, i64 5097, i64 43962, i64 5098, i64 43963, i64 5099, i64 43964, i64 5100, i64 43965, i64 5101, i64 43966, i64 5102, i64 43967, i64 5103, i64 65345, i64 65313, i64 65346, i64 65314, i64 65347, i64 65315, i64 65348, i64 65316, i64 65349, i64 65317, i64 65350, i64 65318, i64 65351, i64 65319, i64 65352, i64 65320, i64 65353, i64 65321, i64 65354, i64 65322, i64 65355, i64 65323, i64 65356, i64 65324, i64 65357, i64 65325, i64 65358, i64 65326, i64 65359, i64 65327, i64 65360, i64 65328, i64 65361, i64 65329, i64 65362, i64 65330, i64 65363, i64 65331, i64 65364, i64 65332, i64 65365, i64 65333, i64 65366, i64 65334, i64 65367, i64 65335, i64 65368, i64 65336, i64 65369, i64 65337, i64 65370, i64 65338, i64 66600, i64 66560, i64 66601, i64 66561, i64 66602, i64 66562, i64 66603, i64 66563, i64 66604, i64 66564, i64 66605, i64 66565, i64 66606, i64 66566, i64 66607, i64 66567, i64 66608, i64 66568, i64 66609, i64 66569, i64 66610, i64 66570, i64 66611, i64 66571, i64 66612, i64 66572, i64 66613, i64 66573, i64 66614, i64 66574, i64 66615, i64 66575, i64 66616, i64 66576, i64 66617, i64 66577, i64 66618, i64 66578, i64 66619, i64 66579, i64 66620, i64 66580, i64 66621, i64 66581, i64 66622, i64 66582, i64 66623, i64 66583, i64 66624, i64 66584, i64 66625, i64 66585, i64 66626, i64 66586, i64 66627, i64 66587, i64 66628, i64 66588, i64 66629, i64 66589, i64 66630, i64 66590, i64 66631, i64 66591, i64 66632, i64 66592, i64 66633, i64 66593, i64 66634, i64 66594, i64 66635, i64 66595, i64 66636, i64 66596, i64 66637, i64 66597, i64 66638, i64 66598, i64 66639, i64 66599, i64 66776, i64 66736, i64 66777, i64 66737, i64 66778, i64 66738, i64 66779, i64 66739, i64 66780, i64 66740, i64 66781, i64 66741, i64 66782, i64 66742, i64 66783, i64 66743, i64 66784, i64 66744, i64 66785, i64 66745, i64 66786, i64 66746, i64 66787, i64 66747, i64 66788, i64 66748, i64 66789, i64 66749, i64 66790, i64 66750, i64 66791, i64 66751, i64 66792, i64 66752, i64 66793, i64 66753, i64 66794, i64 66754, i64 66795, i64 66755, i64 66796, i64 66756, i64 66797, i64 66757, i64 66798, i64 66758, i64 66799, i64 66759, i64 66800, i64 66760, i64 66801, i64 66761, i64 66802, i64 66762, i64 66803, i64 66763, i64 66804, i64 66764, i64 66805, i64 66765, i64 66806, i64 66766, i64 66807, i64 66767, i64 66808, i64 66768, i64 66809, i64 66769, i64 66810, i64 66770, i64 66811, i64 66771, i64 66967, i64 66928, i64 66968, i64 66929, i64 66969, i64 66930, i64 66970, i64 66931, i64 66971, i64 66932, i64 66972, i64 66933, i64 66973, i64 66934, i64 66974, i64 66935, i64 66975, i64 66936, i64 66976, i64 66937, i64 66977, i64 66938, i64 66979, i64 66940, i64 66980, i64 66941, i64 66981, i64 66942, i64 66982, i64 66943, i64 66983, i64 66944, i64 66984, i64 66945, i64 66985, i64 66946, i64 66986, i64 66947, i64 66987, i64 66948, i64 66988, i64 66949, i64 66989, i64 66950, i64 66990, i64 66951, i64 66991, i64 66952, i64 66992, i64 66953, i64 66993, i64 66954, i64 66995, i64 66956, i64 66996, i64 66957, i64 66997, i64 66958, i64 66998, i64 66959, i64 66999, i64 66960, i64 67000, i64 66961, i64 67001, i64 66962, i64 67003, i64 66964, i64 67004, i64 66965, i64 68800, i64 68736, i64 68801, i64 68737, i64 68802, i64 68738, i64 68803, i64 68739, i64 68804, i64 68740, i64 68805, i64 68741, i64 68806, i64 68742, i64 68807, i64 68743, i64 68808, i64 68744, i64 68809, i64 68745, i64 68810, i64 68746, i64 68811, i64 68747, i64 68812, i64 68748, i64 68813, i64 68749, i64 68814, i64 68750, i64 68815, i64 68751, i64 68816, i64 68752, i64 68817, i64 68753, i64 68818, i64 68754, i64 68819, i64 68755, i64 68820, i64 68756, i64 68821, i64 68757, i64 68822, i64 68758, i64 68823, i64 68759, i64 68824, i64 68760, i64 68825, i64 68761, i64 68826, i64 68762, i64 68827, i64 68763, i64 68828, i64 68764, i64 68829, i64 68765, i64 68830, i64 68766, i64 68831, i64 68767, i64 68832, i64 68768, i64 68833, i64 68769, i64 68834, i64 68770, i64 68835, i64 68771, i64 68836, i64 68772, i64 68837, i64 68773, i64 68838, i64 68774, i64 68839, i64 68775, i64 68840, i64 68776, i64 68841, i64 68777, i64 68842, i64 68778, i64 68843, i64 68779, i64 68844, i64 68780, i64 68845, i64 68781, i64 68846, i64 68782, i64 68847, i64 68783, i64 68848, i64 68784, i64 68849, i64 68785, i64 68850, i64 68786, i64 68976, i64 68944, i64 68977, i64 68945, i64 68978, i64 68946, i64 68979, i64 68947, i64 68980, i64 68948, i64 68981, i64 68949, i64 68982, i64 68950, i64 68983, i64 68951, i64 68984, i64 68952, i64 68985, i64 68953, i64 68986, i64 68954, i64 68987, i64 68955, i64 68988, i64 68956, i64 68989, i64 68957, i64 68990, i64 68958, i64 68991, i64 68959, i64 68992, i64 68960, i64 68993, i64 68961, i64 68994, i64 68962, i64 68995, i64 68963, i64 68996, i64 68964, i64 68997, i64 68965, i64 71872, i64 71840, i64 71873, i64 71841, i64 71874, i64 71842, i64 71875, i64 71843, i64 71876, i64 71844, i64 71877, i64 71845, i64 71878, i64 71846, i64 71879, i64 71847, i64 71880, i64 71848, i64 71881, i64 71849, i64 71882, i64 71850, i64 71883, i64 71851, i64 71884, i64 71852, i64 71885, i64 71853, i64 71886, i64 71854, i64 71887, i64 71855, i64 71888, i64 71856, i64 71889, i64 71857, i64 71890, i64 71858, i64 71891, i64 71859, i64 71892, i64 71860, i64 71893, i64 71861, i64 71894, i64 71862, i64 71895, i64 71863, i64 71896, i64 71864, i64 71897, i64 71865, i64 71898, i64 71866, i64 71899, i64 71867, i64 71900, i64 71868, i64 71901, i64 71869, i64 71902, i64 71870, i64 71903, i64 71871, i64 93792, i64 93760, i64 93793, i64 93761, i64 93794, i64 93762, i64 93795, i64 93763, i64 93796, i64 93764, i64 93797, i64 93765, i64 93798, i64 93766, i64 93799, i64 93767, i64 93800, i64 93768, i64 93801, i64 93769, i64 93802, i64 93770, i64 93803, i64 93771, i64 93804, i64 93772, i64 93805, i64 93773, i64 93806, i64 93774, i64 93807, i64 93775, i64 93808, i64 93776, i64 93809, i64 93777, i64 93810, i64 93778, i64 93811, i64 93779, i64 93812, i64 93780, i64 93813, i64 93781, i64 93814, i64 93782, i64 93815, i64 93783, i64 93816, i64 93784, i64 93817, i64 93785, i64 93818, i64 93786, i64 93819, i64 93787, i64 93820, i64 93788, i64 93821, i64 93789, i64 93822, i64 93790, i64 93823, i64 93791, i64 125218, i64 125184, i64 125219, i64 125185, i64 125220, i64 125186, i64 125221, i64 125187, i64 125222, i64 125188, i64 125223, i64 125189, i64 125224, i64 125190, i64 125225, i64 125191, i64 125226, i64 125192, i64 125227, i64 125193, i64 125228, i64 125194, i64 125229, i64 125195, i64 125230, i64 125196, i64 125231, i64 125197, i64 125232, i64 125198, i64 125233, i64 125199, i64 125234, i64 125200, i64 125235, i64 125201, i64 125236, i64 125202, i64 125237, i64 125203, i64 125238, i64 125204, i64 125239, i64 125205, i64 125240, i64 125206, i64 125241, i64 125207, i64 125242, i64 125208, i64 125243, i64 125209, i64 125244, i64 125210, i64 125245, i64 125211, i64 125246, i64 125212, i64 125247, i64 125213, i64 125248, i64 125214, i64 125249, i64 125215, i64 125250, i64 125216, i64 125251, i64 125217], align 16
@rtt.12450 = private unnamed_addr constant [913 x i64] [i64 223, i64 2, i64 83, i64 83, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 329, i64 3, i64 202, i64 188, i64 78, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 496, i64 3, i64 74, i64 204, i64 140, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 912, i64 6, i64 206, i64 153, i64 204, i64 136, i64 204, i64 129, i64 0, i64 0, i64 0, i64 944, i64 6, i64 206, i64 165, i64 204, i64 136, i64 204, i64 129, i64 0, i64 0, i64 0, i64 7830, i64 3, i64 72, i64 204, i64 177, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7831, i64 3, i64 84, i64 204, i64 136, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7832, i64 3, i64 87, i64 204, i64 138, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7833, i64 3, i64 89, i64 204, i64 138, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7834, i64 3, i64 65, i64 202, i64 190, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8064, i64 5, i64 225, i64 188, i64 136, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8065, i64 5, i64 225, i64 188, i64 137, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8066, i64 5, i64 225, i64 188, i64 138, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8067, i64 5, i64 225, i64 188, i64 139, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8068, i64 5, i64 225, i64 188, i64 140, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8069, i64 5, i64 225, i64 188, i64 141, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8070, i64 5, i64 225, i64 188, i64 142, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8071, i64 5, i64 225, i64 188, i64 143, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8072, i64 5, i64 225, i64 188, i64 136, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8073, i64 5, i64 225, i64 188, i64 137, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8074, i64 5, i64 225, i64 188, i64 138, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8075, i64 5, i64 225, i64 188, i64 139, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8076, i64 5, i64 225, i64 188, i64 140, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8077, i64 5, i64 225, i64 188, i64 141, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8078, i64 5, i64 225, i64 188, i64 142, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8079, i64 5, i64 225, i64 188, i64 143, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8080, i64 5, i64 225, i64 190, i64 152, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8081, i64 5, i64 225, i64 190, i64 153, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8082, i64 5, i64 225, i64 190, i64 154, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8083, i64 5, i64 225, i64 190, i64 155, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8084, i64 5, i64 225, i64 190, i64 156, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8085, i64 5, i64 225, i64 190, i64 157, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8086, i64 5, i64 225, i64 190, i64 158, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8087, i64 5, i64 225, i64 190, i64 159, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8088, i64 5, i64 225, i64 190, i64 152, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8089, i64 5, i64 225, i64 190, i64 153, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8090, i64 5, i64 225, i64 190, i64 154, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8091, i64 5, i64 225, i64 190, i64 155, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8092, i64 5, i64 225, i64 190, i64 156, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8093, i64 5, i64 225, i64 190, i64 157, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8094, i64 5, i64 225, i64 190, i64 158, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8095, i64 5, i64 225, i64 190, i64 159, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8096, i64 5, i64 225, i64 190, i64 168, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8097, i64 5, i64 225, i64 190, i64 169, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8098, i64 5, i64 225, i64 190, i64 170, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8099, i64 5, i64 225, i64 190, i64 171, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8100, i64 5, i64 225, i64 190, i64 172, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8101, i64 5, i64 225, i64 190, i64 173, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8102, i64 5, i64 225, i64 190, i64 174, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8103, i64 5, i64 225, i64 190, i64 175, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8104, i64 5, i64 225, i64 190, i64 168, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8105, i64 5, i64 225, i64 190, i64 169, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8106, i64 5, i64 225, i64 190, i64 170, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8107, i64 5, i64 225, i64 190, i64 171, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8108, i64 5, i64 225, i64 190, i64 172, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8109, i64 5, i64 225, i64 190, i64 173, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8110, i64 5, i64 225, i64 190, i64 174, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8111, i64 5, i64 225, i64 190, i64 175, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8114, i64 5, i64 225, i64 190, i64 186, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 8115, i64 4, i64 206, i64 145, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8116, i64 4, i64 206, i64 134, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8118, i64 4, i64 206, i64 145, i64 205, i64 130, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8119, i64 6, i64 206, i64 145, i64 205, i64 130, i64 205, i64 133, i64 0, i64 0, i64 0, i64 8124, i64 4, i64 206, i64 145, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8130, i64 5, i64 225, i64 191, i64 138, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 8131, i64 4, i64 206, i64 151, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8132, i64 4, i64 206, i64 137, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8134, i64 4, i64 206, i64 151, i64 205, i64 130, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8135, i64 6, i64 206, i64 151, i64 205, i64 130, i64 205, i64 133, i64 0, i64 0, i64 0, i64 8140, i64 4, i64 206, i64 151, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8178, i64 5, i64 225, i64 191, i64 186, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 8179, i64 4, i64 206, i64 169, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8180, i64 4, i64 206, i64 143, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8182, i64 4, i64 206, i64 169, i64 205, i64 130, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8183, i64 6, i64 206, i64 169, i64 205, i64 130, i64 205, i64 133, i64 0, i64 0, i64 0, i64 8188, i64 4, i64 206, i64 169, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64256, i64 2, i64 70, i64 70, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64257, i64 2, i64 70, i64 73, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64258, i64 2, i64 70, i64 76, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64259, i64 3, i64 70, i64 70, i64 73, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64260, i64 3, i64 70, i64 70, i64 76, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64261, i64 2, i64 83, i64 84, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64262, i64 2, i64 83, i64 84, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0], align 16
@.s1735 = private unnamed_addr constant [10 x i8] c"List(Str)\00"
@rtg.split_one = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.strtod_end = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.stat_buf = internal thread_local global [144 x i8] zeroinitializer, align 16
@.s2190 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.s2205 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.s2242 = private unnamed_addr constant [10 x i8] c"List(Str)\00"
@.s2320 = private unnamed_addr constant [5 x i8] c"File\00"
@rtg.rt_args = internal global [24 x i8] zeroinitializer, align 16
@.s2383 = private unnamed_addr constant [19 x i8] c"/proc/self/cmdline\00"
@.s2386 = private unnamed_addr constant [19 x i8] c"/proc/self/cmdline\00"
@rtg.wait_status = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s2558 = private unnamed_addr constant [2 x i8] c"r\00"
@.s2595 = private unnamed_addr constant [15 x i8] c"git rev-parse \00"
@.s2598 = private unnamed_addr constant [13 x i8] c" 2>/dev/null\00"
@.s2602 = private unnamed_addr constant [44 x i8] c"git rev-parse --abbrev-ref HEAD 2>/dev/null\00"
@rtt.17089 = private unnamed_addr constant [64 x i64] [i64 1116352408, i64 1899447441, i64 3049323471, i64 3921009573, i64 961987163, i64 1508970993, i64 2453635748, i64 2870763221, i64 3624381080, i64 310598401, i64 607225278, i64 1426881987, i64 1925078388, i64 2162078206, i64 2614888103, i64 3248222580, i64 3835390401, i64 4022224774, i64 264347078, i64 604807628, i64 770255983, i64 1249150122, i64 1555081692, i64 1996064986, i64 2554220882, i64 2821834349, i64 2952996808, i64 3210313671, i64 3336571891, i64 3584528711, i64 113926993, i64 338241895, i64 666307205, i64 773529912, i64 1294757372, i64 1396182291, i64 1695183700, i64 1986661051, i64 2177026350, i64 2456956037, i64 2730485921, i64 2820302411, i64 3259730800, i64 3345764771, i64 3516065817, i64 3600352804, i64 4094571909, i64 275423344, i64 430227734, i64 506948616, i64 659060556, i64 883997877, i64 958139571, i64 1322822218, i64 1537002063, i64 1747873779, i64 1955562222, i64 2024104815, i64 2227730452, i64 2361852424, i64 2428436474, i64 2756734187, i64 3204031479, i64 3329325298], align 16
@rtt.17603 = private unnamed_addr constant [8 x i64] [i64 1779033703, i64 3144134277, i64 1013904242, i64 2773480762, i64 1359893119, i64 2600822924, i64 528734635, i64 1541459225], align 16
@.s2926 = private unnamed_addr constant [17 x i8] c"0123456789abcdef\00"
@rtg.rt_dbg = internal global [8224 x i8] zeroinitializer, align 16
@rtg.dbg_status = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.dbg_msg = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.dbg_peek = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtt.18840 = private unnamed_addr constant [17 x i64] [i64 80, i64 96, i64 88, i64 40, i64 104, i64 112, i64 32, i64 152, i64 72, i64 64, i64 56, i64 48, i64 24, i64 16, i64 8, i64 0, i64 128], align 16
@rtg.dbg_regs = internal thread_local global [256 x i8] zeroinitializer, align 16
@.s3199 = private unnamed_addr constant [15 x i8] c"RESID_STACK_MB\00"
@rtg.numfmt_buf = internal thread_local global [32 x i8] zeroinitializer, align 16
@rtg.limb_buf = internal thread_local global [208 x i8] zeroinitializer, align 16
@rtg.limbs = internal thread_local global [64 x i8] zeroinitializer, align 16
@rtg.ftoa_buf = internal thread_local global [64 x i8] zeroinitializer, align 16
@.s3448 = private unnamed_addr constant [6 x i8] c"%.17g\00"
@.s3453 = private unnamed_addr constant [5 x i8] c"true\00"
@.s3455 = private unnamed_addr constant [6 x i8] c"false\00"
@.s3806 = private unnamed_addr constant [4 x i8] c"nan\00"
@.s3808 = private unnamed_addr constant [5 x i8] c"-inf\00"
@.s3810 = private unnamed_addr constant [4 x i8] c"inf\00"
@rtg.f128_m = internal thread_local global [2080 x i8] zeroinitializer, align 16
@rtg.f128_ip = internal thread_local global [2080 x i8] zeroinitializer, align 16
@rtg.f128_ib = internal thread_local global [5000 x i8] zeroinitializer, align 16
@rtg.f128_fd = internal thread_local global [64 x i8] zeroinitializer, align 16
@.s3851 = private unnamed_addr constant [2 x i8] c"0\00"
@rtg.f128_lead = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s3871 = private unnamed_addr constant [3 x i8] c"-0\00"
@.s3873 = private unnamed_addr constant [2 x i8] c"0\00"
@rtg.f128_digits = internal thread_local global [48 x i8] zeroinitializer, align 16
@rtg.f128_out = internal thread_local global [112 x i8] zeroinitializer, align 16
@rtg.show_buf = internal thread_local global [64 x i8] zeroinitializer, align 16
@.s4060 = private unnamed_addr constant [6 x i8] c"%.17g\00"
@.s4071 = private unnamed_addr constant [5 x i8] c"true\00"
@.s4073 = private unnamed_addr constant [6 x i8] c"false\00"
@.s4080 = private unnamed_addr constant [5 x i8] c"null\00"
@.s4085 = private unnamed_addr constant [4 x i8] c"…\00"
@.s4091 = private unnamed_addr constant [3 x i8] c", \00"
@.s4101 = private unnamed_addr constant [3 x i8] c", \00"
@.s4120 = private unnamed_addr constant [5 x i8] c"null\00"
@.s4129 = private unnamed_addr constant [5 x i8] c"i128\00"
@.s4141 = private unnamed_addr constant [5 x i8] c"u128\00"
@.s4172 = private unnamed_addr constant [6 x i8] c"Some(\00"
@.s4174 = private unnamed_addr constant [6 x i8] c"Some<\00"
@.s4183 = private unnamed_addr constant [2 x i8] c")\00"
@.s4185 = private unnamed_addr constant [2 x i8] c">\00"
@.s4191 = private unnamed_addr constant [5 x i8] c"None\00"
@.s4196 = private unnamed_addr constant [2 x i8] c"(\00"
@.s4201 = private unnamed_addr constant [2 x i8] c")\00"
@.s4206 = private unnamed_addr constant [5 x i8] c"null\00"
@.s4213 = private unnamed_addr constant [2 x i8] c"(\00"
@.s4222 = private unnamed_addr constant [2 x i8] c")\00"
@.s4228 = private unnamed_addr constant [3 x i8] c", \00"
@rtg.rand_byte = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s4407 = private unnamed_addr constant [13 x i8] c"/dev/urandom\00"
@.s4412 = private unnamed_addr constant [38 x i8] c"crypto_random_byte: no entropy source\00"
@.s4417 = private unnamed_addr constant [32 x i8] c"crypto_random_byte: read failed\00"
@.s4424 = private unnamed_addr constant [33 x i8] c"list index out of bounds: index \00"
@.s4428 = private unnamed_addr constant [10 x i8] c", length \00"
@.s4437 = private unnamed_addr constant [3 x i8] c" (\00"
@.s4442 = private unnamed_addr constant [2 x i8] c")\00"
@rtg.ai_hints = internal thread_local global [48 x i8] zeroinitializer, align 16
@rtg.ai_port = internal thread_local global [24 x i8] zeroinitializer, align 16
@rtg.ai_res = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.ai_tv = internal thread_local global [16 x i8] zeroinitializer, align 16
@.s4601 = private unnamed_addr constant [5 x i8] c"List\00"
@rtg.rt_catch = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.rt_catch_msg = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s4633 = private unnamed_addr constant [13 x i8] c"region abort\00"
@.s4649 = private unnamed_addr constant [13 x i8] c"resid: abort\00"
@.s4652 = private unnamed_addr constant [3 x i8] c": \00"
@.s4655 = private unnamed_addr constant [6 x i8] c"abort\00"
@.s4660 = private unnamed_addr constant [3 x i8] c" (\00"
@.s4666 = private unnamed_addr constant [2 x i8] c")\00"
@.s4674 = private unnamed_addr constant [3 x i8] c": \00"
@.s4680 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.s4704 = private unnamed_addr constant [21 x i8] c"child region aborted\00"
@rtg.spawn_slot = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s4711 = private unnamed_addr constant [7 x i8] c"Result\00"
@rtg.spawn_ret = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s4735 = private unnamed_addr constant [7 x i8] c"Result\00"
@rtg.rt_test = internal global [96 x i8] zeroinitializer, align 16
@rtg.rt_test_fail = internal global [1024 x i8] zeroinitializer, align 16
@rtg.rt_test_fmt_read = internal global [8 x i8] zeroinitializer, align 16
@.s4760 = private unnamed_addr constant [18 x i8] c"RESID_TEST_FORMAT\00"
@.s4765 = private unnamed_addr constant [4 x i8] c"tap\00"
@.s4772 = private unnamed_addr constant [5 x i8] c"json\00"
@rtg.test_ms = internal thread_local global [64 x i8] zeroinitializer, align 16
@.s4794 = private unnamed_addr constant [1 x i8] c"\00"
@.s4799 = private unnamed_addr constant [21 x i8] c"expectation failed: \00"
@.s4803 = private unnamed_addr constant [2 x i8] c"?\00"
@.s4808 = private unnamed_addr constant [16 x i8] c"\0A    actual:   \00"
@.s4818 = private unnamed_addr constant [16 x i8] c"\0A    expected: \00"
@rtg.expect_buf = internal thread_local global [1024 x i8] zeroinitializer, align 16
@.s4854 = private unnamed_addr constant [18 x i8] c"RESID_TEST_FILTER\00"
@.s4863 = private unnamed_addr constant [1 x i8] c"\00"
@.s4868 = private unnamed_addr constant [1 x i8] c"\00"
@.s4875 = private unnamed_addr constant [19 x i8] c"TAP version 13\0A1..\00"
@.s4880 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.s4886 = private unnamed_addr constant [12 x i8] c"{\22module\22:\22\00"
@.s4892 = private unnamed_addr constant [12 x i8] c"\22,\22tests\22:[\00"
@.s4898 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.s4904 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.s4919 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.s4938 = private unnamed_addr constant [8 x i8] c"not ok \00"
@.s4940 = private unnamed_addr constant [4 x i8] c"ok \00"
@.s4946 = private unnamed_addr constant [2 x i8] c" \00"
@.s4953 = private unnamed_addr constant [2 x i8] c".\00"
@.s4959 = private unnamed_addr constant [18 x i8] c" # SKIP filtered\0A\00"
@.s4962 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.s4966 = private unnamed_addr constant [20 x i8] c"  ---\0A  message: |\0A\00"
@.s4970 = private unnamed_addr constant [5 x i8] c"    \00"
@.s4973 = private unnamed_addr constant [7 x i8] c"  ...\0A\00"
@.s4978 = private unnamed_addr constant [2 x i8] c",\00"
@.s4982 = private unnamed_addr constant [10 x i8] c"{\22name\22:\22\00"
@.s4987 = private unnamed_addr constant [13 x i8] c"\22,\22status\22:\22\00"
@.s4991 = private unnamed_addr constant [8 x i8] c"skipped\00"
@.s4993 = private unnamed_addr constant [7 x i8] c"failed\00"
@.s4995 = private unnamed_addr constant [7 x i8] c"passed\00"
@.s5000 = private unnamed_addr constant [17 x i8] c"\22,\22duration_ms\22:\00"
@.s5003 = private unnamed_addr constant [5 x i8] c"%.3f\00"
@.s5007 = private unnamed_addr constant [2 x i8] c"}\00"
@.s5012 = private unnamed_addr constant [5 x i8] c"  - \00"
@.s5017 = private unnamed_addr constant [12 x i8] c" (skipped)\0A\00"
@.s5021 = private unnamed_addr constant [7 x i8] c"  ✗ \00"
@.s5023 = private unnamed_addr constant [7 x i8] c"  ✓ \00"
@.s5028 = private unnamed_addr constant [3 x i8] c" (\00"
@.s5032 = private unnamed_addr constant [5 x i8] c"%.0f\00"
@.s5036 = private unnamed_addr constant [5 x i8] c"ms)\0A\00"
@.s5041 = private unnamed_addr constant [5 x i8] c"    \00"
@rtg.test_clock = internal thread_local global [16 x i8] zeroinitializer, align 16
@.s5056 = private unnamed_addr constant [10 x i8] c"<unnamed>\00"
@.s5096 = private unnamed_addr constant [8 x i8] c"aborted\00"
@.s5134 = private unnamed_addr constant [12 x i8] c"],\22passed\22:\00"
@.s5140 = private unnamed_addr constant [11 x i8] c",\22failed\22:\00"
@.s5147 = private unnamed_addr constant [12 x i8] c",\22skipped\22:\00"
@.s5154 = private unnamed_addr constant [16 x i8] c",\22duration_ms\22:\00"
@.s5158 = private unnamed_addr constant [5 x i8] c"%.3f\00"
@.s5162 = private unnamed_addr constant [3 x i8] c"}\0A\00"
@.s5174 = private unnamed_addr constant [12 x i8] c"\0AFailures: \00"
@.s5180 = private unnamed_addr constant [12 x i8] c" | Passed: \00"
@.s5189 = private unnamed_addr constant [13 x i8] c" | Skipped: \00"
@.s5196 = private unnamed_addr constant [14 x i8] c" | Duration: \00"
@.s5199 = private unnamed_addr constant [5 x i8] c"%.0f\00"
@.s5203 = private unnamed_addr constant [4 x i8] c"ms\0A\00"
@rtt.25383 = private unnamed_addr constant [20 x i64] [i64 1, i64 10, i64 100, i64 1000, i64 10000, i64 100000, i64 1000000, i64 10000000, i64 100000000, i64 1000000000, i64 10000000000, i64 100000000000, i64 1000000000000, i64 10000000000000, i64 100000000000000, i64 1000000000000000, i64 10000000000000000, i64 100000000000000000, i64 1000000000000000000, i64 0], align 16
@rtg.dec_r2 = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s5370 = private unnamed_addr constant [21 x i8] c"dec: value too large\00"
@.s5418 = private unnamed_addr constant [28 x i8] c"dec: precision out of range\00"
@.s5537 = private unnamed_addr constant [27 x i8] c"dec: exponent out of range\00"
@.s6736 = private unnamed_addr constant [22 x i8] c"dec: division by zero\00"
@.s6797 = private unnamed_addr constant [14 x i8] c"dec: internal\00"
@.s7025 = private unnamed_addr constant [27 x i8] c"dec: exponent out of range\00"
@.s7091 = private unnamed_addr constant [24 x i8] c"dec: bad decimal string\00"
@rtg.dec_one = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s7140 = private unnamed_addr constant [2 x i8] c"0\00"
@.s7302 = private unnamed_addr constant [24 x i8] c"dec: non-integer to Int\00"
@.s7308 = private unnamed_addr constant [32 x i8] c"dec: value out of range for Int\00"
@.s7350 = private unnamed_addr constant [32 x i8] c"dec: value out of range for Int\00"
@rtg.dec_f64 = internal thread_local global [96 x i8] zeroinitializer, align 16
@rtg.pvec_one = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.list_seed = internal thread_local global [32 x i8] zeroinitializer, align 16
@.s7934 = private unnamed_addr constant [31 x i8] c"range too large to materialize\00"
@.s7941 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.s7956 = private unnamed_addr constant [31 x i8] c"range too large to materialize\00"
@.s7962 = private unnamed_addr constant [17 x i8] c"assertion failed\00"
@.s7966 = private unnamed_addr constant [3 x i8] c": \00"
@.s7976 = private unnamed_addr constant [16 x i8] c"not implemented\00"
@.s7978 = private unnamed_addr constant [20 x i8] c"not yet implemented\00"
@.s7983 = private unnamed_addr constant [3 x i8] c": \00"
@rtg.map_ret = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.map_flag = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.map_heap = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.map_fbuf = internal thread_local global [64 x i8] zeroinitializer, align 16
@.s8203 = private unnamed_addr constant [6 x i8] c"%.17g\00"
@.s8226 = private unnamed_addr constant [4 x i8] c"i64\00"
@.s8229 = private unnamed_addr constant [4 x i8] c"f64\00"
@.s8232 = private unnamed_addr constant [5 x i8] c"bool\00"
@.s8235 = private unnamed_addr constant [5 x i8] c"i128\00"
@.s8238 = private unnamed_addr constant [5 x i8] c"u128\00"
@.s8270 = private unnamed_addr constant [2 x i8] c"t\00"
@.s8272 = private unnamed_addr constant [2 x i8] c"f\00"
@rtg.map_ubuf = internal thread_local global [32 x i8] zeroinitializer, align 16
@.s8286 = private unnamed_addr constant [2 x i8] c"?\00"
@.s8290 = private unnamed_addr constant [4 x i8] c"Str\00"
@.s8294 = private unnamed_addr constant [1 x i8] c"\00"
@.s8299 = private unnamed_addr constant [2 x i8] c"?\00"
@.s8397 = private unnamed_addr constant [4 x i8] c"Str\00"
@.s8401 = private unnamed_addr constant [4 x i8] c"Str\00"
@rtg.map_edit_seq = internal global [8 x i8] zeroinitializer, align 16
@rtg.map_one = internal global [8 x i8] zeroinitializer, align 16
@rtg.map_base = internal thread_local global [24 x i8] zeroinitializer, align 16
@rtg.map_own = internal thread_local global [16 x i8] zeroinitializer, align 16
@rtg.map_own_seq = internal global [8 x i8] zeroinitializer, align 16
@rtg.map_one_elem = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s10810 = private unnamed_addr constant [5 x i8] c"list\00"
@.s10818 = private unnamed_addr constant [5 x i8] c"list\00"
@.s10836 = private unnamed_addr constant [5 x i8] c"true\00"
@.s10838 = private unnamed_addr constant [6 x i8] c"false\00"
@.s10846 = private unnamed_addr constant [3 x i8] c", \00"
@.s10855 = private unnamed_addr constant [3 x i8] c": \00"
@.s10874 = private unnamed_addr constant [2 x i8] c"{\00"
@.s10878 = private unnamed_addr constant [2 x i8] c"}\00"
@.s11083 = private unnamed_addr constant [2 x i8] c"{\00"
@.s11087 = private unnamed_addr constant [2 x i8] c"}\00"
@rtg.rt_alloc = internal thread_local global [104 x i8] zeroinitializer, align 16
@.s11417 = private unnamed_addr constant [33 x i8] c"resid_arena_pop: no active arena\00"
@.s11519 = private unnamed_addr constant [37 x i8] c"resid_bulk_pop: no active bulk arena\00"
@rtg.rt_sc_once = internal global [8 x i8] zeroinitializer, align 16
@rtg.rt_sc_key = internal global [8 x i8] zeroinitializer, align 16
@rtg.box_interned = internal global [96 x i8] zeroinitializer, align 16
@.s11902 = private unnamed_addr constant [5 x i8] c"bool\00"
@.s11906 = private unnamed_addr constant [5 x i8] c"bool\00"
@.s11910 = private unnamed_addr constant [4 x i8] c"f64\00"
@.s11978 = private unnamed_addr constant [4 x i8] c"i64\00"
@.s11992 = private unnamed_addr constant [4 x i8] c"f64\00"
@.s12008 = private unnamed_addr constant [5 x i8] c"bool\00"
@.s12017 = private unnamed_addr constant [5 x i8] c"i128\00"
@.s12061 = private unnamed_addr constant [5 x i8] c"u128\00"
@rtg.addr_probe = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s12097 = private unnamed_addr constant [2 x i8] c"x\00"
@.s12105 = private unnamed_addr constant [50 x i8] c"resid: address space above 2^48 is not supported\0A\00"
