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
declare ptr @str_trim(ptr)
declare ptr @str_to_lower(ptr)
declare ptr @str_to_upper(ptr)
declare ptr @str_reverse(ptr)
declare i8 @str_contains(ptr, ptr)
declare i8 @str_starts_with(ptr, ptr)
declare i8 @str_ends_with(ptr, ptr)
declare ptr @str_repeat(ptr, i64)
declare ptr @str_replace(ptr, ptr, ptr)
declare ptr @bl_str_split(ptr, ptr)
declare ptr @bl_str_join(ptr, ptr)
declare i8 @str_is_int(ptr)
declare i64 @str_parse_int(ptr)
declare i8 @str_is_float(ptr)
declare double @str_parse_float(ptr)
declare i64 @str_count(ptr, ptr)
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
define internal i64 @cstr_from__rs22(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1489 = add i64 %p1, 1
%t1490 = call i64 @xmalloc(i64 %t1489)
%t1491 = call i64 @mcopy(i64 %t1490, i64 %p0, i64 %p1)
%t1492 = add i64 %t1490, %p1
%t1493 = call i64 @st8(i64 %t1492, i64 0)
ret i64 %t1490
}
define internal i64 @__mruntime_rt_text_resid__idx_find__rs30(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1494 = call i64 @__mruntime_rt_text_resid__idx_slots()
%t1495 = add nsw i64 %t1494, 0
%t1496 = call i64 @__mruntime_rt_text_resid__sl_s(i64 %t1495)
%t1497 = icmp eq i64 %t1496, %p0
br i1 %t1497, label %L532, label %L534
L532:
ret i64 %t1495
L534:
%t1498 = call i64 @__mruntime_rt_text_resid__idx_find(i64 %p0, i64 1)
ret i64 %t1498
}
define internal i64 @cstr_from__rs33(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1499 = add i64 %p1, 1
%t1500 = call i64 @ralloc(i64 %t1499)
%t1501 = call i64 @mcopy(i64 %t1500, i64 %p0, i64 %p1)
%t1502 = add i64 %t1500, %p1
%t1503 = call i64 @st8(i64 %t1502, i64 0)
ret i64 %t1500
}
define internal i64 @__mruntime_rt_text_resid__find_from__rs36(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1504 = sub i64 %p3, 1
%t1505 = sub i64 %t1504, %p4
%t1506 = sub i64 %p1, %t1505
%t1507 = icmp sge i64 %p5, %t1506
br i1 %t1507, label %L535, label %L537
L535:
ret i64 0
L537:
%t1508 = add i64 %p2, %p4
%t1509 = call i64 @ld8(i64 %t1508)
%t1510 = sub i64 %t1506, %p5
%t1511 = call i64 @c_memchr(i64 %p5, i64 %t1509, i64 %t1510)
%t1512 = icmp eq i64 %t1511, 0
br i1 %t1512, label %L538, label %L540
L538:
ret i64 0
L540:
%t1513 = sub i64 %t1511, %p4
%t1514 = call i64 @c_memcmp(i64 %t1513, i64 %p2, i64 %p3)
%t1515 = icmp eq i64 %t1514, 0
br i1 %t1515, label %L541, label %L543
L541:
ret i64 %t1513
L543:
%t1516 = add i64 %t1511, 1
%t1517 = call i64 @__mruntime_rt_text_resid__find_from(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %t1516, i64 1)
ret i64 %t1517
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
