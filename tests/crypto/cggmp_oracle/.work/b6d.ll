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
declare ptr @str_sb_append_slice(ptr, ptr, i64, i64)
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
declare i64 @resid_read_byte()
declare i8 @resid_term_is_tty(i64)
declare i64 @resid_term_cols()
declare i64 @resid_term_rows()
declare i8 @resid_term_raw()
declare i8 @resid_term_restore()
declare i64 @resid_clock_now_ns()
declare i64 @resid_clock_now_sec()
declare i64 @resid_clock_monotonic_ns()
declare i64 @resid_clock_sleep_ns(i64)
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
declare i8 @resid_cpu_has_clmul()
declare i8 @resid_cpu_has_sha256()
declare i8 @resid_cpu_has_sha512()
declare <2 x i64> @llvm.x86.aesni.aesenc(<2 x i64>, <2 x i64>)
declare <2 x i64> @llvm.x86.aesni.aesenclast(<2 x i64>, <2 x i64>)
declare i64 @resid_tcp_connect(ptr, i64)
declare i8 @resid_tcp_send(i64, ptr)
declare ptr @resid_tcp_recv_all(i64)
declare i8 @resid_tcp_close(i64)
declare i8 @resid_tcp_send_bin(i64, ptr)
declare ptr @resid_tcp_recv_bin(i64, i64)
declare i64 @resid_tcp_listen(i64)
declare i64 @resid_tcp_bound_port(i64)
declare i64 @resid_tcp_accept(i64)
declare i64 @resid_tcp_listen_at(ptr, i64)
declare ptr @resid_tcp_recv_some(i64, i64)
declare i8 @resid_tcp_shutdown(i64)
declare i8 @resid_tcp_deadline(i64, i64)
declare ptr @resid_tcp_poll(ptr, ptr, i64)
declare ptr @resid_device_call(ptr)
declare ptr @resid_device_call_w(ptr)
declare ptr @resid_device_secret(i64)
declare ptr @resid_random_os(i64)
declare ptr @resid_random_cpu(i64)
declare i64 @resid_chal_new(ptr, i64, i64)
declare i64 @resid_chal_mark(i64, i64)
declare i64 @resid_chal_spend(i64)
declare i64 @resid_chal_left(i64)
declare i64 @resid_chal_bind(i64, ptr, ptr)
declare ptr @resid_chal_bound(i64)
declare i64 @resid_tr_note(ptr)
declare ptr @resid_tr_read()
declare i64 @resid_tcp_send_some(i64, ptr)
declare i64 @resid_tcp_accept_now(i64)
declare ptr @str_trim(ptr)
declare ptr @str_to_lower(ptr)
declare ptr @str_to_upper(ptr)
declare ptr @str_reverse(ptr)
declare i8 @str_contains(ptr, ptr)
declare i8 @str_starts_with(ptr, ptr)
declare i8 @str_ends_with(ptr, ptr)
declare ptr @str_repeat(ptr, i64)
declare ptr @str_replace(ptr, ptr, ptr)
declare ptr @str_split(ptr, ptr)
declare ptr @str_join(ptr, ptr)
declare i8 @str_is_int(ptr)
declare i64 @str_parse_int(ptr)
declare i8 @str_is_float(ptr)
declare double @str_parse_float(ptr)
declare i64 @str_count(ptr, ptr)
declare i64 @abs_i64(i64)
declare i64 @min_i64(i64, i64)
declare i64 @max_i64(i64, i64)
declare i64 @clamp_i64(i64, i64, i64)
declare ptr @resid_list_new(i64, ptr, ptr)
declare i64 @resid_list_len(ptr)
declare ptr @resid_list_get(ptr, i64)
declare ptr @resid_list_get_nc(ptr, i64)
declare ptr @resid_list_get_sh(ptr, i64)
declare ptr @resid_list_get_own(ptr, i64)
declare ptr @resid_list_share_f(ptr)
declare ptr @resid_list_vdata(ptr)
declare i64 @resid_list_vlen(ptr)
declare ptr @resid_list_get_v(ptr, i64, ptr, i64)
declare ptr @resid_list_with(ptr, i8, i64, ptr)
declare ptr @resid_list_with_f(ptr, i8, i64, ptr, ptr)
declare ptr @resid_list_with_fb(ptr, i8, i64, ptr, ptr)
declare ptr @resid_list_with_fh(ptr, i8, i64, ptr, ptr)
declare ptr @resid_list_concat_own_fh(ptr, i8, ptr, ptr)
declare ptr @resid_rec_reuse_sc(ptr, i64)
declare ptr @resid_list_with_i64(ptr, i8, i64, i64)
declare ptr @resid_list_with_bool(ptr, i8, i64, i8)
declare ptr @resid_list_with_f64(ptr, i8, i64, double)
declare ptr @resid_list_concat_own(ptr, i8, ptr)
declare ptr @resid_list_concat_own_f(ptr, i8, ptr, ptr)
declare ptr @resid_list_freeze(ptr)
declare ptr @resid_rec_evac(ptr, i64, i8)
declare ptr @resid_list_evac_f(ptr, ptr)
declare ptr @resid_fx_move(ptr, ptr, i64, i8)
declare ptr @resid_fx_stage(ptr, ptr, ptr, i64, i8)
declare void @resid_str_index_drop(ptr, i64)
declare ptr @resid_fixed_text(ptr, i64)
declare ptr @resid_list_concat(ptr, ptr)
declare ptr @resid_list_push(ptr, ptr)
declare ptr @resid_listbuf_new()
declare ptr @resid_listbuf_push(ptr, ptr)
declare ptr @resid_listbuf_finish(ptr, ptr)
declare ptr @resid_list_slice(ptr, i64, i64)
declare ptr @resid_range_list(i64, i64)
declare ptr @resid_range_list_incl(i64, i64)
declare ptr @list_sort_ints(ptr)
declare ptr @list_sort_wide(ptr, i64)
declare ptr @list_sort_floats(ptr)
declare ptr @list_sort_strs(ptr)
declare ptr @list_reverse_ints(ptr)
declare i8 @list_contains_int(ptr, i64)
declare i8 @list_contains_str(ptr, ptr)
declare i8 @list_contains_float(ptr, double)
declare i64 @list_sum(ptr)
declare double @list_sumf(ptr)
declare ptr @list_sort_by(ptr, ptr)
declare i64 @checked_add(i64, i64)
declare i64 @checked_sub(i64, i64)
declare i64 @checked_mul(i64, i64)
declare i64 @checked_div(i64, i64)
declare i64 @checked_uadd(i64, i64)
declare i64 @checked_usub(i64, i64)
declare i64 @checked_umul(i64, i64)
declare i64 @checked_udiv(i64, i64)
declare i64 @wrapping_add(i64, i64)
declare i64 @wrapping_sub(i64, i64)
declare i64 @wrapping_mul(i64, i64)
declare i64 @wrapping_div(i64, i64)
declare i64 @wrapping_uadd(i64, i64)
declare i64 @wrapping_usub(i64, i64)
declare i64 @wrapping_umul(i64, i64)
declare i64 @wrapping_udiv(i64, i64)
declare i64 @saturating_add(i64, i64)
declare i64 @saturating_sub(i64, i64)
declare i64 @saturating_mul(i64, i64)
declare i64 @saturating_uadd(i64, i64)
declare i64 @saturating_usub(i64, i64)
declare i64 @saturating_umul(i64, i64)
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
declare ptr @resid_list_show(ptr, i64)
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
declare ptr @resid_box_i256(i256)
declare i256 @resid_unbox_i256(ptr)
declare ptr @resid_box_u256(i256)
declare i256 @resid_unbox_u256(ptr)
declare ptr @resid_box_i512(i512)
declare i512 @resid_unbox_i512(ptr)
declare ptr @resid_box_u512(i512)
declare i512 @resid_unbox_u512(ptr)
declare ptr @Int128ToString(i128)
declare ptr @UIntToString(i64)
declare ptr @Int256ToString(i64, i64, i64, i64)
declare ptr @UInt256ToString(i64, i64, i64, i64)
declare ptr @Int512ToString(i64, i64, i64, i64, i64, i64, i64, i64)
declare ptr @UInt512ToString(i64, i64, i64, i64, i64, i64, i64, i64)
declare ptr @WideToString(ptr, i64, i8)
declare ptr @FloatToString(double)
declare ptr @Float128ToString(fp128)
declare ptr @BoolToString(i8)
declare void @resid_overflow_check(i8)
declare void @resid_div_check(i8)
declare void @resid_conv_check(i8)
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
declare i64 @resid_mem_limit_set(i64)
declare i64 @resid_bytes_len(ptr)
declare ptr @Float32ToString(double)
declare double @resid_close_tol(i64)
declare ptr @resid_str_quote(ptr)
declare ptr @resid_list_show_clo(ptr, ptr)
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
declare ptr @resid_fixed_bytes(ptr, i64)
declare ptr @UInt128ToString(i128)
define linkonce_odr ptr @e.itoa(ptr %buf, i64 %v) "probe-stack"="inline-asm" {
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
declare i32 @resid_setjmp(ptr) returns_twice
declare i64 @llvm.ctpop.i64(i64)
define linkonce_odr i64 @e.catch(i64 %slot, i64 %fn, i64 %arg) noinline "probe-stack"="inline-asm" {
entry:
  %jb = alloca [256 x i8], align 16
  %sp = inttoptr i64 %slot to ptr
  %prev = load volatile i64, ptr %sp
  %jbi = ptrtoint ptr %jb to i64
  store volatile i64 %jbi, ptr %sp
  %r = call i32 @resid_setjmp(ptr %jb) returns_twice
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
declare ptr @resid_spawn_start(ptr, ptr)
declare ptr @resid_spawn_wait(ptr)
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
declare i64 @resid_stack_left()
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
declare ptr @resid_sb2_push(ptr, ptr, ptr)
declare ptr @resid_sb2_push_cp(ptr, ptr, i64)
declare ptr @resid_sb2_finish(ptr, ptr)
declare ptr @resid_sb2_lim()
declare i1 @resid_sb2_print(ptr, ptr, i8)
declare void @resid_sb2_discard(ptr, ptr)
declare ptr @resid_fsb_push(ptr, i64, ptr)
declare ptr @resid_fsb_push_cp(ptr, i64, i64)
declare ptr @resid_fbb_push(ptr, i64, i64)
declare void @resid_fb_overflow(i64, i64)
declare ptr @resid_bytes_show(ptr, i64)
declare ptr @resid_map_format_t(ptr, i8, i8, ptr, ptr)
declare ptr @resid_set_format_t(ptr, i8, ptr)
declare ptr @resid_list_show_t(ptr, i8)
declare ptr @resid_fmt_radix(ptr, i64)
declare ptr @resid_fmt_group(ptr)
declare ptr @resid_fmt_case(ptr, i64)
declare ptr @resid_fmt_sign(ptr, i64)
declare ptr @resid_fmt_pad(ptr, i64)
declare ptr @resid_fmt_style(double, i64)
declare void @resid_fb_underfill(i64, i64)
declare i64 @resid_str_ascii_len(ptr)
declare i64 @resid_char_at_n(ptr, i64, i64)
declare double @llvm.sqrt.f64(double)
declare i64 @resid_disp_connect()
declare ptr @resid_disp_pair()
declare i8 @resid_disp_send(i64, ptr, i64)
declare ptr @resid_disp_recv(i64, i64)
declare ptr @resid_disp_poll(ptr, ptr, i64)
declare i64 @resid_disp_recv_fd()
declare i8 @resid_disp_close(i64)
declare i64 @resid_disp_shm_new(i64)
declare i64 @resid_disp_shm_fd(i64)
declare i8 @resid_disp_shm_put(i64, i64, ptr, i64)
declare i8 @resid_disp_shm_free(i64)
declare ptr @resid_dbg_dump(i64, i64)
declare ptr @resid_map_transient(ptr)
declare ptr @resid_map_freeze(ptr)
declare ptr @resid_map_put(ptr, i8, i8, i64, i8, i64)
declare ptr @resid_map_del(ptr, i8, i8, i64)
declare ptr @resid_set_put(ptr, i8, i8, i64)
declare i128 @resid_map_find(ptr, i8, i64, i8)
declare i8 @resid_map_has(ptr, i8, i64)
declare ptr @resid_rec_new(i64, i8)
declare ptr @resid_rec_reuse(ptr, i64)
declare void @resid_rec_share(ptr)
declare ptr @resid_str_keep(ptr)
declare ptr @resid_map_evac(ptr, i8, i8)
declare ptr @resid_list_evac(ptr)
declare ptr @resid_dec_evac(ptr)
declare i64 @resid_loop_enter()
declare i1 @resid_loop_due(i64)
declare ptr @resid_loop_move(i64, i64)
declare ptr @resid_loop_exit(i64, i64)
declare ptr @resid_mv_str(ptr, ptr)
declare ptr @resid_mv_list(ptr, ptr)
declare ptr @resid_mv_list_f(ptr, ptr, ptr)
declare ptr @resid_mv_map(ptr, i8, i8, ptr)
declare ptr @resid_mv_rec(ptr, i64, i8, ptr)
declare ptr @resid_mv_dec(ptr, ptr)
declare ptr @resid_map_list_push(ptr, i8, i8, i64, ptr, ptr)
declare ptr @resid_map_format_k(ptr, i8, i8)
@.declassify.cap = private unnamed_addr constant [11 x i8] c"declassify\00"
@.provision.cap = private unnamed_addr constant [10 x i8] c"provision\00"
define i64 @bn_mask() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1 = trunc i128 18446744073709551615 to i64
ret i64 %t1
}
define i128 @__m____________lib_bignum_resid__bn_base() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i128 18446744073709551616
}
define i64 @__m____________lib_bignum_resid__bn_top(ptr %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8, %tco.s0 ]
%t2 = icmp sle i64 %p1, 0
br i1 %t2, label %L1, label %L3
L1:
ret i64 0
L3:
%t3 = sub nsw i64 %p1, 1
%t4 = call ptr @resid_list_get_v(ptr %p0, i64 %t3, ptr %p0.ld, i64 %p0.ln)
%t5 = call i64 @resid_unbox_i64(ptr %t4)
%t7 = icmp ne i64 %t5, 0
br i1 %t7, label %L4, label %L6
L4:
ret i64 %p1
L6:
%t8 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_trim(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10 = call i64 @resid_list_len(ptr %p0)
%t11 = call i64 @__m____________lib_bignum_resid__bn_top(ptr %p0, i64 %t10)
%t12 = call i64 @resid_list_len(ptr %p0)
%t13 = icmp eq i64 %t11, %t12
br i1 %t13, label %L7, label %L9
L7:
ret ptr %p0
L9:
%t14 = call ptr @resid_listbuf_new()
%t15 = call ptr @__m____________lib_bignum_resid__bn_take(ptr %p0, i64 %t11, i64 0, ptr %t14)
ret ptr %t15
}
define ptr @__m____________lib_bignum_resid__bn_take(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t18, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t25, %tco.s0 ]
%t16 = icmp sge i64 %p2, %p1
br i1 %t16, label %L10, label %L12
L10:
%t17 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty17)
ret ptr %t17
L12:
%t18 = add nsw i64 %p2, 1
%t19 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t20 = call i64 @resid_unbox_i64(ptr %t19)
%t22 = call ptr @resid_box_i64(i64 %t20)
%t25 = call ptr @resid_listbuf_push(ptr %p3, ptr %t22)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_zero() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t28 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty27)
ret ptr %t28
}
define ptr @bn_one() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t30 = call ptr @resid_list_const_i64(ptr @.lc29, i64 1, ptr @.lcd29, ptr @.lty29)
ret ptr %t30
}
define ptr @bn_from_u64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t31 = icmp eq i64 %p0, 0
br i1 %t31, label %L13, label %L15
L13:
%t33 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty32)
ret ptr %t33
L15:
%t34 = alloca [1 x ptr]
%t36 = call ptr @resid_box_i64(i64 %p0)
%t38 = getelementptr i8, ptr %t34, i64 0
store ptr %t36, ptr %t38
%t39 = call ptr @resid_list_new(i64 1, ptr %t34, ptr @.lty34)
ret ptr %t39
}
define i1 @bn_is_zero(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t40 = call i64 @resid_list_len(ptr %p0)
%t41 = icmp eq i64 %t40, 0
ret i1 %t41
}
define i1 @bn_is_odd(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t42 = call i64 @resid_list_len(ptr %p0)
%t43 = icmp sgt i64 %t42, 0
br label %LSL44
LSL44:
br i1 %t43, label %LSR44, label %LSJ44
LSR44:
%t45 = call ptr @resid_list_get(ptr %p0, i64 0)
%t46 = call i64 @resid_unbox_i64(ptr %t45)
%t48 = and i64 %t46, 1
%t49 = icmp eq i64 %t48, 1
br label %LSJ44
LSJ44:
%t50 = phi i1 [ false, %LSL44 ], [ %t49, %LSR44 ]
ret i1 %t50
}
define i64 @bn_cmp(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t51 = call i64 @resid_list_len(ptr %p0)
%t52 = call i64 @resid_list_len(ptr %p1)
%t53 = icmp ne i64 %t51, %t52
br i1 %t53, label %L16, label %L18
L16:
%t54 = call i64 @resid_list_len(ptr %p0)
%t55 = call i64 @resid_list_len(ptr %p1)
%t56 = icmp slt i64 %t54, %t55
br i1 %t56, label %L19, label %L20
L19:
br label %L21
L20:
br label %L21
L21:
%t57 = phi i64 [ -1, %L19 ], [ 1, %L20 ]
ret i64 %t57
L18:
%t58 = call i64 @resid_list_len(ptr %p0)
%t59 = sub nsw i64 %t58, 1
%t60 = call i64 @__m____________lib_bignum_resid__bn_cmp_at(ptr %p0, ptr %p1, i64 %t59)
ret i64 %t60
}
define i64 @__m____________lib_bignum_resid__bn_cmp_at(ptr %p0.in, ptr %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t77, %tco.s0 ]
%t61 = icmp slt i64 %p2, 0
br i1 %t61, label %L22, label %L24
L22:
ret i64 0
L24:
%t62 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t63 = call i64 @resid_unbox_i64(ptr %t62)
%t65 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t66 = call i64 @resid_unbox_i64(ptr %t65)
%t68 = icmp ne i64 %t63, %t66
br i1 %t68, label %L25, label %L27
L25:
%t69 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t70 = call i64 @resid_unbox_i64(ptr %t69)
%t72 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t73 = call i64 @resid_unbox_i64(ptr %t72)
%t75 = icmp ult i64 %t70, %t73
br i1 %t75, label %L28, label %L29
L28:
br label %L30
L29:
br label %L30
L30:
%t76 = phi i64 [ -1, %L28 ], [ 1, %L29 ]
ret i64 %t76
L27:
%t77 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_to_be(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t79 = call i64 @bn_bit_len(ptr %p0)
%t80 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t79, i64 7)
%t81 = extractvalue {i64, i1} %t80, 0
%t82 = extractvalue {i64, i1} %t80, 1
%t83 = zext i1 %t82 to i8
call void @resid_overflow_check(i8 %t83)
%t84 = sdiv i64 %t81, 8
%t85 = icmp sgt i64 %p1, %t84
br i1 %t85, label %L31, label %L32
L31:
br label %L33
L32:
br label %L33
L33:
%t86 = phi i64 [ %p1, %L31 ], [ %t84, %L32 ]
%t87 = call ptr @resid_listbuf_new()
%t88 = call ptr @__m____________lib_bignum_resid__bn_be_at(ptr %p0, i64 %t86, i64 0, ptr %t87)
ret ptr %t88
}
define ptr @__m____________lib_bignum_resid__bn_be_at(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t124, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t128, %tco.s0 ]
%t89 = icmp sge i64 %p2, %p1
br i1 %t89, label %L34, label %L36
L34:
%t90 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty90)
ret ptr %t90
L36:
%t91 = sub nsw i64 %p1, 1
%t92 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t91, i64 %p2)
%t93 = extractvalue {i64, i1} %t92, 0
%t94 = extractvalue {i64, i1} %t92, 1
%t95 = zext i1 %t94 to i8
call void @resid_overflow_check(i8 %t95)
%t96 = sdiv i64 %t93, 8
%t97 = call i64 @resid_list_len(ptr %p0)
%t98 = icmp sge i64 %t96, %t97
br i1 %t98, label %L37, label %L38
L37:
br label %L39
L38:
%t99 = call ptr @resid_list_get_v(ptr %p0, i64 %t96, ptr %p0.ld, i64 %p0.ln)
%t100 = call i64 @resid_unbox_i64(ptr %t99)
%t102 = srem i64 %t93, 8
%t103 = mul nsw i64 %t102, 8
%t104 = add i64 %t103, 0
%t105 = add i64 %t104, 0
%t106 = add i64 %t105, 0
%t107 = icmp ne i64 %t106, %t104
%t108 = icmp slt i64 %t103, 0
%t109 = or i1 %t107, %t108
%t110 = zext i1 %t109 to i8
call void @resid_conv_check(i8 %t110)
%t111 = icmp uge i64 %t105, 64
%t112 = add i64 %t105, 0
%t113 = lshr i64 %t100, %t112
%t114 = select i1 %t111, i64 0, i64 %t113
%t115 = and i64 %t114, 255
%t116 = add i64 %t115, 0
%t117 = add i64 %t116, 0
%t118 = add i64 %t117, 0
%t119 = icmp ne i64 %t118, %t116
%t120 = icmp slt i64 %t117, 0
%t121 = or i1 %t119, %t120
%t122 = zext i1 %t121 to i8
call void @resid_conv_check(i8 %t122)
br label %L39
L39:
%t123 = phi i64 [ 0, %L37 ], [ %t117, %L38 ]
%t124 = add nsw i64 %p2, 1
%t125 = call ptr @resid_box_i64(i64 %t123)
%t128 = call ptr @resid_listbuf_push(ptr %p3, ptr %t125)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_from_be(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t130 = call i64 @resid_list_len(ptr %p0)
%t131 = add nsw i64 %t130, 7
%t132 = sdiv i64 %t131, 8
%t133 = call ptr @resid_listbuf_new()
%t134 = call ptr @__m____________lib_bignum_resid__bn_from_be_at(ptr %p0, i64 %t132, i64 0, ptr %t133)
%t135 = musttail call ptr @bn_trim(ptr %t134)
ret ptr %t135
}
define ptr @__m____________lib_bignum_resid__bn_from_be_at(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t138, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t143, %tco.s0 ]
%t136 = icmp sge i64 %p2, %p1
br i1 %t136, label %L40, label %L42
L40:
%t137 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty137)
ret ptr %t137
L42:
%t138 = add nsw i64 %p2, 1
%t139 = call i64 @__m____________lib_bignum_resid__bn_limb_be(ptr %p0, i64 %p2, i64 0, i64 0)
%t140 = call ptr @resid_box_i64(i64 %t139)
%t143 = call ptr @resid_listbuf_push(ptr %p3, ptr %t140)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_bignum_resid__bn_limb_be(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t173, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t189, %tco.s0 ]
%t145 = icmp sge i64 %p2, 8
br i1 %t145, label %L43, label %L45
L43:
ret i64 %p3
L45:
%t146 = call i64 @resid_list_len(ptr %p0)
%t147 = sub nsw i64 %t146, 1
%t148 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t149 = extractvalue {i64, i1} %t148, 0
%t150 = extractvalue {i64, i1} %t148, 1
%t151 = zext i1 %t150 to i8
call void @resid_overflow_check(i8 %t151)
%t152 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t149, i64 %p2)
%t153 = extractvalue {i64, i1} %t152, 0
%t154 = extractvalue {i64, i1} %t152, 1
%t155 = zext i1 %t154 to i8
call void @resid_overflow_check(i8 %t155)
%t156 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t147, i64 %t153)
%t157 = extractvalue {i64, i1} %t156, 0
%t158 = extractvalue {i64, i1} %t156, 1
%t159 = zext i1 %t158 to i8
call void @resid_overflow_check(i8 %t159)
%t160 = icmp slt i64 %t157, 0
br i1 %t160, label %L46, label %L47
L46:
br label %L48
L47:
%t161 = call ptr @resid_list_get_v(ptr %p0, i64 %t157, ptr %p0.ld, i64 %p0.ln)
%t162 = call i64 @resid_unbox_i64(ptr %t161)
%t164 = and i64 %t162, 255
%t165 = add i64 %t164, 0
%t166 = add i64 %t165, 0
%t167 = add i64 %t166, 0
%t168 = icmp ne i64 %t167, %t165
%t169 = icmp slt i64 %t164, 0
%t170 = or i1 %t168, %t169
%t171 = zext i1 %t170 to i8
call void @resid_conv_check(i8 %t171)
br label %L48
L48:
%t172 = phi i64 [ 0, %L46 ], [ %t166, %L47 ]
%t173 = add nsw i64 %p2, 1
%t174 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 8)
%t175 = extractvalue {i64, i1} %t174, 0
%t176 = extractvalue {i64, i1} %t174, 1
%t177 = zext i1 %t176 to i8
call void @resid_overflow_check(i8 %t177)
%t178 = add i64 %t175, 0
%t179 = add i64 %t178, 0
%t180 = add i64 %t179, 0
%t181 = icmp ne i64 %t180, %t178
%t182 = icmp slt i64 %t175, 0
%t183 = or i1 %t181, %t182
%t184 = zext i1 %t183 to i8
call void @resid_conv_check(i8 %t184)
%t185 = icmp uge i64 %t179, 64
%t186 = add i64 %t179, 0
%t187 = shl i64 %t172, %t186
%t188 = select i1 %t185, i64 0, i64 %t187
%t189 = or i64 %p3, %t188
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_bignum_resid__bn_limb_bits(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t192, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t194, %tco.s0 ]
%t191 = icmp eq i64 %p0, 0
br i1 %t191, label %L49, label %L51
L49:
ret i64 %p1
L51:
%t192 = lshr i64 %p0, 1
%t193 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t194 = extractvalue {i64, i1} %t193, 0
%t195 = extractvalue {i64, i1} %t193, 1
%t196 = zext i1 %t195 to i8
call void @resid_overflow_check(i8 %t196)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @bn_bit_len(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t198 = call i64 @resid_list_len(ptr %p0)
%t199 = icmp eq i64 %t198, 0
br i1 %t199, label %L52, label %L54
L52:
ret i64 0
L54:
%t200 = call i64 @resid_list_len(ptr %p0)
%t201 = sub nsw i64 %t200, 1
%t202 = mul nsw i64 %t201, 64
%t203 = call i64 @resid_list_len(ptr %p0)
%t204 = sub nsw i64 %t203, 1
%t205 = call ptr @resid_list_get(ptr %p0, i64 %t204)
%t206 = call i64 @resid_unbox_i64(ptr %t205)
%t208 = call i64 @__m____________lib_bignum_resid__bn_limb_bits(i64 %t206, i64 0)
%t209 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t202, i64 %t208)
%t210 = extractvalue {i64, i1} %t209, 0
%t211 = extractvalue {i64, i1} %t209, 1
%t212 = zext i1 %t211 to i8
call void @resid_overflow_check(i8 %t212)
ret i64 %t210
}
define i64 @bn_bit(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t213 = sdiv i64 %p1, 64
%t214 = icmp slt i64 %p1, 0
br label %LSL215
LSL215:
br i1 %t214, label %LSJ215, label %LSR215
LSR215:
%t216 = call i64 @resid_list_len(ptr %p0)
%t217 = icmp sge i64 %t213, %t216
br label %LSJ215
LSJ215:
%t218 = phi i1 [ true, %LSL215 ], [ %t217, %LSR215 ]
br i1 %t218, label %L55, label %L57
L55:
ret i64 0
L57:
%t219 = call ptr @resid_list_get(ptr %p0, i64 %t213)
%t220 = call i64 @resid_unbox_i64(ptr %t219)
%t222 = srem i64 %p1, 64
%t223 = add i64 %t222, 0
%t224 = add i64 %t223, 0
%t225 = add i64 %t224, 0
%t226 = icmp ne i64 %t225, %t223
%t227 = icmp slt i64 %t222, 0
%t228 = or i1 %t226, %t227
%t229 = zext i1 %t228 to i8
call void @resid_conv_check(i8 %t229)
%t230 = icmp uge i64 %t224, 64
%t231 = add i64 %t224, 0
%t232 = lshr i64 %t220, %t231
%t233 = select i1 %t230, i64 0, i64 %t232
%t234 = and i64 %t233, 1
%t235 = add i64 %t234, 0
%t236 = add i64 %t235, 0
%t237 = add i64 %t236, 0
%t238 = icmp ne i64 %t237, %t235
%t239 = icmp slt i64 %t236, 0
%t240 = or i1 %t238, %t239
%t241 = zext i1 %t240 to i8
call void @resid_conv_check(i8 %t241)
ret i64 %t236
}
define ptr @bn_shl(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t242 = call i64 @resid_list_len(ptr %p0)
%t243 = icmp eq i64 %t242, 0
br i1 %t243, label %L58, label %L60
L58:
%t245 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty244)
ret ptr %t245
L60:
%t246 = sdiv i64 %p1, 64
%t247 = srem i64 %p1, 64
%t248 = call i64 @resid_list_len(ptr %p0)
%t249 = add nsw i64 %t248, %t246
%t250 = add nsw i64 %t249, 1
%t251 = call ptr @resid_listbuf_new()
%t252 = call ptr @__m____________lib_bignum_resid__bn_shl_at(ptr %p0, i64 %t246, i64 %t247, i64 0, i64 %t250, ptr %t251)
%t253 = call ptr @bn_trim(ptr %t252)
ret ptr %t253
}
define ptr @__m____________lib_bignum_resid__bn_shl_at(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t299, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi ptr [ %p5.in, %entry ], [ %t303, %tco.s0 ]
%t254 = icmp sge i64 %p3, %p4
br i1 %t254, label %L61, label %L63
L61:
%t255 = call ptr @resid_listbuf_finish(ptr %p5, ptr @.lty255)
ret ptr %t255
L63:
%t256 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p3, i64 %p1)
%t257 = extractvalue {i64, i1} %t256, 0
%t258 = extractvalue {i64, i1} %t256, 1
%t259 = zext i1 %t258 to i8
call void @resid_overflow_check(i8 %t259)
%t260 = call i64 @__m____________lib_bignum_resid__bn_get(ptr %p0, i64 %t257)
%t261 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p3, i64 %p1)
%t262 = extractvalue {i64, i1} %t261, 0
%t263 = extractvalue {i64, i1} %t261, 1
%t264 = zext i1 %t263 to i8
call void @resid_overflow_check(i8 %t264)
%t265 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t262, i64 1)
%t266 = extractvalue {i64, i1} %t265, 0
%t267 = extractvalue {i64, i1} %t265, 1
%t268 = zext i1 %t267 to i8
call void @resid_overflow_check(i8 %t268)
%t269 = call i64 @__m____________lib_bignum_resid__bn_get(ptr %p0, i64 %t266)
%t270 = icmp eq i64 %p2, 0
br i1 %t270, label %L64, label %L65
L64:
br label %L66
L65:
%t271 = add i64 %p2, 0
%t272 = add i64 %t271, 0
%t273 = add i64 %t272, 0
%t274 = icmp ne i64 %t273, %t271
%t275 = icmp slt i64 %p2, 0
%t276 = or i1 %t274, %t275
%t277 = zext i1 %t276 to i8
call void @resid_conv_check(i8 %t277)
%t278 = icmp uge i64 %t272, 64
%t279 = add i64 %t272, 0
%t280 = shl i64 %t260, %t279
%t281 = select i1 %t278, i64 0, i64 %t280
%t282 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 64, i64 %p2)
%t283 = extractvalue {i64, i1} %t282, 0
%t284 = extractvalue {i64, i1} %t282, 1
%t285 = zext i1 %t284 to i8
call void @resid_overflow_check(i8 %t285)
%t286 = add i64 %t283, 0
%t287 = add i64 %t286, 0
%t288 = add i64 %t287, 0
%t289 = icmp ne i64 %t288, %t286
%t290 = icmp slt i64 %t283, 0
%t291 = or i1 %t289, %t290
%t292 = zext i1 %t291 to i8
call void @resid_conv_check(i8 %t292)
%t293 = icmp uge i64 %t287, 64
%t294 = add i64 %t287, 0
%t295 = lshr i64 %t269, %t294
%t296 = select i1 %t293, i64 0, i64 %t295
%t297 = or i64 %t281, %t296
br label %L66
L66:
%t298 = phi i64 [ %t260, %L64 ], [ %t297, %L65 ]
%t299 = add nsw i64 %p3, 1
%t300 = call ptr @resid_box_i64(i64 %t298)
%t303 = call ptr @resid_listbuf_push(ptr %p5, ptr %t300)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_bignum_resid__bn_get(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t305 = icmp slt i64 %p1, 0
br label %LSL306
LSL306:
br i1 %t305, label %LSJ306, label %LSR306
LSR306:
%t307 = call i64 @resid_list_len(ptr %p0)
%t308 = icmp sge i64 %p1, %t307
br label %LSJ306
LSJ306:
%t309 = phi i1 [ true, %LSL306 ], [ %t308, %LSR306 ]
br i1 %t309, label %L67, label %L69
L67:
ret i64 0
L69:
%t310 = call ptr @resid_list_get_nc(ptr %p0, i64 %p1)
%t311 = call i64 @resid_unbox_i64(ptr %t310)
ret i64 %t311
}
define ptr @bn_shr(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t313 = sdiv i64 %p1, 64
%t314 = srem i64 %p1, 64
%t315 = call i64 @resid_list_len(ptr %p0)
%t316 = icmp sge i64 %t313, %t315
br i1 %t316, label %L70, label %L72
L70:
%t318 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty317)
ret ptr %t318
L72:
%t319 = call i64 @resid_list_len(ptr %p0)
%t320 = sub nsw i64 %t319, %t313
%t321 = call ptr @resid_listbuf_new()
%t322 = call ptr @__m____________lib_bignum_resid__bn_shr_at(ptr %p0, i64 %t313, i64 %t314, i64 0, i64 %t320, ptr %t321)
%t323 = call ptr @bn_trim(ptr %t322)
ret ptr %t323
}
define ptr @__m____________lib_bignum_resid__bn_shr_at(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t369, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi ptr [ %p5.in, %entry ], [ %t373, %tco.s0 ]
%t324 = icmp sge i64 %p3, %p4
br i1 %t324, label %L73, label %L75
L73:
%t325 = call ptr @resid_listbuf_finish(ptr %p5, ptr @.lty325)
ret ptr %t325
L75:
%t326 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %p1)
%t327 = extractvalue {i64, i1} %t326, 0
%t328 = extractvalue {i64, i1} %t326, 1
%t329 = zext i1 %t328 to i8
call void @resid_overflow_check(i8 %t329)
%t330 = call i64 @__m____________lib_bignum_resid__bn_get(ptr %p0, i64 %t327)
%t331 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %p1)
%t332 = extractvalue {i64, i1} %t331, 0
%t333 = extractvalue {i64, i1} %t331, 1
%t334 = zext i1 %t333 to i8
call void @resid_overflow_check(i8 %t334)
%t335 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t332, i64 1)
%t336 = extractvalue {i64, i1} %t335, 0
%t337 = extractvalue {i64, i1} %t335, 1
%t338 = zext i1 %t337 to i8
call void @resid_overflow_check(i8 %t338)
%t339 = call i64 @__m____________lib_bignum_resid__bn_get(ptr %p0, i64 %t336)
%t340 = icmp eq i64 %p2, 0
br i1 %t340, label %L76, label %L77
L76:
br label %L78
L77:
%t341 = add i64 %p2, 0
%t342 = add i64 %t341, 0
%t343 = add i64 %t342, 0
%t344 = icmp ne i64 %t343, %t341
%t345 = icmp slt i64 %p2, 0
%t346 = or i1 %t344, %t345
%t347 = zext i1 %t346 to i8
call void @resid_conv_check(i8 %t347)
%t348 = icmp uge i64 %t342, 64
%t349 = add i64 %t342, 0
%t350 = lshr i64 %t330, %t349
%t351 = select i1 %t348, i64 0, i64 %t350
%t352 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 64, i64 %p2)
%t353 = extractvalue {i64, i1} %t352, 0
%t354 = extractvalue {i64, i1} %t352, 1
%t355 = zext i1 %t354 to i8
call void @resid_overflow_check(i8 %t355)
%t356 = add i64 %t353, 0
%t357 = add i64 %t356, 0
%t358 = add i64 %t357, 0
%t359 = icmp ne i64 %t358, %t356
%t360 = icmp slt i64 %t353, 0
%t361 = or i1 %t359, %t360
%t362 = zext i1 %t361 to i8
call void @resid_conv_check(i8 %t362)
%t363 = icmp uge i64 %t357, 64
%t364 = add i64 %t357, 0
%t365 = shl i64 %t339, %t364
%t366 = select i1 %t363, i64 0, i64 %t365
%t367 = or i64 %t351, %t366
br label %L78
L78:
%t368 = phi i64 [ %t330, %L76 ], [ %t367, %L77 ]
%t369 = add nsw i64 %p3, 1
%t370 = call ptr @resid_box_i64(i64 %t368)
%t373 = call ptr @resid_listbuf_push(ptr %p5, ptr %t370)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_add(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t375 = call i64 @resid_list_len(ptr %p0)
%t376 = call i64 @resid_list_len(ptr %p1)
%t377 = icmp sgt i64 %t375, %t376
br i1 %t377, label %L79, label %L80
L79:
%t378 = call i64 @resid_list_len(ptr %p0)
br label %L81
L80:
%t379 = call i64 @resid_list_len(ptr %p1)
br label %L81
L81:
%t380 = phi i64 [ %t378, %L79 ], [ %t379, %L80 ]
%t381 = call ptr @resid_listbuf_new()
%t382 = call ptr @__m____________lib_bignum_resid__bn_add_at(ptr %p0, ptr %p1, i64 0, i64 %t380, i64 0, ptr %t381)
ret ptr %t382
}
define ptr @__m____________lib_bignum_resid__bn_add_at(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t405, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t408, %tco.s0 ]
%p5 = phi ptr [ %p5.in, %entry ], [ %t418, %tco.s0 ]
%t383 = icmp sge i64 %p2, %p3
br i1 %t383, label %L82, label %L84
L82:
%t384 = icmp eq i64 %p4, 0
br i1 %t384, label %L85, label %L86
L85:
%t385 = call ptr @resid_listbuf_finish(ptr %p5, ptr @.lty385)
br label %L87
L86:
%t386 = call ptr @resid_box_i64(i64 %p4)
%t389 = call ptr @resid_listbuf_push(ptr %p5, ptr %t386)
%t390 = call ptr @resid_listbuf_finish(ptr %t389, ptr @.lty390)
br label %L87
L87:
%t391 = phi ptr [ %t385, %L85 ], [ %t390, %L86 ]
ret ptr %t391
L84:
%t392 = call i64 @__m____________lib_bignum_resid__bn_get(ptr %p0, i64 %p2)
%t393 = zext i64 %t392 to i128
%t394 = call i64 @__m____________lib_bignum_resid__bn_get(ptr %p1, i64 %p2)
%t395 = zext i64 %t394 to i128
%t396 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t393, i128 %t395)
%t397 = extractvalue {i128, i1} %t396, 0
%t398 = extractvalue {i128, i1} %t396, 1
%t399 = zext i1 %t398 to i8
call void @resid_overflow_check(i8 %t399)
%t400 = zext i64 %p4 to i128
%t401 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t397, i128 %t400)
%t402 = extractvalue {i128, i1} %t401, 0
%t403 = extractvalue {i128, i1} %t401, 1
%t404 = zext i1 %t403 to i8
call void @resid_overflow_check(i8 %t404)
%t405 = add nsw i64 %p2, 1
%t406 = lshr i128 %t402, 64
%t407 = add i128 %t406, 0
%t408 = trunc i128 %t407 to i64
%t409 = zext i64 %t408 to i128
%t410 = icmp ne i128 %t409, %t407
%t411 = icmp eq i8 0, 1
%t412 = or i1 %t410, %t411
%t413 = zext i1 %t412 to i8
call void @resid_conv_check(i8 %t413)
%t414 = trunc i128 %t402 to i64
%t415 = call ptr @resid_box_i64(i64 %t414)
%t418 = call ptr @resid_listbuf_push(ptr %p5, ptr %t415)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_sub(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t420 = call i64 @bn_cmp(ptr %p0, ptr %p1)
%t421 = icmp sge i64 %t420, 0
%t423 = zext i1 %t421 to i8
call void @resid_assert(i8 %t423, ptr @.s422)
%t424 = call i64 @resid_list_len(ptr %p0)
%t425 = call ptr @resid_listbuf_new()
%t426 = call ptr @__m____________lib_bignum_resid__bn_sub_at(ptr %p0, ptr %p1, i64 0, i64 %t424, i64 0, ptr %t425)
%t427 = call ptr @bn_trim(ptr %t426)
ret ptr %t427
}
define ptr @__m____________lib_bignum_resid__bn_sub_at(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t457, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t456, %tco.s0 ]
%p5 = phi ptr [ %p5.in, %entry ], [ %t462, %tco.s0 ]
%t428 = icmp sge i64 %p2, %p3
br i1 %t428, label %L88, label %L90
L88:
%t429 = call ptr @resid_listbuf_finish(ptr %p5, ptr @.lty429)
ret ptr %t429
L90:
%t430 = add i128 18446744073709551616, 0
%t431 = add i128 %t430, 0
%t432 = add i128 %t431, 0
%t433 = icmp ne i128 %t432, %t430
%t434 = icmp slt i128 18446744073709551616, 0
%t435 = or i1 %t433, %t434
%t436 = zext i1 %t435 to i8
call void @resid_conv_check(i8 %t436)
%t437 = call i64 @__m____________lib_bignum_resid__bn_get(ptr %p0, i64 %p2)
%t438 = zext i64 %t437 to i128
%t439 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t431, i128 %t438)
%t440 = extractvalue {i128, i1} %t439, 0
%t441 = extractvalue {i128, i1} %t439, 1
%t442 = zext i1 %t441 to i8
call void @resid_overflow_check(i8 %t442)
%t443 = call i64 @__m____________lib_bignum_resid__bn_get(ptr %p1, i64 %p2)
%t444 = zext i64 %t443 to i128
%t445 = call {i128, i1} @llvm.usub.with.overflow.i128(i128 %t440, i128 %t444)
%t446 = extractvalue {i128, i1} %t445, 0
%t447 = extractvalue {i128, i1} %t445, 1
%t448 = zext i1 %t447 to i8
call void @resid_overflow_check(i8 %t448)
%t449 = zext i64 %p4 to i128
%t450 = call {i128, i1} @llvm.usub.with.overflow.i128(i128 %t446, i128 %t449)
%t451 = extractvalue {i128, i1} %t450, 0
%t452 = extractvalue {i128, i1} %t450, 1
%t453 = zext i1 %t452 to i8
call void @resid_overflow_check(i8 %t453)
%t454 = lshr i128 %t451, 64
%t455 = icmp eq i128 %t454, 0
br i1 %t455, label %L91, label %L92
L91:
br label %L93
L92:
br label %L93
L93:
%t456 = phi i64 [ 1, %L91 ], [ 0, %L92 ]
%t457 = add nsw i64 %p2, 1
%t458 = trunc i128 %t451 to i64
%t459 = call ptr @resid_box_i64(i64 %t458)
%t462 = call ptr @resid_listbuf_push(ptr %p5, ptr %t459)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_mul(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t464 = call i64 @resid_list_len(ptr %p0)
%t465 = icmp eq i64 %t464, 0
br label %LSL466
LSL466:
br i1 %t465, label %LSJ466, label %LSR466
LSR466:
%t467 = call i64 @resid_list_len(ptr %p1)
%t468 = icmp eq i64 %t467, 0
br label %LSJ466
LSJ466:
%t469 = phi i1 [ true, %LSL466 ], [ %t468, %LSR466 ]
br i1 %t469, label %L94, label %L96
L94:
%t471 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty470)
ret ptr %t471
L96:
%t472 = call i64 @resid_list_len(ptr %p0)
%t473 = call i64 @resid_list_len(ptr %p1)
%t474 = add nsw i64 %t472, %t473
%t475 = sext i64 0 to i256
%t476 = call ptr @resid_listbuf_new()
%t477 = call ptr @__m____________lib_bignum_resid__bn_mul_cols(ptr %p0, ptr %p1, i64 0, i64 %t474, i256 %t475, ptr %t476)
%t478 = call ptr @bn_trim(ptr %t477)
ret ptr %t478
}
define ptr @__m____________lib_bignum_resid__bn_mul_cols(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i256 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t502, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i256 [ %p4.in, %entry ], [ %t503, %tco.s0 ]
%p5 = phi ptr [ %p5.in, %entry ], [ %t508, %tco.s0 ]
%t479 = icmp sge i64 %p2, %p3
br i1 %t479, label %L97, label %L99
L97:
%t480 = call ptr @resid_listbuf_finish(ptr %p5, ptr @.lty480)
ret ptr %t480
L99:
%t481 = call i64 @resid_list_len(ptr %p1)
%t482 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 %t481)
%t483 = extractvalue {i64, i1} %t482, 0
%t484 = extractvalue {i64, i1} %t482, 1
%t485 = zext i1 %t484 to i8
call void @resid_overflow_check(i8 %t485)
%t486 = add nsw i64 %t483, 1
%t487 = icmp sgt i64 %t486, 0
br i1 %t487, label %L100, label %L101
L100:
%t488 = call i64 @resid_list_len(ptr %p1)
%t489 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 %t488)
%t490 = extractvalue {i64, i1} %t489, 0
%t491 = extractvalue {i64, i1} %t489, 1
%t492 = zext i1 %t491 to i8
call void @resid_overflow_check(i8 %t492)
%t493 = add nsw i64 %t490, 1
br label %L102
L101:
br label %L102
L102:
%t494 = phi i64 [ %t493, %L100 ], [ 0, %L101 ]
%t495 = call i64 @resid_list_len(ptr %p0)
%t496 = sub nsw i64 %t495, 1
%t497 = icmp slt i64 %p2, %t496
br i1 %t497, label %L103, label %L104
L103:
br label %L105
L104:
%t498 = call i64 @resid_list_len(ptr %p0)
%t499 = sub nsw i64 %t498, 1
br label %L105
L105:
%t500 = phi i64 [ %p2, %L103 ], [ %t499, %L104 ]
%t501 = call i256 @__m____________lib_bignum_resid__bn_col(ptr %p0, ptr %p1, i64 %p2, i64 %t494, i64 %t500, i256 %p4)
%t502 = add nsw i64 %p2, 1
%t503 = lshr i256 %t501, 64
%t504 = trunc i256 %t501 to i64
%t505 = call ptr @resid_box_i64(i64 %t504)
%t508 = call ptr @resid_listbuf_push(ptr %p5, ptr %t505)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i256 @__m____________lib_bignum_resid__bn_col(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i256 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t528, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i256 [ %p5.in, %entry ], [ %t533, %tco.s0 ]
%t510 = icmp sgt i64 %p3, %p4
br i1 %t510, label %L106, label %L108
L106:
ret i256 %p5
L108:
%t511 = call ptr @resid_list_get_v(ptr %p0, i64 %p3, ptr %p0.ld, i64 %p0.ln)
%t512 = call i64 @resid_unbox_i64(ptr %t511)
%t514 = zext i64 %t512 to i128
%t515 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 %p3)
%t516 = extractvalue {i64, i1} %t515, 0
%t517 = extractvalue {i64, i1} %t515, 1
%t518 = zext i1 %t517 to i8
call void @resid_overflow_check(i8 %t518)
%t519 = call ptr @resid_list_get_v(ptr %p1, i64 %t516, ptr %p1.ld, i64 %p1.ln)
%t520 = call i64 @resid_unbox_i64(ptr %t519)
%t522 = zext i64 %t520 to i128
%t523 = call {i128, i1} @llvm.umul.with.overflow.i128(i128 %t514, i128 %t522)
%t524 = extractvalue {i128, i1} %t523, 0
%t525 = extractvalue {i128, i1} %t523, 1
%t526 = zext i1 %t525 to i8
call void @resid_overflow_check(i8 %t526)
%t527 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 1)
%t528 = extractvalue {i64, i1} %t527, 0
%t529 = extractvalue {i64, i1} %t527, 1
%t530 = zext i1 %t529 to i8
call void @resid_overflow_check(i8 %t530)
%t531 = zext i128 %t524 to i256
%t532 = call {i256, i1} @llvm.uadd.with.overflow.i256(i256 %p5, i256 %t531)
%t533 = extractvalue {i256, i1} %t532, 0
%t534 = extractvalue {i256, i1} %t532, 1
%t535 = zext i1 %t534 to i8
call void @resid_overflow_check(i8 %t535)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_divmod(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t537 = call i64 @resid_list_len(ptr %p1)
%t538 = icmp sgt i64 %t537, 0
%t540 = zext i1 %t538 to i8
call void @resid_assert(i8 %t540, ptr @.s539)
%t541 = call i64 @bn_cmp(ptr %p0, ptr %p1)
%t542 = icmp slt i64 %t541, 0
br i1 %t542, label %L109, label %L111
L109:
%t543 = call ptr @resid_gmalloc(i64 16)
%t544 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyE544)
%t543.f0 = getelementptr i8, ptr %t543, i64 0
store ptr %t544, ptr %t543.f0, align 8
%t543.f1 = getelementptr i8, ptr %t543, i64 8
store ptr %p0, ptr %t543.f1, align 8
ret ptr %t543
L111:
%t545 = call i64 @resid_list_len(ptr %p1)
%t546 = icmp eq i64 %t545, 1
br i1 %t546, label %L112, label %L114
L112:
%t547 = call ptr @resid_list_get(ptr %p1, i64 0)
%t548 = call i64 @resid_unbox_i64(ptr %t547)
%t550 = call ptr @__m____________lib_bignum_resid__bn_divmod_short(ptr %p0, i64 %t548)
ret ptr %t550
L114:
%t551 = call i64 @resid_list_len(ptr %p1)
%t552 = sub nsw i64 %t551, 1
%t553 = call ptr @resid_list_get(ptr %p1, i64 %t552)
%t554 = call i64 @resid_unbox_i64(ptr %t553)
%t556 = call i64 @__m____________lib_bignum_resid__bn_limb_bits(i64 %t554, i64 0)
%t557 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 64, i64 %t556)
%t558 = extractvalue {i64, i1} %t557, 0
%t559 = extractvalue {i64, i1} %t557, 1
%t560 = zext i1 %t559 to i8
call void @resid_overflow_check(i8 %t560)
%t561 = call ptr @bn_shl(ptr %p1, i64 %t558)
%t562 = call ptr @bn_shl(ptr %p0, i64 %t558)
%t563 = call i64 @resid_list_len(ptr %t562)
%t564 = call i64 @resid_list_len(ptr %p0)
%t565 = icmp eq i64 %t563, %t564
br i1 %t565, label %L115, label %L116
L115:
%t567 = call ptr @resid_list_const_i64(ptr @.lc566, i64 1, ptr @.lcd566, ptr @.lty566)
%t568 = call ptr @resid_list_concat_own(ptr %t562, i8 1, ptr %t567)
br label %L117
L116:
br label %L117
L117:
%t569 = phi ptr [ %t568, %L115 ], [ %t562, %L116 ]
%t570 = call i64 @resid_list_len(ptr %t561)
%t571 = call i64 @resid_list_len(ptr %t569)
%t572 = sub nsw i64 %t571, %t570
%t573 = sub nsw i64 %t572, 1
%t574 = call ptr @resid_listbuf_new()
%t575 = call ptr @__m____________lib_bignum_resid__bn_div_loop(ptr %t569, ptr %t561, i64 %t570, i64 %t573, ptr %t574)
%t576 = call ptr @resid_gmalloc(i64 16)
%t577 = getelementptr i8, ptr %t575, i64 8
%t578 = load ptr, ptr %t577, align 8
%t579 = call ptr @bn_trim(ptr %t578)
%t576.f0 = getelementptr i8, ptr %t576, i64 0
store ptr %t579, ptr %t576.f0, align 8
%t580 = getelementptr i8, ptr %t575, i64 0
%t581 = load ptr, ptr %t580, align 8
%t582 = call ptr @resid_listbuf_new()
%t583 = call ptr @__m____________lib_bignum_resid__bn_take(ptr %t581, i64 %t570, i64 0, ptr %t582)
%t584 = call ptr @bn_trim(ptr %t583)
%t585 = call ptr @bn_shr(ptr %t584, i64 %t558)
%t576.f1 = getelementptr i8, ptr %t576, i64 8
store ptr %t585, ptr %t576.f1, align 8
ret ptr %t576
}
define ptr @__m____________lib_bignum_resid__bn_div_loop(ptr %p0, ptr %p1, i64 %p2, i64 %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t586 = call ptr @__m____________lib_bignum_resid__bn_div_step(ptr %p0, ptr %p1, i64 %p2, i64 %p3, i64 %p3, ptr %p4)
ret ptr %t586
}
define ptr @__m____________lib_bignum_resid__bn_div_step(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %t665, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t688, %tco.s0 ]
%p5 = phi ptr [ %p5.in, %entry ], [ %t692, %tco.s0 ]
%t587 = icmp slt i64 %p4, 0
br i1 %t587, label %L118, label %L120
L118:
%t588 = call ptr @resid_gmalloc(i64 16)
%t588.f0 = getelementptr i8, ptr %t588, i64 0
store ptr %p0, ptr %t588.f0, align 8
%t589 = call ptr @resid_listbuf_finish(ptr %p5, ptr @.lty589)
%t590 = call ptr @__m____________lib_bignum_resid__bn_reverse(ptr %t589)
%t588.f1 = getelementptr i8, ptr %t588, i64 8
store ptr %t590, ptr %t588.f1, align 8
ret ptr %t588
L120:
%t591 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p4, i64 %p2)
%t592 = extractvalue {i64, i1} %t591, 0
%t593 = extractvalue {i64, i1} %t591, 1
%t594 = zext i1 %t593 to i8
call void @resid_overflow_check(i8 %t594)
%t595 = call ptr @resid_list_get(ptr %p0, i64 %t592)
%t596 = call i64 @resid_unbox_i64(ptr %t595)
%t598 = zext i64 %t596 to i128
%t599 = shl i128 %t598, 64
%t600 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p4, i64 %p2)
%t601 = extractvalue {i64, i1} %t600, 0
%t602 = extractvalue {i64, i1} %t600, 1
%t603 = zext i1 %t602 to i8
call void @resid_overflow_check(i8 %t603)
%t604 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t601, i64 1)
%t605 = extractvalue {i64, i1} %t604, 0
%t606 = extractvalue {i64, i1} %t604, 1
%t607 = zext i1 %t606 to i8
call void @resid_overflow_check(i8 %t607)
%t608 = call ptr @resid_list_get(ptr %p0, i64 %t605)
%t609 = call i64 @resid_unbox_i64(ptr %t608)
%t611 = zext i64 %t609 to i128
%t612 = or i128 %t599, %t611
%t613 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 1)
%t614 = extractvalue {i64, i1} %t613, 0
%t615 = extractvalue {i64, i1} %t613, 1
%t616 = zext i1 %t615 to i8
call void @resid_overflow_check(i8 %t616)
%t617 = call ptr @resid_list_get_v(ptr %p1, i64 %t614, ptr %p1.ld, i64 %p1.ln)
%t618 = call i64 @resid_unbox_i64(ptr %t617)
%t620 = zext i64 %t618 to i128
%t621 = icmp eq i128 %t620, 0
%t622 = zext i1 %t621 to i8
call void @resid_div_check(i8 %t622)
%t627 = udiv i128 %t612, %t620
%t628 = call {i128, i1} @llvm.umul.with.overflow.i128(i128 %t627, i128 %t620)
%t629 = extractvalue {i128, i1} %t628, 0
%t630 = extractvalue {i128, i1} %t628, 1
%t631 = zext i1 %t630 to i8
call void @resid_overflow_check(i8 %t631)
%t632 = call {i128, i1} @llvm.usub.with.overflow.i128(i128 %t612, i128 %t629)
%t633 = extractvalue {i128, i1} %t632, 0
%t634 = extractvalue {i128, i1} %t632, 1
%t635 = zext i1 %t634 to i8
call void @resid_overflow_check(i8 %t635)
%t636 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 2)
%t637 = extractvalue {i64, i1} %t636, 0
%t638 = extractvalue {i64, i1} %t636, 1
%t639 = zext i1 %t638 to i8
call void @resid_overflow_check(i8 %t639)
%t640 = call ptr @resid_list_get_v(ptr %p1, i64 %t637, ptr %p1.ld, i64 %p1.ln)
%t641 = call i64 @resid_unbox_i64(ptr %t640)
%t643 = zext i64 %t641 to i128
%t644 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p4, i64 %p2)
%t645 = extractvalue {i64, i1} %t644, 0
%t646 = extractvalue {i64, i1} %t644, 1
%t647 = zext i1 %t646 to i8
call void @resid_overflow_check(i8 %t647)
%t648 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t645, i64 2)
%t649 = extractvalue {i64, i1} %t648, 0
%t650 = extractvalue {i64, i1} %t648, 1
%t651 = zext i1 %t650 to i8
call void @resid_overflow_check(i8 %t651)
%t652 = call ptr @resid_list_get(ptr %p0, i64 %t649)
%t653 = call i64 @resid_unbox_i64(ptr %t652)
%t655 = zext i64 %t653 to i128
%t656 = call i128 @__m____________lib_bignum_resid__bn_qfix(i128 %t627, i128 %t633, i128 %t620, i128 %t643, i128 %t655)
%t657 = sext i64 0 to i128
%t658 = call ptr @__m____________lib_bignum_resid__bn_mulsub(ptr %p0, ptr %p1, i128 %t656, i64 %p4, i64 0, i128 %t657, i64 0, i64 %p2)
%t659 = getelementptr i8, ptr %t658, i64 0
%t660 = load ptr, ptr %t659, align 8
%t661 = getelementptr i8, ptr %t658, i64 8
%t662 = load i64, ptr %t661, align 8
%t663 = icmp eq i64 %t662, 0
br i1 %t663, label %L121, label %L122
L121:
br label %L123
L122:
%t664 = call ptr @__m____________lib_bignum_resid__bn_addback(ptr %t660, ptr %p1, i64 %p4, i64 0, i64 0, i64 %p2)
br label %L123
L123:
%t665 = phi ptr [ %t660, %L121 ], [ %t664, %L122 ]
%t666 = getelementptr i8, ptr %t658, i64 8
%t667 = load i64, ptr %t666, align 8
%t668 = icmp eq i64 %t667, 0
br i1 %t668, label %L124, label %L125
L124:
%t669 = add i128 %t656, 0
%t670 = trunc i128 %t669 to i64
%t671 = zext i64 %t670 to i128
%t672 = icmp ne i128 %t671, %t669
%t673 = icmp eq i8 0, 1
%t674 = or i1 %t672, %t673
%t675 = zext i1 %t674 to i8
call void @resid_conv_check(i8 %t675)
br label %L126
L125:
%t676 = call {i128, i1} @llvm.usub.with.overflow.i128(i128 %t656, i128 1)
%t677 = extractvalue {i128, i1} %t676, 0
%t678 = extractvalue {i128, i1} %t676, 1
%t679 = zext i1 %t678 to i8
call void @resid_overflow_check(i8 %t679)
%t680 = add i128 %t677, 0
%t681 = trunc i128 %t680 to i64
%t682 = zext i64 %t681 to i128
%t683 = icmp ne i128 %t682, %t680
%t684 = icmp eq i8 0, 1
%t685 = or i1 %t683, %t684
%t686 = zext i1 %t685 to i8
call void @resid_conv_check(i8 %t686)
br label %L126
L126:
%t687 = phi i64 [ %t670, %L124 ], [ %t681, %L125 ]
%t688 = sub nsw i64 %p4, 1
%t689 = call ptr @resid_box_i64(i64 %t687)
%t692 = call ptr @resid_listbuf_push(ptr %p5, ptr %t689)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_bignum_resid__bn_reverse(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t694 = call i64 @resid_list_len(ptr %p0)
%t695 = sub nsw i64 %t694, 1
%t696 = call ptr @resid_listbuf_new()
%t697 = call ptr @__m____________lib_bignum_resid__bn_rev_at(ptr %p0, i64 %t695, ptr %t696)
ret ptr %t697
}
define ptr @__m____________lib_bignum_resid__bn_rev_at(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t700, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t707, %tco.s0 ]
%t698 = icmp slt i64 %p1, 0
br i1 %t698, label %L127, label %L129
L127:
%t699 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty699)
ret ptr %t699
L129:
%t700 = sub nsw i64 %p1, 1
%t701 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t702 = call i64 @resid_unbox_i64(ptr %t701)
%t704 = call ptr @resid_box_i64(i64 %t702)
%t707 = call ptr @resid_listbuf_push(ptr %p2, ptr %t704)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i128 @__m____________lib_bignum_resid__bn_qfix(i128 %p0.in, i128 %p1.in, i128 %p2.in, i128 %p3.in, i128 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i128 [ %p0.in, %entry ], [ %t753, %tco.s0 ]
%p1 = phi i128 [ %p1.in, %entry ], [ %t737, %tco.s0 ]
%p2 = phi i128 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i128 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i128 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t709 = add i128 18446744073709551616, 0
%t710 = add i128 %t709, 0
%t711 = add i128 %t710, 0
%t712 = icmp ne i128 %t711, %t709
%t713 = icmp slt i128 18446744073709551616, 0
%t714 = or i1 %t712, %t713
%t715 = zext i1 %t714 to i8
call void @resid_conv_check(i8 %t715)
%t716 = icmp uge i128 %p0, %t710
br label %LSL717
LSL717:
br i1 %t716, label %LSJ717, label %LSR717
LSR717:
%t718 = add i128 18446744073709551616, 0
%t719 = add i128 %t718, 0
%t720 = add i128 %t719, 0
%t721 = icmp ne i128 %t720, %t718
%t722 = icmp slt i128 18446744073709551616, 0
%t723 = or i1 %t721, %t722
%t724 = zext i1 %t723 to i8
call void @resid_conv_check(i8 %t724)
%t725 = icmp ult i128 %p1, %t719
br label %LSL726
LSL726:
br i1 %t725, label %LSR726, label %LSJ726
LSR726:
%t727 = call {i128, i1} @llvm.umul.with.overflow.i128(i128 %p0, i128 %p3)
%t728 = extractvalue {i128, i1} %t727, 0
%t729 = extractvalue {i128, i1} %t727, 1
%t730 = zext i1 %t729 to i8
call void @resid_overflow_check(i8 %t730)
%t731 = shl i128 %p1, 64
%t732 = or i128 %t731, %p4
%t733 = icmp ugt i128 %t728, %t732
br label %LSJ726
LSJ726:
%t734 = phi i1 [ false, %LSL726 ], [ %t733, %LSR726 ]
br label %LSJ717
LSJ717:
%t735 = phi i1 [ true, %LSL717 ], [ %t734, %LSJ726 ]
br i1 %t735, label %L130, label %L132
L130:
%t736 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %p1, i128 %p2)
%t737 = extractvalue {i128, i1} %t736, 0
%t738 = extractvalue {i128, i1} %t736, 1
%t739 = zext i1 %t738 to i8
call void @resid_overflow_check(i8 %t739)
%t740 = add i128 18446744073709551616, 0
%t741 = add i128 %t740, 0
%t742 = add i128 %t741, 0
%t743 = icmp ne i128 %t742, %t740
%t744 = icmp slt i128 18446744073709551616, 0
%t745 = or i1 %t743, %t744
%t746 = zext i1 %t745 to i8
call void @resid_conv_check(i8 %t746)
%t747 = icmp uge i128 %t737, %t741
br i1 %t747, label %L133, label %L135
L133:
%t748 = call {i128, i1} @llvm.usub.with.overflow.i128(i128 %p0, i128 1)
%t749 = extractvalue {i128, i1} %t748, 0
%t750 = extractvalue {i128, i1} %t748, 1
%t751 = zext i1 %t750 to i8
call void @resid_overflow_check(i8 %t751)
ret i128 %t749
L135:
%t752 = call {i128, i1} @llvm.usub.with.overflow.i128(i128 %p0, i128 1)
%t753 = extractvalue {i128, i1} %t752, 0
%t754 = extractvalue {i128, i1} %t752, 1
%t755 = zext i1 %t754 to i8
call void @resid_overflow_check(i8 %t755)
br label %tco.s0
tco.s0:
br label %tco.head
L132:
ret i128 %p0
}
define ptr @__m____________lib_bignum_resid__bn_mulsub(ptr %p0.in, ptr %p1.in, i128 %p2.in, i64 %p3.in, i64 %p4.in, i128 %p5.in, i64 %p6.in, i64 %p7.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %t858, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i128 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t859, %tco.s0 ]
%p5 = phi i128 [ %p5.in, %entry ], [ %t860, %tco.s0 ]
%p6 = phi i64 [ %p6.in, %entry ], [ %t849, %tco.s0 ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p7, %tco.s0 ]
%t757 = icmp sge i64 %p4, %p7
br i1 %t757, label %L136, label %L138
L136:
%t758 = add i128 18446744073709551616, 0
%t759 = add i128 %t758, 0
%t760 = add i128 %t759, 0
%t761 = icmp ne i128 %t760, %t758
%t762 = icmp slt i128 18446744073709551616, 0
%t763 = or i1 %t761, %t762
%t764 = zext i1 %t763 to i8
call void @resid_conv_check(i8 %t764)
%t765 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %p7)
%t766 = extractvalue {i64, i1} %t765, 0
%t767 = extractvalue {i64, i1} %t765, 1
%t768 = zext i1 %t767 to i8
call void @resid_overflow_check(i8 %t768)
%t769 = call ptr @resid_list_get(ptr %p0, i64 %t766)
%t770 = call i64 @resid_unbox_i64(ptr %t769)
%t772 = zext i64 %t770 to i128
%t773 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t759, i128 %t772)
%t774 = extractvalue {i128, i1} %t773, 0
%t775 = extractvalue {i128, i1} %t773, 1
%t776 = zext i1 %t775 to i8
call void @resid_overflow_check(i8 %t776)
%t777 = call {i128, i1} @llvm.usub.with.overflow.i128(i128 %t774, i128 %p5)
%t778 = extractvalue {i128, i1} %t777, 0
%t779 = extractvalue {i128, i1} %t777, 1
%t780 = zext i1 %t779 to i8
call void @resid_overflow_check(i8 %t780)
%t781 = zext i64 %p6 to i128
%t782 = call {i128, i1} @llvm.usub.with.overflow.i128(i128 %t778, i128 %t781)
%t783 = extractvalue {i128, i1} %t782, 0
%t784 = extractvalue {i128, i1} %t782, 1
%t785 = zext i1 %t784 to i8
call void @resid_overflow_check(i8 %t785)
%t786 = lshr i128 %t783, 64
%t787 = icmp eq i128 %t786, 0
br i1 %t787, label %L139, label %L140
L139:
br label %L141
L140:
br label %L141
L141:
%t788 = phi i64 [ 1, %L139 ], [ 0, %L140 ]
%t789 = call ptr @resid_gmalloc(i64 16)
%t790 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %p7)
%t791 = extractvalue {i64, i1} %t790, 0
%t792 = extractvalue {i64, i1} %t790, 1
%t793 = zext i1 %t792 to i8
call void @resid_overflow_check(i8 %t793)
%t794 = trunc i128 %t783 to i64
%t798 = call ptr @resid_list_with_i64(ptr %p0, i8 1, i64 %t791, i64 %t794)
%t789.f0 = getelementptr i8, ptr %t789, i64 0
store ptr %t798, ptr %t789.f0, align 8
%t789.f1 = getelementptr i8, ptr %t789, i64 8
store i64 %t788, ptr %t789.f1, align 8
ret ptr %t789
L138:
%t799 = call ptr @resid_list_get_v(ptr %p1, i64 %p4, ptr %p1.ld, i64 %p1.ln)
%t800 = call i64 @resid_unbox_i64(ptr %t799)
%t802 = zext i64 %t800 to i128
%t803 = call {i128, i1} @llvm.umul.with.overflow.i128(i128 %p2, i128 %t802)
%t804 = extractvalue {i128, i1} %t803, 0
%t805 = extractvalue {i128, i1} %t803, 1
%t806 = zext i1 %t805 to i8
call void @resid_overflow_check(i8 %t806)
%t807 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t804, i128 %p5)
%t808 = extractvalue {i128, i1} %t807, 0
%t809 = extractvalue {i128, i1} %t807, 1
%t810 = zext i1 %t809 to i8
call void @resid_overflow_check(i8 %t810)
%t811 = add i128 18446744073709551615, 0
%t812 = add i128 %t811, 0
%t813 = add i128 %t812, 0
%t814 = icmp ne i128 %t813, %t811
%t815 = icmp slt i128 18446744073709551615, 0
%t816 = or i1 %t814, %t815
%t817 = zext i1 %t816 to i8
call void @resid_conv_check(i8 %t817)
%t818 = and i128 %t808, %t812
%t819 = add i128 18446744073709551616, 0
%t820 = add i128 %t819, 0
%t821 = add i128 %t820, 0
%t822 = icmp ne i128 %t821, %t819
%t823 = icmp slt i128 18446744073709551616, 0
%t824 = or i1 %t822, %t823
%t825 = zext i1 %t824 to i8
call void @resid_conv_check(i8 %t825)
%t826 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %p4)
%t827 = extractvalue {i64, i1} %t826, 0
%t828 = extractvalue {i64, i1} %t826, 1
%t829 = zext i1 %t828 to i8
call void @resid_overflow_check(i8 %t829)
%t830 = call ptr @resid_list_get(ptr %p0, i64 %t827)
%t831 = call i64 @resid_unbox_i64(ptr %t830)
%t833 = zext i64 %t831 to i128
%t834 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t820, i128 %t833)
%t835 = extractvalue {i128, i1} %t834, 0
%t836 = extractvalue {i128, i1} %t834, 1
%t837 = zext i1 %t836 to i8
call void @resid_overflow_check(i8 %t837)
%t838 = call {i128, i1} @llvm.usub.with.overflow.i128(i128 %t835, i128 %t818)
%t839 = extractvalue {i128, i1} %t838, 0
%t840 = extractvalue {i128, i1} %t838, 1
%t841 = zext i1 %t840 to i8
call void @resid_overflow_check(i8 %t841)
%t842 = zext i64 %p6 to i128
%t843 = call {i128, i1} @llvm.usub.with.overflow.i128(i128 %t839, i128 %t842)
%t844 = extractvalue {i128, i1} %t843, 0
%t845 = extractvalue {i128, i1} %t843, 1
%t846 = zext i1 %t845 to i8
call void @resid_overflow_check(i8 %t846)
%t847 = lshr i128 %t844, 64
%t848 = icmp eq i128 %t847, 0
br i1 %t848, label %L142, label %L143
L142:
br label %L144
L143:
br label %L144
L144:
%t849 = phi i64 [ 1, %L142 ], [ 0, %L143 ]
%t850 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %p4)
%t851 = extractvalue {i64, i1} %t850, 0
%t852 = extractvalue {i64, i1} %t850, 1
%t853 = zext i1 %t852 to i8
call void @resid_overflow_check(i8 %t853)
%t854 = trunc i128 %t844 to i64
%t858 = call ptr @resid_list_with_i64(ptr %p0, i8 1, i64 %t851, i64 %t854)
%t859 = add nsw i64 %p4, 1
%t860 = lshr i128 %t808, 64
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_bignum_resid__bn_addback(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %t914, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t915, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t918, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%t862 = icmp sge i64 %p3, %p5
br i1 %t862, label %L145, label %L147
L145:
%t863 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %p5)
%t864 = extractvalue {i64, i1} %t863, 0
%t865 = extractvalue {i64, i1} %t863, 1
%t866 = zext i1 %t865 to i8
call void @resid_overflow_check(i8 %t866)
%t867 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %p5)
%t868 = extractvalue {i64, i1} %t867, 0
%t869 = extractvalue {i64, i1} %t867, 1
%t870 = zext i1 %t869 to i8
call void @resid_overflow_check(i8 %t870)
%t871 = call ptr @resid_list_get(ptr %p0, i64 %t868)
%t872 = call i64 @resid_unbox_i64(ptr %t871)
%t874 = zext i64 %t872 to i128
%t875 = zext i64 %p4 to i128
%t876 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t874, i128 %t875)
%t877 = extractvalue {i128, i1} %t876, 0
%t878 = extractvalue {i128, i1} %t876, 1
%t879 = zext i1 %t878 to i8
call void @resid_overflow_check(i8 %t879)
%t880 = trunc i128 %t877 to i64
%t884 = call ptr @resid_list_with_i64(ptr %p0, i8 1, i64 %t864, i64 %t880)
ret ptr %t884
L147:
%t885 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %p3)
%t886 = extractvalue {i64, i1} %t885, 0
%t887 = extractvalue {i64, i1} %t885, 1
%t888 = zext i1 %t887 to i8
call void @resid_overflow_check(i8 %t888)
%t889 = call ptr @resid_list_get(ptr %p0, i64 %t886)
%t890 = call i64 @resid_unbox_i64(ptr %t889)
%t892 = zext i64 %t890 to i128
%t893 = call ptr @resid_list_get_v(ptr %p1, i64 %p3, ptr %p1.ld, i64 %p1.ln)
%t894 = call i64 @resid_unbox_i64(ptr %t893)
%t896 = zext i64 %t894 to i128
%t897 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t892, i128 %t896)
%t898 = extractvalue {i128, i1} %t897, 0
%t899 = extractvalue {i128, i1} %t897, 1
%t900 = zext i1 %t899 to i8
call void @resid_overflow_check(i8 %t900)
%t901 = zext i64 %p4 to i128
%t902 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t898, i128 %t901)
%t903 = extractvalue {i128, i1} %t902, 0
%t904 = extractvalue {i128, i1} %t902, 1
%t905 = zext i1 %t904 to i8
call void @resid_overflow_check(i8 %t905)
%t906 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %p3)
%t907 = extractvalue {i64, i1} %t906, 0
%t908 = extractvalue {i64, i1} %t906, 1
%t909 = zext i1 %t908 to i8
call void @resid_overflow_check(i8 %t909)
%t910 = trunc i128 %t903 to i64
%t914 = call ptr @resid_list_with_i64(ptr %p0, i8 1, i64 %t907, i64 %t910)
%t915 = add nsw i64 %p3, 1
%t916 = lshr i128 %t903, 64
%t917 = add i128 %t916, 0
%t918 = trunc i128 %t917 to i64
%t919 = zext i64 %t918 to i128
%t920 = icmp ne i128 %t919, %t917
%t921 = icmp eq i8 0, 1
%t922 = or i1 %t920, %t921
%t923 = zext i1 %t922 to i8
call void @resid_conv_check(i8 %t923)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_bignum_resid__bn_divmod_short(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t925 = call i64 @resid_list_len(ptr %p0)
%t926 = sub nsw i64 %t925, 1
%t927 = sext i64 0 to i128
%t928 = call ptr @resid_listbuf_new()
%t929 = call ptr @__m____________lib_bignum_resid__bn_short_at(ptr %p0, i64 %p1, i64 %t926, i128 %t927, ptr %t928)
ret ptr %t929
}
define ptr @__m____________lib_bignum_resid__bn_short_at(ptr %p0.in, i64 %p1.in, i64 %p2.in, i128 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t950, %tco.s0 ]
%p3 = phi i128 [ %p3.in, %entry ], [ %t963, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t983, %tco.s0 ]
%t930 = icmp slt i64 %p2, 0
br i1 %t930, label %L148, label %L150
L148:
%t931 = call ptr @resid_gmalloc(i64 16)
%t932 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty932)
%t933 = call ptr @__m____________lib_bignum_resid__bn_reverse(ptr %t932)
%t934 = call ptr @bn_trim(ptr %t933)
%t931.f0 = getelementptr i8, ptr %t931, i64 0
store ptr %t934, ptr %t931.f0, align 8
%t935 = add i128 %p3, 0
%t936 = trunc i128 %t935 to i64
%t937 = zext i64 %t936 to i128
%t938 = icmp ne i128 %t937, %t935
%t939 = icmp eq i8 0, 1
%t940 = or i1 %t938, %t939
%t941 = zext i1 %t940 to i8
call void @resid_conv_check(i8 %t941)
%t942 = call ptr @bn_from_u64(i64 %t936)
%t931.f1 = getelementptr i8, ptr %t931, i64 8
store ptr %t942, ptr %t931.f1, align 8
ret ptr %t931
L150:
%t943 = shl i128 %p3, 64
%t944 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t945 = call i64 @resid_unbox_i64(ptr %t944)
%t947 = zext i64 %t945 to i128
%t948 = or i128 %t943, %t947
%t949 = zext i64 %p1 to i128
%t950 = sub nsw i64 %p2, 1
%t951 = icmp eq i128 %t949, 0
%t952 = zext i1 %t951 to i8
call void @resid_div_check(i8 %t952)
%t957 = udiv i128 %t948, %t949
%t958 = call {i128, i1} @llvm.umul.with.overflow.i128(i128 %t957, i128 %t949)
%t959 = extractvalue {i128, i1} %t958, 0
%t960 = extractvalue {i128, i1} %t958, 1
%t961 = zext i1 %t960 to i8
call void @resid_overflow_check(i8 %t961)
%t962 = call {i128, i1} @llvm.usub.with.overflow.i128(i128 %t948, i128 %t959)
%t963 = extractvalue {i128, i1} %t962, 0
%t964 = extractvalue {i128, i1} %t962, 1
%t965 = zext i1 %t964 to i8
call void @resid_overflow_check(i8 %t965)
%t966 = icmp eq i128 %t949, 0
%t967 = zext i1 %t966 to i8
call void @resid_div_check(i8 %t967)
%t972 = udiv i128 %t948, %t949
%t973 = add i128 %t972, 0
%t974 = trunc i128 %t973 to i64
%t975 = zext i64 %t974 to i128
%t976 = icmp ne i128 %t975, %t973
%t977 = icmp eq i8 0, 1
%t978 = or i1 %t976, %t977
%t979 = zext i1 %t978 to i8
call void @resid_conv_check(i8 %t979)
%t980 = call ptr @resid_box_i64(i64 %t974)
%t983 = call ptr @resid_listbuf_push(ptr %p4, ptr %t980)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_mod(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t985 = call ptr @bn_divmod(ptr %p0, ptr %p1)
%t986 = getelementptr i8, ptr %t985, i64 8
%t987 = load ptr, ptr %t986, align 8
ret ptr %t987
}
define ptr @bn_modadd(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t988 = call ptr @bn_add(ptr %p0, ptr %p1)
%t989 = call i64 @bn_cmp(ptr %t988, ptr %p2)
%t990 = icmp sge i64 %t989, 0
br i1 %t990, label %L151, label %L152
L151:
%t991 = call ptr @bn_sub(ptr %t988, ptr %p2)
%t992 = call ptr @resid_list_freeze(ptr %t991)
br label %L153
L152:
br label %L153
L153:
%t993 = phi ptr [ %t992, %L151 ], [ %t988, %L152 ]
ret ptr %t993
}
define ptr @bn_modsub(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t994 = call i64 @bn_cmp(ptr %p0, ptr %p1)
%t995 = icmp sge i64 %t994, 0
br i1 %t995, label %L154, label %L155
L154:
%t996 = call ptr @bn_sub(ptr %p0, ptr %p1)
%t997 = call ptr @resid_list_freeze(ptr %t996)
br label %L156
L155:
%t998 = call ptr @bn_add(ptr %p0, ptr %p2)
%t999 = call ptr @resid_list_freeze(ptr %t998)
%t1000 = call ptr @bn_sub(ptr %t999, ptr %p1)
%t1001 = call ptr @resid_list_freeze(ptr %t1000)
br label %L156
L156:
%t1002 = phi ptr [ %t997, %L154 ], [ %t1001, %L155 ]
ret ptr %t1002
}
define ptr @bn_modmul(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1003 = call ptr @bn_mul(ptr %p0, ptr %p1)
%t1004 = call ptr @bn_mod(ptr %t1003, ptr %p2)
ret ptr %t1004
}
define ptr @bn_gcd(ptr %p0.in, ptr %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p1, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %t1007, %tco.s0 ]
%t1005 = call i64 @resid_list_len(ptr %p1)
%t1006 = icmp eq i64 %t1005, 0
br i1 %t1006, label %L157, label %L159
L157:
ret ptr %p0
L159:
%t1007 = call ptr @bn_mod(ptr %p0, ptr %p1)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_modinv(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1009 = call ptr @bn_mod(ptr %p0, ptr %p1)
%t1010 = call i64 @resid_list_len(ptr %t1009)
%t1011 = icmp eq i64 %t1010, 0
br i1 %t1011, label %L160, label %L162
L160:
ret ptr @.nbox1012
L162:
%t1014 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty1013)
%t1016 = call ptr @resid_list_const_i64(ptr @.lc1015, i64 1, ptr @.lcd1015, ptr @.lty1015)
%t1017 = call ptr @__m____________lib_bignum_resid__bn_inv_loop(ptr %p1, ptr %t1009, ptr %t1014, ptr %t1016, ptr %p1)
ret ptr %t1017
}
define ptr @__m____________lib_bignum_resid__bn_inv_loop(ptr %p0.in, ptr %p1.in, ptr %p2.in, ptr %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p1, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %t1033, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p3, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t1035, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%t1018 = call i64 @resid_list_len(ptr %p1)
%t1019 = icmp eq i64 %t1018, 0
br i1 %t1019, label %L163, label %L165
L163:
%t1021 = call ptr @resid_list_const_i64(ptr @.lc1020, i64 1, ptr @.lcd1020, ptr @.lty1020)
%t1022 = call i64 @bn_cmp(ptr %p0, ptr %t1021)
%t1023 = icmp ne i64 %t1022, 0
br i1 %t1023, label %L166, label %L168
L166:
ret ptr @.nbox1024
L168:
%t1027 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty1025)
%t1026 = getelementptr {i32, i32, ptr}, ptr %t1027, i32 1
store ptr %p2, ptr %t1026
ret ptr %t1027
L165:
%t1028 = call ptr @bn_divmod(ptr %p0, ptr %p1)
%t1029 = getelementptr i8, ptr %t1028, i64 0
%t1030 = load ptr, ptr %t1029, align 8
%t1031 = call ptr @bn_modmul(ptr %t1030, ptr %p3, ptr %p4)
%t1032 = getelementptr i8, ptr %t1028, i64 8
%t1033 = load ptr, ptr %t1032, align 8
%t1034 = call ptr @bn_modsub(ptr %p2, ptr %t1031, ptr %p4)
%t1035 = call ptr @resid_list_freeze(ptr %t1034)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_bignum_resid__bn_neg_inv(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1038 = call ptr @resid_list_const_i64(ptr @.lc1037, i64 1, ptr @.lcd1037, ptr @.lty1037)
%t1039 = call ptr @__m____________lib_bignum_resid__bn_newton(ptr %p0, i64 %p1, ptr %t1038, i64 1)
%t1041 = call ptr @resid_list_const_i64(ptr @.lc1040, i64 1, ptr @.lcd1040, ptr @.lty1040)
%t1042 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 64, i64 %p1)
%t1043 = extractvalue {i64, i1} %t1042, 0
%t1044 = extractvalue {i64, i1} %t1042, 1
%t1045 = zext i1 %t1044 to i8
call void @resid_overflow_check(i8 %t1045)
%t1046 = call ptr @bn_shl(ptr %t1041, i64 %t1043)
%t1047 = call ptr @__m____________lib_bignum_resid__bn_low(ptr %t1039, i64 %p1)
%t1048 = call ptr @bn_sub(ptr %t1046, ptr %t1047)
%t1049 = musttail call ptr @__m____________lib_bignum_resid__bn_low(ptr %t1048, i64 %p1)
ret ptr %t1049
}
define ptr @__m____________lib_bignum_resid__bn_newton(ptr %p0.in, i64 %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t1070, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1072, %tco.s0 ]
%t1050 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 64, i64 %p1)
%t1051 = extractvalue {i64, i1} %t1050, 0
%t1052 = extractvalue {i64, i1} %t1050, 1
%t1053 = zext i1 %t1052 to i8
call void @resid_overflow_check(i8 %t1053)
%t1054 = icmp sge i64 %p3, %t1051
br i1 %t1054, label %L169, label %L171
L169:
ret ptr %p2
L171:
%t1055 = call ptr @bn_mul(ptr %p0, ptr %p2)
%t1056 = call ptr @__m____________lib_bignum_resid__bn_low(ptr %t1055, i64 %p1)
%t1058 = call ptr @resid_list_const_i64(ptr @.lc1057, i64 1, ptr @.lcd1057, ptr @.lty1057)
%t1059 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 64, i64 %p1)
%t1060 = extractvalue {i64, i1} %t1059, 0
%t1061 = extractvalue {i64, i1} %t1059, 1
%t1062 = zext i1 %t1061 to i8
call void @resid_overflow_check(i8 %t1062)
%t1063 = call ptr @bn_shl(ptr %t1058, i64 %t1060)
%t1065 = call ptr @resid_list_const_i64(ptr @.lc1064, i64 1, ptr @.lcd1064, ptr @.lty1064)
%t1066 = call ptr @bn_add(ptr %t1063, ptr %t1065)
%t1067 = call ptr @bn_sub(ptr %t1066, ptr %t1056)
%t1068 = call ptr @__m____________lib_bignum_resid__bn_low(ptr %t1067, i64 %p1)
%t1069 = call ptr @bn_mul(ptr %p2, ptr %t1068)
%t1070 = call ptr @__m____________lib_bignum_resid__bn_low(ptr %t1069, i64 %p1)
%t1071 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p3, i64 2)
%t1072 = extractvalue {i64, i1} %t1071, 0
%t1073 = extractvalue {i64, i1} %t1071, 1
%t1074 = zext i1 %t1073 to i8
call void @resid_overflow_check(i8 %t1074)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_bignum_resid__bn_low(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1076 = call i64 @resid_list_len(ptr %p0)
%t1077 = icmp sle i64 %t1076, %p1
br i1 %t1077, label %L172, label %L174
L172:
ret ptr %p0
L174:
%t1078 = call ptr @resid_listbuf_new()
%t1079 = call ptr @__m____________lib_bignum_resid__bn_take(ptr %p0, i64 %p1, i64 0, ptr %t1078)
%t1080 = call ptr @bn_trim(ptr %t1079)
ret ptr %t1080
}
define ptr @bn_mont_new(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1081 = call i1 @bn_is_odd(ptr %p0)
br label %LSL1082
LSL1082:
br i1 %t1081, label %LSR1082, label %LSJ1082
LSR1082:
%t1084 = call ptr @resid_list_const_i64(ptr @.lc1083, i64 1, ptr @.lcd1083, ptr @.lty1083)
%t1085 = call i64 @bn_cmp(ptr %p0, ptr %t1084)
%t1086 = icmp sgt i64 %t1085, 0
br label %LSJ1082
LSJ1082:
%t1087 = phi i1 [ false, %LSL1082 ], [ %t1086, %LSR1082 ]
%t1089 = zext i1 %t1087 to i8
call void @resid_assert(i8 %t1089, ptr @.s1088)
%t1090 = call i64 @resid_list_len(ptr %p0)
%t1092 = call ptr @resid_list_const_i64(ptr @.lc1091, i64 1, ptr @.lcd1091, ptr @.lty1091)
%t1093 = mul nsw i64 128, %t1090
%t1094 = call ptr @bn_shl(ptr %t1092, i64 %t1093)
%t1095 = call ptr @bn_mod(ptr %t1094, ptr %p0)
%t1096 = call ptr @resid_gmalloc(i64 32)
%t1096.f0 = getelementptr i8, ptr %t1096, i64 0
store ptr %p0, ptr %t1096.f0, align 8
%t1096.f1 = getelementptr i8, ptr %t1096, i64 8
store i64 %t1090, ptr %t1096.f1, align 8
%t1097 = call ptr @__m____________lib_bignum_resid__bn_neg_inv(ptr %p0, i64 %t1090)
%t1096.f2 = getelementptr i8, ptr %t1096, i64 16
store ptr %t1097, ptr %t1096.f2, align 8
%t1096.f3 = getelementptr i8, ptr %t1096, i64 24
store ptr %t1095, ptr %t1096.f3, align 8
ret ptr %t1096
}
define ptr @__m____________lib_bignum_resid__bn_redc(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1098 = getelementptr i8, ptr %p0, i64 8
%t1099 = load i64, ptr %t1098, align 8
%t1100 = call ptr @__m____________lib_bignum_resid__bn_low(ptr %p1, i64 %t1099)
%t1101 = getelementptr i8, ptr %p0, i64 16
%t1102 = load ptr, ptr %t1101, align 8
%t1103 = call ptr @bn_mul(ptr %t1100, ptr %t1102)
%t1104 = getelementptr i8, ptr %p0, i64 8
%t1105 = load i64, ptr %t1104, align 8
%t1106 = call ptr @__m____________lib_bignum_resid__bn_low(ptr %t1103, i64 %t1105)
%t1107 = getelementptr i8, ptr %p0, i64 0
%t1108 = load ptr, ptr %t1107, align 8
%t1109 = call ptr @bn_mul(ptr %t1106, ptr %t1108)
%t1110 = call ptr @bn_add(ptr %p1, ptr %t1109)
%t1111 = getelementptr i8, ptr %p0, i64 8
%t1112 = load i64, ptr %t1111, align 8
%t1113 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 64, i64 %t1112)
%t1114 = extractvalue {i64, i1} %t1113, 0
%t1115 = extractvalue {i64, i1} %t1113, 1
%t1116 = zext i1 %t1115 to i8
call void @resid_overflow_check(i8 %t1116)
%t1117 = call ptr @bn_shr(ptr %t1110, i64 %t1114)
%t1118 = getelementptr i8, ptr %p0, i64 0
%t1119 = load ptr, ptr %t1118, align 8
%t1120 = call i64 @bn_cmp(ptr %t1117, ptr %t1119)
%t1121 = icmp sge i64 %t1120, 0
br i1 %t1121, label %L175, label %L176
L175:
%t1122 = getelementptr i8, ptr %p0, i64 0
%t1123 = load ptr, ptr %t1122, align 8
%t1124 = call ptr @bn_sub(ptr %t1117, ptr %t1123)
%t1125 = call ptr @resid_list_freeze(ptr %t1124)
br label %L177
L176:
br label %L177
L177:
%t1126 = phi ptr [ %t1125, %L175 ], [ %t1117, %L176 ]
ret ptr %t1126
}
define ptr @__m____________lib_bignum_resid__bn_mont_mul(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1127 = call ptr @bn_mul(ptr %p1, ptr %p2)
%t1128 = call ptr @resid_list_freeze(ptr %t1127)
%t1129 = call ptr @__m____________lib_bignum_resid__bn_redc(ptr %p0, ptr %t1128)
ret ptr %t1129
}
define ptr @bn_modexp_mont(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1130 = call i64 @resid_list_len(ptr %p2)
%t1131 = icmp eq i64 %t1130, 0
br i1 %t1131, label %L178, label %L180
L178:
%t1133 = call ptr @resid_list_const_i64(ptr @.lc1132, i64 1, ptr @.lcd1132, ptr @.lty1132)
%t1134 = getelementptr i8, ptr %p0, i64 0
%t1135 = load ptr, ptr %t1134, align 8
%t1136 = call ptr @bn_mod(ptr %t1133, ptr %t1135)
ret ptr %t1136
L180:
%t1137 = getelementptr i8, ptr %p0, i64 24
%t1138 = load ptr, ptr %t1137, align 8
%t1139 = call ptr @__m____________lib_bignum_resid__bn_mont_mul(ptr %p0, ptr %p1, ptr %t1138)
%t1141 = call ptr @resid_list_const_i64(ptr @.lc1140, i64 1, ptr @.lcd1140, ptr @.lty1140)
%t1142 = getelementptr i8, ptr %p0, i64 24
%t1143 = load ptr, ptr %t1142, align 8
%t1144 = call ptr @__m____________lib_bignum_resid__bn_mont_mul(ptr %p0, ptr %t1141, ptr %t1143)
%t1145 = call ptr @resid_list_freeze(ptr %t1144)
%t1146 = call i64 @bn_bit_len(ptr %p2)
%t1147 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t1146, i64 1)
%t1148 = extractvalue {i64, i1} %t1147, 0
%t1149 = extractvalue {i64, i1} %t1147, 1
%t1150 = zext i1 %t1149 to i8
call void @resid_overflow_check(i8 %t1150)
%t1151 = call ptr @__m____________lib_bignum_resid__bn_exp_bits(ptr %p0, ptr %t1139, ptr %p2, i64 %t1148, ptr %t1145)
%t1152 = call ptr @resid_list_freeze(ptr %t1151)
%t1153 = call ptr @__m____________lib_bignum_resid__bn_redc(ptr %p0, ptr %t1152)
ret ptr %t1153
}
define ptr @__m____________lib_bignum_resid__bn_exp_bits(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1161, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t1160, %tco.s0 ]
%t1154 = icmp slt i64 %p3, 0
br i1 %t1154, label %L181, label %L183
L181:
ret ptr %p4
L183:
%t1155 = call ptr @__m____________lib_bignum_resid__bn_mont_mul(ptr %p0, ptr %p4, ptr %p4)
%t1156 = call i64 @bn_bit(ptr %p2, i64 %p3)
%t1157 = icmp eq i64 %t1156, 1
br i1 %t1157, label %L184, label %L185
L184:
%t1158 = call ptr @__m____________lib_bignum_resid__bn_mont_mul(ptr %p0, ptr %t1155, ptr %p1)
%t1159 = call ptr @resid_list_freeze(ptr %t1158)
br label %L186
L185:
br label %L186
L186:
%t1160 = phi ptr [ %t1159, %L184 ], [ %t1155, %L185 ]
%t1161 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_modexp(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1163 = call i1 @bn_is_odd(ptr %p2)
br i1 %t1163, label %L187, label %L189
L187:
%t1164 = call ptr @bn_mont_new(ptr %p2)
%t1165 = call ptr @bn_mod(ptr %p0, ptr %p2)
%t1166 = musttail call ptr @bn_modexp_mont(ptr %t1164, ptr %t1165, ptr %p1)
ret ptr %t1166
L189:
%t1167 = call ptr @bn_mod(ptr %p0, ptr %p2)
%t1168 = call i64 @bn_bit_len(ptr %p1)
%t1169 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t1168, i64 1)
%t1170 = extractvalue {i64, i1} %t1169, 0
%t1171 = extractvalue {i64, i1} %t1169, 1
%t1172 = zext i1 %t1171 to i8
call void @resid_overflow_check(i8 %t1172)
%t1174 = call ptr @resid_list_const_i64(ptr @.lc1173, i64 1, ptr @.lcd1173, ptr @.lty1173)
%t1175 = call ptr @bn_mod(ptr %t1174, ptr %p2)
%t1176 = call ptr @__m____________lib_bignum_resid__bn_modexp_plain(ptr %t1167, ptr %p1, ptr %p2, i64 %t1170, ptr %t1175)
ret ptr %t1176
}
define ptr @__m____________lib_bignum_resid__bn_modexp_plain(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1179, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t1184, %tco.s0 ]
%t1177 = icmp slt i64 %p3, 0
br i1 %t1177, label %L190, label %L192
L190:
ret ptr %p4
L192:
%t1178 = call ptr @bn_modmul(ptr %p4, ptr %p4, ptr %p2)
%t1179 = sub nsw i64 %p3, 1
%t1180 = call i64 @bn_bit(ptr %p1, i64 %p3)
%t1181 = icmp eq i64 %t1180, 1
br i1 %t1181, label %L193, label %L194
L193:
%t1182 = call ptr @bn_modmul(ptr %t1178, ptr %p0, ptr %p2)
%t1183 = call ptr @resid_list_freeze(ptr %t1182)
br label %L195
L194:
br label %L195
L195:
%t1184 = phi ptr [ %t1183, %L193 ], [ %t1178, %L194 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @bn_miller_rabin(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1186 = call ptr @bn_mont_new(ptr %p0)
%t1188 = call ptr @resid_list_const_i64(ptr @.lc1187, i64 1, ptr @.lcd1187, ptr @.lty1187)
%t1189 = call ptr @bn_sub(ptr %p0, ptr %t1188)
%t1190 = call i64 @__m____________lib_bignum_resid__bn_trailing_zeros(ptr %t1189, i64 0)
%t1191 = call ptr @bn_shr(ptr %t1189, i64 %t1190)
%t1192 = call i1 @__m____________lib_bignum_resid__bn_mr_each(ptr %t1186, ptr %t1189, ptr %t1191, i64 %t1190, ptr %p1, i64 0)
ret i1 %t1192
}
define i64 @__m____________lib_bignum_resid__bn_trailing_zeros(ptr %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1200, %tco.s0 ]
%t1193 = call i64 @bn_bit(ptr %p0, i64 %p1)
%t1194 = icmp eq i64 %t1193, 1
br label %LSL1195
LSL1195:
br i1 %t1194, label %LSJ1195, label %LSR1195
LSR1195:
%t1196 = call i64 @bn_bit_len(ptr %p0)
%t1197 = icmp sgt i64 %p1, %t1196
br label %LSJ1195
LSJ1195:
%t1198 = phi i1 [ true, %LSL1195 ], [ %t1197, %LSR1195 ]
br i1 %t1198, label %L196, label %L198
L196:
ret i64 %p1
L198:
%t1199 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t1200 = extractvalue {i64, i1} %t1199, 0
%t1201 = extractvalue {i64, i1} %t1199, 1
%t1202 = zext i1 %t1201 to i8
call void @resid_overflow_check(i8 %t1202)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @__m____________lib_bignum_resid__bn_mr_each(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p4.ld = call ptr @resid_list_vdata(ptr %p4.in)
%p4.ln = call i64 @resid_list_vlen(ptr %p4.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0.k ]
%p4 = phi ptr [ %p4.in, %entry ], [ %p4, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t1211, %tco.s0.k ]
%t1204 = call i64 @resid_list_len(ptr %p4)
%t1205 = icmp sge i64 %p5, %t1204
br i1 %t1205, label %L199, label %L201
L199:
call void @resid_scope_pop(i64 %lml)
ret i1 true
L201:
%t1206 = call ptr @resid_list_get_v(ptr %p4, i64 %p5, ptr %p4.ld, i64 %p4.ln)
%t1209 = call i1 @__m____________lib_bignum_resid__bn_mr_witness(ptr %p0, ptr %p1, ptr %p2, i64 %p3, ptr %t1206)
%t1210 = xor i1 %t1209, true
br i1 %t1210, label %L202, label %L204
L202:
call void @resid_scope_pop(i64 %lml)
ret i1 false
L204:
%t1211 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
br label %tco.head
}
define i1 @__m____________lib_bignum_resid__bn_mr_witness(ptr %p0, ptr %p1, ptr %p2, i64 %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1213 = getelementptr i8, ptr %p0, i64 0
%t1214 = load ptr, ptr %t1213, align 8
%t1215 = call ptr @bn_mod(ptr %p4, ptr %t1214)
%t1216 = call ptr @bn_modexp_mont(ptr %p0, ptr %t1215, ptr %p2)
%t1218 = call ptr @resid_list_const_i64(ptr @.lc1217, i64 1, ptr @.lcd1217, ptr @.lty1217)
%t1219 = call i64 @bn_cmp(ptr %t1216, ptr %t1218)
%t1220 = icmp eq i64 %t1219, 0
br label %LSL1221
LSL1221:
br i1 %t1220, label %LSJ1221, label %LSR1221
LSR1221:
%t1222 = call i64 @bn_cmp(ptr %t1216, ptr %p1)
%t1223 = icmp eq i64 %t1222, 0
br label %LSJ1221
LSJ1221:
%t1224 = phi i1 [ true, %LSL1221 ], [ %t1223, %LSR1221 ]
br i1 %t1224, label %L205, label %L207
L205:
ret i1 true
L207:
%t1225 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p3, i64 1)
%t1226 = extractvalue {i64, i1} %t1225, 0
%t1227 = extractvalue {i64, i1} %t1225, 1
%t1228 = zext i1 %t1227 to i8
call void @resid_overflow_check(i8 %t1228)
%t1229 = call i1 @__m____________lib_bignum_resid__bn_mr_square(ptr %p0, ptr %p1, ptr %t1216, i64 %t1226)
ret i1 %t1229
}
define i1 @__m____________lib_bignum_resid__bn_mr_square(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t1233, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1240, %tco.s0 ]
%t1230 = icmp sle i64 %p3, 0
br i1 %t1230, label %L208, label %L210
L208:
ret i1 false
L210:
%t1231 = getelementptr i8, ptr %p0, i64 0
%t1232 = load ptr, ptr %t1231, align 8
%t1233 = call ptr @bn_modmul(ptr %p2, ptr %p2, ptr %t1232)
%t1234 = call i64 @bn_cmp(ptr %t1233, ptr %p1)
%t1235 = icmp eq i64 %t1234, 0
br i1 %t1235, label %L211, label %L213
L211:
ret i1 true
L213:
%t1237 = call ptr @resid_list_const_i64(ptr @.lc1236, i64 1, ptr @.lcd1236, ptr @.lty1236)
%t1238 = call i64 @bn_cmp(ptr %t1233, ptr %t1237)
%t1239 = icmp eq i64 %t1238, 0
br i1 %t1239, label %L214, label %L216
L214:
ret i1 false
L216:
%t1240 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_small_primes(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1242 = call ptr @resid_listbuf_new()
%t1243 = call ptr @__m____________lib_bignum_resid__bn_sp_from(i64 %p0, i64 3, ptr %t1242)
ret ptr %t1243
}
define ptr @__m____________lib_bignum_resid__bn_sp_from(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1253, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t1251, %tco.s0 ]
%t1244 = icmp sgt i64 %p1, %p0
br i1 %t1244, label %L217, label %L219
L217:
%t1245 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty1245)
ret ptr %t1245
L219:
%t1246 = call i1 @__m____________lib_bignum_resid__bn_sp_is_prime(i64 %p1, i64 3)
br i1 %t1246, label %L220, label %L221
L220:
%t1247 = call ptr @resid_box_i64(i64 %p1)
%t1250 = call ptr @resid_listbuf_push(ptr %p2, ptr %t1247)
br label %L222
L221:
br label %L222
L222:
%t1251 = phi ptr [ %t1250, %L220 ], [ %p2, %L221 ]
%t1252 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t1253 = extractvalue {i64, i1} %t1252, 0
%t1254 = extractvalue {i64, i1} %t1252, 1
%t1255 = zext i1 %t1254 to i8
call void @resid_overflow_check(i8 %t1255)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @__m____________lib_bignum_resid__bn_sp_is_prime(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1272, %tco.s0 ]
%t1257 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 %p1)
%t1258 = extractvalue {i64, i1} %t1257, 0
%t1259 = extractvalue {i64, i1} %t1257, 1
%t1260 = zext i1 %t1259 to i8
call void @resid_overflow_check(i8 %t1260)
%t1261 = icmp sgt i64 %t1258, %p0
br i1 %t1261, label %L223, label %L225
L223:
ret i1 true
L225:
%t1262 = icmp eq i64 %p1, 0
%t1263 = zext i1 %t1262 to i8
call void @resid_div_check(i8 %t1263)
%t1264 = icmp eq i64 %p1, -1
%t1265 = icmp eq i64 %p0, -9223372036854775808
%t1266 = and i1 %t1264, %t1265
%t1267 = select i1 %t1264, i64 1, i64 %p1
%t1268 = srem i64 %p0, %t1267
%t1270 = icmp eq i64 %t1268, 0
br i1 %t1270, label %L226, label %L228
L226:
ret i1 false
L228:
%t1271 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t1272 = extractvalue {i64, i1} %t1271, 0
%t1273 = extractvalue {i64, i1} %t1271, 1
%t1274 = zext i1 %t1273 to i8
call void @resid_overflow_check(i8 %t1274)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_bignum_resid__bn_safe_window() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 2048
}
define ptr @bn_safe_prime(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1276 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 1)
%t1277 = extractvalue {i64, i1} %t1276, 0
%t1278 = extractvalue {i64, i1} %t1276, 1
%t1279 = zext i1 %t1278 to i8
call void @resid_overflow_check(i8 %t1279)
%t1280 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t1277, i64 7)
%t1281 = extractvalue {i64, i1} %t1280, 0
%t1282 = extractvalue {i64, i1} %t1280, 1
%t1283 = zext i1 %t1282 to i8
call void @resid_overflow_check(i8 %t1283)
%t1284 = sdiv i64 %t1281, 8
%t1285 = call ptr @resid_listbuf_new()
%t1286 = call ptr @__m____________lib_bignum_resid__bn_take_int(ptr %p0, i64 %t1284, i64 0, ptr %t1285)
%t1287 = call ptr @bn_from_be(ptr %t1286)
%t1289 = call ptr @resid_list_const_i64(ptr @.lc1288, i64 1, ptr @.lcd1288, ptr @.lty1288)
%t1290 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 1)
%t1291 = extractvalue {i64, i1} %t1290, 0
%t1292 = extractvalue {i64, i1} %t1290, 1
%t1293 = zext i1 %t1292 to i8
call void @resid_overflow_check(i8 %t1293)
%t1294 = call ptr @bn_shl(ptr %t1289, i64 %t1291)
%t1296 = call ptr @resid_list_const_i64(ptr @.lc1295, i64 1, ptr @.lcd1295, ptr @.lty1295)
%t1297 = call ptr @bn_sub(ptr %t1294, ptr %t1296)
%t1298 = call ptr @bn_and(ptr %t1287, ptr %t1297)
%t1300 = call ptr @resid_list_const_i64(ptr @.lc1299, i64 1, ptr @.lcd1299, ptr @.lty1299)
%t1301 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 3)
%t1302 = extractvalue {i64, i1} %t1301, 0
%t1303 = extractvalue {i64, i1} %t1301, 1
%t1304 = zext i1 %t1303 to i8
call void @resid_overflow_check(i8 %t1304)
%t1305 = call ptr @bn_shl(ptr %t1300, i64 %t1302)
%t1306 = call ptr @resid_list_freeze(ptr %t1305)
%t1307 = call ptr @bn_or(ptr %t1298, ptr %t1306)
%t1308 = call ptr @resid_list_freeze(ptr %t1307)
%t1310 = call ptr @resid_list_const_i64(ptr @.lc1309, i64 1, ptr @.lcd1309, ptr @.lty1309)
%t1311 = call ptr @bn_or(ptr %t1308, ptr %t1310)
%t1312 = call ptr @resid_list_freeze(ptr %t1311)
%t1314 = call ptr @resid_list_const_i64(ptr @.lc1313, i64 302, ptr @.lcd1313, ptr @.lty1313)
%t1315 = call ptr @resid_listbuf_new()
%t1316 = call ptr @__m____________lib_bignum_resid__bn_residues(ptr %t1312, ptr %t1314, i64 0, ptr %t1315)
%t1318 = call ptr @resid_list_const_i64(ptr @.lc1317, i64 302, ptr @.lcd1317, ptr @.lty1317)
%t1319 = call ptr @__m____________lib_bignum_resid__bn_safe_search(ptr %t1312, ptr %t1318, ptr %t1316, i64 0)
ret ptr %t1319
}
define ptr @__m____________lib_bignum_resid__bn_take_int(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1322, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t1329, %tco.s0 ]
%t1320 = icmp sge i64 %p2, %p1
br i1 %t1320, label %L229, label %L231
L229:
%t1321 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty1321)
ret ptr %t1321
L231:
%t1322 = add nsw i64 %p2, 1
%t1323 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t1324 = call i64 @resid_unbox_i64(ptr %t1323)
%t1326 = call ptr @resid_box_i64(i64 %t1324)
%t1329 = call ptr @resid_listbuf_push(ptr %p3, ptr %t1326)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_bignum_resid__bn_residues(ptr %p0.in, ptr %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1344 = alloca [1 x ptr]
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1351, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t1368, %tco.s0 ]
%t1331 = call i64 @resid_list_len(ptr %p1)
%t1332 = icmp sge i64 %p2, %t1331
br i1 %t1332, label %L232, label %L234
L232:
%t1333 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty1333)
ret ptr %t1333
L234:
%t1334 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t1335 = call i64 @resid_unbox_i64(ptr %t1334)
%t1337 = add i64 %t1335, 0
%t1338 = add i64 %t1337, 0
%t1339 = add i64 %t1338, 0
%t1340 = icmp ne i64 %t1339, %t1337
%t1341 = icmp slt i64 %t1335, 0
%t1342 = or i1 %t1340, %t1341
%t1343 = zext i1 %t1342 to i8
call void @resid_conv_check(i8 %t1343)
%t1346 = call ptr @resid_box_i64(i64 %t1338)
%t1348 = getelementptr i8, ptr %t1344, i64 0
store ptr %t1346, ptr %t1348
%t1349 = call ptr @resid_list_new(i64 1, ptr %t1344, ptr @.lty1344)
%t1350 = call ptr @bn_mod(ptr %p0, ptr %t1349)
%t1351 = add nsw i64 %p2, 1
%t1352 = call i64 @resid_list_len(ptr %t1350)
%t1353 = icmp eq i64 %t1352, 0
br i1 %t1353, label %L235, label %L236
L235:
br label %L237
L236:
%t1354 = call ptr @resid_list_get(ptr %t1350, i64 0)
%t1355 = call i64 @resid_unbox_i64(ptr %t1354)
%t1357 = add i64 %t1355, 0
%t1358 = add i64 %t1357, 0
%t1359 = add i64 %t1358, 0
%t1360 = icmp ne i64 %t1359, %t1357
%t1361 = icmp slt i64 %t1358, 0
%t1362 = or i1 %t1360, %t1361
%t1363 = zext i1 %t1362 to i8
call void @resid_conv_check(i8 %t1363)
br label %L237
L237:
%t1364 = phi i64 [ 0, %L235 ], [ %t1358, %L236 ]
%t1365 = call ptr @resid_box_i64(i64 %t1364)
%t1368 = call ptr @resid_listbuf_push(ptr %p3, ptr %t1365)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @__m____________lib_bignum_resid__bn_sieve_ok(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1414, %tco.s0 ]
%t1370 = call i64 @resid_list_len(ptr %p0)
%t1371 = icmp sge i64 %p3, %t1370
br i1 %t1371, label %L238, label %L240
L238:
ret i1 true
L240:
%t1372 = call ptr @resid_list_get_v(ptr %p0, i64 %p3, ptr %p0.ld, i64 %p0.ln)
%t1373 = call i64 @resid_unbox_i64(ptr %t1372)
%t1375 = call ptr @resid_list_get_v(ptr %p1, i64 %p3, ptr %p1.ld, i64 %p1.ln)
%t1376 = call i64 @resid_unbox_i64(ptr %t1375)
%t1378 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p2)
%t1379 = extractvalue {i64, i1} %t1378, 0
%t1380 = extractvalue {i64, i1} %t1378, 1
%t1381 = zext i1 %t1380 to i8
call void @resid_overflow_check(i8 %t1381)
%t1382 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t1376, i64 %t1379)
%t1383 = extractvalue {i64, i1} %t1382, 0
%t1384 = extractvalue {i64, i1} %t1382, 1
%t1385 = zext i1 %t1384 to i8
call void @resid_overflow_check(i8 %t1385)
%t1386 = icmp eq i64 %t1373, 0
%t1387 = zext i1 %t1386 to i8
call void @resid_div_check(i8 %t1387)
%t1388 = icmp eq i64 %t1373, -1
%t1389 = icmp eq i64 %t1383, -9223372036854775808
%t1390 = and i1 %t1388, %t1389
%t1391 = select i1 %t1388, i64 1, i64 %t1373
%t1392 = srem i64 %t1383, %t1391
%t1394 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %t1392)
%t1395 = extractvalue {i64, i1} %t1394, 0
%t1396 = extractvalue {i64, i1} %t1394, 1
%t1397 = zext i1 %t1396 to i8
call void @resid_overflow_check(i8 %t1397)
%t1398 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t1395, i64 1)
%t1399 = extractvalue {i64, i1} %t1398, 0
%t1400 = extractvalue {i64, i1} %t1398, 1
%t1401 = zext i1 %t1400 to i8
call void @resid_overflow_check(i8 %t1401)
%t1402 = icmp eq i64 %t1373, 0
%t1403 = zext i1 %t1402 to i8
call void @resid_div_check(i8 %t1403)
%t1404 = icmp eq i64 %t1373, -1
%t1405 = icmp eq i64 %t1399, -9223372036854775808
%t1406 = and i1 %t1404, %t1405
%t1407 = select i1 %t1404, i64 1, i64 %t1373
%t1408 = srem i64 %t1399, %t1407
%t1410 = icmp eq i64 %t1392, 0
br label %LSL1411
LSL1411:
br i1 %t1410, label %LSJ1411, label %LSR1411
LSR1411:
%t1412 = icmp eq i64 %t1408, 0
br label %LSJ1411
LSJ1411:
%t1413 = phi i1 [ true, %LSL1411 ], [ %t1412, %LSR1411 ]
br i1 %t1413, label %L241, label %L243
L241:
ret i1 false
L243:
%t1414 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_mr_bases() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1417 = call ptr @resid_list_const_i64(ptr @.lc1416, i64 1, ptr @.lcd1416, ptr @.lty1416)
%t1419 = call ptr @resid_list_const_i64(ptr @.lc1418, i64 1, ptr @.lcd1418, ptr @.lty1418)
%t1421 = call ptr @resid_list_const_i64(ptr @.lc1420, i64 1, ptr @.lcd1420, ptr @.lty1420)
%t1423 = call ptr @resid_list_const_i64(ptr @.lc1422, i64 1, ptr @.lcd1422, ptr @.lty1422)
%t1425 = call ptr @resid_list_const_i64(ptr @.lc1424, i64 1, ptr @.lcd1424, ptr @.lty1424)
%t1427 = call ptr @resid_list_const_i64(ptr @.lc1426, i64 1, ptr @.lcd1426, ptr @.lty1426)
%t1429 = call ptr @resid_list_const_i64(ptr @.lc1428, i64 1, ptr @.lcd1428, ptr @.lty1428)
%t1431 = call ptr @resid_list_const_i64(ptr @.lc1430, i64 1, ptr @.lcd1430, ptr @.lty1430)
%t1433 = call ptr @resid_list_const_i64(ptr @.lc1432, i64 1, ptr @.lcd1432, ptr @.lty1432)
%t1435 = call ptr @resid_list_const_i64(ptr @.lc1434, i64 1, ptr @.lcd1434, ptr @.lty1434)
%t1437 = call ptr @resid_list_const_i64(ptr @.lc1436, i64 1, ptr @.lcd1436, ptr @.lty1436)
%t1439 = call ptr @resid_list_const_i64(ptr @.lc1438, i64 1, ptr @.lcd1438, ptr @.lty1438)
%t1440 = alloca [12 x ptr]
%t1444 = getelementptr i8, ptr %t1440, i64 0
store ptr %t1417, ptr %t1444
%t1447 = getelementptr i8, ptr %t1440, i64 8
store ptr %t1419, ptr %t1447
%t1450 = getelementptr i8, ptr %t1440, i64 16
store ptr %t1421, ptr %t1450
%t1453 = getelementptr i8, ptr %t1440, i64 24
store ptr %t1423, ptr %t1453
%t1456 = getelementptr i8, ptr %t1440, i64 32
store ptr %t1425, ptr %t1456
%t1459 = getelementptr i8, ptr %t1440, i64 40
store ptr %t1427, ptr %t1459
%t1462 = getelementptr i8, ptr %t1440, i64 48
store ptr %t1429, ptr %t1462
%t1465 = getelementptr i8, ptr %t1440, i64 56
store ptr %t1431, ptr %t1465
%t1468 = getelementptr i8, ptr %t1440, i64 64
store ptr %t1433, ptr %t1468
%t1471 = getelementptr i8, ptr %t1440, i64 72
store ptr %t1435, ptr %t1471
%t1474 = getelementptr i8, ptr %t1440, i64 80
store ptr %t1437, ptr %t1474
%t1477 = getelementptr i8, ptr %t1440, i64 88
store ptr %t1439, ptr %t1477
%t1478 = call ptr @resid_list_new(i64 12, ptr %t1440, ptr @.lty1440)
ret ptr %t1478
}
define ptr @__m____________lib_bignum_resid__bn_safe_search(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1493 = alloca [1 x ptr]
%t1509 = alloca [1 x ptr]
%t1519 = alloca [1 x ptr]
%t1528 = alloca [1 x ptr]
%t1534 = alloca [1 x ptr]
%t1540 = alloca [1 x ptr]
%t1546 = alloca [1 x ptr]
%t1552 = alloca [1 x ptr]
%t1558 = alloca [1 x ptr]
%t1564 = alloca [1 x ptr]
%t1570 = alloca [1 x ptr]
%t1576 = alloca [1 x ptr]
%t1582 = alloca [1 x ptr]
%t1588 = alloca [1 x ptr]
%t1594 = alloca [1 x ptr]
%t1600 = alloca [12 x ptr]
%t1642 = alloca [1 x ptr]
%t1648 = alloca [1 x ptr]
%t1654 = alloca [1 x ptr]
%t1660 = alloca [1 x ptr]
%t1666 = alloca [1 x ptr]
%t1672 = alloca [1 x ptr]
%t1678 = alloca [1 x ptr]
%t1684 = alloca [1 x ptr]
%t1690 = alloca [1 x ptr]
%t1696 = alloca [1 x ptr]
%t1702 = alloca [1 x ptr]
%t1708 = alloca [1 x ptr]
%t1714 = alloca [12 x ptr]
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1758, %tco.s0 ]
%t1479 = icmp sge i64 %p3, 2048
br i1 %t1479, label %L244, label %L246
L244:
ret ptr @.nbox1480
L246:
%t1481 = call i1 @__m____________lib_bignum_resid__bn_sieve_ok(ptr %p1, ptr %p2, i64 %p3, i64 0)
br i1 %t1481, label %L247, label %L249
L247:
%t1482 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p3)
%t1483 = extractvalue {i64, i1} %t1482, 0
%t1484 = extractvalue {i64, i1} %t1482, 1
%t1485 = zext i1 %t1484 to i8
call void @resid_overflow_check(i8 %t1485)
%t1486 = add i64 %t1483, 0
%t1487 = add i64 %t1486, 0
%t1488 = add i64 %t1487, 0
%t1489 = icmp ne i64 %t1488, %t1486
%t1490 = icmp slt i64 %t1483, 0
%t1491 = or i1 %t1489, %t1490
%t1492 = zext i1 %t1491 to i8
call void @resid_conv_check(i8 %t1492)
%t1495 = call ptr @resid_box_i64(i64 %t1487)
%t1497 = getelementptr i8, ptr %t1493, i64 0
store ptr %t1495, ptr %t1497
%t1498 = call ptr @resid_list_new(i64 1, ptr %t1493, ptr @.lty1493)
%t1499 = call ptr @bn_add(ptr %p0, ptr %t1498)
%t1500 = call ptr @resid_list_freeze(ptr %t1499)
%t1501 = call ptr @bn_shl(ptr %t1500, i64 1)
%t1502 = call ptr @resid_list_freeze(ptr %t1501)
%t1504 = call ptr @resid_list_const_i64(ptr @.lc1503, i64 1, ptr @.lcd1503, ptr @.lty1503)
%t1505 = call ptr @bn_add(ptr %t1502, ptr %t1504)
%t1506 = call ptr @resid_list_freeze(ptr %t1505)
%t1508 = call ptr @resid_list_const_i64(ptr @.lc1507, i64 1, ptr @.lcd1507, ptr @.lty1507)
%t1513 = getelementptr i8, ptr %t1509, i64 0
store ptr %t1508, ptr %t1513
%t1514 = call ptr @resid_list_new(i64 1, ptr %t1509, ptr @.lty1509)
%t1515 = call i1 @bn_miller_rabin(ptr %t1500, ptr %t1514)
br label %LSL1516
LSL1516:
br i1 %t1515, label %LSR1516, label %LSJ1516
LSR1516:
%t1518 = call ptr @resid_list_const_i64(ptr @.lc1517, i64 1, ptr @.lcd1517, ptr @.lty1517)
%t1523 = getelementptr i8, ptr %t1519, i64 0
store ptr %t1518, ptr %t1523
%t1524 = call ptr @resid_list_new(i64 1, ptr %t1519, ptr @.lty1519)
%t1525 = call i1 @bn_miller_rabin(ptr %t1506, ptr %t1524)
br label %LSJ1516
LSJ1516:
%t1526 = phi i1 [ false, %LSL1516 ], [ %t1525, %LSR1516 ]
br label %LSL1527
LSL1527:
br i1 %t1526, label %LSR1527, label %LSJ1527
LSR1527:
%t1530 = call ptr @resid_box_i64(i64 2)
%t1532 = getelementptr i8, ptr %t1528, i64 0
store ptr %t1530, ptr %t1532
%t1533 = call ptr @resid_list_new(i64 1, ptr %t1528, ptr @.lty1528)
%t1536 = call ptr @resid_box_i64(i64 3)
%t1538 = getelementptr i8, ptr %t1534, i64 0
store ptr %t1536, ptr %t1538
%t1539 = call ptr @resid_list_new(i64 1, ptr %t1534, ptr @.lty1534)
%t1542 = call ptr @resid_box_i64(i64 5)
%t1544 = getelementptr i8, ptr %t1540, i64 0
store ptr %t1542, ptr %t1544
%t1545 = call ptr @resid_list_new(i64 1, ptr %t1540, ptr @.lty1540)
%t1548 = call ptr @resid_box_i64(i64 7)
%t1550 = getelementptr i8, ptr %t1546, i64 0
store ptr %t1548, ptr %t1550
%t1551 = call ptr @resid_list_new(i64 1, ptr %t1546, ptr @.lty1546)
%t1554 = call ptr @resid_box_i64(i64 11)
%t1556 = getelementptr i8, ptr %t1552, i64 0
store ptr %t1554, ptr %t1556
%t1557 = call ptr @resid_list_new(i64 1, ptr %t1552, ptr @.lty1552)
%t1560 = call ptr @resid_box_i64(i64 13)
%t1562 = getelementptr i8, ptr %t1558, i64 0
store ptr %t1560, ptr %t1562
%t1563 = call ptr @resid_list_new(i64 1, ptr %t1558, ptr @.lty1558)
%t1566 = call ptr @resid_box_i64(i64 17)
%t1568 = getelementptr i8, ptr %t1564, i64 0
store ptr %t1566, ptr %t1568
%t1569 = call ptr @resid_list_new(i64 1, ptr %t1564, ptr @.lty1564)
%t1572 = call ptr @resid_box_i64(i64 19)
%t1574 = getelementptr i8, ptr %t1570, i64 0
store ptr %t1572, ptr %t1574
%t1575 = call ptr @resid_list_new(i64 1, ptr %t1570, ptr @.lty1570)
%t1578 = call ptr @resid_box_i64(i64 23)
%t1580 = getelementptr i8, ptr %t1576, i64 0
store ptr %t1578, ptr %t1580
%t1581 = call ptr @resid_list_new(i64 1, ptr %t1576, ptr @.lty1576)
%t1584 = call ptr @resid_box_i64(i64 29)
%t1586 = getelementptr i8, ptr %t1582, i64 0
store ptr %t1584, ptr %t1586
%t1587 = call ptr @resid_list_new(i64 1, ptr %t1582, ptr @.lty1582)
%t1590 = call ptr @resid_box_i64(i64 31)
%t1592 = getelementptr i8, ptr %t1588, i64 0
store ptr %t1590, ptr %t1592
%t1593 = call ptr @resid_list_new(i64 1, ptr %t1588, ptr @.lty1588)
%t1596 = call ptr @resid_box_i64(i64 37)
%t1598 = getelementptr i8, ptr %t1594, i64 0
store ptr %t1596, ptr %t1598
%t1599 = call ptr @resid_list_new(i64 1, ptr %t1594, ptr @.lty1594)
%t1604 = getelementptr i8, ptr %t1600, i64 0
store ptr %t1533, ptr %t1604
%t1607 = getelementptr i8, ptr %t1600, i64 8
store ptr %t1539, ptr %t1607
%t1610 = getelementptr i8, ptr %t1600, i64 16
store ptr %t1545, ptr %t1610
%t1613 = getelementptr i8, ptr %t1600, i64 24
store ptr %t1551, ptr %t1613
%t1616 = getelementptr i8, ptr %t1600, i64 32
store ptr %t1557, ptr %t1616
%t1619 = getelementptr i8, ptr %t1600, i64 40
store ptr %t1563, ptr %t1619
%t1622 = getelementptr i8, ptr %t1600, i64 48
store ptr %t1569, ptr %t1622
%t1625 = getelementptr i8, ptr %t1600, i64 56
store ptr %t1575, ptr %t1625
%t1628 = getelementptr i8, ptr %t1600, i64 64
store ptr %t1581, ptr %t1628
%t1631 = getelementptr i8, ptr %t1600, i64 72
store ptr %t1587, ptr %t1631
%t1634 = getelementptr i8, ptr %t1600, i64 80
store ptr %t1593, ptr %t1634
%t1637 = getelementptr i8, ptr %t1600, i64 88
store ptr %t1599, ptr %t1637
%t1638 = call ptr @resid_list_new(i64 12, ptr %t1600, ptr @.lty1600)
%t1639 = call i1 @bn_miller_rabin(ptr %t1500, ptr %t1638)
br label %LSJ1527
LSJ1527:
%t1640 = phi i1 [ false, %LSL1527 ], [ %t1639, %LSR1527 ]
br label %LSL1641
LSL1641:
br i1 %t1640, label %LSR1641, label %LSJ1641
LSR1641:
%t1644 = call ptr @resid_box_i64(i64 2)
%t1646 = getelementptr i8, ptr %t1642, i64 0
store ptr %t1644, ptr %t1646
%t1647 = call ptr @resid_list_new(i64 1, ptr %t1642, ptr @.lty1642)
%t1650 = call ptr @resid_box_i64(i64 3)
%t1652 = getelementptr i8, ptr %t1648, i64 0
store ptr %t1650, ptr %t1652
%t1653 = call ptr @resid_list_new(i64 1, ptr %t1648, ptr @.lty1648)
%t1656 = call ptr @resid_box_i64(i64 5)
%t1658 = getelementptr i8, ptr %t1654, i64 0
store ptr %t1656, ptr %t1658
%t1659 = call ptr @resid_list_new(i64 1, ptr %t1654, ptr @.lty1654)
%t1662 = call ptr @resid_box_i64(i64 7)
%t1664 = getelementptr i8, ptr %t1660, i64 0
store ptr %t1662, ptr %t1664
%t1665 = call ptr @resid_list_new(i64 1, ptr %t1660, ptr @.lty1660)
%t1668 = call ptr @resid_box_i64(i64 11)
%t1670 = getelementptr i8, ptr %t1666, i64 0
store ptr %t1668, ptr %t1670
%t1671 = call ptr @resid_list_new(i64 1, ptr %t1666, ptr @.lty1666)
%t1674 = call ptr @resid_box_i64(i64 13)
%t1676 = getelementptr i8, ptr %t1672, i64 0
store ptr %t1674, ptr %t1676
%t1677 = call ptr @resid_list_new(i64 1, ptr %t1672, ptr @.lty1672)
%t1680 = call ptr @resid_box_i64(i64 17)
%t1682 = getelementptr i8, ptr %t1678, i64 0
store ptr %t1680, ptr %t1682
%t1683 = call ptr @resid_list_new(i64 1, ptr %t1678, ptr @.lty1678)
%t1686 = call ptr @resid_box_i64(i64 19)
%t1688 = getelementptr i8, ptr %t1684, i64 0
store ptr %t1686, ptr %t1688
%t1689 = call ptr @resid_list_new(i64 1, ptr %t1684, ptr @.lty1684)
%t1692 = call ptr @resid_box_i64(i64 23)
%t1694 = getelementptr i8, ptr %t1690, i64 0
store ptr %t1692, ptr %t1694
%t1695 = call ptr @resid_list_new(i64 1, ptr %t1690, ptr @.lty1690)
%t1698 = call ptr @resid_box_i64(i64 29)
%t1700 = getelementptr i8, ptr %t1696, i64 0
store ptr %t1698, ptr %t1700
%t1701 = call ptr @resid_list_new(i64 1, ptr %t1696, ptr @.lty1696)
%t1704 = call ptr @resid_box_i64(i64 31)
%t1706 = getelementptr i8, ptr %t1702, i64 0
store ptr %t1704, ptr %t1706
%t1707 = call ptr @resid_list_new(i64 1, ptr %t1702, ptr @.lty1702)
%t1710 = call ptr @resid_box_i64(i64 37)
%t1712 = getelementptr i8, ptr %t1708, i64 0
store ptr %t1710, ptr %t1712
%t1713 = call ptr @resid_list_new(i64 1, ptr %t1708, ptr @.lty1708)
%t1718 = getelementptr i8, ptr %t1714, i64 0
store ptr %t1647, ptr %t1718
%t1721 = getelementptr i8, ptr %t1714, i64 8
store ptr %t1653, ptr %t1721
%t1724 = getelementptr i8, ptr %t1714, i64 16
store ptr %t1659, ptr %t1724
%t1727 = getelementptr i8, ptr %t1714, i64 24
store ptr %t1665, ptr %t1727
%t1730 = getelementptr i8, ptr %t1714, i64 32
store ptr %t1671, ptr %t1730
%t1733 = getelementptr i8, ptr %t1714, i64 40
store ptr %t1677, ptr %t1733
%t1736 = getelementptr i8, ptr %t1714, i64 48
store ptr %t1683, ptr %t1736
%t1739 = getelementptr i8, ptr %t1714, i64 56
store ptr %t1689, ptr %t1739
%t1742 = getelementptr i8, ptr %t1714, i64 64
store ptr %t1695, ptr %t1742
%t1745 = getelementptr i8, ptr %t1714, i64 72
store ptr %t1701, ptr %t1745
%t1748 = getelementptr i8, ptr %t1714, i64 80
store ptr %t1707, ptr %t1748
%t1751 = getelementptr i8, ptr %t1714, i64 88
store ptr %t1713, ptr %t1751
%t1752 = call ptr @resid_list_new(i64 12, ptr %t1714, ptr @.lty1714)
%t1753 = call i1 @bn_miller_rabin(ptr %t1506, ptr %t1752)
br label %LSJ1641
LSJ1641:
%t1754 = phi i1 [ false, %LSL1641 ], [ %t1753, %LSR1641 ]
br i1 %t1754, label %L250, label %L252
L250:
%t1757 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty1755)
%t1756 = getelementptr {i32, i32, ptr}, ptr %t1757, i32 1
store ptr %t1506, ptr %t1756
ret ptr %t1757
L252:
br label %L249
L249:
%t1758 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_and(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1760 = call i64 @resid_list_len(ptr %p0)
%t1761 = call i64 @resid_list_len(ptr %p1)
%t1762 = icmp slt i64 %t1760, %t1761
br i1 %t1762, label %L253, label %L254
L253:
%t1763 = call i64 @resid_list_len(ptr %p0)
br label %L255
L254:
%t1764 = call i64 @resid_list_len(ptr %p1)
br label %L255
L255:
%t1765 = phi i64 [ %t1763, %L253 ], [ %t1764, %L254 ]
%t1766 = call ptr @resid_listbuf_new()
%t1767 = call ptr @__m____________lib_bignum_resid__bn_and_at(ptr %p0, ptr %p1, i64 0, i64 %t1765, ptr %t1766)
%t1768 = call ptr @bn_trim(ptr %t1767)
ret ptr %t1768
}
define ptr @__m____________lib_bignum_resid__bn_and_at(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1771, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t1782, %tco.s0 ]
%t1769 = icmp sge i64 %p2, %p3
br i1 %t1769, label %L256, label %L258
L256:
%t1770 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty1770)
ret ptr %t1770
L258:
%t1771 = add nsw i64 %p2, 1
%t1772 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t1773 = call i64 @resid_unbox_i64(ptr %t1772)
%t1775 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t1776 = call i64 @resid_unbox_i64(ptr %t1775)
%t1778 = and i64 %t1773, %t1776
%t1779 = call ptr @resid_box_i64(i64 %t1778)
%t1782 = call ptr @resid_listbuf_push(ptr %p4, ptr %t1779)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_or(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1784 = call i64 @resid_list_len(ptr %p0)
%t1785 = call i64 @resid_list_len(ptr %p1)
%t1786 = icmp sgt i64 %t1784, %t1785
br i1 %t1786, label %L259, label %L260
L259:
%t1787 = call i64 @resid_list_len(ptr %p0)
br label %L261
L260:
%t1788 = call i64 @resid_list_len(ptr %p1)
br label %L261
L261:
%t1789 = phi i64 [ %t1787, %L259 ], [ %t1788, %L260 ]
%t1790 = call ptr @resid_listbuf_new()
%t1791 = call ptr @__m____________lib_bignum_resid__bn_or_at(ptr %p0, ptr %p1, i64 0, i64 %t1789, ptr %t1790)
ret ptr %t1791
}
define ptr @__m____________lib_bignum_resid__bn_or_at(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1794, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t1801, %tco.s0 ]
%t1792 = icmp sge i64 %p2, %p3
br i1 %t1792, label %L262, label %L264
L262:
%t1793 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty1793)
ret ptr %t1793
L264:
%t1794 = add nsw i64 %p2, 1
%t1795 = call i64 @__m____________lib_bignum_resid__bn_get(ptr %p0, i64 %p2)
%t1796 = call i64 @__m____________lib_bignum_resid__bn_get(ptr %p1, i64 %p2)
%t1797 = or i64 %t1795, %t1796
%t1798 = call ptr @resid_box_i64(i64 %t1797)
%t1801 = call ptr @resid_listbuf_push(ptr %p4, ptr %t1798)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_safe_prime_stream(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1803 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 1)
%t1804 = extractvalue {i64, i1} %t1803, 0
%t1805 = extractvalue {i64, i1} %t1803, 1
%t1806 = zext i1 %t1805 to i8
call void @resid_overflow_check(i8 %t1806)
%t1807 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t1804, i64 7)
%t1808 = extractvalue {i64, i1} %t1807, 0
%t1809 = extractvalue {i64, i1} %t1807, 1
%t1810 = zext i1 %t1809 to i8
call void @resid_overflow_check(i8 %t1810)
%t1811 = sdiv i64 %t1808, 8
%t1812 = call ptr @__m____________lib_bignum_resid__bn_sps_from(ptr %p0, i64 %p1, i64 %t1811, i64 0)
ret ptr %t1812
}
define ptr @__m____________lib_bignum_resid__bn_sps_from(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1813 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %p2)
%t1814 = extractvalue {i64, i1} %t1813, 0
%t1815 = extractvalue {i64, i1} %t1813, 1
%t1816 = zext i1 %t1815 to i8
call void @resid_overflow_check(i8 %t1816)
%t1817 = call i64 @resid_list_len(ptr %p0)
%t1818 = icmp sgt i64 %t1814, %t1817
br i1 %t1818, label %L265, label %L267
L265:
ret ptr @.nbox1819
L267:
%t1820 = call ptr @bn_slice_int(ptr %p0, i64 %p3, i64 %p2)
%t1821 = call ptr @resid_list_freeze(ptr %t1820)
%t1822 = call ptr @bn_safe_prime(ptr %t1821, i64 %p1)
%t1823 = getelementptr {i32, i32, ptr}, ptr %t1822, i32 0, i32 0
%t1824w = load i32, ptr %t1823
%t1824 = sext i32 %t1824w to i64
%t1825 = icmp eq i64 %t1824, 1
br i1 %t1825, label %L268, label %L269
L268:
%t1826 = getelementptr {i32, i32, ptr}, ptr %t1822, i32 1
%t1827 = getelementptr i8, ptr %t1826, i64 0
%t1828 = getelementptr ptr, ptr %t1827, i32 0
%t1829 = load ptr, ptr %t1828
%t1832 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty1830)
%t1831 = getelementptr {i32, i32, ptr}, ptr %t1832, i32 1
store ptr %t1829, ptr %t1831
br label %L270
L269:
%t1833 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %p2)
%t1834 = extractvalue {i64, i1} %t1833, 0
%t1835 = extractvalue {i64, i1} %t1833, 1
%t1836 = zext i1 %t1835 to i8
call void @resid_overflow_check(i8 %t1836)
%t1837 = call ptr @__m____________lib_bignum_resid__bn_sps_from(ptr %p0, i64 %p1, i64 %p2, i64 %t1834)
br label %L270
L270:
%t1838 = phi ptr [ %t1832, %L268 ], [ %t1837, %L269 ]
ret ptr %t1838
}
define ptr @bn_slice_int(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1839 = call ptr @resid_listbuf_new()
%t1840 = call ptr @__m____________lib_bignum_resid__bn_slice_at(ptr %p0, i64 %p1, i64 %p2, i64 0, ptr %t1839)
ret ptr %t1840
}
define ptr @__m____________lib_bignum_resid__bn_slice_at(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1843, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t1854, %tco.s0 ]
%t1841 = icmp sge i64 %p3, %p2
br i1 %t1841, label %L271, label %L273
L271:
%t1842 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty1842)
ret ptr %t1842
L273:
%t1843 = add nsw i64 %p3, 1
%t1844 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p3)
%t1845 = extractvalue {i64, i1} %t1844, 0
%t1846 = extractvalue {i64, i1} %t1844, 1
%t1847 = zext i1 %t1846 to i8
call void @resid_overflow_check(i8 %t1847)
%t1848 = call ptr @resid_list_get_v(ptr %p0, i64 %t1845, ptr %p0.ld, i64 %p0.ln)
%t1849 = call i64 @resid_unbox_i64(ptr %t1848)
%t1851 = call ptr @resid_box_i64(i64 %t1849)
%t1854 = call ptr @resid_listbuf_push(ptr %p4, ptr %t1851)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @bn_jacobi(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1856 = call ptr @bn_mod(ptr %p0, ptr %p1)
%t1857 = call i64 @__m____________lib_bignum_resid__bn_jac(ptr %t1856, ptr %p1, i64 1)
ret i64 %t1857
}
define i64 @__m____________lib_bignum_resid__bn_jac(ptr %p0.in, ptr %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %t1880, %tco.s0 ], [ %t1899, %tco.s1 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p0, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1879, %tco.s0 ], [ %t1898, %tco.s1 ]
%t1858 = call i64 @resid_list_len(ptr %p0)
%t1859 = icmp eq i64 %t1858, 0
br i1 %t1859, label %L274, label %L276
L274:
%t1861 = call ptr @resid_list_const_i64(ptr @.lc1860, i64 1, ptr @.lcd1860, ptr @.lty1860)
%t1862 = call i64 @bn_cmp(ptr %p1, ptr %t1861)
%t1863 = icmp eq i64 %t1862, 0
br i1 %t1863, label %L277, label %L278
L277:
br label %L279
L278:
br label %L279
L279:
%t1864 = phi i64 [ %p2, %L277 ], [ 0, %L278 ]
ret i64 %t1864
L276:
%t1865 = call i1 @bn_is_odd(ptr %p0)
%t1866 = xor i1 %t1865, true
br i1 %t1866, label %L280, label %L282
L280:
%t1867 = call ptr @resid_list_get(ptr %p1, i64 0)
%t1868 = call i64 @resid_unbox_i64(ptr %t1867)
%t1870 = and i64 %t1868, 7
%t1871 = icmp eq i64 %t1870, 3
br label %LSL1872
LSL1872:
br i1 %t1871, label %LSJ1872, label %LSR1872
LSR1872:
%t1873 = icmp eq i64 %t1870, 5
br label %LSJ1872
LSJ1872:
%t1874 = phi i1 [ true, %LSL1872 ], [ %t1873, %LSR1872 ]
br i1 %t1874, label %L283, label %L284
L283:
%t1875 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p2)
%t1876 = extractvalue {i64, i1} %t1875, 0
%t1877 = extractvalue {i64, i1} %t1875, 1
%t1878 = zext i1 %t1877 to i8
call void @resid_overflow_check(i8 %t1878)
br label %L285
L284:
br label %L285
L285:
%t1879 = phi i64 [ %t1876, %L283 ], [ %p2, %L284 ]
%t1880 = call ptr @bn_shr(ptr %p0, i64 1)
br label %tco.s0
tco.s0:
br label %tco.head
L282:
%t1882 = call ptr @resid_list_get(ptr %p0, i64 0)
%t1883 = call i64 @resid_unbox_i64(ptr %t1882)
%t1885 = and i64 %t1883, 3
%t1886 = icmp eq i64 %t1885, 3
br label %LSL1887
LSL1887:
br i1 %t1886, label %LSR1887, label %LSJ1887
LSR1887:
%t1888 = call ptr @resid_list_get(ptr %p1, i64 0)
%t1889 = call i64 @resid_unbox_i64(ptr %t1888)
%t1891 = and i64 %t1889, 3
%t1892 = icmp eq i64 %t1891, 3
br label %LSJ1887
LSJ1887:
%t1893 = phi i1 [ false, %LSL1887 ], [ %t1892, %LSR1887 ]
br i1 %t1893, label %L286, label %L287
L286:
%t1894 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p2)
%t1895 = extractvalue {i64, i1} %t1894, 0
%t1896 = extractvalue {i64, i1} %t1894, 1
%t1897 = zext i1 %t1896 to i8
call void @resid_overflow_check(i8 %t1897)
br label %L288
L287:
br label %L288
L288:
%t1898 = phi i64 [ %t1895, %L286 ], [ %p2, %L287 ]
%t1899 = call ptr @bn_mod(ptr %p1, ptr %p0)
br label %tco.s1
tco.s1:
br label %tco.head
}
define i64 @__m____________lib_word_resid__wi_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1901 = xor i64 %p0, %p1
ret i64 %t1901
}
define i64 @__m____________lib_word_resid__wi_and(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1902 = and i64 %p0, %p1
ret i64 %t1902
}
define i64 @__m____________lib_word_resid__wi_or(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1903 = or i64 %p0, %p1
ret i64 %t1903
}
define i64 @__m____________lib_word_resid__wi_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1904 = call i64 @wrapping_add(i64 %p0, i64 %p1)
%t1905 = and i64 %t1904, 4294967295
ret i64 %t1905
}
define i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1906 = call i64 @wrapping_add(i64 %p0, i64 %p1)
%t1907 = and i64 %t1906, 4294967295
ret i64 %t1907
}
define i64 @__m____________lib_word_resid__wi_xork(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1908 = xor i64 %p0, %p1
ret i64 %t1908
}
define i64 @__m____________lib_word_resid__wi_andk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1909 = and i64 %p0, %p1
ret i64 %t1909
}
define i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1910 = icmp uge i64 %p1, 64
%t1911 = add i64 %p1, 0
%t1912 = select i1 %t1910, i64 63, i64 %t1911
%t1913 = ashr i64 %p0, %t1912
%t1914 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t1915 = extractvalue {i64, i1} %t1914, 0
%t1916 = extractvalue {i64, i1} %t1914, 1
%t1917 = zext i1 %t1916 to i8
call void @resid_overflow_check(i8 %t1917)
%t1918 = icmp uge i64 %t1915, 64
%t1919 = add i64 %t1915, 0
%t1920 = shl i64 %p0, %t1919
%t1921 = select i1 %t1918, i64 0, i64 %t1920
%t1922 = or i64 %t1913, %t1921
%t1923 = and i64 %t1922, 4294967295
ret i64 %t1923
}
define i64 @__m____________lib_word_resid__wi_shr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1924 = icmp uge i64 %p1, 64
%t1925 = add i64 %p1, 0
%t1926 = select i1 %t1924, i64 63, i64 %t1925
%t1927 = ashr i64 %p0, %t1926
ret i64 %t1927
}
define i64 @__m____________lib_word_resid__wi_shl(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1928 = icmp uge i64 %p1, 64
%t1929 = add i64 %p1, 0
%t1930 = shl i64 %p0, %t1929
%t1931 = select i1 %t1928, i64 0, i64 %t1930
%t1932 = and i64 %t1931, 4294967295
ret i64 %t1932
}
define i64 @__m____________lib_word_resid__wi_not(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1933 = xor i64 %p0, 4294967295
%t1934 = and i64 %t1933, 4294967295
ret i64 %t1934
}
define i64 @__m____________lib_word_resid__wi_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i64 @__m____________lib_word_resid__wi_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1935 = and i64 %p0, 255
ret i64 %t1935
}
define i64 @__m____________lib_word_resid__wi_byte(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1936 = icmp uge i64 %p1, 64
%t1937 = add i64 %p1, 0
%t1938 = select i1 %t1936, i64 63, i64 %t1937
%t1939 = ashr i64 %p0, %t1938
%t1940 = and i64 %t1939, 255
ret i64 %t1940
}
define i64 @__m____________lib_word_resid__bi_xork(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1941 = xor i64 %p0, %p1
ret i64 %t1941
}
define i64 @__m____________lib_word_resid__bi_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1942 = xor i64 %p0, %p1
ret i64 %t1942
}
define i64 @__m____________lib_word_resid__bi_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i32 @__m____________lib_word_resid__ws_xor(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1943 = xor i32 %p0, %p1
ret i32 %t1943
}
define i32 @__m____________lib_word_resid__ws_and(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1944 = and i32 %p0, %p1
ret i32 %t1944
}
define i32 @__m____________lib_word_resid__ws_or(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1945 = or i32 %p0, %p1
ret i32 %t1945
}
define i32 @__m____________lib_word_resid__ws_add(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1946 = add i32 %p0, %p1
ret i32 %t1946
}
define i32 @__m____________lib_word_resid__ws_addk(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1947 = trunc i64 %p1 to i32
%t1948 = add i32 %p0, %t1947
ret i32 %t1948
}
define i32 @__m____________lib_word_resid__ws_xork(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1949 = trunc i64 %p1 to i32
%t1950 = xor i32 %p0, %t1949
ret i32 %t1950
}
define i32 @__m____________lib_word_resid__ws_andk(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1951 = trunc i64 %p1 to i32
%t1952 = and i32 %p0, %t1951
ret i32 %t1952
}
define i32 @__m____________lib_word_resid__ws_rotr(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1953 = trunc i64 %p1 to i32
%t1954 = icmp uge i32 %t1953, 32
%t1955 = add i32 %t1953, 0
%t1956 = lshr i32 %p0, %t1955
%t1957 = select i1 %t1954, i32 0, i32 %t1956
%t1958 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t1959 = extractvalue {i64, i1} %t1958, 0
%t1960 = extractvalue {i64, i1} %t1958, 1
%t1961 = zext i1 %t1960 to i8
call void @resid_overflow_check(i8 %t1961)
%t1962 = trunc i64 %t1959 to i32
%t1963 = icmp uge i32 %t1962, 32
%t1964 = add i32 %t1962, 0
%t1965 = shl i32 %p0, %t1964
%t1966 = select i1 %t1963, i32 0, i32 %t1965
%t1967 = or i32 %t1957, %t1966
ret i32 %t1967
}
define i32 @__m____________lib_word_resid__ws_shr(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1968 = trunc i64 %p1 to i32
%t1969 = icmp uge i32 %t1968, 32
%t1970 = add i32 %t1968, 0
%t1971 = lshr i32 %p0, %t1970
%t1972 = select i1 %t1969, i32 0, i32 %t1971
ret i32 %t1972
}
define i32 @__m____________lib_word_resid__ws_shl(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1973 = trunc i64 %p1 to i32
%t1974 = icmp uge i32 %t1973, 32
%t1975 = add i32 %t1973, 0
%t1976 = shl i32 %p0, %t1975
%t1977 = select i1 %t1974, i32 0, i32 %t1976
ret i32 %t1977
}
define i32 @__m____________lib_word_resid__ws_not(i32 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1978 = xor i32 %p0, 4294967295
ret i32 %t1978
}
define i32 @__m____________lib_word_resid__ws_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1979 = trunc i64 %p0 to i32
ret i32 %t1979
}
define i32 @__m____________lib_word_resid__ws_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1980 = zext i8 %p0 to i32
ret i32 %t1980
}
define i8 @__m____________lib_word_resid__ws_byte(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1981 = trunc i64 %p1 to i32
%t1982 = icmp uge i32 %t1981, 32
%t1983 = add i32 %t1981, 0
%t1984 = lshr i32 %p0, %t1983
%t1985 = select i1 %t1982, i32 0, i32 %t1984
%t1986 = trunc i32 %t1985 to i8
ret i8 %t1986
}
define i8 @__m____________lib_word_resid__bs_xork(i8 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1987 = trunc i64 %p1 to i8
%t1988 = xor i8 %p0, %t1987
ret i8 %t1988
}
define i8 @__m____________lib_word_resid__bs_xor(i8 %p0, i8 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1989 = xor i8 %p0, %p1
ret i8 %t1989
}
define i8 @__m____________lib_word_resid__bs_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1990 = trunc i64 %p0 to i8
ret i8 %t1990
}
define ptr @secret_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1991 = call ptr @resid_listbuf_new()
%t1992 = call ptr @__m____________lib_word_resid__secret_bytes_at(ptr %p0, i64 0, ptr %t1991)
ret ptr %t1992
}
define ptr @__m____________lib_word_resid__secret_bytes_at(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1996, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t2004, %tco.s0 ]
%t1993 = call i64 @resid_list_len(ptr %p0)
%t1994 = icmp sge i64 %p1, %t1993
br i1 %t1994, label %L289, label %L291
L289:
%t1995 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty1995)
ret ptr %t1995
L291:
%t1996 = add nsw i64 %p1, 1
%t1997 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t1998 = call i64 @resid_unbox_i64(ptr %t1997)
%t2000 = trunc i64 %t1998 to i8
%t2002 = zext i8 %t2000 to i64
%t2001 = call ptr @resid_box_i64(i64 %t2002)
%t2004 = call ptr @resid_listbuf_push(ptr %p2, ptr %t2001)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_word_resid__di_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2006 = xor i64 %p0, %p1
ret i64 %t2006
}
define i64 @__m____________lib_word_resid__di_and(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2007 = and i64 %p0, %p1
ret i64 %t2007
}
define i64 @__m____________lib_word_resid__di_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2008 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2008
}
define i64 @__m____________lib_word_resid__di_addk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2009 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2009
}
define i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2010 = add i64 %p1, 0
%t2011 = add i64 %t2010, 0
%t2012 = add i64 %t2011, 0
%t2013 = icmp ne i64 %t2012, %t2010
%t2014 = icmp slt i64 %p1, 0
%t2015 = or i1 %t2013, %t2014
%t2016 = zext i1 %t2015 to i8
call void @resid_conv_check(i8 %t2016)
%t2017 = icmp uge i64 %t2011, 64
%t2018 = add i64 %t2011, 0
%t2019 = lshr i64 %p0, %t2018
%t2020 = select i1 %t2017, i64 0, i64 %t2019
%t2021 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 64, i64 %p1)
%t2022 = extractvalue {i64, i1} %t2021, 0
%t2023 = extractvalue {i64, i1} %t2021, 1
%t2024 = zext i1 %t2023 to i8
call void @resid_overflow_check(i8 %t2024)
%t2025 = add i64 %t2022, 0
%t2026 = add i64 %t2025, 0
%t2027 = add i64 %t2026, 0
%t2028 = icmp ne i64 %t2027, %t2025
%t2029 = icmp slt i64 %t2022, 0
%t2030 = or i1 %t2028, %t2029
%t2031 = zext i1 %t2030 to i8
call void @resid_conv_check(i8 %t2031)
%t2032 = icmp uge i64 %t2026, 64
%t2033 = add i64 %t2026, 0
%t2034 = shl i64 %p0, %t2033
%t2035 = select i1 %t2032, i64 0, i64 %t2034
%t2036 = or i64 %t2020, %t2035
ret i64 %t2036
}
define i64 @__m____________lib_word_resid__di_shr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2037 = add i64 %p1, 0
%t2038 = add i64 %t2037, 0
%t2039 = add i64 %t2038, 0
%t2040 = icmp ne i64 %t2039, %t2037
%t2041 = icmp slt i64 %p1, 0
%t2042 = or i1 %t2040, %t2041
%t2043 = zext i1 %t2042 to i8
call void @resid_conv_check(i8 %t2043)
%t2044 = icmp uge i64 %t2038, 64
%t2045 = add i64 %t2038, 0
%t2046 = lshr i64 %p0, %t2045
%t2047 = select i1 %t2044, i64 0, i64 %t2046
ret i64 %t2047
}
define i64 @__m____________lib_word_resid__di_not(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2048 = add i128 18446744073709551615, 0
%t2049 = trunc i128 %t2048 to i64
%t2050 = zext i64 %t2049 to i128
%t2051 = icmp ne i128 %t2050, %t2048
%t2052 = icmp slt i128 18446744073709551615, 0
%t2053 = or i1 %t2051, %t2052
%t2054 = zext i1 %t2053 to i8
call void @resid_conv_check(i8 %t2054)
%t2055 = xor i64 %p0, %t2049
ret i64 %t2055
}
define i64 @__m____________lib_word_resid__di_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i64 @__m____________lib_word_resid__di_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2056 = and i64 %p0, 255
ret i64 %t2056
}
define i64 @__m____________lib_word_resid__di_byte(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2057 = add i64 %p1, 0
%t2058 = add i64 %t2057, 0
%t2059 = add i64 %t2058, 0
%t2060 = icmp ne i64 %t2059, %t2057
%t2061 = icmp slt i64 %p1, 0
%t2062 = or i1 %t2060, %t2061
%t2063 = zext i1 %t2062 to i8
call void @resid_conv_check(i8 %t2063)
%t2064 = icmp uge i64 %t2058, 64
%t2065 = add i64 %t2058, 0
%t2066 = lshr i64 %p0, %t2065
%t2067 = select i1 %t2064, i64 0, i64 %t2066
%t2068 = and i64 %t2067, 255
ret i64 %t2068
}
define i64 @__m____________lib_word_resid__ds_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2069 = xor i64 %p0, %p1
ret i64 %t2069
}
define i64 @__m____________lib_word_resid__ds_and(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2070 = and i64 %p0, %p1
ret i64 %t2070
}
define i64 @__m____________lib_word_resid__ds_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2071 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2071
}
define i64 @__m____________lib_word_resid__ds_addk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2072 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2072
}
define i64 @__m____________lib_word_resid__ds_rotr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2073 = add i64 %p1, 0
%t2074 = add i64 %t2073, 0
%t2075 = add i64 %t2074, 0
%t2076 = icmp ne i64 %t2075, %t2073
%t2077 = icmp slt i64 %p1, 0
%t2078 = or i1 %t2076, %t2077
%t2079 = zext i1 %t2078 to i8
call void @resid_conv_check(i8 %t2079)
%t2080 = icmp uge i64 %t2074, 64
%t2081 = add i64 %t2074, 0
%t2082 = lshr i64 %p0, %t2081
%t2083 = select i1 %t2080, i64 0, i64 %t2082
%t2084 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 64, i64 %p1)
%t2085 = extractvalue {i64, i1} %t2084, 0
%t2086 = extractvalue {i64, i1} %t2084, 1
%t2087 = zext i1 %t2086 to i8
call void @resid_overflow_check(i8 %t2087)
%t2088 = add i64 %t2085, 0
%t2089 = add i64 %t2088, 0
%t2090 = add i64 %t2089, 0
%t2091 = icmp ne i64 %t2090, %t2088
%t2092 = icmp slt i64 %t2085, 0
%t2093 = or i1 %t2091, %t2092
%t2094 = zext i1 %t2093 to i8
call void @resid_conv_check(i8 %t2094)
%t2095 = icmp uge i64 %t2089, 64
%t2096 = add i64 %t2089, 0
%t2097 = shl i64 %p0, %t2096
%t2098 = select i1 %t2095, i64 0, i64 %t2097
%t2099 = or i64 %t2083, %t2098
ret i64 %t2099
}
define i64 @__m____________lib_word_resid__ds_shr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2100 = add i64 %p1, 0
%t2101 = add i64 %t2100, 0
%t2102 = add i64 %t2101, 0
%t2103 = icmp ne i64 %t2102, %t2100
%t2104 = icmp slt i64 %p1, 0
%t2105 = or i1 %t2103, %t2104
%t2106 = zext i1 %t2105 to i8
call void @resid_conv_check(i8 %t2106)
%t2107 = icmp uge i64 %t2101, 64
%t2108 = add i64 %t2101, 0
%t2109 = lshr i64 %p0, %t2108
%t2110 = select i1 %t2107, i64 0, i64 %t2109
ret i64 %t2110
}
define i64 @__m____________lib_word_resid__ds_not(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2111 = add i128 18446744073709551615, 0
%t2112 = trunc i128 %t2111 to i64
%t2113 = zext i64 %t2112 to i128
%t2114 = icmp ne i128 %t2113, %t2111
%t2115 = icmp slt i128 18446744073709551615, 0
%t2116 = or i1 %t2114, %t2115
%t2117 = zext i1 %t2116 to i8
call void @resid_conv_check(i8 %t2117)
%t2118 = xor i64 %p0, %t2112
ret i64 %t2118
}
define i64 @__m____________lib_word_resid__ds_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i64 @__m____________lib_word_resid__ds_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2119 = zext i8 %p0 to i64
ret i64 %t2119
}
define i8 @__m____________lib_word_resid__ds_byte(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2120 = add i64 %p1, 0
%t2121 = add i64 %t2120, 0
%t2122 = add i64 %t2121, 0
%t2123 = icmp ne i64 %t2122, %t2120
%t2124 = icmp slt i64 %p1, 0
%t2125 = or i1 %t2123, %t2124
%t2126 = zext i1 %t2125 to i8
call void @resid_conv_check(i8 %t2126)
%t2127 = icmp uge i64 %t2121, 64
%t2128 = add i64 %t2121, 0
%t2129 = lshr i64 %p0, %t2128
%t2130 = select i1 %t2127, i64 0, i64 %t2129
%t2131 = trunc i64 %t2130 to i8
ret i8 %t2131
}
define i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2132 = add i512 %p0, %p1
ret i512 %t2132
}
define i512 @__m____________lib_word_resid__pi_sub(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2133 = sub i512 %p0, %p1
ret i512 %t2133
}
define i512 @__m____________lib_word_resid__pi_mul(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2134 = mul i512 %p0, %p1
ret i512 %t2134
}
define i512 @__m____________lib_word_resid__pi_mul256(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2135 = trunc i512 %p0 to i256
%t2136 = zext i256 %t2135 to i512
%t2137 = trunc i512 %p1 to i256
%t2138 = zext i256 %t2137 to i512
%t2139 = mul i512 %t2136, %t2138
ret i512 %t2139
}
define i512 @__m____________lib_word_resid__pi_and(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2140 = and i512 %p0, %p1
ret i512 %t2140
}
define i512 @__m____________lib_word_resid__pi_or(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2141 = or i512 %p0, %p1
ret i512 %t2141
}
define i512 @__m____________lib_word_resid__pi_xor(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2142 = xor i512 %p0, %p1
ret i512 %t2142
}
define i512 @__m____________lib_word_resid__pi_shl(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2143 = sext i64 %p1 to i512
%t2144 = icmp uge i512 %t2143, 512
%t2145 = add i512 %t2143, 0
%t2146 = shl i512 %p0, %t2145
%t2147 = select i1 %t2144, i512 0, i512 %t2146
ret i512 %t2147
}
define i512 @__m____________lib_word_resid__pi_shr(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2148 = sext i64 %p1 to i512
%t2149 = icmp uge i512 %t2148, 512
%t2150 = add i512 %t2148, 0
%t2151 = select i1 %t2149, i512 511, i512 %t2150
%t2152 = ashr i512 %p0, %t2151
ret i512 %t2152
}
define i512 @__m____________lib_word_resid__pi_sign(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2153 = ashr i512 %p0, 511
%t2154 = trunc i512 %t2153 to i64
%t2155 = call i64 asm "", "=r,0"(i64 %t2154)
%t2156 = sext i64 %t2155 to i512
ret i512 %t2156
}
define i512 @__m____________lib_word_resid__pi_lift(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i512 %p0
}
define i512 @__m____________lib_word_resid__pi_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2157 = and i64 %p0, 255
%t2158 = sext i64 %t2157 to i512
ret i512 %t2158
}
define i64 @__m____________lib_word_resid__pi_byte(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2159 = sext i64 %p1 to i512
%t2160 = icmp uge i512 %t2159, 512
%t2161 = add i512 %t2159, 0
%t2162 = select i1 %t2160, i512 511, i512 %t2161
%t2163 = ashr i512 %p0, %t2162
%t2164 = and i512 %t2163, 255
%t2165 = trunc i512 %t2164 to i64
ret i64 %t2165
}
define i512 @__m____________lib_word_resid__ps_add(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2166 = add i512 %p0, %p1
ret i512 %t2166
}
define i512 @__m____________lib_word_resid__ps_sub(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2167 = sub i512 %p0, %p1
ret i512 %t2167
}
define i512 @__m____________lib_word_resid__ps_mul(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2168 = mul i512 %p0, %p1
ret i512 %t2168
}
define i512 @__m____________lib_word_resid__ps_mul256(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2169 = trunc i512 %p0 to i256
%t2170 = zext i256 %t2169 to i512
%t2171 = trunc i512 %p1 to i256
%t2172 = zext i256 %t2171 to i512
%t2173 = mul i512 %t2170, %t2172
ret i512 %t2173
}
define i512 @__m____________lib_word_resid__ps_and(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2174 = and i512 %p0, %p1
ret i512 %t2174
}
define i512 @__m____________lib_word_resid__ps_or(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2175 = or i512 %p0, %p1
ret i512 %t2175
}
define i512 @__m____________lib_word_resid__ps_xor(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2176 = xor i512 %p0, %p1
ret i512 %t2176
}
define i512 @__m____________lib_word_resid__ps_shl(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2177 = sext i64 %p1 to i512
%t2178 = icmp uge i512 %t2177, 512
%t2179 = add i512 %t2177, 0
%t2180 = shl i512 %p0, %t2179
%t2181 = select i1 %t2178, i512 0, i512 %t2180
ret i512 %t2181
}
define i512 @__m____________lib_word_resid__ps_shr(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2182 = sext i64 %p1 to i512
%t2183 = icmp uge i512 %t2182, 512
%t2184 = add i512 %t2182, 0
%t2185 = select i1 %t2183, i512 511, i512 %t2184
%t2186 = ashr i512 %p0, %t2185
ret i512 %t2186
}
define i512 @__m____________lib_word_resid__ps_sign(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2187 = ashr i512 %p0, 511
%t2188 = trunc i512 %t2187 to i64
%t2189 = call i64 asm "", "=r,0"(i64 %t2188)
%t2190 = sext i64 %t2189 to i512
ret i512 %t2190
}
define i512 @__m____________lib_word_resid__ps_lift(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i512 %p0
}
define i512 @__m____________lib_word_resid__ps_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2191 = zext i8 %p0 to i512
ret i512 %t2191
}
define i8 @__m____________lib_word_resid__ps_byte(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2192 = sext i64 %p1 to i512
%t2193 = icmp uge i512 %t2192, 512
%t2194 = add i512 %t2192, 0
%t2195 = select i1 %t2193, i512 511, i512 %t2194
%t2196 = ashr i512 %p0, %t2195
%t2197 = trunc i512 %t2196 to i8
ret i8 %t2197
}
define ptr @__m____________lib_word_resid__wi_publish(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret ptr %p0
}
define ptr @__m____________lib_word_resid__ws_publish(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
call void @resid_cap_check(ptr @.declassify.cap)
%t2198 = call ptr @resid_listbuf_new()
%t2199 = call ptr @__m____________lib_word_resid__ws_widen(ptr %p0, i64 0, ptr %t2198)
ret ptr %t2199
}
define ptr @__m____________lib_word_resid__ws_widen(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2207 = alloca [17 x i8], align 16 ; fixed
%t2208 = alloca [48 x i8], align 16 ; fixed
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2203, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t2221, %tco.s0 ]
%t2200 = call i64 @resid_list_len(ptr %p0)
%t2201 = icmp sge i64 %p1, %t2200
br i1 %t2201, label %L292, label %L294
L292:
%t2202 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty2202)
ret ptr %t2202
L294:
%t2203 = add nsw i64 %p1, 1
%t2204 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t2206 = call i64 @resid_unbox_i64(ptr %t2204)
%t2205 = trunc i64 %t2206 to i8
store i8 %t2205, ptr %t2207
%t2209 = ptrtoint ptr %t2207 to i64
store i64 1296236546, ptr %t2208
%t2210 = getelementptr i64, ptr %t2208, i64 1
store i64 %t2209, ptr %t2210
%t2211 = getelementptr i64, ptr %t2208, i64 2
store i64 1, ptr %t2211
%t2212 = getelementptr i64, ptr %t2208, i64 3
store i64 0, ptr %t2212
%t2213 = getelementptr i64, ptr %t2208, i64 4
store i64 0, ptr %t2213
%t2214 = getelementptr i64, ptr %t2208, i64 5
store i64 0, ptr %t2214
%t2215 = call i64 asm sideeffect "rolq $$3, %rdi ; rolq $$13, %rdi ; rolq $$61, %rdi ; rolq $$51, %rdi ; xchgq %rbx, %rbx", "={dx},{ax},0,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(ptr %t2208, i64 0)
%t2216 = load i8, ptr %t2207
%t2217 = zext i8 %t2216 to i64
%t2218 = call ptr @resid_box_i64(i64 %t2217)
%t2221 = call ptr @resid_listbuf_push(ptr %p2, ptr %t2218)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i128 @__m____________lib_word_resid__xi_xor(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2223 = xor i128 %p0, %p1
ret i128 %t2223
}
define i128 @__m____________lib_word_resid__xi_and(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2224 = and i128 %p0, %p1
ret i128 %t2224
}
define i128 @__m____________lib_word_resid__xi_or(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2225 = or i128 %p0, %p1
ret i128 %t2225
}
define i128 @__m____________lib_word_resid__xi_shl(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2226 = sext i64 %p1 to i128
%t2227 = add i128 %t2226, 0
%t2228 = add i128 %t2227, 0
%t2229 = icmp ne i128 %t2228, %t2226
%t2230 = icmp slt i64 %p1, 0
%t2231 = or i1 %t2229, %t2230
%t2232 = zext i1 %t2231 to i8
call void @resid_conv_check(i8 %t2232)
%t2233 = icmp uge i128 %t2227, 128
%t2234 = add i128 %t2227, 0
%t2235 = shl i128 %p0, %t2234
%t2236 = select i1 %t2233, i128 0, i128 %t2235
ret i128 %t2236
}
define i128 @__m____________lib_word_resid__xi_shr(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2237 = sext i64 %p1 to i128
%t2238 = add i128 %t2237, 0
%t2239 = add i128 %t2238, 0
%t2240 = icmp ne i128 %t2239, %t2237
%t2241 = icmp slt i64 %p1, 0
%t2242 = or i1 %t2240, %t2241
%t2243 = zext i1 %t2242 to i8
call void @resid_conv_check(i8 %t2243)
%t2244 = icmp uge i128 %t2238, 128
%t2245 = add i128 %t2238, 0
%t2246 = lshr i128 %p0, %t2245
%t2247 = select i1 %t2244, i128 0, i128 %t2246
ret i128 %t2247
}
define i128 @__m____________lib_word_resid__xi_lift(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i128 %p0
}
define i128 @__m____________lib_word_resid__xi_from_word(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2248 = and i64 %p0, 4294967295
%t2249 = zext i64 %t2248 to i128
ret i128 %t2249
}
define i64 @__m____________lib_word_resid__xi_word(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2250 = sext i64 %p1 to i128
%t2251 = add i128 %t2250, 0
%t2252 = add i128 %t2251, 0
%t2253 = icmp ne i128 %t2252, %t2250
%t2254 = icmp slt i64 %p1, 0
%t2255 = or i1 %t2253, %t2254
%t2256 = zext i1 %t2255 to i8
call void @resid_conv_check(i8 %t2256)
%t2257 = icmp uge i128 %t2251, 128
%t2258 = add i128 %t2251, 0
%t2259 = lshr i128 %p0, %t2258
%t2260 = select i1 %t2257, i128 0, i128 %t2259
%t2261 = and i128 %t2260, 4294967295
%t2262 = trunc i128 %t2261 to i64
ret i64 %t2262
}
define i128 @__m____________lib_word_resid__xi_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2263 = and i64 %p0, 255
%t2264 = zext i64 %t2263 to i128
ret i128 %t2264
}
define i64 @__m____________lib_word_resid__xi_byte(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2265 = sext i64 %p1 to i128
%t2266 = add i128 %t2265, 0
%t2267 = add i128 %t2266, 0
%t2268 = icmp ne i128 %t2267, %t2265
%t2269 = icmp slt i64 %p1, 0
%t2270 = or i1 %t2268, %t2269
%t2271 = zext i1 %t2270 to i8
call void @resid_conv_check(i8 %t2271)
%t2272 = icmp uge i128 %t2266, 128
%t2273 = add i128 %t2266, 0
%t2274 = lshr i128 %p0, %t2273
%t2275 = select i1 %t2272, i128 0, i128 %t2274
%t2276 = and i128 %t2275, 255
%t2277 = trunc i128 %t2276 to i64
ret i64 %t2277
}
define i128 @__m____________lib_word_resid__xi_bit(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2278 = sext i64 %p1 to i128
%t2279 = add i128 %t2278, 0
%t2280 = add i128 %t2279, 0
%t2281 = icmp ne i128 %t2280, %t2278
%t2282 = icmp slt i64 %p1, 0
%t2283 = or i1 %t2281, %t2282
%t2284 = zext i1 %t2283 to i8
call void @resid_conv_check(i8 %t2284)
%t2285 = icmp uge i128 %t2279, 128
%t2286 = add i128 %t2279, 0
%t2287 = lshr i128 %p0, %t2286
%t2288 = select i1 %t2285, i128 0, i128 %t2287
%t2289 = and i128 %t2288, 1
%t2290 = trunc i128 %t2289 to i64
%t2291 = call i64 asm "", "=r,0"(i64 %t2290)
%t2292 = sext i64 %t2291 to i128
%t2293 = sub i128 0, %t2292
ret i128 %t2293
}
define i128 @__m____________lib_word_resid__xi_aes_round(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2294 = bitcast i128 %p0 to <2 x i64>
%t2295 = bitcast i128 %p1 to <2 x i64>
%t2296 = call <2 x i64> @llvm.x86.aesni.aesenc(<2 x i64> %t2294, <2 x i64> %t2295)
%t2297 = bitcast <2 x i64> %t2296 to i128
ret i128 %t2297
}
define i128 @__m____________lib_word_resid__xi_aes_last(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2298 = bitcast i128 %p0 to <2 x i64>
%t2299 = bitcast i128 %p1 to <2 x i64>
%t2300 = call <2 x i64> @llvm.x86.aesni.aesenclast(<2 x i64> %t2298, <2 x i64> %t2299)
%t2301 = bitcast <2 x i64> %t2300 to i128
ret i128 %t2301
}
define i128 @__m____________lib_word_resid__xi_clmul(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2302 = call i128 @e.gf128(i128 %p0, i128 %p1)
ret i128 %t2302
}
define i128 @__m____________lib_word_resid__xs_xor(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2303 = xor i128 %p0, %p1
ret i128 %t2303
}
define i128 @__m____________lib_word_resid__xs_and(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2304 = and i128 %p0, %p1
ret i128 %t2304
}
define i128 @__m____________lib_word_resid__xs_or(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2305 = or i128 %p0, %p1
ret i128 %t2305
}
define i128 @__m____________lib_word_resid__xs_shl(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2306 = sext i64 %p1 to i128
%t2307 = add i128 %t2306, 0
%t2308 = add i128 %t2307, 0
%t2309 = icmp ne i128 %t2308, %t2306
%t2310 = icmp slt i64 %p1, 0
%t2311 = or i1 %t2309, %t2310
%t2312 = zext i1 %t2311 to i8
call void @resid_conv_check(i8 %t2312)
%t2313 = icmp uge i128 %t2307, 128
%t2314 = add i128 %t2307, 0
%t2315 = shl i128 %p0, %t2314
%t2316 = select i1 %t2313, i128 0, i128 %t2315
ret i128 %t2316
}
define i128 @__m____________lib_word_resid__xs_shr(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2317 = sext i64 %p1 to i128
%t2318 = add i128 %t2317, 0
%t2319 = add i128 %t2318, 0
%t2320 = icmp ne i128 %t2319, %t2317
%t2321 = icmp slt i64 %p1, 0
%t2322 = or i1 %t2320, %t2321
%t2323 = zext i1 %t2322 to i8
call void @resid_conv_check(i8 %t2323)
%t2324 = icmp uge i128 %t2318, 128
%t2325 = add i128 %t2318, 0
%t2326 = lshr i128 %p0, %t2325
%t2327 = select i1 %t2324, i128 0, i128 %t2326
ret i128 %t2327
}
define i128 @__m____________lib_word_resid__xs_lift(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i128 %p0
}
define i128 @__m____________lib_word_resid__xs_from_word(i32 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2328 = zext i32 %p0 to i128
ret i128 %t2328
}
define i32 @__m____________lib_word_resid__xs_word(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2329 = sext i64 %p1 to i128
%t2330 = add i128 %t2329, 0
%t2331 = add i128 %t2330, 0
%t2332 = icmp ne i128 %t2331, %t2329
%t2333 = icmp slt i64 %p1, 0
%t2334 = or i1 %t2332, %t2333
%t2335 = zext i1 %t2334 to i8
call void @resid_conv_check(i8 %t2335)
%t2336 = icmp uge i128 %t2330, 128
%t2337 = add i128 %t2330, 0
%t2338 = lshr i128 %p0, %t2337
%t2339 = select i1 %t2336, i128 0, i128 %t2338
%t2340 = trunc i128 %t2339 to i32
ret i32 %t2340
}
define i128 @__m____________lib_word_resid__xs_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2341 = zext i8 %p0 to i128
ret i128 %t2341
}
define i8 @__m____________lib_word_resid__xs_byte(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2342 = sext i64 %p1 to i128
%t2343 = add i128 %t2342, 0
%t2344 = add i128 %t2343, 0
%t2345 = icmp ne i128 %t2344, %t2342
%t2346 = icmp slt i64 %p1, 0
%t2347 = or i1 %t2345, %t2346
%t2348 = zext i1 %t2347 to i8
call void @resid_conv_check(i8 %t2348)
%t2349 = icmp uge i128 %t2343, 128
%t2350 = add i128 %t2343, 0
%t2351 = lshr i128 %p0, %t2350
%t2352 = select i1 %t2349, i128 0, i128 %t2351
%t2353 = trunc i128 %t2352 to i8
ret i8 %t2353
}
define i128 @__m____________lib_word_resid__xs_bit(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2354 = sext i64 %p1 to i128
%t2355 = add i128 %t2354, 0
%t2356 = add i128 %t2355, 0
%t2357 = icmp ne i128 %t2356, %t2354
%t2358 = icmp slt i64 %p1, 0
%t2359 = or i1 %t2357, %t2358
%t2360 = zext i1 %t2359 to i8
call void @resid_conv_check(i8 %t2360)
%t2361 = icmp uge i128 %t2355, 128
%t2362 = add i128 %t2355, 0
%t2363 = lshr i128 %p0, %t2362
%t2364 = select i1 %t2361, i128 0, i128 %t2363
%t2365 = and i128 %t2364, 1
%t2366 = trunc i128 %t2365 to i64
%t2367 = call i64 asm "", "=r,0"(i64 %t2366)
%t2368 = sext i64 %t2367 to i128
%t2369 = sub i128 0, %t2368
ret i128 %t2369
}
define i128 @__m____________lib_word_resid__xs_aes_round(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2370 = bitcast i128 %p0 to <2 x i64>
%t2371 = bitcast i128 %p1 to <2 x i64>
%t2372 = call <2 x i64> @llvm.x86.aesni.aesenc(<2 x i64> %t2370, <2 x i64> %t2371)
%t2373 = bitcast <2 x i64> %t2372 to i128
ret i128 %t2373
}
define i128 @__m____________lib_word_resid__xs_aes_last(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2374 = bitcast i128 %p0 to <2 x i64>
%t2375 = bitcast i128 %p1 to <2 x i64>
%t2376 = call <2 x i64> @llvm.x86.aesni.aesenclast(<2 x i64> %t2374, <2 x i64> %t2375)
%t2377 = bitcast <2 x i64> %t2376 to i128
ret i128 %t2377
}
define i128 @__m____________lib_word_resid__xs_clmul(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2378 = call i128 @e.gf128(i128 %p0, i128 %p1)
ret i128 %t2378
}
define i64 @__m____________lib_sha256g_resid__sha2k(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2380 = call ptr @resid_list_const_i64(ptr @.lc2379, i64 64, ptr @.lcd2379, ptr @.lty2379)
%t2381 = call ptr @resid_list_get(ptr %t2380, i64 %p0)
%t2382 = call i64 @resid_unbox_i64(ptr %t2381)
ret i64 %t2382
}
define ptr @sha256g_pad(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2384 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p0, i64 9)
%t2385 = extractvalue {i64, i1} %t2384, 0
%t2386 = extractvalue {i64, i1} %t2384, 1
%t2387 = zext i1 %t2386 to i8
call void @resid_overflow_check(i8 %t2387)
%t2388 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2385, i64 63)
%t2389 = extractvalue {i64, i1} %t2388, 0
%t2390 = extractvalue {i64, i1} %t2388, 1
%t2391 = zext i1 %t2390 to i8
call void @resid_overflow_check(i8 %t2391)
%t2392 = sdiv i64 %t2389, 64
%t2393 = mul nsw i64 %t2392, 64
%t2394 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t2393, i64 %p0)
%t2395 = extractvalue {i64, i1} %t2394, 0
%t2396 = extractvalue {i64, i1} %t2394, 1
%t2397 = zext i1 %t2396 to i8
call void @resid_overflow_check(i8 %t2397)
%t2398 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t2395, i64 9)
%t2399 = extractvalue {i64, i1} %t2398, 0
%t2400 = extractvalue {i64, i1} %t2398, 1
%t2401 = zext i1 %t2400 to i8
call void @resid_overflow_check(i8 %t2401)
%t2402 = call ptr @resid_listbuf_new()
%t2403 = call ptr @__m____________lib_sha256g_resid__sha256g_pad_at__rs143(i64 %p0, i64 %t2399, i64 0, ptr %t2402)
%t2404 = call ptr @resid_listbuf_finish(ptr %t2403, ptr @.lty2404)
ret ptr %t2404
}
define ptr @__m____________lib_sha256g_resid__sha256g_pad_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ], [ %p0, %tco.s2 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ], [ %p1, %tco.s2 ]
%p2 = phi i64 [ %p2.in, %entry ], [ 1, %tco.s0 ], [ %t2413, %tco.s1 ], [ %t2439, %tco.s2 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t2409, %tco.s0 ], [ %t2419, %tco.s1 ], [ %t2454, %tco.s2 ]
%t2405 = icmp eq i64 %p2, 0
br i1 %t2405, label %L295, label %L297
L295:
%t2406 = call ptr @resid_box_i64(i64 128)
%t2409 = call ptr @resid_listbuf_push(ptr %p3, ptr %t2406)
br label %tco.s0
tco.s0:
br label %tco.head
L297:
%t2411 = icmp sle i64 %p2, %p1
br i1 %t2411, label %L298, label %L300
L298:
%t2412 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t2413 = extractvalue {i64, i1} %t2412, 0
%t2414 = extractvalue {i64, i1} %t2412, 1
%t2415 = zext i1 %t2414 to i8
call void @resid_overflow_check(i8 %t2415)
%t2416 = call ptr @resid_box_i64(i64 0)
%t2419 = call ptr @resid_listbuf_push(ptr %p3, ptr %t2416)
br label %tco.s1
tco.s1:
br label %tco.head
L300:
%t2421 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 8)
%t2422 = extractvalue {i64, i1} %t2421, 0
%t2423 = extractvalue {i64, i1} %t2421, 1
%t2424 = zext i1 %t2423 to i8
call void @resid_overflow_check(i8 %t2424)
%t2425 = icmp sle i64 %p2, %t2422
br i1 %t2425, label %L301, label %L303
L301:
%t2426 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 8)
%t2427 = extractvalue {i64, i1} %t2426, 0
%t2428 = extractvalue {i64, i1} %t2426, 1
%t2429 = zext i1 %t2428 to i8
call void @resid_overflow_check(i8 %t2429)
%t2430 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t2427, i64 %p2)
%t2431 = extractvalue {i64, i1} %t2430, 0
%t2432 = extractvalue {i64, i1} %t2430, 1
%t2433 = zext i1 %t2432 to i8
call void @resid_overflow_check(i8 %t2433)
%t2434 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t2431, i64 8)
%t2435 = extractvalue {i64, i1} %t2434, 0
%t2436 = extractvalue {i64, i1} %t2434, 1
%t2437 = zext i1 %t2436 to i8
call void @resid_overflow_check(i8 %t2437)
%t2438 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t2439 = extractvalue {i64, i1} %t2438, 0
%t2440 = extractvalue {i64, i1} %t2438, 1
%t2441 = zext i1 %t2440 to i8
call void @resid_overflow_check(i8 %t2441)
%t2442 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p0, i64 8)
%t2443 = extractvalue {i64, i1} %t2442, 0
%t2444 = extractvalue {i64, i1} %t2442, 1
%t2445 = zext i1 %t2444 to i8
call void @resid_overflow_check(i8 %t2445)
%t2446 = icmp uge i64 %t2435, 64
%t2447 = add i64 %t2435, 0
%t2448 = select i1 %t2446, i64 63, i64 %t2447
%t2449 = ashr i64 %t2443, %t2448
%t2450 = and i64 %t2449, 255
%t2451 = call ptr @resid_box_i64(i64 %t2450)
%t2454 = call ptr @resid_listbuf_push(ptr %p3, ptr %t2451)
br label %tco.s2
tco.s2:
br label %tco.head
L303:
ret ptr %p3
}
define ptr @sha256g_iv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2457 = call ptr @resid_list_const_i64(ptr @.lc2456, i64 8, ptr @.lcd2456, ptr @.lty2456)
ret ptr %t2457
}
define ptr @__m____________lib_sha256g_resid__sha256g_zeros(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2460, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t2464, %tco.s0 ]
%t2458 = icmp sge i64 %p1, %p0
br i1 %t2458, label %L304, label %L306
L304:
%t2459 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty2459)
ret ptr %t2459
L306:
%t2460 = add nsw i64 %p1, 1
%t2461 = call ptr @resid_box_i64(i64 0)
%t2464 = call ptr @resid_listbuf_push(ptr %p2, ptr %t2461)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @mask32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2466 = and i64 %p0, 4294967295
ret i64 %t2466
}
define i64 @rotr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2467 = icmp uge i64 %p1, 64
%t2468 = add i64 %p1, 0
%t2469 = select i1 %t2467, i64 63, i64 %t2468
%t2470 = ashr i64 %p0, %t2469
%t2471 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t2472 = extractvalue {i64, i1} %t2471, 0
%t2473 = extractvalue {i64, i1} %t2471, 1
%t2474 = zext i1 %t2473 to i8
call void @resid_overflow_check(i8 %t2474)
%t2475 = icmp uge i64 %t2472, 64
%t2476 = add i64 %t2472, 0
%t2477 = shl i64 %p0, %t2476
%t2478 = select i1 %t2475, i64 0, i64 %t2477
%t2479 = or i64 %t2470, %t2478
%t2480 = and i64 %t2479, 4294967295
ret i64 %t2480
}
define i64 @not32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2481 = xor i64 %p0, 4294967295
%t2482 = and i64 %t2481, 4294967295
ret i64 %t2482
}
define i64 @k_at(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2484 = call ptr @resid_list_const_i64(ptr @.lc2483, i64 64, ptr @.lcd2483, ptr @.lty2483)
%t2485 = call ptr @resid_list_get(ptr %t2484, i64 %p0)
%t2486 = call i64 @resid_unbox_i64(ptr %t2485)
ret i64 %t2486
}
define ptr @utf8_push_cp(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2488 = icmp slt i64 %p0, 128
br i1 %t2488, label %L307, label %L309
L307:
%t2489 = call ptr @resid_box_i64(i64 %p0)
%t2492 = call ptr @resid_listbuf_push(ptr %p1, ptr %t2489)
ret ptr %t2492
L309:
%t2493 = icmp slt i64 %p0, 2048
br i1 %t2493, label %L310, label %L312
L310:
%t2494 = ashr i64 %p0, 6
%t2495 = or i64 192, %t2494
%t2496 = call ptr @resid_box_i64(i64 %t2495)
%t2499 = call ptr @resid_listbuf_push(ptr %p1, ptr %t2496)
%t2500 = and i64 %p0, 63
%t2501 = or i64 128, %t2500
%t2502 = call ptr @resid_box_i64(i64 %t2501)
%t2505 = call ptr @resid_listbuf_push(ptr %t2499, ptr %t2502)
ret ptr %t2505
L312:
%t2506 = icmp slt i64 %p0, 65536
br i1 %t2506, label %L313, label %L315
L313:
%t2507 = ashr i64 %p0, 12
%t2508 = or i64 224, %t2507
%t2509 = call ptr @resid_box_i64(i64 %t2508)
%t2512 = call ptr @resid_listbuf_push(ptr %p1, ptr %t2509)
%t2513 = ashr i64 %p0, 6
%t2514 = and i64 %t2513, 63
%t2515 = or i64 128, %t2514
%t2516 = call ptr @resid_box_i64(i64 %t2515)
%t2519 = call ptr @resid_listbuf_push(ptr %t2512, ptr %t2516)
%t2520 = and i64 %p0, 63
%t2521 = or i64 128, %t2520
%t2522 = call ptr @resid_box_i64(i64 %t2521)
%t2525 = call ptr @resid_listbuf_push(ptr %t2519, ptr %t2522)
ret ptr %t2525
L315:
%t2526 = ashr i64 %p0, 18
%t2527 = or i64 240, %t2526
%t2528 = call ptr @resid_box_i64(i64 %t2527)
%t2531 = call ptr @resid_listbuf_push(ptr %p1, ptr %t2528)
%t2532 = ashr i64 %p0, 12
%t2533 = and i64 %t2532, 63
%t2534 = or i64 128, %t2533
%t2535 = call ptr @resid_box_i64(i64 %t2534)
%t2538 = call ptr @resid_listbuf_push(ptr %t2531, ptr %t2535)
%t2539 = ashr i64 %p0, 6
%t2540 = and i64 %t2539, 63
%t2541 = or i64 128, %t2540
%t2542 = call ptr @resid_box_i64(i64 %t2541)
%t2545 = call ptr @resid_listbuf_push(ptr %t2538, ptr %t2542)
%t2546 = and i64 %p0, 63
%t2547 = or i64 128, %t2546
%t2548 = call ptr @resid_box_i64(i64 %t2547)
%t2551 = call ptr @resid_listbuf_push(ptr %t2545, ptr %t2548)
ret ptr %t2551
}
define ptr @utf8_run(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2555, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t2557, %tco.s0 ]
%t2552 = call i64 @str_len(ptr %p0)
%t2553 = icmp sge i64 %p1, %t2552
br i1 %t2553, label %L316, label %L318
L316:
%t2554 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty2554)
ret ptr %t2554
L318:
%t2555 = add nsw i64 %p1, 1
%t2556 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t2557 = call ptr @utf8_push_cp(i64 %t2556, ptr %p2)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @msg_bytes(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2559 = call ptr @resid_listbuf_new()
%t2560 = call ptr @utf8_run(ptr %p0, i64 %p1, ptr %t2559)
%t2561 = call ptr @resid_list_freeze(ptr %t2560)
%t2562 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t2561)
ret ptr %t2562
}
define ptr @bytes_of(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2563 = call ptr @resid_listbuf_new()
%t2564 = call ptr @utf8_run(ptr %p0, i64 0, ptr %t2563)
ret ptr %t2564
}
define i1 @str_is_ascii(ptr %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2569, %tco.s0 ]
%t2565 = call i64 @str_len(ptr %p0)
%t2566 = icmp sge i64 %p1, %t2565
br i1 %t2566, label %L319, label %L321
L319:
ret i1 true
L321:
%t2567 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t2568 = icmp sge i64 %t2567, 128
br i1 %t2568, label %L322, label %L324
L322:
ret i1 false
L324:
%t2569 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @slice_seed(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2575 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2583, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2586, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t2571 = icmp sle i64 %p2, 0
br i1 %t2571, label %L325, label %L327
L325:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p3
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L327:
%t2572 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t2573 = call i64 @resid_unbox_i64(ptr %t2572)
%t2577 = call ptr @resid_box_i64(i64 %t2573)
%t2579 = getelementptr i8, ptr %t2575, i64 0
store ptr %t2577, ptr %t2579
%t2580 = call ptr @resid_list_new(i64 1, ptr %t2575, ptr @.lty2575)
%t2581 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t2580)
%t2582 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t2583 = extractvalue {i64, i1} %t2582, 0
%t2584 = extractvalue {i64, i1} %t2582, 1
%t2585 = zext i1 %t2584 to i8
call void @resid_overflow_check(i8 %t2585)
%t2586 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t2581, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t2581, %tco.s0 ]
br label %tco.head
}
define ptr @zeros_l(ptr %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2592, %tco.s0.k ]
%t2588 = icmp sle i64 %p1, 0
br i1 %t2588, label %L328, label %L330
L328:
%lr.cx9 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz9 = icmp eq ptr %lr.cx9, null
br i1 %lr.lz9, label %lr.x9.k, label %lr.x9.m
lr.x9.k:
ret ptr %p0
lr.x9.m:
%lr.ret9 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx9)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret9
L330:
%t2590 = call ptr @resid_list_const_i64(ptr @.lc2589, i64 1, ptr @.lcd2589, ptr @.lty2589)
%t2591 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t2590)
%t2592 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t2591, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t2591, %tco.s0 ]
br label %tco.head
}
define ptr @length_bytes(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2604 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2611, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t2594 = icmp slt i64 %p1, 0
br i1 %t2594, label %L331, label %L333
L331:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p2
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L333:
%t2595 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t2596 = extractvalue {i64, i1} %t2595, 0
%t2597 = extractvalue {i64, i1} %t2595, 1
%t2598 = zext i1 %t2597 to i8
call void @resid_overflow_check(i8 %t2598)
%t2599 = icmp uge i64 %t2596, 64
%t2600 = add i64 %t2596, 0
%t2601 = select i1 %t2599, i64 63, i64 %t2600
%t2602 = ashr i64 %p0, %t2601
%t2603 = and i64 %t2602, 255
%t2606 = call ptr @resid_box_i64(i64 %t2603)
%t2608 = getelementptr i8, ptr %t2604, i64 0
store ptr %t2606, ptr %t2608
%t2609 = call ptr @resid_list_new(i64 1, ptr %t2604, ptr @.lty2604)
%t2610 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t2609)
%t2611 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t2610, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t2610, %tco.s0 ]
br label %tco.head
}
define ptr @pad_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2613 = call i64 @resid_list_len(ptr %p0)
%t2615 = call ptr @resid_list_const_i64(ptr @.lc2614, i64 1, ptr @.lcd2614, ptr @.lty2614)
%t2616 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t2615)
%t2617 = add nsw i64 %t2613, 9
%t2618 = add nsw i64 %t2617, 63
%t2619 = sdiv i64 %t2618, 64
%t2620 = mul nsw i64 %t2619, 64
%t2621 = sub nsw i64 %t2620, %t2617
%t2622 = call ptr @zeros_l(ptr %t2616, i64 %t2621)
%t2623 = mul nsw i64 %t2613, 8
%t2624 = call ptr @length_bytes__rs146(i64 %t2623, i64 7, ptr %t2622)
ret ptr %t2624
}
define ptr @bw_acc(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2665 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2672, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t2625 = icmp sge i64 %p2, 16
br i1 %t2625, label %L334, label %L336
L334:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p3
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L336:
%t2626 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t2627 = extractvalue {i64, i1} %t2626, 0
%t2628 = extractvalue {i64, i1} %t2626, 1
%t2629 = zext i1 %t2628 to i8
call void @resid_overflow_check(i8 %t2629)
%t2630 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t2627)
%t2631 = extractvalue {i64, i1} %t2630, 0
%t2632 = extractvalue {i64, i1} %t2630, 1
%t2633 = zext i1 %t2632 to i8
call void @resid_overflow_check(i8 %t2633)
%t2634 = call ptr @resid_list_get_v(ptr %p0, i64 %t2631, ptr %p0.ld, i64 %p0.ln)
%t2635 = call i64 @resid_unbox_i64(ptr %t2634)
%t2637 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2631, i64 1)
%t2638 = extractvalue {i64, i1} %t2637, 0
%t2639 = extractvalue {i64, i1} %t2637, 1
%t2640 = zext i1 %t2639 to i8
call void @resid_overflow_check(i8 %t2640)
%t2641 = call ptr @resid_list_get_v(ptr %p0, i64 %t2638, ptr %p0.ld, i64 %p0.ln)
%t2642 = call i64 @resid_unbox_i64(ptr %t2641)
%t2644 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2631, i64 2)
%t2645 = extractvalue {i64, i1} %t2644, 0
%t2646 = extractvalue {i64, i1} %t2644, 1
%t2647 = zext i1 %t2646 to i8
call void @resid_overflow_check(i8 %t2647)
%t2648 = call ptr @resid_list_get_v(ptr %p0, i64 %t2645, ptr %p0.ld, i64 %p0.ln)
%t2649 = call i64 @resid_unbox_i64(ptr %t2648)
%t2651 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2631, i64 3)
%t2652 = extractvalue {i64, i1} %t2651, 0
%t2653 = extractvalue {i64, i1} %t2651, 1
%t2654 = zext i1 %t2653 to i8
call void @resid_overflow_check(i8 %t2654)
%t2655 = call ptr @resid_list_get_v(ptr %p0, i64 %t2652, ptr %p0.ld, i64 %p0.ln)
%t2656 = call i64 @resid_unbox_i64(ptr %t2655)
%t2658 = shl i64 %t2635, 24
%t2659 = shl i64 %t2642, 16
%t2660 = shl i64 %t2649, 8
%t2661 = or i64 %t2658, %t2659
%t2662 = or i64 %t2661, %t2660
%t2663 = or i64 %t2662, %t2656
%t2664 = and i64 %t2663, 4294967295
%t2667 = call ptr @resid_box_i64(i64 %t2664)
%t2669 = getelementptr i8, ptr %t2665, i64 0
store ptr %t2667, ptr %t2669
%t2670 = call ptr @resid_list_new(i64 1, ptr %t2665, ptr @.lty2665)
%t2671 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t2670)
%t2672 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t2671, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t2671, %tco.s0 ]
br label %tco.head
}
define ptr @block_words(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2675 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty2674)
%t2676 = call ptr @bw_acc(ptr %p0, i64 %p1, i64 0, ptr %t2675)
ret ptr %t2676
}
define ptr @ext_w(ptr %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2729 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2736, %tco.s0.k ]
%t2677 = icmp sge i64 %p1, 64
br i1 %t2677, label %L337, label %L339
L337:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr %p0
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L339:
%t2678 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 15)
%t2679 = extractvalue {i64, i1} %t2678, 0
%t2680 = extractvalue {i64, i1} %t2678, 1
%t2681 = zext i1 %t2680 to i8
call void @resid_overflow_check(i8 %t2681)
%t2682 = call ptr @resid_list_get(ptr %p0, i64 %t2679)
%t2683 = call i64 @resid_unbox_i64(ptr %t2682)
%t2685 = call i64 @rotr(i64 %t2683, i64 7)
%t2686 = call i64 @rotr(i64 %t2683, i64 18)
%t2687 = ashr i64 %t2683, 3
%t2688 = xor i64 %t2685, %t2686
%t2689 = xor i64 %t2688, %t2687
%t2690 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 2)
%t2691 = extractvalue {i64, i1} %t2690, 0
%t2692 = extractvalue {i64, i1} %t2690, 1
%t2693 = zext i1 %t2692 to i8
call void @resid_overflow_check(i8 %t2693)
%t2694 = call ptr @resid_list_get(ptr %p0, i64 %t2691)
%t2695 = call i64 @resid_unbox_i64(ptr %t2694)
%t2697 = call i64 @rotr(i64 %t2695, i64 17)
%t2698 = call i64 @rotr(i64 %t2695, i64 19)
%t2699 = ashr i64 %t2695, 10
%t2700 = xor i64 %t2697, %t2698
%t2701 = xor i64 %t2700, %t2699
%t2702 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 16)
%t2703 = extractvalue {i64, i1} %t2702, 0
%t2704 = extractvalue {i64, i1} %t2702, 1
%t2705 = zext i1 %t2704 to i8
call void @resid_overflow_check(i8 %t2705)
%t2706 = call ptr @resid_list_get(ptr %p0, i64 %t2703)
%t2707 = call i64 @resid_unbox_i64(ptr %t2706)
%t2709 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2707, i64 %t2689)
%t2710 = extractvalue {i64, i1} %t2709, 0
%t2711 = extractvalue {i64, i1} %t2709, 1
%t2712 = zext i1 %t2711 to i8
call void @resid_overflow_check(i8 %t2712)
%t2713 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 7)
%t2714 = extractvalue {i64, i1} %t2713, 0
%t2715 = extractvalue {i64, i1} %t2713, 1
%t2716 = zext i1 %t2715 to i8
call void @resid_overflow_check(i8 %t2716)
%t2717 = call ptr @resid_list_get(ptr %p0, i64 %t2714)
%t2718 = call i64 @resid_unbox_i64(ptr %t2717)
%t2720 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2718, i64 %t2701)
%t2721 = extractvalue {i64, i1} %t2720, 0
%t2722 = extractvalue {i64, i1} %t2720, 1
%t2723 = zext i1 %t2722 to i8
call void @resid_overflow_check(i8 %t2723)
%t2724 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2710, i64 %t2721)
%t2725 = extractvalue {i64, i1} %t2724, 0
%t2726 = extractvalue {i64, i1} %t2724, 1
%t2727 = zext i1 %t2726 to i8
call void @resid_overflow_check(i8 %t2727)
%t2728 = and i64 %t2725, 4294967295
%t2731 = call ptr @resid_box_i64(i64 %t2728)
%t2733 = getelementptr i8, ptr %t2729, i64 0
store ptr %t2731, ptr %t2733
%t2734 = call ptr @resid_list_new(i64 1, ptr %t2729, ptr @.lty2729)
%t2735 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t2734)
%t2736 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t2735, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t2735, %tco.s0 ]
br label %tco.head
}
define i64 @pick(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2738 = icmp eq i64 %p3, %p1
br i1 %t2738, label %L340, label %L342
L340:
ret i64 %p2
L342:
%t2739 = call ptr @resid_list_get(ptr %p0, i64 %p3)
%t2740 = call i64 @resid_unbox_i64(ptr %t2739)
ret i64 %t2740
}
define ptr @ls_build(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2742 = icmp sgt i64 %p3, 0
br i1 %t2742, label %L343, label %L345
L343:
%t2743 = sub nsw i64 %p3, 1
%t2744 = call ptr @ls_build(ptr %p0, i64 %p1, i64 %p2, i64 %t2743)
%t2745 = call i64 @pick(ptr %p0, i64 %p1, i64 %p2, i64 %p3)
%t2746 = alloca [1 x ptr]
%t2748 = call ptr @resid_box_i64(i64 %t2745)
%t2750 = getelementptr i8, ptr %t2746, i64 0
store ptr %t2748, ptr %t2750
%t2751 = call ptr @resid_list_new(i64 1, ptr %t2746, ptr @.lty2746)
%t2752 = call ptr @resid_list_concat_own(ptr %t2744, i8 1, ptr %t2751)
ret ptr %t2752
L345:
%t2753 = call i64 @pick(ptr %p0, i64 %p1, i64 %p2, i64 0)
%t2754 = alloca [1 x ptr]
%t2756 = call ptr @resid_box_i64(i64 %t2753)
%t2758 = getelementptr i8, ptr %t2754, i64 0
store ptr %t2756, ptr %t2758
%t2759 = call ptr @resid_list_new(i64 1, ptr %t2754, ptr @.lty2754)
ret ptr %t2759
}
define ptr @ls_set(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2760 = call i64 @resid_list_len(ptr %p0)
%t2761 = sub nsw i64 %t2760, 1
%t2762 = call ptr @ls_build(ptr %p0, i64 %p1, i64 %p2, i64 %t2761)
ret ptr %t2762
}
define i64 @ch_of(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2763 = call i64 @not32(i64 %p0)
%t2764 = and i64 %p0, %p1
%t2765 = and i64 %t2763, %p2
%t2766 = xor i64 %t2764, %t2765
ret i64 %t2766
}
define ptr @sha_round(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2767 = call ptr @resid_list_get(ptr %p0, i64 0)
%t2768 = call i64 @resid_unbox_i64(ptr %t2767)
%t2770 = call ptr @resid_list_get(ptr %p0, i64 1)
%t2771 = call i64 @resid_unbox_i64(ptr %t2770)
%t2773 = call ptr @resid_list_get(ptr %p0, i64 2)
%t2774 = call i64 @resid_unbox_i64(ptr %t2773)
%t2776 = call ptr @resid_list_get(ptr %p0, i64 3)
%t2777 = call i64 @resid_unbox_i64(ptr %t2776)
%t2779 = call ptr @resid_list_get(ptr %p0, i64 4)
%t2780 = call i64 @resid_unbox_i64(ptr %t2779)
%t2782 = call ptr @resid_list_get(ptr %p0, i64 5)
%t2783 = call i64 @resid_unbox_i64(ptr %t2782)
%t2785 = call ptr @resid_list_get(ptr %p0, i64 6)
%t2786 = call i64 @resid_unbox_i64(ptr %t2785)
%t2788 = call ptr @resid_list_get(ptr %p0, i64 7)
%t2789 = call i64 @resid_unbox_i64(ptr %t2788)
%t2791 = call ptr @resid_list_get(ptr %p1, i64 %p2)
%t2792 = call i64 @resid_unbox_i64(ptr %t2791)
%t2794 = call i64 @resid_scope_push()
%t2795 = call i64 @k_at(i64 %p2)
call void @resid_scope_pop(i64 %t2794)
%t2796 = call i64 @rotr(i64 %t2780, i64 6)
%t2797 = call i64 @rotr(i64 %t2780, i64 11)
%t2798 = call i64 @rotr(i64 %t2780, i64 25)
%t2799 = xor i64 %t2796, %t2797
%t2800 = xor i64 %t2799, %t2798
%t2801 = call i64 @ch_of(i64 %t2780, i64 %t2783, i64 %t2786)
%t2802 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2789, i64 %t2800)
%t2803 = extractvalue {i64, i1} %t2802, 0
%t2804 = extractvalue {i64, i1} %t2802, 1
%t2805 = zext i1 %t2804 to i8
call void @resid_overflow_check(i8 %t2805)
%t2806 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2803, i64 %t2801)
%t2807 = extractvalue {i64, i1} %t2806, 0
%t2808 = extractvalue {i64, i1} %t2806, 1
%t2809 = zext i1 %t2808 to i8
call void @resid_overflow_check(i8 %t2809)
%t2810 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2807, i64 %t2795)
%t2811 = extractvalue {i64, i1} %t2810, 0
%t2812 = extractvalue {i64, i1} %t2810, 1
%t2813 = zext i1 %t2812 to i8
call void @resid_overflow_check(i8 %t2813)
%t2814 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2811, i64 %t2792)
%t2815 = extractvalue {i64, i1} %t2814, 0
%t2816 = extractvalue {i64, i1} %t2814, 1
%t2817 = zext i1 %t2816 to i8
call void @resid_overflow_check(i8 %t2817)
%t2818 = and i64 %t2815, 4294967295
%t2819 = call i64 @rotr(i64 %t2768, i64 2)
%t2820 = call i64 @rotr(i64 %t2768, i64 13)
%t2821 = call i64 @rotr(i64 %t2768, i64 22)
%t2822 = xor i64 %t2819, %t2820
%t2823 = xor i64 %t2822, %t2821
%t2824 = and i64 %t2768, %t2771
%t2825 = and i64 %t2768, %t2774
%t2826 = and i64 %t2771, %t2774
%t2827 = xor i64 %t2824, %t2825
%t2828 = xor i64 %t2827, %t2826
%t2829 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2823, i64 %t2828)
%t2830 = extractvalue {i64, i1} %t2829, 0
%t2831 = extractvalue {i64, i1} %t2829, 1
%t2832 = zext i1 %t2831 to i8
call void @resid_overflow_check(i8 %t2832)
%t2833 = and i64 %t2830, 4294967295
%t2834 = add nsw i64 %t2818, %t2833
%t2835 = and i64 %t2834, 4294967295
%t2836 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2777, i64 %t2818)
%t2837 = extractvalue {i64, i1} %t2836, 0
%t2838 = extractvalue {i64, i1} %t2836, 1
%t2839 = zext i1 %t2838 to i8
call void @resid_overflow_check(i8 %t2839)
%t2840 = and i64 %t2837, 4294967295
%t2841 = alloca [8 x ptr]
%t2843 = call ptr @resid_box_i64(i64 %t2835)
%t2845 = getelementptr i8, ptr %t2841, i64 0
store ptr %t2843, ptr %t2845
%t2846 = call ptr @resid_box_i64(i64 %t2768)
%t2848 = getelementptr i8, ptr %t2841, i64 8
store ptr %t2846, ptr %t2848
%t2849 = call ptr @resid_box_i64(i64 %t2771)
%t2851 = getelementptr i8, ptr %t2841, i64 16
store ptr %t2849, ptr %t2851
%t2852 = call ptr @resid_box_i64(i64 %t2774)
%t2854 = getelementptr i8, ptr %t2841, i64 24
store ptr %t2852, ptr %t2854
%t2855 = call ptr @resid_box_i64(i64 %t2840)
%t2857 = getelementptr i8, ptr %t2841, i64 32
store ptr %t2855, ptr %t2857
%t2858 = call ptr @resid_box_i64(i64 %t2780)
%t2860 = getelementptr i8, ptr %t2841, i64 40
store ptr %t2858, ptr %t2860
%t2861 = call ptr @resid_box_i64(i64 %t2783)
%t2863 = getelementptr i8, ptr %t2841, i64 48
store ptr %t2861, ptr %t2863
%t2864 = call ptr @resid_box_i64(i64 %t2786)
%t2866 = getelementptr i8, ptr %t2841, i64 56
store ptr %t2864, ptr %t2866
%t2867 = call ptr @resid_list_new(i64 8, ptr %t2841, ptr @.lty2841)
ret ptr %t2867
}
define ptr @sha_rounds(ptr %p0.in, ptr %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2870, %tco.s0.k ]
%t2868 = icmp sge i64 %p2, 64
br i1 %t2868, label %L346, label %L348
L346:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr %p0
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L348:
%t2869 = call ptr @sha_round(ptr %p0, ptr %p1, i64 %p2)
%t2870 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t2869, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t2869, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
br label %tco.head
}
define i64 @add_w(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2872 = call ptr @resid_list_get(ptr %p0, i64 %p2)
%t2873 = call i64 @resid_unbox_i64(ptr %t2872)
%t2875 = call ptr @resid_list_get(ptr %p1, i64 %p2)
%t2876 = call i64 @resid_unbox_i64(ptr %t2875)
%t2878 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2873, i64 %t2876)
%t2879 = extractvalue {i64, i1} %t2878, 0
%t2880 = extractvalue {i64, i1} %t2878, 1
%t2881 = zext i1 %t2880 to i8
call void @resid_overflow_check(i8 %t2881)
%t2882 = and i64 %t2879, 4294967295
ret i64 %t2882
}
define ptr @add_h(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2883 = call i64 @add_w(ptr %p0, ptr %p1, i64 0)
%t2884 = call i64 @add_w(ptr %p0, ptr %p1, i64 1)
%t2885 = call i64 @add_w(ptr %p0, ptr %p1, i64 2)
%t2886 = call i64 @add_w(ptr %p0, ptr %p1, i64 3)
%t2887 = call i64 @add_w(ptr %p0, ptr %p1, i64 4)
%t2888 = call i64 @add_w(ptr %p0, ptr %p1, i64 5)
%t2889 = call i64 @add_w(ptr %p0, ptr %p1, i64 6)
%t2890 = call i64 @add_w(ptr %p0, ptr %p1, i64 7)
%t2891 = alloca [8 x ptr]
%t2893 = call ptr @resid_box_i64(i64 %t2883)
%t2895 = getelementptr i8, ptr %t2891, i64 0
store ptr %t2893, ptr %t2895
%t2896 = call ptr @resid_box_i64(i64 %t2884)
%t2898 = getelementptr i8, ptr %t2891, i64 8
store ptr %t2896, ptr %t2898
%t2899 = call ptr @resid_box_i64(i64 %t2885)
%t2901 = getelementptr i8, ptr %t2891, i64 16
store ptr %t2899, ptr %t2901
%t2902 = call ptr @resid_box_i64(i64 %t2886)
%t2904 = getelementptr i8, ptr %t2891, i64 24
store ptr %t2902, ptr %t2904
%t2905 = call ptr @resid_box_i64(i64 %t2887)
%t2907 = getelementptr i8, ptr %t2891, i64 32
store ptr %t2905, ptr %t2907
%t2908 = call ptr @resid_box_i64(i64 %t2888)
%t2910 = getelementptr i8, ptr %t2891, i64 40
store ptr %t2908, ptr %t2910
%t2911 = call ptr @resid_box_i64(i64 %t2889)
%t2913 = getelementptr i8, ptr %t2891, i64 48
store ptr %t2911, ptr %t2913
%t2914 = call ptr @resid_box_i64(i64 %t2890)
%t2916 = getelementptr i8, ptr %t2891, i64 56
store ptr %t2914, ptr %t2916
%t2917 = call ptr @resid_list_new(i64 8, ptr %t2891, ptr @.lty2891)
ret ptr %t2917
}
define ptr @digest_block(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2918 = musttail call ptr @sha256g_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
ret ptr %t2918
}
define i64 @word_at_list(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2919 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t2920 = extractvalue {i64, i1} %t2919, 0
%t2921 = extractvalue {i64, i1} %t2919, 1
%t2922 = zext i1 %t2921 to i8
call void @resid_overflow_check(i8 %t2922)
%t2923 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t2920)
%t2924 = extractvalue {i64, i1} %t2923, 0
%t2925 = extractvalue {i64, i1} %t2923, 1
%t2926 = zext i1 %t2925 to i8
call void @resid_overflow_check(i8 %t2926)
%t2927 = call ptr @resid_list_get(ptr %p0, i64 %t2924)
%t2928 = call i64 @resid_unbox_i64(ptr %t2927)
%t2930 = and i64 %t2928, 255
%t2931 = shl i64 %t2930, 24
%t2932 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2924, i64 1)
%t2933 = extractvalue {i64, i1} %t2932, 0
%t2934 = extractvalue {i64, i1} %t2932, 1
%t2935 = zext i1 %t2934 to i8
call void @resid_overflow_check(i8 %t2935)
%t2936 = call ptr @resid_list_get(ptr %p0, i64 %t2933)
%t2937 = call i64 @resid_unbox_i64(ptr %t2936)
%t2939 = and i64 %t2937, 255
%t2940 = shl i64 %t2939, 16
%t2941 = or i64 %t2931, %t2940
%t2942 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2924, i64 2)
%t2943 = extractvalue {i64, i1} %t2942, 0
%t2944 = extractvalue {i64, i1} %t2942, 1
%t2945 = zext i1 %t2944 to i8
call void @resid_overflow_check(i8 %t2945)
%t2946 = call ptr @resid_list_get(ptr %p0, i64 %t2943)
%t2947 = call i64 @resid_unbox_i64(ptr %t2946)
%t2949 = and i64 %t2947, 255
%t2950 = shl i64 %t2949, 8
%t2951 = or i64 %t2941, %t2950
%t2952 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2924, i64 3)
%t2953 = extractvalue {i64, i1} %t2952, 0
%t2954 = extractvalue {i64, i1} %t2952, 1
%t2955 = zext i1 %t2954 to i8
call void @resid_overflow_check(i8 %t2955)
%t2956 = call ptr @resid_list_get(ptr %p0, i64 %t2953)
%t2957 = call i64 @resid_unbox_i64(ptr %t2956)
%t2959 = and i64 %t2957, 255
%t2960 = or i64 %t2951, %t2959
%t2961 = and i64 %t2960, 4294967295
ret i64 %t2961
}
define ptr @digest_blocks(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2969, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t2962 = icmp sge i64 %p1, %p2
br i1 %t2962, label %L349, label %L351
L349:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L351:
%t2963 = call i8 @resid_cpu_has_sha256()
%t2964 = icmp ne i8 %t2963, 0
br i1 %t2964, label %L352, label %L354
L352:
%t2965 = call i256 @sha_hw_state(ptr %p3, i64 0, i256 0)
%t2966 = call ptr @sha_hw_blocks(ptr %p0, i64 %p1, i64 %p2, i256 %t2965)
%lr.cx19 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz19 = icmp eq ptr %lr.cx19, null
br i1 %lr.lz19, label %lr.x19.k, label %lr.x19.m
lr.x19.k:
ret ptr %t2966
lr.x19.m:
%lr.ret19 = call ptr @resid_mv_list(ptr %t2966, ptr %lr.cx19)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret19
L354:
%t2967 = call ptr @digest_block(ptr %p0, i64 %p1, ptr %p3)
%t2968 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t2969 = extractvalue {i64, i1} %t2968, 0
%t2970 = extractvalue {i64, i1} %t2968, 1
%t2971 = zext i1 %t2970 to i8
call void @resid_overflow_check(i8 %t2971)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t2967, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t2967, %tco.s0 ]
br label %tco.head
}
define i256 @sha_hw_state(ptr %p0.in, i64 %p1.in, i256 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2974, %tco.s0 ]
%p2 = phi i256 [ %p2.in, %entry ], [ %t3001, %tco.s0 ]
%t2973 = icmp sge i64 %p1, 8
br i1 %t2973, label %L355, label %L357
L355:
ret i256 %p2
L357:
%t2974 = add nsw i64 %p1, 1
%t2975 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t2976 = call i64 @resid_unbox_i64(ptr %t2975)
%t2978 = and i64 %t2976, 4294967295
%t2979 = sext i64 %t2978 to i256
%t2980 = add i256 %t2979, 0
%t2981 = add i256 %t2980, 0
%t2982 = icmp ne i256 %t2981, %t2979
%t2983 = icmp slt i64 %t2978, 0
%t2984 = or i1 %t2982, %t2983
%t2985 = zext i1 %t2984 to i8
call void @resid_conv_check(i8 %t2985)
%t2986 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 32, i64 %p1)
%t2987 = extractvalue {i64, i1} %t2986, 0
%t2988 = extractvalue {i64, i1} %t2986, 1
%t2989 = zext i1 %t2988 to i8
call void @resid_overflow_check(i8 %t2989)
%t2990 = sext i64 %t2987 to i256
%t2991 = add i256 %t2990, 0
%t2992 = add i256 %t2991, 0
%t2993 = icmp ne i256 %t2992, %t2990
%t2994 = icmp slt i64 %t2987, 0
%t2995 = or i1 %t2993, %t2994
%t2996 = zext i1 %t2995 to i8
call void @resid_conv_check(i8 %t2996)
%t2997 = icmp uge i256 %t2991, 256
%t2998 = add i256 %t2991, 0
%t2999 = shl i256 %t2980, %t2998
%t3000 = select i1 %t2997, i256 0, i256 %t2999
%t3001 = or i256 %p2, %t3000
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @sha_hw_words(i256 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i256 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3005, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t3026, %tco.s0 ]
%t3003 = icmp sge i64 %p1, 8
br i1 %t3003, label %L358, label %L360
L358:
%t3004 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty3004)
ret ptr %t3004
L360:
%t3005 = add nsw i64 %p1, 1
%t3006 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 32, i64 %p1)
%t3007 = extractvalue {i64, i1} %t3006, 0
%t3008 = extractvalue {i64, i1} %t3006, 1
%t3009 = zext i1 %t3008 to i8
call void @resid_overflow_check(i8 %t3009)
%t3010 = sext i64 %t3007 to i256
%t3011 = add i256 %t3010, 0
%t3012 = add i256 %t3011, 0
%t3013 = icmp ne i256 %t3012, %t3010
%t3014 = icmp slt i64 %t3007, 0
%t3015 = or i1 %t3013, %t3014
%t3016 = zext i1 %t3015 to i8
call void @resid_conv_check(i8 %t3016)
%t3017 = icmp uge i256 %t3011, 256
%t3018 = add i256 %t3011, 0
%t3019 = lshr i256 %p0, %t3018
%t3020 = select i1 %t3017, i256 0, i256 %t3019
%t3021 = and i256 %t3020, 4294967295
%t3022 = trunc i256 %t3021 to i64
%t3023 = call ptr @resid_box_i64(i64 %t3022)
%t3026 = call ptr @resid_listbuf_push(ptr %p2, ptr %t3023)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @sha_hw_block(ptr %p0.in, i64 %p1.in, i64 %p2.in, i512 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3029, %tco.s0 ]
%p3 = phi i512 [ %p3.in, %entry ], [ %t3053, %tco.s0 ]
%t3028 = icmp sge i64 %p2, 16
br i1 %t3028, label %L361, label %L363
L361:
ret i512 %p3
L363:
%t3029 = add nsw i64 %p2, 1
%t3030 = call i64 @word_at_list(ptr %p0, i64 %p1, i64 %p2)
%t3031 = sext i64 %t3030 to i512
%t3032 = add i512 %t3031, 0
%t3033 = add i512 %t3032, 0
%t3034 = icmp ne i512 %t3033, %t3031
%t3035 = icmp slt i64 %t3030, 0
%t3036 = or i1 %t3034, %t3035
%t3037 = zext i1 %t3036 to i8
call void @resid_conv_check(i8 %t3037)
%t3038 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 32, i64 %p2)
%t3039 = extractvalue {i64, i1} %t3038, 0
%t3040 = extractvalue {i64, i1} %t3038, 1
%t3041 = zext i1 %t3040 to i8
call void @resid_overflow_check(i8 %t3041)
%t3042 = sext i64 %t3039 to i512
%t3043 = add i512 %t3042, 0
%t3044 = add i512 %t3043, 0
%t3045 = icmp ne i512 %t3044, %t3042
%t3046 = icmp slt i64 %t3039, 0
%t3047 = or i1 %t3045, %t3046
%t3048 = zext i1 %t3047 to i8
call void @resid_conv_check(i8 %t3048)
%t3049 = icmp uge i512 %t3043, 512
%t3050 = add i512 %t3043, 0
%t3051 = shl i512 %t3032, %t3050
%t3052 = select i1 %t3049, i512 0, i512 %t3051
%t3053 = or i512 %p3, %t3052
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @sha_hw_block_str(ptr %p0.in, i64 %p1.in, i64 %p2.in, i512 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3056, %tco.s0 ]
%p3 = phi i512 [ %p3.in, %entry ], [ %t3080, %tco.s0 ]
%t3055 = icmp sge i64 %p2, 16
br i1 %t3055, label %L364, label %L366
L364:
ret i512 %p3
L366:
%t3056 = add nsw i64 %p2, 1
%t3057 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 %p2)
%t3058 = sext i64 %t3057 to i512
%t3059 = add i512 %t3058, 0
%t3060 = add i512 %t3059, 0
%t3061 = icmp ne i512 %t3060, %t3058
%t3062 = icmp slt i64 %t3057, 0
%t3063 = or i1 %t3061, %t3062
%t3064 = zext i1 %t3063 to i8
call void @resid_conv_check(i8 %t3064)
%t3065 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 32, i64 %p2)
%t3066 = extractvalue {i64, i1} %t3065, 0
%t3067 = extractvalue {i64, i1} %t3065, 1
%t3068 = zext i1 %t3067 to i8
call void @resid_overflow_check(i8 %t3068)
%t3069 = sext i64 %t3066 to i512
%t3070 = add i512 %t3069, 0
%t3071 = add i512 %t3070, 0
%t3072 = icmp ne i512 %t3071, %t3069
%t3073 = icmp slt i64 %t3066, 0
%t3074 = or i1 %t3072, %t3073
%t3075 = zext i1 %t3074 to i8
call void @resid_conv_check(i8 %t3075)
%t3076 = icmp uge i512 %t3070, 512
%t3077 = add i512 %t3070, 0
%t3078 = shl i512 %t3059, %t3077
%t3079 = select i1 %t3076, i512 0, i512 %t3078
%t3080 = or i512 %p3, %t3079
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @sha_hw_blocks(ptr %p0.in, i64 %p1.in, i64 %p2.in, i256 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3086, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi i256 [ %p3.in, %entry ], [ %t3090, %tco.s0.k ]
%t3082 = icmp sge i64 %p1, %p2
br i1 %t3082, label %L367, label %L369
L367:
%t3083 = call ptr @resid_listbuf_new()
%t3084 = call ptr @sha_hw_words__rs174(i256 %p3, i64 0, ptr %t3083)
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %t3084
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %t3084, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L369:
%t3085 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t3086 = extractvalue {i64, i1} %t3085, 0
%t3087 = extractvalue {i64, i1} %t3085, 1
%t3088 = zext i1 %t3087 to i8
call void @resid_overflow_check(i8 %t3088)
%t3089 = call i512 @sha_hw_block(ptr %p0, i64 %p1, i64 0, i512 0)
%t3090 = call i256 @e.sha256(i256 %p3, i512 %t3089)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
br label %tco.head
}
define ptr @sha_hw_blocks_str(ptr %p0.in, i64 %p1.in, i64 %p2.in, i256 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3096, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi i256 [ %p3.in, %entry ], [ %t3100, %tco.s0.k ]
%t3092 = icmp sge i64 %p1, %p2
br i1 %t3092, label %L370, label %L372
L370:
%t3093 = call ptr @resid_listbuf_new()
%t3094 = call ptr @sha_hw_words__rs174(i256 %p3, i64 0, ptr %t3093)
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %t3094
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %t3094, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L372:
%t3095 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t3096 = extractvalue {i64, i1} %t3095, 0
%t3097 = extractvalue {i64, i1} %t3095, 1
%t3098 = zext i1 %t3097 to i8
call void @resid_overflow_check(i8 %t3098)
%t3099 = call i512 @sha_hw_block_str(ptr %p0, i64 %p1, i64 0, i512 0)
%t3100 = call i256 @e.sha256(i256 %p3, i512 %t3099)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
br label %tco.head
}
define ptr @hex_digit(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3102 = icmp slt i64 %p0, 10
br i1 %t3102, label %L373, label %L375
L373:
%t3103 = add nsw i64 %p0, 48
%t3104 = musttail call ptr @str_from_code(i64 %t3103)
ret ptr %t3104
L375:
%t3105 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p0, i64 87)
%t3106 = extractvalue {i64, i1} %t3105, 0
%t3107 = extractvalue {i64, i1} %t3105, 1
%t3108 = zext i1 %t3107 to i8
call void @resid_overflow_check(i8 %t3108)
%t3109 = musttail call ptr @str_from_code(i64 %t3106)
ret ptr %t3109
}
define ptr @hex_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3110 = ashr i64 %p0, 4
%t3111 = call ptr @hex_digit(i64 %t3110)
%t3112 = and i64 %p0, 15
%t3113 = call ptr @hex_digit(i64 %t3112)
%t3114 = call ptr @resid_str_concat(ptr %t3111, ptr %t3113)
ret ptr %t3114
}
define ptr @hex_word(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3115 = ashr i64 %p0, 24
%t3116 = call ptr @hex_byte(i64 %t3115)
%t3117 = and i64 %p0, 16711680
%t3118 = ashr i64 %t3117, 16
%t3119 = call ptr @hex_byte(i64 %t3118)
%t3120 = call ptr @resid_str_concat(ptr %t3116, ptr %t3119)
%t3121 = and i64 %p0, 65280
%t3122 = ashr i64 %t3121, 8
%t3123 = call ptr @hex_byte(i64 %t3122)
%t3124 = call ptr @resid_str_concat(ptr %t3120, ptr %t3123)
%t3125 = and i64 %p0, 255
%t3126 = call ptr @hex_byte(i64 %t3125)
%t3127 = call ptr @resid_str_concat(ptr %t3124, ptr %t3126)
ret ptr %t3127
}
define ptr @hex_state(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3134, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t3133, %tco.s0 ]
%t3128 = icmp sge i64 %p1, 8
br i1 %t3128, label %L376, label %L378
L376:
ret ptr %p2
L378:
%t3129 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3130 = call i64 @resid_unbox_i64(ptr %t3129)
%t3132 = call ptr @hex_word(i64 %t3130)
%t3133 = call ptr @resid_str_concat(ptr %p2, ptr %t3132)
%t3134 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bw_acc_str(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3159 = alloca [1 x ptr]
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3166, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3136 = icmp sge i64 %p2, 16
br i1 %t3136, label %L379, label %L381
L379:
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %p3
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L381:
%t3137 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t3138 = extractvalue {i64, i1} %t3137, 0
%t3139 = extractvalue {i64, i1} %t3137, 1
%t3140 = zext i1 %t3139 to i8
call void @resid_overflow_check(i8 %t3140)
%t3141 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t3138)
%t3142 = extractvalue {i64, i1} %t3141, 0
%t3143 = extractvalue {i64, i1} %t3141, 1
%t3144 = zext i1 %t3143 to i8
call void @resid_overflow_check(i8 %t3144)
%t3145 = call i64 @resid_char_at_n(ptr %p0, i64 %t3142, i64 %p0.alen)
%t3146 = add nsw i64 %t3142, 1
%t3147 = call i64 @resid_char_at_n(ptr %p0, i64 %t3146, i64 %p0.alen)
%t3148 = add nsw i64 %t3142, 2
%t3149 = call i64 @resid_char_at_n(ptr %p0, i64 %t3148, i64 %p0.alen)
%t3150 = add nsw i64 %t3142, 3
%t3151 = call i64 @resid_char_at_n(ptr %p0, i64 %t3150, i64 %p0.alen)
%t3152 = shl i64 %t3145, 24
%t3153 = shl i64 %t3147, 16
%t3154 = shl i64 %t3149, 8
%t3155 = or i64 %t3152, %t3153
%t3156 = or i64 %t3155, %t3154
%t3157 = or i64 %t3156, %t3151
%t3158 = and i64 %t3157, 4294967295
%t3161 = call ptr @resid_box_i64(i64 %t3158)
%t3163 = getelementptr i8, ptr %t3159, i64 0
store ptr %t3161, ptr %t3163
%t3164 = call ptr @resid_list_new(i64 1, ptr %t3159, ptr @.lty3159)
%t3165 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3164)
%t3166 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3165, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3165, %tco.s0 ]
br label %tco.head
}
define i64 @word_at_str(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3168 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t3169 = extractvalue {i64, i1} %t3168, 0
%t3170 = extractvalue {i64, i1} %t3168, 1
%t3171 = zext i1 %t3170 to i8
call void @resid_overflow_check(i8 %t3171)
%t3172 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t3169)
%t3173 = extractvalue {i64, i1} %t3172, 0
%t3174 = extractvalue {i64, i1} %t3172, 1
%t3175 = zext i1 %t3174 to i8
call void @resid_overflow_check(i8 %t3175)
%t3176 = call i64 @str_char_at(ptr %p0, i64 %t3173)
%t3177 = add nsw i64 %t3173, 1
%t3178 = call i64 @str_char_at(ptr %p0, i64 %t3177)
%t3179 = add nsw i64 %t3173, 2
%t3180 = call i64 @str_char_at(ptr %p0, i64 %t3179)
%t3181 = add nsw i64 %t3173, 3
%t3182 = call i64 @str_char_at(ptr %p0, i64 %t3181)
%t3183 = shl i64 %t3176, 24
%t3184 = shl i64 %t3178, 16
%t3185 = shl i64 %t3180, 8
%t3186 = or i64 %t3183, %t3184
%t3187 = or i64 %t3186, %t3185
%t3188 = or i64 %t3187, %t3182
%t3189 = and i64 %t3188, 4294967295
ret i64 %t3189
}
define i64 @ssig0(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3190 = call i64 @rotr(i64 %p0, i64 7)
%t3191 = call i64 @rotr(i64 %p0, i64 18)
%t3192 = ashr i64 %p0, 3
%t3193 = xor i64 %t3190, %t3191
%t3194 = xor i64 %t3193, %t3192
ret i64 %t3194
}
define i64 @ssig1(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3195 = call i64 @rotr(i64 %p0, i64 17)
%t3196 = call i64 @rotr(i64 %p0, i64 19)
%t3197 = ashr i64 %p0, 10
%t3198 = xor i64 %t3195, %t3196
%t3199 = xor i64 %t3198, %t3197
ret i64 %t3199
}
define i64 @bsig0(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3200 = call i64 @rotr(i64 %p0, i64 2)
%t3201 = call i64 @rotr(i64 %p0, i64 13)
%t3202 = call i64 @rotr(i64 %p0, i64 22)
%t3203 = xor i64 %t3200, %t3201
%t3204 = xor i64 %t3203, %t3202
ret i64 %t3204
}
define i64 @bsig1(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3205 = call i64 @rotr(i64 %p0, i64 6)
%t3206 = call i64 @rotr(i64 %p0, i64 11)
%t3207 = call i64 @rotr(i64 %p0, i64 25)
%t3208 = xor i64 %t3205, %t3206
%t3209 = xor i64 %t3208, %t3207
ret i64 %t3209
}
define i64 @maj_of(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3210 = and i64 %p0, %p1
%t3211 = and i64 %p0, %p2
%t3212 = and i64 %p1, %p2
%t3213 = xor i64 %t3210, %t3211
%t3214 = xor i64 %t3213, %t3212
ret i64 %t3214
}
define i64 @sched_w(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3215 = icmp slt i64 %p2, 16
br i1 %t3215, label %L382, label %L384
L382:
%t3216 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 %p2)
ret i64 %t3216
L384:
%t3217 = call i64 @ssig1(i64 %p6)
%t3218 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3217, i64 %p5)
%t3219 = extractvalue {i64, i1} %t3218, 0
%t3220 = extractvalue {i64, i1} %t3218, 1
%t3221 = zext i1 %t3220 to i8
call void @resid_overflow_check(i8 %t3221)
%t3222 = call i64 @ssig0(i64 %p4)
%t3223 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3222, i64 %p3)
%t3224 = extractvalue {i64, i1} %t3223, 0
%t3225 = extractvalue {i64, i1} %t3223, 1
%t3226 = zext i1 %t3225 to i8
call void @resid_overflow_check(i8 %t3226)
%t3227 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3219, i64 %t3224)
%t3228 = extractvalue {i64, i1} %t3227, 0
%t3229 = extractvalue {i64, i1} %t3227, 1
%t3230 = zext i1 %t3229 to i8
call void @resid_overflow_check(i8 %t3230)
%t3231 = and i64 %t3228, 4294967295
ret i64 %t3231
}
define ptr @sha_blk(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in, i64 %p19.in, i64 %p20.in, i64 %p21.in, i64 %p22.in, i64 %p23.in, i64 %p24.in, i64 %p25.in, i64 %p26.in, i64 %p27.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3297 = alloca [8 x ptr]
%p3.ld = call ptr @resid_list_vdata(ptr %p3.in)
%p3.ln = call i64 @resid_list_vlen(ptr %p3.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3360, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t3354, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t3359, %tco.s0.k ]
%p9 = phi i64 [ %p9.in, %entry ], [ %p8, %tco.s0.k ]
%p10 = phi i64 [ %p10.in, %entry ], [ %p9, %tco.s0.k ]
%p11 = phi i64 [ %p11.in, %entry ], [ %p10, %tco.s0.k ]
%p12 = phi i64 [ %p12.in, %entry ], [ %p13, %tco.s0.k ]
%p13 = phi i64 [ %p13.in, %entry ], [ %p14, %tco.s0.k ]
%p14 = phi i64 [ %p14.in, %entry ], [ %p15, %tco.s0.k ]
%p15 = phi i64 [ %p15.in, %entry ], [ %p16, %tco.s0.k ]
%p16 = phi i64 [ %p16.in, %entry ], [ %p17, %tco.s0.k ]
%p17 = phi i64 [ %p17.in, %entry ], [ %p18, %tco.s0.k ]
%p18 = phi i64 [ %p18.in, %entry ], [ %p19, %tco.s0.k ]
%p19 = phi i64 [ %p19.in, %entry ], [ %p20, %tco.s0.k ]
%p20 = phi i64 [ %p20.in, %entry ], [ %p21, %tco.s0.k ]
%p21 = phi i64 [ %p21.in, %entry ], [ %p22, %tco.s0.k ]
%p22 = phi i64 [ %p22.in, %entry ], [ %p23, %tco.s0.k ]
%p23 = phi i64 [ %p23.in, %entry ], [ %p24, %tco.s0.k ]
%p24 = phi i64 [ %p24.in, %entry ], [ %p25, %tco.s0.k ]
%p25 = phi i64 [ %p25.in, %entry ], [ %p26, %tco.s0.k ]
%p26 = phi i64 [ %p26.in, %entry ], [ %p27, %tco.s0.k ]
%p27 = phi i64 [ %p27.in, %entry ], [ %t3324, %tco.s0.k ]
%t3232 = icmp sge i64 %p2, 64
br i1 %t3232, label %L385, label %L387
L385:
%t3233 = call ptr @resid_list_get_v(ptr %p3, i64 0, ptr %p3.ld, i64 %p3.ln)
%t3234 = call i64 @resid_unbox_i64(ptr %t3233)
%t3236 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3234, i64 %p4)
%t3237 = extractvalue {i64, i1} %t3236, 0
%t3238 = extractvalue {i64, i1} %t3236, 1
%t3239 = zext i1 %t3238 to i8
call void @resid_overflow_check(i8 %t3239)
%t3240 = and i64 %t3237, 4294967295
%t3241 = call ptr @resid_list_get_v(ptr %p3, i64 1, ptr %p3.ld, i64 %p3.ln)
%t3242 = call i64 @resid_unbox_i64(ptr %t3241)
%t3244 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3242, i64 %p5)
%t3245 = extractvalue {i64, i1} %t3244, 0
%t3246 = extractvalue {i64, i1} %t3244, 1
%t3247 = zext i1 %t3246 to i8
call void @resid_overflow_check(i8 %t3247)
%t3248 = and i64 %t3245, 4294967295
%t3249 = call ptr @resid_list_get_v(ptr %p3, i64 2, ptr %p3.ld, i64 %p3.ln)
%t3250 = call i64 @resid_unbox_i64(ptr %t3249)
%t3252 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3250, i64 %p6)
%t3253 = extractvalue {i64, i1} %t3252, 0
%t3254 = extractvalue {i64, i1} %t3252, 1
%t3255 = zext i1 %t3254 to i8
call void @resid_overflow_check(i8 %t3255)
%t3256 = and i64 %t3253, 4294967295
%t3257 = call ptr @resid_list_get_v(ptr %p3, i64 3, ptr %p3.ld, i64 %p3.ln)
%t3258 = call i64 @resid_unbox_i64(ptr %t3257)
%t3260 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3258, i64 %p7)
%t3261 = extractvalue {i64, i1} %t3260, 0
%t3262 = extractvalue {i64, i1} %t3260, 1
%t3263 = zext i1 %t3262 to i8
call void @resid_overflow_check(i8 %t3263)
%t3264 = and i64 %t3261, 4294967295
%t3265 = call ptr @resid_list_get_v(ptr %p3, i64 4, ptr %p3.ld, i64 %p3.ln)
%t3266 = call i64 @resid_unbox_i64(ptr %t3265)
%t3268 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3266, i64 %p8)
%t3269 = extractvalue {i64, i1} %t3268, 0
%t3270 = extractvalue {i64, i1} %t3268, 1
%t3271 = zext i1 %t3270 to i8
call void @resid_overflow_check(i8 %t3271)
%t3272 = and i64 %t3269, 4294967295
%t3273 = call ptr @resid_list_get_v(ptr %p3, i64 5, ptr %p3.ld, i64 %p3.ln)
%t3274 = call i64 @resid_unbox_i64(ptr %t3273)
%t3276 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3274, i64 %p9)
%t3277 = extractvalue {i64, i1} %t3276, 0
%t3278 = extractvalue {i64, i1} %t3276, 1
%t3279 = zext i1 %t3278 to i8
call void @resid_overflow_check(i8 %t3279)
%t3280 = and i64 %t3277, 4294967295
%t3281 = call ptr @resid_list_get_v(ptr %p3, i64 6, ptr %p3.ld, i64 %p3.ln)
%t3282 = call i64 @resid_unbox_i64(ptr %t3281)
%t3284 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3282, i64 %p10)
%t3285 = extractvalue {i64, i1} %t3284, 0
%t3286 = extractvalue {i64, i1} %t3284, 1
%t3287 = zext i1 %t3286 to i8
call void @resid_overflow_check(i8 %t3287)
%t3288 = and i64 %t3285, 4294967295
%t3289 = call ptr @resid_list_get_v(ptr %p3, i64 7, ptr %p3.ld, i64 %p3.ln)
%t3290 = call i64 @resid_unbox_i64(ptr %t3289)
%t3292 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3290, i64 %p11)
%t3293 = extractvalue {i64, i1} %t3292, 0
%t3294 = extractvalue {i64, i1} %t3292, 1
%t3295 = zext i1 %t3294 to i8
call void @resid_overflow_check(i8 %t3295)
%t3296 = and i64 %t3293, 4294967295
%t3299 = call ptr @resid_box_i64(i64 %t3240)
%t3301 = getelementptr i8, ptr %t3297, i64 0
store ptr %t3299, ptr %t3301
%t3302 = call ptr @resid_box_i64(i64 %t3248)
%t3304 = getelementptr i8, ptr %t3297, i64 8
store ptr %t3302, ptr %t3304
%t3305 = call ptr @resid_box_i64(i64 %t3256)
%t3307 = getelementptr i8, ptr %t3297, i64 16
store ptr %t3305, ptr %t3307
%t3308 = call ptr @resid_box_i64(i64 %t3264)
%t3310 = getelementptr i8, ptr %t3297, i64 24
store ptr %t3308, ptr %t3310
%t3311 = call ptr @resid_box_i64(i64 %t3272)
%t3313 = getelementptr i8, ptr %t3297, i64 32
store ptr %t3311, ptr %t3313
%t3314 = call ptr @resid_box_i64(i64 %t3280)
%t3316 = getelementptr i8, ptr %t3297, i64 40
store ptr %t3314, ptr %t3316
%t3317 = call ptr @resid_box_i64(i64 %t3288)
%t3319 = getelementptr i8, ptr %t3297, i64 48
store ptr %t3317, ptr %t3319
%t3320 = call ptr @resid_box_i64(i64 %t3296)
%t3322 = getelementptr i8, ptr %t3297, i64 56
store ptr %t3320, ptr %t3322
%t3323 = call ptr @resid_list_new(i64 8, ptr %t3297, ptr @.lty3297)
%lr.cx127 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz127 = icmp eq ptr %lr.cx127, null
br i1 %lr.lz127, label %lr.x127.k, label %lr.x127.m
lr.x127.k:
ret ptr %t3323
lr.x127.m:
%lr.ret127 = call ptr @resid_mv_list(ptr %t3323, ptr %lr.cx127)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret127
L387:
%t3324 = call i64 @sched_w(ptr %p0, i64 %p1, i64 %p2, i64 %p12, i64 %p13, i64 %p21, i64 %p26)
%t3325 = call i64 @bsig1(i64 %p8)
%t3326 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t3325)
%t3327 = extractvalue {i64, i1} %t3326, 0
%t3328 = extractvalue {i64, i1} %t3326, 1
%t3329 = zext i1 %t3328 to i8
call void @resid_overflow_check(i8 %t3329)
%t3330 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t3331 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3327, i64 %t3330)
%t3332 = extractvalue {i64, i1} %t3331, 0
%t3333 = extractvalue {i64, i1} %t3331, 1
%t3334 = zext i1 %t3333 to i8
call void @resid_overflow_check(i8 %t3334)
%t3335 = call i64 @resid_scope_push()
%t3336 = call i64 @k_at(i64 %p2)
%t3337 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3332, i64 %t3336)
%t3338 = extractvalue {i64, i1} %t3337, 0
%t3339 = extractvalue {i64, i1} %t3337, 1
%t3340 = zext i1 %t3339 to i8
call void @resid_overflow_check(i8 %t3340)
call void @resid_scope_pop(i64 %t3335)
%t3341 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3338, i64 %t3324)
%t3342 = extractvalue {i64, i1} %t3341, 0
%t3343 = extractvalue {i64, i1} %t3341, 1
%t3344 = zext i1 %t3343 to i8
call void @resid_overflow_check(i8 %t3344)
%t3345 = and i64 %t3342, 4294967295
%t3346 = call i64 @bsig0(i64 %p4)
%t3347 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t3348 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3346, i64 %t3347)
%t3349 = extractvalue {i64, i1} %t3348, 0
%t3350 = extractvalue {i64, i1} %t3348, 1
%t3351 = zext i1 %t3350 to i8
call void @resid_overflow_check(i8 %t3351)
%t3352 = and i64 %t3349, 4294967295
%t3353 = add nsw i64 %t3345, %t3352
%t3354 = and i64 %t3353, 4294967295
%t3355 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t3345)
%t3356 = extractvalue {i64, i1} %t3355, 0
%t3357 = extractvalue {i64, i1} %t3355, 1
%t3358 = zext i1 %t3357 to i8
call void @resid_overflow_check(i8 %t3358)
%t3359 = and i64 %t3356, 4294967295
%t3360 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %p3, %tco.s0 ]
br label %tco.head
}
define ptr @digest_block_str(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3362 = call ptr @resid_list_get(ptr %p2, i64 0)
%t3363 = call i64 @resid_unbox_i64(ptr %t3362)
%t3365 = call ptr @resid_list_get(ptr %p2, i64 1)
%t3366 = call i64 @resid_unbox_i64(ptr %t3365)
%t3368 = call ptr @resid_list_get(ptr %p2, i64 2)
%t3369 = call i64 @resid_unbox_i64(ptr %t3368)
%t3371 = call ptr @resid_list_get(ptr %p2, i64 3)
%t3372 = call i64 @resid_unbox_i64(ptr %t3371)
%t3374 = call ptr @resid_list_get(ptr %p2, i64 4)
%t3375 = call i64 @resid_unbox_i64(ptr %t3374)
%t3377 = call ptr @resid_list_get(ptr %p2, i64 5)
%t3378 = call i64 @resid_unbox_i64(ptr %t3377)
%t3380 = call ptr @resid_list_get(ptr %p2, i64 6)
%t3381 = call i64 @resid_unbox_i64(ptr %t3380)
%t3383 = call ptr @resid_list_get(ptr %p2, i64 7)
%t3384 = call i64 @resid_unbox_i64(ptr %t3383)
%t3386 = call ptr @sha_blk__rs183(ptr %p0, i64 %p1, i64 0, ptr %p2, i64 %t3363, i64 %t3366, i64 %t3369, i64 %t3372, i64 %t3375, i64 %t3378, i64 %t3381, i64 %t3384, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
ret ptr %t3386
}
define ptr @digest_blocks_str(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3394, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3387 = icmp sge i64 %p1, %p2
br i1 %t3387, label %L388, label %L390
L388:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L390:
%t3388 = call i8 @resid_cpu_has_sha256()
%t3389 = icmp ne i8 %t3388, 0
br i1 %t3389, label %L391, label %L393
L391:
%t3390 = call i256 @sha_hw_state(ptr %p3, i64 0, i256 0)
%t3391 = call ptr @sha_hw_blocks_str(ptr %p0, i64 %p1, i64 %p2, i256 %t3390)
%lr.cx19 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz19 = icmp eq ptr %lr.cx19, null
br i1 %lr.lz19, label %lr.x19.k, label %lr.x19.m
lr.x19.k:
ret ptr %t3391
lr.x19.m:
%lr.ret19 = call ptr @resid_mv_list(ptr %t3391, ptr %lr.cx19)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret19
L393:
%t3392 = call ptr @digest_block_str(ptr %p0, i64 %p1, ptr %p3)
%t3393 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t3394 = extractvalue {i64, i1} %t3393, 0
%t3395 = extractvalue {i64, i1} %t3393, 1
%t3396 = zext i1 %t3395 to i8
call void @resid_overflow_check(i8 %t3396)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3392, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3392, %tco.s0 ]
br label %tco.head
}
define ptr @str_bytes_range(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3400 = alloca [1 x ptr]
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3407, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3398 = icmp sge i64 %p1, %p2
br i1 %t3398, label %L394, label %L396
L394:
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %p3
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L396:
%t3399 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t3402 = call ptr @resid_box_i64(i64 %t3399)
%t3404 = getelementptr i8, ptr %t3400, i64 0
store ptr %t3402, ptr %t3404
%t3405 = call ptr @resid_list_new(i64 1, ptr %t3400, ptr @.lty3400)
%t3406 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3405)
%t3407 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3406, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3406, %tco.s0 ]
br label %tco.head
}
define ptr @pad_tail(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3409 = call i64 @resid_list_len(ptr %p0)
%t3411 = call ptr @resid_list_const_i64(ptr @.lc3410, i64 1, ptr @.lcd3410, ptr @.lty3410)
%t3412 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t3411)
%t3413 = add nsw i64 %t3409, 9
%t3414 = add nsw i64 %t3413, 63
%t3415 = sdiv i64 %t3414, 64
%t3416 = mul nsw i64 %t3415, 64
%t3417 = sub nsw i64 %t3416, %t3413
%t3418 = call ptr @zeros_l(ptr %t3412, i64 %t3417)
%t3419 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t3420 = extractvalue {i64, i1} %t3419, 0
%t3421 = extractvalue {i64, i1} %t3419, 1
%t3422 = zext i1 %t3421 to i8
call void @resid_overflow_check(i8 %t3422)
%t3423 = call ptr @length_bytes__rs146(i64 %t3420, i64 7, ptr %t3418)
ret ptr %t3423
}
define ptr @sha256(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3424 = call i1 @str_is_ascii(ptr %p0, i64 0)
%t3425 = xor i1 %t3424, true
br i1 %t3425, label %L397, label %L399
L397:
%t3426 = call ptr @bytes_of(ptr %p0)
%t3427 = call ptr @sha256_bytes(ptr %t3426)
%t3428 = musttail call ptr @hex_encode(ptr %t3427)
ret ptr %t3428
L399:
%t3429 = musttail call ptr @__m____________lib_crypto_resid__sha256_ascii(ptr %p0)
ret ptr %t3429
}
define ptr @__m____________lib_crypto_resid__sha256_ascii(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3430 = call i64 @str_len(ptr %p0)
%t3431 = sdiv i64 %t3430, 64
%t3432 = mul nsw i64 %t3431, 64
%t3434 = call ptr @resid_list_const_i64(ptr @.lc3433, i64 8, ptr @.lcd3433, ptr @.lty3433)
%t3435 = call ptr @digest_blocks_str(ptr %p0, i64 0, i64 %t3432, ptr %t3434)
%t3437 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3436)
%t3438 = call ptr @str_bytes_range(ptr %p0, i64 %t3432, i64 %t3430, ptr %t3437)
%t3439 = call ptr @pad_tail(ptr %t3438, i64 %t3430)
%t3440 = call i64 @resid_list_len(ptr %t3439)
%t3441 = call ptr @digest_blocks(ptr %t3439, i64 0, i64 %t3440, ptr %t3435)
%t3443 = call ptr @hex_state__rs227(ptr %t3441, i64 0, ptr @.s3442)
ret ptr %t3443
}
define i64 @word_byte(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3444 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 3, i64 %p2)
%t3445 = extractvalue {i64, i1} %t3444, 0
%t3446 = extractvalue {i64, i1} %t3444, 1
%t3447 = zext i1 %t3446 to i8
call void @resid_overflow_check(i8 %t3447)
%t3448 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t3445, i64 8)
%t3449 = extractvalue {i64, i1} %t3448, 0
%t3450 = extractvalue {i64, i1} %t3448, 1
%t3451 = zext i1 %t3450 to i8
call void @resid_overflow_check(i8 %t3451)
%t3452 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t3453 = call i64 @resid_unbox_i64(ptr %t3452)
%t3455 = icmp uge i64 %t3449, 64
%t3456 = add i64 %t3449, 0
%t3457 = select i1 %t3455, i64 63, i64 %t3456
%t3458 = ashr i64 %t3453, %t3457
%t3459 = and i64 %t3458, 255
ret i64 %t3459
}
define ptr @wtb_inner(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3462 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3469, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3460 = icmp sgt i64 %p2, 3
br i1 %t3460, label %L400, label %L402
L400:
%lr.cx12 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz12 = icmp eq ptr %lr.cx12, null
br i1 %lr.lz12, label %lr.x12.k, label %lr.x12.m
lr.x12.k:
ret ptr %p3
lr.x12.m:
%lr.ret12 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx12)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret12
L402:
%t3461 = call i64 @word_byte(ptr %p0, i64 %p1, i64 %p2)
%t3464 = call ptr @resid_box_i64(i64 %t3461)
%t3466 = getelementptr i8, ptr %t3462, i64 0
store ptr %t3464, ptr %t3466
%t3467 = call ptr @resid_list_new(i64 1, ptr %t3462, ptr @.lty3462)
%t3468 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3467)
%t3469 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3468, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3468, %tco.s0 ]
br label %tco.head
}
define ptr @wtb_outer(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3473, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t3471 = icmp sgt i64 %p1, 7
br i1 %t3471, label %L403, label %L405
L403:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr %p2
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L405:
%t3472 = call ptr @wtb_inner__rs229(ptr %p0, i64 %p1, i64 0, ptr %p2)
%t3473 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t3472, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t3472, %tco.s0 ]
br label %tco.head
}
define ptr @words_to_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3476 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3475)
%t3477 = call ptr @wtb_outer__rs231(ptr %p0, i64 0, ptr %t3476)
ret ptr %t3477
}
define ptr @sha256_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3478 = call i64 @resid_list_len(ptr %p0)
%t3479 = sdiv i64 %t3478, 64
%t3480 = mul nsw i64 %t3479, 64
%t3482 = call ptr @resid_list_const_i64(ptr @.lc3481, i64 8, ptr @.lcd3481, ptr @.lty3481)
%t3483 = call ptr @digest_blocks(ptr %p0, i64 0, i64 %t3480, ptr %t3482)
%t3484 = call i64 @resid_list_len(ptr %p0)
%t3485 = call ptr @resid_list_slice(ptr %p0, i64 %t3480, i64 %t3484)
%t3487 = call ptr @pad_tail(ptr %t3485, i64 %t3478)
%t3488 = call i64 @resid_list_len(ptr %t3487)
%t3489 = call ptr @digest_blocks(ptr %t3487, i64 0, i64 %t3488, ptr %t3483)
%t3490 = musttail call ptr @words_to_bytes(ptr %t3489)
ret ptr %t3490
}
define ptr @hex_range(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3497, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t3496, %tco.s0 ]
%t3491 = icmp sge i64 %p1, %p2
br i1 %t3491, label %L406, label %L408
L406:
ret ptr %p3
L408:
%t3492 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3493 = call i64 @resid_unbox_i64(ptr %t3492)
%t3495 = call ptr @hex_byte(i64 %t3493)
%t3496 = call ptr @resid_str_concat(ptr %p3, ptr %t3495)
%t3497 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @hex_encode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3499 = call i64 @resid_list_len(ptr %p0)
%t3501 = call ptr @hex_range(ptr %p0, i64 0, i64 %t3499, ptr @.s3500)
ret ptr %t3501
}
define ptr @__m____________lib_crypto_resid__sc_acc(ptr %p0.in, ptr %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3507 = alloca [1 x ptr]
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3514, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3502 = call i64 @resid_list_len(ptr %p1)
%t3503 = icmp sge i64 %p2, %t3502
br i1 %t3503, label %L409, label %L411
L409:
%lr.cx15 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz15 = icmp eq ptr %lr.cx15, null
br i1 %lr.lz15, label %lr.x15.k, label %lr.x15.m
lr.x15.k:
ret ptr %p3
lr.x15.m:
%lr.ret15 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx15)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret15
L411:
%t3504 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t3505 = call i64 @resid_unbox_i64(ptr %t3504)
%t3509 = call ptr @resid_box_i64(i64 %t3505)
%t3511 = getelementptr i8, ptr %t3507, i64 0
store ptr %t3509, ptr %t3511
%t3512 = call ptr @resid_list_new(i64 1, ptr %t3507, ptr @.lty3507)
%t3513 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3512)
%t3514 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3513, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3513, %tco.s0 ]
br label %tco.head
}
define ptr @sconcat(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3516 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %p1)
ret ptr %t3516
}
define i64 @byte_at_or0(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3517 = call i64 @resid_list_len(ptr %p0)
%t3518 = icmp slt i64 %p1, %t3517
br i1 %t3518, label %L412, label %L414
L412:
%t3519 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t3520 = call i64 @resid_unbox_i64(ptr %t3519)
ret i64 %t3520
L414:
ret i64 0
}
define ptr @xor_lists(ptr %p0.in, ptr %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3530 = alloca [1 x ptr]
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3537, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3522 = call i64 @resid_list_len(ptr %p1)
%t3523 = icmp sge i64 %p2, %t3522
br i1 %t3523, label %L415, label %L417
L415:
%lr.cx15 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz15 = icmp eq ptr %lr.cx15, null
br i1 %lr.lz15, label %lr.x15.k, label %lr.x15.m
lr.x15.k:
ret ptr %p3
lr.x15.m:
%lr.ret15 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx15)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret15
L417:
%t3524 = call i64 @byte_at_or0(ptr %p0, i64 %p2)
%t3525 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t3526 = call i64 @resid_unbox_i64(ptr %t3525)
%t3528 = xor i64 %t3524, %t3526
%t3529 = and i64 %t3528, 255
%t3532 = call ptr @resid_box_i64(i64 %t3529)
%t3534 = getelementptr i8, ptr %t3530, i64 0
store ptr %t3532, ptr %t3534
%t3535 = call ptr @resid_list_new(i64 1, ptr %t3530, ptr @.lty3530)
%t3536 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3535)
%t3537 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3536, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3536, %tco.s0 ]
br label %tco.head
}
define ptr @key_block(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3539 = call i64 @resid_list_len(ptr %p0)
%t3540 = icmp sgt i64 %t3539, 64
br i1 %t3540, label %L418, label %L420
L418:
%t3541 = call ptr @sha256_bytes(ptr %p0)
%t3542 = call i64 @resid_list_len(ptr %t3541)
%t3543 = sub nsw i64 64, %t3542
%t3545 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3544)
%t3546 = call ptr @zeros_l(ptr %t3545, i64 %t3543)
%t3547 = call ptr @resid_list_freeze(ptr %t3546)
%t3548 = call ptr @sconcat(ptr %t3541, ptr %t3547)
ret ptr %t3548
L420:
%t3549 = sub nsw i64 64, %t3539
%t3551 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3550)
%t3552 = call ptr @zeros_l(ptr %t3551, i64 %t3549)
%t3553 = call ptr @resid_list_freeze(ptr %t3552)
%t3554 = call ptr @sconcat(ptr %p0, ptr %t3553)
ret ptr %t3554
}
define ptr @map_ipad(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3562 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3569, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t3555 = call i64 @resid_list_len(ptr %p0)
%t3556 = icmp sge i64 %p1, %t3555
br i1 %t3556, label %L421, label %L423
L421:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p2
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L423:
%t3557 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3558 = call i64 @resid_unbox_i64(ptr %t3557)
%t3560 = xor i64 %t3558, 54
%t3561 = and i64 %t3560, 255
%t3564 = call ptr @resid_box_i64(i64 %t3561)
%t3566 = getelementptr i8, ptr %t3562, i64 0
store ptr %t3564, ptr %t3566
%t3567 = call ptr @resid_list_new(i64 1, ptr %t3562, ptr @.lty3562)
%t3568 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t3567)
%t3569 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t3568, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t3568, %tco.s0 ]
br label %tco.head
}
define ptr @map_opad(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3578 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3585, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t3571 = call i64 @resid_list_len(ptr %p0)
%t3572 = icmp sge i64 %p1, %t3571
br i1 %t3572, label %L424, label %L426
L424:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p2
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L426:
%t3573 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3574 = call i64 @resid_unbox_i64(ptr %t3573)
%t3576 = xor i64 %t3574, 92
%t3577 = and i64 %t3576, 255
%t3580 = call ptr @resid_box_i64(i64 %t3577)
%t3582 = getelementptr i8, ptr %t3578, i64 0
store ptr %t3580, ptr %t3582
%t3583 = call ptr @resid_list_new(i64 1, ptr %t3578, ptr @.lty3578)
%t3584 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t3583)
%t3585 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t3584, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t3584, %tco.s0 ]
br label %tco.head
}
define ptr @hmac_sha256_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3587 = call ptr @key_block(ptr %p0)
%t3589 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3588)
%t3590 = call ptr @map_ipad(ptr %t3587, i64 0, ptr %t3589)
%t3592 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3591)
%t3593 = call ptr @map_opad(ptr %t3587, i64 0, ptr %t3592)
%t3594 = call ptr @sconcat(ptr %t3590, ptr %p1)
%t3595 = call ptr @sha256_bytes(ptr %t3594)
%t3596 = call ptr @resid_list_freeze(ptr %t3595)
%t3597 = call ptr @sconcat(ptr %t3593, ptr %t3596)
%t3598 = call ptr @sha256_bytes(ptr %t3597)
ret ptr %t3598
}
define i1 @ct_equal(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3603 = alloca [24 x i8], align 16 ; fixed
%t3604 = alloca [48 x i8], align 16 ; fixed
%t3599 = call i64 @resid_list_len(ptr %p0)
%t3600 = call i64 @resid_list_len(ptr %p1)
%t3601 = icmp ne i64 %t3599, %t3600
br i1 %t3601, label %L427, label %L429
L427:
ret i1 false
L429:
%t3602 = call i64 @ct_acc(ptr %p0, ptr %p1, i64 0, i64 0)
store i64 %t3602, ptr %t3603
%t3605 = ptrtoint ptr %t3603 to i64
store i64 1296236546, ptr %t3604
%t3606 = getelementptr i64, ptr %t3604, i64 1
store i64 %t3605, ptr %t3606
%t3607 = getelementptr i64, ptr %t3604, i64 2
store i64 8, ptr %t3607
%t3608 = getelementptr i64, ptr %t3604, i64 3
store i64 0, ptr %t3608
%t3609 = getelementptr i64, ptr %t3604, i64 4
store i64 0, ptr %t3609
%t3610 = getelementptr i64, ptr %t3604, i64 5
store i64 0, ptr %t3610
%t3611 = call i64 asm sideeffect "rolq $$3, %rdi ; rolq $$13, %rdi ; rolq $$61, %rdi ; rolq $$51, %rdi ; xchgq %rbx, %rbx", "={dx},{ax},0,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(ptr %t3604, i64 0)
%t3612 = load i64, ptr %t3603
%t3613 = icmp eq i64 %t3612, 0
ret i1 %t3613
}
define i64 @ct_acc(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3624, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t3623, %tco.s0 ]
%t3614 = call i64 @resid_list_len(ptr %p0)
%t3615 = icmp sge i64 %p2, %t3614
br i1 %t3615, label %L430, label %L432
L430:
ret i64 %p3
L432:
%t3616 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t3617 = call i64 @resid_unbox_i64(ptr %t3616)
%t3619 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t3620 = call i64 @resid_unbox_i64(ptr %t3619)
%t3622 = xor i64 %t3617, %t3620
%t3623 = or i64 %p3, %t3622
%t3624 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @ct_eq(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
call void @resid_cap_check(ptr @.declassify.cap)
%t3643 = alloca [20 x i8], align 16 ; fixed
%t3644 = alloca [48 x i8], align 16 ; fixed
%t3626 = call i64 @resid_list_len(ptr %p0)
%t3627 = call i64 @resid_list_len(ptr %p1)
%t3628 = icmp ne i64 %t3626, %t3627
br i1 %t3628, label %L433, label %L435
L433:
ret i1 false
L435:
%t3629 = call i64 @resid_list_len(ptr %p0)
%t3630 = icmp eq i64 %t3629, 0
br i1 %t3630, label %L436, label %L438
L436:
ret i1 true
L438:
%t3631 = call ptr @resid_list_get(ptr %p0, i64 0)
%t3633 = call i64 @resid_unbox_i64(ptr %t3631)
%t3632 = trunc i64 %t3633 to i8
%t3634 = call ptr @resid_list_get(ptr %p1, i64 0)
%t3636 = call i64 @resid_unbox_i64(ptr %t3634)
%t3635 = trunc i64 %t3636 to i8
%t3637 = xor i8 %t3632, %t3635
%t3638 = call i8 @__m____________lib_crypto_resid__ct_eq_acc(ptr %p0, ptr %p1, i64 1, i8 %t3637)
%t3639 = zext i8 %t3638 to i32
%t3640 = sub i32 0, %t3639
%t3641 = or i32 %t3639, %t3640
%t3642 = lshr i32 %t3641, 31
store i32 %t3642, ptr %t3643
%t3645 = ptrtoint ptr %t3643 to i64
store i64 1296236546, ptr %t3644
%t3646 = getelementptr i64, ptr %t3644, i64 1
store i64 %t3645, ptr %t3646
%t3647 = getelementptr i64, ptr %t3644, i64 2
store i64 4, ptr %t3647
%t3648 = getelementptr i64, ptr %t3644, i64 3
store i64 0, ptr %t3648
%t3649 = getelementptr i64, ptr %t3644, i64 4
store i64 0, ptr %t3649
%t3650 = getelementptr i64, ptr %t3644, i64 5
store i64 0, ptr %t3650
%t3651 = call i64 asm sideeffect "rolq $$3, %rdi ; rolq $$13, %rdi ; rolq $$61, %rdi ; rolq $$51, %rdi ; xchgq %rbx, %rbx", "={dx},{ax},0,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(ptr %t3644, i64 0)
%t3652 = load i32, ptr %t3643
%t3653 = icmp eq i32 %t3652, 0
ret i1 %t3653
}
define i8 @__m____________lib_crypto_resid__ct_eq_acc(ptr %p0.in, ptr %p1.in, i64 %p2.in, i8 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3656, %tco.s0 ]
%p3 = phi i8 [ %p3.in, %entry ], [ %t3664, %tco.s0 ]
%t3654 = call i64 @resid_list_len(ptr %p0)
%t3655 = icmp sge i64 %p2, %t3654
br i1 %t3655, label %L439, label %L441
L439:
ret i8 %p3
L441:
%t3656 = add nsw i64 %p2, 1
%t3657 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t3659 = call i64 @resid_unbox_i64(ptr %t3657)
%t3658 = trunc i64 %t3659 to i8
%t3660 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t3662 = call i64 @resid_unbox_i64(ptr %t3660)
%t3661 = trunc i64 %t3662 to i8
%t3663 = xor i8 %t3658, %t3661
%t3664 = or i8 %p3, %t3663
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @__m____________lib_crypto_resid__ct_same_pub(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3666 = musttail call i1 @ct_equal(ptr %p0, ptr %p1)
ret i1 %t3666
}
define i1 @__m____________lib_crypto_resid__ct_same_secret(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3667 = musttail call i1 @ct_eq(ptr %p0, ptr %p1)
ret i1 %t3667
}
define ptr @b64_char(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3668 = icmp slt i64 %p0, 26
br i1 %t3668, label %L442, label %L444
L442:
%t3669 = add nsw i64 %p0, 65
%t3670 = musttail call ptr @str_from_code(i64 %t3669)
ret ptr %t3670
L444:
%t3671 = icmp slt i64 %p0, 52
br i1 %t3671, label %L445, label %L447
L445:
%t3672 = add nsw i64 %p0, 71
%t3673 = musttail call ptr @str_from_code(i64 %t3672)
ret ptr %t3673
L447:
%t3674 = icmp slt i64 %p0, 62
br i1 %t3674, label %L448, label %L450
L448:
%t3675 = sub nsw i64 %p0, 4
%t3676 = musttail call ptr @str_from_code(i64 %t3675)
ret ptr %t3676
L450:
%t3677 = icmp eq i64 %p0, 62
br i1 %t3677, label %L451, label %L453
L451:
ret ptr @.s3678
L453:
ret ptr @.s3679
}
define ptr @base64_encode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3680 = call i64 @resid_list_len(ptr %p0)
%t3681x = insertvalue {ptr,ptr} zeroinitializer, ptr null, 0
%t3681 = insertvalue {ptr,ptr} %t3681x, ptr null, 1
%t3682 = call {ptr,ptr} @b64_enc(ptr %p0, i64 0, i64 %t3680, {ptr,ptr} %t3681)
%t3683b = extractvalue {ptr,ptr} %t3682, 0
%t3683l = extractvalue {ptr,ptr} %t3682, 1
%t3683 = call ptr @resid_sb2_finish(ptr %t3683b, ptr %t3683l)
ret ptr %t3683
}
define i64 @__m____________lib_crypto_resid__b64_code(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3684 = icmp slt i64 %p0, 26
br i1 %t3684, label %L454, label %L456
L454:
%t3685 = add nsw i64 %p0, 65
ret i64 %t3685
L456:
%t3686 = icmp slt i64 %p0, 52
br i1 %t3686, label %L457, label %L459
L457:
%t3687 = add nsw i64 %p0, 71
ret i64 %t3687
L459:
%t3688 = icmp slt i64 %p0, 62
br i1 %t3688, label %L460, label %L462
L460:
%t3689 = sub nsw i64 %p0, 4
ret i64 %t3689
L462:
%t3690 = icmp eq i64 %p0, 62
br i1 %t3690, label %L463, label %L464
L463:
br label %L465
L464:
br label %L465
L465:
%t3691 = phi i64 [ 43, %L463 ], [ 47, %L464 ]
ret i64 %t3691
}
define {ptr,ptr} @b64_enc(ptr %p0.in, i64 %p1.in, i64 %p2.in, {ptr,ptr} %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3739, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi {ptr,ptr} [ %p3.in, %entry ], [ %t3737, %tco.s0 ]
%t3692 = icmp sge i64 %p1, %p2
br i1 %t3692, label %L466, label %L468
L466:
ret {ptr,ptr} %p3
L468:
%t3693 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 %p1)
%t3694 = extractvalue {i64, i1} %t3693, 0
%t3695 = extractvalue {i64, i1} %t3693, 1
%t3696 = zext i1 %t3695 to i8
call void @resid_overflow_check(i8 %t3696)
%t3697 = icmp sgt i64 %t3694, 1
br i1 %t3697, label %L469, label %L470
L469:
%t3698 = add nsw i64 %p1, 1
%t3699 = call ptr @resid_list_get_v(ptr %p0, i64 %t3698, ptr %p0.ld, i64 %p0.ln)
%t3700 = call i64 @resid_unbox_i64(ptr %t3699)
br label %L471
L470:
br label %L471
L471:
%t3702 = phi i64 [ %t3700, %L469 ], [ 0, %L470 ]
%t3703 = icmp sgt i64 %t3694, 2
br i1 %t3703, label %L472, label %L473
L472:
%t3704 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t3705 = extractvalue {i64, i1} %t3704, 0
%t3706 = extractvalue {i64, i1} %t3704, 1
%t3707 = zext i1 %t3706 to i8
call void @resid_overflow_check(i8 %t3707)
%t3708 = call ptr @resid_list_get_v(ptr %p0, i64 %t3705, ptr %p0.ld, i64 %p0.ln)
%t3709 = call i64 @resid_unbox_i64(ptr %t3708)
br label %L474
L473:
br label %L474
L474:
%t3711 = phi i64 [ %t3709, %L472 ], [ 0, %L473 ]
%t3712 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3713 = call i64 @resid_unbox_i64(ptr %t3712)
%t3715 = shl i64 %t3713, 16
%t3716 = shl i64 %t3702, 8
%t3717 = or i64 %t3715, %t3716
%t3718 = or i64 %t3717, %t3711
%t3719 = ashr i64 %t3718, 18
%t3720 = and i64 %t3719, 63
%t3721 = call i64 @__m____________lib_crypto_resid__b64_code(i64 %t3720)
%t3722b = extractvalue {ptr,ptr} %p3, 0
%t3722l = extractvalue {ptr,ptr} %p3, 1
%t3722a = icmp ult i64 %t3721, 128
%t3722r = icmp ult ptr %t3722b, %t3722l
%t3722k = and i1 %t3722a, %t3722r
br i1 %t3722k, label %L475, label %L476
L475:
%t3722v = trunc i64 %t3721 to i8
store i8 %t3722v, ptr %t3722b, align 1
%t3722q = getelementptr i8, ptr %t3722b, i64 1
%t3722f = insertvalue {ptr,ptr} %p3, ptr %t3722q, 0
br label %L477
L476:
%t3722nb = call ptr @resid_sb2_push_cp(ptr %t3722b, ptr %t3722l, i64 %t3721)
%t3722nl = call ptr @resid_sb2_lim()
%t3722sx = insertvalue {ptr,ptr} zeroinitializer, ptr %t3722nb, 0
%t3722s = insertvalue {ptr,ptr} %t3722sx, ptr %t3722nl, 1
br label %L477
L477:
%t3722 = phi {ptr,ptr} [ %t3722f, %L475 ], [ %t3722s, %L476 ]
%t3723 = ashr i64 %t3718, 12
%t3724 = and i64 %t3723, 63
%t3725 = call i64 @__m____________lib_crypto_resid__b64_code(i64 %t3724)
%t3726b = extractvalue {ptr,ptr} %t3722, 0
%t3726l = extractvalue {ptr,ptr} %t3722, 1
%t3726a = icmp ult i64 %t3725, 128
%t3726r = icmp ult ptr %t3726b, %t3726l
%t3726k = and i1 %t3726a, %t3726r
br i1 %t3726k, label %L478, label %L479
L478:
%t3726v = trunc i64 %t3725 to i8
store i8 %t3726v, ptr %t3726b, align 1
%t3726q = getelementptr i8, ptr %t3726b, i64 1
%t3726f = insertvalue {ptr,ptr} %t3722, ptr %t3726q, 0
br label %L480
L479:
%t3726nb = call ptr @resid_sb2_push_cp(ptr %t3726b, ptr %t3726l, i64 %t3725)
%t3726nl = call ptr @resid_sb2_lim()
%t3726sx = insertvalue {ptr,ptr} zeroinitializer, ptr %t3726nb, 0
%t3726s = insertvalue {ptr,ptr} %t3726sx, ptr %t3726nl, 1
br label %L480
L480:
%t3726 = phi {ptr,ptr} [ %t3726f, %L478 ], [ %t3726s, %L479 ]
%t3727 = icmp sgt i64 %t3694, 1
br i1 %t3727, label %L481, label %L482
L481:
%t3728 = ashr i64 %t3718, 6
%t3729 = and i64 %t3728, 63
%t3730 = call i64 @__m____________lib_crypto_resid__b64_code(i64 %t3729)
br label %L483
L482:
br label %L483
L483:
%t3731 = phi i64 [ %t3730, %L481 ], [ 61, %L482 ]
%t3732b = extractvalue {ptr,ptr} %t3726, 0
%t3732l = extractvalue {ptr,ptr} %t3726, 1
%t3732a = icmp ult i64 %t3731, 128
%t3732r = icmp ult ptr %t3732b, %t3732l
%t3732k = and i1 %t3732a, %t3732r
br i1 %t3732k, label %L484, label %L485
L484:
%t3732v = trunc i64 %t3731 to i8
store i8 %t3732v, ptr %t3732b, align 1
%t3732q = getelementptr i8, ptr %t3732b, i64 1
%t3732f = insertvalue {ptr,ptr} %t3726, ptr %t3732q, 0
br label %L486
L485:
%t3732nb = call ptr @resid_sb2_push_cp(ptr %t3732b, ptr %t3732l, i64 %t3731)
%t3732nl = call ptr @resid_sb2_lim()
%t3732sx = insertvalue {ptr,ptr} zeroinitializer, ptr %t3732nb, 0
%t3732s = insertvalue {ptr,ptr} %t3732sx, ptr %t3732nl, 1
br label %L486
L486:
%t3732 = phi {ptr,ptr} [ %t3732f, %L484 ], [ %t3732s, %L485 ]
%t3733 = icmp sgt i64 %t3694, 2
br i1 %t3733, label %L487, label %L488
L487:
%t3734 = and i64 %t3718, 63
%t3735 = call i64 @__m____________lib_crypto_resid__b64_code(i64 %t3734)
br label %L489
L488:
br label %L489
L489:
%t3736 = phi i64 [ %t3735, %L487 ], [ 61, %L488 ]
%t3737b = extractvalue {ptr,ptr} %t3732, 0
%t3737l = extractvalue {ptr,ptr} %t3732, 1
%t3737a = icmp ult i64 %t3736, 128
%t3737r = icmp ult ptr %t3737b, %t3737l
%t3737k = and i1 %t3737a, %t3737r
br i1 %t3737k, label %L490, label %L491
L490:
%t3737v = trunc i64 %t3736 to i8
store i8 %t3737v, ptr %t3737b, align 1
%t3737q = getelementptr i8, ptr %t3737b, i64 1
%t3737f = insertvalue {ptr,ptr} %t3732, ptr %t3737q, 0
br label %L492
L491:
%t3737nb = call ptr @resid_sb2_push_cp(ptr %t3737b, ptr %t3737l, i64 %t3736)
%t3737nl = call ptr @resid_sb2_lim()
%t3737sx = insertvalue {ptr,ptr} zeroinitializer, ptr %t3737nb, 0
%t3737s = insertvalue {ptr,ptr} %t3737sx, ptr %t3737nl, 1
br label %L492
L492:
%t3737 = phi {ptr,ptr} [ %t3737f, %L490 ], [ %t3737s, %L491 ]
%t3738 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 3)
%t3739 = extractvalue {i64, i1} %t3738, 0
%t3740 = extractvalue {i64, i1} %t3738, 1
%t3741 = zext i1 %t3740 to i8
call void @resid_overflow_check(i8 %t3741)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @base64_decode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3743 = call i64 @str_len(ptr %p0)
%t3744 = call ptr @resid_listbuf_new()
%t3745 = call ptr @__m____________lib_crypto_resid__b64_strip(ptr %p0, i64 0, i64 %t3743, ptr %t3744)
%t3746 = call i64 @resid_list_len(ptr %t3745)
%t3747 = call i64 @__m____________lib_crypto_resid__b64_pads(ptr %t3745, i64 %t3746, i64 0)
%t3748 = call i64 @resid_list_len(ptr %t3745)
%t3749 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t3748, i64 %t3747)
%t3750 = extractvalue {i64, i1} %t3749, 0
%t3751 = extractvalue {i64, i1} %t3749, 1
%t3752 = zext i1 %t3751 to i8
call void @resid_overflow_check(i8 %t3752)
%t3753 = call ptr @resid_list_slice(ptr %t3745, i64 0, i64 %t3750)
%t3755 = call ptr @base64g_decode__g_Int_64__Int_64_(ptr %t3753, i64 %t3747)
ret ptr %t3755
}
define i1 @__m____________lib_crypto_resid__b64_is_space(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3756 = icmp eq i64 %p0, 32
br label %LSL3757
LSL3757:
br i1 %t3756, label %LSJ3757, label %LSR3757
LSR3757:
%t3758 = icmp eq i64 %p0, 9
br label %LSJ3757
LSJ3757:
%t3759 = phi i1 [ true, %LSL3757 ], [ %t3758, %LSR3757 ]
br label %LSL3760
LSL3760:
br i1 %t3759, label %LSJ3760, label %LSR3760
LSR3760:
%t3761 = icmp eq i64 %p0, 10
br label %LSJ3760
LSJ3760:
%t3762 = phi i1 [ true, %LSL3760 ], [ %t3761, %LSR3760 ]
br label %LSL3763
LSL3763:
br i1 %t3762, label %LSJ3763, label %LSR3763
LSR3763:
%t3764 = icmp eq i64 %p0, 13
br label %LSJ3763
LSJ3763:
%t3765 = phi i1 [ true, %LSL3763 ], [ %t3764, %LSR3763 ]
br i1 %t3765, label %L493, label %L495
L493:
ret i1 true
L495:
ret i1 false
}
define ptr @__m____________lib_crypto_resid__b64_strip(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3780, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t3779, %tco.s0 ]
%t3766 = icmp sge i64 %p1, %p2
br i1 %t3766, label %L496, label %L498
L496:
%t3767 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty3767)
ret ptr %t3767
L498:
%t3768 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t3769 = call i1 @__m____________lib_crypto_resid__b64_is_space(i64 %t3768)
br i1 %t3769, label %L499, label %L500
L499:
br label %L501
L500:
%t3770 = icmp sgt i64 %t3768, 127
br label %LSL3771
LSL3771:
br i1 %t3770, label %LSJ3771, label %LSR3771
LSR3771:
%t3772 = icmp slt i64 %t3768, 0
br label %LSJ3771
LSJ3771:
%t3773 = phi i1 [ true, %LSL3771 ], [ %t3772, %LSR3771 ]
br i1 %t3773, label %L502, label %L503
L502:
br label %L504
L503:
br label %L504
L504:
%t3774 = phi i64 [ 0, %L502 ], [ %t3768, %L503 ]
%t3775 = call ptr @resid_box_i64(i64 %t3774)
%t3778 = call ptr @resid_listbuf_push(ptr %p3, ptr %t3775)
br label %L501
L501:
%t3779 = phi ptr [ %p3, %L499 ], [ %t3778, %L504 ]
%t3780 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_crypto_resid__b64_pads(ptr %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3802, %tco.s0 ]
%t3782 = icmp sge i64 %p2, 2
br label %LSL3783
LSL3783:
br i1 %t3782, label %LSJ3783, label %LSR3783
LSR3783:
%t3784 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 %p2)
%t3785 = extractvalue {i64, i1} %t3784, 0
%t3786 = extractvalue {i64, i1} %t3784, 1
%t3787 = zext i1 %t3786 to i8
call void @resid_overflow_check(i8 %t3787)
%t3788 = icmp sle i64 %t3785, 0
br label %LSJ3783
LSJ3783:
%t3789 = phi i1 [ true, %LSL3783 ], [ %t3788, %LSR3783 ]
br i1 %t3789, label %L505, label %L507
L505:
ret i64 %p2
L507:
%t3790 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 %p2)
%t3791 = extractvalue {i64, i1} %t3790, 0
%t3792 = extractvalue {i64, i1} %t3790, 1
%t3793 = zext i1 %t3792 to i8
call void @resid_overflow_check(i8 %t3793)
%t3794 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t3791, i64 1)
%t3795 = extractvalue {i64, i1} %t3794, 0
%t3796 = extractvalue {i64, i1} %t3794, 1
%t3797 = zext i1 %t3796 to i8
call void @resid_overflow_check(i8 %t3797)
%t3798 = call ptr @resid_list_get_v(ptr %p0, i64 %t3795, ptr %p0.ld, i64 %p0.ln)
%t3799 = call i64 @resid_unbox_i64(ptr %t3798)
%t3801 = icmp ne i64 %t3799, 61
br i1 %t3801, label %L508, label %L510
L508:
ret i64 %p2
L510:
%t3802 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @pbkdf2_f(ptr %p0.in, ptr %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3808, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3804 = icmp sle i64 %p2, 0
br i1 %t3804, label %L511, label %L513
L511:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L513:
%t3805 = call ptr @hmac_sha256_bytes(ptr %p1, ptr %p0)
%t3806 = call ptr @resid_list_freeze(ptr %t3805)
%t3807 = call ptr @pbkdf2_xor_acc(ptr %p3, ptr %t3806, i64 0)
%t3808 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t3806, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3807, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t3806, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3807, %tco.s0 ]
br label %tco.head
}
define ptr @pbkdf2_xor_acc(ptr %p0.in, ptr %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3821, %tco.s0.k ]
%t3810 = call i64 @resid_list_len(ptr %p1)
%t3811 = icmp sge i64 %p2, %t3810
br i1 %t3811, label %L514, label %L516
L514:
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %p0
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L516:
%t3812 = call ptr @resid_list_get(ptr %p0, i64 %p2)
%t3813 = call i64 @resid_unbox_i64(ptr %t3812)
%t3815 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t3816 = call i64 @resid_unbox_i64(ptr %t3815)
%t3818 = xor i64 %t3813, %t3816
%t3819 = and i64 %t3818, 255
%t3820 = call ptr @ls_set(ptr %p0, i64 %p2, i64 %t3819)
%t3821 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t3820, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t3820, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
br label %tco.head
}
define ptr @pbkdf2_hmac_sha256(ptr %p0, ptr %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3823 = and i64 %p3, 255
%t3824 = ashr i64 %p3, 8
%t3825 = and i64 %t3824, 255
%t3826 = ashr i64 %p3, 16
%t3827 = and i64 %t3826, 255
%t3828 = ashr i64 %p3, 24
%t3829 = and i64 %t3828, 255
%t3830 = alloca [4 x ptr]
%t3832 = call ptr @resid_box_i64(i64 %t3829)
%t3834 = getelementptr i8, ptr %t3830, i64 0
store ptr %t3832, ptr %t3834
%t3835 = call ptr @resid_box_i64(i64 %t3827)
%t3837 = getelementptr i8, ptr %t3830, i64 8
store ptr %t3835, ptr %t3837
%t3838 = call ptr @resid_box_i64(i64 %t3825)
%t3840 = getelementptr i8, ptr %t3830, i64 16
store ptr %t3838, ptr %t3840
%t3841 = call ptr @resid_box_i64(i64 %t3823)
%t3843 = getelementptr i8, ptr %t3830, i64 24
store ptr %t3841, ptr %t3843
%t3844 = call ptr @resid_list_new(i64 4, ptr %t3830, ptr @.lty3830)
%t3845 = call ptr @sconcat(ptr %p1, ptr %t3844)
%t3846 = call ptr @resid_list_freeze(ptr %t3845)
%t3847 = call ptr @hmac_sha256_bytes(ptr %p0, ptr %t3846)
%t3848 = call ptr @resid_list_freeze(ptr %t3847)
%t3849 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 1)
%t3850 = extractvalue {i64, i1} %t3849, 0
%t3851 = extractvalue {i64, i1} %t3849, 1
%t3852 = zext i1 %t3851 to i8
call void @resid_overflow_check(i8 %t3852)
%t3853 = call ptr @pbkdf2_f(ptr %t3848, ptr %p0, i64 %t3850, ptr %t3848)
ret ptr %t3853
}
define ptr @hkdf_extract(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3854 = musttail call ptr @hmac_sha256_bytes(ptr %p0, ptr %p1)
ret ptr %t3854
}
define i64 @hkdf_rounds(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3855 = sdiv i64 %p0, 32
%t3856 = srem i64 %p0, 32
%t3857 = icmp ne i64 %t3856, 0
br i1 %t3857, label %L517, label %L519
L517:
%t3858 = add nsw i64 %t3855, 1
ret i64 %t3858
L519:
ret i64 %t3855
}
define ptr @hkdf_exp_acc(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, ptr %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3862 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3873, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0.k ]
%p4 = phi ptr [ %p4.in, %entry ], [ %p4.ev.tco.s0, %tco.s0.k ]
%p5 = phi ptr [ %p5.in, %entry ], [ %p5.ev.tco.s0, %tco.s0.k ]
%t3859 = icmp sgt i64 %p2, %p3
br i1 %t3859, label %L520, label %L522
L520:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p5
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p5, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L522:
%t3860 = call ptr @sconcat(ptr %p4, ptr %p1)
%t3861 = call ptr @resid_list_freeze(ptr %t3860)
%t3864 = call ptr @resid_box_i64(i64 %p2)
%t3866 = getelementptr i8, ptr %t3862, i64 0
store ptr %t3864, ptr %t3866
%t3868e = load ptr, ptr %t3862
%t3868 = call ptr @resid_list_push(ptr %t3861, ptr %t3868e)
%t3869 = call ptr @hmac_sha256_bytes(ptr %p0, ptr %t3868)
%t3870 = call ptr @resid_list_freeze(ptr %t3869)
%t3871 = call ptr @sconcat(ptr %p5, ptr %t3870)
%t3872 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t3873 = extractvalue {i64, i1} %t3872, 0
%t3874 = extractvalue {i64, i1} %t3872, 1
%t3875 = zext i1 %t3874 to i8
call void @resid_overflow_check(i8 %t3875)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p4.e.tco.s0 = call ptr @resid_mv_list(ptr %t3870, ptr %lr.cx.tco.s0)
%p5.e.tco.s0 = call ptr @resid_mv_list(ptr %t3871, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p4.ev.tco.s0 = phi ptr [ %p4.e.tco.s0, %tco.s0.c ], [ %t3870, %tco.s0 ]
%p5.ev.tco.s0 = phi ptr [ %p5.e.tco.s0, %tco.s0.c ], [ %t3871, %tco.s0 ]
br label %tco.head
}
define ptr @hkdf_expand(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3877 = icmp slt i64 %p2, 0
br label %LSL3878
LSL3878:
br i1 %t3877, label %LSJ3878, label %LSR3878
LSR3878:
%t3879 = icmp sgt i64 %p2, 8160
br label %LSJ3878
LSJ3878:
%t3880 = phi i1 [ true, %LSL3878 ], [ %t3879, %LSR3878 ]
br i1 %t3880, label %L523, label %L525
L523:
%t3882 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3881)
ret ptr %t3882
L525:
%t3883 = call i64 @hkdf_rounds(i64 %p2)
%t3885 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3884)
%t3887 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3886)
%t3888 = call ptr @hkdf_exp_acc(ptr %p0, ptr %p1, i64 1, i64 %t3883, ptr %t3885, ptr %t3887)
%t3890 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3889)
%t3891 = call ptr @hkdf_take(ptr %t3888, i64 0, i64 %p2, ptr %t3890)
ret ptr %t3891
}
define ptr @hkdf_take(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3896 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3903, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3892 = icmp sge i64 %p1, %p2
br i1 %t3892, label %L526, label %L528
L526:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p3
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L528:
%t3893 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3894 = call i64 @resid_unbox_i64(ptr %t3893)
%t3898 = call ptr @resid_box_i64(i64 %t3894)
%t3900 = getelementptr i8, ptr %t3896, i64 0
store ptr %t3898, ptr %t3900
%t3901 = call ptr @resid_list_new(i64 1, ptr %t3896, ptr @.lty3896)
%t3902 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3901)
%t3903 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3902, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3902, %tco.s0 ]
br label %tco.head
}
define ptr @hkdf_sha256(ptr %p0, ptr %p1, ptr %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3905 = call ptr @hkdf_extract(ptr %p0, ptr %p1)
%t3906 = call ptr @resid_list_freeze(ptr %t3905)
%t3907 = call ptr @hkdf_expand(ptr %t3906, ptr %p2, i64 %p3)
ret ptr %t3907
}
define ptr @random_bytes(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3908 = icmp sle i64 %p0, 0
br i1 %t3908, label %L529, label %L531
L529:
%t3910 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3909)
ret ptr %t3910
L531:
%t3912 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3911)
%t3913 = call ptr @__m____________lib_crypto_resid__rand_blocks(i64 %p0, ptr %t3912)
ret ptr %t3913
}
define ptr @__m____________lib_crypto_resid__rand_blocks(i64 %p0.in, ptr %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%t3914 = call i64 @resid_list_len(ptr %p1)
%t3915 = icmp sge i64 %t3914, %p0
br i1 %t3915, label %L532, label %L534
L532:
%t3916 = call ptr @resid_list_slice(ptr %p1, i64 0, i64 %p0)
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %t3916
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %t3916, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L534:
%t3918 = call ptr @__m____________lib_crypto_resid__rand_block()
%t3919 = call ptr @resid_list_freeze(ptr %t3918)
%t3920 = call ptr @resid_list_concat_own(ptr %p1, i8 1, ptr %t3919)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %t3920, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %t3920, %tco.s0 ]
br label %tco.head
}
define ptr @__m____________lib_crypto_resid__rand_block() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3922 = call ptr @resid_random_os(i64 32)
%t3923 = call i64 @resid_list_len(ptr %t3922)
%t3924 = icmp eq i64 %t3923, 32
%t3926 = zext i1 %t3924 to i8
call void @resid_assert(i8 %t3926, ptr @.s3925)
%t3927 = call ptr @resid_random_cpu(i64 32)
%t3929 = call ptr @resid_list_const_i64(ptr @.lc3928, i64 4, ptr @.lcd3928, ptr @.lty3928)
%t3930 = call ptr @resid_list_concat(ptr %t3929, ptr %t3922)
%t3931 = call i64 @resid_list_len(ptr %t3927)
%t3932 = call ptr @__m____________lib_crypto_resid__rand_u32(i64 %t3931)
%t3933 = call ptr @resid_list_freeze(ptr %t3932)
%t3934 = call ptr @resid_list_concat(ptr %t3930, ptr %t3933)
%t3935 = call ptr @resid_list_concat(ptr %t3934, ptr %t3927)
%t3936 = call ptr @sha512_bytes(ptr %t3935)
ret ptr %t3936
}
define ptr @__m____________lib_crypto_resid__rand_u32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3937 = ashr i64 %p0, 24
%t3938 = and i64 %t3937, 255
%t3939 = ashr i64 %p0, 16
%t3940 = and i64 %t3939, 255
%t3941 = ashr i64 %p0, 8
%t3942 = and i64 %t3941, 255
%t3943 = and i64 %p0, 255
%t3944 = alloca [4 x ptr]
%t3946 = call ptr @resid_box_i64(i64 %t3938)
%t3948 = getelementptr i8, ptr %t3944, i64 0
store ptr %t3946, ptr %t3948
%t3949 = call ptr @resid_box_i64(i64 %t3940)
%t3951 = getelementptr i8, ptr %t3944, i64 8
store ptr %t3949, ptr %t3951
%t3952 = call ptr @resid_box_i64(i64 %t3942)
%t3954 = getelementptr i8, ptr %t3944, i64 16
store ptr %t3952, ptr %t3954
%t3955 = call ptr @resid_box_i64(i64 %t3943)
%t3957 = getelementptr i8, ptr %t3944, i64 24
store ptr %t3955, ptr %t3957
%t3958 = call ptr @resid_list_new(i64 4, ptr %t3944, ptr @.lty3944)
ret ptr %t3958
}
define ptr @random_hex(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3959 = call ptr @random_bytes(i64 %p0)
%t3960 = call ptr @hex_encode(ptr %t3959)
ret ptr %t3960
}
define ptr @w64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3961 = and i64 %p0, 4294967295
%t3962 = and i64 %p1, 4294967295
%t3963 = alloca [2 x ptr]
%t3965 = call ptr @resid_box_i64(i64 %t3961)
%t3967 = getelementptr i8, ptr %t3963, i64 0
store ptr %t3965, ptr %t3967
%t3968 = call ptr @resid_box_i64(i64 %t3962)
%t3970 = getelementptr i8, ptr %t3963, i64 8
store ptr %t3968, ptr %t3970
%t3971 = call ptr @resid_list_new(i64 2, ptr %t3963, ptr @.lty3963)
ret ptr %t3971
}
define i64 @w64_hi(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3972 = call ptr @resid_list_get(ptr %p0, i64 0)
%t3973 = musttail call i64 @resid_unbox_i64(ptr %t3972)
ret i64 %t3973
}
define i64 @w64_lo(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3975 = call ptr @resid_list_get(ptr %p0, i64 1)
%t3976 = musttail call i64 @resid_unbox_i64(ptr %t3975)
ret i64 %t3976
}
define ptr @w64_add(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3978 = call i64 @w64_lo(ptr %p0)
%t3979 = call i64 @w64_lo(ptr %p1)
%t3980 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3978, i64 %t3979)
%t3981 = extractvalue {i64, i1} %t3980, 0
%t3982 = extractvalue {i64, i1} %t3980, 1
%t3983 = zext i1 %t3982 to i8
call void @resid_overflow_check(i8 %t3983)
%t3984 = and i64 %t3981, 4294967295
%t3985 = ashr i64 %t3981, 32
%t3986 = call i64 @w64_hi(ptr %p0)
%t3987 = call i64 @w64_hi(ptr %p1)
%t3988 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3986, i64 %t3987)
%t3989 = extractvalue {i64, i1} %t3988, 0
%t3990 = extractvalue {i64, i1} %t3988, 1
%t3991 = zext i1 %t3990 to i8
call void @resid_overflow_check(i8 %t3991)
%t3992 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3989, i64 %t3985)
%t3993 = extractvalue {i64, i1} %t3992, 0
%t3994 = extractvalue {i64, i1} %t3992, 1
%t3995 = zext i1 %t3994 to i8
call void @resid_overflow_check(i8 %t3995)
%t3996 = call ptr @w64(i64 %t3993, i64 %t3984)
ret ptr %t3996
}
define ptr @w64_xor(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3997 = call i64 @w64_hi(ptr %p0)
%t3998 = call i64 @w64_hi(ptr %p1)
%t3999 = xor i64 %t3997, %t3998
%t4000 = call i64 @w64_lo(ptr %p0)
%t4001 = call i64 @w64_lo(ptr %p1)
%t4002 = xor i64 %t4000, %t4001
%t4003 = call ptr @w64(i64 %t3999, i64 %t4002)
ret ptr %t4003
}
define ptr @w64_and(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4004 = call i64 @w64_hi(ptr %p0)
%t4005 = call i64 @w64_hi(ptr %p1)
%t4006 = and i64 %t4004, %t4005
%t4007 = call i64 @w64_lo(ptr %p0)
%t4008 = call i64 @w64_lo(ptr %p1)
%t4009 = and i64 %t4007, %t4008
%t4010 = call ptr @w64(i64 %t4006, i64 %t4009)
ret ptr %t4010
}
define ptr @w64_not(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4011 = call i64 @w64_hi(ptr %p0)
%t4012 = xor i64 %t4011, 4294967295
%t4013 = and i64 %t4012, 4294967295
%t4014 = call i64 @w64_lo(ptr %p0)
%t4015 = xor i64 %t4014, 4294967295
%t4016 = and i64 %t4015, 4294967295
%t4017 = call ptr @w64(i64 %t4013, i64 %t4016)
ret ptr %t4017
}
define ptr @w64_zext(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4018 = call i64 @w64_lo(ptr %p0)
%t4019 = call ptr @w64__rs265(i64 0, i64 %t4018)
ret ptr %t4019
}
define ptr @w64_rotr_small(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4020 = call i64 @w64_hi(ptr %p0)
%t4021 = call i64 @w64_lo(ptr %p0)
%t4022 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t4023 = extractvalue {i64, i1} %t4022, 0
%t4024 = extractvalue {i64, i1} %t4022, 1
%t4025 = zext i1 %t4024 to i8
call void @resid_overflow_check(i8 %t4025)
%t4026 = icmp uge i64 %p1, 64
%t4027 = add i64 %p1, 0
%t4028 = select i1 %t4026, i64 63, i64 %t4027
%t4029 = ashr i64 %t4020, %t4028
%t4030 = icmp uge i64 %t4023, 64
%t4031 = add i64 %t4023, 0
%t4032 = shl i64 %t4021, %t4031
%t4033 = select i1 %t4030, i64 0, i64 %t4032
%t4034 = or i64 %t4029, %t4033
%t4035 = icmp uge i64 %p1, 64
%t4036 = add i64 %p1, 0
%t4037 = select i1 %t4035, i64 63, i64 %t4036
%t4038 = ashr i64 %t4021, %t4037
%t4039 = icmp uge i64 %t4023, 64
%t4040 = add i64 %t4023, 0
%t4041 = shl i64 %t4020, %t4040
%t4042 = select i1 %t4039, i64 0, i64 %t4041
%t4043 = or i64 %t4038, %t4042
%t4044 = call ptr @w64(i64 %t4034, i64 %t4043)
ret ptr %t4044
}
define ptr @w64_rotr(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4045 = icmp eq i64 %p1, 0
br i1 %t4045, label %L535, label %L537
L535:
ret ptr %p0
L537:
%t4046 = icmp eq i64 %p1, 32
br i1 %t4046, label %L538, label %L540
L538:
%t4047 = call i64 @w64_lo(ptr %p0)
%t4048 = call i64 @w64_hi(ptr %p0)
%t4049 = call ptr @w64(i64 %t4047, i64 %t4048)
ret ptr %t4049
L540:
%t4050 = icmp sgt i64 %p1, 32
br i1 %t4050, label %L541, label %L543
L541:
%t4051 = sub nsw i64 %p1, 32
%t4052 = call i64 @w64_lo(ptr %p0)
%t4053 = call i64 @w64_hi(ptr %p0)
%t4054 = call ptr @w64(i64 %t4052, i64 %t4053)
%t4055 = musttail call ptr @w64_rotr_small(ptr %t4054, i64 %t4051)
ret ptr %t4055
L543:
%t4056 = musttail call ptr @w64_rotr_small(ptr %p0, i64 %p1)
ret ptr %t4056
}
define ptr @w64_shr_small(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4057 = call i64 @w64_hi(ptr %p0)
%t4058 = call i64 @w64_lo(ptr %p0)
%t4059 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t4060 = extractvalue {i64, i1} %t4059, 0
%t4061 = extractvalue {i64, i1} %t4059, 1
%t4062 = zext i1 %t4061 to i8
call void @resid_overflow_check(i8 %t4062)
%t4063 = icmp uge i64 %p1, 64
%t4064 = add i64 %p1, 0
%t4065 = select i1 %t4063, i64 63, i64 %t4064
%t4066 = ashr i64 %t4058, %t4065
%t4067 = icmp uge i64 %t4060, 64
%t4068 = add i64 %t4060, 0
%t4069 = shl i64 %t4057, %t4068
%t4070 = select i1 %t4067, i64 0, i64 %t4069
%t4071 = or i64 %t4066, %t4070
%t4072 = icmp uge i64 %p1, 64
%t4073 = add i64 %p1, 0
%t4074 = select i1 %t4072, i64 63, i64 %t4073
%t4075 = ashr i64 %t4057, %t4074
%t4076 = call ptr @w64(i64 %t4075, i64 %t4071)
ret ptr %t4076
}
define ptr @w64_shr(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4077 = icmp eq i64 %p1, 0
br i1 %t4077, label %L544, label %L546
L544:
ret ptr %p0
L546:
%t4078 = icmp sge i64 %p1, 32
br i1 %t4078, label %L547, label %L549
L547:
%t4079 = sub nsw i64 %p1, 32
%t4080 = call i64 @w64_hi(ptr %p0)
%t4081 = icmp uge i64 %t4079, 64
%t4082 = add i64 %t4079, 0
%t4083 = select i1 %t4081, i64 63, i64 %t4082
%t4084 = ashr i64 %t4080, %t4083
%t4085 = call ptr @w64__rs265(i64 0, i64 %t4084)
ret ptr %t4085
L549:
%t4086 = musttail call ptr @w64_shr_small(ptr %p0, i64 %p1)
ret ptr %t4086
}
define ptr @k512_limb_at(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4088 = call ptr @resid_list_const_i64(ptr @.lc4087, i64 160, ptr @.lcd4087, ptr @.lty4087)
%t4089 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p0, i64 2)
%t4090 = extractvalue {i64, i1} %t4089, 0
%t4091 = extractvalue {i64, i1} %t4089, 1
%t4092 = zext i1 %t4091 to i8
call void @resid_overflow_check(i8 %t4092)
%t4093 = call ptr @resid_list_get(ptr %t4088, i64 %t4090)
%t4094 = call i64 @resid_unbox_i64(ptr %t4093)
%t4097 = call ptr @resid_list_const_i64(ptr @.lc4096, i64 160, ptr @.lcd4096, ptr @.lty4096)
%t4098 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p0, i64 2)
%t4099 = extractvalue {i64, i1} %t4098, 0
%t4100 = extractvalue {i64, i1} %t4098, 1
%t4101 = zext i1 %t4100 to i8
call void @resid_overflow_check(i8 %t4101)
%t4102 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4099, i64 1)
%t4103 = extractvalue {i64, i1} %t4102, 0
%t4104 = extractvalue {i64, i1} %t4102, 1
%t4105 = zext i1 %t4104 to i8
call void @resid_overflow_check(i8 %t4105)
%t4106 = call ptr @resid_list_get(ptr %t4097, i64 %t4103)
%t4107 = call i64 @resid_unbox_i64(ptr %t4106)
%t4109 = call ptr @w64(i64 %t4094, i64 %t4107)
ret ptr %t4109
}
define ptr @h512_state() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4111 = call ptr @resid_list_const_i64(ptr @.lc4110, i64 16, ptr @.lcd4110, ptr @.lty4110)
ret ptr %t4111
}
define ptr @h512_seed(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4119 = alloca [1 x ptr]
%t4126 = alloca [1 x ptr]
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
%p2.ld = call ptr @resid_list_vdata(ptr %p2.in)
%p2.ln = call i64 @resid_list_vlen(ptr %p2.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t4133, %tco.s0.k ]
%t4112 = icmp sge i64 %p3, 8
br i1 %t4112, label %L550, label %L552
L550:
%lr.cx17 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz17 = icmp eq ptr %lr.cx17, null
br i1 %lr.lz17, label %lr.x17.k, label %lr.x17.m
lr.x17.k:
ret ptr %p0
lr.x17.m:
%lr.ret17 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx17)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret17
L552:
%t4113 = call ptr @resid_list_get_v(ptr %p1, i64 %p3, ptr %p1.ld, i64 %p1.ln)
%t4114 = call i64 @resid_unbox_i64(ptr %t4113)
%t4116 = call ptr @resid_list_get_v(ptr %p2, i64 %p3, ptr %p2.ld, i64 %p2.ln)
%t4117 = call i64 @resid_unbox_i64(ptr %t4116)
%t4121 = call ptr @resid_box_i64(i64 %t4114)
%t4123 = getelementptr i8, ptr %t4119, i64 0
store ptr %t4121, ptr %t4123
%t4124 = call ptr @resid_list_new(i64 1, ptr %t4119, ptr @.lty4119)
%t4125 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t4124)
%t4128 = call ptr @resid_box_i64(i64 %t4117)
%t4130 = getelementptr i8, ptr %t4126, i64 0
store ptr %t4128, ptr %t4130
%t4131 = call ptr @resid_list_new(i64 1, ptr %t4126, ptr @.lty4126)
%t4132 = call ptr @resid_list_concat_own(ptr %t4125, i8 1, ptr %t4131)
%t4133 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4132, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4132, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %p2, %tco.s0 ]
br label %tco.head
}
define ptr @pad512(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4135 = call i64 @resid_list_len(ptr %p0)
%t4137 = call ptr @resid_list_const_i64(ptr @.lc4136, i64 1, ptr @.lcd4136, ptr @.lty4136)
%t4138 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t4137)
%t4139 = add nsw i64 %t4135, 17
%t4140 = add nsw i64 %t4139, 127
%t4141 = sdiv i64 %t4140, 128
%t4142 = mul nsw i64 %t4141, 128
%t4143 = sub nsw i64 %t4142, %t4139
%t4144 = call ptr @zeros_l(ptr %t4138, i64 %t4143)
%t4145 = mul nsw i64 %t4135, 8
%t4146 = call ptr @len512_bytes__rs266(ptr %t4144, i64 %t4145, i64 15)
ret ptr %t4146
}
define i64 @shr_big(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t4152, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4153, %tco.s0 ]
%t4147 = icmp sle i64 %p1, 63
br i1 %t4147, label %L553, label %L555
L553:
%t4148 = icmp uge i64 %p1, 64
%t4149 = add i64 %p1, 0
%t4150 = select i1 %t4148, i64 63, i64 %t4149
%t4151 = ashr i64 %p0, %t4150
ret i64 %t4151
L555:
%t4152 = ashr i64 %p0, 32
%t4153 = sub nsw i64 %p1, 32
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @len512_bytes(ptr %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4162 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4169, %tco.s0.k ]
%t4155 = icmp slt i64 %p2, 0
br i1 %t4155, label %L556, label %L558
L556:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p0
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L558:
%t4156 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 8)
%t4157 = extractvalue {i64, i1} %t4156, 0
%t4158 = extractvalue {i64, i1} %t4156, 1
%t4159 = zext i1 %t4158 to i8
call void @resid_overflow_check(i8 %t4159)
%t4160 = call i64 @shr_big(i64 %p1, i64 %t4157)
%t4161 = and i64 %t4160, 255
%t4164 = call ptr @resid_box_i64(i64 %t4161)
%t4166 = getelementptr i8, ptr %t4162, i64 0
store ptr %t4164, ptr %t4166
%t4167 = call ptr @resid_list_new(i64 1, ptr %t4162, ptr @.lty4162)
%t4168 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t4167)
%t4169 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4168, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4168, %tco.s0 ]
br label %tco.head
}
define ptr @mw512(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4171 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 8)
%t4172 = extractvalue {i64, i1} %t4171, 0
%t4173 = extractvalue {i64, i1} %t4171, 1
%t4174 = zext i1 %t4173 to i8
call void @resid_overflow_check(i8 %t4174)
%t4175 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t4172)
%t4176 = extractvalue {i64, i1} %t4175, 0
%t4177 = extractvalue {i64, i1} %t4175, 1
%t4178 = zext i1 %t4177 to i8
call void @resid_overflow_check(i8 %t4178)
%t4179 = call ptr @resid_list_get(ptr %p0, i64 %t4176)
%t4180 = call i64 @resid_unbox_i64(ptr %t4179)
%t4182 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4176, i64 1)
%t4183 = extractvalue {i64, i1} %t4182, 0
%t4184 = extractvalue {i64, i1} %t4182, 1
%t4185 = zext i1 %t4184 to i8
call void @resid_overflow_check(i8 %t4185)
%t4186 = call ptr @resid_list_get(ptr %p0, i64 %t4183)
%t4187 = call i64 @resid_unbox_i64(ptr %t4186)
%t4189 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4176, i64 2)
%t4190 = extractvalue {i64, i1} %t4189, 0
%t4191 = extractvalue {i64, i1} %t4189, 1
%t4192 = zext i1 %t4191 to i8
call void @resid_overflow_check(i8 %t4192)
%t4193 = call ptr @resid_list_get(ptr %p0, i64 %t4190)
%t4194 = call i64 @resid_unbox_i64(ptr %t4193)
%t4196 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4176, i64 3)
%t4197 = extractvalue {i64, i1} %t4196, 0
%t4198 = extractvalue {i64, i1} %t4196, 1
%t4199 = zext i1 %t4198 to i8
call void @resid_overflow_check(i8 %t4199)
%t4200 = call ptr @resid_list_get(ptr %p0, i64 %t4197)
%t4201 = call i64 @resid_unbox_i64(ptr %t4200)
%t4203 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4176, i64 4)
%t4204 = extractvalue {i64, i1} %t4203, 0
%t4205 = extractvalue {i64, i1} %t4203, 1
%t4206 = zext i1 %t4205 to i8
call void @resid_overflow_check(i8 %t4206)
%t4207 = call ptr @resid_list_get(ptr %p0, i64 %t4204)
%t4208 = call i64 @resid_unbox_i64(ptr %t4207)
%t4210 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4176, i64 5)
%t4211 = extractvalue {i64, i1} %t4210, 0
%t4212 = extractvalue {i64, i1} %t4210, 1
%t4213 = zext i1 %t4212 to i8
call void @resid_overflow_check(i8 %t4213)
%t4214 = call ptr @resid_list_get(ptr %p0, i64 %t4211)
%t4215 = call i64 @resid_unbox_i64(ptr %t4214)
%t4217 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4176, i64 6)
%t4218 = extractvalue {i64, i1} %t4217, 0
%t4219 = extractvalue {i64, i1} %t4217, 1
%t4220 = zext i1 %t4219 to i8
call void @resid_overflow_check(i8 %t4220)
%t4221 = call ptr @resid_list_get(ptr %p0, i64 %t4218)
%t4222 = call i64 @resid_unbox_i64(ptr %t4221)
%t4224 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4176, i64 7)
%t4225 = extractvalue {i64, i1} %t4224, 0
%t4226 = extractvalue {i64, i1} %t4224, 1
%t4227 = zext i1 %t4226 to i8
call void @resid_overflow_check(i8 %t4227)
%t4228 = call ptr @resid_list_get(ptr %p0, i64 %t4225)
%t4229 = call i64 @resid_unbox_i64(ptr %t4228)
%t4231 = shl i64 %t4180, 24
%t4232 = shl i64 %t4187, 16
%t4233 = shl i64 %t4194, 8
%t4234 = or i64 %t4231, %t4232
%t4235 = or i64 %t4234, %t4233
%t4236 = or i64 %t4235, %t4201
%t4237 = and i64 %t4236, 4294967295
%t4238 = shl i64 %t4208, 24
%t4239 = shl i64 %t4215, 16
%t4240 = shl i64 %t4222, 8
%t4241 = or i64 %t4238, %t4239
%t4242 = or i64 %t4241, %t4240
%t4243 = or i64 %t4242, %t4229
%t4244 = and i64 %t4243, 4294967295
%t4245 = alloca [2 x ptr]
%t4247 = call ptr @resid_box_i64(i64 %t4237)
%t4249 = getelementptr i8, ptr %t4245, i64 0
store ptr %t4247, ptr %t4249
%t4250 = call ptr @resid_box_i64(i64 %t4244)
%t4252 = getelementptr i8, ptr %t4245, i64 8
store ptr %t4250, ptr %t4252
%t4253 = call ptr @resid_list_new(i64 2, ptr %t4245, ptr @.lty4245)
ret ptr %t4253
}
define ptr @mw512_acc(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4258, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t4254 = icmp sge i64 %p2, 16
br i1 %t4254, label %L559, label %L561
L559:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L561:
%t4255 = call ptr @mw512(ptr %p0, i64 %p1, i64 %p2)
%t4256 = call ptr @resid_list_freeze(ptr %t4255)
%t4257 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t4256)
%t4258 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t4257, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t4257, %tco.s0 ]
br label %tco.head
}
define ptr @msg_words512(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4261 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4260)
%t4262 = call ptr @mw512_acc__rs282(ptr %p0, i64 %p1, i64 0, ptr %t4261)
ret ptr %t4262
}
define i64 @fw_hi(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4263 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 2)
%t4264 = extractvalue {i64, i1} %t4263, 0
%t4265 = extractvalue {i64, i1} %t4263, 1
%t4266 = zext i1 %t4265 to i8
call void @resid_overflow_check(i8 %t4266)
%t4267 = call ptr @resid_list_get(ptr %p0, i64 %t4264)
%t4268 = call i64 @resid_unbox_i64(ptr %t4267)
ret i64 %t4268
}
define i64 @fw_lo(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4270 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 2)
%t4271 = extractvalue {i64, i1} %t4270, 0
%t4272 = extractvalue {i64, i1} %t4270, 1
%t4273 = zext i1 %t4272 to i8
call void @resid_overflow_check(i8 %t4273)
%t4274 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4271, i64 1)
%t4275 = extractvalue {i64, i1} %t4274, 0
%t4276 = extractvalue {i64, i1} %t4274, 1
%t4277 = zext i1 %t4276 to i8
call void @resid_overflow_check(i8 %t4277)
%t4278 = call ptr @resid_list_get(ptr %p0, i64 %t4275)
%t4279 = call i64 @resid_unbox_i64(ptr %t4278)
ret i64 %t4279
}
define ptr @fw_pair(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4281 = call i64 @fw_hi(ptr %p0, i64 %p1)
%t4282 = call i64 @fw_lo(ptr %p0, i64 %p1)
%t4283 = call ptr @w64(i64 %t4281, i64 %t4282)
ret ptr %t4283
}
define i64 @ch64_of(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4284 = call i64 @not32(i64 %p0)
%t4285 = and i64 %p0, %p1
%t4286 = and i64 %t4284, %p2
%t4287 = xor i64 %t4285, %t4286
ret i64 %t4287
}
define ptr @hex_byte_at(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4288 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t4289 = call i64 @resid_unbox_i64(ptr %t4288)
%t4291 = and i64 %t4289, 255
%t4292 = ashr i64 %t4291, 4
%t4293 = and i64 %t4292, 15
%t4294 = call ptr @hex_digit(i64 %t4293)
%t4295 = and i64 %t4291, 15
%t4296 = call ptr @hex_digit(i64 %t4295)
%t4297 = call ptr @resid_str_concat(ptr %t4294, ptr %t4296)
ret ptr %t4297
}
define ptr @sig0(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4298 = call ptr @w64_rotr__rs284(ptr %p0, i64 1)
%t4299 = call ptr @w64_rotr__rs286(ptr %p0, i64 8)
%t4300 = call ptr @w64_shr__rs288(ptr %p0, i64 7)
%t4301 = call ptr @w64_xor(ptr %t4298, ptr %t4299)
%t4302 = call ptr @w64_xor(ptr %t4301, ptr %t4300)
ret ptr %t4302
}
define ptr @sig1(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4303 = call ptr @w64_rotr__rs290(ptr %p0, i64 19)
%t4304 = call ptr @w64_rotr__rs292(ptr %p0, i64 61)
%t4305 = call ptr @w64_shr__rs294(ptr %p0, i64 6)
%t4306 = call ptr @w64_xor(ptr %t4303, ptr %t4304)
%t4307 = call ptr @w64_xor(ptr %t4306, ptr %t4305)
ret ptr %t4307
}
define ptr @big_sig0(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4308 = call ptr @w64_rotr__rs296(ptr %p0, i64 28)
%t4309 = call ptr @w64_rotr__rs298(ptr %p0, i64 34)
%t4310 = call ptr @w64_rotr__rs300(ptr %p0, i64 39)
%t4311 = call ptr @w64_xor(ptr %t4308, ptr %t4309)
%t4312 = call ptr @w64_xor(ptr %t4311, ptr %t4310)
ret ptr %t4312
}
define ptr @big_sig1(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4313 = call ptr @w64_rotr__rs302(ptr %p0, i64 14)
%t4314 = call ptr @w64_rotr(ptr %p0, i64 18)
%t4315 = call ptr @w64_rotr(ptr %p0, i64 41)
%t4316 = call ptr @w64_xor(ptr %t4313, ptr %t4314)
%t4317 = call ptr @w64_xor(ptr %t4316, ptr %t4315)
ret ptr %t4317
}
define ptr @maj64(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4318 = call ptr @w64_and(ptr %p0, ptr %p1)
%t4319 = call ptr @w64_and(ptr %p0, ptr %p2)
%t4320 = call ptr @w64_and(ptr %p1, ptr %p2)
%t4321 = call ptr @w64_xor(ptr %t4318, ptr %t4319)
%t4322 = call ptr @w64_xor(ptr %t4321, ptr %t4320)
ret ptr %t4322
}
define ptr @ext512_flat(ptr %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4350 = alloca [1 x ptr]
%t4357 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4365, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%t4323 = icmp sge i64 %p1, %p2
br i1 %t4323, label %L562, label %L564
L562:
%lr.cx12 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz12 = icmp eq ptr %lr.cx12, null
br i1 %lr.lz12, label %lr.x12.k, label %lr.x12.m
lr.x12.k:
ret ptr %p0
lr.x12.m:
%lr.ret12 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx12)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret12
L564:
%t4324 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 15)
%t4325 = extractvalue {i64, i1} %t4324, 0
%t4326 = extractvalue {i64, i1} %t4324, 1
%t4327 = zext i1 %t4326 to i8
call void @resid_overflow_check(i8 %t4327)
%t4328 = call ptr @fw_pair(ptr %p0, i64 %t4325)
%t4329 = call ptr @sig0(ptr %t4328)
%t4330 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 2)
%t4331 = extractvalue {i64, i1} %t4330, 0
%t4332 = extractvalue {i64, i1} %t4330, 1
%t4333 = zext i1 %t4332 to i8
call void @resid_overflow_check(i8 %t4333)
%t4334 = call ptr @fw_pair(ptr %p0, i64 %t4331)
%t4335 = call ptr @sig1(ptr %t4334)
%t4336 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 16)
%t4337 = extractvalue {i64, i1} %t4336, 0
%t4338 = extractvalue {i64, i1} %t4336, 1
%t4339 = zext i1 %t4338 to i8
call void @resid_overflow_check(i8 %t4339)
%t4340 = call ptr @fw_pair(ptr %p0, i64 %t4337)
%t4341 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 7)
%t4342 = extractvalue {i64, i1} %t4341, 0
%t4343 = extractvalue {i64, i1} %t4341, 1
%t4344 = zext i1 %t4343 to i8
call void @resid_overflow_check(i8 %t4344)
%t4345 = call ptr @fw_pair(ptr %p0, i64 %t4342)
%t4346 = call ptr @w64_add(ptr %t4340, ptr %t4329)
%t4347 = call ptr @w64_add(ptr %t4345, ptr %t4335)
%t4348 = call ptr @w64_add(ptr %t4346, ptr %t4347)
%t4349 = call i64 @w64_hi(ptr %t4348)
%t4352 = call ptr @resid_box_i64(i64 %t4349)
%t4354 = getelementptr i8, ptr %t4350, i64 0
store ptr %t4352, ptr %t4354
%t4355 = call ptr @resid_list_new(i64 1, ptr %t4350, ptr @.lty4350)
%t4356 = call i64 @w64_lo(ptr %t4348)
%t4359 = call ptr @resid_box_i64(i64 %t4356)
%t4361 = getelementptr i8, ptr %t4357, i64 0
store ptr %t4359, ptr %t4361
%t4362 = call ptr @resid_list_new(i64 1, ptr %t4357, ptr @.lty4357)
%t4363 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t4355)
%t4364 = call ptr @resid_list_concat_own(ptr %t4363, i8 1, ptr %t4362)
%t4365 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4364, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4364, %tco.s0 ]
br label %tco.head
}
define ptr @state512_init() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4368 = call ptr @resid_list_const_i64(ptr @.lc4367, i64 16, ptr @.lcd4367, ptr @.lty4367)
ret ptr %t4368
}
define ptr @st_set(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4369 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 2)
%t4370 = extractvalue {i64, i1} %t4369, 0
%t4371 = extractvalue {i64, i1} %t4369, 1
%t4372 = zext i1 %t4371 to i8
call void @resid_overflow_check(i8 %t4372)
%t4373 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4370, i64 1)
%t4374 = extractvalue {i64, i1} %t4373, 0
%t4375 = extractvalue {i64, i1} %t4373, 1
%t4376 = zext i1 %t4375 to i8
call void @resid_overflow_check(i8 %t4376)
%t4377 = call i64 @w64_hi(ptr %p2)
%t4378 = call ptr @ls_set(ptr %p0, i64 %t4370, i64 %t4377)
%t4379 = call i64 @w64_lo(ptr %p2)
%t4380 = call ptr @ls_set(ptr %t4378, i64 %t4374, i64 %t4379)
ret ptr %t4380
}
define i64 @st_hi(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4381 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 2)
%t4382 = extractvalue {i64, i1} %t4381, 0
%t4383 = extractvalue {i64, i1} %t4381, 1
%t4384 = zext i1 %t4383 to i8
call void @resid_overflow_check(i8 %t4384)
%t4385 = call ptr @resid_list_get(ptr %p0, i64 %t4382)
%t4386 = call i64 @resid_unbox_i64(ptr %t4385)
ret i64 %t4386
}
define i64 @st_lo(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4388 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 2)
%t4389 = extractvalue {i64, i1} %t4388, 0
%t4390 = extractvalue {i64, i1} %t4388, 1
%t4391 = zext i1 %t4390 to i8
call void @resid_overflow_check(i8 %t4391)
%t4392 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4389, i64 1)
%t4393 = extractvalue {i64, i1} %t4392, 0
%t4394 = extractvalue {i64, i1} %t4392, 1
%t4395 = zext i1 %t4394 to i8
call void @resid_overflow_check(i8 %t4395)
%t4396 = call ptr @resid_list_get(ptr %p0, i64 %t4393)
%t4397 = call i64 @resid_unbox_i64(ptr %t4396)
ret i64 %t4397
}
define ptr @sha512_round_flat(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4399 = call ptr @fw_pair(ptr %p0, i64 0)
%t4400 = call ptr @fw_pair(ptr %p0, i64 1)
%t4401 = call ptr @fw_pair(ptr %p0, i64 2)
%t4402 = call ptr @fw_pair(ptr %p0, i64 3)
%t4403 = call ptr @fw_pair(ptr %p0, i64 4)
%t4404 = call ptr @resid_list_freeze(ptr %t4403)
%t4405 = call ptr @fw_pair(ptr %p0, i64 5)
%t4406 = call ptr @fw_pair(ptr %p0, i64 6)
%t4407 = call ptr @fw_pair(ptr %p0, i64 7)
%t4408 = call ptr @fw_pair(ptr %p1, i64 %p2)
%t4409 = call ptr @k512_limb_at(i64 %p2)
%t4410 = call ptr @big_sig1(ptr %t4404)
%t4411 = call ptr @w64_not(ptr %t4404)
%t4412 = call ptr @w64_and(ptr %t4404, ptr %t4405)
%t4413 = call ptr @w64_and(ptr %t4411, ptr %t4406)
%t4414 = call ptr @w64_xor(ptr %t4412, ptr %t4413)
%t4415 = call ptr @w64_add(ptr %t4407, ptr %t4410)
%t4416 = call ptr @w64_add(ptr %t4415, ptr %t4414)
%t4417 = call ptr @w64_add(ptr %t4416, ptr %t4409)
%t4418 = call ptr @w64_add(ptr %t4417, ptr %t4408)
%t4419 = call ptr @big_sig0(ptr %t4399)
%t4420 = call ptr @maj64(ptr %t4399, ptr %t4400, ptr %t4401)
%t4421 = call ptr @w64_add(ptr %t4419, ptr %t4420)
%t4422 = call ptr @w64_add(ptr %t4418, ptr %t4421)
%t4423 = call ptr @w64_add(ptr %t4402, ptr %t4418)
%t4424 = call ptr @resid_list_get(ptr %t4422, i64 0)
%t4425 = call i64 @resid_unbox_i64(ptr %t4424)
%t4427 = call ptr @resid_list_get(ptr %t4422, i64 1)
%t4428 = call i64 @resid_unbox_i64(ptr %t4427)
%t4430 = call ptr @resid_list_get(ptr %t4399, i64 0)
%t4431 = call i64 @resid_unbox_i64(ptr %t4430)
%t4433 = call ptr @resid_list_get(ptr %t4399, i64 1)
%t4434 = call i64 @resid_unbox_i64(ptr %t4433)
%t4436 = call ptr @resid_list_get(ptr %t4400, i64 0)
%t4437 = call i64 @resid_unbox_i64(ptr %t4436)
%t4439 = call ptr @resid_list_get(ptr %t4400, i64 1)
%t4440 = call i64 @resid_unbox_i64(ptr %t4439)
%t4442 = call ptr @resid_list_get(ptr %t4401, i64 0)
%t4443 = call i64 @resid_unbox_i64(ptr %t4442)
%t4445 = call ptr @resid_list_get(ptr %t4401, i64 1)
%t4446 = call i64 @resid_unbox_i64(ptr %t4445)
%t4448 = call ptr @resid_list_get(ptr %t4423, i64 0)
%t4449 = call i64 @resid_unbox_i64(ptr %t4448)
%t4451 = call ptr @resid_list_get(ptr %t4423, i64 1)
%t4452 = call i64 @resid_unbox_i64(ptr %t4451)
%t4454 = call ptr @resid_list_get(ptr %t4404, i64 0)
%t4455 = call i64 @resid_unbox_i64(ptr %t4454)
%t4457 = call ptr @resid_list_get(ptr %t4404, i64 1)
%t4458 = call i64 @resid_unbox_i64(ptr %t4457)
%t4460 = call ptr @resid_list_get(ptr %t4405, i64 0)
%t4461 = call i64 @resid_unbox_i64(ptr %t4460)
%t4463 = call ptr @resid_list_get(ptr %t4405, i64 1)
%t4464 = call i64 @resid_unbox_i64(ptr %t4463)
%t4466 = call ptr @resid_list_get(ptr %t4406, i64 0)
%t4467 = call i64 @resid_unbox_i64(ptr %t4466)
%t4469 = call ptr @resid_list_get(ptr %t4406, i64 1)
%t4470 = call i64 @resid_unbox_i64(ptr %t4469)
%t4472 = alloca [16 x ptr]
%t4474 = call ptr @resid_box_i64(i64 %t4425)
%t4476 = getelementptr i8, ptr %t4472, i64 0
store ptr %t4474, ptr %t4476
%t4477 = call ptr @resid_box_i64(i64 %t4428)
%t4479 = getelementptr i8, ptr %t4472, i64 8
store ptr %t4477, ptr %t4479
%t4480 = call ptr @resid_box_i64(i64 %t4431)
%t4482 = getelementptr i8, ptr %t4472, i64 16
store ptr %t4480, ptr %t4482
%t4483 = call ptr @resid_box_i64(i64 %t4434)
%t4485 = getelementptr i8, ptr %t4472, i64 24
store ptr %t4483, ptr %t4485
%t4486 = call ptr @resid_box_i64(i64 %t4437)
%t4488 = getelementptr i8, ptr %t4472, i64 32
store ptr %t4486, ptr %t4488
%t4489 = call ptr @resid_box_i64(i64 %t4440)
%t4491 = getelementptr i8, ptr %t4472, i64 40
store ptr %t4489, ptr %t4491
%t4492 = call ptr @resid_box_i64(i64 %t4443)
%t4494 = getelementptr i8, ptr %t4472, i64 48
store ptr %t4492, ptr %t4494
%t4495 = call ptr @resid_box_i64(i64 %t4446)
%t4497 = getelementptr i8, ptr %t4472, i64 56
store ptr %t4495, ptr %t4497
%t4498 = call ptr @resid_box_i64(i64 %t4449)
%t4500 = getelementptr i8, ptr %t4472, i64 64
store ptr %t4498, ptr %t4500
%t4501 = call ptr @resid_box_i64(i64 %t4452)
%t4503 = getelementptr i8, ptr %t4472, i64 72
store ptr %t4501, ptr %t4503
%t4504 = call ptr @resid_box_i64(i64 %t4455)
%t4506 = getelementptr i8, ptr %t4472, i64 80
store ptr %t4504, ptr %t4506
%t4507 = call ptr @resid_box_i64(i64 %t4458)
%t4509 = getelementptr i8, ptr %t4472, i64 88
store ptr %t4507, ptr %t4509
%t4510 = call ptr @resid_box_i64(i64 %t4461)
%t4512 = getelementptr i8, ptr %t4472, i64 96
store ptr %t4510, ptr %t4512
%t4513 = call ptr @resid_box_i64(i64 %t4464)
%t4515 = getelementptr i8, ptr %t4472, i64 104
store ptr %t4513, ptr %t4515
%t4516 = call ptr @resid_box_i64(i64 %t4467)
%t4518 = getelementptr i8, ptr %t4472, i64 112
store ptr %t4516, ptr %t4518
%t4519 = call ptr @resid_box_i64(i64 %t4470)
%t4521 = getelementptr i8, ptr %t4472, i64 120
store ptr %t4519, ptr %t4521
%t4522 = call ptr @resid_list_new(i64 16, ptr %t4472, ptr @.lty4472)
ret ptr %t4522
}
define ptr @sha512_rounds_flat(ptr %p0.in, ptr %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4525, %tco.s0.k ]
%t4523 = icmp sge i64 %p2, 80
br i1 %t4523, label %L565, label %L567
L565:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr %p0
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L567:
%t4524 = call ptr @sha512_round_flat(ptr %p0, ptr %p1, i64 %p2)
%t4525 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4524, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4524, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
br label %tco.head
}
define ptr @add_st_word(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4527 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 2)
%t4528 = extractvalue {i64, i1} %t4527, 0
%t4529 = extractvalue {i64, i1} %t4527, 1
%t4530 = zext i1 %t4529 to i8
call void @resid_overflow_check(i8 %t4530)
%t4531 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4528, i64 1)
%t4532 = extractvalue {i64, i1} %t4531, 0
%t4533 = extractvalue {i64, i1} %t4531, 1
%t4534 = zext i1 %t4533 to i8
call void @resid_overflow_check(i8 %t4534)
%t4535 = call ptr @resid_list_get(ptr %p0, i64 %t4528)
%t4536 = call i64 @resid_unbox_i64(ptr %t4535)
%t4538 = call ptr @resid_list_get(ptr %p0, i64 %t4532)
%t4539 = call i64 @resid_unbox_i64(ptr %t4538)
%t4541 = call ptr @w64(i64 %t4536, i64 %t4539)
%t4542 = call ptr @resid_list_get(ptr %p1, i64 %t4528)
%t4543 = call i64 @resid_unbox_i64(ptr %t4542)
%t4545 = call ptr @resid_list_get(ptr %p1, i64 %t4532)
%t4546 = call i64 @resid_unbox_i64(ptr %t4545)
%t4548 = call ptr @w64(i64 %t4543, i64 %t4546)
%t4549 = call ptr @w64_add(ptr %t4541, ptr %t4548)
ret ptr %t4549
}
define ptr @add_st_acc(ptr %p0.in, ptr %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4551, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t4550 = icmp sge i64 %p2, 8
br i1 %t4550, label %L568, label %L570
L568:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L570:
%t4551 = add nsw i64 %p2, 1
%t4552 = call ptr @add_st_word(ptr %p0, ptr %p1, i64 %p2)
%t4553 = call ptr @resid_list_freeze(ptr %t4552)
%t4554 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t4553)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t4554, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t4554, %tco.s0 ]
br label %tco.head
}
define ptr @add_st(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4557 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4556)
%t4558 = call ptr @add_st_acc(ptr %p0, ptr %p1, i64 %p2, ptr %t4557)
ret ptr %t4558
}
define ptr @digest_block512f(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4559 = call ptr @msg_words512(ptr %p0, i64 %p1)
%t4560 = call ptr @ext512_flat(ptr %t4559, i64 16, i64 80)
%t4561 = call ptr @sha512_rounds_flat__rs330(ptr %p2, ptr %t4560, i64 0)
%t4562 = call ptr @add_st(ptr %p2, ptr %t4561, i64 0)
ret ptr %t4562
}
define ptr @digest_blocks512f(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4566, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t4563 = icmp sge i64 %p1, %p2
br i1 %t4563, label %L571, label %L573
L571:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L573:
%t4564 = call ptr @digest_block512f(ptr %p0, i64 %p1, ptr %p3)
%t4565 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 128)
%t4566 = extractvalue {i64, i1} %t4565, 0
%t4567 = extractvalue {i64, i1} %t4565, 1
%t4568 = zext i1 %t4567 to i8
call void @resid_overflow_check(i8 %t4568)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t4564, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t4564, %tco.s0 ]
br label %tco.head
}
define ptr @hex_range_b(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4574, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t4572, %tco.s0 ]
%t4570 = icmp sgt i64 %p1, %p2
br i1 %t4570, label %L574, label %L576
L574:
ret ptr %p3
L576:
%t4571 = call ptr @hex_byte_at(ptr %p0, i64 %p1)
%t4572 = call ptr @resid_str_concat(ptr %p3, ptr %t4571)
%t4573 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t4574 = extractvalue {i64, i1} %t4573, 0
%t4575 = extractvalue {i64, i1} %t4573, 1
%t4576 = zext i1 %t4575 to i8
call void @resid_overflow_check(i8 %t4576)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @r64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4578 = add i64 %p1, 0
%t4579 = add i64 %t4578, 0
%t4580 = add i64 %t4579, 0
%t4581 = icmp ne i64 %t4580, %t4578
%t4582 = icmp slt i64 %p1, 0
%t4583 = or i1 %t4581, %t4582
%t4584 = zext i1 %t4583 to i8
call void @resid_conv_check(i8 %t4584)
%t4585 = icmp uge i64 %t4579, 64
%t4586 = add i64 %t4579, 0
%t4587 = lshr i64 %p0, %t4586
%t4588 = select i1 %t4585, i64 0, i64 %t4587
%t4589 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 64, i64 %p1)
%t4590 = extractvalue {i64, i1} %t4589, 0
%t4591 = extractvalue {i64, i1} %t4589, 1
%t4592 = zext i1 %t4591 to i8
call void @resid_overflow_check(i8 %t4592)
%t4593 = add i64 %t4590, 0
%t4594 = add i64 %t4593, 0
%t4595 = add i64 %t4594, 0
%t4596 = icmp ne i64 %t4595, %t4593
%t4597 = icmp slt i64 %t4590, 0
%t4598 = or i1 %t4596, %t4597
%t4599 = zext i1 %t4598 to i8
call void @resid_conv_check(i8 %t4599)
%t4600 = icmp uge i64 %t4594, 64
%t4601 = add i64 %t4594, 0
%t4602 = shl i64 %p0, %t4601
%t4603 = select i1 %t4600, i64 0, i64 %t4602
%t4604 = or i64 %t4588, %t4603
ret i64 %t4604
}
define i64 @bs0_64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4605 = call i64 @r64(i64 %p0, i64 28)
%t4606 = call i64 @r64(i64 %p0, i64 34)
%t4607 = xor i64 %t4605, %t4606
%t4608 = call i64 @r64(i64 %p0, i64 39)
%t4609 = xor i64 %t4607, %t4608
ret i64 %t4609
}
define i64 @bs1_64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4610 = call i64 @r64(i64 %p0, i64 14)
%t4611 = call i64 @r64(i64 %p0, i64 18)
%t4612 = xor i64 %t4610, %t4611
%t4613 = call i64 @r64(i64 %p0, i64 41)
%t4614 = xor i64 %t4612, %t4613
ret i64 %t4614
}
define i64 @ss0_64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4615 = call i64 @r64(i64 %p0, i64 1)
%t4616 = call i64 @r64(i64 %p0, i64 8)
%t4617 = xor i64 %t4615, %t4616
%t4618 = lshr i64 %p0, 7
%t4619 = xor i64 %t4617, %t4618
ret i64 %t4619
}
define i64 @ss1_64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4620 = call i64 @r64(i64 %p0, i64 19)
%t4621 = call i64 @r64(i64 %p0, i64 61)
%t4622 = xor i64 %t4620, %t4621
%t4623 = lshr i64 %p0, 6
%t4624 = xor i64 %t4622, %t4623
ret i64 %t4624
}
define i64 @k512_u(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4625 = call ptr @k512_limb_at(i64 %p0)
%t4626 = call ptr @resid_list_get(ptr %t4625, i64 0)
%t4627 = call i64 @resid_unbox_i64(ptr %t4626)
%t4629 = add i64 %t4627, 0
%t4630 = add i64 %t4629, 0
%t4631 = add i64 %t4630, 0
%t4632 = icmp ne i64 %t4631, %t4629
%t4633 = icmp slt i64 %t4627, 0
%t4634 = or i1 %t4632, %t4633
%t4635 = zext i1 %t4634 to i8
call void @resid_conv_check(i8 %t4635)
%t4636 = shl i64 %t4630, 32
%t4637 = call ptr @resid_list_get(ptr %t4625, i64 1)
%t4638 = call i64 @resid_unbox_i64(ptr %t4637)
%t4640 = add i64 %t4638, 0
%t4641 = add i64 %t4640, 0
%t4642 = add i64 %t4641, 0
%t4643 = icmp ne i64 %t4642, %t4640
%t4644 = icmp slt i64 %t4638, 0
%t4645 = or i1 %t4643, %t4644
%t4646 = zext i1 %t4645 to i8
call void @resid_conv_check(i8 %t4646)
%t4647 = or i64 %t4636, %t4641
ret i64 %t4647
}
define i64 @word64_at(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4648 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 8)
%t4649 = extractvalue {i64, i1} %t4648, 0
%t4650 = extractvalue {i64, i1} %t4648, 1
%t4651 = zext i1 %t4650 to i8
call void @resid_overflow_check(i8 %t4651)
%t4652 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t4649)
%t4653 = extractvalue {i64, i1} %t4652, 0
%t4654 = extractvalue {i64, i1} %t4652, 1
%t4655 = zext i1 %t4654 to i8
call void @resid_overflow_check(i8 %t4655)
%t4656 = call i64 @w64_bytes__rs344(ptr %p0, i64 %t4653, i64 0, i64 0)
ret i64 %t4656
}
define i64 @w64_bytes(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4658, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t4668, %tco.s0 ]
%t4657 = icmp sge i64 %p2, 8
br i1 %t4657, label %L577, label %L579
L577:
ret i64 %p3
L579:
%t4658 = add nsw i64 %p2, 1
%t4659 = shl i64 %p3, 8
%t4660 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p2)
%t4661 = extractvalue {i64, i1} %t4660, 0
%t4662 = extractvalue {i64, i1} %t4660, 1
%t4663 = zext i1 %t4662 to i8
call void @resid_overflow_check(i8 %t4663)
%t4664 = call ptr @resid_list_get_v(ptr %p0, i64 %t4661, ptr %p0.ld, i64 %p0.ln)
%t4665 = call i64 @resid_unbox_i64(ptr %t4664)
%t4667 = and i64 %t4665, 255
%t4668 = or i64 %t4659, %t4667
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @sched64(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4670 = icmp slt i64 %p2, 16
br i1 %t4670, label %L580, label %L582
L580:
%t4671 = call i64 @word64_at(ptr %p0, i64 %p1, i64 %p2)
ret i64 %t4671
L582:
%t4672 = call i64 @ss1_64(i64 %p6)
%t4673 = call i64 @wrapping_uadd(i64 %t4672, i64 %p5)
%t4674 = call i64 @ss0_64(i64 %p4)
%t4675 = call i64 @wrapping_uadd(i64 %t4674, i64 %p3)
%t4676 = call i64 @wrapping_uadd(i64 %t4673, i64 %t4675)
ret i64 %t4676
}
define ptr @sha512_blk(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in, i64 %p19.in, i64 %p20.in, i64 %p21.in, i64 %p22.in, i64 %p23.in, i64 %p24.in, i64 %p25.in, i64 %p26.in, i64 %p27.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4722, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t4723, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t4724, %tco.s0.k ]
%p9 = phi i64 [ %p9.in, %entry ], [ %p8, %tco.s0.k ]
%p10 = phi i64 [ %p10.in, %entry ], [ %p9, %tco.s0.k ]
%p11 = phi i64 [ %p11.in, %entry ], [ %p10, %tco.s0.k ]
%p12 = phi i64 [ %p12.in, %entry ], [ %p13, %tco.s0.k ]
%p13 = phi i64 [ %p13.in, %entry ], [ %p14, %tco.s0.k ]
%p14 = phi i64 [ %p14.in, %entry ], [ %p15, %tco.s0.k ]
%p15 = phi i64 [ %p15.in, %entry ], [ %p16, %tco.s0.k ]
%p16 = phi i64 [ %p16.in, %entry ], [ %p17, %tco.s0.k ]
%p17 = phi i64 [ %p17.in, %entry ], [ %p18, %tco.s0.k ]
%p18 = phi i64 [ %p18.in, %entry ], [ %p19, %tco.s0.k ]
%p19 = phi i64 [ %p19.in, %entry ], [ %p20, %tco.s0.k ]
%p20 = phi i64 [ %p20.in, %entry ], [ %p21, %tco.s0.k ]
%p21 = phi i64 [ %p21.in, %entry ], [ %p22, %tco.s0.k ]
%p22 = phi i64 [ %p22.in, %entry ], [ %p23, %tco.s0.k ]
%p23 = phi i64 [ %p23.in, %entry ], [ %p24, %tco.s0.k ]
%p24 = phi i64 [ %p24.in, %entry ], [ %p25, %tco.s0.k ]
%p25 = phi i64 [ %p25.in, %entry ], [ %p26, %tco.s0.k ]
%p26 = phi i64 [ %p26.in, %entry ], [ %p27, %tco.s0.k ]
%p27 = phi i64 [ %p27.in, %entry ], [ %t4703, %tco.s0.k ]
%t4677 = icmp sge i64 %p2, 80
br i1 %t4677, label %L583, label %L585
L583:
%t4678 = call ptr @resid_gmalloc(i64 64)
%t4679 = getelementptr i8, ptr %p3, i64 0
%t4680 = load i64, ptr %t4679, align 8
%t4681 = call i64 @wrapping_uadd(i64 %t4680, i64 %p4)
%t4678.f0 = getelementptr i8, ptr %t4678, i64 0
store i64 %t4681, ptr %t4678.f0, align 8
%t4682 = getelementptr i8, ptr %p3, i64 8
%t4683 = load i64, ptr %t4682, align 8
%t4684 = call i64 @wrapping_uadd(i64 %t4683, i64 %p5)
%t4678.f1 = getelementptr i8, ptr %t4678, i64 8
store i64 %t4684, ptr %t4678.f1, align 8
%t4685 = getelementptr i8, ptr %p3, i64 16
%t4686 = load i64, ptr %t4685, align 8
%t4687 = call i64 @wrapping_uadd(i64 %t4686, i64 %p6)
%t4678.f2 = getelementptr i8, ptr %t4678, i64 16
store i64 %t4687, ptr %t4678.f2, align 8
%t4688 = getelementptr i8, ptr %p3, i64 24
%t4689 = load i64, ptr %t4688, align 8
%t4690 = call i64 @wrapping_uadd(i64 %t4689, i64 %p7)
%t4678.f3 = getelementptr i8, ptr %t4678, i64 24
store i64 %t4690, ptr %t4678.f3, align 8
%t4691 = getelementptr i8, ptr %p3, i64 32
%t4692 = load i64, ptr %t4691, align 8
%t4693 = call i64 @wrapping_uadd(i64 %t4692, i64 %p8)
%t4678.f4 = getelementptr i8, ptr %t4678, i64 32
store i64 %t4693, ptr %t4678.f4, align 8
%t4694 = getelementptr i8, ptr %p3, i64 40
%t4695 = load i64, ptr %t4694, align 8
%t4696 = call i64 @wrapping_uadd(i64 %t4695, i64 %p9)
%t4678.f5 = getelementptr i8, ptr %t4678, i64 40
store i64 %t4696, ptr %t4678.f5, align 8
%t4697 = getelementptr i8, ptr %p3, i64 48
%t4698 = load i64, ptr %t4697, align 8
%t4699 = call i64 @wrapping_uadd(i64 %t4698, i64 %p10)
%t4678.f6 = getelementptr i8, ptr %t4678, i64 48
store i64 %t4699, ptr %t4678.f6, align 8
%t4700 = getelementptr i8, ptr %p3, i64 56
%t4701 = load i64, ptr %t4700, align 8
%t4702 = call i64 @wrapping_uadd(i64 %t4701, i64 %p11)
%t4678.f7 = getelementptr i8, ptr %t4678, i64 56
store i64 %t4702, ptr %t4678.f7, align 8
%lr.cx76 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz76 = icmp eq ptr %lr.cx76, null
br i1 %lr.lz76, label %lr.x76.k, label %lr.x76.m
lr.x76.k:
ret ptr %t4678
lr.x76.m:
%lr.ret76 = call ptr @"resid.rec.evac.W512"(ptr %t4678, ptr %lr.cx76)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret76
L585:
%t4703 = call i64 @sched64(ptr %p0, i64 %p1, i64 %p2, i64 %p12, i64 %p13, i64 %p21, i64 %p26)
%t4704 = and i64 %p8, %p9
%t4705 = xor i64 %p8, -1
%t4706 = and i64 %t4705, %p10
%t4707 = xor i64 %t4704, %t4706
%t4708 = call i64 @resid_scope_push()
%t4709 = call i64 @bs1_64(i64 %p8)
%t4710 = call i64 @wrapping_uadd(i64 %p11, i64 %t4709)
%t4711 = call i64 @k512_u(i64 %p2)
%t4712 = call i64 @wrapping_uadd(i64 %t4707, i64 %t4711)
%t4713 = call i64 @wrapping_uadd(i64 %t4710, i64 %t4712)
%t4714 = call i64 @wrapping_uadd(i64 %t4713, i64 %t4703)
call void @resid_scope_pop(i64 %t4708)
%t4715 = call i64 @bs0_64(i64 %p4)
%t4716 = and i64 %p4, %p5
%t4717 = and i64 %p4, %p6
%t4718 = xor i64 %t4716, %t4717
%t4719 = and i64 %p5, %p6
%t4720 = xor i64 %t4718, %t4719
%t4721 = call i64 @wrapping_uadd(i64 %t4715, i64 %t4720)
%t4722 = add nsw i64 %p2, 1
%t4723 = call i64 @wrapping_uadd(i64 %t4714, i64 %t4721)
%t4724 = call i64 @wrapping_uadd(i64 %p7, i64 %t4714)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @"resid.rec.evac.W512"(ptr %p3, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %p3, %tco.s0 ]
br label %tco.head
}
define ptr @sha512_blocks(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4732, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t4726 = icmp sge i64 %p1, %p2
br i1 %t4726, label %L586, label %L588
L586:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @"resid.rec.evac.W512"(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L588:
%t4727 = call i8 @resid_cpu_has_sha512()
%t4728 = icmp ne i8 %t4727, 0
br i1 %t4728, label %L589, label %L591
L589:
%t4729 = call i512 @sha512_hw_state(ptr %p3)
%t4730 = call ptr @sha512_hw_blocks(ptr %p0, i64 %p1, i64 %p2, i512 %t4729)
%lr.cx19 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz19 = icmp eq ptr %lr.cx19, null
br i1 %lr.lz19, label %lr.x19.k, label %lr.x19.m
lr.x19.k:
ret ptr %t4730
lr.x19.m:
%lr.ret19 = call ptr @"resid.rec.evac.W512"(ptr %t4730, ptr %lr.cx19)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret19
L591:
%t4731 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 128)
%t4732 = extractvalue {i64, i1} %t4731, 0
%t4733 = extractvalue {i64, i1} %t4731, 1
%t4734 = zext i1 %t4733 to i8
call void @resid_overflow_check(i8 %t4734)
%t4735 = getelementptr i8, ptr %p3, i64 0
%t4736 = load i64, ptr %t4735, align 8
%t4737 = getelementptr i8, ptr %p3, i64 8
%t4738 = load i64, ptr %t4737, align 8
%t4739 = getelementptr i8, ptr %p3, i64 16
%t4740 = load i64, ptr %t4739, align 8
%t4741 = getelementptr i8, ptr %p3, i64 24
%t4742 = load i64, ptr %t4741, align 8
%t4743 = getelementptr i8, ptr %p3, i64 32
%t4744 = load i64, ptr %t4743, align 8
%t4745 = getelementptr i8, ptr %p3, i64 40
%t4746 = load i64, ptr %t4745, align 8
%t4747 = getelementptr i8, ptr %p3, i64 48
%t4748 = load i64, ptr %t4747, align 8
%t4749 = getelementptr i8, ptr %p3, i64 56
%t4750 = load i64, ptr %t4749, align 8
%t4751 = call ptr @sha512_blk(ptr %p0, i64 %p1, i64 0, ptr %p3, i64 %t4736, i64 %t4738, i64 %t4740, i64 %t4742, i64 %t4744, i64 %t4746, i64 %t4748, i64 %t4750, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @"resid.rec.evac.W512"(ptr %t4751, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t4751, %tco.s0 ]
br label %tco.head
}
define i512 @sha512_hw_state(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4753 = getelementptr i8, ptr %p0, i64 0
%t4754 = load i64, ptr %t4753, align 8
%t4755 = zext i64 %t4754 to i512
%t4756 = getelementptr i8, ptr %p0, i64 8
%t4757 = load i64, ptr %t4756, align 8
%t4758 = zext i64 %t4757 to i512
%t4759 = shl i512 %t4758, 64
%t4760 = or i512 %t4755, %t4759
%t4761 = getelementptr i8, ptr %p0, i64 16
%t4762 = load i64, ptr %t4761, align 8
%t4763 = zext i64 %t4762 to i512
%t4764 = shl i512 %t4763, 128
%t4765 = or i512 %t4760, %t4764
%t4766 = getelementptr i8, ptr %p0, i64 24
%t4767 = load i64, ptr %t4766, align 8
%t4768 = zext i64 %t4767 to i512
%t4769 = shl i512 %t4768, 192
%t4770 = or i512 %t4765, %t4769
%t4771 = getelementptr i8, ptr %p0, i64 32
%t4772 = load i64, ptr %t4771, align 8
%t4773 = zext i64 %t4772 to i512
%t4774 = shl i512 %t4773, 256
%t4775 = or i512 %t4770, %t4774
%t4776 = getelementptr i8, ptr %p0, i64 40
%t4777 = load i64, ptr %t4776, align 8
%t4778 = zext i64 %t4777 to i512
%t4779 = shl i512 %t4778, 320
%t4780 = or i512 %t4775, %t4779
%t4781 = getelementptr i8, ptr %p0, i64 48
%t4782 = load i64, ptr %t4781, align 8
%t4783 = zext i64 %t4782 to i512
%t4784 = shl i512 %t4783, 384
%t4785 = or i512 %t4780, %t4784
%t4786 = getelementptr i8, ptr %p0, i64 56
%t4787 = load i64, ptr %t4786, align 8
%t4788 = zext i64 %t4787 to i512
%t4789 = shl i512 %t4788, 448
%t4790 = or i512 %t4785, %t4789
ret i512 %t4790
}
define i64 @sha512_hw_word(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4791 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 64, i64 %p1)
%t4792 = extractvalue {i64, i1} %t4791, 0
%t4793 = extractvalue {i64, i1} %t4791, 1
%t4794 = zext i1 %t4793 to i8
call void @resid_overflow_check(i8 %t4794)
%t4795 = sext i64 %t4792 to i512
%t4796 = add i512 %t4795, 0
%t4797 = add i512 %t4796, 0
%t4798 = icmp ne i512 %t4797, %t4795
%t4799 = icmp slt i64 %t4792, 0
%t4800 = or i1 %t4798, %t4799
%t4801 = zext i1 %t4800 to i8
call void @resid_conv_check(i8 %t4801)
%t4802 = icmp uge i512 %t4796, 512
%t4803 = add i512 %t4796, 0
%t4804 = lshr i512 %p0, %t4803
%t4805 = select i1 %t4802, i512 0, i512 %t4804
%t4806 = sext i128 18446744073709551615 to i512
%t4807 = add i512 %t4806, 0
%t4808 = add i512 %t4807, 0
%t4809 = icmp ne i512 %t4808, %t4806
%t4810 = icmp slt i128 18446744073709551615, 0
%t4811 = or i1 %t4809, %t4810
%t4812 = zext i1 %t4811 to i8
call void @resid_conv_check(i8 %t4812)
%t4813 = and i512 %t4805, %t4807
%t4814 = add i512 %t4813, 0
%t4815 = trunc i512 %t4814 to i64
%t4816 = zext i64 %t4815 to i512
%t4817 = icmp ne i512 %t4816, %t4814
%t4818 = icmp eq i8 0, 1
%t4819 = or i1 %t4817, %t4818
%t4820 = zext i1 %t4819 to i8
call void @resid_conv_check(i8 %t4820)
ret i64 %t4815
}
define i512 @sha512_hw_block(ptr %p0.in, i64 %p1.in, i64 %p2.in, i512 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4849, %tco.s0 ]
%p3 = phi i512 [ %p3.in, %entry ], [ %t4866, %tco.s0 ]
%t4821 = icmp sge i64 %p2, 8
br i1 %t4821, label %L592, label %L594
L592:
ret i512 %p3
L594:
%t4822 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p2)
%t4823 = extractvalue {i64, i1} %t4822, 0
%t4824 = extractvalue {i64, i1} %t4822, 1
%t4825 = zext i1 %t4824 to i8
call void @resid_overflow_check(i8 %t4825)
%t4826 = call i64 @word_at_list(ptr %p0, i64 %p1, i64 %t4823)
%t4827 = add i64 %t4826, 0
%t4828 = add i64 %t4827, 0
%t4829 = add i64 %t4828, 0
%t4830 = icmp ne i64 %t4829, %t4827
%t4831 = icmp slt i64 %t4826, 0
%t4832 = or i1 %t4830, %t4831
%t4833 = zext i1 %t4832 to i8
call void @resid_conv_check(i8 %t4833)
%t4834 = shl i64 %t4828, 32
%t4835 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p2)
%t4836 = extractvalue {i64, i1} %t4835, 0
%t4837 = extractvalue {i64, i1} %t4835, 1
%t4838 = zext i1 %t4837 to i8
call void @resid_overflow_check(i8 %t4838)
%t4839 = add nsw i64 %t4836, 1
%t4840 = call i64 @word_at_list(ptr %p0, i64 %p1, i64 %t4839)
%t4841 = add i64 %t4840, 0
%t4842 = add i64 %t4841, 0
%t4843 = add i64 %t4842, 0
%t4844 = icmp ne i64 %t4843, %t4841
%t4845 = icmp slt i64 %t4840, 0
%t4846 = or i1 %t4844, %t4845
%t4847 = zext i1 %t4846 to i8
call void @resid_conv_check(i8 %t4847)
%t4848 = or i64 %t4834, %t4842
%t4849 = add nsw i64 %p2, 1
%t4850 = zext i64 %t4848 to i512
%t4851 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 64, i64 %p2)
%t4852 = extractvalue {i64, i1} %t4851, 0
%t4853 = extractvalue {i64, i1} %t4851, 1
%t4854 = zext i1 %t4853 to i8
call void @resid_overflow_check(i8 %t4854)
%t4855 = sext i64 %t4852 to i512
%t4856 = add i512 %t4855, 0
%t4857 = add i512 %t4856, 0
%t4858 = icmp ne i512 %t4857, %t4855
%t4859 = icmp slt i64 %t4852, 0
%t4860 = or i1 %t4858, %t4859
%t4861 = zext i1 %t4860 to i8
call void @resid_conv_check(i8 %t4861)
%t4862 = icmp uge i512 %t4856, 512
%t4863 = add i512 %t4856, 0
%t4864 = shl i512 %t4850, %t4863
%t4865 = select i1 %t4862, i512 0, i512 %t4864
%t4866 = or i512 %p3, %t4865
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @sha512_hw_blocks(ptr %p0.in, i64 %p1.in, i64 %p2.in, i512 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4879, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi i512 [ %p3.in, %entry ], [ %t4888, %tco.s0.k ]
%t4868 = icmp sge i64 %p1, %p2
br i1 %t4868, label %L595, label %L597
L595:
%t4869 = call ptr @resid_gmalloc(i64 64)
%t4870 = call i64 @sha512_hw_word(i512 %p3, i64 0)
%t4869.f0 = getelementptr i8, ptr %t4869, i64 0
store i64 %t4870, ptr %t4869.f0, align 8
%t4871 = call i64 @sha512_hw_word(i512 %p3, i64 1)
%t4869.f1 = getelementptr i8, ptr %t4869, i64 8
store i64 %t4871, ptr %t4869.f1, align 8
%t4872 = call i64 @sha512_hw_word(i512 %p3, i64 2)
%t4869.f2 = getelementptr i8, ptr %t4869, i64 16
store i64 %t4872, ptr %t4869.f2, align 8
%t4873 = call i64 @sha512_hw_word(i512 %p3, i64 3)
%t4869.f3 = getelementptr i8, ptr %t4869, i64 24
store i64 %t4873, ptr %t4869.f3, align 8
%t4874 = call i64 @sha512_hw_word(i512 %p3, i64 4)
%t4869.f4 = getelementptr i8, ptr %t4869, i64 32
store i64 %t4874, ptr %t4869.f4, align 8
%t4875 = call i64 @sha512_hw_word(i512 %p3, i64 5)
%t4869.f5 = getelementptr i8, ptr %t4869, i64 40
store i64 %t4875, ptr %t4869.f5, align 8
%t4876 = call i64 @sha512_hw_word(i512 %p3, i64 6)
%t4869.f6 = getelementptr i8, ptr %t4869, i64 48
store i64 %t4876, ptr %t4869.f6, align 8
%t4877 = call i64 @sha512_hw_word(i512 %p3, i64 7)
%t4869.f7 = getelementptr i8, ptr %t4869, i64 56
store i64 %t4877, ptr %t4869.f7, align 8
%lr.cx36 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz36 = icmp eq ptr %lr.cx36, null
br i1 %lr.lz36, label %lr.x36.k, label %lr.x36.m
lr.x36.k:
ret ptr %t4869
lr.x36.m:
%lr.ret36 = call ptr @"resid.rec.evac.W512"(ptr %t4869, ptr %lr.cx36)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret36
L597:
%t4878 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 128)
%t4879 = extractvalue {i64, i1} %t4878, 0
%t4880 = extractvalue {i64, i1} %t4878, 1
%t4881 = zext i1 %t4880 to i8
call void @resid_overflow_check(i8 %t4881)
%t4882 = call i512 @sha512_hw_block(ptr %p0, i64 %p1, i64 0, i512 0)
%t4883 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t4884 = extractvalue {i64, i1} %t4883, 0
%t4885 = extractvalue {i64, i1} %t4883, 1
%t4886 = zext i1 %t4885 to i8
call void @resid_overflow_check(i8 %t4886)
%t4887 = call i512 @sha512_hw_block(ptr %p0, i64 %t4884, i64 0, i512 0)
%t4888 = call i512 @e.sha512(i512 %p3, i512 %t4882, i512 %t4887)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
br label %tco.head
}
define ptr @sha512_iv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4890 = call ptr @resid_gmalloc(i64 64)
%t4891 = add i64 7640891576956012808, 0
%t4892 = add i64 %t4891, 0
%t4893 = add i64 %t4892, 0
%t4894 = icmp ne i64 %t4893, %t4891
%t4895 = icmp slt i64 7640891576956012808, 0
%t4896 = or i1 %t4894, %t4895
%t4897 = zext i1 %t4896 to i8
call void @resid_conv_check(i8 %t4897)
%t4890.f0 = getelementptr i8, ptr %t4890, i64 0
store i64 %t4892, ptr %t4890.f0, align 8
%t4898 = add i128 13503953896175478587, 0
%t4899 = trunc i128 %t4898 to i64
%t4900 = zext i64 %t4899 to i128
%t4901 = icmp ne i128 %t4900, %t4898
%t4902 = icmp slt i128 13503953896175478587, 0
%t4903 = or i1 %t4901, %t4902
%t4904 = zext i1 %t4903 to i8
call void @resid_conv_check(i8 %t4904)
%t4890.f1 = getelementptr i8, ptr %t4890, i64 8
store i64 %t4899, ptr %t4890.f1, align 8
%t4905 = add i64 4354685564936845355, 0
%t4906 = add i64 %t4905, 0
%t4907 = add i64 %t4906, 0
%t4908 = icmp ne i64 %t4907, %t4905
%t4909 = icmp slt i64 4354685564936845355, 0
%t4910 = or i1 %t4908, %t4909
%t4911 = zext i1 %t4910 to i8
call void @resid_conv_check(i8 %t4911)
%t4890.f2 = getelementptr i8, ptr %t4890, i64 16
store i64 %t4906, ptr %t4890.f2, align 8
%t4912 = add i128 11912009170470909681, 0
%t4913 = trunc i128 %t4912 to i64
%t4914 = zext i64 %t4913 to i128
%t4915 = icmp ne i128 %t4914, %t4912
%t4916 = icmp slt i128 11912009170470909681, 0
%t4917 = or i1 %t4915, %t4916
%t4918 = zext i1 %t4917 to i8
call void @resid_conv_check(i8 %t4918)
%t4890.f3 = getelementptr i8, ptr %t4890, i64 24
store i64 %t4913, ptr %t4890.f3, align 8
%t4919 = add i64 5840696475078001361, 0
%t4920 = add i64 %t4919, 0
%t4921 = add i64 %t4920, 0
%t4922 = icmp ne i64 %t4921, %t4919
%t4923 = icmp slt i64 5840696475078001361, 0
%t4924 = or i1 %t4922, %t4923
%t4925 = zext i1 %t4924 to i8
call void @resid_conv_check(i8 %t4925)
%t4890.f4 = getelementptr i8, ptr %t4890, i64 32
store i64 %t4920, ptr %t4890.f4, align 8
%t4926 = add i128 11170449401992604703, 0
%t4927 = trunc i128 %t4926 to i64
%t4928 = zext i64 %t4927 to i128
%t4929 = icmp ne i128 %t4928, %t4926
%t4930 = icmp slt i128 11170449401992604703, 0
%t4931 = or i1 %t4929, %t4930
%t4932 = zext i1 %t4931 to i8
call void @resid_conv_check(i8 %t4932)
%t4890.f5 = getelementptr i8, ptr %t4890, i64 40
store i64 %t4927, ptr %t4890.f5, align 8
%t4933 = add i64 2270897969802886507, 0
%t4934 = add i64 %t4933, 0
%t4935 = add i64 %t4934, 0
%t4936 = icmp ne i64 %t4935, %t4933
%t4937 = icmp slt i64 2270897969802886507, 0
%t4938 = or i1 %t4936, %t4937
%t4939 = zext i1 %t4938 to i8
call void @resid_conv_check(i8 %t4939)
%t4890.f6 = getelementptr i8, ptr %t4890, i64 48
store i64 %t4934, ptr %t4890.f6, align 8
%t4940 = add i64 6620516959819538809, 0
%t4941 = add i64 %t4940, 0
%t4942 = add i64 %t4941, 0
%t4943 = icmp ne i64 %t4942, %t4940
%t4944 = icmp slt i64 6620516959819538809, 0
%t4945 = or i1 %t4943, %t4944
%t4946 = zext i1 %t4945 to i8
call void @resid_conv_check(i8 %t4946)
%t4890.f7 = getelementptr i8, ptr %t4890, i64 56
store i64 %t4941, ptr %t4890.f7, align 8
ret ptr %t4890
}
define i64 @w64u(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4947 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p1)
%t4948 = extractvalue {i64, i1} %t4947, 0
%t4949 = extractvalue {i64, i1} %t4947, 1
%t4950 = zext i1 %t4949 to i8
call void @resid_overflow_check(i8 %t4950)
%t4951 = call ptr @resid_list_get(ptr %p0, i64 %t4948)
%t4952 = call i64 @resid_unbox_i64(ptr %t4951)
%t4954 = add i64 %t4952, 0
%t4955 = add i64 %t4954, 0
%t4956 = add i64 %t4955, 0
%t4957 = icmp ne i64 %t4956, %t4954
%t4958 = icmp slt i64 %t4952, 0
%t4959 = or i1 %t4957, %t4958
%t4960 = zext i1 %t4959 to i8
call void @resid_conv_check(i8 %t4960)
%t4961 = shl i64 %t4955, 32
%t4962 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p1)
%t4963 = extractvalue {i64, i1} %t4962, 0
%t4964 = extractvalue {i64, i1} %t4962, 1
%t4965 = zext i1 %t4964 to i8
call void @resid_overflow_check(i8 %t4965)
%t4966 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4963, i64 1)
%t4967 = extractvalue {i64, i1} %t4966, 0
%t4968 = extractvalue {i64, i1} %t4966, 1
%t4969 = zext i1 %t4968 to i8
call void @resid_overflow_check(i8 %t4969)
%t4970 = call ptr @resid_list_get(ptr %p0, i64 %t4967)
%t4971 = call i64 @resid_unbox_i64(ptr %t4970)
%t4973 = add i64 %t4971, 0
%t4974 = add i64 %t4973, 0
%t4975 = add i64 %t4974, 0
%t4976 = icmp ne i64 %t4975, %t4973
%t4977 = icmp slt i64 %t4971, 0
%t4978 = or i1 %t4976, %t4977
%t4979 = zext i1 %t4978 to i8
call void @resid_conv_check(i8 %t4979)
%t4980 = or i64 %t4961, %t4974
ret i64 %t4980
}
define ptr @be64_push(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4982, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t5006, %tco.s0 ]
%t4981 = icmp sge i64 %p1, 8
br i1 %t4981, label %L598, label %L600
L598:
ret ptr %p2
L600:
%t4982 = add nsw i64 %p1, 1
%t4983 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t4984 = extractvalue {i64, i1} %t4983, 0
%t4985 = extractvalue {i64, i1} %t4983, 1
%t4986 = zext i1 %t4985 to i8
call void @resid_overflow_check(i8 %t4986)
%t4987 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 56, i64 %t4984)
%t4988 = extractvalue {i64, i1} %t4987, 0
%t4989 = extractvalue {i64, i1} %t4987, 1
%t4990 = zext i1 %t4989 to i8
call void @resid_overflow_check(i8 %t4990)
%t4991 = add i64 %t4988, 0
%t4992 = add i64 %t4991, 0
%t4993 = add i64 %t4992, 0
%t4994 = icmp ne i64 %t4993, %t4991
%t4995 = icmp slt i64 %t4988, 0
%t4996 = or i1 %t4994, %t4995
%t4997 = zext i1 %t4996 to i8
call void @resid_conv_check(i8 %t4997)
%t4998 = icmp uge i64 %t4992, 64
%t4999 = add i64 %t4992, 0
%t5000 = lshr i64 %p0, %t4999
%t5001 = select i1 %t4998, i64 0, i64 %t5000
%t5002 = and i64 %t5001, 255
%t5003 = call ptr @resid_box_i64(i64 %t5002)
%t5006 = call ptr @resid_listbuf_push(ptr %p2, ptr %t5003)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @words64_bytes(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5008 = getelementptr i8, ptr %p0, i64 24
%t5009 = load i64, ptr %t5008, align 8
%t5010 = getelementptr i8, ptr %p0, i64 16
%t5011 = load i64, ptr %t5010, align 8
%t5012 = getelementptr i8, ptr %p0, i64 8
%t5013 = load i64, ptr %t5012, align 8
%t5014 = getelementptr i8, ptr %p0, i64 0
%t5015 = load i64, ptr %t5014, align 8
%t5016 = call ptr @be64_push__rs380(i64 %t5015, i64 0, ptr %p2)
%t5017 = call ptr @be64_push__rs380(i64 %t5013, i64 0, ptr %t5016)
%t5018 = call ptr @be64_push__rs380(i64 %t5011, i64 0, ptr %t5017)
%t5019 = call ptr @be64_push__rs380(i64 %t5009, i64 0, ptr %t5018)
%t5020 = getelementptr i8, ptr %p0, i64 56
%t5021 = load i64, ptr %t5020, align 8
%t5022 = getelementptr i8, ptr %p0, i64 48
%t5023 = load i64, ptr %t5022, align 8
%t5024 = getelementptr i8, ptr %p0, i64 40
%t5025 = load i64, ptr %t5024, align 8
%t5026 = getelementptr i8, ptr %p0, i64 32
%t5027 = load i64, ptr %t5026, align 8
%t5028 = call ptr @be64_push__rs380(i64 %t5027, i64 0, ptr %t5019)
%t5029 = call ptr @be64_push__rs380(i64 %t5025, i64 0, ptr %t5028)
%t5030 = call ptr @be64_push__rs380(i64 %t5023, i64 0, ptr %t5029)
%t5031 = call ptr @be64_push__rs380(i64 %t5021, i64 0, ptr %t5030)
%t5032 = call ptr @resid_listbuf_finish(ptr %t5031, ptr @.lty5032)
ret ptr %t5032
}
define ptr @sha512_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5033 = call i64 @resid_list_len(ptr %p0)
%t5034 = sdiv i64 %t5033, 128
%t5035 = mul nsw i64 %t5034, 128
%t5036 = call ptr @sha512_iv()
%t5037 = call ptr @sha512_blocks(ptr %p0, i64 0, i64 %t5035, ptr %t5036)
%t5038 = call i64 @resid_list_len(ptr %p0)
%t5039 = call ptr @resid_list_slice(ptr %p0, i64 %t5035, i64 %t5038)
%t5041 = call ptr @pad512_tail(ptr %t5039, i64 %t5033)
%t5042 = call i64 @resid_list_len(ptr %t5041)
%t5043 = call ptr @sha512_blocks(ptr %t5041, i64 0, i64 %t5042, ptr %t5037)
%t5044 = call ptr @resid_listbuf_new()
%t5045 = call ptr @words64_bytes(ptr %t5043, i64 0, ptr %t5044)
ret ptr %t5045
}
define ptr @pad512_tail(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5046 = call i64 @resid_list_len(ptr %p0)
%t5047 = add nsw i64 %t5046, 17
%t5048 = add nsw i64 %t5047, 127
%t5049 = sdiv i64 %t5048, 128
%t5051 = call ptr @resid_list_const_i64(ptr @.lc5050, i64 1, ptr @.lcd5050, ptr @.lty5050)
%t5052 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t5051)
%t5053 = mul nsw i64 %t5049, 128
%t5054 = sub nsw i64 %t5053, %t5046
%t5055 = sub nsw i64 %t5054, 17
%t5056 = call ptr @zeros_l(ptr %t5052, i64 %t5055)
%t5057 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t5058 = extractvalue {i64, i1} %t5057, 0
%t5059 = extractvalue {i64, i1} %t5057, 1
%t5060 = zext i1 %t5059 to i8
call void @resid_overflow_check(i8 %t5060)
%t5061 = call ptr @len512_bytes__rs266(ptr %t5056, i64 %t5058, i64 15)
ret ptr %t5061
}
define ptr @limb_bytes_acc(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5074 = alloca [1 x ptr]
%t5081 = alloca [1 x ptr]
%t5088 = alloca [1 x ptr]
%t5095 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5102, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t5062 = icmp sge i64 %p1, 16
br i1 %t5062, label %L601, label %L603
L601:
%lr.cx16 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz16 = icmp eq ptr %lr.cx16, null
br i1 %lr.lz16, label %lr.x16.k, label %lr.x16.m
lr.x16.k:
ret ptr %p2
lr.x16.m:
%lr.ret16 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx16)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret16
L603:
%t5063 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t5064 = call i64 @resid_unbox_i64(ptr %t5063)
%t5066 = and i64 %t5064, 4294967295
%t5067 = ashr i64 %t5066, 24
%t5068 = and i64 %t5067, 255
%t5069 = ashr i64 %t5066, 16
%t5070 = and i64 %t5069, 255
%t5071 = ashr i64 %t5066, 8
%t5072 = and i64 %t5071, 255
%t5073 = and i64 %t5066, 255
%t5076 = call ptr @resid_box_i64(i64 %t5068)
%t5078 = getelementptr i8, ptr %t5074, i64 0
store ptr %t5076, ptr %t5078
%t5079 = call ptr @resid_list_new(i64 1, ptr %t5074, ptr @.lty5074)
%t5080 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t5079)
%t5083 = call ptr @resid_box_i64(i64 %t5070)
%t5085 = getelementptr i8, ptr %t5081, i64 0
store ptr %t5083, ptr %t5085
%t5086 = call ptr @resid_list_new(i64 1, ptr %t5081, ptr @.lty5081)
%t5087 = call ptr @resid_list_concat_own(ptr %t5080, i8 1, ptr %t5086)
%t5090 = call ptr @resid_box_i64(i64 %t5072)
%t5092 = getelementptr i8, ptr %t5088, i64 0
store ptr %t5090, ptr %t5092
%t5093 = call ptr @resid_list_new(i64 1, ptr %t5088, ptr @.lty5088)
%t5094 = call ptr @resid_list_concat_own(ptr %t5087, i8 1, ptr %t5093)
%t5097 = call ptr @resid_box_i64(i64 %t5073)
%t5099 = getelementptr i8, ptr %t5095, i64 0
store ptr %t5097, ptr %t5099
%t5100 = call ptr @resid_list_new(i64 1, ptr %t5095, ptr @.lty5095)
%t5101 = call ptr @resid_list_concat_own(ptr %t5094, i8 1, ptr %t5100)
%t5102 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t5101, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t5101, %tco.s0 ]
br label %tco.head
}
define ptr @limbs_to_hex_bytes(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5105 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty5104)
%t5106 = call ptr @limb_bytes_acc(ptr %p0, i64 0, ptr %t5105)
ret ptr %t5106
}
define i64 @__m____________lib_crypto_resid__u32mask(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5107 = and i64 %p0, 4294967295
ret i64 %t5107
}
define i64 @__m____________lib_crypto_resid__sha1_rol(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5108 = icmp uge i64 %p1, 64
%t5109 = add i64 %p1, 0
%t5110 = shl i64 %p0, %t5109
%t5111 = select i1 %t5108, i64 0, i64 %t5110
%t5112 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5111)
%t5113 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %p0)
%t5114 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t5115 = extractvalue {i64, i1} %t5114, 0
%t5116 = extractvalue {i64, i1} %t5114, 1
%t5117 = zext i1 %t5116 to i8
call void @resid_overflow_check(i8 %t5117)
%t5118 = icmp uge i64 %t5115, 64
%t5119 = add i64 %t5115, 0
%t5120 = select i1 %t5118, i64 63, i64 %t5119
%t5121 = ashr i64 %t5113, %t5120
%t5122 = or i64 %t5112, %t5121
%t5123 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5122)
ret i64 %t5123
}
define i64 @__m____________lib_crypto_resid__sha1_word(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5124 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t5125 = extractvalue {i64, i1} %t5124, 0
%t5126 = extractvalue {i64, i1} %t5124, 1
%t5127 = zext i1 %t5126 to i8
call void @resid_overflow_check(i8 %t5127)
%t5128 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t5125)
%t5129 = extractvalue {i64, i1} %t5128, 0
%t5130 = extractvalue {i64, i1} %t5128, 1
%t5131 = zext i1 %t5130 to i8
call void @resid_overflow_check(i8 %t5131)
%t5132 = call ptr @resid_list_get(ptr %p0, i64 %t5129)
%t5133 = call i64 @resid_unbox_i64(ptr %t5132)
%t5135 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t5133, i64 256)
%t5136 = extractvalue {i64, i1} %t5135, 0
%t5137 = extractvalue {i64, i1} %t5135, 1
%t5138 = zext i1 %t5137 to i8
call void @resid_overflow_check(i8 %t5138)
%t5139 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5129, i64 1)
%t5140 = extractvalue {i64, i1} %t5139, 0
%t5141 = extractvalue {i64, i1} %t5139, 1
%t5142 = zext i1 %t5141 to i8
call void @resid_overflow_check(i8 %t5142)
%t5143 = call ptr @resid_list_get(ptr %p0, i64 %t5140)
%t5144 = call i64 @resid_unbox_i64(ptr %t5143)
%t5146 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5136, i64 %t5144)
%t5147 = extractvalue {i64, i1} %t5146, 0
%t5148 = extractvalue {i64, i1} %t5146, 1
%t5149 = zext i1 %t5148 to i8
call void @resid_overflow_check(i8 %t5149)
%t5150 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t5147, i64 256)
%t5151 = extractvalue {i64, i1} %t5150, 0
%t5152 = extractvalue {i64, i1} %t5150, 1
%t5153 = zext i1 %t5152 to i8
call void @resid_overflow_check(i8 %t5153)
%t5154 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5129, i64 2)
%t5155 = extractvalue {i64, i1} %t5154, 0
%t5156 = extractvalue {i64, i1} %t5154, 1
%t5157 = zext i1 %t5156 to i8
call void @resid_overflow_check(i8 %t5157)
%t5158 = call ptr @resid_list_get(ptr %p0, i64 %t5155)
%t5159 = call i64 @resid_unbox_i64(ptr %t5158)
%t5161 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5151, i64 %t5159)
%t5162 = extractvalue {i64, i1} %t5161, 0
%t5163 = extractvalue {i64, i1} %t5161, 1
%t5164 = zext i1 %t5163 to i8
call void @resid_overflow_check(i8 %t5164)
%t5165 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t5162, i64 256)
%t5166 = extractvalue {i64, i1} %t5165, 0
%t5167 = extractvalue {i64, i1} %t5165, 1
%t5168 = zext i1 %t5167 to i8
call void @resid_overflow_check(i8 %t5168)
%t5169 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5129, i64 3)
%t5170 = extractvalue {i64, i1} %t5169, 0
%t5171 = extractvalue {i64, i1} %t5169, 1
%t5172 = zext i1 %t5171 to i8
call void @resid_overflow_check(i8 %t5172)
%t5173 = call ptr @resid_list_get(ptr %p0, i64 %t5170)
%t5174 = call i64 @resid_unbox_i64(ptr %t5173)
%t5176 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5166, i64 %t5174)
%t5177 = extractvalue {i64, i1} %t5176, 0
%t5178 = extractvalue {i64, i1} %t5176, 1
%t5179 = zext i1 %t5178 to i8
call void @resid_overflow_check(i8 %t5179)
ret i64 %t5177
}
define ptr @__m____________lib_crypto_resid__sha1_words16(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5183 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5181, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t5180 = icmp sge i64 %p2, 16
br i1 %t5180, label %L604, label %L606
L604:
%lr.cx12 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz12 = icmp eq ptr %lr.cx12, null
br i1 %lr.lz12, label %lr.x12.k, label %lr.x12.m
lr.x12.k:
ret ptr %p3
lr.x12.m:
%lr.ret12 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx12)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret12
L606:
%t5181 = add nsw i64 %p2, 1
%t5182 = call i64 @__m____________lib_crypto_resid__sha1_word(ptr %p0, i64 %p1, i64 %p2)
%t5185 = call ptr @resid_box_i64(i64 %t5182)
%t5187 = getelementptr i8, ptr %t5183, i64 0
store ptr %t5185, ptr %t5187
%t5188 = call ptr @resid_list_new(i64 1, ptr %t5183, ptr @.lty5183)
%t5189 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t5188)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t5189, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t5189, %tco.s0 ]
br label %tco.head
}
define ptr @__m____________lib_crypto_resid__sha1_expand(i64 %p0.in, ptr %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5226 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t5224, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%t5191 = icmp sge i64 %p0, 80
br i1 %t5191, label %L607, label %L609
L607:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr %p1
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L609:
%t5192 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p0, i64 3)
%t5193 = extractvalue {i64, i1} %t5192, 0
%t5194 = extractvalue {i64, i1} %t5192, 1
%t5195 = zext i1 %t5194 to i8
call void @resid_overflow_check(i8 %t5195)
%t5196 = call ptr @resid_list_get(ptr %p1, i64 %t5193)
%t5197 = call i64 @resid_unbox_i64(ptr %t5196)
%t5199 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p0, i64 8)
%t5200 = extractvalue {i64, i1} %t5199, 0
%t5201 = extractvalue {i64, i1} %t5199, 1
%t5202 = zext i1 %t5201 to i8
call void @resid_overflow_check(i8 %t5202)
%t5203 = call ptr @resid_list_get(ptr %p1, i64 %t5200)
%t5204 = call i64 @resid_unbox_i64(ptr %t5203)
%t5206 = xor i64 %t5197, %t5204
%t5207 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p0, i64 14)
%t5208 = extractvalue {i64, i1} %t5207, 0
%t5209 = extractvalue {i64, i1} %t5207, 1
%t5210 = zext i1 %t5209 to i8
call void @resid_overflow_check(i8 %t5210)
%t5211 = call ptr @resid_list_get(ptr %p1, i64 %t5208)
%t5212 = call i64 @resid_unbox_i64(ptr %t5211)
%t5214 = xor i64 %t5206, %t5212
%t5215 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p0, i64 16)
%t5216 = extractvalue {i64, i1} %t5215, 0
%t5217 = extractvalue {i64, i1} %t5215, 1
%t5218 = zext i1 %t5217 to i8
call void @resid_overflow_check(i8 %t5218)
%t5219 = call ptr @resid_list_get(ptr %p1, i64 %t5216)
%t5220 = call i64 @resid_unbox_i64(ptr %t5219)
%t5222 = xor i64 %t5214, %t5220
%t5223 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5222)
%t5224 = add nsw i64 %p0, 1
%t5225 = call i64 @__m____________lib_crypto_resid__sha1_rol(i64 %t5223, i64 1)
%t5228 = call ptr @resid_box_i64(i64 %t5225)
%t5230 = getelementptr i8, ptr %t5226, i64 0
store ptr %t5228, ptr %t5230
%t5231 = call ptr @resid_list_new(i64 1, ptr %t5226, ptr @.lty5226)
%t5232 = call ptr @resid_list_concat_own(ptr %p1, i8 1, ptr %t5231)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %t5232, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %t5232, %tco.s0 ]
br label %tco.head
}
define i64 @__m____________lib_crypto_resid__sha1_f(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5234 = icmp slt i64 %p0, 20
%t5235 = icmp sge i64 %p0, 20
br label %LSL5236
LSL5236:
br i1 %t5235, label %LSR5236, label %LSJ5236
LSR5236:
%t5237 = icmp slt i64 %p0, 40
br label %LSJ5236
LSJ5236:
%t5238 = phi i1 [ false, %LSL5236 ], [ %t5237, %LSR5236 ]
%t5239 = icmp sge i64 %p0, 40
br label %LSL5240
LSL5240:
br i1 %t5239, label %LSR5240, label %LSJ5240
LSR5240:
%t5241 = icmp slt i64 %p0, 60
br label %LSJ5240
LSJ5240:
%t5242 = phi i1 [ false, %LSL5240 ], [ %t5241, %LSR5240 ]
br i1 %t5234, label %L610, label %L612
L610:
%t5243 = and i64 %p1, %p2
%t5244 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 4294967295, i64 %p1)
%t5245 = extractvalue {i64, i1} %t5244, 0
%t5246 = extractvalue {i64, i1} %t5244, 1
%t5247 = zext i1 %t5246 to i8
call void @resid_overflow_check(i8 %t5247)
%t5248 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5245)
%t5249 = and i64 %t5248, %p3
%t5250 = or i64 %t5243, %t5249
%t5251 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5250)
ret i64 %t5251
L612:
br i1 %t5238, label %L613, label %L615
L613:
%t5252 = xor i64 %p1, %p2
%t5253 = xor i64 %t5252, %p3
%t5254 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5253)
ret i64 %t5254
L615:
br i1 %t5242, label %L616, label %L618
L616:
%t5255 = and i64 %p1, %p2
%t5256 = and i64 %p1, %p3
%t5257 = or i64 %t5255, %t5256
%t5258 = and i64 %p2, %p3
%t5259 = or i64 %t5257, %t5258
%t5260 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5259)
ret i64 %t5260
L618:
%t5261 = xor i64 %p1, %p2
%t5262 = xor i64 %t5261, %p3
%t5263 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5262)
ret i64 %t5263
}
define i64 @__m____________lib_crypto_resid__sha1_k(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5264 = icmp slt i64 %p0, 20
%t5265 = icmp sge i64 %p0, 20
br label %LSL5266
LSL5266:
br i1 %t5265, label %LSR5266, label %LSJ5266
LSR5266:
%t5267 = icmp slt i64 %p0, 40
br label %LSJ5266
LSJ5266:
%t5268 = phi i1 [ false, %LSL5266 ], [ %t5267, %LSR5266 ]
%t5269 = icmp sge i64 %p0, 40
br label %LSL5270
LSL5270:
br i1 %t5269, label %LSR5270, label %LSJ5270
LSR5270:
%t5271 = icmp slt i64 %p0, 60
br label %LSJ5270
LSJ5270:
%t5272 = phi i1 [ false, %LSL5270 ], [ %t5271, %LSR5270 ]
br i1 %t5264, label %L619, label %L621
L619:
ret i64 1518500249
L621:
br i1 %t5268, label %L622, label %L624
L622:
ret i64 1859775393
L624:
br i1 %t5272, label %L625, label %L627
L625:
ret i64 2400959708
L627:
ret i64 3395469782
}
define ptr @__m____________lib_crypto_resid__sha1_rounds(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5274 = alloca [5 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5316, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5314, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p2, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t5315, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%t5273 = icmp sge i64 %p1, 80
br i1 %t5273, label %L628, label %L630
L628:
%t5276 = call ptr @resid_box_i64(i64 %p2)
%t5278 = getelementptr i8, ptr %t5274, i64 0
store ptr %t5276, ptr %t5278
%t5279 = call ptr @resid_box_i64(i64 %p3)
%t5281 = getelementptr i8, ptr %t5274, i64 8
store ptr %t5279, ptr %t5281
%t5282 = call ptr @resid_box_i64(i64 %p4)
%t5284 = getelementptr i8, ptr %t5274, i64 16
store ptr %t5282, ptr %t5284
%t5285 = call ptr @resid_box_i64(i64 %p5)
%t5287 = getelementptr i8, ptr %t5274, i64 24
store ptr %t5285, ptr %t5287
%t5288 = call ptr @resid_box_i64(i64 %p6)
%t5290 = getelementptr i8, ptr %t5274, i64 32
store ptr %t5288, ptr %t5290
%t5291 = call ptr @resid_list_new(i64 5, ptr %t5274, ptr @.lty5274)
%lr.cx33 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz33 = icmp eq ptr %lr.cx33, null
br i1 %lr.lz33, label %lr.x33.k, label %lr.x33.m
lr.x33.k:
ret ptr %t5291
lr.x33.m:
%lr.ret33 = call ptr @resid_mv_list(ptr %t5291, ptr %lr.cx33)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret33
L630:
%t5292 = call i64 @__m____________lib_crypto_resid__sha1_rol(i64 %p2, i64 5)
%t5293 = call i64 @__m____________lib_crypto_resid__sha1_f(i64 %p1, i64 %p3, i64 %p4, i64 %p5)
%t5294 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5292, i64 %t5293)
%t5295 = extractvalue {i64, i1} %t5294, 0
%t5296 = extractvalue {i64, i1} %t5294, 1
%t5297 = zext i1 %t5296 to i8
call void @resid_overflow_check(i8 %t5297)
%t5298 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5295, i64 %p6)
%t5299 = extractvalue {i64, i1} %t5298, 0
%t5300 = extractvalue {i64, i1} %t5298, 1
%t5301 = zext i1 %t5300 to i8
call void @resid_overflow_check(i8 %t5301)
%t5302 = call i64 @__m____________lib_crypto_resid__sha1_k(i64 %p1)
%t5303 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5299, i64 %t5302)
%t5304 = extractvalue {i64, i1} %t5303, 0
%t5305 = extractvalue {i64, i1} %t5303, 1
%t5306 = zext i1 %t5305 to i8
call void @resid_overflow_check(i8 %t5306)
%t5307 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t5308 = call i64 @resid_unbox_i64(ptr %t5307)
%t5310 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5304, i64 %t5308)
%t5311 = extractvalue {i64, i1} %t5310, 0
%t5312 = extractvalue {i64, i1} %t5310, 1
%t5313 = zext i1 %t5312 to i8
call void @resid_overflow_check(i8 %t5313)
%t5314 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5311)
%t5315 = call i64 @__m____________lib_crypto_resid__sha1_rol(i64 %p3, i64 30)
%t5316 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
br label %tco.head
}
define ptr @__m____________lib_crypto_resid__sha1_step(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5319 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty5318)
%t5320 = call ptr @__m____________lib_crypto_resid__sha1_words16__rs394(ptr %p0, i64 %p1, i64 0, ptr %t5319)
%t5321 = call ptr @__m____________lib_crypto_resid__sha1_expand(i64 16, ptr %t5320)
%t5322 = call ptr @resid_list_get(ptr %p2, i64 0)
%t5323 = call i64 @resid_unbox_i64(ptr %t5322)
%t5325 = call ptr @resid_list_get(ptr %p2, i64 1)
%t5326 = call i64 @resid_unbox_i64(ptr %t5325)
%t5328 = call ptr @resid_list_get(ptr %p2, i64 2)
%t5329 = call i64 @resid_unbox_i64(ptr %t5328)
%t5331 = call ptr @resid_list_get(ptr %p2, i64 3)
%t5332 = call i64 @resid_unbox_i64(ptr %t5331)
%t5334 = call ptr @resid_list_get(ptr %p2, i64 4)
%t5335 = call i64 @resid_unbox_i64(ptr %t5334)
%t5337 = call ptr @__m____________lib_crypto_resid__sha1_rounds(ptr %t5321, i64 0, i64 %t5323, i64 %t5326, i64 %t5329, i64 %t5332, i64 %t5335)
%t5338 = call ptr @resid_list_get(ptr %p2, i64 0)
%t5339 = call i64 @resid_unbox_i64(ptr %t5338)
%t5341 = call ptr @resid_list_get(ptr %t5337, i64 0)
%t5342 = call i64 @resid_unbox_i64(ptr %t5341)
%t5344 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5339, i64 %t5342)
%t5345 = extractvalue {i64, i1} %t5344, 0
%t5346 = extractvalue {i64, i1} %t5344, 1
%t5347 = zext i1 %t5346 to i8
call void @resid_overflow_check(i8 %t5347)
%t5348 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5345)
%t5349 = call ptr @resid_list_get(ptr %p2, i64 1)
%t5350 = call i64 @resid_unbox_i64(ptr %t5349)
%t5352 = call ptr @resid_list_get(ptr %t5337, i64 1)
%t5353 = call i64 @resid_unbox_i64(ptr %t5352)
%t5355 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5350, i64 %t5353)
%t5356 = extractvalue {i64, i1} %t5355, 0
%t5357 = extractvalue {i64, i1} %t5355, 1
%t5358 = zext i1 %t5357 to i8
call void @resid_overflow_check(i8 %t5358)
%t5359 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5356)
%t5360 = call ptr @resid_list_get(ptr %p2, i64 2)
%t5361 = call i64 @resid_unbox_i64(ptr %t5360)
%t5363 = call ptr @resid_list_get(ptr %t5337, i64 2)
%t5364 = call i64 @resid_unbox_i64(ptr %t5363)
%t5366 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5361, i64 %t5364)
%t5367 = extractvalue {i64, i1} %t5366, 0
%t5368 = extractvalue {i64, i1} %t5366, 1
%t5369 = zext i1 %t5368 to i8
call void @resid_overflow_check(i8 %t5369)
%t5370 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5367)
%t5371 = call ptr @resid_list_get(ptr %p2, i64 3)
%t5372 = call i64 @resid_unbox_i64(ptr %t5371)
%t5374 = call ptr @resid_list_get(ptr %t5337, i64 3)
%t5375 = call i64 @resid_unbox_i64(ptr %t5374)
%t5377 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5372, i64 %t5375)
%t5378 = extractvalue {i64, i1} %t5377, 0
%t5379 = extractvalue {i64, i1} %t5377, 1
%t5380 = zext i1 %t5379 to i8
call void @resid_overflow_check(i8 %t5380)
%t5381 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5378)
%t5382 = call ptr @resid_list_get(ptr %p2, i64 4)
%t5383 = call i64 @resid_unbox_i64(ptr %t5382)
%t5385 = call ptr @resid_list_get(ptr %t5337, i64 4)
%t5386 = call i64 @resid_unbox_i64(ptr %t5385)
%t5388 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5383, i64 %t5386)
%t5389 = extractvalue {i64, i1} %t5388, 0
%t5390 = extractvalue {i64, i1} %t5388, 1
%t5391 = zext i1 %t5390 to i8
call void @resid_overflow_check(i8 %t5391)
%t5392 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5389)
%t5393 = alloca [5 x ptr]
%t5395 = call ptr @resid_box_i64(i64 %t5348)
%t5397 = getelementptr i8, ptr %t5393, i64 0
store ptr %t5395, ptr %t5397
%t5398 = call ptr @resid_box_i64(i64 %t5359)
%t5400 = getelementptr i8, ptr %t5393, i64 8
store ptr %t5398, ptr %t5400
%t5401 = call ptr @resid_box_i64(i64 %t5370)
%t5403 = getelementptr i8, ptr %t5393, i64 16
store ptr %t5401, ptr %t5403
%t5404 = call ptr @resid_box_i64(i64 %t5381)
%t5406 = getelementptr i8, ptr %t5393, i64 24
store ptr %t5404, ptr %t5406
%t5407 = call ptr @resid_box_i64(i64 %t5392)
%t5409 = getelementptr i8, ptr %t5393, i64 32
store ptr %t5407, ptr %t5409
%t5410 = call ptr @resid_list_new(i64 5, ptr %t5393, ptr @.lty5393)
ret ptr %t5410
}
define ptr @__m____________lib_crypto_resid__sha1_blocks(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5413, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t5417, %tco.s0.k ]
%t5411 = icmp sge i64 %p4, %p2
br i1 %t5411, label %L631, label %L633
L631:
%lr.cx12 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz12 = icmp eq ptr %lr.cx12, null
br i1 %lr.lz12, label %lr.x12.k, label %lr.x12.m
lr.x12.k:
ret ptr %p3
lr.x12.m:
%lr.ret12 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx12)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret12
L633:
%t5412 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t5413 = extractvalue {i64, i1} %t5412, 0
%t5414 = extractvalue {i64, i1} %t5412, 1
%t5415 = zext i1 %t5414 to i8
call void @resid_overflow_check(i8 %t5415)
%t5416 = call ptr @__m____________lib_crypto_resid__sha1_step(ptr %p0, i64 %p1, ptr %p3)
%t5417 = add nsw i64 %p4, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t5416, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t5416, %tco.s0 ]
br label %tco.head
}
define ptr @__m____________lib_crypto_resid__sha1_be_bytes(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5433 = alloca [4 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5432, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t5419 = icmp sge i64 %p1, 5
br i1 %t5419, label %L634, label %L636
L634:
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %p2
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L636:
%t5420 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t5421 = call i64 @resid_unbox_i64(ptr %t5420)
%t5423 = ashr i64 %t5421, 24
%t5424 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5423)
%t5425 = ashr i64 %t5421, 16
%t5426 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5425)
%t5427 = and i64 %t5426, 255
%t5428 = ashr i64 %t5421, 8
%t5429 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5428)
%t5430 = and i64 %t5429, 255
%t5431 = and i64 %t5421, 255
%t5432 = add nsw i64 %p1, 1
%t5435 = call ptr @resid_box_i64(i64 %t5424)
%t5437 = getelementptr i8, ptr %t5433, i64 0
store ptr %t5435, ptr %t5437
%t5438 = call ptr @resid_box_i64(i64 %t5427)
%t5440 = getelementptr i8, ptr %t5433, i64 8
store ptr %t5438, ptr %t5440
%t5441 = call ptr @resid_box_i64(i64 %t5430)
%t5443 = getelementptr i8, ptr %t5433, i64 16
store ptr %t5441, ptr %t5443
%t5444 = call ptr @resid_box_i64(i64 %t5431)
%t5446 = getelementptr i8, ptr %t5433, i64 24
store ptr %t5444, ptr %t5446
%t5447 = call ptr @resid_list_new(i64 4, ptr %t5433, ptr @.lty5433)
%t5448 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t5447)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t5448, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t5448, %tco.s0 ]
br label %tco.head
}
define ptr @sha1_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5450 = call ptr @pad_bytes(ptr %p0)
%t5451 = call i64 @resid_list_len(ptr %t5450)
%t5452 = sdiv i64 %t5451, 64
%t5454 = call ptr @resid_list_const_i64(ptr @.lc5453, i64 5, ptr @.lcd5453, ptr @.lty5453)
%t5455 = call ptr @__m____________lib_crypto_resid__sha1_blocks(ptr %t5450, i64 0, i64 %t5452, ptr %t5454, i64 0)
%t5457 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty5456)
%t5458 = call ptr @__m____________lib_crypto_resid__sha1_be_bytes(ptr %t5455, i64 0, ptr %t5457)
ret ptr %t5458
}
define ptr @tr_new() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5459 = call ptr @resid_rec_new(i64 8, i8 1)
%t5461 = call ptr @resid_list_const_i64(ptr @.lc5460, i64 9, ptr @.lcd5460, ptr @.lty5460)
%t5462 = alloca [1 x ptr]
%t5466 = getelementptr i8, ptr %t5462, i64 0
store ptr %t5461, ptr %t5466
%t5467 = call ptr @resid_list_new(i64 1, ptr %t5462, ptr @.lty5462)
%t5459.f0 = getelementptr i8, ptr %t5459, i64 0
store ptr %t5467, ptr %t5459.f0, align 8
ret ptr %t5459
}
define ptr @__m____________lib_cggmp_hash_resid__tr_u64be(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5468 = ashr i64 %p0, 24
%t5469 = and i64 %t5468, 255
%t5470 = ashr i64 %p0, 16
%t5471 = and i64 %t5470, 255
%t5472 = ashr i64 %p0, 8
%t5473 = and i64 %t5472, 255
%t5474 = and i64 %p0, 255
%t5475 = alloca [8 x ptr]
%t5477 = call ptr @resid_box_i64(i64 0)
%t5479 = getelementptr i8, ptr %t5475, i64 0
store ptr %t5477, ptr %t5479
%t5480 = call ptr @resid_box_i64(i64 0)
%t5482 = getelementptr i8, ptr %t5475, i64 8
store ptr %t5480, ptr %t5482
%t5483 = call ptr @resid_box_i64(i64 0)
%t5485 = getelementptr i8, ptr %t5475, i64 16
store ptr %t5483, ptr %t5485
%t5486 = call ptr @resid_box_i64(i64 0)
%t5488 = getelementptr i8, ptr %t5475, i64 24
store ptr %t5486, ptr %t5488
%t5489 = call ptr @resid_box_i64(i64 %t5469)
%t5491 = getelementptr i8, ptr %t5475, i64 32
store ptr %t5489, ptr %t5491
%t5492 = call ptr @resid_box_i64(i64 %t5471)
%t5494 = getelementptr i8, ptr %t5475, i64 40
store ptr %t5492, ptr %t5494
%t5495 = call ptr @resid_box_i64(i64 %t5473)
%t5497 = getelementptr i8, ptr %t5475, i64 48
store ptr %t5495, ptr %t5497
%t5498 = call ptr @resid_box_i64(i64 %t5474)
%t5500 = getelementptr i8, ptr %t5475, i64 56
store ptr %t5498, ptr %t5500
%t5501 = call ptr @resid_list_new(i64 8, ptr %t5475, ptr @.lty5475)
ret ptr %t5501
}
define ptr @__m____________lib_cggmp_hash_resid__tr_frame(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5502 = call ptr @bytes_of(ptr %p0)
%t5503 = call ptr @resid_listbuf_new()
%t5504 = call ptr @resid_box_i64(i64 40)
%t5507 = call ptr @resid_listbuf_push(ptr %t5503, ptr %t5504)
%t5508 = call i64 @resid_list_len(ptr %t5502)
%t5509 = call ptr @__m____________lib_cggmp_hash_resid__tr_u64be(i64 %t5508)
%t5510 = call ptr @resid_list_freeze(ptr %t5509)
%t5511 = call ptr @__m____________lib_cggmp_hash_resid__tr_cat(ptr %t5507, ptr %t5510)
%t5512 = call ptr @__m____________lib_cggmp_hash_resid__tr_cat(ptr %t5511, ptr %t5502)
%t5513 = call i64 @resid_list_len(ptr %p1)
%t5514 = call ptr @__m____________lib_cggmp_hash_resid__tr_u64be(i64 %t5513)
%t5515 = call ptr @resid_list_freeze(ptr %t5514)
%t5516 = call ptr @__m____________lib_cggmp_hash_resid__tr_cat(ptr %t5512, ptr %t5515)
%t5517 = call ptr @__m____________lib_cggmp_hash_resid__tr_cat(ptr %t5516, ptr %p1)
%t5518 = call ptr @resid_box_i64(i64 41)
%t5521 = call ptr @resid_listbuf_push(ptr %t5517, ptr %t5518)
%t5522 = musttail call ptr @resid_listbuf_finish(ptr %t5521, ptr @.lty5522)
ret ptr %t5522
}
define ptr @__m____________lib_cggmp_hash_resid__tr_cat(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5523 = call ptr @__m____________lib_cggmp_hash_resid__tr_cat_at(ptr %p0, ptr %p1, i64 0)
ret ptr %t5523
}
define ptr @__m____________lib_cggmp_hash_resid__tr_cat_at(ptr %p0.in, ptr %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %t5532, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5533, %tco.s0 ]
%t5524 = call i64 @resid_list_len(ptr %p1)
%t5525 = icmp sge i64 %p2, %t5524
br i1 %t5525, label %L637, label %L639
L637:
ret ptr %p0
L639:
%t5526 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t5527 = call i64 @resid_unbox_i64(ptr %t5526)
%t5529 = call ptr @resid_box_i64(i64 %t5527)
%t5532 = call ptr @resid_listbuf_push(ptr %p0, ptr %t5529)
%t5533 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @tr_item(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5535 = getelementptr i8, ptr %p0, i64 0
%t5536 = load ptr, ptr %t5535, align 8
%t5537 = call ptr @__m____________lib_cggmp_hash_resid__tr_frame(ptr %p1, ptr %p2)
%t5538 = call ptr @resid_list_freeze(ptr %t5537)
%t5539 = alloca [1 x ptr]
%t5543 = getelementptr i8, ptr %t5539, i64 0
store ptr %t5538, ptr %t5543
%t5545e = load ptr, ptr %t5539
%t5545 = call ptr @resid_list_push(ptr %t5536, ptr %t5545e)
%t5546 = call ptr @resid_rec_reuse(ptr %p0, i64 8)
%t5546.f0 = getelementptr i8, ptr %t5546, i64 0
store ptr %t5545, ptr %t5546.f0, align 8
ret ptr %t5546
}
define ptr @tr_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5548 = call ptr @tr_item(ptr %p0, ptr @.s5547, ptr %p1)
ret ptr %t5548
}
define ptr @tr_nat(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5551 = call ptr @resid_list_const_i64(ptr @.lc5550, i64 1, ptr @.lcd5550, ptr @.lty5550)
%t5552 = call ptr @bn_to_be(ptr %p1, i64 0)
%t5553 = call ptr @resid_list_freeze(ptr %t5552)
%t5554 = call ptr @resid_list_concat(ptr %t5551, ptr %t5553)
%t5555 = call ptr @tr_item(ptr %p0, ptr @.s5549, ptr %t5554)
ret ptr %t5555
}
define ptr @tr_modulus(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5557 = call ptr @bn_to_be(ptr %p1, i64 0)
%t5558 = call ptr @tr_item(ptr %p0, ptr @.s5556, ptr %t5557)
ret ptr %t5558
}
define ptr @__m____________lib_cggmp_hash_resid__tr_flat(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5562, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t5566, %tco.s0 ]
%t5559 = call i64 @resid_list_len(ptr %p0)
%t5560 = icmp sge i64 %p1, %t5559
br i1 %t5560, label %L640, label %L642
L640:
%t5561 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty5561)
ret ptr %t5561
L642:
%t5562 = add nsw i64 %p1, 1
%t5563 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t5566 = call ptr @__m____________lib_cggmp_hash_resid__tr_cat(ptr %p2, ptr %t5563)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @tr_seed(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5568 = getelementptr i8, ptr %p0, i64 0
%t5569 = load ptr, ptr %t5568, align 8
%t5570 = call ptr @resid_listbuf_new()
%t5571 = call ptr @__m____________lib_cggmp_hash_resid__tr_flat(ptr %t5569, i64 0, ptr %t5570)
%t5572 = musttail call ptr @sha256_bytes(ptr %t5571)
ret ptr %t5572
}
define ptr @tr_stream(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5573 = sdiv i64 %p1, 32
%t5574 = call ptr @resid_listbuf_new()
%t5575 = call ptr @__m____________lib_cggmp_hash_resid__tr_stream_at(ptr %p0, i64 %p1, i64 %p2, i64 %t5573, ptr %t5574)
ret ptr %t5575
}
define ptr @__m____________lib_cggmp_hash_resid__tr_stream_at(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5593 = alloca [4 x ptr]
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t5611, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t5622, %tco.s0 ]
%t5576 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p3, i64 32)
%t5577 = extractvalue {i64, i1} %t5576, 0
%t5578 = extractvalue {i64, i1} %t5576, 1
%t5579 = zext i1 %t5578 to i8
call void @resid_overflow_check(i8 %t5579)
%t5580 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p2)
%t5581 = extractvalue {i64, i1} %t5580, 0
%t5582 = extractvalue {i64, i1} %t5580, 1
%t5583 = zext i1 %t5582 to i8
call void @resid_overflow_check(i8 %t5583)
%t5584 = icmp sge i64 %t5577, %t5581
br i1 %t5584, label %L643, label %L645
L643:
%t5585 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty5585)
ret ptr %t5585
L645:
%t5586 = ashr i64 %p3, 24
%t5587 = and i64 %t5586, 255
%t5588 = ashr i64 %p3, 16
%t5589 = and i64 %t5588, 255
%t5590 = ashr i64 %p3, 8
%t5591 = and i64 %t5590, 255
%t5592 = and i64 %p3, 255
%t5595 = call ptr @resid_box_i64(i64 %t5587)
%t5597 = getelementptr i8, ptr %t5593, i64 0
store ptr %t5595, ptr %t5597
%t5598 = call ptr @resid_box_i64(i64 %t5589)
%t5600 = getelementptr i8, ptr %t5593, i64 8
store ptr %t5598, ptr %t5600
%t5601 = call ptr @resid_box_i64(i64 %t5591)
%t5603 = getelementptr i8, ptr %t5593, i64 16
store ptr %t5601, ptr %t5603
%t5604 = call ptr @resid_box_i64(i64 %t5592)
%t5606 = getelementptr i8, ptr %t5593, i64 24
store ptr %t5604, ptr %t5606
%t5607 = call ptr @resid_list_new(i64 4, ptr %t5593, ptr @.lty5593)
%t5608 = call ptr @resid_list_concat(ptr %p0, ptr %t5607)
%t5609 = call ptr @sha256_bytes(ptr %t5608)
%t5610 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 1)
%t5611 = extractvalue {i64, i1} %t5610, 0
%t5612 = extractvalue {i64, i1} %t5610, 1
%t5613 = zext i1 %t5612 to i8
call void @resid_overflow_check(i8 %t5613)
%t5614 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p3, i64 32)
%t5615 = extractvalue {i64, i1} %t5614, 0
%t5616 = extractvalue {i64, i1} %t5614, 1
%t5617 = zext i1 %t5616 to i8
call void @resid_overflow_check(i8 %t5617)
%t5618 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p2)
%t5619 = extractvalue {i64, i1} %t5618, 0
%t5620 = extractvalue {i64, i1} %t5618, 1
%t5621 = zext i1 %t5620 to i8
call void @resid_overflow_check(i8 %t5621)
%t5622 = call ptr @__m____________lib_cggmp_hash_resid__tr_cat_range(ptr %p4, ptr %t5609, i64 %t5615, i64 %p1, i64 %t5619)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_cggmp_hash_resid__tr_cat_range(ptr %p0, ptr %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5624 = call ptr @__m____________lib_cggmp_hash_resid__tr_cat_range_at(ptr %p0, ptr %p1, i64 %p2, i64 %p3, i64 %p4, i64 0)
ret ptr %t5624
}
define ptr @__m____________lib_cggmp_hash_resid__tr_cat_range_at(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %t5642, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t5643, %tco.s0 ]
%t5625 = call i64 @resid_list_len(ptr %p1)
%t5626 = icmp sge i64 %p5, %t5625
br i1 %t5626, label %L646, label %L648
L646:
ret ptr %p0
L648:
%t5627 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %p5)
%t5628 = extractvalue {i64, i1} %t5627, 0
%t5629 = extractvalue {i64, i1} %t5627, 1
%t5630 = zext i1 %t5629 to i8
call void @resid_overflow_check(i8 %t5630)
%t5631 = icmp sge i64 %t5628, %p3
br label %LSL5632
LSL5632:
br i1 %t5631, label %LSR5632, label %LSJ5632
LSR5632:
%t5633 = icmp slt i64 %t5628, %p4
br label %LSJ5632
LSJ5632:
%t5634 = phi i1 [ false, %LSL5632 ], [ %t5633, %LSR5632 ]
br i1 %t5634, label %L649, label %L650
L649:
%t5635 = call ptr @resid_list_get_v(ptr %p1, i64 %p5, ptr %p1.ld, i64 %p1.ln)
%t5636 = call i64 @resid_unbox_i64(ptr %t5635)
%t5638 = call ptr @resid_box_i64(i64 %t5636)
%t5641 = call ptr @resid_listbuf_push(ptr %p0, ptr %t5638)
br label %L651
L650:
br label %L651
L651:
%t5642 = phi ptr [ %t5641, %L649 ], [ %p0, %L650 ]
%t5643 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @tr_sample_modn(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5661, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t5645 = call i64 @bn_bit_len(ptr %p2)
%t5646 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5645, i64 7)
%t5647 = extractvalue {i64, i1} %t5646, 0
%t5648 = extractvalue {i64, i1} %t5646, 1
%t5649 = zext i1 %t5648 to i8
call void @resid_overflow_check(i8 %t5649)
%t5650 = sdiv i64 %t5647, 8
%t5651 = call ptr @tr_stream(ptr %p0, i64 %p1, i64 %t5650)
%t5652 = call ptr @bn_from_be(ptr %t5651)
%t5653 = call i64 @bn_cmp(ptr %t5652, ptr %p2)
%t5654 = icmp slt i64 %t5653, 0
br i1 %t5654, label %L652, label %L654
L652:
%t5655 = call ptr @resid_gmalloc(i64 16)
%t5655.f0 = getelementptr i8, ptr %t5655, i64 0
store ptr %t5652, ptr %t5655.f0, align 8
%t5656 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t5650)
%t5657 = extractvalue {i64, i1} %t5656, 0
%t5658 = extractvalue {i64, i1} %t5656, 1
%t5659 = zext i1 %t5658 to i8
call void @resid_overflow_check(i8 %t5659)
%t5655.f1 = getelementptr i8, ptr %t5655, i64 8
store i64 %t5657, ptr %t5655.f1, align 8
ret ptr %t5655
L654:
%t5660 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t5650)
%t5661 = extractvalue {i64, i1} %t5660, 0
%t5662 = extractvalue {i64, i1} %t5660, 1
%t5663 = zext i1 %t5662 to i8
call void @resid_overflow_check(i8 %t5663)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @zk_stat() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 80
}
define i1 @zk_valid_mod_n(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5665 = call i64 @resid_list_len(ptr %p0)
%t5666 = icmp eq i64 %t5665, 0
br label %LSL5667
LSL5667:
br i1 %t5666, label %LSJ5667, label %LSR5667
LSR5667:
%t5668 = call i64 @bn_cmp(ptr %p0, ptr %p1)
%t5669 = icmp sge i64 %t5668, 0
br label %LSJ5667
LSJ5667:
%t5670 = phi i1 [ true, %LSL5667 ], [ %t5669, %LSR5667 ]
br i1 %t5670, label %L655, label %L657
L655:
ret i1 false
L657:
%t5671 = call ptr @bn_gcd(ptr %p0, ptr %p1)
%t5672 = call ptr @resid_list_freeze(ptr %t5671)
%t5674 = call ptr @resid_list_const_i64(ptr @.lc5673, i64 1, ptr @.lcd5673, ptr @.lty5673)
%t5675 = call i64 @bn_cmp(ptr %t5672, ptr %t5674)
%t5676 = icmp eq i64 %t5675, 0
ret i1 %t5676
}
define i1 @pedersen_valid(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5677 = getelementptr i8, ptr %p0, i64 8
%t5678 = load ptr, ptr %t5677, align 8
%t5679 = getelementptr i8, ptr %p0, i64 0
%t5680 = load ptr, ptr %t5679, align 8
%t5681 = call i1 @zk_valid_mod_n(ptr %t5678, ptr %t5680)
br label %LSL5682
LSL5682:
br i1 %t5681, label %LSR5682, label %LSJ5682
LSR5682:
%t5683 = getelementptr i8, ptr %p0, i64 16
%t5684 = load ptr, ptr %t5683, align 8
%t5685 = getelementptr i8, ptr %p0, i64 0
%t5686 = load ptr, ptr %t5685, align 8
%t5687 = call i1 @zk_valid_mod_n(ptr %t5684, ptr %t5686)
br label %LSJ5682
LSJ5682:
%t5688 = phi i1 [ false, %LSL5682 ], [ %t5687, %LSR5682 ]
br label %LSL5689
LSL5689:
br i1 %t5688, label %LSR5689, label %LSJ5689
LSR5689:
%t5690 = getelementptr i8, ptr %p0, i64 8
%t5691 = load ptr, ptr %t5690, align 8
%t5692 = getelementptr i8, ptr %p0, i64 16
%t5693 = load ptr, ptr %t5692, align 8
%t5694 = call i64 @bn_cmp(ptr %t5691, ptr %t5693)
%t5695 = icmp ne i64 %t5694, 0
br label %LSJ5689
LSJ5689:
%t5696 = phi i1 [ false, %LSL5689 ], [ %t5695, %LSR5689 ]
ret i1 %t5696
}
define ptr @tr_pedersen(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5698 = getelementptr i8, ptr %p1, i64 0
%t5699 = load ptr, ptr %t5698, align 8
%t5700 = call ptr @bn_to_be(ptr %t5699, i64 256)
%t5701 = getelementptr i8, ptr %p1, i64 8
%t5702 = load ptr, ptr %t5701, align 8
%t5703 = call ptr @bn_to_be(ptr %t5702, i64 256)
%t5704 = call ptr @resid_list_freeze(ptr %t5703)
%t5705 = call ptr @resid_list_concat_own(ptr %t5700, i8 1, ptr %t5704)
%t5706 = getelementptr i8, ptr %p1, i64 16
%t5707 = load ptr, ptr %t5706, align 8
%t5708 = call ptr @bn_to_be(ptr %t5707, i64 256)
%t5709 = call ptr @resid_list_freeze(ptr %t5708)
%t5710 = call ptr @resid_list_concat_own(ptr %t5705, i8 1, ptr %t5709)
%t5711 = call ptr @tr_item(ptr %p0, ptr @.s5697, ptr %t5710)
ret ptr %t5711
}
define ptr @zk_draw_below(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5740, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t5712 = call i64 @bn_bit_len(ptr %p2)
%t5713 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5712, i64 7)
%t5714 = extractvalue {i64, i1} %t5713, 0
%t5715 = extractvalue {i64, i1} %t5713, 1
%t5716 = zext i1 %t5715 to i8
call void @resid_overflow_check(i8 %t5716)
%t5717 = sdiv i64 %t5714, 8
%t5718 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t5717)
%t5719 = extractvalue {i64, i1} %t5718, 0
%t5720 = extractvalue {i64, i1} %t5718, 1
%t5721 = zext i1 %t5720 to i8
call void @resid_overflow_check(i8 %t5721)
%t5722 = call i64 @resid_list_len(ptr %p0)
%t5723 = icmp sgt i64 %t5719, %t5722
br i1 %t5723, label %L658, label %L660
L658:
ret ptr @.nbox5724
L660:
%t5725 = call ptr @bn_slice_int(ptr %p0, i64 %p1, i64 %t5717)
%t5726 = call ptr @resid_list_freeze(ptr %t5725)
%t5727 = call ptr @bn_from_be(ptr %t5726)
%t5728 = call ptr @resid_list_freeze(ptr %t5727)
%t5729 = call i64 @bn_cmp(ptr %t5728, ptr %p2)
%t5730 = icmp slt i64 %t5729, 0
br i1 %t5730, label %L661, label %L663
L661:
%t5731 = call ptr @resid_gmalloc(i64 16)
%t5731.f0 = getelementptr i8, ptr %t5731, i64 0
store ptr %t5728, ptr %t5731.f0, align 8
%t5732 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t5717)
%t5733 = extractvalue {i64, i1} %t5732, 0
%t5734 = extractvalue {i64, i1} %t5732, 1
%t5735 = zext i1 %t5734 to i8
call void @resid_overflow_check(i8 %t5735)
%t5731.f1 = getelementptr i8, ptr %t5731, i64 8
store i64 %t5733, ptr %t5731.f1, align 8
%t5738 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty5736)
%t5737 = getelementptr {i32, i32, ptr}, ptr %t5738, i32 1
store ptr %t5731, ptr %t5737
ret ptr %t5738
L663:
%t5739 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t5717)
%t5740 = extractvalue {i64, i1} %t5739, 0
%t5741 = extractvalue {i64, i1} %t5739, 1
%t5742 = zext i1 %t5741 to i8
call void @resid_overflow_check(i8 %t5742)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_cggmp_zk_resid__prm_transcript(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p2.ld = call ptr @resid_list_vdata(ptr %p2.in)
%p2.ln = call i64 @resid_list_vlen(ptr %p2.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %t5749, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t5750, %tco.s0 ]
%t5744 = call i64 @resid_list_len(ptr %p2)
%t5745 = icmp sge i64 %p3, %t5744
br i1 %t5745, label %L664, label %L666
L664:
ret ptr %p0
L666:
%t5746 = call ptr @resid_list_get_v(ptr %p2, i64 %p3, ptr %p2.ld, i64 %p2.ln)
%t5749 = call ptr @tr_nat(ptr %p0, ptr %t5746)
%t5750 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_cggmp_zk_resid__prm_challenge(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5752 = call ptr @tr_pedersen(ptr %p0, ptr %p1)
call void @"resid.rec.freeze.Transcript"(ptr %t5752)
%t5753 = call ptr @__m____________lib_cggmp_zk_resid__prm_transcript(ptr %t5752, ptr %p1, ptr %p2, i64 0)
call void @"resid.rec.freeze.Transcript"(ptr %t5753)
%t5754 = call ptr @tr_seed(ptr %t5753)
%t5755 = call ptr @resid_list_freeze(ptr %t5754)
%t5756 = call ptr @tr_stream(ptr %t5755, i64 0, i64 80)
ret ptr %t5756
}
define i1 @__m____________lib_cggmp_zk_resid__prm_check_all(ptr %p0.in, ptr %p1.in, ptr %p2.in, ptr %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p3.ld = call ptr @resid_list_vdata(ptr %p3.in)
%p3.ln = call i64 @resid_list_vlen(ptr %p3.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t5799, %tco.s0.k ]
%t5757 = icmp sge i64 %p4, 80
br i1 %t5757, label %L667, label %L669
L667:
call void @resid_scope_pop(i64 %lml)
ret i1 true
L669:
%t5758 = getelementptr i8, ptr %p2, i64 0
%t5759 = load ptr, ptr %t5758, align 8
%t5760 = call ptr @resid_list_get(ptr %t5759, i64 %p4)
%t5763 = getelementptr i8, ptr %p2, i64 8
%t5764 = load ptr, ptr %t5763, align 8
%t5765 = call ptr @resid_list_get(ptr %t5764, i64 %p4)
%t5768 = getelementptr i8, ptr %p1, i64 0
%t5769 = load ptr, ptr %t5768, align 8
%t5770 = call i1 @zk_valid_mod_n(ptr %t5760, ptr %t5769)
%t5771 = xor i1 %t5770, true
br label %LSL5772
LSL5772:
br i1 %t5771, label %LSJ5772, label %LSR5772
LSR5772:
%t5773 = getelementptr i8, ptr %p1, i64 0
%t5774 = load ptr, ptr %t5773, align 8
%t5775 = call i1 @zk_valid_mod_n(ptr %t5765, ptr %t5774)
%t5776 = xor i1 %t5775, true
br label %LSJ5772
LSJ5772:
%t5777 = phi i1 [ true, %LSL5772 ], [ %t5776, %LSR5772 ]
br i1 %t5777, label %L670, label %L672
L670:
call void @resid_scope_pop(i64 %lml)
ret i1 false
L672:
%t5779 = call ptr @resid_list_const_i64(ptr @.lc5778, i64 1, ptr @.lcd5778, ptr @.lty5778)
%t5780 = call i64 @bn_cmp(ptr %t5760, ptr %t5779)
%t5781 = icmp eq i64 %t5780, 0
br i1 %t5781, label %L673, label %L675
L673:
call void @resid_scope_pop(i64 %lml)
ret i1 false
L675:
%t5782 = getelementptr i8, ptr %p1, i64 16
%t5783 = load ptr, ptr %t5782, align 8
%t5784 = call ptr @bn_modexp_mont(ptr %p0, ptr %t5783, ptr %t5765)
%t5785 = call ptr @resid_list_get_v(ptr %p3, i64 %p4, ptr %p3.ld, i64 %p3.ln)
%t5786 = call i64 @resid_unbox_i64(ptr %t5785)
%t5788 = and i64 %t5786, 1
%t5789 = icmp eq i64 %t5788, 1
br i1 %t5789, label %L676, label %L677
L676:
%t5790 = getelementptr i8, ptr %p1, i64 8
%t5791 = load ptr, ptr %t5790, align 8
%t5792 = getelementptr i8, ptr %p1, i64 0
%t5793 = load ptr, ptr %t5792, align 8
%t5794 = call ptr @bn_modmul(ptr %t5760, ptr %t5791, ptr %t5793)
%t5795 = call ptr @resid_list_freeze(ptr %t5794)
br label %L678
L677:
br label %L678
L678:
%t5796 = phi ptr [ %t5795, %L676 ], [ %t5760, %L677 ]
%t5797 = call i64 @bn_cmp(ptr %t5784, ptr %t5796)
%t5798 = icmp ne i64 %t5797, 0
br i1 %t5798, label %L679, label %L681
L679:
call void @resid_scope_pop(i64 %lml)
ret i1 false
L681:
%t5799 = add nsw i64 %p4, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %p3, %tco.s0 ]
br label %tco.head
}
define i1 @prm_verify(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5801 = getelementptr i8, ptr %p1, i64 0
%t5802 = load ptr, ptr %t5801, align 8
%t5803 = call i64 @resid_list_len(ptr %t5802)
%t5804 = icmp ne i64 %t5803, 80
br label %LSL5805
LSL5805:
br i1 %t5804, label %LSJ5805, label %LSR5805
LSR5805:
%t5806 = getelementptr i8, ptr %p1, i64 8
%t5807 = load ptr, ptr %t5806, align 8
%t5808 = call i64 @resid_list_len(ptr %t5807)
%t5809 = icmp ne i64 %t5808, 80
br label %LSJ5805
LSJ5805:
%t5810 = phi i1 [ true, %LSL5805 ], [ %t5809, %LSR5805 ]
br i1 %t5810, label %L682, label %L684
L682:
ret i1 false
L684:
%t5811 = getelementptr i8, ptr %p0, i64 0
%t5812 = load ptr, ptr %t5811, align 8
%t5813 = call i1 @bn_is_odd(ptr %t5812)
%t5814 = xor i1 %t5813, true
br label %LSL5815
LSL5815:
br i1 %t5814, label %LSJ5815, label %LSR5815
LSR5815:
%t5816 = call i1 @pedersen_valid(ptr %p0)
%t5817 = xor i1 %t5816, true
br label %LSJ5815
LSJ5815:
%t5818 = phi i1 [ true, %LSL5815 ], [ %t5817, %LSR5815 ]
br i1 %t5818, label %L685, label %L687
L685:
ret i1 false
L687:
%t5819 = getelementptr i8, ptr %p0, i64 0
%t5820 = load ptr, ptr %t5819, align 8
%t5821 = call ptr @bn_mont_new(ptr %t5820)
%t5822 = getelementptr i8, ptr %p1, i64 0
%t5823 = load ptr, ptr %t5822, align 8
%t5824 = call ptr @__m____________lib_cggmp_zk_resid__prm_challenge(ptr %p2, ptr %p0, ptr %t5823)
%t5825 = call i1 @__m____________lib_cggmp_zk_resid__prm_check_all(ptr %t5821, ptr %p0, ptr %p1, ptr %t5824, i64 0)
ret i1 %t5825
}
define ptr @__m____________lib_cggmp_zk_resid__prm_draw_as(ptr %p0, i64 %p1, ptr %p2, i64 %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5826 = icmp sge i64 %p3, 80
br i1 %t5826, label %L688, label %L690
L688:
%t5827 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty5827)
%t5830 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty5828)
%t5829 = getelementptr {i32, i32, ptr}, ptr %t5830, i32 1
store ptr %t5827, ptr %t5829
ret ptr %t5830
L690:
%t5831 = call ptr @zk_draw_below(ptr %p0, i64 %p1, ptr %p2)
%t5832 = getelementptr {i32, i32, ptr}, ptr %t5831, i32 0, i32 0
%t5833w = load i32, ptr %t5832
%t5833 = sext i32 %t5833w to i64
%t5834 = icmp eq i64 %t5833, 1
br i1 %t5834, label %L692, label %L691
L691:
%t5835 = call ptr @__m____________lib_cggmp_zk_resid__zk_drop(ptr %p4)
br label %L693
L692:
%t5836 = getelementptr {i32, i32, ptr}, ptr %t5831, i32 1
%t5837 = getelementptr i8, ptr %t5836, i64 0
%t5838 = getelementptr ptr, ptr %t5837, i32 0
%t5839 = load ptr, ptr %t5838
%t5840 = getelementptr i8, ptr %t5839, i64 8
%t5841 = load i64, ptr %t5840, align 8
%t5842 = add nsw i64 %p3, 1
%t5843 = getelementptr i8, ptr %t5839, i64 0
%t5844 = load ptr, ptr %t5843, align 8
%t5848 = call ptr @resid_listbuf_push(ptr %p4, ptr %t5844)
%t5849 = call ptr @__m____________lib_cggmp_zk_resid__prm_draw_as(ptr %p0, i64 %t5841, ptr %p2, i64 %t5842, ptr %t5848)
br label %L693
L693:
%t5850 = phi ptr [ %t5835, %L691 ], [ %t5849, %L692 ]
ret ptr %t5850
}
define ptr @__m____________lib_cggmp_zk_resid__zk_drop(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5851 = call ptr @resid_listbuf_finish(ptr %p0, ptr @.lty5851)
ret ptr @.nbox5852
}
define ptr @__m____________lib_cggmp_zk_resid__prm_powers(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p2.ld = call ptr @resid_list_vdata(ptr %p2.in)
%p2.ln = call i64 @resid_list_vlen(ptr %p2.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t5856, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t5865, %tco.s0 ]
%t5853 = call i64 @resid_list_len(ptr %p2)
%t5854 = icmp sge i64 %p3, %t5853
br i1 %t5854, label %L694, label %L696
L694:
%t5855 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty5855)
ret ptr %t5855
L696:
%t5856 = add nsw i64 %p3, 1
%t5857 = call ptr @resid_list_get_v(ptr %p2, i64 %p3, ptr %p2.ld, i64 %p2.ln)
%t5860 = call ptr @bn_modexp_mont(ptr %p0, ptr %p1, ptr %t5857)
%t5861 = call ptr @resid_list_freeze(ptr %t5860)
%t5865 = call ptr @resid_listbuf_push(ptr %p4, ptr %t5861)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_cggmp_zk_resid__prm_responses(ptr %p0.in, ptr %p1.in, ptr %p2.in, ptr %p3.in, i64 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t5886, %tco.s0 ]
%p5 = phi ptr [ %p5.in, %entry ], [ %t5890, %tco.s0 ]
%t5867 = call i64 @resid_list_len(ptr %p0)
%t5868 = icmp sge i64 %p4, %t5867
br i1 %t5868, label %L697, label %L699
L697:
%t5869 = call ptr @resid_listbuf_finish(ptr %p5, ptr @.lty5869)
ret ptr %t5869
L699:
%t5870 = call ptr @resid_list_get_v(ptr %p1, i64 %p4, ptr %p1.ld, i64 %p1.ln)
%t5871 = call i64 @resid_unbox_i64(ptr %t5870)
%t5873 = and i64 %t5871, 1
%t5874 = icmp eq i64 %t5873, 1
br i1 %t5874, label %L700, label %L701
L700:
%t5875 = call ptr @resid_list_get_v(ptr %p0, i64 %p4, ptr %p0.ld, i64 %p0.ln)
%t5878 = call ptr @bn_mod(ptr %p2, ptr %p3)
%t5879 = call ptr @resid_list_freeze(ptr %t5878)
%t5880 = call ptr @bn_modadd(ptr %t5875, ptr %t5879, ptr %p3)
%t5881 = call ptr @resid_list_freeze(ptr %t5880)
br label %L702
L701:
%t5882 = call ptr @resid_list_get_v(ptr %p0, i64 %p4, ptr %p0.ld, i64 %p0.ln)
br label %L702
L702:
%t5885 = phi ptr [ %t5881, %L700 ], [ %t5882, %L701 ]
%t5886 = add nsw i64 %p4, 1
%t5890 = call ptr @resid_listbuf_push(ptr %p5, ptr %t5885)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @prm_prove(ptr %p0, ptr %p1, ptr %p2, ptr %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5892 = call ptr @resid_listbuf_new()
%t5893 = call ptr @__m____________lib_cggmp_zk_resid__prm_draw_as(ptr %p4, i64 0, ptr %p1, i64 0, ptr %t5892)
%t5894 = getelementptr {i32, i32, ptr}, ptr %t5893, i32 0, i32 0
%t5895w = load i32, ptr %t5894
%t5895 = sext i32 %t5895w to i64
%t5896 = icmp eq i64 %t5895, 1
br i1 %t5896, label %L704, label %L703
L703:
br label %L705
L704:
%t5898 = getelementptr {i32, i32, ptr}, ptr %t5893, i32 1
%t5899 = getelementptr i8, ptr %t5898, i64 0
%t5900 = getelementptr ptr, ptr %t5899, i32 0
%t5901 = load ptr, ptr %t5900
%t5902 = call ptr @__m____________lib_cggmp_zk_resid__prm_finish(ptr %p0, ptr %p1, ptr %p2, ptr %p3, ptr %t5901)
call void @"resid.rec.freeze.PrmProof"(ptr %t5902)
%t5905 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty5903)
%t5904 = getelementptr {i32, i32, ptr}, ptr %t5905, i32 1
store ptr %t5902, ptr %t5904
br label %L705
L705:
%t5906 = phi ptr [ @.nbox5897, %L703 ], [ %t5905, %L704 ]
ret ptr %t5906
}
define ptr @__m____________lib_cggmp_zk_resid__prm_finish(ptr %p0, ptr %p1, ptr %p2, ptr %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5907 = getelementptr i8, ptr %p2, i64 0
%t5908 = load ptr, ptr %t5907, align 8
%t5909 = call ptr @bn_mont_new(ptr %t5908)
%t5910 = getelementptr i8, ptr %p2, i64 16
%t5911 = load ptr, ptr %t5910, align 8
%t5912 = call ptr @resid_listbuf_new()
%t5913 = call ptr @__m____________lib_cggmp_zk_resid__prm_powers(ptr %t5909, ptr %t5911, ptr %p4, i64 0, ptr %t5912)
%t5914 = call ptr @__m____________lib_cggmp_zk_resid__prm_challenge(ptr %p3, ptr %p2, ptr %t5913)
%t5915 = call ptr @resid_gmalloc(i64 16)
%t5915.f0 = getelementptr i8, ptr %t5915, i64 0
store ptr %t5913, ptr %t5915.f0, align 8
%t5916 = call ptr @resid_listbuf_new()
%t5917 = call ptr @__m____________lib_cggmp_zk_resid__prm_responses(ptr %p4, ptr %t5914, ptr %p0, ptr %p1, i64 0, ptr %t5916)
%t5915.f1 = getelementptr i8, ptr %t5915, i64 8
store ptr %t5917, ptr %t5915.f1, align 8
ret ptr %t5915
}
define ptr @__m____________lib_cggmp_zk_resid__mod_challenges(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5918 = call ptr @tr_modulus(ptr %p0, ptr %p1)
call void @"resid.rec.freeze.Transcript"(ptr %t5918)
%t5919 = call ptr @tr_nat(ptr %t5918, ptr %p2)
call void @"resid.rec.freeze.Transcript"(ptr %t5919)
%t5920 = call ptr @tr_seed(ptr %t5919)
%t5921 = call ptr @resid_list_freeze(ptr %t5920)
%t5922 = call ptr @resid_listbuf_new()
%t5923 = call ptr @__m____________lib_cggmp_zk_resid__mod_ys(ptr %t5921, ptr %p1, i64 0, i64 0, ptr %t5922)
ret ptr %t5923
}
define ptr @__m____________lib_cggmp_zk_resid__mod_ys(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5928, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t5929, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t5935, %tco.s0 ]
%t5924 = icmp sge i64 %p3, 80
br i1 %t5924, label %L706, label %L708
L706:
%t5925 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty5925)
ret ptr %t5925
L708:
%t5926 = call ptr @tr_sample_modn(ptr %p0, i64 %p2, ptr %p1)
call void @"resid.rec.freeze.TrSample"(ptr %t5926)
%t5927 = getelementptr i8, ptr %t5926, i64 8
%t5928 = load i64, ptr %t5927, align 8
%t5929 = add nsw i64 %p3, 1
%t5930 = getelementptr i8, ptr %t5926, i64 0
%t5931 = load ptr, ptr %t5930, align 8
%t5935 = call ptr @resid_listbuf_push(ptr %p4, ptr %t5931)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @__m____________lib_cggmp_zk_resid__mod_response_ok(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5937 = getelementptr i8, ptr %p3, i64 16
%t5938 = load ptr, ptr %t5937, align 8
%t5939 = getelementptr i8, ptr %p0, i64 0
%t5940 = load ptr, ptr %t5939, align 8
%t5941 = call i1 @zk_valid_mod_n(ptr %t5938, ptr %t5940)
%t5942 = xor i1 %t5941, true
br label %LSL5943
LSL5943:
br i1 %t5942, label %LSJ5943, label %LSR5943
LSR5943:
%t5944 = getelementptr i8, ptr %p3, i64 24
%t5945 = load ptr, ptr %t5944, align 8
%t5946 = getelementptr i8, ptr %p0, i64 0
%t5947 = load ptr, ptr %t5946, align 8
%t5948 = call i1 @zk_valid_mod_n(ptr %t5945, ptr %t5947)
%t5949 = xor i1 %t5948, true
br label %LSJ5943
LSJ5943:
%t5950 = phi i1 [ true, %LSL5943 ], [ %t5949, %LSR5943 ]
br i1 %t5950, label %L709, label %L711
L709:
ret i1 false
L711:
%t5951 = getelementptr i8, ptr %p3, i64 24
%t5952 = load ptr, ptr %t5951, align 8
%t5953 = getelementptr i8, ptr %p0, i64 0
%t5954 = load ptr, ptr %t5953, align 8
%t5955 = call ptr @bn_modexp_mont(ptr %p0, ptr %t5952, ptr %t5954)
%t5956 = call ptr @resid_list_freeze(ptr %t5955)
%t5957 = getelementptr i8, ptr %p0, i64 0
%t5958 = load ptr, ptr %t5957, align 8
%t5959 = call ptr @bn_mod(ptr %p2, ptr %t5958)
%t5960 = call ptr @resid_list_freeze(ptr %t5959)
%t5961 = call i64 @bn_cmp(ptr %t5956, ptr %t5960)
%t5962 = icmp ne i64 %t5961, 0
br i1 %t5962, label %L712, label %L714
L712:
ret i1 false
L714:
%t5963 = getelementptr i8, ptr %p3, i64 16
%t5964 = load ptr, ptr %t5963, align 8
%t5965 = getelementptr i8, ptr %p3, i64 16
%t5966 = load ptr, ptr %t5965, align 8
%t5967 = getelementptr i8, ptr %p0, i64 0
%t5968 = load ptr, ptr %t5967, align 8
%t5969 = call ptr @bn_modmul(ptr %t5964, ptr %t5966, ptr %t5968)
%t5970 = getelementptr i8, ptr %p0, i64 0
%t5971 = load ptr, ptr %t5970, align 8
%t5972 = call ptr @bn_modmul(ptr %t5969, ptr %t5969, ptr %t5971)
%t5973 = getelementptr i8, ptr %p3, i64 0
%t5974 = load i1, ptr %t5973, align 8
br i1 %t5974, label %L715, label %L716
L715:
%t5976 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty5975)
%t5977 = getelementptr i8, ptr %p0, i64 0
%t5978 = load ptr, ptr %t5977, align 8
%t5979 = call ptr @bn_mod(ptr %p2, ptr %t5978)
%t5980 = call ptr @resid_list_freeze(ptr %t5979)
%t5981 = getelementptr i8, ptr %p0, i64 0
%t5982 = load ptr, ptr %t5981, align 8
%t5983 = call ptr @bn_modsub(ptr %t5976, ptr %t5980, ptr %t5982)
%t5984 = call ptr @resid_list_freeze(ptr %t5983)
br label %L717
L716:
%t5985 = getelementptr i8, ptr %p0, i64 0
%t5986 = load ptr, ptr %t5985, align 8
%t5987 = call ptr @bn_mod(ptr %p2, ptr %t5986)
%t5988 = call ptr @resid_list_freeze(ptr %t5987)
br label %L717
L717:
%t5989 = phi ptr [ %t5984, %L715 ], [ %t5988, %L716 ]
%t5990 = getelementptr i8, ptr %p3, i64 8
%t5991 = load i1, ptr %t5990, align 8
br i1 %t5991, label %L718, label %L719
L718:
%t5992 = getelementptr i8, ptr %p0, i64 0
%t5993 = load ptr, ptr %t5992, align 8
%t5994 = call ptr @bn_modmul(ptr %t5989, ptr %p1, ptr %t5993)
%t5995 = call ptr @resid_list_freeze(ptr %t5994)
br label %L720
L719:
br label %L720
L720:
%t5996 = phi ptr [ %t5995, %L718 ], [ %t5989, %L719 ]
%t5997 = call i64 @bn_cmp(ptr %t5972, ptr %t5996)
%t5998 = icmp eq i64 %t5997, 0
ret i1 %t5998
}
define i1 @__m____________lib_cggmp_zk_resid__mod_check_all(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p2.ld = call ptr @resid_list_vdata(ptr %p2.in)
%p2.ln = call i64 @resid_list_vlen(ptr %p2.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t6012, %tco.s0.k ]
%t5999 = icmp sge i64 %p3, 80
br i1 %t5999, label %L721, label %L723
L721:
call void @resid_scope_pop(i64 %lml)
ret i1 true
L723:
%t6000 = getelementptr i8, ptr %p1, i64 0
%t6001 = load ptr, ptr %t6000, align 8
%t6002 = call ptr @resid_list_get_v(ptr %p2, i64 %p3, ptr %p2.ld, i64 %p2.ln)
%t6005 = getelementptr i8, ptr %p1, i64 8
%t6006 = load ptr, ptr %t6005, align 8
%t6007 = call ptr @resid_list_get(ptr %t6006, i64 %p3)
%t6010 = call i1 @__m____________lib_cggmp_zk_resid__mod_response_ok(ptr %p0, ptr %t6001, ptr %t6002, ptr %t6007)
%t6011 = xor i1 %t6010, true
br i1 %t6011, label %L724, label %L726
L724:
call void @resid_scope_pop(i64 %lml)
ret i1 false
L726:
%t6012 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
br label %tco.head
}
define i1 @mod_verify(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6014 = getelementptr i8, ptr %p1, i64 8
%t6015 = load ptr, ptr %t6014, align 8
%t6016 = call i64 @resid_list_len(ptr %t6015)
%t6017 = icmp ne i64 %t6016, 80
br i1 %t6017, label %L727, label %L729
L727:
ret i1 false
L729:
%t6018 = call i1 @bn_is_odd(ptr %p0)
%t6019 = xor i1 %t6018, true
br label %LSL6020
LSL6020:
br i1 %t6019, label %LSJ6020, label %LSR6020
LSR6020:
%t6022 = call ptr @resid_list_const_i64(ptr @.lc6021, i64 1, ptr @.lcd6021, ptr @.lty6021)
%t6023 = call i64 @bn_cmp(ptr %p0, ptr %t6022)
%t6024 = icmp sle i64 %t6023, 0
br label %LSJ6020
LSJ6020:
%t6025 = phi i1 [ true, %LSL6020 ], [ %t6024, %LSR6020 ]
br i1 %t6025, label %L730, label %L732
L730:
ret i1 false
L732:
%t6026 = alloca [1 x ptr]
%t6028 = call ptr @resid_box_i64(i64 2)
%t6030 = getelementptr i8, ptr %t6026, i64 0
store ptr %t6028, ptr %t6030
%t6031 = call ptr @resid_list_new(i64 1, ptr %t6026, ptr @.lty6026)
%t6032 = alloca [1 x ptr]
%t6034 = call ptr @resid_box_i64(i64 3)
%t6036 = getelementptr i8, ptr %t6032, i64 0
store ptr %t6034, ptr %t6036
%t6037 = call ptr @resid_list_new(i64 1, ptr %t6032, ptr @.lty6032)
%t6038 = alloca [1 x ptr]
%t6040 = call ptr @resid_box_i64(i64 5)
%t6042 = getelementptr i8, ptr %t6038, i64 0
store ptr %t6040, ptr %t6042
%t6043 = call ptr @resid_list_new(i64 1, ptr %t6038, ptr @.lty6038)
%t6044 = alloca [1 x ptr]
%t6046 = call ptr @resid_box_i64(i64 7)
%t6048 = getelementptr i8, ptr %t6044, i64 0
store ptr %t6046, ptr %t6048
%t6049 = call ptr @resid_list_new(i64 1, ptr %t6044, ptr @.lty6044)
%t6050 = alloca [1 x ptr]
%t6052 = call ptr @resid_box_i64(i64 11)
%t6054 = getelementptr i8, ptr %t6050, i64 0
store ptr %t6052, ptr %t6054
%t6055 = call ptr @resid_list_new(i64 1, ptr %t6050, ptr @.lty6050)
%t6056 = alloca [1 x ptr]
%t6058 = call ptr @resid_box_i64(i64 13)
%t6060 = getelementptr i8, ptr %t6056, i64 0
store ptr %t6058, ptr %t6060
%t6061 = call ptr @resid_list_new(i64 1, ptr %t6056, ptr @.lty6056)
%t6062 = alloca [1 x ptr]
%t6064 = call ptr @resid_box_i64(i64 17)
%t6066 = getelementptr i8, ptr %t6062, i64 0
store ptr %t6064, ptr %t6066
%t6067 = call ptr @resid_list_new(i64 1, ptr %t6062, ptr @.lty6062)
%t6068 = alloca [1 x ptr]
%t6070 = call ptr @resid_box_i64(i64 19)
%t6072 = getelementptr i8, ptr %t6068, i64 0
store ptr %t6070, ptr %t6072
%t6073 = call ptr @resid_list_new(i64 1, ptr %t6068, ptr @.lty6068)
%t6074 = alloca [1 x ptr]
%t6076 = call ptr @resid_box_i64(i64 23)
%t6078 = getelementptr i8, ptr %t6074, i64 0
store ptr %t6076, ptr %t6078
%t6079 = call ptr @resid_list_new(i64 1, ptr %t6074, ptr @.lty6074)
%t6080 = alloca [1 x ptr]
%t6082 = call ptr @resid_box_i64(i64 29)
%t6084 = getelementptr i8, ptr %t6080, i64 0
store ptr %t6082, ptr %t6084
%t6085 = call ptr @resid_list_new(i64 1, ptr %t6080, ptr @.lty6080)
%t6086 = alloca [1 x ptr]
%t6088 = call ptr @resid_box_i64(i64 31)
%t6090 = getelementptr i8, ptr %t6086, i64 0
store ptr %t6088, ptr %t6090
%t6091 = call ptr @resid_list_new(i64 1, ptr %t6086, ptr @.lty6086)
%t6092 = alloca [1 x ptr]
%t6094 = call ptr @resid_box_i64(i64 37)
%t6096 = getelementptr i8, ptr %t6092, i64 0
store ptr %t6094, ptr %t6096
%t6097 = call ptr @resid_list_new(i64 1, ptr %t6092, ptr @.lty6092)
%t6098 = alloca [12 x ptr]
%t6102 = getelementptr i8, ptr %t6098, i64 0
store ptr %t6031, ptr %t6102
%t6105 = getelementptr i8, ptr %t6098, i64 8
store ptr %t6037, ptr %t6105
%t6108 = getelementptr i8, ptr %t6098, i64 16
store ptr %t6043, ptr %t6108
%t6111 = getelementptr i8, ptr %t6098, i64 24
store ptr %t6049, ptr %t6111
%t6114 = getelementptr i8, ptr %t6098, i64 32
store ptr %t6055, ptr %t6114
%t6117 = getelementptr i8, ptr %t6098, i64 40
store ptr %t6061, ptr %t6117
%t6120 = getelementptr i8, ptr %t6098, i64 48
store ptr %t6067, ptr %t6120
%t6123 = getelementptr i8, ptr %t6098, i64 56
store ptr %t6073, ptr %t6123
%t6126 = getelementptr i8, ptr %t6098, i64 64
store ptr %t6079, ptr %t6126
%t6129 = getelementptr i8, ptr %t6098, i64 72
store ptr %t6085, ptr %t6129
%t6132 = getelementptr i8, ptr %t6098, i64 80
store ptr %t6091, ptr %t6132
%t6135 = getelementptr i8, ptr %t6098, i64 88
store ptr %t6097, ptr %t6135
%t6136 = call ptr @resid_list_new(i64 12, ptr %t6098, ptr @.lty6098)
%t6137 = call i1 @bn_miller_rabin(ptr %p0, ptr %t6136)
br i1 %t6137, label %L733, label %L735
L733:
ret i1 false
L735:
%t6138 = getelementptr i8, ptr %p1, i64 0
%t6139 = load ptr, ptr %t6138, align 8
%t6140 = call i64 @bn_jacobi(ptr %t6139, ptr %p0)
%t6141 = icmp ne i64 %t6140, -1
br i1 %t6141, label %L736, label %L738
L736:
ret i1 false
L738:
%t6142 = getelementptr i8, ptr %p1, i64 0
%t6143 = load ptr, ptr %t6142, align 8
%t6144 = call i1 @zk_valid_mod_n(ptr %t6143, ptr %p0)
%t6145 = xor i1 %t6144, true
br i1 %t6145, label %L739, label %L741
L739:
ret i1 false
L741:
%t6146 = call ptr @bn_mont_new(ptr %p0)
call void @"resid.rec.freeze.BnMont"(ptr %t6146)
%t6147 = getelementptr i8, ptr %p1, i64 0
%t6148 = load ptr, ptr %t6147, align 8
%t6149 = call ptr @__m____________lib_cggmp_zk_resid__mod_challenges(ptr %p2, ptr %p0, ptr %t6148)
%t6150 = call i1 @__m____________lib_cggmp_zk_resid__mod_check_all(ptr %t6146, ptr %p1, ptr %t6149, i64 0)
ret i1 %t6150
}
define i1 @__m____________lib_cggmp_zk_resid__mod_is_qr(ptr %p0, ptr %p1, ptr %p2, ptr %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6151 = call ptr @bn_mod(ptr %p0, ptr %p1)
%t6152 = call ptr @resid_list_freeze(ptr %t6151)
%t6153 = call ptr @bn_modexp(ptr %t6152, ptr %p3, ptr %p1)
%t6154 = call ptr @resid_list_freeze(ptr %t6153)
%t6156 = call ptr @resid_list_const_i64(ptr @.lc6155, i64 1, ptr @.lcd6155, ptr @.lty6155)
%t6157 = call i64 @bn_cmp(ptr %t6154, ptr %t6156)
%t6158 = icmp eq i64 %t6157, 0
br label %LSL6159
LSL6159:
br i1 %t6158, label %LSR6159, label %LSJ6159
LSR6159:
%t6160 = call ptr @bn_mod(ptr %p0, ptr %p2)
%t6161 = call ptr @resid_list_freeze(ptr %t6160)
%t6162 = call ptr @bn_modexp(ptr %t6161, ptr %p4, ptr %p2)
%t6163 = call ptr @resid_list_freeze(ptr %t6162)
%t6165 = call ptr @resid_list_const_i64(ptr @.lc6164, i64 1, ptr @.lcd6164, ptr @.lty6164)
%t6166 = call i64 @bn_cmp(ptr %t6163, ptr %t6165)
%t6167 = icmp eq i64 %t6166, 0
br label %LSJ6159
LSJ6159:
%t6168 = phi i1 [ false, %LSL6159 ], [ %t6167, %LSR6159 ]
ret i1 %t6168
}
define ptr @__m____________lib_cggmp_zk_resid__mod_make_qr(ptr %p0, ptr %p1, ptr %p2, ptr %p3, ptr %p4, ptr %p5, ptr %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6169 = call ptr @bn_mod(ptr %p0, ptr %p2)
%t6170 = call ptr @resid_list_freeze(ptr %t6169)
%t6171 = call i1 @__m____________lib_cggmp_zk_resid__mod_is_qr(ptr %t6170, ptr %p3, ptr %p4, ptr %p5, ptr %p6)
br i1 %t6171, label %L742, label %L744
L742:
%t6172 = call ptr @resid_gmalloc(i64 24)
%t6172.f0 = getelementptr i8, ptr %t6172, i64 0
store i1 false, ptr %t6172.f0, align 8
%t6172.f1 = getelementptr i8, ptr %t6172, i64 8
store i1 false, ptr %t6172.f1, align 8
%t6172.f2 = getelementptr i8, ptr %t6172, i64 16
store ptr %t6170, ptr %t6172.f2, align 8
ret ptr %t6172
L744:
%t6174 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty6173)
%t6175 = call ptr @bn_modsub(ptr %t6174, ptr %t6170, ptr %p2)
%t6176 = call ptr @resid_list_freeze(ptr %t6175)
%t6177 = call i1 @__m____________lib_cggmp_zk_resid__mod_is_qr(ptr %t6176, ptr %p3, ptr %p4, ptr %p5, ptr %p6)
br i1 %t6177, label %L745, label %L747
L745:
%t6178 = call ptr @resid_gmalloc(i64 24)
%t6178.f0 = getelementptr i8, ptr %t6178, i64 0
store i1 true, ptr %t6178.f0, align 8
%t6178.f1 = getelementptr i8, ptr %t6178, i64 8
store i1 false, ptr %t6178.f1, align 8
%t6178.f2 = getelementptr i8, ptr %t6178, i64 16
store ptr %t6176, ptr %t6178.f2, align 8
ret ptr %t6178
L747:
%t6179 = call ptr @bn_modmul(ptr %t6176, ptr %p1, ptr %p2)
%t6180 = call ptr @resid_list_freeze(ptr %t6179)
%t6181 = call i1 @__m____________lib_cggmp_zk_resid__mod_is_qr(ptr %t6180, ptr %p3, ptr %p4, ptr %p5, ptr %p6)
br i1 %t6181, label %L748, label %L750
L748:
%t6182 = call ptr @resid_gmalloc(i64 24)
%t6182.f0 = getelementptr i8, ptr %t6182, i64 0
store i1 true, ptr %t6182.f0, align 8
%t6182.f1 = getelementptr i8, ptr %t6182, i64 8
store i1 true, ptr %t6182.f1, align 8
%t6182.f2 = getelementptr i8, ptr %t6182, i64 16
store ptr %t6180, ptr %t6182.f2, align 8
ret ptr %t6182
L750:
%t6183 = call ptr @resid_gmalloc(i64 24)
%t6183.f0 = getelementptr i8, ptr %t6183, i64 0
store i1 false, ptr %t6183.f0, align 8
%t6183.f1 = getelementptr i8, ptr %t6183, i64 8
store i1 true, ptr %t6183.f1, align 8
%t6185 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty6184)
%t6186 = call ptr @bn_modsub(ptr %t6185, ptr %t6180, ptr %p2)
%t6183.f2 = getelementptr i8, ptr %t6183, i64 16
store ptr %t6186, ptr %t6183.f2, align 8
ret ptr %t6183
}
define ptr @__m____________lib_cggmp_zk_resid__mod_draw_qnr(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6211, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t6187 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 256)
%t6188 = extractvalue {i64, i1} %t6187, 0
%t6189 = extractvalue {i64, i1} %t6187, 1
%t6190 = zext i1 %t6189 to i8
call void @resid_overflow_check(i8 %t6190)
%t6191 = call i64 @resid_list_len(ptr %p0)
%t6192 = icmp sgt i64 %t6188, %t6191
br i1 %t6192, label %L751, label %L753
L751:
ret ptr @.nbox6193
L753:
%t6194 = call ptr @bn_slice_int(ptr %p0, i64 %p1, i64 256)
%t6195 = call ptr @resid_list_freeze(ptr %t6194)
%t6196 = call ptr @bn_from_be(ptr %t6195)
%t6197 = call ptr @resid_list_freeze(ptr %t6196)
%t6198 = call ptr @bn_mod(ptr %t6197, ptr %p2)
%t6199 = call ptr @resid_list_freeze(ptr %t6198)
%t6200 = call i64 @bn_jacobi(ptr %t6199, ptr %p2)
%t6201 = icmp eq i64 %t6200, -1
br i1 %t6201, label %L754, label %L756
L754:
%t6202 = call ptr @resid_gmalloc(i64 16)
%t6202.f0 = getelementptr i8, ptr %t6202, i64 0
store ptr %t6199, ptr %t6202.f0, align 8
%t6203 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 256)
%t6204 = extractvalue {i64, i1} %t6203, 0
%t6205 = extractvalue {i64, i1} %t6203, 1
%t6206 = zext i1 %t6205 to i8
call void @resid_overflow_check(i8 %t6206)
%t6202.f1 = getelementptr i8, ptr %t6202, i64 8
store i64 %t6204, ptr %t6202.f1, align 8
%t6209 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty6207)
%t6208 = getelementptr {i32, i32, ptr}, ptr %t6209, i32 1
store ptr %t6202, ptr %t6208
ret ptr %t6209
L756:
%t6210 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 256)
%t6211 = extractvalue {i64, i1} %t6210, 0
%t6212 = extractvalue {i64, i1} %t6210, 1
%t6213 = zext i1 %t6212 to i8
call void @resid_overflow_check(i8 %t6213)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_cggmp_zk_resid__mod_responses(ptr %p0.in, ptr %p1.in, ptr %p2.in, ptr %p3.in, ptr %p4.in, ptr %p5.in, ptr %p6.in, ptr %p7.in, ptr %p8.in, i64 %p9.in, ptr %p10.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p8.ld = call ptr @resid_list_vdata(ptr %p8.in)
%p8.ln = call i64 @resid_list_vlen(ptr %p8.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi ptr [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%p6 = phi ptr [ %p6.in, %entry ], [ %p6, %tco.s0 ]
%p7 = phi ptr [ %p7.in, %entry ], [ %p7, %tco.s0 ]
%p8 = phi ptr [ %p8.in, %entry ], [ %p8, %tco.s0 ]
%p9 = phi i64 [ %p9.in, %entry ], [ %t6233, %tco.s0 ]
%p10 = phi ptr [ %p10.in, %entry ], [ %t6237, %tco.s0 ]
%t6215 = call i64 @resid_list_len(ptr %p8)
%t6216 = icmp sge i64 %p9, %t6215
br i1 %t6216, label %L757, label %L759
L757:
%t6217 = call ptr @resid_listbuf_finish(ptr %p10, ptr @.lty6217)
ret ptr %t6217
L759:
%t6218 = call ptr @resid_list_get_v(ptr %p8, i64 %p9, ptr %p8.ld, i64 %p8.ln)
%t6221 = call ptr @__m____________lib_cggmp_zk_resid__mod_make_qr(ptr %t6218, ptr %p0, ptr %p1, ptr %p2, ptr %p3, ptr %p4, ptr %p5)
%t6222 = call ptr @resid_gmalloc(i64 32)
%t6223 = getelementptr i8, ptr %t6221, i64 0
%t6224 = load i1, ptr %t6223, align 8
%t6222.f0 = getelementptr i8, ptr %t6222, i64 0
store i1 %t6224, ptr %t6222.f0, align 8
%t6225 = getelementptr i8, ptr %t6221, i64 8
%t6226 = load i1, ptr %t6225, align 8
%t6222.f1 = getelementptr i8, ptr %t6222, i64 8
store i1 %t6226, ptr %t6222.f1, align 8
%t6227 = getelementptr i8, ptr %t6221, i64 16
%t6228 = load ptr, ptr %t6227, align 8
%t6229 = call ptr @bn_modexp(ptr %t6228, ptr %p6, ptr %p1)
%t6230 = call ptr @resid_list_freeze(ptr %t6229)
%t6222.f2 = getelementptr i8, ptr %t6222, i64 16
store ptr %t6230, ptr %t6222.f2, align 8
%t6231 = call ptr @bn_modexp(ptr %t6218, ptr %p7, ptr %p1)
%t6232 = call ptr @resid_list_freeze(ptr %t6231)
%t6222.f3 = getelementptr i8, ptr %t6222, i64 24
store ptr %t6232, ptr %t6222.f3, align 8
%t6233 = add nsw i64 %p9, 1
%t6237 = call ptr @resid_listbuf_push(ptr %p10, ptr %t6222)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @mod_prove(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6239 = call ptr @bn_mul(ptr %p0, ptr %p1)
%t6240 = call ptr @resid_list_freeze(ptr %t6239)
%t6242 = call i1 @println(ptr @.s6241)
%t6243 = call ptr @__m____________lib_cggmp_zk_resid__mod_draw_qnr(ptr %p3, i64 0, ptr %t6240)
%t6244 = getelementptr {i32, i32, ptr}, ptr %t6243, i32 0, i32 0
%t6245w = load i32, ptr %t6244
%t6245 = sext i32 %t6245w to i64
%t6246 = icmp eq i64 %t6245, 1
br i1 %t6246, label %L761, label %L760
L760:
br label %L762
L761:
%t6248 = getelementptr {i32, i32, ptr}, ptr %t6243, i32 1
%t6249 = getelementptr i8, ptr %t6248, i64 0
%t6250 = getelementptr ptr, ptr %t6249, i32 0
%t6251 = load ptr, ptr %t6250
%t6252 = getelementptr i8, ptr %t6251, i64 0
%t6253 = load ptr, ptr %t6252, align 8
%t6254 = call ptr @__m____________lib_cggmp_zk_resid__mod_prove_with(ptr %p0, ptr %p1, ptr %t6240, ptr %t6253, ptr %p2)
call void @"resid.rec.freeze.ModProof"(ptr %t6254)
%t6257 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty6255)
%t6256 = getelementptr {i32, i32, ptr}, ptr %t6257, i32 1
store ptr %t6254, ptr %t6256
br label %L762
L762:
%t6258 = phi ptr [ @.nbox6247, %L760 ], [ %t6257, %L761 ]
ret ptr %t6258
}
define ptr @__m____________lib_cggmp_zk_resid__mod_prove_with(ptr %p0, ptr %p1, ptr %p2, ptr %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6260 = call ptr @resid_list_const_i64(ptr @.lc6259, i64 1, ptr @.lcd6259, ptr @.lty6259)
%t6261 = call ptr @bn_sub(ptr %p0, ptr %t6260)
%t6263 = call ptr @resid_list_const_i64(ptr @.lc6262, i64 1, ptr @.lcd6262, ptr @.lty6262)
%t6264 = call ptr @bn_sub(ptr %p1, ptr %t6263)
%t6265 = call ptr @bn_mul(ptr %t6261, ptr %t6264)
%t6267 = call ptr @resid_list_const_i64(ptr @.lc6266, i64 1, ptr @.lcd6266, ptr @.lty6266)
%t6268 = call ptr @bn_add(ptr %t6265, ptr %t6267)
%t6269 = call ptr @bn_shr(ptr %t6268, i64 3)
%t6270 = call ptr @bn_modmul(ptr %t6269, ptr %t6269, ptr %t6265)
%t6271 = call ptr @bn_modinv(ptr %p2, ptr %t6265)
%t6272 = getelementptr {i32, i32, ptr}, ptr %t6271, i32 0, i32 0
%t6273w = load i32, ptr %t6272
%t6273 = sext i32 %t6273w to i64
%t6274 = icmp eq i64 %t6273, 1
br i1 %t6274, label %L763, label %L764
L763:
%t6275 = getelementptr {i32, i32, ptr}, ptr %t6271, i32 1
%t6276 = getelementptr i8, ptr %t6275, i64 0
%t6277 = getelementptr ptr, ptr %t6276, i32 0
%t6278 = load ptr, ptr %t6277
br label %L765
L764:
%t6280 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty6279)
br label %L765
L765:
%t6281 = phi ptr [ %t6278, %L763 ], [ %t6280, %L764 ]
%t6283 = call i1 @println(ptr @.s6282)
%t6284 = call ptr @__m____________lib_cggmp_zk_resid__mod_challenges(ptr %p4, ptr %p2, ptr %p3)
%t6286 = call i1 @println(ptr @.s6285)
%t6287 = call ptr @resid_gmalloc(i64 16)
%t6287.f0 = getelementptr i8, ptr %t6287, i64 0
store ptr %p3, ptr %t6287.f0, align 8
%t6288 = call ptr @bn_shr(ptr %p0, i64 1)
%t6289 = call ptr @bn_shr(ptr %p1, i64 1)
%t6290 = call ptr @resid_listbuf_new()
%t6291 = call ptr @__m____________lib_cggmp_zk_resid__mod_responses(ptr %p3, ptr %p2, ptr %p0, ptr %p1, ptr %t6288, ptr %t6289, ptr %t6270, ptr %t6281, ptr %t6284, i64 0, ptr %t6290)
%t6287.f1 = getelementptr i8, ptr %t6287, i64 8
store ptr %t6291, ptr %t6287.f1, align 8
ret ptr %t6287
}
define ptr @zk_draw_unit(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6292 = call ptr @zk_draw_below(ptr %p0, i64 %p1, ptr %p2)
%t6293 = getelementptr {i32, i32, ptr}, ptr %t6292, i32 0, i32 0
%t6294w = load i32, ptr %t6293
%t6294 = sext i32 %t6294w to i64
%t6295 = icmp eq i64 %t6294, 1
br i1 %t6295, label %L767, label %L766
L766:
br label %L768
L767:
%t6297 = getelementptr {i32, i32, ptr}, ptr %t6292, i32 1
%t6298 = getelementptr i8, ptr %t6297, i64 0
%t6299 = getelementptr ptr, ptr %t6298, i32 0
%t6300 = load ptr, ptr %t6299
%t6301 = getelementptr i8, ptr %t6300, i64 0
%t6302 = load ptr, ptr %t6301, align 8
%t6303 = call i1 @zk_valid_mod_n(ptr %t6302, ptr %p2)
br i1 %t6303, label %L769, label %L770
L769:
%t6306 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty6304)
%t6305 = getelementptr {i32, i32, ptr}, ptr %t6306, i32 1
store ptr %t6300, ptr %t6305
br label %L771
L770:
%t6307 = getelementptr i8, ptr %t6300, i64 8
%t6308 = load i64, ptr %t6307, align 8
%t6309 = call ptr @zk_draw_unit(ptr %p0, i64 %t6308, ptr %p2)
br label %L771
L771:
%t6310 = phi ptr [ %t6306, %L769 ], [ %t6309, %L770 ]
br label %L768
L768:
%t6311 = phi ptr [ @.nbox6296, %L766 ], [ %t6310, %L771 ]
ret ptr %t6311
}
define ptr @pedersen_generate(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6312 = call ptr @bn_mul(ptr %p0, ptr %p1)
%t6313 = call ptr @resid_list_freeze(ptr %t6312)
%t6315 = call ptr @resid_list_const_i64(ptr @.lc6314, i64 1, ptr @.lcd6314, ptr @.lty6314)
%t6316 = call ptr @bn_sub(ptr %p0, ptr %t6315)
%t6317 = call ptr @resid_list_freeze(ptr %t6316)
%t6319 = call ptr @resid_list_const_i64(ptr @.lc6318, i64 1, ptr @.lcd6318, ptr @.lty6318)
%t6320 = call ptr @bn_sub(ptr %p1, ptr %t6319)
%t6321 = call ptr @resid_list_freeze(ptr %t6320)
%t6322 = call ptr @bn_mul(ptr %t6317, ptr %t6321)
%t6323 = call ptr @resid_list_freeze(ptr %t6322)
%t6324 = call ptr @zk_draw_below(ptr %p2, i64 0, ptr %t6323)
%t6325 = getelementptr {i32, i32, ptr}, ptr %t6324, i32 0, i32 0
%t6326w = load i32, ptr %t6325
%t6326 = sext i32 %t6326w to i64
%t6327 = icmp eq i64 %t6326, 1
br i1 %t6327, label %L773, label %L772
L772:
br label %L774
L773:
%t6329 = getelementptr {i32, i32, ptr}, ptr %t6324, i32 1
%t6330 = getelementptr i8, ptr %t6329, i64 0
%t6331 = getelementptr ptr, ptr %t6330, i32 0
%t6332 = load ptr, ptr %t6331
%t6333 = getelementptr i8, ptr %t6332, i64 8
%t6334 = load i64, ptr %t6333, align 8
%t6335 = call ptr @zk_draw_unit(ptr %p2, i64 %t6334, ptr %t6313)
%t6336 = getelementptr {i32, i32, ptr}, ptr %t6335, i32 0, i32 0
%t6337w = load i32, ptr %t6336
%t6337 = sext i32 %t6337w to i64
%t6338 = icmp eq i64 %t6337, 1
br i1 %t6338, label %L776, label %L775
L775:
br label %L777
L776:
%t6340 = getelementptr {i32, i32, ptr}, ptr %t6335, i32 1
%t6341 = getelementptr i8, ptr %t6340, i64 0
%t6342 = getelementptr ptr, ptr %t6341, i32 0
%t6343 = load ptr, ptr %t6342
%t6344 = getelementptr i8, ptr %t6332, i64 0
%t6345 = load ptr, ptr %t6344, align 8
%t6346 = getelementptr i8, ptr %t6343, i64 0
%t6347 = load ptr, ptr %t6346, align 8
%t6348 = call ptr @__m____________lib_cggmp_zk_resid__pedersen_from(ptr %t6313, ptr %t6323, ptr %t6345, ptr %t6347)
call void @"resid.rec.freeze.PedersenKey"(ptr %t6348)
%t6351 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty6349)
%t6350 = getelementptr {i32, i32, ptr}, ptr %t6351, i32 1
store ptr %t6348, ptr %t6350
br label %L777
L777:
%t6352 = phi ptr [ @.nbox6339, %L775 ], [ %t6351, %L776 ]
br label %L774
L774:
%t6353 = phi ptr [ @.nbox6328, %L772 ], [ %t6352, %L777 ]
ret ptr %t6353
}
define ptr @__m____________lib_cggmp_zk_resid__pedersen_from(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6354 = call ptr @bn_modmul(ptr %p3, ptr %p3, ptr %p0)
%t6355 = call ptr @resid_gmalloc(i64 24)
%t6356 = call ptr @resid_gmalloc(i64 24)
%t6356.f0 = getelementptr i8, ptr %t6356, i64 0
store ptr %p0, ptr %t6356.f0, align 8
%t6357 = call ptr @bn_modexp(ptr %t6354, ptr %p2, ptr %p0)
%t6356.f1 = getelementptr i8, ptr %t6356, i64 8
store ptr %t6357, ptr %t6356.f1, align 8
%t6356.f2 = getelementptr i8, ptr %t6356, i64 16
store ptr %t6354, ptr %t6356.f2, align 8
%t6355.f0 = getelementptr i8, ptr %t6355, i64 0
store ptr %t6356, ptr %t6355.f0, align 8
%t6355.f1 = getelementptr i8, ptr %t6355, i64 8
store ptr %p2, ptr %t6355.f1, align 8
%t6355.f2 = getelementptr i8, ptr %t6355, i64 16
store ptr %p1, ptr %t6355.f2, align 8
ret ptr %t6355
}
define ptr @__m____________lib_sha512g_resid__sha512g_k() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6358 = add i64 4794697086780616226, 0
%t6359 = add i64 %t6358, 0
%t6360 = add i64 %t6359, 0
%t6361 = icmp ne i64 %t6360, %t6358
%t6362 = icmp slt i64 4794697086780616226, 0
%t6363 = or i1 %t6361, %t6362
%t6364 = zext i1 %t6363 to i8
call void @resid_conv_check(i8 %t6364)
%t6365 = add i64 8158064640168781261, 0
%t6366 = add i64 %t6365, 0
%t6367 = add i64 %t6366, 0
%t6368 = icmp ne i64 %t6367, %t6365
%t6369 = icmp slt i64 8158064640168781261, 0
%t6370 = or i1 %t6368, %t6369
%t6371 = zext i1 %t6370 to i8
call void @resid_conv_check(i8 %t6371)
%t6372 = add i128 13096744586834688815, 0
%t6373 = trunc i128 %t6372 to i64
%t6374 = zext i64 %t6373 to i128
%t6375 = icmp ne i128 %t6374, %t6372
%t6376 = icmp slt i128 13096744586834688815, 0
%t6377 = or i1 %t6375, %t6376
%t6378 = zext i1 %t6377 to i8
call void @resid_conv_check(i8 %t6378)
%t6379 = add i128 16840607885511220156, 0
%t6380 = trunc i128 %t6379 to i64
%t6381 = zext i64 %t6380 to i128
%t6382 = icmp ne i128 %t6381, %t6379
%t6383 = icmp slt i128 16840607885511220156, 0
%t6384 = or i1 %t6382, %t6383
%t6385 = zext i1 %t6384 to i8
call void @resid_conv_check(i8 %t6385)
%t6386 = add i64 4131703408338449720, 0
%t6387 = add i64 %t6386, 0
%t6388 = add i64 %t6387, 0
%t6389 = icmp ne i64 %t6388, %t6386
%t6390 = icmp slt i64 4131703408338449720, 0
%t6391 = or i1 %t6389, %t6390
%t6392 = zext i1 %t6391 to i8
call void @resid_conv_check(i8 %t6392)
%t6393 = add i64 6480981068601479193, 0
%t6394 = add i64 %t6393, 0
%t6395 = add i64 %t6394, 0
%t6396 = icmp ne i64 %t6395, %t6393
%t6397 = icmp slt i64 6480981068601479193, 0
%t6398 = or i1 %t6396, %t6397
%t6399 = zext i1 %t6398 to i8
call void @resid_conv_check(i8 %t6399)
%t6400 = add i128 10538285296894168987, 0
%t6401 = trunc i128 %t6400 to i64
%t6402 = zext i64 %t6401 to i128
%t6403 = icmp ne i128 %t6402, %t6400
%t6404 = icmp slt i128 10538285296894168987, 0
%t6405 = or i1 %t6403, %t6404
%t6406 = zext i1 %t6405 to i8
call void @resid_conv_check(i8 %t6406)
%t6407 = add i128 12329834152419229976, 0
%t6408 = trunc i128 %t6407 to i64
%t6409 = zext i64 %t6408 to i128
%t6410 = icmp ne i128 %t6409, %t6407
%t6411 = icmp slt i128 12329834152419229976, 0
%t6412 = or i1 %t6410, %t6411
%t6413 = zext i1 %t6412 to i8
call void @resid_conv_check(i8 %t6413)
%t6414 = add i128 15566598209576043074, 0
%t6415 = trunc i128 %t6414 to i64
%t6416 = zext i64 %t6415 to i128
%t6417 = icmp ne i128 %t6416, %t6414
%t6418 = icmp slt i128 15566598209576043074, 0
%t6419 = or i1 %t6417, %t6418
%t6420 = zext i1 %t6419 to i8
call void @resid_conv_check(i8 %t6420)
%t6421 = add i64 1334009975649890238, 0
%t6422 = add i64 %t6421, 0
%t6423 = add i64 %t6422, 0
%t6424 = icmp ne i64 %t6423, %t6421
%t6425 = icmp slt i64 1334009975649890238, 0
%t6426 = or i1 %t6424, %t6425
%t6427 = zext i1 %t6426 to i8
call void @resid_conv_check(i8 %t6427)
%t6428 = add i64 2608012711638119052, 0
%t6429 = add i64 %t6428, 0
%t6430 = add i64 %t6429, 0
%t6431 = icmp ne i64 %t6430, %t6428
%t6432 = icmp slt i64 2608012711638119052, 0
%t6433 = or i1 %t6431, %t6432
%t6434 = zext i1 %t6433 to i8
call void @resid_conv_check(i8 %t6434)
%t6435 = add i64 6128411473006802146, 0
%t6436 = add i64 %t6435, 0
%t6437 = add i64 %t6436, 0
%t6438 = icmp ne i64 %t6437, %t6435
%t6439 = icmp slt i64 6128411473006802146, 0
%t6440 = or i1 %t6438, %t6439
%t6441 = zext i1 %t6440 to i8
call void @resid_conv_check(i8 %t6441)
%t6442 = add i64 8268148722764581231, 0
%t6443 = add i64 %t6442, 0
%t6444 = add i64 %t6443, 0
%t6445 = icmp ne i64 %t6444, %t6442
%t6446 = icmp slt i64 8268148722764581231, 0
%t6447 = or i1 %t6445, %t6446
%t6448 = zext i1 %t6447 to i8
call void @resid_conv_check(i8 %t6448)
%t6449 = add i128 9286055187155687089, 0
%t6450 = trunc i128 %t6449 to i64
%t6451 = zext i64 %t6450 to i128
%t6452 = icmp ne i128 %t6451, %t6449
%t6453 = icmp slt i128 9286055187155687089, 0
%t6454 = or i1 %t6452, %t6453
%t6455 = zext i1 %t6454 to i8
call void @resid_conv_check(i8 %t6455)
%t6456 = add i128 11230858885718282805, 0
%t6457 = trunc i128 %t6456 to i64
%t6458 = zext i64 %t6457 to i128
%t6459 = icmp ne i128 %t6458, %t6456
%t6460 = icmp slt i128 11230858885718282805, 0
%t6461 = or i1 %t6459, %t6460
%t6462 = zext i1 %t6461 to i8
call void @resid_conv_check(i8 %t6462)
%t6463 = add i128 13951009754708518548, 0
%t6464 = trunc i128 %t6463 to i64
%t6465 = zext i64 %t6464 to i128
%t6466 = icmp ne i128 %t6465, %t6463
%t6467 = icmp slt i128 13951009754708518548, 0
%t6468 = or i1 %t6466, %t6467
%t6469 = zext i1 %t6468 to i8
call void @resid_conv_check(i8 %t6469)
%t6470 = add i128 16472876342353939154, 0
%t6471 = trunc i128 %t6470 to i64
%t6472 = zext i64 %t6471 to i128
%t6473 = icmp ne i128 %t6472, %t6470
%t6474 = icmp slt i128 16472876342353939154, 0
%t6475 = or i1 %t6473, %t6474
%t6476 = zext i1 %t6475 to i8
call void @resid_conv_check(i8 %t6476)
%t6477 = add i128 17275323862435702243, 0
%t6478 = trunc i128 %t6477 to i64
%t6479 = zext i64 %t6478 to i128
%t6480 = icmp ne i128 %t6479, %t6477
%t6481 = icmp slt i128 17275323862435702243, 0
%t6482 = or i1 %t6480, %t6481
%t6483 = zext i1 %t6482 to i8
call void @resid_conv_check(i8 %t6483)
%t6484 = add i64 1135362057144423861, 0
%t6485 = add i64 %t6484, 0
%t6486 = add i64 %t6485, 0
%t6487 = icmp ne i64 %t6486, %t6484
%t6488 = icmp slt i64 1135362057144423861, 0
%t6489 = or i1 %t6487, %t6488
%t6490 = zext i1 %t6489 to i8
call void @resid_conv_check(i8 %t6490)
%t6491 = add i64 2597628984639134821, 0
%t6492 = add i64 %t6491, 0
%t6493 = add i64 %t6492, 0
%t6494 = icmp ne i64 %t6493, %t6491
%t6495 = icmp slt i64 2597628984639134821, 0
%t6496 = or i1 %t6494, %t6495
%t6497 = zext i1 %t6496 to i8
call void @resid_conv_check(i8 %t6497)
%t6498 = add i64 3308224258029322869, 0
%t6499 = add i64 %t6498, 0
%t6500 = add i64 %t6499, 0
%t6501 = icmp ne i64 %t6500, %t6498
%t6502 = icmp slt i64 3308224258029322869, 0
%t6503 = or i1 %t6501, %t6502
%t6504 = zext i1 %t6503 to i8
call void @resid_conv_check(i8 %t6504)
%t6505 = add i64 5365058923640841347, 0
%t6506 = add i64 %t6505, 0
%t6507 = add i64 %t6506, 0
%t6508 = icmp ne i64 %t6507, %t6505
%t6509 = icmp slt i64 5365058923640841347, 0
%t6510 = or i1 %t6508, %t6509
%t6511 = zext i1 %t6510 to i8
call void @resid_conv_check(i8 %t6511)
%t6512 = add i64 6679025012923562964, 0
%t6513 = add i64 %t6512, 0
%t6514 = add i64 %t6513, 0
%t6515 = icmp ne i64 %t6514, %t6512
%t6516 = icmp slt i64 6679025012923562964, 0
%t6517 = or i1 %t6515, %t6516
%t6518 = zext i1 %t6517 to i8
call void @resid_conv_check(i8 %t6518)
%t6519 = add i64 8573033837759648693, 0
%t6520 = add i64 %t6519, 0
%t6521 = add i64 %t6520, 0
%t6522 = icmp ne i64 %t6521, %t6519
%t6523 = icmp slt i64 8573033837759648693, 0
%t6524 = or i1 %t6522, %t6523
%t6525 = zext i1 %t6524 to i8
call void @resid_conv_check(i8 %t6525)
%t6526 = add i128 10970295158949994411, 0
%t6527 = trunc i128 %t6526 to i64
%t6528 = zext i64 %t6527 to i128
%t6529 = icmp ne i128 %t6528, %t6526
%t6530 = icmp slt i128 10970295158949994411, 0
%t6531 = or i1 %t6529, %t6530
%t6532 = zext i1 %t6531 to i8
call void @resid_conv_check(i8 %t6532)
%t6533 = add i128 12119686244451234320, 0
%t6534 = trunc i128 %t6533 to i64
%t6535 = zext i64 %t6534 to i128
%t6536 = icmp ne i128 %t6535, %t6533
%t6537 = icmp slt i128 12119686244451234320, 0
%t6538 = or i1 %t6536, %t6537
%t6539 = zext i1 %t6538 to i8
call void @resid_conv_check(i8 %t6539)
%t6540 = add i128 12683024718118986047, 0
%t6541 = trunc i128 %t6540 to i64
%t6542 = zext i64 %t6541 to i128
%t6543 = icmp ne i128 %t6542, %t6540
%t6544 = icmp slt i128 12683024718118986047, 0
%t6545 = or i1 %t6543, %t6544
%t6546 = zext i1 %t6545 to i8
call void @resid_conv_check(i8 %t6546)
%t6547 = add i128 13788192230050041572, 0
%t6548 = trunc i128 %t6547 to i64
%t6549 = zext i64 %t6548 to i128
%t6550 = icmp ne i128 %t6549, %t6547
%t6551 = icmp slt i128 13788192230050041572, 0
%t6552 = or i1 %t6550, %t6551
%t6553 = zext i1 %t6552 to i8
call void @resid_conv_check(i8 %t6553)
%t6554 = add i128 14330467153632333762, 0
%t6555 = trunc i128 %t6554 to i64
%t6556 = zext i64 %t6555 to i128
%t6557 = icmp ne i128 %t6556, %t6554
%t6558 = icmp slt i128 14330467153632333762, 0
%t6559 = or i1 %t6557, %t6558
%t6560 = zext i1 %t6559 to i8
call void @resid_conv_check(i8 %t6560)
%t6561 = add i128 15395433587784984357, 0
%t6562 = trunc i128 %t6561 to i64
%t6563 = zext i64 %t6562 to i128
%t6564 = icmp ne i128 %t6563, %t6561
%t6565 = icmp slt i128 15395433587784984357, 0
%t6566 = or i1 %t6564, %t6565
%t6567 = zext i1 %t6566 to i8
call void @resid_conv_check(i8 %t6567)
%t6568 = add i64 1452737877330783856, 0
%t6569 = add i64 %t6568, 0
%t6570 = add i64 %t6569, 0
%t6571 = icmp ne i64 %t6570, %t6568
%t6572 = icmp slt i64 1452737877330783856, 0
%t6573 = or i1 %t6571, %t6572
%t6574 = zext i1 %t6573 to i8
call void @resid_conv_check(i8 %t6574)
%t6575 = add i64 2861767655752347644, 0
%t6576 = add i64 %t6575, 0
%t6577 = add i64 %t6576, 0
%t6578 = icmp ne i64 %t6577, %t6575
%t6579 = icmp slt i64 2861767655752347644, 0
%t6580 = or i1 %t6578, %t6579
%t6581 = zext i1 %t6580 to i8
call void @resid_conv_check(i8 %t6581)
%t6582 = add i64 3322285676063803686, 0
%t6583 = add i64 %t6582, 0
%t6584 = add i64 %t6583, 0
%t6585 = icmp ne i64 %t6584, %t6582
%t6586 = icmp slt i64 3322285676063803686, 0
%t6587 = or i1 %t6585, %t6586
%t6588 = zext i1 %t6587 to i8
call void @resid_conv_check(i8 %t6588)
%t6589 = add i64 5560940570517711597, 0
%t6590 = add i64 %t6589, 0
%t6591 = add i64 %t6590, 0
%t6592 = icmp ne i64 %t6591, %t6589
%t6593 = icmp slt i64 5560940570517711597, 0
%t6594 = or i1 %t6592, %t6593
%t6595 = zext i1 %t6594 to i8
call void @resid_conv_check(i8 %t6595)
%t6596 = add i64 5996557281743188959, 0
%t6597 = add i64 %t6596, 0
%t6598 = add i64 %t6597, 0
%t6599 = icmp ne i64 %t6598, %t6596
%t6600 = icmp slt i64 5996557281743188959, 0
%t6601 = or i1 %t6599, %t6600
%t6602 = zext i1 %t6601 to i8
call void @resid_conv_check(i8 %t6602)
%t6603 = add i64 7280758554555802590, 0
%t6604 = add i64 %t6603, 0
%t6605 = add i64 %t6604, 0
%t6606 = icmp ne i64 %t6605, %t6603
%t6607 = icmp slt i64 7280758554555802590, 0
%t6608 = or i1 %t6606, %t6607
%t6609 = zext i1 %t6608 to i8
call void @resid_conv_check(i8 %t6609)
%t6610 = add i64 8532644243296465576, 0
%t6611 = add i64 %t6610, 0
%t6612 = add i64 %t6611, 0
%t6613 = icmp ne i64 %t6612, %t6610
%t6614 = icmp slt i64 8532644243296465576, 0
%t6615 = or i1 %t6613, %t6614
%t6616 = zext i1 %t6615 to i8
call void @resid_conv_check(i8 %t6616)
%t6617 = add i128 9350256976987008742, 0
%t6618 = trunc i128 %t6617 to i64
%t6619 = zext i64 %t6618 to i128
%t6620 = icmp ne i128 %t6619, %t6617
%t6621 = icmp slt i128 9350256976987008742, 0
%t6622 = or i1 %t6620, %t6621
%t6623 = zext i1 %t6622 to i8
call void @resid_conv_check(i8 %t6623)
%t6624 = add i128 10552545826968843579, 0
%t6625 = trunc i128 %t6624 to i64
%t6626 = zext i64 %t6625 to i128
%t6627 = icmp ne i128 %t6626, %t6624
%t6628 = icmp slt i128 10552545826968843579, 0
%t6629 = or i1 %t6627, %t6628
%t6630 = zext i1 %t6629 to i8
call void @resid_conv_check(i8 %t6630)
%t6631 = add i128 11727347734174303076, 0
%t6632 = trunc i128 %t6631 to i64
%t6633 = zext i64 %t6632 to i128
%t6634 = icmp ne i128 %t6633, %t6631
%t6635 = icmp slt i128 11727347734174303076, 0
%t6636 = or i1 %t6634, %t6635
%t6637 = zext i1 %t6636 to i8
call void @resid_conv_check(i8 %t6637)
%t6638 = add i128 12113106623233404929, 0
%t6639 = trunc i128 %t6638 to i64
%t6640 = zext i64 %t6639 to i128
%t6641 = icmp ne i128 %t6640, %t6638
%t6642 = icmp slt i128 12113106623233404929, 0
%t6643 = or i1 %t6641, %t6642
%t6644 = zext i1 %t6643 to i8
call void @resid_conv_check(i8 %t6644)
%t6645 = add i128 14000437183269869457, 0
%t6646 = trunc i128 %t6645 to i64
%t6647 = zext i64 %t6646 to i128
%t6648 = icmp ne i128 %t6647, %t6645
%t6649 = icmp slt i128 14000437183269869457, 0
%t6650 = or i1 %t6648, %t6649
%t6651 = zext i1 %t6650 to i8
call void @resid_conv_check(i8 %t6651)
%t6652 = add i128 14369950271660146224, 0
%t6653 = trunc i128 %t6652 to i64
%t6654 = zext i64 %t6653 to i128
%t6655 = icmp ne i128 %t6654, %t6652
%t6656 = icmp slt i128 14369950271660146224, 0
%t6657 = or i1 %t6655, %t6656
%t6658 = zext i1 %t6657 to i8
call void @resid_conv_check(i8 %t6658)
%t6659 = add i128 15101387698204529176, 0
%t6660 = trunc i128 %t6659 to i64
%t6661 = zext i64 %t6660 to i128
%t6662 = icmp ne i128 %t6661, %t6659
%t6663 = icmp slt i128 15101387698204529176, 0
%t6664 = or i1 %t6662, %t6663
%t6665 = zext i1 %t6664 to i8
call void @resid_conv_check(i8 %t6665)
%t6666 = add i128 15463397548674623760, 0
%t6667 = trunc i128 %t6666 to i64
%t6668 = zext i64 %t6667 to i128
%t6669 = icmp ne i128 %t6668, %t6666
%t6670 = icmp slt i128 15463397548674623760, 0
%t6671 = or i1 %t6669, %t6670
%t6672 = zext i1 %t6671 to i8
call void @resid_conv_check(i8 %t6672)
%t6673 = add i128 17586052441742319658, 0
%t6674 = trunc i128 %t6673 to i64
%t6675 = zext i64 %t6674 to i128
%t6676 = icmp ne i128 %t6675, %t6673
%t6677 = icmp slt i128 17586052441742319658, 0
%t6678 = or i1 %t6676, %t6677
%t6679 = zext i1 %t6678 to i8
call void @resid_conv_check(i8 %t6679)
%t6680 = add i64 1182934255886127544, 0
%t6681 = add i64 %t6680, 0
%t6682 = add i64 %t6681, 0
%t6683 = icmp ne i64 %t6682, %t6680
%t6684 = icmp slt i64 1182934255886127544, 0
%t6685 = or i1 %t6683, %t6684
%t6686 = zext i1 %t6685 to i8
call void @resid_conv_check(i8 %t6686)
%t6687 = add i64 1847814050463011016, 0
%t6688 = add i64 %t6687, 0
%t6689 = add i64 %t6688, 0
%t6690 = icmp ne i64 %t6689, %t6687
%t6691 = icmp slt i64 1847814050463011016, 0
%t6692 = or i1 %t6690, %t6691
%t6693 = zext i1 %t6692 to i8
call void @resid_conv_check(i8 %t6693)
%t6694 = add i64 2177327727835720531, 0
%t6695 = add i64 %t6694, 0
%t6696 = add i64 %t6695, 0
%t6697 = icmp ne i64 %t6696, %t6694
%t6698 = icmp slt i64 2177327727835720531, 0
%t6699 = or i1 %t6697, %t6698
%t6700 = zext i1 %t6699 to i8
call void @resid_conv_check(i8 %t6700)
%t6701 = add i64 2830643537854262169, 0
%t6702 = add i64 %t6701, 0
%t6703 = add i64 %t6702, 0
%t6704 = icmp ne i64 %t6703, %t6701
%t6705 = icmp slt i64 2830643537854262169, 0
%t6706 = or i1 %t6704, %t6705
%t6707 = zext i1 %t6706 to i8
call void @resid_conv_check(i8 %t6707)
%t6708 = add i64 3796741975233480872, 0
%t6709 = add i64 %t6708, 0
%t6710 = add i64 %t6709, 0
%t6711 = icmp ne i64 %t6710, %t6708
%t6712 = icmp slt i64 3796741975233480872, 0
%t6713 = or i1 %t6711, %t6712
%t6714 = zext i1 %t6713 to i8
call void @resid_conv_check(i8 %t6714)
%t6715 = add i64 4115178125766777443, 0
%t6716 = add i64 %t6715, 0
%t6717 = add i64 %t6716, 0
%t6718 = icmp ne i64 %t6717, %t6715
%t6719 = icmp slt i64 4115178125766777443, 0
%t6720 = or i1 %t6718, %t6719
%t6721 = zext i1 %t6720 to i8
call void @resid_conv_check(i8 %t6721)
%t6722 = add i64 5681478168544905931, 0
%t6723 = add i64 %t6722, 0
%t6724 = add i64 %t6723, 0
%t6725 = icmp ne i64 %t6724, %t6722
%t6726 = icmp slt i64 5681478168544905931, 0
%t6727 = or i1 %t6725, %t6726
%t6728 = zext i1 %t6727 to i8
call void @resid_conv_check(i8 %t6728)
%t6729 = add i64 6601373596472566643, 0
%t6730 = add i64 %t6729, 0
%t6731 = add i64 %t6730, 0
%t6732 = icmp ne i64 %t6731, %t6729
%t6733 = icmp slt i64 6601373596472566643, 0
%t6734 = or i1 %t6732, %t6733
%t6735 = zext i1 %t6734 to i8
call void @resid_conv_check(i8 %t6735)
%t6736 = add i64 7507060721942968483, 0
%t6737 = add i64 %t6736, 0
%t6738 = add i64 %t6737, 0
%t6739 = icmp ne i64 %t6738, %t6736
%t6740 = icmp slt i64 7507060721942968483, 0
%t6741 = or i1 %t6739, %t6740
%t6742 = zext i1 %t6741 to i8
call void @resid_conv_check(i8 %t6742)
%t6743 = add i64 8399075790359081724, 0
%t6744 = add i64 %t6743, 0
%t6745 = add i64 %t6744, 0
%t6746 = icmp ne i64 %t6745, %t6743
%t6747 = icmp slt i64 8399075790359081724, 0
%t6748 = or i1 %t6746, %t6747
%t6749 = zext i1 %t6748 to i8
call void @resid_conv_check(i8 %t6749)
%t6750 = add i64 8693463985226723168, 0
%t6751 = add i64 %t6750, 0
%t6752 = add i64 %t6751, 0
%t6753 = icmp ne i64 %t6752, %t6750
%t6754 = icmp slt i64 8693463985226723168, 0
%t6755 = or i1 %t6753, %t6754
%t6756 = zext i1 %t6755 to i8
call void @resid_conv_check(i8 %t6756)
%t6757 = add i128 9568029438360202098, 0
%t6758 = trunc i128 %t6757 to i64
%t6759 = zext i64 %t6758 to i128
%t6760 = icmp ne i128 %t6759, %t6757
%t6761 = icmp slt i128 9568029438360202098, 0
%t6762 = or i1 %t6760, %t6761
%t6763 = zext i1 %t6762 to i8
call void @resid_conv_check(i8 %t6763)
%t6764 = add i128 10144078919501101548, 0
%t6765 = trunc i128 %t6764 to i64
%t6766 = zext i64 %t6765 to i128
%t6767 = icmp ne i128 %t6766, %t6764
%t6768 = icmp slt i128 10144078919501101548, 0
%t6769 = or i1 %t6767, %t6768
%t6770 = zext i1 %t6769 to i8
call void @resid_conv_check(i8 %t6770)
%t6771 = add i128 10430055236837252648, 0
%t6772 = trunc i128 %t6771 to i64
%t6773 = zext i64 %t6772 to i128
%t6774 = icmp ne i128 %t6773, %t6771
%t6775 = icmp slt i128 10430055236837252648, 0
%t6776 = or i1 %t6774, %t6775
%t6777 = zext i1 %t6776 to i8
call void @resid_conv_check(i8 %t6777)
%t6778 = add i128 11840083180663258601, 0
%t6779 = trunc i128 %t6778 to i64
%t6780 = zext i64 %t6779 to i128
%t6781 = icmp ne i128 %t6780, %t6778
%t6782 = icmp slt i128 11840083180663258601, 0
%t6783 = or i1 %t6781, %t6782
%t6784 = zext i1 %t6783 to i8
call void @resid_conv_check(i8 %t6784)
%t6785 = add i128 13761210420658862357, 0
%t6786 = trunc i128 %t6785 to i64
%t6787 = zext i64 %t6786 to i128
%t6788 = icmp ne i128 %t6787, %t6785
%t6789 = icmp slt i128 13761210420658862357, 0
%t6790 = or i1 %t6788, %t6789
%t6791 = zext i1 %t6790 to i8
call void @resid_conv_check(i8 %t6791)
%t6792 = add i128 14299343276471374635, 0
%t6793 = trunc i128 %t6792 to i64
%t6794 = zext i64 %t6793 to i128
%t6795 = icmp ne i128 %t6794, %t6792
%t6796 = icmp slt i128 14299343276471374635, 0
%t6797 = or i1 %t6795, %t6796
%t6798 = zext i1 %t6797 to i8
call void @resid_conv_check(i8 %t6798)
%t6799 = add i128 14566680578165727644, 0
%t6800 = trunc i128 %t6799 to i64
%t6801 = zext i64 %t6800 to i128
%t6802 = icmp ne i128 %t6801, %t6799
%t6803 = icmp slt i128 14566680578165727644, 0
%t6804 = or i1 %t6802, %t6803
%t6805 = zext i1 %t6804 to i8
call void @resid_conv_check(i8 %t6805)
%t6806 = add i128 15097957966210449927, 0
%t6807 = trunc i128 %t6806 to i64
%t6808 = zext i64 %t6807 to i128
%t6809 = icmp ne i128 %t6808, %t6806
%t6810 = icmp slt i128 15097957966210449927, 0
%t6811 = or i1 %t6809, %t6810
%t6812 = zext i1 %t6811 to i8
call void @resid_conv_check(i8 %t6812)
%t6813 = add i128 16922976911328602910, 0
%t6814 = trunc i128 %t6813 to i64
%t6815 = zext i64 %t6814 to i128
%t6816 = icmp ne i128 %t6815, %t6813
%t6817 = icmp slt i128 16922976911328602910, 0
%t6818 = or i1 %t6816, %t6817
%t6819 = zext i1 %t6818 to i8
call void @resid_conv_check(i8 %t6819)
%t6820 = add i128 17689382322260857208, 0
%t6821 = trunc i128 %t6820 to i64
%t6822 = zext i64 %t6821 to i128
%t6823 = icmp ne i128 %t6822, %t6820
%t6824 = icmp slt i128 17689382322260857208, 0
%t6825 = or i1 %t6823, %t6824
%t6826 = zext i1 %t6825 to i8
call void @resid_conv_check(i8 %t6826)
%t6827 = add i64 1242879168328830382, 0
%t6828 = add i64 %t6827, 0
%t6829 = add i64 %t6828, 0
%t6830 = icmp ne i64 %t6829, %t6827
%t6831 = icmp slt i64 1242879168328830382, 0
%t6832 = or i1 %t6830, %t6831
%t6833 = zext i1 %t6832 to i8
call void @resid_conv_check(i8 %t6833)
%t6834 = add i64 1977374033974150939, 0
%t6835 = add i64 %t6834, 0
%t6836 = add i64 %t6835, 0
%t6837 = icmp ne i64 %t6836, %t6834
%t6838 = icmp slt i64 1977374033974150939, 0
%t6839 = or i1 %t6837, %t6838
%t6840 = zext i1 %t6839 to i8
call void @resid_conv_check(i8 %t6840)
%t6841 = add i64 2944078676154940804, 0
%t6842 = add i64 %t6841, 0
%t6843 = add i64 %t6842, 0
%t6844 = icmp ne i64 %t6843, %t6841
%t6845 = icmp slt i64 2944078676154940804, 0
%t6846 = or i1 %t6844, %t6845
%t6847 = zext i1 %t6846 to i8
call void @resid_conv_check(i8 %t6847)
%t6848 = add i64 3659926193048069267, 0
%t6849 = add i64 %t6848, 0
%t6850 = add i64 %t6849, 0
%t6851 = icmp ne i64 %t6850, %t6848
%t6852 = icmp slt i64 3659926193048069267, 0
%t6853 = or i1 %t6851, %t6852
%t6854 = zext i1 %t6853 to i8
call void @resid_conv_check(i8 %t6854)
%t6855 = add i64 4368137639120453308, 0
%t6856 = add i64 %t6855, 0
%t6857 = add i64 %t6856, 0
%t6858 = icmp ne i64 %t6857, %t6855
%t6859 = icmp slt i64 4368137639120453308, 0
%t6860 = or i1 %t6858, %t6859
%t6861 = zext i1 %t6860 to i8
call void @resid_conv_check(i8 %t6861)
%t6862 = add i64 4836135668995329356, 0
%t6863 = add i64 %t6862, 0
%t6864 = add i64 %t6863, 0
%t6865 = icmp ne i64 %t6864, %t6862
%t6866 = icmp slt i64 4836135668995329356, 0
%t6867 = or i1 %t6865, %t6866
%t6868 = zext i1 %t6867 to i8
call void @resid_conv_check(i8 %t6868)
%t6869 = add i64 5532061633213252278, 0
%t6870 = add i64 %t6869, 0
%t6871 = add i64 %t6870, 0
%t6872 = icmp ne i64 %t6871, %t6869
%t6873 = icmp slt i64 5532061633213252278, 0
%t6874 = or i1 %t6872, %t6873
%t6875 = zext i1 %t6874 to i8
call void @resid_conv_check(i8 %t6875)
%t6876 = add i64 6448918945643986474, 0
%t6877 = add i64 %t6876, 0
%t6878 = add i64 %t6877, 0
%t6879 = icmp ne i64 %t6878, %t6876
%t6880 = icmp slt i64 6448918945643986474, 0
%t6881 = or i1 %t6879, %t6880
%t6882 = zext i1 %t6881 to i8
call void @resid_conv_check(i8 %t6882)
%t6883 = add i64 6902733635092675308, 0
%t6884 = add i64 %t6883, 0
%t6885 = add i64 %t6884, 0
%t6886 = icmp ne i64 %t6885, %t6883
%t6887 = icmp slt i64 6902733635092675308, 0
%t6888 = or i1 %t6886, %t6887
%t6889 = zext i1 %t6888 to i8
call void @resid_conv_check(i8 %t6889)
%t6890 = add i64 7801388544844847127, 0
%t6891 = add i64 %t6890, 0
%t6892 = add i64 %t6891, 0
%t6893 = icmp ne i64 %t6892, %t6890
%t6894 = icmp slt i64 7801388544844847127, 0
%t6895 = or i1 %t6893, %t6894
%t6896 = zext i1 %t6895 to i8
call void @resid_conv_check(i8 %t6896)
%t6897 = alloca [80 x ptr]
%t6899 = call ptr @resid_box_i64(i64 %t6359)
%t6901 = getelementptr i8, ptr %t6897, i64 0
store ptr %t6899, ptr %t6901
%t6902 = call ptr @resid_box_i64(i64 %t6366)
%t6904 = getelementptr i8, ptr %t6897, i64 8
store ptr %t6902, ptr %t6904
%t6905 = call ptr @resid_box_i64(i64 %t6373)
%t6907 = getelementptr i8, ptr %t6897, i64 16
store ptr %t6905, ptr %t6907
%t6908 = call ptr @resid_box_i64(i64 %t6380)
%t6910 = getelementptr i8, ptr %t6897, i64 24
store ptr %t6908, ptr %t6910
%t6911 = call ptr @resid_box_i64(i64 %t6387)
%t6913 = getelementptr i8, ptr %t6897, i64 32
store ptr %t6911, ptr %t6913
%t6914 = call ptr @resid_box_i64(i64 %t6394)
%t6916 = getelementptr i8, ptr %t6897, i64 40
store ptr %t6914, ptr %t6916
%t6917 = call ptr @resid_box_i64(i64 %t6401)
%t6919 = getelementptr i8, ptr %t6897, i64 48
store ptr %t6917, ptr %t6919
%t6920 = call ptr @resid_box_i64(i64 %t6408)
%t6922 = getelementptr i8, ptr %t6897, i64 56
store ptr %t6920, ptr %t6922
%t6923 = call ptr @resid_box_i64(i64 %t6415)
%t6925 = getelementptr i8, ptr %t6897, i64 64
store ptr %t6923, ptr %t6925
%t6926 = call ptr @resid_box_i64(i64 %t6422)
%t6928 = getelementptr i8, ptr %t6897, i64 72
store ptr %t6926, ptr %t6928
%t6929 = call ptr @resid_box_i64(i64 %t6429)
%t6931 = getelementptr i8, ptr %t6897, i64 80
store ptr %t6929, ptr %t6931
%t6932 = call ptr @resid_box_i64(i64 %t6436)
%t6934 = getelementptr i8, ptr %t6897, i64 88
store ptr %t6932, ptr %t6934
%t6935 = call ptr @resid_box_i64(i64 %t6443)
%t6937 = getelementptr i8, ptr %t6897, i64 96
store ptr %t6935, ptr %t6937
%t6938 = call ptr @resid_box_i64(i64 %t6450)
%t6940 = getelementptr i8, ptr %t6897, i64 104
store ptr %t6938, ptr %t6940
%t6941 = call ptr @resid_box_i64(i64 %t6457)
%t6943 = getelementptr i8, ptr %t6897, i64 112
store ptr %t6941, ptr %t6943
%t6944 = call ptr @resid_box_i64(i64 %t6464)
%t6946 = getelementptr i8, ptr %t6897, i64 120
store ptr %t6944, ptr %t6946
%t6947 = call ptr @resid_box_i64(i64 %t6471)
%t6949 = getelementptr i8, ptr %t6897, i64 128
store ptr %t6947, ptr %t6949
%t6950 = call ptr @resid_box_i64(i64 %t6478)
%t6952 = getelementptr i8, ptr %t6897, i64 136
store ptr %t6950, ptr %t6952
%t6953 = call ptr @resid_box_i64(i64 %t6485)
%t6955 = getelementptr i8, ptr %t6897, i64 144
store ptr %t6953, ptr %t6955
%t6956 = call ptr @resid_box_i64(i64 %t6492)
%t6958 = getelementptr i8, ptr %t6897, i64 152
store ptr %t6956, ptr %t6958
%t6959 = call ptr @resid_box_i64(i64 %t6499)
%t6961 = getelementptr i8, ptr %t6897, i64 160
store ptr %t6959, ptr %t6961
%t6962 = call ptr @resid_box_i64(i64 %t6506)
%t6964 = getelementptr i8, ptr %t6897, i64 168
store ptr %t6962, ptr %t6964
%t6965 = call ptr @resid_box_i64(i64 %t6513)
%t6967 = getelementptr i8, ptr %t6897, i64 176
store ptr %t6965, ptr %t6967
%t6968 = call ptr @resid_box_i64(i64 %t6520)
%t6970 = getelementptr i8, ptr %t6897, i64 184
store ptr %t6968, ptr %t6970
%t6971 = call ptr @resid_box_i64(i64 %t6527)
%t6973 = getelementptr i8, ptr %t6897, i64 192
store ptr %t6971, ptr %t6973
%t6974 = call ptr @resid_box_i64(i64 %t6534)
%t6976 = getelementptr i8, ptr %t6897, i64 200
store ptr %t6974, ptr %t6976
%t6977 = call ptr @resid_box_i64(i64 %t6541)
%t6979 = getelementptr i8, ptr %t6897, i64 208
store ptr %t6977, ptr %t6979
%t6980 = call ptr @resid_box_i64(i64 %t6548)
%t6982 = getelementptr i8, ptr %t6897, i64 216
store ptr %t6980, ptr %t6982
%t6983 = call ptr @resid_box_i64(i64 %t6555)
%t6985 = getelementptr i8, ptr %t6897, i64 224
store ptr %t6983, ptr %t6985
%t6986 = call ptr @resid_box_i64(i64 %t6562)
%t6988 = getelementptr i8, ptr %t6897, i64 232
store ptr %t6986, ptr %t6988
%t6989 = call ptr @resid_box_i64(i64 489312712824947311)
%t6991 = getelementptr i8, ptr %t6897, i64 240
store ptr %t6989, ptr %t6991
%t6992 = call ptr @resid_box_i64(i64 %t6569)
%t6994 = getelementptr i8, ptr %t6897, i64 248
store ptr %t6992, ptr %t6994
%t6995 = call ptr @resid_box_i64(i64 %t6576)
%t6997 = getelementptr i8, ptr %t6897, i64 256
store ptr %t6995, ptr %t6997
%t6998 = call ptr @resid_box_i64(i64 %t6583)
%t7000 = getelementptr i8, ptr %t6897, i64 264
store ptr %t6998, ptr %t7000
%t7001 = call ptr @resid_box_i64(i64 %t6590)
%t7003 = getelementptr i8, ptr %t6897, i64 272
store ptr %t7001, ptr %t7003
%t7004 = call ptr @resid_box_i64(i64 %t6597)
%t7006 = getelementptr i8, ptr %t6897, i64 280
store ptr %t7004, ptr %t7006
%t7007 = call ptr @resid_box_i64(i64 %t6604)
%t7009 = getelementptr i8, ptr %t6897, i64 288
store ptr %t7007, ptr %t7009
%t7010 = call ptr @resid_box_i64(i64 %t6611)
%t7012 = getelementptr i8, ptr %t6897, i64 296
store ptr %t7010, ptr %t7012
%t7013 = call ptr @resid_box_i64(i64 %t6618)
%t7015 = getelementptr i8, ptr %t6897, i64 304
store ptr %t7013, ptr %t7015
%t7016 = call ptr @resid_box_i64(i64 %t6625)
%t7018 = getelementptr i8, ptr %t6897, i64 312
store ptr %t7016, ptr %t7018
%t7019 = call ptr @resid_box_i64(i64 %t6632)
%t7021 = getelementptr i8, ptr %t6897, i64 320
store ptr %t7019, ptr %t7021
%t7022 = call ptr @resid_box_i64(i64 %t6639)
%t7024 = getelementptr i8, ptr %t6897, i64 328
store ptr %t7022, ptr %t7024
%t7025 = call ptr @resid_box_i64(i64 %t6646)
%t7027 = getelementptr i8, ptr %t6897, i64 336
store ptr %t7025, ptr %t7027
%t7028 = call ptr @resid_box_i64(i64 %t6653)
%t7030 = getelementptr i8, ptr %t6897, i64 344
store ptr %t7028, ptr %t7030
%t7031 = call ptr @resid_box_i64(i64 %t6660)
%t7033 = getelementptr i8, ptr %t6897, i64 352
store ptr %t7031, ptr %t7033
%t7034 = call ptr @resid_box_i64(i64 %t6667)
%t7036 = getelementptr i8, ptr %t6897, i64 360
store ptr %t7034, ptr %t7036
%t7037 = call ptr @resid_box_i64(i64 %t6674)
%t7039 = getelementptr i8, ptr %t6897, i64 368
store ptr %t7037, ptr %t7039
%t7040 = call ptr @resid_box_i64(i64 %t6681)
%t7042 = getelementptr i8, ptr %t6897, i64 376
store ptr %t7040, ptr %t7042
%t7043 = call ptr @resid_box_i64(i64 %t6688)
%t7045 = getelementptr i8, ptr %t6897, i64 384
store ptr %t7043, ptr %t7045
%t7046 = call ptr @resid_box_i64(i64 %t6695)
%t7048 = getelementptr i8, ptr %t6897, i64 392
store ptr %t7046, ptr %t7048
%t7049 = call ptr @resid_box_i64(i64 %t6702)
%t7051 = getelementptr i8, ptr %t6897, i64 400
store ptr %t7049, ptr %t7051
%t7052 = call ptr @resid_box_i64(i64 %t6709)
%t7054 = getelementptr i8, ptr %t6897, i64 408
store ptr %t7052, ptr %t7054
%t7055 = call ptr @resid_box_i64(i64 %t6716)
%t7057 = getelementptr i8, ptr %t6897, i64 416
store ptr %t7055, ptr %t7057
%t7058 = call ptr @resid_box_i64(i64 %t6723)
%t7060 = getelementptr i8, ptr %t6897, i64 424
store ptr %t7058, ptr %t7060
%t7061 = call ptr @resid_box_i64(i64 %t6730)
%t7063 = getelementptr i8, ptr %t6897, i64 432
store ptr %t7061, ptr %t7063
%t7064 = call ptr @resid_box_i64(i64 %t6737)
%t7066 = getelementptr i8, ptr %t6897, i64 440
store ptr %t7064, ptr %t7066
%t7067 = call ptr @resid_box_i64(i64 %t6744)
%t7069 = getelementptr i8, ptr %t6897, i64 448
store ptr %t7067, ptr %t7069
%t7070 = call ptr @resid_box_i64(i64 %t6751)
%t7072 = getelementptr i8, ptr %t6897, i64 456
store ptr %t7070, ptr %t7072
%t7073 = call ptr @resid_box_i64(i64 %t6758)
%t7075 = getelementptr i8, ptr %t6897, i64 464
store ptr %t7073, ptr %t7075
%t7076 = call ptr @resid_box_i64(i64 %t6765)
%t7078 = getelementptr i8, ptr %t6897, i64 472
store ptr %t7076, ptr %t7078
%t7079 = call ptr @resid_box_i64(i64 %t6772)
%t7081 = getelementptr i8, ptr %t6897, i64 480
store ptr %t7079, ptr %t7081
%t7082 = call ptr @resid_box_i64(i64 %t6779)
%t7084 = getelementptr i8, ptr %t6897, i64 488
store ptr %t7082, ptr %t7084
%t7085 = call ptr @resid_box_i64(i64 %t6786)
%t7087 = getelementptr i8, ptr %t6897, i64 496
store ptr %t7085, ptr %t7087
%t7088 = call ptr @resid_box_i64(i64 %t6793)
%t7090 = getelementptr i8, ptr %t6897, i64 504
store ptr %t7088, ptr %t7090
%t7091 = call ptr @resid_box_i64(i64 %t6800)
%t7093 = getelementptr i8, ptr %t6897, i64 512
store ptr %t7091, ptr %t7093
%t7094 = call ptr @resid_box_i64(i64 %t6807)
%t7096 = getelementptr i8, ptr %t6897, i64 520
store ptr %t7094, ptr %t7096
%t7097 = call ptr @resid_box_i64(i64 %t6814)
%t7099 = getelementptr i8, ptr %t6897, i64 528
store ptr %t7097, ptr %t7099
%t7100 = call ptr @resid_box_i64(i64 %t6821)
%t7102 = getelementptr i8, ptr %t6897, i64 536
store ptr %t7100, ptr %t7102
%t7103 = call ptr @resid_box_i64(i64 500013540394364858)
%t7105 = getelementptr i8, ptr %t6897, i64 544
store ptr %t7103, ptr %t7105
%t7106 = call ptr @resid_box_i64(i64 748580250866718886)
%t7108 = getelementptr i8, ptr %t6897, i64 552
store ptr %t7106, ptr %t7108
%t7109 = call ptr @resid_box_i64(i64 %t6828)
%t7111 = getelementptr i8, ptr %t6897, i64 560
store ptr %t7109, ptr %t7111
%t7112 = call ptr @resid_box_i64(i64 %t6835)
%t7114 = getelementptr i8, ptr %t6897, i64 568
store ptr %t7112, ptr %t7114
%t7115 = call ptr @resid_box_i64(i64 %t6842)
%t7117 = getelementptr i8, ptr %t6897, i64 576
store ptr %t7115, ptr %t7117
%t7118 = call ptr @resid_box_i64(i64 %t6849)
%t7120 = getelementptr i8, ptr %t6897, i64 584
store ptr %t7118, ptr %t7120
%t7121 = call ptr @resid_box_i64(i64 %t6856)
%t7123 = getelementptr i8, ptr %t6897, i64 592
store ptr %t7121, ptr %t7123
%t7124 = call ptr @resid_box_i64(i64 %t6863)
%t7126 = getelementptr i8, ptr %t6897, i64 600
store ptr %t7124, ptr %t7126
%t7127 = call ptr @resid_box_i64(i64 %t6870)
%t7129 = getelementptr i8, ptr %t6897, i64 608
store ptr %t7127, ptr %t7129
%t7130 = call ptr @resid_box_i64(i64 %t6877)
%t7132 = getelementptr i8, ptr %t6897, i64 616
store ptr %t7130, ptr %t7132
%t7133 = call ptr @resid_box_i64(i64 %t6884)
%t7135 = getelementptr i8, ptr %t6897, i64 624
store ptr %t7133, ptr %t7135
%t7136 = call ptr @resid_box_i64(i64 %t6891)
%t7138 = getelementptr i8, ptr %t6897, i64 632
store ptr %t7136, ptr %t7138
%t7139 = call ptr @resid_list_new(i64 80, ptr %t6897, ptr @.lty6897)
ret ptr %t7139
}
define ptr @sha512g_iv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7140 = add i64 7640891576956012808, 0
%t7141 = add i64 %t7140, 0
%t7142 = add i64 %t7141, 0
%t7143 = icmp ne i64 %t7142, %t7140
%t7144 = icmp slt i64 7640891576956012808, 0
%t7145 = or i1 %t7143, %t7144
%t7146 = zext i1 %t7145 to i8
call void @resid_conv_check(i8 %t7146)
%t7147 = add i128 13503953896175478587, 0
%t7148 = trunc i128 %t7147 to i64
%t7149 = zext i64 %t7148 to i128
%t7150 = icmp ne i128 %t7149, %t7147
%t7151 = icmp slt i128 13503953896175478587, 0
%t7152 = or i1 %t7150, %t7151
%t7153 = zext i1 %t7152 to i8
call void @resid_conv_check(i8 %t7153)
%t7154 = add i64 4354685564936845355, 0
%t7155 = add i64 %t7154, 0
%t7156 = add i64 %t7155, 0
%t7157 = icmp ne i64 %t7156, %t7154
%t7158 = icmp slt i64 4354685564936845355, 0
%t7159 = or i1 %t7157, %t7158
%t7160 = zext i1 %t7159 to i8
call void @resid_conv_check(i8 %t7160)
%t7161 = add i128 11912009170470909681, 0
%t7162 = trunc i128 %t7161 to i64
%t7163 = zext i64 %t7162 to i128
%t7164 = icmp ne i128 %t7163, %t7161
%t7165 = icmp slt i128 11912009170470909681, 0
%t7166 = or i1 %t7164, %t7165
%t7167 = zext i1 %t7166 to i8
call void @resid_conv_check(i8 %t7167)
%t7168 = add i64 5840696475078001361, 0
%t7169 = add i64 %t7168, 0
%t7170 = add i64 %t7169, 0
%t7171 = icmp ne i64 %t7170, %t7168
%t7172 = icmp slt i64 5840696475078001361, 0
%t7173 = or i1 %t7171, %t7172
%t7174 = zext i1 %t7173 to i8
call void @resid_conv_check(i8 %t7174)
%t7175 = add i128 11170449401992604703, 0
%t7176 = trunc i128 %t7175 to i64
%t7177 = zext i64 %t7176 to i128
%t7178 = icmp ne i128 %t7177, %t7175
%t7179 = icmp slt i128 11170449401992604703, 0
%t7180 = or i1 %t7178, %t7179
%t7181 = zext i1 %t7180 to i8
call void @resid_conv_check(i8 %t7181)
%t7182 = add i64 2270897969802886507, 0
%t7183 = add i64 %t7182, 0
%t7184 = add i64 %t7183, 0
%t7185 = icmp ne i64 %t7184, %t7182
%t7186 = icmp slt i64 2270897969802886507, 0
%t7187 = or i1 %t7185, %t7186
%t7188 = zext i1 %t7187 to i8
call void @resid_conv_check(i8 %t7188)
%t7189 = add i64 6620516959819538809, 0
%t7190 = add i64 %t7189, 0
%t7191 = add i64 %t7190, 0
%t7192 = icmp ne i64 %t7191, %t7189
%t7193 = icmp slt i64 6620516959819538809, 0
%t7194 = or i1 %t7192, %t7193
%t7195 = zext i1 %t7194 to i8
call void @resid_conv_check(i8 %t7195)
%t7196 = alloca [8 x ptr]
%t7198 = call ptr @resid_box_i64(i64 %t7141)
%t7200 = getelementptr i8, ptr %t7196, i64 0
store ptr %t7198, ptr %t7200
%t7201 = call ptr @resid_box_i64(i64 %t7148)
%t7203 = getelementptr i8, ptr %t7196, i64 8
store ptr %t7201, ptr %t7203
%t7204 = call ptr @resid_box_i64(i64 %t7155)
%t7206 = getelementptr i8, ptr %t7196, i64 16
store ptr %t7204, ptr %t7206
%t7207 = call ptr @resid_box_i64(i64 %t7162)
%t7209 = getelementptr i8, ptr %t7196, i64 24
store ptr %t7207, ptr %t7209
%t7210 = call ptr @resid_box_i64(i64 %t7169)
%t7212 = getelementptr i8, ptr %t7196, i64 32
store ptr %t7210, ptr %t7212
%t7213 = call ptr @resid_box_i64(i64 %t7176)
%t7215 = getelementptr i8, ptr %t7196, i64 40
store ptr %t7213, ptr %t7215
%t7216 = call ptr @resid_box_i64(i64 %t7183)
%t7218 = getelementptr i8, ptr %t7196, i64 48
store ptr %t7216, ptr %t7218
%t7219 = call ptr @resid_box_i64(i64 %t7190)
%t7221 = getelementptr i8, ptr %t7196, i64 56
store ptr %t7219, ptr %t7221
%t7222 = call ptr @resid_list_new(i64 8, ptr %t7196, ptr @.lty7196)
ret ptr %t7222
}
define ptr @sha384g_iv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7223 = add i128 14680500436340154072, 0
%t7224 = trunc i128 %t7223 to i64
%t7225 = zext i64 %t7224 to i128
%t7226 = icmp ne i128 %t7225, %t7223
%t7227 = icmp slt i128 14680500436340154072, 0
%t7228 = or i1 %t7226, %t7227
%t7229 = zext i1 %t7228 to i8
call void @resid_conv_check(i8 %t7229)
%t7230 = add i64 7105036623409894663, 0
%t7231 = add i64 %t7230, 0
%t7232 = add i64 %t7231, 0
%t7233 = icmp ne i64 %t7232, %t7230
%t7234 = icmp slt i64 7105036623409894663, 0
%t7235 = or i1 %t7233, %t7234
%t7236 = zext i1 %t7235 to i8
call void @resid_conv_check(i8 %t7236)
%t7237 = add i128 10473403895298186519, 0
%t7238 = trunc i128 %t7237 to i64
%t7239 = zext i64 %t7238 to i128
%t7240 = icmp ne i128 %t7239, %t7237
%t7241 = icmp slt i128 10473403895298186519, 0
%t7242 = or i1 %t7240, %t7241
%t7243 = zext i1 %t7242 to i8
call void @resid_conv_check(i8 %t7243)
%t7244 = add i64 1526699215303891257, 0
%t7245 = add i64 %t7244, 0
%t7246 = add i64 %t7245, 0
%t7247 = icmp ne i64 %t7246, %t7244
%t7248 = icmp slt i64 1526699215303891257, 0
%t7249 = or i1 %t7247, %t7248
%t7250 = zext i1 %t7249 to i8
call void @resid_conv_check(i8 %t7250)
%t7251 = add i64 7436329637833083697, 0
%t7252 = add i64 %t7251, 0
%t7253 = add i64 %t7252, 0
%t7254 = icmp ne i64 %t7253, %t7251
%t7255 = icmp slt i64 7436329637833083697, 0
%t7256 = or i1 %t7254, %t7255
%t7257 = zext i1 %t7256 to i8
call void @resid_conv_check(i8 %t7257)
%t7258 = add i128 10282925794625328401, 0
%t7259 = trunc i128 %t7258 to i64
%t7260 = zext i64 %t7259 to i128
%t7261 = icmp ne i128 %t7260, %t7258
%t7262 = icmp slt i128 10282925794625328401, 0
%t7263 = or i1 %t7261, %t7262
%t7264 = zext i1 %t7263 to i8
call void @resid_conv_check(i8 %t7264)
%t7265 = add i128 15784041429090275239, 0
%t7266 = trunc i128 %t7265 to i64
%t7267 = zext i64 %t7266 to i128
%t7268 = icmp ne i128 %t7267, %t7265
%t7269 = icmp slt i128 15784041429090275239, 0
%t7270 = or i1 %t7268, %t7269
%t7271 = zext i1 %t7270 to i8
call void @resid_conv_check(i8 %t7271)
%t7272 = add i64 5167115440072839076, 0
%t7273 = add i64 %t7272, 0
%t7274 = add i64 %t7273, 0
%t7275 = icmp ne i64 %t7274, %t7272
%t7276 = icmp slt i64 5167115440072839076, 0
%t7277 = or i1 %t7275, %t7276
%t7278 = zext i1 %t7277 to i8
call void @resid_conv_check(i8 %t7278)
%t7279 = alloca [8 x ptr]
%t7281 = call ptr @resid_box_i64(i64 %t7224)
%t7283 = getelementptr i8, ptr %t7279, i64 0
store ptr %t7281, ptr %t7283
%t7284 = call ptr @resid_box_i64(i64 %t7231)
%t7286 = getelementptr i8, ptr %t7279, i64 8
store ptr %t7284, ptr %t7286
%t7287 = call ptr @resid_box_i64(i64 %t7238)
%t7289 = getelementptr i8, ptr %t7279, i64 16
store ptr %t7287, ptr %t7289
%t7290 = call ptr @resid_box_i64(i64 %t7245)
%t7292 = getelementptr i8, ptr %t7279, i64 24
store ptr %t7290, ptr %t7292
%t7293 = call ptr @resid_box_i64(i64 %t7252)
%t7295 = getelementptr i8, ptr %t7279, i64 32
store ptr %t7293, ptr %t7295
%t7296 = call ptr @resid_box_i64(i64 %t7259)
%t7298 = getelementptr i8, ptr %t7279, i64 40
store ptr %t7296, ptr %t7298
%t7299 = call ptr @resid_box_i64(i64 %t7266)
%t7301 = getelementptr i8, ptr %t7279, i64 48
store ptr %t7299, ptr %t7301
%t7302 = call ptr @resid_box_i64(i64 %t7273)
%t7304 = getelementptr i8, ptr %t7279, i64 56
store ptr %t7302, ptr %t7304
%t7305 = call ptr @resid_list_new(i64 8, ptr %t7279, ptr @.lty7279)
ret ptr %t7305
}
define ptr @sha512g_pad(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7306 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p0, i64 17)
%t7307 = extractvalue {i64, i1} %t7306, 0
%t7308 = extractvalue {i64, i1} %t7306, 1
%t7309 = zext i1 %t7308 to i8
call void @resid_overflow_check(i8 %t7309)
%t7310 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7307, i64 127)
%t7311 = extractvalue {i64, i1} %t7310, 0
%t7312 = extractvalue {i64, i1} %t7310, 1
%t7313 = zext i1 %t7312 to i8
call void @resid_overflow_check(i8 %t7313)
%t7314 = sdiv i64 %t7311, 128
%t7315 = mul nsw i64 %t7314, 128
%t7316 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7315, i64 %p0)
%t7317 = extractvalue {i64, i1} %t7316, 0
%t7318 = extractvalue {i64, i1} %t7316, 1
%t7319 = zext i1 %t7318 to i8
call void @resid_overflow_check(i8 %t7319)
%t7320 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7317, i64 17)
%t7321 = extractvalue {i64, i1} %t7320, 0
%t7322 = extractvalue {i64, i1} %t7320, 1
%t7323 = zext i1 %t7322 to i8
call void @resid_overflow_check(i8 %t7323)
%t7324 = call ptr @resid_listbuf_new()
%t7325 = call ptr @__m____________lib_sha512g_resid__sha512g_pad_at(i64 %p0, i64 %t7321, i64 0, ptr %t7324)
%t7326 = call ptr @resid_listbuf_finish(ptr %t7325, ptr @.lty7326)
ret ptr %t7326
}
define ptr @__m____________lib_sha512g_resid__sha512g_pad_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ], [ %p0, %tco.s2 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ], [ %p1, %tco.s2 ]
%p2 = phi i64 [ %p2.in, %entry ], [ 1, %tco.s0 ], [ %t7339, %tco.s1 ], [ %t7365, %tco.s2 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t7331, %tco.s0 ], [ %t7345, %tco.s1 ], [ %t7382, %tco.s2 ]
%t7327 = icmp eq i64 %p2, 0
br i1 %t7327, label %L778, label %L780
L778:
%t7328 = call ptr @resid_box_i64(i64 128)
%t7331 = call ptr @resid_listbuf_push(ptr %p3, ptr %t7328)
br label %tco.s0
tco.s0:
br label %tco.head
L780:
%t7333 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 8)
%t7334 = extractvalue {i64, i1} %t7333, 0
%t7335 = extractvalue {i64, i1} %t7333, 1
%t7336 = zext i1 %t7335 to i8
call void @resid_overflow_check(i8 %t7336)
%t7337 = icmp sle i64 %p2, %t7334
br i1 %t7337, label %L781, label %L783
L781:
%t7338 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t7339 = extractvalue {i64, i1} %t7338, 0
%t7340 = extractvalue {i64, i1} %t7338, 1
%t7341 = zext i1 %t7340 to i8
call void @resid_overflow_check(i8 %t7341)
%t7342 = call ptr @resid_box_i64(i64 0)
%t7345 = call ptr @resid_listbuf_push(ptr %p3, ptr %t7342)
br label %tco.s1
tco.s1:
br label %tco.head
L783:
%t7347 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 16)
%t7348 = extractvalue {i64, i1} %t7347, 0
%t7349 = extractvalue {i64, i1} %t7347, 1
%t7350 = zext i1 %t7349 to i8
call void @resid_overflow_check(i8 %t7350)
%t7351 = icmp sle i64 %p2, %t7348
br i1 %t7351, label %L784, label %L786
L784:
%t7352 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 16)
%t7353 = extractvalue {i64, i1} %t7352, 0
%t7354 = extractvalue {i64, i1} %t7352, 1
%t7355 = zext i1 %t7354 to i8
call void @resid_overflow_check(i8 %t7355)
%t7356 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7353, i64 %p2)
%t7357 = extractvalue {i64, i1} %t7356, 0
%t7358 = extractvalue {i64, i1} %t7356, 1
%t7359 = zext i1 %t7358 to i8
call void @resid_overflow_check(i8 %t7359)
%t7360 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t7357, i64 8)
%t7361 = extractvalue {i64, i1} %t7360, 0
%t7362 = extractvalue {i64, i1} %t7360, 1
%t7363 = zext i1 %t7362 to i8
call void @resid_overflow_check(i8 %t7363)
%t7364 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t7365 = extractvalue {i64, i1} %t7364, 0
%t7366 = extractvalue {i64, i1} %t7364, 1
%t7367 = zext i1 %t7366 to i8
call void @resid_overflow_check(i8 %t7367)
%t7368 = icmp sge i64 %t7361, 61
br i1 %t7368, label %L787, label %L788
L787:
br label %L789
L788:
%t7369 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p0, i64 8)
%t7370 = extractvalue {i64, i1} %t7369, 0
%t7371 = extractvalue {i64, i1} %t7369, 1
%t7372 = zext i1 %t7371 to i8
call void @resid_overflow_check(i8 %t7372)
%t7373 = icmp uge i64 %t7361, 64
%t7374 = add i64 %t7361, 0
%t7375 = select i1 %t7373, i64 63, i64 %t7374
%t7376 = ashr i64 %t7370, %t7375
%t7377 = and i64 %t7376, 255
br label %L789
L789:
%t7378 = phi i64 [ 0, %L787 ], [ %t7377, %L788 ]
%t7379 = call ptr @resid_box_i64(i64 %t7378)
%t7382 = call ptr @resid_listbuf_push(ptr %p3, ptr %t7379)
br label %tco.s2
tco.s2:
br label %tco.head
L786:
ret ptr %p3
}
define ptr @__m____________lib_sha512g_resid__sha512g_zero_bytes(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7386, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t7390, %tco.s0 ]
%t7384 = icmp sge i64 %p1, %p0
br i1 %t7384, label %L790, label %L792
L790:
%t7385 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty7385)
ret ptr %t7385
L792:
%t7386 = add nsw i64 %p1, 1
%t7387 = call ptr @resid_box_i64(i64 0)
%t7390 = call ptr @resid_listbuf_push(ptr %p2, ptr %t7387)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @eg_p() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7392 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
ret i512 %t7392
}
define i512 @eg_d() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7393 = sext i256 37095705934669439343138083508754565189542113879843219016388785533085940283555 to i512
ret i512 %t7393
}
define i512 @eg_l() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7394 = sext i256 7237005577332262213973186563042994240857116359379907606001950938285454250989 to i512
ret i512 %t7394
}
define i512 @eg_bx() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7395 = sext i256 15112221349535400772501151409588531511454012693041857206046113283949847762202 to i512
ret i512 %t7395
}
define i512 @eg_by() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7396 = sext i256 46316835694926478169428394003475163141307993866256225615783033603165251855960 to i512
ret i512 %t7396
}
define i512 @__m____________lib_ed25519g_resid__eg_m256() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i512 115792089237316195423570985008687907853269984665640564039457584007913129639935
}
define i512 @__m____________lib_ed25519g_resid__eg_ones() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7397 = sext i64 -1 to i512
ret i512 %t7397
}
define i256 @fe_p() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i256 57896044618658097711785492504343953926634992332820282019728792003956564819949
}
define i256 @fe_d() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i256 37095705934669439343138083508754565189542113879843219016388785533085940283555
}
define i256 @fe_sqrtm1() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i256 19681161376707505956807079304988542015446066515923890162744021073123829784752
}
define i256 @fe_l() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i256 7237005577332262213973186563042994240857116359379907606001950938285454250989
}
define i256 @fe_p58() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i256 7237005577332262213973186563042994240829374041602535252466099000494570602494
}
define i256 @fe_pm2() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i256 57896044618658097711785492504343953926634992332820282019728792003956564819947
}
define i256 @fe_bx() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i256 15112221349535400772501151409588531511454012693041857206046113283949847762202
}
define i256 @fe_by() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i256 46316835694926478169428394003475163141307993866256225615783033603165251855960
}
define i256 @fe_bt() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7398 = call i256 @fe_mul(i256 15112221349535400772501151409588531511454012693041857206046113283949847762202, i256 46316835694926478169428394003475163141307993866256225615783033603165251855960)
ret i256 %t7398
}
define i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7399 = sext i256 %p0 to i512
ret i512 %t7399
}
define i256 @fe_add(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7400 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t7401 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t7402 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t7400, i512 %t7401)
%t7403 = trunc i512 %t7402 to i256
ret i256 %t7403
}
define i256 @fe_sub(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7404 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t7405 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t7406 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t7404, i512 %t7405)
%t7407 = trunc i512 %t7406 to i256
ret i256 %t7407
}
define i256 @fe_mul(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7408 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t7409 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t7410 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7408, i512 %t7409)
%t7411 = trunc i512 %t7410 to i256
ret i256 %t7411
}
define i256 @fe_sq(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7412 = call i256 @fe_mul(i256 %p0, i256 %p0)
ret i256 %t7412
}
define i256 @fe_inv(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7413 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t7414 = call i512 @eg_finv__g_Int_512__Int_64_(i512 %t7413)
%t7415 = trunc i512 %t7414 to i256
ret i256 %t7415
}
define i256 @pow_acc(i256 %p0, i256 %p1, i256 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7416 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t7417 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t7418 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p2)
%t7419 = call i512 @eg_fpow__g_Int_512__Int_64_(i512 %t7416, i512 %t7417, i512 %t7418, i64 %p3)
%t7420 = trunc i512 %t7419 to i256
ret i256 %t7420
}
define i256 @bytes_to_int(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7421 = sext i64 0 to i256
%t7422 = call i256 @b2a(ptr %p0, i256 %t7421, i64 31)
ret i256 %t7422
}
define i256 @b2a(ptr %p0.in, i256 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i256 [ %p1.in, %entry ], [ %t7436, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t7437, %tco.s0 ]
%t7423 = icmp slt i64 %p2, 0
br i1 %t7423, label %L793, label %L795
L793:
ret i256 %p1
L795:
%t7424 = icmp eq i64 %p2, 31
br i1 %t7424, label %L796, label %L797
L796:
%t7425 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t7426 = call i64 @resid_unbox_i64(ptr %t7425)
%t7428 = and i64 %t7426, 127
br label %L798
L797:
%t7429 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t7430 = call i64 @resid_unbox_i64(ptr %t7429)
%t7432 = and i64 %t7430, 255
br label %L798
L798:
%t7433 = phi i64 [ %t7428, %L796 ], [ %t7432, %L797 ]
%t7434 = shl i256 %p1, 8
%t7435 = sext i64 %t7433 to i256
%t7436 = or i256 %t7434, %t7435
%t7437 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @int_to_bytes(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7439 = call ptr @resid_listbuf_new()
%t7440 = call ptr @__m____________lib_ed25519_resid__itob_acc(i256 %p0, i64 0, ptr %t7439)
ret ptr %t7440
}
define ptr @__m____________lib_ed25519_resid__itob_acc(i256 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i256 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7443, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t7458, %tco.s0 ]
%t7441 = icmp sgt i64 %p1, 31
br i1 %t7441, label %L799, label %L801
L799:
%t7442 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty7442)
ret ptr %t7442
L801:
%t7443 = add nsw i64 %p1, 1
%t7444 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t7445 = extractvalue {i64, i1} %t7444, 0
%t7446 = extractvalue {i64, i1} %t7444, 1
%t7447 = zext i1 %t7446 to i8
call void @resid_overflow_check(i8 %t7447)
%t7448 = sext i64 %t7445 to i256
%t7449 = icmp uge i256 %t7448, 256
%t7450 = add i256 %t7448, 0
%t7451 = select i1 %t7449, i256 255, i256 %t7450
%t7452 = ashr i256 %p0, %t7451
%t7453 = and i256 %t7452, 255
%t7454 = trunc i256 %t7453 to i64
%t7455 = call ptr @resid_box_i64(i64 %t7454)
%t7458 = call ptr @resid_listbuf_push(ptr %p2, ptr %t7455)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @slice_bytes(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7460 = icmp slt i64 %p2, %p1
br i1 %t7460, label %L802, label %L804
L802:
%t7462 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty7461)
ret ptr %t7462
L804:
%t7463 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t7464 = extractvalue {i64, i1} %t7463, 0
%t7465 = extractvalue {i64, i1} %t7463, 1
%t7466 = zext i1 %t7465 to i8
call void @resid_overflow_check(i8 %t7466)
%t7467 = musttail call ptr @resid_list_slice(ptr %p0, i64 %p1, i64 %t7464)
ret ptr %t7467
}
define ptr @concat_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7469 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %p1)
ret ptr %t7469
}
define ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7470 = call ptr @resid_rec_new(i64 256, i8 1)
%t7471 = getelementptr i8, ptr %p0, i64 0
%t7472 = load i256, ptr %t7471, align 8
%t7473 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7472)
%t7470.f0 = getelementptr i8, ptr %t7470, i64 0
store i512 %t7473, ptr %t7470.f0, align 8
%t7474 = getelementptr i8, ptr %p0, i64 32
%t7475 = load i256, ptr %t7474, align 8
%t7476 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7475)
%t7470.f8 = getelementptr i8, ptr %t7470, i64 64
store i512 %t7476, ptr %t7470.f8, align 8
%t7477 = getelementptr i8, ptr %p0, i64 64
%t7478 = load i256, ptr %t7477, align 8
%t7479 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7478)
%t7470.f16 = getelementptr i8, ptr %t7470, i64 128
store i512 %t7479, ptr %t7470.f16, align 8
%t7480 = getelementptr i8, ptr %p0, i64 96
%t7481 = load i256, ptr %t7480, align 8
%t7482 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7481)
%t7470.f24 = getelementptr i8, ptr %t7470, i64 192
store i512 %t7482, ptr %t7470.f24, align 8
ret ptr %t7470
}
define ptr @__m____________lib_ed25519_resid__ept_n(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7483 = call ptr @resid_gmalloc(i64 128)
%t7484 = getelementptr i8, ptr %p0, i64 0
%t7485 = load i512, ptr %t7484, align 8
%t7486 = trunc i512 %t7485 to i256
%t7483.f0 = getelementptr i8, ptr %t7483, i64 0
store i256 %t7486, ptr %t7483.f0, align 8
%t7487 = getelementptr i8, ptr %p0, i64 64
%t7488 = load i512, ptr %t7487, align 8
%t7489 = trunc i512 %t7488 to i256
%t7483.f4 = getelementptr i8, ptr %t7483, i64 32
store i256 %t7489, ptr %t7483.f4, align 8
%t7490 = getelementptr i8, ptr %p0, i64 128
%t7491 = load i512, ptr %t7490, align 8
%t7492 = trunc i512 %t7491 to i256
%t7483.f8 = getelementptr i8, ptr %t7483, i64 64
store i256 %t7492, ptr %t7483.f8, align 8
%t7493 = getelementptr i8, ptr %p0, i64 192
%t7494 = load i512, ptr %t7493, align 8
%t7495 = trunc i512 %t7494 to i256
%t7483.f12 = getelementptr i8, ptr %t7483, i64 96
store i256 %t7495, ptr %t7483.f12, align 8
ret ptr %t7483
}
define ptr @ept(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7496 = call ptr @resid_gmalloc(i64 128)
%t7496.f0 = getelementptr i8, ptr %t7496, i64 0
store i256 %p0, ptr %t7496.f0, align 8
%t7496.f4 = getelementptr i8, ptr %t7496, i64 32
store i256 %p1, ptr %t7496.f4, align 8
%t7497 = sext i64 1 to i256
%t7496.f8 = getelementptr i8, ptr %t7496, i64 64
store i256 %t7497, ptr %t7496.f8, align 8
%t7498 = call i256 @fe_mul(i256 %p0, i256 %p1)
%t7496.f12 = getelementptr i8, ptr %t7496, i64 96
store i256 %t7498, ptr %t7496.f12, align 8
ret ptr %t7496
}
define ptr @ept_id() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7499 = call ptr @resid_gmalloc(i64 128)
%t7500 = sext i64 0 to i256
%t7499.f0 = getelementptr i8, ptr %t7499, i64 0
store i256 %t7500, ptr %t7499.f0, align 8
%t7501 = sext i64 1 to i256
%t7499.f4 = getelementptr i8, ptr %t7499, i64 32
store i256 %t7501, ptr %t7499.f4, align 8
%t7502 = sext i64 1 to i256
%t7499.f8 = getelementptr i8, ptr %t7499, i64 64
store i256 %t7502, ptr %t7499.f8, align 8
%t7503 = sext i64 0 to i256
%t7499.f12 = getelementptr i8, ptr %t7499, i64 96
store i256 %t7503, ptr %t7499.f12, align 8
ret ptr %t7499
}
define ptr @ept_dbl(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7504 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0)
%t7505 = call ptr @eg_dbl__g_Int_512__Int_64_(ptr %t7504)
%t7506 = musttail call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t7505)
ret ptr %t7506
}
define ptr @ept_add(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7507 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0)
%t7508 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p1)
%t7509 = call ptr @eg_add__g_Int_512__Int_64_(ptr %t7507, ptr %t7508)
%t7510 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t7509)
ret ptr %t7510
}
define ptr @ept_mul(i256 %p0, ptr %p1, ptr %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7511 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t7512 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p1)
call void @resid_rec_share(ptr %t7512)
%t7513 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p2)
call void @resid_rec_share(ptr %t7513)
%t7514 = call ptr @eg_ladder__g_Int_512__Int_64_(i512 %t7511, ptr %t7512, ptr %t7513, i64 %p3)
%t7515 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t7514)
ret ptr %t7515
}
define ptr @ept_base_mul(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7516 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t7517 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t7516)
%t7518 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t7517)
ret ptr %t7518
}
define ptr @ept_encode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7519 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0)
%t7520 = musttail call ptr @eg_encode__g_Int_512__Int_64_(ptr %t7519)
ret ptr %t7520
}
define i1 @ept_eq(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7521 = getelementptr i8, ptr %p0, i64 0
%t7522 = load i256, ptr %t7521, align 8
%t7523 = getelementptr i8, ptr %p1, i64 64
%t7524 = load i256, ptr %t7523, align 8
%t7525 = call i256 @fe_mul(i256 %t7522, i256 %t7524)
%t7526 = getelementptr i8, ptr %p1, i64 0
%t7527 = load i256, ptr %t7526, align 8
%t7528 = getelementptr i8, ptr %p0, i64 64
%t7529 = load i256, ptr %t7528, align 8
%t7530 = call i256 @fe_mul(i256 %t7527, i256 %t7529)
%t7531 = icmp eq i256 %t7525, %t7530
br label %LSL7532
LSL7532:
br i1 %t7531, label %LSR7532, label %LSJ7532
LSR7532:
%t7533 = getelementptr i8, ptr %p0, i64 32
%t7534 = load i256, ptr %t7533, align 8
%t7535 = getelementptr i8, ptr %p1, i64 64
%t7536 = load i256, ptr %t7535, align 8
%t7537 = call i256 @fe_mul(i256 %t7534, i256 %t7536)
%t7538 = getelementptr i8, ptr %p1, i64 32
%t7539 = load i256, ptr %t7538, align 8
%t7540 = getelementptr i8, ptr %p0, i64 64
%t7541 = load i256, ptr %t7540, align 8
%t7542 = call i256 @fe_mul(i256 %t7539, i256 %t7541)
%t7543 = icmp eq i256 %t7537, %t7542
br label %LSJ7532
LSJ7532:
%t7544 = phi i1 [ false, %LSL7532 ], [ %t7543, %LSR7532 ]
ret i1 %t7544
}
define ptr @smul_x_acc(i256 %p0, i256 %p1, i256 %p2, i256 %p3, i256 %p4, i256 %p5, i256 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7545 = call ptr @resid_gmalloc(i64 128)
%t7545.f0 = getelementptr i8, ptr %t7545, i64 0
store i256 %p1, ptr %t7545.f0, align 8
%t7545.f4 = getelementptr i8, ptr %t7545, i64 32
store i256 %p2, ptr %t7545.f4, align 8
%t7545.f8 = getelementptr i8, ptr %t7545, i64 64
store i256 %p3, ptr %t7545.f8, align 8
%t7546 = call i256 @fe_mul(i256 %p1, i256 %p2)
%t7547 = call i256 @fe_inv(i256 %p3)
%t7548 = call i256 @fe_mul(i256 %t7546, i256 %t7547)
%t7545.f12 = getelementptr i8, ptr %t7545, i64 96
store i256 %t7548, ptr %t7545.f12, align 8
%t7549 = call ptr @resid_gmalloc(i64 128)
%t7549.f0 = getelementptr i8, ptr %t7549, i64 0
store i256 %p4, ptr %t7549.f0, align 8
%t7549.f4 = getelementptr i8, ptr %t7549, i64 32
store i256 %p5, ptr %t7549.f4, align 8
%t7549.f8 = getelementptr i8, ptr %t7549, i64 64
store i256 %p6, ptr %t7549.f8, align 8
%t7550 = call i256 @fe_mul(i256 %p4, i256 %p5)
%t7551 = call i256 @fe_inv(i256 %p6)
%t7552 = call i256 @fe_mul(i256 %t7550, i256 %t7551)
%t7549.f12 = getelementptr i8, ptr %t7549, i64 96
store i256 %t7552, ptr %t7549.f12, align 8
%t7553 = call ptr @ept_mul(i256 %p0, ptr %t7545, ptr %t7549, i64 %p7)
%t7554 = getelementptr i8, ptr %t7553, i64 0
%t7555 = load i256, ptr %t7554, align 8
%t7556 = getelementptr i8, ptr %t7553, i64 64
%t7557 = load i256, ptr %t7556, align 8
%t7558 = call i256 @fe_inv(i256 %t7557)
%t7559 = call i256 @fe_mul(i256 %t7555, i256 %t7558)
%t7560 = call ptr @int_to_bytes(i256 %t7559)
ret ptr %t7560
}
define i256 @dec_y(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7561 = call i256 @bytes_to_int(ptr %p0)
ret i256 %t7561
}
define i256 @dec_x(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7562 = call i256 @dec_y(ptr %p0)
%t7563 = call i64 @resid_list_len(ptr %p0)
%t7564 = sub nsw i64 %t7563, 1
%t7565 = call ptr @resid_list_get(ptr %p0, i64 %t7564)
%t7566 = call i64 @resid_unbox_i64(ptr %t7565)
%t7568 = ashr i64 %t7566, 7
%t7569 = and i64 %t7568, 1
%t7570 = call i256 @fe_sq(i256 %t7562)
%t7571 = sext i64 1 to i256
%t7572 = call i256 @fe_sub(i256 %t7570, i256 %t7571)
%t7573 = call i256 @fe_mul(i256 37095705934669439343138083508754565189542113879843219016388785533085940283555, i256 %t7570)
%t7574 = sext i64 1 to i256
%t7575 = call i256 @fe_add(i256 %t7573, i256 %t7574)
%t7576 = call i256 @fe_inv(i256 %t7575)
%t7577 = call i256 @fe_mul(i256 %t7572, i256 %t7576)
%t7578 = sext i64 1 to i256
%t7579 = call i256 @pow_acc(i256 %t7578, i256 %t7577, i256 7237005577332262213973186563042994240829374041602535252466099000494570602494, i64 254)
%t7580 = call i256 @fe_sq(i256 %t7579)
%t7581 = icmp eq i256 %t7580, %t7577
br i1 %t7581, label %L805, label %L806
L805:
br label %L807
L806:
%t7582 = call i256 @fe_mul(i256 %t7579, i256 19681161376707505956807079304988542015446066515923890162744021073123829784752)
br label %L807
L807:
%t7583 = phi i256 [ %t7579, %L805 ], [ %t7582, %L806 ]
%t7584 = and i256 %t7583, 1
%t7585 = trunc i256 %t7584 to i64
%t7586 = icmp ne i64 %t7585, %t7569
br i1 %t7586, label %L808, label %L809
L808:
%t7587 = sext i64 0 to i256
%t7588 = call i256 @fe_sub(i256 %t7587, i256 %t7583)
br label %L810
L809:
br label %L810
L810:
%t7589 = phi i256 [ %t7588, %L808 ], [ %t7583, %L809 ]
ret i256 %t7589
}
define i1 @dec_ok(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7590 = call ptr @__m____________lib_ed25519_resid__dec_pt(ptr %p0)
%t7591 = getelementptr i8, ptr %t7590, i64 0
%t7592 = load i1, ptr %t7591, align 8
ret i1 %t7592
}
define ptr @__m____________lib_ed25519_resid__dec_pt(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7593 = call ptr @resid_gmalloc(i64 72)
%t7593.f0 = getelementptr i8, ptr %t7593, i64 0
store i1 false, ptr %t7593.f0, align 8
%t7594 = sext i64 0 to i256
%t7593.f1 = getelementptr i8, ptr %t7593, i64 8
store i256 %t7594, ptr %t7593.f1, align 8
%t7595 = sext i64 0 to i256
%t7593.f5 = getelementptr i8, ptr %t7593, i64 40
store i256 %t7595, ptr %t7593.f5, align 8
%t7596 = call i64 @resid_list_len(ptr %p0)
%t7597 = icmp ne i64 %t7596, 32
br i1 %t7597, label %L811, label %L813
L811:
ret ptr %t7593
L813:
%t7598 = call i256 @dec_y(ptr %p0)
%t7599 = icmp sge i256 %t7598, 57896044618658097711785492504343953926634992332820282019728792003956564819949
br i1 %t7599, label %L814, label %L816
L814:
ret ptr %t7593
L816:
%t7600 = call i256 @dec_x(ptr %p0)
%t7601 = icmp eq i256 %t7600, 0
br label %LSL7602
LSL7602:
br i1 %t7601, label %LSR7602, label %LSJ7602
LSR7602:
%t7603 = call ptr @resid_list_get(ptr %p0, i64 31)
%t7604 = call i64 @resid_unbox_i64(ptr %t7603)
%t7606 = ashr i64 %t7604, 7
%t7607 = and i64 %t7606, 1
%t7608 = icmp eq i64 %t7607, 1
br label %LSJ7602
LSJ7602:
%t7609 = phi i1 [ false, %LSL7602 ], [ %t7608, %LSR7602 ]
br i1 %t7609, label %L817, label %L819
L817:
ret ptr %t7593
L819:
%t7610 = call i256 @fe_sq(i256 %t7600)
%t7611 = call i256 @fe_sq(i256 %t7598)
%t7612 = call ptr @resid_gmalloc(i64 72)
%t7613 = call i256 @fe_sub(i256 %t7611, i256 %t7610)
%t7614 = sext i64 1 to i256
%t7615 = call i256 @fe_mul(i256 %t7610, i256 %t7611)
%t7616 = call i256 @fe_mul(i256 37095705934669439343138083508754565189542113879843219016388785533085940283555, i256 %t7615)
%t7617 = call i256 @fe_add(i256 %t7614, i256 %t7616)
%t7618 = icmp eq i256 %t7613, %t7617
%t7612.f0 = getelementptr i8, ptr %t7612, i64 0
store i1 %t7618, ptr %t7612.f0, align 8
%t7612.f1 = getelementptr i8, ptr %t7612, i64 8
store i256 %t7600, ptr %t7612.f1, align 8
%t7612.f5 = getelementptr i8, ptr %t7612, i64 40
store i256 %t7598, ptr %t7612.f5, align 8
ret ptr %t7612
}
define i256 @mod_l(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7619 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %p0)
%t7620 = trunc i512 %t7619 to i256
ret i256 %t7620
}
define i1 @verify_sig_bytes(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7621 = call i64 @resid_list_len(ptr %p1)
%t7622 = icmp ne i64 %t7621, 64
br label %LSL7623
LSL7623:
br i1 %t7622, label %LSJ7623, label %LSR7623
LSR7623:
%t7624 = call i64 @resid_list_len(ptr %p2)
%t7625 = icmp ne i64 %t7624, 32
br label %LSJ7623
LSJ7623:
%t7626 = phi i1 [ true, %LSL7623 ], [ %t7625, %LSR7623 ]
br i1 %t7626, label %L820, label %L822
L820:
ret i1 false
L822:
%t7627 = call ptr @resid_list_get(ptr %p1, i64 63)
%t7628 = call i64 @resid_unbox_i64(ptr %t7627)
%t7630 = icmp sge i64 %t7628, 128
br i1 %t7630, label %L823, label %L825
L823:
ret i1 false
L825:
%t7631 = call ptr @resid_list_slice(ptr %p1, i64 0, i64 32)
%t7633 = call ptr @resid_list_slice(ptr %p1, i64 32, i64 64)
%t7635 = call i256 @bytes_to_int(ptr %t7633)
%t7636 = icmp sge i256 %t7635, 7237005577332262213973186563042994240857116359379907606001950938285454250989
br i1 %t7636, label %L826, label %L828
L826:
ret i1 false
L828:
%t7637 = call ptr @__m____________lib_ed25519_resid__dec_pt(ptr %p2)
%t7638 = call ptr @__m____________lib_ed25519_resid__dec_pt(ptr %t7631)
%t7639 = getelementptr i8, ptr %t7637, i64 0
%t7640 = load i1, ptr %t7639, align 8
%t7641 = xor i1 %t7640, true
br label %LSL7642
LSL7642:
br i1 %t7641, label %LSJ7642, label %LSR7642
LSR7642:
%t7643 = getelementptr i8, ptr %t7638, i64 0
%t7644 = load i1, ptr %t7643, align 8
%t7645 = xor i1 %t7644, true
br label %LSJ7642
LSJ7642:
%t7646 = phi i1 [ true, %LSL7642 ], [ %t7645, %LSR7642 ]
br i1 %t7646, label %L829, label %L831
L829:
ret i1 false
L831:
%t7647 = getelementptr i8, ptr %t7637, i64 8
%t7648 = load i256, ptr %t7647, align 8
%t7649 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7648)
%t7650 = getelementptr i8, ptr %t7637, i64 40
%t7651 = load i256, ptr %t7650, align 8
%t7652 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7651)
%t7653 = call ptr @eg_pt__g_Int_512__Int_64_(i512 %t7649, i512 %t7652)
call void @resid_rec_share(ptr %t7653)
%t7654 = getelementptr i8, ptr %t7638, i64 8
%t7655 = load i256, ptr %t7654, align 8
%t7656 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7655)
%t7657 = getelementptr i8, ptr %t7638, i64 40
%t7658 = load i256, ptr %t7657, align 8
%t7659 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7658)
%t7660 = call ptr @eg_pt__g_Int_512__Int_64_(i512 %t7656, i512 %t7659)
%t7661 = call i64 @resid_scope_push()
%t7662 = call ptr @resid_list_concat_own(ptr %t7631, i8 1, ptr %p2)
%t7663 = call ptr @resid_list_concat_own(ptr %t7662, i8 1, ptr %p0)
%t7664 = call ptr @sha512_bytes(ptr %t7663)
%t7665 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %t7664)
call void @resid_scope_pop(i64 %t7661)
%t7666 = call ptr @eg_id__g_Int_512__Int_64_()
call void @resid_rec_share(ptr %t7666)
%t7667 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7635)
%t7668 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t7667)
%t7669 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t7668)
%t7670 = call ptr @eg_ladder__g_Int_512__Int_64_(i512 %t7665, ptr %t7653, ptr %t7666, i64 255)
%t7671 = call ptr @eg_add__g_Int_512__Int_64_(ptr %t7670, ptr %t7660)
%t7672 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t7671)
%t7673 = call i1 @ept_eq(ptr %t7669, ptr %t7672)
ret i1 %t7673
}
define i1 @verify_sig(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7674 = call ptr @bytes_of(ptr %p0)
%t7675 = call ptr @resid_list_freeze(ptr %t7674)
%t7676 = musttail call i1 @verify_sig_bytes(ptr %t7675, ptr %p1, ptr %p2)
ret i1 %t7676
}
define i256 @clamp_scalar(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7677 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t7678 = call i512 @eg_clamp__g_Int_512__Int_64_(i512 %t7677)
%t7679 = trunc i512 %t7678 to i256
ret i256 %t7679
}
define ptr @pub_key(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7680 = musttail call ptr @ed25519g_pub__g_Int_64__Int_512__UInt_64_(ptr %p0)
ret ptr %t7680
}
define ptr @sign_msg_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7681 = musttail call ptr @ed25519g_sign__g_Int_64__Int_512__UInt_64_(ptr %p0, ptr %p1)
ret ptr %t7681
}
define ptr @sign_msg(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7682 = call ptr @bytes_of(ptr %p1)
%t7683 = call ptr @resid_list_freeze(ptr %t7682)
%t7684 = musttail call ptr @sign_msg_bytes(ptr %p0, ptr %t7683)
ret ptr %t7684
}
define i64 @__m____________lib_chachag_resid__cg_le32(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7685 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t7686 = call i64 @resid_unbox_i64(ptr %t7685)
%t7688 = and i64 %t7686, 255
%t7689 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t7690 = extractvalue {i64, i1} %t7689, 0
%t7691 = extractvalue {i64, i1} %t7689, 1
%t7692 = zext i1 %t7691 to i8
call void @resid_overflow_check(i8 %t7692)
%t7693 = call ptr @resid_list_get(ptr %p0, i64 %t7690)
%t7694 = call i64 @resid_unbox_i64(ptr %t7693)
%t7696 = and i64 %t7694, 255
%t7697 = shl i64 %t7696, 8
%t7698 = or i64 %t7688, %t7697
%t7699 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t7700 = extractvalue {i64, i1} %t7699, 0
%t7701 = extractvalue {i64, i1} %t7699, 1
%t7702 = zext i1 %t7701 to i8
call void @resid_overflow_check(i8 %t7702)
%t7703 = call ptr @resid_list_get(ptr %p0, i64 %t7700)
%t7704 = call i64 @resid_unbox_i64(ptr %t7703)
%t7706 = and i64 %t7704, 255
%t7707 = shl i64 %t7706, 16
%t7708 = or i64 %t7698, %t7707
%t7709 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 3)
%t7710 = extractvalue {i64, i1} %t7709, 0
%t7711 = extractvalue {i64, i1} %t7709, 1
%t7712 = zext i1 %t7711 to i8
call void @resid_overflow_check(i8 %t7712)
%t7713 = call ptr @resid_list_get(ptr %p0, i64 %t7710)
%t7714 = call i64 @resid_unbox_i64(ptr %t7713)
%t7716 = and i64 %t7714, 255
%t7717 = shl i64 %t7716, 24
%t7718 = or i64 %t7708, %t7717
ret i64 %t7718
}
define i512 @__m____________lib_chachag_resid__pg_m130() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7719 = sext i256 1361129467683753853853498429727072845823 to i512
ret i512 %t7719
}
define i512 @__m____________lib_chachag_resid__pg_p() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7720 = sext i256 1361129467683753853853498429727072845819 to i512
ret i512 %t7720
}
define i512 @__m____________lib_chachag_resid__pg_m128() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7721 = sext i256 340282366920938463463374607431768211455 to i512
ret i512 %t7721
}
define i512 @__m____________lib_chachag_resid__pg_clamp() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7722 = sext i128 21267647620597763993911028882763415551 to i512
ret i512 %t7722
}
define i64 @__m____________lib_chachag_resid__cg_pad16(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7723 = srem i64 %p0, 16
%t7724 = icmp eq i64 %t7723, 0
br i1 %t7724, label %L832, label %L833
L832:
br label %L834
L833:
%t7725 = sub nsw i64 16, %t7723
br label %L834
L834:
%t7726 = phi i64 [ 0, %L832 ], [ %t7725, %L833 ]
ret i64 %t7726
}
define ptr @__m____________lib_chachag_resid__cg_zeros(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7729, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t7733, %tco.s0 ]
%t7727 = icmp sge i64 %p1, %p0
br i1 %t7727, label %L835, label %L837
L835:
%t7728 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty7728)
ret ptr %t7728
L837:
%t7729 = add nsw i64 %p1, 1
%t7730 = call ptr @resid_box_i64(i64 0)
%t7733 = call ptr @resid_listbuf_push(ptr %p2, ptr %t7730)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__cg_le64(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7737, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t7750, %tco.s0 ]
%t7735 = icmp sge i64 %p1, 8
br i1 %t7735, label %L838, label %L840
L838:
%t7736 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty7736)
ret ptr %t7736
L840:
%t7737 = add nsw i64 %p1, 1
%t7738 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p1)
%t7739 = extractvalue {i64, i1} %t7738, 0
%t7740 = extractvalue {i64, i1} %t7738, 1
%t7741 = zext i1 %t7740 to i8
call void @resid_overflow_check(i8 %t7741)
%t7742 = icmp uge i64 %t7739, 64
%t7743 = add i64 %t7739, 0
%t7744 = select i1 %t7742, i64 63, i64 %t7743
%t7745 = ashr i64 %p0, %t7744
%t7746 = and i64 %t7745, 255
%t7747 = call ptr @resid_box_i64(i64 %t7746)
%t7750 = call ptr @resid_listbuf_push(ptr %p2, ptr %t7747)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @chacha_block(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7752 = musttail call ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
ret ptr %t7752
}
define ptr @chacha20_xor(ptr %p0, i64 %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7753 = musttail call ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2, ptr %p3)
ret ptr %t7753
}
define ptr @poly1305(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7754 = musttail call ptr @poly1305g__g_Int_64__Int_512_(ptr %p0, ptr %p1)
ret ptr %t7754
}
define ptr @chacha20poly1305_seal(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7755 = musttail call ptr @chacha20poly1305g_seal__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
ret ptr %t7755
}
define i1 @chacha20poly1305_open(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7756 = call ptr @chacha20poly1305_decrypt(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
%t7757 = getelementptr {i32, i32, ptr}, ptr %t7756, i32 0, i32 0
%t7758w = load i32, ptr %t7757
%t7758 = sext i32 %t7758w to i64
%t7759 = icmp eq i64 %t7758, 1
br i1 %t7759, label %L841, label %L842
L841:
%t7760 = getelementptr {i32, i32, ptr}, ptr %t7756, i32 1
%t7761 = getelementptr i8, ptr %t7760, i64 0
%t7762 = getelementptr ptr, ptr %t7761, i32 0
%t7763 = load ptr, ptr %t7762
br label %L843
L842:
br label %L843
L843:
%t7764 = phi i1 [ true, %L841 ], [ false, %L842 ]
ret i1 %t7764
}
define ptr @chacha20poly1305_decrypt(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7765 = musttail call ptr @chacha20poly1305g_decrypt__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
ret ptr %t7765
}
define ptr @chacha20poly1305_open_bytes(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7766 = call ptr @chacha20poly1305_decrypt(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
%t7767 = getelementptr {i32, i32, ptr}, ptr %t7766, i32 0, i32 0
%t7768w = load i32, ptr %t7767
%t7768 = sext i32 %t7768w to i64
%t7769 = icmp eq i64 %t7768, 1
br i1 %t7769, label %L844, label %L845
L845:
%t7771 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty7770)
br label %L846
L844:
%t7772 = getelementptr {i32, i32, ptr}, ptr %t7766, i32 1
%t7773 = getelementptr i8, ptr %t7772, i64 0
%t7774 = getelementptr ptr, ptr %t7773, i32 0
%t7775 = load ptr, ptr %t7774
br label %L846
L846:
%t7776 = phi ptr [ %t7771, %L845 ], [ %t7775, %L844 ]
ret ptr %t7776
}
define ptr @cbe_be(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7789 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7783, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t7777 = icmp sle i64 %p1, 0
br i1 %t7777, label %L847, label %L849
L847:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p2
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L849:
%t7778 = sub nsw i64 %p1, 1
%t7779 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t7778, i64 8)
%t7780 = extractvalue {i64, i1} %t7779, 0
%t7781 = extractvalue {i64, i1} %t7779, 1
%t7782 = zext i1 %t7781 to i8
call void @resid_overflow_check(i8 %t7782)
%t7783 = sub nsw i64 %p1, 1
%t7784 = icmp uge i64 %t7780, 64
%t7785 = add i64 %t7780, 0
%t7786 = select i1 %t7784, i64 63, i64 %t7785
%t7787 = ashr i64 %p0, %t7786
%t7788 = and i64 %t7787, 255
%t7791 = call ptr @resid_box_i64(i64 %t7788)
%t7793 = getelementptr i8, ptr %t7789, i64 0
store ptr %t7791, ptr %t7793
%t7794 = call ptr @resid_list_new(i64 1, ptr %t7789, ptr @.lty7789)
%t7795 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7794)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t7795, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t7795, %tco.s0 ]
br label %tco.head
}
define ptr @cbe_head(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7800 = alloca [1 x ptr]
%t7810 = alloca [2 x ptr]
%t7822 = alloca [1 x ptr]
%t7832 = alloca [1 x ptr]
%t7841 = alloca [1 x ptr]
%t7797 = shl i64 %p0, 5
%t7798 = icmp sle i64 %p1, 23
br i1 %t7798, label %L850, label %L852
L850:
%t7799 = or i64 %t7797, %p1
%t7802 = call ptr @resid_box_i64(i64 %t7799)
%t7804 = getelementptr i8, ptr %t7800, i64 0
store ptr %t7802, ptr %t7804
%t7805 = call ptr @resid_list_new(i64 1, ptr %t7800, ptr @.lty7800)
%t7806 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7805)
ret ptr %t7806
L852:
%t7807 = icmp sle i64 %p1, 255
br i1 %t7807, label %L853, label %L855
L853:
%t7808 = or i64 %t7797, 24
%t7809 = add nsw i64 %p1, 0
%t7812 = call ptr @resid_box_i64(i64 %t7808)
%t7814 = getelementptr i8, ptr %t7810, i64 0
store ptr %t7812, ptr %t7814
%t7815 = call ptr @resid_box_i64(i64 %t7809)
%t7817 = getelementptr i8, ptr %t7810, i64 8
store ptr %t7815, ptr %t7817
%t7818 = call ptr @resid_list_new(i64 2, ptr %t7810, ptr @.lty7810)
%t7819 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7818)
ret ptr %t7819
L855:
%t7820 = icmp sle i64 %p1, 65535
br i1 %t7820, label %L856, label %L858
L856:
%t7821 = or i64 %t7797, 25
%t7824 = call ptr @resid_box_i64(i64 %t7821)
%t7826 = getelementptr i8, ptr %t7822, i64 0
store ptr %t7824, ptr %t7826
%t7827 = call ptr @resid_list_new(i64 1, ptr %t7822, ptr @.lty7822)
%t7828 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7827)
%t7829 = musttail call ptr @cbe_be(i64 %p1, i64 2, ptr %t7828)
ret ptr %t7829
L858:
%t7830 = icmp sle i64 %p1, 4294967295
br i1 %t7830, label %L859, label %L861
L859:
%t7831 = or i64 %t7797, 26
%t7834 = call ptr @resid_box_i64(i64 %t7831)
%t7836 = getelementptr i8, ptr %t7832, i64 0
store ptr %t7834, ptr %t7836
%t7837 = call ptr @resid_list_new(i64 1, ptr %t7832, ptr @.lty7832)
%t7838 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7837)
%t7839 = musttail call ptr @cbe_be(i64 %p1, i64 4, ptr %t7838)
ret ptr %t7839
L861:
%t7840 = or i64 %t7797, 27
%t7843 = call ptr @resid_box_i64(i64 %t7840)
%t7845 = getelementptr i8, ptr %t7841, i64 0
store ptr %t7843, ptr %t7845
%t7846 = call ptr @resid_list_new(i64 1, ptr %t7841, ptr @.lty7841)
%t7847 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7846)
%t7848 = musttail call ptr @cbe_be(i64 %p1, i64 8, ptr %t7847)
ret ptr %t7848
}
define ptr @cbe_uint(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7849 = call ptr @cbe_head(i64 0, i64 %p0, ptr %p1)
ret ptr %t7849
}
define ptr @cbe_int(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7850 = icmp sge i64 %p0, 0
br i1 %t7850, label %L862, label %L864
L862:
%t7851 = call ptr @cbe_head(i64 0, i64 %p0, ptr %p1)
ret ptr %t7851
L864:
%t7852 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p0)
%t7853 = extractvalue {i64, i1} %t7852, 0
%t7854 = extractvalue {i64, i1} %t7852, 1
%t7855 = zext i1 %t7854 to i8
call void @resid_overflow_check(i8 %t7855)
%t7856 = sub nsw i64 %t7853, 1
%t7857 = call ptr @cbe_head(i64 1, i64 %t7856, ptr %p1)
ret ptr %t7857
}
define ptr @cbe_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7858 = call i64 @resid_list_len(ptr %p0)
%t7859 = call ptr @cbe_head(i64 2, i64 %t7858, ptr %p1)
%t7860 = call ptr @resid_list_concat_own(ptr %t7859, i8 1, ptr %p0)
ret ptr %t7860
}
define ptr @cbe_text(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7861 = call ptr @bytes_of(ptr %p0)
%t7862 = call ptr @resid_list_freeze(ptr %t7861)
%t7863 = call i64 @resid_list_len(ptr %t7862)
%t7864 = call ptr @cbe_head(i64 3, i64 %t7863, ptr %p1)
%t7865 = call ptr @resid_list_concat_own(ptr %t7864, i8 1, ptr %t7862)
ret ptr %t7865
}
define ptr @cbe_array(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7866 = call ptr @cbe_head(i64 4, i64 %p0, ptr %p1)
ret ptr %t7866
}
define ptr @cbe_map(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7867 = call ptr @cbe_head(i64 5, i64 %p0, ptr %p1)
ret ptr %t7867
}
define ptr @cbe_tag(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7868 = call ptr @cbe_head(i64 6, i64 %p0, ptr %p1)
ret ptr %t7868
}
define i64 @cbe_be_read(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7871, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t7874, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t7879, %tco.s0 ]
%t7869 = icmp sle i64 %p2, 0
br i1 %t7869, label %L865, label %L867
L865:
ret i64 %p3
L867:
%t7870 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t7871 = extractvalue {i64, i1} %t7870, 0
%t7872 = extractvalue {i64, i1} %t7870, 1
%t7873 = zext i1 %t7872 to i8
call void @resid_overflow_check(i8 %t7873)
%t7874 = sub nsw i64 %p2, 1
%t7875 = shl i64 %p3, 8
%t7876 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t7877 = call i64 @resid_unbox_i64(ptr %t7876)
%t7879 = or i64 %t7875, %t7877
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @cbe_read_head(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7881 = icmp slt i64 %p1, 0
br label %LSL7882
LSL7882:
br i1 %t7881, label %LSJ7882, label %LSR7882
LSR7882:
%t7883 = call i64 @resid_list_len(ptr %p0)
%t7884 = icmp sge i64 %p1, %t7883
br label %LSJ7882
LSJ7882:
%t7885 = phi i1 [ true, %LSL7882 ], [ %t7884, %LSR7882 ]
br i1 %t7885, label %L868, label %L870
L868:
%t7886 = call ptr @resid_gmalloc(i64 32)
%t7886.f0 = getelementptr i8, ptr %t7886, i64 0
store i1 false, ptr %t7886.f0, align 8
%t7886.f1 = getelementptr i8, ptr %t7886, i64 8
store i64 0, ptr %t7886.f1, align 8
%t7886.f2 = getelementptr i8, ptr %t7886, i64 16
store i64 0, ptr %t7886.f2, align 8
%t7886.f3 = getelementptr i8, ptr %t7886, i64 24
store i64 %p1, ptr %t7886.f3, align 8
ret ptr %t7886
L870:
%t7887 = call ptr @resid_list_get_nc(ptr %p0, i64 %p1)
%t7888 = call i64 @resid_unbox_i64(ptr %t7887)
%t7890 = ashr i64 %t7888, 5
%t7891 = and i64 %t7888, 31
%t7892 = icmp sle i64 %t7891, 23
br i1 %t7892, label %L871, label %L873
L871:
%t7893 = call ptr @resid_gmalloc(i64 32)
%t7893.f0 = getelementptr i8, ptr %t7893, i64 0
store i1 true, ptr %t7893.f0, align 8
%t7893.f1 = getelementptr i8, ptr %t7893, i64 8
store i64 %t7890, ptr %t7893.f1, align 8
%t7893.f2 = getelementptr i8, ptr %t7893, i64 16
store i64 %t7891, ptr %t7893.f2, align 8
%t7894 = add nsw i64 %p1, 1
%t7893.f3 = getelementptr i8, ptr %t7893, i64 24
store i64 %t7894, ptr %t7893.f3, align 8
ret ptr %t7893
L873:
%t7895 = call i64 @cbe_arg_len(i64 %t7891)
%t7896 = icmp eq i64 %t7895, 0
br i1 %t7896, label %L874, label %L876
L874:
%t7897 = call ptr @resid_gmalloc(i64 32)
%t7897.f0 = getelementptr i8, ptr %t7897, i64 0
store i1 false, ptr %t7897.f0, align 8
%t7897.f1 = getelementptr i8, ptr %t7897, i64 8
store i64 %t7890, ptr %t7897.f1, align 8
%t7897.f2 = getelementptr i8, ptr %t7897, i64 16
store i64 0, ptr %t7897.f2, align 8
%t7897.f3 = getelementptr i8, ptr %t7897, i64 24
store i64 %p1, ptr %t7897.f3, align 8
ret ptr %t7897
L876:
%t7898 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t7895)
%t7899 = extractvalue {i64, i1} %t7898, 0
%t7900 = extractvalue {i64, i1} %t7898, 1
%t7901 = zext i1 %t7900 to i8
call void @resid_overflow_check(i8 %t7901)
%t7902 = call i64 @resid_list_len(ptr %p0)
%t7903 = icmp sge i64 %t7899, %t7902
br i1 %t7903, label %L877, label %L879
L877:
%t7904 = call ptr @resid_gmalloc(i64 32)
%t7904.f0 = getelementptr i8, ptr %t7904, i64 0
store i1 false, ptr %t7904.f0, align 8
%t7904.f1 = getelementptr i8, ptr %t7904, i64 8
store i64 %t7890, ptr %t7904.f1, align 8
%t7904.f2 = getelementptr i8, ptr %t7904, i64 16
store i64 0, ptr %t7904.f2, align 8
%t7904.f3 = getelementptr i8, ptr %t7904, i64 24
store i64 %p1, ptr %t7904.f3, align 8
ret ptr %t7904
L879:
%t7905 = call ptr @resid_gmalloc(i64 32)
%t7905.f0 = getelementptr i8, ptr %t7905, i64 0
store i1 true, ptr %t7905.f0, align 8
%t7905.f1 = getelementptr i8, ptr %t7905, i64 8
store i64 %t7890, ptr %t7905.f1, align 8
%t7906 = add nsw i64 %p1, 1
%t7907 = call i64 @cbe_be_read(ptr %p0, i64 %t7906, i64 %t7895, i64 0)
%t7905.f2 = getelementptr i8, ptr %t7905, i64 16
store i64 %t7907, ptr %t7905.f2, align 8
%t7908 = add nsw i64 %p1, 1
%t7909 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7908, i64 %t7895)
%t7910 = extractvalue {i64, i1} %t7909, 0
%t7911 = extractvalue {i64, i1} %t7909, 1
%t7912 = zext i1 %t7911 to i8
call void @resid_overflow_check(i8 %t7912)
%t7905.f3 = getelementptr i8, ptr %t7905, i64 24
store i64 %t7910, ptr %t7905.f3, align 8
ret ptr %t7905
}
define i64 @cbe_arg_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7913 = icmp eq i64 %p0, 24
br i1 %t7913, label %L880, label %L882
L880:
ret i64 1
L882:
%t7914 = icmp eq i64 %p0, 25
br i1 %t7914, label %L883, label %L885
L883:
ret i64 2
L885:
%t7915 = icmp eq i64 %p0, 26
br i1 %t7915, label %L886, label %L888
L886:
ret i64 4
L888:
%t7916 = icmp eq i64 %p0, 27
br i1 %t7916, label %L889, label %L891
L889:
ret i64 8
L891:
ret i64 0
}
define ptr @cbe_read_str(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7917 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB7917)
%t7918 = call ptr @cbe_read_head(ptr %p0, i64 %p1)
%t7919 = getelementptr i8, ptr %t7918, i64 0
%t7920 = load i1, ptr %t7919, align 8
%t7921 = xor i1 %t7920, true
br label %LSL7922
LSL7922:
br i1 %t7921, label %LSJ7922, label %LSR7922
LSR7922:
%t7923 = getelementptr i8, ptr %t7918, i64 8
%t7924 = load i64, ptr %t7923, align 8
%t7925 = icmp ne i64 %t7924, %p2
br label %LSJ7922
LSJ7922:
%t7926 = phi i1 [ true, %LSL7922 ], [ %t7925, %LSR7922 ]
br label %LSL7927
LSL7927:
br i1 %t7926, label %LSJ7927, label %LSR7927
LSR7927:
%t7928 = getelementptr i8, ptr %t7918, i64 16
%t7929 = load i64, ptr %t7928, align 8
%t7930 = icmp slt i64 %t7929, 0
br label %LSJ7927
LSJ7927:
%t7931 = phi i1 [ true, %LSL7927 ], [ %t7930, %LSR7927 ]
br label %LSL7932
LSL7932:
br i1 %t7931, label %LSJ7932, label %LSR7932
LSR7932:
%t7933 = getelementptr i8, ptr %t7918, i64 16
%t7934 = load i64, ptr %t7933, align 8
%t7935 = call i64 @resid_list_len(ptr %p0)
%t7936 = getelementptr i8, ptr %t7918, i64 24
%t7937 = load i64, ptr %t7936, align 8
%t7938 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7935, i64 %t7937)
%t7939 = extractvalue {i64, i1} %t7938, 0
%t7940 = extractvalue {i64, i1} %t7938, 1
%t7941 = zext i1 %t7940 to i8
call void @resid_overflow_check(i8 %t7941)
%t7942 = icmp sgt i64 %t7934, %t7939
br label %LSJ7932
LSJ7932:
%t7943 = phi i1 [ true, %LSL7932 ], [ %t7942, %LSR7932 ]
br i1 %t7943, label %L892, label %L894
L892:
%t7944 = call ptr @resid_gmalloc(i64 24)
%t7944.f0 = getelementptr i8, ptr %t7944, i64 0
store i1 false, ptr %t7944.f0, align 8
%t7944.f1 = getelementptr i8, ptr %t7944, i64 8
store ptr %t7917, ptr %t7944.f1, align 8
%t7944.f2 = getelementptr i8, ptr %t7944, i64 16
store i64 %p1, ptr %t7944.f2, align 8
ret ptr %t7944
L894:
%t7945 = getelementptr i8, ptr %t7918, i64 24
%t7946 = load i64, ptr %t7945, align 8
%t7947 = getelementptr i8, ptr %t7918, i64 16
%t7948 = load i64, ptr %t7947, align 8
%t7949 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7946, i64 %t7948)
%t7950 = extractvalue {i64, i1} %t7949, 0
%t7951 = extractvalue {i64, i1} %t7949, 1
%t7952 = zext i1 %t7951 to i8
call void @resid_overflow_check(i8 %t7952)
%t7953 = call ptr @resid_gmalloc(i64 24)
%t7953.f0 = getelementptr i8, ptr %t7953, i64 0
store i1 true, ptr %t7953.f0, align 8
%t7954 = getelementptr i8, ptr %t7918, i64 24
%t7955 = load i64, ptr %t7954, align 8
%t7956 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7950, i64 1)
%t7957 = extractvalue {i64, i1} %t7956, 0
%t7958 = extractvalue {i64, i1} %t7956, 1
%t7959 = zext i1 %t7958 to i8
call void @resid_overflow_check(i8 %t7959)
%t7960 = call ptr @slice_bytes(ptr %p0, i64 %t7955, i64 %t7957)
%t7953.f1 = getelementptr i8, ptr %t7953, i64 8
store ptr %t7960, ptr %t7953.f1, align 8
%t7953.f2 = getelementptr i8, ptr %t7953, i64 16
store i64 %t7950, ptr %t7953.f2, align 8
ret ptr %t7953
}
define ptr @cbe_ascii__sacc(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7963, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t7968, %tco.s0 ]
%t7961 = call i64 @resid_list_len(ptr %p0)
%t7962 = icmp sge i64 %p1, %t7961
br i1 %t7962, label %L895, label %L897
L895:
ret ptr %p2
L897:
%t7963 = add nsw i64 %p1, 1
%t7964 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t7965 = call i64 @resid_unbox_i64(ptr %t7964)
%t7967 = call ptr @str_from_code(i64 %t7965)
%t7968 = call ptr @resid_sacc_append(ptr %p2, ptr %t7967)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @cose_nibble(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7970 = icmp sge i64 %p0, 48
br label %LSL7971
LSL7971:
br i1 %t7970, label %LSR7971, label %LSJ7971
LSR7971:
%t7972 = icmp sle i64 %p0, 57
br label %LSJ7971
LSJ7971:
%t7973 = phi i1 [ false, %LSL7971 ], [ %t7972, %LSR7971 ]
br i1 %t7973, label %L898, label %L900
L898:
%t7974 = sub nsw i64 %p0, 48
ret i64 %t7974
L900:
%t7975 = icmp sge i64 %p0, 97
br label %LSL7976
LSL7976:
br i1 %t7975, label %LSR7976, label %LSJ7976
LSR7976:
%t7977 = icmp sle i64 %p0, 102
br label %LSJ7976
LSJ7976:
%t7978 = phi i1 [ false, %LSL7976 ], [ %t7977, %LSR7976 ]
br i1 %t7978, label %L901, label %L903
L901:
%t7979 = sub nsw i64 %p0, 87
ret i64 %t7979
L903:
%t7980 = icmp sge i64 %p0, 65
br label %LSL7981
LSL7981:
br i1 %t7980, label %LSR7981, label %LSJ7981
LSR7981:
%t7982 = icmp sle i64 %p0, 70
br label %LSJ7981
LSJ7981:
%t7983 = phi i1 [ false, %LSL7981 ], [ %t7982, %LSR7981 ]
br i1 %t7983, label %L904, label %L906
L904:
%t7984 = sub nsw i64 %p0, 55
ret i64 %t7984
L906:
ret i64 0
}
define ptr @cose_hex_acc(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8010 = alloca [1 x ptr]
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8007, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t7985 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t7986 = extractvalue {i64, i1} %t7985, 0
%t7987 = extractvalue {i64, i1} %t7985, 1
%t7988 = zext i1 %t7987 to i8
call void @resid_overflow_check(i8 %t7988)
%t7989 = icmp sge i64 %t7986, %p2
br i1 %t7989, label %L907, label %L909
L907:
%lr.cx18 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz18 = icmp eq ptr %lr.cx18, null
br i1 %lr.lz18, label %lr.x18.k, label %lr.x18.m
lr.x18.k:
ret ptr %p3
lr.x18.m:
%lr.ret18 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx18)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret18
L909:
%t7990 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t7991 = call i64 @cose_nibble(i64 %t7990)
%t7992 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t7991, i64 16)
%t7993 = extractvalue {i64, i1} %t7992, 0
%t7994 = extractvalue {i64, i1} %t7992, 1
%t7995 = zext i1 %t7994 to i8
call void @resid_overflow_check(i8 %t7995)
%t7996 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t7997 = extractvalue {i64, i1} %t7996, 0
%t7998 = extractvalue {i64, i1} %t7996, 1
%t7999 = zext i1 %t7998 to i8
call void @resid_overflow_check(i8 %t7999)
%t8000 = call i64 @resid_char_at_n(ptr %p0, i64 %t7997, i64 %p0.alen)
%t8001 = call i64 @cose_nibble(i64 %t8000)
%t8002 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7993, i64 %t8001)
%t8003 = extractvalue {i64, i1} %t8002, 0
%t8004 = extractvalue {i64, i1} %t8002, 1
%t8005 = zext i1 %t8004 to i8
call void @resid_overflow_check(i8 %t8005)
%t8006 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t8007 = extractvalue {i64, i1} %t8006, 0
%t8008 = extractvalue {i64, i1} %t8006, 1
%t8009 = zext i1 %t8008 to i8
call void @resid_overflow_check(i8 %t8009)
%t8012 = call ptr @resid_box_i64(i64 %t8003)
%t8014 = getelementptr i8, ptr %t8010, i64 0
store ptr %t8012, ptr %t8014
%t8015 = call ptr @resid_list_new(i64 1, ptr %t8010, ptr @.lty8010)
%t8016 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t8015)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t8016, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t8016, %tco.s0 ]
br label %tco.head
}
define ptr @cose_hex_decode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8018 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB8018)
%t8019 = call i64 @str_len(ptr %p0)
%t8020 = call ptr @cose_hex_acc(ptr %p0, i64 0, i64 %t8019, ptr %t8018)
ret ptr %t8020
}
define ptr @cose_sig_structure(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8022 = call ptr @resid_list_const_i64(ptr @.lc8021, i64 12, ptr @.lcd8021, ptr @.lty8021)
%t8023 = call ptr @cbe_bytes(ptr %p0, ptr %t8022)
%t8025 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty8024)
%t8026 = call ptr @cbe_bytes(ptr %t8025, ptr %t8023)
%t8027 = musttail call ptr @cbe_bytes(ptr %p1, ptr %t8026)
ret ptr %t8027
}
define ptr @cose_sign1_protected(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8028 = call ptr @bytes_of(ptr %p0)
%t8029 = call ptr @resid_list_freeze(ptr %t8028)
%t8031 = call ptr @resid_list_const_i64(ptr @.lc8030, i64 4, ptr @.lcd8030, ptr @.lty8030)
%t8032 = call ptr @cbe_bytes(ptr %t8029, ptr %t8031)
ret ptr %t8032
}
define ptr @cose_sign1_err(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8033 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB8033)
%t8034 = call ptr @resid_gmalloc(i64 48)
%t8034.f0 = getelementptr i8, ptr %t8034, i64 0
store i1 false, ptr %t8034.f0, align 8
%t8034.f1 = getelementptr i8, ptr %t8034, i64 8
store ptr %p0, ptr %t8034.f1, align 8
%t8034.f2 = getelementptr i8, ptr %t8034, i64 16
store ptr @.s8035, ptr %t8034.f2, align 8
%t8034.f3 = getelementptr i8, ptr %t8034, i64 24
store ptr %t8033, ptr %t8034.f3, align 8
%t8034.f4 = getelementptr i8, ptr %t8034, i64 32
store ptr %t8033, ptr %t8034.f4, align 8
%t8034.f5 = getelementptr i8, ptr %t8034, i64 40
store ptr %t8033, ptr %t8034.f5, align 8
ret ptr %t8034
}
define ptr @cose_kid_of(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8036 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t8037 = getelementptr i8, ptr %t8036, i64 0
%t8038 = load i1, ptr %t8037, align 8
%t8039 = xor i1 %t8038, true
br label %LSL8040
LSL8040:
br i1 %t8039, label %LSJ8040, label %LSR8040
LSR8040:
%t8041 = getelementptr i8, ptr %t8036, i64 8
%t8042 = load i64, ptr %t8041, align 8
%t8043 = icmp ne i64 %t8042, 5
br label %LSJ8040
LSJ8040:
%t8044 = phi i1 [ true, %LSL8040 ], [ %t8043, %LSR8040 ]
br i1 %t8044, label %L910, label %L912
L910:
ret ptr @.s8045
L912:
%t8046 = getelementptr i8, ptr %t8036, i64 24
%t8047 = load i64, ptr %t8046, align 8
%t8048 = getelementptr i8, ptr %t8036, i64 16
%t8049 = load i64, ptr %t8048, align 8
%t8050 = call ptr @cose_kid_scan(ptr %p0, i64 %t8047, i64 %t8049)
ret ptr %t8050
}
define ptr @cose_kid_scan(ptr %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8129, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8130, %tco.s0.k ]
%t8051 = icmp sle i64 %p2, 0
br i1 %t8051, label %L913, label %L915
L913:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr @.s8052
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_str(ptr @.s8052, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L915:
%t8053 = call ptr @cbe_read_head(ptr %p0, i64 %p1)
%t8054 = getelementptr i8, ptr %t8053, i64 0
%t8055 = load i1, ptr %t8054, align 8
%t8056 = xor i1 %t8055, true
br i1 %t8056, label %L916, label %L918
L916:
%lr.cx18 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz18 = icmp eq ptr %lr.cx18, null
br i1 %lr.lz18, label %lr.x18.k, label %lr.x18.m
lr.x18.k:
ret ptr @.s8057
lr.x18.m:
%lr.ret18 = call ptr @resid_mv_str(ptr @.s8057, ptr %lr.cx18)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret18
L918:
%t8058 = getelementptr i8, ptr %t8053, i64 24
%t8059 = load i64, ptr %t8058, align 8
%t8060 = call ptr @cbe_read_head(ptr %p0, i64 %t8059)
%t8061 = getelementptr i8, ptr %t8060, i64 0
%t8062 = load i1, ptr %t8061, align 8
%t8063 = xor i1 %t8062, true
br i1 %t8063, label %L919, label %L921
L919:
%lr.cx28 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz28 = icmp eq ptr %lr.cx28, null
br i1 %lr.lz28, label %lr.x28.k, label %lr.x28.m
lr.x28.k:
ret ptr @.s8064
lr.x28.m:
%lr.ret28 = call ptr @resid_mv_str(ptr @.s8064, ptr %lr.cx28)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret28
L921:
%t8065 = getelementptr i8, ptr %t8053, i64 8
%t8066 = load i64, ptr %t8065, align 8
%t8067 = icmp eq i64 %t8066, 0
br label %LSL8068
LSL8068:
br i1 %t8067, label %LSR8068, label %LSJ8068
LSR8068:
%t8069 = getelementptr i8, ptr %t8053, i64 16
%t8070 = load i64, ptr %t8069, align 8
%t8071 = icmp eq i64 %t8070, 4
br label %LSJ8068
LSJ8068:
%t8072 = phi i1 [ false, %LSL8068 ], [ %t8071, %LSR8068 ]
br label %LSL8073
LSL8073:
br i1 %t8072, label %LSR8073, label %LSJ8073
LSR8073:
%t8074 = getelementptr i8, ptr %t8060, i64 8
%t8075 = load i64, ptr %t8074, align 8
%t8076 = icmp eq i64 %t8075, 2
br label %LSJ8073
LSJ8073:
%t8077 = phi i1 [ false, %LSL8073 ], [ %t8076, %LSR8073 ]
br i1 %t8077, label %L922, label %L924
L922:
%t8078 = getelementptr i8, ptr %t8053, i64 24
%t8079 = load i64, ptr %t8078, align 8
%t8080 = call ptr @cbe_read_str(ptr %p0, i64 %t8079, i64 2)
%t8081 = getelementptr i8, ptr %t8080, i64 8
%t8082 = load ptr, ptr %t8081, align 8
%t8084 = call ptr @cbe_ascii(ptr %t8082, i64 0, ptr @.s8083)
%lr.cx61 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz61 = icmp eq ptr %lr.cx61, null
br i1 %lr.lz61, label %lr.x61.k, label %lr.x61.m
lr.x61.k:
ret ptr %t8084
lr.x61.m:
%lr.ret61 = call ptr @resid_mv_str(ptr %t8084, ptr %lr.cx61)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret61
L924:
%t8085 = getelementptr i8, ptr %t8060, i64 8
%t8086 = load i64, ptr %t8085, align 8
%t8087 = icmp eq i64 %t8086, 2
br label %LSL8088
LSL8088:
br i1 %t8087, label %LSJ8088, label %LSR8088
LSR8088:
%t8089 = getelementptr i8, ptr %t8060, i64 8
%t8090 = load i64, ptr %t8089, align 8
%t8091 = icmp eq i64 %t8090, 3
br label %LSJ8088
LSJ8088:
%t8092 = phi i1 [ true, %LSL8088 ], [ %t8091, %LSR8088 ]
br label %LSL8093
LSL8093:
br i1 %t8092, label %LSR8093, label %LSJ8093
LSR8093:
%t8094 = getelementptr i8, ptr %t8060, i64 16
%t8095 = load i64, ptr %t8094, align 8
%t8096 = icmp slt i64 %t8095, 0
br label %LSL8097
LSL8097:
br i1 %t8096, label %LSJ8097, label %LSR8097
LSR8097:
%t8098 = getelementptr i8, ptr %t8060, i64 16
%t8099 = load i64, ptr %t8098, align 8
%t8100 = call i64 @resid_list_len(ptr %p0)
%t8101 = getelementptr i8, ptr %t8060, i64 24
%t8102 = load i64, ptr %t8101, align 8
%t8103 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t8100, i64 %t8102)
%t8104 = extractvalue {i64, i1} %t8103, 0
%t8105 = extractvalue {i64, i1} %t8103, 1
%t8106 = zext i1 %t8105 to i8
call void @resid_overflow_check(i8 %t8106)
%t8107 = icmp sgt i64 %t8099, %t8104
br label %LSJ8097
LSJ8097:
%t8108 = phi i1 [ true, %LSL8097 ], [ %t8107, %LSR8097 ]
br label %LSJ8093
LSJ8093:
%t8109 = phi i1 [ false, %LSL8093 ], [ %t8108, %LSJ8097 ]
br i1 %t8109, label %L925, label %L927
L925:
%lr.cx106 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz106 = icmp eq ptr %lr.cx106, null
br i1 %lr.lz106, label %lr.x106.k, label %lr.x106.m
lr.x106.k:
ret ptr @.s8110
lr.x106.m:
%lr.ret106 = call ptr @resid_mv_str(ptr @.s8110, ptr %lr.cx106)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret106
L927:
%t8111 = getelementptr i8, ptr %t8060, i64 8
%t8112 = load i64, ptr %t8111, align 8
%t8113 = icmp eq i64 %t8112, 2
br label %LSL8114
LSL8114:
br i1 %t8113, label %LSJ8114, label %LSR8114
LSR8114:
%t8115 = getelementptr i8, ptr %t8060, i64 8
%t8116 = load i64, ptr %t8115, align 8
%t8117 = icmp eq i64 %t8116, 3
br label %LSJ8114
LSJ8114:
%t8118 = phi i1 [ true, %LSL8114 ], [ %t8117, %LSR8114 ]
br i1 %t8118, label %L928, label %L929
L928:
%t8119 = getelementptr i8, ptr %t8060, i64 24
%t8120 = load i64, ptr %t8119, align 8
%t8121 = getelementptr i8, ptr %t8060, i64 16
%t8122 = load i64, ptr %t8121, align 8
%t8123 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t8120, i64 %t8122)
%t8124 = extractvalue {i64, i1} %t8123, 0
%t8125 = extractvalue {i64, i1} %t8123, 1
%t8126 = zext i1 %t8125 to i8
call void @resid_overflow_check(i8 %t8126)
br label %L930
L929:
%t8127 = getelementptr i8, ptr %t8060, i64 24
%t8128 = load i64, ptr %t8127, align 8
br label %L930
L930:
%t8129 = phi i64 [ %t8124, %L928 ], [ %t8128, %L929 ]
%t8130 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
br label %tco.head
}
define ptr @cose_sign1_parse(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8132 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t8133 = getelementptr i8, ptr %t8132, i64 0
%t8134 = load i1, ptr %t8133, align 8
%t8135 = xor i1 %t8134, true
br label %LSL8136
LSL8136:
br i1 %t8135, label %LSJ8136, label %LSR8136
LSR8136:
%t8137 = getelementptr i8, ptr %t8132, i64 8
%t8138 = load i64, ptr %t8137, align 8
%t8139 = icmp ne i64 %t8138, 6
br label %LSJ8136
LSJ8136:
%t8140 = phi i1 [ true, %LSL8136 ], [ %t8139, %LSR8136 ]
br label %LSL8141
LSL8141:
br i1 %t8140, label %LSJ8141, label %LSR8141
LSR8141:
%t8142 = getelementptr i8, ptr %t8132, i64 16
%t8143 = load i64, ptr %t8142, align 8
%t8144 = icmp ne i64 %t8143, 18
br label %LSJ8141
LSJ8141:
%t8145 = phi i1 [ true, %LSL8141 ], [ %t8144, %LSR8141 ]
br i1 %t8145, label %L931, label %L933
L931:
%t8147 = musttail call ptr @cose_sign1_err(ptr @.s8146)
ret ptr %t8147
L933:
%t8148 = getelementptr i8, ptr %t8132, i64 24
%t8149 = load i64, ptr %t8148, align 8
%t8150 = call ptr @cbe_read_head(ptr %p0, i64 %t8149)
%t8151 = getelementptr i8, ptr %t8150, i64 0
%t8152 = load i1, ptr %t8151, align 8
%t8153 = xor i1 %t8152, true
br label %LSL8154
LSL8154:
br i1 %t8153, label %LSJ8154, label %LSR8154
LSR8154:
%t8155 = getelementptr i8, ptr %t8150, i64 8
%t8156 = load i64, ptr %t8155, align 8
%t8157 = icmp ne i64 %t8156, 4
br label %LSJ8154
LSJ8154:
%t8158 = phi i1 [ true, %LSL8154 ], [ %t8157, %LSR8154 ]
br label %LSL8159
LSL8159:
br i1 %t8158, label %LSJ8159, label %LSR8159
LSR8159:
%t8160 = getelementptr i8, ptr %t8150, i64 16
%t8161 = load i64, ptr %t8160, align 8
%t8162 = icmp ne i64 %t8161, 4
br label %LSJ8159
LSJ8159:
%t8163 = phi i1 [ true, %LSL8159 ], [ %t8162, %LSR8159 ]
br i1 %t8163, label %L934, label %L936
L934:
%t8165 = musttail call ptr @cose_sign1_err(ptr @.s8164)
ret ptr %t8165
L936:
%t8166 = getelementptr i8, ptr %t8150, i64 24
%t8167 = load i64, ptr %t8166, align 8
%t8168 = call ptr @cbe_read_str(ptr %p0, i64 %t8167, i64 2)
%t8169 = getelementptr i8, ptr %t8168, i64 0
%t8170 = load i1, ptr %t8169, align 8
%t8171 = xor i1 %t8170, true
br i1 %t8171, label %L937, label %L939
L937:
%t8173 = musttail call ptr @cose_sign1_err(ptr @.s8172)
ret ptr %t8173
L939:
%t8174 = getelementptr i8, ptr %t8168, i64 16
%t8175 = load i64, ptr %t8174, align 8
%t8176 = call ptr @cbe_read_head(ptr %p0, i64 %t8175)
%t8177 = getelementptr i8, ptr %t8176, i64 0
%t8178 = load i1, ptr %t8177, align 8
%t8179 = xor i1 %t8178, true
br label %LSL8180
LSL8180:
br i1 %t8179, label %LSJ8180, label %LSR8180
LSR8180:
%t8181 = getelementptr i8, ptr %t8176, i64 8
%t8182 = load i64, ptr %t8181, align 8
%t8183 = icmp ne i64 %t8182, 5
br label %LSJ8180
LSJ8180:
%t8184 = phi i1 [ true, %LSL8180 ], [ %t8183, %LSR8180 ]
br label %LSL8185
LSL8185:
br i1 %t8184, label %LSJ8185, label %LSR8185
LSR8185:
%t8186 = getelementptr i8, ptr %t8176, i64 16
%t8187 = load i64, ptr %t8186, align 8
%t8188 = icmp ne i64 %t8187, 0
br label %LSJ8185
LSJ8185:
%t8189 = phi i1 [ true, %LSL8185 ], [ %t8188, %LSR8185 ]
br i1 %t8189, label %L940, label %L942
L940:
%t8191 = musttail call ptr @cose_sign1_err(ptr @.s8190)
ret ptr %t8191
L942:
%t8192 = getelementptr i8, ptr %t8176, i64 24
%t8193 = load i64, ptr %t8192, align 8
%t8194 = call ptr @cbe_read_str(ptr %p0, i64 %t8193, i64 2)
%t8195 = getelementptr i8, ptr %t8194, i64 0
%t8196 = load i1, ptr %t8195, align 8
%t8197 = xor i1 %t8196, true
br i1 %t8197, label %L943, label %L945
L943:
%t8199 = musttail call ptr @cose_sign1_err(ptr @.s8198)
ret ptr %t8199
L945:
%t8200 = getelementptr i8, ptr %t8194, i64 16
%t8201 = load i64, ptr %t8200, align 8
%t8202 = call ptr @cbe_read_str(ptr %p0, i64 %t8201, i64 2)
%t8203 = getelementptr i8, ptr %t8202, i64 0
%t8204 = load i1, ptr %t8203, align 8
%t8205 = xor i1 %t8204, true
br label %LSL8206
LSL8206:
br i1 %t8205, label %LSJ8206, label %LSR8206
LSR8206:
%t8207 = getelementptr i8, ptr %t8202, i64 8
%t8208 = load ptr, ptr %t8207, align 8
%t8209 = call i64 @resid_list_len(ptr %t8208)
%t8210 = icmp ne i64 %t8209, 64
br label %LSJ8206
LSJ8206:
%t8211 = phi i1 [ true, %LSL8206 ], [ %t8210, %LSR8206 ]
br i1 %t8211, label %L946, label %L948
L946:
%t8213 = musttail call ptr @cose_sign1_err(ptr @.s8212)
ret ptr %t8213
L948:
%t8214 = call ptr @resid_gmalloc(i64 48)
%t8214.f0 = getelementptr i8, ptr %t8214, i64 0
store i1 true, ptr %t8214.f0, align 8
%t8214.f1 = getelementptr i8, ptr %t8214, i64 8
store ptr @.s8215, ptr %t8214.f1, align 8
%t8216 = getelementptr i8, ptr %t8168, i64 8
%t8217 = load ptr, ptr %t8216, align 8
%t8218 = call ptr @cose_kid_of(ptr %t8217)
%t8214.f2 = getelementptr i8, ptr %t8214, i64 16
store ptr %t8218, ptr %t8214.f2, align 8
%t8219 = getelementptr i8, ptr %t8168, i64 8
%t8220 = load ptr, ptr %t8219, align 8
%t8214.f3 = getelementptr i8, ptr %t8214, i64 24
store ptr %t8220, ptr %t8214.f3, align 8
%t8221 = getelementptr i8, ptr %t8194, i64 8
%t8222 = load ptr, ptr %t8221, align 8
%t8214.f4 = getelementptr i8, ptr %t8214, i64 32
store ptr %t8222, ptr %t8214.f4, align 8
%t8223 = getelementptr i8, ptr %t8202, i64 8
%t8224 = load ptr, ptr %t8223, align 8
%t8214.f5 = getelementptr i8, ptr %t8214, i64 40
store ptr %t8224, ptr %t8214.f5, align 8
ret ptr %t8214
}
define i1 @cose_sign1_check(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8225 = getelementptr i8, ptr %p0, i64 24
%t8226 = load ptr, ptr %t8225, align 8
%t8227 = getelementptr i8, ptr %p0, i64 32
%t8228 = load ptr, ptr %t8227, align 8
%t8229 = call ptr @cose_sig_structure(ptr %t8226, ptr %t8228)
%t8230 = call ptr @resid_list_freeze(ptr %t8229)
%t8231 = getelementptr i8, ptr %p0, i64 40
%t8232 = load ptr, ptr %t8231, align 8
%t8233 = call i1 @verify_sig_bytes(ptr %t8230, ptr %t8232, ptr %p1)
ret i1 %t8233
}
define ptr @cose_enc_structure(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8235 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty8234)
%t8237 = call ptr @resid_list_const_i64(ptr @.lc8236, i64 10, ptr @.lcd8236, ptr @.lty8236)
%t8238 = call ptr @cbe_bytes(ptr %p0, ptr %t8237)
%t8239 = call ptr @cbe_bytes(ptr %t8235, ptr %t8238)
ret ptr %t8239
}
define ptr @cose_encrypt0_protected() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8241 = call ptr @resid_list_const_i64(ptr @.lc8240, i64 4, ptr @.lcd8240, ptr @.lty8240)
ret ptr %t8241
}
define ptr @cose_encrypt0_nonce(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8243 = call ptr @resid_list_const_i64(ptr @.lc8242, i64 25, ptr @.lcd8242, ptr @.lty8242)
%t8244 = call ptr @resid_list_concat(ptr %t8243, ptr %p0)
%t8245 = call ptr @bytes_of(ptr %p1)
%t8246 = call ptr @resid_list_freeze(ptr %t8245)
%t8247 = call ptr @resid_list_concat_own(ptr %t8244, i8 1, ptr %t8246)
%t8248 = call ptr @resid_list_concat_own(ptr %t8247, i8 1, ptr %p2)
%t8249 = call ptr @sha256_bytes(ptr %t8248)
%t8250 = call ptr @slice_bytes(ptr %t8249, i64 0, i64 11)
ret ptr %t8250
}
define ptr @cose_encrypt0_seal(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8251 = call ptr @cose_encrypt0_nonce(ptr %p1, ptr %p2, ptr %p0)
%t8252 = call ptr @resid_list_freeze(ptr %t8251)
%t8254 = call ptr @resid_list_const_i64(ptr @.lc8253, i64 16, ptr @.lcd8253, ptr @.lty8253)
%t8255 = call ptr @chacha20poly1305_seal(ptr %p1, ptr %t8252, ptr %p0, ptr %t8254)
%t8256 = call ptr @resid_list_freeze(ptr %t8255)
%t8258 = call ptr @resid_list_const_i64(ptr @.lc8257, i64 9, ptr @.lcd8257, ptr @.lty8257)
%t8259 = call ptr @cbe_bytes(ptr %t8252, ptr %t8258)
%t8260 = call ptr @cbe_bytes(ptr %t8256, ptr %t8259)
ret ptr %t8260
}
define ptr @cose_open_err(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8261 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB8261)
%t8262 = call ptr @resid_gmalloc(i64 24)
%t8262.f0 = getelementptr i8, ptr %t8262, i64 0
store i1 false, ptr %t8262.f0, align 8
%t8262.f1 = getelementptr i8, ptr %t8262, i64 8
store ptr %p0, ptr %t8262.f1, align 8
%t8262.f2 = getelementptr i8, ptr %t8262, i64 16
store ptr %t8261, ptr %t8262.f2, align 8
ret ptr %t8262
}
define i1 @cose_is_encrypt0(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8263 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t8264 = getelementptr i8, ptr %t8263, i64 0
%t8265 = load i1, ptr %t8264, align 8
br label %LSL8266
LSL8266:
br i1 %t8265, label %LSR8266, label %LSJ8266
LSR8266:
%t8267 = getelementptr i8, ptr %t8263, i64 8
%t8268 = load i64, ptr %t8267, align 8
%t8269 = icmp eq i64 %t8268, 6
br label %LSJ8266
LSJ8266:
%t8270 = phi i1 [ false, %LSL8266 ], [ %t8269, %LSR8266 ]
br label %LSL8271
LSL8271:
br i1 %t8270, label %LSR8271, label %LSJ8271
LSR8271:
%t8272 = getelementptr i8, ptr %t8263, i64 16
%t8273 = load i64, ptr %t8272, align 8
%t8274 = icmp eq i64 %t8273, 16
br label %LSJ8271
LSJ8271:
%t8275 = phi i1 [ false, %LSL8271 ], [ %t8274, %LSR8271 ]
ret i1 %t8275
}
define ptr @cose_encrypt0_open(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8276 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t8277 = getelementptr i8, ptr %t8276, i64 0
%t8278 = load i1, ptr %t8277, align 8
%t8279 = xor i1 %t8278, true
br label %LSL8280
LSL8280:
br i1 %t8279, label %LSJ8280, label %LSR8280
LSR8280:
%t8281 = getelementptr i8, ptr %t8276, i64 8
%t8282 = load i64, ptr %t8281, align 8
%t8283 = icmp ne i64 %t8282, 6
br label %LSJ8280
LSJ8280:
%t8284 = phi i1 [ true, %LSL8280 ], [ %t8283, %LSR8280 ]
br label %LSL8285
LSL8285:
br i1 %t8284, label %LSJ8285, label %LSR8285
LSR8285:
%t8286 = getelementptr i8, ptr %t8276, i64 16
%t8287 = load i64, ptr %t8286, align 8
%t8288 = icmp ne i64 %t8287, 16
br label %LSJ8285
LSJ8285:
%t8289 = phi i1 [ true, %LSL8285 ], [ %t8288, %LSR8285 ]
br i1 %t8289, label %L949, label %L951
L949:
%t8291 = call ptr @cose_open_err(ptr @.s8290)
ret ptr %t8291
L951:
%t8292 = getelementptr i8, ptr %t8276, i64 24
%t8293 = load i64, ptr %t8292, align 8
%t8294 = call ptr @cbe_read_head(ptr %p0, i64 %t8293)
%t8295 = getelementptr i8, ptr %t8294, i64 0
%t8296 = load i1, ptr %t8295, align 8
%t8297 = xor i1 %t8296, true
br label %LSL8298
LSL8298:
br i1 %t8297, label %LSJ8298, label %LSR8298
LSR8298:
%t8299 = getelementptr i8, ptr %t8294, i64 8
%t8300 = load i64, ptr %t8299, align 8
%t8301 = icmp ne i64 %t8300, 4
br label %LSJ8298
LSJ8298:
%t8302 = phi i1 [ true, %LSL8298 ], [ %t8301, %LSR8298 ]
br label %LSL8303
LSL8303:
br i1 %t8302, label %LSJ8303, label %LSR8303
LSR8303:
%t8304 = getelementptr i8, ptr %t8294, i64 16
%t8305 = load i64, ptr %t8304, align 8
%t8306 = icmp ne i64 %t8305, 3
br label %LSJ8303
LSJ8303:
%t8307 = phi i1 [ true, %LSL8303 ], [ %t8306, %LSR8303 ]
br i1 %t8307, label %L952, label %L954
L952:
%t8309 = call ptr @cose_open_err(ptr @.s8308)
ret ptr %t8309
L954:
%t8310 = getelementptr i8, ptr %t8294, i64 24
%t8311 = load i64, ptr %t8310, align 8
%t8312 = call ptr @cbe_read_str(ptr %p0, i64 %t8311, i64 2)
call void @"resid.rec.freeze.CbeStr"(ptr %t8312)
%t8313 = getelementptr i8, ptr %t8312, i64 0
%t8314 = load i1, ptr %t8313, align 8
%t8315 = xor i1 %t8314, true
br i1 %t8315, label %L955, label %L957
L955:
%t8317 = call ptr @cose_open_err(ptr @.s8316)
ret ptr %t8317
L957:
%t8318 = getelementptr i8, ptr %t8312, i64 16
%t8319 = load i64, ptr %t8318, align 8
%t8320 = call ptr @cbe_read_head(ptr %p0, i64 %t8319)
%t8321 = getelementptr i8, ptr %t8320, i64 0
%t8322 = load i1, ptr %t8321, align 8
%t8323 = xor i1 %t8322, true
br label %LSL8324
LSL8324:
br i1 %t8323, label %LSJ8324, label %LSR8324
LSR8324:
%t8325 = getelementptr i8, ptr %t8320, i64 8
%t8326 = load i64, ptr %t8325, align 8
%t8327 = icmp ne i64 %t8326, 5
br label %LSJ8324
LSJ8324:
%t8328 = phi i1 [ true, %LSL8324 ], [ %t8327, %LSR8324 ]
br label %LSL8329
LSL8329:
br i1 %t8328, label %LSJ8329, label %LSR8329
LSR8329:
%t8330 = getelementptr i8, ptr %t8320, i64 16
%t8331 = load i64, ptr %t8330, align 8
%t8332 = icmp ne i64 %t8331, 1
br label %LSJ8329
LSJ8329:
%t8333 = phi i1 [ true, %LSL8329 ], [ %t8332, %LSR8329 ]
br i1 %t8333, label %L958, label %L960
L958:
%t8335 = call ptr @cose_open_err(ptr @.s8334)
ret ptr %t8335
L960:
%t8336 = getelementptr i8, ptr %t8320, i64 24
%t8337 = load i64, ptr %t8336, align 8
%t8338 = call ptr @cbe_read_head(ptr %p0, i64 %t8337)
%t8339 = getelementptr i8, ptr %t8338, i64 0
%t8340 = load i1, ptr %t8339, align 8
%t8341 = xor i1 %t8340, true
br label %LSL8342
LSL8342:
br i1 %t8341, label %LSJ8342, label %LSR8342
LSR8342:
%t8343 = getelementptr i8, ptr %t8338, i64 8
%t8344 = load i64, ptr %t8343, align 8
%t8345 = icmp ne i64 %t8344, 0
br label %LSJ8342
LSJ8342:
%t8346 = phi i1 [ true, %LSL8342 ], [ %t8345, %LSR8342 ]
br label %LSL8347
LSL8347:
br i1 %t8346, label %LSJ8347, label %LSR8347
LSR8347:
%t8348 = getelementptr i8, ptr %t8338, i64 16
%t8349 = load i64, ptr %t8348, align 8
%t8350 = icmp ne i64 %t8349, 5
br label %LSJ8347
LSJ8347:
%t8351 = phi i1 [ true, %LSL8347 ], [ %t8350, %LSR8347 ]
br i1 %t8351, label %L961, label %L963
L961:
%t8353 = call ptr @cose_open_err(ptr @.s8352)
ret ptr %t8353
L963:
%t8354 = getelementptr i8, ptr %t8338, i64 24
%t8355 = load i64, ptr %t8354, align 8
%t8356 = call ptr @cbe_read_str(ptr %p0, i64 %t8355, i64 2)
%t8357 = getelementptr i8, ptr %t8356, i64 0
%t8358 = load i1, ptr %t8357, align 8
%t8359 = xor i1 %t8358, true
br label %LSL8360
LSL8360:
br i1 %t8359, label %LSJ8360, label %LSR8360
LSR8360:
%t8361 = getelementptr i8, ptr %t8356, i64 8
%t8362 = load ptr, ptr %t8361, align 8
%t8363 = call i64 @resid_list_len(ptr %t8362)
%t8364 = icmp ne i64 %t8363, 12
br label %LSJ8360
LSJ8360:
%t8365 = phi i1 [ true, %LSL8360 ], [ %t8364, %LSR8360 ]
br i1 %t8365, label %L964, label %L966
L964:
%t8367 = call ptr @cose_open_err(ptr @.s8366)
ret ptr %t8367
L966:
%t8368 = getelementptr i8, ptr %t8356, i64 16
%t8369 = load i64, ptr %t8368, align 8
%t8370 = call ptr @cbe_read_str(ptr %p0, i64 %t8369, i64 2)
%t8371 = getelementptr i8, ptr %t8370, i64 0
%t8372 = load i1, ptr %t8371, align 8
%t8373 = xor i1 %t8372, true
br label %LSL8374
LSL8374:
br i1 %t8373, label %LSJ8374, label %LSR8374
LSR8374:
%t8375 = getelementptr i8, ptr %t8370, i64 8
%t8376 = load ptr, ptr %t8375, align 8
%t8377 = call i64 @resid_list_len(ptr %t8376)
%t8378 = icmp slt i64 %t8377, 16
br label %LSJ8374
LSJ8374:
%t8379 = phi i1 [ true, %LSL8374 ], [ %t8378, %LSR8374 ]
br i1 %t8379, label %L967, label %L969
L967:
%t8381 = call ptr @cose_open_err(ptr @.s8380)
ret ptr %t8381
L969:
%t8382 = call i64 @resid_scope_push()
%t8383 = getelementptr i8, ptr %t8356, i64 8
%t8384 = load ptr, ptr %t8383, align 8
%t8385 = getelementptr i8, ptr %t8370, i64 8
%t8386 = load ptr, ptr %t8385, align 8
%t8387 = getelementptr i8, ptr %t8312, i64 8
%t8388 = load ptr, ptr %t8387, align 8
%t8389 = call ptr @cose_enc_structure(ptr %t8388)
%t8390 = call ptr @resid_list_freeze(ptr %t8389)
%t8391 = call i1 @chacha20poly1305_open(ptr %p1, ptr %t8384, ptr %t8386, ptr %t8390)
call void @resid_scope_pop(i64 %t8382)
%t8392 = xor i1 %t8391, true
br i1 %t8392, label %L970, label %L972
L970:
%t8394 = call ptr @cose_open_err(ptr @.s8393)
ret ptr %t8394
L972:
%t8395 = getelementptr i8, ptr %t8370, i64 8
%t8396 = load ptr, ptr %t8395, align 8
%t8397 = getelementptr i8, ptr %t8370, i64 8
%t8398 = load ptr, ptr %t8397, align 8
%t8399 = call i64 @resid_list_len(ptr %t8398)
%t8400 = sub nsw i64 %t8399, 17
%t8401 = call ptr @slice_bytes(ptr %t8396, i64 0, i64 %t8400)
%t8402 = call ptr @resid_gmalloc(i64 24)
%t8402.f0 = getelementptr i8, ptr %t8402, i64 0
store i1 true, ptr %t8402.f0, align 8
%t8402.f1 = getelementptr i8, ptr %t8402, i64 8
store ptr @.s8403, ptr %t8402.f1, align 8
%t8404 = getelementptr i8, ptr %t8356, i64 8
%t8405 = load ptr, ptr %t8404, align 8
%t8406 = call ptr @chacha20_xor(ptr %p1, i64 1, ptr %t8405, ptr %t8401)
%t8402.f2 = getelementptr i8, ptr %t8402, i64 16
store ptr %t8406, ptr %t8402.f2, align 8
ret ptr %t8402
}
define i32 @resid_user_main() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
call void @resid_cap_check(ptr @resid.cap.main)
%t8407 = call ptr @resid_args_get(i64 1)
%t8408 = call ptr @cose_hex_decode(ptr %t8407)
%t8409 = call ptr @resid_list_freeze(ptr %t8408)
%t8410 = call ptr @bn_from_be(ptr %t8409)
%t8411 = call ptr @resid_list_freeze(ptr %t8410)
call void @resid_cap_check(ptr @resid.cap.main.1)
%t8412 = call ptr @resid_args_get(i64 2)
%t8413 = call ptr @cose_hex_decode(ptr %t8412)
%t8414 = call ptr @resid_list_freeze(ptr %t8413)
%t8415 = call ptr @bn_from_be(ptr %t8414)
%t8416 = call ptr @resid_list_freeze(ptr %t8415)
call void @resid_cap_check(ptr @resid.cap.main.2)
%t8417 = call ptr @resid_args_get(i64 3)
%t8418 = call ptr @cose_hex_decode(ptr %t8417)
%t8419 = call ptr @tr_new()
call void @"resid.rec.freeze.Transcript"(ptr %t8419)
%t8420 = call ptr @mod_prove(ptr %t8411, ptr %t8416, ptr %t8419, ptr %t8418)
%t8421 = getelementptr {i32, i32, ptr}, ptr %t8420, i32 0, i32 0
%t8422w = load i32, ptr %t8421
%t8422 = sext i32 %t8422w to i64
%t8423 = icmp eq i64 %t8422, 1
br i1 %t8423, label %L974, label %L973
L973:
br label %L975
L974:
%t8424 = getelementptr {i32, i32, ptr}, ptr %t8420, i32 1
%t8425 = getelementptr i8, ptr %t8424, i64 0
%t8426 = getelementptr ptr, ptr %t8425, i32 0
%t8427 = load ptr, ptr %t8426
%t8428 = getelementptr i8, ptr %t8427, i64 8
%t8429 = load ptr, ptr %t8428, align 8
%t8430 = call i64 @resid_list_len(ptr %t8429)
br label %L975
L975:
%t8431 = phi i64 [ 2, %L973 ], [ %t8430, %L974 ]
%t8432 = trunc i64 %t8431 to i32
ret i32 %t8432
}
define ptr @sha256g_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8433 = call ptr @resid_list_get(ptr %p2, i64 0)
%t8434 = call i64 @resid_unbox_i64(ptr %t8433)
%t8436 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8434, i64 4294967295)
%t8437 = call ptr @resid_list_get(ptr %p2, i64 1)
%t8438 = call i64 @resid_unbox_i64(ptr %t8437)
%t8440 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8438, i64 4294967295)
%t8441 = call ptr @resid_list_get(ptr %p2, i64 2)
%t8442 = call i64 @resid_unbox_i64(ptr %t8441)
%t8444 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8442, i64 4294967295)
%t8445 = call ptr @resid_list_get(ptr %p2, i64 3)
%t8446 = call i64 @resid_unbox_i64(ptr %t8445)
%t8448 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8446, i64 4294967295)
%t8449 = call ptr @resid_list_get(ptr %p2, i64 4)
%t8450 = call i64 @resid_unbox_i64(ptr %t8449)
%t8452 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8450, i64 4294967295)
%t8453 = call ptr @resid_list_get(ptr %p2, i64 5)
%t8454 = call i64 @resid_unbox_i64(ptr %t8453)
%t8456 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8454, i64 4294967295)
%t8457 = call ptr @resid_list_get(ptr %p2, i64 6)
%t8458 = call i64 @resid_unbox_i64(ptr %t8457)
%t8460 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8458, i64 4294967295)
%t8461 = call ptr @resid_list_get(ptr %p2, i64 7)
%t8462 = call i64 @resid_unbox_i64(ptr %t8461)
%t8464 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8462, i64 4294967295)
%t8465 = call ptr @__m____________lib_sha256g_resid__g_blk__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 0, ptr %p2, i64 %t8436, i64 %t8440, i64 %t8444, i64 %t8448, i64 %t8452, i64 %t8456, i64 %t8460, i64 %t8464, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
ret ptr %t8465
}
define ptr @base64g_decode__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8466 = call i64 @resid_list_len(ptr %p0)
%t8467 = srem i64 %t8466, 4
%t8468 = icmp sgt i64 %t8466, 0
br label %LSL8469
LSL8469:
br i1 %t8468, label %LSR8469, label %LSJ8469
LSR8469:
%t8470 = icmp eq i64 %t8467, 0
br label %LSL8471
LSL8471:
br i1 %t8470, label %LSR8471, label %LSJ8471
LSR8471:
%t8472 = icmp eq i64 %p1, 0
br label %LSJ8471
LSJ8471:
%t8473 = phi i1 [ false, %LSL8471 ], [ %t8472, %LSR8471 ]
br label %LSL8474
LSL8474:
br i1 %t8473, label %LSJ8474, label %LSR8474
LSR8474:
%t8475 = icmp eq i64 %t8467, 2
br label %LSL8476
LSL8476:
br i1 %t8475, label %LSR8476, label %LSJ8476
LSR8476:
%t8477 = icmp eq i64 %p1, 2
br label %LSJ8476
LSJ8476:
%t8478 = phi i1 [ false, %LSL8476 ], [ %t8477, %LSR8476 ]
br label %LSJ8474
LSJ8474:
%t8479 = phi i1 [ true, %LSL8474 ], [ %t8478, %LSJ8476 ]
br label %LSL8480
LSL8480:
br i1 %t8479, label %LSJ8480, label %LSR8480
LSR8480:
%t8481 = icmp eq i64 %t8467, 3
br label %LSL8482
LSL8482:
br i1 %t8481, label %LSR8482, label %LSJ8482
LSR8482:
%t8483 = icmp eq i64 %p1, 1
br label %LSJ8482
LSJ8482:
%t8484 = phi i1 [ false, %LSL8482 ], [ %t8483, %LSR8482 ]
br label %LSJ8480
LSJ8480:
%t8485 = phi i1 [ true, %LSL8480 ], [ %t8484, %LSJ8482 ]
br label %LSJ8469
LSJ8469:
%t8486 = phi i1 [ false, %LSL8469 ], [ %t8485, %LSJ8480 ]
%t8487 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB8487)
%t8488 = xor i1 %t8486, true
br i1 %t8488, label %L976, label %L978
L976:
ret ptr %t8487
L978:
%t8489 = call ptr @resid_listbuf_new()
%t8490 = call ptr @__m____________lib_crypto_resid__b64g_groups__g_Int_64__Int_64_(ptr %p0, i64 0, i64 0, ptr %t8489)
ret ptr %t8490
}
define i512 @eg_fadd__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8491 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %p1)
%t8492 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t8493 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8491, i512 %t8492)
ret i512 %t8493
}
define i512 @eg_fsub__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8494 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t8495 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %t8494)
%t8496 = call i512 @__m____________lib_word_resid__pi_sub(i512 %t8495, i512 %p1)
%t8497 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t8498 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8496, i512 %t8497)
ret i512 %t8498
}
define i512 @eg_fmul__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8499 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %p0, i512 %p1)
%t8500 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8499, i512 115792089237316195423570985008687907853269984665640564039457584007913129639935)
%t8501 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t8499, i64 256)
%t8502 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %t8501, i512 38)
%t8503 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8500, i512 %t8502)
%t8504 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8503, i512 115792089237316195423570985008687907853269984665640564039457584007913129639935)
%t8505 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t8503, i64 256)
%t8506 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %t8505, i512 38)
%t8507 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8504, i512 %t8506)
%t8508 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8507, i512 115792089237316195423570985008687907853269984665640564039457584007913129639935)
%t8509 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t8507, i64 256)
%t8510 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %t8509, i512 38)
%t8511 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8508, i512 %t8510)
%t8512 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t8513 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8511, i512 %t8512)
%t8514 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t8515 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8513, i512 %t8514)
ret i512 %t8515
}
define i512 @eg_finv__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8516 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819947 to i512
%t8517 = call i512 @eg_fpow__g_Int_512__Int_64_(i512 1, i512 %p0, i512 %t8516, i64 254)
ret i512 %t8517
}
define i512 @eg_fpow__g_Int_512__Int_64_(i512 %p0.in, i512 %p1.in, i512 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %t8527, %tco.s0 ], [ %t8519, %tco.s1 ]
%p1 = phi i512 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i512 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t8528, %tco.s0 ], [ %t8530, %tco.s1 ]
%t8518 = icmp slt i64 %p3, 0
br i1 %t8518, label %L979, label %L981
L979:
ret i512 %p0
L981:
%t8519 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %p0, i512 %p0)
%t8520 = sext i64 %p3 to i512
%t8521 = icmp uge i512 %t8520, 512
%t8522 = add i512 %t8520, 0
%t8523 = select i1 %t8521, i512 511, i512 %t8522
%t8524 = ashr i512 %p2, %t8523
%t8525 = and i512 %t8524, 1
%t8526 = icmp eq i512 %t8525, 1
br i1 %t8526, label %L982, label %L984
L982:
%t8527 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8519, i512 %p1)
%t8528 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
L984:
%t8530 = sub nsw i64 %p3, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define ptr @eg_dbl__g_Int_512__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8532 = getelementptr i8, ptr %p0, i64 0
%t8533 = load i512, ptr %t8532, align 8
%t8534 = getelementptr i8, ptr %p0, i64 0
%t8535 = load i512, ptr %t8534, align 8
%t8536 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8533, i512 %t8535)
%t8537 = getelementptr i8, ptr %p0, i64 64
%t8538 = load i512, ptr %t8537, align 8
%t8539 = getelementptr i8, ptr %p0, i64 64
%t8540 = load i512, ptr %t8539, align 8
%t8541 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8538, i512 %t8540)
%t8542 = getelementptr i8, ptr %p0, i64 128
%t8543 = load i512, ptr %t8542, align 8
%t8544 = getelementptr i8, ptr %p0, i64 128
%t8545 = load i512, ptr %t8544, align 8
%t8546 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8543, i512 %t8545)
%t8547 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8546, i512 %t8546)
%t8548 = getelementptr i8, ptr %p0, i64 0
%t8549 = load i512, ptr %t8548, align 8
%t8550 = getelementptr i8, ptr %p0, i64 64
%t8551 = load i512, ptr %t8550, align 8
%t8552 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8549, i512 %t8551)
%t8553 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8552, i512 %t8552)
%t8554 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8553, i512 %t8536)
%t8555 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8554, i512 %t8541)
%t8556 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8541, i512 %t8536)
%t8557 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8556, i512 %t8547)
%t8558 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 0, i512 %t8536)
%t8559 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8558, i512 %t8541)
%t8560 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8555, i512 %t8557)
%t8561 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8556, i512 %t8559)
%t8562 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8557, i512 %t8556)
%t8563 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8555, i512 %t8559)
%t8564 = call ptr @resid_rec_reuse_sc(ptr %p0, i64 256)
%t8564.f0 = getelementptr i8, ptr %t8564, i64 0
store i512 %t8560, ptr %t8564.f0, align 8
%t8564.f8 = getelementptr i8, ptr %t8564, i64 64
store i512 %t8561, ptr %t8564.f8, align 8
%t8564.f16 = getelementptr i8, ptr %t8564, i64 128
store i512 %t8562, ptr %t8564.f16, align 8
%t8564.f24 = getelementptr i8, ptr %t8564, i64 192
store i512 %t8563, ptr %t8564.f24, align 8
ret ptr %t8564
}
define ptr @eg_add__g_Int_512__Int_64_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8565 = getelementptr i8, ptr %p0, i64 64
%t8566 = load i512, ptr %t8565, align 8
%t8567 = getelementptr i8, ptr %p0, i64 0
%t8568 = load i512, ptr %t8567, align 8
%t8569 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8566, i512 %t8568)
%t8570 = getelementptr i8, ptr %p1, i64 64
%t8571 = load i512, ptr %t8570, align 8
%t8572 = getelementptr i8, ptr %p1, i64 0
%t8573 = load i512, ptr %t8572, align 8
%t8574 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8571, i512 %t8573)
%t8575 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8569, i512 %t8574)
%t8576 = getelementptr i8, ptr %p0, i64 64
%t8577 = load i512, ptr %t8576, align 8
%t8578 = getelementptr i8, ptr %p0, i64 0
%t8579 = load i512, ptr %t8578, align 8
%t8580 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8577, i512 %t8579)
%t8581 = getelementptr i8, ptr %p1, i64 64
%t8582 = load i512, ptr %t8581, align 8
%t8583 = getelementptr i8, ptr %p1, i64 0
%t8584 = load i512, ptr %t8583, align 8
%t8585 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8582, i512 %t8584)
%t8586 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8580, i512 %t8585)
%t8587 = getelementptr i8, ptr %p0, i64 192
%t8588 = load i512, ptr %t8587, align 8
%t8589 = getelementptr i8, ptr %p0, i64 192
%t8590 = load i512, ptr %t8589, align 8
%t8591 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8588, i512 %t8590)
%t8592 = sext i256 37095705934669439343138083508754565189542113879843219016388785533085940283555 to i512
%t8593 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8591, i512 %t8592)
%t8594 = getelementptr i8, ptr %p1, i64 192
%t8595 = load i512, ptr %t8594, align 8
%t8596 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8593, i512 %t8595)
%t8597 = getelementptr i8, ptr %p0, i64 128
%t8598 = load i512, ptr %t8597, align 8
%t8599 = getelementptr i8, ptr %p0, i64 128
%t8600 = load i512, ptr %t8599, align 8
%t8601 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8598, i512 %t8600)
%t8602 = getelementptr i8, ptr %p1, i64 128
%t8603 = load i512, ptr %t8602, align 8
%t8604 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8601, i512 %t8603)
%t8605 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8586, i512 %t8575)
%t8606 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8604, i512 %t8596)
%t8607 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8604, i512 %t8596)
%t8608 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8586, i512 %t8575)
%t8609 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8605, i512 %t8606)
%t8610 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8607, i512 %t8608)
%t8611 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8606, i512 %t8607)
%t8612 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8605, i512 %t8608)
%t8613 = call ptr @resid_rec_reuse_sc(ptr %p0, i64 256)
%t8613.f0 = getelementptr i8, ptr %t8613, i64 0
store i512 %t8609, ptr %t8613.f0, align 8
%t8613.f8 = getelementptr i8, ptr %t8613, i64 64
store i512 %t8610, ptr %t8613.f8, align 8
%t8613.f16 = getelementptr i8, ptr %t8613, i64 128
store i512 %t8611, ptr %t8613.f16, align 8
%t8613.f24 = getelementptr i8, ptr %t8613, i64 192
store i512 %t8612, ptr %t8613.f24, align 8
ret ptr %t8613
}
define ptr @eg_ladder__g_Int_512__Int_64_(i512 %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t8621, %tco.s0.k ]
%t8614 = icmp slt i64 %p3, 0
br i1 %t8614, label %L985, label %L987
L985:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p2
lr.x11.m:
%lr.ret11 = call ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %p2, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L987:
%t8615 = call ptr @eg_dbl__g_Int_512__Int_64_(ptr %p2)
call void @resid_rec_share(ptr %t8615)
%t8616 = sub nsw i64 511, %p3
%t8617 = call i512 @__m____________lib_word_resid__pi_shl(i512 %p0, i64 %t8616)
%t8618 = call i512 @__m____________lib_word_resid__pi_sign(i512 %t8617)
%t8619 = call ptr @eg_add__g_Int_512__Int_64_(ptr %t8615, ptr %p1)
call void @resid_rec_share(ptr %t8619)
%t8620 = call ptr @__m____________lib_ed25519g_resid__eg_sel__g_Int_512__Int_64_(i512 %t8618, ptr %t8619, ptr %t8615)
call void @resid_rec_share(ptr %t8620)
%t8621 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p1.e.tco.s0 = call ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %p1, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %t8620, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t8620, %tco.s0 ]
br label %tco.head
}
define ptr @eg_base_mul__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8623 = call ptr @eg_base__g_Int_512__Int_64_()
call void @resid_rec_share(ptr %t8623)
%t8624 = call ptr @eg_id__g_Int_512__Int_64_()
call void @resid_rec_share(ptr %t8624)
%t8625 = call ptr @eg_ladder__g_Int_512__Int_64_(i512 %p0, ptr %t8623, ptr %t8624, i64 255)
ret ptr %t8625
}
define ptr @eg_encode__g_Int_512__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8626 = getelementptr i8, ptr %p0, i64 128
%t8627 = load i512, ptr %t8626, align 8
%t8628 = call i512 @eg_finv__g_Int_512__Int_64_(i512 %t8627)
%t8629 = getelementptr i8, ptr %p0, i64 0
%t8630 = load i512, ptr %t8629, align 8
%t8631 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8630, i512 %t8628)
%t8632 = getelementptr i8, ptr %p0, i64 64
%t8633 = load i512, ptr %t8632, align 8
%t8634 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8633, i512 %t8628)
%t8635 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8631, i512 1)
%t8636 = call i512 @__m____________lib_word_resid__pi_shl(i512 %t8635, i64 255)
%t8637 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8634, i512 %t8636)
%t8638 = call ptr @resid_listbuf_new()
%t8639 = call ptr @eg_le_bytes__g_Int_512__Int_64_(i512 %t8637, i64 32, i64 0, ptr %t8638)
ret ptr %t8639
}
define i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8640 = call i512 @eg_le__g_Int_64__Int_512_(ptr %p0, i64 32, i64 32, i64 0, i512 0)
%t8641 = call i512 @eg_le__g_Int_64__Int_512_(ptr %p0, i64 0, i64 32, i64 0, i512 0)
%t8642 = call i512 @eg_fold_l__g_Int_512__Int_64_(i512 0, i512 %t8640, i64 255)
%t8643 = call i512 @eg_fold_l__g_Int_512__Int_64_(i512 %t8642, i512 %t8641, i64 255)
ret i512 %t8643
}
define ptr @eg_pt__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8644 = call ptr @resid_rec_new(i64 256, i8 1)
%t8644.f0 = getelementptr i8, ptr %t8644, i64 0
store i512 %p0, ptr %t8644.f0, align 8
%t8644.f8 = getelementptr i8, ptr %t8644, i64 64
store i512 %p1, ptr %t8644.f8, align 8
%t8644.f16 = getelementptr i8, ptr %t8644, i64 128
store i512 1, ptr %t8644.f16, align 8
%t8645 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %p0, i512 %p1)
%t8644.f24 = getelementptr i8, ptr %t8644, i64 192
store i512 %t8645, ptr %t8644.f24, align 8
ret ptr %t8644
}
define ptr @eg_id__g_Int_512__Int_64_() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8646 = call ptr @resid_rec_new(i64 256, i8 1)
%t8646.f0 = getelementptr i8, ptr %t8646, i64 0
store i512 0, ptr %t8646.f0, align 8
%t8646.f8 = getelementptr i8, ptr %t8646, i64 64
store i512 1, ptr %t8646.f8, align 8
%t8646.f16 = getelementptr i8, ptr %t8646, i64 128
store i512 1, ptr %t8646.f16, align 8
%t8646.f24 = getelementptr i8, ptr %t8646, i64 192
store i512 0, ptr %t8646.f24, align 8
ret ptr %t8646
}
define i512 @eg_clamp__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8647 = sext i256 28948022309329048855892746252171976963317496166410141009864396001978282409976 to i512
%t8648 = call i512 @__m____________lib_word_resid__pi_and(i512 %p0, i512 %t8647)
%t8649 = sext i256 28948022309329048855892746252171976963317496166410141009864396001978282409984 to i512
%t8650 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8648, i512 %t8649)
ret i512 %t8650
}
define ptr @ed25519g_pub__g_Int_64__Int_512__UInt_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8651 = call ptr @sha512g__g_Int_64__UInt_64_(ptr %p0)
%t8652 = call i512 @__m____________lib_ed25519g_resid__eg_scalar__g_Int_64__Int_512_(ptr %t8651)
%t8653 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t8652)
%t8654 = call ptr @eg_encode__g_Int_512__Int_64_(ptr %t8653)
%t8655 = musttail call ptr @__m____________lib_word_resid__wi_publish(ptr %t8654)
ret ptr %t8655
}
define ptr @ed25519g_sign__g_Int_64__Int_512__UInt_64_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8656 = call ptr @sha512g__g_Int_64__UInt_64_(ptr %p0)
%t8657 = call i512 @__m____________lib_ed25519g_resid__eg_scalar__g_Int_64__Int_512_(ptr %t8656)
%t8658 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t8657)
call void @resid_rec_share(ptr %t8658)
%t8659 = call ptr @eg_encode__g_Int_512__Int_64_(ptr %t8658)
%t8660 = call ptr @resid_list_freeze(ptr %t8659)
%t8661 = call ptr @__m____________lib_word_resid__wi_publish(ptr %t8660)
%t8662 = call ptr @resid_list_freeze(ptr %t8661)
%t8663 = call ptr @d_lift_bytes__g_Int_64__UInt_64_(ptr %p1)
%t8664 = call ptr @resid_list_freeze(ptr %t8663)
%t8665 = call i64 @resid_scope_push()
%t8666 = call ptr @resid_list_slice(ptr %t8656, i64 32, i64 64)
%t8668 = call ptr @resid_list_concat(ptr %t8666, ptr %t8664)
%t8669 = call ptr @sha512g__g_Int_64__UInt_64_(ptr %t8668)
%t8670 = call ptr @resid_list_freeze(ptr %t8669)
%t8671 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %t8670)
call void @resid_scope_pop(i64 %t8665)
%t8672 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t8671)
call void @resid_rec_share(ptr %t8672)
%t8673 = call ptr @eg_encode__g_Int_512__Int_64_(ptr %t8672)
%t8674 = call ptr @resid_list_freeze(ptr %t8673)
%t8675 = call ptr @__m____________lib_word_resid__wi_publish(ptr %t8674)
%t8676 = call ptr @resid_list_freeze(ptr %t8675)
%t8677 = call ptr @resid_listbuf_new()
%t8678 = call i64 @resid_scope_push()
%t8679 = call ptr @resid_list_concat(ptr %t8676, ptr %t8662)
%t8680 = call ptr @resid_list_concat(ptr %t8679, ptr %p1)
%t8681 = call ptr @sha512_bytes(ptr %t8680)
%t8682 = call ptr @resid_list_freeze(ptr %t8681)
%t8683 = call ptr @__m____________lib_ed25519g_resid__eg_lift_bytes__g_Int_64__Int_512_(ptr %t8682, i64 0, ptr %t8677)
%t8684 = call ptr @resid_list_freeze(ptr %t8683)
%t8685 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %t8684)
call void @resid_scope_pop(i64 %t8678)
%t8686 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t8685, i512 %t8657)
%t8687 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8686, i512 %t8671)
%t8688 = call i512 @eg_fold_l__g_Int_512__Int_64_(i512 0, i512 %t8687, i64 508)
%t8689 = call ptr @resid_listbuf_new()
%t8690 = call ptr @eg_le_bytes__g_Int_512__Int_64_(i512 %t8688, i64 32, i64 0, ptr %t8689)
%t8691 = call ptr @resid_list_freeze(ptr %t8690)
%t8692 = call ptr @__m____________lib_word_resid__wi_publish(ptr %t8691)
%t8693 = call ptr @resid_list_freeze(ptr %t8692)
%t8694 = musttail call ptr @resid_list_concat(ptr %t8676, ptr %t8693)
ret ptr %t8694
}
define ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8695 = call ptr @chachag_state__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
%t8696 = call ptr @__m____________lib_chachag_resid__cg_block_st__g_Int_64__Int_64_(ptr %t8695)
ret ptr %t8696
}
define ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8697 = call ptr @resid_listbuf_new()
%t8698 = call ptr @chachag_state__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
%t8699 = call ptr @resid_list_freeze(ptr %t8698)
%t8700 = and i64 %p1, 4294967295
%t8701 = call ptr @__m____________lib_chachag_resid__cg_xor_run__g_Int_64__Int_64_(ptr %t8699, i64 %t8700, ptr %p3, i64 0, ptr %t8697)
%t8702 = call ptr @resid_listbuf_finish(ptr %t8701, ptr @.lty8702)
ret ptr %t8702
}
define ptr @poly1305g__g_Int_64__Int_512_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8703 = call i512 @__m____________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p0, i64 0, i64 16, i64 0, i512 0)
%t8704 = sext i128 21267647620597763993911028882763415551 to i512
%t8705 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8703, i512 %t8704)
%t8706 = call i512 @__m____________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p0, i64 16, i64 16, i64 0, i512 0)
%t8707 = call i512 @__m____________lib_chachag_resid__pg_blocks__g_Int_512__Int_64_(i512 0, ptr %p1, i64 0, i512 %t8705)
%t8708 = call ptr @resid_listbuf_new()
%t8709 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8707, i512 %t8706)
%t8710 = sext i256 340282366920938463463374607431768211455 to i512
%t8711 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8709, i512 %t8710)
%t8712 = call ptr @__m____________lib_chachag_resid__pg_bytes__g_Int_512__Int_64_(i512 %t8711, i64 0, ptr %t8708)
ret ptr %t8712
}
define ptr @chacha20poly1305g_seal__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8713 = call ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 0, ptr %p1)
%t8714 = call ptr @resid_list_freeze(ptr %t8713)
%t8715 = call ptr @resid_list_slice(ptr %t8714, i64 0, i64 32)
%t8717 = call ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 1, ptr %p1, ptr %p2)
%t8718 = call ptr @resid_list_freeze(ptr %t8717)
%t8719 = call ptr @__m____________lib_chachag_resid__cg_mac_input__g_Int_64__Int_64_(ptr %p3, ptr %t8718)
%t8720 = call ptr @resid_list_freeze(ptr %t8719)
%t8721 = call ptr @poly1305g__g_Int_64__Int_512_(ptr %t8715, ptr %t8720)
%t8722 = call ptr @resid_list_freeze(ptr %t8721)
%t8723 = call ptr @resid_list_concat(ptr %t8718, ptr %t8722)
ret ptr %t8723
}
define ptr @chacha20poly1305g_decrypt__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8724 = call i64 @resid_list_len(ptr %p2)
%t8725 = sub nsw i64 %t8724, 16
%t8726 = call i64 @resid_list_len(ptr %p0)
%t8727 = icmp ne i64 %t8726, 32
br label %LSL8728
LSL8728:
br i1 %t8727, label %LSJ8728, label %LSR8728
LSR8728:
%t8729 = call i64 @resid_list_len(ptr %p1)
%t8730 = icmp ne i64 %t8729, 12
br label %LSJ8728
LSJ8728:
%t8731 = phi i1 [ true, %LSL8728 ], [ %t8730, %LSR8728 ]
br label %LSL8732
LSL8732:
br i1 %t8731, label %LSJ8732, label %LSR8732
LSR8732:
%t8733 = icmp slt i64 %t8725, 0
br label %LSJ8732
LSJ8732:
%t8734 = phi i1 [ true, %LSL8732 ], [ %t8733, %LSR8732 ]
br i1 %t8734, label %L988, label %L990
L988:
ret ptr @.nbox8735
L990:
%t8736 = call ptr @resid_listbuf_new()
%t8737 = call ptr @resid_listbuf_new()
%t8738 = call ptr @resid_list_slice(ptr %p2, i64 0, i64 %t8725)
%t8740 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t8738, i64 0, ptr %t8736)
%t8741 = call ptr @resid_list_freeze(ptr %t8740)
%t8742 = call i64 @resid_list_len(ptr %p2)
%t8743 = call ptr @resid_list_slice(ptr %p2, i64 %t8725, i64 %t8742)
%t8745 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t8743, i64 0, ptr %t8737)
%t8746 = call ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 0, ptr %p1)
%t8747 = call ptr @resid_list_freeze(ptr %t8746)
%t8748 = call ptr @resid_list_slice(ptr %t8747, i64 0, i64 32)
%t8750 = call ptr @__m____________lib_chachag_resid__cg_mac_input__g_Int_64__Int_64_(ptr %p3, ptr %t8741)
%t8751 = call ptr @resid_list_freeze(ptr %t8750)
%t8752 = call ptr @poly1305g__g_Int_64__Int_512_(ptr %t8748, ptr %t8751)
%t8753 = call ptr @resid_list_freeze(ptr %t8752)
%t8754 = call i1 @__m____________lib_crypto_resid__ct_same_pub(ptr %t8753, ptr %t8745)
%t8755 = xor i1 %t8754, true
br i1 %t8755, label %L991, label %L993
L991:
ret ptr @.nbox8756
L993:
%t8757 = call ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 1, ptr %p1, ptr %t8741)
%t8758 = call ptr @resid_list_freeze(ptr %t8757)
%t8761 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty8759)
%t8760 = getelementptr {i32, i32, ptr}, ptr %t8761, i32 1
store ptr %t8758, ptr %t8760
ret ptr %t8761
}
define ptr @__m____________lib_sha256g_resid__g_blk__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in, i64 %p19.in, i64 %p20.in, i64 %p21.in, i64 %p22.in, i64 %p23.in, i64 %p24.in, i64 %p25.in, i64 %p26.in, i64 %p27.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8795 = alloca [8 x ptr]
%p3.ld = call ptr @resid_list_vdata(ptr %p3.in)
%p3.ln = call i64 @resid_list_vlen(ptr %p3.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8834, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t8835, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t8836, %tco.s0.k ]
%p9 = phi i64 [ %p9.in, %entry ], [ %p8, %tco.s0.k ]
%p10 = phi i64 [ %p10.in, %entry ], [ %p9, %tco.s0.k ]
%p11 = phi i64 [ %p11.in, %entry ], [ %p10, %tco.s0.k ]
%p12 = phi i64 [ %p12.in, %entry ], [ %p13, %tco.s0.k ]
%p13 = phi i64 [ %p13.in, %entry ], [ %p14, %tco.s0.k ]
%p14 = phi i64 [ %p14.in, %entry ], [ %p15, %tco.s0.k ]
%p15 = phi i64 [ %p15.in, %entry ], [ %p16, %tco.s0.k ]
%p16 = phi i64 [ %p16.in, %entry ], [ %p17, %tco.s0.k ]
%p17 = phi i64 [ %p17.in, %entry ], [ %p18, %tco.s0.k ]
%p18 = phi i64 [ %p18.in, %entry ], [ %p19, %tco.s0.k ]
%p19 = phi i64 [ %p19.in, %entry ], [ %p20, %tco.s0.k ]
%p20 = phi i64 [ %p20.in, %entry ], [ %p21, %tco.s0.k ]
%p21 = phi i64 [ %p21.in, %entry ], [ %p22, %tco.s0.k ]
%p22 = phi i64 [ %p22.in, %entry ], [ %p23, %tco.s0.k ]
%p23 = phi i64 [ %p23.in, %entry ], [ %p24, %tco.s0.k ]
%p24 = phi i64 [ %p24.in, %entry ], [ %p25, %tco.s0.k ]
%p25 = phi i64 [ %p25.in, %entry ], [ %p26, %tco.s0.k ]
%p26 = phi i64 [ %p26.in, %entry ], [ %p27, %tco.s0.k ]
%p27 = phi i64 [ %p27.in, %entry ], [ %t8822, %tco.s0.k ]
%t8762 = icmp sge i64 %p2, 64
br i1 %t8762, label %L994, label %L996
L994:
%t8763 = call ptr @resid_list_get_v(ptr %p3, i64 0, ptr %p3.ld, i64 %p3.ln)
%t8764 = call i64 @resid_unbox_i64(ptr %t8763)
%t8766 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8764, i64 %p4)
%t8767 = call ptr @resid_list_get_v(ptr %p3, i64 1, ptr %p3.ld, i64 %p3.ln)
%t8768 = call i64 @resid_unbox_i64(ptr %t8767)
%t8770 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8768, i64 %p5)
%t8771 = call ptr @resid_list_get_v(ptr %p3, i64 2, ptr %p3.ld, i64 %p3.ln)
%t8772 = call i64 @resid_unbox_i64(ptr %t8771)
%t8774 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8772, i64 %p6)
%t8775 = call ptr @resid_list_get_v(ptr %p3, i64 3, ptr %p3.ld, i64 %p3.ln)
%t8776 = call i64 @resid_unbox_i64(ptr %t8775)
%t8778 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8776, i64 %p7)
%t8779 = call ptr @resid_list_get_v(ptr %p3, i64 4, ptr %p3.ld, i64 %p3.ln)
%t8780 = call i64 @resid_unbox_i64(ptr %t8779)
%t8782 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8780, i64 %p8)
%t8783 = call ptr @resid_list_get_v(ptr %p3, i64 5, ptr %p3.ld, i64 %p3.ln)
%t8784 = call i64 @resid_unbox_i64(ptr %t8783)
%t8786 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8784, i64 %p9)
%t8787 = call ptr @resid_list_get_v(ptr %p3, i64 6, ptr %p3.ld, i64 %p3.ln)
%t8788 = call i64 @resid_unbox_i64(ptr %t8787)
%t8790 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8788, i64 %p10)
%t8791 = call ptr @resid_list_get_v(ptr %p3, i64 7, ptr %p3.ld, i64 %p3.ln)
%t8792 = call i64 @resid_unbox_i64(ptr %t8791)
%t8794 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8792, i64 %p11)
%t8797 = call ptr @resid_box_i64(i64 %t8766)
%t8799 = getelementptr i8, ptr %t8795, i64 0
store ptr %t8797, ptr %t8799
%t8800 = call ptr @resid_box_i64(i64 %t8770)
%t8802 = getelementptr i8, ptr %t8795, i64 8
store ptr %t8800, ptr %t8802
%t8803 = call ptr @resid_box_i64(i64 %t8774)
%t8805 = getelementptr i8, ptr %t8795, i64 16
store ptr %t8803, ptr %t8805
%t8806 = call ptr @resid_box_i64(i64 %t8778)
%t8808 = getelementptr i8, ptr %t8795, i64 24
store ptr %t8806, ptr %t8808
%t8809 = call ptr @resid_box_i64(i64 %t8782)
%t8811 = getelementptr i8, ptr %t8795, i64 32
store ptr %t8809, ptr %t8811
%t8812 = call ptr @resid_box_i64(i64 %t8786)
%t8814 = getelementptr i8, ptr %t8795, i64 40
store ptr %t8812, ptr %t8814
%t8815 = call ptr @resid_box_i64(i64 %t8790)
%t8817 = getelementptr i8, ptr %t8795, i64 48
store ptr %t8815, ptr %t8817
%t8818 = call ptr @resid_box_i64(i64 %t8794)
%t8820 = getelementptr i8, ptr %t8795, i64 56
store ptr %t8818, ptr %t8820
%t8821 = call ptr @resid_list_new(i64 8, ptr %t8795, ptr @.lty8795)
%lr.cx87 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz87 = icmp eq ptr %lr.cx87, null
br i1 %lr.lz87, label %lr.x87.k, label %lr.x87.m
lr.x87.k:
ret ptr %t8821
lr.x87.m:
%lr.ret87 = call ptr @resid_mv_list(ptr %t8821, ptr %lr.cx87)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret87
L996:
%t8822 = call i64 @__m____________lib_sha256g_resid__g_sched__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p12, i64 %p13, i64 %p21, i64 %p26)
%t8823 = call i64 @resid_scope_push()
%t8824 = call i64 @__m____________lib_sha256g_resid__g_bsig1__g_Int_64__Int_64_(i64 %p8)
%t8825 = call i64 @__m____________lib_word_resid__wi_add(i64 %p11, i64 %t8824)
%t8826 = call i64 @__m____________lib_sha256g_resid__g_ch__g_Int_64__Int_64_(i64 %p8, i64 %p9, i64 %p10)
%t8827 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8825, i64 %t8826)
%t8828 = call i64 @__m____________lib_sha256g_resid__sha2k(i64 %p2)
%t8829 = call i64 @__m____________lib_word_resid__wi_addk(i64 %t8827, i64 %t8828)
%t8830 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8829, i64 %t8822)
call void @resid_scope_pop(i64 %t8823)
%t8831 = call i64 @__m____________lib_sha256g_resid__g_bsig0__g_Int_64__Int_64_(i64 %p4)
%t8832 = call i64 @__m____________lib_sha256g_resid__g_maj__g_Int_64__Int_64_(i64 %p4, i64 %p5, i64 %p6)
%t8833 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8831, i64 %t8832)
%t8834 = add nsw i64 %p2, 1
%t8835 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8830, i64 %t8833)
%t8836 = call i64 @__m____________lib_word_resid__wi_add(i64 %p7, i64 %t8830)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %p3, %tco.s0 ]
br label %tco.head
}
define ptr @__m____________lib_crypto_resid__b64g_groups__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8875, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8874, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t8872, %tco.s0 ]
%t8838 = call i64 @resid_list_len(ptr %p0)
%t8839 = icmp sge i64 %p1, %t8838
br i1 %t8839, label %L997, label %L999
L997:
%t8840 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty8840)
%t8841 = call ptr @__m____________lib_crypto_resid__b64g_finish__g_Int_64__Int_64_(ptr %t8840, i64 %p2)
ret ptr %t8841
L999:
%t8842 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %p1)
%t8843 = add nsw i64 %p1, 1
%t8844 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %t8843)
%t8845 = add nsw i64 %p1, 2
%t8846 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %t8845)
%t8847 = add nsw i64 %p1, 3
%t8848 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %t8847)
%t8849 = call i64 @__m____________lib_crypto_resid__b64g_join__g_Int_64__Int_64_(i64 %t8842, i64 %t8844, i64 %t8846, i64 %t8848)
%t8850 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t8838, i64 %p1)
%t8851 = extractvalue {i64, i1} %t8850, 0
%t8852 = extractvalue {i64, i1} %t8850, 1
%t8853 = zext i1 %t8852 to i8
call void @resid_overflow_check(i8 %t8853)
%t8854 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8849, i64 16)
%t8855 = call ptr @resid_box_i64(i64 %t8854)
%t8858 = call ptr @resid_listbuf_push(ptr %p3, ptr %t8855)
%t8859 = icmp sgt i64 %t8851, 2
br i1 %t8859, label %L1000, label %L1001
L1000:
%t8860 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8849, i64 8)
%t8861 = call ptr @resid_box_i64(i64 %t8860)
%t8864 = call ptr @resid_listbuf_push(ptr %t8858, ptr %t8861)
br label %L1002
L1001:
br label %L1002
L1002:
%t8865 = phi ptr [ %t8864, %L1000 ], [ %t8858, %L1001 ]
%t8866 = icmp sgt i64 %t8851, 3
br i1 %t8866, label %L1003, label %L1004
L1003:
%t8867 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8849, i64 0)
%t8868 = call ptr @resid_box_i64(i64 %t8867)
%t8871 = call ptr @resid_listbuf_push(ptr %t8865, ptr %t8868)
br label %L1005
L1004:
br label %L1005
L1005:
%t8872 = phi ptr [ %t8871, %L1003 ], [ %t8865, %L1004 ]
%t8873 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8849, i64 16777216)
%t8874 = call i64 @__m____________lib_word_resid__wi_or(i64 %p2, i64 %t8873)
%t8875 = add nsw i64 %p1, 4
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8877 = call i512 @__m____________lib_word_resid__pi_sub(i512 %p0, i512 %p1)
%t8878 = call i512 @__m____________lib_word_resid__pi_sign(i512 %t8877)
%t8879 = call i512 @__m____________lib_word_resid__pi_and(i512 %p0, i512 %t8878)
%t8880 = sext i64 -1 to i512
%t8881 = call i512 @__m____________lib_word_resid__pi_xor(i512 %t8878, i512 %t8880)
%t8882 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8877, i512 %t8881)
%t8883 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8879, i512 %t8882)
ret i512 %t8883
}
define ptr @__m____________lib_ed25519g_resid__eg_sel__g_Int_512__Int_64_(i512 %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8884 = sext i64 -1 to i512
%t8885 = call i512 @__m____________lib_word_resid__pi_xor(i512 %p0, i512 %t8884)
%t8886 = getelementptr i8, ptr %p1, i64 0
%t8887 = load i512, ptr %t8886, align 8
%t8888 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8887, i512 %p0)
%t8889 = getelementptr i8, ptr %p2, i64 0
%t8890 = load i512, ptr %t8889, align 8
%t8891 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8890, i512 %t8885)
%t8892 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8888, i512 %t8891)
%t8893 = getelementptr i8, ptr %p1, i64 64
%t8894 = load i512, ptr %t8893, align 8
%t8895 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8894, i512 %p0)
%t8896 = getelementptr i8, ptr %p2, i64 64
%t8897 = load i512, ptr %t8896, align 8
%t8898 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8897, i512 %t8885)
%t8899 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8895, i512 %t8898)
%t8900 = getelementptr i8, ptr %p1, i64 128
%t8901 = load i512, ptr %t8900, align 8
%t8902 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8901, i512 %p0)
%t8903 = getelementptr i8, ptr %p2, i64 128
%t8904 = load i512, ptr %t8903, align 8
%t8905 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8904, i512 %t8885)
%t8906 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8902, i512 %t8905)
%t8907 = getelementptr i8, ptr %p1, i64 192
%t8908 = load i512, ptr %t8907, align 8
%t8909 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8908, i512 %p0)
%t8910 = getelementptr i8, ptr %p2, i64 192
%t8911 = load i512, ptr %t8910, align 8
%t8912 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8911, i512 %t8885)
%t8913 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8909, i512 %t8912)
%t8914 = call ptr @resid_rec_reuse_sc(ptr %p1, i64 256)
%t8914.f0 = getelementptr i8, ptr %t8914, i64 0
store i512 %t8892, ptr %t8914.f0, align 8
%t8914.f8 = getelementptr i8, ptr %t8914, i64 64
store i512 %t8899, ptr %t8914.f8, align 8
%t8914.f16 = getelementptr i8, ptr %t8914, i64 128
store i512 %t8906, ptr %t8914.f16, align 8
%t8914.f24 = getelementptr i8, ptr %t8914, i64 192
store i512 %t8913, ptr %t8914.f24, align 8
ret ptr %t8914
}
define ptr @eg_base__g_Int_512__Int_64_() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8915 = sext i256 15112221349535400772501151409588531511454012693041857206046113283949847762202 to i512
%t8916 = sext i256 46316835694926478169428394003475163141307993866256225615783033603165251855960 to i512
%t8917 = call ptr @eg_pt__g_Int_512__Int_64_(i512 %t8915, i512 %t8916)
ret ptr %t8917
}
define ptr @eg_le_bytes__g_Int_512__Int_64_(i512 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8920, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t8929, %tco.s0 ]
%t8918 = icmp sge i64 %p2, %p1
br i1 %t8918, label %L1006, label %L1008
L1006:
%t8919 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty8919)
ret ptr %t8919
L1008:
%t8920 = add nsw i64 %p2, 1
%t8921 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p2)
%t8922 = extractvalue {i64, i1} %t8921, 0
%t8923 = extractvalue {i64, i1} %t8921, 1
%t8924 = zext i1 %t8923 to i8
call void @resid_overflow_check(i8 %t8924)
%t8925 = call i64 @__m____________lib_word_resid__pi_byte(i512 %p0, i64 %t8922)
%t8926 = call ptr @resid_box_i64(i64 %t8925)
%t8929 = call ptr @resid_listbuf_push(ptr %p3, ptr %t8926)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @eg_le__g_Int_64__Int_512_(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i512 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t8932, %tco.s0 ]
%p4 = phi i512 [ %p4.in, %entry ], [ %t8946, %tco.s0 ]
%t8931 = icmp sge i64 %p3, %p2
br i1 %t8931, label %L1009, label %L1011
L1009:
ret i512 %p4
L1011:
%t8932 = add nsw i64 %p3, 1
%t8933 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p3)
%t8934 = extractvalue {i64, i1} %t8933, 0
%t8935 = extractvalue {i64, i1} %t8933, 1
%t8936 = zext i1 %t8935 to i8
call void @resid_overflow_check(i8 %t8936)
%t8937 = call ptr @resid_list_get_v(ptr %p0, i64 %t8934, ptr %p0.ld, i64 %p0.ln)
%t8938 = call i64 @resid_unbox_i64(ptr %t8937)
%t8940 = call i512 @__m____________lib_word_resid__pi_from_byte(i64 %t8938)
%t8941 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p3)
%t8942 = extractvalue {i64, i1} %t8941, 0
%t8943 = extractvalue {i64, i1} %t8941, 1
%t8944 = zext i1 %t8943 to i8
call void @resid_overflow_check(i8 %t8944)
%t8945 = call i512 @__m____________lib_word_resid__pi_shl(i512 %t8940, i64 %t8942)
%t8946 = call i512 @__m____________lib_word_resid__pi_or(i512 %p4, i512 %t8945)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @eg_fold_l__g_Int_512__Int_64_(i512 %p0.in, i512 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %t8954, %tco.s0 ]
%p1 = phi i512 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8955, %tco.s0 ]
%t8948 = icmp slt i64 %p2, 0
br i1 %t8948, label %L1012, label %L1014
L1012:
ret i512 %p0
L1014:
%t8949 = call i512 @__m____________lib_word_resid__pi_shr(i512 %p1, i64 %p2)
%t8950 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8949, i512 1)
%t8951 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %p0)
%t8952 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8951, i512 %t8950)
%t8953 = sext i256 7237005577332262213973186563042994240857116359379907606001950938285454250989 to i512
%t8954 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8952, i512 %t8953)
%t8955 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @sha512g__g_Int_64__UInt_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8957 = add i64 7640891576956012808, 0
%t8958 = add i64 %t8957, 0
%t8959 = add i64 %t8958, 0
%t8960 = icmp ne i64 %t8959, %t8957
%t8961 = icmp slt i64 7640891576956012808, 0
%t8962 = or i1 %t8960, %t8961
%t8963 = zext i1 %t8962 to i8
call void @resid_conv_check(i8 %t8963)
%t8964 = add i128 13503953896175478587, 0
%t8965 = trunc i128 %t8964 to i64
%t8966 = zext i64 %t8965 to i128
%t8967 = icmp ne i128 %t8966, %t8964
%t8968 = icmp slt i128 13503953896175478587, 0
%t8969 = or i1 %t8967, %t8968
%t8970 = zext i1 %t8969 to i8
call void @resid_conv_check(i8 %t8970)
%t8971 = add i64 4354685564936845355, 0
%t8972 = add i64 %t8971, 0
%t8973 = add i64 %t8972, 0
%t8974 = icmp ne i64 %t8973, %t8971
%t8975 = icmp slt i64 4354685564936845355, 0
%t8976 = or i1 %t8974, %t8975
%t8977 = zext i1 %t8976 to i8
call void @resid_conv_check(i8 %t8977)
%t8978 = add i128 11912009170470909681, 0
%t8979 = trunc i128 %t8978 to i64
%t8980 = zext i64 %t8979 to i128
%t8981 = icmp ne i128 %t8980, %t8978
%t8982 = icmp slt i128 11912009170470909681, 0
%t8983 = or i1 %t8981, %t8982
%t8984 = zext i1 %t8983 to i8
call void @resid_conv_check(i8 %t8984)
%t8985 = add i64 5840696475078001361, 0
%t8986 = add i64 %t8985, 0
%t8987 = add i64 %t8986, 0
%t8988 = icmp ne i64 %t8987, %t8985
%t8989 = icmp slt i64 5840696475078001361, 0
%t8990 = or i1 %t8988, %t8989
%t8991 = zext i1 %t8990 to i8
call void @resid_conv_check(i8 %t8991)
%t8992 = add i128 11170449401992604703, 0
%t8993 = trunc i128 %t8992 to i64
%t8994 = zext i64 %t8993 to i128
%t8995 = icmp ne i128 %t8994, %t8992
%t8996 = icmp slt i128 11170449401992604703, 0
%t8997 = or i1 %t8995, %t8996
%t8998 = zext i1 %t8997 to i8
call void @resid_conv_check(i8 %t8998)
%t8999 = add i64 2270897969802886507, 0
%t9000 = add i64 %t8999, 0
%t9001 = add i64 %t9000, 0
%t9002 = icmp ne i64 %t9001, %t8999
%t9003 = icmp slt i64 2270897969802886507, 0
%t9004 = or i1 %t9002, %t9003
%t9005 = zext i1 %t9004 to i8
call void @resid_conv_check(i8 %t9005)
%t9006 = add i64 6620516959819538809, 0
%t9007 = add i64 %t9006, 0
%t9008 = add i64 %t9007, 0
%t9009 = icmp ne i64 %t9008, %t9006
%t9010 = icmp slt i64 6620516959819538809, 0
%t9011 = or i1 %t9009, %t9010
%t9012 = zext i1 %t9011 to i8
call void @resid_conv_check(i8 %t9012)
%t9013 = alloca [8 x ptr]
%t9015 = call ptr @resid_box_i64(i64 %t8958)
%t9017 = getelementptr i8, ptr %t9013, i64 0
store ptr %t9015, ptr %t9017
%t9018 = call ptr @resid_box_i64(i64 %t8965)
%t9020 = getelementptr i8, ptr %t9013, i64 8
store ptr %t9018, ptr %t9020
%t9021 = call ptr @resid_box_i64(i64 %t8972)
%t9023 = getelementptr i8, ptr %t9013, i64 16
store ptr %t9021, ptr %t9023
%t9024 = call ptr @resid_box_i64(i64 %t8979)
%t9026 = getelementptr i8, ptr %t9013, i64 24
store ptr %t9024, ptr %t9026
%t9027 = call ptr @resid_box_i64(i64 %t8986)
%t9029 = getelementptr i8, ptr %t9013, i64 32
store ptr %t9027, ptr %t9029
%t9030 = call ptr @resid_box_i64(i64 %t8993)
%t9032 = getelementptr i8, ptr %t9013, i64 40
store ptr %t9030, ptr %t9032
%t9033 = call ptr @resid_box_i64(i64 %t9000)
%t9035 = getelementptr i8, ptr %t9013, i64 48
store ptr %t9033, ptr %t9035
%t9036 = call ptr @resid_box_i64(i64 %t9007)
%t9038 = getelementptr i8, ptr %t9013, i64 56
store ptr %t9036, ptr %t9038
%t9039 = call ptr @resid_list_new(i64 8, ptr %t9013, ptr @.lty9013)
%t9040 = call ptr @__m____________lib_sha512g_resid__g5_hash__g_Int_64__UInt_64_(ptr %p0, ptr %t9039, i64 64)
ret ptr %t9040
}
define i512 @__m____________lib_ed25519g_resid__eg_scalar__g_Int_64__Int_512_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9041 = call i512 @eg_le__g_Int_64__Int_512_(ptr %p0, i64 0, i64 32, i64 0, i512 0)
%t9042 = call i512 @eg_clamp__g_Int_512__Int_64_(i512 %t9041)
ret i512 %t9042
}
define ptr @d_lift_bytes__g_Int_64__UInt_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9043 = call ptr @resid_listbuf_new()
%t9044 = call ptr @__m____________lib_sha512g_resid__g5_lift_bytes__g_Int_64__UInt_64_(ptr %p0, i64 0, ptr %t9043)
ret ptr %t9044
}
define ptr @__m____________lib_ed25519g_resid__eg_lift_bytes__g_Int_64__Int_512_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9054, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t9059, %tco.s0 ]
%t9045 = call i64 @resid_list_len(ptr %p0)
%t9046 = icmp sge i64 %p1, %t9045
br i1 %t9046, label %L1015, label %L1017
L1015:
%t9047 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty9047)
ret ptr %t9047
L1017:
%t9048 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t9049 = call i64 @resid_unbox_i64(ptr %t9048)
%t9051 = and i64 %t9049, 255
%t9052 = sext i64 %t9051 to i512
%t9053 = call i512 @__m____________lib_word_resid__pi_lift(i512 %t9052)
%t9054 = add nsw i64 %p1, 1
%t9055 = call i64 @__m____________lib_word_resid__pi_byte(i512 %t9053, i64 0)
%t9056 = call ptr @resid_box_i64(i64 %t9055)
%t9059 = call ptr @resid_listbuf_push(ptr %p2, ptr %t9056)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @chachag_state__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9061 = call i64 @__m____________lib_chachag_resid__cg_le32(ptr %p2, i64 0)
%t9062 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t9061)
%t9063 = call i64 @__m____________lib_chachag_resid__cg_le32(ptr %p2, i64 4)
%t9064 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t9063)
%t9065 = call i64 @__m____________lib_chachag_resid__cg_le32(ptr %p2, i64 8)
%t9066 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t9065)
%t9067 = call ptr @__m____________lib_chachag_resid__cg_state_w__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %t9062, i64 %t9064, i64 %t9066)
ret ptr %t9067
}
define ptr @__m____________lib_chachag_resid__cg_block_st__g_Int_64__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9068 = call ptr @resid_listbuf_new()
%t9069 = call ptr @resid_list_get(ptr %p0, i64 12)
%t9070 = call i64 @resid_unbox_i64(ptr %t9069)
%t9072 = call ptr @__m____________lib_chachag_resid__cg_words__g_Int_64__Int_64_(ptr %p0, i64 %t9070)
%t9073 = call ptr @__m____________lib_chachag_resid__cg_ser__g_Int_64__Int_64_(ptr %t9072, i64 0, ptr %t9068)
ret ptr %t9073
}
define ptr @__m____________lib_chachag_resid__cg_xor_run__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9086, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9088, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t9091, %tco.s0 ]
%t9074 = call i64 @resid_list_len(ptr %p2)
%t9075 = icmp sge i64 %p3, %t9074
br i1 %t9075, label %L1018, label %L1020
L1018:
ret ptr %p4
L1020:
%t9076 = call i64 @__m____________lib_word_resid__wi_lift(i64 %p1)
%t9077 = call ptr @__m____________lib_chachag_resid__cg_words__g_Int_64__Int_64_(ptr %p0, i64 %t9076)
%t9078 = call i64 @resid_list_len(ptr %p2)
%t9079 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t9078, i64 %p3)
%t9080 = extractvalue {i64, i1} %t9079, 0
%t9081 = extractvalue {i64, i1} %t9079, 1
%t9082 = zext i1 %t9081 to i8
call void @resid_overflow_check(i8 %t9082)
%t9083 = icmp slt i64 %t9080, 64
br i1 %t9083, label %L1021, label %L1022
L1021:
br label %L1023
L1022:
br label %L1023
L1023:
%t9084 = phi i64 [ %t9080, %L1021 ], [ 64, %L1022 ]
%t9085 = call i64 @wrapping_add(i64 %p1, i64 1)
%t9086 = and i64 %t9085, 4294967295
%t9087 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %t9084)
%t9088 = extractvalue {i64, i1} %t9087, 0
%t9089 = extractvalue {i64, i1} %t9087, 1
%t9090 = zext i1 %t9089 to i8
call void @resid_overflow_check(i8 %t9090)
%t9091 = call ptr @__m____________lib_chachag_resid__cg_xor_bytes__g_Int_64__Int_64_(ptr %t9077, ptr %p2, i64 %p3, i64 0, i64 %t9084, ptr %p4)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m____________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i512 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9094, %tco.s0 ]
%p4 = phi i512 [ %p4.in, %entry ], [ %t9108, %tco.s0 ]
%t9093 = icmp sge i64 %p3, %p2
br i1 %t9093, label %L1024, label %L1026
L1024:
ret i512 %p4
L1026:
%t9094 = add nsw i64 %p3, 1
%t9095 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p3)
%t9096 = extractvalue {i64, i1} %t9095, 0
%t9097 = extractvalue {i64, i1} %t9095, 1
%t9098 = zext i1 %t9097 to i8
call void @resid_overflow_check(i8 %t9098)
%t9099 = call ptr @resid_list_get_v(ptr %p0, i64 %t9096, ptr %p0.ld, i64 %p0.ln)
%t9100 = call i64 @resid_unbox_i64(ptr %t9099)
%t9102 = call i512 @__m____________lib_word_resid__pi_from_byte(i64 %t9100)
%t9103 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p3)
%t9104 = extractvalue {i64, i1} %t9103, 0
%t9105 = extractvalue {i64, i1} %t9103, 1
%t9106 = zext i1 %t9105 to i8
call void @resid_overflow_check(i8 %t9106)
%t9107 = call i512 @__m____________lib_word_resid__pi_shl(i512 %t9102, i64 %t9104)
%t9108 = call i512 @__m____________lib_word_resid__pi_or(i512 %p4, i512 %t9107)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m____________lib_chachag_resid__pg_blocks__g_Int_512__Int_64_(i512 %p0.in, ptr %p1.in, i64 %p2.in, i512 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %t9132, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9134, %tco.s0 ]
%p3 = phi i512 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t9110 = call i64 @resid_list_len(ptr %p1)
%t9111 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t9110, i64 %p2)
%t9112 = extractvalue {i64, i1} %t9111, 0
%t9113 = extractvalue {i64, i1} %t9111, 1
%t9114 = zext i1 %t9113 to i8
call void @resid_overflow_check(i8 %t9114)
%t9115 = icmp sle i64 %t9112, 0
br i1 %t9115, label %L1027, label %L1029
L1027:
ret i512 %p0
L1029:
%t9116 = icmp slt i64 %t9112, 16
br i1 %t9116, label %L1030, label %L1031
L1030:
br label %L1032
L1031:
br label %L1032
L1032:
%t9117 = phi i64 [ %t9112, %L1030 ], [ 16, %L1031 ]
%t9118 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t9117, i64 8)
%t9119 = extractvalue {i64, i1} %t9118, 0
%t9120 = extractvalue {i64, i1} %t9118, 1
%t9121 = zext i1 %t9120 to i8
call void @resid_overflow_check(i8 %t9121)
%t9122 = sext i64 %t9119 to i512
%t9123 = icmp uge i512 %t9122, 512
%t9124 = add i512 %t9122, 0
%t9125 = shl i512 1, %t9124
%t9126 = select i1 %t9123, i512 0, i512 %t9125
%t9127 = call i512 @__m____________lib_word_resid__pi_lift(i512 %t9126)
%t9128 = call i512 @__m____________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p1, i64 %p2, i64 %t9117, i64 0, i512 0)
%t9129 = call i512 @__m____________lib_word_resid__pi_add(i512 %t9128, i512 %t9127)
%t9130 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %t9129)
%t9131 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t9130, i512 %p3)
%t9132 = call i512 @__m____________lib_chachag_resid__pg_reduce__g_Int_512__Int_64_(i512 %t9131)
%t9133 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %t9117)
%t9134 = extractvalue {i64, i1} %t9133, 0
%t9135 = extractvalue {i64, i1} %t9133, 1
%t9136 = zext i1 %t9135 to i8
call void @resid_overflow_check(i8 %t9136)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__pg_bytes__g_Int_512__Int_64_(i512 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9140, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t9149, %tco.s0 ]
%t9138 = icmp sge i64 %p1, 16
br i1 %t9138, label %L1033, label %L1035
L1033:
%t9139 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty9139)
ret ptr %t9139
L1035:
%t9140 = add nsw i64 %p1, 1
%t9141 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p1)
%t9142 = extractvalue {i64, i1} %t9141, 0
%t9143 = extractvalue {i64, i1} %t9141, 1
%t9144 = zext i1 %t9143 to i8
call void @resid_overflow_check(i8 %t9144)
%t9145 = call i64 @__m____________lib_word_resid__pi_byte(i512 %p0, i64 %t9142)
%t9146 = call ptr @resid_box_i64(i64 %t9145)
%t9149 = call ptr @resid_listbuf_push(ptr %p2, ptr %t9146)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__cg_mac_input__g_Int_64__Int_64_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9151 = call i64 @resid_list_len(ptr %p0)
%t9152 = call i64 @__m____________lib_chachag_resid__cg_pad16(i64 %t9151)
%t9153 = call ptr @resid_listbuf_new()
%t9154 = call ptr @__m____________lib_chachag_resid__cg_zeros(i64 %t9152, i64 0, ptr %t9153)
%t9155 = call ptr @resid_list_freeze(ptr %t9154)
%t9156 = call ptr @resid_list_concat(ptr %p0, ptr %t9155)
%t9157 = call i64 @resid_list_len(ptr %p1)
%t9158 = call i64 @__m____________lib_chachag_resid__cg_pad16(i64 %t9157)
%t9159 = call ptr @resid_listbuf_new()
%t9160 = call ptr @__m____________lib_chachag_resid__cg_zeros(i64 %t9158, i64 0, ptr %t9159)
%t9161 = call i64 @resid_list_len(ptr %p0)
%t9162 = call ptr @resid_listbuf_new()
%t9163 = call ptr @__m____________lib_chachag_resid__cg_le64(i64 %t9161, i64 0, ptr %t9162)
%t9164 = call ptr @resid_list_freeze(ptr %t9163)
%t9165 = call ptr @resid_list_concat_own(ptr %t9160, i8 1, ptr %t9164)
%t9166 = call i64 @resid_list_len(ptr %p1)
%t9167 = call ptr @resid_listbuf_new()
%t9168 = call ptr @__m____________lib_chachag_resid__cg_le64(i64 %t9166, i64 0, ptr %t9167)
%t9169 = call ptr @resid_list_freeze(ptr %t9168)
%t9170 = call ptr @resid_list_concat_own(ptr %t9165, i8 1, ptr %t9169)
%t9171 = call ptr @resid_listbuf_new()
%t9172 = call ptr @resid_listbuf_new()
%t9173 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t9156, i64 0, ptr %t9171)
%t9174 = call ptr @resid_list_concat_own(ptr %t9173, i8 1, ptr %p1)
%t9175 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t9170, i64 0, ptr %t9172)
%t9176 = call ptr @resid_list_freeze(ptr %t9175)
%t9177 = call ptr @resid_list_concat_own(ptr %t9174, i8 1, ptr %t9176)
ret ptr %t9177
}
define ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9185, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t9189, %tco.s0 ]
%t9178 = call i64 @resid_list_len(ptr %p0)
%t9179 = icmp sge i64 %p1, %t9178
br i1 %t9179, label %L1036, label %L1038
L1036:
%t9180 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty9180)
ret ptr %t9180
L1038:
%t9181 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t9182 = call i64 @resid_unbox_i64(ptr %t9181)
%t9184 = call i64 @__m____________lib_word_resid__bi_lift(i64 %t9182)
%t9185 = add nsw i64 %p1, 1
%t9186 = call ptr @resid_box_i64(i64 %t9184)
%t9189 = call ptr @resid_listbuf_push(ptr %p2, ptr %t9186)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_sha256g_resid__g_sched__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9191 = icmp slt i64 %p2, 16
br i1 %t9191, label %L1039, label %L1041
L1039:
%t9192 = call i64 @__m____________lib_sha256g_resid__g_word_at__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2)
ret i64 %t9192
L1041:
%t9193 = call i64 @__m____________lib_sha256g_resid__g_ssig1__g_Int_64__Int_64_(i64 %p6)
%t9194 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9193, i64 %p5)
%t9195 = call i64 @__m____________lib_sha256g_resid__g_ssig0__g_Int_64__Int_64_(i64 %p4)
%t9196 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9195, i64 %p3)
%t9197 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9194, i64 %t9196)
ret i64 %t9197
}
define i64 @__m____________lib_sha256g_resid__g_bsig1__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9198 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 6)
%t9199 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 11)
%t9200 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9198, i64 %t9199)
%t9201 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 25)
%t9202 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9200, i64 %t9201)
ret i64 %t9202
}
define i64 @__m____________lib_sha256g_resid__g_ch__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9203 = call i64 @__m____________lib_word_resid__wi_and(i64 %p0, i64 %p1)
%t9204 = call i64 @__m____________lib_word_resid__wi_not(i64 %p0)
%t9205 = call i64 @__m____________lib_word_resid__wi_and(i64 %t9204, i64 %p2)
%t9206 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9203, i64 %t9205)
ret i64 %t9206
}
define i64 @__m____________lib_sha256g_resid__g_bsig0__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9207 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 2)
%t9208 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 13)
%t9209 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9207, i64 %t9208)
%t9210 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 22)
%t9211 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9209, i64 %t9210)
ret i64 %t9211
}
define i64 @__m____________lib_sha256g_resid__g_maj__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9212 = call i64 @__m____________lib_word_resid__wi_and(i64 %p0, i64 %p1)
%t9213 = call i64 @__m____________lib_word_resid__wi_and(i64 %p0, i64 %p2)
%t9214 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9212, i64 %t9213)
%t9215 = call i64 @__m____________lib_word_resid__wi_and(i64 %p1, i64 %p2)
%t9216 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9214, i64 %t9215)
ret i64 %t9216
}
define ptr @__m____________lib_crypto_resid__b64g_finish__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9217 = call i64 @__m____________lib_word_resid__wi_byte(i64 %p1, i64 24)
%t9218 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB9218)
%t9219 = alloca [1 x ptr]
%t9221 = call ptr @resid_box_i64(i64 %t9217)
%t9223 = getelementptr i8, ptr %t9219, i64 0
store ptr %t9221, ptr %t9223
%t9224 = call ptr @resid_list_new(i64 1, ptr %t9219, ptr @.lty9219)
%t9226 = call ptr @resid_list_const_i64(ptr @.lc9225, i64 1, ptr @.lcd9225, ptr @.lty9225)
%t9227 = call i1 @__m____________lib_crypto_resid__ct_same_pub(ptr %t9224, ptr %t9226)
%t9228 = xor i1 %t9227, true
br i1 %t9228, label %L1042, label %L1044
L1042:
ret ptr %t9218
L1044:
ret ptr %p0
}
define i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9229 = call i64 @resid_list_len(ptr %p0)
%t9230 = icmp sge i64 %p1, %t9229
br i1 %t9230, label %L1045, label %L1047
L1045:
ret i64 0
L1047:
%t9231 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t9232 = call i64 @resid_unbox_i64(ptr %t9231)
%t9234 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9232)
%t9235 = call i64 @b64g_sextet__g_Int_64__Int_64_(i64 %t9234)
ret i64 %t9235
}
define i64 @__m____________lib_crypto_resid__b64g_join__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9236 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p0, i64 63)
%t9237 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9236, i64 18)
%t9238 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p1, i64 63)
%t9239 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9238, i64 12)
%t9240 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9237, i64 %t9239)
%t9241 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p2, i64 63)
%t9242 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9241, i64 6)
%t9243 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p3, i64 63)
%t9244 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9242, i64 %t9243)
%t9245 = call i64 @__m____________lib_word_resid__wi_or(i64 %p0, i64 %p1)
%t9246 = call i64 @__m____________lib_word_resid__wi_or(i64 %p2, i64 %p3)
%t9247 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9245, i64 %t9246)
%t9248 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t9247, i64 256)
%t9249 = call i64 @__m____________lib_word_resid__wi_shr(i64 %t9248, i64 8)
%t9250 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9249, i64 24)
%t9251 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9240, i64 %t9244)
%t9252 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9251, i64 %t9250)
ret i64 %t9252
}
define ptr @__m____________lib_sha512g_resid__g5_hash__g_Int_64__UInt_64_(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9253 = call ptr @resid_listbuf_new()
%t9254 = call ptr @resid_listbuf_new()
%t9255 = call i64 @resid_list_len(ptr %p0)
%t9256 = call ptr @sha512g_pad(i64 %t9255)
%t9257 = call ptr @resid_list_freeze(ptr %t9256)
%t9258 = call ptr @__m____________lib_sha512g_resid__g5_lift_bytes__g_Int_64__UInt_64_(ptr %t9257, i64 0, ptr %t9253)
%t9259 = call ptr @resid_list_freeze(ptr %t9258)
%t9260 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t9259)
%t9261 = call ptr @__m____________lib_sha512g_resid__g5_lift_state__g_UInt_64__Int_64_(ptr %p1)
%t9262 = call i64 @resid_list_len(ptr %t9260)
%t9263 = call ptr @sha512g_blocks__g_Int_64__UInt_64_(ptr %t9260, i64 0, i64 %t9262, ptr %t9261)
%t9264 = call ptr @__m____________lib_sha512g_resid__g5_out__g_UInt_64__Int_64_(ptr %t9263, i64 %p2, i64 0, ptr %t9254)
ret ptr %t9264
}
define ptr @__m____________lib_sha512g_resid__g5_lift_bytes__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9272, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t9277, %tco.s0 ]
%t9265 = call i64 @resid_list_len(ptr %p0)
%t9266 = icmp sge i64 %p1, %t9265
br i1 %t9266, label %L1048, label %L1050
L1048:
%t9267 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty9267)
ret ptr %t9267
L1050:
%t9268 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t9269 = call i64 @resid_unbox_i64(ptr %t9268)
%t9271 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9269)
%t9272 = add nsw i64 %p1, 1
%t9273 = call i64 @__m____________lib_word_resid__di_byte(i64 %t9271, i64 0)
%t9274 = call ptr @resid_box_i64(i64 %t9273)
%t9277 = call ptr @resid_listbuf_push(ptr %p2, ptr %t9274)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__cg_state_w__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9279 = and i64 %p1, 4294967295
%t9280 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t9279)
%t9281 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 0)
%t9282 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 4)
%t9283 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 8)
%t9284 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 12)
%t9285 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 16)
%t9286 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 20)
%t9287 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 24)
%t9288 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 28)
%t9289 = alloca [16 x ptr]
%t9291 = call ptr @resid_box_i64(i64 1634760805)
%t9293 = getelementptr i8, ptr %t9289, i64 0
store ptr %t9291, ptr %t9293
%t9294 = call ptr @resid_box_i64(i64 857760878)
%t9296 = getelementptr i8, ptr %t9289, i64 8
store ptr %t9294, ptr %t9296
%t9297 = call ptr @resid_box_i64(i64 2036477234)
%t9299 = getelementptr i8, ptr %t9289, i64 16
store ptr %t9297, ptr %t9299
%t9300 = call ptr @resid_box_i64(i64 1797285236)
%t9302 = getelementptr i8, ptr %t9289, i64 24
store ptr %t9300, ptr %t9302
%t9303 = call ptr @resid_box_i64(i64 %t9281)
%t9305 = getelementptr i8, ptr %t9289, i64 32
store ptr %t9303, ptr %t9305
%t9306 = call ptr @resid_box_i64(i64 %t9282)
%t9308 = getelementptr i8, ptr %t9289, i64 40
store ptr %t9306, ptr %t9308
%t9309 = call ptr @resid_box_i64(i64 %t9283)
%t9311 = getelementptr i8, ptr %t9289, i64 48
store ptr %t9309, ptr %t9311
%t9312 = call ptr @resid_box_i64(i64 %t9284)
%t9314 = getelementptr i8, ptr %t9289, i64 56
store ptr %t9312, ptr %t9314
%t9315 = call ptr @resid_box_i64(i64 %t9285)
%t9317 = getelementptr i8, ptr %t9289, i64 64
store ptr %t9315, ptr %t9317
%t9318 = call ptr @resid_box_i64(i64 %t9286)
%t9320 = getelementptr i8, ptr %t9289, i64 72
store ptr %t9318, ptr %t9320
%t9321 = call ptr @resid_box_i64(i64 %t9287)
%t9323 = getelementptr i8, ptr %t9289, i64 80
store ptr %t9321, ptr %t9323
%t9324 = call ptr @resid_box_i64(i64 %t9288)
%t9326 = getelementptr i8, ptr %t9289, i64 88
store ptr %t9324, ptr %t9326
%t9327 = call ptr @resid_box_i64(i64 %t9280)
%t9329 = getelementptr i8, ptr %t9289, i64 96
store ptr %t9327, ptr %t9329
%t9330 = call ptr @resid_box_i64(i64 %p2)
%t9332 = getelementptr i8, ptr %t9289, i64 104
store ptr %t9330, ptr %t9332
%t9333 = call ptr @resid_box_i64(i64 %p3)
%t9335 = getelementptr i8, ptr %t9289, i64 112
store ptr %t9333, ptr %t9335
%t9336 = call ptr @resid_box_i64(i64 %p4)
%t9338 = getelementptr i8, ptr %t9289, i64 120
store ptr %t9336, ptr %t9338
%t9339 = call ptr @resid_list_new(i64 16, ptr %t9289, ptr @.lty9289)
ret ptr %t9339
}
define ptr @__m____________lib_chachag_resid__cg_words__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9340 = call ptr @resid_list_get(ptr %p0, i64 0)
%t9341 = call i64 @resid_unbox_i64(ptr %t9340)
%t9343 = call ptr @resid_list_get(ptr %p0, i64 1)
%t9344 = call i64 @resid_unbox_i64(ptr %t9343)
%t9346 = call ptr @resid_list_get(ptr %p0, i64 2)
%t9347 = call i64 @resid_unbox_i64(ptr %t9346)
%t9349 = call ptr @resid_list_get(ptr %p0, i64 3)
%t9350 = call i64 @resid_unbox_i64(ptr %t9349)
%t9352 = call ptr @resid_list_get(ptr %p0, i64 4)
%t9353 = call i64 @resid_unbox_i64(ptr %t9352)
%t9355 = call ptr @resid_list_get(ptr %p0, i64 5)
%t9356 = call i64 @resid_unbox_i64(ptr %t9355)
%t9358 = call ptr @resid_list_get(ptr %p0, i64 6)
%t9359 = call i64 @resid_unbox_i64(ptr %t9358)
%t9361 = call ptr @resid_list_get(ptr %p0, i64 7)
%t9362 = call i64 @resid_unbox_i64(ptr %t9361)
%t9364 = call ptr @resid_list_get(ptr %p0, i64 8)
%t9365 = call i64 @resid_unbox_i64(ptr %t9364)
%t9367 = call ptr @resid_list_get(ptr %p0, i64 9)
%t9368 = call i64 @resid_unbox_i64(ptr %t9367)
%t9370 = call ptr @resid_list_get(ptr %p0, i64 10)
%t9371 = call i64 @resid_unbox_i64(ptr %t9370)
%t9373 = call ptr @resid_list_get(ptr %p0, i64 11)
%t9374 = call i64 @resid_unbox_i64(ptr %t9373)
%t9376 = call ptr @resid_list_get(ptr %p0, i64 13)
%t9377 = call i64 @resid_unbox_i64(ptr %t9376)
%t9379 = call ptr @resid_list_get(ptr %p0, i64 14)
%t9380 = call i64 @resid_unbox_i64(ptr %t9379)
%t9382 = call ptr @resid_list_get(ptr %p0, i64 15)
%t9383 = call i64 @resid_unbox_i64(ptr %t9382)
%t9385 = call ptr @__m____________lib_chachag_resid__cg_core__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 10, i64 %t9341, i64 %t9344, i64 %t9347, i64 %t9350, i64 %t9353, i64 %t9356, i64 %t9359, i64 %t9362, i64 %t9365, i64 %t9368, i64 %t9371, i64 %t9374, i64 %p1, i64 %t9377, i64 %t9380, i64 %t9383)
ret ptr %t9385
}
define ptr @__m____________lib_chachag_resid__cg_ser__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9388, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t9399, %tco.s0 ]
%t9386 = icmp sge i64 %p1, 64
br i1 %t9386, label %L1051, label %L1053
L1051:
%t9387 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty9387)
ret ptr %t9387
L1053:
%t9388 = add nsw i64 %p1, 1
%t9389 = sdiv i64 %p1, 4
%t9390 = call ptr @resid_list_get_v(ptr %p0, i64 %t9389, ptr %p0.ld, i64 %p0.ln)
%t9391 = call i64 @resid_unbox_i64(ptr %t9390)
%t9393 = srem i64 %p1, 4
%t9394 = mul nsw i64 %t9393, 8
%t9395 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t9391, i64 %t9394)
%t9396 = call ptr @resid_box_i64(i64 %t9395)
%t9399 = call ptr @resid_listbuf_push(ptr %p2, ptr %t9396)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__cg_xor_bytes__g_Int_64__Int_64_(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9402, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi ptr [ %p5.in, %entry ], [ %t9421, %tco.s0 ]
%t9401 = icmp sge i64 %p3, %p4
br i1 %t9401, label %L1054, label %L1056
L1054:
ret ptr %p5
L1056:
%t9402 = add nsw i64 %p3, 1
%t9403 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %p3)
%t9404 = extractvalue {i64, i1} %t9403, 0
%t9405 = extractvalue {i64, i1} %t9403, 1
%t9406 = zext i1 %t9405 to i8
call void @resid_overflow_check(i8 %t9406)
%t9407 = call ptr @resid_list_get_v(ptr %p1, i64 %t9404, ptr %p1.ld, i64 %p1.ln)
%t9408 = call i64 @resid_unbox_i64(ptr %t9407)
%t9410 = sdiv i64 %p3, 4
%t9411 = call ptr @resid_list_get_v(ptr %p0, i64 %t9410, ptr %p0.ld, i64 %p0.ln)
%t9412 = call i64 @resid_unbox_i64(ptr %t9411)
%t9414 = srem i64 %p3, 4
%t9415 = mul nsw i64 %t9414, 8
%t9416 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t9412, i64 %t9415)
%t9417 = call i64 @__m____________lib_word_resid__bi_xor(i64 %t9408, i64 %t9416)
%t9418 = call ptr @resid_box_i64(i64 %t9417)
%t9421 = call ptr @resid_listbuf_push(ptr %p5, ptr %t9418)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m____________lib_chachag_resid__pg_reduce__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9423 = sext i256 1361129467683753853853498429727072845823 to i512
%t9424 = call i512 @__m____________lib_word_resid__pi_and(i512 %p0, i512 %t9423)
%t9425 = call i512 @__m____________lib_word_resid__pi_shr(i512 %p0, i64 130)
%t9426 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t9425, i512 5)
%t9427 = call i512 @__m____________lib_word_resid__pi_add(i512 %t9424, i512 %t9426)
%t9428 = sext i256 1361129467683753853853498429727072845823 to i512
%t9429 = call i512 @__m____________lib_word_resid__pi_and(i512 %t9427, i512 %t9428)
%t9430 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t9427, i64 130)
%t9431 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t9430, i512 5)
%t9432 = call i512 @__m____________lib_word_resid__pi_add(i512 %t9429, i512 %t9431)
%t9433 = sext i256 1361129467683753853853498429727072845819 to i512
%t9434 = call i512 @__m____________lib_word_resid__pi_sub(i512 %t9432, i512 %t9433)
%t9435 = call i512 @__m____________lib_word_resid__pi_sign(i512 %t9434)
%t9436 = call i512 @__m____________lib_word_resid__pi_and(i512 %t9432, i512 %t9435)
%t9437 = sext i64 -1 to i512
%t9438 = call i512 @__m____________lib_word_resid__pi_xor(i512 %t9435, i512 %t9437)
%t9439 = call i512 @__m____________lib_word_resid__pi_and(i512 %t9434, i512 %t9438)
%t9440 = call i512 @__m____________lib_word_resid__pi_or(i512 %t9436, i512 %t9439)
ret i512 %t9440
}
define i64 @__m____________lib_sha256g_resid__g_word_at__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9441 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t9442 = extractvalue {i64, i1} %t9441, 0
%t9443 = extractvalue {i64, i1} %t9441, 1
%t9444 = zext i1 %t9443 to i8
call void @resid_overflow_check(i8 %t9444)
%t9445 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t9442)
%t9446 = extractvalue {i64, i1} %t9445, 0
%t9447 = extractvalue {i64, i1} %t9445, 1
%t9448 = zext i1 %t9447 to i8
call void @resid_overflow_check(i8 %t9448)
%t9449 = call ptr @resid_list_get(ptr %p0, i64 %t9446)
%t9450 = call i64 @resid_unbox_i64(ptr %t9449)
%t9452 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9450)
%t9453 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9452, i64 24)
%t9454 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t9446, i64 1)
%t9455 = extractvalue {i64, i1} %t9454, 0
%t9456 = extractvalue {i64, i1} %t9454, 1
%t9457 = zext i1 %t9456 to i8
call void @resid_overflow_check(i8 %t9457)
%t9458 = call ptr @resid_list_get(ptr %p0, i64 %t9455)
%t9459 = call i64 @resid_unbox_i64(ptr %t9458)
%t9461 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9459)
%t9462 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9461, i64 16)
%t9463 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9453, i64 %t9462)
%t9464 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t9446, i64 2)
%t9465 = extractvalue {i64, i1} %t9464, 0
%t9466 = extractvalue {i64, i1} %t9464, 1
%t9467 = zext i1 %t9466 to i8
call void @resid_overflow_check(i8 %t9467)
%t9468 = call ptr @resid_list_get(ptr %p0, i64 %t9465)
%t9469 = call i64 @resid_unbox_i64(ptr %t9468)
%t9471 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9469)
%t9472 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9471, i64 8)
%t9473 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t9446, i64 3)
%t9474 = extractvalue {i64, i1} %t9473, 0
%t9475 = extractvalue {i64, i1} %t9473, 1
%t9476 = zext i1 %t9475 to i8
call void @resid_overflow_check(i8 %t9476)
%t9477 = call ptr @resid_list_get(ptr %p0, i64 %t9474)
%t9478 = call i64 @resid_unbox_i64(ptr %t9477)
%t9480 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9478)
%t9481 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9472, i64 %t9480)
%t9482 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9463, i64 %t9481)
ret i64 %t9482
}
define i64 @__m____________lib_sha256g_resid__g_ssig1__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9483 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 17)
%t9484 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 19)
%t9485 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9483, i64 %t9484)
%t9486 = call i64 @__m____________lib_word_resid__wi_shr(i64 %p0, i64 10)
%t9487 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9485, i64 %t9486)
ret i64 %t9487
}
define i64 @__m____________lib_sha256g_resid__g_ssig0__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9488 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 7)
%t9489 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 18)
%t9490 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9488, i64 %t9489)
%t9491 = call i64 @__m____________lib_word_resid__wi_shr(i64 %p0, i64 3)
%t9492 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9490, i64 %t9491)
ret i64 %t9492
}
define i64 @b64g_sextet__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9493 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 65, i64 90)
%t9494 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 97, i64 122)
%t9495 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 48, i64 57)
%t9496 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 43, i64 43)
%t9497 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 47, i64 47)
%t9498 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t9493)
%t9499 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 -65)
%t9500 = call i64 @__m____________lib_word_resid__wi_and(i64 %t9498, i64 %t9499)
%t9501 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t9494)
%t9502 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 -71)
%t9503 = call i64 @__m____________lib_word_resid__wi_and(i64 %t9501, i64 %t9502)
%t9504 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9500, i64 %t9503)
%t9505 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t9495)
%t9506 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 4)
%t9507 = call i64 @__m____________lib_word_resid__wi_and(i64 %t9505, i64 %t9506)
%t9508 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t9496)
%t9509 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t9508, i64 62)
%t9510 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t9497)
%t9511 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t9510, i64 63)
%t9512 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9509, i64 %t9511)
%t9513 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9507, i64 %t9512)
%t9514 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9493, i64 %t9494)
%t9515 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9496, i64 %t9497)
%t9516 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9495, i64 %t9515)
%t9517 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9514, i64 %t9516)
%t9518 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9504, i64 %t9513)
%t9519 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t9518, i64 63)
%t9520 = call i64 @__m____________lib_word_resid__wi_xork(i64 %t9517, i64 1)
%t9521 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9520, i64 8)
%t9522 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9519, i64 %t9521)
ret i64 %t9522
}
define ptr @__m____________lib_sha512g_resid__g5_lift_state__g_UInt_64__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9523 = call ptr @resid_gmalloc(i64 64)
%t9524 = call ptr @resid_list_get(ptr %p0, i64 0)
%t9525 = call i64 @resid_unbox_i64(ptr %t9524)
%t9527 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9525)
%t9523.f0 = getelementptr i8, ptr %t9523, i64 0
store i64 %t9527, ptr %t9523.f0, align 8
%t9528 = call ptr @resid_list_get(ptr %p0, i64 1)
%t9529 = call i64 @resid_unbox_i64(ptr %t9528)
%t9531 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9529)
%t9523.f1 = getelementptr i8, ptr %t9523, i64 8
store i64 %t9531, ptr %t9523.f1, align 8
%t9532 = call ptr @resid_list_get(ptr %p0, i64 2)
%t9533 = call i64 @resid_unbox_i64(ptr %t9532)
%t9535 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9533)
%t9523.f2 = getelementptr i8, ptr %t9523, i64 16
store i64 %t9535, ptr %t9523.f2, align 8
%t9536 = call ptr @resid_list_get(ptr %p0, i64 3)
%t9537 = call i64 @resid_unbox_i64(ptr %t9536)
%t9539 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9537)
%t9523.f3 = getelementptr i8, ptr %t9523, i64 24
store i64 %t9539, ptr %t9523.f3, align 8
%t9540 = call ptr @resid_list_get(ptr %p0, i64 4)
%t9541 = call i64 @resid_unbox_i64(ptr %t9540)
%t9543 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9541)
%t9523.f4 = getelementptr i8, ptr %t9523, i64 32
store i64 %t9543, ptr %t9523.f4, align 8
%t9544 = call ptr @resid_list_get(ptr %p0, i64 5)
%t9545 = call i64 @resid_unbox_i64(ptr %t9544)
%t9547 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9545)
%t9523.f5 = getelementptr i8, ptr %t9523, i64 40
store i64 %t9547, ptr %t9523.f5, align 8
%t9548 = call ptr @resid_list_get(ptr %p0, i64 6)
%t9549 = call i64 @resid_unbox_i64(ptr %t9548)
%t9551 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9549)
%t9523.f6 = getelementptr i8, ptr %t9523, i64 48
store i64 %t9551, ptr %t9523.f6, align 8
%t9552 = call ptr @resid_list_get(ptr %p0, i64 7)
%t9553 = call i64 @resid_unbox_i64(ptr %t9552)
%t9555 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9553)
%t9523.f7 = getelementptr i8, ptr %t9523, i64 56
store i64 %t9555, ptr %t9523.f7, align 8
ret ptr %t9523
}
define ptr @sha512g_blocks__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9558, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t9556 = icmp sge i64 %p1, %p2
br i1 %t9556, label %L1057, label %L1059
L1057:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L1059:
%t9557 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 128)
%t9558 = extractvalue {i64, i1} %t9557, 0
%t9559 = extractvalue {i64, i1} %t9557, 1
%t9560 = zext i1 %t9559 to i8
call void @resid_overflow_check(i8 %t9560)
%t9561 = call ptr @sha512g_block__g_Int_64__UInt_64_(ptr %p0, i64 %p1, ptr %p3)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %t9561, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t9561, %tco.s0 ]
br label %tco.head
}
define ptr @__m____________lib_sha512g_resid__g5_out__g_UInt_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9565, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t9575, %tco.s0 ]
%t9563 = icmp sge i64 %p2, %p1
br i1 %t9563, label %L1060, label %L1062
L1060:
%t9564 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty9564)
ret ptr %t9564
L1062:
%t9565 = add nsw i64 %p2, 1
%t9566 = sdiv i64 %p2, 8
%t9567 = call i64 @__m____________lib_sha512g_resid__g5_state_word__g_UInt_64__Int_64_(ptr %p0, i64 %t9566)
%t9568 = srem i64 %p2, 8
%t9569 = mul nsw i64 %t9568, 8
%t9570 = sub nsw i64 56, %t9569
%t9571 = call i64 @__m____________lib_word_resid__di_byte(i64 %t9567, i64 %t9570)
%t9572 = call ptr @resid_box_i64(i64 %t9571)
%t9575 = call ptr @resid_listbuf_push(ptr %p3, ptr %t9572)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9577 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t9578 = call i64 @resid_unbox_i64(ptr %t9577)
%t9580 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9578)
%t9581 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t9582 = extractvalue {i64, i1} %t9581, 0
%t9583 = extractvalue {i64, i1} %t9581, 1
%t9584 = zext i1 %t9583 to i8
call void @resid_overflow_check(i8 %t9584)
%t9585 = call ptr @resid_list_get(ptr %p0, i64 %t9582)
%t9586 = call i64 @resid_unbox_i64(ptr %t9585)
%t9588 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9586)
%t9589 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9588, i64 8)
%t9590 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9580, i64 %t9589)
%t9591 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t9592 = extractvalue {i64, i1} %t9591, 0
%t9593 = extractvalue {i64, i1} %t9591, 1
%t9594 = zext i1 %t9593 to i8
call void @resid_overflow_check(i8 %t9594)
%t9595 = call ptr @resid_list_get(ptr %p0, i64 %t9592)
%t9596 = call i64 @resid_unbox_i64(ptr %t9595)
%t9598 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9596)
%t9599 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9598, i64 16)
%t9600 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 3)
%t9601 = extractvalue {i64, i1} %t9600, 0
%t9602 = extractvalue {i64, i1} %t9600, 1
%t9603 = zext i1 %t9602 to i8
call void @resid_overflow_check(i8 %t9603)
%t9604 = call ptr @resid_list_get(ptr %p0, i64 %t9601)
%t9605 = call i64 @resid_unbox_i64(ptr %t9604)
%t9607 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9605)
%t9608 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9607, i64 24)
%t9609 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9599, i64 %t9608)
%t9610 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9590, i64 %t9609)
ret i64 %t9610
}
define ptr @__m____________lib_chachag_resid__cg_core__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9673 = alloca [16 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9821, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9778, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t9790, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t9802, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %t9814, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %t9819, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t9783, %tco.s0.k ]
%p9 = phi i64 [ %p9.in, %entry ], [ %t9795, %tco.s0.k ]
%p10 = phi i64 [ %p10.in, %entry ], [ %t9807, %tco.s0.k ]
%p11 = phi i64 [ %p11.in, %entry ], [ %t9805, %tco.s0.k ]
%p12 = phi i64 [ %p12.in, %entry ], [ %t9817, %tco.s0.k ]
%p13 = phi i64 [ %p13.in, %entry ], [ %t9781, %tco.s0.k ]
%p14 = phi i64 [ %p14.in, %entry ], [ %t9793, %tco.s0.k ]
%p15 = phi i64 [ %p15.in, %entry ], [ %t9792, %tco.s0.k ]
%p16 = phi i64 [ %p16.in, %entry ], [ %t9804, %tco.s0.k ]
%p17 = phi i64 [ %p17.in, %entry ], [ %t9816, %tco.s0.k ]
%p18 = phi i64 [ %p18.in, %entry ], [ %t9780, %tco.s0.k ]
%t9611 = icmp eq i64 %p2, 0
br i1 %t9611, label %L1063, label %L1065
L1063:
%t9612 = call ptr @resid_list_get_v(ptr %p0, i64 0, ptr %p0.ld, i64 %p0.ln)
%t9613 = call i64 @resid_unbox_i64(ptr %t9612)
%t9615 = call i64 @__m____________lib_word_resid__wi_add(i64 %p3, i64 %t9613)
%t9616 = call ptr @resid_list_get_v(ptr %p0, i64 1, ptr %p0.ld, i64 %p0.ln)
%t9617 = call i64 @resid_unbox_i64(ptr %t9616)
%t9619 = call i64 @__m____________lib_word_resid__wi_add(i64 %p4, i64 %t9617)
%t9620 = call ptr @resid_list_get_v(ptr %p0, i64 2, ptr %p0.ld, i64 %p0.ln)
%t9621 = call i64 @resid_unbox_i64(ptr %t9620)
%t9623 = call i64 @__m____________lib_word_resid__wi_add(i64 %p5, i64 %t9621)
%t9624 = call ptr @resid_list_get_v(ptr %p0, i64 3, ptr %p0.ld, i64 %p0.ln)
%t9625 = call i64 @resid_unbox_i64(ptr %t9624)
%t9627 = call i64 @__m____________lib_word_resid__wi_add(i64 %p6, i64 %t9625)
%t9628 = call ptr @resid_list_get_v(ptr %p0, i64 4, ptr %p0.ld, i64 %p0.ln)
%t9629 = call i64 @resid_unbox_i64(ptr %t9628)
%t9631 = call i64 @__m____________lib_word_resid__wi_add(i64 %p7, i64 %t9629)
%t9632 = call ptr @resid_list_get_v(ptr %p0, i64 5, ptr %p0.ld, i64 %p0.ln)
%t9633 = call i64 @resid_unbox_i64(ptr %t9632)
%t9635 = call i64 @__m____________lib_word_resid__wi_add(i64 %p8, i64 %t9633)
%t9636 = call ptr @resid_list_get_v(ptr %p0, i64 6, ptr %p0.ld, i64 %p0.ln)
%t9637 = call i64 @resid_unbox_i64(ptr %t9636)
%t9639 = call i64 @__m____________lib_word_resid__wi_add(i64 %p9, i64 %t9637)
%t9640 = call ptr @resid_list_get_v(ptr %p0, i64 7, ptr %p0.ld, i64 %p0.ln)
%t9641 = call i64 @resid_unbox_i64(ptr %t9640)
%t9643 = call i64 @__m____________lib_word_resid__wi_add(i64 %p10, i64 %t9641)
%t9644 = call ptr @resid_list_get_v(ptr %p0, i64 8, ptr %p0.ld, i64 %p0.ln)
%t9645 = call i64 @resid_unbox_i64(ptr %t9644)
%t9647 = call i64 @__m____________lib_word_resid__wi_add(i64 %p11, i64 %t9645)
%t9648 = call ptr @resid_list_get_v(ptr %p0, i64 9, ptr %p0.ld, i64 %p0.ln)
%t9649 = call i64 @resid_unbox_i64(ptr %t9648)
%t9651 = call i64 @__m____________lib_word_resid__wi_add(i64 %p12, i64 %t9649)
%t9652 = call ptr @resid_list_get_v(ptr %p0, i64 10, ptr %p0.ld, i64 %p0.ln)
%t9653 = call i64 @resid_unbox_i64(ptr %t9652)
%t9655 = call i64 @__m____________lib_word_resid__wi_add(i64 %p13, i64 %t9653)
%t9656 = call ptr @resid_list_get_v(ptr %p0, i64 11, ptr %p0.ld, i64 %p0.ln)
%t9657 = call i64 @resid_unbox_i64(ptr %t9656)
%t9659 = call i64 @__m____________lib_word_resid__wi_add(i64 %p14, i64 %t9657)
%t9660 = call i64 @__m____________lib_word_resid__wi_add(i64 %p15, i64 %p1)
%t9661 = call ptr @resid_list_get_v(ptr %p0, i64 13, ptr %p0.ld, i64 %p0.ln)
%t9662 = call i64 @resid_unbox_i64(ptr %t9661)
%t9664 = call i64 @__m____________lib_word_resid__wi_add(i64 %p16, i64 %t9662)
%t9665 = call ptr @resid_list_get_v(ptr %p0, i64 14, ptr %p0.ld, i64 %p0.ln)
%t9666 = call i64 @resid_unbox_i64(ptr %t9665)
%t9668 = call i64 @__m____________lib_word_resid__wi_add(i64 %p17, i64 %t9666)
%t9669 = call ptr @resid_list_get_v(ptr %p0, i64 15, ptr %p0.ld, i64 %p0.ln)
%t9670 = call i64 @resid_unbox_i64(ptr %t9669)
%t9672 = call i64 @__m____________lib_word_resid__wi_add(i64 %p18, i64 %t9670)
%t9675 = call ptr @resid_box_i64(i64 %t9615)
%t9677 = getelementptr i8, ptr %t9673, i64 0
store ptr %t9675, ptr %t9677
%t9678 = call ptr @resid_box_i64(i64 %t9619)
%t9680 = getelementptr i8, ptr %t9673, i64 8
store ptr %t9678, ptr %t9680
%t9681 = call ptr @resid_box_i64(i64 %t9623)
%t9683 = getelementptr i8, ptr %t9673, i64 16
store ptr %t9681, ptr %t9683
%t9684 = call ptr @resid_box_i64(i64 %t9627)
%t9686 = getelementptr i8, ptr %t9673, i64 24
store ptr %t9684, ptr %t9686
%t9687 = call ptr @resid_box_i64(i64 %t9631)
%t9689 = getelementptr i8, ptr %t9673, i64 32
store ptr %t9687, ptr %t9689
%t9690 = call ptr @resid_box_i64(i64 %t9635)
%t9692 = getelementptr i8, ptr %t9673, i64 40
store ptr %t9690, ptr %t9692
%t9693 = call ptr @resid_box_i64(i64 %t9639)
%t9695 = getelementptr i8, ptr %t9673, i64 48
store ptr %t9693, ptr %t9695
%t9696 = call ptr @resid_box_i64(i64 %t9643)
%t9698 = getelementptr i8, ptr %t9673, i64 56
store ptr %t9696, ptr %t9698
%t9699 = call ptr @resid_box_i64(i64 %t9647)
%t9701 = getelementptr i8, ptr %t9673, i64 64
store ptr %t9699, ptr %t9701
%t9702 = call ptr @resid_box_i64(i64 %t9651)
%t9704 = getelementptr i8, ptr %t9673, i64 72
store ptr %t9702, ptr %t9704
%t9705 = call ptr @resid_box_i64(i64 %t9655)
%t9707 = getelementptr i8, ptr %t9673, i64 80
store ptr %t9705, ptr %t9707
%t9708 = call ptr @resid_box_i64(i64 %t9659)
%t9710 = getelementptr i8, ptr %t9673, i64 88
store ptr %t9708, ptr %t9710
%t9711 = call ptr @resid_box_i64(i64 %t9660)
%t9713 = getelementptr i8, ptr %t9673, i64 96
store ptr %t9711, ptr %t9713
%t9714 = call ptr @resid_box_i64(i64 %t9664)
%t9716 = getelementptr i8, ptr %t9673, i64 104
store ptr %t9714, ptr %t9716
%t9717 = call ptr @resid_box_i64(i64 %t9668)
%t9719 = getelementptr i8, ptr %t9673, i64 112
store ptr %t9717, ptr %t9719
%t9720 = call ptr @resid_box_i64(i64 %t9672)
%t9722 = getelementptr i8, ptr %t9673, i64 120
store ptr %t9720, ptr %t9722
%t9723 = call ptr @resid_list_new(i64 16, ptr %t9673, ptr @.lty9673)
%lr.cx124 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz124 = icmp eq ptr %lr.cx124, null
br i1 %lr.lz124, label %lr.x124.k, label %lr.x124.m
lr.x124.k:
ret ptr %t9723
lr.x124.m:
%lr.ret124 = call ptr @resid_mv_list(ptr %t9723, ptr %lr.cx124)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret124
L1065:
%t9724 = call i64 @__m____________lib_word_resid__wi_add(i64 %p3, i64 %p7)
%t9725 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p15, i64 %t9724)
%t9726 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9725, i64 16)
%t9727 = call i64 @__m____________lib_word_resid__wi_add(i64 %p11, i64 %t9726)
%t9728 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p7, i64 %t9727)
%t9729 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9728, i64 20)
%t9730 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9724, i64 %t9729)
%t9731 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9726, i64 %t9730)
%t9732 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9731, i64 24)
%t9733 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9727, i64 %t9732)
%t9734 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9729, i64 %t9733)
%t9735 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9734, i64 25)
%t9736 = call i64 @__m____________lib_word_resid__wi_add(i64 %p4, i64 %p8)
%t9737 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p16, i64 %t9736)
%t9738 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9737, i64 16)
%t9739 = call i64 @__m____________lib_word_resid__wi_add(i64 %p12, i64 %t9738)
%t9740 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p8, i64 %t9739)
%t9741 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9740, i64 20)
%t9742 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9736, i64 %t9741)
%t9743 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9738, i64 %t9742)
%t9744 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9743, i64 24)
%t9745 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9739, i64 %t9744)
%t9746 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9741, i64 %t9745)
%t9747 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9746, i64 25)
%t9748 = call i64 @__m____________lib_word_resid__wi_add(i64 %p5, i64 %p9)
%t9749 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p17, i64 %t9748)
%t9750 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9749, i64 16)
%t9751 = call i64 @__m____________lib_word_resid__wi_add(i64 %p13, i64 %t9750)
%t9752 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p9, i64 %t9751)
%t9753 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9752, i64 20)
%t9754 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9748, i64 %t9753)
%t9755 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9750, i64 %t9754)
%t9756 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9755, i64 24)
%t9757 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9751, i64 %t9756)
%t9758 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9753, i64 %t9757)
%t9759 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9758, i64 25)
%t9760 = call i64 @__m____________lib_word_resid__wi_add(i64 %p6, i64 %p10)
%t9761 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p18, i64 %t9760)
%t9762 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9761, i64 16)
%t9763 = call i64 @__m____________lib_word_resid__wi_add(i64 %p14, i64 %t9762)
%t9764 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p10, i64 %t9763)
%t9765 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9764, i64 20)
%t9766 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9760, i64 %t9765)
%t9767 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9762, i64 %t9766)
%t9768 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9767, i64 24)
%t9769 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9763, i64 %t9768)
%t9770 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9765, i64 %t9769)
%t9771 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9770, i64 25)
%t9772 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9730, i64 %t9747)
%t9773 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9768, i64 %t9772)
%t9774 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9773, i64 16)
%t9775 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9757, i64 %t9774)
%t9776 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9747, i64 %t9775)
%t9777 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9776, i64 20)
%t9778 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9772, i64 %t9777)
%t9779 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9774, i64 %t9778)
%t9780 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9779, i64 24)
%t9781 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9775, i64 %t9780)
%t9782 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9777, i64 %t9781)
%t9783 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9782, i64 25)
%t9784 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9742, i64 %t9759)
%t9785 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9732, i64 %t9784)
%t9786 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9785, i64 16)
%t9787 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9769, i64 %t9786)
%t9788 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9759, i64 %t9787)
%t9789 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9788, i64 20)
%t9790 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9784, i64 %t9789)
%t9791 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9786, i64 %t9790)
%t9792 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9791, i64 24)
%t9793 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9787, i64 %t9792)
%t9794 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9789, i64 %t9793)
%t9795 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9794, i64 25)
%t9796 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9754, i64 %t9771)
%t9797 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9744, i64 %t9796)
%t9798 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9797, i64 16)
%t9799 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9733, i64 %t9798)
%t9800 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9771, i64 %t9799)
%t9801 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9800, i64 20)
%t9802 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9796, i64 %t9801)
%t9803 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9798, i64 %t9802)
%t9804 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9803, i64 24)
%t9805 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9799, i64 %t9804)
%t9806 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9801, i64 %t9805)
%t9807 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9806, i64 25)
%t9808 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9766, i64 %t9735)
%t9809 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9756, i64 %t9808)
%t9810 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9809, i64 16)
%t9811 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9745, i64 %t9810)
%t9812 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9735, i64 %t9811)
%t9813 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9812, i64 20)
%t9814 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9808, i64 %t9813)
%t9815 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9810, i64 %t9814)
%t9816 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9815, i64 24)
%t9817 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9811, i64 %t9816)
%t9818 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9813, i64 %t9817)
%t9819 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9818, i64 25)
%t9820 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 1)
%t9821 = extractvalue {i64, i1} %t9820, 0
%t9822 = extractvalue {i64, i1} %t9820, 1
%t9823 = zext i1 %t9822 to i8
call void @resid_overflow_check(i8 %t9823)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
br label %tco.head
}
define i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9825 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p1)
%t9826 = extractvalue {i64, i1} %t9825, 0
%t9827 = extractvalue {i64, i1} %t9825, 1
%t9828 = zext i1 %t9827 to i8
call void @resid_overflow_check(i8 %t9828)
%t9829 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 %t9826)
%t9830 = call i64 @__m____________lib_word_resid__wi_not(i64 %p0)
%t9831 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t9832 = extractvalue {i64, i1} %t9831, 0
%t9833 = extractvalue {i64, i1} %t9831, 1
%t9834 = zext i1 %t9833 to i8
call void @resid_overflow_check(i8 %t9834)
%t9835 = call i64 @__m____________lib_word_resid__wi_addk(i64 %t9830, i64 %t9832)
%t9836 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9829, i64 %t9835)
%t9837 = call i64 @__m____________lib_word_resid__wi_shr(i64 %t9836, i64 31)
%t9838 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t9837, i64 1)
%t9839 = call i64 @__m____________lib_word_resid__wi_xork(i64 %t9838, i64 1)
ret i64 %t9839
}
define i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9840 = call i64 @__m____________lib_word_resid__wi_not(i64 %p0)
%t9841 = call i64 @__m____________lib_word_resid__wi_addk(i64 %t9840, i64 1)
ret i64 %t9841
}
define ptr @sha512g_block__g_Int_64__UInt_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9842 = add i64 4794697086780616226, 0
%t9843 = add i64 %t9842, 0
%t9844 = add i64 %t9843, 0
%t9845 = icmp ne i64 %t9844, %t9842
%t9846 = icmp slt i64 4794697086780616226, 0
%t9847 = or i1 %t9845, %t9846
%t9848 = zext i1 %t9847 to i8
call void @resid_conv_check(i8 %t9848)
%t9849 = add i64 8158064640168781261, 0
%t9850 = add i64 %t9849, 0
%t9851 = add i64 %t9850, 0
%t9852 = icmp ne i64 %t9851, %t9849
%t9853 = icmp slt i64 8158064640168781261, 0
%t9854 = or i1 %t9852, %t9853
%t9855 = zext i1 %t9854 to i8
call void @resid_conv_check(i8 %t9855)
%t9856 = add i128 13096744586834688815, 0
%t9857 = trunc i128 %t9856 to i64
%t9858 = zext i64 %t9857 to i128
%t9859 = icmp ne i128 %t9858, %t9856
%t9860 = icmp slt i128 13096744586834688815, 0
%t9861 = or i1 %t9859, %t9860
%t9862 = zext i1 %t9861 to i8
call void @resid_conv_check(i8 %t9862)
%t9863 = add i128 16840607885511220156, 0
%t9864 = trunc i128 %t9863 to i64
%t9865 = zext i64 %t9864 to i128
%t9866 = icmp ne i128 %t9865, %t9863
%t9867 = icmp slt i128 16840607885511220156, 0
%t9868 = or i1 %t9866, %t9867
%t9869 = zext i1 %t9868 to i8
call void @resid_conv_check(i8 %t9869)
%t9870 = add i64 4131703408338449720, 0
%t9871 = add i64 %t9870, 0
%t9872 = add i64 %t9871, 0
%t9873 = icmp ne i64 %t9872, %t9870
%t9874 = icmp slt i64 4131703408338449720, 0
%t9875 = or i1 %t9873, %t9874
%t9876 = zext i1 %t9875 to i8
call void @resid_conv_check(i8 %t9876)
%t9877 = add i64 6480981068601479193, 0
%t9878 = add i64 %t9877, 0
%t9879 = add i64 %t9878, 0
%t9880 = icmp ne i64 %t9879, %t9877
%t9881 = icmp slt i64 6480981068601479193, 0
%t9882 = or i1 %t9880, %t9881
%t9883 = zext i1 %t9882 to i8
call void @resid_conv_check(i8 %t9883)
%t9884 = add i128 10538285296894168987, 0
%t9885 = trunc i128 %t9884 to i64
%t9886 = zext i64 %t9885 to i128
%t9887 = icmp ne i128 %t9886, %t9884
%t9888 = icmp slt i128 10538285296894168987, 0
%t9889 = or i1 %t9887, %t9888
%t9890 = zext i1 %t9889 to i8
call void @resid_conv_check(i8 %t9890)
%t9891 = add i128 12329834152419229976, 0
%t9892 = trunc i128 %t9891 to i64
%t9893 = zext i64 %t9892 to i128
%t9894 = icmp ne i128 %t9893, %t9891
%t9895 = icmp slt i128 12329834152419229976, 0
%t9896 = or i1 %t9894, %t9895
%t9897 = zext i1 %t9896 to i8
call void @resid_conv_check(i8 %t9897)
%t9898 = add i128 15566598209576043074, 0
%t9899 = trunc i128 %t9898 to i64
%t9900 = zext i64 %t9899 to i128
%t9901 = icmp ne i128 %t9900, %t9898
%t9902 = icmp slt i128 15566598209576043074, 0
%t9903 = or i1 %t9901, %t9902
%t9904 = zext i1 %t9903 to i8
call void @resid_conv_check(i8 %t9904)
%t9905 = add i64 1334009975649890238, 0
%t9906 = add i64 %t9905, 0
%t9907 = add i64 %t9906, 0
%t9908 = icmp ne i64 %t9907, %t9905
%t9909 = icmp slt i64 1334009975649890238, 0
%t9910 = or i1 %t9908, %t9909
%t9911 = zext i1 %t9910 to i8
call void @resid_conv_check(i8 %t9911)
%t9912 = add i64 2608012711638119052, 0
%t9913 = add i64 %t9912, 0
%t9914 = add i64 %t9913, 0
%t9915 = icmp ne i64 %t9914, %t9912
%t9916 = icmp slt i64 2608012711638119052, 0
%t9917 = or i1 %t9915, %t9916
%t9918 = zext i1 %t9917 to i8
call void @resid_conv_check(i8 %t9918)
%t9919 = add i64 6128411473006802146, 0
%t9920 = add i64 %t9919, 0
%t9921 = add i64 %t9920, 0
%t9922 = icmp ne i64 %t9921, %t9919
%t9923 = icmp slt i64 6128411473006802146, 0
%t9924 = or i1 %t9922, %t9923
%t9925 = zext i1 %t9924 to i8
call void @resid_conv_check(i8 %t9925)
%t9926 = add i64 8268148722764581231, 0
%t9927 = add i64 %t9926, 0
%t9928 = add i64 %t9927, 0
%t9929 = icmp ne i64 %t9928, %t9926
%t9930 = icmp slt i64 8268148722764581231, 0
%t9931 = or i1 %t9929, %t9930
%t9932 = zext i1 %t9931 to i8
call void @resid_conv_check(i8 %t9932)
%t9933 = add i128 9286055187155687089, 0
%t9934 = trunc i128 %t9933 to i64
%t9935 = zext i64 %t9934 to i128
%t9936 = icmp ne i128 %t9935, %t9933
%t9937 = icmp slt i128 9286055187155687089, 0
%t9938 = or i1 %t9936, %t9937
%t9939 = zext i1 %t9938 to i8
call void @resid_conv_check(i8 %t9939)
%t9940 = add i128 11230858885718282805, 0
%t9941 = trunc i128 %t9940 to i64
%t9942 = zext i64 %t9941 to i128
%t9943 = icmp ne i128 %t9942, %t9940
%t9944 = icmp slt i128 11230858885718282805, 0
%t9945 = or i1 %t9943, %t9944
%t9946 = zext i1 %t9945 to i8
call void @resid_conv_check(i8 %t9946)
%t9947 = add i128 13951009754708518548, 0
%t9948 = trunc i128 %t9947 to i64
%t9949 = zext i64 %t9948 to i128
%t9950 = icmp ne i128 %t9949, %t9947
%t9951 = icmp slt i128 13951009754708518548, 0
%t9952 = or i1 %t9950, %t9951
%t9953 = zext i1 %t9952 to i8
call void @resid_conv_check(i8 %t9953)
%t9954 = add i128 16472876342353939154, 0
%t9955 = trunc i128 %t9954 to i64
%t9956 = zext i64 %t9955 to i128
%t9957 = icmp ne i128 %t9956, %t9954
%t9958 = icmp slt i128 16472876342353939154, 0
%t9959 = or i1 %t9957, %t9958
%t9960 = zext i1 %t9959 to i8
call void @resid_conv_check(i8 %t9960)
%t9961 = add i128 17275323862435702243, 0
%t9962 = trunc i128 %t9961 to i64
%t9963 = zext i64 %t9962 to i128
%t9964 = icmp ne i128 %t9963, %t9961
%t9965 = icmp slt i128 17275323862435702243, 0
%t9966 = or i1 %t9964, %t9965
%t9967 = zext i1 %t9966 to i8
call void @resid_conv_check(i8 %t9967)
%t9968 = add i64 1135362057144423861, 0
%t9969 = add i64 %t9968, 0
%t9970 = add i64 %t9969, 0
%t9971 = icmp ne i64 %t9970, %t9968
%t9972 = icmp slt i64 1135362057144423861, 0
%t9973 = or i1 %t9971, %t9972
%t9974 = zext i1 %t9973 to i8
call void @resid_conv_check(i8 %t9974)
%t9975 = add i64 2597628984639134821, 0
%t9976 = add i64 %t9975, 0
%t9977 = add i64 %t9976, 0
%t9978 = icmp ne i64 %t9977, %t9975
%t9979 = icmp slt i64 2597628984639134821, 0
%t9980 = or i1 %t9978, %t9979
%t9981 = zext i1 %t9980 to i8
call void @resid_conv_check(i8 %t9981)
%t9982 = add i64 3308224258029322869, 0
%t9983 = add i64 %t9982, 0
%t9984 = add i64 %t9983, 0
%t9985 = icmp ne i64 %t9984, %t9982
%t9986 = icmp slt i64 3308224258029322869, 0
%t9987 = or i1 %t9985, %t9986
%t9988 = zext i1 %t9987 to i8
call void @resid_conv_check(i8 %t9988)
%t9989 = add i64 5365058923640841347, 0
%t9990 = add i64 %t9989, 0
%t9991 = add i64 %t9990, 0
%t9992 = icmp ne i64 %t9991, %t9989
%t9993 = icmp slt i64 5365058923640841347, 0
%t9994 = or i1 %t9992, %t9993
%t9995 = zext i1 %t9994 to i8
call void @resid_conv_check(i8 %t9995)
%t9996 = add i64 6679025012923562964, 0
%t9997 = add i64 %t9996, 0
%t9998 = add i64 %t9997, 0
%t9999 = icmp ne i64 %t9998, %t9996
%t10000 = icmp slt i64 6679025012923562964, 0
%t10001 = or i1 %t9999, %t10000
%t10002 = zext i1 %t10001 to i8
call void @resid_conv_check(i8 %t10002)
%t10003 = add i64 8573033837759648693, 0
%t10004 = add i64 %t10003, 0
%t10005 = add i64 %t10004, 0
%t10006 = icmp ne i64 %t10005, %t10003
%t10007 = icmp slt i64 8573033837759648693, 0
%t10008 = or i1 %t10006, %t10007
%t10009 = zext i1 %t10008 to i8
call void @resid_conv_check(i8 %t10009)
%t10010 = add i128 10970295158949994411, 0
%t10011 = trunc i128 %t10010 to i64
%t10012 = zext i64 %t10011 to i128
%t10013 = icmp ne i128 %t10012, %t10010
%t10014 = icmp slt i128 10970295158949994411, 0
%t10015 = or i1 %t10013, %t10014
%t10016 = zext i1 %t10015 to i8
call void @resid_conv_check(i8 %t10016)
%t10017 = add i128 12119686244451234320, 0
%t10018 = trunc i128 %t10017 to i64
%t10019 = zext i64 %t10018 to i128
%t10020 = icmp ne i128 %t10019, %t10017
%t10021 = icmp slt i128 12119686244451234320, 0
%t10022 = or i1 %t10020, %t10021
%t10023 = zext i1 %t10022 to i8
call void @resid_conv_check(i8 %t10023)
%t10024 = add i128 12683024718118986047, 0
%t10025 = trunc i128 %t10024 to i64
%t10026 = zext i64 %t10025 to i128
%t10027 = icmp ne i128 %t10026, %t10024
%t10028 = icmp slt i128 12683024718118986047, 0
%t10029 = or i1 %t10027, %t10028
%t10030 = zext i1 %t10029 to i8
call void @resid_conv_check(i8 %t10030)
%t10031 = add i128 13788192230050041572, 0
%t10032 = trunc i128 %t10031 to i64
%t10033 = zext i64 %t10032 to i128
%t10034 = icmp ne i128 %t10033, %t10031
%t10035 = icmp slt i128 13788192230050041572, 0
%t10036 = or i1 %t10034, %t10035
%t10037 = zext i1 %t10036 to i8
call void @resid_conv_check(i8 %t10037)
%t10038 = add i128 14330467153632333762, 0
%t10039 = trunc i128 %t10038 to i64
%t10040 = zext i64 %t10039 to i128
%t10041 = icmp ne i128 %t10040, %t10038
%t10042 = icmp slt i128 14330467153632333762, 0
%t10043 = or i1 %t10041, %t10042
%t10044 = zext i1 %t10043 to i8
call void @resid_conv_check(i8 %t10044)
%t10045 = add i128 15395433587784984357, 0
%t10046 = trunc i128 %t10045 to i64
%t10047 = zext i64 %t10046 to i128
%t10048 = icmp ne i128 %t10047, %t10045
%t10049 = icmp slt i128 15395433587784984357, 0
%t10050 = or i1 %t10048, %t10049
%t10051 = zext i1 %t10050 to i8
call void @resid_conv_check(i8 %t10051)
%t10052 = add i64 1452737877330783856, 0
%t10053 = add i64 %t10052, 0
%t10054 = add i64 %t10053, 0
%t10055 = icmp ne i64 %t10054, %t10052
%t10056 = icmp slt i64 1452737877330783856, 0
%t10057 = or i1 %t10055, %t10056
%t10058 = zext i1 %t10057 to i8
call void @resid_conv_check(i8 %t10058)
%t10059 = add i64 2861767655752347644, 0
%t10060 = add i64 %t10059, 0
%t10061 = add i64 %t10060, 0
%t10062 = icmp ne i64 %t10061, %t10059
%t10063 = icmp slt i64 2861767655752347644, 0
%t10064 = or i1 %t10062, %t10063
%t10065 = zext i1 %t10064 to i8
call void @resid_conv_check(i8 %t10065)
%t10066 = add i64 3322285676063803686, 0
%t10067 = add i64 %t10066, 0
%t10068 = add i64 %t10067, 0
%t10069 = icmp ne i64 %t10068, %t10066
%t10070 = icmp slt i64 3322285676063803686, 0
%t10071 = or i1 %t10069, %t10070
%t10072 = zext i1 %t10071 to i8
call void @resid_conv_check(i8 %t10072)
%t10073 = add i64 5560940570517711597, 0
%t10074 = add i64 %t10073, 0
%t10075 = add i64 %t10074, 0
%t10076 = icmp ne i64 %t10075, %t10073
%t10077 = icmp slt i64 5560940570517711597, 0
%t10078 = or i1 %t10076, %t10077
%t10079 = zext i1 %t10078 to i8
call void @resid_conv_check(i8 %t10079)
%t10080 = add i64 5996557281743188959, 0
%t10081 = add i64 %t10080, 0
%t10082 = add i64 %t10081, 0
%t10083 = icmp ne i64 %t10082, %t10080
%t10084 = icmp slt i64 5996557281743188959, 0
%t10085 = or i1 %t10083, %t10084
%t10086 = zext i1 %t10085 to i8
call void @resid_conv_check(i8 %t10086)
%t10087 = add i64 7280758554555802590, 0
%t10088 = add i64 %t10087, 0
%t10089 = add i64 %t10088, 0
%t10090 = icmp ne i64 %t10089, %t10087
%t10091 = icmp slt i64 7280758554555802590, 0
%t10092 = or i1 %t10090, %t10091
%t10093 = zext i1 %t10092 to i8
call void @resid_conv_check(i8 %t10093)
%t10094 = add i64 8532644243296465576, 0
%t10095 = add i64 %t10094, 0
%t10096 = add i64 %t10095, 0
%t10097 = icmp ne i64 %t10096, %t10094
%t10098 = icmp slt i64 8532644243296465576, 0
%t10099 = or i1 %t10097, %t10098
%t10100 = zext i1 %t10099 to i8
call void @resid_conv_check(i8 %t10100)
%t10101 = add i128 9350256976987008742, 0
%t10102 = trunc i128 %t10101 to i64
%t10103 = zext i64 %t10102 to i128
%t10104 = icmp ne i128 %t10103, %t10101
%t10105 = icmp slt i128 9350256976987008742, 0
%t10106 = or i1 %t10104, %t10105
%t10107 = zext i1 %t10106 to i8
call void @resid_conv_check(i8 %t10107)
%t10108 = add i128 10552545826968843579, 0
%t10109 = trunc i128 %t10108 to i64
%t10110 = zext i64 %t10109 to i128
%t10111 = icmp ne i128 %t10110, %t10108
%t10112 = icmp slt i128 10552545826968843579, 0
%t10113 = or i1 %t10111, %t10112
%t10114 = zext i1 %t10113 to i8
call void @resid_conv_check(i8 %t10114)
%t10115 = add i128 11727347734174303076, 0
%t10116 = trunc i128 %t10115 to i64
%t10117 = zext i64 %t10116 to i128
%t10118 = icmp ne i128 %t10117, %t10115
%t10119 = icmp slt i128 11727347734174303076, 0
%t10120 = or i1 %t10118, %t10119
%t10121 = zext i1 %t10120 to i8
call void @resid_conv_check(i8 %t10121)
%t10122 = add i128 12113106623233404929, 0
%t10123 = trunc i128 %t10122 to i64
%t10124 = zext i64 %t10123 to i128
%t10125 = icmp ne i128 %t10124, %t10122
%t10126 = icmp slt i128 12113106623233404929, 0
%t10127 = or i1 %t10125, %t10126
%t10128 = zext i1 %t10127 to i8
call void @resid_conv_check(i8 %t10128)
%t10129 = add i128 14000437183269869457, 0
%t10130 = trunc i128 %t10129 to i64
%t10131 = zext i64 %t10130 to i128
%t10132 = icmp ne i128 %t10131, %t10129
%t10133 = icmp slt i128 14000437183269869457, 0
%t10134 = or i1 %t10132, %t10133
%t10135 = zext i1 %t10134 to i8
call void @resid_conv_check(i8 %t10135)
%t10136 = add i128 14369950271660146224, 0
%t10137 = trunc i128 %t10136 to i64
%t10138 = zext i64 %t10137 to i128
%t10139 = icmp ne i128 %t10138, %t10136
%t10140 = icmp slt i128 14369950271660146224, 0
%t10141 = or i1 %t10139, %t10140
%t10142 = zext i1 %t10141 to i8
call void @resid_conv_check(i8 %t10142)
%t10143 = add i128 15101387698204529176, 0
%t10144 = trunc i128 %t10143 to i64
%t10145 = zext i64 %t10144 to i128
%t10146 = icmp ne i128 %t10145, %t10143
%t10147 = icmp slt i128 15101387698204529176, 0
%t10148 = or i1 %t10146, %t10147
%t10149 = zext i1 %t10148 to i8
call void @resid_conv_check(i8 %t10149)
%t10150 = add i128 15463397548674623760, 0
%t10151 = trunc i128 %t10150 to i64
%t10152 = zext i64 %t10151 to i128
%t10153 = icmp ne i128 %t10152, %t10150
%t10154 = icmp slt i128 15463397548674623760, 0
%t10155 = or i1 %t10153, %t10154
%t10156 = zext i1 %t10155 to i8
call void @resid_conv_check(i8 %t10156)
%t10157 = add i128 17586052441742319658, 0
%t10158 = trunc i128 %t10157 to i64
%t10159 = zext i64 %t10158 to i128
%t10160 = icmp ne i128 %t10159, %t10157
%t10161 = icmp slt i128 17586052441742319658, 0
%t10162 = or i1 %t10160, %t10161
%t10163 = zext i1 %t10162 to i8
call void @resid_conv_check(i8 %t10163)
%t10164 = add i64 1182934255886127544, 0
%t10165 = add i64 %t10164, 0
%t10166 = add i64 %t10165, 0
%t10167 = icmp ne i64 %t10166, %t10164
%t10168 = icmp slt i64 1182934255886127544, 0
%t10169 = or i1 %t10167, %t10168
%t10170 = zext i1 %t10169 to i8
call void @resid_conv_check(i8 %t10170)
%t10171 = add i64 1847814050463011016, 0
%t10172 = add i64 %t10171, 0
%t10173 = add i64 %t10172, 0
%t10174 = icmp ne i64 %t10173, %t10171
%t10175 = icmp slt i64 1847814050463011016, 0
%t10176 = or i1 %t10174, %t10175
%t10177 = zext i1 %t10176 to i8
call void @resid_conv_check(i8 %t10177)
%t10178 = add i64 2177327727835720531, 0
%t10179 = add i64 %t10178, 0
%t10180 = add i64 %t10179, 0
%t10181 = icmp ne i64 %t10180, %t10178
%t10182 = icmp slt i64 2177327727835720531, 0
%t10183 = or i1 %t10181, %t10182
%t10184 = zext i1 %t10183 to i8
call void @resid_conv_check(i8 %t10184)
%t10185 = add i64 2830643537854262169, 0
%t10186 = add i64 %t10185, 0
%t10187 = add i64 %t10186, 0
%t10188 = icmp ne i64 %t10187, %t10185
%t10189 = icmp slt i64 2830643537854262169, 0
%t10190 = or i1 %t10188, %t10189
%t10191 = zext i1 %t10190 to i8
call void @resid_conv_check(i8 %t10191)
%t10192 = add i64 3796741975233480872, 0
%t10193 = add i64 %t10192, 0
%t10194 = add i64 %t10193, 0
%t10195 = icmp ne i64 %t10194, %t10192
%t10196 = icmp slt i64 3796741975233480872, 0
%t10197 = or i1 %t10195, %t10196
%t10198 = zext i1 %t10197 to i8
call void @resid_conv_check(i8 %t10198)
%t10199 = add i64 4115178125766777443, 0
%t10200 = add i64 %t10199, 0
%t10201 = add i64 %t10200, 0
%t10202 = icmp ne i64 %t10201, %t10199
%t10203 = icmp slt i64 4115178125766777443, 0
%t10204 = or i1 %t10202, %t10203
%t10205 = zext i1 %t10204 to i8
call void @resid_conv_check(i8 %t10205)
%t10206 = add i64 5681478168544905931, 0
%t10207 = add i64 %t10206, 0
%t10208 = add i64 %t10207, 0
%t10209 = icmp ne i64 %t10208, %t10206
%t10210 = icmp slt i64 5681478168544905931, 0
%t10211 = or i1 %t10209, %t10210
%t10212 = zext i1 %t10211 to i8
call void @resid_conv_check(i8 %t10212)
%t10213 = add i64 6601373596472566643, 0
%t10214 = add i64 %t10213, 0
%t10215 = add i64 %t10214, 0
%t10216 = icmp ne i64 %t10215, %t10213
%t10217 = icmp slt i64 6601373596472566643, 0
%t10218 = or i1 %t10216, %t10217
%t10219 = zext i1 %t10218 to i8
call void @resid_conv_check(i8 %t10219)
%t10220 = add i64 7507060721942968483, 0
%t10221 = add i64 %t10220, 0
%t10222 = add i64 %t10221, 0
%t10223 = icmp ne i64 %t10222, %t10220
%t10224 = icmp slt i64 7507060721942968483, 0
%t10225 = or i1 %t10223, %t10224
%t10226 = zext i1 %t10225 to i8
call void @resid_conv_check(i8 %t10226)
%t10227 = add i64 8399075790359081724, 0
%t10228 = add i64 %t10227, 0
%t10229 = add i64 %t10228, 0
%t10230 = icmp ne i64 %t10229, %t10227
%t10231 = icmp slt i64 8399075790359081724, 0
%t10232 = or i1 %t10230, %t10231
%t10233 = zext i1 %t10232 to i8
call void @resid_conv_check(i8 %t10233)
%t10234 = add i64 8693463985226723168, 0
%t10235 = add i64 %t10234, 0
%t10236 = add i64 %t10235, 0
%t10237 = icmp ne i64 %t10236, %t10234
%t10238 = icmp slt i64 8693463985226723168, 0
%t10239 = or i1 %t10237, %t10238
%t10240 = zext i1 %t10239 to i8
call void @resid_conv_check(i8 %t10240)
%t10241 = add i128 9568029438360202098, 0
%t10242 = trunc i128 %t10241 to i64
%t10243 = zext i64 %t10242 to i128
%t10244 = icmp ne i128 %t10243, %t10241
%t10245 = icmp slt i128 9568029438360202098, 0
%t10246 = or i1 %t10244, %t10245
%t10247 = zext i1 %t10246 to i8
call void @resid_conv_check(i8 %t10247)
%t10248 = add i128 10144078919501101548, 0
%t10249 = trunc i128 %t10248 to i64
%t10250 = zext i64 %t10249 to i128
%t10251 = icmp ne i128 %t10250, %t10248
%t10252 = icmp slt i128 10144078919501101548, 0
%t10253 = or i1 %t10251, %t10252
%t10254 = zext i1 %t10253 to i8
call void @resid_conv_check(i8 %t10254)
%t10255 = add i128 10430055236837252648, 0
%t10256 = trunc i128 %t10255 to i64
%t10257 = zext i64 %t10256 to i128
%t10258 = icmp ne i128 %t10257, %t10255
%t10259 = icmp slt i128 10430055236837252648, 0
%t10260 = or i1 %t10258, %t10259
%t10261 = zext i1 %t10260 to i8
call void @resid_conv_check(i8 %t10261)
%t10262 = add i128 11840083180663258601, 0
%t10263 = trunc i128 %t10262 to i64
%t10264 = zext i64 %t10263 to i128
%t10265 = icmp ne i128 %t10264, %t10262
%t10266 = icmp slt i128 11840083180663258601, 0
%t10267 = or i1 %t10265, %t10266
%t10268 = zext i1 %t10267 to i8
call void @resid_conv_check(i8 %t10268)
%t10269 = add i128 13761210420658862357, 0
%t10270 = trunc i128 %t10269 to i64
%t10271 = zext i64 %t10270 to i128
%t10272 = icmp ne i128 %t10271, %t10269
%t10273 = icmp slt i128 13761210420658862357, 0
%t10274 = or i1 %t10272, %t10273
%t10275 = zext i1 %t10274 to i8
call void @resid_conv_check(i8 %t10275)
%t10276 = add i128 14299343276471374635, 0
%t10277 = trunc i128 %t10276 to i64
%t10278 = zext i64 %t10277 to i128
%t10279 = icmp ne i128 %t10278, %t10276
%t10280 = icmp slt i128 14299343276471374635, 0
%t10281 = or i1 %t10279, %t10280
%t10282 = zext i1 %t10281 to i8
call void @resid_conv_check(i8 %t10282)
%t10283 = add i128 14566680578165727644, 0
%t10284 = trunc i128 %t10283 to i64
%t10285 = zext i64 %t10284 to i128
%t10286 = icmp ne i128 %t10285, %t10283
%t10287 = icmp slt i128 14566680578165727644, 0
%t10288 = or i1 %t10286, %t10287
%t10289 = zext i1 %t10288 to i8
call void @resid_conv_check(i8 %t10289)
%t10290 = add i128 15097957966210449927, 0
%t10291 = trunc i128 %t10290 to i64
%t10292 = zext i64 %t10291 to i128
%t10293 = icmp ne i128 %t10292, %t10290
%t10294 = icmp slt i128 15097957966210449927, 0
%t10295 = or i1 %t10293, %t10294
%t10296 = zext i1 %t10295 to i8
call void @resid_conv_check(i8 %t10296)
%t10297 = add i128 16922976911328602910, 0
%t10298 = trunc i128 %t10297 to i64
%t10299 = zext i64 %t10298 to i128
%t10300 = icmp ne i128 %t10299, %t10297
%t10301 = icmp slt i128 16922976911328602910, 0
%t10302 = or i1 %t10300, %t10301
%t10303 = zext i1 %t10302 to i8
call void @resid_conv_check(i8 %t10303)
%t10304 = add i128 17689382322260857208, 0
%t10305 = trunc i128 %t10304 to i64
%t10306 = zext i64 %t10305 to i128
%t10307 = icmp ne i128 %t10306, %t10304
%t10308 = icmp slt i128 17689382322260857208, 0
%t10309 = or i1 %t10307, %t10308
%t10310 = zext i1 %t10309 to i8
call void @resid_conv_check(i8 %t10310)
%t10311 = add i64 1242879168328830382, 0
%t10312 = add i64 %t10311, 0
%t10313 = add i64 %t10312, 0
%t10314 = icmp ne i64 %t10313, %t10311
%t10315 = icmp slt i64 1242879168328830382, 0
%t10316 = or i1 %t10314, %t10315
%t10317 = zext i1 %t10316 to i8
call void @resid_conv_check(i8 %t10317)
%t10318 = add i64 1977374033974150939, 0
%t10319 = add i64 %t10318, 0
%t10320 = add i64 %t10319, 0
%t10321 = icmp ne i64 %t10320, %t10318
%t10322 = icmp slt i64 1977374033974150939, 0
%t10323 = or i1 %t10321, %t10322
%t10324 = zext i1 %t10323 to i8
call void @resid_conv_check(i8 %t10324)
%t10325 = add i64 2944078676154940804, 0
%t10326 = add i64 %t10325, 0
%t10327 = add i64 %t10326, 0
%t10328 = icmp ne i64 %t10327, %t10325
%t10329 = icmp slt i64 2944078676154940804, 0
%t10330 = or i1 %t10328, %t10329
%t10331 = zext i1 %t10330 to i8
call void @resid_conv_check(i8 %t10331)
%t10332 = add i64 3659926193048069267, 0
%t10333 = add i64 %t10332, 0
%t10334 = add i64 %t10333, 0
%t10335 = icmp ne i64 %t10334, %t10332
%t10336 = icmp slt i64 3659926193048069267, 0
%t10337 = or i1 %t10335, %t10336
%t10338 = zext i1 %t10337 to i8
call void @resid_conv_check(i8 %t10338)
%t10339 = add i64 4368137639120453308, 0
%t10340 = add i64 %t10339, 0
%t10341 = add i64 %t10340, 0
%t10342 = icmp ne i64 %t10341, %t10339
%t10343 = icmp slt i64 4368137639120453308, 0
%t10344 = or i1 %t10342, %t10343
%t10345 = zext i1 %t10344 to i8
call void @resid_conv_check(i8 %t10345)
%t10346 = add i64 4836135668995329356, 0
%t10347 = add i64 %t10346, 0
%t10348 = add i64 %t10347, 0
%t10349 = icmp ne i64 %t10348, %t10346
%t10350 = icmp slt i64 4836135668995329356, 0
%t10351 = or i1 %t10349, %t10350
%t10352 = zext i1 %t10351 to i8
call void @resid_conv_check(i8 %t10352)
%t10353 = add i64 5532061633213252278, 0
%t10354 = add i64 %t10353, 0
%t10355 = add i64 %t10354, 0
%t10356 = icmp ne i64 %t10355, %t10353
%t10357 = icmp slt i64 5532061633213252278, 0
%t10358 = or i1 %t10356, %t10357
%t10359 = zext i1 %t10358 to i8
call void @resid_conv_check(i8 %t10359)
%t10360 = add i64 6448918945643986474, 0
%t10361 = add i64 %t10360, 0
%t10362 = add i64 %t10361, 0
%t10363 = icmp ne i64 %t10362, %t10360
%t10364 = icmp slt i64 6448918945643986474, 0
%t10365 = or i1 %t10363, %t10364
%t10366 = zext i1 %t10365 to i8
call void @resid_conv_check(i8 %t10366)
%t10367 = add i64 6902733635092675308, 0
%t10368 = add i64 %t10367, 0
%t10369 = add i64 %t10368, 0
%t10370 = icmp ne i64 %t10369, %t10367
%t10371 = icmp slt i64 6902733635092675308, 0
%t10372 = or i1 %t10370, %t10371
%t10373 = zext i1 %t10372 to i8
call void @resid_conv_check(i8 %t10373)
%t10374 = add i64 7801388544844847127, 0
%t10375 = add i64 %t10374, 0
%t10376 = add i64 %t10375, 0
%t10377 = icmp ne i64 %t10376, %t10374
%t10378 = icmp slt i64 7801388544844847127, 0
%t10379 = or i1 %t10377, %t10378
%t10380 = zext i1 %t10379 to i8
call void @resid_conv_check(i8 %t10380)
%t10381 = alloca [80 x ptr]
%t10383 = call ptr @resid_box_i64(i64 %t9843)
%t10385 = getelementptr i8, ptr %t10381, i64 0
store ptr %t10383, ptr %t10385
%t10386 = call ptr @resid_box_i64(i64 %t9850)
%t10388 = getelementptr i8, ptr %t10381, i64 8
store ptr %t10386, ptr %t10388
%t10389 = call ptr @resid_box_i64(i64 %t9857)
%t10391 = getelementptr i8, ptr %t10381, i64 16
store ptr %t10389, ptr %t10391
%t10392 = call ptr @resid_box_i64(i64 %t9864)
%t10394 = getelementptr i8, ptr %t10381, i64 24
store ptr %t10392, ptr %t10394
%t10395 = call ptr @resid_box_i64(i64 %t9871)
%t10397 = getelementptr i8, ptr %t10381, i64 32
store ptr %t10395, ptr %t10397
%t10398 = call ptr @resid_box_i64(i64 %t9878)
%t10400 = getelementptr i8, ptr %t10381, i64 40
store ptr %t10398, ptr %t10400
%t10401 = call ptr @resid_box_i64(i64 %t9885)
%t10403 = getelementptr i8, ptr %t10381, i64 48
store ptr %t10401, ptr %t10403
%t10404 = call ptr @resid_box_i64(i64 %t9892)
%t10406 = getelementptr i8, ptr %t10381, i64 56
store ptr %t10404, ptr %t10406
%t10407 = call ptr @resid_box_i64(i64 %t9899)
%t10409 = getelementptr i8, ptr %t10381, i64 64
store ptr %t10407, ptr %t10409
%t10410 = call ptr @resid_box_i64(i64 %t9906)
%t10412 = getelementptr i8, ptr %t10381, i64 72
store ptr %t10410, ptr %t10412
%t10413 = call ptr @resid_box_i64(i64 %t9913)
%t10415 = getelementptr i8, ptr %t10381, i64 80
store ptr %t10413, ptr %t10415
%t10416 = call ptr @resid_box_i64(i64 %t9920)
%t10418 = getelementptr i8, ptr %t10381, i64 88
store ptr %t10416, ptr %t10418
%t10419 = call ptr @resid_box_i64(i64 %t9927)
%t10421 = getelementptr i8, ptr %t10381, i64 96
store ptr %t10419, ptr %t10421
%t10422 = call ptr @resid_box_i64(i64 %t9934)
%t10424 = getelementptr i8, ptr %t10381, i64 104
store ptr %t10422, ptr %t10424
%t10425 = call ptr @resid_box_i64(i64 %t9941)
%t10427 = getelementptr i8, ptr %t10381, i64 112
store ptr %t10425, ptr %t10427
%t10428 = call ptr @resid_box_i64(i64 %t9948)
%t10430 = getelementptr i8, ptr %t10381, i64 120
store ptr %t10428, ptr %t10430
%t10431 = call ptr @resid_box_i64(i64 %t9955)
%t10433 = getelementptr i8, ptr %t10381, i64 128
store ptr %t10431, ptr %t10433
%t10434 = call ptr @resid_box_i64(i64 %t9962)
%t10436 = getelementptr i8, ptr %t10381, i64 136
store ptr %t10434, ptr %t10436
%t10437 = call ptr @resid_box_i64(i64 %t9969)
%t10439 = getelementptr i8, ptr %t10381, i64 144
store ptr %t10437, ptr %t10439
%t10440 = call ptr @resid_box_i64(i64 %t9976)
%t10442 = getelementptr i8, ptr %t10381, i64 152
store ptr %t10440, ptr %t10442
%t10443 = call ptr @resid_box_i64(i64 %t9983)
%t10445 = getelementptr i8, ptr %t10381, i64 160
store ptr %t10443, ptr %t10445
%t10446 = call ptr @resid_box_i64(i64 %t9990)
%t10448 = getelementptr i8, ptr %t10381, i64 168
store ptr %t10446, ptr %t10448
%t10449 = call ptr @resid_box_i64(i64 %t9997)
%t10451 = getelementptr i8, ptr %t10381, i64 176
store ptr %t10449, ptr %t10451
%t10452 = call ptr @resid_box_i64(i64 %t10004)
%t10454 = getelementptr i8, ptr %t10381, i64 184
store ptr %t10452, ptr %t10454
%t10455 = call ptr @resid_box_i64(i64 %t10011)
%t10457 = getelementptr i8, ptr %t10381, i64 192
store ptr %t10455, ptr %t10457
%t10458 = call ptr @resid_box_i64(i64 %t10018)
%t10460 = getelementptr i8, ptr %t10381, i64 200
store ptr %t10458, ptr %t10460
%t10461 = call ptr @resid_box_i64(i64 %t10025)
%t10463 = getelementptr i8, ptr %t10381, i64 208
store ptr %t10461, ptr %t10463
%t10464 = call ptr @resid_box_i64(i64 %t10032)
%t10466 = getelementptr i8, ptr %t10381, i64 216
store ptr %t10464, ptr %t10466
%t10467 = call ptr @resid_box_i64(i64 %t10039)
%t10469 = getelementptr i8, ptr %t10381, i64 224
store ptr %t10467, ptr %t10469
%t10470 = call ptr @resid_box_i64(i64 %t10046)
%t10472 = getelementptr i8, ptr %t10381, i64 232
store ptr %t10470, ptr %t10472
%t10473 = call ptr @resid_box_i64(i64 489312712824947311)
%t10475 = getelementptr i8, ptr %t10381, i64 240
store ptr %t10473, ptr %t10475
%t10476 = call ptr @resid_box_i64(i64 %t10053)
%t10478 = getelementptr i8, ptr %t10381, i64 248
store ptr %t10476, ptr %t10478
%t10479 = call ptr @resid_box_i64(i64 %t10060)
%t10481 = getelementptr i8, ptr %t10381, i64 256
store ptr %t10479, ptr %t10481
%t10482 = call ptr @resid_box_i64(i64 %t10067)
%t10484 = getelementptr i8, ptr %t10381, i64 264
store ptr %t10482, ptr %t10484
%t10485 = call ptr @resid_box_i64(i64 %t10074)
%t10487 = getelementptr i8, ptr %t10381, i64 272
store ptr %t10485, ptr %t10487
%t10488 = call ptr @resid_box_i64(i64 %t10081)
%t10490 = getelementptr i8, ptr %t10381, i64 280
store ptr %t10488, ptr %t10490
%t10491 = call ptr @resid_box_i64(i64 %t10088)
%t10493 = getelementptr i8, ptr %t10381, i64 288
store ptr %t10491, ptr %t10493
%t10494 = call ptr @resid_box_i64(i64 %t10095)
%t10496 = getelementptr i8, ptr %t10381, i64 296
store ptr %t10494, ptr %t10496
%t10497 = call ptr @resid_box_i64(i64 %t10102)
%t10499 = getelementptr i8, ptr %t10381, i64 304
store ptr %t10497, ptr %t10499
%t10500 = call ptr @resid_box_i64(i64 %t10109)
%t10502 = getelementptr i8, ptr %t10381, i64 312
store ptr %t10500, ptr %t10502
%t10503 = call ptr @resid_box_i64(i64 %t10116)
%t10505 = getelementptr i8, ptr %t10381, i64 320
store ptr %t10503, ptr %t10505
%t10506 = call ptr @resid_box_i64(i64 %t10123)
%t10508 = getelementptr i8, ptr %t10381, i64 328
store ptr %t10506, ptr %t10508
%t10509 = call ptr @resid_box_i64(i64 %t10130)
%t10511 = getelementptr i8, ptr %t10381, i64 336
store ptr %t10509, ptr %t10511
%t10512 = call ptr @resid_box_i64(i64 %t10137)
%t10514 = getelementptr i8, ptr %t10381, i64 344
store ptr %t10512, ptr %t10514
%t10515 = call ptr @resid_box_i64(i64 %t10144)
%t10517 = getelementptr i8, ptr %t10381, i64 352
store ptr %t10515, ptr %t10517
%t10518 = call ptr @resid_box_i64(i64 %t10151)
%t10520 = getelementptr i8, ptr %t10381, i64 360
store ptr %t10518, ptr %t10520
%t10521 = call ptr @resid_box_i64(i64 %t10158)
%t10523 = getelementptr i8, ptr %t10381, i64 368
store ptr %t10521, ptr %t10523
%t10524 = call ptr @resid_box_i64(i64 %t10165)
%t10526 = getelementptr i8, ptr %t10381, i64 376
store ptr %t10524, ptr %t10526
%t10527 = call ptr @resid_box_i64(i64 %t10172)
%t10529 = getelementptr i8, ptr %t10381, i64 384
store ptr %t10527, ptr %t10529
%t10530 = call ptr @resid_box_i64(i64 %t10179)
%t10532 = getelementptr i8, ptr %t10381, i64 392
store ptr %t10530, ptr %t10532
%t10533 = call ptr @resid_box_i64(i64 %t10186)
%t10535 = getelementptr i8, ptr %t10381, i64 400
store ptr %t10533, ptr %t10535
%t10536 = call ptr @resid_box_i64(i64 %t10193)
%t10538 = getelementptr i8, ptr %t10381, i64 408
store ptr %t10536, ptr %t10538
%t10539 = call ptr @resid_box_i64(i64 %t10200)
%t10541 = getelementptr i8, ptr %t10381, i64 416
store ptr %t10539, ptr %t10541
%t10542 = call ptr @resid_box_i64(i64 %t10207)
%t10544 = getelementptr i8, ptr %t10381, i64 424
store ptr %t10542, ptr %t10544
%t10545 = call ptr @resid_box_i64(i64 %t10214)
%t10547 = getelementptr i8, ptr %t10381, i64 432
store ptr %t10545, ptr %t10547
%t10548 = call ptr @resid_box_i64(i64 %t10221)
%t10550 = getelementptr i8, ptr %t10381, i64 440
store ptr %t10548, ptr %t10550
%t10551 = call ptr @resid_box_i64(i64 %t10228)
%t10553 = getelementptr i8, ptr %t10381, i64 448
store ptr %t10551, ptr %t10553
%t10554 = call ptr @resid_box_i64(i64 %t10235)
%t10556 = getelementptr i8, ptr %t10381, i64 456
store ptr %t10554, ptr %t10556
%t10557 = call ptr @resid_box_i64(i64 %t10242)
%t10559 = getelementptr i8, ptr %t10381, i64 464
store ptr %t10557, ptr %t10559
%t10560 = call ptr @resid_box_i64(i64 %t10249)
%t10562 = getelementptr i8, ptr %t10381, i64 472
store ptr %t10560, ptr %t10562
%t10563 = call ptr @resid_box_i64(i64 %t10256)
%t10565 = getelementptr i8, ptr %t10381, i64 480
store ptr %t10563, ptr %t10565
%t10566 = call ptr @resid_box_i64(i64 %t10263)
%t10568 = getelementptr i8, ptr %t10381, i64 488
store ptr %t10566, ptr %t10568
%t10569 = call ptr @resid_box_i64(i64 %t10270)
%t10571 = getelementptr i8, ptr %t10381, i64 496
store ptr %t10569, ptr %t10571
%t10572 = call ptr @resid_box_i64(i64 %t10277)
%t10574 = getelementptr i8, ptr %t10381, i64 504
store ptr %t10572, ptr %t10574
%t10575 = call ptr @resid_box_i64(i64 %t10284)
%t10577 = getelementptr i8, ptr %t10381, i64 512
store ptr %t10575, ptr %t10577
%t10578 = call ptr @resid_box_i64(i64 %t10291)
%t10580 = getelementptr i8, ptr %t10381, i64 520
store ptr %t10578, ptr %t10580
%t10581 = call ptr @resid_box_i64(i64 %t10298)
%t10583 = getelementptr i8, ptr %t10381, i64 528
store ptr %t10581, ptr %t10583
%t10584 = call ptr @resid_box_i64(i64 %t10305)
%t10586 = getelementptr i8, ptr %t10381, i64 536
store ptr %t10584, ptr %t10586
%t10587 = call ptr @resid_box_i64(i64 500013540394364858)
%t10589 = getelementptr i8, ptr %t10381, i64 544
store ptr %t10587, ptr %t10589
%t10590 = call ptr @resid_box_i64(i64 748580250866718886)
%t10592 = getelementptr i8, ptr %t10381, i64 552
store ptr %t10590, ptr %t10592
%t10593 = call ptr @resid_box_i64(i64 %t10312)
%t10595 = getelementptr i8, ptr %t10381, i64 560
store ptr %t10593, ptr %t10595
%t10596 = call ptr @resid_box_i64(i64 %t10319)
%t10598 = getelementptr i8, ptr %t10381, i64 568
store ptr %t10596, ptr %t10598
%t10599 = call ptr @resid_box_i64(i64 %t10326)
%t10601 = getelementptr i8, ptr %t10381, i64 576
store ptr %t10599, ptr %t10601
%t10602 = call ptr @resid_box_i64(i64 %t10333)
%t10604 = getelementptr i8, ptr %t10381, i64 584
store ptr %t10602, ptr %t10604
%t10605 = call ptr @resid_box_i64(i64 %t10340)
%t10607 = getelementptr i8, ptr %t10381, i64 592
store ptr %t10605, ptr %t10607
%t10608 = call ptr @resid_box_i64(i64 %t10347)
%t10610 = getelementptr i8, ptr %t10381, i64 600
store ptr %t10608, ptr %t10610
%t10611 = call ptr @resid_box_i64(i64 %t10354)
%t10613 = getelementptr i8, ptr %t10381, i64 608
store ptr %t10611, ptr %t10613
%t10614 = call ptr @resid_box_i64(i64 %t10361)
%t10616 = getelementptr i8, ptr %t10381, i64 616
store ptr %t10614, ptr %t10616
%t10617 = call ptr @resid_box_i64(i64 %t10368)
%t10619 = getelementptr i8, ptr %t10381, i64 624
store ptr %t10617, ptr %t10619
%t10620 = call ptr @resid_box_i64(i64 %t10375)
%t10622 = getelementptr i8, ptr %t10381, i64 632
store ptr %t10620, ptr %t10622
%t10623 = call ptr @resid_list_new(i64 80, ptr %t10381, ptr @.lty10381)
%t10624 = getelementptr i8, ptr %p2, i64 0
%t10625 = load i64, ptr %t10624, align 8
%t10626 = getelementptr i8, ptr %p2, i64 8
%t10627 = load i64, ptr %t10626, align 8
%t10628 = getelementptr i8, ptr %p2, i64 16
%t10629 = load i64, ptr %t10628, align 8
%t10630 = getelementptr i8, ptr %p2, i64 24
%t10631 = load i64, ptr %t10630, align 8
%t10632 = getelementptr i8, ptr %p2, i64 32
%t10633 = load i64, ptr %t10632, align 8
%t10634 = getelementptr i8, ptr %p2, i64 40
%t10635 = load i64, ptr %t10634, align 8
%t10636 = getelementptr i8, ptr %p2, i64 48
%t10637 = load i64, ptr %t10636, align 8
%t10638 = getelementptr i8, ptr %p2, i64 56
%t10639 = load i64, ptr %t10638, align 8
%t10640 = call ptr @__m____________lib_sha512g_resid__g5_blk__g_Int_64__UInt_64_(ptr %p0, i64 %p1, ptr %t10623, i64 0, ptr %p2, i64 %t10625, i64 %t10627, i64 %t10629, i64 %t10631, i64 %t10633, i64 %t10635, i64 %t10637, i64 %t10639, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
ret ptr %t10640
}
define i64 @__m____________lib_sha512g_resid__g5_state_word__g_UInt_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10641 = icmp eq i64 %p1, 0
br i1 %t10641, label %L1066, label %L1067
L1066:
%t10642 = getelementptr i8, ptr %p0, i64 0
%t10643 = load i64, ptr %t10642, align 8
br label %L1068
L1067:
%t10644 = icmp eq i64 %p1, 1
br i1 %t10644, label %L1069, label %L1070
L1069:
%t10645 = getelementptr i8, ptr %p0, i64 8
%t10646 = load i64, ptr %t10645, align 8
br label %L1071
L1070:
%t10647 = icmp eq i64 %p1, 2
br i1 %t10647, label %L1072, label %L1073
L1072:
%t10648 = getelementptr i8, ptr %p0, i64 16
%t10649 = load i64, ptr %t10648, align 8
br label %L1074
L1073:
%t10650 = icmp eq i64 %p1, 3
br i1 %t10650, label %L1075, label %L1076
L1075:
%t10651 = getelementptr i8, ptr %p0, i64 24
%t10652 = load i64, ptr %t10651, align 8
br label %L1077
L1076:
%t10653 = icmp eq i64 %p1, 4
br i1 %t10653, label %L1078, label %L1079
L1078:
%t10654 = getelementptr i8, ptr %p0, i64 32
%t10655 = load i64, ptr %t10654, align 8
br label %L1080
L1079:
%t10656 = icmp eq i64 %p1, 5
br i1 %t10656, label %L1081, label %L1082
L1081:
%t10657 = getelementptr i8, ptr %p0, i64 40
%t10658 = load i64, ptr %t10657, align 8
br label %L1083
L1082:
%t10659 = icmp eq i64 %p1, 6
br i1 %t10659, label %L1084, label %L1085
L1084:
%t10660 = getelementptr i8, ptr %p0, i64 48
%t10661 = load i64, ptr %t10660, align 8
br label %L1086
L1085:
%t10662 = getelementptr i8, ptr %p0, i64 56
%t10663 = load i64, ptr %t10662, align 8
br label %L1086
L1086:
%t10664 = phi i64 [ %t10661, %L1084 ], [ %t10663, %L1085 ]
br label %L1083
L1083:
%t10665 = phi i64 [ %t10658, %L1081 ], [ %t10664, %L1086 ]
br label %L1080
L1080:
%t10666 = phi i64 [ %t10655, %L1078 ], [ %t10665, %L1083 ]
br label %L1077
L1077:
%t10667 = phi i64 [ %t10652, %L1075 ], [ %t10666, %L1080 ]
br label %L1074
L1074:
%t10668 = phi i64 [ %t10649, %L1072 ], [ %t10667, %L1077 ]
br label %L1071
L1071:
%t10669 = phi i64 [ %t10646, %L1069 ], [ %t10668, %L1074 ]
br label %L1068
L1068:
%t10670 = phi i64 [ %t10643, %L1066 ], [ %t10669, %L1071 ]
ret i64 %t10670
}
define ptr @__m____________lib_sha512g_resid__g5_blk__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in, i64 %p19.in, i64 %p20.in, i64 %p21.in, i64 %p22.in, i64 %p23.in, i64 %p24.in, i64 %p25.in, i64 %p26.in, i64 %p27.in, i64 %p28.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p2.ld = call ptr @resid_list_vdata(ptr %p2.in)
%p2.ln = call i64 @resid_list_vlen(ptr %p2.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t10710, %tco.s0.k ]
%p4 = phi ptr [ %p4.in, %entry ], [ %p4.ev.tco.s0, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t10711, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %p7, %tco.s0.k ]
%p9 = phi i64 [ %p9.in, %entry ], [ %t10712, %tco.s0.k ]
%p10 = phi i64 [ %p10.in, %entry ], [ %p9, %tco.s0.k ]
%p11 = phi i64 [ %p11.in, %entry ], [ %p10, %tco.s0.k ]
%p12 = phi i64 [ %p12.in, %entry ], [ %p11, %tco.s0.k ]
%p13 = phi i64 [ %p13.in, %entry ], [ %p14, %tco.s0.k ]
%p14 = phi i64 [ %p14.in, %entry ], [ %p15, %tco.s0.k ]
%p15 = phi i64 [ %p15.in, %entry ], [ %p16, %tco.s0.k ]
%p16 = phi i64 [ %p16.in, %entry ], [ %p17, %tco.s0.k ]
%p17 = phi i64 [ %p17.in, %entry ], [ %p18, %tco.s0.k ]
%p18 = phi i64 [ %p18.in, %entry ], [ %p19, %tco.s0.k ]
%p19 = phi i64 [ %p19.in, %entry ], [ %p20, %tco.s0.k ]
%p20 = phi i64 [ %p20.in, %entry ], [ %p21, %tco.s0.k ]
%p21 = phi i64 [ %p21.in, %entry ], [ %p22, %tco.s0.k ]
%p22 = phi i64 [ %p22.in, %entry ], [ %p23, %tco.s0.k ]
%p23 = phi i64 [ %p23.in, %entry ], [ %p24, %tco.s0.k ]
%p24 = phi i64 [ %p24.in, %entry ], [ %p25, %tco.s0.k ]
%p25 = phi i64 [ %p25.in, %entry ], [ %p26, %tco.s0.k ]
%p26 = phi i64 [ %p26.in, %entry ], [ %p27, %tco.s0.k ]
%p27 = phi i64 [ %p27.in, %entry ], [ %p28, %tco.s0.k ]
%p28 = phi i64 [ %p28.in, %entry ], [ %t10697, %tco.s0.k ]
%t10671 = icmp sge i64 %p3, 80
br i1 %t10671, label %L1087, label %L1089
L1087:
%t10672 = call ptr @resid_gmalloc(i64 64)
%t10673 = getelementptr i8, ptr %p4, i64 0
%t10674 = load i64, ptr %t10673, align 8
%t10675 = call i64 @__m____________lib_word_resid__di_add(i64 %t10674, i64 %p5)
%t10672.f0 = getelementptr i8, ptr %t10672, i64 0
store i64 %t10675, ptr %t10672.f0, align 8
%t10676 = getelementptr i8, ptr %p4, i64 8
%t10677 = load i64, ptr %t10676, align 8
%t10678 = call i64 @__m____________lib_word_resid__di_add(i64 %t10677, i64 %p6)
%t10672.f1 = getelementptr i8, ptr %t10672, i64 8
store i64 %t10678, ptr %t10672.f1, align 8
%t10679 = getelementptr i8, ptr %p4, i64 16
%t10680 = load i64, ptr %t10679, align 8
%t10681 = call i64 @__m____________lib_word_resid__di_add(i64 %t10680, i64 %p7)
%t10672.f2 = getelementptr i8, ptr %t10672, i64 16
store i64 %t10681, ptr %t10672.f2, align 8
%t10682 = getelementptr i8, ptr %p4, i64 24
%t10683 = load i64, ptr %t10682, align 8
%t10684 = call i64 @__m____________lib_word_resid__di_add(i64 %t10683, i64 %p8)
%t10672.f3 = getelementptr i8, ptr %t10672, i64 24
store i64 %t10684, ptr %t10672.f3, align 8
%t10685 = getelementptr i8, ptr %p4, i64 32
%t10686 = load i64, ptr %t10685, align 8
%t10687 = call i64 @__m____________lib_word_resid__di_add(i64 %t10686, i64 %p9)
%t10672.f4 = getelementptr i8, ptr %t10672, i64 32
store i64 %t10687, ptr %t10672.f4, align 8
%t10688 = getelementptr i8, ptr %p4, i64 40
%t10689 = load i64, ptr %t10688, align 8
%t10690 = call i64 @__m____________lib_word_resid__di_add(i64 %t10689, i64 %p10)
%t10672.f5 = getelementptr i8, ptr %t10672, i64 40
store i64 %t10690, ptr %t10672.f5, align 8
%t10691 = getelementptr i8, ptr %p4, i64 48
%t10692 = load i64, ptr %t10691, align 8
%t10693 = call i64 @__m____________lib_word_resid__di_add(i64 %t10692, i64 %p11)
%t10672.f6 = getelementptr i8, ptr %t10672, i64 48
store i64 %t10693, ptr %t10672.f6, align 8
%t10694 = getelementptr i8, ptr %p4, i64 56
%t10695 = load i64, ptr %t10694, align 8
%t10696 = call i64 @__m____________lib_word_resid__di_add(i64 %t10695, i64 %p12)
%t10672.f7 = getelementptr i8, ptr %t10672, i64 56
store i64 %t10696, ptr %t10672.f7, align 8
%lr.cx79 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz79 = icmp eq ptr %lr.cx79, null
br i1 %lr.lz79, label %lr.x79.k, label %lr.x79.m
lr.x79.k:
ret ptr %t10672
lr.x79.m:
%lr.ret79 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %t10672, ptr %lr.cx79)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret79
L1089:
%t10697 = call i64 @__m____________lib_sha512g_resid__g5_sched__g_Int_64__UInt_64_(ptr %p0, i64 %p1, i64 %p3, i64 %p13, i64 %p14, i64 %p22, i64 %p27)
%t10698 = call i64 @__m____________lib_sha512g_resid__g5_b1__g_UInt_64__Int_64_(i64 %p9)
%t10699 = call i64 @__m____________lib_word_resid__di_add(i64 %p12, i64 %t10698)
%t10700 = call i64 @__m____________lib_sha512g_resid__g5_ch__g_UInt_64__Int_64_(i64 %p9, i64 %p10, i64 %p11)
%t10701 = call i64 @__m____________lib_word_resid__di_add(i64 %t10699, i64 %t10700)
%t10702 = call ptr @resid_list_get_v(ptr %p2, i64 %p3, ptr %p2.ld, i64 %p2.ln)
%t10703 = call i64 @resid_unbox_i64(ptr %t10702)
%t10705 = call i64 @__m____________lib_word_resid__di_addk(i64 %t10701, i64 %t10703)
%t10706 = call i64 @__m____________lib_word_resid__di_add(i64 %t10705, i64 %t10697)
%t10707 = call i64 @__m____________lib_sha512g_resid__g5_b0__g_UInt_64__Int_64_(i64 %p5)
%t10708 = call i64 @__m____________lib_sha512g_resid__g5_maj__g_UInt_64__Int_64_(i64 %p5, i64 %p6, i64 %p7)
%t10709 = call i64 @__m____________lib_word_resid__di_add(i64 %t10707, i64 %t10708)
%t10710 = add nsw i64 %p3, 1
%t10711 = call i64 @__m____________lib_word_resid__di_add(i64 %t10706, i64 %t10709)
%t10712 = call i64 @__m____________lib_word_resid__di_add(i64 %p8, i64 %t10706)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p4.e.tco.s0 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %p4, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p4.ev.tco.s0 = phi ptr [ %p4.e.tco.s0, %tco.s0.c ], [ %p4, %tco.s0 ]
br label %tco.head
}
define i64 @__m____________lib_sha512g_resid__g5_sched__g_Int_64__UInt_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10714 = icmp slt i64 %p2, 16
br i1 %t10714, label %L1090, label %L1092
L1090:
%t10715 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 8)
%t10716 = extractvalue {i64, i1} %t10715, 0
%t10717 = extractvalue {i64, i1} %t10715, 1
%t10718 = zext i1 %t10717 to i8
call void @resid_overflow_check(i8 %t10718)
%t10719 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t10716)
%t10720 = extractvalue {i64, i1} %t10719, 0
%t10721 = extractvalue {i64, i1} %t10719, 1
%t10722 = zext i1 %t10721 to i8
call void @resid_overflow_check(i8 %t10722)
%t10723 = call i64 @__m____________lib_sha512g_resid__g5_word_at__g_Int_64__UInt_64_(ptr %p0, i64 %t10720)
ret i64 %t10723
L1092:
%t10724 = call i64 @__m____________lib_sha512g_resid__g5_s1__g_UInt_64__Int_64_(i64 %p6)
%t10725 = call i64 @__m____________lib_word_resid__di_add(i64 %t10724, i64 %p5)
%t10726 = call i64 @__m____________lib_sha512g_resid__g5_s0__g_UInt_64__Int_64_(i64 %p4)
%t10727 = call i64 @__m____________lib_word_resid__di_add(i64 %t10726, i64 %p3)
%t10728 = call i64 @__m____________lib_word_resid__di_add(i64 %t10725, i64 %t10727)
ret i64 %t10728
}
define i64 @__m____________lib_sha512g_resid__g5_b1__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10729 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 14)
%t10730 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 18)
%t10731 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10729, i64 %t10730)
%t10732 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 41)
%t10733 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10731, i64 %t10732)
ret i64 %t10733
}
define i64 @__m____________lib_sha512g_resid__g5_ch__g_UInt_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10734 = call i64 @__m____________lib_word_resid__di_and(i64 %p0, i64 %p1)
%t10735 = call i64 @__m____________lib_word_resid__di_not(i64 %p0)
%t10736 = call i64 @__m____________lib_word_resid__di_and(i64 %t10735, i64 %p2)
%t10737 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10734, i64 %t10736)
ret i64 %t10737
}
define i64 @__m____________lib_sha512g_resid__g5_b0__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10738 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 28)
%t10739 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 34)
%t10740 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10738, i64 %t10739)
%t10741 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 39)
%t10742 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10740, i64 %t10741)
ret i64 %t10742
}
define i64 @__m____________lib_sha512g_resid__g5_maj__g_UInt_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10743 = call i64 @__m____________lib_word_resid__di_and(i64 %p0, i64 %p1)
%t10744 = call i64 @__m____________lib_word_resid__di_and(i64 %p0, i64 %p2)
%t10745 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10743, i64 %t10744)
%t10746 = call i64 @__m____________lib_word_resid__di_and(i64 %p1, i64 %p2)
%t10747 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10745, i64 %t10746)
ret i64 %t10747
}
define i64 @__m____________lib_sha512g_resid__g5_word_at__g_Int_64__UInt_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10748 = call i64 @__m____________lib_sha512g_resid__g5_word_acc__g_Int_64__UInt_64_(ptr %p0, i64 %p1, i64 0, i64 0)
ret i64 %t10748
}
define i64 @__m____________lib_sha512g_resid__g5_s1__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10749 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 19)
%t10750 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 61)
%t10751 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10749, i64 %t10750)
%t10752 = call i64 @__m____________lib_word_resid__di_shr(i64 %p0, i64 6)
%t10753 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10751, i64 %t10752)
ret i64 %t10753
}
define i64 @__m____________lib_sha512g_resid__g5_s0__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10754 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 1)
%t10755 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 8)
%t10756 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10754, i64 %t10755)
%t10757 = call i64 @__m____________lib_word_resid__di_shr(i64 %p0, i64 7)
%t10758 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10756, i64 %t10757)
ret i64 %t10758
}
define i64 @__m____________lib_sha512g_resid__g5_word_acc__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t10769, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t10771, %tco.s0 ]
%t10759 = icmp sge i64 %p2, 8
br i1 %t10759, label %L1093, label %L1095
L1093:
ret i64 %p3
L1095:
%t10760 = call i64 @__m____________lib_word_resid__di_and(i64 %p3, i64 72057594037927935)
%t10761 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p2)
%t10762 = extractvalue {i64, i1} %t10761, 0
%t10763 = extractvalue {i64, i1} %t10761, 1
%t10764 = zext i1 %t10763 to i8
call void @resid_overflow_check(i8 %t10764)
%t10765 = call ptr @resid_list_get_v(ptr %p0, i64 %t10762, ptr %p0.ld, i64 %p0.ln)
%t10766 = call i64 @resid_unbox_i64(ptr %t10765)
%t10768 = call i64 @__m____________lib_word_resid__di_from_byte(i64 %t10766)
%t10769 = add nsw i64 %p2, 1
%t10770 = call i64 @__m____________lib_sha512g_resid__g5_shl8__g_UInt_64__Int_64_(i64 %t10760)
%t10771 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10770, i64 %t10768)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_sha512g_resid__g5_shl8__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10773 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 56)
%t10774 = add i128 18446744073709551360, 0
%t10775 = trunc i128 %t10774 to i64
%t10776 = zext i64 %t10775 to i128
%t10777 = icmp ne i128 %t10776, %t10774
%t10778 = icmp slt i128 18446744073709551360, 0
%t10779 = or i1 %t10777, %t10778
%t10780 = zext i1 %t10779 to i8
call void @resid_conv_check(i8 %t10780)
%t10781 = call i64 @__m____________lib_word_resid__di_and(i64 %t10773, i64 %t10775)
ret i64 %t10781
}
define i64 @__m____________lib_bignum_resid__bn_cmp_at__rs45(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 0
}
define ptr @__m____________lib_bignum_resid__bn_sub_at__rs48(ptr %p0, ptr %p1, i64 %p2, i64 %p3, i64 %p4, ptr %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10782 = call ptr @resid_listbuf_finish(ptr %p5, ptr @.lty10782)
ret ptr %t10782
}
define ptr @__m____________lib_bignum_resid__bn_short_at__rs72(ptr %p0, i64 %p1, i64 %p2, i128 %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10783 = call ptr @resid_gmalloc(i64 16)
%t10784 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty10784)
%t10785 = call ptr @__m____________lib_bignum_resid__bn_reverse(ptr %t10784)
%t10786 = call ptr @bn_trim(ptr %t10785)
%t10783.f0 = getelementptr i8, ptr %t10783, i64 0
store ptr %t10786, ptr %t10783.f0, align 8
%t10787 = add i128 %p3, 0
%t10788 = trunc i128 %t10787 to i64
%t10789 = zext i64 %t10788 to i128
%t10790 = icmp ne i128 %t10789, %t10787
%t10791 = icmp eq i8 0, 1
%t10792 = or i1 %t10790, %t10791
%t10793 = zext i1 %t10792 to i8
call void @resid_conv_check(i8 %t10793)
%t10794 = call ptr @bn_from_u64(i64 %t10788)
%t10783.f1 = getelementptr i8, ptr %t10783, i64 8
store ptr %t10794, ptr %t10783.f1, align 8
ret ptr %t10783
}
define ptr @bn_divmod__rs93(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10796 = zext i1 true to i8
call void @resid_assert(i8 %t10796, ptr @.s10795)
%t10797 = alloca [1 x ptr]
%t10799 = call ptr @resid_box_i64(i64 3)
%t10801 = getelementptr i8, ptr %t10797, i64 0
store ptr %t10799, ptr %t10801
%t10802 = call ptr @resid_list_new(i64 1, ptr %t10797, ptr @.lty10797)
%t10803 = call i64 @bn_cmp(ptr %p0, ptr %t10802)
%t10804 = icmp slt i64 %t10803, 0
br i1 %t10804, label %L1096, label %L1098
L1096:
%t10805 = call ptr @resid_gmalloc(i64 16)
%t10806 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyE10806)
%t10805.f0 = getelementptr i8, ptr %t10805, i64 0
store ptr %t10806, ptr %t10805.f0, align 8
%t10805.f1 = getelementptr i8, ptr %t10805, i64 8
store ptr %p0, ptr %t10805.f1, align 8
ret ptr %t10805
L1098:
%t10807 = call ptr @__m____________lib_bignum_resid__bn_divmod_short(ptr %p0, i64 3)
ret ptr %t10807
}
define i64 @__m____________lib_bignum_resid__bn_get__rs106(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 0
}
define i64 @__m____________lib_bignum_resid__bn_cmp_at__rs116(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 0
}
define ptr @__m____________lib_bignum_resid__bn_short_at__rs119(ptr %p0, i64 %p1, i64 %p2, i128 %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10808 = call ptr @resid_gmalloc(i64 16)
%t10809 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty10809)
%t10810 = call ptr @__m____________lib_bignum_resid__bn_reverse(ptr %t10809)
%t10811 = call ptr @bn_trim(ptr %t10810)
%t10808.f0 = getelementptr i8, ptr %t10808, i64 0
store ptr %t10811, ptr %t10808.f0, align 8
%t10812 = add i128 %p3, 0
%t10813 = trunc i128 %t10812 to i64
%t10814 = zext i64 %t10813 to i128
%t10815 = icmp ne i128 %t10814, %t10812
%t10816 = icmp eq i8 0, 1
%t10817 = or i1 %t10815, %t10816
%t10818 = zext i1 %t10817 to i8
call void @resid_conv_check(i8 %t10818)
%t10819 = call ptr @bn_from_u64(i64 %t10813)
%t10808.f1 = getelementptr i8, ptr %t10808, i64 8
store ptr %t10819, ptr %t10808.f1, align 8
ret ptr %t10808
}
define ptr @__m____________lib_sha256g_resid__sha256g_pad_at__rs143(i64 %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10820 = call ptr @resid_box_i64(i64 128)
%t10823 = call ptr @resid_listbuf_push(ptr %p3, ptr %t10820)
%t10824 = musttail call ptr @__m____________lib_sha256g_resid__sha256g_pad_at(i64 %p0, i64 %p1, i64 1, ptr %t10823)
ret ptr %t10824
}
define ptr @length_bytes__rs153(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10827 = alloca [1 x ptr]
%t10825 = ashr i64 %p0, 0
%t10826 = and i64 %t10825, 255
%t10829 = call ptr @resid_box_i64(i64 %t10826)
%t10831 = getelementptr i8, ptr %t10827, i64 0
store ptr %t10829, ptr %t10831
%t10832 = call ptr @resid_list_new(i64 1, ptr %t10827, ptr @.lty10827)
%t10833 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10832)
%t10834 = musttail call ptr @length_bytes(i64 %p0, i64 -1, ptr %t10833)
ret ptr %t10834
}
define ptr @length_bytes__rs152(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10837 = alloca [1 x ptr]
%t10835 = ashr i64 %p0, 8
%t10836 = and i64 %t10835, 255
%t10839 = call ptr @resid_box_i64(i64 %t10836)
%t10841 = getelementptr i8, ptr %t10837, i64 0
store ptr %t10839, ptr %t10841
%t10842 = call ptr @resid_list_new(i64 1, ptr %t10837, ptr @.lty10837)
%t10843 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10842)
%t10844 = musttail call ptr @length_bytes__rs153(i64 %p0, i64 0, ptr %t10843)
ret ptr %t10844
}
define ptr @length_bytes__rs151(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10847 = alloca [1 x ptr]
%t10845 = ashr i64 %p0, 16
%t10846 = and i64 %t10845, 255
%t10849 = call ptr @resid_box_i64(i64 %t10846)
%t10851 = getelementptr i8, ptr %t10847, i64 0
store ptr %t10849, ptr %t10851
%t10852 = call ptr @resid_list_new(i64 1, ptr %t10847, ptr @.lty10847)
%t10853 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10852)
%t10854 = musttail call ptr @length_bytes__rs152(i64 %p0, i64 1, ptr %t10853)
ret ptr %t10854
}
define ptr @length_bytes__rs150(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10857 = alloca [1 x ptr]
%t10855 = ashr i64 %p0, 24
%t10856 = and i64 %t10855, 255
%t10859 = call ptr @resid_box_i64(i64 %t10856)
%t10861 = getelementptr i8, ptr %t10857, i64 0
store ptr %t10859, ptr %t10861
%t10862 = call ptr @resid_list_new(i64 1, ptr %t10857, ptr @.lty10857)
%t10863 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10862)
%t10864 = musttail call ptr @length_bytes__rs151(i64 %p0, i64 2, ptr %t10863)
ret ptr %t10864
}
define ptr @length_bytes__rs149(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10867 = alloca [1 x ptr]
%t10865 = ashr i64 %p0, 32
%t10866 = and i64 %t10865, 255
%t10869 = call ptr @resid_box_i64(i64 %t10866)
%t10871 = getelementptr i8, ptr %t10867, i64 0
store ptr %t10869, ptr %t10871
%t10872 = call ptr @resid_list_new(i64 1, ptr %t10867, ptr @.lty10867)
%t10873 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10872)
%t10874 = musttail call ptr @length_bytes__rs150(i64 %p0, i64 3, ptr %t10873)
ret ptr %t10874
}
define ptr @length_bytes__rs148(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10877 = alloca [1 x ptr]
%t10875 = ashr i64 %p0, 40
%t10876 = and i64 %t10875, 255
%t10879 = call ptr @resid_box_i64(i64 %t10876)
%t10881 = getelementptr i8, ptr %t10877, i64 0
store ptr %t10879, ptr %t10881
%t10882 = call ptr @resid_list_new(i64 1, ptr %t10877, ptr @.lty10877)
%t10883 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10882)
%t10884 = musttail call ptr @length_bytes__rs149(i64 %p0, i64 4, ptr %t10883)
ret ptr %t10884
}
define ptr @length_bytes__rs147(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10887 = alloca [1 x ptr]
%t10885 = ashr i64 %p0, 48
%t10886 = and i64 %t10885, 255
%t10889 = call ptr @resid_box_i64(i64 %t10886)
%t10891 = getelementptr i8, ptr %t10887, i64 0
store ptr %t10889, ptr %t10891
%t10892 = call ptr @resid_list_new(i64 1, ptr %t10887, ptr @.lty10887)
%t10893 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10892)
%t10894 = musttail call ptr @length_bytes__rs148(i64 %p0, i64 5, ptr %t10893)
ret ptr %t10894
}
define ptr @length_bytes__rs146(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10897 = alloca [1 x ptr]
%t10895 = ashr i64 %p0, 56
%t10896 = and i64 %t10895, 255
%t10899 = call ptr @resid_box_i64(i64 %t10896)
%t10901 = getelementptr i8, ptr %t10897, i64 0
store ptr %t10899, ptr %t10901
%t10902 = call ptr @resid_list_new(i64 1, ptr %t10897, ptr @.lty10897)
%t10903 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10902)
%t10904 = musttail call ptr @length_bytes__rs147(i64 %p0, i64 6, ptr %t10903)
ret ptr %t10904
}
define ptr @sha_hw_words__rs174(i256 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10905 = lshr i256 %p0, 0
%t10906 = and i256 %t10905, 4294967295
%t10907 = trunc i256 %t10906 to i64
%t10908 = call ptr @resid_box_i64(i64 %t10907)
%t10911 = call ptr @resid_listbuf_push(ptr %p2, ptr %t10908)
%t10912 = call ptr @sha_hw_words(i256 %p0, i64 1, ptr %t10911)
ret ptr %t10912
}
define i64 @sched_w__rs184(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10913 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 0)
ret i64 %t10913
}
define i64 @sched_w__rs186(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10914 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 1)
ret i64 %t10914
}
define i64 @sched_w__rs188(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10915 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 2)
ret i64 %t10915
}
define i64 @sched_w__rs191(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10916 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 3)
ret i64 %t10916
}
define i64 @sched_w__rs194(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10917 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 4)
ret i64 %t10917
}
define i64 @sched_w__rs197(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10918 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 5)
ret i64 %t10918
}
define i64 @sched_w__rs200(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10919 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 6)
ret i64 %t10919
}
define i64 @sched_w__rs203(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10920 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 7)
ret i64 %t10920
}
define ptr @sha_blk__rs202(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10921 = call i64 @sched_w__rs203(ptr %p0, i64 %p1, i64 7, i64 0, i64 0, i64 %p21, i64 %p26)
%t10922 = call i64 @bsig1(i64 %p8)
%t10923 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10922)
%t10924 = extractvalue {i64, i1} %t10923, 0
%t10925 = extractvalue {i64, i1} %t10923, 1
%t10926 = zext i1 %t10925 to i8
call void @resid_overflow_check(i8 %t10926)
%t10927 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10928 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10924, i64 %t10927)
%t10929 = extractvalue {i64, i1} %t10928, 0
%t10930 = extractvalue {i64, i1} %t10928, 1
%t10931 = zext i1 %t10930 to i8
call void @resid_overflow_check(i8 %t10931)
%t10932 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10929, i64 -1424204075)
%t10933 = extractvalue {i64, i1} %t10932, 0
%t10934 = extractvalue {i64, i1} %t10932, 1
%t10935 = zext i1 %t10934 to i8
call void @resid_overflow_check(i8 %t10935)
%t10936 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10933, i64 %t10921)
%t10937 = extractvalue {i64, i1} %t10936, 0
%t10938 = extractvalue {i64, i1} %t10936, 1
%t10939 = zext i1 %t10938 to i8
call void @resid_overflow_check(i8 %t10939)
%t10940 = and i64 %t10937, 4294967295
%t10941 = call i64 @bsig0(i64 %p4)
%t10942 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10943 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10941, i64 %t10942)
%t10944 = extractvalue {i64, i1} %t10943, 0
%t10945 = extractvalue {i64, i1} %t10943, 1
%t10946 = zext i1 %t10945 to i8
call void @resid_overflow_check(i8 %t10946)
%t10947 = and i64 %t10944, 4294967295
%t10948 = add nsw i64 %t10940, %t10947
%t10949 = and i64 %t10948, 4294967295
%t10950 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10940)
%t10951 = extractvalue {i64, i1} %t10950, 0
%t10952 = extractvalue {i64, i1} %t10950, 1
%t10953 = zext i1 %t10952 to i8
call void @resid_overflow_check(i8 %t10953)
%t10954 = and i64 %t10951, 4294967295
%t10955 = musttail call ptr @sha_blk(ptr %p0, i64 %p1, i64 8, ptr %p3, i64 %t10949, i64 %p4, i64 %p5, i64 %p6, i64 %t10954, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t10921)
ret ptr %t10955
}
define ptr @sha_blk__rs199(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10956 = call i64 @sched_w__rs200(ptr %p0, i64 %p1, i64 6, i64 0, i64 0, i64 0, i64 %p26)
%t10957 = call i64 @bsig1(i64 %p8)
%t10958 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10957)
%t10959 = extractvalue {i64, i1} %t10958, 0
%t10960 = extractvalue {i64, i1} %t10958, 1
%t10961 = zext i1 %t10960 to i8
call void @resid_overflow_check(i8 %t10961)
%t10962 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10963 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10959, i64 %t10962)
%t10964 = extractvalue {i64, i1} %t10963, 0
%t10965 = extractvalue {i64, i1} %t10963, 1
%t10966 = zext i1 %t10965 to i8
call void @resid_overflow_check(i8 %t10966)
%t10967 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10964, i64 -1841331548)
%t10968 = extractvalue {i64, i1} %t10967, 0
%t10969 = extractvalue {i64, i1} %t10967, 1
%t10970 = zext i1 %t10969 to i8
call void @resid_overflow_check(i8 %t10970)
%t10971 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10968, i64 %t10956)
%t10972 = extractvalue {i64, i1} %t10971, 0
%t10973 = extractvalue {i64, i1} %t10971, 1
%t10974 = zext i1 %t10973 to i8
call void @resid_overflow_check(i8 %t10974)
%t10975 = and i64 %t10972, 4294967295
%t10976 = call i64 @bsig0(i64 %p4)
%t10977 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10978 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10976, i64 %t10977)
%t10979 = extractvalue {i64, i1} %t10978, 0
%t10980 = extractvalue {i64, i1} %t10978, 1
%t10981 = zext i1 %t10980 to i8
call void @resid_overflow_check(i8 %t10981)
%t10982 = and i64 %t10979, 4294967295
%t10983 = add nsw i64 %t10975, %t10982
%t10984 = and i64 %t10983, 4294967295
%t10985 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10975)
%t10986 = extractvalue {i64, i1} %t10985, 0
%t10987 = extractvalue {i64, i1} %t10985, 1
%t10988 = zext i1 %t10987 to i8
call void @resid_overflow_check(i8 %t10988)
%t10989 = and i64 %t10986, 4294967295
%t10990 = musttail call ptr @sha_blk__rs202(ptr %p0, i64 %p1, i64 7, ptr %p3, i64 %t10984, i64 %p4, i64 %p5, i64 %p6, i64 %t10989, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t10956)
ret ptr %t10990
}
define ptr @sha_blk__rs196(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10991 = call i64 @sched_w__rs197(ptr %p0, i64 %p1, i64 5, i64 0, i64 0, i64 0, i64 %p26)
%t10992 = call i64 @bsig1(i64 %p8)
%t10993 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10992)
%t10994 = extractvalue {i64, i1} %t10993, 0
%t10995 = extractvalue {i64, i1} %t10993, 1
%t10996 = zext i1 %t10995 to i8
call void @resid_overflow_check(i8 %t10996)
%t10997 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10998 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10994, i64 %t10997)
%t10999 = extractvalue {i64, i1} %t10998, 0
%t11000 = extractvalue {i64, i1} %t10998, 1
%t11001 = zext i1 %t11000 to i8
call void @resid_overflow_check(i8 %t11001)
%t11002 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10999, i64 1508970993)
%t11003 = extractvalue {i64, i1} %t11002, 0
%t11004 = extractvalue {i64, i1} %t11002, 1
%t11005 = zext i1 %t11004 to i8
call void @resid_overflow_check(i8 %t11005)
%t11006 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11003, i64 %t10991)
%t11007 = extractvalue {i64, i1} %t11006, 0
%t11008 = extractvalue {i64, i1} %t11006, 1
%t11009 = zext i1 %t11008 to i8
call void @resid_overflow_check(i8 %t11009)
%t11010 = and i64 %t11007, 4294967295
%t11011 = call i64 @bsig0(i64 %p4)
%t11012 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t11013 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11011, i64 %t11012)
%t11014 = extractvalue {i64, i1} %t11013, 0
%t11015 = extractvalue {i64, i1} %t11013, 1
%t11016 = zext i1 %t11015 to i8
call void @resid_overflow_check(i8 %t11016)
%t11017 = and i64 %t11014, 4294967295
%t11018 = add nsw i64 %t11010, %t11017
%t11019 = and i64 %t11018, 4294967295
%t11020 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t11010)
%t11021 = extractvalue {i64, i1} %t11020, 0
%t11022 = extractvalue {i64, i1} %t11020, 1
%t11023 = zext i1 %t11022 to i8
call void @resid_overflow_check(i8 %t11023)
%t11024 = and i64 %t11021, 4294967295
%t11025 = musttail call ptr @sha_blk__rs199(ptr %p0, i64 %p1, i64 6, ptr %p3, i64 %t11019, i64 %p4, i64 %p5, i64 %p6, i64 %t11024, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t10991)
ret ptr %t11025
}
define ptr @sha_blk__rs193(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11026 = call i64 @sched_w__rs194(ptr %p0, i64 %p1, i64 4, i64 0, i64 0, i64 0, i64 %p26)
%t11027 = call i64 @bsig1(i64 %p8)
%t11028 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t11027)
%t11029 = extractvalue {i64, i1} %t11028, 0
%t11030 = extractvalue {i64, i1} %t11028, 1
%t11031 = zext i1 %t11030 to i8
call void @resid_overflow_check(i8 %t11031)
%t11032 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t11033 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11029, i64 %t11032)
%t11034 = extractvalue {i64, i1} %t11033, 0
%t11035 = extractvalue {i64, i1} %t11033, 1
%t11036 = zext i1 %t11035 to i8
call void @resid_overflow_check(i8 %t11036)
%t11037 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11034, i64 961987163)
%t11038 = extractvalue {i64, i1} %t11037, 0
%t11039 = extractvalue {i64, i1} %t11037, 1
%t11040 = zext i1 %t11039 to i8
call void @resid_overflow_check(i8 %t11040)
%t11041 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11038, i64 %t11026)
%t11042 = extractvalue {i64, i1} %t11041, 0
%t11043 = extractvalue {i64, i1} %t11041, 1
%t11044 = zext i1 %t11043 to i8
call void @resid_overflow_check(i8 %t11044)
%t11045 = and i64 %t11042, 4294967295
%t11046 = call i64 @bsig0(i64 %p4)
%t11047 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t11048 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11046, i64 %t11047)
%t11049 = extractvalue {i64, i1} %t11048, 0
%t11050 = extractvalue {i64, i1} %t11048, 1
%t11051 = zext i1 %t11050 to i8
call void @resid_overflow_check(i8 %t11051)
%t11052 = and i64 %t11049, 4294967295
%t11053 = add nsw i64 %t11045, %t11052
%t11054 = and i64 %t11053, 4294967295
%t11055 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t11045)
%t11056 = extractvalue {i64, i1} %t11055, 0
%t11057 = extractvalue {i64, i1} %t11055, 1
%t11058 = zext i1 %t11057 to i8
call void @resid_overflow_check(i8 %t11058)
%t11059 = and i64 %t11056, 4294967295
%t11060 = musttail call ptr @sha_blk__rs196(ptr %p0, i64 %p1, i64 5, ptr %p3, i64 %t11054, i64 %p4, i64 %p5, i64 %p6, i64 %t11059, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t11026)
ret ptr %t11060
}
define ptr @sha_blk__rs190(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11061 = call i64 @sched_w__rs191(ptr %p0, i64 %p1, i64 3, i64 0, i64 0, i64 0, i64 %p26)
%t11062 = call i64 @bsig1(i64 %p8)
%t11063 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t11062)
%t11064 = extractvalue {i64, i1} %t11063, 0
%t11065 = extractvalue {i64, i1} %t11063, 1
%t11066 = zext i1 %t11065 to i8
call void @resid_overflow_check(i8 %t11066)
%t11067 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t11068 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11064, i64 %t11067)
%t11069 = extractvalue {i64, i1} %t11068, 0
%t11070 = extractvalue {i64, i1} %t11068, 1
%t11071 = zext i1 %t11070 to i8
call void @resid_overflow_check(i8 %t11071)
%t11072 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11069, i64 -373957723)
%t11073 = extractvalue {i64, i1} %t11072, 0
%t11074 = extractvalue {i64, i1} %t11072, 1
%t11075 = zext i1 %t11074 to i8
call void @resid_overflow_check(i8 %t11075)
%t11076 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11073, i64 %t11061)
%t11077 = extractvalue {i64, i1} %t11076, 0
%t11078 = extractvalue {i64, i1} %t11076, 1
%t11079 = zext i1 %t11078 to i8
call void @resid_overflow_check(i8 %t11079)
%t11080 = and i64 %t11077, 4294967295
%t11081 = call i64 @bsig0(i64 %p4)
%t11082 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t11083 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11081, i64 %t11082)
%t11084 = extractvalue {i64, i1} %t11083, 0
%t11085 = extractvalue {i64, i1} %t11083, 1
%t11086 = zext i1 %t11085 to i8
call void @resid_overflow_check(i8 %t11086)
%t11087 = and i64 %t11084, 4294967295
%t11088 = add nsw i64 %t11080, %t11087
%t11089 = and i64 %t11088, 4294967295
%t11090 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t11080)
%t11091 = extractvalue {i64, i1} %t11090, 0
%t11092 = extractvalue {i64, i1} %t11090, 1
%t11093 = zext i1 %t11092 to i8
call void @resid_overflow_check(i8 %t11093)
%t11094 = and i64 %t11091, 4294967295
%t11095 = musttail call ptr @sha_blk__rs193(ptr %p0, i64 %p1, i64 4, ptr %p3, i64 %t11089, i64 %p4, i64 %p5, i64 %p6, i64 %t11094, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p25, i64 %p26, i64 %p27, i64 %t11061)
ret ptr %t11095
}
define ptr @sha_blk__rs187(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11096 = call i64 @sched_w__rs188(ptr %p0, i64 %p1, i64 2, i64 0, i64 0, i64 0, i64 %p26)
%t11097 = call i64 @bsig1(i64 %p8)
%t11098 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t11097)
%t11099 = extractvalue {i64, i1} %t11098, 0
%t11100 = extractvalue {i64, i1} %t11098, 1
%t11101 = zext i1 %t11100 to i8
call void @resid_overflow_check(i8 %t11101)
%t11102 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t11103 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11099, i64 %t11102)
%t11104 = extractvalue {i64, i1} %t11103, 0
%t11105 = extractvalue {i64, i1} %t11103, 1
%t11106 = zext i1 %t11105 to i8
call void @resid_overflow_check(i8 %t11106)
%t11107 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11104, i64 -1245643825)
%t11108 = extractvalue {i64, i1} %t11107, 0
%t11109 = extractvalue {i64, i1} %t11107, 1
%t11110 = zext i1 %t11109 to i8
call void @resid_overflow_check(i8 %t11110)
%t11111 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11108, i64 %t11096)
%t11112 = extractvalue {i64, i1} %t11111, 0
%t11113 = extractvalue {i64, i1} %t11111, 1
%t11114 = zext i1 %t11113 to i8
call void @resid_overflow_check(i8 %t11114)
%t11115 = and i64 %t11112, 4294967295
%t11116 = call i64 @bsig0(i64 %p4)
%t11117 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t11118 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11116, i64 %t11117)
%t11119 = extractvalue {i64, i1} %t11118, 0
%t11120 = extractvalue {i64, i1} %t11118, 1
%t11121 = zext i1 %t11120 to i8
call void @resid_overflow_check(i8 %t11121)
%t11122 = and i64 %t11119, 4294967295
%t11123 = add nsw i64 %t11115, %t11122
%t11124 = and i64 %t11123, 4294967295
%t11125 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t11115)
%t11126 = extractvalue {i64, i1} %t11125, 0
%t11127 = extractvalue {i64, i1} %t11125, 1
%t11128 = zext i1 %t11127 to i8
call void @resid_overflow_check(i8 %t11128)
%t11129 = and i64 %t11126, 4294967295
%t11130 = musttail call ptr @sha_blk__rs190(ptr %p0, i64 %p1, i64 3, ptr %p3, i64 %t11124, i64 %p4, i64 %p5, i64 %p6, i64 %t11129, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p26, i64 %p27, i64 %t11096)
ret ptr %t11130
}
define ptr @sha_blk__rs185(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11131 = call i64 @sched_w__rs186(ptr %p0, i64 %p1, i64 1, i64 0, i64 0, i64 0, i64 0)
%t11132 = call i64 @bsig1(i64 %p8)
%t11133 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t11132)
%t11134 = extractvalue {i64, i1} %t11133, 0
%t11135 = extractvalue {i64, i1} %t11133, 1
%t11136 = zext i1 %t11135 to i8
call void @resid_overflow_check(i8 %t11136)
%t11137 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t11138 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11134, i64 %t11137)
%t11139 = extractvalue {i64, i1} %t11138, 0
%t11140 = extractvalue {i64, i1} %t11138, 1
%t11141 = zext i1 %t11140 to i8
call void @resid_overflow_check(i8 %t11141)
%t11142 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11139, i64 1899447441)
%t11143 = extractvalue {i64, i1} %t11142, 0
%t11144 = extractvalue {i64, i1} %t11142, 1
%t11145 = zext i1 %t11144 to i8
call void @resid_overflow_check(i8 %t11145)
%t11146 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11143, i64 %t11131)
%t11147 = extractvalue {i64, i1} %t11146, 0
%t11148 = extractvalue {i64, i1} %t11146, 1
%t11149 = zext i1 %t11148 to i8
call void @resid_overflow_check(i8 %t11149)
%t11150 = and i64 %t11147, 4294967295
%t11151 = call i64 @bsig0(i64 %p4)
%t11152 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t11153 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11151, i64 %t11152)
%t11154 = extractvalue {i64, i1} %t11153, 0
%t11155 = extractvalue {i64, i1} %t11153, 1
%t11156 = zext i1 %t11155 to i8
call void @resid_overflow_check(i8 %t11156)
%t11157 = and i64 %t11154, 4294967295
%t11158 = add nsw i64 %t11150, %t11157
%t11159 = and i64 %t11158, 4294967295
%t11160 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t11150)
%t11161 = extractvalue {i64, i1} %t11160, 0
%t11162 = extractvalue {i64, i1} %t11160, 1
%t11163 = zext i1 %t11162 to i8
call void @resid_overflow_check(i8 %t11163)
%t11164 = and i64 %t11161, 4294967295
%t11165 = musttail call ptr @sha_blk__rs187(ptr %p0, i64 %p1, i64 2, ptr %p3, i64 %t11159, i64 %p4, i64 %p5, i64 %p6, i64 %t11164, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p27, i64 %t11131)
ret ptr %t11165
}
define ptr @sha_blk__rs183(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11166 = call i64 @sched_w__rs184(ptr %p0, i64 %p1, i64 0, i64 0, i64 0, i64 0, i64 0)
%t11167 = call i64 @bsig1(i64 %p8)
%t11168 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t11167)
%t11169 = extractvalue {i64, i1} %t11168, 0
%t11170 = extractvalue {i64, i1} %t11168, 1
%t11171 = zext i1 %t11170 to i8
call void @resid_overflow_check(i8 %t11171)
%t11172 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t11173 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11169, i64 %t11172)
%t11174 = extractvalue {i64, i1} %t11173, 0
%t11175 = extractvalue {i64, i1} %t11173, 1
%t11176 = zext i1 %t11175 to i8
call void @resid_overflow_check(i8 %t11176)
%t11177 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11174, i64 1116352408)
%t11178 = extractvalue {i64, i1} %t11177, 0
%t11179 = extractvalue {i64, i1} %t11177, 1
%t11180 = zext i1 %t11179 to i8
call void @resid_overflow_check(i8 %t11180)
%t11181 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11178, i64 %t11166)
%t11182 = extractvalue {i64, i1} %t11181, 0
%t11183 = extractvalue {i64, i1} %t11181, 1
%t11184 = zext i1 %t11183 to i8
call void @resid_overflow_check(i8 %t11184)
%t11185 = and i64 %t11182, 4294967295
%t11186 = call i64 @bsig0(i64 %p4)
%t11187 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t11188 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11186, i64 %t11187)
%t11189 = extractvalue {i64, i1} %t11188, 0
%t11190 = extractvalue {i64, i1} %t11188, 1
%t11191 = zext i1 %t11190 to i8
call void @resid_overflow_check(i8 %t11191)
%t11192 = and i64 %t11189, 4294967295
%t11193 = add nsw i64 %t11185, %t11192
%t11194 = and i64 %t11193, 4294967295
%t11195 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t11185)
%t11196 = extractvalue {i64, i1} %t11195, 0
%t11197 = extractvalue {i64, i1} %t11195, 1
%t11198 = zext i1 %t11197 to i8
call void @resid_overflow_check(i8 %t11198)
%t11199 = and i64 %t11196, 4294967295
%t11200 = musttail call ptr @sha_blk__rs185(ptr %p0, i64 %p1, i64 1, ptr %p3, i64 %t11194, i64 %p4, i64 %p5, i64 %p6, i64 %t11199, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %t11166)
ret ptr %t11200
}
define ptr @hex_state__rs228(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11201 = call ptr @resid_list_get(ptr %p0, i64 1)
%t11202 = call i64 @resid_unbox_i64(ptr %t11201)
%t11204 = call ptr @hex_word(i64 %t11202)
%t11205 = call ptr @resid_str_concat(ptr %p2, ptr %t11204)
%t11206 = musttail call ptr @hex_state(ptr %p0, i64 2, ptr %t11205)
ret ptr %t11206
}
define ptr @hex_state__rs227(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11208 = call ptr @resid_list_get(ptr %p0, i64 0)
%t11209 = call i64 @resid_unbox_i64(ptr %t11208)
%t11211 = call ptr @hex_word(i64 %t11209)
%t11212 = call ptr @resid_str_concat(ptr @.s11207, ptr %t11211)
%t11213 = musttail call ptr @hex_state__rs228(ptr %p0, i64 1, ptr %t11212)
ret ptr %t11213
}
define ptr @wtb_inner__rs229(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11215 = alloca [1 x ptr]
%t11214 = call i64 @word_byte(ptr %p0, i64 %p1, i64 0)
%t11217 = call ptr @resid_box_i64(i64 %t11214)
%t11219 = getelementptr i8, ptr %t11215, i64 0
store ptr %t11217, ptr %t11219
%t11220 = call ptr @resid_list_new(i64 1, ptr %t11215, ptr @.lty11215)
%t11221 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t11220)
%t11222 = musttail call ptr @wtb_inner(ptr %p0, i64 %p1, i64 1, ptr %t11221)
ret ptr %t11222
}
define ptr @wtb_inner__rs232(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11224 = alloca [1 x ptr]
%t11223 = call i64 @word_byte(ptr %p0, i64 0, i64 0)
%t11226 = call ptr @resid_box_i64(i64 %t11223)
%t11228 = getelementptr i8, ptr %t11224, i64 0
store ptr %t11226, ptr %t11228
%t11229 = call ptr @resid_list_new(i64 1, ptr %t11224, ptr @.lty11224)
%t11230 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t11229)
%t11231 = musttail call ptr @wtb_inner(ptr %p0, i64 0, i64 1, ptr %t11230)
ret ptr %t11231
}
define ptr @wtb_outer__rs231(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11232 = call ptr @wtb_inner__rs232(ptr %p0, i64 0, i64 0, ptr %p2)
%t11233 = musttail call ptr @wtb_outer(ptr %p0, i64 1, ptr %t11232)
ret ptr %t11233
}
define i64 @pick__rs262(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p2
}
define ptr @w64__rs265(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11234 = and i64 %p1, 4294967295
%t11235 = alloca [2 x ptr]
%t11237 = call ptr @resid_box_i64(i64 0)
%t11239 = getelementptr i8, ptr %t11235, i64 0
store ptr %t11237, ptr %t11239
%t11240 = call ptr @resid_box_i64(i64 %t11234)
%t11242 = getelementptr i8, ptr %t11235, i64 8
store ptr %t11240, ptr %t11242
%t11243 = call ptr @resid_list_new(i64 2, ptr %t11235, ptr @.lty11235)
ret ptr %t11243
}
define i64 @shr_big__rs269(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11244 = ashr i64 %p0, 56
ret i64 %t11244
}
define i64 @shr_big__rs268(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11245 = ashr i64 %p0, 32
%t11246 = musttail call i64 @shr_big__rs269(i64 %t11245, i64 56)
ret i64 %t11246
}
define i64 @shr_big__rs267(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11247 = ashr i64 %p0, 32
%t11248 = musttail call i64 @shr_big__rs268(i64 %t11247, i64 88)
ret i64 %t11248
}
define i64 @shr_big__rs273(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11249 = ashr i64 %p0, 48
ret i64 %t11249
}
define i64 @shr_big__rs272(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11250 = ashr i64 %p0, 32
%t11251 = musttail call i64 @shr_big__rs273(i64 %t11250, i64 48)
ret i64 %t11251
}
define i64 @shr_big__rs271(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11252 = ashr i64 %p0, 32
%t11253 = musttail call i64 @shr_big__rs272(i64 %t11252, i64 80)
ret i64 %t11253
}
define i64 @shr_big__rs276(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11254 = ashr i64 %p0, 32
%t11255 = musttail call i64 @shr_big(i64 %t11254, i64 40)
ret i64 %t11255
}
define i64 @shr_big__rs275(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11256 = ashr i64 %p0, 32
%t11257 = musttail call i64 @shr_big__rs276(i64 %t11256, i64 72)
ret i64 %t11257
}
define ptr @len512_bytes__rs281(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11260 = alloca [1 x ptr]
%t11258 = call i64 @shr_big(i64 %p1, i64 64)
%t11259 = and i64 %t11258, 255
%t11262 = call ptr @resid_box_i64(i64 %t11259)
%t11264 = getelementptr i8, ptr %t11260, i64 0
store ptr %t11262, ptr %t11264
%t11265 = call ptr @resid_list_new(i64 1, ptr %t11260, ptr @.lty11260)
%t11266 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11265)
%t11267 = musttail call ptr @len512_bytes(ptr %t11266, i64 %p1, i64 7)
ret ptr %t11267
}
define ptr @len512_bytes__rs280(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11270 = alloca [1 x ptr]
%t11268 = call i64 @shr_big__rs276(i64 %p1, i64 72)
%t11269 = and i64 %t11268, 255
%t11272 = call ptr @resid_box_i64(i64 %t11269)
%t11274 = getelementptr i8, ptr %t11270, i64 0
store ptr %t11272, ptr %t11274
%t11275 = call ptr @resid_list_new(i64 1, ptr %t11270, ptr @.lty11270)
%t11276 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11275)
%t11277 = musttail call ptr @len512_bytes__rs281(ptr %t11276, i64 %p1, i64 8)
ret ptr %t11277
}
define ptr @len512_bytes__rs279(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11280 = alloca [1 x ptr]
%t11278 = call i64 @shr_big__rs272(i64 %p1, i64 80)
%t11279 = and i64 %t11278, 255
%t11282 = call ptr @resid_box_i64(i64 %t11279)
%t11284 = getelementptr i8, ptr %t11280, i64 0
store ptr %t11282, ptr %t11284
%t11285 = call ptr @resid_list_new(i64 1, ptr %t11280, ptr @.lty11280)
%t11286 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11285)
%t11287 = musttail call ptr @len512_bytes__rs280(ptr %t11286, i64 %p1, i64 9)
ret ptr %t11287
}
define ptr @len512_bytes__rs278(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11290 = alloca [1 x ptr]
%t11288 = call i64 @shr_big__rs268(i64 %p1, i64 88)
%t11289 = and i64 %t11288, 255
%t11292 = call ptr @resid_box_i64(i64 %t11289)
%t11294 = getelementptr i8, ptr %t11290, i64 0
store ptr %t11292, ptr %t11294
%t11295 = call ptr @resid_list_new(i64 1, ptr %t11290, ptr @.lty11290)
%t11296 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11295)
%t11297 = musttail call ptr @len512_bytes__rs279(ptr %t11296, i64 %p1, i64 10)
ret ptr %t11297
}
define ptr @len512_bytes__rs277(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11300 = alloca [1 x ptr]
%t11298 = call i64 @shr_big(i64 %p1, i64 96)
%t11299 = and i64 %t11298, 255
%t11302 = call ptr @resid_box_i64(i64 %t11299)
%t11304 = getelementptr i8, ptr %t11300, i64 0
store ptr %t11302, ptr %t11304
%t11305 = call ptr @resid_list_new(i64 1, ptr %t11300, ptr @.lty11300)
%t11306 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11305)
%t11307 = musttail call ptr @len512_bytes__rs278(ptr %t11306, i64 %p1, i64 11)
ret ptr %t11307
}
define ptr @len512_bytes__rs274(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11310 = alloca [1 x ptr]
%t11308 = call i64 @shr_big__rs275(i64 %p1, i64 104)
%t11309 = and i64 %t11308, 255
%t11312 = call ptr @resid_box_i64(i64 %t11309)
%t11314 = getelementptr i8, ptr %t11310, i64 0
store ptr %t11312, ptr %t11314
%t11315 = call ptr @resid_list_new(i64 1, ptr %t11310, ptr @.lty11310)
%t11316 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11315)
%t11317 = musttail call ptr @len512_bytes__rs277(ptr %t11316, i64 %p1, i64 12)
ret ptr %t11317
}
define ptr @len512_bytes__rs270(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11320 = alloca [1 x ptr]
%t11318 = call i64 @shr_big__rs271(i64 %p1, i64 112)
%t11319 = and i64 %t11318, 255
%t11322 = call ptr @resid_box_i64(i64 %t11319)
%t11324 = getelementptr i8, ptr %t11320, i64 0
store ptr %t11322, ptr %t11324
%t11325 = call ptr @resid_list_new(i64 1, ptr %t11320, ptr @.lty11320)
%t11326 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11325)
%t11327 = musttail call ptr @len512_bytes__rs274(ptr %t11326, i64 %p1, i64 13)
ret ptr %t11327
}
define ptr @len512_bytes__rs266(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11330 = alloca [1 x ptr]
%t11328 = call i64 @shr_big__rs267(i64 %p1, i64 120)
%t11329 = and i64 %t11328, 255
%t11332 = call ptr @resid_box_i64(i64 %t11329)
%t11334 = getelementptr i8, ptr %t11330, i64 0
store ptr %t11332, ptr %t11334
%t11335 = call ptr @resid_list_new(i64 1, ptr %t11330, ptr @.lty11330)
%t11336 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11335)
%t11337 = musttail call ptr @len512_bytes__rs270(ptr %t11336, i64 %p1, i64 14)
ret ptr %t11337
}
define ptr @mw512_acc__rs282(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11338 = call ptr @mw512(ptr %p0, i64 %p1, i64 0)
%t11339 = call ptr @resid_list_freeze(ptr %t11338)
%t11340 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t11339)
%t11341 = musttail call ptr @mw512_acc(ptr %p0, i64 %p1, i64 1, ptr %t11340)
ret ptr %t11341
}
define ptr @w64_rotr__rs284(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11342 = musttail call ptr @w64_rotr_small(ptr %p0, i64 1)
ret ptr %t11342
}
define ptr @w64_rotr__rs286(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11343 = musttail call ptr @w64_rotr_small(ptr %p0, i64 8)
ret ptr %t11343
}
define ptr @w64_shr__rs288(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11344 = musttail call ptr @w64_shr_small(ptr %p0, i64 7)
ret ptr %t11344
}
define ptr @w64_rotr__rs290(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11345 = musttail call ptr @w64_rotr_small(ptr %p0, i64 19)
ret ptr %t11345
}
define ptr @w64_rotr__rs292(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11346 = call i64 @w64_lo(ptr %p0)
%t11347 = call i64 @w64_hi(ptr %p0)
%t11348 = call ptr @w64(i64 %t11346, i64 %t11347)
%t11349 = musttail call ptr @w64_rotr_small(ptr %t11348, i64 29)
ret ptr %t11349
}
define ptr @w64_shr__rs294(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11350 = musttail call ptr @w64_shr_small(ptr %p0, i64 6)
ret ptr %t11350
}
define ptr @w64_rotr__rs296(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11351 = musttail call ptr @w64_rotr_small(ptr %p0, i64 28)
ret ptr %t11351
}
define ptr @w64_rotr__rs298(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11352 = call i64 @w64_lo(ptr %p0)
%t11353 = call i64 @w64_hi(ptr %p0)
%t11354 = call ptr @w64(i64 %t11352, i64 %t11353)
%t11355 = musttail call ptr @w64_rotr_small(ptr %t11354, i64 2)
ret ptr %t11355
}
define ptr @w64_rotr__rs300(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11356 = call i64 @w64_lo(ptr %p0)
%t11357 = call i64 @w64_hi(ptr %p0)
%t11358 = call ptr @w64(i64 %t11356, i64 %t11357)
%t11359 = musttail call ptr @w64_rotr_small(ptr %t11358, i64 7)
ret ptr %t11359
}
define ptr @w64_rotr__rs302(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11360 = musttail call ptr @w64_rotr_small(ptr %p0, i64 14)
ret ptr %t11360
}
define i64 @fw_hi__rs305(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11361 = call ptr @resid_list_get(ptr %p0, i64 0)
%t11362 = call i64 @resid_unbox_i64(ptr %t11361)
ret i64 %t11362
}
define i64 @fw_lo__rs306(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11364 = call ptr @resid_list_get(ptr %p0, i64 1)
%t11365 = call i64 @resid_unbox_i64(ptr %t11364)
ret i64 %t11365
}
define i64 @fw_hi__rs308(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11367 = call ptr @resid_list_get(ptr %p0, i64 2)
%t11368 = call i64 @resid_unbox_i64(ptr %t11367)
ret i64 %t11368
}
define i64 @fw_lo__rs309(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11370 = call ptr @resid_list_get(ptr %p0, i64 3)
%t11371 = call i64 @resid_unbox_i64(ptr %t11370)
ret i64 %t11371
}
define i64 @fw_hi__rs311(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11373 = call ptr @resid_list_get(ptr %p0, i64 4)
%t11374 = call i64 @resid_unbox_i64(ptr %t11373)
ret i64 %t11374
}
define i64 @fw_lo__rs312(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11376 = call ptr @resid_list_get(ptr %p0, i64 5)
%t11377 = call i64 @resid_unbox_i64(ptr %t11376)
ret i64 %t11377
}
define i64 @fw_hi__rs314(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11379 = call ptr @resid_list_get(ptr %p0, i64 6)
%t11380 = call i64 @resid_unbox_i64(ptr %t11379)
ret i64 %t11380
}
define i64 @fw_lo__rs315(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11382 = call ptr @resid_list_get(ptr %p0, i64 7)
%t11383 = call i64 @resid_unbox_i64(ptr %t11382)
ret i64 %t11383
}
define i64 @fw_hi__rs317(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11385 = call ptr @resid_list_get(ptr %p0, i64 8)
%t11386 = call i64 @resid_unbox_i64(ptr %t11385)
ret i64 %t11386
}
define i64 @fw_lo__rs318(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11388 = call ptr @resid_list_get(ptr %p0, i64 9)
%t11389 = call i64 @resid_unbox_i64(ptr %t11388)
ret i64 %t11389
}
define i64 @fw_hi__rs320(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11391 = call ptr @resid_list_get(ptr %p0, i64 10)
%t11392 = call i64 @resid_unbox_i64(ptr %t11391)
ret i64 %t11392
}
define i64 @fw_lo__rs321(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11394 = call ptr @resid_list_get(ptr %p0, i64 11)
%t11395 = call i64 @resid_unbox_i64(ptr %t11394)
ret i64 %t11395
}
define i64 @fw_hi__rs323(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11397 = call ptr @resid_list_get(ptr %p0, i64 12)
%t11398 = call i64 @resid_unbox_i64(ptr %t11397)
ret i64 %t11398
}
define i64 @fw_lo__rs324(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11400 = call ptr @resid_list_get(ptr %p0, i64 13)
%t11401 = call i64 @resid_unbox_i64(ptr %t11400)
ret i64 %t11401
}
define i64 @fw_hi__rs326(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11403 = call ptr @resid_list_get(ptr %p0, i64 14)
%t11404 = call i64 @resid_unbox_i64(ptr %t11403)
ret i64 %t11404
}
define i64 @fw_lo__rs327(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11406 = call ptr @resid_list_get(ptr %p0, i64 15)
%t11407 = call i64 @resid_unbox_i64(ptr %t11406)
ret i64 %t11407
}
define ptr @sha512_rounds_flat__rs330(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11409 = call ptr @sha512_round_flat(ptr %p0, ptr %p1, i64 0)
%t11410 = musttail call ptr @sha512_rounds_flat(ptr %t11409, ptr %p1, i64 1)
ret ptr %t11410
}
define ptr @add_st_acc__rs334(ptr %p0, ptr %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11411 = call ptr @add_st_word(ptr %p0, ptr %p1, i64 0)
%t11412 = call ptr @resid_list_freeze(ptr %t11411)
%t11413 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t11412)
%t11414 = musttail call ptr @add_st_acc(ptr %p0, ptr %p1, i64 1, ptr %t11413)
ret ptr %t11414
}
define i64 @w64_bytes__rs344(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11415 = add nsw i64 %p1, 0
%t11416 = call ptr @resid_list_get(ptr %p0, i64 %t11415)
%t11417 = call i64 @resid_unbox_i64(ptr %t11416)
%t11419 = and i64 %t11417, 255
%t11420 = or i64 0, %t11419
%t11421 = musttail call i64 @w64_bytes(ptr %p0, i64 %p1, i64 1, i64 %t11420)
ret i64 %t11421
}
define i64 @sched64__rs347(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11422 = call i64 @word64_at(ptr %p0, i64 %p1, i64 0)
ret i64 %t11422
}
define i64 @sched64__rs350(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11423 = call i64 @word64_at(ptr %p0, i64 %p1, i64 1)
ret i64 %t11423
}
define i64 @sched64__rs353(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11424 = call i64 @word64_at(ptr %p0, i64 %p1, i64 2)
ret i64 %t11424
}
define i64 @sched64__rs356(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11425 = call i64 @word64_at(ptr %p0, i64 %p1, i64 3)
ret i64 %t11425
}
define i64 @sched64__rs359(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11426 = call i64 @word64_at(ptr %p0, i64 %p1, i64 4)
ret i64 %t11426
}
define i64 @sched64__rs362(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11427 = call i64 @word64_at(ptr %p0, i64 %p1, i64 5)
ret i64 %t11427
}
define i64 @sched64__rs365(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11428 = call i64 @word64_at(ptr %p0, i64 %p1, i64 6)
ret i64 %t11428
}
define i64 @sched64__rs368(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11429 = call i64 @word64_at(ptr %p0, i64 %p1, i64 7)
ret i64 %t11429
}
define ptr @be64_push__rs380(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11430 = lshr i64 %p0, 56
%t11431 = and i64 %t11430, 255
%t11432 = call ptr @resid_box_i64(i64 %t11431)
%t11435 = call ptr @resid_listbuf_push(ptr %p2, ptr %t11432)
%t11436 = musttail call ptr @be64_push(i64 %p0, i64 1, ptr %t11435)
ret ptr %t11436
}
define ptr @__m____________lib_crypto_resid__sha1_words16__rs394(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11438 = alloca [1 x ptr]
%t11437 = call i64 @__m____________lib_crypto_resid__sha1_word(ptr %p0, i64 %p1, i64 0)
%t11440 = call ptr @resid_box_i64(i64 %t11437)
%t11442 = getelementptr i8, ptr %t11438, i64 0
store ptr %t11440, ptr %t11442
%t11443 = call ptr @resid_list_new(i64 1, ptr %t11438, ptr @.lty11438)
%t11444 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t11443)
%t11445 = musttail call ptr @__m____________lib_crypto_resid__sha1_words16(ptr %p0, i64 %p1, i64 1, ptr %t11444)
ret ptr %t11445
}
define i64 @__m____________lib_crypto_resid__sha1_f__rs398(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11446 = and i64 %p1, %p2
%t11447 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 4294967295, i64 %p1)
%t11448 = extractvalue {i64, i1} %t11447, 0
%t11449 = extractvalue {i64, i1} %t11447, 1
%t11450 = zext i1 %t11449 to i8
call void @resid_overflow_check(i8 %t11450)
%t11451 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t11448)
%t11452 = and i64 %t11451, %p3
%t11453 = or i64 %t11446, %t11452
%t11454 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t11453)
ret i64 %t11454
}
define ptr @cbe_ascii(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11455 = call ptr @resid_sacc_from(ptr %p2)
%t11456 = musttail call ptr @cbe_ascii__sacc(ptr %p0, i64 %p1, ptr %t11455)
ret ptr %t11456
}
define internal ptr @"resid.rec.evac.W512"(ptr %v, ptr %u) "probe-stack"="inline-asm" {
entry:
%c = call ptr @resid_mv_rec(ptr %v, i64 64, i8 0, ptr %u)
%m = icmp ne ptr %c, %v
br i1 %m, label %fix, label %done
fix:
br label %done
done:
ret ptr %c
}
define internal ptr @"resid.rec.evac.Ept"(ptr %v, ptr %u) "probe-stack"="inline-asm" {
entry:
%c = call ptr @resid_mv_rec(ptr %v, i64 128, i8 0, ptr %u)
%m = icmp ne ptr %c, %v
br i1 %m, label %fix, label %done
fix:
br label %done
done:
ret ptr %c
}
define internal ptr @"resid.rec.evac.DecPt"(ptr %v, ptr %u) "probe-stack"="inline-asm" {
entry:
%c = call ptr @resid_mv_rec(ptr %v, i64 72, i8 0, ptr %u)
%m = icmp ne ptr %c, %v
br i1 %m, label %fix, label %done
fix:
br label %done
done:
ret ptr %c
}
define internal ptr @"resid.rec.evac.CbeHead"(ptr %v, ptr %u) "probe-stack"="inline-asm" {
entry:
%c = call ptr @resid_mv_rec(ptr %v, i64 32, i8 0, ptr %u)
%m = icmp ne ptr %c, %v
br i1 %m, label %fix, label %done
fix:
br label %done
done:
ret ptr %c
}
define internal ptr @"resid.rec.evac.CbeStr"(ptr %v, ptr %u) "probe-stack"="inline-asm" {
entry:
%c = call ptr @resid_mv_rec(ptr %v, i64 24, i8 0, ptr %u)
%m = icmp ne ptr %c, %v
br i1 %m, label %fix, label %done
fix:
%g1 = getelementptr i8, ptr %c, i64 8
%f1 = load ptr, ptr %g1
%e1 = call ptr @resid_mv_list(ptr %f1, ptr %u)
store ptr %e1, ptr %g1
br label %done
done:
ret ptr %c
}
define internal ptr @"resid.rec.evac.CoseSign1"(ptr %v, ptr %u) "probe-stack"="inline-asm" {
entry:
%c = call ptr @resid_mv_rec(ptr %v, i64 48, i8 0, ptr %u)
%m = icmp ne ptr %c, %v
br i1 %m, label %fix, label %done
fix:
%g1 = getelementptr i8, ptr %c, i64 8
%f1 = load ptr, ptr %g1
%e1 = call ptr @resid_mv_str(ptr %f1, ptr %u)
store ptr %e1, ptr %g1
%g2 = getelementptr i8, ptr %c, i64 16
%f2 = load ptr, ptr %g2
%e2 = call ptr @resid_mv_str(ptr %f2, ptr %u)
store ptr %e2, ptr %g2
%g3 = getelementptr i8, ptr %c, i64 24
%f3 = load ptr, ptr %g3
%e3 = call ptr @resid_mv_list(ptr %f3, ptr %u)
store ptr %e3, ptr %g3
%g4 = getelementptr i8, ptr %c, i64 32
%f4 = load ptr, ptr %g4
%e4 = call ptr @resid_mv_list(ptr %f4, ptr %u)
store ptr %e4, ptr %g4
%g5 = getelementptr i8, ptr %c, i64 40
%f5 = load ptr, ptr %g5
%e5 = call ptr @resid_mv_list(ptr %f5, ptr %u)
store ptr %e5, ptr %g5
br label %done
done:
ret ptr %c
}
define internal ptr @"resid.rec.evac.CoseOpen"(ptr %v, ptr %u) "probe-stack"="inline-asm" {
entry:
%c = call ptr @resid_mv_rec(ptr %v, i64 24, i8 0, ptr %u)
%m = icmp ne ptr %c, %v
br i1 %m, label %fix, label %done
fix:
%g1 = getelementptr i8, ptr %c, i64 8
%f1 = load ptr, ptr %g1
%e1 = call ptr @resid_mv_str(ptr %f1, ptr %u)
store ptr %e1, ptr %g1
%g2 = getelementptr i8, ptr %c, i64 16
%f2 = load ptr, ptr %g2
%e2 = call ptr @resid_mv_list(ptr %f2, ptr %u)
store ptr %e2, ptr %g2
br label %done
done:
ret ptr %c
}
define internal ptr @"resid.rec.evac.SourceLoc"(ptr %v, ptr %u) "probe-stack"="inline-asm" {
entry:
%c = call ptr @resid_mv_rec(ptr %v, i64 24, i8 0, ptr %u)
%m = icmp ne ptr %c, %v
br i1 %m, label %fix, label %done
fix:
%g0 = getelementptr i8, ptr %c, i64 0
%f0 = load ptr, ptr %g0
%e0 = call ptr @resid_mv_str(ptr %f0, ptr %u)
store ptr %e0, ptr %g0
br label %done
done:
ret ptr %c
}
define internal ptr @"resid.rec.evac.RegionError"(ptr %v, ptr %u) "probe-stack"="inline-asm" {
entry:
%c = call ptr @resid_mv_rec(ptr %v, i64 8, i8 0, ptr %u)
%m = icmp ne ptr %c, %v
br i1 %m, label %fix, label %done
fix:
%g0 = getelementptr i8, ptr %c, i64 0
%f0 = load ptr, ptr %g0
%e0 = call ptr @resid_mv_str(ptr %f0, ptr %u)
store ptr %e0, ptr %g0
br label %done
done:
ret ptr %c
}
define internal ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %v, ptr %u) "probe-stack"="inline-asm" {
entry:
%c = call ptr @resid_mv_rec(ptr %v, i64 256, i8 1, ptr %u)
%m = icmp ne ptr %c, %v
br i1 %m, label %fix, label %done
fix:
br label %done
done:
ret ptr %c
}
define internal ptr @"resid.rec.evac.H8(UInt(64))"(ptr %v, ptr %u) "probe-stack"="inline-asm" {
entry:
%c = call ptr @resid_mv_rec(ptr %v, i64 64, i8 0, ptr %u)
%m = icmp ne ptr %c, %v
br i1 %m, label %fix, label %done
fix:
br label %done
done:
ret ptr %c
}
define internal void @"resid.rec.freeze.BnDiv"(ptr %v) "probe-stack"="inline-asm" {
entry:
%g0 = getelementptr i8, ptr %v, i64 0
%f0 = load ptr, ptr %g0
%r0 = call ptr @resid_list_freeze(ptr %f0)
%g1 = getelementptr i8, ptr %v, i64 8
%f1 = load ptr, ptr %g1
%r1 = call ptr @resid_list_freeze(ptr %f1)
ret void
}
define internal void @"resid.rec.freeze.BnDivState"(ptr %v) "probe-stack"="inline-asm" {
entry:
%g0 = getelementptr i8, ptr %v, i64 0
%f0 = load ptr, ptr %g0
%r0 = call ptr @resid_list_freeze(ptr %f0)
%g1 = getelementptr i8, ptr %v, i64 8
%f1 = load ptr, ptr %g1
%r1 = call ptr @resid_list_freeze(ptr %f1)
ret void
}
define internal void @"resid.rec.freeze.BnMulSub"(ptr %v) "probe-stack"="inline-asm" {
entry:
%g0 = getelementptr i8, ptr %v, i64 0
%f0 = load ptr, ptr %g0
%r0 = call ptr @resid_list_freeze(ptr %f0)
ret void
}
define internal void @"resid.rec.freeze.BnMont"(ptr %v) "probe-stack"="inline-asm" {
entry:
%g0 = getelementptr i8, ptr %v, i64 0
%f0 = load ptr, ptr %g0
%r0 = call ptr @resid_list_freeze(ptr %f0)
%g1 = getelementptr i8, ptr %v, i64 16
%f1 = load ptr, ptr %g1
%r1 = call ptr @resid_list_freeze(ptr %f1)
%g2 = getelementptr i8, ptr %v, i64 24
%f2 = load ptr, ptr %g2
%r2 = call ptr @resid_list_freeze(ptr %f2)
ret void
}
define internal void @"resid.rec.freeze.Transcript"(ptr %v) "probe-stack"="inline-asm" {
entry:
call void @resid_rec_share(ptr %v)
%g0 = getelementptr i8, ptr %v, i64 0
%f0 = load ptr, ptr %g0
%r0 = call ptr @resid_list_freeze(ptr %f0)
ret void
}
define internal void @"resid.rec.freeze.TrSample"(ptr %v) "probe-stack"="inline-asm" {
entry:
%g0 = getelementptr i8, ptr %v, i64 0
%f0 = load ptr, ptr %g0
%r0 = call ptr @resid_list_freeze(ptr %f0)
ret void
}
define internal void @"resid.rec.freeze.Pedersen"(ptr %v) "probe-stack"="inline-asm" {
entry:
%g0 = getelementptr i8, ptr %v, i64 0
%f0 = load ptr, ptr %g0
%r0 = call ptr @resid_list_freeze(ptr %f0)
%g1 = getelementptr i8, ptr %v, i64 8
%f1 = load ptr, ptr %g1
%r1 = call ptr @resid_list_freeze(ptr %f1)
%g2 = getelementptr i8, ptr %v, i64 16
%f2 = load ptr, ptr %g2
%r2 = call ptr @resid_list_freeze(ptr %f2)
ret void
}
define internal void @"resid.rec.freeze.ZkDraw"(ptr %v) "probe-stack"="inline-asm" {
entry:
%g0 = getelementptr i8, ptr %v, i64 0
%f0 = load ptr, ptr %g0
%r0 = call ptr @resid_list_freeze(ptr %f0)
ret void
}
define internal void @"resid.rec.freeze.PrmProof"(ptr %v) "probe-stack"="inline-asm" {
entry:
%g0 = getelementptr i8, ptr %v, i64 0
%f0 = load ptr, ptr %g0
%r0 = call ptr @resid_list_freeze(ptr %f0)
%g1 = getelementptr i8, ptr %v, i64 8
%f1 = load ptr, ptr %g1
%r1 = call ptr @resid_list_freeze(ptr %f1)
ret void
}
define internal void @"resid.rec.freeze.ModResponse"(ptr %v) "probe-stack"="inline-asm" {
entry:
%g0 = getelementptr i8, ptr %v, i64 16
%f0 = load ptr, ptr %g0
%r0 = call ptr @resid_list_freeze(ptr %f0)
%g1 = getelementptr i8, ptr %v, i64 24
%f1 = load ptr, ptr %g1
%r1 = call ptr @resid_list_freeze(ptr %f1)
ret void
}
define internal void @"resid.rec.freeze.ModProof"(ptr %v) "probe-stack"="inline-asm" {
entry:
%g0 = getelementptr i8, ptr %v, i64 0
%f0 = load ptr, ptr %g0
%r0 = call ptr @resid_list_freeze(ptr %f0)
%g1 = getelementptr i8, ptr %v, i64 8
%f1 = load ptr, ptr %g1
%r1 = call ptr @resid_list_freeze(ptr %f1)
ret void
}
define internal void @"resid.rec.freeze.ModQr"(ptr %v) "probe-stack"="inline-asm" {
entry:
%g0 = getelementptr i8, ptr %v, i64 16
%f0 = load ptr, ptr %g0
%r0 = call ptr @resid_list_freeze(ptr %f0)
ret void
}
define internal void @"resid.rec.freeze.PedersenKey"(ptr %v) "probe-stack"="inline-asm" {
entry:
%g0 = getelementptr i8, ptr %v, i64 0
%f0 = load ptr, ptr %g0
call void @"resid.rec.freeze.Pedersen"(ptr %f0)
%g1 = getelementptr i8, ptr %v, i64 8
%f1 = load ptr, ptr %g1
%r1 = call ptr @resid_list_freeze(ptr %f1)
%g2 = getelementptr i8, ptr %v, i64 16
%f2 = load ptr, ptr %g2
%r2 = call ptr @resid_list_freeze(ptr %f2)
ret void
}
define internal void @"resid.rec.freeze.CbeStr"(ptr %v) "probe-stack"="inline-asm" {
entry:
%g0 = getelementptr i8, ptr %v, i64 8
%f0 = load ptr, ptr %g0
%r0 = call ptr @resid_list_freeze(ptr %f0)
ret void
}
define internal void @"resid.rec.freeze.CoseSign1"(ptr %v) "probe-stack"="inline-asm" {
entry:
%g0 = getelementptr i8, ptr %v, i64 24
%f0 = load ptr, ptr %g0
%r0 = call ptr @resid_list_freeze(ptr %f0)
%g1 = getelementptr i8, ptr %v, i64 32
%f1 = load ptr, ptr %g1
%r1 = call ptr @resid_list_freeze(ptr %f1)
%g2 = getelementptr i8, ptr %v, i64 40
%f2 = load ptr, ptr %g2
%r2 = call ptr @resid_list_freeze(ptr %f2)
ret void
}
define internal void @"resid.rec.freeze.CoseOpen"(ptr %v) "probe-stack"="inline-asm" {
entry:
%g0 = getelementptr i8, ptr %v, i64 16
%f0 = load ptr, ptr %g0
%r0 = call ptr @resid_list_freeze(ptr %f0)
ret void
}
@.lty17 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty27 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty29 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc29 = private global ptr null
@.lcd29 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty32 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty34 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty90 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty137 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty244 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty255 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty317 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty325 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty385 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty390 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.s422 = private unnamed_addr constant [14 x i8] c"bn_sub: a < b\00"
@.lty429 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty470 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty480 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.s539 = private unnamed_addr constant [28 x i8] c"bn_divmod: division by zero\00"
@.ltyE544 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty566 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc566 = private global ptr null
@.lcd566 = private unnamed_addr constant [1 x i64] [i64 0]
@.lty589 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty699 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty932 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.oty1012 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox1012 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty1012}, align 16
@.lty1013 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty1015 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1015 = private global ptr null
@.lcd1015 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1020 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1020 = private global ptr null
@.lcd1020 = private unnamed_addr constant [1 x i64] [i64 1]
@.oty1024 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox1024 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty1024}, align 16
@.oty1025 = private unnamed_addr constant [23 x i8] c"Option(List(UInt(64)))\00"
@.lty1037 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1037 = private global ptr null
@.lcd1037 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1040 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1040 = private global ptr null
@.lcd1040 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1057 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1057 = private global ptr null
@.lcd1057 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1064 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1064 = private global ptr null
@.lcd1064 = private unnamed_addr constant [1 x i64] [i64 2]
@.lty1083 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1083 = private global ptr null
@.lcd1083 = private unnamed_addr constant [1 x i64] [i64 1]
@.s1088 = private unnamed_addr constant [45 x i8] c"bn_mont_new: modulus must be odd and above 1\00"
@.lty1091 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1091 = private global ptr null
@.lcd1091 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1132 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1132 = private global ptr null
@.lcd1132 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1140 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1140 = private global ptr null
@.lcd1140 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1173 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1173 = private global ptr null
@.lcd1173 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1187 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1187 = private global ptr null
@.lcd1187 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1217 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1217 = private global ptr null
@.lcd1217 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1236 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1236 = private global ptr null
@.lcd1236 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1245 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty1288 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1288 = private global ptr null
@.lcd1288 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1295 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1295 = private global ptr null
@.lcd1295 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1299 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1299 = private global ptr null
@.lcd1299 = private unnamed_addr constant [1 x i64] [i64 3]
@.lty1309 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1309 = private global ptr null
@.lcd1309 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1313 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1313 = private global ptr null
@.lcd1313 = private unnamed_addr constant [302 x i64] [i64 3, i64 5, i64 7, i64 11, i64 13, i64 17, i64 19, i64 23, i64 29, i64 31, i64 37, i64 41, i64 43, i64 47, i64 53, i64 59, i64 61, i64 67, i64 71, i64 73, i64 79, i64 83, i64 89, i64 97, i64 101, i64 103, i64 107, i64 109, i64 113, i64 127, i64 131, i64 137, i64 139, i64 149, i64 151, i64 157, i64 163, i64 167, i64 173, i64 179, i64 181, i64 191, i64 193, i64 197, i64 199, i64 211, i64 223, i64 227, i64 229, i64 233, i64 239, i64 241, i64 251, i64 257, i64 263, i64 269, i64 271, i64 277, i64 281, i64 283, i64 293, i64 307, i64 311, i64 313, i64 317, i64 331, i64 337, i64 347, i64 349, i64 353, i64 359, i64 367, i64 373, i64 379, i64 383, i64 389, i64 397, i64 401, i64 409, i64 419, i64 421, i64 431, i64 433, i64 439, i64 443, i64 449, i64 457, i64 461, i64 463, i64 467, i64 479, i64 487, i64 491, i64 499, i64 503, i64 509, i64 521, i64 523, i64 541, i64 547, i64 557, i64 563, i64 569, i64 571, i64 577, i64 587, i64 593, i64 599, i64 601, i64 607, i64 613, i64 617, i64 619, i64 631, i64 641, i64 643, i64 647, i64 653, i64 659, i64 661, i64 673, i64 677, i64 683, i64 691, i64 701, i64 709, i64 719, i64 727, i64 733, i64 739, i64 743, i64 751, i64 757, i64 761, i64 769, i64 773, i64 787, i64 797, i64 809, i64 811, i64 821, i64 823, i64 827, i64 829, i64 839, i64 853, i64 857, i64 859, i64 863, i64 877, i64 881, i64 883, i64 887, i64 907, i64 911, i64 919, i64 929, i64 937, i64 941, i64 947, i64 953, i64 967, i64 971, i64 977, i64 983, i64 991, i64 997, i64 1009, i64 1013, i64 1019, i64 1021, i64 1031, i64 1033, i64 1039, i64 1049, i64 1051, i64 1061, i64 1063, i64 1069, i64 1087, i64 1091, i64 1093, i64 1097, i64 1103, i64 1109, i64 1117, i64 1123, i64 1129, i64 1151, i64 1153, i64 1163, i64 1171, i64 1181, i64 1187, i64 1193, i64 1201, i64 1213, i64 1217, i64 1223, i64 1229, i64 1231, i64 1237, i64 1249, i64 1259, i64 1277, i64 1279, i64 1283, i64 1289, i64 1291, i64 1297, i64 1301, i64 1303, i64 1307, i64 1319, i64 1321, i64 1327, i64 1361, i64 1367, i64 1373, i64 1381, i64 1399, i64 1409, i64 1423, i64 1427, i64 1429, i64 1433, i64 1439, i64 1447, i64 1451, i64 1453, i64 1459, i64 1471, i64 1481, i64 1483, i64 1487, i64 1489, i64 1493, i64 1499, i64 1511, i64 1523, i64 1531, i64 1543, i64 1549, i64 1553, i64 1559, i64 1567, i64 1571, i64 1579, i64 1583, i64 1597, i64 1601, i64 1607, i64 1609, i64 1613, i64 1619, i64 1621, i64 1627, i64 1637, i64 1657, i64 1663, i64 1667, i64 1669, i64 1693, i64 1697, i64 1699, i64 1709, i64 1721, i64 1723, i64 1733, i64 1741, i64 1747, i64 1753, i64 1759, i64 1777, i64 1783, i64 1787, i64 1789, i64 1801, i64 1811, i64 1823, i64 1831, i64 1847, i64 1861, i64 1867, i64 1871, i64 1873, i64 1877, i64 1879, i64 1889, i64 1901, i64 1907, i64 1913, i64 1931, i64 1933, i64 1949, i64 1951, i64 1973, i64 1979, i64 1987, i64 1993, i64 1997, i64 1999]
@.lty1317 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1317 = private global ptr null
@.lcd1317 = private unnamed_addr constant [302 x i64] [i64 3, i64 5, i64 7, i64 11, i64 13, i64 17, i64 19, i64 23, i64 29, i64 31, i64 37, i64 41, i64 43, i64 47, i64 53, i64 59, i64 61, i64 67, i64 71, i64 73, i64 79, i64 83, i64 89, i64 97, i64 101, i64 103, i64 107, i64 109, i64 113, i64 127, i64 131, i64 137, i64 139, i64 149, i64 151, i64 157, i64 163, i64 167, i64 173, i64 179, i64 181, i64 191, i64 193, i64 197, i64 199, i64 211, i64 223, i64 227, i64 229, i64 233, i64 239, i64 241, i64 251, i64 257, i64 263, i64 269, i64 271, i64 277, i64 281, i64 283, i64 293, i64 307, i64 311, i64 313, i64 317, i64 331, i64 337, i64 347, i64 349, i64 353, i64 359, i64 367, i64 373, i64 379, i64 383, i64 389, i64 397, i64 401, i64 409, i64 419, i64 421, i64 431, i64 433, i64 439, i64 443, i64 449, i64 457, i64 461, i64 463, i64 467, i64 479, i64 487, i64 491, i64 499, i64 503, i64 509, i64 521, i64 523, i64 541, i64 547, i64 557, i64 563, i64 569, i64 571, i64 577, i64 587, i64 593, i64 599, i64 601, i64 607, i64 613, i64 617, i64 619, i64 631, i64 641, i64 643, i64 647, i64 653, i64 659, i64 661, i64 673, i64 677, i64 683, i64 691, i64 701, i64 709, i64 719, i64 727, i64 733, i64 739, i64 743, i64 751, i64 757, i64 761, i64 769, i64 773, i64 787, i64 797, i64 809, i64 811, i64 821, i64 823, i64 827, i64 829, i64 839, i64 853, i64 857, i64 859, i64 863, i64 877, i64 881, i64 883, i64 887, i64 907, i64 911, i64 919, i64 929, i64 937, i64 941, i64 947, i64 953, i64 967, i64 971, i64 977, i64 983, i64 991, i64 997, i64 1009, i64 1013, i64 1019, i64 1021, i64 1031, i64 1033, i64 1039, i64 1049, i64 1051, i64 1061, i64 1063, i64 1069, i64 1087, i64 1091, i64 1093, i64 1097, i64 1103, i64 1109, i64 1117, i64 1123, i64 1129, i64 1151, i64 1153, i64 1163, i64 1171, i64 1181, i64 1187, i64 1193, i64 1201, i64 1213, i64 1217, i64 1223, i64 1229, i64 1231, i64 1237, i64 1249, i64 1259, i64 1277, i64 1279, i64 1283, i64 1289, i64 1291, i64 1297, i64 1301, i64 1303, i64 1307, i64 1319, i64 1321, i64 1327, i64 1361, i64 1367, i64 1373, i64 1381, i64 1399, i64 1409, i64 1423, i64 1427, i64 1429, i64 1433, i64 1439, i64 1447, i64 1451, i64 1453, i64 1459, i64 1471, i64 1481, i64 1483, i64 1487, i64 1489, i64 1493, i64 1499, i64 1511, i64 1523, i64 1531, i64 1543, i64 1549, i64 1553, i64 1559, i64 1567, i64 1571, i64 1579, i64 1583, i64 1597, i64 1601, i64 1607, i64 1609, i64 1613, i64 1619, i64 1621, i64 1627, i64 1637, i64 1657, i64 1663, i64 1667, i64 1669, i64 1693, i64 1697, i64 1699, i64 1709, i64 1721, i64 1723, i64 1733, i64 1741, i64 1747, i64 1753, i64 1759, i64 1777, i64 1783, i64 1787, i64 1789, i64 1801, i64 1811, i64 1823, i64 1831, i64 1847, i64 1861, i64 1867, i64 1871, i64 1873, i64 1877, i64 1879, i64 1889, i64 1901, i64 1907, i64 1913, i64 1931, i64 1933, i64 1949, i64 1951, i64 1973, i64 1979, i64 1987, i64 1993, i64 1997, i64 1999]
@.lty1321 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty1333 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty1344 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1416 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1416 = private global ptr null
@.lcd1416 = private unnamed_addr constant [1 x i64] [i64 2]
@.lty1418 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1418 = private global ptr null
@.lcd1418 = private unnamed_addr constant [1 x i64] [i64 3]
@.lty1420 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1420 = private global ptr null
@.lcd1420 = private unnamed_addr constant [1 x i64] [i64 5]
@.lty1422 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1422 = private global ptr null
@.lcd1422 = private unnamed_addr constant [1 x i64] [i64 7]
@.lty1424 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1424 = private global ptr null
@.lcd1424 = private unnamed_addr constant [1 x i64] [i64 11]
@.lty1426 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1426 = private global ptr null
@.lcd1426 = private unnamed_addr constant [1 x i64] [i64 13]
@.lty1428 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1428 = private global ptr null
@.lcd1428 = private unnamed_addr constant [1 x i64] [i64 17]
@.lty1430 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1430 = private global ptr null
@.lcd1430 = private unnamed_addr constant [1 x i64] [i64 19]
@.lty1432 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1432 = private global ptr null
@.lcd1432 = private unnamed_addr constant [1 x i64] [i64 23]
@.lty1434 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1434 = private global ptr null
@.lcd1434 = private unnamed_addr constant [1 x i64] [i64 29]
@.lty1436 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1436 = private global ptr null
@.lcd1436 = private unnamed_addr constant [1 x i64] [i64 31]
@.lty1438 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1438 = private global ptr null
@.lcd1438 = private unnamed_addr constant [1 x i64] [i64 37]
@.lty1440 = private unnamed_addr constant [20 x i8] c"List(List(Int(64)))\00"
@.oty1480 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox1480 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty1480}, align 16
@.lty1493 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1503 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1503 = private global ptr null
@.lcd1503 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1507 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1507 = private global ptr null
@.lcd1507 = private unnamed_addr constant [1 x i64] [i64 2]
@.lty1509 = private unnamed_addr constant [20 x i8] c"List(List(Int(64)))\00"
@.lty1517 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1517 = private global ptr null
@.lcd1517 = private unnamed_addr constant [1 x i64] [i64 2]
@.lty1519 = private unnamed_addr constant [20 x i8] c"List(List(Int(64)))\00"
@.lty1528 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1534 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1540 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1546 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1552 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1558 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1564 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1570 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1576 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1582 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1588 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1594 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1600 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.lty1642 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1648 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1654 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1660 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1666 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1672 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1678 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1684 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1690 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1696 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1702 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1708 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1714 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.oty1755 = private unnamed_addr constant [23 x i8] c"Option(List(UInt(64)))\00"
@.lty1770 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1793 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.oty1819 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox1819 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty1819}, align 16
@.oty1830 = private unnamed_addr constant [23 x i8] c"Option(List(UInt(64)))\00"
@.lty1842 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty1860 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1860 = private global ptr null
@.lcd1860 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1995 = private unnamed_addr constant [14 x i8] c"List(UInt(8))\00"
@.lty2202 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
declare <2 x i64> @llvm.x86.pclmulqdq(<2 x i64>, <2 x i64>, i8)
define linkonce_odr i128 @e.gf128(i128 %a, i128 %b) "target-features"="+pclmul,+sse2" "probe-stack"="inline-asm" {
entry:
  %av = bitcast i128 %a to <2 x i64>
  %bv = bitcast i128 %b to <2 x i64>
  %v00 = call <2 x i64> @llvm.x86.pclmulqdq(<2 x i64> %av, <2 x i64> %bv, i8 0)
  %v11 = call <2 x i64> @llvm.x86.pclmulqdq(<2 x i64> %av, <2 x i64> %bv, i8 17)
  %v10 = call <2 x i64> @llvm.x86.pclmulqdq(<2 x i64> %av, <2 x i64> %bv, i8 1)
  %v01 = call <2 x i64> @llvm.x86.pclmulqdq(<2 x i64> %av, <2 x i64> %bv, i8 16)
  %p00 = bitcast <2 x i64> %v00 to i128
  %p11 = bitcast <2 x i64> %v11 to i128
  %p10 = bitcast <2 x i64> %v10 to i128
  %p01 = bitcast <2 x i64> %v01 to i128
  %mid = xor i128 %p10, %p01
  %ml = shl i128 %mid, 64
  %mh = lshr i128 %mid, 64
  %lo = xor i128 %p00, %ml
  %hi = xor i128 %p11, %mh
  %hs = shl i128 %hi, 1
  %lc = lshr i128 %lo, 127
  %h2 = or i128 %hs, %lc
  %l2 = shl i128 %lo, 1
  %x0 = trunc i128 %l2 to i64
  %l2h = lshr i128 %l2, 64
  %x1 = trunc i128 %l2h to i64
  %ca = shl i64 %x0, 63
  %cb = shl i64 %x0, 62
  %cc = shl i64 %x0, 57
  %d1 = xor i64 %x1, %ca
  %d2 = xor i64 %d1, %cb
  %d = xor i64 %d2, %cc
  %dz = zext i64 %d to i128
  %dh = shl i128 %dz, 64
  %x0z = zext i64 %x0 to i128
  %dx = or i128 %dh, %x0z
  %e = lshr i128 %dx, 1
  %f = lshr i128 %dx, 2
  %g = lshr i128 %dx, 7
  %h1 = xor i128 %dx, %e
  %h3 = xor i128 %h1, %f
  %hh = xor i128 %h3, %g
  %r = xor i128 %h2, %hh
  ret i128 %r
}
@.lty2379 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc2379 = private global ptr null
@.lcd2379 = private unnamed_addr constant [64 x i64] [i64 1116352408, i64 1899447441, i64 3049323471, i64 3921009573, i64 961987163, i64 1508970993, i64 2453635748, i64 2870763221, i64 3624381080, i64 310598401, i64 607225278, i64 1426881987, i64 1925078388, i64 2162078206, i64 2614888103, i64 3248222580, i64 3835390401, i64 4022224774, i64 264347078, i64 604807628, i64 770255983, i64 1249150122, i64 1555081692, i64 1996064986, i64 2554220882, i64 2821834349, i64 2952996808, i64 3210313671, i64 3336571891, i64 3584528711, i64 113926993, i64 338241895, i64 666307205, i64 773529912, i64 1294757372, i64 1396182291, i64 1695183700, i64 1986661051, i64 2177026350, i64 2456956037, i64 2730485921, i64 2820302411, i64 3259730800, i64 3345764771, i64 3516065817, i64 3600352804, i64 4094571909, i64 275423344, i64 430227734, i64 506948616, i64 659060556, i64 883997877, i64 958139571, i64 1322822218, i64 1537002063, i64 1747873779, i64 1955562222, i64 2024104815, i64 2227730452, i64 2361852424, i64 2428436474, i64 2756734187, i64 3204031479, i64 3329325298]
@.lty2404 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2456 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc2456 = private global ptr null
@.lcd2456 = private unnamed_addr constant [8 x i64] [i64 1779033703, i64 3144134277, i64 1013904242, i64 2773480762, i64 1359893119, i64 2600822924, i64 528734635, i64 1541459225]
@.lty2459 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2483 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc2483 = private global ptr null
@.lcd2483 = private unnamed_addr constant [64 x i64] [i64 1116352408, i64 1899447441, i64 -1245643825, i64 -373957723, i64 961987163, i64 1508970993, i64 -1841331548, i64 -1424204075, i64 -670586216, i64 310598401, i64 607225278, i64 1426881987, i64 1925078388, i64 -2132889090, i64 -1680079193, i64 -1046744716, i64 -459576895, i64 -272742522, i64 264347078, i64 604807628, i64 770255983, i64 1249150122, i64 1555081692, i64 1996064986, i64 -1740746414, i64 -1473132947, i64 -1341970488, i64 -1084653625, i64 -958395405, i64 -710438585, i64 113926993, i64 338241895, i64 666307205, i64 773529912, i64 1294757372, i64 1396182291, i64 1695183700, i64 1986661051, i64 -2117940946, i64 -1838011259, i64 -1564481375, i64 -1474664885, i64 -1035236496, i64 -949202525, i64 -778901479, i64 -694614492, i64 -200395387, i64 275423344, i64 430227734, i64 506948616, i64 659060556, i64 883997877, i64 958139571, i64 1322822218, i64 1537002063, i64 1747873779, i64 1955562222, i64 2024104815, i64 -2067236844, i64 -1933114872, i64 -1866530822, i64 -1538233109, i64 -1090935817, i64 -965641998]
@.lty2554 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2575 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2589 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc2589 = private global ptr null
@.lcd2589 = private unnamed_addr constant [1 x i64] [i64 0]
@.lty2604 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2614 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc2614 = private global ptr null
@.lcd2614 = private unnamed_addr constant [1 x i64] [i64 128]
@.lty2665 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2674 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty2729 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2746 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2754 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2841 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2891 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3004 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
declare <4 x i32> @llvm.x86.sha256rnds2(<4 x i32>, <4 x i32>, <4 x i32>)
declare <4 x i32> @llvm.x86.sha256msg1(<4 x i32>, <4 x i32>)
declare <4 x i32> @llvm.x86.sha256msg2(<4 x i32>, <4 x i32>)
define linkonce_odr i256 @e.sha256(i256 %s, i512 %m) "target-features"="+sha,+sse4.1" "probe-stack"="inline-asm" {
entry:
%s0h = lshr i256 %s, 0
%s0i = trunc i256 %s0h to i128
%s0 = bitcast i128 %s0i to <4 x i32>
%s1h = lshr i256 %s, 128
%s1i = trunc i256 %s1h to i128
%s1 = bitcast i128 %s1i to <4 x i32>
%m0h = lshr i512 %m, 0
%m0i = trunc i512 %m0h to i128
%m0 = bitcast i128 %m0i to <4 x i32>
%m1h = lshr i512 %m, 128
%m1i = trunc i512 %m1h to i128
%m1 = bitcast i128 %m1i to <4 x i32>
%m2h = lshr i512 %m, 256
%m2i = trunc i512 %m2h to i128
%m2 = bitcast i128 %m2i to <4 x i32>
%m3h = lshr i512 %m, 384
%m3i = trunc i512 %m3h to i128
%m3 = bitcast i128 %m3i to <4 x i32>
  %a0 = shufflevector <4 x i32> %s0, <4 x i32> %s1, <4 x i32> <i32 5, i32 4, i32 1, i32 0>
  %c0 = shufflevector <4 x i32> %s0, <4 x i32> %s1, <4 x i32> <i32 7, i32 6, i32 3, i32 2>
  %wk0 = add <4 x i32> %m0, <i32 1116352408, i32 1899447441, i32 -1245643825, i32 -373957723>
  %x0 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %c0, <4 x i32> %a0, <4 x i32> %wk0)
  %k0 = shufflevector <4 x i32> %wk0, <4 x i32> %wk0, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z0 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %a0, <4 x i32> %x0, <4 x i32> %k0)
  %p0 = call <4 x i32> @llvm.x86.sha256msg1(<4 x i32> %m0, <4 x i32> %m1)
  %q0 = shufflevector <4 x i32> %m2, <4 x i32> %m3, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  %r0 = add <4 x i32> %p0, %q0
  %m4 = call <4 x i32> @llvm.x86.sha256msg2(<4 x i32> %r0, <4 x i32> %m3)
  %wk1 = add <4 x i32> %m1, <i32 961987163, i32 1508970993, i32 -1841331548, i32 -1424204075>
  %x1 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %x0, <4 x i32> %z0, <4 x i32> %wk1)
  %k1 = shufflevector <4 x i32> %wk1, <4 x i32> %wk1, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z1 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %z0, <4 x i32> %x1, <4 x i32> %k1)
  %p1 = call <4 x i32> @llvm.x86.sha256msg1(<4 x i32> %m1, <4 x i32> %m2)
  %q1 = shufflevector <4 x i32> %m3, <4 x i32> %m4, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  %r1 = add <4 x i32> %p1, %q1
  %m5 = call <4 x i32> @llvm.x86.sha256msg2(<4 x i32> %r1, <4 x i32> %m4)
  %wk2 = add <4 x i32> %m2, <i32 -670586216, i32 310598401, i32 607225278, i32 1426881987>
  %x2 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %x1, <4 x i32> %z1, <4 x i32> %wk2)
  %k2 = shufflevector <4 x i32> %wk2, <4 x i32> %wk2, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z2 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %z1, <4 x i32> %x2, <4 x i32> %k2)
  %p2 = call <4 x i32> @llvm.x86.sha256msg1(<4 x i32> %m2, <4 x i32> %m3)
  %q2 = shufflevector <4 x i32> %m4, <4 x i32> %m5, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  %r2 = add <4 x i32> %p2, %q2
  %m6 = call <4 x i32> @llvm.x86.sha256msg2(<4 x i32> %r2, <4 x i32> %m5)
  %wk3 = add <4 x i32> %m3, <i32 1925078388, i32 -2132889090, i32 -1680079193, i32 -1046744716>
  %x3 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %x2, <4 x i32> %z2, <4 x i32> %wk3)
  %k3 = shufflevector <4 x i32> %wk3, <4 x i32> %wk3, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z3 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %z2, <4 x i32> %x3, <4 x i32> %k3)
  %p3 = call <4 x i32> @llvm.x86.sha256msg1(<4 x i32> %m3, <4 x i32> %m4)
  %q3 = shufflevector <4 x i32> %m5, <4 x i32> %m6, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  %r3 = add <4 x i32> %p3, %q3
  %m7 = call <4 x i32> @llvm.x86.sha256msg2(<4 x i32> %r3, <4 x i32> %m6)
  %wk4 = add <4 x i32> %m4, <i32 -459576895, i32 -272742522, i32 264347078, i32 604807628>
  %x4 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %x3, <4 x i32> %z3, <4 x i32> %wk4)
  %k4 = shufflevector <4 x i32> %wk4, <4 x i32> %wk4, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z4 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %z3, <4 x i32> %x4, <4 x i32> %k4)
  %p4 = call <4 x i32> @llvm.x86.sha256msg1(<4 x i32> %m4, <4 x i32> %m5)
  %q4 = shufflevector <4 x i32> %m6, <4 x i32> %m7, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  %r4 = add <4 x i32> %p4, %q4
  %m8 = call <4 x i32> @llvm.x86.sha256msg2(<4 x i32> %r4, <4 x i32> %m7)
  %wk5 = add <4 x i32> %m5, <i32 770255983, i32 1249150122, i32 1555081692, i32 1996064986>
  %x5 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %x4, <4 x i32> %z4, <4 x i32> %wk5)
  %k5 = shufflevector <4 x i32> %wk5, <4 x i32> %wk5, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z5 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %z4, <4 x i32> %x5, <4 x i32> %k5)
  %p5 = call <4 x i32> @llvm.x86.sha256msg1(<4 x i32> %m5, <4 x i32> %m6)
  %q5 = shufflevector <4 x i32> %m7, <4 x i32> %m8, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  %r5 = add <4 x i32> %p5, %q5
  %m9 = call <4 x i32> @llvm.x86.sha256msg2(<4 x i32> %r5, <4 x i32> %m8)
  %wk6 = add <4 x i32> %m6, <i32 -1740746414, i32 -1473132947, i32 -1341970488, i32 -1084653625>
  %x6 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %x5, <4 x i32> %z5, <4 x i32> %wk6)
  %k6 = shufflevector <4 x i32> %wk6, <4 x i32> %wk6, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z6 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %z5, <4 x i32> %x6, <4 x i32> %k6)
  %p6 = call <4 x i32> @llvm.x86.sha256msg1(<4 x i32> %m6, <4 x i32> %m7)
  %q6 = shufflevector <4 x i32> %m8, <4 x i32> %m9, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  %r6 = add <4 x i32> %p6, %q6
  %m10 = call <4 x i32> @llvm.x86.sha256msg2(<4 x i32> %r6, <4 x i32> %m9)
  %wk7 = add <4 x i32> %m7, <i32 -958395405, i32 -710438585, i32 113926993, i32 338241895>
  %x7 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %x6, <4 x i32> %z6, <4 x i32> %wk7)
  %k7 = shufflevector <4 x i32> %wk7, <4 x i32> %wk7, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z7 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %z6, <4 x i32> %x7, <4 x i32> %k7)
  %p7 = call <4 x i32> @llvm.x86.sha256msg1(<4 x i32> %m7, <4 x i32> %m8)
  %q7 = shufflevector <4 x i32> %m9, <4 x i32> %m10, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  %r7 = add <4 x i32> %p7, %q7
  %m11 = call <4 x i32> @llvm.x86.sha256msg2(<4 x i32> %r7, <4 x i32> %m10)
  %wk8 = add <4 x i32> %m8, <i32 666307205, i32 773529912, i32 1294757372, i32 1396182291>
  %x8 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %x7, <4 x i32> %z7, <4 x i32> %wk8)
  %k8 = shufflevector <4 x i32> %wk8, <4 x i32> %wk8, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z8 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %z7, <4 x i32> %x8, <4 x i32> %k8)
  %p8 = call <4 x i32> @llvm.x86.sha256msg1(<4 x i32> %m8, <4 x i32> %m9)
  %q8 = shufflevector <4 x i32> %m10, <4 x i32> %m11, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  %r8 = add <4 x i32> %p8, %q8
  %m12 = call <4 x i32> @llvm.x86.sha256msg2(<4 x i32> %r8, <4 x i32> %m11)
  %wk9 = add <4 x i32> %m9, <i32 1695183700, i32 1986661051, i32 -2117940946, i32 -1838011259>
  %x9 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %x8, <4 x i32> %z8, <4 x i32> %wk9)
  %k9 = shufflevector <4 x i32> %wk9, <4 x i32> %wk9, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z9 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %z8, <4 x i32> %x9, <4 x i32> %k9)
  %p9 = call <4 x i32> @llvm.x86.sha256msg1(<4 x i32> %m9, <4 x i32> %m10)
  %q9 = shufflevector <4 x i32> %m11, <4 x i32> %m12, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  %r9 = add <4 x i32> %p9, %q9
  %m13 = call <4 x i32> @llvm.x86.sha256msg2(<4 x i32> %r9, <4 x i32> %m12)
  %wk10 = add <4 x i32> %m10, <i32 -1564481375, i32 -1474664885, i32 -1035236496, i32 -949202525>
  %x10 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %x9, <4 x i32> %z9, <4 x i32> %wk10)
  %k10 = shufflevector <4 x i32> %wk10, <4 x i32> %wk10, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z10 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %z9, <4 x i32> %x10, <4 x i32> %k10)
  %p10 = call <4 x i32> @llvm.x86.sha256msg1(<4 x i32> %m10, <4 x i32> %m11)
  %q10 = shufflevector <4 x i32> %m12, <4 x i32> %m13, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  %r10 = add <4 x i32> %p10, %q10
  %m14 = call <4 x i32> @llvm.x86.sha256msg2(<4 x i32> %r10, <4 x i32> %m13)
  %wk11 = add <4 x i32> %m11, <i32 -778901479, i32 -694614492, i32 -200395387, i32 275423344>
  %x11 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %x10, <4 x i32> %z10, <4 x i32> %wk11)
  %k11 = shufflevector <4 x i32> %wk11, <4 x i32> %wk11, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z11 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %z10, <4 x i32> %x11, <4 x i32> %k11)
  %p11 = call <4 x i32> @llvm.x86.sha256msg1(<4 x i32> %m11, <4 x i32> %m12)
  %q11 = shufflevector <4 x i32> %m13, <4 x i32> %m14, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  %r11 = add <4 x i32> %p11, %q11
  %m15 = call <4 x i32> @llvm.x86.sha256msg2(<4 x i32> %r11, <4 x i32> %m14)
  %wk12 = add <4 x i32> %m12, <i32 430227734, i32 506948616, i32 659060556, i32 883997877>
  %x12 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %x11, <4 x i32> %z11, <4 x i32> %wk12)
  %k12 = shufflevector <4 x i32> %wk12, <4 x i32> %wk12, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z12 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %z11, <4 x i32> %x12, <4 x i32> %k12)
  %wk13 = add <4 x i32> %m13, <i32 958139571, i32 1322822218, i32 1537002063, i32 1747873779>
  %x13 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %x12, <4 x i32> %z12, <4 x i32> %wk13)
  %k13 = shufflevector <4 x i32> %wk13, <4 x i32> %wk13, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z13 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %z12, <4 x i32> %x13, <4 x i32> %k13)
  %wk14 = add <4 x i32> %m14, <i32 1955562222, i32 2024104815, i32 -2067236844, i32 -1933114872>
  %x14 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %x13, <4 x i32> %z13, <4 x i32> %wk14)
  %k14 = shufflevector <4 x i32> %wk14, <4 x i32> %wk14, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z14 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %z13, <4 x i32> %x14, <4 x i32> %k14)
  %wk15 = add <4 x i32> %m15, <i32 -1866530822, i32 -1538233109, i32 -1090935817, i32 -965641998>
  %x15 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %x14, <4 x i32> %z14, <4 x i32> %wk15)
  %k15 = shufflevector <4 x i32> %wk15, <4 x i32> %wk15, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
  %z15 = call <4 x i32> @llvm.x86.sha256rnds2(<4 x i32> %z14, <4 x i32> %x15, <4 x i32> %k15)
  %n0 = shufflevector <4 x i32> %z15, <4 x i32> %x15, <4 x i32> <i32 3, i32 2, i32 7, i32 6>
  %n1 = shufflevector <4 x i32> %z15, <4 x i32> %x15, <4 x i32> <i32 1, i32 0, i32 5, i32 4>
  %ft0 = add <4 x i32> %s0, %n0
  %ft1 = add <4 x i32> %s1, %n1
  %fb0 = bitcast <4 x i32> %ft0 to i128
  %fb1 = bitcast <4 x i32> %ft1 to i128
  %fz0 = zext i128 %fb0 to i256
  %fz1 = zext i128 %fb1 to i256
  %fh1 = shl i256 %fz1, 128
  %fr = or i256 %fz0, %fh1
  ret i256 %fr
}
@.lty3159 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3297 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3400 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3410 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc3410 = private global ptr null
@.lcd3410 = private unnamed_addr constant [1 x i64] [i64 128]
@.lty3433 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc3433 = private global ptr null
@.lcd3433 = private unnamed_addr constant [8 x i64] [i64 1779033703, i64 -1150833019, i64 1013904242, i64 -1521486534, i64 1359893119, i64 -1694144372, i64 528734635, i64 1541459225]
@.lty3436 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.s3442 = private unnamed_addr constant [1 x i8] c"\00"
@.lty3462 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3475 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3481 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc3481 = private global ptr null
@.lcd3481 = private unnamed_addr constant [8 x i64] [i64 1779033703, i64 -1150833019, i64 1013904242, i64 -1521486534, i64 1359893119, i64 -1694144372, i64 528734635, i64 1541459225]
@.s3500 = private unnamed_addr constant [1 x i8] c"\00"
@.lty3507 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3530 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3544 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3550 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3562 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3578 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3588 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3591 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.s3678 = private unnamed_addr constant [2 x i8] c"+\00"
@.s3679 = private unnamed_addr constant [2 x i8] c"/\00"
@.lty3767 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3830 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3862 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3881 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3884 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3886 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3889 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3896 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3909 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3911 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.s3925 = private unnamed_addr constant [64 x i8] c"random: getrandom failed, and there is no randomness without it\00"
@.lty3928 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc3928 = private global ptr null
@.lcd3928 = private unnamed_addr constant [4 x i64] [i64 0, i64 0, i64 0, i64 32]
@.lty3944 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3963 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4087 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4087 = private global ptr null
@.lcd4087 = private unnamed_addr constant [160 x i64] [i64 1116352408, i64 3609767458, i64 1899447441, i64 602891725, i64 3049323471, i64 3964484399, i64 3921009573, i64 2173295548, i64 961987163, i64 4081628472, i64 1508970993, i64 3053834265, i64 2453635748, i64 2937671579, i64 2870763221, i64 3664609560, i64 3624381080, i64 2734883394, i64 310598401, i64 1164996542, i64 607225278, i64 1323610764, i64 1426881987, i64 3590304994, i64 1925078388, i64 4068182383, i64 2162078206, i64 991336113, i64 2614888103, i64 633803317, i64 3248222580, i64 3479774868, i64 3835390401, i64 2666613458, i64 4022224774, i64 944711139, i64 264347078, i64 2341262773, i64 604807628, i64 2007800933, i64 770255983, i64 1495990901, i64 1249150122, i64 1856431235, i64 1555081692, i64 3175218132, i64 1996064986, i64 2198950837, i64 2554220882, i64 3999719339, i64 2821834349, i64 766784016, i64 2952996808, i64 2566594879, i64 3210313671, i64 3203337956, i64 3336571891, i64 1034457026, i64 3584528711, i64 2466948901, i64 113926993, i64 3758326383, i64 338241895, i64 168717936, i64 666307205, i64 1188179964, i64 773529912, i64 1546045734, i64 1294757372, i64 1522805485, i64 1396182291, i64 2643833823, i64 1695183700, i64 2343527390, i64 1986661051, i64 1014477480, i64 2177026350, i64 1206759142, i64 2456956037, i64 344077627, i64 2730485921, i64 1290863460, i64 2820302411, i64 3158454273, i64 3259730800, i64 3505952657, i64 3345764771, i64 106217008, i64 3516065817, i64 3606008344, i64 3600352804, i64 1432725776, i64 4094571909, i64 1467031594, i64 275423344, i64 851169720, i64 430227734, i64 3100823752, i64 506948616, i64 1363258195, i64 659060556, i64 3750685593, i64 883997877, i64 3785050280, i64 958139571, i64 3318307427, i64 1322822218, i64 3812723403, i64 1537002063, i64 2003034995, i64 1747873779, i64 3602036899, i64 1955562222, i64 1575990012, i64 2024104815, i64 1125592928, i64 2227730452, i64 2716904306, i64 2361852424, i64 442776044, i64 2428436474, i64 593698344, i64 2756734187, i64 3733110249, i64 3204031479, i64 2999351573, i64 3329325298, i64 3815920427, i64 3391569614, i64 3928383900, i64 3515267271, i64 566280711, i64 3940187606, i64 3454069534, i64 4118630271, i64 4000239992, i64 116418474, i64 1914138554, i64 174292421, i64 2731055270, i64 289380356, i64 3203993006, i64 460393269, i64 320620315, i64 685471733, i64 587496836, i64 852142971, i64 1086792851, i64 1017036298, i64 365543100, i64 1126000580, i64 2618297676, i64 1288033470, i64 3409855158, i64 1501505948, i64 4234509866, i64 1607167915, i64 987167468, i64 1816402316, i64 1246189591]
@.lty4096 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4096 = private global ptr null
@.lcd4096 = private unnamed_addr constant [160 x i64] [i64 1116352408, i64 3609767458, i64 1899447441, i64 602891725, i64 3049323471, i64 3964484399, i64 3921009573, i64 2173295548, i64 961987163, i64 4081628472, i64 1508970993, i64 3053834265, i64 2453635748, i64 2937671579, i64 2870763221, i64 3664609560, i64 3624381080, i64 2734883394, i64 310598401, i64 1164996542, i64 607225278, i64 1323610764, i64 1426881987, i64 3590304994, i64 1925078388, i64 4068182383, i64 2162078206, i64 991336113, i64 2614888103, i64 633803317, i64 3248222580, i64 3479774868, i64 3835390401, i64 2666613458, i64 4022224774, i64 944711139, i64 264347078, i64 2341262773, i64 604807628, i64 2007800933, i64 770255983, i64 1495990901, i64 1249150122, i64 1856431235, i64 1555081692, i64 3175218132, i64 1996064986, i64 2198950837, i64 2554220882, i64 3999719339, i64 2821834349, i64 766784016, i64 2952996808, i64 2566594879, i64 3210313671, i64 3203337956, i64 3336571891, i64 1034457026, i64 3584528711, i64 2466948901, i64 113926993, i64 3758326383, i64 338241895, i64 168717936, i64 666307205, i64 1188179964, i64 773529912, i64 1546045734, i64 1294757372, i64 1522805485, i64 1396182291, i64 2643833823, i64 1695183700, i64 2343527390, i64 1986661051, i64 1014477480, i64 2177026350, i64 1206759142, i64 2456956037, i64 344077627, i64 2730485921, i64 1290863460, i64 2820302411, i64 3158454273, i64 3259730800, i64 3505952657, i64 3345764771, i64 106217008, i64 3516065817, i64 3606008344, i64 3600352804, i64 1432725776, i64 4094571909, i64 1467031594, i64 275423344, i64 851169720, i64 430227734, i64 3100823752, i64 506948616, i64 1363258195, i64 659060556, i64 3750685593, i64 883997877, i64 3785050280, i64 958139571, i64 3318307427, i64 1322822218, i64 3812723403, i64 1537002063, i64 2003034995, i64 1747873779, i64 3602036899, i64 1955562222, i64 1575990012, i64 2024104815, i64 1125592928, i64 2227730452, i64 2716904306, i64 2361852424, i64 442776044, i64 2428436474, i64 593698344, i64 2756734187, i64 3733110249, i64 3204031479, i64 2999351573, i64 3329325298, i64 3815920427, i64 3391569614, i64 3928383900, i64 3515267271, i64 566280711, i64 3940187606, i64 3454069534, i64 4118630271, i64 4000239992, i64 116418474, i64 1914138554, i64 174292421, i64 2731055270, i64 289380356, i64 3203993006, i64 460393269, i64 320620315, i64 685471733, i64 587496836, i64 852142971, i64 1086792851, i64 1017036298, i64 365543100, i64 1126000580, i64 2618297676, i64 1288033470, i64 3409855158, i64 1501505948, i64 4234509866, i64 1607167915, i64 987167468, i64 1816402316, i64 1246189591]
@.lty4110 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4110 = private global ptr null
@.lcd4110 = private unnamed_addr constant [16 x i64] [i64 1779033703, i64 3144134277, i64 1013904242, i64 2773480762, i64 1359893119, i64 2600822924, i64 528734635, i64 1541459225, i64 4089235720, i64 2227873595, i64 4271175723, i64 1595750129, i64 2917565137, i64 725511199, i64 4215389547, i64 327033209]
@.lty4119 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4126 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4136 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4136 = private global ptr null
@.lcd4136 = private unnamed_addr constant [1 x i64] [i64 128]
@.lty4162 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4245 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4260 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty4350 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4357 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4367 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4367 = private global ptr null
@.lcd4367 = private unnamed_addr constant [16 x i64] [i64 1779033703, i64 4089235720, i64 3144134277, i64 2227873595, i64 1013904242, i64 4271175723, i64 2773480762, i64 1595750129, i64 1359893119, i64 2917565137, i64 2600822924, i64 725511199, i64 528734635, i64 4215389547, i64 1541459225, i64 327033209]
@.lty4472 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4556 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
declare void @llvm.trap()
define linkonce_odr i512 @e.sha512(i512 %s, i512 %lo, i512 %hi) "probe-stack"="inline-asm" {
entry:
  call void @llvm.trap()
  ret i512 %s
}
@.lty5032 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5050 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc5050 = private global ptr null
@.lcd5050 = private unnamed_addr constant [1 x i64] [i64 128]
@.lty5074 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5081 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5088 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5095 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5104 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty5183 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5226 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5274 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5318 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty5393 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5433 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5453 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc5453 = private global ptr null
@.lcd5453 = private unnamed_addr constant [5 x i64] [i64 1732584193, i64 4023233417, i64 2562383102, i64 271733878, i64 3285377520]
@.lty5456 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty5460 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc5460 = private global ptr null
@.lcd5460 = private unnamed_addr constant [9 x i64] [i64 67, i64 77, i64 80, i64 45, i64 66, i64 76, i64 65, i64 75, i64 69]
@.lty5462 = private unnamed_addr constant [20 x i8] c"List(List(Int(64)))\00"
@.lty5475 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5522 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5539 = private unnamed_addr constant [20 x i8] c"List(List(Int(64)))\00"
@.s5547 = private unnamed_addr constant [7 x i8] c"[]byte\00"
@.s5549 = private unnamed_addr constant [8 x i8] c"big.Int\00"
@.lty5550 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc5550 = private global ptr null
@.lcd5550 = private unnamed_addr constant [1 x i64] [i64 2]
@.s5556 = private unnamed_addr constant [18 x i8] c"*saferith.Modulus\00"
@.lty5561 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5585 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5593 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5673 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc5673 = private global ptr null
@.lcd5673 = private unnamed_addr constant [1 x i64] [i64 1]
@.s5697 = private unnamed_addr constant [20 x i8] c"Pedersen Parameters\00"
@.oty5724 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox5724 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty5724}, align 16
@.oty5736 = private unnamed_addr constant [15 x i8] c"Option(ZkDraw)\00"
@.lty5778 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc5778 = private global ptr null
@.lcd5778 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty5827 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.oty5828 = private unnamed_addr constant [29 x i8] c"Option(List(List(UInt(64))))\00"
@.lty5851 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.oty5852 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox5852 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty5852}, align 16
@.lty5855 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.lty5869 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.oty5897 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox5897 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty5897}, align 16
@.oty5903 = private unnamed_addr constant [17 x i8] c"Option(PrmProof)\00"
@.lty5925 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.lty5975 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty6021 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6021 = private global ptr null
@.lcd6021 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty6026 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6032 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6038 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6044 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6050 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6056 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6062 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6068 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6074 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6080 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6086 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6092 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6098 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.lty6155 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6155 = private global ptr null
@.lcd6155 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty6164 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6164 = private global ptr null
@.lcd6164 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty6173 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty6184 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.oty6193 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox6193 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty6193}, align 16
@.oty6207 = private unnamed_addr constant [15 x i8] c"Option(ZkDraw)\00"
@.lty6217 = private unnamed_addr constant [18 x i8] c"List(ModResponse)\00"
@.s6241 = private unnamed_addr constant [10 x i8] c"mod: n ok\00"
@.oty6247 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox6247 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty6247}, align 16
@.oty6255 = private unnamed_addr constant [17 x i8] c"Option(ModProof)\00"
@.lty6259 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6259 = private global ptr null
@.lcd6259 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty6262 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6262 = private global ptr null
@.lcd6262 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty6266 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6266 = private global ptr null
@.lcd6266 = private unnamed_addr constant [1 x i64] [i64 4]
@.lty6279 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.s6282 = private unnamed_addr constant [10 x i8] c"mod: w ok\00"
@.s6285 = private unnamed_addr constant [11 x i8] c"mod: ys ok\00"
@.oty6296 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox6296 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty6296}, align 16
@.oty6304 = private unnamed_addr constant [15 x i8] c"Option(ZkDraw)\00"
@.lty6314 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6314 = private global ptr null
@.lcd6314 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty6318 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6318 = private global ptr null
@.lcd6318 = private unnamed_addr constant [1 x i64] [i64 1]
@.oty6328 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox6328 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty6328}, align 16
@.oty6339 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox6339 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty6339}, align 16
@.oty6349 = private unnamed_addr constant [20 x i8] c"Option(PedersenKey)\00"
@.lty6897 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty7196 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty7279 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty7326 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7385 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7442 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7461 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty7728 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7736 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7770 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty7789 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7800 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7810 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7822 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7832 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7841 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.ltyB7917 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty8010 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.ltyB8018 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty8021 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8021 = private global ptr null
@.lcd8021 = private unnamed_addr constant [12 x i64] [i64 132, i64 106, i64 83, i64 105, i64 103, i64 110, i64 97, i64 116, i64 117, i64 114, i64 101, i64 49]
@.lty8024 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty8030 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8030 = private global ptr null
@.lcd8030 = private unnamed_addr constant [4 x i64] [i64 162, i64 1, i64 39, i64 4]
@.ltyB8033 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.s8035 = private unnamed_addr constant [1 x i8] c"\00"
@.s8045 = private unnamed_addr constant [1 x i8] c"\00"
@.s8052 = private unnamed_addr constant [1 x i8] c"\00"
@.s8057 = private unnamed_addr constant [1 x i8] c"\00"
@.s8064 = private unnamed_addr constant [1 x i8] c"\00"
@.s8083 = private unnamed_addr constant [1 x i8] c"\00"
@.s8110 = private unnamed_addr constant [1 x i8] c"\00"
@.s8146 = private unnamed_addr constant [21 x i8] c"cose: missing tag 18\00"
@.s8164 = private unnamed_addr constant [24 x i8] c"cose: expected array(4)\00"
@.s8172 = private unnamed_addr constant [27 x i8] c"cose: bad protected header\00"
@.s8190 = private unnamed_addr constant [37 x i8] c"cose: expected empty unprotected map\00"
@.s8198 = private unnamed_addr constant [18 x i8] c"cose: bad payload\00"
@.s8212 = private unnamed_addr constant [20 x i8] c"cose: bad signature\00"
@.s8215 = private unnamed_addr constant [1 x i8] c"\00"
@.lty8234 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty8236 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8236 = private global ptr null
@.lcd8236 = private unnamed_addr constant [10 x i64] [i64 131, i64 104, i64 69, i64 110, i64 99, i64 114, i64 121, i64 112, i64 116, i64 48]
@.lty8240 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8240 = private global ptr null
@.lcd8240 = private unnamed_addr constant [4 x i64] [i64 161, i64 1, i64 24, i64 24]
@.lty8242 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8242 = private global ptr null
@.lcd8242 = private unnamed_addr constant [25 x i64] [i64 114, i64 101, i64 115, i64 105, i64 100, i64 47, i64 99, i64 111, i64 115, i64 101, i64 47, i64 101, i64 110, i64 99, i64 114, i64 121, i64 112, i64 116, i64 48, i64 47, i64 110, i64 111, i64 110, i64 99, i64 101]
@.lty8253 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8253 = private global ptr null
@.lcd8253 = private unnamed_addr constant [16 x i64] [i64 131, i64 104, i64 69, i64 110, i64 99, i64 114, i64 121, i64 112, i64 116, i64 48, i64 68, i64 161, i64 1, i64 24, i64 24, i64 64]
@.lty8257 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8257 = private global ptr null
@.lcd8257 = private unnamed_addr constant [9 x i64] [i64 208, i64 131, i64 68, i64 161, i64 1, i64 24, i64 24, i64 161, i64 5]
@.ltyB8261 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.s8290 = private unnamed_addr constant [21 x i8] c"cose: missing tag 16\00"
@.s8308 = private unnamed_addr constant [24 x i8] c"cose: expected array(3)\00"
@.s8316 = private unnamed_addr constant [27 x i8] c"cose: bad protected header\00"
@.s8334 = private unnamed_addr constant [34 x i8] c"cose: expected unprotected map(1)\00"
@.s8352 = private unnamed_addr constant [24 x i8] c"cose: expected iv key 5\00"
@.s8366 = private unnamed_addr constant [26 x i8] c"cose: iv must be 12 bytes\00"
@.s8380 = private unnamed_addr constant [21 x i8] c"cose: bad ciphertext\00"
@.s8393 = private unnamed_addr constant [28 x i8] c"cose: authentication failed\00"
@.s8403 = private unnamed_addr constant [1 x i8] c"\00"
@resid.cap.main = unnamed_addr constant [5 x i8] c"args\00"
@resid.cap.main.1 = unnamed_addr constant [5 x i8] c"args\00"
@resid.cap.main.2 = unnamed_addr constant [5 x i8] c"args\00"
@.ltyB8487 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty8702 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.oty8735 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox8735 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty8735}, align 16
@.oty8756 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox8756 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty8756}, align 16
@.oty8759 = private unnamed_addr constant [18 x i8] c"Option(List(Int))\00"
@.lty8795 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8840 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8919 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9013 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty9047 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9139 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9180 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.ltyB9218 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty9219 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9225 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc9225 = private global ptr null
@.lcd9225 = private unnamed_addr constant [1 x i64] [i64 0]
@.lty9267 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9289 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9387 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9564 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9673 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10381 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10782 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10784 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.s10795 = private unnamed_addr constant [28 x i8] c"bn_divmod: division by zero\00"
@.lty10797 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.ltyE10806 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10809 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10827 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10837 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10847 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10857 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10867 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10877 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10887 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10897 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.s11207 = private unnamed_addr constant [1 x i8] c"\00"
@.lty11215 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11224 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11235 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11260 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11270 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11280 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11290 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11300 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11310 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11320 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11330 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11438 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
declare i8 @resid_secret_mode_set(i1)
define i32 @main() "probe-stack"="inline-asm" {
entry:
  %sm = call i8 @resid_secret_mode_set(i1 true)
  %r = call i32 @resid_run_main(ptr @resid_user_main)
  ret i32 %r
}
declare void @resid_start(ptr, ptr)
define void @_start() naked noinline nounwind {
  call void asm sideeffect "xor %ebp, %ebp\0Amov %rsp, %rdi\0Alea _DYNAMIC(%rip), %rsi\0Aand $$-16, %rsp\0Acall resid_start\0Acall main\0Amov %eax, %edi\0Amov $$231, %eax\0Asyscall\0Ahlt", "~{memory}"()
  unreachable
}
@llvm.compiler.used = appending global [2 x ptr] [ptr @main, ptr @resid_start], section "llvm.metadata"
