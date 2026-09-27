declare ptr @malloc(i64)
declare void @free(ptr)
declare i64 @resid_arena_push()
declare i64 @resid_arena_pop()
declare ptr @resid_list_str_persist_copy(ptr)
declare ptr @resid_list_const_i64(ptr, i64, ptr, ptr)
declare ptr @resid_list_const_ptr(ptr, i64, ptr, ptr)
declare ptr @resid_list_const_bool(ptr, i64, ptr, ptr)
declare <2 x i64> @llvm.x86.aesni.aesenc(<2 x i64>, <2 x i64>)
declare <2 x i64> @llvm.x86.aesni.aesenclast(<2 x i64>, <2 x i64>)
declare ptr @resid_box_i64(i64)
declare ptr @resid_box_f64(double)
declare ptr @resid_box_bool(i8)
declare ptr @resid_box_i128(i128)
declare ptr @resid_box_u128(i128)
declare i64 @resid_unbox_i64(ptr)
declare double @resid_unbox_f64(ptr)
declare i8 @resid_unbox_bool(ptr)
declare i128 @resid_unbox_i128(ptr)
declare i128 @resid_unbox_u128(ptr)
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
declare ptr @resid_gmalloc(i64)
declare void @resid_gfree(ptr)
declare i64 @resid_bulk_push()
declare i64 @resid_bulk_pop()
declare i64 @resid_mem_mark()
declare i64 @resid_mem_since_mark()
declare ptr @resid_decp_persist(ptr)
declare i64 @resid_scope_push()
declare void @resid_scope_pop(i64)
declare ptr @resid_rec_new(i64, i8)
declare ptr @resid_rec_reuse(ptr, i64)
declare void @resid_rec_share(ptr)
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
%t1424 = ptrtoint ptr @rtt.8581 to i64
ret i64 %t1424
}
define internal i64 @case_lower_n() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 1459
}
define internal i64 @case_upper_tab() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1425 = ptrtoint ptr @rtt.11492 to i64
ret i64 %t1425
}
define internal i64 @case_upper_n() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 1450
}
define internal i64 @case_special_tab() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1426 = ptrtoint ptr @rtt.12416 to i64
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
%t2640 = ptrtoint ptr @rtt.17055 to i64
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
%t2824 = ptrtoint ptr @rtt.17569 to i64
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
%t3151 = ptrtoint ptr @rtt.18806 to i64
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
%t3217 = call i64 @xmalloc(i64 64)
%t3218 = call i64 @xmalloc(i64 16)
%t3219 = call i64 @st64(i64 %t3218, i64 %p0)
%t3220 = call i64 @c_pthread_attr_init(i64 %t3217)
%t3221 = icmp ne i64 %t3220, 0
br i1 %t3221, label %L1108, label %L1110
L1108:
%t3222p = inttoptr i64 %p0 to ptr
%t3222 = call i64 %t3222p(i64 0, i64 0)
ret i64 %t3222
L1110:
%t3223 = call i64 @__mruntime_rt_sys_resid__stack_mb()
%t3224 = mul i64 %t3223, 1048576
%t3225 = call i64 @c_pthread_attr_setstacksize(i64 %t3217, i64 %t3224)
%t3226 = call i64 @xmalloc(i64 8)
%t3227 = icmp eq i64 %t3225, 0
br i1 %t3227, label %L1111, label %L1112
L1111:
%t3228 = ptrtoint ptr @main_thread to i64
%t3229 = call i64 @c_pthread_create(i64 %t3226, i64 %t3217, i64 %t3228, i64 %t3218)
br label %L1113
L1112:
br label %L1113
L1113:
%t3230 = phi i64 [ %t3229, %L1111 ], [ 1, %L1112 ]
%t3231 = call i64 @c_pthread_attr_destroy(i64 %t3217)
%t3232 = icmp ne i64 %t3230, 0
br i1 %t3232, label %L1114, label %L1116
L1114:
%t3233p = inttoptr i64 %p0 to ptr
%t3233 = call i64 %t3233p(i64 0, i64 0)
ret i64 %t3233
L1116:
%t3234 = call i64 @xmalloc(i64 8)
%t3235 = call i64 @ld64(i64 %t3226)
%t3236 = call i64 @c_pthread_join(i64 %t3235, i64 %t3234)
%t3237 = tail call i64 @ld64(i64 %t3234)
ret i64 %t3237
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
%t3238p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.numfmt_buf)
%t3238 = ptrtoint ptr %t3238p to i64
%t3239 = call i64 @itoa_into(i64 %t3238, i64 %p0)
%t3240 = call i64 @cstr_from(i64 %t3238, i64 %t3239, i64 0)
ret i64 %t3240
}
define ptr @IntToString(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_int_to_string(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @utoa_into(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3241 = call i64 @udigits(i64 %p1, i64 1)
%t3242 = add i64 %p0, %t3241
%t3243 = sub i64 %t3242, 1
%t3244 = call i64 @uput(i64 %t3243, i64 %p1)
ret i64 %t3241
}
define internal i64 @rt_uint_to_string(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3245p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.numfmt_buf)
%t3245 = ptrtoint ptr %t3245p to i64
%t3246 = call i64 @utoa_into(i64 %t3245, i64 %p0)
%t3247 = call i64 @cstr_from(i64 %t3245, i64 %t3246, i64 0)
ret i64 %t3247
}
define ptr @UIntToString(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_uint_to_string(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_int128_to_string(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3248 = call i64 @__mruntime_rt_numfmt_resid__limbs_i128(i128 %p0)
%t3249 = sext i64 0 to i128
%t3250 = icmp slt i128 %p0, %t3249
%t3251 = call i64 @limbs_to_str(i64 %t3248, i64 2, i1 %t3250)
ret i64 %t3251
}
define ptr @Int128ToString(i128 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_int128_to_string(i128 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_uint128_to_string(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3252 = call i64 @__mruntime_rt_numfmt_resid__limbs_i128(i128 %p0)
%t3253 = call i64 @limbs_to_str(i64 %t3252, i64 2, i1 false)
ret i64 %t3253
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t3269, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t3268, %tco.s0 ]
%t3254 = icmp sge i64 %p1, %p2
br i1 %t3254, label %L1117, label %L1119
L1117:
ret i64 0
L1119:
%t3255 = mul i64 %p1, 8
%t3256 = add i64 %p0, %t3255
%t3257 = call i64 @ld64(i64 %t3256)
%t3258 = xor i64 %t3257, -1
%t3259 = mul i64 %p1, 8
%t3260 = add i64 %p0, %t3259
%t3261 = add i64 %t3258, %p3
%t3262 = call i64 @st64(i64 %t3260, i64 %t3261)
%t3263 = icmp eq i64 %p3, 1
br label %LSL3264
LSL3264:
br i1 %t3263, label %LSR3264, label %LSJ3264
LSR3264:
%t3265 = sub nsw i64 0, 1
%t3266 = icmp eq i64 %t3258, %t3265
br label %LSJ3264
LSJ3264:
%t3267 = phi i1 [ false, %LSL3264 ], [ %t3266, %LSR3264 ]
br i1 %t3267, label %L1120, label %L1121
L1120:
br label %L1122
L1121:
br label %L1122
L1122:
%t3268 = phi i64 [ 1, %L1120 ], [ 0, %L1121 ]
%t3269 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_numfmt_resid__limbs_zero(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3276, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t3271 = icmp sge i64 %p1, %p2
br i1 %t3271, label %L1123, label %L1125
L1123:
ret i1 true
L1125:
%t3272 = mul i64 %p1, 8
%t3273 = add i64 %p0, %t3272
%t3274 = call i64 @ld64(i64 %t3273)
%t3275 = icmp ne i64 %t3274, 0
br i1 %t3275, label %L1126, label %L1128
L1126:
ret i1 false
L1128:
%t3276 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__limbs_div10(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3340, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3351, %tco.s0 ]
%t3278 = icmp slt i64 %p1, 0
br i1 %t3278, label %L1129, label %L1131
L1129:
ret i64 %p2
L1131:
%t3279 = sext i64 %p2 to i128
%t3280 = add i128 %t3279, 0
%t3286 = sext i64 64 to i128
%t3287 = add i128 %t3286, 0
%t3293 = icmp uge i128 %t3287, 128
%t3294 = add i128 %t3287, 0
%t3295 = shl i128 %t3280, %t3294
%t3296 = select i1 %t3293, i128 0, i128 %t3295
%t3297 = mul i64 %p1, 8
%t3298 = add i64 %p0, %t3297
%t3299 = call i64 @ld64(i64 %t3298)
%t3300 = sext i64 %t3299 to i128
%t3301 = add i128 %t3300, 0
%t3307 = add i128 18446744073709551615, 0
%t3308 = add i128 %t3307, 0
%t3314 = and i128 %t3301, %t3308
%t3315 = or i128 %t3296, %t3314
%t3316 = sext i64 10 to i128
%t3317 = add i128 %t3316, 0
%t3323 = icmp eq i128 %t3317, 0
%t3324 = zext i1 %t3323 to i8
call void @resid_div_check(i8 %t3324)
%t3329 = udiv i128 %t3315, %t3317
%t3330 = mul i64 %p1, 8
%t3331 = add i64 %p0, %t3330
%t3332 = add i128 %t3329, 0
%t3333 = trunc i128 %t3332 to i64
%t3339 = call i64 @st64(i64 %t3331, i64 %t3333)
%t3340 = sub nsw i64 %p1, 1
%t3341 = sext i64 10 to i128
%t3342 = add i128 %t3341, 0
%t3348 = mul i128 %t3329, %t3342
%t3349 = sub i128 %t3315, %t3348
%t3350 = add i128 %t3349, 0
%t3351 = trunc i128 %t3350 to i64
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t3365, %tco.s0 ]
%t3358 = sub i64 %p1, 1
%t3359 = call i64 @__mruntime_rt_numfmt_resid__limbs_div10(i64 %p0, i64 %t3358, i64 0)
%t3360 = sub i64 %p2, 1
%t3361 = add i64 48, %t3359
%t3362 = call i64 @st8(i64 %t3360, i64 %t3361)
%t3363 = call i1 @__mruntime_rt_numfmt_resid__limbs_zero(i64 %p0, i64 0, i64 %p1)
br i1 %t3363, label %L1132, label %L1134
L1132:
%t3364 = sub i64 %p2, 1
ret i64 %t3364
L1134:
%t3365 = sub i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @limbs_to_str(i64 %p0, i64 %p1, i1 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br i1 %p2, label %L1135, label %L1136
L1135:
%t3367 = call i64 @__mruntime_rt_numfmt_resid__limbs_negate(i64 %p0, i64 0, i64 %p1, i64 1)
br label %L1137
L1136:
br label %L1137
L1137:
%t3368 = phi i64 [ %t3367, %L1135 ], [ 0, %L1136 ]
%t3369p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.limb_buf)
%t3369 = ptrtoint ptr %t3369p to i64
%t3370 = add i64 %t3369, 204
%t3371 = call i64 @__mruntime_rt_numfmt_resid__limbs_digits(i64 %p0, i64 %p1, i64 %t3370)
br i1 %p2, label %L1138, label %L1139
L1138:
%t3372 = sub i64 %t3371, 1
%t3373 = call i64 @st8(i64 %t3372, i64 45)
%t3374 = add i64 %t3373, %t3371
%t3375 = sub i64 %t3374, 1
br label %L1140
L1139:
br label %L1140
L1140:
%t3376 = phi i64 [ %t3375, %L1138 ], [ %t3371, %L1139 ]
%t3377 = add i64 %t3369, 204
%t3378 = sub i64 %t3377, %t3376
%t3379 = call i64 @cstr_from(i64 %t3376, i64 %t3378, i64 0)
ret i64 %t3379
}
define internal i64 @__mruntime_rt_numfmt_resid__limbs_i128(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3380p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.limbs)
%t3380 = ptrtoint ptr %t3380p to i64
%t3381 = add i128 %p0, 0
%t3382 = trunc i128 %t3381 to i64
%t3388 = call i64 @st64(i64 %t3380, i64 %t3382)
%t3389 = add i64 %t3380, 8
%t3390 = sext i64 64 to i128
%t3391 = icmp uge i128 %t3390, 128
%t3392 = add i128 %t3390, 0
%t3393 = select i1 %t3391, i128 127, i128 %t3392
%t3394 = ashr i128 %p0, %t3393
%t3395 = add i128 %t3394, 0
%t3396 = trunc i128 %t3395 to i64
%t3402 = call i64 @st64(i64 %t3389, i64 %t3396)
%t3403 = mul nsw i64 %t3402, 0
%t3404 = add nsw i64 %t3403, %t3380
ret i64 %t3404
}
define internal i64 @limbs2(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3405p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.limbs)
%t3405 = ptrtoint ptr %t3405p to i64
%t3406 = add i64 %p0, 24
%t3407 = call i64 @ld64(i64 %t3406)
%t3408 = call i64 @st64(i64 %t3405, i64 %t3407)
%t3409 = add i64 %t3405, 8
%t3410 = add i64 %p0, 32
%t3411 = call i64 @ld64(i64 %t3410)
%t3412 = call i64 @st64(i64 %t3409, i64 %t3411)
%t3413 = mul nsw i64 %t3412, 0
%t3414 = add nsw i64 %t3413, %t3405
ret i64 %t3414
}
define internal i64 @__mruntime_rt_numfmt_resid__limbs4(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3415p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.limbs)
%t3415 = ptrtoint ptr %t3415p to i64
%t3416 = call i64 @st64(i64 %t3415, i64 %p0)
%t3417 = add i64 %t3415, 8
%t3418 = call i64 @st64(i64 %t3417, i64 %p1)
%t3419 = add i64 %t3415, 16
%t3420 = call i64 @st64(i64 %t3419, i64 %p2)
%t3421 = add i64 %t3415, 24
%t3422 = call i64 @st64(i64 %t3421, i64 %p3)
%t3423 = mul nsw i64 %t3422, 0
%t3424 = add nsw i64 %t3423, %t3415
ret i64 %t3424
}
define internal i64 @__mruntime_rt_numfmt_resid__limbs8(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3425 = call i64 @__mruntime_rt_numfmt_resid__limbs4(i64 %p0, i64 %p1, i64 %p2, i64 %p3)
%t3426 = add i64 %t3425, 32
%t3427 = call i64 @st64(i64 %t3426, i64 %p4)
%t3428 = add i64 %t3425, 40
%t3429 = call i64 @st64(i64 %t3428, i64 %p5)
%t3430 = add i64 %t3425, 48
%t3431 = call i64 @st64(i64 %t3430, i64 %p6)
%t3432 = add i64 %t3425, 56
%t3433 = call i64 @st64(i64 %t3432, i64 %p7)
%t3434 = mul nsw i64 %t3433, 0
%t3435 = add nsw i64 %t3434, %t3425
ret i64 %t3435
}
define internal i64 @rt_int256_to_string(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3436 = call i64 @__mruntime_rt_numfmt_resid__limbs4(i64 %p0, i64 %p1, i64 %p2, i64 %p3)
%t3437 = icmp slt i64 %p3, 0
%t3438 = call i64 @limbs_to_str(i64 %t3436, i64 4, i1 %t3437)
ret i64 %t3438
}
define ptr @Int256ToString(i64 %a0, i64 %a1, i64 %a2, i64 %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_int256_to_string(i64 %a0, i64 %a1, i64 %a2, i64 %a3)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_uint256_to_string(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3439 = call i64 @__mruntime_rt_numfmt_resid__limbs4(i64 %p0, i64 %p1, i64 %p2, i64 %p3)
%t3440 = call i64 @limbs_to_str(i64 %t3439, i64 4, i1 false)
ret i64 %t3440
}
define ptr @UInt256ToString(i64 %a0, i64 %a1, i64 %a2, i64 %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_uint256_to_string(i64 %a0, i64 %a1, i64 %a2, i64 %a3)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_int512_to_string(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3441 = call i64 @__mruntime_rt_numfmt_resid__limbs8(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7)
%t3442 = icmp slt i64 %p7, 0
%t3443 = call i64 @limbs_to_str(i64 %t3441, i64 8, i1 %t3442)
ret i64 %t3443
}
define ptr @Int512ToString(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_int512_to_string(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_uint512_to_string(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3444 = call i64 @__mruntime_rt_numfmt_resid__limbs8(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7)
%t3445 = call i64 @limbs_to_str(i64 %t3444, i64 8, i1 false)
ret i64 %t3445
}
define ptr @UInt512ToString(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_uint512_to_string(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_float_to_string(double %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3446p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.ftoa_buf)
%t3446 = ptrtoint ptr %t3446p to i64
%t3448 = ptrtoint ptr @.s3447 to i64
%t3449 = call i64 @c_strfromd(i64 %t3446, i64 64, i64 %t3448, double %p0)
%t3450 = call i64 @cstr_from(i64 %t3446, i64 %t3449, i64 0)
ret i64 %t3450
}
define ptr @FloatToString(double %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_float_to_string(double %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_bool_to_string(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3451 = icmp ne i64 %p0, 0
br i1 %t3451, label %L1141, label %L1142
L1141:
%t3453 = ptrtoint ptr @.s3452 to i64
br label %L1143
L1142:
%t3455 = ptrtoint ptr @.s3454 to i64
br label %L1143
L1143:
%t3456 = phi i64 [ %t3453, %L1141 ], [ %t3455, %L1142 ]
%t3457 = tail call i64 @cstr_dup(i64 %t3456)
ret i64 %t3457
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
%t3458p = inttoptr i64 %p0 to ptr
%t3458q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t3458p, i8 %t3458q, i64 2080, i1 false)
%t3458 = add i64 0, 0
ret i64 %t3458
}
define internal i1 @__mruntime_rt_numfmt_resid__f128_is_zero(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3459 = call i1 @__mruntime_rt_numfmt_resid__limbs_zero(i64 %p0, i64 0, i64 260)
ret i1 %t3459
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_load(i64 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3460 = call i64 @__mruntime_rt_numfmt_resid__f128_zero(i64 %p0)
%t3461 = add i128 %p1, 0
%t3462 = trunc i128 %t3461 to i64
%t3468 = call i64 @st64(i64 %p0, i64 %t3462)
%t3469 = add i64 %p0, 8
%t3470 = sext i64 64 to i128
%t3471 = add i128 %t3470, 0
%t3477 = icmp uge i128 %t3471, 128
%t3478 = add i128 %t3471, 0
%t3479 = lshr i128 %p1, %t3478
%t3480 = select i1 %t3477, i128 0, i128 %t3479
%t3481 = add i128 %t3480, 0
%t3482 = trunc i128 %t3481 to i64
%t3488 = call i64 @st64(i64 %t3469, i64 %t3482)
ret i64 %t3488
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_shl(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3489 = sdiv i64 %p1, 64
%t3490 = srem i64 %p1, 64
%t3491 = call i64 @__mruntime_rt_numfmt_resid__shl_words(i64 %p0, i64 259, i64 %t3489, i64 %t3490)
%t3492 = mul nsw i64 %t3489, 8
%t3493p = inttoptr i64 %p0 to ptr
%t3493q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t3493p, i8 %t3493q, i64 %t3492, i1 false)
%t3493 = add i64 0, 0
ret i64 %t3493
}
define internal i64 @__mruntime_rt_numfmt_resid__shl_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3523, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t3494 = icmp slt i64 %p1, %p2
br i1 %t3494, label %L1144, label %L1146
L1144:
ret i64 0
L1146:
%t3495 = sub i64 %p1, %p2
%t3496 = mul i64 %t3495, 8
%t3497 = add i64 %p0, %t3496
%t3498 = call i64 @ld64(i64 %t3497)
%t3499 = icmp ne i64 %p3, 0
br label %LSL3500
LSL3500:
br i1 %t3499, label %LSR3500, label %LSJ3500
LSR3500:
%t3501 = sub i64 %p1, %p2
%t3502 = sub i64 %t3501, 1
%t3503 = icmp sge i64 %t3502, 0
br label %LSJ3500
LSJ3500:
%t3504 = phi i1 [ false, %LSL3500 ], [ %t3503, %LSR3500 ]
br i1 %t3504, label %L1147, label %L1148
L1147:
%t3505 = sub i64 %p1, %p2
%t3506 = sub i64 %t3505, 1
%t3507 = mul i64 %t3506, 8
%t3508 = add i64 %p0, %t3507
%t3509 = call i64 @ld64(i64 %t3508)
%t3510 = sub i64 64, %p3
%t3511 = call i64 @lshr(i64 %t3509, i64 %t3510)
br label %L1149
L1148:
br label %L1149
L1149:
%t3512 = phi i64 [ %t3511, %L1147 ], [ 0, %L1148 ]
%t3513 = mul i64 %p1, 8
%t3514 = add i64 %p0, %t3513
%t3515 = icmp eq i64 %p3, 0
br i1 %t3515, label %L1150, label %L1151
L1150:
br label %L1152
L1151:
%t3516 = icmp uge i64 %p3, 64
%t3517 = add i64 %p3, 0
%t3518 = shl i64 %t3498, %t3517
%t3519 = select i1 %t3516, i64 0, i64 %t3518
%t3520 = or i64 %t3519, %t3512
br label %L1152
L1152:
%t3521 = phi i64 [ %t3498, %L1150 ], [ %t3520, %L1151 ]
%t3522 = call i64 @st64(i64 %t3514, i64 %t3521)
%t3523 = sub i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_shr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3525 = sdiv i64 %p1, 64
%t3526 = srem i64 %p1, 64
%t3527 = call i64 @__mruntime_rt_numfmt_resid__shr_words(i64 %p0, i64 0, i64 %t3525, i64 %t3526)
%t3528 = sub nsw i64 260, %t3525
%t3529 = icmp slt i64 %t3528, 0
br i1 %t3529, label %L1153, label %L1154
L1153:
br label %L1155
L1154:
%t3530 = sub nsw i64 260, %t3525
br label %L1155
L1155:
%t3531 = phi i64 [ 0, %L1153 ], [ %t3530, %L1154 ]
%t3532 = mul i64 %t3531, 8
%t3533 = add i64 %p0, %t3532
%t3534 = sub i64 260, %t3531
%t3535 = mul i64 %t3534, 8
%t3536p = inttoptr i64 %t3533 to ptr
%t3536q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t3536p, i8 %t3536q, i64 %t3535, i1 false)
%t3536 = add i64 0, 0
ret i64 %t3536
}
define internal i64 @__mruntime_rt_numfmt_resid__shr_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3567, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t3537 = add i64 %p1, %p2
%t3538 = icmp sge i64 %t3537, 260
br i1 %t3538, label %L1156, label %L1158
L1156:
ret i64 0
L1158:
%t3539 = add i64 %p1, %p2
%t3540 = mul i64 %t3539, 8
%t3541 = add i64 %p0, %t3540
%t3542 = call i64 @ld64(i64 %t3541)
%t3543 = icmp ne i64 %p3, 0
br label %LSL3544
LSL3544:
br i1 %t3543, label %LSR3544, label %LSJ3544
LSR3544:
%t3545 = add i64 %p1, %p2
%t3546 = add i64 %t3545, 1
%t3547 = icmp slt i64 %t3546, 260
br label %LSJ3544
LSJ3544:
%t3548 = phi i1 [ false, %LSL3544 ], [ %t3547, %LSR3544 ]
br i1 %t3548, label %L1159, label %L1160
L1159:
%t3549 = add i64 %p1, %p2
%t3550 = add i64 %t3549, 1
%t3551 = mul i64 %t3550, 8
%t3552 = add i64 %p0, %t3551
%t3553 = call i64 @ld64(i64 %t3552)
%t3554 = sub i64 64, %p3
%t3555 = icmp uge i64 %t3554, 64
%t3556 = add i64 %t3554, 0
%t3557 = shl i64 %t3553, %t3556
%t3558 = select i1 %t3555, i64 0, i64 %t3557
br label %L1161
L1160:
br label %L1161
L1161:
%t3559 = phi i64 [ %t3558, %L1159 ], [ 0, %L1160 ]
%t3560 = mul i64 %p1, 8
%t3561 = add i64 %p0, %t3560
%t3562 = icmp eq i64 %p3, 0
br i1 %t3562, label %L1162, label %L1163
L1162:
br label %L1164
L1163:
%t3563 = call i64 @lshr(i64 %t3542, i64 %p3)
%t3564 = or i64 %t3563, %t3559
br label %L1164
L1164:
%t3565 = phi i64 [ %t3542, %L1162 ], [ %t3564, %L1163 ]
%t3566 = call i64 @st64(i64 %t3561, i64 %t3565)
%t3567 = add i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_mul10(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3614, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3627, %tco.s0 ]
%t3569 = icmp sge i64 %p1, 260
br i1 %t3569, label %L1165, label %L1167
L1165:
ret i64 0
L1167:
%t3570 = mul i64 %p1, 8
%t3571 = add i64 %p0, %t3570
%t3572 = call i64 @ld64(i64 %t3571)
%t3573 = sext i64 %t3572 to i128
%t3574 = add i128 %t3573, 0
%t3580 = add i128 18446744073709551615, 0
%t3581 = add i128 %t3580, 0
%t3587 = and i128 %t3574, %t3581
%t3588 = sext i64 10 to i128
%t3589 = add i128 %t3588, 0
%t3595 = mul i128 %t3587, %t3589
%t3596 = sext i64 %p2 to i128
%t3597 = add i128 %t3596, 0
%t3603 = add i128 %t3595, %t3597
%t3604 = mul i64 %p1, 8
%t3605 = add i64 %p0, %t3604
%t3606 = add i128 %t3603, 0
%t3607 = trunc i128 %t3606 to i64
%t3613 = call i64 @st64(i64 %t3605, i64 %t3607)
%t3614 = add nsw i64 %p1, 1
%t3615 = sext i64 64 to i128
%t3616 = add i128 %t3615, 0
%t3622 = icmp uge i128 %t3616, 128
%t3623 = add i128 %t3616, 0
%t3624 = lshr i128 %t3603, %t3623
%t3625 = select i1 %t3622, i128 0, i128 %t3624
%t3626 = add i128 %t3625, 0
%t3627 = trunc i128 %t3626 to i64
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_div10(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3634 = call i64 @__mruntime_rt_numfmt_resid__limbs_div10(i64 %p0, i64 259, i64 0)
ret i64 %t3634
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_mask(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3635 = sdiv i64 %p1, 64
%t3636 = srem i64 %p1, 64
%t3637 = add nsw i64 %t3635, 1
%t3638 = icmp slt i64 %t3637, 260
br i1 %t3638, label %L1168, label %L1169
L1168:
%t3639 = add nsw i64 %t3635, 1
%t3640 = mul nsw i64 %t3639, 8
%t3641 = add i64 %p0, %t3640
%t3642 = sub nsw i64 259, %t3635
%t3643 = mul nsw i64 %t3642, 8
%t3644p = inttoptr i64 %t3641 to ptr
%t3644q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t3644p, i8 %t3644q, i64 %t3643, i1 false)
%t3644 = add i64 0, 0
br label %L1170
L1169:
br label %L1170
L1170:
%t3645 = phi i64 [ %t3644, %L1168 ], [ 0, %L1169 ]
%t3646 = icmp ne i64 %t3636, 0
br label %LSL3647
LSL3647:
br i1 %t3646, label %LSR3647, label %LSJ3647
LSR3647:
%t3648 = icmp slt i64 %t3635, 260
br label %LSJ3647
LSJ3647:
%t3649 = phi i1 [ false, %LSL3647 ], [ %t3648, %LSR3647 ]
br i1 %t3649, label %L1171, label %L1172
L1171:
%t3650 = mul nsw i64 %t3635, 8
%t3651 = add i64 %p0, %t3650
%t3652 = mul nsw i64 %t3635, 8
%t3653 = add i64 %p0, %t3652
%t3654 = call i64 @ld64(i64 %t3653)
%t3655 = icmp uge i64 %t3636, 64
%t3656 = add i64 %t3636, 0
%t3657 = shl i64 1, %t3656
%t3658 = select i1 %t3655, i64 0, i64 %t3657
%t3659 = sub i64 %t3658, 1
%t3660 = and i64 %t3654, %t3659
%t3661 = call i64 @st64(i64 %t3651, i64 %t3660)
br label %L1173
L1172:
br label %L1173
L1173:
%t3662 = phi i64 [ %t3661, %L1171 ], [ 0, %L1172 ]
ret i64 %t3662
}
define internal i64 @__mruntime_rt_numfmt_resid__int_digits(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3671, %tco.s0 ]
%t3663 = call i1 @__mruntime_rt_numfmt_resid__f128_is_zero(i64 %p0)
br label %LSL3664
LSL3664:
br i1 %t3663, label %LSJ3664, label %LSR3664
LSR3664:
%t3665 = icmp sge i64 %p2, 5000
br label %LSJ3664
LSJ3664:
%t3666 = phi i1 [ true, %LSL3664 ], [ %t3665, %LSR3664 ]
br i1 %t3666, label %L1174, label %L1176
L1174:
ret i64 %p2
L1176:
%t3667 = add i64 %p1, %p2
%t3668 = call i64 @__mruntime_rt_numfmt_resid__f128_div10(i64 %p0)
%t3669 = add i64 48, %t3668
%t3670 = call i64 @st8(i64 %t3667, i64 %t3669)
%t3671 = add nsw i64 %p2, 1
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
%p3 = phi i64 [ %p3.in, %entry ], [ 0, %tco.s0 ], [ %t3714, %tco.s1 ]
%p4 = phi i1 [ %p4.in, %entry ], [ %p4, %tco.s0 ], [ %p4, %tco.s1 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ], [ %p5, %tco.s1 ]
%t3673 = icmp sge i64 %p3, 44
br label %LSL3674
LSL3674:
br i1 %t3673, label %LSJ3674, label %LSR3674
LSR3674:
%t3675 = call i1 @__mruntime_rt_numfmt_resid__f128_is_zero(i64 %p0)
br label %LSJ3674
LSJ3674:
%t3676 = phi i1 [ true, %LSL3674 ], [ %t3675, %LSR3674 ]
br i1 %t3676, label %L1177, label %L1179
L1177:
ret i64 %p3
L1179:
%t3677 = call i64 @__mruntime_rt_numfmt_resid__f128_mul10(i64 %p0, i64 0, i64 0)
%t3678 = sdiv i64 %p1, 64
%t3679 = srem i64 %p1, 64
%t3680 = icmp eq i64 %t3679, 0
br i1 %t3680, label %L1180, label %L1181
L1180:
%t3681 = mul nsw i64 %t3678, 8
%t3682 = add i64 %p0, %t3681
%t3683 = call i64 @ld64(i64 %t3682)
br label %L1182
L1181:
%t3684 = mul nsw i64 %t3678, 8
%t3685 = add i64 %p0, %t3684
%t3686 = call i64 @ld64(i64 %t3685)
%t3687 = call i64 @lshr(i64 %t3686, i64 %t3679)
%t3688 = add nsw i64 %t3678, 1
%t3689 = mul nsw i64 %t3688, 8
%t3690 = add i64 %p0, %t3689
%t3691 = call i64 @ld64(i64 %t3690)
%t3692 = sub nsw i64 64, %t3679
%t3693 = icmp uge i64 %t3692, 64
%t3694 = add i64 %t3692, 0
%t3695 = shl i64 %t3691, %t3694
%t3696 = select i1 %t3693, i64 0, i64 %t3695
%t3697 = or i64 %t3687, %t3696
br label %L1182
L1182:
%t3698 = phi i64 [ %t3683, %L1180 ], [ %t3697, %L1181 ]
%t3699 = and i64 %t3698, 15
%t3700 = call i64 @__mruntime_rt_numfmt_resid__f128_mask(i64 %p0, i64 %p1)
br label %LSL3701
LSL3701:
br i1 %p4, label %LSR3701, label %LSJ3701
LSR3701:
%t3702 = icmp eq i64 %p3, 0
br label %LSJ3701
LSJ3701:
%t3703 = phi i1 [ false, %LSL3701 ], [ %t3702, %LSR3701 ]
br label %LSL3704
LSL3704:
br i1 %t3703, label %LSR3704, label %LSJ3704
LSR3704:
%t3705 = icmp eq i64 %t3699, 0
br label %LSJ3704
LSJ3704:
%t3706 = phi i1 [ false, %LSL3704 ], [ %t3705, %LSR3704 ]
br i1 %t3706, label %L1183, label %L1185
L1183:
%t3707 = call i64 @ld64(i64 %p5)
%t3708 = add i64 %t3707, 1
%t3709 = call i64 @st64(i64 %p5, i64 %t3708)
br label %tco.s0
tco.s0:
br label %tco.head
L1185:
%t3711 = add i64 %p2, %p3
%t3712 = add nsw i64 48, %t3699
%t3713 = call i64 @st8(i64 %t3711, i64 %t3712)
%t3714 = add nsw i64 %p3, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @rt_float128_to_string(fp128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3716 = bitcast fp128 %p0 to i128
%t3717 = add i128 %t3716, 0
%t3718 = add i128 %t3717, 0
%t3724 = sext i64 127 to i128
%t3725 = add i128 %t3724, 0
%t3731 = icmp uge i128 %t3725, 128
%t3732 = add i128 %t3725, 0
%t3733 = lshr i128 %t3718, %t3732
%t3734 = select i1 %t3731, i128 0, i128 %t3733
%t3735 = sext i64 0 to i128
%t3736 = add i128 %t3735, 0
%t3742 = icmp ne i128 %t3734, %t3736
%t3743 = sext i64 112 to i128
%t3744 = add i128 %t3743, 0
%t3750 = icmp uge i128 %t3744, 128
%t3751 = add i128 %t3744, 0
%t3752 = lshr i128 %t3718, %t3751
%t3753 = select i1 %t3750, i128 0, i128 %t3752
%t3754 = sext i64 32767 to i128
%t3755 = add i128 %t3754, 0
%t3761 = and i128 %t3753, %t3755
%t3762 = add i128 %t3761, 0
%t3763 = trunc i128 %t3762 to i64
%t3769 = sext i64 1 to i128
%t3770 = add i128 %t3769, 0
%t3776 = sext i64 112 to i128
%t3777 = add i128 %t3776, 0
%t3783 = icmp uge i128 %t3777, 128
%t3784 = add i128 %t3777, 0
%t3785 = shl i128 %t3770, %t3784
%t3786 = select i1 %t3783, i128 0, i128 %t3785
%t3787 = sext i64 1 to i128
%t3788 = add i128 %t3787, 0
%t3794 = sub i128 %t3786, %t3788
%t3795 = and i128 %t3718, %t3794
%t3796 = icmp eq i64 %t3763, 32767
br i1 %t3796, label %L1186, label %L1188
L1186:
%t3797 = sext i64 0 to i128
%t3798 = add i128 %t3797, 0
%t3804 = icmp ne i128 %t3795, %t3798
br i1 %t3804, label %L1189, label %L1190
L1189:
%t3806 = ptrtoint ptr @.s3805 to i64
br label %L1191
L1190:
br i1 %t3742, label %L1192, label %L1193
L1192:
%t3808 = ptrtoint ptr @.s3807 to i64
br label %L1194
L1193:
%t3810 = ptrtoint ptr @.s3809 to i64
br label %L1194
L1194:
%t3811 = phi i64 [ %t3808, %L1192 ], [ %t3810, %L1193 ]
br label %L1191
L1191:
%t3812 = phi i64 [ %t3806, %L1189 ], [ %t3811, %L1194 ]
%t3813 = call i64 @cstr_dup(i64 %t3812)
ret i64 %t3813
L1188:
%t3814 = icmp eq i64 %t3763, 0
br i1 %t3814, label %L1195, label %L1196
L1195:
br label %L1197
L1196:
%t3815 = sext i64 1 to i128
%t3816 = add i128 %t3815, 0
%t3822 = sext i64 112 to i128
%t3823 = add i128 %t3822, 0
%t3829 = icmp uge i128 %t3823, 128
%t3830 = add i128 %t3823, 0
%t3831 = shl i128 %t3816, %t3830
%t3832 = select i1 %t3829, i128 0, i128 %t3831
%t3833 = or i128 %t3832, %t3795
br label %L1197
L1197:
%t3834 = phi i128 [ %t3795, %L1195 ], [ %t3833, %L1196 ]
%t3835 = icmp eq i64 %t3763, 0
br i1 %t3835, label %L1198, label %L1199
L1198:
%t3836 = sub nsw i64 0, 16382
%t3837 = sub nsw i64 %t3836, 112
br label %L1200
L1199:
%t3838 = sub i64 %t3763, 16383
%t3839 = sub i64 %t3838, 112
br label %L1200
L1200:
%t3840 = phi i64 [ %t3837, %L1198 ], [ %t3839, %L1199 ]
%t3841p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_m)
%t3841 = ptrtoint ptr %t3841p to i64
%t3842p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_ip)
%t3842 = ptrtoint ptr %t3842p to i64
%t3843p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_ib)
%t3843 = ptrtoint ptr %t3843p to i64
%t3844p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_fd)
%t3844 = ptrtoint ptr %t3844p to i64
%t3845 = call i64 @__mruntime_rt_numfmt_resid__f128_load(i64 %t3841, i128 %t3834)
%t3846 = call i64 @__mruntime_rt_numfmt_resid__f128_text(i64 %t3841, i64 %t3842, i64 %t3843, i64 %t3844, i128 %t3834, i64 %t3840, i1 %t3742)
ret i64 %t3846
}
define ptr @Float128ToString(fp128 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_float128_to_string(fp128 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_text(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i128 %p4, i64 %p5, i1 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3847 = icmp sge i64 %p5, 0
br i1 %t3847, label %L1201, label %L1203
L1201:
%t3848 = call i64 @__mruntime_rt_numfmt_resid__f128_shl(i64 %p0, i64 %p5)
%t3849 = call i1 @__mruntime_rt_numfmt_resid__f128_is_zero(i64 %p0)
br i1 %t3849, label %L1204, label %L1206
L1204:
%t3851 = ptrtoint ptr @.s3850 to i64
%t3852 = call i64 @cstr_dup(i64 %t3851)
ret i64 %t3852
L1206:
%t3853 = call i64 @__mruntime_rt_numfmt_resid__int_digits(i64 %p0, i64 %p2, i64 0)
%t3854 = sub i64 %t3853, 1
%t3855 = call i64 @__mruntime_rt_numfmt_resid__f128_assemble(i64 %p2, i64 %t3853, i64 %p3, i64 0, i64 %t3854, i1 %p6)
ret i64 %t3855
L1203:
%t3856 = sub i64 0, %p5
%t3857 = call i64 @__mruntime_rt_numfmt_resid__f128_load(i64 %p1, i128 %p4)
%t3858 = call i64 @__mruntime_rt_numfmt_resid__f128_shr(i64 %p1, i64 %t3856)
%t3859 = call i64 @__mruntime_rt_numfmt_resid__int_digits(i64 %p1, i64 %p2, i64 0)
%t3860 = call i64 @__mruntime_rt_numfmt_resid__f128_load(i64 %p0, i128 %p4)
%t3861 = call i64 @__mruntime_rt_numfmt_resid__f128_mask(i64 %p0, i64 %t3856)
%t3862p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_lead)
%t3862 = ptrtoint ptr %t3862p to i64
%t3863 = call i64 @st64(i64 %t3862, i64 0)
%t3864 = icmp eq i64 %t3859, 0
%t3865 = call i64 @__mruntime_rt_numfmt_resid__frac_digits(i64 %p0, i64 %t3856, i64 %p3, i64 0, i1 %t3864, i64 %t3862)
%t3866 = icmp sgt i64 %t3859, 0
br i1 %t3866, label %L1207, label %L1209
L1207:
%t3867 = sub nsw i64 %t3859, 1
%t3868 = call i64 @__mruntime_rt_numfmt_resid__f128_assemble(i64 %p2, i64 %t3859, i64 %p3, i64 %t3865, i64 %t3867, i1 %p6)
ret i64 %t3868
L1209:
%t3869 = icmp eq i64 %t3865, 0
br i1 %t3869, label %L1210, label %L1212
L1210:
br i1 %p6, label %L1213, label %L1214
L1213:
%t3871 = ptrtoint ptr @.s3870 to i64
br label %L1215
L1214:
%t3873 = ptrtoint ptr @.s3872 to i64
br label %L1215
L1215:
%t3874 = phi i64 [ %t3871, %L1213 ], [ %t3873, %L1214 ]
%t3875 = call i64 @cstr_dup(i64 %t3874)
ret i64 %t3875
L1212:
%t3876 = call i64 @ld64(i64 %t3862)
%t3877 = sub i64 0, %t3876
%t3878 = sub nsw i64 %t3877, 1
%t3879 = call i64 @__mruntime_rt_numfmt_resid__f128_assemble(i64 %p2, i64 0, i64 %p3, i64 %t3865, i64 %t3878, i1 %p6)
ret i64 %t3879
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_assemble(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i1 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3880p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_digits)
%t3880 = ptrtoint ptr %t3880p to i64
%t3881 = call i64 @__mruntime_rt_numfmt_resid__copy_rev(i64 %p0, i64 %p1, i64 %t3880, i64 0, i64 37)
%t3882 = call i64 @__mruntime_rt_numfmt_resid__copy_fwd(i64 %p2, i64 %p3, i64 %t3880, i64 %t3881, i64 37, i64 0)
%t3883 = icmp sgt i64 %t3882, 36
br label %LSL3884
LSL3884:
br i1 %t3883, label %LSR3884, label %LSJ3884
LSR3884:
%t3885 = add i64 %t3880, 36
%t3886 = call i64 @ld8(i64 %t3885)
%t3887 = icmp sge i64 %t3886, 53
br label %LSJ3884
LSJ3884:
%t3888 = phi i1 [ false, %LSL3884 ], [ %t3887, %LSR3884 ]
br label %LSL3889
LSL3889:
br i1 %t3888, label %LSR3889, label %LSJ3889
LSR3889:
%t3890 = call i1 @__mruntime_rt_numfmt_resid__round_up(i64 %t3880, i64 35)
br label %LSJ3889
LSJ3889:
%t3891 = phi i1 [ false, %LSL3889 ], [ %t3890, %LSR3889 ]
br i1 %t3891, label %L1216, label %L1217
L1216:
%t3892 = call i64 @st8(i64 %t3880, i64 49)
%t3893 = add i64 %t3880, 1
%t3894p = inttoptr i64 %t3893 to ptr
%t3894q = trunc i64 48 to i8
call void @llvm.memset.p0.i64(ptr %t3894p, i8 %t3894q, i64 35, i1 false)
%t3894 = add i64 0, 0
%t3895 = add i64 %t3892, %t3894
br label %L1218
L1217:
br label %L1218
L1218:
%t3896 = phi i64 [ %t3895, %L1216 ], [ 0, %L1217 ]
br i1 %t3891, label %L1219, label %L1220
L1219:
%t3897 = add i64 %p4, 1
br label %L1221
L1220:
br label %L1221
L1221:
%t3898 = phi i64 [ %t3897, %L1219 ], [ %p4, %L1220 ]
%t3899 = icmp sgt i64 %t3882, 36
br i1 %t3899, label %L1222, label %L1223
L1222:
br label %L1224
L1223:
br label %L1224
L1224:
%t3900 = phi i64 [ 36, %L1222 ], [ %t3882, %L1223 ]
%t3901 = call i64 @__mruntime_rt_numfmt_resid__strip_zeros(i64 %t3880, i64 %t3900)
%t3902p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_out)
%t3902 = ptrtoint ptr %t3902p to i64
br i1 %p5, label %L1225, label %L1226
L1225:
%t3903 = call i64 @st8(i64 %t3902, i64 45)
%t3904 = add i64 %t3903, 1
br label %L1227
L1226:
br label %L1227
L1227:
%t3905 = phi i64 [ %t3904, %L1225 ], [ 0, %L1226 ]
%t3906 = sub nsw i64 0, 6
%t3907 = icmp sge i64 %t3898, %t3906
br label %LSL3908
LSL3908:
br i1 %t3907, label %LSR3908, label %LSJ3908
LSR3908:
%t3909 = icmp sle i64 %t3898, 36
br label %LSJ3908
LSJ3908:
%t3910 = phi i1 [ false, %LSL3908 ], [ %t3909, %LSR3908 ]
br i1 %t3910, label %L1228, label %L1229
L1228:
%t3911 = call i64 @__mruntime_rt_numfmt_resid__fixed_text(i64 %t3902, i64 %t3905, i64 %t3880, i64 %t3901, i64 %t3898)
br label %L1230
L1229:
%t3912 = call i64 @__mruntime_rt_numfmt_resid__sci_text(i64 %t3902, i64 %t3905, i64 %t3880, i64 %t3901, i64 %t3898)
br label %L1230
L1230:
%t3913 = phi i64 [ %t3911, %L1228 ], [ %t3912, %L1229 ]
%t3914 = call i64 @cstr_from(i64 %t3902, i64 %t3913, i64 0)
ret i64 %t3914
}
define internal i64 @__mruntime_rt_numfmt_resid__copy_rev(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t3925, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t3915 = icmp sge i64 %p3, %p1
br label %LSL3916
LSL3916:
br i1 %t3915, label %LSJ3916, label %LSR3916
LSR3916:
%t3917 = icmp sge i64 %p3, %p4
br label %LSJ3916
LSJ3916:
%t3918 = phi i1 [ true, %LSL3916 ], [ %t3917, %LSR3916 ]
br i1 %t3918, label %L1231, label %L1233
L1231:
ret i64 %p3
L1233:
%t3919 = add i64 %p2, %p3
%t3920 = add i64 %p0, %p1
%t3921 = sub i64 %t3920, 1
%t3922 = sub i64 %t3921, %p3
%t3923 = call i64 @ld8(i64 %t3922)
%t3924 = call i64 @st8(i64 %t3919, i64 %t3923)
%t3925 = add nsw i64 %p3, 1
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t3935, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t3936, %tco.s0 ]
%t3927 = icmp sge i64 %p5, %p1
br label %LSL3928
LSL3928:
br i1 %t3927, label %LSJ3928, label %LSR3928
LSR3928:
%t3929 = icmp sge i64 %p3, %p4
br label %LSJ3928
LSJ3928:
%t3930 = phi i1 [ true, %LSL3928 ], [ %t3929, %LSR3928 ]
br i1 %t3930, label %L1234, label %L1236
L1234:
ret i64 %p3
L1236:
%t3931 = add i64 %p2, %p3
%t3932 = add i64 %p0, %p5
%t3933 = call i64 @ld8(i64 %t3932)
%t3934 = call i64 @st8(i64 %t3931, i64 %t3933)
%t3935 = add nsw i64 %p3, 1
%t3936 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_numfmt_resid__round_up(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3944, %tco.s0 ]
%t3938 = icmp slt i64 %p1, 0
br i1 %t3938, label %L1237, label %L1239
L1237:
ret i1 true
L1239:
%t3939 = add i64 %p0, %p1
%t3940 = call i64 @ld8(i64 %t3939)
%t3941 = icmp eq i64 %t3940, 57
br i1 %t3941, label %L1240, label %L1242
L1240:
%t3942 = add i64 %p0, %p1
%t3943 = call i64 @st8(i64 %t3942, i64 48)
%t3944 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L1242:
%t3946 = add i64 %p0, %p1
%t3947 = add i64 %p0, %p1
%t3948 = call i64 @ld8(i64 %t3947)
%t3949 = add i64 %t3948, 1
%t3950 = call i64 @st8(i64 %t3946, i64 %t3949)
ret i1 false
}
define internal i64 @__mruntime_rt_numfmt_resid__strip_zeros(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3958, %tco.s0 ]
%t3951 = icmp sgt i64 %p1, 1
br label %LSL3952
LSL3952:
br i1 %t3951, label %LSR3952, label %LSJ3952
LSR3952:
%t3953 = add i64 %p0, %p1
%t3954 = sub nsw i64 %t3953, 1
%t3955 = call i64 @ld8(i64 %t3954)
%t3956 = icmp eq i64 %t3955, 48
br label %LSJ3952
LSJ3952:
%t3957 = phi i1 [ false, %LSL3952 ], [ %t3956, %LSR3952 ]
br i1 %t3957, label %L1243, label %L1245
L1243:
%t3958 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L1245:
ret i64 %p1
}
define internal i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3960 = add i64 %p0, %p1
%t3961 = call i64 @st8(i64 %t3960, i64 %p2)
%t3962 = add i64 %t3961, %p1
%t3963 = add i64 %t3962, 1
ret i64 %t3963
}
define internal i64 @__mruntime_rt_numfmt_resid__fixed_text(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3964 = icmp slt i64 %p4, 0
br i1 %t3964, label %L1246, label %L1248
L1246:
%t3965 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 48)
%t3966 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t3965, i64 46)
%t3967 = sub i64 0, %p4
%t3968 = sub nsw i64 %t3967, 1
%t3969 = call i64 @__mruntime_rt_numfmt_resid__zeros(i64 %p0, i64 %t3966, i64 %t3968)
%t3970 = tail call i64 @__mruntime_rt_numfmt_resid__digits_out(i64 %p0, i64 %t3969, i64 %p2, i64 0, i64 %p3)
ret i64 %t3970
L1248:
%t3971 = call i64 @__mruntime_rt_numfmt_resid__int_part(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 %p4)
%t3972 = add i64 %p4, 1
%t3973 = icmp slt i64 %t3972, %p3
br i1 %t3973, label %L1249, label %L1251
L1249:
%t3974 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t3971, i64 46)
%t3975 = add i64 %p4, 1
%t3976 = tail call i64 @__mruntime_rt_numfmt_resid__digits_out(i64 %p0, i64 %t3974, i64 %p2, i64 %t3975, i64 %p3)
ret i64 %t3976
L1251:
ret i64 %t3971
}
define internal i64 @__mruntime_rt_numfmt_resid__zeros(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3978, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3979, %tco.s0 ]
%t3977 = icmp sle i64 %p2, 0
br i1 %t3977, label %L1252, label %L1254
L1252:
ret i64 %p1
L1254:
%t3978 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 48)
%t3979 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__digits_out(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3984, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t3985, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t3981 = icmp sge i64 %p3, %p4
br i1 %t3981, label %L1255, label %L1257
L1255:
ret i64 %p1
L1257:
%t3982 = add i64 %p2, %p3
%t3983 = call i64 @ld8(i64 %t3982)
%t3984 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 %t3983)
%t3985 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__int_part(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3992, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t3993, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t3987 = icmp sgt i64 %p4, %p5
br i1 %t3987, label %L1258, label %L1260
L1258:
ret i64 %p1
L1260:
%t3988 = icmp slt i64 %p4, %p3
br i1 %t3988, label %L1261, label %L1262
L1261:
%t3989 = add i64 %p2, %p4
%t3990 = call i64 @ld8(i64 %t3989)
br label %L1263
L1262:
br label %L1263
L1263:
%t3991 = phi i64 [ %t3990, %L1261 ], [ 48, %L1262 ]
%t3992 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 %t3991)
%t3993 = add i64 %p4, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__sci_text(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3995 = call i64 @ld8(i64 %p2)
%t3996 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 %t3995)
%t3997 = icmp sgt i64 %p3, 1
br i1 %t3997, label %L1264, label %L1265
L1264:
%t3998 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t3996, i64 46)
%t3999 = call i64 @__mruntime_rt_numfmt_resid__digits_out(i64 %p0, i64 %t3998, i64 %p2, i64 1, i64 %p3)
br label %L1266
L1265:
br label %L1266
L1266:
%t4000 = phi i64 [ %t3999, %L1264 ], [ %t3996, %L1265 ]
%t4001 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t4000, i64 69)
%t4002 = icmp sge i64 %p4, 0
br i1 %t4002, label %L1267, label %L1268
L1267:
br label %L1269
L1268:
br label %L1269
L1269:
%t4003 = phi i64 [ 43, %L1267 ], [ 45, %L1268 ]
%t4004 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t4001, i64 %t4003)
%t4005 = icmp sge i64 %p4, 0
br i1 %t4005, label %L1270, label %L1271
L1270:
br label %L1272
L1271:
%t4006 = sub i64 0, %p4
br label %L1272
L1272:
%t4007 = phi i64 [ %p4, %L1270 ], [ %t4006, %L1271 ]
%t4008 = icmp slt i64 %t4007, 10
br i1 %t4008, label %L1273, label %L1274
L1273:
%t4009 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t4004, i64 48)
br label %L1275
L1274:
br label %L1275
L1275:
%t4010 = phi i64 [ %t4009, %L1273 ], [ %t4004, %L1274 ]
%t4011 = add i64 %p0, %t4010
%t4012 = call i64 @itoa_into(i64 %t4011, i64 %t4007)
%t4013 = add i64 %t4010, %t4012
ret i64 %t4013
}
define internal i1 @box_imm(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4014 = sub i64 %p0, 281474976710656
%t4015 = call i1 @ult(i64 %t4014, i64 36028797018963968)
ret i1 %t4015
}
define internal i1 @box_fimm(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4016 = call i1 @ult(i64 %p0, i64 72057594037927936)
%t4017 = xor i1 %t4016, true
ret i1 %t4017
}
define internal i64 @imm_val(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4018 = sub i64 %p0, 18295873486192640
ret i64 %t4018
}
define internal i64 @sx32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4019 = shl i64 %p0, 32
%t4020 = ashr i64 %t4019, 32
ret i64 %t4020
}
define internal i64 @box_tag(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4021 = call i64 @ld32(i64 %p0)
%t4022 = tail call i64 @sx32(i64 %t4021)
ret i64 %t4022
}
define internal i64 @box_count(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4023 = add i64 %p0, 4
%t4024 = call i64 @ld32(i64 %t4023)
%t4025 = tail call i64 @sx32(i64 %t4024)
ret i64 %t4025
}
define internal i64 @box_type(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4026 = add i64 %p0, 8
%t4027 = tail call i64 @ld64(i64 %t4026)
ret i64 %t4027
}
define internal i64 @box_slot(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4028 = add i64 %p0, 16
%t4029 = mul i64 %p1, 8
%t4030 = add i64 %t4028, %t4029
%t4031 = call i64 @ld64(i64 %t4030)
ret i64 %t4031
}
define internal i64 @unbox_word(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4032 = call i1 @box_imm(i64 %p0)
br i1 %t4032, label %L1276, label %L1277
L1276:
%t4033 = call i64 @imm_val(i64 %p0)
br label %L1278
L1277:
%t4034 = add i64 %p0, 24
%t4035 = call i64 @ld64(i64 %t4034)
br label %L1278
L1278:
%t4036 = phi i64 [ %t4033, %L1276 ], [ %t4035, %L1277 ]
ret i64 %t4036
}
define internal double @unbox_float(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4037 = call i1 @box_fimm(i64 %p0)
br i1 %t4037, label %L1279, label %L1280
L1279:
br label %L1281
L1280:
%t4038 = add i64 %p0, 24
%t4039 = call i64 @ld64(i64 %t4038)
br label %L1281
L1281:
%t4040 = phi i64 [ %p0, %L1279 ], [ %t4039, %L1280 ]
%t4041 = bitcast i64 %t4040 to double
ret double %t4041
}
define internal i64 @__mruntime_rt_show_resid__scalar_kind(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4042 = call i1 @box_imm(i64 %p0)
br i1 %t4042, label %L1282, label %L1284
L1282:
ret i64 105
L1284:
%t4043 = call i1 @box_fimm(i64 %p0)
br i1 %t4043, label %L1285, label %L1287
L1285:
ret i64 102
L1287:
%t4044 = call i64 @box_tag(i64 %p0)
%t4045 = sub nsw i64 0, 1
%t4046 = icmp ne i64 %t4044, %t4045
br label %LSL4047
LSL4047:
br i1 %t4046, label %LSJ4047, label %LSR4047
LSR4047:
%t4048 = call i64 @box_type(i64 %p0)
%t4049 = icmp eq i64 %t4048, 0
br label %LSJ4047
LSJ4047:
%t4050 = phi i1 [ true, %LSL4047 ], [ %t4049, %LSR4047 ]
br i1 %t4050, label %L1288, label %L1290
L1288:
ret i64 0
L1290:
%t4051 = call i64 @box_type(i64 %p0)
%t4052 = tail call i64 @ld8(i64 %t4051)
ret i64 %t4052
}
define internal i64 @sb_lit(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4053 = call i64 @c_strlen(i64 %p1)
%t4054 = call i64 @sb_bytes(i64 %p0, i64 %p1, i64 %t4053)
ret i64 %t4054
}
define internal i64 @sb_word(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4055p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.show_buf)
%t4055 = ptrtoint ptr %t4055p to i64
%t4056 = call i64 @itoa_into(i64 %t4055, i64 %p1)
%t4057 = call i64 @sb_bytes(i64 %p0, i64 %t4055, i64 %t4056)
ret i64 %t4057
}
define internal i64 @sb_float(i64 %p0, double %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4058p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.show_buf)
%t4058 = ptrtoint ptr %t4058p to i64
%t4060 = ptrtoint ptr @.s4059 to i64
%t4061 = call i64 @c_strfromd(i64 %t4058, i64 64, i64 %t4060, double %p1)
%t4062 = call i64 @sb_bytes(i64 %p0, i64 %t4058, i64 %t4061)
ret i64 %t4062
}
define internal i64 @__mruntime_rt_show_resid__sb_scalar(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4063 = icmp eq i64 %p2, 102
br i1 %t4063, label %L1291, label %L1293
L1291:
%t4064 = call double @unbox_float(i64 %p1)
%t4065 = call i64 @sb_float(i64 %p0, double %t4064)
ret i64 %t4065
L1293:
%t4066 = icmp eq i64 %p2, 98
br i1 %t4066, label %L1294, label %L1296
L1294:
%t4067 = add i64 %p1, 24
%t4068 = call i64 @ld8(i64 %t4067)
%t4069 = icmp ne i64 %t4068, 0
br i1 %t4069, label %L1297, label %L1298
L1297:
%t4071 = ptrtoint ptr @.s4070 to i64
br label %L1299
L1298:
%t4073 = ptrtoint ptr @.s4072 to i64
br label %L1299
L1299:
%t4074 = phi i64 [ %t4071, %L1297 ], [ %t4073, %L1298 ]
%t4075 = call i64 @sb_lit(i64 %p0, i64 %t4074)
ret i64 %t4075
L1296:
%t4076 = call i64 @unbox_word(i64 %p1)
%t4077 = call i64 @sb_word(i64 %p0, i64 %t4076)
ret i64 %t4077
}
define internal i64 @__mruntime_rt_show_resid__sb_elem(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4078 = icmp eq i64 %p1, 0
br i1 %t4078, label %L1300, label %L1302
L1300:
%t4080 = ptrtoint ptr @.s4079 to i64
%t4081 = tail call i64 @sb_lit(i64 %p0, i64 %t4080)
ret i64 %t4081
L1302:
%t4082 = call i64 @__mruntime_rt_show_resid__scalar_kind(i64 %p1)
%t4083 = icmp eq i64 %t4082, 0
br i1 %t4083, label %L1303, label %L1305
L1303:
%t4085 = ptrtoint ptr @.s4084 to i64
%t4086 = tail call i64 @sb_lit(i64 %p0, i64 %t4085)
ret i64 %t4086
L1305:
%t4087 = call i64 @__mruntime_rt_show_resid__sb_scalar(i64 %p0, i64 %p1, i64 %t4082)
ret i64 %t4087
}
define internal i64 @__mruntime_rt_show_resid__sb_slots(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4096, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t4088 = icmp sge i64 %p2, %p3
br i1 %t4088, label %L1306, label %L1308
L1306:
ret i64 0
L1308:
%t4089 = icmp sgt i64 %p2, 0
br i1 %t4089, label %L1309, label %L1310
L1309:
%t4091 = ptrtoint ptr @.s4090 to i64
%t4092 = call i64 @sb_lit(i64 %p0, i64 %t4091)
br label %L1311
L1310:
br label %L1311
L1311:
%t4093 = phi i64 [ %t4092, %L1309 ], [ 0, %L1310 ]
%t4094 = call i64 @box_slot(i64 %p1, i64 %p2)
%t4095 = call i64 @__mruntime_rt_show_resid__sb_elem(i64 %p0, i64 %t4094)
%t4096 = add nsw i64 %p2, 1
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4106, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t4098 = icmp sge i64 %p2, %p3
br i1 %t4098, label %L1312, label %L1314
L1312:
ret i64 0
L1314:
%t4099 = icmp sgt i64 %p2, 0
br i1 %t4099, label %L1315, label %L1316
L1315:
%t4101 = ptrtoint ptr @.s4100 to i64
%t4102 = call i64 @sb_lit(i64 %p0, i64 %t4101)
br label %L1317
L1316:
br label %L1317
L1317:
%t4103 = phi i64 [ %t4102, %L1315 ], [ 0, %L1316 ]
%t4104 = call i64 @c_list_get(i64 %p1, i64 %p2)
%t4105 = call i64 @__mruntime_rt_show_resid__sb_elem(i64 %p0, i64 %t4104)
%t4106 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_to_string(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4108 = call i1 @box_imm(i64 %p0)
br i1 %t4108, label %L1318, label %L1320
L1318:
%t4109 = call i64 @imm_val(i64 %p0)
%t4110 = tail call i64 @rt_int_to_string(i64 %t4109)
ret i64 %t4110
L1320:
%t4111 = call i1 @box_fimm(i64 %p0)
br i1 %t4111, label %L1321, label %L1323
L1321:
%t4112 = call double @unbox_float(i64 %p0)
%t4113 = call i64 @rt_float_to_string(double %t4112)
ret i64 %t4113
L1323:
%t4114 = icmp eq i64 %p0, 0
br label %LSL4115
LSL4115:
br i1 %t4114, label %LSJ4115, label %LSR4115
LSR4115:
%t4116 = call i64 @box_count(i64 %p0)
%t4117 = icmp sle i64 %t4116, 0
br label %LSJ4115
LSJ4115:
%t4118 = phi i1 [ true, %LSL4115 ], [ %t4117, %LSR4115 ]
br i1 %t4118, label %L1324, label %L1326
L1324:
%t4120 = ptrtoint ptr @.s4119 to i64
%t4121 = tail call i64 @cstr_dup(i64 %t4120)
ret i64 %t4121
L1326:
%t4122 = call i64 @box_tag(i64 %p0)
%t4123 = call i64 @box_type(i64 %p0)
%t4124 = sub nsw i64 0, 1
%t4125 = icmp eq i64 %t4122, %t4124
br i1 %t4125, label %L1327, label %L1329
L1327:
%t4126 = icmp ne i64 %t4123, 0
br label %LSL4127
LSL4127:
br i1 %t4126, label %LSR4127, label %LSJ4127
LSR4127:
%t4129 = ptrtoint ptr @.s4128 to i64
%t4130 = call i64 @c_strcmp(i64 %t4123, i64 %t4129)
%t4131 = icmp eq i64 %t4130, 0
br label %LSJ4127
LSJ4127:
%t4132 = phi i1 [ false, %LSL4127 ], [ %t4131, %LSR4127 ]
br i1 %t4132, label %L1330, label %L1332
L1330:
%t4133 = call i64 @limbs2(i64 %p0)
%t4134 = add i64 %p0, 32
%t4135 = call i64 @ld64(i64 %t4134)
%t4136 = icmp slt i64 %t4135, 0
%t4137 = call i64 @limbs_to_str(i64 %t4133, i64 2, i1 %t4136)
ret i64 %t4137
L1332:
%t4138 = icmp ne i64 %t4123, 0
br label %LSL4139
LSL4139:
br i1 %t4138, label %LSR4139, label %LSJ4139
LSR4139:
%t4141 = ptrtoint ptr @.s4140 to i64
%t4142 = call i64 @c_strcmp(i64 %t4123, i64 %t4141)
%t4143 = icmp eq i64 %t4142, 0
br label %LSJ4139
LSJ4139:
%t4144 = phi i1 [ false, %LSL4139 ], [ %t4143, %LSR4139 ]
br i1 %t4144, label %L1333, label %L1335
L1333:
%t4145 = call i64 @limbs2(i64 %p0)
%t4146 = call i64 @limbs_to_str(i64 %t4145, i64 2, i1 false)
ret i64 %t4146
L1335:
%t4147 = icmp eq i64 %t4123, 0
br i1 %t4147, label %L1336, label %L1337
L1336:
br label %L1338
L1337:
%t4148 = call i64 @ld8(i64 %t4123)
br label %L1338
L1338:
%t4149 = phi i64 [ 0, %L1336 ], [ %t4148, %L1337 ]
%t4150 = call i64 @rt_sb_new()
%t4151 = icmp eq i64 %t4149, 102
br label %LSL4152
LSL4152:
br i1 %t4151, label %LSJ4152, label %LSR4152
LSR4152:
%t4153 = icmp eq i64 %t4149, 98
br label %LSJ4152
LSJ4152:
%t4154 = phi i1 [ true, %LSL4152 ], [ %t4153, %LSR4152 ]
br i1 %t4154, label %L1339, label %L1340
L1339:
br label %L1341
L1340:
br label %L1341
L1341:
%t4155 = phi i64 [ %t4149, %L1339 ], [ 105, %L1340 ]
%t4156 = call i64 @__mruntime_rt_show_resid__sb_scalar(i64 %t4150, i64 %p0, i64 %t4155)
%t4157 = tail call i64 @rt_sb_finish(i64 %t4150)
ret i64 %t4157
L1329:
%t4158 = icmp eq i64 %t4122, 1
br label %LSL4159
LSL4159:
br i1 %t4158, label %LSR4159, label %LSJ4159
LSR4159:
%t4160 = call i64 @box_count(i64 %p0)
%t4161 = icmp eq i64 %t4160, 1
br label %LSJ4159
LSJ4159:
%t4162 = phi i1 [ false, %LSL4159 ], [ %t4161, %LSR4159 ]
br label %LSL4163
LSL4163:
br i1 %t4162, label %LSR4163, label %LSJ4163
LSR4163:
%t4164 = call i64 @box_slot(i64 %p0, i64 0)
%t4165 = icmp ne i64 %t4164, 0
br label %LSJ4163
LSJ4163:
%t4166 = phi i1 [ false, %LSL4163 ], [ %t4165, %LSR4163 ]
br i1 %t4166, label %L1342, label %L1344
L1342:
%t4167 = call i64 @box_slot(i64 %p0, i64 0)
%t4168 = call i64 @__mruntime_rt_show_resid__scalar_kind(i64 %t4167)
%t4169 = call i64 @rt_sb_new()
%t4170 = icmp ne i64 %t4168, 0
br i1 %t4170, label %L1345, label %L1346
L1345:
%t4172 = ptrtoint ptr @.s4171 to i64
br label %L1347
L1346:
%t4174 = ptrtoint ptr @.s4173 to i64
br label %L1347
L1347:
%t4175 = phi i64 [ %t4172, %L1345 ], [ %t4174, %L1346 ]
%t4176 = call i64 @sb_lit(i64 %t4169, i64 %t4175)
%t4177 = icmp ne i64 %t4168, 0
br i1 %t4177, label %L1348, label %L1349
L1348:
%t4178 = call i64 @__mruntime_rt_show_resid__sb_scalar(i64 %t4169, i64 %t4167, i64 %t4168)
br label %L1350
L1349:
%t4179 = call i64 @sb_lit(i64 %t4169, i64 %t4123)
br label %L1350
L1350:
%t4180 = phi i64 [ %t4178, %L1348 ], [ %t4179, %L1349 ]
%t4181 = icmp ne i64 %t4168, 0
br i1 %t4181, label %L1351, label %L1352
L1351:
%t4183 = ptrtoint ptr @.s4182 to i64
br label %L1353
L1352:
%t4185 = ptrtoint ptr @.s4184 to i64
br label %L1353
L1353:
%t4186 = phi i64 [ %t4183, %L1351 ], [ %t4185, %L1352 ]
%t4187 = call i64 @sb_lit(i64 %t4169, i64 %t4186)
%t4188 = tail call i64 @rt_sb_finish(i64 %t4169)
ret i64 %t4188
L1344:
%t4189 = icmp eq i64 %t4122, 2
br i1 %t4189, label %L1354, label %L1356
L1354:
%t4191 = ptrtoint ptr @.s4190 to i64
%t4192 = tail call i64 @cstr_dup(i64 %t4191)
ret i64 %t4192
L1356:
%t4193 = call i64 @rt_sb_new()
%t4194 = call i64 @sb_lit(i64 %t4193, i64 %t4123)
%t4196 = ptrtoint ptr @.s4195 to i64
%t4197 = call i64 @sb_lit(i64 %t4193, i64 %t4196)
%t4198 = call i64 @box_count(i64 %p0)
%t4199 = call i64 @__mruntime_rt_show_resid__sb_slots(i64 %t4193, i64 %p0, i64 0, i64 %t4198)
%t4201 = ptrtoint ptr @.s4200 to i64
%t4202 = call i64 @sb_lit(i64 %t4193, i64 %t4201)
%t4203 = tail call i64 @rt_sb_finish(i64 %t4193)
ret i64 %t4203
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
%t4204 = icmp eq i64 %p0, 0
br i1 %t4204, label %L1357, label %L1359
L1357:
%t4206 = ptrtoint ptr @.s4205 to i64
%t4207 = call i64 @cstr_dup(i64 %t4206)
ret i64 %t4207
L1359:
%t4208 = call i64 @rt_sb_new()
%t4209 = add i64 %p0, 24
%t4210 = call i64 @ld64(i64 %t4209)
%t4211 = call i64 @sb_lit(i64 %t4208, i64 %t4210)
%t4213 = ptrtoint ptr @.s4212 to i64
%t4214 = call i64 @sb_lit(i64 %t4208, i64 %t4213)
%t4215 = icmp ne i64 %p1, 0
br i1 %t4215, label %L1360, label %L1361
L1360:
%t4216 = call i64 @ld64(i64 %p0)
%t4217 = call i64 @__mruntime_rt_show_resid__sb_strs(i64 %t4208, i64 %p0, i64 0, i64 %t4216)
br label %L1362
L1361:
%t4218 = call i64 @ld64(i64 %p0)
%t4219 = call i64 @__mruntime_rt_show_resid__sb_items(i64 %t4208, i64 %p0, i64 0, i64 %t4218)
br label %L1362
L1362:
%t4220 = phi i64 [ %t4217, %L1360 ], [ %t4219, %L1361 ]
%t4222 = ptrtoint ptr @.s4221 to i64
%t4223 = call i64 @sb_lit(i64 %t4208, i64 %t4222)
%t4224 = call i64 @rt_sb_finish(i64 %t4208)
ret i64 %t4224
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4233, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t4225 = icmp sge i64 %p2, %p3
br i1 %t4225, label %L1363, label %L1365
L1363:
ret i64 0
L1365:
%t4226 = icmp sgt i64 %p2, 0
br i1 %t4226, label %L1366, label %L1367
L1366:
%t4228 = ptrtoint ptr @.s4227 to i64
%t4229 = call i64 @sb_lit(i64 %p0, i64 %t4228)
br label %L1368
L1367:
br label %L1368
L1368:
%t4230 = phi i64 [ %t4229, %L1366 ], [ 0, %L1367 ]
%t4231 = call i64 @c_list_get(i64 %p1, i64 %p2)
%t4232 = call i64 @sb_lit(i64 %p0, i64 %t4231)
%t4233 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_to_string(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4235 = call i64 @rt_list_show(i64 %p0, i64 0)
ret i64 %t4235
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
%t4236 = icmp eq i64 %p0, 2
br i1 %t4236, label %L1369, label %L1371
L1369:
%t4237 = call i64 @c_strcmp(i64 %p1, i64 %p2)
%t4238 = icmp eq i64 %t4237, 0
ret i1 %t4238
L1371:
%t4239 = icmp eq i64 %p0, 1
br i1 %t4239, label %L1372, label %L1374
L1372:
%t4240 = call double @unbox_float(i64 %p1)
%t4241 = bitcast i64 %p2 to double
%t4242 = fcmp oeq double %t4240, %t4241
ret i1 %t4242
L1374:
%t4243 = call i64 @unbox_word(i64 %p1)
%t4244 = icmp eq i64 %t4243, %p2
ret i1 %t4244
}
define internal i1 @__mruntime_rt_lists_resid__list_has(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t4248, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t4245 = icmp sge i64 %p3, %p4
br i1 %t4245, label %L1375, label %L1377
L1375:
ret i1 false
L1377:
%t4246 = call i64 @c_list_get(i64 %p0, i64 %p3)
%t4247 = call i1 @__mruntime_rt_lists_resid__elem_eq(i64 %p1, i64 %t4246, i64 %p2)
br i1 %t4247, label %L1378, label %L1380
L1378:
ret i1 true
L1380:
%t4248 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_contains_int(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4250 = call i64 @c_list_len(i64 %p0)
%t4251 = call i1 @__mruntime_rt_lists_resid__list_has(i64 %p0, i64 0, i64 %p1, i64 0, i64 %t4250)
br i1 %t4251, label %L1381, label %L1382
L1381:
br label %L1383
L1382:
br label %L1383
L1383:
%t4252 = phi i64 [ 1, %L1381 ], [ 0, %L1382 ]
ret i64 %t4252
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
%t4253 = bitcast double %p1 to i64
%t4254 = call i64 @c_list_len(i64 %p0)
%t4255 = call i1 @__mruntime_rt_lists_resid__list_has(i64 %p0, i64 1, i64 %t4253, i64 0, i64 %t4254)
br i1 %t4255, label %L1384, label %L1385
L1384:
br label %L1386
L1385:
br label %L1386
L1386:
%t4256 = phi i64 [ 1, %L1384 ], [ 0, %L1385 ]
ret i64 %t4256
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
%t4257 = call i64 @c_list_len(i64 %p0)
%t4258 = call i1 @__mruntime_rt_lists_resid__list_has(i64 %p0, i64 2, i64 %p1, i64 0, i64 %t4257)
br i1 %t4258, label %L1387, label %L1388
L1387:
br label %L1389
L1388:
br label %L1389
L1389:
%t4259 = phi i64 [ 1, %L1387 ], [ 0, %L1388 ]
ret i64 %t4259
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
%t4260 = call i64 @c_list_len(i64 %p0)
%t4261 = call i64 @c_list_to_array(i64 %p0)
%t4262 = sub i64 %t4260, 1
%t4263 = call i64 @__mruntime_rt_lists_resid__rev_at(i64 %t4261, i64 0, i64 %t4262)
%t4264 = call i64 @c_list_type(i64 %p0)
%t4265 = call i64 @c_list_new(i64 %t4260, i64 %t4261, i64 %t4264)
%t4266 = call i64 @c_free(i64 %t4261)
%t4267 = mul nsw i64 %t4266, 0
%t4268 = add nsw i64 %t4267, %t4265
ret i64 %t4268
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t4282, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4283, %tco.s0 ]
%t4269 = icmp sge i64 %p1, %p2
br i1 %t4269, label %L1390, label %L1392
L1390:
ret i64 0
L1392:
%t4270 = mul i64 %p1, 8
%t4271 = add i64 %p0, %t4270
%t4272 = call i64 @ld64(i64 %t4271)
%t4273 = mul i64 %p1, 8
%t4274 = add i64 %p0, %t4273
%t4275 = mul i64 %p2, 8
%t4276 = add i64 %p0, %t4275
%t4277 = call i64 @ld64(i64 %t4276)
%t4278 = call i64 @st64(i64 %t4274, i64 %t4277)
%t4279 = mul i64 %p2, 8
%t4280 = add i64 %p0, %t4279
%t4281 = call i64 @st64(i64 %t4280, i64 %t4272)
%t4282 = add nsw i64 %p1, 1
%t4283 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_sum(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4285 = call i64 @c_list_len(i64 %p0)
%t4286 = call i64 @__mruntime_rt_lists_resid__sum_words(i64 %p0, i64 0, i64 %t4285, i64 0)
ret i64 %t4286
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t4288, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t4291, %tco.s0 ]
%t4287 = icmp sge i64 %p1, %p2
br i1 %t4287, label %L1393, label %L1395
L1393:
ret i64 %p3
L1395:
%t4288 = add nsw i64 %p1, 1
%t4289 = call i64 @c_list_get(i64 %p0, i64 %p1)
%t4290 = call i64 @unbox_word(i64 %t4289)
%t4291 = add i64 %p3, %t4290
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal double @rt_list_sumf(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4293 = call i64 @c_list_len(i64 %p0)
%t4294 = call double @__mruntime_rt_lists_resid__sum_floats(i64 %p0, i64 0, i64 %t4293, double 0.0)
ret double %t4294
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t4296, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi double [ %p3.in, %entry ], [ %t4299, %tco.s0 ]
%t4295 = icmp sge i64 %p1, %p2
br i1 %t4295, label %L1396, label %L1398
L1396:
ret double %p3
L1398:
%t4296 = add nsw i64 %p1, 1
%t4297 = call i64 @c_list_get(i64 %p0, i64 %p1)
%t4298 = call double @unbox_float(i64 %t4297)
%t4299 = fadd double %p3, %t4298
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_lists_resid__slot_cmp(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4301 = icmp eq i64 %p0, 3
br i1 %t4301, label %L1399, label %L1401
L1399:
%t4302p = inttoptr i64 %p1 to ptr
%t4302 = call i64 %t4302p(i64 %p2, i64 %p3)
%t4303 = call i64 @sx32(i64 %t4302)
ret i64 %t4303
L1401:
%t4304 = call i64 @ld64(i64 %p2)
%t4305 = call i64 @ld64(i64 %p3)
%t4306 = icmp eq i64 %p0, 2
br i1 %t4306, label %L1402, label %L1404
L1402:
%t4307 = call i64 @c_strcmp(i64 %t4304, i64 %t4305)
ret i64 %t4307
L1404:
%t4308 = icmp eq i64 %p0, 1
br i1 %t4308, label %L1405, label %L1407
L1405:
%t4309 = call double @unbox_float(i64 %t4304)
%t4310 = call double @unbox_float(i64 %t4305)
%t4311 = fcmp olt double %t4309, %t4310
br i1 %t4311, label %L1408, label %L1409
L1408:
%t4312 = sub nsw i64 0, 1
br label %L1410
L1409:
%t4313 = fcmp ogt double %t4309, %t4310
br i1 %t4313, label %L1411, label %L1412
L1411:
br label %L1413
L1412:
br label %L1413
L1413:
%t4314 = phi i64 [ 1, %L1411 ], [ 0, %L1412 ]
br label %L1410
L1410:
%t4315 = phi i64 [ %t4312, %L1408 ], [ %t4314, %L1413 ]
ret i64 %t4315
L1407:
%t4316 = call i64 @unbox_word(i64 %t4304)
%t4317 = call i64 @unbox_word(i64 %t4305)
%t4318 = icmp slt i64 %t4316, %t4317
br i1 %t4318, label %L1414, label %L1415
L1414:
%t4319 = sub nsw i64 0, 1
br label %L1416
L1415:
%t4320 = icmp sgt i64 %t4316, %t4317
br i1 %t4320, label %L1417, label %L1418
L1417:
br label %L1419
L1418:
br label %L1419
L1419:
%t4321 = phi i64 [ 1, %L1417 ], [ 0, %L1418 ]
br label %L1416
L1416:
%t4322 = phi i64 [ %t4319, %L1414 ], [ %t4321, %L1419 ]
ret i64 %t4322
}
define internal i64 @__mruntime_rt_lists_resid__merge_run(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ], [ %p3, %tco.s1 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t4339, %tco.s0 ], [ %p4, %tco.s1 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ], [ %p5, %tco.s1 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ], [ %t4348, %tco.s1 ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p7, %tco.s0 ], [ %p7, %tco.s1 ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t4340, %tco.s0 ], [ %t4349, %tco.s1 ]
%t4323 = icmp slt i64 %p4, %p5
br label %LSL4324
LSL4324:
br i1 %t4323, label %LSR4324, label %LSJ4324
LSR4324:
%t4325 = icmp slt i64 %p6, %p7
br label %LSJ4324
LSJ4324:
%t4326 = phi i1 [ false, %LSL4324 ], [ %t4325, %LSR4324 ]
br i1 %t4326, label %L1420, label %L1422
L1420:
%t4327 = mul i64 %p4, 8
%t4328 = add i64 %p2, %t4327
%t4329 = mul i64 %p6, 8
%t4330 = add i64 %p2, %t4329
%t4331 = call i64 @__mruntime_rt_lists_resid__slot_cmp(i64 %p0, i64 %p1, i64 %t4328, i64 %t4330)
%t4332 = icmp sle i64 %t4331, 0
br i1 %t4332, label %L1423, label %L1425
L1423:
%t4333 = mul i64 %p8, 8
%t4334 = add i64 %p3, %t4333
%t4335 = mul i64 %p4, 8
%t4336 = add i64 %p2, %t4335
%t4337 = call i64 @ld64(i64 %t4336)
%t4338 = call i64 @st64(i64 %t4334, i64 %t4337)
%t4339 = add nsw i64 %p4, 1
%t4340 = add i64 %p8, 1
br label %tco.s0
tco.s0:
br label %tco.head
L1425:
%t4342 = mul i64 %p8, 8
%t4343 = add i64 %p3, %t4342
%t4344 = mul i64 %p6, 8
%t4345 = add i64 %p2, %t4344
%t4346 = call i64 @ld64(i64 %t4345)
%t4347 = call i64 @st64(i64 %t4343, i64 %t4346)
%t4348 = add nsw i64 %p6, 1
%t4349 = add i64 %p8, 1
br label %tco.s1
tco.s1:
br label %tco.head
L1422:
%t4351 = icmp slt i64 %p4, %p5
br i1 %t4351, label %L1426, label %L1427
L1426:
%t4352 = mul i64 %p8, 8
%t4353 = add i64 %p3, %t4352
%t4354 = mul i64 %p4, 8
%t4355 = add i64 %p2, %t4354
%t4356 = sub i64 %p5, %p4
%t4357 = mul i64 %t4356, 8
%t4358 = call i64 @mcopy(i64 %t4353, i64 %t4355, i64 %t4357)
br label %L1428
L1427:
br label %L1428
L1428:
%t4359 = phi i64 [ %t4358, %L1426 ], [ 0, %L1427 ]
%t4360 = icmp slt i64 %p6, %p7
br i1 %t4360, label %L1429, label %L1430
L1429:
%t4361 = add i64 %p8, %p5
%t4362 = sub i64 %t4361, %p4
%t4363 = mul i64 %t4362, 8
%t4364 = add i64 %p3, %t4363
%t4365 = mul i64 %p6, 8
%t4366 = add i64 %p2, %t4365
%t4367 = sub i64 %p7, %p6
%t4368 = mul i64 %t4367, 8
%t4369 = call i64 @mcopy(i64 %t4364, i64 %t4366, i64 %t4368)
br label %L1431
L1430:
br label %L1431
L1431:
%t4370 = phi i64 [ %t4369, %L1429 ], [ 0, %L1430 ]
ret i64 %t4370
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
%p6 = phi i64 [ %p6.in, %entry ], [ %t4381, %tco.s0 ]
%t4371 = icmp sge i64 %p6, %p4
br i1 %t4371, label %L1432, label %L1434
L1432:
ret i64 0
L1434:
%t4372 = add i64 %p6, %p5
%t4373 = icmp slt i64 %t4372, %p4
br i1 %t4373, label %L1435, label %L1436
L1435:
br label %L1437
L1436:
br label %L1437
L1437:
%t4374 = phi i64 [ %t4372, %L1435 ], [ %p4, %L1436 ]
%t4375 = mul i64 2, %p5
%t4376 = add i64 %p6, %t4375
%t4377 = icmp slt i64 %t4376, %p4
br i1 %t4377, label %L1438, label %L1439
L1438:
br label %L1440
L1439:
br label %L1440
L1440:
%t4378 = phi i64 [ %t4376, %L1438 ], [ %p4, %L1439 ]
%t4379 = call i64 @__mruntime_rt_lists_resid__merge_run(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p6, i64 %t4374, i64 %t4374, i64 %t4378, i64 %p6)
%t4380 = mul i64 2, %p5
%t4381 = add i64 %p6, %t4380
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
%p5 = phi i64 [ %p5.in, %entry ], [ %t4385, %tco.s0 ]
%t4383 = icmp sge i64 %p5, %p4
br i1 %t4383, label %L1441, label %L1443
L1441:
ret i64 %p2
L1443:
%t4384 = call i64 @__mruntime_rt_lists_resid__merge_pass(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 0)
%t4385 = mul i64 %p5, 2
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_lists_resid__sorted_copy(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4387 = call i64 @c_list_len(i64 %p0)
%t4388 = call i64 @c_list_to_array(i64 %p0)
%t4389 = mul i64 %t4387, 8
%t4390 = call i64 @xmalloc(i64 %t4389)
%t4391 = call i64 @__mruntime_rt_lists_resid__merge_sort(i64 %p1, i64 %p2, i64 %t4388, i64 %t4390, i64 %t4387, i64 1)
%t4392 = call i64 @c_list_type(i64 %p0)
%t4393 = call i64 @c_list_new(i64 %t4387, i64 %t4391, i64 %t4392)
%t4394 = call i64 @c_free(i64 %t4388)
%t4395 = call i64 @c_free(i64 %t4390)
%t4396 = add i64 %t4394, %t4395
ret i64 %t4393
}
define internal i64 @rt_list_sort_ints(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4397 = call i64 @__mruntime_rt_lists_resid__sorted_copy(i64 %p0, i64 0, i64 0)
ret i64 %t4397
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
%t4398 = call i64 @__mruntime_rt_lists_resid__sorted_copy(i64 %p0, i64 1, i64 0)
ret i64 %t4398
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
%t4399 = call i64 @__mruntime_rt_lists_resid__sorted_copy(i64 %p0, i64 2, i64 0)
ret i64 %t4399
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
%t4400 = call i64 @__mruntime_rt_lists_resid__sorted_copy(i64 %p0, i64 3, i64 %p1)
ret i64 %t4400
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
%t4401p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.rand_byte)
%t4401 = ptrtoint ptr %t4401p to i64
%t4402 = call i64 @st64(i64 %t4401, i64 0)
%t4403 = call i64 @sc(i64 318, i64 %t4401, i64 1, i64 0)
%t4404 = icmp eq i64 %t4403, 1
br i1 %t4404, label %L1444, label %L1446
L1444:
%t4405 = call i64 @ld8(i64 %t4401)
ret i64 %t4405
L1446:
%t4407 = ptrtoint ptr @.s4406 to i64
%t4408 = call i64 @o_rdonly()
%t4409 = call i64 @sys_open(i64 %t4407, i64 %t4408, i64 0)
%t4410 = icmp slt i64 %t4409, 0
br i1 %t4410, label %L1447, label %L1449
L1447:
%t4412 = call i64 @rt_abort(ptr @.s4411)
ret i64 %t4412
L1449:
%t4413 = call i64 @sc(i64 0, i64 %t4409, i64 %t4401, i64 1)
%t4414 = call i64 @sys_close(i64 %t4409)
%t4415 = icmp ne i64 %t4413, 1
br i1 %t4415, label %L1450, label %L1452
L1450:
%t4417 = call i64 @rt_abort(ptr @.s4416)
ret i64 %t4417
L1452:
%t4418 = call i64 @ld8(i64 %t4401)
ret i64 %t4418
}
define i64 @resid_crypto_random_byte() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_crypto_random_byte()
ret i64 %r
}
define internal i64 @rt_cpu_has_aesni() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4419a = trunc i64 1 to i32
%t4419b = trunc i64 0 to i32
%t4419s = call { i32, i32, i32, i32 } asm "cpuid", "={ax},={bx},={cx},={dx},{ax},{cx}"(i32 %t4419a, i32 %t4419b)
%t4419c = extractvalue { i32, i32, i32, i32 } %t4419s, 2
%t4419d = extractvalue { i32, i32, i32, i32 } %t4419s, 3
%t4419h = zext i32 %t4419c to i64
%t4419l = zext i32 %t4419d to i64
%t4419k = shl i64 %t4419h, 32
%t4419 = or i64 %t4419k, %t4419l
%t4420 = ashr i64 %t4419, 57
%t4421 = and i64 %t4420, 1
ret i64 %t4421
}
define i8 @resid_cpu_has_aesni() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_cpu_has_aesni()
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_index_abort(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4422 = call i64 @rt_sb_new()
%t4424 = ptrtoint ptr @.s4423 to i64
%t4425 = call i64 @sb_lit(i64 %t4422, i64 %t4424)
%t4426 = call i64 @sb_word(i64 %t4422, i64 %p0)
%t4428 = ptrtoint ptr @.s4427 to i64
%t4429 = call i64 @sb_lit(i64 %t4422, i64 %t4428)
%t4430 = call i64 @sb_word(i64 %t4422, i64 %p1)
%t4431 = icmp ne i64 %p2, 0
br label %LSL4432
LSL4432:
br i1 %t4431, label %LSR4432, label %LSJ4432
LSR4432:
%t4433 = call i64 @ld8(i64 %p2)
%t4434 = icmp ne i64 %t4433, 0
br label %LSJ4432
LSJ4432:
%t4435 = phi i1 [ false, %LSL4432 ], [ %t4434, %LSR4432 ]
br i1 %t4435, label %L1453, label %L1454
L1453:
%t4437 = ptrtoint ptr @.s4436 to i64
%t4438 = call i64 @sb_lit(i64 %t4422, i64 %t4437)
%t4439 = call i64 @sb_lit(i64 %t4422, i64 %p2)
%t4440 = add i64 %t4438, %t4439
%t4442 = ptrtoint ptr @.s4441 to i64
%t4443 = call i64 @sb_lit(i64 %t4422, i64 %t4442)
%t4444 = add i64 %t4440, %t4443
br label %L1455
L1454:
br label %L1455
L1455:
%t4445 = phi i64 [ %t4444, %L1453 ], [ 0, %L1454 ]
%t4446 = call i64 @rt_sb_finish(i64 %t4422)
%t4447 = call i64 @rt_abort_at(i64 %t4446)
ret i64 %t4447
}
define void @resid_index_abort(i64 %a0, i64 %a1, ptr %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x2i = ptrtoint ptr %a2 to i64
%r = call i64 @rt_index_abort(i64 %a0, i64 %a1, i64 %x2i)
ret void
}
define internal i1 @__mruntime_rt_net_resid__host_ok(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4448 = call i64 @ld8(i64 %p0)
%t4449 = icmp eq i64 %t4448, 0
br i1 %t4449, label %L1456, label %L1458
L1456:
ret i1 true
L1458:
%t4450 = icmp sge i64 %t4448, 97
br label %LSL4451
LSL4451:
br i1 %t4450, label %LSR4451, label %LSJ4451
LSR4451:
%t4452 = icmp sle i64 %t4448, 122
br label %LSJ4451
LSJ4451:
%t4453 = phi i1 [ false, %LSL4451 ], [ %t4452, %LSR4451 ]
br label %LSL4454
LSL4454:
br i1 %t4453, label %LSJ4454, label %LSR4454
LSR4454:
%t4455 = icmp sge i64 %t4448, 65
br label %LSL4456
LSL4456:
br i1 %t4455, label %LSR4456, label %LSJ4456
LSR4456:
%t4457 = icmp sle i64 %t4448, 90
br label %LSJ4456
LSJ4456:
%t4458 = phi i1 [ false, %LSL4456 ], [ %t4457, %LSR4456 ]
br label %LSJ4454
LSJ4454:
%t4459 = phi i1 [ true, %LSL4454 ], [ %t4458, %LSJ4456 ]
br label %LSL4460
LSL4460:
br i1 %t4459, label %LSJ4460, label %LSR4460
LSR4460:
%t4461 = icmp sge i64 %t4448, 48
br label %LSL4462
LSL4462:
br i1 %t4461, label %LSR4462, label %LSJ4462
LSR4462:
%t4463 = icmp sle i64 %t4448, 57
br label %LSJ4462
LSJ4462:
%t4464 = phi i1 [ false, %LSL4462 ], [ %t4463, %LSR4462 ]
br label %LSJ4460
LSJ4460:
%t4465 = phi i1 [ true, %LSL4460 ], [ %t4464, %LSJ4462 ]
br label %LSL4466
LSL4466:
br i1 %t4465, label %LSJ4466, label %LSR4466
LSR4466:
%t4467 = icmp eq i64 %t4448, 45
br label %LSJ4466
LSJ4466:
%t4468 = phi i1 [ true, %LSL4466 ], [ %t4467, %LSR4466 ]
br label %LSL4469
LSL4469:
br i1 %t4468, label %LSJ4469, label %LSR4469
LSR4469:
%t4470 = icmp eq i64 %t4448, 46
br label %LSJ4469
LSJ4469:
%t4471 = phi i1 [ true, %LSL4469 ], [ %t4470, %LSR4469 ]
br label %LSL4472
LSL4472:
br i1 %t4471, label %LSJ4472, label %LSR4472
LSR4472:
%t4473 = icmp eq i64 %t4448, 58
br label %LSJ4472
LSJ4472:
%t4474 = phi i1 [ true, %LSL4472 ], [ %t4473, %LSR4472 ]
br label %LSL4475
LSL4475:
br i1 %t4474, label %LSR4475, label %LSJ4475
LSR4475:
%t4476 = add i64 %p0, 1
%t4477 = call i1 @__mruntime_rt_net_resid__host_ok(i64 %t4476)
br label %LSJ4475
LSJ4475:
%t4478 = phi i1 [ false, %LSL4475 ], [ %t4477, %LSR4475 ]
ret i1 %t4478
}
define internal i64 @rt_tcp_connect(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4479 = icmp eq i64 %p0, 0
br label %LSL4480
LSL4480:
br i1 %t4479, label %LSJ4480, label %LSR4480
LSR4480:
%t4481 = call i64 @ld8(i64 %p0)
%t4482 = icmp eq i64 %t4481, 0
br label %LSJ4480
LSJ4480:
%t4483 = phi i1 [ true, %LSL4480 ], [ %t4482, %LSR4480 ]
br label %LSL4484
LSL4484:
br i1 %t4483, label %LSJ4484, label %LSR4484
LSR4484:
%t4485 = call i1 @__mruntime_rt_net_resid__host_ok(i64 %p0)
%t4486 = xor i1 %t4485, true
br label %LSJ4484
LSJ4484:
%t4487 = phi i1 [ true, %LSL4484 ], [ %t4486, %LSR4484 ]
br i1 %t4487, label %L1459, label %L1461
L1459:
%t4488 = sub nsw i64 0, 1
ret i64 %t4488
L1461:
%t4489 = icmp sle i64 %p1, 0
br label %LSL4490
LSL4490:
br i1 %t4489, label %LSJ4490, label %LSR4490
LSR4490:
%t4491 = icmp sgt i64 %p1, 65535
br label %LSJ4490
LSJ4490:
%t4492 = phi i1 [ true, %LSL4490 ], [ %t4491, %LSR4490 ]
br i1 %t4492, label %L1462, label %L1464
L1462:
%t4493 = sub nsw i64 0, 1
ret i64 %t4493
L1464:
%t4494p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.ai_hints)
%t4494 = ptrtoint ptr %t4494p to i64
%t4495p = inttoptr i64 %t4494 to ptr
%t4495q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t4495p, i8 %t4495q, i64 48, i1 false)
%t4495 = add i64 0, 0
%t4496 = add i64 %t4494, 8
%t4497 = call i64 @st32(i64 %t4496, i64 1)
%t4498p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.ai_port)
%t4498 = ptrtoint ptr %t4498p to i64
%t4499 = call i64 @itoa_into(i64 %t4498, i64 %p1)
%t4500 = add i64 %t4498, %t4499
%t4501 = call i64 @st8(i64 %t4500, i64 0)
%t4502p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.ai_res)
%t4502 = ptrtoint ptr %t4502p to i64
%t4503 = call i64 @st64(i64 %t4502, i64 0)
%t4504 = call i64 @c_getaddrinfo(i64 %p0, i64 %t4498, i64 %t4494, i64 %t4502)
%t4505 = icmp ne i64 %t4504, 0
br label %LSL4506
LSL4506:
br i1 %t4505, label %LSJ4506, label %LSR4506
LSR4506:
%t4507 = call i64 @ld64(i64 %t4502)
%t4508 = icmp eq i64 %t4507, 0
br label %LSJ4506
LSJ4506:
%t4509 = phi i1 [ true, %LSL4506 ], [ %t4508, %LSR4506 ]
br i1 %t4509, label %L1465, label %L1467
L1465:
%t4510 = sub nsw i64 0, 1
ret i64 %t4510
L1467:
%t4511 = call i64 @ld64(i64 %t4502)
%t4512 = add i64 %t4511, 4
%t4513 = call i64 @ld32(i64 %t4512)
%t4514 = add i64 %t4511, 8
%t4515 = call i64 @ld32(i64 %t4514)
%t4516 = add i64 %t4511, 12
%t4517 = call i64 @ld32(i64 %t4516)
%t4518 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 41, i64 %t4513, i64 %t4515, i64 %t4517, i64 0, i64 0, i64 0)
%t4519 = icmp slt i64 %t4518, 0
br i1 %t4519, label %L1468, label %L1470
L1468:
%t4520 = call i64 @c_freeaddrinfo(i64 %t4511)
%t4521 = mul nsw i64 %t4520, 0
%t4522 = sub nsw i64 %t4521, 1
ret i64 %t4522
L1470:
%t4523 = add i64 %t4511, 24
%t4524 = call i64 @ld64(i64 %t4523)
%t4525 = add i64 %t4511, 16
%t4526 = call i64 @ld32(i64 %t4525)
%t4527 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 42, i64 %t4518, i64 %t4524, i64 %t4526, i64 0, i64 0, i64 0)
%t4528 = call i64 @c_freeaddrinfo(i64 %t4511)
%t4529 = icmp ne i64 %t4527, 0
br i1 %t4529, label %L1471, label %L1473
L1471:
%t4530 = call i64 @sys_close(i64 %t4518)
%t4531 = mul nsw i64 %t4530, 0
%t4532 = sub nsw i64 %t4531, 1
ret i64 %t4532
L1473:
%t4533p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.ai_tv)
%t4533 = ptrtoint ptr %t4533p to i64
%t4534 = call i64 @st64(i64 %t4533, i64 30)
%t4535 = add i64 %t4533, 8
%t4536 = call i64 @st64(i64 %t4535, i64 0)
%t4537 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 54, i64 %t4518, i64 1, i64 20, i64 %t4533, i64 16, i64 0)
ret i64 %t4518
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t4541, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4542, %tco.s0 ]
%t4538 = icmp sle i64 %p2, 0
br i1 %t4538, label %L1474, label %L1476
L1474:
ret i1 true
L1476:
%t4539 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 44, i64 %p0, i64 %p1, i64 %p2, i64 16384, i64 0, i64 0)
%t4540 = icmp sle i64 %t4539, 0
br i1 %t4540, label %L1477, label %L1479
L1477:
ret i1 false
L1479:
%t4541 = add i64 %p1, %t4539
%t4542 = sub nsw i64 %p2, %t4539
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_tcp_send(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4544 = call i64 @c_strlen(i64 %p1)
%t4545 = call i1 @__mruntime_rt_net_resid__send_all(i64 %p0, i64 %p1, i64 %t4544)
br i1 %t4545, label %L1480, label %L1481
L1480:
br label %L1482
L1481:
br label %L1482
L1482:
%t4546 = phi i64 [ 1, %L1480 ], [ 0, %L1481 ]
ret i64 %t4546
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
%t4547 = call i64 @xmalloc(i64 65536)
%t4548 = call i64 @__mruntime_rt_net_resid__recv_loop(i64 %p0, i64 %t4547, i64 65536, i64 0)
ret i64 %t4548
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t4557, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4558, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ], [ %t4569, %tco.s1 ]
%t4549 = add i64 %p3, 4096
%t4550 = icmp sgt i64 %t4549, %p2
br i1 %t4550, label %L1483, label %L1485
L1483:
%t4551 = icmp sge i64 %p2, 4194304
br i1 %t4551, label %L1486, label %L1488
L1486:
%t4552 = add i64 %p1, %p3
%t4553 = call i64 @st8(i64 %t4552, i64 0)
%t4554 = mul nsw i64 %t4553, 0
%t4555 = add nsw i64 %t4554, %p1
ret i64 %t4555
L1488:
%t4556 = mul i64 %p2, 2
%t4557 = call i64 @xrealloc(i64 %p1, i64 %t4556)
%t4558 = mul i64 %p2, 2
br label %tco.s0
tco.s0:
br label %tco.head
L1485:
%t4560 = add i64 %p1, %p3
%t4561 = sub i64 %p2, %p3
%t4562 = sub i64 %t4561, 1
%t4563 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 45, i64 %p0, i64 %t4560, i64 %t4562, i64 0, i64 0, i64 0)
%t4564 = icmp sle i64 %t4563, 0
br i1 %t4564, label %L1489, label %L1491
L1489:
%t4565 = add i64 %p1, %p3
%t4566 = call i64 @st8(i64 %t4565, i64 0)
%t4567 = mul nsw i64 %t4566, 0
%t4568 = add nsw i64 %t4567, %p1
ret i64 %t4568
L1491:
%t4569 = add i64 %p3, %t4563
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @rt_tcp_close(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4571 = call i64 @sys_close(i64 %p0)
%t4572 = icmp eq i64 %t4571, 0
br i1 %t4572, label %L1492, label %L1493
L1492:
br label %L1494
L1493:
br label %L1494
L1494:
%t4573 = phi i64 [ 1, %L1492 ], [ 0, %L1493 ]
ret i64 %t4573
}
define i8 @resid_tcp_close(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_tcp_close(i64 %a0)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_tcp_send_bin(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4574 = call i64 @c_list_len(i64 %p1)
%t4575 = icmp sle i64 %t4574, 0
br i1 %t4575, label %L1495, label %L1497
L1495:
ret i64 1
L1497:
%t4576 = icmp sgt i64 %t4574, 1048576
br i1 %t4576, label %L1498, label %L1500
L1498:
ret i64 0
L1500:
%t4577 = call i64 @xmalloc(i64 %t4574)
%t4578 = call i64 @__mruntime_rt_net_resid__bytes_of(i64 %p1, i64 %t4577, i64 0, i64 %t4574)
%t4579 = call i1 @__mruntime_rt_net_resid__send_all(i64 %p0, i64 %t4577, i64 %t4574)
%t4580 = call i64 @c_free(i64 %t4577)
br i1 %t4579, label %L1501, label %L1502
L1501:
br label %L1503
L1502:
br label %L1503
L1503:
%t4581 = phi i64 [ 1, %L1501 ], [ 0, %L1502 ]
ret i64 %t4581
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4588, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t4582 = icmp sge i64 %p2, %p3
br i1 %t4582, label %L1504, label %L1506
L1504:
ret i64 0
L1506:
%t4583 = add i64 %p1, %p2
%t4584 = call i64 @c_list_get(i64 %p0, i64 %p2)
%t4585 = call i64 @unbox_word(i64 %t4584)
%t4586 = and i64 %t4585, 255
%t4587 = call i64 @st8(i64 %t4583, i64 %t4586)
%t4588 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_tcp_recv_bin(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4590 = icmp slt i64 %p1, 0
br i1 %t4590, label %L1507, label %L1508
L1507:
br label %L1509
L1508:
%t4591 = icmp sgt i64 %p1, 1048576
br i1 %t4591, label %L1510, label %L1511
L1510:
br label %L1512
L1511:
br label %L1512
L1512:
%t4592 = phi i64 [ 1048576, %L1510 ], [ %p1, %L1511 ]
br label %L1509
L1509:
%t4593 = phi i64 [ 0, %L1507 ], [ %t4592, %L1512 ]
%t4594 = call i64 @xmalloc(i64 %t4593)
%t4595p = inttoptr i64 %t4594 to ptr
%t4595q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t4595p, i8 %t4595q, i64 %t4593, i1 false)
%t4595 = add i64 0, 0
%t4596 = call i64 @__mruntime_rt_net_resid__recv_exact(i64 %p0, i64 %t4594, i64 0, i64 %t4593)
%t4597 = mul i64 %t4593, 8
%t4598 = call i64 @xmalloc(i64 %t4597)
%t4599 = call i64 @__mruntime_rt_net_resid__byte_boxes(i64 %t4594, i64 %t4598, i64 0, i64 %t4593)
%t4601 = ptrtoint ptr @.s4600 to i64
%t4602 = call i64 @c_list_new(i64 %t4593, i64 %t4598, i64 %t4601)
%t4603 = call i64 @c_free(i64 %t4594)
%t4604 = call i64 @c_free(i64 %t4598)
%t4605 = add i64 %t4603, %t4604
ret i64 %t4602
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4611, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t4606 = icmp sge i64 %p2, %p3
br i1 %t4606, label %L1513, label %L1515
L1513:
ret i64 %p2
L1515:
%t4607 = add i64 %p1, %p2
%t4608 = sub i64 %p3, %p2
%t4609 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 45, i64 %p0, i64 %t4607, i64 %t4608, i64 0, i64 0, i64 0)
%t4610 = icmp sle i64 %t4609, 0
br i1 %t4610, label %L1516, label %L1518
L1516:
ret i64 %p2
L1518:
%t4611 = add i64 %p2, %t4609
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4620, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t4613 = icmp sge i64 %p2, %p3
br i1 %t4613, label %L1519, label %L1521
L1519:
ret i64 0
L1521:
%t4614 = mul i64 %p2, 8
%t4615 = add i64 %p1, %t4614
%t4616 = add i64 %p0, %p2
%t4617 = call i64 @ld8(i64 %t4616)
%t4618 = add i64 %t4617, 18295873486192640
%t4619 = call i64 @st64(i64 %t4615, i64 %t4618)
%t4620 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_ctl_resid__catch_slot() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4622p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.rt_catch)
%t4622 = ptrtoint ptr %t4622p to i64
ret i64 %t4622
}
define internal i64 @__mruntime_rt_ctl_resid__catch_msg() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4623p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.rt_catch_msg)
%t4623 = ptrtoint ptr %t4623p to i64
ret i64 %t4623
}
define internal i1 @under_catch(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4624 = call i64 @__mruntime_rt_ctl_resid__catch_slot()
%t4625 = call i64 @e.catch(i64 %t4624, i64 %p0, i64 %p1)
%t4626 = icmp ne i64 %t4625, 0
ret i1 %t4626
}
define internal i64 @__mruntime_rt_ctl_resid__rt_fail(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4627 = call i64 @__mruntime_rt_ctl_resid__catch_slot()
%t4628 = call i64 @ld64(i64 %t4627)
%t4629 = icmp ne i64 %t4628, 0
br i1 %t4629, label %L1522, label %L1524
L1522:
%t4630 = call i64 @__mruntime_rt_ctl_resid__catch_msg()
%t4631 = icmp ne i64 %p0, 0
br i1 %t4631, label %L1525, label %L1526
L1525:
br label %L1527
L1526:
%t4633 = ptrtoint ptr @.s4632 to i64
br label %L1527
L1527:
%t4634 = phi i64 [ %p0, %L1525 ], [ %t4633, %L1526 ]
%t4635 = call i64 @st64(i64 %t4630, i64 %t4634)
%t4636 = tail call i64 @c_longjmp(i64 %t4628, i64 1)
ret i64 %t4636
L1524:
%t4637 = call i64 @rt_sb_new()
%t4638 = icmp ne i64 %p0, 0
br label %LSL4639
LSL4639:
br i1 %t4638, label %LSR4639, label %LSJ4639
LSR4639:
%t4640 = call i64 @ld8(i64 %p0)
%t4641 = icmp ne i64 %t4640, 0
br label %LSJ4639
LSJ4639:
%t4642 = phi i1 [ false, %LSL4639 ], [ %t4641, %LSR4639 ]
%t4643 = icmp ne i64 %p1, 0
br label %LSL4644
LSL4644:
br i1 %t4643, label %LSR4644, label %LSJ4644
LSR4644:
%t4645 = call i64 @ld8(i64 %p1)
%t4646 = icmp ne i64 %t4645, 0
br label %LSJ4644
LSJ4644:
%t4647 = phi i1 [ false, %LSL4644 ], [ %t4646, %LSR4644 ]
%t4649 = ptrtoint ptr @.s4648 to i64
%t4650 = call i64 @sb_lit(i64 %t4637, i64 %t4649)
br i1 %t4647, label %L1528, label %L1529
L1528:
%t4652 = ptrtoint ptr @.s4651 to i64
%t4653 = call i64 @sb_lit(i64 %t4637, i64 %t4652)
br i1 %t4642, label %L1531, label %L1532
L1531:
br label %L1533
L1532:
%t4655 = ptrtoint ptr @.s4654 to i64
br label %L1533
L1533:
%t4656 = phi i64 [ %p0, %L1531 ], [ %t4655, %L1532 ]
%t4657 = call i64 @sb_lit(i64 %t4637, i64 %t4656)
%t4658 = add i64 %t4653, %t4657
%t4660 = ptrtoint ptr @.s4659 to i64
%t4661 = call i64 @sb_lit(i64 %t4637, i64 %t4660)
%t4662 = add i64 %t4658, %t4661
%t4663 = call i64 @sb_lit(i64 %t4637, i64 %p1)
%t4664 = add i64 %t4662, %t4663
%t4666 = ptrtoint ptr @.s4665 to i64
%t4667 = call i64 @sb_lit(i64 %t4637, i64 %t4666)
%t4668 = add i64 %t4664, %t4667
br label %L1530
L1529:
br label %L1530
L1530:
%t4669 = phi i64 [ %t4668, %L1533 ], [ 0, %L1529 ]
%t4670 = xor i1 %t4647, true
br label %LSL4671
LSL4671:
br i1 %t4670, label %LSR4671, label %LSJ4671
LSR4671:
br label %LSJ4671
LSJ4671:
%t4672 = phi i1 [ false, %LSL4671 ], [ %t4642, %LSR4671 ]
br i1 %t4672, label %L1534, label %L1535
L1534:
%t4674 = ptrtoint ptr @.s4673 to i64
%t4675 = call i64 @sb_lit(i64 %t4637, i64 %t4674)
%t4676 = call i64 @sb_lit(i64 %t4637, i64 %p0)
%t4677 = add i64 %t4675, %t4676
br label %L1536
L1535:
br label %L1536
L1536:
%t4678 = phi i64 [ %t4677, %L1534 ], [ 0, %L1535 ]
%t4680 = ptrtoint ptr @.s4679 to i64
%t4681 = call i64 @sb_lit(i64 %t4637, i64 %t4680)
%t4682 = call i64 @rt_sb_finish(i64 %t4637)
%t4683 = call i64 @c_strlen(i64 %t4682)
%t4684 = call i1 @write_all(i64 2, i64 %t4682, i64 %t4683)
%t4685 = call i64 @c_libc_abort()
ret i64 %t4685
}
define internal i64 @rt_abort_msg(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4686 = call i64 @__mruntime_rt_ctl_resid__rt_fail(i64 %p0, i64 0)
ret i64 %t4686
}
define void @resid_abort(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_abort_msg(i64 %x0i)
ret void
}
define internal i64 @rt_abort_msg_at(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4687 = tail call i64 @__mruntime_rt_ctl_resid__rt_fail(i64 %p0, i64 %p1)
ret i64 %t4687
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
%t4688 = add i64 %p0, 16
%t4689 = call i64 @ld64(i64 %p0)
%t4690 = add i64 %p0, 8
%t4691 = call i64 @ld64(i64 %t4690)
%t4692p = inttoptr i64 %t4689 to ptr
%t4692 = call i64 %t4692p(i64 %t4691, i64 0)
%t4693 = call i64 @st64(i64 %t4688, i64 %t4692)
ret i64 %t4693
}
define internal i64 @spawn_entry(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4694 = ptrtoint ptr @spawn_run to i64
%t4695 = call i1 @under_catch(i64 %t4694, i64 %p0)
%t4696 = xor i1 %t4695, true
br i1 %t4696, label %L1537, label %L1539
L1537:
%t4697 = add i64 %p0, 16
%t4698 = tail call i64 @ld64(i64 %t4697)
ret i64 %t4698
L1539:
%t4699 = call i64 @__mruntime_rt_ctl_resid__catch_msg()
%t4700 = call i64 @ld64(i64 %t4699)
%t4701 = call i64 @xmalloc(i64 8)
%t4702 = icmp ne i64 %t4700, 0
br i1 %t4702, label %L1540, label %L1541
L1540:
br label %L1542
L1541:
%t4704 = ptrtoint ptr @.s4703 to i64
br label %L1542
L1542:
%t4705 = phi i64 [ %t4700, %L1540 ], [ %t4704, %L1541 ]
%t4706 = call i64 @cstr_dup(i64 %t4705)
%t4707 = call i64 @st64(i64 %t4701, i64 %t4706)
%t4708p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.spawn_slot)
%t4708 = ptrtoint ptr %t4708p to i64
%t4709 = call i64 @st64(i64 %t4708, i64 %t4701)
%t4711 = ptrtoint ptr @.s4710 to i64
%t4712 = call i64 @c_box_new(i64 2, i64 1, i64 %t4708, i64 %t4711)
ret i64 %t4712
}
define internal i64 @rt_spawn(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4713 = call i64 @xmalloc(i64 24)
%t4714 = call i64 @st64(i64 %t4713, i64 %p0)
%t4715 = add i64 %t4713, 8
%t4716 = call i64 @st64(i64 %t4715, i64 %p1)
%t4717 = add i64 %t4713, 16
%t4718 = call i64 @st64(i64 %t4717, i64 0)
%t4719 = call i64 @xmalloc(i64 16)
%t4720 = ptrtoint ptr @spawn_entry to i64
%t4721 = call i64 @c_pthread_create(i64 %t4719, i64 0, i64 %t4720, i64 %t4713)
%t4722 = icmp ne i64 %t4721, 0
br i1 %t4722, label %L1543, label %L1545
L1543:
%t4723 = call i64 @c_free(i64 %t4713)
%t4724 = mul nsw i64 %t4723, 0
ret i64 %t4724
L1545:
%t4725p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.spawn_ret)
%t4725 = ptrtoint ptr %t4725p to i64
%t4726 = call i64 @ld64(i64 %t4719)
%t4727 = call i64 @c_pthread_join(i64 %t4726, i64 %t4725)
%t4728 = call i64 @c_free(i64 %t4713)
%t4729 = call i64 @c_free(i64 %t4719)
%t4730 = add i64 %t4728, %t4729
%t4731 = call i64 @ld64(i64 %t4725)
ret i64 %t4731
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
%t4732p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.spawn_slot)
%t4732 = ptrtoint ptr %t4732p to i64
%t4733 = call i64 @st64(i64 %t4732, i64 %p0)
%t4735 = ptrtoint ptr @.s4734 to i64
%t4736 = call i64 @c_box_new(i64 1, i64 1, i64 %t4732, i64 %t4735)
ret i64 %t4736
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
%t4737p = getelementptr i8, ptr @rtg.rt_test, i64 0
%t4737 = ptrtoint ptr %t4737p to i64
ret i64 %t4737
}
define internal i64 @__mruntime_rt_ctl_resid__tget(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4738 = call i64 @__mruntime_rt_ctl_resid__ts()
%t4739 = mul i64 %p0, 8
%t4740 = add i64 %t4738, %t4739
%t4741 = tail call i64 @ld64(i64 %t4740)
ret i64 %t4741
}
define internal i64 @__mruntime_rt_ctl_resid__tset(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4742 = call i64 @__mruntime_rt_ctl_resid__ts()
%t4743 = mul i64 %p0, 8
%t4744 = add i64 %t4742, %t4743
%t4745 = tail call i64 @st64(i64 %t4744, i64 %p1)
ret i64 %t4745
}
define internal i64 @__mruntime_rt_ctl_resid__fail_buf() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4746p = getelementptr i8, ptr @rtg.rt_test_fail, i64 0
%t4746 = ptrtoint ptr %t4746p to i64
ret i64 %t4746
}
define internal i64 @__mruntime_rt_ctl_resid__cstr_copy_cap(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4747 = call i64 @c_strlen(i64 %p1)
%t4748 = sub i64 %p2, 1
%t4749 = icmp slt i64 %t4747, %t4748
br i1 %t4749, label %L1546, label %L1547
L1546:
br label %L1548
L1547:
br label %L1548
L1548:
%t4750 = phi i64 [ %t4747, %L1546 ], [ %t4748, %L1547 ]
%t4751 = call i64 @mcopy(i64 %p0, i64 %p1, i64 %t4750)
%t4752 = add i64 %p0, %t4750
%t4753 = call i64 @st8(i64 %t4752, i64 0)
ret i64 %t4753
}
define internal i1 @__mruntime_rt_ctl_resid__fmt_read() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4754p = getelementptr i8, ptr @rtg.rt_test_fmt_read, i64 0
%t4754 = ptrtoint ptr %t4754p to i64
%t4755 = call i64 @ld8(i64 %t4754)
%t4756 = icmp ne i64 %t4755, 0
ret i1 %t4756
}
define internal i64 @__mruntime_rt_ctl_resid__fmt_init() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4757 = call i1 @__mruntime_rt_ctl_resid__fmt_read()
br i1 %t4757, label %L1549, label %L1551
L1549:
%t4758 = call i64 @__mruntime_rt_ctl_resid__tget(i64 6)
ret i64 %t4758
L1551:
%t4760 = ptrtoint ptr @.s4759 to i64
%t4761 = call i64 @c_getenv(i64 %t4760)
%t4762 = icmp ne i64 %t4761, 0
br label %LSL4763
LSL4763:
br i1 %t4762, label %LSR4763, label %LSJ4763
LSR4763:
%t4765 = ptrtoint ptr @.s4764 to i64
%t4766 = call i64 @c_strcmp(i64 %t4761, i64 %t4765)
%t4767 = icmp eq i64 %t4766, 0
br label %LSJ4763
LSJ4763:
%t4768 = phi i1 [ false, %LSL4763 ], [ %t4767, %LSR4763 ]
br i1 %t4768, label %L1552, label %L1553
L1552:
br label %L1554
L1553:
%t4769 = icmp ne i64 %t4761, 0
br label %LSL4770
LSL4770:
br i1 %t4769, label %LSR4770, label %LSJ4770
LSR4770:
%t4772 = ptrtoint ptr @.s4771 to i64
%t4773 = call i64 @c_strcmp(i64 %t4761, i64 %t4772)
%t4774 = icmp eq i64 %t4773, 0
br label %LSJ4770
LSJ4770:
%t4775 = phi i1 [ false, %LSL4770 ], [ %t4774, %LSR4770 ]
br i1 %t4775, label %L1555, label %L1556
L1555:
br label %L1557
L1556:
br label %L1557
L1557:
%t4776 = phi i64 [ 2, %L1555 ], [ 0, %L1556 ]
br label %L1554
L1554:
%t4777 = phi i64 [ 1, %L1552 ], [ %t4776, %L1557 ]
%t4778p = getelementptr i8, ptr @rtg.rt_test_fmt_read, i64 0
%t4778 = ptrtoint ptr %t4778p to i64
%t4779 = call i64 @st8(i64 %t4778, i64 1)
%t4780 = call i64 @__mruntime_rt_ctl_resid__tset(i64 7, i64 1)
%t4781 = call i64 @__mruntime_rt_ctl_resid__tset(i64 6, i64 %t4777)
%t4782 = mul nsw i64 %t4781, 0
%t4783 = add nsw i64 %t4782, %t4777
ret i64 %t4783
}
define internal i64 @__mruntime_rt_ctl_resid__out_sb(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4784 = call i64 @rt_sb_finish(i64 %p0)
%t4785 = call i64 @c_strlen(i64 %t4784)
%t4786 = call i1 @write_all(i64 1, i64 %t4784, i64 %t4785)
%t4787 = tail call i64 @c_free(i64 %t4784)
ret i64 %t4787
}
define internal i64 @__mruntime_rt_ctl_resid__sb_ms(i64 %p0, double %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4788p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.test_ms)
%t4788 = ptrtoint ptr %t4788p to i64
%t4789 = call i64 @c_strfromd(i64 %t4788, i64 64, i64 %p2, double %p1)
%t4790 = call i64 @sb_bytes(i64 %p0, i64 %t4788, i64 %t4789)
ret i64 %t4790
}
define internal i64 @__mruntime_rt_ctl_resid__module_name() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4791 = call i64 @__mruntime_rt_ctl_resid__tget(i64 8)
%t4792 = icmp eq i64 %t4791, 0
br i1 %t4792, label %L1558, label %L1559
L1558:
%t4794 = ptrtoint ptr @.s4793 to i64
br label %L1560
L1559:
%t4795 = call i64 @__mruntime_rt_ctl_resid__tget(i64 8)
br label %L1560
L1560:
%t4796 = phi i64 [ %t4794, %L1558 ], [ %t4795, %L1559 ]
ret i64 %t4796
}
define internal i64 @rt_expect_fail(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4797 = call i64 @rt_sb_new()
%t4799 = ptrtoint ptr @.s4798 to i64
%t4800 = call i64 @sb_lit(i64 %t4797, i64 %t4799)
%t4801 = icmp ne i64 %p0, 0
br i1 %t4801, label %L1561, label %L1562
L1561:
br label %L1563
L1562:
%t4803 = ptrtoint ptr @.s4802 to i64
br label %L1563
L1563:
%t4804 = phi i64 [ %p0, %L1561 ], [ %t4803, %L1562 ]
%t4805 = call i64 @sb_lit(i64 %t4797, i64 %t4804)
%t4806 = icmp ne i64 %p1, 0
br i1 %t4806, label %L1564, label %L1565
L1564:
%t4808 = ptrtoint ptr @.s4807 to i64
%t4809 = call i64 @sb_lit(i64 %t4797, i64 %t4808)
%t4810 = call i64 @sb_lit(i64 %t4797, i64 %p1)
%t4811 = add i64 %t4809, %t4810
br label %L1566
L1565:
br label %L1566
L1566:
%t4812 = phi i64 [ %t4811, %L1564 ], [ 0, %L1565 ]
%t4813 = icmp ne i64 %p1, 0
br label %LSL4814
LSL4814:
br i1 %t4813, label %LSR4814, label %LSJ4814
LSR4814:
%t4815 = icmp ne i64 %p2, 0
br label %LSJ4814
LSJ4814:
%t4816 = phi i1 [ false, %LSL4814 ], [ %t4815, %LSR4814 ]
br i1 %t4816, label %L1567, label %L1568
L1567:
%t4818 = ptrtoint ptr @.s4817 to i64
%t4819 = call i64 @sb_lit(i64 %t4797, i64 %t4818)
%t4820 = call i64 @sb_lit(i64 %t4797, i64 %p2)
%t4821 = add i64 %t4819, %t4820
br label %L1569
L1568:
br label %L1569
L1569:
%t4822 = phi i64 [ %t4821, %L1567 ], [ 0, %L1568 ]
%t4823 = call i64 @rt_sb_finish(i64 %t4797)
%t4824p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.expect_buf)
%t4824 = ptrtoint ptr %t4824p to i64
%t4825 = call i64 @__mruntime_rt_ctl_resid__cstr_copy_cap(i64 %t4824, i64 %t4823, i64 1024)
%t4826 = call i64 @__mruntime_rt_ctl_resid__tget(i64 0)
%t4827 = icmp ne i64 %t4826, 0
br i1 %t4827, label %L1570, label %L1571
L1570:
%t4828 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t4829 = call i64 @__mruntime_rt_ctl_resid__cstr_copy_cap(i64 %t4828, i64 %t4824, i64 1024)
br label %L1572
L1571:
br label %L1572
L1572:
%t4830 = phi i64 [ %t4829, %L1570 ], [ 0, %L1571 ]
%t4831 = call i64 @__mruntime_rt_ctl_resid__rt_fail(i64 %t4824, i64 0)
ret i64 %t4831
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
%t4832 = icmp eq i64 %p0, 0
br label %LSL4833
LSL4833:
br i1 %t4832, label %LSJ4833, label %LSR4833
LSR4833:
%t4834 = call i64 @ld64(i64 %p0)
%t4835 = icmp eq i64 %t4834, 0
br label %LSJ4833
LSJ4833:
%t4836 = phi i1 [ true, %LSL4833 ], [ %t4835, %LSR4833 ]
br i1 %t4836, label %L1573, label %L1575
L1573:
ret i64 0
L1575:
%t4837 = call i64 @xmalloc(i64 1024)
%t4838 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t4839 = call i64 @mcopy(i64 %t4837, i64 %t4838, i64 1024)
%t4840 = call i64 @__mruntime_rt_ctl_resid__tget(i64 0)
%t4841 = call i64 @__mruntime_rt_ctl_resid__catch_msg()
%t4842 = call i64 @ld64(i64 %t4841)
%t4843 = call i64 @__mruntime_rt_ctl_resid__tset(i64 0, i64 1)
%t4844 = call i64 @ld64(i64 %p0)
%t4845 = call i1 @under_catch(i64 %t4844, i64 %p0)
%t4846 = call i64 @__mruntime_rt_ctl_resid__catch_msg()
%t4847 = call i64 @st64(i64 %t4846, i64 %t4842)
%t4848 = call i64 @__mruntime_rt_ctl_resid__tset(i64 0, i64 %t4840)
%t4849 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t4850 = call i64 @mcopy(i64 %t4849, i64 %t4837, i64 1024)
%t4851 = call i64 @c_free(i64 %t4837)
br i1 %t4845, label %L1576, label %L1577
L1576:
br label %L1578
L1577:
br label %L1578
L1578:
%t4852 = phi i64 [ 1, %L1576 ], [ 0, %L1577 ]
ret i64 %t4852
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
%t4854 = ptrtoint ptr @.s4853 to i64
%t4855 = call i64 @c_getenv(i64 %t4854)
%t4856 = icmp eq i64 %t4855, 0
br label %LSL4857
LSL4857:
br i1 %t4856, label %LSJ4857, label %LSR4857
LSR4857:
%t4858 = call i64 @ld8(i64 %t4855)
%t4859 = icmp eq i64 %t4858, 0
br label %LSJ4857
LSJ4857:
%t4860 = phi i1 [ true, %LSL4857 ], [ %t4859, %LSR4857 ]
br i1 %t4860, label %L1579, label %L1581
L1579:
ret i64 1
L1581:
%t4861 = icmp ne i64 %p0, 0
br i1 %t4861, label %L1582, label %L1583
L1582:
br label %L1584
L1583:
%t4863 = ptrtoint ptr @.s4862 to i64
br label %L1584
L1584:
%t4864 = phi i64 [ %p0, %L1582 ], [ %t4863, %L1583 ]
%t4865 = call i64 @rt_regex_match(i64 %t4855, i64 %t4864)
ret i64 %t4865
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
%t4866 = icmp ne i64 %p1, 0
br i1 %t4866, label %L1585, label %L1586
L1585:
br label %L1587
L1586:
%t4868 = ptrtoint ptr @.s4867 to i64
br label %L1587
L1587:
%t4869 = phi i64 [ %p1, %L1585 ], [ %t4868, %L1586 ]
%t4870 = call i64 @__mruntime_rt_ctl_resid__tset(i64 8, i64 %t4869)
%t4871 = call i64 @__mruntime_rt_ctl_resid__fmt_init()
%t4872 = call i64 @rt_sb_new()
%t4873 = icmp eq i64 %t4871, 1
br i1 %t4873, label %L1588, label %L1589
L1588:
%t4875 = ptrtoint ptr @.s4874 to i64
%t4876 = call i64 @sb_lit(i64 %t4872, i64 %t4875)
%t4877 = call i64 @sb_word(i64 %t4872, i64 %p0)
%t4878 = add i64 %t4876, %t4877
%t4880 = ptrtoint ptr @.s4879 to i64
%t4881 = call i64 @sb_lit(i64 %t4872, i64 %t4880)
%t4882 = add i64 %t4878, %t4881
br label %L1590
L1589:
br label %L1590
L1590:
%t4883 = phi i64 [ %t4882, %L1588 ], [ 0, %L1589 ]
%t4884 = icmp eq i64 %t4871, 2
br i1 %t4884, label %L1591, label %L1592
L1591:
%t4886 = ptrtoint ptr @.s4885 to i64
%t4887 = call i64 @sb_lit(i64 %t4872, i64 %t4886)
%t4888 = call i64 @__mruntime_rt_ctl_resid__module_name()
%t4889 = call i64 @sb_lit(i64 %t4872, i64 %t4888)
%t4890 = add i64 %t4887, %t4889
%t4892 = ptrtoint ptr @.s4891 to i64
%t4893 = call i64 @sb_lit(i64 %t4872, i64 %t4892)
%t4894 = add i64 %t4890, %t4893
br label %L1593
L1592:
br label %L1593
L1593:
%t4895 = phi i64 [ %t4894, %L1591 ], [ 0, %L1592 ]
%t4896 = icmp eq i64 %t4871, 0
br i1 %t4896, label %L1594, label %L1595
L1594:
%t4898 = ptrtoint ptr @.s4897 to i64
%t4899 = call i64 @sb_lit(i64 %t4872, i64 %t4898)
%t4900 = call i64 @__mruntime_rt_ctl_resid__module_name()
%t4901 = call i64 @sb_lit(i64 %t4872, i64 %t4900)
%t4902 = add i64 %t4899, %t4901
%t4904 = ptrtoint ptr @.s4903 to i64
%t4905 = call i64 @sb_lit(i64 %t4872, i64 %t4904)
%t4906 = add i64 %t4902, %t4905
br label %L1596
L1595:
br label %L1596
L1596:
%t4907 = phi i64 [ %t4906, %L1594 ], [ 0, %L1595 ]
%t4908 = call i64 @__mruntime_rt_ctl_resid__out_sb(i64 %t4872)
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t4922, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t4909 = call i64 @ld8(i64 %p1)
%t4910 = icmp eq i64 %t4909, 0
br i1 %t4910, label %L1597, label %L1599
L1597:
ret i64 0
L1599:
%t4911 = call i64 @c_strchr(i64 %p1, i64 10)
%t4912 = icmp eq i64 %t4911, 0
br i1 %t4912, label %L1600, label %L1601
L1600:
%t4913 = call i64 @c_strlen(i64 %p1)
br label %L1602
L1601:
%t4914 = sub i64 %t4911, %p1
br label %L1602
L1602:
%t4915 = phi i64 [ %t4913, %L1600 ], [ %t4914, %L1601 ]
%t4916 = call i64 @sb_lit(i64 %p0, i64 %p2)
%t4917 = call i64 @sb_bytes(i64 %p0, i64 %p1, i64 %t4915)
%t4919 = ptrtoint ptr @.s4918 to i64
%t4920 = call i64 @sb_lit(i64 %p0, i64 %t4919)
%t4921 = icmp eq i64 %t4911, 0
br i1 %t4921, label %L1603, label %L1605
L1603:
ret i64 0
L1605:
%t4922 = add i64 %t4911, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_ctl_resid__test_report(i64 %p0, i1 %p1, i1 %p2, double %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4924 = call i64 @__mruntime_rt_ctl_resid__fmt_init()
%t4925 = call i64 @rt_sb_new()
%t4926 = icmp eq i64 %t4924, 1
br i1 %t4926, label %L1606, label %L1607
L1606:
%t4927 = call i64 @__mruntime_rt_ctl_resid__report_tap(i64 %t4925, i64 %p0, i1 %p1, i1 %p2)
br label %L1608
L1607:
%t4928 = icmp eq i64 %t4924, 2
br i1 %t4928, label %L1609, label %L1610
L1609:
%t4929 = call i64 @__mruntime_rt_ctl_resid__report_json(i64 %t4925, i64 %p0, i1 %p1, i1 %p2, double %p3)
br label %L1611
L1610:
%t4930 = call i64 @__mruntime_rt_ctl_resid__report_pretty(i64 %t4925, i64 %p0, i1 %p1, i1 %p2, double %p3)
br label %L1611
L1611:
%t4931 = phi i64 [ %t4929, %L1609 ], [ %t4930, %L1610 ]
br label %L1608
L1608:
%t4932 = phi i64 [ %t4927, %L1606 ], [ %t4931, %L1611 ]
%t4933 = call i64 @__mruntime_rt_ctl_resid__out_sb(i64 %t4925)
ret i64 %t4933
}
define internal i64 @__mruntime_rt_ctl_resid__report_tap(i64 %p0, i64 %p1, i1 %p2, i1 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %LSL4934
LSL4934:
br i1 %p2, label %LSR4934, label %LSJ4934
LSR4934:
%t4935 = xor i1 %p3, true
br label %LSJ4934
LSJ4934:
%t4936 = phi i1 [ false, %LSL4934 ], [ %t4935, %LSR4934 ]
br i1 %t4936, label %L1612, label %L1613
L1612:
%t4938 = ptrtoint ptr @.s4937 to i64
br label %L1614
L1613:
%t4940 = ptrtoint ptr @.s4939 to i64
br label %L1614
L1614:
%t4941 = phi i64 [ %t4938, %L1612 ], [ %t4940, %L1613 ]
%t4942 = call i64 @sb_lit(i64 %p0, i64 %t4941)
%t4943 = call i64 @__mruntime_rt_ctl_resid__tget(i64 4)
%t4944 = call i64 @sb_word(i64 %p0, i64 %t4943)
%t4946 = ptrtoint ptr @.s4945 to i64
%t4947 = call i64 @sb_lit(i64 %p0, i64 %t4946)
%t4948 = add i64 %t4944, %t4947
%t4949 = call i64 @__mruntime_rt_ctl_resid__module_name()
%t4950 = call i64 @sb_lit(i64 %p0, i64 %t4949)
%t4951 = add i64 %t4948, %t4950
%t4953 = ptrtoint ptr @.s4952 to i64
%t4954 = call i64 @sb_lit(i64 %p0, i64 %t4953)
%t4955 = add i64 %t4951, %t4954
%t4956 = call i64 @sb_lit(i64 %p0, i64 %p1)
%t4957 = add i64 %t4955, %t4956
br i1 %p3, label %L1615, label %L1617
L1615:
%t4959 = ptrtoint ptr @.s4958 to i64
%t4960 = call i64 @sb_lit(i64 %p0, i64 %t4959)
ret i64 %t4960
L1617:
%t4962 = ptrtoint ptr @.s4961 to i64
%t4963 = call i64 @sb_lit(i64 %p0, i64 %t4962)
%t4964 = xor i1 %p2, true
br i1 %t4964, label %L1618, label %L1620
L1618:
ret i64 0
L1620:
%t4966 = ptrtoint ptr @.s4965 to i64
%t4967 = call i64 @sb_lit(i64 %p0, i64 %t4966)
%t4968 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t4970 = ptrtoint ptr @.s4969 to i64
%t4971 = call i64 @__mruntime_rt_ctl_resid__sb_lines(i64 %p0, i64 %t4968, i64 %t4970)
%t4973 = ptrtoint ptr @.s4972 to i64
%t4974 = call i64 @sb_lit(i64 %p0, i64 %t4973)
ret i64 %t4974
}
define internal i64 @__mruntime_rt_ctl_resid__report_json(i64 %p0, i64 %p1, i1 %p2, i1 %p3, double %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4975 = call i64 @__mruntime_rt_ctl_resid__tget(i64 7)
%t4976 = icmp ne i64 %t4975, 0
br i1 %t4976, label %L1621, label %L1622
L1621:
br label %L1623
L1622:
%t4978 = ptrtoint ptr @.s4977 to i64
%t4979 = call i64 @sb_lit(i64 %p0, i64 %t4978)
br label %L1623
L1623:
%t4980 = phi i64 [ 0, %L1621 ], [ %t4979, %L1622 ]
%t4982 = ptrtoint ptr @.s4981 to i64
%t4983 = call i64 @sb_lit(i64 %p0, i64 %t4982)
%t4984 = call i64 @sb_lit(i64 %p0, i64 %p1)
%t4985 = add i64 %t4983, %t4984
%t4987 = ptrtoint ptr @.s4986 to i64
%t4988 = call i64 @sb_lit(i64 %p0, i64 %t4987)
%t4989 = add i64 %t4985, %t4988
br i1 %p3, label %L1624, label %L1625
L1624:
%t4991 = ptrtoint ptr @.s4990 to i64
br label %L1626
L1625:
br i1 %p2, label %L1627, label %L1628
L1627:
%t4993 = ptrtoint ptr @.s4992 to i64
br label %L1629
L1628:
%t4995 = ptrtoint ptr @.s4994 to i64
br label %L1629
L1629:
%t4996 = phi i64 [ %t4993, %L1627 ], [ %t4995, %L1628 ]
br label %L1626
L1626:
%t4997 = phi i64 [ %t4991, %L1624 ], [ %t4996, %L1629 ]
%t4998 = call i64 @sb_lit(i64 %p0, i64 %t4997)
%t5000 = ptrtoint ptr @.s4999 to i64
%t5001 = call i64 @sb_lit(i64 %p0, i64 %t5000)
%t5003 = ptrtoint ptr @.s5002 to i64
%t5004 = call i64 @__mruntime_rt_ctl_resid__sb_ms(i64 %p0, double %p4, i64 %t5003)
%t5005 = add i64 %t5001, %t5004
%t5007 = ptrtoint ptr @.s5006 to i64
%t5008 = call i64 @sb_lit(i64 %p0, i64 %t5007)
%t5009 = add i64 %t5005, %t5008
%t5010 = call i64 @__mruntime_rt_ctl_resid__tset(i64 7, i64 0)
ret i64 %t5010
}
define internal i64 @__mruntime_rt_ctl_resid__report_pretty(i64 %p0, i64 %p1, i1 %p2, i1 %p3, double %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br i1 %p3, label %L1630, label %L1632
L1630:
%t5012 = ptrtoint ptr @.s5011 to i64
%t5013 = call i64 @sb_lit(i64 %p0, i64 %t5012)
%t5014 = call i64 @sb_lit(i64 %p0, i64 %p1)
%t5015 = add i64 %t5013, %t5014
%t5017 = ptrtoint ptr @.s5016 to i64
%t5018 = call i64 @sb_lit(i64 %p0, i64 %t5017)
%t5019 = add i64 %t5015, %t5018
ret i64 %t5019
L1632:
br i1 %p2, label %L1633, label %L1634
L1633:
%t5021 = ptrtoint ptr @.s5020 to i64
br label %L1635
L1634:
%t5023 = ptrtoint ptr @.s5022 to i64
br label %L1635
L1635:
%t5024 = phi i64 [ %t5021, %L1633 ], [ %t5023, %L1634 ]
%t5025 = call i64 @sb_lit(i64 %p0, i64 %t5024)
%t5026 = call i64 @sb_lit(i64 %p0, i64 %p1)
%t5028 = ptrtoint ptr @.s5027 to i64
%t5029 = call i64 @sb_lit(i64 %p0, i64 %t5028)
%t5030 = add i64 %t5026, %t5029
%t5032 = ptrtoint ptr @.s5031 to i64
%t5033 = call i64 @__mruntime_rt_ctl_resid__sb_ms(i64 %p0, double %p4, i64 %t5032)
%t5034 = add i64 %t5030, %t5033
%t5036 = ptrtoint ptr @.s5035 to i64
%t5037 = call i64 @sb_lit(i64 %p0, i64 %t5036)
%t5038 = add i64 %t5034, %t5037
br i1 %p2, label %L1636, label %L1637
L1636:
%t5039 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t5041 = ptrtoint ptr @.s5040 to i64
%t5042 = call i64 @__mruntime_rt_ctl_resid__sb_lines(i64 %p0, i64 %t5039, i64 %t5041)
br label %L1638
L1637:
br label %L1638
L1638:
%t5043 = phi i64 [ %t5042, %L1636 ], [ 0, %L1637 ]
ret i64 %t5043
}
define internal double @__mruntime_rt_ctl_resid__now_ms() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5044p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.test_clock)
%t5044 = ptrtoint ptr %t5044p to i64
%t5045 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 228, i64 1, i64 %t5044, i64 0, i64 0, i64 0, i64 0)
%t5046 = call i64 @ld64(i64 %t5044)
%t5047 = sitofp i64 %t5046 to double
%t5048 = fmul double %t5047, 1000.0
%t5049 = add i64 %t5044, 8
%t5050 = call i64 @ld64(i64 %t5049)
%t5051 = sitofp i64 %t5050 to double
%t5052 = fdiv double %t5051, 1000000.0
%t5053 = fadd double %t5048, %t5052
ret double %t5053
}
define internal i64 @rt_test_run(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5054 = icmp ne i64 %p1, 0
br i1 %t5054, label %L1639, label %L1640
L1639:
br label %L1641
L1640:
%t5056 = ptrtoint ptr @.s5055 to i64
br label %L1641
L1641:
%t5057 = phi i64 [ %p1, %L1639 ], [ %t5056, %L1640 ]
%t5058 = call i64 @__mruntime_rt_ctl_resid__tget(i64 4)
%t5059 = add i64 %t5058, 1
%t5060 = call i64 @__mruntime_rt_ctl_resid__tset(i64 4, i64 %t5059)
%t5061 = call i64 @__mruntime_rt_ctl_resid__tget(i64 10)
%t5062 = call i64 @__mruntime_rt_ctl_resid__tget(i64 9)
%t5063 = call i64 @__mruntime_rt_ctl_resid__tset(i64 10, i64 0)
%t5064 = call i64 @__mruntime_rt_ctl_resid__tset(i64 9, i64 0)
%t5065 = call i64 @rt_test_selected(i64 %t5057)
%t5066 = icmp eq i64 %t5065, 0
br i1 %t5066, label %L1642, label %L1644
L1642:
%t5067 = call i64 @__mruntime_rt_ctl_resid__tget(i64 3)
%t5068 = add i64 %t5067, 1
%t5069 = call i64 @__mruntime_rt_ctl_resid__tset(i64 3, i64 %t5068)
%t5070 = call i64 @__mruntime_rt_ctl_resid__test_report(i64 %t5057, i1 false, i1 true, double 0.0)
%t5071 = mul nsw i64 %t5070, 0
ret i64 %t5071
L1644:
%t5072 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t5073 = call i64 @st8(i64 %t5072, i64 0)
%t5074 = call i64 @__mruntime_rt_ctl_resid__tset(i64 0, i64 1)
%t5075 = call i64 @__mruntime_rt_ctl_resid__catch_msg()
%t5076 = call i64 @ld64(i64 %t5075)
%t5077 = call double @__mruntime_rt_ctl_resid__now_ms()
%t5078 = icmp ne i64 %p0, 0
br i1 %t5078, label %L1645, label %L1646
L1645:
br label %L1647
L1646:
br label %L1647
L1647:
%t5079 = phi i64 [ %p0, %L1645 ], [ %t5061, %L1646 ]
%t5080 = icmp ne i64 %t5079, 0
br label %LSL5081
LSL5081:
br i1 %t5080, label %LSR5081, label %LSJ5081
LSR5081:
%t5082 = icmp ne i64 %p0, 0
br i1 %t5082, label %L1648, label %L1649
L1648:
br label %L1650
L1649:
br label %L1650
L1650:
%t5083 = phi i64 [ 0, %L1648 ], [ %t5062, %L1649 ]
%t5084 = call i1 @under_catch(i64 %t5079, i64 %t5083)
br label %LSJ5081
LSJ5081:
%t5085 = phi i1 [ false, %LSL5081 ], [ %t5084, %L1650 ]
%t5086 = call i64 @__mruntime_rt_ctl_resid__catch_msg()
%t5087 = call i64 @ld64(i64 %t5086)
br label %LSL5088
LSL5088:
br i1 %t5085, label %LSR5088, label %LSJ5088
LSR5088:
%t5089 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t5090 = call i64 @ld8(i64 %t5089)
%t5091 = icmp eq i64 %t5090, 0
br label %LSJ5088
LSJ5088:
%t5092 = phi i1 [ false, %LSL5088 ], [ %t5091, %LSR5088 ]
br i1 %t5092, label %L1651, label %L1652
L1651:
%t5093 = call i64 @__mruntime_rt_ctl_resid__fail_buf()
%t5094 = icmp ne i64 %t5087, 0
br i1 %t5094, label %L1654, label %L1655
L1654:
br label %L1656
L1655:
%t5096 = ptrtoint ptr @.s5095 to i64
br label %L1656
L1656:
%t5097 = phi i64 [ %t5087, %L1654 ], [ %t5096, %L1655 ]
%t5098 = call i64 @__mruntime_rt_ctl_resid__cstr_copy_cap(i64 %t5093, i64 %t5097, i64 1024)
br label %L1653
L1652:
br label %L1653
L1653:
%t5099 = phi i64 [ %t5098, %L1656 ], [ 0, %L1652 ]
%t5100 = call i64 @__mruntime_rt_ctl_resid__catch_msg()
%t5101 = call i64 @st64(i64 %t5100, i64 %t5076)
%t5102 = call i64 @__mruntime_rt_ctl_resid__tset(i64 0, i64 0)
%t5103 = call double @__mruntime_rt_ctl_resid__now_ms()
%t5104 = fsub double %t5103, %t5077
%t5105 = call i64 @__mruntime_rt_ctl_resid__tget(i64 5)
%t5106 = bitcast i64 %t5105 to double
%t5107 = fadd double %t5106, %t5104
%t5108 = bitcast double %t5107 to i64
%t5109 = call i64 @__mruntime_rt_ctl_resid__tset(i64 5, i64 %t5108)
br i1 %t5085, label %L1657, label %L1658
L1657:
%t5110 = call i64 @__mruntime_rt_ctl_resid__tget(i64 2)
%t5111 = add i64 %t5110, 1
%t5112 = call i64 @__mruntime_rt_ctl_resid__tset(i64 2, i64 %t5111)
br label %L1659
L1658:
%t5113 = call i64 @__mruntime_rt_ctl_resid__tget(i64 1)
%t5114 = add i64 %t5113, 1
%t5115 = call i64 @__mruntime_rt_ctl_resid__tset(i64 1, i64 %t5114)
br label %L1659
L1659:
%t5116 = phi i64 [ %t5112, %L1657 ], [ %t5115, %L1658 ]
%t5117 = call i64 @__mruntime_rt_ctl_resid__test_report(i64 %t5057, i1 %t5085, i1 false, double %t5104)
br i1 %t5085, label %L1660, label %L1661
L1660:
br label %L1662
L1661:
br label %L1662
L1662:
%t5118 = phi i64 [ 1, %L1660 ], [ 0, %L1661 ]
ret i64 %t5118
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
%t5119 = icmp eq i64 %p0, 0
br label %LSL5120
LSL5120:
br i1 %t5119, label %LSJ5120, label %LSR5120
LSR5120:
%t5121 = call i64 @ld64(i64 %p0)
%t5122 = icmp eq i64 %t5121, 0
br label %LSJ5120
LSJ5120:
%t5123 = phi i1 [ true, %LSL5120 ], [ %t5122, %LSR5120 ]
br i1 %t5123, label %L1663, label %L1665
L1663:
ret i64 1
L1665:
%t5124 = call i64 @__mruntime_rt_ctl_resid__tset(i64 9, i64 %p0)
%t5125 = call i64 @ld64(i64 %p0)
%t5126 = call i64 @__mruntime_rt_ctl_resid__tset(i64 10, i64 %t5125)
%t5127 = tail call i64 @rt_test_run(i64 0, i64 %p1)
ret i64 %t5127
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
%t5128 = call i64 @__mruntime_rt_ctl_resid__fmt_init()
%t5129 = call i64 @__mruntime_rt_ctl_resid__tget(i64 5)
%t5130 = bitcast i64 %t5129 to double
%t5131 = call i64 @rt_sb_new()
%t5132 = icmp eq i64 %t5128, 2
br i1 %t5132, label %L1666, label %L1667
L1666:
%t5134 = ptrtoint ptr @.s5133 to i64
%t5135 = call i64 @sb_lit(i64 %t5131, i64 %t5134)
%t5136 = call i64 @__mruntime_rt_ctl_resid__tget(i64 1)
%t5137 = call i64 @sb_word(i64 %t5131, i64 %t5136)
%t5138 = add i64 %t5135, %t5137
%t5140 = ptrtoint ptr @.s5139 to i64
%t5141 = call i64 @sb_lit(i64 %t5131, i64 %t5140)
%t5142 = add i64 %t5138, %t5141
%t5143 = call i64 @__mruntime_rt_ctl_resid__tget(i64 2)
%t5144 = call i64 @sb_word(i64 %t5131, i64 %t5143)
%t5145 = add i64 %t5142, %t5144
%t5147 = ptrtoint ptr @.s5146 to i64
%t5148 = call i64 @sb_lit(i64 %t5131, i64 %t5147)
%t5149 = add i64 %t5145, %t5148
%t5150 = call i64 @__mruntime_rt_ctl_resid__tget(i64 3)
%t5151 = call i64 @sb_word(i64 %t5131, i64 %t5150)
%t5152 = add i64 %t5149, %t5151
%t5154 = ptrtoint ptr @.s5153 to i64
%t5155 = call i64 @sb_lit(i64 %t5131, i64 %t5154)
%t5156 = add i64 %t5152, %t5155
%t5158 = ptrtoint ptr @.s5157 to i64
%t5159 = call i64 @__mruntime_rt_ctl_resid__sb_ms(i64 %t5131, double %t5130, i64 %t5158)
%t5160 = add i64 %t5156, %t5159
%t5162 = ptrtoint ptr @.s5161 to i64
%t5163 = call i64 @sb_lit(i64 %t5131, i64 %t5162)
%t5164 = add i64 %t5160, %t5163
br label %L1668
L1667:
br label %L1668
L1668:
%t5165 = phi i64 [ %t5164, %L1666 ], [ 0, %L1667 ]
%t5166 = icmp eq i64 %t5128, 0
br i1 %t5166, label %L1669, label %L1670
L1669:
%t5167 = call i64 @__mruntime_rt_ctl_resid__summary_pretty(i64 %t5131, double %t5130)
br label %L1671
L1670:
br label %L1671
L1671:
%t5168 = phi i64 [ %t5167, %L1669 ], [ 0, %L1670 ]
%t5169 = call i64 @__mruntime_rt_ctl_resid__out_sb(i64 %t5131)
%t5170 = call i64 @__mruntime_rt_ctl_resid__tget(i64 2)
%t5171 = icmp ne i64 %t5170, 0
br i1 %t5171, label %L1672, label %L1673
L1672:
br label %L1674
L1673:
br label %L1674
L1674:
%t5172 = phi i64 [ 1, %L1672 ], [ 0, %L1673 ]
ret i64 %t5172
}
define i64 @resid_test_summary() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_test_summary()
ret i64 %r
}
define internal i64 @__mruntime_rt_ctl_resid__summary_pretty(i64 %p0, double %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5174 = ptrtoint ptr @.s5173 to i64
%t5175 = call i64 @sb_lit(i64 %p0, i64 %t5174)
%t5176 = call i64 @__mruntime_rt_ctl_resid__tget(i64 2)
%t5177 = call i64 @sb_word(i64 %p0, i64 %t5176)
%t5178 = add i64 %t5175, %t5177
%t5180 = ptrtoint ptr @.s5179 to i64
%t5181 = call i64 @sb_lit(i64 %p0, i64 %t5180)
%t5182 = add i64 %t5178, %t5181
%t5183 = call i64 @__mruntime_rt_ctl_resid__tget(i64 1)
%t5184 = call i64 @sb_word(i64 %p0, i64 %t5183)
%t5185 = add i64 %t5182, %t5184
%t5186 = call i64 @__mruntime_rt_ctl_resid__tget(i64 3)
%t5187 = icmp ne i64 %t5186, 0
br i1 %t5187, label %L1675, label %L1676
L1675:
%t5189 = ptrtoint ptr @.s5188 to i64
%t5190 = call i64 @sb_lit(i64 %p0, i64 %t5189)
%t5191 = call i64 @__mruntime_rt_ctl_resid__tget(i64 3)
%t5192 = call i64 @sb_word(i64 %p0, i64 %t5191)
%t5193 = add i64 %t5190, %t5192
br label %L1677
L1676:
br label %L1677
L1677:
%t5194 = phi i64 [ %t5193, %L1675 ], [ 0, %L1676 ]
%t5196 = ptrtoint ptr @.s5195 to i64
%t5197 = call i64 @sb_lit(i64 %p0, i64 %t5196)
%t5199 = ptrtoint ptr @.s5198 to i64
%t5200 = call i64 @__mruntime_rt_ctl_resid__sb_ms(i64 %p0, double %p1, i64 %t5199)
%t5201 = add i64 %t5197, %t5200
%t5203 = ptrtoint ptr @.s5202 to i64
%t5204 = call i64 @sb_lit(i64 %p0, i64 %t5203)
%t5205 = add i64 %t5201, %t5204
ret i64 %t5205
}
define internal i64 @__mruntime_rt_dec_resid__bb() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5206 = trunc i128 10000000000000000000 to i64
ret i64 %t5206
}
define internal i64 @__mruntime_rt_dec_resid__binv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5207 = trunc i128 15581492618384294730 to i64
ret i64 %t5207
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
%t5208 = icmp eq i64 %p0, 19
br i1 %t5208, label %L1678, label %L1680
L1678:
%t5209 = call i64 @__mruntime_rt_dec_resid__bb()
ret i64 %t5209
L1680:
%t5210 = ptrtoint ptr @rtt.25346 to i64
%t5211 = mul i64 %p0, 8
%t5212 = add i64 %t5210, %t5211
%t5213 = call i64 @ld64(i64 %t5212)
%t5214 = add i64 %t5213, 0
%t5215 = add i64 %t5214, 0
ret i64 %t5215
}
define internal i64 @__mruntime_rt_dec_resid__lu(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5221 = call i64 @ld64(i64 %p0)
%t5222 = add i64 %t5221, 0
%t5223 = add i64 %t5222, 0
ret i64 %t5223
}
define internal i64 @__mruntime_rt_dec_resid__su(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5229 = add i64 %p1, 0
%t5230 = add i64 %t5229, 0
%t5236 = tail call i64 @st64(i64 %p0, i64 %t5230)
ret i64 %t5236
}
define internal i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5237 = mul i64 %p1, 8
%t5238 = add i64 %p0, %t5237
ret i64 %t5238
}
define internal i64 @sx8(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5239 = shl i64 %p0, 56
%t5240 = ashr i64 %t5239, 56
ret i64 %t5240
}
define internal i64 @__mruntime_rt_dec_resid__dsign(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5241 = call i64 @ld8(i64 %p0)
%t5242 = tail call i64 @sx8(i64 %t5241)
ret i64 %t5242
}
define internal i64 @__mruntime_rt_dec_resid__dprec(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5243 = add i64 %p0, 4
%t5244 = tail call i64 @ld32(i64 %t5243)
ret i64 %t5244
}
define internal i64 @__mruntime_rt_dec_resid__dexp(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5245 = add i64 %p0, 8
%t5246 = call i64 @ld32(i64 %t5245)
%t5247 = tail call i64 @sx32(i64 %t5246)
ret i64 %t5247
}
define internal i64 @dn(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5248 = add i64 %p0, 12
%t5249 = tail call i64 @ld32(i64 %t5248)
ret i64 %t5249
}
define internal i64 @__mruntime_rt_dec_resid__dnd(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5250 = add i64 %p0, 16
%t5251 = tail call i64 @ld32(i64 %t5250)
ret i64 %t5251
}
define internal i64 @__mruntime_rt_dec_resid__dl(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5252 = add i64 %p0, 24
ret i64 %t5252
}
define internal i64 @__mruntime_rt_dec_resid__r2() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5253p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dec_r2)
%t5253 = ptrtoint ptr %t5253p to i64
ret i64 %t5253
}
define internal i64 @__mruntime_rt_dec_resid__div_b(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5254 = sext i64 64 to i128
%t5255 = add i128 %t5254, 0
%t5261 = icmp uge i128 %t5255, 128
%t5262 = add i128 %t5255, 0
%t5263 = lshr i128 %p0, %t5262
%t5264 = select i1 %t5261, i128 0, i128 %t5263
%t5265 = add i128 %t5264, 0
%t5266 = trunc i128 %t5265 to i64
%t5272 = add i128 %p0, 0
%t5273 = trunc i128 %t5272 to i64
%t5279 = call i64 @__mruntime_rt_dec_resid__binv()
%t5280 = zext i64 %t5279 to i128
%t5281 = zext i64 %t5266 to i128
%t5282 = mul i128 %t5280, %t5281
%t5283 = add i128 %t5282, %p0
%t5284 = sext i64 64 to i128
%t5285 = add i128 %t5284, 0
%t5291 = icmp uge i128 %t5285, 128
%t5292 = add i128 %t5285, 0
%t5293 = lshr i128 %t5283, %t5292
%t5294 = select i1 %t5291, i128 0, i128 %t5293
%t5295 = add i128 %t5294, 0
%t5296 = trunc i128 %t5295 to i64
%t5302 = add i64 1, 0
%t5303 = add i64 %t5302, 0
%t5309 = add i64 %t5296, %t5303
%t5310 = add i128 %t5283, 0
%t5311 = trunc i128 %t5310 to i64
%t5317 = call i64 @__mruntime_rt_dec_resid__bb()
%t5318 = mul i64 %t5309, %t5317
%t5319 = sub i64 %t5273, %t5318
%t5320 = icmp ugt i64 %t5319, %t5311
br i1 %t5320, label %L1681, label %L1682
L1681:
%t5321 = add i64 1, 0
%t5322 = add i64 %t5321, 0
%t5328 = sub i64 %t5309, %t5322
br label %L1683
L1682:
br label %L1683
L1683:
%t5329 = phi i64 [ %t5328, %L1681 ], [ %t5309, %L1682 ]
br i1 %t5320, label %L1684, label %L1685
L1684:
%t5330 = call i64 @__mruntime_rt_dec_resid__bb()
%t5331 = add i64 %t5319, %t5330
br label %L1686
L1685:
br label %L1686
L1686:
%t5332 = phi i64 [ %t5331, %L1684 ], [ %t5319, %L1685 ]
%t5333 = call i64 @__mruntime_rt_dec_resid__bb()
%t5334 = icmp uge i64 %t5332, %t5333
br i1 %t5334, label %L1687, label %L1688
L1687:
%t5335 = add i64 1, 0
%t5336 = add i64 %t5335, 0
%t5342 = add i64 %t5329, %t5336
br label %L1689
L1688:
br label %L1689
L1689:
%t5343 = phi i64 [ %t5342, %L1687 ], [ %t5329, %L1688 ]
ret i64 %t5343
}
define internal i64 @__mruntime_rt_dec_resid__ndig64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5344 = call i64 @__mruntime_rt_dec_resid__ndig64_at(i64 %p0, i64 1)
ret i64 %t5344
}
define internal i64 @__mruntime_rt_dec_resid__ndig64_at(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5350, %tco.s0 ]
%t5345 = icmp slt i64 %p1, 20
br label %LSL5346
LSL5346:
br i1 %t5345, label %LSR5346, label %LSJ5346
LSR5346:
%t5347 = call i64 @__mruntime_rt_dec_resid__p10(i64 %p1)
%t5348 = icmp uge i64 %p0, %t5347
br label %LSJ5346
LSJ5346:
%t5349 = phi i1 [ false, %LSL5346 ], [ %t5348, %LSR5346 ]
br i1 %t5349, label %L1690, label %L1692
L1690:
%t5350 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L1692:
ret i64 %p1
}
define internal i64 @__mruntime_rt_dec_resid__ndig(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5352 = icmp eq i64 %p1, 0
br i1 %t5352, label %L1693, label %L1695
L1693:
ret i64 0
L1695:
%t5353 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5354 = sub i64 %p1, 1
%t5355 = mul i64 %t5353, %t5354
%t5356 = sub i64 %p1, 1
%t5357 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t5356)
%t5358 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5357)
%t5359 = call i64 @__mruntime_rt_dec_resid__ndig64(i64 %t5358)
%t5360 = add i64 %t5355, %t5359
ret i64 %t5360
}
define internal i64 @__mruntime_rt_dec_resid__tmp_limbs(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5361 = icmp sgt i64 %p0, 0
br i1 %t5361, label %L1696, label %L1697
L1696:
%t5362 = mul i64 %p0, 8
br label %L1698
L1697:
br label %L1698
L1698:
%t5363 = phi i64 [ %t5362, %L1696 ], [ 8, %L1697 ]
%t5364 = tail call i64 @xmalloc(i64 %t5363)
ret i64 %t5364
}
define internal i64 @__mruntime_rt_dec_resid__dalloc(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5365 = icmp slt i64 %p0, 0
br label %LSL5366
LSL5366:
br i1 %t5365, label %LSJ5366, label %LSR5366
LSR5366:
%t5367 = icmp sgt i64 %p0, 1099511627776
br label %LSJ5366
LSJ5366:
%t5368 = phi i1 [ true, %LSL5366 ], [ %t5367, %LSR5366 ]
br i1 %t5368, label %L1699, label %L1701
L1699:
%t5370 = call i64 @rt_abort(ptr @.s5369)
ret i64 %t5370
L1701:
%t5371 = mul nsw i64 %p0, 8
%t5372 = add nsw i64 24, %t5371
%t5373 = tail call i64 @c_gmalloc(i64 %t5372)
ret i64 %t5373
}
define internal i64 @__mruntime_rt_dec_resid__dzero(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5374 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 0)
%t5375 = call i64 @st8(i64 %t5374, i64 0)
%t5376 = add i64 %t5374, 4
%t5377 = call i64 @st32(i64 %t5376, i64 %p0)
%t5378 = add i64 %t5374, 8
%t5379 = call i64 @st32(i64 %t5378, i64 0)
%t5380 = add i64 %t5374, 12
%t5381 = call i64 @st32(i64 %t5380, i64 0)
%t5382 = add i64 %t5374, 16
%t5383 = call i64 @st32(i64 %t5382, i64 0)
%t5384 = mul nsw i64 %t5383, 0
%t5385 = add nsw i64 %t5384, %t5374
ret i64 %t5385
}
define internal i64 @__mruntime_rt_dec_resid__top(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5400, %tco.s0 ]
%t5386 = icmp sgt i64 %p1, 0
br label %LSL5387
LSL5387:
br i1 %t5386, label %LSR5387, label %LSJ5387
LSR5387:
%t5388 = sub nsw i64 %p1, 1
%t5389 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t5388)
%t5390 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5389)
%t5391 = add i64 0, 0
%t5392 = add i64 %t5391, 0
%t5398 = icmp eq i64 %t5390, %t5392
br label %LSJ5387
LSJ5387:
%t5399 = phi i1 [ false, %LSL5387 ], [ %t5398, %LSR5387 ]
br i1 %t5399, label %L1702, label %L1704
L1702:
%t5400 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L1704:
ret i64 %p1
}
define internal i64 @__mruntime_rt_dec_resid__set_hdr(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5402 = call i64 @st8(i64 %p0, i64 %p1)
%t5403 = add i64 %p0, 4
%t5404 = call i64 @st32(i64 %t5403, i64 %p2)
%t5405 = add i64 %p0, 8
%t5406 = call i64 @st32(i64 %t5405, i64 %p3)
%t5407 = add i64 %p0, 12
%t5408 = call i64 @st32(i64 %t5407, i64 %p4)
%t5409 = add i64 %p0, 16
%t5410 = call i64 @st32(i64 %t5409, i64 %p5)
%t5411 = mul nsw i64 %t5410, 0
%t5412 = add nsw i64 %t5411, %p0
ret i64 %t5412
}
define internal i64 @__mruntime_rt_dec_resid__finish(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5413 = icmp slt i64 %p4, 1
br label %LSL5414
LSL5414:
br i1 %t5413, label %LSJ5414, label %LSR5414
LSR5414:
%t5415 = icmp sgt i64 %p4, 1073741823
br label %LSJ5414
LSJ5414:
%t5416 = phi i1 [ true, %LSL5414 ], [ %t5415, %LSR5414 ]
br i1 %t5416, label %L1705, label %L1707
L1705:
%t5418 = call i64 @rt_abort(ptr @.s5417)
ret i64 %t5418
L1707:
%t5419 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t5420 = call i64 @__mruntime_rt_dec_resid__top(i64 %t5419, i64 %p2)
%t5421 = icmp eq i64 %t5420, 0
br label %LSL5422
LSL5422:
br i1 %t5421, label %LSJ5422, label %LSR5422
LSR5422:
%t5423 = icmp eq i64 %p1, 0
br label %LSJ5422
LSJ5422:
%t5424 = phi i1 [ true, %LSL5422 ], [ %t5423, %LSR5422 ]
br i1 %t5424, label %L1708, label %L1710
L1708:
%t5425 = call i64 @__mruntime_rt_dec_resid__set_hdr(i64 %p0, i64 0, i64 %p4, i64 0, i64 0, i64 0)
ret i64 %t5425
L1710:
%t5426 = call i64 @__mruntime_rt_dec_resid__ndig(i64 %t5419, i64 %t5420)
%t5427 = icmp sle i64 %t5426, %p4
br i1 %t5427, label %L1711, label %L1713
L1711:
%t5428 = call i64 @__mruntime_rt_dec_resid__finish_hdr(i64 %p0, i64 %p1, i64 %t5420, i64 %p3, i64 %t5426, i64 %p4)
ret i64 %t5428
L1713:
%t5429 = sub nsw i64 %t5426, %p4
%t5430 = sub nsw i64 %t5429, 1
%t5431 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5432 = icmp eq i64 %t5431, 0
%t5433 = zext i1 %t5432 to i8
call void @resid_div_check(i8 %t5433)
%t5434 = icmp eq i64 %t5431, -1
%t5435 = icmp eq i64 %t5430, -9223372036854775808
%t5436 = and i1 %t5434, %t5435
%t5439 = zext i1 %t5436 to i8
call void @resid_overflow_check(i8 %t5439)
%t5437 = add i64 %t5431, 0
%t5438 = sdiv i64 %t5430, %t5437
%t5440 = call i64 @__mruntime_rt_dec_resid__li(i64 %t5419, i64 %t5438)
%t5441 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5440)
%t5442 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5443 = icmp eq i64 %t5442, 0
%t5444 = zext i1 %t5443 to i8
call void @resid_div_check(i8 %t5444)
%t5445 = icmp eq i64 %t5442, -1
%t5446 = icmp eq i64 %t5430, -9223372036854775808
%t5447 = and i1 %t5445, %t5446
%t5448 = select i1 %t5445, i64 1, i64 %t5442
%t5449 = srem i64 %t5430, %t5448
%t5451 = call i64 @__mruntime_rt_dec_resid__p10(i64 %t5449)
%t5452 = icmp eq i64 %t5451, 0
%t5453 = zext i1 %t5452 to i8
call void @resid_div_check(i8 %t5453)
%t5458 = udiv i64 %t5441, %t5451
%t5459 = add i64 10, 0
%t5460 = add i64 %t5459, 0
%t5466 = icmp eq i64 %t5460, 0
%t5467 = zext i1 %t5466 to i8
call void @resid_div_check(i8 %t5467)
%t5472 = urem i64 %t5458, %t5460
%t5473 = add i64 5, 0
%t5474 = add i64 %t5473, 0
%t5480 = icmp uge i64 %t5472, %t5474
%t5481 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5482 = icmp eq i64 %t5481, 0
%t5483 = zext i1 %t5482 to i8
call void @resid_div_check(i8 %t5483)
%t5484 = icmp eq i64 %t5481, -1
%t5485 = icmp eq i64 %t5429, -9223372036854775808
%t5486 = and i1 %t5484, %t5485
%t5489 = zext i1 %t5486 to i8
call void @resid_overflow_check(i8 %t5489)
%t5487 = add i64 %t5481, 0
%t5488 = sdiv i64 %t5429, %t5487
%t5490 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5491 = icmp eq i64 %t5490, 0
%t5492 = zext i1 %t5491 to i8
call void @resid_div_check(i8 %t5492)
%t5493 = icmp eq i64 %t5490, -1
%t5494 = icmp eq i64 %t5429, -9223372036854775808
%t5495 = and i1 %t5493, %t5494
%t5496 = select i1 %t5493, i64 1, i64 %t5490
%t5497 = srem i64 %t5429, %t5496
%t5499 = sub i64 %t5420, %t5488
%t5500 = icmp eq i64 %t5497, 0
br i1 %t5500, label %L1714, label %L1715
L1714:
%t5501 = call i64 @__mruntime_rt_dec_resid__li(i64 %t5419, i64 %t5488)
%t5502 = mul i64 %t5499, 8
%t5503 = call i64 @mcopy(i64 %t5419, i64 %t5501, i64 %t5502)
br label %L1716
L1715:
%t5504 = call i64 @__mruntime_rt_dec_resid__p10(i64 %t5497)
%t5505 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5506 = sub i64 %t5505, %t5497
%t5507 = call i64 @__mruntime_rt_dec_resid__p10(i64 %t5506)
%t5508 = call i64 @__mruntime_rt_dec_resid__shift_down(i64 %t5419, i64 %t5420, i64 %t5488, i64 %t5504, i64 %t5507, i64 0, i64 %t5499)
br label %L1716
L1716:
%t5509 = phi i64 [ %t5503, %L1714 ], [ %t5508, %L1715 ]
%t5510 = call i64 @__mruntime_rt_dec_resid__top(i64 %t5419, i64 %t5499)
%t5511 = add i64 %p3, %t5429
br i1 %t5480, label %L1717, label %L1718
L1717:
%t5512 = call i64 @__mruntime_rt_dec_resid__round_up(i64 %t5419, i64 0, i64 %t5510)
br label %L1719
L1718:
br label %L1719
L1719:
%t5513 = phi i64 [ %t5512, %L1717 ], [ %t5510, %L1718 ]
%t5514 = call i64 @__mruntime_rt_dec_resid__ndig(i64 %t5419, i64 %t5513)
%t5515 = icmp sgt i64 %t5514, %p4
br i1 %t5515, label %L1720, label %L1722
L1720:
%t5516 = add i64 1, 0
%t5517 = add i64 %t5516, 0
%t5523 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5419, i64 %t5517)
%t5524 = add i64 %t5511, %p4
%t5525 = call i64 @__mruntime_rt_dec_resid__finish_hdr(i64 %p0, i64 %p1, i64 1, i64 %t5524, i64 1, i64 %p4)
ret i64 %t5525
L1722:
%t5526 = call i64 @__mruntime_rt_dec_resid__finish_hdr(i64 %p0, i64 %p1, i64 %t5513, i64 %t5511, i64 %t5514, i64 %p4)
ret i64 %t5526
}
define internal i64 @__mruntime_rt_dec_resid__finish_hdr(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5527 = sub i64 %p5, %p4
%t5528 = sub i64 %p3, %t5527
%t5529 = call i64 @__mruntime_rt_dec_resid__max_exp()
%t5530 = icmp sgt i64 %t5528, %t5529
br label %LSL5531
LSL5531:
br i1 %t5530, label %LSJ5531, label %LSR5531
LSR5531:
%t5532 = call i64 @__mruntime_rt_dec_resid__max_exp()
%t5533 = sub i64 0, %t5532
%t5534 = icmp slt i64 %t5528, %t5533
br label %LSJ5531
LSJ5531:
%t5535 = phi i1 [ true, %LSL5531 ], [ %t5534, %LSR5531 ]
br i1 %t5535, label %L1723, label %L1725
L1723:
%t5537 = call i64 @rt_abort(ptr @.s5536)
ret i64 %t5537
L1725:
%t5538 = icmp slt i64 %p1, 0
br i1 %t5538, label %L1726, label %L1727
L1726:
%t5539 = sub nsw i64 0, 1
br label %L1728
L1727:
br label %L1728
L1728:
%t5540 = phi i64 [ %t5539, %L1726 ], [ 1, %L1727 ]
%t5541 = tail call i64 @__mruntime_rt_dec_resid__set_hdr(i64 %p0, i64 %t5540, i64 %p5, i64 %p3, i64 %p2, i64 %p4)
ret i64 %t5541
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
%p5 = phi i64 [ %p5.in, %entry ], [ %t5579, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ]
%t5542 = icmp sge i64 %p5, %p6
br i1 %t5542, label %L1729, label %L1731
L1729:
ret i64 0
L1731:
%t5543 = add i64 %p5, %p2
%t5544 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t5543)
%t5545 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5544)
%t5546 = icmp eq i64 %p3, 0
%t5547 = zext i1 %t5546 to i8
call void @resid_div_check(i8 %t5547)
%t5552 = udiv i64 %t5545, %p3
%t5553 = add i64 %p5, %p2
%t5554 = add i64 %t5553, 1
%t5555 = icmp slt i64 %t5554, %p1
br i1 %t5555, label %L1732, label %L1733
L1732:
%t5556 = add i64 %p5, %p2
%t5557 = add i64 %t5556, 1
%t5558 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t5557)
%t5559 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5558)
%t5560 = icmp eq i64 %p3, 0
%t5561 = zext i1 %t5560 to i8
call void @resid_div_check(i8 %t5561)
%t5566 = urem i64 %t5559, %p3
%t5567 = mul i64 %t5566, %p4
br label %L1734
L1733:
%t5568 = add i64 0, 0
%t5569 = add i64 %t5568, 0
br label %L1734
L1734:
%t5575 = phi i64 [ %t5567, %L1732 ], [ %t5569, %L1733 ]
%t5576 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p5)
%t5577 = add i64 %t5552, %t5575
%t5578 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5576, i64 %t5577)
%t5579 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__round_up(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5627, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t5581 = icmp sge i64 %p1, %p2
br i1 %t5581, label %L1735, label %L1737
L1735:
%t5582 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t5583 = add i64 1, 0
%t5584 = add i64 %t5583, 0
%t5590 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5582, i64 %t5584)
%t5591 = mul nsw i64 %t5590, 0
%t5592 = add nsw i64 %t5591, %p2
%t5593 = add i64 %t5592, 1
ret i64 %t5593
L1737:
%t5594 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p1)
%t5595 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5594)
%t5596 = add i64 1, 0
%t5597 = add i64 %t5596, 0
%t5603 = add i64 %t5595, %t5597
%t5604 = call i64 @__mruntime_rt_dec_resid__bb()
%t5605 = icmp ult i64 %t5603, %t5604
br i1 %t5605, label %L1738, label %L1740
L1738:
%t5606 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p1)
%t5607 = add i64 1, 0
%t5608 = add i64 %t5607, 0
%t5614 = add i64 %t5595, %t5608
%t5615 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5606, i64 %t5614)
%t5616 = mul nsw i64 %t5615, 0
%t5617 = add nsw i64 %t5616, %p2
ret i64 %t5617
L1740:
%t5618 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p1)
%t5619 = add i64 0, 0
%t5620 = add i64 %t5619, 0
%t5626 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5618, i64 %t5620)
%t5627 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__from_limbs(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5629 = call i64 @__mruntime_rt_dec_resid__top(i64 %p1, i64 %p2)
%t5630 = icmp eq i64 %t5629, 0
br label %LSL5631
LSL5631:
br i1 %t5630, label %LSJ5631, label %LSR5631
LSR5631:
%t5632 = icmp eq i64 %p0, 0
br label %LSJ5631
LSJ5631:
%t5633 = phi i1 [ true, %LSL5631 ], [ %t5632, %LSR5631 ]
br i1 %t5633, label %L1741, label %L1743
L1741:
%t5634 = call i64 @__mruntime_rt_dec_resid__dzero(i64 %p4)
ret i64 %t5634
L1743:
%t5635 = add i64 %t5629, 1
%t5636 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 %t5635)
%t5637 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t5636)
%t5638 = mul i64 %t5629, 8
%t5639 = call i64 @mcopy(i64 %t5637, i64 %p1, i64 %t5638)
%t5640 = tail call i64 @__mruntime_rt_dec_resid__finish(i64 %t5636, i64 %p0, i64 %t5629, i64 %p3, i64 %p4)
ret i64 %t5640
}
define internal i64 @__mruntime_rt_dec_resid__mul1(i64 %p0, i64 %p1, i64 %p2, i64 %p3) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5641 = add i64 4294967296, 0
%t5642 = add i64 %t5641, 0
%t5648 = icmp ult i64 %p3, %t5642
br i1 %t5648, label %L1744, label %L1746
L1744:
%t5649 = add i64 %p3, 0
%t5650 = add i64 %t5649, 0
%t5656 = sitofp i64 %t5650 to double
%t5657 = fmul double %t5656, 2.0
%t5658 = fdiv double %t5657, 10000000000000000000.0
%t5659 = mul i64 %p2, 8
%t5660 = add i64 %p1, %t5659
%t5661 = add i64 0, 0
%t5662 = add i64 %t5661, 0
%t5668 = call i64 @__mruntime_rt_dec_resid__mul1_small(i64 %p0, i64 %p1, i64 %t5660, i64 %p3, double %t5658, i64 %t5662)
%t5669 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t5670 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5669, i64 %t5668)
%t5671 = mul nsw i64 %t5670, 0
%t5672 = add nsw i64 %t5671, %p2
%t5673 = add i64 %t5672, 1
ret i64 %t5673
L1746:
%t5674 = add i64 0, 0
%t5675 = add i64 %t5674, 0
%t5681 = call i64 @__mruntime_rt_dec_resid__mul1_big(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 %t5675)
%t5682 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t5683 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5682, i64 %t5681)
%t5684 = mul nsw i64 %t5683, 0
%t5685 = add nsw i64 %t5684, %p2
%t5686 = add i64 %t5685, 1
ret i64 %t5686
}
define internal i64 @__mruntime_rt_dec_resid__mul1_small(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, double %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t5732, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5733, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi double [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t5717, %tco.s0 ]
%t5687 = icmp sge i64 %p1, %p2
br i1 %t5687, label %L1747, label %L1749
L1747:
ret i64 %p5
L1749:
%t5688 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p1)
%t5689 = add i64 1, 0
%t5690 = add i64 %t5689, 0
%t5696 = icmp uge i64 %t5690, 64
%t5697 = add i64 %t5690, 0
%t5698 = lshr i64 %t5688, %t5697
%t5699 = select i1 %t5696, i64 0, i64 %t5698
%t5700 = add i64 %t5699, 0
%t5701 = add i64 %t5700, 0
%t5707 = sitofp i64 %t5701 to double
%t5708 = fmul double %t5707, %p4
%t5709 = fsub double %t5708, 0.000030517578125
%t5715 = fptosi double %t5709 to i64
%t5716 = add i64 %t5715, 0
%t5717 = add i64 %t5716, 0
%t5723 = mul i64 %t5688, %p3
%t5724 = call i64 @__mruntime_rt_dec_resid__bb()
%t5725 = mul i64 %t5717, %t5724
%t5726 = sub i64 %t5723, %t5725
%t5727 = add i64 %t5726, %p5
%t5728 = call i64 @__mruntime_rt_dec_resid__bb()
%t5729 = icmp uge i64 %t5727, %t5728
br i1 %t5729, label %L1750, label %L1752
L1750:
%t5730 = call i64 @__mruntime_rt_dec_resid__mul1_fix(i64 %p0, i64 %p1, i64 %p2, i64 %p3, double %p4, i64 %t5727, i64 %t5717)
ret i64 %t5730
L1752:
%t5731 = call i64 @__mruntime_rt_dec_resid__su(i64 %p0, i64 %t5727)
%t5732 = add i64 %p0, 8
%t5733 = add i64 %p1, 8
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__mul1_fix(i64 %p0, i64 %p1, i64 %p2, i64 %p3, double %p4, i64 %p5, i64 %p6) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5735 = call i64 @__mruntime_rt_dec_resid__bb()
%t5736 = sub i64 %p5, %t5735
%t5737 = call i64 @__mruntime_rt_dec_resid__su(i64 %p0, i64 %t5736)
%t5738 = add i64 %p0, 8
%t5739 = add i64 %p1, 8
%t5740 = add i64 1, 0
%t5741 = add i64 %t5740, 0
%t5747 = add i64 %p6, %t5741
%t5748 = call i64 @__mruntime_rt_dec_resid__mul1_small(i64 %t5738, i64 %t5739, i64 %p2, i64 %p3, double %p4, i64 %t5747)
ret i64 %t5748
}
define internal i64 @__mruntime_rt_dec_resid__mul1_big(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t5774, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t5783, %tco.s0 ]
%t5749 = icmp sge i64 %p4, %p2
br i1 %t5749, label %L1753, label %L1755
L1753:
ret i64 %p5
L1755:
%t5750 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p4)
%t5751 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5750)
%t5752 = zext i64 %t5751 to i128
%t5753 = zext i64 %p3 to i128
%t5754 = mul i128 %t5752, %t5753
%t5755 = call i64 @__mruntime_rt_dec_resid__div_b(i128 %t5754)
%t5756 = add i128 %t5754, 0
%t5757 = trunc i128 %t5756 to i64
%t5763 = call i64 @__mruntime_rt_dec_resid__bb()
%t5764 = mul i64 %t5755, %t5763
%t5765 = sub i64 %t5757, %t5764
%t5766 = call i64 @__mruntime_rt_dec_resid__bb()
%t5767 = sub i64 %t5766, %p5
%t5768 = icmp uge i64 %t5765, %t5767
%t5769 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p4)
br i1 %t5768, label %L1756, label %L1757
L1756:
%t5770 = sub i64 %t5765, %t5767
br label %L1758
L1757:
%t5771 = add i64 %t5765, %p5
br label %L1758
L1758:
%t5772 = phi i64 [ %t5770, %L1756 ], [ %t5771, %L1757 ]
%t5773 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5769, i64 %t5772)
%t5774 = add nsw i64 %p4, 1
br i1 %t5768, label %L1759, label %L1760
L1759:
%t5775 = add i64 1, 0
%t5776 = add i64 %t5775, 0
%t5782 = add i64 %t5755, %t5776
br label %L1761
L1760:
br label %L1761
L1761:
%t5783 = phi i64 [ %t5782, %L1759 ], [ %t5755, %L1760 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__scale(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5785 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5786 = icmp eq i64 %t5785, 0
%t5787 = zext i1 %t5786 to i8
call void @resid_div_check(i8 %t5787)
%t5788 = icmp eq i64 %t5785, -1
%t5789 = icmp eq i64 %p2, -9223372036854775808
%t5790 = and i1 %t5788, %t5789
%t5793 = zext i1 %t5790 to i8
call void @resid_overflow_check(i8 %t5793)
%t5791 = add i64 %t5785, 0
%t5792 = sdiv i64 %p2, %t5791
%t5794 = call i64 @__mruntime_rt_dec_resid__ld_()
%t5795 = icmp eq i64 %t5794, 0
%t5796 = zext i1 %t5795 to i8
call void @resid_div_check(i8 %t5796)
%t5797 = icmp eq i64 %t5794, -1
%t5798 = icmp eq i64 %p2, -9223372036854775808
%t5799 = and i1 %t5797, %t5798
%t5800 = select i1 %t5797, i64 1, i64 %t5794
%t5801 = srem i64 %p2, %t5800
%t5803 = add i64 %p1, %t5792
%t5804 = add i64 %t5803, 1
%t5805 = call i64 @__mruntime_rt_dec_resid__tmp_limbs(i64 %t5804)
%t5806 = mul i64 %t5792, 8
%t5807p = inttoptr i64 %t5805 to ptr
%t5807q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t5807p, i8 %t5807q, i64 %t5806, i1 false)
%t5807 = add i64 0, 0
%t5808 = icmp eq i64 %t5801, 0
br i1 %t5808, label %L1762, label %L1763
L1762:
%t5809 = call i64 @__mruntime_rt_dec_resid__li(i64 %t5805, i64 %t5792)
%t5810 = mul i64 %p1, 8
%t5811 = call i64 @mcopy(i64 %t5809, i64 %p0, i64 %t5810)
%t5812 = add i64 %t5792, %p1
%t5813 = call i64 @__mruntime_rt_dec_resid__li(i64 %t5805, i64 %t5812)
%t5814 = add i64 0, 0
%t5815 = add i64 %t5814, 0
%t5821 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5813, i64 %t5815)
%t5822 = add i64 %t5811, %t5821
br label %L1764
L1763:
%t5823 = call i64 @__mruntime_rt_dec_resid__li(i64 %t5805, i64 %t5792)
%t5824 = call i64 @__mruntime_rt_dec_resid__p10(i64 %t5801)
%t5825 = call i64 @__mruntime_rt_dec_resid__mul1(i64 %t5823, i64 %p0, i64 %p1, i64 %t5824)
br label %L1764
L1764:
%t5826 = phi i64 [ %t5822, %L1762 ], [ %t5825, %L1763 ]
%t5827 = call i64 @__mruntime_rt_dec_resid__r2()
%t5828 = add i64 %p1, %t5792
%t5829 = add i64 %t5828, 1
%t5830 = call i64 @__mruntime_rt_dec_resid__top(i64 %t5805, i64 %t5829)
%t5831 = call i64 @st64(i64 %t5827, i64 %t5830)
ret i64 %t5805
}
define internal i64 @__mruntime_rt_dec_resid__cmp_n(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5832 = call i64 @__mruntime_rt_dec_resid__top(i64 %p0, i64 %p1)
%t5833 = call i64 @__mruntime_rt_dec_resid__top(i64 %p2, i64 %p3)
%t5834 = icmp ne i64 %t5832, %t5833
br i1 %t5834, label %L1765, label %L1767
L1765:
%t5835 = icmp sgt i64 %t5832, %t5833
br i1 %t5835, label %L1768, label %L1769
L1768:
br label %L1770
L1769:
%t5836 = sub nsw i64 0, 1
br label %L1770
L1770:
%t5837 = phi i64 [ 1, %L1768 ], [ %t5836, %L1769 ]
ret i64 %t5837
L1767:
%t5838 = sub i64 %t5832, 1
%t5839 = call i64 @__mruntime_rt_dec_resid__cmp_from(i64 %p0, i64 %p2, i64 %t5838)
ret i64 %t5839
}
define internal i64 @__mruntime_rt_dec_resid__cmp_from(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5849, %tco.s0 ]
%t5840 = icmp slt i64 %p2, 0
br i1 %t5840, label %L1771, label %L1773
L1771:
ret i64 0
L1773:
%t5841 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t5842 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5841)
%t5843 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p2)
%t5844 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5843)
%t5845 = icmp ne i64 %t5842, %t5844
br i1 %t5845, label %L1774, label %L1776
L1774:
%t5846 = icmp ugt i64 %t5842, %t5844
br i1 %t5846, label %L1777, label %L1778
L1777:
br label %L1779
L1778:
%t5847 = sub nsw i64 0, 1
br label %L1779
L1779:
%t5848 = phi i64 [ 1, %L1777 ], [ %t5847, %L1778 ]
ret i64 %t5848
L1776:
%t5849 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__cmp_mag(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5851 = add i64 %p3, %p2
%t5852 = add i64 %p7, %p6
%t5853 = icmp ne i64 %t5851, %t5852
br i1 %t5853, label %L1780, label %L1782
L1780:
%t5854 = icmp sgt i64 %t5851, %t5852
br i1 %t5854, label %L1783, label %L1784
L1783:
br label %L1785
L1784:
%t5855 = sub nsw i64 0, 1
br label %L1785
L1785:
%t5856 = phi i64 [ 1, %L1783 ], [ %t5855, %L1784 ]
ret i64 %t5856
L1782:
%t5857 = icmp eq i64 %p3, %p7
br i1 %t5857, label %L1786, label %L1788
L1786:
%t5858 = call i64 @__mruntime_rt_dec_resid__cmp_n(i64 %p0, i64 %p1, i64 %p4, i64 %p5)
ret i64 %t5858
L1788:
%t5859 = icmp sgt i64 %p3, %p7
br i1 %t5859, label %L1789, label %L1791
L1789:
%t5860 = sub i64 %p3, %p7
%t5861 = call i64 @__mruntime_rt_dec_resid__scale(i64 %p0, i64 %p1, i64 %t5860)
%t5862 = call i64 @__mruntime_rt_dec_resid__r2()
%t5863 = call i64 @ld64(i64 %t5862)
%t5864 = call i64 @__mruntime_rt_dec_resid__cmp_n(i64 %t5861, i64 %t5863, i64 %p4, i64 %p5)
%t5865 = call i64 @c_free(i64 %t5861)
%t5866 = mul nsw i64 %t5865, 0
%t5867 = add nsw i64 %t5866, %t5864
ret i64 %t5867
L1791:
%t5868 = sub i64 %p7, %p3
%t5869 = call i64 @__mruntime_rt_dec_resid__scale(i64 %p4, i64 %p5, i64 %t5868)
%t5870 = call i64 @__mruntime_rt_dec_resid__r2()
%t5871 = call i64 @ld64(i64 %t5870)
%t5872 = call i64 @__mruntime_rt_dec_resid__cmp_n(i64 %p0, i64 %p1, i64 %t5869, i64 %t5871)
%t5873 = call i64 @c_free(i64 %t5869)
%t5874 = mul nsw i64 %t5873, 0
%t5875 = add nsw i64 %t5874, %t5872
ret i64 %t5875
}
define internal i64 @__mruntime_rt_dec_resid__add_n(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t5876 = mul i64 %p4, 8
%t5877 = add i64 %p3, %t5876
%t5878 = add i64 0, 0
%t5879 = add i64 %t5878, 0
%t5885 = call i64 @__mruntime_rt_dec_resid__add_lo(i64 %p0, i64 %p1, i64 %p3, i64 %t5877, i64 %t5879)
%t5886 = call i64 @__mruntime_rt_dec_resid__add_carry(i64 %p0, i64 %p1, i64 %p4, i64 %p2, i64 %t5885)
%t5887 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t5888 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5887, i64 %t5886)
%t5889 = mul nsw i64 %t5888, 0
%t5890 = add nsw i64 %t5889, %p2
%t5891 = add i64 %t5890, 1
ret i64 %t5891
}
define internal i64 @__mruntime_rt_dec_resid__add_lo(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t5932, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5933, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5934, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t5949, %tco.s0 ]
%t5892 = add i64 %p2, 8
%t5893 = icmp slt i64 %t5892, %p3
br i1 %t5893, label %L1792, label %L1794
L1792:
%t5894 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p2)
%t5895 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p1)
%t5896 = add i64 %t5895, %p4
%t5897 = call i64 @__mruntime_rt_dec_resid__bb()
%t5898 = sub i64 %t5897, %t5894
%t5899 = icmp uge i64 %t5896, %t5898
br i1 %t5899, label %L1795, label %L1796
L1795:
%t5900 = sub i64 %t5896, %t5898
br label %L1797
L1796:
%t5901 = add i64 %t5896, %t5894
br label %L1797
L1797:
%t5902 = phi i64 [ %t5900, %L1795 ], [ %t5901, %L1796 ]
%t5903 = call i64 @__mruntime_rt_dec_resid__su(i64 %p0, i64 %t5902)
%t5904 = add i64 %p2, 8
%t5905 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5904)
%t5906 = add i64 %p1, 8
%t5907 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5906)
br i1 %t5899, label %L1798, label %L1799
L1798:
%t5908 = add i64 1, 0
%t5909 = add i64 %t5908, 0
br label %L1800
L1799:
%t5915 = add i64 0, 0
%t5916 = add i64 %t5915, 0
br label %L1800
L1800:
%t5922 = phi i64 [ %t5909, %L1798 ], [ %t5916, %L1799 ]
%t5923 = add i64 %t5907, %t5922
%t5924 = call i64 @__mruntime_rt_dec_resid__bb()
%t5925 = sub i64 %t5924, %t5905
%t5926 = icmp uge i64 %t5923, %t5925
%t5927 = add i64 %p0, 8
br i1 %t5926, label %L1801, label %L1802
L1801:
%t5928 = sub i64 %t5923, %t5925
br label %L1803
L1802:
%t5929 = add i64 %t5923, %t5905
br label %L1803
L1803:
%t5930 = phi i64 [ %t5928, %L1801 ], [ %t5929, %L1802 ]
%t5931 = call i64 @__mruntime_rt_dec_resid__su(i64 %t5927, i64 %t5930)
%t5932 = add i64 %p0, 16
%t5933 = add i64 %p1, 16
%t5934 = add i64 %p2, 16
br i1 %t5926, label %L1804, label %L1805
L1804:
%t5935 = add i64 1, 0
%t5936 = add i64 %t5935, 0
br label %L1806
L1805:
%t5942 = add i64 0, 0
%t5943 = add i64 %t5942, 0
br label %L1806
L1806:
%t5949 = phi i64 [ %t5936, %L1804 ], [ %t5943, %L1805 ]
br label %tco.s0
tco.s0:
br label %tco.head
L1794:
%t5951 = icmp sge i64 %p2, %p3
br i1 %t5951, label %L1807, label %L1809
L1807:
ret i64 %p4
L1809:
%t5952 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p2)
%t5953 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p1)
%t5954 = add i64 %t5953, %p4
%t5955 = call i64 @__mruntime_rt_dec_resid__bb()
%t5956 = sub i64 %t5955, %t5952
%t5957 = icmp uge i64 %t5954, %t5956
br i1 %t5957, label %L1810, label %L1811
L1810:
%t5958 = sub i64 %t5954, %t5956
br label %L1812
L1811:
%t5959 = add i64 %t5954, %t5952
br label %L1812
L1812:
%t5960 = phi i64 [ %t5958, %L1810 ], [ %t5959, %L1811 ]
%t5961 = call i64 @__mruntime_rt_dec_resid__su(i64 %p0, i64 %t5960)
br i1 %t5957, label %L1813, label %L1814
L1813:
%t5962 = add i64 1, 0
%t5963 = add i64 %t5962, 0
br label %L1815
L1814:
%t5969 = add i64 0, 0
%t5970 = add i64 %t5969, 0
br label %L1815
L1815:
%t5976 = phi i64 [ %t5963, %L1813 ], [ %t5970, %L1814 ]
ret i64 %t5976
}
define internal i64 @__mruntime_rt_dec_resid__add_carry(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6015, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t6030, %tco.s0 ]
%t5977 = icmp sge i64 %p2, %p3
br i1 %t5977, label %L1816, label %L1818
L1816:
ret i64 %p4
L1818:
%t5978 = add i64 0, 0
%t5979 = add i64 %t5978, 0
%t5985 = icmp eq i64 %p4, %t5979
br i1 %t5985, label %L1819, label %L1821
L1819:
%t5986 = icmp ne i64 %p0, %p1
br i1 %t5986, label %L1822, label %L1823
L1822:
%t5987 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t5988 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p2)
%t5989 = sub i64 %p3, %p2
%t5990 = mul i64 %t5989, 8
%t5991 = call i64 @mcopy(i64 %t5987, i64 %t5988, i64 %t5990)
br label %L1824
L1823:
br label %L1824
L1824:
%t5992 = phi i64 [ %t5991, %L1822 ], [ 0, %L1823 ]
ret i64 %p4
L1821:
%t5993 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p2)
%t5994 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t5993)
%t5995 = add i64 1, 0
%t5996 = add i64 %t5995, 0
%t6002 = add i64 %t5994, %t5996
%t6003 = call i64 @__mruntime_rt_dec_resid__bb()
%t6004 = icmp eq i64 %t6002, %t6003
%t6005 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
br i1 %t6004, label %L1825, label %L1826
L1825:
%t6006 = add i64 0, 0
%t6007 = add i64 %t6006, 0
br label %L1827
L1826:
br label %L1827
L1827:
%t6013 = phi i64 [ %t6007, %L1825 ], [ %t6002, %L1826 ]
%t6014 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6005, i64 %t6013)
%t6015 = add nsw i64 %p2, 1
br i1 %t6004, label %L1828, label %L1829
L1828:
%t6016 = add i64 1, 0
%t6017 = add i64 %t6016, 0
br label %L1830
L1829:
%t6023 = add i64 0, 0
%t6024 = add i64 %t6023, 0
br label %L1830
L1830:
%t6030 = phi i64 [ %t6017, %L1828 ], [ %t6024, %L1829 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__sub_n(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6032 = mul i64 %p4, 8
%t6033 = add i64 %p3, %t6032
%t6034 = add i64 0, 0
%t6035 = add i64 %t6034, 0
%t6041 = call i64 @__mruntime_rt_dec_resid__sub_lo(i64 %p0, i64 %p1, i64 %p3, i64 %t6033, i64 %t6035)
%t6042 = call i64 @__mruntime_rt_dec_resid__sub_borrow(i64 %p0, i64 %p1, i64 %p4, i64 %p2, i64 %t6041)
ret i64 %p2
}
define internal i64 @__mruntime_rt_dec_resid__sub_lo(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t6083, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6084, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6085, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t6100, %tco.s0 ]
%t6043 = add i64 %p2, 8
%t6044 = icmp slt i64 %t6043, %p3
br i1 %t6044, label %L1831, label %L1833
L1831:
%t6045 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p1)
%t6046 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p2)
%t6047 = add i64 %t6046, %p4
%t6048 = icmp ult i64 %t6045, %t6047
br i1 %t6048, label %L1834, label %L1835
L1834:
%t6049 = call i64 @__mruntime_rt_dec_resid__bb()
%t6050 = sub i64 %t6049, %t6047
%t6051 = add i64 %t6045, %t6050
br label %L1836
L1835:
%t6052 = sub i64 %t6045, %t6047
br label %L1836
L1836:
%t6053 = phi i64 [ %t6051, %L1834 ], [ %t6052, %L1835 ]
%t6054 = call i64 @__mruntime_rt_dec_resid__su(i64 %p0, i64 %t6053)
%t6055 = add i64 %p1, 8
%t6056 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6055)
%t6057 = add i64 %p2, 8
%t6058 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6057)
br i1 %t6048, label %L1837, label %L1838
L1837:
%t6059 = add i64 1, 0
%t6060 = add i64 %t6059, 0
br label %L1839
L1838:
%t6066 = add i64 0, 0
%t6067 = add i64 %t6066, 0
br label %L1839
L1839:
%t6073 = phi i64 [ %t6060, %L1837 ], [ %t6067, %L1838 ]
%t6074 = add i64 %t6058, %t6073
%t6075 = icmp ult i64 %t6056, %t6074
%t6076 = add i64 %p0, 8
br i1 %t6075, label %L1840, label %L1841
L1840:
%t6077 = call i64 @__mruntime_rt_dec_resid__bb()
%t6078 = sub i64 %t6077, %t6074
%t6079 = add i64 %t6056, %t6078
br label %L1842
L1841:
%t6080 = sub i64 %t6056, %t6074
br label %L1842
L1842:
%t6081 = phi i64 [ %t6079, %L1840 ], [ %t6080, %L1841 ]
%t6082 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6076, i64 %t6081)
%t6083 = add i64 %p0, 16
%t6084 = add i64 %p1, 16
%t6085 = add i64 %p2, 16
br i1 %t6075, label %L1843, label %L1844
L1843:
%t6086 = add i64 1, 0
%t6087 = add i64 %t6086, 0
br label %L1845
L1844:
%t6093 = add i64 0, 0
%t6094 = add i64 %t6093, 0
br label %L1845
L1845:
%t6100 = phi i64 [ %t6087, %L1843 ], [ %t6094, %L1844 ]
br label %tco.s0
tco.s0:
br label %tco.head
L1833:
%t6102 = icmp sge i64 %p2, %p3
br i1 %t6102, label %L1846, label %L1848
L1846:
ret i64 %p4
L1848:
%t6103 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p1)
%t6104 = call i64 @__mruntime_rt_dec_resid__lu(i64 %p2)
%t6105 = add i64 %t6104, %p4
%t6106 = icmp ult i64 %t6103, %t6105
br i1 %t6106, label %L1849, label %L1850
L1849:
%t6107 = call i64 @__mruntime_rt_dec_resid__bb()
%t6108 = sub i64 %t6107, %t6105
%t6109 = add i64 %t6103, %t6108
br label %L1851
L1850:
%t6110 = sub i64 %t6103, %t6105
br label %L1851
L1851:
%t6111 = phi i64 [ %t6109, %L1849 ], [ %t6110, %L1850 ]
%t6112 = call i64 @__mruntime_rt_dec_resid__su(i64 %p0, i64 %t6111)
br i1 %t6106, label %L1852, label %L1853
L1852:
%t6113 = add i64 1, 0
%t6114 = add i64 %t6113, 0
br label %L1854
L1853:
%t6120 = add i64 0, 0
%t6121 = add i64 %t6120, 0
br label %L1854
L1854:
%t6127 = phi i64 [ %t6114, %L1852 ], [ %t6121, %L1853 ]
ret i64 %t6127
}
define internal i64 @__mruntime_rt_dec_resid__sub_borrow(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6174, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t6189, %tco.s0 ]
%t6128 = icmp sge i64 %p2, %p3
br i1 %t6128, label %L1855, label %L1857
L1855:
ret i64 0
L1857:
%t6129 = add i64 0, 0
%t6130 = add i64 %t6129, 0
%t6136 = icmp eq i64 %p4, %t6130
br i1 %t6136, label %L1858, label %L1860
L1858:
%t6137 = icmp ne i64 %p0, %p1
br i1 %t6137, label %L1861, label %L1862
L1861:
%t6138 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t6139 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p2)
%t6140 = sub i64 %p3, %p2
%t6141 = mul i64 %t6140, 8
%t6142 = call i64 @mcopy(i64 %t6138, i64 %t6139, i64 %t6141)
br label %L1863
L1862:
br label %L1863
L1863:
%t6143 = phi i64 [ %t6142, %L1861 ], [ 0, %L1862 ]
ret i64 %t6143
L1860:
%t6144 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p2)
%t6145 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6144)
%t6146 = add i64 0, 0
%t6147 = add i64 %t6146, 0
%t6153 = icmp eq i64 %t6145, %t6147
%t6154 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
br i1 %t6153, label %L1864, label %L1865
L1864:
%t6155 = call i64 @__mruntime_rt_dec_resid__bb()
%t6156 = add i64 1, 0
%t6157 = add i64 %t6156, 0
%t6163 = sub i64 %t6155, %t6157
br label %L1866
L1865:
%t6164 = add i64 1, 0
%t6165 = add i64 %t6164, 0
%t6171 = sub i64 %t6145, %t6165
br label %L1866
L1866:
%t6172 = phi i64 [ %t6163, %L1864 ], [ %t6171, %L1865 ]
%t6173 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6154, i64 %t6172)
%t6174 = add nsw i64 %p2, 1
br i1 %t6153, label %L1867, label %L1868
L1867:
%t6175 = add i64 1, 0
%t6176 = add i64 %t6175, 0
br label %L1869
L1868:
%t6182 = add i64 0, 0
%t6183 = add i64 %t6182, 0
br label %L1869
L1869:
%t6189 = phi i64 [ %t6176, %L1867 ], [ %t6183, %L1868 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__round_v(i64 %p0, i64 %p1, i1 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br i1 %p2, label %L1870, label %L1871
L1870:
%t6191 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6192 = sub i64 0, %t6191
br label %L1872
L1871:
%t6193 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
br label %L1872
L1872:
%t6194 = phi i64 [ %t6192, %L1870 ], [ %t6193, %L1871 ]
%t6195 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6196 = icmp eq i64 %t6195, 0
br i1 %t6196, label %L1873, label %L1875
L1873:
%t6197 = call i64 @__mruntime_rt_dec_resid__dzero(i64 %p1)
ret i64 %t6197
L1875:
%t6198 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t6199 = icmp sle i64 %t6198, %p1
br i1 %t6199, label %L1876, label %L1878
L1876:
%t6200 = call i64 @dn(i64 %p0)
%t6201 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 %t6200)
%t6202 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6201)
%t6203 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6204 = call i64 @dn(i64 %p0)
%t6205 = mul i64 %t6204, 8
%t6206 = call i64 @mcopy(i64 %t6202, i64 %t6203, i64 %t6205)
%t6207 = call i64 @dn(i64 %p0)
%t6208 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t6209 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6201, i64 %t6194, i64 %t6207, i64 %t6208, i64 %p1)
ret i64 %t6209
L1878:
%t6210 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t6211 = sub i64 %t6210, %p1
%t6212 = sub i64 %t6211, 1
%t6213 = call i64 @__mruntime_rt_dec_resid__ld_()
%t6214 = icmp eq i64 %t6213, 0
%t6215 = zext i1 %t6214 to i8
call void @resid_div_check(i8 %t6215)
%t6216 = icmp eq i64 %t6213, -1
%t6217 = icmp eq i64 %t6212, -9223372036854775808
%t6218 = and i1 %t6216, %t6217
%t6221 = zext i1 %t6218 to i8
call void @resid_overflow_check(i8 %t6221)
%t6219 = add i64 %t6213, 0
%t6220 = sdiv i64 %t6212, %t6219
%t6222 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6223 = call i64 @__mruntime_rt_dec_resid__li(i64 %t6222, i64 %t6220)
%t6224 = call i64 @dn(i64 %p0)
%t6225 = sub i64 %t6224, %t6220
%t6226 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t6227 = call i64 @__mruntime_rt_dec_resid__ld_()
%t6228 = mul i64 %t6227, %t6220
%t6229 = add i64 %t6226, %t6228
%t6230 = call i64 @__mruntime_rt_dec_resid__from_limbs(i64 %t6194, i64 %t6223, i64 %t6225, i64 %t6229, i64 %p1)
ret i64 %t6230
}
define internal i64 @__mruntime_rt_dec_resid__addsub(i64 %p0, i64 %p1, i1 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br i1 %p2, label %L1879, label %L1880
L1879:
%t6231 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t6232 = sub i64 0, %t6231
br label %L1881
L1880:
%t6233 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
br label %L1881
L1881:
%t6234 = phi i64 [ %t6232, %L1879 ], [ %t6233, %L1880 ]
%t6235 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6236 = icmp eq i64 %t6235, 0
br i1 %t6236, label %L1882, label %L1884
L1882:
%t6237 = call i64 @__mruntime_rt_dec_resid__round_v(i64 %p1, i64 %p3, i1 %p2)
ret i64 %t6237
L1884:
%t6238 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t6239 = icmp eq i64 %t6238, 0
br i1 %t6239, label %L1885, label %L1887
L1885:
%t6240 = call i64 @__mruntime_rt_dec_resid__round_v(i64 %p0, i64 %p3, i1 false)
ret i64 %t6240
L1887:
%t6241 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t6242 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p1)
%t6243 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t6244 = add i64 %t6241, %t6243
%t6245 = sub i64 %t6244, 1
%t6246 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p1)
%t6247 = add i64 %t6242, %t6246
%t6248 = sub i64 %t6247, 1
%t6249 = sub i64 %t6245, %p3
%t6250 = sub i64 %t6249, 2
%t6251 = icmp sle i64 %t6248, %t6250
br i1 %t6251, label %L1888, label %L1890
L1888:
%t6252 = call i64 @__mruntime_rt_dec_resid__round_v(i64 %p0, i64 %p3, i1 false)
ret i64 %t6252
L1890:
%t6253 = sub i64 %t6248, %p3
%t6254 = sub i64 %t6253, 2
%t6255 = icmp sle i64 %t6245, %t6254
br i1 %t6255, label %L1891, label %L1893
L1891:
%t6256 = call i64 @__mruntime_rt_dec_resid__round_v(i64 %p1, i64 %p3, i1 %p2)
ret i64 %t6256
L1893:
%t6257 = icmp slt i64 %t6241, %t6242
br i1 %t6257, label %L1894, label %L1895
L1894:
br label %L1896
L1895:
br label %L1896
L1896:
%t6258 = phi i64 [ %t6241, %L1894 ], [ %t6242, %L1895 ]
%t6259 = icmp sgt i64 %t6241, %t6258
br i1 %t6259, label %L1897, label %L1898
L1897:
%t6260 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6261 = call i64 @dn(i64 %p0)
%t6262 = sub i64 %t6241, %t6258
%t6263 = call i64 @__mruntime_rt_dec_resid__scale(i64 %t6260, i64 %t6261, i64 %t6262)
br label %L1899
L1898:
br label %L1899
L1899:
%t6264 = phi i64 [ %t6263, %L1897 ], [ 0, %L1898 ]
%t6265 = icmp sgt i64 %t6241, %t6258
br i1 %t6265, label %L1900, label %L1901
L1900:
%t6266 = call i64 @__mruntime_rt_dec_resid__r2()
%t6267 = call i64 @ld64(i64 %t6266)
br label %L1902
L1901:
%t6268 = call i64 @dn(i64 %p0)
br label %L1902
L1902:
%t6269 = phi i64 [ %t6267, %L1900 ], [ %t6268, %L1901 ]
%t6270 = icmp sgt i64 %t6242, %t6258
br i1 %t6270, label %L1903, label %L1904
L1903:
%t6271 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t6272 = call i64 @dn(i64 %p1)
%t6273 = sub i64 %t6242, %t6258
%t6274 = call i64 @__mruntime_rt_dec_resid__scale(i64 %t6271, i64 %t6272, i64 %t6273)
br label %L1905
L1904:
br label %L1905
L1905:
%t6275 = phi i64 [ %t6274, %L1903 ], [ 0, %L1904 ]
%t6276 = icmp sgt i64 %t6242, %t6258
br i1 %t6276, label %L1906, label %L1907
L1906:
%t6277 = call i64 @__mruntime_rt_dec_resid__r2()
%t6278 = call i64 @ld64(i64 %t6277)
br label %L1908
L1907:
%t6279 = call i64 @dn(i64 %p1)
br label %L1908
L1908:
%t6280 = phi i64 [ %t6278, %L1906 ], [ %t6279, %L1907 ]
%t6281 = icmp ne i64 %t6264, 0
br i1 %t6281, label %L1909, label %L1910
L1909:
br label %L1911
L1910:
%t6282 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
br label %L1911
L1911:
%t6283 = phi i64 [ %t6264, %L1909 ], [ %t6282, %L1910 ]
%t6284 = icmp ne i64 %t6275, 0
br i1 %t6284, label %L1912, label %L1913
L1912:
br label %L1914
L1913:
%t6285 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
br label %L1914
L1914:
%t6286 = phi i64 [ %t6275, %L1912 ], [ %t6285, %L1913 ]
%t6287 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6288 = call i64 @__mruntime_rt_dec_resid__addsub_n(i64 %t6287, i64 %t6234, i64 %t6283, i64 %t6269, i64 %t6286, i64 %t6280, i64 %t6258, i64 %p3)
%t6289 = call i64 @c_free(i64 %t6264)
%t6290 = call i64 @c_free(i64 %t6275)
%t6291 = add i64 %t6289, %t6290
ret i64 %t6288
}
define internal i64 @__mruntime_rt_dec_resid__addsub_n(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6292 = icmp sgt i64 %p3, %p5
br i1 %t6292, label %L1915, label %L1916
L1915:
br label %L1917
L1916:
br label %L1917
L1917:
%t6293 = phi i64 [ %p3, %L1915 ], [ %p5, %L1916 ]
%t6294 = add i64 %t6293, 1
%t6295 = icmp eq i64 %p0, %p1
br i1 %t6295, label %L1918, label %L1920
L1918:
%t6296 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 %t6294)
%t6297 = icmp sge i64 %p3, %p5
br i1 %t6297, label %L1921, label %L1922
L1921:
%t6298 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6296)
%t6299 = call i64 @__mruntime_rt_dec_resid__add_n(i64 %t6298, i64 %p2, i64 %p3, i64 %p4, i64 %p5)
br label %L1923
L1922:
%t6300 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6296)
%t6301 = call i64 @__mruntime_rt_dec_resid__add_n(i64 %t6300, i64 %p4, i64 %p5, i64 %p2, i64 %p3)
br label %L1923
L1923:
%t6302 = phi i64 [ %t6299, %L1921 ], [ %t6301, %L1922 ]
%t6303 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6296, i64 %p0, i64 %t6302, i64 %p6, i64 %p7)
ret i64 %t6303
L1920:
%t6304 = call i64 @__mruntime_rt_dec_resid__cmp_n(i64 %p2, i64 %p3, i64 %p4, i64 %p5)
%t6305 = icmp eq i64 %t6304, 0
br i1 %t6305, label %L1924, label %L1926
L1924:
%t6306 = call i64 @__mruntime_rt_dec_resid__dzero(i64 %p7)
ret i64 %t6306
L1926:
%t6307 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 %t6294)
%t6308 = icmp sgt i64 %t6304, 0
br i1 %t6308, label %L1927, label %L1929
L1927:
%t6309 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6307)
%t6310 = call i64 @__mruntime_rt_dec_resid__sub_n(i64 %t6309, i64 %p2, i64 %p3, i64 %p4, i64 %p5)
%t6311 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6307, i64 %p0, i64 %t6310, i64 %p6, i64 %p7)
ret i64 %t6311
L1929:
%t6312 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6307)
%t6313 = call i64 @__mruntime_rt_dec_resid__sub_n(i64 %t6312, i64 %p4, i64 %p5, i64 %p2, i64 %p3)
%t6314 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6307, i64 %p1, i64 %t6313, i64 %p6, i64 %p7)
ret i64 %t6314
}
define internal i64 @__mruntime_rt_dec_resid__mul_v(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6315 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6316 = icmp eq i64 %t6315, 0
br label %LSL6317
LSL6317:
br i1 %t6316, label %LSJ6317, label %LSR6317
LSR6317:
%t6318 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t6319 = icmp eq i64 %t6318, 0
br label %LSJ6317
LSJ6317:
%t6320 = phi i1 [ true, %LSL6317 ], [ %t6319, %LSR6317 ]
br i1 %t6320, label %L1930, label %L1932
L1930:
%t6321 = call i64 @__mruntime_rt_dec_resid__dzero(i64 %p2)
ret i64 %t6321
L1932:
%t6322 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6323 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t6324 = icmp eq i64 %t6322, %t6323
br i1 %t6324, label %L1933, label %L1934
L1933:
br label %L1935
L1934:
%t6325 = sub nsw i64 0, 1
br label %L1935
L1935:
%t6326 = phi i64 [ 1, %L1933 ], [ %t6325, %L1934 ]
%t6327 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t6328 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p1)
%t6329 = add i64 %t6327, %t6328
%t6330 = call i64 @dn(i64 %p0)
%t6331 = call i64 @dn(i64 %p1)
%t6332 = add i64 %t6330, %t6331
%t6333 = add i64 %t6332, 1
%t6334 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 %t6333)
%t6335 = icmp eq i64 %t6331, 1
br i1 %t6335, label %L1936, label %L1938
L1936:
%t6336 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6334)
%t6337 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6338 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t6339 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6338)
%t6340 = call i64 @__mruntime_rt_dec_resid__mul1(i64 %t6336, i64 %t6337, i64 %t6330, i64 %t6339)
%t6341 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6334, i64 %t6326, i64 %t6340, i64 %t6329, i64 %p2)
ret i64 %t6341
L1938:
%t6342 = icmp eq i64 %t6330, 1
br i1 %t6342, label %L1939, label %L1941
L1939:
%t6343 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6334)
%t6344 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t6345 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6346 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6345)
%t6347 = call i64 @__mruntime_rt_dec_resid__mul1(i64 %t6343, i64 %t6344, i64 %t6331, i64 %t6346)
%t6348 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6334, i64 %t6326, i64 %t6347, i64 %t6329, i64 %p2)
ret i64 %t6348
L1941:
%t6349 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6334)
%t6350 = add i64 %t6330, %t6331
%t6351 = mul i64 %t6350, 8
%t6352p = inttoptr i64 %t6349 to ptr
%t6352q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t6352p, i8 %t6352q, i64 %t6351, i1 false)
%t6352 = add i64 0, 0
%t6353 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6334)
%t6354 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6355 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t6356 = call i64 @__mruntime_rt_dec_resid__mul_rows(i64 %t6353, i64 %t6354, i64 %t6330, i64 %t6355, i64 %t6331, i64 0)
%t6357 = add i64 %t6330, %t6331
%t6358 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6334, i64 %t6326, i64 %t6357, i64 %t6329, i64 %p2)
ret i64 %t6358
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
%p5 = phi i64 [ %p5.in, %entry ], [ %t6373, %tco.s0 ]
%t6359 = icmp sge i64 %p5, %p2
br i1 %t6359, label %L1942, label %L1944
L1942:
ret i64 0
L1944:
%t6360 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p5)
%t6361 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6360)
%t6362 = add i64 0, 0
%t6363 = add i64 %t6362, 0
%t6369 = icmp ne i64 %t6361, %t6363
br i1 %t6369, label %L1945, label %L1946
L1945:
%t6370 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p5)
%t6371 = call i64 @__mruntime_rt_dec_resid__mul_row(i64 %t6370, i64 %t6361, i64 %p3, i64 %p4)
br label %L1947
L1946:
br label %L1947
L1947:
%t6372 = phi i64 [ %t6371, %L1945 ], [ 0, %L1946 ]
%t6373 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__mul_row(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6375 = add i64 0, 0
%t6376 = add i64 %t6375, 0
%t6382 = add i64 0, 0
%t6383 = add i64 %t6382, 0
%t6389 = call i64 @__mruntime_rt_dec_resid__mul_row_at(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 %t6376, i64 %t6383)
ret i64 %t6389
}
define internal i64 @__mruntime_rt_dec_resid__mul_row_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t6423, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t6403, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %t6438, %tco.s0 ]
%t6390 = icmp sge i64 %p4, %p3
br i1 %t6390, label %L1948, label %L1950
L1948:
%t6391 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p3)
%t6392 = add i64 %p5, %p6
%t6393 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6391, i64 %t6392)
ret i64 %t6393
L1950:
%t6394 = zext i64 %p1 to i128
%t6395 = call i64 @__mruntime_rt_dec_resid__li(i64 %p2, i64 %p4)
%t6396 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6395)
%t6397 = zext i64 %t6396 to i128
%t6398 = mul i128 %t6394, %t6397
%t6399 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p4)
%t6400 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6399)
%t6401 = zext i64 %t6400 to i128
%t6402 = add i128 %t6398, %t6401
%t6403 = call i64 @__mruntime_rt_dec_resid__div_b(i128 %t6402)
%t6404 = add i128 %t6402, 0
%t6405 = trunc i128 %t6404 to i64
%t6411 = call i64 @__mruntime_rt_dec_resid__bb()
%t6412 = mul i64 %t6403, %t6411
%t6413 = sub i64 %t6405, %t6412
%t6414 = add i64 %t6413, %p6
%t6415 = call i64 @__mruntime_rt_dec_resid__bb()
%t6416 = sub i64 %t6415, %p5
%t6417 = icmp uge i64 %t6414, %t6416
%t6418 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p4)
br i1 %t6417, label %L1951, label %L1952
L1951:
%t6419 = sub i64 %t6414, %t6416
br label %L1953
L1952:
%t6420 = add i64 %t6414, %p5
br label %L1953
L1953:
%t6421 = phi i64 [ %t6419, %L1951 ], [ %t6420, %L1952 ]
%t6422 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6418, i64 %t6421)
%t6423 = add nsw i64 %p4, 1
br i1 %t6417, label %L1954, label %L1955
L1954:
%t6424 = add i64 1, 0
%t6425 = add i64 %t6424, 0
br label %L1956
L1955:
%t6431 = add i64 0, 0
%t6432 = add i64 %t6431, 0
br label %L1956
L1956:
%t6438 = phi i64 [ %t6425, %L1954 ], [ %t6432, %L1955 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__divmod_n(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6440 = call i64 @__mruntime_rt_dec_resid__bb()
%t6441 = sub i64 %p3, 1
%t6442 = call i64 @__mruntime_rt_dec_resid__li(i64 %p2, i64 %t6441)
%t6443 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6442)
%t6444 = add i64 1, 0
%t6445 = add i64 %t6444, 0
%t6451 = add i64 %t6443, %t6445
%t6452 = icmp eq i64 %t6451, 0
%t6453 = zext i1 %t6452 to i8
call void @resid_div_check(i8 %t6453)
%t6458 = udiv i64 %t6440, %t6451
%t6459 = add i64 1, 0
%t6460 = add i64 %t6459, 0
%t6466 = icmp ugt i64 %t6458, %t6460
br i1 %t6466, label %L1957, label %L1958
L1957:
%t6467 = call i64 @__mruntime_rt_dec_resid__mul1(i64 %p0, i64 %p0, i64 %p1, i64 %t6458)
%t6468 = call i64 @__mruntime_rt_dec_resid__norm_v(i64 %p2, i64 %p3, i64 %t6458)
%t6469 = add i64 %t6467, %t6468
br label %L1959
L1958:
%t6470 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p1)
%t6471 = add i64 0, 0
%t6472 = add i64 %t6471, 0
%t6478 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6470, i64 %t6472)
br label %L1959
L1959:
%t6479 = phi i64 [ %t6469, %L1957 ], [ %t6478, %L1958 ]
%t6480 = sub i64 %p1, %p3
%t6481 = sub i64 %p3, 1
%t6482 = call i64 @__mruntime_rt_dec_resid__li(i64 %p2, i64 %t6481)
%t6483 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6482)
%t6484 = sub i64 %p3, 2
%t6485 = call i64 @__mruntime_rt_dec_resid__li(i64 %p2, i64 %t6484)
%t6486 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6485)
%t6487 = call i64 @__mruntime_rt_dec_resid__div_steps(i64 %p0, i64 %p2, i64 %p3, i64 %p4, i64 %t6480, i64 %t6483, i64 %t6486)
ret i64 %t6487
}
define internal i64 @__mruntime_rt_dec_resid__norm_v(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6488 = add i64 %p1, 1
%t6489 = call i64 @__mruntime_rt_dec_resid__tmp_limbs(i64 %t6488)
%t6490 = call i64 @__mruntime_rt_dec_resid__mul1(i64 %t6489, i64 %p0, i64 %p1, i64 %p2)
%t6491 = mul i64 %p1, 8
%t6492 = call i64 @mcopy(i64 %p0, i64 %t6489, i64 %t6491)
%t6493 = call i64 @c_free(i64 %t6489)
ret i64 %t6493
}
define internal i64 @__mruntime_rt_dec_resid__div_steps(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t6581, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ]
%t6494 = icmp slt i64 %p4, 0
br i1 %t6494, label %L1960, label %L1962
L1960:
ret i64 0
L1962:
%t6495 = add i64 %p4, %p2
%t6496 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6495)
%t6497 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6496)
%t6498 = zext i64 %t6497 to i128
%t6499 = call i64 @__mruntime_rt_dec_resid__bb()
%t6500 = zext i64 %t6499 to i128
%t6501 = mul i128 %t6498, %t6500
%t6502 = add i64 %p4, %p2
%t6503 = sub i64 %t6502, 1
%t6504 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6503)
%t6505 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6504)
%t6506 = zext i64 %t6505 to i128
%t6507 = add i128 %t6501, %t6506
%t6508 = zext i64 %p5 to i128
%t6509 = icmp eq i128 %t6508, 0
%t6510 = zext i1 %t6509 to i8
call void @resid_div_check(i8 %t6510)
%t6515 = udiv i128 %t6507, %t6508
%t6516 = zext i64 %p5 to i128
%t6517 = mul i128 %t6515, %t6516
%t6518 = sub i128 %t6507, %t6517
%t6519 = add i64 %p4, %p2
%t6520 = sub i64 %t6519, 2
%t6521 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6520)
%t6522 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6521)
%t6523 = call i128 @__mruntime_rt_dec_resid__qhat_fix(i128 %t6515, i128 %t6518, i64 %p5, i64 %p6, i64 %t6522)
%t6524 = add i128 %t6523, 0
%t6525 = trunc i128 %t6524 to i64
%t6531 = add i64 0, 0
%t6532 = add i64 %t6531, 0
%t6538 = add i64 0, 0
%t6539 = add i64 %t6538, 0
%t6545 = call i64 @__mruntime_rt_dec_resid__sub_mul(i64 %p0, i64 %p1, i64 %p2, i64 %p4, i64 %t6525, i64 0, i64 %t6532, i64 %t6539)
%t6546 = call i64 @__mruntime_rt_dec_resid__r2()
%t6547 = call i64 @ld64(i64 %t6546)
%t6548 = add i64 %t6547, 0
%t6549 = add i64 %t6548, 0
%t6555 = add i64 %p4, %p2
%t6556 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6555)
%t6557 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6556)
%t6558 = add i64 %t6545, %t6549
%t6559 = icmp ult i64 %t6557, %t6558
%t6560 = add i64 %p4, %p2
%t6561 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6560)
br i1 %t6559, label %L1963, label %L1964
L1963:
%t6562 = call i64 @__mruntime_rt_dec_resid__bb()
%t6563 = sub i64 %t6562, %t6558
%t6564 = add i64 %t6557, %t6563
br label %L1965
L1964:
%t6565 = sub i64 %t6557, %t6558
br label %L1965
L1965:
%t6566 = phi i64 [ %t6564, %L1963 ], [ %t6565, %L1964 ]
%t6567 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6561, i64 %t6566)
br i1 %t6559, label %L1966, label %L1967
L1966:
%t6568 = call i64 @__mruntime_rt_dec_resid__add_back(i64 %p0, i64 %p1, i64 %p2, i64 %p4)
br label %L1968
L1967:
br label %L1968
L1968:
%t6569 = phi i64 [ %t6568, %L1966 ], [ 0, %L1967 ]
br i1 %t6559, label %L1969, label %L1970
L1969:
%t6570 = add i64 1, 0
%t6571 = add i64 %t6570, 0
%t6577 = sub i64 %t6525, %t6571
br label %L1971
L1970:
br label %L1971
L1971:
%t6578 = phi i64 [ %t6577, %L1969 ], [ %t6525, %L1970 ]
%t6579 = call i64 @__mruntime_rt_dec_resid__li(i64 %p3, i64 %p4)
%t6580 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6579, i64 %t6578)
%t6581 = sub nsw i64 %p4, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i128 @__mruntime_rt_dec_resid__qhat_fix(i128 %p0.in, i128 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i128 [ %p0.in, %entry ], [ %t6617, %tco.s0 ]
%p1 = phi i128 [ %p1.in, %entry ], [ %t6598, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t6583 = call i64 @__mruntime_rt_dec_resid__bb()
%t6584 = zext i64 %t6583 to i128
%t6585 = icmp uge i128 %p0, %t6584
br label %LSL6586
LSL6586:
br i1 %t6585, label %LSJ6586, label %LSR6586
LSR6586:
%t6587 = zext i64 %p3 to i128
%t6588 = mul i128 %p0, %t6587
%t6589 = call i64 @__mruntime_rt_dec_resid__bb()
%t6590 = zext i64 %t6589 to i128
%t6591 = mul i128 %p1, %t6590
%t6592 = zext i64 %p4 to i128
%t6593 = add i128 %t6591, %t6592
%t6594 = icmp ugt i128 %t6588, %t6593
br label %LSJ6586
LSJ6586:
%t6595 = phi i1 [ true, %LSL6586 ], [ %t6594, %LSR6586 ]
%t6596 = xor i1 %t6595, true
br i1 %t6596, label %L1972, label %L1974
L1972:
ret i128 %p0
L1974:
%t6597 = zext i64 %p2 to i128
%t6598 = add i128 %p1, %t6597
%t6599 = call i64 @__mruntime_rt_dec_resid__bb()
%t6600 = zext i64 %t6599 to i128
%t6601 = icmp uge i128 %t6598, %t6600
br i1 %t6601, label %L1975, label %L1977
L1975:
%t6602 = sext i64 1 to i128
%t6603 = add i128 %t6602, 0
%t6609 = sub i128 %p0, %t6603
ret i128 %t6609
L1977:
%t6610 = sext i64 1 to i128
%t6611 = add i128 %t6610, 0
%t6617 = sub i128 %p0, %t6611
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
%p5 = phi i64 [ %p5.in, %entry ], [ %t6660, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %t6636, %tco.s0 ]
%p7 = phi i64 [ %p7.in, %entry ], [ %t6675, %tco.s0 ]
%t6619 = icmp sge i64 %p5, %p2
br i1 %t6619, label %L1978, label %L1980
L1978:
%t6620 = call i64 @__mruntime_rt_dec_resid__r2()
%t6621 = add i64 %p7, 0
%t6622 = add i64 %t6621, 0
%t6628 = call i64 @st64(i64 %t6620, i64 %t6622)
ret i64 %p6
L1980:
%t6629 = zext i64 %p4 to i128
%t6630 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p5)
%t6631 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6630)
%t6632 = zext i64 %t6631 to i128
%t6633 = mul i128 %t6629, %t6632
%t6634 = zext i64 %p6 to i128
%t6635 = add i128 %t6633, %t6634
%t6636 = call i64 @__mruntime_rt_dec_resid__div_b(i128 %t6635)
%t6637 = add i128 %t6635, 0
%t6638 = trunc i128 %t6637 to i64
%t6644 = call i64 @__mruntime_rt_dec_resid__bb()
%t6645 = mul i64 %t6636, %t6644
%t6646 = sub i64 %t6638, %t6645
%t6647 = add i64 %p5, %p3
%t6648 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6647)
%t6649 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6648)
%t6650 = add i64 %t6646, %p7
%t6651 = icmp uge i64 %t6649, %t6650
%t6652 = add i64 %p5, %p3
%t6653 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6652)
br i1 %t6651, label %L1981, label %L1982
L1981:
%t6654 = sub i64 %t6649, %t6650
br label %L1983
L1982:
%t6655 = call i64 @__mruntime_rt_dec_resid__bb()
%t6656 = sub i64 %t6655, %t6650
%t6657 = add i64 %t6649, %t6656
br label %L1983
L1983:
%t6658 = phi i64 [ %t6654, %L1981 ], [ %t6657, %L1982 ]
%t6659 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6653, i64 %t6658)
%t6660 = add nsw i64 %p5, 1
br i1 %t6651, label %L1984, label %L1985
L1984:
%t6661 = add i64 0, 0
%t6662 = add i64 %t6661, 0
br label %L1986
L1985:
%t6668 = add i64 1, 0
%t6669 = add i64 %t6668, 0
br label %L1986
L1986:
%t6675 = phi i64 [ %t6662, %L1984 ], [ %t6669, %L1985 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__add_back(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6677 = add i64 0, 0
%t6678 = add i64 %t6677, 0
%t6684 = call i64 @__mruntime_rt_dec_resid__add_back_at(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 %t6678)
%t6685 = add i64 %p3, %p2
%t6686 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6685)
%t6687 = add i64 %p3, %p2
%t6688 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6687)
%t6689 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6688)
%t6690 = add i64 %t6689, %t6684
%t6691 = call i64 @__mruntime_rt_dec_resid__bb()
%t6692 = icmp eq i64 %t6691, 0
%t6693 = zext i1 %t6692 to i8
call void @resid_div_check(i8 %t6693)
%t6698 = urem i64 %t6690, %t6691
%t6699 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6686, i64 %t6698)
ret i64 %t6699
}
define internal i64 @__mruntime_rt_dec_resid__add_back_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t6716, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t6731, %tco.s0 ]
%t6700 = icmp sge i64 %p4, %p2
br i1 %t6700, label %L1987, label %L1989
L1987:
ret i64 %p5
L1989:
%t6701 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p4)
%t6702 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6701)
%t6703 = add i64 %p4, %p3
%t6704 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6703)
%t6705 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6704)
%t6706 = add i64 %t6705, %p5
%t6707 = call i64 @__mruntime_rt_dec_resid__bb()
%t6708 = sub i64 %t6707, %t6702
%t6709 = icmp uge i64 %t6706, %t6708
%t6710 = add i64 %p4, %p3
%t6711 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %t6710)
br i1 %t6709, label %L1990, label %L1991
L1990:
%t6712 = sub i64 %t6706, %t6708
br label %L1992
L1991:
%t6713 = add i64 %t6706, %t6702
br label %L1992
L1992:
%t6714 = phi i64 [ %t6712, %L1990 ], [ %t6713, %L1991 ]
%t6715 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6711, i64 %t6714)
%t6716 = add nsw i64 %p4, 1
br i1 %t6709, label %L1993, label %L1994
L1993:
%t6717 = add i64 1, 0
%t6718 = add i64 %t6717, 0
br label %L1995
L1994:
%t6724 = add i64 0, 0
%t6725 = add i64 %t6724, 0
br label %L1995
L1995:
%t6731 = phi i64 [ %t6718, %L1993 ], [ %t6725, %L1994 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__div_v(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6733 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t6734 = icmp eq i64 %t6733, 0
br i1 %t6734, label %L1996, label %L1998
L1996:
%t6736 = call i64 @rt_abort(ptr @.s6735)
ret i64 %t6736
L1998:
%t6737 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6738 = icmp eq i64 %t6737, 0
br i1 %t6738, label %L1999, label %L2001
L1999:
%t6739 = call i64 @__mruntime_rt_dec_resid__dzero(i64 %p2)
ret i64 %t6739
L2001:
%t6740 = add i64 %p2, 2
%t6741 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t6742 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p1)
%t6743 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6744 = call i64 @dn(i64 %p0)
%t6745 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t6746 = call i64 @dn(i64 %p1)
%t6747 = sub i64 %t6741, %t6742
%t6748 = call i64 @__mruntime_rt_dec_resid__cmp_mag(i64 %t6743, i64 %t6744, i64 %t6741, i64 0, i64 %t6745, i64 %t6746, i64 %t6742, i64 %t6747)
%t6749 = sub i64 %t6741, %t6742
%t6750 = icmp slt i64 %t6748, 0
br i1 %t6750, label %L2002, label %L2003
L2002:
br label %L2004
L2003:
br label %L2004
L2004:
%t6751 = phi i64 [ 1, %L2002 ], [ 0, %L2003 ]
%t6752 = sub i64 %t6749, %t6751
%t6753 = sub nsw i64 %t6740, 1
%t6754 = sub i64 %t6753, %t6752
%t6755 = icmp sge i64 %t6754, 0
br i1 %t6755, label %L2005, label %L2006
L2005:
%t6756 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6757 = call i64 @dn(i64 %p0)
%t6758 = call i64 @__mruntime_rt_dec_resid__scale(i64 %t6756, i64 %t6757, i64 %t6754)
br label %L2007
L2006:
%t6759 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6760 = call i64 @dn(i64 %p0)
%t6761 = call i64 @dn(i64 %p0)
%t6762 = add i64 %t6761, 1
%t6763 = call i64 @__mruntime_rt_dec_resid__copy_limbs(i64 %t6759, i64 %t6760, i64 %t6762)
br label %L2007
L2007:
%t6764 = phi i64 [ %t6758, %L2005 ], [ %t6763, %L2006 ]
%t6765 = icmp sge i64 %t6754, 0
br i1 %t6765, label %L2008, label %L2009
L2008:
%t6766 = call i64 @__mruntime_rt_dec_resid__r2()
%t6767 = call i64 @ld64(i64 %t6766)
br label %L2010
L2009:
%t6768 = call i64 @dn(i64 %p0)
br label %L2010
L2010:
%t6769 = phi i64 [ %t6767, %L2008 ], [ %t6768, %L2009 ]
%t6770 = icmp sge i64 %t6754, 0
br i1 %t6770, label %L2011, label %L2012
L2011:
%t6771 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t6772 = call i64 @dn(i64 %p1)
%t6773 = call i64 @dn(i64 %p1)
%t6774 = call i64 @__mruntime_rt_dec_resid__copy_limbs(i64 %t6771, i64 %t6772, i64 %t6773)
br label %L2013
L2012:
%t6775 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t6776 = call i64 @dn(i64 %p1)
%t6777 = sub i64 0, %t6754
%t6778 = call i64 @__mruntime_rt_dec_resid__scale(i64 %t6775, i64 %t6776, i64 %t6777)
br label %L2013
L2013:
%t6779 = phi i64 [ %t6774, %L2011 ], [ %t6778, %L2012 ]
%t6780 = icmp sge i64 %t6754, 0
br i1 %t6780, label %L2014, label %L2015
L2014:
%t6781 = call i64 @dn(i64 %p1)
br label %L2016
L2015:
%t6782 = call i64 @__mruntime_rt_dec_resid__r2()
%t6783 = call i64 @ld64(i64 %t6782)
br label %L2016
L2016:
%t6784 = phi i64 [ %t6781, %L2014 ], [ %t6783, %L2015 ]
%t6785 = sub i64 %t6769, %t6784
%t6786 = add i64 %t6785, 1
%t6787 = icmp sgt i64 %t6786, 1
br i1 %t6787, label %L2017, label %L2018
L2017:
br label %L2019
L2018:
br label %L2019
L2019:
%t6788 = phi i64 [ %t6786, %L2017 ], [ 1, %L2018 ]
%t6789 = add i64 %t6788, 1
%t6790 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 %t6789)
%t6791 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6790)
%t6792 = add i64 %t6788, 1
%t6793 = mul i64 %t6792, 8
%t6794p = inttoptr i64 %t6791 to ptr
%t6794q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t6794p, i8 %t6794q, i64 %t6793, i1 false)
%t6794 = add i64 0, 0
%t6795 = icmp slt i64 %t6769, %t6784
br i1 %t6795, label %L2020, label %L2022
L2020:
%t6797 = call i64 @rt_abort(ptr @.s6796)
ret i64 %t6797
L2022:
%t6798 = icmp eq i64 %t6784, 1
br i1 %t6798, label %L2023, label %L2024
L2023:
%t6799 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6790)
%t6800 = sub i64 %t6769, 1
%t6801 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6779)
%t6802 = sext i64 0 to i128
%t6803 = add i128 %t6802, 0
%t6809 = call i64 @__mruntime_rt_dec_resid__div_small(i64 %t6799, i64 %t6764, i64 %t6800, i64 %t6801, i128 %t6803)
br label %L2025
L2024:
%t6810 = call i64 @__mruntime_rt_dec_resid__dl(i64 %t6790)
%t6811 = call i64 @__mruntime_rt_dec_resid__div_big(i64 %t6764, i64 %t6769, i64 %t6779, i64 %t6784, i64 %t6810)
br label %L2025
L2025:
%t6812 = phi i64 [ %t6809, %L2023 ], [ %t6811, %L2024 ]
%t6813 = call i64 @c_free(i64 %t6764)
%t6814 = call i64 @c_free(i64 %t6779)
%t6815 = add i64 %t6813, %t6814
%t6816 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t6817 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t6818 = icmp eq i64 %t6816, %t6817
br i1 %t6818, label %L2026, label %L2027
L2026:
br label %L2028
L2027:
%t6819 = sub nsw i64 0, 1
br label %L2028
L2028:
%t6820 = phi i64 [ 1, %L2026 ], [ %t6819, %L2027 ]
%t6821 = add i64 %t6788, 1
%t6822 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t6823 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p1)
%t6824 = sub i64 %t6822, %t6823
%t6825 = sub i64 %t6824, %t6754
%t6826 = call i64 @__mruntime_rt_dec_resid__finish(i64 %t6790, i64 %t6820, i64 %t6821, i64 %t6825, i64 %p2)
ret i64 %t6826
}
define internal i64 @__mruntime_rt_dec_resid__copy_limbs(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6827 = call i64 @__mruntime_rt_dec_resid__tmp_limbs(i64 %p2)
%t6828 = mul i64 %p1, 8
%t6829 = call i64 @mcopy(i64 %t6827, i64 %p0, i64 %t6828)
%t6830 = mul nsw i64 %t6829, 0
%t6831 = add nsw i64 %t6830, %t6827
ret i64 %t6831
}
define internal i64 @__mruntime_rt_dec_resid__div_small(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i128 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6857, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i128 [ %p4.in, %entry ], [ %t6860, %tco.s0 ]
%t6832 = icmp slt i64 %p2, 0
br i1 %t6832, label %L2029, label %L2031
L2029:
ret i64 0
L2031:
%t6833 = call i64 @__mruntime_rt_dec_resid__bb()
%t6834 = zext i64 %t6833 to i128
%t6835 = mul i128 %p4, %t6834
%t6836 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p2)
%t6837 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6836)
%t6838 = zext i64 %t6837 to i128
%t6839 = add i128 %t6835, %t6838
%t6840 = zext i64 %p3 to i128
%t6841 = icmp eq i128 %t6840, 0
%t6842 = zext i1 %t6841 to i8
call void @resid_div_check(i8 %t6842)
%t6847 = udiv i128 %t6839, %t6840
%t6848 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p2)
%t6849 = add i128 %t6847, 0
%t6850 = trunc i128 %t6849 to i64
%t6856 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6848, i64 %t6850)
%t6857 = sub nsw i64 %p2, 1
%t6858 = zext i64 %p3 to i128
%t6859 = mul i128 %t6847, %t6858
%t6860 = sub i128 %t6839, %t6859
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__div_big(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6862 = add i64 %p1, 1
%t6863 = call i64 @__mruntime_rt_dec_resid__tmp_limbs(i64 %t6862)
%t6864 = mul i64 %p1, 8
%t6865 = call i64 @mcopy(i64 %t6863, i64 %p0, i64 %t6864)
%t6866 = call i64 @__mruntime_rt_dec_resid__li(i64 %t6863, i64 %p1)
%t6867 = add i64 0, 0
%t6868 = add i64 %t6867, 0
%t6874 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6866, i64 %t6868)
%t6875 = call i64 @__mruntime_rt_dec_resid__divmod_n(i64 %t6863, i64 %p1, i64 %p2, i64 %p3, i64 %p4)
%t6876 = call i64 @c_free(i64 %t6863)
ret i64 %t6876
}
define internal i64 @__mruntime_rt_dec_resid__coef_digits(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6877 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t6878 = add i64 %t6877, 1
%t6879 = call i64 @xmalloc(i64 %t6878)
%t6880 = add i64 %t6879, %t6877
%t6881 = call i64 @st8(i64 %t6880, i64 0)
%t6882 = call i64 @__mruntime_rt_dec_resid__digits_limbs(i64 %p0, i64 %t6879, i64 0, i64 %t6877)
ret i64 %t6879
}
define internal i64 @__mruntime_rt_dec_resid__digits_limbs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6895, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t6894, %tco.s0 ]
%t6883 = call i64 @dn(i64 %p0)
%t6884 = icmp sge i64 %p2, %t6883
br i1 %t6884, label %L2032, label %L2034
L2032:
ret i64 0
L2034:
%t6885 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t6886 = call i64 @__mruntime_rt_dec_resid__li(i64 %t6885, i64 %p2)
%t6887 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t6886)
%t6888 = call i64 @dn(i64 %p0)
%t6889 = sub i64 %t6888, 1
%t6890 = icmp eq i64 %p2, %t6889
br i1 %t6890, label %L2035, label %L2036
L2035:
%t6891 = call i64 @__mruntime_rt_dec_resid__ndig64(i64 %t6887)
br label %L2037
L2036:
%t6892 = call i64 @__mruntime_rt_dec_resid__ld_()
br label %L2037
L2037:
%t6893 = phi i64 [ %t6891, %L2035 ], [ %t6892, %L2036 ]
%t6894 = call i64 @__mruntime_rt_dec_resid__digits_one(i64 %p1, i64 %t6887, i64 %t6893, i64 %p3)
%t6895 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__digits_one(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6936, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6937, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t6938, %tco.s0 ]
%t6897 = icmp eq i64 %p2, 0
br i1 %t6897, label %L2038, label %L2040
L2038:
ret i64 %p3
L2040:
%t6898 = add i64 %p0, %p3
%t6899 = sub i64 %t6898, 1
%t6900 = add i64 10, 0
%t6901 = add i64 %t6900, 0
%t6907 = icmp eq i64 %t6901, 0
%t6908 = zext i1 %t6907 to i8
call void @resid_div_check(i8 %t6908)
%t6913 = urem i64 %p1, %t6901
%t6914 = add i64 %t6913, 0
%t6915 = add i64 %t6914, 0
%t6921 = add i64 48, %t6915
%t6922 = call i64 @st8(i64 %t6899, i64 %t6921)
%t6923 = add i64 10, 0
%t6924 = add i64 %t6923, 0
%t6930 = icmp eq i64 %t6924, 0
%t6931 = zext i1 %t6930 to i8
call void @resid_div_check(i8 %t6931)
%t6936 = udiv i64 %p1, %t6924
%t6937 = sub i64 %p2, 1
%t6938 = sub i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__parse_digits(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6940 = call i64 @__mruntime_rt_dec_resid__ld_()
%t6941 = add i64 %p1, %t6940
%t6942 = sub i64 %t6941, 1
%t6943 = call i64 @__mruntime_rt_dec_resid__ld_()
%t6944 = icmp eq i64 %t6943, 0
%t6945 = zext i1 %t6944 to i8
call void @resid_div_check(i8 %t6945)
%t6946 = icmp eq i64 %t6943, -1
%t6947 = icmp eq i64 %t6942, -9223372036854775808
%t6948 = and i1 %t6946, %t6947
%t6951 = zext i1 %t6948 to i8
call void @resid_overflow_check(i8 %t6951)
%t6949 = add i64 %t6943, 0
%t6950 = sdiv i64 %t6942, %t6949
%t6952 = add i64 %t6950, 1
%t6953 = call i64 @__mruntime_rt_dec_resid__tmp_limbs(i64 %t6952)
%t6954 = call i64 @__mruntime_rt_dec_resid__parse_limbs(i64 %p0, i64 %t6953, i64 0, i64 %t6950, i64 %p1)
%t6955 = call i64 @__mruntime_rt_dec_resid__r2()
%t6956 = call i64 @__mruntime_rt_dec_resid__top(i64 %t6953, i64 %t6950)
%t6957 = call i64 @st64(i64 %t6955, i64 %t6956)
ret i64 %t6953
}
define internal i64 @__mruntime_rt_dec_resid__parse_limbs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6973, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t6962, %tco.s0 ]
%t6958 = icmp sge i64 %p2, %p3
br i1 %t6958, label %L2041, label %L2043
L2041:
ret i64 0
L2043:
%t6959 = call i64 @__mruntime_rt_dec_resid__ld_()
%t6960 = sub i64 %p4, %t6959
%t6961 = icmp sgt i64 %t6960, 0
br i1 %t6961, label %L2044, label %L2045
L2044:
br label %L2046
L2045:
br label %L2046
L2046:
%t6962 = phi i64 [ %t6960, %L2044 ], [ 0, %L2045 ]
%t6963 = call i64 @__mruntime_rt_dec_resid__li(i64 %p1, i64 %p2)
%t6964 = add i64 0, 0
%t6965 = add i64 %t6964, 0
%t6971 = call i64 @__mruntime_rt_dec_resid__digits_value(i64 %p0, i64 %t6962, i64 %p4, i64 %t6965)
%t6972 = call i64 @__mruntime_rt_dec_resid__su(i64 %t6963, i64 %t6971)
%t6973 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__digits_value(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6976, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t6995, %tco.s0 ]
%t6975 = icmp sge i64 %p1, %p2
br i1 %t6975, label %L2047, label %L2049
L2047:
ret i64 %p3
L2049:
%t6976 = add nsw i64 %p1, 1
%t6977 = add i64 10, 0
%t6978 = add i64 %t6977, 0
%t6984 = mul i64 %p3, %t6978
%t6985 = add i64 %p0, %p1
%t6986 = call i64 @ld8(i64 %t6985)
%t6987 = sub i64 %t6986, 48
%t6988 = add i64 %t6987, 0
%t6989 = add i64 %t6988, 0
%t6995 = add i64 %t6984, %t6989
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_dec_resid__is_dig(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6997 = icmp sge i64 %p0, 48
br label %LSL6998
LSL6998:
br i1 %t6997, label %LSR6998, label %LSJ6998
LSR6998:
%t6999 = icmp sle i64 %p0, 57
br label %LSJ6998
LSJ6998:
%t7000 = phi i1 [ false, %LSL6998 ], [ %t6999, %LSR6998 ]
ret i1 %t7000
}
define internal i64 @__mruntime_rt_dec_resid__take_digits(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t7011, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t7012, %tco.s0 ]
%t7001 = call i64 @ld8(i64 %p0)
%t7002 = call i1 @__mruntime_rt_dec_resid__is_dig(i64 %t7001)
%t7003 = xor i1 %t7002, true
br i1 %t7003, label %L2050, label %L2052
L2050:
%t7004 = call i64 @__mruntime_rt_dec_resid__r2()
%t7005 = call i64 @st64(i64 %t7004, i64 %p0)
%t7006 = mul nsw i64 %t7005, 0
%t7007 = add nsw i64 %t7006, %p2
ret i64 %t7007
L2052:
%t7008 = add i64 %p1, %p2
%t7009 = call i64 @ld8(i64 %p0)
%t7010 = call i64 @st8(i64 %t7008, i64 %t7009)
%t7011 = add i64 %p0, 1
%t7012 = add i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__exp_value(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t7026, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7030, %tco.s0 ]
%t7014 = call i64 @ld8(i64 %p0)
%t7015 = call i1 @__mruntime_rt_dec_resid__is_dig(i64 %t7014)
%t7016 = xor i1 %t7015, true
br i1 %t7016, label %L2053, label %L2055
L2053:
%t7017 = call i64 @__mruntime_rt_dec_resid__r2()
%t7018 = call i64 @st64(i64 %t7017, i64 %p0)
%t7019 = mul nsw i64 %t7018, 0
%t7020 = add nsw i64 %t7019, %p1
ret i64 %t7020
L2055:
%t7021 = call i64 @__mruntime_rt_dec_resid__max_exp()
%t7022 = sdiv i64 %t7021, 10
%t7023 = icmp sgt i64 %p1, %t7022
br i1 %t7023, label %L2056, label %L2058
L2056:
%t7025 = call i64 @rt_abort(ptr @.s7024)
ret i64 %t7025
L2058:
%t7026 = add i64 %p0, 1
%t7027 = mul i64 %p1, 10
%t7028 = call i64 @ld8(i64 %p0)
%t7029 = add i64 %t7027, %t7028
%t7030 = sub i64 %t7029, 48
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__from_str(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7032 = call i64 @ld8(i64 %p0)
%t7033 = icmp eq i64 %t7032, 45
br i1 %t7033, label %L2059, label %L2060
L2059:
%t7034 = sub nsw i64 0, 1
br label %L2061
L2060:
br label %L2061
L2061:
%t7035 = phi i64 [ %t7034, %L2059 ], [ 1, %L2060 ]
%t7036 = icmp eq i64 %t7032, 45
br label %LSL7037
LSL7037:
br i1 %t7036, label %LSJ7037, label %LSR7037
LSR7037:
%t7038 = icmp eq i64 %t7032, 43
br label %LSJ7037
LSJ7037:
%t7039 = phi i1 [ true, %LSL7037 ], [ %t7038, %LSR7037 ]
br i1 %t7039, label %L2062, label %L2063
L2062:
%t7040 = add i64 %p0, 1
br label %L2064
L2063:
br label %L2064
L2064:
%t7041 = phi i64 [ %t7040, %L2062 ], [ %p0, %L2063 ]
%t7042 = call i64 @c_strlen(i64 %t7041)
%t7043 = add i64 %t7042, 1
%t7044 = call i64 @xmalloc(i64 %t7043)
%t7045 = call i64 @__mruntime_rt_dec_resid__take_digits(i64 %t7041, i64 %t7044, i64 0)
%t7046 = call i64 @__mruntime_rt_dec_resid__r2()
%t7047 = call i64 @ld64(i64 %t7046)
%t7048 = call i64 @ld8(i64 %t7047)
%t7049 = icmp eq i64 %t7048, 46
br i1 %t7049, label %L2065, label %L2066
L2065:
%t7050 = add i64 %t7047, 1
%t7051 = call i64 @__mruntime_rt_dec_resid__take_digits(i64 %t7050, i64 %t7044, i64 %t7045)
br label %L2067
L2066:
br label %L2067
L2067:
%t7052 = phi i64 [ %t7051, %L2065 ], [ %t7045, %L2066 ]
br i1 %t7049, label %L2068, label %L2069
L2068:
%t7053 = call i64 @__mruntime_rt_dec_resid__r2()
%t7054 = call i64 @ld64(i64 %t7053)
br label %L2070
L2069:
br label %L2070
L2070:
%t7055 = phi i64 [ %t7054, %L2068 ], [ %t7047, %L2069 ]
%t7056 = sub i64 %t7052, %t7045
%t7057 = sub i64 0, %t7056
%t7058 = call i64 @ld8(i64 %t7055)
%t7059 = icmp eq i64 %t7058, 101
br label %LSL7060
LSL7060:
br i1 %t7059, label %LSJ7060, label %LSR7060
LSR7060:
%t7061 = icmp eq i64 %t7058, 69
br label %LSJ7060
LSJ7060:
%t7062 = phi i1 [ true, %LSL7060 ], [ %t7061, %LSR7060 ]
%t7063 = add i64 %t7055, 1
br label %LSL7064
LSL7064:
br i1 %t7062, label %LSR7064, label %LSJ7064
LSR7064:
%t7065 = call i64 @ld8(i64 %t7063)
%t7066 = icmp eq i64 %t7065, 45
br label %LSJ7064
LSJ7064:
%t7067 = phi i1 [ false, %LSL7064 ], [ %t7066, %LSR7064 ]
br i1 %t7067, label %L2071, label %L2072
L2071:
%t7068 = sub nsw i64 0, 1
br label %L2073
L2072:
br label %L2073
L2073:
%t7069 = phi i64 [ %t7068, %L2071 ], [ 1, %L2072 ]
br label %LSL7070
LSL7070:
br i1 %t7062, label %LSR7070, label %LSJ7070
LSR7070:
%t7071 = call i64 @ld8(i64 %t7063)
%t7072 = icmp eq i64 %t7071, 45
br label %LSL7073
LSL7073:
br i1 %t7072, label %LSJ7073, label %LSR7073
LSR7073:
%t7074 = call i64 @ld8(i64 %t7063)
%t7075 = icmp eq i64 %t7074, 43
br label %LSJ7073
LSJ7073:
%t7076 = phi i1 [ true, %LSL7073 ], [ %t7075, %LSR7073 ]
br label %LSJ7070
LSJ7070:
%t7077 = phi i1 [ false, %LSL7070 ], [ %t7076, %LSJ7073 ]
br i1 %t7077, label %L2074, label %L2075
L2074:
%t7078 = add i64 %t7063, 1
br label %L2076
L2075:
br label %L2076
L2076:
%t7079 = phi i64 [ %t7078, %L2074 ], [ %t7063, %L2075 ]
br i1 %t7062, label %L2077, label %L2078
L2077:
%t7080 = call i64 @__mruntime_rt_dec_resid__exp_value(i64 %t7079, i64 0)
br label %L2079
L2078:
br label %L2079
L2079:
%t7081 = phi i64 [ %t7080, %L2077 ], [ 0, %L2078 ]
br i1 %t7062, label %L2080, label %L2081
L2080:
%t7082 = call i64 @__mruntime_rt_dec_resid__r2()
%t7083 = call i64 @ld64(i64 %t7082)
br label %L2082
L2081:
br label %L2082
L2082:
%t7084 = phi i64 [ %t7083, %L2080 ], [ %t7055, %L2081 ]
%t7085 = icmp eq i64 %t7052, 0
br label %LSL7086
LSL7086:
br i1 %t7085, label %LSJ7086, label %LSR7086
LSR7086:
%t7087 = call i64 @ld8(i64 %t7084)
%t7088 = icmp ne i64 %t7087, 0
br label %LSJ7086
LSJ7086:
%t7089 = phi i1 [ true, %LSL7086 ], [ %t7088, %LSR7086 ]
br i1 %t7089, label %L2083, label %L2085
L2083:
%t7091 = call i64 @rt_abort(ptr @.s7090)
ret i64 %t7091
L2085:
%t7092 = call i64 @__mruntime_rt_dec_resid__parse_digits(i64 %t7044, i64 %t7052)
%t7093 = call i64 @__mruntime_rt_dec_resid__r2()
%t7094 = call i64 @ld64(i64 %t7093)
%t7095 = call i64 @c_free(i64 %t7044)
%t7096 = mul i64 %t7069, %t7081
%t7097 = add i64 %t7057, %t7096
%t7098 = call i64 @__mruntime_rt_dec_resid__from_limbs(i64 %t7035, i64 %t7092, i64 %t7094, i64 %t7097, i64 %p1)
%t7099 = call i64 @c_free(i64 %t7092)
%t7100 = mul nsw i64 %t7099, 0
%t7101 = add nsw i64 %t7100, %t7098
ret i64 %t7101
}
define internal i64 @__mruntime_rt_dec_resid__from_i64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7102 = icmp eq i64 %p0, 0
br i1 %t7102, label %L2086, label %L2088
L2086:
%t7103 = call i64 @__mruntime_rt_dec_resid__dzero(i64 %p1)
ret i64 %t7103
L2088:
%t7104p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dec_one)
%t7104 = ptrtoint ptr %t7104p to i64
%t7105 = icmp slt i64 %p0, 0
br i1 %t7105, label %L2089, label %L2090
L2089:
%t7106 = sub i64 0, %p0
br label %L2091
L2090:
br label %L2091
L2091:
%t7107 = phi i64 [ %t7106, %L2089 ], [ %p0, %L2090 ]
%t7108 = call i64 @st64(i64 %t7104, i64 %t7107)
%t7109 = icmp slt i64 %p0, 0
br i1 %t7109, label %L2092, label %L2093
L2092:
%t7110 = sub nsw i64 0, 1
br label %L2094
L2093:
br label %L2094
L2094:
%t7111 = phi i64 [ %t7110, %L2092 ], [ 1, %L2093 ]
%t7112 = call i64 @__mruntime_rt_dec_resid__from_limbs(i64 %t7111, i64 %t7104, i64 1, i64 0, i64 %p1)
ret i64 %t7112
}
define internal i64 @__mruntime_rt_dec_resid__cmp_v(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7113 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7114 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t7115 = icmp ne i64 %t7113, %t7114
br i1 %t7115, label %L2095, label %L2097
L2095:
%t7116 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7117 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p1)
%t7118 = icmp sgt i64 %t7116, %t7117
br i1 %t7118, label %L2098, label %L2099
L2098:
br label %L2100
L2099:
%t7119 = sub nsw i64 0, 1
br label %L2100
L2100:
%t7120 = phi i64 [ 1, %L2098 ], [ %t7119, %L2099 ]
ret i64 %t7120
L2097:
%t7121 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7122 = icmp eq i64 %t7121, 0
br i1 %t7122, label %L2101, label %L2103
L2101:
ret i64 0
L2103:
%t7123 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t7124 = call i64 @dn(i64 %p0)
%t7125 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t7126 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t7127 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p1)
%t7128 = call i64 @dn(i64 %p1)
%t7129 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p1)
%t7130 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p1)
%t7131 = call i64 @__mruntime_rt_dec_resid__cmp_mag(i64 %t7123, i64 %t7124, i64 %t7125, i64 %t7126, i64 %t7127, i64 %t7128, i64 %t7129, i64 %t7130)
%t7132 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7133 = icmp slt i64 %t7132, 0
br i1 %t7133, label %L2104, label %L2105
L2104:
%t7134 = sub i64 0, %t7131
br label %L2106
L2105:
br label %L2106
L2106:
%t7135 = phi i64 [ %t7134, %L2104 ], [ %t7131, %L2105 ]
ret i64 %t7135
}
define internal i64 @__mruntime_rt_dec_resid__format(i64 %p0, i1 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7136 = call i64 @__mruntime_rt_dec_resid__dprec(i64 %p0)
%t7137 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7138 = icmp eq i64 %t7137, 0
br i1 %t7138, label %L2107, label %L2109
L2107:
br i1 %p1, label %L2110, label %L2112
L2110:
%t7140 = ptrtoint ptr @.s7139 to i64
%t7141 = call i64 @cstr_dup(i64 %t7140)
ret i64 %t7141
L2112:
%t7142 = add i64 %t7136, 3
%t7143 = call i64 @xmalloc(i64 %t7142)
%t7144 = call i64 @st8(i64 %t7143, i64 48)
%t7145 = add i64 %t7143, 1
%t7146 = call i64 @st8(i64 %t7145, i64 46)
%t7147 = add i64 %t7144, %t7146
%t7148 = add i64 %t7143, 2
%t7149p = inttoptr i64 %t7148 to ptr
%t7149q = trunc i64 48 to i8
call void @llvm.memset.p0.i64(ptr %t7149p, i8 %t7149q, i64 %t7136, i1 false)
%t7149 = add i64 0, 0
%t7150 = add i64 %t7147, %t7149
%t7151 = add i64 %t7143, %t7136
%t7152 = add i64 %t7151, 2
%t7153 = call i64 @st8(i64 %t7152, i64 0)
%t7154 = mul nsw i64 %t7153, 0
%t7155 = add nsw i64 %t7154, %t7143
ret i64 %t7155
L2109:
%t7156 = call i64 @__mruntime_rt_dec_resid__coef_digits(i64 %p0)
%t7157 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t7158 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t7159 = add i64 %t7157, %t7158
%t7160 = call i64 @__mruntime_rt_dec_resid__trail_zeros(i64 %t7156, i64 %t7157)
br label %LSL7161
LSL7161:
br i1 %p1, label %LSR7161, label %LSJ7161
LSR7161:
%t7162 = icmp slt i64 %t7159, %t7136
br label %LSJ7161
LSJ7161:
%t7163 = phi i1 [ false, %LSL7161 ], [ %t7162, %LSR7161 ]
br i1 %t7163, label %L2113, label %L2114
L2113:
%t7164 = icmp sgt i64 %t7160, %t7159
br i1 %t7164, label %L2116, label %L2117
L2116:
br label %L2118
L2117:
%t7165 = icmp sgt i64 %t7159, 0
br i1 %t7165, label %L2119, label %L2120
L2119:
br label %L2121
L2120:
br label %L2121
L2121:
%t7166 = phi i64 [ %t7159, %L2119 ], [ %t7160, %L2120 ]
br label %L2118
L2118:
%t7167 = phi i64 [ %t7160, %L2116 ], [ %t7166, %L2121 ]
br label %L2115
L2114:
br label %L2115
L2115:
%t7168 = phi i64 [ %t7167, %L2118 ], [ %t7136, %L2114 ]
%t7169 = icmp sgt i64 %t7159, 1
br i1 %t7169, label %L2122, label %L2123
L2122:
br label %L2124
L2123:
br label %L2124
L2124:
%t7170 = phi i64 [ %t7159, %L2122 ], [ 1, %L2123 ]
%t7171 = add i64 1, %t7170
%t7172 = add i64 %t7171, 1
%t7173 = sub i64 0, %t7159
%t7174 = icmp sgt i64 %t7173, 0
br i1 %t7174, label %L2125, label %L2126
L2125:
br label %L2127
L2126:
br label %L2127
L2127:
%t7175 = phi i64 [ %t7173, %L2125 ], [ 0, %L2126 ]
%t7176 = add i64 %t7172, %t7175
%t7177 = icmp sgt i64 %t7168, 0
br i1 %t7177, label %L2128, label %L2129
L2128:
br label %L2130
L2129:
br label %L2130
L2130:
%t7178 = phi i64 [ %t7168, %L2128 ], [ 0, %L2129 ]
%t7179 = add i64 %t7176, %t7178
%t7180 = add i64 %t7179, 1
%t7181 = add i64 %t7180, 1
%t7182 = call i64 @xmalloc(i64 %t7181)
%t7183 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7184 = icmp slt i64 %t7183, 0
br i1 %t7184, label %L2131, label %L2132
L2131:
%t7185 = call i64 @st8(i64 %t7182, i64 45)
%t7186 = add i64 %t7185, 1
br label %L2133
L2132:
br label %L2133
L2133:
%t7187 = phi i64 [ %t7186, %L2131 ], [ 0, %L2132 ]
%t7188 = icmp sgt i64 %t7159, 0
br i1 %t7188, label %L2134, label %L2135
L2134:
%t7189 = call i64 @__mruntime_rt_dec_resid__fmt_int(i64 %t7182, i64 %t7187, i64 %t7156, i64 %t7157, i64 %t7159, i64 %t7168)
br label %L2136
L2135:
%t7190 = call i64 @__mruntime_rt_dec_resid__fmt_frac(i64 %t7182, i64 %t7187, i64 %t7156, i64 %t7157, i64 %t7159, i64 %t7168)
br label %L2136
L2136:
%t7191 = phi i64 [ %t7189, %L2134 ], [ %t7190, %L2135 ]
%t7192 = add i64 %t7182, %t7191
%t7193 = call i64 @st8(i64 %t7192, i64 0)
%t7194 = call i64 @c_free(i64 %t7156)
%t7195 = mul nsw i64 %t7194, 0
%t7196 = add nsw i64 %t7195, %t7182
ret i64 %t7196
}
define internal i64 @__mruntime_rt_dec_resid__trail_zeros(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7204, %tco.s0 ]
%t7197 = icmp sgt i64 %p1, 0
br label %LSL7198
LSL7198:
br i1 %t7197, label %LSR7198, label %LSJ7198
LSR7198:
%t7199 = add i64 %p0, %p1
%t7200 = sub nsw i64 %t7199, 1
%t7201 = call i64 @ld8(i64 %t7200)
%t7202 = icmp eq i64 %t7201, 48
br label %LSJ7198
LSJ7198:
%t7203 = phi i1 [ false, %LSL7198 ], [ %t7202, %LSR7198 ]
br i1 %t7203, label %L2137, label %L2139
L2137:
%t7204 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L2139:
ret i64 %p1
}
define internal i64 @__mruntime_rt_dec_resid__dig_at(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7206 = icmp slt i64 %p2, %p1
br i1 %t7206, label %L2140, label %L2141
L2140:
%t7207 = add i64 %p0, %p2
%t7208 = call i64 @ld8(i64 %t7207)
br label %L2142
L2141:
br label %L2142
L2142:
%t7209 = phi i64 [ %t7208, %L2140 ], [ 48, %L2141 ]
ret i64 %t7209
}
define internal i64 @__mruntime_rt_dec_resid__put_digits(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7214, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t7215, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t7210 = icmp sge i64 %p4, %p5
br i1 %t7210, label %L2143, label %L2145
L2143:
ret i64 %p1
L2145:
%t7211 = add i64 %p0, %p1
%t7212 = call i64 @__mruntime_rt_dec_resid__dig_at(i64 %p2, i64 %p3, i64 %p4)
%t7213 = call i64 @st8(i64 %t7211, i64 %t7212)
%t7214 = add i64 %p1, 1
%t7215 = add nsw i64 %p4, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_dec_resid__fmt_int(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7217 = call i64 @__mruntime_rt_dec_resid__put_digits(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 %p4)
%t7218 = icmp sge i64 %p4, %p5
br i1 %t7218, label %L2146, label %L2148
L2146:
ret i64 %t7217
L2148:
%t7219 = add i64 %p0, %t7217
%t7220 = call i64 @st8(i64 %t7219, i64 46)
%t7221 = add i64 %t7217, 1
%t7222 = tail call i64 @__mruntime_rt_dec_resid__put_digits(i64 %p0, i64 %t7221, i64 %p2, i64 %p3, i64 %p4, i64 %p5)
ret i64 %t7222
}
define internal i64 @__mruntime_rt_dec_resid__fmt_frac(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7223 = add i64 %p0, %p1
%t7224 = call i64 @st8(i64 %t7223, i64 48)
%t7225 = add i64 %p0, %p1
%t7226 = add i64 %t7225, 1
%t7227 = call i64 @st8(i64 %t7226, i64 46)
%t7228 = add i64 %t7224, %t7227
%t7229 = add i64 %p0, %p1
%t7230 = add i64 %t7229, 2
%t7231 = sub i64 0, %p4
%t7232p = inttoptr i64 %t7230 to ptr
%t7232q = trunc i64 48 to i8
call void @llvm.memset.p0.i64(ptr %t7232p, i8 %t7232q, i64 %t7231, i1 false)
%t7232 = add i64 0, 0
%t7233 = add i64 %t7228, %t7232
%t7234 = add i64 %p1, 2
%t7235 = sub i64 %t7234, %p4
%t7236 = tail call i64 @__mruntime_rt_dec_resid__put_digits(i64 %p0, i64 %t7235, i64 %p2, i64 %p3, i64 0, i64 %p5)
ret i64 %t7236
}
define internal i64 @__mruntime_rt_dec_resid__to_int(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7237 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7238 = icmp eq i64 %t7237, 0
br i1 %t7238, label %L2149, label %L2151
L2149:
ret i64 0
L2151:
%t7239 = call i64 @__mruntime_rt_dec_resid__dl(i64 %p0)
%t7240 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t7241 = icmp slt i64 %t7240, 0
br i1 %t7241, label %L2152, label %L2153
L2152:
%t7242 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t7243 = sub i64 0, %t7242
br label %L2154
L2153:
br label %L2154
L2154:
%t7244 = phi i64 [ %t7243, %L2152 ], [ 0, %L2153 ]
%t7245 = icmp eq i64 %t7244, 0
br label %LSL7246
LSL7246:
br i1 %t7245, label %LSJ7246, label %LSR7246
LSR7246:
%t7247 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t7248 = icmp slt i64 %t7244, %t7247
br label %LSL7249
LSL7249:
br i1 %t7248, label %LSR7249, label %LSJ7249
LSR7249:
%t7250 = call i64 @__mruntime_rt_dec_resid__ld_()
%t7251 = icmp eq i64 %t7250, 0
%t7252 = zext i1 %t7251 to i8
call void @resid_div_check(i8 %t7252)
%t7253 = icmp eq i64 %t7250, -1
%t7254 = icmp eq i64 %t7244, -9223372036854775808
%t7255 = and i1 %t7253, %t7254
%t7258 = zext i1 %t7255 to i8
call void @resid_overflow_check(i8 %t7258)
%t7256 = add i64 %t7250, 0
%t7257 = sdiv i64 %t7244, %t7256
%t7259 = call i1 @__mruntime_rt_dec_resid__limbs_zero_to(i64 %t7239, i64 0, i64 %t7257)
br label %LSJ7249
LSJ7249:
%t7260 = phi i1 [ false, %LSL7249 ], [ %t7259, %LSR7249 ]
br label %LSL7261
LSL7261:
br i1 %t7260, label %LSR7261, label %LSJ7261
LSR7261:
%t7262 = call i64 @__mruntime_rt_dec_resid__ld_()
%t7263 = icmp eq i64 %t7262, 0
%t7264 = zext i1 %t7263 to i8
call void @resid_div_check(i8 %t7264)
%t7265 = icmp eq i64 %t7262, -1
%t7266 = icmp eq i64 %t7244, -9223372036854775808
%t7267 = and i1 %t7265, %t7266
%t7270 = zext i1 %t7267 to i8
call void @resid_overflow_check(i8 %t7270)
%t7268 = add i64 %t7262, 0
%t7269 = sdiv i64 %t7244, %t7268
%t7271 = call i64 @__mruntime_rt_dec_resid__li(i64 %t7239, i64 %t7269)
%t7272 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t7271)
%t7273 = call i64 @__mruntime_rt_dec_resid__ld_()
%t7274 = icmp eq i64 %t7273, 0
%t7275 = zext i1 %t7274 to i8
call void @resid_div_check(i8 %t7275)
%t7276 = icmp eq i64 %t7273, -1
%t7277 = icmp eq i64 %t7244, -9223372036854775808
%t7278 = and i1 %t7276, %t7277
%t7279 = select i1 %t7276, i64 1, i64 %t7273
%t7280 = srem i64 %t7244, %t7279
%t7282 = call i64 @__mruntime_rt_dec_resid__p10(i64 %t7280)
%t7283 = icmp eq i64 %t7282, 0
%t7284 = zext i1 %t7283 to i8
call void @resid_div_check(i8 %t7284)
%t7289 = urem i64 %t7272, %t7282
%t7290 = add i64 0, 0
%t7291 = add i64 %t7290, 0
%t7297 = icmp eq i64 %t7289, %t7291
br label %LSJ7261
LSJ7261:
%t7298 = phi i1 [ false, %LSL7261 ], [ %t7297, %LSR7261 ]
br label %LSJ7246
LSJ7246:
%t7299 = phi i1 [ true, %LSL7246 ], [ %t7298, %LSJ7261 ]
%t7300 = xor i1 %t7299, true
br i1 %t7300, label %L2155, label %L2157
L2155:
%t7302 = call i64 @rt_abort(ptr @.s7301)
ret i64 %t7302
L2157:
%t7303 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t7304 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t7305 = add i64 %t7303, %t7304
%t7306 = icmp sgt i64 %t7305, 20
br i1 %t7306, label %L2158, label %L2160
L2158:
%t7308 = call i64 @rt_abort(ptr @.s7307)
ret i64 %t7308
L2160:
%t7309 = call i64 @__mruntime_rt_dec_resid__coef_digits(i64 %p0)
%t7310 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t7311 = sub i64 %t7310, %t7244
%t7312 = sext i64 0 to i128
%t7313 = add i128 %t7312, 0
%t7319 = call i128 @__mruntime_rt_dec_resid__digits128(i64 %t7309, i64 0, i64 %t7311, i128 %t7313)
%t7320 = call i64 @c_free(i64 %t7309)
%t7321 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t7322 = call i128 @__mruntime_rt_dec_resid__times10(i128 %t7319, i64 %t7321)
%t7323 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7324 = icmp slt i64 %t7323, 0
br i1 %t7324, label %L2161, label %L2162
L2161:
%t7325 = add i128 9223372036854775807, 0
%t7326 = add i128 %t7325, 0
%t7332 = sext i64 1 to i128
%t7333 = add i128 %t7332, 0
%t7339 = add i128 %t7326, %t7333
br label %L2163
L2162:
%t7340 = add i128 9223372036854775807, 0
%t7341 = add i128 %t7340, 0
br label %L2163
L2163:
%t7347 = phi i128 [ %t7339, %L2161 ], [ %t7341, %L2162 ]
%t7348 = icmp ugt i128 %t7322, %t7347
br i1 %t7348, label %L2164, label %L2166
L2164:
%t7350 = call i64 @rt_abort(ptr @.s7349)
ret i64 %t7350
L2166:
%t7351 = add i128 %t7322, 0
%t7352 = trunc i128 %t7351 to i64
%t7358 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7359 = icmp slt i64 %t7358, 0
br i1 %t7359, label %L2167, label %L2168
L2167:
%t7360 = sub i64 0, %t7352
br label %L2169
L2168:
br label %L2169
L2169:
%t7361 = phi i64 [ %t7360, %L2167 ], [ %t7352, %L2168 ]
ret i64 %t7361
}
define internal i1 @__mruntime_rt_dec_resid__limbs_zero_to(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7362 = icmp sge i64 %p1, %p2
br i1 %t7362, label %L2170, label %L2172
L2170:
ret i1 true
L2172:
%t7363 = call i64 @__mruntime_rt_dec_resid__li(i64 %p0, i64 %p1)
%t7364 = call i64 @__mruntime_rt_dec_resid__lu(i64 %t7363)
%t7365 = add i64 0, 0
%t7366 = add i64 %t7365, 0
%t7372 = icmp eq i64 %t7364, %t7366
br label %LSL7373
LSL7373:
br i1 %t7372, label %LSR7373, label %LSJ7373
LSR7373:
%t7374 = add nsw i64 %p1, 1
%t7375 = call i1 @__mruntime_rt_dec_resid__limbs_zero_to(i64 %p0, i64 %t7374, i64 %p2)
br label %LSJ7373
LSJ7373:
%t7376 = phi i1 [ false, %LSL7373 ], [ %t7375, %LSR7373 ]
ret i1 %t7376
}
define internal i128 @__mruntime_rt_dec_resid__digits128(i64 %p0.in, i64 %p1.in, i64 %p2.in, i128 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7378, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i128 [ %p3.in, %entry ], [ %t7397, %tco.s0 ]
%t7377 = icmp sge i64 %p1, %p2
br i1 %t7377, label %L2173, label %L2175
L2173:
ret i128 %p3
L2175:
%t7378 = add nsw i64 %p1, 1
%t7379 = sext i64 10 to i128
%t7380 = add i128 %t7379, 0
%t7386 = mul i128 %p3, %t7380
%t7387 = add i64 %p0, %p1
%t7388 = call i64 @ld8(i64 %t7387)
%t7389 = sub i64 %t7388, 48
%t7390 = sext i64 %t7389 to i128
%t7391 = add i128 %t7390, 0
%t7397 = add i128 %t7386, %t7391
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i128 @__mruntime_rt_dec_resid__times10(i128 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i128 [ %p0.in, %entry ], [ %t7407, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7408, %tco.s0 ]
%t7399 = icmp sle i64 %p1, 0
br i1 %t7399, label %L2176, label %L2178
L2176:
ret i128 %p0
L2178:
%t7400 = sext i64 10 to i128
%t7401 = add i128 %t7400, 0
%t7407 = mul i128 %p0, %t7401
%t7408 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal double @__mruntime_rt_dec_resid__to_f64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7410 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7411 = icmp eq i64 %t7410, 0
br i1 %t7411, label %L2179, label %L2181
L2179:
ret double 0.0
L2181:
%t7412 = call i64 @__mruntime_rt_dec_resid__coef_digits(i64 %p0)
%t7413 = call i64 @__mruntime_rt_dec_resid__dnd(i64 %p0)
%t7414 = icmp slt i64 %t7413, 40
br i1 %t7414, label %L2182, label %L2183
L2182:
br label %L2184
L2183:
br label %L2184
L2184:
%t7415 = phi i64 [ %t7413, %L2182 ], [ 40, %L2183 ]
%t7416p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dec_f64)
%t7416 = ptrtoint ptr %t7416p to i64
%t7417 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7418 = icmp slt i64 %t7417, 0
br i1 %t7418, label %L2185, label %L2186
L2185:
%t7419 = call i64 @st8(i64 %t7416, i64 45)
%t7420 = add i64 %t7419, 1
br label %L2187
L2186:
br label %L2187
L2187:
%t7421 = phi i64 [ %t7420, %L2185 ], [ 0, %L2186 ]
%t7422 = add i64 %t7416, %t7421
%t7423 = call i64 @mcopy(i64 %t7422, i64 %t7412, i64 %t7415)
%t7424 = add i64 %t7421, %t7415
%t7425 = add i64 %t7416, %t7424
%t7426 = call i64 @st8(i64 %t7425, i64 101)
%t7427 = add i64 %t7424, 1
%t7428 = add i64 %t7416, %t7424
%t7429 = add i64 %t7428, 1
%t7430 = call i64 @__mruntime_rt_dec_resid__dexp(i64 %p0)
%t7431 = sub i64 %t7413, %t7415
%t7432 = add i64 %t7430, %t7431
%t7433 = call i64 @itoa_into(i64 %t7429, i64 %t7432)
%t7434 = add i64 %t7427, %t7433
%t7435 = add i64 %t7416, %t7434
%t7436 = call i64 @st8(i64 %t7435, i64 0)
%t7437 = call i64 @c_free(i64 %t7412)
%t7438 = call double @c_strtod(i64 %t7416, i64 0)
ret double %t7438
}
define internal i64 @__mruntime_rt_dec_resid__opprec(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7439 = call i64 @__mruntime_rt_dec_resid__dprec(i64 %p0)
%t7440 = call i64 @__mruntime_rt_dec_resid__dprec(i64 %p1)
%t7441 = icmp sgt i64 %t7439, %t7440
br i1 %t7441, label %L2188, label %L2189
L2188:
br label %L2190
L2189:
br label %L2190
L2190:
%t7442 = phi i64 [ %t7439, %L2188 ], [ %t7440, %L2189 ]
ret i64 %t7442
}
define internal i64 @__mruntime_rt_dec_resid__fit(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7443 = call i64 @__mruntime_rt_dec_resid__dprec(i64 %p0)
%t7444 = icmp eq i64 %t7443, %p1
br i1 %t7444, label %L2191, label %L2192
L2191:
br label %L2193
L2192:
%t7445 = call i64 @__mruntime_rt_dec_resid__round_v(i64 %p0, i64 %p1, i1 false)
br label %L2193
L2193:
%t7446 = phi i64 [ %p0, %L2191 ], [ %t7445, %L2192 ]
ret i64 %t7446
}
define internal i64 @rt_decp_from_str(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7447 = tail call i64 @__mruntime_rt_dec_resid__from_str(i64 %p0, i64 %p1)
ret i64 %t7447
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
%t7448 = tail call i64 @__mruntime_rt_dec_resid__from_i64(i64 %p0, i64 %p1)
ret i64 %t7448
}
define ptr @resid_decp_from_i64(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_decp_from_i64(i64 %a0, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_decp_round(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7449 = call i64 @__mruntime_rt_dec_resid__round_v(i64 %p0, i64 %p1, i1 false)
ret i64 %t7449
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
%t7450 = call i64 @__mruntime_rt_dec_resid__opprec(i64 %p0, i64 %p1)
%t7451 = call i64 @__mruntime_rt_dec_resid__addsub(i64 %p0, i64 %p1, i1 false, i64 %t7450)
%t7452 = call i64 @__mruntime_rt_dec_resid__fit(i64 %t7451, i64 %p2)
ret i64 %t7452
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
%t7453 = call i64 @__mruntime_rt_dec_resid__opprec(i64 %p0, i64 %p1)
%t7454 = call i64 @__mruntime_rt_dec_resid__addsub(i64 %p0, i64 %p1, i1 true, i64 %t7453)
%t7455 = call i64 @__mruntime_rt_dec_resid__fit(i64 %t7454, i64 %p2)
ret i64 %t7455
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
%t7456 = call i64 @__mruntime_rt_dec_resid__opprec(i64 %p0, i64 %p1)
%t7457 = call i64 @__mruntime_rt_dec_resid__mul_v(i64 %p0, i64 %p1, i64 %t7456)
%t7458 = call i64 @__mruntime_rt_dec_resid__fit(i64 %t7457, i64 %p2)
ret i64 %t7458
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
%t7459 = call i64 @__mruntime_rt_dec_resid__opprec(i64 %p0, i64 %p1)
%t7460 = call i64 @__mruntime_rt_dec_resid__div_v(i64 %p0, i64 %p1, i64 %t7459)
%t7461 = call i64 @__mruntime_rt_dec_resid__fit(i64 %t7460, i64 %p2)
ret i64 %t7461
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
%t7462 = call i64 @dn(i64 %p0)
%t7463 = call i64 @__mruntime_rt_dec_resid__dalloc(i64 %t7462)
%t7464 = call i64 @dn(i64 %p0)
%t7465 = mul i64 %t7464, 8
%t7466 = add i64 24, %t7465
%t7467 = call i64 @mcopy(i64 %t7463, i64 %p0, i64 %t7466)
%t7468 = call i64 @__mruntime_rt_dec_resid__dsign(i64 %p0)
%t7469 = sub i64 0, %t7468
%t7470 = call i64 @st8(i64 %t7463, i64 %t7469)
%t7471 = mul nsw i64 %t7470, 0
%t7472 = add nsw i64 %t7471, %t7463
ret i64 %t7472
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
%t7473 = tail call i64 @__mruntime_rt_dec_resid__cmp_v(i64 %p0, i64 %p1)
ret i64 %t7473
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
%t7474 = icmp ne i64 %p1, 0
%t7475 = call i64 @__mruntime_rt_dec_resid__format(i64 %p0, i1 %t7474)
ret i64 %t7475
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
%t7476 = tail call i64 @__mruntime_rt_dec_resid__to_int(i64 %p0)
ret i64 %t7476
}
define i64 @resid_decp_to_i64(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_decp_to_i64(i64 %x0i)
ret i64 %r
}
define internal double @rt_decp_to_f64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7477 = tail call double @__mruntime_rt_dec_resid__to_f64(i64 %p0)
ret double %t7477
}
define double @resid_decp_to_f64(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call double @rt_decp_to_f64(i64 %x0i)
ret double %r
}
define internal i64 @__mruntime_rt_list_resid__box_hdr(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7478 = icmp sgt i64 %p1, 0
br i1 %t7478, label %L2194, label %L2195
L2194:
br label %L2196
L2195:
br label %L2196
L2196:
%t7479 = phi i64 [ %p1, %L2194 ], [ 0, %L2195 ]
%t7480 = mul i64 %t7479, 8
%t7481 = add i64 16, %t7480
%t7482 = call i64 @ralloc(i64 %t7481)
%t7483 = call i64 @st32(i64 %t7482, i64 %p0)
%t7484 = add i64 %t7482, 4
%t7485 = call i64 @st32(i64 %t7484, i64 %p1)
%t7486 = add i64 %t7482, 8
%t7487 = call i64 @st64(i64 %t7486, i64 %p2)
%t7488 = mul nsw i64 %t7487, 0
%t7489 = add nsw i64 %t7488, %t7482
ret i64 %t7489
}
define internal i64 @rt_box_new(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7490 = call i64 @__mruntime_rt_list_resid__box_hdr(i64 %p0, i64 %p1, i64 %p3)
%t7491 = icmp sgt i64 %p1, 0
br i1 %t7491, label %L2197, label %L2198
L2197:
%t7492 = add i64 %t7490, 16
%t7493 = mul i64 %p1, 8
%t7494 = call i64 @mcopy(i64 %t7492, i64 %p2, i64 %t7493)
br label %L2199
L2198:
br label %L2199
L2199:
%t7495 = phi i64 [ %t7494, %L2197 ], [ 0, %L2198 ]
ret i64 %t7490
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
%t7496 = tail call i64 @__mruntime_rt_list_resid__box_hdr(i64 %p0, i64 %p1, i64 %p2)
ret i64 %t7496
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
%t7497 = call i1 @box_imm(i64 %p0)
br label %LSL7498
LSL7498:
br i1 %t7497, label %LSJ7498, label %LSR7498
LSR7498:
%t7499 = call i1 @box_fimm(i64 %p0)
br label %LSJ7498
LSJ7498:
%t7500 = phi i1 [ true, %LSL7498 ], [ %t7499, %LSR7498 ]
br i1 %t7500, label %L2200, label %L2201
L2200:
%t7501 = sub nsw i64 0, 1
br label %L2202
L2201:
%t7502 = call i64 @box_tag(i64 %p0)
br label %L2202
L2202:
%t7503 = phi i64 [ %t7501, %L2200 ], [ %t7502, %L2201 ]
ret i64 %t7503
}
define i64 @resid_box_tag(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_box_tag(i64 %x0i)
ret i64 %r
}
define internal i64 @rt_box_count(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7504 = call i1 @box_imm(i64 %p0)
br label %LSL7505
LSL7505:
br i1 %t7504, label %LSJ7505, label %LSR7505
LSR7505:
%t7506 = call i1 @box_fimm(i64 %p0)
br label %LSJ7505
LSJ7505:
%t7507 = phi i1 [ true, %LSL7505 ], [ %t7506, %LSR7505 ]
br i1 %t7507, label %L2203, label %L2204
L2203:
br label %L2205
L2204:
%t7508 = call i64 @box_count(i64 %p0)
br label %L2205
L2205:
%t7509 = phi i64 [ 1, %L2203 ], [ %t7508, %L2204 ]
ret i64 %t7509
}
define i64 @resid_box_count(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_box_count(i64 %x0i)
ret i64 %r
}
define internal i64 @rt_box_slots(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7510 = add i64 %p0, 16
ret i64 %t7510
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
%t7511 = add i64 %p0, 16
%t7512 = mul i64 %p1, 8
%t7513 = add i64 %t7511, %t7512
%t7514 = call i64 @ld64(i64 %t7513)
ret i64 %t7514
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
%t7515 = tail call i64 @c_malloc(i64 %p0)
ret i64 %t7515
}
define ptr @resid_malloc(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_malloc(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @lcount(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7516 = tail call i64 @ld64(i64 %p0)
ret i64 %t7516
}
define internal i64 @lshift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7517 = add i64 %p0, 8
%t7518 = call i64 @ld32(i64 %t7517)
%t7519 = tail call i64 @sx32(i64 %t7518)
ret i64 %t7519
}
define internal i64 @lroot(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7520 = add i64 %p0, 16
%t7521 = tail call i64 @ld64(i64 %t7520)
ret i64 %t7521
}
define internal i64 @ltype(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7522 = add i64 %p0, 24
%t7523 = tail call i64 @ld64(i64 %t7522)
ret i64 %t7523
}
define internal i64 @__mruntime_rt_list_resid__set_list(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7524 = call i64 @st64(i64 %p0, i64 %p1)
%t7525 = add i64 %p0, 8
%t7526 = call i64 @st32(i64 %t7525, i64 %p2)
%t7527 = add i64 %p0, 16
%t7528 = call i64 @st64(i64 %t7527, i64 %p3)
%t7529 = add i64 %p0, 24
%t7530 = call i64 @st64(i64 %t7529, i64 %p4)
%t7531 = mul nsw i64 %t7530, 0
%t7532 = add nsw i64 %t7531, %p0
ret i64 %t7532
}
define internal i64 @list_hdr() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7533 = call i64 @ralloc(i64 32)
%t7534 = add i64 %t7533, 12
%t7535 = call i64 @st32(i64 %t7534, i64 0)
%t7536 = mul nsw i64 %t7535, 0
%t7537 = add nsw i64 %t7536, %t7533
ret i64 %t7537
}
define ptr @resid_rt_list_hdr() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @list_hdr()
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_list_resid__node_new(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7538 = mul i64 %p0, 8
%t7539 = add i64 8, %t7538
%t7540 = call i64 @ralloc(i64 %t7539)
%t7541 = call i64 @st64(i64 %t7540, i64 %p0)
%t7542 = add i64 %t7540, 8
%t7543 = mul i64 %p0, 8
%t7544p = inttoptr i64 %t7542 to ptr
%t7544q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t7544p, i8 %t7544q, i64 %t7543, i1 false)
%t7544 = add i64 0, 0
%t7545 = mul nsw i64 %t7544, 0
%t7546 = add nsw i64 %t7545, %t7540
ret i64 %t7546
}
define internal i64 @flat_new(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7547 = mul i64 %p0, 8
%t7548 = add i64 24, %t7547
%t7549 = call i64 @ralloc(i64 %t7548)
%t7550 = call i64 @st64(i64 %t7549, i64 0)
%t7551 = add i64 %t7549, 8
%t7552 = call i64 @st64(i64 %t7551, i64 %p0)
%t7553 = add i64 %t7549, 16
%t7554 = call i64 @st64(i64 %t7553, i64 0)
%t7555 = mul nsw i64 %t7554, 0
%t7556 = add nsw i64 %t7555, %t7549
ret i64 %t7556
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
%p0 = phi i64 [ %p0.in, %entry ], [ %t7571, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7572, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t7557 = icmp sle i64 %p1, 0
br i1 %t7557, label %L2206, label %L2208
L2206:
%t7558 = add i64 %p0, 8
%t7559 = and i64 %p2, 31
%t7560 = mul nsw i64 %t7559, 8
%t7561 = add i64 %t7558, %t7560
%t7562 = call i64 @ld64(i64 %t7561)
ret i64 %t7562
L2208:
%t7563 = add i64 %p0, 8
%t7564 = icmp uge i64 %p1, 64
%t7565 = add i64 %p1, 0
%t7566 = select i1 %t7564, i64 63, i64 %t7565
%t7567 = ashr i64 %p2, %t7566
%t7568 = and i64 %t7567, 31
%t7569 = mul nsw i64 %t7568, 8
%t7570 = add i64 %t7563, %t7569
%t7571 = call i64 @ld64(i64 %t7570)
%t7572 = sub nsw i64 %p1, 5
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @list_at(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7574 = call i64 @lshift(i64 %p0)
%t7575 = sub nsw i64 0, 1
%t7576 = icmp eq i64 %t7574, %t7575
br i1 %t7576, label %L2209, label %L2211
L2209:
%t7577 = call i64 @lroot(i64 %p0)
%t7578 = add i64 %t7577, 24
%t7579 = mul i64 %p1, 8
%t7580 = add i64 %t7578, %t7579
%t7581 = call i64 @ld64(i64 %t7580)
ret i64 %t7581
L2211:
%t7582 = call i64 @lroot(i64 %p0)
%t7583 = call i64 @lshift(i64 %p0)
%t7584 = call i64 @__mruntime_rt_list_resid__pvec_get(i64 %t7582, i64 %t7583, i64 %p1)
ret i64 %t7584
}
define internal i64 @__mruntime_rt_list_resid__node_with(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7585 = icmp ne i64 %p0, 0
br i1 %t7585, label %L2212, label %L2213
L2212:
%t7586 = call i64 @ld64(i64 %p0)
br label %L2214
L2213:
br label %L2214
L2214:
%t7587 = phi i64 [ %t7586, %L2212 ], [ 0, %L2213 ]
%t7588 = add i64 %p1, 1
%t7589 = icmp sgt i64 %t7588, %t7587
br i1 %t7589, label %L2215, label %L2216
L2215:
br label %L2217
L2216:
br label %L2217
L2217:
%t7590 = phi i64 [ %t7588, %L2215 ], [ %t7587, %L2216 ]
%t7591 = call i64 @__mruntime_rt_list_resid__node_new(i64 %t7590)
%t7592 = icmp sgt i64 %t7587, 0
br i1 %t7592, label %L2218, label %L2219
L2218:
%t7593 = add i64 %t7591, 8
%t7594 = add i64 %p0, 8
%t7595 = mul i64 %t7587, 8
%t7596 = call i64 @mcopy(i64 %t7593, i64 %t7594, i64 %t7595)
br label %L2220
L2219:
br label %L2220
L2220:
%t7597 = phi i64 [ %t7596, %L2218 ], [ 0, %L2219 ]
%t7598 = add i64 %t7591, 8
%t7599 = mul i64 %p1, 8
%t7600 = add i64 %t7598, %t7599
%t7601 = call i64 @st64(i64 %t7600, i64 %p2)
%t7602 = mul nsw i64 %t7601, 0
%t7603 = add nsw i64 %t7602, %t7591
ret i64 %t7603
}
define internal i64 @__mruntime_rt_list_resid__set_leaf(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7604 = icmp eq i64 %p1, 0
br i1 %t7604, label %L2221, label %L2223
L2221:
ret i64 %p3
L2223:
%t7605 = sub i64 %p1, 5
%t7606 = icmp uge i64 %t7605, 64
%t7607 = add i64 %t7605, 0
%t7608 = select i1 %t7606, i64 63, i64 %t7607
%t7609 = ashr i64 %p2, %t7608
%t7610 = and i64 %t7609, 31
%t7611 = icmp ne i64 %p0, 0
br label %LSL7612
LSL7612:
br i1 %t7611, label %LSR7612, label %LSJ7612
LSR7612:
%t7613 = call i64 @ld64(i64 %p0)
%t7614 = icmp slt i64 %t7610, %t7613
br label %LSJ7612
LSJ7612:
%t7615 = phi i1 [ false, %LSL7612 ], [ %t7614, %LSR7612 ]
br i1 %t7615, label %L2224, label %L2225
L2224:
%t7616 = add i64 %p0, 8
%t7617 = mul nsw i64 %t7610, 8
%t7618 = add i64 %t7616, %t7617
%t7619 = call i64 @ld64(i64 %t7618)
br label %L2226
L2225:
br label %L2226
L2226:
%t7620 = phi i64 [ %t7619, %L2224 ], [ 0, %L2225 ]
%t7621 = sub i64 %p1, 5
%t7622 = call i64 @__mruntime_rt_list_resid__set_leaf(i64 %t7620, i64 %t7621, i64 %p2, i64 %p3)
%t7623 = call i64 @__mruntime_rt_list_resid__node_with(i64 %p0, i64 %t7610, i64 %t7622)
ret i64 %t7623
}
define internal i64 @pvec_append_into(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7624 = call i64 @lshift(i64 %p1)
%t7625 = sub nsw i64 0, 1
%t7626 = icmp eq i64 %t7624, %t7625
br label %LSL7627
LSL7627:
br i1 %t7626, label %LSJ7627, label %LSR7627
LSR7627:
%t7628 = call i64 @lroot(i64 %p1)
%t7629 = icmp eq i64 %t7628, 0
br label %LSJ7627
LSJ7627:
%t7630 = phi i1 [ true, %LSL7627 ], [ %t7629, %LSR7627 ]
br i1 %t7630, label %L2227, label %L2229
L2227:
%t7631 = call i64 @lroot(i64 %p1)
%t7632 = call i64 @lcount(i64 %p1)
%t7633 = icmp ne i64 %t7631, 0
br label %LSL7634
LSL7634:
br i1 %t7633, label %LSR7634, label %LSJ7634
LSR7634:
%t7635 = add i64 %t7632, %p3
%t7636 = add i64 %t7631, 8
%t7637 = call i64 @ld64(i64 %t7636)
%t7638 = icmp sle i64 %t7635, %t7637
br label %LSJ7634
LSJ7634:
%t7639 = phi i1 [ false, %LSL7634 ], [ %t7638, %LSR7634 ]
br label %LSL7640
LSL7640:
br i1 %t7639, label %LSR7640, label %LSJ7640
LSR7640:
%t7641 = add i64 %t7632, %p3
%t7642p = inttoptr i64 %t7631 to ptr
%t7642x = cmpxchg ptr %t7642p, i64 %t7632, i64 %t7641 seq_cst seq_cst
%t7642 = extractvalue {i64, i1} %t7642x, 1
br label %LSJ7640
LSJ7640:
%t7643 = phi i1 [ false, %LSL7640 ], [ %t7642, %LSR7640 ]
br i1 %t7643, label %L2230, label %L2232
L2230:
%t7644 = call i64 @__mruntime_rt_list_resid__flat_fill(i64 %p0, i64 %p1, i64 %t7631, i64 %t7631, i64 %t7632, i64 %p2, i64 %p3)
ret i64 %t7644
L2232:
%t7645 = icmp eq i64 %t7631, 0
br label %LSL7646
LSL7646:
br i1 %t7645, label %LSJ7646, label %LSR7646
LSR7646:
%t7647 = call i64 @ld64(i64 %t7631)
%t7648 = icmp eq i64 %t7647, %t7632
br label %LSJ7646
LSJ7646:
%t7649 = phi i1 [ true, %LSL7646 ], [ %t7648, %LSR7646 ]
br label %LSL7650
LSL7650:
br i1 %t7649, label %LSJ7650, label %LSR7650
LSR7650:
%t7651 = icmp sle i64 %t7632, 64
br label %LSJ7650
LSJ7650:
%t7652 = phi i1 [ true, %LSL7650 ], [ %t7651, %LSR7650 ]
br i1 %t7652, label %L2233, label %L2235
L2233:
%t7653 = icmp ne i64 %t7631, 0
br i1 %t7653, label %L2236, label %L2237
L2236:
%t7654 = add i64 %t7632, %p3
%t7655 = mul i64 %t7654, 2
br label %L2238
L2237:
%t7656 = add i64 %t7632, %p3
br label %L2238
L2238:
%t7657 = phi i64 [ %t7655, %L2236 ], [ %t7656, %L2237 ]
%t7658 = call i64 @flat_new(i64 %t7657)
%t7659 = icmp sgt i64 %t7632, 0
br i1 %t7659, label %L2239, label %L2240
L2239:
%t7660 = add i64 %t7658, 24
%t7661 = add i64 %t7631, 24
%t7662 = mul i64 %t7632, 8
%t7663 = call i64 @mcopy(i64 %t7660, i64 %t7661, i64 %t7662)
br label %L2241
L2240:
br label %L2241
L2241:
%t7664 = phi i64 [ %t7663, %L2239 ], [ 0, %L2240 ]
%t7665 = call i64 @st64(i64 %t7658, i64 %t7632)
%t7666 = call i64 @__mruntime_rt_list_resid__flat_fill(i64 %p0, i64 %p1, i64 %t7631, i64 %t7658, i64 %t7632, i64 %p2, i64 %p3)
ret i64 %t7666
L2235:
%t7667 = add i64 %t7631, 24
%t7668 = call i64 @ltype(i64 %p1)
%t7669 = call i64 @__mruntime_rt_list_resid__trie_from_items(i64 %t7667, i64 %t7632, i64 %t7668)
%t7670 = tail call i64 @__mruntime_rt_list_resid__trie_append(i64 %p0, i64 %t7669, i64 %p2, i64 %p3)
ret i64 %t7670
L2229:
%t7671 = tail call i64 @__mruntime_rt_list_resid__trie_append(i64 %p0, i64 %p1, i64 %p2, i64 %p3)
ret i64 %t7671
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
%t7672 = add i64 %p3, 24
%t7673 = mul i64 %p4, 8
%t7674 = add i64 %t7672, %t7673
%t7675 = mul i64 %p6, 8
%t7676 = call i64 @mcopy(i64 %t7674, i64 %p5, i64 %t7675)
%t7677 = icmp ne i64 %p3, %p2
br i1 %t7677, label %L2242, label %L2243
L2242:
%t7678 = add i64 %p4, %p6
%t7679 = call i64 @st64(i64 %p3, i64 %t7678)
br label %L2244
L2243:
br label %L2244
L2244:
%t7680 = phi i64 [ %t7679, %L2242 ], [ 0, %L2243 ]
%t7681 = icmp ne i64 %p0, 0
br i1 %t7681, label %L2245, label %L2246
L2245:
br label %L2247
L2246:
%t7682 = call i64 @list_hdr()
br label %L2247
L2247:
%t7683 = phi i64 [ %p0, %L2245 ], [ %t7682, %L2246 ]
%t7684 = add i64 %p4, %p6
%t7685 = sub nsw i64 0, 1
%t7686 = call i64 @ltype(i64 %p1)
%t7687 = call i64 @__mruntime_rt_list_resid__set_list(i64 %t7683, i64 %t7684, i64 %t7685, i64 %p3, i64 %t7686)
ret i64 %t7687
}
define internal i64 @__mruntime_rt_list_resid__trie_append(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7688 = icmp ne i64 %p0, 0
br i1 %t7688, label %L2248, label %L2249
L2248:
br label %L2250
L2249:
%t7689 = call i64 @list_hdr()
br label %L2250
L2250:
%t7690 = phi i64 [ %p0, %L2248 ], [ %t7689, %L2249 ]
%t7691 = icmp ne i64 %t7690, %p1
br i1 %t7691, label %L2251, label %L2252
L2251:
%t7692 = call i64 @lcount(i64 %p1)
%t7693 = call i64 @lshift(i64 %p1)
%t7694 = call i64 @lroot(i64 %p1)
%t7695 = call i64 @ltype(i64 %p1)
%t7696 = call i64 @__mruntime_rt_list_resid__set_list(i64 %t7690, i64 %t7692, i64 %t7693, i64 %t7694, i64 %t7695)
br label %L2253
L2252:
br label %L2253
L2253:
%t7697 = phi i64 [ %t7696, %L2251 ], [ 0, %L2252 ]
%t7698 = tail call i64 @__mruntime_rt_list_resid__trie_fill(i64 %t7690, i64 %p2, i64 %p3, i64 0)
ret i64 %t7698
}
define internal i64 @__mruntime_rt_list_resid__trie_fill(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t7736, %tco.s0 ]
%t7699 = icmp sge i64 %p3, %p2
br i1 %t7699, label %L2254, label %L2256
L2254:
ret i64 %p0
L2256:
%t7700 = call i64 @lcount(i64 %p0)
%t7701 = ashr i64 %t7700, 5
%t7702 = and i64 %t7700, 31
%t7703 = sub nsw i64 32, %t7702
%t7704 = sub i64 %p2, %p3
%t7705 = icmp slt i64 %t7703, %t7704
br i1 %t7705, label %L2257, label %L2258
L2257:
br label %L2259
L2258:
br label %L2259
L2259:
%t7706 = phi i64 [ %t7703, %L2257 ], [ %t7704, %L2258 ]
%t7707 = add i64 %t7702, %t7706
%t7708 = call i64 @__mruntime_rt_list_resid__node_new(i64 %t7707)
%t7709 = icmp sgt i64 %t7702, 0
br i1 %t7709, label %L2260, label %L2261
L2260:
%t7710 = add i64 %t7708, 8
%t7711 = call i64 @lroot(i64 %p0)
%t7712 = call i64 @lshift(i64 %p0)
%t7713 = call i64 @__mruntime_rt_list_resid__leaf_of(i64 %t7711, i64 %t7712, i64 %t7700)
%t7714 = add i64 %t7713, 8
%t7715 = mul nsw i64 %t7702, 8
%t7716 = call i64 @mcopy(i64 %t7710, i64 %t7714, i64 %t7715)
br label %L2262
L2261:
br label %L2262
L2262:
%t7717 = phi i64 [ %t7716, %L2260 ], [ 0, %L2261 ]
%t7718 = add i64 %t7708, 8
%t7719 = mul nsw i64 %t7702, 8
%t7720 = add i64 %t7718, %t7719
%t7721 = mul i64 %p3, 8
%t7722 = add i64 %p1, %t7721
%t7723 = mul i64 %t7706, 8
%t7724 = call i64 @mcopy(i64 %t7720, i64 %t7722, i64 %t7723)
%t7725 = call i64 @lroot(i64 %p0)
%t7726 = icmp eq i64 %t7725, 0
br i1 %t7726, label %L2263, label %L2264
L2263:
%t7727 = add i64 %p0, 16
%t7728 = call i64 @st64(i64 %t7727, i64 %t7708)
%t7729 = add i64 %p0, 8
%t7730 = call i64 @st32(i64 %t7729, i64 0)
%t7731 = add i64 %t7728, %t7730
br label %L2265
L2264:
%t7732 = call i64 @__mruntime_rt_list_resid__place_leaf(i64 %p0, i64 %t7700, i64 %t7701, i64 %t7708)
br label %L2265
L2265:
%t7733 = phi i64 [ %t7731, %L2263 ], [ %t7732, %L2264 ]
%t7734 = add i64 %t7700, %t7706
%t7735 = call i64 @st64(i64 %p0, i64 %t7734)
%t7736 = add i64 %p3, %t7706
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_list_resid__leaf_of(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t7747, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7748, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t7738 = icmp sle i64 %p1, 0
br i1 %t7738, label %L2266, label %L2268
L2266:
ret i64 %p0
L2268:
%t7739 = add i64 %p0, 8
%t7740 = icmp uge i64 %p1, 64
%t7741 = add i64 %p1, 0
%t7742 = select i1 %t7740, i64 63, i64 %t7741
%t7743 = ashr i64 %p2, %t7742
%t7744 = and i64 %t7743, 31
%t7745 = mul nsw i64 %t7744, 8
%t7746 = add i64 %t7739, %t7745
%t7747 = call i64 @ld64(i64 %t7746)
%t7748 = sub nsw i64 %p1, 5
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_list_resid__place_leaf(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7750 = call i64 @lshift(i64 %p0)
%t7751 = add i64 %t7750, 5
%t7752 = icmp uge i64 %t7751, 64
%t7753 = add i64 %t7751, 0
%t7754 = shl i64 1, %t7753
%t7755 = select i1 %t7752, i64 0, i64 %t7754
%t7756 = icmp sge i64 %p1, %t7755
br i1 %t7756, label %L2269, label %L2270
L2269:
%t7757 = call i64 @__mruntime_rt_list_resid__grow_root(i64 %p0)
br label %L2271
L2270:
br label %L2271
L2271:
%t7758 = phi i64 [ %t7757, %L2269 ], [ 0, %L2270 ]
%t7759 = call i64 @lshift(i64 %p0)
%t7760 = add i64 %p0, 16
%t7761 = icmp eq i64 %t7759, 0
br i1 %t7761, label %L2272, label %L2273
L2272:
br label %L2274
L2273:
%t7762 = call i64 @lroot(i64 %p0)
%t7763 = call i64 @__mruntime_rt_list_resid__set_leaf(i64 %t7762, i64 %t7759, i64 %p2, i64 %p3)
br label %L2274
L2274:
%t7764 = phi i64 [ %p3, %L2272 ], [ %t7763, %L2273 ]
%t7765 = call i64 @st64(i64 %t7760, i64 %t7764)
ret i64 %t7765
}
define internal i64 @__mruntime_rt_list_resid__grow_root(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7766 = call i64 @__mruntime_rt_list_resid__node_new(i64 1)
%t7767 = add i64 %t7766, 8
%t7768 = call i64 @lroot(i64 %p0)
%t7769 = call i64 @st64(i64 %t7767, i64 %t7768)
%t7770 = add i64 %p0, 16
%t7771 = call i64 @st64(i64 %t7770, i64 %t7766)
%t7772 = add i64 %p0, 8
%t7773 = call i64 @lshift(i64 %p0)
%t7774 = add i64 %t7773, 5
%t7775 = call i64 @st32(i64 %t7772, i64 %t7774)
ret i64 %t7775
}
define internal i64 @pvec_push(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7776p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.pvec_one)
%t7776 = ptrtoint ptr %t7776p to i64
%t7777 = call i64 @st64(i64 %t7776, i64 %p1)
%t7778 = call i64 @pvec_append_into(i64 0, i64 %p0, i64 %t7776, i64 1)
ret i64 %t7778
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
%t7779 = icmp slt i64 %p1, 32
br i1 %t7779, label %L2275, label %L2276
L2275:
br label %L2277
L2276:
br label %L2277
L2277:
%t7780 = phi i64 [ %p1, %L2275 ], [ 32, %L2276 ]
%t7781 = call i64 @__mruntime_rt_list_resid__node_new(i64 %t7780)
%t7782 = add i64 %t7781, 8
%t7783 = mul i64 %t7780, 8
%t7784 = call i64 @mcopy(i64 %t7782, i64 %p0, i64 %t7783)
%t7785 = call i64 @list_hdr()
%t7786 = call i64 @__mruntime_rt_list_resid__set_list(i64 %t7785, i64 %t7780, i64 0, i64 %t7781, i64 %p2)
%t7787 = icmp sgt i64 %p1, %t7780
br i1 %t7787, label %L2278, label %L2280
L2278:
%t7788 = mul i64 %t7780, 8
%t7789 = add i64 %p0, %t7788
%t7790 = sub i64 %p1, %t7780
%t7791 = call i64 @__mruntime_rt_list_resid__trie_append(i64 0, i64 %t7786, i64 %t7789, i64 %t7790)
ret i64 %t7791
L2280:
ret i64 %t7786
}
define internal i64 @rt_list_new(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7792p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.list_seed)
%t7792 = ptrtoint ptr %t7792p to i64
%t7793 = call i64 @__mruntime_rt_list_resid__set_list(i64 %t7792, i64 0, i64 0, i64 0, i64 %p2)
%t7794 = icmp eq i64 %p0, 0
br i1 %t7794, label %L2281, label %L2283
L2281:
%t7795 = call i64 @list_hdr()
%t7796 = call i64 @__mruntime_rt_list_resid__set_list(i64 %t7795, i64 0, i64 0, i64 0, i64 %p2)
ret i64 %t7796
L2283:
%t7797 = call i64 @pvec_append_into(i64 0, i64 %t7793, i64 %p1, i64 %p0)
ret i64 %t7797
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
%t7798 = tail call i64 @lcount(i64 %p0)
ret i64 %t7798
}
define i64 @resid_list_len(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_len(i64 %x0i)
ret i64 %r
}
define internal i64 @rt_list_get(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7799 = call i64 @lcount(i64 %p0)
%t7800 = call i1 @ult(i64 %p1, i64 %t7799)
%t7801 = xor i1 %t7800, true
br i1 %t7801, label %L2284, label %L2286
L2284:
%t7802 = call i64 @lcount(i64 %p0)
%t7803 = call i64 @rt_index_abort(i64 %p1, i64 %t7802, i64 0)
ret i64 %t7803
L2286:
%t7804 = tail call i64 @list_at(i64 %p0, i64 %p1)
ret i64 %t7804
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
%t7805 = tail call i64 @list_at(i64 %p0, i64 %p1)
ret i64 %t7805
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
%t7806 = tail call i64 @ltype(i64 %p0)
ret i64 %t7806
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
%t7807 = call i64 @lcount(i64 %p0)
%t7808 = icmp eq i64 %t7807, 0
br i1 %t7808, label %L2287, label %L2289
L2287:
ret i64 0
L2289:
%t7809 = mul i64 %t7807, 8
%t7810 = call i64 @xmalloc(i64 %t7809)
%t7811 = call i64 @lshift(i64 %p0)
%t7812 = sub nsw i64 0, 1
%t7813 = icmp eq i64 %t7811, %t7812
br i1 %t7813, label %L2290, label %L2291
L2290:
%t7814 = call i64 @lroot(i64 %p0)
%t7815 = add i64 %t7814, 24
%t7816 = mul i64 %t7807, 8
%t7817 = call i64 @mcopy(i64 %t7810, i64 %t7815, i64 %t7816)
br label %L2292
L2291:
%t7818 = call i64 @__mruntime_rt_list_resid__array_from_trie(i64 %p0, i64 %t7810, i64 0, i64 %t7807)
br label %L2292
L2292:
%t7819 = phi i64 [ %t7817, %L2290 ], [ %t7818, %L2291 ]
ret i64 %t7810
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t7825, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t7820 = icmp sge i64 %p2, %p3
br i1 %t7820, label %L2293, label %L2295
L2293:
ret i64 0
L2295:
%t7821 = mul i64 %p2, 8
%t7822 = add i64 %p1, %t7821
%t7823 = call i64 @list_at(i64 %p0, i64 %p2)
%t7824 = call i64 @st64(i64 %t7822, i64 %t7823)
%t7825 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_concat(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7827 = call i64 @lcount(i64 %p1)
%t7828 = icmp eq i64 %t7827, 0
br i1 %t7828, label %L2296, label %L2298
L2296:
ret i64 %p0
L2298:
%t7829 = icmp eq i64 %t7827, 1
br i1 %t7829, label %L2299, label %L2301
L2299:
%t7830 = call i64 @list_at(i64 %p1, i64 0)
%t7831 = tail call i64 @pvec_push(i64 %p0, i64 %t7830)
ret i64 %t7831
L2301:
%t7832 = call i64 @lshift(i64 %p1)
%t7833 = sub nsw i64 0, 1
%t7834 = icmp eq i64 %t7832, %t7833
br i1 %t7834, label %L2302, label %L2304
L2302:
%t7835 = call i64 @lroot(i64 %p1)
%t7836 = add i64 %t7835, 24
%t7837 = call i64 @pvec_append_into(i64 0, i64 %p0, i64 %t7836, i64 %t7827)
ret i64 %t7837
L2304:
%t7838 = call i64 @rt_list_to_array(i64 %p1)
%t7839 = call i64 @pvec_append_into(i64 0, i64 %p0, i64 %t7838, i64 %t7827)
%t7840 = call i64 @c_free(i64 %t7838)
%t7841 = mul nsw i64 %t7840, 0
%t7842 = add nsw i64 %t7841, %t7839
ret i64 %t7842
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
%t7843 = tail call i64 @pvec_push(i64 %p0, i64 %p1)
ret i64 %t7843
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
%t7844 = call i64 @list_hdr()
%t7845 = sub nsw i64 0, 1
%t7846 = call i64 @__mruntime_rt_list_resid__set_list(i64 %t7844, i64 0, i64 %t7845, i64 0, i64 0)
ret i64 %t7846
}
define ptr @resid_listbuf_new() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_listbuf_new()
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_listbuf_push(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7847 = call i64 @lcount(i64 %p0)
%t7848 = call i64 @lroot(i64 %p0)
%t7849 = icmp eq i64 %t7848, 0
br label %LSL7850
LSL7850:
br i1 %t7849, label %LSJ7850, label %LSR7850
LSR7850:
%t7851 = add i64 %t7848, 8
%t7852 = call i64 @ld64(i64 %t7851)
%t7853 = icmp sge i64 %t7847, %t7852
br label %LSJ7850
LSJ7850:
%t7854 = phi i1 [ true, %LSL7850 ], [ %t7853, %LSR7850 ]
br i1 %t7854, label %L2305, label %L2306
L2305:
%t7855 = call i64 @__mruntime_rt_list_resid__lb_grow(i64 %p0, i64 %t7848, i64 %t7847)
br label %L2307
L2306:
br label %L2307
L2307:
%t7856 = phi i64 [ %t7855, %L2305 ], [ %t7848, %L2306 ]
%t7857 = add i64 %t7856, 24
%t7858 = mul i64 %t7847, 8
%t7859 = add i64 %t7857, %t7858
%t7860 = call i64 @st64(i64 %t7859, i64 %p1)
%t7861 = add i64 %t7847, 1
%t7862 = call i64 @st64(i64 %p0, i64 %t7861)
%t7863 = add i64 %t7847, 1
%t7864 = call i64 @st64(i64 %t7856, i64 %t7863)
%t7865 = mul nsw i64 %t7864, 0
%t7866 = add nsw i64 %t7865, %p0
ret i64 %t7866
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
%t7867 = icmp slt i64 %p2, 4
br i1 %t7867, label %L2308, label %L2309
L2308:
br label %L2310
L2309:
%t7868 = mul i64 %p2, 2
br label %L2310
L2310:
%t7869 = phi i64 [ 8, %L2308 ], [ %t7868, %L2309 ]
%t7870 = call i64 @flat_new(i64 %t7869)
%t7871 = icmp sgt i64 %p2, 0
br i1 %t7871, label %L2311, label %L2312
L2311:
%t7872 = add i64 %t7870, 24
%t7873 = add i64 %p1, 24
%t7874 = mul i64 %p2, 8
%t7875 = call i64 @mcopy(i64 %t7872, i64 %t7873, i64 %t7874)
br label %L2313
L2312:
br label %L2313
L2313:
%t7876 = phi i64 [ %t7875, %L2311 ], [ 0, %L2312 ]
%t7877 = add i64 %p0, 16
%t7878 = call i64 @st64(i64 %t7877, i64 %t7870)
%t7879 = mul nsw i64 %t7878, 0
%t7880 = add nsw i64 %t7879, %t7870
ret i64 %t7880
}
define internal i64 @rt_listbuf_finish(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7881 = add i64 %p0, 24
%t7882 = call i64 @st64(i64 %t7881, i64 %p1)
%t7883 = call i64 @lroot(i64 %p0)
%t7884 = icmp eq i64 %t7883, 0
br i1 %t7884, label %L2314, label %L2315
L2314:
%t7885 = add i64 %p0, 8
%t7886 = call i64 @st32(i64 %t7885, i64 0)
br label %L2316
L2315:
br label %L2316
L2316:
%t7887 = phi i64 [ %t7886, %L2314 ], [ 0, %L2315 ]
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
%t7888 = icmp sgt i64 %p1, 0
br i1 %t7888, label %L2317, label %L2318
L2317:
br label %L2319
L2318:
br label %L2319
L2319:
%t7889 = phi i64 [ %p1, %L2317 ], [ 0, %L2318 ]
%t7890 = call i64 @lcount(i64 %p0)
%t7891 = icmp slt i64 %p2, %t7890
br i1 %t7891, label %L2320, label %L2321
L2320:
br label %L2322
L2321:
br label %L2322
L2322:
%t7892 = phi i64 [ %p2, %L2320 ], [ %t7890, %L2321 ]
%t7893 = sub i64 %t7892, %t7889
%t7894 = icmp sgt i64 %t7893, 0
br i1 %t7894, label %L2323, label %L2324
L2323:
br label %L2325
L2324:
br label %L2325
L2325:
%t7895 = phi i64 [ %t7893, %L2323 ], [ 0, %L2324 ]
%t7896 = icmp sgt i64 %t7895, 0
br label %LSL7897
LSL7897:
br i1 %t7896, label %LSR7897, label %LSJ7897
LSR7897:
%t7898 = call i64 @lshift(i64 %p0)
%t7899 = sub nsw i64 0, 1
%t7900 = icmp eq i64 %t7898, %t7899
br label %LSJ7897
LSJ7897:
%t7901 = phi i1 [ false, %LSL7897 ], [ %t7900, %LSR7897 ]
br i1 %t7901, label %L2326, label %L2328
L2326:
%t7902 = call i64 @lroot(i64 %p0)
%t7903 = add i64 %t7902, 24
%t7904 = mul i64 %t7889, 8
%t7905 = add i64 %t7903, %t7904
%t7906 = call i64 @ltype(i64 %p0)
%t7907 = tail call i64 @rt_list_new(i64 %t7895, i64 %t7905, i64 %t7906)
ret i64 %t7907
L2328:
%t7908 = icmp sgt i64 %t7895, 1
br i1 %t7908, label %L2329, label %L2330
L2329:
br label %L2331
L2330:
br label %L2331
L2331:
%t7909 = phi i64 [ %t7895, %L2329 ], [ 1, %L2330 ]
%t7910 = mul i64 %t7909, 8
%t7911 = call i64 @xmalloc(i64 %t7910)
%t7912 = call i64 @__mruntime_rt_list_resid__slice_fill(i64 %p0, i64 %t7911, i64 %t7889, i64 0, i64 %t7895)
%t7913 = call i64 @ltype(i64 %p0)
%t7914 = call i64 @rt_list_new(i64 %t7895, i64 %t7911, i64 %t7913)
%t7915 = call i64 @c_free(i64 %t7911)
%t7916 = mul nsw i64 %t7915, 0
%t7917 = add nsw i64 %t7916, %t7914
ret i64 %t7917
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t7924, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t7918 = icmp sge i64 %p3, %p4
br i1 %t7918, label %L2332, label %L2334
L2332:
ret i64 0
L2334:
%t7919 = mul i64 %p3, 8
%t7920 = add i64 %p1, %t7919
%t7921 = add i64 %p2, %p3
%t7922 = call i64 @list_at(i64 %p0, i64 %t7921)
%t7923 = call i64 @st64(i64 %t7920, i64 %t7922)
%t7924 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_range_list(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7926 = icmp sgt i64 %p1, %p0
br i1 %t7926, label %L2335, label %L2336
L2335:
%t7927 = sub i64 %p1, %p0
br label %L2337
L2336:
br label %L2337
L2337:
%t7928 = phi i64 [ %t7927, %L2335 ], [ 0, %L2336 ]
%t7929 = icmp slt i64 %t7928, 0
br label %LSL7930
LSL7930:
br i1 %t7929, label %LSJ7930, label %LSR7930
LSR7930:
%t7931 = icmp sgt i64 %t7928, 1152921504606846975
br label %LSJ7930
LSJ7930:
%t7932 = phi i1 [ true, %LSL7930 ], [ %t7931, %LSR7930 ]
br i1 %t7932, label %L2338, label %L2340
L2338:
%t7934 = call i64 @rt_abort(ptr @.s7933)
ret i64 %t7934
L2340:
%t7935 = icmp sgt i64 %t7928, 1
br i1 %t7935, label %L2341, label %L2342
L2341:
br label %L2343
L2342:
br label %L2343
L2343:
%t7936 = phi i64 [ %t7928, %L2341 ], [ 1, %L2342 ]
%t7937 = mul i64 %t7936, 8
%t7938 = call i64 @xmalloc(i64 %t7937)
%t7939 = call i64 @__mruntime_rt_list_resid__range_fill(i64 %t7938, i64 %p0, i64 0, i64 %t7928)
%t7941 = ptrtoint ptr @.s7940 to i64
%t7942 = call i64 @rt_list_new(i64 %t7928, i64 %t7938, i64 %t7941)
%t7943 = call i64 @c_free(i64 %t7938)
%t7944 = mul nsw i64 %t7943, 0
%t7945 = add nsw i64 %t7944, %t7942
ret i64 %t7945
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t7952, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t7946 = icmp sge i64 %p2, %p3
br i1 %t7946, label %L2344, label %L2346
L2344:
ret i64 0
L2346:
%t7947 = mul i64 %p2, 8
%t7948 = add i64 %p0, %t7947
%t7949 = add i64 %p1, %p2
%t7950 = call i64 @c_box_i64(i64 %t7949)
%t7951 = call i64 @st64(i64 %t7948, i64 %t7950)
%t7952 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_range_list_incl(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7954 = icmp eq i64 %p1, 9223372036854775807
br i1 %t7954, label %L2347, label %L2349
L2347:
%t7956 = call i64 @rt_abort(ptr @.s7955)
ret i64 %t7956
L2349:
%t7957 = add i64 %p1, 1
%t7958 = tail call i64 @rt_range_list(i64 %p0, i64 %t7957)
ret i64 %t7958
}
define ptr @resid_range_list_incl(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_range_list_incl(i64 %a0, i64 %a1)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_assert(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t7959 = icmp ne i64 %p0, 0
br i1 %t7959, label %L2350, label %L2352
L2350:
ret i64 0
L2352:
%t7960 = call i64 @rt_sb_new()
%t7962 = ptrtoint ptr @.s7961 to i64
%t7963 = call i64 @sb_lit(i64 %t7960, i64 %t7962)
%t7964 = icmp ne i64 %p1, 0
br i1 %t7964, label %L2353, label %L2354
L2353:
%t7966 = ptrtoint ptr @.s7965 to i64
%t7967 = call i64 @sb_lit(i64 %t7960, i64 %t7966)
%t7968 = call i64 @sb_lit(i64 %t7960, i64 %p1)
%t7969 = add i64 %t7967, %t7968
br label %L2355
L2354:
br label %L2355
L2355:
%t7970 = phi i64 [ %t7969, %L2353 ], [ 0, %L2354 ]
%t7971 = call i64 @rt_sb_finish(i64 %t7960)
%t7972 = call i64 @rt_abort_msg(i64 %t7971)
ret i64 %t7972
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
%t7973 = call i64 @rt_sb_new()
%t7974 = icmp ne i64 %p0, 0
br i1 %t7974, label %L2356, label %L2357
L2356:
%t7976 = ptrtoint ptr @.s7975 to i64
br label %L2358
L2357:
%t7978 = ptrtoint ptr @.s7977 to i64
br label %L2358
L2358:
%t7979 = phi i64 [ %t7976, %L2356 ], [ %t7978, %L2357 ]
%t7980 = call i64 @sb_lit(i64 %t7973, i64 %t7979)
%t7981 = icmp ne i64 %p1, 0
br i1 %t7981, label %L2359, label %L2360
L2359:
%t7983 = ptrtoint ptr @.s7982 to i64
%t7984 = call i64 @sb_lit(i64 %t7973, i64 %t7983)
%t7985 = call i64 @sb_lit(i64 %t7973, i64 %p1)
%t7986 = add i64 %t7984, %t7985
br label %L2361
L2360:
br label %L2361
L2361:
%t7987 = phi i64 [ %t7986, %L2359 ], [ 0, %L2360 ]
%t7988 = call i64 @rt_sb_finish(i64 %t7973)
%t7989 = call i64 @rt_abort_msg(i64 %t7988)
ret i64 %t7989
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
%t7990 = call i64 @lcount(i64 %p0)
%t7991 = call i64 @xmalloc(i64 24)
%t7992 = icmp slt i64 %t7990, 4
br i1 %t7992, label %L2362, label %L2363
L2362:
br label %L2364
L2363:
%t7993 = mul i64 %t7990, 2
br label %L2364
L2364:
%t7994 = phi i64 [ 4, %L2362 ], [ %t7993, %L2363 ]
%t7995 = mul i64 %t7994, 8
%t7996 = call i64 @xmalloc(i64 %t7995)
%t7997 = call i64 @rt_list_to_array(i64 %p0)
%t7998 = icmp sgt i64 %t7990, 0
br i1 %t7998, label %L2365, label %L2366
L2365:
%t7999 = mul i64 %t7990, 8
%t8000 = call i64 @mcopy(i64 %t7996, i64 %t7997, i64 %t7999)
br label %L2367
L2366:
br label %L2367
L2367:
%t8001 = phi i64 [ %t8000, %L2365 ], [ 0, %L2366 ]
%t8002 = call i64 @c_free(i64 %t7997)
%t8003 = call i64 @st64(i64 %t7991, i64 %t7990)
%t8004 = add i64 %t7991, 8
%t8005 = call i64 @st64(i64 %t8004, i64 %t7994)
%t8006 = add i64 %t7991, 16
%t8007 = call i64 @st64(i64 %t8006, i64 %t7996)
%t8008 = mul nsw i64 %t8007, 0
%t8009 = add nsw i64 %t8008, %t7991
ret i64 %t8009
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
%t8010 = call i64 @lcount(i64 %p1)
%t8011 = call i64 @ld64(i64 %p0)
%t8012 = add i64 %t8011, %t8010
%t8013 = add i64 %p0, 8
%t8014 = call i64 @ld64(i64 %t8013)
%t8015 = icmp sgt i64 %t8012, %t8014
br i1 %t8015, label %L2368, label %L2369
L2368:
%t8016 = call i64 @__mruntime_rt_list_resid__gb_grow(i64 %p0, i64 %t8012)
br label %L2370
L2369:
br label %L2370
L2370:
%t8017 = phi i64 [ %t8016, %L2368 ], [ 0, %L2369 ]
%t8018 = call i64 @rt_list_to_array(i64 %p1)
%t8019 = icmp sgt i64 %t8010, 0
br i1 %t8019, label %L2371, label %L2372
L2371:
%t8020 = add i64 %p0, 16
%t8021 = call i64 @ld64(i64 %t8020)
%t8022 = call i64 @ld64(i64 %p0)
%t8023 = mul i64 %t8022, 8
%t8024 = add i64 %t8021, %t8023
%t8025 = mul i64 %t8010, 8
%t8026 = call i64 @mcopy(i64 %t8024, i64 %t8018, i64 %t8025)
br label %L2373
L2372:
br label %L2373
L2373:
%t8027 = phi i64 [ %t8026, %L2371 ], [ 0, %L2372 ]
%t8028 = call i64 @c_free(i64 %t8018)
%t8029 = call i64 @st64(i64 %p0, i64 %t8012)
%t8030 = mul nsw i64 %t8029, 0
%t8031 = add nsw i64 %t8030, %p0
ret i64 %t8031
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
%t8032 = add i64 %p0, 8
%t8033 = call i64 @ld64(i64 %t8032)
%t8034 = mul i64 %t8033, 2
%t8035 = icmp sgt i64 %t8034, %p1
br i1 %t8035, label %L2374, label %L2375
L2374:
br label %L2376
L2375:
br label %L2376
L2376:
%t8036 = phi i64 [ %t8034, %L2374 ], [ %p1, %L2375 ]
%t8037 = add i64 %p0, 16
%t8038 = add i64 %p0, 16
%t8039 = call i64 @ld64(i64 %t8038)
%t8040 = mul i64 %t8036, 8
%t8041 = call i64 @xrealloc(i64 %t8039, i64 %t8040)
%t8042 = call i64 @st64(i64 %t8037, i64 %t8041)
%t8043 = add i64 %p0, 8
%t8044 = tail call i64 @st64(i64 %t8043, i64 %t8036)
ret i64 %t8044
}
define internal i64 @rt_growbuf_finish(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8045 = call i64 @ld64(i64 %p0)
%t8046 = add i64 %p0, 16
%t8047 = call i64 @ld64(i64 %t8046)
%t8048 = call i64 @rt_list_new(i64 %t8045, i64 %t8047, i64 %p1)
%t8049 = add i64 %p0, 16
%t8050 = call i64 @ld64(i64 %t8049)
%t8051 = call i64 @c_free(i64 %t8050)
%t8052 = call i64 @c_free(i64 %p0)
%t8053 = add i64 %t8051, %t8052
ret i64 %t8048
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
%t8054 = call i64 @c_box_interned(i64 %p0)
%t8055 = icmp ne i64 %t8054, 0
br i1 %t8055, label %L2377, label %L2378
L2377:
br label %L2379
L2378:
%t8056 = call i64 @c_free(i64 %p0)
br label %L2379
L2379:
%t8057 = phi i64 [ 0, %L2377 ], [ %t8056, %L2378 ]
ret i64 %t8057
}
define internal i64 @__mruntime_rt_list_resid__free_node(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8058 = icmp eq i64 %p0, 0
br i1 %t8058, label %L2380, label %L2382
L2380:
ret i64 0
L2382:
%t8059 = call i64 @ld64(i64 %p0)
%t8060 = call i64 @__mruntime_rt_list_resid__free_kids(i64 %p0, i64 %p1, i64 0, i64 %t8059)
%t8061 = call i64 @c_free(i64 %p0)
ret i64 %t8061
}
define internal i64 @__mruntime_rt_list_resid__free_kids(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8074, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t8062 = icmp sge i64 %p2, %p3
br i1 %t8062, label %L2383, label %L2385
L2383:
ret i64 0
L2385:
%t8063 = add i64 %p0, 8
%t8064 = mul i64 %p2, 8
%t8065 = add i64 %t8063, %t8064
%t8066 = call i64 @ld64(i64 %t8065)
%t8067 = icmp eq i64 %p1, 0
br i1 %t8067, label %L2386, label %L2387
L2386:
%t8068 = icmp ne i64 %t8066, 0
br i1 %t8068, label %L2389, label %L2390
L2389:
%t8069 = call i64 @__mruntime_rt_list_resid__box_free_shallow(i64 %t8066)
br label %L2391
L2390:
br label %L2391
L2391:
%t8070 = phi i64 [ %t8069, %L2389 ], [ 0, %L2390 ]
br label %L2388
L2387:
%t8071 = sub i64 %p1, 5
%t8072 = call i64 @__mruntime_rt_list_resid__free_node(i64 %t8066, i64 %t8071)
br label %L2388
L2388:
%t8073 = phi i64 [ %t8070, %L2391 ], [ %t8072, %L2387 ]
%t8074 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_free(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8076 = icmp eq i64 %p0, 0
br i1 %t8076, label %L2392, label %L2394
L2392:
ret i64 0
L2394:
%t8077 = call i64 @lroot(i64 %p0)
%t8078 = icmp ne i64 %t8077, 0
br label %LSL8079
LSL8079:
br i1 %t8078, label %LSR8079, label %LSJ8079
LSR8079:
%t8080 = call i64 @lshift(i64 %p0)
%t8081 = sub nsw i64 0, 1
%t8082 = icmp ne i64 %t8080, %t8081
br label %LSJ8079
LSJ8079:
%t8083 = phi i1 [ false, %LSL8079 ], [ %t8082, %LSR8079 ]
br i1 %t8083, label %L2395, label %L2396
L2395:
%t8084 = call i64 @lroot(i64 %p0)
%t8085 = call i64 @lshift(i64 %p0)
%t8086 = call i64 @__mruntime_rt_list_resid__free_node(i64 %t8084, i64 %t8085)
br label %L2397
L2396:
br label %L2397
L2397:
%t8087 = phi i64 [ %t8086, %L2395 ], [ 0, %L2396 ]
%t8088 = tail call i64 @c_free(i64 %p0)
ret i64 %t8088
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t8101, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i1 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t8089 = icmp sge i64 %p1, %p2
br i1 %t8089, label %L2398, label %L2400
L2398:
ret i64 0
L2400:
%t8090 = add i64 %p0, 16
%t8091 = mul i64 %p1, 8
%t8092 = add i64 %t8090, %t8091
%t8093 = call i64 @ld64(i64 %t8092)
%t8094 = icmp ne i64 %t8093, 0
br label %LSL8095
LSL8095:
br i1 %t8094, label %LSR8095, label %LSJ8095
LSR8095:
%t8096 = call i64 @c_box_interned(i64 %t8093)
%t8097 = icmp eq i64 %t8096, 0
br label %LSJ8095
LSJ8095:
%t8098 = phi i1 [ false, %LSL8095 ], [ %t8097, %LSR8095 ]
br i1 %t8098, label %L2401, label %L2402
L2401:
%t8099 = call i64 @c_free(i64 %t8093)
br label %L2403
L2402:
br label %L2403
L2403:
%t8100 = phi i64 [ %t8099, %L2401 ], [ 0, %L2402 ]
%t8101 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_struct_free(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8103 = icmp eq i64 %p0, 0
br i1 %t8103, label %L2404, label %L2406
L2404:
ret i64 0
L2406:
%t8104 = call i64 @box_count(i64 %p0)
%t8105 = call i64 @__mruntime_rt_list_resid__free_slots(i64 %p0, i64 0, i64 %t8104, i1 false)
%t8106 = tail call i64 @c_free(i64 %p0)
ret i64 %t8106
}
define void @resid_struct_free(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_struct_free(i64 %x0i)
ret void
}
define internal i64 @rt_box_free(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8107 = icmp eq i64 %p0, 0
br label %LSL8108
LSL8108:
br i1 %t8107, label %LSJ8108, label %LSR8108
LSR8108:
%t8109 = call i64 @c_box_interned(i64 %p0)
%t8110 = icmp ne i64 %t8109, 0
br label %LSJ8108
LSJ8108:
%t8111 = phi i1 [ true, %LSL8108 ], [ %t8110, %LSR8108 ]
br i1 %t8111, label %L2407, label %L2409
L2407:
ret i64 0
L2409:
%t8112 = call i64 @box_tag(i64 %p0)
%t8113 = sub nsw i64 0, 1
%t8114 = icmp ne i64 %t8112, %t8113
br i1 %t8114, label %L2410, label %L2411
L2410:
%t8115 = call i64 @box_count(i64 %p0)
%t8116 = call i64 @__mruntime_rt_list_resid__free_slots(i64 %p0, i64 0, i64 %t8115, i1 true)
br label %L2412
L2411:
br label %L2412
L2412:
%t8117 = phi i64 [ %t8116, %L2410 ], [ 0, %L2411 ]
%t8118 = tail call i64 @c_free(i64 %p0)
ret i64 %t8118
}
define void @resid_box_free(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_box_free(i64 %x0i)
ret void
}
define internal i64 @__mruntime_rt_map_resid__ld_i8(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8119 = call i64 @ld8(i64 %p0)
%t8120 = tail call i64 @sx8(i64 %t8119)
ret i64 %t8120
}
define internal i64 @__mruntime_rt_map_resid__popc(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8121 = tail call i64 @llvm.ctpop.i64(i64 %p0)
ret i64 %t8121
}
define internal i64 @__mruntime_rt_map_resid__mret() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8122p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_ret)
%t8122 = ptrtoint ptr %t8122p to i64
ret i64 %t8122
}
define internal i64 @__mruntime_rt_map_resid__mflag() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8123p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_flag)
%t8123 = ptrtoint ptr %t8123p to i64
ret i64 %t8123
}
define internal i64 @__mruntime_rt_map_resid__ret_word(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8124 = call i64 @__mruntime_rt_map_resid__mret()
%t8125 = call i64 @st64(i64 %t8124, i64 %p0)
%t8126 = mul nsw i64 %t8125, 0
%t8127 = add nsw i64 %t8126, 1
ret i64 %t8127
}
define internal i64 @__mruntime_rt_map_resid__map_heap_w() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8128p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_heap)
%t8128 = ptrtoint ptr %t8128p to i64
ret i64 %t8128
}
define internal i1 @__mruntime_rt_map_resid__map_heap() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8129 = call i64 @__mruntime_rt_map_resid__map_heap_w()
%t8130 = call i64 @ld64(i64 %t8129)
%t8131 = icmp ne i64 %t8130, 0
ret i1 %t8131
}
define internal i64 @__mruntime_rt_map_resid__sc_depth() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8132 = tail call i64 @c_sc_depth()
ret i64 %t8132
}
define internal i1 @__mruntime_rt_map_resid__in_region(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8133 = call i64 @c_sc_depth()
%t8134 = icmp ne i64 %t8133, 0
br label %LSL8135
LSL8135:
br i1 %t8134, label %LSR8135, label %LSJ8135
LSR8135:
%t8136 = call i64 @c_in_scope(i64 %p0)
%t8137 = icmp ne i64 %t8136, 0
br label %LSJ8135
LSJ8135:
%t8138 = phi i1 [ false, %LSL8135 ], [ %t8137, %LSR8135 ]
ret i1 %t8138
}
define internal i64 @__mruntime_rt_map_resid__map_obj(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8139 = call i1 @__mruntime_rt_map_resid__map_heap()
%t8140 = xor i1 %t8139, true
br label %LSL8141
LSL8141:
br i1 %t8140, label %LSR8141, label %LSJ8141
LSR8141:
%t8142 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t8143 = icmp ne i64 %t8142, 0
br label %LSJ8141
LSJ8141:
%t8144 = phi i1 [ false, %LSL8141 ], [ %t8143, %LSR8141 ]
br i1 %t8144, label %L2413, label %L2415
L2413:
%t8145 = tail call i64 @c_scope_alloc(i64 %p0)
ret i64 %t8145
L2415:
%t8146 = tail call i64 @xmalloc(i64 %p0)
ret i64 %t8146
}
define internal i64 @__mruntime_rt_map_resid__map_obj_free(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8147 = icmp ne i64 %p0, 0
br label %LSL8148
LSL8148:
br i1 %t8147, label %LSR8148, label %LSJ8148
LSR8148:
%t8149 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t8150 = xor i1 %t8149, true
br label %LSJ8148
LSJ8148:
%t8151 = phi i1 [ false, %LSL8148 ], [ %t8150, %LSR8148 ]
br i1 %t8151, label %L2416, label %L2417
L2416:
%t8152 = call i64 @c_free(i64 %p0)
br label %L2418
L2417:
br label %L2418
L2418:
%t8153 = phi i64 [ %t8152, %L2416 ], [ 0, %L2417 ]
ret i64 %t8153
}
define internal i64 @__mruntime_rt_map_resid__raw_empty() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8154 = sext i64 0 to i128
%t8155 = sub i128 %t8154, 9223372036854775807
%t8156 = sext i64 1 to i128
%t8157 = sub i128 %t8155, %t8156
%t8158 = trunc i128 %t8157 to i64
ret i64 %t8158
}
define internal i64 @__mruntime_rt_map_resid__raw_tomb() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8159 = sext i64 0 to i128
%t8160 = sub i128 %t8159, 9223372036854775807
%t8161 = trunc i128 %t8160 to i64
ret i64 %t8161
}
define internal i64 @__mruntime_rt_map_resid__fnv_off() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8162 = sext i64 0 to i128
%t8163 = sub i128 %t8162, 3750763034362895579
%t8164 = trunc i128 %t8163 to i64
ret i64 %t8164
}
define internal i64 @__mruntime_rt_map_resid__fnv_p() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 1099511628211
}
define internal i64 @__mruntime_rt_map_resid__fnv_str(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8165 = call i64 @__mruntime_rt_map_resid__fnv_off()
%t8166 = call i64 @__mruntime_rt_map_resid__fnv_from(i64 %t8165, i64 %p0)
ret i64 %t8166
}
define internal i64 @__mruntime_rt_map_resid__fnv_from(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t8171, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8172, %tco.s0 ]
%t8167 = call i64 @ld8(i64 %p1)
%t8168 = icmp eq i64 %t8167, 0
br i1 %t8168, label %L2419, label %L2421
L2419:
ret i64 %p0
L2421:
%t8169 = xor i64 %p0, %t8167
%t8170 = call i64 @__mruntime_rt_map_resid__fnv_p()
%t8171 = mul i64 %t8169, %t8170
%t8172 = add i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__fnv_dec(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8174 = sdiv i64 %p1, 10
%t8175 = icmp sgt i64 %t8174, 0
br i1 %t8175, label %L2422, label %L2423
L2422:
%t8176 = call i64 @__mruntime_rt_map_resid__fnv_dec(i64 %p0, i64 %t8174)
br label %L2424
L2423:
br label %L2424
L2424:
%t8177 = phi i64 [ %t8176, %L2422 ], [ %p0, %L2423 ]
%t8178 = add i64 48, %p1
%t8179 = mul nsw i64 %t8174, 10
%t8180 = sub i64 %t8178, %t8179
%t8181 = xor i64 %t8177, %t8180
%t8182 = call i64 @__mruntime_rt_map_resid__fnv_p()
%t8183 = mul i64 %t8181, %t8182
ret i64 %t8183
}
define internal i64 @__mruntime_rt_map_resid__fnv_i64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8184 = icmp slt i64 %p0, 0
br i1 %t8184, label %L2425, label %L2426
L2425:
%t8185 = call i64 @__mruntime_rt_map_resid__fnv_off()
%t8186 = xor i64 %t8185, 45
%t8187 = call i64 @__mruntime_rt_map_resid__fnv_p()
%t8188 = mul i64 %t8186, %t8187
br label %L2427
L2426:
%t8189 = call i64 @__mruntime_rt_map_resid__fnv_off()
br label %L2427
L2427:
%t8190 = phi i64 [ %t8188, %L2425 ], [ %t8189, %L2426 ]
%t8191 = call i64 @__mruntime_rt_map_resid__raw_empty()
%t8192 = icmp eq i64 %p0, %t8191
br i1 %t8192, label %L2428, label %L2430
L2428:
%t8193 = call i64 @__mruntime_rt_map_resid__fnv_dec(i64 %t8190, i64 922337203685477580)
%t8194 = xor i64 %t8193, 56
%t8195 = call i64 @__mruntime_rt_map_resid__fnv_p()
%t8196 = mul i64 %t8194, %t8195
ret i64 %t8196
L2430:
%t8197 = icmp slt i64 %p0, 0
br i1 %t8197, label %L2431, label %L2432
L2431:
%t8198 = sub i64 0, %p0
br label %L2433
L2432:
br label %L2433
L2433:
%t8199 = phi i64 [ %t8198, %L2431 ], [ %p0, %L2432 ]
%t8200 = call i64 @__mruntime_rt_map_resid__fnv_dec(i64 %t8190, i64 %t8199)
ret i64 %t8200
}
define internal i64 @__mruntime_rt_map_resid__fnv_f64(double %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8201p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_fbuf)
%t8201 = ptrtoint ptr %t8201p to i64
%t8203 = ptrtoint ptr @.s8202 to i64
%t8204 = call i64 @c_strfromd(i64 %t8201, i64 64, i64 %t8203, double %p0)
%t8205 = call i64 @__mruntime_rt_map_resid__fnv_str(i64 %t8201)
ret i64 %t8205
}
define internal i1 @__mruntime_rt_map_resid__is_boxed(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8206 = call i1 @box_imm(i64 %p0)
br label %LSL8207
LSL8207:
br i1 %t8206, label %LSJ8207, label %LSR8207
LSR8207:
%t8208 = call i1 @box_fimm(i64 %p0)
br label %LSJ8207
LSJ8207:
%t8209 = phi i1 [ true, %LSL8207 ], [ %t8208, %LSR8207 ]
br label %LSL8210
LSL8210:
br i1 %t8209, label %LSJ8210, label %LSR8210
LSR8210:
%t8211 = call i64 @ld8(i64 %p0)
%t8212 = icmp eq i64 %t8211, 255
br label %LSJ8210
LSJ8210:
%t8213 = phi i1 [ true, %LSL8210 ], [ %t8212, %LSR8210 ]
ret i1 %t8213
}
define internal i1 @__mruntime_rt_map_resid__type_is(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8214 = icmp ne i64 %p0, 0
br label %LSL8215
LSL8215:
br i1 %t8214, label %LSR8215, label %LSJ8215
LSR8215:
%t8216 = call i64 @c_strcmp(i64 %p0, i64 %p1)
%t8217 = icmp eq i64 %t8216, 0
br label %LSJ8215
LSJ8215:
%t8218 = phi i1 [ false, %LSL8215 ], [ %t8217, %LSR8215 ]
ret i1 %t8218
}
define internal i64 @__mruntime_rt_map_resid__stype(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8219 = call i1 @box_imm(i64 %p0)
br i1 %t8219, label %L2434, label %L2436
L2434:
ret i64 1
L2436:
%t8220 = call i1 @box_fimm(i64 %p0)
br i1 %t8220, label %L2437, label %L2439
L2437:
ret i64 2
L2439:
%t8221 = call i64 @box_tag(i64 %p0)
%t8222 = sub nsw i64 0, 1
%t8223 = icmp ne i64 %t8221, %t8222
br i1 %t8223, label %L2440, label %L2442
L2440:
ret i64 0
L2442:
%t8224 = call i64 @box_type(i64 %p0)
%t8226 = ptrtoint ptr @.s8225 to i64
%t8227 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8224, i64 %t8226)
br i1 %t8227, label %L2443, label %L2445
L2443:
ret i64 1
L2445:
%t8229 = ptrtoint ptr @.s8228 to i64
%t8230 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8224, i64 %t8229)
br i1 %t8230, label %L2446, label %L2448
L2446:
ret i64 2
L2448:
%t8232 = ptrtoint ptr @.s8231 to i64
%t8233 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8224, i64 %t8232)
br i1 %t8233, label %L2449, label %L2451
L2449:
ret i64 3
L2451:
%t8235 = ptrtoint ptr @.s8234 to i64
%t8236 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8224, i64 %t8235)
br i1 %t8236, label %L2452, label %L2454
L2452:
ret i64 4
L2454:
%t8238 = ptrtoint ptr @.s8237 to i64
%t8239 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8224, i64 %t8238)
br i1 %t8239, label %L2455, label %L2457
L2455:
ret i64 5
L2457:
ret i64 6
}
define internal i64 @__mruntime_rt_map_resid__value_hash(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8240 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p0)
%t8241 = xor i1 %t8240, true
br i1 %t8241, label %L2458, label %L2460
L2458:
%t8242 = tail call i64 @__mruntime_rt_map_resid__fnv_str(i64 %p0)
ret i64 %t8242
L2460:
%t8243 = call i1 @box_imm(i64 %p0)
br i1 %t8243, label %L2461, label %L2463
L2461:
%t8244 = call i64 @imm_val(i64 %p0)
%t8245 = tail call i64 @__mruntime_rt_map_resid__fnv_i64(i64 %t8244)
ret i64 %t8245
L2463:
%t8246 = call i1 @box_fimm(i64 %p0)
br i1 %t8246, label %L2464, label %L2466
L2464:
%t8247 = call double @unbox_float(i64 %p0)
%t8248 = call i64 @__mruntime_rt_map_resid__fnv_f64(double %t8247)
ret i64 %t8248
L2466:
%t8249 = call i64 @box_type(i64 %p0)
%t8250 = add i64 %p0, 16
%t8251 = call i64 @ld64(i64 %t8250)
%t8252 = call i64 @box_tag(i64 %p0)
%t8253 = sub nsw i64 0, 1
%t8254 = icmp eq i64 %t8252, %t8253
br i1 %t8254, label %L2467, label %L2469
L2467:
%t8255 = call i64 @__mruntime_rt_map_resid__stype(i64 %p0)
%t8256 = icmp eq i64 %t8255, 1
br label %LSL8257
LSL8257:
br i1 %t8256, label %LSJ8257, label %LSR8257
LSR8257:
%t8258 = icmp eq i64 %t8255, 4
br label %LSJ8257
LSJ8257:
%t8259 = phi i1 [ true, %LSL8257 ], [ %t8258, %LSR8257 ]
br i1 %t8259, label %L2470, label %L2472
L2470:
%t8260 = call i64 @ld64(i64 %t8251)
%t8261 = tail call i64 @__mruntime_rt_map_resid__fnv_i64(i64 %t8260)
ret i64 %t8261
L2472:
%t8262 = icmp eq i64 %t8255, 2
br i1 %t8262, label %L2473, label %L2475
L2473:
%t8263 = call i64 @ld64(i64 %t8251)
%t8264 = bitcast i64 %t8263 to double
%t8265 = call i64 @__mruntime_rt_map_resid__fnv_f64(double %t8264)
ret i64 %t8265
L2475:
%t8266 = icmp eq i64 %t8255, 3
br i1 %t8266, label %L2476, label %L2478
L2476:
%t8267 = call i64 @ld8(i64 %t8251)
%t8268 = icmp ne i64 %t8267, 0
br i1 %t8268, label %L2479, label %L2480
L2479:
%t8270 = ptrtoint ptr @.s8269 to i64
br label %L2481
L2480:
%t8272 = ptrtoint ptr @.s8271 to i64
br label %L2481
L2481:
%t8273 = phi i64 [ %t8270, %L2479 ], [ %t8272, %L2480 ]
%t8274 = tail call i64 @__mruntime_rt_map_resid__fnv_str(i64 %t8273)
ret i64 %t8274
L2478:
%t8275 = icmp eq i64 %t8255, 5
br i1 %t8275, label %L2482, label %L2484
L2482:
%t8276p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_ubuf)
%t8276 = ptrtoint ptr %t8276p to i64
%t8277 = call i64 @ld64(i64 %t8251)
%t8278 = call i64 @utoa_into(i64 %t8276, i64 %t8277)
%t8279 = add i64 %t8276, %t8278
%t8280 = call i64 @st8(i64 %t8279, i64 0)
%t8281 = mul nsw i64 %t8280, 0
%t8282 = call i64 @__mruntime_rt_map_resid__fnv_str(i64 %t8276)
%t8283 = add nsw i64 %t8281, %t8282
ret i64 %t8283
L2484:
%t8284 = icmp ne i64 %t8249, 0
br i1 %t8284, label %L2485, label %L2486
L2485:
br label %L2487
L2486:
%t8286 = ptrtoint ptr @.s8285 to i64
br label %L2487
L2487:
%t8287 = phi i64 [ %t8249, %L2485 ], [ %t8286, %L2486 ]
%t8288 = tail call i64 @__mruntime_rt_map_resid__fnv_str(i64 %t8287)
ret i64 %t8288
L2469:
%t8290 = ptrtoint ptr @.s8289 to i64
%t8291 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8249, i64 %t8290)
br i1 %t8291, label %L2488, label %L2490
L2488:
%t8292 = icmp ne i64 %t8251, 0
br i1 %t8292, label %L2491, label %L2492
L2491:
br label %L2493
L2492:
%t8294 = ptrtoint ptr @.s8293 to i64
br label %L2493
L2493:
%t8295 = phi i64 [ %t8251, %L2491 ], [ %t8294, %L2492 ]
%t8296 = tail call i64 @__mruntime_rt_map_resid__fnv_str(i64 %t8295)
ret i64 %t8296
L2490:
%t8297 = icmp ne i64 %t8249, 0
br i1 %t8297, label %L2494, label %L2495
L2494:
br label %L2496
L2495:
%t8299 = ptrtoint ptr @.s8298 to i64
br label %L2496
L2496:
%t8300 = phi i64 [ %t8249, %L2494 ], [ %t8299, %L2495 ]
%t8301 = tail call i64 @__mruntime_rt_map_resid__fnv_str(i64 %t8300)
ret i64 %t8301
}
define internal i1 @__mruntime_rt_map_resid__value_eq(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8302 = call i1 @box_imm(i64 %p0)
br label %LSL8303
LSL8303:
br i1 %t8302, label %LSJ8303, label %LSR8303
LSR8303:
%t8304 = call i1 @box_imm(i64 %p1)
br label %LSJ8303
LSJ8303:
%t8305 = phi i1 [ true, %LSL8303 ], [ %t8304, %LSR8303 ]
br label %LSL8306
LSL8306:
br i1 %t8305, label %LSJ8306, label %LSR8306
LSR8306:
%t8307 = call i1 @box_fimm(i64 %p0)
br label %LSJ8306
LSJ8306:
%t8308 = phi i1 [ true, %LSL8306 ], [ %t8307, %LSR8306 ]
br label %LSL8309
LSL8309:
br i1 %t8308, label %LSJ8309, label %LSR8309
LSR8309:
%t8310 = call i1 @box_fimm(i64 %p1)
br label %LSJ8309
LSJ8309:
%t8311 = phi i1 [ true, %LSL8309 ], [ %t8310, %LSR8309 ]
br i1 %t8311, label %L2497, label %L2499
L2497:
%t8312 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p0)
br i1 %t8312, label %L2500, label %L2501
L2500:
%t8313 = call i64 @__mruntime_rt_map_resid__stype(i64 %p0)
br label %L2502
L2501:
br label %L2502
L2502:
%t8314 = phi i64 [ %t8313, %L2500 ], [ 0, %L2501 ]
%t8315 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p1)
br i1 %t8315, label %L2503, label %L2504
L2503:
%t8316 = call i64 @__mruntime_rt_map_resid__stype(i64 %p1)
br label %L2505
L2504:
br label %L2505
L2505:
%t8317 = phi i64 [ %t8316, %L2503 ], [ 0, %L2504 ]
%t8318 = icmp eq i64 %t8314, 0
br label %LSL8319
LSL8319:
br i1 %t8318, label %LSJ8319, label %LSR8319
LSR8319:
%t8320 = icmp ne i64 %t8314, %t8317
br label %LSJ8319
LSJ8319:
%t8321 = phi i1 [ true, %LSL8319 ], [ %t8320, %LSR8319 ]
br i1 %t8321, label %L2506, label %L2508
L2506:
ret i1 false
L2508:
%t8322 = icmp eq i64 %t8314, 1
br i1 %t8322, label %L2509, label %L2511
L2509:
%t8323 = call i64 @unbox_word(i64 %p0)
%t8324 = call i64 @unbox_word(i64 %p1)
%t8325 = icmp eq i64 %t8323, %t8324
ret i1 %t8325
L2511:
%t8326 = icmp eq i64 %t8314, 2
br label %LSL8327
LSL8327:
br i1 %t8326, label %LSR8327, label %LSJ8327
LSR8327:
%t8328 = call double @unbox_float(i64 %p0)
%t8329 = call double @unbox_float(i64 %p1)
%t8330 = fcmp oeq double %t8328, %t8329
br label %LSJ8327
LSJ8327:
%t8331 = phi i1 [ false, %LSL8327 ], [ %t8330, %LSR8327 ]
ret i1 %t8331
L2499:
%t8332 = icmp eq i64 %p0, %p1
br i1 %t8332, label %L2512, label %L2514
L2512:
ret i1 true
L2514:
%t8333 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p0)
%t8334 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p1)
br label %LSL8335
LSL8335:
br i1 %t8333, label %LSR8335, label %LSJ8335
LSR8335:
br label %LSJ8335
LSJ8335:
%t8336 = phi i1 [ false, %LSL8335 ], [ %t8334, %LSR8335 ]
br i1 %t8336, label %L2515, label %L2517
L2515:
%t8337 = tail call i1 @__mruntime_rt_map_resid__boxed_eq(i64 %p0, i64 %p1)
ret i1 %t8337
L2517:
%t8338 = xor i1 %t8333, true
br label %LSL8339
LSL8339:
br i1 %t8338, label %LSR8339, label %LSJ8339
LSR8339:
%t8340 = xor i1 %t8334, true
br label %LSJ8339
LSJ8339:
%t8341 = phi i1 [ false, %LSL8339 ], [ %t8340, %LSR8339 ]
br i1 %t8341, label %L2518, label %L2520
L2518:
%t8342 = call i64 @c_strcmp(i64 %p0, i64 %p1)
%t8343 = icmp eq i64 %t8342, 0
ret i1 %t8343
L2520:
ret i1 false
}
define internal i1 @__mruntime_rt_map_resid__boxed_eq(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8344 = call i64 @box_type(i64 %p0)
%t8345 = call i64 @box_type(i64 %p1)
%t8346 = call i64 @box_tag(i64 %p0)
%t8347 = sub nsw i64 0, 1
%t8348 = icmp eq i64 %t8346, %t8347
br label %LSL8349
LSL8349:
br i1 %t8348, label %LSR8349, label %LSJ8349
LSR8349:
%t8350 = call i64 @box_tag(i64 %p1)
%t8351 = sub nsw i64 0, 1
%t8352 = icmp eq i64 %t8350, %t8351
br label %LSJ8349
LSJ8349:
%t8353 = phi i1 [ false, %LSL8349 ], [ %t8352, %LSR8349 ]
br i1 %t8353, label %L2521, label %L2523
L2521:
%t8354 = icmp eq i64 %t8344, 0
br label %LSL8355
LSL8355:
br i1 %t8354, label %LSJ8355, label %LSR8355
LSR8355:
%t8356 = icmp eq i64 %t8345, 0
br label %LSJ8355
LSJ8355:
%t8357 = phi i1 [ true, %LSL8355 ], [ %t8356, %LSR8355 ]
br label %LSL8358
LSL8358:
br i1 %t8357, label %LSJ8358, label %LSR8358
LSR8358:
%t8359 = call i64 @c_strcmp(i64 %t8344, i64 %t8345)
%t8360 = icmp ne i64 %t8359, 0
br label %LSJ8358
LSJ8358:
%t8361 = phi i1 [ true, %LSL8358 ], [ %t8360, %LSR8358 ]
br i1 %t8361, label %L2524, label %L2526
L2524:
ret i1 false
L2526:
%t8362 = add i64 %p0, 16
%t8363 = call i64 @ld64(i64 %t8362)
%t8364 = add i64 %p1, 16
%t8365 = call i64 @ld64(i64 %t8364)
%t8366 = icmp eq i64 %t8363, %t8365
br i1 %t8366, label %L2527, label %L2529
L2527:
ret i1 true
L2529:
%t8367 = call i64 @__mruntime_rt_map_resid__stype(i64 %p0)
%t8368 = icmp eq i64 %t8367, 1
br i1 %t8368, label %L2530, label %L2532
L2530:
%t8369 = call i64 @ld64(i64 %t8363)
%t8370 = call i64 @ld64(i64 %t8365)
%t8371 = icmp eq i64 %t8369, %t8370
ret i1 %t8371
L2532:
%t8372 = icmp eq i64 %t8367, 2
br i1 %t8372, label %L2533, label %L2535
L2533:
%t8373 = call i64 @ld64(i64 %t8363)
%t8374 = bitcast i64 %t8373 to double
%t8375 = call i64 @ld64(i64 %t8365)
%t8376 = bitcast i64 %t8375 to double
%t8377 = fcmp oeq double %t8374, %t8376
ret i1 %t8377
L2535:
%t8378 = icmp eq i64 %t8367, 3
br i1 %t8378, label %L2536, label %L2538
L2536:
%t8379 = call i64 @ld8(i64 %t8363)
%t8380 = call i64 @ld8(i64 %t8365)
%t8381 = icmp eq i64 %t8379, %t8380
ret i1 %t8381
L2538:
%t8382 = icmp eq i64 %t8367, 4
br label %LSL8383
LSL8383:
br i1 %t8382, label %LSJ8383, label %LSR8383
LSR8383:
%t8384 = icmp eq i64 %t8367, 5
br label %LSJ8383
LSJ8383:
%t8385 = phi i1 [ true, %LSL8383 ], [ %t8384, %LSR8383 ]
br i1 %t8385, label %L2539, label %L2541
L2539:
%t8386 = call i64 @ld64(i64 %t8363)
%t8387 = call i64 @ld64(i64 %t8365)
%t8388 = icmp eq i64 %t8386, %t8387
br label %LSL8389
LSL8389:
br i1 %t8388, label %LSR8389, label %LSJ8389
LSR8389:
%t8390 = add i64 %t8363, 8
%t8391 = call i64 @ld64(i64 %t8390)
%t8392 = add i64 %t8365, 8
%t8393 = call i64 @ld64(i64 %t8392)
%t8394 = icmp eq i64 %t8391, %t8393
br label %LSJ8389
LSJ8389:
%t8395 = phi i1 [ false, %LSL8389 ], [ %t8394, %LSR8389 ]
ret i1 %t8395
L2541:
ret i1 false
L2523:
%t8397 = ptrtoint ptr @.s8396 to i64
%t8398 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8344, i64 %t8397)
br label %LSL8399
LSL8399:
br i1 %t8398, label %LSR8399, label %LSJ8399
LSR8399:
%t8401 = ptrtoint ptr @.s8400 to i64
%t8402 = call i1 @__mruntime_rt_map_resid__type_is(i64 %t8345, i64 %t8401)
br label %LSJ8399
LSJ8399:
%t8403 = phi i1 [ false, %LSL8399 ], [ %t8402, %LSR8399 ]
br i1 %t8403, label %L2542, label %L2544
L2542:
%t8404 = add i64 %p0, 16
%t8405 = call i64 @ld64(i64 %t8404)
%t8406 = add i64 %p1, 16
%t8407 = call i64 @ld64(i64 %t8406)
%t8408 = icmp eq i64 %t8405, 0
br label %LSL8409
LSL8409:
br i1 %t8408, label %LSJ8409, label %LSR8409
LSR8409:
%t8410 = icmp eq i64 %t8407, 0
br label %LSJ8409
LSJ8409:
%t8411 = phi i1 [ true, %LSL8409 ], [ %t8410, %LSR8409 ]
br i1 %t8411, label %L2545, label %L2547
L2545:
%t8412 = icmp eq i64 %t8405, %t8407
ret i1 %t8412
L2547:
%t8413 = call i64 @c_strcmp(i64 %t8405, i64 %t8407)
%t8414 = icmp eq i64 %t8413, 0
ret i1 %t8414
L2544:
%t8415 = icmp eq i64 %p0, %p1
ret i1 %t8415
}
define internal i64 @__mruntime_rt_map_resid__key_hash(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8416 = icmp eq i64 %p0, 1
br i1 %t8416, label %L2548, label %L2549
L2548:
%t8417 = call i64 @__mruntime_rt_map_resid__fnv_i64(i64 %p1)
br label %L2550
L2549:
%t8418 = call i64 @__mruntime_rt_map_resid__value_hash(i64 %p1)
br label %L2550
L2550:
%t8419 = phi i64 [ %t8417, %L2548 ], [ %t8418, %L2549 ]
ret i64 %t8419
}
define internal i1 @__mruntime_rt_map_resid__key_eq(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8420 = icmp eq i64 %p0, 1
br i1 %t8420, label %L2551, label %L2552
L2551:
%t8421 = icmp eq i64 %p1, %p2
br label %L2553
L2552:
%t8422 = call i1 @__mruntime_rt_map_resid__value_eq(i64 %p1, i64 %p2)
br label %L2553
L2553:
%t8423 = phi i1 [ %t8421, %L2551 ], [ %t8422, %L2552 ]
ret i1 %t8423
}
define internal i64 @__mruntime_rt_map_resid__canon_rank(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8424 = call i64 @__mruntime_rt_map_resid__rank_at(i64 %p0, i64 0, i64 0)
%t8425 = shl i64 %t8424, 4
%t8426 = call i64 @lshr(i64 %p0, i64 60)
%t8427 = or i64 %t8425, %t8426
ret i64 %t8427
}
define internal i64 @__mruntime_rt_map_resid__rank_at(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8429, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8437, %tco.s0 ]
%t8428 = icmp sge i64 %p1, 12
br i1 %t8428, label %L2554, label %L2556
L2554:
ret i64 %p2
L2556:
%t8429 = add nsw i64 %p1, 1
%t8430 = shl i64 %p2, 5
%t8431 = mul i64 %p1, 5
%t8432 = icmp uge i64 %t8431, 64
%t8433 = add i64 %t8431, 0
%t8434 = select i1 %t8432, i64 63, i64 %t8433
%t8435 = ashr i64 %p0, %t8434
%t8436 = and i64 %t8435, 31
%t8437 = or i64 %t8430, %t8436
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__edit_seq() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8439p = getelementptr i8, ptr @rtg.map_edit_seq, i64 0
%t8439 = ptrtoint ptr %t8439p to i64
ret i64 %t8439
}
define internal i64 @__mruntime_rt_map_resid__new_edit() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8440 = call i64 @__mruntime_rt_map_resid__edit_seq()
%t8441p = inttoptr i64 %t8440 to ptr
%t8441 = atomicrmw add ptr %t8441p, i64 1 seq_cst
%t8442 = add i64 %t8441, 1
ret i64 %t8442
}
define internal i64 @__mruntime_rt_map_resid__box_any(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8443 = icmp eq i64 %p0, 1
br i1 %t8443, label %L2557, label %L2559
L2557:
%t8444 = call i64 @c_box_i64(i64 %p1)
ret i64 %t8444
L2559:
%t8445 = icmp eq i64 %p0, 2
br i1 %t8445, label %L2560, label %L2562
L2560:
%t8446 = bitcast i64 %p1 to double
%t8447 = call i64 @c_box_f64(double %t8446)
ret i64 %t8447
L2562:
%t8448 = icmp eq i64 %p0, 3
br i1 %t8448, label %L2563, label %L2565
L2563:
%t8449 = icmp ne i64 %p1, 0
br i1 %t8449, label %L2566, label %L2567
L2566:
br label %L2568
L2567:
br label %L2568
L2568:
%t8450 = phi i64 [ 1, %L2566 ], [ 0, %L2567 ]
%t8451 = call i64 @c_box_bool(i64 %t8450)
ret i64 %t8451
L2565:
ret i64 %p1
}
define internal i64 @__mruntime_rt_map_resid__mbox(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8452 = icmp slt i64 %p0, 1
br label %LSL8453
LSL8453:
br i1 %t8452, label %LSJ8453, label %LSR8453
LSR8453:
%t8454 = icmp sgt i64 %p0, 3
br label %LSJ8453
LSJ8453:
%t8455 = phi i1 [ true, %LSL8453 ], [ %t8454, %LSR8453 ]
br label %LSL8456
LSL8456:
br i1 %t8455, label %LSJ8456, label %LSR8456
LSR8456:
%t8457 = call i1 @__mruntime_rt_map_resid__map_heap()
%t8458 = xor i1 %t8457, true
br label %LSJ8456
LSJ8456:
%t8459 = phi i1 [ true, %LSL8456 ], [ %t8458, %LSR8456 ]
br label %LSL8460
LSL8460:
br i1 %t8459, label %LSJ8460, label %LSR8460
LSR8460:
%t8461 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t8462 = icmp eq i64 %t8461, 0
br label %LSJ8460
LSJ8460:
%t8463 = phi i1 [ true, %LSL8460 ], [ %t8462, %LSR8460 ]
br i1 %t8463, label %L2569, label %L2571
L2569:
%t8464 = tail call i64 @__mruntime_rt_map_resid__box_any(i64 %p0, i64 %p1)
ret i64 %t8464
L2571:
%t8465 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t8466 = call i64 @c_sc_depth_set(i64 0)
%t8467 = call i64 @__mruntime_rt_map_resid__box_any(i64 %p0, i64 %p1)
%t8468 = call i64 @c_sc_depth_set(i64 %t8465)
%t8469 = mul nsw i64 %t8468, 0
%t8470 = add nsw i64 %t8469, %t8467
ret i64 %t8470
}
define internal i1 @__mruntime_rt_map_resid__unbox_k(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8471 = call i1 @ult(i64 %p1, i64 4096)
br label %LSL8472
LSL8472:
br i1 %t8471, label %LSJ8472, label %LSR8472
LSR8472:
%t8473 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p1)
%t8474 = xor i1 %t8473, true
br label %LSJ8472
LSJ8472:
%t8475 = phi i1 [ true, %LSL8472 ], [ %t8474, %LSR8472 ]
br i1 %t8475, label %L2572, label %L2574
L2572:
ret i1 false
L2574:
%t8476 = call i64 @__mruntime_rt_map_resid__stype(i64 %p1)
%t8477 = icmp eq i64 %p0, 1
br label %LSL8478
LSL8478:
br i1 %t8477, label %LSR8478, label %LSJ8478
LSR8478:
%t8479 = icmp eq i64 %t8476, 1
br label %LSJ8478
LSJ8478:
%t8480 = phi i1 [ false, %LSL8478 ], [ %t8479, %LSR8478 ]
br i1 %t8480, label %L2575, label %L2577
L2575:
%t8481 = call i64 @unbox_word(i64 %p1)
%t8482 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t8481)
%t8483 = icmp ne i64 %t8482, 0
ret i1 %t8483
L2577:
%t8484 = icmp eq i64 %p0, 2
br label %LSL8485
LSL8485:
br i1 %t8484, label %LSR8485, label %LSJ8485
LSR8485:
%t8486 = icmp eq i64 %t8476, 2
br label %LSJ8485
LSJ8485:
%t8487 = phi i1 [ false, %LSL8485 ], [ %t8486, %LSR8485 ]
br i1 %t8487, label %L2578, label %L2580
L2578:
%t8488 = call double @unbox_float(i64 %p1)
%t8489 = bitcast double %t8488 to i64
%t8490 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t8489)
%t8491 = icmp ne i64 %t8490, 0
ret i1 %t8491
L2580:
%t8492 = icmp eq i64 %p0, 3
br label %LSL8493
LSL8493:
br i1 %t8492, label %LSR8493, label %LSJ8493
LSR8493:
%t8494 = icmp eq i64 %t8476, 3
br label %LSJ8493
LSJ8493:
%t8495 = phi i1 [ false, %LSL8493 ], [ %t8494, %LSR8493 ]
br i1 %t8495, label %L2581, label %L2583
L2581:
%t8496 = add i64 %p1, 24
%t8497 = call i64 @ld8(i64 %t8496)
%t8498 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t8497)
%t8499 = icmp ne i64 %t8498, 0
ret i1 %t8499
L2583:
ret i1 false
}
define internal i64 @__mruntime_rt_map_resid__word_of_box(i64 %p0, i1 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8500 = call i1 @ult(i64 %p0, i64 4096)
%t8501 = xor i1 %t8500, true
br label %LSL8502
LSL8502:
br i1 %t8501, label %LSR8502, label %LSJ8502
LSR8502:
%t8503 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p0)
br label %LSJ8502
LSJ8502:
%t8504 = phi i1 [ false, %LSL8502 ], [ %t8503, %LSR8502 ]
br i1 %t8504, label %L2584, label %L2585
L2584:
%t8505 = call i64 @__mruntime_rt_map_resid__stype(i64 %p0)
br label %L2586
L2585:
br label %L2586
L2586:
%t8506 = phi i64 [ %t8505, %L2584 ], [ 0, %L2585 ]
%t8507 = icmp eq i64 %t8506, 1
br i1 %t8507, label %L2587, label %L2589
L2587:
%t8508 = call i64 @unbox_word(i64 %p0)
%t8509 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t8508)
ret i64 %t8509
L2589:
%t8510 = xor i1 %p1, true
br label %LSL8511
LSL8511:
br i1 %t8510, label %LSR8511, label %LSJ8511
LSR8511:
%t8512 = icmp eq i64 %t8506, 2
br label %LSJ8511
LSJ8511:
%t8513 = phi i1 [ false, %LSL8511 ], [ %t8512, %LSR8511 ]
br i1 %t8513, label %L2590, label %L2592
L2590:
%t8514 = call double @unbox_float(i64 %p0)
%t8515 = bitcast double %t8514 to i64
%t8516 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t8515)
%t8517 = mul i64 %t8516, 2
ret i64 %t8517
L2592:
%t8518 = xor i1 %p1, true
br label %LSL8519
LSL8519:
br i1 %t8518, label %LSR8519, label %LSJ8519
LSR8519:
%t8520 = icmp eq i64 %t8506, 3
br label %LSJ8519
LSJ8519:
%t8521 = phi i1 [ false, %LSL8519 ], [ %t8520, %LSR8519 ]
br i1 %t8521, label %L2593, label %L2595
L2593:
%t8522 = add i64 %p0, 24
%t8523 = call i64 @ld8(i64 %t8522)
%t8524 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t8523)
%t8525 = mul i64 %t8524, 3
ret i64 %t8525
L2595:
%t8526 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %p0)
%t8527 = mul nsw i64 %t8526, 0
ret i64 %t8527
}
define internal i64 @rt_str_keep(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8528 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t8529 = icmp eq i64 %t8528, 0
br label %LSL8530
LSL8530:
br i1 %t8529, label %LSJ8530, label %LSR8530
LSR8530:
%t8531 = call i64 @c_in_scope(i64 %p0)
%t8532 = icmp eq i64 %t8531, 0
br label %LSJ8530
LSJ8530:
%t8533 = phi i1 [ true, %LSL8530 ], [ %t8532, %LSR8530 ]
br i1 %t8533, label %L2596, label %L2598
L2596:
ret i64 %p0
L2598:
%t8534 = call i64 @c_strlen(i64 %p0)
%t8535 = add i64 %t8534, 1
%t8536 = call i64 @c_outer_alloc(i64 %t8535)
%t8537 = call i64 @mcopy(i64 %t8536, i64 %p0, i64 %t8535)
%t8538 = mul nsw i64 %t8537, 0
%t8539 = add nsw i64 %t8538, %t8536
ret i64 %t8539
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
%t8540 = icmp eq i64 %p0, 4
br i1 %t8540, label %L2599, label %L2601
L2599:
%t8541 = call i64 @rt_str_keep(i64 %p1)
ret i64 %t8541
L2601:
%t8542 = icmp eq i64 %p0, 5
br i1 %t8542, label %L2602, label %L2604
L2602:
%t8543 = call i64 @rt_list_keep(i64 %p1)
ret i64 %t8543
L2604:
ret i64 %p1
}
define internal i64 @__mruntime_rt_map_resid__ndmap(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8544 = tail call i64 @ld32(i64 %p0)
ret i64 %t8544
}
define internal i64 @__mruntime_rt_map_resid__nnmap(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8545 = add i64 %p0, 4
%t8546 = tail call i64 @ld32(i64 %t8545)
ret i64 %t8546
}
define internal i64 @__mruntime_rt_map_resid__nncoll(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8547 = add i64 %p0, 8
%t8548 = tail call i64 @ld32(i64 %t8547)
ret i64 %t8548
}
define internal i64 @__mruntime_rt_map_resid__ncap(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8549 = add i64 %p0, 12
%t8550 = tail call i64 @ld32(i64 %t8549)
ret i64 %t8550
}
define internal i64 @__mruntime_rt_map_resid__nedit(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8551 = add i64 %p0, 16
%t8552 = tail call i64 @ld64(i64 %t8551)
ret i64 %t8552
}
define internal i64 @__mruntime_rt_map_resid__nw(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8553 = add i64 %p0, 24
ret i64 %t8553
}
define internal i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8554 = add i64 %p0, 24
%t8555 = mul i64 %p1, 8
%t8556 = add i64 %t8554, %t8555
%t8557 = call i64 @ld64(i64 %t8556)
ret i64 %t8557
}
define internal i64 @__mruntime_rt_map_resid__wset(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8558 = add i64 %p0, 24
%t8559 = mul i64 %p1, 8
%t8560 = add i64 %t8558, %t8559
%t8561 = call i64 @st64(i64 %t8560, i64 %p2)
ret i64 %t8561
}
define internal i64 @__mruntime_rt_map_resid__node_nd(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8562 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t8563 = icmp ne i64 %t8562, 0
br i1 %t8563, label %L2605, label %L2606
L2605:
%t8564 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
br label %L2607
L2606:
%t8565 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8566 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8565)
br label %L2607
L2607:
%t8567 = phi i64 [ %t8564, %L2605 ], [ %t8566, %L2606 ]
ret i64 %t8567
}
define internal i64 @__mruntime_rt_map_resid__node_nn(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8568 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t8569 = icmp ne i64 %t8568, 0
br i1 %t8569, label %L2608, label %L2609
L2608:
br label %L2610
L2609:
%t8570 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8571 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8570)
br label %L2610
L2610:
%t8572 = phi i64 [ 0, %L2608 ], [ %t8571, %L2609 ]
ret i64 %t8572
}
define internal i64 @__mruntime_rt_map_resid__node_words(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8573 = call i64 @__mruntime_rt_map_resid__node_nd(i64 %p0)
%t8574 = mul i64 2, %t8573
%t8575 = call i64 @__mruntime_rt_map_resid__node_nn(i64 %p0)
%t8576 = add i64 %t8574, %t8575
ret i64 %t8576
}
define internal i64 @__mruntime_rt_map_resid__slot_bit(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8577 = mul i64 %p1, 5
%t8578 = call i64 @lshr(i64 %p0, i64 %t8577)
%t8579 = and i64 %t8578, 31
%t8580 = icmp uge i64 %t8579, 64
%t8581 = add i64 %t8579, 0
%t8582 = shl i64 1, %t8581
%t8583 = select i1 %t8580, i64 0, i64 %t8582
ret i64 %t8583
}
define internal i64 @__mruntime_rt_map_resid__node_new(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8584 = mul i64 %p0, 8
%t8585 = add i64 24, %t8584
%t8586 = call i64 @__mruntime_rt_map_resid__map_obj(i64 %t8585)
%t8587 = call i64 @st32(i64 %t8586, i64 0)
%t8588 = add i64 %t8586, 4
%t8589 = call i64 @st32(i64 %t8588, i64 0)
%t8590 = add i64 %t8587, %t8589
%t8591 = add i64 %t8586, 8
%t8592 = call i64 @st32(i64 %t8591, i64 0)
%t8593 = add i64 %t8590, %t8592
%t8594 = add i64 %t8586, 12
%t8595 = call i64 @st32(i64 %t8594, i64 %p0)
%t8596 = add i64 %t8586, 16
%t8597 = call i64 @st64(i64 %t8596, i64 %p1)
%t8598 = mul nsw i64 %t8597, 0
%t8599 = add nsw i64 %t8598, %t8586
ret i64 %t8599
}
define internal i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8600 = call i64 @__mruntime_rt_map_resid__node_words(i64 %p0)
%t8601 = icmp ne i64 %p2, 0
br label %LSL8602
LSL8602:
br i1 %t8601, label %LSR8602, label %LSJ8602
LSR8602:
%t8603 = call i64 @__mruntime_rt_map_resid__nedit(i64 %p0)
%t8604 = icmp eq i64 %t8603, %p2
br label %LSJ8602
LSJ8602:
%t8605 = phi i1 [ false, %LSL8602 ], [ %t8604, %LSR8602 ]
br label %LSL8606
LSL8606:
br i1 %t8605, label %LSR8606, label %LSJ8606
LSR8606:
%t8607 = add i64 %t8600, %p1
%t8608 = call i64 @__mruntime_rt_map_resid__ncap(i64 %p0)
%t8609 = icmp sle i64 %t8607, %t8608
br label %LSJ8606
LSJ8606:
%t8610 = phi i1 [ false, %LSL8606 ], [ %t8609, %LSR8606 ]
br i1 %t8610, label %L2611, label %L2613
L2611:
ret i64 %p0
L2613:
%t8611 = icmp sgt i64 %p1, 0
br i1 %t8611, label %L2614, label %L2615
L2614:
br label %L2616
L2615:
br label %L2616
L2616:
%t8612 = phi i64 [ %p1, %L2614 ], [ 0, %L2615 ]
%t8613 = icmp ne i64 %p2, 0
br i1 %t8613, label %L2617, label %L2618
L2617:
br label %L2619
L2618:
br label %L2619
L2619:
%t8614 = phi i64 [ 4, %L2617 ], [ 0, %L2618 ]
%t8615 = add i64 %t8612, %t8614
%t8616 = add i64 %t8600, %t8615
%t8617 = call i64 @__mruntime_rt_map_resid__node_new(i64 %t8616, i64 %p2)
%t8618 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8619 = call i64 @st32(i64 %t8617, i64 %t8618)
%t8620 = add i64 %t8617, 4
%t8621 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8622 = call i64 @st32(i64 %t8620, i64 %t8621)
%t8623 = add i64 %t8619, %t8622
%t8624 = add i64 %t8617, 8
%t8625 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t8626 = call i64 @st32(i64 %t8624, i64 %t8625)
%t8627 = add i64 %t8623, %t8626
%t8628 = call i64 @__mruntime_rt_map_resid__nw(i64 %t8617)
%t8629 = call i64 @__mruntime_rt_map_resid__nw(i64 %p0)
%t8630 = mul i64 %t8600, 8
%t8631 = call i64 @mcopy(i64 %t8628, i64 %t8629, i64 %t8630)
%t8632 = mul nsw i64 %t8631, 0
%t8633 = add nsw i64 %t8632, %t8617
ret i64 %t8633
}
define internal i64 @__mruntime_rt_map_resid__node_leaf(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8634 = icmp ne i64 %p4, 0
br i1 %t8634, label %L2620, label %L2621
L2620:
br label %L2622
L2621:
br label %L2622
L2622:
%t8635 = phi i64 [ 6, %L2620 ], [ 2, %L2621 ]
%t8636 = call i64 @__mruntime_rt_map_resid__node_new(i64 %t8635, i64 %p4)
%t8637 = call i64 @__mruntime_rt_map_resid__slot_bit(i64 %p1, i64 %p0)
%t8638 = call i64 @st32(i64 %t8636, i64 %t8637)
%t8639 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8636, i64 0, i64 %p2)
%t8640 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8636, i64 1, i64 %p3)
%t8641 = mul nsw i64 %t8640, 0
%t8642 = add nsw i64 %t8641, %t8636
ret i64 %t8642
}
define internal i64 @__mruntime_rt_map_resid__node_coll2(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8643 = icmp ne i64 %p4, 0
br i1 %t8643, label %L2623, label %L2624
L2623:
br label %L2625
L2624:
br label %L2625
L2625:
%t8644 = phi i64 [ 8, %L2623 ], [ 4, %L2624 ]
%t8645 = call i64 @__mruntime_rt_map_resid__node_new(i64 %t8644, i64 %p4)
%t8646 = add i64 %t8645, 8
%t8647 = call i64 @st32(i64 %t8646, i64 2)
%t8648 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8645, i64 0, i64 %p0)
%t8649 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8645, i64 1, i64 %p1)
%t8650 = add i64 %t8648, %t8649
%t8651 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8645, i64 2, i64 %p2)
%t8652 = add i64 %t8650, %t8651
%t8653 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8645, i64 3, i64 %p3)
%t8654 = add i64 %t8652, %t8653
ret i64 %t8645
}
define internal i64 @__mruntime_rt_map_resid__node_pair(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8655 = icmp sgt i64 %p0, 12
br i1 %t8655, label %L2626, label %L2628
L2626:
%t8656 = call i64 @__mruntime_rt_map_resid__node_coll2(i64 %p2, i64 %p3, i64 %p5, i64 %p6, i64 %p7)
ret i64 %t8656
L2628:
%t8657 = call i64 @__mruntime_rt_map_resid__slot_bit(i64 %p1, i64 %p0)
%t8658 = call i64 @__mruntime_rt_map_resid__slot_bit(i64 %p4, i64 %p0)
%t8659 = icmp eq i64 %t8657, %t8658
br i1 %t8659, label %L2629, label %L2631
L2629:
%t8660 = add nsw i64 %p0, 1
%t8661 = call i64 @__mruntime_rt_map_resid__node_pair(i64 %t8660, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7)
%t8662 = icmp ne i64 %p7, 0
br i1 %t8662, label %L2632, label %L2633
L2632:
br label %L2634
L2633:
br label %L2634
L2634:
%t8663 = phi i64 [ 5, %L2632 ], [ 1, %L2633 ]
%t8664 = call i64 @__mruntime_rt_map_resid__node_new(i64 %t8663, i64 %p7)
%t8665 = add i64 %t8664, 4
%t8666 = call i64 @st32(i64 %t8665, i64 %t8657)
%t8667 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8664, i64 0, i64 %t8661)
%t8668 = mul nsw i64 %t8667, 0
%t8669 = add nsw i64 %t8668, %t8664
ret i64 %t8669
L2631:
%t8670 = icmp ne i64 %p7, 0
br i1 %t8670, label %L2635, label %L2636
L2635:
br label %L2637
L2636:
br label %L2637
L2637:
%t8671 = phi i64 [ 8, %L2635 ], [ 4, %L2636 ]
%t8672 = call i64 @__mruntime_rt_map_resid__node_new(i64 %t8671, i64 %p7)
%t8673 = or i64 %t8657, %t8658
%t8674 = call i64 @st32(i64 %t8672, i64 %t8673)
%t8675 = icmp slt i64 %t8657, %t8658
br i1 %t8675, label %L2638, label %L2639
L2638:
br label %L2640
L2639:
br label %L2640
L2640:
%t8676 = phi i64 [ %p2, %L2638 ], [ %p5, %L2639 ]
%t8677 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8672, i64 0, i64 %t8676)
br i1 %t8675, label %L2641, label %L2642
L2641:
br label %L2643
L2642:
br label %L2643
L2643:
%t8678 = phi i64 [ %p3, %L2641 ], [ %p6, %L2642 ]
%t8679 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8672, i64 1, i64 %t8678)
%t8680 = add i64 %t8677, %t8679
br i1 %t8675, label %L2644, label %L2645
L2644:
br label %L2646
L2645:
br label %L2646
L2646:
%t8681 = phi i64 [ %p5, %L2644 ], [ %p2, %L2645 ]
%t8682 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8672, i64 2, i64 %t8681)
%t8683 = add i64 %t8680, %t8682
br i1 %t8675, label %L2647, label %L2648
L2647:
br label %L2649
L2648:
br label %L2649
L2649:
%t8684 = phi i64 [ %p6, %L2647 ], [ %p3, %L2648 ]
%t8685 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8672, i64 3, i64 %t8684)
%t8686 = add i64 %t8683, %t8685
ret i64 %t8672
}
define internal i64 @__mruntime_rt_map_resid__node_ins_data(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8687 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8688 = sub i64 %p1, 1
%t8689 = and i64 %t8687, %t8688
%t8690 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8689)
%t8691 = call i64 @__mruntime_rt_map_resid__node_words(i64 %p0)
%t8692 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 2, i64 %p4)
%t8693 = call i64 @__mruntime_rt_map_resid__nw(i64 %t8692)
%t8694 = mul i64 2, %t8690
%t8695 = add i64 %t8694, 2
%t8696 = mul i64 %t8695, 8
%t8697 = add i64 %t8693, %t8696
%t8698 = call i64 @__mruntime_rt_map_resid__nw(i64 %t8692)
%t8699 = mul i64 2, %t8690
%t8700 = mul i64 %t8699, 8
%t8701 = add i64 %t8698, %t8700
%t8702 = mul i64 2, %t8690
%t8703 = sub i64 %t8691, %t8702
%t8704 = mul i64 %t8703, 8
%t8705 = call i64 @mcopy(i64 %t8697, i64 %t8701, i64 %t8704)
%t8706 = mul i64 2, %t8690
%t8707 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8692, i64 %t8706, i64 %p2)
%t8708 = mul i64 2, %t8690
%t8709 = add i64 %t8708, 1
%t8710 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8692, i64 %t8709, i64 %p3)
%t8711 = add i64 %t8707, %t8710
%t8712 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %t8692)
%t8713 = or i64 %t8712, %p1
%t8714 = call i64 @st32(i64 %t8692, i64 %t8713)
%t8715 = mul nsw i64 %t8714, 0
%t8716 = add nsw i64 %t8715, %t8692
ret i64 %t8716
}
define internal i64 @__mruntime_rt_map_resid__node_data_to_sub(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8717 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8718 = sub i64 %p1, 1
%t8719 = and i64 %t8717, %t8718
%t8720 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8719)
%t8721 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8722 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8721)
%t8723 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8724 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8723)
%t8725 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8726 = sub i64 %p1, 1
%t8727 = and i64 %t8725, %t8726
%t8728 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8727)
%t8729 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p3)
%t8730 = call i64 @__mruntime_rt_map_resid__nw(i64 %t8729)
%t8731 = mul i64 2, %t8720
%t8732 = mul i64 %t8731, 8
%t8733 = add i64 %t8730, %t8732
%t8734 = mul i64 2, %t8720
%t8735 = add i64 %t8734, 2
%t8736 = mul i64 %t8735, 8
%t8737 = add i64 %t8730, %t8736
%t8738 = sub i64 %t8722, %t8720
%t8739 = sub i64 %t8738, 1
%t8740 = mul i64 2, %t8739
%t8741 = mul i64 %t8740, 8
%t8742 = call i64 @mcopy(i64 %t8733, i64 %t8737, i64 %t8741)
%t8743 = sub i64 %t8722, 1
%t8744 = mul i64 2, %t8743
%t8745 = mul i64 %t8744, 8
%t8746 = add i64 %t8730, %t8745
%t8747 = mul i64 2, %t8722
%t8748 = mul i64 %t8747, 8
%t8749 = add i64 %t8730, %t8748
%t8750 = mul i64 %t8728, 8
%t8751 = call i64 @mcopy(i64 %t8746, i64 %t8749, i64 %t8750)
%t8752 = sub i64 %t8722, 1
%t8753 = mul i64 2, %t8752
%t8754 = add i64 %t8753, %t8728
%t8755 = add i64 %t8754, 1
%t8756 = mul i64 %t8755, 8
%t8757 = add i64 %t8730, %t8756
%t8758 = mul i64 2, %t8722
%t8759 = add i64 %t8758, %t8728
%t8760 = mul i64 %t8759, 8
%t8761 = add i64 %t8730, %t8760
%t8762 = sub i64 %t8724, %t8728
%t8763 = mul i64 %t8762, 8
%t8764 = call i64 @mcopy(i64 %t8757, i64 %t8761, i64 %t8763)
%t8765 = sub i64 %t8722, 1
%t8766 = mul i64 2, %t8765
%t8767 = add i64 %t8766, %t8728
%t8768 = mul i64 %t8767, 8
%t8769 = add i64 %t8730, %t8768
%t8770 = call i64 @st64(i64 %t8769, i64 %p2)
%t8771 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %t8729)
%t8772 = xor i64 %p1, -1
%t8773 = and i64 %t8771, %t8772
%t8774 = call i64 @st32(i64 %t8729, i64 %t8773)
%t8775 = add i64 %t8729, 4
%t8776 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %t8729)
%t8777 = or i64 %t8776, %p1
%t8778 = call i64 @st32(i64 %t8775, i64 %t8777)
%t8779 = mul nsw i64 %t8778, 0
%t8780 = add nsw i64 %t8779, %t8729
ret i64 %t8780
}
define internal i64 @__mruntime_rt_map_resid__node_sub_to_data(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8781 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8782 = sub i64 %p1, 1
%t8783 = and i64 %t8781, %t8782
%t8784 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8783)
%t8785 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8786 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8785)
%t8787 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8788 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8787)
%t8789 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8790 = sub i64 %p1, 1
%t8791 = and i64 %t8789, %t8790
%t8792 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8791)
%t8793 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 1, i64 %p4)
%t8794 = call i64 @__mruntime_rt_map_resid__nw(i64 %t8793)
%t8795 = mul i64 2, %t8786
%t8796 = add i64 %t8795, 2
%t8797 = add i64 %t8796, %t8792
%t8798 = mul i64 %t8797, 8
%t8799 = add i64 %t8794, %t8798
%t8800 = mul i64 2, %t8786
%t8801 = add i64 %t8800, %t8792
%t8802 = add i64 %t8801, 1
%t8803 = mul i64 %t8802, 8
%t8804 = add i64 %t8794, %t8803
%t8805 = sub i64 %t8788, %t8792
%t8806 = sub i64 %t8805, 1
%t8807 = mul i64 %t8806, 8
%t8808 = call i64 @mcopy(i64 %t8799, i64 %t8804, i64 %t8807)
%t8809 = mul i64 2, %t8786
%t8810 = add i64 %t8809, 2
%t8811 = mul i64 %t8810, 8
%t8812 = add i64 %t8794, %t8811
%t8813 = mul i64 2, %t8786
%t8814 = mul i64 %t8813, 8
%t8815 = add i64 %t8794, %t8814
%t8816 = mul i64 %t8792, 8
%t8817 = call i64 @mcopy(i64 %t8812, i64 %t8815, i64 %t8816)
%t8818 = mul i64 2, %t8784
%t8819 = add i64 %t8818, 2
%t8820 = mul i64 %t8819, 8
%t8821 = add i64 %t8794, %t8820
%t8822 = mul i64 2, %t8784
%t8823 = mul i64 %t8822, 8
%t8824 = add i64 %t8794, %t8823
%t8825 = sub i64 %t8786, %t8784
%t8826 = mul i64 2, %t8825
%t8827 = mul i64 %t8826, 8
%t8828 = call i64 @mcopy(i64 %t8821, i64 %t8824, i64 %t8827)
%t8829 = mul i64 2, %t8784
%t8830 = mul i64 %t8829, 8
%t8831 = add i64 %t8794, %t8830
%t8832 = call i64 @st64(i64 %t8831, i64 %p2)
%t8833 = mul i64 2, %t8784
%t8834 = add i64 %t8833, 1
%t8835 = mul i64 %t8834, 8
%t8836 = add i64 %t8794, %t8835
%t8837 = call i64 @st64(i64 %t8836, i64 %p3)
%t8838 = add i64 %t8832, %t8837
%t8839 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %t8793)
%t8840 = or i64 %t8839, %p1
%t8841 = call i64 @st32(i64 %t8793, i64 %t8840)
%t8842 = add i64 %t8793, 4
%t8843 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %t8793)
%t8844 = xor i64 %p1, -1
%t8845 = and i64 %t8843, %t8844
%t8846 = call i64 @st32(i64 %t8842, i64 %t8845)
%t8847 = mul nsw i64 %t8846, 0
%t8848 = add nsw i64 %t8847, %t8793
ret i64 %t8848
}
define internal i64 @__mruntime_rt_map_resid__hn_insert(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t8849 = icmp eq i64 %p0, 0
br i1 %t8849, label %L2650, label %L2652
L2650:
%t8850 = call i64 @__mruntime_rt_map_resid__mflag()
%t8851 = call i64 @st64(i64 %t8850, i64 1)
%t8852 = mul nsw i64 %t8851, 0
%t8853 = call i64 @__mruntime_rt_map_resid__node_leaf(i64 %p1, i64 %p2, i64 %p4, i64 %p5, i64 %p6)
%t8854 = add nsw i64 %t8852, %t8853
ret i64 %t8854
L2652:
%t8855 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t8856 = icmp ne i64 %t8855, 0
br i1 %t8856, label %L2653, label %L2655
L2653:
%t8857 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t8858 = tail call i64 @__mruntime_rt_map_resid__coll_insert(i64 %p0, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 0, i64 %t8857)
ret i64 %t8858
L2655:
%t8859 = call i64 @__mruntime_rt_map_resid__slot_bit(i64 %p2, i64 %p1)
%t8860 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8861 = and i64 %t8860, %t8859
%t8862 = icmp ne i64 %t8861, 0
br i1 %t8862, label %L2656, label %L2658
L2656:
%t8863 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8864 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8863)
%t8865 = mul i64 2, %t8864
%t8866 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8867 = sub i64 %t8859, 1
%t8868 = and i64 %t8866, %t8867
%t8869 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8868)
%t8870 = add i64 %t8865, %t8869
%t8871 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8870)
%t8872 = add i64 %p1, 1
%t8873 = call i64 @__mruntime_rt_map_resid__hn_insert(i64 %t8871, i64 %t8872, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6)
%t8874 = icmp eq i64 %t8873, %t8871
br i1 %t8874, label %L2659, label %L2661
L2659:
ret i64 %p0
L2661:
%t8875 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p6)
%t8876 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8875, i64 %t8870, i64 %t8873)
%t8877 = mul nsw i64 %t8876, 0
%t8878 = add nsw i64 %t8877, %t8875
ret i64 %t8878
L2658:
%t8879 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8880 = and i64 %t8879, %t8859
%t8881 = icmp ne i64 %t8880, 0
br i1 %t8881, label %L2662, label %L2664
L2662:
%t8882 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8883 = sub i64 %t8859, 1
%t8884 = and i64 %t8882, %t8883
%t8885 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8884)
%t8886 = mul i64 2, %t8885
%t8887 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8886)
%t8888 = mul i64 2, %t8885
%t8889 = add i64 %t8888, 1
%t8890 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8889)
%t8891 = call i1 @__mruntime_rt_map_resid__key_eq(i64 %p3, i64 %t8887, i64 %p4)
br i1 %t8891, label %L2665, label %L2667
L2665:
%t8892 = call i64 @__mruntime_rt_map_resid__mflag()
%t8893 = call i64 @st64(i64 %t8892, i64 0)
%t8894 = icmp eq i64 %t8890, %p5
br label %LSL8895
LSL8895:
br i1 %t8894, label %LSR8895, label %LSJ8895
LSR8895:
%t8896 = icmp eq i64 %t8887, %p4
br label %LSJ8895
LSJ8895:
%t8897 = phi i1 [ false, %LSL8895 ], [ %t8896, %LSR8895 ]
br i1 %t8897, label %L2668, label %L2670
L2668:
ret i64 %p0
L2670:
%t8898 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p6)
%t8899 = mul i64 2, %t8885
%t8900 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8898, i64 %t8899, i64 %p4)
%t8901 = mul nsw i64 %t8900, 0
%t8902 = mul i64 2, %t8885
%t8903 = add i64 %t8902, 1
%t8904 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8898, i64 %t8903, i64 %p5)
%t8905 = mul nsw i64 %t8904, 0
%t8906 = add nsw i64 %t8901, %t8905
%t8907 = add nsw i64 %t8906, %t8898
ret i64 %t8907
L2667:
%t8908 = call i64 @__mruntime_rt_map_resid__mflag()
%t8909 = call i64 @st64(i64 %t8908, i64 1)
%t8910 = icmp sge i64 %p1, 12
br i1 %t8910, label %L2671, label %L2672
L2671:
%t8911 = call i64 @__mruntime_rt_map_resid__node_coll2(i64 %t8887, i64 %t8890, i64 %p4, i64 %p5, i64 %p6)
br label %L2673
L2672:
%t8912 = add nsw i64 %p1, 1
%t8913 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %p3, i64 %t8887)
%t8914 = call i64 @__mruntime_rt_map_resid__node_pair(i64 %t8912, i64 %t8913, i64 %t8887, i64 %t8890, i64 %p2, i64 %p4, i64 %p5, i64 %p6)
br label %L2673
L2673:
%t8915 = phi i64 [ %t8911, %L2671 ], [ %t8914, %L2672 ]
%t8916 = call i64 @__mruntime_rt_map_resid__node_data_to_sub(i64 %p0, i64 %t8859, i64 %t8915, i64 %p6)
ret i64 %t8916
L2664:
%t8917 = call i64 @__mruntime_rt_map_resid__mflag()
%t8918 = call i64 @st64(i64 %t8917, i64 1)
%t8919 = call i64 @__mruntime_rt_map_resid__node_ins_data(i64 %p0, i64 %t8859, i64 %p4, i64 %p5, i64 %p6)
ret i64 %t8919
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
%p5 = phi i64 [ %p5.in, %entry ], [ %t8959, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ]
%t8920 = icmp sge i64 %p5, %p6
br i1 %t8920, label %L2674, label %L2676
L2674:
%t8921 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 2, i64 %p4)
%t8922 = mul i64 2, %p6
%t8923 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8921, i64 %t8922, i64 %p2)
%t8924 = mul i64 2, %p6
%t8925 = add i64 %t8924, 1
%t8926 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8921, i64 %t8925, i64 %p3)
%t8927 = add i64 %t8923, %t8926
%t8928 = add i64 %t8921, 8
%t8929 = add i64 %p6, 1
%t8930 = call i64 @st32(i64 %t8928, i64 %t8929)
%t8931 = call i64 @__mruntime_rt_map_resid__mflag()
%t8932 = call i64 @st64(i64 %t8931, i64 1)
%t8933 = mul nsw i64 %t8932, 0
%t8934 = add nsw i64 %t8933, %t8921
ret i64 %t8934
L2676:
%t8935 = mul i64 2, %p5
%t8936 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8935)
%t8937 = call i1 @__mruntime_rt_map_resid__key_eq(i64 %p1, i64 %t8936, i64 %p2)
br i1 %t8937, label %L2677, label %L2679
L2677:
%t8938 = call i64 @__mruntime_rt_map_resid__mflag()
%t8939 = call i64 @st64(i64 %t8938, i64 0)
%t8940 = mul i64 2, %p5
%t8941 = add i64 %t8940, 1
%t8942 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8941)
%t8943 = icmp eq i64 %t8942, %p3
br label %LSL8944
LSL8944:
br i1 %t8943, label %LSR8944, label %LSJ8944
LSR8944:
%t8945 = mul i64 2, %p5
%t8946 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8945)
%t8947 = icmp eq i64 %t8946, %p2
br label %LSJ8944
LSJ8944:
%t8948 = phi i1 [ false, %LSL8944 ], [ %t8947, %LSR8944 ]
br i1 %t8948, label %L2680, label %L2682
L2680:
ret i64 %p0
L2682:
%t8949 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p4)
%t8950 = mul i64 2, %p5
%t8951 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8949, i64 %t8950, i64 %p2)
%t8952 = mul nsw i64 %t8951, 0
%t8953 = mul i64 2, %p5
%t8954 = add i64 %t8953, 1
%t8955 = call i64 @__mruntime_rt_map_resid__wset(i64 %t8949, i64 %t8954, i64 %p3)
%t8956 = mul nsw i64 %t8955, 0
%t8957 = add nsw i64 %t8952, %t8956
%t8958 = add nsw i64 %t8957, %t8949
ret i64 %t8958
L2679:
%t8959 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__hn_find(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t8994, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t8995, %tco.s0 ]
%t8961 = icmp eq i64 %p0, 0
br i1 %t8961, label %L2683, label %L2685
L2683:
ret i64 0
L2685:
%t8962 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t8963 = icmp ne i64 %t8962, 0
br i1 %t8963, label %L2686, label %L2688
L2686:
%t8964 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t8965 = tail call i64 @__mruntime_rt_map_resid__coll_find(i64 %p0, i64 %p2, i64 %p3, i64 0, i64 %t8964)
ret i64 %t8965
L2688:
%t8966 = call i64 @__mruntime_rt_map_resid__slot_bit(i64 %p1, i64 %p4)
%t8967 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8968 = and i64 %t8967, %t8966
%t8969 = icmp ne i64 %t8968, 0
br i1 %t8969, label %L2689, label %L2691
L2689:
%t8970 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8971 = sub i64 %t8966, 1
%t8972 = and i64 %t8970, %t8971
%t8973 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8972)
%t8974 = mul i64 2, %t8973
%t8975 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8974)
%t8976 = call i1 @__mruntime_rt_map_resid__key_eq(i64 %p2, i64 %t8975, i64 %p3)
br i1 %t8976, label %L2692, label %L2693
L2692:
%t8977 = call i64 @__mruntime_rt_map_resid__nw(i64 %p0)
%t8978 = mul i64 2, %t8973
%t8979 = add i64 %t8978, 1
%t8980 = mul i64 %t8979, 8
%t8981 = add i64 %t8977, %t8980
br label %L2694
L2693:
br label %L2694
L2694:
%t8982 = phi i64 [ %t8981, %L2692 ], [ 0, %L2693 ]
ret i64 %t8982
L2691:
%t8983 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8984 = and i64 %t8983, %t8966
%t8985 = icmp eq i64 %t8984, 0
br i1 %t8985, label %L2695, label %L2697
L2695:
ret i64 0
L2697:
%t8986 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t8987 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8986)
%t8988 = mul i64 2, %t8987
%t8989 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t8990 = sub i64 %t8966, 1
%t8991 = and i64 %t8989, %t8990
%t8992 = call i64 @__mruntime_rt_map_resid__popc(i64 %t8991)
%t8993 = add i64 %t8988, %t8992
%t8994 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8993)
%t8995 = add i64 %p4, 1
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t9006, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t8997 = icmp sge i64 %p3, %p4
br i1 %t8997, label %L2698, label %L2700
L2698:
ret i64 0
L2700:
%t8998 = mul i64 2, %p3
%t8999 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t8998)
%t9000 = call i1 @__mruntime_rt_map_resid__key_eq(i64 %p1, i64 %t8999, i64 %p2)
br i1 %t9000, label %L2701, label %L2703
L2701:
%t9001 = call i64 @__mruntime_rt_map_resid__nw(i64 %p0)
%t9002 = mul i64 2, %p3
%t9003 = add i64 %t9002, 1
%t9004 = mul i64 %t9003, 8
%t9005 = add i64 %t9001, %t9004
ret i64 %t9005
L2703:
%t9006 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_map_resid__node_single(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9008 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t9009 = icmp eq i64 %t9008, 1
br label %LSL9010
LSL9010:
br i1 %t9009, label %LSJ9010, label %LSR9010
LSR9010:
%t9011 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t9012 = icmp eq i64 %t9011, 0
br label %LSL9013
LSL9013:
br i1 %t9012, label %LSR9013, label %LSJ9013
LSR9013:
%t9014 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t9015 = icmp eq i64 %t9014, 0
br label %LSJ9013
LSJ9013:
%t9016 = phi i1 [ false, %LSL9013 ], [ %t9015, %LSR9013 ]
br label %LSL9017
LSL9017:
br i1 %t9016, label %LSR9017, label %LSJ9017
LSR9017:
%t9018 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9019 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9018)
%t9020 = icmp eq i64 %t9019, 1
br label %LSJ9017
LSJ9017:
%t9021 = phi i1 [ false, %LSL9017 ], [ %t9020, %LSR9017 ]
br label %LSJ9010
LSJ9010:
%t9022 = phi i1 [ true, %LSL9010 ], [ %t9021, %LSJ9017 ]
ret i1 %t9022
}
define internal i64 @__mruntime_rt_map_resid__hn_remove(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9023 = call i64 @__mruntime_rt_map_resid__mflag()
%t9024 = call i64 @st64(i64 %t9023, i64 0)
%t9025 = icmp eq i64 %p0, 0
br i1 %t9025, label %L2704, label %L2706
L2704:
ret i64 0
L2706:
%t9026 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t9027 = icmp ne i64 %t9026, 0
br i1 %t9027, label %L2707, label %L2709
L2707:
%t9028 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t9029 = tail call i64 @__mruntime_rt_map_resid__coll_remove(i64 %p0, i64 %p3, i64 %p4, i64 %p5, i64 0, i64 %t9028)
ret i64 %t9029
L2709:
%t9030 = call i64 @__mruntime_rt_map_resid__slot_bit(i64 %p2, i64 %p1)
%t9031 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t9032 = and i64 %t9031, %t9030
%t9033 = icmp ne i64 %t9032, 0
br i1 %t9033, label %L2710, label %L2712
L2710:
%t9034 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9035 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9034)
%t9036 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t9037 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9036)
%t9038 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t9039 = sub i64 %t9030, 1
%t9040 = and i64 %t9038, %t9039
%t9041 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9040)
%t9042 = mul i64 2, %t9035
%t9043 = add i64 %t9042, %t9041
%t9044 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9043)
%t9045 = add i64 %p1, 1
%t9046 = call i64 @__mruntime_rt_map_resid__hn_remove(i64 %t9044, i64 %t9045, i64 %p2, i64 %p3, i64 %p4, i64 %p5)
%t9047 = call i64 @__mruntime_rt_map_resid__mflag()
%t9048 = call i64 @ld64(i64 %t9047)
%t9049 = icmp eq i64 %t9048, 0
br i1 %t9049, label %L2713, label %L2715
L2713:
ret i64 %p0
L2715:
%t9050 = icmp eq i64 %t9046, 0
br i1 %t9050, label %L2716, label %L2718
L2716:
%t9051 = icmp eq i64 %t9035, 0
br label %LSL9052
LSL9052:
br i1 %t9051, label %LSR9052, label %LSJ9052
LSR9052:
%t9053 = icmp eq i64 %t9037, 1
br label %LSJ9052
LSJ9052:
%t9054 = phi i1 [ false, %LSL9052 ], [ %t9053, %LSR9052 ]
br i1 %t9054, label %L2719, label %L2721
L2719:
ret i64 0
L2721:
%t9055 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p5)
%t9056 = call i64 @__mruntime_rt_map_resid__nw(i64 %t9055)
%t9057 = mul i64 2, %t9035
%t9058 = add i64 %t9057, %t9041
%t9059 = mul i64 %t9058, 8
%t9060 = add i64 %t9056, %t9059
%t9061 = call i64 @__mruntime_rt_map_resid__nw(i64 %t9055)
%t9062 = mul i64 2, %t9035
%t9063 = add i64 %t9062, %t9041
%t9064 = add i64 %t9063, 1
%t9065 = mul i64 %t9064, 8
%t9066 = add i64 %t9061, %t9065
%t9067 = sub i64 %t9037, %t9041
%t9068 = sub i64 %t9067, 1
%t9069 = mul i64 %t9068, 8
%t9070 = call i64 @mcopy(i64 %t9060, i64 %t9066, i64 %t9069)
%t9071 = add i64 %t9055, 4
%t9072 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %t9055)
%t9073 = xor i64 %t9030, -1
%t9074 = and i64 %t9072, %t9073
%t9075 = call i64 @st32(i64 %t9071, i64 %t9074)
%t9076 = mul nsw i64 %t9075, 0
%t9077 = add nsw i64 %t9076, %t9055
ret i64 %t9077
L2718:
%t9078 = call i1 @__mruntime_rt_map_resid__node_single(i64 %t9046)
br i1 %t9078, label %L2722, label %L2724
L2722:
%t9079 = call i64 @__mruntime_rt_map_resid__wd(i64 %t9046, i64 0)
%t9080 = call i64 @__mruntime_rt_map_resid__wd(i64 %t9046, i64 1)
%t9081 = call i64 @__mruntime_rt_map_resid__node_sub_to_data(i64 %p0, i64 %t9030, i64 %t9079, i64 %t9080, i64 %p5)
ret i64 %t9081
L2724:
%t9082 = icmp eq i64 %t9046, %t9044
br i1 %t9082, label %L2725, label %L2727
L2725:
ret i64 %p0
L2727:
%t9083 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p5)
%t9084 = mul i64 2, %t9035
%t9085 = add i64 %t9084, %t9041
%t9086 = call i64 @__mruntime_rt_map_resid__wset(i64 %t9083, i64 %t9085, i64 %t9046)
%t9087 = mul nsw i64 %t9086, 0
%t9088 = add nsw i64 %t9087, %t9083
ret i64 %t9088
L2712:
%t9089 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9090 = and i64 %t9089, %t9030
%t9091 = icmp ne i64 %t9090, 0
br i1 %t9091, label %L2728, label %L2730
L2728:
%t9092 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9093 = sub i64 %t9030, 1
%t9094 = and i64 %t9092, %t9093
%t9095 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9094)
%t9096 = mul i64 2, %t9095
%t9097 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9096)
%t9098 = call i1 @__mruntime_rt_map_resid__key_eq(i64 %p3, i64 %t9097, i64 %p4)
%t9099 = xor i1 %t9098, true
br i1 %t9099, label %L2731, label %L2733
L2731:
ret i64 %p0
L2733:
%t9100 = call i64 @__mruntime_rt_map_resid__mflag()
%t9101 = call i64 @st64(i64 %t9100, i64 1)
%t9102 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9103 = icmp eq i64 %t9102, %t9030
br label %LSL9104
LSL9104:
br i1 %t9103, label %LSR9104, label %LSJ9104
LSR9104:
%t9105 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t9106 = icmp eq i64 %t9105, 0
br label %LSJ9104
LSJ9104:
%t9107 = phi i1 [ false, %LSL9104 ], [ %t9106, %LSR9104 ]
br i1 %t9107, label %L2734, label %L2736
L2734:
ret i64 0
L2736:
%t9108 = call i64 @__mruntime_rt_map_resid__node_words(i64 %p0)
%t9109 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p5)
%t9110 = call i64 @__mruntime_rt_map_resid__nw(i64 %t9109)
%t9111 = mul i64 2, %t9095
%t9112 = mul i64 %t9111, 8
%t9113 = add i64 %t9110, %t9112
%t9114 = call i64 @__mruntime_rt_map_resid__nw(i64 %t9109)
%t9115 = mul i64 2, %t9095
%t9116 = add i64 %t9115, 2
%t9117 = mul i64 %t9116, 8
%t9118 = add i64 %t9114, %t9117
%t9119 = mul i64 2, %t9095
%t9120 = sub i64 %t9108, %t9119
%t9121 = sub i64 %t9120, 2
%t9122 = mul i64 %t9121, 8
%t9123 = call i64 @mcopy(i64 %t9113, i64 %t9118, i64 %t9122)
%t9124 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %t9109)
%t9125 = xor i64 %t9030, -1
%t9126 = and i64 %t9124, %t9125
%t9127 = call i64 @st32(i64 %t9109, i64 %t9126)
%t9128 = mul nsw i64 %t9127, 0
%t9129 = add nsw i64 %t9128, %t9109
ret i64 %t9129
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
%p4 = phi i64 [ %p4.in, %entry ], [ %t9135, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t9130 = icmp sge i64 %p4, %p5
br i1 %t9130, label %L2737, label %L2739
L2737:
ret i64 %p0
L2739:
%t9131 = mul i64 2, %p4
%t9132 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9131)
%t9133 = call i1 @__mruntime_rt_map_resid__key_eq(i64 %p1, i64 %t9132, i64 %p2)
%t9134 = xor i1 %t9133, true
br i1 %t9134, label %L2740, label %L2742
L2740:
%t9135 = add nsw i64 %p4, 1
br label %tco.s0
tco.s0:
br label %tco.head
L2742:
%t9137 = call i64 @__mruntime_rt_map_resid__mflag()
%t9138 = call i64 @st64(i64 %t9137, i64 1)
%t9139 = icmp eq i64 %p5, 1
br i1 %t9139, label %L2743, label %L2745
L2743:
ret i64 0
L2745:
%t9140 = call i64 @__mruntime_rt_map_resid__node_room(i64 %p0, i64 0, i64 %p3)
%t9141 = call i64 @__mruntime_rt_map_resid__nw(i64 %t9140)
%t9142 = mul i64 2, %p4
%t9143 = mul i64 %t9142, 8
%t9144 = add i64 %t9141, %t9143
%t9145 = call i64 @__mruntime_rt_map_resid__nw(i64 %t9140)
%t9146 = mul i64 2, %p4
%t9147 = add i64 %t9146, 2
%t9148 = mul i64 %t9147, 8
%t9149 = add i64 %t9145, %t9148
%t9150 = sub i64 %p5, %p4
%t9151 = sub i64 %t9150, 1
%t9152 = mul i64 2, %t9151
%t9153 = mul i64 %t9152, 8
%t9154 = call i64 @mcopy(i64 %t9144, i64 %t9149, i64 %t9153)
%t9155 = add i64 %t9140, 8
%t9156 = sub nsw i64 %p5, 1
%t9157 = call i64 @st32(i64 %t9155, i64 %t9156)
%t9158 = mul nsw i64 %t9157, 0
%t9159 = add nsw i64 %t9158, %t9140
ret i64 %t9159
}
define internal i64 @__mruntime_rt_map_resid__hn_collect(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9160 = icmp eq i64 %p0, 0
br i1 %t9160, label %L2746, label %L2748
L2746:
ret i64 %p3
L2748:
%t9161 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t9162 = icmp ne i64 %t9161, 0
br i1 %t9162, label %L2749, label %L2751
L2749:
%t9163 = call i64 @__mruntime_rt_map_resid__nncoll(i64 %p0)
%t9164 = call i64 @__mruntime_rt_map_resid__coll_collect(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 %t9163)
ret i64 %t9164
L2751:
%t9165 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9166 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t9167 = or i64 %t9165, %t9166
%t9168 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9169 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9168)
%t9170 = call i64 @__mruntime_rt_map_resid__slots_collect(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %t9167, i64 %t9169)
ret i64 %t9170
}
define internal i64 @__mruntime_rt_map_resid__coll_collect(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9187, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t9188, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t9171 = icmp sge i64 %p4, %p5
br i1 %t9171, label %L2752, label %L2754
L2752:
ret i64 %p3
L2754:
%t9172 = icmp ne i64 %p1, 0
br i1 %t9172, label %L2755, label %L2756
L2755:
%t9173 = mul i64 %p3, 8
%t9174 = add i64 %p1, %t9173
%t9175 = mul i64 2, %p4
%t9176 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9175)
%t9177 = call i64 @st64(i64 %t9174, i64 %t9176)
br label %L2757
L2756:
br label %L2757
L2757:
%t9178 = phi i64 [ %t9177, %L2755 ], [ 0, %L2756 ]
%t9179 = icmp ne i64 %p2, 0
br i1 %t9179, label %L2758, label %L2759
L2758:
%t9180 = mul i64 %p3, 8
%t9181 = add i64 %p2, %t9180
%t9182 = mul i64 2, %p4
%t9183 = add i64 %t9182, 1
%t9184 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9183)
%t9185 = call i64 @st64(i64 %t9181, i64 %t9184)
br label %L2760
L2759:
br label %L2760
L2760:
%t9186 = phi i64 [ %t9185, %L2758 ], [ 0, %L2759 ]
%t9187 = add i64 %p3, 1
%t9188 = add nsw i64 %p4, 1
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t9215, %tco.s0 ], [ %t9226, %tco.s1 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t9217, %tco.s0 ], [ %t9228, %tco.s1 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ], [ %p5, %tco.s1 ]
%t9190 = icmp eq i64 %p4, 0
br i1 %t9190, label %L2761, label %L2763
L2761:
ret i64 %p3
L2763:
%t9191 = sub i64 0, %p4
%t9192 = and i64 %p4, %t9191
%t9193 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9194 = and i64 %t9193, %t9192
%t9195 = icmp ne i64 %t9194, 0
br i1 %t9195, label %L2764, label %L2766
L2764:
%t9196 = call i64 @__mruntime_rt_map_resid__ndmap(i64 %p0)
%t9197 = sub i64 %t9192, 1
%t9198 = and i64 %t9196, %t9197
%t9199 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9198)
%t9200 = icmp ne i64 %p1, 0
br i1 %t9200, label %L2767, label %L2768
L2767:
%t9201 = mul i64 %p3, 8
%t9202 = add i64 %p1, %t9201
%t9203 = mul i64 2, %t9199
%t9204 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9203)
%t9205 = call i64 @st64(i64 %t9202, i64 %t9204)
br label %L2769
L2768:
br label %L2769
L2769:
%t9206 = phi i64 [ %t9205, %L2767 ], [ 0, %L2768 ]
%t9207 = icmp ne i64 %p2, 0
br i1 %t9207, label %L2770, label %L2771
L2770:
%t9208 = mul i64 %p3, 8
%t9209 = add i64 %p2, %t9208
%t9210 = mul i64 2, %t9199
%t9211 = add i64 %t9210, 1
%t9212 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9211)
%t9213 = call i64 @st64(i64 %t9209, i64 %t9212)
br label %L2772
L2771:
br label %L2772
L2772:
%t9214 = phi i64 [ %t9213, %L2770 ], [ 0, %L2771 ]
%t9215 = add i64 %p3, 1
%t9216 = sub i64 %p4, 1
%t9217 = and i64 %p4, %t9216
br label %tco.s0
tco.s0:
br label %tco.head
L2766:
%t9219 = mul i64 2, %p5
%t9220 = call i64 @__mruntime_rt_map_resid__nnmap(i64 %p0)
%t9221 = sub i64 %t9192, 1
%t9222 = and i64 %t9220, %t9221
%t9223 = call i64 @__mruntime_rt_map_resid__popc(i64 %t9222)
%t9224 = add i64 %t9219, %t9223
%t9225 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t9224)
%t9226 = call i64 @__mruntime_rt_map_resid__hn_collect(i64 %t9225, i64 %p1, i64 %p2, i64 %p3)
%t9227 = sub i64 %p4, 1
%t9228 = and i64 %p4, %t9227
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__mcount(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9230 = tail call i64 @ld64(i64 %p0)
ret i64 %t9230
}
define internal i64 @__mruntime_rt_map_resid__mroot(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9231 = add i64 %p0, 8
%t9232 = tail call i64 @ld64(i64 %t9231)
ret i64 %t9232
}
define internal i64 @__mruntime_rt_map_resid__mtab(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9233 = add i64 %p0, 16
%t9234 = tail call i64 @ld64(i64 %t9233)
ret i64 %t9234
}
define internal i1 @__mruntime_rt_map_resid__mtrans(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9235 = add i64 %p0, 24
%t9236 = call i64 @ld64(i64 %t9235)
%t9237 = icmp ne i64 %t9236, 0
ret i1 %t9237
}
define internal i64 @__mruntime_rt_map_resid__medit(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9238 = add i64 %p0, 32
%t9239 = tail call i64 @ld64(i64 %t9238)
ret i64 %t9239
}
define internal i64 @__mruntime_rt_map_resid__mown(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9240 = add i64 %p0, 40
%t9241 = tail call i64 @ld32(i64 %t9240)
ret i64 %t9241
}
define internal i64 @__mruntime_rt_map_resid__mkk(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9242 = add i64 %p0, 44
%t9243 = tail call i64 @__mruntime_rt_map_resid__ld_i8(i64 %t9242)
ret i64 %t9243
}
define internal i64 @__mruntime_rt_map_resid__mvk(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9244 = add i64 %p0, 45
%t9245 = tail call i64 @__mruntime_rt_map_resid__ld_i8(i64 %t9244)
ret i64 %t9245
}
define internal i64 @__mruntime_rt_map_resid__trie_new(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9246 = call i64 @__mruntime_rt_map_resid__map_obj(i64 48)
%t9247 = call i64 @st64(i64 %t9246, i64 %p0)
%t9248 = add i64 %t9246, 8
%t9249 = call i64 @st64(i64 %t9248, i64 %p1)
%t9250 = add i64 %t9247, %t9249
%t9251 = add i64 %t9246, 16
%t9252 = call i64 @st64(i64 %t9251, i64 0)
%t9253 = add i64 %t9250, %t9252
%t9254 = add i64 %t9246, 24
%t9255 = call i64 @st64(i64 %t9254, i64 0)
%t9256 = add i64 %t9253, %t9255
%t9257 = add i64 %t9246, 32
%t9258 = call i64 @st64(i64 %t9257, i64 0)
%t9259 = add i64 %t9256, %t9258
%t9260 = add i64 %t9246, 40
%t9261 = call i64 @st32(i64 %t9260, i64 0)
%t9262 = add i64 %t9246, 44
%t9263 = call i64 @st8(i64 %t9262, i64 %p2)
%t9264 = add i64 %t9261, %t9263
%t9265 = add i64 %t9246, 45
%t9266 = call i64 @st8(i64 %t9265, i64 %p3)
%t9267 = add i64 %t9264, %t9266
ret i64 %t9246
}
define internal i64 @__mruntime_rt_map_resid__tcap(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9268 = tail call i64 @ld64(i64 %p0)
ret i64 %t9268
}
define internal i64 @__mruntime_rt_map_resid__tlive(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9269 = add i64 %p0, 8
%t9270 = tail call i64 @ld64(i64 %t9269)
ret i64 %t9270
}
define internal i64 @__mruntime_rt_map_resid__ttombs(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9271 = add i64 %p0, 16
%t9272 = tail call i64 @ld64(i64 %t9271)
ret i64 %t9272
}
define internal i64 @__mruntime_rt_map_resid__tkk(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9273 = add i64 %p0, 24
%t9274 = tail call i64 @__mruntime_rt_map_resid__ld_i8(i64 %t9273)
ret i64 %t9274
}
define internal i64 @__mruntime_rt_map_resid__tvk(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9275 = add i64 %p0, 25
%t9276 = tail call i64 @__mruntime_rt_map_resid__ld_i8(i64 %t9275)
ret i64 %t9276
}
define internal i1 @__mruntime_rt_map_resid__tnov(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9277 = add i64 %p0, 26
%t9278 = call i64 @ld8(i64 %t9277)
%t9279 = icmp ne i64 %t9278, 0
ret i1 %t9279
}
define internal i64 @__mruntime_rt_map_resid__tkeys(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9280 = add i64 %p0, 32
%t9281 = tail call i64 @ld64(i64 %t9280)
ret i64 %t9281
}
define internal i64 @__mruntime_rt_map_resid__tvals(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9282 = add i64 %p0, 40
%t9283 = tail call i64 @ld64(i64 %t9282)
ret i64 %t9283
}
define internal i1 @__mruntime_rt_map_resid__toob_has(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9284 = add i64 %p0, 48
%t9285 = add i64 %t9284, %p1
%t9286 = call i64 @ld8(i64 %t9285)
%t9287 = icmp ne i64 %t9286, 0
ret i1 %t9287
}
define internal i64 @__mruntime_rt_map_resid__toob_val(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9288 = add i64 %p0, 56
%t9289 = mul i64 %p1, 8
%t9290 = add i64 %t9288, %t9289
%t9291 = call i64 @ld64(i64 %t9290)
ret i64 %t9291
}
define internal i64 @__mruntime_rt_map_resid__t_empty(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9292 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9293 = icmp eq i64 %t9292, 1
br i1 %t9293, label %L2773, label %L2774
L2773:
%t9294 = call i64 @__mruntime_rt_map_resid__raw_empty()
br label %L2775
L2774:
br label %L2775
L2775:
%t9295 = phi i64 [ %t9294, %L2773 ], [ 0, %L2774 ]
ret i64 %t9295
}
define internal i64 @__mruntime_rt_map_resid__t_tomb(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9296 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9297 = icmp eq i64 %t9296, 1
br i1 %t9297, label %L2776, label %L2777
L2776:
%t9298 = call i64 @__mruntime_rt_map_resid__raw_tomb()
br label %L2778
L2777:
br label %L2778
L2778:
%t9299 = phi i64 [ %t9298, %L2776 ], [ 1, %L2777 ]
ret i64 %t9299
}
define internal i64 @__mruntime_rt_map_resid__mix(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9300 = call i64 @lshr(i64 %p0, i64 33)
%t9301 = xor i64 %p0, %t9300
%t9302 = sub nsw i64 0, 49064778989728563
%t9303 = mul i64 %t9301, %t9302
%t9304 = call i64 @lshr(i64 %t9303, i64 33)
%t9305 = xor i64 %t9303, %t9304
ret i64 %t9305
}
define internal i64 @__mruntime_rt_map_resid__t_hash(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9306 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9307 = icmp eq i64 %t9306, 1
br i1 %t9307, label %L2779, label %L2780
L2779:
%t9308 = call i64 @__mruntime_rt_map_resid__mix(i64 %p1)
br label %L2781
L2780:
%t9309 = call i64 @__mruntime_rt_map_resid__value_hash(i64 %p1)
br label %L2781
L2781:
%t9310 = phi i64 [ %t9308, %L2779 ], [ %t9309, %L2780 ]
ret i64 %t9310
}
define internal i1 @__mruntime_rt_map_resid__t_keq(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9311 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9312 = icmp eq i64 %t9311, 1
br i1 %t9312, label %L2782, label %L2783
L2782:
%t9313 = icmp eq i64 %p1, %p2
br label %L2784
L2783:
%t9314 = call i1 @__mruntime_rt_map_resid__value_eq(i64 %p1, i64 %p2)
br label %L2784
L2784:
%t9315 = phi i1 [ %t9313, %L2782 ], [ %t9314, %L2783 ]
ret i1 %t9315
}
define internal i64 @__mruntime_rt_map_resid__t_oob(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9316 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9317 = icmp ne i64 %t9316, 1
br i1 %t9317, label %L2785, label %L2787
L2785:
%t9318 = sub nsw i64 0, 1
ret i64 %t9318
L2787:
%t9319 = call i64 @__mruntime_rt_map_resid__raw_empty()
%t9320 = icmp eq i64 %p1, %t9319
br i1 %t9320, label %L2788, label %L2790
L2788:
ret i64 0
L2790:
%t9321 = call i64 @__mruntime_rt_map_resid__raw_tomb()
%t9322 = icmp eq i64 %p1, %t9321
br i1 %t9322, label %L2791, label %L2793
L2791:
ret i64 1
L2793:
%t9323 = sub nsw i64 0, 1
ret i64 %t9323
}
define internal i64 @__mruntime_rt_map_resid__t_alloc(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9324 = call i64 @st64(i64 %p0, i64 %p1)
%t9325 = mul i64 %p1, 8
%t9326 = call i64 @__mruntime_rt_map_resid__map_obj(i64 %t9325)
%t9327 = add i64 %p0, 32
%t9328 = call i64 @st64(i64 %t9327, i64 %t9326)
%t9329 = add i64 %p0, 40
%t9330 = call i1 @__mruntime_rt_map_resid__tnov(i64 %p0)
br i1 %t9330, label %L2794, label %L2795
L2794:
br label %L2796
L2795:
%t9331 = mul i64 %p1, 8
%t9332 = call i64 @__mruntime_rt_map_resid__map_obj(i64 %t9331)
br label %L2796
L2796:
%t9333 = phi i64 [ 0, %L2794 ], [ %t9332, %L2795 ]
%t9334 = call i64 @st64(i64 %t9329, i64 %t9333)
%t9335 = call i64 @__mruntime_rt_map_resid__t_empty(i64 %p0)
%t9336 = call i64 @__mruntime_rt_map_resid__fill_words(i64 %t9326, i64 %t9335, i64 0, i64 %p1)
ret i64 %t9336
}
define internal i64 @__mruntime_rt_map_resid__fill_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9341, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t9337 = icmp sge i64 %p2, %p3
br i1 %t9337, label %L2797, label %L2799
L2797:
ret i64 0
L2799:
%t9338 = mul i64 %p2, 8
%t9339 = add i64 %p0, %t9338
%t9340 = call i64 @st64(i64 %t9339, i64 %p1)
%t9341 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__tab_new(i64 %p0, i64 %p1, i64 %p2, i1 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9343 = call i64 @__mruntime_rt_map_resid__map_obj(i64 96)
%t9344p = inttoptr i64 %t9343 to ptr
%t9344q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t9344p, i8 %t9344q, i64 96, i1 false)
%t9344 = add i64 0, 0
%t9345 = call i64 @st64(i64 %t9343, i64 %p0)
%t9346 = add i64 %t9343, 24
%t9347 = call i64 @st8(i64 %t9346, i64 %p1)
%t9348 = add i64 %t9343, 25
%t9349 = call i64 @st8(i64 %t9348, i64 %p2)
%t9350 = add i64 %t9347, %t9349
%t9351 = add i64 %t9343, 26
br i1 %p3, label %L2800, label %L2801
L2800:
br label %L2802
L2801:
br label %L2802
L2802:
%t9352 = phi i64 [ 1, %L2800 ], [ 0, %L2801 ]
%t9353 = call i64 @st8(i64 %t9351, i64 %t9352)
%t9354 = add i64 %t9350, %t9353
%t9355 = sub nsw i64 0, 1
%t9356 = icmp ne i64 %p1, %t9355
br i1 %t9356, label %L2803, label %L2804
L2803:
%t9357 = call i64 @__mruntime_rt_map_resid__t_alloc(i64 %t9343, i64 %p0)
br label %L2805
L2804:
br label %L2805
L2805:
%t9358 = phi i64 [ %t9357, %L2803 ], [ 0, %L2804 ]
ret i64 %t9343
}
define internal i1 @__mruntime_rt_map_resid__t_over(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9359 = mul i64 %p0, 2
%t9360 = icmp sgt i64 %t9359, %p1
ret i1 %t9360
}
define internal i64 @__mruntime_rt_map_resid__cap_for(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9361 = call i64 @__mruntime_rt_map_resid__cap_for_at(i64 %p0, i64 16)
ret i64 %t9361
}
define internal i64 @__mruntime_rt_map_resid__cap_for_at(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9362 = add i64 %p0, 1
%t9363 = call i1 @__mruntime_rt_map_resid__t_over(i64 %t9362, i64 %p1)
br i1 %t9363, label %L2806, label %L2807
L2806:
%t9364 = mul i64 %p1, 2
%t9365 = call i64 @__mruntime_rt_map_resid__cap_for_at(i64 %p0, i64 %t9364)
br label %L2808
L2807:
br label %L2808
L2808:
%t9366 = phi i64 [ %t9365, %L2806 ], [ %p1, %L2807 ]
ret i64 %t9366
}
define internal i64 @__mruntime_rt_map_resid__t_probe(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9367 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9368 = sub i64 %t9367, 1
%t9369 = call i64 @__mruntime_rt_map_resid__t_hash(i64 %p0, i64 %p1)
%t9370 = and i64 %t9369, %t9368
%t9371 = call i64 @__mruntime_rt_map_resid__t_empty(i64 %p0)
%t9372 = call i64 @__mruntime_rt_map_resid__t_tomb(i64 %p0)
%t9373 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9374 = call i64 @__mruntime_rt_map_resid__probe_at(i64 %p0, i64 %p1, i64 %t9370, i64 %t9368, i64 %t9371, i64 %t9372, i64 %t9373)
ret i64 %t9374
}
define internal i64 @__mruntime_rt_map_resid__probe_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9386, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ]
%t9375 = mul i64 %p2, 8
%t9376 = add i64 %p6, %t9375
%t9377 = call i64 @ld64(i64 %t9376)
%t9378 = icmp eq i64 %t9377, %p4
br i1 %t9378, label %L2809, label %L2811
L2809:
%t9379 = sub i64 0, %p2
%t9380 = sub nsw i64 %t9379, 1
ret i64 %t9380
L2811:
%t9381 = icmp ne i64 %t9377, %p5
br label %LSL9382
LSL9382:
br i1 %t9381, label %LSR9382, label %LSJ9382
LSR9382:
%t9383 = call i1 @__mruntime_rt_map_resid__t_keq(i64 %p0, i64 %t9377, i64 %p1)
br label %LSJ9382
LSJ9382:
%t9384 = phi i1 [ false, %LSL9382 ], [ %t9383, %LSR9382 ]
br i1 %t9384, label %L2812, label %L2814
L2812:
ret i64 %p2
L2814:
%t9385 = add i64 %p2, 1
%t9386 = and i64 %t9385, %p3
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__probe_raw_cached(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9388 = add i64 %p0, 72
%t9389 = call i64 @ld8(i64 %t9388)
%t9390 = icmp ne i64 %t9389, 0
br label %LSL9391
LSL9391:
br i1 %t9390, label %LSR9391, label %LSJ9391
LSR9391:
%t9392 = add i64 %p0, 80
%t9393 = call i64 @ld64(i64 %t9392)
%t9394 = icmp eq i64 %t9393, %p1
br label %LSJ9391
LSJ9391:
%t9395 = phi i1 [ false, %LSL9391 ], [ %t9394, %LSR9391 ]
br i1 %t9395, label %L2815, label %L2817
L2815:
%t9396 = add i64 %p0, 88
%t9397 = call i64 @ld64(i64 %t9396)
ret i64 %t9397
L2817:
%t9398 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9399 = sub i64 %t9398, 1
%t9400 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9401 = call i64 @__mruntime_rt_map_resid__mix(i64 %p1)
%t9402 = and i64 %t9401, %t9399
%t9403 = call i64 @__mruntime_rt_map_resid__probe_raw(i64 %t9400, i64 %p1, i64 %t9402, i64 %t9399)
%t9404 = add i64 %p0, 72
%t9405 = call i64 @st8(i64 %t9404, i64 1)
%t9406 = add i64 %p0, 80
%t9407 = call i64 @st64(i64 %t9406, i64 %p1)
%t9408 = add i64 %p0, 88
%t9409 = call i64 @st64(i64 %t9408, i64 %t9403)
%t9410 = mul nsw i64 %t9409, 0
%t9411 = add nsw i64 %t9410, %t9403
ret i64 %t9411
}
define internal i64 @__mruntime_rt_map_resid__probe_raw(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9421, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t9412 = mul i64 %p2, 8
%t9413 = add i64 %p0, %t9412
%t9414 = call i64 @ld64(i64 %t9413)
%t9415 = call i64 @__mruntime_rt_map_resid__raw_empty()
%t9416 = icmp eq i64 %t9414, %t9415
br i1 %t9416, label %L2818, label %L2820
L2818:
%t9417 = sub i64 0, %p2
%t9418 = sub nsw i64 %t9417, 1
ret i64 %t9418
L2820:
%t9419 = icmp eq i64 %t9414, %p1
br i1 %t9419, label %L2821, label %L2823
L2821:
ret i64 %p2
L2823:
%t9420 = add i64 %p2, 1
%t9421 = and i64 %t9420, %p3
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__t_next(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ], [ %p0, %tco.s2 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9423, %tco.s0 ], [ %t9438, %tco.s1 ], [ %t9457, %tco.s2 ]
%t9423 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9424 = icmp slt i64 %p1, %t9423
br i1 %t9424, label %L2824, label %L2826
L2824:
%t9425 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9426 = icmp eq i64 %t9425, 0
br i1 %t9426, label %L2827, label %L2829
L2827:
br label %tco.s0
tco.s0:
br label %tco.head
L2829:
%t9428 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9429 = mul i64 %p1, 8
%t9430 = add i64 %t9428, %t9429
%t9431 = call i64 @ld64(i64 %t9430)
%t9432 = call i64 @__mruntime_rt_map_resid__t_empty(i64 %p0)
%t9433 = icmp eq i64 %t9431, %t9432
br label %LSL9434
LSL9434:
br i1 %t9433, label %LSJ9434, label %LSR9434
LSR9434:
%t9435 = call i64 @__mruntime_rt_map_resid__t_tomb(i64 %p0)
%t9436 = icmp eq i64 %t9431, %t9435
br label %LSJ9434
LSJ9434:
%t9437 = phi i1 [ true, %LSL9434 ], [ %t9436, %LSR9434 ]
br i1 %t9437, label %L2830, label %L2832
L2830:
%t9438 = add nsw i64 %p1, 1
br label %tco.s1
tco.s1:
br label %tco.head
L2832:
%t9440 = call i64 @__mruntime_rt_map_resid__mret()
%t9441 = call i64 @st64(i64 %t9440, i64 %t9431)
%t9442 = call i64 @__mruntime_rt_map_resid__mflag()
%t9443 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9444 = icmp ne i64 %t9443, 0
br i1 %t9444, label %L2833, label %L2834
L2833:
%t9445 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9446 = mul i64 %p1, 8
%t9447 = add i64 %t9445, %t9446
%t9448 = call i64 @ld64(i64 %t9447)
br label %L2835
L2834:
br label %L2835
L2835:
%t9449 = phi i64 [ %t9448, %L2833 ], [ 1, %L2834 ]
%t9450 = call i64 @st64(i64 %t9442, i64 %t9449)
%t9451 = add nsw i64 %p1, 1
ret i64 %t9451
L2826:
%t9452 = add i64 %t9423, 2
%t9453 = icmp slt i64 %p1, %t9452
br i1 %t9453, label %L2836, label %L2838
L2836:
%t9454 = sub i64 %p1, %t9423
%t9455 = call i1 @__mruntime_rt_map_resid__toob_has(i64 %p0, i64 %t9454)
%t9456 = xor i1 %t9455, true
br i1 %t9456, label %L2839, label %L2841
L2839:
%t9457 = add nsw i64 %p1, 1
br label %tco.s2
tco.s2:
br label %tco.head
L2841:
%t9459 = call i64 @__mruntime_rt_map_resid__mret()
%t9460 = icmp eq i64 %t9454, 0
br i1 %t9460, label %L2842, label %L2843
L2842:
%t9461 = call i64 @__mruntime_rt_map_resid__raw_empty()
br label %L2844
L2843:
%t9462 = call i64 @__mruntime_rt_map_resid__raw_tomb()
br label %L2844
L2844:
%t9463 = phi i64 [ %t9461, %L2842 ], [ %t9462, %L2843 ]
%t9464 = call i64 @st64(i64 %t9459, i64 %t9463)
%t9465 = call i64 @__mruntime_rt_map_resid__mflag()
%t9466 = call i64 @__mruntime_rt_map_resid__toob_val(i64 %p0, i64 %t9454)
%t9467 = call i64 @st64(i64 %t9465, i64 %t9466)
%t9468 = add nsw i64 %p1, 1
ret i64 %t9468
L2838:
%t9469 = sub nsw i64 0, 1
ret i64 %t9469
}
define internal i64 @__mruntime_rt_map_resid__t_rebuild(i64 %p0, i64 %p1, i64 %p2, i1 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9470 = call i64 @xmalloc(i64 96)
%t9471 = call i64 @mcopy(i64 %t9470, i64 %p0, i64 96)
%t9472 = add i64 %p0, 24
%t9473 = call i64 @st8(i64 %t9472, i64 %p2)
%t9474 = add i64 %p0, 8
%t9475 = call i64 @st64(i64 %t9474, i64 0)
%t9476 = add i64 %p0, 16
%t9477 = call i64 @st64(i64 %t9476, i64 0)
%t9478 = add i64 %t9475, %t9477
%t9479 = add i64 %p0, 48
%t9480 = call i64 @st8(i64 %t9479, i64 0)
%t9481 = add i64 %t9478, %t9480
%t9482 = add i64 %p0, 49
%t9483 = call i64 @st8(i64 %t9482, i64 0)
%t9484 = add i64 %t9481, %t9483
%t9485 = add i64 %p0, 72
%t9486 = call i64 @st8(i64 %t9485, i64 0)
%t9487 = add i64 %t9484, %t9486
%t9488 = call i64 @__mruntime_rt_map_resid__t_alloc(i64 %p0, i64 %p1)
%t9489 = call i64 @__mruntime_rt_map_resid__rebuild_from(i64 %p0, i64 %t9470, i64 0, i1 %p3)
%t9490 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %t9470)
%t9491 = call i64 @__mruntime_rt_map_resid__map_obj_free(i64 %t9490)
%t9492 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t9470)
%t9493 = call i64 @__mruntime_rt_map_resid__map_obj_free(i64 %t9492)
%t9494 = add i64 %t9491, %t9493
%t9495 = call i64 @c_free(i64 %t9470)
ret i64 %t9495
}
define internal i64 @__mruntime_rt_map_resid__rebuild_from(i64 %p0.in, i64 %p1.in, i64 %p2.in, i1 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9496, %tco.s0 ]
%p3 = phi i1 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t9496 = call i64 @__mruntime_rt_map_resid__t_next(i64 %p1, i64 %p2)
%t9497 = icmp slt i64 %t9496, 0
br i1 %t9497, label %L2845, label %L2847
L2845:
ret i64 0
L2847:
%t9498 = call i64 @__mruntime_rt_map_resid__mret()
%t9499 = call i64 @ld64(i64 %t9498)
%t9500 = call i64 @__mruntime_rt_map_resid__mflag()
%t9501 = call i64 @ld64(i64 %t9500)
br i1 %p3, label %L2848, label %L2849
L2848:
%t9502 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p1)
%t9503 = call i64 @__mruntime_rt_map_resid__mbox(i64 %t9502, i64 %t9499)
br label %L2850
L2849:
br label %L2850
L2850:
%t9504 = phi i64 [ %t9503, %L2848 ], [ %t9499, %L2849 ]
%t9505 = call i64 @__mruntime_rt_map_resid__t_insert_new(i64 %p0, i64 %t9504, i64 %t9501)
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__t_insert_new(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9507 = call i64 @__mruntime_rt_map_resid__t_oob(i64 %p0, i64 %p1)
%t9508 = icmp sge i64 %t9507, 0
br i1 %t9508, label %L2851, label %L2853
L2851:
%t9509 = add i64 %p0, 48
%t9510 = add i64 %t9509, %t9507
%t9511 = call i64 @st8(i64 %t9510, i64 1)
%t9512 = add i64 %p0, 56
%t9513 = mul i64 %t9507, 8
%t9514 = add i64 %t9512, %t9513
%t9515 = call i64 @st64(i64 %t9514, i64 %p2)
%t9516 = add i64 %t9511, %t9515
%t9517 = add i64 %p0, 8
%t9518 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9519 = add i64 %t9518, 1
%t9520 = call i64 @st64(i64 %t9517, i64 %t9519)
%t9521 = add i64 %t9516, %t9520
ret i64 %t9521
L2853:
%t9522 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9523 = call i64 @__mruntime_rt_map_resid__ttombs(i64 %p0)
%t9524 = add i64 %t9522, %t9523
%t9525 = add i64 %t9524, 1
%t9526 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9527 = call i1 @__mruntime_rt_map_resid__t_over(i64 %t9525, i64 %t9526)
br i1 %t9527, label %L2854, label %L2855
L2854:
%t9528 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9529 = mul i64 %t9528, 4
%t9530 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9531 = icmp sgt i64 %t9529, %t9530
br i1 %t9531, label %L2857, label %L2858
L2857:
%t9532 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9533 = mul i64 %t9532, 2
br label %L2859
L2858:
%t9534 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
br label %L2859
L2859:
%t9535 = phi i64 [ %t9533, %L2857 ], [ %t9534, %L2858 ]
%t9536 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9537 = call i64 @__mruntime_rt_map_resid__t_rebuild(i64 %p0, i64 %t9535, i64 %t9536, i1 false)
br label %L2856
L2855:
br label %L2856
L2856:
%t9538 = phi i64 [ %t9537, %L2859 ], [ 0, %L2855 ]
%t9539 = call i64 @__mruntime_rt_map_resid__t_probe(i64 %p0, i64 %p1)
%t9540 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9541 = sub i64 0, %t9539
%t9542 = sub nsw i64 %t9541, 1
%t9543 = mul i64 %t9542, 8
%t9544 = add i64 %t9540, %t9543
%t9545 = call i64 @st64(i64 %t9544, i64 %p1)
%t9546 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9547 = icmp ne i64 %t9546, 0
br i1 %t9547, label %L2860, label %L2861
L2860:
%t9548 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9549 = sub i64 0, %t9539
%t9550 = sub nsw i64 %t9549, 1
%t9551 = mul i64 %t9550, 8
%t9552 = add i64 %t9548, %t9551
%t9553 = call i64 @st64(i64 %t9552, i64 %p2)
br label %L2862
L2861:
br label %L2862
L2862:
%t9554 = phi i64 [ %t9553, %L2860 ], [ 0, %L2861 ]
%t9555 = add i64 %p0, 8
%t9556 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9557 = add i64 %t9556, 1
%t9558 = call i64 @st64(i64 %t9555, i64 %t9557)
%t9559 = add i64 %p0, 72
%t9560 = call i64 @st8(i64 %t9559, i64 0)
ret i64 %t9560
}
define internal i64 @__mruntime_rt_map_resid__t_decide(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9561 = call i64 @__mruntime_rt_map_resid__tvk(i64 %p0)
%t9562 = sub nsw i64 0, 1
%t9563 = icmp eq i64 %t9561, %t9562
br i1 %t9563, label %L2863, label %L2864
L2863:
%t9564 = add i64 %p0, 25
%t9565 = call i64 @st8(i64 %t9564, i64 %p2)
br label %L2865
L2864:
br label %L2865
L2865:
%t9566 = phi i64 [ %t9565, %L2863 ], [ 0, %L2864 ]
%t9567 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9568 = sub nsw i64 0, 1
%t9569 = icmp ne i64 %t9567, %t9568
br i1 %t9569, label %L2866, label %L2868
L2866:
ret i64 0
L2868:
%t9570 = add i64 %p0, 24
%t9571 = call i64 @st8(i64 %t9570, i64 %p1)
%t9572 = add i64 %p0, 26
%t9573 = icmp eq i64 %p2, 0
br label %LSL9574
LSL9574:
br i1 %t9573, label %LSR9574, label %LSJ9574
LSR9574:
%t9575 = icmp eq i64 %p3, 1
br label %LSJ9574
LSJ9574:
%t9576 = phi i1 [ false, %LSL9574 ], [ %t9575, %LSR9574 ]
br i1 %t9576, label %L2869, label %L2870
L2869:
br label %L2871
L2870:
br label %L2871
L2871:
%t9577 = phi i64 [ 1, %L2869 ], [ 0, %L2870 ]
%t9578 = call i64 @st8(i64 %t9572, i64 %t9577)
%t9579 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9580 = call i64 @__mruntime_rt_map_resid__t_alloc(i64 %p0, i64 %t9579)
ret i64 %t9580
}
define internal i64 @__mruntime_rt_map_resid__t_vals_make(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9581 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9582 = mul i64 %t9581, 8
%t9583 = call i64 @__mruntime_rt_map_resid__map_obj(i64 %t9582)
%t9584 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9585 = call i64 @__mruntime_rt_map_resid__fill_words(i64 %t9583, i64 1, i64 0, i64 %t9584)
%t9586 = add i64 %p0, 40
%t9587 = call i64 @st64(i64 %t9586, i64 %t9583)
%t9588 = add i64 %p0, 26
%t9589 = call i64 @st8(i64 %t9588, i64 0)
ret i64 %t9589
}
define internal i64 @__mruntime_rt_map_resid__t_vals_boxed(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9590 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9591 = call i64 @__mruntime_rt_map_resid__vals_box_at(i64 %p0, i64 0, i64 %t9590)
%t9592 = call i1 @__mruntime_rt_map_resid__toob_has(i64 %p0, i64 0)
br i1 %t9592, label %L2872, label %L2873
L2872:
%t9593 = add i64 %p0, 56
%t9594 = call i64 @__mruntime_rt_map_resid__tvk(i64 %p0)
%t9595 = call i64 @__mruntime_rt_map_resid__toob_val(i64 %p0, i64 0)
%t9596 = call i64 @__mruntime_rt_map_resid__mbox(i64 %t9594, i64 %t9595)
%t9597 = call i64 @st64(i64 %t9593, i64 %t9596)
br label %L2874
L2873:
br label %L2874
L2874:
%t9598 = phi i64 [ %t9597, %L2872 ], [ 0, %L2873 ]
%t9599 = call i1 @__mruntime_rt_map_resid__toob_has(i64 %p0, i64 1)
br i1 %t9599, label %L2875, label %L2876
L2875:
%t9600 = add i64 %p0, 64
%t9601 = call i64 @__mruntime_rt_map_resid__tvk(i64 %p0)
%t9602 = call i64 @__mruntime_rt_map_resid__toob_val(i64 %p0, i64 1)
%t9603 = call i64 @__mruntime_rt_map_resid__mbox(i64 %t9601, i64 %t9602)
%t9604 = call i64 @st64(i64 %t9600, i64 %t9603)
br label %L2877
L2876:
br label %L2877
L2877:
%t9605 = phi i64 [ %t9604, %L2875 ], [ 0, %L2876 ]
%t9606 = add i64 %p0, 25
%t9607 = call i64 @st8(i64 %t9606, i64 0)
ret i64 %t9607
}
define internal i64 @__mruntime_rt_map_resid__vals_box_at(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9630, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t9608 = icmp sge i64 %p1, %p2
br i1 %t9608, label %L2878, label %L2880
L2878:
ret i64 0
L2880:
%t9609 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9610 = mul i64 %p1, 8
%t9611 = add i64 %t9609, %t9610
%t9612 = call i64 @ld64(i64 %t9611)
%t9613 = call i64 @__mruntime_rt_map_resid__t_empty(i64 %p0)
%t9614 = icmp ne i64 %t9612, %t9613
br label %LSL9615
LSL9615:
br i1 %t9614, label %LSR9615, label %LSJ9615
LSR9615:
%t9616 = call i64 @__mruntime_rt_map_resid__t_tomb(i64 %p0)
%t9617 = icmp ne i64 %t9612, %t9616
br label %LSJ9615
LSJ9615:
%t9618 = phi i1 [ false, %LSL9615 ], [ %t9617, %LSR9615 ]
br i1 %t9618, label %L2881, label %L2882
L2881:
%t9619 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9620 = mul i64 %p1, 8
%t9621 = add i64 %t9619, %t9620
%t9622 = call i64 @__mruntime_rt_map_resid__tvk(i64 %p0)
%t9623 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9624 = mul i64 %p1, 8
%t9625 = add i64 %t9623, %t9624
%t9626 = call i64 @ld64(i64 %t9625)
%t9627 = call i64 @__mruntime_rt_map_resid__mbox(i64 %t9622, i64 %t9626)
%t9628 = call i64 @st64(i64 %t9621, i64 %t9627)
br label %L2883
L2882:
br label %L2883
L2883:
%t9629 = phi i64 [ %t9628, %L2881 ], [ 0, %L2882 ]
%t9630 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__t_key_in(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9632 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9633 = icmp eq i64 %t9632, %p1
br i1 %t9633, label %L2884, label %L2886
L2884:
ret i64 %p2
L2886:
%t9634 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9635 = icmp eq i64 %t9634, 0
br i1 %t9635, label %L2887, label %L2889
L2887:
%t9636 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
ret i64 %t9636
L2889:
%t9637 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9638 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %t9637, i64 %p2)
br i1 %t9638, label %L2890, label %L2892
L2890:
%t9639 = call i64 @__mruntime_rt_map_resid__mret()
%t9640 = call i64 @ld64(i64 %t9639)
ret i64 %t9640
L2892:
%t9641 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t9642 = call i64 @__mruntime_rt_map_resid__t_rebuild(i64 %p0, i64 %t9641, i64 0, i1 true)
ret i64 %p2
}
define internal i64 @__mruntime_rt_map_resid__t_val_in(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9643 = call i64 @__mruntime_rt_map_resid__tvk(i64 %p0)
%t9644 = icmp eq i64 %t9643, %p1
br i1 %t9644, label %L2893, label %L2895
L2893:
ret i64 %p2
L2895:
%t9645 = call i64 @__mruntime_rt_map_resid__tvk(i64 %p0)
%t9646 = icmp eq i64 %t9645, 0
br i1 %t9646, label %L2896, label %L2898
L2896:
%t9647 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
ret i64 %t9647
L2898:
%t9648 = icmp eq i64 %p1, 0
br label %LSL9649
LSL9649:
br i1 %t9648, label %LSR9649, label %LSJ9649
LSR9649:
%t9650 = call i64 @__mruntime_rt_map_resid__tvk(i64 %p0)
%t9651 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %t9650, i64 %p2)
br label %LSJ9649
LSJ9649:
%t9652 = phi i1 [ false, %LSL9649 ], [ %t9651, %LSR9649 ]
br i1 %t9652, label %L2899, label %L2901
L2899:
%t9653 = call i64 @__mruntime_rt_map_resid__mret()
%t9654 = call i64 @ld64(i64 %t9653)
ret i64 %t9654
L2901:
%t9655 = call i64 @__mruntime_rt_map_resid__t_vals_boxed(i64 %p0)
%t9656 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
ret i64 %t9656
}
define internal i64 @__mruntime_rt_map_resid__word_out(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9657 = icmp eq i64 %p0, %p1
br label %LSL9658
LSL9658:
br i1 %t9657, label %LSJ9658, label %LSR9658
LSR9658:
%t9659 = sub nsw i64 0, 1
%t9660 = icmp eq i64 %p0, %t9659
br label %LSJ9658
LSJ9658:
%t9661 = phi i1 [ true, %LSL9658 ], [ %t9660, %LSR9658 ]
br i1 %t9661, label %L2902, label %L2904
L2902:
ret i64 %p2
L2904:
%t9662 = icmp eq i64 %p1, 0
br i1 %t9662, label %L2905, label %L2907
L2905:
%t9663 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p0, i64 %p2)
ret i64 %t9663
L2907:
%t9664 = icmp eq i64 %p0, 0
br label %LSL9665
LSL9665:
br i1 %t9664, label %LSR9665, label %LSJ9665
LSR9665:
%t9666 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %p1, i64 %p2)
br label %LSJ9665
LSJ9665:
%t9667 = phi i1 [ false, %LSL9665 ], [ %t9666, %LSR9665 ]
br i1 %t9667, label %L2908, label %L2910
L2908:
%t9668 = call i64 @__mruntime_rt_map_resid__mret()
%t9669 = call i64 @ld64(i64 %t9668)
ret i64 %t9669
L2910:
ret i64 %p2
}
define internal i64 @__mruntime_rt_map_resid__map_one() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9670p = getelementptr i8, ptr @rtg.map_one, i64 0
%t9670 = ptrtoint ptr %t9670p to i64
ret i64 %t9670
}
define internal i64 @__mruntime_rt_map_resid__t_vref(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9671 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9672 = icmp eq i64 %t9671, 0
br label %LSL9673
LSL9673:
br i1 %t9672, label %LSJ9673, label %LSR9673
LSR9673:
%t9674 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9675 = icmp eq i64 %t9674, 0
br label %LSJ9673
LSJ9673:
%t9676 = phi i1 [ true, %LSL9673 ], [ %t9675, %LSR9673 ]
br i1 %t9676, label %L2911, label %L2913
L2911:
ret i64 0
L2913:
%t9677 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9678 = icmp eq i64 %t9677, %p1
br label %LSL9679
LSL9679:
br i1 %t9678, label %LSJ9679, label %LSR9679
LSR9679:
%t9680 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9681 = icmp eq i64 %t9680, 0
br label %LSL9682
LSL9682:
br i1 %t9681, label %LSR9682, label %LSJ9682
LSR9682:
%t9683 = icmp eq i64 %p1, 1
br label %LSJ9682
LSJ9682:
%t9684 = phi i1 [ false, %LSL9682 ], [ %t9683, %LSR9682 ]
br label %LSJ9679
LSJ9679:
%t9685 = phi i1 [ true, %LSL9679 ], [ %t9684, %LSJ9682 ]
br label %LSL9686
LSL9686:
br i1 %t9685, label %LSJ9686, label %LSR9686
LSR9686:
%t9687 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9688 = icmp ne i64 %t9687, 0
br label %LSL9689
LSL9689:
br i1 %t9688, label %LSR9689, label %LSJ9689
LSR9689:
%t9690 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9691 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %t9690, i64 %p2)
br label %LSJ9689
LSJ9689:
%t9692 = phi i1 [ false, %LSL9689 ], [ %t9691, %LSR9689 ]
br label %LSJ9686
LSJ9686:
%t9693 = phi i1 [ true, %LSL9686 ], [ %t9692, %LSJ9689 ]
%t9694 = xor i1 %t9693, true
br i1 %t9694, label %L2914, label %L2916
L2914:
ret i64 0
L2916:
br i1 %t9678, label %L2917, label %L2918
L2917:
br label %L2919
L2918:
%t9695 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9696 = icmp eq i64 %t9695, 0
br i1 %t9696, label %L2920, label %L2921
L2920:
%t9697 = call i64 @c_box_i64(i64 %p2)
br label %L2922
L2921:
%t9698 = call i64 @__mruntime_rt_map_resid__mret()
%t9699 = call i64 @ld64(i64 %t9698)
br label %L2922
L2922:
%t9700 = phi i64 [ %t9697, %L2920 ], [ %t9699, %L2921 ]
br label %L2919
L2919:
%t9701 = phi i64 [ %p2, %L2917 ], [ %t9700, %L2922 ]
%t9702 = call i64 @__mruntime_rt_map_resid__t_oob(i64 %p0, i64 %t9701)
%t9703 = icmp sge i64 %t9702, 0
br i1 %t9703, label %L2923, label %L2925
L2923:
%t9704 = call i1 @__mruntime_rt_map_resid__toob_has(i64 %p0, i64 %t9702)
br i1 %t9704, label %L2926, label %L2927
L2926:
%t9705 = add i64 %p0, 56
%t9706 = mul i64 %t9702, 8
%t9707 = add i64 %t9705, %t9706
br label %L2928
L2927:
br label %L2928
L2928:
%t9708 = phi i64 [ %t9707, %L2926 ], [ 0, %L2927 ]
ret i64 %t9708
L2925:
%t9709 = call i64 @__mruntime_rt_map_resid__t_probe(i64 %p0, i64 %t9701)
%t9710 = icmp slt i64 %t9709, 0
br i1 %t9710, label %L2929, label %L2931
L2929:
ret i64 0
L2931:
%t9711 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9712 = icmp ne i64 %t9711, 0
br i1 %t9712, label %L2932, label %L2934
L2932:
%t9713 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t9714 = mul i64 %t9709, 8
%t9715 = add i64 %t9713, %t9714
ret i64 %t9715
L2934:
%t9716 = call i64 @__mruntime_rt_map_resid__map_one()
%t9717 = call i64 @st64(i64 %t9716, i64 1)
%t9718 = mul nsw i64 %t9717, 0
%t9719 = call i64 @__mruntime_rt_map_resid__map_one()
%t9720 = add nsw i64 %t9718, %t9719
ret i64 %t9720
}
define internal i64 @__mruntime_rt_map_resid__t_put_s(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9721 = call i64 @__mruntime_rt_map_resid__t_decide(i64 %p0, i64 %p1, i64 %p3, i64 %p4)
%t9722 = call i64 @__mruntime_rt_map_resid__t_key_in(i64 %p0, i64 %p1, i64 %p2)
%t9723 = call i64 @__mruntime_rt_map_resid__t_val_in(i64 %p0, i64 %p3, i64 %p4)
%t9724 = call i1 @__mruntime_rt_map_resid__tnov(i64 %p0)
br label %LSL9725
LSL9725:
br i1 %t9724, label %LSR9725, label %LSJ9725
LSR9725:
%t9726 = icmp ne i64 %t9723, 1
br label %LSJ9725
LSJ9725:
%t9727 = phi i1 [ false, %LSL9725 ], [ %t9726, %LSR9725 ]
br i1 %t9727, label %L2935, label %L2936
L2935:
%t9728 = call i64 @__mruntime_rt_map_resid__t_vals_make(i64 %p0)
br label %L2937
L2936:
br label %L2937
L2937:
%t9729 = phi i64 [ %t9728, %L2935 ], [ 0, %L2936 ]
%t9730 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9731 = call i64 @__mruntime_rt_map_resid__t_vref(i64 %p0, i64 %t9730, i64 %t9722)
%t9732 = icmp ne i64 %p6, 0
br i1 %t9732, label %L2938, label %L2939
L2938:
%t9733 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %p6, i64 %t9723)
br label %L2940
L2939:
br label %L2940
L2940:
%t9734 = phi i64 [ %t9733, %L2938 ], [ %t9723, %L2939 ]
%t9735 = icmp ne i64 %t9731, 0
br i1 %t9735, label %L2941, label %L2943
L2941:
%t9736 = call i1 @__mruntime_rt_map_resid__tnov(i64 %p0)
%t9737 = xor i1 %t9736, true
br i1 %t9737, label %L2944, label %L2945
L2944:
%t9738 = call i64 @st64(i64 %t9731, i64 %t9734)
br label %L2946
L2945:
br label %L2946
L2946:
%t9739 = phi i64 [ %t9738, %L2944 ], [ 0, %L2945 ]
ret i64 %t9739
L2943:
%t9740 = icmp ne i64 %p5, 0
br i1 %t9740, label %L2947, label %L2948
L2947:
%t9741 = call i64 @__mruntime_rt_map_resid__word_keep(i64 4, i64 %t9722)
br label %L2949
L2948:
br label %L2949
L2949:
%t9742 = phi i64 [ %t9741, %L2947 ], [ %t9722, %L2948 ]
%t9743 = call i64 @__mruntime_rt_map_resid__t_insert_new(i64 %p0, i64 %t9742, i64 %t9734)
ret i64 %t9743
}
define internal i64 @__mruntime_rt_map_resid__t_put(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9744 = call i64 @__mruntime_rt_map_resid__t_put_s(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 0, i64 0)
ret i64 %t9744
}
define internal i1 @__mruntime_rt_map_resid__t_del(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9745 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9746 = icmp eq i64 %t9745, 0
br label %LSL9747
LSL9747:
br i1 %t9746, label %LSJ9747, label %LSR9747
LSR9747:
%t9748 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9749 = icmp eq i64 %t9748, 0
br label %LSJ9747
LSJ9747:
%t9750 = phi i1 [ true, %LSL9747 ], [ %t9749, %LSR9747 ]
br i1 %t9750, label %L2950, label %L2952
L2950:
ret i1 false
L2952:
%t9751 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9752 = icmp eq i64 %t9751, %p1
br label %LSL9753
LSL9753:
br i1 %t9752, label %LSJ9753, label %LSR9753
LSR9753:
%t9754 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9755 = icmp eq i64 %t9754, 0
br label %LSJ9753
LSJ9753:
%t9756 = phi i1 [ true, %LSL9753 ], [ %t9755, %LSR9753 ]
br label %LSL9757
LSL9757:
br i1 %t9756, label %LSJ9757, label %LSR9757
LSR9757:
%t9758 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9759 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %t9758, i64 %p2)
br label %LSJ9757
LSJ9757:
%t9760 = phi i1 [ true, %LSL9757 ], [ %t9759, %LSR9757 ]
%t9761 = xor i1 %t9760, true
br i1 %t9761, label %L2953, label %L2955
L2953:
ret i1 false
L2955:
br i1 %t9752, label %L2956, label %L2957
L2956:
br label %L2958
L2957:
%t9762 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9763 = icmp eq i64 %t9762, 0
br i1 %t9763, label %L2959, label %L2960
L2959:
%t9764 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
br label %L2961
L2960:
%t9765 = call i64 @__mruntime_rt_map_resid__mret()
%t9766 = call i64 @ld64(i64 %t9765)
br label %L2961
L2961:
%t9767 = phi i64 [ %t9764, %L2959 ], [ %t9766, %L2960 ]
br label %L2958
L2958:
%t9768 = phi i64 [ %p2, %L2956 ], [ %t9767, %L2961 ]
%t9769 = add i64 %p0, 72
%t9770 = call i64 @st8(i64 %t9769, i64 0)
%t9771 = call i64 @__mruntime_rt_map_resid__t_oob(i64 %p0, i64 %t9768)
%t9772 = icmp sge i64 %t9771, 0
br i1 %t9772, label %L2962, label %L2964
L2962:
%t9773 = call i1 @__mruntime_rt_map_resid__toob_has(i64 %p0, i64 %t9771)
%t9774 = xor i1 %t9773, true
br i1 %t9774, label %L2965, label %L2967
L2965:
ret i1 false
L2967:
%t9775 = add i64 %p0, 48
%t9776 = add i64 %t9775, %t9771
%t9777 = call i64 @st8(i64 %t9776, i64 0)
%t9778 = add i64 %p0, 8
%t9779 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9780 = sub i64 %t9779, 1
%t9781 = call i64 @st64(i64 %t9778, i64 %t9780)
%t9782 = icmp eq i64 %t9781, 0
ret i1 %t9782
L2964:
%t9783 = call i64 @__mruntime_rt_map_resid__t_probe(i64 %p0, i64 %t9768)
%t9784 = icmp slt i64 %t9783, 0
br i1 %t9784, label %L2968, label %L2970
L2968:
ret i1 false
L2970:
%t9785 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t9786 = mul i64 %t9783, 8
%t9787 = add i64 %t9785, %t9786
%t9788 = call i64 @__mruntime_rt_map_resid__t_tomb(i64 %p0)
%t9789 = call i64 @st64(i64 %t9787, i64 %t9788)
%t9790 = add i64 %p0, 8
%t9791 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9792 = sub i64 %t9791, 1
%t9793 = call i64 @st64(i64 %t9790, i64 %t9792)
%t9794 = add i64 %p0, 16
%t9795 = call i64 @__mruntime_rt_map_resid__ttombs(i64 %p0)
%t9796 = add i64 %t9795, 1
%t9797 = call i64 @st64(i64 %t9794, i64 %t9796)
%t9798 = icmp eq i64 %t9797, 0
ret i1 %t9798
}
define internal i64 @__mruntime_rt_map_resid__map_kk(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9799 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9800 = icmp ne i64 %t9799, 0
br i1 %t9800, label %L2971, label %L2972
L2971:
%t9801 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9802 = call i64 @__mruntime_rt_map_resid__tkk(i64 %t9801)
br label %L2973
L2972:
%t9803 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
br label %L2973
L2973:
%t9804 = phi i64 [ %t9802, %L2971 ], [ %t9803, %L2972 ]
ret i64 %t9804
}
define internal i64 @__mruntime_rt_map_resid__map_vk(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9805 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9806 = icmp ne i64 %t9805, 0
br i1 %t9806, label %L2974, label %L2975
L2974:
%t9807 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9808 = call i64 @__mruntime_rt_map_resid__tvk(i64 %t9807)
br label %L2976
L2975:
%t9809 = call i64 @__mruntime_rt_map_resid__mvk(i64 %p0)
br label %L2976
L2976:
%t9810 = phi i64 [ %t9808, %L2974 ], [ %t9809, %L2975 ]
ret i64 %t9810
}
define internal i64 @__mruntime_rt_map_resid__trie_build(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9811 = call i64 @__mruntime_rt_map_resid__new_edit()
%t9812 = call i64 @__mruntime_rt_map_resid__build_at(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %t9811, i64 0, i64 0)
ret i64 %t9812
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
%p5 = phi i64 [ %p5.in, %entry ], [ %t9824, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %t9823, %tco.s0 ]
%t9813 = icmp sge i64 %p5, %p2
br i1 %t9813, label %L2977, label %L2979
L2977:
ret i64 %p6
L2979:
%t9814 = mul i64 %p5, 8
%t9815 = add i64 %p0, %t9814
%t9816 = call i64 @ld64(i64 %t9815)
%t9817 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %p3, i64 %t9816)
%t9818 = icmp ne i64 %p1, 0
br i1 %t9818, label %L2980, label %L2981
L2980:
%t9819 = mul i64 %p5, 8
%t9820 = add i64 %p1, %t9819
%t9821 = call i64 @ld64(i64 %t9820)
br label %L2982
L2981:
br label %L2982
L2982:
%t9822 = phi i64 [ %t9821, %L2980 ], [ 1, %L2981 ]
%t9823 = call i64 @__mruntime_rt_map_resid__hn_insert(i64 %p6, i64 0, i64 %t9817, i64 %p3, i64 %t9816, i64 %t9822, i64 %p4)
%t9824 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__t_entries(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9826 = call i64 @__mruntime_rt_map_resid__tlive(i64 %p0)
%t9827 = icmp eq i64 %t9826, 0
br i1 %t9827, label %L2983, label %L2985
L2983:
ret i64 0
L2985:
%t9828 = mul i64 %t9826, 24
%t9829 = call i64 @xmalloc(i64 %t9828)
%t9830 = call i64 @__mruntime_rt_map_resid__ents_fill(i64 %p0, i64 %t9829, i64 0, i64 0)
%t9831 = mul i64 %t9826, 24
%t9832 = call i64 @xmalloc(i64 %t9831)
%t9833 = call i64 @__mruntime_rt_map_resid__ent_sort(i64 %t9829, i64 %t9832, i64 %t9826, i64 1)
%t9834 = call i64 @__mruntime_rt_map_resid__ents_out(i64 %t9833, i64 %p1, i64 %p2, i64 0, i64 %t9826)
%t9835 = call i64 @c_free(i64 %t9829)
%t9836 = call i64 @c_free(i64 %t9832)
%t9837 = add i64 %t9835, %t9836
ret i64 %t9837
}
define internal i64 @__mruntime_rt_map_resid__ents_fill(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9838, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9856, %tco.s0 ]
%t9838 = call i64 @__mruntime_rt_map_resid__t_next(i64 %p0, i64 %p2)
%t9839 = icmp slt i64 %t9838, 0
br i1 %t9839, label %L2986, label %L2988
L2986:
ret i64 %p3
L2988:
%t9840 = call i64 @__mruntime_rt_map_resid__mret()
%t9841 = call i64 @ld64(i64 %t9840)
%t9842 = mul i64 %p3, 24
%t9843 = add i64 %p1, %t9842
%t9844 = call i64 @__mruntime_rt_map_resid__tkk(i64 %p0)
%t9845 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %t9844, i64 %t9841)
%t9846 = call i64 @__mruntime_rt_map_resid__canon_rank(i64 %t9845)
%t9847 = call i64 @st64(i64 %t9843, i64 %t9846)
%t9848 = add i64 %t9843, 8
%t9849 = call i64 @st64(i64 %t9848, i64 %t9841)
%t9850 = add i64 %t9847, %t9849
%t9851 = add i64 %t9843, 16
%t9852 = call i64 @__mruntime_rt_map_resid__mflag()
%t9853 = call i64 @ld64(i64 %t9852)
%t9854 = call i64 @st64(i64 %t9851, i64 %t9853)
%t9855 = add i64 %t9850, %t9854
%t9856 = add i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__ent_merge(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9858 = icmp slt i64 %p2, %p3
br label %LSL9859
LSL9859:
br i1 %t9858, label %LSR9859, label %LSJ9859
LSR9859:
%t9860 = icmp slt i64 %p4, %p5
br label %LSJ9859
LSJ9859:
%t9861 = phi i1 [ false, %LSL9859 ], [ %t9860, %LSR9859 ]
br i1 %t9861, label %L2989, label %L2991
L2989:
%t9862 = mul i64 %p4, 24
%t9863 = add i64 %p0, %t9862
%t9864 = call i64 @ld64(i64 %t9863)
%t9865 = mul i64 %p2, 24
%t9866 = add i64 %p0, %t9865
%t9867 = call i64 @ld64(i64 %t9866)
%t9868 = call i1 @ult(i64 %t9864, i64 %t9867)
%t9869 = xor i1 %t9868, true
br i1 %t9869, label %L2992, label %L2993
L2992:
br label %L2994
L2993:
br label %L2994
L2994:
%t9870 = phi i64 [ %p2, %L2992 ], [ %p4, %L2993 ]
%t9871 = mul i64 %p6, 24
%t9872 = add i64 %p1, %t9871
%t9873 = mul i64 %t9870, 24
%t9874 = add i64 %p0, %t9873
%t9875 = call i64 @mcopy(i64 %t9872, i64 %t9874, i64 24)
br i1 %t9869, label %L2995, label %L2996
L2995:
%t9876 = add nsw i64 %p2, 1
%t9877 = add i64 %p6, 1
%t9878 = call i64 @__mruntime_rt_map_resid__ent_merge(i64 %p0, i64 %p1, i64 %t9876, i64 %p3, i64 %p4, i64 %p5, i64 %t9877)
br label %L2997
L2996:
%t9879 = add nsw i64 %p4, 1
%t9880 = add i64 %p6, 1
%t9881 = call i64 @__mruntime_rt_map_resid__ent_merge(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %t9879, i64 %p5, i64 %t9880)
br label %L2997
L2997:
%t9882 = phi i64 [ %t9878, %L2995 ], [ %t9881, %L2996 ]
ret i64 %t9882
L2991:
%t9883 = icmp slt i64 %p2, %p3
br i1 %t9883, label %L2998, label %L2999
L2998:
%t9884 = mul i64 %p6, 24
%t9885 = add i64 %p1, %t9884
%t9886 = mul i64 %p2, 24
%t9887 = add i64 %p0, %t9886
%t9888 = sub i64 %p3, %p2
%t9889 = mul i64 %t9888, 24
%t9890 = call i64 @mcopy(i64 %t9885, i64 %t9887, i64 %t9889)
br label %L3000
L2999:
br label %L3000
L3000:
%t9891 = phi i64 [ %t9890, %L2998 ], [ 0, %L2999 ]
%t9892 = icmp slt i64 %p4, %p5
br i1 %t9892, label %L3001, label %L3002
L3001:
%t9893 = add i64 %p6, %p3
%t9894 = sub i64 %t9893, %p2
%t9895 = mul i64 %t9894, 24
%t9896 = add i64 %p1, %t9895
%t9897 = mul i64 %p4, 24
%t9898 = add i64 %p0, %t9897
%t9899 = sub i64 %p5, %p4
%t9900 = mul i64 %t9899, 24
%t9901 = call i64 @mcopy(i64 %t9896, i64 %t9898, i64 %t9900)
br label %L3003
L3002:
br label %L3003
L3003:
%t9902 = phi i64 [ %t9901, %L3001 ], [ 0, %L3002 ]
ret i64 %t9902
}
define internal i64 @__mruntime_rt_map_resid__ent_pass(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t9916, %tco.s0 ]
%t9903 = icmp sge i64 %p4, %p2
br i1 %t9903, label %L3004, label %L3006
L3004:
ret i64 0
L3006:
%t9904 = add i64 %p4, %p3
%t9905 = icmp slt i64 %t9904, %p2
br i1 %t9905, label %L3007, label %L3008
L3007:
br label %L3009
L3008:
br label %L3009
L3009:
%t9906 = phi i64 [ %t9904, %L3007 ], [ %p2, %L3008 ]
%t9907 = add i64 %p4, %p3
%t9908 = icmp slt i64 %t9907, %p2
br i1 %t9908, label %L3010, label %L3011
L3010:
br label %L3012
L3011:
br label %L3012
L3012:
%t9909 = phi i64 [ %t9907, %L3010 ], [ %p2, %L3011 ]
%t9910 = mul i64 2, %p3
%t9911 = add i64 %p4, %t9910
%t9912 = icmp slt i64 %t9911, %p2
br i1 %t9912, label %L3013, label %L3014
L3013:
br label %L3015
L3014:
br label %L3015
L3015:
%t9913 = phi i64 [ %t9911, %L3013 ], [ %p2, %L3014 ]
%t9914 = call i64 @__mruntime_rt_map_resid__ent_merge(i64 %p0, i64 %p1, i64 %p4, i64 %t9906, i64 %t9909, i64 %t9913, i64 %p4)
%t9915 = mul i64 2, %p3
%t9916 = add i64 %p4, %t9915
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t9920, %tco.s0 ]
%t9918 = icmp sge i64 %p3, %p2
br i1 %t9918, label %L3016, label %L3018
L3016:
ret i64 %p0
L3018:
%t9919 = call i64 @__mruntime_rt_map_resid__ent_pass(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0)
%t9920 = mul i64 %p3, 2
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t9941, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t9922 = icmp sge i64 %p3, %p4
br i1 %t9922, label %L3019, label %L3021
L3019:
ret i64 0
L3021:
%t9923 = icmp ne i64 %p1, 0
br i1 %t9923, label %L3022, label %L3023
L3022:
%t9924 = mul i64 %p3, 8
%t9925 = add i64 %p1, %t9924
%t9926 = mul i64 %p3, 24
%t9927 = add i64 %p0, %t9926
%t9928 = add i64 %t9927, 8
%t9929 = call i64 @ld64(i64 %t9928)
%t9930 = call i64 @st64(i64 %t9925, i64 %t9929)
br label %L3024
L3023:
br label %L3024
L3024:
%t9931 = phi i64 [ %t9930, %L3022 ], [ 0, %L3023 ]
%t9932 = icmp ne i64 %p2, 0
br i1 %t9932, label %L3025, label %L3026
L3025:
%t9933 = mul i64 %p3, 8
%t9934 = add i64 %p2, %t9933
%t9935 = mul i64 %p3, 24
%t9936 = add i64 %p0, %t9935
%t9937 = add i64 %t9936, 16
%t9938 = call i64 @ld64(i64 %t9937)
%t9939 = call i64 @st64(i64 %t9934, i64 %t9938)
br label %L3027
L3026:
br label %L3027
L3027:
%t9940 = phi i64 [ %t9939, %L3025 ], [ 0, %L3026 ]
%t9941 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__map_entries(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9943 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9944 = icmp ne i64 %t9943, 0
br i1 %t9944, label %L3028, label %L3030
L3028:
%t9945 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9946 = tail call i64 @__mruntime_rt_map_resid__t_entries(i64 %t9945, i64 %p1, i64 %p2)
ret i64 %t9946
L3030:
%t9947 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t9948 = call i64 @__mruntime_rt_map_resid__hn_collect(i64 %t9947, i64 %p1, i64 %p2, i64 0)
ret i64 %t9948
}
define internal i64 @__mruntime_rt_map_resid__words_of(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9949 = icmp sgt i64 %p0, 1
br i1 %t9949, label %L3031, label %L3032
L3031:
br label %L3033
L3032:
br label %L3033
L3033:
%t9950 = phi i64 [ %p0, %L3031 ], [ 1, %L3032 ]
%t9951 = mul i64 %t9950, 8
%t9952 = tail call i64 @xmalloc(i64 %t9951)
ret i64 %t9952
}
define internal i64 @__mruntime_rt_map_resid__map_root(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9953 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9954 = icmp eq i64 %t9953, 0
br i1 %t9954, label %L3034, label %L3036
L3034:
%t9955 = tail call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
ret i64 %t9955
L3036:
%t9956 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
%t9957 = xor i1 %t9956, true
br i1 %t9957, label %L3037, label %L3039
L3037:
%t9958 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t9959 = icmp ne i64 %t9958, 0
br label %LSL9960
LSL9960:
br i1 %t9959, label %LSJ9960, label %LSR9960
LSR9960:
%t9961 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t9962 = icmp eq i64 %t9961, 0
br label %LSJ9960
LSJ9960:
%t9963 = phi i1 [ true, %LSL9960 ], [ %t9962, %LSR9960 ]
br i1 %t9963, label %L3040, label %L3042
L3040:
ret i64 %t9958
L3042:
br label %L3039
L3039:
%t9964 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t9965 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t9964)
%t9966 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
%t9967 = xor i1 %t9966, true
%t9968 = call i64 @xmalloc(i64 24)
br i1 %t9967, label %L3043, label %L3044
L3043:
%t9969 = call i64 @c_suspend(i64 %t9968)
br label %L3045
L3044:
br label %L3045
L3045:
%t9970 = phi i64 [ %t9969, %L3043 ], [ 0, %L3044 ]
%t9971 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t9965)
%t9972 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t9965)
%t9973 = call i64 @__mruntime_rt_map_resid__table_words(i64 %t9964, i64 %t9971, i64 %t9972, i64 0, i64 0)
%t9974 = call i64 @__mruntime_rt_map_resid__tkk(i64 %t9964)
%t9975 = call i64 @__mruntime_rt_map_resid__trie_build(i64 %t9971, i64 %t9972, i64 %t9965, i64 %t9974)
%t9976 = call i64 @c_free(i64 %t9971)
%t9977 = call i64 @c_free(i64 %t9972)
%t9978 = add i64 %t9976, %t9977
br i1 %t9967, label %L3046, label %L3047
L3046:
%t9979 = call i64 @c_resume(i64 %t9968)
br label %L3048
L3047:
br label %L3048
L3048:
%t9980 = phi i64 [ %t9979, %L3046 ], [ 0, %L3047 ]
%t9981 = call i64 @c_free(i64 %t9968)
%t9982 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
br i1 %t9982, label %L3049, label %L3051
L3049:
ret i64 %t9975
L3051:
%t9983 = add i64 %p0, 8
%t9984p = inttoptr i64 %t9983 to ptr
%t9984x = cmpxchg ptr %t9984p, i64 0, i64 %t9975 seq_cst seq_cst
%t9984 = extractvalue {i64, i1} %t9984x, 1
br i1 %t9984, label %L3052, label %L3054
L3052:
ret i64 %t9975
L3054:
%t9985 = tail call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
ret i64 %t9985
}
define internal i64 @__mruntime_rt_map_resid__table_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9986, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t9998, %tco.s0 ]
%t9986 = call i64 @__mruntime_rt_map_resid__t_next(i64 %p0, i64 %p3)
%t9987 = icmp slt i64 %t9986, 0
br i1 %t9987, label %L3055, label %L3057
L3055:
ret i64 %p4
L3057:
%t9988 = mul i64 %p4, 8
%t9989 = add i64 %p1, %t9988
%t9990 = call i64 @__mruntime_rt_map_resid__mret()
%t9991 = call i64 @ld64(i64 %t9990)
%t9992 = call i64 @st64(i64 %t9989, i64 %t9991)
%t9993 = mul i64 %p4, 8
%t9994 = add i64 %p2, %t9993
%t9995 = call i64 @__mruntime_rt_map_resid__mflag()
%t9996 = call i64 @ld64(i64 %t9995)
%t9997 = call i64 @st64(i64 %t9994, i64 %t9996)
%t9998 = add i64 %p4, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__map_exit(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10000 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
br label %LSL10001
LSL10001:
br i1 %t10000, label %LSR10001, label %LSJ10001
LSR10001:
%t10002 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10003 = icmp sle i64 %t10002, 0
br label %LSJ10001
LSJ10001:
%t10004 = phi i1 [ false, %LSL10001 ], [ %t10003, %LSR10001 ]
br i1 %t10004, label %L3058, label %L3060
L3058:
%t10005 = add i64 %p0, 40
%t10006 = call i64 @__mruntime_rt_map_resid__new_own()
%t10007 = call i64 @st32(i64 %t10005, i64 %t10006)
ret i64 %t10007
L3060:
ret i64 0
}
define internal i64 @__mruntime_rt_map_resid__base_w() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10008p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_base)
%t10008 = ptrtoint ptr %t10008p to i64
ret i64 %t10008
}
define internal i64 @__mruntime_rt_map_resid__base_set(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10009 = call i64 @__mruntime_rt_map_resid__base_w()
%t10010 = call i64 @st64(i64 %t10009, i64 %p0)
%t10011 = call i64 @__mruntime_rt_map_resid__base_w()
%t10012 = add i64 %t10011, 8
%t10013 = call i64 @st64(i64 %t10012, i64 %p1)
%t10014 = add i64 %t10010, %t10013
%t10015 = call i64 @__mruntime_rt_map_resid__base_w()
%t10016 = add i64 %t10015, 16
%t10017 = call i64 @st64(i64 %t10016, i64 %p2)
%t10018 = add i64 %t10014, %t10017
ret i64 %t10018
}
define internal i64 @__mruntime_rt_map_resid__b_root() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10019 = call i64 @__mruntime_rt_map_resid__base_w()
%t10020 = call i64 @ld64(i64 %t10019)
ret i64 %t10020
}
define internal i64 @__mruntime_rt_map_resid__b_kk() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10021 = call i64 @__mruntime_rt_map_resid__base_w()
%t10022 = add i64 %t10021, 8
%t10023 = call i64 @ld64(i64 %t10022)
ret i64 %t10023
}
define internal i64 @__mruntime_rt_map_resid__b_vk() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10024 = call i64 @__mruntime_rt_map_resid__base_w()
%t10025 = add i64 %t10024, 16
%t10026 = call i64 @ld64(i64 %t10025)
ret i64 %t10026
}
define internal i64 @__mruntime_rt_map_resid__map_base(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10027 = call i64 @__mruntime_rt_map_resid__map_exit(i64 %p0)
%t10028 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10029 = icmp ne i64 %t10028, 0
br label %LSL10030
LSL10030:
br i1 %t10029, label %LSJ10030, label %LSR10030
LSR10030:
%t10031 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
%t10032 = xor i1 %t10031, true
br label %LSJ10030
LSJ10030:
%t10033 = phi i1 [ true, %LSL10030 ], [ %t10032, %LSR10030 ]
br i1 %t10033, label %L3061, label %L3063
L3061:
%t10034 = call i64 @__mruntime_rt_map_resid__map_root(i64 %p0)
%t10035 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t10036 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10037 = call i64 @__mruntime_rt_map_resid__base_set(i64 %t10034, i64 %t10035, i64 %t10036)
ret i64 %t10037
L3063:
%t10038 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10039 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t10038)
%t10040 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t10038)
%t10041 = call i64 @__mruntime_rt_map_resid__map_entries(i64 %p0, i64 %t10039, i64 %t10040)
%t10042 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t10043 = call i64 @__mruntime_rt_map_resid__trie_build(i64 %t10039, i64 %t10040, i64 %t10038, i64 %t10042)
%t10044 = call i64 @c_free(i64 %t10039)
%t10045 = call i64 @c_free(i64 %t10040)
%t10046 = add i64 %t10044, %t10045
%t10047 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t10048 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10049 = call i64 @__mruntime_rt_map_resid__base_set(i64 %t10043, i64 %t10047, i64 %t10048)
ret i64 %t10049
}
define internal i64 @__mruntime_rt_map_resid__base_boxed(i64 %p0, i1 %p1, i1 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10050 = call i64 @__mruntime_rt_map_resid__words_of(i64 %p0)
%t10051 = call i64 @__mruntime_rt_map_resid__words_of(i64 %p0)
%t10052 = call i64 @__mruntime_rt_map_resid__b_root()
%t10053 = call i64 @__mruntime_rt_map_resid__hn_collect(i64 %t10052, i64 %t10050, i64 %t10051, i64 0)
br i1 %p1, label %L3064, label %L3065
L3064:
br label %L3066
L3065:
%t10054 = call i64 @__mruntime_rt_map_resid__b_kk()
br label %L3066
L3066:
%t10055 = phi i64 [ 0, %L3064 ], [ %t10054, %L3065 ]
br i1 %p2, label %L3067, label %L3068
L3067:
br label %L3069
L3068:
%t10056 = call i64 @__mruntime_rt_map_resid__b_vk()
br label %L3069
L3069:
%t10057 = phi i64 [ 0, %L3067 ], [ %t10056, %L3068 ]
%t10058 = call i64 @__mruntime_rt_map_resid__b_kk()
%t10059 = call i64 @__mruntime_rt_map_resid__b_vk()
%t10060 = call i64 @__mruntime_rt_map_resid__box_words(i64 %t10050, i64 %t10051, i64 0, i64 %p0, i1 %p1, i1 %p2, i64 %t10058, i64 %t10059)
%t10061 = call i64 @__mruntime_rt_map_resid__trie_build(i64 %t10050, i64 %t10051, i64 %p0, i64 %t10055)
%t10062 = call i64 @c_free(i64 %t10050)
%t10063 = call i64 @c_free(i64 %t10051)
%t10064 = add i64 %t10062, %t10063
%t10065 = call i64 @__mruntime_rt_map_resid__base_set(i64 %t10061, i64 %t10055, i64 %t10057)
ret i64 %t10065
}
define internal i64 @__mruntime_rt_map_resid__box_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i1 %p4.in, i1 %p5.in, i64 %p6.in, i64 %p7.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t10083, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i1 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i1 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p7, %tco.s0 ]
%t10066 = icmp sge i64 %p2, %p3
br i1 %t10066, label %L3070, label %L3072
L3070:
ret i64 0
L3072:
br i1 %p4, label %L3073, label %L3074
L3073:
%t10067 = mul i64 %p2, 8
%t10068 = add i64 %p0, %t10067
%t10069 = mul i64 %p2, 8
%t10070 = add i64 %p0, %t10069
%t10071 = call i64 @ld64(i64 %t10070)
%t10072 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p6, i64 %t10071)
%t10073 = call i64 @st64(i64 %t10068, i64 %t10072)
br label %L3075
L3074:
br label %L3075
L3075:
%t10074 = phi i64 [ %t10073, %L3073 ], [ 0, %L3074 ]
br i1 %p5, label %L3076, label %L3077
L3076:
%t10075 = mul i64 %p2, 8
%t10076 = add i64 %p1, %t10075
%t10077 = mul i64 %p2, 8
%t10078 = add i64 %p1, %t10077
%t10079 = call i64 @ld64(i64 %t10078)
%t10080 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p7, i64 %t10079)
%t10081 = call i64 @st64(i64 %t10076, i64 %t10080)
br label %L3078
L3077:
br label %L3078
L3078:
%t10082 = phi i64 [ %t10081, %L3076 ], [ 0, %L3077 ]
%t10083 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_map_resid__word_in(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10085 = icmp eq i64 %p0, %p1
br i1 %t10085, label %L3079, label %L3081
L3079:
%t10086 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %p2)
%t10087 = icmp ne i64 %t10086, 0
ret i1 %t10087
L3081:
%t10088 = icmp eq i64 %p0, 0
br i1 %t10088, label %L3082, label %L3084
L3082:
%t10089 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
%t10090 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t10089)
%t10091 = icmp ne i64 %t10090, 0
ret i1 %t10091
L3084:
%t10092 = icmp eq i64 %p1, 0
br i1 %t10092, label %L3085, label %L3087
L3085:
%t10093 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %p0, i64 %p2)
ret i1 %t10093
L3087:
ret i1 false
}
define internal i64 @__mruntime_rt_map_resid__map_insert_p(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10094 = call i64 @__mruntime_rt_map_resid__map_base(i64 %p0)
%t10095 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10096 = icmp eq i64 %t10095, 0
br i1 %t10096, label %L3088, label %L3089
L3088:
%t10097 = call i64 @__mruntime_rt_map_resid__base_set(i64 0, i64 %p1, i64 %p3)
br label %L3090
L3089:
br label %L3090
L3090:
%t10098 = phi i64 [ %t10097, %L3088 ], [ 0, %L3089 ]
%t10099 = call i64 @__mruntime_rt_map_resid__b_kk()
%t10100 = sub nsw i64 0, 1
%t10101 = icmp eq i64 %t10099, %t10100
br i1 %t10101, label %L3091, label %L3092
L3091:
%t10102 = call i64 @__mruntime_rt_map_resid__base_w()
%t10103 = add i64 %t10102, 8
%t10104 = call i64 @st64(i64 %t10103, i64 %p1)
br label %L3093
L3092:
br label %L3093
L3093:
%t10105 = phi i64 [ %t10104, %L3091 ], [ 0, %L3092 ]
%t10106 = call i64 @__mruntime_rt_map_resid__b_vk()
%t10107 = sub nsw i64 0, 1
%t10108 = icmp eq i64 %t10106, %t10107
br i1 %t10108, label %L3094, label %L3095
L3094:
%t10109 = call i64 @__mruntime_rt_map_resid__base_w()
%t10110 = add i64 %t10109, 16
%t10111 = call i64 @st64(i64 %t10110, i64 %p3)
br label %L3096
L3095:
br label %L3096
L3096:
%t10112 = phi i64 [ %t10111, %L3094 ], [ 0, %L3095 ]
%t10113 = call i64 @__mruntime_rt_map_resid__b_kk()
%t10114 = call i1 @__mruntime_rt_map_resid__word_in(i64 %t10113, i64 %p1, i64 %p2)
br i1 %t10114, label %L3097, label %L3098
L3097:
%t10115 = call i64 @__mruntime_rt_map_resid__mret()
%t10116 = call i64 @ld64(i64 %t10115)
br label %L3099
L3098:
%t10117 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10118 = call i64 @__mruntime_rt_map_resid__base_boxed(i64 %t10117, i1 true, i1 false)
%t10119 = mul nsw i64 %t10118, 0
%t10120 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
%t10121 = add nsw i64 %t10119, %t10120
br label %L3099
L3099:
%t10122 = phi i64 [ %t10116, %L3097 ], [ %t10121, %L3098 ]
%t10123 = call i64 @__mruntime_rt_map_resid__b_vk()
%t10124 = call i1 @__mruntime_rt_map_resid__word_in(i64 %t10123, i64 %p3, i64 %p4)
br i1 %t10124, label %L3100, label %L3101
L3100:
%t10125 = call i64 @__mruntime_rt_map_resid__mret()
%t10126 = call i64 @ld64(i64 %t10125)
br label %L3102
L3101:
%t10127 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10128 = call i64 @__mruntime_rt_map_resid__base_boxed(i64 %t10127, i1 false, i1 true)
%t10129 = mul nsw i64 %t10128, 0
%t10130 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p3, i64 %p4)
%t10131 = add nsw i64 %t10129, %t10130
br label %L3102
L3102:
%t10132 = phi i64 [ %t10126, %L3100 ], [ %t10131, %L3101 ]
%t10133 = call i64 @__mruntime_rt_map_resid__b_kk()
%t10134 = call i64 @__mruntime_rt_map_resid__b_vk()
%t10135 = call i64 @__mruntime_rt_map_resid__b_root()
%t10136 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %t10133, i64 %t10122)
%t10137 = call i64 @__mruntime_rt_map_resid__hn_insert(i64 %t10135, i64 0, i64 %t10136, i64 %t10133, i64 %t10122, i64 %t10132, i64 0)
%t10138 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10139 = call i64 @__mruntime_rt_map_resid__mflag()
%t10140 = call i64 @ld64(i64 %t10139)
%t10141 = add i64 %t10138, %t10140
%t10142 = call i64 @__mruntime_rt_map_resid__trie_new(i64 %t10141, i64 %t10137, i64 %t10133, i64 %t10134)
ret i64 %t10142
}
define internal i1 @__mruntime_rt_map_resid__key_lookup_word(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10143 = icmp eq i64 %p0, %p1
br i1 %t10143, label %L3103, label %L3105
L3103:
%t10144 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %p2)
%t10145 = icmp ne i64 %t10144, 0
ret i1 %t10145
L3105:
%t10146 = icmp eq i64 %p0, 0
br i1 %t10146, label %L3106, label %L3108
L3106:
%t10147 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
%t10148 = call i64 @__mruntime_rt_map_resid__ret_word(i64 %t10147)
%t10149 = icmp ne i64 %t10148, 0
ret i1 %t10149
L3108:
%t10150 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %p0, i64 %p2)
ret i1 %t10150
}
define internal i64 @__mruntime_rt_map_resid__map_remove_p(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10151 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10152 = icmp eq i64 %t10151, 0
br label %LSL10153
LSL10153:
br i1 %t10152, label %LSJ10153, label %LSR10153
LSR10153:
%t10154 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t10155 = call i1 @__mruntime_rt_map_resid__key_lookup_word(i64 %t10154, i64 %p1, i64 %p2)
%t10156 = xor i1 %t10155, true
br label %LSJ10153
LSJ10153:
%t10157 = phi i1 [ true, %LSL10153 ], [ %t10156, %LSR10153 ]
br i1 %t10157, label %L3109, label %L3111
L3109:
%t10158 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
%t10159 = xor i1 %t10158, true
br i1 %t10159, label %L3112, label %L3114
L3112:
ret i64 %p0
L3114:
%t10160 = call i64 @__mruntime_rt_map_resid__map_base(i64 %p0)
%t10161 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10162 = call i64 @__mruntime_rt_map_resid__b_root()
%t10163 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t10164 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10165 = call i64 @__mruntime_rt_map_resid__trie_new(i64 %t10161, i64 %t10162, i64 %t10163, i64 %t10164)
ret i64 %t10165
L3111:
%t10166 = call i64 @__mruntime_rt_map_resid__mret()
%t10167 = call i64 @ld64(i64 %t10166)
%t10168 = call i64 @__mruntime_rt_map_resid__map_base(i64 %p0)
%t10169 = call i64 @__mruntime_rt_map_resid__b_kk()
%t10170 = call i64 @__mruntime_rt_map_resid__b_vk()
%t10171 = call i64 @__mruntime_rt_map_resid__b_root()
%t10172 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %t10169, i64 %t10167)
%t10173 = call i64 @__mruntime_rt_map_resid__hn_remove(i64 %t10171, i64 0, i64 %t10172, i64 %t10169, i64 %t10167, i64 0)
%t10174 = call i64 @__mruntime_rt_map_resid__mflag()
%t10175 = call i64 @ld64(i64 %t10174)
%t10176 = icmp eq i64 %t10175, 0
br i1 %t10176, label %L3115, label %L3117
L3115:
%t10177 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
br i1 %t10177, label %L3118, label %L3119
L3118:
%t10178 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10179 = call i64 @__mruntime_rt_map_resid__trie_new(i64 %t10178, i64 %t10171, i64 %t10169, i64 %t10170)
br label %L3120
L3119:
br label %L3120
L3120:
%t10180 = phi i64 [ %t10179, %L3118 ], [ %p0, %L3119 ]
ret i64 %t10180
L3117:
%t10181 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10182 = sub i64 %t10181, 1
%t10183 = call i64 @__mruntime_rt_map_resid__trie_new(i64 %t10182, i64 %t10173, i64 %t10169, i64 %t10170)
ret i64 %t10183
}
define internal i64 @__mruntime_rt_map_resid__own_w() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10184p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_own)
%t10184 = ptrtoint ptr %t10184p to i64
ret i64 %t10184
}
define internal i64 @__mruntime_rt_map_resid__new_own() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10185 = call i64 @__mruntime_rt_map_resid__own_w()
%t10186 = call i64 @ld64(i64 %t10185)
%t10187 = add i64 %t10185, 8
%t10188 = call i64 @ld64(i64 %t10187)
%t10189 = icmp eq i64 %t10186, %t10188
br i1 %t10189, label %L3121, label %L3122
L3121:
%t10190 = call i64 @__mruntime_rt_map_resid__own_block(i64 %t10185)
br label %L3123
L3122:
br label %L3123
L3123:
%t10191 = phi i64 [ %t10190, %L3121 ], [ 0, %L3122 ]
%t10192 = call i64 @ld64(i64 %t10185)
%t10193 = icmp sgt i64 %t10192, 4294967295
br i1 %t10193, label %L3124, label %L3126
L3124:
ret i64 0
L3126:
%t10194 = add nsw i64 %t10192, 1
%t10195 = call i64 @st64(i64 %t10185, i64 %t10194)
%t10196 = mul nsw i64 %t10195, 0
%t10197 = add nsw i64 %t10196, %t10192
ret i64 %t10197
}
define internal i64 @__mruntime_rt_map_resid__own_block(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10198p = getelementptr i8, ptr @rtg.map_own_seq, i64 0
%t10198 = ptrtoint ptr %t10198p to i64
%t10199p = inttoptr i64 %t10198 to ptr
%t10199 = atomicrmw add ptr %t10199p, i64 65536 seq_cst
%t10200 = add i64 %t10199, 1
%t10201 = call i64 @st64(i64 %p0, i64 %t10200)
%t10202 = add i64 %p0, 8
%t10203 = add i64 %t10200, 65535
%t10204 = call i64 @st64(i64 %t10202, i64 %t10203)
ret i64 %t10204
}
define internal i64 @__mruntime_rt_map_resid__map_vref(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10205 = call i64 @__mruntime_rt_map_resid__map_exit(i64 %p0)
%t10206 = tail call i64 @__mruntime_rt_map_resid__map_vref_raw(i64 %p0, i64 %p1, i64 %p2)
ret i64 %t10206
}
define internal i64 @__mruntime_rt_map_resid__map_vref_raw(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10207 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10208 = icmp eq i64 %t10207, 0
br i1 %t10208, label %L3127, label %L3129
L3127:
ret i64 0
L3129:
%t10209 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10210 = icmp ne i64 %t10209, 0
br i1 %t10210, label %L3130, label %L3132
L3130:
%t10211 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10212 = tail call i64 @__mruntime_rt_map_resid__t_vref(i64 %t10211, i64 %p1, i64 %p2)
ret i64 %t10212
L3132:
%t10213 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10214 = call i1 @__mruntime_rt_map_resid__key_lookup_word(i64 %t10213, i64 %p1, i64 %p2)
%t10215 = xor i1 %t10214, true
br i1 %t10215, label %L3133, label %L3135
L3133:
ret i64 0
L3135:
%t10216 = call i64 @__mruntime_rt_map_resid__mret()
%t10217 = call i64 @ld64(i64 %t10216)
%t10218 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t10219 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10220 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %t10219, i64 %t10217)
%t10221 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10222 = call i64 @__mruntime_rt_map_resid__hn_find(i64 %t10218, i64 %t10220, i64 %t10221, i64 %t10217, i64 0)
ret i64 %t10222
}
define internal i64 @rt_map_transient(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10223 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10224 = icmp sgt i64 %t10223, 64
br label %LSL10225
LSL10225:
br i1 %t10224, label %LSR10225, label %LSJ10225
LSR10225:
%t10226 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
%t10227 = xor i1 %t10226, true
br label %LSJ10225
LSJ10225:
%t10228 = phi i1 [ false, %LSL10225 ], [ %t10227, %LSR10225 ]
br i1 %t10228, label %L3136, label %L3138
L3136:
%t10229 = call i64 @__mruntime_rt_map_resid__map_root(i64 %p0)
%t10230 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t10231 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10232 = call i64 @__mruntime_rt_map_resid__trie_new(i64 %t10223, i64 %t10229, i64 %t10230, i64 %t10231)
%t10233 = add i64 %t10232, 24
%t10234 = call i64 @st64(i64 %t10233, i64 1)
%t10235 = add i64 %t10232, 32
%t10236 = call i64 @__mruntime_rt_map_resid__new_edit()
%t10237 = call i64 @st64(i64 %t10235, i64 %t10236)
%t10238 = add i64 %t10234, %t10237
%t10239 = add i64 %t10232, 40
%t10240 = call i64 @__mruntime_rt_map_resid__new_own()
%t10241 = call i64 @st32(i64 %t10239, i64 %t10240)
%t10242 = mul nsw i64 %t10241, 0
%t10243 = add nsw i64 %t10242, %t10232
ret i64 %t10243
L3138:
%t10244 = call i64 @__mruntime_rt_map_resid__map_exit(i64 %p0)
%t10245 = sub nsw i64 0, 1
%t10246 = sub nsw i64 0, 1
%t10247 = call i64 @__mruntime_rt_map_resid__trie_new(i64 %t10223, i64 0, i64 %t10245, i64 %t10246)
%t10248 = add i64 %t10247, 24
%t10249 = call i64 @st64(i64 %t10248, i64 1)
%t10250 = add i64 %t10247, 40
%t10251 = call i64 @__mruntime_rt_map_resid__new_own()
%t10252 = call i64 @st32(i64 %t10250, i64 %t10251)
%t10253 = add i64 %t10249, %t10252
%t10254 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10255 = icmp ne i64 %t10254, 0
br i1 %t10255, label %L3139, label %L3141
L3139:
%t10256 = add i64 %t10247, 16
%t10257 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10258 = call i64 @__mruntime_rt_map_resid__copy_tab(i64 %t10257)
%t10259 = call i64 @st64(i64 %t10256, i64 %t10258)
%t10260 = mul nsw i64 %t10259, 0
%t10261 = add nsw i64 %t10260, %t10247
ret i64 %t10261
L3141:
%t10262 = call i64 @__mruntime_rt_map_resid__cap_for(i64 %t10223)
%t10263 = sub nsw i64 0, 1
%t10264 = sub nsw i64 0, 1
%t10265 = call i64 @__mruntime_rt_map_resid__tab_new(i64 %t10262, i64 %t10263, i64 %t10264, i1 false)
%t10266 = add i64 %t10247, 16
%t10267 = call i64 @st64(i64 %t10266, i64 %t10265)
%t10268 = icmp eq i64 %t10223, 0
br i1 %t10268, label %L3142, label %L3144
L3142:
ret i64 %t10247
L3144:
%t10269 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t10223)
%t10270 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t10223)
%t10271 = call i64 @__mruntime_rt_map_resid__map_entries(i64 %p0, i64 %t10269, i64 %t10270)
%t10272 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10273 = call i64 @__mruntime_rt_map_resid__mvk(i64 %p0)
%t10274 = call i64 @__mruntime_rt_map_resid__put_all(i64 %t10265, i64 %t10272, i64 %t10273, i64 %t10269, i64 %t10270, i64 0, i64 %t10223)
%t10275 = call i64 @c_free(i64 %t10269)
%t10276 = call i64 @c_free(i64 %t10270)
%t10277 = add i64 %t10275, %t10276
ret i64 %t10247
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
%t10278 = call i64 @__mruntime_rt_map_resid__map_obj(i64 96)
%t10279 = call i64 @mcopy(i64 %t10278, i64 %p0, i64 96)
%t10280 = add i64 %t10278, 72
%t10281 = call i64 @st8(i64 %t10280, i64 0)
%t10282 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t10283 = icmp eq i64 %t10282, 0
br i1 %t10283, label %L3145, label %L3147
L3145:
ret i64 %t10278
L3147:
%t10284 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t10285 = mul i64 %t10284, 8
%t10286 = call i64 @__mruntime_rt_map_resid__map_obj(i64 %t10285)
%t10287 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t10288 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t10289 = mul i64 %t10288, 8
%t10290 = call i64 @mcopy(i64 %t10286, i64 %t10287, i64 %t10289)
%t10291 = add i64 %t10278, 32
%t10292 = call i64 @st64(i64 %t10291, i64 %t10286)
%t10293 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t10294 = icmp eq i64 %t10293, 0
br i1 %t10294, label %L3148, label %L3150
L3148:
ret i64 %t10278
L3150:
%t10295 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t10296 = mul i64 %t10295, 8
%t10297 = call i64 @__mruntime_rt_map_resid__map_obj(i64 %t10296)
%t10298 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t10299 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t10300 = mul i64 %t10299, 8
%t10301 = call i64 @mcopy(i64 %t10297, i64 %t10298, i64 %t10300)
%t10302 = add i64 %t10278, 40
%t10303 = call i64 @st64(i64 %t10302, i64 %t10297)
%t10304 = mul nsw i64 %t10303, 0
%t10305 = add nsw i64 %t10304, %t10278
ret i64 %t10305
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
%p5 = phi i64 [ %p5.in, %entry ], [ %t10314, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ]
%t10306 = icmp sge i64 %p5, %p6
br i1 %t10306, label %L3151, label %L3153
L3151:
ret i64 0
L3153:
%t10307 = mul i64 %p5, 8
%t10308 = add i64 %p3, %t10307
%t10309 = call i64 @ld64(i64 %t10308)
%t10310 = mul i64 %p5, 8
%t10311 = add i64 %p4, %t10310
%t10312 = call i64 @ld64(i64 %t10311)
%t10313 = call i64 @__mruntime_rt_map_resid__t_put(i64 %p0, i64 %p1, i64 %t10309, i64 %p2, i64 %t10312)
%t10314 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_map_freeze(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10316 = add i64 %p0, 24
%t10317 = call i64 @st64(i64 %t10316, i64 0)
%t10318 = mul nsw i64 %t10317, 0
%t10319 = add nsw i64 %t10318, %p0
ret i64 %t10319
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
%t10320 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10321 = icmp eq i64 %t10320, 0
br i1 %t10321, label %L3154, label %L3155
L3154:
%t10322 = add i64 %p0, 44
%t10323 = call i64 @st8(i64 %t10322, i64 %p1)
%t10324 = add i64 %p0, 45
%t10325 = call i64 @st8(i64 %t10324, i64 %p3)
%t10326 = add i64 %t10323, %t10325
br label %L3156
L3155:
br label %L3156
L3156:
%t10327 = phi i64 [ %t10326, %L3154 ], [ 0, %L3155 ]
%t10328 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10329 = call i1 @__mruntime_rt_map_resid__word_in(i64 %t10328, i64 %p1, i64 %p2)
%t10330 = call i64 @__mruntime_rt_map_resid__mret()
%t10331 = call i64 @ld64(i64 %t10330)
br label %LSL10332
LSL10332:
br i1 %t10329, label %LSR10332, label %LSJ10332
LSR10332:
%t10333 = call i64 @__mruntime_rt_map_resid__mvk(i64 %p0)
%t10334 = call i1 @__mruntime_rt_map_resid__word_in(i64 %t10333, i64 %p3, i64 %p4)
br label %LSJ10332
LSJ10332:
%t10335 = phi i1 [ false, %LSL10332 ], [ %t10334, %LSR10332 ]
%t10336 = call i64 @__mruntime_rt_map_resid__mret()
%t10337 = call i64 @ld64(i64 %t10336)
%t10338 = xor i1 %t10329, true
br label %LSL10339
LSL10339:
br i1 %t10338, label %LSJ10339, label %LSR10339
LSR10339:
%t10340 = xor i1 %t10335, true
br label %LSJ10339
LSJ10339:
%t10341 = phi i1 [ true, %LSL10339 ], [ %t10340, %LSR10339 ]
br i1 %t10341, label %L3157, label %L3159
L3157:
%t10342 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t10343 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10344 = call i64 @__mruntime_rt_map_resid__mvk(i64 %p0)
%t10345 = call i64 @__mruntime_rt_map_resid__base_set(i64 %t10342, i64 %t10343, i64 %t10344)
%t10346 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10347 = call i64 @__mruntime_rt_map_resid__base_boxed(i64 %t10346, i1 true, i1 true)
%t10348 = add i64 %p0, 8
%t10349 = call i64 @__mruntime_rt_map_resid__b_root()
%t10350 = call i64 @st64(i64 %t10348, i64 %t10349)
%t10351 = add i64 %p0, 44
%t10352 = call i64 @st8(i64 %t10351, i64 0)
%t10353 = add i64 %t10350, %t10352
%t10354 = add i64 %p0, 45
%t10355 = call i64 @st8(i64 %t10354, i64 0)
%t10356 = add i64 %t10353, %t10355
%t10357 = add i64 %p0, 32
%t10358 = call i64 @__mruntime_rt_map_resid__new_edit()
%t10359 = call i64 @st64(i64 %t10357, i64 %t10358)
%t10360 = add i64 %t10356, %t10359
%t10361 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p1, i64 %p2)
%t10362 = call i64 @__mruntime_rt_map_resid__mbox(i64 %p3, i64 %p4)
%t10363 = call i64 @__mruntime_rt_map_resid__trie_put_at(i64 %p0, i64 %t10361, i64 %t10362)
ret i64 %t10363
L3159:
%t10364 = call i64 @__mruntime_rt_map_resid__trie_put_at(i64 %p0, i64 %t10331, i64 %t10337)
ret i64 %t10364
}
define internal i64 @__mruntime_rt_map_resid__trie_put_at(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10365 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t10366 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10367 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %t10366, i64 %p1)
%t10368 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10369 = call i64 @__mruntime_rt_map_resid__medit(i64 %p0)
%t10370 = call i64 @__mruntime_rt_map_resid__hn_insert(i64 %t10365, i64 0, i64 %t10367, i64 %t10368, i64 %p1, i64 %p2, i64 %t10369)
%t10371 = add i64 %p0, 8
%t10372 = call i64 @st64(i64 %t10371, i64 %t10370)
%t10373 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10374 = call i64 @__mruntime_rt_map_resid__mflag()
%t10375 = call i64 @ld64(i64 %t10374)
%t10376 = add i64 %t10373, %t10375
%t10377 = call i64 @st64(i64 %p0, i64 %t10376)
%t10378 = mul nsw i64 %t10377, 0
%t10379 = add nsw i64 %t10378, %p0
ret i64 %t10379
}
define internal i64 @__mruntime_rt_map_resid__map_put_slow(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10380 = icmp eq i64 %p2, 4
br i1 %t10380, label %L3160, label %L3161
L3160:
br label %L3162
L3161:
br label %L3162
L3162:
%t10381 = phi i64 [ 1, %L3160 ], [ 0, %L3161 ]
%t10382 = icmp eq i64 %p2, 4
br i1 %t10382, label %L3163, label %L3164
L3163:
br label %L3165
L3164:
br label %L3165
L3165:
%t10383 = phi i64 [ 0, %L3163 ], [ %p2, %L3164 ]
%t10384 = icmp eq i64 %p4, 4
br label %LSL10385
LSL10385:
br i1 %t10384, label %LSJ10385, label %LSR10385
LSR10385:
%t10386 = icmp eq i64 %p4, 5
br label %LSJ10385
LSJ10385:
%t10387 = phi i1 [ true, %LSL10385 ], [ %t10386, %LSR10385 ]
br i1 %t10387, label %L3166, label %L3167
L3166:
br label %L3168
L3167:
br label %L3168
L3168:
%t10388 = phi i64 [ %p4, %L3166 ], [ 0, %L3167 ]
%t10389 = icmp eq i64 %p4, 4
br label %LSL10390
LSL10390:
br i1 %t10389, label %LSJ10390, label %LSR10390
LSR10390:
%t10391 = icmp eq i64 %p4, 5
br label %LSJ10390
LSJ10390:
%t10392 = phi i1 [ true, %LSL10390 ], [ %t10391, %LSR10390 ]
br i1 %t10392, label %L3169, label %L3170
L3169:
br label %L3171
L3170:
br label %L3171
L3171:
%t10393 = phi i64 [ 0, %L3169 ], [ %p4, %L3170 ]
%t10394 = icmp ne i64 %p1, 0
br label %LSL10395
LSL10395:
br i1 %t10394, label %LSR10395, label %LSJ10395
LSR10395:
%t10396 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
%t10397 = xor i1 %t10396, true
br label %LSJ10395
LSJ10395:
%t10398 = phi i1 [ false, %LSL10395 ], [ %t10397, %LSR10395 ]
br i1 %t10398, label %L3172, label %L3173
L3172:
%t10399 = call i64 @rt_map_transient(i64 %p0)
br label %L3174
L3173:
br label %L3174
L3174:
%t10400 = phi i64 [ %t10399, %L3172 ], [ %p0, %L3173 ]
%t10401 = icmp ne i64 %p1, 0
br label %LSL10402
LSL10402:
br i1 %t10401, label %LSR10402, label %LSJ10402
LSR10402:
%t10403 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %t10400)
br label %LSJ10402
LSJ10402:
%t10404 = phi i1 [ false, %LSL10402 ], [ %t10403, %LSR10402 ]
br i1 %t10404, label %L3175, label %L3177
L3175:
%t10405 = call i64 @__mruntime_rt_map_resid__map_heap_w()
%t10406 = call i64 @ld64(i64 %t10405)
%t10407 = call i64 @__mruntime_rt_map_resid__map_heap_w()
%t10408 = call i1 @__mruntime_rt_map_resid__in_region(i64 %t10400)
br i1 %t10408, label %L3178, label %L3179
L3178:
br label %L3180
L3179:
br label %L3180
L3180:
%t10409 = phi i64 [ 0, %L3178 ], [ 1, %L3179 ]
%t10410 = call i64 @st64(i64 %t10407, i64 %t10409)
%t10411 = call i64 @__mruntime_rt_map_resid__mtab(i64 %t10400)
%t10412 = icmp ne i64 %t10411, 0
br i1 %t10412, label %L3181, label %L3182
L3181:
%t10413 = call i64 @__mruntime_rt_map_resid__tab_put_owned(i64 %t10400, i64 %t10383, i64 %p3, i64 %t10393, i64 %p5, i64 %t10381, i64 %t10388)
br label %L3183
L3182:
%t10414 = icmp ne i64 %t10381, 0
br i1 %t10414, label %L3184, label %L3185
L3184:
br label %L3186
L3185:
br label %L3186
L3186:
%t10415 = phi i64 [ 4, %L3184 ], [ 0, %L3185 ]
%t10416 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %t10415, i64 %p3)
%t10417 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %t10388, i64 %p5)
%t10418 = call i64 @__mruntime_rt_map_resid__trie_put_owned(i64 %t10400, i64 %t10383, i64 %t10416, i64 %t10393, i64 %t10417)
br label %L3183
L3183:
%t10419 = phi i64 [ %t10413, %L3181 ], [ %t10418, %L3186 ]
%t10420 = call i64 @__mruntime_rt_map_resid__map_heap_w()
%t10421 = call i64 @st64(i64 %t10420, i64 %t10406)
%t10422 = mul nsw i64 %t10421, 0
%t10423 = add nsw i64 %t10422, %t10400
ret i64 %t10423
L3177:
%t10424 = icmp ne i64 %t10381, 0
br i1 %t10424, label %L3187, label %L3188
L3187:
br label %L3189
L3188:
br label %L3189
L3189:
%t10425 = phi i64 [ 4, %L3187 ], [ 0, %L3188 ]
%t10426 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %t10425, i64 %p3)
%t10427 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %t10388, i64 %p5)
%t10428 = call i64 @__mruntime_rt_map_resid__map_insert_p(i64 %t10400, i64 %t10383, i64 %t10426, i64 %t10393, i64 %t10427)
ret i64 %t10428
}
define internal i64 @__mruntime_rt_map_resid__tab_put_owned(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10429 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10430 = add i64 %t10429, 72
%t10431 = call i64 @st8(i64 %t10430, i64 0)
%t10432 = call i64 @__mruntime_rt_map_resid__t_put_s(i64 %t10429, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6)
%t10433 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t10429)
%t10434 = call i64 @st64(i64 %p0, i64 %t10433)
ret i64 %t10434
}
define internal i64 @rt_map_put(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10435 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10436 = icmp ne i64 %p1, 0
br label %LSL10437
LSL10437:
br i1 %t10436, label %LSR10437, label %LSJ10437
LSR10437:
%t10438 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
br label %LSJ10437
LSJ10437:
%t10439 = phi i1 [ false, %LSL10437 ], [ %t10438, %LSR10437 ]
br label %LSL10440
LSL10440:
br i1 %t10439, label %LSR10440, label %LSJ10440
LSR10440:
%t10441 = icmp ne i64 %t10435, 0
br label %LSJ10440
LSJ10440:
%t10442 = phi i1 [ false, %LSL10440 ], [ %t10441, %LSR10440 ]
br label %LSL10443
LSL10443:
br i1 %t10442, label %LSR10443, label %LSJ10443
LSR10443:
%t10444 = icmp eq i64 %p2, 1
br label %LSJ10443
LSJ10443:
%t10445 = phi i1 [ false, %LSL10443 ], [ %t10444, %LSR10443 ]
br label %LSL10446
LSL10446:
br i1 %t10445, label %LSR10446, label %LSJ10446
LSR10446:
%t10447 = call i64 @__mruntime_rt_map_resid__tkk(i64 %t10435)
%t10448 = icmp eq i64 %t10447, 1
br label %LSJ10446
LSJ10446:
%t10449 = phi i1 [ false, %LSL10446 ], [ %t10448, %LSR10446 ]
br label %LSL10450
LSL10450:
br i1 %t10449, label %LSR10450, label %LSJ10450
LSR10450:
%t10451 = call i64 @__mruntime_rt_map_resid__tvk(i64 %t10435)
%t10452 = icmp eq i64 %t10451, %p4
br label %LSJ10450
LSJ10450:
%t10453 = phi i1 [ false, %LSL10450 ], [ %t10452, %LSR10450 ]
br label %LSL10454
LSL10454:
br i1 %t10453, label %LSR10454, label %LSJ10454
LSR10454:
%t10455 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t10435)
%t10456 = icmp ne i64 %t10455, 0
br label %LSL10457
LSL10457:
br i1 %t10456, label %LSJ10457, label %LSR10457
LSR10457:
%t10458 = icmp eq i64 %p5, 1
br label %LSJ10457
LSJ10457:
%t10459 = phi i1 [ true, %LSL10457 ], [ %t10458, %LSR10457 ]
br label %LSJ10454
LSJ10454:
%t10460 = phi i1 [ false, %LSL10454 ], [ %t10459, %LSJ10457 ]
br label %LSL10461
LSL10461:
br i1 %t10460, label %LSR10461, label %LSJ10461
LSR10461:
%t10462 = call i64 @lshr(i64 %p3, i64 1)
%t10463 = call i64 @__mruntime_rt_map_resid__raw_empty()
%t10464 = call i64 @lshr(i64 %t10463, i64 1)
%t10465 = icmp ne i64 %t10462, %t10464
br label %LSJ10461
LSJ10461:
%t10466 = phi i1 [ false, %LSL10461 ], [ %t10465, %LSR10461 ]
br i1 %t10466, label %L3190, label %L3192
L3190:
%t10467 = call i64 @__mruntime_rt_map_resid__probe_raw_cached(i64 %t10435, i64 %p3)
%t10468 = icmp sge i64 %t10467, 0
br i1 %t10468, label %L3193, label %L3195
L3193:
%t10469 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t10435)
%t10470 = icmp ne i64 %t10469, 0
br i1 %t10470, label %L3196, label %L3197
L3196:
%t10471 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t10435)
%t10472 = mul i64 %t10467, 8
%t10473 = add i64 %t10471, %t10472
%t10474 = call i64 @st64(i64 %t10473, i64 %p5)
br label %L3198
L3197:
br label %L3198
L3198:
%t10475 = phi i64 [ %t10474, %L3196 ], [ 0, %L3197 ]
%t10476 = mul nsw i64 %t10475, 0
%t10477 = add nsw i64 %t10476, %p0
ret i64 %t10477
L3195:
%t10478 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t10435)
%t10479 = call i64 @__mruntime_rt_map_resid__ttombs(i64 %t10435)
%t10480 = add i64 %t10478, %t10479
%t10481 = add i64 %t10480, 1
%t10482 = call i64 @__mruntime_rt_map_resid__tcap(i64 %t10435)
%t10483 = call i1 @__mruntime_rt_map_resid__t_over(i64 %t10481, i64 %t10482)
%t10484 = xor i1 %t10483, true
br i1 %t10484, label %L3199, label %L3201
L3199:
%t10485 = sub i64 0, %t10467
%t10486 = sub nsw i64 %t10485, 1
%t10487 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %t10435)
%t10488 = mul i64 %t10486, 8
%t10489 = add i64 %t10487, %t10488
%t10490 = call i64 @st64(i64 %t10489, i64 %p3)
%t10491 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t10435)
%t10492 = icmp ne i64 %t10491, 0
br i1 %t10492, label %L3202, label %L3203
L3202:
%t10493 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t10435)
%t10494 = mul i64 %t10486, 8
%t10495 = add i64 %t10493, %t10494
%t10496 = call i64 @st64(i64 %t10495, i64 %p5)
br label %L3204
L3203:
br label %L3204
L3204:
%t10497 = phi i64 [ %t10496, %L3202 ], [ 0, %L3203 ]
%t10498 = add i64 %t10435, 8
%t10499 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t10435)
%t10500 = add i64 %t10499, 1
%t10501 = call i64 @st64(i64 %t10498, i64 %t10500)
%t10502 = add i64 %t10435, 88
%t10503 = call i64 @st64(i64 %t10502, i64 %t10486)
%t10504 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t10435)
%t10505 = call i64 @st64(i64 %p0, i64 %t10504)
%t10506 = mul nsw i64 %t10505, 0
%t10507 = add nsw i64 %t10506, %p0
ret i64 %t10507
L3201:
br label %L3192
L3192:
%t10508 = tail call i64 @__mruntime_rt_map_resid__map_put_slow(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5)
ret i64 %t10508
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
%t10509 = icmp eq i64 %p0, 0
br label %LSL10510
LSL10510:
br i1 %t10509, label %LSJ10510, label %LSR10510
LSR10510:
%t10511 = call i1 @ult(i64 %p0, i64 4096)
br label %LSJ10510
LSJ10510:
%t10512 = phi i1 [ true, %LSL10510 ], [ %t10511, %LSR10510 ]
br label %LSL10513
LSL10513:
br i1 %t10512, label %LSJ10513, label %LSR10513
LSR10513:
%t10514 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t10515 = xor i1 %t10514, true
br label %LSJ10513
LSJ10513:
%t10516 = phi i1 [ true, %LSL10513 ], [ %t10515, %LSR10513 ]
br i1 %t10516, label %L3205, label %L3207
L3205:
ret i64 %p0
L3207:
%t10517 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p0)
%t10518 = xor i1 %t10517, true
br i1 %t10518, label %L3208, label %L3210
L3208:
%t10519 = tail call i64 @rt_str_keep(i64 %p0)
ret i64 %t10519
L3210:
%t10520 = call i64 @__mruntime_rt_map_resid__word_of_box(i64 %p0, i1 false)
%t10521 = icmp eq i64 %t10520, 0
br i1 %t10521, label %L3211, label %L3213
L3211:
ret i64 %p0
L3213:
%t10522 = call i64 @__mruntime_rt_map_resid__mret()
%t10523 = call i64 @ld64(i64 %t10522)
%t10524 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t10525 = call i64 @c_sc_depth_set(i64 0)
%t10526 = call i64 @__mruntime_rt_map_resid__box_any(i64 %t10520, i64 %t10523)
%t10527 = call i64 @c_sc_depth_set(i64 %t10524)
%t10528 = mul nsw i64 %t10527, 0
%t10529 = add nsw i64 %t10528, %t10526
ret i64 %t10529
}
define internal i64 @rt_map_list_push(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10530 = icmp eq i64 %p2, 4
br i1 %t10530, label %L3214, label %L3215
L3214:
br label %L3216
L3215:
br label %L3216
L3216:
%t10531 = phi i64 [ 0, %L3214 ], [ %p2, %L3215 ]
%t10532 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t10533 = xor i1 %t10532, true
%t10534 = icmp ne i64 %p1, 0
br label %LSL10535
LSL10535:
br i1 %t10534, label %LSR10535, label %LSJ10535
LSR10535:
%t10536 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
br label %LSJ10535
LSJ10535:
%t10537 = phi i1 [ false, %LSL10535 ], [ %t10536, %LSR10535 ]
br label %LSL10538
LSL10538:
br i1 %t10537, label %LSR10538, label %LSJ10538
LSR10538:
%t10539 = call i64 @__mruntime_rt_map_resid__mown(i64 %p0)
%t10540 = icmp ne i64 %t10539, 0
br label %LSJ10538
LSJ10538:
%t10541 = phi i1 [ false, %LSL10538 ], [ %t10540, %LSR10538 ]
br i1 %t10541, label %L3217, label %L3219
L3217:
%t10542 = call i64 @__mruntime_rt_map_resid__map_vref_raw(i64 %p0, i64 %t10531, i64 %p3)
%t10543 = icmp ne i64 %t10542, 0
br i1 %t10543, label %L3220, label %L3221
L3220:
%t10544 = call i64 @ld64(i64 %t10542)
br label %L3222
L3221:
br label %L3222
L3222:
%t10545 = phi i64 [ %t10544, %L3220 ], [ 0, %L3221 ]
%t10546 = icmp ne i64 %t10545, 0
br label %LSL10547
LSL10547:
br i1 %t10546, label %LSR10547, label %LSJ10547
LSR10547:
%t10548 = add i64 %t10545, 12
%t10549 = call i64 @ld32(i64 %t10548)
%t10550 = call i64 @__mruntime_rt_map_resid__mown(i64 %p0)
%t10551 = icmp eq i64 %t10549, %t10550
br label %LSJ10547
LSJ10547:
%t10552 = phi i1 [ false, %LSL10547 ], [ %t10551, %LSR10547 ]
br i1 %t10552, label %L3223, label %L3225
L3223:
%t10553 = call i64 @__mruntime_rt_map_resid__sc_depth()
br i1 %t10533, label %L3226, label %L3227
L3226:
%t10554 = call i64 @__mruntime_rt_map_resid__elem_keep(i64 %p4)
br label %L3228
L3227:
br label %L3228
L3228:
%t10555 = phi i64 [ %t10554, %L3226 ], [ %p4, %L3227 ]
br i1 %t10533, label %L3229, label %L3230
L3229:
%t10556 = call i64 @c_sc_depth_set(i64 0)
br label %L3231
L3230:
br label %L3231
L3231:
%t10557 = phi i64 [ %t10556, %L3229 ], [ 0, %L3230 ]
%t10558p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.map_one_elem)
%t10558 = ptrtoint ptr %t10558p to i64
%t10559 = call i64 @st64(i64 %t10558, i64 %t10555)
%t10560 = call i64 @pvec_append_into(i64 %t10545, i64 %t10545, i64 %t10558, i64 1)
%t10561 = call i64 @c_sc_depth_set(i64 %t10553)
%t10562 = mul nsw i64 %t10561, 0
%t10563 = add nsw i64 %t10562, %p0
ret i64 %t10563
L3225:
br label %L3219
L3219:
%t10564 = call i64 @__mruntime_rt_map_resid__map_vref_raw(i64 %p0, i64 %t10531, i64 %p3)
%t10565 = icmp ne i64 %t10564, 0
br i1 %t10565, label %L3232, label %L3233
L3232:
%t10566 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10567 = call i64 @ld64(i64 %t10564)
%t10568 = call i64 @__mruntime_rt_map_resid__word_out(i64 %t10566, i64 0, i64 %t10567)
br label %L3234
L3233:
br label %L3234
L3234:
%t10569 = phi i64 [ %t10568, %L3232 ], [ %p5, %L3233 ]
%t10570 = call i64 @lcount(i64 %t10569)
%t10571 = icmp eq i64 %t10570, 0
br i1 %t10571, label %L3235, label %L3236
L3235:
%t10572 = icmp ne i64 %p1, 0
%t10573 = call i64 @__mruntime_rt_map_resid__fresh_list(i64 %t10569, i64 %p4, i1 %t10533, i1 %t10572)
br label %L3237
L3236:
%t10574 = call i64 @pvec_push(i64 %t10569, i64 %p4)
br label %L3237
L3237:
%t10575 = phi i64 [ %t10573, %L3235 ], [ %t10574, %L3236 ]
%t10576 = call i64 @rt_map_put(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 5, i64 %t10575)
%t10577 = icmp ne i64 %p1, 0
br label %LSL10578
LSL10578:
br i1 %t10577, label %LSR10578, label %LSJ10578
LSR10578:
%t10579 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %t10576)
br label %LSJ10578
LSJ10578:
%t10580 = phi i1 [ false, %LSL10578 ], [ %t10579, %LSR10578 ]
br label %LSL10581
LSL10581:
br i1 %t10580, label %LSR10581, label %LSJ10581
LSR10581:
%t10582 = call i64 @__mruntime_rt_map_resid__mown(i64 %t10576)
%t10583 = icmp ne i64 %t10582, 0
br label %LSJ10581
LSJ10581:
%t10584 = phi i1 [ false, %LSL10581 ], [ %t10583, %LSR10581 ]
br i1 %t10584, label %L3238, label %L3240
L3238:
%t10585 = call i64 @__mruntime_rt_map_resid__map_vref_raw(i64 %t10576, i64 %t10531, i64 %p3)
%t10586 = icmp ne i64 %t10585, 0
br i1 %t10586, label %L3241, label %L3242
L3241:
%t10587 = call i64 @ld64(i64 %t10585)
%t10588 = add i64 %t10587, 12
%t10589 = call i64 @__mruntime_rt_map_resid__mown(i64 %t10576)
%t10590 = call i64 @st32(i64 %t10588, i64 %t10589)
br label %L3243
L3242:
br label %L3243
L3243:
%t10591 = phi i64 [ %t10590, %L3241 ], [ 0, %L3242 ]
ret i64 %t10576
L3240:
ret i64 %t10576
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
%t10592 = call i64 @__mruntime_rt_map_resid__sc_depth()
br label %LSL10593
LSL10593:
br i1 %p2, label %LSR10593, label %LSJ10593
LSR10593:
br label %LSJ10593
LSJ10593:
%t10594 = phi i1 [ false, %LSL10593 ], [ %p3, %LSR10593 ]
br i1 %t10594, label %L3244, label %L3245
L3244:
%t10595 = call i64 @c_sc_depth_set(i64 0)
br label %L3246
L3245:
br label %L3246
L3246:
%t10596 = phi i64 [ %t10595, %L3244 ], [ 0, %L3245 ]
%t10597 = call i64 @flat_new(i64 4)
%t10598 = add i64 %t10597, 24
br i1 %p2, label %L3247, label %L3248
L3247:
%t10599 = call i64 @__mruntime_rt_map_resid__elem_keep(i64 %p1)
br label %L3249
L3248:
br label %L3249
L3249:
%t10600 = phi i64 [ %t10599, %L3247 ], [ %p1, %L3248 ]
%t10601 = call i64 @st64(i64 %t10598, i64 %t10600)
%t10602 = call i64 @st64(i64 %t10597, i64 1)
%t10603 = call i64 @list_hdr()
%t10604 = call i64 @st64(i64 %t10603, i64 1)
%t10605 = add i64 %t10603, 8
%t10606 = sub nsw i64 0, 1
%t10607 = call i64 @st32(i64 %t10605, i64 %t10606)
%t10608 = add i64 %t10604, %t10607
%t10609 = add i64 %t10603, 16
%t10610 = call i64 @st64(i64 %t10609, i64 %t10597)
%t10611 = add i64 %t10608, %t10610
%t10612 = add i64 %t10603, 24
%t10613 = call i64 @ltype(i64 %p0)
%t10614 = call i64 @st64(i64 %t10612, i64 %t10613)
%t10615 = add i64 %t10611, %t10614
%t10616 = call i64 @c_sc_depth_set(i64 %t10592)
%t10617 = mul nsw i64 %t10616, 0
%t10618 = add nsw i64 %t10617, %t10603
ret i64 %t10618
}
define internal i64 @rt_map_del(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10619 = icmp eq i64 %p2, 4
br i1 %t10619, label %L3250, label %L3251
L3250:
br label %L3252
L3251:
br label %L3252
L3252:
%t10620 = phi i64 [ 0, %L3250 ], [ %p2, %L3251 ]
%t10621 = icmp ne i64 %p1, 0
br label %LSL10622
LSL10622:
br i1 %t10621, label %LSR10622, label %LSJ10622
LSR10622:
%t10623 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
%t10624 = xor i1 %t10623, true
br label %LSJ10622
LSJ10622:
%t10625 = phi i1 [ false, %LSL10622 ], [ %t10624, %LSR10622 ]
br label %LSL10626
LSL10626:
br i1 %t10625, label %LSR10626, label %LSJ10626
LSR10626:
%t10627 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10628 = icmp sgt i64 %t10627, 0
br label %LSJ10626
LSJ10626:
%t10629 = phi i1 [ false, %LSL10626 ], [ %t10628, %LSR10626 ]
br i1 %t10629, label %L3253, label %L3254
L3253:
%t10630 = call i64 @rt_map_transient(i64 %p0)
br label %L3255
L3254:
br label %L3255
L3255:
%t10631 = phi i64 [ %t10630, %L3253 ], [ %p0, %L3254 ]
%t10632 = icmp ne i64 %p1, 0
br label %LSL10633
LSL10633:
br i1 %t10632, label %LSR10633, label %LSJ10633
LSR10633:
%t10634 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %t10631)
br label %LSJ10633
LSJ10633:
%t10635 = phi i1 [ false, %LSL10633 ], [ %t10634, %LSR10633 ]
br label %LSL10636
LSL10636:
br i1 %t10635, label %LSR10636, label %LSJ10636
LSR10636:
%t10637 = call i64 @__mruntime_rt_map_resid__mtab(i64 %t10631)
%t10638 = icmp eq i64 %t10637, 0
br label %LSJ10636
LSJ10636:
%t10639 = phi i1 [ false, %LSL10636 ], [ %t10638, %LSR10636 ]
br i1 %t10639, label %L3256, label %L3258
L3256:
%t10640 = call i64 @__mruntime_rt_map_resid__map_heap_w()
%t10641 = call i64 @ld64(i64 %t10640)
%t10642 = call i64 @__mruntime_rt_map_resid__map_heap_w()
%t10643 = call i1 @__mruntime_rt_map_resid__in_region(i64 %t10631)
br i1 %t10643, label %L3259, label %L3260
L3259:
br label %L3261
L3260:
br label %L3261
L3261:
%t10644 = phi i64 [ 0, %L3259 ], [ 1, %L3260 ]
%t10645 = call i64 @st64(i64 %t10642, i64 %t10644)
%t10646 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t10631)
%t10647 = icmp sgt i64 %t10646, 0
br label %LSL10648
LSL10648:
br i1 %t10647, label %LSR10648, label %LSJ10648
LSR10648:
%t10649 = call i64 @__mruntime_rt_map_resid__mkk(i64 %t10631)
%t10650 = call i1 @__mruntime_rt_map_resid__key_lookup_word(i64 %t10649, i64 %t10620, i64 %p3)
br label %LSJ10648
LSJ10648:
%t10651 = phi i1 [ false, %LSL10648 ], [ %t10650, %LSR10648 ]
br i1 %t10651, label %L3262, label %L3263
L3262:
%t10652 = call i64 @__mruntime_rt_map_resid__mret()
%t10653 = call i64 @ld64(i64 %t10652)
%t10654 = call i64 @__mruntime_rt_map_resid__trie_del_at(i64 %t10631, i64 %t10653)
br label %L3264
L3263:
br label %L3264
L3264:
%t10655 = phi i64 [ %t10654, %L3262 ], [ 0, %L3263 ]
%t10656 = call i64 @__mruntime_rt_map_resid__map_heap_w()
%t10657 = call i64 @st64(i64 %t10656, i64 %t10641)
%t10658 = mul nsw i64 %t10657, 0
%t10659 = add nsw i64 %t10658, %t10631
ret i64 %t10659
L3258:
%t10660 = icmp ne i64 %p1, 0
br label %LSL10661
LSL10661:
br i1 %t10660, label %LSR10661, label %LSJ10661
LSR10661:
%t10662 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %t10631)
br label %LSJ10661
LSJ10661:
%t10663 = phi i1 [ false, %LSL10661 ], [ %t10662, %LSR10661 ]
br i1 %t10663, label %L3265, label %L3267
L3265:
%t10664 = call i64 @__mruntime_rt_map_resid__mtab(i64 %t10631)
%t10665 = call i1 @__mruntime_rt_map_resid__t_del(i64 %t10664, i64 %t10620, i64 %p3)
%t10666 = call i64 @__mruntime_rt_map_resid__mtab(i64 %t10631)
%t10667 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t10666)
%t10668 = call i64 @st64(i64 %t10631, i64 %t10667)
%t10669 = mul nsw i64 %t10668, 0
%t10670 = add nsw i64 %t10669, %t10631
ret i64 %t10670
L3267:
%t10671 = call i64 @__mruntime_rt_map_resid__map_remove_p(i64 %t10631, i64 %t10620, i64 %p3)
ret i64 %t10671
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
%t10672 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t10673 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10674 = call i64 @__mruntime_rt_map_resid__key_hash(i64 %t10673, i64 %p1)
%t10675 = call i64 @__mruntime_rt_map_resid__mkk(i64 %p0)
%t10676 = call i64 @__mruntime_rt_map_resid__medit(i64 %p0)
%t10677 = call i64 @__mruntime_rt_map_resid__hn_remove(i64 %t10672, i64 0, i64 %t10674, i64 %t10675, i64 %p1, i64 %t10676)
%t10678 = add i64 %p0, 8
%t10679 = call i64 @st64(i64 %t10678, i64 %t10677)
%t10680 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10681 = call i64 @__mruntime_rt_map_resid__mflag()
%t10682 = call i64 @ld64(i64 %t10681)
%t10683 = sub i64 %t10680, %t10682
%t10684 = tail call i64 @st64(i64 %p0, i64 %t10683)
ret i64 %t10684
}
define internal i64 @rt_set_put(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10685 = call i64 @rt_map_put(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 1)
ret i64 %t10685
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
%t10686 = call i64 @__mruntime_rt_map_resid__map_vref(i64 %p0, i64 %p1, i64 %p2)
%t10687 = icmp eq i64 %t10686, 0
br i1 %t10687, label %L3268, label %L3270
L3268:
%t10688 = sext i64 0 to i128
ret i128 %t10688
L3270:
%t10689 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10690 = call i64 @ld64(i64 %t10686)
%t10691 = call i64 @__mruntime_rt_map_resid__word_out(i64 %t10689, i64 %p3, i64 %t10690)
%t10692 = icmp ne i64 %p3, 0
br label %LSL10693
LSL10693:
br i1 %t10692, label %LSR10693, label %LSJ10693
LSR10693:
%t10694 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10695 = icmp eq i64 %t10694, 0
br label %LSJ10693
LSJ10693:
%t10696 = phi i1 [ false, %LSL10693 ], [ %t10695, %LSR10693 ]
br label %LSL10697
LSL10697:
br i1 %t10696, label %LSR10697, label %LSJ10697
LSR10697:
%t10698 = call i64 @ld64(i64 %t10686)
%t10699 = call i1 @__mruntime_rt_map_resid__unbox_k(i64 %p3, i64 %t10698)
%t10700 = xor i1 %t10699, true
br label %LSJ10697
LSJ10697:
%t10701 = phi i1 [ false, %LSL10697 ], [ %t10700, %LSR10697 ]
br i1 %t10701, label %L3271, label %L3273
L3271:
%t10702 = sext i64 0 to i128
ret i128 %t10702
L3273:
%t10703 = icmp ne i64 %p3, 0
br label %LSL10704
LSL10704:
br i1 %t10703, label %LSR10704, label %LSJ10704
LSR10704:
%t10705 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10706 = icmp eq i64 %t10705, 0
br label %LSJ10704
LSJ10704:
%t10707 = phi i1 [ false, %LSL10704 ], [ %t10706, %LSR10704 ]
br i1 %t10707, label %L3274, label %L3275
L3274:
%t10708 = call i64 @__mruntime_rt_map_resid__mret()
%t10709 = call i64 @ld64(i64 %t10708)
br label %L3276
L3275:
br label %L3276
L3276:
%t10710 = phi i64 [ %t10709, %L3274 ], [ %t10691, %L3275 ]
%t10711 = call i128 @__mruntime_rt_map_resid__found_word(i64 %t10710)
ret i128 %t10711
}
define internal i128 @__mruntime_rt_map_resid__found_word(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10712 = sext i64 1 to i128
%t10713 = sext i64 64 to i128
%t10714 = icmp uge i128 %t10713, 128
%t10715 = add i128 %t10713, 0
%t10716 = shl i128 %t10712, %t10715
%t10717 = select i1 %t10714, i128 0, i128 %t10716
%t10718 = sext i64 %p0 to i128
%t10719 = and i128 %t10718, 18446744073709551615
%t10720 = or i128 %t10717, %t10719
ret i128 %t10720
}
define internal i128 @rt_map_find(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10721 = icmp eq i64 %p1, 4
br i1 %t10721, label %L3277, label %L3278
L3277:
br label %L3279
L3278:
br label %L3279
L3279:
%t10722 = phi i64 [ 0, %L3277 ], [ %p1, %L3278 ]
%t10723 = icmp eq i64 %p3, 4
br i1 %t10723, label %L3280, label %L3281
L3280:
br label %L3282
L3281:
br label %L3282
L3282:
%t10724 = phi i64 [ 0, %L3280 ], [ %p3, %L3281 ]
%t10725 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10726 = call i1 @__mruntime_rt_map_resid__mtrans(i64 %p0)
br label %LSL10727
LSL10727:
br i1 %t10726, label %LSR10727, label %LSJ10727
LSR10727:
%t10728 = icmp ne i64 %t10725, 0
br label %LSJ10727
LSJ10727:
%t10729 = phi i1 [ false, %LSL10727 ], [ %t10728, %LSR10727 ]
br label %LSL10730
LSL10730:
br i1 %t10729, label %LSR10730, label %LSJ10730
LSR10730:
%t10731 = icmp eq i64 %t10722, 1
br label %LSJ10730
LSJ10730:
%t10732 = phi i1 [ false, %LSL10730 ], [ %t10731, %LSR10730 ]
br label %LSL10733
LSL10733:
br i1 %t10732, label %LSR10733, label %LSJ10733
LSR10733:
%t10734 = call i64 @__mruntime_rt_map_resid__tkk(i64 %t10725)
%t10735 = icmp eq i64 %t10734, 1
br label %LSJ10733
LSJ10733:
%t10736 = phi i1 [ false, %LSL10733 ], [ %t10735, %LSR10733 ]
br label %LSL10737
LSL10737:
br i1 %t10736, label %LSR10737, label %LSJ10737
LSR10737:
%t10738 = call i64 @__mruntime_rt_map_resid__tvk(i64 %t10725)
%t10739 = icmp eq i64 %t10738, %t10724
br label %LSJ10737
LSJ10737:
%t10740 = phi i1 [ false, %LSL10737 ], [ %t10739, %LSR10737 ]
br label %LSL10741
LSL10741:
br i1 %t10740, label %LSR10741, label %LSJ10741
LSR10741:
%t10742 = call i64 @lshr(i64 %p2, i64 1)
%t10743 = call i64 @__mruntime_rt_map_resid__raw_empty()
%t10744 = call i64 @lshr(i64 %t10743, i64 1)
%t10745 = icmp ne i64 %t10742, %t10744
br label %LSJ10741
LSJ10741:
%t10746 = phi i1 [ false, %LSL10741 ], [ %t10745, %LSR10741 ]
br i1 %t10746, label %L3283, label %L3285
L3283:
%t10747 = call i64 @__mruntime_rt_map_resid__map_exit(i64 %p0)
%t10748 = call i64 @__mruntime_rt_map_resid__probe_raw_cached(i64 %t10725, i64 %p2)
%t10749 = icmp slt i64 %t10748, 0
br i1 %t10749, label %L3286, label %L3288
L3286:
%t10750 = sext i64 0 to i128
ret i128 %t10750
L3288:
%t10751 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t10725)
%t10752 = icmp ne i64 %t10751, 0
br i1 %t10752, label %L3289, label %L3290
L3289:
%t10753 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t10725)
%t10754 = mul i64 %t10748, 8
%t10755 = add i64 %t10753, %t10754
%t10756 = call i64 @ld64(i64 %t10755)
br label %L3291
L3290:
br label %L3291
L3291:
%t10757 = phi i64 [ %t10756, %L3289 ], [ 1, %L3290 ]
%t10758 = call i128 @__mruntime_rt_map_resid__found_word(i64 %t10757)
ret i128 %t10758
L3285:
%t10759 = call i128 @__mruntime_rt_map_resid__map_find_slow(i64 %p0, i64 %t10722, i64 %p2, i64 %t10724)
ret i128 %t10759
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
%t10760 = icmp eq i64 %p1, 4
br i1 %t10760, label %L3292, label %L3293
L3292:
br label %L3294
L3293:
br label %L3294
L3294:
%t10761 = phi i64 [ 0, %L3292 ], [ %p1, %L3293 ]
%t10762 = call i64 @__mruntime_rt_map_resid__map_vref(i64 %p0, i64 %t10761, i64 %p2)
%t10763 = icmp ne i64 %t10762, 0
br i1 %t10763, label %L3295, label %L3296
L3295:
br label %L3297
L3296:
br label %L3297
L3297:
%t10764 = phi i64 [ 1, %L3295 ], [ 0, %L3296 ]
ret i64 %t10764
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
%t10765 = call i64 @__mruntime_rt_map_resid__word_of_box(i64 %p1, i1 true)
%t10766 = call i64 @__mruntime_rt_map_resid__mret()
%t10767 = call i64 @ld64(i64 %t10766)
%t10768 = call i64 @__mruntime_rt_map_resid__map_vref(i64 %p0, i64 %t10765, i64 %t10767)
%t10769 = icmp ne i64 %t10768, 0
br i1 %t10769, label %L3298, label %L3299
L3298:
%t10770 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10771 = call i64 @ld64(i64 %t10768)
%t10772 = call i64 @__mruntime_rt_map_resid__word_out(i64 %t10770, i64 0, i64 %t10771)
br label %L3300
L3299:
br label %L3300
L3300:
%t10773 = phi i64 [ %t10772, %L3298 ], [ 0, %L3299 ]
ret i64 %t10773
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
%t10774 = call i64 @__mruntime_rt_map_resid__word_of_box(i64 %p1, i1 true)
%t10775 = call i64 @__mruntime_rt_map_resid__mret()
%t10776 = call i64 @ld64(i64 %t10775)
%t10777 = call i64 @__mruntime_rt_map_resid__word_of_box(i64 %p2, i1 false)
%t10778 = call i64 @__mruntime_rt_map_resid__mret()
%t10779 = call i64 @ld64(i64 %t10778)
%t10780 = call i64 @__mruntime_rt_map_resid__map_insert_p(i64 %p0, i64 %t10774, i64 %t10776, i64 %t10777, i64 %t10779)
ret i64 %t10780
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
%t10781 = call i64 @__mruntime_rt_map_resid__word_of_box(i64 %p1, i1 true)
%t10782 = call i64 @__mruntime_rt_map_resid__mret()
%t10783 = call i64 @ld64(i64 %t10782)
%t10784 = call i64 @__mruntime_rt_map_resid__map_remove_p(i64 %p0, i64 %t10781, i64 %t10783)
ret i64 %t10784
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
%t10785 = call i64 @__mruntime_rt_map_resid__word_of_box(i64 %p1, i1 true)
%t10786 = call i64 @__mruntime_rt_map_resid__mret()
%t10787 = call i64 @ld64(i64 %t10786)
%t10788 = call i64 @__mruntime_rt_map_resid__map_vref(i64 %p0, i64 %t10785, i64 %t10787)
%t10789 = icmp ne i64 %t10788, 0
br i1 %t10789, label %L3301, label %L3302
L3301:
br label %L3303
L3302:
br label %L3303
L3303:
%t10790 = phi i64 [ 1, %L3301 ], [ 0, %L3302 ]
ret i64 %t10790
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
%t10791 = tail call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
ret i64 %t10791
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
%t10792 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10793 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t10792)
%t10794 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t10792)
%t10795 = call i64 @__mruntime_rt_map_resid__map_exit(i64 %p0)
%t10796 = call i64 @__mruntime_rt_map_resid__map_entries(i64 %p0, i64 %t10793, i64 %t10794)
%t10797 = xor i1 %p1, true
%t10798 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t10799 = call i64 @__mruntime_rt_map_resid__map_vk(i64 %p0)
%t10800 = call i64 @__mruntime_rt_map_resid__box_words(i64 %t10793, i64 %t10794, i64 0, i64 %t10792, i1 %p1, i1 %t10797, i64 %t10798, i64 %t10799)
br i1 %p1, label %L3304, label %L3306
L3304:
%t10801 = call i64 @c_free(i64 %t10794)
%t10802 = mul nsw i64 %t10801, 0
%t10803 = add nsw i64 %t10802, %t10793
ret i64 %t10803
L3306:
%t10804 = call i64 @c_free(i64 %t10793)
%t10805 = mul nsw i64 %t10804, 0
%t10806 = add nsw i64 %t10805, %t10794
ret i64 %t10806
}
define internal i64 @rt_map_keys(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10807 = call i64 @__mruntime_rt_map_resid__boxed_entries(i64 %p0, i1 true)
%t10808 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10810 = ptrtoint ptr @.s10809 to i64
%t10811 = call i64 @rt_list_new(i64 %t10808, i64 %t10807, i64 %t10810)
%t10812 = call i64 @c_free(i64 %t10807)
%t10813 = mul nsw i64 %t10812, 0
%t10814 = add nsw i64 %t10813, %t10811
ret i64 %t10814
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
%t10815 = call i64 @__mruntime_rt_map_resid__boxed_entries(i64 %p0, i1 false)
%t10816 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10818 = ptrtoint ptr @.s10817 to i64
%t10819 = call i64 @rt_list_new(i64 %t10816, i64 %t10815, i64 %t10818)
%t10820 = call i64 @c_free(i64 %t10815)
%t10821 = mul nsw i64 %t10820, 0
%t10822 = add nsw i64 %t10821, %t10819
ret i64 %t10822
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
%t10823 = call i1 @__mruntime_rt_map_resid__is_boxed(i64 %p1)
br i1 %t10823, label %L3307, label %L3308
L3307:
%t10824 = call i64 @__mruntime_rt_map_resid__stype(i64 %p1)
br label %L3309
L3308:
br label %L3309
L3309:
%t10825 = phi i64 [ %t10824, %L3307 ], [ 0, %L3308 ]
%t10826 = icmp eq i64 %t10825, 0
br i1 %t10826, label %L3310, label %L3312
L3310:
%t10827 = tail call i64 @sb_lit(i64 %p0, i64 %p1)
ret i64 %t10827
L3312:
%t10828 = icmp eq i64 %t10825, 2
br i1 %t10828, label %L3313, label %L3315
L3313:
%t10829 = call double @unbox_float(i64 %p1)
%t10830 = call i64 @sb_float(i64 %p0, double %t10829)
ret i64 %t10830
L3315:
%t10831 = icmp eq i64 %t10825, 3
br i1 %t10831, label %L3316, label %L3318
L3316:
%t10832 = add i64 %p1, 24
%t10833 = call i64 @ld8(i64 %t10832)
%t10834 = icmp ne i64 %t10833, 0
br i1 %t10834, label %L3319, label %L3320
L3319:
%t10836 = ptrtoint ptr @.s10835 to i64
br label %L3321
L3320:
%t10838 = ptrtoint ptr @.s10837 to i64
br label %L3321
L3321:
%t10839 = phi i64 [ %t10836, %L3319 ], [ %t10838, %L3320 ]
%t10840 = tail call i64 @sb_lit(i64 %p0, i64 %t10839)
ret i64 %t10840
L3318:
%t10841 = call i64 @unbox_word(i64 %p1)
%t10842 = tail call i64 @sb_word(i64 %p0, i64 %t10841)
ret i64 %t10842
}
define internal i64 @__mruntime_rt_map_resid__sb_pairs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t10863, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t10843 = icmp sge i64 %p3, %p4
br i1 %t10843, label %L3322, label %L3324
L3322:
ret i64 0
L3324:
%t10844 = icmp sgt i64 %p3, 0
br i1 %t10844, label %L3325, label %L3326
L3325:
%t10846 = ptrtoint ptr @.s10845 to i64
%t10847 = call i64 @sb_lit(i64 %p0, i64 %t10846)
br label %L3327
L3326:
br label %L3327
L3327:
%t10848 = phi i64 [ %t10847, %L3325 ], [ 0, %L3326 ]
%t10849 = mul i64 %p3, 8
%t10850 = add i64 %p1, %t10849
%t10851 = call i64 @ld64(i64 %t10850)
%t10852 = call i64 @__mruntime_rt_map_resid__sb_entry(i64 %p0, i64 %t10851)
%t10853 = icmp ne i64 %p2, 0
br i1 %t10853, label %L3328, label %L3329
L3328:
%t10855 = ptrtoint ptr @.s10854 to i64
%t10856 = call i64 @sb_lit(i64 %p0, i64 %t10855)
%t10857 = mul i64 %p3, 8
%t10858 = add i64 %p2, %t10857
%t10859 = call i64 @ld64(i64 %t10858)
%t10860 = call i64 @__mruntime_rt_map_resid__sb_entry(i64 %p0, i64 %t10859)
%t10861 = add i64 %t10856, %t10860
br label %L3330
L3329:
br label %L3330
L3330:
%t10862 = phi i64 [ %t10861, %L3328 ], [ 0, %L3329 ]
%t10863 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_map_format(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10865 = call i64 @rt_sb_new()
%t10866 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10867 = icmp sgt i64 %t10866, 0
br i1 %t10867, label %L3331, label %L3332
L3331:
%t10868 = call i64 @__mruntime_rt_map_resid__boxed_entries(i64 %p0, i1 true)
br label %L3333
L3332:
br label %L3333
L3333:
%t10869 = phi i64 [ %t10868, %L3331 ], [ 0, %L3332 ]
%t10870 = icmp sgt i64 %t10866, 0
br i1 %t10870, label %L3334, label %L3335
L3334:
%t10871 = call i64 @__mruntime_rt_map_resid__boxed_entries(i64 %p0, i1 false)
br label %L3336
L3335:
br label %L3336
L3336:
%t10872 = phi i64 [ %t10871, %L3334 ], [ 0, %L3335 ]
%t10874 = ptrtoint ptr @.s10873 to i64
%t10875 = call i64 @sb_lit(i64 %t10865, i64 %t10874)
%t10876 = call i64 @__mruntime_rt_map_resid__sb_pairs(i64 %t10865, i64 %t10869, i64 %t10872, i64 0, i64 %t10866)
%t10878 = ptrtoint ptr @.s10877 to i64
%t10879 = call i64 @sb_lit(i64 %t10865, i64 %t10878)
%t10880 = call i64 @c_free(i64 %t10869)
%t10881 = call i64 @c_free(i64 %t10872)
%t10882 = add i64 %t10880, %t10881
%t10883 = tail call i64 @rt_sb_finish(i64 %t10865)
ret i64 %t10883
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
%t10884 = sub nsw i64 0, 1
%t10885 = sub nsw i64 0, 1
%t10886 = call i64 @__mruntime_rt_map_resid__trie_new(i64 0, i64 0, i64 %t10884, i64 %t10885)
ret i64 %t10886
}
define ptr @resid_set_new() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_set_new()
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_set_insert(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10887 = call i64 @rt_map_insert(i64 %p0, i64 %p1, i64 1)
ret i64 %t10887
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
%t10888 = tail call i64 @rt_map_remove(i64 %p0, i64 %p1)
ret i64 %t10888
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
%t10889 = tail call i64 @rt_map_contains(i64 %p0, i64 %p1)
ret i64 %t10889
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
%t10890 = tail call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
ret i64 %t10890
}
define i64 @resid_set_len(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_set_len(i64 %x0i)
ret i64 %r
}
define internal i64 @__mruntime_rt_map_resid__set_words(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10891 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10892 = call i64 @__mruntime_rt_map_resid__words_of(i64 %t10891)
%t10893 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10894 = icmp ne i64 %t10893, 0
br i1 %t10894, label %L3337, label %L3339
L3337:
%t10895 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t10896 = call i64 @__mruntime_rt_map_resid__table_keys(i64 %t10895, i64 %t10892, i64 0, i64 0)
%t10897 = mul nsw i64 %t10896, 0
%t10898 = add nsw i64 %t10897, %t10892
ret i64 %t10898
L3339:
%t10899 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t10900 = call i64 @__mruntime_rt_map_resid__hn_collect(i64 %t10899, i64 %t10892, i64 0, i64 0)
%t10901 = mul nsw i64 %t10900, 0
%t10902 = add nsw i64 %t10901, %t10892
ret i64 %t10902
}
define internal i64 @__mruntime_rt_map_resid__table_keys(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t10903, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t10910, %tco.s0 ]
%t10903 = call i64 @__mruntime_rt_map_resid__t_next(i64 %p0, i64 %p2)
%t10904 = icmp slt i64 %t10903, 0
br i1 %t10904, label %L3340, label %L3342
L3340:
ret i64 %p3
L3342:
%t10905 = mul i64 %p3, 8
%t10906 = add i64 %p1, %t10905
%t10907 = call i64 @__mruntime_rt_map_resid__mret()
%t10908 = call i64 @ld64(i64 %t10907)
%t10909 = call i64 @st64(i64 %t10906, i64 %t10908)
%t10910 = add i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__set_of_words(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10912 = sub nsw i64 0, 1
%t10913 = sub nsw i64 0, 1
%t10914 = call i64 @__mruntime_rt_map_resid__trie_new(i64 0, i64 0, i64 %t10912, i64 %t10913)
%t10915 = icmp eq i64 %p1, 0
br i1 %t10915, label %L3343, label %L3345
L3343:
ret i64 %t10914
L3345:
%t10916 = call i64 @__mruntime_rt_map_resid__cap_for(i64 %p1)
%t10917 = call i64 @__mruntime_rt_map_resid__tab_new(i64 %t10916, i64 %p2, i64 0, i1 true)
%t10918 = add i64 %t10914, 16
%t10919 = call i64 @st64(i64 %t10918, i64 %t10917)
%t10920 = call i64 @__mruntime_rt_map_resid__insert_words(i64 %t10917, i64 %p0, i64 0, i64 %p1)
%t10921 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t10917)
%t10922 = call i64 @st64(i64 %t10914, i64 %t10921)
%t10923 = mul nsw i64 %t10922, 0
%t10924 = add nsw i64 %t10923, %t10914
ret i64 %t10924
}
define internal i64 @__mruntime_rt_map_resid__insert_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t10930, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t10925 = icmp sge i64 %p2, %p3
br i1 %t10925, label %L3346, label %L3348
L3346:
ret i64 0
L3348:
%t10926 = mul i64 %p2, 8
%t10927 = add i64 %p1, %t10926
%t10928 = call i64 @ld64(i64 %t10927)
%t10929 = call i64 @__mruntime_rt_map_resid__t_insert_new(i64 %p0, i64 %t10928, i64 1)
%t10930 = add nsw i64 %p2, 1
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t10937, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t10932 = icmp sge i64 %p3, %p4
br i1 %t10932, label %L3349, label %L3351
L3349:
ret i64 0
L3351:
%t10933 = mul i64 %p3, 8
%t10934 = add i64 %p2, %t10933
%t10935 = call i64 @ld64(i64 %t10934)
%t10936 = call i64 @__mruntime_rt_map_resid__t_put(i64 %p0, i64 %p1, i64 %t10935, i64 0, i64 1)
%t10937 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__set_put_all(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10939 = call i64 @__mruntime_rt_map_resid__set_words(i64 %p1)
%t10940 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p1)
%t10941 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t10942 = call i64 @__mruntime_rt_map_resid__put_owned_words(i64 %p0, i64 %t10940, i64 %t10939, i64 0, i64 %t10941)
%t10943 = call i64 @c_free(i64 %t10939)
%t10944 = mul nsw i64 %t10943, 0
%t10945 = add nsw i64 %t10944, %t10942
ret i64 %t10945
}
define internal i64 @__mruntime_rt_map_resid__put_owned_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t10950, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t10951, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t10946 = icmp sge i64 %p3, %p4
br i1 %t10946, label %L3352, label %L3354
L3352:
ret i64 %p0
L3354:
%t10947 = mul i64 %p3, 8
%t10948 = add i64 %p2, %t10947
%t10949 = call i64 @ld64(i64 %t10948)
%t10950 = call i64 @__mruntime_rt_map_resid__map_put_slow(i64 %p0, i64 1, i64 %p1, i64 %t10949, i64 0, i64 1)
%t10951 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_set_union(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t10953 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t10954 = icmp eq i64 %t10953, 0
br i1 %t10954, label %L3355, label %L3357
L3355:
ret i64 %p0
L3357:
%t10955 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10956 = icmp eq i64 %t10955, 0
br i1 %t10956, label %L3358, label %L3360
L3358:
ret i64 %p1
L3360:
%t10957 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t10958 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t10959 = icmp sge i64 %t10957, %t10958
br i1 %t10959, label %L3361, label %L3362
L3361:
br label %L3363
L3362:
br label %L3363
L3363:
%t10960 = phi i64 [ %p0, %L3361 ], [ %p1, %L3362 ]
%t10961 = icmp eq i64 %t10960, %p0
br i1 %t10961, label %L3364, label %L3365
L3364:
br label %L3366
L3365:
br label %L3366
L3366:
%t10962 = phi i64 [ %p1, %L3364 ], [ %p0, %L3365 ]
%t10963 = call i64 @__mruntime_rt_map_resid__mtab(i64 %t10960)
%t10964 = icmp eq i64 %t10963, 0
br label %LSL10965
LSL10965:
br i1 %t10964, label %LSR10965, label %LSJ10965
LSR10965:
%t10966 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t10962)
%t10967 = mul i64 %t10966, 8
%t10968 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t10960)
%t10969 = icmp slt i64 %t10967, %t10968
br label %LSJ10965
LSJ10965:
%t10970 = phi i1 [ false, %LSL10965 ], [ %t10969, %LSR10965 ]
br i1 %t10970, label %L3367, label %L3369
L3367:
%t10971 = call i64 @rt_map_transient(i64 %t10960)
%t10972 = call i64 @__mruntime_rt_map_resid__set_put_all(i64 %t10971, i64 %t10962)
%t10973 = call i64 @rt_map_freeze(i64 %t10972)
ret i64 %t10973
L3369:
%t10974 = sub nsw i64 0, 1
%t10975 = sub nsw i64 0, 1
%t10976 = call i64 @__mruntime_rt_map_resid__trie_new(i64 0, i64 0, i64 %t10974, i64 %t10975)
%t10977 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t10960)
%t10978 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t10962)
%t10979 = add i64 %t10977, %t10978
%t10980 = call i64 @__mruntime_rt_map_resid__cap_for(i64 %t10979)
%t10981 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %t10960)
%t10982 = call i64 @__mruntime_rt_map_resid__tab_new(i64 %t10980, i64 %t10981, i64 0, i1 true)
%t10983 = add i64 %t10976, 16
%t10984 = call i64 @st64(i64 %t10983, i64 %t10982)
%t10985 = call i64 @__mruntime_rt_map_resid__set_words(i64 %t10960)
%t10986 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t10960)
%t10987 = call i64 @__mruntime_rt_map_resid__insert_words(i64 %t10982, i64 %t10985, i64 0, i64 %t10986)
%t10988 = call i64 @__mruntime_rt_map_resid__set_words(i64 %t10962)
%t10989 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %t10962)
%t10990 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t10962)
%t10991 = call i64 @__mruntime_rt_map_resid__put_words(i64 %t10982, i64 %t10989, i64 %t10988, i64 0, i64 %t10990)
%t10992 = call i64 @c_free(i64 %t10985)
%t10993 = call i64 @c_free(i64 %t10988)
%t10994 = add i64 %t10992, %t10993
%t10995 = call i64 @__mruntime_rt_map_resid__tlive(i64 %t10982)
%t10996 = call i64 @st64(i64 %t10976, i64 %t10995)
%t10997 = mul nsw i64 %t10996, 0
%t10998 = add nsw i64 %t10997, %t10976
ret i64 %t10998
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
%t10999 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t11000 = icmp eq i64 %t10999, 0
br label %LSL11001
LSL11001:
br i1 %t11000, label %LSJ11001, label %LSR11001
LSR11001:
%t11002 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t11003 = icmp eq i64 %t11002, 0
br label %LSJ11001
LSJ11001:
%t11004 = phi i1 [ true, %LSL11001 ], [ %t11003, %LSR11001 ]
br i1 %t11004, label %L3370, label %L3372
L3370:
ret i64 %p0
L3372:
%t11005 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t11006 = mul i64 %t11005, 4
%t11007 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t11008 = icmp slt i64 %t11006, %t11007
br i1 %t11008, label %L3373, label %L3375
L3373:
%t11009 = call i64 @__mruntime_rt_map_resid__set_words(i64 %p1)
%t11010 = call i64 @rt_map_transient(i64 %p0)
%t11011 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p1)
%t11012 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t11013 = call i64 @__mruntime_rt_map_resid__del_words(i64 %t11010, i64 %t11011, i64 %t11009, i64 0, i64 %t11012)
%t11014 = call i64 @c_free(i64 %t11009)
%t11015 = mul nsw i64 %t11014, 0
%t11016 = call i64 @rt_map_freeze(i64 %t11013)
%t11017 = add nsw i64 %t11015, %t11016
ret i64 %t11017
L3375:
%t11018 = call i64 @__mruntime_rt_map_resid__set_words(i64 %p0)
%t11019 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t11020 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t11021 = call i64 @__mruntime_rt_map_resid__keep_words(i64 %t11018, i64 0, i64 0, i64 %t11019, i64 %p1, i64 %t11020, i1 false)
%t11022 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t11023 = icmp eq i64 %t11021, %t11022
br i1 %t11023, label %L3376, label %L3377
L3376:
br label %L3378
L3377:
%t11024 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %p0)
%t11025 = call i64 @__mruntime_rt_map_resid__set_of_words(i64 %t11018, i64 %t11021, i64 %t11024)
br label %L3378
L3378:
%t11026 = phi i64 [ %p0, %L3376 ], [ %t11025, %L3377 ]
%t11027 = call i64 @c_free(i64 %t11018)
%t11028 = mul nsw i64 %t11027, 0
%t11029 = add nsw i64 %t11028, %t11026
ret i64 %t11029
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
%p0 = phi i64 [ %p0.in, %entry ], [ %t11034, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t11035, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t11030 = icmp sge i64 %p3, %p4
br i1 %t11030, label %L3379, label %L3381
L3379:
ret i64 %p0
L3381:
%t11031 = mul i64 %p3, 8
%t11032 = add i64 %p2, %t11031
%t11033 = call i64 @ld64(i64 %t11032)
%t11034 = call i64 @rt_map_del(i64 %p0, i64 1, i64 %p1, i64 %t11033)
%t11035 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_map_resid__keep_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i1 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t11044, %tco.s0 ], [ %t11052, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t11050, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ], [ %p3, %tco.s1 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ], [ %p4, %tco.s1 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ], [ %p5, %tco.s1 ]
%p6 = phi i1 [ %p6.in, %entry ], [ %p6, %tco.s0 ], [ %p6, %tco.s1 ]
%t11037 = icmp sge i64 %p1, %p3
br i1 %t11037, label %L3382, label %L3384
L3382:
ret i64 %p2
L3384:
%t11038 = mul i64 %p1, 8
%t11039 = add i64 %p0, %t11038
%t11040 = call i64 @ld64(i64 %t11039)
%t11041 = call i64 @__mruntime_rt_map_resid__map_vref(i64 %p4, i64 %p5, i64 %t11040)
%t11042 = icmp ne i64 %t11041, 0
%t11043 = icmp eq i1 %t11042, %p6
br i1 %t11043, label %L3385, label %L3387
L3385:
%t11044 = add nsw i64 %p1, 1
%t11045 = mul i64 %p2, 8
%t11046 = add i64 %p0, %t11045
%t11047 = call i64 @st64(i64 %t11046, i64 %t11040)
%t11048 = mul nsw i64 %t11047, 0
%t11049 = add nsw i64 %t11048, %p2
%t11050 = add i64 %t11049, 1
br label %tco.s0
tco.s0:
br label %tco.head
L3387:
%t11052 = add nsw i64 %p1, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @rt_set_intersection(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11054 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t11055 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t11056 = icmp sle i64 %t11054, %t11055
br i1 %t11056, label %L3388, label %L3389
L3388:
br label %L3390
L3389:
br label %L3390
L3390:
%t11057 = phi i64 [ %p0, %L3388 ], [ %p1, %L3389 ]
%t11058 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t11059 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p1)
%t11060 = icmp sle i64 %t11058, %t11059
br i1 %t11060, label %L3391, label %L3392
L3391:
br label %L3393
L3392:
br label %L3393
L3393:
%t11061 = phi i64 [ %p1, %L3391 ], [ %p0, %L3392 ]
%t11062 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t11057)
%t11063 = icmp eq i64 %t11062, 0
br i1 %t11063, label %L3394, label %L3396
L3394:
ret i64 %t11057
L3396:
%t11064 = call i64 @__mruntime_rt_map_resid__set_words(i64 %t11057)
%t11065 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t11057)
%t11066 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %t11057)
%t11067 = call i64 @__mruntime_rt_map_resid__keep_words(i64 %t11064, i64 0, i64 0, i64 %t11065, i64 %t11061, i64 %t11066, i1 true)
%t11068 = call i64 @__mruntime_rt_map_resid__mcount(i64 %t11057)
%t11069 = icmp eq i64 %t11067, %t11068
br i1 %t11069, label %L3397, label %L3398
L3397:
br label %L3399
L3398:
%t11070 = call i64 @__mruntime_rt_map_resid__map_kk(i64 %t11057)
%t11071 = call i64 @__mruntime_rt_map_resid__set_of_words(i64 %t11064, i64 %t11067, i64 %t11070)
br label %L3399
L3399:
%t11072 = phi i64 [ %t11057, %L3397 ], [ %t11071, %L3398 ]
%t11073 = call i64 @c_free(i64 %t11064)
%t11074 = mul nsw i64 %t11073, 0
%t11075 = add nsw i64 %t11074, %t11072
ret i64 %t11075
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
%t11076 = tail call i64 @rt_map_keys(i64 %p0)
ret i64 %t11076
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
%t11077 = call i64 @rt_sb_new()
%t11078 = call i64 @__mruntime_rt_map_resid__mcount(i64 %p0)
%t11079 = icmp sgt i64 %t11078, 0
br i1 %t11079, label %L3400, label %L3401
L3400:
%t11080 = call i64 @__mruntime_rt_map_resid__boxed_entries(i64 %p0, i1 true)
br label %L3402
L3401:
br label %L3402
L3402:
%t11081 = phi i64 [ %t11080, %L3400 ], [ 0, %L3401 ]
%t11083 = ptrtoint ptr @.s11082 to i64
%t11084 = call i64 @sb_lit(i64 %t11077, i64 %t11083)
%t11085 = call i64 @__mruntime_rt_map_resid__sb_pairs(i64 %t11077, i64 %t11081, i64 0, i64 0, i64 %t11078)
%t11087 = ptrtoint ptr @.s11086 to i64
%t11088 = call i64 @sb_lit(i64 %t11077, i64 %t11087)
%t11089 = call i64 @c_free(i64 %t11081)
%t11090 = tail call i64 @rt_sb_finish(i64 %t11077)
ret i64 %t11090
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
%t11091 = icmp eq i64 %p0, 0
br label %LSL11092
LSL11092:
br i1 %t11091, label %LSJ11092, label %LSR11092
LSR11092:
%t11093 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t11094 = xor i1 %t11093, true
br label %LSJ11092
LSJ11092:
%t11095 = phi i1 [ true, %LSL11092 ], [ %t11094, %LSR11092 ]
br i1 %t11095, label %L3403, label %L3405
L3403:
ret i64 %p0
L3405:
%t11096 = call i64 @ld64(i64 %p0)
%t11097 = mul i64 %t11096, 8
%t11098 = add i64 8, %t11097
%t11099 = call i64 @c_outer_alloc(i64 %t11098)
%t11100 = call i64 @st64(i64 %t11099, i64 %t11096)
%t11101 = call i64 @__mruntime_rt_map_resid__keep_items(i64 %p0, i64 %t11099, i64 0, i64 %t11096, i64 %p1)
%t11102 = mul nsw i64 %t11101, 0
%t11103 = add nsw i64 %t11102, %t11099
ret i64 %t11103
}
define internal i64 @__mruntime_rt_map_resid__keep_items(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t11118, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t11104 = icmp sge i64 %p2, %p3
br i1 %t11104, label %L3406, label %L3408
L3406:
ret i64 0
L3408:
%t11105 = add i64 %p0, 8
%t11106 = mul i64 %p2, 8
%t11107 = add i64 %t11105, %t11106
%t11108 = call i64 @ld64(i64 %t11107)
%t11109 = add i64 %p1, 8
%t11110 = mul i64 %p2, 8
%t11111 = add i64 %t11109, %t11110
%t11112 = icmp sgt i64 %p4, 0
br i1 %t11112, label %L3409, label %L3410
L3409:
%t11113 = sub nsw i64 %p4, 5
%t11114 = call i64 @__mruntime_rt_map_resid__pvec_keep(i64 %t11108, i64 %t11113)
br label %L3411
L3410:
%t11115 = call i64 @__mruntime_rt_map_resid__elem_keep(i64 %t11108)
br label %L3411
L3411:
%t11116 = phi i64 [ %t11114, %L3409 ], [ %t11115, %L3410 ]
%t11117 = call i64 @st64(i64 %t11111, i64 %t11116)
%t11118 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_keep(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11120 = icmp eq i64 %p0, 0
br label %LSL11121
LSL11121:
br i1 %t11120, label %LSJ11121, label %LSR11121
LSR11121:
%t11122 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t11123 = icmp eq i64 %t11122, 0
br label %LSJ11121
LSJ11121:
%t11124 = phi i1 [ true, %LSL11121 ], [ %t11123, %LSR11121 ]
br i1 %t11124, label %L3412, label %L3414
L3412:
ret i64 %p0
L3414:
%t11125 = call i64 @lroot(i64 %p0)
%t11126 = call i64 @lcount(i64 %p0)
%t11127 = call i64 @lshift(i64 %p0)
%t11128 = sub nsw i64 0, 1
%t11129 = icmp eq i64 %t11127, %t11128
br label %LSL11130
LSL11130:
br i1 %t11129, label %LSR11130, label %LSJ11130
LSR11130:
%t11131 = icmp ne i64 %t11125, 0
br label %LSJ11130
LSJ11130:
%t11132 = phi i1 [ false, %LSL11130 ], [ %t11131, %LSR11130 ]
br i1 %t11132, label %L3415, label %L3416
L3415:
%t11133 = call i64 @__mruntime_rt_map_resid__flat_keep(i64 %t11125, i64 %t11126)
br label %L3417
L3416:
%t11134 = icmp ne i64 %t11125, 0
br i1 %t11134, label %L3418, label %L3419
L3418:
%t11135 = call i64 @lshift(i64 %p0)
%t11136 = call i64 @__mruntime_rt_map_resid__pvec_keep(i64 %t11125, i64 %t11135)
br label %L3420
L3419:
br label %L3420
L3420:
%t11137 = phi i64 [ %t11136, %L3418 ], [ %t11125, %L3419 ]
br label %L3417
L3417:
%t11138 = phi i64 [ %t11133, %L3415 ], [ %t11137, %L3420 ]
%t11139 = icmp eq i64 %t11138, %t11125
br label %LSL11140
LSL11140:
br i1 %t11139, label %LSR11140, label %LSJ11140
LSR11140:
%t11141 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t11142 = xor i1 %t11141, true
br label %LSJ11140
LSJ11140:
%t11143 = phi i1 [ false, %LSL11140 ], [ %t11142, %LSR11140 ]
br i1 %t11143, label %L3421, label %L3423
L3421:
ret i64 %p0
L3423:
%t11144 = call i64 @c_outer_alloc(i64 32)
%t11145 = call i64 @mcopy(i64 %t11144, i64 %p0, i64 32)
%t11146 = add i64 %t11144, 16
%t11147 = call i64 @st64(i64 %t11146, i64 %t11138)
%t11148 = mul nsw i64 %t11147, 0
%t11149 = add nsw i64 %t11148, %t11144
ret i64 %t11149
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
%t11150 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
br i1 %t11150, label %L3424, label %L3426
L3424:
%t11151 = add i64 %p0, 8
%t11152 = call i64 @ld64(i64 %t11151)
%t11153 = icmp sgt i64 %t11152, %p1
br i1 %t11153, label %L3427, label %L3428
L3427:
%t11154 = add i64 %p0, 8
%t11155 = call i64 @ld64(i64 %t11154)
br label %L3429
L3428:
%t11156 = icmp sgt i64 %p1, 1
br i1 %t11156, label %L3430, label %L3431
L3430:
br label %L3432
L3431:
br label %L3432
L3432:
%t11157 = phi i64 [ %p1, %L3430 ], [ 1, %L3431 ]
br label %L3429
L3429:
%t11158 = phi i64 [ %t11155, %L3427 ], [ %t11157, %L3432 ]
%t11159 = mul i64 %t11158, 8
%t11160 = add i64 24, %t11159
%t11161 = call i64 @c_outer_alloc(i64 %t11160)
%t11162 = call i64 @st64(i64 %t11161, i64 %p1)
%t11163 = add i64 %t11161, 8
%t11164 = call i64 @st64(i64 %t11163, i64 %t11158)
%t11165 = add i64 %t11162, %t11164
%t11166 = add i64 %t11161, 16
%t11167 = call i64 @st64(i64 %t11166, i64 %p1)
%t11168 = add i64 %t11165, %t11167
%t11169 = call i64 @__mruntime_rt_map_resid__keep_elems(i64 %p0, i64 %t11161, i64 0, i64 %p1)
%t11170 = mul nsw i64 %t11169, 0
%t11171 = add nsw i64 %t11170, %t11161
ret i64 %t11171
L3426:
%t11172 = add i64 %p0, 16
%t11173 = call i64 @ld64(i64 %t11172)
%t11174 = icmp slt i64 %t11173, %p1
br i1 %t11174, label %L3433, label %L3434
L3433:
%t11175 = call i64 @__mruntime_rt_map_resid__keep_elems(i64 %p0, i64 %p0, i64 %t11173, i64 %p1)
%t11176 = add i64 %p0, 16
%t11177 = call i64 @st64(i64 %t11176, i64 %p1)
%t11178 = add i64 %t11175, %t11177
br label %L3435
L3434:
br label %L3435
L3435:
%t11179 = phi i64 [ %t11178, %L3433 ], [ 0, %L3434 ]
ret i64 %p0
}
define internal i64 @__mruntime_rt_map_resid__keep_elems(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t11190, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t11180 = icmp sge i64 %p2, %p3
br i1 %t11180, label %L3436, label %L3438
L3436:
ret i64 0
L3438:
%t11181 = add i64 %p1, 24
%t11182 = mul i64 %p2, 8
%t11183 = add i64 %t11181, %t11182
%t11184 = add i64 %p0, 24
%t11185 = mul i64 %p2, 8
%t11186 = add i64 %t11184, %t11185
%t11187 = call i64 @ld64(i64 %t11186)
%t11188 = call i64 @__mruntime_rt_map_resid__elem_keep(i64 %t11187)
%t11189 = call i64 @st64(i64 %t11183, i64 %t11188)
%t11190 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_evac(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11192 = tail call i64 @rt_list_keep(i64 %p0)
ret i64 %t11192
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
%t11193 = icmp eq i64 %p0, 0
br label %LSL11194
LSL11194:
br i1 %t11193, label %LSJ11194, label %LSR11194
LSR11194:
%t11195 = icmp eq i64 %p1, 0
br label %LSJ11194
LSJ11194:
%t11196 = phi i1 [ true, %LSL11194 ], [ %t11195, %LSR11194 ]
br label %LSL11197
LSL11197:
br i1 %t11196, label %LSJ11197, label %LSR11197
LSR11197:
%t11198 = call i64 @c_in_arenas(i64 %p1)
%t11199 = icmp ne i64 %t11198, 0
br label %LSJ11197
LSJ11197:
%t11200 = phi i1 [ true, %LSL11197 ], [ %t11199, %LSR11197 ]
br i1 %t11200, label %L3439, label %L3441
L3439:
ret i64 0
L3441:
%t11201 = call i64 @c_free(i64 %p1)
ret i64 %t11201
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
%t11202 = icmp eq i64 %p0, 0
br label %LSL11203
LSL11203:
br i1 %t11202, label %LSJ11203, label %LSR11203
LSR11203:
%t11204 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t11205 = xor i1 %t11204, true
br label %LSJ11203
LSJ11203:
%t11206 = phi i1 [ true, %LSL11203 ], [ %t11205, %LSR11203 ]
br i1 %t11206, label %L3442, label %L3444
L3442:
ret i64 %p0
L3444:
%t11207 = call i64 @dn(i64 %p0)
%t11208 = mul i64 %t11207, 8
%t11209 = add i64 24, %t11208
%t11210 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t11211 = call i64 @c_sc_depth_set(i64 0)
%t11212 = call i64 @c_gmalloc(i64 %t11209)
%t11213 = call i64 @c_sc_depth_set(i64 %t11210)
%t11214 = call i64 @mcopy(i64 %t11212, i64 %p0, i64 %t11209)
%t11215 = mul nsw i64 %t11214, 0
%t11216 = add nsw i64 %t11215, %t11212
ret i64 %t11216
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
%t11217 = icmp eq i64 %p0, 0
br label %LSL11218
LSL11218:
br i1 %t11217, label %LSJ11218, label %LSR11218
LSR11218:
%t11219 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t11220 = xor i1 %t11219, true
br label %LSJ11218
LSJ11218:
%t11221 = phi i1 [ true, %LSL11218 ], [ %t11220, %LSR11218 ]
br i1 %t11221, label %L3445, label %L3447
L3445:
ret i64 %p0
L3447:
%t11222 = call i64 @__mruntime_rt_map_resid__node_nd(i64 %p0)
%t11223 = call i64 @__mruntime_rt_map_resid__node_nn(i64 %p0)
%t11224 = call i64 @__mruntime_rt_map_resid__ncap(i64 %p0)
%t11225 = mul i64 %t11224, 8
%t11226 = add i64 24, %t11225
%t11227 = call i64 @xmalloc(i64 %t11226)
%t11228 = mul i64 2, %t11222
%t11229 = add i64 %t11228, %t11223
%t11230 = mul i64 %t11229, 8
%t11231 = add i64 24, %t11230
%t11232 = call i64 @mcopy(i64 %t11227, i64 %p0, i64 %t11231)
%t11233 = call i64 @__mruntime_rt_map_resid__evac_pairs(i64 %t11227, i64 0, i64 %t11222, i64 %p1, i64 %p2)
%t11234 = call i64 @__mruntime_rt_map_resid__evac_subs(i64 %t11227, i64 %t11222, i64 0, i64 %t11223, i64 %p1, i64 %p2)
%t11235 = mul nsw i64 %t11234, 0
%t11236 = add nsw i64 %t11235, %t11227
ret i64 %t11236
}
define internal i64 @__mruntime_rt_map_resid__evac_pairs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t11250, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t11237 = icmp sge i64 %p1, %p2
br i1 %t11237, label %L3448, label %L3450
L3448:
ret i64 0
L3450:
%t11238 = mul i64 2, %p1
%t11239 = mul i64 2, %p1
%t11240 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t11239)
%t11241 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %p3, i64 %t11240)
%t11242 = call i64 @__mruntime_rt_map_resid__wset(i64 %p0, i64 %t11238, i64 %t11241)
%t11243 = mul i64 2, %p1
%t11244 = add i64 %t11243, 1
%t11245 = mul i64 2, %p1
%t11246 = add i64 %t11245, 1
%t11247 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t11246)
%t11248 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %p4, i64 %t11247)
%t11249 = call i64 @__mruntime_rt_map_resid__wset(i64 %p0, i64 %t11244, i64 %t11248)
%t11250 = add nsw i64 %p1, 1
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t11260, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t11252 = icmp sge i64 %p2, %p3
br i1 %t11252, label %L3451, label %L3453
L3451:
ret i64 0
L3453:
%t11253 = mul i64 2, %p1
%t11254 = add i64 %t11253, %p2
%t11255 = mul i64 2, %p1
%t11256 = add i64 %t11255, %p2
%t11257 = call i64 @__mruntime_rt_map_resid__wd(i64 %p0, i64 %t11256)
%t11258 = call i64 @__mruntime_rt_map_resid__hnode_evac(i64 %t11257, i64 %p4, i64 %p5)
%t11259 = call i64 @__mruntime_rt_map_resid__wset(i64 %p0, i64 %t11254, i64 %t11258)
%t11260 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_map_evac(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11262 = icmp eq i64 %p0, 0
br label %LSL11263
LSL11263:
br i1 %t11262, label %LSJ11263, label %LSR11263
LSR11263:
%t11264 = call i64 @__mruntime_rt_map_resid__sc_depth()
%t11265 = icmp eq i64 %t11264, 0
br label %LSJ11263
LSJ11263:
%t11266 = phi i1 [ true, %LSL11263 ], [ %t11265, %LSR11263 ]
br i1 %t11266, label %L3454, label %L3456
L3454:
ret i64 %p0
L3456:
%t11267 = call i64 @__mruntime_rt_map_resid__mtab(i64 %p0)
%t11268 = icmp ne i64 %t11267, 0
br i1 %t11268, label %L3457, label %L3458
L3457:
%t11269 = call i64 @__mruntime_rt_map_resid__tab_evac(i64 %t11267, i64 %p1, i64 %p2)
br label %L3459
L3458:
br label %L3459
L3459:
%t11270 = phi i64 [ %t11269, %L3457 ], [ 0, %L3458 ]
%t11271 = icmp ne i64 %t11267, 0
br i1 %t11271, label %L3460, label %L3461
L3460:
%t11272 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
br label %L3462
L3461:
%t11273 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t11274 = call i64 @__mruntime_rt_map_resid__hnode_evac(i64 %t11273, i64 %p1, i64 %p2)
br label %L3462
L3462:
%t11275 = phi i64 [ %t11272, %L3460 ], [ %t11274, %L3461 ]
%t11276 = icmp eq i64 %t11270, %t11267
br label %LSL11277
LSL11277:
br i1 %t11276, label %LSR11277, label %LSJ11277
LSR11277:
%t11278 = call i64 @__mruntime_rt_map_resid__mroot(i64 %p0)
%t11279 = icmp eq i64 %t11275, %t11278
br label %LSJ11277
LSJ11277:
%t11280 = phi i1 [ false, %LSL11277 ], [ %t11279, %LSR11277 ]
br label %LSL11281
LSL11281:
br i1 %t11280, label %LSR11281, label %LSJ11281
LSR11281:
%t11282 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t11283 = xor i1 %t11282, true
br label %LSJ11281
LSJ11281:
%t11284 = phi i1 [ false, %LSL11281 ], [ %t11283, %LSR11281 ]
br i1 %t11284, label %L3463, label %L3465
L3463:
ret i64 %p0
L3465:
%t11285 = call i64 @xmalloc(i64 48)
%t11286 = call i64 @mcopy(i64 %t11285, i64 %p0, i64 48)
%t11287 = add i64 %t11285, 16
%t11288 = call i64 @st64(i64 %t11287, i64 %t11270)
%t11289 = add i64 %t11285, 8
%t11290 = call i64 @st64(i64 %t11289, i64 %t11275)
%t11291 = mul nsw i64 %t11290, 0
%t11292 = add nsw i64 %t11291, %t11285
ret i64 %t11292
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
%t11293 = call i1 @__mruntime_rt_map_resid__in_region(i64 %p0)
%t11294 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t11295 = icmp ne i64 %t11294, 0
br label %LSL11296
LSL11296:
br i1 %t11295, label %LSR11296, label %LSJ11296
LSR11296:
%t11297 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t11298 = call i1 @__mruntime_rt_map_resid__in_region(i64 %t11297)
br label %LSJ11296
LSJ11296:
%t11299 = phi i1 [ false, %LSL11296 ], [ %t11298, %LSR11296 ]
%t11300 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t11301 = icmp ne i64 %t11300, 0
br label %LSL11302
LSL11302:
br i1 %t11301, label %LSR11302, label %LSJ11302
LSR11302:
%t11303 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t11304 = call i1 @__mruntime_rt_map_resid__in_region(i64 %t11303)
br label %LSJ11302
LSJ11302:
%t11305 = phi i1 [ false, %LSL11302 ], [ %t11304, %LSR11302 ]
%t11306 = xor i1 %t11293, true
br label %LSL11307
LSL11307:
br i1 %t11306, label %LSR11307, label %LSJ11307
LSR11307:
%t11308 = xor i1 %t11299, true
br label %LSJ11307
LSJ11307:
%t11309 = phi i1 [ false, %LSL11307 ], [ %t11308, %LSR11307 ]
br label %LSL11310
LSL11310:
br i1 %t11309, label %LSR11310, label %LSJ11310
LSR11310:
%t11311 = xor i1 %t11305, true
br label %LSJ11310
LSJ11310:
%t11312 = phi i1 [ false, %LSL11310 ], [ %t11311, %LSR11310 ]
br i1 %t11312, label %L3466, label %L3468
L3466:
ret i64 %p0
L3468:
%t11313 = call i64 @xmalloc(i64 96)
%t11314 = call i64 @mcopy(i64 %t11313, i64 %p0, i64 96)
br i1 %t11299, label %L3469, label %L3470
L3469:
%t11315 = add i64 %t11313, 32
%t11316 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t11317 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t11318 = call i64 @__mruntime_rt_map_resid__dup_words(i64 %t11316, i64 %t11317)
%t11319 = call i64 @st64(i64 %t11315, i64 %t11318)
br label %L3471
L3470:
br label %L3471
L3471:
%t11320 = phi i64 [ %t11319, %L3469 ], [ 0, %L3470 ]
br i1 %t11305, label %L3472, label %L3473
L3472:
%t11321 = add i64 %t11313, 40
%t11322 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t11323 = call i64 @__mruntime_rt_map_resid__tcap(i64 %p0)
%t11324 = call i64 @__mruntime_rt_map_resid__dup_words(i64 %t11322, i64 %t11323)
%t11325 = call i64 @st64(i64 %t11321, i64 %t11324)
br label %L3474
L3473:
br label %L3474
L3474:
%t11326 = phi i64 [ %t11325, %L3472 ], [ 0, %L3473 ]
%t11327 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %t11313)
%t11328 = icmp ne i64 %t11327, 0
br label %LSL11329
LSL11329:
br i1 %t11328, label %LSR11329, label %LSJ11329
LSR11329:
%t11330 = icmp eq i64 %p1, 4
br label %LSL11331
LSL11331:
br i1 %t11330, label %LSJ11331, label %LSR11331
LSR11331:
%t11332 = icmp sge i64 %p2, 4
br label %LSL11333
LSL11333:
br i1 %t11332, label %LSR11333, label %LSJ11333
LSR11333:
%t11334 = call i64 @__mruntime_rt_map_resid__tvals(i64 %t11313)
%t11335 = icmp ne i64 %t11334, 0
br label %LSJ11333
LSJ11333:
%t11336 = phi i1 [ false, %LSL11333 ], [ %t11335, %LSR11333 ]
br label %LSJ11331
LSJ11331:
%t11337 = phi i1 [ true, %LSL11331 ], [ %t11336, %LSJ11333 ]
br label %LSJ11329
LSJ11329:
%t11338 = phi i1 [ false, %LSL11329 ], [ %t11337, %LSJ11331 ]
br i1 %t11338, label %L3475, label %L3476
L3475:
%t11339 = call i64 @__mruntime_rt_map_resid__tcap(i64 %t11313)
br label %LSL11340
LSL11340:
br i1 %t11299, label %LSR11340, label %LSJ11340
LSR11340:
%t11341 = icmp eq i64 %p1, 4
br label %LSJ11340
LSJ11340:
%t11342 = phi i1 [ false, %LSL11340 ], [ %t11341, %LSR11340 ]
br label %LSL11343
LSL11343:
br i1 %t11305, label %LSR11343, label %LSJ11343
LSR11343:
%t11344 = icmp sge i64 %p2, 4
br label %LSJ11343
LSJ11343:
%t11345 = phi i1 [ false, %LSL11343 ], [ %t11344, %LSR11343 ]
%t11346 = call i64 @__mruntime_rt_map_resid__keep_slots(i64 %t11313, i64 0, i64 %t11339, i1 %t11342, i1 %t11345, i64 %p2)
br label %L3477
L3476:
br label %L3477
L3477:
%t11347 = phi i64 [ %t11346, %LSJ11343 ], [ 0, %L3476 ]
ret i64 %t11313
}
define internal i64 @__mruntime_rt_map_resid__dup_words(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t11348 = mul i64 %p1, 8
%t11349 = call i64 @xmalloc(i64 %t11348)
%t11350 = mul i64 %p1, 8
%t11351 = call i64 @mcopy(i64 %t11349, i64 %p0, i64 %t11350)
%t11352 = mul nsw i64 %t11351, 0
%t11353 = add nsw i64 %t11352, %t11349
ret i64 %t11353
}
define internal i64 @__mruntime_rt_map_resid__keep_slots(i64 %p0.in, i64 %p1.in, i64 %p2.in, i1 %p3.in, i1 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t11385, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i1 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i1 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t11354 = icmp sge i64 %p1, %p2
br i1 %t11354, label %L3478, label %L3480
L3478:
ret i64 0
L3480:
%t11355 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t11356 = mul i64 %p1, 8
%t11357 = add i64 %t11355, %t11356
%t11358 = call i64 @ld64(i64 %t11357)
%t11359 = call i64 @__mruntime_rt_map_resid__t_empty(i64 %p0)
%t11360 = icmp ne i64 %t11358, %t11359
br label %LSL11361
LSL11361:
br i1 %t11360, label %LSR11361, label %LSJ11361
LSR11361:
%t11362 = call i64 @__mruntime_rt_map_resid__t_tomb(i64 %p0)
%t11363 = icmp ne i64 %t11358, %t11362
br label %LSJ11361
LSJ11361:
%t11364 = phi i1 [ false, %LSL11361 ], [ %t11363, %LSR11361 ]
br label %LSL11365
LSL11365:
br i1 %t11364, label %LSR11365, label %LSJ11365
LSR11365:
br label %LSJ11365
LSJ11365:
%t11366 = phi i1 [ false, %LSL11365 ], [ %p3, %LSR11365 ]
br i1 %t11366, label %L3481, label %L3482
L3481:
%t11367 = call i64 @__mruntime_rt_map_resid__tkeys(i64 %p0)
%t11368 = mul i64 %p1, 8
%t11369 = add i64 %t11367, %t11368
%t11370 = call i64 @__mruntime_rt_map_resid__word_keep(i64 4, i64 %t11358)
%t11371 = call i64 @st64(i64 %t11369, i64 %t11370)
br label %L3483
L3482:
br label %L3483
L3483:
%t11372 = phi i64 [ %t11371, %L3481 ], [ 0, %L3482 ]
br label %LSL11373
LSL11373:
br i1 %t11364, label %LSR11373, label %LSJ11373
LSR11373:
br label %LSJ11373
LSJ11373:
%t11374 = phi i1 [ false, %LSL11373 ], [ %p4, %LSR11373 ]
br i1 %t11374, label %L3484, label %L3485
L3484:
%t11375 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t11376 = mul i64 %p1, 8
%t11377 = add i64 %t11375, %t11376
%t11378 = call i64 @__mruntime_rt_map_resid__tvals(i64 %p0)
%t11379 = mul i64 %p1, 8
%t11380 = add i64 %t11378, %t11379
%t11381 = call i64 @ld64(i64 %t11380)
%t11382 = call i64 @__mruntime_rt_map_resid__word_keep(i64 %p5, i64 %t11381)
%t11383 = call i64 @st64(i64 %t11377, i64 %t11382)
br label %L3486
L3485:
br label %L3486
L3486:
%t11384 = phi i64 [ %t11383, %L3484 ], [ 0, %L3485 ]
%t11385 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
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
declare ptr @resid_rt_alloc(i64)
declare i8 @resid_rt_arena_contains(ptr)
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
declare i8 @resid_rt_box_interned(ptr)
declare i64 @resid_rt_sc_depth()
declare void @resid_rt_sc_depth_set(i64)
declare i8 @resid_rt_in_scope(ptr)
declare ptr @resid_rt_scope_alloc(i64)
declare ptr @resid_rt_outer_alloc(i64)
declare void @resid_rt_suspend(ptr)
declare void @resid_rt_resume(ptr)
declare i8 @resid_rt_in_arenas(ptr)
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
@rtt.8581 = private unnamed_addr constant [2918 x i64] [i64 65, i64 97, i64 66, i64 98, i64 67, i64 99, i64 68, i64 100, i64 69, i64 101, i64 70, i64 102, i64 71, i64 103, i64 72, i64 104, i64 73, i64 105, i64 74, i64 106, i64 75, i64 107, i64 76, i64 108, i64 77, i64 109, i64 78, i64 110, i64 79, i64 111, i64 80, i64 112, i64 81, i64 113, i64 82, i64 114, i64 83, i64 115, i64 84, i64 116, i64 85, i64 117, i64 86, i64 118, i64 87, i64 119, i64 88, i64 120, i64 89, i64 121, i64 90, i64 122, i64 192, i64 224, i64 193, i64 225, i64 194, i64 226, i64 195, i64 227, i64 196, i64 228, i64 197, i64 229, i64 198, i64 230, i64 199, i64 231, i64 200, i64 232, i64 201, i64 233, i64 202, i64 234, i64 203, i64 235, i64 204, i64 236, i64 205, i64 237, i64 206, i64 238, i64 207, i64 239, i64 208, i64 240, i64 209, i64 241, i64 210, i64 242, i64 211, i64 243, i64 212, i64 244, i64 213, i64 245, i64 214, i64 246, i64 216, i64 248, i64 217, i64 249, i64 218, i64 250, i64 219, i64 251, i64 220, i64 252, i64 221, i64 253, i64 222, i64 254, i64 256, i64 257, i64 258, i64 259, i64 260, i64 261, i64 262, i64 263, i64 264, i64 265, i64 266, i64 267, i64 268, i64 269, i64 270, i64 271, i64 272, i64 273, i64 274, i64 275, i64 276, i64 277, i64 278, i64 279, i64 280, i64 281, i64 282, i64 283, i64 284, i64 285, i64 286, i64 287, i64 288, i64 289, i64 290, i64 291, i64 292, i64 293, i64 294, i64 295, i64 296, i64 297, i64 298, i64 299, i64 300, i64 301, i64 302, i64 303, i64 306, i64 307, i64 308, i64 309, i64 310, i64 311, i64 313, i64 314, i64 315, i64 316, i64 317, i64 318, i64 319, i64 320, i64 321, i64 322, i64 323, i64 324, i64 325, i64 326, i64 327, i64 328, i64 330, i64 331, i64 332, i64 333, i64 334, i64 335, i64 336, i64 337, i64 338, i64 339, i64 340, i64 341, i64 342, i64 343, i64 344, i64 345, i64 346, i64 347, i64 348, i64 349, i64 350, i64 351, i64 352, i64 353, i64 354, i64 355, i64 356, i64 357, i64 358, i64 359, i64 360, i64 361, i64 362, i64 363, i64 364, i64 365, i64 366, i64 367, i64 368, i64 369, i64 370, i64 371, i64 372, i64 373, i64 374, i64 375, i64 376, i64 255, i64 377, i64 378, i64 379, i64 380, i64 381, i64 382, i64 385, i64 595, i64 386, i64 387, i64 388, i64 389, i64 390, i64 596, i64 391, i64 392, i64 393, i64 598, i64 394, i64 599, i64 395, i64 396, i64 398, i64 477, i64 399, i64 601, i64 400, i64 603, i64 401, i64 402, i64 403, i64 608, i64 404, i64 611, i64 406, i64 617, i64 407, i64 616, i64 408, i64 409, i64 412, i64 623, i64 413, i64 626, i64 415, i64 629, i64 416, i64 417, i64 418, i64 419, i64 420, i64 421, i64 422, i64 640, i64 423, i64 424, i64 425, i64 643, i64 428, i64 429, i64 430, i64 648, i64 431, i64 432, i64 433, i64 650, i64 434, i64 651, i64 435, i64 436, i64 437, i64 438, i64 439, i64 658, i64 440, i64 441, i64 444, i64 445, i64 452, i64 454, i64 453, i64 454, i64 455, i64 457, i64 456, i64 457, i64 458, i64 460, i64 459, i64 460, i64 461, i64 462, i64 463, i64 464, i64 465, i64 466, i64 467, i64 468, i64 469, i64 470, i64 471, i64 472, i64 473, i64 474, i64 475, i64 476, i64 478, i64 479, i64 480, i64 481, i64 482, i64 483, i64 484, i64 485, i64 486, i64 487, i64 488, i64 489, i64 490, i64 491, i64 492, i64 493, i64 494, i64 495, i64 497, i64 499, i64 498, i64 499, i64 500, i64 501, i64 502, i64 405, i64 503, i64 447, i64 504, i64 505, i64 506, i64 507, i64 508, i64 509, i64 510, i64 511, i64 512, i64 513, i64 514, i64 515, i64 516, i64 517, i64 518, i64 519, i64 520, i64 521, i64 522, i64 523, i64 524, i64 525, i64 526, i64 527, i64 528, i64 529, i64 530, i64 531, i64 532, i64 533, i64 534, i64 535, i64 536, i64 537, i64 538, i64 539, i64 540, i64 541, i64 542, i64 543, i64 544, i64 414, i64 546, i64 547, i64 548, i64 549, i64 550, i64 551, i64 552, i64 553, i64 554, i64 555, i64 556, i64 557, i64 558, i64 559, i64 560, i64 561, i64 562, i64 563, i64 570, i64 11365, i64 571, i64 572, i64 573, i64 410, i64 574, i64 11366, i64 577, i64 578, i64 579, i64 384, i64 580, i64 649, i64 581, i64 652, i64 582, i64 583, i64 584, i64 585, i64 586, i64 587, i64 588, i64 589, i64 590, i64 591, i64 880, i64 881, i64 882, i64 883, i64 886, i64 887, i64 895, i64 1011, i64 902, i64 940, i64 904, i64 941, i64 905, i64 942, i64 906, i64 943, i64 908, i64 972, i64 910, i64 973, i64 911, i64 974, i64 913, i64 945, i64 914, i64 946, i64 915, i64 947, i64 916, i64 948, i64 917, i64 949, i64 918, i64 950, i64 919, i64 951, i64 920, i64 952, i64 921, i64 953, i64 922, i64 954, i64 923, i64 955, i64 924, i64 956, i64 925, i64 957, i64 926, i64 958, i64 927, i64 959, i64 928, i64 960, i64 929, i64 961, i64 931, i64 963, i64 932, i64 964, i64 933, i64 965, i64 934, i64 966, i64 935, i64 967, i64 936, i64 968, i64 937, i64 969, i64 938, i64 970, i64 939, i64 971, i64 975, i64 983, i64 984, i64 985, i64 986, i64 987, i64 988, i64 989, i64 990, i64 991, i64 992, i64 993, i64 994, i64 995, i64 996, i64 997, i64 998, i64 999, i64 1000, i64 1001, i64 1002, i64 1003, i64 1004, i64 1005, i64 1006, i64 1007, i64 1012, i64 952, i64 1015, i64 1016, i64 1017, i64 1010, i64 1018, i64 1019, i64 1021, i64 891, i64 1022, i64 892, i64 1023, i64 893, i64 1024, i64 1104, i64 1025, i64 1105, i64 1026, i64 1106, i64 1027, i64 1107, i64 1028, i64 1108, i64 1029, i64 1109, i64 1030, i64 1110, i64 1031, i64 1111, i64 1032, i64 1112, i64 1033, i64 1113, i64 1034, i64 1114, i64 1035, i64 1115, i64 1036, i64 1116, i64 1037, i64 1117, i64 1038, i64 1118, i64 1039, i64 1119, i64 1040, i64 1072, i64 1041, i64 1073, i64 1042, i64 1074, i64 1043, i64 1075, i64 1044, i64 1076, i64 1045, i64 1077, i64 1046, i64 1078, i64 1047, i64 1079, i64 1048, i64 1080, i64 1049, i64 1081, i64 1050, i64 1082, i64 1051, i64 1083, i64 1052, i64 1084, i64 1053, i64 1085, i64 1054, i64 1086, i64 1055, i64 1087, i64 1056, i64 1088, i64 1057, i64 1089, i64 1058, i64 1090, i64 1059, i64 1091, i64 1060, i64 1092, i64 1061, i64 1093, i64 1062, i64 1094, i64 1063, i64 1095, i64 1064, i64 1096, i64 1065, i64 1097, i64 1066, i64 1098, i64 1067, i64 1099, i64 1068, i64 1100, i64 1069, i64 1101, i64 1070, i64 1102, i64 1071, i64 1103, i64 1120, i64 1121, i64 1122, i64 1123, i64 1124, i64 1125, i64 1126, i64 1127, i64 1128, i64 1129, i64 1130, i64 1131, i64 1132, i64 1133, i64 1134, i64 1135, i64 1136, i64 1137, i64 1138, i64 1139, i64 1140, i64 1141, i64 1142, i64 1143, i64 1144, i64 1145, i64 1146, i64 1147, i64 1148, i64 1149, i64 1150, i64 1151, i64 1152, i64 1153, i64 1162, i64 1163, i64 1164, i64 1165, i64 1166, i64 1167, i64 1168, i64 1169, i64 1170, i64 1171, i64 1172, i64 1173, i64 1174, i64 1175, i64 1176, i64 1177, i64 1178, i64 1179, i64 1180, i64 1181, i64 1182, i64 1183, i64 1184, i64 1185, i64 1186, i64 1187, i64 1188, i64 1189, i64 1190, i64 1191, i64 1192, i64 1193, i64 1194, i64 1195, i64 1196, i64 1197, i64 1198, i64 1199, i64 1200, i64 1201, i64 1202, i64 1203, i64 1204, i64 1205, i64 1206, i64 1207, i64 1208, i64 1209, i64 1210, i64 1211, i64 1212, i64 1213, i64 1214, i64 1215, i64 1216, i64 1231, i64 1217, i64 1218, i64 1219, i64 1220, i64 1221, i64 1222, i64 1223, i64 1224, i64 1225, i64 1226, i64 1227, i64 1228, i64 1229, i64 1230, i64 1232, i64 1233, i64 1234, i64 1235, i64 1236, i64 1237, i64 1238, i64 1239, i64 1240, i64 1241, i64 1242, i64 1243, i64 1244, i64 1245, i64 1246, i64 1247, i64 1248, i64 1249, i64 1250, i64 1251, i64 1252, i64 1253, i64 1254, i64 1255, i64 1256, i64 1257, i64 1258, i64 1259, i64 1260, i64 1261, i64 1262, i64 1263, i64 1264, i64 1265, i64 1266, i64 1267, i64 1268, i64 1269, i64 1270, i64 1271, i64 1272, i64 1273, i64 1274, i64 1275, i64 1276, i64 1277, i64 1278, i64 1279, i64 1280, i64 1281, i64 1282, i64 1283, i64 1284, i64 1285, i64 1286, i64 1287, i64 1288, i64 1289, i64 1290, i64 1291, i64 1292, i64 1293, i64 1294, i64 1295, i64 1296, i64 1297, i64 1298, i64 1299, i64 1300, i64 1301, i64 1302, i64 1303, i64 1304, i64 1305, i64 1306, i64 1307, i64 1308, i64 1309, i64 1310, i64 1311, i64 1312, i64 1313, i64 1314, i64 1315, i64 1316, i64 1317, i64 1318, i64 1319, i64 1320, i64 1321, i64 1322, i64 1323, i64 1324, i64 1325, i64 1326, i64 1327, i64 1329, i64 1377, i64 1330, i64 1378, i64 1331, i64 1379, i64 1332, i64 1380, i64 1333, i64 1381, i64 1334, i64 1382, i64 1335, i64 1383, i64 1336, i64 1384, i64 1337, i64 1385, i64 1338, i64 1386, i64 1339, i64 1387, i64 1340, i64 1388, i64 1341, i64 1389, i64 1342, i64 1390, i64 1343, i64 1391, i64 1344, i64 1392, i64 1345, i64 1393, i64 1346, i64 1394, i64 1347, i64 1395, i64 1348, i64 1396, i64 1349, i64 1397, i64 1350, i64 1398, i64 1351, i64 1399, i64 1352, i64 1400, i64 1353, i64 1401, i64 1354, i64 1402, i64 1355, i64 1403, i64 1356, i64 1404, i64 1357, i64 1405, i64 1358, i64 1406, i64 1359, i64 1407, i64 1360, i64 1408, i64 1361, i64 1409, i64 1362, i64 1410, i64 1363, i64 1411, i64 1364, i64 1412, i64 1365, i64 1413, i64 1366, i64 1414, i64 4256, i64 11520, i64 4257, i64 11521, i64 4258, i64 11522, i64 4259, i64 11523, i64 4260, i64 11524, i64 4261, i64 11525, i64 4262, i64 11526, i64 4263, i64 11527, i64 4264, i64 11528, i64 4265, i64 11529, i64 4266, i64 11530, i64 4267, i64 11531, i64 4268, i64 11532, i64 4269, i64 11533, i64 4270, i64 11534, i64 4271, i64 11535, i64 4272, i64 11536, i64 4273, i64 11537, i64 4274, i64 11538, i64 4275, i64 11539, i64 4276, i64 11540, i64 4277, i64 11541, i64 4278, i64 11542, i64 4279, i64 11543, i64 4280, i64 11544, i64 4281, i64 11545, i64 4282, i64 11546, i64 4283, i64 11547, i64 4284, i64 11548, i64 4285, i64 11549, i64 4286, i64 11550, i64 4287, i64 11551, i64 4288, i64 11552, i64 4289, i64 11553, i64 4290, i64 11554, i64 4291, i64 11555, i64 4292, i64 11556, i64 4293, i64 11557, i64 4295, i64 11559, i64 4301, i64 11565, i64 5024, i64 43888, i64 5025, i64 43889, i64 5026, i64 43890, i64 5027, i64 43891, i64 5028, i64 43892, i64 5029, i64 43893, i64 5030, i64 43894, i64 5031, i64 43895, i64 5032, i64 43896, i64 5033, i64 43897, i64 5034, i64 43898, i64 5035, i64 43899, i64 5036, i64 43900, i64 5037, i64 43901, i64 5038, i64 43902, i64 5039, i64 43903, i64 5040, i64 43904, i64 5041, i64 43905, i64 5042, i64 43906, i64 5043, i64 43907, i64 5044, i64 43908, i64 5045, i64 43909, i64 5046, i64 43910, i64 5047, i64 43911, i64 5048, i64 43912, i64 5049, i64 43913, i64 5050, i64 43914, i64 5051, i64 43915, i64 5052, i64 43916, i64 5053, i64 43917, i64 5054, i64 43918, i64 5055, i64 43919, i64 5056, i64 43920, i64 5057, i64 43921, i64 5058, i64 43922, i64 5059, i64 43923, i64 5060, i64 43924, i64 5061, i64 43925, i64 5062, i64 43926, i64 5063, i64 43927, i64 5064, i64 43928, i64 5065, i64 43929, i64 5066, i64 43930, i64 5067, i64 43931, i64 5068, i64 43932, i64 5069, i64 43933, i64 5070, i64 43934, i64 5071, i64 43935, i64 5072, i64 43936, i64 5073, i64 43937, i64 5074, i64 43938, i64 5075, i64 43939, i64 5076, i64 43940, i64 5077, i64 43941, i64 5078, i64 43942, i64 5079, i64 43943, i64 5080, i64 43944, i64 5081, i64 43945, i64 5082, i64 43946, i64 5083, i64 43947, i64 5084, i64 43948, i64 5085, i64 43949, i64 5086, i64 43950, i64 5087, i64 43951, i64 5088, i64 43952, i64 5089, i64 43953, i64 5090, i64 43954, i64 5091, i64 43955, i64 5092, i64 43956, i64 5093, i64 43957, i64 5094, i64 43958, i64 5095, i64 43959, i64 5096, i64 43960, i64 5097, i64 43961, i64 5098, i64 43962, i64 5099, i64 43963, i64 5100, i64 43964, i64 5101, i64 43965, i64 5102, i64 43966, i64 5103, i64 43967, i64 5104, i64 5112, i64 5105, i64 5113, i64 5106, i64 5114, i64 5107, i64 5115, i64 5108, i64 5116, i64 5109, i64 5117, i64 7305, i64 7306, i64 7312, i64 4304, i64 7313, i64 4305, i64 7314, i64 4306, i64 7315, i64 4307, i64 7316, i64 4308, i64 7317, i64 4309, i64 7318, i64 4310, i64 7319, i64 4311, i64 7320, i64 4312, i64 7321, i64 4313, i64 7322, i64 4314, i64 7323, i64 4315, i64 7324, i64 4316, i64 7325, i64 4317, i64 7326, i64 4318, i64 7327, i64 4319, i64 7328, i64 4320, i64 7329, i64 4321, i64 7330, i64 4322, i64 7331, i64 4323, i64 7332, i64 4324, i64 7333, i64 4325, i64 7334, i64 4326, i64 7335, i64 4327, i64 7336, i64 4328, i64 7337, i64 4329, i64 7338, i64 4330, i64 7339, i64 4331, i64 7340, i64 4332, i64 7341, i64 4333, i64 7342, i64 4334, i64 7343, i64 4335, i64 7344, i64 4336, i64 7345, i64 4337, i64 7346, i64 4338, i64 7347, i64 4339, i64 7348, i64 4340, i64 7349, i64 4341, i64 7350, i64 4342, i64 7351, i64 4343, i64 7352, i64 4344, i64 7353, i64 4345, i64 7354, i64 4346, i64 7357, i64 4349, i64 7358, i64 4350, i64 7359, i64 4351, i64 7680, i64 7681, i64 7682, i64 7683, i64 7684, i64 7685, i64 7686, i64 7687, i64 7688, i64 7689, i64 7690, i64 7691, i64 7692, i64 7693, i64 7694, i64 7695, i64 7696, i64 7697, i64 7698, i64 7699, i64 7700, i64 7701, i64 7702, i64 7703, i64 7704, i64 7705, i64 7706, i64 7707, i64 7708, i64 7709, i64 7710, i64 7711, i64 7712, i64 7713, i64 7714, i64 7715, i64 7716, i64 7717, i64 7718, i64 7719, i64 7720, i64 7721, i64 7722, i64 7723, i64 7724, i64 7725, i64 7726, i64 7727, i64 7728, i64 7729, i64 7730, i64 7731, i64 7732, i64 7733, i64 7734, i64 7735, i64 7736, i64 7737, i64 7738, i64 7739, i64 7740, i64 7741, i64 7742, i64 7743, i64 7744, i64 7745, i64 7746, i64 7747, i64 7748, i64 7749, i64 7750, i64 7751, i64 7752, i64 7753, i64 7754, i64 7755, i64 7756, i64 7757, i64 7758, i64 7759, i64 7760, i64 7761, i64 7762, i64 7763, i64 7764, i64 7765, i64 7766, i64 7767, i64 7768, i64 7769, i64 7770, i64 7771, i64 7772, i64 7773, i64 7774, i64 7775, i64 7776, i64 7777, i64 7778, i64 7779, i64 7780, i64 7781, i64 7782, i64 7783, i64 7784, i64 7785, i64 7786, i64 7787, i64 7788, i64 7789, i64 7790, i64 7791, i64 7792, i64 7793, i64 7794, i64 7795, i64 7796, i64 7797, i64 7798, i64 7799, i64 7800, i64 7801, i64 7802, i64 7803, i64 7804, i64 7805, i64 7806, i64 7807, i64 7808, i64 7809, i64 7810, i64 7811, i64 7812, i64 7813, i64 7814, i64 7815, i64 7816, i64 7817, i64 7818, i64 7819, i64 7820, i64 7821, i64 7822, i64 7823, i64 7824, i64 7825, i64 7826, i64 7827, i64 7828, i64 7829, i64 7838, i64 223, i64 7840, i64 7841, i64 7842, i64 7843, i64 7844, i64 7845, i64 7846, i64 7847, i64 7848, i64 7849, i64 7850, i64 7851, i64 7852, i64 7853, i64 7854, i64 7855, i64 7856, i64 7857, i64 7858, i64 7859, i64 7860, i64 7861, i64 7862, i64 7863, i64 7864, i64 7865, i64 7866, i64 7867, i64 7868, i64 7869, i64 7870, i64 7871, i64 7872, i64 7873, i64 7874, i64 7875, i64 7876, i64 7877, i64 7878, i64 7879, i64 7880, i64 7881, i64 7882, i64 7883, i64 7884, i64 7885, i64 7886, i64 7887, i64 7888, i64 7889, i64 7890, i64 7891, i64 7892, i64 7893, i64 7894, i64 7895, i64 7896, i64 7897, i64 7898, i64 7899, i64 7900, i64 7901, i64 7902, i64 7903, i64 7904, i64 7905, i64 7906, i64 7907, i64 7908, i64 7909, i64 7910, i64 7911, i64 7912, i64 7913, i64 7914, i64 7915, i64 7916, i64 7917, i64 7918, i64 7919, i64 7920, i64 7921, i64 7922, i64 7923, i64 7924, i64 7925, i64 7926, i64 7927, i64 7928, i64 7929, i64 7930, i64 7931, i64 7932, i64 7933, i64 7934, i64 7935, i64 7944, i64 7936, i64 7945, i64 7937, i64 7946, i64 7938, i64 7947, i64 7939, i64 7948, i64 7940, i64 7949, i64 7941, i64 7950, i64 7942, i64 7951, i64 7943, i64 7960, i64 7952, i64 7961, i64 7953, i64 7962, i64 7954, i64 7963, i64 7955, i64 7964, i64 7956, i64 7965, i64 7957, i64 7976, i64 7968, i64 7977, i64 7969, i64 7978, i64 7970, i64 7979, i64 7971, i64 7980, i64 7972, i64 7981, i64 7973, i64 7982, i64 7974, i64 7983, i64 7975, i64 7992, i64 7984, i64 7993, i64 7985, i64 7994, i64 7986, i64 7995, i64 7987, i64 7996, i64 7988, i64 7997, i64 7989, i64 7998, i64 7990, i64 7999, i64 7991, i64 8008, i64 8000, i64 8009, i64 8001, i64 8010, i64 8002, i64 8011, i64 8003, i64 8012, i64 8004, i64 8013, i64 8005, i64 8025, i64 8017, i64 8027, i64 8019, i64 8029, i64 8021, i64 8031, i64 8023, i64 8040, i64 8032, i64 8041, i64 8033, i64 8042, i64 8034, i64 8043, i64 8035, i64 8044, i64 8036, i64 8045, i64 8037, i64 8046, i64 8038, i64 8047, i64 8039, i64 8072, i64 8064, i64 8073, i64 8065, i64 8074, i64 8066, i64 8075, i64 8067, i64 8076, i64 8068, i64 8077, i64 8069, i64 8078, i64 8070, i64 8079, i64 8071, i64 8088, i64 8080, i64 8089, i64 8081, i64 8090, i64 8082, i64 8091, i64 8083, i64 8092, i64 8084, i64 8093, i64 8085, i64 8094, i64 8086, i64 8095, i64 8087, i64 8104, i64 8096, i64 8105, i64 8097, i64 8106, i64 8098, i64 8107, i64 8099, i64 8108, i64 8100, i64 8109, i64 8101, i64 8110, i64 8102, i64 8111, i64 8103, i64 8120, i64 8112, i64 8121, i64 8113, i64 8122, i64 8048, i64 8123, i64 8049, i64 8124, i64 8115, i64 8136, i64 8050, i64 8137, i64 8051, i64 8138, i64 8052, i64 8139, i64 8053, i64 8140, i64 8131, i64 8152, i64 8144, i64 8153, i64 8145, i64 8154, i64 8054, i64 8155, i64 8055, i64 8168, i64 8160, i64 8169, i64 8161, i64 8170, i64 8058, i64 8171, i64 8059, i64 8172, i64 8165, i64 8184, i64 8056, i64 8185, i64 8057, i64 8186, i64 8060, i64 8187, i64 8061, i64 8188, i64 8179, i64 8486, i64 969, i64 8490, i64 107, i64 8491, i64 229, i64 8498, i64 8526, i64 8544, i64 8560, i64 8545, i64 8561, i64 8546, i64 8562, i64 8547, i64 8563, i64 8548, i64 8564, i64 8549, i64 8565, i64 8550, i64 8566, i64 8551, i64 8567, i64 8552, i64 8568, i64 8553, i64 8569, i64 8554, i64 8570, i64 8555, i64 8571, i64 8556, i64 8572, i64 8557, i64 8573, i64 8558, i64 8574, i64 8559, i64 8575, i64 8579, i64 8580, i64 9398, i64 9424, i64 9399, i64 9425, i64 9400, i64 9426, i64 9401, i64 9427, i64 9402, i64 9428, i64 9403, i64 9429, i64 9404, i64 9430, i64 9405, i64 9431, i64 9406, i64 9432, i64 9407, i64 9433, i64 9408, i64 9434, i64 9409, i64 9435, i64 9410, i64 9436, i64 9411, i64 9437, i64 9412, i64 9438, i64 9413, i64 9439, i64 9414, i64 9440, i64 9415, i64 9441, i64 9416, i64 9442, i64 9417, i64 9443, i64 9418, i64 9444, i64 9419, i64 9445, i64 9420, i64 9446, i64 9421, i64 9447, i64 9422, i64 9448, i64 9423, i64 9449, i64 11264, i64 11312, i64 11265, i64 11313, i64 11266, i64 11314, i64 11267, i64 11315, i64 11268, i64 11316, i64 11269, i64 11317, i64 11270, i64 11318, i64 11271, i64 11319, i64 11272, i64 11320, i64 11273, i64 11321, i64 11274, i64 11322, i64 11275, i64 11323, i64 11276, i64 11324, i64 11277, i64 11325, i64 11278, i64 11326, i64 11279, i64 11327, i64 11280, i64 11328, i64 11281, i64 11329, i64 11282, i64 11330, i64 11283, i64 11331, i64 11284, i64 11332, i64 11285, i64 11333, i64 11286, i64 11334, i64 11287, i64 11335, i64 11288, i64 11336, i64 11289, i64 11337, i64 11290, i64 11338, i64 11291, i64 11339, i64 11292, i64 11340, i64 11293, i64 11341, i64 11294, i64 11342, i64 11295, i64 11343, i64 11296, i64 11344, i64 11297, i64 11345, i64 11298, i64 11346, i64 11299, i64 11347, i64 11300, i64 11348, i64 11301, i64 11349, i64 11302, i64 11350, i64 11303, i64 11351, i64 11304, i64 11352, i64 11305, i64 11353, i64 11306, i64 11354, i64 11307, i64 11355, i64 11308, i64 11356, i64 11309, i64 11357, i64 11310, i64 11358, i64 11311, i64 11359, i64 11360, i64 11361, i64 11362, i64 619, i64 11363, i64 7549, i64 11364, i64 637, i64 11367, i64 11368, i64 11369, i64 11370, i64 11371, i64 11372, i64 11373, i64 593, i64 11374, i64 625, i64 11375, i64 592, i64 11376, i64 594, i64 11378, i64 11379, i64 11381, i64 11382, i64 11390, i64 575, i64 11391, i64 576, i64 11392, i64 11393, i64 11394, i64 11395, i64 11396, i64 11397, i64 11398, i64 11399, i64 11400, i64 11401, i64 11402, i64 11403, i64 11404, i64 11405, i64 11406, i64 11407, i64 11408, i64 11409, i64 11410, i64 11411, i64 11412, i64 11413, i64 11414, i64 11415, i64 11416, i64 11417, i64 11418, i64 11419, i64 11420, i64 11421, i64 11422, i64 11423, i64 11424, i64 11425, i64 11426, i64 11427, i64 11428, i64 11429, i64 11430, i64 11431, i64 11432, i64 11433, i64 11434, i64 11435, i64 11436, i64 11437, i64 11438, i64 11439, i64 11440, i64 11441, i64 11442, i64 11443, i64 11444, i64 11445, i64 11446, i64 11447, i64 11448, i64 11449, i64 11450, i64 11451, i64 11452, i64 11453, i64 11454, i64 11455, i64 11456, i64 11457, i64 11458, i64 11459, i64 11460, i64 11461, i64 11462, i64 11463, i64 11464, i64 11465, i64 11466, i64 11467, i64 11468, i64 11469, i64 11470, i64 11471, i64 11472, i64 11473, i64 11474, i64 11475, i64 11476, i64 11477, i64 11478, i64 11479, i64 11480, i64 11481, i64 11482, i64 11483, i64 11484, i64 11485, i64 11486, i64 11487, i64 11488, i64 11489, i64 11490, i64 11491, i64 11499, i64 11500, i64 11501, i64 11502, i64 11506, i64 11507, i64 42560, i64 42561, i64 42562, i64 42563, i64 42564, i64 42565, i64 42566, i64 42567, i64 42568, i64 42569, i64 42570, i64 42571, i64 42572, i64 42573, i64 42574, i64 42575, i64 42576, i64 42577, i64 42578, i64 42579, i64 42580, i64 42581, i64 42582, i64 42583, i64 42584, i64 42585, i64 42586, i64 42587, i64 42588, i64 42589, i64 42590, i64 42591, i64 42592, i64 42593, i64 42594, i64 42595, i64 42596, i64 42597, i64 42598, i64 42599, i64 42600, i64 42601, i64 42602, i64 42603, i64 42604, i64 42605, i64 42624, i64 42625, i64 42626, i64 42627, i64 42628, i64 42629, i64 42630, i64 42631, i64 42632, i64 42633, i64 42634, i64 42635, i64 42636, i64 42637, i64 42638, i64 42639, i64 42640, i64 42641, i64 42642, i64 42643, i64 42644, i64 42645, i64 42646, i64 42647, i64 42648, i64 42649, i64 42650, i64 42651, i64 42786, i64 42787, i64 42788, i64 42789, i64 42790, i64 42791, i64 42792, i64 42793, i64 42794, i64 42795, i64 42796, i64 42797, i64 42798, i64 42799, i64 42802, i64 42803, i64 42804, i64 42805, i64 42806, i64 42807, i64 42808, i64 42809, i64 42810, i64 42811, i64 42812, i64 42813, i64 42814, i64 42815, i64 42816, i64 42817, i64 42818, i64 42819, i64 42820, i64 42821, i64 42822, i64 42823, i64 42824, i64 42825, i64 42826, i64 42827, i64 42828, i64 42829, i64 42830, i64 42831, i64 42832, i64 42833, i64 42834, i64 42835, i64 42836, i64 42837, i64 42838, i64 42839, i64 42840, i64 42841, i64 42842, i64 42843, i64 42844, i64 42845, i64 42846, i64 42847, i64 42848, i64 42849, i64 42850, i64 42851, i64 42852, i64 42853, i64 42854, i64 42855, i64 42856, i64 42857, i64 42858, i64 42859, i64 42860, i64 42861, i64 42862, i64 42863, i64 42873, i64 42874, i64 42875, i64 42876, i64 42877, i64 7545, i64 42878, i64 42879, i64 42880, i64 42881, i64 42882, i64 42883, i64 42884, i64 42885, i64 42886, i64 42887, i64 42891, i64 42892, i64 42893, i64 613, i64 42896, i64 42897, i64 42898, i64 42899, i64 42902, i64 42903, i64 42904, i64 42905, i64 42906, i64 42907, i64 42908, i64 42909, i64 42910, i64 42911, i64 42912, i64 42913, i64 42914, i64 42915, i64 42916, i64 42917, i64 42918, i64 42919, i64 42920, i64 42921, i64 42922, i64 614, i64 42923, i64 604, i64 42924, i64 609, i64 42925, i64 620, i64 42926, i64 618, i64 42928, i64 670, i64 42929, i64 647, i64 42930, i64 669, i64 42931, i64 43859, i64 42932, i64 42933, i64 42934, i64 42935, i64 42936, i64 42937, i64 42938, i64 42939, i64 42940, i64 42941, i64 42942, i64 42943, i64 42944, i64 42945, i64 42946, i64 42947, i64 42948, i64 42900, i64 42949, i64 642, i64 42950, i64 7566, i64 42951, i64 42952, i64 42953, i64 42954, i64 42955, i64 612, i64 42956, i64 42957, i64 42960, i64 42961, i64 42966, i64 42967, i64 42968, i64 42969, i64 42970, i64 42971, i64 42972, i64 411, i64 42997, i64 42998, i64 65313, i64 65345, i64 65314, i64 65346, i64 65315, i64 65347, i64 65316, i64 65348, i64 65317, i64 65349, i64 65318, i64 65350, i64 65319, i64 65351, i64 65320, i64 65352, i64 65321, i64 65353, i64 65322, i64 65354, i64 65323, i64 65355, i64 65324, i64 65356, i64 65325, i64 65357, i64 65326, i64 65358, i64 65327, i64 65359, i64 65328, i64 65360, i64 65329, i64 65361, i64 65330, i64 65362, i64 65331, i64 65363, i64 65332, i64 65364, i64 65333, i64 65365, i64 65334, i64 65366, i64 65335, i64 65367, i64 65336, i64 65368, i64 65337, i64 65369, i64 65338, i64 65370, i64 66560, i64 66600, i64 66561, i64 66601, i64 66562, i64 66602, i64 66563, i64 66603, i64 66564, i64 66604, i64 66565, i64 66605, i64 66566, i64 66606, i64 66567, i64 66607, i64 66568, i64 66608, i64 66569, i64 66609, i64 66570, i64 66610, i64 66571, i64 66611, i64 66572, i64 66612, i64 66573, i64 66613, i64 66574, i64 66614, i64 66575, i64 66615, i64 66576, i64 66616, i64 66577, i64 66617, i64 66578, i64 66618, i64 66579, i64 66619, i64 66580, i64 66620, i64 66581, i64 66621, i64 66582, i64 66622, i64 66583, i64 66623, i64 66584, i64 66624, i64 66585, i64 66625, i64 66586, i64 66626, i64 66587, i64 66627, i64 66588, i64 66628, i64 66589, i64 66629, i64 66590, i64 66630, i64 66591, i64 66631, i64 66592, i64 66632, i64 66593, i64 66633, i64 66594, i64 66634, i64 66595, i64 66635, i64 66596, i64 66636, i64 66597, i64 66637, i64 66598, i64 66638, i64 66599, i64 66639, i64 66736, i64 66776, i64 66737, i64 66777, i64 66738, i64 66778, i64 66739, i64 66779, i64 66740, i64 66780, i64 66741, i64 66781, i64 66742, i64 66782, i64 66743, i64 66783, i64 66744, i64 66784, i64 66745, i64 66785, i64 66746, i64 66786, i64 66747, i64 66787, i64 66748, i64 66788, i64 66749, i64 66789, i64 66750, i64 66790, i64 66751, i64 66791, i64 66752, i64 66792, i64 66753, i64 66793, i64 66754, i64 66794, i64 66755, i64 66795, i64 66756, i64 66796, i64 66757, i64 66797, i64 66758, i64 66798, i64 66759, i64 66799, i64 66760, i64 66800, i64 66761, i64 66801, i64 66762, i64 66802, i64 66763, i64 66803, i64 66764, i64 66804, i64 66765, i64 66805, i64 66766, i64 66806, i64 66767, i64 66807, i64 66768, i64 66808, i64 66769, i64 66809, i64 66770, i64 66810, i64 66771, i64 66811, i64 66928, i64 66967, i64 66929, i64 66968, i64 66930, i64 66969, i64 66931, i64 66970, i64 66932, i64 66971, i64 66933, i64 66972, i64 66934, i64 66973, i64 66935, i64 66974, i64 66936, i64 66975, i64 66937, i64 66976, i64 66938, i64 66977, i64 66940, i64 66979, i64 66941, i64 66980, i64 66942, i64 66981, i64 66943, i64 66982, i64 66944, i64 66983, i64 66945, i64 66984, i64 66946, i64 66985, i64 66947, i64 66986, i64 66948, i64 66987, i64 66949, i64 66988, i64 66950, i64 66989, i64 66951, i64 66990, i64 66952, i64 66991, i64 66953, i64 66992, i64 66954, i64 66993, i64 66956, i64 66995, i64 66957, i64 66996, i64 66958, i64 66997, i64 66959, i64 66998, i64 66960, i64 66999, i64 66961, i64 67000, i64 66962, i64 67001, i64 66964, i64 67003, i64 66965, i64 67004, i64 68736, i64 68800, i64 68737, i64 68801, i64 68738, i64 68802, i64 68739, i64 68803, i64 68740, i64 68804, i64 68741, i64 68805, i64 68742, i64 68806, i64 68743, i64 68807, i64 68744, i64 68808, i64 68745, i64 68809, i64 68746, i64 68810, i64 68747, i64 68811, i64 68748, i64 68812, i64 68749, i64 68813, i64 68750, i64 68814, i64 68751, i64 68815, i64 68752, i64 68816, i64 68753, i64 68817, i64 68754, i64 68818, i64 68755, i64 68819, i64 68756, i64 68820, i64 68757, i64 68821, i64 68758, i64 68822, i64 68759, i64 68823, i64 68760, i64 68824, i64 68761, i64 68825, i64 68762, i64 68826, i64 68763, i64 68827, i64 68764, i64 68828, i64 68765, i64 68829, i64 68766, i64 68830, i64 68767, i64 68831, i64 68768, i64 68832, i64 68769, i64 68833, i64 68770, i64 68834, i64 68771, i64 68835, i64 68772, i64 68836, i64 68773, i64 68837, i64 68774, i64 68838, i64 68775, i64 68839, i64 68776, i64 68840, i64 68777, i64 68841, i64 68778, i64 68842, i64 68779, i64 68843, i64 68780, i64 68844, i64 68781, i64 68845, i64 68782, i64 68846, i64 68783, i64 68847, i64 68784, i64 68848, i64 68785, i64 68849, i64 68786, i64 68850, i64 68944, i64 68976, i64 68945, i64 68977, i64 68946, i64 68978, i64 68947, i64 68979, i64 68948, i64 68980, i64 68949, i64 68981, i64 68950, i64 68982, i64 68951, i64 68983, i64 68952, i64 68984, i64 68953, i64 68985, i64 68954, i64 68986, i64 68955, i64 68987, i64 68956, i64 68988, i64 68957, i64 68989, i64 68958, i64 68990, i64 68959, i64 68991, i64 68960, i64 68992, i64 68961, i64 68993, i64 68962, i64 68994, i64 68963, i64 68995, i64 68964, i64 68996, i64 68965, i64 68997, i64 71840, i64 71872, i64 71841, i64 71873, i64 71842, i64 71874, i64 71843, i64 71875, i64 71844, i64 71876, i64 71845, i64 71877, i64 71846, i64 71878, i64 71847, i64 71879, i64 71848, i64 71880, i64 71849, i64 71881, i64 71850, i64 71882, i64 71851, i64 71883, i64 71852, i64 71884, i64 71853, i64 71885, i64 71854, i64 71886, i64 71855, i64 71887, i64 71856, i64 71888, i64 71857, i64 71889, i64 71858, i64 71890, i64 71859, i64 71891, i64 71860, i64 71892, i64 71861, i64 71893, i64 71862, i64 71894, i64 71863, i64 71895, i64 71864, i64 71896, i64 71865, i64 71897, i64 71866, i64 71898, i64 71867, i64 71899, i64 71868, i64 71900, i64 71869, i64 71901, i64 71870, i64 71902, i64 71871, i64 71903, i64 93760, i64 93792, i64 93761, i64 93793, i64 93762, i64 93794, i64 93763, i64 93795, i64 93764, i64 93796, i64 93765, i64 93797, i64 93766, i64 93798, i64 93767, i64 93799, i64 93768, i64 93800, i64 93769, i64 93801, i64 93770, i64 93802, i64 93771, i64 93803, i64 93772, i64 93804, i64 93773, i64 93805, i64 93774, i64 93806, i64 93775, i64 93807, i64 93776, i64 93808, i64 93777, i64 93809, i64 93778, i64 93810, i64 93779, i64 93811, i64 93780, i64 93812, i64 93781, i64 93813, i64 93782, i64 93814, i64 93783, i64 93815, i64 93784, i64 93816, i64 93785, i64 93817, i64 93786, i64 93818, i64 93787, i64 93819, i64 93788, i64 93820, i64 93789, i64 93821, i64 93790, i64 93822, i64 93791, i64 93823, i64 125184, i64 125218, i64 125185, i64 125219, i64 125186, i64 125220, i64 125187, i64 125221, i64 125188, i64 125222, i64 125189, i64 125223, i64 125190, i64 125224, i64 125191, i64 125225, i64 125192, i64 125226, i64 125193, i64 125227, i64 125194, i64 125228, i64 125195, i64 125229, i64 125196, i64 125230, i64 125197, i64 125231, i64 125198, i64 125232, i64 125199, i64 125233, i64 125200, i64 125234, i64 125201, i64 125235, i64 125202, i64 125236, i64 125203, i64 125237, i64 125204, i64 125238, i64 125205, i64 125239, i64 125206, i64 125240, i64 125207, i64 125241, i64 125208, i64 125242, i64 125209, i64 125243, i64 125210, i64 125244, i64 125211, i64 125245, i64 125212, i64 125246, i64 125213, i64 125247, i64 125214, i64 125248, i64 125215, i64 125249, i64 125216, i64 125250, i64 125217, i64 125251], align 16
@rtt.11492 = private unnamed_addr constant [2900 x i64] [i64 97, i64 65, i64 98, i64 66, i64 99, i64 67, i64 100, i64 68, i64 101, i64 69, i64 102, i64 70, i64 103, i64 71, i64 104, i64 72, i64 105, i64 73, i64 106, i64 74, i64 107, i64 75, i64 108, i64 76, i64 109, i64 77, i64 110, i64 78, i64 111, i64 79, i64 112, i64 80, i64 113, i64 81, i64 114, i64 82, i64 115, i64 83, i64 116, i64 84, i64 117, i64 85, i64 118, i64 86, i64 119, i64 87, i64 120, i64 88, i64 121, i64 89, i64 122, i64 90, i64 181, i64 924, i64 224, i64 192, i64 225, i64 193, i64 226, i64 194, i64 227, i64 195, i64 228, i64 196, i64 229, i64 197, i64 230, i64 198, i64 231, i64 199, i64 232, i64 200, i64 233, i64 201, i64 234, i64 202, i64 235, i64 203, i64 236, i64 204, i64 237, i64 205, i64 238, i64 206, i64 239, i64 207, i64 240, i64 208, i64 241, i64 209, i64 242, i64 210, i64 243, i64 211, i64 244, i64 212, i64 245, i64 213, i64 246, i64 214, i64 248, i64 216, i64 249, i64 217, i64 250, i64 218, i64 251, i64 219, i64 252, i64 220, i64 253, i64 221, i64 254, i64 222, i64 255, i64 376, i64 257, i64 256, i64 259, i64 258, i64 261, i64 260, i64 263, i64 262, i64 265, i64 264, i64 267, i64 266, i64 269, i64 268, i64 271, i64 270, i64 273, i64 272, i64 275, i64 274, i64 277, i64 276, i64 279, i64 278, i64 281, i64 280, i64 283, i64 282, i64 285, i64 284, i64 287, i64 286, i64 289, i64 288, i64 291, i64 290, i64 293, i64 292, i64 295, i64 294, i64 297, i64 296, i64 299, i64 298, i64 301, i64 300, i64 303, i64 302, i64 305, i64 73, i64 307, i64 306, i64 309, i64 308, i64 311, i64 310, i64 314, i64 313, i64 316, i64 315, i64 318, i64 317, i64 320, i64 319, i64 322, i64 321, i64 324, i64 323, i64 326, i64 325, i64 328, i64 327, i64 331, i64 330, i64 333, i64 332, i64 335, i64 334, i64 337, i64 336, i64 339, i64 338, i64 341, i64 340, i64 343, i64 342, i64 345, i64 344, i64 347, i64 346, i64 349, i64 348, i64 351, i64 350, i64 353, i64 352, i64 355, i64 354, i64 357, i64 356, i64 359, i64 358, i64 361, i64 360, i64 363, i64 362, i64 365, i64 364, i64 367, i64 366, i64 369, i64 368, i64 371, i64 370, i64 373, i64 372, i64 375, i64 374, i64 378, i64 377, i64 380, i64 379, i64 382, i64 381, i64 383, i64 83, i64 384, i64 579, i64 387, i64 386, i64 389, i64 388, i64 392, i64 391, i64 396, i64 395, i64 402, i64 401, i64 405, i64 502, i64 409, i64 408, i64 410, i64 573, i64 411, i64 42972, i64 414, i64 544, i64 417, i64 416, i64 419, i64 418, i64 421, i64 420, i64 424, i64 423, i64 429, i64 428, i64 432, i64 431, i64 436, i64 435, i64 438, i64 437, i64 441, i64 440, i64 445, i64 444, i64 447, i64 503, i64 453, i64 452, i64 454, i64 452, i64 456, i64 455, i64 457, i64 455, i64 459, i64 458, i64 460, i64 458, i64 462, i64 461, i64 464, i64 463, i64 466, i64 465, i64 468, i64 467, i64 470, i64 469, i64 472, i64 471, i64 474, i64 473, i64 476, i64 475, i64 477, i64 398, i64 479, i64 478, i64 481, i64 480, i64 483, i64 482, i64 485, i64 484, i64 487, i64 486, i64 489, i64 488, i64 491, i64 490, i64 493, i64 492, i64 495, i64 494, i64 498, i64 497, i64 499, i64 497, i64 501, i64 500, i64 505, i64 504, i64 507, i64 506, i64 509, i64 508, i64 511, i64 510, i64 513, i64 512, i64 515, i64 514, i64 517, i64 516, i64 519, i64 518, i64 521, i64 520, i64 523, i64 522, i64 525, i64 524, i64 527, i64 526, i64 529, i64 528, i64 531, i64 530, i64 533, i64 532, i64 535, i64 534, i64 537, i64 536, i64 539, i64 538, i64 541, i64 540, i64 543, i64 542, i64 547, i64 546, i64 549, i64 548, i64 551, i64 550, i64 553, i64 552, i64 555, i64 554, i64 557, i64 556, i64 559, i64 558, i64 561, i64 560, i64 563, i64 562, i64 572, i64 571, i64 575, i64 11390, i64 576, i64 11391, i64 578, i64 577, i64 583, i64 582, i64 585, i64 584, i64 587, i64 586, i64 589, i64 588, i64 591, i64 590, i64 592, i64 11375, i64 593, i64 11373, i64 594, i64 11376, i64 595, i64 385, i64 596, i64 390, i64 598, i64 393, i64 599, i64 394, i64 601, i64 399, i64 603, i64 400, i64 604, i64 42923, i64 608, i64 403, i64 609, i64 42924, i64 611, i64 404, i64 612, i64 42955, i64 613, i64 42893, i64 614, i64 42922, i64 616, i64 407, i64 617, i64 406, i64 618, i64 42926, i64 619, i64 11362, i64 620, i64 42925, i64 623, i64 412, i64 625, i64 11374, i64 626, i64 413, i64 629, i64 415, i64 637, i64 11364, i64 640, i64 422, i64 642, i64 42949, i64 643, i64 425, i64 647, i64 42929, i64 648, i64 430, i64 649, i64 580, i64 650, i64 433, i64 651, i64 434, i64 652, i64 581, i64 658, i64 439, i64 669, i64 42930, i64 670, i64 42928, i64 837, i64 921, i64 881, i64 880, i64 883, i64 882, i64 887, i64 886, i64 891, i64 1021, i64 892, i64 1022, i64 893, i64 1023, i64 940, i64 902, i64 941, i64 904, i64 942, i64 905, i64 943, i64 906, i64 945, i64 913, i64 946, i64 914, i64 947, i64 915, i64 948, i64 916, i64 949, i64 917, i64 950, i64 918, i64 951, i64 919, i64 952, i64 920, i64 953, i64 921, i64 954, i64 922, i64 955, i64 923, i64 956, i64 924, i64 957, i64 925, i64 958, i64 926, i64 959, i64 927, i64 960, i64 928, i64 961, i64 929, i64 962, i64 931, i64 963, i64 931, i64 964, i64 932, i64 965, i64 933, i64 966, i64 934, i64 967, i64 935, i64 968, i64 936, i64 969, i64 937, i64 970, i64 938, i64 971, i64 939, i64 972, i64 908, i64 973, i64 910, i64 974, i64 911, i64 976, i64 914, i64 977, i64 920, i64 981, i64 934, i64 982, i64 928, i64 983, i64 975, i64 985, i64 984, i64 987, i64 986, i64 989, i64 988, i64 991, i64 990, i64 993, i64 992, i64 995, i64 994, i64 997, i64 996, i64 999, i64 998, i64 1001, i64 1000, i64 1003, i64 1002, i64 1005, i64 1004, i64 1007, i64 1006, i64 1008, i64 922, i64 1009, i64 929, i64 1010, i64 1017, i64 1011, i64 895, i64 1013, i64 917, i64 1016, i64 1015, i64 1019, i64 1018, i64 1072, i64 1040, i64 1073, i64 1041, i64 1074, i64 1042, i64 1075, i64 1043, i64 1076, i64 1044, i64 1077, i64 1045, i64 1078, i64 1046, i64 1079, i64 1047, i64 1080, i64 1048, i64 1081, i64 1049, i64 1082, i64 1050, i64 1083, i64 1051, i64 1084, i64 1052, i64 1085, i64 1053, i64 1086, i64 1054, i64 1087, i64 1055, i64 1088, i64 1056, i64 1089, i64 1057, i64 1090, i64 1058, i64 1091, i64 1059, i64 1092, i64 1060, i64 1093, i64 1061, i64 1094, i64 1062, i64 1095, i64 1063, i64 1096, i64 1064, i64 1097, i64 1065, i64 1098, i64 1066, i64 1099, i64 1067, i64 1100, i64 1068, i64 1101, i64 1069, i64 1102, i64 1070, i64 1103, i64 1071, i64 1104, i64 1024, i64 1105, i64 1025, i64 1106, i64 1026, i64 1107, i64 1027, i64 1108, i64 1028, i64 1109, i64 1029, i64 1110, i64 1030, i64 1111, i64 1031, i64 1112, i64 1032, i64 1113, i64 1033, i64 1114, i64 1034, i64 1115, i64 1035, i64 1116, i64 1036, i64 1117, i64 1037, i64 1118, i64 1038, i64 1119, i64 1039, i64 1121, i64 1120, i64 1123, i64 1122, i64 1125, i64 1124, i64 1127, i64 1126, i64 1129, i64 1128, i64 1131, i64 1130, i64 1133, i64 1132, i64 1135, i64 1134, i64 1137, i64 1136, i64 1139, i64 1138, i64 1141, i64 1140, i64 1143, i64 1142, i64 1145, i64 1144, i64 1147, i64 1146, i64 1149, i64 1148, i64 1151, i64 1150, i64 1153, i64 1152, i64 1163, i64 1162, i64 1165, i64 1164, i64 1167, i64 1166, i64 1169, i64 1168, i64 1171, i64 1170, i64 1173, i64 1172, i64 1175, i64 1174, i64 1177, i64 1176, i64 1179, i64 1178, i64 1181, i64 1180, i64 1183, i64 1182, i64 1185, i64 1184, i64 1187, i64 1186, i64 1189, i64 1188, i64 1191, i64 1190, i64 1193, i64 1192, i64 1195, i64 1194, i64 1197, i64 1196, i64 1199, i64 1198, i64 1201, i64 1200, i64 1203, i64 1202, i64 1205, i64 1204, i64 1207, i64 1206, i64 1209, i64 1208, i64 1211, i64 1210, i64 1213, i64 1212, i64 1215, i64 1214, i64 1218, i64 1217, i64 1220, i64 1219, i64 1222, i64 1221, i64 1224, i64 1223, i64 1226, i64 1225, i64 1228, i64 1227, i64 1230, i64 1229, i64 1231, i64 1216, i64 1233, i64 1232, i64 1235, i64 1234, i64 1237, i64 1236, i64 1239, i64 1238, i64 1241, i64 1240, i64 1243, i64 1242, i64 1245, i64 1244, i64 1247, i64 1246, i64 1249, i64 1248, i64 1251, i64 1250, i64 1253, i64 1252, i64 1255, i64 1254, i64 1257, i64 1256, i64 1259, i64 1258, i64 1261, i64 1260, i64 1263, i64 1262, i64 1265, i64 1264, i64 1267, i64 1266, i64 1269, i64 1268, i64 1271, i64 1270, i64 1273, i64 1272, i64 1275, i64 1274, i64 1277, i64 1276, i64 1279, i64 1278, i64 1281, i64 1280, i64 1283, i64 1282, i64 1285, i64 1284, i64 1287, i64 1286, i64 1289, i64 1288, i64 1291, i64 1290, i64 1293, i64 1292, i64 1295, i64 1294, i64 1297, i64 1296, i64 1299, i64 1298, i64 1301, i64 1300, i64 1303, i64 1302, i64 1305, i64 1304, i64 1307, i64 1306, i64 1309, i64 1308, i64 1311, i64 1310, i64 1313, i64 1312, i64 1315, i64 1314, i64 1317, i64 1316, i64 1319, i64 1318, i64 1321, i64 1320, i64 1323, i64 1322, i64 1325, i64 1324, i64 1327, i64 1326, i64 1377, i64 1329, i64 1378, i64 1330, i64 1379, i64 1331, i64 1380, i64 1332, i64 1381, i64 1333, i64 1382, i64 1334, i64 1383, i64 1335, i64 1384, i64 1336, i64 1385, i64 1337, i64 1386, i64 1338, i64 1387, i64 1339, i64 1388, i64 1340, i64 1389, i64 1341, i64 1390, i64 1342, i64 1391, i64 1343, i64 1392, i64 1344, i64 1393, i64 1345, i64 1394, i64 1346, i64 1395, i64 1347, i64 1396, i64 1348, i64 1397, i64 1349, i64 1398, i64 1350, i64 1399, i64 1351, i64 1400, i64 1352, i64 1401, i64 1353, i64 1402, i64 1354, i64 1403, i64 1355, i64 1404, i64 1356, i64 1405, i64 1357, i64 1406, i64 1358, i64 1407, i64 1359, i64 1408, i64 1360, i64 1409, i64 1361, i64 1410, i64 1362, i64 1411, i64 1363, i64 1412, i64 1364, i64 1413, i64 1365, i64 1414, i64 1366, i64 4304, i64 7312, i64 4305, i64 7313, i64 4306, i64 7314, i64 4307, i64 7315, i64 4308, i64 7316, i64 4309, i64 7317, i64 4310, i64 7318, i64 4311, i64 7319, i64 4312, i64 7320, i64 4313, i64 7321, i64 4314, i64 7322, i64 4315, i64 7323, i64 4316, i64 7324, i64 4317, i64 7325, i64 4318, i64 7326, i64 4319, i64 7327, i64 4320, i64 7328, i64 4321, i64 7329, i64 4322, i64 7330, i64 4323, i64 7331, i64 4324, i64 7332, i64 4325, i64 7333, i64 4326, i64 7334, i64 4327, i64 7335, i64 4328, i64 7336, i64 4329, i64 7337, i64 4330, i64 7338, i64 4331, i64 7339, i64 4332, i64 7340, i64 4333, i64 7341, i64 4334, i64 7342, i64 4335, i64 7343, i64 4336, i64 7344, i64 4337, i64 7345, i64 4338, i64 7346, i64 4339, i64 7347, i64 4340, i64 7348, i64 4341, i64 7349, i64 4342, i64 7350, i64 4343, i64 7351, i64 4344, i64 7352, i64 4345, i64 7353, i64 4346, i64 7354, i64 4349, i64 7357, i64 4350, i64 7358, i64 4351, i64 7359, i64 5112, i64 5104, i64 5113, i64 5105, i64 5114, i64 5106, i64 5115, i64 5107, i64 5116, i64 5108, i64 5117, i64 5109, i64 7296, i64 1042, i64 7297, i64 1044, i64 7298, i64 1054, i64 7299, i64 1057, i64 7300, i64 1058, i64 7301, i64 1058, i64 7302, i64 1066, i64 7303, i64 1122, i64 7304, i64 42570, i64 7306, i64 7305, i64 7545, i64 42877, i64 7549, i64 11363, i64 7566, i64 42950, i64 7681, i64 7680, i64 7683, i64 7682, i64 7685, i64 7684, i64 7687, i64 7686, i64 7689, i64 7688, i64 7691, i64 7690, i64 7693, i64 7692, i64 7695, i64 7694, i64 7697, i64 7696, i64 7699, i64 7698, i64 7701, i64 7700, i64 7703, i64 7702, i64 7705, i64 7704, i64 7707, i64 7706, i64 7709, i64 7708, i64 7711, i64 7710, i64 7713, i64 7712, i64 7715, i64 7714, i64 7717, i64 7716, i64 7719, i64 7718, i64 7721, i64 7720, i64 7723, i64 7722, i64 7725, i64 7724, i64 7727, i64 7726, i64 7729, i64 7728, i64 7731, i64 7730, i64 7733, i64 7732, i64 7735, i64 7734, i64 7737, i64 7736, i64 7739, i64 7738, i64 7741, i64 7740, i64 7743, i64 7742, i64 7745, i64 7744, i64 7747, i64 7746, i64 7749, i64 7748, i64 7751, i64 7750, i64 7753, i64 7752, i64 7755, i64 7754, i64 7757, i64 7756, i64 7759, i64 7758, i64 7761, i64 7760, i64 7763, i64 7762, i64 7765, i64 7764, i64 7767, i64 7766, i64 7769, i64 7768, i64 7771, i64 7770, i64 7773, i64 7772, i64 7775, i64 7774, i64 7777, i64 7776, i64 7779, i64 7778, i64 7781, i64 7780, i64 7783, i64 7782, i64 7785, i64 7784, i64 7787, i64 7786, i64 7789, i64 7788, i64 7791, i64 7790, i64 7793, i64 7792, i64 7795, i64 7794, i64 7797, i64 7796, i64 7799, i64 7798, i64 7801, i64 7800, i64 7803, i64 7802, i64 7805, i64 7804, i64 7807, i64 7806, i64 7809, i64 7808, i64 7811, i64 7810, i64 7813, i64 7812, i64 7815, i64 7814, i64 7817, i64 7816, i64 7819, i64 7818, i64 7821, i64 7820, i64 7823, i64 7822, i64 7825, i64 7824, i64 7827, i64 7826, i64 7829, i64 7828, i64 7835, i64 7776, i64 7841, i64 7840, i64 7843, i64 7842, i64 7845, i64 7844, i64 7847, i64 7846, i64 7849, i64 7848, i64 7851, i64 7850, i64 7853, i64 7852, i64 7855, i64 7854, i64 7857, i64 7856, i64 7859, i64 7858, i64 7861, i64 7860, i64 7863, i64 7862, i64 7865, i64 7864, i64 7867, i64 7866, i64 7869, i64 7868, i64 7871, i64 7870, i64 7873, i64 7872, i64 7875, i64 7874, i64 7877, i64 7876, i64 7879, i64 7878, i64 7881, i64 7880, i64 7883, i64 7882, i64 7885, i64 7884, i64 7887, i64 7886, i64 7889, i64 7888, i64 7891, i64 7890, i64 7893, i64 7892, i64 7895, i64 7894, i64 7897, i64 7896, i64 7899, i64 7898, i64 7901, i64 7900, i64 7903, i64 7902, i64 7905, i64 7904, i64 7907, i64 7906, i64 7909, i64 7908, i64 7911, i64 7910, i64 7913, i64 7912, i64 7915, i64 7914, i64 7917, i64 7916, i64 7919, i64 7918, i64 7921, i64 7920, i64 7923, i64 7922, i64 7925, i64 7924, i64 7927, i64 7926, i64 7929, i64 7928, i64 7931, i64 7930, i64 7933, i64 7932, i64 7935, i64 7934, i64 7936, i64 7944, i64 7937, i64 7945, i64 7938, i64 7946, i64 7939, i64 7947, i64 7940, i64 7948, i64 7941, i64 7949, i64 7942, i64 7950, i64 7943, i64 7951, i64 7952, i64 7960, i64 7953, i64 7961, i64 7954, i64 7962, i64 7955, i64 7963, i64 7956, i64 7964, i64 7957, i64 7965, i64 7968, i64 7976, i64 7969, i64 7977, i64 7970, i64 7978, i64 7971, i64 7979, i64 7972, i64 7980, i64 7973, i64 7981, i64 7974, i64 7982, i64 7975, i64 7983, i64 7984, i64 7992, i64 7985, i64 7993, i64 7986, i64 7994, i64 7987, i64 7995, i64 7988, i64 7996, i64 7989, i64 7997, i64 7990, i64 7998, i64 7991, i64 7999, i64 8000, i64 8008, i64 8001, i64 8009, i64 8002, i64 8010, i64 8003, i64 8011, i64 8004, i64 8012, i64 8005, i64 8013, i64 8017, i64 8025, i64 8019, i64 8027, i64 8021, i64 8029, i64 8023, i64 8031, i64 8032, i64 8040, i64 8033, i64 8041, i64 8034, i64 8042, i64 8035, i64 8043, i64 8036, i64 8044, i64 8037, i64 8045, i64 8038, i64 8046, i64 8039, i64 8047, i64 8048, i64 8122, i64 8049, i64 8123, i64 8050, i64 8136, i64 8051, i64 8137, i64 8052, i64 8138, i64 8053, i64 8139, i64 8054, i64 8154, i64 8055, i64 8155, i64 8056, i64 8184, i64 8057, i64 8185, i64 8058, i64 8170, i64 8059, i64 8171, i64 8060, i64 8186, i64 8061, i64 8187, i64 8112, i64 8120, i64 8113, i64 8121, i64 8126, i64 921, i64 8144, i64 8152, i64 8145, i64 8153, i64 8160, i64 8168, i64 8161, i64 8169, i64 8165, i64 8172, i64 8526, i64 8498, i64 8560, i64 8544, i64 8561, i64 8545, i64 8562, i64 8546, i64 8563, i64 8547, i64 8564, i64 8548, i64 8565, i64 8549, i64 8566, i64 8550, i64 8567, i64 8551, i64 8568, i64 8552, i64 8569, i64 8553, i64 8570, i64 8554, i64 8571, i64 8555, i64 8572, i64 8556, i64 8573, i64 8557, i64 8574, i64 8558, i64 8575, i64 8559, i64 8580, i64 8579, i64 9424, i64 9398, i64 9425, i64 9399, i64 9426, i64 9400, i64 9427, i64 9401, i64 9428, i64 9402, i64 9429, i64 9403, i64 9430, i64 9404, i64 9431, i64 9405, i64 9432, i64 9406, i64 9433, i64 9407, i64 9434, i64 9408, i64 9435, i64 9409, i64 9436, i64 9410, i64 9437, i64 9411, i64 9438, i64 9412, i64 9439, i64 9413, i64 9440, i64 9414, i64 9441, i64 9415, i64 9442, i64 9416, i64 9443, i64 9417, i64 9444, i64 9418, i64 9445, i64 9419, i64 9446, i64 9420, i64 9447, i64 9421, i64 9448, i64 9422, i64 9449, i64 9423, i64 11312, i64 11264, i64 11313, i64 11265, i64 11314, i64 11266, i64 11315, i64 11267, i64 11316, i64 11268, i64 11317, i64 11269, i64 11318, i64 11270, i64 11319, i64 11271, i64 11320, i64 11272, i64 11321, i64 11273, i64 11322, i64 11274, i64 11323, i64 11275, i64 11324, i64 11276, i64 11325, i64 11277, i64 11326, i64 11278, i64 11327, i64 11279, i64 11328, i64 11280, i64 11329, i64 11281, i64 11330, i64 11282, i64 11331, i64 11283, i64 11332, i64 11284, i64 11333, i64 11285, i64 11334, i64 11286, i64 11335, i64 11287, i64 11336, i64 11288, i64 11337, i64 11289, i64 11338, i64 11290, i64 11339, i64 11291, i64 11340, i64 11292, i64 11341, i64 11293, i64 11342, i64 11294, i64 11343, i64 11295, i64 11344, i64 11296, i64 11345, i64 11297, i64 11346, i64 11298, i64 11347, i64 11299, i64 11348, i64 11300, i64 11349, i64 11301, i64 11350, i64 11302, i64 11351, i64 11303, i64 11352, i64 11304, i64 11353, i64 11305, i64 11354, i64 11306, i64 11355, i64 11307, i64 11356, i64 11308, i64 11357, i64 11309, i64 11358, i64 11310, i64 11359, i64 11311, i64 11361, i64 11360, i64 11365, i64 570, i64 11366, i64 574, i64 11368, i64 11367, i64 11370, i64 11369, i64 11372, i64 11371, i64 11379, i64 11378, i64 11382, i64 11381, i64 11393, i64 11392, i64 11395, i64 11394, i64 11397, i64 11396, i64 11399, i64 11398, i64 11401, i64 11400, i64 11403, i64 11402, i64 11405, i64 11404, i64 11407, i64 11406, i64 11409, i64 11408, i64 11411, i64 11410, i64 11413, i64 11412, i64 11415, i64 11414, i64 11417, i64 11416, i64 11419, i64 11418, i64 11421, i64 11420, i64 11423, i64 11422, i64 11425, i64 11424, i64 11427, i64 11426, i64 11429, i64 11428, i64 11431, i64 11430, i64 11433, i64 11432, i64 11435, i64 11434, i64 11437, i64 11436, i64 11439, i64 11438, i64 11441, i64 11440, i64 11443, i64 11442, i64 11445, i64 11444, i64 11447, i64 11446, i64 11449, i64 11448, i64 11451, i64 11450, i64 11453, i64 11452, i64 11455, i64 11454, i64 11457, i64 11456, i64 11459, i64 11458, i64 11461, i64 11460, i64 11463, i64 11462, i64 11465, i64 11464, i64 11467, i64 11466, i64 11469, i64 11468, i64 11471, i64 11470, i64 11473, i64 11472, i64 11475, i64 11474, i64 11477, i64 11476, i64 11479, i64 11478, i64 11481, i64 11480, i64 11483, i64 11482, i64 11485, i64 11484, i64 11487, i64 11486, i64 11489, i64 11488, i64 11491, i64 11490, i64 11500, i64 11499, i64 11502, i64 11501, i64 11507, i64 11506, i64 11520, i64 4256, i64 11521, i64 4257, i64 11522, i64 4258, i64 11523, i64 4259, i64 11524, i64 4260, i64 11525, i64 4261, i64 11526, i64 4262, i64 11527, i64 4263, i64 11528, i64 4264, i64 11529, i64 4265, i64 11530, i64 4266, i64 11531, i64 4267, i64 11532, i64 4268, i64 11533, i64 4269, i64 11534, i64 4270, i64 11535, i64 4271, i64 11536, i64 4272, i64 11537, i64 4273, i64 11538, i64 4274, i64 11539, i64 4275, i64 11540, i64 4276, i64 11541, i64 4277, i64 11542, i64 4278, i64 11543, i64 4279, i64 11544, i64 4280, i64 11545, i64 4281, i64 11546, i64 4282, i64 11547, i64 4283, i64 11548, i64 4284, i64 11549, i64 4285, i64 11550, i64 4286, i64 11551, i64 4287, i64 11552, i64 4288, i64 11553, i64 4289, i64 11554, i64 4290, i64 11555, i64 4291, i64 11556, i64 4292, i64 11557, i64 4293, i64 11559, i64 4295, i64 11565, i64 4301, i64 42561, i64 42560, i64 42563, i64 42562, i64 42565, i64 42564, i64 42567, i64 42566, i64 42569, i64 42568, i64 42571, i64 42570, i64 42573, i64 42572, i64 42575, i64 42574, i64 42577, i64 42576, i64 42579, i64 42578, i64 42581, i64 42580, i64 42583, i64 42582, i64 42585, i64 42584, i64 42587, i64 42586, i64 42589, i64 42588, i64 42591, i64 42590, i64 42593, i64 42592, i64 42595, i64 42594, i64 42597, i64 42596, i64 42599, i64 42598, i64 42601, i64 42600, i64 42603, i64 42602, i64 42605, i64 42604, i64 42625, i64 42624, i64 42627, i64 42626, i64 42629, i64 42628, i64 42631, i64 42630, i64 42633, i64 42632, i64 42635, i64 42634, i64 42637, i64 42636, i64 42639, i64 42638, i64 42641, i64 42640, i64 42643, i64 42642, i64 42645, i64 42644, i64 42647, i64 42646, i64 42649, i64 42648, i64 42651, i64 42650, i64 42787, i64 42786, i64 42789, i64 42788, i64 42791, i64 42790, i64 42793, i64 42792, i64 42795, i64 42794, i64 42797, i64 42796, i64 42799, i64 42798, i64 42803, i64 42802, i64 42805, i64 42804, i64 42807, i64 42806, i64 42809, i64 42808, i64 42811, i64 42810, i64 42813, i64 42812, i64 42815, i64 42814, i64 42817, i64 42816, i64 42819, i64 42818, i64 42821, i64 42820, i64 42823, i64 42822, i64 42825, i64 42824, i64 42827, i64 42826, i64 42829, i64 42828, i64 42831, i64 42830, i64 42833, i64 42832, i64 42835, i64 42834, i64 42837, i64 42836, i64 42839, i64 42838, i64 42841, i64 42840, i64 42843, i64 42842, i64 42845, i64 42844, i64 42847, i64 42846, i64 42849, i64 42848, i64 42851, i64 42850, i64 42853, i64 42852, i64 42855, i64 42854, i64 42857, i64 42856, i64 42859, i64 42858, i64 42861, i64 42860, i64 42863, i64 42862, i64 42874, i64 42873, i64 42876, i64 42875, i64 42879, i64 42878, i64 42881, i64 42880, i64 42883, i64 42882, i64 42885, i64 42884, i64 42887, i64 42886, i64 42892, i64 42891, i64 42897, i64 42896, i64 42899, i64 42898, i64 42900, i64 42948, i64 42903, i64 42902, i64 42905, i64 42904, i64 42907, i64 42906, i64 42909, i64 42908, i64 42911, i64 42910, i64 42913, i64 42912, i64 42915, i64 42914, i64 42917, i64 42916, i64 42919, i64 42918, i64 42921, i64 42920, i64 42933, i64 42932, i64 42935, i64 42934, i64 42937, i64 42936, i64 42939, i64 42938, i64 42941, i64 42940, i64 42943, i64 42942, i64 42945, i64 42944, i64 42947, i64 42946, i64 42952, i64 42951, i64 42954, i64 42953, i64 42957, i64 42956, i64 42961, i64 42960, i64 42967, i64 42966, i64 42969, i64 42968, i64 42971, i64 42970, i64 42998, i64 42997, i64 43859, i64 42931, i64 43888, i64 5024, i64 43889, i64 5025, i64 43890, i64 5026, i64 43891, i64 5027, i64 43892, i64 5028, i64 43893, i64 5029, i64 43894, i64 5030, i64 43895, i64 5031, i64 43896, i64 5032, i64 43897, i64 5033, i64 43898, i64 5034, i64 43899, i64 5035, i64 43900, i64 5036, i64 43901, i64 5037, i64 43902, i64 5038, i64 43903, i64 5039, i64 43904, i64 5040, i64 43905, i64 5041, i64 43906, i64 5042, i64 43907, i64 5043, i64 43908, i64 5044, i64 43909, i64 5045, i64 43910, i64 5046, i64 43911, i64 5047, i64 43912, i64 5048, i64 43913, i64 5049, i64 43914, i64 5050, i64 43915, i64 5051, i64 43916, i64 5052, i64 43917, i64 5053, i64 43918, i64 5054, i64 43919, i64 5055, i64 43920, i64 5056, i64 43921, i64 5057, i64 43922, i64 5058, i64 43923, i64 5059, i64 43924, i64 5060, i64 43925, i64 5061, i64 43926, i64 5062, i64 43927, i64 5063, i64 43928, i64 5064, i64 43929, i64 5065, i64 43930, i64 5066, i64 43931, i64 5067, i64 43932, i64 5068, i64 43933, i64 5069, i64 43934, i64 5070, i64 43935, i64 5071, i64 43936, i64 5072, i64 43937, i64 5073, i64 43938, i64 5074, i64 43939, i64 5075, i64 43940, i64 5076, i64 43941, i64 5077, i64 43942, i64 5078, i64 43943, i64 5079, i64 43944, i64 5080, i64 43945, i64 5081, i64 43946, i64 5082, i64 43947, i64 5083, i64 43948, i64 5084, i64 43949, i64 5085, i64 43950, i64 5086, i64 43951, i64 5087, i64 43952, i64 5088, i64 43953, i64 5089, i64 43954, i64 5090, i64 43955, i64 5091, i64 43956, i64 5092, i64 43957, i64 5093, i64 43958, i64 5094, i64 43959, i64 5095, i64 43960, i64 5096, i64 43961, i64 5097, i64 43962, i64 5098, i64 43963, i64 5099, i64 43964, i64 5100, i64 43965, i64 5101, i64 43966, i64 5102, i64 43967, i64 5103, i64 65345, i64 65313, i64 65346, i64 65314, i64 65347, i64 65315, i64 65348, i64 65316, i64 65349, i64 65317, i64 65350, i64 65318, i64 65351, i64 65319, i64 65352, i64 65320, i64 65353, i64 65321, i64 65354, i64 65322, i64 65355, i64 65323, i64 65356, i64 65324, i64 65357, i64 65325, i64 65358, i64 65326, i64 65359, i64 65327, i64 65360, i64 65328, i64 65361, i64 65329, i64 65362, i64 65330, i64 65363, i64 65331, i64 65364, i64 65332, i64 65365, i64 65333, i64 65366, i64 65334, i64 65367, i64 65335, i64 65368, i64 65336, i64 65369, i64 65337, i64 65370, i64 65338, i64 66600, i64 66560, i64 66601, i64 66561, i64 66602, i64 66562, i64 66603, i64 66563, i64 66604, i64 66564, i64 66605, i64 66565, i64 66606, i64 66566, i64 66607, i64 66567, i64 66608, i64 66568, i64 66609, i64 66569, i64 66610, i64 66570, i64 66611, i64 66571, i64 66612, i64 66572, i64 66613, i64 66573, i64 66614, i64 66574, i64 66615, i64 66575, i64 66616, i64 66576, i64 66617, i64 66577, i64 66618, i64 66578, i64 66619, i64 66579, i64 66620, i64 66580, i64 66621, i64 66581, i64 66622, i64 66582, i64 66623, i64 66583, i64 66624, i64 66584, i64 66625, i64 66585, i64 66626, i64 66586, i64 66627, i64 66587, i64 66628, i64 66588, i64 66629, i64 66589, i64 66630, i64 66590, i64 66631, i64 66591, i64 66632, i64 66592, i64 66633, i64 66593, i64 66634, i64 66594, i64 66635, i64 66595, i64 66636, i64 66596, i64 66637, i64 66597, i64 66638, i64 66598, i64 66639, i64 66599, i64 66776, i64 66736, i64 66777, i64 66737, i64 66778, i64 66738, i64 66779, i64 66739, i64 66780, i64 66740, i64 66781, i64 66741, i64 66782, i64 66742, i64 66783, i64 66743, i64 66784, i64 66744, i64 66785, i64 66745, i64 66786, i64 66746, i64 66787, i64 66747, i64 66788, i64 66748, i64 66789, i64 66749, i64 66790, i64 66750, i64 66791, i64 66751, i64 66792, i64 66752, i64 66793, i64 66753, i64 66794, i64 66754, i64 66795, i64 66755, i64 66796, i64 66756, i64 66797, i64 66757, i64 66798, i64 66758, i64 66799, i64 66759, i64 66800, i64 66760, i64 66801, i64 66761, i64 66802, i64 66762, i64 66803, i64 66763, i64 66804, i64 66764, i64 66805, i64 66765, i64 66806, i64 66766, i64 66807, i64 66767, i64 66808, i64 66768, i64 66809, i64 66769, i64 66810, i64 66770, i64 66811, i64 66771, i64 66967, i64 66928, i64 66968, i64 66929, i64 66969, i64 66930, i64 66970, i64 66931, i64 66971, i64 66932, i64 66972, i64 66933, i64 66973, i64 66934, i64 66974, i64 66935, i64 66975, i64 66936, i64 66976, i64 66937, i64 66977, i64 66938, i64 66979, i64 66940, i64 66980, i64 66941, i64 66981, i64 66942, i64 66982, i64 66943, i64 66983, i64 66944, i64 66984, i64 66945, i64 66985, i64 66946, i64 66986, i64 66947, i64 66987, i64 66948, i64 66988, i64 66949, i64 66989, i64 66950, i64 66990, i64 66951, i64 66991, i64 66952, i64 66992, i64 66953, i64 66993, i64 66954, i64 66995, i64 66956, i64 66996, i64 66957, i64 66997, i64 66958, i64 66998, i64 66959, i64 66999, i64 66960, i64 67000, i64 66961, i64 67001, i64 66962, i64 67003, i64 66964, i64 67004, i64 66965, i64 68800, i64 68736, i64 68801, i64 68737, i64 68802, i64 68738, i64 68803, i64 68739, i64 68804, i64 68740, i64 68805, i64 68741, i64 68806, i64 68742, i64 68807, i64 68743, i64 68808, i64 68744, i64 68809, i64 68745, i64 68810, i64 68746, i64 68811, i64 68747, i64 68812, i64 68748, i64 68813, i64 68749, i64 68814, i64 68750, i64 68815, i64 68751, i64 68816, i64 68752, i64 68817, i64 68753, i64 68818, i64 68754, i64 68819, i64 68755, i64 68820, i64 68756, i64 68821, i64 68757, i64 68822, i64 68758, i64 68823, i64 68759, i64 68824, i64 68760, i64 68825, i64 68761, i64 68826, i64 68762, i64 68827, i64 68763, i64 68828, i64 68764, i64 68829, i64 68765, i64 68830, i64 68766, i64 68831, i64 68767, i64 68832, i64 68768, i64 68833, i64 68769, i64 68834, i64 68770, i64 68835, i64 68771, i64 68836, i64 68772, i64 68837, i64 68773, i64 68838, i64 68774, i64 68839, i64 68775, i64 68840, i64 68776, i64 68841, i64 68777, i64 68842, i64 68778, i64 68843, i64 68779, i64 68844, i64 68780, i64 68845, i64 68781, i64 68846, i64 68782, i64 68847, i64 68783, i64 68848, i64 68784, i64 68849, i64 68785, i64 68850, i64 68786, i64 68976, i64 68944, i64 68977, i64 68945, i64 68978, i64 68946, i64 68979, i64 68947, i64 68980, i64 68948, i64 68981, i64 68949, i64 68982, i64 68950, i64 68983, i64 68951, i64 68984, i64 68952, i64 68985, i64 68953, i64 68986, i64 68954, i64 68987, i64 68955, i64 68988, i64 68956, i64 68989, i64 68957, i64 68990, i64 68958, i64 68991, i64 68959, i64 68992, i64 68960, i64 68993, i64 68961, i64 68994, i64 68962, i64 68995, i64 68963, i64 68996, i64 68964, i64 68997, i64 68965, i64 71872, i64 71840, i64 71873, i64 71841, i64 71874, i64 71842, i64 71875, i64 71843, i64 71876, i64 71844, i64 71877, i64 71845, i64 71878, i64 71846, i64 71879, i64 71847, i64 71880, i64 71848, i64 71881, i64 71849, i64 71882, i64 71850, i64 71883, i64 71851, i64 71884, i64 71852, i64 71885, i64 71853, i64 71886, i64 71854, i64 71887, i64 71855, i64 71888, i64 71856, i64 71889, i64 71857, i64 71890, i64 71858, i64 71891, i64 71859, i64 71892, i64 71860, i64 71893, i64 71861, i64 71894, i64 71862, i64 71895, i64 71863, i64 71896, i64 71864, i64 71897, i64 71865, i64 71898, i64 71866, i64 71899, i64 71867, i64 71900, i64 71868, i64 71901, i64 71869, i64 71902, i64 71870, i64 71903, i64 71871, i64 93792, i64 93760, i64 93793, i64 93761, i64 93794, i64 93762, i64 93795, i64 93763, i64 93796, i64 93764, i64 93797, i64 93765, i64 93798, i64 93766, i64 93799, i64 93767, i64 93800, i64 93768, i64 93801, i64 93769, i64 93802, i64 93770, i64 93803, i64 93771, i64 93804, i64 93772, i64 93805, i64 93773, i64 93806, i64 93774, i64 93807, i64 93775, i64 93808, i64 93776, i64 93809, i64 93777, i64 93810, i64 93778, i64 93811, i64 93779, i64 93812, i64 93780, i64 93813, i64 93781, i64 93814, i64 93782, i64 93815, i64 93783, i64 93816, i64 93784, i64 93817, i64 93785, i64 93818, i64 93786, i64 93819, i64 93787, i64 93820, i64 93788, i64 93821, i64 93789, i64 93822, i64 93790, i64 93823, i64 93791, i64 125218, i64 125184, i64 125219, i64 125185, i64 125220, i64 125186, i64 125221, i64 125187, i64 125222, i64 125188, i64 125223, i64 125189, i64 125224, i64 125190, i64 125225, i64 125191, i64 125226, i64 125192, i64 125227, i64 125193, i64 125228, i64 125194, i64 125229, i64 125195, i64 125230, i64 125196, i64 125231, i64 125197, i64 125232, i64 125198, i64 125233, i64 125199, i64 125234, i64 125200, i64 125235, i64 125201, i64 125236, i64 125202, i64 125237, i64 125203, i64 125238, i64 125204, i64 125239, i64 125205, i64 125240, i64 125206, i64 125241, i64 125207, i64 125242, i64 125208, i64 125243, i64 125209, i64 125244, i64 125210, i64 125245, i64 125211, i64 125246, i64 125212, i64 125247, i64 125213, i64 125248, i64 125214, i64 125249, i64 125215, i64 125250, i64 125216, i64 125251, i64 125217], align 16
@rtt.12416 = private unnamed_addr constant [913 x i64] [i64 223, i64 2, i64 83, i64 83, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 329, i64 3, i64 202, i64 188, i64 78, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 496, i64 3, i64 74, i64 204, i64 140, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 912, i64 6, i64 206, i64 153, i64 204, i64 136, i64 204, i64 129, i64 0, i64 0, i64 0, i64 944, i64 6, i64 206, i64 165, i64 204, i64 136, i64 204, i64 129, i64 0, i64 0, i64 0, i64 7830, i64 3, i64 72, i64 204, i64 177, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7831, i64 3, i64 84, i64 204, i64 136, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7832, i64 3, i64 87, i64 204, i64 138, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7833, i64 3, i64 89, i64 204, i64 138, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7834, i64 3, i64 65, i64 202, i64 190, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8064, i64 5, i64 225, i64 188, i64 136, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8065, i64 5, i64 225, i64 188, i64 137, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8066, i64 5, i64 225, i64 188, i64 138, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8067, i64 5, i64 225, i64 188, i64 139, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8068, i64 5, i64 225, i64 188, i64 140, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8069, i64 5, i64 225, i64 188, i64 141, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8070, i64 5, i64 225, i64 188, i64 142, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8071, i64 5, i64 225, i64 188, i64 143, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8072, i64 5, i64 225, i64 188, i64 136, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8073, i64 5, i64 225, i64 188, i64 137, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8074, i64 5, i64 225, i64 188, i64 138, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8075, i64 5, i64 225, i64 188, i64 139, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8076, i64 5, i64 225, i64 188, i64 140, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8077, i64 5, i64 225, i64 188, i64 141, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8078, i64 5, i64 225, i64 188, i64 142, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8079, i64 5, i64 225, i64 188, i64 143, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8080, i64 5, i64 225, i64 190, i64 152, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8081, i64 5, i64 225, i64 190, i64 153, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8082, i64 5, i64 225, i64 190, i64 154, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8083, i64 5, i64 225, i64 190, i64 155, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8084, i64 5, i64 225, i64 190, i64 156, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8085, i64 5, i64 225, i64 190, i64 157, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8086, i64 5, i64 225, i64 190, i64 158, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8087, i64 5, i64 225, i64 190, i64 159, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8088, i64 5, i64 225, i64 190, i64 152, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8089, i64 5, i64 225, i64 190, i64 153, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8090, i64 5, i64 225, i64 190, i64 154, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8091, i64 5, i64 225, i64 190, i64 155, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8092, i64 5, i64 225, i64 190, i64 156, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8093, i64 5, i64 225, i64 190, i64 157, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8094, i64 5, i64 225, i64 190, i64 158, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8095, i64 5, i64 225, i64 190, i64 159, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8096, i64 5, i64 225, i64 190, i64 168, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8097, i64 5, i64 225, i64 190, i64 169, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8098, i64 5, i64 225, i64 190, i64 170, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8099, i64 5, i64 225, i64 190, i64 171, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8100, i64 5, i64 225, i64 190, i64 172, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8101, i64 5, i64 225, i64 190, i64 173, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8102, i64 5, i64 225, i64 190, i64 174, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8103, i64 5, i64 225, i64 190, i64 175, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8104, i64 5, i64 225, i64 190, i64 168, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8105, i64 5, i64 225, i64 190, i64 169, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8106, i64 5, i64 225, i64 190, i64 170, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8107, i64 5, i64 225, i64 190, i64 171, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8108, i64 5, i64 225, i64 190, i64 172, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8109, i64 5, i64 225, i64 190, i64 173, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8110, i64 5, i64 225, i64 190, i64 174, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8111, i64 5, i64 225, i64 190, i64 175, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8114, i64 5, i64 225, i64 190, i64 186, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 8115, i64 4, i64 206, i64 145, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8116, i64 4, i64 206, i64 134, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8118, i64 4, i64 206, i64 145, i64 205, i64 130, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8119, i64 6, i64 206, i64 145, i64 205, i64 130, i64 205, i64 133, i64 0, i64 0, i64 0, i64 8124, i64 4, i64 206, i64 145, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8130, i64 5, i64 225, i64 191, i64 138, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 8131, i64 4, i64 206, i64 151, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8132, i64 4, i64 206, i64 137, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8134, i64 4, i64 206, i64 151, i64 205, i64 130, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8135, i64 6, i64 206, i64 151, i64 205, i64 130, i64 205, i64 133, i64 0, i64 0, i64 0, i64 8140, i64 4, i64 206, i64 151, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8178, i64 5, i64 225, i64 191, i64 186, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 8179, i64 4, i64 206, i64 169, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8180, i64 4, i64 206, i64 143, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8182, i64 4, i64 206, i64 169, i64 205, i64 130, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8183, i64 6, i64 206, i64 169, i64 205, i64 130, i64 205, i64 133, i64 0, i64 0, i64 0, i64 8188, i64 4, i64 206, i64 169, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64256, i64 2, i64 70, i64 70, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64257, i64 2, i64 70, i64 73, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64258, i64 2, i64 70, i64 76, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64259, i64 3, i64 70, i64 70, i64 73, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64260, i64 3, i64 70, i64 70, i64 76, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64261, i64 2, i64 83, i64 84, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64262, i64 2, i64 83, i64 84, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0], align 16
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
@rtt.17055 = private unnamed_addr constant [64 x i64] [i64 1116352408, i64 1899447441, i64 3049323471, i64 3921009573, i64 961987163, i64 1508970993, i64 2453635748, i64 2870763221, i64 3624381080, i64 310598401, i64 607225278, i64 1426881987, i64 1925078388, i64 2162078206, i64 2614888103, i64 3248222580, i64 3835390401, i64 4022224774, i64 264347078, i64 604807628, i64 770255983, i64 1249150122, i64 1555081692, i64 1996064986, i64 2554220882, i64 2821834349, i64 2952996808, i64 3210313671, i64 3336571891, i64 3584528711, i64 113926993, i64 338241895, i64 666307205, i64 773529912, i64 1294757372, i64 1396182291, i64 1695183700, i64 1986661051, i64 2177026350, i64 2456956037, i64 2730485921, i64 2820302411, i64 3259730800, i64 3345764771, i64 3516065817, i64 3600352804, i64 4094571909, i64 275423344, i64 430227734, i64 506948616, i64 659060556, i64 883997877, i64 958139571, i64 1322822218, i64 1537002063, i64 1747873779, i64 1955562222, i64 2024104815, i64 2227730452, i64 2361852424, i64 2428436474, i64 2756734187, i64 3204031479, i64 3329325298], align 16
@rtt.17569 = private unnamed_addr constant [8 x i64] [i64 1779033703, i64 3144134277, i64 1013904242, i64 2773480762, i64 1359893119, i64 2600822924, i64 528734635, i64 1541459225], align 16
@.s2926 = private unnamed_addr constant [17 x i8] c"0123456789abcdef\00"
@rtg.rt_dbg = internal global [8224 x i8] zeroinitializer, align 16
@rtg.dbg_status = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.dbg_msg = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.dbg_peek = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtt.18806 = private unnamed_addr constant [17 x i64] [i64 80, i64 96, i64 88, i64 40, i64 104, i64 112, i64 32, i64 152, i64 72, i64 64, i64 56, i64 48, i64 24, i64 16, i64 8, i64 0, i64 128], align 16
@rtg.dbg_regs = internal thread_local global [256 x i8] zeroinitializer, align 16
@.s3199 = private unnamed_addr constant [15 x i8] c"RESID_STACK_MB\00"
@rtg.numfmt_buf = internal thread_local global [32 x i8] zeroinitializer, align 16
@rtg.limb_buf = internal thread_local global [208 x i8] zeroinitializer, align 16
@rtg.limbs = internal thread_local global [64 x i8] zeroinitializer, align 16
@rtg.ftoa_buf = internal thread_local global [64 x i8] zeroinitializer, align 16
@.s3447 = private unnamed_addr constant [6 x i8] c"%.17g\00"
@.s3452 = private unnamed_addr constant [5 x i8] c"true\00"
@.s3454 = private unnamed_addr constant [6 x i8] c"false\00"
@.s3805 = private unnamed_addr constant [4 x i8] c"nan\00"
@.s3807 = private unnamed_addr constant [5 x i8] c"-inf\00"
@.s3809 = private unnamed_addr constant [4 x i8] c"inf\00"
@rtg.f128_m = internal thread_local global [2080 x i8] zeroinitializer, align 16
@rtg.f128_ip = internal thread_local global [2080 x i8] zeroinitializer, align 16
@rtg.f128_ib = internal thread_local global [5000 x i8] zeroinitializer, align 16
@rtg.f128_fd = internal thread_local global [64 x i8] zeroinitializer, align 16
@.s3850 = private unnamed_addr constant [2 x i8] c"0\00"
@rtg.f128_lead = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s3870 = private unnamed_addr constant [3 x i8] c"-0\00"
@.s3872 = private unnamed_addr constant [2 x i8] c"0\00"
@rtg.f128_digits = internal thread_local global [48 x i8] zeroinitializer, align 16
@rtg.f128_out = internal thread_local global [112 x i8] zeroinitializer, align 16
@rtg.show_buf = internal thread_local global [64 x i8] zeroinitializer, align 16
@.s4059 = private unnamed_addr constant [6 x i8] c"%.17g\00"
@.s4070 = private unnamed_addr constant [5 x i8] c"true\00"
@.s4072 = private unnamed_addr constant [6 x i8] c"false\00"
@.s4079 = private unnamed_addr constant [5 x i8] c"null\00"
@.s4084 = private unnamed_addr constant [4 x i8] c"…\00"
@.s4090 = private unnamed_addr constant [3 x i8] c", \00"
@.s4100 = private unnamed_addr constant [3 x i8] c", \00"
@.s4119 = private unnamed_addr constant [5 x i8] c"null\00"
@.s4128 = private unnamed_addr constant [5 x i8] c"i128\00"
@.s4140 = private unnamed_addr constant [5 x i8] c"u128\00"
@.s4171 = private unnamed_addr constant [6 x i8] c"Some(\00"
@.s4173 = private unnamed_addr constant [6 x i8] c"Some<\00"
@.s4182 = private unnamed_addr constant [2 x i8] c")\00"
@.s4184 = private unnamed_addr constant [2 x i8] c">\00"
@.s4190 = private unnamed_addr constant [5 x i8] c"None\00"
@.s4195 = private unnamed_addr constant [2 x i8] c"(\00"
@.s4200 = private unnamed_addr constant [2 x i8] c")\00"
@.s4205 = private unnamed_addr constant [5 x i8] c"null\00"
@.s4212 = private unnamed_addr constant [2 x i8] c"(\00"
@.s4221 = private unnamed_addr constant [2 x i8] c")\00"
@.s4227 = private unnamed_addr constant [3 x i8] c", \00"
@rtg.rand_byte = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s4406 = private unnamed_addr constant [13 x i8] c"/dev/urandom\00"
@.s4411 = private unnamed_addr constant [38 x i8] c"crypto_random_byte: no entropy source\00"
@.s4416 = private unnamed_addr constant [32 x i8] c"crypto_random_byte: read failed\00"
@.s4423 = private unnamed_addr constant [33 x i8] c"list index out of bounds: index \00"
@.s4427 = private unnamed_addr constant [10 x i8] c", length \00"
@.s4436 = private unnamed_addr constant [3 x i8] c" (\00"
@.s4441 = private unnamed_addr constant [2 x i8] c")\00"
@rtg.ai_hints = internal thread_local global [48 x i8] zeroinitializer, align 16
@rtg.ai_port = internal thread_local global [24 x i8] zeroinitializer, align 16
@rtg.ai_res = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.ai_tv = internal thread_local global [16 x i8] zeroinitializer, align 16
@.s4600 = private unnamed_addr constant [5 x i8] c"List\00"
@rtg.rt_catch = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.rt_catch_msg = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s4632 = private unnamed_addr constant [13 x i8] c"region abort\00"
@.s4648 = private unnamed_addr constant [13 x i8] c"resid: abort\00"
@.s4651 = private unnamed_addr constant [3 x i8] c": \00"
@.s4654 = private unnamed_addr constant [6 x i8] c"abort\00"
@.s4659 = private unnamed_addr constant [3 x i8] c" (\00"
@.s4665 = private unnamed_addr constant [2 x i8] c")\00"
@.s4673 = private unnamed_addr constant [3 x i8] c": \00"
@.s4679 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.s4703 = private unnamed_addr constant [21 x i8] c"child region aborted\00"
@rtg.spawn_slot = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s4710 = private unnamed_addr constant [7 x i8] c"Result\00"
@rtg.spawn_ret = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s4734 = private unnamed_addr constant [7 x i8] c"Result\00"
@rtg.rt_test = internal global [96 x i8] zeroinitializer, align 16
@rtg.rt_test_fail = internal global [1024 x i8] zeroinitializer, align 16
@rtg.rt_test_fmt_read = internal global [8 x i8] zeroinitializer, align 16
@.s4759 = private unnamed_addr constant [18 x i8] c"RESID_TEST_FORMAT\00"
@.s4764 = private unnamed_addr constant [4 x i8] c"tap\00"
@.s4771 = private unnamed_addr constant [5 x i8] c"json\00"
@rtg.test_ms = internal thread_local global [64 x i8] zeroinitializer, align 16
@.s4793 = private unnamed_addr constant [1 x i8] c"\00"
@.s4798 = private unnamed_addr constant [21 x i8] c"expectation failed: \00"
@.s4802 = private unnamed_addr constant [2 x i8] c"?\00"
@.s4807 = private unnamed_addr constant [16 x i8] c"\0A    actual:   \00"
@.s4817 = private unnamed_addr constant [16 x i8] c"\0A    expected: \00"
@rtg.expect_buf = internal thread_local global [1024 x i8] zeroinitializer, align 16
@.s4853 = private unnamed_addr constant [18 x i8] c"RESID_TEST_FILTER\00"
@.s4862 = private unnamed_addr constant [1 x i8] c"\00"
@.s4867 = private unnamed_addr constant [1 x i8] c"\00"
@.s4874 = private unnamed_addr constant [19 x i8] c"TAP version 13\0A1..\00"
@.s4879 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.s4885 = private unnamed_addr constant [12 x i8] c"{\22module\22:\22\00"
@.s4891 = private unnamed_addr constant [12 x i8] c"\22,\22tests\22:[\00"
@.s4897 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.s4903 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.s4918 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.s4937 = private unnamed_addr constant [8 x i8] c"not ok \00"
@.s4939 = private unnamed_addr constant [4 x i8] c"ok \00"
@.s4945 = private unnamed_addr constant [2 x i8] c" \00"
@.s4952 = private unnamed_addr constant [2 x i8] c".\00"
@.s4958 = private unnamed_addr constant [18 x i8] c" # SKIP filtered\0A\00"
@.s4961 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.s4965 = private unnamed_addr constant [20 x i8] c"  ---\0A  message: |\0A\00"
@.s4969 = private unnamed_addr constant [5 x i8] c"    \00"
@.s4972 = private unnamed_addr constant [7 x i8] c"  ...\0A\00"
@.s4977 = private unnamed_addr constant [2 x i8] c",\00"
@.s4981 = private unnamed_addr constant [10 x i8] c"{\22name\22:\22\00"
@.s4986 = private unnamed_addr constant [13 x i8] c"\22,\22status\22:\22\00"
@.s4990 = private unnamed_addr constant [8 x i8] c"skipped\00"
@.s4992 = private unnamed_addr constant [7 x i8] c"failed\00"
@.s4994 = private unnamed_addr constant [7 x i8] c"passed\00"
@.s4999 = private unnamed_addr constant [17 x i8] c"\22,\22duration_ms\22:\00"
@.s5002 = private unnamed_addr constant [5 x i8] c"%.3f\00"
@.s5006 = private unnamed_addr constant [2 x i8] c"}\00"
@.s5011 = private unnamed_addr constant [5 x i8] c"  - \00"
@.s5016 = private unnamed_addr constant [12 x i8] c" (skipped)\0A\00"
@.s5020 = private unnamed_addr constant [7 x i8] c"  ✗ \00"
@.s5022 = private unnamed_addr constant [7 x i8] c"  ✓ \00"
@.s5027 = private unnamed_addr constant [3 x i8] c" (\00"
@.s5031 = private unnamed_addr constant [5 x i8] c"%.0f\00"
@.s5035 = private unnamed_addr constant [5 x i8] c"ms)\0A\00"
@.s5040 = private unnamed_addr constant [5 x i8] c"    \00"
@rtg.test_clock = internal thread_local global [16 x i8] zeroinitializer, align 16
@.s5055 = private unnamed_addr constant [10 x i8] c"<unnamed>\00"
@.s5095 = private unnamed_addr constant [8 x i8] c"aborted\00"
@.s5133 = private unnamed_addr constant [12 x i8] c"],\22passed\22:\00"
@.s5139 = private unnamed_addr constant [11 x i8] c",\22failed\22:\00"
@.s5146 = private unnamed_addr constant [12 x i8] c",\22skipped\22:\00"
@.s5153 = private unnamed_addr constant [16 x i8] c",\22duration_ms\22:\00"
@.s5157 = private unnamed_addr constant [5 x i8] c"%.3f\00"
@.s5161 = private unnamed_addr constant [3 x i8] c"}\0A\00"
@.s5173 = private unnamed_addr constant [12 x i8] c"\0AFailures: \00"
@.s5179 = private unnamed_addr constant [12 x i8] c" | Passed: \00"
@.s5188 = private unnamed_addr constant [13 x i8] c" | Skipped: \00"
@.s5195 = private unnamed_addr constant [14 x i8] c" | Duration: \00"
@.s5198 = private unnamed_addr constant [5 x i8] c"%.0f\00"
@.s5202 = private unnamed_addr constant [4 x i8] c"ms\0A\00"
@rtt.25346 = private unnamed_addr constant [20 x i64] [i64 1, i64 10, i64 100, i64 1000, i64 10000, i64 100000, i64 1000000, i64 10000000, i64 100000000, i64 1000000000, i64 10000000000, i64 100000000000, i64 1000000000000, i64 10000000000000, i64 100000000000000, i64 1000000000000000, i64 10000000000000000, i64 100000000000000000, i64 1000000000000000000, i64 0], align 16
@rtg.dec_r2 = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s5369 = private unnamed_addr constant [21 x i8] c"dec: value too large\00"
@.s5417 = private unnamed_addr constant [28 x i8] c"dec: precision out of range\00"
@.s5536 = private unnamed_addr constant [27 x i8] c"dec: exponent out of range\00"
@.s6735 = private unnamed_addr constant [22 x i8] c"dec: division by zero\00"
@.s6796 = private unnamed_addr constant [14 x i8] c"dec: internal\00"
@.s7024 = private unnamed_addr constant [27 x i8] c"dec: exponent out of range\00"
@.s7090 = private unnamed_addr constant [24 x i8] c"dec: bad decimal string\00"
@rtg.dec_one = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s7139 = private unnamed_addr constant [2 x i8] c"0\00"
@.s7301 = private unnamed_addr constant [24 x i8] c"dec: non-integer to Int\00"
@.s7307 = private unnamed_addr constant [32 x i8] c"dec: value out of range for Int\00"
@.s7349 = private unnamed_addr constant [32 x i8] c"dec: value out of range for Int\00"
@rtg.dec_f64 = internal thread_local global [96 x i8] zeroinitializer, align 16
@rtg.pvec_one = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.list_seed = internal thread_local global [32 x i8] zeroinitializer, align 16
@.s7933 = private unnamed_addr constant [31 x i8] c"range too large to materialize\00"
@.s7940 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.s7955 = private unnamed_addr constant [31 x i8] c"range too large to materialize\00"
@.s7961 = private unnamed_addr constant [17 x i8] c"assertion failed\00"
@.s7965 = private unnamed_addr constant [3 x i8] c": \00"
@.s7975 = private unnamed_addr constant [16 x i8] c"not implemented\00"
@.s7977 = private unnamed_addr constant [20 x i8] c"not yet implemented\00"
@.s7982 = private unnamed_addr constant [3 x i8] c": \00"
@rtg.map_ret = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.map_flag = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.map_heap = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.map_fbuf = internal thread_local global [64 x i8] zeroinitializer, align 16
@.s8202 = private unnamed_addr constant [6 x i8] c"%.17g\00"
@.s8225 = private unnamed_addr constant [4 x i8] c"i64\00"
@.s8228 = private unnamed_addr constant [4 x i8] c"f64\00"
@.s8231 = private unnamed_addr constant [5 x i8] c"bool\00"
@.s8234 = private unnamed_addr constant [5 x i8] c"i128\00"
@.s8237 = private unnamed_addr constant [5 x i8] c"u128\00"
@.s8269 = private unnamed_addr constant [2 x i8] c"t\00"
@.s8271 = private unnamed_addr constant [2 x i8] c"f\00"
@rtg.map_ubuf = internal thread_local global [32 x i8] zeroinitializer, align 16
@.s8285 = private unnamed_addr constant [2 x i8] c"?\00"
@.s8289 = private unnamed_addr constant [4 x i8] c"Str\00"
@.s8293 = private unnamed_addr constant [1 x i8] c"\00"
@.s8298 = private unnamed_addr constant [2 x i8] c"?\00"
@.s8396 = private unnamed_addr constant [4 x i8] c"Str\00"
@.s8400 = private unnamed_addr constant [4 x i8] c"Str\00"
@rtg.map_edit_seq = internal global [8 x i8] zeroinitializer, align 16
@rtg.map_one = internal global [8 x i8] zeroinitializer, align 16
@rtg.map_base = internal thread_local global [24 x i8] zeroinitializer, align 16
@rtg.map_own = internal thread_local global [16 x i8] zeroinitializer, align 16
@rtg.map_own_seq = internal global [8 x i8] zeroinitializer, align 16
@rtg.map_one_elem = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s10809 = private unnamed_addr constant [5 x i8] c"list\00"
@.s10817 = private unnamed_addr constant [5 x i8] c"list\00"
@.s10835 = private unnamed_addr constant [5 x i8] c"true\00"
@.s10837 = private unnamed_addr constant [6 x i8] c"false\00"
@.s10845 = private unnamed_addr constant [3 x i8] c", \00"
@.s10854 = private unnamed_addr constant [3 x i8] c": \00"
@.s10873 = private unnamed_addr constant [2 x i8] c"{\00"
@.s10877 = private unnamed_addr constant [2 x i8] c"}\00"
@.s11082 = private unnamed_addr constant [2 x i8] c"{\00"
@.s11086 = private unnamed_addr constant [2 x i8] c"}\00"
