declare ptr @malloc(i64)
declare void @free(ptr)
declare ptr @resid_fs_read_all(ptr)
declare i8 @resid_fs_write_all(ptr, ptr)
declare ptr @resid_fs_read_bytes(ptr)
declare i8 @resid_fs_write_bytes(ptr, ptr)
declare i8 @resid_fs_write_secret(ptr, ptr)
declare ptr @resid_fs_sha256(ptr)
declare i8 @resid_fs_append_bytes(ptr, ptr)
declare ptr @resid_fs_open(ptr)
declare ptr @resid_fs_read_handle(ptr)
declare i8 @resid_fs_close(ptr)
declare i8 @resid_fs_exists(ptr)
declare i8 @resid_fs_is_dir(ptr)
declare i8 @resid_fs_create_dir_all(ptr)
declare ptr @resid_fs_list_dir(ptr)
declare i64 @resid_args_count()
declare ptr @resid_args_get(i64)
declare i64 @resid_process_run(ptr)
declare ptr @resid_env_get(ptr)
declare i64 @resid_arena_push()
declare i64 @resid_arena_pop()
declare ptr @resid_list_str_persist_copy(ptr)
declare i32 @resid_run_main(ptr)
declare ptr @resid_list_const_i64(ptr, i64, ptr, ptr)
declare ptr @resid_list_const_ptr(ptr, i64, ptr, ptr)
declare ptr @resid_list_const_bool(ptr, i64, ptr, ptr)
declare i64 @resid_crypto_random_byte()
declare ptr @resid_read_line()
declare i64 @resid_dbg_spawn(ptr)
declare i64 @resid_dbg_wait()
declare i8 @resid_dbg_cont(i64, i64)
declare i8 @resid_dbg_step(i64)
declare i64 @resid_dbg_peek(i64, i64)
declare i8 @resid_dbg_poke(i64, i64, i64)
declare i64 @resid_dbg_reg(i64, i64)
declare i8 @resid_dbg_set_pc(i64, i64)
declare i64 @resid_dbg_signal()
declare i64 @resid_dbg_exit_code()
declare i8 @resid_dbg_kill()
declare ptr @resid_dbg_f64(i64)
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
declare ptr @ToString(ptr)
declare ptr @resid_list_to_string(ptr)
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
declare ptr @Int128ToString(i128)
declare ptr @UIntToString(i64)
declare ptr @Int256ToString(i64, i64, i64, i64)
declare ptr @UInt256ToString(i64, i64, i64, i64)
declare ptr @Int512ToString(i64, i64, i64, i64, i64, i64, i64, i64)
declare ptr @UInt512ToString(i64, i64, i64, i64, i64, i64, i64, i64)
declare ptr @FloatToString(double)
declare ptr @Float128ToString(fp128)
declare ptr @BoolToString(i8)
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
declare ptr @UInt128ToString(i128)
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
declare void @resid_handle_release(ptr)
declare ptr @resid_spawn(ptr, ptr)
declare ptr @resid_ok_box(ptr)
declare ptr @resid_gmalloc(i64)
declare void @resid_gfree(ptr)
declare i64 @resid_bulk_push()
declare i64 @resid_bulk_pop()
declare i64 @resid_mem_mark()
declare i64 @resid_mem_since_mark()
declare ptr @str_sha256(ptr)
declare i8 @resid_fs_write_hex(ptr, ptr)
declare i8 @resid_fs_append_hex(ptr, ptr)
declare ptr @resid_decp_persist(ptr)
declare i64 @resid_scope_push()
declare void @resid_scope_pop(i64)
declare i8 @resid_print_bytes(ptr)
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
%t83 = sub i128 -9223372036854775807, 1
%t84 = add i128 %t83, 0
%t85 = trunc i128 %t84 to i64
%t86 = sext i64 %t85 to i128
%t87 = icmp ne i128 %t86, %t84
%t88 = icmp eq i8 0, 1
%t89 = or i1 %t87, %t88
%t90 = zext i1 %t89 to i8
call void @resid_conv_check(i8 %t90)
%t91 = xor i64 %p0, %t85
%t92 = sub i128 -9223372036854775807, 1
%t93 = add i128 %t92, 0
%t94 = trunc i128 %t93 to i64
%t95 = sext i64 %t94 to i128
%t96 = icmp ne i128 %t95, %t93
%t97 = icmp eq i8 0, 1
%t98 = or i1 %t96, %t97
%t99 = zext i1 %t98 to i8
call void @resid_conv_check(i8 %t99)
%t100 = xor i64 %p1, %t94
%t101 = icmp slt i64 %t91, %t100
ret i1 %t101
}
define internal i1 @write_all(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %t107, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %t108, %tco.s1 ]
%t102 = icmp sle i64 %p2, 0
br i1 %t102, label %L31, label %L33
L31:
ret i1 true
L33:
%t103 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 1, i64 %p0, i64 %p1, i64 %p2, i64 0, i64 0, i64 0)
%t104 = icmp eq i64 %t103, -4
br i1 %t104, label %L34, label %L36
L34:
br label %tco.s0
tco.s0:
br label %tco.head
L36:
%t106 = icmp sle i64 %t103, 0
br i1 %t106, label %L37, label %L39
L37:
ret i1 false
L39:
%t107 = add i64 %p1, %t103
%t108 = sub nsw i64 %p2, %t103
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i1 @write_cstr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t110 = call i64 @c_strlen(i64 %p1)
%t111 = call i1 @write_all(i64 %p0, i64 %p1, i64 %t110)
ret i1 %t111
}
define internal i1 @write_nl(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t113 = ptrtoint ptr @.s112 to i64
%t114 = call i1 @write_all(i64 %p0, i64 %t113, i64 1)
ret i1 %t114
}
define internal i1 @rt_print(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t115 = call i1 @write_cstr(i64 1, i64 %p0)
ret i1 %t115
}
define i1 @print(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i1 @rt_print(i64 %x0i)
ret i1 %r
}
define internal i1 @write_line(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t116p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.iov)
%t116 = ptrtoint ptr %t116p to i64
%t117 = call i64 @st64(i64 %t116, i64 %p1)
%t118 = add i64 %t116, 8
%t119 = call i64 @st64(i64 %t118, i64 %p2)
%t120 = add i64 %t116, 16
%t122 = ptrtoint ptr @.s121 to i64
%t123 = call i64 @st64(i64 %t120, i64 %t122)
%t124 = add i64 %t116, 24
%t125 = call i64 @st64(i64 %t124, i64 1)
%t126 = call i64 asm sideeffect "syscall", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11},~{memory}"(i64 20, i64 %p0, i64 %t116, i64 2, i64 0, i64 0, i64 0)
%t127 = add i64 %p2, 1
%t128 = icmp eq i64 %t126, %t127
br i1 %t128, label %L40, label %L42
L40:
ret i1 true
L42:
%t129 = icmp slt i64 %t126, 0
br label %LSL130
LSL130:
br i1 %t129, label %LSR130, label %LSJ130
LSR130:
%t131 = icmp ne i64 %t126, -4
br label %LSJ130
LSJ130:
%t132 = phi i1 [ false, %LSL130 ], [ %t131, %LSR130 ]
br i1 %t132, label %L43, label %L45
L43:
ret i1 false
L45:
%t133 = icmp slt i64 %t126, 0
br i1 %t133, label %L46, label %L47
L46:
br label %L48
L47:
br label %L48
L48:
%t134 = phi i64 [ 0, %L46 ], [ %t126, %L47 ]
%t135 = icmp sge i64 %t134, %p2
br i1 %t135, label %L49, label %L51
L49:
%t136 = call i1 @write_nl(i64 %p0)
ret i1 %t136
L51:
%t137 = add i64 %p1, %t134
%t138 = sub i64 %p2, %t134
%t139 = call i1 @write_all(i64 %p0, i64 %t137, i64 %t138)
br label %LSL140
LSL140:
br i1 %t139, label %LSR140, label %LSJ140
LSR140:
%t141 = call i1 @write_nl(i64 %p0)
br label %LSJ140
LSJ140:
%t142 = phi i1 [ false, %LSL140 ], [ %t141, %LSR140 ]
ret i1 %t142
}
define internal i1 @rt_println(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t143 = call i64 @c_strlen(i64 %p0)
%t144 = call i1 @write_line(i64 1, i64 %p0, i64 %t143)
ret i1 %t144
}
define i1 @println(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i1 @rt_println(i64 %x0i)
ret i1 %r
}
define internal i1 @rt_eprintln(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t145 = call i64 @c_strlen(i64 %p0)
%t146 = call i1 @write_line(i64 2, i64 %p0, i64 %t145)
ret i1 %t146
}
define i1 @eprintln(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i1 @rt_eprintln(i64 %x0i)
ret i1 %r
}
define internal i64 @__mruntime_rt_io_resid__flags() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t147p = getelementptr i8, ptr @rtg.rt_flags, i64 0
%t147 = ptrtoint ptr %t147p to i64
ret i64 %t147
}
define internal i64 @rt_quiet_set(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t148 = call i64 @__mruntime_rt_io_resid__flags()
%t149 = call i64 @st64(i64 %t148, i64 %p0)
%t150 = add i64 %t149, 1
ret i64 %t150
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
%t151 = call i64 @__mruntime_rt_io_resid__flags()
%t152 = call i64 @ld64(i64 %t151)
ret i64 %t152
}
define i8 @resid_quiet() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_quiet()
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_internals_set(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t153 = call i64 @__mruntime_rt_io_resid__flags()
%t154 = add i64 %t153, 8
%t155 = call i64 @st64(i64 %t154, i64 %p0)
%t156 = add i64 %t155, 1
ret i64 %t156
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
%t157 = call i64 @__mruntime_rt_io_resid__flags()
%t158 = add i64 %t157, 8
%t159 = call i64 @ld64(i64 %t158)
ret i64 %t159
}
define i8 @resid_internals() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_internals()
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_rtmod_set(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t160 = call i64 @__mruntime_rt_io_resid__flags()
%t161 = add i64 %t160, 16
%t162 = call i64 @st64(i64 %t161, i64 %p0)
%t163 = add i64 %t162, 1
ret i64 %t163
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
%t164 = call i64 @__mruntime_rt_io_resid__flags()
%t165 = add i64 %t164, 16
%t166 = call i64 @ld64(i64 %t165)
ret i64 %t166
}
define i8 @resid_rtmod() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_rtmod()
%rv = trunc i64 %r to i8
ret i8 %rv
}
define internal i64 @rt_overflow_check(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t167 = icmp ne i64 %p0, 0
br i1 %t167, label %L52, label %L54
L52:
%t169 = call i64 @rt_abort(ptr @.s168)
ret i64 %t169
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
%t170 = icmp ne i64 %p0, 0
br i1 %t170, label %L55, label %L57
L55:
%t172 = call i64 @rt_abort(ptr @.s171)
ret i64 %t172
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
%t173 = icmp ne i64 %p0, 0
br i1 %t173, label %L58, label %L60
L58:
%t175 = call i64 @rt_abort(ptr @.s174)
ret i64 %t175
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
%t176 = trunc i128 9223372036854775807 to i64
ret i64 %t176
}
define internal i64 @__mruntime_rt_arith_resid__imin() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t177 = sub i128 -9223372036854775807, 1
%t178 = add i128 %t177, 0
%t179 = trunc i128 %t178 to i64
%t180 = sext i64 %t179 to i128
%t181 = icmp ne i128 %t180, %t178
%t182 = icmp eq i8 0, 1
%t183 = or i1 %t181, %t182
%t184 = zext i1 %t183 to i8
call void @resid_conv_check(i8 %t184)
%t185 = sext i64 %t179 to i128
%t186 = trunc i128 %t185 to i64
ret i64 %t186
}
define internal i64 @rt_wrapping_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t187 = add i64 %p0, %p1
ret i64 %t187
}
define i64 @wrapping_add(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_add(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_wrapping_sub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t188 = sub i64 %p0, %p1
ret i64 %t188
}
define i64 @wrapping_sub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_sub(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_wrapping_mul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t189 = mul i64 %p0, %p1
ret i64 %t189
}
define i64 @wrapping_mul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_mul(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_wrapping_div(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t190 = icmp eq i64 %p1, 0
br i1 %t190, label %L61, label %L63
L61:
%t192 = call i64 @rt_abort(ptr @.s191)
ret i64 %t192
L63:
%t193 = icmp eq i64 %p1, -1
br i1 %t193, label %L64, label %L66
L64:
%t194 = sub i64 0, %p0
ret i64 %t194
L66:
%t195 = icmp eq i64 %p1, 0
%t196 = zext i1 %t195 to i8
call void @resid_div_check(i8 %t196)
%t197 = icmp eq i64 %p1, -1
%t198 = icmp eq i64 %p0, -9223372036854775808
%t199 = and i1 %t197, %t198
%t202 = zext i1 %t199 to i8
call void @resid_overflow_check(i8 %t202)
%t200 = add i64 %p1, 0
%t201 = sdiv i64 %p0, %t200
ret i64 %t201
}
define i64 @wrapping_div(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_div(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_wrapping_uadd(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t203 = add i64 %p0, %p1
ret i64 %t203
}
define i64 @wrapping_uadd(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_uadd(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_wrapping_usub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t204 = sub i64 %p0, %p1
ret i64 %t204
}
define i64 @wrapping_usub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_usub(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_wrapping_umul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t205 = mul i64 %p0, %p1
ret i64 %t205
}
define i64 @wrapping_umul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_umul(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_wrapping_udiv(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t206 = icmp eq i64 %p1, 0
br i1 %t206, label %L67, label %L69
L67:
%t208 = call i64 @rt_abort(ptr @.s207)
ret i64 %t208
L69:
%t209 = tail call i64 @__mruntime_rt_arith_resid__rt_udiv(i64 %p0, i64 %p1)
ret i64 %t209
}
define i64 @wrapping_udiv(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_udiv(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @__mruntime_rt_arith_resid__rt_udiv(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t210 = tail call i64 @udiv(i64 %p0, i64 %p1)
ret i64 %t210
}
define internal i1 @__mruntime_rt_arith_resid__rt_ult(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t211 = tail call i1 @ult(i64 %p0, i64 %p1)
ret i1 %t211
}
define internal i64 @rt_saturating_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t212 = icmp sgt i64 %p1, 0
br label %LSL213
LSL213:
br i1 %t212, label %LSR213, label %LSJ213
LSR213:
%t214 = add i128 9223372036854775807, 0
%t215 = trunc i128 %t214 to i64
%t216 = sext i64 %t215 to i128
%t217 = icmp ne i128 %t216, %t214
%t218 = icmp eq i8 0, 1
%t219 = or i1 %t217, %t218
%t220 = zext i1 %t219 to i8
call void @resid_conv_check(i8 %t220)
%t221 = sub i64 %t215, %p1
%t222 = icmp sgt i64 %p0, %t221
br label %LSJ213
LSJ213:
%t223 = phi i1 [ false, %LSL213 ], [ %t222, %LSR213 ]
br i1 %t223, label %L70, label %L72
L70:
%t224 = add i128 9223372036854775807, 0
%t225 = trunc i128 %t224 to i64
%t226 = sext i64 %t225 to i128
%t227 = icmp ne i128 %t226, %t224
%t228 = icmp eq i8 0, 1
%t229 = or i1 %t227, %t228
%t230 = zext i1 %t229 to i8
call void @resid_conv_check(i8 %t230)
ret i64 %t225
L72:
%t231 = icmp slt i64 %p1, 0
br label %LSL232
LSL232:
br i1 %t231, label %LSR232, label %LSJ232
LSR232:
%t233 = sub i128 -9223372036854775807, 1
%t234 = add i128 %t233, 0
%t235 = trunc i128 %t234 to i64
%t236 = sext i64 %t235 to i128
%t237 = icmp ne i128 %t236, %t234
%t238 = icmp eq i8 0, 1
%t239 = or i1 %t237, %t238
%t240 = zext i1 %t239 to i8
call void @resid_conv_check(i8 %t240)
%t241 = sub i64 %t235, %p1
%t242 = icmp slt i64 %p0, %t241
br label %LSJ232
LSJ232:
%t243 = phi i1 [ false, %LSL232 ], [ %t242, %LSR232 ]
br i1 %t243, label %L73, label %L75
L73:
%t244 = sub i128 -9223372036854775807, 1
%t245 = add i128 %t244, 0
%t246 = trunc i128 %t245 to i64
%t247 = sext i64 %t246 to i128
%t248 = icmp ne i128 %t247, %t245
%t249 = icmp eq i8 0, 1
%t250 = or i1 %t248, %t249
%t251 = zext i1 %t250 to i8
call void @resid_conv_check(i8 %t251)
ret i64 %t246
L75:
%t252 = add i64 %p0, %p1
ret i64 %t252
}
define i64 @saturating_add(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_add(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_saturating_sub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t253 = icmp slt i64 %p1, 0
br label %LSL254
LSL254:
br i1 %t253, label %LSR254, label %LSJ254
LSR254:
%t255 = add i128 9223372036854775807, 0
%t256 = trunc i128 %t255 to i64
%t257 = sext i64 %t256 to i128
%t258 = icmp ne i128 %t257, %t255
%t259 = icmp eq i8 0, 1
%t260 = or i1 %t258, %t259
%t261 = zext i1 %t260 to i8
call void @resid_conv_check(i8 %t261)
%t262 = add i64 %t256, %p1
%t263 = icmp sgt i64 %p0, %t262
br label %LSJ254
LSJ254:
%t264 = phi i1 [ false, %LSL254 ], [ %t263, %LSR254 ]
br i1 %t264, label %L76, label %L78
L76:
%t265 = add i128 9223372036854775807, 0
%t266 = trunc i128 %t265 to i64
%t267 = sext i64 %t266 to i128
%t268 = icmp ne i128 %t267, %t265
%t269 = icmp eq i8 0, 1
%t270 = or i1 %t268, %t269
%t271 = zext i1 %t270 to i8
call void @resid_conv_check(i8 %t271)
ret i64 %t266
L78:
%t272 = icmp sgt i64 %p1, 0
br label %LSL273
LSL273:
br i1 %t272, label %LSR273, label %LSJ273
LSR273:
%t274 = sub i128 -9223372036854775807, 1
%t275 = add i128 %t274, 0
%t276 = trunc i128 %t275 to i64
%t277 = sext i64 %t276 to i128
%t278 = icmp ne i128 %t277, %t275
%t279 = icmp eq i8 0, 1
%t280 = or i1 %t278, %t279
%t281 = zext i1 %t280 to i8
call void @resid_conv_check(i8 %t281)
%t282 = add i64 %t276, %p1
%t283 = icmp slt i64 %p0, %t282
br label %LSJ273
LSJ273:
%t284 = phi i1 [ false, %LSL273 ], [ %t283, %LSR273 ]
br i1 %t284, label %L79, label %L81
L79:
%t285 = sub i128 -9223372036854775807, 1
%t286 = add i128 %t285, 0
%t287 = trunc i128 %t286 to i64
%t288 = sext i64 %t287 to i128
%t289 = icmp ne i128 %t288, %t286
%t290 = icmp eq i8 0, 1
%t291 = or i1 %t289, %t290
%t292 = zext i1 %t291 to i8
call void @resid_conv_check(i8 %t292)
ret i64 %t287
L81:
%t293 = sub i64 %p0, %p1
ret i64 %t293
}
define i64 @saturating_sub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_sub(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_saturating_mul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t294 = mul i64 %p0, %p1
%t295 = icmp ne i64 %p0, 0
br label %LSL296
LSL296:
br i1 %t295, label %LSR296, label %LSJ296
LSR296:
%t297 = icmp eq i64 %p0, 0
%t298 = zext i1 %t297 to i8
call void @resid_div_check(i8 %t298)
%t299 = icmp eq i64 %p0, -1
%t300 = icmp eq i64 %t294, -9223372036854775808
%t301 = and i1 %t299, %t300
%t304 = zext i1 %t301 to i8
call void @resid_overflow_check(i8 %t304)
%t302 = add i64 %p0, 0
%t303 = sdiv i64 %t294, %t302
%t305 = icmp ne i64 %t303, %p1
br label %LSL306
LSL306:
br i1 %t305, label %LSJ306, label %LSR306
LSR306:
%t307 = icmp eq i64 %p0, -1
br label %LSL308
LSL308:
br i1 %t307, label %LSR308, label %LSJ308
LSR308:
%t309 = sub i128 -9223372036854775807, 1
%t310 = add i128 %t309, 0
%t311 = trunc i128 %t310 to i64
%t312 = sext i64 %t311 to i128
%t313 = icmp ne i128 %t312, %t310
%t314 = icmp eq i8 0, 1
%t315 = or i1 %t313, %t314
%t316 = zext i1 %t315 to i8
call void @resid_conv_check(i8 %t316)
%t317 = icmp eq i64 %p1, %t311
br label %LSJ308
LSJ308:
%t318 = phi i1 [ false, %LSL308 ], [ %t317, %LSR308 ]
br label %LSJ306
LSJ306:
%t319 = phi i1 [ true, %LSL306 ], [ %t318, %LSJ308 ]
br label %LSJ296
LSJ296:
%t320 = phi i1 [ false, %LSL296 ], [ %t319, %LSJ306 ]
br label %LSL321
LSL321:
br i1 %t320, label %LSJ321, label %LSR321
LSR321:
%t322 = icmp eq i64 %p1, -1
br label %LSL323
LSL323:
br i1 %t322, label %LSR323, label %LSJ323
LSR323:
%t324 = sub i128 -9223372036854775807, 1
%t325 = add i128 %t324, 0
%t326 = trunc i128 %t325 to i64
%t327 = sext i64 %t326 to i128
%t328 = icmp ne i128 %t327, %t325
%t329 = icmp eq i8 0, 1
%t330 = or i1 %t328, %t329
%t331 = zext i1 %t330 to i8
call void @resid_conv_check(i8 %t331)
%t332 = icmp eq i64 %p0, %t326
br label %LSJ323
LSJ323:
%t333 = phi i1 [ false, %LSL323 ], [ %t332, %LSR323 ]
br label %LSJ321
LSJ321:
%t334 = phi i1 [ true, %LSL321 ], [ %t333, %LSJ323 ]
%t335 = xor i1 %t334, true
br i1 %t335, label %L82, label %L84
L82:
ret i64 %t294
L84:
%t336 = icmp sgt i64 %p0, 0
%t337 = icmp sgt i64 %p1, 0
%t338 = icmp eq i1 %t336, %t337
br i1 %t338, label %L85, label %L86
L85:
%t339 = add i128 9223372036854775807, 0
%t340 = trunc i128 %t339 to i64
%t341 = sext i64 %t340 to i128
%t342 = icmp ne i128 %t341, %t339
%t343 = icmp eq i8 0, 1
%t344 = or i1 %t342, %t343
%t345 = zext i1 %t344 to i8
call void @resid_conv_check(i8 %t345)
br label %L87
L86:
%t346 = sub i128 -9223372036854775807, 1
%t347 = add i128 %t346, 0
%t348 = trunc i128 %t347 to i64
%t349 = sext i64 %t348 to i128
%t350 = icmp ne i128 %t349, %t347
%t351 = icmp eq i8 0, 1
%t352 = or i1 %t350, %t351
%t353 = zext i1 %t352 to i8
call void @resid_conv_check(i8 %t353)
br label %L87
L87:
%t354 = phi i64 [ %t340, %L85 ], [ %t348, %L86 ]
ret i64 %t354
}
define i64 @saturating_mul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_mul(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_saturating_uadd(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t355 = add i64 %p0, %p1
%t356 = call i1 @__mruntime_rt_arith_resid__rt_ult(i64 %t355, i64 %p0)
br i1 %t356, label %L88, label %L89
L88:
br label %L90
L89:
br label %L90
L90:
%t357 = phi i64 [ -1, %L88 ], [ %t355, %L89 ]
ret i64 %t357
}
define i64 @saturating_uadd(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_uadd(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_saturating_usub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t358 = call i1 @__mruntime_rt_arith_resid__rt_ult(i64 %p0, i64 %p1)
br i1 %t358, label %L91, label %L92
L91:
br label %L93
L92:
%t359 = sub i64 %p0, %p1
br label %L93
L93:
%t360 = phi i64 [ 0, %L91 ], [ %t359, %L92 ]
ret i64 %t360
}
define i64 @saturating_usub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_usub(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_saturating_umul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t361 = icmp eq i64 %p0, 0
br label %LSL362
LSL362:
br i1 %t361, label %LSJ362, label %LSR362
LSR362:
%t363 = icmp eq i64 %p1, 0
br label %LSJ362
LSJ362:
%t364 = phi i1 [ true, %LSL362 ], [ %t363, %LSR362 ]
br i1 %t364, label %L94, label %L96
L94:
ret i64 0
L96:
%t365 = mul i64 %p0, %p1
%t366 = call i64 @__mruntime_rt_arith_resid__rt_udiv(i64 %t365, i64 %p0)
%t367 = icmp ne i64 %t366, %p1
br i1 %t367, label %L97, label %L98
L97:
br label %L99
L98:
br label %L99
L99:
%t368 = phi i64 [ -1, %L97 ], [ %t365, %L98 ]
ret i64 %t368
}
define i64 @saturating_umul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_umul(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t369 = add i64 %p0, %p1
ret i64 %t369
}
define i64 @checked_add(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_add(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_sub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t370 = sub i64 %p0, %p1
ret i64 %t370
}
define i64 @checked_sub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_sub(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_mul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t371 = mul i64 %p0, %p1
ret i64 %t371
}
define i64 @checked_mul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_mul(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_div(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t372 = icmp eq i64 %p1, 0
br i1 %t372, label %L100, label %L102
L100:
%t374 = call i64 @rt_abort(ptr @.s373)
ret i64 %t374
L102:
%t375 = icmp eq i64 %p1, 0
%t376 = zext i1 %t375 to i8
call void @resid_div_check(i8 %t376)
%t377 = icmp eq i64 %p1, -1
%t378 = icmp eq i64 %p0, -9223372036854775808
%t379 = and i1 %t377, %t378
%t382 = zext i1 %t379 to i8
call void @resid_overflow_check(i8 %t382)
%t380 = add i64 %p1, 0
%t381 = sdiv i64 %p0, %t380
ret i64 %t381
}
define i64 @checked_div(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_div(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_uadd(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t383 = add i64 %p0, %p1
ret i64 %t383
}
define i64 @checked_uadd(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_uadd(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_usub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t384 = sub i64 %p0, %p1
ret i64 %t384
}
define i64 @checked_usub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_usub(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_umul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t385 = mul i64 %p0, %p1
ret i64 %t385
}
define i64 @checked_umul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_umul(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_checked_udiv(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t386 = icmp eq i64 %p1, 0
br i1 %t386, label %L103, label %L105
L103:
%t388 = call i64 @rt_abort(ptr @.s387)
ret i64 %t388
L105:
%t389 = tail call i64 @__mruntime_rt_arith_resid__rt_udiv(i64 %p0, i64 %p1)
ret i64 %t389
}
define i64 @checked_udiv(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_udiv(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_abs_i64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t390 = icmp slt i64 %p0, 0
br i1 %t390, label %L106, label %L107
L106:
%t391 = sub i64 0, %p0
br label %L108
L107:
br label %L108
L108:
%t392 = phi i64 [ %t391, %L106 ], [ %p0, %L107 ]
ret i64 %t392
}
define i64 @abs_i64(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_abs_i64(i64 %a0)
ret i64 %r
}
define internal i64 @rt_min_i64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t393 = icmp slt i64 %p0, %p1
br i1 %t393, label %L109, label %L110
L109:
br label %L111
L110:
br label %L111
L111:
%t394 = phi i64 [ %p0, %L109 ], [ %p1, %L110 ]
ret i64 %t394
}
define i64 @min_i64(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_min_i64(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_max_i64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t395 = icmp sgt i64 %p0, %p1
br i1 %t395, label %L112, label %L113
L112:
br label %L114
L113:
br label %L114
L114:
%t396 = phi i64 [ %p0, %L112 ], [ %p1, %L113 ]
ret i64 %t396
}
define i64 @max_i64(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_max_i64(i64 %a0, i64 %a1)
ret i64 %r
}
define internal i64 @rt_clamp_i64(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t397 = icmp slt i64 %p0, %p1
br i1 %t397, label %L115, label %L117
L115:
ret i64 %p1
L117:
%t398 = icmp sgt i64 %p0, %p2
br i1 %t398, label %L118, label %L120
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
%t399 = add i64 %p0, 1
%t400 = call i64 @ld8(i64 %t399)
%t401 = icmp eq i64 %t400, 94
br i1 %t401, label %L121, label %L122
L121:
%t402 = add i64 %p0, 2
br label %L123
L122:
%t403 = add i64 %p0, 1
br label %L123
L123:
%t404 = phi i64 [ %t402, %L121 ], [ %t403, %L122 ]
%t405 = call i1 @__mruntime_rt_regex_resid__rx_class_at(i64 %t404, i64 %p1, i1 false)
%t406 = icmp ne i1 %t405, %t401
ret i1 %t406
}
define internal i1 @__mruntime_rt_regex_resid__rx_class_at(i64 %p0.in, i64 %p1.in, i1 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t425, %tco.s0 ], [ %t433, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i1 [ %p2.in, %entry ], [ %t431, %tco.s0 ], [ %t436, %tco.s1 ]
%t407 = call i64 @ld8(i64 %p0)
%t408 = icmp eq i64 %t407, 0
br label %LSL409
LSL409:
br i1 %t408, label %LSJ409, label %LSR409
LSR409:
%t410 = icmp eq i64 %t407, 93
br label %LSJ409
LSJ409:
%t411 = phi i1 [ true, %LSL409 ], [ %t410, %LSR409 ]
br i1 %t411, label %L124, label %L126
L124:
ret i1 %p2
L126:
%t412 = add i64 %p0, 1
%t413 = call i64 @ld8(i64 %t412)
%t414 = icmp eq i64 %t413, 0
br i1 %t414, label %L127, label %L128
L127:
br label %L129
L128:
%t415 = add i64 %p0, 2
%t416 = call i64 @ld8(i64 %t415)
br label %L129
L129:
%t417 = phi i64 [ 0, %L127 ], [ %t416, %L128 ]
%t418 = icmp eq i64 %t413, 45
br label %LSL419
LSL419:
br i1 %t418, label %LSR419, label %LSJ419
LSR419:
%t420 = icmp ne i64 %t417, 0
br label %LSJ419
LSJ419:
%t421 = phi i1 [ false, %LSL419 ], [ %t420, %LSR419 ]
br label %LSL422
LSL422:
br i1 %t421, label %LSR422, label %LSJ422
LSR422:
%t423 = icmp ne i64 %t417, 93
br label %LSJ422
LSJ422:
%t424 = phi i1 [ false, %LSL422 ], [ %t423, %LSR422 ]
br i1 %t424, label %L130, label %L132
L130:
%t425 = add i64 %p0, 3
br label %LSL426
LSL426:
br i1 %p2, label %LSJ426, label %LSR426
LSR426:
%t427 = icmp sge i64 %p1, %t407
br label %LSL428
LSL428:
br i1 %t427, label %LSR428, label %LSJ428
LSR428:
%t429 = icmp sle i64 %p1, %t417
br label %LSJ428
LSJ428:
%t430 = phi i1 [ false, %LSL428 ], [ %t429, %LSR428 ]
br label %LSJ426
LSJ426:
%t431 = phi i1 [ true, %LSL426 ], [ %t430, %LSJ428 ]
br label %tco.s0
tco.s0:
br label %tco.head
L132:
%t433 = add i64 %p0, 1
br label %LSL434
LSL434:
br i1 %p2, label %LSJ434, label %LSR434
LSR434:
%t435 = icmp eq i64 %t407, %p1
br label %LSJ434
LSJ434:
%t436 = phi i1 [ true, %LSL434 ], [ %t435, %LSR434 ]
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @__mruntime_rt_regex_resid__rx_atom_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t438 = call i64 @ld8(i64 %p0)
%t439 = icmp eq i64 %t438, 91
br i1 %t439, label %L133, label %L135
L133:
%t440 = add i64 %p0, 1
%t441 = call i64 @ld8(i64 %t440)
%t442 = icmp eq i64 %t441, 94
br i1 %t442, label %L136, label %L137
L136:
%t443 = add i64 %t440, 1
br label %L138
L137:
br label %L138
L138:
%t444 = phi i64 [ %t443, %L136 ], [ %t440, %L137 ]
%t445 = call i64 @ld8(i64 %t444)
%t446 = icmp eq i64 %t445, 93
br i1 %t446, label %L139, label %L140
L139:
%t447 = add i64 %t444, 1
br label %L141
L140:
br label %L141
L141:
%t448 = phi i64 [ %t447, %L139 ], [ %t444, %L140 ]
%t449 = call i64 @__mruntime_rt_regex_resid__rx_to_close(i64 %t448)
%t450 = call i64 @ld8(i64 %t449)
%t451 = icmp eq i64 %t450, 93
br i1 %t451, label %L142, label %L143
L142:
%t452 = add i64 %t449, 1
%t453 = sub i64 %t452, %p0
br label %L144
L143:
%t454 = sub i64 %t449, %p0
br label %L144
L144:
%t455 = phi i64 [ %t453, %L142 ], [ %t454, %L143 ]
ret i64 %t455
L135:
%t456 = icmp eq i64 %t438, 92
br label %LSL457
LSL457:
br i1 %t456, label %LSR457, label %LSJ457
LSR457:
%t458 = add i64 %p0, 1
%t459 = call i64 @ld8(i64 %t458)
%t460 = icmp ne i64 %t459, 0
br label %LSJ457
LSJ457:
%t461 = phi i1 [ false, %LSL457 ], [ %t460, %LSR457 ]
br i1 %t461, label %L145, label %L147
L145:
ret i64 2
L147:
ret i64 1
}
define internal i64 @__mruntime_rt_regex_resid__rx_to_close(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t467, %tco.s0 ]
%t462 = call i64 @ld8(i64 %p0)
%t463 = icmp eq i64 %t462, 0
br label %LSL464
LSL464:
br i1 %t463, label %LSJ464, label %LSR464
LSR464:
%t465 = icmp eq i64 %t462, 93
br label %LSJ464
LSJ464:
%t466 = phi i1 [ true, %LSL464 ], [ %t465, %LSR464 ]
br i1 %t466, label %L148, label %L150
L148:
ret i64 %p0
L150:
%t467 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_regex_resid__rx_one(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t469 = call i64 @ld8(i64 %p0)
%t470 = icmp eq i64 %t469, 91
br i1 %t470, label %L151, label %L153
L151:
%t471 = tail call i1 @__mruntime_rt_regex_resid__rx_class(i64 %p0, i64 %p1)
ret i1 %t471
L153:
%t472 = icmp eq i64 %t469, 92
br label %LSL473
LSL473:
br i1 %t472, label %LSR473, label %LSJ473
LSR473:
%t474 = add i64 %p0, 1
%t475 = call i64 @ld8(i64 %t474)
%t476 = icmp ne i64 %t475, 0
br label %LSJ473
LSJ473:
%t477 = phi i1 [ false, %LSL473 ], [ %t476, %LSR473 ]
br i1 %t477, label %L154, label %L156
L154:
%t478 = add i64 %p0, 1
%t479 = call i64 @ld8(i64 %t478)
%t480 = icmp eq i64 %t479, %p1
ret i1 %t480
L156:
%t481 = icmp eq i64 %t469, 46
br i1 %t481, label %L157, label %L159
L157:
%t482 = icmp ne i64 %p1, 0
ret i1 %t482
L159:
%t483 = icmp eq i64 %t469, %p1
ret i1 %t483
}
define internal i1 @__mruntime_rt_regex_resid__rx_star(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t491, %tco.s0 ]
%t484 = call i1 @__mruntime_rt_regex_resid__rx_here(i64 %p1, i64 %p2)
br i1 %t484, label %L160, label %L162
L160:
ret i1 true
L162:
%t485 = call i64 @ld8(i64 %p2)
%t486 = icmp eq i64 %t485, 0
br label %LSL487
LSL487:
br i1 %t486, label %LSJ487, label %LSR487
LSR487:
%t488 = call i1 @__mruntime_rt_regex_resid__rx_one(i64 %p0, i64 %t485)
%t489 = xor i1 %t488, true
br label %LSJ487
LSJ487:
%t490 = phi i1 [ true, %LSL487 ], [ %t489, %LSR487 ]
br i1 %t490, label %L163, label %L165
L163:
ret i1 false
L165:
%t491 = add i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_regex_resid__rx_rep(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t493 = call i64 @ld8(i64 %p3)
%t494 = icmp eq i64 %p1, 63
br i1 %t494, label %L166, label %L168
L166:
%t495 = call i1 @__mruntime_rt_regex_resid__rx_here(i64 %p2, i64 %p3)
br i1 %t495, label %L169, label %L171
L169:
ret i1 true
L171:
%t496 = icmp ne i64 %t493, 0
br label %LSL497
LSL497:
br i1 %t496, label %LSR497, label %LSJ497
LSR497:
%t498 = call i1 @__mruntime_rt_regex_resid__rx_one(i64 %p0, i64 %t493)
br label %LSJ497
LSJ497:
%t499 = phi i1 [ false, %LSL497 ], [ %t498, %LSR497 ]
br label %LSL500
LSL500:
br i1 %t499, label %LSR500, label %LSJ500
LSR500:
%t501 = add i64 %p3, 1
%t502 = call i1 @__mruntime_rt_regex_resid__rx_here(i64 %p2, i64 %t501)
br label %LSJ500
LSJ500:
%t503 = phi i1 [ false, %LSL500 ], [ %t502, %LSR500 ]
ret i1 %t503
L168:
%t504 = icmp eq i64 %p1, 43
br i1 %t504, label %L172, label %L174
L172:
%t505 = icmp eq i64 %t493, 0
br label %LSL506
LSL506:
br i1 %t505, label %LSJ506, label %LSR506
LSR506:
%t507 = call i1 @__mruntime_rt_regex_resid__rx_one(i64 %p0, i64 %t493)
%t508 = xor i1 %t507, true
br label %LSJ506
LSJ506:
%t509 = phi i1 [ true, %LSL506 ], [ %t508, %LSR506 ]
br i1 %t509, label %L175, label %L177
L175:
ret i1 false
L177:
%t510 = add i64 %p3, 1
%t511 = call i1 @__mruntime_rt_regex_resid__rx_star(i64 %p0, i64 %p2, i64 %t510)
ret i1 %t511
L174:
%t512 = call i1 @__mruntime_rt_regex_resid__rx_star(i64 %p0, i64 %p2, i64 %p3)
ret i1 %t512
}
define internal i1 @__mruntime_rt_regex_resid__rx_here(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t513 = call i64 @ld8(i64 %p0)
%t514 = icmp eq i64 %t513, 0
br i1 %t514, label %L178, label %L180
L178:
ret i1 true
L180:
%t515 = icmp eq i64 %t513, 36
br label %LSL516
LSL516:
br i1 %t515, label %LSR516, label %LSJ516
LSR516:
%t517 = add i64 %p0, 1
%t518 = call i64 @ld8(i64 %t517)
%t519 = icmp eq i64 %t518, 0
br label %LSJ516
LSJ516:
%t520 = phi i1 [ false, %LSL516 ], [ %t519, %LSR516 ]
br i1 %t520, label %L181, label %L183
L181:
%t521 = call i64 @ld8(i64 %p1)
%t522 = icmp eq i64 %t521, 0
ret i1 %t522
L183:
%t523 = call i64 @__mruntime_rt_regex_resid__rx_atom_len(i64 %p0)
%t524 = add i64 %p0, %t523
%t525 = call i64 @ld8(i64 %t524)
%t526 = icmp eq i64 %t525, 42
br label %LSL527
LSL527:
br i1 %t526, label %LSJ527, label %LSR527
LSR527:
%t528 = icmp eq i64 %t525, 43
br label %LSJ527
LSJ527:
%t529 = phi i1 [ true, %LSL527 ], [ %t528, %LSR527 ]
br label %LSL530
LSL530:
br i1 %t529, label %LSJ530, label %LSR530
LSR530:
%t531 = icmp eq i64 %t525, 63
br label %LSJ530
LSJ530:
%t532 = phi i1 [ true, %LSL530 ], [ %t531, %LSR530 ]
br i1 %t532, label %L184, label %L186
L184:
%t533 = add i64 %p0, %t523
%t534 = add i64 %t533, 1
%t535 = call i1 @__mruntime_rt_regex_resid__rx_rep(i64 %p0, i64 %t525, i64 %t534, i64 %p1)
ret i1 %t535
L186:
%t536 = call i64 @ld8(i64 %p1)
%t537 = icmp ne i64 %t536, 0
br label %LSL538
LSL538:
br i1 %t537, label %LSR538, label %LSJ538
LSR538:
%t539 = call i1 @__mruntime_rt_regex_resid__rx_one(i64 %p0, i64 %t536)
br label %LSJ538
LSJ538:
%t540 = phi i1 [ false, %LSL538 ], [ %t539, %LSR538 ]
br label %LSL541
LSL541:
br i1 %t540, label %LSR541, label %LSJ541
LSR541:
%t542 = add i64 %p0, %t523
%t543 = add i64 %p1, 1
%t544 = call i1 @__mruntime_rt_regex_resid__rx_here(i64 %t542, i64 %t543)
br label %LSJ541
LSJ541:
%t545 = phi i1 [ false, %LSL541 ], [ %t544, %LSR541 ]
ret i1 %t545
}
define internal i1 @__mruntime_rt_regex_resid__rx_search(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t549, %tco.s0 ]
%t546 = call i1 @__mruntime_rt_regex_resid__rx_here(i64 %p0, i64 %p1)
br i1 %t546, label %L187, label %L189
L187:
ret i1 true
L189:
%t547 = call i64 @ld8(i64 %p1)
%t548 = icmp eq i64 %t547, 0
br i1 %t548, label %L190, label %L192
L190:
ret i1 false
L192:
%t549 = add i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_regex_match(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t551 = icmp eq i64 %p0, 0
br label %LSL552
LSL552:
br i1 %t551, label %LSJ552, label %LSR552
LSR552:
%t553 = icmp eq i64 %p1, 0
br label %LSJ552
LSJ552:
%t554 = phi i1 [ true, %LSL552 ], [ %t553, %LSR552 ]
br i1 %t554, label %L193, label %L195
L193:
ret i64 0
L195:
%t555 = call i64 @ld8(i64 %p0)
%t556 = icmp eq i64 %t555, 94
br i1 %t556, label %L196, label %L197
L196:
%t557 = add i64 %p0, 1
%t558 = call i1 @__mruntime_rt_regex_resid__rx_here(i64 %t557, i64 %p1)
br label %L198
L197:
%t559 = call i1 @__mruntime_rt_regex_resid__rx_search(i64 %p0, i64 %p1)
br label %L198
L198:
%t560 = phi i1 [ %t558, %L196 ], [ %t559, %L197 ]
br i1 %t560, label %L199, label %L200
L199:
br label %L201
L200:
br label %L201
L201:
%t561 = phi i64 [ 1, %L199 ], [ 0, %L200 ]
ret i64 %t561
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
%t562p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.cap_stack)
%t562 = ptrtoint ptr %t562p to i64
ret i64 %t562
}
define internal i64 @__mruntime_rt_caps_resid__cap_ns() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t563p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.cap_ns)
%t563 = ptrtoint ptr %t563p to i64
ret i64 %t563
}
define internal i64 @__mruntime_rt_caps_resid__cap_depth_at() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t564p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.cap_depth)
%t564 = ptrtoint ptr %t564p to i64
ret i64 %t564
}
define internal i64 @rt_cap_enter(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t565 = call i64 @__mruntime_rt_caps_resid__cap_depth_at()
%t566 = call i64 @ld64(i64 %t565)
%t567 = icmp sge i64 %t566, 32
br i1 %t567, label %L202, label %L204
L202:
%t569 = call i64 @rt_abort(ptr @.s568)
ret i64 %t569
L204:
%t570 = icmp ne i64 %p0, 0
br label %LSL571
LSL571:
br i1 %t570, label %LSR571, label %LSJ571
LSR571:
%t572 = icmp sgt i64 %p1, 0
br label %LSJ571
LSJ571:
%t573 = phi i1 [ false, %LSL571 ], [ %t572, %LSR571 ]
br i1 %t573, label %L205, label %L206
L205:
br label %L207
L206:
br label %L207
L207:
%t574 = phi i64 [ %p1, %L205 ], [ 0, %L206 ]
%t575 = icmp sgt i64 %t574, 64
br i1 %t575, label %L208, label %L209
L208:
br label %L210
L209:
br label %L210
L210:
%t576 = phi i64 [ 64, %L208 ], [ %t574, %L209 ]
%t577 = call i64 @__mruntime_rt_caps_resid__cap_stack()
%t578 = mul i64 %t566, 512
%t579 = add i64 %t577, %t578
%t580 = mul i64 %t576, 8
%t581 = call i64 @mcopy(i64 %t579, i64 %p0, i64 %t580)
%t582 = call i64 @__mruntime_rt_caps_resid__cap_ns()
%t583 = mul i64 %t566, 8
%t584 = add i64 %t582, %t583
%t585 = call i64 @st64(i64 %t584, i64 %t576)
%t586 = call i64 @__mruntime_rt_caps_resid__cap_depth_at()
%t587 = add nsw i64 %t566, 1
%t588 = tail call i64 @st64(i64 %t586, i64 %t587)
ret i64 %t588
}
define void @resid_cap_enter(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_cap_enter(i64 %x0i, i64 %a1)
ret void
}
define internal i64 @rt_cap_leave() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t589 = call i64 @__mruntime_rt_caps_resid__cap_depth_at()
%t590 = call i64 @ld64(i64 %t589)
%t591 = icmp sgt i64 %t590, 0
br i1 %t591, label %L211, label %L212
L211:
%t592 = call i64 @__mruntime_rt_caps_resid__cap_depth_at()
%t593 = sub nsw i64 %t590, 1
%t594 = call i64 @st64(i64 %t592, i64 %t593)
br label %L213
L212:
br label %L213
L213:
%t595 = phi i64 [ %t594, %L211 ], [ 0, %L212 ]
ret i64 %t595
}
define void @resid_cap_leave() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_cap_leave()
ret void
}
define internal i1 @__mruntime_rt_caps_resid__cap_term(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t596 = icmp eq i64 %p0, 0
br label %LSL597
LSL597:
br i1 %t596, label %LSJ597, label %LSR597
LSR597:
%t598 = icmp eq i64 %p0, 40
br label %LSJ597
LSJ597:
%t599 = phi i1 [ true, %LSL597 ], [ %t598, %LSR597 ]
br label %LSL600
LSL600:
br i1 %t599, label %LSJ600, label %LSR600
LSR600:
%t601 = icmp eq i64 %p0, 58
br label %LSJ600
LSJ600:
%t602 = phi i1 [ true, %LSL600 ], [ %t601, %LSR600 ]
br label %LSL603
LSL603:
br i1 %t602, label %LSJ603, label %LSR603
LSR603:
%t604 = icmp eq i64 %p0, 33
br label %LSJ603
LSJ603:
%t605 = phi i1 [ true, %LSL603 ], [ %t604, %LSR603 ]
ret i1 %t605
}
define internal i1 @__mruntime_rt_caps_resid__cap_ro(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t606 = call i64 @__mruntime_rt_caps_resid__cap_find(i64 %p0, i64 58)
%t607 = icmp ne i64 %t606, 0
br label %LSL608
LSL608:
br i1 %t607, label %LSR608, label %LSJ608
LSR608:
%t609 = add i64 %t606, 1
%t610 = call i64 @ld8(i64 %t609)
%t611 = icmp eq i64 %t610, 114
br label %LSJ608
LSJ608:
%t612 = phi i1 [ false, %LSL608 ], [ %t611, %LSR608 ]
br label %LSL613
LSL613:
br i1 %t612, label %LSR613, label %LSJ613
LSR613:
%t614 = add i64 %t606, 2
%t615 = call i64 @ld8(i64 %t614)
%t616 = icmp eq i64 %t615, 111
br label %LSJ613
LSJ613:
%t617 = phi i1 [ false, %LSL613 ], [ %t616, %LSR613 ]
br label %LSL618
LSL618:
br i1 %t617, label %LSR618, label %LSJ618
LSR618:
%t619 = add i64 %t606, 3
%t620 = call i64 @ld8(i64 %t619)
%t621 = icmp eq i64 %t620, 0
br label %LSJ618
LSJ618:
%t622 = phi i1 [ false, %LSL618 ], [ %t621, %LSR618 ]
ret i1 %t622
}
define internal i64 @__mruntime_rt_caps_resid__cap_find(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t626, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%t623 = call i64 @ld8(i64 %p0)
%t624 = icmp eq i64 %t623, %p1
br i1 %t624, label %L214, label %L216
L214:
ret i64 %p0
L216:
%t625 = icmp eq i64 %t623, 0
br i1 %t625, label %L217, label %L219
L217:
ret i64 0
L219:
%t626 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_caps_resid__cap_same_family(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t649, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t650, %tco.s0 ]
%t628 = icmp eq i64 %p0, 0
br label %LSL629
LSL629:
br i1 %t628, label %LSJ629, label %LSR629
LSR629:
%t630 = icmp eq i64 %p1, 0
br label %LSJ629
LSJ629:
%t631 = phi i1 [ true, %LSL629 ], [ %t630, %LSR629 ]
br i1 %t631, label %L220, label %L222
L220:
ret i1 false
L222:
%t632 = call i64 @ld8(i64 %p0)
%t633 = call i64 @ld8(i64 %p1)
%t634 = icmp ne i64 %t632, 0
br label %LSL635
LSL635:
br i1 %t634, label %LSR635, label %LSJ635
LSR635:
%t636 = icmp ne i64 %t633, 0
br label %LSJ635
LSJ635:
%t637 = phi i1 [ false, %LSL635 ], [ %t636, %LSR635 ]
br label %LSL638
LSL638:
br i1 %t637, label %LSR638, label %LSJ638
LSR638:
%t639 = call i1 @__mruntime_rt_caps_resid__cap_term(i64 %t632)
%t640 = xor i1 %t639, true
br label %LSJ638
LSJ638:
%t641 = phi i1 [ false, %LSL638 ], [ %t640, %LSR638 ]
br label %LSL642
LSL642:
br i1 %t641, label %LSR642, label %LSJ642
LSR642:
%t643 = call i1 @__mruntime_rt_caps_resid__cap_term(i64 %t633)
%t644 = xor i1 %t643, true
br label %LSJ642
LSJ642:
%t645 = phi i1 [ false, %LSL642 ], [ %t644, %LSR642 ]
br label %LSL646
LSL646:
br i1 %t645, label %LSR646, label %LSJ646
LSR646:
%t647 = icmp eq i64 %t632, %t633
br label %LSJ646
LSJ646:
%t648 = phi i1 [ false, %LSL646 ], [ %t647, %LSR646 ]
br i1 %t648, label %L223, label %L225
L223:
%t649 = add i64 %p0, 1
%t650 = add i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L225:
%t652 = call i1 @__mruntime_rt_caps_resid__cap_term(i64 %t632)
br label %LSL653
LSL653:
br i1 %t652, label %LSR653, label %LSJ653
LSR653:
%t654 = call i1 @__mruntime_rt_caps_resid__cap_term(i64 %t633)
br label %LSJ653
LSJ653:
%t655 = phi i1 [ false, %LSL653 ], [ %t654, %LSR653 ]
ret i1 %t655
}
define internal i1 @__mruntime_rt_caps_resid__cap_in_frame(i64 %p0.in, i64 %p1.in, i64 %p2.in, i1 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t674, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i1 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t656 = call i64 @__mruntime_rt_caps_resid__cap_ns()
%t657 = mul i64 %p0, 8
%t658 = add i64 %t656, %t657
%t659 = call i64 @ld64(i64 %t658)
%t660 = icmp sge i64 %p1, %t659
br i1 %t660, label %L226, label %L228
L226:
ret i1 false
L228:
%t661 = call i64 @__mruntime_rt_caps_resid__cap_stack()
%t662 = mul i64 %p0, 512
%t663 = add i64 %t661, %t662
%t664 = mul i64 %p1, 8
%t665 = add i64 %t663, %t664
%t666 = call i64 @ld64(i64 %t665)
%t667 = call i1 @__mruntime_rt_caps_resid__cap_same_family(i64 %t666, i64 %p2)
br label %LSL668
LSL668:
br i1 %t667, label %LSR668, label %LSJ668
LSR668:
br label %LSL669
LSL669:
br i1 %p3, label %LSR669, label %LSJ669
LSR669:
%t670 = call i1 @__mruntime_rt_caps_resid__cap_ro(i64 %t666)
br label %LSJ669
LSJ669:
%t671 = phi i1 [ false, %LSL669 ], [ %t670, %LSR669 ]
%t672 = xor i1 %t671, true
br label %LSJ668
LSJ668:
%t673 = phi i1 [ false, %LSL668 ], [ %t672, %LSJ669 ]
br i1 %t673, label %L229, label %L231
L229:
ret i1 true
L231:
%t674 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_caps_resid__cap_all_frames(i64 %p0.in, i64 %p1.in, i64 %p2.in, i1 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t679, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i1 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t676 = icmp sge i64 %p0, %p1
br i1 %t676, label %L232, label %L234
L232:
ret i1 true
L234:
%t677 = call i1 @__mruntime_rt_caps_resid__cap_in_frame(i64 %p0, i64 0, i64 %p2, i1 %p3)
%t678 = xor i1 %t677, true
br i1 %t678, label %L235, label %L237
L235:
ret i1 false
L237:
%t679 = add nsw i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_caps_resid__cap_granted(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t681 = call i64 @__mruntime_rt_caps_resid__cap_depth_at()
%t682 = call i64 @ld64(i64 %t681)
%t683 = icmp eq i64 %t682, 0
br i1 %t683, label %L238, label %L240
L238:
ret i1 true
L240:
%t684 = call i64 @c_strlen(i64 %p0)
%t685 = icmp sgt i64 %t684, 0
br label %LSL686
LSL686:
br i1 %t685, label %LSR686, label %LSJ686
LSR686:
%t687 = add i64 %p0, %t684
%t688 = sub nsw i64 %t687, 1
%t689 = call i64 @ld8(i64 %t688)
%t690 = icmp eq i64 %t689, 33
br label %LSJ686
LSJ686:
%t691 = phi i1 [ false, %LSL686 ], [ %t690, %LSR686 ]
%t692 = call i1 @__mruntime_rt_caps_resid__cap_all_frames(i64 0, i64 %t682, i64 %p0, i1 %t691)
ret i1 %t692
}
define internal i64 @rt_cap_granted(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t693 = call i1 @__mruntime_rt_caps_resid__cap_granted(i64 %p0)
br i1 %t693, label %L241, label %L242
L241:
br label %L243
L242:
br label %L243
L243:
%t694 = phi i64 [ 1, %L241 ], [ 0, %L242 ]
ret i64 %t694
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
%t695 = call i1 @__mruntime_rt_caps_resid__cap_granted(i64 %p0)
br i1 %t695, label %L244, label %L246
L244:
ret i64 0
L246:
%t696 = call i64 @c_strlen(i64 %p0)
%t697 = icmp sgt i64 %t696, 0
br label %LSL698
LSL698:
br i1 %t697, label %LSR698, label %LSJ698
LSR698:
%t699 = add i64 %p0, %t696
%t700 = sub nsw i64 %t699, 1
%t701 = call i64 @ld8(i64 %t700)
%t702 = icmp eq i64 %t701, 33
br label %LSJ698
LSJ698:
%t703 = phi i1 [ false, %LSL698 ], [ %t702, %LSR698 ]
br i1 %t703, label %L247, label %L248
L247:
%t704 = sub i64 %t696, 1
br label %L249
L248:
br label %L249
L249:
%t705 = phi i64 [ %t704, %L247 ], [ %t696, %L248 ]
%t707 = ptrtoint ptr @.s706 to i64
br i1 %t703, label %L250, label %L251
L250:
%t709 = ptrtoint ptr @.s708 to i64
br label %L252
L251:
%t711 = ptrtoint ptr @.s710 to i64
br label %L252
L252:
%t712 = phi i64 [ %t709, %L250 ], [ %t711, %L251 ]
%t713 = call i64 @c_strlen(i64 %t707)
%t714 = call i64 @c_strlen(i64 %t712)
%t715 = add i64 %t713, %t705
%t716 = add i64 %t715, %t714
%t717 = add i64 %t716, 1
%t718 = call i64 @xmalloc(i64 %t717)
%t719 = call i64 @mcopy(i64 %t718, i64 %t707, i64 %t713)
%t720 = add i64 %t718, %t713
%t721 = call i64 @mcopy(i64 %t720, i64 %p0, i64 %t705)
%t722 = add i64 %t718, %t713
%t723 = add i64 %t722, %t705
%t724 = add i64 %t714, 1
%t725 = call i64 @mcopy(i64 %t723, i64 %t712, i64 %t724)
%t726 = tail call i64 @rt_abort_at(i64 %t718)
ret i64 %t726
}
define void @resid_cap_check(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_cap_check(i64 %x0i)
ret void
}
define internal i64 @rt_str_concat(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t727 = call i64 @c_strlen(i64 %p0)
%t728 = call i64 @c_strlen(i64 %p1)
%t729 = add i64 %t727, %t728
%t730 = add i64 %t729, 1
%t731 = call i64 @ralloc(i64 %t730)
%t732 = call i64 @mcopy(i64 %t731, i64 %p0, i64 %t727)
%t733 = add i64 %t731, %t727
%t734 = add i64 %t728, 1
%t735 = call i64 @mcopy(i64 %t733, i64 %p1, i64 %t734)
ret i64 %t731
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
%t736 = call i64 @c_strcmp(i64 %p0, i64 %p1)
%t737 = icmp eq i64 %t736, 0
br i1 %t737, label %L253, label %L254
L253:
br label %L255
L254:
br label %L255
L255:
%t738 = phi i64 [ 1, %L253 ], [ 0, %L254 ]
ret i64 %t738
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
%t739 = add i64 16, %p0
%t740 = add i64 %t739, 1
%t741 = call i64 @xmalloc(i64 %t740)
%t742 = call i64 @st64(i64 %t741, i64 0)
%t743 = add i64 %t741, 8
%t744 = call i64 @st64(i64 %t743, i64 %p0)
%t745 = add i64 %t741, 16
ret i64 %t745
}
define internal i64 @rt_sacc_from(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t746 = call i64 @c_strlen(i64 %p0)
%t747 = icmp slt i64 %t746, 32
br i1 %t747, label %L256, label %L257
L256:
br label %L258
L257:
%t748 = mul i64 %t746, 2
br label %L258
L258:
%t749 = phi i64 [ 64, %L256 ], [ %t748, %L257 ]
%t750 = call i64 @__mruntime_rt_text_resid__sacc_alloc(i64 %t749)
%t751 = add i64 %t746, 1
%t752 = call i64 @mcopy(i64 %t750, i64 %p0, i64 %t751)
%t753 = sub i64 %t750, 16
%t754 = call i64 @st64(i64 %t753, i64 %t746)
ret i64 %t750
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
%t755 = sub i64 %p0, 16
%t756 = call i64 @ld64(i64 %t755)
%t757 = sub i64 %p0, 8
%t758 = call i64 @ld64(i64 %t757)
%t759 = add i64 %t756, %p1
%t760 = icmp sle i64 %t759, %t758
br i1 %t760, label %L259, label %L261
L259:
ret i64 %p0
L261:
%t761 = mul i64 %t758, 2
%t762 = add i64 %t756, %p1
%t763 = icmp slt i64 %t761, %t762
br i1 %t763, label %L262, label %L263
L262:
%t764 = add i64 %t756, %p1
br label %L264
L263:
%t765 = mul i64 %t758, 2
br label %L264
L264:
%t766 = phi i64 [ %t764, %L262 ], [ %t765, %L263 ]
%t767 = call i64 @str_index_forget(i64 %p0)
%t768 = sub i64 %p0, 16
%t769 = add i64 16, %t766
%t770 = add i64 %t769, 1
%t771 = call i64 @xrealloc(i64 %t768, i64 %t770)
%t772 = add i64 %t771, 8
%t773 = call i64 @st64(i64 %t772, i64 %t766)
%t774 = add i64 %t771, 16
ret i64 %t774
}
define internal i64 @rt_sacc_append(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t775 = call i64 @c_strlen(i64 %p1)
%t776 = call i64 @__mruntime_rt_text_resid__sacc_reserve(i64 %p0, i64 %t775)
%t777 = sub i64 %t776, 16
%t778 = call i64 @ld64(i64 %t777)
%t779 = add i64 %t776, %t778
%t780 = add i64 %t775, 1
%t781 = call i64 @mcopy(i64 %t779, i64 %p1, i64 %t780)
%t782 = sub i64 %t776, 16
%t783 = add i64 %t778, %t775
%t784 = call i64 @st64(i64 %t782, i64 %t783)
%t785 = add i64 %t784, %t776
ret i64 %t785
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
%t786p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.sacc_itoa)
%t786 = ptrtoint ptr %t786p to i64
%t787 = call i64 @itoa_into(i64 %t786, i64 %p1)
%t788 = call i64 @__mruntime_rt_text_resid__sacc_reserve(i64 %p0, i64 %t787)
%t789 = sub i64 %t788, 16
%t790 = call i64 @ld64(i64 %t789)
%t791 = add i64 %t788, %t790
%t792 = call i64 @mcopy(i64 %t791, i64 %t786, i64 %t787)
%t793 = add i64 %t788, %t790
%t794 = add i64 %t793, %t787
%t795 = call i64 @st8(i64 %t794, i64 0)
%t796 = sub i64 %t788, 16
%t797 = add i64 %t790, %t787
%t798 = call i64 @st64(i64 %t796, i64 %t797)
%t799 = add i64 %t798, %t788
ret i64 %t799
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
%t800 = icmp slt i64 %p1, 0
br i1 %t800, label %L265, label %L266
L265:
%t801 = sub i64 0, %p1
br label %L267
L266:
br label %L267
L267:
%t802 = phi i64 [ %t801, %L265 ], [ %p1, %L266 ]
%t803 = call i64 @__mruntime_rt_text_resid__udigits(i64 %t802, i64 1)
br i1 %t800, label %L268, label %L269
L268:
%t804 = call i64 @st8(i64 %p0, i64 45)
%t805 = add i64 %t804, 1
br label %L270
L269:
br label %L270
L270:
%t806 = phi i64 [ %t805, %L268 ], [ 0, %L269 ]
%t807 = add i64 %p0, %t806
%t808 = add i64 %t807, %t803
%t809 = sub i64 %t808, 1
%t810 = call i64 @__mruntime_rt_text_resid__uput(i64 %t809, i64 %t802)
%t811 = add i64 %t806, %t803
ret i64 %t811
}
define internal i64 @__mruntime_rt_text_resid__udigits(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t812, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t814, %tco.s0 ]
%t812 = call i64 @__mruntime_rt_text_resid__udiv10(i64 %p0)
%t813 = icmp eq i64 %t812, 0
br i1 %t813, label %L271, label %L273
L271:
ret i64 %p1
L273:
%t814 = add i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__udiv10(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t816 = call i64 @udiv(i64 %p0, i64 10)
ret i64 %t816
}
define internal i64 @__mruntime_rt_text_resid__uput(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t823, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t817, %tco.s0 ]
%t817 = call i64 @__mruntime_rt_text_resid__udiv10(i64 %p1)
%t818 = mul i64 %t817, 10
%t819 = sub i64 %p1, %t818
%t820 = add i64 48, %t819
%t821 = call i64 @st8(i64 %p0, i64 %t820)
%t822 = icmp eq i64 %t817, 0
br i1 %t822, label %L274, label %L276
L274:
ret i64 0
L276:
%t823 = sub i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_to_fixed(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t825 = icmp eq i64 %p2, 0
br i1 %t825, label %L277, label %L279
L277:
ret i64 0
L279:
%t826 = sub i64 %p2, 1
%t827 = call i64 @__mruntime_rt_text_resid__fixed_copy(i64 %p0, i64 %p1, i64 0, i64 %t826)
%t828 = add i64 %p1, %t827
%t829 = call i64 @ld8(i64 %t828)
%t830 = icmp ne i64 %t829, 0
br label %LSL831
LSL831:
br i1 %t830, label %LSR831, label %LSJ831
LSR831:
%t832 = add i64 %p1, %t827
%t833 = call i64 @ld8(i64 %t832)
%t834 = and i64 %t833, 192
%t835 = icmp eq i64 %t834, 128
br label %LSJ831
LSJ831:
%t836 = phi i1 [ false, %LSL831 ], [ %t835, %LSR831 ]
br i1 %t836, label %L280, label %L281
L280:
%t837 = call i64 @__mruntime_rt_text_resid__fixed_back(i64 %p1, i64 %t827)
br label %L282
L281:
br label %L282
L282:
%t838 = phi i64 [ %t837, %L280 ], [ %t827, %L281 ]
%t839 = add i64 %p0, %t838
%t840 = call i64 @st8(i64 %t839, i64 0)
ret i64 %t838
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t847, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t841 = icmp sge i64 %p2, %p3
br i1 %t841, label %L283, label %L285
L283:
ret i64 %p2
L285:
%t842 = add i64 %p1, %p2
%t843 = call i64 @ld8(i64 %t842)
%t844 = icmp eq i64 %t843, 0
br i1 %t844, label %L286, label %L288
L286:
ret i64 %p2
L288:
%t845 = add i64 %p0, %p2
%t846 = call i64 @st8(i64 %t845, i64 %t843)
%t847 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__fixed_back(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t856, %tco.s0 ]
%t849 = icmp sgt i64 %p1, 0
br label %LSL850
LSL850:
br i1 %t849, label %LSR850, label %LSJ850
LSR850:
%t851 = add i64 %p0, %p1
%t852 = call i64 @ld8(i64 %t851)
%t853 = and i64 %t852, 192
%t854 = icmp eq i64 %t853, 128
br label %LSJ850
LSJ850:
%t855 = phi i1 [ false, %LSL850 ], [ %t854, %LSR850 ]
br i1 %t855, label %L289, label %L291
L289:
%t856 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L291:
ret i64 %p1
}
define internal i64 @rt_bytes_to_fixed(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t858 = icmp eq i64 %p2, 0
br i1 %t858, label %L292, label %L294
L292:
ret i64 0
L294:
%t859 = call i64 @__mruntime_rt_text_resid__fixed_copy(i64 %p0, i64 %p1, i64 0, i64 %p2)
ret i64 %t859
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
%t860 = icmp slt i64 %p0, 128
br i1 %t860, label %L295, label %L297
L295:
ret i64 1
L297:
%t861 = and i64 %p0, 224
%t862 = icmp eq i64 %t861, 192
br i1 %t862, label %L298, label %L300
L298:
ret i64 2
L300:
%t863 = and i64 %p0, 240
%t864 = icmp eq i64 %t863, 224
br i1 %t864, label %L301, label %L303
L301:
ret i64 3
L303:
%t865 = and i64 %p0, 248
%t866 = icmp eq i64 %t865, 240
br i1 %t866, label %L304, label %L306
L304:
ret i64 4
L306:
ret i64 1
}
define internal i64 @utf8_len_at(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t867 = call i64 @ld8(i64 %p0)
%t868 = call i64 @utf8_seq_len(i64 %t867)
%t869 = call i64 @__mruntime_rt_text_resid__utf8_cont(i64 %p0, i64 1, i64 %t868)
ret i64 %t869
}
define internal i64 @__mruntime_rt_text_resid__utf8_cont(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t875, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t870 = icmp sge i64 %p1, %p2
br i1 %t870, label %L307, label %L309
L307:
ret i64 %p2
L309:
%t871 = add i64 %p0, %p1
%t872 = call i64 @ld8(i64 %t871)
%t873 = and i64 %t872, 192
%t874 = icmp ne i64 %t873, 128
br i1 %t874, label %L310, label %L312
L310:
ret i64 %p1
L312:
%t875 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @utf8_decode(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t877 = call i64 @ld8(i64 %p0)
%t878 = icmp eq i64 %p1, 1
br i1 %t878, label %L313, label %L315
L313:
ret i64 %t877
L315:
%t879 = icmp eq i64 %p1, 2
br i1 %t879, label %L316, label %L318
L316:
%t880 = and i64 %t877, 31
%t881 = shl i64 %t880, 6
%t882 = add i64 %p0, 1
%t883 = call i64 @ld8(i64 %t882)
%t884 = and i64 %t883, 63
%t885 = or i64 %t881, %t884
ret i64 %t885
L318:
%t886 = icmp eq i64 %p1, 3
br i1 %t886, label %L319, label %L321
L319:
%t887 = and i64 %t877, 15
%t888 = shl i64 %t887, 12
%t889 = add i64 %p0, 1
%t890 = call i64 @ld8(i64 %t889)
%t891 = and i64 %t890, 63
%t892 = shl i64 %t891, 6
%t893 = or i64 %t888, %t892
%t894 = add i64 %p0, 2
%t895 = call i64 @ld8(i64 %t894)
%t896 = and i64 %t895, 63
%t897 = or i64 %t893, %t896
ret i64 %t897
L321:
%t898 = and i64 %t877, 7
%t899 = shl i64 %t898, 18
%t900 = add i64 %p0, 1
%t901 = call i64 @ld8(i64 %t900)
%t902 = and i64 %t901, 63
%t903 = shl i64 %t902, 12
%t904 = or i64 %t899, %t903
%t905 = add i64 %p0, 2
%t906 = call i64 @ld8(i64 %t905)
%t907 = and i64 %t906, 63
%t908 = shl i64 %t907, 6
%t909 = or i64 %t904, %t908
%t910 = add i64 %p0, 3
%t911 = call i64 @ld8(i64 %t910)
%t912 = and i64 %t911, 63
%t913 = or i64 %t909, %t912
ret i64 %t913
}
define internal i64 @utf8_encode(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t914 = icmp slt i64 %p0, 128
br i1 %t914, label %L322, label %L324
L322:
%t915 = call i64 @st8(i64 %p1, i64 %p0)
%t916 = add i64 %t915, 1
ret i64 %t916
L324:
%t917 = icmp slt i64 %p0, 2048
br i1 %t917, label %L325, label %L327
L325:
%t918 = ashr i64 %p0, 6
%t919 = or i64 192, %t918
%t920 = call i64 @st8(i64 %p1, i64 %t919)
%t921 = add i64 %p1, 1
%t922 = and i64 %p0, 63
%t923 = or i64 128, %t922
%t924 = call i64 @st8(i64 %t921, i64 %t923)
%t925 = add i64 %t924, 2
ret i64 %t925
L327:
%t926 = icmp slt i64 %p0, 65536
br i1 %t926, label %L328, label %L330
L328:
%t927 = ashr i64 %p0, 12
%t928 = or i64 224, %t927
%t929 = call i64 @st8(i64 %p1, i64 %t928)
%t930 = add i64 %p1, 1
%t931 = ashr i64 %p0, 6
%t932 = and i64 %t931, 63
%t933 = or i64 128, %t932
%t934 = call i64 @st8(i64 %t930, i64 %t933)
%t935 = add i64 %p1, 2
%t936 = and i64 %p0, 63
%t937 = or i64 128, %t936
%t938 = call i64 @st8(i64 %t935, i64 %t937)
%t939 = add i64 %t938, 3
ret i64 %t939
L330:
%t940 = ashr i64 %p0, 18
%t941 = or i64 240, %t940
%t942 = call i64 @st8(i64 %p1, i64 %t941)
%t943 = add i64 %p1, 1
%t944 = ashr i64 %p0, 12
%t945 = and i64 %t944, 63
%t946 = or i64 128, %t945
%t947 = call i64 @st8(i64 %t943, i64 %t946)
%t948 = add i64 %p1, 2
%t949 = ashr i64 %p0, 6
%t950 = and i64 %t949, 63
%t951 = or i64 128, %t950
%t952 = call i64 @st8(i64 %t948, i64 %t951)
%t953 = add i64 %p1, 3
%t954 = and i64 %p0, 63
%t955 = or i64 128, %t954
%t956 = call i64 @st8(i64 %t953, i64 %t955)
%t957 = add i64 %t956, 4
ret i64 %t957
}
define internal i64 @rt_str_from_code(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t958p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.from_code)
%t958 = ptrtoint ptr %t958p to i64
%t959 = call i64 @utf8_encode(i64 %p0, i64 %t958)
%t960 = call i64 @cstr_from__rs22(i64 %t958, i64 %t959)
ret i64 %t960
}
define ptr @str_from_code(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_str_from_code(i64 %a0)
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @__mruntime_rt_text_resid__idx_slots() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t961p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.str_slots)
%t961 = ptrtoint ptr %t961p to i64
ret i64 %t961
}
define internal i64 @__mruntime_rt_text_resid__idx_small() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t962 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t963 = add i64 %t962, 640
ret i64 %t963
}
define internal i64 @__mruntime_rt_text_resid__idx_scratch() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t964 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t965 = add i64 %t964, 680
ret i64 %t965
}
define internal i64 @__mruntime_rt_text_resid__idx_state() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t966p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.str_state)
%t966 = ptrtoint ptr %t966p to i64
ret i64 %t966
}
define internal i64 @__mruntime_rt_text_resid__sl_s(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t967 = tail call i64 @ld64(i64 %p0)
ret i64 %t967
}
define internal i64 @__mruntime_rt_text_resid__sl_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t968 = add i64 %p0, 8
%t969 = tail call i64 @ld64(i64 %t968)
ret i64 %t969
}
define internal i64 @__mruntime_rt_text_resid__sl_off(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t970 = add i64 %p0, 16
%t971 = tail call i64 @ld64(i64 %t970)
ret i64 %t971
}
define internal i64 @__mruntime_rt_text_resid__sl_blen(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t972 = add i64 %p0, 32
%t973 = tail call i64 @ld64(i64 %t972)
ret i64 %t973
}
define internal i64 @slot_off(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t974 = call i64 @__mruntime_rt_text_resid__sl_off(i64 %p0)
%t975 = icmp eq i64 %t974, 0
br i1 %t975, label %L331, label %L333
L331:
ret i64 %p1
L333:
%t976 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %p0)
%t977 = ashr i64 %p1, 4
%t978 = mul i64 %t977, 8
%t979 = add i64 %t974, %t978
%t980 = call i64 @ld64(i64 %t979)
%t981 = add i64 %t976, %t980
%t982 = and i64 %p1, 15
%t983 = call i64 @__mruntime_rt_text_resid__slot_walk(i64 %t981, i64 %t982)
%t984 = sub i64 %t983, %t976
ret i64 %t984
}
define internal i64 @__mruntime_rt_text_resid__slot_walk(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t987, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t988, %tco.s0 ]
%t985 = icmp sle i64 %p1, 0
br i1 %t985, label %L334, label %L336
L334:
ret i64 %p0
L336:
%t986 = call i64 @utf8_len_at(i64 %p0)
%t987 = add i64 %p0, %t986
%t988 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_text_resid__any_high(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t992, %tco.s0 ], [ %t1010, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1007, %tco.s0 ], [ %t1013, %tco.s1 ]
%t990 = add i64 %p1, 32
%t991 = icmp sle i64 %t990, %p2
br i1 %t991, label %L337, label %L339
L337:
%t992 = add i64 %p1, 32
%t993 = add i64 %p0, %p1
%t994 = call i64 @ld64(i64 %t993)
%t995 = or i64 %p3, %t994
%t996 = add i64 %p0, %p1
%t997 = add i64 %t996, 8
%t998 = call i64 @ld64(i64 %t997)
%t999 = or i64 %t995, %t998
%t1000 = add i64 %p0, %p1
%t1001 = add i64 %t1000, 16
%t1002 = call i64 @ld64(i64 %t1001)
%t1003 = or i64 %t999, %t1002
%t1004 = add i64 %p0, %p1
%t1005 = add i64 %t1004, 24
%t1006 = call i64 @ld64(i64 %t1005)
%t1007 = or i64 %t1003, %t1006
br label %tco.s0
tco.s0:
br label %tco.head
L339:
%t1009 = icmp slt i64 %p1, %p2
br i1 %t1009, label %L340, label %L342
L340:
%t1010 = add nsw i64 %p1, 1
%t1011 = add i64 %p0, %p1
%t1012 = call i64 @ld8(i64 %t1011)
%t1013 = or i64 %p3, %t1012
br label %tco.s1
tco.s1:
br label %tco.head
L342:
%t1015 = add i128 -9187201950435737472, 0
%t1016 = trunc i128 %t1015 to i64
%t1017 = sext i64 %t1016 to i128
%t1018 = icmp ne i128 %t1017, %t1015
%t1019 = icmp eq i8 0, 1
%t1020 = or i1 %t1018, %t1019
%t1021 = zext i1 %t1020 to i8
call void @resid_conv_check(i8 %t1021)
%t1022 = sext i64 %t1016 to i128
%t1023 = sext i64 %p3 to i128
%t1024 = and i128 %t1023, %t1022
%t1025 = icmp ne i128 %t1024, 0
ret i1 %t1025
}
define internal i64 @__mruntime_rt_text_resid__cp_count(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1029, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1030, %tco.s0 ]
%t1026 = call i64 @ld8(i64 %p0)
%t1027 = icmp eq i64 %t1026, 0
br i1 %t1027, label %L343, label %L345
L343:
ret i64 %p1
L345:
%t1028 = call i64 @utf8_len_at(i64 %p0)
%t1029 = add i64 %p0, %t1028
%t1030 = add i64 %p1, 1
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t1049, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1050, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t1032 = icmp sge i64 %p3, %p4
br i1 %t1032, label %L346, label %L348
L346:
%t1033 = and i64 %p4, 15
%t1034 = icmp eq i64 %t1033, 0
br i1 %t1034, label %L349, label %L351
L349:
%t1035 = ashr i64 %p4, 4
%t1036 = mul i64 %t1035, 8
%t1037 = add i64 %p1, %t1036
%t1038 = sub i64 %p2, %p0
%t1039 = call i64 @st64(i64 %t1037, i64 %t1038)
ret i64 %t1039
L351:
ret i64 0
L348:
%t1040 = and i64 %p3, 15
%t1041 = icmp eq i64 %t1040, 0
br i1 %t1041, label %L352, label %L353
L352:
%t1042 = ashr i64 %p3, 4
%t1043 = mul i64 %t1042, 8
%t1044 = add i64 %p1, %t1043
%t1045 = sub i64 %p2, %p0
%t1046 = call i64 @st64(i64 %t1044, i64 %t1045)
br label %L354
L353:
br label %L354
L354:
%t1047 = phi i64 [ %t1046, %L352 ], [ 0, %L353 ]
%t1048 = call i64 @utf8_len_at(i64 %p2)
%t1049 = add i64 %p2, %t1048
%t1050 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__idx_build(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1052 = call i64 @__mruntime_rt_text_resid__sl_off(i64 %p1)
%t1053 = icmp ne i64 %t1052, 0
br i1 %t1053, label %L355, label %L356
L355:
%t1054 = call i64 @c_free(i64 %t1052)
%t1055 = add i64 %p1, 16
%t1056 = call i64 @st64(i64 %t1055, i64 0)
%t1057 = add i64 %t1054, %t1056
br label %L357
L356:
br label %L357
L357:
%t1058 = phi i64 [ %t1057, %L355 ], [ 0, %L356 ]
%t1059 = call i64 @c_strlen(i64 %p0)
%t1060 = add i64 %p1, 32
%t1061 = call i64 @st64(i64 %t1060, i64 %t1059)
%t1062 = call i64 @st64(i64 %p1, i64 %p0)
%t1063 = call i1 @__mruntime_rt_text_resid__any_high(i64 %p0, i64 0, i64 %t1059, i64 0)
%t1064 = xor i1 %t1063, true
br i1 %t1064, label %L358, label %L360
L358:
%t1065 = add i64 %p1, 8
%t1066 = tail call i64 @st64(i64 %t1065, i64 %t1059)
ret i64 %t1066
L360:
%t1067 = call i64 @__mruntime_rt_text_resid__cp_count(i64 %p0, i64 0)
%t1068 = add i64 %p1, 8
%t1069 = call i64 @st64(i64 %t1068, i64 %t1067)
%t1070 = ashr i64 %t1067, 4
%t1071 = add i64 %t1070, 1
%t1072 = mul i64 %t1071, 8
%t1073 = call i64 @xmalloc(i64 %t1072)
%t1074 = call i64 @__mruntime_rt_text_resid__fill_off(i64 %p0, i64 %t1073, i64 %p0, i64 0, i64 %t1067)
%t1075 = add i64 %p1, 16
%t1076 = tail call i64 @st64(i64 %t1075, i64 %t1073)
ret i64 %t1076
}
define internal i64 @__mruntime_rt_text_resid__idx_ready() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1077 = call i64 @__mruntime_rt_text_resid__idx_state()
%t1078 = add i64 %t1077, 8
%t1079 = call i64 @ld64(i64 %t1078)
%t1080 = icmp ne i64 %t1079, 0
br i1 %t1080, label %L361, label %L363
L361:
ret i64 0
L363:
%t1081 = call i64 @__mruntime_rt_text_resid__idx_clear_all(i64 0)
%t1082 = call i64 @__mruntime_rt_text_resid__idx_state()
%t1083 = add i64 %t1082, 8
%t1084 = call i64 @st64(i64 %t1083, i64 1)
ret i64 %t1084
}
define internal i64 @__mruntime_rt_text_resid__idx_clear_all(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1096, %tco.s0 ]
%t1085 = icmp sge i64 %p0, 16
br i1 %t1085, label %L364, label %L366
L364:
ret i64 0
L366:
%t1086 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t1087 = mul i64 %p0, 40
%t1088 = add i64 %t1086, %t1087
%t1089 = call i64 @st64(i64 %t1088, i64 0)
%t1090 = add i64 %t1088, 8
%t1091 = call i64 @st64(i64 %t1090, i64 -1)
%t1092 = add i64 %t1088, 16
%t1093 = call i64 @st64(i64 %t1092, i64 0)
%t1094 = add i64 %t1088, 24
%t1095 = call i64 @st64(i64 %t1094, i64 0)
%t1096 = add nsw i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_text_resid__str_short(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1102, %tco.s0 ]
%t1098 = icmp sge i64 %p1, 256
br i1 %t1098, label %L367, label %L369
L367:
ret i1 false
L369:
%t1099 = add i64 %p0, %p1
%t1100 = call i64 @ld8(i64 %t1099)
%t1101 = icmp eq i64 %t1100, 0
br i1 %t1101, label %L370, label %L372
L370:
ret i1 true
L372:
%t1102 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__idx_find(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1110, %tco.s0 ]
%t1104 = icmp sge i64 %p1, 16
br i1 %t1104, label %L373, label %L375
L373:
ret i64 0
L375:
%t1105 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t1106 = mul i64 %p1, 40
%t1107 = add i64 %t1105, %t1106
%t1108 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1107)
%t1109 = icmp eq i64 %t1108, %p0
br i1 %t1109, label %L376, label %L378
L376:
ret i64 %t1107
L378:
%t1110 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__idx_victim(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1121, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1122, %tco.s0 ]
%t1112 = icmp sge i64 %p0, 16
br i1 %t1112, label %L379, label %L381
L379:
ret i64 %p1
L381:
%t1113 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t1114 = mul i64 %p0, 40
%t1115 = add i64 %t1113, %t1114
%t1116 = add i64 %t1115, 24
%t1117 = call i64 @ld64(i64 %t1116)
%t1118 = add i64 %p1, 24
%t1119 = call i64 @ld64(i64 %t1118)
%t1120 = icmp slt i64 %t1117, %t1119
%t1121 = add nsw i64 %p0, 1
br i1 %t1120, label %L382, label %L383
L382:
br label %L384
L383:
br label %L384
L384:
%t1122 = phi i64 [ %t1115, %L382 ], [ %p1, %L383 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__idx_slot_slow(i64 %p0) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1124 = call i64 @__mruntime_rt_text_resid__idx_ready()
%t1125 = call i64 @__mruntime_rt_text_resid__idx_small()
%t1126 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1125)
%t1127 = icmp eq i64 %t1126, %p0
br i1 %t1127, label %L385, label %L387
L385:
%t1128 = call i64 @__mruntime_rt_text_resid__idx_small()
ret i64 %t1128
L387:
%t1129 = call i1 @__mruntime_rt_text_resid__str_short(i64 %p0, i64 0)
br i1 %t1129, label %L388, label %L390
L388:
%t1130 = call i64 @__mruntime_rt_text_resid__idx_small()
%t1131 = call i64 @__mruntime_rt_text_resid__idx_build(i64 %p0, i64 %t1130)
%t1132 = mul nsw i64 %t1131, 0
%t1133 = call i64 @__mruntime_rt_text_resid__idx_small()
%t1134 = add nsw i64 %t1132, %t1133
ret i64 %t1134
L390:
%t1135 = call i64 @__mruntime_rt_text_resid__idx_state()
%t1136 = call i64 @ld64(i64 %t1135)
%t1137 = add i64 %t1136, 1
%t1138 = call i64 @st64(i64 %t1135, i64 %t1137)
%t1139 = add i64 %t1135, 16
%t1140 = call i64 @ld64(i64 %t1139)
%t1141 = icmp ne i64 %t1140, 0
br i1 %t1141, label %L391, label %L392
L391:
%t1142 = add i64 %t1140, 24
%t1143 = call i64 @st64(i64 %t1142, i64 %t1137)
br label %L393
L392:
br label %L393
L393:
%t1144 = phi i64 [ %t1143, %L391 ], [ 0, %L392 ]
%t1145 = call i64 @__mruntime_rt_text_resid__idx_find__rs30(i64 %p0)
%t1146 = icmp ne i64 %t1145, 0
br i1 %t1146, label %L394, label %L396
L394:
%t1147 = add i64 %t1145, 24
%t1148 = call i64 @st64(i64 %t1147, i64 %t1137)
%t1149 = mul nsw i64 %t1148, 0
%t1150 = add nsw i64 %t1149, %t1145
ret i64 %t1150
L396:
%t1151 = call i64 @__mruntime_rt_text_resid__idx_scratch()
%t1152 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1151)
%t1153 = icmp eq i64 %t1152, %p0
br i1 %t1153, label %L397, label %L399
L397:
%t1154 = call i64 @__mruntime_rt_text_resid__idx_scratch()
ret i64 %t1154
L399:
%t1155 = call i64 @rt_arena_contains(i64 %p0)
%t1156 = icmp ne i64 %t1155, 0
br i1 %t1156, label %L400, label %L402
L400:
%t1157 = call i64 @__mruntime_rt_text_resid__idx_scratch()
%t1158 = call i64 @__mruntime_rt_text_resid__idx_build(i64 %p0, i64 %t1157)
%t1159 = call i64 @__mruntime_rt_text_resid__idx_scratch()
%t1160 = add i64 %t1159, 24
%t1161 = call i64 @st64(i64 %t1160, i64 %t1137)
%t1162 = mul nsw i64 %t1161, 0
%t1163 = call i64 @__mruntime_rt_text_resid__idx_scratch()
%t1164 = add nsw i64 %t1162, %t1163
ret i64 %t1164
L402:
%t1165 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t1166 = call i64 @__mruntime_rt_text_resid__idx_victim(i64 1, i64 %t1165)
%t1167 = call i64 @__mruntime_rt_text_resid__idx_build(i64 %p0, i64 %t1166)
%t1168 = add i64 %t1166, 24
%t1169 = call i64 @st64(i64 %t1168, i64 %t1137)
%t1170 = mul nsw i64 %t1169, 0
%t1171 = add nsw i64 %t1170, %t1166
ret i64 %t1171
}
define internal i64 @idx_slot(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1172 = call i64 @__mruntime_rt_text_resid__idx_state()
%t1173 = add i64 %t1172, 16
%t1174 = call i64 @ld64(i64 %t1173)
%t1175 = icmp ne i64 %t1174, 0
br label %LSL1176
LSL1176:
br i1 %t1175, label %LSR1176, label %LSJ1176
LSR1176:
%t1177 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1174)
%t1178 = icmp eq i64 %t1177, %p0
br label %LSJ1176
LSJ1176:
%t1179 = phi i1 [ false, %LSL1176 ], [ %t1178, %LSR1176 ]
br i1 %t1179, label %L403, label %L405
L403:
ret i64 %t1174
L405:
%t1180 = call i64 @__mruntime_rt_text_resid__idx_slot_miss(i64 %p0, i64 %t1172)
ret i64 %t1180
}
define internal i64 @__mruntime_rt_text_resid__idx_slot_miss(i64 %p0, i64 %p1) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1181 = call i64 @__mruntime_rt_text_resid__idx_slot_slow(i64 %p0)
%t1182 = add i64 %p1, 16
%t1183 = call i64 @st64(i64 %t1182, i64 %t1181)
%t1184 = call i64 @__mruntime_rt_text_resid__sl_off(i64 %t1181)
%t1185 = icmp eq i64 %t1184, 0
br i1 %t1185, label %L406, label %L407
L406:
%t1186 = add i64 %p1, 24
%t1187 = call i64 @st64(i64 %t1186, i64 %p0)
%t1188 = add i64 %p1, 32
%t1189 = call i64 @__mruntime_rt_text_resid__sl_len(i64 %t1181)
%t1190 = call i64 @st64(i64 %t1188, i64 %t1189)
%t1191 = add i64 %t1187, %t1190
br label %L408
L407:
br label %L408
L408:
%t1192 = phi i64 [ %t1191, %L406 ], [ 0, %L407 ]
ret i64 %t1181
}
define internal i64 @rt_str_index_popped() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1193 = call i64 @__mruntime_rt_text_resid__idx_state()
%t1194 = add i64 %t1193, 24
%t1195 = call i64 @st64(i64 %t1194, i64 0)
%t1196 = call i64 @__mruntime_rt_text_resid__idx_small()
%t1197 = call i64 @st64(i64 %t1196, i64 0)
%t1198 = call i64 @__mruntime_rt_text_resid__idx_scratch()
%t1199 = call i64 @st64(i64 %t1198, i64 0)
ret i64 %t1199
}
define void @resid_str_index_popped() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_str_index_popped()
ret void
}
define internal i64 @str_index_forget(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1200 = call i64 @__mruntime_rt_text_resid__idx_state()
%t1201 = add i64 %t1200, 24
%t1202 = call i64 @ld64(i64 %t1201)
%t1203 = icmp eq i64 %t1202, %p0
br i1 %t1203, label %L409, label %L410
L409:
%t1204 = add i64 %t1200, 24
%t1205 = call i64 @st64(i64 %t1204, i64 0)
br label %L411
L410:
br label %L411
L411:
%t1206 = phi i64 [ %t1205, %L409 ], [ 0, %L410 ]
%t1207 = call i64 @__mruntime_rt_text_resid__idx_small()
%t1208 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1207)
%t1209 = icmp eq i64 %t1208, %p0
br i1 %t1209, label %L412, label %L413
L412:
%t1210 = call i64 @__mruntime_rt_text_resid__idx_small()
%t1211 = call i64 @st64(i64 %t1210, i64 0)
br label %L414
L413:
br label %L414
L414:
%t1212 = phi i64 [ %t1211, %L412 ], [ 0, %L413 ]
%t1213 = call i64 @__mruntime_rt_text_resid__idx_scratch()
%t1214 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1213)
%t1215 = icmp eq i64 %t1214, %p0
br i1 %t1215, label %L415, label %L416
L415:
%t1216 = call i64 @__mruntime_rt_text_resid__idx_scratch()
%t1217 = call i64 @st64(i64 %t1216, i64 0)
br label %L417
L416:
br label %L417
L417:
%t1218 = phi i64 [ %t1217, %L415 ], [ 0, %L416 ]
%t1219 = add i64 %t1200, 8
%t1220 = call i64 @ld64(i64 %t1219)
%t1221 = icmp eq i64 %t1220, 0
br i1 %t1221, label %L418, label %L420
L418:
ret i64 0
L420:
%t1222 = call i64 @__mruntime_rt_text_resid__idx_forget_at(i64 %p0, i64 0)
ret i64 %t1222
}
define internal i64 @__mruntime_rt_text_resid__idx_forget_at(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1234, %tco.s0 ]
%t1223 = icmp sge i64 %p1, 16
br i1 %t1223, label %L421, label %L423
L421:
ret i64 0
L423:
%t1224 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t1225 = mul i64 %p1, 40
%t1226 = add i64 %t1224, %t1225
%t1227 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1226)
%t1228 = icmp eq i64 %t1227, %p0
br i1 %t1228, label %L424, label %L425
L424:
%t1229 = call i64 @st64(i64 %t1226, i64 0)
%t1230 = add i64 %t1226, 24
%t1231 = call i64 @st64(i64 %t1230, i64 0)
%t1232 = add i64 %t1229, %t1231
br label %L426
L425:
br label %L426
L426:
%t1233 = phi i64 [ %t1232, %L424 ], [ 0, %L425 ]
%t1234 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1236 = call i64 @__mruntime_rt_text_resid__idx_state()
%t1237 = add i64 %t1236, 24
%t1238 = call i64 @ld64(i64 %t1237)
%t1239 = icmp eq i64 %p0, %t1238
br i1 %t1239, label %L427, label %L429
L427:
%t1240 = add i64 %t1236, 32
%t1241 = tail call i64 @ld64(i64 %t1240)
ret i64 %t1241
L429:
%t1242 = call i64 @idx_slot(i64 %p0)
%t1243 = tail call i64 @__mruntime_rt_text_resid__sl_len(i64 %t1242)
ret i64 %t1243
}
define i64 @str_len(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_len(i64 %x0i)
ret i64 %r
}
define internal i64 @__mruntime_rt_text_resid__char_at_slow(i64 %p0, i64 %p1) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1244 = call i64 @idx_slot(i64 %p0)
%t1245 = call i64 @__mruntime_rt_text_resid__sl_len(i64 %t1244)
%t1246 = call i1 @ult(i64 %p1, i64 %t1245)
%t1247 = xor i1 %t1246, true
br i1 %t1247, label %L430, label %L432
L430:
ret i64 -1
L432:
%t1248 = call i64 @__mruntime_rt_text_resid__sl_off(i64 %t1244)
%t1249 = icmp eq i64 %t1248, 0
br i1 %t1249, label %L433, label %L435
L433:
%t1250 = add i64 %p0, %p1
%t1251 = call i64 @ld8(i64 %t1250)
ret i64 %t1251
L435:
%t1252 = call i64 @slot_off(i64 %t1244, i64 %p1)
%t1253 = add i64 %p0, %t1252
%t1254 = call i64 @utf8_len_at(i64 %t1253)
%t1255 = tail call i64 @utf8_decode(i64 %t1253, i64 %t1254)
ret i64 %t1255
}
define internal i64 @rt_str_char_at(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1256 = call i64 @__mruntime_rt_text_resid__idx_state()
%t1257 = add i64 %t1256, 24
%t1258 = call i64 @ld64(i64 %t1257)
%t1259 = icmp eq i64 %p0, %t1258
br i1 %t1259, label %L436, label %L438
L436:
%t1260 = add i64 %t1256, 32
%t1261 = call i64 @ld64(i64 %t1260)
%t1262 = call i1 @ult(i64 %p1, i64 %t1261)
br i1 %t1262, label %L439, label %L440
L439:
%t1263 = add i64 %p0, %p1
%t1264 = call i64 @ld8(i64 %t1263)
br label %L441
L440:
br label %L441
L441:
%t1265 = phi i64 [ %t1264, %L439 ], [ -1, %L440 ]
ret i64 %t1265
L438:
%t1266 = tail call i64 @__mruntime_rt_text_resid__char_at_slow(i64 %p0, i64 %p1)
ret i64 %t1266
}
define i64 @str_char_at(ptr %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call i64 @rt_str_char_at(i64 %x0i, i64 %a1)
ret i64 %r
}
define internal i64 @rt_str_slice(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1267 = call i64 @idx_slot(i64 %p0)
%t1268 = call i64 @__mruntime_rt_text_resid__sl_len(i64 %t1267)
%t1269 = icmp slt i64 %p1, 0
br i1 %t1269, label %L442, label %L443
L442:
br label %L444
L443:
br label %L444
L444:
%t1270 = phi i64 [ 0, %L442 ], [ %p1, %L443 ]
%t1271 = icmp slt i64 %p2, %t1270
br i1 %t1271, label %L445, label %L446
L445:
br label %L447
L446:
br label %L447
L447:
%t1272 = phi i64 [ %t1270, %L445 ], [ %p2, %L446 ]
%t1273 = icmp sgt i64 %t1270, %t1268
br i1 %t1273, label %L448, label %L449
L448:
br label %L450
L449:
br label %L450
L450:
%t1274 = phi i64 [ %t1268, %L448 ], [ %t1270, %L449 ]
%t1275 = icmp sgt i64 %t1272, %t1268
br i1 %t1275, label %L451, label %L452
L451:
br label %L453
L452:
br label %L453
L453:
%t1276 = phi i64 [ %t1268, %L451 ], [ %t1272, %L452 ]
%t1277 = call i64 @slot_off(i64 %t1267, i64 %t1274)
%t1278 = call i64 @slot_off(i64 %t1267, i64 %t1276)
%t1279 = add i64 %p0, %t1277
%t1280 = sub i64 %t1278, %t1277
%t1281 = call i64 @cstr_from__rs33(i64 %t1279, i64 %t1280)
ret i64 %t1281
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
%t1282 = icmp sge i64 %p0, 97
br label %LSL1283
LSL1283:
br i1 %t1282, label %LSR1283, label %LSJ1283
LSR1283:
%t1284 = icmp sle i64 %p0, 122
br label %LSJ1283
LSJ1283:
%t1285 = phi i1 [ false, %LSL1283 ], [ %t1284, %LSR1283 ]
br label %LSL1286
LSL1286:
br i1 %t1285, label %LSJ1286, label %LSR1286
LSR1286:
%t1287 = icmp eq i64 %p0, 32
br label %LSJ1286
LSJ1286:
%t1288 = phi i1 [ true, %LSL1286 ], [ %t1287, %LSR1286 ]
br label %LSL1289
LSL1289:
br i1 %t1288, label %LSJ1289, label %LSR1289
LSR1289:
%t1290 = icmp eq i64 %p0, 10
br label %LSJ1289
LSJ1289:
%t1291 = phi i1 [ true, %LSL1289 ], [ %t1290, %LSR1289 ]
br i1 %t1291, label %L454, label %L456
L454:
ret i64 3
L456:
%t1292 = icmp sge i64 %p0, 65
br label %LSL1293
LSL1293:
br i1 %t1292, label %LSR1293, label %LSJ1293
LSR1293:
%t1294 = icmp sle i64 %p0, 90
br label %LSJ1293
LSJ1293:
%t1295 = phi i1 [ false, %LSL1293 ], [ %t1294, %LSR1293 ]
br label %LSL1296
LSL1296:
br i1 %t1295, label %LSJ1296, label %LSR1296
LSR1296:
%t1297 = icmp sge i64 %p0, 48
br label %LSL1298
LSL1298:
br i1 %t1297, label %LSR1298, label %LSJ1298
LSR1298:
%t1299 = icmp sle i64 %p0, 57
br label %LSJ1298
LSJ1298:
%t1300 = phi i1 [ false, %LSL1298 ], [ %t1299, %LSR1298 ]
br label %LSJ1296
LSJ1296:
%t1301 = phi i1 [ true, %LSL1296 ], [ %t1300, %LSJ1298 ]
br i1 %t1301, label %L457, label %L459
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t1310, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1311, %tco.s0 ]
%t1302 = icmp sge i64 %p1, %p2
br i1 %t1302, label %L460, label %L462
L460:
ret i64 %p3
L462:
%t1303 = add i64 %p0, %p1
%t1304 = call i64 @ld8(i64 %t1303)
%t1305 = call i64 @__mruntime_rt_text_resid__byte_common(i64 %t1304)
%t1306 = add i64 %p0, %p3
%t1307 = call i64 @ld8(i64 %t1306)
%t1308 = call i64 @__mruntime_rt_text_resid__byte_common(i64 %t1307)
%t1309 = icmp slt i64 %t1305, %t1308
%t1310 = add nsw i64 %p1, 1
br i1 %t1309, label %L463, label %L464
L463:
br label %L465
L464:
br label %L465
L465:
%t1311 = phi i64 [ %p1, %L463 ], [ %p3, %L464 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @find_bytes(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1313 = icmp eq i64 %p3, 0
br i1 %t1313, label %L466, label %L468
L466:
ret i64 %p0
L468:
%t1314 = icmp sgt i64 %p3, %p1
br i1 %t1314, label %L469, label %L471
L469:
ret i64 0
L471:
%t1315 = call i64 @__mruntime_rt_text_resid__rarest(i64 %p2, i64 1, i64 %p3, i64 0)
%t1316 = add i64 %p0, %p1
%t1317 = add i64 %p0, %t1315
%t1318 = call i64 @__mruntime_rt_text_resid__find_from__rs36(i64 %p0, i64 %t1316, i64 %p2, i64 %p3, i64 %t1315, i64 %t1317)
ret i64 %t1318
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
%p5 = phi i64 [ %p5.in, %entry ], [ %t1331, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %t1332, %tco.s0 ]
%t1319 = sub i64 %p3, 1
%t1320 = sub i64 %t1319, %p4
%t1321 = sub i64 %p1, %t1320
%t1322 = icmp sge i64 %p5, %t1321
br i1 %t1322, label %L472, label %L474
L472:
ret i64 0
L474:
%t1323 = add i64 %p2, %p4
%t1324 = call i64 @ld8(i64 %t1323)
%t1325 = sub i64 %t1321, %p5
%t1326 = call i64 @c_memchr(i64 %p5, i64 %t1324, i64 %t1325)
%t1327 = icmp eq i64 %t1326, 0
br i1 %t1327, label %L475, label %L477
L475:
ret i64 0
L477:
%t1328 = sub i64 %t1326, %p4
%t1329 = call i64 @c_memcmp(i64 %t1328, i64 %p2, i64 %p3)
%t1330 = icmp eq i64 %t1329, 0
br i1 %t1330, label %L478, label %L480
L478:
ret i64 %t1328
L480:
%t1331 = add i64 %t1326, 1
%t1332 = add i64 %p6, 1
%t1333 = icmp sgt i64 %t1332, 64
br label %LSL1334
LSL1334:
br i1 %t1333, label %LSR1334, label %LSJ1334
LSR1334:
%t1335 = sub i64 %t1331, %p0
%t1336 = mul i64 %t1332, 16
%t1337 = icmp slt i64 %t1335, %t1336
br label %LSJ1334
LSJ1334:
%t1338 = phi i1 [ false, %LSL1334 ], [ %t1337, %LSR1334 ]
br i1 %t1338, label %L481, label %L483
L481:
%t1339 = add i64 %t1328, 1
%t1340 = sub i64 %p1, %t1328
%t1341 = sub i64 %t1340, 1
%t1342 = call i64 @c_memmem(i64 %t1339, i64 %t1341, i64 %p2, i64 %p3)
ret i64 %t1342
L483:
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_index_of(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1344 = call i64 @idx_slot(i64 %p0)
%t1345 = call i64 @__mruntime_rt_text_resid__sl_len(i64 %t1344)
%t1346 = icmp slt i64 %p2, 0
br i1 %t1346, label %L484, label %L485
L484:
br label %L486
L485:
br label %L486
L486:
%t1347 = phi i64 [ 0, %L484 ], [ %p2, %L485 ]
%t1348 = icmp sgt i64 %t1347, %t1345
br i1 %t1348, label %L487, label %L489
L487:
ret i64 -1
L489:
%t1349 = call i64 @slot_off(i64 %t1344, i64 %t1347)
%t1350 = add i64 %p0, %t1349
%t1351 = call i64 @__mruntime_rt_text_resid__sl_blen(i64 %t1344)
%t1352 = sub i64 %t1351, %t1349
%t1353 = call i64 @c_strlen(i64 %p1)
%t1354 = call i64 @find_bytes(i64 %t1350, i64 %t1352, i64 %p1, i64 %t1353)
%t1355 = icmp eq i64 %t1354, 0
br i1 %t1355, label %L490, label %L492
L490:
ret i64 -1
L492:
%t1356 = sub i64 %t1354, %p0
%t1357 = call i64 @__mruntime_rt_text_resid__sl_off(i64 %t1344)
%t1358 = icmp eq i64 %t1357, 0
br i1 %t1358, label %L493, label %L495
L493:
ret i64 %t1356
L495:
%t1359 = ashr i64 %t1345, 4
%t1360 = call i64 @__mruntime_rt_text_resid__ck_search(i64 %t1357, i64 %t1356, i64 0, i64 %t1359)
%t1361 = mul i64 %t1360, 8
%t1362 = add i64 %t1357, %t1361
%t1363 = call i64 @ld64(i64 %t1362)
%t1364 = add i64 %p0, %t1363
%t1365 = add i64 %p0, %t1356
%t1366 = shl i64 %t1360, 4
%t1367 = tail call i64 @__mruntime_rt_text_resid__cp_walk(i64 %t1364, i64 %t1365, i64 %t1366)
ret i64 %t1367
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t1371, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ], [ %t1377, %tco.s1 ]
%t1368 = icmp sge i64 %p2, %p3
br i1 %t1368, label %L496, label %L498
L496:
ret i64 %p2
L498:
%t1369 = add i64 %p2, %p3
%t1370 = add i64 %t1369, 1
%t1371 = sdiv i64 %t1370, 2
%t1372 = mul i64 %t1371, 8
%t1373 = add i64 %p0, %t1372
%t1374 = call i64 @ld64(i64 %t1373)
%t1375 = icmp sle i64 %t1374, %p1
br i1 %t1375, label %L499, label %L501
L499:
br label %tco.s0
tco.s0:
br label %tco.head
L501:
%t1377 = sub nsw i64 %t1371, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__cp_walk(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1381, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1382, %tco.s0 ]
%t1379 = icmp sge i64 %p0, %p1
br i1 %t1379, label %L502, label %L504
L502:
ret i64 %p2
L504:
%t1380 = call i64 @utf8_len_at(i64 %p0)
%t1381 = add i64 %p0, %t1380
%t1382 = add i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_text_resid__sb_grow(i64 %p0, i64 %p1) noinline "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1384 = add i64 %p0, 8
%t1385 = call i64 @ld64(i64 %t1384)
%t1386 = add i64 %p0, 16
%t1387 = call i64 @ld64(i64 %t1386)
%t1388 = icmp eq i64 %t1387, 0
br i1 %t1388, label %L505, label %L506
L505:
br label %L507
L506:
%t1389 = mul i64 %t1387, 2
br label %L507
L507:
%t1390 = phi i64 [ 64, %L505 ], [ %t1389, %L506 ]
%t1391 = add i64 %t1385, %p1
%t1392 = icmp slt i64 %t1390, %t1391
br i1 %t1392, label %L508, label %L509
L508:
%t1393 = add i64 %t1385, %p1
br label %L510
L509:
br label %L510
L510:
%t1394 = phi i64 [ %t1393, %L508 ], [ %t1390, %L509 ]
%t1395 = call i64 @ld64(i64 %p0)
%t1396 = add i64 %t1394, 1
%t1397 = call i64 @xrealloc(i64 %t1395, i64 %t1396)
%t1398 = call i64 @st64(i64 %p0, i64 %t1397)
%t1399 = add i64 %p0, 16
%t1400 = tail call i64 @st64(i64 %t1399, i64 %t1394)
ret i64 %t1400
}
define internal i64 @sb_bytes(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1401 = add i64 %p0, 16
%t1402 = call i64 @ld64(i64 %t1401)
%t1403 = add i64 %p0, 8
%t1404 = call i64 @ld64(i64 %t1403)
%t1405 = sub i64 %t1402, %t1404
%t1406 = icmp slt i64 %t1405, %p2
br i1 %t1406, label %L511, label %L512
L511:
%t1407 = call i64 @__mruntime_rt_text_resid__sb_grow(i64 %p0, i64 %p2)
br label %L513
L512:
br label %L513
L513:
%t1408 = phi i64 [ %t1407, %L511 ], [ 0, %L512 ]
%t1409 = add i64 %p0, 8
%t1410 = call i64 @ld64(i64 %t1409)
%t1411 = call i64 @ld64(i64 %p0)
%t1412 = add i64 %t1411, %t1410
%t1413 = call i64 @mcopy(i64 %t1412, i64 %p1, i64 %p2)
%t1414 = add i64 %p0, 8
%t1415 = add i64 %t1410, %p2
%t1416 = call i64 @st64(i64 %t1414, i64 %t1415)
ret i64 %t1416
}
define internal i64 @rt_sb_new() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1417 = call i64 @xmalloc(i64 24)
%t1418 = call i64 @st64(i64 %t1417, i64 0)
%t1419 = add i64 %t1417, 8
%t1420 = call i64 @st64(i64 %t1419, i64 0)
%t1421 = add i64 %t1417, 16
%t1422 = call i64 @st64(i64 %t1421, i64 0)
ret i64 %t1417
}
define ptr @str_sb_new() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_sb_new()
%rv = inttoptr i64 %r to ptr
ret ptr %rv
}
define internal i64 @rt_sb_append(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1423 = call i64 @c_strlen(i64 %p1)
%t1424 = call i64 @sb_bytes(i64 %p0, i64 %p1, i64 %t1423)
%t1425 = mul nsw i64 %t1424, 0
%t1426 = add nsw i64 %t1425, %p0
ret i64 %t1426
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
%t1427 = add i64 %p0, 8
%t1428 = call i64 @ld64(i64 %t1427)
%t1429 = call i1 @ult(i64 %p1, i64 128)
br label %LSL1430
LSL1430:
br i1 %t1429, label %LSR1430, label %LSJ1430
LSR1430:
%t1431 = add i64 %p0, 16
%t1432 = call i64 @ld64(i64 %t1431)
%t1433 = icmp slt i64 %t1428, %t1432
br label %LSJ1430
LSJ1430:
%t1434 = phi i1 [ false, %LSL1430 ], [ %t1433, %LSR1430 ]
br i1 %t1434, label %L514, label %L516
L514:
%t1435 = call i64 @ld64(i64 %p0)
%t1436 = add i64 %t1435, %t1428
%t1437 = call i64 @st8(i64 %t1436, i64 %p1)
%t1438 = add i64 %p0, 8
%t1439 = add nsw i64 %t1428, 1
%t1440 = call i64 @st64(i64 %t1438, i64 %t1439)
%t1441 = mul nsw i64 %t1440, 0
%t1442 = add nsw i64 %t1441, %p0
ret i64 %t1442
L516:
%t1443 = tail call i64 @__mruntime_rt_text_resid__sb_cp_slow(i64 %p0, i64 %p1)
ret i64 %t1443
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
%t1444p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.sb_cp)
%t1444 = ptrtoint ptr %t1444p to i64
%t1445 = call i64 @utf8_encode(i64 %p1, i64 %t1444)
%t1446 = call i64 @sb_bytes(i64 %p0, i64 %t1444, i64 %t1445)
%t1447 = mul nsw i64 %t1446, 0
%t1448 = add nsw i64 %t1447, %p0
ret i64 %t1448
}
define internal i64 @rt_sb_finish(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1449 = call i64 @ld64(i64 %p0)
%t1450 = add i64 %p0, 8
%t1451 = call i64 @ld64(i64 %t1450)
%t1452 = add i64 %p0, 16
%t1453 = call i64 @ld64(i64 %t1452)
%t1454 = icmp eq i64 %t1449, 0
br i1 %t1454, label %L517, label %L518
L517:
%t1455 = call i64 @xmalloc(i64 1)
br label %L519
L518:
br label %L519
L519:
%t1456 = phi i64 [ %t1455, %L517 ], [ %t1449, %L518 ]
%t1457 = icmp ne i64 %t1449, 0
br label %LSL1458
LSL1458:
br i1 %t1457, label %LSR1458, label %LSJ1458
LSR1458:
%t1459 = sdiv i64 %t1451, 8
%t1460 = add i64 %t1451, %t1459
%t1461 = add i64 %t1460, 64
%t1462 = icmp sgt i64 %t1453, %t1461
br label %LSJ1458
LSJ1458:
%t1463 = phi i1 [ false, %LSL1458 ], [ %t1462, %LSR1458 ]
br i1 %t1463, label %L520, label %L521
L520:
%t1464 = call i64 @__mruntime_rt_text_resid__sb_shrink(i64 %t1456, i64 %t1451)
br label %L522
L521:
br label %L522
L522:
%t1465 = phi i64 [ %t1464, %L520 ], [ %t1456, %L521 ]
%t1466 = add i64 %t1465, %t1451
%t1467 = call i64 @st8(i64 %t1466, i64 0)
%t1468 = call i64 @c_free(i64 %p0)
ret i64 %t1465
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
%t1469 = add i64 %p1, 1
%t1470 = call i64 @c_realloc(i64 %p0, i64 %t1469)
%t1471 = icmp eq i64 %t1470, 0
br i1 %t1471, label %L523, label %L524
L523:
br label %L525
L524:
br label %L525
L525:
%t1472 = phi i64 [ %p0, %L523 ], [ %t1470, %L524 ]
ret i64 %t1472
}
define internal i1 @rt_sb_print(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1473 = call i64 @ld64(i64 %p0)
%t1474 = add i64 %p0, 8
%t1475 = call i64 @ld64(i64 %t1474)
%t1476 = icmp ne i64 %p1, 0
br i1 %t1476, label %L526, label %L527
L526:
%t1477 = icmp eq i64 %t1473, 0
br i1 %t1477, label %L529, label %L530
L529:
%t1479 = ptrtoint ptr @.s1478 to i64
br label %L531
L530:
br label %L531
L531:
%t1480 = phi i64 [ %t1479, %L529 ], [ %t1473, %L530 ]
%t1481 = call i1 @write_line(i64 1, i64 %t1480, i64 %t1475)
br label %L528
L527:
%t1482 = icmp eq i64 %t1473, 0
br label %LSL1483
LSL1483:
br i1 %t1482, label %LSJ1483, label %LSR1483
LSR1483:
%t1484 = call i1 @write_all(i64 1, i64 %t1473, i64 %t1475)
br label %LSJ1483
LSJ1483:
%t1485 = phi i1 [ true, %LSL1483 ], [ %t1484, %LSR1483 ]
br label %L528
L528:
%t1486 = phi i1 [ %t1481, %L531 ], [ %t1485, %LSJ1483 ]
%t1487 = call i64 @c_free(i64 %t1473)
%t1488 = call i64 @c_free(i64 %p0)
ret i1 %t1486
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
%t1489 = ptrtoint ptr @rtt.8216 to i64
ret i64 %t1489
}
define internal i64 @case_lower_n() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 1459
}
define internal i64 @case_upper_tab() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1490 = ptrtoint ptr @rtt.11127 to i64
ret i64 %t1490
}
define internal i64 @case_upper_n() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 1450
}
define internal i64 @case_special_tab() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1491 = ptrtoint ptr @rtt.12051 to i64
ret i64 %t1491
}
define internal i64 @case_special_n() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 83
}
define internal i64 @__mruntime_rt_case_resid__case_lookup(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1492 = sub i64 %p1, 1
%t1493 = call i64 @__mruntime_rt_case_resid__case_bs(i64 %p0, i64 %p2, i64 0, i64 %t1492)
ret i64 %t1493
}
define internal i64 @__mruntime_rt_case_resid__case_bs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %t1509, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1507, %tco.s0 ], [ %p3, %tco.s1 ]
%t1494 = icmp sgt i64 %p2, %p3
br i1 %t1494, label %L532, label %L534
L532:
ret i64 0
L534:
%t1495 = sub i64 %p3, %p2
%t1496 = sdiv i64 %t1495, 2
%t1497 = add i64 %p2, %t1496
%t1498 = mul i64 %t1497, 16
%t1499 = add i64 %p0, %t1498
%t1500 = call i64 @ld64(i64 %t1499)
%t1501 = icmp eq i64 %p1, %t1500
br i1 %t1501, label %L535, label %L537
L535:
%t1502 = mul i64 %t1497, 16
%t1503 = add i64 %p0, %t1502
%t1504 = add i64 %t1503, 8
%t1505 = call i64 @ld64(i64 %t1504)
ret i64 %t1505
L537:
%t1506 = icmp slt i64 %p1, %t1500
br i1 %t1506, label %L538, label %L540
L538:
%t1507 = sub i64 %t1497, 1
br label %tco.s0
tco.s0:
br label %tco.head
L540:
%t1509 = add i64 %t1497, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i64 @case_simple(i64 %p0, i1 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br i1 %p1, label %L541, label %L542
L541:
%t1511 = call i64 @case_lower_tab()
%t1512 = call i64 @__mruntime_rt_case_resid__case_lookup__rs40(i64 %t1511, i64 %p0)
br label %L543
L542:
%t1513 = call i64 @case_upper_tab()
%t1514 = call i64 @__mruntime_rt_case_resid__case_lookup(i64 %t1513, i64 1450, i64 %p0)
br label %L543
L543:
%t1515 = phi i64 [ %t1512, %L541 ], [ %t1514, %L542 ]
%t1516 = icmp ne i64 %t1515, 0
br i1 %t1516, label %L544, label %L545
L544:
br label %L546
L545:
br label %L546
L546:
%t1517 = phi i64 [ %t1515, %L544 ], [ %p0, %L545 ]
ret i64 %t1517
}
define internal i64 @__mruntime_rt_case_resid__special_upper(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1518 = call i64 @case_special_tab()
%t1519 = call i64 @__mruntime_rt_case_resid__special_bs__rs49(i64 %t1518, i64 %p0)
ret i64 %t1519
}
define internal i64 @__mruntime_rt_case_resid__special_bs(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %t1531, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1529, %tco.s0 ], [ %p3, %tco.s1 ]
%t1520 = icmp sgt i64 %p2, %p3
br i1 %t1520, label %L547, label %L549
L547:
ret i64 0
L549:
%t1521 = sub i64 %p3, %p2
%t1522 = sdiv i64 %t1521, 2
%t1523 = add i64 %p2, %t1522
%t1524 = mul i64 %t1523, 88
%t1525 = add i64 %p0, %t1524
%t1526 = call i64 @ld64(i64 %t1525)
%t1527 = icmp eq i64 %p1, %t1526
br i1 %t1527, label %L550, label %L552
L550:
ret i64 %t1525
L552:
%t1528 = icmp slt i64 %p1, %t1526
br i1 %t1528, label %L553, label %L555
L553:
%t1529 = sub i64 %t1523, 1
br label %tco.s0
tco.s0:
br label %tco.head
L555:
%t1531 = add i64 %t1523, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define internal i1 @__mruntime_rt_case_resid__is_cased(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1533 = call i64 @case_lower_tab()
%t1534 = call i64 @__mruntime_rt_case_resid__case_lookup__rs40(i64 %t1533, i64 %p0)
%t1535 = icmp ne i64 %t1534, 0
br label %LSL1536
LSL1536:
br i1 %t1535, label %LSJ1536, label %LSR1536
LSR1536:
%t1537 = call i64 @case_upper_tab()
%t1538 = call i64 @__mruntime_rt_case_resid__case_lookup(i64 %t1537, i64 1450, i64 %p0)
%t1539 = icmp ne i64 %t1538, 0
br label %LSJ1536
LSJ1536:
%t1540 = phi i1 [ true, %LSL1536 ], [ %t1539, %LSR1536 ]
ret i1 %t1540
}
define internal i1 @__mruntime_rt_case_resid__is_ignorable(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1541 = call i1 @__mruntime_rt_case_resid__is_cased(i64 %p0)
br i1 %t1541, label %L556, label %L558
L556:
ret i1 false
L558:
%t1542 = icmp sge i64 %p0, 768
br label %LSL1543
LSL1543:
br i1 %t1542, label %LSR1543, label %LSJ1543
LSR1543:
%t1544 = icmp sle i64 %p0, 879
br label %LSJ1543
LSJ1543:
%t1545 = phi i1 [ false, %LSL1543 ], [ %t1544, %LSR1543 ]
br label %LSL1546
LSL1546:
br i1 %t1545, label %LSJ1546, label %LSR1546
LSR1546:
%t1547 = icmp sge i64 %p0, 1155
br label %LSL1548
LSL1548:
br i1 %t1547, label %LSR1548, label %LSJ1548
LSR1548:
%t1549 = icmp sle i64 %p0, 1161
br label %LSJ1548
LSJ1548:
%t1550 = phi i1 [ false, %LSL1548 ], [ %t1549, %LSR1548 ]
br label %LSJ1546
LSJ1546:
%t1551 = phi i1 [ true, %LSL1546 ], [ %t1550, %LSJ1548 ]
br label %LSL1552
LSL1552:
br i1 %t1551, label %LSJ1552, label %LSR1552
LSR1552:
%t1553 = icmp sge i64 %p0, 1425
br label %LSL1554
LSL1554:
br i1 %t1553, label %LSR1554, label %LSJ1554
LSR1554:
%t1555 = icmp sle i64 %p0, 1469
br label %LSJ1554
LSJ1554:
%t1556 = phi i1 [ false, %LSL1554 ], [ %t1555, %LSR1554 ]
br label %LSJ1552
LSJ1552:
%t1557 = phi i1 [ true, %LSL1552 ], [ %t1556, %LSJ1554 ]
br label %LSL1558
LSL1558:
br i1 %t1557, label %LSJ1558, label %LSR1558
LSR1558:
%t1559 = icmp sge i64 %p0, 1552
br label %LSL1560
LSL1560:
br i1 %t1559, label %LSR1560, label %LSJ1560
LSR1560:
%t1561 = icmp sle i64 %p0, 1562
br label %LSJ1560
LSJ1560:
%t1562 = phi i1 [ false, %LSL1560 ], [ %t1561, %LSR1560 ]
br label %LSJ1558
LSJ1558:
%t1563 = phi i1 [ true, %LSL1558 ], [ %t1562, %LSJ1560 ]
br label %LSL1564
LSL1564:
br i1 %t1563, label %LSJ1564, label %LSR1564
LSR1564:
%t1565 = icmp sge i64 %p0, 1611
br label %LSL1566
LSL1566:
br i1 %t1565, label %LSR1566, label %LSJ1566
LSR1566:
%t1567 = icmp sle i64 %p0, 1631
br label %LSJ1566
LSJ1566:
%t1568 = phi i1 [ false, %LSL1566 ], [ %t1567, %LSR1566 ]
br label %LSJ1564
LSJ1564:
%t1569 = phi i1 [ true, %LSL1564 ], [ %t1568, %LSJ1566 ]
br label %LSL1570
LSL1570:
br i1 %t1569, label %LSJ1570, label %LSR1570
LSR1570:
%t1571 = icmp sge i64 %p0, 3633
br label %LSL1572
LSL1572:
br i1 %t1571, label %LSR1572, label %LSJ1572
LSR1572:
%t1573 = icmp sle i64 %p0, 3642
br label %LSJ1572
LSJ1572:
%t1574 = phi i1 [ false, %LSL1572 ], [ %t1573, %LSR1572 ]
br label %LSJ1570
LSJ1570:
%t1575 = phi i1 [ true, %LSL1570 ], [ %t1574, %LSJ1572 ]
br label %LSL1576
LSL1576:
br i1 %t1575, label %LSJ1576, label %LSR1576
LSR1576:
%t1577 = icmp sge i64 %p0, 8204
br label %LSL1578
LSL1578:
br i1 %t1577, label %LSR1578, label %LSJ1578
LSR1578:
%t1579 = icmp sle i64 %p0, 8207
br label %LSJ1578
LSJ1578:
%t1580 = phi i1 [ false, %LSL1578 ], [ %t1579, %LSR1578 ]
br label %LSJ1576
LSJ1576:
%t1581 = phi i1 [ true, %LSL1576 ], [ %t1580, %LSJ1578 ]
br label %LSL1582
LSL1582:
br i1 %t1581, label %LSJ1582, label %LSR1582
LSR1582:
%t1583 = icmp sge i64 %p0, 65024
br label %LSL1584
LSL1584:
br i1 %t1583, label %LSR1584, label %LSJ1584
LSR1584:
%t1585 = icmp sle i64 %p0, 65039
br label %LSJ1584
LSJ1584:
%t1586 = phi i1 [ false, %LSL1584 ], [ %t1585, %LSR1584 ]
br label %LSJ1582
LSJ1582:
%t1587 = phi i1 [ true, %LSL1582 ], [ %t1586, %LSJ1584 ]
ret i1 %t1587
}
define internal i1 @__mruntime_rt_case_resid__prev_cased(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1590, %tco.s0 ]
%t1588 = icmp sle i64 %p1, %p0
br i1 %t1588, label %L559, label %L561
L559:
ret i1 false
L561:
%t1589 = sub nsw i64 %p1, 1
%t1590 = call i64 @__mruntime_rt_case_resid__back_lead(i64 %p0, i64 %t1589)
%t1591 = sub i64 %p1, %t1590
%t1592 = call i64 @utf8_decode(i64 %t1590, i64 %t1591)
%t1593 = call i1 @__mruntime_rt_case_resid__is_ignorable(i64 %t1592)
%t1594 = xor i1 %t1593, true
br i1 %t1594, label %L562, label %L564
L562:
%t1595 = call i1 @__mruntime_rt_case_resid__is_cased(i64 %t1592)
ret i1 %t1595
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t1607, %tco.s0 ]
%t1597 = call i64 @ld8(i64 %p1)
%t1598 = and i64 %t1597, 128
%t1599 = icmp eq i64 %t1598, 0
br i1 %t1599, label %L565, label %L567
L565:
ret i64 %p1
L567:
%t1600 = icmp sgt i64 %p1, %p0
br label %LSL1601
LSL1601:
br i1 %t1600, label %LSR1601, label %LSJ1601
LSR1601:
%t1602 = sub nsw i64 %p1, 1
%t1603 = call i64 @ld8(i64 %t1602)
%t1604 = and i64 %t1603, 192
%t1605 = icmp eq i64 %t1604, 128
br label %LSJ1601
LSJ1601:
%t1606 = phi i1 [ false, %LSL1601 ], [ %t1605, %LSR1601 ]
br i1 %t1606, label %L568, label %L570
L568:
%t1607 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L570:
%t1609 = icmp sgt i64 %p1, %p0
br label %LSL1610
LSL1610:
br i1 %t1609, label %LSR1610, label %LSJ1610
LSR1610:
%t1611 = call i64 @ld8(i64 %p1)
%t1612 = and i64 %t1611, 192
%t1613 = icmp eq i64 %t1612, 128
br label %LSJ1610
LSJ1610:
%t1614 = phi i1 [ false, %LSL1610 ], [ %t1613, %LSR1610 ]
br i1 %t1614, label %L571, label %L572
L571:
%t1615 = sub nsw i64 %p1, 1
br label %L573
L572:
br label %L573
L573:
%t1616 = phi i64 [ %t1615, %L571 ], [ %p1, %L572 ]
ret i64 %t1616
}
define internal i1 @__mruntime_rt_case_resid__next_cased(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1624, %tco.s0 ]
%t1617 = call i64 @ld8(i64 %p0)
%t1618 = icmp eq i64 %t1617, 0
br i1 %t1618, label %L574, label %L576
L574:
ret i1 false
L576:
%t1619 = call i64 @utf8_len_at(i64 %p0)
%t1620 = call i64 @utf8_decode(i64 %p0, i64 %t1619)
%t1621 = call i1 @__mruntime_rt_case_resid__is_ignorable(i64 %t1620)
%t1622 = xor i1 %t1621, true
br i1 %t1622, label %L577, label %L579
L577:
%t1623 = tail call i1 @__mruntime_rt_case_resid__is_cased(i64 %t1620)
ret i1 %t1623
L579:
%t1624 = add i64 %p0, %t1619
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_case_resid__lower_at(i64 %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1640, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1642, %tco.s0 ]
%t1626 = call i64 @ld8(i64 %p1)
%t1627 = icmp eq i64 %t1626, 0
br i1 %t1627, label %L580, label %L582
L580:
ret i64 %p2
L582:
%t1628 = call i64 @utf8_len_at(i64 %p1)
%t1629 = call i64 @utf8_decode(i64 %p1, i64 %t1628)
%t1630 = icmp eq i64 %t1629, 931
br i1 %t1630, label %L583, label %L584
L583:
%t1631 = call i1 @__mruntime_rt_case_resid__prev_cased(i64 %p0, i64 %p1)
br label %LSL1632
LSL1632:
br i1 %t1631, label %LSR1632, label %LSJ1632
LSR1632:
%t1633 = add i64 %p1, %t1628
%t1634 = call i1 @__mruntime_rt_case_resid__next_cased(i64 %t1633)
%t1635 = xor i1 %t1634, true
br label %LSJ1632
LSJ1632:
%t1636 = phi i1 [ false, %LSL1632 ], [ %t1635, %LSR1632 ]
br i1 %t1636, label %L586, label %L587
L586:
br label %L588
L587:
br label %L588
L588:
%t1637 = phi i64 [ 962, %L586 ], [ 963, %L587 ]
br label %L585
L584:
%t1638 = call i64 @case_simple__rs57(i64 %t1629)
br label %L585
L585:
%t1639 = phi i64 [ %t1637, %L588 ], [ %t1638, %L584 ]
%t1640 = add i64 %p1, %t1628
%t1641 = call i64 @utf8_encode(i64 %t1639, i64 %p2)
%t1642 = add i64 %p2, %t1641
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_to_lower(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1644 = call i64 @rt_str_len(i64 %p0)
%t1645 = mul i64 %t1644, 4
%t1646 = add i64 %t1645, 8
%t1647 = call i64 @xmalloc(i64 %t1646)
%t1648 = call i64 @__mruntime_rt_case_resid__lower_at(i64 %p0, i64 %p0, i64 %t1647)
%t1649 = call i64 @st8(i64 %t1648, i64 0)
ret i64 %t1647
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
%p0 = phi i64 [ %p0.in, %entry ], [ %t1663, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1664, %tco.s0 ]
%t1650 = call i64 @ld8(i64 %p0)
%t1651 = icmp eq i64 %t1650, 0
br i1 %t1651, label %L589, label %L591
L589:
ret i64 %p1
L591:
%t1652 = call i64 @utf8_len_at(i64 %p0)
%t1653 = call i64 @utf8_decode(i64 %p0, i64 %t1652)
%t1654 = call i64 @__mruntime_rt_case_resid__special_upper(i64 %t1653)
%t1655 = icmp ne i64 %t1654, 0
br i1 %t1655, label %L592, label %L593
L592:
%t1656 = add i64 %t1654, 16
%t1657 = add i64 %t1654, 8
%t1658 = call i64 @ld64(i64 %t1657)
%t1659 = call i64 @__mruntime_rt_case_resid__copy_words(i64 %p1, i64 %t1656, i64 %t1658)
br label %L594
L593:
%t1660 = call i64 @case_simple__rs58(i64 %t1653)
%t1661 = call i64 @utf8_encode(i64 %t1660, i64 %p1)
br label %L594
L594:
%t1662 = phi i64 [ %t1659, %L592 ], [ %t1661, %L593 ]
%t1663 = add i64 %p0, %t1652
%t1664 = add i64 %p1, %t1662
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_case_resid__copy_words(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1666 = call i64 @__mruntime_rt_case_resid__copy_words_at(i64 %p0, i64 %p1, i64 0, i64 %p2)
ret i64 %p2
}
define internal i64 @__mruntime_rt_case_resid__copy_words_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1673, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t1667 = icmp sge i64 %p2, %p3
br i1 %t1667, label %L595, label %L597
L595:
ret i64 0
L597:
%t1668 = add i64 %p0, %p2
%t1669 = mul i64 %p2, 8
%t1670 = add i64 %p1, %t1669
%t1671 = call i64 @ld64(i64 %t1670)
%t1672 = call i64 @st8(i64 %t1668, i64 %t1671)
%t1673 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_to_upper(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1675 = call i64 @rt_str_len(i64 %p0)
%t1676 = mul i64 %t1675, 9
%t1677 = add i64 %t1676, 8
%t1678 = call i64 @xmalloc(i64 %t1677)
%t1679 = call i64 @__mruntime_rt_case_resid__upper_at(i64 %p0, i64 %t1678)
%t1680 = call i64 @st8(i64 %t1679, i64 0)
ret i64 %t1678
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
%t1681 = icmp ne i64 %p1, 0
%t1682 = call i64 @case_simple(i64 %p0, i1 %t1681)
ret i64 %t1682
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
%t1683 = icmp eq i64 %p0, 32
br label %LSL1684
LSL1684:
br i1 %t1683, label %LSJ1684, label %LSR1684
LSR1684:
%t1685 = icmp eq i64 %p0, 9
br label %LSJ1684
LSJ1684:
%t1686 = phi i1 [ true, %LSL1684 ], [ %t1685, %LSR1684 ]
br label %LSL1687
LSL1687:
br i1 %t1686, label %LSJ1687, label %LSR1687
LSR1687:
%t1688 = icmp eq i64 %p0, 10
br label %LSJ1687
LSJ1687:
%t1689 = phi i1 [ true, %LSL1687 ], [ %t1688, %LSR1687 ]
br label %LSL1690
LSL1690:
br i1 %t1689, label %LSJ1690, label %LSR1690
LSR1690:
%t1691 = icmp eq i64 %p0, 13
br label %LSJ1690
LSJ1690:
%t1692 = phi i1 [ true, %LSL1690 ], [ %t1691, %LSR1690 ]
br label %LSL1693
LSL1693:
br i1 %t1692, label %LSJ1693, label %LSR1693
LSR1693:
%t1694 = icmp eq i64 %p0, 11
br label %LSJ1693
LSJ1693:
%t1695 = phi i1 [ true, %LSL1693 ], [ %t1694, %LSR1693 ]
br label %LSL1696
LSL1696:
br i1 %t1695, label %LSJ1696, label %LSR1696
LSR1696:
%t1697 = icmp eq i64 %p0, 12
br label %LSJ1696
LSJ1696:
%t1698 = phi i1 [ true, %LSL1696 ], [ %t1697, %LSR1696 ]
ret i1 %t1698
}
define internal i64 @__mruntime_rt_strutil_resid__skip_space(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1704, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%t1699 = icmp slt i64 %p0, %p1
br label %LSL1700
LSL1700:
br i1 %t1699, label %LSR1700, label %LSJ1700
LSR1700:
%t1701 = call i64 @ld8(i64 %p0)
%t1702 = call i1 @__mruntime_rt_strutil_resid__is_space(i64 %t1701)
br label %LSJ1700
LSJ1700:
%t1703 = phi i1 [ false, %LSL1700 ], [ %t1702, %LSR1700 ]
br i1 %t1703, label %L598, label %L600
L598:
%t1704 = add nsw i64 %p0, 1
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t1712, %tco.s0 ]
%t1706 = icmp sgt i64 %p1, %p0
br label %LSL1707
LSL1707:
br i1 %t1706, label %LSR1707, label %LSJ1707
LSR1707:
%t1708 = sub nsw i64 %p1, 1
%t1709 = call i64 @ld8(i64 %t1708)
%t1710 = call i1 @__mruntime_rt_strutil_resid__is_space(i64 %t1709)
br label %LSJ1707
LSJ1707:
%t1711 = phi i1 [ false, %LSL1707 ], [ %t1710, %LSR1707 ]
br i1 %t1711, label %L601, label %L603
L601:
%t1712 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
L603:
ret i64 %p1
}
define internal i64 @rt_str_trim(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1714 = call i64 @c_strlen(i64 %p0)
%t1715 = add i64 %p0, %t1714
%t1716 = call i64 @__mruntime_rt_strutil_resid__skip_space(i64 %p0, i64 %t1715)
%t1717 = call i64 @c_strlen(i64 %p0)
%t1718 = add i64 %p0, %t1717
%t1719 = call i64 @__mruntime_rt_strutil_resid__back_space(i64 %t1716, i64 %t1718)
%t1720 = sub i64 %t1719, %t1716
%t1721 = call i64 @cstr_from__rs22(i64 %t1716, i64 %t1720)
ret i64 %t1721
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
%t1722 = call i64 @c_strstr(i64 %p0, i64 %p1)
%t1723 = icmp ne i64 %t1722, 0
br i1 %t1723, label %L604, label %L605
L604:
br label %L606
L605:
br label %L606
L606:
%t1724 = phi i64 [ 1, %L604 ], [ 0, %L605 ]
ret i64 %t1724
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
%t1725 = call i64 @c_strlen(i64 %p1)
%t1726 = call i64 @c_strncmp(i64 %p0, i64 %p1, i64 %t1725)
%t1727 = icmp eq i64 %t1726, 0
br i1 %t1727, label %L607, label %L608
L607:
br label %L609
L608:
br label %L609
L609:
%t1728 = phi i64 [ 1, %L607 ], [ 0, %L608 ]
ret i64 %t1728
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
%t1729 = call i64 @c_strlen(i64 %p0)
%t1730 = call i64 @c_strlen(i64 %p1)
%t1731 = icmp sgt i64 %t1730, %t1729
br i1 %t1731, label %L610, label %L612
L610:
ret i64 0
L612:
%t1732 = add i64 %p0, %t1729
%t1733 = sub i64 %t1732, %t1730
%t1734 = call i64 @c_strcmp(i64 %t1733, i64 %p1)
%t1735 = icmp eq i64 %t1734, 0
br i1 %t1735, label %L613, label %L614
L613:
br label %L615
L614:
br label %L615
L615:
%t1736 = phi i64 [ 1, %L613 ], [ 0, %L614 ]
ret i64 %t1736
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
%t1737 = icmp slt i64 %p1, 0
br i1 %t1737, label %L616, label %L617
L616:
br label %L618
L617:
br label %L618
L618:
%t1738 = phi i64 [ 0, %L616 ], [ %p1, %L617 ]
%t1739 = call i64 @c_strlen(i64 %p0)
%t1740 = icmp sgt i64 %t1739, 0
br label %LSL1741
LSL1741:
br i1 %t1740, label %LSR1741, label %LSJ1741
LSR1741:
%t1742 = sdiv i64 9223372036854775807, %t1739
%t1743 = icmp sgt i64 %t1738, %t1742
br label %LSJ1741
LSJ1741:
%t1744 = phi i1 [ false, %LSL1741 ], [ %t1743, %LSR1741 ]
br i1 %t1744, label %L619, label %L621
L619:
%t1745 = call i64 @cstr_from__rs60(i64 %p0)
ret i64 %t1745
L621:
%t1746 = mul i64 %t1739, %t1738
%t1747 = add i64 %t1746, 1
%t1748 = call i64 @c_malloc(i64 %t1747)
%t1749 = icmp eq i64 %t1748, 0
br i1 %t1749, label %L622, label %L624
L622:
%t1750 = call i64 @cstr_from__rs60(i64 %p0)
ret i64 %t1750
L624:
%t1751 = call i64 @__mruntime_rt_strutil_resid__repeat_at(i64 %t1748, i64 %p0, i64 %t1739, i64 %t1738)
%t1752 = call i64 @st8(i64 %t1751, i64 0)
ret i64 %t1748
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
%p0 = phi i64 [ %p0.in, %entry ], [ %t1755, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1756, %tco.s0 ]
%t1753 = icmp sle i64 %p3, 0
br i1 %t1753, label %L625, label %L627
L625:
ret i64 %p0
L627:
%t1754 = call i64 @mcopy(i64 %p0, i64 %p1, i64 %p2)
%t1755 = add i64 %p0, %p2
%t1756 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_strutil_resid__count_hits(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1760, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1761, %tco.s0 ]
%t1758 = call i64 @c_strstr(i64 %p0, i64 %p1)
%t1759 = icmp eq i64 %t1758, 0
br i1 %t1759, label %L628, label %L630
L628:
ret i64 %p3
L630:
%t1760 = add i64 %t1758, %p2
%t1761 = add i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_replace(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1763 = call i64 @c_strlen(i64 %p1)
%t1764 = call i64 @c_strlen(i64 %p2)
%t1765 = icmp eq i64 %t1763, 0
br i1 %t1765, label %L631, label %L633
L631:
%t1766 = call i64 @cstr_dup(i64 %p0)
ret i64 %t1766
L633:
%t1767 = call i64 @__mruntime_rt_strutil_resid__count_hits(i64 %p0, i64 %p1, i64 %t1763, i64 0)
%t1768 = call i64 @c_strlen(i64 %p0)
%t1769 = icmp sgt i64 %t1764, %t1763
br i1 %t1769, label %L634, label %L635
L634:
%t1770 = sub i64 %t1764, %t1763
%t1771 = mul i64 %t1767, %t1770
br label %L636
L635:
br label %L636
L636:
%t1772 = phi i64 [ %t1771, %L634 ], [ 0, %L635 ]
%t1773 = add i64 %t1768, %t1772
%t1774 = add i64 %t1773, 1
%t1775 = call i64 @xmalloc(i64 %t1774)
%t1776 = call i64 @__mruntime_rt_strutil_resid__replace_at(i64 %t1775, i64 %p0, i64 %p1, i64 %t1763, i64 %p2, i64 %t1764)
ret i64 %t1775
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
%p0 = phi i64 [ %p0.in, %entry ], [ %t1791, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1792, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t1777 = call i64 @c_strstr(i64 %p1, i64 %p2)
%t1778 = icmp eq i64 %t1777, 0
br i1 %t1778, label %L637, label %L639
L637:
%t1779 = call i64 @c_strlen(i64 %p1)
%t1780 = add i64 %t1779, 1
%t1781 = call i64 @mcopy(i64 %p0, i64 %p1, i64 %t1780)
%t1782 = add i64 %t1781, %p0
%t1783 = add i64 %t1782, %t1779
ret i64 %t1783
L639:
%t1784 = sub i64 %t1777, %p1
%t1785 = call i64 @mcopy(i64 %p0, i64 %p1, i64 %t1784)
%t1786 = sub i64 %t1777, %p1
%t1787 = add i64 %p0, %t1786
%t1788 = call i64 @mcopy(i64 %t1787, i64 %p4, i64 %p5)
%t1789 = sub i64 %t1777, %p1
%t1790 = add i64 %p0, %t1789
%t1791 = add i64 %t1790, %p5
%t1792 = add i64 %t1777, %p3
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_split(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1795 = ptrtoint ptr @.s1794 to i64
%t1796 = call i64 @c_strlen(i64 %p1)
%t1797 = icmp eq i64 %t1796, 0
br i1 %t1797, label %L640, label %L642
L640:
%t1798p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.split_one)
%t1798 = ptrtoint ptr %t1798p to i64
%t1799 = call i64 @st64(i64 %t1798, i64 %p0)
%t1800 = call i64 @c_list_new(i64 1, i64 %t1798, i64 %t1795)
ret i64 %t1800
L642:
%t1801 = call i64 @__mruntime_rt_strutil_resid__count_hits(i64 %p0, i64 %p1, i64 %t1796, i64 0)
%t1802 = add i64 %t1801, 1
%t1803 = mul i64 %t1802, 8
%t1804 = call i64 @xmalloc(i64 %t1803)
%t1805 = call i64 @__mruntime_rt_strutil_resid__split_at(i64 %t1804, i64 0, i64 %p0, i64 %p1, i64 %t1796)
%t1806 = call i64 @c_list_new(i64 %t1802, i64 %t1804, i64 %t1795)
%t1807 = call i64 @c_free(i64 %t1804)
ret i64 %t1806
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t1819, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1820, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t1808 = call i64 @c_strstr(i64 %p2, i64 %p3)
%t1809 = icmp eq i64 %t1808, 0
br i1 %t1809, label %L643, label %L645
L643:
%t1810 = mul i64 %p1, 8
%t1811 = add i64 %p0, %t1810
%t1812 = call i64 @cstr_dup(i64 %p2)
%t1813 = call i64 @st64(i64 %t1811, i64 %t1812)
ret i64 %t1813
L645:
%t1814 = mul i64 %p1, 8
%t1815 = add i64 %p0, %t1814
%t1816 = sub i64 %t1808, %p2
%t1817 = call i64 @cstr_from__rs22(i64 %p2, i64 %t1816)
%t1818 = call i64 @st64(i64 %t1815, i64 %t1817)
%t1819 = add i64 %p1, 1
%t1820 = add i64 %t1808, %p4
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @rt_str_join(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1822 = call i64 @c_list_len(i64 %p0)
%t1823 = call i64 @c_list_to_array(i64 %p0)
%t1824 = call i64 @c_strlen(i64 %p1)
%t1825 = call i64 @__mruntime_rt_strutil_resid__join_len(i64 %t1823, i64 0, i64 %t1822, i64 0)
%t1826 = icmp sgt i64 %t1822, 0
br i1 %t1826, label %L646, label %L647
L646:
%t1827 = sub nsw i64 %t1822, 1
%t1828 = mul i64 %t1824, %t1827
br label %L648
L647:
br label %L648
L648:
%t1829 = phi i64 [ %t1828, %L646 ], [ 0, %L647 ]
%t1830 = add i64 %t1825, %t1829
%t1831 = add i64 %t1830, 1
%t1832 = call i64 @xmalloc(i64 %t1831)
%t1833 = call i64 @__mruntime_rt_strutil_resid__join_at(i64 %t1832, i64 %t1823, i64 0, i64 %t1822, i64 %p1, i64 %t1824)
%t1834 = call i64 @st8(i64 %t1833, i64 0)
%t1835 = call i64 @c_free(i64 %t1823)
ret i64 %t1832
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t1837, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1842, %tco.s0 ]
%t1836 = icmp sge i64 %p1, %p2
br i1 %t1836, label %L649, label %L651
L649:
ret i64 %p3
L651:
%t1837 = add nsw i64 %p1, 1
%t1838 = mul i64 %p1, 8
%t1839 = add i64 %p0, %t1838
%t1840 = call i64 @ld64(i64 %t1839)
%t1841 = call i64 @c_strlen(i64 %t1840)
%t1842 = add i64 %p3, %t1841
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @__mruntime_rt_strutil_resid__join_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1855, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1856, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t1844 = icmp sge i64 %p2, %p3
br i1 %t1844, label %L652, label %L654
L652:
ret i64 %p0
L654:
%t1845 = icmp sgt i64 %p2, 0
br i1 %t1845, label %L655, label %L656
L655:
%t1846 = call i64 @mcopy(i64 %p0, i64 %p4, i64 %p5)
%t1847 = add i64 %t1846, %p0
%t1848 = add i64 %t1847, %p5
br label %L657
L656:
br label %L657
L657:
%t1849 = phi i64 [ %t1848, %L655 ], [ %p0, %L656 ]
%t1850 = mul i64 %p2, 8
%t1851 = add i64 %p1, %t1850
%t1852 = call i64 @ld64(i64 %t1851)
%t1853 = call i64 @c_strlen(i64 %t1852)
%t1854 = call i64 @mcopy(i64 %t1849, i64 %t1852, i64 %t1853)
%t1855 = add i64 %t1849, %t1853
%t1856 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_strutil_resid__all_digits(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1864, %tco.s0 ]
%t1858 = call i64 @ld8(i64 %p0)
%t1859 = icmp eq i64 %t1858, 0
br i1 %t1859, label %L658, label %L660
L658:
ret i1 true
L660:
%t1860 = icmp slt i64 %t1858, 48
br label %LSL1861
LSL1861:
br i1 %t1860, label %LSJ1861, label %LSR1861
LSR1861:
%t1862 = icmp sgt i64 %t1858, 57
br label %LSJ1861
LSJ1861:
%t1863 = phi i1 [ true, %LSL1861 ], [ %t1862, %LSR1861 ]
br i1 %t1863, label %L661, label %L663
L661:
ret i1 false
L663:
%t1864 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_strutil_resid__is_int(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1866 = call i64 @ld8(i64 %p0)
%t1867 = icmp eq i64 %t1866, 0
br i1 %t1867, label %L664, label %L666
L664:
ret i1 false
L666:
%t1868 = icmp eq i64 %t1866, 45
br label %LSL1869
LSL1869:
br i1 %t1868, label %LSJ1869, label %LSR1869
LSR1869:
%t1870 = icmp eq i64 %t1866, 43
br label %LSJ1869
LSJ1869:
%t1871 = phi i1 [ true, %LSL1869 ], [ %t1870, %LSR1869 ]
br i1 %t1871, label %L667, label %L668
L667:
%t1872 = add i64 %p0, 1
br label %L669
L668:
br label %L669
L669:
%t1873 = phi i64 [ %t1872, %L667 ], [ %p0, %L668 ]
%t1874 = call i64 @ld8(i64 %t1873)
%t1875 = icmp ne i64 %t1874, 0
br label %LSL1876
LSL1876:
br i1 %t1875, label %LSR1876, label %LSJ1876
LSR1876:
%t1877 = call i1 @__mruntime_rt_strutil_resid__all_digits(i64 %t1873)
br label %LSJ1876
LSJ1876:
%t1878 = phi i1 [ false, %LSL1876 ], [ %t1877, %LSR1876 ]
ret i1 %t1878
}
define internal i64 @rt_str_is_int(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1879 = call i1 @__mruntime_rt_strutil_resid__is_int(i64 %p0)
br i1 %t1879, label %L670, label %L671
L670:
br label %L672
L671:
br label %L672
L672:
%t1880 = phi i64 [ 1, %L670 ], [ 0, %L671 ]
ret i64 %t1880
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
%t1881 = call i1 @__mruntime_rt_strutil_resid__is_int(i64 %p0)
%t1882 = xor i1 %t1881, true
br i1 %t1882, label %L673, label %L675
L673:
ret i64 0
L675:
%t1883 = call i64 @ld8(i64 %p0)
%t1884 = icmp eq i64 %t1883, 45
%t1885 = call i64 @ld8(i64 %p0)
%t1886 = icmp eq i64 %t1885, 45
br label %LSL1887
LSL1887:
br i1 %t1886, label %LSJ1887, label %LSR1887
LSR1887:
%t1888 = call i64 @ld8(i64 %p0)
%t1889 = icmp eq i64 %t1888, 43
br label %LSJ1887
LSJ1887:
%t1890 = phi i1 [ true, %LSL1887 ], [ %t1889, %LSR1887 ]
br i1 %t1890, label %L676, label %L677
L676:
%t1891 = add i64 %p0, 1
br label %L678
L677:
br label %L678
L678:
%t1892 = phi i64 [ %t1891, %L676 ], [ %p0, %L677 ]
%t1893 = call i64 @__mruntime_rt_strutil_resid__neg_digits__rs67(i64 %t1892)
%t1894 = icmp eq i64 %t1893, 1
br i1 %t1894, label %L679, label %L681
L679:
br i1 %t1884, label %L682, label %L683
L682:
%t1895 = sub i128 -9223372036854775807, 1
%t1896 = add i128 %t1895, 0
%t1897 = trunc i128 %t1896 to i64
%t1898 = sext i64 %t1897 to i128
%t1899 = icmp ne i128 %t1898, %t1896
%t1900 = icmp eq i8 0, 1
%t1901 = or i1 %t1899, %t1900
%t1902 = zext i1 %t1901 to i8
call void @resid_conv_check(i8 %t1902)
%t1903 = sext i64 %t1897 to i128
br label %L684
L683:
br label %L684
L684:
%t1904 = phi i128 [ %t1903, %L682 ], [ 9223372036854775807, %L683 ]
%t1905 = trunc i128 %t1904 to i64
ret i64 %t1905
L681:
br i1 %t1884, label %L685, label %L687
L685:
ret i64 %t1893
L687:
%t1906 = sub i128 -9223372036854775807, 1
%t1907 = add i128 %t1906, 0
%t1908 = trunc i128 %t1907 to i64
%t1909 = sext i64 %t1908 to i128
%t1910 = icmp ne i128 %t1909, %t1907
%t1911 = icmp eq i8 0, 1
%t1912 = or i1 %t1910, %t1911
%t1913 = zext i1 %t1912 to i8
call void @resid_conv_check(i8 %t1913)
%t1914 = sext i64 %t1908 to i128
%t1915 = sext i64 %t1893 to i128
%t1916 = icmp eq i128 %t1915, %t1914
br i1 %t1916, label %L688, label %L690
L688:
%t1917 = trunc i128 9223372036854775807 to i64
ret i64 %t1917
L690:
%t1918 = sub i64 0, %t1893
ret i64 %t1918
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
%p0 = phi i64 [ %p0.in, %entry ], [ %t1929, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1931, %tco.s0 ]
%t1919 = call i64 @ld8(i64 %p0)
%t1920 = icmp eq i64 %t1919, 0
br i1 %t1920, label %L691, label %L693
L691:
ret i64 %p1
L693:
%t1921 = sub i64 %t1919, 48
%t1922 = icmp slt i64 %p1, -922337203685477580
br label %LSL1923
LSL1923:
br i1 %t1922, label %LSJ1923, label %LSR1923
LSR1923:
%t1924 = icmp eq i64 %p1, -922337203685477580
br label %LSL1925
LSL1925:
br i1 %t1924, label %LSR1925, label %LSJ1925
LSR1925:
%t1926 = icmp sgt i64 %t1921, 8
br label %LSJ1925
LSJ1925:
%t1927 = phi i1 [ false, %LSL1925 ], [ %t1926, %LSR1925 ]
br label %LSJ1923
LSJ1923:
%t1928 = phi i1 [ true, %LSL1923 ], [ %t1927, %LSJ1925 ]
br i1 %t1928, label %L694, label %L696
L694:
ret i64 1
L696:
%t1929 = add i64 %p0, 1
%t1930 = mul i64 %p1, 10
%t1931 = sub i64 %t1930, %t1921
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i1 @__mruntime_rt_strutil_resid__is_float(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1933 = call i64 @ld8(i64 %p0)
%t1934 = icmp eq i64 %t1933, 0
br i1 %t1934, label %L697, label %L699
L697:
ret i1 false
L699:
%t1935p = call ptr @llvm.threadlocal.address.p0(ptr @rtg.strtod_end)
%t1935 = ptrtoint ptr %t1935p to i64
%t1936 = call double @c_strtod(i64 %p0, i64 %t1935)
%t1937 = call i64 @ld64(i64 %t1935)
%t1938 = call i64 @__mruntime_rt_strutil_resid__skip_tabs(i64 %t1937)
%t1939 = call i64 @ld8(i64 %t1938)
%t1940 = icmp eq i64 %t1939, 0
br label %LSL1941
LSL1941:
br i1 %t1940, label %LSR1941, label %LSJ1941
LSR1941:
%t1942 = icmp ne i64 %t1937, %p0
br label %LSJ1941
LSJ1941:
%t1943 = phi i1 [ false, %LSL1941 ], [ %t1942, %LSR1941 ]
ret i1 %t1943
}
define internal i64 @__mruntime_rt_strutil_resid__skip_tabs(i64 %p0.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t1949, %tco.s0 ]
%t1944 = call i64 @ld8(i64 %p0)
%t1945 = icmp eq i64 %t1944, 32
br label %LSL1946
LSL1946:
br i1 %t1945, label %LSJ1946, label %LSR1946
LSR1946:
%t1947 = icmp eq i64 %t1944, 9
br label %LSJ1946
LSJ1946:
%t1948 = phi i1 [ true, %LSL1946 ], [ %t1947, %LSR1946 ]
br i1 %t1948, label %L700, label %L702
L700:
%t1949 = add i64 %p0, 1
br label %tco.s0
tco.s0:
br label %tco.head
L702:
ret i64 %p0
}
define internal i64 @rt_str_is_float(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1951 = call i1 @__mruntime_rt_strutil_resid__is_float(i64 %p0)
br i1 %t1951, label %L703, label %L704
L703:
br label %L705
L704:
br label %L705
L705:
%t1952 = phi i64 [ 1, %L703 ], [ 0, %L704 ]
ret i64 %t1952
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
%t1953 = call i1 @__mruntime_rt_strutil_resid__is_float(i64 %p0)
%t1954 = xor i1 %t1953, true
br i1 %t1954, label %L706, label %L708
L706:
ret double 0.0
L708:
%t1955 = call double @c_strtod(i64 %p0, i64 0)
ret double %t1955
}
define double @str_parse_float(ptr %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0i = ptrtoint ptr %a0 to i64
%r = call double @rt_str_parse_float(i64 %x0i)
ret double %r
}
define internal i64 @rt_str_count(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1956 = call i64 @c_strlen(i64 %p1)
%t1957 = icmp eq i64 %t1956, 0
br i1 %t1957, label %L709, label %L711
L709:
ret i64 0
L711:
%t1958 = call i64 @__mruntime_rt_strutil_resid__count_hits(i64 %p0, i64 %p1, i64 %t1956, i64 0)
ret i64 %t1958
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
%t1959 = call i64 @c_strlen(i64 %p0)
%t1960 = add i64 %t1959, 1
%t1961 = call i64 @xmalloc(i64 %t1960)
%t1962 = add i64 %t1961, %t1959
%t1963 = call i64 @__mruntime_rt_strutil_resid__rev_at(i64 %p0, i64 %t1962)
%t1964 = add i64 %t1961, %t1959
%t1965 = call i64 @st8(i64 %t1964, i64 0)
ret i64 %t1961
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
%p0 = phi i64 [ %p0.in, %entry ], [ %t1971, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1972, %tco.s0 ]
%t1966 = call i64 @ld8(i64 %p0)
%t1967 = icmp eq i64 %t1966, 0
br i1 %t1967, label %L712, label %L714
L712:
ret i64 0
L714:
%t1968 = call i64 @utf8_len_at(i64 %p0)
%t1969 = sub i64 %p1, %t1968
%t1970 = call i64 @mcopy(i64 %t1969, i64 %p0, i64 %t1968)
%t1971 = add i64 %p0, %t1968
%t1972 = sub i64 %p1, %t1968
br label %tco.s0
tco.s0:
br label %tco.head
}
define internal i64 @cstr_from__rs22(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1974 = add i64 %p1, 1
%t1975 = call i64 @xmalloc(i64 %t1974)
%t1976 = call i64 @mcopy(i64 %t1975, i64 %p0, i64 %p1)
%t1977 = add i64 %t1975, %p1
%t1978 = call i64 @st8(i64 %t1977, i64 0)
ret i64 %t1975
}
define internal i64 @__mruntime_rt_text_resid__idx_find__rs30(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1979 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t1980 = add nsw i64 %t1979, 0
%t1981 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1980)
%t1982 = icmp eq i64 %t1981, %p0
br i1 %t1982, label %L715, label %L717
L715:
ret i64 %t1980
L717:
%t1983 = call i64 @__mruntime_rt_text_resid__idx_find(i64 %p0, i64 1)
ret i64 %t1983
}
define internal i64 @cstr_from__rs33(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1984 = add i64 %p1, 1
%t1985 = call i64 @ralloc(i64 %t1984)
%t1986 = call i64 @mcopy(i64 %t1985, i64 %p0, i64 %p1)
%t1987 = add i64 %t1985, %p1
%t1988 = call i64 @st8(i64 %t1987, i64 0)
ret i64 %t1985
}
define internal i64 @__mruntime_rt_text_resid__find_from__rs36(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1989 = sub i64 %p3, 1
%t1990 = sub i64 %t1989, %p4
%t1991 = sub i64 %p1, %t1990
%t1992 = icmp sge i64 %p5, %t1991
br i1 %t1992, label %L718, label %L720
L718:
ret i64 0
L720:
%t1993 = add i64 %p2, %p4
%t1994 = call i64 @ld8(i64 %t1993)
%t1995 = sub i64 %t1991, %p5
%t1996 = call i64 @c_memchr(i64 %p5, i64 %t1994, i64 %t1995)
%t1997 = icmp eq i64 %t1996, 0
br i1 %t1997, label %L721, label %L723
L721:
ret i64 0
L723:
%t1998 = sub i64 %t1996, %p4
%t1999 = call i64 @c_memcmp(i64 %t1998, i64 %p2, i64 %p3)
%t2000 = icmp eq i64 %t1999, 0
br i1 %t2000, label %L724, label %L726
L724:
ret i64 %t1998
L726:
%t2001 = add i64 %t1996, 1
%t2002 = call i64 @__mruntime_rt_text_resid__find_from(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %t2001, i64 1)
ret i64 %t2002
}
define internal i64 @__mruntime_rt_case_resid__case_bs__rs47(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2003 = add i64 %p0, 160
%t2004 = call i64 @ld64(i64 %t2003)
%t2005 = icmp eq i64 %p1, %t2004
br i1 %t2005, label %L727, label %L729
L727:
%t2006 = add i64 %p0, 160
%t2007 = add i64 %t2006, 8
%t2008 = call i64 @ld64(i64 %t2007)
ret i64 %t2008
L729:
%t2009 = icmp slt i64 %p1, %t2004
br i1 %t2009, label %L730, label %L732
L730:
%t2010 = call i64 @__mruntime_rt_case_resid__case_bs(i64 %p0, i64 %p1, i64 0, i64 9)
ret i64 %t2010
L732:
%t2011 = call i64 @__mruntime_rt_case_resid__case_bs(i64 %p0, i64 %p1, i64 11, i64 20)
ret i64 %t2011
}
define internal i64 @__mruntime_rt_case_resid__case_bs__rs46(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2012 = add i64 %p0, 336
%t2013 = call i64 @ld64(i64 %t2012)
%t2014 = icmp eq i64 %p1, %t2013
br i1 %t2014, label %L733, label %L735
L733:
%t2015 = add i64 %p0, 336
%t2016 = add i64 %t2015, 8
%t2017 = call i64 @ld64(i64 %t2016)
ret i64 %t2017
L735:
%t2018 = icmp slt i64 %p1, %t2013
br i1 %t2018, label %L736, label %L738
L736:
%t2019 = tail call i64 @__mruntime_rt_case_resid__case_bs__rs47(i64 %p0, i64 %p1)
ret i64 %t2019
L738:
%t2020 = call i64 @__mruntime_rt_case_resid__case_bs(i64 %p0, i64 %p1, i64 22, i64 43)
ret i64 %t2020
}
define internal i64 @__mruntime_rt_case_resid__case_bs__rs45(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2021 = add i64 %p0, 704
%t2022 = call i64 @ld64(i64 %t2021)
%t2023 = icmp eq i64 %p1, %t2022
br i1 %t2023, label %L739, label %L741
L739:
%t2024 = add i64 %p0, 704
%t2025 = add i64 %t2024, 8
%t2026 = call i64 @ld64(i64 %t2025)
ret i64 %t2026
L741:
%t2027 = icmp slt i64 %p1, %t2022
br i1 %t2027, label %L742, label %L744
L742:
%t2028 = tail call i64 @__mruntime_rt_case_resid__case_bs__rs46(i64 %p0, i64 %p1)
ret i64 %t2028
L744:
%t2029 = call i64 @__mruntime_rt_case_resid__case_bs(i64 %p0, i64 %p1, i64 45, i64 89)
ret i64 %t2029
}
define internal i64 @__mruntime_rt_case_resid__case_bs__rs44(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2030 = add i64 %p0, 1440
%t2031 = call i64 @ld64(i64 %t2030)
%t2032 = icmp eq i64 %p1, %t2031
br i1 %t2032, label %L745, label %L747
L745:
%t2033 = add i64 %p0, 1440
%t2034 = add i64 %t2033, 8
%t2035 = call i64 @ld64(i64 %t2034)
ret i64 %t2035
L747:
%t2036 = icmp slt i64 %p1, %t2031
br i1 %t2036, label %L748, label %L750
L748:
%t2037 = tail call i64 @__mruntime_rt_case_resid__case_bs__rs45(i64 %p0, i64 %p1)
ret i64 %t2037
L750:
%t2038 = call i64 @__mruntime_rt_case_resid__case_bs(i64 %p0, i64 %p1, i64 91, i64 180)
ret i64 %t2038
}
define internal i64 @__mruntime_rt_case_resid__case_bs__rs43(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2039 = add i64 %p0, 2896
%t2040 = call i64 @ld64(i64 %t2039)
%t2041 = icmp eq i64 %p1, %t2040
br i1 %t2041, label %L751, label %L753
L751:
%t2042 = add i64 %p0, 2896
%t2043 = add i64 %t2042, 8
%t2044 = call i64 @ld64(i64 %t2043)
ret i64 %t2044
L753:
%t2045 = icmp slt i64 %p1, %t2040
br i1 %t2045, label %L754, label %L756
L754:
%t2046 = tail call i64 @__mruntime_rt_case_resid__case_bs__rs44(i64 %p0, i64 %p1)
ret i64 %t2046
L756:
%t2047 = call i64 @__mruntime_rt_case_resid__case_bs(i64 %p0, i64 %p1, i64 182, i64 363)
ret i64 %t2047
}
define internal i64 @__mruntime_rt_case_resid__case_bs__rs42(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2048 = add i64 %p0, 5824
%t2049 = call i64 @ld64(i64 %t2048)
%t2050 = icmp eq i64 %p1, %t2049
br i1 %t2050, label %L757, label %L759
L757:
%t2051 = add i64 %p0, 5824
%t2052 = add i64 %t2051, 8
%t2053 = call i64 @ld64(i64 %t2052)
ret i64 %t2053
L759:
%t2054 = icmp slt i64 %p1, %t2049
br i1 %t2054, label %L760, label %L762
L760:
%t2055 = tail call i64 @__mruntime_rt_case_resid__case_bs__rs43(i64 %p0, i64 %p1)
ret i64 %t2055
L762:
%t2056 = call i64 @__mruntime_rt_case_resid__case_bs(i64 %p0, i64 %p1, i64 365, i64 728)
ret i64 %t2056
}
define internal i64 @__mruntime_rt_case_resid__case_bs__rs41(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2057 = add i64 %p0, 11664
%t2058 = call i64 @ld64(i64 %t2057)
%t2059 = icmp eq i64 %p1, %t2058
br i1 %t2059, label %L763, label %L765
L763:
%t2060 = add i64 %p0, 11664
%t2061 = add i64 %t2060, 8
%t2062 = call i64 @ld64(i64 %t2061)
ret i64 %t2062
L765:
%t2063 = icmp slt i64 %p1, %t2058
br i1 %t2063, label %L766, label %L768
L766:
%t2064 = tail call i64 @__mruntime_rt_case_resid__case_bs__rs42(i64 %p0, i64 %p1)
ret i64 %t2064
L768:
%t2065 = call i64 @__mruntime_rt_case_resid__case_bs(i64 %p0, i64 %p1, i64 730, i64 1458)
ret i64 %t2065
}
define internal i64 @__mruntime_rt_case_resid__case_lookup__rs40(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2066 = tail call i64 @__mruntime_rt_case_resid__case_bs__rs41(i64 %p0, i64 %p1)
ret i64 %t2066
}
define internal i64 @__mruntime_rt_case_resid__special_bs__rs55(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
ret i64 0
}
define internal i64 @__mruntime_rt_case_resid__special_bs__rs54(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2067 = add nsw i64 %p0, 0
%t2068 = call i64 @ld64(i64 %t2067)
%t2069 = icmp eq i64 %p1, %t2068
br i1 %t2069, label %L769, label %L771
L769:
ret i64 %t2067
L771:
%t2070 = icmp slt i64 %p1, %t2068
br i1 %t2070, label %L772, label %L774
L772:
%t2071 = tail call i64 @__mruntime_rt_case_resid__special_bs__rs55(i64 %p0, i64 %p1)
ret i64 %t2071
L774:
%t2072 = call i64 @__mruntime_rt_case_resid__special_bs(i64 %p0, i64 %p1, i64 1, i64 0)
ret i64 %t2072
}
define internal i64 @__mruntime_rt_case_resid__special_bs__rs53(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2073 = add i64 %p0, 88
%t2074 = call i64 @ld64(i64 %t2073)
%t2075 = icmp eq i64 %p1, %t2074
br i1 %t2075, label %L775, label %L777
L775:
ret i64 %t2073
L777:
%t2076 = icmp slt i64 %p1, %t2074
br i1 %t2076, label %L778, label %L780
L778:
%t2077 = tail call i64 @__mruntime_rt_case_resid__special_bs__rs54(i64 %p0, i64 %p1)
ret i64 %t2077
L780:
%t2078 = call i64 @__mruntime_rt_case_resid__special_bs(i64 %p0, i64 %p1, i64 2, i64 3)
ret i64 %t2078
}
define internal i64 @__mruntime_rt_case_resid__special_bs__rs52(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2079 = add i64 %p0, 352
%t2080 = call i64 @ld64(i64 %t2079)
%t2081 = icmp eq i64 %p1, %t2080
br i1 %t2081, label %L781, label %L783
L781:
ret i64 %t2079
L783:
%t2082 = icmp slt i64 %p1, %t2080
br i1 %t2082, label %L784, label %L786
L784:
%t2083 = tail call i64 @__mruntime_rt_case_resid__special_bs__rs53(i64 %p0, i64 %p1)
ret i64 %t2083
L786:
%t2084 = call i64 @__mruntime_rt_case_resid__special_bs(i64 %p0, i64 %p1, i64 5, i64 8)
ret i64 %t2084
}
define internal i64 @__mruntime_rt_case_resid__special_bs__rs51(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2085 = add i64 %p0, 792
%t2086 = call i64 @ld64(i64 %t2085)
%t2087 = icmp eq i64 %p1, %t2086
br i1 %t2087, label %L787, label %L789
L787:
ret i64 %t2085
L789:
%t2088 = icmp slt i64 %p1, %t2086
br i1 %t2088, label %L790, label %L792
L790:
%t2089 = tail call i64 @__mruntime_rt_case_resid__special_bs__rs52(i64 %p0, i64 %p1)
ret i64 %t2089
L792:
%t2090 = call i64 @__mruntime_rt_case_resid__special_bs(i64 %p0, i64 %p1, i64 10, i64 19)
ret i64 %t2090
}
define internal i64 @__mruntime_rt_case_resid__special_bs__rs50(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2091 = add i64 %p0, 1760
%t2092 = call i64 @ld64(i64 %t2091)
%t2093 = icmp eq i64 %p1, %t2092
br i1 %t2093, label %L793, label %L795
L793:
ret i64 %t2091
L795:
%t2094 = icmp slt i64 %p1, %t2092
br i1 %t2094, label %L796, label %L798
L796:
%t2095 = tail call i64 @__mruntime_rt_case_resid__special_bs__rs51(i64 %p0, i64 %p1)
ret i64 %t2095
L798:
%t2096 = call i64 @__mruntime_rt_case_resid__special_bs(i64 %p0, i64 %p1, i64 21, i64 40)
ret i64 %t2096
}
define internal i64 @__mruntime_rt_case_resid__special_bs__rs49(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2097 = add i64 %p0, 3608
%t2098 = call i64 @ld64(i64 %t2097)
%t2099 = icmp eq i64 %p1, %t2098
br i1 %t2099, label %L799, label %L801
L799:
ret i64 %t2097
L801:
%t2100 = icmp slt i64 %p1, %t2098
br i1 %t2100, label %L802, label %L804
L802:
%t2101 = tail call i64 @__mruntime_rt_case_resid__special_bs__rs50(i64 %p0, i64 %p1)
ret i64 %t2101
L804:
%t2102 = call i64 @__mruntime_rt_case_resid__special_bs(i64 %p0, i64 %p1, i64 42, i64 82)
ret i64 %t2102
}
define internal i64 @case_simple__rs57(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2103 = call i64 @case_lower_tab()
%t2104 = call i64 @__mruntime_rt_case_resid__case_lookup__rs40(i64 %t2103, i64 %p0)
%t2105 = icmp ne i64 %t2104, 0
br i1 %t2105, label %L805, label %L806
L805:
br label %L807
L806:
br label %L807
L807:
%t2106 = phi i64 [ %t2104, %L805 ], [ %p0, %L806 ]
ret i64 %t2106
}
define internal i64 @case_simple__rs58(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2107 = call i64 @case_upper_tab()
%t2108 = call i64 @__mruntime_rt_case_resid__case_lookup(i64 %t2107, i64 1450, i64 %p0)
%t2109 = icmp ne i64 %t2108, 0
br i1 %t2109, label %L808, label %L809
L808:
br label %L810
L809:
br label %L810
L810:
%t2110 = phi i64 [ %t2108, %L808 ], [ %p0, %L809 ]
ret i64 %t2110
}
define internal i64 @cstr_from__rs60(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2111 = call i64 @xmalloc(i64 1)
%t2112 = call i64 @mcopy(i64 %t2111, i64 %p0, i64 0)
%t2113 = add nsw i64 %t2111, 0
%t2114 = call i64 @st8(i64 %t2113, i64 0)
ret i64 %t2111
}
define internal i64 @__mruntime_rt_strutil_resid__neg_digits__rs67(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t2115 = call i64 @ld8(i64 %p0)
%t2116 = icmp eq i64 %t2115, 0
br i1 %t2116, label %L811, label %L813
L811:
ret i64 0
L813:
%t2117 = sub i64 %t2115, 48
%t2118 = add i64 %p0, 1
%t2119 = sub i64 0, %t2117
%t2120 = call i64 @__mruntime_rt_strutil_resid__neg_digits(i64 %t2118, i64 %t2119)
ret i64 %t2120
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
@.s15 = private unnamed_addr constant [14 x i8] c"out of memory\00"
@.s21 = private unnamed_addr constant [14 x i8] c"out of memory\00"
@.s112 = private unnamed_addr constant [2 x i8] c"\0A\00"
@rtg.iov = internal thread_local global [32 x i8] zeroinitializer, align 16
@.s121 = private unnamed_addr constant [2 x i8] c"\0A\00"
@rtg.rt_flags = internal global [24 x i8] zeroinitializer, align 16
@.s168 = private unnamed_addr constant [39 x i8] c"integer overflow in checked arithmetic\00"
@.s171 = private unnamed_addr constant [25 x i8] c"integer division by zero\00"
@.s174 = private unnamed_addr constant [32 x i8] c"numeric conversion out of range\00"
@.s191 = private unnamed_addr constant [31 x i8] c"wrapping_div: division by zero\00"
@.s207 = private unnamed_addr constant [32 x i8] c"wrapping_udiv: division by zero\00"
@.s373 = private unnamed_addr constant [30 x i8] c"checked_div: division by zero\00"
@.s387 = private unnamed_addr constant [31 x i8] c"checked_udiv: division by zero\00"
@rtg.cap_stack = internal thread_local global [16384 x i8] zeroinitializer, align 16
@rtg.cap_ns = internal thread_local global [256 x i8] zeroinitializer, align 16
@rtg.cap_depth = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s568 = private unnamed_addr constant [56 x i8] c"capability: sandbox nesting exceeds RESID_CAP_MAX_DEPTH\00"
@.s706 = private unnamed_addr constant [25 x i8] c"capability not granted: \00"
@.s708 = private unnamed_addr constant [9 x i8] c" (write)\00"
@.s710 = private unnamed_addr constant [1 x i8] c"\00"
@rtg.sacc_itoa = internal thread_local global [32 x i8] zeroinitializer, align 16
@rtg.from_code = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.str_slots = internal thread_local global [720 x i8] zeroinitializer, align 16
@rtg.str_state = internal thread_local global [40 x i8] zeroinitializer, align 16
@rtg.sb_cp = internal thread_local global [8 x i8] zeroinitializer, align 16
@.s1478 = private unnamed_addr constant [1 x i8] c"\00"
@rtt.8216 = private unnamed_addr constant [2918 x i64] [i64 65, i64 97, i64 66, i64 98, i64 67, i64 99, i64 68, i64 100, i64 69, i64 101, i64 70, i64 102, i64 71, i64 103, i64 72, i64 104, i64 73, i64 105, i64 74, i64 106, i64 75, i64 107, i64 76, i64 108, i64 77, i64 109, i64 78, i64 110, i64 79, i64 111, i64 80, i64 112, i64 81, i64 113, i64 82, i64 114, i64 83, i64 115, i64 84, i64 116, i64 85, i64 117, i64 86, i64 118, i64 87, i64 119, i64 88, i64 120, i64 89, i64 121, i64 90, i64 122, i64 192, i64 224, i64 193, i64 225, i64 194, i64 226, i64 195, i64 227, i64 196, i64 228, i64 197, i64 229, i64 198, i64 230, i64 199, i64 231, i64 200, i64 232, i64 201, i64 233, i64 202, i64 234, i64 203, i64 235, i64 204, i64 236, i64 205, i64 237, i64 206, i64 238, i64 207, i64 239, i64 208, i64 240, i64 209, i64 241, i64 210, i64 242, i64 211, i64 243, i64 212, i64 244, i64 213, i64 245, i64 214, i64 246, i64 216, i64 248, i64 217, i64 249, i64 218, i64 250, i64 219, i64 251, i64 220, i64 252, i64 221, i64 253, i64 222, i64 254, i64 256, i64 257, i64 258, i64 259, i64 260, i64 261, i64 262, i64 263, i64 264, i64 265, i64 266, i64 267, i64 268, i64 269, i64 270, i64 271, i64 272, i64 273, i64 274, i64 275, i64 276, i64 277, i64 278, i64 279, i64 280, i64 281, i64 282, i64 283, i64 284, i64 285, i64 286, i64 287, i64 288, i64 289, i64 290, i64 291, i64 292, i64 293, i64 294, i64 295, i64 296, i64 297, i64 298, i64 299, i64 300, i64 301, i64 302, i64 303, i64 306, i64 307, i64 308, i64 309, i64 310, i64 311, i64 313, i64 314, i64 315, i64 316, i64 317, i64 318, i64 319, i64 320, i64 321, i64 322, i64 323, i64 324, i64 325, i64 326, i64 327, i64 328, i64 330, i64 331, i64 332, i64 333, i64 334, i64 335, i64 336, i64 337, i64 338, i64 339, i64 340, i64 341, i64 342, i64 343, i64 344, i64 345, i64 346, i64 347, i64 348, i64 349, i64 350, i64 351, i64 352, i64 353, i64 354, i64 355, i64 356, i64 357, i64 358, i64 359, i64 360, i64 361, i64 362, i64 363, i64 364, i64 365, i64 366, i64 367, i64 368, i64 369, i64 370, i64 371, i64 372, i64 373, i64 374, i64 375, i64 376, i64 255, i64 377, i64 378, i64 379, i64 380, i64 381, i64 382, i64 385, i64 595, i64 386, i64 387, i64 388, i64 389, i64 390, i64 596, i64 391, i64 392, i64 393, i64 598, i64 394, i64 599, i64 395, i64 396, i64 398, i64 477, i64 399, i64 601, i64 400, i64 603, i64 401, i64 402, i64 403, i64 608, i64 404, i64 611, i64 406, i64 617, i64 407, i64 616, i64 408, i64 409, i64 412, i64 623, i64 413, i64 626, i64 415, i64 629, i64 416, i64 417, i64 418, i64 419, i64 420, i64 421, i64 422, i64 640, i64 423, i64 424, i64 425, i64 643, i64 428, i64 429, i64 430, i64 648, i64 431, i64 432, i64 433, i64 650, i64 434, i64 651, i64 435, i64 436, i64 437, i64 438, i64 439, i64 658, i64 440, i64 441, i64 444, i64 445, i64 452, i64 454, i64 453, i64 454, i64 455, i64 457, i64 456, i64 457, i64 458, i64 460, i64 459, i64 460, i64 461, i64 462, i64 463, i64 464, i64 465, i64 466, i64 467, i64 468, i64 469, i64 470, i64 471, i64 472, i64 473, i64 474, i64 475, i64 476, i64 478, i64 479, i64 480, i64 481, i64 482, i64 483, i64 484, i64 485, i64 486, i64 487, i64 488, i64 489, i64 490, i64 491, i64 492, i64 493, i64 494, i64 495, i64 497, i64 499, i64 498, i64 499, i64 500, i64 501, i64 502, i64 405, i64 503, i64 447, i64 504, i64 505, i64 506, i64 507, i64 508, i64 509, i64 510, i64 511, i64 512, i64 513, i64 514, i64 515, i64 516, i64 517, i64 518, i64 519, i64 520, i64 521, i64 522, i64 523, i64 524, i64 525, i64 526, i64 527, i64 528, i64 529, i64 530, i64 531, i64 532, i64 533, i64 534, i64 535, i64 536, i64 537, i64 538, i64 539, i64 540, i64 541, i64 542, i64 543, i64 544, i64 414, i64 546, i64 547, i64 548, i64 549, i64 550, i64 551, i64 552, i64 553, i64 554, i64 555, i64 556, i64 557, i64 558, i64 559, i64 560, i64 561, i64 562, i64 563, i64 570, i64 11365, i64 571, i64 572, i64 573, i64 410, i64 574, i64 11366, i64 577, i64 578, i64 579, i64 384, i64 580, i64 649, i64 581, i64 652, i64 582, i64 583, i64 584, i64 585, i64 586, i64 587, i64 588, i64 589, i64 590, i64 591, i64 880, i64 881, i64 882, i64 883, i64 886, i64 887, i64 895, i64 1011, i64 902, i64 940, i64 904, i64 941, i64 905, i64 942, i64 906, i64 943, i64 908, i64 972, i64 910, i64 973, i64 911, i64 974, i64 913, i64 945, i64 914, i64 946, i64 915, i64 947, i64 916, i64 948, i64 917, i64 949, i64 918, i64 950, i64 919, i64 951, i64 920, i64 952, i64 921, i64 953, i64 922, i64 954, i64 923, i64 955, i64 924, i64 956, i64 925, i64 957, i64 926, i64 958, i64 927, i64 959, i64 928, i64 960, i64 929, i64 961, i64 931, i64 963, i64 932, i64 964, i64 933, i64 965, i64 934, i64 966, i64 935, i64 967, i64 936, i64 968, i64 937, i64 969, i64 938, i64 970, i64 939, i64 971, i64 975, i64 983, i64 984, i64 985, i64 986, i64 987, i64 988, i64 989, i64 990, i64 991, i64 992, i64 993, i64 994, i64 995, i64 996, i64 997, i64 998, i64 999, i64 1000, i64 1001, i64 1002, i64 1003, i64 1004, i64 1005, i64 1006, i64 1007, i64 1012, i64 952, i64 1015, i64 1016, i64 1017, i64 1010, i64 1018, i64 1019, i64 1021, i64 891, i64 1022, i64 892, i64 1023, i64 893, i64 1024, i64 1104, i64 1025, i64 1105, i64 1026, i64 1106, i64 1027, i64 1107, i64 1028, i64 1108, i64 1029, i64 1109, i64 1030, i64 1110, i64 1031, i64 1111, i64 1032, i64 1112, i64 1033, i64 1113, i64 1034, i64 1114, i64 1035, i64 1115, i64 1036, i64 1116, i64 1037, i64 1117, i64 1038, i64 1118, i64 1039, i64 1119, i64 1040, i64 1072, i64 1041, i64 1073, i64 1042, i64 1074, i64 1043, i64 1075, i64 1044, i64 1076, i64 1045, i64 1077, i64 1046, i64 1078, i64 1047, i64 1079, i64 1048, i64 1080, i64 1049, i64 1081, i64 1050, i64 1082, i64 1051, i64 1083, i64 1052, i64 1084, i64 1053, i64 1085, i64 1054, i64 1086, i64 1055, i64 1087, i64 1056, i64 1088, i64 1057, i64 1089, i64 1058, i64 1090, i64 1059, i64 1091, i64 1060, i64 1092, i64 1061, i64 1093, i64 1062, i64 1094, i64 1063, i64 1095, i64 1064, i64 1096, i64 1065, i64 1097, i64 1066, i64 1098, i64 1067, i64 1099, i64 1068, i64 1100, i64 1069, i64 1101, i64 1070, i64 1102, i64 1071, i64 1103, i64 1120, i64 1121, i64 1122, i64 1123, i64 1124, i64 1125, i64 1126, i64 1127, i64 1128, i64 1129, i64 1130, i64 1131, i64 1132, i64 1133, i64 1134, i64 1135, i64 1136, i64 1137, i64 1138, i64 1139, i64 1140, i64 1141, i64 1142, i64 1143, i64 1144, i64 1145, i64 1146, i64 1147, i64 1148, i64 1149, i64 1150, i64 1151, i64 1152, i64 1153, i64 1162, i64 1163, i64 1164, i64 1165, i64 1166, i64 1167, i64 1168, i64 1169, i64 1170, i64 1171, i64 1172, i64 1173, i64 1174, i64 1175, i64 1176, i64 1177, i64 1178, i64 1179, i64 1180, i64 1181, i64 1182, i64 1183, i64 1184, i64 1185, i64 1186, i64 1187, i64 1188, i64 1189, i64 1190, i64 1191, i64 1192, i64 1193, i64 1194, i64 1195, i64 1196, i64 1197, i64 1198, i64 1199, i64 1200, i64 1201, i64 1202, i64 1203, i64 1204, i64 1205, i64 1206, i64 1207, i64 1208, i64 1209, i64 1210, i64 1211, i64 1212, i64 1213, i64 1214, i64 1215, i64 1216, i64 1231, i64 1217, i64 1218, i64 1219, i64 1220, i64 1221, i64 1222, i64 1223, i64 1224, i64 1225, i64 1226, i64 1227, i64 1228, i64 1229, i64 1230, i64 1232, i64 1233, i64 1234, i64 1235, i64 1236, i64 1237, i64 1238, i64 1239, i64 1240, i64 1241, i64 1242, i64 1243, i64 1244, i64 1245, i64 1246, i64 1247, i64 1248, i64 1249, i64 1250, i64 1251, i64 1252, i64 1253, i64 1254, i64 1255, i64 1256, i64 1257, i64 1258, i64 1259, i64 1260, i64 1261, i64 1262, i64 1263, i64 1264, i64 1265, i64 1266, i64 1267, i64 1268, i64 1269, i64 1270, i64 1271, i64 1272, i64 1273, i64 1274, i64 1275, i64 1276, i64 1277, i64 1278, i64 1279, i64 1280, i64 1281, i64 1282, i64 1283, i64 1284, i64 1285, i64 1286, i64 1287, i64 1288, i64 1289, i64 1290, i64 1291, i64 1292, i64 1293, i64 1294, i64 1295, i64 1296, i64 1297, i64 1298, i64 1299, i64 1300, i64 1301, i64 1302, i64 1303, i64 1304, i64 1305, i64 1306, i64 1307, i64 1308, i64 1309, i64 1310, i64 1311, i64 1312, i64 1313, i64 1314, i64 1315, i64 1316, i64 1317, i64 1318, i64 1319, i64 1320, i64 1321, i64 1322, i64 1323, i64 1324, i64 1325, i64 1326, i64 1327, i64 1329, i64 1377, i64 1330, i64 1378, i64 1331, i64 1379, i64 1332, i64 1380, i64 1333, i64 1381, i64 1334, i64 1382, i64 1335, i64 1383, i64 1336, i64 1384, i64 1337, i64 1385, i64 1338, i64 1386, i64 1339, i64 1387, i64 1340, i64 1388, i64 1341, i64 1389, i64 1342, i64 1390, i64 1343, i64 1391, i64 1344, i64 1392, i64 1345, i64 1393, i64 1346, i64 1394, i64 1347, i64 1395, i64 1348, i64 1396, i64 1349, i64 1397, i64 1350, i64 1398, i64 1351, i64 1399, i64 1352, i64 1400, i64 1353, i64 1401, i64 1354, i64 1402, i64 1355, i64 1403, i64 1356, i64 1404, i64 1357, i64 1405, i64 1358, i64 1406, i64 1359, i64 1407, i64 1360, i64 1408, i64 1361, i64 1409, i64 1362, i64 1410, i64 1363, i64 1411, i64 1364, i64 1412, i64 1365, i64 1413, i64 1366, i64 1414, i64 4256, i64 11520, i64 4257, i64 11521, i64 4258, i64 11522, i64 4259, i64 11523, i64 4260, i64 11524, i64 4261, i64 11525, i64 4262, i64 11526, i64 4263, i64 11527, i64 4264, i64 11528, i64 4265, i64 11529, i64 4266, i64 11530, i64 4267, i64 11531, i64 4268, i64 11532, i64 4269, i64 11533, i64 4270, i64 11534, i64 4271, i64 11535, i64 4272, i64 11536, i64 4273, i64 11537, i64 4274, i64 11538, i64 4275, i64 11539, i64 4276, i64 11540, i64 4277, i64 11541, i64 4278, i64 11542, i64 4279, i64 11543, i64 4280, i64 11544, i64 4281, i64 11545, i64 4282, i64 11546, i64 4283, i64 11547, i64 4284, i64 11548, i64 4285, i64 11549, i64 4286, i64 11550, i64 4287, i64 11551, i64 4288, i64 11552, i64 4289, i64 11553, i64 4290, i64 11554, i64 4291, i64 11555, i64 4292, i64 11556, i64 4293, i64 11557, i64 4295, i64 11559, i64 4301, i64 11565, i64 5024, i64 43888, i64 5025, i64 43889, i64 5026, i64 43890, i64 5027, i64 43891, i64 5028, i64 43892, i64 5029, i64 43893, i64 5030, i64 43894, i64 5031, i64 43895, i64 5032, i64 43896, i64 5033, i64 43897, i64 5034, i64 43898, i64 5035, i64 43899, i64 5036, i64 43900, i64 5037, i64 43901, i64 5038, i64 43902, i64 5039, i64 43903, i64 5040, i64 43904, i64 5041, i64 43905, i64 5042, i64 43906, i64 5043, i64 43907, i64 5044, i64 43908, i64 5045, i64 43909, i64 5046, i64 43910, i64 5047, i64 43911, i64 5048, i64 43912, i64 5049, i64 43913, i64 5050, i64 43914, i64 5051, i64 43915, i64 5052, i64 43916, i64 5053, i64 43917, i64 5054, i64 43918, i64 5055, i64 43919, i64 5056, i64 43920, i64 5057, i64 43921, i64 5058, i64 43922, i64 5059, i64 43923, i64 5060, i64 43924, i64 5061, i64 43925, i64 5062, i64 43926, i64 5063, i64 43927, i64 5064, i64 43928, i64 5065, i64 43929, i64 5066, i64 43930, i64 5067, i64 43931, i64 5068, i64 43932, i64 5069, i64 43933, i64 5070, i64 43934, i64 5071, i64 43935, i64 5072, i64 43936, i64 5073, i64 43937, i64 5074, i64 43938, i64 5075, i64 43939, i64 5076, i64 43940, i64 5077, i64 43941, i64 5078, i64 43942, i64 5079, i64 43943, i64 5080, i64 43944, i64 5081, i64 43945, i64 5082, i64 43946, i64 5083, i64 43947, i64 5084, i64 43948, i64 5085, i64 43949, i64 5086, i64 43950, i64 5087, i64 43951, i64 5088, i64 43952, i64 5089, i64 43953, i64 5090, i64 43954, i64 5091, i64 43955, i64 5092, i64 43956, i64 5093, i64 43957, i64 5094, i64 43958, i64 5095, i64 43959, i64 5096, i64 43960, i64 5097, i64 43961, i64 5098, i64 43962, i64 5099, i64 43963, i64 5100, i64 43964, i64 5101, i64 43965, i64 5102, i64 43966, i64 5103, i64 43967, i64 5104, i64 5112, i64 5105, i64 5113, i64 5106, i64 5114, i64 5107, i64 5115, i64 5108, i64 5116, i64 5109, i64 5117, i64 7305, i64 7306, i64 7312, i64 4304, i64 7313, i64 4305, i64 7314, i64 4306, i64 7315, i64 4307, i64 7316, i64 4308, i64 7317, i64 4309, i64 7318, i64 4310, i64 7319, i64 4311, i64 7320, i64 4312, i64 7321, i64 4313, i64 7322, i64 4314, i64 7323, i64 4315, i64 7324, i64 4316, i64 7325, i64 4317, i64 7326, i64 4318, i64 7327, i64 4319, i64 7328, i64 4320, i64 7329, i64 4321, i64 7330, i64 4322, i64 7331, i64 4323, i64 7332, i64 4324, i64 7333, i64 4325, i64 7334, i64 4326, i64 7335, i64 4327, i64 7336, i64 4328, i64 7337, i64 4329, i64 7338, i64 4330, i64 7339, i64 4331, i64 7340, i64 4332, i64 7341, i64 4333, i64 7342, i64 4334, i64 7343, i64 4335, i64 7344, i64 4336, i64 7345, i64 4337, i64 7346, i64 4338, i64 7347, i64 4339, i64 7348, i64 4340, i64 7349, i64 4341, i64 7350, i64 4342, i64 7351, i64 4343, i64 7352, i64 4344, i64 7353, i64 4345, i64 7354, i64 4346, i64 7357, i64 4349, i64 7358, i64 4350, i64 7359, i64 4351, i64 7680, i64 7681, i64 7682, i64 7683, i64 7684, i64 7685, i64 7686, i64 7687, i64 7688, i64 7689, i64 7690, i64 7691, i64 7692, i64 7693, i64 7694, i64 7695, i64 7696, i64 7697, i64 7698, i64 7699, i64 7700, i64 7701, i64 7702, i64 7703, i64 7704, i64 7705, i64 7706, i64 7707, i64 7708, i64 7709, i64 7710, i64 7711, i64 7712, i64 7713, i64 7714, i64 7715, i64 7716, i64 7717, i64 7718, i64 7719, i64 7720, i64 7721, i64 7722, i64 7723, i64 7724, i64 7725, i64 7726, i64 7727, i64 7728, i64 7729, i64 7730, i64 7731, i64 7732, i64 7733, i64 7734, i64 7735, i64 7736, i64 7737, i64 7738, i64 7739, i64 7740, i64 7741, i64 7742, i64 7743, i64 7744, i64 7745, i64 7746, i64 7747, i64 7748, i64 7749, i64 7750, i64 7751, i64 7752, i64 7753, i64 7754, i64 7755, i64 7756, i64 7757, i64 7758, i64 7759, i64 7760, i64 7761, i64 7762, i64 7763, i64 7764, i64 7765, i64 7766, i64 7767, i64 7768, i64 7769, i64 7770, i64 7771, i64 7772, i64 7773, i64 7774, i64 7775, i64 7776, i64 7777, i64 7778, i64 7779, i64 7780, i64 7781, i64 7782, i64 7783, i64 7784, i64 7785, i64 7786, i64 7787, i64 7788, i64 7789, i64 7790, i64 7791, i64 7792, i64 7793, i64 7794, i64 7795, i64 7796, i64 7797, i64 7798, i64 7799, i64 7800, i64 7801, i64 7802, i64 7803, i64 7804, i64 7805, i64 7806, i64 7807, i64 7808, i64 7809, i64 7810, i64 7811, i64 7812, i64 7813, i64 7814, i64 7815, i64 7816, i64 7817, i64 7818, i64 7819, i64 7820, i64 7821, i64 7822, i64 7823, i64 7824, i64 7825, i64 7826, i64 7827, i64 7828, i64 7829, i64 7838, i64 223, i64 7840, i64 7841, i64 7842, i64 7843, i64 7844, i64 7845, i64 7846, i64 7847, i64 7848, i64 7849, i64 7850, i64 7851, i64 7852, i64 7853, i64 7854, i64 7855, i64 7856, i64 7857, i64 7858, i64 7859, i64 7860, i64 7861, i64 7862, i64 7863, i64 7864, i64 7865, i64 7866, i64 7867, i64 7868, i64 7869, i64 7870, i64 7871, i64 7872, i64 7873, i64 7874, i64 7875, i64 7876, i64 7877, i64 7878, i64 7879, i64 7880, i64 7881, i64 7882, i64 7883, i64 7884, i64 7885, i64 7886, i64 7887, i64 7888, i64 7889, i64 7890, i64 7891, i64 7892, i64 7893, i64 7894, i64 7895, i64 7896, i64 7897, i64 7898, i64 7899, i64 7900, i64 7901, i64 7902, i64 7903, i64 7904, i64 7905, i64 7906, i64 7907, i64 7908, i64 7909, i64 7910, i64 7911, i64 7912, i64 7913, i64 7914, i64 7915, i64 7916, i64 7917, i64 7918, i64 7919, i64 7920, i64 7921, i64 7922, i64 7923, i64 7924, i64 7925, i64 7926, i64 7927, i64 7928, i64 7929, i64 7930, i64 7931, i64 7932, i64 7933, i64 7934, i64 7935, i64 7944, i64 7936, i64 7945, i64 7937, i64 7946, i64 7938, i64 7947, i64 7939, i64 7948, i64 7940, i64 7949, i64 7941, i64 7950, i64 7942, i64 7951, i64 7943, i64 7960, i64 7952, i64 7961, i64 7953, i64 7962, i64 7954, i64 7963, i64 7955, i64 7964, i64 7956, i64 7965, i64 7957, i64 7976, i64 7968, i64 7977, i64 7969, i64 7978, i64 7970, i64 7979, i64 7971, i64 7980, i64 7972, i64 7981, i64 7973, i64 7982, i64 7974, i64 7983, i64 7975, i64 7992, i64 7984, i64 7993, i64 7985, i64 7994, i64 7986, i64 7995, i64 7987, i64 7996, i64 7988, i64 7997, i64 7989, i64 7998, i64 7990, i64 7999, i64 7991, i64 8008, i64 8000, i64 8009, i64 8001, i64 8010, i64 8002, i64 8011, i64 8003, i64 8012, i64 8004, i64 8013, i64 8005, i64 8025, i64 8017, i64 8027, i64 8019, i64 8029, i64 8021, i64 8031, i64 8023, i64 8040, i64 8032, i64 8041, i64 8033, i64 8042, i64 8034, i64 8043, i64 8035, i64 8044, i64 8036, i64 8045, i64 8037, i64 8046, i64 8038, i64 8047, i64 8039, i64 8072, i64 8064, i64 8073, i64 8065, i64 8074, i64 8066, i64 8075, i64 8067, i64 8076, i64 8068, i64 8077, i64 8069, i64 8078, i64 8070, i64 8079, i64 8071, i64 8088, i64 8080, i64 8089, i64 8081, i64 8090, i64 8082, i64 8091, i64 8083, i64 8092, i64 8084, i64 8093, i64 8085, i64 8094, i64 8086, i64 8095, i64 8087, i64 8104, i64 8096, i64 8105, i64 8097, i64 8106, i64 8098, i64 8107, i64 8099, i64 8108, i64 8100, i64 8109, i64 8101, i64 8110, i64 8102, i64 8111, i64 8103, i64 8120, i64 8112, i64 8121, i64 8113, i64 8122, i64 8048, i64 8123, i64 8049, i64 8124, i64 8115, i64 8136, i64 8050, i64 8137, i64 8051, i64 8138, i64 8052, i64 8139, i64 8053, i64 8140, i64 8131, i64 8152, i64 8144, i64 8153, i64 8145, i64 8154, i64 8054, i64 8155, i64 8055, i64 8168, i64 8160, i64 8169, i64 8161, i64 8170, i64 8058, i64 8171, i64 8059, i64 8172, i64 8165, i64 8184, i64 8056, i64 8185, i64 8057, i64 8186, i64 8060, i64 8187, i64 8061, i64 8188, i64 8179, i64 8486, i64 969, i64 8490, i64 107, i64 8491, i64 229, i64 8498, i64 8526, i64 8544, i64 8560, i64 8545, i64 8561, i64 8546, i64 8562, i64 8547, i64 8563, i64 8548, i64 8564, i64 8549, i64 8565, i64 8550, i64 8566, i64 8551, i64 8567, i64 8552, i64 8568, i64 8553, i64 8569, i64 8554, i64 8570, i64 8555, i64 8571, i64 8556, i64 8572, i64 8557, i64 8573, i64 8558, i64 8574, i64 8559, i64 8575, i64 8579, i64 8580, i64 9398, i64 9424, i64 9399, i64 9425, i64 9400, i64 9426, i64 9401, i64 9427, i64 9402, i64 9428, i64 9403, i64 9429, i64 9404, i64 9430, i64 9405, i64 9431, i64 9406, i64 9432, i64 9407, i64 9433, i64 9408, i64 9434, i64 9409, i64 9435, i64 9410, i64 9436, i64 9411, i64 9437, i64 9412, i64 9438, i64 9413, i64 9439, i64 9414, i64 9440, i64 9415, i64 9441, i64 9416, i64 9442, i64 9417, i64 9443, i64 9418, i64 9444, i64 9419, i64 9445, i64 9420, i64 9446, i64 9421, i64 9447, i64 9422, i64 9448, i64 9423, i64 9449, i64 11264, i64 11312, i64 11265, i64 11313, i64 11266, i64 11314, i64 11267, i64 11315, i64 11268, i64 11316, i64 11269, i64 11317, i64 11270, i64 11318, i64 11271, i64 11319, i64 11272, i64 11320, i64 11273, i64 11321, i64 11274, i64 11322, i64 11275, i64 11323, i64 11276, i64 11324, i64 11277, i64 11325, i64 11278, i64 11326, i64 11279, i64 11327, i64 11280, i64 11328, i64 11281, i64 11329, i64 11282, i64 11330, i64 11283, i64 11331, i64 11284, i64 11332, i64 11285, i64 11333, i64 11286, i64 11334, i64 11287, i64 11335, i64 11288, i64 11336, i64 11289, i64 11337, i64 11290, i64 11338, i64 11291, i64 11339, i64 11292, i64 11340, i64 11293, i64 11341, i64 11294, i64 11342, i64 11295, i64 11343, i64 11296, i64 11344, i64 11297, i64 11345, i64 11298, i64 11346, i64 11299, i64 11347, i64 11300, i64 11348, i64 11301, i64 11349, i64 11302, i64 11350, i64 11303, i64 11351, i64 11304, i64 11352, i64 11305, i64 11353, i64 11306, i64 11354, i64 11307, i64 11355, i64 11308, i64 11356, i64 11309, i64 11357, i64 11310, i64 11358, i64 11311, i64 11359, i64 11360, i64 11361, i64 11362, i64 619, i64 11363, i64 7549, i64 11364, i64 637, i64 11367, i64 11368, i64 11369, i64 11370, i64 11371, i64 11372, i64 11373, i64 593, i64 11374, i64 625, i64 11375, i64 592, i64 11376, i64 594, i64 11378, i64 11379, i64 11381, i64 11382, i64 11390, i64 575, i64 11391, i64 576, i64 11392, i64 11393, i64 11394, i64 11395, i64 11396, i64 11397, i64 11398, i64 11399, i64 11400, i64 11401, i64 11402, i64 11403, i64 11404, i64 11405, i64 11406, i64 11407, i64 11408, i64 11409, i64 11410, i64 11411, i64 11412, i64 11413, i64 11414, i64 11415, i64 11416, i64 11417, i64 11418, i64 11419, i64 11420, i64 11421, i64 11422, i64 11423, i64 11424, i64 11425, i64 11426, i64 11427, i64 11428, i64 11429, i64 11430, i64 11431, i64 11432, i64 11433, i64 11434, i64 11435, i64 11436, i64 11437, i64 11438, i64 11439, i64 11440, i64 11441, i64 11442, i64 11443, i64 11444, i64 11445, i64 11446, i64 11447, i64 11448, i64 11449, i64 11450, i64 11451, i64 11452, i64 11453, i64 11454, i64 11455, i64 11456, i64 11457, i64 11458, i64 11459, i64 11460, i64 11461, i64 11462, i64 11463, i64 11464, i64 11465, i64 11466, i64 11467, i64 11468, i64 11469, i64 11470, i64 11471, i64 11472, i64 11473, i64 11474, i64 11475, i64 11476, i64 11477, i64 11478, i64 11479, i64 11480, i64 11481, i64 11482, i64 11483, i64 11484, i64 11485, i64 11486, i64 11487, i64 11488, i64 11489, i64 11490, i64 11491, i64 11499, i64 11500, i64 11501, i64 11502, i64 11506, i64 11507, i64 42560, i64 42561, i64 42562, i64 42563, i64 42564, i64 42565, i64 42566, i64 42567, i64 42568, i64 42569, i64 42570, i64 42571, i64 42572, i64 42573, i64 42574, i64 42575, i64 42576, i64 42577, i64 42578, i64 42579, i64 42580, i64 42581, i64 42582, i64 42583, i64 42584, i64 42585, i64 42586, i64 42587, i64 42588, i64 42589, i64 42590, i64 42591, i64 42592, i64 42593, i64 42594, i64 42595, i64 42596, i64 42597, i64 42598, i64 42599, i64 42600, i64 42601, i64 42602, i64 42603, i64 42604, i64 42605, i64 42624, i64 42625, i64 42626, i64 42627, i64 42628, i64 42629, i64 42630, i64 42631, i64 42632, i64 42633, i64 42634, i64 42635, i64 42636, i64 42637, i64 42638, i64 42639, i64 42640, i64 42641, i64 42642, i64 42643, i64 42644, i64 42645, i64 42646, i64 42647, i64 42648, i64 42649, i64 42650, i64 42651, i64 42786, i64 42787, i64 42788, i64 42789, i64 42790, i64 42791, i64 42792, i64 42793, i64 42794, i64 42795, i64 42796, i64 42797, i64 42798, i64 42799, i64 42802, i64 42803, i64 42804, i64 42805, i64 42806, i64 42807, i64 42808, i64 42809, i64 42810, i64 42811, i64 42812, i64 42813, i64 42814, i64 42815, i64 42816, i64 42817, i64 42818, i64 42819, i64 42820, i64 42821, i64 42822, i64 42823, i64 42824, i64 42825, i64 42826, i64 42827, i64 42828, i64 42829, i64 42830, i64 42831, i64 42832, i64 42833, i64 42834, i64 42835, i64 42836, i64 42837, i64 42838, i64 42839, i64 42840, i64 42841, i64 42842, i64 42843, i64 42844, i64 42845, i64 42846, i64 42847, i64 42848, i64 42849, i64 42850, i64 42851, i64 42852, i64 42853, i64 42854, i64 42855, i64 42856, i64 42857, i64 42858, i64 42859, i64 42860, i64 42861, i64 42862, i64 42863, i64 42873, i64 42874, i64 42875, i64 42876, i64 42877, i64 7545, i64 42878, i64 42879, i64 42880, i64 42881, i64 42882, i64 42883, i64 42884, i64 42885, i64 42886, i64 42887, i64 42891, i64 42892, i64 42893, i64 613, i64 42896, i64 42897, i64 42898, i64 42899, i64 42902, i64 42903, i64 42904, i64 42905, i64 42906, i64 42907, i64 42908, i64 42909, i64 42910, i64 42911, i64 42912, i64 42913, i64 42914, i64 42915, i64 42916, i64 42917, i64 42918, i64 42919, i64 42920, i64 42921, i64 42922, i64 614, i64 42923, i64 604, i64 42924, i64 609, i64 42925, i64 620, i64 42926, i64 618, i64 42928, i64 670, i64 42929, i64 647, i64 42930, i64 669, i64 42931, i64 43859, i64 42932, i64 42933, i64 42934, i64 42935, i64 42936, i64 42937, i64 42938, i64 42939, i64 42940, i64 42941, i64 42942, i64 42943, i64 42944, i64 42945, i64 42946, i64 42947, i64 42948, i64 42900, i64 42949, i64 642, i64 42950, i64 7566, i64 42951, i64 42952, i64 42953, i64 42954, i64 42955, i64 612, i64 42956, i64 42957, i64 42960, i64 42961, i64 42966, i64 42967, i64 42968, i64 42969, i64 42970, i64 42971, i64 42972, i64 411, i64 42997, i64 42998, i64 65313, i64 65345, i64 65314, i64 65346, i64 65315, i64 65347, i64 65316, i64 65348, i64 65317, i64 65349, i64 65318, i64 65350, i64 65319, i64 65351, i64 65320, i64 65352, i64 65321, i64 65353, i64 65322, i64 65354, i64 65323, i64 65355, i64 65324, i64 65356, i64 65325, i64 65357, i64 65326, i64 65358, i64 65327, i64 65359, i64 65328, i64 65360, i64 65329, i64 65361, i64 65330, i64 65362, i64 65331, i64 65363, i64 65332, i64 65364, i64 65333, i64 65365, i64 65334, i64 65366, i64 65335, i64 65367, i64 65336, i64 65368, i64 65337, i64 65369, i64 65338, i64 65370, i64 66560, i64 66600, i64 66561, i64 66601, i64 66562, i64 66602, i64 66563, i64 66603, i64 66564, i64 66604, i64 66565, i64 66605, i64 66566, i64 66606, i64 66567, i64 66607, i64 66568, i64 66608, i64 66569, i64 66609, i64 66570, i64 66610, i64 66571, i64 66611, i64 66572, i64 66612, i64 66573, i64 66613, i64 66574, i64 66614, i64 66575, i64 66615, i64 66576, i64 66616, i64 66577, i64 66617, i64 66578, i64 66618, i64 66579, i64 66619, i64 66580, i64 66620, i64 66581, i64 66621, i64 66582, i64 66622, i64 66583, i64 66623, i64 66584, i64 66624, i64 66585, i64 66625, i64 66586, i64 66626, i64 66587, i64 66627, i64 66588, i64 66628, i64 66589, i64 66629, i64 66590, i64 66630, i64 66591, i64 66631, i64 66592, i64 66632, i64 66593, i64 66633, i64 66594, i64 66634, i64 66595, i64 66635, i64 66596, i64 66636, i64 66597, i64 66637, i64 66598, i64 66638, i64 66599, i64 66639, i64 66736, i64 66776, i64 66737, i64 66777, i64 66738, i64 66778, i64 66739, i64 66779, i64 66740, i64 66780, i64 66741, i64 66781, i64 66742, i64 66782, i64 66743, i64 66783, i64 66744, i64 66784, i64 66745, i64 66785, i64 66746, i64 66786, i64 66747, i64 66787, i64 66748, i64 66788, i64 66749, i64 66789, i64 66750, i64 66790, i64 66751, i64 66791, i64 66752, i64 66792, i64 66753, i64 66793, i64 66754, i64 66794, i64 66755, i64 66795, i64 66756, i64 66796, i64 66757, i64 66797, i64 66758, i64 66798, i64 66759, i64 66799, i64 66760, i64 66800, i64 66761, i64 66801, i64 66762, i64 66802, i64 66763, i64 66803, i64 66764, i64 66804, i64 66765, i64 66805, i64 66766, i64 66806, i64 66767, i64 66807, i64 66768, i64 66808, i64 66769, i64 66809, i64 66770, i64 66810, i64 66771, i64 66811, i64 66928, i64 66967, i64 66929, i64 66968, i64 66930, i64 66969, i64 66931, i64 66970, i64 66932, i64 66971, i64 66933, i64 66972, i64 66934, i64 66973, i64 66935, i64 66974, i64 66936, i64 66975, i64 66937, i64 66976, i64 66938, i64 66977, i64 66940, i64 66979, i64 66941, i64 66980, i64 66942, i64 66981, i64 66943, i64 66982, i64 66944, i64 66983, i64 66945, i64 66984, i64 66946, i64 66985, i64 66947, i64 66986, i64 66948, i64 66987, i64 66949, i64 66988, i64 66950, i64 66989, i64 66951, i64 66990, i64 66952, i64 66991, i64 66953, i64 66992, i64 66954, i64 66993, i64 66956, i64 66995, i64 66957, i64 66996, i64 66958, i64 66997, i64 66959, i64 66998, i64 66960, i64 66999, i64 66961, i64 67000, i64 66962, i64 67001, i64 66964, i64 67003, i64 66965, i64 67004, i64 68736, i64 68800, i64 68737, i64 68801, i64 68738, i64 68802, i64 68739, i64 68803, i64 68740, i64 68804, i64 68741, i64 68805, i64 68742, i64 68806, i64 68743, i64 68807, i64 68744, i64 68808, i64 68745, i64 68809, i64 68746, i64 68810, i64 68747, i64 68811, i64 68748, i64 68812, i64 68749, i64 68813, i64 68750, i64 68814, i64 68751, i64 68815, i64 68752, i64 68816, i64 68753, i64 68817, i64 68754, i64 68818, i64 68755, i64 68819, i64 68756, i64 68820, i64 68757, i64 68821, i64 68758, i64 68822, i64 68759, i64 68823, i64 68760, i64 68824, i64 68761, i64 68825, i64 68762, i64 68826, i64 68763, i64 68827, i64 68764, i64 68828, i64 68765, i64 68829, i64 68766, i64 68830, i64 68767, i64 68831, i64 68768, i64 68832, i64 68769, i64 68833, i64 68770, i64 68834, i64 68771, i64 68835, i64 68772, i64 68836, i64 68773, i64 68837, i64 68774, i64 68838, i64 68775, i64 68839, i64 68776, i64 68840, i64 68777, i64 68841, i64 68778, i64 68842, i64 68779, i64 68843, i64 68780, i64 68844, i64 68781, i64 68845, i64 68782, i64 68846, i64 68783, i64 68847, i64 68784, i64 68848, i64 68785, i64 68849, i64 68786, i64 68850, i64 68944, i64 68976, i64 68945, i64 68977, i64 68946, i64 68978, i64 68947, i64 68979, i64 68948, i64 68980, i64 68949, i64 68981, i64 68950, i64 68982, i64 68951, i64 68983, i64 68952, i64 68984, i64 68953, i64 68985, i64 68954, i64 68986, i64 68955, i64 68987, i64 68956, i64 68988, i64 68957, i64 68989, i64 68958, i64 68990, i64 68959, i64 68991, i64 68960, i64 68992, i64 68961, i64 68993, i64 68962, i64 68994, i64 68963, i64 68995, i64 68964, i64 68996, i64 68965, i64 68997, i64 71840, i64 71872, i64 71841, i64 71873, i64 71842, i64 71874, i64 71843, i64 71875, i64 71844, i64 71876, i64 71845, i64 71877, i64 71846, i64 71878, i64 71847, i64 71879, i64 71848, i64 71880, i64 71849, i64 71881, i64 71850, i64 71882, i64 71851, i64 71883, i64 71852, i64 71884, i64 71853, i64 71885, i64 71854, i64 71886, i64 71855, i64 71887, i64 71856, i64 71888, i64 71857, i64 71889, i64 71858, i64 71890, i64 71859, i64 71891, i64 71860, i64 71892, i64 71861, i64 71893, i64 71862, i64 71894, i64 71863, i64 71895, i64 71864, i64 71896, i64 71865, i64 71897, i64 71866, i64 71898, i64 71867, i64 71899, i64 71868, i64 71900, i64 71869, i64 71901, i64 71870, i64 71902, i64 71871, i64 71903, i64 93760, i64 93792, i64 93761, i64 93793, i64 93762, i64 93794, i64 93763, i64 93795, i64 93764, i64 93796, i64 93765, i64 93797, i64 93766, i64 93798, i64 93767, i64 93799, i64 93768, i64 93800, i64 93769, i64 93801, i64 93770, i64 93802, i64 93771, i64 93803, i64 93772, i64 93804, i64 93773, i64 93805, i64 93774, i64 93806, i64 93775, i64 93807, i64 93776, i64 93808, i64 93777, i64 93809, i64 93778, i64 93810, i64 93779, i64 93811, i64 93780, i64 93812, i64 93781, i64 93813, i64 93782, i64 93814, i64 93783, i64 93815, i64 93784, i64 93816, i64 93785, i64 93817, i64 93786, i64 93818, i64 93787, i64 93819, i64 93788, i64 93820, i64 93789, i64 93821, i64 93790, i64 93822, i64 93791, i64 93823, i64 125184, i64 125218, i64 125185, i64 125219, i64 125186, i64 125220, i64 125187, i64 125221, i64 125188, i64 125222, i64 125189, i64 125223, i64 125190, i64 125224, i64 125191, i64 125225, i64 125192, i64 125226, i64 125193, i64 125227, i64 125194, i64 125228, i64 125195, i64 125229, i64 125196, i64 125230, i64 125197, i64 125231, i64 125198, i64 125232, i64 125199, i64 125233, i64 125200, i64 125234, i64 125201, i64 125235, i64 125202, i64 125236, i64 125203, i64 125237, i64 125204, i64 125238, i64 125205, i64 125239, i64 125206, i64 125240, i64 125207, i64 125241, i64 125208, i64 125242, i64 125209, i64 125243, i64 125210, i64 125244, i64 125211, i64 125245, i64 125212, i64 125246, i64 125213, i64 125247, i64 125214, i64 125248, i64 125215, i64 125249, i64 125216, i64 125250, i64 125217, i64 125251], align 16
@rtt.11127 = private unnamed_addr constant [2900 x i64] [i64 97, i64 65, i64 98, i64 66, i64 99, i64 67, i64 100, i64 68, i64 101, i64 69, i64 102, i64 70, i64 103, i64 71, i64 104, i64 72, i64 105, i64 73, i64 106, i64 74, i64 107, i64 75, i64 108, i64 76, i64 109, i64 77, i64 110, i64 78, i64 111, i64 79, i64 112, i64 80, i64 113, i64 81, i64 114, i64 82, i64 115, i64 83, i64 116, i64 84, i64 117, i64 85, i64 118, i64 86, i64 119, i64 87, i64 120, i64 88, i64 121, i64 89, i64 122, i64 90, i64 181, i64 924, i64 224, i64 192, i64 225, i64 193, i64 226, i64 194, i64 227, i64 195, i64 228, i64 196, i64 229, i64 197, i64 230, i64 198, i64 231, i64 199, i64 232, i64 200, i64 233, i64 201, i64 234, i64 202, i64 235, i64 203, i64 236, i64 204, i64 237, i64 205, i64 238, i64 206, i64 239, i64 207, i64 240, i64 208, i64 241, i64 209, i64 242, i64 210, i64 243, i64 211, i64 244, i64 212, i64 245, i64 213, i64 246, i64 214, i64 248, i64 216, i64 249, i64 217, i64 250, i64 218, i64 251, i64 219, i64 252, i64 220, i64 253, i64 221, i64 254, i64 222, i64 255, i64 376, i64 257, i64 256, i64 259, i64 258, i64 261, i64 260, i64 263, i64 262, i64 265, i64 264, i64 267, i64 266, i64 269, i64 268, i64 271, i64 270, i64 273, i64 272, i64 275, i64 274, i64 277, i64 276, i64 279, i64 278, i64 281, i64 280, i64 283, i64 282, i64 285, i64 284, i64 287, i64 286, i64 289, i64 288, i64 291, i64 290, i64 293, i64 292, i64 295, i64 294, i64 297, i64 296, i64 299, i64 298, i64 301, i64 300, i64 303, i64 302, i64 305, i64 73, i64 307, i64 306, i64 309, i64 308, i64 311, i64 310, i64 314, i64 313, i64 316, i64 315, i64 318, i64 317, i64 320, i64 319, i64 322, i64 321, i64 324, i64 323, i64 326, i64 325, i64 328, i64 327, i64 331, i64 330, i64 333, i64 332, i64 335, i64 334, i64 337, i64 336, i64 339, i64 338, i64 341, i64 340, i64 343, i64 342, i64 345, i64 344, i64 347, i64 346, i64 349, i64 348, i64 351, i64 350, i64 353, i64 352, i64 355, i64 354, i64 357, i64 356, i64 359, i64 358, i64 361, i64 360, i64 363, i64 362, i64 365, i64 364, i64 367, i64 366, i64 369, i64 368, i64 371, i64 370, i64 373, i64 372, i64 375, i64 374, i64 378, i64 377, i64 380, i64 379, i64 382, i64 381, i64 383, i64 83, i64 384, i64 579, i64 387, i64 386, i64 389, i64 388, i64 392, i64 391, i64 396, i64 395, i64 402, i64 401, i64 405, i64 502, i64 409, i64 408, i64 410, i64 573, i64 411, i64 42972, i64 414, i64 544, i64 417, i64 416, i64 419, i64 418, i64 421, i64 420, i64 424, i64 423, i64 429, i64 428, i64 432, i64 431, i64 436, i64 435, i64 438, i64 437, i64 441, i64 440, i64 445, i64 444, i64 447, i64 503, i64 453, i64 452, i64 454, i64 452, i64 456, i64 455, i64 457, i64 455, i64 459, i64 458, i64 460, i64 458, i64 462, i64 461, i64 464, i64 463, i64 466, i64 465, i64 468, i64 467, i64 470, i64 469, i64 472, i64 471, i64 474, i64 473, i64 476, i64 475, i64 477, i64 398, i64 479, i64 478, i64 481, i64 480, i64 483, i64 482, i64 485, i64 484, i64 487, i64 486, i64 489, i64 488, i64 491, i64 490, i64 493, i64 492, i64 495, i64 494, i64 498, i64 497, i64 499, i64 497, i64 501, i64 500, i64 505, i64 504, i64 507, i64 506, i64 509, i64 508, i64 511, i64 510, i64 513, i64 512, i64 515, i64 514, i64 517, i64 516, i64 519, i64 518, i64 521, i64 520, i64 523, i64 522, i64 525, i64 524, i64 527, i64 526, i64 529, i64 528, i64 531, i64 530, i64 533, i64 532, i64 535, i64 534, i64 537, i64 536, i64 539, i64 538, i64 541, i64 540, i64 543, i64 542, i64 547, i64 546, i64 549, i64 548, i64 551, i64 550, i64 553, i64 552, i64 555, i64 554, i64 557, i64 556, i64 559, i64 558, i64 561, i64 560, i64 563, i64 562, i64 572, i64 571, i64 575, i64 11390, i64 576, i64 11391, i64 578, i64 577, i64 583, i64 582, i64 585, i64 584, i64 587, i64 586, i64 589, i64 588, i64 591, i64 590, i64 592, i64 11375, i64 593, i64 11373, i64 594, i64 11376, i64 595, i64 385, i64 596, i64 390, i64 598, i64 393, i64 599, i64 394, i64 601, i64 399, i64 603, i64 400, i64 604, i64 42923, i64 608, i64 403, i64 609, i64 42924, i64 611, i64 404, i64 612, i64 42955, i64 613, i64 42893, i64 614, i64 42922, i64 616, i64 407, i64 617, i64 406, i64 618, i64 42926, i64 619, i64 11362, i64 620, i64 42925, i64 623, i64 412, i64 625, i64 11374, i64 626, i64 413, i64 629, i64 415, i64 637, i64 11364, i64 640, i64 422, i64 642, i64 42949, i64 643, i64 425, i64 647, i64 42929, i64 648, i64 430, i64 649, i64 580, i64 650, i64 433, i64 651, i64 434, i64 652, i64 581, i64 658, i64 439, i64 669, i64 42930, i64 670, i64 42928, i64 837, i64 921, i64 881, i64 880, i64 883, i64 882, i64 887, i64 886, i64 891, i64 1021, i64 892, i64 1022, i64 893, i64 1023, i64 940, i64 902, i64 941, i64 904, i64 942, i64 905, i64 943, i64 906, i64 945, i64 913, i64 946, i64 914, i64 947, i64 915, i64 948, i64 916, i64 949, i64 917, i64 950, i64 918, i64 951, i64 919, i64 952, i64 920, i64 953, i64 921, i64 954, i64 922, i64 955, i64 923, i64 956, i64 924, i64 957, i64 925, i64 958, i64 926, i64 959, i64 927, i64 960, i64 928, i64 961, i64 929, i64 962, i64 931, i64 963, i64 931, i64 964, i64 932, i64 965, i64 933, i64 966, i64 934, i64 967, i64 935, i64 968, i64 936, i64 969, i64 937, i64 970, i64 938, i64 971, i64 939, i64 972, i64 908, i64 973, i64 910, i64 974, i64 911, i64 976, i64 914, i64 977, i64 920, i64 981, i64 934, i64 982, i64 928, i64 983, i64 975, i64 985, i64 984, i64 987, i64 986, i64 989, i64 988, i64 991, i64 990, i64 993, i64 992, i64 995, i64 994, i64 997, i64 996, i64 999, i64 998, i64 1001, i64 1000, i64 1003, i64 1002, i64 1005, i64 1004, i64 1007, i64 1006, i64 1008, i64 922, i64 1009, i64 929, i64 1010, i64 1017, i64 1011, i64 895, i64 1013, i64 917, i64 1016, i64 1015, i64 1019, i64 1018, i64 1072, i64 1040, i64 1073, i64 1041, i64 1074, i64 1042, i64 1075, i64 1043, i64 1076, i64 1044, i64 1077, i64 1045, i64 1078, i64 1046, i64 1079, i64 1047, i64 1080, i64 1048, i64 1081, i64 1049, i64 1082, i64 1050, i64 1083, i64 1051, i64 1084, i64 1052, i64 1085, i64 1053, i64 1086, i64 1054, i64 1087, i64 1055, i64 1088, i64 1056, i64 1089, i64 1057, i64 1090, i64 1058, i64 1091, i64 1059, i64 1092, i64 1060, i64 1093, i64 1061, i64 1094, i64 1062, i64 1095, i64 1063, i64 1096, i64 1064, i64 1097, i64 1065, i64 1098, i64 1066, i64 1099, i64 1067, i64 1100, i64 1068, i64 1101, i64 1069, i64 1102, i64 1070, i64 1103, i64 1071, i64 1104, i64 1024, i64 1105, i64 1025, i64 1106, i64 1026, i64 1107, i64 1027, i64 1108, i64 1028, i64 1109, i64 1029, i64 1110, i64 1030, i64 1111, i64 1031, i64 1112, i64 1032, i64 1113, i64 1033, i64 1114, i64 1034, i64 1115, i64 1035, i64 1116, i64 1036, i64 1117, i64 1037, i64 1118, i64 1038, i64 1119, i64 1039, i64 1121, i64 1120, i64 1123, i64 1122, i64 1125, i64 1124, i64 1127, i64 1126, i64 1129, i64 1128, i64 1131, i64 1130, i64 1133, i64 1132, i64 1135, i64 1134, i64 1137, i64 1136, i64 1139, i64 1138, i64 1141, i64 1140, i64 1143, i64 1142, i64 1145, i64 1144, i64 1147, i64 1146, i64 1149, i64 1148, i64 1151, i64 1150, i64 1153, i64 1152, i64 1163, i64 1162, i64 1165, i64 1164, i64 1167, i64 1166, i64 1169, i64 1168, i64 1171, i64 1170, i64 1173, i64 1172, i64 1175, i64 1174, i64 1177, i64 1176, i64 1179, i64 1178, i64 1181, i64 1180, i64 1183, i64 1182, i64 1185, i64 1184, i64 1187, i64 1186, i64 1189, i64 1188, i64 1191, i64 1190, i64 1193, i64 1192, i64 1195, i64 1194, i64 1197, i64 1196, i64 1199, i64 1198, i64 1201, i64 1200, i64 1203, i64 1202, i64 1205, i64 1204, i64 1207, i64 1206, i64 1209, i64 1208, i64 1211, i64 1210, i64 1213, i64 1212, i64 1215, i64 1214, i64 1218, i64 1217, i64 1220, i64 1219, i64 1222, i64 1221, i64 1224, i64 1223, i64 1226, i64 1225, i64 1228, i64 1227, i64 1230, i64 1229, i64 1231, i64 1216, i64 1233, i64 1232, i64 1235, i64 1234, i64 1237, i64 1236, i64 1239, i64 1238, i64 1241, i64 1240, i64 1243, i64 1242, i64 1245, i64 1244, i64 1247, i64 1246, i64 1249, i64 1248, i64 1251, i64 1250, i64 1253, i64 1252, i64 1255, i64 1254, i64 1257, i64 1256, i64 1259, i64 1258, i64 1261, i64 1260, i64 1263, i64 1262, i64 1265, i64 1264, i64 1267, i64 1266, i64 1269, i64 1268, i64 1271, i64 1270, i64 1273, i64 1272, i64 1275, i64 1274, i64 1277, i64 1276, i64 1279, i64 1278, i64 1281, i64 1280, i64 1283, i64 1282, i64 1285, i64 1284, i64 1287, i64 1286, i64 1289, i64 1288, i64 1291, i64 1290, i64 1293, i64 1292, i64 1295, i64 1294, i64 1297, i64 1296, i64 1299, i64 1298, i64 1301, i64 1300, i64 1303, i64 1302, i64 1305, i64 1304, i64 1307, i64 1306, i64 1309, i64 1308, i64 1311, i64 1310, i64 1313, i64 1312, i64 1315, i64 1314, i64 1317, i64 1316, i64 1319, i64 1318, i64 1321, i64 1320, i64 1323, i64 1322, i64 1325, i64 1324, i64 1327, i64 1326, i64 1377, i64 1329, i64 1378, i64 1330, i64 1379, i64 1331, i64 1380, i64 1332, i64 1381, i64 1333, i64 1382, i64 1334, i64 1383, i64 1335, i64 1384, i64 1336, i64 1385, i64 1337, i64 1386, i64 1338, i64 1387, i64 1339, i64 1388, i64 1340, i64 1389, i64 1341, i64 1390, i64 1342, i64 1391, i64 1343, i64 1392, i64 1344, i64 1393, i64 1345, i64 1394, i64 1346, i64 1395, i64 1347, i64 1396, i64 1348, i64 1397, i64 1349, i64 1398, i64 1350, i64 1399, i64 1351, i64 1400, i64 1352, i64 1401, i64 1353, i64 1402, i64 1354, i64 1403, i64 1355, i64 1404, i64 1356, i64 1405, i64 1357, i64 1406, i64 1358, i64 1407, i64 1359, i64 1408, i64 1360, i64 1409, i64 1361, i64 1410, i64 1362, i64 1411, i64 1363, i64 1412, i64 1364, i64 1413, i64 1365, i64 1414, i64 1366, i64 4304, i64 7312, i64 4305, i64 7313, i64 4306, i64 7314, i64 4307, i64 7315, i64 4308, i64 7316, i64 4309, i64 7317, i64 4310, i64 7318, i64 4311, i64 7319, i64 4312, i64 7320, i64 4313, i64 7321, i64 4314, i64 7322, i64 4315, i64 7323, i64 4316, i64 7324, i64 4317, i64 7325, i64 4318, i64 7326, i64 4319, i64 7327, i64 4320, i64 7328, i64 4321, i64 7329, i64 4322, i64 7330, i64 4323, i64 7331, i64 4324, i64 7332, i64 4325, i64 7333, i64 4326, i64 7334, i64 4327, i64 7335, i64 4328, i64 7336, i64 4329, i64 7337, i64 4330, i64 7338, i64 4331, i64 7339, i64 4332, i64 7340, i64 4333, i64 7341, i64 4334, i64 7342, i64 4335, i64 7343, i64 4336, i64 7344, i64 4337, i64 7345, i64 4338, i64 7346, i64 4339, i64 7347, i64 4340, i64 7348, i64 4341, i64 7349, i64 4342, i64 7350, i64 4343, i64 7351, i64 4344, i64 7352, i64 4345, i64 7353, i64 4346, i64 7354, i64 4349, i64 7357, i64 4350, i64 7358, i64 4351, i64 7359, i64 5112, i64 5104, i64 5113, i64 5105, i64 5114, i64 5106, i64 5115, i64 5107, i64 5116, i64 5108, i64 5117, i64 5109, i64 7296, i64 1042, i64 7297, i64 1044, i64 7298, i64 1054, i64 7299, i64 1057, i64 7300, i64 1058, i64 7301, i64 1058, i64 7302, i64 1066, i64 7303, i64 1122, i64 7304, i64 42570, i64 7306, i64 7305, i64 7545, i64 42877, i64 7549, i64 11363, i64 7566, i64 42950, i64 7681, i64 7680, i64 7683, i64 7682, i64 7685, i64 7684, i64 7687, i64 7686, i64 7689, i64 7688, i64 7691, i64 7690, i64 7693, i64 7692, i64 7695, i64 7694, i64 7697, i64 7696, i64 7699, i64 7698, i64 7701, i64 7700, i64 7703, i64 7702, i64 7705, i64 7704, i64 7707, i64 7706, i64 7709, i64 7708, i64 7711, i64 7710, i64 7713, i64 7712, i64 7715, i64 7714, i64 7717, i64 7716, i64 7719, i64 7718, i64 7721, i64 7720, i64 7723, i64 7722, i64 7725, i64 7724, i64 7727, i64 7726, i64 7729, i64 7728, i64 7731, i64 7730, i64 7733, i64 7732, i64 7735, i64 7734, i64 7737, i64 7736, i64 7739, i64 7738, i64 7741, i64 7740, i64 7743, i64 7742, i64 7745, i64 7744, i64 7747, i64 7746, i64 7749, i64 7748, i64 7751, i64 7750, i64 7753, i64 7752, i64 7755, i64 7754, i64 7757, i64 7756, i64 7759, i64 7758, i64 7761, i64 7760, i64 7763, i64 7762, i64 7765, i64 7764, i64 7767, i64 7766, i64 7769, i64 7768, i64 7771, i64 7770, i64 7773, i64 7772, i64 7775, i64 7774, i64 7777, i64 7776, i64 7779, i64 7778, i64 7781, i64 7780, i64 7783, i64 7782, i64 7785, i64 7784, i64 7787, i64 7786, i64 7789, i64 7788, i64 7791, i64 7790, i64 7793, i64 7792, i64 7795, i64 7794, i64 7797, i64 7796, i64 7799, i64 7798, i64 7801, i64 7800, i64 7803, i64 7802, i64 7805, i64 7804, i64 7807, i64 7806, i64 7809, i64 7808, i64 7811, i64 7810, i64 7813, i64 7812, i64 7815, i64 7814, i64 7817, i64 7816, i64 7819, i64 7818, i64 7821, i64 7820, i64 7823, i64 7822, i64 7825, i64 7824, i64 7827, i64 7826, i64 7829, i64 7828, i64 7835, i64 7776, i64 7841, i64 7840, i64 7843, i64 7842, i64 7845, i64 7844, i64 7847, i64 7846, i64 7849, i64 7848, i64 7851, i64 7850, i64 7853, i64 7852, i64 7855, i64 7854, i64 7857, i64 7856, i64 7859, i64 7858, i64 7861, i64 7860, i64 7863, i64 7862, i64 7865, i64 7864, i64 7867, i64 7866, i64 7869, i64 7868, i64 7871, i64 7870, i64 7873, i64 7872, i64 7875, i64 7874, i64 7877, i64 7876, i64 7879, i64 7878, i64 7881, i64 7880, i64 7883, i64 7882, i64 7885, i64 7884, i64 7887, i64 7886, i64 7889, i64 7888, i64 7891, i64 7890, i64 7893, i64 7892, i64 7895, i64 7894, i64 7897, i64 7896, i64 7899, i64 7898, i64 7901, i64 7900, i64 7903, i64 7902, i64 7905, i64 7904, i64 7907, i64 7906, i64 7909, i64 7908, i64 7911, i64 7910, i64 7913, i64 7912, i64 7915, i64 7914, i64 7917, i64 7916, i64 7919, i64 7918, i64 7921, i64 7920, i64 7923, i64 7922, i64 7925, i64 7924, i64 7927, i64 7926, i64 7929, i64 7928, i64 7931, i64 7930, i64 7933, i64 7932, i64 7935, i64 7934, i64 7936, i64 7944, i64 7937, i64 7945, i64 7938, i64 7946, i64 7939, i64 7947, i64 7940, i64 7948, i64 7941, i64 7949, i64 7942, i64 7950, i64 7943, i64 7951, i64 7952, i64 7960, i64 7953, i64 7961, i64 7954, i64 7962, i64 7955, i64 7963, i64 7956, i64 7964, i64 7957, i64 7965, i64 7968, i64 7976, i64 7969, i64 7977, i64 7970, i64 7978, i64 7971, i64 7979, i64 7972, i64 7980, i64 7973, i64 7981, i64 7974, i64 7982, i64 7975, i64 7983, i64 7984, i64 7992, i64 7985, i64 7993, i64 7986, i64 7994, i64 7987, i64 7995, i64 7988, i64 7996, i64 7989, i64 7997, i64 7990, i64 7998, i64 7991, i64 7999, i64 8000, i64 8008, i64 8001, i64 8009, i64 8002, i64 8010, i64 8003, i64 8011, i64 8004, i64 8012, i64 8005, i64 8013, i64 8017, i64 8025, i64 8019, i64 8027, i64 8021, i64 8029, i64 8023, i64 8031, i64 8032, i64 8040, i64 8033, i64 8041, i64 8034, i64 8042, i64 8035, i64 8043, i64 8036, i64 8044, i64 8037, i64 8045, i64 8038, i64 8046, i64 8039, i64 8047, i64 8048, i64 8122, i64 8049, i64 8123, i64 8050, i64 8136, i64 8051, i64 8137, i64 8052, i64 8138, i64 8053, i64 8139, i64 8054, i64 8154, i64 8055, i64 8155, i64 8056, i64 8184, i64 8057, i64 8185, i64 8058, i64 8170, i64 8059, i64 8171, i64 8060, i64 8186, i64 8061, i64 8187, i64 8112, i64 8120, i64 8113, i64 8121, i64 8126, i64 921, i64 8144, i64 8152, i64 8145, i64 8153, i64 8160, i64 8168, i64 8161, i64 8169, i64 8165, i64 8172, i64 8526, i64 8498, i64 8560, i64 8544, i64 8561, i64 8545, i64 8562, i64 8546, i64 8563, i64 8547, i64 8564, i64 8548, i64 8565, i64 8549, i64 8566, i64 8550, i64 8567, i64 8551, i64 8568, i64 8552, i64 8569, i64 8553, i64 8570, i64 8554, i64 8571, i64 8555, i64 8572, i64 8556, i64 8573, i64 8557, i64 8574, i64 8558, i64 8575, i64 8559, i64 8580, i64 8579, i64 9424, i64 9398, i64 9425, i64 9399, i64 9426, i64 9400, i64 9427, i64 9401, i64 9428, i64 9402, i64 9429, i64 9403, i64 9430, i64 9404, i64 9431, i64 9405, i64 9432, i64 9406, i64 9433, i64 9407, i64 9434, i64 9408, i64 9435, i64 9409, i64 9436, i64 9410, i64 9437, i64 9411, i64 9438, i64 9412, i64 9439, i64 9413, i64 9440, i64 9414, i64 9441, i64 9415, i64 9442, i64 9416, i64 9443, i64 9417, i64 9444, i64 9418, i64 9445, i64 9419, i64 9446, i64 9420, i64 9447, i64 9421, i64 9448, i64 9422, i64 9449, i64 9423, i64 11312, i64 11264, i64 11313, i64 11265, i64 11314, i64 11266, i64 11315, i64 11267, i64 11316, i64 11268, i64 11317, i64 11269, i64 11318, i64 11270, i64 11319, i64 11271, i64 11320, i64 11272, i64 11321, i64 11273, i64 11322, i64 11274, i64 11323, i64 11275, i64 11324, i64 11276, i64 11325, i64 11277, i64 11326, i64 11278, i64 11327, i64 11279, i64 11328, i64 11280, i64 11329, i64 11281, i64 11330, i64 11282, i64 11331, i64 11283, i64 11332, i64 11284, i64 11333, i64 11285, i64 11334, i64 11286, i64 11335, i64 11287, i64 11336, i64 11288, i64 11337, i64 11289, i64 11338, i64 11290, i64 11339, i64 11291, i64 11340, i64 11292, i64 11341, i64 11293, i64 11342, i64 11294, i64 11343, i64 11295, i64 11344, i64 11296, i64 11345, i64 11297, i64 11346, i64 11298, i64 11347, i64 11299, i64 11348, i64 11300, i64 11349, i64 11301, i64 11350, i64 11302, i64 11351, i64 11303, i64 11352, i64 11304, i64 11353, i64 11305, i64 11354, i64 11306, i64 11355, i64 11307, i64 11356, i64 11308, i64 11357, i64 11309, i64 11358, i64 11310, i64 11359, i64 11311, i64 11361, i64 11360, i64 11365, i64 570, i64 11366, i64 574, i64 11368, i64 11367, i64 11370, i64 11369, i64 11372, i64 11371, i64 11379, i64 11378, i64 11382, i64 11381, i64 11393, i64 11392, i64 11395, i64 11394, i64 11397, i64 11396, i64 11399, i64 11398, i64 11401, i64 11400, i64 11403, i64 11402, i64 11405, i64 11404, i64 11407, i64 11406, i64 11409, i64 11408, i64 11411, i64 11410, i64 11413, i64 11412, i64 11415, i64 11414, i64 11417, i64 11416, i64 11419, i64 11418, i64 11421, i64 11420, i64 11423, i64 11422, i64 11425, i64 11424, i64 11427, i64 11426, i64 11429, i64 11428, i64 11431, i64 11430, i64 11433, i64 11432, i64 11435, i64 11434, i64 11437, i64 11436, i64 11439, i64 11438, i64 11441, i64 11440, i64 11443, i64 11442, i64 11445, i64 11444, i64 11447, i64 11446, i64 11449, i64 11448, i64 11451, i64 11450, i64 11453, i64 11452, i64 11455, i64 11454, i64 11457, i64 11456, i64 11459, i64 11458, i64 11461, i64 11460, i64 11463, i64 11462, i64 11465, i64 11464, i64 11467, i64 11466, i64 11469, i64 11468, i64 11471, i64 11470, i64 11473, i64 11472, i64 11475, i64 11474, i64 11477, i64 11476, i64 11479, i64 11478, i64 11481, i64 11480, i64 11483, i64 11482, i64 11485, i64 11484, i64 11487, i64 11486, i64 11489, i64 11488, i64 11491, i64 11490, i64 11500, i64 11499, i64 11502, i64 11501, i64 11507, i64 11506, i64 11520, i64 4256, i64 11521, i64 4257, i64 11522, i64 4258, i64 11523, i64 4259, i64 11524, i64 4260, i64 11525, i64 4261, i64 11526, i64 4262, i64 11527, i64 4263, i64 11528, i64 4264, i64 11529, i64 4265, i64 11530, i64 4266, i64 11531, i64 4267, i64 11532, i64 4268, i64 11533, i64 4269, i64 11534, i64 4270, i64 11535, i64 4271, i64 11536, i64 4272, i64 11537, i64 4273, i64 11538, i64 4274, i64 11539, i64 4275, i64 11540, i64 4276, i64 11541, i64 4277, i64 11542, i64 4278, i64 11543, i64 4279, i64 11544, i64 4280, i64 11545, i64 4281, i64 11546, i64 4282, i64 11547, i64 4283, i64 11548, i64 4284, i64 11549, i64 4285, i64 11550, i64 4286, i64 11551, i64 4287, i64 11552, i64 4288, i64 11553, i64 4289, i64 11554, i64 4290, i64 11555, i64 4291, i64 11556, i64 4292, i64 11557, i64 4293, i64 11559, i64 4295, i64 11565, i64 4301, i64 42561, i64 42560, i64 42563, i64 42562, i64 42565, i64 42564, i64 42567, i64 42566, i64 42569, i64 42568, i64 42571, i64 42570, i64 42573, i64 42572, i64 42575, i64 42574, i64 42577, i64 42576, i64 42579, i64 42578, i64 42581, i64 42580, i64 42583, i64 42582, i64 42585, i64 42584, i64 42587, i64 42586, i64 42589, i64 42588, i64 42591, i64 42590, i64 42593, i64 42592, i64 42595, i64 42594, i64 42597, i64 42596, i64 42599, i64 42598, i64 42601, i64 42600, i64 42603, i64 42602, i64 42605, i64 42604, i64 42625, i64 42624, i64 42627, i64 42626, i64 42629, i64 42628, i64 42631, i64 42630, i64 42633, i64 42632, i64 42635, i64 42634, i64 42637, i64 42636, i64 42639, i64 42638, i64 42641, i64 42640, i64 42643, i64 42642, i64 42645, i64 42644, i64 42647, i64 42646, i64 42649, i64 42648, i64 42651, i64 42650, i64 42787, i64 42786, i64 42789, i64 42788, i64 42791, i64 42790, i64 42793, i64 42792, i64 42795, i64 42794, i64 42797, i64 42796, i64 42799, i64 42798, i64 42803, i64 42802, i64 42805, i64 42804, i64 42807, i64 42806, i64 42809, i64 42808, i64 42811, i64 42810, i64 42813, i64 42812, i64 42815, i64 42814, i64 42817, i64 42816, i64 42819, i64 42818, i64 42821, i64 42820, i64 42823, i64 42822, i64 42825, i64 42824, i64 42827, i64 42826, i64 42829, i64 42828, i64 42831, i64 42830, i64 42833, i64 42832, i64 42835, i64 42834, i64 42837, i64 42836, i64 42839, i64 42838, i64 42841, i64 42840, i64 42843, i64 42842, i64 42845, i64 42844, i64 42847, i64 42846, i64 42849, i64 42848, i64 42851, i64 42850, i64 42853, i64 42852, i64 42855, i64 42854, i64 42857, i64 42856, i64 42859, i64 42858, i64 42861, i64 42860, i64 42863, i64 42862, i64 42874, i64 42873, i64 42876, i64 42875, i64 42879, i64 42878, i64 42881, i64 42880, i64 42883, i64 42882, i64 42885, i64 42884, i64 42887, i64 42886, i64 42892, i64 42891, i64 42897, i64 42896, i64 42899, i64 42898, i64 42900, i64 42948, i64 42903, i64 42902, i64 42905, i64 42904, i64 42907, i64 42906, i64 42909, i64 42908, i64 42911, i64 42910, i64 42913, i64 42912, i64 42915, i64 42914, i64 42917, i64 42916, i64 42919, i64 42918, i64 42921, i64 42920, i64 42933, i64 42932, i64 42935, i64 42934, i64 42937, i64 42936, i64 42939, i64 42938, i64 42941, i64 42940, i64 42943, i64 42942, i64 42945, i64 42944, i64 42947, i64 42946, i64 42952, i64 42951, i64 42954, i64 42953, i64 42957, i64 42956, i64 42961, i64 42960, i64 42967, i64 42966, i64 42969, i64 42968, i64 42971, i64 42970, i64 42998, i64 42997, i64 43859, i64 42931, i64 43888, i64 5024, i64 43889, i64 5025, i64 43890, i64 5026, i64 43891, i64 5027, i64 43892, i64 5028, i64 43893, i64 5029, i64 43894, i64 5030, i64 43895, i64 5031, i64 43896, i64 5032, i64 43897, i64 5033, i64 43898, i64 5034, i64 43899, i64 5035, i64 43900, i64 5036, i64 43901, i64 5037, i64 43902, i64 5038, i64 43903, i64 5039, i64 43904, i64 5040, i64 43905, i64 5041, i64 43906, i64 5042, i64 43907, i64 5043, i64 43908, i64 5044, i64 43909, i64 5045, i64 43910, i64 5046, i64 43911, i64 5047, i64 43912, i64 5048, i64 43913, i64 5049, i64 43914, i64 5050, i64 43915, i64 5051, i64 43916, i64 5052, i64 43917, i64 5053, i64 43918, i64 5054, i64 43919, i64 5055, i64 43920, i64 5056, i64 43921, i64 5057, i64 43922, i64 5058, i64 43923, i64 5059, i64 43924, i64 5060, i64 43925, i64 5061, i64 43926, i64 5062, i64 43927, i64 5063, i64 43928, i64 5064, i64 43929, i64 5065, i64 43930, i64 5066, i64 43931, i64 5067, i64 43932, i64 5068, i64 43933, i64 5069, i64 43934, i64 5070, i64 43935, i64 5071, i64 43936, i64 5072, i64 43937, i64 5073, i64 43938, i64 5074, i64 43939, i64 5075, i64 43940, i64 5076, i64 43941, i64 5077, i64 43942, i64 5078, i64 43943, i64 5079, i64 43944, i64 5080, i64 43945, i64 5081, i64 43946, i64 5082, i64 43947, i64 5083, i64 43948, i64 5084, i64 43949, i64 5085, i64 43950, i64 5086, i64 43951, i64 5087, i64 43952, i64 5088, i64 43953, i64 5089, i64 43954, i64 5090, i64 43955, i64 5091, i64 43956, i64 5092, i64 43957, i64 5093, i64 43958, i64 5094, i64 43959, i64 5095, i64 43960, i64 5096, i64 43961, i64 5097, i64 43962, i64 5098, i64 43963, i64 5099, i64 43964, i64 5100, i64 43965, i64 5101, i64 43966, i64 5102, i64 43967, i64 5103, i64 65345, i64 65313, i64 65346, i64 65314, i64 65347, i64 65315, i64 65348, i64 65316, i64 65349, i64 65317, i64 65350, i64 65318, i64 65351, i64 65319, i64 65352, i64 65320, i64 65353, i64 65321, i64 65354, i64 65322, i64 65355, i64 65323, i64 65356, i64 65324, i64 65357, i64 65325, i64 65358, i64 65326, i64 65359, i64 65327, i64 65360, i64 65328, i64 65361, i64 65329, i64 65362, i64 65330, i64 65363, i64 65331, i64 65364, i64 65332, i64 65365, i64 65333, i64 65366, i64 65334, i64 65367, i64 65335, i64 65368, i64 65336, i64 65369, i64 65337, i64 65370, i64 65338, i64 66600, i64 66560, i64 66601, i64 66561, i64 66602, i64 66562, i64 66603, i64 66563, i64 66604, i64 66564, i64 66605, i64 66565, i64 66606, i64 66566, i64 66607, i64 66567, i64 66608, i64 66568, i64 66609, i64 66569, i64 66610, i64 66570, i64 66611, i64 66571, i64 66612, i64 66572, i64 66613, i64 66573, i64 66614, i64 66574, i64 66615, i64 66575, i64 66616, i64 66576, i64 66617, i64 66577, i64 66618, i64 66578, i64 66619, i64 66579, i64 66620, i64 66580, i64 66621, i64 66581, i64 66622, i64 66582, i64 66623, i64 66583, i64 66624, i64 66584, i64 66625, i64 66585, i64 66626, i64 66586, i64 66627, i64 66587, i64 66628, i64 66588, i64 66629, i64 66589, i64 66630, i64 66590, i64 66631, i64 66591, i64 66632, i64 66592, i64 66633, i64 66593, i64 66634, i64 66594, i64 66635, i64 66595, i64 66636, i64 66596, i64 66637, i64 66597, i64 66638, i64 66598, i64 66639, i64 66599, i64 66776, i64 66736, i64 66777, i64 66737, i64 66778, i64 66738, i64 66779, i64 66739, i64 66780, i64 66740, i64 66781, i64 66741, i64 66782, i64 66742, i64 66783, i64 66743, i64 66784, i64 66744, i64 66785, i64 66745, i64 66786, i64 66746, i64 66787, i64 66747, i64 66788, i64 66748, i64 66789, i64 66749, i64 66790, i64 66750, i64 66791, i64 66751, i64 66792, i64 66752, i64 66793, i64 66753, i64 66794, i64 66754, i64 66795, i64 66755, i64 66796, i64 66756, i64 66797, i64 66757, i64 66798, i64 66758, i64 66799, i64 66759, i64 66800, i64 66760, i64 66801, i64 66761, i64 66802, i64 66762, i64 66803, i64 66763, i64 66804, i64 66764, i64 66805, i64 66765, i64 66806, i64 66766, i64 66807, i64 66767, i64 66808, i64 66768, i64 66809, i64 66769, i64 66810, i64 66770, i64 66811, i64 66771, i64 66967, i64 66928, i64 66968, i64 66929, i64 66969, i64 66930, i64 66970, i64 66931, i64 66971, i64 66932, i64 66972, i64 66933, i64 66973, i64 66934, i64 66974, i64 66935, i64 66975, i64 66936, i64 66976, i64 66937, i64 66977, i64 66938, i64 66979, i64 66940, i64 66980, i64 66941, i64 66981, i64 66942, i64 66982, i64 66943, i64 66983, i64 66944, i64 66984, i64 66945, i64 66985, i64 66946, i64 66986, i64 66947, i64 66987, i64 66948, i64 66988, i64 66949, i64 66989, i64 66950, i64 66990, i64 66951, i64 66991, i64 66952, i64 66992, i64 66953, i64 66993, i64 66954, i64 66995, i64 66956, i64 66996, i64 66957, i64 66997, i64 66958, i64 66998, i64 66959, i64 66999, i64 66960, i64 67000, i64 66961, i64 67001, i64 66962, i64 67003, i64 66964, i64 67004, i64 66965, i64 68800, i64 68736, i64 68801, i64 68737, i64 68802, i64 68738, i64 68803, i64 68739, i64 68804, i64 68740, i64 68805, i64 68741, i64 68806, i64 68742, i64 68807, i64 68743, i64 68808, i64 68744, i64 68809, i64 68745, i64 68810, i64 68746, i64 68811, i64 68747, i64 68812, i64 68748, i64 68813, i64 68749, i64 68814, i64 68750, i64 68815, i64 68751, i64 68816, i64 68752, i64 68817, i64 68753, i64 68818, i64 68754, i64 68819, i64 68755, i64 68820, i64 68756, i64 68821, i64 68757, i64 68822, i64 68758, i64 68823, i64 68759, i64 68824, i64 68760, i64 68825, i64 68761, i64 68826, i64 68762, i64 68827, i64 68763, i64 68828, i64 68764, i64 68829, i64 68765, i64 68830, i64 68766, i64 68831, i64 68767, i64 68832, i64 68768, i64 68833, i64 68769, i64 68834, i64 68770, i64 68835, i64 68771, i64 68836, i64 68772, i64 68837, i64 68773, i64 68838, i64 68774, i64 68839, i64 68775, i64 68840, i64 68776, i64 68841, i64 68777, i64 68842, i64 68778, i64 68843, i64 68779, i64 68844, i64 68780, i64 68845, i64 68781, i64 68846, i64 68782, i64 68847, i64 68783, i64 68848, i64 68784, i64 68849, i64 68785, i64 68850, i64 68786, i64 68976, i64 68944, i64 68977, i64 68945, i64 68978, i64 68946, i64 68979, i64 68947, i64 68980, i64 68948, i64 68981, i64 68949, i64 68982, i64 68950, i64 68983, i64 68951, i64 68984, i64 68952, i64 68985, i64 68953, i64 68986, i64 68954, i64 68987, i64 68955, i64 68988, i64 68956, i64 68989, i64 68957, i64 68990, i64 68958, i64 68991, i64 68959, i64 68992, i64 68960, i64 68993, i64 68961, i64 68994, i64 68962, i64 68995, i64 68963, i64 68996, i64 68964, i64 68997, i64 68965, i64 71872, i64 71840, i64 71873, i64 71841, i64 71874, i64 71842, i64 71875, i64 71843, i64 71876, i64 71844, i64 71877, i64 71845, i64 71878, i64 71846, i64 71879, i64 71847, i64 71880, i64 71848, i64 71881, i64 71849, i64 71882, i64 71850, i64 71883, i64 71851, i64 71884, i64 71852, i64 71885, i64 71853, i64 71886, i64 71854, i64 71887, i64 71855, i64 71888, i64 71856, i64 71889, i64 71857, i64 71890, i64 71858, i64 71891, i64 71859, i64 71892, i64 71860, i64 71893, i64 71861, i64 71894, i64 71862, i64 71895, i64 71863, i64 71896, i64 71864, i64 71897, i64 71865, i64 71898, i64 71866, i64 71899, i64 71867, i64 71900, i64 71868, i64 71901, i64 71869, i64 71902, i64 71870, i64 71903, i64 71871, i64 93792, i64 93760, i64 93793, i64 93761, i64 93794, i64 93762, i64 93795, i64 93763, i64 93796, i64 93764, i64 93797, i64 93765, i64 93798, i64 93766, i64 93799, i64 93767, i64 93800, i64 93768, i64 93801, i64 93769, i64 93802, i64 93770, i64 93803, i64 93771, i64 93804, i64 93772, i64 93805, i64 93773, i64 93806, i64 93774, i64 93807, i64 93775, i64 93808, i64 93776, i64 93809, i64 93777, i64 93810, i64 93778, i64 93811, i64 93779, i64 93812, i64 93780, i64 93813, i64 93781, i64 93814, i64 93782, i64 93815, i64 93783, i64 93816, i64 93784, i64 93817, i64 93785, i64 93818, i64 93786, i64 93819, i64 93787, i64 93820, i64 93788, i64 93821, i64 93789, i64 93822, i64 93790, i64 93823, i64 93791, i64 125218, i64 125184, i64 125219, i64 125185, i64 125220, i64 125186, i64 125221, i64 125187, i64 125222, i64 125188, i64 125223, i64 125189, i64 125224, i64 125190, i64 125225, i64 125191, i64 125226, i64 125192, i64 125227, i64 125193, i64 125228, i64 125194, i64 125229, i64 125195, i64 125230, i64 125196, i64 125231, i64 125197, i64 125232, i64 125198, i64 125233, i64 125199, i64 125234, i64 125200, i64 125235, i64 125201, i64 125236, i64 125202, i64 125237, i64 125203, i64 125238, i64 125204, i64 125239, i64 125205, i64 125240, i64 125206, i64 125241, i64 125207, i64 125242, i64 125208, i64 125243, i64 125209, i64 125244, i64 125210, i64 125245, i64 125211, i64 125246, i64 125212, i64 125247, i64 125213, i64 125248, i64 125214, i64 125249, i64 125215, i64 125250, i64 125216, i64 125251, i64 125217], align 16
@rtt.12051 = private unnamed_addr constant [913 x i64] [i64 223, i64 2, i64 83, i64 83, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 329, i64 3, i64 202, i64 188, i64 78, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 496, i64 3, i64 74, i64 204, i64 140, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 912, i64 6, i64 206, i64 153, i64 204, i64 136, i64 204, i64 129, i64 0, i64 0, i64 0, i64 944, i64 6, i64 206, i64 165, i64 204, i64 136, i64 204, i64 129, i64 0, i64 0, i64 0, i64 7830, i64 3, i64 72, i64 204, i64 177, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7831, i64 3, i64 84, i64 204, i64 136, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7832, i64 3, i64 87, i64 204, i64 138, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7833, i64 3, i64 89, i64 204, i64 138, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 7834, i64 3, i64 65, i64 202, i64 190, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8064, i64 5, i64 225, i64 188, i64 136, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8065, i64 5, i64 225, i64 188, i64 137, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8066, i64 5, i64 225, i64 188, i64 138, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8067, i64 5, i64 225, i64 188, i64 139, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8068, i64 5, i64 225, i64 188, i64 140, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8069, i64 5, i64 225, i64 188, i64 141, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8070, i64 5, i64 225, i64 188, i64 142, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8071, i64 5, i64 225, i64 188, i64 143, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8072, i64 5, i64 225, i64 188, i64 136, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8073, i64 5, i64 225, i64 188, i64 137, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8074, i64 5, i64 225, i64 188, i64 138, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8075, i64 5, i64 225, i64 188, i64 139, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8076, i64 5, i64 225, i64 188, i64 140, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8077, i64 5, i64 225, i64 188, i64 141, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8078, i64 5, i64 225, i64 188, i64 142, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8079, i64 5, i64 225, i64 188, i64 143, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8080, i64 5, i64 225, i64 190, i64 152, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8081, i64 5, i64 225, i64 190, i64 153, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8082, i64 5, i64 225, i64 190, i64 154, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8083, i64 5, i64 225, i64 190, i64 155, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8084, i64 5, i64 225, i64 190, i64 156, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8085, i64 5, i64 225, i64 190, i64 157, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8086, i64 5, i64 225, i64 190, i64 158, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8087, i64 5, i64 225, i64 190, i64 159, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8088, i64 5, i64 225, i64 190, i64 152, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8089, i64 5, i64 225, i64 190, i64 153, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8090, i64 5, i64 225, i64 190, i64 154, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8091, i64 5, i64 225, i64 190, i64 155, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8092, i64 5, i64 225, i64 190, i64 156, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8093, i64 5, i64 225, i64 190, i64 157, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8094, i64 5, i64 225, i64 190, i64 158, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8095, i64 5, i64 225, i64 190, i64 159, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8096, i64 5, i64 225, i64 190, i64 168, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8097, i64 5, i64 225, i64 190, i64 169, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8098, i64 5, i64 225, i64 190, i64 170, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8099, i64 5, i64 225, i64 190, i64 171, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8100, i64 5, i64 225, i64 190, i64 172, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8101, i64 5, i64 225, i64 190, i64 173, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8102, i64 5, i64 225, i64 190, i64 174, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8103, i64 5, i64 225, i64 190, i64 175, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8104, i64 5, i64 225, i64 190, i64 168, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8105, i64 5, i64 225, i64 190, i64 169, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8106, i64 5, i64 225, i64 190, i64 170, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8107, i64 5, i64 225, i64 190, i64 171, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8108, i64 5, i64 225, i64 190, i64 172, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8109, i64 5, i64 225, i64 190, i64 173, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8110, i64 5, i64 225, i64 190, i64 174, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8111, i64 5, i64 225, i64 190, i64 175, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 8114, i64 5, i64 225, i64 190, i64 186, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 8115, i64 4, i64 206, i64 145, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8116, i64 4, i64 206, i64 134, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8118, i64 4, i64 206, i64 145, i64 205, i64 130, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8119, i64 6, i64 206, i64 145, i64 205, i64 130, i64 205, i64 133, i64 0, i64 0, i64 0, i64 8124, i64 4, i64 206, i64 145, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8130, i64 5, i64 225, i64 191, i64 138, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 8131, i64 4, i64 206, i64 151, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8132, i64 4, i64 206, i64 137, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8134, i64 4, i64 206, i64 151, i64 205, i64 130, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8135, i64 6, i64 206, i64 151, i64 205, i64 130, i64 205, i64 133, i64 0, i64 0, i64 0, i64 8140, i64 4, i64 206, i64 151, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8178, i64 5, i64 225, i64 191, i64 186, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 8179, i64 4, i64 206, i64 169, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8180, i64 4, i64 206, i64 143, i64 205, i64 133, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8182, i64 4, i64 206, i64 169, i64 205, i64 130, i64 0, i64 0, i64 0, i64 0, i64 0, i64 8183, i64 6, i64 206, i64 169, i64 205, i64 130, i64 205, i64 133, i64 0, i64 0, i64 0, i64 8188, i64 4, i64 206, i64 169, i64 206, i64 153, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64256, i64 2, i64 70, i64 70, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64257, i64 2, i64 70, i64 73, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64258, i64 2, i64 70, i64 76, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64259, i64 3, i64 70, i64 70, i64 73, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64260, i64 3, i64 70, i64 70, i64 76, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64261, i64 2, i64 83, i64 84, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 64262, i64 2, i64 83, i64 84, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0], align 16
@.s1794 = private unnamed_addr constant [10 x i8] c"List(Str)\00"
@rtg.split_one = internal thread_local global [8 x i8] zeroinitializer, align 16
@rtg.strtod_end = internal thread_local global [8 x i8] zeroinitializer, align 16
