declare ptr @malloc(i64)
declare void @free(ptr)
declare i64 @resid_arena_push()
declare i64 @resid_arena_pop()
declare ptr @resid_list_str_persist_copy(ptr)
declare ptr @resid_list_const_i64(ptr, i64, ptr, ptr)
declare ptr @resid_list_const_ptr(ptr, i64, ptr, ptr)
declare ptr @resid_list_const_bool(ptr, i64, ptr, ptr)
declare i64 @resid_crypto_random_byte()
declare i8 @resid_cpu_has_aesni()
declare <2 x i64> @llvm.x86.aesni.aesenc(<2 x i64>, <2 x i64>)
declare <2 x i64> @llvm.x86.aesni.aesenclast(<2 x i64>, <2 x i64>)
declare i64 @resid_tcp_connect(ptr, i64)
declare i8 @resid_tcp_send(i64, ptr)
declare ptr @resid_tcp_recv_all(i64)
declare i8 @resid_tcp_close(i64)
declare ptr @bl_str_split(ptr, ptr)
declare ptr @bl_str_join(ptr, ptr)
declare ptr @resid_list_new(i64, ptr, ptr)
declare i64 @resid_list_len(ptr)
declare ptr @resid_list_get(ptr, i64)
declare ptr @resid_list_get_nc(ptr, i64)
declare ptr @resid_list_concat(ptr, ptr)
declare ptr @resid_list_push(ptr, ptr)
declare ptr @resid_listbuf_new()
declare ptr @resid_listbuf_push(ptr, ptr)
declare ptr @resid_listbuf_finish(ptr, ptr)
declare ptr @resid_list_slice(ptr, i64, i64)
declare ptr @resid_range_list(i64, i64)
declare ptr @resid_range_list_incl(i64, i64)
declare ptr @list_sort_ints(ptr)
declare ptr @list_sort_floats(ptr)
declare ptr @list_sort_strs(ptr)
declare ptr @list_reverse_ints(ptr)
declare ptr @list_reverse_strs(ptr)
declare ptr @list_reverse_floats(ptr)
declare i8 @list_contains_int(ptr, i64)
declare i8 @list_contains_str(ptr, ptr)
declare i8 @list_contains_float(ptr, double)
declare i64 @list_sum(ptr)
declare double @list_sumf(ptr)
declare ptr @list_sort_by(ptr, ptr)
declare ptr @resid_set_new()
declare ptr @resid_map_get(ptr, ptr)
declare ptr @resid_map_insert(ptr, ptr, ptr)
declare ptr @resid_map_remove(ptr, ptr)
declare i8 @resid_map_contains(ptr, ptr)
declare i64 @resid_map_len(ptr)
declare ptr @resid_map_keys(ptr)
declare ptr @resid_map_values(ptr)
declare ptr @resid_map_format(ptr)
declare ptr @resid_set_insert(ptr, ptr)
declare ptr @resid_set_remove(ptr, ptr)
declare i8 @resid_set_contains(ptr, ptr)
declare i64 @resid_set_len(ptr)
declare ptr @resid_set_union(ptr, ptr)
declare ptr @resid_set_difference(ptr, ptr)
declare ptr @resid_set_intersection(ptr, ptr)
declare ptr @resid_set_to_list(ptr)
declare ptr @resid_set_format(ptr)
declare void @resid_assert(i8, ptr)
declare void @resid_todo(i8, ptr)
declare ptr @resid_box_new(i64, i64, ptr, ptr)
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
declare ptr @resid_str_from_codepoints(ptr)
declare void @resid_index_abort(i64, i64, ptr) noreturn
declare void @resid_abort(ptr) noreturn
declare void @resid_expect_fail(ptr, ptr, ptr) noreturn
declare void @llvm.memmove.p0.p0.i64(ptr, ptr, i64, i1)
declare void @llvm.memset.p0.i64(ptr, i8, i64, i1)
declare ptr @llvm.threadlocal.address.p0(ptr)
declare i8 @resid_expect_throws(ptr)
declare i64 @resid_box_tag(ptr)
declare i8 @resid_test_plan(i64, ptr)
declare i64 @resid_test_run_closure(ptr, ptr)
declare i64 @resid_test_run(ptr, ptr)
declare i64 @resid_test_summary()
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
declare ptr @resid_decp_from_str(ptr, i64)
declare ptr @resid_decp_from_i64(i64, i64)
declare ptr @resid_decp_round(ptr, i64)
declare ptr @resid_decp_add(ptr, ptr, i64)
declare ptr @resid_decp_sub(ptr, ptr, i64)
declare ptr @resid_decp_mul(ptr, ptr, i64)
declare ptr @resid_decp_div(ptr, ptr, i64)
declare ptr @resid_decp_neg(ptr)
declare i64 @resid_decp_cmp(ptr, ptr)
declare ptr @resid_decp_to_str(ptr, i8)
declare i64 @resid_decp_to_i64(ptr)
declare double @resid_decp_to_f64(ptr)
declare ptr @resid_spawn(ptr, ptr)
declare ptr @resid_ok_box(ptr)
declare ptr @resid_gmalloc(i64)
declare void @resid_gfree(ptr)
declare i64 @resid_bulk_push()
declare i64 @resid_bulk_pop()
declare i64 @resid_mem_mark()
declare i64 @resid_mem_since_mark()
declare ptr @resid_decp_persist(ptr)
declare i64 @resid_scope_push()
declare void @resid_scope_pop(i64)
declare ptr @resid_box_alloc(i64, i64, ptr)
declare ptr @resid_map_transient(ptr)
declare ptr @resid_map_freeze(ptr)
declare ptr @resid_map_put(ptr, i8, i8, i64, i8, i64)
declare ptr @resid_map_del(ptr, i8, i8, i64)
declare ptr @resid_set_put(ptr, i8, i8, i64)
declare {i64, i64} @resid_map_find(ptr, i8, i64, i8)
declare i8 @resid_map_has(ptr, i8, i64)
declare ptr @resid_rec_new(i64, i8)
declare ptr @resid_rec_reuse(ptr, i64)
declare void @resid_rec_share(ptr)
declare ptr @resid_str_keep(ptr)
declare ptr @resid_map_evac(ptr, i8, i8)
declare ptr @resid_list_evac(ptr)
declare ptr @resid_dec_evac(ptr)
declare void @resid_carry_free(i8, ptr)
declare ptr @resid_map_list_push(ptr, i8, i8, i64, ptr, ptr)
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
define internal i64 @case_lower_tab() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1403 = ptrtoint ptr @rtt.8354 to i64
ret i64 %t1403
}
define internal i64 @case_lower_n() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 1459
}
define internal i64 @case_upper_tab() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1404 = ptrtoint ptr @rtt.11265 to i64
ret i64 %t1404
}
define internal i64 @case_upper_n() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 1450
}
define internal i64 @case_special_tab() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1405 = ptrtoint ptr @rtt.12189 to i64
ret i64 %t1405
}
define internal i64 @case_special_n() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 83
}
define internal i64 @__mruntime_rt_case_resid__case_lookup(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1406 = sub i64 %p1, 1
%t1407 = call i64 @__mruntime_rt_case_resid__case_bs(i64 %p0, i64 %p2, i64 0, i64 %t1406)
ret i64 %t1407
}
define internal i64 @__mruntime_rt_case_resid__case_bs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %t1423, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1421, %tco.s0 ], [ %p3, %tco.s1 ]
%t1408 = icmp sgt i64 %p2, %p3
br i1 %t1408, label %L532, label %L534
L532:
ret i64 0
L534:
%t1409 = sub i64 %p3, %p2
%t1410 = sdiv i64 %t1409, 2
%t1411 = add i64 %p2, %t1410
%t1412 = mul i64 %t1411, 16
%t1413 = add i64 %p0, %t1412
%t1414 = call i64 @ld64(i64 %t1413)
%t1415 = icmp eq i64 %p1, %t1414
br i1 %t1415, label %L535, label %L537
L535:
%t1416 = mul i64 %t1411, 16
%t1417 = add i64 %p0, %t1416
%t1418 = add i64 %t1417, 8
%t1419 = call i64 @ld64(i64 %t1418)
ret i64 %t1419
L537:
%t1420 = icmp slt i64 %p1, %t1414
br i1 %t1420, label %L538, label %L540
L538:
%t1421 = sub i64 %t1411, 1
br label %tco.s0
tco.s0:
br label %tco.head
L540:
%t1423 = add i64 %t1411, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @case_simple(i64 %p0, i1 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br i1 %p1, label %L541, label %L542
L541:
%t1425 = call i64 @case_lower_tab()
%t1426 = call i64 @case_lower_n()
%t1427 = call i64 @__mruntime_rt_case_resid__case_lookup(i64 %t1425, i64 %t1426, i64 %p0)
br label %L543
L542:
%t1428 = call i64 @case_upper_tab()
%t1429 = call i64 @case_upper_n()
%t1430 = call i64 @__mruntime_rt_case_resid__case_lookup(i64 %t1428, i64 %t1429, i64 %p0)
br label %L543
L543:
%t1431 = phi i64 [ %t1427, %L541 ], [ %t1430, %L542 ]
%t1432 = icmp ne i64 %t1431, 0
br i1 %t1432, label %L544, label %L545
L544:
br label %L546
L545:
br label %L546
L546:
%t1433 = phi i64 [ %t1431, %L544 ], [ %p0, %L545 ]
ret i64 %t1433
}
define internal i64 @__mruntime_rt_case_resid__special_upper(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1434 = call i64 @case_special_tab()
%t1435 = call i64 @case_special_n()
%t1436 = sub i64 %t1435, 1
%t1437 = call i64 @__mruntime_rt_case_resid__special_bs(i64 %t1434, i64 %p0, i64 0, i64 %t1436)
ret i64 %t1437
}
define internal i64 @__mruntime_rt_case_resid__special_bs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %t1449, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1447, %tco.s0 ], [ %p3, %tco.s1 ]
%t1438 = icmp sgt i64 %p2, %p3
br i1 %t1438, label %L547, label %L549
L547:
ret i64 0
L549:
%t1439 = sub i64 %p3, %p2
%t1440 = sdiv i64 %t1439, 2
%t1441 = add i64 %p2, %t1440
%t1442 = mul i64 %t1441, 88
%t1443 = add i64 %p0, %t1442
%t1444 = call i64 @ld64(i64 %t1443)
%t1445 = icmp eq i64 %p1, %t1444
br i1 %t1445, label %L550, label %L552
L550:
ret i64 %t1443
L552:
%t1446 = icmp slt i64 %p1, %t1444
br i1 %t1446, label %L553, label %L555
L553:
%t1447 = sub i64 %t1441, 1
br label %tco.s0
tco.s0:
br label %tco.head
L555:
%t1449 = add i64 %t1441, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i1 @__mruntime_rt_case_resid__is_cased(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1451 = call i64 @case_lower_tab()
%t1452 = call i64 @case_lower_n()
%t1453 = call i64 @__mruntime_rt_case_resid__case_lookup(i64 %t1451, i64 %t1452, i64 %p0)
%t1454 = icmp ne i64 %t1453, 0
br label %LSL1455
LSL1455:
br i1 %t1454, label %LSJ1455, label %LSR1455
LSR1455:
%t1456 = call i64 @case_upper_tab()
%t1457 = call i64 @case_upper_n()
%t1458 = call i64 @__mruntime_rt_case_resid__case_lookup(i64 %t1456, i64 %t1457, i64 %p0)
%t1459 = icmp ne i64 %t1458, 0
br label %LSJ1455
LSJ1455:
%t1460 = phi i1 [ true, %LSL1455 ], [ %t1459, %LSR1455 ]
ret i1 %t1460
}
define internal i1 @__mruntime_rt_case_resid__is_ignorable(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1461 = call i1 @__mruntime_rt_case_resid__is_cased(i64 %p0)
br i1 %t1461, label %L556, label %L558
L556:
ret i1 false
L558:
%t1462 = icmp sge i64 %p0, 768
br label %LSL1463
LSL1463:
br i1 %t1462, label %LSR1463, label %LSJ1463
LSR1463:
%t1464 = icmp sle i64 %p0, 879
br label %LSJ1463
LSJ1463:
%t1465 = phi i1 [ false, %LSL1463 ], [ %t1464, %LSR1463 ]
br label %LSL1466
LSL1466:
br i1 %t1465, label %LSJ1466, label %LSR1466
LSR1466:
%t1467 = icmp sge i64 %p0, 1155
br label %LSL1468
LSL1468:
br i1 %t1467, label %LSR1468, label %LSJ1468
LSR1468:
%t1469 = icmp sle i64 %p0, 1161
br label %LSJ1468
LSJ1468:
%t1470 = phi i1 [ false, %LSL1468 ], [ %t1469, %LSR1468 ]
br label %LSJ1466
LSJ1466:
%t1471 = phi i1 [ true, %LSL1466 ], [ %t1470, %LSJ1468 ]
br label %LSL1472
LSL1472:
br i1 %t1471, label %LSJ1472, label %LSR1472
LSR1472:
%t1473 = icmp sge i64 %p0, 1425
br label %LSL1474
LSL1474:
br i1 %t1473, label %LSR1474, label %LSJ1474
LSR1474:
%t1475 = icmp sle i64 %p0, 1469
br label %LSJ1474
LSJ1474:
%t1476 = phi i1 [ false, %LSL1474 ], [ %t1475, %LSR1474 ]
br label %LSJ1472
LSJ1472:
%t1477 = phi i1 [ true, %LSL1472 ], [ %t1476, %LSJ1474 ]
br label %LSL1478
LSL1478:
br i1 %t1477, label %LSJ1478, label %LSR1478
LSR1478:
%t1479 = icmp sge i64 %p0, 1552
br label %LSL1480
LSL1480:
br i1 %t1479, label %LSR1480, label %LSJ1480
LSR1480:
%t1481 = icmp sle i64 %p0, 1562
br label %LSJ1480
LSJ1480:
%t1482 = phi i1 [ false, %LSL1480 ], [ %t1481, %LSR1480 ]
br label %LSJ1478
LSJ1478:
%t1483 = phi i1 [ true, %LSL1478 ], [ %t1482, %LSJ1480 ]
br label %LSL1484
LSL1484:
br i1 %t1483, label %LSJ1484, label %LSR1484
LSR1484:
%t1485 = icmp sge i64 %p0, 1611
br label %LSL1486
LSL1486:
br i1 %t1485, label %LSR1486, label %LSJ1486
LSR1486:
%t1487 = icmp sle i64 %p0, 1631
br label %LSJ1486
LSJ1486:
%t1488 = phi i1 [ false, %LSL1486 ], [ %t1487, %LSR1486 ]
br label %LSJ1484
LSJ1484:
%t1489 = phi i1 [ true, %LSL1484 ], [ %t1488, %LSJ1486 ]
br label %LSL1490
LSL1490:
br i1 %t1489, label %LSJ1490, label %LSR1490
LSR1490:
%t1491 = icmp sge i64 %p0, 3633
br label %LSL1492
LSL1492:
br i1 %t1491, label %LSR1492, label %LSJ1492
LSR1492:
%t1493 = icmp sle i64 %p0, 3642
br label %LSJ1492
LSJ1492:
%t1494 = phi i1 [ false, %LSL1492 ], [ %t1493, %LSR1492 ]
br label %LSJ1490
LSJ1490:
%t1495 = phi i1 [ true, %LSL1490 ], [ %t1494, %LSJ1492 ]
br label %LSL1496
LSL1496:
br i1 %t1495, label %LSJ1496, label %LSR1496
LSR1496:
%t1497 = icmp sge i64 %p0, 8204
br label %LSL1498
LSL1498:
br i1 %t1497, label %LSR1498, label %LSJ1498
LSR1498:
%t1499 = icmp sle i64 %p0, 8207
br label %LSJ1498
LSJ1498:
%t1500 = phi i1 [ false, %LSL1498 ], [ %t1499, %LSR1498 ]
br label %LSJ1496
LSJ1496:
%t1501 = phi i1 [ true, %LSL1496 ], [ %t1500, %LSJ1498 ]
br label %LSL1502
LSL1502:
br i1 %t1501, label %LSJ1502, label %LSR1502
LSR1502:
%t1503 = icmp sge i64 %p0, 65024
br label %LSL1504
LSL1504:
br i1 %t1503, label %LSR1504, label %LSJ1504
LSR1504:
%t1505 = icmp sle i64 %p0, 65039
br label %LSJ1504
LSJ1504:
%t1506 = phi i1 [ false, %LSL1504 ], [ %t1505, %LSR1504 ]
br label %LSJ1502
LSJ1502:
%t1507 = phi i1 [ true, %LSL1502 ], [ %t1506, %LSJ1504 ]
ret i1 %t1507
}
define internal i1 @__mruntime_rt_case_resid__prev_cased(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1510, %tco.s0 ]
%t1508 = icmp sle i64 %p1, %p0
br i1 %t1508, label %L559, label %L561
L559:
ret i1 false
L561:
%t1509 = sub nsw i64 %p1, 1
%t1510 = call i64 @__mruntime_rt_case_resid__back_lead(i64 %p0, i64 %t1509)
%t1511 = sub i64 %p1, %t1510
%t1512 = call i64 @utf8_decode(i64 %t1510, i64 %t1511)
%t1513 = call i1 @__mruntime_rt_case_resid__is_ignorable(i64 %t1512)
%t1514 = xor i1 %t1513, true
br i1 %t1514, label %L562, label %L564
L562:
%t1515 = call i1 @__mruntime_rt_case_resid__is_cased(i64 %t1512)
ret i1 %t1515
L564:
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_case_resid__back_lead(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1527, %tco.s0 ]
%t1517 = call i64 @ld8(i64 %p1)
%t1518 = and i64 %t1517, 128
%t1519 = icmp eq i64 %t1518, 0
br i1 %t1519, label %L565, label %L567
L565:
ret i64 %p1
L567:
%t1520 = icmp sgt i64 %p1, %p0
br label %LSL1521
LSL1521:
br i1 %t1520, label %LSR1521, label %LSJ1521
LSR1521:
%t1522 = sub nsw i64 %p1, 1
%t1523 = call i64 @ld8(i64 %t1522)
%t1524 = and i64 %t1523, 192
%t1525 = icmp eq i64 %t1524, 128
br label %LSJ1521
LSJ1521:
%t1526 = phi i1 [ false, %LSL1521 ], [ %t1525, %LSR1521 ]
br i1 %t1526, label %L568, label %L570
L568:
%t1527 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L570:
%t1529 = icmp sgt i64 %p1, %p0
br label %LSL1530
LSL1530:
br i1 %t1529, label %LSR1530, label %LSJ1530
LSR1530:
%t1531 = call i64 @ld8(i64 %p1)
%t1532 = and i64 %t1531, 192
%t1533 = icmp eq i64 %t1532, 128
br label %LSJ1530
LSJ1530:
%t1534 = phi i1 [ false, %LSL1530 ], [ %t1533, %LSR1530 ]
br i1 %t1534, label %L571, label %L572
L571:
%t1535 = sub nsw i64 %p1, 1
br label %L573
L572:
br label %L573
L573:
%t1536 = phi i64 [ %t1535, %L571 ], [ %p1, %L572 ]
ret i64 %t1536
}
define internal i1 @__mruntime_rt_case_resid__next_cased(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1544, %tco.s0 ]
%t1537 = call i64 @ld8(i64 %p0)
%t1538 = icmp eq i64 %t1537, 0
br i1 %t1538, label %L574, label %L576
L574:
ret i1 false
L576:
%t1539 = call i64 @utf8_len_at(i64 %p0)
%t1540 = call i64 @utf8_decode(i64 %p0, i64 %t1539)
%t1541 = call i1 @__mruntime_rt_case_resid__is_ignorable(i64 %t1540)
%t1542 = xor i1 %t1541, true
br i1 %t1542, label %L577, label %L579
L577:
%t1543 = tail call i1 @__mruntime_rt_case_resid__is_cased(i64 %t1540)
ret i1 %t1543
L579:
%t1544 = add i64 %p0, %t1539
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_case_resid__lower_at(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1560, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1562, %tco.s0 ]
%t1546 = call i64 @ld8(i64 %p1)
%t1547 = icmp eq i64 %t1546, 0
br i1 %t1547, label %L580, label %L582
L580:
ret i64 %p2
L582:
%t1548 = call i64 @utf8_len_at(i64 %p1)
%t1549 = call i64 @utf8_decode(i64 %p1, i64 %t1548)
%t1550 = icmp eq i64 %t1549, 931
br i1 %t1550, label %L583, label %L584
L583:
%t1551 = call i1 @__mruntime_rt_case_resid__prev_cased(i64 %p0, i64 %p1)
br label %LSL1552
LSL1552:
br i1 %t1551, label %LSR1552, label %LSJ1552
LSR1552:
%t1553 = add i64 %p1, %t1548
%t1554 = call i1 @__mruntime_rt_case_resid__next_cased(i64 %t1553)
%t1555 = xor i1 %t1554, true
br label %LSJ1552
LSJ1552:
%t1556 = phi i1 [ false, %LSL1552 ], [ %t1555, %LSR1552 ]
br i1 %t1556, label %L586, label %L587
L586:
br label %L588
L587:
br label %L588
L588:
%t1557 = phi i64 [ 962, %L586 ], [ 963, %L587 ]
br label %L585
L584:
%t1558 = call i64 @case_simple(i64 %t1549, i1 true)
br label %L585
L585:
%t1559 = phi i64 [ %t1557, %L588 ], [ %t1558, %L584 ]
%t1560 = add i64 %p1, %t1548
%t1561 = call i64 @utf8_encode(i64 %t1559, i64 %p2)
%t1562 = add i64 %p2, %t1561
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_to_lower(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1564 = call i64 @rt_str_len(i64 %p0)
%t1565 = mul i64 %t1564, 4
%t1566 = add i64 %t1565, 8
%t1567 = call i64 @xmalloc(i64 %t1566)
%t1568 = call i64 @__mruntime_rt_case_resid__lower_at(i64 %p0, i64 %p0, i64 %t1567)
%t1569 = call i64 @st8(i64 %t1568, i64 0)
ret i64 %t1567
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
%p0 = phi i64 [ %p0.in, %entry ], [ %t1583, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1584, %tco.s0 ]
%t1570 = call i64 @ld8(i64 %p0)
%t1571 = icmp eq i64 %t1570, 0
br i1 %t1571, label %L589, label %L591
L589:
ret i64 %p1
L591:
%t1572 = call i64 @utf8_len_at(i64 %p0)
%t1573 = call i64 @utf8_decode(i64 %p0, i64 %t1572)
%t1574 = call i64 @__mruntime_rt_case_resid__special_upper(i64 %t1573)
%t1575 = icmp ne i64 %t1574, 0
br i1 %t1575, label %L592, label %L593
L592:
%t1576 = add i64 %t1574, 16
%t1577 = add i64 %t1574, 8
%t1578 = call i64 @ld64(i64 %t1577)
%t1579 = call i64 @__mruntime_rt_case_resid__copy_words(i64 %p1, i64 %t1576, i64 %t1578)
br label %L594
L593:
%t1580 = call i64 @case_simple(i64 %t1573, i1 false)
%t1581 = call i64 @utf8_encode(i64 %t1580, i64 %p1)
br label %L594
L594:
%t1582 = phi i64 [ %t1579, %L592 ], [ %t1581, %L593 ]
%t1583 = add i64 %p0, %t1572
%t1584 = add i64 %p1, %t1582
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_case_resid__copy_words(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1586 = call i64 @__mruntime_rt_case_resid__copy_words_at(i64 %p0, i64 %p1, i64 0, i64 %p2)
ret i64 %p2
}
define internal i64 @__mruntime_rt_case_resid__copy_words_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1593, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t1587 = icmp sge i64 %p2, %p3
br i1 %t1587, label %L595, label %L597
L595:
ret i64 0
L597:
%t1588 = add i64 %p0, %p2
%t1589 = mul i64 %p2, 8
%t1590 = add i64 %p1, %t1589
%t1591 = call i64 @ld64(i64 %t1590)
%t1592 = call i64 @st8(i64 %t1588, i64 %t1591)
%t1593 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_to_upper(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1595 = call i64 @rt_str_len(i64 %p0)
%t1596 = mul i64 %t1595, 9
%t1597 = add i64 %t1596, 8
%t1598 = call i64 @xmalloc(i64 %t1597)
%t1599 = call i64 @__mruntime_rt_case_resid__upper_at(i64 %p0, i64 %t1598)
%t1600 = call i64 @st8(i64 %t1599, i64 0)
ret i64 %t1598
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
%t1601 = icmp ne i64 %p1, 0
%t1602 = call i64 @case_simple(i64 %p0, i1 %t1601)
ret i64 %t1602
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
%t1603 = icmp eq i64 %p0, 32
br label %LSL1604
LSL1604:
br i1 %t1603, label %LSJ1604, label %LSR1604
LSR1604:
%t1605 = icmp eq i64 %p0, 9
br label %LSJ1604
LSJ1604:
%t1606 = phi i1 [ true, %LSL1604 ], [ %t1605, %LSR1604 ]
br label %LSL1607
LSL1607:
br i1 %t1606, label %LSJ1607, label %LSR1607
LSR1607:
%t1608 = icmp eq i64 %p0, 10
br label %LSJ1607
LSJ1607:
%t1609 = phi i1 [ true, %LSL1607 ], [ %t1608, %LSR1607 ]
br label %LSL1610
LSL1610:
br i1 %t1609, label %LSJ1610, label %LSR1610
LSR1610:
%t1611 = icmp eq i64 %p0, 13
br label %LSJ1610
LSJ1610:
%t1612 = phi i1 [ true, %LSL1610 ], [ %t1611, %LSR1610 ]
br label %LSL1613
LSL1613:
br i1 %t1612, label %LSJ1613, label %LSR1613
LSR1613:
%t1614 = icmp eq i64 %p0, 11
br label %LSJ1613
LSJ1613:
%t1615 = phi i1 [ true, %LSL1613 ], [ %t1614, %LSR1613 ]
br label %LSL1616
LSL1616:
br i1 %t1615, label %LSJ1616, label %LSR1616
LSR1616:
%t1617 = icmp eq i64 %p0, 12
br label %LSJ1616
LSJ1616:
%t1618 = phi i1 [ true, %LSL1616 ], [ %t1617, %LSR1616 ]
ret i1 %t1618
}
define internal i64 @__mruntime_rt_strutil_resid__skip_space(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1624, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%t1619 = icmp slt i64 %p0, %p1
br label %LSL1620
LSL1620:
br i1 %t1619, label %LSR1620, label %LSJ1620
LSR1620:
%t1621 = call i64 @ld8(i64 %p0)
%t1622 = call i1 @__mruntime_rt_strutil_resid__is_space(i64 %t1621)
br label %LSJ1620
LSJ1620:
%t1623 = phi i1 [ false, %LSL1620 ], [ %t1622, %LSR1620 ]
br i1 %t1623, label %L598, label %L600
L598:
%t1624 = add nsw i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
L600:
ret i64 %p0
}
define internal i64 @__mruntime_rt_strutil_resid__back_space(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1632, %tco.s0 ]
%t1626 = icmp sgt i64 %p1, %p0
br label %LSL1627
LSL1627:
br i1 %t1626, label %LSR1627, label %LSJ1627
LSR1627:
%t1628 = sub nsw i64 %p1, 1
%t1629 = call i64 @ld8(i64 %t1628)
%t1630 = call i1 @__mruntime_rt_strutil_resid__is_space(i64 %t1629)
br label %LSJ1627
LSJ1627:
%t1631 = phi i1 [ false, %LSL1627 ], [ %t1630, %LSR1627 ]
br i1 %t1631, label %L601, label %L603
L601:
%t1632 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L603:
ret i64 %p1
}
define internal i64 @rt_str_trim(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1634 = call i64 @c_strlen(i64 %p0)
%t1635 = add i64 %p0, %t1634
%t1636 = call i64 @__mruntime_rt_strutil_resid__skip_space(i64 %p0, i64 %t1635)
%t1637 = call i64 @c_strlen(i64 %p0)
%t1638 = add i64 %p0, %t1637
%t1639 = call i64 @__mruntime_rt_strutil_resid__back_space(i64 %t1636, i64 %t1638)
%t1640 = sub i64 %t1639, %t1636
%t1641 = call i64 @cstr_from(i64 %t1636, i64 %t1640, i64 0)
ret i64 %t1641
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
%t1642 = call i64 @c_strstr(i64 %p0, i64 %p1)
%t1643 = icmp ne i64 %t1642, 0
br i1 %t1643, label %L604, label %L605
L604:
br label %L606
L605:
br label %L606
L606:
%t1644 = phi i64 [ 1, %L604 ], [ 0, %L605 ]
ret i64 %t1644
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
%t1645 = call i64 @c_strlen(i64 %p1)
%t1646 = call i64 @c_strncmp(i64 %p0, i64 %p1, i64 %t1645)
%t1647 = icmp eq i64 %t1646, 0
br i1 %t1647, label %L607, label %L608
L607:
br label %L609
L608:
br label %L609
L609:
%t1648 = phi i64 [ 1, %L607 ], [ 0, %L608 ]
ret i64 %t1648
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
%t1649 = call i64 @c_strlen(i64 %p0)
%t1650 = call i64 @c_strlen(i64 %p1)
%t1651 = icmp sgt i64 %t1650, %t1649
br i1 %t1651, label %L610, label %L612
L610:
ret i64 0
L612:
%t1652 = add i64 %p0, %t1649
%t1653 = sub i64 %t1652, %t1650
%t1654 = call i64 @c_strcmp(i64 %t1653, i64 %p1)
%t1655 = icmp eq i64 %t1654, 0
br i1 %t1655, label %L613, label %L614
L613:
br label %L615
L614:
br label %L615
L615:
%t1656 = phi i64 [ 1, %L613 ], [ 0, %L614 ]
ret i64 %t1656
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
%t1657 = icmp slt i64 %p1, 0
br i1 %t1657, label %L616, label %L617
L616:
br label %L618
L617:
br label %L618
L618:
%t1658 = phi i64 [ 0, %L616 ], [ %p1, %L617 ]
%t1659 = call i64 @c_strlen(i64 %p0)
%t1660 = icmp sgt i64 %t1659, 0
br label %LSL1661
LSL1661:
br i1 %t1660, label %LSR1661, label %LSJ1661
LSR1661:
%t1662 = sdiv i64 9223372036854775807, %t1659
%t1663 = icmp sgt i64 %t1658, %t1662
br label %LSJ1661
LSJ1661:
%t1664 = phi i1 [ false, %LSL1661 ], [ %t1663, %LSR1661 ]
br i1 %t1664, label %L619, label %L621
L619:
%t1665 = call i64 @cstr_from(i64 %p0, i64 0, i64 0)
ret i64 %t1665
L621:
%t1666 = mul i64 %t1659, %t1658
%t1667 = add i64 %t1666, 1
%t1668 = call i64 @c_malloc(i64 %t1667)
%t1669 = icmp eq i64 %t1668, 0
br i1 %t1669, label %L622, label %L624
L622:
%t1670 = call i64 @cstr_from(i64 %p0, i64 0, i64 0)
ret i64 %t1670
L624:
%t1671 = call i64 @__mruntime_rt_strutil_resid__repeat_at(i64 %t1668, i64 %p0, i64 %t1659, i64 %t1658)
%t1672 = call i64 @st8(i64 %t1671, i64 0)
ret i64 %t1668
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
%p0 = phi i64 [ %p0.in, %entry ], [ %t1675, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1676, %tco.s0 ]
%t1673 = icmp sle i64 %p3, 0
br i1 %t1673, label %L625, label %L627
L625:
ret i64 %p0
L627:
%t1674 = call i64 @mcopy(i64 %p0, i64 %p1, i64 %p2)
%t1675 = add i64 %p0, %p2
%t1676 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_strutil_resid__count_hits(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1680, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1681, %tco.s0 ]
%t1678 = call i64 @c_strstr(i64 %p0, i64 %p1)
%t1679 = icmp eq i64 %t1678, 0
br i1 %t1679, label %L628, label %L630
L628:
ret i64 %p3
L630:
%t1680 = add i64 %t1678, %p2
%t1681 = add i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_replace(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1683 = call i64 @c_strlen(i64 %p1)
%t1684 = call i64 @c_strlen(i64 %p2)
%t1685 = icmp eq i64 %t1683, 0
br i1 %t1685, label %L631, label %L633
L631:
%t1686 = call i64 @cstr_dup(i64 %p0)
ret i64 %t1686
L633:
%t1687 = call i64 @__mruntime_rt_strutil_resid__count_hits(i64 %p0, i64 %p1, i64 %t1683, i64 0)
%t1688 = call i64 @c_strlen(i64 %p0)
%t1689 = icmp sgt i64 %t1684, %t1683
br i1 %t1689, label %L634, label %L635
L634:
%t1690 = sub i64 %t1684, %t1683
%t1691 = mul i64 %t1687, %t1690
br label %L636
L635:
br label %L636
L636:
%t1692 = phi i64 [ %t1691, %L634 ], [ 0, %L635 ]
%t1693 = add i64 %t1688, %t1692
%t1694 = add i64 %t1693, 1
%t1695 = call i64 @xmalloc(i64 %t1694)
%t1696 = call i64 @__mruntime_rt_strutil_resid__replace_at(i64 %t1695, i64 %p0, i64 %p1, i64 %t1683, i64 %p2, i64 %t1684)
ret i64 %t1695
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
%p0 = phi i64 [ %p0.in, %entry ], [ %t1711, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1712, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t1697 = call i64 @c_strstr(i64 %p1, i64 %p2)
%t1698 = icmp eq i64 %t1697, 0
br i1 %t1698, label %L637, label %L639
L637:
%t1699 = call i64 @c_strlen(i64 %p1)
%t1700 = add i64 %t1699, 1
%t1701 = call i64 @mcopy(i64 %p0, i64 %p1, i64 %t1700)
%t1702 = add i64 %t1701, %p0
%t1703 = add i64 %t1702, %t1699
ret i64 %t1703
L639:
%t1704 = sub i64 %t1697, %p1
%t1705 = call i64 @mcopy(i64 %p0, i64 %p1, i64 %t1704)
%t1706 = sub i64 %t1697, %p1
%t1707 = add i64 %p0, %t1706
%t1708 = call i64 @mcopy(i64 %t1707, i64 %p4, i64 %p5)
%t1709 = sub i64 %t1697, %p1
%t1710 = add i64 %p0, %t1709
%t1711 = add i64 %t1710, %p5
%t1712 = add i64 %t1697, %p3
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_split(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1715 = ptrtoint ptr @.s1714 to i64
%t1716 = call i64 @c_strlen(i64 %p1)
%t1717 = icmp eq i64 %t1716, 0
br i1 %t1717, label %L640, label %L642
L640:
%t1718p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.split_one)
%t1718 = ptrtoint ptr %t1718p to i64
%t1719 = call i64 @st64(i64 %t1718, i64 %p0)
%t1720 = call i64 @c_list_new(i64 1, i64 %t1718, i64 %t1715)
ret i64 %t1720
L642:
%t1721 = call i64 @__mruntime_rt_strutil_resid__count_hits(i64 %p0, i64 %p1, i64 %t1716, i64 0)
%t1722 = add i64 %t1721, 1
%t1723 = mul i64 %t1722, 8
%t1724 = call i64 @xmalloc(i64 %t1723)
%t1725 = call i64 @__mruntime_rt_strutil_resid__split_at(i64 %t1724, i64 0, i64 %p0, i64 %p1, i64 %t1716)
%t1726 = call i64 @c_list_new(i64 %t1722, i64 %t1724, i64 %t1715)
%t1727 = call i64 @c_free(i64 %t1724)
ret i64 %t1726
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t1739, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1740, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t1728 = call i64 @c_strstr(i64 %p2, i64 %p3)
%t1729 = icmp eq i64 %t1728, 0
br i1 %t1729, label %L643, label %L645
L643:
%t1730 = mul i64 %p1, 8
%t1731 = add i64 %p0, %t1730
%t1732 = call i64 @cstr_dup(i64 %p2)
%t1733 = call i64 @st64(i64 %t1731, i64 %t1732)
ret i64 %t1733
L645:
%t1734 = mul i64 %p1, 8
%t1735 = add i64 %p0, %t1734
%t1736 = sub i64 %t1728, %p2
%t1737 = call i64 @cstr_from(i64 %p2, i64 %t1736, i64 0)
%t1738 = call i64 @st64(i64 %t1735, i64 %t1737)
%t1739 = add i64 %p1, 1
%t1740 = add i64 %t1728, %p4
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_join(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1742 = call i64 @c_list_len(i64 %p0)
%t1743 = call i64 @c_list_to_array(i64 %p0)
%t1744 = call i64 @c_strlen(i64 %p1)
%t1745 = call i64 @__mruntime_rt_strutil_resid__join_len(i64 %t1743, i64 0, i64 %t1742, i64 0)
%t1746 = icmp sgt i64 %t1742, 0
br i1 %t1746, label %L646, label %L647
L646:
%t1747 = sub nsw i64 %t1742, 1
%t1748 = mul i64 %t1744, %t1747
br label %L648
L647:
br label %L648
L648:
%t1749 = phi i64 [ %t1748, %L646 ], [ 0, %L647 ]
%t1750 = add i64 %t1745, %t1749
%t1751 = add i64 %t1750, 1
%t1752 = call i64 @xmalloc(i64 %t1751)
%t1753 = call i64 @__mruntime_rt_strutil_resid__join_at(i64 %t1752, i64 %t1743, i64 0, i64 %t1742, i64 %p1, i64 %t1744)
%t1754 = call i64 @st8(i64 %t1753, i64 0)
%t1755 = call i64 @c_free(i64 %t1743)
ret i64 %t1752
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t1757, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1762, %tco.s0 ]
%t1756 = icmp sge i64 %p1, %p2
br i1 %t1756, label %L649, label %L651
L649:
ret i64 %p3
L651:
%t1757 = add nsw i64 %p1, 1
%t1758 = mul i64 %p1, 8
%t1759 = add i64 %p0, %t1758
%t1760 = call i64 @ld64(i64 %t1759)
%t1761 = call i64 @c_strlen(i64 %t1760)
%t1762 = add i64 %p3, %t1761
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_strutil_resid__join_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1775, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1776, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t1764 = icmp sge i64 %p2, %p3
br i1 %t1764, label %L652, label %L654
L652:
ret i64 %p0
L654:
%t1765 = icmp sgt i64 %p2, 0
br i1 %t1765, label %L655, label %L656
L655:
%t1766 = call i64 @mcopy(i64 %p0, i64 %p4, i64 %p5)
%t1767 = add i64 %t1766, %p0
%t1768 = add i64 %t1767, %p5
br label %L657
L656:
br label %L657
L657:
%t1769 = phi i64 [ %t1768, %L655 ], [ %p0, %L656 ]
%t1770 = mul i64 %p2, 8
%t1771 = add i64 %p1, %t1770
%t1772 = call i64 @ld64(i64 %t1771)
%t1773 = call i64 @c_strlen(i64 %t1772)
%t1774 = call i64 @mcopy(i64 %t1769, i64 %t1772, i64 %t1773)
%t1775 = add i64 %t1769, %t1773
%t1776 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_strutil_resid__all_digits(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1784, %tco.s0 ]
%t1778 = call i64 @ld8(i64 %p0)
%t1779 = icmp eq i64 %t1778, 0
br i1 %t1779, label %L658, label %L660
L658:
ret i1 true
L660:
%t1780 = icmp slt i64 %t1778, 48
br label %LSL1781
LSL1781:
br i1 %t1780, label %LSJ1781, label %LSR1781
LSR1781:
%t1782 = icmp sgt i64 %t1778, 57
br label %LSJ1781
LSJ1781:
%t1783 = phi i1 [ true, %LSL1781 ], [ %t1782, %LSR1781 ]
br i1 %t1783, label %L661, label %L663
L661:
ret i1 false
L663:
%t1784 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @is_int(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1786 = call i64 @ld8(i64 %p0)
%t1787 = icmp eq i64 %t1786, 0
br i1 %t1787, label %L664, label %L666
L664:
ret i1 false
L666:
%t1788 = icmp eq i64 %t1786, 45
br label %LSL1789
LSL1789:
br i1 %t1788, label %LSJ1789, label %LSR1789
LSR1789:
%t1790 = icmp eq i64 %t1786, 43
br label %LSJ1789
LSJ1789:
%t1791 = phi i1 [ true, %LSL1789 ], [ %t1790, %LSR1789 ]
br i1 %t1791, label %L667, label %L668
L667:
%t1792 = add i64 %p0, 1
br label %L669
L668:
br label %L669
L669:
%t1793 = phi i64 [ %t1792, %L667 ], [ %p0, %L668 ]
%t1794 = call i64 @ld8(i64 %t1793)
%t1795 = icmp ne i64 %t1794, 0
br label %LSL1796
LSL1796:
br i1 %t1795, label %LSR1796, label %LSJ1796
LSR1796:
%t1797 = call i1 @__mruntime_rt_strutil_resid__all_digits(i64 %t1793)
br label %LSJ1796
LSJ1796:
%t1798 = phi i1 [ false, %LSL1796 ], [ %t1797, %LSR1796 ]
ret i1 %t1798
}
define internal i64 @rt_str_is_int(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1799 = call i1 @is_int(i64 %p0)
br i1 %t1799, label %L670, label %L671
L670:
br label %L672
L671:
br label %L672
L672:
%t1800 = phi i64 [ 1, %L670 ], [ 0, %L671 ]
ret i64 %t1800
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
%t1801 = call i1 @is_int(i64 %p0)
%t1802 = xor i1 %t1801, true
br i1 %t1802, label %L673, label %L675
L673:
ret i64 0
L675:
%t1803 = call i64 @ld8(i64 %p0)
%t1804 = icmp eq i64 %t1803, 45
%t1805 = call i64 @ld8(i64 %p0)
%t1806 = icmp eq i64 %t1805, 45
br label %LSL1807
LSL1807:
br i1 %t1806, label %LSJ1807, label %LSR1807
LSR1807:
%t1808 = call i64 @ld8(i64 %p0)
%t1809 = icmp eq i64 %t1808, 43
br label %LSJ1807
LSJ1807:
%t1810 = phi i1 [ true, %LSL1807 ], [ %t1809, %LSR1807 ]
br i1 %t1810, label %L676, label %L677
L676:
%t1811 = add i64 %p0, 1
br label %L678
L677:
br label %L678
L678:
%t1812 = phi i64 [ %t1811, %L676 ], [ %p0, %L677 ]
%t1813 = call i64 @__mruntime_rt_strutil_resid__neg_digits(i64 %t1812, i64 0)
%t1814 = icmp eq i64 %t1813, 1
br i1 %t1814, label %L679, label %L681
L679:
br i1 %t1804, label %L682, label %L683
L682:
%t1815 = sext i64 0 to i128
%t1816 = sub i128 %t1815, 9223372036854775807
%t1817 = sext i64 1 to i128
%t1818 = sub i128 %t1816, %t1817
br label %L684
L683:
br label %L684
L684:
%t1819 = phi i128 [ %t1818, %L682 ], [ 9223372036854775807, %L683 ]
%t1820 = trunc i128 %t1819 to i64
ret i64 %t1820
L681:
br i1 %t1804, label %L685, label %L687
L685:
ret i64 %t1813
L687:
%t1821 = sext i64 0 to i128
%t1822 = sub i128 %t1821, 9223372036854775807
%t1823 = sext i64 1 to i128
%t1824 = sub i128 %t1822, %t1823
%t1825 = sext i64 %t1813 to i128
%t1826 = icmp eq i128 %t1825, %t1824
br i1 %t1826, label %L688, label %L690
L688:
%t1827 = trunc i128 9223372036854775807 to i64
ret i64 %t1827
L690:
%t1828 = sub i64 0, %t1813
ret i64 %t1828
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
%p0 = phi i64 [ %p0.in, %entry ], [ %t1840, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1842, %tco.s0 ]
%t1829 = call i64 @ld8(i64 %p0)
%t1830 = icmp eq i64 %t1829, 0
br i1 %t1830, label %L691, label %L693
L691:
ret i64 %p1
L693:
%t1831 = sub i64 %t1829, 48
%t1832 = sub nsw i64 0, 922337203685477580
%t1833 = icmp slt i64 %p1, %t1832
br label %LSL1834
LSL1834:
br i1 %t1833, label %LSJ1834, label %LSR1834
LSR1834:
%t1835 = icmp eq i64 %p1, %t1832
br label %LSL1836
LSL1836:
br i1 %t1835, label %LSR1836, label %LSJ1836
LSR1836:
%t1837 = icmp sgt i64 %t1831, 8
br label %LSJ1836
LSJ1836:
%t1838 = phi i1 [ false, %LSL1836 ], [ %t1837, %LSR1836 ]
br label %LSJ1834
LSJ1834:
%t1839 = phi i1 [ true, %LSL1834 ], [ %t1838, %LSJ1836 ]
br i1 %t1839, label %L694, label %L696
L694:
ret i64 1
L696:
%t1840 = add i64 %p0, 1
%t1841 = mul i64 %p1, 10
%t1842 = sub i64 %t1841, %t1831
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_strutil_resid__is_float(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1844 = call i64 @ld8(i64 %p0)
%t1845 = icmp eq i64 %t1844, 0
br i1 %t1845, label %L697, label %L699
L697:
ret i1 false
L699:
%t1846p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.strtod_end)
%t1846 = ptrtoint ptr %t1846p to i64
%t1847 = call double @c_strtod(i64 %p0, i64 %t1846)
%t1848 = call i64 @ld64(i64 %t1846)
%t1849 = call i64 @__mruntime_rt_strutil_resid__skip_tabs(i64 %t1848)
%t1850 = call i64 @ld8(i64 %t1849)
%t1851 = icmp eq i64 %t1850, 0
br label %LSL1852
LSL1852:
br i1 %t1851, label %LSR1852, label %LSJ1852
LSR1852:
%t1853 = icmp ne i64 %t1848, %p0
br label %LSJ1852
LSJ1852:
%t1854 = phi i1 [ false, %LSL1852 ], [ %t1853, %LSR1852 ]
ret i1 %t1854
}
define internal i64 @__mruntime_rt_strutil_resid__skip_tabs(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1860, %tco.s0 ]
%t1855 = call i64 @ld8(i64 %p0)
%t1856 = icmp eq i64 %t1855, 32
br label %LSL1857
LSL1857:
br i1 %t1856, label %LSJ1857, label %LSR1857
LSR1857:
%t1858 = icmp eq i64 %t1855, 9
br label %LSJ1857
LSJ1857:
%t1859 = phi i1 [ true, %LSL1857 ], [ %t1858, %LSR1857 ]
br i1 %t1859, label %L700, label %L702
L700:
%t1860 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
L702:
ret i64 %p0
}
define internal i64 @rt_str_is_float(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1862 = call i1 @__mruntime_rt_strutil_resid__is_float(i64 %p0)
br i1 %t1862, label %L703, label %L704
L703:
br label %L705
L704:
br label %L705
L705:
%t1863 = phi i64 [ 1, %L703 ], [ 0, %L704 ]
ret i64 %t1863
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
%t1864 = call i1 @__mruntime_rt_strutil_resid__is_float(i64 %p0)
%t1865 = xor i1 %t1864, true
br i1 %t1865, label %L706, label %L708
L706:
ret double 0.0
L708:
%t1866 = call double @c_strtod(i64 %p0, i64 0)
ret double %t1866
}
define double @str_parse_float(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call double @rt_str_parse_float(i64 %x0i)
ret double %r
}
define internal i64 @rt_str_count(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1867 = call i64 @c_strlen(i64 %p1)
%t1868 = icmp eq i64 %t1867, 0
br i1 %t1868, label %L709, label %L711
L709:
ret i64 0
L711:
%t1869 = call i64 @__mruntime_rt_strutil_resid__count_hits(i64 %p0, i64 %p1, i64 %t1867, i64 0)
ret i64 %t1869
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
%t1870 = call i64 @c_strlen(i64 %p0)
%t1871 = add i64 %t1870, 1
%t1872 = call i64 @xmalloc(i64 %t1871)
%t1873 = add i64 %t1872, %t1870
%t1874 = call i64 @__mruntime_rt_strutil_resid__rev_at(i64 %p0, i64 %t1873)
%t1875 = add i64 %t1872, %t1870
%t1876 = call i64 @st8(i64 %t1875, i64 0)
ret i64 %t1872
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
%p0 = phi i64 [ %p0.in, %entry ], [ %t1882, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1883, %tco.s0 ]
%t1877 = call i64 @ld8(i64 %p0)
%t1878 = icmp eq i64 %t1877, 0
br i1 %t1878, label %L712, label %L714
L712:
ret i64 0
L714:
%t1879 = call i64 @utf8_len_at(i64 %p0)
%t1880 = sub i64 %p1, %t1879
%t1881 = call i64 @mcopy(i64 %t1880, i64 %p0, i64 %t1879)
%t1882 = add i64 %p0, %t1879
%t1883 = sub i64 %p1, %t1879
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__sc(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t1885 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 0, i64 0)
%t1886 = sub nsw i64 0, 4
%t1887 = icmp eq i64 %t1885, %t1886
br i1 %t1887, label %L715, label %L717
L715:
br label %tco.s0
tco.s0:
br label %tco.head
L717:
ret i64 %t1885
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
%t1889 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 0, i64 0)
%t1890 = sub nsw i64 0, 4
%t1891 = icmp eq i64 %t1889, %t1890
br i1 %t1891, label %L718, label %L720
L718:
br label %tco.s0
tco.s0:
br label %tco.head
L720:
ret i64 %t1889
}
define internal i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1893 = icmp ne i64 %p0, 0
br label %LSL1894
LSL1894:
br i1 %t1893, label %LSR1894, label %LSJ1894
LSR1894:
%t1895 = call i64 @ld8(i64 %p0)
%t1896 = icmp ne i64 %t1895, 0
br label %LSJ1894
LSJ1894:
%t1897 = phi i1 [ false, %LSL1894 ], [ %t1896, %LSR1894 ]
ret i1 %t1897
}
define internal i64 @__mruntime_rt_sys_resid__o_rdonly() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 524288
}
define internal i64 @__mruntime_rt_sys_resid__o_write() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1898 = or i64 524288, 1
%t1899 = or i64 %t1898, 64
%t1900 = or i64 %t1899, 512
ret i64 %t1900
}
define internal i64 @__mruntime_rt_sys_resid__o_append() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1901 = or i64 524288, 1
%t1902 = or i64 %t1901, 64
%t1903 = or i64 %t1902, 1024
ret i64 %t1903
}
define internal i64 @sys_open(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1904 = call i64 @__mruntime_rt_sys_resid__sc(i64 2, i64 %p0, i64 %p1, i64 %p2)
ret i64 %t1904
}
define internal i64 @sys_close(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1905 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 3, i64 %p0, i64 0, i64 0, i64 0, i64 0, i64 0)
ret i64 %t1905
}
define internal i64 @__mruntime_rt_sys_resid__stat_buf() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1906p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.stat_buf)
%t1906 = ptrtoint ptr %t1906p to i64
ret i64 %t1906
}
define internal i1 @__mruntime_rt_sys_resid__mode_dir(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1907 = and i64 %p0, 61440
%t1908 = icmp eq i64 %t1907, 16384
ret i1 %t1908
}
define internal i1 @__mruntime_rt_sys_resid__mode_reg(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1909 = and i64 %p0, 61440
%t1910 = icmp eq i64 %t1909, 32768
ret i1 %t1910
}
define internal i64 @rt_fs_is_dir(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1911 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t1912 = xor i1 %t1911, true
br i1 %t1912, label %L721, label %L723
L721:
ret i64 0
L723:
%t1913 = call i64 @__mruntime_rt_sys_resid__stat_buf()
%t1914 = call i64 @__mruntime_rt_sys_resid__sc(i64 4, i64 %p0, i64 %t1913, i64 0)
%t1915 = icmp ne i64 %t1914, 0
br i1 %t1915, label %L724, label %L726
L724:
ret i64 0
L726:
%t1916 = add i64 %t1913, 24
%t1917 = call i64 @ld32(i64 %t1916)
%t1918 = call i1 @__mruntime_rt_sys_resid__mode_dir(i64 %t1917)
br i1 %t1918, label %L727, label %L728
L727:
br label %L729
L728:
br label %L729
L729:
%t1919 = phi i64 [ 1, %L727 ], [ 0, %L728 ]
ret i64 %t1919
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
%t1920 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t1921 = xor i1 %t1920, true
br i1 %t1921, label %L730, label %L732
L730:
ret i64 0
L732:
%t1922 = call i64 @c_strlen(i64 %p0)
%t1923 = icmp sge i64 %t1922, 4096
br i1 %t1923, label %L733, label %L735
L733:
ret i64 0
L735:
%t1924 = call i64 @cstr_dup(i64 %p0)
%t1925 = call i1 @__mruntime_rt_sys_resid__mkdir_parents(i64 %t1924, i64 1, i64 %t1922)
br label %LSL1926
LSL1926:
br i1 %t1925, label %LSR1926, label %LSJ1926
LSR1926:
%t1927 = call i1 @__mruntime_rt_sys_resid__mkdir_ok(i64 %t1924)
br label %LSJ1926
LSJ1926:
%t1928 = phi i1 [ false, %LSL1926 ], [ %t1927, %LSR1926 ]
%t1929 = call i64 @__mruntime_rt_sys_resid__stat_buf()
br label %LSL1930
LSL1930:
br i1 %t1928, label %LSR1930, label %LSJ1930
LSR1930:
%t1931 = call i64 @__mruntime_rt_sys_resid__sc(i64 4, i64 %t1924, i64 %t1929, i64 0)
%t1932 = icmp eq i64 %t1931, 0
br label %LSJ1930
LSJ1930:
%t1933 = phi i1 [ false, %LSL1930 ], [ %t1932, %LSR1930 ]
br label %LSL1934
LSL1934:
br i1 %t1933, label %LSR1934, label %LSJ1934
LSR1934:
%t1935 = add i64 %t1929, 24
%t1936 = call i64 @ld32(i64 %t1935)
%t1937 = call i1 @__mruntime_rt_sys_resid__mode_dir(i64 %t1936)
br label %LSJ1934
LSJ1934:
%t1938 = phi i1 [ false, %LSL1934 ], [ %t1937, %LSR1934 ]
%t1939 = call i64 @c_free(i64 %t1924)
br i1 %t1938, label %L736, label %L737
L736:
br label %L738
L737:
br label %L738
L738:
%t1940 = phi i64 [ 1, %L736 ], [ 0, %L737 ]
ret i64 %t1940
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
%t1941 = call i64 @__mruntime_rt_sys_resid__sc(i64 83, i64 %p0, i64 511, i64 0)
%t1942 = icmp eq i64 %t1941, 0
br label %LSL1943
LSL1943:
br i1 %t1942, label %LSJ1943, label %LSR1943
LSR1943:
%t1944 = sub nsw i64 0, 17
%t1945 = icmp eq i64 %t1941, %t1944
br label %LSJ1943
LSJ1943:
%t1946 = phi i1 [ true, %LSL1943 ], [ %t1945, %LSR1943 ]
ret i1 %t1946
}
define internal i1 @__mruntime_rt_sys_resid__mkdir_parents(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1951, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t1947 = icmp sge i64 %p1, %p2
br i1 %t1947, label %L739, label %L741
L739:
ret i1 true
L741:
%t1948 = add i64 %p0, %p1
%t1949 = call i64 @ld8(i64 %t1948)
%t1950 = icmp ne i64 %t1949, 47
br i1 %t1950, label %L742, label %L744
L742:
%t1951 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L744:
%t1953 = add i64 %p0, %p1
%t1954 = call i64 @st8(i64 %t1953, i64 0)
%t1955 = call i64 @ld8(i64 %p0)
%t1956 = icmp eq i64 %t1955, 0
br label %LSL1957
LSL1957:
br i1 %t1956, label %LSJ1957, label %LSR1957
LSR1957:
%t1958 = call i1 @__mruntime_rt_sys_resid__mkdir_ok(i64 %p0)
br label %LSJ1957
LSJ1957:
%t1959 = phi i1 [ true, %LSL1957 ], [ %t1958, %LSR1957 ]
%t1960 = add i64 %p0, %p1
%t1961 = call i64 @st8(i64 %t1960, i64 47)
br label %LSL1962
LSL1962:
br i1 %t1959, label %LSR1962, label %LSJ1962
LSR1962:
%t1963 = add nsw i64 %p1, 1
%t1964 = call i1 @__mruntime_rt_sys_resid__mkdir_parents(i64 %p0, i64 %t1963, i64 %p2)
br label %LSJ1962
LSJ1962:
%t1965 = phi i1 [ false, %LSL1962 ], [ %t1964, %LSR1962 ]
ret i1 %t1965
}
define internal i64 @rt_fs_exists(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1966 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t1967 = xor i1 %t1966, true
br i1 %t1967, label %L745, label %L747
L745:
ret i64 0
L747:
%t1968 = call i64 @__mruntime_rt_sys_resid__o_rdonly()
%t1969 = call i64 @sys_open(i64 %p0, i64 %t1968, i64 0)
%t1970 = icmp slt i64 %t1969, 0
br i1 %t1970, label %L748, label %L750
L748:
ret i64 0
L750:
%t1971 = call i64 @sys_close(i64 %t1969)
%t1972 = mul nsw i64 %t1971, 0
%t1973 = add nsw i64 %t1972, 1
ret i64 %t1973
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
%t1974 = call i64 @xmalloc(i64 256)
%t1975 = call i64 @__mruntime_rt_sys_resid__read_line_at(i64 %t1974, i64 0, i64 256)
ret i64 %t1975
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
%p0 = phi i64 [ %p0.in, %entry ], [ %t1980, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1998, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1984, %tco.s0 ]
%t1976 = add i64 %p1, 2
%t1977 = icmp sgt i64 %t1976, %p2
br i1 %t1977, label %L751, label %L752
L751:
%t1978 = mul i64 %p2, 2
%t1979 = call i64 @xrealloc(i64 %p0, i64 %t1978)
br label %L753
L752:
br label %L753
L753:
%t1980 = phi i64 [ %t1979, %L751 ], [ %p0, %L752 ]
%t1981 = add i64 %p1, 2
%t1982 = icmp sgt i64 %t1981, %p2
br i1 %t1982, label %L754, label %L755
L754:
%t1983 = mul i64 %p2, 2
br label %L756
L755:
br label %L756
L756:
%t1984 = phi i64 [ %t1983, %L754 ], [ %p2, %L755 ]
%t1985 = add i64 %t1980, %p1
%t1986 = call i64 @__mruntime_rt_sys_resid__sc(i64 0, i64 0, i64 %t1985, i64 1)
%t1987 = icmp sle i64 %t1986, 0
br i1 %t1987, label %L757, label %L759
L757:
%t1988 = add i64 %t1980, %p1
%t1989 = call i64 @st8(i64 %t1988, i64 0)
%t1990 = add i64 %t1989, %t1980
ret i64 %t1990
L759:
%t1991 = add i64 %t1980, %p1
%t1992 = call i64 @ld8(i64 %t1991)
%t1993 = icmp eq i64 %t1992, 10
br i1 %t1993, label %L760, label %L762
L760:
%t1994 = add i64 %t1980, %p1
%t1995 = add i64 %t1994, 1
%t1996 = call i64 @st8(i64 %t1995, i64 0)
%t1997 = add i64 %t1996, %t1980
ret i64 %t1997
L762:
%t1998 = add i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__read_fd_all(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2000 = call i64 @__mruntime_rt_sys_resid__stat_buf()
%t2001 = call i64 @__mruntime_rt_sys_resid__sc(i64 5, i64 %p0, i64 %t2000, i64 0)
%t2002 = icmp eq i64 %t2001, 0
br label %LSL2003
LSL2003:
br i1 %t2002, label %LSR2003, label %LSJ2003
LSR2003:
%t2004 = add i64 %t2000, 24
%t2005 = call i64 @ld32(i64 %t2004)
%t2006 = call i1 @__mruntime_rt_sys_resid__mode_reg(i64 %t2005)
br label %LSJ2003
LSJ2003:
%t2007 = phi i1 [ false, %LSL2003 ], [ %t2006, %LSR2003 ]
br i1 %t2007, label %L763, label %L764
L763:
%t2008 = add i64 %t2000, 48
%t2009 = call i64 @ld64(i64 %t2008)
br label %L765
L764:
br label %L765
L765:
%t2010 = phi i64 [ %t2009, %L763 ], [ 0, %L764 ]
%t2011 = call i64 @__mruntime_rt_sys_resid__sc(i64 8, i64 %p0, i64 0, i64 1)
%t2012 = icmp sgt i64 %t2010, 0
br label %LSL2013
LSL2013:
br i1 %t2012, label %LSR2013, label %LSJ2013
LSR2013:
%t2014 = icmp sgt i64 %t2011, 0
br label %LSJ2013
LSJ2013:
%t2015 = phi i1 [ false, %LSL2013 ], [ %t2014, %LSR2013 ]
br label %LSL2016
LSL2016:
br i1 %t2015, label %LSR2016, label %LSJ2016
LSR2016:
%t2017 = icmp slt i64 %t2011, %t2010
br label %LSJ2016
LSJ2016:
%t2018 = phi i1 [ false, %LSL2016 ], [ %t2017, %LSR2016 ]
br i1 %t2018, label %L766, label %L767
L766:
%t2019 = sub nsw i64 %t2010, %t2011
br label %L768
L767:
br label %L768
L768:
%t2020 = phi i64 [ %t2019, %L766 ], [ %t2010, %L767 ]
%t2021 = icmp sgt i64 %t2020, 0
br i1 %t2021, label %L769, label %L770
L769:
br label %L771
L770:
br label %L771
L771:
%t2022 = phi i64 [ %t2020, %L769 ], [ 65536, %L770 ]
%t2023 = add i64 %t2022, 1
%t2024 = call i64 @xmalloc(i64 %t2023)
%t2025 = call i64 @__mruntime_rt_sys_resid__read_fd_at(i64 %p0, i64 %t2024, i64 0, i64 %t2022)
ret i64 %t2025
}
define internal i64 @__mruntime_rt_sys_resid__read_fd_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2030, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2041, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t2033, %tco.s0 ]
%t2026 = icmp sge i64 %p2, %p3
br i1 %t2026, label %L772, label %L773
L772:
%t2027 = mul i64 %p3, 2
%t2028 = add i64 %t2027, 1
%t2029 = call i64 @xrealloc(i64 %p1, i64 %t2028)
br label %L774
L773:
br label %L774
L774:
%t2030 = phi i64 [ %t2029, %L772 ], [ %p1, %L773 ]
%t2031 = icmp sge i64 %p2, %p3
br i1 %t2031, label %L775, label %L776
L775:
%t2032 = mul i64 %p3, 2
br label %L777
L776:
br label %L777
L777:
%t2033 = phi i64 [ %t2032, %L775 ], [ %p3, %L776 ]
%t2034 = add i64 %t2030, %p2
%t2035 = sub i64 %t2033, %p2
%t2036 = call i64 @__mruntime_rt_sys_resid__sc(i64 0, i64 %p0, i64 %t2034, i64 %t2035)
%t2037 = icmp sle i64 %t2036, 0
br i1 %t2037, label %L778, label %L780
L778:
%t2038 = add i64 %t2030, %p2
%t2039 = call i64 @st8(i64 %t2038, i64 0)
%t2040 = add i64 %t2039, %t2030
ret i64 %t2040
L780:
%t2041 = add i64 %p2, %t2036
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_fs_read_all(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2043 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t2044 = xor i1 %t2043, true
br i1 %t2044, label %L781, label %L783
L781:
%t2045 = call i64 @xempty()
ret i64 %t2045
L783:
%t2046 = call i64 @__mruntime_rt_sys_resid__o_rdonly()
%t2047 = call i64 @sys_open(i64 %p0, i64 %t2046, i64 0)
%t2048 = icmp slt i64 %t2047, 0
br i1 %t2048, label %L784, label %L786
L784:
%t2049 = call i64 @xempty()
ret i64 %t2049
L786:
%t2050 = call i64 @__mruntime_rt_sys_resid__read_fd_all(i64 %t2047)
%t2051 = call i64 @sys_close(i64 %t2047)
%t2052 = mul nsw i64 %t2051, 0
%t2053 = add nsw i64 %t2052, %t2050
ret i64 %t2053
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
%t2054 = call i64 @xmalloc(i64 1)
%t2055 = call i64 @st8(i64 %t2054, i64 0)
%t2056 = add i64 %t2055, %t2054
ret i64 %t2056
}
define internal i1 @__mruntime_rt_sys_resid__put_file(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2057 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t2058 = xor i1 %t2057, true
br i1 %t2058, label %L787, label %L789
L787:
ret i1 false
L789:
%t2059 = call i64 @sys_open(i64 %p0, i64 %p1, i64 %p2)
%t2060 = icmp slt i64 %t2059, 0
br i1 %t2060, label %L790, label %L792
L790:
ret i1 false
L792:
%t2061 = call i1 @write_all(i64 %t2059, i64 %p3, i64 %p4)
%t2062 = call i64 @sys_close(i64 %t2059)
%t2063 = icmp eq i64 %t2062, 0
br label %LSL2064
LSL2064:
br i1 %t2063, label %LSR2064, label %LSJ2064
LSR2064:
br label %LSJ2064
LSJ2064:
%t2065 = phi i1 [ false, %LSL2064 ], [ %t2061, %LSR2064 ]
ret i1 %t2065
}
define internal i64 @__mruntime_rt_sys_resid__b8(i1 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br i1 %p0, label %L793, label %L794
L793:
br label %L795
L794:
br label %L795
L795:
%t2066 = phi i64 [ 1, %L793 ], [ 0, %L794 ]
ret i64 %t2066
}
define internal i64 @rt_fs_write_all(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2067 = call i64 @__mruntime_rt_sys_resid__o_write()
%t2068 = call i64 @c_strlen(i64 %p1)
%t2069 = call i1 @__mruntime_rt_sys_resid__put_file(i64 %p0, i64 %t2067, i64 438, i64 %p1, i64 %t2068)
%t2070 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t2069)
ret i64 %t2070
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
%t2071 = call i64 @c_list_len(i64 %p0)
%t2072 = call i64 @xmalloc(i64 %t2071)
%t2073 = call i64 @__mruntime_rt_sys_resid__list_bytes_at(i64 %p0, i64 %t2072, i64 0, i64 %t2071)
ret i64 %t2072
}
define internal i64 @__mruntime_rt_sys_resid__list_bytes_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2079, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t2074 = icmp sge i64 %p2, %p3
br i1 %t2074, label %L796, label %L798
L796:
ret i64 0
L798:
%t2075 = add i64 %p1, %p2
%t2076 = call i64 @c_list_get(i64 %p0, i64 %p2)
%t2077 = call i64 @c_unbox_i64(i64 %t2076)
%t2078 = call i64 @st8(i64 %t2075, i64 %t2077)
%t2079 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_sys_resid__put_list(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2081 = call i64 @__mruntime_rt_sys_resid__list_bytes(i64 %p3)
%t2082 = call i64 @c_list_len(i64 %p3)
%t2083 = call i1 @__mruntime_rt_sys_resid__put_file(i64 %p0, i64 %p1, i64 %p2, i64 %t2081, i64 %t2082)
%t2084 = call i64 @c_free(i64 %t2081)
ret i1 %t2083
}
define internal i64 @rt_fs_write_bytes(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2085 = call i64 @__mruntime_rt_sys_resid__o_write()
%t2086 = call i1 @__mruntime_rt_sys_resid__put_list(i64 %p0, i64 %t2085, i64 438, i64 %p1)
%t2087 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t2086)
ret i64 %t2087
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
%t2088 = call i64 @__mruntime_rt_sys_resid__o_append()
%t2089 = call i1 @__mruntime_rt_sys_resid__put_list(i64 %p0, i64 %t2088, i64 438, i64 %p1)
%t2090 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t2089)
ret i64 %t2090
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
%t2091 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t2092 = xor i1 %t2091, true
br i1 %t2092, label %L799, label %L801
L799:
ret i64 0
L801:
%t2093 = call i64 @__mruntime_rt_sys_resid__o_write()
%t2094 = or i64 %t2093, 131072
%t2095 = call i64 @sys_open(i64 %p0, i64 %t2094, i64 384)
%t2096 = icmp slt i64 %t2095, 0
br i1 %t2096, label %L802, label %L804
L802:
ret i64 0
L804:
%t2097 = call i64 @__mruntime_rt_sys_resid__sc(i64 91, i64 %t2095, i64 384, i64 0)
%t2098 = icmp eq i64 %t2097, 0
%t2099 = call i64 @__mruntime_rt_sys_resid__list_bytes(i64 %p1)
br label %LSL2100
LSL2100:
br i1 %t2098, label %LSR2100, label %LSJ2100
LSR2100:
%t2101 = call i64 @c_list_len(i64 %p1)
%t2102 = call i1 @write_all(i64 %t2095, i64 %t2099, i64 %t2101)
br label %LSJ2100
LSJ2100:
%t2103 = phi i1 [ false, %LSL2100 ], [ %t2102, %LSR2100 ]
%t2104 = call i64 @c_free(i64 %t2099)
%t2105 = call i64 @sys_close(i64 %t2095)
%t2106 = icmp eq i64 %t2105, 0
br label %LSL2107
LSL2107:
br i1 %t2106, label %LSR2107, label %LSJ2107
LSR2107:
br label %LSJ2107
LSJ2107:
%t2108 = phi i1 [ false, %LSL2107 ], [ %t2103, %LSR2107 ]
%t2109 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t2108)
ret i64 %t2109
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
%t2110 = icmp sge i64 %p0, 48
br label %LSL2111
LSL2111:
br i1 %t2110, label %LSR2111, label %LSJ2111
LSR2111:
%t2112 = icmp sle i64 %p0, 57
br label %LSJ2111
LSJ2111:
%t2113 = phi i1 [ false, %LSL2111 ], [ %t2112, %LSR2111 ]
br i1 %t2113, label %L805, label %L807
L805:
%t2114 = sub nsw i64 %p0, 48
ret i64 %t2114
L807:
%t2115 = icmp sge i64 %p0, 97
br label %LSL2116
LSL2116:
br i1 %t2115, label %LSR2116, label %LSJ2116
LSR2116:
%t2117 = icmp sle i64 %p0, 102
br label %LSJ2116
LSJ2116:
%t2118 = phi i1 [ false, %LSL2116 ], [ %t2117, %LSR2116 ]
br i1 %t2118, label %L808, label %L810
L808:
%t2119 = sub nsw i64 %p0, 87
ret i64 %t2119
L810:
%t2120 = icmp sge i64 %p0, 65
br label %LSL2121
LSL2121:
br i1 %t2120, label %LSR2121, label %LSJ2121
LSR2121:
%t2122 = icmp sle i64 %p0, 70
br label %LSJ2121
LSJ2121:
%t2123 = phi i1 [ false, %LSL2121 ], [ %t2122, %LSR2121 ]
br i1 %t2123, label %L811, label %L813
L811:
%t2124 = sub nsw i64 %p0, 55
ret i64 %t2124
L813:
%t2125 = sub nsw i64 0, 1
ret i64 %t2125
}
define internal i1 @__mruntime_rt_sys_resid__unhex(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2144, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t2126 = icmp sge i64 %p2, %p3
br i1 %t2126, label %L814, label %L816
L814:
ret i1 true
L816:
%t2127 = mul i64 2, %p2
%t2128 = add i64 %p0, %t2127
%t2129 = call i64 @ld8(i64 %t2128)
%t2130 = call i64 @__mruntime_rt_sys_resid__hex_val(i64 %t2129)
%t2131 = mul i64 2, %p2
%t2132 = add i64 %p0, %t2131
%t2133 = add i64 %t2132, 1
%t2134 = call i64 @ld8(i64 %t2133)
%t2135 = call i64 @__mruntime_rt_sys_resid__hex_val(i64 %t2134)
%t2136 = icmp slt i64 %t2130, 0
br label %LSL2137
LSL2137:
br i1 %t2136, label %LSJ2137, label %LSR2137
LSR2137:
%t2138 = icmp slt i64 %t2135, 0
br label %LSJ2137
LSJ2137:
%t2139 = phi i1 [ true, %LSL2137 ], [ %t2138, %LSR2137 ]
br i1 %t2139, label %L817, label %L819
L817:
ret i1 false
L819:
%t2140 = add i64 %p1, %p2
%t2141 = mul i64 %t2130, 16
%t2142 = add i64 %t2141, %t2135
%t2143 = call i64 @st8(i64 %t2140, i64 %t2142)
%t2144 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__put_hex(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2146 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t2147 = xor i1 %t2146, true
br i1 %t2147, label %L820, label %L822
L820:
ret i64 0
L822:
%t2148 = call i64 @c_strlen(i64 %p1)
%t2149 = srem i64 %t2148, 2
%t2150 = icmp ne i64 %t2149, 0
br i1 %t2150, label %L823, label %L825
L823:
ret i64 0
L825:
%t2151 = sdiv i64 %t2148, 2
%t2152 = add nsw i64 %t2151, 1
%t2153 = call i64 @xmalloc(i64 %t2152)
%t2154 = sdiv i64 %t2148, 2
%t2155 = call i1 @__mruntime_rt_sys_resid__unhex(i64 %p1, i64 %t2153, i64 0, i64 %t2154)
br label %LSL2156
LSL2156:
br i1 %t2155, label %LSR2156, label %LSJ2156
LSR2156:
%t2157 = sdiv i64 %t2148, 2
%t2158 = call i1 @__mruntime_rt_sys_resid__put_file(i64 %p0, i64 %p2, i64 438, i64 %t2153, i64 %t2157)
br label %LSJ2156
LSJ2156:
%t2159 = phi i1 [ false, %LSL2156 ], [ %t2158, %LSR2156 ]
%t2160 = call i64 @c_free(i64 %t2153)
%t2161 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t2159)
ret i64 %t2161
}
define internal i64 @rt_fs_write_hex(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2162 = call i64 @__mruntime_rt_sys_resid__o_write()
%t2163 = call i64 @__mruntime_rt_sys_resid__put_hex(i64 %p0, i64 %p1, i64 %t2162)
ret i64 %t2163
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
%t2164 = call i64 @__mruntime_rt_sys_resid__o_append()
%t2165 = call i64 @__mruntime_rt_sys_resid__put_hex(i64 %p0, i64 %p1, i64 %t2164)
ret i64 %t2165
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
%t2166 = mul i64 %p1, 8
%t2167 = call i64 @xmalloc(i64 %t2166)
%t2168 = call i64 @__mruntime_rt_sys_resid__box_bytes(i64 %p0, i64 %t2167, i64 0, i64 %p1)
%t2170 = ptrtoint ptr @.s2169 to i64
%t2171 = call i64 @c_list_new(i64 %p1, i64 %t2167, i64 %t2170)
%t2172 = call i64 @c_free(i64 %t2167)
%t2173 = mul nsw i64 %t2172, 0
%t2174 = add nsw i64 %t2173, %t2171
ret i64 %t2174
}
define internal i64 @__mruntime_rt_sys_resid__box_bytes(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2182, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t2175 = icmp sge i64 %p2, %p3
br i1 %t2175, label %L826, label %L828
L826:
ret i64 0
L828:
%t2176 = mul i64 %p2, 8
%t2177 = add i64 %p1, %t2176
%t2178 = add i64 %p0, %p2
%t2179 = call i64 @ld8(i64 %t2178)
%t2180 = call i64 @c_box_i64(i64 %t2179)
%t2181 = call i64 @st64(i64 %t2177, i64 %t2180)
%t2182 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__empty_bytes() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2185 = ptrtoint ptr @.s2184 to i64
%t2186 = call i64 @c_list_new(i64 0, i64 0, i64 %t2185)
ret i64 %t2186
}
define internal i64 @rt_fs_read_bytes(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2187 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t2188 = xor i1 %t2187, true
br i1 %t2188, label %L829, label %L831
L829:
%t2189 = call i64 @__mruntime_rt_sys_resid__empty_bytes()
ret i64 %t2189
L831:
%t2190 = call i64 @__mruntime_rt_sys_resid__o_rdonly()
%t2191 = call i64 @sys_open(i64 %p0, i64 %t2190, i64 0)
%t2192 = icmp slt i64 %t2191, 0
br i1 %t2192, label %L832, label %L834
L832:
%t2193 = call i64 @__mruntime_rt_sys_resid__empty_bytes()
ret i64 %t2193
L834:
%t2194 = call i64 @__mruntime_rt_sys_resid__stat_buf()
%t2195 = call i64 @__mruntime_rt_sys_resid__sc(i64 5, i64 %t2191, i64 %t2194, i64 0)
%t2196 = icmp eq i64 %t2195, 0
br i1 %t2196, label %L835, label %L836
L835:
%t2197 = add i64 %t2194, 48
%t2198 = call i64 @ld64(i64 %t2197)
br label %L837
L836:
br label %L837
L837:
%t2199 = phi i64 [ %t2198, %L835 ], [ 0, %L836 ]
%t2200 = icmp sgt i64 %t2199, 0
br i1 %t2200, label %L838, label %L839
L838:
br label %L840
L839:
br label %L840
L840:
%t2201 = phi i64 [ %t2199, %L838 ], [ 1, %L839 ]
%t2202 = call i64 @xmalloc(i64 %t2201)
%t2203 = call i64 @__mruntime_rt_sys_resid__read_n(i64 %t2191, i64 %t2202, i64 0, i64 %t2199)
%t2204 = call i64 @sys_close(i64 %t2191)
%t2205 = call i64 @__mruntime_rt_sys_resid__bytes_list(i64 %t2202, i64 %t2203)
%t2206 = call i64 @c_free(i64 %t2202)
%t2207 = mul nsw i64 %t2206, 0
%t2208 = add nsw i64 %t2207, %t2205
ret i64 %t2208
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t2214, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t2209 = icmp sge i64 %p2, %p3
br i1 %t2209, label %L841, label %L843
L841:
ret i64 %p2
L843:
%t2210 = add i64 %p1, %p2
%t2211 = sub i64 %p3, %p2
%t2212 = call i64 @__mruntime_rt_sys_resid__sc(i64 0, i64 %p0, i64 %t2210, i64 %t2211)
%t2213 = icmp sle i64 %t2212, 0
br i1 %t2213, label %L844, label %L846
L844:
ret i64 %p2
L846:
%t2214 = add i64 %p2, %t2212
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_print_bytes(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2216 = call i64 @__mruntime_rt_sys_resid__list_bytes(i64 %p0)
%t2217 = call i64 @c_list_len(i64 %p0)
%t2218 = call i1 @write_all(i64 1, i64 %t2216, i64 %t2217)
%t2219 = call i64 @c_free(i64 %t2216)
%t2220 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t2218)
ret i64 %t2220
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
%t2222 = ptrtoint ptr @.s2221 to i64
%t2223 = call i64 @__mruntime_rt_sys_resid__o_rdonly()
%t2224 = or i64 %t2223, 65536
%t2225 = call i64 @sys_open(i64 %p0, i64 %t2224, i64 0)
%t2226 = icmp slt i64 %t2225, 0
br i1 %t2226, label %L847, label %L849
L847:
%t2227 = call i64 @c_list_new(i64 0, i64 0, i64 %t2222)
ret i64 %t2227
L849:
%t2228 = call i64 @xmalloc(i64 32768)
%t2229 = mul nsw i64 64, 8
%t2230 = call i64 @xmalloc(i64 %t2229)
%t2231 = call i64 @__mruntime_rt_sys_resid__dir_entries(i64 %t2225, i64 %t2228, i64 %t2230, i64 0, i64 64)
%t2232 = call i64 @ld64(i64 %t2228)
%t2233 = call i64 @c_list_new(i64 %t2232, i64 %t2231, i64 %t2222)
%t2234 = call i64 @sys_close(i64 %t2225)
%t2235 = call i64 @c_free(i64 %t2231)
%t2236 = call i64 @c_free(i64 %t2228)
%t2237 = mul nsw i64 %t2236, 0
%t2238 = add nsw i64 %t2237, %t2233
ret i64 %t2238
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
%t2239 = call i64 @__mruntime_rt_sys_resid__sc(i64 217, i64 %p0, i64 %p1, i64 32768)
%t2240 = icmp sle i64 %t2239, 0
br i1 %t2240, label %L850, label %L852
L850:
%t2241 = call i64 @st64(i64 %p1, i64 %p3)
%t2242 = mul nsw i64 %t2241, 0
%t2243 = add nsw i64 %t2242, %p2
ret i64 %t2243
L852:
%t2244 = add i64 %p1, %t2239
%t2245 = call i64 @__mruntime_rt_sys_resid__dir_chunk(i64 %p0, i64 %p1, i64 %p1, i64 %t2244, i64 %p2, i64 %p3, i64 %p4)
ret i64 %t2245
}
define internal i64 @__mruntime_rt_sys_resid__dir_chunk(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2272, %tco.s0 ], [ %t2285, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ], [ %p3, %tco.s1 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ], [ %t2277, %tco.s1 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ], [ %t2286, %tco.s1 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p6, %tco.s0 ], [ %t2280, %tco.s1 ]
%t2246 = icmp sge i64 %p2, %p3
br i1 %t2246, label %L853, label %L855
L853:
%t2247 = call i64 @__mruntime_rt_sys_resid__dir_entries(i64 %p0, i64 %p1, i64 %p4, i64 %p5, i64 %p6)
ret i64 %t2247
L855:
%t2248 = add i64 %p2, 16
%t2249 = call i64 @ld8(i64 %t2248)
%t2250 = add i64 %p2, 17
%t2251 = call i64 @ld8(i64 %t2250)
%t2252 = shl i64 %t2251, 8
%t2253 = or i64 %t2249, %t2252
%t2254 = add i64 %p2, 19
%t2255 = call i64 @ld8(i64 %t2254)
%t2256 = icmp eq i64 %t2255, 46
br label %LSL2257
LSL2257:
br i1 %t2256, label %LSR2257, label %LSJ2257
LSR2257:
%t2258 = add i64 %t2254, 1
%t2259 = call i64 @ld8(i64 %t2258)
%t2260 = icmp eq i64 %t2259, 0
br label %LSL2261
LSL2261:
br i1 %t2260, label %LSJ2261, label %LSR2261
LSR2261:
%t2262 = add i64 %t2254, 1
%t2263 = call i64 @ld8(i64 %t2262)
%t2264 = icmp eq i64 %t2263, 46
br label %LSL2265
LSL2265:
br i1 %t2264, label %LSR2265, label %LSJ2265
LSR2265:
%t2266 = add i64 %t2254, 2
%t2267 = call i64 @ld8(i64 %t2266)
%t2268 = icmp eq i64 %t2267, 0
br label %LSJ2265
LSJ2265:
%t2269 = phi i1 [ false, %LSL2265 ], [ %t2268, %LSR2265 ]
br label %LSJ2261
LSJ2261:
%t2270 = phi i1 [ true, %LSL2261 ], [ %t2269, %LSJ2265 ]
br label %LSJ2257
LSJ2257:
%t2271 = phi i1 [ false, %LSL2257 ], [ %t2270, %LSJ2261 ]
br i1 %t2271, label %L856, label %L858
L856:
%t2272 = add i64 %p2, %t2253
br label %tco.s0
tco.s0:
br label %tco.head
L858:
%t2274 = icmp sge i64 %p5, %p6
br i1 %t2274, label %L859, label %L860
L859:
%t2275 = mul i64 %p6, 16
%t2276 = call i64 @xrealloc(i64 %p4, i64 %t2275)
br label %L861
L860:
br label %L861
L861:
%t2277 = phi i64 [ %t2276, %L859 ], [ %p4, %L860 ]
%t2278 = icmp sge i64 %p5, %p6
br i1 %t2278, label %L862, label %L863
L862:
%t2279 = mul i64 %p6, 2
br label %L864
L863:
br label %L864
L864:
%t2280 = phi i64 [ %t2279, %L862 ], [ %p6, %L863 ]
%t2281 = mul i64 %p5, 8
%t2282 = add i64 %t2277, %t2281
%t2283 = call i64 @cstr_dup(i64 %t2254)
%t2284 = call i64 @st64(i64 %t2282, i64 %t2283)
%t2285 = add i64 %p2, %t2253
%t2286 = add i64 %p5, 1
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
%t2288 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
br i1 %t2288, label %L865, label %L866
L865:
%t2289 = call i64 @__mruntime_rt_sys_resid__o_rdonly()
%t2290 = call i64 @sys_open(i64 %p0, i64 %t2289, i64 0)
br label %L867
L866:
%t2291 = sub nsw i64 0, 1
br label %L867
L867:
%t2292 = phi i64 [ %t2290, %L865 ], [ %t2291, %L866 ]
%t2293 = call i64 @xmalloc(i64 24)
%t2294 = call i64 @__mruntime_rt_sys_resid__file_tag()
%t2295 = call i64 @st32(i64 %t2293, i64 %t2294)
%t2296 = add i64 %t2293, 4
%t2297 = call i64 @st32(i64 %t2296, i64 1)
%t2298 = add i64 %t2293, 8
%t2300 = ptrtoint ptr @.s2299 to i64
%t2301 = call i64 @st64(i64 %t2298, i64 %t2300)
%t2302 = add i64 %t2293, 16
%t2303 = icmp slt i64 %t2292, 0
br i1 %t2303, label %L868, label %L869
L868:
%t2304 = sub nsw i64 0, 1
br label %L870
L869:
br label %L870
L870:
%t2305 = phi i64 [ %t2304, %L868 ], [ %t2292, %L869 ]
%t2306 = call i64 @st64(i64 %t2302, i64 %t2305)
%t2307 = mul nsw i64 %t2306, 0
%t2308 = add nsw i64 %t2307, %t2293
ret i64 %t2308
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
%t2309 = icmp eq i64 %p0, 0
br label %LSL2310
LSL2310:
br i1 %t2309, label %LSJ2310, label %LSR2310
LSR2310:
%t2311 = call i64 @ld32(i64 %p0)
%t2312 = call i64 @__mruntime_rt_sys_resid__file_tag()
%t2313 = icmp ne i64 %t2311, %t2312
br label %LSJ2310
LSJ2310:
%t2314 = phi i1 [ true, %LSL2310 ], [ %t2313, %LSR2310 ]
br label %LSL2315
LSL2315:
br i1 %t2314, label %LSJ2315, label %LSR2315
LSR2315:
%t2316 = add i64 %p0, 4
%t2317 = call i64 @ld32(i64 %t2316)
%t2318 = icmp slt i64 %t2317, 1
br label %LSJ2315
LSJ2315:
%t2319 = phi i1 [ true, %LSL2315 ], [ %t2318, %LSR2315 ]
br i1 %t2319, label %L871, label %L873
L871:
%t2320 = sub nsw i64 0, 1
ret i64 %t2320
L873:
%t2321 = add i64 %p0, 16
%t2322 = tail call i64 @ld64(i64 %t2321)
ret i64 %t2322
}
define internal i64 @rt_fs_read_handle(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2323 = call i64 @__mruntime_rt_sys_resid__handle_fd(i64 %p0)
%t2324 = icmp slt i64 %t2323, 0
br i1 %t2324, label %L874, label %L876
L874:
%t2325 = call i64 @xempty()
ret i64 %t2325
L876:
%t2326 = call i64 @__mruntime_rt_sys_resid__sc(i64 8, i64 %t2323, i64 0, i64 2)
%t2327 = icmp slt i64 %t2326, 0
br label %LSL2328
LSL2328:
br i1 %t2327, label %LSJ2328, label %LSR2328
LSR2328:
%t2329 = call i64 @__mruntime_rt_sys_resid__sc(i64 8, i64 %t2323, i64 0, i64 0)
%t2330 = icmp slt i64 %t2329, 0
br label %LSJ2328
LSJ2328:
%t2331 = phi i1 [ true, %LSL2328 ], [ %t2330, %LSR2328 ]
br i1 %t2331, label %L877, label %L879
L877:
%t2332 = call i64 @xempty()
ret i64 %t2332
L879:
%t2333 = add i64 %t2326, 1
%t2334 = call i64 @xmalloc(i64 %t2333)
%t2335 = call i64 @__mruntime_rt_sys_resid__read_n(i64 %t2323, i64 %t2334, i64 0, i64 %t2326)
%t2336 = add i64 %t2334, %t2335
%t2337 = call i64 @st8(i64 %t2336, i64 0)
%t2338 = add i64 %t2337, %t2334
ret i64 %t2338
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
%t2339 = icmp eq i64 %p0, 0
br i1 %t2339, label %L880, label %L882
L880:
ret i64 0
L882:
%t2340 = call i64 @__mruntime_rt_sys_resid__handle_fd(i64 %p0)
%t2341 = icmp sge i64 %t2340, 0
br i1 %t2341, label %L883, label %L884
L883:
%t2342 = call i64 @sys_close(i64 %t2340)
br label %L885
L884:
br label %L885
L885:
%t2343 = phi i64 [ %t2342, %L883 ], [ 0, %L884 ]
%t2344 = call i64 @c_free(i64 %p0)
%t2345 = add i64 %t2344, 1
ret i64 %t2345
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
%t2346 = icmp eq i64 %p0, 0
br i1 %t2346, label %L886, label %L887
L886:
br label %L888
L887:
%t2347 = call i64 @rt_fs_close(i64 %p0)
br label %L888
L888:
%t2348 = phi i64 [ 0, %L886 ], [ %t2347, %L887 ]
ret i64 %t2348
}
define void @resid_handle_release(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_handle_release(i64 %x0i)
ret void
}
define internal i64 @rt_env_get(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2349 = call i64 @c_getenv(i64 %p0)
%t2350 = icmp eq i64 %t2349, 0
br i1 %t2350, label %L889, label %L890
L889:
%t2351 = call i64 @xempty()
br label %L891
L890:
%t2352 = call i64 @cstr_dup(i64 %t2349)
br label %L891
L891:
%t2353 = phi i64 [ %t2351, %L889 ], [ %t2352, %L890 ]
ret i64 %t2353
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
%t2354 = call i64 @c_getenv(i64 %p0)
%t2355 = icmp ne i64 %t2354, 0
%t2356 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t2355)
ret i64 %t2356
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
%t2357p = getelementptr i8, ptr @rtg.rt_args, i64 0
%t2357 = ptrtoint ptr %t2357p to i64
ret i64 %t2357
}
define internal i64 @__mruntime_rt_sys_resid__args_load() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2358 = call i64 @__mruntime_rt_sys_resid__args_state()
%t2359 = add i64 %t2358, 8
%t2360 = call i64 @ld64(i64 %t2359)
%t2361 = icmp ne i64 %t2360, 0
br i1 %t2361, label %L892, label %L894
L892:
ret i64 0
L894:
%t2363 = ptrtoint ptr @.s2362 to i64
%t2364 = call i64 @rt_fs_read_all(i64 %t2363)
%t2366 = ptrtoint ptr @.s2365 to i64
%t2367 = call i64 @__mruntime_rt_sys_resid__cmdline_len(i64 %t2366)
%t2368 = call i64 @__mruntime_rt_sys_resid__count_nuls(i64 %t2364, i64 0, i64 %t2367, i64 0)
%t2369 = add i64 %t2368, 1
%t2370 = mul i64 %t2369, 8
%t2371 = call i64 @xmalloc(i64 %t2370)
%t2372 = call i64 @__mruntime_rt_sys_resid__index_nuls(i64 %t2364, i64 %t2371, i64 0, i64 %t2367, i64 0, i64 0)
%t2373 = call i64 @st64(i64 %t2358, i64 %t2368)
%t2374 = add i64 %t2358, 16
%t2375 = call i64 @st64(i64 %t2374, i64 %t2371)
%t2376 = add i64 %t2358, 8
%t2377 = call i64 @st64(i64 %t2376, i64 %t2364)
ret i64 %t2377
}
define internal i64 @__mruntime_rt_sys_resid__cmdline_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2378 = call i64 @__mruntime_rt_sys_resid__o_rdonly()
%t2379 = call i64 @sys_open(i64 %p0, i64 %t2378, i64 0)
%t2380 = icmp slt i64 %t2379, 0
br i1 %t2380, label %L895, label %L897
L895:
ret i64 0
L897:
%t2381 = call i64 @xmalloc(i64 65536)
%t2382 = call i64 @__mruntime_rt_sys_resid__count_read(i64 %t2379, i64 %t2381, i64 0)
%t2383 = call i64 @sys_close(i64 %t2379)
%t2384 = call i64 @c_free(i64 %t2381)
%t2385 = mul nsw i64 %t2384, 0
%t2386 = add nsw i64 %t2385, %t2382
ret i64 %t2386
}
define internal i64 @__mruntime_rt_sys_resid__count_read(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2389, %tco.s0 ]
%t2387 = call i64 @__mruntime_rt_sys_resid__sc(i64 0, i64 %p0, i64 %p1, i64 65536)
%t2388 = icmp sle i64 %t2387, 0
br i1 %t2388, label %L898, label %L900
L898:
ret i64 %p2
L900:
%t2389 = add i64 %p2, %t2387
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__count_nuls(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2392, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t2397, %tco.s0 ]
%t2391 = icmp sge i64 %p1, %p2
br i1 %t2391, label %L901, label %L903
L901:
ret i64 %p3
L903:
%t2392 = add nsw i64 %p1, 1
%t2393 = add i64 %p0, %p1
%t2394 = call i64 @ld8(i64 %t2393)
%t2395 = icmp eq i64 %t2394, 0
br i1 %t2395, label %L904, label %L905
L904:
%t2396 = add i64 %p3, 1
br label %L906
L905:
br label %L906
L906:
%t2397 = phi i64 [ %t2396, %L904 ], [ %p3, %L905 ]
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t2403, %tco.s0 ], [ %t2409, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ], [ %p3, %tco.s1 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ], [ %t2410, %tco.s1 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ], [ %t2411, %tco.s1 ]
%t2399 = icmp sge i64 %p2, %p3
br i1 %t2399, label %L907, label %L909
L907:
ret i64 0
L909:
%t2400 = add i64 %p0, %p2
%t2401 = call i64 @ld8(i64 %t2400)
%t2402 = icmp ne i64 %t2401, 0
br i1 %t2402, label %L910, label %L912
L910:
%t2403 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
L912:
%t2405 = mul i64 %p5, 8
%t2406 = add i64 %p1, %t2405
%t2407 = add i64 %p0, %p4
%t2408 = call i64 @st64(i64 %t2406, i64 %t2407)
%t2409 = add nsw i64 %p2, 1
%t2410 = add nsw i64 %p2, 1
%t2411 = add i64 %p5, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @rt_args_count() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2413 = call i64 @__mruntime_rt_sys_resid__args_load()
%t2414 = mul nsw i64 %t2413, 0
%t2415 = call i64 @__mruntime_rt_sys_resid__args_state()
%t2416 = call i64 @ld64(i64 %t2415)
%t2417 = add nsw i64 %t2414, %t2416
ret i64 %t2417
}
define i64 @resid_args_count() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_args_count()
ret i64 %r
}
define internal i64 @rt_args_get(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2418 = call i64 @__mruntime_rt_sys_resid__args_load()
%t2419 = call i64 @__mruntime_rt_sys_resid__args_state()
%t2420 = icmp slt i64 %p0, 0
br label %LSL2421
LSL2421:
br i1 %t2420, label %LSJ2421, label %LSR2421
LSR2421:
%t2422 = call i64 @ld64(i64 %t2419)
%t2423 = icmp sge i64 %p0, %t2422
br label %LSJ2421
LSJ2421:
%t2424 = phi i1 [ true, %LSL2421 ], [ %t2423, %LSR2421 ]
br i1 %t2424, label %L913, label %L915
L913:
%t2425 = call i64 @xempty()
ret i64 %t2425
L915:
%t2426 = add i64 %t2419, 16
%t2427 = call i64 @ld64(i64 %t2426)
%t2428 = mul i64 %p0, 8
%t2429 = add i64 %t2427, %t2428
%t2430 = call i64 @ld64(i64 %t2429)
%t2431 = tail call i64 @cstr_dup(i64 %t2430)
ret i64 %t2431
}
define ptr @resid_args_get(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_args_get(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_sys_resid__split_argv(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2432 = call i64 @cstr_dup(i64 %p0)
%t2433 = mul nsw i64 65, 8
%t2434 = call i64 @xmalloc(i64 %t2433)
%t2435 = call i64 @__mruntime_rt_sys_resid__argv_at(i64 %t2432, i64 %t2434, i64 0)
%t2436 = mul i64 %t2435, 8
%t2437 = add i64 %t2434, %t2436
%t2438 = call i64 @st64(i64 %t2437, i64 0)
%t2439 = icmp eq i64 %t2435, 0
br i1 %t2439, label %L916, label %L918
L916:
%t2440 = call i64 @c_free(i64 %t2432)
%t2441 = call i64 @c_free(i64 %t2434)
%t2442 = add i64 %t2440, %t2441
ret i64 %t2442
L918:
ret i64 %t2434
}
define internal i64 @__mruntime_rt_sys_resid__skip_sp(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t2445, %tco.s0 ]
%t2443 = call i64 @ld8(i64 %p0)
%t2444 = icmp eq i64 %t2443, 32
br i1 %t2444, label %L919, label %L921
L919:
%t2445 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
L921:
ret i64 %p0
}
define internal i64 @__mruntime_rt_sys_resid__word_end(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t2452, %tco.s0 ]
%t2447 = call i64 @ld8(i64 %p0)
%t2448 = icmp eq i64 %t2447, 0
br label %LSL2449
LSL2449:
br i1 %t2448, label %LSJ2449, label %LSR2449
LSR2449:
%t2450 = icmp eq i64 %t2447, 32
br label %LSJ2449
LSJ2449:
%t2451 = phi i1 [ true, %LSL2449 ], [ %t2450, %LSR2449 ]
br i1 %t2451, label %L922, label %L924
L922:
ret i64 %p0
L924:
%t2452 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__argv_at(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t2466, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2467, %tco.s0 ]
%t2454 = icmp sge i64 %p2, 64
br i1 %t2454, label %L925, label %L927
L925:
ret i64 %p2
L927:
%t2455 = call i64 @__mruntime_rt_sys_resid__skip_sp(i64 %p0)
%t2456 = call i64 @ld8(i64 %t2455)
%t2457 = icmp eq i64 %t2456, 0
br i1 %t2457, label %L928, label %L930
L928:
ret i64 %p2
L930:
%t2458 = mul i64 %p2, 8
%t2459 = add i64 %p1, %t2458
%t2460 = call i64 @st64(i64 %t2459, i64 %t2455)
%t2461 = call i64 @__mruntime_rt_sys_resid__word_end(i64 %t2455)
%t2462 = call i64 @ld8(i64 %t2461)
%t2463 = icmp eq i64 %t2462, 0
br i1 %t2463, label %L931, label %L933
L931:
%t2464 = add nsw i64 %p2, 1
ret i64 %t2464
L933:
%t2465 = call i64 @st8(i64 %t2461, i64 0)
%t2466 = add i64 %t2461, 1
%t2467 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__free_argv(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2469 = call i64 @ld64(i64 %p0)
%t2470 = call i64 @c_free(i64 %t2469)
%t2471 = call i64 @c_free(i64 %p0)
%t2472 = add i64 %t2470, %t2471
ret i64 %t2472
}
define internal i64 @__mruntime_rt_sys_resid__wait_pid(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2473p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.wait_status)
%t2473 = ptrtoint ptr %t2473p to i64
%t2474 = call i64 @st64(i64 %t2473, i64 0)
%t2475 = call i64 @__mruntime_rt_sys_resid__sc4(i64 61, i64 %p0, i64 %t2473, i64 %p1, i64 0)
%t2476 = icmp slt i64 %t2475, 0
br i1 %t2476, label %L934, label %L936
L934:
%t2477 = sub nsw i64 0, 1
ret i64 %t2477
L936:
%t2478 = call i64 @ld32(i64 %t2473)
ret i64 %t2478
}
define internal i64 @__mruntime_rt_sys_resid__exit_code(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2479 = and i64 %p0, 127
%t2480 = icmp eq i64 %t2479, 0
br i1 %t2480, label %L937, label %L938
L937:
%t2481 = ashr i64 %p0, 8
%t2482 = and i64 %t2481, 255
br label %L939
L938:
%t2483 = sub nsw i64 0, 1
br label %L939
L939:
%t2484 = phi i64 [ %t2482, %L937 ], [ %t2483, %L938 ]
ret i64 %t2484
}
define internal i64 @rt_process_run(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2485 = icmp eq i64 %p0, 0
br i1 %t2485, label %L940, label %L942
L940:
%t2486 = sub nsw i64 0, 1
ret i64 %t2486
L942:
%t2487 = call i64 @__mruntime_rt_sys_resid__split_argv(i64 %p0)
%t2488 = icmp eq i64 %t2487, 0
br i1 %t2488, label %L943, label %L945
L943:
%t2489 = sub nsw i64 0, 1
ret i64 %t2489
L945:
%t2490 = call i64 @c_fork()
%t2491 = icmp slt i64 %t2490, 0
br i1 %t2491, label %L946, label %L948
L946:
%t2492 = call i64 @__mruntime_rt_sys_resid__free_argv(i64 %t2487)
%t2493 = sub i64 %t2492, 1
ret i64 %t2493
L948:
%t2494 = icmp eq i64 %t2490, 0
br i1 %t2494, label %L949, label %L951
L949:
%t2495 = call i64 @ld64(i64 %t2487)
%t2496 = call i64 @c_execvp(i64 %t2495, i64 %t2487)
%t2497 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 231, i64 127, i64 0, i64 0, i64 0, i64 0, i64 0)
ret i64 %t2497
L951:
%t2498 = call i64 @__mruntime_rt_sys_resid__wait_pid(i64 %t2490, i64 0)
%t2499 = call i64 @__mruntime_rt_sys_resid__free_argv(i64 %t2487)
%t2500 = icmp slt i64 %t2498, 0
br i1 %t2500, label %L952, label %L954
L952:
%t2501 = sub nsw i64 0, 1
ret i64 %t2501
L954:
%t2502 = tail call i64 @__mruntime_rt_sys_resid__exit_code(i64 %t2498)
ret i64 %t2502
}
define i64 @resid_process_run(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_process_run(i64 %x0i)
ret i64 %r
}
define internal i1 @__mruntime_rt_sys_resid__ref_ok(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2503 = call i64 @ld8(i64 %p0)
%t2504 = icmp eq i64 %t2503, 0
br i1 %t2504, label %L955, label %L957
L955:
ret i1 true
L957:
%t2505 = icmp sge i64 %t2503, 97
br label %LSL2506
LSL2506:
br i1 %t2505, label %LSR2506, label %LSJ2506
LSR2506:
%t2507 = icmp sle i64 %t2503, 122
br label %LSJ2506
LSJ2506:
%t2508 = phi i1 [ false, %LSL2506 ], [ %t2507, %LSR2506 ]
br label %LSL2509
LSL2509:
br i1 %t2508, label %LSJ2509, label %LSR2509
LSR2509:
%t2510 = icmp sge i64 %t2503, 65
br label %LSL2511
LSL2511:
br i1 %t2510, label %LSR2511, label %LSJ2511
LSR2511:
%t2512 = icmp sle i64 %t2503, 90
br label %LSJ2511
LSJ2511:
%t2513 = phi i1 [ false, %LSL2511 ], [ %t2512, %LSR2511 ]
br label %LSJ2509
LSJ2509:
%t2514 = phi i1 [ true, %LSL2509 ], [ %t2513, %LSJ2511 ]
br label %LSL2515
LSL2515:
br i1 %t2514, label %LSJ2515, label %LSR2515
LSR2515:
%t2516 = icmp sge i64 %t2503, 48
br label %LSL2517
LSL2517:
br i1 %t2516, label %LSR2517, label %LSJ2517
LSR2517:
%t2518 = icmp sle i64 %t2503, 57
br label %LSJ2517
LSJ2517:
%t2519 = phi i1 [ false, %LSL2517 ], [ %t2518, %LSR2517 ]
br label %LSJ2515
LSJ2515:
%t2520 = phi i1 [ true, %LSL2515 ], [ %t2519, %LSJ2517 ]
br label %LSL2521
LSL2521:
br i1 %t2520, label %LSJ2521, label %LSR2521
LSR2521:
%t2522 = icmp eq i64 %t2503, 45
br label %LSJ2521
LSJ2521:
%t2523 = phi i1 [ true, %LSL2521 ], [ %t2522, %LSR2521 ]
br label %LSL2524
LSL2524:
br i1 %t2523, label %LSJ2524, label %LSR2524
LSR2524:
%t2525 = icmp eq i64 %t2503, 95
br label %LSJ2524
LSJ2524:
%t2526 = phi i1 [ true, %LSL2524 ], [ %t2525, %LSR2524 ]
br label %LSL2527
LSL2527:
br i1 %t2526, label %LSJ2527, label %LSR2527
LSR2527:
%t2528 = icmp eq i64 %t2503, 47
br label %LSJ2527
LSJ2527:
%t2529 = phi i1 [ true, %LSL2527 ], [ %t2528, %LSR2527 ]
br label %LSL2530
LSL2530:
br i1 %t2529, label %LSJ2530, label %LSR2530
LSR2530:
%t2531 = icmp eq i64 %t2503, 46
br label %LSJ2530
LSJ2530:
%t2532 = phi i1 [ true, %LSL2530 ], [ %t2531, %LSR2530 ]
br label %LSL2533
LSL2533:
br i1 %t2532, label %LSR2533, label %LSJ2533
LSR2533:
%t2534 = add i64 %p0, 1
%t2535 = call i1 @__mruntime_rt_sys_resid__ref_ok(i64 %t2534)
br label %LSJ2533
LSJ2533:
%t2536 = phi i1 [ false, %LSL2533 ], [ %t2535, %LSR2533 ]
ret i1 %t2536
}
define internal i64 @__mruntime_rt_sys_resid__popen_line(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2538 = ptrtoint ptr @.s2537 to i64
%t2539 = call i64 @c_popen(i64 %p0, i64 %t2538)
%t2540 = icmp eq i64 %t2539, 0
br i1 %t2540, label %L958, label %L960
L958:
%t2541 = call i64 @xempty()
ret i64 %t2541
L960:
%t2542 = call i64 @xmalloc(i64 256)
%t2543 = call i64 @c_fgets(i64 %t2542, i64 256, i64 %t2539)
%t2544 = call i64 @c_pclose(i64 %t2539)
%t2545 = icmp eq i64 %t2543, 0
br i1 %t2545, label %L961, label %L963
L961:
%t2546 = call i64 @st8(i64 %t2542, i64 0)
%t2547 = add i64 %t2546, %t2542
ret i64 %t2547
L963:
%t2548 = call i64 @c_strlen(i64 %t2542)
%t2549 = icmp sgt i64 %t2548, 0
br label %LSL2550
LSL2550:
br i1 %t2549, label %LSR2550, label %LSJ2550
LSR2550:
%t2551 = add i64 %t2542, %t2548
%t2552 = sub nsw i64 %t2551, 1
%t2553 = call i64 @ld8(i64 %t2552)
%t2554 = icmp eq i64 %t2553, 10
br label %LSJ2550
LSJ2550:
%t2555 = phi i1 [ false, %LSL2550 ], [ %t2554, %LSR2550 ]
br i1 %t2555, label %L964, label %L965
L964:
%t2556 = add i64 %t2542, %t2548
%t2557 = sub nsw i64 %t2556, 1
%t2558 = call i64 @st8(i64 %t2557, i64 0)
br label %L966
L965:
br label %L966
L966:
%t2559 = phi i64 [ %t2558, %L964 ], [ 0, %L965 ]
ret i64 %t2542
}
define internal i64 @rt_git_rev(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2560 = icmp eq i64 %p0, 0
br label %LSL2561
LSL2561:
br i1 %t2560, label %LSJ2561, label %LSR2561
LSR2561:
%t2562 = call i64 @ld8(i64 %p0)
%t2563 = icmp eq i64 %t2562, 0
br label %LSJ2561
LSJ2561:
%t2564 = phi i1 [ true, %LSL2561 ], [ %t2563, %LSR2561 ]
br label %LSL2565
LSL2565:
br i1 %t2564, label %LSJ2565, label %LSR2565
LSR2565:
%t2566 = call i1 @__mruntime_rt_sys_resid__ref_ok(i64 %p0)
%t2567 = xor i1 %t2566, true
br label %LSJ2565
LSJ2565:
%t2568 = phi i1 [ true, %LSL2565 ], [ %t2567, %LSR2565 ]
br label %LSL2569
LSL2569:
br i1 %t2568, label %LSJ2569, label %LSR2569
LSR2569:
%t2570 = call i64 @c_strlen(i64 %p0)
%t2571 = icmp sgt i64 %t2570, 4000
br label %LSJ2569
LSJ2569:
%t2572 = phi i1 [ true, %LSL2569 ], [ %t2571, %LSR2569 ]
br i1 %t2572, label %L967, label %L969
L967:
%t2573 = call i64 @xempty()
ret i64 %t2573
L969:
%t2575 = ptrtoint ptr @.s2574 to i64
%t2576 = call i64 @rt_str_concat(i64 %t2575, i64 %p0)
%t2578 = ptrtoint ptr @.s2577 to i64
%t2579 = call i64 @rt_str_concat(i64 %t2576, i64 %t2578)
%t2580 = tail call i64 @__mruntime_rt_sys_resid__popen_line(i64 %t2579)
ret i64 %t2580
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
%t2582 = ptrtoint ptr @.s2581 to i64
%t2583 = call i64 @__mruntime_rt_sys_resid__popen_line(i64 %t2582)
%t2584 = call i64 @__mruntime_rt_sys_resid__sanitize_ref(i64 %t2583)
ret i64 %t2583
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
%p0 = phi i64 [ %p0.in, %entry ], [ %t2617, %tco.s0 ]
%t2585 = call i64 @ld8(i64 %p0)
%t2586 = icmp eq i64 %t2585, 0
br i1 %t2586, label %L970, label %L972
L970:
ret i64 0
L972:
%t2587 = icmp sge i64 %t2585, 97
br label %LSL2588
LSL2588:
br i1 %t2587, label %LSR2588, label %LSJ2588
LSR2588:
%t2589 = icmp sle i64 %t2585, 122
br label %LSJ2588
LSJ2588:
%t2590 = phi i1 [ false, %LSL2588 ], [ %t2589, %LSR2588 ]
br label %LSL2591
LSL2591:
br i1 %t2590, label %LSJ2591, label %LSR2591
LSR2591:
%t2592 = icmp sge i64 %t2585, 65
br label %LSL2593
LSL2593:
br i1 %t2592, label %LSR2593, label %LSJ2593
LSR2593:
%t2594 = icmp sle i64 %t2585, 90
br label %LSJ2593
LSJ2593:
%t2595 = phi i1 [ false, %LSL2593 ], [ %t2594, %LSR2593 ]
br label %LSJ2591
LSJ2591:
%t2596 = phi i1 [ true, %LSL2591 ], [ %t2595, %LSJ2593 ]
br label %LSL2597
LSL2597:
br i1 %t2596, label %LSJ2597, label %LSR2597
LSR2597:
%t2598 = icmp sge i64 %t2585, 48
br label %LSL2599
LSL2599:
br i1 %t2598, label %LSR2599, label %LSJ2599
LSR2599:
%t2600 = icmp sle i64 %t2585, 57
br label %LSJ2599
LSJ2599:
%t2601 = phi i1 [ false, %LSL2599 ], [ %t2600, %LSR2599 ]
br label %LSJ2597
LSJ2597:
%t2602 = phi i1 [ true, %LSL2597 ], [ %t2601, %LSJ2599 ]
br label %LSL2603
LSL2603:
br i1 %t2602, label %LSJ2603, label %LSR2603
LSR2603:
%t2604 = icmp eq i64 %t2585, 45
br label %LSJ2603
LSJ2603:
%t2605 = phi i1 [ true, %LSL2603 ], [ %t2604, %LSR2603 ]
br label %LSL2606
LSL2606:
br i1 %t2605, label %LSJ2606, label %LSR2606
LSR2606:
%t2607 = icmp eq i64 %t2585, 95
br label %LSJ2606
LSJ2606:
%t2608 = phi i1 [ true, %LSL2606 ], [ %t2607, %LSR2606 ]
br label %LSL2609
LSL2609:
br i1 %t2608, label %LSJ2609, label %LSR2609
LSR2609:
%t2610 = icmp eq i64 %t2585, 47
br label %LSJ2609
LSJ2609:
%t2611 = phi i1 [ true, %LSL2609 ], [ %t2610, %LSR2609 ]
br label %LSL2612
LSL2612:
br i1 %t2611, label %LSJ2612, label %LSR2612
LSR2612:
%t2613 = icmp eq i64 %t2585, 46
br label %LSJ2612
LSJ2612:
%t2614 = phi i1 [ true, %LSL2612 ], [ %t2613, %LSR2612 ]
br i1 %t2614, label %L973, label %L974
L973:
br label %L975
L974:
%t2615 = call i64 @st8(i64 %p0, i64 95)
br label %L975
L975:
%t2616 = phi i64 [ 0, %L973 ], [ %t2615, %L974 ]
%t2617 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__sha_k() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2619 = ptrtoint ptr @rtt.16828 to i64
ret i64 %t2619
}
define internal i64 @__mruntime_rt_sys_resid__m32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2620 = and i64 %p0, 4294967295
ret i64 %t2620
}
define internal i64 @__mruntime_rt_sys_resid__ror32(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2621 = icmp uge i64 %p1, 64
%t2622 = add i64 %p1, 0
%t2623 = select i1 %t2621, i64 63, i64 %t2622
%t2624 = ashr i64 %p0, %t2623
%t2625 = sub i64 32, %p1
%t2626 = icmp uge i64 %t2625, 64
%t2627 = add i64 %t2625, 0
%t2628 = shl i64 %p0, %t2627
%t2629 = select i1 %t2626, i64 0, i64 %t2628
%t2630 = or i64 %t2624, %t2629
%t2631 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2630)
ret i64 %t2631
}
define internal i64 @__mruntime_rt_sys_resid__sha_block(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2632 = call i64 @__mruntime_rt_sys_resid__sha_load(i64 %p2, i64 %p1, i64 0)
%t2633 = call i64 @__mruntime_rt_sys_resid__sha_expand(i64 %p2, i64 16)
%t2634 = call i64 @ld64(i64 %p0)
%t2635 = add i64 %p0, 8
%t2636 = call i64 @ld64(i64 %t2635)
%t2637 = add i64 %p0, 16
%t2638 = call i64 @ld64(i64 %t2637)
%t2639 = add i64 %p0, 24
%t2640 = call i64 @ld64(i64 %t2639)
%t2641 = add i64 %p0, 32
%t2642 = call i64 @ld64(i64 %t2641)
%t2643 = add i64 %p0, 40
%t2644 = call i64 @ld64(i64 %t2643)
%t2645 = add i64 %p0, 48
%t2646 = call i64 @ld64(i64 %t2645)
%t2647 = add i64 %p0, 56
%t2648 = call i64 @ld64(i64 %t2647)
%t2649 = call i64 @__mruntime_rt_sys_resid__sha_rounds(i64 %p0, i64 %p2, i64 0, i64 %t2634, i64 %t2636, i64 %t2638, i64 %t2640, i64 %t2642, i64 %t2644, i64 %t2646, i64 %t2648)
ret i64 0
}
define internal i64 @__mruntime_rt_sys_resid__sha_load(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2675, %tco.s0 ]
%t2650 = icmp sge i64 %p2, 16
br i1 %t2650, label %L976, label %L978
L976:
ret i64 0
L978:
%t2651 = mul i64 4, %p2
%t2652 = add i64 %p1, %t2651
%t2653 = call i64 @ld8(i64 %t2652)
%t2654 = shl i64 %t2653, 24
%t2655 = mul i64 4, %p2
%t2656 = add i64 %p1, %t2655
%t2657 = add i64 %t2656, 1
%t2658 = call i64 @ld8(i64 %t2657)
%t2659 = shl i64 %t2658, 16
%t2660 = or i64 %t2654, %t2659
%t2661 = mul i64 4, %p2
%t2662 = add i64 %p1, %t2661
%t2663 = add i64 %t2662, 2
%t2664 = call i64 @ld8(i64 %t2663)
%t2665 = shl i64 %t2664, 8
%t2666 = or i64 %t2660, %t2665
%t2667 = mul i64 4, %p2
%t2668 = add i64 %p1, %t2667
%t2669 = add i64 %t2668, 3
%t2670 = call i64 @ld8(i64 %t2669)
%t2671 = or i64 %t2666, %t2670
%t2672 = mul i64 %p2, 8
%t2673 = add i64 %p0, %t2672
%t2674 = call i64 @st64(i64 %t2673, i64 %t2671)
%t2675 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__sha_expand(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2711, %tco.s0 ]
%t2677 = icmp sge i64 %p1, 64
br i1 %t2677, label %L979, label %L981
L979:
ret i64 0
L981:
%t2678 = sub i64 %p1, 15
%t2679 = mul i64 %t2678, 8
%t2680 = add i64 %p0, %t2679
%t2681 = call i64 @ld64(i64 %t2680)
%t2682 = sub i64 %p1, 2
%t2683 = mul i64 %t2682, 8
%t2684 = add i64 %p0, %t2683
%t2685 = call i64 @ld64(i64 %t2684)
%t2686 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %t2681, i64 7)
%t2687 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %t2681, i64 18)
%t2688 = xor i64 %t2686, %t2687
%t2689 = ashr i64 %t2681, 3
%t2690 = xor i64 %t2688, %t2689
%t2691 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %t2685, i64 17)
%t2692 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %t2685, i64 19)
%t2693 = xor i64 %t2691, %t2692
%t2694 = ashr i64 %t2685, 10
%t2695 = xor i64 %t2693, %t2694
%t2696 = mul i64 %p1, 8
%t2697 = add i64 %p0, %t2696
%t2698 = sub i64 %p1, 16
%t2699 = mul i64 %t2698, 8
%t2700 = add i64 %p0, %t2699
%t2701 = call i64 @ld64(i64 %t2700)
%t2702 = add i64 %t2701, %t2690
%t2703 = sub i64 %p1, 7
%t2704 = mul i64 %t2703, 8
%t2705 = add i64 %p0, %t2704
%t2706 = call i64 @ld64(i64 %t2705)
%t2707 = add i64 %t2702, %t2706
%t2708 = add i64 %t2707, %t2695
%t2709 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2708)
%t2710 = call i64 @st64(i64 %t2697, i64 %t2709)
%t2711 = add nsw i64 %p1, 1
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t2794, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t2796, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p3, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0 ]
%p7 = phi i64 [ %p7.in, %entry ], [ %t2798, %tco.s0 ]
%p8 = phi i64 [ %p8.in, %entry ], [ %p7, %tco.s0 ]
%p9 = phi i64 [ %p9.in, %entry ], [ %p8, %tco.s0 ]
%p10 = phi i64 [ %p10.in, %entry ], [ %p9, %tco.s0 ]
%t2713 = icmp sge i64 %p2, 64
br i1 %t2713, label %L982, label %L984
L982:
%t2714 = call i64 @ld64(i64 %p0)
%t2715 = add i64 %t2714, %p3
%t2716 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2715)
%t2717 = call i64 @st64(i64 %p0, i64 %t2716)
%t2718 = add i64 %p0, 8
%t2719 = add i64 %p0, 8
%t2720 = call i64 @ld64(i64 %t2719)
%t2721 = add i64 %t2720, %p4
%t2722 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2721)
%t2723 = call i64 @st64(i64 %t2718, i64 %t2722)
%t2724 = add i64 %p0, 16
%t2725 = add i64 %p0, 16
%t2726 = call i64 @ld64(i64 %t2725)
%t2727 = add i64 %t2726, %p5
%t2728 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2727)
%t2729 = call i64 @st64(i64 %t2724, i64 %t2728)
%t2730 = add i64 %p0, 24
%t2731 = add i64 %p0, 24
%t2732 = call i64 @ld64(i64 %t2731)
%t2733 = add i64 %t2732, %p6
%t2734 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2733)
%t2735 = call i64 @st64(i64 %t2730, i64 %t2734)
%t2736 = add i64 %p0, 32
%t2737 = add i64 %p0, 32
%t2738 = call i64 @ld64(i64 %t2737)
%t2739 = add i64 %t2738, %p7
%t2740 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2739)
%t2741 = call i64 @st64(i64 %t2736, i64 %t2740)
%t2742 = add i64 %p0, 40
%t2743 = add i64 %p0, 40
%t2744 = call i64 @ld64(i64 %t2743)
%t2745 = add i64 %t2744, %p8
%t2746 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2745)
%t2747 = call i64 @st64(i64 %t2742, i64 %t2746)
%t2748 = add i64 %p0, 48
%t2749 = add i64 %p0, 48
%t2750 = call i64 @ld64(i64 %t2749)
%t2751 = add i64 %t2750, %p9
%t2752 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2751)
%t2753 = call i64 @st64(i64 %t2748, i64 %t2752)
%t2754 = add i64 %p0, 56
%t2755 = add i64 %p0, 56
%t2756 = call i64 @ld64(i64 %t2755)
%t2757 = add i64 %t2756, %p10
%t2758 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2757)
%t2759 = call i64 @st64(i64 %t2754, i64 %t2758)
ret i64 %t2759
L984:
%t2760 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %p7, i64 6)
%t2761 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %p7, i64 11)
%t2762 = xor i64 %t2760, %t2761
%t2763 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %p7, i64 25)
%t2764 = xor i64 %t2762, %t2763
%t2765 = add i64 %p10, %t2764
%t2766 = and i64 %p7, %p8
%t2767 = xor i64 %p7, -1
%t2768 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2767)
%t2769 = and i64 %t2768, %p9
%t2770 = xor i64 %t2766, %t2769
%t2771 = add i64 %t2765, %t2770
%t2772 = call i64 @__mruntime_rt_sys_resid__sha_k()
%t2773 = mul i64 %p2, 8
%t2774 = add i64 %t2772, %t2773
%t2775 = call i64 @ld64(i64 %t2774)
%t2776 = add i64 %t2771, %t2775
%t2777 = mul i64 %p2, 8
%t2778 = add i64 %p1, %t2777
%t2779 = call i64 @ld64(i64 %t2778)
%t2780 = add i64 %t2776, %t2779
%t2781 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2780)
%t2782 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %p3, i64 2)
%t2783 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %p3, i64 13)
%t2784 = xor i64 %t2782, %t2783
%t2785 = call i64 @__mruntime_rt_sys_resid__ror32(i64 %p3, i64 22)
%t2786 = xor i64 %t2784, %t2785
%t2787 = and i64 %p3, %p4
%t2788 = and i64 %p3, %p5
%t2789 = xor i64 %t2787, %t2788
%t2790 = and i64 %p4, %p5
%t2791 = xor i64 %t2789, %t2790
%t2792 = add i64 %t2786, %t2791
%t2793 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2792)
%t2794 = add nsw i64 %p2, 1
%t2795 = add i64 %t2781, %t2793
%t2796 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2795)
%t2797 = add i64 %p6, %t2781
%t2798 = call i64 @__mruntime_rt_sys_resid__m32(i64 %t2797)
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__sha_new() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2800 = add nsw i64 64, 512
%t2801 = add nsw i64 %t2800, 128
%t2802 = call i64 @xmalloc(i64 %t2801)
%t2803 = ptrtoint ptr @rtt.17342 to i64
%t2804 = call i64 @mcopy(i64 %t2802, i64 %t2803, i64 64)
%t2805 = add i64 %t2804, %t2802
ret i64 %t2805
}
define internal i64 @__mruntime_rt_sys_resid__sha_bytes(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2806 = sub nsw i64 0, 64
%t2807 = and i64 %p2, %t2806
%t2808 = call i64 @__mruntime_rt_sys_resid__sha_blocks(i64 %p0, i64 %p1, i64 0, i64 %t2807)
ret i64 %t2807
}
define internal i64 @__mruntime_rt_sys_resid__sha_blocks(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2813, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t2809 = icmp sge i64 %p2, %p3
br i1 %t2809, label %L985, label %L987
L985:
ret i64 0
L987:
%t2810 = add i64 %p1, %p2
%t2811 = add i64 %p0, 64
%t2812 = call i64 @__mruntime_rt_sys_resid__sha_block(i64 %p0, i64 %t2810, i64 %t2811)
%t2813 = add i64 %p2, 64
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__sha_finish(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2815 = add i64 %p0, 576
%t2816 = call i64 @mcopy(i64 %t2815, i64 %p1, i64 %p2)
%t2817 = add i64 %t2815, %p2
%t2818 = call i64 @st8(i64 %t2817, i64 128)
%t2819 = add i64 %p2, 1
%t2820 = icmp sle i64 %t2819, 56
br i1 %t2820, label %L988, label %L989
L988:
br label %L990
L989:
br label %L990
L990:
%t2821 = phi i64 [ 64, %L988 ], [ 128, %L989 ]
%t2822 = add i64 %t2815, %p2
%t2823 = add i64 %t2822, 1
%t2824 = sub i64 %t2821, %p2
%t2825 = sub i64 %t2824, 1
%t2826p = inttoptr i64 %t2823 to ptr
%t2826q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t2826p, i8 %t2826q, i64 %t2825, i1 false)
%t2826 = add i64 0, 0
%t2827 = mul i64 %p3, 8
%t2828 = add i64 %t2815, %t2821
%t2829 = sub i64 %t2828, 8
%t2830 = call i64 @__mruntime_rt_sys_resid__sha_len(i64 %t2829, i64 %t2827, i64 0)
%t2831 = tail call i64 @__mruntime_rt_sys_resid__sha_blocks(i64 %p0, i64 %t2815, i64 0, i64 %t2821)
ret i64 %t2831
}
define internal i64 @__mruntime_rt_sys_resid__sha_len(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2838, %tco.s0 ]
%t2832 = icmp sge i64 %p2, 8
br i1 %t2832, label %L991, label %L993
L991:
ret i64 0
L993:
%t2833 = add i64 %p0, 7
%t2834 = sub i64 %t2833, %p2
%t2835 = mul i64 8, %p2
%t2836 = call i64 @lshr(i64 %p1, i64 %t2835)
%t2837 = call i64 @st8(i64 %t2834, i64 %t2836)
%t2838 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__sha_byte(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2840 = sdiv i64 %p1, 4
%t2841 = mul i64 %t2840, 8
%t2842 = add i64 %p0, %t2841
%t2843 = call i64 @ld64(i64 %t2842)
%t2844 = srem i64 %p1, 4
%t2845 = mul nsw i64 8, %t2844
%t2846 = sub nsw i64 24, %t2845
%t2847 = icmp uge i64 %t2846, 64
%t2848 = add i64 %t2846, 0
%t2849 = select i1 %t2847, i64 63, i64 %t2848
%t2850 = ashr i64 %t2843, %t2849
%t2851 = and i64 %t2850, 255
ret i64 %t2851
}
define internal i64 @rt_fs_sha256(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2852 = call i1 @__mruntime_rt_sys_resid__path_ok(i64 %p0)
%t2853 = xor i1 %t2852, true
br i1 %t2853, label %L994, label %L996
L994:
%t2854 = call i64 @__mruntime_rt_sys_resid__empty_bytes()
ret i64 %t2854
L996:
%t2855 = call i64 @__mruntime_rt_sys_resid__o_rdonly()
%t2856 = call i64 @sys_open(i64 %p0, i64 %t2855, i64 0)
%t2857 = icmp slt i64 %t2856, 0
br i1 %t2857, label %L997, label %L999
L997:
%t2858 = call i64 @__mruntime_rt_sys_resid__empty_bytes()
ret i64 %t2858
L999:
%t2859 = call i64 @__mruntime_rt_sys_resid__sha_new()
%t2860 = call i64 @xmalloc(i64 65536)
%t2861 = call i64 @__mruntime_rt_sys_resid__sha_file(i64 %t2856, i64 %t2859, i64 %t2860, i64 0, i64 0)
%t2862 = call i64 @sys_close(i64 %t2856)
%t2863 = srem i64 %t2861, 64
%t2864 = call i64 @__mruntime_rt_sys_resid__sha_finish(i64 %t2859, i64 %t2860, i64 %t2863, i64 %t2861)
%t2865 = call i64 @xmalloc(i64 32)
%t2866 = call i64 @__mruntime_rt_sys_resid__sha_out(i64 %t2859, i64 %t2865, i64 0)
%t2867 = call i64 @__mruntime_rt_sys_resid__bytes_list(i64 %t2865, i64 32)
%t2868 = call i64 @c_free(i64 %t2865)
%t2869 = call i64 @c_free(i64 %t2860)
%t2870 = add i64 %t2868, %t2869
%t2871 = call i64 @c_free(i64 %t2859)
%t2872 = add i64 %t2870, %t2871
%t2873 = add i64 %t2872, %t2867
ret i64 %t2873
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t2880, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t2883, %tco.s0 ]
%t2874 = add i64 %p2, %p3
%t2875 = sub i64 65536, %p3
%t2876 = call i64 @__mruntime_rt_sys_resid__sc(i64 0, i64 %p0, i64 %t2874, i64 %t2875)
%t2877 = icmp sle i64 %t2876, 0
br i1 %t2877, label %L1000, label %L1002
L1000:
ret i64 %p4
L1002:
%t2878 = add i64 %p3, %t2876
%t2879 = call i64 @__mruntime_rt_sys_resid__sha_bytes(i64 %p1, i64 %p2, i64 %t2878)
%t2880 = sub i64 %t2878, %t2879
%t2881 = add i64 %p2, %t2879
%t2882 = call i64 @mcopy(i64 %p2, i64 %t2881, i64 %t2880)
%t2883 = add i64 %p4, %t2876
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t2889, %tco.s0 ]
%t2885 = icmp sge i64 %p2, 32
br i1 %t2885, label %L1003, label %L1005
L1003:
ret i64 0
L1005:
%t2886 = add i64 %p1, %p2
%t2887 = call i64 @__mruntime_rt_sys_resid__sha_byte(i64 %p0, i64 %p2)
%t2888 = call i64 @st8(i64 %t2886, i64 %t2887)
%t2889 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_sha256(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2891 = call i64 @c_strlen(i64 %p0)
%t2892 = call i64 @__mruntime_rt_sys_resid__sha_new()
%t2893 = call i64 @__mruntime_rt_sys_resid__sha_bytes(i64 %t2892, i64 %p0, i64 %t2891)
%t2894 = add i64 %p0, %t2893
%t2895 = sub i64 %t2891, %t2893
%t2896 = call i64 @__mruntime_rt_sys_resid__sha_finish(i64 %t2892, i64 %t2894, i64 %t2895, i64 %t2891)
%t2897 = call i64 @xmalloc(i64 65)
%t2898 = call i64 @__mruntime_rt_sys_resid__sha_hex(i64 %t2892, i64 %t2897, i64 0)
%t2899 = add i64 %t2897, 64
%t2900 = call i64 @st8(i64 %t2899, i64 0)
%t2901 = call i64 @c_free(i64 %t2892)
%t2902 = add i64 %t2901, %t2897
ret i64 %t2902
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t2920, %tco.s0 ]
%t2903 = icmp sge i64 %p2, 32
br i1 %t2903, label %L1006, label %L1008
L1006:
ret i64 0
L1008:
%t2904 = call i64 @__mruntime_rt_sys_resid__sha_byte(i64 %p0, i64 %p2)
%t2906 = ptrtoint ptr @.s2905 to i64
%t2907 = mul i64 2, %p2
%t2908 = add i64 %p1, %t2907
%t2909 = ashr i64 %t2904, 4
%t2910 = add i64 %t2906, %t2909
%t2911 = call i64 @ld8(i64 %t2910)
%t2912 = call i64 @st8(i64 %t2908, i64 %t2911)
%t2913 = mul i64 2, %p2
%t2914 = add i64 %p1, %t2913
%t2915 = add i64 %t2914, 1
%t2916 = and i64 %t2904, 15
%t2917 = add i64 %t2906, %t2916
%t2918 = call i64 @ld8(i64 %t2917)
%t2919 = call i64 @st8(i64 %t2915, i64 %t2918)
%t2920 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__dbg() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2922p = getelementptr i8, ptr @rtg.rt_dbg, i64 0
%t2922 = ptrtoint ptr %t2922p to i64
ret i64 %t2922
}
define internal i64 @__mruntime_rt_sys_resid__ptrace(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2923 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 101, i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 0)
ret i64 %t2923
}
define internal i1 @__mruntime_rt_sys_resid__dbg_known(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2934, %tco.s0 ]
%t2924 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2925 = add i64 %t2924, 8
%t2926 = call i64 @ld64(i64 %t2925)
%t2927 = icmp sge i64 %p1, %t2926
br i1 %t2927, label %L1009, label %L1011
L1009:
ret i1 false
L1011:
%t2928 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2929 = add i64 %t2928, 32
%t2930 = mul i64 %p1, 8
%t2931 = add i64 %t2929, %t2930
%t2932 = call i64 @ld64(i64 %t2931)
%t2933 = icmp eq i64 %t2932, %p0
br i1 %t2933, label %L1012, label %L1014
L1012:
ret i1 true
L1014:
%t2934 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_sys_resid__dbg_add(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2936 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2937 = add i64 %t2936, 8
%t2938 = call i64 @ld64(i64 %t2937)
%t2939 = call i1 @__mruntime_rt_sys_resid__dbg_known(i64 %p0, i64 0)
br label %LSL2940
LSL2940:
br i1 %t2939, label %LSJ2940, label %LSR2940
LSR2940:
%t2941 = icmp sge i64 %t2938, 1024
br label %LSJ2940
LSJ2940:
%t2942 = phi i1 [ true, %LSL2940 ], [ %t2941, %LSR2940 ]
br i1 %t2942, label %L1015, label %L1017
L1015:
ret i64 0
L1017:
%t2943 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2944 = add i64 %t2943, 32
%t2945 = mul i64 %t2938, 8
%t2946 = add i64 %t2944, %t2945
%t2947 = call i64 @st64(i64 %t2946, i64 %p0)
%t2948 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2949 = add i64 %t2948, 8
%t2950 = add nsw i64 %t2938, 1
%t2951 = call i64 @st64(i64 %t2949, i64 %t2950)
ret i64 %t2951
}
define internal i64 @__mruntime_rt_sys_resid__dbg_remove(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2952 = call i64 @__mruntime_rt_sys_resid__dbg_remove_at(i64 %p0, i64 0)
ret i64 %t2952
}
define internal i64 @__mruntime_rt_sys_resid__dbg_remove_at(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2963, %tco.s0 ]
%t2953 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2954 = add i64 %t2953, 8
%t2955 = call i64 @ld64(i64 %t2954)
%t2956 = icmp sge i64 %p1, %t2955
br i1 %t2956, label %L1018, label %L1020
L1018:
ret i64 0
L1020:
%t2957 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2958 = add i64 %t2957, 32
%t2959 = mul i64 %p1, 8
%t2960 = add i64 %t2958, %t2959
%t2961 = call i64 @ld64(i64 %t2960)
%t2962 = icmp ne i64 %t2961, %p0
br i1 %t2962, label %L1021, label %L1023
L1021:
%t2963 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L1023:
%t2965 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2966 = add i64 %t2965, 32
%t2967 = mul i64 %p1, 8
%t2968 = add i64 %t2966, %t2967
%t2969 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2970 = add i64 %t2969, 32
%t2971 = sub nsw i64 %t2955, 1
%t2972 = mul i64 %t2971, 8
%t2973 = add i64 %t2970, %t2972
%t2974 = call i64 @ld64(i64 %t2973)
%t2975 = call i64 @st64(i64 %t2968, i64 %t2974)
%t2976 = call i64 @__mruntime_rt_sys_resid__dbg()
%t2977 = add i64 %t2976, 8
%t2978 = sub nsw i64 %t2955, 1
%t2979 = tail call i64 @st64(i64 %t2977, i64 %t2978)
ret i64 %t2979
}
define internal i64 @rt_dbg_spawn(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2980 = icmp eq i64 %p0, 0
br i1 %t2980, label %L1024, label %L1026
L1024:
%t2981 = sub nsw i64 0, 1
ret i64 %t2981
L1026:
%t2982 = call i64 @__mruntime_rt_sys_resid__split_argv(i64 %p0)
%t2983 = icmp eq i64 %t2982, 0
br i1 %t2983, label %L1027, label %L1029
L1027:
%t2984 = sub nsw i64 0, 1
ret i64 %t2984
L1029:
%t2985 = call i64 @c_fork()
%t2986 = icmp slt i64 %t2985, 0
br i1 %t2986, label %L1030, label %L1032
L1030:
%t2987 = call i64 @__mruntime_rt_sys_resid__free_argv(i64 %t2982)
%t2988 = sub i64 %t2987, 1
ret i64 %t2988
L1032:
%t2989 = icmp eq i64 %t2985, 0
br i1 %t2989, label %L1033, label %L1035
L1033:
%t2990 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 0, i64 0, i64 0, i64 0)
%t2991 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 135, i64 262144, i64 0, i64 0, i64 0, i64 0, i64 0)
%t2992 = call i64 @ld64(i64 %t2982)
%t2993 = call i64 @c_execv(i64 %t2992, i64 %t2982)
%t2994 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 231, i64 127, i64 0, i64 0, i64 0, i64 0, i64 0)
ret i64 %t2994
L1035:
%t2995 = call i64 @__mruntime_rt_sys_resid__free_argv(i64 %t2982)
%t2996 = call i64 @__mruntime_rt_sys_resid__wait_pid(i64 %t2985, i64 0)
%t2997 = icmp slt i64 %t2996, 0
br label %LSL2998
LSL2998:
br i1 %t2997, label %LSJ2998, label %LSR2998
LSR2998:
%t2999 = and i64 %t2996, 255
%t3000 = icmp ne i64 %t2999, 127
br label %LSJ2998
LSJ2998:
%t3001 = phi i1 [ true, %LSL2998 ], [ %t3000, %LSR2998 ]
br i1 %t3001, label %L1036, label %L1038
L1036:
%t3002 = sub nsw i64 0, 1
ret i64 %t3002
L1038:
%t3003 = or i64 8, 1048576
%t3004 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 16896, i64 %t2985, i64 0, i64 %t3003)
%t3005 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3006 = call i64 @st64(i64 %t3005, i64 %t2985)
%t3007 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3008 = add i64 %t3007, 8
%t3009 = call i64 @st64(i64 %t3008, i64 0)
%t3010 = call i64 @__mruntime_rt_sys_resid__dbg_add(i64 %t2985)
%t3011 = mul nsw i64 %t3010, 0
%t3012 = add nsw i64 %t3011, %t2985
ret i64 %t3012
}
define i64 @resid_dbg_spawn(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_dbg_spawn(i64 %x0i)
ret i64 %r
}
define internal i64 @rt_dbg_cont(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3013 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 7, i64 %p0, i64 0, i64 %p1)
%t3014 = icmp eq i64 %t3013, 0
%t3015 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t3014)
ret i64 %t3015
}
define i8 @resid_dbg_cont(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_cont(i64 %a0, i64 %a1)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i1 @__mruntime_rt_sys_resid__st_exited(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3016 = and i64 %p0, 127
%t3017 = icmp eq i64 %t3016, 0
ret i1 %t3017
}
define internal i1 @__mruntime_rt_sys_resid__st_signaled(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3018 = and i64 %p0, 127
%t3019 = icmp ne i64 %t3018, 0
br label %LSL3020
LSL3020:
br i1 %t3019, label %LSR3020, label %LSJ3020
LSR3020:
%t3021 = and i64 %p0, 127
%t3022 = icmp ne i64 %t3021, 127
br label %LSJ3020
LSJ3020:
%t3023 = phi i1 [ false, %LSL3020 ], [ %t3022, %LSR3020 ]
ret i1 %t3023
}
define internal i1 @__mruntime_rt_sys_resid__st_stopped(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3024 = and i64 %p0, 255
%t3025 = icmp eq i64 %t3024, 127
ret i1 %t3025
}
define internal i64 @__mruntime_rt_sys_resid__dbg_status(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3026 = call i1 @__mruntime_rt_sys_resid__st_exited(i64 %p0)
br i1 %t3026, label %L1039, label %L1040
L1039:
%t3027 = ashr i64 %p0, 8
%t3028 = and i64 %t3027, 255
br label %L1041
L1040:
%t3029 = and i64 %p0, 127
%t3030 = add nsw i64 128, %t3029
br label %L1041
L1041:
%t3031 = phi i64 [ %t3028, %L1039 ], [ %t3030, %L1040 ]
ret i64 %t3031
}
define internal i64 @rt_dbg_wait() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%t3032p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dbg_status)
%t3032 = ptrtoint ptr %t3032p to i64
%t3033 = call i64 @st64(i64 %t3032, i64 0)
%t3034 = sub nsw i64 0, 1
%t3035 = call i64 @__mruntime_rt_sys_resid__sc4(i64 61, i64 %t3034, i64 %t3032, i64 1073741824, i64 0)
%t3036 = icmp slt i64 %t3035, 0
br i1 %t3036, label %L1042, label %L1044
L1042:
%t3037 = sub nsw i64 0, 1
ret i64 %t3037
L1044:
%t3038 = call i64 @ld32(i64 %t3032)
%t3039 = call i1 @__mruntime_rt_sys_resid__st_exited(i64 %t3038)
br label %LSL3040
LSL3040:
br i1 %t3039, label %LSJ3040, label %LSR3040
LSR3040:
%t3041 = call i1 @__mruntime_rt_sys_resid__st_signaled(i64 %t3038)
br label %LSJ3040
LSJ3040:
%t3042 = phi i1 [ true, %LSL3040 ], [ %t3041, %LSR3040 ]
br i1 %t3042, label %L1045, label %L1047
L1045:
%t3043 = call i64 @__mruntime_rt_sys_resid__dbg_remove(i64 %t3035)
%t3044 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3045 = call i64 @ld64(i64 %t3044)
%t3046 = icmp eq i64 %t3035, %t3045
br i1 %t3046, label %L1048, label %L1050
L1048:
%t3047 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3048 = add i64 %t3047, 24
%t3049 = call i64 @__mruntime_rt_sys_resid__dbg_status(i64 %t3038)
%t3050 = call i64 @st64(i64 %t3048, i64 %t3049)
%t3051 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3052 = sub nsw i64 0, 1
%t3053 = call i64 @st64(i64 %t3051, i64 %t3052)
%t3054 = sub i64 %t3053, 1
ret i64 %t3054
L1050:
br label %tco.s0
tco.s0:
br label %tco.head
L1047:
%t3056 = call i1 @__mruntime_rt_sys_resid__st_stopped(i64 %t3038)
%t3057 = xor i1 %t3056, true
br i1 %t3057, label %L1051, label %L1053
L1051:
br label %tco.s1
tco.s1:
br label %tco.head
L1053:
%t3059 = ashr i64 %t3038, 8
%t3060 = and i64 %t3059, 255
%t3061 = ashr i64 %t3038, 16
%t3062 = icmp eq i64 %t3060, 5
br label %LSL3063
LSL3063:
br i1 %t3062, label %LSR3063, label %LSJ3063
LSR3063:
%t3064 = icmp eq i64 %t3061, 3
br label %LSJ3063
LSJ3063:
%t3065 = phi i1 [ false, %LSL3063 ], [ %t3064, %LSR3063 ]
br i1 %t3065, label %L1054, label %L1056
L1054:
%t3066p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dbg_msg)
%t3066 = ptrtoint ptr %t3066p to i64
%t3067 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 16897, i64 %t3035, i64 0, i64 %t3066)
%t3068 = call i64 @ld64(i64 %t3066)
%t3069 = call i64 @__mruntime_rt_sys_resid__dbg_add(i64 %t3068)
%t3070 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 7, i64 %t3035, i64 0, i64 0)
br label %tco.s2
tco.s2:
br label %tco.head
L1056:
%t3072 = icmp eq i64 %t3060, 19
br label %LSL3073
LSL3073:
br i1 %t3072, label %LSR3073, label %LSJ3073
LSR3073:
%t3074 = call i1 @__mruntime_rt_sys_resid__dbg_known(i64 %t3035, i64 0)
%t3075 = xor i1 %t3074, true
br label %LSJ3073
LSJ3073:
%t3076 = phi i1 [ false, %LSL3073 ], [ %t3075, %LSR3073 ]
br i1 %t3076, label %L1057, label %L1059
L1057:
%t3077 = call i64 @__mruntime_rt_sys_resid__dbg_add(i64 %t3035)
%t3078 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 7, i64 %t3035, i64 0, i64 0)
br label %tco.s3
tco.s3:
br label %tco.head
L1059:
%t3080 = icmp eq i64 %t3060, 19
br label %LSL3081
LSL3081:
br i1 %t3080, label %LSR3081, label %LSJ3081
LSR3081:
%t3082 = icmp eq i64 %t3061, 0
br label %LSJ3081
LSJ3081:
%t3083 = phi i1 [ false, %LSL3081 ], [ %t3082, %LSR3081 ]
br label %LSL3084
LSL3084:
br i1 %t3083, label %LSR3084, label %LSJ3084
LSR3084:
%t3085 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3086 = call i64 @ld64(i64 %t3085)
%t3087 = icmp ne i64 %t3035, %t3086
br label %LSJ3084
LSJ3084:
%t3088 = phi i1 [ false, %LSL3084 ], [ %t3087, %LSR3084 ]
br i1 %t3088, label %L1060, label %L1062
L1060:
%t3089 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 7, i64 %t3035, i64 0, i64 0)
br label %tco.s4
tco.s4:
br label %tco.head
L1062:
%t3091 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3092 = add i64 %t3091, 16
%t3093 = icmp eq i64 %t3060, 5
br i1 %t3093, label %L1063, label %L1064
L1063:
br label %L1065
L1064:
br label %L1065
L1065:
%t3094 = phi i64 [ 0, %L1063 ], [ %t3060, %L1064 ]
%t3095 = call i64 @st64(i64 %t3092, i64 %t3094)
ret i64 %t3035
}
define i64 @resid_dbg_wait() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_wait()
ret i64 %r
}
define internal i64 @rt_dbg_signal() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3096 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3097 = add i64 %t3096, 16
%t3098 = call i64 @ld64(i64 %t3097)
ret i64 %t3098
}
define i64 @resid_dbg_signal() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_signal()
ret i64 %r
}
define internal i64 @rt_dbg_exit_code() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3099 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3100 = add i64 %t3099, 24
%t3101 = call i64 @ld64(i64 %t3100)
ret i64 %t3101
}
define i64 @resid_dbg_exit_code() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_exit_code()
ret i64 %r
}
define internal i64 @rt_dbg_step(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3102 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 9, i64 %p0, i64 0, i64 0)
%t3103 = icmp ne i64 %t3102, 0
br i1 %t3103, label %L1066, label %L1068
L1066:
ret i64 0
L1068:
%t3104 = call i64 @__mruntime_rt_sys_resid__wait_pid(i64 %p0, i64 1073741824)
%t3105 = icmp slt i64 %t3104, 0
br i1 %t3105, label %L1069, label %L1071
L1069:
ret i64 0
L1071:
%t3106 = call i1 @__mruntime_rt_sys_resid__st_exited(i64 %t3104)
br label %LSL3107
LSL3107:
br i1 %t3106, label %LSJ3107, label %LSR3107
LSR3107:
%t3108 = call i1 @__mruntime_rt_sys_resid__st_signaled(i64 %t3104)
br label %LSJ3107
LSJ3107:
%t3109 = phi i1 [ true, %LSL3107 ], [ %t3108, %LSR3107 ]
br i1 %t3109, label %L1072, label %L1074
L1072:
%t3110 = call i64 @__mruntime_rt_sys_resid__dbg_remove(i64 %p0)
%t3111 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3112 = call i64 @ld64(i64 %t3111)
%t3113 = icmp eq i64 %p0, %t3112
br i1 %t3113, label %L1075, label %L1076
L1075:
%t3114 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3115 = add i64 %t3114, 24
%t3116 = call i64 @__mruntime_rt_sys_resid__dbg_status(i64 %t3104)
%t3117 = call i64 @st64(i64 %t3115, i64 %t3116)
%t3118 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3119 = sub nsw i64 0, 1
%t3120 = call i64 @st64(i64 %t3118, i64 %t3119)
%t3121 = add i64 %t3117, %t3120
br label %L1077
L1076:
br label %L1077
L1077:
%t3122 = phi i64 [ %t3121, %L1075 ], [ 0, %L1076 ]
ret i64 0
L1074:
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
%t3123p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dbg_peek)
%t3123 = ptrtoint ptr %t3123p to i64
%t3124 = call i64 @st64(i64 %t3123, i64 0)
%t3125 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 2, i64 %p0, i64 %p1, i64 %t3123)
%t3126 = call i64 @ld64(i64 %t3123)
ret i64 %t3126
}
define i64 @resid_dbg_peek(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_peek(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_dbg_poke(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3127 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 5, i64 %p0, i64 %p1, i64 %p2)
%t3128 = icmp eq i64 %t3127, 0
%t3129 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t3128)
ret i64 %t3129
}
define i8 @resid_dbg_poke(i64 %a0, i64 %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_poke(i64 %a0, i64 %a1, i64 %a2)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @__mruntime_rt_sys_resid__reg_off(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3130 = ptrtoint ptr @rtt.18579 to i64
%t3131 = icmp sge i64 %p0, 0
br label %LSL3132
LSL3132:
br i1 %t3131, label %LSR3132, label %LSJ3132
LSR3132:
%t3133 = icmp sle i64 %p0, 16
br label %LSJ3132
LSJ3132:
%t3134 = phi i1 [ false, %LSL3132 ], [ %t3133, %LSR3132 ]
br i1 %t3134, label %L1078, label %L1079
L1078:
%t3135 = mul nsw i64 %p0, 8
%t3136 = add i64 %t3130, %t3135
%t3137 = call i64 @ld64(i64 %t3136)
br label %L1080
L1079:
%t3138 = sub nsw i64 0, 1
br label %L1080
L1080:
%t3139 = phi i64 [ %t3137, %L1078 ], [ %t3138, %L1079 ]
ret i64 %t3139
}
define internal i64 @rt_dbg_reg(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3140p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dbg_regs)
%t3140 = ptrtoint ptr %t3140p to i64
%t3141 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 12, i64 %p0, i64 0, i64 %t3140)
%t3142 = icmp ne i64 %t3141, 0
br i1 %t3142, label %L1081, label %L1083
L1081:
ret i64 0
L1083:
%t3143 = call i64 @__mruntime_rt_sys_resid__reg_off(i64 %p1)
%t3144 = icmp slt i64 %t3143, 0
br i1 %t3144, label %L1084, label %L1085
L1084:
br label %L1086
L1085:
%t3145 = add i64 %t3140, %t3143
%t3146 = call i64 @ld64(i64 %t3145)
br label %L1086
L1086:
%t3147 = phi i64 [ 0, %L1084 ], [ %t3146, %L1085 ]
ret i64 %t3147
}
define i64 @resid_dbg_reg(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_reg(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_dbg_set_pc(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3148p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dbg_regs)
%t3148 = ptrtoint ptr %t3148p to i64
%t3149 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 12, i64 %p0, i64 0, i64 %t3148)
%t3150 = icmp ne i64 %t3149, 0
br i1 %t3150, label %L1087, label %L1089
L1087:
ret i64 0
L1089:
%t3151 = add i64 %t3148, 128
%t3152 = call i64 @st64(i64 %t3151, i64 %p1)
%t3153 = call i64 @__mruntime_rt_sys_resid__ptrace(i64 13, i64 %p0, i64 0, i64 %t3148)
%t3154 = icmp eq i64 %t3153, 0
%t3155 = call i64 @__mruntime_rt_sys_resid__b8(i1 %t3154)
ret i64 %t3155
}
define i8 @resid_dbg_set_pc(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_set_pc(i64 %a0, i64 %a1)
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_dbg_kill() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3156 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3157 = call i64 @ld64(i64 %t3156)
%t3158 = icmp sle i64 %t3157, 0
br i1 %t3158, label %L1090, label %L1092
L1090:
ret i64 0
L1092:
%t3159 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 62, i64 %t3157, i64 9, i64 0, i64 0, i64 0, i64 0)
%t3160 = call i64 @__mruntime_rt_sys_resid__reap_all()
%t3161 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3162 = sub nsw i64 0, 1
%t3163 = call i64 @st64(i64 %t3161, i64 %t3162)
%t3164 = call i64 @__mruntime_rt_sys_resid__dbg()
%t3165 = add i64 %t3164, 8
%t3166 = call i64 @st64(i64 %t3165, i64 0)
%t3167 = add i64 %t3166, 1
ret i64 %t3167
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
%t3168p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.dbg_status)
%t3168 = ptrtoint ptr %t3168p to i64
%t3169 = sub nsw i64 0, 1
%t3170 = call i64 @__mruntime_rt_sys_resid__sc4(i64 61, i64 %t3169, i64 %t3168, i64 1073741824, i64 0)
%t3171 = icmp sgt i64 %t3170, 0
br i1 %t3171, label %L1093, label %L1095
L1093:
br label %tco.s0
tco.s0:
br label %tco.head
L1095:
ret i64 0
}
define internal i64 @rt_dbg_f64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3173 = bitcast i64 %p0 to double
%t3174 = call i64 @c_float_to_string(double %t3173)
ret i64 %t3174
}
define ptr @resid_dbg_f64(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_dbg_f64(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @main_thread(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3175 = call i64 @ld64(i64 %p0)
%t3176p = inttoptr i64 %t3175 to ptr
%t3176 = call i64 %t3176p(i64 0, i64 0)
%t3177 = and i64 %t3176, 4294967295
ret i64 %t3177
}
define internal i64 @__mruntime_rt_sys_resid__stack_mb() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3179 = ptrtoint ptr @.s3178 to i64
%t3180 = call i64 @c_getenv(i64 %t3179)
%t3181 = icmp eq i64 %t3180, 0
br label %LSL3182
LSL3182:
br i1 %t3181, label %LSJ3182, label %LSR3182
LSR3182:
%t3183 = call i64 @ld8(i64 %t3180)
%t3184 = icmp eq i64 %t3183, 0
br label %LSJ3182
LSJ3182:
%t3185 = phi i1 [ true, %LSL3182 ], [ %t3184, %LSR3182 ]
br label %LSL3186
LSL3186:
br i1 %t3185, label %LSJ3186, label %LSR3186
LSR3186:
%t3187 = call i1 @is_int(i64 %t3180)
%t3188 = xor i1 %t3187, true
br label %LSJ3186
LSJ3186:
%t3189 = phi i1 [ true, %LSL3186 ], [ %t3188, %LSR3186 ]
br i1 %t3189, label %L1096, label %L1098
L1096:
ret i64 1024
L1098:
%t3190 = call i64 @rt_str_parse_int(i64 %t3180)
%t3191 = icmp sge i64 %t3190, 8
br label %LSL3192
LSL3192:
br i1 %t3191, label %LSR3192, label %LSJ3192
LSR3192:
%t3193 = icmp sle i64 %t3190, 1048576
br label %LSJ3192
LSJ3192:
%t3194 = phi i1 [ false, %LSL3192 ], [ %t3193, %LSR3192 ]
br i1 %t3194, label %L1099, label %L1100
L1099:
br label %L1101
L1100:
br label %L1101
L1101:
%t3195 = phi i64 [ %t3190, %L1099 ], [ 1024, %L1100 ]
ret i64 %t3195
}
define internal i64 @rt_run_main(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3196 = call i64 @xmalloc(i64 64)
%t3197 = call i64 @xmalloc(i64 16)
%t3198 = call i64 @st64(i64 %t3197, i64 %p0)
%t3199 = call i64 @c_pthread_attr_init(i64 %t3196)
%t3200 = icmp ne i64 %t3199, 0
br i1 %t3200, label %L1102, label %L1104
L1102:
%t3201p = inttoptr i64 %p0 to ptr
%t3201 = call i64 %t3201p(i64 0, i64 0)
ret i64 %t3201
L1104:
%t3202 = call i64 @__mruntime_rt_sys_resid__stack_mb()
%t3203 = mul i64 %t3202, 1048576
%t3204 = call i64 @c_pthread_attr_setstacksize(i64 %t3196, i64 %t3203)
%t3205 = call i64 @xmalloc(i64 8)
%t3206 = icmp eq i64 %t3204, 0
br i1 %t3206, label %L1105, label %L1106
L1105:
%t3207 = ptrtoint ptr @main_thread to i64
%t3208 = call i64 @c_pthread_create(i64 %t3205, i64 %t3196, i64 %t3207, i64 %t3197)
br label %L1107
L1106:
br label %L1107
L1107:
%t3209 = phi i64 [ %t3208, %L1105 ], [ 1, %L1106 ]
%t3210 = call i64 @c_pthread_attr_destroy(i64 %t3196)
%t3211 = icmp ne i64 %t3209, 0
br i1 %t3211, label %L1108, label %L1110
L1108:
%t3212p = inttoptr i64 %p0 to ptr
%t3212 = call i64 %t3212p(i64 0, i64 0)
ret i64 %t3212
L1110:
%t3213 = call i64 @xmalloc(i64 8)
%t3214 = call i64 @ld64(i64 %t3205)
%t3215 = call i64 @c_pthread_join(i64 %t3214, i64 %t3213)
%t3216 = tail call i64 @ld64(i64 %t3213)
ret i64 %t3216
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
%t3217p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.numfmt_buf)
%t3217 = ptrtoint ptr %t3217p to i64
%t3218 = call i64 @itoa_into(i64 %t3217, i64 %p0)
%t3219 = call i64 @cstr_from(i64 %t3217, i64 %t3218, i64 0)
ret i64 %t3219
}
define ptr @IntToString(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_int_to_string(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @utoa_into(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3220 = call i64 @udigits(i64 %p1, i64 1)
%t3221 = add i64 %p0, %t3220
%t3222 = sub i64 %t3221, 1
%t3223 = call i64 @uput(i64 %t3222, i64 %p1)
ret i64 %t3220
}
define internal i64 @rt_uint_to_string(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3224p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.numfmt_buf)
%t3224 = ptrtoint ptr %t3224p to i64
%t3225 = call i64 @utoa_into(i64 %t3224, i64 %p0)
%t3226 = call i64 @cstr_from(i64 %t3224, i64 %t3225, i64 0)
ret i64 %t3226
}
define ptr @UIntToString(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_uint_to_string(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_int128_to_string(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3227 = call i64 @__mruntime_rt_numfmt_resid__limbs_i128(i128 %p0)
%t3228 = sext i64 0 to i128
%t3229 = icmp slt i128 %p0, %t3228
%t3230 = call i64 @limbs_to_str(i64 %t3227, i64 2, i1 %t3229)
ret i64 %t3230
}
define ptr @Int128ToString(i128 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_int128_to_string(i128 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_uint128_to_string(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3231 = call i64 @__mruntime_rt_numfmt_resid__limbs_i128(i128 %p0)
%t3232 = call i64 @limbs_to_str(i64 %t3231, i64 2, i1 false)
ret i64 %t3232
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t3248, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t3247, %tco.s0 ]
%t3233 = icmp sge i64 %p1, %p2
br i1 %t3233, label %L1111, label %L1113
L1111:
ret i64 0
L1113:
%t3234 = mul i64 %p1, 8
%t3235 = add i64 %p0, %t3234
%t3236 = call i64 @ld64(i64 %t3235)
%t3237 = xor i64 %t3236, -1
%t3238 = mul i64 %p1, 8
%t3239 = add i64 %p0, %t3238
%t3240 = add i64 %t3237, %p3
%t3241 = call i64 @st64(i64 %t3239, i64 %t3240)
%t3242 = icmp eq i64 %p3, 1
br label %LSL3243
LSL3243:
br i1 %t3242, label %LSR3243, label %LSJ3243
LSR3243:
%t3244 = sub nsw i64 0, 1
%t3245 = icmp eq i64 %t3237, %t3244
br label %LSJ3243
LSJ3243:
%t3246 = phi i1 [ false, %LSL3243 ], [ %t3245, %LSR3243 ]
br i1 %t3246, label %L1114, label %L1115
L1114:
br label %L1116
L1115:
br label %L1116
L1116:
%t3247 = phi i64 [ 1, %L1114 ], [ 0, %L1115 ]
%t3248 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_numfmt_resid__limbs_zero(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3255, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t3250 = icmp sge i64 %p1, %p2
br i1 %t3250, label %L1117, label %L1119
L1117:
ret i1 true
L1119:
%t3251 = mul i64 %p1, 8
%t3252 = add i64 %p0, %t3251
%t3253 = call i64 @ld64(i64 %t3252)
%t3254 = icmp ne i64 %t3253, 0
br i1 %t3254, label %L1120, label %L1122
L1120:
ret i1 false
L1122:
%t3255 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__limbs_div10(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3319, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3330, %tco.s0 ]
%t3257 = icmp slt i64 %p1, 0
br i1 %t3257, label %L1123, label %L1125
L1123:
ret i64 %p2
L1125:
%t3258 = sext i64 %p2 to i128
%t3259 = add i128 %t3258, 0
%t3265 = sext i64 64 to i128
%t3266 = add i128 %t3265, 0
%t3272 = icmp uge i128 %t3266, 128
%t3273 = add i128 %t3266, 0
%t3274 = shl i128 %t3259, %t3273
%t3275 = select i1 %t3272, i128 0, i128 %t3274
%t3276 = mul i64 %p1, 8
%t3277 = add i64 %p0, %t3276
%t3278 = call i64 @ld64(i64 %t3277)
%t3279 = sext i64 %t3278 to i128
%t3280 = add i128 %t3279, 0
%t3286 = add i128 18446744073709551615, 0
%t3287 = add i128 %t3286, 0
%t3293 = and i128 %t3280, %t3287
%t3294 = or i128 %t3275, %t3293
%t3295 = sext i64 10 to i128
%t3296 = add i128 %t3295, 0
%t3302 = icmp eq i128 %t3296, 0
%t3303 = zext i1 %t3302 to i8
call void @resid_div_check(i8 %t3303)
%t3308 = udiv i128 %t3294, %t3296
%t3309 = mul i64 %p1, 8
%t3310 = add i64 %p0, %t3309
%t3311 = add i128 %t3308, 0
%t3312 = trunc i128 %t3311 to i64
%t3318 = call i64 @st64(i64 %t3310, i64 %t3312)
%t3319 = sub nsw i64 %p1, 1
%t3320 = sext i64 10 to i128
%t3321 = add i128 %t3320, 0
%t3327 = mul i128 %t3308, %t3321
%t3328 = sub i128 %t3294, %t3327
%t3329 = add i128 %t3328, 0
%t3330 = trunc i128 %t3329 to i64
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t3344, %tco.s0 ]
%t3337 = sub i64 %p1, 1
%t3338 = call i64 @__mruntime_rt_numfmt_resid__limbs_div10(i64 %p0, i64 %t3337, i64 0)
%t3339 = sub i64 %p2, 1
%t3340 = add i64 48, %t3338
%t3341 = call i64 @st8(i64 %t3339, i64 %t3340)
%t3342 = call i1 @__mruntime_rt_numfmt_resid__limbs_zero(i64 %p0, i64 0, i64 %p1)
br i1 %t3342, label %L1126, label %L1128
L1126:
%t3343 = sub i64 %p2, 1
ret i64 %t3343
L1128:
%t3344 = sub i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @limbs_to_str(i64 %p0, i64 %p1, i1 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br i1 %p2, label %L1129, label %L1130
L1129:
%t3346 = call i64 @__mruntime_rt_numfmt_resid__limbs_negate(i64 %p0, i64 0, i64 %p1, i64 1)
br label %L1131
L1130:
br label %L1131
L1131:
%t3347 = phi i64 [ %t3346, %L1129 ], [ 0, %L1130 ]
%t3348p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.limb_buf)
%t3348 = ptrtoint ptr %t3348p to i64
%t3349 = add i64 %t3348, 204
%t3350 = call i64 @__mruntime_rt_numfmt_resid__limbs_digits(i64 %p0, i64 %p1, i64 %t3349)
br i1 %p2, label %L1132, label %L1133
L1132:
%t3351 = sub i64 %t3350, 1
%t3352 = call i64 @st8(i64 %t3351, i64 45)
%t3353 = add i64 %t3352, %t3350
%t3354 = sub i64 %t3353, 1
br label %L1134
L1133:
br label %L1134
L1134:
%t3355 = phi i64 [ %t3354, %L1132 ], [ %t3350, %L1133 ]
%t3356 = add i64 %t3348, 204
%t3357 = sub i64 %t3356, %t3355
%t3358 = call i64 @cstr_from(i64 %t3355, i64 %t3357, i64 0)
ret i64 %t3358
}
define internal i64 @__mruntime_rt_numfmt_resid__limbs_i128(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3359p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.limbs)
%t3359 = ptrtoint ptr %t3359p to i64
%t3360 = add i128 %p0, 0
%t3361 = trunc i128 %t3360 to i64
%t3367 = call i64 @st64(i64 %t3359, i64 %t3361)
%t3368 = add i64 %t3359, 8
%t3369 = sext i64 64 to i128
%t3370 = icmp uge i128 %t3369, 128
%t3371 = add i128 %t3369, 0
%t3372 = select i1 %t3370, i128 127, i128 %t3371
%t3373 = ashr i128 %p0, %t3372
%t3374 = add i128 %t3373, 0
%t3375 = trunc i128 %t3374 to i64
%t3381 = call i64 @st64(i64 %t3368, i64 %t3375)
%t3382 = mul nsw i64 %t3381, 0
%t3383 = add nsw i64 %t3382, %t3359
ret i64 %t3383
}
define internal i64 @limbs2(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3384p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.limbs)
%t3384 = ptrtoint ptr %t3384p to i64
%t3385 = add i64 %p0, 24
%t3386 = call i64 @ld64(i64 %t3385)
%t3387 = call i64 @st64(i64 %t3384, i64 %t3386)
%t3388 = add i64 %t3384, 8
%t3389 = add i64 %p0, 32
%t3390 = call i64 @ld64(i64 %t3389)
%t3391 = call i64 @st64(i64 %t3388, i64 %t3390)
%t3392 = mul nsw i64 %t3391, 0
%t3393 = add nsw i64 %t3392, %t3384
ret i64 %t3393
}
define internal i64 @__mruntime_rt_numfmt_resid__limbs4(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3394p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.limbs)
%t3394 = ptrtoint ptr %t3394p to i64
%t3395 = call i64 @st64(i64 %t3394, i64 %p0)
%t3396 = add i64 %t3394, 8
%t3397 = call i64 @st64(i64 %t3396, i64 %p1)
%t3398 = add i64 %t3394, 16
%t3399 = call i64 @st64(i64 %t3398, i64 %p2)
%t3400 = add i64 %t3394, 24
%t3401 = call i64 @st64(i64 %t3400, i64 %p3)
%t3402 = mul nsw i64 %t3401, 0
%t3403 = add nsw i64 %t3402, %t3394
ret i64 %t3403
}
define internal i64 @__mruntime_rt_numfmt_resid__limbs8(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3404 = call i64 @__mruntime_rt_numfmt_resid__limbs4(i64 %p0, i64 %p1, i64 %p2, i64 %p3)
%t3405 = add i64 %t3404, 32
%t3406 = call i64 @st64(i64 %t3405, i64 %p4)
%t3407 = add i64 %t3404, 40
%t3408 = call i64 @st64(i64 %t3407, i64 %p5)
%t3409 = add i64 %t3404, 48
%t3410 = call i64 @st64(i64 %t3409, i64 %p6)
%t3411 = add i64 %t3404, 56
%t3412 = call i64 @st64(i64 %t3411, i64 %p7)
%t3413 = mul nsw i64 %t3412, 0
%t3414 = add nsw i64 %t3413, %t3404
ret i64 %t3414
}
define internal i64 @rt_int256_to_string(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3415 = call i64 @__mruntime_rt_numfmt_resid__limbs4(i64 %p0, i64 %p1, i64 %p2, i64 %p3)
%t3416 = icmp slt i64 %p3, 0
%t3417 = call i64 @limbs_to_str(i64 %t3415, i64 4, i1 %t3416)
ret i64 %t3417
}
define ptr @Int256ToString(i64 %a0, i64 %a1, i64 %a2, i64 %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_int256_to_string(i64 %a0, i64 %a1, i64 %a2, i64 %a3)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_uint256_to_string(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3418 = call i64 @__mruntime_rt_numfmt_resid__limbs4(i64 %p0, i64 %p1, i64 %p2, i64 %p3)
%t3419 = call i64 @limbs_to_str(i64 %t3418, i64 4, i1 false)
ret i64 %t3419
}
define ptr @UInt256ToString(i64 %a0, i64 %a1, i64 %a2, i64 %a3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_uint256_to_string(i64 %a0, i64 %a1, i64 %a2, i64 %a3)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_int512_to_string(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3420 = call i64 @__mruntime_rt_numfmt_resid__limbs8(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7)
%t3421 = icmp slt i64 %p7, 0
%t3422 = call i64 @limbs_to_str(i64 %t3420, i64 8, i1 %t3421)
ret i64 %t3422
}
define ptr @Int512ToString(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_int512_to_string(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_uint512_to_string(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3423 = call i64 @__mruntime_rt_numfmt_resid__limbs8(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7)
%t3424 = call i64 @limbs_to_str(i64 %t3423, i64 8, i1 false)
ret i64 %t3424
}
define ptr @UInt512ToString(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_uint512_to_string(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_float_to_string(double %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3425p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.ftoa_buf)
%t3425 = ptrtoint ptr %t3425p to i64
%t3427 = ptrtoint ptr @.s3426 to i64
%t3428 = call i64 @c_strfromd(i64 %t3425, i64 64, i64 %t3427, double %p0)
%t3429 = call i64 @cstr_from(i64 %t3425, i64 %t3428, i64 0)
ret i64 %t3429
}
define ptr @FloatToString(double %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_float_to_string(double %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_bool_to_string(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3430 = icmp ne i64 %p0, 0
br i1 %t3430, label %L1135, label %L1136
L1135:
%t3432 = ptrtoint ptr @.s3431 to i64
br label %L1137
L1136:
%t3434 = ptrtoint ptr @.s3433 to i64
br label %L1137
L1137:
%t3435 = phi i64 [ %t3432, %L1135 ], [ %t3434, %L1136 ]
%t3436 = tail call i64 @cstr_dup(i64 %t3435)
ret i64 %t3436
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
%t3437p = inttoptr i64 %p0 to ptr
%t3437q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t3437p, i8 %t3437q, i64 2080, i1 false)
%t3437 = add i64 0, 0
ret i64 %t3437
}
define internal i1 @__mruntime_rt_numfmt_resid__f128_is_zero(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3438 = call i1 @__mruntime_rt_numfmt_resid__limbs_zero(i64 %p0, i64 0, i64 260)
ret i1 %t3438
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_load(i64 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3439 = call i64 @__mruntime_rt_numfmt_resid__f128_zero(i64 %p0)
%t3440 = add i128 %p1, 0
%t3441 = trunc i128 %t3440 to i64
%t3447 = call i64 @st64(i64 %p0, i64 %t3441)
%t3448 = add i64 %p0, 8
%t3449 = sext i64 64 to i128
%t3450 = add i128 %t3449, 0
%t3456 = icmp uge i128 %t3450, 128
%t3457 = add i128 %t3450, 0
%t3458 = lshr i128 %p1, %t3457
%t3459 = select i1 %t3456, i128 0, i128 %t3458
%t3460 = add i128 %t3459, 0
%t3461 = trunc i128 %t3460 to i64
%t3467 = call i64 @st64(i64 %t3448, i64 %t3461)
ret i64 %t3467
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_shl(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3468 = sdiv i64 %p1, 64
%t3469 = srem i64 %p1, 64
%t3470 = call i64 @__mruntime_rt_numfmt_resid__shl_words(i64 %p0, i64 259, i64 %t3468, i64 %t3469)
%t3471 = mul nsw i64 %t3468, 8
%t3472p = inttoptr i64 %p0 to ptr
%t3472q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t3472p, i8 %t3472q, i64 %t3471, i1 false)
%t3472 = add i64 0, 0
ret i64 %t3472
}
define internal i64 @__mruntime_rt_numfmt_resid__shl_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3502, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t3473 = icmp slt i64 %p1, %p2
br i1 %t3473, label %L1138, label %L1140
L1138:
ret i64 0
L1140:
%t3474 = sub i64 %p1, %p2
%t3475 = mul i64 %t3474, 8
%t3476 = add i64 %p0, %t3475
%t3477 = call i64 @ld64(i64 %t3476)
%t3478 = icmp ne i64 %p3, 0
br label %LSL3479
LSL3479:
br i1 %t3478, label %LSR3479, label %LSJ3479
LSR3479:
%t3480 = sub i64 %p1, %p2
%t3481 = sub i64 %t3480, 1
%t3482 = icmp sge i64 %t3481, 0
br label %LSJ3479
LSJ3479:
%t3483 = phi i1 [ false, %LSL3479 ], [ %t3482, %LSR3479 ]
br i1 %t3483, label %L1141, label %L1142
L1141:
%t3484 = sub i64 %p1, %p2
%t3485 = sub i64 %t3484, 1
%t3486 = mul i64 %t3485, 8
%t3487 = add i64 %p0, %t3486
%t3488 = call i64 @ld64(i64 %t3487)
%t3489 = sub i64 64, %p3
%t3490 = call i64 @lshr(i64 %t3488, i64 %t3489)
br label %L1143
L1142:
br label %L1143
L1143:
%t3491 = phi i64 [ %t3490, %L1141 ], [ 0, %L1142 ]
%t3492 = mul i64 %p1, 8
%t3493 = add i64 %p0, %t3492
%t3494 = icmp eq i64 %p3, 0
br i1 %t3494, label %L1144, label %L1145
L1144:
br label %L1146
L1145:
%t3495 = icmp uge i64 %p3, 64
%t3496 = add i64 %p3, 0
%t3497 = shl i64 %t3477, %t3496
%t3498 = select i1 %t3495, i64 0, i64 %t3497
%t3499 = or i64 %t3498, %t3491
br label %L1146
L1146:
%t3500 = phi i64 [ %t3477, %L1144 ], [ %t3499, %L1145 ]
%t3501 = call i64 @st64(i64 %t3493, i64 %t3500)
%t3502 = sub i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_shr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3504 = sdiv i64 %p1, 64
%t3505 = srem i64 %p1, 64
%t3506 = call i64 @__mruntime_rt_numfmt_resid__shr_words(i64 %p0, i64 0, i64 %t3504, i64 %t3505)
%t3507 = sub nsw i64 260, %t3504
%t3508 = icmp slt i64 %t3507, 0
br i1 %t3508, label %L1147, label %L1148
L1147:
br label %L1149
L1148:
%t3509 = sub nsw i64 260, %t3504
br label %L1149
L1149:
%t3510 = phi i64 [ 0, %L1147 ], [ %t3509, %L1148 ]
%t3511 = mul i64 %t3510, 8
%t3512 = add i64 %p0, %t3511
%t3513 = sub i64 260, %t3510
%t3514 = mul i64 %t3513, 8
%t3515p = inttoptr i64 %t3512 to ptr
%t3515q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t3515p, i8 %t3515q, i64 %t3514, i1 false)
%t3515 = add i64 0, 0
ret i64 %t3515
}
define internal i64 @__mruntime_rt_numfmt_resid__shr_words(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3546, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t3516 = add i64 %p1, %p2
%t3517 = icmp sge i64 %t3516, 260
br i1 %t3517, label %L1150, label %L1152
L1150:
ret i64 0
L1152:
%t3518 = add i64 %p1, %p2
%t3519 = mul i64 %t3518, 8
%t3520 = add i64 %p0, %t3519
%t3521 = call i64 @ld64(i64 %t3520)
%t3522 = icmp ne i64 %p3, 0
br label %LSL3523
LSL3523:
br i1 %t3522, label %LSR3523, label %LSJ3523
LSR3523:
%t3524 = add i64 %p1, %p2
%t3525 = add i64 %t3524, 1
%t3526 = icmp slt i64 %t3525, 260
br label %LSJ3523
LSJ3523:
%t3527 = phi i1 [ false, %LSL3523 ], [ %t3526, %LSR3523 ]
br i1 %t3527, label %L1153, label %L1154
L1153:
%t3528 = add i64 %p1, %p2
%t3529 = add i64 %t3528, 1
%t3530 = mul i64 %t3529, 8
%t3531 = add i64 %p0, %t3530
%t3532 = call i64 @ld64(i64 %t3531)
%t3533 = sub i64 64, %p3
%t3534 = icmp uge i64 %t3533, 64
%t3535 = add i64 %t3533, 0
%t3536 = shl i64 %t3532, %t3535
%t3537 = select i1 %t3534, i64 0, i64 %t3536
br label %L1155
L1154:
br label %L1155
L1155:
%t3538 = phi i64 [ %t3537, %L1153 ], [ 0, %L1154 ]
%t3539 = mul i64 %p1, 8
%t3540 = add i64 %p0, %t3539
%t3541 = icmp eq i64 %p3, 0
br i1 %t3541, label %L1156, label %L1157
L1156:
br label %L1158
L1157:
%t3542 = call i64 @lshr(i64 %t3521, i64 %p3)
%t3543 = or i64 %t3542, %t3538
br label %L1158
L1158:
%t3544 = phi i64 [ %t3521, %L1156 ], [ %t3543, %L1157 ]
%t3545 = call i64 @st64(i64 %t3540, i64 %t3544)
%t3546 = add i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_mul10(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3593, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3606, %tco.s0 ]
%t3548 = icmp sge i64 %p1, 260
br i1 %t3548, label %L1159, label %L1161
L1159:
ret i64 0
L1161:
%t3549 = mul i64 %p1, 8
%t3550 = add i64 %p0, %t3549
%t3551 = call i64 @ld64(i64 %t3550)
%t3552 = sext i64 %t3551 to i128
%t3553 = add i128 %t3552, 0
%t3559 = add i128 18446744073709551615, 0
%t3560 = add i128 %t3559, 0
%t3566 = and i128 %t3553, %t3560
%t3567 = sext i64 10 to i128
%t3568 = add i128 %t3567, 0
%t3574 = mul i128 %t3566, %t3568
%t3575 = sext i64 %p2 to i128
%t3576 = add i128 %t3575, 0
%t3582 = add i128 %t3574, %t3576
%t3583 = mul i64 %p1, 8
%t3584 = add i64 %p0, %t3583
%t3585 = add i128 %t3582, 0
%t3586 = trunc i128 %t3585 to i64
%t3592 = call i64 @st64(i64 %t3584, i64 %t3586)
%t3593 = add nsw i64 %p1, 1
%t3594 = sext i64 64 to i128
%t3595 = add i128 %t3594, 0
%t3601 = icmp uge i128 %t3595, 128
%t3602 = add i128 %t3595, 0
%t3603 = lshr i128 %t3582, %t3602
%t3604 = select i1 %t3601, i128 0, i128 %t3603
%t3605 = add i128 %t3604, 0
%t3606 = trunc i128 %t3605 to i64
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_div10(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3613 = call i64 @__mruntime_rt_numfmt_resid__limbs_div10(i64 %p0, i64 259, i64 0)
ret i64 %t3613
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_mask(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3614 = sdiv i64 %p1, 64
%t3615 = srem i64 %p1, 64
%t3616 = add nsw i64 %t3614, 1
%t3617 = icmp slt i64 %t3616, 260
br i1 %t3617, label %L1162, label %L1163
L1162:
%t3618 = add nsw i64 %t3614, 1
%t3619 = mul nsw i64 %t3618, 8
%t3620 = add i64 %p0, %t3619
%t3621 = sub nsw i64 259, %t3614
%t3622 = mul nsw i64 %t3621, 8
%t3623p = inttoptr i64 %t3620 to ptr
%t3623q = trunc i64 0 to i8
call void @llvm.memset.p0.i64(ptr %t3623p, i8 %t3623q, i64 %t3622, i1 false)
%t3623 = add i64 0, 0
br label %L1164
L1163:
br label %L1164
L1164:
%t3624 = phi i64 [ %t3623, %L1162 ], [ 0, %L1163 ]
%t3625 = icmp ne i64 %t3615, 0
br label %LSL3626
LSL3626:
br i1 %t3625, label %LSR3626, label %LSJ3626
LSR3626:
%t3627 = icmp slt i64 %t3614, 260
br label %LSJ3626
LSJ3626:
%t3628 = phi i1 [ false, %LSL3626 ], [ %t3627, %LSR3626 ]
br i1 %t3628, label %L1165, label %L1166
L1165:
%t3629 = mul nsw i64 %t3614, 8
%t3630 = add i64 %p0, %t3629
%t3631 = mul nsw i64 %t3614, 8
%t3632 = add i64 %p0, %t3631
%t3633 = call i64 @ld64(i64 %t3632)
%t3634 = icmp uge i64 %t3615, 64
%t3635 = add i64 %t3615, 0
%t3636 = shl i64 1, %t3635
%t3637 = select i1 %t3634, i64 0, i64 %t3636
%t3638 = sub i64 %t3637, 1
%t3639 = and i64 %t3633, %t3638
%t3640 = call i64 @st64(i64 %t3630, i64 %t3639)
br label %L1167
L1166:
br label %L1167
L1167:
%t3641 = phi i64 [ %t3640, %L1165 ], [ 0, %L1166 ]
ret i64 %t3641
}
define internal i64 @__mruntime_rt_numfmt_resid__int_digits(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3650, %tco.s0 ]
%t3642 = call i1 @__mruntime_rt_numfmt_resid__f128_is_zero(i64 %p0)
br label %LSL3643
LSL3643:
br i1 %t3642, label %LSJ3643, label %LSR3643
LSR3643:
%t3644 = icmp sge i64 %p2, 5000
br label %LSJ3643
LSJ3643:
%t3645 = phi i1 [ true, %LSL3643 ], [ %t3644, %LSR3643 ]
br i1 %t3645, label %L1168, label %L1170
L1168:
ret i64 %p2
L1170:
%t3646 = add i64 %p1, %p2
%t3647 = call i64 @__mruntime_rt_numfmt_resid__f128_div10(i64 %p0)
%t3648 = add i64 48, %t3647
%t3649 = call i64 @st8(i64 %t3646, i64 %t3648)
%t3650 = add nsw i64 %p2, 1
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
%p3 = phi i64 [ %p3.in, %entry ], [ 0, %tco.s0 ], [ %t3693, %tco.s1 ]
%p4 = phi i1 [ %p4.in, %entry ], [ %p4, %tco.s0 ], [ %p4, %tco.s1 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ], [ %p5, %tco.s1 ]
%t3652 = icmp sge i64 %p3, 44
br label %LSL3653
LSL3653:
br i1 %t3652, label %LSJ3653, label %LSR3653
LSR3653:
%t3654 = call i1 @__mruntime_rt_numfmt_resid__f128_is_zero(i64 %p0)
br label %LSJ3653
LSJ3653:
%t3655 = phi i1 [ true, %LSL3653 ], [ %t3654, %LSR3653 ]
br i1 %t3655, label %L1171, label %L1173
L1171:
ret i64 %p3
L1173:
%t3656 = call i64 @__mruntime_rt_numfmt_resid__f128_mul10(i64 %p0, i64 0, i64 0)
%t3657 = sdiv i64 %p1, 64
%t3658 = srem i64 %p1, 64
%t3659 = icmp eq i64 %t3658, 0
br i1 %t3659, label %L1174, label %L1175
L1174:
%t3660 = mul nsw i64 %t3657, 8
%t3661 = add i64 %p0, %t3660
%t3662 = call i64 @ld64(i64 %t3661)
br label %L1176
L1175:
%t3663 = mul nsw i64 %t3657, 8
%t3664 = add i64 %p0, %t3663
%t3665 = call i64 @ld64(i64 %t3664)
%t3666 = call i64 @lshr(i64 %t3665, i64 %t3658)
%t3667 = add nsw i64 %t3657, 1
%t3668 = mul nsw i64 %t3667, 8
%t3669 = add i64 %p0, %t3668
%t3670 = call i64 @ld64(i64 %t3669)
%t3671 = sub nsw i64 64, %t3658
%t3672 = icmp uge i64 %t3671, 64
%t3673 = add i64 %t3671, 0
%t3674 = shl i64 %t3670, %t3673
%t3675 = select i1 %t3672, i64 0, i64 %t3674
%t3676 = or i64 %t3666, %t3675
br label %L1176
L1176:
%t3677 = phi i64 [ %t3662, %L1174 ], [ %t3676, %L1175 ]
%t3678 = and i64 %t3677, 15
%t3679 = call i64 @__mruntime_rt_numfmt_resid__f128_mask(i64 %p0, i64 %p1)
br label %LSL3680
LSL3680:
br i1 %p4, label %LSR3680, label %LSJ3680
LSR3680:
%t3681 = icmp eq i64 %p3, 0
br label %LSJ3680
LSJ3680:
%t3682 = phi i1 [ false, %LSL3680 ], [ %t3681, %LSR3680 ]
br label %LSL3683
LSL3683:
br i1 %t3682, label %LSR3683, label %LSJ3683
LSR3683:
%t3684 = icmp eq i64 %t3678, 0
br label %LSJ3683
LSJ3683:
%t3685 = phi i1 [ false, %LSL3683 ], [ %t3684, %LSR3683 ]
br i1 %t3685, label %L1177, label %L1179
L1177:
%t3686 = call i64 @ld64(i64 %p5)
%t3687 = add i64 %t3686, 1
%t3688 = call i64 @st64(i64 %p5, i64 %t3687)
br label %tco.s0
tco.s0:
br label %tco.head
L1179:
%t3690 = add i64 %p2, %p3
%t3691 = add nsw i64 48, %t3678
%t3692 = call i64 @st8(i64 %t3690, i64 %t3691)
%t3693 = add nsw i64 %p3, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @rt_float128_to_string(fp128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3695 = bitcast fp128 %p0 to i128
%t3696 = add i128 %t3695, 0
%t3697 = add i128 %t3696, 0
%t3703 = sext i64 127 to i128
%t3704 = add i128 %t3703, 0
%t3710 = icmp uge i128 %t3704, 128
%t3711 = add i128 %t3704, 0
%t3712 = lshr i128 %t3697, %t3711
%t3713 = select i1 %t3710, i128 0, i128 %t3712
%t3714 = sext i64 0 to i128
%t3715 = add i128 %t3714, 0
%t3721 = icmp ne i128 %t3713, %t3715
%t3722 = sext i64 112 to i128
%t3723 = add i128 %t3722, 0
%t3729 = icmp uge i128 %t3723, 128
%t3730 = add i128 %t3723, 0
%t3731 = lshr i128 %t3697, %t3730
%t3732 = select i1 %t3729, i128 0, i128 %t3731
%t3733 = sext i64 32767 to i128
%t3734 = add i128 %t3733, 0
%t3740 = and i128 %t3732, %t3734
%t3741 = add i128 %t3740, 0
%t3742 = trunc i128 %t3741 to i64
%t3748 = sext i64 1 to i128
%t3749 = add i128 %t3748, 0
%t3755 = sext i64 112 to i128
%t3756 = add i128 %t3755, 0
%t3762 = icmp uge i128 %t3756, 128
%t3763 = add i128 %t3756, 0
%t3764 = shl i128 %t3749, %t3763
%t3765 = select i1 %t3762, i128 0, i128 %t3764
%t3766 = sext i64 1 to i128
%t3767 = add i128 %t3766, 0
%t3773 = sub i128 %t3765, %t3767
%t3774 = and i128 %t3697, %t3773
%t3775 = icmp eq i64 %t3742, 32767
br i1 %t3775, label %L1180, label %L1182
L1180:
%t3776 = sext i64 0 to i128
%t3777 = add i128 %t3776, 0
%t3783 = icmp ne i128 %t3774, %t3777
br i1 %t3783, label %L1183, label %L1184
L1183:
%t3785 = ptrtoint ptr @.s3784 to i64
br label %L1185
L1184:
br i1 %t3721, label %L1186, label %L1187
L1186:
%t3787 = ptrtoint ptr @.s3786 to i64
br label %L1188
L1187:
%t3789 = ptrtoint ptr @.s3788 to i64
br label %L1188
L1188:
%t3790 = phi i64 [ %t3787, %L1186 ], [ %t3789, %L1187 ]
br label %L1185
L1185:
%t3791 = phi i64 [ %t3785, %L1183 ], [ %t3790, %L1188 ]
%t3792 = call i64 @cstr_dup(i64 %t3791)
ret i64 %t3792
L1182:
%t3793 = icmp eq i64 %t3742, 0
br i1 %t3793, label %L1189, label %L1190
L1189:
br label %L1191
L1190:
%t3794 = sext i64 1 to i128
%t3795 = add i128 %t3794, 0
%t3801 = sext i64 112 to i128
%t3802 = add i128 %t3801, 0
%t3808 = icmp uge i128 %t3802, 128
%t3809 = add i128 %t3802, 0
%t3810 = shl i128 %t3795, %t3809
%t3811 = select i1 %t3808, i128 0, i128 %t3810
%t3812 = or i128 %t3811, %t3774
br label %L1191
L1191:
%t3813 = phi i128 [ %t3774, %L1189 ], [ %t3812, %L1190 ]
%t3814 = icmp eq i64 %t3742, 0
br i1 %t3814, label %L1192, label %L1193
L1192:
%t3815 = sub nsw i64 0, 16382
%t3816 = sub nsw i64 %t3815, 112
br label %L1194
L1193:
%t3817 = sub i64 %t3742, 16383
%t3818 = sub i64 %t3817, 112
br label %L1194
L1194:
%t3819 = phi i64 [ %t3816, %L1192 ], [ %t3818, %L1193 ]
%t3820p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_m)
%t3820 = ptrtoint ptr %t3820p to i64
%t3821p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_ip)
%t3821 = ptrtoint ptr %t3821p to i64
%t3822p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_ib)
%t3822 = ptrtoint ptr %t3822p to i64
%t3823p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_fd)
%t3823 = ptrtoint ptr %t3823p to i64
%t3824 = call i64 @__mruntime_rt_numfmt_resid__f128_load(i64 %t3820, i128 %t3813)
%t3825 = call i64 @__mruntime_rt_numfmt_resid__f128_text(i64 %t3820, i64 %t3821, i64 %t3822, i64 %t3823, i128 %t3813, i64 %t3819, i1 %t3721)
ret i64 %t3825
}
define ptr @Float128ToString(fp128 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_float128_to_string(fp128 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_text(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i128 %p4, i64 %p5, i1 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3826 = icmp sge i64 %p5, 0
br i1 %t3826, label %L1195, label %L1197
L1195:
%t3827 = call i64 @__mruntime_rt_numfmt_resid__f128_shl(i64 %p0, i64 %p5)
%t3828 = call i1 @__mruntime_rt_numfmt_resid__f128_is_zero(i64 %p0)
br i1 %t3828, label %L1198, label %L1200
L1198:
%t3830 = ptrtoint ptr @.s3829 to i64
%t3831 = call i64 @cstr_dup(i64 %t3830)
ret i64 %t3831
L1200:
%t3832 = call i64 @__mruntime_rt_numfmt_resid__int_digits(i64 %p0, i64 %p2, i64 0)
%t3833 = sub i64 %t3832, 1
%t3834 = call i64 @__mruntime_rt_numfmt_resid__f128_assemble(i64 %p2, i64 %t3832, i64 %p3, i64 0, i64 %t3833, i1 %p6)
ret i64 %t3834
L1197:
%t3835 = sub i64 0, %p5
%t3836 = call i64 @__mruntime_rt_numfmt_resid__f128_load(i64 %p1, i128 %p4)
%t3837 = call i64 @__mruntime_rt_numfmt_resid__f128_shr(i64 %p1, i64 %t3835)
%t3838 = call i64 @__mruntime_rt_numfmt_resid__int_digits(i64 %p1, i64 %p2, i64 0)
%t3839 = call i64 @__mruntime_rt_numfmt_resid__f128_load(i64 %p0, i128 %p4)
%t3840 = call i64 @__mruntime_rt_numfmt_resid__f128_mask(i64 %p0, i64 %t3835)
%t3841p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_lead)
%t3841 = ptrtoint ptr %t3841p to i64
%t3842 = call i64 @st64(i64 %t3841, i64 0)
%t3843 = icmp eq i64 %t3838, 0
%t3844 = call i64 @__mruntime_rt_numfmt_resid__frac_digits(i64 %p0, i64 %t3835, i64 %p3, i64 0, i1 %t3843, i64 %t3841)
%t3845 = icmp sgt i64 %t3838, 0
br i1 %t3845, label %L1201, label %L1203
L1201:
%t3846 = sub nsw i64 %t3838, 1
%t3847 = call i64 @__mruntime_rt_numfmt_resid__f128_assemble(i64 %p2, i64 %t3838, i64 %p3, i64 %t3844, i64 %t3846, i1 %p6)
ret i64 %t3847
L1203:
%t3848 = icmp eq i64 %t3844, 0
br i1 %t3848, label %L1204, label %L1206
L1204:
br i1 %p6, label %L1207, label %L1208
L1207:
%t3850 = ptrtoint ptr @.s3849 to i64
br label %L1209
L1208:
%t3852 = ptrtoint ptr @.s3851 to i64
br label %L1209
L1209:
%t3853 = phi i64 [ %t3850, %L1207 ], [ %t3852, %L1208 ]
%t3854 = call i64 @cstr_dup(i64 %t3853)
ret i64 %t3854
L1206:
%t3855 = call i64 @ld64(i64 %t3841)
%t3856 = sub i64 0, %t3855
%t3857 = sub nsw i64 %t3856, 1
%t3858 = call i64 @__mruntime_rt_numfmt_resid__f128_assemble(i64 %p2, i64 0, i64 %p3, i64 %t3844, i64 %t3857, i1 %p6)
ret i64 %t3858
}
define internal i64 @__mruntime_rt_numfmt_resid__f128_assemble(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i1 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3859p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_digits)
%t3859 = ptrtoint ptr %t3859p to i64
%t3860 = call i64 @__mruntime_rt_numfmt_resid__copy_rev(i64 %p0, i64 %p1, i64 %t3859, i64 0, i64 37)
%t3861 = call i64 @__mruntime_rt_numfmt_resid__copy_fwd(i64 %p2, i64 %p3, i64 %t3859, i64 %t3860, i64 37, i64 0)
%t3862 = icmp sgt i64 %t3861, 36
br label %LSL3863
LSL3863:
br i1 %t3862, label %LSR3863, label %LSJ3863
LSR3863:
%t3864 = add i64 %t3859, 36
%t3865 = call i64 @ld8(i64 %t3864)
%t3866 = icmp sge i64 %t3865, 53
br label %LSJ3863
LSJ3863:
%t3867 = phi i1 [ false, %LSL3863 ], [ %t3866, %LSR3863 ]
br label %LSL3868
LSL3868:
br i1 %t3867, label %LSR3868, label %LSJ3868
LSR3868:
%t3869 = call i1 @__mruntime_rt_numfmt_resid__round_up(i64 %t3859, i64 35)
br label %LSJ3868
LSJ3868:
%t3870 = phi i1 [ false, %LSL3868 ], [ %t3869, %LSR3868 ]
br i1 %t3870, label %L1210, label %L1211
L1210:
%t3871 = call i64 @st8(i64 %t3859, i64 49)
%t3872 = add i64 %t3859, 1
%t3873p = inttoptr i64 %t3872 to ptr
%t3873q = trunc i64 48 to i8
call void @llvm.memset.p0.i64(ptr %t3873p, i8 %t3873q, i64 35, i1 false)
%t3873 = add i64 0, 0
%t3874 = add i64 %t3871, %t3873
br label %L1212
L1211:
br label %L1212
L1212:
%t3875 = phi i64 [ %t3874, %L1210 ], [ 0, %L1211 ]
br i1 %t3870, label %L1213, label %L1214
L1213:
%t3876 = add i64 %p4, 1
br label %L1215
L1214:
br label %L1215
L1215:
%t3877 = phi i64 [ %t3876, %L1213 ], [ %p4, %L1214 ]
%t3878 = icmp sgt i64 %t3861, 36
br i1 %t3878, label %L1216, label %L1217
L1216:
br label %L1218
L1217:
br label %L1218
L1218:
%t3879 = phi i64 [ 36, %L1216 ], [ %t3861, %L1217 ]
%t3880 = call i64 @__mruntime_rt_numfmt_resid__strip_zeros(i64 %t3859, i64 %t3879)
%t3881p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.f128_out)
%t3881 = ptrtoint ptr %t3881p to i64
br i1 %p5, label %L1219, label %L1220
L1219:
%t3882 = call i64 @st8(i64 %t3881, i64 45)
%t3883 = add i64 %t3882, 1
br label %L1221
L1220:
br label %L1221
L1221:
%t3884 = phi i64 [ %t3883, %L1219 ], [ 0, %L1220 ]
%t3885 = sub nsw i64 0, 6
%t3886 = icmp sge i64 %t3877, %t3885
br label %LSL3887
LSL3887:
br i1 %t3886, label %LSR3887, label %LSJ3887
LSR3887:
%t3888 = icmp sle i64 %t3877, 36
br label %LSJ3887
LSJ3887:
%t3889 = phi i1 [ false, %LSL3887 ], [ %t3888, %LSR3887 ]
br i1 %t3889, label %L1222, label %L1223
L1222:
%t3890 = call i64 @__mruntime_rt_numfmt_resid__fixed_text(i64 %t3881, i64 %t3884, i64 %t3859, i64 %t3880, i64 %t3877)
br label %L1224
L1223:
%t3891 = call i64 @__mruntime_rt_numfmt_resid__sci_text(i64 %t3881, i64 %t3884, i64 %t3859, i64 %t3880, i64 %t3877)
br label %L1224
L1224:
%t3892 = phi i64 [ %t3890, %L1222 ], [ %t3891, %L1223 ]
%t3893 = call i64 @cstr_from(i64 %t3881, i64 %t3892, i64 0)
ret i64 %t3893
}
define internal i64 @__mruntime_rt_numfmt_resid__copy_rev(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t3904, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t3894 = icmp sge i64 %p3, %p1
br label %LSL3895
LSL3895:
br i1 %t3894, label %LSJ3895, label %LSR3895
LSR3895:
%t3896 = icmp sge i64 %p3, %p4
br label %LSJ3895
LSJ3895:
%t3897 = phi i1 [ true, %LSL3895 ], [ %t3896, %LSR3895 ]
br i1 %t3897, label %L1225, label %L1227
L1225:
ret i64 %p3
L1227:
%t3898 = add i64 %p2, %p3
%t3899 = add i64 %p0, %p1
%t3900 = sub i64 %t3899, 1
%t3901 = sub i64 %t3900, %p3
%t3902 = call i64 @ld8(i64 %t3901)
%t3903 = call i64 @st8(i64 %t3898, i64 %t3902)
%t3904 = add nsw i64 %p3, 1
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t3914, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t3915, %tco.s0 ]
%t3906 = icmp sge i64 %p5, %p1
br label %LSL3907
LSL3907:
br i1 %t3906, label %LSJ3907, label %LSR3907
LSR3907:
%t3908 = icmp sge i64 %p3, %p4
br label %LSJ3907
LSJ3907:
%t3909 = phi i1 [ true, %LSL3907 ], [ %t3908, %LSR3907 ]
br i1 %t3909, label %L1228, label %L1230
L1228:
ret i64 %p3
L1230:
%t3910 = add i64 %p2, %p3
%t3911 = add i64 %p0, %p5
%t3912 = call i64 @ld8(i64 %t3911)
%t3913 = call i64 @st8(i64 %t3910, i64 %t3912)
%t3914 = add nsw i64 %p3, 1
%t3915 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_numfmt_resid__round_up(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3923, %tco.s0 ]
%t3917 = icmp slt i64 %p1, 0
br i1 %t3917, label %L1231, label %L1233
L1231:
ret i1 true
L1233:
%t3918 = add i64 %p0, %p1
%t3919 = call i64 @ld8(i64 %t3918)
%t3920 = icmp eq i64 %t3919, 57
br i1 %t3920, label %L1234, label %L1236
L1234:
%t3921 = add i64 %p0, %p1
%t3922 = call i64 @st8(i64 %t3921, i64 48)
%t3923 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L1236:
%t3925 = add i64 %p0, %p1
%t3926 = add i64 %p0, %p1
%t3927 = call i64 @ld8(i64 %t3926)
%t3928 = add i64 %t3927, 1
%t3929 = call i64 @st8(i64 %t3925, i64 %t3928)
ret i1 false
}
define internal i64 @__mruntime_rt_numfmt_resid__strip_zeros(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3937, %tco.s0 ]
%t3930 = icmp sgt i64 %p1, 1
br label %LSL3931
LSL3931:
br i1 %t3930, label %LSR3931, label %LSJ3931
LSR3931:
%t3932 = add i64 %p0, %p1
%t3933 = sub nsw i64 %t3932, 1
%t3934 = call i64 @ld8(i64 %t3933)
%t3935 = icmp eq i64 %t3934, 48
br label %LSJ3931
LSJ3931:
%t3936 = phi i1 [ false, %LSL3931 ], [ %t3935, %LSR3931 ]
br i1 %t3936, label %L1237, label %L1239
L1237:
%t3937 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L1239:
ret i64 %p1
}
define internal i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3939 = add i64 %p0, %p1
%t3940 = call i64 @st8(i64 %t3939, i64 %p2)
%t3941 = add i64 %t3940, %p1
%t3942 = add i64 %t3941, 1
ret i64 %t3942
}
define internal i64 @__mruntime_rt_numfmt_resid__fixed_text(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3943 = icmp slt i64 %p4, 0
br i1 %t3943, label %L1240, label %L1242
L1240:
%t3944 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 48)
%t3945 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t3944, i64 46)
%t3946 = sub i64 0, %p4
%t3947 = sub nsw i64 %t3946, 1
%t3948 = call i64 @__mruntime_rt_numfmt_resid__zeros(i64 %p0, i64 %t3945, i64 %t3947)
%t3949 = tail call i64 @__mruntime_rt_numfmt_resid__digits_out(i64 %p0, i64 %t3948, i64 %p2, i64 0, i64 %p3)
ret i64 %t3949
L1242:
%t3950 = call i64 @__mruntime_rt_numfmt_resid__int_part(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 0, i64 %p4)
%t3951 = add i64 %p4, 1
%t3952 = icmp slt i64 %t3951, %p3
br i1 %t3952, label %L1243, label %L1245
L1243:
%t3953 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t3950, i64 46)
%t3954 = add i64 %p4, 1
%t3955 = tail call i64 @__mruntime_rt_numfmt_resid__digits_out(i64 %p0, i64 %t3953, i64 %p2, i64 %t3954, i64 %p3)
ret i64 %t3955
L1245:
ret i64 %t3950
}
define internal i64 @__mruntime_rt_numfmt_resid__zeros(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3957, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3958, %tco.s0 ]
%t3956 = icmp sle i64 %p2, 0
br i1 %t3956, label %L1246, label %L1248
L1246:
ret i64 %p1
L1248:
%t3957 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 48)
%t3958 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__digits_out(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3963, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t3964, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t3960 = icmp sge i64 %p3, %p4
br i1 %t3960, label %L1249, label %L1251
L1249:
ret i64 %p1
L1251:
%t3961 = add i64 %p2, %p3
%t3962 = call i64 @ld8(i64 %t3961)
%t3963 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 %t3962)
%t3964 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__int_part(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3971, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t3972, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t3966 = icmp sgt i64 %p4, %p5
br i1 %t3966, label %L1252, label %L1254
L1252:
ret i64 %p1
L1254:
%t3967 = icmp slt i64 %p4, %p3
br i1 %t3967, label %L1255, label %L1256
L1255:
%t3968 = add i64 %p2, %p4
%t3969 = call i64 @ld8(i64 %t3968)
br label %L1257
L1256:
br label %L1257
L1257:
%t3970 = phi i64 [ %t3969, %L1255 ], [ 48, %L1256 ]
%t3971 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 %t3970)
%t3972 = add i64 %p4, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_numfmt_resid__sci_text(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3974 = call i64 @ld8(i64 %p2)
%t3975 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %p1, i64 %t3974)
%t3976 = icmp sgt i64 %p3, 1
br i1 %t3976, label %L1258, label %L1259
L1258:
%t3977 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t3975, i64 46)
%t3978 = call i64 @__mruntime_rt_numfmt_resid__digits_out(i64 %p0, i64 %t3977, i64 %p2, i64 1, i64 %p3)
br label %L1260
L1259:
br label %L1260
L1260:
%t3979 = phi i64 [ %t3978, %L1258 ], [ %t3975, %L1259 ]
%t3980 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t3979, i64 69)
%t3981 = icmp sge i64 %p4, 0
br i1 %t3981, label %L1261, label %L1262
L1261:
br label %L1263
L1262:
br label %L1263
L1263:
%t3982 = phi i64 [ 43, %L1261 ], [ 45, %L1262 ]
%t3983 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t3980, i64 %t3982)
%t3984 = icmp sge i64 %p4, 0
br i1 %t3984, label %L1264, label %L1265
L1264:
br label %L1266
L1265:
%t3985 = sub i64 0, %p4
br label %L1266
L1266:
%t3986 = phi i64 [ %p4, %L1264 ], [ %t3985, %L1265 ]
%t3987 = icmp slt i64 %t3986, 10
br i1 %t3987, label %L1267, label %L1268
L1267:
%t3988 = call i64 @__mruntime_rt_numfmt_resid__put_byte(i64 %p0, i64 %t3983, i64 48)
br label %L1269
L1268:
br label %L1269
L1269:
%t3989 = phi i64 [ %t3988, %L1267 ], [ %t3983, %L1268 ]
%t3990 = add i64 %p0, %t3989
%t3991 = call i64 @itoa_into(i64 %t3990, i64 %t3986)
%t3992 = add i64 %t3989, %t3991
ret i64 %t3992
}
define internal i1 @__mruntime_rt_show_resid__box_imm(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3993 = sub i64 %p0, 281474976710656
%t3994 = call i1 @ult(i64 %t3993, i64 36028797018963968)
ret i1 %t3994
}
define internal i1 @__mruntime_rt_show_resid__box_fimm(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3995 = call i1 @ult(i64 %p0, i64 72057594037927936)
%t3996 = xor i1 %t3995, true
ret i1 %t3996
}
define internal i64 @__mruntime_rt_show_resid__imm_val(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3997 = sub i64 %p0, 18295873486192640
ret i64 %t3997
}
define internal i64 @__mruntime_rt_show_resid__sx32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3998 = shl i64 %p0, 32
%t3999 = ashr i64 %t3998, 32
ret i64 %t3999
}
define internal i64 @__mruntime_rt_show_resid__box_tag(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4000 = call i64 @ld32(i64 %p0)
%t4001 = tail call i64 @__mruntime_rt_show_resid__sx32(i64 %t4000)
ret i64 %t4001
}
define internal i64 @__mruntime_rt_show_resid__box_count(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4002 = add i64 %p0, 4
%t4003 = call i64 @ld32(i64 %t4002)
%t4004 = tail call i64 @__mruntime_rt_show_resid__sx32(i64 %t4003)
ret i64 %t4004
}
define internal i64 @__mruntime_rt_show_resid__box_type(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4005 = add i64 %p0, 8
%t4006 = tail call i64 @ld64(i64 %t4005)
ret i64 %t4006
}
define internal i64 @__mruntime_rt_show_resid__box_slot(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4007 = add i64 %p0, 16
%t4008 = mul i64 %p1, 8
%t4009 = add i64 %t4007, %t4008
%t4010 = call i64 @ld64(i64 %t4009)
ret i64 %t4010
}
define internal i64 @unbox_word(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4011 = call i1 @__mruntime_rt_show_resid__box_imm(i64 %p0)
br i1 %t4011, label %L1270, label %L1271
L1270:
%t4012 = call i64 @__mruntime_rt_show_resid__imm_val(i64 %p0)
br label %L1272
L1271:
%t4013 = add i64 %p0, 24
%t4014 = call i64 @ld64(i64 %t4013)
br label %L1272
L1272:
%t4015 = phi i64 [ %t4012, %L1270 ], [ %t4014, %L1271 ]
ret i64 %t4015
}
define internal double @unbox_float(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4016 = call i1 @__mruntime_rt_show_resid__box_fimm(i64 %p0)
br i1 %t4016, label %L1273, label %L1274
L1273:
br label %L1275
L1274:
%t4017 = add i64 %p0, 24
%t4018 = call i64 @ld64(i64 %t4017)
br label %L1275
L1275:
%t4019 = phi i64 [ %p0, %L1273 ], [ %t4018, %L1274 ]
%t4020 = bitcast i64 %t4019 to double
ret double %t4020
}
define internal i64 @__mruntime_rt_show_resid__scalar_kind(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4021 = call i1 @__mruntime_rt_show_resid__box_imm(i64 %p0)
br i1 %t4021, label %L1276, label %L1278
L1276:
ret i64 105
L1278:
%t4022 = call i1 @__mruntime_rt_show_resid__box_fimm(i64 %p0)
br i1 %t4022, label %L1279, label %L1281
L1279:
ret i64 102
L1281:
%t4023 = call i64 @__mruntime_rt_show_resid__box_tag(i64 %p0)
%t4024 = sub nsw i64 0, 1
%t4025 = icmp ne i64 %t4023, %t4024
br label %LSL4026
LSL4026:
br i1 %t4025, label %LSJ4026, label %LSR4026
LSR4026:
%t4027 = call i64 @__mruntime_rt_show_resid__box_type(i64 %p0)
%t4028 = icmp eq i64 %t4027, 0
br label %LSJ4026
LSJ4026:
%t4029 = phi i1 [ true, %LSL4026 ], [ %t4028, %LSR4026 ]
br i1 %t4029, label %L1282, label %L1284
L1282:
ret i64 0
L1284:
%t4030 = call i64 @__mruntime_rt_show_resid__box_type(i64 %p0)
%t4031 = tail call i64 @ld8(i64 %t4030)
ret i64 %t4031
}
define internal i64 @__mruntime_rt_show_resid__sb_lit(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4032 = call i64 @c_strlen(i64 %p1)
%t4033 = call i64 @sb_bytes(i64 %p0, i64 %p1, i64 %t4032)
ret i64 %t4033
}
define internal i64 @__mruntime_rt_show_resid__sb_word(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4034p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.show_buf)
%t4034 = ptrtoint ptr %t4034p to i64
%t4035 = call i64 @itoa_into(i64 %t4034, i64 %p1)
%t4036 = call i64 @sb_bytes(i64 %p0, i64 %t4034, i64 %t4035)
ret i64 %t4036
}
define internal i64 @__mruntime_rt_show_resid__sb_float(i64 %p0, double %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4037p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.show_buf)
%t4037 = ptrtoint ptr %t4037p to i64
%t4039 = ptrtoint ptr @.s4038 to i64
%t4040 = call i64 @c_strfromd(i64 %t4037, i64 64, i64 %t4039, double %p1)
%t4041 = call i64 @sb_bytes(i64 %p0, i64 %t4037, i64 %t4040)
ret i64 %t4041
}
define internal i64 @__mruntime_rt_show_resid__sb_scalar(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4042 = icmp eq i64 %p2, 102
br i1 %t4042, label %L1285, label %L1287
L1285:
%t4043 = call double @unbox_float(i64 %p1)
%t4044 = call i64 @__mruntime_rt_show_resid__sb_float(i64 %p0, double %t4043)
ret i64 %t4044
L1287:
%t4045 = icmp eq i64 %p2, 98
br i1 %t4045, label %L1288, label %L1290
L1288:
%t4046 = add i64 %p1, 24
%t4047 = call i64 @ld8(i64 %t4046)
%t4048 = icmp ne i64 %t4047, 0
br i1 %t4048, label %L1291, label %L1292
L1291:
%t4050 = ptrtoint ptr @.s4049 to i64
br label %L1293
L1292:
%t4052 = ptrtoint ptr @.s4051 to i64
br label %L1293
L1293:
%t4053 = phi i64 [ %t4050, %L1291 ], [ %t4052, %L1292 ]
%t4054 = call i64 @__mruntime_rt_show_resid__sb_lit(i64 %p0, i64 %t4053)
ret i64 %t4054
L1290:
%t4055 = call i64 @unbox_word(i64 %p1)
%t4056 = call i64 @__mruntime_rt_show_resid__sb_word(i64 %p0, i64 %t4055)
ret i64 %t4056
}
define internal i64 @__mruntime_rt_show_resid__sb_elem(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4057 = icmp eq i64 %p1, 0
br i1 %t4057, label %L1294, label %L1296
L1294:
%t4059 = ptrtoint ptr @.s4058 to i64
%t4060 = tail call i64 @__mruntime_rt_show_resid__sb_lit(i64 %p0, i64 %t4059)
ret i64 %t4060
L1296:
%t4061 = call i64 @__mruntime_rt_show_resid__scalar_kind(i64 %p1)
%t4062 = icmp eq i64 %t4061, 0
br i1 %t4062, label %L1297, label %L1299
L1297:
%t4064 = ptrtoint ptr @.s4063 to i64
%t4065 = tail call i64 @__mruntime_rt_show_resid__sb_lit(i64 %p0, i64 %t4064)
ret i64 %t4065
L1299:
%t4066 = call i64 @__mruntime_rt_show_resid__sb_scalar(i64 %p0, i64 %p1, i64 %t4061)
ret i64 %t4066
}
define internal i64 @__mruntime_rt_show_resid__sb_slots(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4075, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t4067 = icmp sge i64 %p2, %p3
br i1 %t4067, label %L1300, label %L1302
L1300:
ret i64 0
L1302:
%t4068 = icmp sgt i64 %p2, 0
br i1 %t4068, label %L1303, label %L1304
L1303:
%t4070 = ptrtoint ptr @.s4069 to i64
%t4071 = call i64 @__mruntime_rt_show_resid__sb_lit(i64 %p0, i64 %t4070)
br label %L1305
L1304:
br label %L1305
L1305:
%t4072 = phi i64 [ %t4071, %L1303 ], [ 0, %L1304 ]
%t4073 = call i64 @__mruntime_rt_show_resid__box_slot(i64 %p1, i64 %p2)
%t4074 = call i64 @__mruntime_rt_show_resid__sb_elem(i64 %p0, i64 %t4073)
%t4075 = add nsw i64 %p2, 1
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4085, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t4077 = icmp sge i64 %p2, %p3
br i1 %t4077, label %L1306, label %L1308
L1306:
ret i64 0
L1308:
%t4078 = icmp sgt i64 %p2, 0
br i1 %t4078, label %L1309, label %L1310
L1309:
%t4080 = ptrtoint ptr @.s4079 to i64
%t4081 = call i64 @__mruntime_rt_show_resid__sb_lit(i64 %p0, i64 %t4080)
br label %L1311
L1310:
br label %L1311
L1311:
%t4082 = phi i64 [ %t4081, %L1309 ], [ 0, %L1310 ]
%t4083 = call i64 @c_list_get(i64 %p1, i64 %p2)
%t4084 = call i64 @__mruntime_rt_show_resid__sb_elem(i64 %p0, i64 %t4083)
%t4085 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_to_string(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4087 = call i1 @__mruntime_rt_show_resid__box_imm(i64 %p0)
br i1 %t4087, label %L1312, label %L1314
L1312:
%t4088 = call i64 @__mruntime_rt_show_resid__imm_val(i64 %p0)
%t4089 = tail call i64 @rt_int_to_string(i64 %t4088)
ret i64 %t4089
L1314:
%t4090 = call i1 @__mruntime_rt_show_resid__box_fimm(i64 %p0)
br i1 %t4090, label %L1315, label %L1317
L1315:
%t4091 = call double @unbox_float(i64 %p0)
%t4092 = call i64 @rt_float_to_string(double %t4091)
ret i64 %t4092
L1317:
%t4093 = icmp eq i64 %p0, 0
br label %LSL4094
LSL4094:
br i1 %t4093, label %LSJ4094, label %LSR4094
LSR4094:
%t4095 = call i64 @__mruntime_rt_show_resid__box_count(i64 %p0)
%t4096 = icmp sle i64 %t4095, 0
br label %LSJ4094
LSJ4094:
%t4097 = phi i1 [ true, %LSL4094 ], [ %t4096, %LSR4094 ]
br i1 %t4097, label %L1318, label %L1320
L1318:
%t4099 = ptrtoint ptr @.s4098 to i64
%t4100 = tail call i64 @cstr_dup(i64 %t4099)
ret i64 %t4100
L1320:
%t4101 = call i64 @__mruntime_rt_show_resid__box_tag(i64 %p0)
%t4102 = call i64 @__mruntime_rt_show_resid__box_type(i64 %p0)
%t4103 = sub nsw i64 0, 1
%t4104 = icmp eq i64 %t4101, %t4103
br i1 %t4104, label %L1321, label %L1323
L1321:
%t4105 = icmp ne i64 %t4102, 0
br label %LSL4106
LSL4106:
br i1 %t4105, label %LSR4106, label %LSJ4106
LSR4106:
%t4108 = ptrtoint ptr @.s4107 to i64
%t4109 = call i64 @c_strcmp(i64 %t4102, i64 %t4108)
%t4110 = icmp eq i64 %t4109, 0
br label %LSJ4106
LSJ4106:
%t4111 = phi i1 [ false, %LSL4106 ], [ %t4110, %LSR4106 ]
br i1 %t4111, label %L1324, label %L1326
L1324:
%t4112 = call i64 @limbs2(i64 %p0)
%t4113 = add i64 %p0, 32
%t4114 = call i64 @ld64(i64 %t4113)
%t4115 = icmp slt i64 %t4114, 0
%t4116 = call i64 @limbs_to_str(i64 %t4112, i64 2, i1 %t4115)
ret i64 %t4116
L1326:
%t4117 = icmp ne i64 %t4102, 0
br label %LSL4118
LSL4118:
br i1 %t4117, label %LSR4118, label %LSJ4118
LSR4118:
%t4120 = ptrtoint ptr @.s4119 to i64
%t4121 = call i64 @c_strcmp(i64 %t4102, i64 %t4120)
%t4122 = icmp eq i64 %t4121, 0
br label %LSJ4118
LSJ4118:
%t4123 = phi i1 [ false, %LSL4118 ], [ %t4122, %LSR4118 ]
br i1 %t4123, label %L1327, label %L1329
L1327:
%t4124 = call i64 @limbs2(i64 %p0)
%t4125 = call i64 @limbs_to_str(i64 %t4124, i64 2, i1 false)
ret i64 %t4125
L1329:
%t4126 = icmp eq i64 %t4102, 0
br i1 %t4126, label %L1330, label %L1331
L1330:
br label %L1332
L1331:
%t4127 = call i64 @ld8(i64 %t4102)
br label %L1332
L1332:
%t4128 = phi i64 [ 0, %L1330 ], [ %t4127, %L1331 ]
%t4129 = call i64 @rt_sb_new()
%t4130 = icmp eq i64 %t4128, 102
br label %LSL4131
LSL4131:
br i1 %t4130, label %LSJ4131, label %LSR4131
LSR4131:
%t4132 = icmp eq i64 %t4128, 98
br label %LSJ4131
LSJ4131:
%t4133 = phi i1 [ true, %LSL4131 ], [ %t4132, %LSR4131 ]
br i1 %t4133, label %L1333, label %L1334
L1333:
br label %L1335
L1334:
br label %L1335
L1335:
%t4134 = phi i64 [ %t4128, %L1333 ], [ 105, %L1334 ]
%t4135 = call i64 @__mruntime_rt_show_resid__sb_scalar(i64 %t4129, i64 %p0, i64 %t4134)
%t4136 = tail call i64 @rt_sb_finish(i64 %t4129)
ret i64 %t4136
L1323:
%t4137 = icmp eq i64 %t4101, 1
br label %LSL4138
LSL4138:
br i1 %t4137, label %LSR4138, label %LSJ4138
LSR4138:
%t4139 = call i64 @__mruntime_rt_show_resid__box_count(i64 %p0)
%t4140 = icmp eq i64 %t4139, 1
br label %LSJ4138
LSJ4138:
%t4141 = phi i1 [ false, %LSL4138 ], [ %t4140, %LSR4138 ]
br label %LSL4142
LSL4142:
br i1 %t4141, label %LSR4142, label %LSJ4142
LSR4142:
%t4143 = call i64 @__mruntime_rt_show_resid__box_slot(i64 %p0, i64 0)
%t4144 = icmp ne i64 %t4143, 0
br label %LSJ4142
LSJ4142:
%t4145 = phi i1 [ false, %LSL4142 ], [ %t4144, %LSR4142 ]
br i1 %t4145, label %L1336, label %L1338
L1336:
%t4146 = call i64 @__mruntime_rt_show_resid__box_slot(i64 %p0, i64 0)
%t4147 = call i64 @__mruntime_rt_show_resid__scalar_kind(i64 %t4146)
%t4148 = call i64 @rt_sb_new()
%t4149 = icmp ne i64 %t4147, 0
br i1 %t4149, label %L1339, label %L1340
L1339:
%t4151 = ptrtoint ptr @.s4150 to i64
br label %L1341
L1340:
%t4153 = ptrtoint ptr @.s4152 to i64
br label %L1341
L1341:
%t4154 = phi i64 [ %t4151, %L1339 ], [ %t4153, %L1340 ]
%t4155 = call i64 @__mruntime_rt_show_resid__sb_lit(i64 %t4148, i64 %t4154)
%t4156 = icmp ne i64 %t4147, 0
br i1 %t4156, label %L1342, label %L1343
L1342:
%t4157 = call i64 @__mruntime_rt_show_resid__sb_scalar(i64 %t4148, i64 %t4146, i64 %t4147)
br label %L1344
L1343:
%t4158 = call i64 @__mruntime_rt_show_resid__sb_lit(i64 %t4148, i64 %t4102)
br label %L1344
L1344:
%t4159 = phi i64 [ %t4157, %L1342 ], [ %t4158, %L1343 ]
%t4160 = icmp ne i64 %t4147, 0
br i1 %t4160, label %L1345, label %L1346
L1345:
%t4162 = ptrtoint ptr @.s4161 to i64
br label %L1347
L1346:
%t4164 = ptrtoint ptr @.s4163 to i64
br label %L1347
L1347:
%t4165 = phi i64 [ %t4162, %L1345 ], [ %t4164, %L1346 ]
%t4166 = call i64 @__mruntime_rt_show_resid__sb_lit(i64 %t4148, i64 %t4165)
%t4167 = tail call i64 @rt_sb_finish(i64 %t4148)
ret i64 %t4167
L1338:
%t4168 = icmp eq i64 %t4101, 2
br i1 %t4168, label %L1348, label %L1350
L1348:
%t4170 = ptrtoint ptr @.s4169 to i64
%t4171 = tail call i64 @cstr_dup(i64 %t4170)
ret i64 %t4171
L1350:
%t4172 = call i64 @rt_sb_new()
%t4173 = call i64 @__mruntime_rt_show_resid__sb_lit(i64 %t4172, i64 %t4102)
%t4175 = ptrtoint ptr @.s4174 to i64
%t4176 = call i64 @__mruntime_rt_show_resid__sb_lit(i64 %t4172, i64 %t4175)
%t4177 = call i64 @__mruntime_rt_show_resid__box_count(i64 %p0)
%t4178 = call i64 @__mruntime_rt_show_resid__sb_slots(i64 %t4172, i64 %p0, i64 0, i64 %t4177)
%t4180 = ptrtoint ptr @.s4179 to i64
%t4181 = call i64 @__mruntime_rt_show_resid__sb_lit(i64 %t4172, i64 %t4180)
%t4182 = tail call i64 @rt_sb_finish(i64 %t4172)
ret i64 %t4182
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
%t4183 = icmp eq i64 %p0, 0
br i1 %t4183, label %L1351, label %L1353
L1351:
%t4185 = ptrtoint ptr @.s4184 to i64
%t4186 = call i64 @cstr_dup(i64 %t4185)
ret i64 %t4186
L1353:
%t4187 = call i64 @rt_sb_new()
%t4188 = add i64 %p0, 24
%t4189 = call i64 @ld64(i64 %t4188)
%t4190 = call i64 @__mruntime_rt_show_resid__sb_lit(i64 %t4187, i64 %t4189)
%t4192 = ptrtoint ptr @.s4191 to i64
%t4193 = call i64 @__mruntime_rt_show_resid__sb_lit(i64 %t4187, i64 %t4192)
%t4194 = icmp ne i64 %p1, 0
br i1 %t4194, label %L1354, label %L1355
L1354:
%t4195 = call i64 @ld64(i64 %p0)
%t4196 = call i64 @__mruntime_rt_show_resid__sb_strs(i64 %t4187, i64 %p0, i64 0, i64 %t4195)
br label %L1356
L1355:
%t4197 = call i64 @ld64(i64 %p0)
%t4198 = call i64 @__mruntime_rt_show_resid__sb_items(i64 %t4187, i64 %p0, i64 0, i64 %t4197)
br label %L1356
L1356:
%t4199 = phi i64 [ %t4196, %L1354 ], [ %t4198, %L1355 ]
%t4201 = ptrtoint ptr @.s4200 to i64
%t4202 = call i64 @__mruntime_rt_show_resid__sb_lit(i64 %t4187, i64 %t4201)
%t4203 = call i64 @rt_sb_finish(i64 %t4187)
ret i64 %t4203
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4212, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t4204 = icmp sge i64 %p2, %p3
br i1 %t4204, label %L1357, label %L1359
L1357:
ret i64 0
L1359:
%t4205 = icmp sgt i64 %p2, 0
br i1 %t4205, label %L1360, label %L1361
L1360:
%t4207 = ptrtoint ptr @.s4206 to i64
%t4208 = call i64 @__mruntime_rt_show_resid__sb_lit(i64 %p0, i64 %t4207)
br label %L1362
L1361:
br label %L1362
L1362:
%t4209 = phi i64 [ %t4208, %L1360 ], [ 0, %L1361 ]
%t4210 = call i64 @c_list_get(i64 %p1, i64 %p2)
%t4211 = call i64 @__mruntime_rt_show_resid__sb_lit(i64 %p0, i64 %t4210)
%t4212 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_list_to_string(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t4214 = call i64 @rt_list_show(i64 %p0, i64 0)
ret i64 %t4214
}
define ptr @resid_list_to_string(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_list_to_string(i64 %x0i)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
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
declare ptr @resid_list_to_array(ptr)
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
@rtt.8354 = private unnamed_addr constant [2918 x i64] [i64 65, i64 97, i64 66, i64 98, i64 67, i64 99, i64 68, i64 100, i64 69, i64 101, i64 70, i64 102, i64 71, i64 103, i64 72, i64 104, i64 73, i64 105, i64 74, i64 106, i64 75, i64 107, i64 76, i64 108, i64 77, i64 109, i64 78, i64 110, i64 79, i64 111, i64 80, i64 112, i64 81, i64 113, i64 82, i64 114, i64 83, i64 115, i64 84, i64 116, i64 85, i64 117, i64 86, i64 118, i64 87, i64 119, i64 88, i64 120, i64 89, i64 121, i64 90, i64 122, i64 192, i64 224, i64 193, i64 225, i64 194, i64 226, i64 195, i64 227, i64 196, i64 228, i64 197, i64 229, i64 198, i64 230, i64 199, i64 231, i64 200, i64 232, i64 201, i64 233, i64 202, i64 234, i64 203, i64 235, i64 204, i64 236, i64 205, i64 237, i64 206, i64 238, i64 207, i64 239, i64 208, i64 240, i64 209, i64 241, i64 210, i64 242, i64 211, i64 243, i64 212, i64 244, i64 213, i64 245, i64 214, i64 246, i64 216, i64 248, i64 217, i64 249, i64 218, i64 250, i64 219, i64 251, i64 220, i64 252, i64 221, i64 253, i64 222, i64 254, i64 256, i64 257, i64 258, i64 259, i64 260, i64 261, i64 262, i64 263, i64 264, i64 265, i64 266, i64 267, i64 268, i64 269, i64 270, i64 271, i64 272, i64 273, i64 274, i64 275, i64 276, i64 277, i64 278, i64 279, i64 280, i64 281, i64 282, i64 283, i64 284, i64 285, i64 286, i64 287, i64 288, i64 289, i64 290, i64 291, i64 292, i64 293, i64 294, i64 295, i64 296, i64 297, i64 298, i64 299, i64 300, i64 301, i64 302, i64 303, i64 306, i64 307, i64 308, i64 309, i64 310, i64 311, i64 313, i64 314, i64 315, i64 316, i64 317, i64 318, i64 319, i64 320, i64 321, i64 322, i64 323, i64 324, i64 325, i64 326, i64 327, i64 328, i64 330, i64 331, i64 332, i64 333, i64 334, i64 335, i64 336, i64 337, i64 338, i64 339, i64 340, i64 341, i64 342, i64 343, i64 344, i64 345, i64 346, i64 347, i64 348, i64 349, i64 350, i64 351, i64 352, i64 353, i64 354, i64 355, i64 356, i64 357, i64 358, i64 359, i64 360, i64 361, i64 362, i64 363, i64 364, i64 365, i64 366, i64 367, i64 368, i64 369, i64 370, i64 371, i64 372, i64 373, i64 374, i64 375, i64 376, i64 255, i64 377, i64 378, i64 379, i64 380, i64 381, i64 382, i64 385, i64 595, i64 386, i64 387, i64 388, i64 389, i64 390, i64 596, i64 391, i64 392, i64 393, i64 598, i64 394, i64 599, i64 395, i64 396, i64 398, i64 477, i64 399, i64 601, i64 400, i64 603, i64 401, i64 402, i64 403, i64 608, i64 404, i64 611, i64 406, i64 617, i64 407, i64 616, i64 408, i64 409, i64 412, i64 623, i64 413, i64 626, i64 415, i64 629, i64 416, i64 417, i64 418, i64 419, i64 420, i64 421, i64 422, i64 640, i64 423, i64 424, i64 425, i64 643, i64 428, i64 429, i64 430, i64 648, i64 431, i64 432, i64 433, i64 650, i64 434, i64 651, i64 435, i64 436, i64 437, i64 438, i64 439, i64 658, i64 440, i64 441, i64 444, i64 445, i64 452, i64 454, i64 453, i64 454, i64 455, i64 457, i64 456, i64 457, i64 458, i64 460, i64 459, i64 460, i64 461, i64 462, i64 463, i64 464, i64 465, i64 466, i64 467, i64 468, i64 469, i64 470, i64 471, i64 472, i64 473, i64 474, i64 475, i64 476, i64 478, i64 479, i64 480, i64 481, i64 482, i64 483, i64 484, i64 485, i64 486, i64 487, i64 488, i64 489, i64 490, i64 491, i64 492, i64 493, i64 494, i64 495, i64 497, i64 499, i64 498, i64 499, i64 500, i64 501, i64 502, i64 405, i64 503, i64 447, i64 504, i64 505, i64 506, i64 507, i64 508, i64 509, i64 510, i64 511, i64 512, i64 513, i64 514, i64 515, i64 516, i64 517, i64 518, i64 519, i64 520, i64 521, i64 522, i64 523, i64 524, i64 525, i64 526, i64 527, i64 528, i64 529, i64 530, i64 531, i64 532, i64 533, i64 534, i64 535, i64 536, i64 537, i64 538, i64 539, i64 540, i64 541, i64 542, i64 543, i64 544, i64 414, i64 546, i64 547, i64 548, i64 549, i64 550, i64 551, i64 552, i64 553, i64 554, i64 555, i64 556, i64 557, i64 558, i64 559, i64 560, i64 561, i64 562, i64 563, i64 570, i64 11365, i64 571, i64 572, i64 573, i64 410, i64 574, i64 11366, i64 577, i64 578, i64 579, i64 384, i64 580, i64 649, i64 581, i64 652, i64 582, i64 583, i64 584, i64 585, i64 586, i64 587, i64 588, i64 589, i64 590, i64 591, i64 880, i64 881, i64 882, i64 883, i64 886, i64 887, i64 895, i64 1011, i64 902, i64 940, i64 904, i64 941, i64 905, i64 942, i64 906, i64 943, i64 908, i64 972, i64 910, i64 973, i64 911, i64 974, i64 913, i64 945, i64 914, i64 946, i64 915, i64 947, i64 916, i64 948, i64 917, i64 949, i64 918, i64 950, i64 919, i64 951, i64 920, i64 952, i64 921, i64 953, i64 922, i64 954, i64 923, i64 955, i64 924, i64 956, i64 925, i64 957, i64 926, i64 958, i64 927, i64 959, i64 928, i64 960, i64 929, i64 961, i64 931, i64 963, i64 932, i64 964, i64 933, i64 965, i64 934, i64 966, i64 935, i64 967, i64 936, i64 968, i64 937, i64 969, i64 938, i64 970, i64 939, i64 971, i64 975, i64 983, i64 984, i64 985, i64 986, i64 987, i64 988, i64 989, i64 990, i64 991, i64 992, i64 993, i64 994, i64 995, i64 996, i64 997, i64 998, i64 999, i64 1000, i64 1001, i64 1002, i64 1003, i64 1004, i64 1005, i64 1006, i64 1007, i64 1012, i64 952, i64 1015, i64 1016, i64 1017, i64 1010, i64 1018, i64 1019, i64 1021, i64 891, i64 1022, i64 892, i64 1023, i64 893, i64 1024, i64 1104, i64 1025, i64 1105, i64 1026, i64 1106, i64 1027, i64 1107, i64 1028, i64 1108, i64 1029, i64 1109, i64 1030, i64 1110, i64 1031, i64 1111, i64 1032, i64 1112, i64 1033, i64 1113, i64 1034, i64 1114, i64 1035, i64 1115, i64 1036, i64 1116, i64 1037, i64 1117, i64 1038, i64 1118, i64 1039, i64 1119, i64 1040, i64 1072, i64 1041, i64 1073, i64 1042, i64 1074, i64 1043, i64 1075, i64 1044, i64 1076, i64 1045, i64 1077, i64 1046, i64 1078, i64 1047, i64 1079, i64 1048, i64 1080, i64 1049, i64 1081, i64 1050, i64 1082, i64 1051, i64 1083, i64 1052, i64 1084, i64 1053, i64 1085, i64 1054, i64 1086, i64 1055, i64 1087, i64 1056, i64 1088, i64 1057, i64 1089, i64 1058, i64 1090, i64 1059, i64 1091, i64 1060, i64 1092, i64 1061, i64 1093, i64 1062, i64 1094, i64 1063, i64 1095, i64 1064, i64 1096, i64 1065, i64 1097, i64 1066, i64 1098, i64 1067, i64 1099, i64 1068, i64 1100, i64 1069, i64 1101, i64 1070, i64 1102, i64 1071, i64 1103, i64 1120, i64 1121, i64 1122, i64 1123, i64 1124, i64 1125, i64 1126, i64 1127, i64 1128, i64 1129, i64 1130, i64 1131, i64 1132, i64 1133, i64 1134, i64 1135, i64 1136, i64 1137, i64 1138, i64 1139, i64 1140, i64 1141, i64 1142, i64 1143, i64 1144, i64 1145, i64 1146, i64 1147, i64 1148, i64 1149, i64 1150, i64 1151, i64 1152, i64 1153, i64 1162, i64 1163, i64 1164, i64 1165, i64 1166, i64 1167, i64 1168, i64 1169, i64 1170, i64 1171, i64 1172, i64 1173, i64 1174, i64 1175, i64 1176, i64 1177, i64 1178, i64 1179, i64 1180, i64 1181, i64 1182, i64 1183, i64 1184, i64 1185, i64 1186, i64 1187, i64 1188, i64 1189, i64 1190, i64 1191, i64 1192, i64 1193, i64 1194, i64 1195, i64 1196, i64 1197, i64 1198, i64 1199, i64 1200, i64 1201, i64 1202, i64 1203, i64 1204, i64 1205, i64 1206, i64 1207, i64 1208, i64 1209, i64 1210, i64 1211, i64 1212, i64 1213, i64 1214, i64 1215, i64 1216, i64 1231, i64 1217, i64 1218, i64 1219, i64 1220, i64 1221, i64 1222, i64 1223, i64 1224, i64 1225, i64 1226, i64 1227, i64 1228, i64 1229, i64 1230, i64 1232, i64 1233, i64 1234, i64 1235, i64 1236, i64 1237, i64 1238, i64 1239, i64 1240, i64 1241, i64 1242, i64 1243, i64 1244, i64 1245, i64 1246, i64 1247, i64 1248, i64 1249, i64 1250, i64 1251, i64 1252, i64 1253, i64 1254, i64 1255, i64 1256, i64 1257, i64 1258, i64 1259, i64 1260, i64 1261, i64 1262, i64 1263, i64 1264, i64 1265, i64 1266, i64 1267, i64 1268, i64 1269, i64 1270, i64 1271, i64 1272, i64 1273, i64 1274, i64 1275, i64 1276, i64 1277, i64 1278, i64 1279, i64 1280, i64 1281, i64 1282, i64 1283, i64 1284, i64 1285, i64 1286, i64 1287, i64 1288, i64 1289, i64 1290, i64 1291, i64 1292, i64 1293, i64 1294, i64 1295, i64 1296, i64 1297, i64 1298, i64 1299, i64 1300, i64 1301, i64 1302, i64 1303, i64 1304, i64 1305, i64 1306, i64 1307, i64 1308, i64 1309, i64 1310, i64 1311, i64 1312, i64 1313, i64 1314, i64 1315, i64 1316, i64 1317, i64 1318, i64 1319, i64 1320, i64 1321, i64 1322, i64 1323, i64 1324, i64 1325, i64 1326, i64 1327, i64 1329, i64 1377, i64 1330, i64 1378, i64 1331, i64 1379, i64 1332, i64 1380, i64 1333, i64 1381, i64 1334, i64 1382, i64 1335, i64 1383, i64 1336, i64 1384, i64 1337, i64 1385, i64 1338, i64 1386, i64 1339, i64 1387, i64 1340, i64 1388, i64 1341, i64 1389, i64 1342, i64 1390, i64 1343, i64 1391, i64 1344, i64 1392, i64 1345, i64 1393, i64 1346, i64 1394, i64 1347, i64 1395, i64 1348, i64 1396, i64 1349, i64 1397, i64 1350, i64 1398, i64 1351, i64 1399, i64 1352, i64 1400, i64 1353, i64 1401, i64 1354, i64 1402, i64 1355, i64 1403, i64 1356, i64 1404, i64 1357, i64 1405, i64 1358, i64 1406, i64 1359, i64 1407, i64 1360, i64 1408, i64 1361, i64 1409, i64 1362, i64 1410, i64 1363, i64 1411, i64 1364, i64 1412, i64 1365, i64 1413, i64 1366, i64 1414, i64 4256, i64 11520, i64 4257, i64 11521, i64 4258, i64 11522, i64 4259, i64 11523, i64 4260, i64 11524, i64 4261, i64 11525, i64 4262, i64 11526, i64 4263, i64 11527, i64 4264, i64 11528, i64 4265, i64 11529, i64 4266, i64 11530, i64 4267, i64 11531, i64 4268, i64 11532, i64 4269, i64 11533, i64 4270, i64 11534, i64 4271, i64 11535, i64 4272, i64 11536, i64 4273, i64 11537, i64 4274, i64 11538, i64 4275, i64 11539, i64 4276, i64 11540, i64 4277, i64 11541, i64 4278, i64 11542, i64 4279, i64 11543, i64 4280, i64 11544, i64 4281, i64 11545, i64 4282, i64 11546, i64 4283, i64 11547, i64 4284, i64 11548, i64 4285, i64 11549, i64 4286, i64 11550, i64 4287, i64 11551, i64 4288, i64 11552, i64 4289, i64 11553, i64 4290, i64 11554, i64 4291, i64 11555, i64 4292, i64 11556, i64 4293, i64 11557, i64 4295, i64 11559, i64 4301, i64 11565, i64 5024, i64 43888, i64 5025, i64 43889, i64 5026, i64 43890, i64 5027, i64 43891, i64 5028, i64 43892, i64 5029, i64 43893, i64 5030, i64 43894, i64 5031, i64 43895, i64 5032, i64 43896, i64 5033, i64 43897, i64 5034, i64 43898, i64 5035, i64 43899, i64 5036, i64 43900, i64 5037, i64 43901, i64 5038, i64 43902, i64 5039, i64 43903, i64 5040, i64 43904, i64 5041, i64 43905, i64 5042, i64 43906, i64 5043, i64 43907, i64 5044, i64 43908, i64 5045, i64 43909, i64 5046, i64 43910, i64 5047, i64 43911, i64 5048, i64 43912, i64 5049, i64 43913, i64 5050, i64 43914, i64 5051, i64 43915, i64 5052, i64 43916, i64 5053, i64 43917, i64 5054, i64 43918, i64 5055, i64 43919, i64 5056, i64 43920, i64 5057, i64 43921, i64 5058, i64 43922, i64 5059, i64 43923, i64 5060, i64 43924, i64 5061, i64 43925, i64 5062, i64 43926, i64 5063, i64 43927, i64 5064, i64 43928, i64 5065, i64 43929, i64 5066, i64 43930, i64 5067, i64 43931, i64 5068, i64 43932, i64 5069, i64 43933, i64 5070, i64 43934, i64 5071, i64 43935, i64 5072, i64 43936, i64 5073, i64 43937, i64 5074, i64 43938, i64 5075, i64 43939, i64 5076, i64 43940, i64 5077, i64 43941, i64 5078, i64 43942, i64 5079, i64 43943, i64 5080, i64 43944, i64 5081, i64 43945, i64 5082, i64 43946, i64 5083, i64 43947, i64 5084, i64 43948, i64 5085, i64 43949, i64 5086, i64 43950, i64 5087, i64 43951, i64 5088, i64 43952, i64 5089, i64 43953, i64 5090, i64 43954, i64 5091, i64 43955, i64 5092, i64 43956, i64 5093, i64 43957, i64 5094, i64 43958, i64 5095, i64 43959, i64 5096, i64 43960, i64 5097, i64 43961, i64 5098, i64 43962, i64 5099, i64 43963, i64 5100, i64 43964, i64 5101, i64 43965, i64 5102, i64 43966, i64 5103, i64 43967, i64 5104, i64 5112, i64 5105, i64 5113, i64 5106, i64 5114, i64 5107, i64 5115, i64 5108, i64 5116, i64 5109, i64 5117, i64 7305, i64 7306, i64 7312, i64 4304, i64 7313, i64 4305, i64 7314, i64 4306, i64 7315, i64 4307, i64 7316, i64 4308, i64 7317, i64 4309, i64 7318, i64 4310, i64 7319, i64 4311, i64 7320, i64 4312, i64 7321, i64 4313, i64 7322, i64 4314, i64 7323, i64 4315, i64 7324, i64 4316, i64 7325, i64 4317, i64 7326, i64 4318, i64 7327, i64 4319, i64 7328, i64 4320, i64 7329, i64 4321, i64 7330, i64 4322, i64 7331, i64 4323, i64 7332, i64 4324, i64 7333, i64 4325, i64 7334, i64 4326, i64 7335, i64 4327, i64 7336, i64 4328, i64 7337, i64 4329, i64 7338, i64 4330, i64 7339, i64 4331, i64 7340, i64 4332, i64 7341, i64 4333, i64 7342, i64 4334, i64 7343, i64 4335, i64 7344, i64 4336, i64 7345, i64 4337, i64 7346, i64 4338, i64 7347, i64 4339, i64 7348, i64 4340, i64 7349, i64 4341, i64 7350, i64 4342, i64 7351, i64 4343, i64 7352, i64 4344, i64 7353, i64 4345, i64 7354, i64 4346, i64 7357, i64 4349, i64 7358, i64 4350, i64 7359, i64 4351, i64 7680, i64 7681, i64 7682, i64 7683, i64 7684, i64 7685, i64 7686, i64 7687, i64 7688, i64 7689, i64 7690, i64 7691, i64 7692, i64 7693, i64 7694, i64 7695, i64 7696, i64 7697, i64 7698, i64 7699, i64 7700, i64 7701, i64 7702, i64 7703, i64 7704, i64 7705, i64 7706, i64 7707, i64 7708, i64 7709, i64 7710, i64 7711, i64 7712, i64 7713, i64 7714, i64 7715, i64 7716, i64 7717, i64 7718, i64 7719, i64 7720, i64 7721, i64 7722, i64 7723, i64 7724, i64 7725, i64 7726, i64 7727, i64 7728, i64 7729, i64 7730, i64 7731, i64 7732, i64 7733, i64 7734, i64 7735, i64 7736, i64 7737, i64 7738, i64 7739, i64 7740, i64 7741, i64 7742, i64 7743, i64 7744, i64 7745, i64 7746, i64 7747, i64 7748, i64 7749, i64 7750, i64 7751, i64 7752, i64 7753, i64 7754, i64 7755, i64 7756, i64 7757, i64 7758, i64 7759, i64 7760, i64 7761, i64 7762, i64 7763, i64 7764, i64 7765, i64 7766, i64 7767, i64 7768, i64 7769, i64 7770, i64 7771, i64 7772, i64 7773, i64 7774, i64 7775, i64 7776, i64 7777, i64 7778, i64 7779, i64 7780, i64 7781, i64 7782, i64 7783, i64 7784, i64 7785, i64 7786, i64 7787, i64 7788, i64 7789, i64 7790, i64 7791, i64 7792, i64 7793, i64 7794, i64 7795, i64 7796, i64 7797, i64 7798, i64 7799, i64 7800, i64 7801, i64 7802, i64 7803, i64 7804, i64 7805, i64 7806, i64 7807, i64 7808, i64 7809, i64 7810, i64 7811, i64 7812, i64 7813, i64 7814, i64 7815, i64 7816, i64 7817, i64 7818, i64 7819, i64 7820, i64 7821, i64 7822, i64 7823, i64 7824, i64 7825, i64 7826, i64 7827, i64 7828, i64 7829, i64 7838, i64 223, i64 7840, i64 7841, i64 7842, i64 7843, i64 7844, i64 7845, i64 7846, i64 7847, i64 7848, i64 7849, i64 7850, i64 7851, i64 7852, i64 7853, i64 7854, i64 7855, i64 7856, i64 7857, i64 7858, i64 7859, i64 7860, i64 7861, i64 7862, i64 7863, i64 7864, i64 7865, i64 7866, i64 7867, i64 7868, i64 7869, i64 7870, i64 7871, i64 7872, i64 7873, i64 7874, i64 7875, i64 7876, i64 7877, i64 7878, i64 7879, i64 7880, i64 7881, i64 7882, i64 7883, i64 7884, i64 7885, i64 7886, i64 7887, i64 7888, i64 7889, i64 7890, i64 7891, i64 7892, i64 7893, i64 7894, i64 7895, i64 7896, i64 7897, i64 7898, i64 7899, i64 7900, i64 7901, i64 7902, i64 7903, i64 7904, i64 7905, i64 7906, i64 7907, i64 7908, i64 7909, i64 7910, i64 7911, i64 7912, i64 7913, i64 7914, i64 7915, i64 7916, i64 7917, i64 7918, i64 7919, i64 7920, i64 7921, i64 7922, i64 7923, i64 7924, i64 7925, i64 7926, i64 7927, i64 7928, i64 7929, i64 7930, i64 7931, i64 7932, i64 7933, i64 7934, i64 7935, i64 7944, i64 7936, i64 7945, i64 7937, i64 7946, i64 7938, i64 7947, i64 7939, i64 7948, i64 7940, i64 7949, i64 7941, i64 7950, i64 7942, i64 7951, i64 7943, i64 7960, i64 7952, i64 7961, i64 7953, i64 7962, i64 7954, i64 7963, i64 7955, i64 7964, i64 7956, i64 7965, i64 7957, i64 7976, i64 7968, i64 7977, i64 7969, i64 7978, i64 7970, i64 7979, i64 7971, i64 7980, i64 7972, i64 7981, i64 7973, i64 7982, i64 7974, i64 7983, i64 7975, i64 7992, i64 7984, i64 7993, i64 7985, i64 7994, i64 7986, i64 7995, i64 7987, i64 7996, i64 7988, i64 7997, i64 7989, i64 7998, i64 7990, i64 7999, i64 7991, i64 8008, i64 8000, i64 8009, i64 8001, i64 8010, i64 8002, i64 8011, i64 8003, i64 8012, i64 8004, i64 8013, i64 8005, i64 8025, i64 8017, i64 8027, i64 8019, i64 8029, i64 8021, i64 8031, i64 8023, i64 8040, i64 8032, i64 8041, i64 8033, i64 8042, i64 8034, i64 8043, i64 8035, i64 8044, i64 8036, i64 8045, i64 8037, i64 8046, i64 8038, i64 8047, i64 8039, i64 8072, i64 8064, i64 8073, i64 8065, i64 8074, i64 8066, i64 8075, i64 8067, i64 8076, i64 8068, i64 8077, i64 8069, i64 8078, i64 8070, i64 8079, i64 8071, i64 8088, i64 8080, i64 8089, i64 8081, i64 8090, i64 8082, i64 8091, i64 8083, i64 8092, i64 8084, i64 8093, i64 8085, i64 8094, i64 8086, i64 8095, i64 8087, i64 8104, i64 8096, i64 8105, i64 8097, i64 8106, i64 8098, i64 8107, i64 8099, i64 8108, i64 8100, i64 8109, i64 8101, i64 8110, i64 8102, i64 8111, i64 8103, i64 8120, i64 8112, i64 8121, i64 8113, i64 8122, i64 8048, i64 8123, i64 8049, i64 8124, i64 8115, i64 8136, i64 8050, i64 8137, i64 8051, i64 8138, i64 8052, i64 8139, i64 8053, i64 8140, i64 8131, i64 8152, i64 8144, i64 8153, i64 8145, i64 8154, i64 8054, i64 8155, i64 8055, i64 8168, i64 8160, i64 8169, i64 8161, i64 8170, i64 8058, i64 8171, i64 8059, i64 8172, i64 8165, i64 8184, i64 8056, i64 8185, i64 8057, i64 8186, i64 8060, i64 8187, i64 8061, i64 8188, i64 8179, i64 8486, i64 969, i64 8490, i64 107, i64 8491, i64 229, i64 8498, i64 8526, i64 8544, i64 8560, i64 8545, i64 8561, i64 8546, i64 8562, i64 8547, i64 8563, i64 8548, i64 8564, i64 8549, i64 8565, i64 8550, i64 8566, i64 8551, i64 8567, i64 8552, i64 8568, i64 8553, i64 8569, i64 8554, i64 8570, i64 8555, i64 8571, i64 8556, i64 8572, i64 8557, i64 8573, i64 8558, i64 8574, i64 8559, i64 8575, i64 8579, i64 8580, i64 9398, i64 9424, i64 9399, i64 9425, i64 9400, i64 9426, i64 9401, i64 9427, i64 9402, i64 9428, i64 9403, i64 9429, i64 9404, i64 9430, i64 9405, i64 9431, i64 9406, i64 9432, i64 9407, i64 9433, i64 9408, i64 9434, i64 9409, i64 9435, i64 9410, i64 9436, i64 9411, i64 9437, i64 9412, i64 9438, i64 9413, i64 9439, i64 9414, i64 9440, i64 9415, i64 9441, i64 9416, i64 9442, i64 9417, i64 9443, i64 9418, i64 9444, i64 9419, i64 9445, i64 9420, i64 9446, i64 9421, i64 9447, i64 9422, i64 9448, i64 9423, i64 9449, i64 11264, i64 11312, i64 11265, i64 11313, i64 11266, i64 11314, i64 11267, i64 11315, i64 11268, i64 11316, i64 11269, i64 11317, i64 11270, i64 11318, i64 11271, i64 11319, i64 11272, i64 11320, i64 11273, i64 11321, i64 11274, i64 11322, i64 11275, i64 11323, i64 11276, i64 11324, i64 11277, i64 11325, i64 11278, i64 11326, i64 11279, i64 11327, i64 11280, i64 11328, i64 11281, i64 11329, i64 11282, i64 11330, i64 11283, i64 11331, i64 11284, i64 11332, i64 11285, i64 11333, i64 11286, i64 11334, i64 11287, i64 11335, i64 11288, i64 11336, i64 11289, i64 11337, i64 11290, i64 11338, i64 11291, i64 11339, i64 11292, i64 11340, i64 11293, i64 11341, i64 11294, i64 11342, i64 11295, i64 11343, i64 11296, i64 11344, i64 11297, i64 11345, i64 11298, i64 11346, i64 11299, i64 11347, i64 11300, i64 11348, i64 11301, i64 11349, i64 11302, i64 11350, i64 11303, i64 11351, i64 11304, i64 11352, i64 11305, i64 11353, i64 11306, i64 11354, i64 11307, i64 11355, i64 11308, i64 11356, i64 11309, i64 11357, i64 11310, i64 11358, i64 11311, i64 11359, i64 11360, i64 11361, i64 11362, i64 619, i64 11363, i64 7549, i64 11364, i64 637, i64 11367, i64 11368, i64 11369, i64 11370, i64 11371, i64 11372, i64 11373, i64 593, i64 11374, i64 625, i64 11375, i64 592, i64 11376, i64 594, i64 11378, i64 11379, i64 11381, i64 11382, i64 11390, i64 575, i64 11391, i64 576, i64 11392, i64 11393, i64 11394, i64 11395, i64 11396, i64 11397, i64 11398, i64 11399, i64 11400, i64 11401, i64 11402, i64 11403, i64 11404, i64 11405, i64 11406, i64 11407, i64 11408, i64 11409, i64 11410, i64 11411, i64 11412, i64 11413, i64 11414, i64 11415, i64 11416, i64 11417, i64 11418, i64 11419, i64 11420, i64 11421, i64 11422, i64 11423, i64 11424, i64 11425, i64 11426, i64 11427, i64 11428, i64 11429, i64 11430, i64 11431, i64 11432, i64 11433, i64 11434, i64 11435, i64 11436, i64 11437, i64 11438, i64 11439, i64 11440, i64 11441, i64 11442, i64 11443, i64 11444, i64 11445, i64 11446, i64 11447, i64 11448, i64 11449, i64 11450, i64 11451, i64 11452, i64 11453, i64 11454, i64 11455, i64 11456, i64 11457, i64 11458, i64 11459, i64 11460, i64 11461, i64 11462, i64 11463, i64 11464, i64 11465, i64 11466, i64 11467, i64 11468, i64 11469, i64 11470, i64 11471, i64 11472, i64 11473, i64 11474, i64 11475, i64 11476, i64 11477, i64 11478, i64 11479, i64 11480, i64 11481, i64 11482, i64 11483, i64 11484, i64 11485, i64 11486, i64 11487, i64 11488, i64 11489, i64 11490, i64 11491, i64 11499, i64 11500, i64 11501, i64 11502, i64 11506, i64 11507, i64 42560, i64 42561, i64 42562, i64 42563, i64 42564, i64 42565, i64 42566, i64 42567, i64 42568, i64 42569, i64 42570, i64 42571, i64 42572, i64 42573, i64 42574, i64 42575, i64 42576, i64 42577, i64 42578, i64 42579, i64 42580, i64 42581, i64 42582, i64 42583, i64 42584, i64 42585, i64 42586, i64 42587, i64 42588, i64 42589, i64 42590, i64 42591, i64 42592, i64 42593, i64 42594, i64 42595, i64 42596, i64 42597, i64 42598, i64 42599, i64 42600, i64 42601, i64 42602, i64 42603, i64 42604, i64 42605, i64 42624, i64 42625, i64 42626, i64 42627, i64 42628, i64 42629, i64 42630, i64 42631, i64 42632, i64 42633, i64 42634, i64 42635, i64 42636, i64 42637, i64 42638, i64 42639, i64 42640, i64 42641, i64 42642, i64 42643, i64 42644, i64 42645, i64 42646, i64 42647, i64 42648, i64 42649, i64 42650, i64 42651, i64 42786, i64 42787, i64 42788, i64 42789, i64 42790, i64 42791, i64 42792, i64 42793, i64 42794, i64 42795, i64 42796, i64 42797, i64 42798, i64 42799, i64 42802, i64 42803, i64 42804, i64 42805, i64 42806, i64 42807, i64 42808, i64 42809, i64 42810, i64 42811, i64 42812, i64 42813, i64 42814, i64 42815, i64 42816, i64 42817, i64 42818, i64 42819, i64 42820, i64 42821, i64 42822, i64 42823, i64 42824, i64 42825, i64 42826, i64 42827, i64 42828, i64 42829, i64 42830, i64 42831, i64 42832, i64 42833, i64 42834, i64 42835, i64 42836, i64 42837, i64 42838, i64 42839, i64 42840, i64 42841, i64 42842, i64 42843, i64 42844, i64 42845, i64 42846, i64 42847, i64 42848, i64 42849, i64 42850, i64 42851, i64 42852, i64 42853, i64 42854, i64 42855, i64 42856, i64 42857, i64 42858, i64 42859, i64 42860, i64 42861, i64 42862, i64 42863, i64 42873, i64 42874, i64 42875, i64 42876, i64 42877, i64 7545, i64 42878, i64 42879, i64 42880, i64 42881, i64 42882, i64 42883, i64 42884, i64 42885, i64 42886, i64 42887, i64 42891, i64 42892, i64 42893, i64 613, i64 42896, i64 42897, i64 42898, i64 42899, i64 42902, i64 42903, i64 42904, i64 42905, i64 42906, i64 42907, i64 42908, i64 42909, i64 42910, i64 42911, i64 42912, i64 42913, i64 42914, i64 42915, i64 42916, i64 42917, i64 42918, i64 42919, i64 42920, i64 42921, i64 42922, i64 614, i64 42923, i64 604, i64 42924, i64 609, i64 42925, i64 620, i64 42926, i64 618, i64 42928, i64 670, i64 42929, i64 647, i64 42930, i64 669, i64 42931, i64 43859, i64 42932, i64 42933, i64 42934, i64 42935, i64 42936, i64 42937, i64 42938, i64 42939, i64 42940, i64 42941, i64 42942, i64 42943, i64 42944, i64 42945, i64 42946, i64 42947, i64 42948, i64 42900, i64 42949, i64 642, i64 42950, i64 7566, i64 42951, i64 42952, i64 42953, i64 42954, i64 42955, i64 612, i64 42956, i64 42957, i64 42960, i64 42961, i64 42966, i64 42967, i64 42968, i64 42969, i64 42970, i64 42971, i64 42972, i64 411, i64 42997, i64 42998, i64 65313, i64 65345, i64 65314, i64 65346, i64 65315, i64 65347, i64 65316, i64 65348, i64 65317, i64 65349, i64 65318, i64 65350, i64 65319, i64 65351, i64 65320, i64 65352, i64 65321, i64 65353, i64 65322, i64 65354, i64 65323, i64 65355, i64 65324, i64 65356, i64 65325, i64 65357, i64 65326, i64 65358, i64 65327, i64 65359, i64 65328, i64 65360, i64 65329, i64 65361, i64 65330, i64 65362, i64 65331, i64 65363, i64 65332, i64 65364, i64 65333, i64 65365, i64 65334, i64 65366, i64 65335, i64 65367, i64 65336, i64 65368, i64 65337, i64 65369, i64 65338, i64 65370, i64 66560, i64 66600, i64 66561, i64 66601, i64 66562, i64 66602, i64 66563, i64 66603, i64 66564, i64 66604, i64 66565, i64 66605, i64 66566, i64 66606, i64 66567, i64 66607, i64 66568, i64 66608, i64 66569, i64 66609, i64 66570, i64 66610, i64 66571, i64 66611, i64 66572, i64 66612, i64 66573, i64 66613, i64 66574, i64 66614, i64 66575, i64 66615, i64 66576, i64 66616, i64 66577, i64 66617, i64 66578, i64 66618, i64 66579, i64 66619, i64 66580, i64 66620, i64 66581, i64 66621, i64 66582, i64 66622, i64 66583, i64 66623, i64 66584, i64 66624, i64 66585, i64 66625, i64 66586, i64 66626, i64 66587, i64 66627, i64 66588, i64 66628, i64 66589, i64 66629, i64 66590, i64 66630, i64 66591, i64 66631, i64 66592, i64 66632, i64 66593, i64 66633, i64 66594, i64 66634, i64 66595, i64 66635, i64 66596, i64 66636, i64 66597, i64 66637, i64 66598, i64 66638, i64 66599, i64 66639, i64 66736, i64 66776, i64 66737, i64 66777, i64 66738, i64 66778, i64 66739, i64 66779, i64 66740, i64 66780, i64 66741, i64 66781, i64 66742, i64 66782, i64 66743, i64 66783, i64 66744, i64 66784, i64 66745, i64 66785, i64 66746, i64 66786, i64 66747, i64 66787, i64 66748, i64 66788, i64 66749, i64 66789, i64 66750, i64 66790, i64 66751, i64 66791, i64 66752, i64 66792, i64 66753, i64 66793, i64 66754, i64 66794, i64 66755, i64 66795, i64 66756, i64 66796, i64 66757, i64 66797, i64 66758, i64 66798, i64 66759, i64 66799, i64 66760, i64 66800, i64 66761, i64 66801, i64 66762, i64 66802, i64 66763, i64 66803, i64 66764, i64 66804, i64 66765, i64 66805, i64 66766, i64 66806, i64 66767, i64 66807, i64 66768, i64 66808, i64 66769, i64 66809, i64 66770, i64 66810, i64 66771, i64 66811, i64 66928, i64 66967, i64 66929, i64 66968, i64 66930, i64 66969, i64 66931, i64 66970, i64 66932, i64 66971, i64 66933, i64 66972, i64 66934, i64 66973, i64 66935, i64 66974, i64 66936, i64 66975, i64 66937, i64 66976, i64 66938, i64 66977, i64 66940, i64 66979, i64 66941, i64 66980, i64 66942, i64 66981, i64 66943, i64 66982, i64 66944, i64 66983, i64 66945, i64 66984, i64 66946, i64 66985, i64 66947, i64 66986, i64 66948, i64 66987, i64 66949, i64 66988, i64 66950, i64 66989, i64 66951, i64 66990, i64 66952, i64 66991, i64 66953, i64 66992, i64 66954, i64 66993, i64 66956, i64 66995, i64 66957, i64 66996, i64 66958, i64 66997, i64 66959, i64 66998, i64 66960, i64 66999, i64 66961, i64 67000, i64 66962, i64 67001, i64 66964, i64 67003, i64 66965, i64 67004, i64 68736, i64 68800, i64 68737, i64 68801, i64 68738, i64 68802, i64 68739, i64 68803, i64 68740, i64 68804, i64 68741, i64 68805, i64 68742, i64 68806, i64 68743, i64 68807, i64 68744, i64 68808, i64 68745, i64 68809, i64 68746, i64 68810, i64 68747, i64 68811, i64 68748, i64 68812, i64 68749, i64 68813, i64 68750, i64 68814, i64 68751, i64 68815, i64 68752, i64 68816, i64 68753, i64 68817, i64 68754, i64 68818, i64 68755, i64 68819, i64 68756, i64 68820, i64 68757, i64 68821, i64 68758, i64 68822, i64 68759, i64 68823, i64 68760, i64 68824, i64 68761, i64 68825, i64 68762, i64 68826, i64 68763, i64 68827, i64 68764, i64 68828, i64 68765, i64 68829, i64 68766, i64 68830, i64 68767, i64 68831, i64 68768, i64 68832, i64 68769, i64 68833, i64 68770, i64 68834, i64 68771, i64 68835, i64 68772, i64 68836, i64 68773, i64 68837, i64 68774, i64 68838, i64 68775, i64 68839, i64 68776, i64 68840, i64 68777, i64 68841, i64 68778, i64 68842, i64 68779, i64 68843, i64 68780, i64 68844, i64 68781, i64 68845, i64 68782, i64 68846, i64 68783, i64 68847, i64 68784, i64 68848, i64 68785, i64 68849, i64 68786, i64 68850, i64 68944, i64 68976, i64 68945, i64 68977, i64 68946, i64 68978, i64 68947, i64 68979, i64 68948, i64 68980, i64 68949, i64 68981, i64 68950, i64 68982, i64 68951, i64 68983, i64 68952, i64 68984, i64 68953, i64 68985, i64 68954, i64 68986, i64 68955, i64 68987, i64 68956, i64 68988, i64 68957, i64 68989, i64 68958, i64 68990, i64 68959, i64 68991, i64 68960, i64 68992, i64 68961, i64 68993, i64 68962, i64 68994, i64 68963, i64 68995, i64 68964, i64 68996, i64 68965, i64 68997, i64 71840, i64 71872, i64 71841, i64 71873, i64 71842, i64 71874, i64 71843, i64 71875, i64 71844, i64 71876, i64 71845, i64 71877, i64 71846, i64 71878, i64 71847, i64 71879, i64 71848, i64 71880, i64 71849, i64 71881, i64 71850, i64 71882, i64 71851, i64 71883, i64 71852, i64 71884, i64 71853, i64 71885, i64 71854, i64 71886, i64 71855, i64 71887, i64 71856, i64 71888, i64 71857, i64 71889, i64 71858, i64 71890, i64 71859, i64 71891, i64 71860, i64 71892, i64 71861, i64 71893, i64 71862, i64 71894, i64 71863, i64 71895, i64 71864, i64 71896, i64 71865, i64 71897, i64 71866, i64 71898, i64 71867, i64 71899, i64 71868, i64 71900, i64 71869, i64 71901, i64 71870, i64 71902, i64 71871, i64 71903, i64 93760, i64 93792, i64 93761, i64 93793, i64 93762, i64 93794, i64 93763, i64 93795, i64 93764, i64 93796, i64 93765, i64 93797, i64 93766, i64 93798, i64 93767, i64 93799, i64 93768, i64 93800, i64 93769, i64 93801, i64 93770, i64 93802, i64 93771, i64 93803, i64 93772, i64 93804, i64 93773, i64 93805, i64 93774, i64 93806, i64 93775, i64 93807, i64 93776, i64 93808, i64 93777, i64 93809, i64 93778, i64 93810, i64 93779, i64 93811, i64 93780, i64 93812, i64 93781, i64 93813, i64 93782, i64 93814, i64 93783, i64 93815, i64 93784, i64 93816, i64 93785, i64 93817, i64 93786, i64 93818, i64 93787, i64 93819, i64 93788, i64 93820, i64 93789, i64 93821, i64 93790, i64 93822, i64 93791, i64 93823, i64 125184, i64 125218, i64 125185, i64 125219, i64 125186, i64 125220, i64 125187, i64 125221, i64 125188, i64 125222, i64 125189, i64 125223, i64 125190, i64 125224, i64 125191, i64 125225, i64 125192, i64 125226, i64 125193, i64 125227, i64 125194, i64 125228, i64 125195, i64 125229, i64 125196, i64 125230, i64 125197, i64 125231, i64 125198, i64 125232, i64 125199, i64 125233, i64 125200, i64 125234, i64 125201, i64 125235, i64 125202, i64 125236, i64 125203, i64 125237, i64 125204, i64 125238, i64 125205, i64 125239, i64 125206, i64 125240, i64 125207, i64 125241, i64 125208, i64 125242, i64 125209, i64 125243, i64 125210, i64 125244, i64 125211, i64 125245, i64 125212, i64 125246, i64 125213, i64 125247, i64 125214, i64 125248, i64 125215, i64 125249, i64 125216, i64 125250, i64 125217, i64 125251], align 16
@rtt.11265 = private unnamed_addr constant [2900 x i64] [i64 97, i64 65, i64 98, i64 66, i64 99, i64 67, i64 100, i64 68, i64 101, i64 69, i64 102, i64 70, i64 103, i64 71, i64 104, i64 72, i64 105, i64 73, i64 106, i64 74, i64 107, i64 75, i64 108, i64 76, i64 109, i64 77, i64 110, i64 78, i64 111, i64 79, i64 112, i64 80, i64 113, i64 81, i64 114, i64 82, i64 115, i64 83, i64 116, i64 84, i64 117, i64 85, i64 118, i64 86, i64 119, i64 87, i64 120, i64 88, i64 121, i64 89, i64 122, i64 90, i64 181, i64 924, i64 224, i64 192, i64 225, i64 193, i64 226, i64 194, i64 227, i64 195, i64 228, i64 196, i64 229, i64 197, i64 230, i64 198, i64 231, i64 199, i64 232, i64 200, i64 233, i64 201, i64 234, i64 202, i64 235, i64 203, i64 236, i64 204, i64 237, i64 205, i64 238, i64 206, i64 239, i64 207, i64 240, i64 208, i64 241, i64 209, i64 242, i64 210, i64 243, i64 211, i64 244, i64 212, i64 245, i64 213, i64 246, i64 214, i64 248, i64 216, i64 249, i64 217, i64 250, i64 218, i64 251, i64 219, i64 252, i64 220, i64 253, i64 221, i64 254, i64 222, i64 255, i64 376, i64 257, i64 256, i64 259, i64 258, i64 261, i64 260, i64 263, i64 262, i64 265, i64 264, i64 267, i64 266, i64 269, i64 268, i64 271, i64 270, i64 273, i64 272, i64 275, i64 274, i64 277, i64 276, i64 279, i64 278, i64 281, i64 280, i64 283, i64 282, i64 285, i64 284, i64 287, i64 286, i64 289, i64 288, i64 291, i64 290, i64 293, i64 292, i64 295, i64 294, i64 297, i64 296, i64 299, i64 298, i64 301, i64 300, i64 303, i64 302, i64 305, i64 73, i64 307, i64 306, i64 309, i64 308, i64 311, i64 310, i64 314, i64 313, i64 316, i64 315, i64 318, i64 317, i64 320, i64 319, i64 322, i64 321, i64 324, i64 323, i64 326, i64 325, i64 328, i64 327, i64 331, i64 330, i64 333, i64 332, i64 335, i64 334, i64 337, i64 336, i64 339, i64 338, i64 341, i64 340, i64 343, i64 342, i64 345, i64 344, i64 347, i64 346, i64 349, i64 348, i64 351, i64 350, i64 353, i64 352, i64 355, i64 354, i64 357, i64 356, i64 359, i64 358, i64 361, i64 360, i64 363, i64 362, i64 365, i64 364, i64 367, i64 366, i64 369, i64 368, i64 371, i64 370, i64 373, i64 372, i64 375, i64 374, i64 378, i64 377, i64 380, i64 379, i64 382, i64 381, i64 383, i64 83, i64 384, i64 579, i64 387, i64 386, i64 389, i64 388, i64 392, i64 391, i64 396, i64 395, i64 402, i64 401, i64 405, i64 502, i64 409, i64 408, i64 410, i64 573, i64 411, i64 42972, i64 414, i64 544, i64 417, i64 416, i64 419, i64 418, i64 421, i64 420, i64 424, i64 423, i64 429, i64 428, i64 432, i64 431, i64 436, i64 435, i64 438, i64 437, i64 441, i64 440, i64 445, i64 444, i64 447, i64 503, i64 453, i64 452, i64 454, i64 452, i64 456, i64 455, i64 457, i64 455, i64 459, i64 458, i64 460, i64 458, i64 462, i64 461, i64 464, i64 463, i64 466, i64 465, i64 468, i64 467, i64 470, i64 469, i64 472, i64 471, i64 474, i64 473, i64 476, i64 475, i64 477, i64 398, i64 479, i64 478, i64 481, i64 480, i64 483, i64 482, i64 485, i64 484, i64 487, i64 486, i64 489, i64 488, i64 491, i64 490, i64 493, i64 492, i64 495, i64 494, i64 498, i64 497, i64 499, i64 497, i64 501, i64 500, i64 505, i64 504, i64 507, i64 506, i64 509, i64 508, i64 511, i64 510, i64 513, i64 512, i64 515, i64 514, i64 517, i64 516, i64 519, i64 518, i64 521, i64 520, i64 523, i64 522, i64 525, i64 524, i64 527, i64 526, i64 529, i64 528, i64 531, i64 530, i64 533, i64 532, i64 535, i64 534, i64 537, i64 536, i64 539, i64 538, i64 541, i64 540, i64 543, i64 542, i64 547, i64 546, i64 549, i64 548, i64 551, i64 550, i64 553, i64 552, i64 555, i64 554, i64 557, i64 556, i64 559, i64 558, i64 561, i64 560, i64 563, i64 562, i64 572, i64 571, i64 575, i64 11390, i64 576, i64 11391, i64 578, i64 577, i64 583, i64 582, i64 585, i64 584, i64 587, i64 586, i64 589, i64 588, i64 591, i64 590, i64 592, i64 11375, i64 593, i64 11373, i64 594, i64 11376, i64 595, i64 385, i64 596, i64 390, i64 598, i64 393, i64 599, i64 394, i64 601, i64 399, i64 603, i64 400, i64 604, i64 42923, i64 608, i64 403, i64 609, i64 42924, i64 611, i64 404, i64 612, i64 42955, i64 613, i64 42893, i64 614, i64 42922, i64 616, i64 407, i64 617, i64 406, i64 618, i64 42926, i64 619, i64 11362, i64 620, i64 42925, i64 623, i64 412, i64 625, i64 11374, i64 626, i64 413, i64 629, i64 415, i64 637, i64 11364, i64 640, i64 422, i64 642, i64 42949, i64 643, i64 425, i64 647, i64 42929, i64 648, i64 430, i64 649, i64 580, i64 650, i64 433, i64 651, i64 434, i64 652, i64 581, i64 658, i64 439, i64 669, i64 42930, i64 670, i64 42928, i64 837, i64 921, i64 881, i64 880, i64 883, i64 882, i64 887, i64 886, i64 891, i64 1021, i64 892, i64 1022, i64 893, i64 1023, i64 940, i64 902, i64 941, i64 904, i64 942, i64 905, i64 943, i64 906, i64 945, i64 913, i64 946, i64 914, i64 947, i64 915, i64 948, i64 916, i64 949, i64 917, i64 950, i64 918, i64 951, i64 919, i64 952, i64 920, i64 953, i64 921, i64 954, i64 922, i64 955, i64 923, i64 956, i64 924, i64 957, i64 925, i64 958, i64 926, i64 959, i64 927, i64 960, i64 928, i64 961, i64 929, i64 962, i64 931, i64 963, i64 931, i64 964, i64 932, i64 965, i64 933, i64 966, i64 934, i64 967, i64 935, i64 968, i64 936, i64 969, i64 937, i64 970, i64 938, i64 971, i64 939, i64 972, i64 908, i64 973, i64 910, i64 974, i64 911, i64 976, i64 914, i64 977, i64 920, i64 981, i64 934, i64 982, i64 928, i64 983, i64 975, i64 985, i64 984, i64 987, i64 986, i64 989, i64 988, i64 991, i64 990, i64 993, i64 992, i64 995, i64 994, i64 997, i64 996, i64 999, i64 998, i64 1001, i64 1000, i64 1003, i64 1002, i64 1005, i64 1004, i64 1007, i64 1006, i64 1008, i64 922, i64 1009, i64 929, i64 1010, i64 1017, i64 1011, i64 895, i64 1013, i64 917, i64 1016, i64 1015, i64 1019, i64 1018, i64 1072, i64 1040, i64 1073, i64 1041, i64 1074, i64 1042, i64 1075, i64 1043, i64 1076, i64 1044, i64 1077, i64 1045, i64 1078, i64 1046, i64 1079, i64 1047, i64 1080, i64 1048, i64 1081, i64 1049, i64 1082, i64 1050, i64 1083, i64 1051, i64 1084, i64 1052, i64 1085, i64 1053, i64 1086, i64 1054, i64 1087, i64 1055, i64 1088, i64 1056, i64 1089, i64 1057, i64 1090, i64 1058, i64 1091, i64 1059, i64 1092, i64 1060, i64 1093, i64 1061, i64 1094, i64 1062, i64 1095, i64 1063, i64 1096, i64 1064, i64 1097, i64 1065, i64 1098, i64 1066, i64 1099, i64 1067, i64 1100, i64 1068, i64 1101, i64 1069, i64 1102, i64 1070, i64 1103, i64 1071, i64 1104, i64 1024, i64 1105, i64 1025, i64 1106, i64 1026, i64 1107, i64 1027, i64 1108, i64 1028, i64 1109, i64 1029, i64 1110, i64 1030, i64 1111, i64 1031, i64 1112, i64 1032, i64 1113, i64 1033, i64 1114, i64 1034, i64 1115, i64 1035, i64 1116, i64 1036, i64 1117, i64 1037, i64 1118, i64 1038, i64 1119, i64 1039, i64 1121, i64 1120, i64 1123, i64 1122, i64 1125, i64 1124, i64 1127, i64 1126, i64 1129, i64 1128, i64 1131, i64 1130, i64 1133, i64 1132, i64 1135, i64 1134, i64 1137, i64 1136, i64 1139, i64 1138, i64 1141, i64 1140, i64 1143, i64 1142, i64 1145, i64 1144, i64 1147, i64 1146, i64 1149, i64 1148, i64 1151, i64 1150, i64 1153, i64 1152, i64 1163, i64 1162, i64 1165, i64 1164, i64 1167, i64 1166, i64 1169, i64 1168, i64 1171, i64 1170, i64 1173, i64 1172, i64 1175, i64 1174, i64 1177, i64 1176, i64 1179, i64 1178, i64 1181, i64 1180, i64 1183, i64 1182, i64 1185, i64 1184, i64 1187, i64 1186, i64 1189, i64 1188, i64 1191, i64 1190, i64 1193, i64 1192, i64 1195, i64 1194, i64 1197, i64 1196, i64 1199, i64 1198, i64 1201, i64 1200, i64 1203, i64 1202, i64 1205, i64 1204, i64 1207, i64 1206, i64 1209, i64 1208, i64 1211, i64 1210, i64 1213, i64 1212, i64 1215, i64 1214, i64 1218, i64 1217, i64 1220, i64 1219, i64 1222, i64 1221, i64 1224, i64 1223, i64 1226, i64 1225, i64 1228, i64 1227, i64 1230, i64 1229, i64 1231, i64 1216, i64 1233, i64 1232, i64 1235, i64 1234, i64 1237, i64 1236, i64 1239, i64 1238, i64 1241, i64 1240, i64 1243, i64 1242, i64 1245, i64 1244, i64 1247, i64 1246, i64 1249, i64 1248, i64 1251, i64 1250, i64 1253, i64 1252, i64 1255, i64 1254, i64 1257, i64 1256, i64 1259, i64 1258, i64 1261, i64 1260, i64 1263, i64 1262, i64 1265, i64 1264, i64 1267, i64 1266, i64 1269, i64 1268, i64 1271, i64 1270, i64 1273, i64 1272, i64 1275, i64 1274, i64 1277, i64 1276, i64 1279, i64 1278, i64 1281, i64 1280, i64 1283, i64 1282, i64 1285, i64 1284, i64 1287, i64 1286, i64 1289, i64 1288, i64 1291, i64 1290, i64 1293, i64 1292, i64 1295, i64 1294, i64 1297, i64 1296, i64 1299, i64 1298, i64 1301, i64 1300, i64 1303, i64 1302, i64 1305, i64 1304, i64 1307, i64 1306, i64 1309, i64 1308, i64 1311, i64 1310, i64 1313, i64 1312, i64 1315, i64 1314, i64 1317, i64 1316, i64 1319, i64 1318, i64 1321, i64 1320, i64 1323, i64 1322, i64 1325, i64 1324, i64 1327, i64 1326, i64 1377, i64 1329, i64 1378, i64 1330, i64 1379, i64 1331, i64 1380, i64 1332, i64 1381, i64 1333, i64 1382, i64 1334, i64 1383, i64 1335, i64 1384, i64 1336, i64 1385, i64 1337, i64 1386, i64 1338, i64 1387, i64 1339, i64 1388, i64 1340, i64 1389, i64 1341, i64 1390, i64 1342, i64 1391, i64 1343, i64 1392, i64 1344, i64 1393, i64 1345, i64 1394, i64 1346, i64 1395, i64 1347, i64 1396, i64 1348, i64 1397, i64 1349, i64 1398, i64 1350, i64 1399, i64 1351, i64 1400, i64 1352, i64 1401, i64 1353, i64 1402, i64 1354, i64 1403, i64 1355, i64 1404, i64 1356, i64 1405, i64 1357, i64 1406, i64 1358, i64 1407, i64 1359, i64 1408, i64 1360, i64 1409, i64 1361, i64 1410, i64 1362, i64 1411, i64 1363, i64 1412, i64 1364, i64 1413, i64 1365, i64 1414, i64 1366, i64 4304, i64 7312, i64 4305, i64 7313, i64 4306, i64 7314, i64 4307, i64 7315, i64 4308, i64 7316, i64 4309, i64 7317, i64 4310, i64 7318, i64 4311, i64 7319, i64 4312, i64 7320, i64 4313, i64 7321, i64 4314, i64 7322, i64 4315, i64 7323, i64 4316, i64 7324, i64 4317, i64 7325, i64 4318, i64 7326, i64 4319, i64 7327, i64 4320, i64 7328, i64 4321, i64 7329, i64 4322, i64 7330, i64 4323, i64 7331, i64 4324, i64 7332, i64 4325, i64 7333, i64 4326, i64 7334, i64 4327, i64 7335, i64 4328, i64 7336, i64 4329, i64 7337, i64 4330, i64 7338, i64 4331, i64 7339, i64 4332, i64 7340, i64 4333, i64 7341, i64 4334, i64 7342, i64 4335, i64 7343, i64 4336, i64 7344, i64 4337, i64 7345, i64 4338, i64 7346, i64 4339, i64 7347, i64 4340, i64 7348, i64 4341, i64 7349, i64 4342, i64 7350, i64 4343, i64 7351, i64 4344, i64 7352, i64 4345, i64 7353, i64 4346, i64 7354, i64 4349, i64 7357, i64 4350, i64 7358, i64 4351, i64 7359, i64 5112, i64 5104, i64 5113, i64 5105, i64 5114, i64 5106, i64 5115, i64 5107, i64 5116, i64 5108, i64 5117, i64 5109, i64 7296, i64 1042, i64 7297, i64 1044, i64 7298, i64 1054, i64 7299, i64 1057, i64 7300, i64 1058, i64 7301, i64 1058, i64 7302, i64 1066, i64 7303, i64 1122, i64 7304, i64 42570, i64 7306, i64 7305, i64 7545, i64 42877, i64 7549, i64 11363, i64 7566, i64 42950, i64 7681, i64 7680, i64 7683, i64 7682, i64 7685, i64 7684, i64 7687, i64 7686, i64 7689, i64 7688, i64 7691, i64 7690, i64 7693, i64 7692, i64 7695, i64 7694, i64 7697, i64 7696, i64 7699, i64 7698, i64 7701, i64 7700, i64 7703, i64 7702, i64 7705, i64 7704, i64 7707, i64 7706, i64 7709, i64 7708, i64 7711, i64 7710, i64 7713, i64 7712, i64 7715, i64 7714, i64 7717, i64 7716, i64 7719, i64 7718, i64 7721, i64 7720, i64 7723, i64 7722, i64 7725, i64 7724, i64 7727, i64 7726, i64 7729, i64 7728, i64 7731, i64 7730, i64 7733, i64 7732, i64 7735, i64 7734, i64 7737, i64 7736, i64 7739, i64 7738, i64 7741, i64 7740, i64 7743, i64 7742, i64 7745, i64 7744, i64 7747, i64 7746, i64 7749, i64 7748, i64 7751, i64 7750, i64 7753, i64 7752, i64 7755, i64 7754, i64 7757, i64 7756, i64 7759, i64 7758, i64 7761, i64 7760, i64 7763, i64 7762, i64 7765, i64 7764, i64 7767, i64 7766, i64 7769, i64 7768, i64 7771, i64 7770, i64 7773, i64 7772, i64 7775, i64 7774, i64 7777, i64 7776, i64 7779, i64 7778, i64 7781, i64 7780, i64 7783, i64 7782, i64 7785, i64 7784, i64 7787, i64 7786, i64 7789, i64 7788, i64 7791, i64 7790, i64 7793, i64 7792, i64 7795, i64 7794, i64 7797, i64 7796, i64 7799, i64 7798, i64 7801, i64 7800, i64 7803, i64 7802, i64 7805, i64 7804, i64 7807, i64 7806, i64 7809, i64 7808, i64 7811, i64 7810, i64 7813, i64 7812, i64 7815, i64 7814, i64 7817, i64 7816, i64 7819, i64 7818, i64 7821, i64 7820, i64 7823, i64 7822, i64 7825, i64 7824, i64 7827, i64 7826, i64 7829, i64 7828, i64 7835, i64 7776, i64 7841, i64 7840, i64 7843, i64 7842, i64 7845, i64 7844, i64 7847, i64 7846, i64 7849, i64 7848, i64 7851, i64 7850, i64 7853, i64 7852, i64 7855, i64 7854, i64 7857, i64 7856, i64 7859, i64 7858, i64 7861, i64 7860, i64 7863, i64 7862, i64 7865, i64 7864, i64 7867, i64 7866, i64 7869, i64 7868, i64 7871, i64 7870, i64 7873, i64 7872, i64 7875, i64 7874, i64 7877, i64 7876, i64 7879, i64 7878, i64 7881, i64 7880, i64 7883, i64 7882, i64 7885, i64 7884, i64 7887, i64 7886, i64 7889, i64 7888, i64 7891, i64 7890, i64 7893, i64 7892, i64 7895, i64 7894, i64 7897, i64 7896, i64 7899, i64 7898, i64 7901, i64 7900, i64 7903, i64 7902, i64 7905, i64 7904, i64 7907, i64 7906, i64 7909, i64 7908, i64 7911, i64 7910, i64 7913, i64 7912, i64 7915, i64 7914, i64 7917, i64 7916, i64 7919, i64 7918, i64 7921, i64 7920, i64 7923, i64 7922, i64 7925, i64 7924, i64 7927, i64 7926, i64 7929, i64 7928, i64 7931, i64 7930, i64 7933, i64 7932, i64 7935, i64 7934, i64 7936, i64 7944, i64 7937, i64 7945, i64 7938, i64 7946, i64 7939, i64 7947, i64 7940, i64 7948, i64 7941, i64 7949, i64 7942, i64 7950, i64 7943, i64 7951, i64 7952, i64 7960, i64 7953, i64 7961, i64 7954, i64 7962, i64 7955, i64 7963, i64 7956, i64 7964, i64 7957, i64 7965, i64 7968, i64 7976, i64 7969, i64 7977, i64 7970, i64 7978, i64 7971, i64 7979, i64 7972, i64 7980, i64 7973, i64 7981, i64 7974, i64 7982, i64 7975, i64 7983, i64 7984, i64 7992, i64 7985, i64 7993, i64 7986, i64 7994, i64 7987, i64 7995, i64 7988, i64 7996, i64 7989, i64 7997, i64 7990, i64 7998, i64 7991, i64 7999, i64 8000, i64 8008, i64 8001, i64 8009, i64 8002, i64 8010, i64 8003, i64 8011, i64 8004, i64 8012, i64 8005, i64 8013, i64 8017, i64 8025, i64 8019, i64 8027, i64 8021, i64 8029, i64 8023, i64 8031, i64 8032, i64 8040, i64 8033, i64 8041, i64 8034, i64 8042, i64 8035, i64 8043, i64 8036, i64 8044, i64 8037, i64 8045, i64 8038, i64 8046, i64 8039, i64 8047, i64 8048, i64 8122, i64 8049, i64 8123, i64 8050, i64 8136, i64 8051, i64 8137, i64 8052, i64 8138, i64 8053, i64 8139, i64 8054, i64 8154, i64 8055, i64 8155, i64 8056, i64 8184, i64 8057, i64 8185, i64 8058, i64 8170, i64 8059, i64 8171, i64 8060, i64 8186, i64 8061, i64 8187, i64 8112, i64 8120, i64 8113, i64 8121, i64 8126, i64 921, i64 8144, i64 8152, i64 8145, i64 8153, i64 8160, i64 8168, i64 8161, i64 8169, i64 8165, i64 8172, i64 8526, i64 8498, i64 8560, i64 8544, i64 8561, i64 8545, i64 8562, i64 8546, i64 8563, i64 8547, i64 8564, i64 8548, i64 8565, i64 8549, i64 8566, i64 8550, i64 8567, i64 8551, i64 8568, i64 8552, i64 8569, i64 8553, i64 8570, i64 8554, i64 8571, i64 8555, i64 8572, i64 8556, i64 8573, i64 8557, i64 8574, i64 8558, i64 8575, i64 8559, i64 8580, i64 8579, i64 9424, i64 9398, i64 9425, i64 9399, i64 9426, i64 9400, i64 9427, i64 9401, i64 9428, i64 9402, i64 9429, i64 9403, i64 9430, i64 9404, i64 9431, i64 9405, i64 9432, i64 9406, i64 9433, i64 9407, i64 9434, i64 9408, i64 9435, i64 9409, i64 9436, i64 9410, i64 9437, i64 9411, i64 9438, i64 9412, i64 9439, i64 9413, i64 9440, i64 9414, i64 9441, i64 9415, i64 9442, i64 9416, i64 9443, i64 9417, i64 9444, i64 9418, i64 9445, i64 9419, i64 9446, i64 9420, i64 9447, i64 9421, i64 9448, i64 9422, i64 9449, i64 9423, i64 11312, i64 11264, i64 11313, i64 11265, i64 11314, i64 11266, i64 11315, i64 11267, i64 11316, i64 11268, i64 11317, i64 11269, i64 11318, i64 11270, i64 11319, i64 11271, i64 11320, i64 11272, i64 11321, i64 11273, i64 11322, i64 11274, i64 11323, i64 11275, i64 11324, i64 11276, i64 11325, i64 11277, i64 11326, i64 11278, i64 11327, i64 11279, i64 11328, i64 11280, i64 11329, i64 11281, i64 11330, i64 11282, i64 11331, i64 11283, i64 11332, i64 11284, i64 11333, i64 11285, i64 11334, i64 11286, i64 11335, i64 11287, i64 11336, i64 11288, i64 11337, i64 11289, i64 11338, i64 11290, i64 11339, i64 11291, i64 11340, i64 11292, i64 11341, i64 11293, i64 11342, i64 11294, i64 11343, i64 11295, i64 11344, i64 11296, i64 11345, i64 11297, i64 11346, i64 11298, i64 11347, i64 11299, i64 11348, i64 11300, i64 11349, i64 11301, i64 11350, i64 11302, i64 11351, i64 11303, i64 11352, i64 11304, i64 11353, i64 11305, i64 11354, i64 11306, i64 11355, i64 11307, i64 11356, i64 11308, i64 11357, i64 11309, i64 11358, i64 11310, i64 11359, i64 11311, i64 11361, i64 11360, i64 11365, i64 570, i64 11366, i64 574, i64 11368, i64 11367, i64 11370, i64 11369, i64 11372, i64 11371, i64 11379, i64 11378, i64 11382, i64 11381, i64 11393, i64 11392, i64 11395, i64 11394, i64 11397, i64 11396, i64 11399, i64 11398, i64 11401, i64 11400, i64 11403, i64 11402, i64 11405, i64 11404, i64 11407, i64 11406, i64 11409, i64 11408, i64 11411, i64 11410, i64 11413, i64 11412, i64 11415, i64 11414, i64 11417, i64 11416, i64 11419, i64 11418, i64 11421, i64 11420, i64 11423, i64 11422, i64 11425, i64 11424, i64 11427, i64 11426, i64 11429, i64 11428, i64 11431, i64 11430, i64 11433, i64 11432, i64 11435, i64 11434, i64 11437, i64 11436, i64 11439, i64 11438, i64 11441, i64 11440, i64 11443, i64 11442, i64 11445, i64 11444, i64 11447, i64 11446, i64 11449, i64 11448, i64 11451, i64 11450, i64 11453, i64 11452, i64 11455, i64 11454, i64 11457, i64 11456, i64 11459, i64 11458, i64 11461, i64 11460, i64 11463, i64 11462, i64 11465, i64 11464, i64 11467, i64 11466, i64 11469, i64 11468, i64 11471, i64 11470, i64 11473, i64 11472, i64 11475, i64 11474, i64 11477, i64 11476, i64 11479, i64 11478, i64 11481, i64 11480, i64 11483, i64 11482, i64 11485, i64 11484, i64 11487, i64 11486, i64 11489, i64 11488, i64 11491, i64 11490, i64 11500, i64 11499, i64 11502, i64 11501, i64 11507, i64 11506, i64 11520, i64 4256, i64 11521, i64 4257, i64 11522, i64 4258, i64 11523, i64 4259, i64 11524, i64 4260, i64 11525, i64 4261, i64 11526, i64 4262, i64 11527, i64 4263, i64 11528, i64 4264, i64 11529, i64 4265, i64 11530, i64 4266, i64 11531, i64 4267, i64 11532, i64 4268, i64 11533, i64 4269, i64 11534, i64 4270, i64 11535, i64 4271, i64 11536, i64 4272, i64 11537, i64 4273, i64 11538, i64 4274, i64 11539, i64 4275, i64 11540, i64 4276, i64 11541, i64 4277, i64 11542, i64 4278, i64 11543, i64 4279, i64 11544, i64 4280, i64 11545, i64 4281, i64 11546, i64 4282, i64 11547, i64 4283, i64 11548, i64 4284, i64 11549, i64 4285, i64 11550, i64 4286, i64 11551, i64 4287, i64 11552, i64 4288, i64 11553, i64 4289, i64 11554, i64 4290, i64 11555, i64 4291, i64 11556, i64 4292, i64 11557, i64 4293, i64 11559, i64 4295, i64 11565, i64 4301, i64 42561, i64 42560, i64 42563, i64 42562, i64 42565, i64 42564, i64 42567, i64 42566, i64 42569, i64 42568, i64 42571, i64 42570, i64 42573, i64 42572, i64 42575, i64 42574, i64 42577, i64 42576, i64 42579, i64 42578, i64 42581, i64 42580, i64 42583, i64 42582, i64 42585, i64 42584, i64 42587, i64 42586, i64 42589, i64 42588, i64 42591, i64 42590, i64 42593, i64 42592, i64 42595, i64 42594, i64 42597, i64 42596, i64 42599, i64 42598, i64 42601, i64 42600, i64 42603, i64 42602, i64 42605, i64 42604, i64 42625, i64 42624, i64 42627, i64 42626, i64 42629, i64 42628, i64 42631, i64 42630, i64 42633, i64 42632, i64 42635, i64 42634, i64 42637, i64 42636, i64 42639, i64 42638, i64 42641, i64 42640, i64 42643, i64 42642, i64 42645, i64 42644, i64 42647, i64 42646, i64 42649, i64 42648, i64 42651, i64 42650, i64 42787, i64 42786, i64 42789, i64 42788, i64 42791, i64 42790, i64 42793, i64 42792, i64 42795, i64 42794, i64 42797, i64 42796, i64 42799, i64 42798, i64 42803, i64 42802, i64 42805, i64 42804, i64 42807, i64 42806, i64 42809, i64 42808, i64 42811, i64 42810, i64 42813, i64 42812, i64 42815, i64 42814, i64 42817, i64 42816, i64 42819, i64 42818, i64 42821, i64 42820, i64 42823, i64 42822, i64 42825, i64 42824, i64 42827, i64 42826, i64 42829, i64 42828, i64 42831, i64 42830, i64 42833, i64 42832, i64 42835, i64 42834, i64 42837, i64 42836, i64 42839, i64 42838, i64 42841, i64 42840, i64 42843, i64 42842, i64 42845, i64 42844, i64 42847, i64 42846, i64 42849, i64 42848, i64 42851, i64 42850, i64 42853, i64 42852, i64 42855, i64 42854, i64 42857, i64 42856, i64 42859, i64 42858, i64 42861, i64 42860, i64 42863, i64 42862, i64 42874, i64 42873, i64 42876, i64 42875, i64 42879, i64 42878, i64 42881, i64 42880, i64 42883, i64 42882, i64 42885, i64 42884, i64 42887, i64 42886, i64 42892, i64 42891, i64 42897, i64 42896, i64 42899, i64 42898, i64 42900, i64 42948, i64 42903, i64 42902, i64 42905, i64 42904, i64 42907, i64 42906, i64 42909, i64 42908, i64 42911, i64 42910, i64 42913, i64 42912, i64 42915, i64 42914, i64 42917, i64 42916, i64 42919, i64 42918, i64 42921, i64 42920, i64 42933, i64 42932, i64 42935, i64 42934, i64 42937, i64 42936, i64 42939, i64 42938, i64 42941, i64 42940, i64 42943, i64 42942, i64 42945, i64 42944, i64 42947, i64 42946, i64 42952, i64 42951, i64 42954, i64 42953, i64 42957, i64 42956, i64 42961, i64 42960, i64 42967, i64 42966, i64 42969, i64 42968, i64 42971, i64 42970, i64 42998, i64 42997, i64 43859, i64 42931, i64 43888, i64 5024, i64 43889, i64 5025, i64 43890, i64 5026, i64 43891, i64 5027, i64 43892, i64 5028, i64 43893, i64 5029, i64 43894, i64 5030, i64 43895, i64 5031, i64 43896, i64 5032, i64 43897, i64 5033, i64 43898, i64 5034, i64 43899, i64 5035, i64 43900, i64 5036, i64 43901, i64 5037, i64 43902, i64 5038, i64 43903, i64 5039, i64 43904, i64 5040, i64 43905, i64 5041, i64 43906, i64 5042, i64 43907, i64 5043, i64 43908, i64 5044, i64 43909, i64 5045, i64 43910, i64 5046, i64 43911, i64 5047, i64 43912, i64 5048, i64 43913, i64 5049, i64 43914, i64 5050, i64 43915, i64 5051, i64 43916, i64 5052, i64 43917, i64 5053, i64 43918, i64 5054, i64 43919, i64 5055, i64 43920, i64 5056, i64 43921, i64 5057, i64 43922, i64 5058, i64 43923, i64 5059, i64 43924, i64 5060, i64 43925, i64 5061, i64 43926, i64 5062, i64 43927, i64 5063, i64 43928, i64 5064, i64 43929, i64 5065, i64 43930, i64 5066, i64 43931, i64 5067, i64 43932, i64 5068, i64 43933, i64 5069, i64 43934, i64 5070, i64 43935, i64 5071, i64 43936, i64 5072, i64 43937, i64 5073, i64 43938, i64 5074, i64 43939, i64 5075, i64 43940, i64 5076, i64 43941, i64 5077, i64 43942, i64 5078, i64 43943, i64 5079, i64 43944, i64 5080, i64 43945, i64 5081, i64 43946, i64 5082, i64 43947, i64 5083, i64 43948, i64 5084, i64 43949, i64 5085, i64 43950, i64 5086, i64 43951, i64 5087, i64 43952, i64 5088, i64 43953, i64 5089, i64 43954, i64 5090, i64 43955, i64 5091, i64 43956, i64 5092, i64 43957, i64 5093, i64 43958, i64 5094, i64 43959, i64 5095, i64 43960, i64 5096, i64 43961, i64 5097, i64 43962, i64 5098, i64 43963, i64 5099, i64 43964, i64 5100, i64 43965, i64 5101, i64 43966, i64 5102, i64 43967, i64 5103, i64 65345, i64 65313, i64 65346, i64 65314, i64 65347, i64 65315, i64 65348, i64 65316, i64 65349, i64 65317, i64 65350, i64 65318, i64 65351, i64 65319, i64 65352, i64 65320, i64 65353, i64 65321, i64 65354, i64 65322, i64 65355, i64 65323, i64 65356, i64 65324, i64 65357, i64 65325, i64 65358, i64 65326, i64 65359, i64 65327, i64 65360, i64 65328, i64 65361, i64 65329, i64 65362, i64 65330, i64 65363, i64 65331, i64 65364, i64 65332, i64 65365, i64 65333, i64 65366, i64 65334, i64 65367, i64 65335, i64 65368, i64 65336, i64 65369, i64 65337, i64 65370, i64 65338, i64 66600, i64 66560, i64 66601, i64 66561, i64 66602, i64 66562, i64 66603, i64 66563, i64 66604, i64 66564, i64 66605, i64 66565, i64 66606, i64 66566, i64 66607, i64 66567, i64 66608, i64 66568, i64 66609, i64 66569, i64 66610, i64 66570, i64 66611, i64 66571, i64 66612, i64 66572, i64 66613, i64 66573, i64 66614, i64 66574, i64 66615, i64 66575, i64 66616, i64 66576, i64 66617, i64 66577, i64 66618, i64 66578, i64 66619, i64 66579, i64 66620, i64 66580, i64 66621, i64 66581, i64 66622, i64 66582, i64 66623, i64 66583, i64 66624, i64 66584, i64 66625, i64 66585, i64 66626, i64 66586, i64 66627, i64 66587, i64 66628, i64 66588, i64 66629, i64 66589, i64 66630, i64 66590, i64 66631, i64 66591, i64 66632, i64 66592, i64 66633, i64 66593, i64 66634, i64 66594, i64 66635, i64 66595, i64 66636, i64 66596, i64 66637, i64 66597, i64 66638, i64 66598, i64 66639, i64 66599, i64 66776, i64 66736, i64 66777, i64 66737, i64 66778, i64 66738, i64 66779, i64 66739, i64 66780, i64 66740, i64 66781, i64 66741, i64 66782, i64 66742, i64 66783, i64 66743, i64 66784, i64 66744, i64 66785, i64 66745, i64 66786, i64 66746, i64 66787, i64 66747, i64 66788, i64 66748, i64 66789, i64 66749, i64 66790, i64 66750, i64 66791, i64 66751, i64 66792, i64 66752, i64 66793, i64 66753, i64 66794, i64 66754, i64 66795, i64 66755, i64 66796, i64 66756, i64 66797, i64 66757, i64 66798, i64 66758, i64 66799, i64 66759, i64 66800, i64 66760, i64 66801, i64 66761, i64 66802, i64 66762, i64 66803, i64 66763, i64 66804, i64 66764, i64 66805, i64 66765, i64 66806, i64 66766, i64 66807, i64 66767, i64 66808, i64 66768, i64 66809, i64 66769, i64 66810, i64 66770, i64 66811, i64 66771, i64 66967, i64 66928, i64 66968, i64 66929, i64 66969, i64 66930, i64 66970, i64 66931, i64 66971, i64 66932, i64 66972, i64 66933, i64 66973, i64 66934, i64 66974, i64 66935, i64 66975, i64 66936, i64 66976, i64 66937, i64 66977, i64 66938, i64 66979, i64 66940, i64 66980, i64 66941, i64 66981, i64 66942, i64 66982, i64 66943, i64 66983, i64 66944, i64 66984, i64 66945, i64 66985, i64 66946, i64 66986, i64 66947, i64 66987, i64 66948, i64 66988, i64 66949, i64 66989, i64 66950, i64 66990, i64 66951, i64 66991, i64 66952, i64 66992, i64 66953, i64 66993, i64 66954, i64 66995, i64 66956, i64 66996, i64 66957, i64 66997, i64 66958, i64 66998, i64 66959, i64 66999, i64 66960, i64 67000, i64 66961, i64 67001, i64 66962, i64 67003, i64 66964, i64 67004, i64 66965, i64 68800, i64 68736, i64 68801, i64 68737, i64 68802, i64 68738, i64 68803, i64 68739, i64 68804, i64 68740, i64 68805, i64 68741, i64 68806, i64 68742, i64 68807, i64 68743, i64 68808, i64 68744, i64 68809, i64 68745, i64 68810, i64 68746, i64 68811, i64 68747, i64 68812, i64 68748, i64 68813, i64 68749, i64 68814, i64 68750, i64 68815, i64 68751, i64 68816, i64 68752, i64 68817, i64 68753, i64 68818, i64 68754, i64 68819, i64 68755, i64 68820, i64 68756, i64 68821, i64 68757, i64 68822, i64 68758, i64 68823, i64 68759, i64 68824, i64 68760, i64 68825, i64 68761, i64 68826, i64 68762, i64 68827, i64 68763, i64 68828, i64 68764, i64 68829, i64 68765, i64 68830, i64 68766, i64 68831, i64 68767, i64 68832, i64 68768, i64 68833, i64 68769, i64 68834, i64 68770, i64 68835, i64 68771, i64 68836, i64 68772, i64 68837, i64 68773, i64 68838, i64 68774, i64 68839, i64 68775, i64 68840, i64 68776, i64 68841, i64 68777, i64 68842, i64 68778, i64 68843, i64 68779, i64 68844, i64 68780, i64 68845, i64 68781, i64 68846, i64 68782, i64 68847, i64 68783, i64 68848, i64 68784, i64 68849, i64 68785, i64 68850, i64 68786, i64 68976, i64 68944, i64 68977, i64 68945, i64 68978, i64 68946, i64 68979, i64 68947, i64 68980, i64 68948, i64 68981, i64 68949, i64 68982, i64 68950, i64 68983, i64 68951, i64 68984, i64 68952, i64 68985, i64 68953, i64 68986, i64 68954, i64 68987, i64 68955, i64 68988, i64 68956, i64 68989, i64 68957, i64 68990, i64 68958, i64 68991, i64 68959, i64 68992, i64 68960, i64 68993, i64 68961, i64 68994, i64 68962, i64 68995, i64 68963, i64 68996, i64 68964, i64 68997, i64 68965, i64 71872, i64 71840, i64 71873, i64 71841, i64 71874, i64 71842, i64 71875, i64 71843, i64 71876, i64 71844, i64 71877, i64 71845, i64 71878, i64 71846, i64 71879, i64 71847, i64 71880, i64 71848, i64 71881, i64 71849, i64 71882, i64 71850, i64 71883, i64 71851, i64 71884, i64 71852, i64 71885, i64 71853, i64 71886, i64 71854, i64 71887, i64 71855, i64 71888, i64 71856, i64 71889, i64 71857, i64 71890, i64 71858, i64 71891, i64 71859, i64 71892, i64 71860, i64 71893, i64 71861, i64 71894, i64 71862, i64 71895, i64 71863, i64 71896, i64 71864, i64 71897, i64 71865, i64 71898, i64 71866, i64 71899, i64 71867, i64 71900, i64 71868, i64 71901, i64 71869, i64 71902, i64 71870, i64 71903, i64 71871, i64 93792, i64 93760, i64 93793, i64 93761, i64 93794, i64 93762, i64 93795, i64 93763, i64 93796, i64 93764, i64 93797, i64 93765, i64 93798, i64 93766, i64 93799, i64 93767, i64 93800, i64 93768, i64 93801, i64 93769, i64 93802, i64 93770, i64 93803, i64 93771, i64 93804, i64 93772, i64 93805, i64 93773, i64 93806, i64 93774, i64 93807, i64 93775, i64 93808, i64 93776, i64 93809, i64 93777, i64 93810, i64 93778, i64 93811, i64 93779, i64 93812, i64 93780, i64 93813, i64 93781, i64 93814, i64 93782, i64 93815, i64 93783, i64 93816, i64 93784, i64 93817, i64 93785, i64 93818, i64 93786, i64 93819, i64 93787, i64 93820, i64 93788, i64 93821, i64 93789, i64 93822, i64 93790, i64 93823, i64 93791, i64 125218, i64 125184, i64 125219, i64 125185, i64 125220, i64 125186, i64 125221, i64 125187, i64 125222, i64 125188, i64 125223, i64 125189, i64 125224, i64 125190, i64 125225, i64 125191, i64 125226, i64 125192, i64 125227, i64 125193, i64 125228, i64 125194, i64 125229, i64 125195, i64 125230, i64 125196, i64 125231, i64 125197, i64 125232, i64 125198, i64 125233, i64 125199, i64 125234, i64 125200, i64 125235, i64 125201, i64 125236, i64 125202, i64 125237, i64 125203, i64 125238, i64 125204, i64 125239, i64 125205, i64 125240, i64 125206, i64 125241, i64 125207, i64 125242, i64 125208, i64 125243, i64 125209, i64 125244, i64 125210, i64 125245, i64 125211, i64 125246, i64 125212, i64 125247, i64 125213, i64 125248, i64 125214, i64 125249, i64 125215, i64 125250, i64 125216, i64 125251, i64 125217], align 16
@rtt.12189 = private unnamed_addr constant [913 x i64] [i64 223, i64 2, i64 83, i64 83, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 329, i64 3, i64 202, i64 188, i64 78, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 496, i64 3, i64 74, i64 204, i64 140, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 912, i64 6, i64 206, i64 153, i64 204, i64 136, i64 204, i64 129, i64 0, i64 0, i64 0, i64 944, i64 6, i64 206, i64 165, i64 204, i64 136, i64 204, i64 129, i64 0, i64 0, i64 0, i64 7830, i64 3, i64 72, i64 204, i64 177, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7831, i64 3, i64 84, i64 204, i64 136, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7832, i64 3, i64 87, i64 204, i64 138, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7833, i64 3, i64 89, i64 204, i64 138, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7834, i64 3, i64 65, i64 202, i64 190, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8064, i64 5, i64 225, i64 188, i64 136, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8065, i64 5, i64 225, i64 188, i64 137, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8066, i64 5, i64 225, i64 188, i64 138, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8067, i64 5, i64 225, i64 188, i64 139, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8068, i64 5, i64 225, i64 188, i64 140, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8069, i64 5, i64 225, i64 188, i64 141, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8070, i64 5, i64 225, i64 188, i64 142, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8071, i64 5, i64 225, i64 188, i64 143, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8072, i64 5, i64 225, i64 188, i64 136, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8073, i64 5, i64 225, i64 188, i64 137, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8074, i64 5, i64 225, i64 188, i64 138, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8075, i64 5, i64 225, i64 188, i64 139, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8076, i64 5, i64 225, i64 188, i64 140, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8077, i64 5, i64 225, i64 188, i64 141, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8078, i64 5, i64 225, i64 188, i64 142, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8079, i64 5, i64 225, i64 188, i64 143, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8080, i64 5, i64 225, i64 190, i64 152, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8081, i64 5, i64 225, i64 190, i64 153, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8082, i64 5, i64 225, i64 190, i64 154, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8083, i64 5, i64 225, i64 190, i64 155, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8084, i64 5, i64 225, i64 190, i64 156, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8085, i64 5, i64 225, i64 190, i64 157, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8086, i64 5, i64 225, i64 190, i64 158, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8087, i64 5, i64 225, i64 190, i64 159, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8088, i64 5, i64 225, i64 190, i64 152, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8089, i64 5, i64 225, i64 190, i64 153, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8090, i64 5, i64 225, i64 190, i64 154, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8091, i64 5, i64 225, i64 190, i64 155, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8092, i64 5, i64 225, i64 190, i64 156, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8093, i64 5, i64 225, i64 190, i64 157, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8094, i64 5, i64 225, i64 190, i64 158, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8095, i64 5, i64 225, i64 190, i64 159, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8096, i64 5, i64 225, i64 190, i64 168, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8097, i64 5, i64 225, i64 190, i64 169, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8098, i64 5, i64 225, i64 190, i64 170, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8099, i64 5, i64 225, i64 190, i64 171, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8100, i64 5, i64 225, i64 190, i64 172, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8101, i64 5, i64 225, i64 190, i64 173, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8102, i64 5, i64 225, i64 190, i64 174, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8103, i64 5, i64 225, i64 190, i64 175, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8104, i64 5, i64 225, i64 190, i64 168, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8105, i64 5, i64 225, i64 190, i64 169, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8106, i64 5, i64 225, i64 190, i64 170, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8107, i64 5, i64 225, i64 190, i64 171, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8108, i64 5, i64 225, i64 190, i64 172, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8109, i64 5, i64 225, i64 190, i64 173, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8110, i64 5, i64 225, i64 190, i64 174, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8111, i64 5, i64 225, i64 190, i64 175, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8114, i64 5, i64 225, i64 190, i64 186, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 8115, i64 4, i64 206, i64 145, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8116, i64 4, i64 206, i64 134, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8118, i64 4, i64 206, i64 145, i64 205, i64 130, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8119, i64 6, i64 206, i64 145, i64 205, i64 130, i64 205, i64 133, i64 0, i64 0, i64 0, i64 8124, i64 4, i64 206, i64 145, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8130, i64 5, i64 225, i64 191, i64 138, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 8131, i64 4, i64 206, i64 151, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8132, i64 4, i64 206, i64 137, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8134, i64 4, i64 206, i64 151, i64 205, i64 130, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8135, i64 6, i64 206, i64 151, i64 205, i64 130, i64 205, i64 133, i64 0, i64 0, i64 0, i64 8140, i64 4, i64 206, i64 151, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8178, i64 5, i64 225, i64 191, i64 186, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 8179, i64 4, i64 206, i64 169, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8180, i64 4, i64 206, i64 143, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8182, i64 4, i64 206, i64 169, i64 205, i64 130, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8183, i64 6, i64 206, i64 169, i64 205, i64 130, i64 205, i64 133, i64 0, i64 0, i64 0, i64 8188, i64 4, i64 206, i64 169, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64256, i64 2, i64 70, i64 70, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64257, i64 2, i64 70, i64 73, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64258, i64 2, i64 70, i64 76, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64259, i64 3, i64 70, i64 70, i64 73, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64260, i64 3, i64 70, i64 70, i64 76, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64261, i64 2, i64 83, i64 84, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64262, i64 2, i64 83, i64 84, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0], align 16
@.s1714 = private unnamed_addr constant [10 x i8] c"List(Str)\00"
@rtg.split_one = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.strtod_end = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.stat_buf = internal thread_local global [144 x i8] zeroinitializer, align 16
@.s2169 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.s2184 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.s2221 = private unnamed_addr constant [10 x i8] c"List(Str)\00"
@.s2299 = private unnamed_addr constant [5 x i8] c"File\00"
@rtg.rt_args = internal global [24 x i8] zeroinitializer, align 16
@.s2362 = private unnamed_addr constant [19 x i8] c"/proc/self/cmdline\00"
@.s2365 = private unnamed_addr constant [19 x i8] c"/proc/self/cmdline\00"
@rtg.wait_status = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s2537 = private unnamed_addr constant [2 x i8] c"r\00"
@.s2574 = private unnamed_addr constant [15 x i8] c"git rev-parse \00"
@.s2577 = private unnamed_addr constant [13 x i8] c" 2>/dev/null\00"
@.s2581 = private unnamed_addr constant [44 x i8] c"git rev-parse --abbrev-ref HEAD 2>/dev/null\00"
@rtt.16828 = private unnamed_addr constant [64 x i64] [i64 1116352408, i64 1899447441, i64 3049323471, i64 3921009573, i64 961987163, i64 1508970993, i64 2453635748, i64 2870763221, i64 3624381080, i64 310598401, i64 607225278, i64 1426881987, i64 1925078388, i64 2162078206, i64 2614888103, i64 3248222580, i64 3835390401, i64 4022224774, i64 264347078, i64 604807628, i64 770255983, i64 1249150122, i64 1555081692, i64 1996064986, i64 2554220882, i64 2821834349, i64 2952996808, i64 3210313671, i64 3336571891, i64 3584528711, i64 113926993, i64 338241895, i64 666307205, i64 773529912, i64 1294757372, i64 1396182291, i64 1695183700, i64 1986661051, i64 2177026350, i64 2456956037, i64 2730485921, i64 2820302411, i64 3259730800, i64 3345764771, i64 3516065817, i64 3600352804, i64 4094571909, i64 275423344, i64 430227734, i64 506948616, i64 659060556, i64 883997877, i64 958139571, i64 1322822218, i64 1537002063, i64 1747873779, i64 1955562222, i64 2024104815, i64 2227730452, i64 2361852424, i64 2428436474, i64 2756734187, i64 3204031479, i64 3329325298], align 16
@rtt.17342 = private unnamed_addr constant [8 x i64] [i64 1779033703, i64 3144134277, i64 1013904242, i64 2773480762, i64 1359893119, i64 2600822924, i64 528734635, i64 1541459225], align 16
@.s2905 = private unnamed_addr constant [17 x i8] c"0123456789abcdef\00"
@rtg.rt_dbg = internal global [8224 x i8] zeroinitializer, align 16
@rtg.dbg_status = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.dbg_msg = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.dbg_peek = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtt.18579 = private unnamed_addr constant [17 x i64] [i64 80, i64 96, i64 88, i64 40, i64 104, i64 112, i64 32, i64 152, i64 72, i64 64, i64 56, i64 48, i64 24, i64 16, i64 8, i64 0, i64 128], align 16
@rtg.dbg_regs = internal thread_local global [256 x i8] zeroinitializer, align 16
@.s3178 = private unnamed_addr constant [15 x i8] c"RESID_STACK_MB\00"
@rtg.numfmt_buf = internal thread_local global [32 x i8] zeroinitializer, align 16
@rtg.limb_buf = internal thread_local global [208 x i8] zeroinitializer, align 16
@rtg.limbs = internal thread_local global [64 x i8] zeroinitializer, align 16
@rtg.ftoa_buf = internal thread_local global [64 x i8] zeroinitializer, align 16
@.s3426 = private unnamed_addr constant [6 x i8] c"%.17g\00"
@.s3431 = private unnamed_addr constant [5 x i8] c"true\00"
@.s3433 = private unnamed_addr constant [6 x i8] c"false\00"
@.s3784 = private unnamed_addr constant [4 x i8] c"nan\00"
@.s3786 = private unnamed_addr constant [5 x i8] c"-inf\00"
@.s3788 = private unnamed_addr constant [4 x i8] c"inf\00"
@rtg.f128_m = internal thread_local global [2080 x i8] zeroinitializer, align 16
@rtg.f128_ip = internal thread_local global [2080 x i8] zeroinitializer, align 16
@rtg.f128_ib = internal thread_local global [5000 x i8] zeroinitializer, align 16
@rtg.f128_fd = internal thread_local global [64 x i8] zeroinitializer, align 16
@.s3829 = private unnamed_addr constant [2 x i8] c"0\00"
@rtg.f128_lead = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s3849 = private unnamed_addr constant [3 x i8] c"-0\00"
@.s3851 = private unnamed_addr constant [2 x i8] c"0\00"
@rtg.f128_digits = internal thread_local global [48 x i8] zeroinitializer, align 16
@rtg.f128_out = internal thread_local global [112 x i8] zeroinitializer, align 16
@rtg.show_buf = internal thread_local global [64 x i8] zeroinitializer, align 16
@.s4038 = private unnamed_addr constant [6 x i8] c"%.17g\00"
@.s4049 = private unnamed_addr constant [5 x i8] c"true\00"
@.s4051 = private unnamed_addr constant [6 x i8] c"false\00"
@.s4058 = private unnamed_addr constant [5 x i8] c"null\00"
@.s4063 = private unnamed_addr constant [4 x i8] c"…\00"
@.s4069 = private unnamed_addr constant [3 x i8] c", \00"
@.s4079 = private unnamed_addr constant [3 x i8] c", \00"
@.s4098 = private unnamed_addr constant [5 x i8] c"null\00"
@.s4107 = private unnamed_addr constant [5 x i8] c"i128\00"
@.s4119 = private unnamed_addr constant [5 x i8] c"u128\00"
@.s4150 = private unnamed_addr constant [6 x i8] c"Some(\00"
@.s4152 = private unnamed_addr constant [6 x i8] c"Some<\00"
@.s4161 = private unnamed_addr constant [2 x i8] c")\00"
@.s4163 = private unnamed_addr constant [2 x i8] c">\00"
@.s4169 = private unnamed_addr constant [5 x i8] c"None\00"
@.s4174 = private unnamed_addr constant [2 x i8] c"(\00"
@.s4179 = private unnamed_addr constant [2 x i8] c")\00"
@.s4184 = private unnamed_addr constant [5 x i8] c"null\00"
@.s4191 = private unnamed_addr constant [2 x i8] c"(\00"
@.s4200 = private unnamed_addr constant [2 x i8] c")\00"
@.s4206 = private unnamed_addr constant [3 x i8] c", \00"
