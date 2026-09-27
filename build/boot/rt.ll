declare i1 @print(ptr)
declare i1 @println(ptr)
declare i1 @eprintln(ptr)
declare void @resid_cap_check(ptr)
declare void @resid_cap_enter(ptr, i64)
declare void @resid_cap_leave()
declare ptr @malloc(i64)
declare void @free(ptr)
declare ptr @resid_str_concat(ptr, ptr)
declare i8 @resid_str_eq(ptr, ptr)
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
declare i64 @str_char_at(ptr, i64)
declare ptr @str_from_code(i64)
declare i64 @str_len(ptr)
declare ptr @str_slice(ptr, i64, i64)
declare ptr @str_sb_new()
declare ptr @str_sb_append(ptr, ptr)
declare ptr @str_sb_append_cp(ptr, i64)
declare ptr @str_sb_finish(ptr)
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
declare i64 @resid_str_to_fixed(ptr, ptr, i64)
declare i64 @resid_bytes_to_fixed(ptr, ptr, i64)
declare void @resid_index_abort(i64, i64, ptr) noreturn
declare void @resid_abort(ptr) noreturn
declare void @resid_expect_fail(ptr, ptr, ptr) noreturn
declare i8 @resid_regex_match(ptr, ptr)
declare i8 @resid_quiet()
declare i8 @resid_quiet_set(i1)
declare i8 @resid_internals()
declare i8 @resid_internals_set(i1)
declare i8 @resid_rtmod()
declare i8 @resid_rtmod_set(i1)
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
declare ptr @resid_sacc_from(ptr)
declare ptr @resid_sacc_append(ptr, ptr)
declare ptr @resid_sacc_append_int(ptr, i64)
declare ptr @resid_gmalloc(i64)
declare void @resid_gfree(ptr)
declare i64 @resid_bulk_push()
declare i64 @resid_bulk_pop()
declare i64 @resid_mem_mark()
declare i64 @resid_mem_since_mark()
declare i64 @str_index_of(ptr, ptr, i64)
declare ptr @str_sha256(ptr)
declare i8 @resid_fs_write_hex(ptr, ptr)
declare i8 @resid_fs_append_hex(ptr, ptr)
declare ptr @resid_decp_persist(ptr)
declare i64 @resid_scope_push()
declare void @resid_scope_pop(i64)
declare i1 @resid_sb_print(ptr, i8)
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
define i64 @c_abort(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = inttoptr i64 %a0 to ptr
call void @resid_abort(ptr %x0)
unreachable
}
define i64 @rt_abort(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t1 = ptrtoint ptr %p0 to i64
%t2 = call i64 @c_abort(i64 %t1)
ret i64 %t2
}
define i64 @rt_overflow_check(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t3 = icmp ne i64 %p0, 0
br i1 %t3, label %L1, label %L3
L1:
%t5 = call i64 @rt_abort(ptr @.s4)
ret i64 %t5
L3:
ret i64 0
}
define void @resid_overflow_check(i8 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = zext i8 %a0 to i64
%r = call i64 @rt_overflow_check(i64 %x0)
ret void
}
define i64 @rt_div_check(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t6 = icmp ne i64 %p0, 0
br i1 %t6, label %L4, label %L6
L4:
%t8 = call i64 @rt_abort(ptr @.s7)
ret i64 %t8
L6:
ret i64 0
}
define void @resid_div_check(i8 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = zext i8 %a0 to i64
%r = call i64 @rt_div_check(i64 %x0)
ret void
}
define i64 @rt_conv_check(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t9 = icmp ne i64 %p0, 0
br i1 %t9, label %L7, label %L9
L7:
%t11 = call i64 @rt_abort(ptr @.s10)
ret i64 %t11
L9:
ret i64 0
}
define void @resid_conv_check(i8 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%x0 = zext i8 %a0 to i64
%r = call i64 @rt_conv_check(i64 %x0)
ret void
}
define i64 @__mruntime_rt_arith_resid__imax() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t12 = trunc i128 9223372036854775807 to i64
ret i64 %t12
}
define i64 @__mruntime_rt_arith_resid__imin() "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t13 = sub i128 -9223372036854775807, 1
%t14 = add i128 %t13, 0
%t15 = trunc i128 %t14 to i64
%t16 = sext i64 %t15 to i128
%t17 = icmp ne i128 %t16, %t14
%t18 = icmp eq i8 0, 1
%t19 = or i1 %t17, %t18
%t20 = zext i1 %t19 to i8
call void @resid_conv_check(i8 %t20)
%t21 = sext i64 %t15 to i128
%t22 = trunc i128 %t21 to i64
ret i64 %t22
}
define i64 @rt_wrapping_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t23 = add i64 %p0, %p1
ret i64 %t23
}
define i64 @wrapping_add(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_add(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_wrapping_sub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t24 = sub i64 %p0, %p1
ret i64 %t24
}
define i64 @wrapping_sub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_sub(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_wrapping_mul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t25 = mul i64 %p0, %p1
ret i64 %t25
}
define i64 @wrapping_mul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_mul(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_wrapping_div(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t26 = icmp eq i64 %p1, 0
br i1 %t26, label %L10, label %L12
L10:
%t28 = call i64 @rt_abort(ptr @.s27)
ret i64 %t28
L12:
%t29 = icmp eq i64 %p1, -1
br i1 %t29, label %L13, label %L15
L13:
%t30 = sub i64 0, %p0
ret i64 %t30
L15:
%t31 = icmp eq i64 %p1, 0
%t32 = zext i1 %t31 to i8
call void @resid_div_check(i8 %t32)
%t33 = icmp eq i64 %p1, -1
%t34 = icmp eq i64 %p0, -9223372036854775808
%t35 = and i1 %t33, %t34
%t38 = zext i1 %t35 to i8
call void @resid_overflow_check(i8 %t38)
%t36 = add i64 %p1, 0
%t37 = sdiv i64 %p0, %t36
ret i64 %t37
}
define i64 @wrapping_div(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_div(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_wrapping_uadd(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t39 = add i64 %p0, %p1
ret i64 %t39
}
define i64 @wrapping_uadd(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_uadd(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_wrapping_usub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t40 = sub i64 %p0, %p1
ret i64 %t40
}
define i64 @wrapping_usub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_usub(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_wrapping_umul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t41 = mul i64 %p0, %p1
ret i64 %t41
}
define i64 @wrapping_umul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_umul(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_wrapping_udiv(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t42 = icmp eq i64 %p1, 0
br i1 %t42, label %L16, label %L18
L16:
%t44 = call i64 @rt_abort(ptr @.s43)
ret i64 %t44
L18:
%t45 = musttail call i64 @__mruntime_rt_arith_resid__rt_udiv(i64 %p0, i64 %p1)
ret i64 %t45
}
define i64 @wrapping_udiv(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_wrapping_udiv(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @__mruntime_rt_arith_resid__rt_udiv(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t46 = add i64 %p0, 0
%t47 = add i64 %t46, 0
%t48 = add i64 %t47, 0
%t49 = icmp ne i64 %t48, %t46
%t50 = icmp slt i64 %p0, 0
%t51 = or i1 %t49, %t50
%t52 = zext i1 %t51 to i8
call void @resid_conv_check(i8 %t52)
%t53 = add i64 %p1, 0
%t54 = add i64 %t53, 0
%t55 = add i64 %t54, 0
%t56 = icmp ne i64 %t55, %t53
%t57 = icmp slt i64 %p1, 0
%t58 = or i1 %t56, %t57
%t59 = zext i1 %t58 to i8
call void @resid_conv_check(i8 %t59)
%t60 = icmp eq i64 %t54, 0
%t61 = zext i1 %t60 to i8
call void @resid_div_check(i8 %t61)
%t66 = udiv i64 %t47, %t54
%t67 = add i64 %t66, 0
%t68 = add i64 %t67, 0
%t69 = add i64 %t68, 0
%t70 = icmp ne i64 %t69, %t67
%t71 = icmp slt i64 %t68, 0
%t72 = or i1 %t70, %t71
%t73 = zext i1 %t72 to i8
call void @resid_conv_check(i8 %t73)
ret i64 %t68
}
define i1 @__mruntime_rt_arith_resid__rt_ult(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t74 = sub i128 -9223372036854775807, 1
%t75 = add i128 %t74, 0
%t76 = trunc i128 %t75 to i64
%t77 = sext i64 %t76 to i128
%t78 = icmp ne i128 %t77, %t75
%t79 = icmp eq i8 0, 1
%t80 = or i1 %t78, %t79
%t81 = zext i1 %t80 to i8
call void @resid_conv_check(i8 %t81)
%t82 = xor i64 %p0, %t76
%t83 = sub i128 -9223372036854775807, 1
%t84 = add i128 %t83, 0
%t85 = trunc i128 %t84 to i64
%t86 = sext i64 %t85 to i128
%t87 = icmp ne i128 %t86, %t84
%t88 = icmp eq i8 0, 1
%t89 = or i1 %t87, %t88
%t90 = zext i1 %t89 to i8
call void @resid_conv_check(i8 %t90)
%t91 = xor i64 %p1, %t85
%t92 = icmp slt i64 %t82, %t91
ret i1 %t92
}
define i64 @rt_saturating_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t93 = icmp sgt i64 %p1, 0
br label %LSL94
LSL94:
br i1 %t93, label %LSR94, label %LSJ94
LSR94:
%t95 = add i128 9223372036854775807, 0
%t96 = trunc i128 %t95 to i64
%t97 = sext i64 %t96 to i128
%t98 = icmp ne i128 %t97, %t95
%t99 = icmp eq i8 0, 1
%t100 = or i1 %t98, %t99
%t101 = zext i1 %t100 to i8
call void @resid_conv_check(i8 %t101)
%t102 = sub i64 %t96, %p1
%t103 = icmp sgt i64 %p0, %t102
br label %LSJ94
LSJ94:
%t104 = phi i1 [ false, %LSL94 ], [ %t103, %LSR94 ]
br i1 %t104, label %L19, label %L21
L19:
%t105 = add i128 9223372036854775807, 0
%t106 = trunc i128 %t105 to i64
%t107 = sext i64 %t106 to i128
%t108 = icmp ne i128 %t107, %t105
%t109 = icmp eq i8 0, 1
%t110 = or i1 %t108, %t109
%t111 = zext i1 %t110 to i8
call void @resid_conv_check(i8 %t111)
ret i64 %t106
L21:
%t112 = icmp slt i64 %p1, 0
br label %LSL113
LSL113:
br i1 %t112, label %LSR113, label %LSJ113
LSR113:
%t114 = sub i128 -9223372036854775807, 1
%t115 = add i128 %t114, 0
%t116 = trunc i128 %t115 to i64
%t117 = sext i64 %t116 to i128
%t118 = icmp ne i128 %t117, %t115
%t119 = icmp eq i8 0, 1
%t120 = or i1 %t118, %t119
%t121 = zext i1 %t120 to i8
call void @resid_conv_check(i8 %t121)
%t122 = sub i64 %t116, %p1
%t123 = icmp slt i64 %p0, %t122
br label %LSJ113
LSJ113:
%t124 = phi i1 [ false, %LSL113 ], [ %t123, %LSR113 ]
br i1 %t124, label %L22, label %L24
L22:
%t125 = sub i128 -9223372036854775807, 1
%t126 = add i128 %t125, 0
%t127 = trunc i128 %t126 to i64
%t128 = sext i64 %t127 to i128
%t129 = icmp ne i128 %t128, %t126
%t130 = icmp eq i8 0, 1
%t131 = or i1 %t129, %t130
%t132 = zext i1 %t131 to i8
call void @resid_conv_check(i8 %t132)
ret i64 %t127
L24:
%t133 = add i64 %p0, %p1
ret i64 %t133
}
define i64 @saturating_add(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_add(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_saturating_sub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t134 = icmp slt i64 %p1, 0
br label %LSL135
LSL135:
br i1 %t134, label %LSR135, label %LSJ135
LSR135:
%t136 = add i128 9223372036854775807, 0
%t137 = trunc i128 %t136 to i64
%t138 = sext i64 %t137 to i128
%t139 = icmp ne i128 %t138, %t136
%t140 = icmp eq i8 0, 1
%t141 = or i1 %t139, %t140
%t142 = zext i1 %t141 to i8
call void @resid_conv_check(i8 %t142)
%t143 = add i64 %t137, %p1
%t144 = icmp sgt i64 %p0, %t143
br label %LSJ135
LSJ135:
%t145 = phi i1 [ false, %LSL135 ], [ %t144, %LSR135 ]
br i1 %t145, label %L25, label %L27
L25:
%t146 = add i128 9223372036854775807, 0
%t147 = trunc i128 %t146 to i64
%t148 = sext i64 %t147 to i128
%t149 = icmp ne i128 %t148, %t146
%t150 = icmp eq i8 0, 1
%t151 = or i1 %t149, %t150
%t152 = zext i1 %t151 to i8
call void @resid_conv_check(i8 %t152)
ret i64 %t147
L27:
%t153 = icmp sgt i64 %p1, 0
br label %LSL154
LSL154:
br i1 %t153, label %LSR154, label %LSJ154
LSR154:
%t155 = sub i128 -9223372036854775807, 1
%t156 = add i128 %t155, 0
%t157 = trunc i128 %t156 to i64
%t158 = sext i64 %t157 to i128
%t159 = icmp ne i128 %t158, %t156
%t160 = icmp eq i8 0, 1
%t161 = or i1 %t159, %t160
%t162 = zext i1 %t161 to i8
call void @resid_conv_check(i8 %t162)
%t163 = add i64 %t157, %p1
%t164 = icmp slt i64 %p0, %t163
br label %LSJ154
LSJ154:
%t165 = phi i1 [ false, %LSL154 ], [ %t164, %LSR154 ]
br i1 %t165, label %L28, label %L30
L28:
%t166 = sub i128 -9223372036854775807, 1
%t167 = add i128 %t166, 0
%t168 = trunc i128 %t167 to i64
%t169 = sext i64 %t168 to i128
%t170 = icmp ne i128 %t169, %t167
%t171 = icmp eq i8 0, 1
%t172 = or i1 %t170, %t171
%t173 = zext i1 %t172 to i8
call void @resid_conv_check(i8 %t173)
ret i64 %t168
L30:
%t174 = sub i64 %p0, %p1
ret i64 %t174
}
define i64 @saturating_sub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_sub(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_saturating_mul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t175 = mul i64 %p0, %p1
%t176 = icmp ne i64 %p0, 0
br label %LSL177
LSL177:
br i1 %t176, label %LSR177, label %LSJ177
LSR177:
%t178 = icmp eq i64 %p0, 0
%t179 = zext i1 %t178 to i8
call void @resid_div_check(i8 %t179)
%t180 = icmp eq i64 %p0, -1
%t181 = icmp eq i64 %t175, -9223372036854775808
%t182 = and i1 %t180, %t181
%t185 = zext i1 %t182 to i8
call void @resid_overflow_check(i8 %t185)
%t183 = add i64 %p0, 0
%t184 = sdiv i64 %t175, %t183
%t186 = icmp ne i64 %t184, %p1
br label %LSL187
LSL187:
br i1 %t186, label %LSJ187, label %LSR187
LSR187:
%t188 = icmp eq i64 %p0, -1
br label %LSL189
LSL189:
br i1 %t188, label %LSR189, label %LSJ189
LSR189:
%t190 = sub i128 -9223372036854775807, 1
%t191 = add i128 %t190, 0
%t192 = trunc i128 %t191 to i64
%t193 = sext i64 %t192 to i128
%t194 = icmp ne i128 %t193, %t191
%t195 = icmp eq i8 0, 1
%t196 = or i1 %t194, %t195
%t197 = zext i1 %t196 to i8
call void @resid_conv_check(i8 %t197)
%t198 = icmp eq i64 %p1, %t192
br label %LSJ189
LSJ189:
%t199 = phi i1 [ false, %LSL189 ], [ %t198, %LSR189 ]
br label %LSJ187
LSJ187:
%t200 = phi i1 [ true, %LSL187 ], [ %t199, %LSJ189 ]
br label %LSJ177
LSJ177:
%t201 = phi i1 [ false, %LSL177 ], [ %t200, %LSJ187 ]
br label %LSL202
LSL202:
br i1 %t201, label %LSJ202, label %LSR202
LSR202:
%t203 = icmp eq i64 %p1, -1
br label %LSL204
LSL204:
br i1 %t203, label %LSR204, label %LSJ204
LSR204:
%t205 = sub i128 -9223372036854775807, 1
%t206 = add i128 %t205, 0
%t207 = trunc i128 %t206 to i64
%t208 = sext i64 %t207 to i128
%t209 = icmp ne i128 %t208, %t206
%t210 = icmp eq i8 0, 1
%t211 = or i1 %t209, %t210
%t212 = zext i1 %t211 to i8
call void @resid_conv_check(i8 %t212)
%t213 = icmp eq i64 %p0, %t207
br label %LSJ204
LSJ204:
%t214 = phi i1 [ false, %LSL204 ], [ %t213, %LSR204 ]
br label %LSJ202
LSJ202:
%t215 = phi i1 [ true, %LSL202 ], [ %t214, %LSJ204 ]
%t216 = xor i1 %t215, true
br i1 %t216, label %L31, label %L33
L31:
ret i64 %t175
L33:
%t217 = icmp sgt i64 %p0, 0
%t218 = icmp sgt i64 %p1, 0
%t219 = icmp eq i1 %t217, %t218
br i1 %t219, label %L34, label %L35
L34:
%t220 = add i128 9223372036854775807, 0
%t221 = trunc i128 %t220 to i64
%t222 = sext i64 %t221 to i128
%t223 = icmp ne i128 %t222, %t220
%t224 = icmp eq i8 0, 1
%t225 = or i1 %t223, %t224
%t226 = zext i1 %t225 to i8
call void @resid_conv_check(i8 %t226)
br label %L36
L35:
%t227 = sub i128 -9223372036854775807, 1
%t228 = add i128 %t227, 0
%t229 = trunc i128 %t228 to i64
%t230 = sext i64 %t229 to i128
%t231 = icmp ne i128 %t230, %t228
%t232 = icmp eq i8 0, 1
%t233 = or i1 %t231, %t232
%t234 = zext i1 %t233 to i8
call void @resid_conv_check(i8 %t234)
br label %L36
L36:
%t235 = phi i64 [ %t221, %L34 ], [ %t229, %L35 ]
ret i64 %t235
}
define i64 @saturating_mul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_mul(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_saturating_uadd(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t236 = add i64 %p0, %p1
%t237 = call i1 @__mruntime_rt_arith_resid__rt_ult(i64 %t236, i64 %p0)
br i1 %t237, label %L37, label %L38
L37:
br label %L39
L38:
br label %L39
L39:
%t238 = phi i64 [ -1, %L37 ], [ %t236, %L38 ]
ret i64 %t238
}
define i64 @saturating_uadd(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_uadd(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_saturating_usub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t239 = call i1 @__mruntime_rt_arith_resid__rt_ult(i64 %p0, i64 %p1)
br i1 %t239, label %L40, label %L41
L40:
br label %L42
L41:
%t240 = sub i64 %p0, %p1
br label %L42
L42:
%t241 = phi i64 [ 0, %L40 ], [ %t240, %L41 ]
ret i64 %t241
}
define i64 @saturating_usub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_usub(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_saturating_umul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t242 = icmp eq i64 %p0, 0
br label %LSL243
LSL243:
br i1 %t242, label %LSJ243, label %LSR243
LSR243:
%t244 = icmp eq i64 %p1, 0
br label %LSJ243
LSJ243:
%t245 = phi i1 [ true, %LSL243 ], [ %t244, %LSR243 ]
br i1 %t245, label %L43, label %L45
L43:
ret i64 0
L45:
%t246 = mul i64 %p0, %p1
%t247 = call i64 @__mruntime_rt_arith_resid__rt_udiv(i64 %t246, i64 %p0)
%t248 = icmp ne i64 %t247, %p1
br i1 %t248, label %L46, label %L47
L46:
br label %L48
L47:
br label %L48
L48:
%t249 = phi i64 [ -1, %L46 ], [ %t246, %L47 ]
ret i64 %t249
}
define i64 @saturating_umul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_saturating_umul(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_checked_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t250 = add i64 %p0, %p1
ret i64 %t250
}
define i64 @checked_add(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_add(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_checked_sub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t251 = sub i64 %p0, %p1
ret i64 %t251
}
define i64 @checked_sub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_sub(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_checked_mul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t252 = mul i64 %p0, %p1
ret i64 %t252
}
define i64 @checked_mul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_mul(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_checked_div(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t253 = icmp eq i64 %p1, 0
br i1 %t253, label %L49, label %L51
L49:
%t255 = call i64 @rt_abort(ptr @.s254)
ret i64 %t255
L51:
%t256 = icmp eq i64 %p1, 0
%t257 = zext i1 %t256 to i8
call void @resid_div_check(i8 %t257)
%t258 = icmp eq i64 %p1, -1
%t259 = icmp eq i64 %p0, -9223372036854775808
%t260 = and i1 %t258, %t259
%t263 = zext i1 %t260 to i8
call void @resid_overflow_check(i8 %t263)
%t261 = add i64 %p1, 0
%t262 = sdiv i64 %p0, %t261
ret i64 %t262
}
define i64 @checked_div(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_div(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_checked_uadd(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t264 = add i64 %p0, %p1
ret i64 %t264
}
define i64 @checked_uadd(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_uadd(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_checked_usub(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t265 = sub i64 %p0, %p1
ret i64 %t265
}
define i64 @checked_usub(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_usub(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_checked_umul(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t266 = mul i64 %p0, %p1
ret i64 %t266
}
define i64 @checked_umul(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_umul(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_checked_udiv(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t267 = icmp eq i64 %p1, 0
br i1 %t267, label %L52, label %L54
L52:
%t269 = call i64 @rt_abort(ptr @.s268)
ret i64 %t269
L54:
%t270 = musttail call i64 @__mruntime_rt_arith_resid__rt_udiv(i64 %p0, i64 %p1)
ret i64 %t270
}
define i64 @checked_udiv(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_checked_udiv(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_abs_i64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t271 = icmp slt i64 %p0, 0
br i1 %t271, label %L55, label %L56
L55:
%t272 = sub i64 0, %p0
br label %L57
L56:
br label %L57
L57:
%t273 = phi i64 [ %t272, %L55 ], [ %p0, %L56 ]
ret i64 %t273
}
define i64 @abs_i64(i64 %a0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_abs_i64(i64 %a0)
ret i64 %r
}
define i64 @rt_min_i64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t274 = icmp slt i64 %p0, %p1
br i1 %t274, label %L58, label %L59
L58:
br label %L60
L59:
br label %L60
L60:
%t275 = phi i64 [ %p0, %L58 ], [ %p1, %L59 ]
ret i64 %t275
}
define i64 @min_i64(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_min_i64(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_max_i64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t276 = icmp sgt i64 %p0, %p1
br i1 %t276, label %L61, label %L62
L61:
br label %L63
L62:
br label %L63
L63:
%t277 = phi i64 [ %p0, %L61 ], [ %p1, %L62 ]
ret i64 %t277
}
define i64 @max_i64(i64 %a0, i64 %a1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_max_i64(i64 %a0, i64 %a1)
ret i64 %r
}
define i64 @rt_clamp_i64(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%t278 = icmp slt i64 %p0, %p1
br i1 %t278, label %L64, label %L66
L64:
ret i64 %p1
L66:
%t279 = icmp sgt i64 %p0, %p2
br i1 %t279, label %L67, label %L69
L67:
ret i64 %p2
L69:
ret i64 %p0
}
define i64 @clamp_i64(i64 %a0, i64 %a1, i64 %a2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" {
entry:
%r = call i64 @rt_clamp_i64(i64 %a0, i64 %a1, i64 %a2)
ret i64 %r
}
@.s4 = private unnamed_addr constant [39 x i8] c"integer overflow in checked arithmetic\00"
@.s7 = private unnamed_addr constant [25 x i8] c"integer division by zero\00"
@.s10 = private unnamed_addr constant [32 x i8] c"numeric conversion out of range\00"
@.s27 = private unnamed_addr constant [31 x i8] c"wrapping_div: division by zero\00"
@.s43 = private unnamed_addr constant [32 x i8] c"wrapping_udiv: division by zero\00"
@.s254 = private unnamed_addr constant [30 x i8] c"checked_div: division by zero\00"
@.s268 = private unnamed_addr constant [31 x i8] c"checked_udiv: division by zero\00"
